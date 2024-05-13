1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.0;
3 
4 import "./MockERC20.sol";
5 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
6 
7 contract MockTokemakRewards is MockERC20 {
8     MockERC20 public rewardsToken;
9 
10     struct Recipient {
11         uint256 chainId;
12         uint256 cycle;
13         address wallet;
14         uint256 amount;
15     }
16 
17     constructor(address _rewardsToken) {
18         rewardsToken = MockERC20(_rewardsToken);
19     }
20 
21     function claim(
22         Recipient calldata recipient,
23         uint8, /* v*/
24         bytes32, /* r*/
25         bytes32 /* s*/ // bytes calldata signature
26     ) external {
27         rewardsToken.mint(recipient.wallet, recipient.amount);
28     }
29 }
