package com.bis.web.auth;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import com.bis.common.conf.Params;

import net.sf.json.JSONObject;

public class AppInterceptor extends HandlerInterceptorAdapter {
    // private HashMap<String,String> menuMap = new HashMap<String,String>();
    //
    // public AppInterceptor(){
    // menuMap.put("showStoreMng", "key_storeManage");
    // menuMap.put("showCategoryMng", "key_areaCategory");
    // menuMap.put("showSvaMng", "key_svaManage");
    // menuMap.put("showMapMng", "key_mapManage");
    // menuMap.put("showMsgMng", "key_messagePush");
    // menuMap.put("showInputMng", "key_areaInfo");
    // menuMap.put("showSellerMng", "key_sellerInfo");
    // menuMap.put("showPing", "key_ping");
    // menuMap.put("showHeatmap5", "key_customerPeriodHeamap");
    // menuMap.put("showScattermap", "key_customerScattermap");
    // menuMap.put("showLinemap", "key_CustomerFlowLinemap");
    // menuMap.put("showCodeMng", "key_code");
    // menuMap.put("showEstimate", "key_estimateDeviation");
    // menuMap.put("showBluemix", "key_bluemixConnection");
    // menuMap.put("showpRRU", "key_pRRUConfig");
    // menuMap.put("showDown", "key_versionDownload");
    // }

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
            throws Exception {

        if (handler.getClass().isAssignableFrom(HandlerMethod.class)) {
            AppPassport appPassport = ((HandlerMethod) handler).getMethodAnnotation(AppPassport.class);
            // 没有声明需要权限,或者声明不验证权限
            if (appPassport == null || !appPassport.validate()) {
                return true;
            } else {
                // 验证session是否在登录状态
                Integer id = (Integer) request.getSession().getAttribute("id");
                if (id != null) {
                    return true;
                } else {
                    JSONObject jsonObject = new JSONObject();
                    jsonObject.put("status", Params.RETURN_CODE_301);
                    PrintWriter out = null;
                    try {
                        out = response.getWriter();
                        out.write(jsonObject.toString());
                        out.flush();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    // 拦截掉该请求
                    return false;
                }
            }
        } else {
            return true;
        }
    }

}
