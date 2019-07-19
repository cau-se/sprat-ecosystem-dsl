package org.sprat.ecosystem.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.sprat.ecosystem.EcosystemInjectorProvider

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(EcosystemInjectorProvider))
class EcosystemParserTest {
	
//	@Inject extension ParseHelper<EcosystemModel>
//	@Inject extension ValidationTestHelper
//	
//	
//	
//	@Test
//	def void testGeneralParsing() {
//		Assert::assertTrue(true)
//		val source = '''
//Species Sprat {
//	ScientificName: "Sprattus sprattus"
//	InitialDistribution: function @ 1.0
//	
//	
//	MaxSwimmingSpeed: 0.5 [m/s]
//	GrowthCoefficient: sqrt(amass=-2.789+55.0+5)+6 @ 10 [°C]
//	MaxMass: sqrt(-2.789+55.0+5)+6 [g]
//}
//
//'''
//		//source.parse.assertNoErrors
//		val model = source.parse
//		val gCoeff = (model.entities.get(0).attributes.get(3) as PropertyAttribute)
//		Assert::assertEquals("GrowthCoefficient", gCoeff.aname)
//		Assert::assertFalse(ExpressionTools.isValidConstMathExpression(gCoeff.value as Expression))
//		val maxMass = (model.entities.get(0).attributes.get(4) as PropertyAttribute)
//		Assert::assertTrue(ExpressionTools.isValidConstMathExpressionWithUnit(maxMass.value as Expression))
//		Assert::assertFalse(ExpressionTools.isValidConstMathExpressionWithoutUnit(maxMass.value as Expression))
//		
//		
//		/val entity = model.entities.get(0)
//		Assert::assertEquals("Sprat", entity.name)
//		val scname = entity.attributes.get(0)
//		Assert::assertEquals("ScientificName", scname.aname)
//		Assert::assertEquals("Sprattus sprattus", (scname.value as StringAttributeValue).value)
//		
//		val swimmingSpeed = entity.attributes.get(2)
//		Assert::assertEquals("MaxSwimmingSpeed", swimmingSpeed.aname)
//		Assert::assertEquals(0.5, ((swimmingSpeed.value as NumberExpressionWithUnit).expression as RealLiteral).value, 1e-12)
//		Assert::assertEquals("m/s", (swimmingSpeed.value as NumberExpressionWithUnit).unit)

		//Assert::assertTrue(scname.value.equals("Sprattus sprattus"))
		//Assert::assertTrue(scname.value.value.equals("Sprattus sprattus"))
		//Assert::assert("", scname.value)
		//Assert::assertEquals(320, greeting.value, 1e-6)
		//Assert::assertEquals("kg*m^2/3", greeting.unit)
//	}
}
