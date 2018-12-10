/*
  # 描述：时间格式化
  # @param date Date 时间
  # @param format String 格式
  # @return 格式化时间
  # eg:
  # "yyyy-MM-DD HH:mm:ss.S"
  # "yyyy-MM-DD hh:mm:ss.S"
  # "yyyy-MM-DD hh:mm:ss"
 */
var dateFormat = function(date, fmt) {
	var k, o, v;

	o = {
		"M+" : date.getMonth() + 1,
		"d+" : date.getDate(),
		"h+" : date.getHours() % 12 === 0 ? 12 : date.getHours() % 12,
		"H+" : date.getHours(),
		"m+" : date.getMinutes(),
		"s+" : date.getSeconds(),
		"q+" : Math.floor((date.getMonth() + 3) / 3),
		"S" : date.getMilliseconds()
	};
	if (/(y+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, (date.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	}
	for (k in o) {
		v = o[k];
		if (new RegExp("(" + k + ")").test(fmt)) {
			fmt = fmt.replace(RegExp.$1, RegExp.$1.length === 1 ? o[k]
					: ("00" + o[k]).substr(("" + o[k]).length));
		}
	}
	return fmt;
};

function HtmlDecode2(str) {
	var str1 = str.replace(/&lt;/g, "<");
	var str2 = str1.replace(/&gt;/g, ">");
	var str3 = str2.replace(/&amp;/g, "&");
	var str4 = str3.replace(/&quot;/g, "\"");
	var str5 = str4.replace(/&apos;/g, "\'");
	return str5;
}

function showWeatherIcons(data) {
	// ------------- Weather icons -------------//
	var today = new Skycons({
		"color" : colours.white,
		"resizeClear" : true
	});
	today.set("weather-now", getWeatherKey(data[0].split(" ")[0]));
	today.play();
	// set forecast icons too
	var forecast = new Skycons({
		"color" : colours.dark,
		"resizeClear" : true
	});
	forecast.set("forecast-now", getWeatherKey(data[1].split(" ")[0]));
	forecast.set("forecast-day1", getWeatherKey(data[2].split(" ")[0]));
	forecast.set("forecast-day2", getWeatherKey(data[3].split(" ")[0]));
	forecast.set("forecast-day3", getWeatherKey(data[4].split(" ")[0]));
	forecast.play();
}

function getWeatherKey(str) {
	if (str.indexOf("雨")>=0) {
		if (str.indexOf("雪")>=0) {
			return "sleet";
		}
		return "rain";
	} else if (str.indexOf("雪")>=0) {
		return "snow";
	} else if (str.indexOf("阴")>=0) {
		return "partly-cloudy-day";
	} else if (str.indexOf("云")>=0) {
		return "cloudy";
	} else if (str.indexOf("风")>=0) {
		return "wind";
	} else if (str.indexOf("雾")>=0) {
		return "fog";
	}
	return "clear-day";
}

Date.prototype.format = function(fmt) {
	var o = {
		"M+" : this.getMonth() + 1, // 月份
		"d+" : this.getDate(), // 日
		"h+" : this.getHours(), // 小时
		"m+" : this.getMinutes(), // 分
		"s+" : this.getSeconds(), // 秒
		"q+" : Math.floor((this.getMonth() + 3) / 3), // 季度
		"S" : this.getMilliseconds()
	// 毫秒
	};
	if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	for ( var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k])
					: (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}
function HtmlDecode3(str) {
	var str1 = str.replace(/</g, "&lt;");
	var str2 = str1.replace(/>/g, "&gt;");
	return str2;
}

/*
 * # 描述：给数字字符串补零，不支持负数 # @param num 待补全的数字 # @param fill 补全的长度 # @return 处理后的字符串
 */
function addZeroFromLeft(num, fill) {
	var len = ('' + num).length;
	return (Array(fill > len ? fill - len + 1 || 0 : 0).join(0) + num);
}

/*
 * # 描述：将ip转为16进制字符串 # @param ip # @return 处理后的字符串
 */
function ipToHex(ip) {
	var arr = ip.split(".");
	var result = "";
	for ( var k in arr) {
		result += addZeroFromLeft(parseInt(arr[k]).toString(16).toUpperCase(),
				2);
	}
	return result;
}
/**
 * @param type
 *            可选pass,notPass
 * @param message
 *            显示信息
 * @param showid
 *            对应Id
 */
function setTip(type, message, showid) {
	$("#" + showid + " ~ i").remove();
	var tip;
	if (type == "pass") {
		tip = "<i class=\"im-checkmark-circle\" data-type=\"tip\" style=\"color: #71b83d;padding: 10px 6px;\">"
				+ message + "!</i>";
	} else {
		tip = "<i class=\"im-cancel-circle\" style=\"color:red; padding: 10px 6px;\" data-type=\"tip\">"
				+ message + "</i>";
	}
	$("#" + showid).parent().append(tip);
}

/**
 * 
 * @param pass
 *            是否通过
 * @param errormsg
 *            错误信息
 * @param showid
 *            对应id
 */
function checkPass(pass, errormsg, showid) {
	$("#" + showid + " ~ i").remove();
	var tip;
	if (pass) {
		tip = "<i class=\"im-checkmark-circle\" data-type=\"tip\" style=\"color: #71b83d;padding: 10px 6px;\">"
				+ "pass" + "</i>";
	} else {
		tip = "<i class=\"im-cancel-circle\" style=\"color:red; padding: 10px 6px;\" data-type=\"tip\">"
				+ errormsg + "</i>";
	}
	$("#" + showid).parent().append(tip);

}

// get the IP addresses associated with an account
function getIPs(callback) {
	var ip_dups = {};
	// compatibility for firefox and chrome
	var RTCPeerConnection = window.RTCPeerConnection
			|| window.mozRTCPeerConnection || window.webkitRTCPeerConnection;
	// bypass naive webrtc blocking
	if (!RTCPeerConnection) {
		var iframe = document.createElement('iframe');
		// invalidate content script
		iframe.sandbox = 'allow-same-origin';
		iframe.style.display = 'none';
		document.body.appendChild(iframe);
		var win = iframe.contentWindow;
		window.RTCPeerConnection = win.RTCPeerConnection;
		window.mozRTCPeerConnection = win.mozRTCPeerConnection;
		window.webkitRTCPeerConnection = win.webkitRTCPeerConnection;
		RTCPeerConnection = window.RTCPeerConnection
				|| window.mozRTCPeerConnection
				|| window.webkitRTCPeerConnection;
	}
	// minimal requirements for data connection
	var mediaConstraints = {
		optional : [ {
			RtpDataChannels : true
		} ]
	};
	// firefox already has a default stun server in about:config
	// media.peerconnection.default_iceservers =
	// [{"url": "stun:stun.services.mozilla.com"}]
	var servers = undefined;
	// add same stun server for chrome
	if (window.webkitRTCPeerConnection) {
		servers = {
			iceServers : [ {
				urls : "stun:stun.services.mozilla.com"
			} ]
		};
	}
	// construct a new RTCPeerConnection
	var pc = new RTCPeerConnection(servers, mediaConstraints);
	// listen for candidate events
	pc.onicecandidate = function(ice) {
		// skip non-candidate events
		if (ice.candidate) {
			// match just the IP address
			var ip_regex = /([0-9]{1,3}(\.[0-9]{1,3}){3})/
			var ip_addr = ip_regex.exec(ice.candidate.candidate)[1];
			// remove duplicates
			if (ip_dups[ip_addr] === undefined)
				callback(ip_addr);
			ip_dups[ip_addr] = true;
		}
	};
	// create a bogus data channel
	pc.createDataChannel("");
	// create an offer sdp
	pc.createOffer(function(result) {
		// trigger the stun server request
		pc.setLocalDescription(result, function() {
		}, function() {
		});
	}, function() {
	});
}