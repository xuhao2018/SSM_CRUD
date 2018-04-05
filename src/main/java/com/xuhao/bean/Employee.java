package com.xuhao.bean;

import javax.validation.constraints.Pattern;

import org.hibernate.validator.constraints.Length;
import org.springframework.stereotype.Component;

@Component
public class Employee {
	
	
    private Integer empId;

    //用正则自定义校验规则 
 @Pattern(regexp="(^[a-zA-Z0-9_-]{3,16}$)|(^[\\u2E80-\\u9FFF]{2,5})",message="用户名必须是3-16位字符 或者 2-5位汉字的组合")
    private String empName;

    private String empGender;

    //验证邮箱格式
    @Pattern(regexp="^[A-Za-z0-9\\u4e00-\\u9fa5]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$",message="邮箱格式不正确")
    private String empEmail;

    private Integer deptId;
    
    //希望查询员工的同时，查询部门信息
    private Department department;
    
    
    

    public Department getDepartment() {
		return department;
	}

	public void setDepartment(Department department) {
		this.department = department;
	}

	public Integer getEmpId() {
        return empId;
    }

    public void setEmpId(Integer empId) {
        this.empId = empId;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName == null ? null : empName.trim();
    }

    public String getEmpGender() {
        return empGender;
    }

    public void setEmpGender(String empGender) {
        this.empGender = empGender == null ? null : empGender.trim();
    }

    public String getEmpEmail() {
        return empEmail;
    }

    public void setEmpEmail(String empEmail) {
        this.empEmail = empEmail == null ? null : empEmail.trim();
    }

    public Integer getDeptId() {
        return deptId;
    }

    public void setDeptId(Integer deptId) {
        this.deptId = deptId;
    }

	public Employee(Integer empId, String empName, String empGender, String empEmail, Integer deptId) {
		super();
		this.empId = empId;
		this.empName = empName;
		this.empGender = empGender;
		this.empEmail = empEmail;
		this.deptId = deptId;
	}
    
    
    public  Employee(){}

	@Override
	public String toString() {
		return "Employee [empId=" + empId + ", empName=" + empName + ", empGender=" + empGender + ", empEmail="
				+ empEmail + ", department=" + department + "]";
	}


    
    
    
    
    
    
    
}