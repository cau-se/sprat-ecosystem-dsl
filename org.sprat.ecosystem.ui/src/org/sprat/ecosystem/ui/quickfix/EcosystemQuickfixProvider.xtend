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

package org.sprat.ecosystem.ui.quickfix

import org.eclipse.xtext.ui.editor.quickfix.DefaultQuickfixProvider
import org.eclipse.xtext.ui.editor.quickfix.Fix
import org.eclipse.xtext.ui.editor.quickfix.IssueResolutionAcceptor
import org.eclipse.xtext.validation.Issue
import org.sprat.ecosystem.validation.EcosystemValidator


/**
 * Custom quickfixes.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#quickfixes
 */
class EcosystemQuickfixProvider extends DefaultQuickfixProvider {
	
	@Fix(EcosystemValidator::EXPRESSION_LACKS_DEFAULT_MODIFIER)
	def void addOptionalDefaultModifier(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(
			issue,
			"Add default modifier to attribute", // label
			"Add modifier '" + issue.data.get(0) + "' to expression.", // description
			"attribute.gif", // icon
			[ context |
				val xtextDocument = context.xtextDocument
				var content = xtextDocument.get
				var before = content.substring(0, issue.offset + issue.length)
				var after =  content.substring(issue.offset + issue.length, content.length)
				content = before + issue.data.get(0) + after
				xtextDocument.set(content)
			]
		);
	}
	
	@Fix(EcosystemValidator::EXPRESSION_LACKS_UNIT)
	def void addBaseUnitToExpression(Issue issue, IssueResolutionAcceptor acceptor) {
		acceptor.accept(
			issue,
			"Add base unit to expression", // label
			"Add base unit '" + issue.data.get(0) + "' to expression.", // description
			"attribute.gif", // icon
			[ context |
				val xtextDocument = context.xtextDocument
				var content = xtextDocument.get
				var before = content.substring(0, issue.offset + issue.length)
				var after =  content.substring(issue.offset + issue.length, content.length)
				content = before + " [" + issue.data.get(0) + "]" + after
				xtextDocument.set(content)
			]
		);
	}

//	@Fix(MyDslValidator::INVALID_NAME)
//	def capitalizeName(Issue issue, IssueResolutionAcceptor acceptor) {
//		acceptor.accept(issue, 'Capitalize name', 'Capitalize the name.', 'upcase.png') [
//			context |
//			val xtextDocument = context.xtextDocument
//			val firstLetter = xtextDocument.get(issue.offset, 1)
//			xtextDocument.replace(issue.offset, 1, firstLetter.toUpperCase)
//		]
//	}
}
