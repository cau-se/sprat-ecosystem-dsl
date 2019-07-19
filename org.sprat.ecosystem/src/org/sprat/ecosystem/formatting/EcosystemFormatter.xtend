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
 
package org.sprat.ecosystem.formatting

import com.google.inject.Inject
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import org.sprat.ecosystem.services.EcosystemGrammarAccess

// import com.google.inject.Inject;
// import org.sprat.ecosystem.services.EcosystemGrammarAccess

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
class EcosystemFormatter extends AbstractDeclarativeFormatter {

	@Inject extension EcosystemGrammarAccess g
	
	override protected void configureFormatting(FormattingConfig c) {
		c.setAutoLinewrap(180)
		
		
		val e = g.getEntityAccess()
		// indentation between { }
		c.setIndentation(e.getLeftCurlyBracketKeyword_2(),
			e.getClosingBraceRightCurlyBracketKeyword_4_0()
		)
		// newline after {
		c.setLinewrap().after(e.getLeftCurlyBracketKeyword_2())
		// two newlines after }
		c.setLinewrap(2).after(g.entityRule)
		
		
		
		// newlines around Attributes
		c.setLinewrap().after(g.attributeRule)
		c.setLinewrap(2).before(g.recordAttributeRule)
		
		// format Attributes
		val ra = g.getRecordAttributeAccess()
		val pa = g.getPropertyAttributeAccess()
		
		c.setNoSpace.around(ra.recModifierAssignment_3)
		c.setNoSpace.after(pa.nameAssignment_0)
		
		c.setLinewrap().after(ra.colonKeyword_4)
		c.setIndentationIncrement.after(ra.colonKeyword_4)
		c.setIndentationDecrement.after(ra.expressionAssignment_5)
		
		// format Expressions
		val aexpr = g.getAtomicExpressionAccess()
		c.setNoSpace.after(aexpr.leftParenthesisKeyword_0_0)
		c.setNoSpace.before(aexpr.rightParenthesisKeyword_0_2)
		
		val mfexpr = g.getMathFunctionAccess()
		c.setNoSpace.around(mfexpr.leftParenthesisKeyword_2)
		c.setNoSpace.before(mfexpr.closingParenthesisRightParenthesisKeyword_4_0)
		
		val rmfexpr = g.getRecordModifierFunctionAccess()
		c.setNoSpace.around(rmfexpr.leftParenthesisKeyword_1)
		c.setNoSpace.before(rmfexpr.closingParenthesisRightParenthesisKeyword_3_0)
		
		val rfexpr = g.getRecordFunctionAccess()
		c.setNoSpace.around(rfexpr.leftParenthesisKeyword_2)
		c.setNoSpace.before(rfexpr.closingParenthesisRightParenthesisKeyword_5_0)
		c.setNoSpace.before(rfexpr.commaKeyword_4_0)
		
		
		
		// format comments
		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
		c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)
	}
}
