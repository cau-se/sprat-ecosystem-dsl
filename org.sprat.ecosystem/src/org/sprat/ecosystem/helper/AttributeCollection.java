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

public class AttributeCollection {
	final ArrayList<SpratAttribute> attributes = new ArrayList<>();
	
	public AttributeCollection() {}
	
	
	public ArrayList<SpratAttribute> getAttributes() {
		return attributes;
	}

	public void add(SpratAttribute attribute) {
		if(attribute != null) {
			attributes.add(attribute);
		}
	}
	
	public boolean contains(String attributeName) {
		for(SpratAttribute a : attributes) {
			if(a.getName().equals(attributeName)) {
				return true;
			}
		}
		return false;
	}
	
	public SpratAttribute getAttribute(String attributeName) {
		for(SpratAttribute a : attributes) {
			if(a.getName().equals(attributeName)) {
				return a;
			}
		}
		return null;
	}
}
