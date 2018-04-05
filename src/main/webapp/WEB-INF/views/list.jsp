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
</head>
<body>

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
 <button type="button" class="btn btn-info" >新增</button>
 <button type="button" class="btn btn-danger">删除</button>
 </div>

 </div>
 <!-- 表格数据 -->
  <div class="row">
   <div class="col-lg-10 col-md-offset-1">
     <table class="table table-hover">
     <tr>
    <th>员工编号</th>
    <th>姓名</th>
    <th>性别</th>
    <th>邮箱</th>
    <th>部门名称</th> 
    <th>操作</th>   
    
     </tr>
 
     <c:forEach items="${requestScope.pageInfo.list }" var="emp"> 
     
                <tr>
    <th>${emp.empId }</th>
    <th>${emp.empName }</th>
    <th>${emp.empGender=='M'?'男':'女' }</th>
    <th>${emp.empEmail }</th>
    <th>${emp.department.deptName }</th> 
    <th>
  <button class="btn btn-info  btn-sm">
      <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>编辑</button>
  <button  class="btn btn-danger  btn-sm">
   <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> 删除</button>
    
    </th>   
     </tr>
     
     </c:forEach> 
     
     </table>
     
   </div>
  
  </div>
  <!-- 分页信息 -->
   <div class="row">
   <!-- 分页文字信息 -->
   <div class="col-lg-3 col-md-offset-1">
    当前${pageInfo.pageNum }页/总共${pageInfo.pages }页/总共${pageInfo.total }条记录
   </div>
   <div class="col-lg-4 col-md-offset-1">
     <nav aria-label="Page navigation">
  <ul class="pagination">

<!-- 如果是第一页不需要显示 首页 -->
  <c:if test="${!pageInfo.isFirstPage}">
  
  <li><a href="${app_path }/emps/1">首页</a></li>
  
    <li>
      <a href="${app_path }/emps/${pageInfo.prePage }" aria-label="Previous">
        <span aria-hidden="true">&laquo;</span>
      </a>
    </li>
  </c:if>
  
    
    <c:forEach items="${pageInfo.navigatepageNums }" var="navigatepageNum">
 
    
    <c:if test="${pageInfo.pageNum==navigatepageNum }">
    <li class=" active"><a href="#">${navigatepageNum }</a></li>
   </c:if>
   
    <c:if test="${pageInfo.pageNum!=navigatepageNum }">
    <li ><a href="${app_path }/emps/${navigatepageNum }">${navigatepageNum }</a></li>
   </c:if>
    
    </c:forEach>
    
    <!-- 最后一页不需要显示 末页 -->
    <c:if test="${!pageInfo.isLastPage }">
 
    <li>
      <a href="${app_path }/emps/${pageInfo.nextPage }" aria-label="Next">
        <span aria-hidden="true">&raquo;</span>
      </a>
    </li>
    
    <li><a href="${app_path }/emps/${pageInfo.pages }">末页</a></li>
    
    </c:if>
  </ul>
</nav>
   </div>
   </div> 
 
 </div>







</body>
</html>