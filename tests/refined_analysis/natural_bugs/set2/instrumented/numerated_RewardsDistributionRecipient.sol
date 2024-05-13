1 //SPDX-License-Identifier: MIT
2 pragma solidity 0.7.5;
3 
4 // Inheritance
5 import "./Owned.sol";
6 
7 
8 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
9 abstract contract RewardsDistributionRecipient is Owned {
10     address public rewardsDistribution;
11 
12     function notifyRewardAmount(uint256 reward) virtual external;
13 
14     modifier onlyRewardsDistribution() {
15         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
16         _;
17     }
18 
19     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
20         rewardsDistribution = _rewardsDistribution;
21     }
22 }
