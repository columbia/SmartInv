1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface IOmniBridge {
5     /// @dev Initiate the bridge operation for some amount of tokens from msg.sender.
6     /// @param token bridged token contract address.
7     /// @param receiver Receiver address
8     /// @param amount Dai amount
9     function relayTokens(
10         address token,
11         address receiver,
12         uint256 amount
13     ) external;
14 
15     /// @dev Wraps native assets and relays wrapped ERC20 tokens to the other chain.
16     /// @param receiver Bridged assets receiver on the other side of the bridge.
17     function wrapAndRelayTokens(address receiver) external payable;
18 }
