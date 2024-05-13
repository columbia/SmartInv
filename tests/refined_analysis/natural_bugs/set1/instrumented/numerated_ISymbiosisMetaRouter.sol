1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ISymbiosisMetaRouter {
5     /// @notice entry point data to Symbiosis contracts
6     /// @param firstSwapCalldata calldata for the dex swap to get corresponding asset (USDC) on init chain
7     /// @param secondSwapCalldata legacy calldata from v1, should be empty
8     /// @param approvedTokens set of token for firstSwapCalldata, and o bridgingCalldata
9     /// @param firstDexRouter entry point for firstSwapCalldata
10     /// @param secondDexRouter legacy entry point from v1, should be empty
11     /// @param amount of tokens
12     /// @param nativeIn native token in amount or not
13     /// @param relayRecipient entry point to bridge provided from API
14     /// @param otherSideCalldata bridging calldata
15     struct MetaRouteTransaction {
16         bytes firstSwapCalldata;
17         bytes secondSwapCalldata;
18         address[] approvedTokens;
19         address firstDexRouter;
20         address secondDexRouter;
21         uint256 amount;
22         bool nativeIn;
23         address relayRecipient;
24         bytes otherSideCalldata;
25     }
26 
27     /**
28      * @notice Method that starts the Meta Routing in Symbiosis
29      * @param _metarouteTransaction metaRoute offchain transaction data
30      */
31     function metaRoute(
32         MetaRouteTransaction calldata _metarouteTransaction
33     ) external payable;
34 }
