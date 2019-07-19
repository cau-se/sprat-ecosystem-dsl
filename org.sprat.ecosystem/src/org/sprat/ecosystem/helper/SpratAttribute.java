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

public class SpratAttribute {
	final String name;
	final UnitCollection unitCategory;
	ValueRange range;
	
	final UnitCollection modifierUnitCategory;
	ValueRange modifierRange;
	boolean modifierIsOptional;
	double defaultModifier;
	
	final ArrayList<String> validIdentifiers = new ArrayList<>();
	
	static ValueRange defaultRange = new ValueRange(ValueRange.INF, ValueRange.INF);
	
	
	public SpratAttribute() {
		this("", null);
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory) {
		this(name, unitCategory, defaultRange,
				null, defaultRange, 0.0);
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory, ValueRange range) {
		this(name, unitCategory, range,
				null, defaultRange, 0.0);
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory, UnitCollection modifierUnitCategory) {
		this(name, unitCategory, modifierUnitCategory, 0.0);
		this.modifierIsOptional = false;
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory, UnitCollection modifierUnitCategory, double defaultModifier) {
		this(name, unitCategory, defaultRange,
				modifierUnitCategory, defaultRange, defaultModifier);
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory, ValueRange range, 
			UnitCollection modifierUnitCategory, ValueRange modifierRange) {
		this(name, unitCategory, range,
				modifierUnitCategory, modifierRange, 0.0);
		this.modifierIsOptional = false;
	}
	
	public SpratAttribute(String name, UnitCollection unitCategory, ValueRange range, 
			UnitCollection modifierUnitCategory, ValueRange modifierRange, double defaultModifier) {
		this.name = name;
		this.unitCategory = unitCategory;
		this.modifierUnitCategory = modifierUnitCategory;
		this.modifierIsOptional = true;
		this.defaultModifier = defaultModifier;
		this.range = range;
		this.modifierRange = modifierRange;
	}

	
	
	public String getName() {
		return name;
	}

	public UnitCollection getUnitCategory() {
		return unitCategory;
	}
	public ValueRange getRange() {
		return range;
	}

	public UnitCollection getModifierUnitCategory() {
		return modifierUnitCategory;
	}
	public ValueRange getModifierRange() {
		return modifierRange;
	}
	
	public boolean hasModifier() {
		return (modifierUnitCategory != null);
	}
	public boolean modifierIsOptional() {
		return modifierIsOptional;
	}
	public double getDefaultModifier() {
		return defaultModifier;
	}
	
	public boolean isValidUnit(String unitName) {
		if(unitCategory != null) {
			return unitCategory.contains(unitName);
		}
		if(unitName.isEmpty()) {
			return true;
		}
		return false;
	}
	
	public boolean isValidModifierUnit(String unitName) {
		if(modifierUnitCategory != null) {
			return modifierUnitCategory.contains(unitName);
		}
		if(unitName.isEmpty()) {
			return true;
		}
		return false;
	}
	
	public double convertValueToBaseUnit(String unitName, double value) {
		if(unitCategory != null) {
			return unitCategory.convertToBaseUnit(unitName, value);
		}
		return value;
	}
	
	public double convertModifierValueToBaseUnit(String unitName, double value) {
		if(modifierUnitCategory != null) {
			return modifierUnitCategory.convertToBaseUnit(unitName, value);
		}
		return value;
	}
	
	public boolean isValueInRange(String unitName, double value) {
		return isValueInRange(convertValueToBaseUnit(unitName, value));
	}
	public boolean isValueInRange(double value) {
		return range.isInRange(value);
	}
	
	public boolean isModifierValueInRange(String unitName, double value) {
		return isModifierValueInRange(convertModifierValueToBaseUnit(unitName, value));
	}
	public boolean isModifierValueInRange(double value) {
		return modifierRange.isInRange(value);
	}

	public String printValueRange() {
		return range.print();
	}
	public String printModifierValueRange() {
		return modifierRange.print();
	}

	public boolean isValidIdentifier(String identifier) {
		return validIdentifiers.contains(identifier);
	}

	public ArrayList<String> getValidIdentifiers() {
		return validIdentifiers;
	}
}
