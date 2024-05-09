1 /**
2 *  @title Random Number Generator Standard
3 *  @author Clément Lesaege - <clement@lesaege.com>
4 *
5 */
6 
7 pragma solidity ^0.4.15;
8 
9 contract RNG{
10 
11     /** @dev Contribute to the reward of a random number.
12     *  @param _block Block the random number is linked to.
13     */
14     function contribute(uint _block) public payable;
15 
16     /** @dev Request a random number.
17     *  @param _block Block linked to the request.
18     */
19     function requestRN(uint _block) public payable {
20         contribute(_block);
21     }
22 
23     /** @dev Get the random number.
24     *  @param _block Block the random number is linked to.
25     *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
26     */
27     function getRN(uint _block) public returns (uint RN);
28 
29     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
30     *  This is to prevent users from getting correlated numbers.
31     *  @param _block Block the random number is linked to.
32     *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
33     */
34     function getUncorrelatedRN(uint _block) public returns (uint RN) {
35         uint baseRN = getRN(_block);
36         if (baseRN == 0)
37         return 0;
38         else
39         return uint(keccak256(msg.sender,baseRN));
40     }
41 
42 }
43 
44 /**
45  *  @title Arbitrator
46  *  @author Clément Lesaege - <clement@lesaege.com>
47  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
48  */
49 
50 pragma solidity ^0.4.15;
51 
52 /** @title Arbitrator
53  *  Arbitrator abstract contract.
54  *  When developing arbitrator contracts we need to:
55  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
56  *  -Define the functions for cost display (arbitrationCost and appealCost).
57  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
58  */
59 contract Arbitrator{
60 
61     enum DisputeStatus {Waiting, Appealable, Solved}
62 
63     modifier requireArbitrationFee(bytes _extraData) {
64         require(msg.value >= arbitrationCost(_extraData), "Not enough ETH to cover arbitration costs.");
65         _;
66     }
67     modifier requireAppealFee(uint _disputeID, bytes _extraData) {
68         require(msg.value >= appealCost(_disputeID, _extraData), "Not enough ETH to cover appeal costs.");
69         _;
70     }
71 
72     /** @dev To be raised when a dispute is created.
73      *  @param _disputeID ID of the dispute.
74      *  @param _arbitrable The contract which created the dispute.
75      */
76     event DisputeCreation(uint indexed _disputeID, Arbitrable indexed _arbitrable);
77 
78     /** @dev To be raised when a dispute can be appealed.
79      *  @param _disputeID ID of the dispute.
80      */
81     event AppealPossible(uint indexed _disputeID, Arbitrable indexed _arbitrable);
82 
83     /** @dev To be raised when the current ruling is appealed.
84      *  @param _disputeID ID of the dispute.
85      *  @param _arbitrable The contract which created the dispute.
86      */
87     event AppealDecision(uint indexed _disputeID, Arbitrable indexed _arbitrable);
88 
89     /** @dev Create a dispute. Must be called by the arbitrable contract.
90      *  Must be paid at least arbitrationCost(_extraData).
91      *  @param _choices Amount of choices the arbitrator can make in this dispute.
92      *  @param _extraData Can be used to give additional info on the dispute to be created.
93      *  @return disputeID ID of the dispute created.
94      */
95     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID) {}
96 
97     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
98      *  @param _extraData Can be used to give additional info on the dispute to be created.
99      *  @return fee Amount to be paid.
100      */
101     function arbitrationCost(bytes _extraData) public view returns(uint fee);
102 
103     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
104      *  @param _disputeID ID of the dispute to be appealed.
105      *  @param _extraData Can be used to give extra info on the appeal.
106      */
107     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
108         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
109     }
110 
111     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
112      *  @param _disputeID ID of the dispute to be appealed.
113      *  @param _extraData Can be used to give additional info on the dispute to be created.
114      *  @return fee Amount to be paid.
115      */
116     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint fee);
117 
118     /** @dev Compute the start and end of the dispute's current or next appeal period, if possible.
119      *  @param _disputeID ID of the dispute.
120      *  @return The start and end of the period.
121      */
122     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {}
123 
124     /** @dev Return the status of a dispute.
125      *  @param _disputeID ID of the dispute to rule.
126      *  @return status The status of the dispute.
127      */
128     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status);
129 
130     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
131      *  @param _disputeID ID of the dispute.
132      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
133      */
134     function currentRuling(uint _disputeID) public view returns(uint ruling);
135 }
136 
137 /**
138  *  @title IArbitrable
139  *  @author Enrique Piqueras - <enrique@kleros.io>
140  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
141  */
142 
143 pragma solidity ^0.4.15;
144 
145 /** @title IArbitrable
146  *  Arbitrable interface.
147  *  When developing arbitrable contracts, we need to:
148  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
149  *  -Allow dispute creation. For this a function must:
150  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
151  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
152  */
153 interface IArbitrable {
154     /** @dev To be emmited when meta-evidence is submitted.
155      *  @param _metaEvidenceID Unique identifier of meta-evidence.
156      *  @param _evidence A link to the meta-evidence JSON.
157      */
158     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
159 
160     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
161      *  @param _arbitrator The arbitrator of the contract.
162      *  @param _disputeID ID of the dispute in the Arbitrator contract.
163      *  @param _metaEvidenceID Unique identifier of meta-evidence.
164      *  @param _evidenceGroupID Unique identifier of the evidence group that is linked to this dispute.
165      */
166     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID, uint _evidenceGroupID);
167 
168     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
169      *  @param _arbitrator The arbitrator of the contract.
170      *  @param _evidenceGroupID Unique identifier of the evidence group the evidence belongs to.
171      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
172      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
173      */
174     event Evidence(Arbitrator indexed _arbitrator, uint indexed _evidenceGroupID, address indexed _party, string _evidence);
175 
176     /** @dev To be raised when a ruling is given.
177      *  @param _arbitrator The arbitrator giving the ruling.
178      *  @param _disputeID ID of the dispute in the Arbitrator contract.
179      *  @param _ruling The ruling which was given.
180      */
181     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
182 
183     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
184      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
185      *  @param _disputeID ID of the dispute in the Arbitrator contract.
186      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
187      */
188     function rule(uint _disputeID, uint _ruling) public;
189 }
190 
191 /**
192  *  @title Arbitrable
193  *  @author Clément Lesaege - <clement@lesaege.com>
194  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
195  */
196 
197 pragma solidity ^0.4.15;
198 
199 /** @title Arbitrable
200  *  Arbitrable abstract contract.
201  *  When developing arbitrable contracts, we need to:
202  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
203  *  -Allow dispute creation. For this a function must:
204  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
205  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
206  */
207 contract Arbitrable is IArbitrable {
208     Arbitrator public arbitrator;
209     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
210 
211     modifier onlyArbitrator {require(msg.sender == address(arbitrator), "Can only be called by the arbitrator."); _;}
212 
213     /** @dev Constructor. Choose the arbitrator.
214      *  @param _arbitrator The arbitrator of the contract.
215      *  @param _arbitratorExtraData Extra data for the arbitrator.
216      */
217     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
218         arbitrator = _arbitrator;
219         arbitratorExtraData = _arbitratorExtraData;
220     }
221 
222     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
223      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
224      *  @param _disputeID ID of the dispute in the Arbitrator contract.
225      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
226      */
227     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
228         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
229 
230         executeRuling(_disputeID,_ruling);
231     }
232 
233 
234     /** @dev Execute a ruling of a dispute.
235      *  @param _disputeID ID of the dispute in the Arbitrator contract.
236      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
237      */
238     function executeRuling(uint _disputeID, uint _ruling) internal;
239 }
240 
241 pragma solidity ^0.4.18;
242 
243 contract Controlled {
244     /// @notice The address of the controller is the only address that can call
245     ///  a function with this modifier
246     modifier onlyController { require(msg.sender == controller); _; }
247 
248     address public controller;
249 
250     function Controlled() public { controller = msg.sender;}
251 
252     /// @notice Changes the controller of the contract
253     /// @param _newController The new controller of the contract
254     function changeController(address _newController) public onlyController {
255         controller = _newController;
256     }
257 }
258  
259  pragma solidity ^0.4.18;
260 
261 /*
262     Copyright 2016, Jordi Baylina
263 
264     This program is free software: you can redistribute it and/or modify
265     it under the terms of the GNU General Public License as published by
266     the Free Software Foundation, either version 3 of the License, or
267     (at your option) any later version.
268 
269     This program is distributed in the hope that it will be useful,
270     but WITHOUT ANY WARRANTY; without even the implied warranty of
271     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
272     GNU General Public License for more details.
273 
274     You should have received a copy of the GNU General Public License
275     along with this program.  If not, see <http://www.gnu.org/licenses/>.
276  */
277 
278 /// @title MiniMeToken Contract
279 /// @author Jordi Baylina
280 /// @dev This token contract's goal is to make it easy for anyone to clone this
281 ///  token using the token distribution at a given block, this will allow DAO's
282 ///  and DApps to upgrade their features in a decentralized manner without
283 ///  affecting the original token
284 /// @dev It is ERC20 compliant, but still needs to under go further testing.
285 
286 contract ApproveAndCallFallBack {
287     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
288 }
289 
290 /// @dev The actual token contract, the default controller is the msg.sender
291 ///  that deploys the contract, so usually this token will be deployed by a
292 ///  token controller contract, which Giveth will call a "Campaign"
293 contract MiniMeToken is Controlled {
294 
295     string public name;                //The Token's name: e.g. DigixDAO Tokens
296     uint8 public decimals;             //Number of decimals of the smallest unit
297     string public symbol;              //An identifier: e.g. REP
298     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
299 
300 
301     /// @dev `Checkpoint` is the structure that attaches a block number to a
302     ///  given value, the block number attached is the one that last changed the
303     ///  value
304     struct  Checkpoint {
305 
306         // `fromBlock` is the block number that the value was generated from
307         uint128 fromBlock;
308 
309         // `value` is the amount of tokens at a specific block number
310         uint128 value;
311     }
312 
313     // `parentToken` is the Token address that was cloned to produce this token;
314     //  it will be 0x0 for a token that was not cloned
315     MiniMeToken public parentToken;
316 
317     // `parentSnapShotBlock` is the block number from the Parent Token that was
318     //  used to determine the initial distribution of the Clone Token
319     uint public parentSnapShotBlock;
320 
321     // `creationBlock` is the block number that the Clone Token was created
322     uint public creationBlock;
323 
324     // `balances` is the map that tracks the balance of each address, in this
325     //  contract when the balance changes the block number that the change
326     //  occurred is also included in the map
327     mapping (address => Checkpoint[]) balances;
328 
329     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
330     mapping (address => mapping (address => uint256)) allowed;
331 
332     // Tracks the history of the `totalSupply` of the token
333     Checkpoint[] totalSupplyHistory;
334 
335     // Flag that determines if the token is transferable or not.
336     bool public transfersEnabled;
337 
338     // The factory used to create new clone tokens
339     MiniMeTokenFactory public tokenFactory;
340 
341 ////////////////
342 // Constructor
343 ////////////////
344 
345     /// @notice Constructor to create a MiniMeToken
346     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
347     ///  will create the Clone token contracts, the token factory needs to be
348     ///  deployed first
349     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
350     ///  new token
351     /// @param _parentSnapShotBlock Block of the parent token that will
352     ///  determine the initial distribution of the clone token, set to 0 if it
353     ///  is a new token
354     /// @param _tokenName Name of the new token
355     /// @param _decimalUnits Number of decimals of the new token
356     /// @param _tokenSymbol Token Symbol for the new token
357     /// @param _transfersEnabled If true, tokens will be able to be transferred
358     function MiniMeToken(
359         address _tokenFactory,
360         address _parentToken,
361         uint _parentSnapShotBlock,
362         string _tokenName,
363         uint8 _decimalUnits,
364         string _tokenSymbol,
365         bool _transfersEnabled
366     ) public {
367         tokenFactory = MiniMeTokenFactory(_tokenFactory);
368         name = _tokenName;                                 // Set the name
369         decimals = _decimalUnits;                          // Set the decimals
370         symbol = _tokenSymbol;                             // Set the symbol
371         parentToken = MiniMeToken(_parentToken);
372         parentSnapShotBlock = _parentSnapShotBlock;
373         transfersEnabled = _transfersEnabled;
374         creationBlock = block.number;
375     }
376 
377 
378 ///////////////////
379 // ERC20 Methods
380 ///////////////////
381 
382     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
383     /// @param _to The address of the recipient
384     /// @param _amount The amount of tokens to be transferred
385     /// @return Whether the transfer was successful or not
386     function transfer(address _to, uint256 _amount) public returns (bool success) {
387         require(transfersEnabled);
388         doTransfer(msg.sender, _to, _amount);
389         return true;
390     }
391 
392     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
393     ///  is approved by `_from`
394     /// @param _from The address holding the tokens being transferred
395     /// @param _to The address of the recipient
396     /// @param _amount The amount of tokens to be transferred
397     /// @return True if the transfer was successful
398     function transferFrom(address _from, address _to, uint256 _amount
399     ) public returns (bool success) {
400 
401         // The controller of this contract can move tokens around at will,
402         //  this is important to recognize! Confirm that you trust the
403         //  controller of this contract, which in most situations should be
404         //  another open source smart contract or 0x0
405         if (msg.sender != controller) {
406             require(transfersEnabled);
407 
408             // The standard ERC 20 transferFrom functionality
409             require(allowed[_from][msg.sender] >= _amount);
410             allowed[_from][msg.sender] -= _amount;
411         }
412         doTransfer(_from, _to, _amount);
413         return true;
414     }
415 
416     /// @dev This is the actual transfer function in the token contract, it can
417     ///  only be called by other functions in this contract.
418     /// @param _from The address holding the tokens being transferred
419     /// @param _to The address of the recipient
420     /// @param _amount The amount of tokens to be transferred
421     /// @return True if the transfer was successful
422     function doTransfer(address _from, address _to, uint _amount
423     ) internal {
424 
425            if (_amount == 0) {
426                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
427                return;
428            }
429 
430            require(parentSnapShotBlock < block.number);
431 
432            // Do not allow transfer to 0x0 or the token contract itself
433            require((_to != 0) && (_to != address(this)));
434 
435            // If the amount being transfered is more than the balance of the
436            //  account the transfer throws
437            var previousBalanceFrom = balanceOfAt(_from, block.number);
438 
439            require(previousBalanceFrom >= _amount);
440 
441            // Alerts the token controller of the transfer
442            if (isContract(controller)) {
443                require(TokenController(controller).onTransfer(_from, _to, _amount));
444            }
445 
446            // First update the balance array with the new value for the address
447            //  sending the tokens
448            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
449 
450            // Then update the balance array with the new value for the address
451            //  receiving the tokens
452            var previousBalanceTo = balanceOfAt(_to, block.number);
453            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
454            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
455 
456            // An event to make the transfer easy to find on the blockchain
457            Transfer(_from, _to, _amount);
458 
459     }
460 
461     /// @param _owner The address that's balance is being requested
462     /// @return The balance of `_owner` at the current block
463     function balanceOf(address _owner) public constant returns (uint256 balance) {
464         return balanceOfAt(_owner, block.number);
465     }
466 
467     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
468     ///  its behalf. This is a modified version of the ERC20 approve function
469     ///  to be a little bit safer
470     /// @param _spender The address of the account able to transfer the tokens
471     /// @param _amount The amount of tokens to be approved for transfer
472     /// @return True if the approval was successful
473     function approve(address _spender, uint256 _amount) public returns (bool success) {
474         require(transfersEnabled);
475 
476         // To change the approve amount you first have to reduce the addresses`
477         //  allowance to zero by calling `approve(_spender,0)` if it is not
478         //  already 0 to mitigate the race condition described here:
479         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
480         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
481 
482         // Alerts the token controller of the approve function call
483         if (isContract(controller)) {
484             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
485         }
486 
487         allowed[msg.sender][_spender] = _amount;
488         Approval(msg.sender, _spender, _amount);
489         return true;
490     }
491 
492     /// @dev This function makes it easy to read the `allowed[]` map
493     /// @param _owner The address of the account that owns the token
494     /// @param _spender The address of the account able to transfer the tokens
495     /// @return Amount of remaining tokens of _owner that _spender is allowed
496     ///  to spend
497     function allowance(address _owner, address _spender
498     ) public constant returns (uint256 remaining) {
499         return allowed[_owner][_spender];
500     }
501 
502     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
503     ///  its behalf, and then a function is triggered in the contract that is
504     ///  being approved, `_spender`. This allows users to use their tokens to
505     ///  interact with contracts in one function call instead of two
506     /// @param _spender The address of the contract able to transfer the tokens
507     /// @param _amount The amount of tokens to be approved for transfer
508     /// @return True if the function call was successful
509     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
510     ) public returns (bool success) {
511         require(approve(_spender, _amount));
512 
513         ApproveAndCallFallBack(_spender).receiveApproval(
514             msg.sender,
515             _amount,
516             this,
517             _extraData
518         );
519 
520         return true;
521     }
522 
523     /// @dev This function makes it easy to get the total number of tokens
524     /// @return The total number of tokens
525     function totalSupply() public constant returns (uint) {
526         return totalSupplyAt(block.number);
527     }
528 
529 
530 ////////////////
531 // Query balance and totalSupply in History
532 ////////////////
533 
534     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
535     /// @param _owner The address from which the balance will be retrieved
536     /// @param _blockNumber The block number when the balance is queried
537     /// @return The balance at `_blockNumber`
538     function balanceOfAt(address _owner, uint _blockNumber) public constant
539         returns (uint) {
540 
541         // These next few lines are used when the balance of the token is
542         //  requested before a check point was ever created for this token, it
543         //  requires that the `parentToken.balanceOfAt` be queried at the
544         //  genesis block for that token as this contains initial balance of
545         //  this token
546         if ((balances[_owner].length == 0)
547             || (balances[_owner][0].fromBlock > _blockNumber)) {
548             if (address(parentToken) != 0) {
549                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
550             } else {
551                 // Has no parent
552                 return 0;
553             }
554 
555         // This will return the expected balance during normal situations
556         } else {
557             return getValueAt(balances[_owner], _blockNumber);
558         }
559     }
560 
561     /// @notice Total amount of tokens at a specific `_blockNumber`.
562     /// @param _blockNumber The block number when the totalSupply is queried
563     /// @return The total amount of tokens at `_blockNumber`
564     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
565 
566         // These next few lines are used when the totalSupply of the token is
567         //  requested before a check point was ever created for this token, it
568         //  requires that the `parentToken.totalSupplyAt` be queried at the
569         //  genesis block for this token as that contains totalSupply of this
570         //  token at this block number.
571         if ((totalSupplyHistory.length == 0)
572             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
573             if (address(parentToken) != 0) {
574                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
575             } else {
576                 return 0;
577             }
578 
579         // This will return the expected totalSupply during normal situations
580         } else {
581             return getValueAt(totalSupplyHistory, _blockNumber);
582         }
583     }
584 
585 ////////////////
586 // Clone Token Method
587 ////////////////
588 
589     /// @notice Creates a new clone token with the initial distribution being
590     ///  this token at `_snapshotBlock`
591     /// @param _cloneTokenName Name of the clone token
592     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
593     /// @param _cloneTokenSymbol Symbol of the clone token
594     /// @param _snapshotBlock Block when the distribution of the parent token is
595     ///  copied to set the initial distribution of the new clone token;
596     ///  if the block is zero than the actual block, the current block is used
597     /// @param _transfersEnabled True if transfers are allowed in the clone
598     /// @return The address of the new MiniMeToken Contract
599     function createCloneToken(
600         string _cloneTokenName,
601         uint8 _cloneDecimalUnits,
602         string _cloneTokenSymbol,
603         uint _snapshotBlock,
604         bool _transfersEnabled
605         ) public returns(address) {
606         if (_snapshotBlock == 0) _snapshotBlock = block.number;
607         MiniMeToken cloneToken = tokenFactory.createCloneToken(
608             this,
609             _snapshotBlock,
610             _cloneTokenName,
611             _cloneDecimalUnits,
612             _cloneTokenSymbol,
613             _transfersEnabled
614             );
615 
616         cloneToken.changeController(msg.sender);
617 
618         // An event to make the token easy to find on the blockchain
619         NewCloneToken(address(cloneToken), _snapshotBlock);
620         return address(cloneToken);
621     }
622 
623 ////////////////
624 // Generate and destroy tokens
625 ////////////////
626 
627     /// @notice Generates `_amount` tokens that are assigned to `_owner`
628     /// @param _owner The address that will be assigned the new tokens
629     /// @param _amount The quantity of tokens generated
630     /// @return True if the tokens are generated correctly
631     function generateTokens(address _owner, uint _amount
632     ) public onlyController returns (bool) {
633         uint curTotalSupply = totalSupply();
634         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
635         uint previousBalanceTo = balanceOf(_owner);
636         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
637         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
638         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
639         Transfer(0, _owner, _amount);
640         return true;
641     }
642 
643 
644     /// @notice Burns `_amount` tokens from `_owner`
645     /// @param _owner The address that will lose the tokens
646     /// @param _amount The quantity of tokens to burn
647     /// @return True if the tokens are burned correctly
648     function destroyTokens(address _owner, uint _amount
649     ) onlyController public returns (bool) {
650         uint curTotalSupply = totalSupply();
651         require(curTotalSupply >= _amount);
652         uint previousBalanceFrom = balanceOf(_owner);
653         require(previousBalanceFrom >= _amount);
654         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
655         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
656         Transfer(_owner, 0, _amount);
657         return true;
658     }
659 
660 ////////////////
661 // Enable tokens transfers
662 ////////////////
663 
664 
665     /// @notice Enables token holders to transfer their tokens freely if true
666     /// @param _transfersEnabled True if transfers are allowed in the clone
667     function enableTransfers(bool _transfersEnabled) public onlyController {
668         transfersEnabled = _transfersEnabled;
669     }
670 
671 ////////////////
672 // Internal helper functions to query and set a value in a snapshot array
673 ////////////////
674 
675     /// @dev `getValueAt` retrieves the number of tokens at a given block number
676     /// @param checkpoints The history of values being queried
677     /// @param _block The block number to retrieve the value at
678     /// @return The number of tokens being queried
679     function getValueAt(Checkpoint[] storage checkpoints, uint _block
680     ) constant internal returns (uint) {
681         if (checkpoints.length == 0) return 0;
682 
683         // Shortcut for the actual value
684         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
685             return checkpoints[checkpoints.length-1].value;
686         if (_block < checkpoints[0].fromBlock) return 0;
687 
688         // Binary search of the value in the array
689         uint min = 0;
690         uint max = checkpoints.length-1;
691         while (max > min) {
692             uint mid = (max + min + 1)/ 2;
693             if (checkpoints[mid].fromBlock<=_block) {
694                 min = mid;
695             } else {
696                 max = mid-1;
697             }
698         }
699         return checkpoints[min].value;
700     }
701 
702     /// @dev `updateValueAtNow` used to update the `balances` map and the
703     ///  `totalSupplyHistory`
704     /// @param checkpoints The history of data being updated
705     /// @param _value The new number of tokens
706     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
707     ) internal  {
708         if ((checkpoints.length == 0)
709         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
710                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
711                newCheckPoint.fromBlock =  uint128(block.number);
712                newCheckPoint.value = uint128(_value);
713            } else {
714                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
715                oldCheckPoint.value = uint128(_value);
716            }
717     }
718 
719     /// @dev Internal function to determine if an address is a contract
720     /// @param _addr The address being queried
721     /// @return True if `_addr` is a contract
722     function isContract(address _addr) constant internal returns(bool) {
723         uint size;
724         if (_addr == 0) return false;
725         assembly {
726             size := extcodesize(_addr)
727         }
728         return size>0;
729     }
730 
731     /// @dev Helper function to return a min betwen the two uints
732     function min(uint a, uint b) pure internal returns (uint) {
733         return a < b ? a : b;
734     }
735 
736     /// @notice The fallback function: If the contract's controller has not been
737     ///  set to 0, then the `proxyPayment` method is called which relays the
738     ///  ether and creates tokens as described in the token controller contract
739     function () public payable {
740         require(isContract(controller));
741         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
742     }
743 
744 //////////
745 // Safety Methods
746 //////////
747 
748     /// @notice This method can be used by the controller to extract mistakenly
749     ///  sent tokens to this contract.
750     /// @param _token The address of the token contract that you want to recover
751     ///  set to 0 in case you want to extract ether.
752     function claimTokens(address _token) public onlyController {
753         if (_token == 0x0) {
754             controller.transfer(this.balance);
755             return;
756         }
757 
758         MiniMeToken token = MiniMeToken(_token);
759         uint balance = token.balanceOf(this);
760         token.transfer(controller, balance);
761         ClaimedTokens(_token, controller, balance);
762     }
763 
764 ////////////////
765 // Events
766 ////////////////
767     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
768     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
769     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
770     event Approval(
771         address indexed _owner,
772         address indexed _spender,
773         uint256 _amount
774         );
775 
776 }
777 
778 
779 ////////////////
780 // MiniMeTokenFactory
781 ////////////////
782 
783 /// @dev This contract is used to generate clone contracts from a contract.
784 ///  In solidity this is the way to create a contract from a contract of the
785 ///  same class
786 contract MiniMeTokenFactory {
787 
788     /// @notice Update the DApp by creating a new token with new functionalities
789     ///  the msg.sender becomes the controller of this clone token
790     /// @param _parentToken Address of the token being cloned
791     /// @param _snapshotBlock Block of the parent token that will
792     ///  determine the initial distribution of the clone token
793     /// @param _tokenName Name of the new token
794     /// @param _decimalUnits Number of decimals of the new token
795     /// @param _tokenSymbol Token Symbol for the new token
796     /// @param _transfersEnabled If true, tokens will be able to be transferred
797     /// @return The address of the new token contract
798     function createCloneToken(
799         address _parentToken,
800         uint _snapshotBlock,
801         string _tokenName,
802         uint8 _decimalUnits,
803         string _tokenSymbol,
804         bool _transfersEnabled
805     ) public returns (MiniMeToken) {
806         MiniMeToken newToken = new MiniMeToken(
807             this,
808             _parentToken,
809             _snapshotBlock,
810             _tokenName,
811             _decimalUnits,
812             _tokenSymbol,
813             _transfersEnabled
814             );
815 
816         newToken.changeController(msg.sender);
817         return newToken;
818     }
819 }
820  
821  /**
822  *  @title Mini Me Token ERC20
823  *  Overwrite the MiniMeToken to make it follow ERC20 recommendation.
824  *  This is required because the base token reverts when approve is used with the non zero value while allowed is non zero (which not recommended by the standard, see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md).
825  *  @author Clément Lesaege - <clement@lesaege.com>
826  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
827  */
828 
829 pragma solidity ^0.4.18;
830 
831 contract Pinakion is MiniMeToken {
832 
833     /** @notice Constructor to create a MiniMeTokenERC20
834      *  @param _tokenFactory The address of the MiniMeTokenFactory contract that will
835      *   create the Clone token contracts, the token factory needs to be deployed first
836      *  @param _parentToken Address of the parent token, set to 0x0 if it is a new token
837      *  @param _parentSnapShotBlock Block of the parent token that will determine the
838      *   initial distribution of the clone token, set to 0 if it is a new token
839      *  @param _tokenName Name of the new token
840      *  @param _decimalUnits Number of decimals of the new token
841      *  @param _tokenSymbol Token Symbol for the new token
842      *  @param _transfersEnabled If true, tokens will be able to be transferred
843      */
844     constructor(
845         address _tokenFactory,
846         address _parentToken,
847         uint _parentSnapShotBlock,
848         string _tokenName,
849         uint8 _decimalUnits,
850         string _tokenSymbol,
851         bool _transfersEnabled
852     )  MiniMeToken(
853         _tokenFactory,
854         _parentToken,
855         _parentSnapShotBlock,
856         _tokenName,
857         _decimalUnits,
858         _tokenSymbol,
859         _transfersEnabled
860     ) public {}
861 
862     /** @notice `msg.sender` approves `_spender` to spend `_amount` tokens on its behalf.
863       * This is a ERC20 compliant version.
864       * @param _spender The address of the account able to transfer the tokens
865       * @param _amount The amount of tokens to be approved for transfer
866       * @return True if the approval was successful
867       */
868     function approve(address _spender, uint256 _amount) public returns (bool success) {
869         require(transfersEnabled, "Transfers are not enabled.");
870         // Alerts the token controller of the approve function call
871         if (isContract(controller)) {
872             require(TokenController(controller).onApprove(msg.sender, _spender, _amount), "Token controller does not approve.");
873         }
874 
875         allowed[msg.sender][_spender] = _amount;
876         Approval(msg.sender, _spender, _amount);
877         return true;
878     }
879 }
880 
881 pragma solidity ^0.4.18;
882 
883 /// @dev The token controller contract must implement these functions
884 contract TokenController {
885     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
886     /// @param _owner The address that sent the ether to create tokens
887     /// @return True if the ether is accepted, false if it throws
888     function proxyPayment(address _owner) public payable returns(bool);
889 
890     /// @notice Notifies the controller about a token transfer allowing the
891     ///  controller to react if desired
892     /// @param _from The origin of the transfer
893     /// @param _to The destination of the transfer
894     /// @param _amount The amount of the transfer
895     /// @return False if the controller does not authorize the transfer
896     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
897 
898     /// @notice Notifies the controller about an approval allowing the
899     ///  controller to react if desired
900     /// @param _owner The address that calls `approve()`
901     /// @param _spender The spender in the `approve()` call
902     /// @param _amount The amount in the `approve()` call
903     /// @return False if the controller does not authorize the approval
904     function onApprove(address _owner, address _spender, uint _amount) public
905         returns(bool);
906 }
907 
908 /**
909  *  @reviewers: [@clesaege, @unknownunknown1, @ferittuncer]
910  *  @auditors: []
911  *  @bounties: [<14 days 10 ETH max payout>]
912  *  @deployments: []
913  */
914 
915 pragma solidity ^0.4.24;
916 
917 /**
918  *  @title SortitionSumTreeFactory
919  *  @author Enrique Piqueras - <epiquerass@gmail.com>
920  *  @dev A factory of trees that keep track of staked values for sortition.
921  */
922 library SortitionSumTreeFactory {
923     /* Structs */
924 
925     struct SortitionSumTree {
926         uint K; // The maximum number of childs per node.
927         // We use this to keep track of vacant positions in the tree after removing a leaf. This is for keeping the tree as balanced as possible without spending gas on moving nodes around.
928         uint[] stack;
929         uint[] nodes;
930         // Two-way mapping of IDs to node indexes. Note that node index 0 is reserved for the root node, and means the ID does not have a node.
931         mapping(bytes32 => uint) IDsToNodeIndexes;
932         mapping(uint => bytes32) nodeIndexesToIDs;
933     }
934 
935     /* Storage */
936 
937     struct SortitionSumTrees {
938         mapping(bytes32 => SortitionSumTree) sortitionSumTrees;
939     }
940 
941     /* Public */
942 
943     /**
944      *  @dev Create a sortition sum tree at the specified key.
945      *  @param _key The key of the new tree.
946      *  @param _K The number of children each node in the tree should have.
947      */
948     function createTree(SortitionSumTrees storage self, bytes32 _key, uint _K) public {
949         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
950         require(tree.K == 0, "Tree already exists.");
951         require(_K > 1, "K must be greater than one.");
952         tree.K = _K;
953         tree.stack.length = 0;
954         tree.nodes.length = 0;
955         tree.nodes.push(0);
956     }
957 
958     /**
959      *  @dev Set a value of a tree.
960      *  @param _key The key of the tree.
961      *  @param _value The new value.
962      *  @param _ID The ID of the value.
963      *  `O(log_k(n))` where
964      *  `k` is the maximum number of childs per node in the tree,
965      *   and `n` is the maximum number of nodes ever appended.
966      */
967     function set(SortitionSumTrees storage self, bytes32 _key, uint _value, bytes32 _ID) public {
968         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
969         uint treeIndex = tree.IDsToNodeIndexes[_ID];
970 
971         if (treeIndex == 0) { // No existing node.
972             if (_value != 0) { // Non zero value.
973                 // Append.
974                 // Add node.
975                 if (tree.stack.length == 0) { // No vacant spots.
976                     // Get the index and append the value.
977                     treeIndex = tree.nodes.length;
978                     tree.nodes.push(_value);
979 
980                     // Potentially append a new node and make the parent a sum node.
981                     if (treeIndex != 1 && (treeIndex - 1) % tree.K == 0) { // Is first child.
982                         uint parentIndex = treeIndex / tree.K;
983                         bytes32 parentID = tree.nodeIndexesToIDs[parentIndex];
984                         uint newIndex = treeIndex + 1;
985                         tree.nodes.push(tree.nodes[parentIndex]);
986                         delete tree.nodeIndexesToIDs[parentIndex];
987                         tree.IDsToNodeIndexes[parentID] = newIndex;
988                         tree.nodeIndexesToIDs[newIndex] = parentID;
989                     }
990                 } else { // Some vacant spot.
991                     // Pop the stack and append the value.
992                     treeIndex = tree.stack[tree.stack.length - 1];
993                     tree.stack.length--;
994                     tree.nodes[treeIndex] = _value;
995                 }
996 
997                 // Add label.
998                 tree.IDsToNodeIndexes[_ID] = treeIndex;
999                 tree.nodeIndexesToIDs[treeIndex] = _ID;
1000 
1001                 updateParents(self, _key, treeIndex, true, _value);
1002             }
1003         } else { // Existing node.
1004             if (_value == 0) { // Zero value.
1005                 // Remove.
1006                 // Remember value and set to 0.
1007                 uint value = tree.nodes[treeIndex];
1008                 tree.nodes[treeIndex] = 0;
1009 
1010                 // Push to stack.
1011                 tree.stack.push(treeIndex);
1012 
1013                 // Clear label.
1014                 delete tree.IDsToNodeIndexes[_ID];
1015                 delete tree.nodeIndexesToIDs[treeIndex];
1016 
1017                 updateParents(self, _key, treeIndex, false, value);
1018             } else if (_value != tree.nodes[treeIndex]) { // New, non zero value.
1019                 // Set.
1020                 bool plusOrMinus = tree.nodes[treeIndex] <= _value;
1021                 uint plusOrMinusValue = plusOrMinus ? _value - tree.nodes[treeIndex] : tree.nodes[treeIndex] - _value;
1022                 tree.nodes[treeIndex] = _value;
1023 
1024                 updateParents(self, _key, treeIndex, plusOrMinus, plusOrMinusValue);
1025             }
1026         }
1027     }
1028 
1029     /* Public Views */
1030 
1031     /**
1032      *  @dev Query the leaves of a tree. Note that if `startIndex == 0`, the tree is empty and the root node will be returned.
1033      *  @param _key The key of the tree to get the leaves from.
1034      *  @param _cursor The pagination cursor.
1035      *  @param _count The number of items to return.
1036      *  @return The index at which leaves start, the values of the returned leaves, and whether there are more for pagination.
1037      *  `O(n)` where
1038      *  `n` is the maximum number of nodes ever appended.
1039      */
1040     function queryLeafs(
1041         SortitionSumTrees storage self,
1042         bytes32 _key,
1043         uint _cursor,
1044         uint _count
1045     ) public view returns(uint startIndex, uint[] values, bool hasMore) {
1046         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1047 
1048         // Find the start index.
1049         for (uint i = 0; i < tree.nodes.length; i++) {
1050             if ((tree.K * i) + 1 >= tree.nodes.length) {
1051                 startIndex = i;
1052                 break;
1053             }
1054         }
1055 
1056         // Get the values.
1057         uint loopStartIndex = startIndex + _cursor;
1058         values = new uint[](loopStartIndex + _count > tree.nodes.length ? tree.nodes.length - loopStartIndex : _count);
1059         uint valuesIndex = 0;
1060         for (uint j = loopStartIndex; j < tree.nodes.length; j++) {
1061             if (valuesIndex < _count) {
1062                 values[valuesIndex] = tree.nodes[j];
1063                 valuesIndex++;
1064             } else {
1065                 hasMore = true;
1066                 break;
1067             }
1068         }
1069     }
1070 
1071     /**
1072      *  @dev Draw an ID from a tree using a number. Note that this function reverts if the sum of all values in the tree is 0.
1073      *  @param _key The key of the tree.
1074      *  @param _drawnNumber The drawn number.
1075      *  @return The drawn ID.
1076      *  `O(k * log_k(n))` where
1077      *  `k` is the maximum number of childs per node in the tree,
1078      *   and `n` is the maximum number of nodes ever appended.
1079      */
1080     function draw(SortitionSumTrees storage self, bytes32 _key, uint _drawnNumber) public view returns(bytes32 ID) {
1081         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1082         uint treeIndex = 0;
1083         uint currentDrawnNumber = _drawnNumber % tree.nodes[0];
1084 
1085         while ((tree.K * treeIndex) + 1 < tree.nodes.length)  // While it still has children.
1086             for (uint i = 1; i <= tree.K; i++) { // Loop over children.
1087                 uint nodeIndex = (tree.K * treeIndex) + i;
1088                 uint nodeValue = tree.nodes[nodeIndex];
1089 
1090                 if (currentDrawnNumber >= nodeValue) currentDrawnNumber -= nodeValue; // Go to the next child.
1091                 else { // Pick this child.
1092                     treeIndex = nodeIndex;
1093                     break;
1094                 }
1095             }
1096         
1097         ID = tree.nodeIndexesToIDs[treeIndex];
1098     }
1099 
1100     /** @dev Gets a specified ID's associated value.
1101      *  @param _key The key of the tree.
1102      *  @param _ID The ID of the value.
1103      *  @return The associated value.
1104      */
1105     function stakeOf(SortitionSumTrees storage self, bytes32 _key, bytes32 _ID) public view returns(uint value) {
1106         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1107         uint treeIndex = tree.IDsToNodeIndexes[_ID];
1108 
1109         if (treeIndex == 0) value = 0;
1110         else value = tree.nodes[treeIndex];
1111     }
1112 
1113     /* Private */
1114 
1115     /**
1116      *  @dev Update all the parents of a node.
1117      *  @param _key The key of the tree to update.
1118      *  @param _treeIndex The index of the node to start from.
1119      *  @param _plusOrMinus Wether to add (true) or substract (false).
1120      *  @param _value The value to add or substract.
1121      *  `O(log_k(n))` where
1122      *  `k` is the maximum number of childs per node in the tree,
1123      *   and `n` is the maximum number of nodes ever appended.
1124      */
1125     function updateParents(SortitionSumTrees storage self, bytes32 _key, uint _treeIndex, bool _plusOrMinus, uint _value) private {
1126         SortitionSumTree storage tree = self.sortitionSumTrees[_key];
1127 
1128         uint parentIndex = _treeIndex;
1129         while (parentIndex != 0) {
1130             parentIndex = (parentIndex - 1) / tree.K;
1131             tree.nodes[parentIndex] = _plusOrMinus ? tree.nodes[parentIndex] + _value : tree.nodes[parentIndex] - _value;
1132         }
1133     }
1134 }
1135 
1136 
1137 
1138 /**
1139  *  @title Random Number Generator usign blockhash
1140  *  @author Clément Lesaege - <clement@lesaege.com>
1141  *
1142  *  This contract implements the RNG standard and gives parties incentives to save the blockhash to avoid it to become unreachable after 256 blocks.
1143  *
1144  */
1145 pragma solidity ^0.4.15;
1146 
1147 /** Simple Random Number Generator returning the blockhash.
1148  *  Allows saving the random number for use in the future.
1149  *  It allows the contract to still access the blockhash even after 256 blocks.
1150  *  The first party to call the save function gets the reward.
1151  */
1152 contract BlockHashRNG is RNG {
1153 
1154     mapping (uint => uint) public randomNumber; // randomNumber[block] is the random number for this block, 0 otherwise.
1155     mapping (uint => uint) public reward; // reward[block] is the amount to be paid to the party w.
1156 
1157 
1158 
1159     /** @dev Contribute to the reward of a random number.
1160      *  @param _block Block the random number is linked to.
1161      */
1162     function contribute(uint _block) public payable { reward[_block] += msg.value; }
1163 
1164 
1165     /** @dev Return the random number. If it has not been saved and is still computable compute it.
1166      *  @param _block Block the random number is linked to.
1167      *  @return RN Random Number. If the number is not ready or has not been requested 0 instead.
1168      */
1169     function getRN(uint _block) public returns (uint RN) {
1170         RN = randomNumber[_block];
1171         if (RN == 0){
1172             saveRN(_block);
1173             return randomNumber[_block];
1174         }
1175         else
1176             return RN;
1177     }
1178 
1179     /** @dev Save the random number for this blockhash and give the reward to the caller.
1180      *  @param _block Block the random number is linked to.
1181      */
1182     function saveRN(uint _block) public {
1183         if (blockhash(_block) != 0x0)
1184             randomNumber[_block] = uint(blockhash(_block));
1185         else
1186             randomNumber[_block] = getFallbackRN(_block);
1187 
1188         if (randomNumber[_block] != 0) { // If the number is set.
1189             uint rewardToSend = reward[_block];
1190             reward[_block] = 0;
1191             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
1192         }
1193     }
1194 
1195     /** @dev Fallback strategy. This class has no fallback. Subclass provides fallback strategy by overriding this method.
1196      *  @param _block Block the random number is linked to.
1197      */
1198     function getFallbackRN(uint _block) internal view returns (uint) {
1199         return 0x0; 
1200     }
1201 }
1202 
1203 /**
1204  *  https://contributing.kleros.io/smart-contract-workflow
1205  *  @reviewers: []
1206  *  @auditors: []
1207  *  @bounties: []
1208  *  @deployments: []
1209  */
1210 
1211 /* solium-disable security/no-block-members */
1212 /**
1213  *  https://contributing.kleros.io/smart-contract-workflow
1214  *  @reviewers: []
1215  *  @auditors: []
1216  *  @bounties: []
1217  *  @deployments: []
1218  */
1219 
1220 /* solium-disable security/no-block-members */
1221 /**
1222  *  https://contributing.kleros.io/smart-contract-workflow
1223  *  @reviewers: []
1224  *  @auditors: []
1225  *  @bounties: []
1226  *  @deployments: []
1227  */
1228 
1229 /**
1230  *  https://contributing.kleros.io/smart-contract-workflow
1231  *  @reviewers: []
1232  *  @auditors: []
1233  *  @bounties: []
1234  *  @deployments: []
1235  */
1236 /* solium-disable error-reason */
1237 /* solium-disable security/no-block-members */
1238 pragma solidity ^0.4.24;
1239 
1240 
1241 /**
1242  *  @title KlerosLiquid
1243  *  @author Enrique Piqueras - <epiquerass@gmail.com>
1244  *  @dev The main Kleros contract with dispute resolution logic for the Athena release.
1245  */
1246 contract KlerosLiquid is TokenController, Arbitrator {
1247     /* Enums */
1248 
1249     // General
1250     enum Phase {
1251       staking, // Stake sum trees can be updated. Pass after `minStakingTime` passes and there is at least one dispute without jurors.
1252       generating, // Waiting for a random number. Pass as soon as it is ready.
1253       drawing // Jurors can be drawn. Pass after all disputes have jurors or `maxDrawingTime` passes.
1254     }
1255 
1256     // Dispute
1257     enum Period {
1258       evidence, // Evidence can be submitted. This is also when drawing has to take place.
1259       commit, // Jurors commit a hashed vote. This is skipped for courts without hidden votes.
1260       vote, // Jurors reveal/cast their vote depending on whether the court has hidden votes or not.
1261       appeal, // The dispute can be appealed.
1262       execution // Tokens are redistributed and the ruling is executed.
1263     }
1264 
1265     /* Structs */
1266 
1267     // General
1268     struct Court {
1269         uint96 parent; // The parent court.
1270         uint[] children; // List of child courts.
1271         bool hiddenVotes; // Whether to use commit and reveal or not.
1272         uint minStake; // Minimum tokens needed to stake in the court.
1273         uint alpha; // Basis point of tokens that are lost when incoherent.
1274         uint feeForJuror; // Arbitration fee paid per juror.
1275         // The appeal after the one that reaches this number of jurors will go to the parent court if any, otherwise, no more appeals are possible.
1276         uint jurorsForCourtJump;
1277         uint[4] timesPerPeriod; // The time allotted to each dispute period in the form `timesPerPeriod[period]`.
1278     }
1279     struct DelayedSetStake {
1280         address account; // The address of the juror.
1281         uint96 subcourtID; // The ID of the subcourt.
1282         uint128 stake; // The new stake.
1283     }
1284 
1285     // Dispute
1286     struct Vote {
1287         address account; // The address of the juror.
1288         bytes32 commit; // The commit of the juror. For courts with hidden votes.
1289         uint choice; // The choice of the juror.
1290         bool voted; // True if the vote has been cast or revealed, false otherwise.
1291     }
1292     struct VoteCounter {
1293         // The choice with the most votes. Note that in the case of a tie, it is the choice that reached the tied number of votes first.
1294         uint winningChoice;
1295         mapping(uint => uint) counts; // The sum of votes for each choice in the form `counts[choice]`.
1296         bool tied; // True if there is a tie, false otherwise.
1297     }
1298     struct Dispute { // Note that appeal `0` is equivalent to the first round of the dispute.
1299         uint96 subcourtID; // The ID of the subcourt the dispute is in.
1300         Arbitrable arbitrated; // The arbitrated arbitrable contract.
1301         // The number of choices jurors have when voting. This does not include choice `0` which is reserved for "refuse to arbitrate"/"no ruling".
1302         uint numberOfChoices;
1303         Period period; // The current period of the dispute.
1304         uint lastPeriodChange; // The last time the period was changed.
1305         // The votes in the form `votes[appeal][voteID]`. On each round, a new list is pushed and packed with as many empty votes as there are draws. We use `dispute.votes.length` to get the number of appeals plus 1 for the first round.
1306         Vote[][] votes;
1307         VoteCounter[] voteCounters; // The vote counters in the form `voteCounters[appeal]`.
1308         uint[] tokensAtStakePerJuror; // The amount of tokens at stake for each juror in the form `tokensAtStakePerJuror[appeal]`.
1309         uint[] totalFeesForJurors; // The total juror fees paid in the form `totalFeesForJurors[appeal]`.
1310         uint drawsInRound; // A counter of draws made in the current round.
1311         uint commitsInRound; // A counter of commits made in the current round.
1312         uint[] votesInEachRound; // A counter of votes made in each round in the form `votesInEachRound[appeal]`.
1313         // A counter of vote reward repartitions made in each round in the form `repartitionsInEachRound[appeal]`.
1314         uint[] repartitionsInEachRound;
1315         uint[] penaltiesInEachRound; // The amount of tokens collected from penalties in each round in the form `penaltiesInEachRound[appeal]`.
1316         bool ruled; // True if the ruling has been executed, false otherwise.
1317     }
1318 
1319     // Juror
1320     struct Juror {
1321         // The IDs of subcourts where the juror has stake path ends. A stake path is a path from the general court to a court the juror directly staked in using `_setStake`.
1322         uint96[] subcourtIDs;
1323         uint stakedTokens; // The juror's total amount of tokens staked in subcourts.
1324         uint lockedTokens; // The juror's total amount of tokens locked in disputes.
1325     }
1326 
1327     /* Events */
1328 
1329     /** @dev Emitted when we pass to a new phase.
1330      *  @param _phase The new phase.
1331      */
1332     event NewPhase(Phase _phase);
1333 
1334     /** @dev Emitted when a dispute passes to a new period.
1335      *  @param _disputeID The ID of the dispute.
1336      *  @param _period The new period.
1337      */
1338     event NewPeriod(uint indexed _disputeID, Period _period);
1339 
1340     /** @dev Emitted when a juror's stake is set.
1341      *  @param _address The address of the juror.
1342      *  @param _subcourtID The ID of the subcourt at the end of the stake path.
1343      *  @param _stake The new stake.
1344      *  @param _newTotalStake The new total stake.
1345      */
1346     event StakeSet(address indexed _address, uint _subcourtID, uint128 _stake, uint _newTotalStake);
1347 
1348     /** @dev Emitted when a juror is drawn.
1349      *  @param _address The drawn address.
1350      *  @param _disputeID The ID of the dispute.
1351      *  @param _appeal The appeal the draw is for. 0 is for the first round.
1352      *  @param _voteID The vote ID.
1353      */
1354     event Draw(address indexed _address, uint indexed _disputeID, uint _appeal, uint _voteID);
1355 
1356     /** @dev Emitted when a juror wins or loses tokens and ETH from a dispute.
1357      *  @param _address The juror affected.
1358      *  @param _disputeID The ID of the dispute.
1359      *  @param _tokenAmount The amount of tokens won or lost.
1360      *  @param _ETHAmount The amount of ETH won or lost.
1361      */
1362     event TokenAndETHShift(address indexed _address, uint indexed _disputeID, int _tokenAmount, int _ETHAmount);
1363 
1364     /* Storage */
1365 
1366     // General Constants
1367     uint public constant MAX_STAKE_PATHS = 4; // The maximum number of stake paths a juror can have.
1368     uint public constant MIN_JURORS = 3; // The global default minimum number of jurors in a dispute.
1369     uint public constant NON_PAYABLE_AMOUNT = (2 ** 256 - 2) / 2; // An amount higher than the supply of ETH.
1370     uint public constant ALPHA_DIVISOR = 1e4; // The number to divide `Court.alpha` by.
1371     // General Contracts
1372     address public governor; // The governor of the contract.
1373     Pinakion public pinakion; // The Pinakion token contract.
1374     RNG public RNGenerator; // The random number generator contract.
1375     // General Dynamic
1376     Phase public phase; // The current phase.
1377     uint public lastPhaseChange; // The last time the phase was changed.
1378     uint public disputesWithoutJurors; // The number of disputes that have not finished drawing jurors.
1379     // The block number to get the next random number from. Used so there is at least a 1 block difference from the staking phase.
1380     uint public RNBlock;
1381     uint public RN; // The current random number.
1382     uint public minStakingTime; // The minimum staking time.
1383     uint public maxDrawingTime; // The maximum drawing time.
1384     // True if insolvent (`balance < stakedTokens || balance < lockedTokens`) token transfers should be blocked. Used to avoid blocking penalties.
1385     bool public lockInsolventTransfers = true;
1386     // General Storage
1387     Court[] public courts; // The subcourts.
1388     using SortitionSumTreeFactory for SortitionSumTreeFactory.SortitionSumTrees; // Use library functions for sortition sum trees.
1389     SortitionSumTreeFactory.SortitionSumTrees internal sortitionSumTrees; // The sortition sum trees.
1390     // The delayed calls to `_setStake`. Used to schedule `_setStake`s when not in the staking phase.
1391     mapping(uint => DelayedSetStake) public delayedSetStakes;
1392     // The index of the next `delayedSetStakes` item to execute. Starts at 1 because `lastDelayedSetStake` starts at 0.
1393     uint public nextDelayedSetStake = 1;
1394     uint public lastDelayedSetStake; // The index of the last `delayedSetStakes` item. 0 is skipped because it is the initial value.
1395 
1396     // Dispute
1397     Dispute[] public disputes; // The disputes.
1398 
1399     // Juror
1400     mapping(address => Juror) public jurors; // The jurors.
1401 
1402     /* Modifiers */
1403 
1404     /** @dev Requires a specific phase.
1405      *  @param _phase The required phase.
1406      */
1407     modifier onlyDuringPhase(Phase _phase) {require(phase == _phase); _;}
1408 
1409     /** @dev Requires a specific period in a dispute.
1410      *  @param _disputeID The ID of the dispute.
1411      *  @param _period The required period.
1412      */
1413     modifier onlyDuringPeriod(uint _disputeID, Period _period) {require(disputes[_disputeID].period == _period); _;}
1414 
1415     /** @dev Requires that the sender is the governor. Note that the governor is expected to not be malicious. */
1416     modifier onlyByGovernor() {require(governor == msg.sender); _;}
1417 
1418     /* Constructor */
1419 
1420     /** @dev Constructs the KlerosLiquid contract.
1421      *  @param _governor The governor's address.
1422      *  @param _pinakion The address of the token contract.
1423      *  @param _RNGenerator The address of the RNG contract.
1424      *  @param _minStakingTime The minimum time that the staking phase should last.
1425      *  @param _maxDrawingTime The maximum time that the drawing phase should last.
1426      *  @param _hiddenVotes The `hiddenVotes` property value of the general court.
1427      *  @param _minStake The `minStake` property value of the general court.
1428      *  @param _alpha The `alpha` property value of the general court.
1429      *  @param _feeForJuror The `feeForJuror` property value of the general court.
1430      *  @param _jurorsForCourtJump The `jurorsForCourtJump` property value of the general court.
1431      *  @param _timesPerPeriod The `timesPerPeriod` property value of the general court.
1432      *  @param _sortitionSumTreeK The number of children per node of the general court's sortition sum tree.
1433      */
1434     constructor(
1435         address _governor,
1436         Pinakion _pinakion,
1437         RNG _RNGenerator,
1438         uint _minStakingTime,
1439         uint _maxDrawingTime,
1440         bool _hiddenVotes,
1441         uint _minStake,
1442         uint _alpha,
1443         uint _feeForJuror,
1444         uint _jurorsForCourtJump,
1445         uint[4] _timesPerPeriod,
1446         uint _sortitionSumTreeK
1447     ) public {
1448         // Initialize contract.
1449         governor = _governor;
1450         pinakion = _pinakion;
1451         RNGenerator = _RNGenerator;
1452         minStakingTime = _minStakingTime;
1453         maxDrawingTime = _maxDrawingTime;
1454         lastPhaseChange = now;
1455 
1456         // Create the general court.
1457         courts.push(Court({
1458             parent: 0,
1459             children: new uint[](0),
1460             hiddenVotes: _hiddenVotes,
1461             minStake: _minStake,
1462             alpha: _alpha,
1463             feeForJuror: _feeForJuror,
1464             jurorsForCourtJump: _jurorsForCourtJump,
1465             timesPerPeriod: _timesPerPeriod
1466         }));
1467         sortitionSumTrees.createTree(bytes32(0), _sortitionSumTreeK);
1468     }
1469 
1470     /* External */
1471 
1472     /** @dev Lets the governor call anything on behalf of the contract.
1473      *  @param _destination The destination of the call.
1474      *  @param _amount The value sent with the call.
1475      *  @param _data The data sent with the call.
1476      */
1477     function executeGovernorProposal(address _destination, uint _amount, bytes _data) external onlyByGovernor {
1478         require(_destination.call.value(_amount)(_data)); // solium-disable-line security/no-call-value
1479     }
1480 
1481     // /** @dev Changes the `governor` storage variable.
1482     //  *  @param _governor The new value for the `governor` storage variable.
1483     //  */
1484     // function changeGovernor(address _governor) external onlyByGovernor {
1485     //     governor = _governor;
1486     // }
1487 
1488     // /** @dev Changes the `pinakion` storage variable.
1489     //  *  @param _pinakion The new value for the `pinakion` storage variable.
1490     //  */
1491     // function changePinakion(Pinakion _pinakion) external onlyByGovernor {
1492     //     pinakion = _pinakion;
1493     // }
1494 
1495     /** @dev Changes the `RNGenerator` storage variable.
1496      *  @param _RNGenerator The new value for the `RNGenerator` storage variable.
1497      */
1498     function changeRNGenerator(RNG _RNGenerator) external onlyByGovernor {
1499         RNGenerator = _RNGenerator;
1500         if (phase == Phase.generating) {
1501             RNBlock = block.number + 1;
1502             RNGenerator.requestRN(RNBlock);
1503         }
1504     }
1505 
1506     // /** @dev Changes the `minStakingTime` storage variable.
1507     //  *  @param _minStakingTime The new value for the `minStakingTime` storage variable.
1508     //  */
1509     // function changeMinStakingTime(uint _minStakingTime) external onlyByGovernor {
1510     //     minStakingTime = _minStakingTime;
1511     // }
1512 
1513     // /** @dev Changes the `maxDrawingTime` storage variable.
1514     //  *  @param _maxDrawingTime The new value for the `maxDrawingTime` storage variable.
1515     //  */
1516     // function changeMaxDrawingTime(uint _maxDrawingTime) external onlyByGovernor {
1517     //     maxDrawingTime = _maxDrawingTime;
1518     // }
1519 
1520     /** @dev Creates a subcourt under a specified parent court.
1521      *  @param _parent The `parent` property value of the subcourt.
1522      *  @param _hiddenVotes The `hiddenVotes` property value of the subcourt.
1523      *  @param _minStake The `minStake` property value of the subcourt.
1524      *  @param _alpha The `alpha` property value of the subcourt.
1525      *  @param _feeForJuror The `feeForJuror` property value of the subcourt.
1526      *  @param _jurorsForCourtJump The `jurorsForCourtJump` property value of the subcourt.
1527      *  @param _timesPerPeriod The `timesPerPeriod` property value of the subcourt.
1528      *  @param _sortitionSumTreeK The number of children per node of the subcourt's sortition sum tree.
1529      */
1530     function createSubcourt(
1531         uint96 _parent,
1532         bool _hiddenVotes,
1533         uint _minStake,
1534         uint _alpha,
1535         uint _feeForJuror,
1536         uint _jurorsForCourtJump,
1537         uint[4] _timesPerPeriod,
1538         uint _sortitionSumTreeK
1539     ) external onlyByGovernor {
1540         require(courts[_parent].minStake <= _minStake, "A subcourt cannot be a child of a subcourt with a higher minimum stake.");
1541 
1542         // Create the subcourt.
1543         uint96 subcourtID = uint96(
1544             courts.push(Court({
1545                 parent: _parent,
1546                 children: new uint[](0),
1547                 hiddenVotes: _hiddenVotes,
1548                 minStake: _minStake,
1549                 alpha: _alpha,
1550                 feeForJuror: _feeForJuror,
1551                 jurorsForCourtJump: _jurorsForCourtJump,
1552                 timesPerPeriod: _timesPerPeriod
1553             })) - 1
1554         );
1555         sortitionSumTrees.createTree(bytes32(subcourtID), _sortitionSumTreeK);
1556 
1557         // Update the parent.
1558         courts[_parent].children.push(subcourtID);
1559     }
1560 
1561     /** @dev Changes the `minStake` property value of a specified subcourt. Don't set to a value lower than its parent's `minStake` property value.
1562      *  @param _subcourtID The ID of the subcourt.
1563      *  @param _minStake The new value for the `minStake` property value.
1564      */
1565     function changeSubcourtMinStake(uint96 _subcourtID, uint _minStake) external onlyByGovernor {
1566         require(_subcourtID == 0 || courts[courts[_subcourtID].parent].minStake <= _minStake);
1567         for (uint i = 0; i < courts[_subcourtID].children.length; i++) {
1568             require(
1569                 courts[courts[_subcourtID].children[i]].minStake >= _minStake,
1570                 "A subcourt cannot be the parent of a subcourt with a lower minimum stake."
1571             );
1572         }
1573 
1574         courts[_subcourtID].minStake = _minStake;
1575     }
1576 
1577     /** @dev Changes the `alpha` property value of a specified subcourt.
1578      *  @param _subcourtID The ID of the subcourt.
1579      *  @param _alpha The new value for the `alpha` property value.
1580      */
1581     function changeSubcourtAlpha(uint96 _subcourtID, uint _alpha) external onlyByGovernor {
1582         courts[_subcourtID].alpha = _alpha;
1583     }
1584 
1585     /** @dev Changes the `feeForJuror` property value of a specified subcourt.
1586      *  @param _subcourtID The ID of the subcourt.
1587      *  @param _feeForJuror The new value for the `feeForJuror` property value.
1588      */
1589     function changeSubcourtJurorFee(uint96 _subcourtID, uint _feeForJuror) external onlyByGovernor {
1590         courts[_subcourtID].feeForJuror = _feeForJuror;
1591     }
1592 
1593     /** @dev Changes the `jurorsForCourtJump` property value of a specified subcourt.
1594      *  @param _subcourtID The ID of the subcourt.
1595      *  @param _jurorsForCourtJump The new value for the `jurorsForCourtJump` property value.
1596      */
1597     function changeSubcourtJurorsForJump(uint96 _subcourtID, uint _jurorsForCourtJump) external onlyByGovernor {
1598         courts[_subcourtID].jurorsForCourtJump = _jurorsForCourtJump;
1599     }
1600 
1601     /** @dev Changes the `timesPerPeriod` property value of a specified subcourt.
1602      *  @param _subcourtID The ID of the subcourt.
1603      *  @param _timesPerPeriod The new value for the `timesPerPeriod` property value.
1604      */
1605     function changeSubcourtTimesPerPeriod(uint96 _subcourtID, uint[4] _timesPerPeriod) external onlyByGovernor {
1606         courts[_subcourtID].timesPerPeriod = _timesPerPeriod;
1607     }
1608 
1609     /** @dev Passes the phase. TRUSTED */
1610     function passPhase() external {
1611         if (phase == Phase.staking) {
1612             require(now - lastPhaseChange >= minStakingTime, "The minimum staking time has not passed yet.");
1613             require(disputesWithoutJurors > 0, "There are no disputes that need jurors.");
1614             RNBlock = block.number + 1;
1615             RNGenerator.requestRN(RNBlock);
1616             phase = Phase.generating;
1617         } else if (phase == Phase.generating) {
1618             RN = RNGenerator.getUncorrelatedRN(RNBlock);
1619             require(RN != 0, "Random number is not ready yet.");
1620             phase = Phase.drawing;
1621         } else if (phase == Phase.drawing) {
1622             require(disputesWithoutJurors == 0 || now - lastPhaseChange >= maxDrawingTime, "There are still disputes without jurors and the maximum drawing time has not passed yet.");
1623             phase = Phase.staking;
1624         }
1625 
1626         lastPhaseChange = now;
1627         emit NewPhase(phase);
1628     }
1629 
1630     /** @dev Passes the period of a specified dispute.
1631      *  @param _disputeID The ID of the dispute.
1632      */
1633     function passPeriod(uint _disputeID) external {
1634         Dispute storage dispute = disputes[_disputeID];
1635         if (dispute.period == Period.evidence) {
1636             require(
1637                 dispute.votes.length > 1 || now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)],
1638                 "The evidence period time has not passed yet and it is not an appeal."
1639             );
1640             require(dispute.drawsInRound == dispute.votes[dispute.votes.length - 1].length, "The dispute has not finished drawing yet.");
1641             dispute.period = courts[dispute.subcourtID].hiddenVotes ? Period.commit : Period.vote;
1642         } else if (dispute.period == Period.commit) {
1643             require(
1644                 now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)] || dispute.commitsInRound == dispute.votes[dispute.votes.length - 1].length,
1645                 "The commit period time has not passed yet and not every juror has committed yet."
1646             );
1647             dispute.period = Period.vote;
1648         } else if (dispute.period == Period.vote) {
1649             require(
1650                 now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)] || dispute.votesInEachRound[dispute.votes.length - 1] == dispute.votes[dispute.votes.length - 1].length,
1651                 "The vote period time has not passed yet and not every juror has voted yet."
1652             );
1653             dispute.period = Period.appeal;
1654             emit AppealPossible(_disputeID, dispute.arbitrated);
1655         } else if (dispute.period == Period.appeal) {
1656             require(now - dispute.lastPeriodChange >= courts[dispute.subcourtID].timesPerPeriod[uint(dispute.period)], "The appeal period time has not passed yet.");
1657             dispute.period = Period.execution;
1658         } else if (dispute.period == Period.execution) {
1659             revert("The dispute is already in the last period.");
1660         }
1661 
1662         dispute.lastPeriodChange = now;
1663         emit NewPeriod(_disputeID, dispute.period);
1664     }
1665 
1666     /** @dev Sets the caller's stake in a subcourt.
1667      *  @param _subcourtID The ID of the subcourt.
1668      *  @param _stake The new stake.
1669      */
1670     function setStake(uint96 _subcourtID, uint128 _stake) external {
1671         require(_setStake(msg.sender, _subcourtID, _stake));
1672     }
1673 
1674     /** @dev Executes the next delayed set stakes.
1675      *  @param _iterations The number of delayed set stakes to execute.
1676      */
1677     function executeDelayedSetStakes(uint _iterations) external onlyDuringPhase(Phase.staking) {
1678         uint actualIterations = (nextDelayedSetStake + _iterations) - 1 > lastDelayedSetStake ?
1679             (lastDelayedSetStake - nextDelayedSetStake) + 1 : _iterations;
1680         uint newNextDelayedSetStake = nextDelayedSetStake + actualIterations;
1681         require(newNextDelayedSetStake >= nextDelayedSetStake);
1682         for (uint i = nextDelayedSetStake; i < newNextDelayedSetStake; i++) {
1683             DelayedSetStake storage delayedSetStake = delayedSetStakes[i];
1684             _setStake(delayedSetStake.account, delayedSetStake.subcourtID, delayedSetStake.stake);
1685             delete delayedSetStakes[i];
1686         }
1687         nextDelayedSetStake = newNextDelayedSetStake;
1688     }
1689 
1690     /** @dev Draws jurors for a dispute. Can be called in parts.
1691      *  `O(n * k * log_k(j))` where
1692      *  `n` is the number of iterations to run,
1693      *  `k` is the number of children per node of the dispute's court's sortition sum tree,
1694      *  and `j` is the maximum number of jurors that ever staked in it simultaneously.
1695      *  @param _disputeID The ID of the dispute.
1696      *  @param _iterations The number of iterations to run.
1697      */
1698     function drawJurors(
1699         uint _disputeID,
1700         uint _iterations
1701     ) external onlyDuringPhase(Phase.drawing) onlyDuringPeriod(_disputeID, Period.evidence) {
1702         Dispute storage dispute = disputes[_disputeID];
1703         uint endIndex = dispute.drawsInRound + _iterations;
1704         require(endIndex >= dispute.drawsInRound);
1705 
1706         // Avoid going out of range.
1707         if (endIndex > dispute.votes[dispute.votes.length - 1].length) endIndex = dispute.votes[dispute.votes.length - 1].length;
1708         for (uint i = dispute.drawsInRound; i < endIndex; i++) {
1709             // Draw from sortition tree.
1710             (
1711                 address drawnAddress,
1712                 uint subcourtID
1713             ) = stakePathIDToAccountAndSubcourtID(sortitionSumTrees.draw(bytes32(dispute.subcourtID), uint(keccak256(RN, _disputeID, i))));
1714 
1715             // Save the vote.
1716             dispute.votes[dispute.votes.length - 1][i].account = drawnAddress;
1717             jurors[drawnAddress].lockedTokens += dispute.tokensAtStakePerJuror[dispute.tokensAtStakePerJuror.length - 1];
1718             emit Draw(drawnAddress, _disputeID, dispute.votes.length - 1, i);
1719 
1720             // If dispute is fully drawn.
1721             if (i == dispute.votes[dispute.votes.length - 1].length - 1) disputesWithoutJurors--;
1722         }
1723         dispute.drawsInRound = endIndex;
1724     }
1725 
1726     /** @dev Sets the caller's commit for the specified votes.
1727      *  `O(n)` where
1728      *  `n` is the number of votes.
1729      *  @param _disputeID The ID of the dispute.
1730      *  @param _voteIDs The IDs of the votes.
1731      *  @param _commit The commit.
1732      */
1733     function commit(uint _disputeID, uint[] _voteIDs, bytes32 _commit) external onlyDuringPeriod(_disputeID, Period.commit) {
1734         Dispute storage dispute = disputes[_disputeID];
1735         require(_commit != bytes32(0));
1736         for (uint i = 0; i < _voteIDs.length; i++) {
1737             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].account == msg.sender, "The caller has to own the vote.");
1738             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit == bytes32(0), "Already committed this vote.");
1739             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit = _commit;
1740         }
1741         dispute.commitsInRound += _voteIDs.length;
1742     }
1743 
1744     /** @dev Sets the caller's choices for the specified votes.
1745      *  `O(n)` where
1746      *  `n` is the number of votes.
1747      *  @param _disputeID The ID of the dispute.
1748      *  @param _voteIDs The IDs of the votes.
1749      *  @param _choice The choice.
1750      *  @param _salt The salt for the commit if the votes were hidden.
1751      */
1752     function vote(uint _disputeID, uint[] _voteIDs, uint _choice, uint _salt) external onlyDuringPeriod(_disputeID, Period.vote) {
1753         Dispute storage dispute = disputes[_disputeID];
1754         require(_voteIDs.length > 0);
1755         require(_choice <= dispute.numberOfChoices, "The choice has to be less than or equal to the number of choices for the dispute.");
1756 
1757         // Save the votes.
1758         for (uint i = 0; i < _voteIDs.length; i++) {
1759             require(dispute.votes[dispute.votes.length - 1][_voteIDs[i]].account == msg.sender, "The caller has to own the vote.");
1760             require(
1761                 !courts[dispute.subcourtID].hiddenVotes || dispute.votes[dispute.votes.length - 1][_voteIDs[i]].commit == keccak256(_choice, _salt),
1762                 "The commit must match the choice in subcourts with hidden votes."
1763             );
1764             require(!dispute.votes[dispute.votes.length - 1][_voteIDs[i]].voted, "Vote already cast.");
1765             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].choice = _choice;
1766             dispute.votes[dispute.votes.length - 1][_voteIDs[i]].voted = true;
1767         }
1768         dispute.votesInEachRound[dispute.votes.length - 1] += _voteIDs.length;
1769 
1770         // Update winning choice.
1771         VoteCounter storage voteCounter = dispute.voteCounters[dispute.voteCounters.length - 1];
1772         voteCounter.counts[_choice] += _voteIDs.length;
1773         if (_choice == voteCounter.winningChoice) { // Voted for the winning choice.
1774             if (voteCounter.tied) voteCounter.tied = false; // Potentially broke tie.
1775         } else { // Voted for another choice.
1776             if (voteCounter.counts[_choice] == voteCounter.counts[voteCounter.winningChoice]) { // Tie.
1777                 if (!voteCounter.tied) voteCounter.tied = true;
1778             } else if (voteCounter.counts[_choice] > voteCounter.counts[voteCounter.winningChoice]) { // New winner.
1779                 voteCounter.winningChoice = _choice;
1780                 voteCounter.tied = false;
1781             }
1782         }
1783     }
1784 
1785     /** @dev Computes the token and ETH rewards for a specified appeal in a specified dispute.
1786      *  @param _disputeID The ID of the dispute.
1787      *  @param _appeal The appeal.
1788      *  @return The token and ETH rewards.
1789      */
1790     function computeTokenAndETHRewards(uint _disputeID, uint _appeal) private view returns(uint tokenReward, uint ETHReward) {
1791         Dispute storage dispute = disputes[_disputeID];
1792 
1793         // Distribute penalties and arbitration fees.
1794         if (dispute.voteCounters[dispute.voteCounters.length - 1].tied) {
1795             // Distribute penalties and fees evenly between active jurors.
1796             uint activeCount = dispute.votesInEachRound[_appeal];
1797             if (activeCount > 0) {
1798                 tokenReward = dispute.penaltiesInEachRound[_appeal] / activeCount;
1799                 ETHReward = dispute.totalFeesForJurors[_appeal] / activeCount;
1800             } else {
1801                 tokenReward = 0;
1802                 ETHReward = 0;
1803             }
1804         } else {
1805             // Distribute penalties and fees evenly between coherent jurors.
1806             uint winningChoice = dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
1807             uint coherentCount = dispute.voteCounters[_appeal].counts[winningChoice];
1808             tokenReward = dispute.penaltiesInEachRound[_appeal] / coherentCount;
1809             ETHReward = dispute.totalFeesForJurors[_appeal] / coherentCount;
1810         }
1811     }
1812 
1813     /** @dev Repartitions tokens and ETH for a specified appeal in a specified dispute. Can be called in parts.
1814      *  `O(i + u * n * (n + p * log_k(j)))` where
1815      *  `i` is the number of iterations to run,
1816      *  `u` is the number of jurors that need to be unstaked,
1817      *  `n` is the maximum number of subcourts one of these jurors has staked in,
1818      *  `p` is the depth of the subcourt tree,
1819      *  `k` is the minimum number of children per node of one of these subcourts' sortition sum tree,
1820      *  and `j` is the maximum number of jurors that ever staked in one of these subcourts simultaneously.
1821      *  @param _disputeID The ID of the dispute.
1822      *  @param _appeal The appeal.
1823      *  @param _iterations The number of iterations to run.
1824      */
1825     function execute(uint _disputeID, uint _appeal, uint _iterations) external onlyDuringPeriod(_disputeID, Period.execution) {
1826         lockInsolventTransfers = false;
1827         Dispute storage dispute = disputes[_disputeID];
1828         uint end = dispute.repartitionsInEachRound[_appeal] + _iterations;
1829         require(end >= dispute.repartitionsInEachRound[_appeal]);
1830         uint penaltiesInRoundCache = dispute.penaltiesInEachRound[_appeal]; // For saving gas.
1831         (uint tokenReward, uint ETHReward) = (0, 0);
1832 
1833         // Avoid going out of range.
1834         if (
1835             !dispute.voteCounters[dispute.voteCounters.length - 1].tied &&
1836             dispute.voteCounters[_appeal].counts[dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice] == 0
1837         ) {
1838             // We loop over the votes once as there are no rewards because it is not a tie and no one in this round is coherent with the final outcome.
1839             if (end > dispute.votes[_appeal].length) end = dispute.votes[_appeal].length;
1840         } else {
1841             // We loop over the votes twice, first to collect penalties, and second to distribute them as rewards along with arbitration fees.
1842             (tokenReward, ETHReward) = dispute.repartitionsInEachRound[_appeal] >= dispute.votes[_appeal].length ? computeTokenAndETHRewards(_disputeID, _appeal) : (0, 0); // Compute rewards if rewarding.
1843             if (end > dispute.votes[_appeal].length * 2) end = dispute.votes[_appeal].length * 2;
1844         }
1845         for (uint i = dispute.repartitionsInEachRound[_appeal]; i < end; i++) {
1846             Vote storage vote = dispute.votes[_appeal][i % dispute.votes[_appeal].length];
1847             if (
1848                 vote.voted &&
1849                 (vote.choice == dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice || dispute.voteCounters[dispute.voteCounters.length - 1].tied)
1850             ) { // Juror was active, and voted coherently or it was a tie.
1851                 if (i >= dispute.votes[_appeal].length) { // Only execute in the second half of the iterations.
1852 
1853                     // Reward.
1854                     pinakion.transfer(vote.account, tokenReward);
1855                     // Intentional use to avoid blocking.
1856                     vote.account.send(ETHReward); // solium-disable-line security/no-send
1857                     emit TokenAndETHShift(vote.account, _disputeID, int(tokenReward), int(ETHReward));
1858                     jurors[vote.account].lockedTokens -= dispute.tokensAtStakePerJuror[_appeal];
1859                 }
1860             } else { // Juror was inactive, or voted incoherently and it was not a tie.
1861                 if (i < dispute.votes[_appeal].length) { // Only execute in the first half of the iterations.
1862 
1863                     // Penalize.
1864                     uint penalty = dispute.tokensAtStakePerJuror[_appeal] > pinakion.balanceOf(vote.account) ? pinakion.balanceOf(vote.account) : dispute.tokensAtStakePerJuror[_appeal];
1865                     pinakion.transferFrom(vote.account, this, penalty);
1866                     emit TokenAndETHShift(vote.account, _disputeID, -int(penalty), 0);
1867                     penaltiesInRoundCache += penalty;
1868                     jurors[vote.account].lockedTokens -= dispute.tokensAtStakePerJuror[_appeal];
1869 
1870                     // Unstake juror if his penalty made balance less than his total stake or if he lost due to inactivity.
1871                     if (pinakion.balanceOf(vote.account) < jurors[vote.account].stakedTokens || !vote.voted)
1872                         for (uint j = 0; j < jurors[vote.account].subcourtIDs.length; j++)
1873                             _setStake(vote.account, jurors[vote.account].subcourtIDs[j], 0);
1874 
1875                 }
1876             }
1877             if (i == dispute.votes[_appeal].length - 1) {
1878                 // Send fees and tokens to the governor if no one was coherent.
1879                 if (dispute.votesInEachRound[_appeal] == 0 || !dispute.voteCounters[dispute.voteCounters.length - 1].tied && dispute.voteCounters[_appeal].counts[dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice] == 0) {
1880                     // Intentional use to avoid blocking.
1881                     governor.send(dispute.totalFeesForJurors[_appeal]); // solium-disable-line security/no-send
1882                     pinakion.transfer(governor, penaltiesInRoundCache);
1883                 } else if (i + 1 < end) {
1884                     // Compute rewards because we are going into rewarding.
1885                     dispute.penaltiesInEachRound[_appeal] = penaltiesInRoundCache;
1886                     (tokenReward, ETHReward) = computeTokenAndETHRewards(_disputeID, _appeal);
1887                 }
1888             }
1889         }
1890         if (dispute.penaltiesInEachRound[_appeal] != penaltiesInRoundCache) dispute.penaltiesInEachRound[_appeal] = penaltiesInRoundCache;
1891         dispute.repartitionsInEachRound[_appeal] = end;
1892         lockInsolventTransfers = true;
1893     }
1894 
1895     /** @dev Executes a specified dispute's ruling. UNTRUSTED.
1896      *  @param _disputeID The ID of the dispute.
1897      */
1898     function executeRuling(uint _disputeID) external onlyDuringPeriod(_disputeID, Period.execution) {
1899         Dispute storage dispute = disputes[_disputeID];
1900         require(!dispute.ruled, "Ruling already executed.");
1901         dispute.ruled = true;
1902         uint winningChoice = dispute.voteCounters[dispute.voteCounters.length - 1].tied ? 0
1903             : dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
1904         dispute.arbitrated.rule(_disputeID, winningChoice);
1905     }
1906 
1907     /* Public */
1908 
1909     /** @dev Creates a dispute. Must be called by the arbitrable contract.
1910      *  @param _numberOfChoices Number of choices to choose from in the dispute to be created.
1911      *  @param _extraData Additional info about the dispute to be created. We use it to pass the ID of the subcourt to create the dispute in (first 32 bytes) and the minimum number of jurors required (next 32 bytes).
1912      *  @return The ID of the created dispute.
1913      */
1914     function createDispute(
1915         uint _numberOfChoices,
1916         bytes _extraData
1917     ) public payable requireArbitrationFee(_extraData) returns(uint disputeID)  {
1918         (uint96 subcourtID, uint minJurors) = extraDataToSubcourtIDAndMinJurors(_extraData);
1919         disputeID = disputes.length++;
1920         Dispute storage dispute = disputes[disputeID];
1921         dispute.subcourtID = subcourtID;
1922         dispute.arbitrated = Arbitrable(msg.sender);
1923         dispute.numberOfChoices = _numberOfChoices;
1924         dispute.period = Period.evidence;
1925         dispute.lastPeriodChange = now;
1926         // As many votes that can be afforded by the provided funds.
1927         dispute.votes[dispute.votes.length++].length = msg.value / courts[dispute.subcourtID].feeForJuror;
1928         dispute.voteCounters[dispute.voteCounters.length++].tied = true;
1929         dispute.tokensAtStakePerJuror.push((courts[dispute.subcourtID].minStake * courts[dispute.subcourtID].alpha) / ALPHA_DIVISOR);
1930         dispute.totalFeesForJurors.push(msg.value);
1931         dispute.votesInEachRound.push(0);
1932         dispute.repartitionsInEachRound.push(0);
1933         dispute.penaltiesInEachRound.push(0);
1934         disputesWithoutJurors++;
1935 
1936         emit DisputeCreation(disputeID, Arbitrable(msg.sender));
1937     }
1938 
1939     /** @dev Appeals the ruling of a specified dispute.
1940      *  @param _disputeID The ID of the dispute.
1941      *  @param _extraData Additional info about the appeal. Not used by this contract.
1942      */
1943     function appeal(
1944         uint _disputeID,
1945         bytes _extraData
1946     ) public payable requireAppealFee(_disputeID, _extraData) onlyDuringPeriod(_disputeID, Period.appeal) {
1947         Dispute storage dispute = disputes[_disputeID];
1948         require(
1949             msg.sender == address(dispute.arbitrated),
1950             "Can only be called by the arbitrable contract."
1951         );
1952         if (dispute.votes[dispute.votes.length - 1].length >= courts[dispute.subcourtID].jurorsForCourtJump) // Jump to parent subcourt.
1953             dispute.subcourtID = courts[dispute.subcourtID].parent;
1954         dispute.period = Period.evidence;
1955         dispute.lastPeriodChange = now;
1956         // As many votes that can be afforded by the provided funds.
1957         dispute.votes[dispute.votes.length++].length = msg.value / courts[dispute.subcourtID].feeForJuror;
1958         dispute.voteCounters[dispute.voteCounters.length++].tied = true;
1959         dispute.tokensAtStakePerJuror.push((courts[dispute.subcourtID].minStake * courts[dispute.subcourtID].alpha) / ALPHA_DIVISOR);
1960         dispute.totalFeesForJurors.push(msg.value);
1961         dispute.drawsInRound = 0;
1962         dispute.commitsInRound = 0;
1963         dispute.votesInEachRound.push(0);
1964         dispute.repartitionsInEachRound.push(0);
1965         dispute.penaltiesInEachRound.push(0);
1966         disputesWithoutJurors++;
1967 
1968         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
1969     }
1970 
1971     /** @dev Called when `_owner` sends ether to the MiniMe Token contract.
1972      *  @param _owner The address that sent the ether to create tokens.
1973      *  @return Whether the operation should be allowed or not.
1974      */
1975     function proxyPayment(address _owner) public payable returns(bool allowed) { allowed = false; }
1976 
1977     /** @dev Notifies the controller about a token transfer allowing the controller to react if desired.
1978      *  @param _from The origin of the transfer.
1979      *  @param _to The destination of the transfer.
1980      *  @param _amount The amount of the transfer.
1981      *  @return Whether the operation should be allowed or not.
1982      */
1983     function onTransfer(address _from, address _to, uint _amount) public returns(bool allowed) {
1984         if (lockInsolventTransfers) { // Never block penalties or rewards.
1985             uint newBalance = pinakion.balanceOf(_from) - _amount;
1986             if (newBalance < jurors[_from].stakedTokens || newBalance < jurors[_from].lockedTokens) return false;
1987         }
1988         allowed = true;
1989     }
1990 
1991     /** @dev Notifies the controller about an approval allowing the controller to react if desired.
1992      *  @param _owner The address that calls `approve()`.
1993      *  @param _spender The spender in the `approve()` call.
1994      *  @param _amount The amount in the `approve()` call.
1995      *  @return Whether the operation should be allowed or not.
1996      */
1997     function onApprove(address _owner, address _spender, uint _amount) public returns(bool allowed) { allowed = true; }
1998 
1999     /* Public Views */
2000 
2001     /** @dev Gets the cost of arbitration in a specified subcourt.
2002      *  @param _extraData Additional info about the dispute. We use it to pass the ID of the subcourt to create the dispute in (first 32 bytes) and the minimum number of jurors required (next 32 bytes).
2003      *  @return The cost.
2004      */
2005     function arbitrationCost(bytes _extraData) public view returns(uint cost) {
2006         (uint96 subcourtID, uint minJurors) = extraDataToSubcourtIDAndMinJurors(_extraData);
2007         cost = courts[subcourtID].feeForJuror * minJurors;
2008     }
2009 
2010     /** @dev Gets the cost of appealing a specified dispute.
2011      *  @param _disputeID The ID of the dispute.
2012      *  @param _extraData Additional info about the appeal. Not used by this contract.
2013      *  @return The cost.
2014      */
2015     function appealCost(uint _disputeID, bytes _extraData) public view returns(uint cost) {
2016         Dispute storage dispute = disputes[_disputeID];
2017         uint lastNumberOfJurors = dispute.votes[dispute.votes.length - 1].length;
2018         if (lastNumberOfJurors >= courts[dispute.subcourtID].jurorsForCourtJump) { // Jump to parent subcourt.
2019             if (dispute.subcourtID == 0) // Already in the general court.
2020                 cost = NON_PAYABLE_AMOUNT;
2021             else // Get the cost of the parent subcourt.
2022                 cost = courts[courts[dispute.subcourtID].parent].feeForJuror * ((lastNumberOfJurors * 2) + 1);
2023         } else // Stay in current subcourt.
2024             cost = courts[dispute.subcourtID].feeForJuror * ((lastNumberOfJurors * 2) + 1);
2025     }
2026 
2027     /** @dev Gets the start and end of a specified dispute's current appeal period.
2028      *  @param _disputeID The ID of the dispute.
2029      *  @return The start and end of the appeal period.
2030      */
2031     function appealPeriod(uint _disputeID) public view returns(uint start, uint end) {
2032         Dispute storage dispute = disputes[_disputeID];
2033         if (dispute.period == Period.appeal) {
2034             start = dispute.lastPeriodChange;
2035             end = dispute.lastPeriodChange + courts[dispute.subcourtID].timesPerPeriod[uint(Period.appeal)];
2036         } else {
2037             start = 0;
2038             end = 0;
2039         }
2040     }
2041 
2042     /** @dev Gets the status of a specified dispute.
2043      *  @param _disputeID The ID of the dispute.
2044      *  @return The status.
2045      */
2046     function disputeStatus(uint _disputeID) public view returns(DisputeStatus status) {
2047         Dispute storage dispute = disputes[_disputeID];
2048         if (dispute.period < Period.appeal) status = DisputeStatus.Waiting;
2049         else if (dispute.period < Period.execution) status = DisputeStatus.Appealable;
2050         else status = DisputeStatus.Solved;
2051     }
2052 
2053     /** @dev Gets the current ruling of a specified dispute.
2054      *  @param _disputeID The ID of the dispute.
2055      *  @return The current ruling.
2056      */
2057     function currentRuling(uint _disputeID) public view returns(uint ruling) {
2058         Dispute storage dispute = disputes[_disputeID];
2059         ruling = dispute.voteCounters[dispute.voteCounters.length - 1].tied ? 0
2060             : dispute.voteCounters[dispute.voteCounters.length - 1].winningChoice;
2061     }
2062 
2063     /* Internal */
2064 
2065     /** @dev Sets the specified juror's stake in a subcourt.
2066      *  `O(n + p * log_k(j))` where
2067      *  `n` is the number of subcourts the juror has staked in,
2068      *  `p` is the depth of the subcourt tree,
2069      *  `k` is the minimum number of children per node of one of these subcourts' sortition sum tree,
2070      *  and `j` is the maximum number of jurors that ever staked in one of these subcourts simultaneously.
2071      *  @param _account The address of the juror.
2072      *  @param _subcourtID The ID of the subcourt.
2073      *  @param _stake The new stake.
2074      *  @return True if the call succeeded, false otherwise.
2075      */
2076     function _setStake(address _account, uint96 _subcourtID, uint128 _stake) internal returns(bool succeeded) {
2077         // Delayed action logic.
2078         if (phase != Phase.staking) {
2079             delayedSetStakes[++lastDelayedSetStake] = DelayedSetStake({ account: _account, subcourtID: _subcourtID, stake: _stake });
2080             return true;
2081         }
2082 
2083         if (!(_stake == 0 || courts[_subcourtID].minStake <= _stake))
2084             return false; // The juror's stake cannot be lower than the minimum stake for the subcourt.
2085         Juror storage juror = jurors[_account];
2086         bytes32 stakePathID = accountAndSubcourtIDToStakePathID(_account, _subcourtID);
2087         uint currentStake = sortitionSumTrees.stakeOf(bytes32(_subcourtID), stakePathID);
2088         if (!(_stake == 0 || currentStake > 0 || juror.subcourtIDs.length < MAX_STAKE_PATHS))
2089             return false; // Maximum stake paths reached.
2090         uint newTotalStake = juror.stakedTokens - currentStake + _stake; // Can't overflow because _stake is a uint128.
2091         if (!(_stake == 0 || pinakion.balanceOf(_account) >= newTotalStake))
2092             return false; // The juror's total amount of staked tokens cannot be higher than the juror's balance.
2093 
2094         // Update juror's records.
2095         juror.stakedTokens = newTotalStake;
2096         if (_stake == 0) {
2097             for (uint i = 0; i < juror.subcourtIDs.length; i++)
2098                 if (juror.subcourtIDs[i] == _subcourtID) {
2099                     juror.subcourtIDs[i] = juror.subcourtIDs[juror.subcourtIDs.length - 1];
2100                     juror.subcourtIDs.length--;
2101                     break;
2102                 }
2103         } else if (currentStake == 0) juror.subcourtIDs.push(_subcourtID);
2104 
2105         // Update subcourt parents.
2106         bool finished = false;
2107         uint currentSubcourtID = _subcourtID;
2108         while (!finished) {
2109             sortitionSumTrees.set(bytes32(currentSubcourtID), _stake, stakePathID);
2110             if (currentSubcourtID == 0) finished = true;
2111             else currentSubcourtID = courts[currentSubcourtID].parent;
2112         }
2113         emit StakeSet(_account, _subcourtID, _stake, newTotalStake);
2114         return true;
2115     }
2116 
2117     /** @dev Gets a subcourt ID and the minimum number of jurors required from a specified extra data bytes array.
2118      *  @param _extraData The extra data bytes array. The first 32 bytes are the subcourt ID and the next 32 bytes are the minimum number of jurors.
2119      *  @return The subcourt ID and the minimum number of jurors required.
2120      */
2121     function extraDataToSubcourtIDAndMinJurors(bytes _extraData) internal view returns (uint96 subcourtID, uint minJurors) {
2122         if (_extraData.length >= 64) {
2123             assembly { // solium-disable-line security/no-inline-assembly
2124                 subcourtID := mload(add(_extraData, 0x20))
2125                 minJurors := mload(add(_extraData, 0x40))
2126             }
2127             if (subcourtID >= courts.length) subcourtID = 0;
2128             if (minJurors == 0) minJurors = MIN_JURORS;
2129         } else {
2130             subcourtID = 0;
2131             minJurors = MIN_JURORS;
2132         }
2133     }
2134 
2135     /** @dev Packs an account and a subcourt ID into a stake path ID.
2136      *  @param _account The account to pack.
2137      *  @param _subcourtID The subcourt ID to pack.
2138      *  @return The stake path ID.
2139      */
2140     function accountAndSubcourtIDToStakePathID(address _account, uint96 _subcourtID) internal pure returns (bytes32 stakePathID) {
2141         assembly { // solium-disable-line security/no-inline-assembly
2142             let ptr := mload(0x40)
2143             for { let i := 0x00 } lt(i, 0x14) { i := add(i, 0x01) } {
2144                 mstore8(add(ptr, i), byte(add(0x0c, i), _account))
2145             }
2146             for { let i := 0x14 } lt(i, 0x20) { i := add(i, 0x01) } {
2147                 mstore8(add(ptr, i), byte(i, _subcourtID))
2148             }
2149             stakePathID := mload(ptr)
2150         }
2151     }
2152 
2153     /** @dev Unpacks a stake path ID into an account and a subcourt ID.
2154      *  @param _stakePathID The stake path ID to unpack.
2155      *  @return The account and subcourt ID.
2156      */
2157     function stakePathIDToAccountAndSubcourtID(bytes32 _stakePathID) internal pure returns (address account, uint96 subcourtID) {
2158         assembly { // solium-disable-line security/no-inline-assembly
2159             let ptr := mload(0x40)
2160             for { let i := 0x00 } lt(i, 0x14) { i := add(i, 0x01) } {
2161                 mstore8(add(add(ptr, 0x0c), i), byte(i, _stakePathID))
2162             }
2163             account := mload(ptr)
2164             subcourtID := _stakePathID
2165         }
2166     }
2167     
2168     /* Interface Views */
2169 
2170     /** @dev Gets a specified subcourt's non primitive properties.
2171      *  @param _subcourtID The ID of the subcourt.
2172      *  @return The subcourt's non primitive properties.
2173      */
2174     function getSubcourt(uint96 _subcourtID) external view returns(
2175         uint[] children,
2176         uint[4] timesPerPeriod
2177     ) {
2178         Court storage subcourt = courts[_subcourtID];
2179         children = subcourt.children;
2180         timesPerPeriod = subcourt.timesPerPeriod;
2181     }
2182 
2183     /** @dev Gets a specified vote for a specified appeal in a specified dispute.
2184      *  @param _disputeID The ID of the dispute.
2185      *  @param _appeal The appeal.
2186      *  @param _voteID The ID of the vote.
2187      *  @return The vote.
2188      */
2189     function getVote(uint _disputeID, uint _appeal, uint _voteID) external view returns(
2190         address account,
2191         bytes32 commit,
2192         uint choice,
2193         bool voted
2194     ) {
2195         Vote storage vote = disputes[_disputeID].votes[_appeal][_voteID];
2196         account = vote.account;
2197         commit = vote.commit;
2198         choice = vote.choice;
2199         voted = vote.voted;
2200     }
2201 
2202     /** @dev Gets the vote counter for a specified appeal in a specified dispute.
2203      *  Note: This function is only to be used by the interface and it won't work if the number of choices is too high.
2204      *  @param _disputeID The ID of the dispute.
2205      *  @param _appeal The appeal.
2206      *  @return The vote counter.
2207      *  `O(n)` where
2208      *  `n` is the number of choices of the dispute.
2209      */
2210     function getVoteCounter(uint _disputeID, uint _appeal) external view returns(
2211         uint winningChoice,
2212         uint[] counts,
2213         bool tied
2214     ) {
2215         Dispute storage dispute = disputes[_disputeID];
2216         VoteCounter storage voteCounter = dispute.voteCounters[_appeal];
2217         winningChoice = voteCounter.winningChoice;
2218         counts = new uint[](dispute.numberOfChoices + 1);
2219         for (uint i = 0; i <= dispute.numberOfChoices; i++) counts[i] = voteCounter.counts[i];
2220         tied = voteCounter.tied;
2221     }
2222 
2223     /** @dev Gets a specified dispute's non primitive properties.
2224      *  @param _disputeID The ID of the dispute.
2225      *  @return The dispute's non primitive properties.
2226      *  `O(a)` where
2227      *  `a` is the number of appeals of the dispute.
2228      */
2229     function getDispute(uint _disputeID) external view returns(
2230         uint[] votesLengths,
2231         uint[] tokensAtStakePerJuror,
2232         uint[] totalFeesForJurors,
2233         uint[] votesInEachRound,
2234         uint[] repartitionsInEachRound,
2235         uint[] penaltiesInEachRound
2236     ) {
2237         Dispute storage dispute = disputes[_disputeID];
2238         votesLengths = new uint[](dispute.votes.length);
2239         for (uint i = 0; i < dispute.votes.length; i++) votesLengths[i] = dispute.votes[i].length;
2240         tokensAtStakePerJuror = dispute.tokensAtStakePerJuror;
2241         totalFeesForJurors = dispute.totalFeesForJurors;
2242         votesInEachRound = dispute.votesInEachRound;
2243         repartitionsInEachRound = dispute.repartitionsInEachRound;
2244         penaltiesInEachRound = dispute.penaltiesInEachRound;
2245     }
2246 
2247     /** @dev Gets a specified juror's non primitive properties.
2248      *  @param _account The address of the juror.
2249      *  @return The juror's non primitive properties.
2250      */
2251     function getJuror(address _account) external view returns(
2252         uint96[] subcourtIDs
2253     ) {
2254         Juror storage juror = jurors[_account];
2255         subcourtIDs = juror.subcourtIDs;
2256     }
2257 
2258     /** @dev Gets the stake of a specified juror in a specified subcourt.
2259      *  @param _account The address of the juror.
2260      *  @param _subcourtID The ID of the subcourt.
2261      *  @return The stake.
2262      */
2263     function stakeOf(address _account, uint96 _subcourtID) external view returns(uint stake) {
2264         return sortitionSumTrees.stakeOf(bytes32(_subcourtID), accountAndSubcourtIDToStakePathID(_account, _subcourtID));
2265     }
2266 }