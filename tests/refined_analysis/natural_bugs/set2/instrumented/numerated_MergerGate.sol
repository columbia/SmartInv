1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "../dao/governor/GovernorAlpha.sol";
5 
6 /** 
7  @title Merger Gate
8  @author Joey Santoro
9  @notice a gate to make sure the FeiRari Merger proposal has executed on Rari side before executing Fei Side
10 */
11 contract MergerGate {
12     event OnePlusOneEqualsThree(string note);
13 
14     /// @notice the Rari DAO address
15     /// @dev Rari uses Governor Bravo not alpha, but the relevant interface is identical
16     GovernorAlpha public constant rgtGovernor = GovernorAlpha(0x91d9c2b5cF81D55a5f2Ecc0fC84E62f9cd2ceFd6);
17 
18     uint256 public constant PROPOSAL_NUMBER = 9;
19 
20     /// @notice ensures Rari proposal 9 has executed
21     /// @dev uses MakerDAO variable naming conventions for obvious reasons: https://github.com/makerdao/dss/issues/28
22     function floop() external {
23         require(rgtGovernor.state(PROPOSAL_NUMBER) == GovernorAlpha.ProposalState.Executed, "rip");
24         emit OnePlusOneEqualsThree("May the sun never set on the Tribe");
25     }
26 }
