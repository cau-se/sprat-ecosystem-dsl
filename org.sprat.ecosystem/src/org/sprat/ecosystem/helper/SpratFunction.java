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


public class SpratFunction {
	final String name;
	final SpratDimensionality dim;
	final ArrayList<SpratFunctionArgument> arguments = new ArrayList<>();
	
	public SpratFunction() {
		this("");
	}
	
	public SpratFunction(String name) {
		this(name, SpratDimensionality.ZERO);
	}
	
	public SpratFunction(String name, SpratDimensionality dim) {
		this.name = name;
		this.dim = dim;
	}
	
	public SpratFunction(String name, SpratFunctionArgument... args) {
		this(name, SpratDimensionality.ZERO, args);
	}
	
	public SpratFunction(String name, SpratDimensionality dim, SpratFunctionArgument... args) {
		this.name = name;
		this.dim = dim;
		for(SpratFunctionArgument a : args) {
			addArgument(a);
		}
	}
	
	public String getName() {
		return name;
	}
	
	public SpratDimensionality getDimensionality() {
		return dim;
	}

	public ArrayList<SpratFunctionArgument> getArguments() {
		return arguments;
	}
	
	public boolean hasArgument(String argumentName) {
		for(SpratFunctionArgument a : arguments) {
			if(a.getName().equals(argumentName)) {
				return true;
			}
		}
		return false;
	}

	public void addArgument(SpratFunctionArgument argument) {
		if(argument != null) {
			arguments.add(argument);
		}
	}
	
	public int nArguments() {
		return arguments.size();
	}
}
