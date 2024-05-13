1 //SPDX-License-Identifier: Unlicense
2 
3 pragma solidity 0.6.12;
4 
5 // Unifying the interface with the Synthetix Reward Pool
6 interface IRewardPool {
7   function rewardToken() external view returns (address);
8   function lpToken() external view returns (address);
9   function duration() external view returns (uint256);
10 
11   function periodFinish() external view returns (uint256);
12   function rewardRate() external view returns (uint256);
13   function rewardPerTokenStored() external view returns (uint256);
14 
15   function stake(uint256 amountWei) external;
16 
17   // `balanceOf` would give the amount staked.
18   // As this is 1 to 1, this is also the holder's share
19   function balanceOf(address holder) external view returns (uint256);
20   // total shares & total lpTokens staked
21   function totalSupply() external view returns(uint256);
22 
23   function withdraw(uint256 amountWei) external;
24   function exit() external;
25 
26   // get claimed rewards
27   function earned(address holder) external view returns (uint256);
28 
29   // claim rewards
30   function getReward() external;
31 
32   // notify
33   function notifyRewardAmount(uint256 _amount) external;
34 }
