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

package org.sprat.ecosystem.generator

import com.google.inject.Inject
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import org.sprat.ecosystem.EcosystemDescription
import org.sprat.ecosystem.ecosystem.EcosystemModel
import org.sprat.ecosystem.ecosystem.Expression
import org.sprat.ecosystem.helper.ExpressionHelper
import org.sprat.ecosystem.helper.GeneratorHelper

import static extension org.sprat.ecosystem.helper.FormattingHelper.*

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class EcosystemGenerator implements IGenerator {
	
	@Inject extension ExpressionHelper
	@Inject extension GeneratorHelper
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val model = (resource.getContents().get(0) as EcosystemModel)
		fsa.generateFile('model_parameters.hpp',
			generateModelParameters(model)
		)
		fsa.generateFile('initial_data.hpp',
			generateInitialDataLoading(model)
		)
		fsa.generateFile('fem_config.hpp',
			generateFEMConfig(model)
		)
		fsa.generateFile('model_config.hpp',
			generateModelConfig(model)
		)
		fsa.generateFile('recorder_setup.hpp',
			generateRecorders(model)
		)
	}
	
	def generateModelConfig(EcosystemModel model) {
		val meshFunction = model.getMeshFunction
		val meshFunctionName = meshFunction.name
		return '''
			/*
			 * model_config.hpp
			 *
			 * Automatically-generated file. Do not edit!
			 */
			 
			#ifndef MODEL_CONFIG_HPP_
			#define MODEL_CONFIG_HPP_
			
			#include "../model.hpp"
			typedef SpratModel«meshFunctionName.substring(meshFunctionName.length-4)» ModelT;
			
			#include "../solver.hpp"
			typedef ElementFCTSolverFor«meshFunction.getMeshDimension»DRectMesh SolverT;
			
			
			#endif /* MODEL_CONFIG_HPP_ */
						
		'''
	}
	
	def generateFEMConfig(EcosystemModel model) {
		val meshFunction = model.getMeshFunction
		val meshDim = meshFunction.meshDimension
		
		return '''
			/*
			 * fem_config.hpp
			 *
			 * Automatically-generated file. Do not edit!
			 */
			 
			#ifndef FEM_CONFIG_HPP_
			#define FEM_CONFIG_HPP_
			
			
			#include <vector>
			#include "../pdedsl/mesh.hpp"
			
			
			typedef FEMMeshRectP1Periodic<«meshDim»> FEMMeshT;
			
			struct MeshParameters {
				static std::vector<RectMeshDimension> initParameters() {
					std::vector<RectMeshDimension> dims;
					«FOR dim : 0 ..< meshDim»
						RectMeshDimension dim_«dim»("«dim.getMeshDimensionName(meshDim)»", Interval(«dim.getMeshDimensionMin(meshFunction).formatDouble», «dim.getMeshDimensionMax(meshFunction).formatDouble»), «dim.getMeshDimensionResolution(meshFunction)»);
						dims.push_back(dim_«dim»);
					«ENDFOR»
					return dims;
				}
			};
			
			
			#endif /* FEM_CONFIG_HPP_ */
			
		'''
	}
	
	def generateRecorders(EcosystemModel model) {
		val records = model.recordAttributes
		val writerType = model.outputFormat
	
		return '''
		/*
		 * recorders.hpp
		 *
		 * Automatically-generated file. Do not edit!
		 */
		
		#ifndef RECORDERS_HPP_
		#define RECORDERS_HPP_
		
		#include <vector>
		#include "../pdedsl/sprat_pde_dsl.hpp"
		#include "../recorder.hpp"
		#include "model_config.hpp"
		
		
		struct RecorderSetup {
			
			«FOR i : 0 ..< records.length»
				// «records.get(i).description»
				class SlaveRecorder_impl«i» : public SlaveRecorder {
				public:
					using SlaveRecorder::SlaveRecorder;
				protected:
					real recordValue(DoFT * dof) {
						return «records.get(i).expression.format»;
					}
				};
				
			«ENDFOR»
		
			static void setupMaster(FEMMeshT const& femMesh, std::vector<FileWriter *> & writers, std::vector<MasterRecorder *> & masterRecorders, ParallelExecutionEnvironment const* pEE, std::vector<index_t> const* dofStartIndexForProcess, std::vector<SlaveRecorder *> * slaveRecorders) {
				
				«FOR i : 0 ..< records.length»
					writers.push_back(new «writerType»Writer(
						"«model.outputModifierString»",
						"«records.get(i).description»",
						«records.get(i).deduceDimensionality(model)»,
						«records.get(i).formatRecordModifier»,
						femMesh
					));
				«ENDFOR»
				
		
				«FOR i : 0 ..< records.length»
					masterRecorders.push_back(new MasterRecorder(
						«i»,
						pEE,
						dofStartIndexForProcess,
						(slaveRecorders ? slaveRecorders->operator[](«i») : 0),
						femMesh,
						writers[«i»],
						«records.get(i).deduceDimensionality(model)»,
						«records.get(i).formatRecordModifierWithInterval»
					));
				«ENDFOR»
			}
			
			static void setupSlave(SolverT const& solver, std::vector<SlaveRecorder *> & recorders) {
				«FOR i : 0 ..< records.length»
					recorders.push_back(new SlaveRecorder_impl«i»(
						«i»,
						solver,
						«records.get(i).deduceDimensionality(model)»,
						«records.get(i).formatRecordModifierWithInterval»
					));
				«ENDFOR»
			}
		
			static void freeMaster(std::vector<FileWriter *> & writers, std::vector<MasterRecorder*> const& recorders) {
				for(auto rptr : recorders) {
					delete rptr;
				}
				for(auto wptr : writers) {
					delete wptr;
				}
			}
			
			static void freeSlave(std::vector<SlaveRecorder*> const& recorders) {
				for(auto rptr : recorders) {
					delete rptr;
				}
			}
		};
		
		#endif /* RECORDERS_HPP_ */
		
		'''
	}
	


	
	def generateInitialDataLoading(EcosystemModel model) {
		val nSpecies = model.nSpecies
		
		return '''
	/*
	 * initial_data.hpp
	 *
	 * Automatically-generated file. Do not edit!
	 */
	
	#ifndef INITIAL_DATA_HPP_
	#define INITIAL_DATA_HPP_
	
	#include "../pdedsl/sprat_pde_dsl.hpp"
	#include "model_parameters.hpp"

	
	struct InitialDataLoader {
		//DistributedVector u[SpratModelParameters::nSpecies];
		template <class VecT>
		void init(FEMMeshT const& femMesh, VecT * u) {
			foreach_omp(auto dof, DoF(femMesh), , {
				const real x = dof.positionInDimension(0);
				const real y = dof.positionInDimension(1);
				const real r = dof.positionInDimension(2);
				
				«FOR i : 0 ..< nSpecies»
					u[«i»][dof] = «model.getInitialDistribution(i).format»;
				«ENDFOR»
			})
		}
	};
	
	#endif /* INITIAL_DATA_HPP_ */
	
		'''
	}
	
	
	def generateModelParameters(EcosystemModel model) {
		val nSpecies = model.nSpecies
		
		return '''
		/*
		 * model_parameters.hpp
		 *
		 * Automatically-generated file. Do not edit!
		 */
		
		#ifndef MODEL_PARAMETERS_HPP_
		#define MODEL_PARAMETERS_HPP_
		
		#include "../pdedsl/config.hpp"
		
		struct SpratModelParameters {
			static constexpr real t_max = «model.getTMax.formatDouble»; // in s
			static constexpr real delta_t = «model.timeStep.formatDouble»; // in s
			static constexpr uint nDimensions = «model.meshFunction.meshDimension»;
			static constexpr uint nSpecies = «nSpecies»;
			«FOR a : realValuedEcosystemProperties»
				static constexpr real «a.name.toFirstLower» = «model.getEcosystemAttributeValue(a.name).formatDouble»;«IF a.unitCategory != EcosystemDescription.DIMENSIONLESS» // in «a.unitCategory.baseUnit»«ENDIF»
			«ENDFOR»
			static constexpr real inversePredatorPreyRatio = 1.0/predatorPreyRatio;
			«FOR a : realValuedSpeciesProperties»
				const real «a.name.toFirstLower»[nSpecies];
				«IF a.hasModifier»
					const real «a.name.toFirstLower»Modifier[nSpecies];
				«ENDIF»
			«ENDFOR»
		
			SpratModelParameters() :
				«FOR a : realValuedSpeciesProperties SEPARATOR ','»
					«a.name.toFirstLower»«IF a.unitCategory != EcosystemDescription.DIMENSIONLESS» // in «a.unitCategory.baseUnit»«ENDIF»
						{«FOR s : model.speciesEntities SEPARATOR ', '»«(s.getSpeciesPropertyAttribute(a.name).attribute.value as Expression).eval.formatDouble»«ENDFOR»}«IF a.hasModifier», 
		«a.name.toFirstLower»Modifier«IF a.modifierUnitCategory != EcosystemDescription.DIMENSIONLESS» // in «a.modifierUnitCategory.baseUnit»«ENDIF»
						{«FOR s : model.speciesEntities SEPARATOR ', '»«(s.getSpeciesPropertyAttribute(a.name).modifier.value as Expression).eval.formatDouble»«ENDFOR»}«ENDIF»
				«ENDFOR»
			{}
		};
		
		#endif /* MODEL_PARAMETERS_HPP_ */
		
		'''
	}
	
}
