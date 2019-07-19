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
import org.eclipse.jface.text.templates.DocumentTemplateContext
import org.eclipse.jface.text.templates.Template
import org.eclipse.jface.text.templates.TemplateContextType
import org.eclipse.jface.text.templates.TemplateProposal
import org.eclipse.jface.viewers.StyledString
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtext.ui.editor.contentassist.ConfigurableCompletionProposal
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.PropertyAttributeValue
import org.sprat.ecosystem.ecosystem.RecordAttribute
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.ecosystem.RecordModifierFunction
import org.sprat.ecosystem.helper.ModelHelper
import org.sprat.ecosystem.helper.SpratAttribute
import org.sprat.ecosystem.helper.SpratExprContext
import org.sprat.ecosystem.helper.SpratFunction
import org.sprat.ecosystem.helper.SpratFunctionArgument
import org.sprat.ecosystem.helper.UnitCollection

class ContentAssistHelper {
	
	public static val String FQN_ENTITY = "org.sprat.ecosystem.Ecosystem.Entity"
	public static val String FQN_PROPERTY_ATTRIBUTE = "org.sprat.ecosystem.Ecosystem.PropertyAttribute"
	public static val String FQN_RECORD_ATTRIBUTE = "org.sprat.ecosystem.Ecosystem.RecordAttribute"
	public static val String FQN_EXPRESSION = "org.sprat.ecosystem.Ecosystem.Expression"
	
	protected static val int RELEVANCE_DEFAULT =             1
	protected static val int RELEVANCE_SPECIAL =           100
	
	protected static val int RELEVANCE_PROPERTY_ATTRIBUTE =  5
	protected static val int RELEVANCE_RECORD_SKELETON =     6
	protected static val int RELEVANCE_SPECIES_NAME =       40
	protected static val int RELEVANCE_RECORD_MODIFIER =    32
	protected static val int RELEVANCE_RECORD_ARGUMENT =    31
	protected static val int RELEVANCE_RECORD_FUNCTION =    30
	protected static val int RELEVANCE_UNIT =               11
	protected static val int RELEVANCE_MATH_FUNCTION =      10
	protected static val int RELEVANCE_VARIABLE =           20
	
	@Inject extension ModelHelper
	
	def Image loadImage(String iconFile) {
		if(iconFile != null) {
			return AbstractUIPlugin.imageDescriptorFromPlugin("org.sprat.ecosystem.ui", "/icons/"+iconFile).createImage();
		}
		return null
	}
	
	def ConfigurableCompletionProposal createConfigurableProposal(
		String proposal,
		int offset,
		int length,
		int caret,
		String name,
		String description,
		String icon,
		int relevance,
		ContentAssistContext context
	) {
		val int replacementOffset = context.getReplaceRegion().getOffset()
		val int replacementLength = context.getReplaceRegion().getLength()
		var ConfigurableCompletionProposal result = new ConfigurableCompletionProposal(
			proposal,
			replacementOffset,
			replacementLength,
			proposal.length(),
			loadImage(icon),
			new StyledString(description), null, null)
		result.setPriority(relevance)
		result.setMatcher(context.getMatcher())
		result.setReplaceContextLength(context.getReplaceContextLength())
		
		if(caret >= 0) {
			result.setCursorPosition(caret)
		}
		if(length > 0 && offset > 0) {
			result.setSelectionStart(result.replacementOffset + offset)
			result.setSelectionLength(length)
			result.setSimpleLinkedMode(context.viewer, '\t')
		}
		return result
	}
	
