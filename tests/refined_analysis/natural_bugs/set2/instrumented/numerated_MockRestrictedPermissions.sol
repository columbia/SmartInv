1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../core/RestrictedPermissions.sol";
5 
6 contract MockRestrictedPermissions is RestrictedPermissions {
7     address public fei;
8     address public tribe;
9     bytes32 public constant GOVERN_ROLE = keccak256("GOVERN_ROLE");
10 
11     constructor(
12         IPermissionsRead core,
13         address _fei,
14         address _tribe
15     ) RestrictedPermissions(core) {
16         fei = _fei;
17         tribe = _tribe;
18     }
19 }
