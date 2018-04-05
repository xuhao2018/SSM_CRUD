package com.xuhao.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.xuhao.bean.DepartmentExample;
import com.xuhao.bean.Message;
import com.xuhao.dao.DepartmentMapper;

@Service
public class DepartmentService {

	@Autowired
	private DepartmentMapper departmentMapper;
	
	
	 public Message getAllDepts(){
		 
		  DepartmentExample departmentExample=new DepartmentExample();
		 
		  departmentExample.setOrderByClause("dept_id asc");
		  
		return  Message.success().add("depts", departmentMapper.selectByExample(departmentExample));
		
	 }
	
	
	
}
