1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 
4 interface IMasterChef {
5     function cakePerBlock() view external returns(uint);
6     function totalAllocPoint() view external returns(uint);
7 
8     function poolInfo(uint _pid) view external returns(address lpToken, uint allocPoint, uint lastRewardBlock, uint accCakePerShare);
9     function userInfo(uint _pid, address _account) view external returns(uint amount, uint rewardDebt);
10     function poolLength() view external returns(uint);
11 
12     function deposit(uint256 _pid, uint256 _amount) external;
13     function withdraw(uint256 _pid, uint256 _amount) external;
14     function emergencyWithdraw(uint256 _pid) external;
15 
16     function enterStaking(uint256 _amount) external;
17     function leaveStaking(uint256 _amount) external;
18 }
