1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity 0.8.17;
3 
4 interface IERC20 {
5     function transfer(address,uint) external returns (bool);
6 }
7 
8 contract Faucet {
9     address private constant INU = 0x67372e5b5279044E188E1a25cA95975BB9b7a0e8;
10 
11     uint last;
12 
13     function drip() external {
14         require(block.timestamp - last > 4 hours, 'wait');
15         require(msg.sender == tx.origin, 'contract');
16         last = block.timestamp;
17         IERC20(INU).transfer(msg.sender, 1e17);
18     }
19 }