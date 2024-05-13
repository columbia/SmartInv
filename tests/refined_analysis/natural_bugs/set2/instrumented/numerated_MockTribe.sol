1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./MockERC20.sol";
5 
6 contract MockTribe is MockERC20 {
7     mapping(address => address) public delegates;
8 
9     // note : this is a naive implementation for mocking, it allows a token
10     //        owner to double delegate.
11     function delegate(address account) external {
12         delegates[account] = msg.sender;
13     }
14 
15     function getCurrentVotes(address account) external view returns (uint256) {
16         uint256 votes = balanceOf(account);
17         if (delegates[account] != address(0)) {
18             votes = votes + balanceOf(delegates[account]);
19         }
20         return votes;
21     }
22 }
