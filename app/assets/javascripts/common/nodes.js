function select_mian_node(obj){
    var section_id = $(obj).val();
    $.ajax({
        type:'get',
        url:"/nodes/"+section_id+"/node_list",
        dataType:'script'
    });
}
function show_section(obj){
    $("#add_section").find('input').val("");
    $("#add_section").css({
        "top":($(obj).offset().top+40)+"px",
        "left":($(obj).offset().left)+"px"
    });
    $("#add_section").show();
}
function show_node(obj){
    $("#add_node").find('input[name=node_summary]').val("");
    $("#add_node").find('input[name=node_name]').val("");
    $("#add_node").css({
        "top":($(obj).offset().top+40)+"px",
        "left":($(obj).offset().left)+"px"
    });
    $("#add_node").show();
}
function show_tip(obj){
    $("#add_tip").find('input[name=tip_content]').val("");
    $("#add_tip").css({
        "top":($(obj).offset().top+30)+"px",
        "left":($(obj).offset().left)+"px"
    });
    $("#add_tip").show();
}
function submit_section(obj){
    var section_name = $.trim($(obj).parent().find('input').val());
    if(section_name=="" || section_name.length>8){
        alert("名称不能大于8个字，且不为空");
        return false;
    }
    location.href = "nodes/create_section?section_name="+section_name;
}
function submit_node(obj){
    var section_id =$("#add_node").find('input[name=section_id]').val();
    var node_summary = $.trim($("#add_node").find('input[name=node_summary]').val());
    var node_name    = $.trim($("#add_node").find('input[name=node_name]').val());
    if(node_name=="" || node_name.length>8){
        alert("名称不能大于8个字，且不为空");
        return false;
    }
    if(node_summary.length>20){
        alert("摘要不能大于20个字");
        return false;
    }
     $.ajax({
        type:'get',
        url:"/nodes/"+section_id+"/create_node?node_name="+node_name+"&node_summary="+node_summary,
        dataType:'script',
        success:function(data){
            $("#add_node").hide();
        }
    });
}

function submit_tip(obj){
    var txt = $("#add_tip").find("textarea");
    if(txt=="" || txt.length>200){
        alert('内容不为空且不能大于200');
        return false;
    }
    $("#add_tip").find("form").submit();
}
function cancel_tow(obj){
    $(obj).parent().parent().hide();
}
function cancel_three(obj){
    $(obj).parent().parent().parent().hide();
}