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

package com.liferay.portalweb.portal.controlpanel.webcontent.templates.addtemplateassociated;

import com.liferay.portalweb.portal.BaseTestCase;
import com.liferay.portalweb.portal.util.RuntimeVariables;

/**
 * @author Brian Wing Shun Chan
 */
public class AddStructureTest extends BaseTestCase {
	public void testAddStructure() throws Exception {
		selenium.open("/web/guest/home/");

		for (int second = 0;; second++) {
			if (second >= 60) {
				fail("timeout");
			}

			try {
				if (selenium.isElementPresent("link=Control Panel")) {
					break;
				}
			}
			catch (Exception e) {
			}

			Thread.sleep(1000);
		}

		selenium.saveScreenShotAndSource();
		selenium.clickAt("link=Control Panel",
			RuntimeVariables.replace("Control Panel"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.clickAt("link=Web Content",
			RuntimeVariables.replace("Web Content"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.clickAt("link=Structures",
			RuntimeVariables.replace("Structures"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.clickAt("//input[@value='Add Structure']",
			RuntimeVariables.replace("Add Structure"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.type("//input[@id='_15_name_en_US']",
			RuntimeVariables.replace("Web Content Structure Name"));
		selenium.saveScreenShotAndSource();
		selenium.type("//textarea[@id='_15_description_en_US']",
			RuntimeVariables.replace("Web Content Structure Description"));
		selenium.saveScreenShotAndSource();
		selenium.clickAt("//input[@value='Add Row']",
			RuntimeVariables.replace("Add Row"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.type("//input[@id='_15_structure_el0_name']",
			RuntimeVariables.replace("Itp"));
		selenium.saveScreenShotAndSource();
		selenium.select("//select[@id='_15_structure_el0_type']",
			RuntimeVariables.replace("label=Link to Page"));
		selenium.clickAt("//input[@value='Add Row']",
			RuntimeVariables.replace("Add Row"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		selenium.type("//input[@id='_15_structure_el0_name']",
			RuntimeVariables.replace("title"));
		selenium.saveScreenShotAndSource();
		selenium.select("//select[@id='_15_structure_el0_type']",
			RuntimeVariables.replace("label=Text"));
		selenium.clickAt("//input[@value='Save']",
			RuntimeVariables.replace("Save"));
		selenium.waitForPageToLoad("30000");
		selenium.saveScreenShotAndSource();
		assertEquals(RuntimeVariables.replace(
				"Your request completed successfully."),
			selenium.getText("//div[@class='portlet-msg-success']"));
		assertTrue(selenium.isElementPresent("//td[2]/a"));
		assertEquals(RuntimeVariables.replace("Web Content Structure Name"),
			selenium.getText("//td[3]/a"));
		assertEquals(RuntimeVariables.replace(
				"Web Content Structure Description"),
			selenium.getText("//td[4]/a"));
	}
}