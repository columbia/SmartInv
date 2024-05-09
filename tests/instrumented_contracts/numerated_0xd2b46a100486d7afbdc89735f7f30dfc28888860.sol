1 // File: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: 4_deploy-defarm/Optimiser/SafeMath.sol
146 
147 pragma solidity ^0.6.12;
148 
149 // ----------------------------------------------------------------------------
150 // Safe maths
151 // ----------------------------------------------------------------------------
152 library SafeMath {
153     function add(uint a, uint b) internal pure returns (uint c) {
154         c = a + b;
155         require(c >= a, 'SafeMath:INVALID_ADD');
156     }
157 
158     function sub(uint a, uint b) internal pure returns (uint c) {
159         require(b <= a, 'SafeMath:OVERFLOW_SUB');
160         c = a - b;
161     }
162 
163     function mul(uint a, uint b, uint decimal) internal pure returns (uint) {
164         uint dc = 10**decimal;
165         uint c0 = a * b;
166         require(a == 0 || c0 / a == b, "SafeMath: multiple overflow");
167         uint c1 = c0 + (dc / 2);
168         require(c1 >= c0, "SafeMath: multiple overflow");
169         uint c2 = c1 / dc;
170         return c2;
171     }
172 
173     function div(uint256 a, uint256 b, uint decimal) internal pure returns (uint256) {
174         require(b != 0, "SafeMath: division by zero");
175         uint dc = 10**decimal;
176         uint c0 = a * dc;
177         require(a == 0 || c0 / a == dc, "SafeMath: division internal");
178         uint c1 = c0 + (b / 2);
179         require(c1 >= c0, "SafeMath: division internal");
180         uint c2 = c1 / b;
181         return c2;
182     }
183 }
184 
185 // File: 4_deploy-defarm/Optimiser/TransferHelper.sol
186 
187 pragma solidity ^0.6.12;
188 
189 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
190 library TransferHelper {
191     function safeApprove(
192         address token,
193         address to,
194         uint256 value
195     ) internal {
196         // bytes4(keccak256(bytes('approve(address,uint256)')));
197         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
198         require(
199             success && (data.length == 0 || abi.decode(data, (bool))),
200             'TransferHelper::safeApprove: approve failed'
201         );
202     }
203 
204     function safeTransfer(
205         address token,
206         address to,
207         uint256 value
208     ) internal {
209         // bytes4(keccak256(bytes('transfer(address,uint256)')));
210         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
211         require(
212             success && (data.length == 0 || abi.decode(data, (bool))),
213             'TransferHelper::safeTransfer: transfer failed'
214         );
215     }
216 
217     function safeTransferFrom(
218         address token,
219         address from,
220         address to,
221         uint256 value
222     ) internal {
223         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
224         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
225         require(
226             success && (data.length == 0 || abi.decode(data, (bool))),
227             'TransferHelper::transferFrom: transferFrom failed'
228         );
229     }
230 
231     function safeTransferETH(address to, uint256 value) internal {
232         (bool success, ) = to.call{value: value}(new bytes(0));
233         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
234     }
235 }
236 
237 // File: 4_deploy-defarm/Optimiser/UniformRandomNumber.sol
238 
239 /**
240 Copyright 2019 PoolTogether LLC
241 
242 This file is part of PoolTogether.
243 
244 PoolTogether is free software: you can redistribute it and/or modify
245 it under the terms of the GNU General Public License as published by
246 the Free Software Foundation under version 3 of the License.
247 
248 PoolTogether is distributed in the hope that it will be useful,
249 but WITHOUT ANY WARRANTY; without even the implied warranty of
250 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
251 GNU General Public License for more details.
252 
253 You should have received a copy of the GNU General Public License
254 along with PoolTogether.  If not, see <https://www.gnu.org/licenses/>.
255 */
256 
257 pragma solidity 0.6.12;
258 
259 /**
260  * @author Brendan Asselstine
261  * @notice A library that uses entropy to select a random number within a bound.  Compensates for modulo bias.
262  * @dev Thanks to https://medium.com/hownetworks/dont-waste-cycles-with-modulo-bias-35b6fdafcf94
263  */
264 library UniformRandomNumber {
265   /// @notice Select a random number without modulo bias using a random seed and upper bound
266   /// @param _entropy The seed for randomness
267   /// @param _upperBound The upper bound of the desired number
268   /// @return A random number less than the _upperBound
269   function uniform(uint256 _entropy, uint256 _upperBound) internal pure returns (uint256) {
270     require(_upperBound > 0, "UniformRand/min-bound");
271     uint256 min = -_upperBound % _upperBound;
272     uint256 random = _entropy;
273     while (true) {
274       if (random >= min) {
275         break;
276       }
277       random = uint256(keccak256(abi.encodePacked(random)));
278     }
279     return random % _upperBound;
280   }
281 }
282 
283 
284 // File: 4_deploy-defarm/Optimiser/SortitionSumTreeFactory.sol
285 
286 pragma solidity ^0.6.12;
287 
288 /**
289  *  @reviewers: [@clesaege, @unknownunknown1, @ferittuncer]
290  *  @auditors: []
291  *  @bounties: [<14 days 10 ETH max payout>]
292  *  @deployments: []
293  */
294 
295 /**
296  *  @title SortitionSumTreeFactory
297  *  @author Enrique Piqueras - <epiquerass@gmail.com>
298  *  @dev A factory of trees that keep track of staked values for sortition.
299  */
300 library SortitionSumTreeFactory {
301     /* Structs */
302 
303     struct SortitionSumTree {
304         uint K; // The maximum number of childs per node.
305         // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
306         uint[] stack;
307         uint[] nodes;
308         // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
309         mapping(bytes32 => uint) IDsToNodeIndexes;
310         mapping(uint => bytes32) nodeIndexesToIDs;
311     }
312 
313     /* Storage */
314 
315     struct SortitionSumTrees {
316         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
317     }
318 
319     /* internal */
320 
321     /**
322      *  @dev Create a sortition sum tree at the specified key.
323      *  @param _key The key of the new tree.
324      *  @param _K The number of children each node in the tree should have.
325      */
326     function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) internal {
327         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
328         require(tree.K == 0, "Tree already exists.");
329         require(_K > 1, "K must be greater than one.");
330         tree.K = _K;
331         tree.stack = new uint[](0);
332         tree.nodes = new uint[](0);
333         tree.nodes.push(0);
334     }
335 
336     /**
337      *  @dev Set a value of a tree.
338      *  @param _key The key of the tree.
339      *  @param _value The new value.
340      *  @param _ID The ID of the value.
341      *  `O(log_k(n))` where
342      *  `k` is the maximum number of childs per node in the tree,
343      *   and `n` is the maximum number of nodes ever appended.
344      */
345     function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) internal {
346         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
347         uint treeIndex = tree.IDsToNodeIndexes[_ID];
348 
349         if (treeIndex == 0) { // No existing node.
350             if (_value != 0) { // Non zero value.
351                 // Append.
352                 // Add node.
353                 if (tree.stack.length == 0) { // No vacant spots.
354                     // Get the index and append the value.
355                     treeIndex = tree.nodes.length;
356                     tree.nodes.push(_value);
357 
358                     // Potentially append a new node and make the parent a sum node.
359                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) { // Is first child.
360                         uint parentIndex = treeIndex / tree.K;
361                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
362                         uint newIndex = treeIndex + 1;
363                         tree.nodes.push(tree.nodes[parentIndex]);
364                         delete tree.nodeIndexesToIDs[parentIndex];
365                         tree.IDsToNodeIndexes[parentID] = newIndex;
366                         tree.nodeIndexesToIDs[newIndex] = parentID;
367                     }
368                 } else { // Some vacant spot.
369                     // Pop the stack and append the value.
370                     treeIndex = tree.stack[tree.stack.length - 1];
371                     tree.stack.pop();
372                     tree.nodes[treeIndex] = _value;
373                 }
374 
375                 // Add label.
376                 tree.IDsToNodeIndexes[_ID] = treeIndex;
377                 tree.nodeIndexesToIDs[treeIndex] = _ID;
378 
379                 updateParents(self, _key, treeIndex, true, _value);
380             }
381         } else { // Existing node.
382             if (_value == 0) { // Zero value.
383                 // Remove.
384                 // Remember value and set to 0.
385                 uint value = tree.nodes[treeIndex];
386                 tree.nodes[treeIndex] = 0;
387 
388                 // Push to stack.
389                 tree.stack.push(treeIndex);
390 
391                 // Clear label.
392                 delete tree.IDsToNodeIndexes[_ID];
393                 delete tree.nodeIndexesToIDs[treeIndex];
394 
395                 updateParents(self, _key, treeIndex, false, value);
396             } else if (_value != tree.nodes[treeIndex]) { // New, non zero value.
397                 // Set.
398                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
399                 uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
400                 tree.nodes[treeIndex] = _value;
401 
402                 updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
403             }
404         }
405     }
406 
407     /* internal Views */
408 
409     /**
410      *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
411      *  @param _key The key of the tree to get the leaves from.
412      *  @param _cursor The pagination cursor.
413      *  @param _count The number of items to return.
414      *  @return startIndex The index at which leaves start
415      *  @return values The values of the returned leaves
416      *  @return hasMore Whether there are more for pagination.
417      *  `O(n)` where
418      *  `n` is the maximum number of nodes ever appended.
419      */
420     function queryLeafs(
421         SortitionSumTrees storage self,
422         bytes32 _key,
423         uint _cursor,
424         uint _count
425     ) internal view returns(uint startIndex, uint[] memory values, bool hasMore) {
426         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
427 
428         // Find the start index.
429         for (uint i = 0; i < tree.nodes.length; i++) {
430             if ((tree.K * i) + 1 >= tree.nodes.length) {
431                 startIndex = i;
432                 break;
433             }
434         }
435 
436         // Get the values.
437         uint loopStartIndex = startIndex + _cursor;
438         values = new uint[](loopStartIndex + _count > tree.nodes.length ? tree.nodes.length - loopStartIndex : _count);
439         uint valuesIndex = 0;
440         for (uint j = loopStartIndex; j < tree.nodes.length; j++) {
441             if (valuesIndex < _count) {
442                 values[valuesIndex] = tree.nodes[j];
443                 valuesIndex++;
444             } else {
445                 hasMore = true;
446                 break;
447             }
448         }
449     }
450 
451     /**
452      *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
453      *  @param _key The key of the tree.
454      *  @param _drawnNumber The drawn number.
455      *  @return ID The drawn ID.
456      *  `O(k * log_k(n))` where
457      *  `k` is the maximum number of childs per node in the tree,
458      *   and `n` is the maximum number of nodes ever appended.
459      */
460     function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) internal view returns(bytes32 ID) {
461         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
462         uint treeIndex = 0;
463         uint currentDrawnNumber = _drawnNumber % tree.nodes[0];
464 
465         while ((tree.K * treeIndex) + 1 < tree.nodes.length)  // While it still has children.
466             for (uint i = 1; i <= tree.K; i++) { // Loop over children.
467                 uint nodeIndex = (tree.K * treeIndex) + i;
468                 uint nodeValue = tree.nodes[nodeIndex];
469 
470                 if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue; // Go to the next child.
471                 else { // Pick this child.
472                     treeIndex = nodeIndex;
473                     break;
474                 }
475             }
476         
477         ID = tree.nodeIndexesToIDs[treeIndex];
478     }
479 
480     /** @dev Gets a specified ID's associated value.
481      *  @param _key The key of the tree.
482      *  @param _ID The ID of the value.
483      *  @return value The associated value.
484      */
485     function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) internal view returns(uint value) {
486         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
487         uint treeIndex = tree.IDsToNodeIndexes[_ID];
488 
489         if (treeIndex == 0) value = 0;
490         else value = tree.nodes[treeIndex];
491     }
492 
493     function total(SortitionSumTrees storage self, bytes32 _key) internal view returns (uint) {
494         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
495         if (tree.nodes.length == 0) {
496             return 0;
497         } else {
498             return tree.nodes[0];
499         }
500     }
501 
502     /* Private */
503 
504     /**
505      *  @dev Update all the parents of a node.
506      *  @param _key The key of the tree to update.
507      *  @param _treeIndex The index of the node to start from.
508      *  @param _plusOrMinus Wether to add (true) or substract (false).
509      *  @param _value The value to add or substract.
510      *  `O(log_k(n))` where
511      *  `k` is the maximum number of childs per node in the tree,
512      *   and `n` is the maximum number of nodes ever appended.
513      */
514     function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
515         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
516 
517         uint parentIndex = _treeIndex;
518         while (parentIndex != 0) {
519             parentIndex = (parentIndex - 1) / tree.K;
520             tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
521         }
522     }
523 }
524 // File: 4_deploy-defarm/Optimiser/Optimiser.sol
525 
526 pragma solidity 0.6.12;
527 
528 
529 
530 
531 
532 
533 contract Optimiser {
534     using SafeMath for uint;
535     using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees;
536 
537     struct PoolInfo {
538         uint total_weightage;
539         uint rate_reward;
540     }
541     
542     struct SessionInfo {
543         uint total_reward;
544         uint start_timestamp;
545         uint end_timestamp;
546         bool can_claim;      // upon session ended, enable user to claim reward
547         bool deposit_paused; // access control
548         bool claim_paused;   // access control
549     }
550 
551     struct UserInfo {
552         uint purchase_counter;
553     }
554 
555     struct UserSessionInfo {
556         uint tvl;
557         uint num_of_ticket;
558         uint first_deposit_timestamp;
559         uint penalty_until_timestamp;
560         bool has_purchased; // once purchased in the session, always is true
561         bool has_claimed;   // reward only can claim once
562     }
563     
564     struct UserPoolInfo {
565         uint weightage;
566         uint num_of_ticket;
567         bool claimed;
568     }
569 
570     // mapping (session ID => session info)
571     mapping(uint => SessionInfo) private session;
572     
573     // mapping (session ID => pool category => pool information)
574     mapping(uint => mapping(uint => PoolInfo)) private pool;
575     
576     // mapping (user address => session ID => pool category => user purchased information)
577     mapping(address => mapping(uint => mapping(uint => UserPoolInfo))) private user_pool;
578     
579     // mapping (user address => session ID => user info by session)
580     mapping(address => mapping(uint => UserSessionInfo)) private user_session;
581     
582     // mapping (user address => user personal info)
583     mapping(address => UserInfo) private user_info;
584 
585     // mapping (pool category ID => rate reward) master lookup
586     mapping(uint => uint) public pool_reward_list;
587     
588     // mapping (pool category ID => chances of user enter the pool) lookup
589     mapping(uint => uint) public pool_chances;
590     
591     mapping(address => bool) public access_permission;
592     
593     bool    private initialized;
594     bool    public stop_next_session; // toggle for session will auto continue or not
595     bool    public swap_payment;      // payment will swap to DEX and burn
596 
597     address public  owner;          // owner who deploy the contract
598     address public  tube;           // TUBE2 token contract
599     address public  tube_chief;     // TUBE Chief contract
600     address public  dev;            // development address
601     address public  utility;        // other usage purpose
602     address public  buyback;        // upon user hit penalty, transfer for buyback
603     address public  uniswap_router; // dex router address
604     address public  signer;         // website validation
605 
606     uint    private  preseed;            // RNG seed
607     uint    public  session_id;          // current session ID
608     uint    public  session_minute;      // session duration
609     uint    public  category_size;       // current pool category size
610     uint    public  eth_per_ticket;      // how many ETH to buy 1 ticket
611     uint    public  rate_buyback;        // fund distribution for buyback TUBE
612     uint    public  rate_dev;            // fund distrubtion for dev team
613     uint    public  rate_penalty;        // claim penalty rate
614     uint    public  penalty_base_minute; // claim penalty basis duration
615     uint    public  DECIMAL;             // ether unit decimal
616     uint    public  PER_UNIT;            // ether unit
617     uint[]  public  multiplier_list;     // multiplier list
618     
619     uint256 constant private MAX_TREE_LEAVES = 5;
620     bytes32 constant private TREE_KEY        = keccak256("JACKPOT");
621     
622     SortitionSumTreeFactory.SortitionSumTrees private sortitionSumTrees;
623 
624     event PurchaseTicket(uint session_id, uint multiplier_rate, uint pool_index, uint eth_per_ticket, uint tvl, uint weightage, uint timestamp, address buyer);
625     event Claim(uint session_id, uint claimable, uint actual_claimable, uint penalty_amount, uint timestamp, address buyer);
626     event CompletePot(uint conclude_session, uint reward_amount, uint timestamp);
627     event UpdateMultiplierList(uint[] multiplier_list);
628     event UpdatePenaltySetting(uint rate_penalty, uint penalty_base_minute);
629     event UpdateContracts(address tube, address tube_chief, address buyback, address dev, address utility, address uniswap_router, address signer);
630     event UpdateRewardBySessionId(uint session_id, uint amount);
631     event UpdateRewardPermission(address _address, bool status);
632     event UpdateAccessPermission(address _address, bool status);
633     event UpdatePoolCategory(uint new_max_category, uint[] reward_rates, uint[] chance_rates);
634     event UpdateSessionEndTimestamp(uint end_timestamp);
635     event UpdateStopNextSession(bool status);
636     event UpdateSwapPayment(bool status);
637     event UpdateSessionMinute(uint minute);
638     event UpdatePaymentRateDistribution(uint rate_buyback, uint rate_dev);
639     event UpdateToggleBySession(uint session_id, bool deposit_paused, bool claim_paused);
640     event UpdateEthPerTicket(uint eth_per_ticket);
641     event TransferOwner(address old_owner, address new_owner);
642     
643     modifier onlyOwner {
644         require(msg.sender == owner);
645         _;
646     }
647     
648     modifier hasAccessPermission {
649         require(access_permission[msg.sender], "no access permission");
650         _;
651     }
652 
653     /*
654     * init function after contract deployment
655     */
656     function initialize() public {
657         require(!initialized, "Contract instance has already been initialized");
658         initialized = true;
659         
660         sortitionSumTrees.createTree(TREE_KEY, MAX_TREE_LEAVES);
661         
662         owner = msg.sender;
663         
664         // constant value
665         DECIMAL  = 18;
666         PER_UNIT = 1000000000000000000;
667         
668         // multipliers (1.5, 3, 6, 9)
669         multiplier_list.push(1500000000000000000);
670         multiplier_list.push(3000000000000000000);
671         multiplier_list.push(6000000000000000000);
672         multiplier_list.push(9000000000000000000);
673         
674         // reward distribution: P1[0] 33%, P2[1] 33%, P3[2] 33%
675         // chances enter pool : P1[0] 50%, P2[1] 30%, P3[2] 20%
676         category_size = 3;
677         pool_reward_list[0] = 333333333333333333;
678         pool_reward_list[1] = 333333333333333333;
679         pool_reward_list[2] = 333333333333333333;
680         _updatePoolChances(0, 500000000000000000);
681         _updatePoolChances(1, 300000000000000000);
682         _updatePoolChances(2, 200000000000000000);
683 
684         // per session duration 7 day
685         session_minute = 10080;
686         session_id     = 2;
687         
688         // ticket price (0.2 ETH)
689         eth_per_ticket = 200000000000000000;
690         
691         // payment received distribution (remaining 10% will for utility)
692         rate_buyback = 700000000000000000;
693         rate_dev     = 200000000000000000;
694         
695         // penalty setting (30%, base lock up to 30 day)
696         rate_penalty        = 300000000000000000;
697         penalty_base_minute = 43200;
698         
699         // contract linking
700         tube           = 0xdA86006036540822e0cd2861dBd2fD7FF9CAA0e8;
701         tube_chief     = 0x5fe65B1172E148d1Ac4F44fFc4777c2D4731ee8f;
702         dev            = 0xAd451FBEaee85D370ca953D2020bb0480c2Cfc45;
703         buyback        = 0x702b11a838429Edca4Ea0e80c596501F1a4F4c28;
704         utility        = 0x4679025788c92187d44BdA852e9fF97229e3109b;
705         uniswap_router = 0x37D7f26405103C9Bc9D8F9352Cf32C5b655CBe02;
706         signer         = 0xd916731C0063E0c8D93552bE0a021c9Ae15ff183;
707 
708         // permission
709         access_permission[msg.sender] = true;
710     }
711 
712     /*
713     * user purchase ticket and join current session jackpot
714     * @params tvl - input from front end with signature validation 
715     */
716     function purchaseTicket(uint _tvl, uint counter, bytes memory signature) public payable {
717         require(!session[session_id].deposit_paused, "deposit paused");
718         require(session[session_id].end_timestamp > block.timestamp, "jackpot ended");
719         require(msg.value == eth_per_ticket, "invalid payment");
720         require(counter > user_info[msg.sender].purchase_counter, 'EXPIRED COUNTER'); // prevent replay attack
721         require(_verifySign(signer, msg.sender, _tvl, counter, signature), "invalid signature");
722 
723         // replace user purchase counter number
724         user_info[msg.sender].purchase_counter = counter;
725         
726         // uniform lowest bound number is 0
727         // result format is in array index so max upper bound number need to minus 1
728         uint mul_index  = UniformRandomNumber.uniform(_rngSeed(), multiplier_list.length);
729         uint pool_index = _pickPoolIndex();
730         
731         // tvl should source from maximizer pool. (LP staked value * weightage)
732         uint actual_weightage = _tvl.mul(multiplier_list[mul_index], DECIMAL);
733         
734         pool[session_id][pool_index].total_weightage                = pool[session_id][pool_index].total_weightage.add(actual_weightage);
735         user_pool[msg.sender][session_id][pool_index].weightage     = user_pool[msg.sender][session_id][pool_index].weightage.add(actual_weightage);
736         user_pool[msg.sender][session_id][pool_index].num_of_ticket = user_pool[msg.sender][session_id][pool_index].num_of_ticket.add(1);
737         user_session[msg.sender][session_id].tvl                    = user_session[msg.sender][session_id].tvl.add(_tvl);
738         user_session[msg.sender][session_id].num_of_ticket          = user_session[msg.sender][session_id].num_of_ticket.add(1);
739         user_session[msg.sender][session_id].has_purchased          = true;
740         
741         if (swap_payment) {
742             _paymentDistributionDex(msg.value);
743         } else {
744             _paymentDistributionBuyback(msg.value);    
745         }
746 
747         // withdrawal penalty set once
748         // -> block.timestamp + 30 day + session(end - now)
749         if (user_session[msg.sender][session_id].penalty_until_timestamp <= 0) {
750             user_session[msg.sender][session_id].first_deposit_timestamp = block.timestamp;
751             user_session[msg.sender][session_id].penalty_until_timestamp = session[session_id].end_timestamp.add(penalty_base_minute * 60);
752         }
753         
754         emit PurchaseTicket(session_id, multiplier_list[mul_index], pool_index, eth_per_ticket, _tvl, actual_weightage, block.timestamp, msg.sender);
755     }
756 
757     /*
758     * user claim reward by session
759     */
760     function claimReward(uint _session_id) public {
761         require(session[_session_id].can_claim, "claim not enable");
762         require(!session[_session_id].claim_paused, "claim paused");
763         require(!user_session[msg.sender][_session_id].has_claimed, "reward claimed");
764 
765         uint claimable = 0;
766         for (uint pcategory = 0; pcategory < category_size; pcategory++) {
767             claimable = claimable.add(_userReward(msg.sender, _session_id, pcategory, session[_session_id].total_reward));
768         }
769         
770         uint actual_claimable = _rewardAfterPenalty(msg.sender, claimable, _session_id);
771         uint penalty_amount   = claimable.sub(actual_claimable);
772 
773         // gas saving. transfer penalty amount for buyback
774         if (claimable != actual_claimable) {
775             TransferHelper.safeTransfer(tube, buyback, penalty_amount);    
776         }
777 
778         TransferHelper.safeTransfer(tube, msg.sender, actual_claimable);
779         user_session[msg.sender][_session_id].has_claimed = true;
780         
781         emit Claim(_session_id, claimable, actual_claimable, penalty_amount, block.timestamp, msg.sender);
782     }
783     
784     /*
785     * get current session ended
786     */
787     function getCurrentSessionEnded() public view returns(bool) {
788         return (session[session_id].end_timestamp <= block.timestamp);
789     }
790 
791     /*
792     * get user in pool detail via pool category
793     */
794     function getUserPoolInfo(address _address, uint _session_id, uint _pool_category) public view returns(uint, uint, bool) {
795         return (
796             user_pool[_address][_session_id][_pool_category].weightage,
797             user_pool[_address][_session_id][_pool_category].num_of_ticket,
798             user_pool[_address][_session_id][_pool_category].claimed
799         );
800     }
801     
802     /*
803     * get user information
804     */
805     function getUserInfo(address _address) public view returns(uint) {
806         return (user_info[_address].purchase_counter);
807     }
808 
809     /*
810     * get user in the session
811     */
812     function getUserSessionInfo(address _address, uint _session_id) public view returns(uint, uint, bool, bool, uint, uint) {
813         return (
814             user_session[_address][_session_id].tvl,
815             user_session[_address][_session_id].num_of_ticket,
816             user_session[_address][_session_id].has_purchased,
817             user_session[_address][_session_id].has_claimed,
818             user_session[_address][_session_id].first_deposit_timestamp,
819             user_session[_address][_session_id].penalty_until_timestamp
820         );
821     }
822 
823     /*
824     * get user has participant on current jackpot session or not
825     */
826     function getCurrentSessionJoined(address _address) public view returns (bool) {
827         return user_session[_address][session_id].has_purchased;
828     }
829 
830     /*
831     * get pool info
832     */
833     function getPool(uint _session_id, uint _pool_category) public view returns(uint, uint) {
834         return (
835             pool[_session_id][_pool_category].total_weightage,
836             pool[_session_id][_pool_category].rate_reward    
837         );
838     }
839 
840     /*
841     * get session info
842     */
843     function getSession(uint _session_id) public view returns(uint, uint, uint, bool, bool, bool) {
844        return (
845            session[_session_id].total_reward,
846            session[_session_id].start_timestamp,
847            session[_session_id].end_timestamp,
848            session[_session_id].deposit_paused,
849            session[_session_id].can_claim,
850            session[_session_id].claim_paused
851         );
852     }
853     
854     /*
855     * get all pool reward by session ID
856     */
857     function getPoolRewardBySession(uint _session_id) public view returns(uint, uint[] memory) {
858         uint reward_tube  = 0;
859         if (_session_id == session_id) {
860              reward_tube = reward_tube.add(ITubeChief(tube_chief).getJackpotReward());
861         }
862 
863         // local reward + pending tube chief reward
864         uint reward_atm            = reward_tube.add(session[_session_id].total_reward);
865         uint[] memory pool_rewards = new uint[](category_size);
866 
867         for (uint pcategory = 0; pcategory < category_size; pcategory++) {
868             pool_rewards[pcategory] = reward_atm.mul(pool[_session_id][pcategory].rate_reward, DECIMAL);
869         }
870 
871         return (category_size, pool_rewards);
872     }
873 
874     /*
875     * get user reward by session ID
876     */
877     function getUserRewardBySession(address _address, uint _session_id) public view returns (uint, uint) {
878         uint reward_atm = session[_session_id].total_reward;
879 
880         if (_session_id == session_id) {
881              reward_atm = reward_atm.add(ITubeChief(tube_chief).getJackpotReward());
882         }
883 
884         uint claimable = 0;
885         for (uint pcategory = 0; pcategory < category_size; pcategory++) {
886             claimable = claimable.add(_userReward(_address, _session_id, pcategory, reward_atm));
887         }
888 
889         uint max_claimable = claimable;
890 
891         claimable = _rewardAfterPenalty(_address, claimable, _session_id);
892 
893         return (max_claimable, claimable);
894     }
895 
896     /*
897     * start jackpot new session
898     */
899     function initPot() public hasAccessPermission {
900         _startPot();
901     }
902 
903     /*
904     * update ticket prcing
905     */
906     function updateEthPerTicket(uint _eth_per_ticket) public hasAccessPermission {
907         eth_per_ticket = _eth_per_ticket;
908         emit UpdateEthPerTicket(eth_per_ticket);
909     }
910     
911     /*
912     * update jackpot control toggle by session ID
913     */
914     function updateToggleBySession(uint _session_id, bool _deposit_paused, bool _claim_paused) public hasAccessPermission {
915         session[_session_id].deposit_paused = _deposit_paused;
916         session[_session_id].claim_paused   = _claim_paused;
917         emit UpdateToggleBySession(_session_id, _deposit_paused, _claim_paused);
918     }
919 
920     /*
921     * update current session end timestamp
922     */
923     function updateSessionEndTimestamp(uint end_timestamp) public hasAccessPermission {
924         session[session_id].end_timestamp = end_timestamp;
925         emit UpdateSessionEndTimestamp(end_timestamp);
926     }
927 
928     /*
929     * resetup pool category size and reward distribution
930     * XX update will reflect immediately
931     */
932     function updateMultiplierList(uint[] memory _multiplier_list) public hasAccessPermission {
933        multiplier_list = _multiplier_list;
934        emit UpdateMultiplierList(multiplier_list);
935     }
936 
937     /*
938     * update penatly setting
939     */
940     function updatePenaltySetting(uint _rate_penalty, uint _penalty_base_minute) public hasAccessPermission {
941         rate_penalty        = _rate_penalty;
942         penalty_base_minute = _penalty_base_minute;
943         emit UpdatePenaltySetting(rate_penalty, penalty_base_minute);
944     }
945     
946     /*
947     * update payment rate distribution to each sectors
948     * (!) rate utility will auto result in (1 - rate_buyback - rate_dev)
949     */
950     function updatePaymentRateDistribution(uint _rate_buyback, uint _rate_dev) public hasAccessPermission {
951         rate_buyback = _rate_buyback;
952         rate_dev     = _rate_dev;
953         emit UpdatePaymentRateDistribution(rate_buyback, rate_dev);
954     }
955 
956     /*
957     * update contract addresses
958     */
959     function updateContracts(
960         address _tube,
961         address _tube_chief,
962         address _buyback,
963         address _dev,
964         address _utility,
965         address _uniswap_router,
966         address _signer
967     ) public hasAccessPermission {
968         tube           = _tube;
969         tube_chief     = _tube_chief;
970         buyback        = _buyback;
971         dev            = _dev;
972         utility        = _utility;
973         uniswap_router = _uniswap_router;
974         signer         = _signer;
975         emit UpdateContracts(tube, tube_chief, buyback, dev, utility, uniswap_router, signer);
976     }
977 
978     /*
979     * resetup pool category size and reward distribution
980     * @param new_max_category - total pool size
981     * @param reward_rates     - each pool reward distribution rate
982     * @param chance_rates     - change rate of user will enter the pool
983     * XX pool reward rate update will reflect on next session
984     * XX pool chance rate update will reflect now
985     * XX may incur high gas fee
986     */
987     function updatePoolCategory(uint new_max_category, uint[] memory reward_rates, uint[] memory chance_rates) public hasAccessPermission {
988         require(reward_rates.length == category_size, "invalid input size");
989 
990         // remove old setting
991         for (uint i = 0; i < category_size; i++) {
992             delete pool_reward_list[i];
993             delete pool_chances[i];
994             _updatePoolChances(i, 0);
995         }
996 
997         // add new setting
998         for (uint i = 0; i < new_max_category; i++) {
999             pool_reward_list[i] = reward_rates[i];
1000             _updatePoolChances(i, chance_rates[i]);
1001         }
1002 
1003         category_size = new_max_category;
1004         
1005         emit UpdatePoolCategory(new_max_category, reward_rates, chance_rates);
1006     }
1007 
1008     /*
1009     * update stop next session status
1010     */
1011     function updateStopNextSession(bool status) public hasAccessPermission {
1012         stop_next_session = status;
1013         emit UpdateStopNextSession(status);
1014     }
1015     
1016     /*
1017     * update jackpot duration
1018     * XX update reflect on next session
1019     */
1020     function updateSessionMinute(uint minute) public hasAccessPermission {
1021         session_minute = minute;
1022         emit UpdateSessionMinute(minute);
1023     }
1024     
1025     /*
1026     * update swap payment method
1027     */
1028     function updateSwapPayment(bool status) public hasAccessPermission {
1029         swap_payment = status;
1030         emit UpdateSwapPayment(status);
1031     }
1032 
1033     /*
1034     * update access permission
1035     */
1036     function updateAccessPermission(address _address, bool status) public onlyOwner {
1037         access_permission[_address] = status;
1038         emit UpdateAccessPermission(_address, status);
1039     }
1040 
1041     /*
1042     * conclude current session and start new session
1043     * - transferJackpot
1044     * - completePot
1045     */
1046     function completePot() public hasAccessPermission {
1047         require(session[session_id].end_timestamp <= block.timestamp, "session not end");
1048 
1049         /*
1050         * 1. main contract will transfer TUBE to this contract
1051         * 2. update the total reward amount for current session
1052         */
1053         uint conclude_session = session_id;
1054         uint reward_amount    = ITubeChief(tube_chief).transferJackpotReward();
1055 
1056         session[conclude_session].total_reward = session[conclude_session].total_reward.add(reward_amount);
1057         session[conclude_session].can_claim    = true;
1058         session_id = session_id.add(1);
1059         
1060         if (!stop_next_session) {
1061             _startPot();
1062         }
1063         
1064         // if pool weightage is empty, transfer pool reward to buyback
1065         for (uint pcategory = 0; pcategory < category_size; pcategory++) {
1066             if (pool[conclude_session][pcategory].total_weightage > 0) {
1067                 continue;
1068             }
1069             uint amount = session[conclude_session].total_reward.mul(pool[conclude_session][pcategory].rate_reward, DECIMAL);
1070             TransferHelper.safeTransfer(tube, buyback, amount);
1071         }
1072         
1073         emit CompletePot(conclude_session, reward_amount, block.timestamp);
1074     }
1075     
1076     /*
1077     * transfer ownership. proceed wisely. only owner executable
1078     */
1079     function transferOwner(address new_owner) public onlyOwner {
1080         emit TransferOwner(owner, new_owner);
1081         owner = new_owner;
1082     }
1083     
1084     /*
1085     * emergency collect token from the contract. only owner executable
1086     */
1087     function emergencyCollectToken(address token, uint amount) public onlyOwner {
1088         TransferHelper.safeTransfer(token, owner, amount);
1089     }
1090 
1091     /*
1092     * emergency collect eth from the contract. only owner executable
1093     */
1094     function emergencyCollectEth(uint amount) public onlyOwner {
1095         address payable owner_address = payable(owner);
1096         TransferHelper.safeTransferETH(owner_address, amount);
1097     }
1098 
1099     function _userReward(address _address, uint _session_id, uint _pool_category, uint _total_reward) internal view returns (uint) {
1100         // (Z / Total Z of all users) x P1 / P2 / P3 TUBE2 = X amount of reward
1101         uint total_weight = pool[_session_id][_pool_category].total_weightage;
1102         
1103         if (total_weight <= 0 || user_pool[_address][_session_id][_pool_category].claimed) {
1104             return 0;
1105         }
1106 
1107         uint user_weight = user_pool[_address][_session_id][_pool_category].weightage;
1108         uint rate        = pool[_session_id][_pool_category].rate_reward;
1109 
1110         return user_weight.div(total_weight, DECIMAL).mul(_total_reward, DECIMAL).mul(rate, DECIMAL);
1111     }
1112 
1113     function _startPot() internal {
1114         session[session_id].start_timestamp = block.timestamp;
1115         session[session_id].end_timestamp   = block.timestamp.add(session_minute * 60);
1116         
1117         // init P1, P2, P3
1118         for (uint i = 0; i < category_size; i++) {
1119             pool[session_id][i].rate_reward = pool_reward_list[i];
1120         }
1121     }
1122 
1123     function _paymentDistributionDex(uint amount) internal {
1124         uint buyback_amount = amount.mul(rate_buyback, DECIMAL);
1125         uint dev_amount     = amount.mul(rate_dev, DECIMAL);
1126         uint utility_amount = amount.sub(buyback_amount).sub(dev_amount);
1127         uint tube_swapped   = _swapEthToTUBE(buyback_amount);
1128         
1129         TransferHelper.safeTransfer(tube, address(0), tube_swapped);
1130         TransferHelper.safeTransferETH(dev, dev_amount);
1131         TransferHelper.safeTransferETH(utility, utility_amount);
1132     }
1133     
1134     function _paymentDistributionBuyback(uint amount) internal {
1135         /*
1136         * distribution plan (initial)
1137         * buyback     - 70% (buyback)
1138         * masternode  - 20% (dev)
1139         * leaderboard - 10% (utility)
1140         */
1141         uint buyback_amount = amount.mul(rate_buyback, DECIMAL);
1142         uint dev_amount     = amount.mul(rate_dev, DECIMAL);
1143         uint utility_amount = amount.sub(buyback_amount).sub(dev_amount);
1144 
1145         TransferHelper.safeTransferETH(buyback, buyback_amount);
1146         TransferHelper.safeTransferETH(dev, dev_amount);
1147         TransferHelper.safeTransferETH(utility, utility_amount);
1148     }
1149 
1150     function _rngSeed() internal returns (uint) {
1151         uint seed = uint256(keccak256(abi.encode(block.number, msg.sender, preseed)));
1152         preseed   = seed;
1153         return seed;
1154     }
1155 
1156     function _swapEthToTUBE(uint amount) internal returns (uint) {
1157         require(amount > 0, "empty swap amount");
1158 
1159         TransferHelper.safeApprove(tube, uniswap_router, amount);
1160         
1161         address[] memory path = new address[](2);
1162         path[0] = IUniswapV2Router02(uniswap_router).WETH();
1163         path[1] = tube;
1164         
1165         // lower down the receive expectation to prevent high failure
1166         uint buffer_rate = 980000000000000000;
1167         uint deadline    = block.timestamp.add(60);
1168         uint[] memory amount_out_min = new uint[](2);
1169 
1170         amount_out_min        = IUniswapV2Router02(uniswap_router).getAmountsOut(amount, path);
1171         amount_out_min[1]     = amount_out_min[1].mul(buffer_rate, DECIMAL);
1172         uint[] memory swapped = IUniswapV2Router02(uniswap_router).swapExactETHForTokens{ value: amount }(amount_out_min[1], path, address(this), deadline);
1173 
1174         return swapped[1];
1175     }
1176 
1177     function _rewardAfterPenalty(address _address, uint reward_amount, uint _session_id) internal view returns (uint) {
1178         /*
1179         * calculate the reward amount after penalty condition
1180         *
1181         * 1. get the withdrawable amount
1182         * 2. get the withdraw penalty rate
1183         * 3. get time ratio: (userPenaltyEndTime - now) / (penalty_base_minute * 60)
1184         * 4. result = [full reward] x [penalty rate] x [time ratio]
1185         */
1186         if (user_session[_address][_session_id].penalty_until_timestamp >= block.timestamp) {
1187            uint end            = user_session[_address][_session_id].penalty_until_timestamp;
1188            uint diff_now       = end.sub(block.timestamp);
1189            uint time_ratio     = diff_now.div(penalty_base_minute * 60, DECIMAL);
1190            uint penalty_amount = reward_amount.mul(rate_penalty, DECIMAL).mul(time_ratio, DECIMAL);
1191 
1192            reward_amount = reward_amount.sub(penalty_amount);
1193         }
1194         return reward_amount;
1195     }
1196     
1197     function _updatePoolChances(uint pool_index, uint chance_rate) internal {
1198         pool_chances[pool_index] = chance_rate;
1199         sortitionSumTrees.set(TREE_KEY, chance_rate, bytes32(uint256(pool_index)));
1200     }
1201     
1202     function _pickPoolIndex() internal returns (uint) {
1203         return uint256(sortitionSumTrees.draw(TREE_KEY, _rngSeed()));
1204     }
1205 
1206     /*
1207     * VerifySignature
1208     */
1209     function _getMessageHash(address buyer, uint tvl, uint counter) internal pure returns (bytes32) {
1210         return keccak256(abi.encodePacked(buyer, tvl, counter));
1211     }
1212 
1213     function _getEthSignedMessageHash(bytes32 _messageHash) internal pure returns (bytes32) {
1214         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash));
1215     }
1216 
1217     function _verifySign(address _signer, address buyer, uint tvl, uint counter, bytes memory signature) internal pure returns (bool) {
1218         bytes32 messageHash = _getMessageHash(buyer, tvl, counter);
1219         bytes32 ethSignedMessageHash = _getEthSignedMessageHash(messageHash);
1220         return _recoverSigner(ethSignedMessageHash, signature) == _signer;
1221     }
1222 
1223     function _recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) internal pure returns (address) {
1224         (bytes32 r, bytes32 s, uint8 v) = _splitSignature(_signature);
1225         return ecrecover(_ethSignedMessageHash, v, r, s);
1226     }
1227 
1228     function _splitSignature(bytes memory sig) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
1229         require(sig.length == 65, "invalid signature length");
1230 
1231         assembly {
1232             r := mload(add(sig, 32))
1233             s := mload(add(sig, 64))
1234             v := byte(0, mload(add(sig, 96)))
1235         }
1236     }
1237 }
1238 
1239 interface ITubeChief {
1240     function getJackpotReward() external view returns (uint);
1241     function transferJackpotReward() external returns (uint);
1242 }