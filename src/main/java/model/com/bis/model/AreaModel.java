package com.bis.model;

/**
 * @ClassName: AreaModel
 * @Description: 店铺model
 * @author JunWang
 * @date 2017年6月19日 上午9:57:07
 * 
 */
public class AreaModel {

    /**
     * @Fields id : 主键
     */
    private int id;

    /**
     * @Fields shopName : 店铺名称
     */
    private String shopName;

    /**
     * @Fields mapId : mapId
     */
    private String mapId;

    /**
     * @Fields description : 店铺描述
     */
    private String description;

    /**
     * @Fields ySpot : x
     */
    private double ySpot;

    /**
     * @Fields xSpot : y
     */
    private double xSpot;

    /**
     * @Fields x1Spot : x1
     */
    private double x1Spot;

    /**
     * @Fields y1Spot : y1
     */
    private double y1Spot;

    /**
     * @Fields status : 状态
     */
    private int status;

    /**
     * @Fields zoneId : zoneId
     */
    private int zoneId;

    /**
     * @Fields isVip : 是否ip
     */
    private String isVip;

    /**
     * @Fields categoryid : 类别
     */
    private int categoryid;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }

    public String getMapId() {
        return mapId;
    }

    public void setMapId(String mapId) {
        this.mapId = mapId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getySpot() {
        return ySpot;
    }

    public void setySpot(double ySpot) {
        this.ySpot = ySpot;
    }

    public double getxSpot() {
        return xSpot;
    }

    public void setxSpot(double xSpot) {
        this.xSpot = xSpot;
    }

    public double getX1Spot() {
        return x1Spot;
    }

    public void setX1Spot(double x1Spot) {
        this.x1Spot = x1Spot;
    }

    public double getY1Spot() {
        return y1Spot;
    }

    public void setY1Spot(double y1Spot) {
        this.y1Spot = y1Spot;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getZoneId() {
        return zoneId;
    }

    public void setZoneId(int zoneId) {
        this.zoneId = zoneId;
    }

    public String getIsVip() {
        return isVip;
    }

    public void setIsVip(String isVip) {
        this.isVip = isVip;
    }

    public int getCategoryid() {
        return categoryid;
    }

    public void setCategoryid(int categoryid) {
        this.categoryid = categoryid;
    }

}
