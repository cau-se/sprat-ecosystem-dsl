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

package org.sprat.ecosystem;

import java.util.ArrayList;

import org.sprat.ecosystem.ecosystem.Entity;
import org.sprat.ecosystem.ecosystem.EntityType;
import org.sprat.ecosystem.helper.AttributeCollection;
import org.sprat.ecosystem.helper.FormattingHelper;
import org.sprat.ecosystem.helper.FunctionCollection;
import org.sprat.ecosystem.helper.MathFunctionCollection;
import org.sprat.ecosystem.helper.SpratAttribute;
import org.sprat.ecosystem.helper.SpratDimensionality;
import org.sprat.ecosystem.helper.SpratFunction;
import org.sprat.ecosystem.helper.SpratFunctionArgument;
import org.sprat.ecosystem.helper.SpratMathFunction;
import org.sprat.ecosystem.helper.SpratUnit;
import org.sprat.ecosystem.helper.UnitCollection;
import org.sprat.ecosystem.helper.ValueRange;

public class EcosystemDescription {
	public static final UnitCollection LENGTH = new UnitCollection("Length");
	public static final UnitCollection VELOCITY = new UnitCollection("Velocity");
	public static final UnitCollection TIME = new UnitCollection("Time");
	public static final UnitCollection FREQUENCY = new UnitCollection("Frequency");
	public static final UnitCollection ACCELERATION = new UnitCollection("Acceleration");
	public static final UnitCollection MASS = new UnitCollection("Mass");
	public static final UnitCollection PER_MASS = new UnitCollection("per Mass");
	public static final UnitCollection FORCE = new UnitCollection("Force");
	public static final UnitCollection ENERGY = new UnitCollection("Energy");
	public static final UnitCollection ENERGY_CONTENT = new UnitCollection("Energy content");
	public static final UnitCollection PER_AREA = new UnitCollection("Per area");
	public static final UnitCollection AREA_MASS_CONCENTRATION = new UnitCollection("Area mass concentration");
	public static final UnitCollection AREA_CARBON_MASS_CONCENTRATION = new UnitCollection("Area carbon mass concentration");
	public static final UnitCollection AREA_CONCENTRATION = new UnitCollection("Area unit concentration");
	public static final UnitCollection VOLUME_MASS_CONCENTRATION = new UnitCollection("Volume mass concentration");
	public static final UnitCollection VOLUME_CONCENTRATION = new UnitCollection("Volume unit concentration");
	public static final UnitCollection TEMPERATURE = new UnitCollection("Temperature");
	
