1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.17;
3 
4 interface IGatewayRouter {
5     /// @notice Transfer non-native assets
6     /// @param _token L1 address of ERC20
7     /// @param _to Account to be credited with the tokens in the L2 (can be the user's L2 account or a contract)
8     /// @param _amount Token Amount
9     /// @param _maxGas Max gas deducted from user's L2 balance to cover L2 execution
10     /// @param _gasPriceBid Gas price for L2 execution
11     /// @param _data Encoded data from router and user
12     function outboundTransfer(
13         address _token,
14         address _to,
15         uint256 _amount,
16         uint256 _maxGas,
17         uint256 _gasPriceBid,
18         bytes calldata _data
19     ) external payable returns (bytes memory);
20 
21     /// @dev Advanced usage only (does not rewrite aliases for excessFeeRefundAddress and callValueRefundAddress). createRetryableTicket method is the recommended standard.
22     /// @param _destAddr destination L2 contract address
23     /// @param _l2CallValue call value for retryable L2 message
24     /// @param _maxSubmissionCost Max gas deducted from user's L2 balance to cover base submission fee
25     /// @param _excessFeeRefundAddress maxgas x gasprice - execution cost gets credited here on L2 balance
26     /// @param _callValueRefundAddress l2Callvalue gets credited here on L2 if retryable txn times out or gets cancelled
27     /// @param _maxGas Max gas deducted from user's L2 balance to cover L2 execution
28     /// @param _gasPriceBid price bid for L2 execution
29     /// @param _data ABI encoded data of L2 message
30     /// @return unique id for retryable transaction (keccak256(requestID, uint(0) )
31     function unsafeCreateRetryableTicket(
32         address _destAddr,
33         uint256 _l2CallValue,
34         uint256 _maxSubmissionCost,
35         address _excessFeeRefundAddress,
36         address _callValueRefundAddress,
37         uint256 _maxGas,
38         uint256 _gasPriceBid,
39         bytes calldata _data
40     ) external payable returns (uint256);
41 
42     /// @notice Returns receiving token address on L2
43     /// @param _token Sending token address on L1
44     /// @return Receiving token address on L2
45     function calculateL2TokenAddress(
46         address _token
47     ) external view returns (address);
48 
49     /// @notice Returns exact gateway router address for token
50     /// @param _token Sending token address on L1
51     /// @return Gateway router address for sending token
52     function getGateway(address _token) external view returns (address);
53 }
