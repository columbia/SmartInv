1 pragma solidity ^0.4.13;
2 
3 //inspired by multiple tokensale contracts
4 
5 /**
6  * Math operations with safety checks
7  */
8 contract SafeMath {
9   function safeMul(uint a, uint b) internal returns (uint) {
10     uint c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function safeDiv(uint a, uint b) internal returns (uint) {
16     assert(b > 0);
17     uint c = a / b;
18     assert(a == b * c + a % b);
19     return c;
20   }
21 
22   function safeSub(uint a, uint b) internal returns (uint) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function safeAdd(uint a, uint b) internal returns (uint) {
28     uint c = a + b;
29     assert(c>=a && c>=b);
30     return c;
31   }
32 
33   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a >= b ? a : b;
35   }
36 
37   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
38     return a < b ? a : b;
39   }
40 
41   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a >= b ? a : b;
43   }
44 
45   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a < b ? a : b;
47   }
48 
49   function assert(bool assertion) internal {
50     require(assertion);
51   }
52 }
53 
54 /// @dev The token controller contract must implement these functions
55 contract Controller {
56     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
57     /// @param _owner The address that sent the ether to create tokens
58     /// @return True if the ether is accepted, false if it throws
59     function proxyPayment(address _owner) payable returns(bool);
60 
61     /// @notice Notifies the controller about a token transfer allowing the
62     ///  controller to react if desired
63     /// @param _from The origin of the transfer
64     /// @param _to The destination of the transfer
65     /// @param _amount The amount of the transfer
66     /// @return False if the controller does not authorize the transfer
67     function onTransfer(address _from, address _to, uint _amount) returns(bool);
68 
69     /// @notice Notifies the controller about an approval allowing the
70     ///  controller to react if desired
71     /// @param _owner The address that calls `approve()`
72     /// @param _spender The spender in the `approve()` call
73     /// @param _amount The amount in the `approve()` call
74     /// @return False if the controller does not authorize the approval
75     function onApprove(address _owner, address _spender, uint _amount)
76         returns(bool);
77 }
78 
79 // inspired by Zeppelin's Vested Token deriving MiniMeToken
80 
81 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
82 // ability to createTokenGrants which are basically a transfer that limits the
83 // receiver of the tokens.
84 
85 contract Controlled {
86     /// @notice The address of the controller is the only address that can call
87     ///  a function with this modifier
88     modifier onlyController{ require(msg.sender==controller); _; }
89 
90 
91     address public controller;
92 
93     function Controlled() { controller = msg.sender;}
94 
95     /// @notice Changes the controller of the contract
96     /// @param _newController The new controller of the contract
97     function changeController(address _newController) onlyController {
98         controller = _newController;
99     }
100 }
101 
102 
103 
104 contract ApproveAndCallReceiver {
105     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data);
106 }
107 
108 /*
109  * ERC20 interface
110  * see https://github.com/ethereum/EIPs/issues/20
111  */
112 contract ERC20 {
113   function totalSupply() constant returns (uint);
114   function balanceOf(address who) constant returns (uint);
115   function allowance(address owner, address spender) constant returns (uint);
116 
117   function transfer(address to, uint value) returns (bool ok);
118   function transferFrom(address from, address to, uint value) returns (bool ok);
119   function approve(address spender, uint value) returns (bool ok);
120   event Transfer(address indexed from, address indexed to, uint value);
121   event Approval(address indexed owner, address indexed spender, uint value);
122 }
123 
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
483         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
484         assert(curTotalSupply+_amount>=curTotalSupply);
485         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
486         var previousBalanceTo = balanceOf(_owner);
487         assert(previousBalanceTo+_amount>=previousBalanceTo);
488         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
489         Transfer(0, _owner, _amount);
490         return true;
491     }
492 
493 
494     /// @notice Burns `_amount` tokens from `_owner`
495     /// @param _owner The address that will lose the tokens
496     /// @param _amount The quantity of tokens to burn
497     /// @return True if the tokens are burned correctly
498     function destroyTokens(address _owner, uint _amount
499     ) onlyController returns (bool) {
500         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
501         assert(curTotalSupply >= _amount);
502         
503         //// if (curTotalSupply < _amount) throw;
504 
505         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
506         var previousBalanceFrom = balanceOf(_owner);
507         assert(previousBalanceFrom >=_amount);
508 
509         //// if (previousBalanceFrom < _amount) throw;
510         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
511         Transfer(_owner, 0, _amount);
512         return true;
513     }
514 
515 ////////////////
516 // Enable tokens transfers
517 ////////////////
518 
519 
520     /// @notice Enables token holders to transfer their tokens freely if true
521     /// @param _transfersEnabled True if transfers are allowed in the clone
522     function enableTransfers(bool _transfersEnabled) onlyController {
523         transfersEnabled = _transfersEnabled;
524     }
525 
526 ////////////////
527 // Internal helper functions to query and set a value in a snapshot array
528 ////////////////
529 
530     /// @dev `getValueAt` retrieves the number of tokens at a given block number
531     /// @param checkpoints The history of values being queried
532     /// @param _block The block number to retrieve the value at
533     /// @return The number of tokens being queried
534     function getValueAt(Checkpoint[] storage checkpoints, uint _block
535     ) constant internal returns (uint) {
536         if (checkpoints.length == 0) return 0;
537 
538         // Shortcut for the actual value
539         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
540             return checkpoints[checkpoints.length-1].value;
541         if (_block < checkpoints[0].fromBlock) return 0;
542 
543         // Binary search of the value in the array
544         uint min = 0;
545         uint max = checkpoints.length-1;
546         while (max > min) {
547             uint mid = (max + min + 1)/ 2;
548             if (checkpoints[mid].fromBlock<=_block) {
549                 min = mid;
550             } else {
551                 max = mid-1;
552             }
553         }
554         return checkpoints[min].value;
555     }
556 
557     /// @dev `updateValueAtNow` used to update the `balances` map and the
558     ///  `totalSupplyHistory`
559     /// @param checkpoints The history of data being updated
560     /// @param _value The new number of tokens
561     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
562     ) internal  {
563         if ((checkpoints.length == 0)
564         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
565                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
566                newCheckPoint.fromBlock =  uint128(block.number);
567                newCheckPoint.value = uint128(_value);
568            } else {
569                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
570                oldCheckPoint.value = uint128(_value);
571            }
572     }
573 
574     /// @dev Internal function to determine if an address is a contract
575     /// @param _addr The address being queried
576     /// @return True if `_addr` is a contract
577     function isContract(address _addr) constant internal returns(bool) {
578         uint size;
579         if (_addr == 0) return false;
580         assembly {
581             size := extcodesize(_addr)
582         }
583         return size>0;
584     }
585 
586     /// @notice The fallback function: If the contract's controller has not been
587     ///  set to 0, then the `proxyPayment` method is called which relays the
588     ///  ether and creates tokens as described in the token controller contract
589     function ()  payable {
590         require(isContract(controller));
591         assert(Controller(controller).proxyPayment.value(msg.value)(msg.sender));
592     }
593 
594 
595 ////////////////
596 // Events
597 ////////////////
598     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
599 }
600 
601 
602 ////////////////
603 // MiniMeTokenFactory
604 ////////////////
605 
606 /// @dev This contract is used to generate clone contracts from a contract.
607 ///  In solidity this is the way to create a contract from a contract of the
608 ///  same class
609 contract MiniMeTokenFactory {
610 
611     /// @notice Update the DApp by creating a new token with new functionalities
612     ///  the msg.sender becomes the controller of this clone token
613     /// @param _parentToken Address of the token being cloned
614     /// @param _snapshotBlock Block of the parent token that will
615     ///  determine the initial distribution of the clone token
616     /// @param _tokenName Name of the new token
617     /// @param _decimalUnits Number of decimals of the new token
618     /// @param _tokenSymbol Token Symbol for the new token
619     /// @param _transfersEnabled If true, tokens will be able to be transferred
620     /// @return The address of the new token contract
621     function createCloneToken(
622         address _parentToken,
623         uint _snapshotBlock,
624         string _tokenName,
625         uint8 _decimalUnits,
626         string _tokenSymbol,
627         bool _transfersEnabled
628     ) returns (MiniMeToken) {
629         MiniMeToken newToken = new MiniMeToken(
630             this,
631             _parentToken,
632             _snapshotBlock,
633             _tokenName,
634             _decimalUnits,
635             _tokenSymbol,
636             _transfersEnabled
637             );
638 
639         newToken.changeController(msg.sender);
640         return newToken;
641     }
642 }
643 
644 contract MiniMeIrrevocableVestedToken is MiniMeToken, SafeMath {
645 
646   uint256 MAX_GRANTS_PER_ADDRESS = 20;
647 
648   // Keep the struct at 3 sstores ( total value  20+32+24 =76 bytes)
649   struct TokenGrant {
650     address granter;  // 20 bytes
651     uint256 value;    // 32 bytes
652     uint64 cliff;
653     uint64 vesting;
654     uint64 start;     // 3*8 =24 bytes
655   }
656 
657   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting);
658 
659   mapping (address => TokenGrant[]) public grants;
660 
661   mapping (address => bool) canCreateGrants;
662   address vestingWhitelister;
663 
664   modifier canTransfer(address _sender, uint _value) {
665     require(_value<=spendableBalanceOf(_sender));
666     _;
667   }
668 
669   modifier onlyVestingWhitelister {
670     require(msg.sender==vestingWhitelister);
671     _;
672   }
673 
674   function MiniMeIrrevocableVestedToken (
675       address _tokenFactory,
676       address _parentToken,
677       uint _parentSnapShotBlock,
678       string _tokenName,
679       uint8 _decimalUnits,
680       string _tokenSymbol,
681       bool _transfersEnabled
682   ) MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
683     vestingWhitelister = msg.sender;
684     doSetCanCreateGrants(vestingWhitelister, true);
685   }
686 
687   // @dev Checks modifier and allows transfer if tokens are not locked.
688   function transfer(address _to, uint _value)
689            canTransfer(msg.sender, _value)
690            public
691            returns (bool success) {
692     return super.transfer(_to, _value);
693   }
694 
695   function transferFrom(address _from, address _to, uint _value)
696            canTransfer(_from, _value)
697            public
698            returns (bool success) {
699     return super.transferFrom(_from, _to, _value);
700   }
701 
702   function spendableBalanceOf(address _holder) constant public returns (uint) {
703     return transferableTokens(_holder, uint64(now));
704   }
705 
706   // main func for token grant
707 
708   function grantVestedTokens(
709     address _to,
710     uint256 _value,
711     uint64 _start,
712     uint64 _cliff,
713     uint64 _vesting) public {
714 
715     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
716 
717     require(_cliff >= _start && _vesting >= _cliff);
718     
719     require(tokenGrantsCount(_to)<=MAX_GRANTS_PER_ADDRESS); //// To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
720 
721     assert(canCreateGrants[msg.sender]);
722 
723 
724     TokenGrant memory grant = TokenGrant(msg.sender, _value, _cliff, _vesting, _start);
725     grants[_to].push(grant);
726 
727     assert(transfer(_to,_value));
728 
729     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start);
730   }
731 
732   function setCanCreateGrants(address _addr, bool _allowed)
733            onlyVestingWhitelister public {
734     doSetCanCreateGrants(_addr, _allowed);
735   }
736 
737   function doSetCanCreateGrants(address _addr, bool _allowed)
738            internal {
739     canCreateGrants[_addr] = _allowed;
740   }
741 
742   function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
743     doSetCanCreateGrants(vestingWhitelister, false);
744     vestingWhitelister = _newWhitelister;
745     doSetCanCreateGrants(vestingWhitelister, true);
746   }
747 
748   function tokenGrantsCount(address _holder) constant public returns (uint index) {
749     return grants[_holder].length;
750   }
751 
752   function tokenGrant(address _holder, uint _grantId) constant public returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting) {
753     TokenGrant storage grant = grants[_holder][_grantId];
754 
755     granter = grant.granter;
756     value = grant.value;
757     start = grant.start;
758     cliff = grant.cliff;
759     vesting = grant.vesting;
760 
761     vested = vestedTokens(grant, uint64(now));
762   }
763 
764   function vestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
765     return calculateVestedTokens(
766       grant.value,
767       uint256(time),
768       uint256(grant.start),
769       uint256(grant.cliff),
770       uint256(grant.vesting)
771     );
772   }
773 
774   //  transferableTokens
775   //   |                         _/--------   NonVestedTokens
776   //   |                       _/
777   //   |                     _/
778   //   |                   _/
779   //   |                 _/
780   //   |                /
781   //   |              .|
782   //   |            .  |
783   //   |          .    |
784   //   |        .      |
785   //   |      .        |
786   //   |    .          |
787   //   +===+===========+---------+----------> time
788   //      Start       Cliff    Vesting
789 
790   function calculateVestedTokens(
791     uint256 tokens,
792     uint256 time,
793     uint256 start,
794     uint256 cliff,
795     uint256 vesting) internal constant returns (uint256)
796     {
797 
798     // Shortcuts for before cliff and after vesting cases.
799     if (time < cliff) return 0;
800     if (time >= vesting) return tokens;
801 
802     // Interpolate all vested tokens.
803     // As before cliff the shortcut returns 0, we can use just this function to
804     // calculate it.
805 
806     // vestedTokens = tokens * (time - start) / (vesting - start)
807     uint256 vestedTokens = safeDiv(
808                                   safeMul(
809                                     tokens,
810                                     safeSub(time, start)
811                                     ),
812                                   safeSub(vesting, start)
813                                   );
814 
815     return vestedTokens;
816   }
817 
818   function nonVestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
819     return safeSub(grant.value, vestedTokens(grant, time));
820   }
821 
822   // @dev The date in which all tokens are transferable for the holder
823   // Useful for displaying purposes (not used in any logic calculations)
824   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
825     date = uint64(now);
826     uint256 grantIndex = tokenGrantsCount(holder);
827     for (uint256 i = 0; i < grantIndex; i++) {
828       date = max64(grants[holder][i].vesting, date);
829     }
830     return date;
831   }
832 
833   // @dev How many tokens can a holder transfer at a point in time
834   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
835     uint256 grantIndex = tokenGrantsCount(holder);
836 
837     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
838 
839     // Iterate through all the grants the holder has, and add all non-vested tokens
840     uint256 nonVested = 0;
841     for (uint256 i = 0; i < grantIndex; i++) {
842       nonVested = safeAdd(nonVested, nonVestedTokens(grants[holder][i], time));
843     }
844 
845     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
846     return safeSub(balanceOf(holder), nonVested);
847   }
848 }
849 
850 
851 contract GNR is MiniMeIrrevocableVestedToken {
852   // @dev GNR constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
853   function GNR(
854     address _tokenFactory
855   ) MiniMeIrrevocableVestedToken(
856     _tokenFactory,
857     0x0,                    // no parent token
858     0,                      // no snapshot block number from parent
859     "Genaro Network Token", // Token name
860     9,                     // Decimals
861     "GNR",                  // Symbol
862     true                    // Enable transfers
863     ) {}
864 }
865 
866 /*
867 
868 @notice The GRPlaceholder contract will take control over the GNR after the sale
869         is finalized and before the Genaro Network is deployed.
870 
871         The contract allows for GNR transfers and transferFrom and implements the
872         logic for transfering control of the token to the network when the sale
873         asks it to do so.
874 */
875 
876 contract GRPlaceholder is Controller {
877   address public sale;
878   GNR public token;
879 
880   function GRPlaceholder(address _sale, address _gnr) {
881     sale = _sale;
882     token = GNR(_gnr);
883   }
884 
885   function changeController(address network) public {
886     require(msg.sender == sale);
887     token.changeController(network);
888     suicide(network);
889   }
890 
891   // In between the sale and the network. Default settings for allowing token transfers.
892   function proxyPayment(address) payable public returns (bool) {
893     return false;
894   }
895 
896   function onTransfer(address, address, uint) public returns (bool) {
897     return true;
898   }
899 
900   function onApprove(address, address, uint) public returns (bool) {
901     return true;
902   }
903 }
904 
905 // @dev Contract to hold sale raised funds during the sale period.
906 // Prevents attack in which the Genaro Multisig sends raised ether
907 // to the sale contract to mint tokens to itself, and getting the
908 // funds back immediately.
909 
910 contract AbstractSale {
911   function saleFinalized() constant returns (bool);
912 }
913 
914 contract SaleWallet {
915   // Public variables
916   address public multisig;
917   uint public finalBlock;
918   AbstractSale public tokenSale;
919 
920   // @dev Constructor initializes public variables
921   // @param _multisig The address of the multisig that will receive the funds
922   // @param _finalBlock Block after which the multisig can request the funds
923   function SaleWallet(address _multisig, uint _finalBlock, address _tokenSale) {
924     multisig = _multisig;
925     finalBlock = _finalBlock;
926     tokenSale = AbstractSale(_tokenSale);
927   }
928 
929   // @dev Receive all sent funds without any further logic
930   function () public payable {}
931 
932   // @dev Withdraw function sends all the funds to the wallet if conditions are correct
933   function withdraw() public {
934     require(msg.sender == multisig);  // Only the multisig can request it
935     if (block.number > finalBlock) return doWithdraw();      // Allow after the final block
936     if (tokenSale.saleFinalized()) return doWithdraw();      // Allow when sale is finalized
937   }
938 
939   function doWithdraw() internal {
940     require(multisig.send(this.balance));
941   }
942 }
943 
944 
945 contract GenaroTokenSale is Controlled, Controller, SafeMath {
946     uint public initialBlock;             // Block number in which the sale starts. Inclusive. sale will be opened at initial block.
947     uint public finalBlock;               // Block number in which the sale end. Exclusive, sale will be closed at ends block.
948     uint public price;                    // Number of wei-GNR tokens for 1 wei, at the start of the sale (9 decimals) 
949 
950     address public genaroDevMultisig;     // The address to hold the funds donated
951     bytes32 public capCommitment;
952 
953     uint public totalCollected = 0;               // In wei
954     bool public saleStopped = false;              // Has Genaro Dev stopped the sale?
955     bool public saleFinalized = false;            // Has Genaro Dev finalized the sale?
956 
957     mapping (address => bool) public activated;   // Address confirmates that wants to activate the sale
958 
959     mapping (address => bool) public whitelist;   // Address consists of whitelist payer
960 
961     GNR public token;                             // The token
962     GRPlaceholder public networkPlaceholder;      // The network placeholder
963     SaleWallet public saleWallet;                 // Wallet that receives all sale funds
964 
965     uint constant public dust = 1 ether;         // Minimum investment
966     uint constant public maxPerPersion = 100 ether;   // Maximum investment per person
967 
968     uint public hardCap = 2888 ether;          // Hard cap for Genaro 
969 
970     event NewPresaleAllocation(address indexed holder, uint256 gnrAmount);
971     event NewBuyer(address indexed holder, uint256 gnrAmount, uint256 etherAmount);
972     event CapRevealed(uint value, uint secret, address revealer);
973 
974 /// @dev There are several checks to make sure the parameters are acceptable
975 /// @param _initialBlock The Block number in which the sale starts
976 /// @param _finalBlock The Block number in which the sale ends
977 /// @param _genaroDevMultisig The address that will store the donated funds and manager
978 /// for the sale
979 /// @param _price The price for the genaro sale. Price in wei-GNR per wei.
980 
981   function GenaroTokenSale (
982       uint _initialBlock,
983       uint _finalBlock,
984       address _genaroDevMultisig,
985       uint256 _price,
986       bytes32 _capCommitment
987   )
988   {
989       require(_genaroDevMultisig !=0);
990       require(_initialBlock >= getBlockNumber());
991       require(_initialBlock < _finalBlock);
992 
993       require(uint(_capCommitment)!=0);
994       
995 
996       // Save constructor arguments as global variables
997       initialBlock = _initialBlock;
998       finalBlock = _finalBlock;
999       genaroDevMultisig = _genaroDevMultisig;
1000       price = _price;
1001       capCommitment = _capCommitment;
1002   }
1003 
1004   // @notice Deploy GNR is called only once to setup all the needed contracts.
1005   // @param _token: Address of an instance of the GNR token
1006   // @param _networkPlaceholder: Address of an instance of GNRPlaceholder
1007   // @param _saleWallet: Address of the wallet receiving the funds of the sale
1008 
1009   function setGNR(address _token, address _networkPlaceholder, address _saleWallet)
1010            only(genaroDevMultisig)
1011            public {
1012 
1013     require(_token != 0);
1014     require(_networkPlaceholder != 0);
1015     require(_saleWallet != 0);
1016 
1017     // Assert that the function hasn't been called before, as activate will happen at the end
1018     assert(!activated[this]);
1019 
1020     token = GNR(_token);
1021     networkPlaceholder = GRPlaceholder(_networkPlaceholder);
1022     saleWallet = SaleWallet(_saleWallet);
1023     
1024     assert(token.controller() == address(this)); // sale is controller
1025     assert(networkPlaceholder.sale() ==address(this)); // placeholder has reference to Sale
1026     assert(networkPlaceholder.token() == address(token)); // placeholder has reference to GNR
1027     assert(saleWallet.finalBlock() == finalBlock); // final blocks must match
1028     assert(saleWallet.multisig() == genaroDevMultisig);  // receiving wallet must match
1029     assert(saleWallet.tokenSale() == address(this));  // watched token sale must be self
1030 
1031     // Contract activates sale as all requirements are ready
1032     doActivateSale(this);
1033   }
1034 
1035   // @notice Certain addresses need to call the activate function prior to the sale opening block.
1036   // This proves that they have checked the sale contract is legit, as well as proving
1037   // the capability for those addresses to interact with the contract.
1038   function activateSale()
1039            public {
1040     doActivateSale(msg.sender);
1041   }
1042 
1043   function doActivateSale(address _entity)
1044     non_zero_address(token)               // cannot activate before setting token
1045     only_before_sale
1046     private {
1047     activated[_entity] = true;
1048   }
1049 
1050   // @notice Whether the needed accounts have activated the sale.
1051   // @return Is sale activated
1052   function isActivated() constant public returns (bool) {
1053     return activated[this] && activated[genaroDevMultisig];
1054   }
1055 
1056   // @notice Get the price for a GNR token at any given block number
1057   // @param _blockNumber the block for which the price is requested
1058   // @return Number of wei-GNR for 1 wei
1059   // If sale isn't ongoing for that block, returns 0.
1060 
1061   function getPrice(address _owner, uint _blockNumber) constant public returns (uint256) {
1062     if (_blockNumber < initialBlock || _blockNumber >= finalBlock) return 0;
1063 
1064     return (price);
1065   }
1066 
1067   // @notice Genaro Dev needs to make initial token allocations for presale partners
1068   // This allocation has to be made before the sale is activated. Activating the sale means no more
1069   // arbitrary allocations are possible and expresses conformity.
1070   // @param _receiver: The receiver of the tokens
1071   // @param _amount: Amount of tokens allocated for receiver.
1072 
1073   function allocatePresaleTokens(address _receiver, uint _amount, uint64 cliffDate, uint64 vestingDate)
1074            only_before_sale_activation
1075            only_before_sale
1076            non_zero_address(_receiver)
1077            only(genaroDevMultisig)
1078            public {
1079 
1080     require(_amount<=6.3*(10 ** 15)); // presale 63 million GNR. No presale partner will have more than this allocated. Prevent overflows.
1081 
1082     assert(token.generateTokens(address(this),_amount));
1083     
1084     // vested token be sent in appropiate vesting date
1085     token.grantVestedTokens(_receiver, _amount, uint64(now), cliffDate, vestingDate);
1086 
1087     NewPresaleAllocation(_receiver, _amount);
1088   }
1089 
1090 /// @dev The fallback function is called when ether is sent to the contract, it
1091 /// simply calls `doPayment()` with the address that sent the ether as the
1092 /// `_owner`. Payable is a required solidity modifier for functions to receive
1093 /// ether, without this modifier functions will throw if ether is sent to them
1094 
1095   function () public payable {
1096     return doPayment(msg.sender);
1097   }
1098 
1099 /////////////////
1100 // Whitelist  controll
1101 /////////////////
1102 
1103   function addToWhiteList(address _owner) 
1104            only(controller)
1105            public{
1106               whitelist[_owner]=true;
1107            }
1108 
1109   function removeFromWhiteList(address _owner)
1110            only(controller)
1111            public{
1112               whitelist[_owner]=false;
1113            }
1114 
1115   // @return true if investor is whitelisted
1116   function isWhitelisted(address _owner) public constant returns (bool) {
1117     return whitelist[_owner];
1118   }           
1119 
1120 /////////////////
1121 // Controller interface
1122 /////////////////
1123 
1124 /// @notice `proxyPayment()` allows the caller to send ether to the Token directly and
1125 /// have the tokens created in an address of their choosing
1126 /// @param _owner The address that will hold the newly created tokens
1127 
1128   function proxyPayment(address _owner) payable public returns (bool) {
1129     doPayment(_owner);
1130     return true;
1131   }
1132 
1133 /// @notice Notifies the controller about a transfer, for this sale all
1134 ///  transfers are allowed by default and no extra notifications are needed
1135 /// @param _from The origin of the transfer
1136 /// @param _to The destination of the transfer
1137 /// @param _amount The amount of the transfer
1138 /// @return False if the controller does not authorize the transfer
1139   function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
1140     // Until the sale is finalized, only allows transfers originated by the sale contract.
1141     // When finalizeSale is called, this function will stop being called and will always be true.
1142     return _from == address(this);
1143   }
1144 
1145 /// @notice Notifies the controller about an approval, for this sale all
1146 ///  approvals are allowed by default and no extra notifications are needed
1147 /// @param _owner The address that calls `approve()`
1148 /// @param _spender The spender in the `approve()` call
1149 /// @param _amount The amount in the `approve()` call
1150 /// @return False if the controller does not authorize the approval
1151   function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
1152     // No approve/transferFrom during the sale
1153     return false;
1154   }
1155 
1156 /// @dev `doPayment()` is an internal function that sends the ether that this
1157 ///  contract receives to the genaroDevMultisig and creates tokens in the address of the
1158 /// @param _owner The address that will hold the newly created tokens
1159 
1160   function doPayment(address _owner)
1161            only_during_sale_period
1162            only_sale_not_stopped
1163            only_sale_activated
1164            non_zero_address(_owner)
1165            minimum_value(dust)
1166            maximum_value(maxPerPersion)
1167            internal {
1168 
1169     assert(totalCollected+msg.value <= hardCap); //if past hard cap, throw
1170 
1171     uint256 boughtTokens = safeDiv(safeMul(msg.value, getPrice(_owner,getBlockNumber())),10**9); // Calculate how many tokens bought
1172 
1173     assert(saleWallet.send(msg.value));  //Send fund to multisig
1174     assert(token.generateTokens(_owner,boughtTokens));// Allocate tokens. This will fail after sale is finalized in case it is hidden cap finalized.
1175     
1176     totalCollected = safeAdd(totalCollected, msg.value); // Save total collected amount
1177 
1178     NewBuyer(_owner, boughtTokens, msg.value);
1179   }
1180 
1181   // @notice Function to stop sale for an emergency.
1182   // @dev Only Genaro Dev can do it after it has been activated.
1183   function emergencyStopSale()
1184            only_sale_activated
1185            only_sale_not_stopped
1186            only(genaroDevMultisig)
1187            public {
1188 
1189     saleStopped = true;
1190   }
1191 
1192   // @notice Function to restart stopped sale.
1193   // @dev Only Genaro Dev can do it after it has been disabled and sale is ongoing.
1194   function restartSale()
1195            only_during_sale_period
1196            only_sale_stopped
1197            only(genaroDevMultisig)
1198            public {
1199 
1200     saleStopped = false;
1201   }
1202 
1203   function revealCap(uint256 _cap, uint256 _cap_secure)
1204            only_during_sale_period
1205            only_sale_activated
1206            verify_cap(_cap, _cap_secure)
1207            public {
1208 
1209     require(_cap <= hardCap);
1210 
1211     hardCap = _cap;
1212     CapRevealed(_cap, _cap_secure, msg.sender);
1213 
1214     if (totalCollected + dust >= hardCap) {
1215       doFinalizeSale();
1216     }
1217   }
1218 
1219   // @notice Finalizes sale generating the tokens for Genaro Dev.
1220   // @dev Transfers the token controller power to the GRPlaceholder.
1221   function finalizeSale()
1222            only(genaroDevMultisig)
1223            public {
1224 
1225     require(getBlockNumber() >= finalBlock  ||  totalCollected >= hardCap);
1226     doFinalizeSale();
1227   }
1228 
1229   function doFinalizeSale()
1230            internal {
1231     // Doesn't check if saleStopped is false, because sale could end in a emergency stop.
1232     // This function cannot be successfully called twice, because it will top being the controller,
1233     // and the generateTokens call will fail if called again.
1234 
1235     //token.changeController(networkPlaceholder); // Sale loses token controller power in favor of network placeholder
1236 
1237     token.changeController(genaroDevMultisig);
1238     saleFinalized = true;  // Set stop is true which will enable network deployment
1239     saleStopped = true;
1240   }
1241 
1242   // @notice Deploy Genaro Network contract.
1243   // @param networkAddress: The address the network was deployed at.
1244   function deployNetwork(address networkAddress)
1245            only_finalized_sale
1246            non_zero_address(networkAddress)
1247            only(genaroDevMultisig)
1248            public {
1249 
1250     networkPlaceholder.changeController(networkAddress);
1251   }
1252 
1253   function setGenaroDevMultisig(address _newMultisig)
1254            non_zero_address(_newMultisig)
1255            only(genaroDevMultisig)
1256            public {
1257 
1258     genaroDevMultisig = _newMultisig;
1259   }
1260 
1261   function getBlockNumber() constant internal returns (uint) {
1262     return block.number;
1263   }
1264 
1265   function computeCap(uint256 _cap, uint256 _cap_secure) constant public returns (bytes32) {
1266     return sha3(_cap, _cap_secure);
1267   }
1268 
1269   function isValidCap(uint256 _cap, uint256 _cap_secure) constant public returns (bool) {
1270     return computeCap(_cap, _cap_secure) == capCommitment;
1271   }
1272 
1273   modifier only(address x) {
1274     require(msg.sender == x);
1275     _;
1276   }
1277 
1278   modifier verify_cap(uint256 _cap, uint256 _cap_secure) {
1279     require(isValidCap(_cap,_cap_secure));
1280     _;
1281   }
1282 
1283   modifier only_before_sale {
1284     require(getBlockNumber() < initialBlock);
1285     _;
1286   }
1287 
1288   modifier only_during_sale_period {
1289     require(getBlockNumber() >= initialBlock);
1290     require(getBlockNumber() < finalBlock);
1291     _;
1292   }
1293 
1294   modifier only_after_sale {
1295     require(getBlockNumber() >= finalBlock);
1296     _;
1297   }
1298 
1299   modifier only_sale_stopped {
1300     require(saleStopped);
1301     _;
1302   }
1303 
1304   modifier only_sale_not_stopped {
1305     require(!saleStopped);
1306     _;
1307   }
1308 
1309   modifier only_before_sale_activation {
1310     require(!isActivated());
1311     _;
1312   }
1313 
1314   modifier only_sale_activated {
1315     require(isActivated());
1316     _;
1317   }
1318 
1319   modifier only_finalized_sale {
1320     require(getBlockNumber() >= finalBlock);
1321     require(saleFinalized);
1322     _;
1323   }
1324 
1325   modifier non_zero_address(address x) {
1326     require(x != 0);
1327     _;
1328   }
1329 
1330   modifier maximum_value(uint256 x) {
1331     require(msg.value <= x);
1332     _;
1333   }
1334 
1335   modifier minimum_value(uint256 x) {
1336     require(msg.value >= x);
1337     _;
1338   }
1339 }