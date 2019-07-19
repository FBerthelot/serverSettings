<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<template:addResources type="javascript" resources="jquery.min.js,jquery.blockUI.js,workInProgress.js"/>
<fmt:message key="label.workInProgressTitle" var="i18nWaiting"/><c:set var="i18nWaiting" value="${functions:escapeJavaScript(i18nWaiting)}"/>
<fmt:message key="serverSettings.manageWebProjects.warningMsg.serverNameChange" var="i18nServerNameChangeWarn"/><c:set var="i18nServerNameChangeWarn" value="${functions:escapeJavaScript(i18nServerNameChangeWarn)}"/>
<%--@elvariable id="siteBean" type="org.jahia.modules.serversettings.flow.SiteBean"--%>
<template:addResources>
    <script type="text/javascript">
        $(document).ready(function() {
            $("#${currentNode.identifier}-editModules").click(function() {
               $("#${currentNode.identifier}-eventId").val("editModules");
            });

            $("#${currentNode.identifier}-cancel").click(function() {
                $("#${currentNode.identifier}-eventId").val("cancel");
            });

            $("#${currentNode.identifier}-updateSiteForm").submit(function(event) {
                if ($("#${currentNode.identifier}-eventId").val() != 'next'
                        ||'${siteBean.serverName}' == $("#serverName").val()
                        || confirm('${i18nServerNameChangeWarn}')) {
                    workInProgress('${i18nWaiting}');
                    return;
                }
                event.preventDefault();
            });
        });
    </script>
</template:addResources>

<div class="page-header">
    <h2><fmt:message key="serverSettings.manageWebProjects.editSite"/></h2>
</div>


<c:if test="${!empty flowRequestContext.messageContext.allMessages}">
    <c:forEach var="error" items="${flowRequestContext.messageContext.allMessages}">
        <div class="alert alert-danger">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
                ${fn:escapeXml(error.text)}
        </div>
    </c:forEach>
</c:if>

<div class="row">
    <div class="col-md-offset-2 col-md-8">
        <div class="panel panel-default">
            <div class="panel-heading">
                <h4><fmt:message key="serverSettings.manageWebProjects.webProject.siteKey"/>: <strong>${fn:escapeXml(siteBean.siteKey)}</strong></h4>
            </div>
            <form id="${currentNode.identifier}-updateSiteForm" action="${flowExecutionUrl}" method="POST">
                <div class="panel-body">

                    <div class="form-group label-floating">
                        <label class="control-label" for="title">
                            <fmt:message key="label.name"/><strong class="text-danger">*</strong>
                        </label>
                        <input class="form-control" type="text" id="title" name="title" value="${fn:escapeXml(siteBean.title)}"/>
                    </div>

                    <div class="form-group label-floating">
                        <label class="control-label" for="serverName">
                            <fmt:message key="serverSettings.manageWebProjects.webProject.serverName"/><strong class="text-danger">*</strong>
                        </label>
                        <input class="form-control" type="text" id="serverName" name="serverName" value="${fn:escapeXml(siteBean.serverName)}"/>
                    </div>

                    <div class="form-group label-floating">
                        <label class="control-label" for="serverName">
                            <fmt:message key="serverSettings.manageWebProjects.webProject.serverNameAliases"/>
                        </label>
                        <input class="form-control" type="text" id="serverNameAliases" name="serverNameAliases" value="${fn:escapeXml(siteBean.serverNameAliases)}"/>
                    </div>

                    <div class="form-group label-floating">
                        <label>
                            <fmt:message key="serverSettings.manageWebProjects.webProject.templateSet"/>
                        </label>
                        <input class="form-control" type="text" value="${fn:escapeXml(siteBean.templatePackageName)}&nbsp;(${fn:escapeXml(siteBean.templateFolder)})" disabled />
                    </div>

                    <div class="form-group label-floating">
                        <label>
                            <fmt:message key="label.modules"/>
                            <button class="btn btn-default btn-fab btn-fab-xs" data-toggle="tooltip"
                                    data-container="body" title="<fmt:message key='serverSettings.manageWebProjects.webProject.selectModules' />"
                                    type="submit" id="${currentNode.identifier}-editModules">
                                <i class="material-icons">edit</i>
                            </button>
                        </label>
                        <p style="line-height: 2em">
                            <c:forEach items="${siteBean.modulePackages}" var="module" varStatus="loopStatus">
                                <c:choose>
                                    <c:when test="${module.moduleType eq 'system'}">
                                <span data-toggle="tooltip" class="label label-default" title="${module.moduleType}"
                                      data-placement="top" data-container="body">${module.name}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="label label-primary">${module.name}</span>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </p>
                    </div>

                    <div class="form-group">
                        <div class="checkbox">
                            <label for="defaultSite">
                                <c:if test="${numberOfSites > 1}">
                                    <input class="input-sm" type="checkbox" name="defaultSite" id="defaultSite"
                                           <c:if test="${siteBean.defaultSite}">checked="checked"</c:if> />
                                    <fmt:message key="serverSettings.manageWebProjects.webProject.defaultSite"/>
                                </c:if>
                                <c:if test="${numberOfSites <= 1}">
                                    <input class="input-sm" type="checkbox" name="defaultSite" id="defaultSite" disabled="disabled" checked="checked"/>
                                    <fmt:message key="serverSettings.manageWebProjects.webProject.isDefault"/>
                                </c:if>
                            </label>
                        </div>
                        <input type="hidden" name="_defaultSite"/>
                    </div>

                    <div class="form-group label-floating">
                        <label class="control-label" for="description">
                            <fmt:message key="label.description"/>
                        </label>
                        <textarea class="form-control" id="description" name="description">${fn:escapeXml(siteBean.description)}</textarea>
                    </div>

                    <input type="hidden" id="${currentNode.identifier}-eventId" name="_eventId" value="next" />

                    <div class="form-group form-group-sm">
                        <button class="btn btn-primary btn-raised pull-right" type="submit" id="${currentNode.identifier}-next">
                            <fmt:message key='label.save'/>
                        </button>
                        <button class="btn btn-default pull-right" type="submit" id="${currentNode.identifier}-cancel">
                            <fmt:message key='label.cancel' />
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>
