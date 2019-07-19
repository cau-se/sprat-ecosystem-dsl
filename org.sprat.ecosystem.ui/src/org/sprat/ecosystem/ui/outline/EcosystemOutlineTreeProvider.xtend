package org.sprat.ecosystem.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode
import org.sprat.ecosystem.ecosystem.Attribute
import org.sprat.ecosystem.ecosystem.EcosystemModel

/**
 * Customization of the default outline structure.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 */
class EcosystemOutlineTreeProvider extends DefaultOutlineTreeProvider {
	
	def _isLeaf(Attribute a) {
		true
	}
	
	def void _createChildren(DocumentRootNode outlineNode, EcosystemModel model) {
		model.entities.forEach[
			createNode(outlineNode, it);
		]
	}
}
