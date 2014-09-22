function send_post(obj){
    var form = $(obj).parents("form");
    var title = $.trim($(form).find("input[name='post[title]']").val());
    if(title == ""){
        alert("标题不能为空！");
        return false;
    }
    if(title.length > 30){
        alert("标题长度不能大于30！");
        return false;
    }
    var content = $.trim($(form).find("textarea[name='post[content]']").val());
    if(content == ""){
        alert("内容不能为空！");
        return false;
    }
    var tag = $.trim($(form).find("input[name='post[tags]']").val());
    if(tag == ""){
        alert("标签内容不能为空！");
        return false;
    }
    if(tag.split(";").length >4){
        alert("标签不能大于3个！");
        return false;
    }
    form.submit();

}

function create_reply(obj){
    var form = $(obj).parents("form");
    var content = form.find("#k_editor_id").val();
    if(content.length>150){
        alert("内容长度不能大于150！");
        return false;
    }
    if($.trim(content).length==0){
        alert("回复内容不能为空！");
        return false;
    }
    form.submit();
}
function  show_reply(obj,reply_id,target_user_id,reply_type){

    $(".tab_mess").show();
    $(".tab_mess").find("input[name=reply_id]").val(reply_id);
    $(".tab_mess").find("input[name=reply_type]").val(reply_type);
    $(".tab_mess").find("input[name=target_user_id]").val(target_user_id);
    $(".tab_mess").css({
        "top":($(obj).offset().top+20)+"px",
        "left":($(obj).offset().left-150)+"px"
    })
}

function cancle_this_window(obj){
    $($(obj).parents(".tab_mess")[0]).hide(10);
}

function commit_reply(obj){
    var content = $.trim($("#reply_text_area").val());
    var reply_type = $(".tab_mess").find("input[name=reply_type]").val();
    var reply_id = $(".tab_mess").find("input[name=reply_id]").val();
    if(content==""){
        alert("内容不能为空！");
        return false;
    }
    if(content.length>150){
        alert("长度不能大于150！");
        return false;
    }
        
    var form_data = $(".tab_mess").find("form").serialize();
    $.ajax({
        type:'post',
        url:"/posts/"+reply_id+"/create_reply_again",
        data:form_data,
        dataType:'text',
        success:function(data){
            if(data == 1){
                location.reload();
            }
        }
    });
}

function show_messages()
{
    $.ajax({
        url:"/messages/show_messages",
        dataType:"text",
        success:function(data){
            $("#message_count").text(data);
            if(data!='0'){
                $("#message_count").addClass('change-red');
            }else{
                $("#message_count").removeClass('change-red');
            }
        }
    });
   
    setTimeout("show_messages()",60000);
}


function show_recommend(){
    $.ajax({
        url:"/messages/user_recommend",
        dataType:"json",
        success:function(data){
            if(data.commend_posts.length > 0){
                $("#recommend_post").html("");
                $.each(data.commend_posts, function(key,value){
                    var i='';
                    if(value.cream==1){
                        i='<i class="icon small_cert_on" title="精华贴"></i>';
                    }
                    var str = "<li><a data-no-turbolink href='/posts/"+value.id+"'>"+value.title+"</a>"+i+"</li>"
                    $("#recommend_post").append(str);
                });
            }

        }

    });
}
function show_k_means(){
    $.ajax({
        url:"/messages/k_means",
        dataType:"json",
        success:function(data){
            $("#all_like_post").html("");
            $.each(data.all_like_posts, function(key,value){
                var i='';
                if(value.cream==1){
                    i='<i class="icon small_cert_on" title="精华贴"></i>';
                }
                var str = "<li><a data-no-turbolink href='/posts/"+value.id+"'>"+value.title+"</a>"+i+"</li>"
                $("#all_like_post").append(str);
            });
        }
    });
}

function show_node_list(obj){
    
    if($(obj).parent().find(".node_area").css("display")=='none'){
        $(".node_list").find(".node_area").hide();
        $(obj).parent().find(".node_area").show(100);
    }else{
        $(obj).parent().find(".node_area").hide(100);
    }
   
}

 