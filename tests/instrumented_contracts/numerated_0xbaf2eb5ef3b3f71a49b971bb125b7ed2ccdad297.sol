1 pragma solidity ^0.4.24;
2 
3 
4 /** @title PEpsilonLastRound
5  *  @author based on a contract by Daniel Babbev, modified by William George
6  *
7  *  This contract implements a p + epsilon attack against the Kleros court where the bribe is only offered to jurors in the last appeal round.
8  *  The attack is described by VitaliK Buterin here: https://blog.ethereum.org/2015/01/28/p-epsilon-attack/
9  */
10 contract PEpsilon {
11   Pinakion public pinakion;
12   Kleros public court;
13    uint public balance;
14   uint public disputeID;
15   uint public desiredOutcome;
16   uint public epsilon;
17   bool public settled;
18   uint public maxAppeals; // The maximum number of appeals this cotracts promises to pay
19   mapping (address => uint) public withdraw; // We'll use a withdraw pattern here to avoid multiple sends when a juror has voted multiple times.
20    address public attacker;
21   uint public remainingWithdraw; // Here we keep the total amount bribed jurors have available for withdraw.
22    modifier onlyBy(address _account) {require(msg.sender == _account); _;}
23    event AmountShift(uint val, uint epsilon ,address juror);
24   event Log(uint val, address addr, string message);
25    /** @dev Constructor.
26    *  @param _pinakion The PNK contract.
27    *  @param _kleros   The Kleros court.
28    *  @param _disputeID The dispute we are targeting.
29    *  @param _desiredOutcome The desired ruling of the dispute.
30    *  @param _epsilon  Jurors will be paid epsilon more for voting for the desiredOutcome.
31    *  @param _maxAppeals The maximum number of appeals this contract promises to pay out
32    */
33   constructor(Pinakion _pinakion, Kleros _kleros, uint _disputeID, uint _desiredOutcome, uint _epsilon, uint _maxAppeals) public {
34     pinakion = _pinakion;
35     court = _kleros;
36     disputeID = _disputeID;
37     desiredOutcome = _desiredOutcome;
38     epsilon = _epsilon;
39     attacker = msg.sender;
40     maxAppeals = _maxAppeals;
41   }
42    /** @dev Callback of approveAndCall - transfer pinakions in the contract. Should be called by the pinakion contract. TRUSTED.
43    *  The attacker has to deposit sufficiently large amount of PNK to cover the payouts to the jurors.
44    *  @param _from The address making the transfer.
45    *  @param _amount Amount of tokens to transfer to this contract (in basic units).
46    */
47   function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
48     require(pinakion.transferFrom(_from, this, _amount));
49      balance += _amount;
50   }
51    /** @dev Jurors can withdraw their PNK from here
52    */
53   function withdrawJuror() {
54     withdrawSelect(msg.sender);
55   }
56    /** @dev Withdraw the funds of a given juror
57    *  @param _juror The address of the juror
58    */
59   function withdrawSelect(address _juror) {
60     uint amount = withdraw[_juror];
61     withdraw[_juror] = 0;
62      balance = sub(balance, amount); // Could underflow
63     remainingWithdraw = sub(remainingWithdraw, amount);
64      // The juror receives d + p + e (deposit + p + epsilon)
65     require(pinakion.transfer(_juror, amount));
66   }
67    /**
68   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
69   */
70   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
71     assert(_b <= _a);
72     return _a - _b;
73   }
74    /** @dev The attacker can withdraw their PNK from here after the bribe has been settled.
75    */
76   function withdrawAttacker(){
77     require(settled);
78      if (balance > remainingWithdraw) {
79       // The remaning balance of PNK after settlement is transfered to the attacker.
80       uint amount = balance - remainingWithdraw;
81       balance = remainingWithdraw;
82        require(pinakion.transfer(attacker, amount));
83     }
84   }
85    /** @dev Settles the p + e bribe with the jurors.
86    * If the dispute is ruled differently from desiredOutcome:
87    *    The jurors who voted for desiredOutcome receive p + d + e in rewards from this contract.
88    * If the dispute is ruled as in desiredOutcome:
89    *    The jurors don't receive anything from this contract.
90    */
91   function settle() public {
92     require(court.disputeStatus(disputeID) ==  Arbitrator.DisputeStatus.Solved); // The case must be solved.
93     require(!settled); // This function can be executed only once.
94      settled = true; // settle the bribe
95      // From the dispute we get the # of appeals and the available choices
96     var (, , appeals, choices, , , ,) = court.disputes(disputeID);
97      if (court.currentRuling(disputeID) != desiredOutcome){
98       // Calculate the redistribution amounts.
99       uint amountShift = court.getStakePerDraw();
100       uint winningChoice = court.getWinningChoice(disputeID, appeals);
101        // Rewards are calculated as per the one shot token reparation.
102       uint lastRound = (appeals > maxAppeals ? maxAppeals : appeals);
103        // Note that we don't check if the result was a tie becuse we are getting a funny compiler error: "stack is too deep" if we check.
104       // TODO: Account for ties
105       if (winningChoice != 0){
106         // votesLen is the length of the votes per each appeal. There is no getter function for that, so we have to calculate it here.
107         // We must end up with the exact same value as if we would have called dispute.votes[lastRound].length
108         uint votesLen = 0;
109         for (uint c = 0; c <= choices; c++) { // Iterate for each choice of the dispute.
110           votesLen += court.getVoteCount(disputeID, lastRound, c);
111         }
112          emit Log(amountShift, 0x0 ,"stakePerDraw");
113         emit Log(votesLen, 0x0, "votesLen");
114          uint totalToRedistribute = 0;
115         uint nbCoherent = 0;
116          // Now we will use votesLen as a substitute for dispute.votes[lastRound].length
117         for (uint j=0; j < votesLen; j++){
118           uint voteRuling = court.getVoteRuling(disputeID, lastRound, j);
119           address voteAccount = court.getVoteAccount(disputeID, lastRound, j);
120            emit Log(voteRuling, voteAccount, "voted");
121            if (voteRuling != winningChoice){
122             totalToRedistribute += amountShift;
123              if (voteRuling == desiredOutcome){ // If the juror voted as we desired.
124               // Transfer this juror back the penalty.
125               withdraw[voteAccount] += amountShift + epsilon;
126               remainingWithdraw += amountShift + epsilon;
127               emit AmountShift(amountShift, epsilon, voteAccount);
128             }
129           } else {
130             nbCoherent++;
131           }
132         }
133         // toRedistribute is the amount each juror received when he voted coherently.
134         uint toRedistribute = (totalToRedistribute - amountShift) / (nbCoherent + 1);
135          // We use votesLen again as a substitute for dispute.votes[lastRound].length
136         for (j = 0; j < votesLen; j++){
137           voteRuling = court.getVoteRuling(disputeID, lastRound, j);
138           voteAccount = court.getVoteAccount(disputeID, lastRound, j);
139            if (voteRuling == desiredOutcome){
140             // Add the coherent juror reward to the total payout.
141             withdraw[voteAccount] += toRedistribute;
142             remainingWithdraw += toRedistribute;
143             emit AmountShift(toRedistribute, 0, voteAccount);
144           }
145         }
146       }
147     }
148   }
149 }
150 
151 /**
152  *  @title Kleros
153  *  @author Clément Lesaege - <clement@lesaege.com>
154  *  This code implements a simple version of Kleros.
155  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
156  */
157 
158 pragma solidity ^0.4.24;
159 
160 
161 contract ApproveAndCallFallBack {
162     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
163 }
164 
165 /// @dev The token controller contract must implement these functions
166 contract TokenController {
167     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
168     /// @param _owner The address that sent the ether to create tokens
169     /// @return True if the ether is accepted, false if it throws
170     function proxyPayment(address _owner) public payable returns(bool);
171 
172     /// @notice Notifies the controller about a token transfer allowing the
173     ///  controller to react if desired
174     /// @param _from The origin of the transfer
175     /// @param _to The destination of the transfer
176     /// @param _amount The amount of the transfer
177     /// @return False if the controller does not authorize the transfer
178     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
179 
180     /// @notice Notifies the controller about an approval allowing the
181     ///  controller to react if desired
182     /// @param _owner The address that calls `approve()`
183     /// @param _spender The spender in the `approve()` call
184     /// @param _amount The amount in the `approve()` call
185     /// @return False if the controller does not authorize the approval
186     function onApprove(address _owner, address _spender, uint _amount) public
187         returns(bool);
188 }
189 
190 contract Controlled {
191     /// @notice The address of the controller is the only address that can call
192     ///  a function with this modifier
193     modifier onlyController { require(msg.sender == controller); _; }
194 
195     address public controller;
196 
197     function Controlled() public { controller = msg.sender;}
198 
199     /// @notice Changes the controller of the contract
200     /// @param _newController The new controller of the contract
201     function changeController(address _newController) public onlyController {
202         controller = _newController;
203     }
204 }
205 
206 /// @dev The actual token contract, the default controller is the msg.sender
207 ///  that deploys the contract, so usually this token will be deployed by a
208 ///  token controller contract, which Giveth will call a "Campaign"
209 contract Pinakion is Controlled {
210 
211     string public name;                //The Token's name: e.g. DigixDAO Tokens
212     uint8 public decimals;             //Number of decimals of the smallest unit
213     string public symbol;              //An identifier: e.g. REP
214     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
215 
216 
217     /// @dev `Checkpoint` is the structure that attaches a block number to a
218     ///  given value, the block number attached is the one that last changed the
219     ///  value
220     struct  Checkpoint {
221 
222         // `fromBlock` is the block number that the value was generated from
223         uint128 fromBlock;
224 
225         // `value` is the amount of tokens at a specific block number
226         uint128 value;
227     }
228 
229     // `parentToken` is the Token address that was cloned to produce this token;
230     //  it will be 0x0 for a token that was not cloned
231     Pinakion public parentToken;
232 
233     // `parentSnapShotBlock` is the block number from the Parent Token that was
234     //  used to determine the initial distribution of the Clone Token
235     uint public parentSnapShotBlock;
236 
237     // `creationBlock` is the block number that the Clone Token was created
238     uint public creationBlock;
239 
240     // `balances` is the map that tracks the balance of each address, in this
241     //  contract when the balance changes the block number that the change
242     //  occurred is also included in the map
243     mapping (address => Checkpoint[]) balances;
244 
245     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
246     mapping (address => mapping (address => uint256)) allowed;
247 
248     // Tracks the history of the `totalSupply` of the token
249     Checkpoint[] totalSupplyHistory;
250 
251     // Flag that determines if the token is transferable or not.
252     bool public transfersEnabled;
253 
254     // The factory used to create new clone tokens
255     MiniMeTokenFactory public tokenFactory;
256 
257 ////////////////
258 // Constructor
259 ////////////////
260 
261     /// @notice Constructor to create a Pinakion
262     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
263     ///  will create the Clone token contracts, the token factory needs to be
264     ///  deployed first
265     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
266     ///  new token
267     /// @param _parentSnapShotBlock Block of the parent token that will
268     ///  determine the initial distribution of the clone token, set to 0 if it
269     ///  is a new token
270     /// @param _tokenName Name of the new token
271     /// @param _decimalUnits Number of decimals of the new token
272     /// @param _tokenSymbol Token Symbol for the new token
273     /// @param _transfersEnabled If true, tokens will be able to be transferred
274     function Pinakion(
275         address _tokenFactory,
276         address _parentToken,
277         uint _parentSnapShotBlock,
278         string _tokenName,
279         uint8 _decimalUnits,
280         string _tokenSymbol,
281         bool _transfersEnabled
282     ) public {
283         tokenFactory = MiniMeTokenFactory(_tokenFactory);
284         name = _tokenName;                                 // Set the name
285         decimals = _decimalUnits;                          // Set the decimals
286         symbol = _tokenSymbol;                             // Set the symbol
287         parentToken = Pinakion(_parentToken);
288         parentSnapShotBlock = _parentSnapShotBlock;
289         transfersEnabled = _transfersEnabled;
290         creationBlock = block.number;
291     }
292 
293 
294 ///////////////////
295 // ERC20 Methods
296 ///////////////////
297 
298     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
299     /// @param _to The address of the recipient
300     /// @param _amount The amount of tokens to be transferred
301     /// @return Whether the transfer was successful or not
302     function transfer(address _to, uint256 _amount) public returns (bool success) {
303         require(transfersEnabled);
304         doTransfer(msg.sender, _to, _amount);
305         return true;
306     }
307 
308     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
309     ///  is approved by `_from`
310     /// @param _from The address holding the tokens being transferred
311     /// @param _to The address of the recipient
312     /// @param _amount The amount of tokens to be transferred
313     /// @return True if the transfer was successful
314     function transferFrom(address _from, address _to, uint256 _amount
315     ) public returns (bool success) {
316 
317         // The controller of this contract can move tokens around at will,
318         //  this is important to recognize! Confirm that you trust the
319         //  controller of this contract, which in most situations should be
320         //  another open source smart contract or 0x0
321         if (msg.sender != controller) {
322             require(transfersEnabled);
323 
324             // The standard ERC 20 transferFrom functionality
325             require(allowed[_from][msg.sender] >= _amount);
326             allowed[_from][msg.sender] -= _amount;
327         }
328         doTransfer(_from, _to, _amount);
329         return true;
330     }
331 
332     /// @dev This is the actual transfer function in the token contract, it can
333     ///  only be called by other functions in this contract.
334     /// @param _from The address holding the tokens being transferred
335     /// @param _to The address of the recipient
336     /// @param _amount The amount of tokens to be transferred
337     /// @return True if the transfer was successful
338     function doTransfer(address _from, address _to, uint _amount
339     ) internal {
340 
341            if (_amount == 0) {
342                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
343                return;
344            }
345 
346            require(parentSnapShotBlock < block.number);
347 
348            // Do not allow transfer to 0x0 or the token contract itself
349            require((_to != 0) && (_to != address(this)));
350 
351            // If the amount being transfered is more than the balance of the
352            //  account the transfer throws
353            var previousBalanceFrom = balanceOfAt(_from, block.number);
354 
355            require(previousBalanceFrom >= _amount);
356 
357            // Alerts the token controller of the transfer
358            if (isContract(controller)) {
359                require(TokenController(controller).onTransfer(_from, _to, _amount));
360            }
361 
362            // First update the balance array with the new value for the address
363            //  sending the tokens
364            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
365 
366            // Then update the balance array with the new value for the address
367            //  receiving the tokens
368            var previousBalanceTo = balanceOfAt(_to, block.number);
369            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
370            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
371 
372            // An event to make the transfer easy to find on the blockchain
373            Transfer(_from, _to, _amount);
374 
375     }
376 
377     /// @param _owner The address that's balance is being requested
378     /// @return The balance of `_owner` at the current block
379     function balanceOf(address _owner) public constant returns (uint256 balance) {
380         return balanceOfAt(_owner, block.number);
381     }
382 
383     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
384     ///  its behalf. This is the standard version to allow backward compatibility.
385     /// @param _spender The address of the account able to transfer the tokens
386     /// @param _amount The amount of tokens to be approved for transfer
387     /// @return True if the approval was successful
388     function approve(address _spender, uint256 _amount) public returns (bool success) {
389         require(transfersEnabled);
390 
391         // Alerts the token controller of the approve function call
392         if (isContract(controller)) {
393             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
394         }
395 
396         allowed[msg.sender][_spender] = _amount;
397         Approval(msg.sender, _spender, _amount);
398         return true;
399     }
400 
401     /// @dev This function makes it easy to read the `allowed[]` map
402     /// @param _owner The address of the account that owns the token
403     /// @param _spender The address of the account able to transfer the tokens
404     /// @return Amount of remaining tokens of _owner that _spender is allowed
405     ///  to spend
406     function allowance(address _owner, address _spender
407     ) public constant returns (uint256 remaining) {
408         return allowed[_owner][_spender];
409     }
410 
411     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
412     ///  its behalf, and then a function is triggered in the contract that is
413     ///  being approved, `_spender`. This allows users to use their tokens to
414     ///  interact with contracts in one function call instead of two
415     /// @param _spender The address of the contract able to transfer the tokens
416     /// @param _amount The amount of tokens to be approved for transfer
417     /// @return True if the function call was successful
418     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
419     ) public returns (bool success) {
420         require(approve(_spender, _amount));
421 
422         ApproveAndCallFallBack(_spender).receiveApproval(
423             msg.sender,
424             _amount,
425             this,
426             _extraData
427         );
428 
429         return true;
430     }
431 
432     /// @dev This function makes it easy to get the total number of tokens
433     /// @return The total number of tokens
434     function totalSupply() public constant returns (uint) {
435         return totalSupplyAt(block.number);
436     }
437 
438 
439 ////////////////
440 // Query balance and totalSupply in History
441 ////////////////
442 
443     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
444     /// @param _owner The address from which the balance will be retrieved
445     /// @param _blockNumber The block number when the balance is queried
446     /// @return The balance at `_blockNumber`
447     function balanceOfAt(address _owner, uint _blockNumber) public constant
448         returns (uint) {
449 
450         // These next few lines are used when the balance of the token is
451         //  requested before a check point was ever created for this token, it
452         //  requires that the `parentToken.balanceOfAt` be queried at the
453         //  genesis block for that token as this contains initial balance of
454         //  this token
455         if ((balances[_owner].length == 0)
456             || (balances[_owner][0].fromBlock > _blockNumber)) {
457             if (address(parentToken) != 0) {
458                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
459             } else {
460                 // Has no parent
461                 return 0;
462             }
463 
464         // This will return the expected balance during normal situations
465         } else {
466             return getValueAt(balances[_owner], _blockNumber);
467         }
468     }
469 
470     /// @notice Total amount of tokens at a specific `_blockNumber`.
471     /// @param _blockNumber The block number when the totalSupply is queried
472     /// @return The total amount of tokens at `_blockNumber`
473     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
474 
475         // These next few lines are used when the totalSupply of the token is
476         //  requested before a check point was ever created for this token, it
477         //  requires that the `parentToken.totalSupplyAt` be queried at the
478         //  genesis block for this token as that contains totalSupply of this
479         //  token at this block number.
480         if ((totalSupplyHistory.length == 0)
481             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
482             if (address(parentToken) != 0) {
483                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
484             } else {
485                 return 0;
486             }
487 
488         // This will return the expected totalSupply during normal situations
489         } else {
490             return getValueAt(totalSupplyHistory, _blockNumber);
491         }
492     }
493 
494 ////////////////
495 // Clone Token Method
496 ////////////////
497 
498     /// @notice Creates a new clone token with the initial distribution being
499     ///  this token at `_snapshotBlock`
500     /// @param _cloneTokenName Name of the clone token
501     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
502     /// @param _cloneTokenSymbol Symbol of the clone token
503     /// @param _snapshotBlock Block when the distribution of the parent token is
504     ///  copied to set the initial distribution of the new clone token;
505     ///  if the block is zero than the actual block, the current block is used
506     /// @param _transfersEnabled True if transfers are allowed in the clone
507     /// @return The address of the new MiniMeToken Contract
508     function createCloneToken(
509         string _cloneTokenName,
510         uint8 _cloneDecimalUnits,
511         string _cloneTokenSymbol,
512         uint _snapshotBlock,
513         bool _transfersEnabled
514         ) public returns(address) {
515         if (_snapshotBlock == 0) _snapshotBlock = block.number;
516         Pinakion cloneToken = tokenFactory.createCloneToken(
517             this,
518             _snapshotBlock,
519             _cloneTokenName,
520             _cloneDecimalUnits,
521             _cloneTokenSymbol,
522             _transfersEnabled
523             );
524 
525         cloneToken.changeController(msg.sender);
526 
527         // An event to make the token easy to find on the blockchain
528         NewCloneToken(address(cloneToken), _snapshotBlock);
529         return address(cloneToken);
530     }
531 
532 ////////////////
533 // Generate and destroy tokens
534 ////////////////
535 
536     /// @notice Generates `_amount` tokens that are assigned to `_owner`
537     /// @param _owner The address that will be assigned the new tokens
538     /// @param _amount The quantity of tokens generated
539     /// @return True if the tokens are generated correctly
540     function generateTokens(address _owner, uint _amount
541     ) public onlyController returns (bool) {
542         uint curTotalSupply = totalSupply();
543         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
544         uint previousBalanceTo = balanceOf(_owner);
545         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
546         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
547         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
548         Transfer(0, _owner, _amount);
549         return true;
550     }
551 
552 
553     /// @notice Burns `_amount` tokens from `_owner`
554     /// @param _owner The address that will lose the tokens
555     /// @param _amount The quantity of tokens to burn
556     /// @return True if the tokens are burned correctly
557     function destroyTokens(address _owner, uint _amount
558     ) onlyController public returns (bool) {
559         uint curTotalSupply = totalSupply();
560         require(curTotalSupply >= _amount);
561         uint previousBalanceFrom = balanceOf(_owner);
562         require(previousBalanceFrom >= _amount);
563         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
564         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
565         Transfer(_owner, 0, _amount);
566         return true;
567     }
568 
569 ////////////////
570 // Enable tokens transfers
571 ////////////////
572 
573 
574     /// @notice Enables token holders to transfer their tokens freely if true
575     /// @param _transfersEnabled True if transfers are allowed in the clone
576     function enableTransfers(bool _transfersEnabled) public onlyController {
577         transfersEnabled = _transfersEnabled;
578     }
579 
580 ////////////////
581 // Internal helper functions to query and set a value in a snapshot array
582 ////////////////
583 
584     /// @dev `getValueAt` retrieves the number of tokens at a given block number
585     /// @param checkpoints The history of values being queried
586     /// @param _block The block number to retrieve the value at
587     /// @return The number of tokens being queried
588     function getValueAt(Checkpoint[] storage checkpoints, uint _block
589     ) constant internal returns (uint) {
590         if (checkpoints.length == 0) return 0;
591 
592         // Shortcut for the actual value
593         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
594             return checkpoints[checkpoints.length-1].value;
595         if (_block < checkpoints[0].fromBlock) return 0;
596 
597         // Binary search of the value in the array
598         uint min = 0;
599         uint max = checkpoints.length-1;
600         while (max > min) {
601             uint mid = (max + min + 1)/ 2;
602             if (checkpoints[mid].fromBlock<=_block) {
603                 min = mid;
604             } else {
605                 max = mid-1;
606             }
607         }
608         return checkpoints[min].value;
609     }
610 
611     /// @dev `updateValueAtNow` used to update the `balances` map and the
612     ///  `totalSupplyHistory`
613     /// @param checkpoints The history of data being updated
614     /// @param _value The new number of tokens
615     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
616     ) internal  {
617         if ((checkpoints.length == 0)
618         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
619                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
620                newCheckPoint.fromBlock =  uint128(block.number);
621                newCheckPoint.value = uint128(_value);
622            } else {
623                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
624                oldCheckPoint.value = uint128(_value);
625            }
626     }
627 
628     /// @dev Internal function to determine if an address is a contract
629     /// @param _addr The address being queried
630     /// @return True if `_addr` is a contract
631     function isContract(address _addr) constant internal returns(bool) {
632         uint size;
633         if (_addr == 0) return false;
634         assembly {
635             size := extcodesize(_addr)
636         }
637         return size>0;
638     }
639 
640     /// @dev Helper function to return a min betwen the two uints
641     function min(uint a, uint b) pure internal returns (uint) {
642         return a < b ? a : b;
643     }
644 
645     /// @notice The fallback function: If the contract's controller has not been
646     ///  set to 0, then the `proxyPayment` method is called which relays the
647     ///  ether and creates tokens as described in the token controller contract
648     function () public payable {
649         require(isContract(controller));
650         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
651     }
652 
653 //////////
654 // Safety Methods
655 //////////
656 
657     /// @notice This method can be used by the controller to extract mistakenly
658     ///  sent tokens to this contract.
659     /// @param _token The address of the token contract that you want to recover
660     ///  set to 0 in case you want to extract ether.
661     function claimTokens(address _token) public onlyController {
662         if (_token == 0x0) {
663             controller.transfer(this.balance);
664             return;
665         }
666 
667         Pinakion token = Pinakion(_token);
668         uint balance = token.balanceOf(this);
669         token.transfer(controller, balance);
670         ClaimedTokens(_token, controller, balance);
671     }
672 
673 ////////////////
674 // Events
675 ////////////////
676     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
677     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
678     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
679     event Approval(
680         address indexed _owner,
681         address indexed _spender,
682         uint256 _amount
683         );
684 
685 }
686 
687 
688 ////////////////
689 // MiniMeTokenFactory
690 ////////////////
691 
692 /// @dev This contract is used to generate clone contracts from a contract.
693 ///  In solidity this is the way to create a contract from a contract of the
694 ///  same class
695 contract MiniMeTokenFactory {
696 
697     /// @notice Update the DApp by creating a new token with new functionalities
698     ///  the msg.sender becomes the controller of this clone token
699     /// @param _parentToken Address of the token being cloned
700     /// @param _snapshotBlock Block of the parent token that will
701     ///  determine the initial distribution of the clone token
702     /// @param _tokenName Name of the new token
703     /// @param _decimalUnits Number of decimals of the new token
704     /// @param _tokenSymbol Token Symbol for the new token
705     /// @param _transfersEnabled If true, tokens will be able to be transferred
706     /// @return The address of the new token contract
707     function createCloneToken(
708         address _parentToken,
709         uint _snapshotBlock,
710         string _tokenName,
711         uint8 _decimalUnits,
712         string _tokenSymbol,
713         bool _transfersEnabled
714     ) public returns (Pinakion) {
715         Pinakion newToken = new Pinakion(
716             this,
717             _parentToken,
718             _snapshotBlock,
719             _tokenName,
720             _decimalUnits,
721             _tokenSymbol,
722             _transfersEnabled
723             );
724 
725         newToken.changeController(msg.sender);
726         return newToken;
727     }
728 }
729 
730 contract RNG{
731 
732     /** @dev Contribute to the reward of a random number.
733      *  @param _block Block the random number is linked to.
734      */
735     function contribute(uint _block) public payable;
736 
737     /** @dev Request a random number.
738      *  @param _block Block linked to the request.
739      */
740     function requestRN(uint _block) public payable {
741         contribute(_block);
742     }
743 
744     /** @dev Get the random number.
745      *  @param _block Block the random number is linked to.
746      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
747      */
748     function getRN(uint _block) public returns (uint RN);
749 
750     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
751      *  This is to prevent users from getting correlated numbers.
752      *  @param _block Block the random number is linked to.
753      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
754      */
755     function getUncorrelatedRN(uint _block) public returns (uint RN) {
756         uint baseRN=getRN(_block);
757         if (baseRN==0)
758             return 0;
759         else
760             return uint(keccak256(msg.sender,baseRN));
761     }
762 
763  }
764 
765 /** Simple Random Number Generator returning the blockhash.
766  *  Allows saving the random number for use in the future.
767  *  It allows the contract to still access the blockhash even after 256 blocks.
768  *  The first party to call the save function gets the reward.
769  */
770 contract BlockHashRNG is RNG {
771 
772     mapping (uint => uint) public randomNumber; // randomNumber[block] is the random number for this block, 0 otherwise.
773     mapping (uint => uint) public reward; // reward[block] is the amount to be paid to the party w.
774 
775 
776 
777     /** @dev Contribute to the reward of a random number.
778      *  @param _block Block the random number is linked to.
779      */
780     function contribute(uint _block) public payable { reward[_block]+=msg.value; }
781 
782 
783     /** @dev Return the random number. If it has not been saved and is still computable compute it.
784      *  @param _block Block the random number is linked to.
785      *  @return RN Random Number. If the number is not ready or has not been requested 0 instead.
786      */
787     function getRN(uint _block) public returns (uint RN) {
788         RN=randomNumber[_block];
789         if (RN==0){
790             saveRN(_block);
791             return randomNumber[_block];
792         }
793         else
794             return RN;
795     }
796 
797     /** @dev Save the random number for this blockhash and give the reward to the caller.
798      *  @param _block Block the random number is linked to.
799      */
800     function saveRN(uint _block) public {
801         if (blockhash(_block) != 0x0)
802             randomNumber[_block] = uint(blockhash(_block));
803         if (randomNumber[_block] != 0) { // If the number is set.
804             uint rewardToSend = reward[_block];
805             reward[_block] = 0;
806             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
807         }
808     }
809 
810 }
811 
812 
813 /** Random Number Generator returning the blockhash with a backup behaviour.
814  *  Allows saving the random number for use in the future. 
815  *  It allows the contract to still access the blockhash even after 256 blocks.
816  *  The first party to call the save function gets the reward.
817  *  If no one calls the contract within 256 blocks, the contract fallback in returning the blockhash of the previous block.
818  */
819 contract BlockHashRNGFallback is BlockHashRNG {
820     
821     /** @dev Save the random number for this blockhash and give the reward to the caller.
822      *  @param _block Block the random number is linked to.
823      */
824     function saveRN(uint _block) public {
825         if (_block<block.number && randomNumber[_block]==0) {// If the random number is not already set and can be.
826             if (blockhash(_block)!=0x0) // Normal case.
827                 randomNumber[_block]=uint(blockhash(_block));
828             else // The contract was not called in time. Fallback to returning previous blockhash.
829                 randomNumber[_block]=uint(blockhash(block.number-1));
830         }
831         if (randomNumber[_block] != 0) { // If the random number is set.
832             uint rewardToSend=reward[_block];
833             reward[_block]=0;
834             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case the msg.sender has a fallback issue.
835         }
836     }
837     
838 }
839 
840 /** @title Arbitrable
841  *  Arbitrable abstract contract.
842  *  When developing arbitrable contracts, we need to:
843  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
844  *  -Allow dispute creation. For this a function must:
845  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
846  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
847  */
848 contract Arbitrable{
849     Arbitrator public arbitrator;
850     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
851 
852     modifier onlyArbitrator {require(msg.sender==address(arbitrator)); _;}
853 
854     /** @dev To be raised when a ruling is given.
855      *  @param _arbitrator The arbitrator giving the ruling.
856      *  @param _disputeID ID of the dispute in the Arbitrator contract.
857      *  @param _ruling The ruling which was given.
858      */
859     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
860 
861     /** @dev To be emmited when meta-evidence is submitted.
862      *  @param _metaEvidenceID Unique identifier of meta-evidence.
863      *  @param _evidence A link to the meta-evidence JSON.
864      */
865     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
866 
867     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
868      *  @param _arbitrator The arbitrator of the contract.
869      *  @param _disputeID ID of the dispute in the Arbitrator contract.
870      *  @param _metaEvidenceID Unique identifier of meta-evidence.
871      */
872     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID);
873 
874     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
875      *  @param _arbitrator The arbitrator of the contract.
876      *  @param _disputeID ID of the dispute in the Arbitrator contract.
877      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
878      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
879      */
880     event Evidence(Arbitrator indexed _arbitrator, uint indexed _disputeID, address _party, string _evidence);
881 
882     /** @dev Constructor. Choose the arbitrator.
883      *  @param _arbitrator The arbitrator of the contract.
884      *  @param _arbitratorExtraData Extra data for the arbitrator.
885      */
886     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
887         arbitrator = _arbitrator;
888         arbitratorExtraData = _arbitratorExtraData;
889     }
890 
891     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
892      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
893      *  @param _disputeID ID of the dispute in the Arbitrator contract.
894      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
895      */
896     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
897         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
898 
899         executeRuling(_disputeID,_ruling);
900     }
901 
902 
903     /** @dev Execute a ruling of a dispute.
904      *  @param _disputeID ID of the dispute in the Arbitrator contract.
905      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
906      */
907     function executeRuling(uint _disputeID, uint _ruling) internal;
908 }
909 
910 /** @title Arbitrator
911  *  Arbitrator abstract contract.
912  *  When developing arbitrator contracts we need to:
913  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
914  *  -Define the functions for cost display (arbitrationCost and appealCost).
915  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
916  */
917 contract Arbitrator{
918 
919     enum DisputeStatus {Waiting, Appealable, Solved}
920 
921     modifier requireArbitrationFee(bytes _extraData) {require(msg.value>=arbitrationCost(_extraData)); _;}
922     modifier requireAppealFee(uint _disputeID, bytes _extraData) {require(msg.value>=appealCost(_disputeID, _extraData)); _;}
923 
924     /** @dev To be raised when a dispute can be appealed.
925      *  @param _disputeID ID of the dispute.
926      */
927     event AppealPossible(uint _disputeID);
928 
929     /** @dev To be raised when a dispute is created.
930      *  @param _disputeID ID of the dispute.
931      *  @param _arbitrable The contract which created the dispute.
932      */
933     event DisputeCreation(uint indexed _disputeID, Arbitrable _arbitrable);
934 
935     /** @dev To be raised when the current ruling is appealed.
936      *  @param _disputeID ID of the dispute.
937      *  @param _arbitrable The contract which created the dispute.
938      */
939     event AppealDecision(uint indexed _disputeID, Arbitrable _arbitrable);
940 
941     /** @dev Create a dispute. Must be called by the arbitrable contract.
942      *  Must be paid at least arbitrationCost(_extraData).
943      *  @param _choices Amount of choices the arbitrator can make in this dispute.
944      *  @param _extraData Can be used to give additional info on the dispute to be created.
945      *  @return disputeID ID of the dispute created.
946      */
947     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID)  {}
948 
949     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
950      *  @param _extraData Can be used to give additional info on the dispute to be created.
951      *  @return fee Amount to be paid.
952      */
953     function arbitrationCost(bytes _extraData) public constant returns(uint fee);
954 
955     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
956      *  @param _disputeID ID of the dispute to be appealed.
957      *  @param _extraData Can be used to give extra info on the appeal.
958      */
959     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
960         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
961     }
962 
963     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
964      *  @param _disputeID ID of the dispute to be appealed.
965      *  @param _extraData Can be used to give additional info on the dispute to be created.
966      *  @return fee Amount to be paid.
967      */
968     function appealCost(uint _disputeID, bytes _extraData) public constant returns(uint fee);
969 
970     /** @dev Return the status of a dispute.
971      *  @param _disputeID ID of the dispute to rule.
972      *  @return status The status of the dispute.
973      */
974     function disputeStatus(uint _disputeID) public constant returns(DisputeStatus status);
975 
976     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
977      *  @param _disputeID ID of the dispute.
978      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
979      */
980     function currentRuling(uint _disputeID) public constant returns(uint ruling);
981 
982 }
983 
984 
985 
986 contract Kleros is Arbitrator, ApproveAndCallFallBack {
987 
988     // **************************** //
989     // *    Contract variables    * //
990     // **************************** //
991 
992     // Variables which should not change after initialization.
993     Pinakion public pinakion;
994     uint public constant NON_PAYABLE_AMOUNT = (2**256 - 2) / 2; // An astronomic amount, practically can't be paid.
995 
996     // Variables which will subject to the governance mechanism.
997     // Note they will only be able to be changed during the activation period (because a session assumes they don't change after it).
998     RNG public rng; // Random Number Generator used to draw jurors.
999     uint public arbitrationFeePerJuror = 0.05 ether; // The fee which will be paid to each juror.
1000     uint16 public defaultNumberJuror = 3; // Number of drawn jurors unless specified otherwise.
1001     uint public minActivatedToken = 0.1 * 1e18; // Minimum of tokens to be activated (in basic units).
1002     uint[5] public timePerPeriod; // The minimum time each period lasts (seconds).
1003     uint public alpha = 2000; // alpha in ‱ (1 / 10 000).
1004     uint constant ALPHA_DIVISOR = 1e4; // Amount we need to divided alpha in ‱ to get the float value of alpha.
1005     uint public maxAppeals = 5; // Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1006     // Initially, the governor will be an address controlled by the Kleros team. At a later stage,
1007     // the governor will be switched to a governance contract with liquid voting.
1008     address public governor; // Address of the governor contract.
1009 
1010     // Variables changing during day to day interaction.
1011     uint public session = 1;      // Current session of the court.
1012     uint public lastPeriodChange; // The last time we changed of period (seconds).
1013     uint public segmentSize;      // Size of the segment of activated tokens.
1014     uint public rnBlock;          // The block linked with the RN which is requested.
1015     uint public randomNumber;     // Random number of the session.
1016 
1017     enum Period {
1018         Activation, // When juror can deposit their tokens and parties give evidences.
1019         Draw,       // When jurors are drawn at random, note that this period is fast.
1020         Vote,       // Where jurors can vote on disputes.
1021         Appeal,     // When parties can appeal the rulings.
1022         Execution   // When where token redistribution occurs and Kleros call the arbitrated contracts.
1023     }
1024 
1025     Period public period;
1026 
1027     struct Juror {
1028         uint balance;      // The amount of tokens the contract holds for this juror.
1029         uint atStake;      // Total number of tokens the jurors can loose in disputes they are drawn in. Those tokens are locked. Note that we can have atStake > balance but it should be statistically unlikely and does not pose issues.
1030         uint lastSession;  // Last session the tokens were activated.
1031         uint segmentStart; // Start of the segment of activated tokens.
1032         uint segmentEnd;   // End of the segment of activated tokens.
1033     }
1034 
1035     mapping (address => Juror) public jurors;
1036 
1037     struct Vote {
1038         address account; // The juror who casted the vote.
1039         uint ruling;     // The ruling which was given.
1040     }
1041 
1042     struct VoteCounter {
1043         uint winningChoice; // The choice which currently has the highest amount of votes. Is 0 in case of a tie.
1044         uint winningCount;  // The number of votes for winningChoice. Or for the choices which are tied.
1045         mapping (uint => uint) voteCount; // voteCount[choice] is the number of votes for choice.
1046     }
1047 
1048     enum DisputeState {
1049         Open,       // The dispute is opened but the outcome is not available yet (this include when jurors voted but appeal is still possible).
1050         Resolving,  // The token repartition has started. Note that if it's done in just one call, this state is skipped.
1051         Executable, // The arbitrated contract can be called to enforce the decision.
1052         Executed    // Everything has been done and the dispute can't be interacted with anymore.
1053     }
1054 
1055     struct Dispute {
1056         Arbitrable arbitrated;       // Contract to be arbitrated.
1057         uint session;                // First session the dispute was schedule.
1058         uint appeals;                // Number of appeals.
1059         uint choices;                // The number of choices available to the jurors.
1060         uint16 initialNumberJurors;  // The initial number of jurors.
1061         uint arbitrationFeePerJuror; // The fee which will be paid to each juror.
1062         DisputeState state;          // The state of the dispute.
1063         Vote[][] votes;              // The votes in the form vote[appeals][voteID].
1064         VoteCounter[] voteCounter;   // The vote counters in the form voteCounter[appeals].
1065         mapping (address => uint) lastSessionVote; // Last session a juror has voted on this dispute. Is 0 if he never did.
1066         uint currentAppealToRepartition; // The current appeal we are repartitioning.
1067         AppealsRepartitioned[] appealsRepartitioned; // Track a partially repartitioned appeal in the form AppealsRepartitioned[appeal].
1068     }
1069 
1070     enum RepartitionStage { // State of the token repartition if oneShotTokenRepartition would throw because there are too many votes.
1071         Incoherent,
1072         Coherent,
1073         AtStake,
1074         Complete
1075     }
1076 
1077     struct AppealsRepartitioned {
1078         uint totalToRedistribute;   // Total amount of tokens we have to redistribute.
1079         uint nbCoherent;            // Number of coherent jurors for session.
1080         uint currentIncoherentVote; // Current vote for the incoherent loop.
1081         uint currentCoherentVote;   // Current vote we need to count.
1082         uint currentAtStakeVote;    // Current vote we need to count.
1083         RepartitionStage stage;     // Use with multipleShotTokenRepartition if oneShotTokenRepartition would throw.
1084     }
1085 
1086     Dispute[] public disputes;
1087 
1088     // **************************** //
1089     // *          Events          * //
1090     // **************************** //
1091 
1092     /** @dev Emitted when we pass to a new period.
1093      *  @param _period The new period.
1094      *  @param _session The current session.
1095      */
1096     event NewPeriod(Period _period, uint indexed _session);
1097 
1098     /** @dev Emitted when a juror wins or loses tokens.
1099       * @param _account The juror affected.
1100       * @param _disputeID The ID of the dispute.
1101       * @param _amount The amount of parts of token which was won. Can be negative for lost amounts.
1102       */
1103     event TokenShift(address indexed _account, uint _disputeID, int _amount);
1104 
1105     /** @dev Emited when a juror wins arbitration fees.
1106       * @param _account The account affected.
1107       * @param _disputeID The ID of the dispute.
1108       * @param _amount The amount of weis which was won.
1109       */
1110     event ArbitrationReward(address indexed _account, uint _disputeID, uint _amount);
1111 
1112     // **************************** //
1113     // *         Modifiers        * //
1114     // **************************** //
1115     modifier onlyBy(address _account) {require(msg.sender == _account); _;}
1116     modifier onlyDuring(Period _period) {require(period == _period); _;}
1117     modifier onlyGovernor() {require(msg.sender == governor); _;}
1118 
1119 
1120     /** @dev Constructor.
1121      *  @param _pinakion The address of the pinakion contract.
1122      *  @param _rng The random number generator which will be used.
1123      *  @param _timePerPeriod The minimal time for each period (seconds).
1124      *  @param _governor Address of the governor contract.
1125      */
1126     constructor(Pinakion _pinakion, RNG _rng, uint[5] _timePerPeriod, address _governor) public {
1127         pinakion = _pinakion;
1128         rng = _rng;
1129         lastPeriodChange = now;
1130         timePerPeriod = _timePerPeriod;
1131         governor = _governor;
1132     }
1133 
1134     // **************************** //
1135     // *  Functions interacting   * //
1136     // *  with Pinakion contract  * //
1137     // **************************** //
1138 
1139     /** @dev Callback of approveAndCall - transfer pinakions of a juror in the contract. Should be called by the pinakion contract. TRUSTED.
1140      *  @param _from The address making the transfer.
1141      *  @param _amount Amount of tokens to transfer to Kleros (in basic units).
1142      */
1143     function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
1144         require(pinakion.transferFrom(_from, this, _amount));
1145 
1146         jurors[_from].balance += _amount;
1147     }
1148 
1149     /** @dev Withdraw tokens. Note that we can't withdraw the tokens which are still atStake. 
1150      *  Jurors can't withdraw their tokens if they have deposited some during this session.
1151      *  This is to prevent jurors from withdrawing tokens they could loose.
1152      *  @param _value The amount to withdraw.
1153      */
1154     function withdraw(uint _value) public {
1155         Juror storage juror = jurors[msg.sender];
1156         require(juror.atStake <= juror.balance); // Make sure that there is no more at stake than owned to avoid overflow.
1157         require(_value <= juror.balance-juror.atStake);
1158         require(juror.lastSession != session);
1159 
1160         juror.balance -= _value;
1161         require(pinakion.transfer(msg.sender,_value));
1162     }
1163 
1164     // **************************** //
1165     // *      Court functions     * //
1166     // *    Modifying the state   * //
1167     // **************************** //
1168 
1169     /** @dev To call to go to a new period. TRUSTED.
1170      */
1171     function passPeriod() public {
1172         require(now-lastPeriodChange >= timePerPeriod[uint8(period)]);
1173 
1174         if (period == Period.Activation) {
1175             rnBlock = block.number + 1;
1176             rng.requestRN(rnBlock);
1177             period = Period.Draw;
1178         } else if (period == Period.Draw) {
1179             randomNumber = rng.getUncorrelatedRN(rnBlock);
1180             require(randomNumber != 0);
1181             period = Period.Vote;
1182         } else if (period == Period.Vote) {
1183             period = Period.Appeal;
1184         } else if (period == Period.Appeal) {
1185             period = Period.Execution;
1186         } else if (period == Period.Execution) {
1187             period = Period.Activation;
1188             ++session;
1189             segmentSize = 0;
1190             rnBlock = 0;
1191             randomNumber = 0;
1192         }
1193 
1194 
1195         lastPeriodChange = now;
1196         NewPeriod(period, session);
1197     }
1198 
1199 
1200     /** @dev Deposit tokens in order to have chances of being drawn. Note that once tokens are deposited, 
1201      *  there is no possibility of depositing more.
1202      *  @param _value Amount of tokens (in basic units) to deposit.
1203      */
1204     function activateTokens(uint _value) public onlyDuring(Period.Activation) {
1205         Juror storage juror = jurors[msg.sender];
1206         require(_value <= juror.balance);
1207         require(_value >= minActivatedToken);
1208         require(juror.lastSession != session); // Verify that tokens were not already activated for this session.
1209 
1210         juror.lastSession = session;
1211         juror.segmentStart = segmentSize;
1212         segmentSize += _value;
1213         juror.segmentEnd = segmentSize;
1214 
1215     }
1216 
1217     /** @dev Vote a ruling. Juror must input the draw ID he was drawn.
1218      *  Note that the complexity is O(d), where d is amount of times the juror was drawn.
1219      *  Since being drawn multiple time is a rare occurrence and that a juror can always vote with less weight than it has, it is not a problem.
1220      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1221      *  @param _disputeID The ID of the dispute the juror was drawn.
1222      *  @param _ruling The ruling given.
1223      *  @param _draws The list of draws the juror was drawn. Draw numbering starts at 1 and the numbers should be increasing.
1224      */
1225     function voteRuling(uint _disputeID, uint _ruling, uint[] _draws) public onlyDuring(Period.Vote) {
1226         Dispute storage dispute = disputes[_disputeID];
1227         Juror storage juror = jurors[msg.sender];
1228         VoteCounter storage voteCounter = dispute.voteCounter[dispute.appeals];
1229         require(dispute.lastSessionVote[msg.sender] != session); // Make sure juror hasn't voted yet.
1230         require(_ruling <= dispute.choices);
1231         // Note that it throws if the draws are incorrect.
1232         require(validDraws(msg.sender, _disputeID, _draws));
1233 
1234         dispute.lastSessionVote[msg.sender] = session;
1235         voteCounter.voteCount[_ruling] += _draws.length;
1236         if (voteCounter.winningCount < voteCounter.voteCount[_ruling]) {
1237             voteCounter.winningCount = voteCounter.voteCount[_ruling];
1238             voteCounter.winningChoice = _ruling;
1239         } else if (voteCounter.winningCount==voteCounter.voteCount[_ruling] && _draws.length!=0) { // Verify draw length to be non-zero to avoid the possibility of setting tie by casting 0 votes.
1240             voteCounter.winningChoice = 0; // It's currently a tie.
1241         }
1242         for (uint i = 0; i < _draws.length; ++i) {
1243             dispute.votes[dispute.appeals].push(Vote({
1244                 account: msg.sender,
1245                 ruling: _ruling
1246             }));
1247         }
1248 
1249         juror.atStake += _draws.length * getStakePerDraw();
1250         uint feeToPay = _draws.length * dispute.arbitrationFeePerJuror;
1251         msg.sender.transfer(feeToPay);
1252         ArbitrationReward(msg.sender, _disputeID, feeToPay);
1253     }
1254 
1255     /** @dev Steal part of the tokens and the arbitration fee of a juror who failed to vote.
1256      *  Note that a juror who voted but without all his weight can't be penalized.
1257      *  It is possible to not penalize with the maximum weight.
1258      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1259      *  @param _jurorAddress Address of the juror to steal tokens from.
1260      *  @param _disputeID The ID of the dispute the juror was drawn.
1261      *  @param _draws The list of draws the juror was drawn. Numbering starts at 1 and the numbers should be increasing.
1262      */
1263     function penalizeInactiveJuror(address _jurorAddress, uint _disputeID, uint[] _draws) public {
1264         Dispute storage dispute = disputes[_disputeID];
1265         Juror storage inactiveJuror = jurors[_jurorAddress];
1266         require(period > Period.Vote);
1267         require(dispute.lastSessionVote[_jurorAddress] != session); // Verify the juror hasn't voted.
1268         dispute.lastSessionVote[_jurorAddress] = session; // Update last session to avoid penalizing multiple times.
1269         require(validDraws(_jurorAddress, _disputeID, _draws));
1270         uint penality = _draws.length * minActivatedToken * 2 * alpha / ALPHA_DIVISOR;
1271         penality = (penality < inactiveJuror.balance) ? penality : inactiveJuror.balance; // Make sure the penality is not higher than the balance.
1272         inactiveJuror.balance -= penality;
1273         TokenShift(_jurorAddress, _disputeID, -int(penality));
1274         jurors[msg.sender].balance += penality / 2; // Give half of the penalty to the caller.
1275         TokenShift(msg.sender, _disputeID, int(penality / 2));
1276         jurors[governor].balance += penality / 2; // The other half to the governor.
1277         TokenShift(governor, _disputeID, int(penality / 2));
1278         msg.sender.transfer(_draws.length*dispute.arbitrationFeePerJuror); // Give the arbitration fees to the caller.
1279     }
1280 
1281     /** @dev Execute all the token repartition.
1282      *  Note that this function could consume to much gas if there is too much votes. 
1283      *  It is O(v), where v is the number of votes for this dispute.
1284      *  In the next version, there will also be a function to execute it in multiple calls 
1285      *  (but note that one shot execution, if possible, is less expensive).
1286      *  @param _disputeID ID of the dispute.
1287      */
1288     function oneShotTokenRepartition(uint _disputeID) public onlyDuring(Period.Execution) {
1289         Dispute storage dispute = disputes[_disputeID];
1290         require(dispute.state == DisputeState.Open);
1291         require(dispute.session+dispute.appeals <= session);
1292 
1293         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1294         uint amountShift = getStakePerDraw();
1295         for (uint i = 0; i <= dispute.appeals; ++i) {
1296             // If the result is not a tie, some parties are incoherent. Note that 0 (refuse to arbitrate) winning is not a tie.
1297             // Result is a tie if the winningChoice is 0 (refuse to arbitrate) and the choice 0 is not the most voted choice.
1298             // Note that in case of a "tie" among some choices including 0, parties who did not vote 0 are considered incoherent.
1299             if (winningChoice!=0 || (dispute.voteCounter[dispute.appeals].voteCount[0] == dispute.voteCounter[dispute.appeals].winningCount)) {
1300                 uint totalToRedistribute = 0;
1301                 uint nbCoherent = 0;
1302                 // First loop to penalize the incoherent votes.
1303                 for (uint j = 0; j < dispute.votes[i].length; ++j) {
1304                     Vote storage vote = dispute.votes[i][j];
1305                     if (vote.ruling != winningChoice) {
1306                         Juror storage juror = jurors[vote.account];
1307                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1308                         juror.balance -= penalty;
1309                         TokenShift(vote.account, _disputeID, int(-penalty));
1310                         totalToRedistribute += penalty;
1311                     } else {
1312                         ++nbCoherent;
1313                     }
1314                 }
1315                 if (nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1316                     jurors[governor].balance += totalToRedistribute;
1317                     TokenShift(governor, _disputeID, int(totalToRedistribute));
1318                 } else { // otherwise, redistribute them.
1319                     uint toRedistribute = totalToRedistribute / nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1320                     // Second loop to redistribute.
1321                     for (j = 0; j < dispute.votes[i].length; ++j) {
1322                         vote = dispute.votes[i][j];
1323                         if (vote.ruling == winningChoice) {
1324                             juror = jurors[vote.account];
1325                             juror.balance += toRedistribute;
1326                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1327                         }
1328                     }
1329                 }
1330             }
1331             // Third loop to lower the atStake in order to unlock tokens.
1332             for (j = 0; j < dispute.votes[i].length; ++j) {
1333                 vote = dispute.votes[i][j];
1334                 juror = jurors[vote.account];
1335                 juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1336             }
1337         }
1338         dispute.state = DisputeState.Executable; // Since it was solved in one shot, go directly to the executable step.
1339     }
1340 
1341     /** @dev Execute token repartition on a dispute for a specific number of votes.
1342      *  This should only be called if oneShotTokenRepartition will throw because there are too many votes (will use too much gas).
1343      *  Note that There are 3 iterations per vote. e.g. A dispute with 1 appeal (2 sessions) and 3 votes per session will have 18 iterations
1344      *  @param _disputeID ID of the dispute.
1345      *  @param _maxIterations the maxium number of votes to repartition in this iteration
1346      */
1347     function multipleShotTokenRepartition(uint _disputeID, uint _maxIterations) public onlyDuring(Period.Execution) {
1348         Dispute storage dispute = disputes[_disputeID];
1349         require(dispute.state <= DisputeState.Resolving);
1350         require(dispute.session+dispute.appeals <= session);
1351         dispute.state = DisputeState.Resolving; // Mark as resolving so oneShotTokenRepartition cannot be called on dispute.
1352 
1353         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1354         uint amountShift = getStakePerDraw();
1355         uint currentIterations = 0; // Total votes we have repartitioned this iteration.
1356         for (uint i = dispute.currentAppealToRepartition; i <= dispute.appeals; ++i) {
1357             // Allocate space for new AppealsRepartitioned.
1358             if (dispute.appealsRepartitioned.length < i+1) {
1359                 dispute.appealsRepartitioned.length++;
1360             }
1361 
1362             // If the result is a tie, no parties are incoherent and no need to move tokens. Note that 0 (refuse to arbitrate) winning is not a tie.
1363             if (winningChoice==0 && (dispute.voteCounter[dispute.appeals].voteCount[0] != dispute.voteCounter[dispute.appeals].winningCount)) {
1364                 // If ruling is a tie we can skip to at stake.
1365                 dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1366             }
1367 
1368             // First loop to penalize the incoherent votes.
1369             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Incoherent) {
1370                 for (uint j = dispute.appealsRepartitioned[i].currentIncoherentVote; j < dispute.votes[i].length; ++j) {
1371                     if (currentIterations >= _maxIterations) {
1372                         return;
1373                     }
1374                     Vote storage vote = dispute.votes[i][j];
1375                     if (vote.ruling != winningChoice) {
1376                         Juror storage juror = jurors[vote.account];
1377                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1378                         juror.balance -= penalty;
1379                         TokenShift(vote.account, _disputeID, int(-penalty));
1380                         dispute.appealsRepartitioned[i].totalToRedistribute += penalty;
1381                     } else {
1382                         ++dispute.appealsRepartitioned[i].nbCoherent;
1383                     }
1384 
1385                     ++dispute.appealsRepartitioned[i].currentIncoherentVote;
1386                     ++currentIterations;
1387                 }
1388 
1389                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Coherent;
1390             }
1391 
1392             // Second loop to reward coherent voters
1393             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Coherent) {
1394                 if (dispute.appealsRepartitioned[i].nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1395                     jurors[governor].balance += dispute.appealsRepartitioned[i].totalToRedistribute;
1396                     TokenShift(governor, _disputeID, int(dispute.appealsRepartitioned[i].totalToRedistribute));
1397                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1398                 } else { // Otherwise, redistribute them.
1399                     uint toRedistribute = dispute.appealsRepartitioned[i].totalToRedistribute / dispute.appealsRepartitioned[i].nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1400                     // Second loop to redistribute.
1401                     for (j = dispute.appealsRepartitioned[i].currentCoherentVote; j < dispute.votes[i].length; ++j) {
1402                         if (currentIterations >= _maxIterations) {
1403                             return;
1404                         }
1405                         vote = dispute.votes[i][j];
1406                         if (vote.ruling == winningChoice) {
1407                             juror = jurors[vote.account];
1408                             juror.balance += toRedistribute;
1409                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1410                         }
1411 
1412                         ++currentIterations;
1413                         ++dispute.appealsRepartitioned[i].currentCoherentVote;
1414                     }
1415 
1416                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1417                 }
1418             }
1419 
1420             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.AtStake) {
1421                 // Third loop to lower the atStake in order to unlock tokens.
1422                 for (j = dispute.appealsRepartitioned[i].currentAtStakeVote; j < dispute.votes[i].length; ++j) {
1423                     if (currentIterations >= _maxIterations) {
1424                         return;
1425                     }
1426                     vote = dispute.votes[i][j];
1427                     juror = jurors[vote.account];
1428                     juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1429 
1430                     ++currentIterations;
1431                     ++dispute.appealsRepartitioned[i].currentAtStakeVote;
1432                 }
1433 
1434                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Complete;
1435             }
1436 
1437             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Complete) {
1438                 ++dispute.currentAppealToRepartition;
1439             }
1440         }
1441 
1442         dispute.state = DisputeState.Executable;
1443     }
1444 
1445     // **************************** //
1446     // *      Court functions     * //
1447     // *     Constant and Pure    * //
1448     // **************************** //
1449 
1450     /** @dev Return the amount of jurors which are or will be drawn in the dispute.
1451      *  The number of jurors is doubled and 1 is added at each appeal. We have proven the formula by recurrence.
1452      *  This avoid having a variable number of jurors which would be updated in order to save gas.
1453      *  @param _disputeID The ID of the dispute we compute the amount of jurors.
1454      *  @return nbJurors The number of jurors which are drawn.
1455      */
1456     function amountJurors(uint _disputeID) public view returns (uint nbJurors) {
1457         Dispute storage dispute = disputes[_disputeID];
1458         return (dispute.initialNumberJurors + 1) * 2**dispute.appeals - 1;
1459     }
1460 
1461     /** @dev Must be used to verify that a juror has been draw at least _draws.length times.
1462      *  We have to require the user to specify the draws that lead the juror to be drawn.
1463      *  Because doing otherwise (looping through all draws) could consume too much gas.
1464      *  @param _jurorAddress Address of the juror we want to verify draws.
1465      *  @param _disputeID The ID of the dispute the juror was drawn.
1466      *  @param _draws The list of draws the juror was drawn. It draw numbering starts at 1 and the numbers should be increasing.
1467      *  Note that in most cases this list will just contain 1 number.
1468      *  @param valid true if the draws are valid.
1469      */
1470     function validDraws(address _jurorAddress, uint _disputeID, uint[] _draws) public view returns (bool valid) {
1471         uint draw = 0;
1472         Juror storage juror = jurors[_jurorAddress];
1473         Dispute storage dispute = disputes[_disputeID];
1474         uint nbJurors = amountJurors(_disputeID);
1475 
1476         if (juror.lastSession != session) return false; // Make sure that the tokens were deposited for this session.
1477         if (dispute.session+dispute.appeals != session) return false; // Make sure there is currently a dispute.
1478         if (period <= Period.Draw) return false; // Make sure that jurors are already drawn.
1479         for (uint i = 0; i < _draws.length; ++i) {
1480             if (_draws[i] <= draw) return false; // Make sure that draws are always increasing to avoid someone inputing the same multiple times.
1481             draw = _draws[i];
1482             if (draw > nbJurors) return false;
1483             uint position = uint(keccak256(randomNumber, _disputeID, draw)) % segmentSize; // Random position on the segment for draw.
1484             require(position >= juror.segmentStart);
1485             require(position < juror.segmentEnd);
1486         }
1487 
1488         return true;
1489     }
1490 
1491     // **************************** //
1492     // *   Arbitrator functions   * //
1493     // *   Modifying the state    * //
1494     // **************************** //
1495 
1496     /** @dev Create a dispute. Must be called by the arbitrable contract.
1497      *  Must be paid at least arbitrationCost().
1498      *  @param _choices Amount of choices the arbitrator can make in this dispute.
1499      *  @param _extraData Null for the default number. Otherwise, first 16 bytes will be used to return the number of jurors.
1500      *  @return disputeID ID of the dispute created.
1501      */
1502     function createDispute(uint _choices, bytes _extraData) public payable returns (uint disputeID) {
1503         uint16 nbJurors = extraDataToNbJurors(_extraData);
1504         require(msg.value >= arbitrationCost(_extraData));
1505 
1506         disputeID = disputes.length++;
1507         Dispute storage dispute = disputes[disputeID];
1508         dispute.arbitrated = Arbitrable(msg.sender);
1509         if (period < Period.Draw) // If drawing did not start schedule it for the current session.
1510             dispute.session = session;
1511         else // Otherwise schedule it for the next one.
1512             dispute.session = session+1;
1513         dispute.choices = _choices;
1514         dispute.initialNumberJurors = nbJurors;
1515         dispute.arbitrationFeePerJuror = arbitrationFeePerJuror; // We store it as the general fee can be changed through the governance mechanism.
1516         dispute.votes.length++;
1517         dispute.voteCounter.length++;
1518 
1519         DisputeCreation(disputeID, Arbitrable(msg.sender));
1520         return disputeID;
1521     }
1522 
1523     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
1524      *  @param _disputeID ID of the dispute to be appealed.
1525      *  @param _extraData Standard but not used by this contract.
1526      */
1527     function appeal(uint _disputeID, bytes _extraData) public payable onlyDuring(Period.Appeal) {
1528         super.appeal(_disputeID,_extraData);
1529         Dispute storage dispute = disputes[_disputeID];
1530         require(msg.value >= appealCost(_disputeID, _extraData));
1531         require(dispute.session+dispute.appeals == session); // Dispute of the current session.
1532         require(dispute.arbitrated == msg.sender);
1533         
1534         dispute.appeals++;
1535         dispute.votes.length++;
1536         dispute.voteCounter.length++;
1537     }
1538 
1539     /** @dev Execute the ruling of a dispute which is in the state executable. UNTRUSTED.
1540      *  @param disputeID ID of the dispute to execute the ruling.
1541      */
1542     function executeRuling(uint disputeID) public {
1543         Dispute storage dispute = disputes[disputeID];
1544         require(dispute.state == DisputeState.Executable);
1545 
1546         dispute.state = DisputeState.Executed;
1547         dispute.arbitrated.rule(disputeID, dispute.voteCounter[dispute.appeals].winningChoice);
1548     }
1549 
1550     // **************************** //
1551     // *   Arbitrator functions   * //
1552     // *    Constant and pure     * //
1553     // **************************** //
1554 
1555     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, 
1556      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1557      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1558      *  @return fee Amount to be paid.
1559      */
1560     function arbitrationCost(bytes _extraData) public view returns (uint fee) {
1561         return extraDataToNbJurors(_extraData) * arbitrationFeePerJuror;
1562     }
1563 
1564     /** @dev Compute the cost of appeal. It is recommended not to increase it often, 
1565      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1566      *  @param _disputeID ID of the dispute to be appealed.
1567      *  @param _extraData Is not used there.
1568      *  @return fee Amount to be paid.
1569      */
1570     function appealCost(uint _disputeID, bytes _extraData) public view returns (uint fee) {
1571         Dispute storage dispute = disputes[_disputeID];
1572 
1573         if(dispute.appeals >= maxAppeals) return NON_PAYABLE_AMOUNT;
1574 
1575         return (2*amountJurors(_disputeID) + 1) * dispute.arbitrationFeePerJuror;
1576     }
1577 
1578     /** @dev Compute the amount of jurors to be drawn.
1579      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1580      *  Note that it does not check that the number of jurors is odd, but users are advised to choose a odd number of jurors.
1581      */
1582     function extraDataToNbJurors(bytes _extraData) internal view returns (uint16 nbJurors) {
1583         if (_extraData.length < 2)
1584             return defaultNumberJuror;
1585         else
1586             return (uint16(_extraData[0]) << 8) + uint16(_extraData[1]);
1587     }
1588 
1589     /** @dev Compute the minimum activated pinakions in alpha.
1590      *  Note there may be multiple draws for a single user on a single dispute.
1591      */
1592     function getStakePerDraw() public view returns (uint minActivatedTokenInAlpha) {
1593         return (alpha * minActivatedToken) / ALPHA_DIVISOR;
1594     }
1595 
1596 
1597     // **************************** //
1598     // *     Constant getters     * //
1599     // **************************** //
1600 
1601     /** @dev Getter for account in Vote.
1602      *  @param _disputeID ID of the dispute.
1603      *  @param _appeals Which appeal (or 0 for the initial session).
1604      *  @param _voteID The ID of the vote for this appeal (or initial session).
1605      *  @return account The address of the voter.
1606      */
1607     function getVoteAccount(uint _disputeID, uint _appeals, uint _voteID) public view returns (address account) {
1608         return disputes[_disputeID].votes[_appeals][_voteID].account;
1609     }
1610 
1611     /** @dev Getter for ruling in Vote.
1612      *  @param _disputeID ID of the dispute.
1613      *  @param _appeals Which appeal (or 0 for the initial session).
1614      *  @param _voteID The ID of the vote for this appeal (or initial session).
1615      *  @return ruling The ruling given by the voter.
1616      */
1617     function getVoteRuling(uint _disputeID, uint _appeals, uint _voteID) public view returns (uint ruling) {
1618         return disputes[_disputeID].votes[_appeals][_voteID].ruling;
1619     }
1620 
1621     /** @dev Getter for winningChoice in VoteCounter.
1622      *  @param _disputeID ID of the dispute.
1623      *  @param _appeals Which appeal (or 0 for the initial session).
1624      *  @return winningChoice The currently winning choice (or 0 if it's tied). Note that 0 can also be return if the majority refuses to arbitrate.
1625      */
1626     function getWinningChoice(uint _disputeID, uint _appeals) public view returns (uint winningChoice) {
1627         return disputes[_disputeID].voteCounter[_appeals].winningChoice;
1628     }
1629 
1630     /** @dev Getter for winningCount in VoteCounter.
1631      *  @param _disputeID ID of the dispute.
1632      *  @param _appeals Which appeal (or 0 for the initial session).
1633      *  @return winningCount The amount of votes the winning choice (or those who are tied) has.
1634      */
1635     function getWinningCount(uint _disputeID, uint _appeals) public view returns (uint winningCount) {
1636         return disputes[_disputeID].voteCounter[_appeals].winningCount;
1637     }
1638 
1639     /** @dev Getter for voteCount in VoteCounter.
1640      *  @param _disputeID ID of the dispute.
1641      *  @param _appeals Which appeal (or 0 for the initial session).
1642      *  @param _choice The choice.
1643      *  @return voteCount The amount of votes the winning choice (or those who are tied) has.
1644      */
1645     function getVoteCount(uint _disputeID, uint _appeals, uint _choice) public view returns (uint voteCount) {
1646         return disputes[_disputeID].voteCounter[_appeals].voteCount[_choice];
1647     }
1648 
1649     /** @dev Getter for lastSessionVote in Dispute.
1650      *  @param _disputeID ID of the dispute.
1651      *  @param _juror The juror we want to get the last session he voted.
1652      *  @return lastSessionVote The last session the juror voted.
1653      */
1654     function getLastSessionVote(uint _disputeID, address _juror) public view returns (uint lastSessionVote) {
1655         return disputes[_disputeID].lastSessionVote[_juror];
1656     }
1657 
1658     /** @dev Is the juror drawn in the draw of the dispute.
1659      *  @param _disputeID ID of the dispute.
1660      *  @param _juror The juror.
1661      *  @param _draw The draw. Note that it starts at 1.
1662      *  @return drawn True if the juror is drawn, false otherwise.
1663      */
1664     function isDrawn(uint _disputeID, address _juror, uint _draw) public view returns (bool drawn) {
1665         Dispute storage dispute = disputes[_disputeID];
1666         Juror storage juror = jurors[_juror];
1667         if (juror.lastSession != session
1668         || (dispute.session+dispute.appeals != session)
1669         || period<=Period.Draw
1670         || _draw>amountJurors(_disputeID)
1671         || _draw==0
1672         || segmentSize==0
1673         ) {
1674             return false;
1675         } else {
1676             uint position = uint(keccak256(randomNumber,_disputeID,_draw)) % segmentSize;
1677             return (position >= juror.segmentStart) && (position < juror.segmentEnd);
1678         }
1679 
1680     }
1681 
1682     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1683      *  @param _disputeID ID of the dispute.
1684      *  @return ruling The current ruling which will be given if there is no appeal. If it is not available, return 0.
1685      */
1686     function currentRuling(uint _disputeID) public view returns (uint ruling) {
1687         Dispute storage dispute = disputes[_disputeID];
1688         return dispute.voteCounter[dispute.appeals].winningChoice;
1689     }
1690 
1691     /** @dev Return the status of a dispute.
1692      *  @param _disputeID ID of the dispute to rule.
1693      *  @return status The status of the dispute.
1694      */
1695     function disputeStatus(uint _disputeID) public view returns (DisputeStatus status) {
1696         Dispute storage dispute = disputes[_disputeID];
1697         if (dispute.session+dispute.appeals < session) // Dispute of past session.
1698             return DisputeStatus.Solved;
1699         else if(dispute.session+dispute.appeals == session) { // Dispute of current session.
1700             if (dispute.state == DisputeState.Open) {
1701                 if (period < Period.Appeal)
1702                     return DisputeStatus.Waiting;
1703                 else if (period == Period.Appeal)
1704                     return DisputeStatus.Appealable;
1705                 else return DisputeStatus.Solved;
1706             } else return DisputeStatus.Solved;
1707         } else return DisputeStatus.Waiting; // Dispute for future session.
1708     }
1709 
1710     // **************************** //
1711     // *     Governor Functions   * //
1712     // **************************** //
1713 
1714     /** @dev General call function where the contract execute an arbitrary call with data and ETH following governor orders.
1715      *  @param _data Transaction data.
1716      *  @param _value Transaction value.
1717      *  @param _target Transaction target.
1718      */
1719     function executeOrder(bytes32 _data, uint _value, address _target) public onlyGovernor {
1720         _target.call.value(_value)(_data);
1721     }
1722 
1723     /** @dev Setter for rng.
1724      *  @param _rng An instance of RNG.
1725      */
1726     function setRng(RNG _rng) public onlyGovernor {
1727         rng = _rng;
1728     }
1729 
1730     /** @dev Setter for arbitrationFeePerJuror.
1731      *  @param _arbitrationFeePerJuror The fee which will be paid to each juror.
1732      */
1733     function setArbitrationFeePerJuror(uint _arbitrationFeePerJuror) public onlyGovernor {
1734         arbitrationFeePerJuror = _arbitrationFeePerJuror;
1735     }
1736 
1737     /** @dev Setter for defaultNumberJuror.
1738      *  @param _defaultNumberJuror Number of drawn jurors unless specified otherwise.
1739      */
1740     function setDefaultNumberJuror(uint16 _defaultNumberJuror) public onlyGovernor {
1741         defaultNumberJuror = _defaultNumberJuror;
1742     }
1743 
1744     /** @dev Setter for minActivatedToken.
1745      *  @param _minActivatedToken Minimum of tokens to be activated (in basic units).
1746      */
1747     function setMinActivatedToken(uint _minActivatedToken) public onlyGovernor {
1748         minActivatedToken = _minActivatedToken;
1749     }
1750 
1751     /** @dev Setter for timePerPeriod.
1752      *  @param _timePerPeriod The minimum time each period lasts (seconds).
1753      */
1754     function setTimePerPeriod(uint[5] _timePerPeriod) public onlyGovernor {
1755         timePerPeriod = _timePerPeriod;
1756     }
1757 
1758     /** @dev Setter for alpha.
1759      *  @param _alpha Alpha in ‱.
1760      */
1761     function setAlpha(uint _alpha) public onlyGovernor {
1762         alpha = _alpha;
1763     }
1764 
1765     /** @dev Setter for maxAppeals.
1766      *  @param _maxAppeals Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1767      */
1768     function setMaxAppeals(uint _maxAppeals) public onlyGovernor {
1769         maxAppeals = _maxAppeals;
1770     }
1771 
1772     /** @dev Setter for governor.
1773      *  @param _governor Address of the governor contract.
1774      */
1775     function setGovernor(address _governor) public onlyGovernor {
1776         governor = _governor;
1777     }
1778 }