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

package org.sprat.ecosystem.helper

import com.google.inject.Inject
import java.util.ArrayList
import org.eclipse.emf.ecore.EObject
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.EcosystemModel
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.PropertyAttributeValue
import org.sprat.ecosystem.ecosystem.RangeExpressionNode
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.ecosystem.RecordModifierFunction
import org.sprat.ecosystem.ecosystem.UnitExpressionNode

class ValidationHelper {
	
	@Inject extension ModelHelper
	
	def ArrayList<String> getSpeciesNames(EcosystemModel model) {
		var ArrayList<String> species = new ArrayList()
		for(entity : model.entities) {
			if(entity.type == EntityType.SPECIES && entity.name != null) {
				species.add(entity.name)
			}
		}
		return species
	}
	def boolean isValidSpeciesName(String sname, EObject obj) {
		obj.rootNode.speciesNames.filter[ it==sname ].length > 0
	}
	
	
	def listMissingAttributes(Entity entity) {
		val attributeCollection = EcosystemDescription.getAttributeCollection(entity)
		val propertyAttributes = entity.attributes.filter[it instanceof PropertyAttribute]
		var ArrayList<SpratAttribute> missing = new ArrayList()
		
		for(spratAttribute : attributeCollection.attributes) {
			if(propertyAttributes.filter[ 
				spratAttribute.name.equals((it as PropertyAttribute).name)
			].empty) {
				missing.add(spratAttribute)
			}
		}
		return missing
	}
	
//	def String containmentHierarchy(EObject obj) {
//		var String result = ""
//		var EObject object = obj
//		while(object != null) {
//			result = result + object.toString + "\n"
//			object = object.eContainer
//		}
//		//result = result + "\n"
//		return result
//	}	
	
//	def SpratExprContext inferContext(Expression expr) {
//		// Find location in AST
//		var EObject container = expr?.eContainer
//		while(container != null) {
//			switch(container) {
//				PropertyAttributeValue: return inferContext(container as PropertyAttributeValue)
//				FunctionArgument: return inferContext(container as FunctionArgument)
//				RecordExpression: return SpratExprContext.RECORD_EXPR
//				RecordAttributeModifier: return SpratExprContext.RECORD_MODIFIER
//			}
//			container = container.eContainer
//		}
//		return SpratExprContext.UNDEFINED
//	}
//	
//	def SpratExprContext inferContext(PropertyAttributeValue pav) {
//		// TODO: Implement
//		SpratExprContext.CONST_MATH
//		//SpratExprContext.VARIABLE_MATH
//	}
//	
//	def SpratExprContext inferContext(FunctionArgumentValue fa) {
//		// TODO: Implement
//		SpratExprContext.RECORD_FUNCTION_ARGUMENT
//		// return inferContext(Expression expr)
//	}
//	
//	
	

	def boolean isTopLevel(RangeExpressionNode expr) {
		expr.eContainer instanceof RecordFunctionArgument
	}
	def boolean isTopLevel(UnitExpressionNode expr) {
		switch(expr.eContainer) {
			RecordFunctionArgument: true
			RangeExpressionNode: true
			PropertyAttribute: true
			PropertyAttributeValue: true
			RecordModifierFunction: true
			default: false
		}
	}
	
	def boolean isMathFunctionName(String fname) {
		EcosystemDescription.MATH_FUNCTIONS.contains(fname)
	}
	def boolean isMathVariable(String vname) {
		EcosystemDescription.MATH_VARIABLES.contains(vname)
	}
	def boolean isRecordFunctionName(String fname) {
		EcosystemDescription.RECORD_FUNCTIONS.contains(fname)
	}
	
	def int argumentIndex(RecordFunctionArgument arg, RecordFunction f) {
		f.arguments.indexOf(arg)
	}
	
}

