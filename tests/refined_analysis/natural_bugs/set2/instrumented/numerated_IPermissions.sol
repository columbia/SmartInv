1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "@openzeppelin/contracts/access/AccessControl.sol";
5 import "./IPermissionsRead.sol";
6 
7 /// @title Permissions interface
8 /// @author Fei Protocol
9 interface IPermissions is IAccessControl, IPermissionsRead {
10     // ----------- Governor only state changing api -----------
11 
12     function createRole(bytes32 role, bytes32 adminRole) external;
13 
14     function grantMinter(address minter) external;
15 
16     function grantBurner(address burner) external;
17 
18     function grantPCVController(address pcvController) external;
19 
20     function grantGovernor(address governor) external;
21 
22     function grantGuardian(address guardian) external;
23 
24     function revokeMinter(address minter) external;
25 
26     function revokeBurner(address burner) external;
27 
28     function revokePCVController(address pcvController) external;
29 
30     function revokeGovernor(address governor) external;
31 
32     function revokeGuardian(address guardian) external;
33 
34     // ----------- Revoker only state changing api -----------
35 
36     function revokeOverride(bytes32 role, address account) external;
37 
38     // ----------- Getters -----------
39 
40     function GUARDIAN_ROLE() external view returns (bytes32);
41 
42     function GOVERN_ROLE() external view returns (bytes32);
43 
44     function BURNER_ROLE() external view returns (bytes32);
45 
46     function MINTER_ROLE() external view returns (bytes32);
47 
48     function PCV_CONTROLLER_ROLE() external view returns (bytes32);
49 }
