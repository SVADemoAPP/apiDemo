var ip = "",
	port = "",
	username = "",
	password = "",
	cellId = "",
	rate = "";
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
	
	var initChart = function(){
		// 获取数据
		$.post("/mie/home/getData",{ip:ip, port:port, username:username, password:password, cellId:cellId},function(data){
			if(data.data){
				
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