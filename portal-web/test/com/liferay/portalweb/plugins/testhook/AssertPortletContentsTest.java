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

package com.liferay.portalweb.plugins.testhook;

import com.liferay.portalweb.portal.BaseTestCase;
import com.liferay.portalweb.portal.util.RuntimeVariables;

/**
 * @author Brian Wing Shun Chan
 */
public class AssertPortletContentsTest extends BaseTestCase {
	public void testAssertPortletContents() throws Exception {
		selenium.open("/web/guest/home/");

		for (int second = 0;; second++) {
			if (second >= 60) {
				fail("timeout");
			}

			try {
				if (selenium.isVisible("link=Test Hook Page")) {
					break;
				}
			}
			catch (Exception e) {
			}

			Thread.sleep(1000);
		}

		selenium.saveScreenShotAndSource();
		selenium.clickAt("link=Test Hook Page",
			RuntimeVariables.replace("Test Hook Page"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		assertEquals(RuntimeVariables.replace("terms.of.use.required=PASSED"),
			selenium.getText("//div[@class='portlet-body']/p[1]"));
		assertEquals(RuntimeVariables.replace(
				"application.startup.events=PASSED"),
			selenium.getText("//div[@class='portlet-body']/p[2]"));
		assertTrue(selenium.isPartialText("//div[@class='portlet-body']/p[3]",
				"field.enable.com.liferay.portal.model.Contact.male=PASSED"));
		assertTrue(selenium.isPartialText("//div[@class='portlet-body']/p[3]",
				"field.enable.com.liferay.portal.model.Contact.birthday=PASSED"));
		assertTrue(selenium.isPartialText("//div[@class='portlet-body']/p[3]",
				"field.enable.com.liferay.portal.model.Organization.status=PASSED"));
		assertEquals(RuntimeVariables.replace("javax.portlet.title.33=PASSED"),
			selenium.getText("//div[@class='portlet-body']/p[4]"));
		assertEquals(RuntimeVariables.replace("/META-INF/custom_jsps=PASSED"),
			selenium.getText("//div[@class='portlet-body']/p[5]"));
		assertEquals(RuntimeVariables.replace(
				"com.liferay.portal.service.UserLocalService=PASSED"),
			selenium.getText("//div[@class='portlet-body']/p[6]"));
	}
}