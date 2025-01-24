<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ page import="es.bean.*, com.ktech.conf.Conf" %>
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
String dbname = com.ktech.conf.Conf.getInstance().getString("dbname");
String path = com.ktech.conf.Conf.getInstance().getString("path");
String sys_url = com.ktech.conf.Conf.getInstance().getString("sys_url");
String strSearchCheck = request.getParameter("search_ck");
int s_ck = 0;
if(strSearchCheck != null) s_ck = Integer.parseInt(strSearchCheck);

Integer intUser_id = (Integer)session.getAttribute("user_id");
String user_name = (String)session.getAttribute("user_name");
int user_id = 0;

if(intUser_id != null)
	user_id = intUser_id.intValue();

DBProc db = new DBProc(dbname);

String host = hostName;
if(host == null) host = "";
%>
<script type="Text/javascript">
function goHelp() {
	if(<%=user_id%> == 0) {
   		alert("로그인 후 사용해주세요.");
        return;
	}else{
    	window.open("<%=path %>/help/errorReport.jsp", "HelpWindow", "width=650,height=640,toolbar=no,resizable=no,scrollbars=no");
	}
}
</script>
<!--{* copyAll start *}-->
<section class="footDiv">
	<div class="footer">
		<div class="inner">
			<div class="policybox">
				<ul>
					<li><a href="<%=path %>/login/policy.jsp"><span> <fmt:message key = "policy" /></span></a></li>
					<li><a href="<%=path %>/login/private.jsp"><span><fmt:message key = "privacyPolicy" /></span></a></li>
					<li><a href="https://map.naver.com/p/entry/place/18733888?c=15.00,0,0,0,dh" target="_blank"><span><fmt:message key = "location" /></span></a></li>
					<li><a href="<%=path %>/mobile/web/app"><span><fmt:message key = "mobileVersion" /></span></a></li>
					<li><a href="#"><span><fmt:message key = "about" /></span></a></li>
					<li><a href="<%=path %>/faq/index.jsp"><span><fmt:message key = "cs" /></span></a></li>

				</ul>
			</div>
			<div class="select_box">
				<button type="button" class="site_open" style="display: inline-block;">관련 기관 홈페이지</button>
				<!-- 이부분부터 위쪽으로 나오게 -->
				<ul class="site_list" style="display: none;">
					<li><a href="#" target="_blank">대학 포털</a></li>
					<li><a href="#" target="_blank">학사관리시스템 (교수/학생)</a></li>
					<li><a href="#" target="_blank">학사관리시스템 (교직원)</a></li>
					<li><a href="#" target="_blank">수강신청</a></li>
					<li><a href="#" target="_blank">개설강좌</a></li>
					<li><a href="#" target="_blank">등록금 안내</a></li>
					<li><a href="#" target="_blank">평생교육원</a></li>
					<li><a href="#" target="_blank">취업진로처</a></li>
					<li><a href="#" target="_blank">창업교육센터</a></li>
					<li><a href="#" target="_blank">창업지원단</a></li>
					<li><a href="#" target="_blank">산학협력단</a></li>
				</ul>
				<button type="button" class="site_close close" style="display: none;">관련 사이트 목록 닫기 X</button>
			</div>
		</div>
	</div>
	<div class="footaddress">
		<div class="inner">
			<div class="addressGrap">
				<div class="addressbox">
					<div class="addressw">
						<div class="addresstitle">
							(08826)서울특별시 관악구 관악로 1 102동 206호 빅데이터 혁신융합대학사업단  &nbsp;&nbsp;<br/>
							콜센터&nbsp;&nbsp;☎ TEL&nbsp;02-889-5708  <br/>
							빅데이터 혁신융합대학 사업단 &nbsp;<br/>
							@COPYRIGHT BIGDATAHUB UNIVERSITY. ALL RIGHT RESERVED
						</div>
					</div>
				</div>
				<div class="footsns">
					<span> 
					<!-- a class="addthis_sns_url btn-sns1" href="https://www.youtube.com/channel/UCJzEYFv0PUZEsRPcKz_ffOQ" target="_blank" title="유튜브 공유">
					</a> <a class="addthis_sns_url btn-sns2" href="https://www.facebook.com/jvision76" target="_blank" title="페이스북 공유"></a> 
					<a class="addthis_sns_url btn-sns3" href="http://instagram.com/jeonju_vision" target="_blank" title="인스타 공유"></a>
					 <a class="addthis_sns_url btn-sns4" href="https://blog.naver.com/jvu_mngr" target="_blank" title="네이버 공유"></a -->
					</span>
				</div>
				<div class="footsnsw"></div>
			</div>
		</div>
	</div>
</section>
