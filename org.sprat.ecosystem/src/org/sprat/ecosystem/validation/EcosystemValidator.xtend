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

package org.sprat.ecosystem.validation

import com.google.inject.Inject
import org.eclipse.xtext.validation.Check
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.BinaryArithmeticExpressionNode
import org.sprat.ecosystem.ecosystem.BinaryBooleanExpressionNode
import org.sprat.ecosystem.ecosystem.EcosystemModel
import org.sprat.ecosystem.ecosystem.EcosystemPackage
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.Expression
import org.sprat.ecosystem.ecosystem.Identifier
import org.sprat.ecosystem.ecosystem.IntegerLiteral
import org.sprat.ecosystem.ecosystem.MathFunction
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.PropertyAttributeValue
import org.sprat.ecosystem.ecosystem.RangeExpressionNode
import org.sprat.ecosystem.ecosystem.RealLiteral
import org.sprat.ecosystem.ecosystem.RecordAttribute
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.ecosystem.RecordModifierFunction
import org.sprat.ecosystem.ecosystem.RecordModifierIdentifier
import org.sprat.ecosystem.ecosystem.StringLiteral
import org.sprat.ecosystem.ecosystem.TernaryConditionalExpressionNode
import org.sprat.ecosystem.ecosystem.UnaryArithmeticExpressionNode
import org.sprat.ecosystem.ecosystem.UnaryBooleanExpressionNode
import org.sprat.ecosystem.ecosystem.UnitExpressionNode
import org.sprat.ecosystem.helper.ExpressionHelper
import org.sprat.ecosystem.helper.FormattingHelper
import org.sprat.ecosystem.helper.ModelHelper
import org.sprat.ecosystem.helper.SpratExprContext
import org.sprat.ecosystem.helper.UnitCollection
import org.sprat.ecosystem.helper.ValidationHelper
import org.sprat.ecosystem.helper.ValueRange

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class EcosystemValidator extends AbstractEcosystemValidator {

	/*
	 * Errors:
	 */
	//public static val INVALID_ATTRIBUTE_NAME = 'invalidAttributeName'
	//public static val INVALID_ATTRIBUTE_UNIT = 'invalidAttributeUnit'
	//public static val INVALID_ATTRIBUTE_MODIFIER_UNIT = 'invalidAttributeModifierUnit'
	
	
	//public static val ONLY_OUTPUT_RECORD_KEYWORD = 'onlyOutputEntitiesCanContainRecords'
	//public static val MORE_THAN_ONE_ECOSYSTEM = 'moreThanOneEcosystem'
	//public static val MORE_THAN_ONE_INPUT = 'moreThanOneInput'
	//public static val MORE_THAN_ONE_OUTPUT = 'moreThanOneOutput'
	//public static val CANNOT_EVAL_CONST_MATH_EXPR = 'cannotEvalConstMathExpr'
	//public static val AT_LEAST_ONE_ = 'atLeastOne'
	
	/*
	 * Warnings:
	 */
	public static final val EXPRESSION_LACKS_UNIT = 'expressionLacksUnit'
	public static final val EXPRESSION_LACKS_DEFAULT_MODIFIER = 'expressionLacksDefaultModifier'
	
	@Inject extension ModelHelper
	@Inject extension ExpressionHelper
	@Inject extension ValidationHelper
	
	
	
	
	@Check
	def checkModelIsNotEmpty(EcosystemModel model) {
		if(model.entities.empty) {
			error("An empty model is invalid", model, null)
		}
	}
	
	
	@Check
	def checkAtLeatOneOfEachEntityType(EcosystemModel model) {
		if(model.entities.length > 0) {
			model.validateAtLeatOneOfEntityType(EntityType.ECOSYSTEM)
			model.validateAtLeatOneOfEntityType(EntityType.INPUT)
			model.validateAtLeatOneOfEntityType(EntityType.OUTPUT)
			model.validateAtLeatOneOfEntityType(EntityType.SPECIES)
		}
	}
	protected def validateAtLeatOneOfEntityType(EcosystemModel model, EntityType t) {
		if(model.nEntitiesOfType(t) == 0) {
			error("At least one '"+ t.getEntityTypePrintName +"' entity must be present", 
				model.entities.get(model.entities.length - 1),
				EcosystemPackage::eINSTANCE.entity_ClosingBrace
			)
		}
	}
	
	
	@Check
	def checkOnlyOneOfSingularEntities(EcosystemModel model) {
		model.validateOnlyOneOfSingularEntities(EntityType.ECOSYSTEM)
		model.validateOnlyOneOfSingularEntities(EntityType.INPUT)
		model.validateOnlyOneOfSingularEntities(EntityType.OUTPUT)
	}
	protected def validateOnlyOneOfSingularEntities(EcosystemModel model, EntityType t) {
		if(model.nEntitiesOfType(t) > 1) {
			model.entities.filter[ it.type == t ].forEach[
				error("Only one '"+ t.getName() +"' entity allowed", 
					it,
					EcosystemPackage::eINSTANCE.entity_Type
				)
			]
		}
	}


	@Check
	def checkSpeciesHasUniqueName(Entity entity) {
		if(entity.type != EntityType.SPECIES) {
			return
		}
		if(entity.name == null || entity.name.empty) {
			error("Species must have a name", entity, EcosystemPackage::eINSTANCE.entity_Type)
			return
		}
		if((entity.eContainer as EcosystemModel).getSpeciesNames.filter[ entity.name.equals(it) ].length > 1) {
			error("Species name must be unique", entity, EcosystemPackage::eINSTANCE.entity_Name) 
		}
	}
	
	
	@Check
	def checkForMissingAttributes(Entity entity) {
		entity.listMissingAttributes.forEach[
			error("Missing attribute '"+ it.name +"'", entity, EcosystemPackage::eINSTANCE.entity_ClosingBrace
			)
		]
	}
	
	
	@Check
	def checkForUnknownAttributes(PropertyAttribute attribute) {
		val entity = attribute.entity
		val isValid = EcosystemDescription.getAttributeCollection(entity).contains(attribute.name)
		
		if(!isValid) {
			error("Attribute "+ attribute.name +" is not defined for entity '" + entity.type.getName() + "'",
				attribute, 
				EcosystemPackage::eINSTANCE.propertyAttribute_Name
			)
		}
	}
	
	
	@Check
	def checkNonRealPropertyValuesForCorrectness(PropertyAttribute attribute) {
		val entity = attribute.entity
		val attributeCollection = EcosystemDescription.getAttributeCollection(entity)
		
		if(attributeCollection.contains(attribute.name)) {
			val spratAttribute = attributeCollection.getAttribute(attribute.name)
			
			if(spratAttribute.unitCategory.equals(EcosystemDescription.STRING)) {
				if(!(attribute.attribute?.value instanceof StringLiteral)) {
					error("Attribute value must be a string", attribute.attribute?:attribute, null)
				}
			} else if(spratAttribute.unitCategory.equals(EcosystemDescription.IDENTIFIER)) {
				if(!(attribute.attribute?.value instanceof Identifier)) {
					error("Attribute value must be one of the following identifiers: " + spratAttribute.validIdentifiers.join(", "), attribute.attribute?:attribute, null)
				} else if(!spratAttribute.isValidIdentifier((attribute.attribute.value as Identifier).name)) {
					error("Only the following identifiers are valid values: " + spratAttribute.validIdentifiers.join(", "), attribute.attribute, null)
				}
			} else if(spratAttribute.unitCategory.equals(EcosystemDescription.VARIABLE_EXPRESSION)) {
				if(!(attribute.attribute?.value instanceof Expression)) {
					error("Attribute value must be a variable expression", attribute.attribute?:attribute, null)
				} else {
					(attribute.attribute.value as Expression).validateExpr(SpratExprContext.VARIABLE_MATH)
				}
			}
			
			if(spratAttribute.hasModifier) {
				val boolean isPresent = (attribute.modifier!=null)
				val boolean isOptionalAndPresent = (spratAttribute.modifierIsOptional() && isPresent)
				val boolean isMandatory = !spratAttribute.modifierIsOptional()
				
				
				if(isOptionalAndPresent || isMandatory) {
					if(spratAttribute.modifierUnitCategory.equals(EcosystemDescription.STRING)) {
						if(!(attribute.modifier?.value instanceof StringLiteral)) {
							error("Attribute modifier must be a string", attribute.modifier?:attribute, null)
						}
					} else if(spratAttribute.modifierUnitCategory.equals(EcosystemDescription.IDENTIFIER)) {
						if(!(attribute.modifier?.value instanceof Identifier)) {
							error("Attribute modifier must be one of the following identifiers: " + spratAttribute.validIdentifiers.join(", "), attribute.modifier?:attribute, null)
						} else if(!spratAttribute.isValidIdentifier((attribute.modifier.value as Identifier).name)) {
							error("Only the following identifiers are valid modifiers: " + spratAttribute.validIdentifiers.join(", "), attribute.modifier, null)
						}
					} else if(spratAttribute.modifierUnitCategory.equals(EcosystemDescription.VARIABLE_EXPRESSION)) {
						if(!(attribute.modifier?.value instanceof Expression)) {
							error("Attribute modifier must be a variable expression", attribute.modifier?:attribute, null)
						} else {
							(attribute.modifier.value as Expression).validateExpr(SpratExprContext.VARIABLE_MATH)
						}
					}
				}
			} else if(attribute.modifier != null) {
				error("This attribute must not have a modifier", attribute.modifier, null)
			}
		}
	}
	
	
	@Check
	def checkRealPropertyValuesForCorrectValueAndUnit(PropertyAttribute attribute) {
		val entity = attribute.entity
		val attributeCollection = EcosystemDescription.getAttributeCollection(entity)
		
		if(attributeCollection.contains(attribute.name)) {
			val spratAttribute = attributeCollection.getAttribute(attribute.name)
			
			validateRealPropertyAttributeValueAndUnit(attribute.attribute, 
				spratAttribute.unitCategory, 
				spratAttribute.range
			)
			
			
			if(spratAttribute.modifierUnitCategory == null) {
				if(attribute.modifier != null) {
					error("This attribute must not have a modifier", attribute.modifier, null)
				}
			} else {
				if(attribute.modifier==null && 
					EcosystemDescription.isRealUnitCategory(spratAttribute.modifierUnitCategory)
				) {
					if(!spratAttribute.modifierIsOptional) {
						error("Real-valued modifier is missing", attribute, null)
					} else {
						warning("Optional real-valued modifier not specified - using default modifier", 
							attribute, 
							null,
							EXPRESSION_LACKS_DEFAULT_MODIFIER,
							" @ "+spratAttribute.defaultModifier+" ["+spratAttribute.modifierUnitCategory.baseUnit+"]"
						)
						
					}
				}
				validateRealPropertyAttributeValueAndUnit(attribute.modifier, 
					spratAttribute.modifierUnitCategory, 
					spratAttribute.modifierRange
				)
			}
		}
	}
	protected def void validateRealPropertyAttributeValueAndUnit(
		PropertyAttributeValue attributeValue,
		UnitCollection units,
		ValueRange range
	) {
		if(attributeValue?.value != null && EcosystemDescription.isRealUnitCategory(units)) {
			if(attributeValue.value instanceof Expression) {
				val expr = (attributeValue.value as Expression)
				expr.validateExpr(SpratExprContext.CONST_MATH)
				
				val valOfExpr = expr.eval
				if(!range.isInRange(valOfExpr)) { // liegt es in Range?
					error("Value of expression is "+FormattingHelper.formatDouble(valOfExpr)
						+" which is outside of "+ range.print, 
						expr,
						null
					)
				}
				
				expr.validateCorrectUnit(units)
			} else {
				// Es sollte ein Ausdruck sein, ist aber ein String --> Fehler
				error("Expected constant math expression", 
					attributeValue,
					null
				)
			}
		}
	}
	
	
	@Check
	def checkRecordAttributes(RecordAttribute attribute) {
		if(attribute.entity.type != EntityType.OUTPUT) {
			error("Only 'Output' entities can contain record attributes", 
				attribute,
				null
			)
			return
		}
		if(attribute.description == null || attribute.description.empty) {
			error("Missing description", attribute, null)
		}
		
		if(attribute.recModifier == null) {
			error("Missing record frequency", attribute, null)
		} else { // check modifier
			var String modifierName
			var int nArgs
			if(attribute.recModifier instanceof RecordModifierIdentifier) {
				modifierName = (attribute.recModifier as RecordModifierIdentifier).value
				nArgs = 0
			} else if(attribute.recModifier instanceof RecordModifierFunction) {
				modifierName = (attribute.recModifier as RecordModifierFunction).name
				nArgs = 1
				(attribute.recModifier as RecordModifierFunction).argument.validateExpr(SpratExprContext.CONST_MATH)
			}
			
			if(!EcosystemDescription.RECORD_MODIFIERS.contains(modifierName)) {
				error("Modifier must be one of: " + EcosystemDescription.RECORD_MODIFIERS.functions.map[it.name].join(", "), attribute.recModifier, null)
			} else {
				val modFunction = EcosystemDescription.RECORD_MODIFIERS.getFunction(modifierName)
				
				if(modFunction.nArguments != nArgs) {
					if(nArgs == 0) {
						error("Must be a function with exactly one argument", attribute.recModifier, null)
					} else {
						error("Must be an identifier", attribute.recModifier, null)
					}
				} else if(nArgs == 1) { // correct argument?
					(attribute.recModifier as RecordModifierFunction).argument.validateCorrectUnit(modFunction.arguments.head.units)
				}
			}
		}
		
		attribute.expression.validateExpr(SpratExprContext.RECORD_EXPR)
	}
	
	
	@Check
	def checkSpecialAttributes(PropertyAttribute attribute) {
		if(attribute.attribute == null) {
			error("Value missing", attribute, null)
			return
		}
		
		if('TimeStep'.equals(attribute.name)) {
			if(attribute.modifier != null) {
				error("Must not have a modifier", attribute.modifier, null)
			}
			
			if(attribute.attribute?.value instanceof Identifier) {
				if(!'auto'.equals((attribute.attribute.value as Identifier).name)) {
					error("Must be time expression or 'auto'", attribute.attribute, null)
				}
			} else if(attribute.attribute?.value instanceof Expression) {
				(attribute.attribute.value as Expression).validateCorrectUnit(EcosystemDescription.TIME)
				(attribute.attribute.value as Expression).validateExpr(SpratExprContext.CONST_MATH)
			} else {
				error("Must be time expression or 'auto'", attribute.attribute, null)
			}
		}
//		else if('InitialDistribution'.equals(attribute.name)) {
//			if(attribute.modifier == null) {
//				error("Modifier missing", attribute, null)
//			}
//			
//			if(attribute.attribute.value instanceof Identifier) {
//				if(!'function'.equals((attribute.attribute.value as Identifier).name)) {
//					error("Must be one of: 'function'", attribute.attribute, null)
//				} else { // modifier
//					if(attribute.modifier.value instanceof Expression) {
//						(attribute.modifier.value as Expression).validateExpr(SpratExprContext.VARIABLE_MATH)
//					} else {
//						error("Must be variable math expression", attribute.modifier, null)
//					}
//				}
//			} else {
//				error("Must be one of: 'function'", attribute.attribute, null)
//			}
//		}
		else if('Mesh'.equals(attribute.name)) {
			if(attribute.modifier != null) {
				error("Must not have a modifier", attribute.modifier, null)
			}
			
			if(attribute.attribute?.value instanceof RecordFunction) {
				val function = (attribute.attribute.value as RecordFunction)
				if(!('Rectangular2D1D'.equals(function.name))) {
					error("Must be one of the following functions: 'Rectangular2D1D'", function, null)
				} else {
					if(function.arguments.length != 6 || 
						!((function.arguments.get(0) as RecordFunctionArgument).argument instanceof RangeExpressionNode) || 
						!((function.arguments.get(2) as RecordFunctionArgument).argument instanceof RangeExpressionNode) || 
						!((function.arguments.get(4) as RecordFunctionArgument).argument instanceof RangeExpressionNode) || 
						!((function.arguments.get(1) as RecordFunctionArgument).argument instanceof IntegerLiteral) || 
						!((function.arguments.get(3) as RecordFunctionArgument).argument instanceof IntegerLiteral) || 
						!((function.arguments.get(5) as RecordFunctionArgument).argument instanceof IntegerLiteral) ||
						!('x'.equals((function.arguments.get(0) as RecordFunctionArgument).name)) ||
						!('n_x'.equals((function.arguments.get(1) as RecordFunctionArgument).name)) || 
						!('y'.equals((function.arguments.get(2) as RecordFunctionArgument).name)) || 
						!('n_y'.equals((function.arguments.get(3) as RecordFunctionArgument).name)) || 
						!('r'.equals((function.arguments.get(4) as RecordFunctionArgument).name)) || 
						!('n_r'.equals((function.arguments.get(5) as RecordFunctionArgument).name)) 
					) {
						error("Function signature is: Rectangular2D1D(x=..~.., n_x=.., y=..~.., n_y=.., r=..~.., n_r=..)", function, null)
					} else {
						((function.arguments.get(0) as RecordFunctionArgument).argument as Expression).validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
						((function.arguments.get(2) as RecordFunctionArgument).argument as Expression).validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
						((function.arguments.get(4) as RecordFunctionArgument).argument as Expression).validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
					}
				}
			} else {
				error("Must be one of the following functions: 'Rectangular2D1D'", attribute.attribute, null)
			}
		}
	}
	
	
	@Check
	def checkRangeExpression(RangeExpressionNode range) {
		if(range.from == null || range.to == null) {
			return
		}
		val a = range.from.eval
		val b = range.to.eval
		if(a >= b) {
			error("Interval must not be empty", range, null)
		}
	}
	
	
	
	/*
	 * Expression validation (no @Checks -- they are called from within the checks above)
	 */
	
	protected def void validateCorrectUnit(Expression expr, UnitCollection units, boolean isRange) {
		if(isRange) {
			if(expr instanceof RangeExpressionNode) {
				expr.from.validateCorrectUnit(units)
				expr.to.validateCorrectUnit(units)
			} else {
				error("Must be range expression ('~')", expr, null)
			}
		} else {
			expr.validateCorrectUnit(units)
		}
	}
	protected def void validateCorrectUnit(Expression expr, UnitCollection units) {
		if(expr instanceof UnitExpressionNode) {
			if(!units.contains((expr as UnitExpressionNode).unit)) {
				error("Unit must be from category '"+ units.name +"'", 
					expr as UnitExpressionNode,
					EcosystemPackage::eINSTANCE.unitExpressionNode_Unit
				)
			}
		} else if(expr != null) {
			if(units!=EcosystemDescription.DIMENSIONLESS) {
				warning("Expression should have unit from category '"+ units.name +"' - using default unit",
					expr,
					null,
					EXPRESSION_LACKS_UNIT,
					units.baseUnit
				)
			}
		}
	}
	
	// Contract for validateExpr(): context != UNDEFINED
	protected def dispatch void validateExpr(RangeExpressionNode expr, SpratExprContext context) {
		if(context != SpratExprContext.RECORD_FUNCTION_ARGUMENT) {
			error("Range expression not allowed here", expr, EcosystemPackage::eINSTANCE.rangeExpressionNode_Op)
		} else if(!expr.topLevel) {
			error("Nested range expression not allowed", expr, EcosystemPackage::eINSTANCE.rangeExpressionNode_Op)
		}
		expr.from.validateExpr(context)
		expr.to.validateExpr(context)
	}
	protected def dispatch void validateExpr(TernaryConditionalExpressionNode expr, SpratExprContext context) {
		if(context != SpratExprContext.VARIABLE_MATH) {
			error("Ternary conditional expression not allowed here", expr, EcosystemPackage::eINSTANCE.ternaryConditionalExpressionNode_Op)
		}
		expr.condition.validateExpr(context)
		expr.ifTrue.validateExpr(context)
		expr.ifFalse.validateExpr(context)
	}
	protected def dispatch void validateExpr(BinaryBooleanExpressionNode expr, SpratExprContext context) {
		if(context != SpratExprContext.VARIABLE_MATH) {
			error("Boolean operation not allowed here", expr, EcosystemPackage::eINSTANCE.binaryBooleanExpressionNode_Op)
		}
		expr.left.validateExpr(context)
		expr.right.validateExpr(context)
	}
	protected def dispatch void validateExpr(UnitExpressionNode expr, SpratExprContext context) {
		if(   context != SpratExprContext.CONST_MATH 
		   && context != SpratExprContext.RECORD_FUNCTION_ARGUMENT
		) {
			error("Unit not allowed here", expr, EcosystemPackage::eINSTANCE.unitExpressionNode_Unit)
		} else if(!expr.topLevel) {
			error("Nested unit expression not allowed", expr, EcosystemPackage::eINSTANCE.unitExpressionNode_Unit)
		}
		expr.child.validateExpr(context)
	}
	protected def dispatch void validateExpr(BinaryArithmeticExpressionNode expr, SpratExprContext context) {
		expr.left.validateExpr(context)
		expr.right.validateExpr(context)
	}
	protected def dispatch void validateExpr(UnaryBooleanExpressionNode expr, SpratExprContext context) {
		if(context != SpratExprContext.VARIABLE_MATH) {
			error("Non-arithmetic operation not allowed here", expr, EcosystemPackage::eINSTANCE.unaryBooleanExpressionNode_Op)
		}
		expr.child.validateExpr(context)
	}
	protected def dispatch void validateExpr(UnaryArithmeticExpressionNode expr, SpratExprContext context) {
		expr.child.validateExpr(context)
	}
	protected def dispatch void validateExpr(MathFunction expr, SpratExprContext context) {
		if(!expr.name.mathFunctionName) {
			error("Invalid math function; must be one of: " + EcosystemDescription.MATH_FUNCTIONS.functions.map[it.name].join(", "), expr, EcosystemPackage::eINSTANCE.mathFunction_Name)
		}
		expr.argument.validateExpr(context)
	}
	protected def dispatch void validateExpr(RecordFunction expr, SpratExprContext context) {
		if(context != SpratExprContext.RECORD_EXPR) {
			error("Record function not allowed here", expr, EcosystemPackage::eINSTANCE.recordFunction_Name)
		} else if(!expr.name.recordFunctionName) {
			error("Invalid record function; must be one of: " + EcosystemDescription.RECORD_FUNCTIONS.functions.map[it.name].join(", "), expr, EcosystemPackage::eINSTANCE.recordFunction_Name)
		} else {
			if(expr.arguments.length < EcosystemDescription.RECORD_FUNCTIONS.getFunction(expr.name).nArguments) {
				error("Too few arguments", expr, EcosystemPackage::eINSTANCE.recordFunction_ClosingParenthesis)
			}
			for(arg : expr.arguments) {
				arg.validateExpr(context)
			}
		}
	}
	protected def dispatch void validateExpr(RecordFunctionArgument expr, SpratExprContext context) {
		val f = (expr.eContainer as RecordFunction)
		
		if(f.name.recordFunctionName) {
			val sf = EcosystemDescription.RECORD_FUNCTIONS.getFunction(f.name)
			if(expr.argumentIndex(f) >= sf.nArguments) {
				error("Too many arguments", expr, null)
			} else {
				val sarg = sf.arguments.get(expr.argumentIndex(f))
				if(!sarg.name.equals(expr.name)) {
					error("Argument name must be '"+sarg.name+"'", expr, EcosystemPackage::eINSTANCE.recordFunctionArgument_Name)
					expr.argument.validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
				}
				if(sarg.units == EcosystemDescription.IDENTIFIER) {
					if(!(expr.argument instanceof Identifier)
						|| !(expr.argument as Identifier).name.isValidSpeciesName(expr)
					) {
						error("Argument must be a species", expr.argument, null)
					}
				} else {
					expr.argument.validateCorrectUnit(sarg.units, sarg.range)
					expr.argument.validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
				}
			}
		} else {
			expr.argument.validateExpr(SpratExprContext.RECORD_FUNCTION_ARGUMENT)
		}
	}
	protected def dispatch void validateExpr(IntegerLiteral expr, SpratExprContext context) {
	}
	protected def dispatch void validateExpr(RealLiteral expr, SpratExprContext context) {
	}
	protected def dispatch void validateExpr(Identifier expr, SpratExprContext context) {
		if(context != SpratExprContext.VARIABLE_MATH) {
			error("Identifier not allowed here", expr, null)
		} else if(!expr.name.isMathVariable) {
			error("Invalid variable name; must be one of: " + EcosystemDescription.MATH_VARIABLES.join(", "), expr, null)
		}
	}
	protected def dispatch void validateExpr(Void expr, SpratExprContext context) {
	}
}
