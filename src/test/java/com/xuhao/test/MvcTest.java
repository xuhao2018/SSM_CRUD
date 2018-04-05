package com.xuhao.test;

import java.util.Arrays;
import java.util.List;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import com.github.pagehelper.PageInfo;
import com.xuhao.bean.Department;
import com.xuhao.bean.Employee;
import com.xuhao.bean.Message;
/**
 * 
 * spring 4测试需要 servlet3.0支持
 * 
 * 
 * @author admin
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration//可以注入 web ioc 容器
@ContextConfiguration({"classpath:applicationContext.xml","classpath:spring-mvc.xml"})
public class MvcTest {
	
	//虚拟mvc请求 ，获取 处理结果
	MockMvc mockMvc;
	
 
	@Autowired
	 WebApplicationContext webApplicationContext;

	 @Before//每次 调用 mockMvc 都需要 初始化
	public void initMockMvc(){
		
		//传入 springmvc的 ioc 容器
		mockMvc= MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
		
		
	}
	
	 @Test
	 public void testPage() throws Exception{
		 
		 //模拟 发送请求         虚拟一个发送到 emps的get请求  并且 带有参数              并拿到返回值
		MvcResult mvcResult= mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pageNum", "5")).andReturn();
		 
		
		//发送请求成功之后 ，request域中会 有一个 pageInfo 
		//取出 request域对象中的 pageInfo 进行验证
		PageInfo<Employee> pageInfo=(PageInfo<Employee>) mvcResult.getRequest().getAttribute("emps");
		
		 
		 pageInfo.getList().forEach((x)->System.out.println(x));
		 
          System.out.println("当前页码："+ pageInfo.getPageNum()+"   总页码"+pageInfo.getPages()+"  总记录数:"+pageInfo.getTotal());	
          System.out.println("显示页码总数"+pageInfo.getNavigatePages());
          
          Arrays.stream(pageInfo.getNavigatepageNums())
                .forEach((x)->System.out.println("显示页码"+x));
              		 
		 
	 }
	 
	 
	 @Test
	 public void testDepts() throws Exception{
		 
		MvcResult mvcResult= mockMvc.perform(MockMvcRequestBuilders.get("/depts")).andReturn();
		 
		 
		List<Department> departments=(List<Department>)((Message)mvcResult.getRequest().getAttribute("depts")).getMap().get("depts");
		
		
		 departments.forEach(System.out::println);
		
		 
	 }
	 
	 @Test
	 public void testInteger(){
		 
		 
		 System.out.println(Integer.parseInt("21")+"  "+Integer.valueOf("122"));
		 
	 }
	 
	 
	 
	 
	 
}
