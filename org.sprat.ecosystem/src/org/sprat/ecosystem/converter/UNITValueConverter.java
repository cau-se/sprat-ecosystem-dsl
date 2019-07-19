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

package org.sprat.ecosystem.converter;

import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.conversion.impl.AbstractLexerBasedConverter;
import org.eclipse.xtext.nodemodel.INode;
import org.eclipse.xtext.util.Strings;

public class UNITValueConverter extends AbstractLexerBasedConverter<String> {

	@Override
	protected String toEscapedString(String value) {
		return '"' + Strings.convertToJavaString(value, false) + '"';
	}
	
	@Override
	public String toValue(String string, INode node) {
		if (string == null)
			return null;
		
		try {
			return string.substring(1, string.length() - 1);
		} catch (IndexOutOfBoundsException e) {
			throw new ValueConverterException(e.getMessage(), node, e);
		}
	}

}
