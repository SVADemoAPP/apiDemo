/**   
 * @Title: SubscriptionService.java 
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
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.http.Header;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.bis.common.GlobalConf;
import com.bis.common.Util;
import com.bis.dao.AmqpDao;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

/** 
 * @ClassName: SubscriptionService 
 * @Description: 订阅服务
 * @author labelCS 
 * @date 2016年8月18日 下午4:43:51 
 *  
 */
@Service
public class SubscriptionService extends HttpsService {
    /**
     * @Fields log ： 输出日志
     */
    private static final Logger LOG = Logger.getLogger(SubscriptionService.class);
    

    /**   
     * @Fields amqpDao : amqp对接入库dao   
     */ 
    @Autowired
    private AmqpDao amqpDao;

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
    
    private static final String FLAG1 = "1";
    
    /** 
     * @Title: subscribeSvaInBatch 
     * @Description: 批量订阅sva  
     */
    public void subscribeSvaInBatch(){
        List<SvaModel> svaList = amqpDao.getActiveSva();
        for(SvaModel sm : svaList){
            subscribeSva(sm);
        }
    }
    
    /** 
     * @Title: subscribeSvaPhone 
     * @Description: 实现sva指定用户订阅
     * @param sva: sva信息
     * @param phoneIp: 手机ip
     */
    public void subscribeSvaPhone(SvaModel sva, String phoneIp){

        LOG.debug("subscribeSvaPhone started:"
                + "appName:" + sva.getUsername() 
                + ",ip:" + sva.getIp() 
                + ",port:" + sva.getTokenPort()
                + ",phoneIp:" + phoneIp);
        
        // 获取token地址
        String url = "https://" + sva.getIp() + ":"
                + sva.getTokenPort() + "/v3/auth/tokens";
        // 获取token参数
        String content = "{\"auth\":{\"identity\":{\"methods\":[\"password\"],\"password\": {\"user\": {\"domain\": \"Api\",\"name\": \""
                + sva.getUsername()
                + "\",\"password\": \""
                + sva.getPassword() + "\"}}}}}";
        String charset = "UTF-8";
        
        try{
            // 获取token值
            Map<String,String> tokenResult = HttpsService.httpsPost(url, content, charset,"POST", null, svaSSLVersion);
            String token = tokenResult.get("token");
            sva.setToken(token);
            
            if(StringUtils.isEmpty(token)){
                LOG.debug("subscribeSvaPhone token got failed:appName:" + sva.getUsername());
                return;
            }
            LOG.debug("subscribeSvaPhone token got:"+token);
            
            // 是否需要在订阅参数中加idType
            String idTypeString = "";
            if(FLAG1.equals(hasIdType)){
                idTypeString = ",\"idType\":\""+sva.getIdType()+"\"";
            }
            
            url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                    + "/enabler/catalog/locationstreamreg/json/v1.0";
            content = "{\"APPID\":\"" + sva.getUsername()
                    + "\"" + idTypeString
                    + ",\"useridlist\":[\""
                    + Util.convertMacOrIp(phoneIp)
                    + "\"]}";
            LOG.debug("subscribeSvaPhone param:"+content);
            // 获取订阅ID
            Map<String,String> subResult = HttpsService.httpsPost(url, content, charset,"POST", tokenResult.get("token"),svaSSLVersion);
            LOG.debug("subscribeSvaPhone result:" + subResult.get("result"));
            JSONObject jsonObj = JSONObject.fromObject(subResult.get("result"));
            //判断是否订阅成功,成功为0
            JSONObject svaResult =  jsonObj.getJSONObject("result");
            int svaString = svaResult.getInt("error_code");
            if (0==svaString) {
            JSONArray list = jsonObj.getJSONArray("Subscribe Information");
            JSONObject obj = (JSONObject) list.get(0);
            String queueId = obj.getString("QUEUE_ID");
            LOG.debug("subscribeSvaPhone queueId:" + queueId);
            }
            else{
                LOG.debug("subscribeSvaPhone sva Subscription failed: "+jsonObj);
            }
            
        }
        catch (IOException e)
        {
            LOG.error("IOException.", e);
        }
        catch (KeyManagementException e)
        {
            LOG.error("KeyManagementException.", e);
        }
        catch (NoSuchAlgorithmException e)
        {
            LOG.error("NoSuchAlgorithmException.", e);
        }
    }
    
    
    public void unsubscribeSvaPhone(SvaModel sva, String phoneIp)
    {
        LOG.debug("unsubscribeSvaPhone started!");
        String url = "";
        String content = "";

        try
        {
            // 获取token
            url = "https://" + sva.getIp() + ":"
                    + sva.getTokenPort() + "/v3/auth/tokens";
            content = "{\"auth\":{\"identity\":{\"methods\":[\"password\"],\"password\": {\"user\": {\"domain\": \"Api\",\"name\": \""
                    + sva.getUsername()
                    + "\",\"password\": \""
                    + sva.getPassword() + "\"}}}}}";
            String charset = "UTF-8";
            Map<String,String> tokenResult = HttpsService.httpsPost(url, content, charset,"POST", null, svaSSLVersion);            
            String token = tokenResult.get("token");            
            if(StringUtils.isEmpty(token)){
                LOG.warn("[unsubscribeSvaPhone]token got failed:appName:" + sva.getUsername());
                return;
            }
            LOG.debug("[unsubscribeSvaPhone]token got:"+token);

            // 是否需要在订阅参数中加idType
            String idTypeString = "";
            if(FLAG1.equals(hasIdType)){
                idTypeString = ",\"idType\":\""+sva.getIdType()+"\"";
            }
            
                url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamunreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername()
                + "\"" + idTypeString
                + ",\"useridlist\":[\""
                + Util.convertMacOrIp(phoneIp)
                + "\"]}";
//                content = "{\"APPID\":\"" + sva.getUsername()+ "\""+idTypeString+"}";
                Map<String,String> subResult = HttpsService.httpsPost(url, content,charset, "DELETE", token, svaSSLVersion);
                LOG.debug("[unsubscribeSvaPhone]result:" + subResult.get("result"));
            // 关闭amqp连接
//            GlobalConf.removeAmqpThread(sva.getId());
            LOG.debug("[unsubscribeSvaPhone]connection closed!");

        }
        catch (KeyManagementException e)
        {
            LOG.error("KeyManagementException.", e);
        }
        catch (NoSuchAlgorithmException e)
        {
            LOG.error("NoSuchAlgorithmException.", e);
        }
        catch (IOException e)
        {
            LOG.error("IOException.", e);
        }
        catch (Exception e)
        {
            LOG.error("Exception.", e);
        }
    }
    
