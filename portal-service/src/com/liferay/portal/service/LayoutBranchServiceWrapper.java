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

package com.liferay.portal.service;

/**
 * <p>
 * This class is a wrapper for {@link LayoutBranchService}.
 * </p>
 *
 * @author    Brian Wing Shun Chan
 * @see       LayoutBranchService
 * @generated
 */
public class LayoutBranchServiceWrapper implements LayoutBranchService {
	public LayoutBranchServiceWrapper(LayoutBranchService layoutBranchService) {
		_layoutBranchService = layoutBranchService;
	}

	public com.liferay.portal.model.LayoutBranch addLayoutBranch(
		long layoutRevisionId, java.lang.String name,
		java.lang.String description, boolean master,
		com.liferay.portal.service.ServiceContext serviceContext)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
		return _layoutBranchService.addLayoutBranch(layoutRevisionId, name,
			description, master, serviceContext);
	}

	public void deleteLayoutBranch(long layoutBranchId)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
		_layoutBranchService.deleteLayoutBranch(layoutBranchId);
	}

	public com.liferay.portal.model.LayoutBranch updateLayoutBranch(
		long layoutBranchId, java.lang.String name,
		java.lang.String description,
		com.liferay.portal.service.ServiceContext serviceContext)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
		return _layoutBranchService.updateLayoutBranch(layoutBranchId, name,
			description, serviceContext);
	}

	public LayoutBranchService getWrappedLayoutBranchService() {
		return _layoutBranchService;
	}

	public void setWrappedLayoutBranchService(
		LayoutBranchService layoutBranchService) {
		_layoutBranchService = layoutBranchService;
	}

	private LayoutBranchService _layoutBranchService;
}