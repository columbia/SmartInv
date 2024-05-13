1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.17;
3 
4 interface IRootChainManager {
5     /// @notice Move ether from root to child chain, accepts ether transfer
6     /// @dev Keep in mind this ether cannot be used to pay gas on child chain
7     ///      Use Matic tokens deposited using plasma mechanism for that
8     /// @param user address of account that should receive WETH on child chain
9     function depositEtherFor(address user) external payable;
10 
11     /// @notice Move tokens from root to child chain
12     /// @dev This mechanism supports arbitrary tokens as long as
13     ///      its predicate has been registered and the token is mapped
14     /// @param user address of account that should receive this deposit on child chain
15     /// @param rootToken address of token that is being deposited
16     /// @param depositData bytes data that is sent to predicate and
17     ///        child token contracts to handle deposit
18     function depositFor(
19         address user,
20         address rootToken,
21         bytes calldata depositData
22     ) external;
23 
24     /// @notice Returns child token address for root token
25     /// @param rootToken Root token address
26     /// @return childToken Child token address
27     function rootToChildToken(
28         address rootToken
29     ) external view returns (address childToken);
30 }
