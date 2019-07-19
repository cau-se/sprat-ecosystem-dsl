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

public class SpratMathFunction {
	
	public interface SpratMathFunctionObject {
		public double eval(double x);
	}
	
	final String name;
	final SpratMathFunctionObject function; 
	
	public SpratMathFunction(String name, SpratMathFunctionObject function) {
		this.name = name;
		this.function = function;
	}
	
	public String getName() {
		return name;
	}

	public double eval(double x) {
		return function.eval(x);
	}
}
