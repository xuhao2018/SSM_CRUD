<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"  %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%
 pageContext.setAttribute("app_path",request.getContextPath() );

%>

<title>Insert title here</title>

<link rel="stylesheet" style="text/html" href="${pageScope.app_path}/static/css/bootstrap.min.css" />
 <script type="text/javascript" src="${pageScope.app_path}/static/js/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="${pageScope.app_path}/static/js/bootstrap.min.js"></script>

 <script type="text/javascript" >
 
 /**
  * index页面的 js 代码
  */



  //把 全局 信息 保存到 一个map 中
 	 var map ={
     //保存 当前页面总记录数
 		totalRecord:1,
 		//当前页的数量
 		size:0,
 	 //保存当前 code
 		code:100,
 		//添加员工的校验是否完全成功
 		addEmpValidateResult:false,
 		//修改员工的信息 是否 完全成功
 		updateEmpValidateResult:true
 	 };
 	 
 	 
 
 
 
 	 
  
   //页面加载完成之后
    //发送ajax 请求
    //接受 分页数据
    $(function(){
    	
    	//批量删除
       //删除 所有 选中的 员工
       $("#delete_emps_checked").on("click",function(){
    	   
    	    //如果没有复选框被选中 则 提示 没有要删除的
    	   if($("#emps .check_item:checked").length==0){
    		    
    		   $("#deleteEmps_modal_0").modal("show");
    		   
    		   return ;
    	   }
    	   
    	   
    	   var ids="";
    	   

    	   
    	   $("#emps .check_item:checked").each(function(index,value){
    		
                 ids+= $(this).parent("td").parent("tr").children("#td_emp_id").text()+",";
    		
    	   })

    	    ids=ids.substr(0,ids.length-1); 
    	   
    	   $("#delete_emps_btn").attr("empsId",ids);
    	   
    	    $("#deleteEmps_modal  #emp_title").children("span").text(" "+ids+"号员工");
    	    
    	    //打开 是否删除 的模态框
    	   $("#deleteEmps_modal").modal("show");

       })
    	
    	
    	   //发送ajax 请求 删除 选中 的员工
     	   $("#delete_emps_btn").on("click",function(){
    
    		    $.ajax({
    		    url:"${app_path}/emp/id/"+$("#delete_emps_btn").attr("empsId"),
    		    type:"delete",
    		    success:function(data){
    		    	
    		    	//关闭模态框
         			$("#deleteEmps_modal").modal("hide");
    		    	
                //将 当前 页数据 回显到页面
    			  requestAjax("${app_path}/emps/"+$("#pageNum").text());      
    		    	
    		    }	
    		    	
    		    })
    		   
    	   }) 
    	   
    	
    	
    	
    	//当 总 复选框 全选 和 全不选 其他 复选框也要全选全不全 
    	$(document).on("click","#check_all",function(){
    		
    		$("#emps .check_item").each(function(index,value){
    		
    			  $(value).prop("checked",$("#check_all").prop("checked"));
    			
    		})
    		
    	})
    	
    	
    	//当 所有的复选框全选或者 全不选
    	//总复选框也要 选中或者不选中
    	
    	 $(document).on("click","#emps .check_item",function(){
    		 
    		 
    	     //匹配所有被选中复选框
    	     //被选中的复选框 为 0 总复选框 跟着不被选中
    		 if($("#emps .check_item:checked").length==0){
    			 $("#check_all").prop("checked",false); 
    			 return;
    		 }
    		 
    		 
    		 //被选中的复选框 等于 所有复选框数(不包括总复选框)，总复选框跟着被选中
    		 if($("#emps .check_item:checked").length==$("#emps .check_item").length){
    			 
    			 $("#check_all").prop("checked",true); 
    			 
    		 }
    		 
    		 
    	 })
    	
    	
    	 
    	 
    	 
    	
    	
    	//员工的单个删除事件
    	$(document).on("click","#emp_delete",function(){
    
    		
    		 //将 员工id 存到 模态框 中
    		 $("#deleteEmp_modal").attr("empId",$(this).parent("td").parent("tr").children("#td_emp_id").text());
    		 
    		  //在 模态框内 显示 要删除的员工编号即姓名
    		  $("#deleteEmp_modal  h4").children("span").text(" <"+$(this).parent("td").parent("tr").children("#td_emp_id").text()+">"
    				  +$(this).parent("td").parent("tr").children("#td_emp_name").text());
    		  
               //先 确认是否删除
                //显示模态框
                $("#deleteEmp_modal").modal("show");
               
    	})
    	
    	
    	
    	 //点击确认模态框中的 删除 按钮 事件
    	$("#delete_emp_btn").on("click",function(){
    		
    		 //点击确认删除 就开始删除
    		 
          //发送Ajax请求 删除用户
                $.ajax({
             	   url:"${app_path}/emp/id/"+ $("#deleteEmp_modal").attr("empId"),
             	   type:"delete",
             	   success:function(data){
             		   
                        //回显 页面
             		   requestAjax("${app_path}/emps/"+$("#pageNum").text());            		   
             	   }
             	   
                })

                //关闭模态框
              $("#deleteEmp_modal").modal("hide");                
    		
    	})
    	
    	
    	
 	   
    	//点击修改就更新 员工信息
    	
    	$("#update_emp_btn").on("click",function(){
    	
    		//先确定邮箱 是否验证 成功
    		//失败就不需要发送请求了
    	 	if(!map.updateEmpValidateResult){
    			return ;
    		}  
    		
    		
    		//发送ajax 请求 
    		//保存 
    		
    		 $.ajax({
    			url:"${app_path}/emp/"+$(this).attr("empId"),
    			type:"PUT",
    			data:$("#update_emp_form").serialize(),
    			 success:function(data){
    			 
    				
    				 //清除 校验信息
    		         $("#update_clear").click();
               
    			 //关闭模态框
         			$("#updateEmp_modal").modal("hide");
                //将 当前 页数据 回显到页面
    			  requestAjax("${app_path}/emps/"+$("#pageNum").text());      			 

                
    			 }
    			 
    		 })
    		
    		
    	})
    	
    	
    	//关闭 模态框的时候清除校验信息
    	$("#updateEmp_modal #close_modal,#updateEmp_modal  .close").on("click",function(){
    	
    		 //清除 校验信息
            $("#update_clear").click();
    		 
    	})
    	
    	
    	
    	
    	
    	//修改 员工 信息的邮箱的模态框发生 改变就 校验 格式
    	 $("#emp_update_email").on("change",function(){
    		
    		//验证 邮箱 是否合法
    	    if(!validateMessage("#emp_update_email",
    	    		/^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/.test($("#emp_update_email").val()),
    	    		"邮箱校验成功","邮箱不太收欢迎")){
    	    			
    	    	// $("#update_emp_btn").text("校验");
    	    	
    	    	         //验证不通过就不需要 更新了
    	    	         return  map.updateEmpValidateResult=false;
    	    			
    	    		} 	
    		
    		//$("#update_emp_btn").text("修改");
    		
    		return map.updateEmpValidateResult=true;
    		
    	}) 
    	
    	
 	   
 	   
 	   // 修改员工
 	   //点击编辑按钮  触发模态框
 	     $(document).on("click","#emp_update",function(){
 		   
 		     //发送ajax同步请求
 		   //  获取部门信息并显示在模态框中
 	    	 getDepts("update");
 		     
 		      //将 员工id 加到模态框的更新按钮属性上
 		       $("#update_emp_btn").attr("empId",$(this).parent("td").parent("tr").find("#td_emp_id").text()); 
 		      
 		     
 				 //从之前的 表单中获取 编辑按钮对应的员工信息
 				   //回显 用户名和 邮箱
 				   $("#emp_update_name").html($(this).parent("td").parent("tr").find("#td_emp_name").text());
 				   $("#emp_update_email").val($(this).parent("td").parent("tr").find("#td_emp_email").text());
 				   
 				   //显示 性别和 部门
 		   
 		   $("#updateEmp_modal input["+$(this).parent("td").parent("tr").find("#td_emp_gender").text()+"]").prop("checked",true);
 		   
 		   $("#emp_update_dept").val($(this).parent("td").parent("tr").children("#td_emp_dept").attr("deptId"));
 				  
 	   }) 
 	   

 	   
 	   
 	   
 	    //校验 员工姓名是否可用
   	    $("#emp_add_name").on("change",function(){
   	    	
   	    	//如果 用户名格式不正确 就没有必要 验证是否重复
   	    	if(addEmpValidate()=='name_fail'){
   	    		
   	    		return ;
   	    		
   	    	}
   	    	
 	    	
              $.ajax({
             	 
             	 url:"${app_path}/emp/"+$(this).val().trim(),
             	 type:"get",
             	 success:function(data){
             	
             		 validateMessage("#emp_add_name",data.code==100,data.map.message,data.map.message);
             	
             		 
             		 //获取 当前 浏览器 发送的状态码
             		 map.code=data.code;
             		 
             		 
             	 }
             	 
              })  	    	
 	    	
 	    })  
 	    
 	    
 	     //当添加员工的模态框邮箱 信息 发生改变 也会 进行格式 校验
 	     $("#emp_add_email ").on("change",function(){
 	    	 
 	    	 $("#emp_add_name").change();

           })
 	     
 	    
 	    
 	    
 	   
 	   
 	   
 	   
 	   
 	    //点击保存 添加员工
         $("#save_emp").on("click",function(){
        
         	 //对 员工 信息进行校验
         	 //校验失败 就不再 发送 添加请求
         	
           	 if(!map.addEmpValidateResult||map.code!=100){
         		 
         		 return ;
         	 } 
         
         	$.ajax({
         		url:"${app_path}/emp",
         		data:$("#add_emp").serialize(),//将form 表单数据解析为 json字符串
         		type:"post",
         		success:function(data){
         			
         			//如果 后端 校验失败
                if(data.code==200){
  
             	    //显示错误信息
             	   for(var key in data.map.emp_error){
             		   
             		   validateMessage(key=='empName'?"#emp_add_name":"#emp_add_email",false,null,data.map.emp_error[key]);
             		   
             	   }
             	   
             	   return ;
             	   
                }
         			
         			
         			//清除 之前  填写的信息 以及 校验信息
         			$("#add_clear").click();
         			
         			
         			//关闭模态框
         			$('#addEmp_modal').modal('hide')
         			
         			//请求 刷新 页面 显示 新增后的 员工信息
         			//来到最后一页 显示 刚才的员工
         			//传一个 总记录数(总记录数一定大于 总页数) 让分页插件 返回 最后一页
         			requestAjax("${app_path}/emps/"+map.totalRecord);
         			
         		}
         		
         	}) 
         	
         	
         })	    	
 	   
 	   
 	   
 	   
 	   
 	    //清空添加员工 模态框的信息 以及校验的信息
 	    $("#add_clear ,#update_clear ").on("click",function(){
 	    		
 	    	 //重置表单数据内容
 	    	 $(this).parent("div").prev("div").children("form")[0].reset();
 	    	
 	    	 if($(this).prop("id")=="add_clear"){
 	    		 
 	    	 //清空校验信息
 	    		clearValidateMessage("#emp_add_name,#emp_add_email");
 	    		 
 	    	 }else{
 	    		 
 	    	 clearValidateMessage("#emp_update_email");
 	    		 
 	    	 }
 	    	
 	    })
 	   
 	   
 	     
 	    
 	    
 	    
 	   
 	   
 	    //点击 新增员工 弹出模态框
 	    $("#addEmp").on("click",function(){
 	    	
 	    	 //从数据库 查询 部门信息 并 显示在 模态框
 	    	  getDepts("add");
 	    	
 	    	
 	    	
 	    })
 	    
 	    
 	   
 	   
 	   
 	    //导航 go 的点击
 	    $("#go").on("click",function(){
 	    	
 	    	 if($("#go_pageNum").val().trim()!=''){
 	    		 
 	    	requestAjax("${app_path}/emps/"+$("#go_pageNum").val());
 	    		 
 	    	 }
 	    	
 	    	
 	    })
 	   
 	   
 	   
 	   //默认初始化加载 第一页 信息
 	   requestAjax("${app_path}/emps/1");
 	   
 	   
 	   //绑定超链接事件  请求 分页查询员工信息
 	   $(document).on("click","a",function(){
 		   //alert();
 		   requestAjax($(this).attr("href"));
 		    return false;
 		   
 	   })
 	   
 	   
 	   
 	   
    })
   
    //发送ajax 请求 显示 页面信息
    function  requestAjax(u){
 	  
 	   $.ajax({
 		   url:u,
            type:"get",		   
 		   success:function(data){
 		 
 			   //解析 json，取出 员工信息
 			   getEmpsTable(data.map.pageInfo.list);
 			   
 			   //解析 分页信息
 			   getPageInfo(data.map.pageInfo);
 			   
 			   //解析分页条信息
 			   getPageNav(data.map.pageInfo);
 			   
        			  
 		   }
 		   
 	   })
 	   
 	   
 	  
   }  
   
    
   // 获取 员工信息
    function getEmpsTable(emps){

 		  
 	   	  $("#emps").empty().append(
 		  $("<tr></tr>").addClass("warning")
 		  .append($("<th></th>").append($("<input>").prop("id","check_all").prop("type","checkbox")))
 		  .append($("<th></th>").html("员工编号"))
 		  .append($("<th></th>").html("姓名"))
 		  .append($("<th></th>").html("性别"))
 		  .append($("<th></th>").html("邮箱"))
 		  .append($("<th></th>").html("部门名称"))
 		  .append($("<th></th>").html("操作")) 
 		  );   
 		 
 	   	
 		 
 	 $.each(emps,function(index,emp){
 		 
 		   
 		  var $_tr=$("<tr></tr>").append($("<td></td>").append($("<input>").prop("type","checkbox").addClass("check_item")));
 		  
 		  $("<td></td>").prop("id","td_emp_id").append(emp.empId).appendTo($_tr);
 		  $("<td></td>").prop("id","td_emp_name").append(emp.empName).appendTo($_tr);
 		  $("<td></td>").prop("id","td_emp_gender").append(emp.empGender=='M'?'男':'女').appendTo($_tr);
 		  $("<td></td>").prop("id","td_emp_email").append(emp.empEmail).appendTo($_tr);
 		  $("<td></td>").prop("id","td_emp_dept").attr("deptId",emp.department.deptId).append(emp.department.deptName).appendTo($_tr);
 		  var $_edit=$("<botton></button>").addClass("btn btn-info  btn-sm").prop("id","emp_update");
 		  $("<span></span>").addClass("glyphicon glyphicon-pencil").attr("aria-hidden",true).html("编辑").appendTo($_edit);
 		  var $_delete=$("<botton></button>").addClass("btn btn-danger  btn-sm").prop("id","emp_delete");
 		  $("<span></span>").addClass("glyphicon glyphicon-trash").attr("aria-hidden",true).html("删除").appendTo($_delete);
 		  $("<td></td>").append($_edit).append($_delete).appendTo($_tr);
 		  $_tr.appendTo($("#emps"));
 		  
 		 
 	   });
 	  
   }
   
   
   //获取 分页信息
      function getPageInfo(pageInfo){
 	  
 	$("#pageNum").html(pageInfo.pageNum);
 	$("#pages").html(pageInfo.pages);
 	$("#total").html(pageInfo.total);
 	
 	//获取当前总记录数
 	map.totalRecord=pageInfo.total;
 	//获取 当前 页面 记录数
 	map.size=pageInfo.size;
 	
   } 
   
   
   //解析显示 分页导航条
   
     function getPageNav(pageInfo){
 	   
 	         //把 go 输入框清空
 	         $("#go_pageNum").val("");
 	  
 	     $(".pagination").empty();
 	  
 		var $_first=  $("<li></li>").append($("<a></a>").attr("href","${app_path }/emps/"+1).html("首页")).appendTo($(".pagination")).addClass("disabled");
 		  if(!pageInfo.isFirstPage){
 			  
 			$_first.removeClass("disabled");
 			  
 			  $("<li></li>").
 			  append($("<a></a>").attr("href","${app_path }/emps/"+(pageInfo.pageNum-1)).attr("aria-label","Previous").
 			  append($("<span></span>").attr("aria-hidden",true).html("&laquo;"))).
 			  appendTo($(".pagination"));
 			  
 		  }
 	  $.each(pageInfo.navigatepageNums,function(index,navigatepageNum){
 		 
 		  
 		 var $_li=  $("<li></li>").append($("<a></a>").attr("href","${app_path }/emps/"+navigatepageNum).html(navigatepageNum)).appendTo($(".pagination"));
 		  if(navigatepageNum==pageInfo.pageNum){
 			  $_li.addClass("active");
 		  }
 		  
 		  
 		  
 		  
 	  })
 	  
 			  var $_last=$("<li></li>").append($("<a></a>").attr("href","${app_path }/emps/"+pageInfo.pages).html("末页")).addClass("disabled");
 	  
           if(!pageInfo.isLastPage){
 			  
 			  $("<li></li>").
 			  append($("<a></a>").attr("href","${app_path }/emps/"+(pageInfo.pageNum+1)).attr("aria-label","Next").
 			  append($("<span></span>").attr("aria-hidden",true).html("&raquo;"))).
 			  appendTo($(".pagination"));
 			  
 			  $_last.removeClass("disabled");
 		  }
 	  
           $_last.appendTo($(".pagination"));
 	  
   } 
 	  
 	  
   
   
   // 获取 部门信息 并显示在 模态框内
   function getDepts(modal_title){
 	
 	   $.ajax({
 		   url :"${app_path}/depts",
 		   type:"get",
 		  async : false  ,
 		   success:function(data){

 			    //先 清空 之前的 部门信息
 			    $("#emp_"+modal_title+"_dept").empty();
 			   
 			   $.each(data.map.depts,function(index,dept){
 				 
 				 $("#emp_"+modal_title+"_dept").append($("<option></option>").val(dept.deptId).html(dept.deptName));  
 				   
 			   })
 		   }
 	   })
 	 //启动模块框 并设置 属性
    	$("#"+modal_title+"Emp_modal").modal({
    		keyboard:true,
    		backdrop:"static"
    	});
 	   
 	  
   }

   
   // 对添加 员工的信息  进行校验
   function addEmpValidate(){
 	  
 	  //校验 员工姓名 使用 正则表达式
 	  var testName=/(^[a-zA-Z0-9_-]{3,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
 	  
 	  //校验 邮箱地址的正则 表达式
 	  var testEmail=/^[A-Za-z0-9\u4e00-\u9fa5]+@[a-zA-Z0-9_-]+(\.[a-zA-Z0-9_-]+)+$/;
  
 	  
 		 
 	  //验证用户名 和 邮箱
 	  if(!validateMessage("#emp_add_name",testName.test($("#emp_add_name").val()),"用户名格式正确","用户名不太收欢迎")){
 		  
 		  map.addEmpValidateResult=false;
 		  
 		  return "name_fail";
 		  
 	  }
 	  
      
 	  //验证 邮箱 
 	  if(!validateMessage("#emp_add_email",testEmail.test($("#emp_add_email").val()),"邮箱校验成功","邮箱不太收欢迎")){
 		  
 		  map.addEmpValidateResult=false;
 		  
 		  return "email_fail";
 	  }
 		
 	  return map.addEmpValidateResult=true;
 	  
   }
   
   
    //封装校验信息                      选择器    状态    校验成功信息    校验失败信息
    function validateMessage(selector,status,message_success,message_fail){
 	   
 	   // 先清除 之前的状态
 		  clearValidateMessage(selector);
 	   if(status){
 		   
 		   $(selector).parent().addClass("has-success");
 			  $(selector).next("span").next("span").addClass("glyphicon-ok");
 			  $(selector).next("span").html(message_success);
 			  
 		   return true;
 		   
 	   }else{
 		   
 		   $(selector).parent().addClass("has-error");
 			  $(selector).next("span").next("span").addClass("glyphicon-remove");
 			  $(selector).next("span").html(message_fail);
 			  
 			  return false;
 	   }
 	   
 	   
 	   
 	   
    }
    
   
    
     //清除校验 信息
     function clearValidateMessage(selector){
     	
     	$(selector).parent().removeClass("has-error").removeClass("has-success");
 		  $(selector).next("span").next("span").removeClass("glyphicon-ok").removeClass("glyphicon-remove");
 		  $(selector).next("span").html("");
     	
     }
     
    
   
   
   
 </script>


</head>
<body>



<!-- Modal
 模态框
 用于 新增 员工
 -->
<div class="modal fade" id="addEmp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"  id="emp_title">员工添加</h4>
      </div>
      <div class="modal-body">
        
        
        
        <form class="form-horizontal" id="add_emp">
  <div class="form-group">
    <label for="emp_add_name" class="col-sm-2 control-label">姓   名</label>
    <div class="col-sm-10 has-feedback">
      <input type="text" class="form-control" id="emp_add_name" placeholder="Name:由3-16位数字或字母  或者 2-5位汉字组成" name="empName" >
      <span  class="help-block" ></span>
       <span class="glyphicon  form-control-feedback" aria-hidden="true" id="check_emp_name_pic"></span>
      
    </div>
  </div>
  <div class="form-group">
    <label for="emp_add_emil" class="col-sm-2 control-label">邮   箱</label>
    <div class="col-sm-10 has-feedback">
      <input type="text" class="form-control" id="emp_add_email" placeholder="Email:121221@163.com" name="empEmail">
      <span  class="help-block"></span>
       <span class="glyphicon  form-control-feedback" aria-hidden="true" id="check_emp_email_pic"></span>
    </div>
  </div>


 <div class="form-group">
    <label for="emp_add_gender" class="col-sm-2 control-label">性    别</label>
    <div class="col-sm-10">

      
  <label class="radio-inline">
  <input type="radio" name="empGender" id="emp_add_gender_M" value="M" checked="checked"> 男
</label>
<label class="radio-inline">
  <input type="radio" name="empGender" id="emp_add_gender_F" value="F"> 女
</label>


    </div>
  </div>
  
  
  
   <div class="form-group">
    <label for="emp_add_dept" class="col-sm-2 control-label">部门</label>
    <div class="col-sm-4">
     <select class="form-control" name="deptId" id="emp_add_dept" >

  
</select>
    </div>
  </div>
  


</form>
        
        
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" id="add_clear">清空</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="close_modal">关闭</button>
        <button type="button" class="btn btn-primary" id="save_emp" >保存</button>
      </div>
    </div>
  </div>
</div>




<!-- Modal
 模态框
 用于 修改 员工
 -->
<div class="modal fade" id="updateEmp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"  id="emp_title">员工修改</h4>
      </div>
      <div class="modal-body">
        
        
        
        <form class="form-horizontal" id="update_emp_form">
  <div class="form-group">
    <label for="emp_update_name" class="col-sm-2 control-label">姓   名</label>
    <div class="col-sm-10 has-feedback">
     <p class="form-control-static" id="emp_update_name"></p>
      <span  class="help-block" ></span>
       <span class="glyphicon  form-control-feedback" aria-hidden="true" id="check_emp_name_pic"></span>
      
    </div>
  </div>
  <div class="form-group">
    <label for="emp_update_emil" class="col-sm-2 control-label">邮   箱</label>
    <div class="col-sm-10 has-feedback">
      <input type="text" class="form-control" id="emp_update_email" placeholder="Email:121221@163.com" name="empEmail">
      <span  class="help-block"></span>
       <span class="glyphicon  form-control-feedback" aria-hidden="true" id="check_emp_email_pic"></span>
    </div>
  </div>


 <div class="form-group">
    <label for="emp_update_gender" class="col-sm-2 control-label">性    别</label>
    <div class="col-sm-10">

      
  <label class="radio-inline">
  <input type="radio" name="empGender" id="emp_update_gender_M" value="M" checked="checked" 男> 男
</label>
<label class="radio-inline">
  <input type="radio" name="empGender" id="emp_update_gender_F" value="F" 女> 女
</label>


    </div>
  </div>
  
  
  
   <div class="form-group">
    <label for="emp_update_dept" class="col-sm-2 control-label">部门</label>
    <div class="col-sm-4">
     <select class="form-control" name="deptId" id="emp_update_dept" >

  
</select>
    </div>
  </div>
  


</form>
        
        
        
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-info" id="update_clear">清空</button>
        <button type="button" class="btn btn-default" data-dismiss="modal" id="close_modal">关闭</button>
        <button type="button" class="btn btn-primary" id="update_emp_btn" >修改</button>
      </div>
    </div>
  </div>
</div>







<!-- 模态框 用于 确认是否删除单个员工 -->
<div class="modal fade" id="deleteEmp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"  id="emp_title">确认删除   <span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span> </h4>
      </div>
      
      <div class="modal-footer ">
        <button type="button" class="btn btn-info" data-dismiss="modal" id="close_modal">取消</button>
        <button type="button" class="btn btn-danger" id="delete_emp_btn" >删除</button>
      </div>
    </div>
  </div>
</div>




<!-- 模态框 用于 确认是否批量删除员工 -->
<div class="modal fade" id="deleteEmps_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"  id="emp_title">确认删除   <span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span> </h4>
      </div>
      
      <div class="modal-footer ">
        <button type="button" class="btn btn-info" data-dismiss="modal" id="close_modal">取消</button>
        <button type="button" class="btn btn-danger" id="delete_emps_btn" >删除</button>
      </div>
    </div>
  </div>
</div>





<!-- 模态框 用于 提示没有可以删除员工 -->
<div class="modal fade" id="deleteEmps_modal_0" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-sm" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close" ><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title"  id="emp_title"> <span class="glyphicon glyphicon-exclamation-sign " aria-hidden="true"></span> 没有可以删除的员工 </h4>
      </div>
      
      <div class="modal-footer ">
        <button type="button" class="btn btn-info" data-dismiss="modal" id="close_modal">确定</button>
      </div>
    </div>
  </div>
</div>



 <div class="containter">
 <!-- 标题 -->
 <div class="row">
 <div class="col-lg-12"  > 
 <div class="col-lg-4 col-md-offset-4">
  <h1 >SSM-CRUD</h1>
 </div>
 </div>
 </div>
 <!-- 按钮 -->
 <div class="row">

 <div class="col-lg-4 col-md-offset-8">
 <button type="button" class="btn btn-primary" data-toggle="modal" id="addEmp">
  <span class="glyphicon glyphicon-plus" aria-hidden="true"  ></span>新增</button>
 <button type="button" class="btn btn btn-danger" id="delete_emps_checked">
  <span class="glyphicon glyphicon-scissors" aria-hidden="true"></span>   批量删除</button>
 </div>

 </div>
 <!-- 表格数据 -->
  <div class="row ">
   <div class="col-lg-10 col-md-offset-1 " >
   
     <table class="table table-hover " >

 <!--  <thead id="emps_head">
   <tr>
   <th><input type="checkbox"> </th>
   <th>员工编号</th>
   <th>姓名</th>
   <th>性别</th>
   <th>部门名称</th>
   <th>操作</th>
   </tr>
    
  </thead> -->

    <tbody id="emps"></tbody>
 
     
     </table>

   </div>
  
  </div>
  <!-- 分页信息 -->
   <div class="row">
   <!-- 分页文字信息 -->
   <div class="col-lg-3 col-md-offset-1">
    当前第<span id="pageNum"></span>页/总共<span id="pages"></span>页/总共<span id="total"></span>条记录

   </div>
   
   
  <div class="col-lg-2">
    <div class="input-group">
      <input type="text" class="form-control" placeholder="Let's go..." id="go_pageNum">
      <span class="input-group-btn">
        <button class="btn btn-default" type="button" id="go">Go</button>
      </span>
    </div>
  </div>
  

   
   
   <div class="col-lg-4 col-md-offset-1">
     <nav aria-label="Page navigation">
  <ul class="pagination">


  
    
 
    
 
  </ul>
  
</nav>
   </div>
   </div> 
 
 </div>







</body>
</html>