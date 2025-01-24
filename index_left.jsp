<%@page import="es.bean.menu.SubMenuInfo"%>
<%@page import="es.bean.menu.MenuProc"%>
<%@page import="es.bean.menu.SubMenu"%>
<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="com.ktech.conf.*, java.util.*, java.net.*, java.text.*, es.bean.*, org.apache.log4j.*,java.security.*" %>
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
	if(intUser_id != null) user_id = intUser_id.intValue();

	GroupAdminProc db = new GroupAdminProc(dbname);

	String strMenuId = request.getParameter("menu_id");
	
	boolean	mygroup_ck = db.isUserGroupAdminOROwner(user_id);
	
	boolean admin_ck = db.getUserAdminCheck(user_id);

	//회원등급 별 차이 추가 yjkim 2015-12-17
	List userList = new ArrayList();
	int user_approval = 0;
	String user_approval_config = db.getConfigInfo("user_approval");
	if(user_approval_config == null) user_approval_config ="false";
	if(user_id!= 0) {
		UserInfo uainfo = (UserInfo)db.getUserInfo(user_id);
		user_approval = uainfo.getApproval();
		if(user_approval > 1) mygroup_ck = true;
	}

	//int noJoinCnt = db.getMyGroupListJoinWatingCount(db, user_id);
	int noJoinCnt = 0;
    List newsList = db.getGroupJoinWatingListByMyGroups(user_id, 10); // 최대 10개까지
    noJoinCnt = newsList.size();

	Integer intGroup_id = (Integer)session.getAttribute("ss_group_id");
	int group_id = 0;
	if(intGroup_id != null){ group_id = intGroup_id.intValue();  }

	String group_name = "";
	GroupInfo ginfo = new GroupInfo();
	if(group_id > 0){
		ginfo = db.getGroupInfo(group_id);
		group_name = db.getGroupName(group_id);
	}

	String link = (String)session.getAttribute("link");
	if(link == null) link = "";
	link = new String(link.trim().getBytes("ISO-8859-1"), "UTF-8");

	if(link.indexOf("/mypage/group/index.jsp") > -1) group_name = "";

	boolean use_haksa_info = false;
	String strUseHaksaInfo = db.getConfigInfo("use_haksa_info");
	if(strUseHaksaInfo != null) {
		if(strUseHaksaInfo.equals("true")) use_haksa_info = true;
	}
	
	String host = hostName;
	if(host == null) host = "";
	
	MenuProc mdb = new MenuProc(dbname);
	Map<Integer, SubMenuInfo> subMenuMap = mdb.getSubMenuMapByGroupId(group_id, lang);

	//현재 url 경로 추출
	String cur_url = request.getRequestURL().toString();
