1 // SPDX-License-Identifier: GNU-GPL v3.0 or later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../interfaces/IAddressRegistry.sol";
6 import "@openzeppelin/contracts/access/Ownable.sol";
7 import "../interfaces/ILockManager.sol";
8 import "../interfaces/ITokenVault.sol";
9 import "../lib/uniswap/IUniswapV2Factory.sol";
10 
11 interface IRegistryProvider {
12     function setAddressRegistry(address revest) external;
13 
14     function getAddressRegistry() external view returns (address);
15 }
