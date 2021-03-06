<%--
/**
 * Copyright (c) 2000-2011 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/html/portlet/layouts_admin/init.jsp" %>

<%
Group selGroup = (Group)request.getAttribute(WebKeys.GROUP);

Group group = (Group)request.getAttribute("edit_pages.jsp-group");
Group liveGroup = (Group)request.getAttribute("edit_pages.jsp-liveGroup");

long groupId = ((Long)request.getAttribute("edit_pages.jsp-groupId")).longValue();
long liveGroupId = ((Long)request.getAttribute("edit_pages.jsp-liveGroupId")).longValue();
long stagingGroupId = ((Long)request.getAttribute("edit_pages.jsp-stagingGroupId")).longValue();

Layout selLayout = (Layout)request.getAttribute("edit_pages.jsp-selLayout");
long selPlid = ((Long)request.getAttribute("edit_pages.jsp-selPlid")).longValue();
long layoutId = ((Long)request.getAttribute("edit_pages.jsp-layoutId")).longValue();
boolean privateLayout = ((Boolean)request.getAttribute("edit_pages.jsp-privateLayout")).booleanValue();

PortletURL portletURL = (PortletURL)request.getAttribute("edit_pages.jsp-portletURL");
PortletURL redirectURL = (PortletURL)request.getAttribute("edit_pages.jsp-redirectURL");

long refererPlid = ParamUtil.getLong(request, "refererPlid", LayoutConstants.DEFAULT_PLID);

LayoutRevision layoutRevision = LayoutStagingUtil.getLayoutRevision(selLayout);

String layoutSetBranchName = StringPool.BLANK;

boolean incomplete = false;

if (layoutRevision != null) {
	LayoutSet layoutSet = selLayout.getLayoutSet();

	long recentLayoutSetBranchId = StagingUtil.getRecentLayoutSetBranchId(user, layoutSet.getLayoutSetId());

	incomplete = StagingUtil.isIncomplete(selLayout, recentLayoutSetBranchId);

	if (incomplete) {
		layoutRevision = LayoutRevisionLocalServiceUtil.getLayoutRevision(recentLayoutSetBranchId, selLayout.getPlid(), false);

		LayoutSetBranch layoutSetBranch = LayoutSetBranchLocalServiceUtil.getLayoutSetBranch(recentLayoutSetBranchId);

		layoutSetBranchName = layoutSetBranch.getName();
	}
}

String[] mainSections = PropsValues.LAYOUT_FORM_UPDATE;

if (!group.isUser() && selLayout.isTypePortlet()) {
	mainSections = ArrayUtil.append(mainSections, "customization-settings");
}

String[][] categorySections = {mainSections};
%>

<div class="lfr-header-row title">
	<div class="lfr-header-row-content">
		<liferay-util:include page="/html/portlet/layouts_admin/add_layout.jsp" />

		<aui:button-row cssClass="edit-toolbar" id='<%= liferayPortletResponse.getNamespace() + "layoutToolbar" %>' />
	</div>
</div>

<portlet:actionURL var="editLayoutURL">
	<portlet:param name="struts_action" value="/manage_pages/edit_layouts" />
</portlet:actionURL>

<aui:form action="<%= editLayoutURL %>" cssClass="edit-layout-form" enctype="multipart/form-data" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + liferayPortletResponse.getNamespace() + "saveLayout();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" />
	<aui:input name="redirect" type="hidden" value='<%= HttpUtil.addParameter(redirectURL.toString(), liferayPortletResponse.getNamespace() + "selPlid", selPlid) %>' />
	<aui:input name="groupId" type="hidden" value="<%= groupId %>" />
	<aui:input name="liveGroupId" type="hidden" value="<%= liveGroupId %>" />
	<aui:input name="stagingGroupId" type="hidden" value="<%= stagingGroupId %>" />
	<aui:input name="selPlid" type="hidden" value="<%= selPlid %>" />
	<aui:input name="privateLayout" type="hidden" value="<%= privateLayout %>" />
	<aui:input name="layoutId" type="hidden" value="<%= layoutId %>" />
	<aui:input name="friendlyURL" type="hidden" value="<%= (selLayout != null) ? selLayout.getFriendlyURL() : StringPool.BLANK %>" />
	<aui:input name="<%= PortletDataHandlerKeys.SELECTED_LAYOUTS %>" type="hidden" />

	<c:if test="<%= layoutRevision != null && !incomplete%>">
		<aui:input name="layoutSetBranchId" type="hidden" value="<%= layoutRevision.getLayoutSetBranchId() %>" />
	</c:if>

	<c:choose>
		<c:when test="<%= incomplete %>">
			<liferay-ui:message arguments="<%= new Object[] {selLayout.getName(locale), layoutSetBranchName} %>" key="the-page-x-is-not-enabled-in-x,-but-is-available-in-other-pages-variations" />

			<aui:input name="incompleteLayoutRevisionId" value="<%= layoutRevision.getLayoutRevisionId() %>" type="hidden" />

			<%
			String taglibEnableOnClick = "event.preventDefault(); " + liferayPortletResponse.getNamespace() + "saveLayout('enable');";

			String taglibDeleteOnClick = "event.preventDefault(); " + liferayPortletResponse.getNamespace() + "saveLayout('" + Constants.DELETE + "');";
			%>

			<aui:button-row>
				<aui:button name="enableLayout" onClick="<%= taglibEnableOnClick %>" value='<%= LanguageUtil.format(pageContext, "enable-in-x", layoutSetBranchName) %>' />

				<aui:button name="deleteLayout" onClick="<%= taglibDeleteOnClick %>" value="delete-in-all-pages-variations" />
			</aui:button-row>
		</c:when>
		<c:otherwise>
			<c:if test="<%= !group.isLayoutPrototype() && (selLayout != null) %>">
				<c:if test="<%= liveGroup.isStaged() %>">
					<liferay-ui:error exception="<%= RemoteExportException.class %>">

						<%
						RemoteExportException ree = (RemoteExportException)errorException;
						%>

						<c:if test="<%= ree.getType() == RemoteExportException.BAD_CONNECTION %>">
							<%= LanguageUtil.format(pageContext, "could-not-connect-to-address-x.-please-verify-that-the-specified-port-is-correct-and-that-the-remote-server-is-configured-to-accept-requests-from-this-server", "<em>" + ree.getURL() + "</em>") %>
						</c:if>

						<c:if test="<%= ree.getType() == RemoteExportException.NO_GROUP %>">
							<%= LanguageUtil.format(pageContext, "remote-group-with-id-x-does-not-exist", ree.getGroupId()) %>
						</c:if>

						<c:if test="<%= ree.getType() == RemoteExportException.NO_LAYOUTS %>">
							<liferay-ui:message key="no-pages-are-selected-for-export" />
						</c:if>
					</liferay-ui:error>

					<div class="portlet-msg-alert">
						<liferay-ui:message key="the-staging-environment-is-activated-changes-have-to-be-published-to-make-them-available-to-end-users" />
					</div>
				</c:if>

				<liferay-security:permissionsURL
					modelResource="<%= Layout.class.getName() %>"
					modelResourceDescription="<%= selLayout.getName(locale) %>"
					resourcePrimKey="<%= String.valueOf(selLayout.getPlid()) %>"
					var="permissionURL"
					windowState="<%= LiferayWindowState.POP_UP.toString() %>"
				/>

				<c:choose>
					<c:when test="<%= SitesUtil.isLayoutLocked(selLayout) %>">
						<div class="portlet-msg-alert">
							<liferay-ui:message key="this-page-is-locked-by-the-template" />
						</div>
					</c:when>
					<c:otherwise>
						<aui:script use="aui-dialog,aui-dialog-iframe,aui-toolbar">
							var buttonRow = A.one('#<portlet:namespace />layoutToolbar');

							var popup = null;

							var layoutToolbar = new A.Toolbar(
								{
									activeState: false,
									boundingBox: buttonRow,
									children: [
										<c:if test="<%= GroupPermissionUtil.contains(permissionChecker, groupId, ActionKeys.ADD_LAYOUT) %>">
											{
												handler: function(event) {
													if (!popup) {
														var content = A.one('#<portlet:namespace />addLayout');

														popup = new A.Dialog(
															{
																bodyContent: content.show(),
																centered: true,
																title: '<liferay-ui:message key="add-child-page" />',
																modal: true,
																width: 500
															}
														).render();
													}

													popup.show();

													Liferay.Util.focusFormField(content.one('input:text'));
												},
												icon: 'circle-plus',
												label: '<liferay-ui:message key="add-child-page" />'
											},
										</c:if>
										{
											handler: function(event) {
												Liferay.Util.openWindow(
													{
														cache: false,
														dialog: {
															width: 700
														},
														id: '<portlet:namespace /><%= selPlid %>_permissions',
														title: '<liferay-ui:message key="permissions" />',
														uri: '<%= permissionURL %>'
													}
												);
											},
											icon: 'key',
											label: '<liferay-ui:message key="permissions" />'
										},
										{
											handler: function(event) {
												<portlet:namespace />saveLayout('<%= Constants.DELETE %>');
											},
											icon: 'circle-minus',
											label: '<liferay-ui:message key="delete" />'
										}
									]
								}
							).render();

							buttonRow.setData('layoutToolbar', layoutToolbar);
						</aui:script>
					</c:otherwise>
				</c:choose>
			</c:if>

			<liferay-ui:form-navigator
				categoryNames="<%= _CATEGORY_NAMES %>"
				categorySections="<%= categorySections %>"
				jspPath="/html/portlet/layouts_admin/layout/"
				showButtons="<%= !SitesUtil.isLayoutLocked(selLayout) %>"
			/>
		</c:otherwise>
	</c:choose>
</aui:form>

<aui:script>
	Liferay.provide(
		window,
		'<portlet:namespace />saveLayout',
		function(action) {
			var A = AUI();

			action = action || '<%= Constants.UPDATE %>';

			if (action == '<%= Constants.DELETE %>') {
				<c:choose>
					<c:when test="<%= (selPlid == themeDisplay.getPlid()) || (selPlid == refererPlid) %>">
						alert('<%= UnicodeLanguageUtil.get(pageContext, "you-cannot-delete-this-page-because-you-are-currently-accessing-this-page") %>');

						return false;
					</c:when>
					<c:otherwise>
						if (!confirm('<%= UnicodeLanguageUtil.get(pageContext, "are-you-sure-you-want-to-delete-the-selected-page") %>')) {
							return false;
						}

						<c:if test="<%= layoutRevision == null || incomplete %>">
							document.<portlet:namespace />fm.<portlet:namespace />redirect.value = '<%= HttpUtil.setParameter(redirectURL.toString(), liferayPortletResponse.getNamespace() + "selPlid", selLayout.getParentPlid()) %>';
						</c:if>
					</c:otherwise>
				</c:choose>
			}
			else {
				document.<portlet:namespace />fm.<portlet:namespace />redirect.value += Liferay.Util.getHistoryParam('<portlet:namespace />');
			}

			document.<portlet:namespace />fm.<portlet:namespace /><%= Constants.CMD %>.value = action;

			submitForm(document.<portlet:namespace />fm);
		},
		['aui-base']
	);
</aui:script>

<%!
private static String[] _CATEGORY_NAMES = {""};
%>