%>
<div class="list_mj_zone">
              	
	<% if(!group_name.equals("")){ %>
              	<div id="currentGroupNameDiv" style="display:none; width:200px;text-align:center;font-size:1.5em;color:#2864b9;font-weight:600;padding-bottom:10px;">
					<a style="border-bottom:1px solid #2864b9;" href="<%=path%>/mypage/group/groupPage.jsp"><%=group_name %></a>
				</div>
	<% } %>
	
	<nav>
	<% if(( strMenuId.indexOf("menu_06_") >= 0) && !group_name.equals("")){ %>
			  <h2><fmt:message key = "classPage" /></h2>
			  <div class="leftGroupMenu_div" style="background-image: url(<%=ginfo.getPhotoUrl()%>);">
				<div class="leftGroupPage_divtxt">
					<a href="<%=path%>/mypage/group/groupPage.jsp"><%=group_name %></a>
				</div>
				<div class="leftGroupMenu_divtxt">
					<a href="<%=path%>/mypage/group/groupPage.jsp"><fmt:message key = "classPage" />&nbsp;<img src="<%=path %>/img/icon_go.gif" /></a>
				</div>
				<div class="leftGroupMenu-cover"></div>
			  </div>
   	<% } %>
                <%
                // 내 강의 메뉴
               	if(strMenuId.equals("menu_01") || strMenuId.equals("menu_03") || strMenuId.equals("menu_07") || strMenuId.equals("menu_09")) {
               	%>
               	<h2><fmt:message key = "myClass" /></h2> <!--  내 강의 -->
                  <ul>
                    <li><a href="<%= path %>/mypage/group/index.jsp" class="<% if(strMenuId.equals("menu_01")){out.print("on");}%>">
                    	<fmt:message key = "myClass" /></a></li> <!--  내 강의 -->
                    <% if(host.equals("JBNUHub")) { %>
					<li><a href="<%= path %>/mypage/group/groupTimeTable.jsp" class="<% if(strMenuId.equals("menu_09")){out.print("on");}%>">
                    	<fmt:message key = "timetable" /></a></li> <!-- 강의 시간표 -->
                    <% } %>
               		<li><a href="<%= path %>/mypage/group/group<%if(admin_ck) { out.print("Search");}else{out.print("Join");}%>.jsp" class="<% if(strMenuId.equals("menu_03")){out.print("on");}%>">
               			<fmt:message key = "applyClass" /></a></li> <!-- 강의 가입 -->
	 				<% if(mygroup_ck){ %>
					<li><a href="<%= path %>/mypage/group/closedGroupManage.jsp" class="<% if(strMenuId.equals("menu_07")){out.print("on");}%>">
							<fmt:message key = "closedGroupManagement" /></a></li> <!-- 강의 폐쇄 관리 -->
					<% } %>
                  </ul>
                <%
                // 강의관리 메뉴
               	} else{
               	%>
               	<h2 style="<% if(lang.equals("en")){ %> height:90px; line-height:35px; padding-top:9px; <% } %>">
               		<fmt:message key = "managementClass" /></h2> <!-- 강의 관리 -->
               		<%
	               	if(user_approval_config.equals("false") ) {
	               	%>
	              	<ul>
						<li>
	               			<a href="<%= path %>/mypage/group/groupList.jsp" class="<% if(strMenuId.equals("menu_02")){out.print("on");}%>" title="" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
	               				<%=subMenuMap.get(SubMenu.CreateClassManagement.getValue()).getNameByLang() %></a>
	               		</li>
						<% if(mygroup_ck || admin_ck) { %>
						<li style="position:relative;">
							<a href="<%= path %>/mypage/group/groupMember.jsp" class="<% if(strMenuId.equals("menu_04")){out.print("on");}%>" title=""><%=subMenuMap.get(SubMenu.Members.getValue()).getNameByLang() %></a>
							<% if(noJoinCnt > 0) { %>
								<span style="position:absolute;right:20px; top:15px; z-index:10; cursor:pointer;" onclick="javascript:location.href='<%= path %>/mypage/group/groupJoinWating.jsp';" title="가입요청자 <%=noJoinCnt %>명">
									[<%=noJoinCnt %>]
								</span>
							<% } %>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/grouplog_member.jsp" class="<% if(strMenuId.equals("menu_05_02")){out.print("on");}%>" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
								<%=subMenuMap.get(SubMenu.ActivityIndexOfMembers.getValue()).getNameByLang() %></a>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/learningStatus.jsp" class="<% if(strMenuId.equals("menu_05_03")){out.print("on");}%>"><fmt:message key = "learningStatus" /></a>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/menuName.jsp" class="<% if(strMenuId.equals("menu_08")){out.print("on");}%>" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
								<%=subMenuMap.get(SubMenu.MenuNameManagement.getValue()).getNameByLang() %></a>
						</li>
						<% } %>
					</ul>
					<%
					} else {
	               		//그룹관리자, 그룹개설자, 사이트관리자인 경우 그룹관리메뉴 접근가능하도록 처리
	           			if(mygroup_ck || admin_ck) {
	               	%>
	               	<ul>
	   					<li>
		               		<a href="<%= path %>/mypage/group/groupList.jsp" class="<% if(strMenuId.equals("menu_02")){out.print("on");}%>" title="" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
		               			<%=subMenuMap.get(SubMenu.CreateClassManagement.getValue()).getNameByLang() %></a>
		               	</li>
						<li style="position:relative;">
							<a href="<%= path %>/mypage/group/groupMember.jsp" class="<% if(strMenuId.equals("menu_04")){out.print("on");}%>" title=""><%=subMenuMap.get(SubMenu.Members.getValue()).getNameByLang() %></a>
							<% if(noJoinCnt > 0) { %>
									<span style="position:absolute;right:20px; top:15px; z-index:10; cursor:pointer;" onclick="javascript:location.href='<%= path %>/mypage/group/groupJoinWating.jsp';" title="가입요청자 <%=noJoinCnt %>명">
										[<%=noJoinCnt %>]
									</span>
							<% } %>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/grouplog_member.jsp" class="<% if(strMenuId.equals("menu_05_02")){out.print("on");}%>" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
								<%=subMenuMap.get(SubMenu.ActivityIndexOfMembers.getValue()).getNameByLang() %></a>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/learningStatus.jsp" class="<% if(strMenuId.equals("menu_05_03")){out.print("on");}%>"><fmt:message key = "learningStatus" /></a>
						</li>
						<li>
							<a href="<%= path %>/mypage/group/menuName.jsp" class="<% if(strMenuId.equals("menu_08")){out.print("on");}%>" style="<% if(lang.equals("en")){ %> height:65px; line-height:20px; padding-top:12px; <% } %>">
								<%=subMenuMap.get(SubMenu.MenuNameManagement.getValue()).getNameByLang() %></a>
						</li>
					</ul>
					<%
						}
	               	}
	               	
	             	if(use_haksa_info && mygroup_ck) {
	             	%>
	             	<ul>
						<li class="myM<% if(strMenuId.equals("menu_07")){out.print("e");}%>">
							<div style="font-size:13px;">
								<a href="<%=path%>/mypage/group/groupListHaksa.jsp" >학사정보연동</a>
							</div>
						</li>
					</ul>
					<% 
					} 
				} %>              
		</nav>
		
		<% if(cur_url.indexOf(path + "/mypage/group/") >= 0 || cur_url.indexOf(path + "/mypage/group/index.jsp") >= 0){ %>
		<div class="benner">
		<nav>
             <% //레포트에서만 나타나도록 <표절검색시스템 카피킬러>          	  
         	 boolean use_copykiller = true;
         	 String strUseCopykiller = (String)session.getAttribute("use_copykiller");
         	 
         	 if(strUseCopykiller == null) {
         		String conf_ck = db.getConfigInfo("useCopyKiller");
         		if(conf_ck != null) session.setAttribute("use_copykiller", conf_ck);
         		if(conf_ck == null || conf_ck.equals("false")) use_copykiller = false;
         	 }else
         		if(strUseCopykiller.equals("false")) use_copykiller = false;
         	
              if(use_copykiller){ 
              %>				
			  <div onclick="javascript:location.href='<%=path%>/copykiller/login.jsp';" 
			  		style="width:auto;cursor:pointer;border:1px solid #c2c2c2;padding:8px 0;margin:0px 0 10px 0;text-align:center;">
				 <img src="<%=path%>/img/copykiller.png" width="78px" title="표절검색시스템" /> 
				 <br /><span style="line-height:190%;color:#084e8b;font-weight:bold;"><fmt:message key='paperCopySystemBtn' /></span>
			  </div>
			  <%
			  } %> 
<script>
	function goCourseRegisterHelper() {
		window.open('<%=path%>/ontoweb/search.jsp?search_query=알고리즘', 'CR_Helper');		
	}
	function goContentsManageSystem() {
		window.open('<%=path%>/cms/', 'CMS');
	}
	function goContentsManageSystemOfDISU() {
		window.open('<%=path%>/disucms/', 'DISU-CMS');
	}
</script>	         
	         <% //수강신청 도우미          	  
         	 boolean use_courseRegHelper = true;
         	 String strCourseRegHelper = (String)session.getAttribute("use_courseRegHelper");
         	 
         	 if(strCourseRegHelper == null) {
         		String conf_ck = db.getConfigInfo("useHelperForCourseReg");
         		if(conf_ck != null) session.setAttribute("use_courseRegHelper", conf_ck);
         		if(conf_ck == null || conf_ck.equals("false")) use_courseRegHelper = false;
         	 }else
         		if(strCourseRegHelper.equals("false")) use_courseRegHelper = false;
         	 
              if(use_courseRegHelper){ 
              %>				
			  <div onclick="javascript:goCourseRegisterHelper();"
			  		style="background-color:#fff;width:auto;cursor:pointer;border:1px solid #c2c2c2;line-height:140%;padding:8px 0;margin:0px 0 10px 0;text-align:center;">
				 <span style="color:#084e8b;font-weight:bold;"><fmt:message key='classRegHelperBtn' /></span><br/>
				 <span style="font-size:10px;color:#084e8b;padding:3px 0;"><fmt:message key='classRegHelperBtnNote' /></span>
			  </div>
			  <%
			  } %>
			  
			<div onclick="window.open('https://bigdatahub.ac.kr/curriculum/mdnd')"
				style="background-color:#fff;width:auto;cursor:pointer;border:1px solid #c2c2c2;line-height:140%;padding:8px 0;margin:0px 0 10px 0; text-align:center;">
				<span style="color:#084e8b;font-weight:bold;">진로설계 도우미 <!-- AI 선배 과목 추천 --></span><br/>
				<span style="font-size:10px;color:#084e8b;padding:3px 0;">(DEMO)</span>
			</div>
				  
			<div onclick="window.open('https://bigdatahub.ac.kr/')"
				style="background-color:#fff;width:auto;cursor:pointer;border:1px solid #c2c2c2;line-height:140%;padding:8px 0;margin:0px 0 10px 0;text-align:center;">
				<span style="color:#084e8b;font-weight:bold;">디지털 혁신공유대학 사업단</span><br/>
				<span style="font-size:14px;color:#084e8b;padding:3px 0;">콘텐츠 관리 시스템 (DEMO)</span>
			</div>
			
			<div onclick="window.open('https://bigdatacms.co.kr/login')"
				style="background-color:#fff;width:auto;cursor:pointer;border:1px solid #c2c2c2;line-height:140%;padding:8px 0;margin:0px 0 10px 0;text-align:center;">
				<span style="color:#084e8b;font-weight:bold;">Enook LCMS</span><br/>
				<span style="font-size:14px;color:#084e8b;padding:3px 0;">(Evolving Notebook of Our Knowledge)</span>
			</div>
			
			<div onclick="window.open('https://spa.elpai.org/kg-wiki/COSS/COSS#%EC%96%B8%EC%96%B4%EC%9D%B8%EC%A7%80%EB%8D%B0%EC%9D%B4%ED%84%B0_%EC%B8%A1%EC%A0%95_%EB%B0%8F_%ED%99%9C%EC%9A%A9_%ED%99%95%EC%9E%A5')"
				style="background-color:#fff;width:auto;cursor:pointer;border:1px solid #c2c2c2;line-height:140%;padding:8px 0;margin:0px 0 20px 0;text-align:center;">
				<span style="color:#084e8b;font-weight:bold;">elp AI</span><br/>
				<span style="font-size:14px;color:#084e8b;padding:3px 0;">COSS Ontology</span>
			</div>
			  
			  <%-- 23.07.17 임시 주석 처리
			  <% 
			  if(host.equals("CSEHub") || host.equals("NewKhub")) { %>
			  <div onclick="javascript:goContentsManageSystemOfDISU();"
					style="background-color:#19767e;width:245px;cursor:pointer;border:2px solid #196970;line-height:140%;padding:8px 0;margin:-10px 0 20px 0;text-align:center;">
				<span style="color:white;font-weight:bold;">디지털 혁신공유대학 사업단</span><br/>
				<span style="font-size:14px;color:white;padding:3px 0;">콘텐츠 관리 시스템 (DEMO)</span>
			  </div>
			  <% }
			     if(host.equals("CSEHub")) {
			  %>
			  <div onclick="javascript:goContentsManageSystem();"
			  		style="background-color:#6a7ba3;width:196px;cursor:pointer;border:2px solid #5c6e97;line-height:140%;padding:4px 0 2px 0;margin:5px 0 0 0;text-align:center;">
				 <span style="color:white;font-weight:bold;">콘텐츠 관리 시스템</span><br/>
				 <span style="font-size:10px;color:white;padding:3px 0;">(DEMO)</span>
			  </div>
			  <% } %>
			  --%>
		</nav>
		</div>
		<% } %>

			<div style="margin-top:10px; <% if(cur_url.indexOf(path+"/mypage/group/groupList.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/groupMember.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/groupInvite.jsp") >= 0 	
											|| cur_url.indexOf(path+"/mypage/group/groupJoinWating.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/grouplog_member.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/menuName.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/addGroupThroughExcel.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/memberCopyJoin.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/learningStatus.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/learningStatusDetail.jsp") >= 0 
											){ %> width:200px; <%} %>;">
    		<div class="mjbox">
      			<h3><fmt:message key = "news" /><span class="mjnum"><%=noJoinCnt %></span></h3> <!-- 새 소식 -->
	         
