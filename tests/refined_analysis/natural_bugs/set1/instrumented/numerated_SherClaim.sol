1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
10 import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
11 
12 import './interfaces/ISherClaim.sol';
13 
14 /// @title Claim SHER tokens send to the contract
15 /// @author Evert Kors
16 /// @dev This contract allows users to claim their bought SHER
17 /// @dev The contract has two states seperated by the `_newEntryDeadline` timestamp (+ CLAIM_FREEZE_TIME_AFTER_DEADLINE)
18 /// @dev Up until the timestamp, to be claimed SHER can be added using `add()`
19 /// @dev After and including the timestamp, SHER can be claimed using `claim())`
20 contract SherClaim is ISherClaim {
21   using SafeERC20 for IERC20;
22 
23   // The state switch needs to be executed between BOTTOM and CEILING after deployment
24   uint256 internal constant CLAIM_PERIOD_SANITY_BOTTOM = 7 days;
25   uint256 internal constant CLAIM_PERIOD_SANITY_CEILING = 14 days;
26   uint256 internal constant CLAIM_FREEZE_TIME_AFTER_DEADLINE = 26 weeks;
27 
28   // Timestamp up until new SHER entries can be added
29   uint256 public immutable override newEntryDeadline;
30 
31   // SHER token address (18 decimals)
32   IERC20 public immutable sher;
33 
34   // Mapping how much each user is able to claim
35   mapping(address => uint256) public userClaims;
36 
37   /// @notice Construct claim contract
38   /// @param _sher ERC20 contract for SHER token
39   /// @param _newEntryDeadline Timestamp up until SHER entries can be added
40   /// @dev _newEntryDeadline is between BOTTOM and CEILING after deployment
41   constructor(IERC20 _sher, uint256 _newEntryDeadline) {
42     if (address(_sher) == address(0)) revert ZeroArgument();
43     // Verify if _newEntryDeadline has a valid value
44     if (_newEntryDeadline < block.timestamp + CLAIM_PERIOD_SANITY_BOTTOM) revert InvalidState();
45     if (_newEntryDeadline > block.timestamp + CLAIM_PERIOD_SANITY_CEILING) revert InvalidState();
46 
47     sher = _sher;
48     newEntryDeadline = _newEntryDeadline;
49   }
50 
51   /// @notice Add `_amount` SHER to the timelock for `_user`
52   /// @param _user The account that is able to claim the SHER
53   /// @param _amount The amount of SHER that is added to the timelock
54   function add(address _user, uint256 _amount) external override {
55     if (_user == address(0)) revert ZeroArgument();
56     if (_amount == 0) revert ZeroArgument();
57     // Only allow new SHER to be added pre newEntryDeadline
58     if (block.timestamp >= newEntryDeadline) revert InvalidState();
59 
60     // Transfer SHER from caller to this contract
61     sher.safeTransferFrom(msg.sender, address(this), _amount);
62     // Account how much SHER the `_user` is able to claim
63     userClaims[_user] += _amount;
64 
65     // Emit event about the new SHER tokens
66     emit Add(msg.sender, _user, _amount);
67   }
68 
69   /// @notice Allow caller to claim SHER tokens
70   /// @dev Every account is able to call this once
71   /// @dev Will revert in case the amount is 0
72   /// @dev SHER tokens will be sent to caller
73   function claim() external {
74     // Only allow claim calls if claim period is active
75     if (block.timestamp < newEntryDeadline + CLAIM_FREEZE_TIME_AFTER_DEADLINE) {
76       revert InvalidState();
77     }
78 
79     // How much SHER the user will receive
80     uint256 amount = userClaims[msg.sender];
81     // Dont proceed if it's 0 SHER
82     if (amount == 0) revert InvalidAmount();
83     // If it is not 0, make sure it's 0 next time the user calls this function
84     delete userClaims[msg.sender];
85 
86     // Transfer SHER to user
87     sher.safeTransfer(msg.sender, amount);
88 
89     // Emit event about the SHER claim
90     emit Claim(msg.sender, amount);
91   }
92 }
