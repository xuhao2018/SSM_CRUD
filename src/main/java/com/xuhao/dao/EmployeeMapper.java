package com.xuhao.dao;

import com.xuhao.bean.Employee;
import com.xuhao.bean.EmployeeExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EmployeeMapper {
    long countByExample(EmployeeExample example);

    int deleteByExample(EmployeeExample example);

    int insert(Employee record);

    int insertSelective(Employee record);

    List<Employee> selectByExample(EmployeeExample example);

    int updateByExampleSelective(@Param("record") Employee record, @Param("example") EmployeeExample example);

    int updateByExample(@Param("record") Employee record, @Param("example") EmployeeExample example);
    
    //查询带有部门信息的 员工信息
     List<Employee> selectByExampleWithDept(EmployeeExample example);
    
   //List<Employee> selectByExampleWithDeptForList(EmployeeExample employeeExample);
    
    
}