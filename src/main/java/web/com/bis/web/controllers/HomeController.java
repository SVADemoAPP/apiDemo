package com.bis.web.controllers;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContext;

import com.bis.model.SvaModel;
import com.bis.service.SvaService;

/**
 * @ClassName: HomeController
 * @Description: 页面跳转controller
 * @author labelCS
 * @date 2017年6月26日 上午9:13:34
 * 
 */
@Controller
@RequestMapping(value = "/home")
public class HomeController {

    private static final Logger LOG = Logger.getLogger(HomeController.class);

    @Autowired
    private LocaleResolver localeResolver;
    
    @Autowired
    private SvaService service;
    
    /**
     * @Title: showHome
     * @Description: 主页
     * @param model
     * @return
     */
    @RequestMapping(value = "/home", method = { RequestMethod.GET })
    public String showHome(Model model){
    	return "home";
    }
    
    @RequestMapping(value = "/getData", method = {RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> getData(@RequestBody SvaModel requestModel)
    {
    	String res = service.getDataFromSvaTest(requestModel);
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("data", res);
    	return map;
    }

    @RequestMapping(value = "/changeLocal", method = { RequestMethod.GET })
    public String changeLocal(HttpServletRequest request, String local, HttpServletResponse response) {
        if ("zh".equals(local)) {
            localeResolver.setLocale(request, response, Locale.CHINA);
        } else if ("en".equals(local)) {
            localeResolver.setLocale(request, response, Locale.ENGLISH);
        }
        String lastUrl = request.getHeader("Referer");
        String str;
        if (lastUrl.indexOf("?") != -1) {
            str = lastUrl.substring(0, lastUrl.lastIndexOf("?"));
        } else {
            str = lastUrl;
        }
        RequestContext requestContext = new RequestContext(request);

        Locale myLocale = requestContext.getLocale();

        LOG.info(myLocale);

        return "redirect:" + str;
    }

    @RequestMapping(value = "/notfound")
    public ModelAndView notfound() {

        ModelAndView mv = new ModelAndView();
        mv.setViewName("404");

        return mv;
    }
}
