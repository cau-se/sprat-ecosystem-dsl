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

package org.sprat.ecosystem.ui.contentassist

import com.google.inject.Inject
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.Assignment
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.PropertyAttributeValue
import org.sprat.ecosystem.ecosystem.RangeExpressionNode
import org.sprat.ecosystem.ecosystem.RecordAttribute
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.helper.ModelHelper
import org.sprat.ecosystem.helper.SpratExprContext
import org.sprat.ecosystem.helper.ValidationHelper

import static extension org.eclipse.xtext.EcoreUtil2.*

/**
 * see http://www.eclipse.org/Xtext/documentation.html#contentAssist on how to customize content assistant
 */
class EcosystemProposalProvider extends AbstractEcosystemProposalProvider {
	
	@Inject extension ModelHelper  
	@Inject extension ContentAssistHelper
	@Inject extension ValidationHelper
	  
	override completeEcosystemModel_Entities(EObject object, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val model = object.rootNode
		
		for(t : #[EntityType.ECOSYSTEM, EntityType.OUTPUT, EntityType.INPUT]) {
			if(model.nEntitiesOfType(t) == 0) {
				acceptor.accept(t.createEmptyEntityTemplateProposal(context))
				acceptor.accept(t.createFullEntityTemplateProposal(context))
			}
		}
		
		acceptor.accept(EntityType.SPECIES.createEmptyEntityTemplateProposal(context))
		acceptor.accept(EntityType.SPECIES.createFullEntityTemplateProposal(context))
	}
	override completeEntity_Type(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
	}
	override complete_EcosystemModel(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
	}
	
	
	override complete_INT(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model.inferExprContext != SpratExprContext.UNDEFINED) {
			super.complete_INT(model, ruleCall, context, acceptor)
		}
	}
	override complete_Expression(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model instanceof PropertyAttribute) {
			val entity = model.eContainer as Entity
			if(entity.type == EntityType.INPUT && 'Mesh'.equals(model.name)) {
				acceptor.accept(createRectangular2D1DProposalProposal(context))
			} else if(entity.type == EntityType.ECOSYSTEM && 'TimeStep'.equals(model.name)) {
				acceptor.accept(createCompletionProposal("auto", "auto", loadImage("attribute.gif"), context))
			}
		}
