1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IXDaiBridge {
5     /// @notice Bridge Dai to xDai and sends to receiver
6     /// @dev It's implemented in xDaiBridge on only Ethereum
7     /// @param receiver Receiver address
8     /// @param amount Dai amount
9     function relayTokens(address receiver, uint256 amount) external;
10 }
