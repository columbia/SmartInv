1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IHopBridge } from "../Interfaces/IHopBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { LibDiamond } from "../Libraries/LibDiamond.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { InvalidConfig, AlreadyInitialized, NotInitialized } from "../Errors/GenericErrors.sol";
10 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 
13 /// @title Hop Facet
14 /// @author LI.FI (https://li.fi)
15 /// @notice Provides functionality for bridging through Hop
16 /// @custom:version 2.0.0
17 contract HopFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
18     /// Storage ///
19 
20     bytes32 internal constant NAMESPACE = keccak256("com.lifi.facets.hop");
21 
22     /// Types ///
23 
24     struct Storage {
25         mapping(address => IHopBridge) bridges;
26         bool initialized; // no longer used but kept here to maintain the same storage layout
27     }
28 
29     struct Config {
30         address assetId;
31         address bridge;
32     }
33 
34     struct HopData {
35         uint256 bonderFee;
36         uint256 amountOutMin;
37         uint256 deadline;
38         uint256 destinationAmountOutMin;
39         uint256 destinationDeadline;
40         address relayer;
41         uint256 relayerFee;
42         uint256 nativeFee;
43     }
44 
45     /// Events ///
46 
47     event HopInitialized(Config[] configs);
48     event HopBridgeRegistered(address indexed assetId, address bridge);
49 
50     /// Init ///
51 
52     /// @notice Initialize local variables for the Hop Facet
53     /// @param configs Bridge configuration data
54     function initHop(Config[] calldata configs) external {
55         LibDiamond.enforceIsContractOwner();
56 
57         Storage storage s = getStorage();
58 
59         for (uint256 i = 0; i < configs.length; i++) {
60             if (configs[i].bridge == address(0)) {
61                 revert InvalidConfig();
62             }
63             s.bridges[configs[i].assetId] = IHopBridge(configs[i].bridge);
64         }
65 
66         emit HopInitialized(configs);
67     }
68 
69     /// External Methods ///
70 
71     /// @notice Register token and bridge
72     /// @param assetId Address of token
73     /// @param bridge Address of bridge for asset
74     function registerBridge(address assetId, address bridge) external {
75         LibDiamond.enforceIsContractOwner();
76 
77         Storage storage s = getStorage();
78 
79         if (bridge == address(0)) {
80             revert InvalidConfig();
81         }
82 
83         s.bridges[assetId] = IHopBridge(bridge);
84 
85         emit HopBridgeRegistered(assetId, bridge);
86     }
87 
88     /// @notice Bridges tokens via Hop Protocol
89     /// @param _bridgeData the core information needed for bridging
90     /// @param _hopData data specific to Hop Protocol
91     function startBridgeTokensViaHop(
92         ILiFi.BridgeData memory _bridgeData,
93         HopData calldata _hopData
94     )
95         external
96         payable
97         nonReentrant
98         refundExcessNative(payable(msg.sender))
99         doesNotContainSourceSwaps(_bridgeData)
100         doesNotContainDestinationCalls(_bridgeData)
101         validateBridgeData(_bridgeData)
102     {
103         LibAsset.depositAsset(
104             _bridgeData.sendingAssetId,
105             _bridgeData.minAmount
106         );
107         _startBridge(_bridgeData, _hopData);
108     }
109 
110     /// @notice Performs a swap before bridging via Hop Protocol
111     /// @param _bridgeData the core information needed for bridging
112     /// @param _swapData an array of swap related data for performing swaps before bridging
113     /// @param _hopData data specific to Hop Protocol
114     function swapAndStartBridgeTokensViaHop(
115         ILiFi.BridgeData memory _bridgeData,
116         LibSwap.SwapData[] calldata _swapData,
117         HopData calldata _hopData
118     )
119         external
120         payable
121         nonReentrant
122         refundExcessNative(payable(msg.sender))
123         containsSourceSwaps(_bridgeData)
124         doesNotContainDestinationCalls(_bridgeData)
125         validateBridgeData(_bridgeData)
126     {
127         _bridgeData.minAmount = _depositAndSwap(
128             _bridgeData.transactionId,
129             _bridgeData.minAmount,
130             _swapData,
131             payable(msg.sender),
132             _hopData.nativeFee
133         );
134         _startBridge(_bridgeData, _hopData);
135     }
136 
137     /// private Methods ///
138 
139     /// @dev Contains the business logic for the bridge via Hop Protocol
140     /// @param _bridgeData the core information needed for bridging
141     /// @param _hopData data specific to Hop Protocol
142     function _startBridge(
143         ILiFi.BridgeData memory _bridgeData,
144         HopData calldata _hopData
145     ) private {
146         address sendingAssetId = _bridgeData.sendingAssetId;
147         Storage storage s = getStorage();
148         IHopBridge bridge = s.bridges[sendingAssetId];
149 
150         // Give Hop approval to bridge tokens
151         LibAsset.maxApproveERC20(
152             IERC20(sendingAssetId),
153             address(bridge),
154             _bridgeData.minAmount
155         );
156 
157         uint256 value = LibAsset.isNativeAsset(address(sendingAssetId))
158             ? _hopData.nativeFee + _bridgeData.minAmount
159             : _hopData.nativeFee;
160 
161         if (block.chainid == 1 || block.chainid == 5) {
162             // Ethereum L1
163             bridge.sendToL2{ value: value }(
164                 _bridgeData.destinationChainId,
165                 _bridgeData.receiver,
166                 _bridgeData.minAmount,
167                 _hopData.destinationAmountOutMin,
168                 _hopData.destinationDeadline,
169                 _hopData.relayer,
170                 _hopData.relayerFee
171             );
172         } else {
173             // L2
174             // solhint-disable-next-line check-send-result
175             bridge.swapAndSend{ value: value }(
176                 _bridgeData.destinationChainId,
177                 _bridgeData.receiver,
178                 _bridgeData.minAmount,
179                 _hopData.bonderFee,
180                 _hopData.amountOutMin,
181                 _hopData.deadline,
182                 _hopData.destinationAmountOutMin,
183                 _hopData.destinationDeadline
184             );
185         }
186         emit LiFiTransferStarted(_bridgeData);
187     }
188 
189     /// @dev fetch local storage
190     function getStorage() private pure returns (Storage storage s) {
191         bytes32 namespace = NAMESPACE;
192         // solhint-disable-next-line no-inline-assembly
193         assembly {
194             s.slot := namespace
195         }
196     }
197 }
