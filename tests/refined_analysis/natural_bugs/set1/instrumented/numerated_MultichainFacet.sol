1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
6 import { LibDiamond } from "../Libraries/LibDiamond.sol";
7 import { IMultichainRouter } from "../Interfaces/IMultichainRouter.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { InvalidConfig, AlreadyInitialized, NotInitialized } from "../Errors/GenericErrors.sol";
10 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 
13 interface IMultichainERC20 {
14     function Swapout(uint256 amount, address bindaddr) external returns (bool);
15 }
16 
17 /// @title Multichain Facet
18 /// @author LI.FI (https://li.fi)
19 /// @notice Provides functionality for bridging through Multichain (Prev. AnySwap)
20 /// @custom:version 1.0.1
21 contract MultichainFacet is ILiFi, SwapperV2, ReentrancyGuard, Validatable {
22     /// Storage ///
23 
24     bytes32 internal constant NAMESPACE =
25         keccak256("com.lifi.facets.multichain");
26 
27     /// Types ///
28 
29     struct Storage {
30         mapping(address => bool) allowedRouters;
31         bool initialized; // no longer used but kept here to maintain the same storage layout
32         address anyNative;
33         mapping(address => address) anyTokenAddresses;
34     }
35 
36     struct MultichainData {
37         address router;
38     }
39 
40     struct AnyMapping {
41         address tokenAddress;
42         address anyTokenAddress;
43     }
44 
45     /// Errors ///
46 
47     error InvalidRouter();
48 
49     /// Events ///
50 
51     event MultichainInitialized();
52     event MultichainRoutersUpdated(address[] routers, bool[] allowed);
53     event AnyMappingUpdated(AnyMapping[] mappings);
54 
55     /// Init ///
56 
57     /// @notice Initialize local variables for the Multichain Facet
58     /// @param anyNative The address of the anyNative (e.g. anyETH) token
59     /// @param routers Allowed Multichain Routers
60     function initMultichain(
61         address anyNative,
62         address[] calldata routers
63     ) external {
64         LibDiamond.enforceIsContractOwner();
65 
66         Storage storage s = getStorage();
67 
68         s.anyNative = anyNative;
69 
70         uint256 len = routers.length;
71         for (uint256 i = 0; i < len; ) {
72             if (routers[i] == address(0)) {
73                 revert InvalidConfig();
74             }
75             s.allowedRouters[routers[i]] = true;
76             unchecked {
77                 ++i;
78             }
79         }
80 
81         emit MultichainInitialized();
82     }
83 
84     /// External Methods ///
85 
86     /// @notice Updates the tokenAddress > anyTokenAddress storage
87     /// @param mappings A mapping of tokenAddress(es) to anyTokenAddress(es)
88     function updateAddressMappings(AnyMapping[] calldata mappings) external {
89         LibDiamond.enforceIsContractOwner();
90 
91         Storage storage s = getStorage();
92 
93         for (uint64 i; i < mappings.length; ) {
94             s.anyTokenAddresses[mappings[i].tokenAddress] = mappings[i]
95                 .anyTokenAddress;
96             unchecked {
97                 ++i;
98             }
99         }
100 
101         emit AnyMappingUpdated(mappings);
102     }
103 
104     /// @notice (Batch) register routers
105     /// @param routers Router addresses
106     /// @param allowed Array of whether the addresses are allowed or not
107     function registerRouters(
108         address[] calldata routers,
109         bool[] calldata allowed
110     ) external {
111         LibDiamond.enforceIsContractOwner();
112 
113         Storage storage s = getStorage();
114 
115         uint256 len = routers.length;
116         for (uint256 i = 0; i < len; ) {
117             if (routers[i] == address(0)) {
118                 revert InvalidConfig();
119             }
120             s.allowedRouters[routers[i]] = allowed[i];
121 
122             unchecked {
123                 ++i;
124             }
125         }
126         emit MultichainRoutersUpdated(routers, allowed);
127     }
128 
129     /// @notice Bridges tokens via Multichain
130     /// @param _bridgeData the core information needed for bridging
131     /// @param _multichainData data specific to Multichain
132     function startBridgeTokensViaMultichain(
133         ILiFi.BridgeData memory _bridgeData,
134         MultichainData calldata _multichainData
135     )
136         external
137         payable
138         nonReentrant
139         refundExcessNative(payable(msg.sender))
140         doesNotContainSourceSwaps(_bridgeData)
141         doesNotContainDestinationCalls(_bridgeData)
142         validateBridgeData(_bridgeData)
143     {
144         Storage storage s = getStorage();
145         if (!s.allowedRouters[_multichainData.router]) {
146             revert InvalidRouter();
147         }
148         if (!LibAsset.isNativeAsset(_bridgeData.sendingAssetId))
149             LibAsset.depositAsset(
150                 _bridgeData.sendingAssetId,
151                 _bridgeData.minAmount
152             );
153 
154         _startBridge(_bridgeData, _multichainData);
155     }
156 
157     /// @notice Performs a swap before bridging via Multichain
158     /// @param _bridgeData the core information needed for bridging
159     /// @param _swapData an array of swap related data for performing swaps before bridging
160     /// @param _multichainData data specific to Multichain
161     function swapAndStartBridgeTokensViaMultichain(
162         ILiFi.BridgeData memory _bridgeData,
163         LibSwap.SwapData[] calldata _swapData,
164         MultichainData calldata _multichainData
165     )
166         external
167         payable
168         nonReentrant
169         refundExcessNative(payable(msg.sender))
170         containsSourceSwaps(_bridgeData)
171         doesNotContainDestinationCalls(_bridgeData)
172         validateBridgeData(_bridgeData)
173     {
174         Storage storage s = getStorage();
175 
176         if (!s.allowedRouters[_multichainData.router]) {
177             revert InvalidRouter();
178         }
179 
180         _bridgeData.minAmount = _depositAndSwap(
181             _bridgeData.transactionId,
182             _bridgeData.minAmount,
183             _swapData,
184             payable(msg.sender)
185         );
186         _startBridge(_bridgeData, _multichainData);
187     }
188 
189     /// Private Methods ///
190 
191     /// @dev Contains the business logic for the bridge via Multichain
192     /// @param _bridgeData the core information needed for bridging
193     /// @param _multichainData data specific to Multichain
194     function _startBridge(
195         ILiFi.BridgeData memory _bridgeData,
196         MultichainData calldata _multichainData
197     ) private {
198         // check if sendingAsset is a Multichain token that needs to be called directly in order to bridge it
199         if (_multichainData.router == _bridgeData.sendingAssetId) {
200             IMultichainERC20(_bridgeData.sendingAssetId).Swapout(
201                 _bridgeData.minAmount,
202                 _bridgeData.receiver
203             );
204         } else {
205             Storage storage s = getStorage();
206             if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
207                 // call native asset bridge function
208                 IMultichainRouter(_multichainData.router).anySwapOutNative{
209                     value: _bridgeData.minAmount
210                 }(
211                     s.anyNative,
212                     _bridgeData.receiver,
213                     _bridgeData.destinationChainId
214                 );
215             } else {
216                 // Give Multichain router approval to pull tokens
217                 LibAsset.maxApproveERC20(
218                     IERC20(_bridgeData.sendingAssetId),
219                     _multichainData.router,
220                     _bridgeData.minAmount
221                 );
222 
223                 address anyToken = s.anyTokenAddresses[
224                     _bridgeData.sendingAssetId
225                 ];
226 
227                 // replace tokenAddress with anyTokenAddress (if mapping found) and call ERC20 asset bridge function
228                 IMultichainRouter(_multichainData.router).anySwapOutUnderlying(
229                     anyToken != address(0)
230                         ? anyToken
231                         : _bridgeData.sendingAssetId,
232                     _bridgeData.receiver,
233                     _bridgeData.minAmount,
234                     _bridgeData.destinationChainId
235                 );
236             }
237         }
238 
239         emit LiFiTransferStarted(_bridgeData);
240     }
241 
242     /// @dev fetch local storage
243     function getStorage() private pure returns (Storage storage s) {
244         bytes32 namespace = NAMESPACE;
245         // solhint-disable-next-line no-inline-assembly
246         assembly {
247             s.slot := namespace
248         }
249     }
250 }
