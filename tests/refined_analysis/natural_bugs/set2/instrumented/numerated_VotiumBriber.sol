1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity ^0.8.4;
3 
4 import "./IVotiumBribe.sol";
5 import "../../refs/CoreRef.sol";
6 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
7 
8 import {TribeRoles} from "../../core/TribeRoles.sol";
9 
10 /// @title VotiumBriber: implementation for a contract that can use
11 /// tokens to bribe on Votium.
12 /// @author Fei Protocol
13 contract VotiumBriber is CoreRef {
14     using SafeERC20 for IERC20;
15 
16     // ------------------ Properties -------------------------------------------
17 
18     /// @notice The Curve pool to deposit in
19     IVotiumBribe public votiumBribe;
20 
21     /// @notice The token to spend bribes in
22     IERC20 public token;
23 
24     // ------------------ Constructor ------------------------------------------
25 
26     /// @notice VotiumBriber constructor
27     /// @param _core Fei Core for reference
28     /// @param _token The token spent for bribes
29     /// @param _votiumBribe The Votium bribe contract
30     constructor(
31         address _core,
32         IERC20 _token,
33         IVotiumBribe _votiumBribe
34     ) CoreRef(_core) {
35         token = _token;
36         votiumBribe = _votiumBribe;
37     }
38 
39     /// @notice Spend tokens on Votium to bribe for a given pool.
40     /// @param _proposal id of the proposal on snapshot
41     /// @param _choiceIndex index of the pool in the snapshot vote to vote for
42     /// @dev the call will revert if Votium has not called initiateProposal with
43     /// the _proposal ID, if _choiceIndex is out of range, or of block.timestamp
44     /// is after the deadline for bribing (usually 6 hours before Convex snapshot
45     /// vote ends).
46     function bribe(bytes32 _proposal, uint256 _choiceIndex)
47         public
48         onlyTribeRole(TribeRoles.VOTIUM_ADMIN_ROLE)
49         whenNotPaused
50     {
51         // fetch the current number of TRIBE
52         uint256 tokenAmount = token.balanceOf(address(this));
53         require(tokenAmount > 0, "VotiumBriber: no tokens to bribe");
54 
55         // send TRIBE to bribe contract
56         token.approve(address(votiumBribe), tokenAmount);
57         votiumBribe.depositBribe(
58             address(token), // token
59             tokenAmount, // amount
60             _proposal, // proposal
61             _choiceIndex // choiceIndex
62         );
63     }
64 
65     /// @notice withdraw ERC20 from the contract
66     /// @param token address of the ERC20 to send
67     /// @param to address destination of the ERC20
68     /// @param amount quantity of ERC20 to send
69     function withdrawERC20(
70         address token,
71         address to,
72         uint256 amount
73     ) external onlyPCVController {
74         IERC20(token).safeTransfer(to, amount);
75     }
76 }
