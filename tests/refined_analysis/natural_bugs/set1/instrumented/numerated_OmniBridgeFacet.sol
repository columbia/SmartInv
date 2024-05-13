1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IOmniBridge } from "../Interfaces/IOmniBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
8 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 
11 /// @title OmniBridge Facet
12 /// @author LI.FI (https://li.fi)
13 /// @notice Provides functionality for bridging through OmniBridge
14 /// @custom:version 1.0.0
15 contract OmniBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
16     /// Storage ///
17 
18     /// @notice The contract address of the foreign omni bridge on the source chain.
19     IOmniBridge private immutable foreignOmniBridge;
20 
21     /// @notice The contract address of the weth omni bridge on the source chain.
22     IOmniBridge private immutable wethOmniBridge;
23 
24     /// Constructor ///
25 
26     /// @notice Initialize the contract.
27     /// @param _foreignOmniBridge The contract address of the foreign omni bridge on the source chain.
28     /// @param _wethOmniBridge The contract address of the weth omni bridge on the source chain.
29     constructor(IOmniBridge _foreignOmniBridge, IOmniBridge _wethOmniBridge) {
30         foreignOmniBridge = _foreignOmniBridge;
31         wethOmniBridge = _wethOmniBridge;
32     }
33 
34     /// External Methods ///
35 
36     /// @notice Bridges tokens via OmniBridge
37     /// @param _bridgeData Data contaning core information for bridging
38     function startBridgeTokensViaOmniBridge(
39         ILiFi.BridgeData memory _bridgeData
40     )
41         external
42         payable
43         nonReentrant
44         refundExcessNative(payable(msg.sender))
45         doesNotContainSourceSwaps(_bridgeData)
46         doesNotContainDestinationCalls(_bridgeData)
47         validateBridgeData(_bridgeData)
48     {
49         LibAsset.depositAsset(
50             _bridgeData.sendingAssetId,
51             _bridgeData.minAmount
52         );
53         _startBridge(_bridgeData);
54     }
55 
56     /// @notice Performs a swap before bridging via OmniBridge
57     /// @param _bridgeData Data contaning core information for bridging
58     /// @param _swapData An array of swap related data for performing swaps before bridging
59     function swapAndStartBridgeTokensViaOmniBridge(
60         ILiFi.BridgeData memory _bridgeData,
61         LibSwap.SwapData[] calldata _swapData
62     )
63         external
64         payable
65         nonReentrant
66         refundExcessNative(payable(msg.sender))
67         containsSourceSwaps(_bridgeData)
68         doesNotContainDestinationCalls(_bridgeData)
69         validateBridgeData(_bridgeData)
70     {
71         _bridgeData.minAmount = _depositAndSwap(
72             _bridgeData.transactionId,
73             _bridgeData.minAmount,
74             _swapData,
75             payable(msg.sender)
76         );
77         _startBridge(_bridgeData);
78     }
79 
80     /// Private Methods ///
81 
82     /// @dev Contains the business logic for the bridge via OmniBridge
83     /// @param _bridgeData Data contaning core information for bridging
84     function _startBridge(ILiFi.BridgeData memory _bridgeData) private {
85         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
86             wethOmniBridge.wrapAndRelayTokens{ value: _bridgeData.minAmount }(
87                 _bridgeData.receiver
88             );
89         } else {
90             LibAsset.maxApproveERC20(
91                 IERC20(_bridgeData.sendingAssetId),
92                 address(foreignOmniBridge),
93                 _bridgeData.minAmount
94             );
95             foreignOmniBridge.relayTokens(
96                 _bridgeData.sendingAssetId,
97                 _bridgeData.receiver,
98                 _bridgeData.minAmount
99             );
100         }
101 
102         emit LiFiTransferStarted(_bridgeData);
103     }
104 }
