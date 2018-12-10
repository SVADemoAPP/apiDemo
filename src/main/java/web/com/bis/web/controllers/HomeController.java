package com.bis.web.controllers;

import java.util.Locale;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContext;
import com.bis.web.auth.AuthPassport;

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

    /**
     * @Title: showSvaMng
     * @Description: 商场管理页面
     * @param model
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/storeMng", method = { RequestMethod.GET })
    public String showSvaMng(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("infoMng", true);
        model.addAttribute("storeMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/storeConfig";
    }

    /**
     * @Title: showMapMng
     * @Description: 地图管理页面
     * @param model
     * @param info
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/mapMng", method = { RequestMethod.GET })
    public String showMapMng(Model model, @RequestParam(value = "info", required = false) String info) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("mapMngModel", true);
        model.addAttribute("infoMng", true);
        model.addAttribute("mapMng", true);
        model.addAttribute("info", info);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/mapConfig";
    }

    /**
     * @Title: showCategoryMng
     * @Description: 店铺分类管理页面
     * @param model
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/categoryMng", method = { RequestMethod.GET })
    public String showCategoryMng(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("infoMng", true);
        model.addAttribute("categoryMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/categoryConfig";
    }

    /**
     * @Title: showShopMng
     * @Description: 店铺管理页面
     * @param model
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/shopMng", method = { RequestMethod.GET })
    public String showShopMng(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("infoMng", true);
        model.addAttribute("InputMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/shopConfig";
    }

    /**
     * @Title: showShopMng
     * @Description: 店铺管理页面
     * @param model
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/ticketMng", method = { RequestMethod.GET })
    public String showTicket(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("infoMng", true);
        model.addAttribute("InputMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/ticketConfig";
    }

    @AuthPassport
    @RequestMapping(value = "/mixingMng", method = { RequestMethod.GET })
    public String showMixing(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        model.addAttribute("infoMng", true);
        model.addAttribute("InputMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "config/mixingConfig";
    }

    /**
     * @Title: showShop
     * @Description: 店铺分析数据展示页面
     * @param response
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/shop", method = { RequestMethod.GET })
    public String showShop(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("infoMng", true);
        // model.addAttribute("InputMng", true);
        // model.addAttribute("cpu",si.getCpuRatioForWindows());
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "shop";
    }

    @AuthPassport
    @RequestMapping(value = "/floor", method = { RequestMethod.GET })
    public String showFloor(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        model.addAttribute("infoMng", true);
        model.addAttribute("InputMng", true);
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        // model.addAttribute("cpu",si.getCpuRatioForWindows());
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        return "floor";
    }

    /**
     * @Title: showUser
     * @Description: 用户画像页面
     * @return
     */
    @AuthPassport
    @RequestMapping(value = "/operation", method = { RequestMethod.GET })
    public String showUser(Model model) {
        // SystemInfo si = new SystemInfo();
        // int r = dao.selectCount();
        // long b = System.currentTimeMillis();
        // if(r==0){
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }else {
        // long a = dao.selectTimeById()+30000;
        // if(b<=a){
        // int c = dao.selectParameter();
        // model.addAttribute("cpu", c);
        // }else{
        // int d = si.getCpuRatioForWindows();
        // model.addAttribute("cpu", d);
        // dao.saveCpu(d,b);
        // }
        // }
        // if(r>2){
        // long e = dao.selectMinId();
        // dao.deleteCount(e);
        // }
        // model.addAttribute("memory", si.getEMS());
        // model.addAttribute("diskspace",si.getDisk());
        // model.addAttribute("cpu", SystemInfo.cpu());
        // model.addAttribute("memory", SystemInfo.memory());
        // model.addAttribute("diskspace", SystemInfo.file());
        return "operation";
    }

    @AuthPassport
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

    @AuthPassport
    @RequestMapping(value = "/market2", method = { RequestMethod.GET })
    public String showMarket(Model model) {
        return "market2";
    }

    @RequestMapping(value = "/login1", method = { RequestMethod.GET })
    public String login1(Model model) {
        return "market";
    }
}
