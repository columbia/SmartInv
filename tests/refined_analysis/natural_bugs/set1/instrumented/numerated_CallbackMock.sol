1 // SPDX-License-Identifier: GPL-2.0-or-later
2 pragma solidity 0.8.10;
3 
4 /******************************************************************************\
5 * Author: Evert Kors <dev@sherlock.xyz> (https://twitter.com/evert0x)
6 * Sherlock Protocol: https://sherlock.xyz
7 /******************************************************************************/
8 
9 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
10 import '../interfaces/managers/callbacks/ISherlockClaimManagerCallbackReceiver.sol';
11 
12 contract CallbackMock is ISherlockClaimManagerCallbackReceiver {
13   IERC20 constant TOKEN = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
14 
15   function PreCorePayoutCallback(
16     bytes32 _protocol,
17     uint256 _claimID,
18     uint256 _amount
19   ) external override {
20     TOKEN.transfer(msg.sender, TOKEN.balanceOf(address(this)));
21   }
22 }
