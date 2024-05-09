1 pragma solidity ^0.4.24;
2 
3 
4 /** @title PEpsilon
5  *  @author Daniel Babbev
6  *
7  *  This contract implements a p + epsilon attack against the Kleros court.
8  *  The attack is described by VitaliK Buterin here: https://blog.ethereum.org/2015/01/28/p-epsilon-attack/
9  */
10 contract PEpsilon {
11   Pinakion public pinakion;
12   Kleros public court;
13 
14   uint public balance;
15   uint public disputeID;
16   uint public desiredOutcome;
17   uint public epsilon;
18   bool public settled;
19   uint public maxAppeals; // The maximum number of appeals this cotracts promises to pay
20   mapping (address => uint) public withdraw; // We'll use a withdraw pattern here to avoid multiple sends when a juror has voted multiple times.
21 
22   address public attacker;
23   uint public remainingWithdraw; // Here we keep the total amount bribed jurors have available for withdraw.
24 
25   modifier onlyBy(address _account) {require(msg.sender == _account); _;}
26 
27   event AmountShift(uint val, uint epsilon ,address juror);
28   event Log(uint val, address addr, string message);
29 
30   /** @dev Constructor.
31    *  @param _pinakion The PNK contract.
32    *  @param _kleros   The Kleros court.
33    *  @param _disputeID The dispute we are targeting.
34    *  @param _desiredOutcome The desired ruling of the dispute.
35    *  @param _epsilon  Jurors will be paid epsilon more for voting for the desiredOutcome.
36    *  @param _maxAppeals The maximum number of appeals this contract promises to pay out
37    */
38   constructor(Pinakion _pinakion, Kleros _kleros, uint _disputeID, uint _desiredOutcome, uint _epsilon, uint _maxAppeals) public {
39     pinakion = _pinakion;
40     court = _kleros;
41     disputeID = _disputeID;
42     desiredOutcome = _desiredOutcome;
43     epsilon = _epsilon;
44     attacker = msg.sender;
45     maxAppeals = _maxAppeals;
46   }
47 
48   /** @dev Callback of approveAndCall - transfer pinakions in the contract. Should be called by the pinakion contract. TRUSTED.
49    *  The attacker has to deposit sufficiently large amount of PNK to cover the payouts to the jurors.
50    *  @param _from The address making the transfer.
51    *  @param _amount Amount of tokens to transfer to this contract (in basic units).
52    */
53   function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
54     require(pinakion.transferFrom(_from, this, _amount));
55 
56     balance += _amount;
57   }
58 
59   /** @dev Jurors can withdraw their PNK from here
60    */
61   function withdrawJuror() {
62     withdrawSelect(msg.sender);
63   }
64 
65   /** @dev Withdraw the funds of a given juror
66    *  @param _juror The address of the juror
67    */
68   function withdrawSelect(address _juror) {
69     uint amount = withdraw[_juror];
70     withdraw[_juror] = 0;
71 
72     balance = sub(balance, amount); // Could underflow
73     remainingWithdraw = sub(remainingWithdraw, amount);
74 
75     // The juror receives d + p + e (deposit + p + epsilon)
76     require(pinakion.transfer(_juror, amount));
77   }
78 
79   /**
80   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     assert(_b <= _a);
84     return _a - _b;
85   }
86 
87   /** @dev The attacker can withdraw their PNK from here after the bribe has been settled.
88    */
89   function withdrawAttacker(){
90     require(settled);
91 
92     if (balance > remainingWithdraw) {
93       // The remaning balance of PNK after settlement is transfered to the attacker.
94       uint amount = balance - remainingWithdraw;
95       balance = remainingWithdraw;
96 
97       require(pinakion.transfer(attacker, amount));
98     }
99   }
100 
101   /** @dev Settles the p + e bribe with the jurors.
102    * If the dispute is ruled differently from desiredOutcome:
103    *    The jurors who voted for desiredOutcome receive p + d + e in rewards from this contract.
104    * If the dispute is ruled as in desiredOutcome:
105    *    The jurors don't receive anything from this contract.
106    */
107   function settle() public {
108     require(court.disputeStatus(disputeID) ==  Arbitrator.DisputeStatus.Solved); // The case must be solved.
109     require(!settled); // This function can be executed only once.
110 
111     settled = true; // settle the bribe
112 
113     // From the dispute we get the # of appeals and the available choices
114     var (, , appeals, choices, , , ,) = court.disputes(disputeID);
115 
116     if (court.currentRuling(disputeID) != desiredOutcome){
117       // Calculate the redistribution amounts.
118       uint amountShift = court.getStakePerDraw();
119       uint winningChoice = court.getWinningChoice(disputeID, appeals);
120 
121       // Rewards are calculated as per the one shot token reparation.
122       for (uint i=0; i <= (appeals > maxAppeals ? maxAppeals : appeals); i++){ // Loop each appeal and each vote.
123 
124         // Note that we don't check if the result was a tie becuse we are getting a funny compiler error: "stack is too deep" if we check.
125         // TODO: Account for ties
126         if (winningChoice != 0){
127           // votesLen is the length of the votes per each appeal. There is no getter function for that, so we have to calculate it here.
128           // We must end up with the exact same value as if we would have called dispute.votes[i].length
129           uint votesLen = 0;
130           for (uint c = 0; c <= choices; c++) { // Iterate for each choice of the dispute.
131             votesLen += court.getVoteCount(disputeID, i, c);
132           }
133 
134           emit Log(amountShift, 0x0 ,"stakePerDraw");
135           emit Log(votesLen, 0x0, "votesLen");
136 
137           uint totalToRedistribute = 0;
138           uint nbCoherent = 0;
139 
140           // Now we will use votesLen as a substitute for dispute.votes[i].length
141           for (uint j=0; j < votesLen; j++){
142             uint voteRuling = court.getVoteRuling(disputeID, i, j);
143             address voteAccount = court.getVoteAccount(disputeID, i, j);
144 
145             emit Log(voteRuling, voteAccount, "voted");
146 
147             if (voteRuling != winningChoice){
148               totalToRedistribute += amountShift;
149 
150               if (voteRuling == desiredOutcome){ // If the juror voted as we desired.
151                 // Transfer this juror back the penalty.
152                 withdraw[voteAccount] += amountShift + epsilon;
153                 remainingWithdraw += amountShift + epsilon;
154                 emit AmountShift(amountShift, epsilon, voteAccount);
155               }
156             } else {
157               nbCoherent++;
158             }
159           }
160           // toRedistribute is the amount each juror received when he voted coherently.
161           uint toRedistribute = (totalToRedistribute - amountShift) / (nbCoherent + 1);
162 
163           // We use votesLen again as a substitute for dispute.votes[i].length
164           for (j = 0; j < votesLen; j++){
165             voteRuling = court.getVoteRuling(disputeID, i, j);
166             voteAccount = court.getVoteAccount(disputeID, i, j);
167 
168             if (voteRuling == desiredOutcome){
169               // Add the coherent juror reward to the total payout.
170               withdraw[voteAccount] += toRedistribute;
171               remainingWithdraw += toRedistribute;
172               emit AmountShift(toRedistribute, 0, voteAccount);
173             }
174           }
175         }
176       }
177     }
178   }
179 }
180 
181 /**
182  *  @title Kleros
183  *  @author Clément Lesaege - <clement@lesaege.com>
184  *  This code implements a simple version of Kleros.
185  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
186  */
187 
188 pragma solidity ^0.4.24;
189 
190 
191 contract ApproveAndCallFallBack {
192     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
193 }
194 
195 /// @dev The token controller contract must implement these functions
196 contract TokenController {
197     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
198     /// @param _owner The address that sent the ether to create tokens
199     /// @return True if the ether is accepted, false if it throws
200     function proxyPayment(address _owner) public payable returns(bool);
201 
202     /// @notice Notifies the controller about a token transfer allowing the
203     ///  controller to react if desired
204     /// @param _from The origin of the transfer
205     /// @param _to The destination of the transfer
206     /// @param _amount The amount of the transfer
207     /// @return False if the controller does not authorize the transfer
208     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
209 
210     /// @notice Notifies the controller about an approval allowing the
211     ///  controller to react if desired
212     /// @param _owner The address that calls `approve()`
213     /// @param _spender The spender in the `approve()` call
214     /// @param _amount The amount in the `approve()` call
215     /// @return False if the controller does not authorize the approval
216     function onApprove(address _owner, address _spender, uint _amount) public
217         returns(bool);
218 }
219 
220 contract Controlled {
221     /// @notice The address of the controller is the only address that can call
222     ///  a function with this modifier
223     modifier onlyController { require(msg.sender == controller); _; }
224 
225     address public controller;
226 
227     function Controlled() public { controller = msg.sender;}
228 
229     /// @notice Changes the controller of the contract
230     /// @param _newController The new controller of the contract
231     function changeController(address _newController) public onlyController {
232         controller = _newController;
233     }
234 }
235 
236 /// @dev The actual token contract, the default controller is the msg.sender
237 ///  that deploys the contract, so usually this token will be deployed by a
238 ///  token controller contract, which Giveth will call a "Campaign"
239 contract Pinakion is Controlled {
240 
241     string public name;                //The Token's name: e.g. DigixDAO Tokens
242     uint8 public decimals;             //Number of decimals of the smallest unit
243     string public symbol;              //An identifier: e.g. REP
244     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
245 
246 
247     /// @dev `Checkpoint` is the structure that attaches a block number to a
248     ///  given value, the block number attached is the one that last changed the
249     ///  value
250     struct  Checkpoint {
251 
252         // `fromBlock` is the block number that the value was generated from
253         uint128 fromBlock;
254 
255         // `value` is the amount of tokens at a specific block number
256         uint128 value;
257     }
258 
259     // `parentToken` is the Token address that was cloned to produce this token;
260     //  it will be 0x0 for a token that was not cloned
261     Pinakion public parentToken;
262 
263     // `parentSnapShotBlock` is the block number from the Parent Token that was
264     //  used to determine the initial distribution of the Clone Token
265     uint public parentSnapShotBlock;
266 
267     // `creationBlock` is the block number that the Clone Token was created
268     uint public creationBlock;
269 
270     // `balances` is the map that tracks the balance of each address, in this
271     //  contract when the balance changes the block number that the change
272     //  occurred is also included in the map
273     mapping (address => Checkpoint[]) balances;
274 
275     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
276     mapping (address => mapping (address => uint256)) allowed;
277 
278     // Tracks the history of the `totalSupply` of the token
279     Checkpoint[] totalSupplyHistory;
280 
281     // Flag that determines if the token is transferable or not.
282     bool public transfersEnabled;
283 
284     // The factory used to create new clone tokens
285     MiniMeTokenFactory public tokenFactory;
286 
287 ////////////////
288 // Constructor
289 ////////////////
290 
291     /// @notice Constructor to create a Pinakion
292     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
293     ///  will create the Clone token contracts, the token factory needs to be
294     ///  deployed first
295     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
296     ///  new token
297     /// @param _parentSnapShotBlock Block of the parent token that will
298     ///  determine the initial distribution of the clone token, set to 0 if it
299     ///  is a new token
300     /// @param _tokenName Name of the new token
301     /// @param _decimalUnits Number of decimals of the new token
302     /// @param _tokenSymbol Token Symbol for the new token
303     /// @param _transfersEnabled If true, tokens will be able to be transferred
304     function Pinakion(
305         address _tokenFactory,
306         address _parentToken,
307         uint _parentSnapShotBlock,
308         string _tokenName,
309         uint8 _decimalUnits,
310         string _tokenSymbol,
311         bool _transfersEnabled
312     ) public {
313         tokenFactory = MiniMeTokenFactory(_tokenFactory);
314         name = _tokenName;                                 // Set the name
315         decimals = _decimalUnits;                          // Set the decimals
316         symbol = _tokenSymbol;                             // Set the symbol
317         parentToken = Pinakion(_parentToken);
318         parentSnapShotBlock = _parentSnapShotBlock;
319         transfersEnabled = _transfersEnabled;
320         creationBlock = block.number;
321     }
322 
323 
324 ///////////////////
325 // ERC20 Methods
326 ///////////////////
327 
328     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
329     /// @param _to The address of the recipient
330     /// @param _amount The amount of tokens to be transferred
331     /// @return Whether the transfer was successful or not
332     function transfer(address _to, uint256 _amount) public returns (bool success) {
333         require(transfersEnabled);
334         doTransfer(msg.sender, _to, _amount);
335         return true;
336     }
337 
338     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
339     ///  is approved by `_from`
340     /// @param _from The address holding the tokens being transferred
341     /// @param _to The address of the recipient
342     /// @param _amount The amount of tokens to be transferred
343     /// @return True if the transfer was successful
344     function transferFrom(address _from, address _to, uint256 _amount
345     ) public returns (bool success) {
346 
347         // The controller of this contract can move tokens around at will,
348         //  this is important to recognize! Confirm that you trust the
349         //  controller of this contract, which in most situations should be
350         //  another open source smart contract or 0x0
351         if (msg.sender != controller) {
352             require(transfersEnabled);
353 
354             // The standard ERC 20 transferFrom functionality
355             require(allowed[_from][msg.sender] >= _amount);
356             allowed[_from][msg.sender] -= _amount;
357         }
358         doTransfer(_from, _to, _amount);
359         return true;
360     }
361 
362     /// @dev This is the actual transfer function in the token contract, it can
363     ///  only be called by other functions in this contract.
364     /// @param _from The address holding the tokens being transferred
365     /// @param _to The address of the recipient
366     /// @param _amount The amount of tokens to be transferred
367     /// @return True if the transfer was successful
368     function doTransfer(address _from, address _to, uint _amount
369     ) internal {
370 
371            if (_amount == 0) {
372                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
373                return;
374            }
375 
376            require(parentSnapShotBlock < block.number);
377 
378            // Do not allow transfer to 0x0 or the token contract itself
379            require((_to != 0) && (_to != address(this)));
380 
381            // If the amount being transfered is more than the balance of the
382            //  account the transfer throws
383            var previousBalanceFrom = balanceOfAt(_from, block.number);
384 
385            require(previousBalanceFrom >= _amount);
386 
387            // Alerts the token controller of the transfer
388            if (isContract(controller)) {
389                require(TokenController(controller).onTransfer(_from, _to, _amount));
390            }
391 
392            // First update the balance array with the new value for the address
393            //  sending the tokens
394            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
395 
396            // Then update the balance array with the new value for the address
397            //  receiving the tokens
398            var previousBalanceTo = balanceOfAt(_to, block.number);
399            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
400            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
401 
402            // An event to make the transfer easy to find on the blockchain
403            Transfer(_from, _to, _amount);
404 
405     }
406 
407     /// @param _owner The address that's balance is being requested
408     /// @return The balance of `_owner` at the current block
409     function balanceOf(address _owner) public constant returns (uint256 balance) {
410         return balanceOfAt(_owner, block.number);
411     }
412 
413     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
414     ///  its behalf. This is the standard version to allow backward compatibility.
415     /// @param _spender The address of the account able to transfer the tokens
416     /// @param _amount The amount of tokens to be approved for transfer
417     /// @return True if the approval was successful
418     function approve(address _spender, uint256 _amount) public returns (bool success) {
419         require(transfersEnabled);
420 
421         // Alerts the token controller of the approve function call
422         if (isContract(controller)) {
423             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
424         }
425 
426         allowed[msg.sender][_spender] = _amount;
427         Approval(msg.sender, _spender, _amount);
428         return true;
429     }
430 
431     /// @dev This function makes it easy to read the `allowed[]` map
432     /// @param _owner The address of the account that owns the token
433     /// @param _spender The address of the account able to transfer the tokens
434     /// @return Amount of remaining tokens of _owner that _spender is allowed
435     ///  to spend
436     function allowance(address _owner, address _spender
437     ) public constant returns (uint256 remaining) {
438         return allowed[_owner][_spender];
439     }
440 
441     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
442     ///  its behalf, and then a function is triggered in the contract that is
443     ///  being approved, `_spender`. This allows users to use their tokens to
444     ///  interact with contracts in one function call instead of two
445     /// @param _spender The address of the contract able to transfer the tokens
446     /// @param _amount The amount of tokens to be approved for transfer
447     /// @return True if the function call was successful
448     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
449     ) public returns (bool success) {
450         require(approve(_spender, _amount));
451 
452         ApproveAndCallFallBack(_spender).receiveApproval(
453             msg.sender,
454             _amount,
455             this,
456             _extraData
457         );
458 
459         return true;
460     }
461 
462     /// @dev This function makes it easy to get the total number of tokens
463     /// @return The total number of tokens
464     function totalSupply() public constant returns (uint) {
465         return totalSupplyAt(block.number);
466     }
467 
468 
469 ////////////////
470 // Query balance and totalSupply in History
471 ////////////////
472 
473     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
474     /// @param _owner The address from which the balance will be retrieved
475     /// @param _blockNumber The block number when the balance is queried
476     /// @return The balance at `_blockNumber`
477     function balanceOfAt(address _owner, uint _blockNumber) public constant
478         returns (uint) {
479 
480         // These next few lines are used when the balance of the token is
481         //  requested before a check point was ever created for this token, it
482         //  requires that the `parentToken.balanceOfAt` be queried at the
483         //  genesis block for that token as this contains initial balance of
484         //  this token
485         if ((balances[_owner].length == 0)
486             || (balances[_owner][0].fromBlock > _blockNumber)) {
487             if (address(parentToken) != 0) {
488                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
489             } else {
490                 // Has no parent
491                 return 0;
492             }
493 
494         // This will return the expected balance during normal situations
495         } else {
496             return getValueAt(balances[_owner], _blockNumber);
497         }
498     }
499 
500     /// @notice Total amount of tokens at a specific `_blockNumber`.
501     /// @param _blockNumber The block number when the totalSupply is queried
502     /// @return The total amount of tokens at `_blockNumber`
503     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
504 
505         // These next few lines are used when the totalSupply of the token is
506         //  requested before a check point was ever created for this token, it
507         //  requires that the `parentToken.totalSupplyAt` be queried at the
508         //  genesis block for this token as that contains totalSupply of this
509         //  token at this block number.
510         if ((totalSupplyHistory.length == 0)
511             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
512             if (address(parentToken) != 0) {
513                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
514             } else {
515                 return 0;
516             }
517 
518         // This will return the expected totalSupply during normal situations
519         } else {
520             return getValueAt(totalSupplyHistory, _blockNumber);
521         }
522     }
523 
524 ////////////////
525 // Clone Token Method
526 ////////////////
527 
528     /// @notice Creates a new clone token with the initial distribution being
529     ///  this token at `_snapshotBlock`
530     /// @param _cloneTokenName Name of the clone token
531     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
532     /// @param _cloneTokenSymbol Symbol of the clone token
533     /// @param _snapshotBlock Block when the distribution of the parent token is
534     ///  copied to set the initial distribution of the new clone token;
535     ///  if the block is zero than the actual block, the current block is used
536     /// @param _transfersEnabled True if transfers are allowed in the clone
537     /// @return The address of the new MiniMeToken Contract
538     function createCloneToken(
539         string _cloneTokenName,
540         uint8 _cloneDecimalUnits,
541         string _cloneTokenSymbol,
542         uint _snapshotBlock,
543         bool _transfersEnabled
544         ) public returns(address) {
545         if (_snapshotBlock == 0) _snapshotBlock = block.number;
546         Pinakion cloneToken = tokenFactory.createCloneToken(
547             this,
548             _snapshotBlock,
549             _cloneTokenName,
550             _cloneDecimalUnits,
551             _cloneTokenSymbol,
552             _transfersEnabled
553             );
554 
555         cloneToken.changeController(msg.sender);
556 
557         // An event to make the token easy to find on the blockchain
558         NewCloneToken(address(cloneToken), _snapshotBlock);
559         return address(cloneToken);
560     }
561 
562 ////////////////
563 // Generate and destroy tokens
564 ////////////////
565 
566     /// @notice Generates `_amount` tokens that are assigned to `_owner`
567     /// @param _owner The address that will be assigned the new tokens
568     /// @param _amount The quantity of tokens generated
569     /// @return True if the tokens are generated correctly
570     function generateTokens(address _owner, uint _amount
571     ) public onlyController returns (bool) {
572         uint curTotalSupply = totalSupply();
573         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
574         uint previousBalanceTo = balanceOf(_owner);
575         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
576         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
577         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
578         Transfer(0, _owner, _amount);
579         return true;
580     }
581 
582 
583     /// @notice Burns `_amount` tokens from `_owner`
584     /// @param _owner The address that will lose the tokens
585     /// @param _amount The quantity of tokens to burn
586     /// @return True if the tokens are burned correctly
587     function destroyTokens(address _owner, uint _amount
588     ) onlyController public returns (bool) {
589         uint curTotalSupply = totalSupply();
590         require(curTotalSupply >= _amount);
591         uint previousBalanceFrom = balanceOf(_owner);
592         require(previousBalanceFrom >= _amount);
593         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
594         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
595         Transfer(_owner, 0, _amount);
596         return true;
597     }
598 
599 ////////////////
600 // Enable tokens transfers
601 ////////////////
602 
603 
604     /// @notice Enables token holders to transfer their tokens freely if true
605     /// @param _transfersEnabled True if transfers are allowed in the clone
606     function enableTransfers(bool _transfersEnabled) public onlyController {
607         transfersEnabled = _transfersEnabled;
608     }
609 
610 ////////////////
611 // Internal helper functions to query and set a value in a snapshot array
612 ////////////////
613 
614     /// @dev `getValueAt` retrieves the number of tokens at a given block number
615     /// @param checkpoints The history of values being queried
616     /// @param _block The block number to retrieve the value at
617     /// @return The number of tokens being queried
618     function getValueAt(Checkpoint[] storage checkpoints, uint _block
619     ) constant internal returns (uint) {
620         if (checkpoints.length == 0) return 0;
621 
622         // Shortcut for the actual value
623         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
624             return checkpoints[checkpoints.length-1].value;
625         if (_block < checkpoints[0].fromBlock) return 0;
626 
627         // Binary search of the value in the array
628         uint min = 0;
629         uint max = checkpoints.length-1;
630         while (max > min) {
631             uint mid = (max + min + 1)/ 2;
632             if (checkpoints[mid].fromBlock<=_block) {
633                 min = mid;
634             } else {
635                 max = mid-1;
636             }
637         }
638         return checkpoints[min].value;
639     }
640 
641     /// @dev `updateValueAtNow` used to update the `balances` map and the
642     ///  `totalSupplyHistory`
643     /// @param checkpoints The history of data being updated
644     /// @param _value The new number of tokens
645     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
646     ) internal  {
647         if ((checkpoints.length == 0)
648         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
649                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
650                newCheckPoint.fromBlock =  uint128(block.number);
651                newCheckPoint.value = uint128(_value);
652            } else {
653                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
654                oldCheckPoint.value = uint128(_value);
655            }
656     }
657 
658     /// @dev Internal function to determine if an address is a contract
659     /// @param _addr The address being queried
660     /// @return True if `_addr` is a contract
661     function isContract(address _addr) constant internal returns(bool) {
662         uint size;
663         if (_addr == 0) return false;
664         assembly {
665             size := extcodesize(_addr)
666         }
667         return size>0;
668     }
669 
670     /// @dev Helper function to return a min betwen the two uints
671     function min(uint a, uint b) pure internal returns (uint) {
672         return a < b ? a : b;
673     }
674 
675     /// @notice The fallback function: If the contract's controller has not been
676     ///  set to 0, then the `proxyPayment` method is called which relays the
677     ///  ether and creates tokens as described in the token controller contract
678     function () public payable {
679         require(isContract(controller));
680         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
681     }
682 
683 //////////
684 // Safety Methods
685 //////////
686 
687     /// @notice This method can be used by the controller to extract mistakenly
688     ///  sent tokens to this contract.
689     /// @param _token The address of the token contract that you want to recover
690     ///  set to 0 in case you want to extract ether.
691     function claimTokens(address _token) public onlyController {
692         if (_token == 0x0) {
693             controller.transfer(this.balance);
694             return;
695         }
696 
697         Pinakion token = Pinakion(_token);
698         uint balance = token.balanceOf(this);
699         token.transfer(controller, balance);
700         ClaimedTokens(_token, controller, balance);
701     }
702 
703 ////////////////
704 // Events
705 ////////////////
706     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
707     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
708     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
709     event Approval(
710         address indexed _owner,
711         address indexed _spender,
712         uint256 _amount
713         );
714 
715 }
716 
717 
718 ////////////////
719 // MiniMeTokenFactory
720 ////////////////
721 
722 /// @dev This contract is used to generate clone contracts from a contract.
723 ///  In solidity this is the way to create a contract from a contract of the
724 ///  same class
725 contract MiniMeTokenFactory {
726 
727     /// @notice Update the DApp by creating a new token with new functionalities
728     ///  the msg.sender becomes the controller of this clone token
729     /// @param _parentToken Address of the token being cloned
730     /// @param _snapshotBlock Block of the parent token that will
731     ///  determine the initial distribution of the clone token
732     /// @param _tokenName Name of the new token
733     /// @param _decimalUnits Number of decimals of the new token
734     /// @param _tokenSymbol Token Symbol for the new token
735     /// @param _transfersEnabled If true, tokens will be able to be transferred
736     /// @return The address of the new token contract
737     function createCloneToken(
738         address _parentToken,
739         uint _snapshotBlock,
740         string _tokenName,
741         uint8 _decimalUnits,
742         string _tokenSymbol,
743         bool _transfersEnabled
744     ) public returns (Pinakion) {
745         Pinakion newToken = new Pinakion(
746             this,
747             _parentToken,
748             _snapshotBlock,
749             _tokenName,
750             _decimalUnits,
751             _tokenSymbol,
752             _transfersEnabled
753             );
754 
755         newToken.changeController(msg.sender);
756         return newToken;
757     }
758 }
759 
760 contract RNG{
761 
762     /** @dev Contribute to the reward of a random number.
763      *  @param _block Block the random number is linked to.
764      */
765     function contribute(uint _block) public payable;
766 
767     /** @dev Request a random number.
768      *  @param _block Block linked to the request.
769      */
770     function requestRN(uint _block) public payable {
771         contribute(_block);
772     }
773 
774     /** @dev Get the random number.
775      *  @param _block Block the random number is linked to.
776      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
777      */
778     function getRN(uint _block) public returns (uint RN);
779 
780     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
781      *  This is to prevent users from getting correlated numbers.
782      *  @param _block Block the random number is linked to.
783      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
784      */
785     function getUncorrelatedRN(uint _block) public returns (uint RN) {
786         uint baseRN=getRN(_block);
787         if (baseRN==0)
788             return 0;
789         else
790             return uint(keccak256(msg.sender,baseRN));
791     }
792 
793  }
794 
795 /** Simple Random Number Generator returning the blockhash.
796  *  Allows saving the random number for use in the future.
797  *  It allows the contract to still access the blockhash even after 256 blocks.
798  *  The first party to call the save function gets the reward.
799  */
800 contract BlockHashRNG is RNG {
801 
802     mapping (uint => uint) public randomNumber; // randomNumber[block] is the random number for this block, 0 otherwise.
803     mapping (uint => uint) public reward; // reward[block] is the amount to be paid to the party w.
804 
805 
806 
807     /** @dev Contribute to the reward of a random number.
808      *  @param _block Block the random number is linked to.
809      */
810     function contribute(uint _block) public payable { reward[_block]+=msg.value; }
811 
812 
813     /** @dev Return the random number. If it has not been saved and is still computable compute it.
814      *  @param _block Block the random number is linked to.
815      *  @return RN Random Number. If the number is not ready or has not been requested 0 instead.
816      */
817     function getRN(uint _block) public returns (uint RN) {
818         RN=randomNumber[_block];
819         if (RN==0){
820             saveRN(_block);
821             return randomNumber[_block];
822         }
823         else
824             return RN;
825     }
826 
827     /** @dev Save the random number for this blockhash and give the reward to the caller.
828      *  @param _block Block the random number is linked to.
829      */
830     function saveRN(uint _block) public {
831         if (blockhash(_block) != 0x0)
832             randomNumber[_block] = uint(blockhash(_block));
833         if (randomNumber[_block] != 0) { // If the number is set.
834             uint rewardToSend = reward[_block];
835             reward[_block] = 0;
836             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
837         }
838     }
839 
840 }
841 
842 
843 /** Random Number Generator returning the blockhash with a backup behaviour.
844  *  Allows saving the random number for use in the future. 
845  *  It allows the contract to still access the blockhash even after 256 blocks.
846  *  The first party to call the save function gets the reward.
847  *  If no one calls the contract within 256 blocks, the contract fallback in returning the blockhash of the previous block.
848  */
849 contract BlockHashRNGFallback is BlockHashRNG {
850     
851     /** @dev Save the random number for this blockhash and give the reward to the caller.
852      *  @param _block Block the random number is linked to.
853      */
854     function saveRN(uint _block) public {
855         if (_block<block.number && randomNumber[_block]==0) {// If the random number is not already set and can be.
856             if (blockhash(_block)!=0x0) // Normal case.
857                 randomNumber[_block]=uint(blockhash(_block));
858             else // The contract was not called in time. Fallback to returning previous blockhash.
859                 randomNumber[_block]=uint(blockhash(block.number-1));
860         }
861         if (randomNumber[_block] != 0) { // If the random number is set.
862             uint rewardToSend=reward[_block];
863             reward[_block]=0;
864             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case the msg.sender has a fallback issue.
865         }
866     }
867     
868 }
869 
870 /** @title Arbitrable
871  *  Arbitrable abstract contract.
872  *  When developing arbitrable contracts, we need to:
873  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
874  *  -Allow dispute creation. For this a function must:
875  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
876  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
877  */
878 contract Arbitrable{
879     Arbitrator public arbitrator;
880     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
881 
882     modifier onlyArbitrator {require(msg.sender==address(arbitrator)); _;}
883 
884     /** @dev To be raised when a ruling is given.
885      *  @param _arbitrator The arbitrator giving the ruling.
886      *  @param _disputeID ID of the dispute in the Arbitrator contract.
887      *  @param _ruling The ruling which was given.
888      */
889     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
890 
891     /** @dev To be emmited when meta-evidence is submitted.
892      *  @param _metaEvidenceID Unique identifier of meta-evidence.
893      *  @param _evidence A link to the meta-evidence JSON.
894      */
895     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
896 
897     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
898      *  @param _arbitrator The arbitrator of the contract.
899      *  @param _disputeID ID of the dispute in the Arbitrator contract.
900      *  @param _metaEvidenceID Unique identifier of meta-evidence.
901      */
902     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID);
903 
904     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
905      *  @param _arbitrator The arbitrator of the contract.
906      *  @param _disputeID ID of the dispute in the Arbitrator contract.
907      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
908      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
909      */
910     event Evidence(Arbitrator indexed _arbitrator, uint indexed _disputeID, address _party, string _evidence);
911 
912     /** @dev Constructor. Choose the arbitrator.
913      *  @param _arbitrator The arbitrator of the contract.
914      *  @param _arbitratorExtraData Extra data for the arbitrator.
915      */
916     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
917         arbitrator = _arbitrator;
918         arbitratorExtraData = _arbitratorExtraData;
919     }
920 
921     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
922      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
923      *  @param _disputeID ID of the dispute in the Arbitrator contract.
924      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
925      */
926     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
927         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
928 
929         executeRuling(_disputeID,_ruling);
930     }
931 
932 
933     /** @dev Execute a ruling of a dispute.
934      *  @param _disputeID ID of the dispute in the Arbitrator contract.
935      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
936      */
937     function executeRuling(uint _disputeID, uint _ruling) internal;
938 }
939 
940 /** @title Arbitrator
941  *  Arbitrator abstract contract.
942  *  When developing arbitrator contracts we need to:
943  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
944  *  -Define the functions for cost display (arbitrationCost and appealCost).
945  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
946  */
947 contract Arbitrator{
948 
949     enum DisputeStatus {Waiting, Appealable, Solved}
950 
951     modifier requireArbitrationFee(bytes _extraData) {require(msg.value>=arbitrationCost(_extraData)); _;}
952     modifier requireAppealFee(uint _disputeID, bytes _extraData) {require(msg.value>=appealCost(_disputeID, _extraData)); _;}
953 
954     /** @dev To be raised when a dispute can be appealed.
955      *  @param _disputeID ID of the dispute.
956      */
957     event AppealPossible(uint _disputeID);
958 
959     /** @dev To be raised when a dispute is created.
960      *  @param _disputeID ID of the dispute.
961      *  @param _arbitrable The contract which created the dispute.
962      */
963     event DisputeCreation(uint indexed _disputeID, Arbitrable _arbitrable);
964 
965     /** @dev To be raised when the current ruling is appealed.
966      *  @param _disputeID ID of the dispute.
967      *  @param _arbitrable The contract which created the dispute.
968      */
969     event AppealDecision(uint indexed _disputeID, Arbitrable _arbitrable);
970 
971     /** @dev Create a dispute. Must be called by the arbitrable contract.
972      *  Must be paid at least arbitrationCost(_extraData).
973      *  @param _choices Amount of choices the arbitrator can make in this dispute.
974      *  @param _extraData Can be used to give additional info on the dispute to be created.
975      *  @return disputeID ID of the dispute created.
976      */
977     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID)  {}
978 
979     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
980      *  @param _extraData Can be used to give additional info on the dispute to be created.
981      *  @return fee Amount to be paid.
982      */
983     function arbitrationCost(bytes _extraData) public constant returns(uint fee);
984 
985     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
986      *  @param _disputeID ID of the dispute to be appealed.
987      *  @param _extraData Can be used to give extra info on the appeal.
988      */
989     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
990         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
991     }
992 
993     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
994      *  @param _disputeID ID of the dispute to be appealed.
995      *  @param _extraData Can be used to give additional info on the dispute to be created.
996      *  @return fee Amount to be paid.
997      */
998     function appealCost(uint _disputeID, bytes _extraData) public constant returns(uint fee);
999 
1000     /** @dev Return the status of a dispute.
1001      *  @param _disputeID ID of the dispute to rule.
1002      *  @return status The status of the dispute.
1003      */
1004     function disputeStatus(uint _disputeID) public constant returns(DisputeStatus status);
1005 
1006     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1007      *  @param _disputeID ID of the dispute.
1008      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
1009      */
1010     function currentRuling(uint _disputeID) public constant returns(uint ruling);
1011 
1012 }
1013 
1014 
1015 
1016 contract Kleros is Arbitrator, ApproveAndCallFallBack {
1017 
1018     // **************************** //
1019     // *    Contract variables    * //
1020     // **************************** //
1021 
1022     // Variables which should not change after initialization.
1023     Pinakion public pinakion;
1024     uint public constant NON_PAYABLE_AMOUNT = (2**256 - 2) / 2; // An astronomic amount, practically can't be paid.
1025 
1026     // Variables which will subject to the governance mechanism.
1027     // Note they will only be able to be changed during the activation period (because a session assumes they don't change after it).
1028     RNG public rng; // Random Number Generator used to draw jurors.
1029     uint public arbitrationFeePerJuror = 0.05 ether; // The fee which will be paid to each juror.
1030     uint16 public defaultNumberJuror = 3; // Number of drawn jurors unless specified otherwise.
1031     uint public minActivatedToken = 0.1 * 1e18; // Minimum of tokens to be activated (in basic units).
1032     uint[5] public timePerPeriod; // The minimum time each period lasts (seconds).
1033     uint public alpha = 2000; // alpha in ‱ (1 / 10 000).
1034     uint constant ALPHA_DIVISOR = 1e4; // Amount we need to divided alpha in ‱ to get the float value of alpha.
1035     uint public maxAppeals = 5; // Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1036     // Initially, the governor will be an address controlled by the Kleros team. At a later stage,
1037     // the governor will be switched to a governance contract with liquid voting.
1038     address public governor; // Address of the governor contract.
1039 
1040     // Variables changing during day to day interaction.
1041     uint public session = 1;      // Current session of the court.
1042     uint public lastPeriodChange; // The last time we changed of period (seconds).
1043     uint public segmentSize;      // Size of the segment of activated tokens.
1044     uint public rnBlock;          // The block linked with the RN which is requested.
1045     uint public randomNumber;     // Random number of the session.
1046 
1047     enum Period {
1048         Activation, // When juror can deposit their tokens and parties give evidences.
1049         Draw,       // When jurors are drawn at random, note that this period is fast.
1050         Vote,       // Where jurors can vote on disputes.
1051         Appeal,     // When parties can appeal the rulings.
1052         Execution   // When where token redistribution occurs and Kleros call the arbitrated contracts.
1053     }
1054 
1055     Period public period;
1056 
1057     struct Juror {
1058         uint balance;      // The amount of tokens the contract holds for this juror.
1059         uint atStake;      // Total number of tokens the jurors can loose in disputes they are drawn in. Those tokens are locked. Note that we can have atStake > balance but it should be statistically unlikely and does not pose issues.
1060         uint lastSession;  // Last session the tokens were activated.
1061         uint segmentStart; // Start of the segment of activated tokens.
1062         uint segmentEnd;   // End of the segment of activated tokens.
1063     }
1064 
1065     mapping (address => Juror) public jurors;
1066 
1067     struct Vote {
1068         address account; // The juror who casted the vote.
1069         uint ruling;     // The ruling which was given.
1070     }
1071 
1072     struct VoteCounter {
1073         uint winningChoice; // The choice which currently has the highest amount of votes. Is 0 in case of a tie.
1074         uint winningCount;  // The number of votes for winningChoice. Or for the choices which are tied.
1075         mapping (uint => uint) voteCount; // voteCount[choice] is the number of votes for choice.
1076     }
1077 
1078     enum DisputeState {
1079         Open,       // The dispute is opened but the outcome is not available yet (this include when jurors voted but appeal is still possible).
1080         Resolving,  // The token repartition has started. Note that if it's done in just one call, this state is skipped.
1081         Executable, // The arbitrated contract can be called to enforce the decision.
1082         Executed    // Everything has been done and the dispute can't be interacted with anymore.
1083     }
1084 
1085     struct Dispute {
1086         Arbitrable arbitrated;       // Contract to be arbitrated.
1087         uint session;                // First session the dispute was schedule.
1088         uint appeals;                // Number of appeals.
1089         uint choices;                // The number of choices available to the jurors.
1090         uint16 initialNumberJurors;  // The initial number of jurors.
1091         uint arbitrationFeePerJuror; // The fee which will be paid to each juror.
1092         DisputeState state;          // The state of the dispute.
1093         Vote[][] votes;              // The votes in the form vote[appeals][voteID].
1094         VoteCounter[] voteCounter;   // The vote counters in the form voteCounter[appeals].
1095         mapping (address => uint) lastSessionVote; // Last session a juror has voted on this dispute. Is 0 if he never did.
1096         uint currentAppealToRepartition; // The current appeal we are repartitioning.
1097         AppealsRepartitioned[] appealsRepartitioned; // Track a partially repartitioned appeal in the form AppealsRepartitioned[appeal].
1098     }
1099 
1100     enum RepartitionStage { // State of the token repartition if oneShotTokenRepartition would throw because there are too many votes.
1101         Incoherent,
1102         Coherent,
1103         AtStake,
1104         Complete
1105     }
1106 
1107     struct AppealsRepartitioned {
1108         uint totalToRedistribute;   // Total amount of tokens we have to redistribute.
1109         uint nbCoherent;            // Number of coherent jurors for session.
1110         uint currentIncoherentVote; // Current vote for the incoherent loop.
1111         uint currentCoherentVote;   // Current vote we need to count.
1112         uint currentAtStakeVote;    // Current vote we need to count.
1113         RepartitionStage stage;     // Use with multipleShotTokenRepartition if oneShotTokenRepartition would throw.
1114     }
1115 
1116     Dispute[] public disputes;
1117 
1118     // **************************** //
1119     // *          Events          * //
1120     // **************************** //
1121 
1122     /** @dev Emitted when we pass to a new period.
1123      *  @param _period The new period.
1124      *  @param _session The current session.
1125      */
1126     event NewPeriod(Period _period, uint indexed _session);
1127 
1128     /** @dev Emitted when a juror wins or loses tokens.
1129       * @param _account The juror affected.
1130       * @param _disputeID The ID of the dispute.
1131       * @param _amount The amount of parts of token which was won. Can be negative for lost amounts.
1132       */
1133     event TokenShift(address indexed _account, uint _disputeID, int _amount);
1134 
1135     /** @dev Emited when a juror wins arbitration fees.
1136       * @param _account The account affected.
1137       * @param _disputeID The ID of the dispute.
1138       * @param _amount The amount of weis which was won.
1139       */
1140     event ArbitrationReward(address indexed _account, uint _disputeID, uint _amount);
1141 
1142     // **************************** //
1143     // *         Modifiers        * //
1144     // **************************** //
1145     modifier onlyBy(address _account) {require(msg.sender == _account); _;}
1146     modifier onlyDuring(Period _period) {require(period == _period); _;}
1147     modifier onlyGovernor() {require(msg.sender == governor); _;}
1148 
1149 
1150     /** @dev Constructor.
1151      *  @param _pinakion The address of the pinakion contract.
1152      *  @param _rng The random number generator which will be used.
1153      *  @param _timePerPeriod The minimal time for each period (seconds).
1154      *  @param _governor Address of the governor contract.
1155      */
1156     constructor(Pinakion _pinakion, RNG _rng, uint[5] _timePerPeriod, address _governor) public {
1157         pinakion = _pinakion;
1158         rng = _rng;
1159         lastPeriodChange = now;
1160         timePerPeriod = _timePerPeriod;
1161         governor = _governor;
1162     }
1163 
1164     // **************************** //
1165     // *  Functions interacting   * //
1166     // *  with Pinakion contract  * //
1167     // **************************** //
1168 
1169     /** @dev Callback of approveAndCall - transfer pinakions of a juror in the contract. Should be called by the pinakion contract. TRUSTED.
1170      *  @param _from The address making the transfer.
1171      *  @param _amount Amount of tokens to transfer to Kleros (in basic units).
1172      */
1173     function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
1174         require(pinakion.transferFrom(_from, this, _amount));
1175 
1176         jurors[_from].balance += _amount;
1177     }
1178 
1179     /** @dev Withdraw tokens. Note that we can't withdraw the tokens which are still atStake. 
1180      *  Jurors can't withdraw their tokens if they have deposited some during this session.
1181      *  This is to prevent jurors from withdrawing tokens they could loose.
1182      *  @param _value The amount to withdraw.
1183      */
1184     function withdraw(uint _value) public {
1185         Juror storage juror = jurors[msg.sender];
1186         require(juror.atStake <= juror.balance); // Make sure that there is no more at stake than owned to avoid overflow.
1187         require(_value <= juror.balance-juror.atStake);
1188         require(juror.lastSession != session);
1189 
1190         juror.balance -= _value;
1191         require(pinakion.transfer(msg.sender,_value));
1192     }
1193 
1194     // **************************** //
1195     // *      Court functions     * //
1196     // *    Modifying the state   * //
1197     // **************************** //
1198 
1199     /** @dev To call to go to a new period. TRUSTED.
1200      */
1201     function passPeriod() public {
1202         require(now-lastPeriodChange >= timePerPeriod[uint8(period)]);
1203 
1204         if (period == Period.Activation) {
1205             rnBlock = block.number + 1;
1206             rng.requestRN(rnBlock);
1207             period = Period.Draw;
1208         } else if (period == Period.Draw) {
1209             randomNumber = rng.getUncorrelatedRN(rnBlock);
1210             require(randomNumber != 0);
1211             period = Period.Vote;
1212         } else if (period == Period.Vote) {
1213             period = Period.Appeal;
1214         } else if (period == Period.Appeal) {
1215             period = Period.Execution;
1216         } else if (period == Period.Execution) {
1217             period = Period.Activation;
1218             ++session;
1219             segmentSize = 0;
1220             rnBlock = 0;
1221             randomNumber = 0;
1222         }
1223 
1224 
1225         lastPeriodChange = now;
1226         NewPeriod(period, session);
1227     }
1228 
1229 
1230     /** @dev Deposit tokens in order to have chances of being drawn. Note that once tokens are deposited, 
1231      *  there is no possibility of depositing more.
1232      *  @param _value Amount of tokens (in basic units) to deposit.
1233      */
1234     function activateTokens(uint _value) public onlyDuring(Period.Activation) {
1235         Juror storage juror = jurors[msg.sender];
1236         require(_value <= juror.balance);
1237         require(_value >= minActivatedToken);
1238         require(juror.lastSession != session); // Verify that tokens were not already activated for this session.
1239 
1240         juror.lastSession = session;
1241         juror.segmentStart = segmentSize;
1242         segmentSize += _value;
1243         juror.segmentEnd = segmentSize;
1244 
1245     }
1246 
1247     /** @dev Vote a ruling. Juror must input the draw ID he was drawn.
1248      *  Note that the complexity is O(d), where d is amount of times the juror was drawn.
1249      *  Since being drawn multiple time is a rare occurrence and that a juror can always vote with less weight than it has, it is not a problem.
1250      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1251      *  @param _disputeID The ID of the dispute the juror was drawn.
1252      *  @param _ruling The ruling given.
1253      *  @param _draws The list of draws the juror was drawn. Draw numbering starts at 1 and the numbers should be increasing.
1254      */
1255     function voteRuling(uint _disputeID, uint _ruling, uint[] _draws) public onlyDuring(Period.Vote) {
1256         Dispute storage dispute = disputes[_disputeID];
1257         Juror storage juror = jurors[msg.sender];
1258         VoteCounter storage voteCounter = dispute.voteCounter[dispute.appeals];
1259         require(dispute.lastSessionVote[msg.sender] != session); // Make sure juror hasn't voted yet.
1260         require(_ruling <= dispute.choices);
1261         // Note that it throws if the draws are incorrect.
1262         require(validDraws(msg.sender, _disputeID, _draws));
1263 
1264         dispute.lastSessionVote[msg.sender] = session;
1265         voteCounter.voteCount[_ruling] += _draws.length;
1266         if (voteCounter.winningCount < voteCounter.voteCount[_ruling]) {
1267             voteCounter.winningCount = voteCounter.voteCount[_ruling];
1268             voteCounter.winningChoice = _ruling;
1269         } else if (voteCounter.winningCount==voteCounter.voteCount[_ruling] && _draws.length!=0) { // Verify draw length to be non-zero to avoid the possibility of setting tie by casting 0 votes.
1270             voteCounter.winningChoice = 0; // It's currently a tie.
1271         }
1272         for (uint i = 0; i < _draws.length; ++i) {
1273             dispute.votes[dispute.appeals].push(Vote({
1274                 account: msg.sender,
1275                 ruling: _ruling
1276             }));
1277         }
1278 
1279         juror.atStake += _draws.length * getStakePerDraw();
1280         uint feeToPay = _draws.length * dispute.arbitrationFeePerJuror;
1281         msg.sender.transfer(feeToPay);
1282         ArbitrationReward(msg.sender, _disputeID, feeToPay);
1283     }
1284 
1285     /** @dev Steal part of the tokens and the arbitration fee of a juror who failed to vote.
1286      *  Note that a juror who voted but without all his weight can't be penalized.
1287      *  It is possible to not penalize with the maximum weight.
1288      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1289      *  @param _jurorAddress Address of the juror to steal tokens from.
1290      *  @param _disputeID The ID of the dispute the juror was drawn.
1291      *  @param _draws The list of draws the juror was drawn. Numbering starts at 1 and the numbers should be increasing.
1292      */
1293     function penalizeInactiveJuror(address _jurorAddress, uint _disputeID, uint[] _draws) public {
1294         Dispute storage dispute = disputes[_disputeID];
1295         Juror storage inactiveJuror = jurors[_jurorAddress];
1296         require(period > Period.Vote);
1297         require(dispute.lastSessionVote[_jurorAddress] != session); // Verify the juror hasn't voted.
1298         dispute.lastSessionVote[_jurorAddress] = session; // Update last session to avoid penalizing multiple times.
1299         require(validDraws(_jurorAddress, _disputeID, _draws));
1300         uint penality = _draws.length * minActivatedToken * 2 * alpha / ALPHA_DIVISOR;
1301         penality = (penality < inactiveJuror.balance) ? penality : inactiveJuror.balance; // Make sure the penality is not higher than the balance.
1302         inactiveJuror.balance -= penality;
1303         TokenShift(_jurorAddress, _disputeID, -int(penality));
1304         jurors[msg.sender].balance += penality / 2; // Give half of the penalty to the caller.
1305         TokenShift(msg.sender, _disputeID, int(penality / 2));
1306         jurors[governor].balance += penality / 2; // The other half to the governor.
1307         TokenShift(governor, _disputeID, int(penality / 2));
1308         msg.sender.transfer(_draws.length*dispute.arbitrationFeePerJuror); // Give the arbitration fees to the caller.
1309     }
1310 
1311     /** @dev Execute all the token repartition.
1312      *  Note that this function could consume to much gas if there is too much votes. 
1313      *  It is O(v), where v is the number of votes for this dispute.
1314      *  In the next version, there will also be a function to execute it in multiple calls 
1315      *  (but note that one shot execution, if possible, is less expensive).
1316      *  @param _disputeID ID of the dispute.
1317      */
1318     function oneShotTokenRepartition(uint _disputeID) public onlyDuring(Period.Execution) {
1319         Dispute storage dispute = disputes[_disputeID];
1320         require(dispute.state == DisputeState.Open);
1321         require(dispute.session+dispute.appeals <= session);
1322 
1323         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1324         uint amountShift = getStakePerDraw();
1325         for (uint i = 0; i <= dispute.appeals; ++i) {
1326             // If the result is not a tie, some parties are incoherent. Note that 0 (refuse to arbitrate) winning is not a tie.
1327             // Result is a tie if the winningChoice is 0 (refuse to arbitrate) and the choice 0 is not the most voted choice.
1328             // Note that in case of a "tie" among some choices including 0, parties who did not vote 0 are considered incoherent.
1329             if (winningChoice!=0 || (dispute.voteCounter[dispute.appeals].voteCount[0] == dispute.voteCounter[dispute.appeals].winningCount)) {
1330                 uint totalToRedistribute = 0;
1331                 uint nbCoherent = 0;
1332                 // First loop to penalize the incoherent votes.
1333                 for (uint j = 0; j < dispute.votes[i].length; ++j) {
1334                     Vote storage vote = dispute.votes[i][j];
1335                     if (vote.ruling != winningChoice) {
1336                         Juror storage juror = jurors[vote.account];
1337                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1338                         juror.balance -= penalty;
1339                         TokenShift(vote.account, _disputeID, int(-penalty));
1340                         totalToRedistribute += penalty;
1341                     } else {
1342                         ++nbCoherent;
1343                     }
1344                 }
1345                 if (nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1346                     jurors[governor].balance += totalToRedistribute;
1347                     TokenShift(governor, _disputeID, int(totalToRedistribute));
1348                 } else { // otherwise, redistribute them.
1349                     uint toRedistribute = totalToRedistribute / nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1350                     // Second loop to redistribute.
1351                     for (j = 0; j < dispute.votes[i].length; ++j) {
1352                         vote = dispute.votes[i][j];
1353                         if (vote.ruling == winningChoice) {
1354                             juror = jurors[vote.account];
1355                             juror.balance += toRedistribute;
1356                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1357                         }
1358                     }
1359                 }
1360             }
1361             // Third loop to lower the atStake in order to unlock tokens.
1362             for (j = 0; j < dispute.votes[i].length; ++j) {
1363                 vote = dispute.votes[i][j];
1364                 juror = jurors[vote.account];
1365                 juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1366             }
1367         }
1368         dispute.state = DisputeState.Executable; // Since it was solved in one shot, go directly to the executable step.
1369     }
1370 
1371     /** @dev Execute token repartition on a dispute for a specific number of votes.
1372      *  This should only be called if oneShotTokenRepartition will throw because there are too many votes (will use too much gas).
1373      *  Note that There are 3 iterations per vote. e.g. A dispute with 1 appeal (2 sessions) and 3 votes per session will have 18 iterations
1374      *  @param _disputeID ID of the dispute.
1375      *  @param _maxIterations the maxium number of votes to repartition in this iteration
1376      */
1377     function multipleShotTokenRepartition(uint _disputeID, uint _maxIterations) public onlyDuring(Period.Execution) {
1378         Dispute storage dispute = disputes[_disputeID];
1379         require(dispute.state <= DisputeState.Resolving);
1380         require(dispute.session+dispute.appeals <= session);
1381         dispute.state = DisputeState.Resolving; // Mark as resolving so oneShotTokenRepartition cannot be called on dispute.
1382 
1383         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1384         uint amountShift = getStakePerDraw();
1385         uint currentIterations = 0; // Total votes we have repartitioned this iteration.
1386         for (uint i = dispute.currentAppealToRepartition; i <= dispute.appeals; ++i) {
1387             // Allocate space for new AppealsRepartitioned.
1388             if (dispute.appealsRepartitioned.length < i+1) {
1389                 dispute.appealsRepartitioned.length++;
1390             }
1391 
1392             // If the result is a tie, no parties are incoherent and no need to move tokens. Note that 0 (refuse to arbitrate) winning is not a tie.
1393             if (winningChoice==0 && (dispute.voteCounter[dispute.appeals].voteCount[0] != dispute.voteCounter[dispute.appeals].winningCount)) {
1394                 // If ruling is a tie we can skip to at stake.
1395                 dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1396             }
1397 
1398             // First loop to penalize the incoherent votes.
1399             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Incoherent) {
1400                 for (uint j = dispute.appealsRepartitioned[i].currentIncoherentVote; j < dispute.votes[i].length; ++j) {
1401                     if (currentIterations >= _maxIterations) {
1402                         return;
1403                     }
1404                     Vote storage vote = dispute.votes[i][j];
1405                     if (vote.ruling != winningChoice) {
1406                         Juror storage juror = jurors[vote.account];
1407                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1408                         juror.balance -= penalty;
1409                         TokenShift(vote.account, _disputeID, int(-penalty));
1410                         dispute.appealsRepartitioned[i].totalToRedistribute += penalty;
1411                     } else {
1412                         ++dispute.appealsRepartitioned[i].nbCoherent;
1413                     }
1414 
1415                     ++dispute.appealsRepartitioned[i].currentIncoherentVote;
1416                     ++currentIterations;
1417                 }
1418 
1419                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Coherent;
1420             }
1421 
1422             // Second loop to reward coherent voters
1423             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Coherent) {
1424                 if (dispute.appealsRepartitioned[i].nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1425                     jurors[governor].balance += dispute.appealsRepartitioned[i].totalToRedistribute;
1426                     TokenShift(governor, _disputeID, int(dispute.appealsRepartitioned[i].totalToRedistribute));
1427                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1428                 } else { // Otherwise, redistribute them.
1429                     uint toRedistribute = dispute.appealsRepartitioned[i].totalToRedistribute / dispute.appealsRepartitioned[i].nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1430                     // Second loop to redistribute.
1431                     for (j = dispute.appealsRepartitioned[i].currentCoherentVote; j < dispute.votes[i].length; ++j) {
1432                         if (currentIterations >= _maxIterations) {
1433                             return;
1434                         }
1435                         vote = dispute.votes[i][j];
1436                         if (vote.ruling == winningChoice) {
1437                             juror = jurors[vote.account];
1438                             juror.balance += toRedistribute;
1439                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1440                         }
1441 
1442                         ++currentIterations;
1443                         ++dispute.appealsRepartitioned[i].currentCoherentVote;
1444                     }
1445 
1446                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1447                 }
1448             }
1449 
1450             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.AtStake) {
1451                 // Third loop to lower the atStake in order to unlock tokens.
1452                 for (j = dispute.appealsRepartitioned[i].currentAtStakeVote; j < dispute.votes[i].length; ++j) {
1453                     if (currentIterations >= _maxIterations) {
1454                         return;
1455                     }
1456                     vote = dispute.votes[i][j];
1457                     juror = jurors[vote.account];
1458                     juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1459 
1460                     ++currentIterations;
1461                     ++dispute.appealsRepartitioned[i].currentAtStakeVote;
1462                 }
1463 
1464                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Complete;
1465             }
1466 
1467             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Complete) {
1468                 ++dispute.currentAppealToRepartition;
1469             }
1470         }
1471 
1472         dispute.state = DisputeState.Executable;
1473     }
1474 
1475     // **************************** //
1476     // *      Court functions     * //
1477     // *     Constant and Pure    * //
1478     // **************************** //
1479 
1480     /** @dev Return the amount of jurors which are or will be drawn in the dispute.
1481      *  The number of jurors is doubled and 1 is added at each appeal. We have proven the formula by recurrence.
1482      *  This avoid having a variable number of jurors which would be updated in order to save gas.
1483      *  @param _disputeID The ID of the dispute we compute the amount of jurors.
1484      *  @return nbJurors The number of jurors which are drawn.
1485      */
1486     function amountJurors(uint _disputeID) public view returns (uint nbJurors) {
1487         Dispute storage dispute = disputes[_disputeID];
1488         return (dispute.initialNumberJurors + 1) * 2**dispute.appeals - 1;
1489     }
1490 
1491     /** @dev Must be used to verify that a juror has been draw at least _draws.length times.
1492      *  We have to require the user to specify the draws that lead the juror to be drawn.
1493      *  Because doing otherwise (looping through all draws) could consume too much gas.
1494      *  @param _jurorAddress Address of the juror we want to verify draws.
1495      *  @param _disputeID The ID of the dispute the juror was drawn.
1496      *  @param _draws The list of draws the juror was drawn. It draw numbering starts at 1 and the numbers should be increasing.
1497      *  Note that in most cases this list will just contain 1 number.
1498      *  @param valid true if the draws are valid.
1499      */
1500     function validDraws(address _jurorAddress, uint _disputeID, uint[] _draws) public view returns (bool valid) {
1501         uint draw = 0;
1502         Juror storage juror = jurors[_jurorAddress];
1503         Dispute storage dispute = disputes[_disputeID];
1504         uint nbJurors = amountJurors(_disputeID);
1505 
1506         if (juror.lastSession != session) return false; // Make sure that the tokens were deposited for this session.
1507         if (dispute.session+dispute.appeals != session) return false; // Make sure there is currently a dispute.
1508         if (period <= Period.Draw) return false; // Make sure that jurors are already drawn.
1509         for (uint i = 0; i < _draws.length; ++i) {
1510             if (_draws[i] <= draw) return false; // Make sure that draws are always increasing to avoid someone inputing the same multiple times.
1511             draw = _draws[i];
1512             if (draw > nbJurors) return false;
1513             uint position = uint(keccak256(randomNumber, _disputeID, draw)) % segmentSize; // Random position on the segment for draw.
1514             require(position >= juror.segmentStart);
1515             require(position < juror.segmentEnd);
1516         }
1517 
1518         return true;
1519     }
1520 
1521     // **************************** //
1522     // *   Arbitrator functions   * //
1523     // *   Modifying the state    * //
1524     // **************************** //
1525 
1526     /** @dev Create a dispute. Must be called by the arbitrable contract.
1527      *  Must be paid at least arbitrationCost().
1528      *  @param _choices Amount of choices the arbitrator can make in this dispute.
1529      *  @param _extraData Null for the default number. Otherwise, first 16 bytes will be used to return the number of jurors.
1530      *  @return disputeID ID of the dispute created.
1531      */
1532     function createDispute(uint _choices, bytes _extraData) public payable returns (uint disputeID) {
1533         uint16 nbJurors = extraDataToNbJurors(_extraData);
1534         require(msg.value >= arbitrationCost(_extraData));
1535 
1536         disputeID = disputes.length++;
1537         Dispute storage dispute = disputes[disputeID];
1538         dispute.arbitrated = Arbitrable(msg.sender);
1539         if (period < Period.Draw) // If drawing did not start schedule it for the current session.
1540             dispute.session = session;
1541         else // Otherwise schedule it for the next one.
1542             dispute.session = session+1;
1543         dispute.choices = _choices;
1544         dispute.initialNumberJurors = nbJurors;
1545         dispute.arbitrationFeePerJuror = arbitrationFeePerJuror; // We store it as the general fee can be changed through the governance mechanism.
1546         dispute.votes.length++;
1547         dispute.voteCounter.length++;
1548 
1549         DisputeCreation(disputeID, Arbitrable(msg.sender));
1550         return disputeID;
1551     }
1552 
1553     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
1554      *  @param _disputeID ID of the dispute to be appealed.
1555      *  @param _extraData Standard but not used by this contract.
1556      */
1557     function appeal(uint _disputeID, bytes _extraData) public payable onlyDuring(Period.Appeal) {
1558         super.appeal(_disputeID,_extraData);
1559         Dispute storage dispute = disputes[_disputeID];
1560         require(msg.value >= appealCost(_disputeID, _extraData));
1561         require(dispute.session+dispute.appeals == session); // Dispute of the current session.
1562         require(dispute.arbitrated == msg.sender);
1563         
1564         dispute.appeals++;
1565         dispute.votes.length++;
1566         dispute.voteCounter.length++;
1567     }
1568 
1569     /** @dev Execute the ruling of a dispute which is in the state executable. UNTRUSTED.
1570      *  @param disputeID ID of the dispute to execute the ruling.
1571      */
1572     function executeRuling(uint disputeID) public {
1573         Dispute storage dispute = disputes[disputeID];
1574         require(dispute.state == DisputeState.Executable);
1575 
1576         dispute.state = DisputeState.Executed;
1577         dispute.arbitrated.rule(disputeID, dispute.voteCounter[dispute.appeals].winningChoice);
1578     }
1579 
1580     // **************************** //
1581     // *   Arbitrator functions   * //
1582     // *    Constant and pure     * //
1583     // **************************** //
1584 
1585     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, 
1586      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1587      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1588      *  @return fee Amount to be paid.
1589      */
1590     function arbitrationCost(bytes _extraData) public view returns (uint fee) {
1591         return extraDataToNbJurors(_extraData) * arbitrationFeePerJuror;
1592     }
1593 
1594     /** @dev Compute the cost of appeal. It is recommended not to increase it often, 
1595      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1596      *  @param _disputeID ID of the dispute to be appealed.
1597      *  @param _extraData Is not used there.
1598      *  @return fee Amount to be paid.
1599      */
1600     function appealCost(uint _disputeID, bytes _extraData) public view returns (uint fee) {
1601         Dispute storage dispute = disputes[_disputeID];
1602 
1603         if(dispute.appeals >= maxAppeals) return NON_PAYABLE_AMOUNT;
1604 
1605         return (2*amountJurors(_disputeID) + 1) * dispute.arbitrationFeePerJuror;
1606     }
1607 
1608     /** @dev Compute the amount of jurors to be drawn.
1609      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1610      *  Note that it does not check that the number of jurors is odd, but users are advised to choose a odd number of jurors.
1611      */
1612     function extraDataToNbJurors(bytes _extraData) internal view returns (uint16 nbJurors) {
1613         if (_extraData.length < 2)
1614             return defaultNumberJuror;
1615         else
1616             return (uint16(_extraData[0]) << 8) + uint16(_extraData[1]);
1617     }
1618 
1619     /** @dev Compute the minimum activated pinakions in alpha.
1620      *  Note there may be multiple draws for a single user on a single dispute.
1621      */
1622     function getStakePerDraw() public view returns (uint minActivatedTokenInAlpha) {
1623         return (alpha * minActivatedToken) / ALPHA_DIVISOR;
1624     }
1625 
1626 
1627     // **************************** //
1628     // *     Constant getters     * //
1629     // **************************** //
1630 
1631     /** @dev Getter for account in Vote.
1632      *  @param _disputeID ID of the dispute.
1633      *  @param _appeals Which appeal (or 0 for the initial session).
1634      *  @param _voteID The ID of the vote for this appeal (or initial session).
1635      *  @return account The address of the voter.
1636      */
1637     function getVoteAccount(uint _disputeID, uint _appeals, uint _voteID) public view returns (address account) {
1638         return disputes[_disputeID].votes[_appeals][_voteID].account;
1639     }
1640 
1641     /** @dev Getter for ruling in Vote.
1642      *  @param _disputeID ID of the dispute.
1643      *  @param _appeals Which appeal (or 0 for the initial session).
1644      *  @param _voteID The ID of the vote for this appeal (or initial session).
1645      *  @return ruling The ruling given by the voter.
1646      */
1647     function getVoteRuling(uint _disputeID, uint _appeals, uint _voteID) public view returns (uint ruling) {
1648         return disputes[_disputeID].votes[_appeals][_voteID].ruling;
1649     }
1650 
1651     /** @dev Getter for winningChoice in VoteCounter.
1652      *  @param _disputeID ID of the dispute.
1653      *  @param _appeals Which appeal (or 0 for the initial session).
1654      *  @return winningChoice The currently winning choice (or 0 if it's tied). Note that 0 can also be return if the majority refuses to arbitrate.
1655      */
1656     function getWinningChoice(uint _disputeID, uint _appeals) public view returns (uint winningChoice) {
1657         return disputes[_disputeID].voteCounter[_appeals].winningChoice;
1658     }
1659 
1660     /** @dev Getter for winningCount in VoteCounter.
1661      *  @param _disputeID ID of the dispute.
1662      *  @param _appeals Which appeal (or 0 for the initial session).
1663      *  @return winningCount The amount of votes the winning choice (or those who are tied) has.
1664      */
1665     function getWinningCount(uint _disputeID, uint _appeals) public view returns (uint winningCount) {
1666         return disputes[_disputeID].voteCounter[_appeals].winningCount;
1667     }
1668 
1669     /** @dev Getter for voteCount in VoteCounter.
1670      *  @param _disputeID ID of the dispute.
1671      *  @param _appeals Which appeal (or 0 for the initial session).
1672      *  @param _choice The choice.
1673      *  @return voteCount The amount of votes the winning choice (or those who are tied) has.
1674      */
1675     function getVoteCount(uint _disputeID, uint _appeals, uint _choice) public view returns (uint voteCount) {
1676         return disputes[_disputeID].voteCounter[_appeals].voteCount[_choice];
1677     }
1678 
1679     /** @dev Getter for lastSessionVote in Dispute.
1680      *  @param _disputeID ID of the dispute.
1681      *  @param _juror The juror we want to get the last session he voted.
1682      *  @return lastSessionVote The last session the juror voted.
1683      */
1684     function getLastSessionVote(uint _disputeID, address _juror) public view returns (uint lastSessionVote) {
1685         return disputes[_disputeID].lastSessionVote[_juror];
1686     }
1687 
1688     /** @dev Is the juror drawn in the draw of the dispute.
1689      *  @param _disputeID ID of the dispute.
1690      *  @param _juror The juror.
1691      *  @param _draw The draw. Note that it starts at 1.
1692      *  @return drawn True if the juror is drawn, false otherwise.
1693      */
1694     function isDrawn(uint _disputeID, address _juror, uint _draw) public view returns (bool drawn) {
1695         Dispute storage dispute = disputes[_disputeID];
1696         Juror storage juror = jurors[_juror];
1697         if (juror.lastSession != session
1698         || (dispute.session+dispute.appeals != session)
1699         || period<=Period.Draw
1700         || _draw>amountJurors(_disputeID)
1701         || _draw==0
1702         || segmentSize==0
1703         ) {
1704             return false;
1705         } else {
1706             uint position = uint(keccak256(randomNumber,_disputeID,_draw)) % segmentSize;
1707             return (position >= juror.segmentStart) && (position < juror.segmentEnd);
1708         }
1709 
1710     }
1711 
1712     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1713      *  @param _disputeID ID of the dispute.
1714      *  @return ruling The current ruling which will be given if there is no appeal. If it is not available, return 0.
1715      */
1716     function currentRuling(uint _disputeID) public view returns (uint ruling) {
1717         Dispute storage dispute = disputes[_disputeID];
1718         return dispute.voteCounter[dispute.appeals].winningChoice;
1719     }
1720 
1721     /** @dev Return the status of a dispute.
1722      *  @param _disputeID ID of the dispute to rule.
1723      *  @return status The status of the dispute.
1724      */
1725     function disputeStatus(uint _disputeID) public view returns (DisputeStatus status) {
1726         Dispute storage dispute = disputes[_disputeID];
1727         if (dispute.session+dispute.appeals < session) // Dispute of past session.
1728             return DisputeStatus.Solved;
1729         else if(dispute.session+dispute.appeals == session) { // Dispute of current session.
1730             if (dispute.state == DisputeState.Open) {
1731                 if (period < Period.Appeal)
1732                     return DisputeStatus.Waiting;
1733                 else if (period == Period.Appeal)
1734                     return DisputeStatus.Appealable;
1735                 else return DisputeStatus.Solved;
1736             } else return DisputeStatus.Solved;
1737         } else return DisputeStatus.Waiting; // Dispute for future session.
1738     }
1739 
1740     // **************************** //
1741     // *     Governor Functions   * //
1742     // **************************** //
1743 
1744     /** @dev General call function where the contract execute an arbitrary call with data and ETH following governor orders.
1745      *  @param _data Transaction data.
1746      *  @param _value Transaction value.
1747      *  @param _target Transaction target.
1748      */
1749     function executeOrder(bytes32 _data, uint _value, address _target) public onlyGovernor {
1750         _target.call.value(_value)(_data);
1751     }
1752 
1753     /** @dev Setter for rng.
1754      *  @param _rng An instance of RNG.
1755      */
1756     function setRng(RNG _rng) public onlyGovernor {
1757         rng = _rng;
1758     }
1759 
1760     /** @dev Setter for arbitrationFeePerJuror.
1761      *  @param _arbitrationFeePerJuror The fee which will be paid to each juror.
1762      */
1763     function setArbitrationFeePerJuror(uint _arbitrationFeePerJuror) public onlyGovernor {
1764         arbitrationFeePerJuror = _arbitrationFeePerJuror;
1765     }
1766 
1767     /** @dev Setter for defaultNumberJuror.
1768      *  @param _defaultNumberJuror Number of drawn jurors unless specified otherwise.
1769      */
1770     function setDefaultNumberJuror(uint16 _defaultNumberJuror) public onlyGovernor {
1771         defaultNumberJuror = _defaultNumberJuror;
1772     }
1773 
1774     /** @dev Setter for minActivatedToken.
1775      *  @param _minActivatedToken Minimum of tokens to be activated (in basic units).
1776      */
1777     function setMinActivatedToken(uint _minActivatedToken) public onlyGovernor {
1778         minActivatedToken = _minActivatedToken;
1779     }
1780 
1781     /** @dev Setter for timePerPeriod.
1782      *  @param _timePerPeriod The minimum time each period lasts (seconds).
1783      */
1784     function setTimePerPeriod(uint[5] _timePerPeriod) public onlyGovernor {
1785         timePerPeriod = _timePerPeriod;
1786     }
1787 
1788     /** @dev Setter for alpha.
1789      *  @param _alpha Alpha in ‱.
1790      */
1791     function setAlpha(uint _alpha) public onlyGovernor {
1792         alpha = _alpha;
1793     }
1794 
1795     /** @dev Setter for maxAppeals.
1796      *  @param _maxAppeals Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1797      */
1798     function setMaxAppeals(uint _maxAppeals) public onlyGovernor {
1799         maxAppeals = _maxAppeals;
1800     }
1801 
1802     /** @dev Setter for governor.
1803      *  @param _governor Address of the governor contract.
1804      */
1805     function setGovernor(address _governor) public onlyGovernor {
1806         governor = _governor;
1807     }
1808 }