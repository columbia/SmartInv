1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 interface ISwapReceiver {
5     function swapMint(address _holder, uint256 _amount) external;
6 }
