/**
 * index页面的 js 代码
 */



 //把 全局 信息 保存到 一个map 中
	 var map ={
    //保存 当前页面总记录数
		totalRecord:1,
	 //保存当前 code
		code:100,
		//添加员工的校验是否完全成功
		addEmpValidateResult:false
	 };
	 
	 
	 
 
  //页面加载完成之后
   //发送ajax 请求
   //接受 分页数据
   $(function(){
	   
	   
	   
	   
	   // 修改员工
	   
	     $(document).on("click","#emp_update",function(){
		   
		   
		     //发送ajax请求
		   //  获取部门信息并显示在模态框中
	    	 getDepts("update");
	    	 
				 
				   //回显 用户名和 邮箱
				   $("#emp_update_name").val($(this).parent("td").parent("tr").find("#td_emp_name").text()).prop("readonly",true);
				   $("#emp_update_email").val($(this).parent("td").parent("tr").find("#td_emp_email").text());
				   
				   //显示 性别和 部门
				  $(this).parent("td").parent("tr").find("#td_emp_gender").text()=='男'?$("#emp_update_gender_M").prop("checked",true):$("#emp_update_gender_F").prop("checked",true); 
				
				   //alert($(this).parent("td").parent("tr").children("#td_emp_dept").attr("deptId"));
				  
                   $("#emp_update_dept").val(3);
				  
		
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
	    
	    
	     //当邮箱 信息 发生改变 也会 进行格式 校验
	     
	     $("#emp_add_email").on("change",function(){
	    	 
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
	    $("#add_clear").on("click",function(){

	    	
	    	 //重置表单数据内容
	    	 $("#add_emp")[0].reset();
	    	 
	    	
	    	 //清空校验信息
	    	 clearValidateMessage("#emp_add_name,#emp_add_email");
	    	 
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
		  .append($("<th></th>").html("员工编号"))
		  .append($("<th></th>").html("姓名"))
		  .append($("<th></th>").html("性别"))
		  .append($("<th></th>").html("邮箱"))
		  .append($("<th></th>").html("部门名称"))
		  .append($("<th></th>").html("操作")) 
		  );  
		 
		 
	   	
		 
	 $.each(emps,function(index,emp){
		 
		   
		  var $_tr=$("<tr></tr>");
		  
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
    
   
  
  
  