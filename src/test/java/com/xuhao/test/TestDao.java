package com.xuhao.test;

import java.util.UUID;
import java.util.stream.Stream;

import javax.annotation.Resource;

import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.xuhao.bean.Department;
import com.xuhao.bean.Employee;
import com.xuhao.bean.EmployeeExample;
import com.xuhao.dao.DepartmentMapper;
import com.xuhao.dao.EmployeeMapper;
/**
 * 
 * Spring推荐使用spring 单元测试
 * 
 * @author admin
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)//指定 junit 用什么 单元测试模块，这里用的是spring的单元测试
@ContextConfiguration(locations="classpath:applicationContext.xml")//指定 spring配置文件位置
public class TestDao {

	@Autowired
    private  EmployeeMapper employeeMapper;
    
	@Autowired
	private DepartmentMapper departmentMapper;
	
	@Autowired
	private SqlSession sqlSession;
	
     

	@Test
	public void testCURD(){
		
		
//		 System.out.println(employeeMapper);
		
		//insertSelective 是 有选择的 插入
		//如果 doamin 对象 为 null 的属性 不会 插入到 数据库中的对应字段
		 
//		 departmentMapper.insertSelective(new Department(null, "测试部"));
//		  
//		 departmentMapper.insertSelective(new Department(null, "开发部"));
//		 
//		 departmentMapper.insertSelective(new Department(null, "市场部"));
//		 
//		 departmentMapper.insertSelective(new Department(null, "销售部"));
//		
//		 employeeMapper.insertSelective(new Employee(null, "xuhao", "M", "xuhao@qq.com", 1));
		 
         	
		 //生成员工数据
		 
//		 employeeMapper.insertSelective(new Employee(null, "xiaoming", "M", "xiaoming@163.com", 2));
//		 
//		 employeeMapper.insertSelective(new Employee(null, "laowang", "M", "laowang@163.com", 4));
//		 
//		 employeeMapper.insertSelective(new Employee(null, "xiaohau", "F", "xiaohong@163.com", 3));
//		 
//		 employeeMapper.insertSelective(new Employee(null, "xiaohong", "F", "xiaohong@163.com", 1));
		
    //批量操作 使用可以执行批量 操作的sqlSession

		EmployeeMapper employeeMapper2=sqlSession.getMapper(EmployeeMapper.class);
//		
//		//批量插入1000条数据
		  Stream.generate(()->1)
		        .limit(1000)
		        .forEach((x)->{
		        	//生成一个随机 字符串
		         String uuId=UUID.randomUUID().toString().substring(0, 5);
		         employeeMapper2.insertSelective(new Employee(null, uuId, Math.random()>0.5?"M":"F", uuId+"@qq.com", (int)(Math.random()*4)+1));
		        	
		        });
		
		
		 
		//更新员工数据
		
//		EmployeeExample employeeExample=new EmployeeExample();
//		employeeExample.createCriteria().andEmpIdEqualTo(3);
//		employeeMapper.updateByExampleSelective(new Employee(3, "xiaohua", null, "xiaohua@qq.com", null),employeeExample);
		
		
		
		 
   
	}
	
	
	
	
}