//		complete_MathFunction(model, ruleCall, context, acceptor)
//		complete_Identifier(model, ruleCall, context, acceptor)
//		complete_RecordFunction(model, ruleCall, context, acceptor)
	}
	
	override completeEntity_Attributes(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model instanceof Entity) {
			for(a : model.listMissingAttributes) {
				acceptor.accept(a.createAttributeTemplateProposal(context))
			}
			
			if(model.type == EntityType.OUTPUT) {
				acceptor.accept(createRecordTemplateProposal(context))
			}
		}
	}
	
	override completeEntity_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model instanceof Entity) {
			if(model.type == EntityType.SPECIES) {
				acceptor.accept(createSpeciesNameProposal(context))
			}
		}
	}
	
	override completeRecordAttribute_Description(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		acceptor.accept(createStringProposal(context))
	}
	override completeStringLiteral_Value(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val uc = model.inferAttributeUnitCollection
		if(uc == EcosystemDescription.STRING) {
			acceptor.accept(createStringProposal(context))
		}
	}
	
	override completeRecordAttribute_RecModifier(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		for(f : EcosystemDescription.RECORD_MODIFIERS.functions) {
			acceptor.accept(f.createRecordModifierFunctionProposal(context))
		}
	}
	
	override complete_MathFunction(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model.inferExprContext == SpratExprContext.UNDEFINED) {
			return
		}
		for(f : EcosystemDescription.MATH_FUNCTIONS.functions) {
			acceptor.accept(f.name.createMathFunctionProposal(context))
		}
	}
	
	override complete_Identifier(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val exprCtx = model.inferExprContext
		if(exprCtx == SpratExprContext.VARIABLE_MATH) {
			for(v : EcosystemDescription.MATH_VARIABLES) {
				acceptor.accept(v.createMathVariableProposal(context))
			}
		} else if(exprCtx == SpratExprContext.UNDEFINED) {
			val farg = model.getContainerOfType(RecordFunctionArgument)
			if(farg != null && 'species'.equals(farg.name)) {
				model.createAndAcceptSpeciesNamesProposal(context, acceptor)
				return
			}
		}
		
		val uc = model.inferAttributeUnitCollection
		if(uc == EcosystemDescription.IDENTIFIER) {
			val attr = model.getContainerOfType(PropertyAttribute)
			val entity = attr.eContainer as Entity
			val ac = EcosystemDescription.getAttributeCollection(entity)
			if(ac.contains(attr.name)) {
				val sa = ac.getAttribute(attr.name)
				for(id : sa.validIdentifiers) {
					acceptor.accept(id.createIdProposal(context))
				}
			}
		}
	}
	
	override complete_RecordFunction(EObject model, RuleCall ruleCall, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		if(model.inferExprContext != SpratExprContext.RECORD_EXPR) {
			return
		}
		for(f : EcosystemDescription.RECORD_FUNCTIONS.functions) {
			acceptor.accept(f.createRecordFunctionProposal(context))
		}
	}
	
	override completeUnitExpression_Unit(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val container = model.eContainer
		if(model instanceof PropertyAttributeValue || container instanceof PropertyAttributeValue) {
			val uc = model.inferAttributeUnitCollection
			if(uc != null && EcosystemDescription.isRealUnitCategory(uc)) {
				for(u : uc.units) {
					acceptor.accept(u.name.createUnitProposal(uc.name, context))
				}
			}
		} else if(model instanceof RangeExpressionNode || container instanceof RangeExpressionNode) {
			val uc = model.inferRangeExpressionUnitCollection
			if(uc != null && EcosystemDescription.isRealUnitCategory(uc)) {
				for(u : uc.units) {
					acceptor.accept(u.name.createUnitProposal(uc.name, context))
				}
			}
		}
	}
	
	override completeRecordFunctionArgument_Name(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val rf = model.getContainerOfType(RecordFunction)
		if(rf == null) {
			return
		}
		
		if(EcosystemDescription.RECORD_FUNCTIONS.contains(rf.name)) {
			val sf = EcosystemDescription.RECORD_FUNCTIONS.getFunction(rf.name)
//			if(model instanceof RecordFunction) {
//				if(model.arguments.length < sf.arguments.length) {
//					var int whichOne = model.arguments.length-1
//					if(whichOne < 0) {
//						whichOne = 0
//					}
//					acceptor.accept(
//						sf.arguments.get(whichOne).createRecordFunctionArgumentProposal(context)
//					)
//					return
//				}
//			}
			for(a : sf.arguments) {
				acceptor.accept(a.createRecordFunctionArgumentProposal(context))
			}
		}
		
	}
	
	
	override completeEntity_ClosingBrace(EObject model, Assignment assignment, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
	}
	override completeKeyword(Keyword keyword, ContentAssistContext contentAssistContext, ICompletionProposalAcceptor acceptor) {
		//System.out.println(keyword.value)
		if("@".equals(keyword.value)) {
			val obj = contentAssistContext.currentModel
			if(obj.getContainerOfType(PropertyAttribute) != null) {
				val attr = obj.getContainerOfType(PropertyAttribute)
				val entity = attr.eContainer as Entity
				val coll = EcosystemDescription.getAttributeCollection(entity)
				if(coll.contains(attr.name)) {
					val sa = coll.getAttribute(attr.name)
					if(sa.hasModifier) {
						acceptor.accept(createCompletionProposal(keyword.value, keyword.value, null, contentAssistContext))
					}
				}
			} else if(obj.getContainerOfType(RecordAttribute) != null) {
				acceptor.accept(createCompletionProposal(keyword.value, keyword.value, null, contentAssistContext))
			}
			//System.out.println(obj.toString)
		} else if (":".equals(keyword.value)
			|| "{".equals(keyword.value)
			|| "}".equals(keyword.value)
		) {
			acceptor.accept(createCompletionProposal(keyword.value, keyword.value, null, contentAssistContext))
		}
		
		//super.completeKeyword(keyword, contentAssistContext, acceptor)
	}
}
