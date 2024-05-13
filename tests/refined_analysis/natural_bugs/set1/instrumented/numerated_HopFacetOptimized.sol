1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ILiFi } from "../Interfaces/ILiFi.sol";
5 import { IHopBridge } from "../Interfaces/IHopBridge.sol";
6 import { LibAsset, IERC20 } from "../Libraries/LibAsset.sol";
7 import { SwapperV2, LibSwap } from "../Helpers/SwapperV2.sol";
8 import { LibDiamond } from "../Libraries/LibDiamond.sol";
9 
10 /// @title Hop Facet (Optimized)
11 /// @author LI.FI (https://li.fi)
12 /// @notice Provides functionality for bridging through Hop
13 /// @custom:version 2.0.0
14 contract HopFacetOptimized is ILiFi, SwapperV2 {
15     /// Types ///
16 
17     struct HopData {
18         uint256 bonderFee;
19         uint256 amountOutMin;
20         uint256 deadline;
21         uint256 destinationAmountOutMin;
22         uint256 destinationDeadline;
23         IHopBridge hopBridge;
24         address relayer;
25         uint256 relayerFee;
26         uint256 nativeFee;
27     }
28 
29     /// External Methods ///
30 
31     /// @notice Sets approval for the Hop Bridge to spend the specified token
32     /// @param bridges The Hop Bridges to approve
33     /// @param tokensToApprove The tokens to approve to approve to the Hop Bridges
34     function setApprovalForBridges(
35         address[] calldata bridges,
36         address[] calldata tokensToApprove
37     ) external {
38         LibDiamond.enforceIsContractOwner();
39         for (uint256 i; i < bridges.length; i++) {
40             // Give Hop approval to bridge tokens
41             LibAsset.maxApproveERC20(
42                 IERC20(tokensToApprove[i]),
43                 address(bridges[i]),
44                 type(uint256).max
45             );
46         }
47     }
48 
49     /// @notice Bridges ERC20 tokens via Hop Protocol from L1
50     /// @param _bridgeData the core information needed for bridging
51     /// @param _hopData data specific to Hop Protocol
52     function startBridgeTokensViaHopL1ERC20(
53         ILiFi.BridgeData calldata _bridgeData,
54         HopData calldata _hopData
55     ) external payable {
56         // Deposit assets
57         LibAsset.transferFromERC20(
58             _bridgeData.sendingAssetId,
59             msg.sender,
60             address(this),
61             _bridgeData.minAmount
62         );
63         // Bridge assets
64         _hopData.hopBridge.sendToL2{ value: _hopData.nativeFee }(
65             _bridgeData.destinationChainId,
66             _bridgeData.receiver,
67             _bridgeData.minAmount,
68             _hopData.destinationAmountOutMin,
69             _hopData.destinationDeadline,
70             _hopData.relayer,
71             _hopData.relayerFee
72         );
73         emit LiFiTransferStarted(_bridgeData);
74     }
75 
76     /// @notice Bridges Native tokens via Hop Protocol from L1
77     /// @param _bridgeData the core information needed for bridging
78     /// @param _hopData data specific to Hop Protocol
79     function startBridgeTokensViaHopL1Native(
80         ILiFi.BridgeData calldata _bridgeData,
81         HopData calldata _hopData
82     ) external payable {
83         // Bridge assets
84         _hopData.hopBridge.sendToL2{
85             value: _bridgeData.minAmount + _hopData.nativeFee
86         }(
87             _bridgeData.destinationChainId,
88             _bridgeData.receiver,
89             _bridgeData.minAmount,
90             _hopData.destinationAmountOutMin,
91             _hopData.destinationDeadline,
92             _hopData.relayer,
93             _hopData.relayerFee
94         );
95         emit LiFiTransferStarted(_bridgeData);
96     }
97 
98     /// @notice Performs a swap before bridging ERC20 tokens via Hop Protocol from L1
99     /// @param _bridgeData the core information needed for bridging
100     /// @param _swapData an array of swap related data for performing swaps before bridging
101     /// @param _hopData data specific to Hop Protocol
102     function swapAndStartBridgeTokensViaHopL1ERC20(
103         ILiFi.BridgeData memory _bridgeData,
104         LibSwap.SwapData[] calldata _swapData,
105         HopData calldata _hopData
106     ) external payable {
107         // Deposit and swap assets
108         _bridgeData.minAmount = _depositAndSwap(
109             _bridgeData.transactionId,
110             _bridgeData.minAmount,
111             _swapData,
112             payable(msg.sender),
113             _hopData.nativeFee
114         );
115 
116         // Bridge assets
117         _hopData.hopBridge.sendToL2{ value: _hopData.nativeFee }(
118             _bridgeData.destinationChainId,
119             _bridgeData.receiver,
120             _bridgeData.minAmount,
121             _hopData.destinationAmountOutMin,
122             _hopData.destinationDeadline,
123             _hopData.relayer,
124             _hopData.relayerFee
125         );
126         emit LiFiTransferStarted(_bridgeData);
127     }
128 
129     /// @notice Performs a swap before bridging Native tokens via Hop Protocol from L1
130     /// @param _bridgeData the core information needed for bridging
131     /// @param _swapData an array of swap related data for performing swaps before bridging
132     /// @param _hopData data specific to Hop Protocol
133     function swapAndStartBridgeTokensViaHopL1Native(
134         ILiFi.BridgeData memory _bridgeData,
135         LibSwap.SwapData[] calldata _swapData,
136         HopData calldata _hopData
137     ) external payable {
138         // Deposit and swap assets
139         _bridgeData.minAmount = _depositAndSwap(
140             _bridgeData.transactionId,
141             _bridgeData.minAmount,
142             _swapData,
143             payable(msg.sender),
144             _hopData.nativeFee
145         );
146 
147         // Bridge assets
148         _hopData.hopBridge.sendToL2{
149             value: _bridgeData.minAmount + _hopData.nativeFee
150         }(
151             _bridgeData.destinationChainId,
152             _bridgeData.receiver,
153             _bridgeData.minAmount,
154             _hopData.destinationAmountOutMin,
155             _hopData.destinationDeadline,
156             _hopData.relayer,
157             _hopData.relayerFee
158         );
159 
160         emit LiFiTransferStarted(_bridgeData);
161     }
162 
163     /// @notice Bridges ERC20 tokens via Hop Protocol from L2
164     /// @param _bridgeData the core information needed for bridging
165     /// @param _hopData data specific to Hop Protocol
166     function startBridgeTokensViaHopL2ERC20(
167         ILiFi.BridgeData calldata _bridgeData,
168         HopData calldata _hopData
169     ) external {
170         // Deposit assets
171         LibAsset.transferFromERC20(
172             _bridgeData.sendingAssetId,
173             msg.sender,
174             address(this),
175             _bridgeData.minAmount
176         );
177         // Bridge assets
178         _hopData.hopBridge.swapAndSend(
179             _bridgeData.destinationChainId,
180             _bridgeData.receiver,
181             _bridgeData.minAmount,
182             _hopData.bonderFee,
183             _hopData.amountOutMin,
184             _hopData.deadline,
185             _hopData.destinationAmountOutMin,
186             _hopData.destinationDeadline
187         );
188         emit LiFiTransferStarted(_bridgeData);
189     }
190 
191     /// @notice Bridges Native tokens via Hop Protocol from L2
192     /// @param _bridgeData the core information needed for bridging
193     /// @param _hopData data specific to Hop Protocol
194     function startBridgeTokensViaHopL2Native(
195         ILiFi.BridgeData calldata _bridgeData,
196         HopData calldata _hopData
197     ) external payable {
198         // Bridge assets
199         _hopData.hopBridge.swapAndSend{ value: _bridgeData.minAmount }(
200             _bridgeData.destinationChainId,
201             _bridgeData.receiver,
202             _bridgeData.minAmount,
203             _hopData.bonderFee,
204             _hopData.amountOutMin,
205             _hopData.deadline,
206             _hopData.destinationAmountOutMin,
207             _hopData.destinationDeadline
208         );
209         emit LiFiTransferStarted(_bridgeData);
210     }
211 
212     /// @notice Performs a swap before bridging ERC20 tokens via Hop Protocol from L2
213     /// @param _bridgeData the core information needed for bridging
214     /// @param _swapData an array of swap related data for performing swaps before bridging
215     /// @param _hopData data specific to Hop Protocol
216     function swapAndStartBridgeTokensViaHopL2ERC20(
217         ILiFi.BridgeData memory _bridgeData,
218         LibSwap.SwapData[] calldata _swapData,
219         HopData calldata _hopData
220     ) external payable {
221         // Deposit and swap assets
222         _bridgeData.minAmount = _depositAndSwap(
223             _bridgeData.transactionId,
224             _bridgeData.minAmount,
225             _swapData,
226             payable(msg.sender)
227         );
228         // Bridge assets
229         _hopData.hopBridge.swapAndSend(
230             _bridgeData.destinationChainId,
231             _bridgeData.receiver,
232             _bridgeData.minAmount,
233             _hopData.bonderFee,
234             _hopData.amountOutMin,
235             _hopData.deadline,
236             _hopData.destinationAmountOutMin,
237             _hopData.destinationDeadline
238         );
239         emit LiFiTransferStarted(_bridgeData);
240     }
241 
242     /// @notice Performs a swap before bridging Native tokens via Hop Protocol from L2
243     /// @param _bridgeData the core information needed for bridging
244     /// @param _swapData an array of swap related data for performing swaps before bridging
245     /// @param _hopData data specific to Hop Protocol
246     function swapAndStartBridgeTokensViaHopL2Native(
247         ILiFi.BridgeData memory _bridgeData,
248         LibSwap.SwapData[] calldata _swapData,
249         HopData calldata _hopData
250     ) external payable {
251         // Deposit and swap assets
252         _bridgeData.minAmount = _depositAndSwap(
253             _bridgeData.transactionId,
254             _bridgeData.minAmount,
255             _swapData,
256             payable(msg.sender)
257         );
258         // Bridge assets
259         _hopData.hopBridge.swapAndSend{ value: _bridgeData.minAmount }(
260             _bridgeData.destinationChainId,
261             _bridgeData.receiver,
262             _bridgeData.minAmount,
263             _hopData.bonderFee,
264             _hopData.amountOutMin,
265             _hopData.deadline,
266             _hopData.destinationAmountOutMin,
267             _hopData.destinationDeadline
268         );
269         emit LiFiTransferStarted(_bridgeData);
270     }
271 }
