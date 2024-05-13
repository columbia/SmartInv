1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '../managers/Manager.sol';
10 import '../interfaces/managers/ISherDistributionManager.sol';
11 
12 contract SherDistributionMock is ISherDistributionManager, Manager {
13   uint256 reward;
14   IERC20 token;
15   IERC20 sher;
16 
17   uint256 public lastAmount;
18   uint256 public lastPeriod;
19   uint256 public value;
20 
21   bool public revertReward;
22 
23   constructor(IERC20 _token, IERC20 _sher) {
24     token = _token;
25     sher = _sher;
26 
27     value = type(uint256).max;
28   }
29 
30   function setReward(uint256 _reward) external {
31     reward = _reward;
32   }
33 
34   function setRewardRevert(bool _revert) external {
35     revertReward = _revert;
36   }
37 
38   function setCustomRewardReturnValue(uint256 _value) external {
39     value = _value;
40   }
41 
42   function pullReward(
43     uint256 _amount,
44     uint256 _period,
45     uint256 _id,
46     address _receiver
47   ) external override returns (uint256 _sher) {
48     require(_amount != 0, 'ZERO');
49     require(!revertReward, 'REV');
50     _sher = reward;
51     sher.transfer(msg.sender, reward);
52 
53     lastAmount = _amount;
54     lastPeriod = _period;
55 
56     if (value != type(uint256).max) _sher = value;
57   }
58 
59   function calcReward(
60     uint256 _tvl,
61     uint256 _amount,
62     uint256 _period
63   ) external view override returns (uint256 _sher) {}
64 
65   function isActive() external view override returns (bool) {}
66 }
