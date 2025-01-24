<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="java.util.*, java.net.*, java.text.*, es.bean.*" %>
<%@ page import="static com.ktech.conf.ConfStatic.*" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String lang = (String)session.getAttribute("lang");
if(lang == null || lang.equals("")) lang= "ko";
%>
<c:set var="lang" value="<%=lang%>"/>
<c:if test="${lang eq 'en'}"><fmt:setLocale value = "en"/></c:if>
<c:if test="${lang ne 'en'}"><fmt:setLocale value = "ko"/></c:if>
<fmt:setBundle basename = "groupMember"/>
<%
Integer intUser_id = (Integer)session.getAttribute("user_id");
String user_name = (String)session.getAttribute("user_name");

int user_id = 0;
if(intUser_id != null)
	user_id = intUser_id.intValue();

session.setAttribute("link",path+"/mypage/group/index.jsp");

if(user_id == 0) {
	response.sendRedirect(path+"/login/login.jsp");
	return;
}

String link = (String)session.getAttribute("link");
if(link == null)
	link = "";
link = new String(link.trim().getBytes("ISO-8859-1"), "UTF-8");
//link = URLEncoder.encode(link);

String strGroup_id = request.getParameter("group_id"); // group_id
int group_id = 0;
if(strGroup_id != null)	group_id = Integer.parseInt(strGroup_id);

myGroupProc db = new myGroupProc(dbname);

Integer intGroup_id = (Integer)session.getAttribute("ss_group_id");
int sg_id = 0;
if(intGroup_id != null){ sg_id = intGroup_id.intValue();  }

String strOpenTerm = request.getParameter("open_term");
String openTerm = "0";
if(strOpenTerm != null){ openTerm = strOpenTerm;  }
if(!hostName.equals("HowonHUB") && !hostName.equals("edim") && !hostName.equals("JNUHub") && !hostName.equals("snu")){
	openTerm = "1";
}
UserInfo uinfo = db.getUserInfo(user_id);
String user_photo_url = "";
if(uinfo.getPhoto() != null)
	user_photo_url = path + "/photo/"+user_id+"/"+uinfo.getPhoto();

if(group_id != 0) session.setAttribute("ss_group_id", group_id);
else if(sg_id != 0) group_id = sg_id;
// 세션 연동 완료

int cnt_item = 5;

String strStart = request.getParameter("start"); // page
int start = 1;
if(strStart != null) start = Integer.parseInt(strStart);

String group_join_url = "groupJoin";
if(db.getUserAdminCheck(user_id)) group_join_url = "groupSearch";

boolean groupAdmin = db.hasGroupAdminAuth(user_id, group_id, true);

List<GroupInfo> groupList = db.getMainGroupJoinList(user_id, 0);
int groupCount = groupList.size();

String host = hostName;
if(host == null) host = "";
%>
<!doctype html>
<html>
<head>
	<%@ include file="../../header.jsp" %>
	<!-- Meta Tags -->
	<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
	<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
	<!-- Page Title -->
	<title><%= title %></title>
	<!-- Stylesheet -->
	<link rel="stylesheet" href="<%=path %>/new_skin/css/reset.css" type="text/css">
	<link rel="stylesheet" href="<%=path %>/new_skin/css/font.css" type="text/css">
	<link rel="stylesheet" href="<%=path %>/new_skin/css/style.css" type="text/css">
	<link rel="stylesheet" href="<%=path %>/new_skin/css/swiper.css" type="text/css">
	<script src="<%=path %>/new_skin/js/jquery-1.11.1.min.js"></script>
	<script src="<%=path %>/new_skin/js/swiper-bundle.min.js"></script>
	
