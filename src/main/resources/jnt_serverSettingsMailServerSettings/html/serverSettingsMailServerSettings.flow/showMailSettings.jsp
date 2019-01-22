<%@ page language="java" contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ page import="org.jahia.settings.SettingsBean" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>
<%--@elvariable id="mailSettings" type="org.jahia.services.mail.MailSettings"--%>
<%--@elvariable id="flowRequestContext" type="org.springframework.webflow.execution.RequestContext"--%>
<template:addResources type="javascript" resources="jquery.min.js,jquery-ui.min.js,admin-bootstrap.js,bootstrapSwitch.js"/>
<template:addResources type="css" resources="jquery-ui.smoothness.css,jquery-ui.smoothness-jahia.css,bootstrapSwitch.css"/>

<script type="text/javascript">
    <!--
    function testSettings() {
        if (document.jahiaAdmin.uri.value.length == 0) {
        <fmt:message key="serverSettings.mailServerSettings.errors.server.mandatory" var="msg"/>
            alert("${functions:escapeJavaScript(msg)}");
            document.jahiaAdmin.uri.focus();
        } else if (document.jahiaAdmin.to.value.length == 0) {
        <fmt:message key="serverSettings.mailServerSettings.errors.administrator.mandatory" var="msg"/>
            alert("${functions:escapeJavaScript(msg)}");
            document.jahiaAdmin.to.focus();
        } else if (document.jahiaAdmin.from.value.length == 0) {
        <fmt:message key="serverSettings.mailServerSettings.errors.from.mandatory" var="msg"/>
            alert("${functions:escapeJavaScript(msg)}");
            document.jahiaAdmin.from.focus();
        } else {
            if (typeof workInProgressOverlay != 'undefined') {
                workInProgressOverlay.start();
            }

            $.ajax({
                url:'${url.context}/cms/notification/testEmail',
                type:'POST',
                dataType:'text',
                cache:false,
                data:{
                    host:document.jahiaAdmin.uri.value,
                    from:document.jahiaAdmin.from.value,
                    to:document.jahiaAdmin.to.value
                },
                success:function (data, textStatus) {
                    if (typeof workInProgressOverlay != 'undefined') {
                        workInProgressOverlay.stop();
                    }
                    if ("success" == textStatus) {
                    <fmt:message key="serverSettings.mailServerSettings.testSettings.success" var="msg"/>
                        alert("${functions:escapeJavaScript(msg)}");
                    } else {
                    <fmt:message key="serverSettings.mailServerSettings.testSettings.failure" var="msg"/>
                        alert("${functions:escapeJavaScript(msg)}");
                    }
                },
                error:function (xhr, textStatus, errorThrown) {
                    if (typeof workInProgressOverlay != 'undefined') {
                        workInProgressOverlay.stop();
                    }
                    <fmt:message key="serverSettings.mailServerSettings.testSettings.failure" var="msg"/>
                    alert("${functions:escapeJavaScript(msg)}" + "\n" + xhr.status + " " + xhr.statusText + "\n" +
                          xhr.responseText);
                }
            });
        }
    }//-->

    function validateRegex(element) {
        var regexEmail = RegExp('[A-Za-z0-9._%+-]+@(?:[A-Za-z0-9-]+\\.)+[A-Za-z]{2,}');
        var validMail = true;
        var toSplit = $("input[name="+element+"]").get(0).value.split(',');
        $(toSplit).each(function(index, mail) {
            if (validMail) {
                if (!regexEmail.test(mail)) {
                    var formGroup = $("#group-"+element);
                    alert(formGroup.get(0).getAttribute("data-error"));
                    formGroup.addClass('error');
                }

                validMail = false;
            }
        });
        return validMail;
    }

    function validateForm() {
        var valid = true;
        var toTest = ["to","from"];
        $(toTest).each(function(index, formInput) {
                $("#group-"+formInput).removeClass('error');
                if (valid) {
                    valid = validateRegex(formInput);
                }
            }
        );

        return valid;
    }

    var academyLink = "<%= SettingsBean.getInstance().getString("mailConfigurationAcademyLink","https://academy.jahia.com/documentation/knowledge-base/configuration-mail-server-in-jahia")%>";
    window.onload = function() { document.getElementById('academyBtn').setAttribute('href',academyLink)};

    function toggleVisibility() {
        var $uriEntry = $('#uriEntry');
        var $visibilityIcon = $('#visibilityIcon');
        var isPassword = $uriEntry.get(0).getAttribute("type") === "password";
        $uriEntry.get(0).setAttribute("type", isPassword ? "text" : "password");
        isPassword ? $visibilityIcon.switchClass("icon-eye-open","icon-eye-close") :
            $visibilityIcon.switchClass("icon-eye-close","icon-eye-open");
    }
    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip();
    });
</script>


<h2>
    <fmt:message key="serverSettings.mailServerSettings"/>
