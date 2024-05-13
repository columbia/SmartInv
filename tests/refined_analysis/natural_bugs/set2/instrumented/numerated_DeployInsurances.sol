1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 import {IConvenience} from '../interfaces/IConvenience.sol';
5 import {IPair} from '@timeswap-labs/timeswap-v1-core/contracts/interfaces/IPair.sol';
6 import {InsuranceInterest} from '../InsuranceInterest.sol';
7 import {InsurancePrincipal} from '../InsurancePrincipal.sol';
8 
9 library DeployInsurances {
10     function deployInsurances(
11         IConvenience.Native storage native,
12         bytes32 salt,
13         IConvenience convenience,
14         IPair pair,
15         uint256 maturity
16     ) external {
17         
18         native.insuranceInterest = new InsuranceInterest{salt: salt}(convenience, pair, maturity);
19         native.insurancePrincipal = new InsurancePrincipal{salt: salt}(convenience, pair, maturity);
20     }
21 }
