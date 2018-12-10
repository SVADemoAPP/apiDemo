package com.bis.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

import com.bis.common.conf.Params;
import com.bis.dao.LocationDao;
import com.bis.dao.MapMngDao;
import com.bis.dao.MarketDao;
import com.bis.dao.ShopDao;
import com.bis.dao.StatisticsDao;
import com.bis.dao.VisitorDao;
import com.bis.model.AreaModel;
import com.bis.model.GlobalModel;
import com.bis.model.IvasSvaModel;
import com.bis.model.LocationModel;
import com.bis.model.MapBorderModel;
import com.bis.model.MarketModel;
import com.bis.model.NewUserModel;
import com.bis.model.ShopModel;
import com.bis.model.SvaModel;
import com.bis.model.TrendAllModel;
import com.bis.model.TrendMapModel;
import com.bis.model.TrendShopModel;
import com.bis.model.VisitTimeModel;
import com.bis.service.CleanTableService;
import com.bis.service.DataAnalysisService;
import com.bis.service.SubscriptionService;
import com.bis.web.auth.PeripheryService;

import net.sf.json.JSONObject;

public class QuartzJob {

    @Value("${mysql.db}")
    private String db;


    @Autowired
    private SubscriptionService service;

    @Value("${sva.subscriptionType}")
    private int subscriptionType;

    @Value("${sva.subscriptionUrl}")
    private int subscriptionUrl;

    @Value("${sva.subivasurl1}")
    private String subivasurl1;

    @Value("${sva.subivasurl2}")
    private String subivasurl2;

    @Value("${sva.ftpIp}")
    private String ftpIp;

    @Value("${sva.ftpPort}")
    private int ftpPort;

    @Value("${sva.ftpUserName}")
    private String ftpUserName;

    @Value("${sva.ftpPassWord}")
    private String ftpPassWord;

    @Value("${sva.ftpRemotePath}")
    private String ftpRemotePath;

    @Value("${sva.ftpFileNameHeader}")
    private String ftpFileNameHeader;

    @Value("${sva.ftpType}")
    private int ftpType;

    @Value("${sva.subTimes}")
    private int subTimes;
    
    @Autowired
    private GlobalModel globalModel;

    private static final Logger LOG = Logger.getLogger(QuartzJob.class);

    /**
     * @Title: doCreateTable
     * @Description: 动态创建位置数据表任务处理器
     */
    public void doCreateTable() {
        //初始化map边界配置文件
        initMapBorders();
        // System.out.println("定时任务：启动服务器时doCreateTable");
        String tableName = "bi_location_" + Util.dateFormat(new Date(), "yyyyMMdd");
        Calendar cal = Calendar.getInstance();
        cal.add(5, 1);
        String time = Util.dateFormat(cal.getTime(), "yyyyMMdd");
        String tableNameTommorrow = "bi_location_" + time;
        try {
            if (statisticsDao.isTableExist(tableName, this.db) < 1) {
                LOG.info("create table today:" + tableName);

                statisticsDao.createTable(tableName);
            }

            if (this.statisticsDao.isTableExist(tableNameTommorrow, this.db) < 1) {
                LOG.info("create table tommorrow:" + tableName);

                statisticsDao.createTable(tableNameTommorrow);
            }
        } catch (Exception e) {
            LOG.error(e);
        }
        // 店铺表
        String nowMouths = Util.dateFormat(new Date(), Params.YYYYMM);
        String shopTableName = Params.SHOPLOCATION + nowMouths;
        try {
            // 创建shop表
            if (statisticsDao.isTableExist(shopTableName, db) < 1) {
                LOG.info("create" + shopTableName);
                // 动态创建表
                statisticsDao.createShopTable(shopTableName);
            }
        } catch (Exception e) {
            LOG.error(e);
        }
        // 商场表
        String storeTableName = Params.STORELOCATION + nowMouths;
        try {
            // 创建shop表
            if (statisticsDao.isTableExist(storeTableName, db) < 1) {
                LOG.info("create" + storeTableName);
                // 动态创建表
                statisticsDao.createStoreTable(storeTableName);
            }
        } catch (Exception e) {
            LOG.error(e);
        }

        String localPath = getClass().getResource("/").getPath();
        // String localPath = System.getProperty("user.dir");
        // localPath = localPath.substring(0,
        // localPath.indexOf("bin"))+"webapps/SVAProject/WEB-INF";
        localPath = localPath.substring(0, localPath.indexOf("/classes"));
        System.out.println(localPath);
        localPath = localPath + File.separator + "ftp" + File.separator;
        File file = new File(localPath, "lac.txt");
        if (file.exists()) {
            List<JSONObject> list = new ArrayList<>();
            String[] names = Params.LAC_COLUMNS;
            BufferedReader reader = null;
            InputStreamReader isr = null;
            try {
                isr = new InputStreamReader(new FileInputStream(file), "gbk");
                reader = new BufferedReader(isr);
                String tempString = null;
                // 一次读入一行，直到读入null为文件结束
                while ((tempString = reader.readLine()) != null) {
                    JSONObject jsonObject = new JSONObject();
                    String[] values = tempString.replace("|", "_").split("_");
                    for (int i = 0; i < names.length; i++) {
                        jsonObject.put(names[i], values[i]);
                    }
                    jsonObject.put("time", time);
                    list.add(jsonObject);
                }
                reader.close();
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                if (isr != null) {
                    try {
                        isr.close();
                    } catch (IOException e1) {
                    }
                }
                if (reader != null) {
                    try {
                        reader.close();
                    } catch (IOException e1) {
                    }
                }
            }
            visitorDao.clearData1();
            visitorDao.saveData1(list);
        }

        // 数据库清理
        cleanTableService.cleanTableInDb();
    }


    public void deleteTable() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, -7);
        String time = Util.dateFormat(calendar.getTime(), Params.YYYYMMddHH00);
        String deletSql = "delete from bi_static_floor_visittime where time <  '" + time + "'";
        String deletSql1 = "delete from bi_static_shop_visittime where time <  '" + time + "'";
        String deletSql2 = "delete from bi_static_store_visittime where time <  '" + time + "'";
    }

}