<%
int count = 0;
String reg_date = "";

for(int x=0; x<newsList.size(); x++) {
   	GroupInfo groupInfo = (GroupInfo)newsList.get(x);
	count = groupInfo.getTotal();

	Date strDate = groupInfo.getDate();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
	if(strDate != null) reg_date = sdf.format(strDate);

    if(count > 0){
%>
      			<div class="memct">
        			<div class="memcbox">
		 			<a href="<%=path%>/mypage/group/groupJoinWating.jsp?group_id=<%=groupInfo.getId()%>">
           				<div class="memtit"><%=groupInfo.getName() %></div>
           				<div class="memstit">
               				<%-- <p><%=newConf.getString("menuGroupName")%>가입 요청 <%=count%>건이 있습니다. </p> --%>
               				<p><fmt:message key = "groupJoinRequestText1-1" />&nbsp;<%=count %>&nbsp;<fmt:message key = "groupJoinRequestText1-2" /></p>
               				<p><%=reg_date %></p>
           				</div>
		   			</a>
         			</div>    
      			</div>
<%
    }
}
if(noJoinCnt == 0) {%>
				<div class="memct">
					<div class="memcbox">
						<div class="memtit">
	        			<div class="memstit">
	  						<p><fmt:message key = "noClassJoinRequestText" /></p>
	        			</div>
	        			</div>
	        		</div>
	        	</div>
<%
} %>
	        </div>
		</div> <!-- 새 소식 끝 -->

