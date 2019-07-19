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


public class ValueRange {
	double min;
	double max;
	boolean leftInfinity;
	boolean rightInfinity;
	boolean leftInclusive;
	boolean rightInclusive;
	
	static class InfinityValue {
		boolean isInfinity = true;
	}
	
	public static InfinityValue INF       = new InfinityValue();
	public static InfinityValue INFINITY  = new InfinityValue();
	public static InfinityValue MINUS_INF = new InfinityValue();
	
	public ValueRange(double min, double max) {
		this(min, max, true, true);
	}
	
	public ValueRange(InfinityValue min, double max) {
		this(min, max, true);
	}
	
	public ValueRange(double min, InfinityValue max) {
		this(min, max, true);
	}
	
	public ValueRange(double min, double max, boolean leftInclusive, boolean rightInclusive) {
		this.min = min;
		this.max = max;
		this.leftInclusive = leftInclusive;
		this.rightInclusive = rightInclusive;
		this.leftInfinity = false;
		this.rightInfinity = false;
	}
	
	public ValueRange(InfinityValue min, double max, boolean rightInclusive) {
		this.min = 0.0;
		this.max = max;
		this.leftInclusive = false;
		this.rightInclusive = rightInclusive;
		this.leftInfinity = true;
		this.rightInfinity = false;
	}
	
	public ValueRange(double min, InfinityValue max, boolean leftInclusive) {
		this.min = min;
		this.max = 0.0;
		this.leftInclusive = leftInclusive;
		this.rightInclusive = false;
		this.leftInfinity = false;
		this.rightInfinity = true;
	}
	
	public ValueRange(InfinityValue min, InfinityValue max) {
		this.min = 0.0;
		this.max = 0.0;
		this.leftInclusive = false;
		this.rightInclusive = false;
		this.leftInfinity = true;
		this.rightInfinity = true;
	}
	
	
	public boolean isInRange(double x) {
		if(!leftInfinity && ((leftInclusive && x<min) || (!leftInclusive && x<=min))) {
			return false;
		}
		if(!rightInfinity && ((rightInclusive && x>max) || (!rightInclusive && x>=max))) {
			return false;
		}
		return true;
	}
	
	public String print() {
		String result = "";
		result += (leftInclusive ? "[" : "(");
		result += (leftInfinity ? "-inf" : FormattingHelper.formatDouble(min));
		result += ", ";
		result += (rightInfinity ? "inf" : FormattingHelper.formatDouble(max));
		result += (rightInclusive ? "]" : ")");
		return result;
	}
}
