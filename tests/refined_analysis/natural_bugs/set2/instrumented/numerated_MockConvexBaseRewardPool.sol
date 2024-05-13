1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockConvexBaseRewardPool is MockERC20 {
7     uint256 public pid = 42;
8     uint256 public rewardAmountPerClaim = 0;
9     MockERC20 public rewardToken;
10     MockERC20 public lpTokens;
11     mapping(address => uint256) private _balances;
12 
13     constructor(address _rewardToken, address _lpTokens) {
14         rewardToken = MockERC20(_rewardToken);
15         lpTokens = MockERC20(_lpTokens);
16     }
17 
18     function mockSetRewardAmountPerClaim(uint256 _rewardAmountPerClaim) public {
19         rewardAmountPerClaim = _rewardAmountPerClaim;
20     }
21 
22     function withdrawAndUnwrap(uint256 amount, bool claim) public returns (bool) {
23         lpTokens.transfer(msg.sender, amount);
24         getReward(msg.sender, claim);
25         return true;
26     }
27 
28     function withdrawAllAndUnwrap(bool claim) public {
29         uint256 _balance = lpTokens.balanceOf(address(this));
30         lpTokens.transfer(msg.sender, _balance);
31         getReward(msg.sender, claim);
32     }
33 
34     function getReward(
35         address who,
36         bool /* claim*/
37     ) public returns (bool) {
38         if (rewardAmountPerClaim > 0) {
39             rewardToken.mint(who, rewardAmountPerClaim);
40         }
41         return true;
42     }
43 
44     function stakeFor(address who, uint256 amount) public returns (bool) {
45         _balances[who] = amount;
46         return true;
47     }
48 
49     function balanceOf(address who) public view override returns (uint256) {
50         return _balances[who];
51     }
52 }
