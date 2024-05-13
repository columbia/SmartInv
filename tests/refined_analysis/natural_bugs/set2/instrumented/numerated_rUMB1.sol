1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 import "./interfaces/rUMB.sol";
5 
6 contract rUMB1 is rUMB {
7      constructor (
8         address _owner,
9         address _initialHolder,
10         uint256 _initialBalance,
11         uint256 _maxAllowedTotalSupply,
12         uint256 _swapDuration,
13         string memory _name,
14         string memory _symbol
15     )
16     rUMB(_owner, _initialHolder, _initialBalance, _maxAllowedTotalSupply, _swapDuration, _name, _symbol) {
17     }
18 }