<style type="text/css">
/* 팝업 레이어 S */
.popupLayer {position:absolute; width:100%; height:1600px; z-index:100; -ms-filter: alpha(opacity=50); filter: alpha(opacity=50); opacity:0.3; -moz-opacity:0.3;}
.popupLayer .back {position:absolute; width:100%; height:1600px; background:#000; z-index:101;}

.popup_box {position:absolute; left:50%; top:50%; z-index:102; background:#fff; padding:20px; min-width:500px; margin-left:-300px; margin-top:-200px; padding-bottom:10px;}
.popup_box .popup_contents {position:absolute; left:0; top:0; width:100%; z-index:102; border: 2px solid #288CD2; display:inline; background:#fff;min-width:499px; margin:0 auto;}
.popup_box .popup_contents select{font-size:10pt;}

.load {position:absolute;left:200px;top:150px;display:none;verticul-align:middle;}

.layertitle {width:100%;height:50px;background-image:url('../../img/title_bgSub3.gif');verticul-align:middle;}
.layertitle .pubTitle {color:#5565c6;margin:10px 0px 9px 15px;font-weight:bold;font-size:16px;font-family:Malgun Gothic, gulim, dotum;float:left;}

/* 팝업 레이어 E */

/* 23.07.10 Middle Menu 높이 조정 */
.myclassuser {height: 85px;}
.team img {width: 75px; height: 75px;}
.myteatyear {padding-top: 20px; }
</style>

<script type="text/javascript">
function groupAfterLogin(mode) {
	var strQuestion = "<fmt:message key = 'noActiveLoginAfterScreenConfirm' />";
	if(mode == 'true') strQuestion = "<fmt:message key = 'thisPageLoginAfterScreenSetConfirm' />";
	if(confirm(strQuestion)){
		location.href = "<%= path %>/mypage/group/groupAfterLogin.jsp?mode="+ mode;
	}
}

function pageLoad(openTerm) {
   var term = document.getElementById("openTerm");
   term.value = openTerm;
   myGroupList_load(1);
}
function goContentsManageSystemOfDISU() {
	window.open('<%=path%>/disucms/', 'DISU-CMS');
}
function goCourseRegisterHelper() {
	window.open('<%=path%>/ontoweb/search.jsp', 'CR_Helper');
}
function goAIRecommendation() {
	window.open('<%= path %>/mypage/aiRecommend/aiRecommend.jsp');		
}
<%-- 23.07.11 높이 조정에 따른 주석 처리
<!-- 20230620 강혜경 hkkang - 중간 메뉴 열기/닫기 설정 기능 -->
function reduceMiddleMenu() {
	var menuDiv = document.getElementById("myclassmakew");
	var menuSubDiv1 = document.getElementById("myclassmake");
	var menuSubDiv2 = document.getElementById("myclasscation");
	
	var textDiv = document.getElementById("midMenuResize");
	if(textDiv.innerText.indexOf("접기") > -1) {
		menuDiv.style.padding = "0";
		menuDiv.style.borderTop = "0";
		menuSubDiv1.style.display = "none";
		menuSubDiv2.style.display = "none";
		
		textDiv.innerHTML = "▼ 펼치기"; 
	}else{
		menuDiv.style.padding = "35px 0 20px";
		menuDiv.style.borderTop = "1px solid rgba(255,255,255,0.2)";
		menuSubDiv1.style.display = "block";
		menuSubDiv2.style.display = "block";
		
		textDiv.innerHTML = "▲ 접기"; 
	}
}
--%>
</script>
</head>

<!-- 배경 popup -->
<div id="divpopbg">
</div>

<body>
<div class="wrap">

	<jsp:include page="../../new_menu_Top.jsp" flush="true"></jsp:include>
	
	<jsp:include page="../../myclass_Menu.jsp" flush="true">
        <jsp:param name="open_term" value="<%= openTerm %>" />
	</jsp:include>
	<!-- content myclass  -->
	<section class="content myclass">
		<div class="container">
		<!-- 왼쪽 메뉴 리스트 -->	
         <jsp:include page="./index_left.jsp" flush="true">
            <jsp:param name="menu_id" value="menu_01" />
         </jsp:include>
         
<script type="text/javascript">

	function newGroup() {
		location.href="<%= path %>/mypage/group/groupList.jsp";
	}
	function selectGroup(id, name, active, owner_ck) {
		if(!activeCheck(active, owner_ck)) return;
		else{
			var group_id = document.getElementById("group_id");
			var group_name = document.getElementById("group_name");
		    group_id.value = id;
		    group_name.value = name;

		    var f = document.groupform;
		    f.action="<%= path %>/mypage/group/groupPage.jsp";
			f.submit();
		}
	}
	function goGroupPage(id, active, owner_ck) {
		if(!activeCheck(active, owner_ck)) return;
		else
			location.href="<%= path %>/mypage/group/groupPage.jsp?group_id="+id;
	}
	function goGroupMember(id, active, owner_ck) {
		if(!activeCheck(active, owner_ck)) return;
		else
			location.href="<%= path %>/mypage/group/groupMember.jsp?group_id="+id;
	}
	function activeCheck(active, owner_ck) {
		var active_name = "<fmt:message key = 'group_off'/>";
		if(owner_ck) {
			return true;
			//active_name = "비활성화";
		}else{
			if(active == 1) {
				<%-- alert("현재 <%=newConf.getString("menuGroupName")%>의 상태가 ["+active_name+"]로 되어 있어, 이용하실 수 없습니다."); --%>
				alert("<fmt:message key = 'classStatusOff_msg'/> ["+active_name+"]<fmt:message key = 'classStatusOff2_msg'/>");
				return false;
			}else
				return true;
		}
	}

</script>

					<form name="groupform" method="post">
						<input type="hidden" name="group_id" id="group_id" />
						<input type="hidden" name="group_name" id="group_name" />
                  		<input type="hidden" name="openTerm" id="openTerm" value="<%= openTerm %>" />
                    </form>
                    
		<!-- 강의 리스트 START -->
		<div class="list_view_zone">
		<%-- 24.04.29 홍정표 교수님 컨설팅에 따라 주석 처리
   			<div class="tipw">
   			<div class="tipbox"><fmt:message key = "help" /><span></span> </div> <!-- 도움말 보기 -->
   			<div class="tipcont" style="display: block;">
                     	※ <fmt:message key = "msg17"/> ( <span><img src="<%=path %>/new_skin/img/bookmark_basic.png"></span>) <fmt:message key = "msg17-2"/><br/>
	                  	※ <fmt:message key = "msg18"/>
            </div>
            </div> 
        --%>
            
                    <div id="groupJoinList"></div>
                    
		</div>
		
<script type="text/javascript">
	myGroupList_load(1);

	function chActivity(gid,v,p,owner){
		var url = "<%= path %>/mypage/group/groupActiveModProc.jsp";
		var param = "group_id="+gid+"&v="+v+"&p="+p;
		var ok = true;

		if(owner && v==0) { // 현재 값이 0인 경우 숨기기(1)로 변경
			<%-- if(!confirm("해당 <%=newConf.getString("menuGroupName")%>의 관리자입니다.\n[숨기기]를 하실 경우, [<%=newConf.getString("menuGroupName")%> 가입] 리스트에서 보여지지 않으며,\n가입신청을 더이상 받을 수 없습니다. 진행하시겠습니까?")) --%>
			if(!confirm("<fmt:message key = 'classOn/Off_msg'/>"))
				ok = false;
		}
		if(ok) {
			$.ajax({
				url:url,
				type: 'post',
				data: param,
		        error:function(request,status,error){
		            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		        },
		        success: function(data){
		        	var txt = $.trim(data);
		        	if(txt != "error") {
		        		if(v == 1) {
		        			<%-- alert("<%=newConf.getString("menuGroupName")%>이(가) 활성화되었습니다."); --%>
		        			alert("<fmt:message key = 'classOn_msg'/>");
		        		}else{
		        			<%-- alert("<%=newConf.getString("menuGroupName")%>이(가) 비활성화되었습니다."); --%>
		        			alert("<fmt:message key = 'classOff_msg'/>");
		        		}
			        	myGroupList_load(txt);
		        	}else return;
		        }
			});
		}
	}
	function chActivityPopup(gid, v, super_gid, super_gname, owner){
		var url = "<%= path %>/mypage/group/groupActiveModProc.jsp";
		var param = "group_id="+gid+"&v="+v;
		var ok = true;

		if(owner && v==0) { // 현재 값이 0인 경우 숨기기(1)로 변경
			<%-- if(!confirm("해당 <%=newConf.getString("menuGroupName")%>의 관리자입니다.\n[숨기기]를 하실 경우, [<%=newConf.getString("menuGroupName")%> 가입] 리스트에서 보여지지 않으며,\n가입신청을 더이상 받을 수 없습니다. 진행하시겠습니까?")) --%>
			if(!confirm("<fmt:message key = 'classOn/Off_msg'/>"))
				ok = false;
		}
		if(ok) {
			$.ajax({
				url:url,
				type: 'post',
				data: param,
		        error:function(request,status,error){
		            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		        },
		        success: function(data){
		        	var txt = $.trim(data);
		        	if(txt != "error") {
		        		show_grouplist(super_gid, super_gname);
		        	}else return;
		        }
			});
		}
	}

	function myGroupList_load(page){
        var term = document.getElementById("openTerm");
        var openTerm = term.value;
	    var searchQuery = document.getElementById("searchQuery");
	    var query = "";
	    if(searchQuery) query = searchQuery.value;
		var url = "<%= path %>/mypage/group/myGroupList.jsp";
		
	    var data = {
		    start: page,
		    openTerm: openTerm,
		    searchQuery: query
		};
		$.ajax({
			url:url,
			type: 'post',
			data: data,
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        },
	        success: function(data){
	        	var txt = $.trim(data);
	    		var ohandle = document.getElementById("groupJoinList");
	    		ohandle.innerHTML=txt;
	        }
		});
	}

	function show_grouplist(gid, gname) {
		document.getElementById('all_popup').style.display='';
		var param = "group_id="+gid;
		$.ajax({
			url: "<%= path %>/mypage/group/mySubGroupList.jsp",
		    data: param,
		    type: 'post',
		    dataType: 'html',
		    error:function(request,status,error){
		        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		    },
		    success: function(data){
		    	var div = document.getElementById('subGroupDIV');
		    	div.innerHTML = data;

		    	var title = document.getElementById('pubTitle');

		    	if(gname.length >= 20) gname = gname.substr(0,20)+"...";

		    	title.innerHTML = "<font color='black'>["+gname+"]</font> <fmt:message key = 'subClassList' /> ";
		    }
		});
	}
	function close_grouplist() {
		document.getElementById('all_popup').style.display='none';
	}

	function setFavoriteGroup(gid, f, ck, url_gid, url_gname){
		if(ck == 1) close_grouplist();

		var url = "<%= path %>/mypage/group/groupFavoriteModProc.jsp";
		var param = "group_id="+gid+"&f="+f;
		$.ajax({
			url:url,
			type: 'post',
			data: param,
	        error:function(request,status,error){
	            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
	        },
	        success: function(data){
	        	var txt = $.trim(data);
	        	if(txt != "error") {
	        		if(f == 1) {
	        			<%-- alert("해당 <%=newConf.getString("menuGroupName")%>의 즐겨찾기를 취소하였습니다."); --%>
	        			alert("<fmt:message key = 'bookmarkOff_msg'/>");
	        		}else{
	        			<%-- alert("해당 <%=newConf.getString("menuGroupName")%>을(를) 즐겨찾기하였습니다."); --%>
	        			alert("<fmt:message key = 'bookmarkOn_msg'/>");
	        		}
	        		if(ck == 1) show_grouplist(url_gid, url_gname);
       				myGroupList_load(1);
	        	}else{
	        		<%-- 
	        		alert("즐겨찾기할 수 있는 <%=newConf.getString("menuGroupName")%>의 개수를 초과하였습니다.\n최대 5개까지 설정이 가능합니다.");
	        		alert("해당 <%=newConf.getString("menuGroupName")%>의 즐겨찾기를 취소하였습니다.");
	        		--%>
	        		alert("<fmt:message key = 'bookmarkLimit_msg'/>");
	        		alert("<fmt:message key = 'bookmarkOff_msg'/>");
	        		return;
	        	}
	        }
		});
	}

	function secedeGroup(mode, win, gid) {
		if(confirm("<fmt:message key = 'accountWithdraw_msg'/>")) {
			location.href="<%= path %>/mypage/group/groupMemberDelProc.jsp?mode="+mode+"&win="+win+"&group_id="+gid;
		}else return;
	}
</script>

		</div>
		</div><!-- 왼쪽 메뉴 END -->
	</section><!-- content END -->

</div><!-- All Content END -->

<div id="all_popup" style="display:none;">
 <div class="popupLayer" id="popupLayer">
  <div class="back" id="back"></div>
 </div>
 <div class="popup_box" id="popup_box"> <!-- 변경될 수 있는값은 html에서 작성 -->
  <div class="popup_contents" id="selectBoxs"><!-- popup_contents 안에서 자유 디자인 -->
  	<div class="load" id="load"><img src="<%=path %>/img/ajax_loding5_fbisk.gif"/></div>
  	<div class="layertitle">
  		<span class="pubTitle" id="pubTitle"><fmt:message key = "classList" /></span>
  		<span style="float:right;margin:3px 3px 0 0;">
  			<a href="javascript:close_grouplist();"><img width="25" src="<%=path %>/img/btn_del3.gif" /></a></span>
  	</div>
	<div id="subGroupDIV" style="height:600px;overflow:auto;overflow-x:hidden;"></div>
  </div>
 </div>
</div>

<script>
	$('.popupLayer').css('height', 'auto');
	$('.back').css('height', '100%');
/*
	$('.popupLayer').css('height', $(window).height());
	$('.back').css('height', $(window).height());
	$('.popupLayer').css('height', $(window).width());
	$('.back').css('height', $(window).width());
*/
</script>

	<jsp:include page="../../new_copyright.jsp" flush="true"></jsp:include>

</body>
<script src="<%=path %>/new_skin/js/common.js"></script>
</html>