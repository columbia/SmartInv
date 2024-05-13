1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.7.4;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";
7 import "../token/VBabyToken.sol";
8 import "hardhat/console.sol";
9 
10 contract vBabyNFTFee is Ownable, ReentrancyGuard {
11     using SafeERC20 for IERC20;
12 
13     IERC20 public immutable baby;
14     vBABYToken public immutable vBaby;
15     uint256 public totalSupply;
16 
17     event ExecteEvent(uint256 value);
18 
19     constructor(IERC20 baby_, vBABYToken vBaby_) {
20         baby = baby_;
21         vBaby = vBaby_;
22     }
23 
24     function execteDonate() external nonReentrant {
25         uint256 babyBalance = baby.balanceOf(address(this));
26         baby.approve(address(vBaby), babyBalance);
27         vBaby.donate(babyBalance);
28         totalSupply = totalSupply + babyBalance;
29 
30         emit ExecteEvent(babyBalance);
31     }
32 }
