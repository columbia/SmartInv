1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 /// @title Sherlock interface for payout manager
10 /// @author Evert Kors
11 interface ISherlockPayout {
12   /// @notice Initiate a payout of `_amount` to `_receiver`
13   /// @param _receiver Receiver of payout
14   /// @param _amount Amount to send
15   /// @dev only payout manager should call this
16   /// @dev should pull money out of strategy
17   function payoutClaim(address _receiver, uint256 _amount) external;
18 }
