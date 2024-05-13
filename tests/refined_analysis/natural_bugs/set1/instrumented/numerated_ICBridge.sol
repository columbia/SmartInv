1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 interface ICBridge {
5     /// @notice Send a cross-chain transfer via the liquidity pool-based bridge.
6     /// @dev This function DOES NOT SUPPORT fee-on-transfer / rebasing tokens.
7     /// @param _receiver The address of the receiver.
8     /// @param _token The address of the token.
9     /// @param _amount The amount of the transfer.
10     /// @param _dstChainId The destination chain ID.
11     /// @param _nonce A number input to guarantee uniqueness of transferId. Can be timestamp in practice.
12     /// @param _maxSlippage The max slippage accepted, given as percentage in point (pip).
13     ///                     Eg. 5000 means 0.5%. Must be greater than minimalMaxSlippage.
14     ///                     Receiver is guaranteed to receive at least (100% - max slippage percentage) * amount
15     ///                     or the transfer can be refunded.
16     function send(
17         address _receiver,
18         address _token,
19         uint256 _amount,
20         uint64 _dstChainId,
21         uint64 _nonce,
22         uint32 _maxSlippage
23     ) external;
24 
25     /// @notice Send a cross-chain transfer via the liquidity pool-based bridge using the native token.
26     /// @param _receiver The address of the receiver.
27     /// @param _amount The amount of the transfer.
28     /// @param _dstChainId The destination chain ID.
29     /// @param _nonce A unique number. Can be timestamp in practice.
30     /// @param _maxSlippage The max slippage accepted, given as percentage in point (pip).
31     ///                     Eg. 5000 means 0.5%. Must be greater than minimalMaxSlippage.
32     ///                     Receiver is guaranteed to receive at least (100% - max slippage percentage) * amount
33     ///                     or the transfer can be refunded.
34     function sendNative(
35         address _receiver,
36         uint256 _amount,
37         uint64 _dstChainId,
38         uint64 _nonce,
39         uint32 _maxSlippage
40     ) external payable;
41 }
