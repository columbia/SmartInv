1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { ISquidRouter } from "../Interfaces/ISquidRouter.sol";
6 import { ISquidMulticall } from "../Interfaces/ISquidMulticall.sol";
7 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
8 import { LibSwap } from "../Libraries/LibSwap.sol";
9 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
10 import { SwapperV2 } from "../Helpers/SwapperV2.sol";
11 import { Validatable } from "../Helpers/Validatable.sol";
12 import { LibBytes } from "../Libraries/LibBytes.sol";
13 import { InformationMismatch } from "../Errors/GenericErrors.sol";
14 import { ERC20 } from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
15 
16 /// @title Squid Facet
17 /// @author LI.FI (https://li.fi)
18 /// @notice Provides functionality for bridging through Squid Router
19 /// @custom:version 1.0.0
20 contract SquidFacet is ILiFi, ReentrancyGuard, SwapperV2, Validatable {
21     /// Types ///
22 
23     enum RouteType {
24         BridgeCall,
25         CallBridge,
26         CallBridgeCall
27     }
28 
29     /// @dev Contains the data needed for bridging via Squid squidRouter
30     /// @param RouteType The type of route to use
31     /// @param destinationChain The chain to bridge tokens to
32     /// @param destinationAddress The receiver address in dst chain format
33     /// @param bridgedTokenSymbol The symbol of the to-be-bridged token
34     /// @param depositAssetId The asset to be deposited on src network (input for optional Squid-internal src swaps)
35     /// @param sourceCalls The calls to be made by Squid on the source chain before bridging the bridgeData.sendingAsssetId token
36     /// @param payload The payload for the calls to be made at dest chain
37     /// @param fee The fee to be payed in native token on src chain
38     /// @param enableExpress enable Squid Router's instant execution service
39     struct SquidData {
40         RouteType routeType;
41         string destinationChain;
42         string destinationAddress; // required to allow future bridging to non-EVM networks
43         string bridgedTokenSymbol;
44         address depositAssetId;
45         ISquidMulticall.Call[] sourceCalls;
46         bytes payload;
47         uint256 fee;
48         bool enableExpress;
49     }
50 
51     // introduced to tacke a stack-too-deep error
52     struct BridgeContext {
53         ILiFi.BridgeData bridgeData;
54         SquidData squidData;
55         uint256 msgValue;
56     }
57 
58     /// Errors ///
59     error InvalidRouteType();
60 
61     /// State ///
62 
63     ISquidRouter private immutable squidRouter;
64 
65     /// Constructor ///
66 
67     constructor(ISquidRouter _squidRouter) {
68         squidRouter = _squidRouter;
69     }
70 
71     /// External Methods ///
72 
73     /// @notice Bridges tokens via Squid Router
74     /// @param _bridgeData The core information needed for bridging
75     /// @param _squidData Data specific to Squid Router
76     function startBridgeTokensViaSquid(
77         ILiFi.BridgeData memory _bridgeData,
78         SquidData calldata _squidData
79     )
80         external
81         payable
82         nonReentrant
83         refundExcessNative(payable(msg.sender))
84         doesNotContainSourceSwaps(_bridgeData)
85         validateBridgeData(_bridgeData)
86     {
87         LibAsset.depositAsset(
88             _squidData.depositAssetId,
89             _bridgeData.minAmount
90         );
91 
92         _startBridge(_bridgeData, _squidData);
93     }
94 
95     /// @notice Swaps and bridges tokens via Squid Router
96     /// @param _bridgeData The core information needed for bridging
97     /// @param _swapData An array of swap related data for performing swaps before bridging
98     /// @param _squidData Data specific to Squid Router
99     function swapAndStartBridgeTokensViaSquid(
100         ILiFi.BridgeData memory _bridgeData,
101         LibSwap.SwapData[] calldata _swapData,
102         SquidData calldata _squidData
103     )
104         external
105         payable
106         nonReentrant
107         refundExcessNative(payable(msg.sender))
108         containsSourceSwaps(_bridgeData)
109         validateBridgeData(_bridgeData)
110     {
111         // in case of native we need to keep the fee as reserve from the swap
112         _bridgeData.minAmount = _depositAndSwap(
113             _bridgeData.transactionId,
114             _bridgeData.minAmount,
115             _swapData,
116             payable(msg.sender),
117             _squidData.fee
118         );
119 
120         _startBridge(_bridgeData, _squidData);
121     }
122 
123     /// Internal Methods ///
124 
125     /// @dev Contains the business logic for the bridge via Squid Router
126     /// @param _bridgeData The core information needed for bridging
127     /// @param _squidData Data specific to Squid Router
128     function _startBridge(
129         ILiFi.BridgeData memory _bridgeData,
130         SquidData calldata _squidData
131     ) internal {
132         BridgeContext memory context = BridgeContext({
133             bridgeData: _bridgeData,
134             squidData: _squidData,
135             msgValue: _calculateMsgValue(_bridgeData, _squidData)
136         });
137 
138         // ensure max approval if non-native asset
139         if (!LibAsset.isNativeAsset(context.squidData.depositAssetId)) {
140             LibAsset.maxApproveERC20(
141                 IERC20(context.squidData.depositAssetId),
142                 address(squidRouter),
143                 context.bridgeData.minAmount
144             );
145         }
146 
147         // make the call to Squid router based on RouteType
148         if (_squidData.routeType == RouteType.BridgeCall) {
149             _bridgeCall(context);
150         } else if (_squidData.routeType == RouteType.CallBridge) {
151             _callBridge(context);
152         } else if (_squidData.routeType == RouteType.CallBridgeCall) {
153             _callBridgeCall(context);
154         } else {
155             revert InvalidRouteType();
156         }
157 
158         emit LiFiTransferStarted(_bridgeData);
159     }
160 
161     function _bridgeCall(BridgeContext memory _context) internal {
162         squidRouter.bridgeCall{ value: _context.msgValue }(
163             _context.squidData.bridgedTokenSymbol,
164             _context.bridgeData.minAmount,
165             _context.squidData.destinationChain,
166             _context.squidData.destinationAddress,
167             _context.squidData.payload,
168             _context.bridgeData.receiver,
169             _context.squidData.enableExpress
170         );
171     }
172 
173     function _callBridge(BridgeContext memory _context) private {
174         squidRouter.callBridge{ value: _context.msgValue }(
175             LibAsset.isNativeAsset(_context.squidData.depositAssetId)
176                 ? 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
177                 : _context.squidData.depositAssetId,
178             _context.bridgeData.minAmount,
179             _context.squidData.sourceCalls,
180             _context.squidData.bridgedTokenSymbol,
181             _context.squidData.destinationChain,
182             LibBytes.toHexString(uint160(_context.bridgeData.receiver), 20)
183         );
184     }
185 
186     function _callBridgeCall(BridgeContext memory _context) private {
187         squidRouter.callBridgeCall{ value: _context.msgValue }(
188             LibAsset.isNativeAsset(_context.squidData.depositAssetId)
189                 ? 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
190                 : _context.squidData.depositAssetId,
191             _context.bridgeData.minAmount,
192             _context.squidData.sourceCalls,
193             _context.squidData.bridgedTokenSymbol,
194             _context.squidData.destinationChain,
195             _context.squidData.destinationAddress,
196             _context.squidData.payload,
197             _context.bridgeData.receiver,
198             _context.squidData.enableExpress
199         );
200     }
201 
202     function _calculateMsgValue(
203         ILiFi.BridgeData memory _bridgeData,
204         SquidData calldata _squidData
205     ) private pure returns (uint256) {
206         uint256 msgValue = _squidData.fee;
207         if (LibAsset.isNativeAsset(_bridgeData.sendingAssetId)) {
208             msgValue += _bridgeData.minAmount;
209         }
210         return msgValue;
211     }
212 }
