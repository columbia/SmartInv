1 pragma solidity ^0.4.8;
2 
3 contract ERC20 {
4   function totalSupply() constant returns (uint);
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 contract SafeMath {
17   function safeMul(uint a, uint b) internal returns (uint) {
18     uint c = a * b;
19     assert(a == 0 || c / a == b);
20     return c;
21   }
22 
23   function safeDiv(uint a, uint b) internal returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29 
30   function safeSub(uint a, uint b) internal returns (uint) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function safeAdd(uint a, uint b) internal returns (uint) {
36     uint c = a + b;
37     assert(c>=a && c>=b);
38     return c;
39   }
40 
41   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
42     return a >= b ? a : b;
43   }
44 
45   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
46     return a < b ? a : b;
47   }
48 
49   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
50     return a >= b ? a : b;
51   }
52 
53   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
54     return a < b ? a : b;
55   }
56 
57   function assert(bool assertion) internal {
58     if (!assertion) {
59       throw;
60     }
61   }
62 }
63 contract ApproveAndCallReceiver {
64     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data);
65 }
66 
67 contract Controlled {
68     /// @notice The address of the controller is the only address that can call
69     ///  a function with this modifier
70     modifier onlyController { if (msg.sender != controller) throw; _; }
71 
72     address public controller;
73 
74     function Controlled() { controller = msg.sender;}
75 
76     /// @notice Changes the controller of the contract
77     /// @param _newController The new controller of the contract
78     function changeController(address _newController) onlyController {
79         controller = _newController;
80     }
81 }
82 contract AbstractSale {
83   function saleFinalized() constant returns (bool);
84 }
85 
86 contract SaleWallet {
87   // Public variables
88   address public multisig;
89   uint public finalBlock;
90   AbstractSale public tokenSale;
91 
92   // @dev Constructor initializes public variables
93   // @param _multisig The address of the multisig that will receive the funds
94   // @param _finalBlock Block after which the multisig can request the funds
95   function SaleWallet(address _multisig, uint _finalBlock, address _tokenSale) {
96     multisig = _multisig;
97     finalBlock = _finalBlock;
98     tokenSale = AbstractSale(_tokenSale);
99   }
100 
101   // @dev Receive all sent funds without any further logic
102   function () public payable {}
103 
104   // @dev Withdraw function sends all the funds to the wallet if conditions are correct
105   function withdraw() public {
106     if (msg.sender != multisig) throw;                       // Only the multisig can request it
107     if (block.number > finalBlock) return doWithdraw();      // Allow after the final block
108     if (tokenSale.saleFinalized()) return doWithdraw();      // Allow when sale is finalized
109   }
110 
111   function doWithdraw() internal {
112     if (!multisig.send(this.balance)) throw;
113   }
114 }
115 
116 contract Controller {
117     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
118     /// @param _owner The address that sent the ether to create tokens
119     /// @return True if the ether is accepted, false if it throws
120     function proxyPayment(address _owner) payable returns(bool);
121 
122     /// @notice Notifies the controller about a token transfer allowing the
123     ///  controller to react if desired
124     /// @param _from The origin of the transfer
125     /// @param _to The destination of the transfer
126     /// @param _amount The amount of the transfer
127     /// @return False if the controller does not authorize the transfer
128     function onTransfer(address _from, address _to, uint _amount) returns(bool);
129 
130     /// @notice Notifies the controller about an approval allowing the
131     ///  controller to react if desired
132     /// @param _owner The address that calls `approve()`
133     /// @param _spender The spender in the `approve()` call
134     /// @param _amount The amount in the `approve()` call
135     /// @return False if the controller does not authorize the approval
136     function onApprove(address _owner, address _spender, uint _amount)
137         returns(bool);
138 }
139 
140 contract ANPlaceholder is Controller {
141   address public sale;
142   ANT public token;
143 
144   function ANPlaceholder(address _sale, address _ant) {
145     sale = _sale;
146     token = ANT(_ant);
147   }
148 
149   function changeController(address network) public {
150     if (msg.sender != sale) throw;
151     token.changeController(network);
152     suicide(network);
153   }
154 
155   // In between the sale and the network. Default settings for allowing token transfers.
156   function proxyPayment(address _owner) payable public returns (bool) {
157     throw;
158     return false;
159   }
160 
161   function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
162     return true;
163   }
164 
165   function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
166     return true;
167   }
168 }
169 
170 
171 
172 
173 contract MiniMeToken is ERC20, Controlled {
174     string public name;                //The Token's name: e.g. DigixDAO Tokens
175     uint8 public decimals;             //Number of decimals of the smallest unit
176     string public symbol;              //An identifier: e.g. REP
177     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
178 
179 
180     /// @dev `Checkpoint` is the structure that attaches a block number to a
181     ///  given value, the block number attached is the one that last changed the
182     ///  value
183     struct  Checkpoint {
184 
185         // `fromBlock` is the block number that the value was generated from
186         uint128 fromBlock;
187 
188         // `value` is the amount of tokens at a specific block number
189         uint128 value;
190     }
191 
192     // `parentToken` is the Token address that was cloned to produce this token;
193     //  it will be 0x0 for a token that was not cloned
194     MiniMeToken public parentToken;
195 
196     // `parentSnapShotBlock` is the block number from the Parent Token that was
197     //  used to determine the initial distribution of the Clone Token
198     uint public parentSnapShotBlock;
199 
200     // `creationBlock` is the block number that the Clone Token was created
201     uint public creationBlock;
202 
203     // `balances` is the map that tracks the balance of each address, in this
204     //  contract when the balance changes the block number that the change
205     //  occurred is also included in the map
206     mapping (address => Checkpoint[]) balances;
207 
208     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
209     mapping (address => mapping (address => uint256)) allowed;
210 
211     // Tracks the history of the `totalSupply` of the token
212     Checkpoint[] totalSupplyHistory;
213 
214     // Flag that determines if the token is transferable or not.
215     bool public transfersEnabled;
216 
217     // The factory used to create new clone tokens
218     MiniMeTokenFactory public tokenFactory;
219 
220 ////////////////
221 // Constructor
222 ////////////////
223 
224     /// @notice Constructor to create a MiniMeToken
225     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
226     ///  will create the Clone token contracts, the token factory needs to be
227     ///  deployed first
228     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
229     ///  new token
230     /// @param _parentSnapShotBlock Block of the parent token that will
231     ///  determine the initial distribution of the clone token, set to 0 if it
232     ///  is a new token
233     /// @param _tokenName Name of the new token
234     /// @param _decimalUnits Number of decimals of the new token
235     /// @param _tokenSymbol Token Symbol for the new token
236     /// @param _transfersEnabled If true, tokens will be able to be transferred
237     function MiniMeToken(
238         address _tokenFactory,
239         address _parentToken,
240         uint _parentSnapShotBlock,
241         string _tokenName,
242         uint8 _decimalUnits,
243         string _tokenSymbol,
244         bool _transfersEnabled
245     ) {
246         tokenFactory = MiniMeTokenFactory(_tokenFactory);
247         name = _tokenName;                                 // Set the name
248         decimals = _decimalUnits;                          // Set the decimals
249         symbol = _tokenSymbol;                             // Set the symbol
250         parentToken = MiniMeToken(_parentToken);
251         parentSnapShotBlock = _parentSnapShotBlock;
252         transfersEnabled = _transfersEnabled;
253         creationBlock = block.number;
254     }
255 
256 
257 ///////////////////
258 // ERC20 Methods
259 ///////////////////
260 
261     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
262     /// @param _to The address of the recipient
263     /// @param _amount The amount of tokens to be transferred
264     /// @return Whether the transfer was successful or not
265     function transfer(address _to, uint256 _amount) returns (bool success) {
266         if (!transfersEnabled) throw;
267         return doTransfer(msg.sender, _to, _amount);
268     }
269 
270     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
271     ///  is approved by `_from`
272     /// @param _from The address holding the tokens being transferred
273     /// @param _to The address of the recipient
274     /// @param _amount The amount of tokens to be transferred
275     /// @return True if the transfer was successful
276     function transferFrom(address _from, address _to, uint256 _amount
277     ) returns (bool success) {
278 
279         // The controller of this contract can move tokens around at will,
280         //  this is important to recognize! Confirm that you trust the
281         //  controller of this contract, which in most situations should be
282         //  another open source smart contract or 0x0
283         if (msg.sender != controller) {
284             if (!transfersEnabled) throw;
285 
286             // The standard ERC 20 transferFrom functionality
287             if (allowed[_from][msg.sender] < _amount) throw;
288             allowed[_from][msg.sender] -= _amount;
289         }
290         return doTransfer(_from, _to, _amount);
291     }
292 
293     /// @dev This is the actual transfer function in the token contract, it can
294     ///  only be called by other functions in this contract.
295     /// @param _from The address holding the tokens being transferred
296     /// @param _to The address of the recipient
297     /// @param _amount The amount of tokens to be transferred
298     /// @return True if the transfer was successful
299     function doTransfer(address _from, address _to, uint _amount
300     ) internal returns(bool) {
301 
302            if (_amount == 0) {
303                return true;
304            }
305 
306            // Do not allow transfer to 0x0 or the token contract itself
307            if ((_to == 0) || (_to == address(this))) throw;
308 
309            // If the amount being transfered is more than the balance of the
310            //  account the transfer returns false
311            var previousBalanceFrom = balanceOfAt(_from, block.number);
312            if (previousBalanceFrom < _amount) {
313                throw;
314            }
315 
316            // Alerts the token controller of the transfer
317            if (isContract(controller)) {
318                if (!Controller(controller).onTransfer(_from, _to, _amount)) throw;
319            }
320 
321            // First update the balance array with the new value for the address
322            //  sending the tokens
323            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
324 
325            // Then update the balance array with the new value for the address
326            //  receiving the tokens
327            var previousBalanceTo = balanceOfAt(_to, block.number);
328            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
329            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
330 
331            // An event to make the transfer easy to find on the blockchain
332            Transfer(_from, _to, _amount);
333 
334            return true;
335     }
336 
337     /// @param _owner The address that's balance is being requested
338     /// @return The balance of `_owner` at the current block
339     function balanceOf(address _owner) constant returns (uint256 balance) {
340         return balanceOfAt(_owner, block.number);
341     }
342 
343     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
344     ///  its behalf. This is a modified version of the ERC20 approve function
345     ///  to be a little bit safer
346     /// @param _spender The address of the account able to transfer the tokens
347     /// @param _amount The amount of tokens to be approved for transfer
348     /// @return True if the approval was successful
349     function approve(address _spender, uint256 _amount) returns (bool success) {
350         if (!transfersEnabled) throw;
351 
352         // To change the approve amount you first have to reduce the addresses´
353         //  allowance to zero by calling `approve(_spender,0)` if it is not
354         //  already 0 to mitigate the race condition described here:
355         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
356         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
357 
358         // Alerts the token controller of the approve function call
359         if (isContract(controller)) {
360             if (!Controller(controller).onApprove(msg.sender, _spender, _amount))
361                 throw;
362         }
363 
364         allowed[msg.sender][_spender] = _amount;
365         Approval(msg.sender, _spender, _amount);
366         return true;
367     }
368 
369     /// @dev This function makes it easy to read the `allowed[]` map
370     /// @param _owner The address of the account that owns the token
371     /// @param _spender The address of the account able to transfer the tokens
372     /// @return Amount of remaining tokens of _owner that _spender is allowed
373     ///  to spend
374     function allowance(address _owner, address _spender
375     ) constant returns (uint256 remaining) {
376         return allowed[_owner][_spender];
377     }
378 
379     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
380     ///  its behalf, and then a function is triggered in the contract that is
381     ///  being approved, `_spender`. This allows users to use their tokens to
382     ///  interact with contracts in one function call instead of two
383     /// @param _spender The address of the contract able to transfer the tokens
384     /// @param _amount The amount of tokens to be approved for transfer
385     /// @return True if the function call was successful
386     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
387     ) returns (bool success) {
388         approve(_spender, _amount);
389 
390         // This portion is copied from ConsenSys's Standard Token Contract. It
391         //  calls the receiveApproval function that is part of the contract that
392         //  is being approved (`_spender`). The function should look like:
393         //  `receiveApproval(address _from, uint256 _amount, address
394         //  _tokenContract, bytes _extraData)` It is assumed that the call
395         //  *should* succeed, otherwise the plain vanilla approve would be used
396         ApproveAndCallReceiver(_spender).receiveApproval(
397            msg.sender,
398            _amount,
399            this,
400            _extraData
401         );
402         return true;
403     }
404 
405     /// @dev This function makes it easy to get the total number of tokens
406     /// @return The total number of tokens
407     function totalSupply() constant returns (uint) {
408         return totalSupplyAt(block.number);
409     }
410 
411 
412 ////////////////
413 // Query balance and totalSupply in History
414 ////////////////
415 
416     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
417     /// @param _owner The address from which the balance will be retrieved
418     /// @param _blockNumber The block number when the balance is queried
419     /// @return The balance at `_blockNumber`
420     function balanceOfAt(address _owner, uint _blockNumber) constant
421         returns (uint) {
422 
423         // These next few lines are used when the balance of the token is
424         //  requested before a check point was ever created for this token, it
425         //  requires that the `parentToken.balanceOfAt` be queried at the
426         //  genesis block for that token as this contains initial balance of
427         //  this token
428         if ((balances[_owner].length == 0)
429             || (balances[_owner][0].fromBlock > _blockNumber)) {
430             if (address(parentToken) != 0) {
431                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
432             } else {
433                 // Has no parent
434                 return 0;
435             }
436 
437         // This will return the expected balance during normal situations
438         } else {
439             return getValueAt(balances[_owner], _blockNumber);
440         }
441     }
442 
443     /// @notice Total amount of tokens at a specific `_blockNumber`.
444     /// @param _blockNumber The block number when the totalSupply is queried
445     /// @return The total amount of tokens at `_blockNumber`
446     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
447 
448         // These next few lines are used when the totalSupply of the token is
449         //  requested before a check point was ever created for this token, it
450         //  requires that the `parentToken.totalSupplyAt` be queried at the
451         //  genesis block for this token as that contains totalSupply of this
452         //  token at this block number.
453         if ((totalSupplyHistory.length == 0)
454             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
455             if (address(parentToken) != 0) {
456                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
457             } else {
458                 return 0;
459             }
460 
461         // This will return the expected totalSupply during normal situations
462         } else {
463             return getValueAt(totalSupplyHistory, _blockNumber);
464         }
465     }
466 
467     function min(uint a, uint b) internal returns (uint) {
468       return a < b ? a : b;
469     }
470 
471 ////////////////
472 // Clone Token Method
473 ////////////////
474 
475     /// @notice Creates a new clone token with the initial distribution being
476     ///  this token at `_snapshotBlock`
477     /// @param _cloneTokenName Name of the clone token
478     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
479     /// @param _cloneTokenSymbol Symbol of the clone token
480     /// @param _snapshotBlock Block when the distribution of the parent token is
481     ///  copied to set the initial distribution of the new clone token;
482     ///  if the block is higher than the actual block, the current block is used
483     /// @param _transfersEnabled True if transfers are allowed in the clone
484     /// @return The address of the new MiniMeToken Contract
485     function createCloneToken(
486         string _cloneTokenName,
487         uint8 _cloneDecimalUnits,
488         string _cloneTokenSymbol,
489         uint _snapshotBlock,
490         bool _transfersEnabled
491         ) returns(address) {
492         if (_snapshotBlock > block.number) _snapshotBlock = block.number;
493         MiniMeToken cloneToken = tokenFactory.createCloneToken(
494             this,
495             _snapshotBlock,
496             _cloneTokenName,
497             _cloneDecimalUnits,
498             _cloneTokenSymbol,
499             _transfersEnabled
500             );
501 
502         cloneToken.changeController(msg.sender);
503 
504         // An event to make the token easy to find on the blockchain
505         NewCloneToken(address(cloneToken), _snapshotBlock);
506         return address(cloneToken);
507     }
508 
509 ////////////////
510 // Generate and destroy tokens
511 ////////////////
512 
513     /// @notice Generates `_amount` tokens that are assigned to `_owner`
514     /// @param _owner The address that will be assigned the new tokens
515     /// @param _amount The quantity of tokens generated
516     /// @return True if the tokens are generated correctly
517     function generateTokens(address _owner, uint _amount
518     ) onlyController returns (bool) {
519         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
520         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
521         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
522         var previousBalanceTo = balanceOf(_owner);
523         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
524         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
525         Transfer(0, _owner, _amount);
526         return true;
527     }
528 
529 
530     /// @notice Burns `_amount` tokens from `_owner`
531     /// @param _owner The address that will lose the tokens
532     /// @param _amount The quantity of tokens to burn
533     /// @return True if the tokens are burned correctly
534     function destroyTokens(address _owner, uint _amount
535     ) onlyController returns (bool) {
536         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
537         if (curTotalSupply < _amount) throw;
538         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
539         var previousBalanceFrom = balanceOf(_owner);
540         if (previousBalanceFrom < _amount) throw;
541         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
542         Transfer(_owner, 0, _amount);
543         return true;
544     }
545 
546 ////////////////
547 // Enable tokens transfers
548 ////////////////
549 
550 
551     /// @notice Enables token holders to transfer their tokens freely if true
552     /// @param _transfersEnabled True if transfers are allowed in the clone
553     function enableTransfers(bool _transfersEnabled) onlyController {
554         transfersEnabled = _transfersEnabled;
555     }
556 
557 ////////////////
558 // Internal helper functions to query and set a value in a snapshot array
559 ////////////////
560 
561     /// @dev `getValueAt` retrieves the number of tokens at a given block number
562     /// @param checkpoints The history of values being queried
563     /// @param _block The block number to retrieve the value at
564     /// @return The number of tokens being queried
565     function getValueAt(Checkpoint[] storage checkpoints, uint _block
566     ) constant internal returns (uint) {
567         if (checkpoints.length == 0) return 0;
568 
569         // Shortcut for the actual value
570         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
571             return checkpoints[checkpoints.length-1].value;
572         if (_block < checkpoints[0].fromBlock) return 0;
573 
574         // Binary search of the value in the array
575         uint min = 0;
576         uint max = checkpoints.length-1;
577         while (max > min) {
578             uint mid = (max + min + 1)/ 2;
579             if (checkpoints[mid].fromBlock<=_block) {
580                 min = mid;
581             } else {
582                 max = mid-1;
583             }
584         }
585         return checkpoints[min].value;
586     }
587 
588     /// @dev `updateValueAtNow` used to update the `balances` map and the
589     ///  `totalSupplyHistory`
590     /// @param checkpoints The history of data being updated
591     /// @param _value The new number of tokens
592     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
593     ) internal  {
594         if ((checkpoints.length == 0)
595         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
596                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
597                newCheckPoint.fromBlock =  uint128(block.number);
598                newCheckPoint.value = uint128(_value);
599            } else {
600                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
601                oldCheckPoint.value = uint128(_value);
602            }
603     }
604 
605     /// @dev Internal function to determine if an address is a contract
606     /// @param _addr The address being queried
607     /// @return True if `_addr` is a contract
608     function isContract(address _addr) constant internal returns(bool) {
609         uint size;
610         if (_addr == 0) return false;
611         assembly {
612             size := extcodesize(_addr)
613         }
614         return size>0;
615     }
616 
617     /// @notice The fallback function: If the contract's controller has not been
618     ///  set to 0, then the `proxyPayment` method is called which relays the
619     ///  ether and creates tokens as described in the token controller contract
620     function ()  payable {
621         if (isContract(controller)) {
622             if (! Controller(controller).proxyPayment.value(msg.value)(msg.sender))
623                 throw;
624         } else {
625             throw;
626         }
627     }
628 
629 
630 ////////////////
631 // Events
632 ////////////////
633     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
634 }
635 
636 
637 ////////////////
638 // MiniMeTokenFactory
639 ////////////////
640 
641 /// @dev This contract is used to generate clone contracts from a contract.
642 ///  In solidity this is the way to create a contract from a contract of the
643 ///  same class
644 contract MiniMeTokenFactory {
645 
646     /// @notice Update the DApp by creating a new token with new functionalities
647     ///  the msg.sender becomes the controller of this clone token
648     /// @param _parentToken Address of the token being cloned
649     /// @param _snapshotBlock Block of the parent token that will
650     ///  determine the initial distribution of the clone token
651     /// @param _tokenName Name of the new token
652     /// @param _decimalUnits Number of decimals of the new token
653     /// @param _tokenSymbol Token Symbol for the new token
654     /// @param _transfersEnabled If true, tokens will be able to be transferred
655     /// @return The address of the new token contract
656     function createCloneToken(
657         address _parentToken,
658         uint _snapshotBlock,
659         string _tokenName,
660         uint8 _decimalUnits,
661         string _tokenSymbol,
662         bool _transfersEnabled
663     ) returns (MiniMeToken) {
664         MiniMeToken newToken = new MiniMeToken(
665             this,
666             _parentToken,
667             _snapshotBlock,
668             _tokenName,
669             _decimalUnits,
670             _tokenSymbol,
671             _transfersEnabled
672             );
673 
674         newToken.changeController(msg.sender);
675         return newToken;
676     }
677 }
678 
679 
680 /*
681     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
682 
683     Based on VestedToken.sol from https://github.com/OpenZeppelin/zeppelin-solidity
684 
685     SafeMath – Copyright (c) 2016 Smart Contract Solutions, Inc.
686     MiniMeToken – Copyright 2017, Jordi Baylina (Giveth)
687  */
688 
689 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
690 // ability to createTokenGrants which are basically a transfer that limits the
691 // receiver of the tokens how can he spend them over time.
692 
693 // For simplicity, token grants are not saved in MiniMe type checkpoints.
694 // Vanilla cloning ANT will clone it into a MiniMeToken without vesting.
695 // More complex cloning could account for past vesting calendars.
696 
697 contract MiniMeIrrevocableVestedToken is MiniMeToken, SafeMath {
698   // Keep the struct at 2 sstores (1 slot for value + 64 * 3 (dates) + 20 (address) = 2 slots (2nd slot is 212 bytes, lower than 256))
699   struct TokenGrant {
700     address granter;
701     uint256 value;
702     uint64 cliff;
703     uint64 vesting;
704     uint64 start;
705   }
706 
707   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting);
708 
709   mapping (address => TokenGrant[]) public grants;
710 
711   mapping (address => bool) canCreateGrants;
712   address vestingWhitelister;
713 
714   modifier canTransfer(address _sender, uint _value) {
715     if (_value > spendableBalanceOf(_sender)) throw;
716     _;
717   }
718 
719   modifier onlyVestingWhitelister {
720     if (msg.sender != vestingWhitelister) throw;
721     _;
722   }
723 
724   function MiniMeIrrevocableVestedToken (
725       address _tokenFactory,
726       address _parentToken,
727       uint _parentSnapShotBlock,
728       string _tokenName,
729       uint8 _decimalUnits,
730       string _tokenSymbol,
731       bool _transfersEnabled
732   ) MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
733     vestingWhitelister = msg.sender;
734     doSetCanCreateGrants(vestingWhitelister, true);
735   }
736 
737   // @dev Add canTransfer modifier before allowing transfer and transferFrom to go through
738   function transfer(address _to, uint _value)
739            canTransfer(msg.sender, _value)
740            public
741            returns (bool success) {
742     return super.transfer(_to, _value);
743   }
744 
745   function transferFrom(address _from, address _to, uint _value)
746            canTransfer(_from, _value)
747            public
748            returns (bool success) {
749     return super.transferFrom(_from, _to, _value);
750   }
751 
752   function spendableBalanceOf(address _holder) constant public returns (uint) {
753     return transferableTokens(_holder, uint64(now));
754   }
755 
756   function grantVestedTokens(
757     address _to,
758     uint256 _value,
759     uint64 _start,
760     uint64 _cliff,
761     uint64 _vesting) public {
762 
763     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
764     if (_cliff < _start) throw;
765     if (_vesting < _start) throw;
766     if (_vesting < _cliff) throw;
767 
768     if (!canCreateGrants[msg.sender]) throw;
769     if (tokenGrantsCount(_to) > 20) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
770 
771     TokenGrant memory grant = TokenGrant(msg.sender, _value, _cliff, _vesting, _start);
772     grants[_to].push(grant);
773 
774     if (!transfer(_to, _value)) throw;
775 
776     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start);
777   }
778 
779   function setCanCreateGrants(address _addr, bool _allowed)
780            onlyVestingWhitelister public {
781     doSetCanCreateGrants(_addr, _allowed);
782   }
783 
784   function doSetCanCreateGrants(address _addr, bool _allowed)
785            internal {
786     canCreateGrants[_addr] = _allowed;
787   }
788 
789   function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
790     doSetCanCreateGrants(vestingWhitelister, false);
791     vestingWhitelister = _newWhitelister;
792     doSetCanCreateGrants(vestingWhitelister, true);
793   }
794 
795   // @dev Not allow token grants
796   function revokeTokenGrant(address _holder, uint _grantId) public {
797     throw;
798   }
799 
800   //
801   function tokenGrantsCount(address _holder) constant public returns (uint index) {
802     return grants[_holder].length;
803   }
804 
805   function tokenGrant(address _holder, uint _grantId) constant public returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting) {
806     TokenGrant grant = grants[_holder][_grantId];
807 
808     granter = grant.granter;
809     value = grant.value;
810     start = grant.start;
811     cliff = grant.cliff;
812     vesting = grant.vesting;
813 
814     vested = vestedTokens(grant, uint64(now));
815   }
816 
817   function vestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
818     return calculateVestedTokens(
819       grant.value,
820       uint256(time),
821       uint256(grant.start),
822       uint256(grant.cliff),
823       uint256(grant.vesting)
824     );
825   }
826 
827   //  transferableTokens
828   //   |                         _/--------   NonVestedTokens
829   //   |                       _/
830   //   |                     _/
831   //   |                   _/
832   //   |                 _/
833   //   |                /
834   //   |              .|
835   //   |            .  |
836   //   |          .    |
837   //   |        .      |
838   //   |      .        |
839   //   |    .          |
840   //   +===+===========+---------+----------> time
841   //      Start       Clift    Vesting
842 
843   function calculateVestedTokens(
844     uint256 tokens,
845     uint256 time,
846     uint256 start,
847     uint256 cliff,
848     uint256 vesting) internal constant returns (uint256)
849     {
850 
851     // Shortcuts for before cliff and after vesting cases.
852     if (time < cliff) return 0;
853     if (time >= vesting) return tokens;
854 
855     // Interpolate all vested tokens.
856     // As before cliff the shortcut returns 0, we can use just this function to
857     // calculate it.
858 
859     // vestedTokens = tokens * (time - start) / (vesting - start)
860     uint256 vestedTokens = safeDiv(
861                                   safeMul(
862                                     tokens,
863                                     safeSub(time, start)
864                                     ),
865                                   safeSub(vesting, start)
866                                   );
867 
868     return vestedTokens;
869   }
870 
871   function nonVestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
872     // Of all the tokens of the grant, how many of them are not vested?
873     // grantValue - vestedTokens
874     return safeSub(grant.value, vestedTokens(grant, time));
875   }
876 
877   // @dev The date in which all tokens are transferable for the holder
878   // Useful for displaying purposes (not used in any logic calculations)
879   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
880     date = uint64(now);
881     uint256 grantIndex = tokenGrantsCount(holder);
882     for (uint256 i = 0; i < grantIndex; i++) {
883       date = max64(grants[holder][i].vesting, date);
884     }
885     return date;
886   }
887 
888   // @dev How many tokens can a holder transfer at a point in time
889   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
890     uint256 grantIndex = tokenGrantsCount(holder);
891 
892     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
893 
894     // Iterate through all the grants the holder has, and add all non-vested tokens
895     uint256 nonVested = 0;
896     for (uint256 i = 0; i < grantIndex; i++) {
897       nonVested = safeAdd(nonVested, nonVestedTokens(grants[holder][i], time));
898     }
899 
900     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
901     return safeSub(balanceOf(holder), nonVested);
902   }
903 }
904 
905 /*
906     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
907 */
908 
909 contract ANT is MiniMeIrrevocableVestedToken {
910   // @dev ANT constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
911   function ANT(
912     address _tokenFactory
913   ) MiniMeIrrevocableVestedToken(
914     _tokenFactory,
915     0x0,                    // no parent token
916     0,                      // no snapshot block number from parent
917     "Aragon Network Token", // Token name
918     18,                     // Decimals
919     "ANT",                  // Symbol
920     true                    // Enable transfers
921     ) {}
922 }