    /** 
     * @Title: subscribeSva 
     * @Description: 实现sva数据订阅
     * @param sva sva信息
     */
    public void subscribeSva(SvaModel sva){
        LOG.debug("subscripiton started:"
                + "appName:" + sva.getUsername() 
                + ",ip:" + sva.getIp() 
                + ",port:" + sva.getTokenPort());

        
        // 获取token地址
        String url = "https://" + sva.getIp() + ":"
                + sva.getTokenPort() + "/v3/auth/tokens";
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
            sva.setToken(token);
            
            if(StringUtils.isEmpty(token)){
                LOG.debug("subscripiton token got failed:appName:" + sva.getUsername());
                return;
            }
            LOG.debug("subscripiton token got:"+token);
            
            // 是否需要在订阅参数中加idType
            String idTypeString = "";
            String isIpMac = "0a0a0a0a";
            if (("MAC").equals(sva.getIdType())) {
                isIpMac = "C01ADA2E2BC0";
            }
            if(FLAG1.equals(hasIdType)){
                idTypeString = ",\"idType\":\""+sva.getIdType()+"\"";
            }
            
            // 非匿名化全量订阅
            if (sva.getType() == 0)
            {
                url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername() + "\"" + idTypeString + "}";
            }
            // 匿名化全量订阅
            else if (sva.getType() == 1)
            {
                url = "https://"
                        + sva.getIp()
                        + ":"
                        + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamanonymousreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername() + "\"}";
            }
            // 指定用户订阅
            else if (sva.getType() == 2)
            {
                url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername()+ "\""
                        + idTypeString
                        + ",\"useridlist\":[\""+isIpMac+"\"]}";
            }
            LOG.debug("subscription param:"+content);
            // 获取订阅ID
            Map<String,String> subResult = HttpsService.httpsPost(url, content, charset,"POST", sva.getToken(), svaSSLVersion);
            LOG.debug("subscription result:" + subResult.get("result"));
            JSONObject jsonObj = JSONObject.fromObject(subResult.get("result")); 
            //判断是否订阅成功,成功为0
            JSONObject svaResult =  jsonObj.getJSONObject("result");
            int svaString = svaResult.getInt("error_code");
            if (0==svaString) {
                JSONArray list = jsonObj.getJSONArray("Subscribe Information");
                JSONObject obj = (JSONObject) list.get(0);
                String queueId = obj.getString("QUEUE_ID");
                LOG.debug("subscripiton queueId:" + queueId);
                
                // 如果获取queueId，则进入数据对接逻辑
                if(StringUtils.isNotEmpty(queueId)){
                    AmqpThread at = new AmqpThread(sva,amqpDao,queueId);
                    GlobalConf.addAmqpThread(sva.getId(), at);
                    at.start();
                }else{
                    LOG.debug("subscripiton queueId got failed:appName:" + sva.getUsername());
                }
            }else
            {
                LOG.debug("subscripiton sva Subscription failed: "+jsonObj);
            }
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
    }
    
