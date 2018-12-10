package com.bis.web.auth;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

public class AuthInterceptor extends HandlerInterceptorAdapter
{

    @Override
    public boolean preHandle(HttpServletRequest request,
            HttpServletResponse response, Object handler) throws Exception
    {

        if (handler.getClass().isAssignableFrom(HandlerMethod.class))
        {
            AuthPassport authPassport = ((HandlerMethod) handler)
                    .getMethodAnnotation(AuthPassport.class);

            // 没有声明需要权限,或者声明不验证权限
            if (authPassport == null || !authPassport.validate())
            {
                return true;
            }
            else{
                String username = (String) (request.getSession()
                        .getAttribute("userName"));
                if (username==null) {
                    response.sendRedirect("/sva/home/login");
                    return false;
                }else
                {
                    return true;
                }
                }
        }
        else
        {
            return true;
        }
    }
    
}
