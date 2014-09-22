function submit_user_form(obj){
    if( check()){
        $(obj).parent().submit();
    }
    
    
}

function address_search_city(obj){
    var provincecode = $(obj).val();
    $.ajax({
        type: "get",
        dataType: "json",
        url: "/clients/search_citties",
        data: {
            provincecode : provincecode
        },
        success: function(data){
            if(data.cities.length > 0){
                $("#city_id").empty();
                $("#city_id").append("<option value='0'>-------</option>");
                $.each(data.cities, function(key,value){
                    $("#city_id").append("<option value='"+value.code+"'>"+value.name+"</option>");
                });
            }else{
                $("#city_id").empty();
                $("#city_id").html("<option value='0'>当前省份无城市</option>");
            }
        },
        error: function(data){
            alert("数据错误!");
        }
    })
}

function submit_user_info_submit(){
    var user_name = $("#user_info_form").find("input[name=user_name]").val();
    if(($.trim(user_name).length)==0){
      alert('用户名不能为空');
      return false;
    }
    if(($.trim(user_name).length)>12){
      alert('用户名长度小于12');
      return false;
    }
    var user_qq = $("#user_info_form").find("input[name=user_qq]").val();
    var phoneReg =/^[0-9]*$/;
    if(!$.trim(user_qq).match(phoneReg)){
      alert('qq请输入数字');
      return false;
    }
    if(user_qq.length>10){
      alert('qq不能大于10位');
      return false;
    }
    var user_website = $("#user_info_form").find("input[name=user_website]");
    var city_name = $("#user_info_form").find("#city_id").val();
    if(($.trim(city_name))== 0){
      alert('请选择城市');
      return false;
    }
    var user_remark = $("#user_info_form").find("input[name=user_remark]");
    if(($.trim(user_remark).length)>250){
      alert('用户名长度小于250');
      return false;
    }
    $("#user_info_form").submit();
}
function submit_pwd(obj){
    var old_pwd = $("#user_info_pwd_form").find("input[name=old_pwd]").val();
    if($.trim(old_pwd)==""){
        alert("原密码不能为空");
        return false;
    }
    var new_pwd = $("#user_info_pwd_form").find("input[name=new_pwd]").val();
    var com_new_pwd = $("#user_info_pwd_form").find("input[name=com_new_pwd]").val();
    if(new_pwd==""){
        alert("新密码不能为空");
        return false;
    }
    if(new_pwd.length<6){
        alert("新密码长度不能小于6");
        return false;
    }
    if(new_pwd != com_new_pwd){
        alert("新密码不一致");
        return false;
    }
    $("#user_info_pwd_form").submit();
    
}

function freeze_user(user_id){
    $.ajax({
        url:'/users/'+user_id+'/freeze_user',
        dataType:'text',
        success:function(data){
            $("#freeze_user").html(data);
            if(data=="解冻该会员"){
                $("#user_status").html('（冻结状态）');
            }else{
                $("#user_status").html('');
            }

        }
    });
}