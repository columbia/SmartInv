1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 /// @title Sherlock core interface for stakers
10 /// @author Evert Kors
11 interface ISherlockStake {
12   /// @notice View the current lockup end timestamp of `_tokenID`
13   /// @return Timestamp when NFT position unlocks
14   function lockupEnd(uint256 _tokenID) external view returns (uint256);
15 
16   /// @notice View the current SHER reward of `_tokenID`
17   /// @return Amount of SHER rewarded to owner upon reaching the end of the lockup
18   function sherRewards(uint256 _tokenID) external view returns (uint256);
19 
20   /// @notice View the current token balance claimable upon reaching end of the lockup
21   /// @return Amount of tokens assigned to owner when unstaking position
22   function tokenBalanceOf(uint256 _tokenID) external view returns (uint256);
23 
24   /// @notice View the current TVL for all stakers
25   /// @return Total amount of tokens staked
26   /// @dev Adds principal + strategy + premiums
27   /// @dev Will calculate the most up to date value for each piece
28   function totalTokenBalanceStakers() external view returns (uint256);
29 
30   /// @notice Stakes `_amount` of tokens and locks up for `_period` seconds, `_receiver` will receive the NFT receipt
31   /// @param _amount Amount of tokens to stake
32   /// @param _period Period of time, in seconds, to lockup your funds
33   /// @param _receiver Address that will receive the NFT representing the position
34   /// @return _id ID of the position
35   /// @return _sher Amount of SHER tokens to be released to this ID after `_period` ends
36   /// @dev `_period` needs to be whitelisted
37   function initialStake(
38     uint256 _amount,
39     uint256 _period,
40     address _receiver
41   ) external returns (uint256 _id, uint256 _sher);
42 
43   /// @notice Redeem NFT `_id` and receive `_amount` of tokens
44   /// @param _id TokenID of the position
45   /// @return _amount Amount of tokens (USDC) owed to NFT ID
46   /// @dev Only the owner of `_id` will be able to redeem their position
47   /// @dev The SHER rewards are sent to the NFT owner
48   /// @dev Can only be called after lockup `_period` has ended
49   function redeemNFT(uint256 _id) external returns (uint256 _amount);
50 
51   /// @notice Owner restakes position with ID: `_id` for `_period` seconds
52   /// @param _id ID of the position
53   /// @param _period Period of time, in seconds, to lockup your funds
54   /// @return _sher Amount of SHER tokens to be released to owner address after `_period` ends
55   /// @dev Only the owner of `_id` will be able to restake their position using this call
56   /// @dev `_period` needs to be whitelisted
57   /// @dev Can only be called after lockup `_period` has ended
58   function ownerRestake(uint256 _id, uint256 _period) external returns (uint256 _sher);
59 
60   /// @notice Allows someone who doesn't own the position (an arbitrager) to restake the position for 26 weeks (ARB_RESTAKE_PERIOD)
61   /// @param _id ID of the position
62   /// @return _sher Amount of SHER tokens to be released to position owner on expiry of the 26 weeks lockup
63   /// @return _arbReward Amount of tokens (USDC) sent to caller (the arbitrager) in return for calling the function
64   /// @dev Can only be called after lockup `_period` is more than 2 weeks in the past (assuming ARB_RESTAKE_WAIT_TIME is 2 weeks)
65   /// @dev Max 20% (ARB_RESTAKE_MAX_PERCENTAGE) of tokens associated with a position are used to incentivize arbs (x)
66   /// @dev During a 2 week period the reward ratio will move from 0% to 100% (* x)
67   function arbRestake(uint256 _id) external returns (uint256 _sher, uint256 _arbReward);
68 }
