1 //SPDX-License-Identifier: Unlicense
2 pragma solidity 0.7.3;
3 
4 interface IStrat {
5     function invest() external; // underlying amount must be sent from vault to strat address before
6     function divest(uint amount) external; // should send requested amount to vault directly, not less or more
7     function calcTotalValue() external returns (uint);
8 }