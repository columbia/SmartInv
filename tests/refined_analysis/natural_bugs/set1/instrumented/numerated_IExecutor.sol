1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { LibSwap } from "../Libraries/LibSwap.sol";
5 
6 /// @title Interface for Executor
7 /// @author LI.FI (https://li.fi)
8 interface IExecutor {
9     /// @notice Performs a swap before completing a cross-chain transaction
10     /// @param _transactionId the transaction id associated with the operation
11     /// @param _swapData array of data needed for swaps
12     /// @param transferredAssetId token received from the other chain
13     /// @param receiver address that will receive tokens in the end
14     function swapAndCompleteBridgeTokens(
15         bytes32 _transactionId,
16         LibSwap.SwapData[] calldata _swapData,
17         address transferredAssetId,
18         address payable receiver
19     ) external payable;
20 }
