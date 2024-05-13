1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./ICore.sol";
5 
6 /// @title [OLD] Core V1 Interface
7 /// @author Fei Protocol
8 interface ICoreV1 is ICore {
9     // ----------- Governor only state changing api -----------
10 
11     function setGenesisGroup(address token) external;
12 
13     // ----------- Read-only api -----------
14     function genesisGroup() external view returns (address);
15 }
