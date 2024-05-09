1 /**
2  *  Kleros Liquid
3  *  https://contributing.kleros.io/smart-contract-workflow
4  *  @reviewers: [@clesaege]
5  *  @auditors: []
6  *  @bounties: [{duration: 14days, link: https://github.com/kleros/kleros/issues/117, max_payout: 50ETH}]
7  *  @deployments: []
8  */
9 /* solium-disable error-reason */
10 /* solium-disable security/no-block-members */
11 pragma solidity ^0.4.25;
12 
13 
14 
15 /**
16  *  @title SortitionSumTreeFactory
17  *  @author Enrique Piqueras - <epiquerass@gmail.com>
18  *  @dev A factory of trees that keep track of staked values for sortition.
19  */
20 library SortitionSumTreeFactory {
21     /* Structs */
22 
23     struct SortitionSumTree {
24         uint K; // The maximum number of childs per node.
25         // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
26         uint[] stack;
27         uint[] nodes;
28         // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
29         mapping(bytes32 => uint) IDsToNodeIndexes;
30         mapping(uint => bytes32) nodeIndexesToIDs;
31     }
32 
33     /* Storage */
34 
35     struct SortitionSumTrees {
36         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
37     }
38 
39     /* Public */
40 
41     /**
42      *  @dev Create a sortition sum tree at the specified key.
43      *  @param _key The key of the new tree.
44      *  @param _K The number of children each node in the tree should have.
45      */
46     function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) public {
47         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
48         require(tree.K == 0, "Tree already exists.");
49         require(_K > 1, "K must be greater than one.");
50         tree.K = _K;
51         tree.stack.length = 0;
52         tree.nodes.length = 0;
53         tree.nodes.push(0);
54     }
55 
56     /**
57      *  @dev Set a value of a tree.
58      *  @param _key The key of the tree.
59      *  @param _value The new value.
60      *  @param _ID The ID of the value.
61      *  `O(log_k(n))` where
62      *  `k` is the maximum number of childs per node in the tree,
63      *   and `n` is the maximum number of nodes ever appended.
64      */
65     function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) public {
66         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
67         uint treeIndex = tree.IDsToNodeIndexes[_ID];
68 
69         if (treeIndex == 0) { // No existing node.
70             if (_value != 0) { // Non zero value.
71                 // Append.
72                 // Add node.
73                 if (tree.stack.length == 0) { // No vacant spots.
74                     // Get the index and append the value.
75                     treeIndex = tree.nodes.length;
76                     tree.nodes.push(_value);
77 
78                     // Potentially append a new node and make the parent a sum node.
79                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) { // Is first child.
80                         uint parentIndex = treeIndex / tree.K;
81                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
82                         uint newIndex = treeIndex + 1;
83                         tree.nodes.push(tree.nodes[parentIndex]);
84                         delete tree.nodeIndexesToIDs[parentIndex];
85                         tree.IDsToNodeIndexes[parentID] = newIndex;
86                         tree.nodeIndexesToIDs[newIndex] = parentID;
87                     }
88                 } else { // Some vacant spot.
89                     // Pop the stack and append the value.
90                     treeIndex = tree.stack[tree.stack.length - 1];
91                     tree.stack.length--;
92                     tree.nodes[treeIndex] = _value;
93                 }
94 
95                 // Add label.
96                 tree.IDsToNodeIndexes[_ID] = treeIndex;
97                 tree.nodeIndexesToIDs[treeIndex] = _ID;
98 
99                 updateParents(self, _key, treeIndex, true, _value);
100             }
101         } else { // Existing node.
102             if (_value == 0) { // Zero value.
103                 // Remove.
104                 // Remember value and set to 0.
105                 uint value = tree.nodes[treeIndex];
106                 tree.nodes[treeIndex] = 0;
107 
108                 // Push to stack.
109                 tree.stack.push(treeIndex);
110 
111                 // Clear label.
112                 delete tree.IDsToNodeIndexes[_ID];
113                 delete tree.nodeIndexesToIDs[treeIndex];
114 
115                 updateParents(self, _key, treeIndex, false, value);
116             } else if (_value != tree.nodes[treeIndex]) { // New, non zero value.
117                 // Set.
118                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
119                 uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
120                 tree.nodes[treeIndex] = _value;
121 
122                 updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
123             }
124         }
125     }
126 
127     /* Public Views */
128 
129     /**
130      *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
131      *  @param _key The key of the tree to get the leaves from.
132      *  @param _cursor The pagination cursor.
133      *  @param _count The number of items to return.
134      *  @return The index at which leaves start, the values of the returned leaves, and whether there are more for pagination.
135      *  `O(n)` where
136      *  `n` is the maximum number of nodes ever appended.
137      */
138     function queryLeafs(
139         SortitionSumTrees storage self,
140         bytes32 _key,
141         uint _cursor,
142         uint _count
143     ) public view returns(uint startIndex, uint[] values, bool hasMore) {
144         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
145 
146         // Find the start index.
147         for (uint i = 0; i < tree.nodes.length; i++) {
148             if ((tree.K * i) + 1 >= tree.nodes.length) {
149                 startIndex = i;
150                 break;
151             }
152         }
153 
154         // Get the values.
155         uint loopStartIndex = startIndex + _cursor;
156         values = new uint[](loopStartIndex + _count > tree.nodes.length ? tree.nodes.length - loopStartIndex : _count);
157         uint valuesIndex = 0;
158         for (uint j = loopStartIndex; j < tree.nodes.length; j++) {
159             if (valuesIndex < _count) {
160                 values[valuesIndex] = tree.nodes[j];
161                 valuesIndex++;
162             } else {
163                 hasMore = true;
164                 break;
165             }
166         }
167     }
168 
169     /**
170      *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
171      *  @param _key The key of the tree.
172      *  @param _drawnNumber The drawn number.
173      *  @return The drawn ID.
174      *  `O(k * log_k(n))` where
175      *  `k` is the maximum number of childs per node in the tree,
176      *   and `n` is the maximum number of nodes ever appended.
177      */
178     function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) public view returns(bytes32 ID) {
179         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
180         uint treeIndex = 0;
181         uint currentDrawnNumber = _drawnNumber % tree.nodes[0];
182 
183         while ((tree.K * treeIndex) + 1 < tree.nodes.length)  // While it still has children.
184             for (uint i = 1; i <= tree.K; i++) { // Loop over children.
185                 uint nodeIndex = (tree.K * treeIndex) + i;
186                 uint nodeValue = tree.nodes[nodeIndex];
187 
188                 if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue; // Go to the next child.
189                 else { // Pick this child.
190                     treeIndex = nodeIndex;
191                     break;
192                 }
193             }
194         
195         ID = tree.nodeIndexesToIDs[treeIndex];
196     }
197 
198     /** @dev Gets a specified ID's associated value.
199      *  @param _key The key of the tree.
200      *  @param _ID The ID of the value.
201      *  @return The associated value.
202      */
203     function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) public view returns(uint value) {
204         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
205         uint treeIndex = tree.IDsToNodeIndexes[_ID];
206 
207         if (treeIndex == 0) value = 0;
208         else value = tree.nodes[treeIndex];
209     }
210 
211     /* Private */
212 
213     /**
214      *  @dev Update all the parents of a node.
215      *  @param _key The key of the tree to update.
216      *  @param _treeIndex The index of the node to start from.
217      *  @param _plusOrMinus Wether to add (true) or substract (false).
218      *  @param _value The value to add or substract.
219      *  `O(log_k(n))` where
220      *  `k` is the maximum number of childs per node in the tree,
221      *   and `n` is the maximum number of nodes ever appended.
222      */
223     function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
224         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
225 
226         uint parentIndex = _treeIndex;
227         while (parentIndex != 0) {
228             parentIndex = (parentIndex - 1) / tree.K;
229             tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
230         }
231     }
232 }
233 
234 
235 contract RNG{
236 
237     /** @dev Contribute to the reward of a random number.
238     *  @param _block Block the random number is linked to.
239     */
240     function contribute(uint _block) public payable;
241 
242     /** @dev Request a random number.
243     *  @param _block Block linked to the request.
244     */
245     function requestRN(uint _block) public payable {
246         contribute(_block);
247     }
248 
249     /** @dev Get the random number.
250     *  @param _block Block the random number is linked to.
251     *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
252     */
253     function getRN(uint _block) public returns (uint RN);
254 
255     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
256     *  This is to prevent users from getting correlated numbers.
257     *  @param _block Block the random number is linked to.
258     *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
259     */
260     function getUncorrelatedRN(uint _block) public returns (uint RN) {
261         uint baseRN = getRN(_block);
262         if (baseRN == 0)
263         return 0;
264         else
265         return uint(keccak256(msg.sender,baseRN));
266     }
267 
268 }
269 
270 
271 /** @title Arbitrator
272  *  Arbitrator abstract contract.
273  *  When developing arbitrator contracts we need to:
274  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
275  *  -Define the functions for cost display (arbitrationCost and appealCost).
276  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID, ruling).
277  */
278 contract Arbitrator {
279 
280     enum DisputeStatus {Waiting, Appealable, Solved}
281 
282     modifier requireArbitrationFee(bytes _extraData) {
283         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
284         _;
285     }
286     modifier requireAppealFee(uint _disputeID, bytes _extraData) {
287         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
288         _;
289     }
290 
291     /** @dev To be raised when a dispute is created.
292      *  @param _disputeID ID of the dispute.
293      *  @param _arbitrable The contract which created the dispute.
294      */
295     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
296 
297     /** @dev To be raised when a dispute can be appealed.
298      *  @param _disputeID ID of the dispute.
299      */
300     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
301 
302     /** @dev To be raised when the current ruling is appealed.
303      *  @param _disputeID ID of the dispute.
304      *  @param _arbitrable The contract which created the dispute.
305      */
306     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
307 
308     /** @dev Create a dispute. Must be called by the arbitrable contract.
309      *  Must be paid at least arbitrationCost(_extraData).
310      *  @param _choices Amount of choices the arbitrator can make in this dispute.
311      *  @param _extraData Can be used to give additional info on the dispute to be created.
312      *  @return disputeID ID of the dispute created.
313      */
314     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
315 
316     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
317      *  @param _extraData Can be used to give additional info on the dispute to be created.
318      *  @return fee Amount to be paid.
319      */
320     function arbitrationCost(bytes _extraData) public view returns(uint fee);
321 
322     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
323      *  @param _disputeID ID of the dispute to be appealed.
324      *  @param _extraData Can be used to give extra info on the appeal.
325      */
326     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
327         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
328     }
329 
330     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
331      *  @param _disputeID ID of the dispute to be appealed.
332      *  @param _extraData Can be used to give additional info on the dispute to be created.
333      *  @return fee Amount to be paid.
334      */
335     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);
336 
337     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.
338      *  @param _disputeID ID of the dispute.
339      *  @return The start and end of the period.
340      */
341     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
342 
343     /** @dev Return the status of a dispute.
344      *  @param _disputeID ID of the dispute to rule.
345      *  @return status The status of the dispute.
346      */
347     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
348 
349     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
350      *  @param _disputeID ID of the dispute.
351      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
352      */
353     function currentRuling(uint _disputeID) public view returns(uint ruling);
354 }
355 
356 
357 
358 /**
359  *  @title IArbitrable
360  *  @author Enrique Piqueras - <enrique@kleros.io>
361  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
362  */
363 
364 
365 /** @title IArbitrable
366  *  Arbitrable interface.
367  *  When developing arbitrable contracts, we need to:
368  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
369  *  -Allow dispute creation. For this a function must:
370  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
371  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
372  */
373 interface IArbitrable {
374     /** @dev To be emmited when meta-evidence is submitted.
375      *  @param _metaEvidenceID Unique identifier of meta-evidence.
376      *  @param _evidence A link to the meta-evidence JSON.
377      */
378     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
379 
380     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
381      *  @param _arbitrator The arbitrator of the contract.
382      *  @param _disputeID ID of the dispute in the Arbitrator contract.
383      *  @param _metaEvidenceID Unique identifier of meta-evidence.
384      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
385      */
386     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
387 
388     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
389      *  @param _arbitrator The arbitrator of the contract.
390      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
391      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
392      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
393      */
394     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
395 
396     /** @dev To be raised when a ruling is given.
397      *  @param _arbitrator The arbitrator giving the ruling.
398      *  @param _disputeID ID of the dispute in the Arbitrator contract.
399      *  @param _ruling The ruling which was given.
400      */
401     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
402 
403     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
404      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
405      *  @param _disputeID ID of the dispute in the Arbitrator contract.
406      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
407      */
408     function rule(uint _disputeID, uint _ruling) public;
409 }
410 
411 
412 
413 /** @title Arbitrable
414  *  Arbitrable abstract contract.
415  *  When developing arbitrable contracts, we need to:
416  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
417  *  -Allow dispute creation. For this a function must:
418  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
419  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
420  */
421 contract Arbitrable is IArbitrable {
422     Arbitrator public arbitrator;
423     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
424 
425     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
426 
427     /** @dev Constructor. Choose the arbitrator.
428      *  @param _arbitrator The arbitrator of the contract.
429      *  @param _arbitratorExtraData Extra data for the arbitrator.
430      */
431     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
432         arbitrator = _arbitrator;
433         arbitratorExtraData = _arbitratorExtraData;
434     }
435 
436     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
437      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
438      *  @param _disputeID ID of the dispute in the Arbitrator contract.
439      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
440      */
441     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
442         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
443 
444         executeRuling(_disputeID,_ruling);
445     }
446 
447 
448     /** @dev Execute a ruling of a dispute.
449      *  @param _disputeID ID of the dispute in the Arbitrator contract.
450      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
451      */
452     function executeRuling(uint _disputeID, uint _ruling) internal;
453 }
454 
455 
456 /*
457     Copyright 2016, Jordi Baylina.
458     Slight modification by Clément Lesaege.
459 
460     This program is free software: you can redistribute it and/or modify
461     it under the terms of the GNU General Public License as published by
462     the Free Software Foundation, either version 3 of the License, or
463     (at your option) any later version.
464 
465     This program is distributed in the hope that it will be useful,
466     but WITHOUT ANY WARRANTY; without even the implied warranty of
467     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
468     GNU General Public License for more details.
469 
470     You should have received a copy of the GNU General Public License
471     along with this program.  If not, see <http://www.gnu.org/licenses/>.
472  */
473 
474 /// @title MiniMeToken Contract
475 /// @author Jordi Baylina
476 /// @dev This token contract's goal is to make it easy for anyone to clone this
477 ///  token using the token distribution at a given block, this will allow DAO's
478 ///  and DApps to upgrade their features in a decentralized manner without
479 ///  affecting the original token
480 /// @dev It is ERC20 compliant, but still needs to under go further testing.
481 
482 
483 contract ApproveAndCallFallBack {
484     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
485 }
486 
487 /// @dev The token controller contract must implement these functions
488 contract TokenController {
489     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
490     /// @param _owner The address that sent the ether to create tokens
491     /// @return True if the ether is accepted, false if it throws
492     function proxyPayment(address _owner) public payable returns(bool);
493 
494     /// @notice Notifies the controller about a token transfer allowing the
495     ///  controller to react if desired
496     /// @param _from The origin of the transfer
497     /// @param _to The destination of the transfer
498     /// @param _amount The amount of the transfer
499     /// @return False if the controller does not authorize the transfer
500     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
501 
502     /// @notice Notifies the controller about an approval allowing the
503     ///  controller to react if desired
504     /// @param _owner The address that calls `approve()`
505     /// @param _spender The spender in the `approve()` call
506     /// @param _amount The amount in the `approve()` call
507     /// @return False if the controller does not authorize the approval
508     function onApprove(address _owner, address _spender, uint _amount) public
509         returns(bool);
510 }
511 
512 contract Controlled {
513     /// @notice The address of the controller is the only address that can call
514     ///  a function with this modifier
515     modifier onlyController { require(msg.sender == controller); _; }
516 
517     address public controller;
518 
519     function Controlled() public { controller = msg.sender;}
520 
521     /// @notice Changes the controller of the contract
522     /// @param _newController The new controller of the contract
523     function changeController(address _newController) public onlyController {
524         controller = _newController;
525     }
526 }
527 
528 /// @dev The actual token contract, the default controller is the msg.sender
529 ///  that deploys the contract, so usually this token will be deployed by a
530 ///  token controller contract, which Giveth will call a "Campaign"
531 contract MiniMeToken is Controlled {
532 
533     string public name;                //The Token's name: e.g. DigixDAO Tokens
534     uint8 public decimals;             //Number of decimals of the smallest unit
535     string public symbol;              //An identifier: e.g. REP
536     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
537 
538 
539     /// @dev `Checkpoint` is the structure that attaches a block number to a
540     ///  given value, the block number attached is the one that last changed the
541     ///  value
542     struct  Checkpoint {
543 
544         // `fromBlock` is the block number that the value was generated from
545         uint128 fromBlock;
546 
547         // `value` is the amount of tokens at a specific block number
548         uint128 value;
549     }
550 
551     // `parentToken` is the Token address that was cloned to produce this token;
552     //  it will be 0x0 for a token that was not cloned
553     MiniMeToken public parentToken;
554 
555     // `parentSnapShotBlock` is the block number from the Parent Token that was
556     //  used to determine the initial distribution of the Clone Token
557     uint public parentSnapShotBlock;
558 
559     // `creationBlock` is the block number that the Clone Token was created
560     uint public creationBlock;
561 
562     // `balances` is the map that tracks the balance of each address, in this
563     //  contract when the balance changes the block number that the change
564     //  occurred is also included in the map
565     mapping (address => Checkpoint[]) balances;
566 
567     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
568     mapping (address => mapping (address => uint256)) allowed;
569 
570     // Tracks the history of the `totalSupply` of the token
571     Checkpoint[] totalSupplyHistory;
572 
573     // Flag that determines if the token is transferable or not.
574     bool public transfersEnabled;
575 
576     // The factory used to create new clone tokens
577     MiniMeTokenFactory public tokenFactory;
578 
579 ////////////////
580 // Constructor
581 ////////////////
582 
583     /// @notice Constructor to create a MiniMeToken
584     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
585     ///  will create the Clone token contracts, the token factory needs to be
586     ///  deployed first
587     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
588     ///  new token
589     /// @param _parentSnapShotBlock Block of the parent token that will
590     ///  determine the initial distribution of the clone token, set to 0 if it
591     ///  is a new token
592     /// @param _tokenName Name of the new token
593     /// @param _decimalUnits Number of decimals of the new token
594     /// @param _tokenSymbol Token Symbol for the new token
595     /// @param _transfersEnabled If true, tokens will be able to be transferred
596     function MiniMeToken(
597         address _tokenFactory,
598         address _parentToken,
599         uint _parentSnapShotBlock,
600         string _tokenName,
601         uint8 _decimalUnits,
602         string _tokenSymbol,
603         bool _transfersEnabled
604     ) public {
605         tokenFactory = MiniMeTokenFactory(_tokenFactory);
606         name = _tokenName;                                 // Set the name
607         decimals = _decimalUnits;                          // Set the decimals
608         symbol = _tokenSymbol;                             // Set the symbol
609         parentToken = MiniMeToken(_parentToken);
610         parentSnapShotBlock = _parentSnapShotBlock;
611         transfersEnabled = _transfersEnabled;
612         creationBlock = block.number;
613     }
614 
615 
616 ///////////////////
617 // ERC20 Methods
618 ///////////////////
619 
620     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
621     /// @param _to The address of the recipient
622     /// @param _amount The amount of tokens to be transferred
623     /// @return Whether the transfer was successful or not
624     function transfer(address _to, uint256 _amount) public returns (bool success) {
625         require(transfersEnabled);
626         doTransfer(msg.sender, _to, _amount);
627         return true;
628     }
629 
630     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
631     ///  is approved by `_from`
632     /// @param _from The address holding the tokens being transferred
633     /// @param _to The address of the recipient
634     /// @param _amount The amount of tokens to be transferred
635     /// @return True if the transfer was successful
636     function transferFrom(address _from, address _to, uint256 _amount
637     ) public returns (bool success) {
638 
639         // The controller of this contract can move tokens around at will,
640         //  this is important to recognize! Confirm that you trust the
641         //  controller of this contract, which in most situations should be
642         //  another open source smart contract or 0x0
643         if (msg.sender != controller) {
644             require(transfersEnabled);
645 
646             // The standard ERC 20 transferFrom functionality
647             require(allowed[_from][msg.sender] >= _amount);
648             allowed[_from][msg.sender] -= _amount;
649         }
650         doTransfer(_from, _to, _amount);
651         return true;
652     }
653 
654     /// @dev This is the actual transfer function in the token contract, it can
655     ///  only be called by other functions in this contract.
656     /// @param _from The address holding the tokens being transferred
657     /// @param _to The address of the recipient
658     /// @param _amount The amount of tokens to be transferred
659     /// @return True if the transfer was successful
660     function doTransfer(address _from, address _to, uint _amount
661     ) internal {
662 
663            if (_amount == 0) {
664                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
665                return;
666            }
667 
668            require(parentSnapShotBlock < block.number);
669 
670            // Do not allow transfer to 0x0 or the token contract itself
671            require((_to != 0) && (_to != address(this)));
672 
673            // If the amount being transfered is more than the balance of the
674            //  account the transfer throws
675            var previousBalanceFrom = balanceOfAt(_from, block.number);
676 
677            require(previousBalanceFrom >= _amount);
678 
679            // Alerts the token controller of the transfer
680            if (isContract(controller)) {
681                require(TokenController(controller).onTransfer(_from, _to, _amount));
682            }
683 
684            // First update the balance array with the new value for the address
685            //  sending the tokens
686            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
687 
688            // Then update the balance array with the new value for the address
689            //  receiving the tokens
690            var previousBalanceTo = balanceOfAt(_to, block.number);
691            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
692            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
693 
694            // An event to make the transfer easy to find on the blockchain
695            Transfer(_from, _to, _amount);
696 
697     }
698 
699     /// @param _owner The address that's balance is being requested
700     /// @return The balance of `_owner` at the current block
701     function balanceOf(address _owner) public constant returns (uint256 balance) {
702         return balanceOfAt(_owner, block.number);
703     }
704 
705     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
706     ///  its behalf. This is the standard version to allow backward compatibility.
707     /// @param _spender The address of the account able to transfer the tokens
708     /// @param _amount The amount of tokens to be approved for transfer
709     /// @return True if the approval was successful
710     function approve(address _spender, uint256 _amount) public returns (bool success) {
711         require(transfersEnabled);
712 
713         // Alerts the token controller of the approve function call
714         if (isContract(controller)) {
715             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
716         }
717 
718         allowed[msg.sender][_spender] = _amount;
719         Approval(msg.sender, _spender, _amount);
720         return true;
721     }
722 
723     /// @dev This function makes it easy to read the `allowed[]` map
724     /// @param _owner The address of the account that owns the token
725     /// @param _spender The address of the account able to transfer the tokens
726     /// @return Amount of remaining tokens of _owner that _spender is allowed
727     ///  to spend
728     function allowance(address _owner, address _spender
729     ) public constant returns (uint256 remaining) {
730         return allowed[_owner][_spender];
731     }
732 
733     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
734     ///  its behalf, and then a function is triggered in the contract that is
735     ///  being approved, `_spender`. This allows users to use their tokens to
736     ///  interact with contracts in one function call instead of two
737     /// @param _spender The address of the contract able to transfer the tokens
738     /// @param _amount The amount of tokens to be approved for transfer
739     /// @return True if the function call was successful
740     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
741     ) public returns (bool success) {
742         require(approve(_spender, _amount));
743 
744         ApproveAndCallFallBack(_spender).receiveApproval(
745             msg.sender,
746             _amount,
747             this,
748             _extraData
749         );
750 
751         return true;
752     }
753 
754     /// @dev This function makes it easy to get the total number of tokens
755     /// @return The total number of tokens
756     function totalSupply() public constant returns (uint) {
757         return totalSupplyAt(block.number);
758     }
759 
760 
761 ////////////////
762 // Query balance and totalSupply in History
763 ////////////////
764 
765     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
766     /// @param _owner The address from which the balance will be retrieved
767     /// @param _blockNumber The block number when the balance is queried
768     /// @return The balance at `_blockNumber`
769     function balanceOfAt(address _owner, uint _blockNumber) public constant
770         returns (uint) {
771 
772         // These next few lines are used when the balance of the token is
773         //  requested before a check point was ever created for this token, it
774         //  requires that the `parentToken.balanceOfAt` be queried at the
775         //  genesis block for that token as this contains initial balance of
776         //  this token
777         if ((balances[_owner].length == 0)
778             || (balances[_owner][0].fromBlock > _blockNumber)) {
779             if (address(parentToken) != 0) {
780                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
781             } else {
782                 // Has no parent
783                 return 0;
784             }
785 
786         // This will return the expected balance during normal situations
787         } else {
788             return getValueAt(balances[_owner], _blockNumber);
789         }
790     }
791 
792     /// @notice Total amount of tokens at a specific `_blockNumber`.
793     /// @param _blockNumber The block number when the totalSupply is queried
794     /// @return The total amount of tokens at `_blockNumber`
795     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
796 
797         // These next few lines are used when the totalSupply of the token is
798         //  requested before a check point was ever created for this token, it
799         //  requires that the `parentToken.totalSupplyAt` be queried at the
800         //  genesis block for this token as that contains totalSupply of this
801         //  token at this block number.
802         if ((totalSupplyHistory.length == 0)
803             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
804             if (address(parentToken) != 0) {
805                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
806             } else {
807                 return 0;
808             }
809 
810         // This will return the expected totalSupply during normal situations
811         } else {
812             return getValueAt(totalSupplyHistory, _blockNumber);
813         }
814     }
815 
816 ////////////////
817 // Clone Token Method
818 ////////////////
819 
820     /// @notice Creates a new clone token with the initial distribution being
821     ///  this token at `_snapshotBlock`
822     /// @param _cloneTokenName Name of the clone token
823     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
824     /// @param _cloneTokenSymbol Symbol of the clone token
825     /// @param _snapshotBlock Block when the distribution of the parent token is
826     ///  copied to set the initial distribution of the new clone token;
827     ///  if the block is zero than the actual block, the current block is used
828     /// @param _transfersEnabled True if transfers are allowed in the clone
829     /// @return The address of the new MiniMeToken Contract
830     function createCloneToken(
831         string _cloneTokenName,
832         uint8 _cloneDecimalUnits,
833         string _cloneTokenSymbol,
834         uint _snapshotBlock,
835         bool _transfersEnabled
836         ) public returns(address) {
837         if (_snapshotBlock == 0) _snapshotBlock = block.number;
838         MiniMeToken cloneToken = tokenFactory.createCloneToken(
839             this,
840             _snapshotBlock,
841             _cloneTokenName,
842             _cloneDecimalUnits,
843             _cloneTokenSymbol,
844             _transfersEnabled
845             );
846 
847         cloneToken.changeController(msg.sender);
848 
849         // An event to make the token easy to find on the blockchain
850         NewCloneToken(address(cloneToken), _snapshotBlock);
851         return address(cloneToken);
852     }
853 
854 ////////////////
855 // Generate and destroy tokens
856 ////////////////
857 
858     /// @notice Generates `_amount` tokens that are assigned to `_owner`
859     /// @param _owner The address that will be assigned the new tokens
860     /// @param _amount The quantity of tokens generated
861     /// @return True if the tokens are generated correctly
862     function generateTokens(address _owner, uint _amount
863     ) public onlyController returns (bool) {
864         uint curTotalSupply = totalSupply();
865         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
866         uint previousBalanceTo = balanceOf(_owner);
867         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
868         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
869         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
870         Transfer(0, _owner, _amount);
871         return true;
872     }
873 
874 
875     /// @notice Burns `_amount` tokens from `_owner`
876     /// @param _owner The address that will lose the tokens
877     /// @param _amount The quantity of tokens to burn
878     /// @return True if the tokens are burned correctly
879     function destroyTokens(address _owner, uint _amount
880     ) onlyController public returns (bool) {
881         uint curTotalSupply = totalSupply();
882         require(curTotalSupply >= _amount);
883         uint previousBalanceFrom = balanceOf(_owner);
884         require(previousBalanceFrom >= _amount);
885         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
886         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
887         Transfer(_owner, 0, _amount);
888         return true;
889     }
890 
891 ////////////////
892 // Enable tokens transfers
893 ////////////////
894 
895 
896     /// @notice Enables token holders to transfer their tokens freely if true
897     /// @param _transfersEnabled True if transfers are allowed in the clone
898     function enableTransfers(bool _transfersEnabled) public onlyController {
899         transfersEnabled = _transfersEnabled;
900     }
901 
902 ////////////////
903 // Internal helper functions to query and set a value in a snapshot array
904 ////////////////
905 
906     /// @dev `getValueAt` retrieves the number of tokens at a given block number
907     /// @param checkpoints The history of values being queried
908     /// @param _block The block number to retrieve the value at
909     /// @return The number of tokens being queried
910     function getValueAt(Checkpoint[] storage checkpoints, uint _block
911     ) constant internal returns (uint) {
912         if (checkpoints.length == 0) return 0;
913 
914         // Shortcut for the actual value
915         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
916             return checkpoints[checkpoints.length-1].value;
917         if (_block < checkpoints[0].fromBlock) return 0;
918 
919         // Binary search of the value in the array
920         uint min = 0;
921         uint max = checkpoints.length-1;
922         while (max > min) {
923             uint mid = (max + min + 1)/ 2;
924             if (checkpoints[mid].fromBlock<=_block) {
925                 min = mid;
926             } else {
927                 max = mid-1;
928             }
929         }
930         return checkpoints[min].value;
931     }
932 
933     /// @dev `updateValueAtNow` used to update the `balances` map and the
934     ///  `totalSupplyHistory`
935     /// @param checkpoints The history of data being updated
936     /// @param _value The new number of tokens
937     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
938     ) internal  {
939         if ((checkpoints.length == 0)
940         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
941                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
942                newCheckPoint.fromBlock =  uint128(block.number);
943                newCheckPoint.value = uint128(_value);
944            } else {
945                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
946                oldCheckPoint.value = uint128(_value);
947            }
948     }
949 
950     /// @dev Internal function to determine if an address is a contract
951     /// @param _addr The address being queried
952     /// @return True if `_addr` is a contract
953     function isContract(address _addr) constant internal returns(bool) {
954         uint size;
955         if (_addr == 0) return false;
956         assembly {
957             size := extcodesize(_addr)
958         }
959         return size>0;
960     }
961 
962     /// @dev Helper function to return a min betwen the two uints
963     function min(uint a, uint b) pure internal returns (uint) {
964         return a < b ? a : b;
965     }
966 
967     /// @notice The fallback function: If the contract's controller has not been
968     ///  set to 0, then the `proxyPayment` method is called which relays the
969     ///  ether and creates tokens as described in the token controller contract
970     function () public payable {
971         require(isContract(controller));
972         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
973     }
974 
975 //////////
976 // Safety Methods
977 //////////
978 
979     /// @notice This method can be used by the controller to extract mistakenly
980     ///  sent tokens to this contract.
981     /// @param _token The address of the token contract that you want to recover
982     ///  set to 0 in case you want to extract ether.
983     function claimTokens(address _token) public onlyController {
984         if (_token == 0x0) {
985             controller.transfer(this.balance);
986             return;
987         }
988 
989         MiniMeToken token = MiniMeToken(_token);
990         uint balance = token.balanceOf(this);
991         token.transfer(controller, balance);
992         ClaimedTokens(_token, controller, balance);
993     }
994 
995 ////////////////
996 // Events
997 ////////////////
998     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
999     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1000     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1001     event Approval(
1002         address indexed _owner,
1003         address indexed _spender,
1004         uint256 _amount
1005         );
1006 
1007 }
1008 
1009 
1010 ////////////////
1011 // MiniMeTokenFactory
1012 ////////////////
1013 
1014 /// @dev This contract is used to generate clone contracts from a contract.
1015 ///  In solidity this is the way to create a contract from a contract of the
1016 ///  same class
1017 contract MiniMeTokenFactory {
1018 
1019     /// @notice Update the DApp by creating a new token with new functionalities
1020     ///  the msg.sender becomes the controller of this clone token
1021     /// @param _parentToken Address of the token being cloned
1022     /// @param _snapshotBlock Block of the parent token that will
1023     ///  determine the initial distribution of the clone token
1024     /// @param _tokenName Name of the new token
1025     /// @param _decimalUnits Number of decimals of the new token
1026     /// @param _tokenSymbol Token Symbol for the new token
1027     /// @param _transfersEnabled If true, tokens will be able to be transferred
1028     /// @return The address of the new token contract
1029     function createCloneToken(
1030         address _parentToken,
1031         uint _snapshotBlock,
1032         string _tokenName,
1033         uint8 _decimalUnits,
1034         string _tokenSymbol,
1035         bool _transfersEnabled
1036     ) public returns (MiniMeToken) {
1037         MiniMeToken newToken = new MiniMeToken(
1038             this,
1039             _parentToken,
1040             _snapshotBlock,
1041             _tokenName,
1042             _decimalUnits,
1043             _tokenSymbol,
1044             _transfersEnabled
1045             );
1046 
1047         newToken.changeController(msg.sender);
1048         return newToken;
1049     }
1050 }
1051 
1052 /**
1053  *  @title KlerosLiquid
1054  *  @author Enrique Piqueras - <epiquerass@gmail.com>
1055  *  @dev The main Kleros contract with dispute resolution logic for the Athena release.
1056  */
1057 contract KlerosLiquid is TokenController, Arbitrator {
1058     /* Enums */
1059 
1060     // General
1061     enum Phase {
1062       staking, // Stake sum trees can be updated. Pass after `minStakingTime` passes and there is at least one dispute without jurors.
1063       generating, // Waiting for a random number. Pass as soon as it is ready.
1064       drawing // Jurors can be drawn. Pass after all disputes have jurors or `maxDrawingTime` passes.
1065     }
1066 
1067     // Dispute
1068     enum Period {
1069       evidence, // Evidence can be submitted. This is also when drawing has to take place.
1070       commit, // Jurors commit a hashed vote. This is skipped for courts without hidden votes.
1071       vote, // Jurors reveal/cast their vote depending on whether the court has hidden votes or not.
1072       appeal, // The dispute can be appealed.
1073       execution // Tokens are redistributed and the ruling is executed.
1074     }
1075 
1076     /* Structs */
1077 
1078     // General
1079     struct Court {
1080         uint96 parent; // The parent court.
1081         uint[] children; // List of child courts.
1082         bool hiddenVotes; // Whether to use commit and reveal or not.
1083         uint minStake; // Minimum tokens needed to stake in the court.
1084         uint alpha; // Basis point of tokens that are lost when incoherent.
1085         uint feeForJuror; // Arbitration fee paid per juror.
1086         // The appeal after the one that reaches this number of jurors will go to the parent court if any, otherwise, no more appeals are possible.
1087         uint jurorsForCourtJump;
1088         uint[4] timesPerPeriod; // The time allotted to each dispute period in the form `timesPerPeriod[period]`.
1089     }
1090     struct DelayedSetStake {
1091         address account; // The address of the juror.
1092         uint96 subcourtID; // The ID of the subcourt.
1093         uint128 stake; // The new stake.
1094     }
1095 
1096     // Dispute
1097     struct Vote {
1098         address account; // The address of the juror.
1099         bytes32 commit; // The commit of the juror. For courts with hidden votes.
1100         uint choice; // The choice of the juror.
1101         bool voted; // True if the vote has been cast or revealed, false otherwise.
1102     }
1103     struct VoteCounter {
1104         // The choice with the most votes. Note that in the case of a tie, it is the choice that reached the tied number of votes first.
1105         uint winningChoice;
1106         mapping(uint => uint) counts; // The sum of votes for each choice in the form `counts[choice]`.
1107         bool tied; // True if there is a tie, false otherwise.
1108     }
1109     struct Dispute { // Note that appeal `0` is equivalent to the first round of the dispute.
1110         uint96 subcourtID; // The ID of the subcourt the dispute is in.
1111         Arbitrable arbitrated; // The arbitrated arbitrable contract.
1112         // The number of choices jurors have when voting. This does not include choice `0` which is reserved for "refuse to arbitrate"/"no ruling".
1113         uint numberOfChoices;
1114         Period period; // The current period of the dispute.
1115         uint lastPeriodChange; // The last time the period was changed.
1116         // The votes in the form `votes[appeal][voteID]`. On each round, a new list is pushed and packed with as many empty votes as there are draws. We use `dispute.votes.length` to get the number of appeals plus 1 for the first round.
1117         Vote[][] votes;
1118         VoteCounter[] voteCounters; // The vote counters in the form `voteCounters[appeal]`.
1119         uint[] tokensAtStakePerJuror; // The amount of tokens at stake for each juror in the form `tokensAtStakePerJuror[appeal]`.
1120         uint[] totalFeesForJurors; // The total juror fees paid in the form `totalFeesForJurors[appeal]`.
1121         uint drawsInRound; // A counter of draws made in the current round.
1122         uint commitsInRound; // A counter of commits made in the current round.
1123         uint[] votesInEachRound; // A counter of votes made in each round in the form `votesInEachRound[appeal]`.
1124         // A counter of vote reward repartitions made in each round in the form `repartitionsInEachRound[appeal]`.
1125         uint[] repartitionsInEachRound;
1126         uint[] penaltiesInEachRound; // The amount of tokens collected from penalties in each round in the form `penaltiesInEachRound[appeal]`.
1127         bool ruled; // True if the ruling has been executed, false otherwise.
1128     }
1129 
1130     // Juror
1131     struct Juror {
1132         // The IDs of subcourts where the juror has stake path ends. A stake path is a path from the general court to a court the juror directly staked in using `_setStake`.
1133         uint96[] subcourtIDs;
1134         uint stakedTokens; // The juror's total amount of tokens staked in subcourts.
1135         uint lockedTokens; // The juror's total amount of tokens locked in disputes.
1136     }
1137 
1138     /* Events */
1139 
1140     /** @dev Emitted when we pass to a new phase.
1141      *  @param _phase The new phase.
1142      */
1143     event NewPhase(Phase _phase);
1144 
1145     /** @dev Emitted when a dispute passes to a new period.
1146      *  @param _disputeID The ID of the dispute.
1147      *  @param _period The new period.
1148      */
1149     event NewPeriod(uint indexed _disputeID, Period _period);
1150 
1151     /** @dev Emitted when a juror's stake is set.
1152      *  @param _address The address of the juror.
1153      *  @param _subcourtID The ID of the subcourt at the end of the stake path.
1154      *  @param _stake The new stake.
1155      *  @param _newTotalStake The new total stake.
1156      */
1157     event StakeSet(address indexed _address, uint _subcourtID, uint128 _stake, uint _newTotalStake);
1158 
1159     /** @dev Emitted when a juror is drawn.
1160      *  @param _address The drawn address.
1161      *  @param _disputeID The ID of the dispute.
1162      *  @param _appeal The appeal the draw is for. 0 is for the first round.
1163      *  @param _voteID The vote ID.
1164      */
1165     event Draw(address indexed _address, uint indexed _disputeID, uint _appeal, uint _voteID);
1166 
1167     /** @dev Emitted when a juror wins or loses tokens and ETH from a dispute.
1168      *  @param _address The juror affected.
1169      *  @param _disputeID The ID of the dispute.
1170      *  @param _tokenAmount The amount of tokens won or lost.
1171      *  @param _ETHAmount The amount of ETH won or lost.
1172      */
1173     event TokenAndETHShift(address indexed _address, uint indexed _disputeID, int _tokenAmount, int _ETHAmount);
1174 
1175     /* Storage */
1176 
1177     // General Constants
1178     uint public constant MAX_STAKE_PATHS = 4; // The maximum number of stake paths a juror can have.
1179     uint public constant MIN_JURORS = 3; // The global default minimum number of jurors in a dispute.
1180     uint public constant NON_PAYABLE_AMOUNT = (2 ** 256 - 2) / 2; // An amount higher than the supply of ETH.
1181     uint public constant ALPHA_DIVISOR = 1e4; // The number to divide `Court.alpha` by.
1182     // General Contracts
1183     address public governor; // The governor of the contract.
1184     MiniMeToken public pinakion; // The Pinakion token contract.
1185     RNG public RNGenerator; // The random number generator contract.
1186     // General Dynamic
1187     Phase public phase; // The current phase.
1188     uint public lastPhaseChange; // The last time the phase was changed.
1189     uint public disputesWithoutJurors; // The number of disputes that have not finished drawing jurors.
1190     // The block number to get the next random number from. Used so there is at least a 1 block difference from the staking phase.
1191     uint public RNBlock;
1192     uint public RN; // The current random number.
1193     uint public minStakingTime; // The minimum staking time.
1194     uint public maxDrawingTime; // The maximum drawing time.
1195     // True if insolvent (`balance < stakedTokens || balance < lockedTokens`) token transfers should be blocked. Used to avoid blocking penalties.
1196     bool public lockInsolventTransfers = true;
1197     // General Storage
1198     Court[] public courts; // The subcourts.
1199     using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees; // Use library functions for sortition sum trees.
1200     SortitionSumTreeFactory.SortitionSumTrees internal sortitionSumTrees; // The sortition sum trees.
1201     // The delayed calls to `_setStake`. Used to schedule `_setStake`s when not in the staking phase.
1202     mapping(uint => DelayedSetStake) public delayedSetStakes;
1203     // The index of the next `delayedSetStakes` item to execute. Starts at 1 because `lastDelayedSetStake` starts at 0.
1204     uint public nextDelayedSetStake = 1;
1205     uint public lastDelayedSetStake; // The index of the last `delayedSetStakes` item. 0 is skipped because it is the initial value.
1206 
1207     // Dispute
1208     Dispute[] public disputes; // The disputes.
1209 
1210     // Juror
1211     mapping(address => Juror) public jurors; // The jurors.
1212 
1213     /* Modifiers */
1214 
1215     /** @dev Requires a specific phase.
1216      *  @param _phase The required phase.
1217      */
1218     modifier onlyDuringPhase(Phase _phase) {require(phase == _phase); _;}
1219 
1220     /** @dev Requires a specific period in a dispute.
1221      *  @param _disputeID The ID of the dispute.
1222      *  @param _period The required period.
1223      */
1224     modifier onlyDuringPeriod(uint _disputeID, Period _period) {require(disputes[_disputeID].period == _period); _;}
1225 
1226     /** @dev Requires that the sender is the governor. Note that the governor is expected to not be malicious. */
1227     modifier onlyByGovernor() {require(governor == msg.sender); _;}
1228 
1229     /* Constructor */
1230 
1231     /** @dev Constructs the KlerosLiquid contract.
1232      *  @param _governor The governor's address.
1233      *  @param _pinakion The address of the token contract.
1234      *  @param _RNGenerator The address of the RNG contract.
1235      *  @param _minStakingTime The minimum time that the staking phase should last.
1236      *  @param _maxDrawingTime The maximum time that the drawing phase should last.
1237      *  @param _hiddenVotes The `hiddenVotes` property value of the general court.
1238      *  @param _minStake The `minStake` property value of the general court.
1239      *  @param _alpha The `alpha` property value of the general court.
1240      *  @param _feeForJuror The `feeForJuror` property value of the general court.
1241      *  @param _jurorsForCourtJump The `jurorsForCourtJump` property value of the general court.
1242      *  @param _timesPerPeriod The `timesPerPeriod` property value of the general court.
1243      *  @param _sortitionSumTreeK The number of children per node of the general court's sortition sum tree.
1244      */
1245     constructor(
1246         address _governor,
1247         MiniMeToken _pinakion,
1248         RNG _RNGenerator,
1249         uint _minStakingTime,
1250         uint _maxDrawingTime,
1251         bool _hiddenVotes,
1252         uint _minStake,
1253         uint _alpha,
1254         uint _feeForJuror,
1255         uint _jurorsForCourtJump,
1256         uint[4] _timesPerPeriod,
1257         uint _sortitionSumTreeK
1258     ) public {
1259         // Initialize contract.
1260         governor = _governor;
1261         pinakion = _pinakion;
1262         RNGenerator = _RNGenerator;
1263         minStakingTime = _minStakingTime;
1264         maxDrawingTime = _maxDrawingTime;
1265         lastPhaseChange = now;
1266 
1267         // Create the general court.
1268         courts.push(Court({
1269             parent: 0,
1270             children: new uint[](0),
1271             hiddenVotes: _hiddenVotes,
1272             minStake: _minStake,
1273             alpha: _alpha,
1274             feeForJuror: _feeForJuror,
1275             jurorsForCourtJump: _jurorsForCourtJump,
1276             timesPerPeriod: _timesPerPeriod
1277         }));
1278         sortitionSumTrees.createTree(bytes32(0), _sortitionSumTreeK);
1279     }
1280 
1281     /* External */
1282 
1283     /** @dev Lets the governor call anything on behalf of the contract.
1284      *  @param _destination The destination of the call.
1285      *  @param _amount The value sent with the call.
1286      *  @param _data The data sent with the call.
1287      */
1288     function executeGovernorProposal(address _destination, uint _amount, bytes _data) external onlyByGovernor {
1289         require(_destination.call.value(_amount)(_data)); // solium-disable-line security/no-call-value
1290     }
1291 
1292     /** @dev Changes the `governor` storage variable.
1293      *  @param _governor The new value for the `governor` storage variable.
1294      */
1295     function changeGovernor(address _governor) external onlyByGovernor {
1296         governor = _governor;
1297     }
1298 
1299     /** @dev Changes the `pinakion` storage variable.
1300      *  @param _pinakion The new value for the `pinakion` storage variable.
1301      */
1302     function changePinakion(MiniMeToken _pinakion) external onlyByGovernor {
1303         pinakion = _pinakion;
1304     }
1305 
1306     /** @dev Changes the `RNGenerator` storage variable.
1307      *  @param _RNGenerator The new value for the `RNGenerator` storage variable.
1308      */
1309     function changeRNGenerator(RNG _RNGenerator) external onlyByGovernor {
1310         RNGenerator = _RNGenerator;
1311         if (phase == Phase.generating) {
1312             RNBlock = block.number + 1;
1313             RNGenerator.requestRN(RNBlock);
1314         }
1315     }
1316 
1317     /** @dev Changes the `minStakingTime` storage variable.
1318      *  @param _minStakingTime The new value for the `minStakingTime` storage variable.
1319      */
1320     function changeMinStakingTime(uint _minStakingTime) external onlyByGovernor {
1321         minStakingTime = _minStakingTime;
1322     }
1323 
1324     /** @dev Changes the `maxDrawingTime` storage variable.
1325      *  @param _maxDrawingTime The new value for the `maxDrawingTime` storage variable.
1326      */
1327     function changeMaxDrawingTime(uint _maxDrawingTime) external onlyByGovernor {
1328         maxDrawingTime = _maxDrawingTime;
1329     }
1330 
1331     /** @dev Creates a subcourt under a specified parent court.
1332      *  @param _parent The `parent` property value of the subcourt.
1333      *  @param _hiddenVotes The `hiddenVotes` property value of the subcourt.
1334      *  @param _minStake The `minStake` property value of the subcourt.
1335      *  @param _alpha The `alpha` property value of the subcourt.
1336      *  @param _feeForJuror The `feeForJuror` property value of the subcourt.
1337      *  @param _jurorsForCourtJump The `jurorsForCourtJump` property value of the subcourt.
1338      *  @param _timesPerPeriod The `timesPerPeriod` property value of the subcourt.
1339      *  @param _sortitionSumTreeK The number of children per node of the subcourt's sortition sum tree.
1340      */
1341     function createSubcourt(
1342         uint96 _parent,
1343         bool _hiddenVotes,
1344         uint _minStake,
1345         uint _alpha,
1346         uint _feeForJuror,
1347         uint _jurorsForCourtJump,
1348         uint[4] _timesPerPeriod,
1349         uint _sortitionSumTreeK
1350     ) external onlyByGovernor {
1351         require(courts[_parent].minStake <= _minStake, "A subcourt cannot be a child of a subcourt with a higher minimum stake.");
1352 
1353         // Create the subcourt.
1354         uint96 subcourtID = uint96(
1355             courts.push(Court({
1356                 parent: _parent,
1357                 children: new uint[](0),
1358                 hiddenVotes: _hiddenVotes,
1359                 minStake: _minStake,
1360                 alpha: _alpha,
1361                 feeForJuror: _feeForJuror,
1362                 jurorsForCourtJump: _jurorsForCourtJump,
1363                 timesPerPeriod: _timesPerPeriod
1364             })) - 1
1365         );
1366         sortitionSumTrees.createTree(bytes32(subcourtID), _sortitionSumTreeK);
1367 
1368         // Update the parent.
1369         courts[_parent].children.push(subcourtID);
1370     }
1371 
1372     /** @dev Changes the `minStake` property value of a specified subcourt. Don't set to a value lower than its parent's `minStake` property value.
1373      *  @param _subcourtID The ID of the subcourt.
1374      *  @param _minStake The new value for the `minStake` property value.
1375      */
1376     function changeSubcourtMinStake(uint96 _subcourtID, uint _minStake) external onlyByGovernor {
1377         require(_subcourtID == 0 || courts[courts[_subcourtID].parent].minStake <= _minStake);
1378         for (uint i = 0; i < courts[_subcourtID].children.length; i++) {
1379             require(
1380                 courts[courts[_subcourtID].children[i]].minStake >= _minStake,
1381                 "A subcourt cannot be the parent of a subcourt with a lower minimum stake."
1382             );
1383         }
1384 
1385         courts[_subcourtID].minStake = _minStake;
1386     }
1387 
1388     /** @dev Changes the `alpha` property value of a specified subcourt.
1389      *  @param _subcourtID The ID of the subcourt.
1390      *  @param _alpha The new value for the `alpha` property value.
1391      */
1392     function changeSubcourtAlpha(uint96 _subcourtID, uint _alpha) external onlyByGovernor {
1393         courts[_subcourtID].alpha = _alpha;
1394     }
1395 
1396     /** @dev Changes the `feeForJuror` property value of a specified subcourt.
1397      *  @param _subcourtID The ID of the subcourt.
1398      *  @param _feeForJuror The new value for the `feeForJuror` property value.
1399      */
1400     function changeSubcourtJurorFee(uint96 _subcourtID, uint _feeForJuror) external onlyByGovernor {
1401         courts[_subcourtID].feeForJuror = _feeForJuror;
1402     }
1403 
1404     /** @dev Changes the `jurorsForCourtJump` property value of a specified subcourt.
1405      *  @param _subcourtID The ID of the subcourt.
1406      *  @param _jurorsForCourtJump The new value for the `jurorsForCourtJump` property value.
1407      */
1408     function changeSubcourtJurorsForJump(uint96 _subcourtID, uint _jurorsForCourtJump) external onlyByGovernor {
1409         courts[_subcourtID].jurorsForCourtJump = _jurorsForCourtJump;
1410     }
1411 
1412     /** @dev Changes the `timesPerPeriod` property value of a specified subcourt.
1413      *  @param _subcourtID The ID of the subcourt.
1414      *  @param _timesPerPeriod The new value for the `timesPerPeriod` property value.
1415      */
1416     function changeSubcourtTimesPerPeriod(uint96 _subcourtID, uint[4] _timesPerPeriod) external onlyByGovernor {
1417         courts[_subcourtID].timesPerPeriod = _timesPerPeriod;
1418     }
1419 
1420     /** @dev Passes the phase. TRUSTED */
1421     function passPhase() external {
1422         if (phase == Phase.staking) {
1423             require(now - lastPhaseChange >= minStakingTime, "The minimum staking time has not passed yet.");
1424             require(disputesWithoutJurors > 0, "There are no disputes that need jurors.");
1425             RNBlock = block.number + 1;
1426             RNGenerator.requestRN(RNBlock);
1427             phase = Phase.generating;
1428         } else if (phase == Phase.generating) {
1429             RN = RNGenerator.getUncorrelatedRN(RNBlock);
1430             require(RN != 0, "Random number is not ready yet.");
1431             phase = Phase.drawing;
1432         } else if (phase == Phase.drawing) {
1433             require(disputesWithoutJurors == 0 || now - lastPhaseChange >= maxDrawingTime, "There are still disputes without jurors and the maximum drawing time has not passed yet.");
1434             phase = Phase.staking;
1435         }
1436 
1437         lastPhaseChange = now;
1438         emit NewPhase(phase);
1439     }
1440 
1441     /** @dev Passes the period of a specified dispute.
1442      *  @param _disputeID The ID of the dispute.
1443      */
1444     function passPeriod(uint _disputeID) external {
1445         Dispute storage dispute = disputes[_disputeID];
1446         if (dispute.period == Period.evidence) {
1447             require(
1448                 dispute.votes.length > 1 || now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)],
1449                 "The evidence period time has not passed yet and it is not an appeal."
1450             );
1451             require(dispute.drawsInRound == dispute.votes[dispute.votes.length - 1].length, "The dispute has not finished drawing yet.");
1452             dispute.period = courts[dispute.subcourtID].hiddenVotes ? Period.commit : Period.vote;
1453         } else if (dispute.period == Period.commit) {
1454             require(
1455                 now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)] || dispute.commitsInRound == dispute.votes[dispute.votes.length - 1].length,
1456                 "The commit period time has not passed yet and not every juror has committed yet."
1457             );
1458             dispute.period = Period.vote;
1459         } else if (dispute.period == Period.vote) {
1460             require(
1461                 now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)] || dispute.votesInEachRound[dispute.votes.length - 1] == dispute.votes[dispute.votes.length - 1].length,
1462                 "The vote period time has not passed yet and not every juror has voted yet."
1463             );
1464             dispute.period = Period.appeal;
1465             emit AppealPossible(_disputeID, dispute.arbitrated);
1466         } else if (dispute.period == Period.appeal) {
1467             require(now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)], "The appeal period time has not passed yet.");
1468             dispute.period = Period.execution;
1469         } else if (dispute.period == Period.execution) {
1470             revert("The dispute is already in the last period.");
1471         }
1472 
1473         dispute.lastPeriodChange = now;
1474         emit NewPeriod(_disputeID, dispute.period);
1475     }
1476 
1477     /** @dev Sets the caller's stake in a subcourt.
1478      *  @param _subcourtID The ID of the subcourt.
1479      *  @param _stake The new stake.
1480      */
1481     function setStake(uint96 _subcourtID, uint128 _stake) external {
1482         require(_setStake(msg.sender, _subcourtID, _stake));
1483     }
1484 
1485     /** @dev Executes the next delayed set stakes.
1486      *  @param _iterations The number of delayed set stakes to execute.
1487      */
1488     function executeDelayedSetStakes(uint _iterations) external onlyDuringPhase(Phase.staking) {
1489         uint actualIterations = (nextDelayedSetStake + _iterations) - 1 > lastDelayedSetStake ?
1490             (lastDelayedSetStake - nextDelayedSetStake) + 1 : _iterations;
1491         uint newNextDelayedSetStake = nextDelayedSetStake + actualIterations;
1492         require(newNextDelayedSetStake >= nextDelayedSetStake);
1493         for (uint i = nextDelayedSetStake; i < newNextDelayedSetStake; i++) {
1494             DelayedSetStake storage delayedSetStake = delayedSetStakes[i];
1495             _setStake(delayedSetStake.account, delayedSetStake.subcourtID, delayedSetStake.stake);
1496             delete delayedSetStakes[i];
1497         }
1498         nextDelayedSetStake = newNextDelayedSetStake;
1499     }
1500 
1501     /** @dev Draws jurors for a dispute. Can be called in parts.
1502      *  `O(n * k * log_k(j))` where
1503      *  `n` is the number of iterations to run,
1504      *  `k` is the number of children per node of the dispute's court's sortition sum tree,
1505      *  and `j` is the maximum number of jurors that ever staked in it simultaneously.
1506      *  @param _disputeID The ID of the dispute.
1507      *  @param _iterations The number of iterations to run.
1508      */
1509     function drawJurors(
1510         uint _disputeID,
1511         uint _iterations
1512     ) external onlyDuringPhase(Phase.drawing) onlyDuringPeriod(_disputeID, Period.evidence) {
1513         Dispute storage dispute = disputes[_disputeID];
1514         uint endIndex = dispute.drawsInRound + _iterations;
1515         require(endIndex >= dispute.drawsInRound);
1516 
1517         // Avoid going out of range.
1518         if (endIndex > dispute.votes[dispute.votes.length - 1].length) endIndex = dispute.votes[dispute.votes.length - 1].length;
1519         for (uint i = dispute.drawsInRound; i < endIndex; i++) {
1520             // Draw from sortition tree.
1521             (
1522                 address drawnAddress,
1523                 uint subcourtID
1524             ) = stakePathIDToAccountAndSubcourtID(sortitionSumTrees.draw(bytes32(dispute.subcourtID), uint(keccak256(RN, _disputeID, i))));
1525 
1526             // Save the vote.
1527             dispute.votes[dispute.votes.length - 1][i].account = drawnAddress;
1528             jurors[drawnAddress].lockedTokens += dispute.tokensAtStakePerJuror[dispute.tokensAtStakePerJuror.length - 1];
1529             emit Draw(drawnAddress, _disputeID, dispute.votes.length - 1, i);
1530 
1531             // If dispute is fully drawn.
1532             if (i == dispute.votes[dispute.votes.length - 1].length - 1) disputesWithoutJurors--;
1533         }
1534         dispute.drawsInRound = endIndex;
1535     }
1536 
1537     /** @dev Sets the caller's commit for the specified votes.
1538      *  `O(n)` where
1539      *  `n` is the number of votes.
1540      *  @param _disputeID The ID of the dispute.
1541      *  @param _voteIDs The IDs of the votes.
1542      *  @param _commit The commit.
1543      */
1544     function castCommit(uint _disputeID, uint[] _voteIDs, bytes32 _commit) external onlyDuringPeriod(_disputeID, Period.commit) {
1545         Dispute storage dispute = disputes[_disputeID];
1546         require(_commit != bytes32(0));
1547         for (uint i = 0; i < _voteIDs.length; i++) {
1548             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].account == msg.sender, "The caller has to own the vote.");
1549             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit == bytes32(0), "Already committed this vote.");
1550             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit = _commit;
1551         }
1552         dispute.commitsInRound += _voteIDs.length;
1553     }
1554 
1555     /** @dev Sets the caller's choices for the specified votes.
1556      *  `O(n)` where
1557      *  `n` is the number of votes.
1558      *  @param _disputeID The ID of the dispute.
1559      *  @param _voteIDs The IDs of the votes.
1560      *  @param _choice The choice.
1561      *  @param _salt The salt for the commit if the votes were hidden.
1562      */
1563     function castVote(uint _disputeID, uint[] _voteIDs, uint _choice, uint _salt) external onlyDuringPeriod(_disputeID, Period.vote) {
1564         Dispute storage dispute = disputes[_disputeID];
1565         require(_voteIDs.length > 0);
1566         require(_choice <= dispute.numberOfChoices, "The choice has to be less than or equal to the number of choices for the dispute.");
1567 
1568         // Save the votes.
1569         for (uint i = 0; i < _voteIDs.length; i++) {
1570             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].account == msg.sender, "The caller has to own the vote.");
1571             require(
1572                 !courts[dispute.subcourtID].hiddenVotes || dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit == keccak256(_choice, _salt),
1573                 "The commit must match the choice in subcourts with hidden votes."
1574             );
1575             require(!dispute.votes[dispute.votes.length - 1][_voteIDs[i]].voted, "Vote already cast.");
1576             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].choice = _choice;
1577             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].voted = true;
1578         }
1579         dispute.votesInEachRound[dispute.votes.length - 1] += _voteIDs.length;
1580 
1581         // Update winning choice.
1582         VoteCounter storage voteCounter = dispute.voteCounters[dispute.voteCounters.length - 1];
1583         voteCounter.counts[_choice] += _voteIDs.length;
1584         if (_choice == voteCounter.winningChoice) { // Voted for the winning choice.
1585             if (voteCounter.tied) voteCounter.tied = false; // Potentially broke tie.
1586         } else { // Voted for another choice.
1587             if (voteCounter.counts[_choice] == voteCounter.counts[voteCounter.winningChoice]) { // Tie.
1588                 if (!voteCounter.tied) voteCounter.tied = true;
1589             } else if (voteCounter.counts[_choice] > voteCounter.counts[voteCounter.winningChoice]) { // New winner.
1590                 voteCounter.winningChoice = _choice;
1591                 voteCounter.tied = false;
1592             }
1593         }
1594     }
1595 
1596     /** @dev Computes the token and ETH rewards for a specified appeal in a specified dispute.
1597      *  @param _disputeID The ID of the dispute.
1598      *  @param _appeal The appeal.
1599      *  @return The token and ETH rewards.
1600      */
1601     function computeTokenAndETHRewards(uint _disputeID, uint _appeal) private view returns(uint tokenReward, uint ETHReward) {
1602         Dispute storage dispute = disputes[_disputeID];
1603 
1604         // Distribute penalties and arbitration fees.
1605         if (dispute.voteCounters[dispute.voteCounters.length - 1].tied) {
1606             // Distribute penalties and fees evenly between active jurors.
1607             uint activeCount = dispute.votesInEachRound[_appeal];
1608             if (activeCount > 0) {
1609                 tokenReward = dispute.penaltiesInEachRound[_appeal] / activeCount;
1610                 ETHReward = dispute.totalFeesForJurors[_appeal] / activeCount;
1611             } else {
1612                 tokenReward = 0;
1613                 ETHReward = 0;
1614             }
1615         } else {
1616             // Distribute penalties and fees evenly between coherent jurors.
1617             uint winningChoice = dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
1618             uint coherentCount = dispute.voteCounters[_appeal].counts[winningChoice];
1619             tokenReward = dispute.penaltiesInEachRound[_appeal] / coherentCount;
1620             ETHReward = dispute.totalFeesForJurors[_appeal] / coherentCount;
1621         }
1622     }
1623 
1624     /** @dev Repartitions tokens and ETH for a specified appeal in a specified dispute. Can be called in parts.
1625      *  `O(i + u * n * (n + p * log_k(j)))` where
1626      *  `i` is the number of iterations to run,
1627      *  `u` is the number of jurors that need to be unstaked,
1628      *  `n` is the maximum number of subcourts one of these jurors has staked in,
1629      *  `p` is the depth of the subcourt tree,
1630      *  `k` is the minimum number of children per node of one of these subcourts' sortition sum tree,
1631      *  and `j` is the maximum number of jurors that ever staked in one of these subcourts simultaneously.
1632      *  @param _disputeID The ID of the dispute.
1633      *  @param _appeal The appeal.
1634      *  @param _iterations The number of iterations to run.
1635      */
1636     function execute(uint _disputeID, uint _appeal, uint _iterations) external onlyDuringPeriod(_disputeID, Period.execution) {
1637         lockInsolventTransfers = false;
1638         Dispute storage dispute = disputes[_disputeID];
1639         uint end = dispute.repartitionsInEachRound[_appeal] + _iterations;
1640         require(end >= dispute.repartitionsInEachRound[_appeal]);
1641         uint penaltiesInRoundCache = dispute.penaltiesInEachRound[_appeal]; // For saving gas.
1642         (uint tokenReward, uint ETHReward) = (0, 0);
1643 
1644         // Avoid going out of range.
1645         if (
1646             !dispute.voteCounters[dispute.voteCounters.length - 1].tied &&
1647             dispute.voteCounters[_appeal].counts[dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice] == 0
1648         ) {
1649             // We loop over the votes once as there are no rewards because it is not a tie and no one in this round is coherent with the final outcome.
1650             if (end > dispute.votes[_appeal].length) end = dispute.votes[_appeal].length;
1651         } else {
1652             // We loop over the votes twice, first to collect penalties, and second to distribute them as rewards along with arbitration fees.
1653             (tokenReward, ETHReward) = dispute.repartitionsInEachRound[_appeal] >= dispute.votes[_appeal].length ? computeTokenAndETHRewards(_disputeID, _appeal) : (0, 0); // Compute rewards if rewarding.
1654             if (end > dispute.votes[_appeal].length * 2) end = dispute.votes[_appeal].length * 2;
1655         }
1656         for (uint i = dispute.repartitionsInEachRound[_appeal]; i < end; i++) {
1657             Vote storage vote = dispute.votes[_appeal][i % dispute.votes[_appeal].length];
1658             if (
1659                 vote.voted &&
1660                 (vote.choice == dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice || dispute.voteCounters[dispute.voteCounters.length - 1].tied)
1661             ) { // Juror was active, and voted coherently or it was a tie.
1662                 if (i >= dispute.votes[_appeal].length) { // Only execute in the second half of the iterations.
1663 
1664                     // Reward.
1665                     pinakion.transfer(vote.account, tokenReward);
1666                     // Intentional use to avoid blocking.
1667                     vote.account.send(ETHReward); // solium-disable-line security/no-send
1668                     emit TokenAndETHShift(vote.account, _disputeID, int(tokenReward), int(ETHReward));
1669                     jurors[vote.account].lockedTokens -= dispute.tokensAtStakePerJuror[_appeal];
1670                 }
1671             } else { // Juror was inactive, or voted incoherently and it was not a tie.
1672                 if (i < dispute.votes[_appeal].length) { // Only execute in the first half of the iterations.
1673 
1674                     // Penalize.
1675                     uint penalty = dispute.tokensAtStakePerJuror[_appeal] > pinakion.balanceOf(vote.account) ? pinakion.balanceOf(vote.account) : dispute.tokensAtStakePerJuror[_appeal];
1676                     pinakion.transferFrom(vote.account, this, penalty);
1677                     emit TokenAndETHShift(vote.account, _disputeID, -int(penalty), 0);
1678                     penaltiesInRoundCache += penalty;
1679                     jurors[vote.account].lockedTokens -= dispute.tokensAtStakePerJuror[_appeal];
1680 
1681                     // Unstake juror if his penalty made balance less than his total stake or if he lost due to inactivity.
1682                     if (pinakion.balanceOf(vote.account) < jurors[vote.account].stakedTokens || !vote.voted)
1683                         for (uint j = 0; j < jurors[vote.account].subcourtIDs.length; j++)
1684                             _setStake(vote.account, jurors[vote.account].subcourtIDs[j], 0);
1685 
1686                 }
1687             }
1688             if (i == dispute.votes[_appeal].length - 1) {
1689                 // Send fees and tokens to the governor if no one was coherent.
1690                 if (dispute.votesInEachRound[_appeal] == 0 || !dispute.voteCounters[dispute.voteCounters.length - 1].tied && dispute.voteCounters[_appeal].counts[dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice] == 0) {
1691                     // Intentional use to avoid blocking.
1692                     governor.send(dispute.totalFeesForJurors[_appeal]); // solium-disable-line security/no-send
1693                     pinakion.transfer(governor, penaltiesInRoundCache);
1694                 } else if (i + 1 < end) {
1695                     // Compute rewards because we are going into rewarding.
1696                     dispute.penaltiesInEachRound[_appeal] = penaltiesInRoundCache;
1697                     (tokenReward, ETHReward) = computeTokenAndETHRewards(_disputeID, _appeal);
1698                 }
1699             }
1700         }
1701         if (dispute.penaltiesInEachRound[_appeal] != penaltiesInRoundCache) dispute.penaltiesInEachRound[_appeal] = penaltiesInRoundCache;
1702         dispute.repartitionsInEachRound[_appeal] = end;
1703         lockInsolventTransfers = true;
1704     }
1705 
1706     /** @dev Executes a specified dispute's ruling. UNTRUSTED.
1707      *  @param _disputeID The ID of the dispute.
1708      */
1709     function executeRuling(uint _disputeID) external onlyDuringPeriod(_disputeID, Period.execution) {
1710         Dispute storage dispute = disputes[_disputeID];
1711         require(!dispute.ruled, "Ruling already executed.");
1712         dispute.ruled = true;
1713         uint winningChoice = dispute.voteCounters[dispute.voteCounters.length - 1].tied ? 0
1714             : dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
1715         dispute.arbitrated.rule(_disputeID, winningChoice);
1716     }
1717 
1718     /* Public */
1719 
1720     /** @dev Creates a dispute. Must be called by the arbitrable contract.
1721      *  @param _numberOfChoices Number of choices to choose from in the dispute to be created.
1722      *  @param _extraData Additional info about the dispute to be created. We use it to pass the ID of the subcourt to create the dispute in (first 32 bytes) and the minimum number of jurors required (next 32 bytes).
1723      *  @return The ID of the created dispute.
1724      */
1725     function createDispute(
1726         uint _numberOfChoices,
1727         bytes _extraData
1728     ) public payable requireArbitrationFee(_extraData) returns(uint disputeID)  {
1729         (uint96 subcourtID, uint minJurors) = extraDataToSubcourtIDAndMinJurors(_extraData);
1730         disputeID = disputes.length++;
1731         Dispute storage dispute = disputes[disputeID];
1732         dispute.subcourtID = subcourtID;
1733         dispute.arbitrated = Arbitrable(msg.sender);
1734         dispute.numberOfChoices = _numberOfChoices;
1735         dispute.period = Period.evidence;
1736         dispute.lastPeriodChange = now;
1737         // As many votes that can be afforded by the provided funds.
1738         dispute.votes[dispute.votes.length++].length = msg.value / courts[dispute.subcourtID].feeForJuror;
1739         dispute.voteCounters[dispute.voteCounters.length++].tied = true;
1740         dispute.tokensAtStakePerJuror.push((courts[dispute.subcourtID].minStake * courts[dispute.subcourtID].alpha) / ALPHA_DIVISOR);
1741         dispute.totalFeesForJurors.push(msg.value);
1742         dispute.votesInEachRound.push(0);
1743         dispute.repartitionsInEachRound.push(0);
1744         dispute.penaltiesInEachRound.push(0);
1745         disputesWithoutJurors++;
1746 
1747         emit DisputeCreation(disputeID, Arbitrable(msg.sender));
1748     }
1749 
1750     /** @dev Appeals the ruling of a specified dispute.
1751      *  @param _disputeID The ID of the dispute.
1752      *  @param _extraData Additional info about the appeal. Not used by this contract.
1753      */
1754     function appeal(
1755         uint _disputeID,
1756         bytes _extraData
1757     ) public payable requireAppealFee(_disputeID, _extraData) onlyDuringPeriod(_disputeID, Period.appeal) {
1758         Dispute storage dispute = disputes[_disputeID];
1759         require(
1760             msg.sender == address(dispute.arbitrated),
1761             "Can only be called by the arbitrable contract."
1762         );
1763         if (dispute.votes[dispute.votes.length - 1].length >= courts[dispute.subcourtID].jurorsForCourtJump) // Jump to parent subcourt.
1764             dispute.subcourtID = courts[dispute.subcourtID].parent;
1765         dispute.period = Period.evidence;
1766         dispute.lastPeriodChange = now;
1767         // As many votes that can be afforded by the provided funds.
1768         dispute.votes[dispute.votes.length++].length = msg.value / courts[dispute.subcourtID].feeForJuror;
1769         dispute.voteCounters[dispute.voteCounters.length++].tied = true;
1770         dispute.tokensAtStakePerJuror.push((courts[dispute.subcourtID].minStake * courts[dispute.subcourtID].alpha) / ALPHA_DIVISOR);
1771         dispute.totalFeesForJurors.push(msg.value);
1772         dispute.drawsInRound = 0;
1773         dispute.commitsInRound = 0;
1774         dispute.votesInEachRound.push(0);
1775         dispute.repartitionsInEachRound.push(0);
1776         dispute.penaltiesInEachRound.push(0);
1777         disputesWithoutJurors++;
1778 
1779         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
1780     }
1781 
1782     /** @dev Called when `_owner` sends ether to the MiniMe Token contract.
1783      *  @param _owner The address that sent the ether to create tokens.
1784      *  @return Whether the operation should be allowed or not.
1785      */
1786     function proxyPayment(address _owner) public payable returns(bool allowed) { allowed = false; }
1787 
1788     /** @dev Notifies the controller about a token transfer allowing the controller to react if desired.
1789      *  @param _from The origin of the transfer.
1790      *  @param _to The destination of the transfer.
1791      *  @param _amount The amount of the transfer.
1792      *  @return Whether the operation should be allowed or not.
1793      */
1794     function onTransfer(address _from, address _to, uint _amount) public returns(bool allowed) {
1795         if (lockInsolventTransfers) { // Never block penalties or rewards.
1796             uint newBalance = pinakion.balanceOf(_from) - _amount;
1797             if (newBalance < jurors[_from].stakedTokens || newBalance < jurors[_from].lockedTokens) return false;
1798         }
1799         allowed = true;
1800     }
1801 
1802     /** @dev Notifies the controller about an approval allowing the controller to react if desired.
1803      *  @param _owner The address that calls `approve()`.
1804      *  @param _spender The spender in the `approve()` call.
1805      *  @param _amount The amount in the `approve()` call.
1806      *  @return Whether the operation should be allowed or not.
1807      */
1808     function onApprove(address _owner, address _spender, uint _amount) public returns(bool allowed) { allowed = true; }
1809 
1810     /* Public Views */
1811 
1812     /** @dev Gets the cost of arbitration in a specified subcourt.
1813      *  @param _extraData Additional info about the dispute. We use it to pass the ID of the subcourt to create the dispute in (first 32 bytes) and the minimum number of jurors required (next 32 bytes).
1814      *  @return The cost.
1815      */
1816     function arbitrationCost(bytes _extraData) public view returns(uint cost) {
1817         (uint96 subcourtID, uint minJurors) = extraDataToSubcourtIDAndMinJurors(_extraData);
1818         cost = courts[subcourtID].feeForJuror * minJurors;
1819     }
1820 
1821     /** @dev Gets the cost of appealing a specified dispute.
1822      *  @param _disputeID The ID of the dispute.
1823      *  @param _extraData Additional info about the appeal. Not used by this contract.
1824      *  @return The cost.
1825      */
1826     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint cost) {
1827         Dispute storage dispute = disputes[_disputeID];
1828         uint lastNumberOfJurors = dispute.votes[dispute.votes.length - 1].length;
1829         if (lastNumberOfJurors >= courts[dispute.subcourtID].jurorsForCourtJump) { // Jump to parent subcourt.
1830             if (dispute.subcourtID == 0) // Already in the general court.
1831                 cost = NON_PAYABLE_AMOUNT;
1832             else // Get the cost of the parent subcourt.
1833                 cost = courts[courts[dispute.subcourtID].parent].feeForJuror * ((lastNumberOfJurors * 2) + 1);
1834         } else // Stay in current subcourt.
1835             cost = courts[dispute.subcourtID].feeForJuror * ((lastNumberOfJurors * 2) + 1);
1836     }
1837 
1838     /** @dev Gets the start and end of a specified dispute's current appeal period.
1839      *  @param _disputeID The ID of the dispute.
1840      *  @return The start and end of the appeal period.
1841      */
1842     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {
1843         Dispute storage dispute = disputes[_disputeID];
1844         if (dispute.period == Period.appeal) {
1845             start = dispute.lastPeriodChange;
1846             end = dispute.lastPeriodChange + courts[dispute.subcourtID].timesPerPeriod[uint(Period.appeal)];
1847         } else {
1848             start = 0;
1849             end = 0;
1850         }
1851     }
1852 
1853     /** @dev Gets the status of a specified dispute.
1854      *  @param _disputeID The ID of the dispute.
1855      *  @return The status.
1856      */
1857     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status) {
1858         Dispute storage dispute = disputes[_disputeID];
1859         if (dispute.period < Period.appeal) status = DisputeStatus.Waiting;
1860         else if (dispute.period < Period.execution) status = DisputeStatus.Appealable;
1861         else status = DisputeStatus.Solved;
1862     }
1863 
1864     /** @dev Gets the current ruling of a specified dispute.
1865      *  @param _disputeID The ID of the dispute.
1866      *  @return The current ruling.
1867      */
1868     function currentRuling(uint _disputeID) public view returns(uint ruling) {
1869         Dispute storage dispute = disputes[_disputeID];
1870         ruling = dispute.voteCounters[dispute.voteCounters.length - 1].tied ? 0
1871             : dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
1872     }
1873 
1874     /* Internal */
1875 
1876     /** @dev Sets the specified juror's stake in a subcourt.
1877      *  `O(n + p * log_k(j))` where
1878      *  `n` is the number of subcourts the juror has staked in,
1879      *  `p` is the depth of the subcourt tree,
1880      *  `k` is the minimum number of children per node of one of these subcourts' sortition sum tree,
1881      *  and `j` is the maximum number of jurors that ever staked in one of these subcourts simultaneously.
1882      *  @param _account The address of the juror.
1883      *  @param _subcourtID The ID of the subcourt.
1884      *  @param _stake The new stake.
1885      *  @return True if the call succeeded, false otherwise.
1886      */
1887     function _setStake(address _account, uint96 _subcourtID, uint128 _stake) internal returns(bool succeeded) {
1888         if (!(_subcourtID < courts.length))
1889             return false;
1890 
1891         // Delayed action logic.
1892         if (phase != Phase.staking) {
1893             delayedSetStakes[++lastDelayedSetStake] = DelayedSetStake({ account: _account, subcourtID: _subcourtID, stake: _stake });
1894             return true;
1895         }
1896 
1897         if (!(_stake == 0 || courts[_subcourtID].minStake <= _stake))
1898             return false; // The juror's stake cannot be lower than the minimum stake for the subcourt.
1899         Juror storage juror = jurors[_account];
1900         bytes32 stakePathID = accountAndSubcourtIDToStakePathID(_account, _subcourtID);
1901         uint currentStake = sortitionSumTrees.stakeOf(bytes32(_subcourtID), stakePathID);
1902         if (!(_stake == 0 || currentStake > 0 || juror.subcourtIDs.length < MAX_STAKE_PATHS))
1903             return false; // Maximum stake paths reached.
1904         uint newTotalStake = juror.stakedTokens - currentStake + _stake; // Can't overflow because _stake is a uint128.
1905         if (!(_stake == 0 || pinakion.balanceOf(_account) >= newTotalStake))
1906             return false; // The juror's total amount of staked tokens cannot be higher than the juror's balance.
1907 
1908         // Update juror's records.
1909         juror.stakedTokens = newTotalStake;
1910         if (_stake == 0) {
1911             for (uint i = 0; i < juror.subcourtIDs.length; i++)
1912                 if (juror.subcourtIDs[i] == _subcourtID) {
1913                     juror.subcourtIDs[i] = juror.subcourtIDs[juror.subcourtIDs.length - 1];
1914                     juror.subcourtIDs.length--;
1915                     break;
1916                 }
1917         } else if (currentStake == 0) juror.subcourtIDs.push(_subcourtID);
1918 
1919         // Update subcourt parents.
1920         bool finished = false;
1921         uint currentSubcourtID = _subcourtID;
1922         while (!finished) {
1923             sortitionSumTrees.set(bytes32(currentSubcourtID), _stake, stakePathID);
1924             if (currentSubcourtID == 0) finished = true;
1925             else currentSubcourtID = courts[currentSubcourtID].parent;
1926         }
1927         emit StakeSet(_account, _subcourtID, _stake, newTotalStake);
1928         return true;
1929     }
1930 
1931     /** @dev Gets a subcourt ID and the minimum number of jurors required from a specified extra data bytes array.
1932      *  @param _extraData The extra data bytes array. The first 32 bytes are the subcourt ID and the next 32 bytes are the minimum number of jurors.
1933      *  @return The subcourt ID and the minimum number of jurors required.
1934      */
1935     function extraDataToSubcourtIDAndMinJurors(bytes _extraData) internal view returns (uint96 subcourtID, uint minJurors) {
1936         if (_extraData.length >= 64) {
1937             assembly { // solium-disable-line security/no-inline-assembly
1938                 subcourtID := mload(add(_extraData, 0x20))
1939                 minJurors := mload(add(_extraData, 0x40))
1940             }
1941             if (subcourtID >= courts.length) subcourtID = 0;
1942             if (minJurors == 0) minJurors = MIN_JURORS;
1943         } else {
1944             subcourtID = 0;
1945             minJurors = MIN_JURORS;
1946         }
1947     }
1948 
1949     /** @dev Packs an account and a subcourt ID into a stake path ID.
1950      *  @param _account The account to pack.
1951      *  @param _subcourtID The subcourt ID to pack.
1952      *  @return The stake path ID.
1953      */
1954     function accountAndSubcourtIDToStakePathID(address _account, uint96 _subcourtID) internal pure returns (bytes32 stakePathID) {
1955         assembly { // solium-disable-line security/no-inline-assembly
1956             let ptr := mload(0x40)
1957             for { let i := 0x00 } lt(i, 0x14) { i := add(i, 0x01) } {
1958                 mstore8(add(ptr, i), byte(add(0x0c, i), _account))
1959             }
1960             for { let i := 0x14 } lt(i, 0x20) { i := add(i, 0x01) } {
1961                 mstore8(add(ptr, i), byte(i, _subcourtID))
1962             }
1963             stakePathID := mload(ptr)
1964         }
1965     }
1966 
1967     /** @dev Unpacks a stake path ID into an account and a subcourt ID.
1968      *  @param _stakePathID The stake path ID to unpack.
1969      *  @return The account and subcourt ID.
1970      */
1971     function stakePathIDToAccountAndSubcourtID(bytes32 _stakePathID) internal pure returns (address account, uint96 subcourtID) {
1972         assembly { // solium-disable-line security/no-inline-assembly
1973             let ptr := mload(0x40)
1974             for { let i := 0x00 } lt(i, 0x14) { i := add(i, 0x01) } {
1975                 mstore8(add(add(ptr, 0x0c), i), byte(i, _stakePathID))
1976             }
1977             account := mload(ptr)
1978             subcourtID := _stakePathID
1979         }
1980     }
1981     
1982     /* Interface Views */
1983 
1984     /** @dev Gets a specified subcourt's non primitive properties.
1985      *  @param _subcourtID The ID of the subcourt.
1986      *  @return The subcourt's non primitive properties.
1987      */
1988     function getSubcourt(uint96 _subcourtID) external view returns(
1989         uint[] children,
1990         uint[4] timesPerPeriod
1991     ) {
1992         Court storage subcourt = courts[_subcourtID];
1993         children = subcourt.children;
1994         timesPerPeriod = subcourt.timesPerPeriod;
1995     }
1996 
1997     /** @dev Gets a specified vote for a specified appeal in a specified dispute.
1998      *  @param _disputeID The ID of the dispute.
1999      *  @param _appeal The appeal.
2000      *  @param _voteID The ID of the vote.
2001      *  @return The vote.
2002      */
2003     function getVote(uint _disputeID, uint _appeal, uint _voteID) external view returns(
2004         address account,
2005         bytes32 commit,
2006         uint choice,
2007         bool voted
2008     ) {
2009         Vote storage vote = disputes[_disputeID].votes[_appeal][_voteID];
2010         account = vote.account;
2011         commit = vote.commit;
2012         choice = vote.choice;
2013         voted = vote.voted;
2014     }
2015 
2016     /** @dev Gets the vote counter for a specified appeal in a specified dispute.
2017      *  Note: This function is only to be used by the interface and it won't work if the number of choices is too high.
2018      *  @param _disputeID The ID of the dispute.
2019      *  @param _appeal The appeal.
2020      *  @return The vote counter.
2021      *  `O(n)` where
2022      *  `n` is the number of choices of the dispute.
2023      */
2024     function getVoteCounter(uint _disputeID, uint _appeal) external view returns(
2025         uint winningChoice,
2026         uint[] counts,
2027         bool tied
2028     ) {
2029         Dispute storage dispute = disputes[_disputeID];
2030         VoteCounter storage voteCounter = dispute.voteCounters[_appeal];
2031         winningChoice = voteCounter.winningChoice;
2032         counts = new uint[](dispute.numberOfChoices + 1);
2033         for (uint i = 0; i <= dispute.numberOfChoices; i++) counts[i] = voteCounter.counts[i];
2034         tied = voteCounter.tied;
2035     }
2036 
2037     /** @dev Gets a specified dispute's non primitive properties.
2038      *  @param _disputeID The ID of the dispute.
2039      *  @return The dispute's non primitive properties.
2040      *  `O(a)` where
2041      *  `a` is the number of appeals of the dispute.
2042      */
2043     function getDispute(uint _disputeID) external view returns(
2044         uint[] votesLengths,
2045         uint[] tokensAtStakePerJuror,
2046         uint[] totalFeesForJurors,
2047         uint[] votesInEachRound,
2048         uint[] repartitionsInEachRound,
2049         uint[] penaltiesInEachRound
2050     ) {
2051         Dispute storage dispute = disputes[_disputeID];
2052         votesLengths = new uint[](dispute.votes.length);
2053         for (uint i = 0; i < dispute.votes.length; i++) votesLengths[i] = dispute.votes[i].length;
2054         tokensAtStakePerJuror = dispute.tokensAtStakePerJuror;
2055         totalFeesForJurors = dispute.totalFeesForJurors;
2056         votesInEachRound = dispute.votesInEachRound;
2057         repartitionsInEachRound = dispute.repartitionsInEachRound;
2058         penaltiesInEachRound = dispute.penaltiesInEachRound;
2059     }
2060 
2061     /** @dev Gets a specified juror's non primitive properties.
2062      *  @param _account The address of the juror.
2063      *  @return The juror's non primitive properties.
2064      */
2065     function getJuror(address _account) external view returns(
2066         uint96[] subcourtIDs
2067     ) {
2068         Juror storage juror = jurors[_account];
2069         subcourtIDs = juror.subcourtIDs;
2070     }
2071 
2072     /** @dev Gets the stake of a specified juror in a specified subcourt.
2073      *  @param _account The address of the juror.
2074      *  @param _subcourtID The ID of the subcourt.
2075      *  @return The stake.
2076      */
2077     function stakeOf(address _account, uint96 _subcourtID) external view returns(uint stake) {
2078         return sortitionSumTrees.stakeOf(bytes32(_subcourtID), accountAndSubcourtIDToStakePathID(_account, _subcourtID));
2079     }
2080 }