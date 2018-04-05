package com.xuhao.service;

import java.util.Collections;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.xuhao.bean.Employee;
import com.xuhao.bean.EmployeeExample;
import com.xuhao.dao.EmployeeMapper;

@Service
public class EmployeeService {

	@Autowired
	EmployeeMapper employeeMapper;
	
	
	//按照 员工编号 升序 查询所有员工
	public List<Employee> getAllEmps(){
		
		EmployeeExample employeeExample=new EmployeeExample();
		
		employeeExample.setOrderByClause("emp_id asc");
		
		return employeeMapper.selectByExampleWithDept(employeeExample);
		
	}
	
	
	public PageInfo<Employee> getEmpsByPageNum(Integer pageNum){
		
		 //传入 页码 以及  每页大小
		  PageHelper.startPage(pageNum, 5);
		  
		  // 调用 分页 后 的查询  就可以实现分页的功能
		  
		   //使用pageInfo封装 分页结果
		  //只需要将 pageInfo 交给 页面就可以 知道 分页所有信息
		  // 5代表指定 页面 最多 连续 显示 的页码 数 为 5
		   PageInfo<Employee> pageInfo=new PageInfo<>(getAllEmps(),5);
		  
           return pageInfo;
		   
	}
	
	
	// 添加员工
	
	public void saveEmp(Employee employee){
		
		employeeMapper.insertSelective(employee);
		
	}
	
	
 //校验 员工 姓名是否合法
	public boolean checkEmpByName(String empName){
		
		 EmployeeExample employeeExample=new EmployeeExample();
		
		 employeeExample.createCriteria().andEmpNameEqualTo(empName);
		 
		 //没查到 相同姓名的人 就 返回 true ，说明 姓名可以注册
		 return  employeeMapper.selectByExample(employeeExample).size()==0;
		
	}
	


	public Employee getEmpById(Integer empId) {
		
         EmployeeExample employeeExample=new EmployeeExample();		
		
         employeeExample.createCriteria().andEmpIdEqualTo(empId);
         
		return employeeMapper.selectByExample(employeeExample).get(0);
	}


	
	
	
	public void updateEmp(Employee employee) {

		EmployeeExample employeeExample=new EmployeeExample(); 
		
		//根据 主键更新
		employeeExample.createCriteria().andEmpIdEqualTo(employee.getEmpId());
		

		employeeMapper.updateByExampleSelective(employee, employeeExample);	
		
	}


	public void deleteEmpById(Integer empId) {

		EmployeeExample employeeExample=new EmployeeExample();
		
		employeeExample.createCriteria().andEmpIdEqualTo(empId);
		
		employeeMapper.deleteByExample(employeeExample);
		
	}


	public void deleteEmpsByIds(List<Integer> empIds) {

		 //开启事务
		
		//批量删除
		empIds.stream()
		      .forEach((x)->{
		    	  EmployeeExample employeeExample=new EmployeeExample();
		    	  
		    	  employeeExample.createCriteria().andEmpIdEqualTo(x);		
		    	  
		    	  employeeMapper.deleteByExample(employeeExample);
		      });
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
