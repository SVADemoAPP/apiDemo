var ip = "",
	port = "",
	username = "",
	password = "",
	cellId = "",
	rate = "";

var upUsageChart = null,
	downUsageChart = null,
	activeUser = null,
	upAvgSense = null,
	upMCSAvg = null;

var refreshInter = null;

var Home = function() {
	var launchFullScreen = function (el) {           
	    if ((document.fullScreenElement && document.fullScreenElement !== null) || (!document.mozFullScreen && !document.webkitIsFullScreen)) { 
	        $('body').addClass("full-screen");
	        if (document.documentElement.requestFullScreen) {
	          document.documentElement.requestFullScreen();
	        } else if (document.documentElement.mozRequestFullScreen) {
	          document.documentElement.mozRequestFullScreen();
	        } else if (document.documentElement.webkitRequestFullScreen) {
	          document.documentElement.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);
	        }
	    } else {
	        $('body').removeClass("full-screen");
	        if (document.cancelFullScreen) {
	          document.cancelFullScreen();
	        } else if (document.mozCancelFullScreen) {
	          document.mozCancelFullScreen();
	        } else if (document.webkitCancelFullScreen) {
	          document.webkitCancelFullScreen();
	        }
	    }
	};
	
	var formatData = function(data){
		var result = {};
		// 转化成JSON对象
		var temp = JSON.parse(data);
		var d = new Date();
		for(var k in temp){
			var v = Math.round(temp[k] * 100) / 100;
			result[k] = {name:dateFormat(d, "yyyy/MM/dd HH:mm:ss"), value:v, append:"", time:d.getTime()};
			if(k == "ucULRbRate"){
				result[k]["append"] = "%";
			}else if(k == "ulULCellTraffic" || k == "ulULActiveUserAvgRate"){
				result[k]["append"] = "kbps";
			}else if(k == "ULCellInterference"){
				result[k]["append"] = "dBm";
			}
		}
		
		return result;
	};
	
	var refresh = function(){
		// 获取数据
		var param = {ip:ip, port:port, username:username, password:password, cellId:cellId};
		$.ajax({
            "dataType": 'json', 
            'contentType' : 'application/json',
            "type": "POST", 
            "url": "/mie/home/getData", 
            "data": JSON.stringify(param), 
            "success": function(res){
				if(res.data){
					var fresh = formatData(res.data);
					
					$("#downUsage").html(fresh.ulULCellTraffic.value + fresh.ulULCellTraffic.append);
					$("#activeUser").html(fresh.ULCellInterference.value + fresh.ULCellInterference.append);
					$("#upUserSense").html(fresh.ulULActiveUserAvgRate.value + fresh.ulULActiveUserAvgRate.append);
					$("#upMCS").html(fresh.ucULAvgMcs.value + fresh.ucULAvgMcs.append);
					$("#upUsage").html(fresh.ucULRbRate.value + fresh.ucULRbRate.append);
					
					var op1 = upUsageChart.getOption(),
						op2 = downUsageChart.getOption(),
						op3 = activeUser.getOption(),
						op4 = upAvgSense.getOption(),
						op5 = upMCSAvg.getOption();
					
					if(op1.xAxis[0].data.length >= 1000/parseInt(rate)){
						op1.series[0].data.shift();
						op2.series[0].data.shift();
						op3.series[0].data.shift();
						op4.series[0].data.shift();
						op5.series[0].data.shift();
						
						op1.xAxis[0].data.shift();
						op2.xAxis[0].data.shift();
						op3.xAxis[0].data.shift();
						op4.xAxis[0].data.shift();
						op5.xAxis[0].data.shift();
					}
					
					op1.xAxis[0].data.push(fresh.ucULRbRate.name);
					op1.series[0].data.push(fresh.ucULRbRate);
					op2.xAxis[0].data.push(fresh.ulULCellTraffic.name);
					op2.series[0].data.push(fresh.ulULCellTraffic);
					op3.xAxis[0].data.push(fresh.ULCellInterference.name);
					op3.series[0].data.push(fresh.ULCellInterference);
					op4.xAxis[0].data.push(fresh.ulULActiveUserAvgRate.name);
					op4.series[0].data.push(fresh.ulULActiveUserAvgRate);
					op5.xAxis[0].data.push(fresh.ucULAvgMcs.name);
					op5.series[0].data.push(fresh.ucULAvgMcs);
					
					upUsageChart.setOption(op1); 
					downUsageChart.setOption(op2); 
					activeUser.setOption(op3); 
					upAvgSense.setOption(op4); 
					upMCSAvg.setOption(op5); 
					
				}else{
					alert("no data");
				}
            }
		});
	};
	
	var initChart = function(){
		if(!upUsageChart){
			upUsageChart = echarts.init(document.getElementById('upUsageChart')),
			downUsageChart = echarts.init(document.getElementById('downUsageChart')),
			activeUser = echarts.init(document.getElementById('activeUserChart')),
			upAvgSense = echarts.init(document.getElementById('upUserSenseChart')),
			upMCSAvg = echarts.init(document.getElementById('UpMCSChart'));
		}
		// 获取数据
		var param = {ip:ip, port:port, username:username, password:password, cellId:cellId};
		$.ajax({
            "dataType": 'json', 
            'contentType' : 'application/json',
            "type": "POST", 
            "url": "/mie/home/getData", 
            "data": JSON.stringify(param), 
            "success": function(res){
				if(res.data){
					var fresh = formatData(res.data);
					
					$("#downUsage").html(fresh.ulULCellTraffic.value + fresh.ulULCellTraffic.append);
					$("#activeUser").html(fresh.ULCellInterference.value + fresh.ULCellInterference.append);
					$("#upUserSense").html(fresh.ulULActiveUserAvgRate.value + fresh.ulULActiveUserAvgRate.append);
					$("#upMCS").html(fresh.ucULAvgMcs.value + fresh.ucULAvgMcs.append);
					$("#upUsage").html(fresh.ucULRbRate.value + fresh.ucULRbRate.append);
					
					var option = {
						    tooltip: {
						        trigger: 'axis',
						        formatter: function (params) {
						            params = params[0];
						            return params.name + ' : ' + params.value + params.data.append;
						        },
						        axisPointer: {
						            animation: false
						        }
						    },
						    xAxis: {
						        type: 'category',
						        splitLine: {
						            show: false
						        },
						        data:[fresh.ucULRbRate.name]
						    },
						    yAxis: {
						        type: 'value',
						        boundaryGap: [0, '100%'],
						        splitLine: {
						            show: false
						        }
						    },
						    series: [{
						        type: 'line',
						        showSymbol: false,
						        hoverAnimation: false,
						        lineStyle: {
						            color:"#61a0a8",
						            width:1
						        },
						        areaStyle: {
						            color:"#61a0a8",
						            opacity:0.5
						        }
						    }]
						};
					
					downUsageChart.setOption(option);
					activeUser.setOption(option);
					upAvgSense.setOption(option);
					upMCSAvg.setOption(option);
					upUsageChart.setOption(option);
					
					downUsageChart.setOption({
				        series: [{
				            data: [fresh.ulULCellTraffic]
				        }]
				    }); 
					activeUser.setOption({
				        series: [{
				            data: [fresh.ULCellInterference]
				        }]
				    }); 
					upAvgSense.setOption({
				        series: [{
				            data: [fresh.ulULActiveUserAvgRate]
				        }]
				    }); 
					upMCSAvg.setOption({
				        series: [{
				            data: [fresh.ucULAvgMcs]
				        }]
				    }); 
					upUsageChart.setOption({
				        series: [{
				            data: [fresh.ucULRbRate]
				        }]
				    }); 
					
					refreshInter = setInterval(function(){
						refresh();
					}, parseInt(rate)*1000);
					
				}else{
					alert("no data");
				}
            }
		});
	}
	
	var showConfig = function(){
		$("#toolModal").modal("show");
	};
	
	var bindEvent = function(){
		//full screen
        $('a.full-screen').click(function(el) {
            launchFullScreen();
        });
        
        // 配置项
        $("#toolBox").on("click",function(e){
        	$("#ip").val(ip);
        	$("#port").val(port);
        	$("#username").val(username);
        	$("#password").val(password);
        	$("#cellId").val(cellId);
        	$("#refreshRate").val(rate);
        	$("#toolModal").modal("show");
        });
        
        // 确认按钮
        $("#confirm").on("click",function(e){
        	var ipTemp = $("#ip").val(),
        		portTemp = $("#port").val(),
        		usernameTemp = $("#username").val(),
        		passwordTemp = $("#password").val(),
        		cellIdTemp = $("#cellId").val(),
        		rateTemp = $("#refreshRate").val();
        	
        	if(ipTemp == "" || portTemp == "" || usernameTemp == "" || passwordTemp == "" || cellIdTemp == "" || rateTemp == ""){
        		return false;
        	}else{
        		// 赋值
        		ip = ipTemp;
        		port = portTemp;
        		username = usernameTemp;
        		password = passwordTemp;
        		cellId = cellIdTemp;
        		rate = rateTemp;
        		
        		// 刷新
        		/*
        		if(refreshInter){
        			clearInterval(refreshInter);
        			refreshInter = setInterval(function(){
    					refresh();
    				}, parseInt(rate)*1000);
        		}else{
        			initChart();
        		}*/
        		
        		if(refreshInter){
        			clearInterval(refreshInter);
        		}
        		initChart();
        	}
        });
        
        // 关闭按钮
        $("#close").on("click",function(e){
        	$("#ip").val(ip);
        	$("#port").val(port);
        	$("#username").val(username);
        	$("#password").val(password);
        	$("#cellId").val(cellId);
        	$("#refreshRate").val(rate);
        });
	};
	
	return {
		// 初始化
		init: function(){
			// 绑定事件
			bindEvent();
			// 弹出配置框
			showConfig();
		}
	};
}();