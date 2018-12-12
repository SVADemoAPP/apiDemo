<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<html lang="en">
<head>
<meta charset="utf-8">
<title><spring:message code="mall1" /></title>
<!-- Mobile specific metas -->
<meta name="viewport"
	content="width=device-width, initial-scale=1, maximum-scale=1">
<!-- Force IE9 to render in normal mode -->
<!--[if IE]><meta http-equiv="x-ua-compatible" content="IE=9" /><![endif]-->
<meta name="author" content="SuggeElson" />
<meta name="description" content="" />
<meta name="keywords" content="" />
<meta name="application-name" content="sprFlat admin template" />
<!-- Import google fonts - Heading first/ text second -->
<link rel='stylesheet' type='text/css' />
<!--[if lt IE 9]>

<![endif]-->
<!-- Css files -->
<!-- Bootstrap stylesheets (included template modifications) -->
<link href="../css/bootstrap.min.css" rel="stylesheet" />
<link href="../plugins/font-awesome/css/font-awesome.css" rel="stylesheet" />
<!-- Main stylesheets (template main css file) -->
<link href="../css/main.css" rel="stylesheet" />
<link rel="icon" href="../images/header/favicon.ico"
	type="image/png">
<!-- Windows8 touch icon ( http://www.buildmypinnedsite.com/ )-->
<meta name="msapplication-TileColor" content="#3399cc" />
<style>
	.dataLabel{
		height:268px;
		background-color: #f68484; 
		color: white;
	}
	.panel-success {
	   margin-top: 8px;
	}
	.panel-body {
	    padding: 10px !important;
	}
	.panel-heading{
		background-color: #71d398 !important; 
		border:none !important;
	}
	
	.panel-success > .panel-body{
		border: 1px solid #71d398;
	}
	
	.form-group {
	    margin-bottom: 15px !important;
	}
	.control {
	    float: right;
	}
	.control-label {
	    width: 80px;
	    margin-top: 6px;
	}
	
	.logoDiv{
	    font-size: 35px;
        height: 40px;
        width: 50px;
        float: left;
        padding: 15px 0 0 15px;
	}
</style>
</head>
<body>
	<!-- Start #header -->
	<div id="header">
		<div class="container-fluid">
			<div class="navbar">
				<div class="navbar-header">
					<a class="navbar-brand" href="../home/home"> 
						<img src="<c:url value='/images/huawei.png'/>"
						style="margin: 5px 5px 5px 15px; height: 35px;float:left;"></img>
						<div class="logoDiv">DIS</div>
					</a>
				</div>
				<nav class="top-nav" role="navigation">
					<ul class="nav navbar-nav pull-left">
						<li id="toggle-sidebar-li">
							<a href="#" id="toolBox">
								<i class="fa fa-cog fa-2x"></i>
							</a>
						</li>
						<li><a href="#" class="full-screen"><i
								class="fa fa-arrows-alt fa-2x"></i></a></li>
					</ul>
					<ul class="nav navbar-nav pull-right">
						<li class="dropdown"><a
							style="font-size: 15px; font-weight: bold;"
							href="../home/changeLocal?local=zh">中文</a></li>
						<li class="dropdown"><a style="font-size: 15px;"
							href="../home/changeLocal?local=en">English</a></li>
					</ul>
				</nav>
			</div>
		</div>
		<!-- Start .header-inner -->
	</div>
	<!-- End #header -->
	<!-- Start #content -->
	<div id="content">
		<!-- Start .content-wrapper -->
		<div class="content-wrapper">
			<!-- Start .row -->
			<div class="row">
				<!-- Start .page-header -->
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="fa fa-area-chart"></i>
								上行PRB利用率
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
									<div class="tile m0 dataLabel">
										<div class="tile-content text-center clearfix">
											<div class="spark-number">
												<i class="fa fa-group"></i>
											</div>
											<div class="spark clearfix">
												<div id="upUsage" class="percent"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-9">
									<div id="upUsageChart" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading"  style="background-color: #97d3c5; color: white; border-color: #97d3c5">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="fa fa-area-chart"></i>
								下行PRB利用率
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
									<div class="tile m0 dataLabel">
										<div class="tile-content text-center clearfix">
											<div class="spark-number">
												<i class="fa fa-group"></i>
											</div>
											<div class="spark clearfix">
												<div id="downUsage" class="percent"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-9">
									<div id="downUsageChart" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- End .page-header -->
			</div>
			<!-- End .row -->
			<!-- Start .row -->
			<div class="row">
				<!-- Start .page-header -->
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading"  style="background-color: #97d3c5; color: white; border-color: #97d3c5">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="fa fa-area-chart"></i>
								激活用户数
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
									<div class="tile m0 dataLabel">
										<div class="tile-content text-center clearfix">
											<div class="spark-number">
												<i class="fa fa-group"></i>
											</div>
											<div class="spark clearfix">
												<div id="activeUser" class="percent"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-9">
									<div id="activeUserChart" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading"  style="background-color: #97d3c5; color: white; border-color: #97d3c5">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="fa fa-area-chart"></i>
								上行用户平均感知速率
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
									<div class="tile m0 dataLabel">
										<div class="tile-content text-center clearfix">
											<div class="spark-number">
												<i class="fa fa-group"></i>
											</div>
											<div class="spark clearfix">
												<div id="upUserSense" class="percent"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-9">
									<div id="upUserSenseChart" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- End .page-header -->
			</div>
			<!-- End .row -->
			<!-- Start .row -->
			<div class="row">
				<!-- Start .page-header -->
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading"  style="background-color: #97d3c5; color: white; border-color: #97d3c5">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="fa fa-area-chart"></i>
								上行MCS均值
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
									<div class="tile m0 dataLabel">
										<div class="tile-content text-center clearfix">
											<div class="spark-number">
												<i class="fa fa-group"></i>
											</div>
											<div class="spark clearfix">
												<div id="upMCS" class="percent"></div>
											</div>
										</div>
									</div>
								</div>
								<div class="col-lg-9">
									<div id="UpMCSChart" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-lg-6">
					<div class="panel-success toggle">
						<!-- Start .panel -->
						<div class="panel-heading"  style="background-color: #97d3c5; color: white; border-color: #97d3c5">
							<h4 class="panel-title"style="font-size: 15px;color: white;">
								<i class="st-connection-full"></i>
								<spring:message code="mall_shop_visitors"> TOP10</spring:message>
							</h4>
						</div>
						<div class="panel-body" style="">
							<div class="row">
								<div class="col-lg-3">
								</div>
								<div class="col-lg-9">
									<div id="mall_floor_visitors" style="height: 268px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- End .page-header -->
			</div>
			<!-- End .row -->
		</div>
		<!-- End .content-wrapper -->
		<div class="clearfix"></div>
		<!-- Modal -->
        <div class="modal fade" id="toolModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog" style="width:800px;" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h4 class="modal-title" id="myModalLabel">Configure</h4>
                    </div>
                    <div class="modal-body">
                        <div class="row">
			                <form class="form-inline" role="form">
			                  <!-- 左边列开始 -->
			                  <div class="col-md-6">
			                    <div class="form-group">
			                      <label for="" class="control-label">IP：</label>
			                      <div class="control">
			                        <input type="text" class="form-control" id="ip" name="ip">
			                      </div>
			                    </div>
			                    <div class="form-group">
			                      <label for="" class="control-label">PORT：</label>
			                      <div class="control">
			                        <input type="text" class="form-control" id="port" name="port">
			                      </div>
			                    </div>
			                    <div class="form-group">
			                      <label for="" class="control-label">用户名：</label>  
			                      <div class="control">
			                        <input type="text" class="form-control" id="username" name="username">
			                      </div>
			                    </div>
			                    <div class="form-group">
			                      <label for="" class="control-label">密码：</label>
			                      <div class="control">
			                        <input type="password" class="form-control" id="password" autocomplete="off" name="password">
			                      </div>
			                    </div>
			                  </div>
			                  <!-- 左边列结束 -->
			                  <!-- 右边列开始 -->
			                  <div class="col-md-6">
			                  	<div class="form-group">
			                      <label for="Mapid" class="control-label">Cell ID：</label>
			                      <div class="control">
			                        <input type="text" class="form-control" id="cellId" name="cellId">
			                      </div>
			                    </div>
			                    <div class="form-group">
			                      <label for="Mapid" class="control-label">刷新频率：</label>
			                      <div class="control">
			                        <input type="text" class="form-control" id="refreshRate" name="refreshRate">
			                      </div>
			                    </div>
			                  </div>
			                <!-- 右边列结束 -->
			                </form>
			            </div>
                    </div>
                    <div class="modal-footer">
                        <button id="close" type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button id="confirm" type="button" class="btn btn-primary"  data-dismiss="modal">OK</button>
                    </div>
                </div>
                </form>
            </div>
        </div>
	</div>
	<!-- End #content -->
	<!-- Javascripts -->
	<!-- Important javascript libs(put in all pages) -->
	<script src="../plugins/jquery-1.10.2.min.js"></script>
	<!-- Bootstrap plugins -->
	<script src="../plugins/bootstrap.min.js"></script>
	<script src="../plugins/echarts3/echarts4.min.js"></script>
	<script type="text/javascript" src="../js/util.js"></script>
	<script type="text/javascript" src="../js/home.js"></script>
	<script type="text/javascript">
		var passenger = '<spring:message code="passenger"/>';
		var home = '<spring:message code="home"/>';
		var EnteringRate = '<spring:message code="EnteringRate"/>';
		var OverflowRate = '<spring:message code="OverflowRate"/>';
		var echarAverage = '<spring:message code="echart_average"/>';
		var echarMax = '<spring:message code="echart_max"/>';
		var echarMin = '<spring:message code="echart_min"/>';
		var echardanwei = '<spring:message code="echart_danwei"/>';
		var DeepRate = '<spring:message code="DeepRate"/>';
		var operation_count = '<spring:message code="operation_count"/>';
		var objColors, colours;
		$(document).ready(function() {
			Home.init();
						});
	</script>
</body>
</html>