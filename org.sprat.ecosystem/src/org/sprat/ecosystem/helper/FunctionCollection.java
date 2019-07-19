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

public class FunctionCollection {
	final String name;
	final ArrayList<SpratFunction> functions = new ArrayList<>();
	
	public FunctionCollection() {
		this("");
	}
	
	public FunctionCollection(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}

	public ArrayList<SpratFunction> getFunctions() {
		return functions;
	}
	
	public void add(SpratFunction function) {
		if(function != null) {
			functions.add(function);
		}
	}
	
	public boolean contains(String functionName) {
		for(SpratFunction f : functions) {
			if(f.getName().equals(functionName)) {
				return true;
			}
		}
		return false;
	}
	
	public SpratFunction getFunction(String functionName) {
		for(SpratFunction f : functions) {
			if(f.getName().equals(functionName)) {
				return f;
			}
		}
		return null;
	}
}
