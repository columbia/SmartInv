1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.6;
3 
4 interface IConvexDeposits {
5     function deposit(uint256 _pid, uint256 _amount, bool _stake) external returns(bool);
6     function deposit(uint256 _amount, bool _lock, address _stakeAddress) external;
7 }