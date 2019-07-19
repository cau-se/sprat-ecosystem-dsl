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
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.EcosystemModel
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.Expression
import org.sprat.ecosystem.ecosystem.IntegerLiteral
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.RangeExpressionNode
import org.sprat.ecosystem.ecosystem.RecordAttribute
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.ecosystem.RecordModifierFunction
import org.sprat.ecosystem.ecosystem.RecordModifierIdentifier

import static org.sprat.ecosystem.helper.SpratDimensionality.*

import static extension org.sprat.ecosystem.helper.FormattingHelper.*
import org.sprat.ecosystem.ecosystem.StringLiteral
import org.sprat.ecosystem.ecosystem.Identifier

class GeneratorHelper {
	
	@Inject extension ExpressionHelper
	
	def getSpeciesEntities(EcosystemModel model) {
		model.entities.filter[
			it.type == EntityType.SPECIES
		]
	}
	def nSpecies(EcosystemModel model) {
		model.getSpeciesEntities.length
	}
	def PropertyAttribute getSpeciesPropertyAttribute(Entity s, String name) {
		(s.attributes.filter[
			name.equals((it as PropertyAttribute).name)
		].head as PropertyAttribute)
	}
	
	def getRealValuedEcosystemProperties() {
		EcosystemDescription.ECOSYSTEM_ATTRIBUTES.attributes.filter[
			EcosystemDescription.isRealUnitCategory(it.unitCategory) && 
			!("SimulateFor".equals(it.name))
		]
	}
	def getRealValuedSpeciesProperties() {
		EcosystemDescription.SPECIES_ATTRIBUTES.attributes.filter[EcosystemDescription.isRealUnitCategory(it.unitCategory)]
	}
	
	
	def PropertyAttribute findPropertyAttribute(EcosystemModel model, EntityType t, String name) {
		(model.entities.filter[
			it.type == t
		].head.attributes.filter[
			name.equals((it as PropertyAttribute).name)
		].head as PropertyAttribute)
	}
	
	
	
	def Expression getInitialDistribution(EcosystemModel model, int species) {
		((model.entities.filter[
			it.type == EntityType.SPECIES
		].get(species).attributes.filter[
			'InitialDistribution'.equals((it as PropertyAttribute).name)
		].head as PropertyAttribute).modifier.value as Expression)
	}
	
	def double getEcosystemAttributeValue(EcosystemModel model, String name) {
		(model.findPropertyAttribute(EntityType.ECOSYSTEM, name).attribute.value as Expression).eval
	}
	
	def double getTMax(EcosystemModel model) {
		(model.findPropertyAttribute(EntityType.ECOSYSTEM, 'SimulateFor').attribute.value as Expression).eval
	}
	
	def RecordFunction getMeshFunction(EcosystemModel model) {
		(model.findPropertyAttribute(EntityType.INPUT, 'Mesh').attribute.value as RecordFunction)
	}
	
	def int getMeshDimension(RecordFunction f) {
		3
	}
	def String getMeshDimensionName(int whichDim, int nDim) {
		if(whichDim == nDim-1) {
			return "r";
		}
		return switch(whichDim) {
			case 0: "x"
			case 1: "y"
			case 2: "z"
			default: ("w"+(whichDim-2))
		}
	}
	
	def int getMeshDimensionResolution(int dimension, RecordFunction f) {
		((f.arguments.get(1 + 2*dimension) as RecordFunctionArgument).argument as IntegerLiteral).value
	}
	def double getMeshDimensionMin(int dimension, RecordFunction f) {
		((f.arguments.get(2*dimension) as RecordFunctionArgument).argument as RangeExpressionNode).from.eval
	}
	def double getMeshDimensionMax(int dimension, RecordFunction f) {
		((f.arguments.get(2*dimension) as RecordFunctionArgument).argument as RangeExpressionNode).to.eval
	}
	
	def double getTimeStep(EcosystemModel model) {
		(model.findPropertyAttribute(EntityType.ECOSYSTEM, "TimeStep").attribute.value as Expression).eval
	}
	
	def String getOutputFormat(EcosystemModel model) {
		(model.findPropertyAttribute(EntityType.OUTPUT, "OutputFormat").attribute.value as Identifier).name
	}
	def String getOutputModifierString(EcosystemModel model) {
		(model.findPropertyAttribute(EntityType.OUTPUT, "OutputFormat").modifier.value as StringLiteral).value
	}
	
	
	
	def getRecordAttributes(EcosystemModel model) {
		model.entities.filter[
			it.type == EntityType.OUTPUT
		].head.attributes.filter(typeof(RecordAttribute))
	}
	
	def deduceDimensionality(RecordAttribute r, EcosystemModel model) {
		val SpratDimensionality dim = r.expression.evalDim
		switch(dim) {
			case ZERO: 0
			case ONE: 1
			case N: model.getMeshFunction.meshDimension
			case N_MINUS_ONE: model.getMeshFunction.meshDimension-1
		}
	}
	
	def formatRecordModifier(RecordAttribute r) {
		var String name
		if(r.recModifier instanceof RecordModifierIdentifier) {
			name = (r.recModifier as RecordModifierIdentifier).value
		} else {
			name = (r.recModifier as RecordModifierFunction).name
		}
		return '''RecordWhen::«name.toUpperCase»'''
	}
	def formatRecordModifierWithInterval(RecordAttribute r) {
		var String name
		var double every
		if(r.recModifier instanceof RecordModifierIdentifier) {
			name = (r.recModifier as RecordModifierIdentifier).value
			every = -1.0
		} else {
			name = (r.recModifier as RecordModifierFunction).name
			every = (r.recModifier as RecordModifierFunction).argument.eval
		}
		return '''
			RecordWhen::«name.toUpperCase»,
			«every.formatDouble»«IF every > 0.0» // in «EcosystemDescription.TIME.baseUnit»«ENDIF»
		'''
	}
}





