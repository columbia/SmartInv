1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IGlpMinter {
5 
6     function mintAndStakeGlp(address _token, uint256 _amount, uint256 _minUsdg, uint256 _minGlp) external returns (uint256);
7 
8     function unstakeAndRedeemGlp(address _tokenOut, uint256 _glpAmount, uint256 _minOut, address _receiver) external returns (uint256);
9 
10     function unstakeAndRedeemGlpETH(uint256 _glpAmount, uint256 _minOut, address payable _receiver) external returns (uint256);
11 }