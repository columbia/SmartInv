1 pragma solidity ^0.4.13;
2 
3 contract SafeMath {
4   function safeMul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint a, uint b) internal returns (uint) {
11     assert(b > 0);
12     uint c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint a, uint b) internal returns (uint) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint a, uint b) internal returns (uint) {
23     uint c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
29     return a >= b ? a : b;
30   }
31 
32   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a < b ? a : b;
34   }
35 
36   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
37     return a >= b ? a : b;
38   }
39 
40   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a < b ? a : b;
42   }
43 
44   function assert(bool assertion) internal {
45     require(assertion);
46   }
47 }
48 
49 
50 /*
51     Copyright 2017, Jordi Baylina (Giveth)
52 
53     Based on MiniMeToken.sol from https://github.com/Giveth/minime
54  */
55 
56 contract Controlled {
57     /// @notice The address of the controller is the only address that can call
58     ///  a function with this modifier
59     modifier onlyController{ require(msg.sender==controller); _; }
60 
61 
62     address public controller;
63 
64     function Controlled() { controller = msg.sender;}
65 
66     /// @notice Changes the controller of the contract
67     /// @param _newController The new controller of the contract
68     function changeController(address _newController) onlyController {
69         controller = _newController;
70     }
71 }
72 
73 /*
74     Copyright 2017, Jordi Baylina (Giveth)
75 
76     Based on MiniMeToken.sol from https://github.com/Giveth/minime
77  */
78 
79 /// @dev The token controller contract must implement these functions
80 contract Controller {
81     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
82     /// @param _owner The address that sent the ether to create tokens
83     /// @return True if the ether is accepted, false if it throws
84     function proxyPayment(address _owner) payable returns(bool);
85 
86     /// @notice Notifies the controller about a token transfer allowing the
87     ///  controller to react if desired
88     /// @param _from The origin of the transfer
89     /// @param _to The destination of the transfer
90     /// @param _amount The amount of the transfer
91     /// @return False if the controller does not authorize the transfer
92     function onTransfer(address _from, address _to, uint _amount) returns(bool);
93 
94     /// @notice Notifies the controller about an approval allowing the
95     ///  controller to react if desired
96     /// @param _owner The address that calls `approve()`
97     /// @param _spender The spender in the `approve()` call
98     /// @param _amount The amount in the `approve()` call
99     /// @return False if the controller does not authorize the approval
100     function onApprove(address _owner, address _spender, uint _amount)
101         returns(bool);
102 }
103 
104 contract ApproveAndCallReceiver {
105     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data);
106 }
107 
108 
109 /*
110  * ERC20 interface
111  * see https://github.com/ethereum/EIPs/issues/20
112  */
113 contract ERC20 {
114   function totalSupply() constant returns (uint);
115   function balanceOf(address who) constant returns (uint);
116   function allowance(address owner, address spender) constant returns (uint);
117 
118   function transfer(address to, uint value) returns (bool ok);
119   function transferFrom(address from, address to, uint value) returns (bool ok);
120   function approve(address spender, uint value) returns (bool ok);
121   event Transfer(address indexed from, address indexed to, uint value);
122   event Approval(address indexed owner, address indexed spender, uint value);
123 }
124 
125 contract MiniMeToken is ERC20, Controlled {
126     string public name;                //The Token's name: e.g. DigixDAO Tokens
127     uint8 public decimals;             //Number of decimals of the smallest unit
128     string public symbol;              //An identifier: e.g. REP
129     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
130 
131 
132     /// @dev `Checkpoint` is the structure that attaches a block number to a
133     ///  given value, the block number attached is the one that last changed the
134     ///  value
135     struct  Checkpoint {
136 
137         // `fromBlock` is the block number that the value was generated from
138         uint128 fromBlock;
139 
140         // `value` is the amount of tokens at a specific block number
141         uint128 value;
142     }
143 
144     // `parentToken` is the Token address that was cloned to produce this token;
145     //  it will be 0x0 for a token that was not cloned
146     MiniMeToken public parentToken;
147 
148     // `parentSnapShotBlock` is the block number from the Parent Token that was
149     //  used to determine the initial distribution of the Clone Token
150     uint public parentSnapShotBlock;
151 
152     // `creationBlock` is the block number that the Clone Token was created
153     uint public creationBlock;
154 
155     // `balances` is the map that tracks the balance of each address, in this
156     //  contract when the balance changes the block number that the change
157     //  occurred is also included in the map
158     mapping (address => Checkpoint[]) balances;
159 
160     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
161     mapping (address => mapping (address => uint256)) allowed;
162 
163     // Tracks the history of the `totalSupply` of the token
164     Checkpoint[] totalSupplyHistory;
165 
166     // Flag that determines if the token is transferable or not.
167     bool public transfersEnabled;
168 
169     // The factory used to create new clone tokens
170     MiniMeTokenFactory public tokenFactory;
171 
172 ////////////////
173 // Constructor
174 ////////////////
175 
176     /// @notice Constructor to create a MiniMeToken
177     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
178     ///  will create the Clone token contracts, the token factory needs to be
179     ///  deployed first
180     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
181     ///  new token
182     /// @param _parentSnapShotBlock Block of the parent token that will
183     ///  determine the initial distribution of the clone token, set to 0 if it
184     ///  is a new token
185     /// @param _tokenName Name of the new token
186     /// @param _decimalUnits Number of decimals of the new token
187     /// @param _tokenSymbol Token Symbol for the new token
188     /// @param _transfersEnabled If true, tokens will be able to be transferred
189     function MiniMeToken(
190         address _tokenFactory,
191         address _parentToken,
192         uint _parentSnapShotBlock,
193         string _tokenName,
194         uint8 _decimalUnits,
195         string _tokenSymbol,
196         bool _transfersEnabled
197     ) {
198         tokenFactory = MiniMeTokenFactory(_tokenFactory);
199         name = _tokenName;                                 // Set the name
200         decimals = _decimalUnits;                          // Set the decimals
201         symbol = _tokenSymbol;                             // Set the symbol
202         parentToken = MiniMeToken(_parentToken);
203         parentSnapShotBlock = _parentSnapShotBlock;
204         transfersEnabled = _transfersEnabled;
205         creationBlock = block.number;
206     }
207 
208 
209 ///////////////////
210 // ERC20 Methods
211 ///////////////////
212 
213     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
214     /// @param _to The address of the recipient
215     /// @param _amount The amount of tokens to be transferred
216     /// @return Whether the transfer was successful or not
217     function transfer(address _to, uint256 _amount) returns (bool success) {
218         require (transfersEnabled);
219     ////if (!transfersEnabled) throw;
220         return doTransfer(msg.sender, _to, _amount);
221     }
222 
223     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
224     ///  is approved by `_from`
225     /// @param _from The address holding the tokens being transferred
226     /// @param _to The address of the recipient
227     /// @param _amount The amount of tokens to be transferred
228     /// @return True if the transfer was successful
229     function transferFrom(address _from, address _to, uint256 _amount
230     ) returns (bool success) {
231 
232         // The controller of this contract can move tokens around at will,
233         //  this is important to recognize! Confirm that you trust the
234         //  controller of this contract, which in most situations should be
235         //  another open source smart contract or 0x0
236         if (msg.sender != controller) {
237             require (transfersEnabled);
238 
239             ////if (!transfersEnabled) throw;
240 
241             // The standard ERC 20 transferFrom functionality
242             assert (allowed[_from][msg.sender]>=_amount);
243 
244             ////if (allowed[_from][msg.sender] < _amount) throw;
245             allowed[_from][msg.sender] -= _amount;
246         }
247         return doTransfer(_from, _to, _amount);
248     }
249 
250     /// @dev This is the actual transfer function in the token contract, it can
251     ///  only be called by other functions in this contract.
252     /// @param _from The address holding the tokens being transferred
253     /// @param _to The address of the recipient
254     /// @param _amount The amount of tokens to be transferred
255     /// @return True if the transfer was successful
256     function doTransfer(address _from, address _to, uint _amount
257     ) internal returns(bool) {
258            if (_amount == 0) {
259                return true;
260            }
261 
262            // Do not allow transfer to 0x0 or the token contract itself
263            require((_to!=0)&&(_to!=address(this)));
264 
265            //// if ((_to == 0) || (_to == address(this))) throw;
266 
267            // If the amount being transfered is more than the balance of the
268            //  account the transfer returns false
269 
270            var previousBalanceFrom = balanceOfAt(_from, block.number);
271            assert(previousBalanceFrom >= _amount);
272 
273            // Alerts the token controller of the transfer
274            if (isContract(controller)) {
275                assert(Controller(controller).onTransfer(_from,_to,_amount));
276 
277            }
278 
279            // First update the balance array with the new value for the address
280            //  sending the tokens
281            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
282 
283            // Then update the balance array with the new value for the address
284            //  receiving the tokens
285            
286            var previousBalanceTo = balanceOfAt(_to, block.number);
287            assert(previousBalanceTo+_amount>=previousBalanceTo); 
288            
289            //// if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
290            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
291 
292            // An event to make the transfer easy to find on the blockchain
293            Transfer(_from, _to, _amount);
294 
295            return true;
296     }
297 
298     /// @param _owner The address that's balance is being requested
299     /// @return The balance of `_owner` at the current block
300     function balanceOf(address _owner) constant returns (uint256 balance) {
301         return balanceOfAt(_owner, block.number);
302     }
303 
304     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
305     ///  its behalf. This is a modified version of the ERC20 approve function
306     ///  to be a little bit safer
307     /// @param _spender The address of the account able to transfer the tokens
308     /// @param _amount The amount of tokens to be approved for transfer
309     /// @return True if the approval was successful
310     function approve(address _spender, uint256 _amount) returns (bool success) {
311         require(transfersEnabled);
312 
313         // To change the approve amount you first have to reduce the addresses´
314         //  allowance to zero by calling `approve(_spender,0)` if it is not
315         //  already 0 to mitigate the race condition described here:
316         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
317 
318         require((_amount==0)||(allowed[msg.sender][_spender]==0));
319 
320         // Alerts the token controller of the approve function call
321         if (isContract(controller)) {
322             assert(Controller(controller).onApprove(msg.sender,_spender,_amount));
323 
324             //  if (!Controller(controller).onApprove(msg.sender, _spender, _amount))
325             //        throw;
326         }
327 
328         allowed[msg.sender][_spender] = _amount;
329         Approval(msg.sender, _spender, _amount);
330         return true;
331     }
332 
333     /// @dev This function makes it easy to read the `allowed[]` map
334     /// @param _owner The address of the account that owns the token
335     /// @param _spender The address of the account able to transfer the tokens
336     /// @return Amount of remaining tokens of _owner that _spender is allowed
337     ///  to spend
338     function allowance(address _owner, address _spender
339     ) constant returns (uint256 remaining) {
340         return allowed[_owner][_spender];
341     }
342 
343     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
344     ///  its behalf, and then a function is triggered in the contract that is
345     ///  being approved, `_spender`. This allows users to use their tokens to
346     ///  interact with contracts in one function call instead of two
347     /// @param _spender The address of the contract able to transfer the tokens
348     /// @param _amount The amount of tokens to be approved for transfer
349     /// @return True if the function call was successful
350     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
351     ) returns (bool success) {
352         approve(_spender, _amount);
353 
354         // This portion is copied from ConsenSys's Standard Token Contract. It
355         //  calls the receiveApproval function that is part of the contract that
356         //  is being approved (`_spender`). The function should look like:
357         //  `receiveApproval(address _from, uint256 _amount, address
358         //  _tokenContract, bytes _extraData)` It is assumed that the call
359         //  *should* succeed, otherwise the plain vanilla approve would be used
360         ApproveAndCallReceiver(_spender).receiveApproval(
361            msg.sender,
362            _amount,
363            this,
364            _extraData
365         );
366         return true;
367     }
368 
369     /// @dev This function makes it easy to get the total number of tokens
370     /// @return The total number of tokens
371     function totalSupply() constant returns (uint) {
372         return totalSupplyAt(block.number);
373     }
374 
375 
376 ////////////////
377 // Query balance and totalSupply in History
378 ////////////////
379 
380     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
381     /// @param _owner The address from which the balance will be retrieved
382     /// @param _blockNumber The block number when the balance is queried
383     /// @return The balance at `_blockNumber`
384     function balanceOfAt(address _owner, uint _blockNumber) constant
385         returns (uint) {
386 
387         // These next few lines are used when the balance of the token is
388         //  requested before a check point was ever created for this token, it
389         //  requires that the `parentToken.balanceOfAt` be queried at the
390         //  genesis block for that token as this contains initial balance of
391         //  this token
392         if ((balances[_owner].length == 0)
393             || (balances[_owner][0].fromBlock > _blockNumber)) {
394             if (address(parentToken) != 0) {
395                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
396             } else {
397                 // Has no parent
398                 return 0;
399             }
400 
401         // This will return the expected balance during normal situations
402         } else {
403             return getValueAt(balances[_owner], _blockNumber);
404         }
405     }
406 
407     /// @notice Total amount of tokens at a specific `_blockNumber`.
408     /// @param _blockNumber The block number when the totalSupply is queried
409     /// @return The total amount of tokens at `_blockNumber`
410     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
411 
412         // These next few lines are used when the totalSupply of the token is
413         //  requested before a check point was ever created for this token, it
414         //  requires that the `parentToken.totalSupplyAt` be queried at the
415         //  genesis block for this token as that contains totalSupply of this
416         //  token at this block number.
417         if ((totalSupplyHistory.length == 0)
418             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
419             if (address(parentToken) != 0) {
420                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
421             } else {
422                 return 0;
423             }
424 
425         // This will return the expected totalSupply during normal situations
426         } else {
427             return getValueAt(totalSupplyHistory, _blockNumber);
428         }
429     }
430 
431     function min(uint a, uint b) internal returns (uint) {
432       return a < b ? a : b;
433     }
434 
435 ////////////////
436 // Clone Token Method
437 ////////////////
438 
439     /// @notice Creates a new clone token with the initial distribution being
440     ///  this token at `_snapshotBlock`
441     /// @param _cloneTokenName Name of the clone token
442     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
443     /// @param _cloneTokenSymbol Symbol of the clone token
444     /// @param _snapshotBlock Block when the distribution of the parent token is
445     ///  copied to set the initial distribution of the new clone token;
446     ///  if the block is higher than the actual block, the current block is used
447     /// @param _transfersEnabled True if transfers are allowed in the clone
448     /// @return The address of the new MiniMeToken Contract
449     function createCloneToken(
450         string _cloneTokenName,
451         uint8 _cloneDecimalUnits,
452         string _cloneTokenSymbol,
453         uint _snapshotBlock,
454         bool _transfersEnabled
455         ) returns(address) {
456         if (_snapshotBlock > block.number) _snapshotBlock = block.number;
457         MiniMeToken cloneToken = tokenFactory.createCloneToken(
458             this,
459             _snapshotBlock,
460             _cloneTokenName,
461             _cloneDecimalUnits,
462             _cloneTokenSymbol,
463             _transfersEnabled
464             );
465 
466         cloneToken.changeController(msg.sender);
467 
468         // An event to make the token easy to find on the blockchain
469         NewCloneToken(address(cloneToken), _snapshotBlock);
470         return address(cloneToken);
471     }
472 
473 ////////////////
474 // Generate and destroy tokens
475 ////////////////
476 
477     /// @notice Generates `_amount` tokens that are assigned to `_owner`
478     /// @param _owner The address that will be assigned the new tokens
479     /// @param _amount The quantity of tokens generated
480     /// @return True if the tokens are generated correctly
481     function generateTokens(address _owner, uint _amount
482     ) onlyController returns (bool) {
483         uint curTotalSupply = totalSupply();
484         //uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
485 
486         assert(curTotalSupply+_amount>=curTotalSupply);
487         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
488         var previousBalanceTo = balanceOf(_owner);
489         assert(previousBalanceTo+_amount>=previousBalanceTo);
490         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
491         Transfer(0, _owner, _amount);
492         return true;
493     }
494 
495 
496     /// @notice Burns `_amount` tokens from `_owner`
497     /// @param _owner The address that will lose the tokens
498     /// @param _amount The quantity of tokens to burn
499     /// @return True if the tokens are burned correctly
500     function destroyTokens(address _owner, uint _amount
501     ) onlyController returns (bool) {
502         uint curTotalSupply = totalSupply();
503 
504         //uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
505         
506         assert(curTotalSupply >= _amount);
507         
508         //// if (curTotalSupply < _amount) throw;
509 
510         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
511         var previousBalanceFrom = balanceOf(_owner);
512         assert(previousBalanceFrom >=_amount);
513 
514         //// if (previousBalanceFrom < _amount) throw;
515         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
516         Transfer(_owner, 0, _amount);
517         return true;
518     }
519 
520 ////////////////
521 // Enable tokens transfers
522 ////////////////
523 
524 
525     /// @notice Enables token holders to transfer their tokens freely if true
526     /// @param _transfersEnabled True if transfers are allowed in the clone
527     function enableTransfers(bool _transfersEnabled) onlyController {
528         transfersEnabled = _transfersEnabled;
529     }
530 
531 ////////////////
532 // Internal helper functions to query and set a value in a snapshot array
533 ////////////////
534 
535     /// @dev `getValueAt` retrieves the number of tokens at a given block number
536     /// @param checkpoints The history of values being queried
537     /// @param _block The block number to retrieve the value at
538     /// @return The number of tokens being queried
539     function getValueAt(Checkpoint[] storage checkpoints, uint _block
540     ) constant internal returns (uint) {
541         if (checkpoints.length == 0) return 0;
542 
543         // Shortcut for the actual value
544         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
545             return checkpoints[checkpoints.length-1].value;
546         if (_block < checkpoints[0].fromBlock) return 0;
547 
548         // Binary search of the value in the array
549         uint min = 0;
550         uint max = checkpoints.length-1;
551         while (max > min) {
552             uint mid = (max + min + 1)/ 2;
553             if (checkpoints[mid].fromBlock<=_block) {
554                 min = mid;
555             } else {
556                 max = mid-1;
557             }
558         }
559         return checkpoints[min].value;
560     }
561 
562     /// @dev `updateValueAtNow` used to update the `balances` map and the
563     ///  `totalSupplyHistory`
564     /// @param checkpoints The history of data being updated
565     /// @param _value The new number of tokens
566     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
567     ) internal  {
568         if ((checkpoints.length == 0)
569         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
570                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
571                newCheckPoint.fromBlock =  uint128(block.number);
572                newCheckPoint.value = uint128(_value);
573            } else {
574                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
575                oldCheckPoint.value = uint128(_value);
576            }
577     }
578 
579     /// @dev Internal function to determine if an address is a contract
580     /// @param _addr The address being queried
581     /// @return True if `_addr` is a contract
582     function isContract(address _addr) constant internal returns(bool) {
583         uint size;
584         if (_addr == 0) return false;
585         assembly {
586             size := extcodesize(_addr)
587         }
588         return size>0;
589     }
590 
591     /// @notice The fallback function: If the contract's controller has not been
592     ///  set to 0, then the `proxyPayment` method is called which relays the
593     ///  ether and creates tokens as described in the token controller contract
594     function ()  payable {
595         require(isContract(controller));
596         assert(Controller(controller).proxyPayment.value(msg.value)(msg.sender));
597     }
598 
599 
600 ////////////////
601 // Events
602 ////////////////
603     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
604 }
605 
606 
607 ////////////////
608 // MiniMeTokenFactory
609 ////////////////
610 
611 /// @dev This contract is used to generate clone contracts from a contract.
612 ///  In solidity this is the way to create a contract from a contract of the
613 ///  same class
614 contract MiniMeTokenFactory {
615 
616     /// @notice Update the DApp by creating a new token with new functionalities
617     ///  the msg.sender becomes the controller of this clone token
618     /// @param _parentToken Address of the token being cloned
619     /// @param _snapshotBlock Block of the parent token that will
620     ///  determine the initial distribution of the clone token
621     /// @param _tokenName Name of the new token
622     /// @param _decimalUnits Number of decimals of the new token
623     /// @param _tokenSymbol Token Symbol for the new token
624     /// @param _transfersEnabled If true, tokens will be able to be transferred
625     /// @return The address of the new token contract
626     function createCloneToken(
627         address _parentToken,
628         uint _snapshotBlock,
629         string _tokenName,
630         uint8 _decimalUnits,
631         string _tokenSymbol,
632         bool _transfersEnabled
633     ) returns (MiniMeToken) {
634         MiniMeToken newToken = new MiniMeToken(
635             this,
636             _parentToken,
637             _snapshotBlock,
638             _tokenName,
639             _decimalUnits,
640             _tokenSymbol,
641             _transfersEnabled
642             );
643 
644         newToken.changeController(msg.sender);
645         return newToken;
646     }
647 }
648 
649 // inspired by Zeppelin's Vested Token deriving MiniMeToken
650 
651 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
652 // ability to createTokenGrants which are basically a transfer that limits the
653 // receiver of the tokens.
654 
655 
656 contract MiniMeIrrevocableVestedToken is MiniMeToken, SafeMath {
657 
658   uint256 MAX_GRANTS_PER_ADDRESS = 20;
659 
660   // Keep the struct at 3 sstores ( total value  20+32+24 =76 bytes)
661   struct TokenGrant {
662     address granter;  // 20 bytes
663     uint256 value;    // 32 bytes
664     uint64 cliff;
665     uint64 vesting;
666     uint64 start;     // 3*8 =24 bytes
667   }
668 
669   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting);
670 
671   mapping (address => TokenGrant[]) public grants;
672 
673   mapping (address => bool) canCreateGrants;
674   address vestingWhitelister;
675 
676   modifier canTransfer(address _sender, uint _value) {
677     require(_value<=spendableBalanceOf(_sender));
678     _;
679   }
680 
681   modifier onlyVestingWhitelister {
682     require(msg.sender==vestingWhitelister);
683     _;
684   }
685 
686   function MiniMeIrrevocableVestedToken (
687       address _tokenFactory,
688       address _parentToken,
689       uint _parentSnapShotBlock,
690       string _tokenName,
691       uint8 _decimalUnits,
692       string _tokenSymbol,
693       bool _transfersEnabled
694   ) MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
695     vestingWhitelister = msg.sender;
696     doSetCanCreateGrants(vestingWhitelister, true);
697   }
698 
699   // @dev Checks modifier and allows transfer if tokens are not locked.
700   function transfer(address _to, uint _value)
701            canTransfer(msg.sender, _value)
702            public
703            returns (bool success) {
704     return super.transfer(_to, _value);
705   }
706 
707   function transferFrom(address _from, address _to, uint _value)
708            canTransfer(_from, _value)
709            public
710            returns (bool success) {
711     return super.transferFrom(_from, _to, _value);
712   }
713 
714   function spendableBalanceOf(address _holder) constant public returns (uint) {
715     return transferableTokens(_holder, uint64(now));
716   }
717 
718   // main func for token grant
719 
720   function grantVestedTokens(
721     address _to,
722     uint256 _value,
723     uint64 _start,
724     uint64 _cliff,
725     uint64 _vesting) public {
726 
727     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
728 
729     require(_cliff >= _start && _vesting >= _cliff);
730     
731     require(tokenGrantsCount(_to)<=MAX_GRANTS_PER_ADDRESS); //// To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
732 
733     assert(canCreateGrants[msg.sender]);
734 
735 
736     TokenGrant memory grant = TokenGrant(msg.sender, _value, _cliff, _vesting, _start);
737     grants[_to].push(grant);
738 
739     assert(transfer(_to,_value));
740 
741     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start);
742   }
743 
744   function setCanCreateGrants(address _addr, bool _allowed)
745            onlyVestingWhitelister public {
746     doSetCanCreateGrants(_addr, _allowed);
747   }
748 
749   function doSetCanCreateGrants(address _addr, bool _allowed)
750            internal {
751     canCreateGrants[_addr] = _allowed;
752   }
753 
754   function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
755     doSetCanCreateGrants(vestingWhitelister, false);
756     vestingWhitelister = _newWhitelister;
757     doSetCanCreateGrants(vestingWhitelister, true);
758   }
759 
760   function tokenGrantsCount(address _holder) constant public returns (uint index) {
761     return grants[_holder].length;
762   }
763 
764   function tokenGrant(address _holder, uint _grantId) constant public returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting) {
765     TokenGrant storage grant = grants[_holder][_grantId];
766 
767     granter = grant.granter;
768     value = grant.value;
769     start = grant.start;
770     cliff = grant.cliff;
771     vesting = grant.vesting;
772 
773     vested = vestedTokens(grant, uint64(now));
774   }
775 
776   function vestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
777     return calculateVestedTokens(
778       grant.value,
779       uint256(time),
780       uint256(grant.start),
781       uint256(grant.cliff),
782       uint256(grant.vesting)
783     );
784   }
785 
786   //  transferableTokens
787   //   |                         _/--------   NonVestedTokens
788   //   |                       _/
789   //   |                     _/
790   //   |                   _/
791   //   |                 _/
792   //   |                /
793   //   |              .|
794   //   |            .  |
795   //   |          .    |
796   //   |        .      |
797   //   |      .        |
798   //   |    .          |
799   //   +===+===========+---------+----------> time
800   //      Start       Cliff    Vesting
801 
802   function calculateVestedTokens(
803     uint256 tokens,
804     uint256 time,
805     uint256 start,
806     uint256 cliff,
807     uint256 vesting) internal constant returns (uint256)
808     {
809 
810     // Shortcuts for before cliff and after vesting cases.
811     if (time < cliff) return 0;
812     if (time >= vesting) return tokens;
813 
814     // Interpolate all vested tokens.
815     // As before cliff the shortcut returns 0, we can use just this function to
816     // calculate it.
817 
818     // vestedTokens = tokens * (time - start) / (vesting - start)
819     uint256 vestedTokens = safeDiv(
820                                   safeMul(
821                                     tokens,
822                                     safeSub(time, start)
823                                     ),
824                                   safeSub(vesting, start)
825                                   );
826 
827     return vestedTokens;
828   }
829 
830   function nonVestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
831     return safeSub(grant.value, vestedTokens(grant, time));
832   }
833 
834   // @dev The date in which all tokens are transferable for the holder
835   // Useful for displaying purposes (not used in any logic calculations)
836   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
837     date = uint64(now);
838     uint256 grantIndex = tokenGrantsCount(holder);
839     for (uint256 i = 0; i < grantIndex; i++) {
840       date = max64(grants[holder][i].vesting, date);
841     }
842     return date;
843   }
844 
845   // @dev How many tokens can a holder transfer at a point in time
846   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
847     uint256 grantIndex = tokenGrantsCount(holder);
848 
849     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
850 
851     // Iterate through all the grants the holder has, and add all non-vested tokens
852     uint256 nonVested = 0;
853     for (uint256 i = 0; i < grantIndex; i++) {
854       nonVested = safeAdd(nonVested, nonVestedTokens(grants[holder][i], time));
855     }
856 
857     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
858     return safeSub(balanceOf(holder), nonVested);
859   }
860 }
861 
862 contract GNX is MiniMeIrrevocableVestedToken {
863 
864   uint constant D160 = 0x0010000000000000000000000000000000000000000;
865 
866   // @dev GNX constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
867   function GNX(
868     address _tokenFactory
869   ) MiniMeIrrevocableVestedToken(
870     _tokenFactory,
871     0xBB13E608888E5D30C09b13F89d27631056161B9F,		//genaro network token mainnet
872     4313000,  										//snapshot for mainnet	
873     "Genaro X", 		  								// Token name
874     9,												// Decimals
875     "GNX",											// Symbol
876     true												// Enable Transfers	
877     ) {}
878 
879     // data is an array of uints. Each uint represents a transfer.
880     // The 160 LSB is the destination of the addess that wants to be sent
881     // The 96 MSB is the amount of tokens that wants to be sent.
882     function multiMint(uint[] data) onlyController {
883         for (uint i = 0; i < data.length; i++ ) {
884             address addr = address( data[i] & (D160-1) );
885             uint amount = data[i] / D160;
886             assert(generateTokens(addr,amount));
887         }
888     }
889 
890     // Due to the supervision of certain country, it may uses some time.
891     // data is an array of uints. Each uint represents a sterilization.
892     // The 160 LSB is the destination of the addess that needs to be sterilized
893     // The 96 MSB is the amount of tokens that needs to be sterilized.
894     function sterilize(uint[] data) onlyController {
895         for (uint i = 0; i < data.length; i++ ) {
896             address addr = address( data[i] & (D160-1) );
897             uint amount = data[i] / D160;
898             assert(destroyTokens(addr,amount));
899         }
900     }    
901 }