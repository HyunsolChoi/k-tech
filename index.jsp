<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*, java.net.*, java.text.*, es.bean.*, org.apache.log4j.*,java.security.*,java.security.spec.*" %>
<%@ page import="com.ktech.popupManager.*, es.search.MetaSearch, com.ktech.conf.Conf"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils, org.apache.commons.lang.StringUtils"%>
<%@ page import="static com.ktech.conf.ConfStatic.*" %>
<%@ page import="static es.util.CommonUtil.*" %>
<%@ include file="include/redirectMobile.jsp" %>
<%
Logger logger = Logger.getLogger("search");

StringBuffer sb = new StringBuffer();
sb.append(path).append("/");
String link = (String)session.getAttribute("link");
if(link == null || link.equals(sb.toString())) {
	session.setAttribute("link",sb.toString());
	sb.setLength(0);
	sb.append(path).append("/mypage/group/");
	link = sb.toString();
}

//DBProc db = new DBProc(dbname);
EventProc db = new EventProc(dbname);

Integer intUser_id = (Integer)session.getAttribute("user_id");
String user_name = (String)session.getAttribute("user_name");
int user_id = 0;
if(intUser_id != null)
	user_id = intUser_id.intValue();

if(user_id != 0) {
	if(!db.getUserPolicyAgree(user_id)) // 개인정보약관 미동의시, 이동
		response.sendRedirect(path+"/login/serviceRule.jsp");
	else{
		sb.setLength(0);
		sb.append(path).append("/mypage/group/");
		response.sendRedirect(sb.toString());
	}
	return;
}

System.out.println("jenkins test 2");

//팝업관련
final String[] week = { "일", "월", "화", "수", "목", "금", "토" };
PopupManagerProc pdb = new PopupManagerProc(dbname);
Date curdate = new Date();
SimpleDateFormat simpleDate = new SimpleDateFormat("yyyy-MM-dd");
String strdate = simpleDate.format(curdate);
List plist = pdb.PopupsInfo(0,strdate); // 팝업 포맷 소스 가져오기 :게시 설정 되어있는 팝업창만 가져옴.

sb.setLength(0);
sb.append("!!! ").append(path).append(" ").append(user_name).append(" ").append(request.getRemoteAddr());
logger.info(sb.toString());

sb.setLength(0);

String loginType = db.getConfigInfo("login_id_type");
if(loginType.equals("2")) {
	sb.append(path).append("/login/authLoginProc.jsp");
}else {
	sb.append(path).append("/login/loginCheck.jsp");
}
String loginProcUrl = sb.toString();

if(loginType == null || loginType.equals("1")) loginType = "basic";

Calendar today = Calendar.getInstance();
String today_date = simpleDate.format(today.getTime());
today_date = today_date.substring(2, 10).replace("-", ".");

//환경변수 로딩을 한번에 처리하여 session에 저장
String reportUserCk = db.getConfigInfo("report_manage");
if(reportUserCk != null) session.setAttribute("report_manage", reportUserCk);

String gradeUserCk = db.getConfigInfo("grade_manage");
if(gradeUserCk != null)	session.setAttribute("grade_manage", gradeUserCk);

String useweeklyLecture = db.getConfigInfo("use_weeklyLecture");
if(useweeklyLecture != null) session.setAttribute("use_weeklyLecture", useweeklyLecture);

String strUseMPM = db.getConfigInfo("useMemberPublicMenu");
if(strUseMPM != null) session.setAttribute("useMemberPublicMenu", strUseMPM);

String user_approval_config = db.getConfigInfo("user_approval"); //등급별 그룹생성 가능 여부
if(user_approval_config != null) session.setAttribute("user_approval", user_approval_config);

String strAttendCheck = db.getConfigInfo("use_attend_check");
if(strAttendCheck != null) session.setAttribute("use_attend_check", strAttendCheck);

String strDataAttendCheck = db.getConfigInfo("useDataAttend");
if(strDataAttendCheck != null) session.setAttribute("use_dataAttend_check", strDataAttendCheck);

String strZoomAttendCheck = db.getConfigInfo("useZoomAttend");
if(strZoomAttendCheck != null) session.setAttribute("use_zoomAttend_check", strZoomAttendCheck);

String strIntergrationAttendCheck = db.getConfigInfo("useIntegrationAttend");
if(strIntergrationAttendCheck != null) session.setAttribute("use_intergrationAttend_check", strIntergrationAttendCheck);

