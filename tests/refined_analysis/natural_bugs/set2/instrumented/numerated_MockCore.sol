1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./../core/Permissions.sol";
5 import "../fei/Fei.sol";
6 import "../tribe/Tribe.sol";
7 
8 /// @title Mock Source of truth for Fei Protocol
9 /// @author Fei Protocol
10 /// @notice maintains roles, access control, fei, tribe, genesisGroup, and the TRIBE treasury
11 contract MockCore is Permissions {
12     /// @notice the address of the FEI contract
13     IFei public fei;
14 
15     /// @notice the address of the TRIBE contract
16     IFei public tribe;
17 
18     /// @notice tracks whether the contract has been initialized
19     bool private _initialized;
20 
21     constructor() {
22         require(!_initialized, "initialized");
23         _initialized = true;
24 
25         uint256 id;
26         assembly {
27             id := chainid()
28         }
29         require(id != 1, "cannot deploy mock on mainnet");
30         _setupGovernor(msg.sender);
31 
32         Fei _fei = new Fei(address(this));
33         fei = IFei(_fei);
34 
35         Tribe _tribe = new Tribe(msg.sender, msg.sender);
36         tribe = IFei(address(_tribe));
37     }
38 }