    /**   
     * @Title: unsubscribe   
     * @Description: 取消订阅    
     * @return: void      
     * @throws   
     */ 
    public void unsubscribe(SvaModel sva)
    {
        LOG.debug("unsubcribe started!");
        if (StringUtils.isNotEmpty(sva.getToken()))
        {
            return;
        }
        String url = "";
        String content = "";

        try
        {
            // 获取token
            url = "https://" + sva.getIp() + ":"
                    + sva.getTokenPort() + "/v3/auth/tokens";
            content = "{\"auth\":{\"identity\":{\"methods\":[\"password\"],\"password\": {\"user\": {\"domain\": \"Api\",\"name\": \""
                    + sva.getUsername()
                    + "\",\"password\": \""
                    + sva.getPassword() + "\"}}}}}";
            String charset = "UTF-8";
            Map<String,String> tokenResult = HttpsService.httpsPost(url, content, charset,"POST", null, svaSSLVersion);  
            String token = tokenResult.get("token"); 
            if(StringUtils.isEmpty(token)){
                LOG.warn("[unsubscribe] token got failed:appName:" + sva.getUsername());
                return;
            }
            LOG.debug("[unsubscribe]token got:"+token);

            // 是否需要在订阅参数中加idType
            String idTypeString = "";
            if(FLAG1.equals(hasIdType)){
                idTypeString = ",\"idType\":\""+sva.getIdType()+"\"";
            }
            
            // 非匿名化取消订阅
            if (sva.getType() == 0){
                url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamunreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername()+ "\""+idTypeString+"}";
                Map<String,String> subResult = HttpsService.httpsPost(url, content,charset, "DELETE", token, svaSSLVersion);
                LOG.debug("[unsubscribe]result:" + subResult.get("result"));
            }else if(sva.getType() == 1){
                // 匿名化取消订阅
                url = "https://" + sva.getIp() + ":" + sva.getTokenPort()
                        + "/enabler/catalog/locationstreamanonymousunreg/json/v1.0";
                content = "{\"APPID\":\"" + sva.getUsername() + "\"}";
                Map<String,String> subResultAnonymous = HttpsService.httpsPost(url, content,charset, "DELETE", token, svaSSLVersion);
                LOG.debug("[unsubscribe]anonymous result:" + subResultAnonymous.get("result"));
            }
            
            // 关闭amqp连接
            GlobalConf.removeAmqpThread(sva.getId());
            LOG.debug("[unsubscribe]connection closed!");

        }
        catch (KeyManagementException e)
        {
            LOG.error("KeyManagementException.", e);
        }
        catch (NoSuchAlgorithmException e)
        {
            LOG.error("NoSuchAlgorithmException.", e);
        }
        catch (IOException e)
        {
            LOG.error("IOException.", e);
        }
        catch (Exception e)
        {
            LOG.error("Exception.", e);
        }
    }
    
