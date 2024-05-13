1 // SPDX-License-Identifier: BUSL-1.1
2 pragma solidity 0.8.17;
3 
4 // solhint-disable contract-name-camelcase
5 interface IStargateRouter {
6     struct lzTxObj {
7         uint256 dstGasForCall;
8         uint256 dstNativeAmount;
9         bytes dstNativeAddr;
10     }
11 
12     /// @notice SwapAmount struct
13     /// @param amountLD The amount, in Local Decimals, to be swapped
14     /// @param minAmountLD The minimum amount accepted out on destination
15     struct SwapAmount {
16         uint256 amountLD;
17         uint256 minAmountLD;
18     }
19 
20     /// @notice Returns factory address used for creating pools.
21     function factory() external view returns (address);
22 
23     /// @notice Swap assets cross-chain.
24     /// @dev Pass (0, 0, "0x") to lzTxParams
25     ///      for 0 additional gasLimit increase, 0 airdrop, at 0x address.
26     /// @param dstChainId Destination chainId
27     /// @param srcPoolId Source pool id
28     /// @param dstPoolId Dest pool id
29     /// @param refundAddress Refund adddress. extra gas (if any) is returned to this address
30     /// @param amountLD Quantity to swap
31     /// @param minAmountLD The min qty you would accept on the destination
32     /// @param lzTxParams Additional gas, airdrop data
33     /// @param to The address to send the tokens to on the destination
34     /// @param payload Additional payload. You can abi.encode() them here
35     function swap(
36         uint16 dstChainId,
37         uint256 srcPoolId,
38         uint256 dstPoolId,
39         address payable refundAddress,
40         uint256 amountLD,
41         uint256 minAmountLD,
42         lzTxObj memory lzTxParams,
43         bytes calldata to,
44         bytes calldata payload
45     ) external payable;
46 
47     /// @notice Swap native assets cross-chain.
48     /// @param _dstChainId Destination Stargate chainId
49     /// @param _refundAddress Refunds additional messageFee to this address
50     /// @param _toAddress The receiver of the destination ETH
51     /// @param _swapAmount The amount and the minimum swap amount
52     /// @param _lzTxParams The LZ tx params
53     /// @param _payload The payload to send to the destination
54     function swapETHAndCall(
55         uint16 _dstChainId,
56         address payable _refundAddress,
57         bytes calldata _toAddress,
58         SwapAmount memory _swapAmount,
59         IStargateRouter.lzTxObj memory _lzTxParams,
60         bytes calldata _payload
61     ) external payable;
62 
63     /// @notice Returns the native gas fee required for swap.
64     function quoteLayerZeroFee(
65         uint16 dstChainId,
66         uint8 functionType,
67         bytes calldata toAddress,
68         bytes calldata transferAndCallPayload,
69         lzTxObj memory lzTxParams
70     ) external view returns (uint256 nativeFee, uint256 zroFee);
71 }
