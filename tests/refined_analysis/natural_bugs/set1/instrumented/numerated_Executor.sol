1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 import { ReentrancyGuard } from "../Helpers/ReentrancyGuard.sol";
5 import { LibSwap } from "../Libraries/LibSwap.sol";
6 import { LibAsset } from "../Libraries/LibAsset.sol";
7 import { UnAuthorized } from "lifi/Errors/GenericErrors.sol";
8 import { ILiFi } from "../Interfaces/ILiFi.sol";
9 import { IERC20Proxy } from "../Interfaces/IERC20Proxy.sol";
10 import { ERC1155Holder } from "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
11 import { ERC721Holder } from "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
12 import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
13 
14 /// @title Executor
15 /// @author LI.FI (https://li.fi)
16 /// @notice Arbitrary execution contract used for cross-chain swaps and message passing
17 /// @custom:version 2.0.0
18 contract Executor is ILiFi, ReentrancyGuard, ERC1155Holder, ERC721Holder {
19     /// Storage ///
20 
21     /// @notice The address of the ERC20Proxy contract
22     IERC20Proxy public erc20Proxy;
23 
24     /// Events ///
25     event ERC20ProxySet(address indexed proxy);
26 
27     /// Modifiers ///
28 
29     /// @dev Sends any leftover balances back to the user
30     modifier noLeftovers(
31         LibSwap.SwapData[] calldata _swaps,
32         address payable _leftoverReceiver
33     ) {
34         uint256 numSwaps = _swaps.length;
35         if (numSwaps != 1) {
36             uint256[] memory initialBalances = _fetchBalances(_swaps);
37             address finalAsset = _swaps[numSwaps - 1].receivingAssetId;
38             uint256 curBalance = 0;
39 
40             _;
41 
42             for (uint256 i = 0; i < numSwaps - 1; ) {
43                 address curAsset = _swaps[i].receivingAssetId;
44                 // Handle multi-to-one swaps
45                 if (curAsset != finalAsset) {
46                     curBalance = LibAsset.getOwnBalance(curAsset);
47                     if (curBalance > initialBalances[i]) {
48                         LibAsset.transferAsset(
49                             curAsset,
50                             _leftoverReceiver,
51                             curBalance - initialBalances[i]
52                         );
53                     }
54                 }
55                 unchecked {
56                     ++i;
57                 }
58             }
59         } else {
60             _;
61         }
62     }
63 
64     /// Constructor
65     /// @notice Initialize local variables for the Executor
66     /// @param _erc20Proxy The address of the ERC20Proxy contract
67     constructor(address _erc20Proxy) {
68         erc20Proxy = IERC20Proxy(_erc20Proxy);
69         emit ERC20ProxySet(_erc20Proxy);
70     }
71 
72     /// External Methods ///
73 
74     /// @notice Performs a swap before completing a cross-chain transaction
75     /// @param _transactionId the transaction id for the swap
76     /// @param _swapData array of data needed for swaps
77     /// @param _transferredAssetId token received from the other chain
78     /// @param _receiver address that will receive tokens in the end
79     function swapAndCompleteBridgeTokens(
80         bytes32 _transactionId,
81         LibSwap.SwapData[] calldata _swapData,
82         address _transferredAssetId,
83         address payable _receiver
84     ) external payable nonReentrant {
85         _processSwaps(
86             _transactionId,
87             _swapData,
88             _transferredAssetId,
89             _receiver,
90             0,
91             true
92         );
93     }
94 
95     /// @notice Performs a series of swaps or arbitrary executions
96     /// @param _transactionId the transaction id for the swap
97     /// @param _swapData array of data needed for swaps
98     /// @param _transferredAssetId token received from the other chain
99     /// @param _receiver address that will receive tokens in the end
100     /// @param _amount amount of token for swaps or arbitrary executions
101     function swapAndExecute(
102         bytes32 _transactionId,
103         LibSwap.SwapData[] calldata _swapData,
104         address _transferredAssetId,
105         address payable _receiver,
106         uint256 _amount
107     ) external payable nonReentrant {
108         _processSwaps(
109             _transactionId,
110             _swapData,
111             _transferredAssetId,
112             _receiver,
113             _amount,
114             false
115         );
116     }
117 
118     /// Private Methods ///
119 
120     /// @notice Performs a series of swaps or arbitrary executions
121     /// @param _transactionId the transaction id for the swap
122     /// @param _swapData array of data needed for swaps
123     /// @param _transferredAssetId token received from the other chain
124     /// @param _receiver address that will receive tokens in the end
125     /// @param _amount amount of token for swaps or arbitrary executions
126     /// @param _depositAllowance If deposit approved amount of token
127     function _processSwaps(
128         bytes32 _transactionId,
129         LibSwap.SwapData[] calldata _swapData,
130         address _transferredAssetId,
131         address payable _receiver,
132         uint256 _amount,
133         bool _depositAllowance
134     ) private {
135         uint256 startingBalance;
136         uint256 finalAssetStartingBalance;
137         address finalAssetId = _swapData[_swapData.length - 1]
138             .receivingAssetId;
139         if (!LibAsset.isNativeAsset(finalAssetId)) {
140             finalAssetStartingBalance = LibAsset.getOwnBalance(finalAssetId);
141         } else {
142             finalAssetStartingBalance =
143                 LibAsset.getOwnBalance(finalAssetId) -
144                 msg.value;
145         }
146 
147         if (!LibAsset.isNativeAsset(_transferredAssetId)) {
148             startingBalance = LibAsset.getOwnBalance(_transferredAssetId);
149             if (_depositAllowance) {
150                 uint256 allowance = IERC20(_transferredAssetId).allowance(
151                     msg.sender,
152                     address(this)
153                 );
154                 LibAsset.depositAsset(_transferredAssetId, allowance);
155             } else {
156                 erc20Proxy.transferFrom(
157                     _transferredAssetId,
158                     msg.sender,
159                     address(this),
160                     _amount
161                 );
162             }
163         } else {
164             startingBalance =
165                 LibAsset.getOwnBalance(_transferredAssetId) -
166                 msg.value;
167         }
168 
169         _executeSwaps(_transactionId, _swapData, _receiver);
170 
171         uint256 postSwapBalance = LibAsset.getOwnBalance(_transferredAssetId);
172         if (postSwapBalance > startingBalance) {
173             LibAsset.transferAsset(
174                 _transferredAssetId,
175                 _receiver,
176                 postSwapBalance - startingBalance
177             );
178         }
179 
180         uint256 finalAssetPostSwapBalance = LibAsset.getOwnBalance(
181             finalAssetId
182         );
183 
184         if (finalAssetPostSwapBalance > finalAssetStartingBalance) {
185             LibAsset.transferAsset(
186                 finalAssetId,
187                 _receiver,
188                 finalAssetPostSwapBalance - finalAssetStartingBalance
189             );
190         }
191 
192         emit LiFiTransferCompleted(
193             _transactionId,
194             _transferredAssetId,
195             _receiver,
196             finalAssetPostSwapBalance,
197             block.timestamp
198         );
199     }
200 
201     /// @dev Executes swaps one after the other
202     /// @param _transactionId the transaction id for the swap
203     /// @param _swapData Array of data used to execute swaps
204     /// @param _leftoverReceiver Address to receive lefover tokens
205     function _executeSwaps(
206         bytes32 _transactionId,
207         LibSwap.SwapData[] calldata _swapData,
208         address payable _leftoverReceiver
209     ) private noLeftovers(_swapData, _leftoverReceiver) {
210         uint256 numSwaps = _swapData.length;
211         for (uint256 i = 0; i < numSwaps; ) {
212             if (_swapData[i].callTo == address(erc20Proxy)) {
213                 revert UnAuthorized(); // Prevent calling ERC20 Proxy directly
214             }
215 
216             LibSwap.SwapData calldata currentSwapData = _swapData[i];
217             LibSwap.swap(_transactionId, currentSwapData);
218             unchecked {
219                 ++i;
220             }
221         }
222     }
223 
224     /// @dev Fetches balances of tokens to be swapped before swapping.
225     /// @param _swapData Array of data used to execute swaps
226     /// @return uint256[] Array of token balances.
227     function _fetchBalances(
228         LibSwap.SwapData[] calldata _swapData
229     ) private view returns (uint256[] memory) {
230         uint256 numSwaps = _swapData.length;
231         uint256[] memory balances = new uint256[](numSwaps);
232         address asset;
233         for (uint256 i = 0; i < numSwaps; ) {
234             asset = _swapData[i].receivingAssetId;
235             balances[i] = LibAsset.getOwnBalance(asset);
236 
237             if (LibAsset.isNativeAsset(asset)) {
238                 balances[i] -= msg.value;
239             }
240 
241             unchecked {
242                 ++i;
243             }
244         }
245 
246         return balances;
247     }
248 
249     /// @dev required for receiving native assets from destination swaps
250     // solhint-disable-next-line no-empty-blocks
251     receive() external payable {}
252 }
