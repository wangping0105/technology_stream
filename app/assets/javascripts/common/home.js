$(function(){
    var height = $(".index-left").height();
    $(".index-right").css("min-height",height+20);
    $("#close_flash").on('click',function() {
        $("#flash_field").hide();
        $(".tab_alert").hide();
    });
    $("#flash_field").fadeOut(2000);
})
function close_flash(){
    $("#flash_field").hide();
    $(".tab_alert").hide();
}

function rejust_height(){
    $(".index-left").css("height",$(".index-right").height()-20);
}
function show_user_act(obj){
    if($(".user_act").css("display")=='none'){
        $(".user_act").css({
            "top":($(obj).offset().top+15)+"px",
            "left":($(obj).offset().left-40)+"px"
        })
        $(".user_act").show();
    }else{
        $(".user_act").hide();
    }
}

function cancle_user_act(obj){
    $(".user_act").hide();
}

function upload_avatar(obj){
    png_reg = /\.png$|\.PNG/;
    jpg_reg = /\.jpg$|\.JPG/;
    var pic = $(obj).val();
    var input_s = $('#file_uploads');
    //    var ie = +[1,];
    var isIE = document.all && window.external
    if(isIE){
    }
    else{
        var file_size = input_s[0].files[0].size;
        if(file_size>1048576){
            tishi("图片不可大于1M");
            return false;
        }
    }


    if(png_reg.test(pic) == false && jpg_reg.test(pic) == false)
    {
        tishi("头像格式不正确，请重新选择JPG或PNG格式的图片！");
        $(obj).val("");
    }
    else{
        $("#fugai").show();
        $("#fugai1").show();
        $("#back_ground").show();
        $("#submit_button").click();
    /*$(obj).parents("form").submit();
        var form = $(obj).parents("form") ;
        $.ajax({
            type:'post',
            url:'/users/upload_avatar',
            dataType:'script',
            data:form.serialize()
        });*/
    }
}

function cancel_upload(){
    $("#changes_avatar").hide(100);
    $("#back_ground").hide(100);

}