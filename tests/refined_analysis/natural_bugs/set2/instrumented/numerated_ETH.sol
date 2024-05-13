1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 library ETH {
5     function transfer(address payable to, uint256 amount) internal {
6         (bool success, ) = to.call{value: amount}('');
7         require(success, 'E521');
8     }
9 }
