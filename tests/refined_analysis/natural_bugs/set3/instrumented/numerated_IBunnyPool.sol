1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.12;
3 pragma experimental ABIEncoderV2;
4 
5 interface IBunnyPool {
6 
7     function balanceOf(address account) external view returns (uint);
8     function earned(address account) external view returns (uint[] memory);
9     function rewardTokens() external view returns (address [] memory);
10 
11     function deposit(uint _amount) external;
12     function withdraw(uint _amount) external;
13     function withdrawAll() external;
14     function getReward() external;
15 
16     function depositOnBehalf(uint _amount, address _to) external;
17     function notifyRewardAmounts(uint[] memory amounts) external;
18 }