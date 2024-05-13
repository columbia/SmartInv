1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 
6 contract MockCoreRef is CoreRef {
7     constructor(address core) CoreRef(core) {
8         _setContractAdminRole(keccak256("MOCK_CORE_REF_ADMIN"));
9     }
10 
11     function testMinter() public view onlyMinter {}
12 
13     function testBurner() public view onlyBurner {}
14 
15     function testPCVController() public view onlyPCVController {}
16 
17     function testGovernor() public view onlyGovernor {}
18 
19     function testGuardian() public view onlyGuardianOrGovernor {}
20 
21     function testOnlyGovernorOrAdmin() public view onlyGovernorOrAdmin {}
22 }
