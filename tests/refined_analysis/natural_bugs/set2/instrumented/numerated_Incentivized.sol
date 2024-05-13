1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "../refs/CoreRef.sol";
5 
6 /// @title abstract contract for incentivizing keepers
7 /// @author Fei Protocol
8 abstract contract Incentivized is CoreRef {
9     /// @notice FEI incentive for calling keeper functions
10     uint256 public incentiveAmount;
11 
12     event IncentiveUpdate(uint256 oldIncentiveAmount, uint256 newIncentiveAmount);
13 
14     constructor(uint256 _incentiveAmount) {
15         incentiveAmount = _incentiveAmount;
16         emit IncentiveUpdate(0, _incentiveAmount);
17     }
18 
19     /// @notice set the incentiveAmount
20     function setIncentiveAmount(uint256 newIncentiveAmount) public onlyGovernor {
21         uint256 oldIncentiveAmount = incentiveAmount;
22         incentiveAmount = newIncentiveAmount;
23         emit IncentiveUpdate(oldIncentiveAmount, newIncentiveAmount);
24     }
25 
26     /// @notice incentivize a call with incentiveAmount FEI rewards
27     /// @dev no-op if the contract does not have Minter role
28     function _incentivize() internal ifMinterSelf {
29         _mintFei(msg.sender, incentiveAmount);
30     }
31 }