    /** 
     * @Title: getIvasToken 
     * @Description: Ivas获取token
     * @param url 地址
     * @param key key
     * @param sign
     * @param body 参数
     * @return 
     */
    public String getIvasToken(String url,String key,String sign,String body)
    {
        String token = null;
        HttpClient httpClient = HttpClients.createDefault();
        HttpPost  httpPost = new HttpPost(url);
        httpPost.setHeader("key",key);
        httpPost.setHeader("sign",sign);
        httpPost.setHeader("Content-Type","application/json");
        StringEntity  se = new StringEntity(body,"utf-8");
        httpPost.setEntity(se);
        LOG.debug("getIvasToken url:"+url+",key:"+key+",sign"+sign+",body:"+body);
        HttpResponse response;
            try {
                response = httpClient.execute(httpPost);
                String result = EntityUtils.toString(response.getEntity());
                Header tokenHeader = response.getFirstHeader("X-Subject-Token");
                System.err.println(tokenHeader==null);
                if (tokenHeader!=null) {
                    token = tokenHeader.getValue();
                }
//                System.out.println(tokenHeader+","+token);
                LOG.debug("getIvasToken status:"+response.getStatusLine().getStatusCode()+",result:"+result+",tokenHeader:"+tokenHeader+",token:"+token);
            } catch (ClientProtocolException e) {
                LOG.debug("getIvasToken error:"+e.getMessage());
            } catch (IOException e) {
                LOG.debug("getIvasToken IO error:"+e.getMessage());
            }
            return token;
    }
    
    /** 
     * @Title: subIvasSva 
     * @Description: 订阅
     * @param url
     * @param key
     * @param sign
     * @param body
     * @param token
     * @param sva 
     */
    public void subIvasSva(String url,String key,String sign,String body,String token,SvaModel sva)
    {
        HttpClient httpClient = HttpClients.createDefault();
        HttpPost  httpPost = new HttpPost(url);
        httpPost.setHeader("key",key);
        httpPost.setHeader("sign",sign);
        httpPost.setHeader("Content-Type","application/json");
        httpPost.setHeader("X-Auth-Token",token);
        StringEntity  se = new StringEntity(body,"utf-8");
        httpPost.setEntity(se);
        LOG.debug("subIvasSva url:"+url+",key:"+key+",sign"+sign+",body:"+body+",token"+token);
        HttpResponse response;
            try {
                response = httpClient.execute(httpPost);
                String result = EntityUtils.toString(response.getEntity());
                System.out.println(result);
                LOG.debug("subIvasSva reslut:"+result);
                JSONObject jsonObj = JSONObject.fromObject(result); 
                //判断是否订阅成功,成功为0
                JSONObject svaResult =  jsonObj.getJSONObject("result");
                int svaString;
                if (svaResult.toString()!="null") {
                    svaString = svaResult.getInt("error_code");
                }else
                {
                    svaString = 1;
                }
                 
                if (0==svaString) {
                    JSONArray list = jsonObj.getJSONArray("Subscribe Information");
                    JSONObject obj = (JSONObject) list.get(0);
                    String queueId = obj.getString("QUEUE_ID");
                    String subIp = obj.getString("BROKER_IP");
                    String broken = obj.getString("BROKER_PORT");
                    sva.setBrokerPort(broken);
                    sva.setIp(subIp);
                    LOG.debug("subIvasSva queueId:" + queueId);
                    
                    // 如果获取queueId，则进入数据对接逻辑
                    if(StringUtils.isNotEmpty(queueId)){
                        AmqpThread at = new AmqpThread(sva,amqpDao,queueId);
                        GlobalConf.addAmqpThread(sva.getId(), at);
                        at.start();
                    }else{
                        LOG.debug("subIvasSva queueId got failed:appName:" + sva.getUsername());
                    }
                }else
                {
                    LOG.debug("subIvasSva sva Subscription failed: "+jsonObj);
                }
            } catch (ClientProtocolException e) {
                LOG.debug("subIvasSva error:"+e.getMessage());
            } catch (IOException e) {
                LOG.debug("subIvasSva IO error:"+e.getMessage());
            }finally {  
//                if (httpClient != null) {  
//                    try {  
//                        response. 
//                    } catch (IOException e) {  
//                        e.printStackTrace();  
//                    }  
//                }  
            } 
    }    
}
