package com.xuhao.bean;
/**
 * 
 * 返回json 数据通用的类
 * 
 * @author admin
 *
 */

import java.util.HashMap;
import java.util.Map;

public class Message {

	private int code; //状态码
	
	private String message;//提示信息
	
	//用户返回给 浏览器的数据
	private Map<String, Object>  map=new HashMap<>();
	
	
	//请求成功
	public static Message success(){
		
		Message message= new Message();
		message.setCode(100);

		message.setMessage("Success");
		
		return message;
	}
	

	//请求失败
	public static Message fail(){
		
		Message message= new Message();
		message.setCode(200);

		message.setMessage("Fail");
		
		return message;
	}
	
	//添加 pageInfo信息
	
	public Message add(String key,Object value){
		
		 this.map.put(key, value);
		 
		 return this;
		
	}
	
	

	public int getCode() {
		return code;
	}

	public void setCode(int code) {
		this.code = code;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}
	

	public void setMap(Map<String, Object> map) {
		this.map = map;
	}


	public Map<String, Object> getMap() {
		return map;
	}
	
	
	
	
	
	
	
}
