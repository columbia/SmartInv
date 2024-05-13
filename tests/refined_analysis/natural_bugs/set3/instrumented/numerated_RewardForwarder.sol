1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.17;
4 
5 import "@openzeppelin/contracts-4.7.3/token/ERC20/utils/SafeERC20.sol";
6 
7 /// @notice interface compatible with LiquidityGaugeV5 or ChildGauge
8 interface IGauge {
9     function deposit_reward_token(address _reward_token, uint256 amount)
10         external; // nonpayable
11 }
12 
13 /// @title RewardForwarder contract for gauges
14 /// @notice RewardForwarder is responsible for forwarding rewards to gauges
15 /// in permissionlessly manner
16 contract RewardForwarder {
17     using SafeERC20 for IERC20;
18 
19     // address of the associated gauge
20     address immutable GAUGE;
21 
22     /// @notice RewardForwarder constructor. Sets the gauge address.
23     /// @param _gauge address of the associated gauge
24     constructor(address _gauge) {
25         GAUGE = _gauge;
26     }
27 
28     /// @notice Deposit the reward token in this contract to the gauge
29     /// @dev Upon calling this function, the reward token will be
30     /// transferred from this contract to the gauge.
31     /// @param _rewardToken address of the reward token to deposit
32     function depositRewardToken(address _rewardToken) external {
33         IGauge(GAUGE).deposit_reward_token(
34             _rewardToken,
35             IERC20(_rewardToken).balanceOf(address(this))
36         );
37     }
38 
39     /// @notice Allow the gauge to use the reward token in this contract
40     /// @dev This must be called before `depositRewardToken` can be called successfully
41     /// @param _rewardToken address of the reward token to deposit
42     function allow(address _rewardToken) external {
43         IERC20(_rewardToken).safeApprove(GAUGE, 0);
44         IERC20(_rewardToken).safeApprove(GAUGE, type(uint256).max);
45     }
46 
47     /// @notice Read the associated gauge address
48     /// @return gauge address
49     function gauge() external view returns (address) {
50         return (GAUGE);
51     }
52 }