%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" lang="ko" xml:lang="ko" style="overflow:auto;">
<head>	
	<!-- Google Analytics (GA4) -->
	<%@ include file="header.jsp" %>
	<!-- Meta Tags -->
	<title><%=title%></title>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="width=1130" />
	<meta content="IE=9" http-equiv="X-UA-Compatible" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge, chrome=1" />
	<meta http-equiv="Cache-Control" content="no-cache" />
	<meta http-equiv="Expires" content="0" />
	<meta http-equiv="Pragma" content="no-cache" />
	<meta name="robots" content="all" />
	<meta name="og:title" content="<%=hostName%>"/>
	<meta name="og:description" content="<%=title%>"/>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="shortcut icon"  href="<%=path%>/favicon.ico" />
	<script src="<%= path %>/jscss/jquery-1.10.2.js"></script>
	<%-- <script type="text/javascript" src="<%= path %>/jscss/ga.js"></script> --%>
	<link rel="stylesheet" type="text/css" href="<%= path %>/homecss/main.css" />
	
	<link rel="stylesheet" href="<%=path %>/new_skin/css/reset.css" type="text/css"/>
	<link rel="stylesheet" href="<%=path %>/new_skin/css/font.css" type="text/css"/>
	
	<link rel="stylesheet preload" type="text/css" href="<%= path %>/_AXJ/ui/default/AXJ.css">
	<script type="text/javascript" src="<%= path %>/_AXJ/lib/AXJ.js"></script>
	<link rel="stylesheet" type="text/css" href="<%= path %>/_AXJ/ui/default/AXSelect.css" />
	<script type="text/javascript" src="<%= path %>/_AXJ/lib/AXSelect.js"></script>
	<script type="text/javascript">
		var fnObj = {
			pageStart: function(){
	            jQuery("#AXSelect").bindSelect({
	            	maxHeight: 150,
	            	onChange: function(){
	            		if($('#AXSelect').val() == '')
	            			return;
	            		window.open($('#AXSelect').val(), "","");
	            	}
	            });
			}
		}

		var intval="";
		var jbIntval="";
		
		$(document).ready(function(){
			khubIndexResizing();
			startMainBanner();
			startJbnuHotNotice();
			fnObj.pageStart.delay(0.1);
		});

		//창크기 변화 감지
		$(window).resize(function() {
			khubIndexResizing();
		});

		function khubIndexResizing(){
			var w = $( window ).width();
			if(w < 555) { //창 가로크기가 555 보다 작을 경우
				$('#section1').css('display','none');
				$('#banner_left').css('display','none');
			
				$('#footer').css('min-width','555px');
				$('#footer').css('margin-top','70px');
				$('.copybox').css('min-width','555px');
				$('.bottomlogo').css('float','left').css('margin','20px');

			}else{
				$('#section1').css('display','block');
				$('#banner_left').css('display','block');

				$('#footer').css('margin-top','0');
				$('#footer').css('width',$('#section1').width()+560);
				$('#footer').css('background-color','#424854');

				//하단 로고 이미지
				var lw = $('#section1').width()+450
				$('.copybox').css('width', lw+'px');
				$('.bottomlogo').css('float','right').css('margin-top','-80px');
			}

			var h = $( window ).height(); //창 세로크기
			if(w < 555 && $('.bottomlogo img').attr('src') != 'undefined') {
				$('#footer').css('height',220+'px');
				$('#banner_left').css('height',130+'px');
			}
			else {
				$('#footer').css('height',150+'px');
				$('#banner_left').css('height',94+'px');
			}

			var temp = h - $('#footer').height();
			if(w > 1200) //왼쪽 배경화면 크기 키우기
				temp = h - $('#banner_left').height() - $('#footer').height();
				
			if(temp < 600) temp= 600;

			$('#container').css('height',temp+23+'px');
			$('#section1').css('height',temp+23+'px');
			$('#section2').css('height',temp+23+'px');
			
			if(temp < 770) {
				$('#khubbanner').css('display','none');
			}else{
				$('#khubbanner').css('display','block');
			}

			$('#spot_image1').css('height',temp+23+'px');
			$('#spot_image2').css('height',temp+23+'px');
			$('#spot_image3').css('height',temp+23+'px');
//			$('#spot_image4').css('height',temp+'px');
		}

		function startMainBanner(){
			intval==""?intval=window.setInterval("mainslider()",5E3):
			stopMainBanner()
		}
		function stopMainBanner(){
			intval!=""&&(window.clearInterval(intval),intval="")
		}
		var currentMainImage=1,mainImageCnt=1;
		function mainImg(a){
			currentMainImage!=a&&($("#spot_image"+a).css({opacity:0}).addClass("on").animate({opacity:1},1E3),$("#spot_image"+currentMainImage).animate({opacity:0},1E3,function(){$(this).removeClass("on")}),currentMainImage=a,stopMainBanner(),startMainBanner())
		}
		function mainslider(){
			currentMainImage+1>mainImageCnt?mainImg(1):mainImg(currentMainImage+1)
		}
		
		function startJbnuHotNotice(){
			jbIntval==""?jbIntval=window.setInterval("JbNoticeSlider()",5E3):
			stopJbnuHotNotice();
		}
		function stopJbnuHotNotice(){
			jbIntval!=""&&(window.clearInterval(jbIntval),jbIntval="");
		}
		var currentJbMainImage=1,jbMainImageCnt=5;
		function jbMainImg(a){
			currentJbMainImage!=a&&($("#hotnotice_image"+a).css({opacity:0, 'display':'block'}).addClass("on").animate({opacity:1},1E3),$("#hotnotice_image"+currentJbMainImage).css({'display':'none'}).animate({opacity:0},1E3,function(){$(this).removeClass("on")}),currentJbMainImage=a,stopJbnuHotNotice(),startJbnuHotNotice())
		}
		function JbNoticeSlider(){
			currentJbMainImage+1>jbMainImageCnt?jbMainImg(1):jbMainImg(currentJbMainImage+1);
		}

		function lmsGuidePopupOpen(popUrl) { //height:600
			 //window.open(popUrl,'lmsGuidePopup','width=420,height=550,scrollbars=no,status=no,toolbar=no,resizable=no,location=no,menu=no');
			 $.ajax({
				url: popUrl,
				type: 'post',
				param: '',
			    success: function(text){
			    	$('#lmsGuidePopup').html(text);
				 	$("#lmsGuidePopup").fadeIn(200);  // 레이어 열기
			    }
			 });
		}
		function lmsGuidePopupClose() { 
			 $("#lmsGuidePopup").fadeOut(200);  // 레이어 닫기
		}
	</script>
	<script type="text/javascript" >
	<!--
	var kspringOutboundLink = function(url) {
		if(url.indexOf("www.khub.kr") >= 0) {
			window.open(url,"previewPopWin","location=yes,menubar=yes,toolbar=yes,directories=yes,resizable=yes,scrollbars=yes");
			//ga('send', 'event', 'previewPopWin', 'click', url, {
			//	'transport': 'beacon',
			//   'hitCallback': function(){window.open(url,"","location=yes,menubar=yes,toolbar=yes,directories=yes,resizable=yes,scrollbars=yes");}
			//});
		}else{
			window.open(url,"quickMenualWin","location=yes,menubar=yes,toolbar=yes,directories=yes,resizable=yes,scrollbars=yes");
			//ga('send', 'event', 'quickMenualWin', 'click', url, {
			//	'transport': 'beacon',
			//    'hitCallback': function(){window.open(url,"","location=yes,menubar=yes,toolbar=yes,directories=yes,resizable=yes,scrollbars=yes");}
			//});
		}
	}

	function readcookie() {
	   var yourname = document.cookie;
	   var f = document.loginform;
	   f.idsave.checked = false;
	   if(yourname.length > 0) {
		   var ca = document.cookie.split(';');
		   for(var i=0; i<ca.length;i++){
			   	var yourname = ca[i];
	      		if(yourname.indexOf("username=") != -1) {
	        		yourname=yourname.substring(yourname.indexOf("username=")+9,  yourname.length);
	         		if(yourname.length > 0) {
	         			if("<%=loginType%>" == "2"){
	          				f.id.value= yourname;
	         			}else{
	         				f.login.value= yourname;
	         			}
	           			f.idsave.checked = true;
	         		}
	      		}
	      	}
	   }
	}
	function LoginEvent() { // 이벤트
		var url = "<%= path %>/event/visit.jsp";
		var param = "";
		$.ajax({
			url: url,
			type: 'post',
			data: param,
	        success: function(text){
	        	//cb_loginEvent(text);
	        }
		});
	}
	function cb_loginEvent(req) { // 이벤트
		var text = req;
		text = text.replace(/[^\w]/g, "");
		if(text != "")
			window.open("<%=path%>/event/visit_win.jsp?win="+text,"visitEvent","width=430,height=230,toolbar=no,resizable=no,scrollbars=no");
	}
	function check_login_form() {
		var f = document.loginform;
		var loginsave = document.getElementById("loginsave");
		if(f.login.value == ""){
			alert("아이디를 입력해주세요.");
			f.login.focus();
			return;
		}

		var id = f.login.value;
	    /*if(!/^[a-zA-Z0-9@._\-]+$/.test(id))
	    {
	        alert('아이디는 알파벳, 숫자, 문자(@ . - _)만 가능합니다.');
	        f.login.focus();
	        return;
	    }*/

	    if(id.length > 40)
	    {
	        alert('아이디는 최대 40글자까지 입력해주세요.');
	        f.login.focus();
	        return;
	    }

		saveID();

		if(f.passwd.value == ""){
			alert("비밀번호를 입력해주세요.");
			f.passwd.focus();
			return;
		}

		/*if(f.passwd.value.length < 8)
	    {
	        alert('비밀번호는 최소 8글자입니다.');
	        f.passwd.focus();
	        return;
	    }

		if(!/^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,24}$/.test(f.passwd.value))
	    {
	        alert('비밀번호는 대/소문자, 숫자, 특수문자의 조합으로 최소 8자 이상입니다.');
	        f.passwd.focus();
	        return;
	    }*/

		if(loginsave.checked == true)
			loginsave.value = 1;

		var string = $("form[name=loginform]").serialize();

		$.ajax({
			type:"POST",
			url:"<%= loginProcUrl %>",
			data: string,
			success: function(text){
				if(text.indexOf("deadlineMessage") >= 0){
					alert("곧 제출기한, 출결인정기간이 종료되는 자료가 있습니다. 내 강의에서 종료 예정인 리스트를 확인해 주세요.");
					text = text.replace("deadlineMessage", "");
				}
		        cb_login(text);
		    }
		});
	}
	function cb_login(req) {
		if(req.indexOf("newuser") >= 0) {
			location.href="<%=path%>/login/serviceRule.jsp";
		}else if(req.indexOf("moduser") >= 0) {
			location.href="<%=path%>/login/memEdit.jsp";
		}else if(req.indexOf("success") >= 0) {
			if(req.indexOf("mypage") >= 0) location.href="<%=path%>/mypage/";
			else if(req.indexOf("group") >= 0) location.href="<%=path%>/mypage/group/";
			else {
				if(req.replace("success","").length > 0)
					location.href="<%=link%>";
				else
					location.href="<%=path%>/mypage/group/";
			}
		}else{
			alert(req);
			document.loginform.login.focus();
			document.loginform.passwd.value = "";
		}
	}
	function saveID() {
		var f = document.loginform;
	  	var idsave = document.getElementById("idsave");
	  	if (idsave.checked == true) {
			if("<%=loginType%>" == "2"){
				makecookieId(f.id.value);
		  	}else
				makecookieId(f.login.value);
	  	}
	  	else
		   	UnSaveID();
	}
	function UnSaveID() {
		  var todayDate = new Date();
		  todayDate.setDate(todayDate.getDate() + 365);

		  var cookies = document.cookie.split("; ");
		  var tmpCookie = "username=;";
		  for(var i = 0; i < cookies.length; i++){
			  if(cookies.indexOf("username=") != -1) continue;
			  tmpCookie += cookies[i].split("=")[0] + "=" + cookies[i].split("=")[1] + ";"
		  }
		  document.cookie= tmpCookie + "expires="+ todayDate.toGMTString()+";path=/";
	}
	function makecookieId(id) {
		  var todayDate = new Date();
		  todayDate.setDate(todayDate.getDate() + 365);

		  var cookies = document.cookie.split("; ");
		  var tmpCookie = "username="+id + ";";
		  for(var i = 0; i < cookies.length; i++){
			  if(cookies.indexOf("username=") != -1) continue;
		      tmpCookie += cookies[i].split("=")[0] + "=" + cookies[i].split("=")[1] + ";"
		  }
		  document.cookie= tmpCookie + "expires=" + todayDate.toGMTString()+";path=/";
	}
	function keepingLogin() {
		var lk = document.getElementById("loginsave");
		if(lk.checked == true) {
			if(!confirm("자동 로그인 기능을 사용하시겠습니까?\n단, 공공장소(PC방, 학교 등)에서 이용시 개인정보가 유출될 수 있으니 주의하시길 바랍니다.\n로그인 상태를 한 달간 유지하시려면 [확인] 버튼을, 취소를 원하시면\n[취소] 버튼을 클릭해주세요.")){
				lk.checked = false;
				document.getElementById("loginkeep").value = 0;
			}else{
				document.getElementById("loginkeep").value = 1;
			}
			return;
		}
	}

	//쿠키가져오기
	function getCookie(name){
		var nameOfCookie = name + "=";
		var x=0;
//		alert(document.cookie);
		while(x <= document.cookie.length){
			var y = (x+nameOfCookie.length);
			if(document.cookie.substring(x,y)==nameOfCookie){
				if((endOfCookie = document.cookie.indexOf(";",y))== -1)
					endOfCookie = document.cookie.length;
				return unescape(document.cookie.substring(y,endOfCookie));
			}
			x = document.cookie.indexOf("",x)+1;
			if(x==0)
				break;
		}
		return "";
	}
	var top = 0; // 팝업창 위치
	var left = 0; // 팝업창 위치
	//쿠키 설정 여부 체크
	function cookieChk(index,w,h){
		var h2 = h + 30;
		if(getCookie("popup"+index) != "none"){
			window.open("./popup/popup.jsp?no="+index,"","width="+w+",height="+h2+",menubar=no,toolbar=no,status=no,top="+top+",left="+left);
		}
		top += 20;
		left += 40;
	}

	<%
	//팝업 창 띄우기.
	if(plist.size() > 0 && user_id == 0){
		for(int i=0; plist.size() > i; i++){
			PopupInfo pinfo = (PopupInfo)plist.get(i);
			//out.println("cookieChk(encodeURI(\""+pinfo.getTitle()+"\"),"+pinfo.getPostId()+","+pinfo.getPostW()+","+pinfo.getPostH()+");");
	%>
			cookieChk(<%=pinfo.getPostId()%>,<%=pinfo.getPostW()%>,<%=pinfo.getPostH()%>);
	<%
		}
	}
	%>

	$('#loginform').submit(
		function(){
			check_login_form();
		}
	);
	//-->
	</script>
