1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.5.0;
4 
5 interface IBabyWonderlandMintable {
6     function mint(address to) external;
7 
8     function batchMint(address _recipient, uint256 _number) external;
9 
10     function totalSupply() external view returns (uint256);
11 }