	def ConfigurableCompletionProposal createConfigurableProposal(
		String proposal,
		String marker,
		int caret,
		String name,
		String description,
		String icon,
		int relevance,
		ContentAssistContext context
	) {
		return createConfigurableProposal(
			proposal,
			proposal.indexOf(marker),
			marker.length,
			caret,
			name,
			description,
			icon,
			relevance,
			context
		)
	}
	
	
	def TemplateProposal createTemplateProposal(
		String template,
		String name,
		String description,
		String contextTypeId,
		String icon,
		int relevance,
		ContentAssistContext context
	) {
		new TemplateProposal(
			new Template(name, description, contextTypeId, template, true),
			new DocumentTemplateContext(
				new TemplateContextType(contextTypeId, name),
				context.document,
				context.offset,
				context.replaceContextLength
			),
			context.replaceRegion,
			loadImage(icon),
			relevance
		)
	}
	
	
	def String formatAttribute(SpratAttribute a) {
		var result = a.name+": "
		if(EcosystemDescription.isRealUnitCategory(a.unitCategory)) {
			result = result+"${"+a.name.toFirstLower+"Value}"
			if(a.unitCategory != EcosystemDescription.DIMENSIONLESS) {
				result = result+" ["+a.unitCategory.baseUnit+"]"
			}
		} else if(a.unitCategory == EcosystemDescription.STRING) {
			result = result+"\"${"+a.name.toFirstLower+"}\""
		} else {
			result = result+"${"+a.name.toFirstLower+"ID}"
		} 
		
		if(a.hasModifier) {
			result = result+" @ "
			if(EcosystemDescription.isRealUnitCategory(a.modifierUnitCategory)) {
				result = result+"${"+a.name.toFirstLower+"Modifier}"
				if(a.modifierUnitCategory != EcosystemDescription.DIMENSIONLESS) {
					result = result+" ["+a.modifierUnitCategory.baseUnit+"]"
				}
			} else if(a.modifierUnitCategory == EcosystemDescription.STRING) {
				result = result+"\"${"+a.name.toFirstLower+"Modifier}\""
			} else {
				result = result+"${"+a.name.toFirstLower+"ModifierID}"
			}
		}
		return result
	}
	def TemplateProposal createAttributeTemplateProposal(SpratAttribute a, ContentAssistContext context) {
		(a.formatAttribute + "\n\t${cursor}\n").createTemplateProposal(
			a.name,
			"Attribute '"+a.name+"'",
			FQN_PROPERTY_ATTRIBUTE,
			"attribute.gif",
			RELEVANCE_PROPERTY_ATTRIBUTE,
			context
		)
	}
	
	def ConfigurableCompletionProposal createStringProposal(ContentAssistContext context) {
		val proposal = '"string"'
		return createConfigurableProposal(
			proposal,
			"string",
			proposal.length,
			"String",
			"String",
			null,
			RELEVANCE_SPECIAL,
			context
		)
	}
	
	def ConfigurableCompletionProposal createSpeciesNameProposal(ContentAssistContext context) {
		val proposal = "name"
		return createConfigurableProposal(
			proposal,
			0,
			proposal.length,
			proposal.length,
			"name - Species Name",
			"name - Species Name",
			"species.gif",
			RELEVANCE_DEFAULT,
			context
		)
	}
	
	def String emptyEntitySkeletonProposal(EntityType t) '''
		«t.entityTypePrintName» «IF t == EntityType.SPECIES »name «ENDIF»{
			
		}
		
	'''
	def ConfigurableCompletionProposal createEmptyEntityTemplateProposal(EntityType t, ContentAssistContext context) {
		val name = t.entityTypePrintName
		val proposal = t.emptyEntitySkeletonProposal
		return createConfigurableProposal(
			proposal,
			"name",
			proposal.indexOf('\t')+1,
			name+" - Entity of type '"+name+"'",
			name+" - Entity of type '"+name+"'",
			name.toFirstLower+".gif",
			RELEVANCE_DEFAULT,
			context
		)
	}
	
	def String fullEntitySkeletonProposal(EntityType t) '''
		«t.entityTypePrintName» «IF t == EntityType.SPECIES »${name} «ENDIF»{
			«FOR a : EcosystemDescription.getAttributeCollection(t).attributes»
				«a.formatAttribute»
			«ENDFOR»
		}
		
	'''
	def TemplateProposal createFullEntityTemplateProposal(EntityType t, ContentAssistContext context) {
		val name = t.entityTypePrintName
		t.fullEntitySkeletonProposal.createTemplateProposal(
				name,
				"Fully populated skeleton for entity of type '"+name+"'",
				FQN_ENTITY,
				name.toFirstLower+".gif",
				RELEVANCE_DEFAULT,
				context
			)
	}
	
	def String recordSkeletonProposal() '''
		record "${description}" @${frequency} :
				${expression}
		
	'''
	def TemplateProposal createRecordTemplateProposal(ContentAssistContext context) {
		recordSkeletonProposal.createTemplateProposal(
				"record",
				"Record expression",
				FQN_ENTITY,
				"record.gif",
				RELEVANCE_RECORD_SKELETON,
				context
			)
	}
	
