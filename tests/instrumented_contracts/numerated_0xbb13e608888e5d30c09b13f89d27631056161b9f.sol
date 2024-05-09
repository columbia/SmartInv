1 pragma solidity ^0.4.13;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function safeMul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function safeDiv(uint a, uint b) internal returns (uint) {
14     assert(b > 0);
15     uint c = a / b;
16     assert(a == b * c + a % b);
17     return c;
18   }
19 
20   function safeSub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function safeAdd(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c>=a && c>=b);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47   function assert(bool assertion) internal {
48     require(assertion);
49   }
50 }
51 
52 // inspired by Zeppelin's Vested Token deriving MiniMeToken
53 
54 contract Controlled {
55     /// @notice The address of the controller is the only address that can call
56     ///  a function with this modifier
57     modifier onlyController{ require(msg.sender==controller); _; }
58 
59 
60     address public controller;
61 
62     function Controlled() { controller = msg.sender;}
63 
64     /// @notice Changes the controller of the contract
65     /// @param _newController The new controller of the contract
66     function changeController(address _newController) onlyController {
67         controller = _newController;
68     }
69 }
70 
71 /// @dev The token controller contract must implement these functions
72 contract Controller {
73     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
74     /// @param _owner The address that sent the ether to create tokens
75     /// @return True if the ether is accepted, false if it throws
76     function proxyPayment(address _owner) payable returns(bool);
77 
78     /// @notice Notifies the controller about a token transfer allowing the
79     ///  controller to react if desired
80     /// @param _from The origin of the transfer
81     /// @param _to The destination of the transfer
82     /// @param _amount The amount of the transfer
83     /// @return False if the controller does not authorize the transfer
84     function onTransfer(address _from, address _to, uint _amount) returns(bool);
85 
86     /// @notice Notifies the controller about an approval allowing the
87     ///  controller to react if desired
88     /// @param _owner The address that calls `approve()`
89     /// @param _spender The spender in the `approve()` call
90     /// @param _amount The amount in the `approve()` call
91     /// @return False if the controller does not authorize the approval
92     function onApprove(address _owner, address _spender, uint _amount)
93         returns(bool);
94 }
95 
96 contract ApproveAndCallReceiver {
97     function receiveApproval(address _from, uint256 _amount, address _token, bytes _data);
98 }
99 
100 /*
101  * ERC20 interface
102  * see https://github.com/ethereum/EIPs/issues/20
103  */
104 contract ERC20 {
105   function totalSupply() constant returns (uint);
106   function balanceOf(address who) constant returns (uint);
107   function allowance(address owner, address spender) constant returns (uint);
108 
109   function transfer(address to, uint value) returns (bool ok);
110   function transferFrom(address from, address to, uint value) returns (bool ok);
111   function approve(address spender, uint value) returns (bool ok);
112   event Transfer(address indexed from, address indexed to, uint value);
113   event Approval(address indexed owner, address indexed spender, uint value);
114 }
115 
116 contract MiniMeToken is ERC20, Controlled {
117     string public name;                //The Token's name: e.g. DigixDAO Tokens
118     uint8 public decimals;             //Number of decimals of the smallest unit
119     string public symbol;              //An identifier: e.g. REP
120     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
121 
122 
123     /// @dev `Checkpoint` is the structure that attaches a block number to a
124     ///  given value, the block number attached is the one that last changed the
125     ///  value
126     struct  Checkpoint {
127 
128         // `fromBlock` is the block number that the value was generated from
129         uint128 fromBlock;
130 
131         // `value` is the amount of tokens at a specific block number
132         uint128 value;
133     }
134 
135     // `parentToken` is the Token address that was cloned to produce this token;
136     //  it will be 0x0 for a token that was not cloned
137     MiniMeToken public parentToken;
138 
139     // `parentSnapShotBlock` is the block number from the Parent Token that was
140     //  used to determine the initial distribution of the Clone Token
141     uint public parentSnapShotBlock;
142 
143     // `creationBlock` is the block number that the Clone Token was created
144     uint public creationBlock;
145 
146     // `balances` is the map that tracks the balance of each address, in this
147     //  contract when the balance changes the block number that the change
148     //  occurred is also included in the map
149     mapping (address => Checkpoint[]) balances;
150 
151     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
152     mapping (address => mapping (address => uint256)) allowed;
153 
154     // Tracks the history of the `totalSupply` of the token
155     Checkpoint[] totalSupplyHistory;
156 
157     // Flag that determines if the token is transferable or not.
158     bool public transfersEnabled;
159 
160     // The factory used to create new clone tokens
161     MiniMeTokenFactory public tokenFactory;
162 
163 ////////////////
164 // Constructor
165 ////////////////
166 
167     /// @notice Constructor to create a MiniMeToken
168     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
169     ///  will create the Clone token contracts, the token factory needs to be
170     ///  deployed first
171     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
172     ///  new token
173     /// @param _parentSnapShotBlock Block of the parent token that will
174     ///  determine the initial distribution of the clone token, set to 0 if it
175     ///  is a new token
176     /// @param _tokenName Name of the new token
177     /// @param _decimalUnits Number of decimals of the new token
178     /// @param _tokenSymbol Token Symbol for the new token
179     /// @param _transfersEnabled If true, tokens will be able to be transferred
180     function MiniMeToken(
181         address _tokenFactory,
182         address _parentToken,
183         uint _parentSnapShotBlock,
184         string _tokenName,
185         uint8 _decimalUnits,
186         string _tokenSymbol,
187         bool _transfersEnabled
188     ) {
189         tokenFactory = MiniMeTokenFactory(_tokenFactory);
190         name = _tokenName;                                 // Set the name
191         decimals = _decimalUnits;                          // Set the decimals
192         symbol = _tokenSymbol;                             // Set the symbol
193         parentToken = MiniMeToken(_parentToken);
194         parentSnapShotBlock = _parentSnapShotBlock;
195         transfersEnabled = _transfersEnabled;
196         creationBlock = block.number;
197     }
198 
199 
200 ///////////////////
201 // ERC20 Methods
202 ///////////////////
203 
204     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
205     /// @param _to The address of the recipient
206     /// @param _amount The amount of tokens to be transferred
207     /// @return Whether the transfer was successful or not
208     function transfer(address _to, uint256 _amount) returns (bool success) {
209         require (transfersEnabled);
210     ////if (!transfersEnabled) throw;
211         return doTransfer(msg.sender, _to, _amount);
212     }
213 
214     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
215     ///  is approved by `_from`
216     /// @param _from The address holding the tokens being transferred
217     /// @param _to The address of the recipient
218     /// @param _amount The amount of tokens to be transferred
219     /// @return True if the transfer was successful
220     function transferFrom(address _from, address _to, uint256 _amount
221     ) returns (bool success) {
222 
223         // The controller of this contract can move tokens around at will,
224         //  this is important to recognize! Confirm that you trust the
225         //  controller of this contract, which in most situations should be
226         //  another open source smart contract or 0x0
227         if (msg.sender != controller) {
228             require (transfersEnabled);
229 
230             ////if (!transfersEnabled) throw;
231 
232             // The standard ERC 20 transferFrom functionality
233             assert (allowed[_from][msg.sender]>=_amount);
234 
235             ////if (allowed[_from][msg.sender] < _amount) throw;
236             allowed[_from][msg.sender] -= _amount;
237         }
238         return doTransfer(_from, _to, _amount);
239     }
240 
241     /// @dev This is the actual transfer function in the token contract, it can
242     ///  only be called by other functions in this contract.
243     /// @param _from The address holding the tokens being transferred
244     /// @param _to The address of the recipient
245     /// @param _amount The amount of tokens to be transferred
246     /// @return True if the transfer was successful
247     function doTransfer(address _from, address _to, uint _amount
248     ) internal returns(bool) {
249            if (_amount == 0) {
250                return true;
251            }
252 
253            // Do not allow transfer to 0x0 or the token contract itself
254            require((_to>0)&&(_to!=address(this)));
255 
256            //// if ((_to == 0) || (_to == address(this))) throw;
257 
258            // If the amount being transfered is more than the balance of the
259            //  account the transfer returns false
260            var previousBalanceFrom = balanceOfAt(_from, block.number);
261            assert(previousBalanceFrom >= _amount);
262 
263            // Alerts the token controller of the transfer
264            if (isContract(controller)) {
265                assert(Controller(controller).onTransfer(_from,_to,_amount));
266 
267            }
268 
269            // First update the balance array with the new value for the address
270            //  sending the tokens
271            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
272 
273            // Then update the balance array with the new value for the address
274            //  receiving the tokens
275            var previousBalanceTo = balanceOfAt(_to, block.number);
276            assert(previousBalanceTo+_amount>=previousBalanceTo); 
277            
278            //// if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
279            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
280 
281            // An event to make the transfer easy to find on the blockchain
282            Transfer(_from, _to, _amount);
283 
284            return true;
285     }
286 
287     /// @param _owner The address that's balance is being requested
288     /// @return The balance of `_owner` at the current block
289     function balanceOf(address _owner) constant returns (uint256 balance) {
290         return balanceOfAt(_owner, block.number);
291     }
292 
293     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
294     ///  its behalf. This is a modified version of the ERC20 approve function
295     ///  to be a little bit safer
296     /// @param _spender The address of the account able to transfer the tokens
297     /// @param _amount The amount of tokens to be approved for transfer
298     /// @return True if the approval was successful
299     function approve(address _spender, uint256 _amount) returns (bool success) {
300         require(transfersEnabled);
301 
302         // To change the approve amount you first have to reduce the addresses´
303         //  allowance to zero by calling `approve(_spender,0)` if it is not
304         //  already 0 to mitigate the race condition described here:
305         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
306         require((_amount==0)||(allowed[msg.sender][_spender]==0));
307 
308         // Alerts the token controller of the approve function call
309         if (isContract(controller)) {
310             assert(Controller(controller).onApprove(msg.sender,_spender,_amount));
311 
312             //  if (!Controller(controller).onApprove(msg.sender, _spender, _amount))
313             //        throw;
314         }
315 
316         allowed[msg.sender][_spender] = _amount;
317         Approval(msg.sender, _spender, _amount);
318         return true;
319     }
320 
321     /// @dev This function makes it easy to read the `allowed[]` map
322     /// @param _owner The address of the account that owns the token
323     /// @param _spender The address of the account able to transfer the tokens
324     /// @return Amount of remaining tokens of _owner that _spender is allowed
325     ///  to spend
326     function allowance(address _owner, address _spender
327     ) constant returns (uint256 remaining) {
328         return allowed[_owner][_spender];
329     }
330 
331     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
332     ///  its behalf, and then a function is triggered in the contract that is
333     ///  being approved, `_spender`. This allows users to use their tokens to
334     ///  interact with contracts in one function call instead of two
335     /// @param _spender The address of the contract able to transfer the tokens
336     /// @param _amount The amount of tokens to be approved for transfer
337     /// @return True if the function call was successful
338     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
339     ) returns (bool success) {
340         approve(_spender, _amount);
341 
342         // This portion is copied from ConsenSys's Standard Token Contract. It
343         //  calls the receiveApproval function that is part of the contract that
344         //  is being approved (`_spender`). The function should look like:
345         //  `receiveApproval(address _from, uint256 _amount, address
346         //  _tokenContract, bytes _extraData)` It is assumed that the call
347         //  *should* succeed, otherwise the plain vanilla approve would be used
348         ApproveAndCallReceiver(_spender).receiveApproval(
349            msg.sender,
350            _amount,
351            this,
352            _extraData
353         );
354         return true;
355     }
356 
357     /// @dev This function makes it easy to get the total number of tokens
358     /// @return The total number of tokens
359     function totalSupply() constant returns (uint) {
360         return totalSupplyAt(block.number);
361     }
362 
363 
364 ////////////////
365 // Query balance and totalSupply in History
366 ////////////////
367 
368     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
369     /// @param _owner The address from which the balance will be retrieved
370     /// @param _blockNumber The block number when the balance is queried
371     /// @return The balance at `_blockNumber`
372     function balanceOfAt(address _owner, uint _blockNumber) constant
373         returns (uint) {
374 
375         // These next few lines are used when the balance of the token is
376         //  requested before a check point was ever created for this token, it
377         //  requires that the `parentToken.balanceOfAt` be queried at the
378         //  genesis block for that token as this contains initial balance of
379         //  this token
380         if ((balances[_owner].length == 0)
381             || (balances[_owner][0].fromBlock > _blockNumber)) {
382             if (address(parentToken) != 0) {
383                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
384             } else {
385                 // Has no parent
386                 return 0;
387             }
388 
389         // This will return the expected balance during normal situations
390         } else {
391             return getValueAt(balances[_owner], _blockNumber);
392         }
393     }
394 
395     /// @notice Total amount of tokens at a specific `_blockNumber`.
396     /// @param _blockNumber The block number when the totalSupply is queried
397     /// @return The total amount of tokens at `_blockNumber`
398     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
399 
400         // These next few lines are used when the totalSupply of the token is
401         //  requested before a check point was ever created for this token, it
402         //  requires that the `parentToken.totalSupplyAt` be queried at the
403         //  genesis block for this token as that contains totalSupply of this
404         //  token at this block number.
405         if ((totalSupplyHistory.length == 0)
406             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
407             if (address(parentToken) != 0) {
408                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
409             } else {
410                 return 0;
411             }
412 
413         // This will return the expected totalSupply during normal situations
414         } else {
415             return getValueAt(totalSupplyHistory, _blockNumber);
416         }
417     }
418 
419     function min(uint a, uint b) internal returns (uint) {
420       return a < b ? a : b;
421     }
422 
423 ////////////////
424 // Clone Token Method
425 ////////////////
426 
427     /// @notice Creates a new clone token with the initial distribution being
428     ///  this token at `_snapshotBlock`
429     /// @param _cloneTokenName Name of the clone token
430     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
431     /// @param _cloneTokenSymbol Symbol of the clone token
432     /// @param _snapshotBlock Block when the distribution of the parent token is
433     ///  copied to set the initial distribution of the new clone token;
434     ///  if the block is higher than the actual block, the current block is used
435     /// @param _transfersEnabled True if transfers are allowed in the clone
436     /// @return The address of the new MiniMeToken Contract
437     function createCloneToken(
438         string _cloneTokenName,
439         uint8 _cloneDecimalUnits,
440         string _cloneTokenSymbol,
441         uint _snapshotBlock,
442         bool _transfersEnabled
443         ) returns(address) {
444         if (_snapshotBlock > block.number) _snapshotBlock = block.number;
445         MiniMeToken cloneToken = tokenFactory.createCloneToken(
446             this,
447             _snapshotBlock,
448             _cloneTokenName,
449             _cloneDecimalUnits,
450             _cloneTokenSymbol,
451             _transfersEnabled
452             );
453 
454         cloneToken.changeController(msg.sender);
455 
456         // An event to make the token easy to find on the blockchain
457         NewCloneToken(address(cloneToken), _snapshotBlock);
458         return address(cloneToken);
459     }
460 
461 ////////////////
462 // Generate and destroy tokens
463 ////////////////
464 
465     /// @notice Generates `_amount` tokens that are assigned to `_owner`
466     /// @param _owner The address that will be assigned the new tokens
467     /// @param _amount The quantity of tokens generated
468     /// @return True if the tokens are generated correctly
469     function generateTokens(address _owner, uint _amount
470     ) onlyController returns (bool) {
471         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
472         assert(curTotalSupply+_amount>=curTotalSupply);
473         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
474         var previousBalanceTo = balanceOf(_owner);
475         assert(previousBalanceTo+_amount>=previousBalanceTo);
476         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
477         Transfer(0, _owner, _amount);
478         return true;
479     }
480 
481 
482     /// @notice Burns `_amount` tokens from `_owner`
483     /// @param _owner The address that will lose the tokens
484     /// @param _amount The quantity of tokens to burn
485     /// @return True if the tokens are burned correctly
486     function destroyTokens(address _owner, uint _amount
487     ) onlyController returns (bool) {
488         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
489         assert(curTotalSupply >= _amount);
490         
491         //// if (curTotalSupply < _amount) throw;
492 
493         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
494         var previousBalanceFrom = balanceOf(_owner);
495         assert(previousBalanceFrom >=_amount);
496 
497         //// if (previousBalanceFrom < _amount) throw;
498         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
499         Transfer(_owner, 0, _amount);
500         return true;
501     }
502 
503 ////////////////
504 // Enable tokens transfers
505 ////////////////
506 
507 
508     /// @notice Enables token holders to transfer their tokens freely if true
509     /// @param _transfersEnabled True if transfers are allowed in the clone
510     function enableTransfers(bool _transfersEnabled) onlyController {
511         transfersEnabled = _transfersEnabled;
512     }
513 
514 ////////////////
515 // Internal helper functions to query and set a value in a snapshot array
516 ////////////////
517 
518     /// @dev `getValueAt` retrieves the number of tokens at a given block number
519     /// @param checkpoints The history of values being queried
520     /// @param _block The block number to retrieve the value at
521     /// @return The number of tokens being queried
522     function getValueAt(Checkpoint[] storage checkpoints, uint _block
523     ) constant internal returns (uint) {
524         if (checkpoints.length == 0) return 0;
525 
526         // Shortcut for the actual value
527         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
528             return checkpoints[checkpoints.length-1].value;
529         if (_block < checkpoints[0].fromBlock) return 0;
530 
531         // Binary search of the value in the array
532         uint min = 0;
533         uint max = checkpoints.length-1;
534         while (max > min) {
535             uint mid = (max + min + 1)/ 2;
536             if (checkpoints[mid].fromBlock<=_block) {
537                 min = mid;
538             } else {
539                 max = mid-1;
540             }
541         }
542         return checkpoints[min].value;
543     }
544 
545     /// @dev `updateValueAtNow` used to update the `balances` map and the
546     ///  `totalSupplyHistory`
547     /// @param checkpoints The history of data being updated
548     /// @param _value The new number of tokens
549     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
550     ) internal  {
551         if ((checkpoints.length == 0)
552         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
553                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
554                newCheckPoint.fromBlock =  uint128(block.number);
555                newCheckPoint.value = uint128(_value);
556            } else {
557                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
558                oldCheckPoint.value = uint128(_value);
559            }
560     }
561 
562     /// @dev Internal function to determine if an address is a contract
563     /// @param _addr The address being queried
564     /// @return True if `_addr` is a contract
565     function isContract(address _addr) constant internal returns(bool) {
566         uint size;
567         if (_addr == 0) return false;
568         assembly {
569             size := extcodesize(_addr)
570         }
571         return size>0;
572     }
573 
574     /// @notice The fallback function: If the contract's controller has not been
575     ///  set to 0, then the `proxyPayment` method is called which relays the
576     ///  ether and creates tokens as described in the token controller contract
577     function ()  payable {
578         require(isContract(controller));
579         assert(Controller(controller).proxyPayment.value(msg.value)(msg.sender));
580     }
581 
582 
583 ////////////////
584 // Events
585 ////////////////
586     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
587 }
588 
589 
590 ////////////////
591 // MiniMeTokenFactory
592 ////////////////
593 
594 /// @dev This contract is used to generate clone contracts from a contract.
595 ///  In solidity this is the way to create a contract from a contract of the
596 ///  same class
597 contract MiniMeTokenFactory {
598 
599     /// @notice Update the DApp by creating a new token with new functionalities
600     ///  the msg.sender becomes the controller of this clone token
601     /// @param _parentToken Address of the token being cloned
602     /// @param _snapshotBlock Block of the parent token that will
603     ///  determine the initial distribution of the clone token
604     /// @param _tokenName Name of the new token
605     /// @param _decimalUnits Number of decimals of the new token
606     /// @param _tokenSymbol Token Symbol for the new token
607     /// @param _transfersEnabled If true, tokens will be able to be transferred
608     /// @return The address of the new token contract
609     function createCloneToken(
610         address _parentToken,
611         uint _snapshotBlock,
612         string _tokenName,
613         uint8 _decimalUnits,
614         string _tokenSymbol,
615         bool _transfersEnabled
616     ) returns (MiniMeToken) {
617         MiniMeToken newToken = new MiniMeToken(
618             this,
619             _parentToken,
620             _snapshotBlock,
621             _tokenName,
622             _decimalUnits,
623             _tokenSymbol,
624             _transfersEnabled
625             );
626 
627         newToken.changeController(msg.sender);
628         return newToken;
629     }
630 }
631 
632 
633 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
634 // ability to createTokenGrants which are basically a transfer that limits the
635 // receiver of the tokens.
636 
637 
638 contract MiniMeIrrevocableVestedToken is MiniMeToken, SafeMath {
639 
640   uint256 MAX_GRANTS_PER_ADDRESS = 20;
641 
642   // Keep the struct at 3 sstores ( total value  20+32+24 =76 bytes)
643   struct TokenGrant {
644     address granter;  // 20 bytes
645     uint256 value;    // 32 bytes
646     uint64 cliff;
647     uint64 vesting;
648     uint64 start;     // 3*8 =24 bytes
649   }
650 
651   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting);
652 
653   mapping (address => TokenGrant[]) public grants;
654 
655   mapping (address => bool) canCreateGrants;
656   address vestingWhitelister;
657 
658   modifier canTransfer(address _sender, uint _value) {
659     require(_value<=spendableBalanceOf(_sender));
660     _;
661   }
662 
663   modifier onlyVestingWhitelister {
664     require(msg.sender==vestingWhitelister);
665     _;
666   }
667 
668   function MiniMeIrrevocableVestedToken (
669       address _tokenFactory,
670       address _parentToken,
671       uint _parentSnapShotBlock,
672       string _tokenName,
673       uint8 _decimalUnits,
674       string _tokenSymbol,
675       bool _transfersEnabled
676   ) MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
677     vestingWhitelister = msg.sender;
678     doSetCanCreateGrants(vestingWhitelister, true);
679   }
680 
681   // @dev Checks modifier and allows transfer if tokens are not locked.
682   function transfer(address _to, uint _value)
683            canTransfer(msg.sender, _value)
684            public
685            returns (bool success) {
686     return super.transfer(_to, _value);
687   }
688 
689   function transferFrom(address _from, address _to, uint _value)
690            canTransfer(_from, _value)
691            public
692            returns (bool success) {
693     return super.transferFrom(_from, _to, _value);
694   }
695 
696   function spendableBalanceOf(address _holder) constant public returns (uint) {
697     return transferableTokens(_holder, uint64(now));
698   }
699 
700   // main func for token grant
701 
702   function grantVestedTokens(
703     address _to,
704     uint256 _value,
705     uint64 _start,
706     uint64 _cliff,
707     uint64 _vesting) public {
708 
709     // Check start, cliff and vesting are properly order to ensure correct functionality of the formula.
710     require(_cliff >= _start && _vesting >= _cliff);
711     require(tokenGrantsCount(_to)<=MAX_GRANTS_PER_ADDRESS); //// To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
712 
713     assert(canCreateGrants[msg.sender]);
714 
715 
716     TokenGrant memory grant = TokenGrant(msg.sender, _value, _cliff, _vesting, _start);
717     grants[_to].push(grant);
718 
719     assert(transfer(_to,_value));
720 
721     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start);
722   }
723 
724   function setCanCreateGrants(address _addr, bool _allowed)
725            onlyVestingWhitelister public {
726     doSetCanCreateGrants(_addr, _allowed);
727   }
728 
729   function doSetCanCreateGrants(address _addr, bool _allowed)
730            internal {
731     canCreateGrants[_addr] = _allowed;
732   }
733 
734   function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
735     doSetCanCreateGrants(vestingWhitelister, false);
736     vestingWhitelister = _newWhitelister;
737     doSetCanCreateGrants(vestingWhitelister, true);
738   }
739 
740   function tokenGrantsCount(address _holder) constant public returns (uint index) {
741     return grants[_holder].length;
742   }
743 
744   function tokenGrant(address _holder, uint _grantId) constant public returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting) {
745     TokenGrant storage grant = grants[_holder][_grantId];
746 
747     granter = grant.granter;
748     value = grant.value;
749     start = grant.start;
750     cliff = grant.cliff;
751     vesting = grant.vesting;
752 
753     vested = vestedTokens(grant, uint64(now));
754   }
755 
756   function vestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
757     return calculateVestedTokens(
758       grant.value,
759       uint256(time),
760       uint256(grant.start),
761       uint256(grant.cliff),
762       uint256(grant.vesting)
763     );
764   }
765 
766   //  transferableTokens
767   //   |                         _/--------   NonVestedTokens
768   //   |                       _/
769   //   |                     _/
770   //   |                   _/
771   //   |                 _/
772   //   |                /
773   //   |              .|
774   //   |            .  |
775   //   |          .    |
776   //   |        .      |
777   //   |      .        |
778   //   |    .          |
779   //   +===+===========+---------+----------> time
780   //      Start       Cliff    Vesting
781 
782   function calculateVestedTokens(
783     uint256 tokens,
784     uint256 time,
785     uint256 start,
786     uint256 cliff,
787     uint256 vesting) internal constant returns (uint256)
788     {
789 
790     // Shortcuts for before cliff and after vesting cases.
791     if (time < cliff) return 0;
792     if (time >= vesting) return tokens;
793 
794     // Interpolate all vested tokens.
795     // As before cliff the shortcut returns 0, we can use just this function to
796     // calculate it.
797 
798     // vestedTokens = tokens * (time - start) / (vesting - start)
799     uint256 vestedTokens = safeDiv(
800                                   safeMul(
801                                     tokens,
802                                     safeSub(time, start)
803                                     ),
804                                   safeSub(vesting, start)
805                                   );
806 
807     return vestedTokens;
808   }
809 
810   function nonVestedTokens(TokenGrant grant, uint64 time) internal constant returns (uint256) {
811     return safeSub(grant.value, vestedTokens(grant, time));
812   }
813 
814   // @dev The date in which all tokens are transferable for the holder
815   // Useful for displaying purposes (not used in any logic calculations)
816   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
817     date = uint64(now);
818     uint256 grantIndex = tokenGrantsCount(holder);
819     for (uint256 i = 0; i < grantIndex; i++) {
820       date = max64(grants[holder][i].vesting, date);
821     }
822     return date;
823   }
824 
825   // @dev How many tokens can a holder transfer at a point in time
826   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
827     uint256 grantIndex = tokenGrantsCount(holder);
828 
829     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
830 
831     // Iterate through all the grants the holder has, and add all non-vested tokens
832     uint256 nonVested = 0;
833     for (uint256 i = 0; i < grantIndex; i++) {
834       nonVested = safeAdd(nonVested, nonVestedTokens(grants[holder][i], time));
835     }
836 
837     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
838     return safeSub(balanceOf(holder), nonVested);
839   }
840 }
841 
842 contract GNR is MiniMeIrrevocableVestedToken {
843   // @dev GNR constructor just parametrizes the MiniMeIrrevocableVestedToken constructor
844   function GNR(
845     address _tokenFactory
846   ) MiniMeIrrevocableVestedToken(
847     _tokenFactory,
848     0x0,                    // no parent token
849     0,                      // no snapshot block number from parent
850     "Genaro Network Token", // Token name
851     9,                     // Decimals
852     "GNR",                  // Symbol
853     true                    // Enable transfers
854     ) {}
855 }