/*
 * Copyright 2014-2015 Arne Johanson
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.sprat.ecosystem.helper;

import java.util.ArrayList;

public class UnitCollection {
	String name;
	final ArrayList<SpratUnit> units = new ArrayList<>();
	
	public UnitCollection() {
		this("");
	}
	
	public UnitCollection(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ArrayList<SpratUnit> getUnits() {
		return units;
	}

	public void add(SpratUnit unit) {
		if(unit != null) {
			units.add(unit);
		}
	}
	
	//public void add(UnitCollection collection) {
	//	for(SpratUnit u : collection.getUnits()) {
	//		add(u);
	//	}
	//}
	
	public boolean contains(String unitName) {
		for(SpratUnit unit : units) {
			if(unit.getName().equals(unitName)) {
				return true;
			}
		}
		return false;
	}
	
	public String getBaseUnit() {
		for(SpratUnit unit : units) {
			if(unit.isBaseUnit()) {
				return unit.getName();
			}
		}
		return "";
	}
	
	public double convertToBaseUnit(String unitName, double value) {
		for(SpratUnit unit : units) {
			if(unit.getName().equals(unitName)) {
				return unit.convertToBaseUnit(value);
			}
		}
		return value;
	}

	public String formatConversionToBaseUnit(String unitName, String formattedString) {
		for(SpratUnit unit : units) {
			if(unit.getName().equals(unitName)) {
				return unit.formatConversionToBaseUnit(formattedString);
			}
		}
		return FormattingHelper.parenthize(formattedString);
	}
}
