1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IStargateRouter } from "../Interfaces/IStargateRouter.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { LibDiamond } from "../Libraries/LibDiamond.sol";
8 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
9 import { InformationMismatch, AlreadyInitialized, NotInitialized } from "../Errors/GenericErrors.sol";
10 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 
13 /// @title Stargate Facet
14 /// @author Li.Finance (https://li.finance)
15 /// @notice Provides functionality for bridging through Stargate
16 /// @custom:version 2.2.0
17 contract StargateFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
18     /// CONSTANTS ///
19 
20     /// @notice The contract address of the stargate composer on the source chain.
21     IStargateRouter private immutable composer;
22 
23     /// Storage ///
24 
25     bytes32 internal constant NAMESPACE =
26         keccak256("com.lifi.facets.stargate");
27 
28     /// Types ///
29 
30     struct Storage {
31         mapping(uint256 => uint16) layerZeroChainId;
32         bool initialized;
33     }
34 
35     struct ChainIdConfig {
36         uint256 chainId;
37         uint16 layerZeroChainId;
38     }
39 
40     /// @param srcPoolId Source pool id.
41     /// @param dstPoolId Dest pool id.
42     /// @param minAmountLD The min qty you would accept on the destination.
43     /// @param dstGasForCall Additional gas fee for extral call on the destination.
44     /// @param lzFee Estimated message fee.
45     /// @param refundAddress Refund adddress. Extra gas (if any) is returned to this address
46     /// @param callTo The address to send the tokens to on the destination.
47     /// @param callData Additional payload.
48     struct StargateData {
49         uint256 srcPoolId;
50         uint256 dstPoolId;
51         uint256 minAmountLD;
52         uint256 dstGasForCall;
53         uint256 lzFee;
54         address payable refundAddress;
55         bytes callTo;
56         bytes callData;
57     }
58 
59     /// Errors ///
60 
61     error UnknownLayerZeroChain();
62 
63     /// Events ///
64 
65     event StargateInitialized(ChainIdConfig[] chainIdConfigs);
66 
67     event LayerZeroChainIdSet(
68         uint256 indexed chainId,
69         uint16 layerZeroChainId
70     );
71 
72     /// @notice Emit to get credited for referral
73     /// @dev Our partner id is 0x0006
74     event PartnerSwap(bytes2 partnerId);
75 
76     /// Constructor ///
77 
78     /// @notice Initialize the contract.
79     /// @param _composer The contract address of the stargate composer router on the source chain.
80     constructor(IStargateRouter _composer) {
81         composer = _composer;
82     }
83 
84     /// Init ///
85 
86     /// @notice Initialize local variables for the Stargate Facet
87     /// @param chainIdConfigs Chain Id configuration data
88     function initStargate(ChainIdConfig[] calldata chainIdConfigs) external {
89         LibDiamond.enforceIsContractOwner();
90 
91         Storage storage sm = getStorage();
92 
93         for (uint256 i = 0; i < chainIdConfigs.length; i++) {
94             sm.layerZeroChainId[chainIdConfigs[i].chainId] = chainIdConfigs[i]
95                 .layerZeroChainId;
96         }
97 
98         sm.initialized = true;
99 
100         emit StargateInitialized(chainIdConfigs);
101     }
102 
103     /// External Methods ///
104 
105     /// @notice Bridges tokens via Stargate Bridge
106     /// @param _bridgeData Data used purely for tracking and analytics
107     /// @param _stargateData Data specific to Stargate Bridge
108     function startBridgeTokensViaStargate(
109         ILiFi.BridgeData calldata _bridgeData,
110         StargateData calldata _stargateData
111     )
112         external
113         payable
114         nonReentrant
115         refundExcessNative(payable(msg.sender))
116         doesNotContainSourceSwaps(_bridgeData)
117         validateBridgeData(_bridgeData)
118     {
119         validateDestinationCallFlag(_bridgeData, _stargateData);
120         LibAsset.depositAsset(
121             _bridgeData.sendingAssetId,
122             _bridgeData.minAmount
123         );
124         _startBridge(_bridgeData, _stargateData);
125     }
126 
127     /// @notice Performs a swap before bridging via Stargate Bridge
128     /// @param _bridgeData Data used purely for tracking and analytics
129     /// @param _swapData An array of swap related data for performing swaps before bridging
130     /// @param _stargateData Data specific to Stargate Bridge
131     function swapAndStartBridgeTokensViaStargate(
132         ILiFi.BridgeData memory _bridgeData,
133         LibSwap.SwapData[] calldata _swapData,
134         StargateData calldata _stargateData
135     )
136         external
137         payable
138         nonReentrant
139         refundExcessNative(payable(msg.sender))
140         containsSourceSwaps(_bridgeData)
141         validateBridgeData(_bridgeData)
142     {
143         validateDestinationCallFlag(_bridgeData, _stargateData);
144         _bridgeData.minAmount = _depositAndSwap(
145             _bridgeData.transactionId,
146             _bridgeData.minAmount,
147             _swapData,
148             payable(msg.sender),
149             LibAsset.isNativeAsset(_bridgeData.sendingAssetId)
150                 ? 0
151                 : _stargateData.lzFee
152         );
153 
154         _startBridge(_bridgeData, _stargateData);
155     }
156 
157     function quoteLayerZeroFee(
158         uint256 _destinationChainId,
159         StargateData calldata _stargateData
160     ) external view returns (uint256, uint256) {
161         return
162             composer.quoteLayerZeroFee(
163                 getLayerZeroChainId(_destinationChainId),
164                 1, // TYPE_SWAP_REMOTE on Bridge
165                 _stargateData.callTo,
166                 _stargateData.callData,
167                 IStargateRouter.lzTxObj(
168                     _stargateData.dstGasForCall,
169                     0,
170                     toBytes(address(0))
171                 )
172             );
173     }
174 
175     /// Private Methods ///
176 
177     /// @dev Contains the business logic for the bridge via Stargate Bridge
178     /// @param _bridgeData Data used purely for tracking and analytics
179     /// @param _stargateData Data specific to Stargate Bridge
180     function _startBridge(
181         ILiFi.BridgeData memory _bridgeData,
182         StargateData calldata _stargateData
183     ) private {
184         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
185             composer.swapETHAndCall{ value: _bridgeData.minAmount }(
186                 getLayerZeroChainId(_bridgeData.destinationChainId),
187                 _stargateData.refundAddress,
188                 _stargateData.callTo,
189                 IStargateRouter.SwapAmount(
190                     _bridgeData.minAmount - _stargateData.lzFee,
191                     _stargateData.minAmountLD
192                 ),
193                 IStargateRouter.lzTxObj(
194                     _stargateData.dstGasForCall,
195                     0,
196                     toBytes(address(0))
197                 ),
198                 _stargateData.callData
199             );
200         } else {
201             LibAsset.maxApproveERC20(
202                 IERC20(_bridgeData.sendingAssetId),
203                 address(composer),
204                 _bridgeData.minAmount
205             );
206 
207             composer.swap{ value: _stargateData.lzFee }(
208                 getLayerZeroChainId(_bridgeData.destinationChainId),
209                 _stargateData.srcPoolId,
210                 _stargateData.dstPoolId,
211                 _stargateData.refundAddress,
212                 _bridgeData.minAmount,
213                 _stargateData.minAmountLD,
214                 IStargateRouter.lzTxObj(
215                     _stargateData.dstGasForCall,
216                     0,
217                     toBytes(address(0))
218                 ),
219                 _stargateData.callTo,
220                 _stargateData.callData
221             );
222         }
223 
224         emit PartnerSwap(0x0006);
225 
226         emit LiFiTransferStarted(_bridgeData);
227     }
228 
229     function validateDestinationCallFlag(
230         ILiFi.BridgeData memory _bridgeData,
231         StargateData calldata _stargateData
232     ) private pure {
233         if (
234             (_stargateData.callData.length > 0) !=
235             _bridgeData.hasDestinationCall
236         ) {
237             revert InformationMismatch();
238         }
239     }
240 
241     /// Mappings management ///
242 
243     /// @notice Sets the Layer 0 chain ID for a given chain ID
244     /// @param _chainId uint16 of the chain ID
245     /// @param _layerZeroChainId uint16 of the Layer 0 chain ID
246     /// @dev This is used to map a chain ID to its Layer 0 chain ID
247     function setLayerZeroChainId(
248         uint256 _chainId,
249         uint16 _layerZeroChainId
250     ) external {
251         LibDiamond.enforceIsContractOwner();
252         Storage storage sm = getStorage();
253 
254         if (!sm.initialized) {
255             revert NotInitialized();
256         }
257 
258         sm.layerZeroChainId[_chainId] = _layerZeroChainId;
259         emit LayerZeroChainIdSet(_chainId, _layerZeroChainId);
260     }
261 
262     /// @notice Gets the Layer 0 chain ID for a given chain ID
263     /// @param _chainId uint256 of the chain ID
264     /// @return uint16 of the Layer 0 chain ID
265     function getLayerZeroChainId(
266         uint256 _chainId
267     ) private view returns (uint16) {
268         Storage storage sm = getStorage();
269         uint16 chainId = sm.layerZeroChainId[_chainId];
270         if (chainId == 0) revert UnknownLayerZeroChain();
271         return chainId;
272     }
273 
274     function toBytes(address _address) private pure returns (bytes memory) {
275         return abi.encodePacked(_address);
276     }
277 
278     /// @dev fetch local storage
279     function getStorage() private pure returns (Storage storage s) {
280         bytes32 namespace = NAMESPACE;
281         // solhint-disable-next-line no-inline-assembly
282         assembly {
283             s.slot := namespace
284         }
285     }
286 }
