<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<template:addResources type="javascript" resources="jquery.min.js,jquery.blockUI.js,workInProgress.js"/>
<fmt:message key="label.workInProgressTitle" var="i18nWaiting"/><c:set var="i18nWaiting" value="${functions:escapeJavaScript(i18nWaiting)}"/>
<template:addResources>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#${currentNode.identifier}-deleteSitesConfirmed').click(function() {workInProgress('${i18nWaiting}');});
        });
    </script>
</template:addResources>

<h2><fmt:message key="label.confirmContinue"/></h2>
<div class="alert alert-error">
    <fmt:message key="serverSettings.manageWebProjects.delete.warning"/>
</div>

<form action="${flowExecutionUrl}" method="post">
    <table class="table table-bordered table-striped table-hover">
        <thead>
            <tr>
                <th>
                    <fmt:message key="label.name" />
                </th>
                <th>
                    <fmt:message key="serverSettings.manageWebProjects.webProject.siteKey" />
                </th>
                <th>
                    <fmt:message key="serverSettings.manageWebProjects.webProject.serverName" />
                </th>
                <th>
                    <fmt:message key="serverSettings.manageWebProjects.webProject.templateSet" />
                </th>
            </tr>
        </thead>
        <tbody>
            <input name="_sites" type="hidden"/>
            <c:forEach items="${webprojectHandler.sites}" var="site">
                <tr>
                    <td><strong>${fn:escapeXml(site.title)}</strong></td>
                    <td>${fn:escapeXml(site.siteKey)}</td>
                    <td>${fn:escapeXml(site.serverName)}</td>
                    <td title="${fn:escapeXml(site.templatePackageName)}">${fn:escapeXml(site.templateFolder)}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <button class="btn btn-danger" type="submit" name="_eventId_deleteSitesConfirmed" id="${currentNode.identifier}-deleteSitesConfirmed">
        <i class="icon-remove icon-white"></i>
        &nbsp;<fmt:message key='label.delete' />
    </button>
    <button class="btn" type="submit" name="_eventId_cancel">
        <i class="icon-ban-circle"></i>
        &nbsp;<fmt:message key='label.cancel' />
    </button>
</form>


