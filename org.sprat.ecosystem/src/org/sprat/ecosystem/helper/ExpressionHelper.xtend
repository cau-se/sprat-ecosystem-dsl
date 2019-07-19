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
import org.sprat.ecosystem.ecosystem.BinaryArithmeticExpressionNode
import org.sprat.ecosystem.ecosystem.BinaryBooleanExpressionNode
import org.sprat.ecosystem.ecosystem.Identifier
import org.sprat.ecosystem.ecosystem.IntegerLiteral
import org.sprat.ecosystem.ecosystem.MathFunction
import org.sprat.ecosystem.ecosystem.RangeExpressionNode
import org.sprat.ecosystem.ecosystem.RealLiteral
import org.sprat.ecosystem.ecosystem.RecordFunction
import org.sprat.ecosystem.ecosystem.RecordFunctionArgument
import org.sprat.ecosystem.ecosystem.TernaryConditionalExpressionNode
import org.sprat.ecosystem.ecosystem.UnaryArithmeticExpressionNode
import org.sprat.ecosystem.ecosystem.UnaryBooleanExpressionNode
import org.sprat.ecosystem.ecosystem.UnitExpressionNode

class ExpressionHelper {
	/*
	TernaryConditionalExpressionNode
	BinaryBooleanExpressionNode
	RangeExpressionNode
	UnitExpressionNode
	BinaryArithmeticExpressionNode
	UnaryBooleanExpressionNode
	UnaryArithmeticExpressionNode
	MathFunction
	RecordFunction
	RecordFunctionArgument
	IntegerLiteral
	RealLiteral
	Identifier
	*/
	
	@Inject extension ModelHelper
	
	
	def dispatch String format(RangeExpressionNode expr) {
		var String result
		if(expr.from == null) {
			result = "-1.0"
		} else {
			result = expr.from.format
		}
		result += ", "
		if(expr.to == null) {
			result += "-1.0"
		} else {
			result += expr.to.format
		}
		return result
	}
	def dispatch String format(TernaryConditionalExpressionNode expr) {
		return FormattingHelper.parenthize(expr.condition.format) + " ? " + 
			FormattingHelper.parenthize(expr.ifTrue.format) + " : " + 
			FormattingHelper.parenthize(expr.ifFalse.format)
	}
	def dispatch String format(BinaryBooleanExpressionNode expr) {
		return FormattingHelper.parenthize(expr.left.format + " " + expr.op + " " + expr.right.format)
	}
	def dispatch String format(UnitExpressionNode expr) {
		return EcosystemDescription.formatConversionToBaseUnit(expr.unit, expr.child.format)
	}
	def dispatch String format(BinaryArithmeticExpressionNode expr) {
		return FormattingHelper.parenthize(expr.left.format + " " + expr.op + " " + expr.right.format)
	}
	def dispatch String format(UnaryBooleanExpressionNode expr) {
		return expr.op + format(expr.child)
	}
	def dispatch String format(UnaryArithmeticExpressionNode expr) {
		return expr.op + format(expr.child)
	}
	def dispatch String format(MathFunction expr) {
		return expr.name + "(" + expr.argument.format + ")"
	}
	def dispatch String format(RecordFunction expr) {
		var String result = expr.name + "(dof";
		if(!expr.arguments.empty) {
			result += ", " + expr.arguments.map[ format ].join(", ");
		}
		result += ")";
		return result;
	}
	def dispatch String format(RecordFunctionArgument expr) {
		if(expr.argument instanceof Identifier) {
			return Integer.toString((expr.argument as Identifier).name.getSpeciesIndex(expr.rootNode))
		}
		return expr.argument.format
	}
	def dispatch String format(IntegerLiteral expr) {
		return FormattingHelper.formatDouble(expr.value as double)
	}
	def dispatch String format(RealLiteral expr) {
		return FormattingHelper.formatDouble(expr.value)
	}
	def dispatch String format(Identifier expr) {
		return expr.name
	}
	def dispatch String format(Void expr) {
		return ""
	}
	
	
	
	
	
	def dispatch double eval(RangeExpressionNode expr) {
		0.0
	}
	def dispatch double eval(TernaryConditionalExpressionNode expr) {
		0.0
	}
	def dispatch double eval(BinaryBooleanExpressionNode expr) {
		0.0
	}
	def dispatch double eval(UnitExpressionNode expr) {
		EcosystemDescription.convertToBaseUnit(expr.unit, expr.child.eval)
	}
	def dispatch double eval(BinaryArithmeticExpressionNode expr) {
		val left = expr.left.eval
		val right = expr.right.eval
		return switch(expr.op) {
			case "+": left + right
			case "-": left - right
			case "*": left * right
			case "/": left / right
			default: 0.0
		}
	}
	def dispatch double eval(UnaryBooleanExpressionNode expr) {
		0.0
	}
	def dispatch double eval(UnaryArithmeticExpressionNode expr) {
		val child = expr.child.eval
		return switch(expr.op) {
			case "+": child
			case "-": -1.0 * child
			default: 0.0
		}
	}
	def dispatch double eval(MathFunction expr) {
		if(expr.argument != null) {
			EcosystemDescription.MATH_FUNCTIONS.evalFunction(expr.name, expr.argument.eval);
		} else {
			0.0
		}
	}
	def dispatch double eval(RecordFunction expr) {
		0.0
	}
	def dispatch double eval(RecordFunctionArgument expr) {
		0.0
	}
	def dispatch double eval(RealLiteral expr) {
		expr.value
	}
	def dispatch double eval(IntegerLiteral expr) {
		((expr.value) as double)
	}
	def dispatch double eval(Identifier expr) {
		0.0
	}
	def dispatch double eval(Void expr) {
		0.0
	}
	
	
	
	def dispatch SpratDimensionality evalDim(RangeExpressionNode expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(TernaryConditionalExpressionNode expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(BinaryBooleanExpressionNode expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(UnitExpressionNode expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(BinaryArithmeticExpressionNode expr) {
		val left = expr.left.evalDim
		val right = expr.right.evalDim
		return combinDims(left, right)
	}
	def dispatch SpratDimensionality evalDim(UnaryBooleanExpressionNode expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(UnaryArithmeticExpressionNode expr) {
		return expr.child.evalDim
	}
	def dispatch SpratDimensionality evalDim(MathFunction expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(RecordFunction expr) {
		if(EcosystemDescription.RECORD_FUNCTIONS.contains(expr.name)) {
			return EcosystemDescription.RECORD_FUNCTIONS.getFunction(expr.name).dimensionality
		}
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(RecordFunctionArgument expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(RealLiteral expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(IntegerLiteral expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(Identifier expr) {
		return SpratDimensionality.ZERO
	}
	def dispatch SpratDimensionality evalDim(Void expr) {
		return SpratDimensionality.ZERO
	}
	
	def SpratDimensionality combinDims(SpratDimensionality a, SpratDimensionality b) {
		if(a == SpratDimensionality.N || b == SpratDimensionality.N) {
			return SpratDimensionality.N
		}
		if(a == SpratDimensionality.N_MINUS_ONE || b == SpratDimensionality.N_MINUS_ONE) {
			return SpratDimensionality.N_MINUS_ONE
		}
		if(a == SpratDimensionality.ONE || b == SpratDimensionality.ONE) {
			return SpratDimensionality.ONE
		}
		return SpratDimensionality.ZERO
	}
	
}