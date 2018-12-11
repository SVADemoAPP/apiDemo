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

var data1 = [],
	data2 = [],
	data3 = [],
	data4 = [],
	data5 = [];

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
		for(var k in temp){
			var v = Math.round(temp[k] * 100) / 100;
			result[k] = {name:dateFormat(new Date(), "yyyy/MM/dd HH:mm:ss"), value:v, append:""};
			if(k == "ucDLPrbRate" || k == "ucULPrbRate"){
				result[k][append] = "%";
			}
		}
		
		return result;
	};
	
	var refresh = function(){
		// 获取数据
		$.post("/mie/home/getData",{ip:ip, port:port, username:username, password:password, cellId:cellId},function(data){
			if(data.data){
				var fresh = formatData(data.data);
				
				$("#upUsage").html(fresh.upUsage);
				$("#downUsage").html(fresh.downUsage);
				$("#activeUser").html(fresh.activeUser);
				$("#upUserSense").html(fresh.upAvgSense);
				$("#upMCS").html(fresh.upMCSAvg);
				
				if(data1.length > 1000/rate){
					data1.shift();
					data2.shift();
					data3.shift();
					data4.shift();
					data5.shift();
				}
				data1.push(fresh.upUsage);
				data2.push(fresh.downUsage);
				data3.push(fresh.activeUser);
				data4.push(fresh.upAvgSense);
				data5.push(fresh.upMCSAvg);
				upUsageChart.setOption({
			        series: [{
			            data: data1
			        }]
			    }); 
				downUsageChart.setOption({
			        series: [{
			            data: data2
			        }]
			    }); 
				activeUser.setOption({
			        series: [{
			            data: data3
			        }]
			    }); 
				upAvgSense.setOption({
			        series: [{
			            data: data4
			        }]
			    }); 
				upMCSAvg.setOption({
			        series: [{
			            data: data5
			        }]
			    }); 
				
			}else{
				alert("no data");
			}
		});
	};
	
	var initChart = function(){
		upUsageChart = echarts.init(document.getElementById('upUsageChart')),
		downUsageChart = echarts.init(document.getElementById('downUsageChart')),
		activeUser = echarts.init(document.getElementById('activeUserChart')),
		upAvgSense = echarts.init(document.getElementById('upUserSenseChart')),
		upMCSAvg = echarts.init(document.getElementById('UpMCSChart'));
		// 获取数据
		$.post("/mie/home/getData",{ip:ip, port:port, username:username, password:password, cellId:cellId},function(data){
			if(data.data){
				var fresh = formatData(data.data);
				
				$("#upUsage").html(fresh.upUsage);
				$("#downUsage").html(fresh.downUsage);
				$("#activeUser").html(fresh.activeUser);
				$("#upUserSense").html(fresh.upAvgSense);
				$("#upMCS").html(fresh.upMCSAvg);
				
				data1.push(fresh.upUsage);
				data2.push(fresh.downUsage);
				data3.push(fresh.activeUser);
				data4.push(fresh.upAvgSense);
				data5.push(fresh.upMCSAvg);
				
				var option = {
					    tooltip: {
					        trigger: 'axis',
					        formatter: function (params) {
					            params = params[0];
					            return params.name + ' : ' + params.value + params.append;
					        },
					        axisPointer: {
					            animation: false
					        }
					    },
					    xAxis: {
					        type: 'time',
					        splitLine: {
					            show: false
					        }
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
				
				upUsageChart.setOption({
			        series: [{
			            data: data1
			        }]
			    }); 
				downUsageChart.setOption({
			        series: [{
			            data: data2
			        }]
			    }); 
				activeUser.setOption({
			        series: [{
			            data: data3
			        }]
			    }); 
				upAvgSense.setOption({
			        series: [{
			            data: data4
			        }]
			    }); 
				upMCSAvg.setOption({
			        series: [{
			            data: data5
			        }]
			    }); 
				
				refreshInter = setInterval(function(){
					refresh();
				}, parseInt(rate)*1000);
				
			}else{
				alert("no data");
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
        		if(refreshInter){
        			clearInterval(refreshInter);
        			refreshInter = setInterval(function(){
    					refresh();
    				}, parseInt(rate)*1000);
        		}else{
        			initChart();
        		}
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