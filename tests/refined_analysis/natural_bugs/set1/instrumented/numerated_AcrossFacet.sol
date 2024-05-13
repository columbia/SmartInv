1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
5 import { ILiFi } from "../Interfaces/ILiFi.sol";
6 import { IAcrossSpokePool } from "../Interfaces/IAcrossSpokePool.sol";
7 import { LibAsset } from "../Libraries/LibAsset.sol";
8 import { LibSwap } from "../Libraries/LibSwap.sol";
9 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
10 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 
13 /// @title Across Facet
14 /// @author LI.FI (https://li.fi)
15 /// @notice Provides functionality for bridging through Across Protocol
16 /// @custom:version 2.0.0
17 contract AcrossFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
18     /// Storage ///
19 
20     /// @notice The contract address of the spoke pool on the source chain.
21     IAcrossSpokePool private immutable spokePool;
22 
23     /// @notice The WETH address on the current chain.
24     address private immutable wrappedNative;
25 
26     /// Types ///
27 
28     /// @param relayerFeePct The relayer fee in token percentage with 18 decimals.
29     /// @param quoteTimestamp The timestamp associated with the suggested fee.
30     /// @param message Arbitrary data that can be used to pass additional information to the recipient along with the tokens.
31     /// @param maxCount Used to protect the depositor from frontrunning to guarantee their quote remains valid.
32     struct AcrossData {
33         int64 relayerFeePct;
34         uint32 quoteTimestamp;
35         bytes message;
36         uint256 maxCount;
37     }
38 
39     /// Constructor ///
40 
41     /// @notice Initialize the contract.
42     /// @param _spokePool The contract address of the spoke pool on the source chain.
43     /// @param _wrappedNative The address of the wrapped native token on the source chain.
44     constructor(IAcrossSpokePool _spokePool, address _wrappedNative) {
45         spokePool = _spokePool;
46         wrappedNative = _wrappedNative;
47     }
48 
49     /// External Methods ///
50 
51     /// @notice Bridges tokens via Across
52     /// @param _bridgeData the core information needed for bridging
53     /// @param _acrossData data specific to Across
54     function startBridgeTokensViaAcross(
55         ILiFi.BridgeData memory _bridgeData,
56         AcrossData calldata _acrossData
57     )
58         external
59         payable
60         nonReentrant
61         refundExcessNative(payable(msg.sender))
62         validateBridgeData(_bridgeData)
63         doesNotContainSourceSwaps(_bridgeData)
64         doesNotContainDestinationCalls(_bridgeData)
65     {
66         LibAsset.depositAsset(
67             _bridgeData.sendingAssetId,
68             _bridgeData.minAmount
69         );
70         _startBridge(_bridgeData, _acrossData);
71     }
72 
73     /// @notice Performs a swap before bridging via Across
74     /// @param _bridgeData the core information needed for bridging
75     /// @param _swapData an array of swap related data for performing swaps before bridging
76     /// @param _acrossData data specific to Across
77     function swapAndStartBridgeTokensViaAcross(
78         ILiFi.BridgeData memory _bridgeData,
79         LibSwap.SwapData[] calldata _swapData,
80         AcrossData calldata _acrossData
81     )
82         external
83         payable
84         nonReentrant
85         refundExcessNative(payable(msg.sender))
86         containsSourceSwaps(_bridgeData)
87         doesNotContainDestinationCalls(_bridgeData)
88         validateBridgeData(_bridgeData)
89     {
90         _bridgeData.minAmount = _depositAndSwap(
91             _bridgeData.transactionId,
92             _bridgeData.minAmount,
93             _swapData,
94             payable(msg.sender)
95         );
96         _startBridge(_bridgeData, _acrossData);
97     }
98 
99     /// Internal Methods ///
100 
101     /// @dev Contains the business logic for the bridge via Across
102     /// @param _bridgeData the core information needed for bridging
103     /// @param _acrossData data specific to Across
104     function _startBridge(
105         ILiFi.BridgeData memory _bridgeData,
106         AcrossData calldata _acrossData
107     ) internal {
108         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
109             spokePool.deposit{ value: _bridgeData.minAmount }(
110                 _bridgeData.receiver,
111                 wrappedNative,
112                 _bridgeData.minAmount,
113                 _bridgeData.destinationChainId,
114                 _acrossData.relayerFeePct,
115                 _acrossData.quoteTimestamp,
116                 _acrossData.message,
117                 _acrossData.maxCount
118             );
119         } else {
120             LibAsset.maxApproveERC20(
121                 IERC20(_bridgeData.sendingAssetId),
122                 address(spokePool),
123                 _bridgeData.minAmount
124             );
125             spokePool.deposit(
126                 _bridgeData.receiver,
127                 _bridgeData.sendingAssetId,
128                 _bridgeData.minAmount,
129                 _bridgeData.destinationChainId,
130                 _acrossData.relayerFeePct,
131                 _acrossData.quoteTimestamp,
132                 _acrossData.message,
133                 _acrossData.maxCount
134             );
135         }
136 
137         emit LiFiTransferStarted(_bridgeData);
138     }
139 }
