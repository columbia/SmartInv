1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import {TribeRoles} from "../core/TribeRoles.sol";
5 import {CoreRef} from "../refs/CoreRef.sol";
6 import {Core} from "../core/Core.sol";
7 
8 /// @title RoleBastion
9 /// @notice Used by ROLE_ADMIN to create new roles. Granted GOVERNOR role with a simple API
10 contract RoleBastion is CoreRef {
11     event BastionRoleCreate(bytes32 indexed role, bytes32 roleAdmin);
12 
13     constructor(address _core) CoreRef(_core) {}
14 
15     /// @notice Create a role whose admin is the ROLE_ADMIN
16     /// @param role Role to be created
17     /// @dev Function is used by an address with ROLE_ADMIN, e.g. the TribalCouncil, to create
18     ///      non-major roles. A check is made to ensure that the role to be created does not
19     ///      have an admin i.e. that it is a new admin.
20     ///      Specificially, can not create the bytes32(0) role as this is set as the CONTRACT_ADMIN_ROLE
21     ///      in core and has not been created yet.
22     function createRole(bytes32 role) external onlyTribeRole(TribeRoles.ROLE_ADMIN) whenNotPaused {
23         require(role != bytes32(0), "Can not create zero role");
24 
25         bytes32 roleAdmin = core().getRoleAdmin(role);
26         require(roleAdmin == bytes32(0), "Role already exists");
27         emit BastionRoleCreate(role, TribeRoles.ROLE_ADMIN);
28         core().createRole(role, TribeRoles.ROLE_ADMIN);
29     }
30 }
