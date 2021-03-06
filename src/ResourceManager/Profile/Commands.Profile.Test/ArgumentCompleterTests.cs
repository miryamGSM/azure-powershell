﻿// ----------------------------------------------------------------------------------
//
// Copyright Microsoft Corporation
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// ----------------------------------------------------------------------------------

using Microsoft.Azure.Commands.ResourceManager.Common;
using Microsoft.Azure.Commands.Resources.Test.ScenarioTests;
using Microsoft.Azure.Commands.ScenarioTest;
using Microsoft.Azure.ServiceManagement.Common.Models;
using Microsoft.WindowsAzure.Commands.ScenarioTest;
using Microsoft.WindowsAzure.Commands.Test.Utilities.Common;
using Xunit;
using Xunit.Abstractions;

namespace Microsoft.Azure.Commands.Profile.Test
{
    public class ArgumentCompleterTests : RMTestBase
    {
        private XunitTracingInterceptor xunitLogger;

        public ArgumentCompleterTests(ITestOutputHelper output)
        {
            TestExecutionHelpers.SetUpSessionAndProfile();
            ResourceManagerProfileProvider.InitializeResourceManagerProfile(true);

            xunitLogger = new XunitTracingInterceptor(output);
        }

        [Fact(Skip = "Failure needs investigated. Not returning list of locations.")]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestLocationCompleter()
        {
            ProfileController.NewInstance.RunPsTest(xunitLogger, "72f988bf-86f1-41af-91ab-2d7cd011db47", "Test-LocationCompleter");
        }

        [Fact(Skip = "Failure needs investigated. Cannot bind argument to parameter 'DifferenceObject' because it is null.")]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestResourceGroupCompleter()
        {
            ProfileController.NewInstance.RunPsTest(xunitLogger, "72f988bf-86f1-41af-91ab-2d7cd011db47", "Test-ResourceGroupCompleter");
        }

        [Fact(Skip = "AzureRM.Resources.ps1 needs Get-AzureRmResource to be implemented")]
        [Trait(Category.AcceptanceType, Category.CheckIn)]
        public void TestResourceIdCompleter()
        {
            ProfileController.NewInstance.RunPsTest(xunitLogger, "72f988bf-86f1-41af-91ab-2d7cd011db47", "Test-ResourceIdCompleter");
        }
    }
}