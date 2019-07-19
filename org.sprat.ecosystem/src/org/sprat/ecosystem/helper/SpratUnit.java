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


public class SpratUnit {
	final String name;
	final double conversionFactor;
	final double conversionOffset;
	
	public SpratUnit() {
		this("", 1.0, 0.0);
	}
	
	public SpratUnit(String name, double conversionFactor) {
		this(name, conversionFactor, 0.0);
	}
	
	public SpratUnit(String name, double conversionFactor, double conversionOffset) {
		this.name = name;
		this.conversionFactor = conversionFactor;
		this.conversionOffset = conversionOffset;
	}
	
	public String getName() {
		return name;
	}

	public double getConversionFactor() {
		return conversionFactor;
	}

	public double getConversionOffset() {
		return conversionOffset;
	}
	
	private boolean almostEqual(double a, double b) {
		return (Math.abs(a-b) < 1.0e-12);
	}
	
	public boolean isBaseUnit() {
		return (almostEqual(conversionFactor, 1.0) && almostEqual(conversionOffset, 0.0));
	}
	
	public double convertToBaseUnit(double value) {
		return conversionFactor * value + conversionOffset;
	}

	public String formatConversionToBaseUnit(String formattedString) {
		if(isBaseUnit()) {
			return FormattingHelper.parenthize(formattedString);
		}
		String result = FormattingHelper.formatDouble(conversionFactor) + " * " +
				FormattingHelper.parenthize(formattedString);
		if(!almostEqual(conversionOffset, 0.0)) {
			result += " + " + FormattingHelper.formatDouble(conversionOffset);
		}
		return FormattingHelper.parenthize(result);
	}
}
