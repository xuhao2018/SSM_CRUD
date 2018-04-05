package com.xuhao.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.xuhao.bean.Department;
import com.xuhao.bean.Message;
import com.xuhao.service.DepartmentService;
/**
 * 
 * 处理 部门 信息
 * 
 * @author admin
 *
 */
@Controller
public class DepartmentHandler {

	 @Autowired
	private DepartmentService departmentService;
	
	
	
	@ResponseBody
	@RequestMapping(value="/depts",method=RequestMethod.GET)
	public Message getDepts(){
		
		return departmentService.getAllDepts();
		
	}
	
	
	
	
	
	
}
