1 /** @title PEpsilon
2  *  @author Daniel Babbev
3  *
4  *  This contract implements a p + epsilon attack against the Kleros court.
5  *  The attack is described by VitaliK Buterin here: https://blog.ethereum.org/2015/01/28/p-epsilon-attack/
6  */
7 contract PEpsilon {
8   Pinakion public pinakion;
9   Kleros public court;
10 
11   uint public balance;
12   uint public disputeID;
13   uint public desiredOutcome;
14   uint public epsilon;
15   bool public settled;
16   uint public maxAppeals; // The maximum number of appeals this cotracts promises to pay
17   mapping (address => uint) public withdraw; // We'll use a withdraw pattern here to avoid multiple sends when a juror has voted multiple times.
18 
19   address public attacker;
20   uint public remainingWithdraw; // Here we keep the total amount bribed jurors have available for withdraw.
21 
22   modifier onlyBy(address _account) {require(msg.sender == _account); _;}
23 
24   event AmountShift(uint val, uint epsilon ,address juror);
25   event Log(uint val, address addr, string message);
26 
27   /** @dev Constructor.
28    *  @param _pinakion The PNK contract.
29    *  @param _kleros   The Kleros court.
30    *  @param _disputeID The dispute we are targeting.
31    *  @param _desiredOutcome The desired ruling of the dispute.
32    *  @param _epsilon  Jurors will be paid epsilon more for voting for the desiredOutcome.
33    *  @param _maxAppeals The maximum number of appeals this contract promises to pay out
34    */
35   constructor(Pinakion _pinakion, Kleros _kleros, uint _disputeID, uint _desiredOutcome, uint _epsilon, uint _maxAppeals) public {
36     pinakion = _pinakion;
37     court = _kleros;
38     disputeID = _disputeID;
39     desiredOutcome = _desiredOutcome;
40     epsilon = _epsilon;
41     attacker = msg.sender;
42     maxAppeals = _maxAppeals;
43   }
44 
45   /** @dev Callback of approveAndCall - transfer pinakions in the contract. Should be called by the pinakion contract. TRUSTED.
46    *  The attacker has to deposit sufficiently large amount of PNK to cover the payouts to the jurors.
47    *  @param _from The address making the transfer.
48    *  @param _amount Amount of tokens to transfer to this contract (in basic units).
49    */
50   function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
51     require(pinakion.transferFrom(_from, this, _amount));
52 
53     balance += _amount;
54   }
55 
56   /** @dev Jurors can withdraw their PNK from here
57    */
58   function withdrawJuror() {
59     withdrawSelect(msg.sender);
60   }
61 
62   /** @dev Withdraw the funds of a given juror
63    *  @param _juror The address of the juror
64    */
65   function withdrawSelect(address _juror) {
66     uint amount = withdraw[_juror];
67     withdraw[_juror] = 0;
68 
69     balance = sub(balance, amount); // Could underflow
70     remainingWithdraw = sub(remainingWithdraw, amount);
71 
72     // The juror receives d + p + e (deposit + p + epsilon)
73     require(pinakion.transfer(_juror, amount));
74   }
75 
76   /**
77   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78   */
79   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
80     assert(_b <= _a);
81     return _a - _b;
82   }
83 
84   /** @dev The attacker can withdraw their PNK from here after the bribe has been settled.
85    */
86   function withdrawAttacker(){
87     require(settled);
88 
89     if (balance > remainingWithdraw) {
90       // The remaning balance of PNK after settlement is transfered to the attacker.
91       uint amount = balance - remainingWithdraw;
92       balance = remainingWithdraw;
93 
94       require(pinakion.transfer(attacker, amount));
95     }
96   }
97 
98   /** @dev Settles the p + e bribe with the jurors.
99    * If the dispute is ruled differently from desiredOutcome:
100    *    The jurors who voted for desiredOutcome receive p + d + e in rewards from this contract.
101    * If the dispute is ruled as in desiredOutcome:
102    *    The jurors don't receive anything from this contract.
103    */
104   function settle() public {
105     require(court.disputeStatus(disputeID) ==  Arbitrator.DisputeStatus.Solved); // The case must be solved.
106     require(!settled); // This function can be executed only once.
107 
108     settled = true; // settle the bribe
109 
110     // From the dispute we get the # of appeals and the available choices
111     var (, , appeals, choices, , , ,) = court.disputes(disputeID);
112 
113     if (court.currentRuling(disputeID) != desiredOutcome){
114       // Calculate the redistribution amounts.
115       uint amountShift = court.getStakePerDraw();
116       uint winningChoice = court.getWinningChoice(disputeID, appeals);
117 
118       // Rewards are calculated as per the one shot token reparation.
119       for (uint i=0; i <= (appeals > maxAppeals ? maxAppeals : appeals); i++){ // Loop each appeal and each vote.
120 
121         // Note that we don't check if the result was a tie becuse we are getting a funny compiler error: "stack is too deep" if we check.
122         // TODO: Account for ties
123         if (winningChoice != 0){
124           // votesLen is the length of the votes per each appeal. There is no getter function for that, so we have to calculate it here.
125           // We must end up with the exact same value as if we would have called dispute.votes[i].length
126           uint votesLen = 0;
127           for (uint c = 0; c <= choices; c++) { // Iterate for each choice of the dispute.
128             votesLen += court.getVoteCount(disputeID, i, c);
129           }
130 
131           emit Log(amountShift, 0x0 ,"stakePerDraw");
132           emit Log(votesLen, 0x0, "votesLen");
133 
134           uint totalToRedistribute = 0;
135           uint nbCoherent = 0;
136 
137           // Now we will use votesLen as a substitute for dispute.votes[i].length
138           for (uint j=0; j < votesLen; j++){
139             uint voteRuling = court.getVoteRuling(disputeID, i, j);
140             address voteAccount = court.getVoteAccount(disputeID, i, j);
141 
142             emit Log(voteRuling, voteAccount, "voted");
143 
144             if (voteRuling != winningChoice){
145               totalToRedistribute += amountShift;
146 
147               if (voteRuling == desiredOutcome){ // If the juror voted as we desired.
148                 // Transfer this juror back the penalty.
149                 withdraw[voteAccount] += amountShift + epsilon;
150                 remainingWithdraw += amountShift + epsilon;
151                 emit AmountShift(amountShift, epsilon, voteAccount);
152               }
153             } else {
154               nbCoherent++;
155             }
156           }
157           // toRedistribute is the amount each juror received when he voted coherently.
158           uint toRedistribute = (totalToRedistribute - amountShift) / (nbCoherent + 1);
159 
160           // We use votesLen again as a substitute for dispute.votes[i].length
161           for (j = 0; j < votesLen; j++){
162             voteRuling = court.getVoteRuling(disputeID, i, j);
163             voteAccount = court.getVoteAccount(disputeID, i, j);
164 
165             if (voteRuling == desiredOutcome){
166               // Add the coherent juror reward to the total payout.
167               withdraw[voteAccount] += toRedistribute;
168               remainingWithdraw += toRedistribute;
169               emit AmountShift(toRedistribute, 0, voteAccount);
170             }
171           }
172         }
173       }
174     }
175   }
176 }
177 
178 
179 /**
180  *  @title Kleros
181  *  @author Clément Lesaege - <clement@lesaege.com>
182  *  This code implements a simple version of Kleros.
183  *  Bug Bounties: This code hasn't undertaken a bug bounty program yet.
184  */
185 
186 pragma solidity ^0.4.24;
187 
188 
189 contract ApproveAndCallFallBack {
190     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
191 }
192 
193 /// @dev The token controller contract must implement these functions
194 contract TokenController {
195     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
196     /// @param _owner The address that sent the ether to create tokens
197     /// @return True if the ether is accepted, false if it throws
198     function proxyPayment(address _owner) public payable returns(bool);
199 
200     /// @notice Notifies the controller about a token transfer allowing the
201     ///  controller to react if desired
202     /// @param _from The origin of the transfer
203     /// @param _to The destination of the transfer
204     /// @param _amount The amount of the transfer
205     /// @return False if the controller does not authorize the transfer
206     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
207 
208     /// @notice Notifies the controller about an approval allowing the
209     ///  controller to react if desired
210     /// @param _owner The address that calls `approve()`
211     /// @param _spender The spender in the `approve()` call
212     /// @param _amount The amount in the `approve()` call
213     /// @return False if the controller does not authorize the approval
214     function onApprove(address _owner, address _spender, uint _amount) public
215         returns(bool);
216 }
217 
218 contract Controlled {
219     /// @notice The address of the controller is the only address that can call
220     ///  a function with this modifier
221     modifier onlyController { require(msg.sender == controller); _; }
222 
223     address public controller;
224 
225     function Controlled() public { controller = msg.sender;}
226 
227     /// @notice Changes the controller of the contract
228     /// @param _newController The new controller of the contract
229     function changeController(address _newController) public onlyController {
230         controller = _newController;
231     }
232 }
233 
234 /// @dev The actual token contract, the default controller is the msg.sender
235 ///  that deploys the contract, so usually this token will be deployed by a
236 ///  token controller contract, which Giveth will call a "Campaign"
237 contract Pinakion is Controlled {
238 
239     string public name;                //The Token's name: e.g. DigixDAO Tokens
240     uint8 public decimals;             //Number of decimals of the smallest unit
241     string public symbol;              //An identifier: e.g. REP
242     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
243 
244 
245     /// @dev `Checkpoint` is the structure that attaches a block number to a
246     ///  given value, the block number attached is the one that last changed the
247     ///  value
248     struct  Checkpoint {
249 
250         // `fromBlock` is the block number that the value was generated from
251         uint128 fromBlock;
252 
253         // `value` is the amount of tokens at a specific block number
254         uint128 value;
255     }
256 
257     // `parentToken` is the Token address that was cloned to produce this token;
258     //  it will be 0x0 for a token that was not cloned
259     Pinakion public parentToken;
260 
261     // `parentSnapShotBlock` is the block number from the Parent Token that was
262     //  used to determine the initial distribution of the Clone Token
263     uint public parentSnapShotBlock;
264 
265     // `creationBlock` is the block number that the Clone Token was created
266     uint public creationBlock;
267 
268     // `balances` is the map that tracks the balance of each address, in this
269     //  contract when the balance changes the block number that the change
270     //  occurred is also included in the map
271     mapping (address => Checkpoint[]) balances;
272 
273     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
274     mapping (address => mapping (address => uint256)) allowed;
275 
276     // Tracks the history of the `totalSupply` of the token
277     Checkpoint[] totalSupplyHistory;
278 
279     // Flag that determines if the token is transferable or not.
280     bool public transfersEnabled;
281 
282     // The factory used to create new clone tokens
283     MiniMeTokenFactory public tokenFactory;
284 
285 ////////////////
286 // Constructor
287 ////////////////
288 
289     /// @notice Constructor to create a Pinakion
290     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
291     ///  will create the Clone token contracts, the token factory needs to be
292     ///  deployed first
293     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
294     ///  new token
295     /// @param _parentSnapShotBlock Block of the parent token that will
296     ///  determine the initial distribution of the clone token, set to 0 if it
297     ///  is a new token
298     /// @param _tokenName Name of the new token
299     /// @param _decimalUnits Number of decimals of the new token
300     /// @param _tokenSymbol Token Symbol for the new token
301     /// @param _transfersEnabled If true, tokens will be able to be transferred
302     function Pinakion(
303         address _tokenFactory,
304         address _parentToken,
305         uint _parentSnapShotBlock,
306         string _tokenName,
307         uint8 _decimalUnits,
308         string _tokenSymbol,
309         bool _transfersEnabled
310     ) public {
311         tokenFactory = MiniMeTokenFactory(_tokenFactory);
312         name = _tokenName;                                 // Set the name
313         decimals = _decimalUnits;                          // Set the decimals
314         symbol = _tokenSymbol;                             // Set the symbol
315         parentToken = Pinakion(_parentToken);
316         parentSnapShotBlock = _parentSnapShotBlock;
317         transfersEnabled = _transfersEnabled;
318         creationBlock = block.number;
319     }
320 
321 
322 ///////////////////
323 // ERC20 Methods
324 ///////////////////
325 
326     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
327     /// @param _to The address of the recipient
328     /// @param _amount The amount of tokens to be transferred
329     /// @return Whether the transfer was successful or not
330     function transfer(address _to, uint256 _amount) public returns (bool success) {
331         require(transfersEnabled);
332         doTransfer(msg.sender, _to, _amount);
333         return true;
334     }
335 
336     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
337     ///  is approved by `_from`
338     /// @param _from The address holding the tokens being transferred
339     /// @param _to The address of the recipient
340     /// @param _amount The amount of tokens to be transferred
341     /// @return True if the transfer was successful
342     function transferFrom(address _from, address _to, uint256 _amount
343     ) public returns (bool success) {
344 
345         // The controller of this contract can move tokens around at will,
346         //  this is important to recognize! Confirm that you trust the
347         //  controller of this contract, which in most situations should be
348         //  another open source smart contract or 0x0
349         if (msg.sender != controller) {
350             require(transfersEnabled);
351 
352             // The standard ERC 20 transferFrom functionality
353             require(allowed[_from][msg.sender] >= _amount);
354             allowed[_from][msg.sender] -= _amount;
355         }
356         doTransfer(_from, _to, _amount);
357         return true;
358     }
359 
360     /// @dev This is the actual transfer function in the token contract, it can
361     ///  only be called by other functions in this contract.
362     /// @param _from The address holding the tokens being transferred
363     /// @param _to The address of the recipient
364     /// @param _amount The amount of tokens to be transferred
365     /// @return True if the transfer was successful
366     function doTransfer(address _from, address _to, uint _amount
367     ) internal {
368 
369            if (_amount == 0) {
370                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
371                return;
372            }
373 
374            require(parentSnapShotBlock < block.number);
375 
376            // Do not allow transfer to 0x0 or the token contract itself
377            require((_to != 0) && (_to != address(this)));
378 
379            // If the amount being transfered is more than the balance of the
380            //  account the transfer throws
381            var previousBalanceFrom = balanceOfAt(_from, block.number);
382 
383            require(previousBalanceFrom >= _amount);
384 
385            // Alerts the token controller of the transfer
386            if (isContract(controller)) {
387                require(TokenController(controller).onTransfer(_from, _to, _amount));
388            }
389 
390            // First update the balance array with the new value for the address
391            //  sending the tokens
392            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
393 
394            // Then update the balance array with the new value for the address
395            //  receiving the tokens
396            var previousBalanceTo = balanceOfAt(_to, block.number);
397            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
398            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
399 
400            // An event to make the transfer easy to find on the blockchain
401            Transfer(_from, _to, _amount);
402 
403     }
404 
405     /// @param _owner The address that's balance is being requested
406     /// @return The balance of `_owner` at the current block
407     function balanceOf(address _owner) public constant returns (uint256 balance) {
408         return balanceOfAt(_owner, block.number);
409     }
410 
411     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
412     ///  its behalf. This is the standard version to allow backward compatibility.
413     /// @param _spender The address of the account able to transfer the tokens
414     /// @param _amount The amount of tokens to be approved for transfer
415     /// @return True if the approval was successful
416     function approve(address _spender, uint256 _amount) public returns (bool success) {
417         require(transfersEnabled);
418 
419         // Alerts the token controller of the approve function call
420         if (isContract(controller)) {
421             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
422         }
423 
424         allowed[msg.sender][_spender] = _amount;
425         Approval(msg.sender, _spender, _amount);
426         return true;
427     }
428 
429     /// @dev This function makes it easy to read the `allowed[]` map
430     /// @param _owner The address of the account that owns the token
431     /// @param _spender The address of the account able to transfer the tokens
432     /// @return Amount of remaining tokens of _owner that _spender is allowed
433     ///  to spend
434     function allowance(address _owner, address _spender
435     ) public constant returns (uint256 remaining) {
436         return allowed[_owner][_spender];
437     }
438 
439     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
440     ///  its behalf, and then a function is triggered in the contract that is
441     ///  being approved, `_spender`. This allows users to use their tokens to
442     ///  interact with contracts in one function call instead of two
443     /// @param _spender The address of the contract able to transfer the tokens
444     /// @param _amount The amount of tokens to be approved for transfer
445     /// @return True if the function call was successful
446     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
447     ) public returns (bool success) {
448         require(approve(_spender, _amount));
449 
450         ApproveAndCallFallBack(_spender).receiveApproval(
451             msg.sender,
452             _amount,
453             this,
454             _extraData
455         );
456 
457         return true;
458     }
459 
460     /// @dev This function makes it easy to get the total number of tokens
461     /// @return The total number of tokens
462     function totalSupply() public constant returns (uint) {
463         return totalSupplyAt(block.number);
464     }
465 
466 
467 ////////////////
468 // Query balance and totalSupply in History
469 ////////////////
470 
471     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
472     /// @param _owner The address from which the balance will be retrieved
473     /// @param _blockNumber The block number when the balance is queried
474     /// @return The balance at `_blockNumber`
475     function balanceOfAt(address _owner, uint _blockNumber) public constant
476         returns (uint) {
477 
478         // These next few lines are used when the balance of the token is
479         //  requested before a check point was ever created for this token, it
480         //  requires that the `parentToken.balanceOfAt` be queried at the
481         //  genesis block for that token as this contains initial balance of
482         //  this token
483         if ((balances[_owner].length == 0)
484             || (balances[_owner][0].fromBlock > _blockNumber)) {
485             if (address(parentToken) != 0) {
486                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
487             } else {
488                 // Has no parent
489                 return 0;
490             }
491 
492         // This will return the expected balance during normal situations
493         } else {
494             return getValueAt(balances[_owner], _blockNumber);
495         }
496     }
497 
498     /// @notice Total amount of tokens at a specific `_blockNumber`.
499     /// @param _blockNumber The block number when the totalSupply is queried
500     /// @return The total amount of tokens at `_blockNumber`
501     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
502 
503         // These next few lines are used when the totalSupply of the token is
504         //  requested before a check point was ever created for this token, it
505         //  requires that the `parentToken.totalSupplyAt` be queried at the
506         //  genesis block for this token as that contains totalSupply of this
507         //  token at this block number.
508         if ((totalSupplyHistory.length == 0)
509             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
510             if (address(parentToken) != 0) {
511                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
512             } else {
513                 return 0;
514             }
515 
516         // This will return the expected totalSupply during normal situations
517         } else {
518             return getValueAt(totalSupplyHistory, _blockNumber);
519         }
520     }
521 
522 ////////////////
523 // Clone Token Method
524 ////////////////
525 
526     /// @notice Creates a new clone token with the initial distribution being
527     ///  this token at `_snapshotBlock`
528     /// @param _cloneTokenName Name of the clone token
529     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
530     /// @param _cloneTokenSymbol Symbol of the clone token
531     /// @param _snapshotBlock Block when the distribution of the parent token is
532     ///  copied to set the initial distribution of the new clone token;
533     ///  if the block is zero than the actual block, the current block is used
534     /// @param _transfersEnabled True if transfers are allowed in the clone
535     /// @return The address of the new MiniMeToken Contract
536     function createCloneToken(
537         string _cloneTokenName,
538         uint8 _cloneDecimalUnits,
539         string _cloneTokenSymbol,
540         uint _snapshotBlock,
541         bool _transfersEnabled
542         ) public returns(address) {
543         if (_snapshotBlock == 0) _snapshotBlock = block.number;
544         Pinakion cloneToken = tokenFactory.createCloneToken(
545             this,
546             _snapshotBlock,
547             _cloneTokenName,
548             _cloneDecimalUnits,
549             _cloneTokenSymbol,
550             _transfersEnabled
551             );
552 
553         cloneToken.changeController(msg.sender);
554 
555         // An event to make the token easy to find on the blockchain
556         NewCloneToken(address(cloneToken), _snapshotBlock);
557         return address(cloneToken);
558     }
559 
560 ////////////////
561 // Generate and destroy tokens
562 ////////////////
563 
564     /// @notice Generates `_amount` tokens that are assigned to `_owner`
565     /// @param _owner The address that will be assigned the new tokens
566     /// @param _amount The quantity of tokens generated
567     /// @return True if the tokens are generated correctly
568     function generateTokens(address _owner, uint _amount
569     ) public onlyController returns (bool) {
570         uint curTotalSupply = totalSupply();
571         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
572         uint previousBalanceTo = balanceOf(_owner);
573         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
574         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
575         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
576         Transfer(0, _owner, _amount);
577         return true;
578     }
579 
580 
581     /// @notice Burns `_amount` tokens from `_owner`
582     /// @param _owner The address that will lose the tokens
583     /// @param _amount The quantity of tokens to burn
584     /// @return True if the tokens are burned correctly
585     function destroyTokens(address _owner, uint _amount
586     ) onlyController public returns (bool) {
587         uint curTotalSupply = totalSupply();
588         require(curTotalSupply >= _amount);
589         uint previousBalanceFrom = balanceOf(_owner);
590         require(previousBalanceFrom >= _amount);
591         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
592         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
593         Transfer(_owner, 0, _amount);
594         return true;
595     }
596 
597 ////////////////
598 // Enable tokens transfers
599 ////////////////
600 
601 
602     /// @notice Enables token holders to transfer their tokens freely if true
603     /// @param _transfersEnabled True if transfers are allowed in the clone
604     function enableTransfers(bool _transfersEnabled) public onlyController {
605         transfersEnabled = _transfersEnabled;
606     }
607 
608 ////////////////
609 // Internal helper functions to query and set a value in a snapshot array
610 ////////////////
611 
612     /// @dev `getValueAt` retrieves the number of tokens at a given block number
613     /// @param checkpoints The history of values being queried
614     /// @param _block The block number to retrieve the value at
615     /// @return The number of tokens being queried
616     function getValueAt(Checkpoint[] storage checkpoints, uint _block
617     ) constant internal returns (uint) {
618         if (checkpoints.length == 0) return 0;
619 
620         // Shortcut for the actual value
621         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
622             return checkpoints[checkpoints.length-1].value;
623         if (_block < checkpoints[0].fromBlock) return 0;
624 
625         // Binary search of the value in the array
626         uint min = 0;
627         uint max = checkpoints.length-1;
628         while (max > min) {
629             uint mid = (max + min + 1)/ 2;
630             if (checkpoints[mid].fromBlock<=_block) {
631                 min = mid;
632             } else {
633                 max = mid-1;
634             }
635         }
636         return checkpoints[min].value;
637     }
638 
639     /// @dev `updateValueAtNow` used to update the `balances` map and the
640     ///  `totalSupplyHistory`
641     /// @param checkpoints The history of data being updated
642     /// @param _value The new number of tokens
643     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
644     ) internal  {
645         if ((checkpoints.length == 0)
646         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
647                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
648                newCheckPoint.fromBlock =  uint128(block.number);
649                newCheckPoint.value = uint128(_value);
650            } else {
651                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
652                oldCheckPoint.value = uint128(_value);
653            }
654     }
655 
656     /// @dev Internal function to determine if an address is a contract
657     /// @param _addr The address being queried
658     /// @return True if `_addr` is a contract
659     function isContract(address _addr) constant internal returns(bool) {
660         uint size;
661         if (_addr == 0) return false;
662         assembly {
663             size := extcodesize(_addr)
664         }
665         return size>0;
666     }
667 
668     /// @dev Helper function to return a min betwen the two uints
669     function min(uint a, uint b) pure internal returns (uint) {
670         return a < b ? a : b;
671     }
672 
673     /// @notice The fallback function: If the contract's controller has not been
674     ///  set to 0, then the `proxyPayment` method is called which relays the
675     ///  ether and creates tokens as described in the token controller contract
676     function () public payable {
677         require(isContract(controller));
678         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
679     }
680 
681 //////////
682 // Safety Methods
683 //////////
684 
685     /// @notice This method can be used by the controller to extract mistakenly
686     ///  sent tokens to this contract.
687     /// @param _token The address of the token contract that you want to recover
688     ///  set to 0 in case you want to extract ether.
689     function claimTokens(address _token) public onlyController {
690         if (_token == 0x0) {
691             controller.transfer(this.balance);
692             return;
693         }
694 
695         Pinakion token = Pinakion(_token);
696         uint balance = token.balanceOf(this);
697         token.transfer(controller, balance);
698         ClaimedTokens(_token, controller, balance);
699     }
700 
701 ////////////////
702 // Events
703 ////////////////
704     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
705     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
706     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
707     event Approval(
708         address indexed _owner,
709         address indexed _spender,
710         uint256 _amount
711         );
712 
713 }
714 
715 
716 ////////////////
717 // MiniMeTokenFactory
718 ////////////////
719 
720 /// @dev This contract is used to generate clone contracts from a contract.
721 ///  In solidity this is the way to create a contract from a contract of the
722 ///  same class
723 contract MiniMeTokenFactory {
724 
725     /// @notice Update the DApp by creating a new token with new functionalities
726     ///  the msg.sender becomes the controller of this clone token
727     /// @param _parentToken Address of the token being cloned
728     /// @param _snapshotBlock Block of the parent token that will
729     ///  determine the initial distribution of the clone token
730     /// @param _tokenName Name of the new token
731     /// @param _decimalUnits Number of decimals of the new token
732     /// @param _tokenSymbol Token Symbol for the new token
733     /// @param _transfersEnabled If true, tokens will be able to be transferred
734     /// @return The address of the new token contract
735     function createCloneToken(
736         address _parentToken,
737         uint _snapshotBlock,
738         string _tokenName,
739         uint8 _decimalUnits,
740         string _tokenSymbol,
741         bool _transfersEnabled
742     ) public returns (Pinakion) {
743         Pinakion newToken = new Pinakion(
744             this,
745             _parentToken,
746             _snapshotBlock,
747             _tokenName,
748             _decimalUnits,
749             _tokenSymbol,
750             _transfersEnabled
751             );
752 
753         newToken.changeController(msg.sender);
754         return newToken;
755     }
756 }
757 
758 contract RNG{
759 
760     /** @dev Contribute to the reward of a random number.
761      *  @param _block Block the random number is linked to.
762      */
763     function contribute(uint _block) public payable;
764 
765     /** @dev Request a random number.
766      *  @param _block Block linked to the request.
767      */
768     function requestRN(uint _block) public payable {
769         contribute(_block);
770     }
771 
772     /** @dev Get the random number.
773      *  @param _block Block the random number is linked to.
774      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
775      */
776     function getRN(uint _block) public returns (uint RN);
777 
778     /** @dev Get a uncorrelated random number. Act like getRN but give a different number for each sender.
779      *  This is to prevent users from getting correlated numbers.
780      *  @param _block Block the random number is linked to.
781      *  @return RN Random Number. If the number is not ready or has not been required 0 instead.
782      */
783     function getUncorrelatedRN(uint _block) public returns (uint RN) {
784         uint baseRN=getRN(_block);
785         if (baseRN==0)
786             return 0;
787         else
788             return uint(keccak256(msg.sender,baseRN));
789     }
790 
791  }
792 
793 /** Simple Random Number Generator returning the blockhash.
794  *  Allows saving the random number for use in the future.
795  *  It allows the contract to still access the blockhash even after 256 blocks.
796  *  The first party to call the save function gets the reward.
797  */
798 contract BlockHashRNG is RNG {
799 
800     mapping (uint => uint) public randomNumber; // randomNumber[block] is the random number for this block, 0 otherwise.
801     mapping (uint => uint) public reward; // reward[block] is the amount to be paid to the party w.
802 
803 
804 
805     /** @dev Contribute to the reward of a random number.
806      *  @param _block Block the random number is linked to.
807      */
808     function contribute(uint _block) public payable { reward[_block]+=msg.value; }
809 
810 
811     /** @dev Return the random number. If it has not been saved and is still computable compute it.
812      *  @param _block Block the random number is linked to.
813      *  @return RN Random Number. If the number is not ready or has not been requested 0 instead.
814      */
815     function getRN(uint _block) public returns (uint RN) {
816         RN=randomNumber[_block];
817         if (RN==0){
818             saveRN(_block);
819             return randomNumber[_block];
820         }
821         else
822             return RN;
823     }
824 
825     /** @dev Save the random number for this blockhash and give the reward to the caller.
826      *  @param _block Block the random number is linked to.
827      */
828     function saveRN(uint _block) public {
829         if (blockhash(_block) != 0x0)
830             randomNumber[_block] = uint(blockhash(_block));
831         if (randomNumber[_block] != 0) { // If the number is set.
832             uint rewardToSend = reward[_block];
833             reward[_block] = 0;
834             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case msg.sender has a fallback issue.
835         }
836     }
837 
838 }
839 
840 
841 /** Random Number Generator returning the blockhash with a backup behaviour.
842  *  Allows saving the random number for use in the future. 
843  *  It allows the contract to still access the blockhash even after 256 blocks.
844  *  The first party to call the save function gets the reward.
845  *  If no one calls the contract within 256 blocks, the contract fallback in returning the blockhash of the previous block.
846  */
847 contract BlockHashRNGFallback is BlockHashRNG {
848     
849     /** @dev Save the random number for this blockhash and give the reward to the caller.
850      *  @param _block Block the random number is linked to.
851      */
852     function saveRN(uint _block) public {
853         if (_block<block.number && randomNumber[_block]==0) {// If the random number is not already set and can be.
854             if (blockhash(_block)!=0x0) // Normal case.
855                 randomNumber[_block]=uint(blockhash(_block));
856             else // The contract was not called in time. Fallback to returning previous blockhash.
857                 randomNumber[_block]=uint(blockhash(block.number-1));
858         }
859         if (randomNumber[_block] != 0) { // If the random number is set.
860             uint rewardToSend=reward[_block];
861             reward[_block]=0;
862             msg.sender.send(rewardToSend); // Note that the use of send is on purpose as we don't want to block in case the msg.sender has a fallback issue.
863         }
864     }
865     
866 }
867 
868 /** @title Arbitrable
869  *  Arbitrable abstract contract.
870  *  When developing arbitrable contracts, we need to:
871  *  -Define the action taken when a ruling is received by the contract. We should do so in executeRuling.
872  *  -Allow dispute creation. For this a function must:
873  *      -Call arbitrator.createDispute.value(_fee)(_choices,_extraData);
874  *      -Create the event Dispute(_arbitrator,_disputeID,_rulingOptions);
875  */
876 contract Arbitrable{
877     Arbitrator public arbitrator;
878     bytes public arbitratorExtraData; // Extra data to require particular dispute and appeal behaviour.
879 
880     modifier onlyArbitrator {require(msg.sender==address(arbitrator)); _;}
881 
882     /** @dev To be raised when a ruling is given.
883      *  @param _arbitrator The arbitrator giving the ruling.
884      *  @param _disputeID ID of the dispute in the Arbitrator contract.
885      *  @param _ruling The ruling which was given.
886      */
887     event Ruling(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _ruling);
888 
889     /** @dev To be emmited when meta-evidence is submitted.
890      *  @param _metaEvidenceID Unique identifier of meta-evidence.
891      *  @param _evidence A link to the meta-evidence JSON.
892      */
893     event MetaEvidence(uint indexed _metaEvidenceID, string _evidence);
894 
895     /** @dev To be emmited when a dispute is created to link the correct meta-evidence to the disputeID
896      *  @param _arbitrator The arbitrator of the contract.
897      *  @param _disputeID ID of the dispute in the Arbitrator contract.
898      *  @param _metaEvidenceID Unique identifier of meta-evidence.
899      */
900     event Dispute(Arbitrator indexed _arbitrator, uint indexed _disputeID, uint _metaEvidenceID);
901 
902     /** @dev To be raised when evidence are submitted. Should point to the ressource (evidences are not to be stored on chain due to gas considerations).
903      *  @param _arbitrator The arbitrator of the contract.
904      *  @param _disputeID ID of the dispute in the Arbitrator contract.
905      *  @param _party The address of the party submiting the evidence. Note that 0x0 refers to evidence not submitted by any party.
906      *  @param _evidence A URI to the evidence JSON file whose name should be its keccak256 hash followed by .json.
907      */
908     event Evidence(Arbitrator indexed _arbitrator, uint indexed _disputeID, address _party, string _evidence);
909 
910     /** @dev Constructor. Choose the arbitrator.
911      *  @param _arbitrator The arbitrator of the contract.
912      *  @param _arbitratorExtraData Extra data for the arbitrator.
913      */
914     constructor(Arbitrator _arbitrator, bytes _arbitratorExtraData) public {
915         arbitrator = _arbitrator;
916         arbitratorExtraData = _arbitratorExtraData;
917     }
918 
919     /** @dev Give a ruling for a dispute. Must be called by the arbitrator.
920      *  The purpose of this function is to ensure that the address calling it has the right to rule on the contract.
921      *  @param _disputeID ID of the dispute in the Arbitrator contract.
922      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
923      */
924     function rule(uint _disputeID, uint _ruling) public onlyArbitrator {
925         emit Ruling(Arbitrator(msg.sender),_disputeID,_ruling);
926 
927         executeRuling(_disputeID,_ruling);
928     }
929 
930 
931     /** @dev Execute a ruling of a dispute.
932      *  @param _disputeID ID of the dispute in the Arbitrator contract.
933      *  @param _ruling Ruling given by the arbitrator. Note that 0 is reserved for "Not able/wanting to make a decision".
934      */
935     function executeRuling(uint _disputeID, uint _ruling) internal;
936 }
937 
938 /** @title Arbitrator
939  *  Arbitrator abstract contract.
940  *  When developing arbitrator contracts we need to:
941  *  -Define the functions for dispute creation (createDispute) and appeal (appeal). Don't forget to store the arbitrated contract and the disputeID (which should be unique, use nbDisputes).
942  *  -Define the functions for cost display (arbitrationCost and appealCost).
943  *  -Allow giving rulings. For this a function must call arbitrable.rule(disputeID,ruling).
944  */
945 contract Arbitrator{
946 
947     enum DisputeStatus {Waiting, Appealable, Solved}
948 
949     modifier requireArbitrationFee(bytes _extraData) {require(msg.value>=arbitrationCost(_extraData)); _;}
950     modifier requireAppealFee(uint _disputeID, bytes _extraData) {require(msg.value>=appealCost(_disputeID, _extraData)); _;}
951 
952     /** @dev To be raised when a dispute can be appealed.
953      *  @param _disputeID ID of the dispute.
954      */
955     event AppealPossible(uint _disputeID);
956 
957     /** @dev To be raised when a dispute is created.
958      *  @param _disputeID ID of the dispute.
959      *  @param _arbitrable The contract which created the dispute.
960      */
961     event DisputeCreation(uint indexed _disputeID, Arbitrable _arbitrable);
962 
963     /** @dev To be raised when the current ruling is appealed.
964      *  @param _disputeID ID of the dispute.
965      *  @param _arbitrable The contract which created the dispute.
966      */
967     event AppealDecision(uint indexed _disputeID, Arbitrable _arbitrable);
968 
969     /** @dev Create a dispute. Must be called by the arbitrable contract.
970      *  Must be paid at least arbitrationCost(_extraData).
971      *  @param _choices Amount of choices the arbitrator can make in this dispute.
972      *  @param _extraData Can be used to give additional info on the dispute to be created.
973      *  @return disputeID ID of the dispute created.
974      */
975     function createDispute(uint _choices, bytes _extraData) public requireArbitrationFee(_extraData) payable returns(uint disputeID)  {}
976 
977     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
978      *  @param _extraData Can be used to give additional info on the dispute to be created.
979      *  @return fee Amount to be paid.
980      */
981     function arbitrationCost(bytes _extraData) public constant returns(uint fee);
982 
983     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
984      *  @param _disputeID ID of the dispute to be appealed.
985      *  @param _extraData Can be used to give extra info on the appeal.
986      */
987     function appeal(uint _disputeID, bytes _extraData) public requireAppealFee(_disputeID,_extraData) payable {
988         emit AppealDecision(_disputeID, Arbitrable(msg.sender));
989     }
990 
991     /** @dev Compute the cost of appeal. It is recommended not to increase it often, as it can be higly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
992      *  @param _disputeID ID of the dispute to be appealed.
993      *  @param _extraData Can be used to give additional info on the dispute to be created.
994      *  @return fee Amount to be paid.
995      */
996     function appealCost(uint _disputeID, bytes _extraData) public constant returns(uint fee);
997 
998     /** @dev Return the status of a dispute.
999      *  @param _disputeID ID of the dispute to rule.
1000      *  @return status The status of the dispute.
1001      */
1002     function disputeStatus(uint _disputeID) public constant returns(DisputeStatus status);
1003 
1004     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1005      *  @param _disputeID ID of the dispute.
1006      *  @return ruling The ruling which has been given or the one which will be given if there is no appeal.
1007      */
1008     function currentRuling(uint _disputeID) public constant returns(uint ruling);
1009 
1010 }
1011 
1012 
1013 
1014 contract Kleros is Arbitrator, ApproveAndCallFallBack {
1015 
1016     // **************************** //
1017     // *    Contract variables    * //
1018     // **************************** //
1019 
1020     // Variables which should not change after initialization.
1021     Pinakion public pinakion;
1022     uint public constant NON_PAYABLE_AMOUNT = (2**256 - 2) / 2; // An astronomic amount, practically can't be paid.
1023 
1024     // Variables which will subject to the governance mechanism.
1025     // Note they will only be able to be changed during the activation period (because a session assumes they don't change after it).
1026     RNG public rng; // Random Number Generator used to draw jurors.
1027     uint public arbitrationFeePerJuror = 0.05 ether; // The fee which will be paid to each juror.
1028     uint16 public defaultNumberJuror = 3; // Number of drawn jurors unless specified otherwise.
1029     uint public minActivatedToken = 0.1 * 1e18; // Minimum of tokens to be activated (in basic units).
1030     uint[5] public timePerPeriod; // The minimum time each period lasts (seconds).
1031     uint public alpha = 2000; // alpha in ‱ (1 / 10 000).
1032     uint constant ALPHA_DIVISOR = 1e4; // Amount we need to divided alpha in ‱ to get the float value of alpha.
1033     uint public maxAppeals = 5; // Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1034     // Initially, the governor will be an address controlled by the Kleros team. At a later stage,
1035     // the governor will be switched to a governance contract with liquid voting.
1036     address public governor; // Address of the governor contract.
1037 
1038     // Variables changing during day to day interaction.
1039     uint public session = 1;      // Current session of the court.
1040     uint public lastPeriodChange; // The last time we changed of period (seconds).
1041     uint public segmentSize;      // Size of the segment of activated tokens.
1042     uint public rnBlock;          // The block linked with the RN which is requested.
1043     uint public randomNumber;     // Random number of the session.
1044 
1045     enum Period {
1046         Activation, // When juror can deposit their tokens and parties give evidences.
1047         Draw,       // When jurors are drawn at random, note that this period is fast.
1048         Vote,       // Where jurors can vote on disputes.
1049         Appeal,     // When parties can appeal the rulings.
1050         Execution   // When where token redistribution occurs and Kleros call the arbitrated contracts.
1051     }
1052 
1053     Period public period;
1054 
1055     struct Juror {
1056         uint balance;      // The amount of tokens the contract holds for this juror.
1057         uint atStake;      // Total number of tokens the jurors can loose in disputes they are drawn in. Those tokens are locked. Note that we can have atStake > balance but it should be statistically unlikely and does not pose issues.
1058         uint lastSession;  // Last session the tokens were activated.
1059         uint segmentStart; // Start of the segment of activated tokens.
1060         uint segmentEnd;   // End of the segment of activated tokens.
1061     }
1062 
1063     mapping (address => Juror) public jurors;
1064 
1065     struct Vote {
1066         address account; // The juror who casted the vote.
1067         uint ruling;     // The ruling which was given.
1068     }
1069 
1070     struct VoteCounter {
1071         uint winningChoice; // The choice which currently has the highest amount of votes. Is 0 in case of a tie.
1072         uint winningCount;  // The number of votes for winningChoice. Or for the choices which are tied.
1073         mapping (uint => uint) voteCount; // voteCount[choice] is the number of votes for choice.
1074     }
1075 
1076     enum DisputeState {
1077         Open,       // The dispute is opened but the outcome is not available yet (this include when jurors voted but appeal is still possible).
1078         Resolving,  // The token repartition has started. Note that if it's done in just one call, this state is skipped.
1079         Executable, // The arbitrated contract can be called to enforce the decision.
1080         Executed    // Everything has been done and the dispute can't be interacted with anymore.
1081     }
1082 
1083     struct Dispute {
1084         Arbitrable arbitrated;       // Contract to be arbitrated.
1085         uint session;                // First session the dispute was schedule.
1086         uint appeals;                // Number of appeals.
1087         uint choices;                // The number of choices available to the jurors.
1088         uint16 initialNumberJurors;  // The initial number of jurors.
1089         uint arbitrationFeePerJuror; // The fee which will be paid to each juror.
1090         DisputeState state;          // The state of the dispute.
1091         Vote[][] votes;              // The votes in the form vote[appeals][voteID].
1092         VoteCounter[] voteCounter;   // The vote counters in the form voteCounter[appeals].
1093         mapping (address => uint) lastSessionVote; // Last session a juror has voted on this dispute. Is 0 if he never did.
1094         uint currentAppealToRepartition; // The current appeal we are repartitioning.
1095         AppealsRepartitioned[] appealsRepartitioned; // Track a partially repartitioned appeal in the form AppealsRepartitioned[appeal].
1096     }
1097 
1098     enum RepartitionStage { // State of the token repartition if oneShotTokenRepartition would throw because there are too many votes.
1099         Incoherent,
1100         Coherent,
1101         AtStake,
1102         Complete
1103     }
1104 
1105     struct AppealsRepartitioned {
1106         uint totalToRedistribute;   // Total amount of tokens we have to redistribute.
1107         uint nbCoherent;            // Number of coherent jurors for session.
1108         uint currentIncoherentVote; // Current vote for the incoherent loop.
1109         uint currentCoherentVote;   // Current vote we need to count.
1110         uint currentAtStakeVote;    // Current vote we need to count.
1111         RepartitionStage stage;     // Use with multipleShotTokenRepartition if oneShotTokenRepartition would throw.
1112     }
1113 
1114     Dispute[] public disputes;
1115 
1116     // **************************** //
1117     // *          Events          * //
1118     // **************************** //
1119 
1120     /** @dev Emitted when we pass to a new period.
1121      *  @param _period The new period.
1122      *  @param _session The current session.
1123      */
1124     event NewPeriod(Period _period, uint indexed _session);
1125 
1126     /** @dev Emitted when a juror wins or loses tokens.
1127       * @param _account The juror affected.
1128       * @param _disputeID The ID of the dispute.
1129       * @param _amount The amount of parts of token which was won. Can be negative for lost amounts.
1130       */
1131     event TokenShift(address indexed _account, uint _disputeID, int _amount);
1132 
1133     /** @dev Emited when a juror wins arbitration fees.
1134       * @param _account The account affected.
1135       * @param _disputeID The ID of the dispute.
1136       * @param _amount The amount of weis which was won.
1137       */
1138     event ArbitrationReward(address indexed _account, uint _disputeID, uint _amount);
1139 
1140     // **************************** //
1141     // *         Modifiers        * //
1142     // **************************** //
1143     modifier onlyBy(address _account) {require(msg.sender == _account); _;}
1144     modifier onlyDuring(Period _period) {require(period == _period); _;}
1145     modifier onlyGovernor() {require(msg.sender == governor); _;}
1146 
1147 
1148     /** @dev Constructor.
1149      *  @param _pinakion The address of the pinakion contract.
1150      *  @param _rng The random number generator which will be used.
1151      *  @param _timePerPeriod The minimal time for each period (seconds).
1152      *  @param _governor Address of the governor contract.
1153      */
1154     constructor(Pinakion _pinakion, RNG _rng, uint[5] _timePerPeriod, address _governor) public {
1155         pinakion = _pinakion;
1156         rng = _rng;
1157         lastPeriodChange = now;
1158         timePerPeriod = _timePerPeriod;
1159         governor = _governor;
1160     }
1161 
1162     // **************************** //
1163     // *  Functions interacting   * //
1164     // *  with Pinakion contract  * //
1165     // **************************** //
1166 
1167     /** @dev Callback of approveAndCall - transfer pinakions of a juror in the contract. Should be called by the pinakion contract. TRUSTED.
1168      *  @param _from The address making the transfer.
1169      *  @param _amount Amount of tokens to transfer to Kleros (in basic units).
1170      */
1171     function receiveApproval(address _from, uint _amount, address, bytes) public onlyBy(pinakion) {
1172         require(pinakion.transferFrom(_from, this, _amount));
1173 
1174         jurors[_from].balance += _amount;
1175     }
1176 
1177     /** @dev Withdraw tokens. Note that we can't withdraw the tokens which are still atStake. 
1178      *  Jurors can't withdraw their tokens if they have deposited some during this session.
1179      *  This is to prevent jurors from withdrawing tokens they could loose.
1180      *  @param _value The amount to withdraw.
1181      */
1182     function withdraw(uint _value) public {
1183         Juror storage juror = jurors[msg.sender];
1184         require(juror.atStake <= juror.balance); // Make sure that there is no more at stake than owned to avoid overflow.
1185         require(_value <= juror.balance-juror.atStake);
1186         require(juror.lastSession != session);
1187 
1188         juror.balance -= _value;
1189         require(pinakion.transfer(msg.sender,_value));
1190     }
1191 
1192     // **************************** //
1193     // *      Court functions     * //
1194     // *    Modifying the state   * //
1195     // **************************** //
1196 
1197     /** @dev To call to go to a new period. TRUSTED.
1198      */
1199     function passPeriod() public {
1200         require(now-lastPeriodChange >= timePerPeriod[uint8(period)]);
1201 
1202         if (period == Period.Activation) {
1203             rnBlock = block.number + 1;
1204             rng.requestRN(rnBlock);
1205             period = Period.Draw;
1206         } else if (period == Period.Draw) {
1207             randomNumber = rng.getUncorrelatedRN(rnBlock);
1208             require(randomNumber != 0);
1209             period = Period.Vote;
1210         } else if (period == Period.Vote) {
1211             period = Period.Appeal;
1212         } else if (period == Period.Appeal) {
1213             period = Period.Execution;
1214         } else if (period == Period.Execution) {
1215             period = Period.Activation;
1216             ++session;
1217             segmentSize = 0;
1218             rnBlock = 0;
1219             randomNumber = 0;
1220         }
1221 
1222 
1223         lastPeriodChange = now;
1224         NewPeriod(period, session);
1225     }
1226 
1227 
1228     /** @dev Deposit tokens in order to have chances of being drawn. Note that once tokens are deposited, 
1229      *  there is no possibility of depositing more.
1230      *  @param _value Amount of tokens (in basic units) to deposit.
1231      */
1232     function activateTokens(uint _value) public onlyDuring(Period.Activation) {
1233         Juror storage juror = jurors[msg.sender];
1234         require(_value <= juror.balance);
1235         require(_value >= minActivatedToken);
1236         require(juror.lastSession != session); // Verify that tokens were not already activated for this session.
1237 
1238         juror.lastSession = session;
1239         juror.segmentStart = segmentSize;
1240         segmentSize += _value;
1241         juror.segmentEnd = segmentSize;
1242 
1243     }
1244 
1245     /** @dev Vote a ruling. Juror must input the draw ID he was drawn.
1246      *  Note that the complexity is O(d), where d is amount of times the juror was drawn.
1247      *  Since being drawn multiple time is a rare occurrence and that a juror can always vote with less weight than it has, it is not a problem.
1248      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1249      *  @param _disputeID The ID of the dispute the juror was drawn.
1250      *  @param _ruling The ruling given.
1251      *  @param _draws The list of draws the juror was drawn. Draw numbering starts at 1 and the numbers should be increasing.
1252      */
1253     function voteRuling(uint _disputeID, uint _ruling, uint[] _draws) public onlyDuring(Period.Vote) {
1254         Dispute storage dispute = disputes[_disputeID];
1255         Juror storage juror = jurors[msg.sender];
1256         VoteCounter storage voteCounter = dispute.voteCounter[dispute.appeals];
1257         require(dispute.lastSessionVote[msg.sender] != session); // Make sure juror hasn't voted yet.
1258         require(_ruling <= dispute.choices);
1259         // Note that it throws if the draws are incorrect.
1260         require(validDraws(msg.sender, _disputeID, _draws));
1261 
1262         dispute.lastSessionVote[msg.sender] = session;
1263         voteCounter.voteCount[_ruling] += _draws.length;
1264         if (voteCounter.winningCount < voteCounter.voteCount[_ruling]) {
1265             voteCounter.winningCount = voteCounter.voteCount[_ruling];
1266             voteCounter.winningChoice = _ruling;
1267         } else if (voteCounter.winningCount==voteCounter.voteCount[_ruling] && _draws.length!=0) { // Verify draw length to be non-zero to avoid the possibility of setting tie by casting 0 votes.
1268             voteCounter.winningChoice = 0; // It's currently a tie.
1269         }
1270         for (uint i = 0; i < _draws.length; ++i) {
1271             dispute.votes[dispute.appeals].push(Vote({
1272                 account: msg.sender,
1273                 ruling: _ruling
1274             }));
1275         }
1276 
1277         juror.atStake += _draws.length * getStakePerDraw();
1278         uint feeToPay = _draws.length * dispute.arbitrationFeePerJuror;
1279         msg.sender.transfer(feeToPay);
1280         ArbitrationReward(msg.sender, _disputeID, feeToPay);
1281     }
1282 
1283     /** @dev Steal part of the tokens and the arbitration fee of a juror who failed to vote.
1284      *  Note that a juror who voted but without all his weight can't be penalized.
1285      *  It is possible to not penalize with the maximum weight.
1286      *  But note that it can lead to arbitration fees being kept by the contract and never distributed.
1287      *  @param _jurorAddress Address of the juror to steal tokens from.
1288      *  @param _disputeID The ID of the dispute the juror was drawn.
1289      *  @param _draws The list of draws the juror was drawn. Numbering starts at 1 and the numbers should be increasing.
1290      */
1291     function penalizeInactiveJuror(address _jurorAddress, uint _disputeID, uint[] _draws) public {
1292         Dispute storage dispute = disputes[_disputeID];
1293         Juror storage inactiveJuror = jurors[_jurorAddress];
1294         require(period > Period.Vote);
1295         require(dispute.lastSessionVote[_jurorAddress] != session); // Verify the juror hasn't voted.
1296         dispute.lastSessionVote[_jurorAddress] = session; // Update last session to avoid penalizing multiple times.
1297         require(validDraws(_jurorAddress, _disputeID, _draws));
1298         uint penality = _draws.length * minActivatedToken * 2 * alpha / ALPHA_DIVISOR;
1299         penality = (penality < inactiveJuror.balance) ? penality : inactiveJuror.balance; // Make sure the penality is not higher than the balance.
1300         inactiveJuror.balance -= penality;
1301         TokenShift(_jurorAddress, _disputeID, -int(penality));
1302         jurors[msg.sender].balance += penality / 2; // Give half of the penalty to the caller.
1303         TokenShift(msg.sender, _disputeID, int(penality / 2));
1304         jurors[governor].balance += penality / 2; // The other half to the governor.
1305         TokenShift(governor, _disputeID, int(penality / 2));
1306         msg.sender.transfer(_draws.length*dispute.arbitrationFeePerJuror); // Give the arbitration fees to the caller.
1307     }
1308 
1309     /** @dev Execute all the token repartition.
1310      *  Note that this function could consume to much gas if there is too much votes. 
1311      *  It is O(v), where v is the number of votes for this dispute.
1312      *  In the next version, there will also be a function to execute it in multiple calls 
1313      *  (but note that one shot execution, if possible, is less expensive).
1314      *  @param _disputeID ID of the dispute.
1315      */
1316     function oneShotTokenRepartition(uint _disputeID) public onlyDuring(Period.Execution) {
1317         Dispute storage dispute = disputes[_disputeID];
1318         require(dispute.state == DisputeState.Open);
1319         require(dispute.session+dispute.appeals <= session);
1320 
1321         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1322         uint amountShift = getStakePerDraw();
1323         for (uint i = 0; i <= dispute.appeals; ++i) {
1324             // If the result is not a tie, some parties are incoherent. Note that 0 (refuse to arbitrate) winning is not a tie.
1325             // Result is a tie if the winningChoice is 0 (refuse to arbitrate) and the choice 0 is not the most voted choice.
1326             // Note that in case of a "tie" among some choices including 0, parties who did not vote 0 are considered incoherent.
1327             if (winningChoice!=0 || (dispute.voteCounter[dispute.appeals].voteCount[0] == dispute.voteCounter[dispute.appeals].winningCount)) {
1328                 uint totalToRedistribute = 0;
1329                 uint nbCoherent = 0;
1330                 // First loop to penalize the incoherent votes.
1331                 for (uint j = 0; j < dispute.votes[i].length; ++j) {
1332                     Vote storage vote = dispute.votes[i][j];
1333                     if (vote.ruling != winningChoice) {
1334                         Juror storage juror = jurors[vote.account];
1335                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1336                         juror.balance -= penalty;
1337                         TokenShift(vote.account, _disputeID, int(-penalty));
1338                         totalToRedistribute += penalty;
1339                     } else {
1340                         ++nbCoherent;
1341                     }
1342                 }
1343                 if (nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1344                     jurors[governor].balance += totalToRedistribute;
1345                     TokenShift(governor, _disputeID, int(totalToRedistribute));
1346                 } else { // otherwise, redistribute them.
1347                     uint toRedistribute = totalToRedistribute / nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1348                     // Second loop to redistribute.
1349                     for (j = 0; j < dispute.votes[i].length; ++j) {
1350                         vote = dispute.votes[i][j];
1351                         if (vote.ruling == winningChoice) {
1352                             juror = jurors[vote.account];
1353                             juror.balance += toRedistribute;
1354                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1355                         }
1356                     }
1357                 }
1358             }
1359             // Third loop to lower the atStake in order to unlock tokens.
1360             for (j = 0; j < dispute.votes[i].length; ++j) {
1361                 vote = dispute.votes[i][j];
1362                 juror = jurors[vote.account];
1363                 juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1364             }
1365         }
1366         dispute.state = DisputeState.Executable; // Since it was solved in one shot, go directly to the executable step.
1367     }
1368 
1369     /** @dev Execute token repartition on a dispute for a specific number of votes.
1370      *  This should only be called if oneShotTokenRepartition will throw because there are too many votes (will use too much gas).
1371      *  Note that There are 3 iterations per vote. e.g. A dispute with 1 appeal (2 sessions) and 3 votes per session will have 18 iterations
1372      *  @param _disputeID ID of the dispute.
1373      *  @param _maxIterations the maxium number of votes to repartition in this iteration
1374      */
1375     function multipleShotTokenRepartition(uint _disputeID, uint _maxIterations) public onlyDuring(Period.Execution) {
1376         Dispute storage dispute = disputes[_disputeID];
1377         require(dispute.state <= DisputeState.Resolving);
1378         require(dispute.session+dispute.appeals <= session);
1379         dispute.state = DisputeState.Resolving; // Mark as resolving so oneShotTokenRepartition cannot be called on dispute.
1380 
1381         uint winningChoice = dispute.voteCounter[dispute.appeals].winningChoice;
1382         uint amountShift = getStakePerDraw();
1383         uint currentIterations = 0; // Total votes we have repartitioned this iteration.
1384         for (uint i = dispute.currentAppealToRepartition; i <= dispute.appeals; ++i) {
1385             // Allocate space for new AppealsRepartitioned.
1386             if (dispute.appealsRepartitioned.length < i+1) {
1387                 dispute.appealsRepartitioned.length++;
1388             }
1389 
1390             // If the result is a tie, no parties are incoherent and no need to move tokens. Note that 0 (refuse to arbitrate) winning is not a tie.
1391             if (winningChoice==0 && (dispute.voteCounter[dispute.appeals].voteCount[0] != dispute.voteCounter[dispute.appeals].winningCount)) {
1392                 // If ruling is a tie we can skip to at stake.
1393                 dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1394             }
1395 
1396             // First loop to penalize the incoherent votes.
1397             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Incoherent) {
1398                 for (uint j = dispute.appealsRepartitioned[i].currentIncoherentVote; j < dispute.votes[i].length; ++j) {
1399                     if (currentIterations >= _maxIterations) {
1400                         return;
1401                     }
1402                     Vote storage vote = dispute.votes[i][j];
1403                     if (vote.ruling != winningChoice) {
1404                         Juror storage juror = jurors[vote.account];
1405                         uint penalty = amountShift<juror.balance ? amountShift : juror.balance;
1406                         juror.balance -= penalty;
1407                         TokenShift(vote.account, _disputeID, int(-penalty));
1408                         dispute.appealsRepartitioned[i].totalToRedistribute += penalty;
1409                     } else {
1410                         ++dispute.appealsRepartitioned[i].nbCoherent;
1411                     }
1412 
1413                     ++dispute.appealsRepartitioned[i].currentIncoherentVote;
1414                     ++currentIterations;
1415                 }
1416 
1417                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Coherent;
1418             }
1419 
1420             // Second loop to reward coherent voters
1421             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Coherent) {
1422                 if (dispute.appealsRepartitioned[i].nbCoherent == 0) { // No one was coherent at this stage. Give the tokens to the governor.
1423                     jurors[governor].balance += dispute.appealsRepartitioned[i].totalToRedistribute;
1424                     TokenShift(governor, _disputeID, int(dispute.appealsRepartitioned[i].totalToRedistribute));
1425                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1426                 } else { // Otherwise, redistribute them.
1427                     uint toRedistribute = dispute.appealsRepartitioned[i].totalToRedistribute / dispute.appealsRepartitioned[i].nbCoherent; // Note that few fractions of tokens can be lost but due to the high amount of decimals we don't care.
1428                     // Second loop to redistribute.
1429                     for (j = dispute.appealsRepartitioned[i].currentCoherentVote; j < dispute.votes[i].length; ++j) {
1430                         if (currentIterations >= _maxIterations) {
1431                             return;
1432                         }
1433                         vote = dispute.votes[i][j];
1434                         if (vote.ruling == winningChoice) {
1435                             juror = jurors[vote.account];
1436                             juror.balance += toRedistribute;
1437                             TokenShift(vote.account, _disputeID, int(toRedistribute));
1438                         }
1439 
1440                         ++currentIterations;
1441                         ++dispute.appealsRepartitioned[i].currentCoherentVote;
1442                     }
1443 
1444                     dispute.appealsRepartitioned[i].stage = RepartitionStage.AtStake;
1445                 }
1446             }
1447 
1448             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.AtStake) {
1449                 // Third loop to lower the atStake in order to unlock tokens.
1450                 for (j = dispute.appealsRepartitioned[i].currentAtStakeVote; j < dispute.votes[i].length; ++j) {
1451                     if (currentIterations >= _maxIterations) {
1452                         return;
1453                     }
1454                     vote = dispute.votes[i][j];
1455                     juror = jurors[vote.account];
1456                     juror.atStake -= amountShift; // Note that it can't underflow due to amountShift not changing between vote and redistribution.
1457 
1458                     ++currentIterations;
1459                     ++dispute.appealsRepartitioned[i].currentAtStakeVote;
1460                 }
1461 
1462                 dispute.appealsRepartitioned[i].stage = RepartitionStage.Complete;
1463             }
1464 
1465             if (dispute.appealsRepartitioned[i].stage == RepartitionStage.Complete) {
1466                 ++dispute.currentAppealToRepartition;
1467             }
1468         }
1469 
1470         dispute.state = DisputeState.Executable;
1471     }
1472 
1473     // **************************** //
1474     // *      Court functions     * //
1475     // *     Constant and Pure    * //
1476     // **************************** //
1477 
1478     /** @dev Return the amount of jurors which are or will be drawn in the dispute.
1479      *  The number of jurors is doubled and 1 is added at each appeal. We have proven the formula by recurrence.
1480      *  This avoid having a variable number of jurors which would be updated in order to save gas.
1481      *  @param _disputeID The ID of the dispute we compute the amount of jurors.
1482      *  @return nbJurors The number of jurors which are drawn.
1483      */
1484     function amountJurors(uint _disputeID) public view returns (uint nbJurors) {
1485         Dispute storage dispute = disputes[_disputeID];
1486         return (dispute.initialNumberJurors + 1) * 2**dispute.appeals - 1;
1487     }
1488 
1489     /** @dev Must be used to verify that a juror has been draw at least _draws.length times.
1490      *  We have to require the user to specify the draws that lead the juror to be drawn.
1491      *  Because doing otherwise (looping through all draws) could consume too much gas.
1492      *  @param _jurorAddress Address of the juror we want to verify draws.
1493      *  @param _disputeID The ID of the dispute the juror was drawn.
1494      *  @param _draws The list of draws the juror was drawn. It draw numbering starts at 1 and the numbers should be increasing.
1495      *  Note that in most cases this list will just contain 1 number.
1496      *  @param valid true if the draws are valid.
1497      */
1498     function validDraws(address _jurorAddress, uint _disputeID, uint[] _draws) public view returns (bool valid) {
1499         uint draw = 0;
1500         Juror storage juror = jurors[_jurorAddress];
1501         Dispute storage dispute = disputes[_disputeID];
1502         uint nbJurors = amountJurors(_disputeID);
1503 
1504         if (juror.lastSession != session) return false; // Make sure that the tokens were deposited for this session.
1505         if (dispute.session+dispute.appeals != session) return false; // Make sure there is currently a dispute.
1506         if (period <= Period.Draw) return false; // Make sure that jurors are already drawn.
1507         for (uint i = 0; i < _draws.length; ++i) {
1508             if (_draws[i] <= draw) return false; // Make sure that draws are always increasing to avoid someone inputing the same multiple times.
1509             draw = _draws[i];
1510             if (draw > nbJurors) return false;
1511             uint position = uint(keccak256(randomNumber, _disputeID, draw)) % segmentSize; // Random position on the segment for draw.
1512             require(position >= juror.segmentStart);
1513             require(position < juror.segmentEnd);
1514         }
1515 
1516         return true;
1517     }
1518 
1519     // **************************** //
1520     // *   Arbitrator functions   * //
1521     // *   Modifying the state    * //
1522     // **************************** //
1523 
1524     /** @dev Create a dispute. Must be called by the arbitrable contract.
1525      *  Must be paid at least arbitrationCost().
1526      *  @param _choices Amount of choices the arbitrator can make in this dispute.
1527      *  @param _extraData Null for the default number. Otherwise, first 16 bytes will be used to return the number of jurors.
1528      *  @return disputeID ID of the dispute created.
1529      */
1530     function createDispute(uint _choices, bytes _extraData) public payable returns (uint disputeID) {
1531         uint16 nbJurors = extraDataToNbJurors(_extraData);
1532         require(msg.value >= arbitrationCost(_extraData));
1533 
1534         disputeID = disputes.length++;
1535         Dispute storage dispute = disputes[disputeID];
1536         dispute.arbitrated = Arbitrable(msg.sender);
1537         if (period < Period.Draw) // If drawing did not start schedule it for the current session.
1538             dispute.session = session;
1539         else // Otherwise schedule it for the next one.
1540             dispute.session = session+1;
1541         dispute.choices = _choices;
1542         dispute.initialNumberJurors = nbJurors;
1543         dispute.arbitrationFeePerJuror = arbitrationFeePerJuror; // We store it as the general fee can be changed through the governance mechanism.
1544         dispute.votes.length++;
1545         dispute.voteCounter.length++;
1546 
1547         DisputeCreation(disputeID, Arbitrable(msg.sender));
1548         return disputeID;
1549     }
1550 
1551     /** @dev Appeal a ruling. Note that it has to be called before the arbitrator contract calls rule.
1552      *  @param _disputeID ID of the dispute to be appealed.
1553      *  @param _extraData Standard but not used by this contract.
1554      */
1555     function appeal(uint _disputeID, bytes _extraData) public payable onlyDuring(Period.Appeal) {
1556         super.appeal(_disputeID,_extraData);
1557         Dispute storage dispute = disputes[_disputeID];
1558         require(msg.value >= appealCost(_disputeID, _extraData));
1559         require(dispute.session+dispute.appeals == session); // Dispute of the current session.
1560         require(dispute.arbitrated == msg.sender);
1561         
1562         dispute.appeals++;
1563         dispute.votes.length++;
1564         dispute.voteCounter.length++;
1565     }
1566 
1567     /** @dev Execute the ruling of a dispute which is in the state executable. UNTRUSTED.
1568      *  @param disputeID ID of the dispute to execute the ruling.
1569      */
1570     function executeRuling(uint disputeID) public {
1571         Dispute storage dispute = disputes[disputeID];
1572         require(dispute.state == DisputeState.Executable);
1573 
1574         dispute.state = DisputeState.Executed;
1575         dispute.arbitrated.rule(disputeID, dispute.voteCounter[dispute.appeals].winningChoice);
1576     }
1577 
1578     // **************************** //
1579     // *   Arbitrator functions   * //
1580     // *    Constant and pure     * //
1581     // **************************** //
1582 
1583     /** @dev Compute the cost of arbitration. It is recommended not to increase it often, 
1584      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1585      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1586      *  @return fee Amount to be paid.
1587      */
1588     function arbitrationCost(bytes _extraData) public view returns (uint fee) {
1589         return extraDataToNbJurors(_extraData) * arbitrationFeePerJuror;
1590     }
1591 
1592     /** @dev Compute the cost of appeal. It is recommended not to increase it often, 
1593      *  as it can be highly time and gas consuming for the arbitrated contracts to cope with fee augmentation.
1594      *  @param _disputeID ID of the dispute to be appealed.
1595      *  @param _extraData Is not used there.
1596      *  @return fee Amount to be paid.
1597      */
1598     function appealCost(uint _disputeID, bytes _extraData) public view returns (uint fee) {
1599         Dispute storage dispute = disputes[_disputeID];
1600 
1601         if(dispute.appeals >= maxAppeals) return NON_PAYABLE_AMOUNT;
1602 
1603         return (2*amountJurors(_disputeID) + 1) * dispute.arbitrationFeePerJuror;
1604     }
1605 
1606     /** @dev Compute the amount of jurors to be drawn.
1607      *  @param _extraData Null for the default number. Other first 16 bits will be used to return the number of jurors.
1608      *  Note that it does not check that the number of jurors is odd, but users are advised to choose a odd number of jurors.
1609      */
1610     function extraDataToNbJurors(bytes _extraData) internal view returns (uint16 nbJurors) {
1611         if (_extraData.length < 2)
1612             return defaultNumberJuror;
1613         else
1614             return (uint16(_extraData[0]) << 8) + uint16(_extraData[1]);
1615     }
1616 
1617     /** @dev Compute the minimum activated pinakions in alpha.
1618      *  Note there may be multiple draws for a single user on a single dispute.
1619      */
1620     function getStakePerDraw() public view returns (uint minActivatedTokenInAlpha) {
1621         return (alpha * minActivatedToken) / ALPHA_DIVISOR;
1622     }
1623 
1624 
1625     // **************************** //
1626     // *     Constant getters     * //
1627     // **************************** //
1628 
1629     /** @dev Getter for account in Vote.
1630      *  @param _disputeID ID of the dispute.
1631      *  @param _appeals Which appeal (or 0 for the initial session).
1632      *  @param _voteID The ID of the vote for this appeal (or initial session).
1633      *  @return account The address of the voter.
1634      */
1635     function getVoteAccount(uint _disputeID, uint _appeals, uint _voteID) public view returns (address account) {
1636         return disputes[_disputeID].votes[_appeals][_voteID].account;
1637     }
1638 
1639     /** @dev Getter for ruling in Vote.
1640      *  @param _disputeID ID of the dispute.
1641      *  @param _appeals Which appeal (or 0 for the initial session).
1642      *  @param _voteID The ID of the vote for this appeal (or initial session).
1643      *  @return ruling The ruling given by the voter.
1644      */
1645     function getVoteRuling(uint _disputeID, uint _appeals, uint _voteID) public view returns (uint ruling) {
1646         return disputes[_disputeID].votes[_appeals][_voteID].ruling;
1647     }
1648 
1649     /** @dev Getter for winningChoice in VoteCounter.
1650      *  @param _disputeID ID of the dispute.
1651      *  @param _appeals Which appeal (or 0 for the initial session).
1652      *  @return winningChoice The currently winning choice (or 0 if it's tied). Note that 0 can also be return if the majority refuses to arbitrate.
1653      */
1654     function getWinningChoice(uint _disputeID, uint _appeals) public view returns (uint winningChoice) {
1655         return disputes[_disputeID].voteCounter[_appeals].winningChoice;
1656     }
1657 
1658     /** @dev Getter for winningCount in VoteCounter.
1659      *  @param _disputeID ID of the dispute.
1660      *  @param _appeals Which appeal (or 0 for the initial session).
1661      *  @return winningCount The amount of votes the winning choice (or those who are tied) has.
1662      */
1663     function getWinningCount(uint _disputeID, uint _appeals) public view returns (uint winningCount) {
1664         return disputes[_disputeID].voteCounter[_appeals].winningCount;
1665     }
1666 
1667     /** @dev Getter for voteCount in VoteCounter.
1668      *  @param _disputeID ID of the dispute.
1669      *  @param _appeals Which appeal (or 0 for the initial session).
1670      *  @param _choice The choice.
1671      *  @return voteCount The amount of votes the winning choice (or those who are tied) has.
1672      */
1673     function getVoteCount(uint _disputeID, uint _appeals, uint _choice) public view returns (uint voteCount) {
1674         return disputes[_disputeID].voteCounter[_appeals].voteCount[_choice];
1675     }
1676 
1677     /** @dev Getter for lastSessionVote in Dispute.
1678      *  @param _disputeID ID of the dispute.
1679      *  @param _juror The juror we want to get the last session he voted.
1680      *  @return lastSessionVote The last session the juror voted.
1681      */
1682     function getLastSessionVote(uint _disputeID, address _juror) public view returns (uint lastSessionVote) {
1683         return disputes[_disputeID].lastSessionVote[_juror];
1684     }
1685 
1686     /** @dev Is the juror drawn in the draw of the dispute.
1687      *  @param _disputeID ID of the dispute.
1688      *  @param _juror The juror.
1689      *  @param _draw The draw. Note that it starts at 1.
1690      *  @return drawn True if the juror is drawn, false otherwise.
1691      */
1692     function isDrawn(uint _disputeID, address _juror, uint _draw) public view returns (bool drawn) {
1693         Dispute storage dispute = disputes[_disputeID];
1694         Juror storage juror = jurors[_juror];
1695         if (juror.lastSession != session
1696         || (dispute.session+dispute.appeals != session)
1697         || period<=Period.Draw
1698         || _draw>amountJurors(_disputeID)
1699         || _draw==0
1700         || segmentSize==0
1701         ) {
1702             return false;
1703         } else {
1704             uint position = uint(keccak256(randomNumber,_disputeID,_draw)) % segmentSize;
1705             return (position >= juror.segmentStart) && (position < juror.segmentEnd);
1706         }
1707 
1708     }
1709 
1710     /** @dev Return the current ruling of a dispute. This is useful for parties to know if they should appeal.
1711      *  @param _disputeID ID of the dispute.
1712      *  @return ruling The current ruling which will be given if there is no appeal. If it is not available, return 0.
1713      */
1714     function currentRuling(uint _disputeID) public view returns (uint ruling) {
1715         Dispute storage dispute = disputes[_disputeID];
1716         return dispute.voteCounter[dispute.appeals].winningChoice;
1717     }
1718 
1719     /** @dev Return the status of a dispute.
1720      *  @param _disputeID ID of the dispute to rule.
1721      *  @return status The status of the dispute.
1722      */
1723     function disputeStatus(uint _disputeID) public view returns (DisputeStatus status) {
1724         Dispute storage dispute = disputes[_disputeID];
1725         if (dispute.session+dispute.appeals < session) // Dispute of past session.
1726             return DisputeStatus.Solved;
1727         else if(dispute.session+dispute.appeals == session) { // Dispute of current session.
1728             if (dispute.state == DisputeState.Open) {
1729                 if (period < Period.Appeal)
1730                     return DisputeStatus.Waiting;
1731                 else if (period == Period.Appeal)
1732                     return DisputeStatus.Appealable;
1733                 else return DisputeStatus.Solved;
1734             } else return DisputeStatus.Solved;
1735         } else return DisputeStatus.Waiting; // Dispute for future session.
1736     }
1737 
1738     // **************************** //
1739     // *     Governor Functions   * //
1740     // **************************** //
1741 
1742     /** @dev General call function where the contract execute an arbitrary call with data and ETH following governor orders.
1743      *  @param _data Transaction data.
1744      *  @param _value Transaction value.
1745      *  @param _target Transaction target.
1746      */
1747     function executeOrder(bytes32 _data, uint _value, address _target) public onlyGovernor {
1748         _target.call.value(_value)(_data);
1749     }
1750 
1751     /** @dev Setter for rng.
1752      *  @param _rng An instance of RNG.
1753      */
1754     function setRng(RNG _rng) public onlyGovernor {
1755         rng = _rng;
1756     }
1757 
1758     /** @dev Setter for arbitrationFeePerJuror.
1759      *  @param _arbitrationFeePerJuror The fee which will be paid to each juror.
1760      */
1761     function setArbitrationFeePerJuror(uint _arbitrationFeePerJuror) public onlyGovernor {
1762         arbitrationFeePerJuror = _arbitrationFeePerJuror;
1763     }
1764 
1765     /** @dev Setter for defaultNumberJuror.
1766      *  @param _defaultNumberJuror Number of drawn jurors unless specified otherwise.
1767      */
1768     function setDefaultNumberJuror(uint16 _defaultNumberJuror) public onlyGovernor {
1769         defaultNumberJuror = _defaultNumberJuror;
1770     }
1771 
1772     /** @dev Setter for minActivatedToken.
1773      *  @param _minActivatedToken Minimum of tokens to be activated (in basic units).
1774      */
1775     function setMinActivatedToken(uint _minActivatedToken) public onlyGovernor {
1776         minActivatedToken = _minActivatedToken;
1777     }
1778 
1779     /** @dev Setter for timePerPeriod.
1780      *  @param _timePerPeriod The minimum time each period lasts (seconds).
1781      */
1782     function setTimePerPeriod(uint[5] _timePerPeriod) public onlyGovernor {
1783         timePerPeriod = _timePerPeriod;
1784     }
1785 
1786     /** @dev Setter for alpha.
1787      *  @param _alpha Alpha in ‱.
1788      */
1789     function setAlpha(uint _alpha) public onlyGovernor {
1790         alpha = _alpha;
1791     }
1792 
1793     /** @dev Setter for maxAppeals.
1794      *  @param _maxAppeals Number of times a dispute can be appealed. When exceeded appeal cost becomes NON_PAYABLE_AMOUNT.
1795      */
1796     function setMaxAppeals(uint _maxAppeals) public onlyGovernor {
1797         maxAppeals = _maxAppeals;
1798     }
1799 
1800     /** @dev Setter for governor.
1801      *  @param _governor Address of the governor contract.
1802      */
1803     function setGovernor(address _governor) public onlyGovernor {
1804         governor = _governor;
1805     }
1806 }