</h2>
<p>
    <c:forEach items="${flowRequestContext.messageContext.allMessages}" var="message">
        <c:if test="${message.severity eq 'ERROR'}">
            <div class="alert alert-error">
                <button type="button" class="close" data-dismiss="alert">&times;</button>
                    ${message.text}
            </div>
        </c:if>
    </c:forEach>
</p>
<c:if test="${settingsUpdated}">
<div class="alert alert-success">
    <button type="button" class="close" data-dismiss="alert">&times;</button>
    <fmt:message key="label.changeSaved"/>
</div>
</c:if>
<div class="box-1">
    <form class="form-horizontal" name="jahiaAdmin" action='${flowExecutionUrl}' method="post">

        <div class="control-group">
            <div class="controls">
                <label for="serviceActivated">
                    <div class="switch" data-on="success" data-off="danger">
                        <input type="checkbox" name="serviceActivated" id="serviceActivated"<c:if test='${mailSettings.serviceActivated}'> checked="checked"</c:if>/>
                    </div>
                    <input type="hidden" name="_serviceActivated"/>
                    &nbsp;<fmt:message key="serverSettings.mailServerSettings.serviceEnabled"/>
                </label>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label"><fmt:message key="serverSettings.mailServerSettings.address"/> &nbsp;:</label>
            <div class="controls ">
                <input type="password" id="uriEntry" name="uri" size="70" maxlength="250"
                       value="<c:out value='${mailSettings.uri}'/>"/>&nbsp;
                <span onclick="toggleVisibility()" class="btn">
                    <i id="visibilityIcon" class="icon-eye-open"></i>
                </span>
                <a class="btn btn-info" id="academyBtn" target="_blank"
                   style="cursor: pointer;"><i class="icon-info-sign icon-white"></i></a>
            </div>
        </div>

        <div class="control-group" id="group-to" data-error="<fmt:message key="serverSettings.mailServerSettings.errors.emailList"/>">
            <label class="control-label"><fmt:message key="serverSettings.mailServerSettings.administrator"/>&nbsp;:</label>
            <div class="controls">
                <input type="text" name="to" size="64" maxlength="250" value="<c:out value='${mailSettings.to}'/>">
                <a class="btn btn-info" target="_blank" data-toggle="tooltip" data-placement="right" title="<fmt:message key="serverSettings.mailServerSettings.administratorTooltip"/>">
                    <i class="icon-info-sign icon-white"></i>
                </a>
            </div>
        </div>

        <div class="control-group" id="group-from" data-error="<fmt:message key="serverSettings.mailServerSettings.errors.email"/>">
            <label class="control-label"><fmt:message key="serverSettings.mailServerSettings.from"/>&nbsp;:</label>
            <div class="controls">
                <input type="text" name="from" size="64" maxlength="250" value="<c:out value='${mailSettings.from}'/>">
            </div>
        </div>

        <div class="control-group">
            <label class="control-label"><fmt:message key="serverSettings.mailServerSettings.eventNotificationLevel"/>&nbsp;:</label>
            <div class="controls">
                <select name="notificationLevel">
                    <option value="Disabled" ${mailSettings.notificationLevel == 'Disabled' ? 'selected="selected"' : ''}>
                        <fmt:message key="serverSettings.mailServerSettings.eventNotificationLevel.disabled"/></option>
                    <option value="Standard" ${mailSettings.notificationLevel == 'Standard' ? 'selected="selected"' : ''}>
                        <fmt:message key="serverSettings.mailServerSettings.eventNotificationLevel.standard"/></option>
                    <option value="Wary" ${mailSettings.notificationLevel == 'Wary' ? 'selected="selected"' : ''}>
                        <fmt:message key="serverSettings.mailServerSettings.eventNotificationLevel.wary"/></option>
                    <option value="Paranoid" ${mailSettings.notificationLevel == 'Paranoid' ? 'selected="selected"' : ''}>
                        <fmt:message key="serverSettings.mailServerSettings.eventNotificationLevel.paranoid"/></option>
                </select>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label" for="workflowNotificationsDisabled"><fmt:message key="serverSettings.mailServerSettings.workflowNotificationsDisabled"/>&nbsp;:</label>
            <div class="controls">
                    <input type="checkbox" name="workflowNotificationsDisabled" id="workflowNotificationsDisabled" ${mailSettings.workflowNotificationsDisabled ?'checked="checked"' : ''}/>
                <input type="hidden" name="_workflowNotificationsDisabled"/>
            </div>
        </div>

        <div class="control-group">
            <div class="controls">
                <button class="btn btn-primary" type="submit" onclick="return validateForm()" name="_eventId_submitMailSettings">
                    <i class="icon-ok icon-white"></i>
                    &nbsp;<fmt:message key="label.save"/></button>
                <button class="btn" type="button" onclick="testSettings(); return false;">
                    <i class="icon-thumbs-up"></i>&nbsp;<fmt:message key="serverSettings.mailServerSettings.testSettings"/></button>
            </div>
        </div>
    </form>
</div>
