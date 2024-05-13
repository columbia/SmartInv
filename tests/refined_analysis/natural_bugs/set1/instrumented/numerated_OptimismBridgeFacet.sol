1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IL1StandardBridge } from "../Interfaces/IL1StandardBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { LibDiamond } from "../Libraries/LibDiamond.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { InvalidConfig, AlreadyInitialized, NotInitialized } from "../Errors/GenericErrors.sol";
10 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 import { LibUtil } from "../Libraries/LibUtil.sol";
13 
14 /// @title Optimism Bridge Facet
15 /// @author Li.Finance (https://li.finance)
16 /// @notice Provides functionality for bridging through Optimism Bridge
17 /// @custom:version 1.0.0
18 contract OptimismBridgeFacet is
19     ILiFi,
20     ReentrancyGuard,
21     SwapperV2,
22     Validatable
23 {
24     /// Storage ///
25 
26     bytes32 internal constant NAMESPACE =
27         keccak256("com.lifi.facets.optimism");
28 
29     /// Types ///
30 
31     struct Storage {
32         mapping(address => IL1StandardBridge) bridges;
33         IL1StandardBridge standardBridge;
34         bool initialized;
35     }
36 
37     struct Config {
38         address assetId;
39         address bridge;
40     }
41 
42     struct OptimismData {
43         address assetIdOnL2;
44         uint32 l2Gas;
45         bool isSynthetix;
46     }
47 
48     /// Events ///
49 
50     event OptimismInitialized(Config[] configs);
51     event OptimismBridgeRegistered(address indexed assetId, address bridge);
52 
53     /// Init ///
54 
55     /// @notice Initialize local variables for the Optimism Bridge Facet
56     /// @param configs Bridge configuration data
57     function initOptimism(
58         Config[] calldata configs,
59         IL1StandardBridge standardBridge
60     ) external {
61         LibDiamond.enforceIsContractOwner();
62 
63         Storage storage s = getStorage();
64 
65         if (s.initialized) {
66             revert AlreadyInitialized();
67         }
68 
69         for (uint256 i = 0; i < configs.length; i++) {
70             if (configs[i].bridge == address(0)) {
71                 revert InvalidConfig();
72             }
73             s.bridges[configs[i].assetId] = IL1StandardBridge(
74                 configs[i].bridge
75             );
76         }
77 
78         s.standardBridge = standardBridge;
79         s.initialized = true;
80 
81         emit OptimismInitialized(configs);
82     }
83 
84     /// External Methods ///
85 
86     /// @notice Register token and bridge
87     /// @param assetId Address of token
88     /// @param bridge Address of bridge for asset
89     function registerOptimismBridge(address assetId, address bridge) external {
90         LibDiamond.enforceIsContractOwner();
91 
92         Storage storage s = getStorage();
93 
94         if (!s.initialized) revert NotInitialized();
95 
96         if (bridge == address(0)) {
97             revert InvalidConfig();
98         }
99 
100         s.bridges[assetId] = IL1StandardBridge(bridge);
101 
102         emit OptimismBridgeRegistered(assetId, bridge);
103     }
104 
105     /// @notice Bridges tokens via Optimism Bridge
106     /// @param _bridgeData Data contaning core information for bridging
107     /// @param _bridgeData Data specific to Optimism Bridge
108     function startBridgeTokensViaOptimismBridge(
109         ILiFi.BridgeData memory _bridgeData,
110         OptimismData calldata _optimismData
111     )
112         external
113         payable
114         nonReentrant
115         refundExcessNative(payable(msg.sender))
116         doesNotContainSourceSwaps(_bridgeData)
117         doesNotContainDestinationCalls(_bridgeData)
118         validateBridgeData(_bridgeData)
119     {
120         LibAsset.depositAsset(
121             _bridgeData.sendingAssetId,
122             _bridgeData.minAmount
123         );
124         _startBridge(_bridgeData, _optimismData);
125     }
126 
127     /// @notice Performs a swap before bridging via Optimism Bridge
128     /// @param _bridgeData Data contaning core information for bridging
129     /// @param _swapData An array of swap related data for performing swaps before bridging
130     /// @param _bridgeData Data specific to Optimism Bridge
131     function swapAndStartBridgeTokensViaOptimismBridge(
132         ILiFi.BridgeData memory _bridgeData,
133         LibSwap.SwapData[] calldata _swapData,
134         OptimismData calldata _optimismData
135     )
136         external
137         payable
138         nonReentrant
139         refundExcessNative(payable(msg.sender))
140         containsSourceSwaps(_bridgeData)
141         doesNotContainDestinationCalls(_bridgeData)
142         validateBridgeData(_bridgeData)
143     {
144         _bridgeData.minAmount = _depositAndSwap(
145             _bridgeData.transactionId,
146             _bridgeData.minAmount,
147             _swapData,
148             payable(msg.sender)
149         );
150         _startBridge(_bridgeData, _optimismData);
151     }
152 
153     /// Private Methods ///
154 
155     /// @dev Contains the business logic for the bridge via Optimism Bridge
156     /// @param _bridgeData Data contaning core information for bridging
157     /// @param _bridgeData Data specific to Optimism Bridge
158     function _startBridge(
159         ILiFi.BridgeData memory _bridgeData,
160         OptimismData calldata _optimismData
161     ) private {
162         Storage storage s = getStorage();
163         IL1StandardBridge nonStandardBridge = s.bridges[
164             _bridgeData.sendingAssetId
165         ];
166         IL1StandardBridge bridge = LibUtil.isZeroAddress(
167             address(nonStandardBridge)
168         )
169             ? s.standardBridge
170             : nonStandardBridge;
171 
172         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
173             bridge.depositETHTo{ value: _bridgeData.minAmount }(
174                 _bridgeData.receiver,
175                 _optimismData.l2Gas,
176                 ""
177             );
178         } else {
179             LibAsset.maxApproveERC20(
180                 IERC20(_bridgeData.sendingAssetId),
181                 address(bridge),
182                 _bridgeData.minAmount
183             );
184 
185             if (_optimismData.isSynthetix) {
186                 bridge.depositTo(_bridgeData.receiver, _bridgeData.minAmount);
187             } else {
188                 bridge.depositERC20To(
189                     _bridgeData.sendingAssetId,
190                     _optimismData.assetIdOnL2,
191                     _bridgeData.receiver,
192                     _bridgeData.minAmount,
193                     _optimismData.l2Gas,
194                     ""
195                 );
196             }
197         }
198 
199         emit LiFiTransferStarted(_bridgeData);
200     }
201 
202     /// @dev fetch local storage
203     function getStorage() private pure returns (Storage storage s) {
204         bytes32 namespace = NAMESPACE;
205         // solhint-disable-next-line no-inline-assembly
206         assembly {
207             s.slot := namespace
208         }
209     }
210 }
