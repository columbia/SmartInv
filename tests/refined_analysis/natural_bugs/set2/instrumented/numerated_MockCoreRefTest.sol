1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 
6 contract MockCoreRefTest is CoreRef {
7     constructor(address core) CoreRef(core) {
8         _setContractAdminRole(keccak256("MOCK_CORE_REF_ADMIN"));
9     }
10 
11     function governorOrGuardianTest() external hasAnyOfTwoRoles(keccak256("GOVERN_ROLE"), keccak256("GUARDIAN_ROLE")) {}
12 }
