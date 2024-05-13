1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IAllBridge } from "../Interfaces/IAllBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { Validatable } from "../Helpers/Validatable.sol";
10 import { LibSwap } from "../Libraries/LibSwap.sol";
11 
12 /// @title Allbridge Facet
13 /// @author Li.Finance (https://li.finance)
14 /// @notice Provides functionality for bridging through AllBridge
15 /// @custom:version 2.0.0
16 contract AllBridgeFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
17     /// @notice The contract address of the AllBridge router on the source chain.
18     IAllBridge private immutable allBridge;
19 
20     /// @notice The struct for the AllBridge data.
21     /// @param fees The amount of token to pay the messenger and the bridge
22     /// @param recipient The address of the token receiver after bridging.
23     /// @param destinationChainId The destination chain id.
24     /// @param receiveToken The token to receive on the destination chain.
25     /// @param nonce A random nonce to associate with the tx.
26     /// @param messenger The messenger protocol enum
27     /// @param payFeeWithSendingAsset Whether to pay the relayer fee with the sending asset or not
28     struct AllBridgeData {
29         uint256 fees;
30         bytes32 recipient;
31         uint256 destinationChainId;
32         bytes32 receiveToken;
33         uint256 nonce;
34         IAllBridge.MessengerProtocol messenger;
35         bool payFeeWithSendingAsset;
36     }
37 
38     /// @notice Initializes the AllBridge contract
39     /// @param _allBridge The address of the AllBridge contract
40     constructor(IAllBridge _allBridge) {
41         allBridge = _allBridge;
42     }
43 
44     /// @notice Bridge tokens to another chain via AllBridge
45     /// @param _bridgeData The bridge data struct
46     function startBridgeTokensViaAllBridge(
47         ILiFi.BridgeData memory _bridgeData,
48         AllBridgeData calldata _allBridgeData
49     )
50         external
51         payable
52         nonReentrant
53         refundExcessNative(payable(msg.sender))
54         validateBridgeData(_bridgeData)
55         doesNotContainSourceSwaps(_bridgeData)
56         doesNotContainDestinationCalls(_bridgeData)
57     {
58         LibAsset.depositAsset(
59             _bridgeData.sendingAssetId,
60             _bridgeData.minAmount
61         );
62         _startBridge(_bridgeData, _allBridgeData);
63     }
64 
65     /// @notice Bridge tokens to another chain via AllBridge
66     /// @param _bridgeData The bridge data struct
67     /// @param _swapData The swap data struct
68     /// @param _allBridgeData The AllBridge data struct
69     function swapAndStartBridgeTokensViaAllBridge(
70         ILiFi.BridgeData memory _bridgeData,
71         LibSwap.SwapData[] calldata _swapData,
72         AllBridgeData calldata _allBridgeData
73     )
74         external
75         payable
76         nonReentrant
77         refundExcessNative(payable(msg.sender))
78         containsSourceSwaps(_bridgeData)
79         doesNotContainDestinationCalls(_bridgeData)
80         validateBridgeData(_bridgeData)
81     {
82         _bridgeData.minAmount = _depositAndSwap(
83             _bridgeData.transactionId,
84             _bridgeData.minAmount,
85             _swapData,
86             payable(msg.sender)
87         );
88         _startBridge(_bridgeData, _allBridgeData);
89     }
90 
91     /// @notice Bridge tokens to another chain via AllBridge
92     /// @param _bridgeData The bridge data struct
93     /// @param _allBridgeData The allBridge data struct for AllBridge specicific data
94     function _startBridge(
95         ILiFi.BridgeData memory _bridgeData,
96         AllBridgeData calldata _allBridgeData
97     ) internal {
98         LibAsset.maxApproveERC20(
99             IERC20(_bridgeData.sendingAssetId),
100             address(allBridge),
101             _bridgeData.minAmount
102         );
103 
104         if (_allBridgeData.payFeeWithSendingAsset) {
105             allBridge.swapAndBridge(
106                 bytes32(uint256(uint160(_bridgeData.sendingAssetId))),
107                 _bridgeData.minAmount,
108                 _allBridgeData.recipient,
109                 _allBridgeData.destinationChainId,
110                 _allBridgeData.receiveToken,
111                 _allBridgeData.nonce,
112                 _allBridgeData.messenger,
113                 _allBridgeData.fees
114             );
115         } else {
116             allBridge.swapAndBridge{ value: _allBridgeData.fees }(
117                 bytes32(uint256(uint160(_bridgeData.sendingAssetId))),
118                 _bridgeData.minAmount,
119                 _allBridgeData.recipient,
120                 _allBridgeData.destinationChainId,
121                 _allBridgeData.receiveToken,
122                 _allBridgeData.nonce,
123                 _allBridgeData.messenger,
124                 0
125             );
126         }
127 
128         emit LiFiTransferStarted(_bridgeData);
129     }
130 }