	public static final UnitCollection DIMENSIONLESS = new UnitCollection("Dimensionless");
	public static final ArrayList<UnitCollection> REAL_UNIT_CATEGORIES = new ArrayList<>();
	
	
	public static final UnitCollection STRING = new UnitCollection("String");
	public static final UnitCollection IDENTIFIER = new UnitCollection("Identifier");
	public static final UnitCollection VARIABLE_EXPRESSION = new UnitCollection("Variable expression");
	public static final ArrayList<UnitCollection> OTHER_UNIT_CATEGORIES = new ArrayList<>();
	public static final UnitCollection SPECIAL = new UnitCollection("Special");
	
	
	public static final AttributeCollection SPECIES_ATTRIBUTES = new AttributeCollection();
	public static final AttributeCollection ECOSYSTEM_ATTRIBUTES = new AttributeCollection();
	public static final AttributeCollection INPUT_ATTRIBUTES = new AttributeCollection();
	public static final AttributeCollection OUTPUT_ATTRIBUTES = new AttributeCollection();
	
	
	public static final MathFunctionCollection MATH_FUNCTIONS = new MathFunctionCollection("Math function");
	public static final ArrayList<String> MATH_VARIABLES = new ArrayList<>();
	public static final FunctionCollection RECORD_MODIFIERS = new FunctionCollection("Record modifier function");
	public static final FunctionCollection RECORD_FUNCTIONS = new FunctionCollection("Record function");
	public static final ArrayList<String> OTHER_KNOWN_IDENTIFIERS = new ArrayList<>();
	
	
	static {		
		/*
		 * Unit collections.
		 */
		LENGTH.add(new SpratUnit("m", 1.0));

		LENGTH.add(new SpratUnit("dm", 1.0e-1));
		LENGTH.add(new SpratUnit("cm", 1.0e-2));
		LENGTH.add(new SpratUnit("mm", 1.0e-3));
		LENGTH.add(new SpratUnit("um", 1.0e-6));
		LENGTH.add(new SpratUnit("km", 1.0e3));
		
		
		VELOCITY.add(new SpratUnit("m/s", 1.0));
		VELOCITY.add(new SpratUnit("cm/s", 1.0e-2));
		VELOCITY.add(new SpratUnit("km/h", 1.0/3.6));
		
		
		TIME.add(new SpratUnit("s", 1.0));
		TIME.add(new SpratUnit("ms", 1.0e-3));
		TIME.add(new SpratUnit("us", 1.0e-6));
		TIME.add(new SpratUnit("ns", 1.0e-9));
		TIME.add(new SpratUnit("min", 60.0));
		TIME.add(new SpratUnit("h", 60.0*60.0));
		TIME.add(new SpratUnit("d", 24.0*60.0*60.0));
		TIME.add(new SpratUnit("y", 365.25*24.0*60.0*60.0));
		
		
		FREQUENCY.add(new SpratUnit("Hz", 1.0));
		FREQUENCY.add(new SpratUnit("s^-1", 1.0));
		FREQUENCY.add(new SpratUnit("1/s",  1.0));
		FREQUENCY.add(new SpratUnit("h^-1", 1.0/3600.0));
		FREQUENCY.add(new SpratUnit("1/h",  1.0/3600.0));		
		FREQUENCY.add(new SpratUnit("d^-1", 1.0/(24.0*3600.0)));
		FREQUENCY.add(new SpratUnit("1/d",  1.0/(24.0*3600.0)));
		
		
		ACCELERATION.add(new SpratUnit("m/s^2", 1.0));
		ACCELERATION.add(new SpratUnit("m*s^-2", 1.0));
		
		
		MASS.add(new SpratUnit("kg", 1.0));
		MASS.add(new SpratUnit("g", 1.0e-3));
		MASS.add(new SpratUnit("mg", 1.0e-6));
		MASS.add(new SpratUnit("ug", 1.0e-9));
		MASS.add(new SpratUnit("t", 1.0e3));
		
		PER_MASS.add(new SpratUnit("1/kg",  1.0));
		PER_MASS.add(new SpratUnit("kg^-1", 1.0));
		PER_MASS.add(new SpratUnit("1/g",  1.0e3));
		PER_MASS.add(new SpratUnit("g^-1", 1.0e3));
		
		
		FORCE.add(new SpratUnit("N", 1.0));
		FORCE.add(new SpratUnit("km*m*s^-2", 1.0));
		FORCE.add(new SpratUnit("km*m/s^2", 1.0));
		
		ENERGY.add(new SpratUnit("J", 1.0));
		
		ENERGY_CONTENT.add(new SpratUnit("kJ/kg", 1.0));
		ENERGY_CONTENT.add(new SpratUnit("J/kg", 1.0e-3));
		ENERGY_CONTENT.add(new SpratUnit("MJ/kg", 1.0e3));
		
		PER_AREA.add(new SpratUnit("1/m^2", 1.0));
		PER_AREA.add(new SpratUnit("m^-2", 1.0));
		
		AREA_MASS_CONCENTRATION.add(new SpratUnit("kg/m^2", 1.0));
		AREA_MASS_CONCENTRATION.add(new SpratUnit("kg m^-2", 1.0));
		
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("kg C m^-2", 1.0));
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("g C m^-2", 1.0e-3));
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("mg C m^-2", 1.0e-6));
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("kg C/m^2", 1.0));
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("g C/m^2", 1.0e-3));
		AREA_CARBON_MASS_CONCENTRATION.add(new SpratUnit("mg C/m^2", 1.0e-6));
		
		AREA_CONCENTRATION.add(new SpratUnit("1/m^2", 1.0));
		
		VOLUME_MASS_CONCENTRATION.add(new SpratUnit("kg/m^3", 1.0));
		
		VOLUME_CONCENTRATION.add(new SpratUnit("1/m^3", 1.0));
		
		TEMPERATURE.add(new SpratUnit("°C", 1.0));
		TEMPERATURE.add(new SpratUnit("°K", 1.0, -273.2));
		TEMPERATURE.add(new SpratUnit("°F", 5.0/9.0, (-5.0/9.0)*32.0));
		
		DIMENSIONLESS.add(new SpratUnit("", 1.0));
		
		
		/*
		 * Attributes for the different entities.
		 */
		SPECIES_ATTRIBUTES.add(new SpratAttribute("ScientificName", STRING));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("InitialDistribution", IDENTIFIER, VARIABLE_EXPRESSION));
		SPECIES_ATTRIBUTES.getAttribute("InitialDistribution").getValidIdentifiers().add("function");
		SPECIES_ATTRIBUTES.add(new SpratAttribute("SwimmingSpeed", VELOCITY, new ValueRange(0.0, ValueRange.INF)));
		//SPECIES_ATTRIBUTES.add(new SpratAttribute("GrowthCoefficient", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF), TEMPERATURE, new ValueRange(-25.0, 50.0), 10.0));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("MaxWetMass", MASS, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("DryToWetMassRatio", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("CarbonToDryMassRatio", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("lengthWeightParameter_a", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("lengthWeightParameter_b", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("LarvaeBeginPredationMass", MASS, new ValueRange(0.0, ValueRange.INF, false)));
		
		//SPECIES_ATTRIBUTES.add(new SpratAttribute("StrideLength", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		//SPECIES_ATTRIBUTES.add(new SpratAttribute("MaximumTailBeatFrequency", FREQUENCY, new ValueRange(0.0, ValueRange.INF, false), LENGTH, new ValueRange(0.0, ValueRange.INF, false), 0.1));
		//SPECIES_ATTRIBUTES.add(new SpratAttribute("MaximumTailBeatFrequencyAtTemperature", TEMPERATURE, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("WetMassFecundity", PER_MASS, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("EggDryMass", MASS, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("BeginSpawningSeason", DIMENSIONLESS, new ValueRange(0.0, 1.0)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("EndSpawningSeason", DIMENSIONLESS, new ValueRange(0.0, 1.0)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("WetMassAtMaturity", MASS, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("AssimilationEfficiency", DIMENSIONLESS, new ValueRange(0.0, 1.0)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("WetMassUpToWhichPlanktonIsConsumed", MASS, new ValueRange(0.0, ValueRange.INF)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("PredationRate", FREQUENCY, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("GrazingRate", FREQUENCY, new ValueRange(0.0, ValueRange.INF, false)));
		//SPECIES_ATTRIBUTES.add(new SpratAttribute("InflunceOfMassOnPredationExponent", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("LarvaeBeginToPredateAfter", TIME, new ValueRange(0.0, ValueRange.INF, false), TEMPERATURE, new ValueRange(-25.0, 50.0), 10.0));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("PredationHalfSaturation", PER_AREA, new ValueRange(0.0, ValueRange.INF, false)));
		SPECIES_ATTRIBUTES.add(new SpratAttribute("ZooplanktonGrazingHalfSaturation", AREA_CARBON_MASS_CONCENTRATION, new ValueRange(0.0, ValueRange.INF, false)));
		
		SPECIES_ATTRIBUTES.add(new SpratAttribute("QuadraticDeathTerms", FREQUENCY, new ValueRange(0.0, ValueRange.INF)));
		
		
		
		
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("Name", STRING));
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("SimulateFor", TIME));
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("TimeStep", SPECIAL));
		
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("PredatorPreyRatio", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("ZoneOfInfluenceRadius", LENGTH, new ValueRange(0.0, ValueRange.INF)));
		
		ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("influnceOfMassOnPredationExponent", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF, false)));
		
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("ScalingExponentForPredatorRisk", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("ScalingExponentForStarvationRisk", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("AdditiveRiskScaling", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("ReactiveMovementThreshold", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("ReactiveMovementThresholdScaling", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("PredictiveMovementThreshold", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("AbsoluteRiskForPredictiveMovementThreshold", DIMENSIONLESS, new ValueRange(0.0, ValueRange.INF)));
		
		//ECOSYSTEM_ATTRIBUTES.add(new SpratAttribute("FishEnergyContent", ENERGY_CONTENT));
		
		
		
		INPUT_ATTRIBUTES.add(new SpratAttribute("Mesh", SPECIAL));
		INPUT_ATTRIBUTES.add(new SpratAttribute("ElementType", IDENTIFIER));
		INPUT_ATTRIBUTES.getAttribute("ElementType").getValidIdentifiers().add("P1");
		
		OUTPUT_ATTRIBUTES.add(new SpratAttribute("OutputFormat", IDENTIFIER, STRING));
		OUTPUT_ATTRIBUTES.getAttribute("OutputFormat").getValidIdentifiers().add("TXTFile");
		OUTPUT_ATTRIBUTES.getAttribute("OutputFormat").getValidIdentifiers().add("NetCDFFile");
		
		
		
		
		/*
		 * Functions and variables
		 */
		MATH_FUNCTIONS.add(new SpratMathFunction("sqrt", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.sqrt(x);
			}
		}));
		MATH_FUNCTIONS.add(new SpratMathFunction("fabs", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.abs(x);
			}
		}));
		MATH_FUNCTIONS.add(new SpratMathFunction("exp", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.exp(x);
			}
		}));
		MATH_FUNCTIONS.add(new SpratMathFunction("log", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.log(x);
			}
		}));
		MATH_FUNCTIONS.add(new SpratMathFunction("sin", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.sin(x);
			}
		}));
		MATH_FUNCTIONS.add(new SpratMathFunction("cos", new SpratMathFunction.SpratMathFunctionObject() {
			public double eval(double x) {
				return Math.cos(x);
			}
		}));
		
		MATH_VARIABLES.add("x");
		MATH_VARIABLES.add("y");
		//MATH_VARIABLES.add("z");
		MATH_VARIABLES.add("r");
		
		
		RECORD_FUNCTIONS.add(new SpratFunction("nIndividuals", SpratDimensionality.ZERO, new SpratFunctionArgument("species", IDENTIFIER), new SpratFunctionArgument("mass", MASS, true)));
		RECORD_FUNCTIONS.add(new SpratFunction("carbonBiomass", SpratDimensionality.ZERO, new SpratFunctionArgument("species", IDENTIFIER), new SpratFunctionArgument("mass", MASS, true)));
		RECORD_FUNCTIONS.add(new SpratFunction("dryBiomass", SpratDimensionality.ZERO, new SpratFunctionArgument("species", IDENTIFIER), new SpratFunctionArgument("mass", MASS, true)));
		RECORD_FUNCTIONS.add(new SpratFunction("wetBiomass", SpratDimensionality.ZERO, new SpratFunctionArgument("species", IDENTIFIER), new SpratFunctionArgument("mass", MASS, true)));
		RECORD_FUNCTIONS.add(new SpratFunction("matureWetBiomass", SpratDimensionality.ZERO, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("nutrientsAverage", SpratDimensionality.ZERO));
		RECORD_FUNCTIONS.add(new SpratFunction("phytoplanktonAverage", SpratDimensionality.ZERO));
		RECORD_FUNCTIONS.add(new SpratFunction("zooplanktonAverage", SpratDimensionality.ZERO));
		RECORD_FUNCTIONS.add(new SpratFunction("temperatureAverage", SpratDimensionality.ZERO));
		
		RECORD_FUNCTIONS.add(new SpratFunction("carbonMassDistribution", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("dryMassDistribution", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("wetMassDistribution", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("wetMassDistributionSizeIntegrated", SpratDimensionality.N_MINUS_ONE, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("growthVelocity", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("spatialVelocity", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("spatialCurrentXVelocity", SpratDimensionality.N_MINUS_ONE));
		RECORD_FUNCTIONS.add(new SpratFunction("spatialCurrentYVelocity", SpratDimensionality.N_MINUS_ONE));
		
		RECORD_FUNCTIONS.add(new SpratFunction("localCarbonBiomass", SpratDimensionality.N_MINUS_ONE, new SpratFunctionArgument("species", IDENTIFIER), new SpratFunctionArgument("mass", MASS, true)));
		RECORD_FUNCTIONS.add(new SpratFunction("preyMassConcentration", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("predatorMassConcentration", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("habitatRisk", SpratDimensionality.N, new SpratFunctionArgument("species", IDENTIFIER)));
		RECORD_FUNCTIONS.add(new SpratFunction("nutrients", SpratDimensionality.N_MINUS_ONE));
		RECORD_FUNCTIONS.add(new SpratFunction("phytoplankton", SpratDimensionality.N_MINUS_ONE));
		RECORD_FUNCTIONS.add(new SpratFunction("zooplankton", SpratDimensionality.N_MINUS_ONE));
		RECORD_FUNCTIONS.add(new SpratFunction("zooplanktonDeathToGrazingRatio", SpratDimensionality.N_MINUS_ONE));
		RECORD_FUNCTIONS.add(new SpratFunction("temperature", SpratDimensionality.N_MINUS_ONE));
		
		
		RECORD_MODIFIERS.add(new SpratFunction("every", new SpratFunctionArgument("t", TIME)));
		RECORD_MODIFIERS.add(new SpratFunction("beforeSimulation"));
		RECORD_MODIFIERS.add(new SpratFunction("afterSimulation"));
		
		
		
		/*
		 * Do NOT edit!
		 */
		REAL_UNIT_CATEGORIES.add(LENGTH);
		REAL_UNIT_CATEGORIES.add(VELOCITY);
		REAL_UNIT_CATEGORIES.add(TIME);
		REAL_UNIT_CATEGORIES.add(FREQUENCY);
		REAL_UNIT_CATEGORIES.add(ACCELERATION);
		REAL_UNIT_CATEGORIES.add(MASS);
		REAL_UNIT_CATEGORIES.add(PER_MASS);
		REAL_UNIT_CATEGORIES.add(FORCE);
		REAL_UNIT_CATEGORIES.add(ENERGY);
		REAL_UNIT_CATEGORIES.add(ENERGY_CONTENT);
		REAL_UNIT_CATEGORIES.add(PER_AREA);
		REAL_UNIT_CATEGORIES.add(AREA_MASS_CONCENTRATION);
		REAL_UNIT_CATEGORIES.add(AREA_CARBON_MASS_CONCENTRATION);
		REAL_UNIT_CATEGORIES.add(AREA_CONCENTRATION);
		REAL_UNIT_CATEGORIES.add(VOLUME_MASS_CONCENTRATION);
		REAL_UNIT_CATEGORIES.add(VOLUME_CONCENTRATION);
		REAL_UNIT_CATEGORIES.add(TEMPERATURE);
		REAL_UNIT_CATEGORIES.add(DIMENSIONLESS);
		
		// SPECIAL does not belong here!
		OTHER_UNIT_CATEGORIES.add(STRING);
		OTHER_UNIT_CATEGORIES.add(IDENTIFIER);
		OTHER_UNIT_CATEGORIES.add(VARIABLE_EXPRESSION);
	}
	
	public EcosystemDescription() {}
	
	public static final AttributeCollection getAttributeCollection(Entity entity) {
		return getAttributeCollection(entity.getType());
	}
	
	public static final AttributeCollection getAttributeCollection(EntityType t) {
		if(t == EntityType.SPECIES) {
			return SPECIES_ATTRIBUTES;
		}
		if(t == EntityType.ECOSYSTEM) {
			return ECOSYSTEM_ATTRIBUTES;
		}
		if(t == EntityType.INPUT) {
			return INPUT_ATTRIBUTES;
		}
		if(t == EntityType.OUTPUT) {
			return OUTPUT_ATTRIBUTES;
		}
		return null;
	}
	
	public static double convertToBaseUnit(String unitName, double value) {
		for(UnitCollection uc : REAL_UNIT_CATEGORIES) {
			if(uc.contains(unitName)) {
				return uc.convertToBaseUnit(unitName, value);
			}
		}
		return 0.0;
	}
	public static String formatConversionToBaseUnit(String unitName, String formattedString) {
		for(UnitCollection uc : REAL_UNIT_CATEGORIES) {
			if(uc.contains(unitName)) {
				return uc.formatConversionToBaseUnit(unitName, formattedString);
			}
		}
		return FormattingHelper.parenthize(formattedString);
	}
	
	public static boolean isRealUnitCategory(UnitCollection unitCategory) {
		for(UnitCollection uc : REAL_UNIT_CATEGORIES) {
			if(uc.equals(unitCategory)) {
				return true;
			}
		}
		return false;
	}
	
	public static boolean isOtherUnitCategory(UnitCollection unitCategory) {
		for(UnitCollection uc : OTHER_UNIT_CATEGORIES) {
			if(uc.equals(unitCategory)) {
				return true;
			}
		}
		return false;
	}

	
}
