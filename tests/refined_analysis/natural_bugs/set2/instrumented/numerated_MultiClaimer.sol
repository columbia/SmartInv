1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____     _ _   _ _____ _     _               
18 // |     |_ _| | |_|_|     | |___|_|_____ ___ ___ 
19 // | | | | | | |  _| |   --| | .'| |     | -_|  _|
20 // |_|_|_|___|_|_| |_|_____|_|__,|_|_|_|_|___|_|  
21 
22 // Github - https://github.com/FortressFinance
23 
24 import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
25 import {IFortressConcentrator} from "src/shared/fortress-interfaces/IFortressConcentrator.sol";
26 
27 contract MultiClaimer is ReentrancyGuard {
28 
29     /// @dev Claim rewards from multiple Concentrator vaults
30     /// @param _vaults Array of Concentrator vaults
31     /// @param _receiver Address to receive rewards
32     /// @return _rewards Total rewards claimed
33     function multiClaim(address[] memory _vaults, address _receiver) external nonReentrant returns (uint256 _rewards) {
34         for (uint256 i = 0; i < _vaults.length; i++) {
35             _rewards += IFortressConcentrator(_vaults[i]).claim(msg.sender, _receiver);
36         }
37     }
38 }