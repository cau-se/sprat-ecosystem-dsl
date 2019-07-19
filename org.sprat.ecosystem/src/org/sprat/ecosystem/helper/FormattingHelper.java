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

import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.Locale;

public class FormattingHelper {
	
	private FormattingHelper() {}
	
	public static String parenthize(String expr) {
		return "(" + expr + ")";
	}
	public static String formatDouble(double x) {
		final String scientificFormat = "0.0##############E0";
		final String normalFormat     = "0.0##############";
		final boolean useNormalFormat = (Math.abs(x) < 1.0e3 && Math.abs(x) >= 1.0e-2) || Math.abs(x) == 0.0;
		DecimalFormat nf = new DecimalFormat(useNormalFormat ? normalFormat : scientificFormat, 
				new DecimalFormatSymbols(Locale.US));
		return nf.format(x);
	}
}
