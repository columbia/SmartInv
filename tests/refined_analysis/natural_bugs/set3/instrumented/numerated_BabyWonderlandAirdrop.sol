1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.4;
4 pragma experimental ABIEncoderV2;
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/math/SafeMath.sol";
7 import "../interfaces/IBabyWonderlandMintable.sol";
8 
9 contract BabyWonderlandAirdrop is Ownable {
10     using SafeMath for uint256;
11     
12     IBabyWonderlandMintable public rewardToken;
13 
14     uint256 public remaining;
15 
16     mapping(address => uint256) public rewardList;
17     mapping(address => uint256) public claimedNumber;
18 
19     struct RewardConfig {
20         address account;
21         uint256 number;
22     }
23     event SetRewardList(address account, uint256 number);
24     event Claimed(address account, uint256 number);
25 
26     constructor(IBabyWonderlandMintable _rewardToken) {
27         require(address(_rewardToken) != address(0), "rewardToken is zero");
28         rewardToken = _rewardToken;
29         remaining = 2000;
30     }
31 
32     function setRewardList(RewardConfig[] calldata list) external onlyOwner {
33         for (uint256 i = 0; i != list.length; i++) {
34             RewardConfig memory config = list[i];
35             rewardList[config.account] = config.number;
36 
37             emit SetRewardList(config.account, config.number);
38         }
39     }
40 
41     function claim() external {
42         if (rewardList[msg.sender] > claimedNumber[msg.sender]) {
43             uint256 number = rewardList[msg.sender].sub(
44                 claimedNumber[msg.sender]
45             );
46             remaining = remaining.sub(number, "insufficient supply");
47             claimedNumber[msg.sender] = rewardList[msg.sender];
48             rewardToken.batchMint(msg.sender, number);
49             emit Claimed(msg.sender, number);
50         }
51     }
52 }
