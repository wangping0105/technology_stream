class MessagesController < ApplicationController
  skip_before_action :end_calculate_time,only:[:show_messages,:user_recommend,:k_means]
  before_action :get_nodes,:signed_in_user?
  skip_before_action :signed_in_user?,only:[:show_messages,:user_recommend,:k_means]



  def empting_messages
    Message.where("target_user_id = ? ",current_user.id).destroy_all
    redirect_to show_messages_page_messages_path
  end

  def show_messages_page
    @messages = Message.where("target_user_id = ? ",current_user.id).order(created_at: :desc).
      select("messages.id,messages.user_id,messages.target_user_id,messages.content,
      messages.post_id,messages.status,messages.types,messages.created_at,messages.updated_at,
      p.title post_title,u.name user_name,u.avatar_url").
      joins("inner join posts p on p.id = messages.post_id ").
      joins("inner join users u on messages.user_id=u.id")

  end
  def show_messages
    if current_user
      count = Message.where("target_user_id = ? and status = 0",current_user.id)
      render text:count.length
    else
      render text:0
    end
  end

  def user_recommend
    if current_user
      sql = " select urr.id,urr.user_id,urr.post_id,urr.times,c.created_at collection,p.created_at praise, a.created_at attent from user_read_records urr
            left join collections c on urr.post_id=c.post_id
            left join praises p on urr.post_id = p.post_id left join attentions a on a.post_id = urr.post_id
    where urr.user_id = #{current_user.id}"
      user_record1 = UserReadRecord.find_by_sql(sql)
      max =0;
      user_record =[]
      post_ids = []
      user_record1 =user_record1.group_by{|s| s.user_id}
      user_record1.each do |k,v|
        post_ids = []
        v.each do |u|
          unless post_ids.include?(u.post_id)
            post_ids << u.post_id
            user_record << u
          end
        end
      end
      user_record.each do |ur|
        if ur.times>max
          max = ur.times
        end
      end
      arr =[]
      user_record.each do |ur|
        arr_t =[]
        arr_t<<ur.user_id<<ur.post_id
        post_ids << ur.post_id
        c = ur.collection.nil? ? 0 : 1
        p = ur.praise.nil? ? 0 : 1
        a = ur.attent.nil? ? 0 : 1
        score = c+p+a+ur.times*2/max
        arr_t<<score
        arr << arr_t
      end
      tags = Tag.select("tags.id,tags.content,tpr.post_id").
        joins("inner join tags_post_relations tpr on tags.id = tpr.tag_id").
        where("tpr.post_id in (?)",post_ids)
      taghash = {}
      tags.each do |tag|
        arr.each do |a|
          if a[1] == tag.post_id
            if taghash[tag.id].nil?
              taghash[tag.id]=a[2]
            else
              taghash[tag.id] = (taghash[tag.id]+a[2])/2
            end
            # p "a[1]=#{a[1]},tag.post_id=#{tag.post_id},a[2]=#{a[2]},taghash[#{tag.id}]=#{taghash[a[1]]}"
          end
        end
      end
      #p taghash
      tags_paxu =[]
      (0...taghash.length).each do |i|
        tags_paxu[i]=0
        taghash.each do |tag|
          if tag[1]>tags_paxu[i]
            tags_paxu[i]=tag[0]
          end
        end
        taghash[tags_paxu[i]]=-1
      end
      @recommend_posts =[]
      tags_paxu.each do|tag_id|
        commend_posts = TagsPostRelation.select("p.id id,p.title title,p.cream cream").
          where("tag_id = ?",tag_id).order("tags_post_relations.created_at DESC").
          joins("inner join posts p on p.id = tags_post_relations.post_id")
        post_id_repeat = []
        commend_posts.each do |commend_post|
          unless post_ids.include?(commend_post.id)
            unless post_id_repeat.include?(commend_post.id)
              post_id_repeat<<commend_post.id
              @recommend_posts << commend_post
            end
          end
          if @recommend_posts.length>4
            break;
          end
        end
        unless @recommend_posts.blank?
          break;
        end
      end
      if @recommend_posts.blank?
        @recommend_posts = Post.all.limit(4).where("id!=#{current_user.id}").order("created_at desc")
      end
      #p 111111111, post_ids,@recommend_posts
      render json:{:commend_posts=>@recommend_posts}
    else
      render json:{}
    end
  end


  def k_means
    require 'kmeans/pair'
    require 'kmeans/pearson'
    require 'kmeans/cluster'
    date = Time.now.prev_month.strftime("%y-%m-%d")
    sql = " select urr.id,urr.user_id,urr.post_id,urr.times,c.created_at collection,p.created_at praise, a.created_at attent from user_read_records urr
            left join collections c on urr.post_id=c.post_id
            left join praises p on urr.post_id = p.post_id left join attentions a on a.post_id = urr.post_id
            where urr.created_at > #{date}
    "
    user_record = UserReadRecord.find_by_sql(sql)
    max =0;
    
    user_record1 =[]
    user_record =user_record.group_by{|s| s.user_id}
    user_record.each do |k,v|
      post_ids = []
      v.each do |u|
        unless post_ids.include?(u.post_id)
          post_ids << u.post_id
          user_record1 << u
        end
      end
    end
    user_record1.each do |ur|
      if ur.times>max
        max = ur.times
      end
    end
    arr =[]

    user_record1.each do |ur|
      arr_t =[]
      arr_t<<ur.user_id<<ur.post_id
      c = ur.collection.nil? ? 0 : 1
      p = ur.praise.nil? ? 0 : 1
      a = ur.attent.nil? ? 0 : 1
      score = c+p+a+ur.times*2/max
      arr_t<<score
      arr << arr_t
    end
    #用户=>{帖子=>评分}
    
    hash ={}
    a=arr.group_by{|s| s[0]}
    a.each do |a,v|
      hash_t = {}
      v.each do |item|
        hash_t[item[1]] = item[2]
      end
      hash[a] =hash_t
    end
    #k-means算法聚类
    kmeans = Kmeans::Cluster.new(hash, {
        :centroids => 5,
        :loop_max => 100
      })

    # Kmeans Clustering
    kmeans.make_cluster
    # The results differ for each run
    user_ids = kmeans.cluster.values
    
    max_user_group =[]
    user_ids.each do |u|
      if u.length>max_user_group.length
        max_user_group =u
      end
    end
    #得到聚类用户
    hash_post ={}
    hash.each do |u|
      if max_user_group.include?(u[0])
        u[1].each do |post|
          hash_post[post[0]]||=[]
          hash_post[post[0]]<< post[1]
        end
      end
    end
   
    #求出平均值
    hash_post.each do |hp|
      s= (eval hp[1].join('+'))/hp[1].length
      hash_post[hp[0]] = s
    end
    hash_post.each do |a|
     # p a
    end
    #给帖子hash排序
    hash_paixu = []
    i=0
    hash_post.each do |hh|
      max_v =0.0
      max_ph = 0
      hash_post.each do |hp|
        if hp[1]>max_v
          max_v = hp[1]
          max_ph = hp[0]
        end
      end
      hash_paixu[i] = max_ph
      hash_post[max_ph]=-1
      i+=1
    end
    if hash_paixu.length>4
      hash_paixu = [hash_paixu[0],hash_paixu[1],hash_paixu[2],hash_paixu[3]]
    end
    @all_like_posts =Post.where("id in (?)",hash_paixu).limit(4)
    render json:{:all_like_posts => @all_like_posts}
  end
  
  def creat_1000_user
    (2..340).each do|i|
      user = User.create(name:"test_#{i}",email:"test#{i}@qq.com",qq:"21323#{i}",password:111111,password_confirmation:111111)
      post = Post.new do |p|
        p.title = "test_title_#{i}"
        p.node_id = i%34
        p.content = "content_#{i}"
        p.user_id = user.id
        p.status = Post::STATUS[:nomal]
        p.replies_count = 0
        p.collections_count = 0
        p.praises_count = 0
        p.attentions_count = 0
      end
      post.save
      
    end
  end

  def create_100_tag
  

  end


end