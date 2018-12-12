/**   
 * @Title: SvaService.java 
 * @Package com.sva.service 
 * @Description: 订阅服务 
 * @author labelCS   
 * @date 2016年8月18日 下午4:43:51 
 * @version V1.0   
 */
package com.bis.service;

import java.io.IOException;
import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.util.Map;
import java.util.Random;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import com.bis.model.SvaModel;

/** 
 * @ClassName: SvaService 
 * @Description: 订阅服务
 * @author labelCS 
 * @date 2016年8月18日 下午4:43:51 
 *  
 */
@Service
public class SvaService extends HttpsService {
    /**
     * @Fields log ： 输出日志
     */
    private static final Logger LOG = Logger.getLogger(SvaService.class);
    
    /** 
     * @Fields hasIdType : 向sva订阅时是否要加idType
     */ 
    @Value("${sva.hasIdType}")
    private String hasIdType;
    
    /** 
     * @Fields svaSSLVersion : SVA使用的SSL版本
     */ 
    @Value("${sva.sslVersion}")
    private String svaSSLVersion;
    
    
    /** 
     * @Title: subscribeSva 
     * @Description: 实现sva数据订阅
     * @param sva sva信息
     */
    public String getDataFromSva(SvaModel sva){
        LOG.debug("subscripiton started:"
                + "appName:" + sva.getUsername() 
                + ",ip:" + sva.getIp() 
                + ",port:" + sva.getPort());

        String result = "";
        // 获取token地址
        String url = "https://" + sva.getIp() + ":"
                + sva.getPort() + "/v3/auth/tokens";
        // 获取token参数
        String content = "{\"auth\":{\"identity\":{\"methods\":[\"password\"],\"password\": {\"user\": {\"domain\": \"Api\",\"name\": \""
                + sva.getUsername()
                + "\",\"password\": \""
                + sva.getPassword() + "\"}}}}}";
        String charset = "UTF-8";
        LOG.debug("subscripiton get token cotent:"+content);
        try{
            // 获取token值
            Map<String,String> tokenResult = HttpsService.httpsPost(url, content, charset,"POST", null, svaSSLVersion);
            String token = tokenResult.get("token");
            
            if(StringUtils.isEmpty(token)){
                LOG.debug("subscripiton token got failed:appName:" + sva.getUsername());
                return "";
            }
            LOG.debug("subscripiton token got:"+token);
            
            url = "https://" + sva.getIp() + ":" + sva.getPort()
                        + "/enabler/getwirelessinfo/json/v1.0";
            content = "{\"CELLID\":\"" + sva.getCellId() + "\"" + "}";
            LOG.debug("subscription param:"+content);
            // 获取订阅ID
            Map<String,String> subResult = HttpsService.httpsPost(url, content, charset,"POST", token, svaSSLVersion);
            LOG.debug("subscription result:" + subResult.get("result"));
            
            result = subResult.get("result");
        }
        catch (IOException e)
        {
            LOG.error("subscripiton IOException.", e);
        }
        catch (KeyManagementException e)
        {
            LOG.error("subscripiton KeyManagementException.", e);
        }
        catch (NoSuchAlgorithmException e)
        {
            LOG.error("subscripiton NoSuchAlgorithmException.", e);
        }
        
        return result;
    }
    
    public String getDataFromSvaTest(SvaModel sva){
    	Random random1 = new Random(100);
    	int a = Math.abs(random1.nextInt());
    	float c = Math.abs(random1.nextFloat());
    	
    	Random random2 = new Random(10);
    	int b = Math.abs(random2.nextInt());
    	float d = Math.abs(random2.nextFloat());
    	
    	Random random3 = new Random(1);
    	int e = Math.abs(random3.nextInt());
    	
    	String result = "{\"ucDLPrbRate\":"+a
    			+",\"ucULAvgMcs\":"+b
    			+",\"ucULPrbRate\":"+c
    			+",\"ulULAvgFeelSpeed\":"+d
    			+",\"usActiveUserCnt\":"+e+"}";
    	return result;
    }
}
