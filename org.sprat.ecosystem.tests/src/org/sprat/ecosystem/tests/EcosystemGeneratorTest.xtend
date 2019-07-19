package org.sprat.ecosystem.tests

import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.runner.RunWith
import org.sprat.ecosystem.EcosystemInjectorProvider

//import org.eclipse.xtext.junit4.compiler.CompilationTestHelper

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(EcosystemInjectorProvider))
class EcosystemGeneratorTest {
	
//	@Inject extension CompilationTestHelper
//	
//	@Test
//	def void testGeneratedCode() {
//		Assert::assertTrue(true);
//		'''
//Species Herring {
//	ScientificName: "Herum apumus"
//	InitialDistribution: function @ (1.0-r)*(sqrt((x-0.5)*(x-0.5) + y*y)<=0.3 ? (x<=0.5 && fabs(y)<0.08 ? 0.0 : 1.0) : 0.0)
//	
//	
//	MaxSwimmingSpeed: 1.5 [m/s]
//	GrowthCoefficient: 3.45 @ 15.3 [°C]
//	MaxMass: 0.5 [kg]
//}
//
//Species Sprat {
//	ScientificName: "Sprattus sprattus"
//	InitialDistribution: function @ (1.0-r)*(sqrt((x-0.5)*(x-0.5) + y*y)<=0.3 ? (x<=0.5 && fabs(y)<0.08 ? 0.0 : 1.0) : 0.0)
//	
//	
//	MaxSwimmingSpeed: 0.5 [m/s]
//	GrowthCoefficient: 2.789 @ 10 [°C]
//	MaxMass: 450 [g]
//}
//'''.assertCompilesTo('''
//package entities;
//public class MyEntity {
//private String myAttribute;
//public String getMyAttribute() {
//return myAttribute;
//}
//public void setMyAttribute(String _arg) {
//this.myAttribute = _arg;
//}
//}
//''')
//	}
}