<style>
.deadlineBtn{
	position:absolute;
	top:17px;
	right: -7px;
	width: 55px;
	border-radius: 3px;
	font-weight: bold;
	color: #454545;
	background:#f9f9f9;
}
</style>
<script>
function openClose(){
	var board = document.getElementById("deadlineBoard");
	var btn = document.getElementById("deadlineBtn");
	if(board.style.display == 'none'){
		board.style.display='block';
		btn.innerText='<fmt:message key = "close2" />';
	}else{
		board.style.display='none';		
		btn.innerText='<fmt:message key = "open" />';
	}
}
</script>
<%
myGroupProc myGroupDb = new myGroupProc(dbname);
List<DeadlineInfo> deadlineList = myGroupDb.getDeadlineList(user_id);

%>
<% if(deadlineList.size() > 0){ %>		
			<div style="margin-top:10px; <% if(cur_url.indexOf(path+"/mypage/group/groupList.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/groupMember.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/grouplog_member.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/menuName.jsp") >= 0 
											|| cur_url.indexOf(path+"/mypage/group/learningStatus.jsp") >= 0
											|| cur_url.indexOf(path+"/mypage/group/learningStatusDetail.jsp") >= 0
											|| cur_url.indexOf(path+"/mypage/group/learningStatusDetailStu.jsp") >= 0
											){ %> width:200px; <%} %>;">
    		<div class="mjbox">
      			<h3 style="position:relative;">
      				<fmt:message key = "closingSoon" />
      				<span class="mjnum"><%=deadlineList.size() %></span> 
      				<button id="deadlineBtn" class="deadlineBtn" onclick="javascript:openClose();"><fmt:message key = "close2" /></button>
      			</h3>
      			<div id="deadlineBoard">

<%for(DeadlineInfo dInfo : deadlineList ){ 
	
	String deadline = dInfo.getDeadlineTime();
	String pathParam = "#";
	if(dInfo.getCategory() == 1) pathParam = "/mypage/data/dataList.jsp?group_id="+dInfo.getGroupId();
	else if(dInfo.getCategory() == 2) pathParam = "/paper/paperList.jsp?group_id="+dInfo.getGroupId();
	else if(dInfo.getCategory() == 3) pathParam = "/quiz/quizList.jsp?group_id="+dInfo.getGroupId();
%>		
      			<div class="memct">
        			<div class="memcbox">
		 			<a href="<%=path%><%=pathParam%>">
           				<div class="memstit">
               				<p style="font-size:17px; font-weight: bold;color:#3969aa;"><%=dInfo.getGroupNameByLang(lang) %></p>
               				<p><%=dInfo.getCategoryStr(lang) %>: <%= dInfo.getTitle() %></p>
               				<p><fmt:message key = "close" />: <%=deadline %></p>
               				<p><%=dInfo.getStatusStr(lang)%></p>
           				</div>
		   			</a>
         			</div>    
      			</div>

	<%} %>
			</div>		
		</div>
	</div>
<%} %>
    </div>
