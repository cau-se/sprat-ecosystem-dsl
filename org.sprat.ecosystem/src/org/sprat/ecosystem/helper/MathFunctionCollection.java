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

public class MathFunctionCollection {
	final String name;
	final ArrayList<SpratMathFunction> functions = new ArrayList<>();
	
	public MathFunctionCollection() {
		this("");
	}
	
	public MathFunctionCollection(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}

	public ArrayList<SpratMathFunction> getFunctions() {
		return functions;
	}
	
	public void add(SpratMathFunction function) {
		if(function != null) {
			functions.add(function);
		}
	}
	
	public boolean contains(String functionName) {
		for(SpratMathFunction f : functions) {
			if(f.getName().equals(functionName)) {
				return true;
			}
		}
		return false;
	}
	
	public SpratMathFunction getFunction(String functionName) {
		for(SpratMathFunction f : functions) {
			if(f.getName().equals(functionName)) {
				return f;
			}
		}
		return new SpratMathFunction("null", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return 0.0;
			}
		});
	}
	
	public double evalFunction(String functionName, double x) {
		return getFunction(functionName).eval(x);
	}
}
