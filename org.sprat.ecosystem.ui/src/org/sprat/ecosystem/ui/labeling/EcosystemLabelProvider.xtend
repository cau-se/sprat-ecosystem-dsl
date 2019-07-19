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

package org.sprat.ecosystem.ui.labeling

import com.google.inject.Inject
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider
import org.sprat.ecosystem.ecosystem.Entity
import org.sprat.ecosystem.ecosystem.EntityType
import org.sprat.ecosystem.ecosystem.PropertyAttribute
import org.sprat.ecosystem.ecosystem.RecordAttribute

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class EcosystemLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}
	//@Inject extension TypeRepresentation

	// Labels and icons can be computed like this:
	
	def text(Entity entity) {
		if(entity.type == EntityType.SPECIES) {
			return entity.name?: entity.type
		} else {
			return entity.type
		}
	}
	def image(Entity entity) {
		switch(entity.type) {
			case EntityType.ECOSYSTEM: 'ecosystem.gif'
			case EntityType.INPUT: 'input.gif'
			case EntityType.OUTPUT: 'output.gif'
			default: 'species.gif'
		}
	}
	
	def text(RecordAttribute recordAttribute) {
		recordAttribute.description?:'record'
	}
	def image(RecordAttribute recordAttribute) {
		'record.gif'
	}
	
	def text(PropertyAttribute attribute) {
		attribute.name?:'?'
	}
	def image(PropertyAttribute recordAttribute) {
		'attribute.gif'
	}
}
