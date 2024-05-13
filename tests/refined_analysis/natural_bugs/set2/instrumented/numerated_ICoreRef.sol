1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../core/ICore.sol";
5 
6 /// @title CoreRef interface
7 /// @author Fei Protocol
8 interface ICoreRef {
9     // ----------- Events -----------
10 
11     event CoreUpdate(address indexed oldCore, address indexed newCore);
12 
13     event ContractAdminRoleUpdate(bytes32 indexed oldContractAdminRole, bytes32 indexed newContractAdminRole);
14 
15     // ----------- Governor only state changing api -----------
16 
17     function setContractAdminRole(bytes32 newContractAdminRole) external;
18 
19     // ----------- Governor or Guardian only state changing api -----------
20 
21     function pause() external;
22 
23     function unpause() external;
24 
25     // ----------- Getters -----------
26 
27     function core() external view returns (ICore);
28 
29     function fei() external view returns (IFei);
30 
31     function tribe() external view returns (IERC20);
32 
33     function feiBalance() external view returns (uint256);
34 
35     function tribeBalance() external view returns (uint256);
36 
37     function CONTRACT_ADMIN_ROLE() external view returns (bytes32);
38 
39     function isContractAdmin(address admin) external view returns (bool);
40 }
