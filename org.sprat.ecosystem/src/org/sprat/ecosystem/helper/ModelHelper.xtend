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

import org.eclipse.emf.ecore.EObject
import org.sprat.ecosystem.ecosystem.Attribute
import org.sprat.ecosystem.ecosystem.EcosystemModel
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType

class ModelHelper {
	def String getEntityTypePrintName(EntityType t) {
		switch(t) {
			case EntityType.SPECIES: "Species"
			case EntityType.ECOSYSTEM: "Ecosystem"
			case EntityType.INPUT: "Input"
			case EntityType.OUTPUT: "Output"
		}
	}
	
	def Entity getEntity(Attribute attribute) {
		return (attribute.eContainer as Entity);
	}
	
//	def int getIndexInProperty(Attribute attribute) {
//		val entity = getEntity(attribute)
//		return entity.attributes.indexOf(attribute);
//	}

	def int getEntityIndexInModel(Entity entity) {
		val model = entity.eContainer as EcosystemModel
		return model.entities.indexOf(entity);
	}
	
	def EcosystemModel getRootNode(EObject obj) {
		var container = obj
		while(container.eContainer != null) {
			container = container.eContainer
		}
		return (container as EcosystemModel)
	}
	
	def getSpecies(EcosystemModel model) {
		model.entities.filter[it.type == EntityType.SPECIES]
	}
	
	def int getSpeciesIndex(String name, EcosystemModel model) {
		val spEntities = model.entities.filter[it.type == EntityType.SPECIES]
		for(i : 0 ..< spEntities.length) {
			if(spEntities.get(i).name.equals(name)) {
				return i
			}
		}
		return 0;
	}
	
	def nEntitiesOfType(EcosystemModel model, EntityType t) {
		model.entities.filter[ it.type == t ].length
	}
}