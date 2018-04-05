package com.xuhao.controller;


import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageInfo;
import com.xuhao.bean.Employee;
import com.xuhao.bean.Message;
import com.xuhao.service.EmployeeService;

/**
 * 处理员工 增删改查
 * 
 * @author admin
 *
 */

@Controller
public class EmployeeHandler {

	@Autowired
	private EmployeeService employeeService;
	
	//@RequestMapping("/emps")
	public String getEmps(@RequestParam(value="pageNum",defaultValue="1") Integer pageNum ,Map<String, ? super PageInfo<Employee>> map){
		
		//从数据库中查询所有员工
		//并返回 分页 结果
		map.put("pageInfo", employeeService.getEmpsByPageNum(pageNum));
		
		return "list";
		
	}
	
	/**
	 * 
	 * 导入 jackSon包
	 * 返回 json 字符串的支持
	 * @param pageNum
	 * @return
	 */
	@ResponseBody //将返回结果对象转化为 json字符串     
	@RequestMapping(value={"/emps/{pageNum}"},method=RequestMethod.GET)
	public Message  getEmpsWithJson(@PathVariable(value="pageNum",required=false)Integer pageNum){

		 //返回Message 封装 pageInfo 过后的信息
		 return Message.success().add("pageInfo", employeeService.getEmpsByPageNum(Optional.ofNullable(pageNum).orElse(1)));
		
	}
	

	
	//员工保存
	//后端校验 数据 是否 合法
    //传入 员工信息 需要 验证 用户名和 邮箱的格式
	@ResponseBody
	@RequestMapping(value="/emp",method=RequestMethod.POST)
	public Message  saveEmp(@Valid Employee employee,BindingResult result){
		
		//如果校验失败 就返回 校验失败错误信息
		if(result.hasErrors()){
			
			Map<String, ? super String> map=new HashMap<>();
			
			//添加 校验信息 并返回结果到 前端
		 result.getFieldErrors().forEach((x)->map.put(x.getField(), x.getDefaultMessage()));
		
		  return Message.fail().add("emp_error", map);
		 
		}
		
		
		//保存
		employeeService.saveEmp(employee);
	
		return Message.success();
		
	}
	
	
	
	//检验用户名是否可用
	
	@ResponseBody
	@RequestMapping(value="/emp/{empName}",method=RequestMethod.GET)
	public Message checkEmpName(@PathVariable(value="empName")String empName){
		
                   //		 使用正则 验证 有户名 格式是否正确
		// 如果 验证 失败 就没有不必要到数据库查询
		
		return empName.matches("(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})")
				?employeeService.checkEmpByName(empName)?Message.success().add("message", "用户名校验成功")
				:Message.fail().add("message", "用户名已存在")
				:Message.fail().add("message", "用户名格式 校验失败");
		       
	}
	
	
	/**
	 * 
	 * 根据 id 查询  员工信息
	 * 
	 * @param empId
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value="/emp/id/{empId}",method=RequestMethod.GET)
	public Message getEmpByEmpId(@PathVariable(value="empId")Integer empId){
		
		 return Message.success().add("emp", employeeService.getEmpById(empId));
		
	}
	
	
	
	/**
	 * 
	 * 根据员工id
	 * 修改 员工信息
	 * 
	 * 如果直接发送 ajax type=put形式的 请求 
	 *  封装的数据 除了 路径 带的 参数 其他 参数 无效
	 * 
	 * 问题：
	 *  请求体中有数据 
	 *  employee 对象封装不了
	 *  
	 *  解决：
	 *  配置 put 的filter
	 *  将 put 请求 的参数 解析 封装成对象 
	 * 
	 */
	@ResponseBody
	@RequestMapping(value="/emp/{empId}",method=RequestMethod.PUT)
	public Message updateEmp(@Valid Employee employee,BindingResult bindingResult){
		
		Map<String,? super String> empError =VaildEmployee(bindingResult);
		
		if( !empError.isEmpty()){
			 
			return Message.fail().add("emp_error",empError );
			
		}
	
		employeeService.updateEmp(employee);
	
		return Message.success();
		
		
		
	}

	public Map<String, ? super String> VaildEmployee(BindingResult bindingResult) {
		Map<String, ? super String> map=new HashMap<>();
		
		 if(bindingResult.hasErrors()){
			 
			  bindingResult.getFieldErrors().forEach((x)->map.put(x.getField(), x.getDefaultMessage()));
			  
		 }
		 
         return map;		 
		 
	}
	
	

 /**
  * 根据 id 单个删除
  * 以及合并删除
  * @param empId
  * @return
  */
	@ResponseBody
	@RequestMapping(value="/emp/id/{empIds}",method=RequestMethod.DELETE)
	public Message deleteEmp(@PathVariable(value="empIds") String empIds){
		 
		
		    //遍历 找到 所有的 员工id
		 employeeService.deleteEmpsByIds(
			  Arrays.stream(empIds.split(","))
			        .map(Integer::valueOf)
			        .collect(Collectors.toList())); 
		        
		  
		  return Message.success();
		
	}
	
	
	
	/**\
	 * 
	 * 
	 * 批量删除员工
	 */
	
	@ResponseBody
	//@RequestMapping(value="/emps/id")
	public Message deleteEmpsByIds(List<Integer> empIds){
		
		
		employeeService.deleteEmpsByIds(empIds);
		
		return Message.success();
		
	}
	
	
	
	
	
}