</head>

<style type="text/css">
	/* min-width: 1920px까지는 24인치 ↓, 1921px부터는 24인치 ↑ */
	@media screen and (min-width : 1921px) {
		input[type=text] { height: 75px !important; font-size: 18px; }
		input[type=password] { height: 75px !important; font-size: 18px; }
		
		.tablezone { margin-bottom: 25px !important; }
	}
	
	body { font-family: 'Noto Sans KR'; letter-spacing: -1px; }
	input[type="text"], input[type="password"], select, button  { font-family: 'Noto Sans KR'; letter-spacing: -1px; }
	
	input[type=text] { height:60px; border-radius: 3px; }
	input[type=password] { height:60px; border-radius: 3px; }
	input[type=checkbox] { border: 1px solid #cfcfcf; }
	
	.tablezone { margin-bottom: 15px; }
	
	.basic-table { border-top: none; }
	.basic-table th { border-bottom: 1px solid #e5e6e7; color: #303030; text-align: center;	font-size: 16px; font-weight: 600;	background: #f5f5f5; padding: 20px 0; vertical-align: middle; position: relative }
	.basic-table th:before{ width: 1px; height: 15px; background: rgba(112,112,112,0.5); position: absolute; content: ''; left: 0; top: 25px }
	.basic-table th:nth-child(1):before{ display: none }
	.basic-table td { padding: 0; border-bottom: none; line-height: 2; font-size: 16px; font-weight: 300; vertical-align: middle; width: 22.5%; }
	.basic-table td:nth-child(2+n) { width: 21.5%; }
	
	#footer { width: 100% !important; }
	
	
	/* 0. 대표 이미지(좌측 구간) */
	@media screen and (min-width : 1921px) {
		#section1 { width:  calc(100% - 1080px) !important; }
		
		.Mainbg #spot_image1 { zoom: 1.4; top: -265px; }
	}
	
	#section1 { width:  calc(100% - 850px); min-height: 600px; overflow:hidden; position:relative;}
	.Mainbg #spot_image1 { width: 100%; min-height: 600px; }
	.Mainbg #spot_image2 { width: 100%; min-height: 600px; display:none; }
	.Mainbg #spot_image3 { width: 100%; min-height: 600px; display:none; }
	
	.logoImg { padding: 20px 0 0 20px; }
	/* .logoImg { background: #505050; opacity: 0.8; padding: 20px 0 0 20px; } */
	
	
	/* 0-2. 로그인(우측 구간) */
	@media screen and (min-width : 1921px) {
		#section2 { width: 932px !important; }
	}
	
	#section2 { width: 702px; padding: 0 74px; min-height: 600px; }
	
	
	/* 1. 로그인(ID/PW) 구간 */
	/*
	@media screen and (max-width: 1718px) {
		.loginSlogan { font-size: 48px !important; }
		.loginText { font-size: 13px !important; }
	}
	@media screen and (max-width: 1368px) {
		.loginSlogan { font-size: 40px !important; }
		.loginText { font-size: 11px !important; }
	}
	@media screen and (max-width: 571px) {
		.loginSlogan { font-size: 60px !important; }
		.loginText { font-size: 14px !important; }
	}
	*/
	@media screen and (min-width : 1921px) {
		.loginSlogan { font-size: 85px !important; }
		.loginText { font-size: 17px !important; }
		.loginBtn { height: 160px !important; font-size: 18px !important; }
		.loginInfo label { font-size: 15px !important; }
	}
	
	.loginSlogan { width: 100%; font-weight: 400; font-size: 60px; margin: auto; text-align: left; }
	.loginText { line-height: 160%; font-size: 15px; text-align: left; margin: auto; }
	.loginText font { color: #1F4787 }
	.loginBtn { width: 92%; height: 130px; font-size: 18px; font-weight: bold; cursor: pointer; margin-left: 8%; margin-right: 0; border-radius: 3px !important; }
	.loginInfo { text-align: left; }
	.loginInfo label { font-size: 13px; }
	
	
	/* 2. 아이콘(배너) 구간 */
	/*
	@media only all and (max-width: 1690px){
		.basic-table span { font-size: 13px; }
	}
	*/
	/* .basic-table a img { width: 75%; } */
	@media screen and (min-width : 1921px) {
		.icon_1 { padding: 0 33px !important; font-size: 17px; }
		.icon_2 { padding: 0 25px !important; font-size: 17px; }
		.icon_3 { padding: 0 38px !important; font-size: 17px; }
		
		.tablezone img { width: 120px !important; }
	}
	
	.basic-table span { display: block; }
	
	.icon_1 { padding: 0 24px; }
	.icon_2 { padding: 0 16px; }
	.icon_3 { padding: 0 29px; }
	
	.tablezone img { width: 100px; }
	
	
	/* 3. 공지사항(탭) 구간 */
	/* .notice { width: 93%; margin: 10px 0 0 10px; } */
	@media screen and (min-width : 1921px) {
		.tabmenu ul li.active, .tabmenu ul li:hover { width: 140px !important; font-size: 19px !important; }
		.tabmenu .cation { top: 18px !important; font-size: 16px !important; }
		
		.contents { font-size: 17px !important; }
		.contents:first-child { padding-top: 21px !important; }
		.contents:last-child { padding-bottom: 21px !important; }
	}
	
	.notice { width: 100%; margin: 10px 0 0 0; }
	
	.tabmenu { border: 1px solid #cccecd; position: relative; border-bottom: none; margin-bottom: 0; background: #eeeeee; /*#f5f5f5;*/ }
	.tabmenu ul li{float:left;height: 49px;width:110px;color: #000;font-weight: 500;font-size: 18px;background: white; /*#f8f8f8;*/ text-align: center;line-height: 50px;/* margin-right: 1px; */cursor: pointer;border: 1px solid #ccc;/* margin-left: -1px; *//* border-right: 0; */ position: relative;width: 165px;border-bottom: none;top: 1px;}
	.tabmenu ul li.active, .tabmenu ul li:hover { width: 110px; height: 52px; color: #262626; border: 1px solid #cccecd; border-top: none; border-bottom: none; border-left: none; top: 0; font-size: 17px; line-height: 52px; }
	.tabmenu .cation { position: absolute; top: 20px; right: 25px; font-size: 14px; }
	
	.content_Box { border: 1px solid #cccecd; border-top: none; }
	.contents { padding: 12px 25px; font-size: 15px; }
	.contents:first-child { padding-top: 17px; }
	.contents:last-child { padding-bottom: 17px; }
	.content_Date { float: right; }
	
	
	/* 4. Hot Notice & Banner 구간 */
	@media screen and (max-width: 1800px) {
		.banner_left { overflow: hidden; }
	}
	@media screen and (max-width: 555px) {
		.banner_left { display: none; }
		#footer { margin-top: 70px !important; }
		.bottommenu { width: 100% !important; padding: 17px 33px 17px 33px !important; }		
	}
	
	@media screen and (max-width: 1130px) {
		.bottommenu_right { display: none !important; }		
		.bottommenu { width: 100% !important;}
	}
	
	/* #footer { margin-top: 94px; } */
	#lmsGuidePopup {
	    position: absolute;
	    top: 10%;
	    left: 30%;
	    display: none;
	    z-index: 9999;
	}
	
	.banner_left { width: 100%; float: left; text-align: left; height: 94px; }
	.banner_left_inDiv { width: 70%; float: left; text-align: left; }
	.banner_icon { font-size: 16px; font-weight: bold; font-family: Noto Sans KR; text-align:center; padding: 0 10px; }
	.banner_icon a { color: white; }
	.banner_icon a span { font-size:12px; color: white; }
	.banner_icon a:hover { /*transform: scale(1.1);*/ text-decoration:underline; color:white; }
	
	.khubbanner { float:left; position: relative; text-align: center; margin: 0 0 0 0; padding-top:20px; border-top: none; }
	.khubbanner div { color:#ad1c63; padding:0 0 15px 10px; text-align:left; font-size: 19px; font-weight: bold; font-family: Noto Sans KR; }
	.khubbanner .jbnuNoticeBg {  transition: left 1s ease-out; } 
	#hotnotice_image1 { opacity: 1; float: left; display:block; }
	#hotnotice_image2 { opacity: 0; float: left; display:none; }
	#hotnotice_image3 { opacity: 0; float: left; display:none; }
	
	
	/* 5. 상세 보기 구간 (아래 구간) */
	.copybox { width: 100% !important; padding-left: 0px !important; }
	.bottommenu_box { display: inline-flex; width: 100%; }
	.bottommenu { display: flex; float: left; width:100%; background: #333333; padding: 17px 33px 17px 33px !important; white-space: nowrap; }
	.bottommenu span a { background-color: #333333 !important; color: #B2B4BC !important; }
	.bottombox { padding-left: 35px !important; width:calc(100% - 35px) !important; }
	.bottommenu_right { display: flex; background: #1f1f1f; color: #fff; font-size: 13px; }
	.shortcut_right { float:left; padding: 18px 12px 18px 12px; border-left: 1px solid #434343; white-space: nowrap; color: white; }
	.shortcut_right a { padding: 0 10px; }
	.shortcut_right a:hover { color: #fff !important; }
	.bottombox address { clear: both; color: #B2B4BC !important; line-height: 185%; }
	
	
	/* 6. 웹 사이트 바로가기 */
	@media screen and (min-width : 1921px) {
		.shortcut_row { height: 130px !important; margin-bottom: 35px !important; }
		.shortcutBtn { width: 130px !important; font-size: 18px !important; }
	}
	
	.shortcut_bundle { display:flex; flex-wrap: wrap; align-content: flex-end; height: 89%; }
	.shortcut_row { width:100%; height:100px; display:flex; justify-content:flex-end; margin-bottom:30px; }
	.shortcutBtn_mold { margin-right: 40px; }
	.shortcutBtn { background:#f1f1f1; width:100px; height:100%; display: flex; justify-content: center; align-items: center; border-radius: 5px; line-height: 25px; font-size: 16px; font-weight: 500; color: white; opacity: 0.8; }
</style>

<body <% if(user_id == 0) { %>onload="readcookie();"<%}%> style="overflow:auto; overflow-x:hidden;">
	<jsp:include page='<%=JSPINC_PREFIX + "/login/autoLogin.jsp"%>' flush="true"/>

	<div id="container" style="min-height: 600px;">
	
		<!-- LMS 기능 및 매뉴얼 가이드 팝업창 -->
		<div id="lmsGuidePopup"></div>
		
		<!-- 0. 대표 이미지(좌측 구간) -->
		<div id="section1">
			<div class="logoImg"><img src="<%=path %>/img/khub_orginal2.png" onClick="window.open('https://bigdatahub.ac.kr/')" /></div>
			<div class="main_visual">
	      		<div class="rolling" id="rolling">
					<ul class="Mainbg">
						<%-- <li id="spot_image3"></li>
						<li id="spot_image2"></li> --%>
						<li id="spot_image1" class="on"></li>
					</ul>
				</div>
			</div>
			<div class="shortcut_bundle">
				<div class="shortcut_row">
					<button class="shortcutBtn_mold" onclick="window.open('https://bigdatahub.ac.kr/ ')" ><div class="shortcutBtn" style="background: #73d7ff">홈페이지</div></button>
				</div>
				<div class="shortcut_row">
					<button class="shortcutBtn_mold" onclick="window.open('https://sugang.snu.ac.kr/')"><div class="shortcutBtn" style="background: #8da8b4">수강신청</div></button>
					<button class="shortcutBtn_mold" onclick="window.open('https://bigdatahub.ac.kr/community/support')"><div class="shortcutBtn" style="background: #246a74">취업지원</div></button>
				</div>
				<div class="shortcut_row">
					<button class="shortcutBtn_mold" onclick="window.open('https://my.snu.ac.kr/login.jsp')"><div class="shortcutBtn" style="background: #1f4787">대학포털</div></button>
					<button class="shortcutBtn_mold" onclick="window.open('https://oasis.jbnu.ac.kr/com/login.do')"><div class="shortcutBtn" style="background: #1f4787">학사관리</div></button>
					<button class="shortcutBtn_mold" onclick="window.open('https://coss.ac.kr/login?coss=1')"><div class="shortcutBtn" style="background: #1f4787">LMS 기능<br>/매뉴얼</div></button>
				</div>
			</div>
		</div><!-- billboard 종료 -->

		<!-- 0. 로그인(우측 구간) -->
		<div id="section2">
		
		<!-- 1. 로그인(ID/PW) 구간 -->
		<div class="tablezone">	
		
			<form name="loginform" method="post" action="javascript:check_login_form();" id="loginform">
			
			 <!--  <table width="92%" border="0" cellspacing="0" cellpadding="0" class="basic-table" style="margin-left: 2%"> -->
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="basic-table" >
				<colgroup>
						  <col width="30%">
						  <col width="*">
					</colgroup>
					<tbody>
                        <tr>
                          <td colspan="1">
	                		<div class="loginSlogan">LOGIN</div>
						  </td>
                          <td colspan="3">
							<div class="loginText">
								<font>대학 포털 ID</font>(학번 또는 사번)로 로그인할 수 있습니다.<br/>
								교수님께서는 재직 중인 개인 사번으로 로그인해주십시오.
							</div>
						  </td>
                        <tr>
                          <td colspan="3">
								<input type="text" name="login" id="id" placeholder="<%if(loginType.equals("basic"))out.print("아이디"); else out.print("학번 또는 사번");%>" style="margin-bottom:10px;"/>
								<input type="password" name="passwd" id="passwd" placeholder="비밀번호" autocomplete="off"/>
						  </td>
                          <td>
								<input class="loginBtn" type="submit" title="로그인" value="로그인" />
						  </td>
                        </tr>
                        <tr>
                          <td colspan="4">
							<div class="loginInfo">
								<input type="checkbox" name="idsave" id="idsave" value="1">
									<label for="idsave">아이디 저장</label>
								<input type="checkbox" name="loginsave" id="loginsave" value="0" onclick="javascript:keepingLogin();" style="margin-left:10px;">
									<label for="loginsave">로그인 상태 유지</label>
							</div>
						  </td>
                        </tr>
						</tbody>
                     </table>
                     
			</form>
                     
            </div> <!-- 로그인(ID/PW) 구간 END -->
            
            
		<!-- 2. 아이콘(배너) 구간 -->
		<div class="tablezone">	
		
			 <!-- <table width="95%" border="0" cellspacing="0" cellpadding="0" class="basic-table"> -->
			 <table width="100%" border="0" cellspacing="0" cellpadding="0" class="basic-table">
				<colgroup>
						  <col width="20%">
						  <col width="20%">
						  <col width="20%">
						  <col width="20%">
						  <col width="20%">						
					</colgroup>
					<tbody>
                        <tr>
                          <td>
	                		<a href="<%= path %>/login/register.jsp" target="_blank">
	                			<img src="<%=path%>/new_skin/img/login_banner1.png"/><span class="icon_1">회원가입</span></a>
						  </td>
                          <td>
	                		<a href="<%= path %>/login/memSearch.jsp" target="_blank">
	                			<img src="<%=path%>/new_skin/img/login_banner2.png" /><span class="icon_2">ID/PW 찾기</span></a>
						  </td>
                          <td>
	                		<%-- <a href="//www.jbnu.ac.kr/kor/?menuID=139" target="_blank"> --%>
	                		<a href="#">
	                			<img src="<%=path%>/new_skin/img/login_banner3.png" /><span class="icon_1">교내공지</span></a>
						  </td>
                          <td>
	                		<%-- <a href="https://sobi.chonbuk.ac.kr/menu/week_menu.php" target="_blank"> --%>
	                		<a href="#">
	                			<img src="<%=path%>/new_skin/img/login_banner4.png" /><span class="icon_1">주간식단</span></a>
						  </td>
                          <td>
	                		<%-- <a href="//mail.jbnu.ac.kr" target="_blank"> --%>
	                		<a href="#">
	                			<img src="<%=path%>/new_skin/img/login_banner5.png" /><span class="icon_3">웹메일</span></a>
						  </td>
                        </tr>
					</tbody>
			 </table>
			 
		</div> <!-- 아이콘(배너) END -->
		
	                <%-- 
	                <div class="khubbanner2_select">
		                <select name="email" class="AXSelect" id="AXSelect">
						    <option value="">이메일을 선택해주세요.</option>
						    <option value="https://mail.jbnu.ac.kr">전북대메일</option>
						    <option value="https://gmail.com">지메일</option>
						    <option value="https://mail.naver.com">네이버</option>
						    <option value="https://mail.daum.net">다음</option>
						</select>
					</div>
					--%>

				<!-- 3. 공지사항(탭) 구간 -->
				<div class="notice">
					<div class="tabmenu">
						<ul>
							<li class="active">공지사항</li>
						</ul>
						<div class="cation">
							<a onclick="window.open('https://bigdatahub.ac.kr/information/notice')" title="Notice" rel="noopener noreferrer">더 보기</a>
						</div>
					</div>
					<div class="content_Box">
<%
List postList = new ArrayList();
List allPostList = db.getPostList("notice");
for(int i=0; i < allPostList.size(); i++) {
	PostInfo postInfo = (PostInfo)allPostList.get(i);
    if(i>10) break;
    postList.add(postInfo);
}
if(user_id != 0) {
	List groupPostList = db.getGroupPostList(user_id);
	for(int i=0; i < groupPostList.size(); i++) {
		PostInfo postInfo2 = (PostInfo)groupPostList.get(i);
        if(i>10) break;
        postList.add(postInfo2);
	}
}
Collections.sort(postList, new Comparator() {
		public int compare(Object o1, Object o2) {
			PostInfo info1 = (PostInfo)o1;
			PostInfo info2 = (PostInfo)o2;
			return info2.getDate().compareTo(info1.getDate());
		}
	});
for(int i=0; i < postList.size(); i++) {
	PostInfo pi = (PostInfo)postList.get(i);
	if(i > 4) break;

	sb.setLength(0);
	sb.append(path).append("/board/view.jsp?board=notice&id=").append(pi.getPostId());
	if(pi.getGroupId() != 0) {
		sb.append("&group_id=").append(pi.getGroupId());
	}

	String pdate = pi.getDate().toString().substring(2, 10).replace("-", ".");
	String ptitle = WebUtil.removeHTMLTag(pi.getTitle());
	int k = GetTitleSubSize(ptitle, 80);

	String newtitle = ptitle.substring(0, k);
	if(ptitle.length() > k)
		newtitle += "...";
%>
						<div class="contents">
							<a href="<%=sb.toString() %>" title="<%=ptitle%>" target="_blank" rel="noopener noreferrer">
								<% if(today_date.equals(pdate)){ %>
									<font color="red"><%=newtitle %></font>
								<% }else{ out.print(newtitle); } %>
							</a><span class="content_Date"> <%=pdate %></span>
						</div>
<%	}%>
					</div>
				</div> <!-- 공지사항(탭) 구간 END -->
			
			<%-- 
			<!-- 4. 전북대학교 홈페이지 HOT NOTICE -->
			<div class="khubbanner" id="khubbanner">	
				<ul class="jbnuNoticeBg">
<%
MetaSearch ms = new MetaSearch();
SearchInfo sinfo = ms.searchWeb("jbnu_hotnotice", "", "", 1, 3);
sinfo.setImage(true);

List slist = sinfo.getSearchItem();
%>
<script>
jbMainImageCnt=<%=slist.size()%>
</script>
<%
for(int i=0; i<slist.size(); i++) {
	SearchItem sitem = (SearchItem)slist.get(i);

	String imageTitle = "";
	if(!sitem.getTitle().isEmpty())
		imageTitle = WebUtil.removeTag(sitem.getTitle()).trim();
	
	String noticeLink = sitem.getLink(); //URLDecoder.decode(sitem.getLink());
	String imageUrl = sitem.getImage(); 
%>
					<li id="hotnotice_image<%=i+1%>" class="<%if(i==0){out.print("on");}%>">
						<a href="<%=noticeLink %>" target="_blank"><img src="<%=imageUrl %>" width="510px" title="<%=imageTitle %>"></a>
					</li>
<%
}
%>
				</ul>				
			</div>
			--%>
			
			<%-- 
			<div class="khubbanner">
				<div style="padding-bottom:20px;">기능 살펴보기</div>
                <a href="javascript:kspringOutboundLink('<%=demoFunctionUrl%>');" rel="noopener noreferrer">
                	<div style="background:url(<%=path%>/img/preview01.gif) no-repeat;">주요 기능 <br/>살펴보기</div></a>
                <a href="javascript:kspringOutboundLink('<%=demoGroupAddUrl%>');" rel="noopener noreferrer">
                	<div style="background:url(<%=path%>/img/preview02.gif) no-repeat;"><%=newConf.getString("menuGroupName")%> 만들기<br/>및 초대</div></a>
                <a href="javascript:kspringOutboundLink('<%=demoGroupJoinUrl%>');" rel="noopener noreferrer">
                	<div style="background:url(<%=path%>/img/preview03.gif) no-repeat;"><%=newConf.getString("menuGroupName")%> 가입</div></a>
             	<a href="javascript:kspringOutboundLink('<%=demoGroupPortalUrl%>');" rel="noopener noreferrer">
                	<div style="background:url(<%=path%>/img/preview04.gif) no-repeat;"><%=newConf.getString("menuGroupName")%> 포털 <br/>만들기</div></a>
				<a href="javascript:kspringOutboundLink('<%=path %>/faq/index.jsp');"  rel="noopener noreferrer"  style="padding-top:7px;width:160px;" title="시스템 매뉴얼 및 운영 사례">
					<div style="background:url(<%=path%>/img/preview05.gif) no-repeat;">사용자 매뉴얼 보기</div></a>
       		</div>
       		--%>
		</div>
		<!--section2 종료-->

	</div>
	<!--container 종료-->

<%-- 23.11.14 edu 기준 주석 처리 
	<!-- 5. 전북대학교  Quick Menu -->
	<div class="banner_left" id="banner_left">
	  <div class="banner_left_inDiv">
	  	<table style="width: 100%; height: 94px;">
	  		<tr>
	  			<td width="12%" class="banner_icon" style="background: #8c1851;"><a href="https://www.jbnu.ac.kr/kor/?menuID=460" target="_blank">대학포털</a></td>
	  			<td width="18%" class="banner_icon" style="background: #544ad1;">
					<a href="https://all.jbnu.ac.kr/jbnu/oasis/index.html" target="_blank">오아시스 3.0<br/><span>(교수/학생)</span></a>
				</td>
	  			<td width="12%" class="banner_icon" style="background: #3b6db9;"><a href="https://all.jbnu.ac.kr/jbnu/sugang/index.html" target="_blank">수강신청</a></td>
	  			<td width="12%" class="banner_icon" style="background: #00b0a3;"><a href="https://career.jbnu.ac.kr/career/index.do" target="_blank">취업지원</a></td>
	  			<td width="18%" class="banner_icon" style="background: #143971;">
					<a href="https://up.jbnu.ac.kr/" target="_blank">오아시스 UP<br/><span>(교직원)</span></a>
	  			</td>
	  			<td width="26%" class="banner_icon" style="background: #0c6580;"><a href="javascript:lmsGuidePopupOpen('<%=path %>/demo/preview-popup.jsp');">LMS 기능 및 매뉴얼</a></td>
	  		</tr>
	  	</table>
	  </div>
	</div>
--%>

	<!--footer 시작-->
	<div id="footer">
		<div class="copybox">
		<div class="bottommenu_box">
			<div class="bottommenu">
				<span><a href="<%=path%>/login/policy.jsp" rel="noopener noreferrer">이용약관</a></span>
				<span><a href="<%=path%>/login/private.jsp" rel="noopener noreferrer"><font color="#FFF200">개인정보처리방침</font></a></span>
				<span><a href="<%=sys_url %><%=path%>/mobile/web/app" rel="noopener noreferrer">모바일버전</a></span>
				<span><a href="javascript:alert('K-HUB v1.0');" rel="noopener noreferrer">버전정보</a></span>
				<span><a href="javascript:location.href='<%=path %>/faq/index.jsp';" rel="noopener noreferrer"><font color="#FFF200">고객센터</font></a></span>
				
			</div>
			<!-- 24.08.13 바로가기 위치 조정에 따른 주석 처리
				<div class="bottommenu_right">
					<div class="shortcut_right" style="background:#8c1851"><a href="#">대학포털</a></div>
					<div class="shortcut_right" style="background:#544ad1"><a href="#">학사관리시스템 (교수/학생)</a></div>
					<div class="shortcut_right" style="background:#143971"><a href="#">학사관리시스템 (교직원)</a></div>
					<div class="shortcut_right" style="background:#3b6db9"><a href="#">수강신청</a></div>
					<div class="shortcut_right" style="background:#00b0a3"><a href="#">취업지원</a></div>
					<div class="shortcut_right" style="background:#0c6580"><a href="javascript:lmsGuidePopupOpen('<%=path %>/demo/preview-popup.jsp');">LMS 기능 및 매뉴얼</a></div>
				</div>
			-->
		</div>
			<div class="bottombox">
				<ul>
					<li>
						<address>
						(08826)서울특별시 관악구 관악로 1 102동 206호 빅데이터 혁신융합대학사업단<br/>				
						TEL&nbsp;02-889-5708  <br/>		
						</address>
						<!-- <p>
						@COPYRIGHT BIGDATAHUB UNIVERSITY. ALL RIGHT RESERVED
						</p> -->
					</li>
				</ul>
			</div>
			<div class="bottomlogo">
				<!-- img src="<%=path %>/img/logo_ktech.png" title="케이테크" / -->
			</div>
		</div>
	</div>
	<!--footer 종료-->

</body>
</html>