package com.bis.web.auth;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.net.URLConnection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.io.FileReader;
import net.sf.json.JSONArray;
import net.sf.json.JSONException;
import net.sf.json.JSONObject;

public class WeatherInfo {
	static WeatherInfo wi = new WeatherInfo();
	
    private static StringBuilder sb;
    private static BufferedReader br; 
	public  String json(String cityName) throws Exception{
		
		//参数url化
		String city = java.net.URLEncoder.encode(cityName, "utf-8");
		
		//拼地址
		String apiUrl = String.format("http://www.sojson.com/open/api/weather/json.shtml?city=%s",city);
		//开始请求
		URL url= new URL(apiUrl);
		URLConnection open = url.openConnection();
		try { 
            br = new BufferedReader(new InputStreamReader( 
            		open.getInputStream(), "UTF-8")); 
            sb = new StringBuilder(); 
            String line = null; 
            while ((line = br.readLine()) != null) 
                sb.append(line); 
        } catch (SocketTimeoutException e) { 
            System.out.println("连接超时"); 
        } catch (FileNotFoundException e) { 
            System.out.println("加载文件出错"); 
        } 		
            String datas = sb.toString();          
          return datas;  
	}

}
