1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 import { LibAsset } from "../Libraries/LibAsset.sol";
5 import { LibUtil } from "../Libraries/LibUtil.sol";
6 import { InvalidReceiver, InformationMismatch, InvalidSendingToken, InvalidAmount, NativeAssetNotSupported, InvalidDestinationChain, CannotBridgeToSameNetwork } from "../Errors/GenericErrors.sol";
7 import { ILiFi } from "../Interfaces/ILiFi.sol";
8 import { LibSwap } from "../Libraries/LibSwap.sol";
9 
10 contract Validatable {
11     modifier validateBridgeData(ILiFi.BridgeData memory _bridgeData) {
12         if (LibUtil.isZeroAddress(_bridgeData.receiver)) {
13             revert InvalidReceiver();
14         }
15         if (_bridgeData.minAmount == 0) {
16             revert InvalidAmount();
17         }
18         if (_bridgeData.destinationChainId == block.chainid) {
19             revert CannotBridgeToSameNetwork();
20         }
21         _;
22     }
23 
24     modifier noNativeAsset(ILiFi.BridgeData memory _bridgeData) {
25         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
26             revert NativeAssetNotSupported();
27         }
28         _;
29     }
30 
31     modifier onlyAllowSourceToken(
32         ILiFi.BridgeData memory _bridgeData,
33         address _token
34     ) {
35         if (_bridgeData.sendingAssetId != _token) {
36             revert InvalidSendingToken();
37         }
38         _;
39     }
40 
41     modifier onlyAllowDestinationChain(
42         ILiFi.BridgeData memory _bridgeData,
43         uint256 _chainId
44     ) {
45         if (_bridgeData.destinationChainId != _chainId) {
46             revert InvalidDestinationChain();
47         }
48         _;
49     }
50 
51     modifier containsSourceSwaps(ILiFi.BridgeData memory _bridgeData) {
52         if (!_bridgeData.hasSourceSwaps) {
53             revert InformationMismatch();
54         }
55         _;
56     }
57 
58     modifier doesNotContainSourceSwaps(ILiFi.BridgeData memory _bridgeData) {
59         if (_bridgeData.hasSourceSwaps) {
60             revert InformationMismatch();
61         }
62         _;
63     }
64 
65     modifier doesNotContainDestinationCalls(
66         ILiFi.BridgeData memory _bridgeData
67     ) {
68         if (_bridgeData.hasDestinationCall) {
69             revert InformationMismatch();
70         }
71         _;
72     }
73 }