	def String recordModifierFunctionProposal(SpratFunction f) '''
		«f.name»«IF f.arguments.length>0»(value [«f.arguments.head.units.baseUnit»])«ENDIF»'''
	def ConfigurableCompletionProposal createRecordModifierFunctionProposal(SpratFunction f, ContentAssistContext context) {
		val proposal = f.recordModifierFunctionProposal
		return createConfigurableProposal(
			proposal,
			"value",
			proposal.length,
			f.name+" - Record frequency",
			f.name+" - Record frequency",
			"record.gif",
			RELEVANCE_RECORD_MODIFIER,
			context
		)
	}
	def String mathFunctionProposal(String fname) '''
		«fname»(value)'''
	def ConfigurableCompletionProposal createMathFunctionProposal(String fname, ContentAssistContext context) {
		val proposal = fname.mathFunctionProposal
		return createConfigurableProposal(
			proposal,
			"value",
			proposal.length,
			fname+" - Math function",
			fname+" - Math function",
			"math_function.gif",
			RELEVANCE_MATH_FUNCTION,
			context
		)
	}
	def ConfigurableCompletionProposal createMathVariableProposal(String vname, ContentAssistContext context) {
		return createConfigurableProposal(
			vname,
			-1,
			0,
			vname.length,
			vname+" - Variable",
			vname+" - Variable",
			"variable.gif",
			RELEVANCE_VARIABLE,
			context
		)
	}
	
	def String recordFunctionArgumentValueProposal(SpratFunctionArgument a) {
		if(a.units == EcosystemDescription.IDENTIFIER) {
			return "${"+a.name+"}"
		} else {
			if(a.range) {
				return "${"+a.name+"From} ["+a.units.baseUnit+"] ~ ${"+a.name+"To} ["+a.units.baseUnit+"]"
			} else {
				return "${"+a.name+"} ["+a.units.baseUnit+"]"
			}
		}
	}
	def String recordFunctionArgumentProposal(SpratFunctionArgument a) '''
		«a.name» = «a.recordFunctionArgumentValueProposal»'''
	def String recordFunctionProposal(SpratFunction f) '''
		«f.name»(«FOR a : f.arguments SEPARATOR ', '»«a.recordFunctionArgumentProposal»«ENDFOR»)'''
	def TemplateProposal createRecordFunctionProposal(SpratFunction f, ContentAssistContext context) {
		f.recordFunctionProposal.createTemplateProposal(
			f.name,
			"Record function",
			FQN_EXPRESSION,
			"record.gif",
			RELEVANCE_RECORD_FUNCTION,
			context
		)
	}
	def TemplateProposal createRecordFunctionArgumentProposal(SpratFunctionArgument argument, ContentAssistContext context) {
		argument.recordFunctionArgumentProposal.createTemplateProposal(
			argument.name,
			"Record function argument",
			FQN_EXPRESSION,
			"record.gif",
			RELEVANCE_RECORD_ARGUMENT,
			context
		)
	}
	
	
	def void createAndAcceptSpeciesNamesProposal(EObject object, ContentAssistContext context, ICompletionProposalAcceptor acceptor) {
		val model = object.rootNode
		for(sp : model.species) {
			acceptor.accept(createConfigurableProposal(
				sp.name,
				-1,
				0,
				sp.name.length,
				sp.name + " - Species name",
				sp.name + " - Species name",
				"species.gif",
				RELEVANCE_SPECIES_NAME,
				context
			))
		}
	}
	
	def createUnitProposal(String unitName, String unitCollectionName, ContentAssistContext context) {
		val String proposal = "["+unitName+"]"
		return createConfigurableProposal(
			proposal,
			-1,
			0,
			proposal.length,
			proposal + " - "+unitCollectionName+" unit",
			proposal + " - "+unitCollectionName+" unit",
			"unit.gif",
			RELEVANCE_UNIT,
			context
		)
	}
	
	def createIdProposal(String id, ContentAssistContext context) {
		return createConfigurableProposal(
			id,
			-1,
			0,
			id.length,
			id,
			id,
			"attribute.gif",
			RELEVANCE_SPECIAL,
			context
		)
	}
	
	
	
	
	
	
	def String meshRectangular2D1DProposal() '''
		Rectangular2D1D(x = ${xFrom} ~ ${xTo}, n_x = ${xN}, y = ${yFrom} ~ ${yTo}, n_y = ${yN}, r = ${rFrom} ~ ${rTo}, n_r = ${rN})'''
	def TemplateProposal createRectangular2D1DProposalProposal(ContentAssistContext context) {
		meshRectangular2D1DProposal.createTemplateProposal(
				"Rectangular2D1D",
				"Mesh type",
				FQN_ENTITY,
				"attribute.gif",
				RELEVANCE_SPECIAL,
				context
			)
	}
	
	
	
	/*
	 * Infer context
	 */
	 
