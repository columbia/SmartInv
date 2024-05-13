1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IXDaiBridgeL2 {
5     /// @notice Bridge xDai to DAI and sends to receiver
6     /// @dev It's implemented in xDaiBridge on only Gnosis
7     /// @param receiver Receiver address
8     function relayTokens(address receiver) external payable;
9 }
