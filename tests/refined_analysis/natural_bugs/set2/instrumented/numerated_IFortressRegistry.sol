1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.17;
3 
4 import "src/shared/interfaces/ERC20.sol";
5 import "src/mainnet/compounders/curve/CurveCompounder.sol";
6 import "src/mainnet/compounders/balancer/BalancerCompounder.sol";
7 
8 interface IFortressRegistry {
9 
10     function registerCurveCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) external;
11 
12     function registerBalancerCompounder(address _compounder, address _asset, string memory _symbol, string memory _name, address[] memory _underlyingAssets) external;
13 
14 }