	 def UnitCollection inferAttributeUnitCollection(EObject object) {
	 	var EObject o = object
		var EObject oContained = object
		while(o != null) {
			if(o instanceof PropertyAttribute) {
				val attr = (o as PropertyAttribute)
				val entity = (attr.eContainer as Entity)
				val attrCollection = EcosystemDescription.getAttributeCollection(entity)
				if(attrCollection.contains(attr.name)) {
					val sa = attrCollection.getAttribute(attr.name)
					if(oContained instanceof PropertyAttributeValue) {
						val attrVal = (oContained as PropertyAttributeValue)
						if(attr.attribute == attrVal) {
							return sa.unitCategory
						}
						return sa.modifierUnitCategory
					}
					if(!sa.hasModifier) {
						return sa.unitCategory
					}
					if(sa.unitCategory == EcosystemDescription.IDENTIFIER || 
						sa.modifierUnitCategory == EcosystemDescription.IDENTIFIER
					) {
						return EcosystemDescription.IDENTIFIER
					}
					if(sa.unitCategory == EcosystemDescription.STRING || 
						sa.modifierUnitCategory == EcosystemDescription.STRING
					) {
						return EcosystemDescription.STRING
					}
				}
				return null
			}
			oContained = o
			o = o.eContainer
		}
		return null
	 }
	 
	 def UnitCollection inferRangeExpressionUnitCollection(EObject object) {
	 	var EObject o = object
		var EObject oContained = object
		while(o != null) {
			if(o instanceof RecordFunction) {
				if(oContained instanceof RecordFunctionArgument) {
					val rf = (o as RecordFunction)
					val arg = (oContained as RecordFunctionArgument)
					if(EcosystemDescription.RECORD_FUNCTIONS.contains(rf.name)) {
						val sf = EcosystemDescription.RECORD_FUNCTIONS.getFunction(rf.name)
						val sac = sf.arguments.filter[ it.name.equals(arg.name) ]
						if(!sac.empty) {
							return sac.head.units
						}
					}
				}
				return null
			}
			oContained = o
			o = o.eContainer
		}
		return null
	 }
	 
	def SpratExprContext inferExprContext(EObject object) {
		var EObject o = object
		var EObject oContained = object
		while(o != null) {
			if(o instanceof RecordFunction) {
				if(EcosystemDescription.RECORD_FUNCTIONS.contains(o.name)) {
					val srf = EcosystemDescription.RECORD_FUNCTIONS.getFunction(o.name)
					val int narg = o.arguments.indexOf(oContained)
					if(narg<0 || narg>=srf.arguments.length) {
						return SpratExprContext.UNDEFINED
					}
					if(EcosystemDescription.isRealUnitCategory(srf.arguments.get(narg).units)) {
						return SpratExprContext.RECORD_FUNCTION_ARGUMENT
					}
					return SpratExprContext.UNDEFINED
				}
				return SpratExprContext.UNDEFINED
			}
			if(o instanceof RecordModifierFunction) {
				return SpratExprContext.CONST_MATH
			}
			if(o instanceof RecordAttribute) {
				return SpratExprContext.RECORD_EXPR
			}
			if(o instanceof PropertyAttribute) {
				val entity = (o.eContainer as Entity)
				val coll = EcosystemDescription.getAttributeCollection(entity)
				if(coll.contains(o.name)) {
					val sa = coll.getAttribute(o.name)
					var UnitCollection uc = null
					if(o.attribute == oContained) {
						uc = sa.unitCategory
					} else if(o.modifier == oContained) {
						uc = sa.modifierUnitCategory
					}
					if(uc == null) {
						if(sa.unitCategory == EcosystemDescription.VARIABLE_EXPRESSION
							|| sa.modifierUnitCategory == EcosystemDescription.VARIABLE_EXPRESSION) {
							return SpratExprContext.VARIABLE_MATH
						} else if(EcosystemDescription.isRealUnitCategory(sa.unitCategory)
							|| EcosystemDescription.isRealUnitCategory(sa.modifierUnitCategory)) {
							return SpratExprContext.CONST_MATH
						}
						return SpratExprContext.UNDEFINED
					}
					if(EcosystemDescription.isRealUnitCategory(uc)) {
						return SpratExprContext.CONST_MATH
					}
					if(uc == EcosystemDescription.VARIABLE_EXPRESSION) {
						return SpratExprContext.VARIABLE_MATH
					}
					return SpratExprContext.UNDEFINED
				}
				return SpratExprContext.UNDEFINED
			}
			oContained = o
			o = o.eContainer
		}
		return SpratExprContext.UNDEFINED
	}
	
	
	
	
	
	
	
}