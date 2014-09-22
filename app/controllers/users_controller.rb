#encoding:utf-8
class UsersController < ApplicationController
  layout 'session'
  before_action :get_nodes
  before_action :signed_in_user?
  skip_before_action :signed_in_user?, :only => [:new,:create]
  skip_before_filter :verify_authenticity_token, :only => [:upload_avatar]
  def new
  end

  def create
    user = User.new(user_params)
    if user.save
      flash[:success] = '注册成功！'
      sign_in(user)
      redirect_back_or sessions_path
    else
      flash[:error] = '注册失败!用户名或邮箱已经存在！'
      render 'new'
    end
  end

  def update
    if current_user.update_attributes(
        name:params[:user_name],
        email:params[:user_email],
        qq:params[:user_qq],
        sex:params[:user_sex],
        website:params[:user_website],
        location:params[:city_name],
        remark:params[:user_remark]
      )
      flash[:success] = '更新个人资料成功'
    else
      flash[:error] = '更新个人资料失败'
    end
    redirect_to client_info_clients_path
  end

  def change_pwd
    user = current_user
    past_pwd = params[:old_pwd]

    if !past_pwd.nil? && user.authenticate(past_pwd)
      user.update_attribute(:password_digest,BCrypt::Password.create( params[:new_pwd].strip))
      flash[:success] = "密码修改成功"
    elsif past_pwd!=""
      flash[:success] = "原密码有误，密码修改失败"
    end
    redirect_to client_info_clients_path
  end

  def destroy_user
    sign_out
    flash[:success] = '退出成功！'
    redirect_to root_path
  end
  
  def upload_avatar
    file_upload = params[:file_upload]
    if !file_upload.nil?
      if file_upload.size > 1048576
        @status = "imgbig"
        @src = ""
      else
        img = MiniMagick::Image.read(file_upload)
        img.format("jpg") if file_upload.content_type =~ /gif|png$/i   #把别的格式改为jpg
        destination_dir = "avatars/users/#{Time.now.strftime('%Y-%m')}"
        rename_file_name = "user_#{current_user.id}"
        FileUtils.mkdir_p("#{Rails.root}/public/#{destination_dir}") if !Dir.exist? ("#{Rails.root}/public/#{destination_dir}")
        img.write "#{Rails.root}/public/#{destination_dir}/#{rename_file_name}.jpg"
        @status = "true"
        @src = "/#{destination_dir}/#{rename_file_name}.jpg"
      end
    else
      @status = "false"
      @src = ""
    end
  end
  
  def update_avatar
    avatar_url = current_user.avatar_url
    x_p =params[:x]
    y_p =params[:y]
    width = params[:w]
    height = params[:h]
    new_width = 0
    new_height = 0
    file_path = "#{Rails.root}/public/avatars/users/#{Time.now.strftime('%Y-%m')}/user_#{current_user.id}.jpg"
    img  = MiniMagick::Image.open(file_path)
    
    User::SCREENSHOT_SIZE.each do |size|
      resize = size>img["width"] ? img["width"] :size
      if avatar_url.eql?(User::TEAVHER_URL)
        file_paths = "#{Rails.root}/public/avatars/users/#{Time.now.strftime('%Y-%m')}/user_#{current_user.id}_1.jpg"
        avatar_url = "/avatars/users/#{Time.now.strftime('%Y-%m')}/user_#{current_user.id}_1.jpg"
      else
        index_name = avatar_url.split("_")[2]
        index_a = index_name.split(".")[0].to_i + 1
        file_used_paths = "#{Rails.root}/public#{avatar_url}"
        File.delete file_used_paths  if File.exist?(file_used_paths)
        file_paths = "#{Rails.root}/public/avatars/users/#{Time.now.strftime('%Y-%m')}/user_#{current_user.id}_#{index_a}.jpg"
        avatar_url = "/avatars/users/#{Time.now.strftime('%Y-%m')}/user_#{current_user.id}_#{index_a}.jpg"
      end
      if size<img["width"]
        w=(params[:w].to_i)
        h=(params[:h].to_i>img["height"]? img["height"]:params[:h].to_i)
        x=(params[:x].to_i)
        y=(params[:y].to_i)
        img.run_command("convert #{file_path} -crop #{w}x#{h}+#{x}+#{y} #{file_paths}")
      else
        img.run_command("convert #{file_path} -crop #{size}x#{size}+#{0}+#{0} #{file_paths}")
      end
      # new_file = file_path.split(".")[0]+"_"+resize.to_s+"."+ file_path.split(".").reverse[0]
      #imgs  = MiniMagick::Image.open(new_file)
      #imgs.run_command("convert #{new_file} -crop #{w}x#{h}+#{x}+#{y} #{file_paths}")
    end
    if current_user.update_attribute(:avatar_url , avatar_url)
      flash[:notice] = "操作成功!"
      redirect_to root_path
    else
      redirect_to root_path
    end

  end

  def freeze_user
    user = User.find_by_id(params[:id])
    msg=""
    if user
      if user.status
        user.update_attribute(:status,User::STATUS[:normal])
        msg='冻结该会员'
      else
        user.update_attribute(:status,User::STATUS[:freezn])
        msg='解冻该会员'
      end
    end
    render text:msg
  end

  private
  def user_params
    params.require(:users).permit(:name,:password,:password_confirmation,:email,:qq)
  end
end
