1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 interface IVotiumBribe {
5     // Deposit bribe
6     function depositBribe(
7         address _token,
8         uint256 _amount,
9         bytes32 _proposal,
10         uint256 _choiceIndex
11     ) external;
12 
13     // admin function
14     function initiateProposal(
15         bytes32 _proposal,
16         uint256 _deadline,
17         uint256 _maxIndex
18     ) external;
19 }
