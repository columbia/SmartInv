1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5   function mul(uint a, uint b) internal returns (uint) {
6     uint c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint a, uint b) internal returns (uint) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint a, uint b) internal returns (uint) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint a, uint b) internal returns (uint) {
24     uint c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 
29   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
30     return a >= b ? a : b;
31   }
32 
33   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
34     return a < b ? a : b;
35   }
36 
37   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
38     return a >= b ? a : b;
39   }
40 
41   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
42     return a < b ? a : b;
43   }
44 
45   function assert(bool assertion) internal {
46     if (!assertion) {
47       throw;
48     }
49   }
50 }
51 
52 contract Ownable {
53 
54     /// @dev `owner` is the only address that can call a function with this
55     /// modifier
56     modifier onlyOwner() {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     address public owner;
62 
63     /// @notice The Constructor assigns the message sender to be `owner`
64     function Ownable() {
65         owner = msg.sender;
66     }
67 
68     address public newOwner;
69 
70     /// @notice `owner` can step down and assign some other address to this role
71     /// @param _newOwner The address of the new owner.
72     function changeOwner(address _newOwner) onlyOwner {
73         newOwner = _newOwner;
74     }
75 
76 
77     function acceptOwnership() {
78         if (msg.sender == newOwner) {
79             owner = newOwner;
80         }
81     }
82 }
83 
84 contract Pausable is Ownable {
85   bool public stopped;
86   event onEmergencyChanged(bool isStopped);
87 
88   modifier stopInEmergency {
89     if (stopped) {
90       throw;
91     }
92     _;
93   }
94 
95   modifier onlyInEmergency {
96     if (!stopped) {
97       throw;
98     }
99     _;
100   }
101 
102   // called by the owner on emergency, triggers stopped state
103   function emergencyStop() external onlyOwner {
104     stopped = true;
105     onEmergencyChanged(stopped);
106   }
107 
108   // called by the owner on end of emergency, returns to normal state
109   function release() external onlyOwner onlyInEmergency {
110     stopped = false;
111     onEmergencyChanged(stopped);
112   }
113 
114 }
115 
116 contract ERC20Basic {
117   function totalSupply() constant returns (uint);
118   function balanceOf(address who) constant returns (uint);
119   function transfer(address to, uint value) returns (bool);
120   event Transfer(address indexed from, address indexed to, uint value);
121 }
122 
123 contract ERC20 is ERC20Basic {
124 
125   mapping(address => uint) balances;
126 
127   function allowance(address owner, address spender) constant returns (uint);
128   function transferFrom(address from, address to, uint value) returns (bool);
129   function approve(address spender, uint value) returns (bool);
130   function approveAndCall(address spender, uint256 value, bytes extraData) returns (bool);
131   event Approval(address indexed owner, address indexed spender, uint value);
132 
133   function doTransfer(address _from, address _to, uint _amount) internal returns(bool);
134 }
135 
136 contract GrantsControlled {
137     modifier onlyGrantsController { if (msg.sender != grantsController) throw; _; }
138 
139     address public grantsController;
140 
141     function GrantsControlled() { grantsController = msg.sender;}
142 
143     function changeGrantsController(address _newController) onlyGrantsController {
144         grantsController = _newController;
145     }
146 }
147 
148 contract LimitedTransferToken is ERC20 {
149   // Checks whether it can transfer or otherwise throws.
150   modifier canTransfer(address _sender, uint _value) {
151    if (_value > transferableTokens(_sender, uint64(now))) throw;
152    _;
153   }
154 
155   // Checks modifier and allows transfer if tokens are not locked.
156   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool) {
157    return super.transfer(_to, _value);
158   }
159 
160   // Checks modifier and allows transfer if tokens are not locked.
161   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool) {
162    return super.transferFrom(_from, _to, _value);
163   }
164 
165   // Default transferable tokens function returns all tokens for a holder (no limit).
166   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
167     return balanceOf(holder);
168   }
169 }
170 
171 contract Controlled {
172     /// @notice The address of the controller is the only address that can call
173     ///  a function with this modifier
174     modifier onlyController { if (msg.sender != controller) throw; _; }
175 
176     address public controller;
177 
178     function Controlled() { controller = msg.sender;}
179 
180     /// @notice Changes the controller of the contract
181     /// @param _newController The new controller of the contract
182     function changeController(address _newController) onlyController {
183         controller = _newController;
184     }
185 }
186 
187 contract MiniMeToken is ERC20, Controlled {
188     using SafeMath for uint;
189 
190     string public name;                //The Token's name: e.g. DigixDAO Tokens
191     uint8 public decimals;             //Number of decimals of the smallest unit
192     string public symbol;              //An identifier: e.g. REP
193     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
194 
195 
196     /// @dev `Checkpoint` is the structure that attaches a block number to a
197     ///  given value, the block number attached is the one that last changed the
198     ///  value
199     struct  Checkpoint {
200 
201         // `fromBlock` is the block number that the value was generated from
202         uint128 fromBlock;
203 
204         // `value` is the amount of tokens at a specific block number
205         uint128 value;
206     }
207 
208     // `parentToken` is the Token address that was cloned to produce this token;
209     //  it will be 0x0 for a token that was not cloned
210     MiniMeToken public parentToken;
211 
212     // `parentSnapShotBlock` is the block number from the Parent Token that was
213     //  used to determine the initial distribution of the Clone Token
214     uint public parentSnapShotBlock;
215 
216     // `creationBlock` is the block number that the Clone Token was created
217     uint public creationBlock;
218 
219     // `balances` is the map that tracks the balance of each address, in this
220     //  contract when the balance changes the block number that the change
221     //  occurred is also included in the map
222     mapping (address => Checkpoint[]) balances;
223 
224     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
225     mapping (address => mapping (address => uint256)) allowed;
226 
227     // Tracks the history of the `totalSupply` of the token
228     Checkpoint[] totalSupplyHistory;
229 
230     // Flag that determines if the token is transferable or not.
231     bool public transfersEnabled;
232 
233     // The factory used to create new clone tokens
234     MiniMeTokenFactory public tokenFactory;
235 
236 ////////////////
237 // Constructor
238 ////////////////
239 
240     /// @notice Constructor to create a MiniMeToken
241     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
242     ///  will create the Clone token contracts, the token factory needs to be
243     ///  deployed first
244     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
245     ///  new token
246     /// @param _parentSnapShotBlock Block of the parent token that will
247     ///  determine the initial distribution of the clone token, set to 0 if it
248     ///  is a new token
249     /// @param _tokenName Name of the new token
250     /// @param _decimalUnits Number of decimals of the new token
251     /// @param _tokenSymbol Token Symbol for the new token
252     /// @param _transfersEnabled If true, tokens will be able to be transferred
253     function MiniMeToken(
254         address _tokenFactory,
255         address _parentToken,
256         uint _parentSnapShotBlock,
257         string _tokenName,
258         uint8 _decimalUnits,
259         string _tokenSymbol,
260         bool _transfersEnabled
261     ) {
262         tokenFactory = MiniMeTokenFactory(_tokenFactory);
263         name = _tokenName;                                 // Set the name
264         decimals = _decimalUnits;                          // Set the decimals
265         symbol = _tokenSymbol;                             // Set the symbol
266         parentToken = MiniMeToken(_parentToken);
267         parentSnapShotBlock = _parentSnapShotBlock;
268         transfersEnabled = _transfersEnabled;
269         creationBlock = block.number;
270     }
271 
272 
273 ///////////////////
274 // ERC20 Methods
275 ///////////////////
276 
277     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
278     /// @param _to The address of the recipient
279     /// @param _amount The amount of tokens to be transferred
280     /// @return Whether the transfer was successful or not
281     function transfer(address _to, uint256 _amount) returns (bool success) {
282         if (!transfersEnabled) throw;
283         return doTransfer(msg.sender, _to, _amount);
284     }
285 
286     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
287     ///  is approved by `_from`
288     /// @param _from The address holding the tokens being transferred
289     /// @param _to The address of the recipient
290     /// @param _amount The amount of tokens to be transferred
291     /// @return True if the transfer was successful
292     function transferFrom(address _from, address _to, uint256 _amount
293     ) returns (bool success) {
294 
295         // The controller of this contract can move tokens around at will,
296         //  this is important to recognize! Confirm that you trust the
297         //  controller of this contract, which in most situations should be
298         //  another open source smart contract or 0x0
299         if (msg.sender != controller) {
300             if (!transfersEnabled) throw;
301 
302             // The standard ERC 20 transferFrom functionality
303             if (allowed[_from][msg.sender] < _amount) return false;
304             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
305         }
306         return doTransfer(_from, _to, _amount);
307     }
308 
309     /// @dev This is the actual transfer function in the token contract, it can
310     ///  only be called by other functions in this contract.
311     /// @param _from The address holding the tokens being transferred
312     /// @param _to The address of the recipient
313     /// @param _amount The amount of tokens to be transferred
314     /// @return True if the transfer was successful
315     function doTransfer(address _from, address _to, uint _amount
316     ) internal returns(bool) {
317 
318            if (_amount == 0) {
319                return true;
320            }
321 
322            if (parentSnapShotBlock >= block.number) throw;
323 
324            // Do not allow transfer to 0x0 or the token contract itself
325            if ((_to == 0) || (_to == address(this))) throw;
326 
327            // If the amount being transfered is more than the balance of the
328            //  account the transfer returns false
329            var previousBalanceFrom = balanceOfAt(_from, block.number);
330            if (previousBalanceFrom < _amount) {
331                return false;
332            }
333 
334            // Alerts the token controller of the transfer
335            if (isContract(controller)) {
336                if (!TokenController(controller).onTransfer(_from, _to, _amount))
337                throw;
338            }
339 
340            // First update the balance array with the new value for the address
341            //  sending the tokens
342            updateValueAtNow(balances[_from], previousBalanceFrom.sub(_amount));
343 
344            // Then update the balance array with the new value for the address
345            //  receiving the tokens
346            var previousBalanceTo = balanceOfAt(_to, block.number);
347            updateValueAtNow(balances[_to], previousBalanceTo.add(_amount));
348 
349            // An event to make the transfer easy to find on the blockchain
350            Transfer(_from, _to, _amount);
351 
352            return true;
353     }
354 
355     /// @param _owner The address that's balance is being requested
356     /// @return The balance of `_owner` at the current block
357     function balanceOf(address _owner) constant returns (uint256 balance) {
358         return balanceOfAt(_owner, block.number);
359     }
360 
361     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
362     ///  its behalf. This is a modified version of the ERC20 approve function
363     ///  to be a little bit safer
364     /// @param _spender The address of the account able to transfer the tokens
365     /// @param _amount The amount of tokens to be approved for transfer
366     /// @return True if the approval was successful
367     function approve(address _spender, uint256 _amount) returns (bool success) {
368         if (!transfersEnabled) throw;
369 
370         // To change the approve amount you first have to reduce the addresses`
371         //  allowance to zero by calling `approve(_spender,0)` if it is not
372         //  already 0 to mitigate the race condition described here:
373         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
375 
376         // Alerts the token controller of the approve function call
377         if (isContract(controller)) {
378             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
379                 throw;
380         }
381 
382         allowed[msg.sender][_spender] = _amount;
383         Approval(msg.sender, _spender, _amount);
384         return true;
385     }
386 
387     /// @dev This function makes it easy to read the `allowed[]` map
388     /// @param _owner The address of the account that owns the token
389     /// @param _spender The address of the account able to transfer the tokens
390     /// @return Amount of remaining tokens of _owner that _spender is allowed
391     ///  to spend
392     function allowance(address _owner, address _spender
393     ) constant returns (uint256 remaining) {
394         return allowed[_owner][_spender];
395     }
396 
397     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
398     ///  its behalf, and then a function is triggered in the contract that is
399     ///  being approved, `_spender`. This allows users to use their tokens to
400     ///  interact with contracts in one function call instead of two
401     /// @param _spender The address of the contract able to transfer the tokens
402     /// @param _amount The amount of tokens to be approved for transfer
403     /// @return True if the function call was successful
404     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
405     ) returns (bool success) {
406         if (!approve(_spender, _amount)) throw;
407 
408         ApproveAndCallFallBack(_spender).receiveApproval(
409             msg.sender,
410             _amount,
411             this,
412             _extraData
413         );
414 
415         return true;
416     }
417 
418     /// @dev This function makes it easy to get the total number of tokens
419     /// @return The total number of tokens
420     function totalSupply() constant returns (uint) {
421         return totalSupplyAt(block.number);
422     }
423 
424 
425 ////////////////
426 // Query balance and totalSupply in History
427 ////////////////
428 
429     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
430     /// @param _owner The address from which the balance will be retrieved
431     /// @param _blockNumber The block number when the balance is queried
432     /// @return The balance at `_blockNumber`
433     function balanceOfAt(address _owner, uint _blockNumber) constant
434         returns (uint) {
435 
436         // These next few lines are used when the balance of the token is
437         //  requested before a check point was ever created for this token, it
438         //  requires that the `parentToken.balanceOfAt` be queried at the
439         //  genesis block for that token as this contains initial balance of
440         //  this token
441         if ((balances[_owner].length == 0)
442             || (balances[_owner][0].fromBlock > _blockNumber)) {
443             if (address(parentToken) != 0) {
444                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
445             } else {
446                 // Has no parent
447                 return 0;
448             }
449 
450         // This will return the expected balance during normal situations
451         } else {
452             return getValueAt(balances[_owner], _blockNumber);
453         }
454     }
455 
456     /// @notice Total amount of tokens at a specific `_blockNumber`.
457     /// @param _blockNumber The block number when the totalSupply is queried
458     /// @return The total amount of tokens at `_blockNumber`
459     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
460 
461         // These next few lines are used when the totalSupply of the token is
462         //  requested before a check point was ever created for this token, it
463         //  requires that the `parentToken.totalSupplyAt` be queried at the
464         //  genesis block for this token as that contains totalSupply of this
465         //  token at this block number.
466         if ((totalSupplyHistory.length == 0)
467             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
468             if (address(parentToken) != 0) {
469                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
470             } else {
471                 return 0;
472             }
473 
474         // This will return the expected totalSupply during normal situations
475         } else {
476             return getValueAt(totalSupplyHistory, _blockNumber);
477         }
478     }
479 
480 ////////////////
481 // Clone Token Method
482 ////////////////
483 
484     /// @notice Creates a new clone token with the initial distribution being
485     ///  this token at `_snapshotBlock`
486     /// @param _cloneTokenName Name of the clone token
487     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
488     /// @param _cloneTokenSymbol Symbol of the clone token
489     /// @param _snapshotBlock Block when the distribution of the parent token is
490     ///  copied to set the initial distribution of the new clone token;
491     ///  if the block is zero than the actual block, the current block is used
492     /// @param _transfersEnabled True if transfers are allowed in the clone
493     /// @return The address of the new MiniMeToken Contract
494     function createCloneToken(
495         string _cloneTokenName,
496         uint8 _cloneDecimalUnits,
497         string _cloneTokenSymbol,
498         uint _snapshotBlock,
499         bool _transfersEnabled
500         ) returns(address) {
501         if (_snapshotBlock == 0) _snapshotBlock = block.number;
502         MiniMeToken cloneToken = tokenFactory.createCloneToken(
503             this,
504             _snapshotBlock,
505             _cloneTokenName,
506             _cloneDecimalUnits,
507             _cloneTokenSymbol,
508             _transfersEnabled
509             );
510 
511         cloneToken.changeController(msg.sender);
512 
513         // An event to make the token easy to find on the blockchain
514         NewCloneToken(address(cloneToken), _snapshotBlock);
515         return address(cloneToken);
516     }
517 
518 ////////////////
519 // Generate and destroy tokens
520 ////////////////
521 
522     /// @notice Generates `_amount` tokens that are assigned to `_owner`
523     /// @param _owner The address that will be assigned the new tokens
524     /// @param _amount The quantity of tokens generated
525     /// @return True if the tokens are generated correctly
526     function generateTokens(address _owner, uint _amount
527     ) onlyController returns (bool) {
528         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
529         updateValueAtNow(totalSupplyHistory, curTotalSupply.add(_amount));
530         var previousBalanceTo = balanceOf(_owner);
531         updateValueAtNow(balances[_owner], previousBalanceTo.add(_amount));
532         Transfer(0, _owner, _amount);
533         return true;
534     }
535 
536 
537     /// @notice Burns `_amount` tokens from `_owner`
538     /// @param _owner The address that will lose the tokens
539     /// @param _amount The quantity of tokens to burn
540     /// @return True if the tokens are burned correctly
541     function destroyTokens(address _owner, uint _amount
542     ) onlyController returns (bool) {
543         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
544         if (curTotalSupply < _amount) throw;
545         updateValueAtNow(totalSupplyHistory, curTotalSupply.sub(_amount));
546         var previousBalanceFrom = balanceOf(_owner);
547         if (previousBalanceFrom < _amount) throw;
548         updateValueAtNow(balances[_owner], previousBalanceFrom.sub(_amount));
549         Transfer(_owner, 0, _amount);
550         return true;
551     }
552 
553 ////////////////
554 // Enable tokens transfers
555 ////////////////
556 
557 
558     /// @notice Enables token holders to transfer their tokens freely if true
559     /// @param _transfersEnabled True if transfers are allowed in the clone
560     function enableTransfers(bool _transfersEnabled) onlyController {
561         transfersEnabled = _transfersEnabled;
562     }
563 
564 ////////////////
565 // Internal helper functions to query and set a value in a snapshot array
566 ////////////////
567 
568     /// @dev `getValueAt` retrieves the number of tokens at a given block number
569     /// @param checkpoints The history of values being queried
570     /// @param _block The block number to retrieve the value at
571     /// @return The number of tokens being queried
572     function getValueAt(Checkpoint[] storage checkpoints, uint _block
573     ) constant internal returns (uint) {
574         if (checkpoints.length == 0) return 0;
575 
576         // Shortcut for the actual value
577         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
578             return checkpoints[checkpoints.length-1].value;
579         if (_block < checkpoints[0].fromBlock) return 0;
580 
581         // Binary search of the value in the array
582         uint min = 0;
583         uint max = checkpoints.length-1;
584         while (max > min) {
585             uint mid = (max + min + 1)/ 2;
586             if (checkpoints[mid].fromBlock<=_block) {
587                 min = mid;
588             } else {
589                 max = mid-1;
590             }
591         }
592         return checkpoints[min].value;
593     }
594 
595     /// @dev `updateValueAtNow` used to update the `balances` map and the
596     ///  `totalSupplyHistory`
597     /// @param checkpoints The history of data being updated
598     /// @param _value The new number of tokens
599     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
600     ) internal  {
601         if ((checkpoints.length == 0)
602         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
603                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
604                newCheckPoint.fromBlock =  uint128(block.number);
605                newCheckPoint.value = uint128(_value);
606            } else {
607                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
608                oldCheckPoint.value = uint128(_value);
609            }
610     }
611 
612     /// @dev Internal function to determine if an address is a contract
613     /// @param _addr The address being queried
614     /// @return True if `_addr` is a contract
615     function isContract(address _addr) constant internal returns(bool) {
616         uint size;
617         if (_addr == 0) return false;
618         assembly {
619             size := extcodesize(_addr)
620         }
621         return size>0;
622     }
623 
624     /// @dev Helper function to return a min betwen the two uints
625     function min(uint a, uint b) internal returns (uint) {
626         return a < b ? a : b;
627     }
628 
629     /// @notice The fallback function: If the contract's controller has not been
630     ///  set to 0, then the `proxyPayment` method is called which relays the
631     ///  ether and creates tokens as described in the token controller contract
632     function ()  payable {
633         if (isContract(controller)) {
634             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
635                 throw;
636         } else {
637             throw;
638         }
639     }
640 
641     //////////
642     // Safety Methods
643     //////////
644 
645     /// @notice This method can be used by the controller to extract mistakenly
646     ///  sent tokens to this contract.
647     /// @param _token The address of the token contract that you want to recover
648     ///  set to 0 in case you want to extract ether.
649     /// @param _claimer Address that tokens will be send to
650     function claimTokens(address _token, address _claimer) onlyController {
651         if (_token == 0x0) {
652             _claimer.transfer(this.balance);
653             return;
654         }
655 
656         ERC20Basic token = ERC20Basic(_token);
657         uint balance = token.balanceOf(this);
658         token.transfer(_claimer, balance);
659         ClaimedTokens(_token, _claimer, balance);
660     }
661 
662 
663 ////////////////
664 // Events
665 ////////////////
666     event ClaimedTokens(address indexed _token, address indexed _claimer, uint _amount);
667     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
668     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
669     event Approval(
670         address indexed _owner,
671         address indexed _spender,
672         uint256 _amount
673         );
674 
675 }
676 
677 
678 ////////////////
679 // MiniMeTokenFactory
680 ////////////////
681 
682 /// @dev This contract is used to generate clone contracts from a contract.
683 ///  In solidity this is the way to create a contract from a contract of the
684 ///  same class
685 contract MiniMeTokenFactory {
686 
687     /// @notice Update the DApp by creating a new token with new functionalities
688     ///  the msg.sender becomes the controller of this clone token
689     /// @param _parentToken Address of the token being cloned
690     /// @param _snapshotBlock Block of the parent token that will
691     ///  determine the initial distribution of the clone token
692     /// @param _tokenName Name of the new token
693     /// @param _decimalUnits Number of decimals of the new token
694     /// @param _tokenSymbol Token Symbol for the new token
695     /// @param _transfersEnabled If true, tokens will be able to be transferred
696     /// @return The address of the new token contract
697     function createCloneToken(
698         address _parentToken,
699         uint _snapshotBlock,
700         string _tokenName,
701         uint8 _decimalUnits,
702         string _tokenSymbol,
703         bool _transfersEnabled
704     ) returns (MiniMeToken) {
705         MiniMeToken newToken = new MiniMeToken(
706             this,
707             _parentToken,
708             _snapshotBlock,
709             _tokenName,
710             _decimalUnits,
711             _tokenSymbol,
712             _transfersEnabled
713             );
714 
715         newToken.changeController(msg.sender);
716         return newToken;
717     }
718 }
719 
720 contract VestedToken is LimitedTransferToken, GrantsControlled {
721   using SafeMath for uint;
722 
723   uint256 MAX_GRANTS_PER_ADDRESS = 20;
724 
725   struct TokenGrant {
726     address granter;     // 20 bytes
727     uint256 value;       // 32 bytes
728     uint64 cliff;
729     uint64 vesting;
730     uint64 start;        // 3 * 8 = 24 bytes
731     bool revokable;
732     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
733   } // total 78 bytes = 3 sstore per operation (32 per sstore)
734 
735   mapping (address => TokenGrant[]) public grants;
736 
737   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
738 
739   /**
740    * @dev Grant tokens to a specified address
741    * @param _to address The address which the tokens will be granted to.
742    * @param _value uint256 The amount of tokens to be granted.
743    * @param _start uint64 Time of the beginning of the grant.
744    * @param _cliff uint64 Time of the cliff period.
745    * @param _vesting uint64 The vesting period.
746    */
747   function grantVestedTokens(
748     address _to,
749     uint256 _value,
750     uint64 _start,
751     uint64 _cliff,
752     uint64 _vesting,
753     bool _revokable,
754     bool _burnsOnRevoke
755   ) onlyGrantsController public {
756 
757     // Check for date inconsistencies that may cause unexpected behavior
758     if (_cliff < _start || _vesting < _cliff) {
759       throw;
760     }
761 
762     if (tokenGrantsCount(_to) > MAX_GRANTS_PER_ADDRESS) throw;   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
763 
764     uint count = grants[_to].push(
765                 TokenGrant(
766                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
767                   _value,
768                   _cliff,
769                   _vesting,
770                   _start,
771                   _revokable,
772                   _burnsOnRevoke
773                 )
774               );
775 
776     transfer(_to, _value);
777 
778     NewTokenGrant(msg.sender, _to, _value, count - 1);
779   }
780 
781   /**
782    * @dev Revoke the grant of tokens of a specifed address.
783    * @param _holder The address which will have its tokens revoked.
784    * @param _grantId The id of the token grant.
785    */
786   function revokeTokenGrant(address _holder, uint _grantId) public {
787     TokenGrant grant = grants[_holder][_grantId];
788 
789     if (!grant.revokable) { // Check if grant was revokable
790       throw;
791     }
792 
793     if (grant.granter != msg.sender) { // Only granter can revoke it
794       throw;
795     }
796 
797     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
798 
799     uint256 nonVested = nonVestedTokens(grant, uint64(now));
800 
801     // remove grant from array
802     delete grants[_holder][_grantId];
803     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
804     grants[_holder].length -= 1;
805 
806     // This will call MiniMe's doTransfer method, so token is transferred according to
807     // MiniMe Token logic
808     doTransfer(_holder, receiver, nonVested);
809 
810     Transfer(_holder, receiver, nonVested);
811   }
812 
813   /**
814    * @dev Revoke all grants of tokens of a specifed address.
815    * @param _holder The address which will have its tokens revoked.
816    */
817     function revokeAllTokenGrants(address _holder) {
818         var grandsCount = tokenGrantsCount(_holder);
819         for (uint i = 0; i < grandsCount; i++) {
820           revokeTokenGrant(_holder, 0);
821         }
822     }
823 
824   /**
825    * @dev Calculate the total amount of transferable tokens of a holder at a given time
826    * @param holder address The address of the holder
827    * @param time uint64 The specific time.
828    * @return An uint representing a holder's total amount of transferable tokens.
829    */
830   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
831     uint256 grantIndex = tokenGrantsCount(holder);
832 
833     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
834 
835     // Iterate through all the grants the holder has, and add all non-vested tokens
836     uint256 nonVested = 0;
837     for (uint256 i = 0; i < grantIndex; i++) {
838       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
839     }
840 
841     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
842     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
843 
844     // Return the minimum of how many vested can transfer and other value
845     // in case there are other limiting transferability factors (default is balanceOf)
846     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
847   }
848 
849   /**
850    * @dev Check the amount of grants that an address has.
851    * @param _holder The holder of the grants.
852    * @return A uint representing the total amount of grants.
853    */
854   function tokenGrantsCount(address _holder) constant returns (uint index) {
855     return grants[_holder].length;
856   }
857 
858   /**
859    * @dev Calculate amount of vested tokens at a specifc time.
860    * @param tokens uint256 The amount of tokens grantted.
861    * @param time uint64 The time to be checked
862    * @param start uint64 A time representing the begining of the grant
863    * @param cliff uint64 The cliff period.
864    * @param vesting uint64 The vesting period.
865    * @return An uint representing the amount of vested tokensof a specif grant.
866    *  transferableTokens
867    *   |                         _/--------   vestedTokens rect
868    *   |                       _/
869    *   |                     _/
870    *   |                   _/
871    *   |                 _/
872    *   |                /
873    *   |              .|
874    *   |            .  |
875    *   |          .    |
876    *   |        .      |
877    *   |      .        |
878    *   |    .          |
879    *   +===+===========+---------+----------> time
880    *      Start       Clift    Vesting
881    */
882   function calculateVestedTokens(
883     uint256 tokens,
884     uint256 time,
885     uint256 start,
886     uint256 cliff,
887     uint256 vesting) constant returns (uint256)
888     {
889       // Shortcuts for before cliff and after vesting cases.
890       if (time < cliff) return 0;
891       if (time >= vesting) return tokens;
892 
893       // Interpolate all vested tokens.
894       // As before cliff the shortcut returns 0, we can use just calculate a value
895       // in the vesting rect (as shown in above's figure)
896 
897       // vestedTokens = tokens * (time - start) / (vesting - start)
898       uint256 vestedTokens = SafeMath.div(
899                                     SafeMath.mul(
900                                       tokens,
901                                       SafeMath.sub(time, start)
902                                       ),
903                                     SafeMath.sub(vesting, start)
904                                     );
905 
906       return vestedTokens;
907   }
908 
909   /**
910    * @dev Get all information about a specifc grant.
911    * @param _holder The address which will have its tokens revoked.
912    * @param _grantId The id of the token grant.
913    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
914    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
915    */
916   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
917     TokenGrant grant = grants[_holder][_grantId];
918 
919     granter = grant.granter;
920     value = grant.value;
921     start = grant.start;
922     cliff = grant.cliff;
923     vesting = grant.vesting;
924     revokable = grant.revokable;
925     burnsOnRevoke = grant.burnsOnRevoke;
926 
927     vested = vestedTokens(grant, uint64(now));
928   }
929 
930   /**
931    * @dev Get the amount of vested tokens at a specific time.
932    * @param grant TokenGrant The grant to be checked.
933    * @param time The time to be checked
934    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
935    */
936   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
937     return calculateVestedTokens(
938       grant.value,
939       uint256(time),
940       uint256(grant.start),
941       uint256(grant.cliff),
942       uint256(grant.vesting)
943     );
944   }
945 
946   /**
947    * @dev Calculate the amount of non vested tokens at a specific time.
948    * @param grant TokenGrant The grant to be checked.
949    * @param time uint64 The time to be checked
950    * @return An uint representing the amount of non vested tokens of a specifc grant on the
951    * passed time frame.
952    */
953   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
954     return grant.value.sub(vestedTokens(grant, time));
955   }
956 
957   /**
958    * @dev Calculate the date when the holder can trasfer all its tokens
959    * @param holder address The address of the holder
960    * @return An uint representing the date of the last transferable tokens.
961    */
962   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
963     date = uint64(now);
964     uint256 grantIndex = grants[holder].length;
965     for (uint256 i = 0; i < grantIndex; i++) {
966       date = SafeMath.max64(grants[holder][i].vesting, date);
967     }
968   }
969 }
970 
971 contract ApproveAndCallFallBack {
972     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
973 }
974 
975 
976 contract TokenController {
977     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
978     /// @param _owner The address that sent the ether to create tokens
979     /// @return True if the ether is accepted, false if it throws
980     function proxyPayment(address _owner) payable returns(bool);
981 
982     /// @notice Notifies the controller about a token transfer allowing the
983     ///  controller to react if desired
984     /// @param _from The origin of the transfer
985     /// @param _to The destination of the transfer
986     /// @param _amount The amount of the transfer
987     /// @return False if the controller does not authorize the transfer
988     function onTransfer(address _from, address _to, uint _amount) returns(bool);
989 
990     /// @notice Notifies the controller about an approval allowing the
991     ///  controller to react if desired
992     /// @param _owner The address that calls `approve()`
993     /// @param _spender The spender in the `approve()` call
994     /// @param _amount The amount in the `approve()` call
995     /// @return False if the controller does not authorize the approval
996     function onApprove(address _owner, address _spender, uint _amount)
997         returns(bool);
998 }
999 
1000 contract District0xNetworkToken is MiniMeToken, VestedToken {
1001     function District0xNetworkToken(address _controller, address _tokenFactory)
1002         MiniMeToken(
1003             _tokenFactory,
1004             0x0,                        // no parent token
1005             0,                          // no snapshot block number from parent
1006             "district0x Network Token", // Token name
1007             18,                         // Decimals
1008             "DNT",                      // Symbol
1009             true                        // Enable transfers
1010             )
1011     {
1012         changeController(_controller);
1013         changeGrantsController(_controller);
1014     }
1015 }
1016 
1017 contract HasNoTokens is Ownable {
1018 
1019   District0xNetworkToken public district0xNetworkToken;
1020 
1021  /**
1022   * @dev Reject all ERC23 compatible tokens
1023   * @param from_ address The address that is transferring the tokens
1024   * @param value_ uint256 the amount of the specified token
1025   * @param data_ Bytes The data passed from the caller.
1026   */
1027   function tokenFallback(address from_, uint256 value_, bytes data_) external {
1028     throw;
1029   }
1030 
1031   function isTokenSaleToken(address tokenAddr) returns(bool);
1032 
1033   /**
1034    * @dev Reclaim all ERC20Basic compatible tokens
1035    * @param tokenAddr address The address of the token contract
1036    */
1037   function reclaimToken(address tokenAddr) external onlyOwner {
1038     require(!isTokenSaleToken(tokenAddr));
1039     ERC20Basic tokenInst = ERC20Basic(tokenAddr);
1040     uint256 balance = tokenInst.balanceOf(this);
1041     tokenInst.transfer(msg.sender, balance);
1042   }
1043 }
1044 
1045 
1046 contract District0xContribution is Pausable, HasNoTokens, TokenController {
1047     using SafeMath for uint;
1048 
1049     District0xNetworkToken public district0xNetworkToken;
1050     address public multisigWallet;                                      // Wallet that receives all sale funds
1051     address public founder1;                                            // Wallet of founder 1
1052     address public founder2;                                            // Wallet of founder 2
1053     address public earlySponsor;                                        // Wallet of early sponsor
1054     address[] public advisers;                                          // 4 Wallets of advisors
1055 
1056     uint public constant FOUNDER1_STAKE = 119000000 ether;              // 119M DNT
1057     uint public constant FOUNDER2_STAKE = 79000000 ether;               // 79M  DNT
1058     uint public constant EARLY_CONTRIBUTOR_STAKE = 5000000 ether;       // 5M   DNT
1059     uint public constant ADVISER_STAKE = 5000000 ether;                 // 5M   DNT
1060     uint public constant ADVISER_STAKE2 = 1000000 ether;                // 1M   DNT
1061     uint public constant COMMUNITY_ADVISERS_STAKE = 5000000 ether;      // 5M   DNT
1062     uint public constant CONTRIB_PERIOD1_STAKE = 600000000 ether;       // 600M DNT
1063     uint public constant CONTRIB_PERIOD2_STAKE = 140000000 ether;       // 140M DNT
1064     uint public constant CONTRIB_PERIOD3_STAKE = 40000000 ether;        // 40M  DNT
1065 
1066     uint public minContribAmount = 0.01 ether;                          // 0.01 ether
1067     uint public maxGasPrice = 50000000000;                              // 50 GWei
1068 
1069     uint public constant TEAM_VESTING_CLIFF = 24 weeks;                 // 6 months vesting cliff for founders and advisors, except community advisors
1070     uint public constant TEAM_VESTING_PERIOD = 96 weeks;                // 2 years vesting period for founders and advisors, except community advisors
1071 
1072     uint public constant EARLY_CONTRIBUTOR_VESTING_CLIFF = 12 weeks;    // 3 months vesting cliff for early sponsor
1073     uint public constant EARLY_CONTRIBUTOR_VESTING_PERIOD = 24 weeks;   // 6 months vesting cliff for early sponsor
1074 
1075     bool public tokenTransfersEnabled = false;                          // DNT token transfers will be enabled manually
1076                                                                         // after first contribution period
1077                                                                         // Can't be disabled back
1078     struct Contributor {
1079         uint amount;                        // Amount of ETH contributed by an address in given contribution period
1080         bool isCompensated;                 // Whether this contributor received DNT token for ETH contribution
1081         uint amountCompensated;             // Amount of DNT received. Not really needed to store,
1082                                             // but stored for accounting and security purposes
1083     }
1084 
1085     uint public softCapAmount;                                 // Soft cap of contribution period in wei
1086     uint public afterSoftCapDuration;                          // Number of seconds to the end of sale from the moment of reaching soft cap (unless reaching hardcap)
1087     uint public hardCapAmount;                                 // When reached this amount of wei, the contribution will end instantly
1088     uint public startTime;                                     // Start time of contribution period in UNIX time
1089     uint public endTime;                                       // End time of contribution period in UNIX time
1090     bool public isEnabled;                                     // If contribution period was enabled by multisignature
1091     bool public softCapReached;                                // If soft cap was reached
1092     bool public hardCapReached;                                // If hard cap was reached
1093     uint public totalContributed;                              // Total amount of ETH contributed in given period
1094     address[] public contributorsKeys;                         // Addresses of all contributors in given contribution period
1095     mapping (address => Contributor) public contributors;
1096 
1097     event onContribution(uint totalContributed, address indexed contributor, uint amount,
1098         uint contributorsCount);
1099     event onSoftCapReached(uint endTime);
1100     event onHardCapReached(uint endTime);
1101     event onCompensated(address indexed contributor, uint amount);
1102 
1103     modifier onlyMultisig() {
1104         require(multisigWallet == msg.sender);
1105         _;
1106     }
1107 
1108     function District0xContribution(
1109         address _multisigWallet,
1110         address _founder1,
1111         address _founder2,
1112         address _earlySponsor,
1113         address[] _advisers
1114     ) {
1115         require(_advisers.length == 5);
1116         multisigWallet = _multisigWallet;
1117         founder1 = _founder1;
1118         founder2 = _founder2;
1119         earlySponsor = _earlySponsor;
1120         advisers = _advisers;
1121     }
1122 
1123     // @notice Returns true if contribution period is currently running
1124     function isContribPeriodRunning() constant returns (bool) {
1125         return !hardCapReached &&
1126                isEnabled &&
1127                startTime <= now &&
1128                endTime > now;
1129     }
1130 
1131     function contribute()
1132         payable
1133         stopInEmergency
1134     {
1135         contributeWithAddress(msg.sender);
1136     }
1137 
1138     // @notice Function to participate in contribution period
1139     //  Amounts from the same address should be added up
1140     //  If soft or hard cap is reached, end time should be modified
1141     //  Funds should be transferred into multisig wallet
1142     // @param contributor Address that will receive DNT token
1143     function contributeWithAddress(address contributor)
1144         payable
1145         stopInEmergency
1146     {
1147         require(tx.gasprice <= maxGasPrice);
1148         require(msg.value >= minContribAmount);
1149         require(isContribPeriodRunning());
1150 
1151         uint contribValue = msg.value;
1152         uint excessContribValue = 0;
1153 
1154         uint oldTotalContributed = totalContributed;
1155 
1156         totalContributed = oldTotalContributed.add(contribValue);
1157 
1158         uint newTotalContributed = totalContributed;
1159 
1160         // Soft cap was reached
1161         if (newTotalContributed >= softCapAmount &&
1162             oldTotalContributed < softCapAmount)
1163         {
1164             softCapReached = true;
1165             endTime = afterSoftCapDuration.add(now);
1166             onSoftCapReached(endTime);
1167         }
1168         // Hard cap was reached
1169         if (newTotalContributed >= hardCapAmount &&
1170             oldTotalContributed < hardCapAmount)
1171         {
1172             hardCapReached = true;
1173             endTime = now;
1174             onHardCapReached(endTime);
1175 
1176             // Everything above hard cap will be sent back to contributor
1177             excessContribValue = newTotalContributed.sub(hardCapAmount);
1178             contribValue = contribValue.sub(excessContribValue);
1179 
1180             totalContributed = hardCapAmount;
1181         }
1182 
1183         if (contributors[contributor].amount == 0) {
1184             contributorsKeys.push(contributor);
1185         }
1186 
1187         contributors[contributor].amount = contributors[contributor].amount.add(contribValue);
1188 
1189         multisigWallet.transfer(contribValue);
1190         if (excessContribValue > 0) {
1191             msg.sender.transfer(excessContribValue);
1192         }
1193         onContribution(newTotalContributed, contributor, contribValue, contributorsKeys.length);
1194     }
1195 
1196     // @notice This method is called by owner after contribution period ends, to distribute DNT in proportional manner
1197     //  Each contributor should receive DNT just once even if this method is called multiple times
1198     //  In case of many contributors must be able to compensate contributors in paginational way, otherwise might
1199     //  run out of gas if wanted to compensate all on one method call. Therefore parameters offset and limit
1200     // @param periodIndex Index of contribution period (0-2)
1201     // @param offset Number of first contributors to skip.
1202     // @param limit Max number of contributors compensated on this call
1203     function compensateContributors(uint offset, uint limit)
1204         onlyOwner
1205     {
1206         require(isEnabled);
1207         require(endTime < now);
1208 
1209         uint i = offset;
1210         uint compensatedCount = 0;
1211         uint contributorsCount = contributorsKeys.length;
1212 
1213         uint ratio = CONTRIB_PERIOD1_STAKE
1214             .mul(1000000000000000000)
1215             .div(totalContributed);
1216 
1217         while (i < contributorsCount && compensatedCount < limit) {
1218             address contributorAddress = contributorsKeys[i];
1219             if (!contributors[contributorAddress].isCompensated) {
1220                 uint amountContributed = contributors[contributorAddress].amount;
1221                 contributors[contributorAddress].isCompensated = true;
1222 
1223                 contributors[contributorAddress].amountCompensated =
1224                     amountContributed.mul(ratio).div(1000000000000000000);
1225 
1226                 district0xNetworkToken.transfer(contributorAddress, contributors[contributorAddress].amountCompensated);
1227                 onCompensated(contributorAddress, contributors[contributorAddress].amountCompensated);
1228 
1229                 compensatedCount++;
1230             }
1231             i++;
1232         }
1233     }
1234 
1235     // @notice Method for setting up contribution period
1236     //  Only owner should be able to execute
1237     //  Setting first contribution period sets up vesting for founders & advisors
1238     //  Contribution period should still not be enabled after calling this method
1239     // @param softCapAmount Soft Cap in wei
1240     // @param afterSoftCapDuration Number of seconds till the end of sale in the moment of reaching soft cap (unless reaching hard cap)
1241     // @param hardCapAmount Hard Cap in wei
1242     // @param startTime Contribution start time in UNIX time
1243     // @param endTime Contribution end time in UNIX time
1244     function setContribPeriod(
1245         uint _softCapAmount,
1246         uint _afterSoftCapDuration,
1247         uint _hardCapAmount,
1248         uint _startTime,
1249         uint _endTime
1250     )
1251         onlyOwner
1252     {
1253         require(_softCapAmount > 0);
1254         require(_hardCapAmount > _softCapAmount);
1255         require(_afterSoftCapDuration > 0);
1256         require(_startTime > now);
1257         require(_endTime > _startTime);
1258         require(!isEnabled);
1259 
1260         softCapAmount = _softCapAmount;
1261         afterSoftCapDuration = _afterSoftCapDuration;
1262         hardCapAmount = _hardCapAmount;
1263         startTime = _startTime;
1264         endTime = _endTime;
1265 
1266         district0xNetworkToken.revokeAllTokenGrants(founder1);
1267         district0xNetworkToken.revokeAllTokenGrants(founder2);
1268         district0xNetworkToken.revokeAllTokenGrants(earlySponsor);
1269 
1270         for (uint j = 0; j < advisers.length; j++) {
1271             district0xNetworkToken.revokeAllTokenGrants(advisers[j]);
1272         }
1273 
1274         uint64 vestingDate = uint64(startTime.add(TEAM_VESTING_PERIOD));
1275         uint64 cliffDate = uint64(startTime.add(TEAM_VESTING_CLIFF));
1276         uint64 earlyContribVestingDate = uint64(startTime.add(EARLY_CONTRIBUTOR_VESTING_PERIOD));
1277         uint64 earlyContribCliffDate = uint64(startTime.add(EARLY_CONTRIBUTOR_VESTING_CLIFF));
1278         uint64 startDate = uint64(startTime);
1279 
1280         district0xNetworkToken.grantVestedTokens(founder1, FOUNDER1_STAKE, startDate, cliffDate, vestingDate, true, false);
1281         district0xNetworkToken.grantVestedTokens(founder2, FOUNDER2_STAKE, startDate, cliffDate, vestingDate, true, false);
1282         district0xNetworkToken.grantVestedTokens(earlySponsor, EARLY_CONTRIBUTOR_STAKE, startDate, earlyContribCliffDate, earlyContribVestingDate, true, false);
1283         district0xNetworkToken.grantVestedTokens(advisers[0], ADVISER_STAKE, startDate, cliffDate, vestingDate, true, false);
1284         district0xNetworkToken.grantVestedTokens(advisers[1], ADVISER_STAKE, startDate, cliffDate, vestingDate, true, false);
1285         district0xNetworkToken.grantVestedTokens(advisers[2], ADVISER_STAKE2, startDate, cliffDate, vestingDate, true, false);
1286         district0xNetworkToken.grantVestedTokens(advisers[3], ADVISER_STAKE2, startDate, cliffDate, vestingDate, true, false);
1287 
1288         // Community advisors stake has no vesting, but we set it up this way, so we can revoke it in case of
1289         // re-setting up contribution period
1290         district0xNetworkToken.grantVestedTokens(advisers[4], COMMUNITY_ADVISERS_STAKE, startDate, startDate, startDate, true, false);
1291     }
1292 
1293     // @notice Enables contribution period
1294     //  Must be executed by multisignature
1295     function enableContribPeriod()
1296         onlyMultisig
1297     {
1298         require(startTime > now);
1299         isEnabled = true;
1300     }
1301 
1302     // @notice Sets new min. contribution amount
1303     //  Only owner can execute
1304     //  Cannot be executed while contribution period is running
1305     // @param _minContribAmount new min. amount
1306     function setMinContribAmount(uint _minContribAmount)
1307         onlyOwner
1308     {
1309         require(_minContribAmount > 0);
1310         require(startTime > now);
1311         minContribAmount = _minContribAmount;
1312     }
1313 
1314     // @notice Sets new max gas price for contribution
1315     //  Only owner can execute
1316     //  Cannot be executed while contribution period is running
1317     // @param _minContribAmount new min. amount
1318     function setMaxGasPrice(uint _maxGasPrice)
1319         onlyOwner
1320     {
1321         require(_maxGasPrice > 0);
1322         require(startTime > now);
1323         maxGasPrice = _maxGasPrice;
1324     }
1325 
1326     // @notice Sets District0xNetworkToken contract
1327     //  Generates all DNT tokens and assigns them to this contract
1328     //  If token contract has already generated tokens, do not generate again
1329     // @param _district0xNetworkToken District0xNetworkToken address
1330     function setDistrict0xNetworkToken(address _district0xNetworkToken)
1331         onlyOwner
1332     {
1333         require(_district0xNetworkToken != 0x0);
1334         require(!isEnabled);
1335         district0xNetworkToken = District0xNetworkToken(_district0xNetworkToken);
1336         if (district0xNetworkToken.totalSupply() == 0) {
1337             district0xNetworkToken.generateTokens(this, FOUNDER1_STAKE
1338                 .add(FOUNDER2_STAKE)
1339                 .add(EARLY_CONTRIBUTOR_STAKE)
1340                 .add(ADVISER_STAKE.mul(2))
1341                 .add(ADVISER_STAKE2.mul(2))
1342                 .add(COMMUNITY_ADVISERS_STAKE)
1343                 .add(CONTRIB_PERIOD1_STAKE));
1344 
1345             district0xNetworkToken.generateTokens(multisigWallet, CONTRIB_PERIOD2_STAKE
1346                 .add(CONTRIB_PERIOD3_STAKE));
1347         }
1348     }
1349 
1350     // @notice Enables transfers of DNT
1351     //  Will be executed after first contribution period by owner
1352     function enableDistrict0xNetworkTokenTransfers()
1353         onlyOwner
1354     {
1355         require(endTime < now);
1356         tokenTransfersEnabled = true;
1357     }
1358 
1359     // @notice Method to claim tokens accidentally sent to a DNT contract
1360     //  Only multisig wallet can execute
1361     // @param _token Address of claimed ERC20 Token
1362     function claimTokensFromTokenDistrict0xNetworkToken(address _token)
1363         onlyMultisig
1364     {
1365         district0xNetworkToken.claimTokens(_token, multisigWallet);
1366     }
1367 
1368     // @notice Kill method should not really be needed, but just in case
1369     function kill(address _to) onlyMultisig external {
1370         suicide(_to);
1371     }
1372 
1373     function()
1374         payable
1375         stopInEmergency
1376     {
1377         contributeWithAddress(msg.sender);
1378     }
1379 
1380     // MiniMe Controller default settings for allowing token transfers.
1381     function proxyPayment(address _owner) payable public returns (bool) {
1382         throw;
1383     }
1384 
1385     // Before transfers are enabled for everyone, only this contract is allowed to distribute DNT
1386     function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
1387         return tokenTransfersEnabled || _from == address(this) || _to == address(this);
1388     }
1389 
1390     function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
1391         return tokenTransfersEnabled;
1392     }
1393 
1394     function isTokenSaleToken(address tokenAddr) returns(bool) {
1395         return district0xNetworkToken == tokenAddr;
1396     }
1397 
1398     /*
1399      Following constant methods are used for tests and contribution web app
1400      They don't impact logic of contribution contract, therefor DOES NOT NEED TO BE AUDITED
1401      */
1402 
1403     // Used by contribution front-end to obtain contribution period properties
1404     function getContribPeriod()
1405         constant
1406         returns (bool[3] boolValues, uint[8] uintValues)
1407     {
1408         boolValues[0] = isEnabled;
1409         boolValues[1] = softCapReached;
1410         boolValues[2] = hardCapReached;
1411 
1412         uintValues[0] = softCapAmount;
1413         uintValues[1] = afterSoftCapDuration;
1414         uintValues[2] = hardCapAmount;
1415         uintValues[3] = startTime;
1416         uintValues[4] = endTime;
1417         uintValues[5] = totalContributed;
1418         uintValues[6] = contributorsKeys.length;
1419         uintValues[7] = CONTRIB_PERIOD1_STAKE;
1420 
1421         return (boolValues, uintValues);
1422     }
1423 
1424     // Used by contribution front-end to obtain contribution contract properties
1425     function getConfiguration()
1426         constant
1427         returns (bool, address, address, address, address, address[] _advisers, bool, uint)
1428     {
1429         _advisers = new address[](advisers.length);
1430         for (uint i = 0; i < advisers.length; i++) {
1431             _advisers[i] = advisers[i];
1432         }
1433         return (stopped, multisigWallet, founder1, founder2, earlySponsor, _advisers, tokenTransfersEnabled,
1434             maxGasPrice);
1435     }
1436 
1437     // Used by contribution front-end to obtain contributor's properties
1438     function getContributor(address contributorAddress)
1439         constant
1440         returns(uint, bool, uint)
1441     {
1442         Contributor contributor = contributors[contributorAddress];
1443         return (contributor.amount, contributor.isCompensated, contributor.amountCompensated);
1444     }
1445 
1446     // Function to verify if all contributors were compensated
1447     function getUncompensatedContributors(uint offset, uint limit)
1448         constant
1449         returns (uint[] contributorIndexes)
1450     {
1451         uint contributorsCount = contributorsKeys.length;
1452 
1453         if (limit == 0) {
1454             limit = contributorsCount;
1455         }
1456 
1457         uint i = offset;
1458         uint resultsCount = 0;
1459         uint[] memory _contributorIndexes = new uint[](limit);
1460 
1461         while (i < contributorsCount && resultsCount < limit) {
1462             if (!contributors[contributorsKeys[i]].isCompensated) {
1463                 _contributorIndexes[resultsCount] = i;
1464                 resultsCount++;
1465             }
1466             i++;
1467         }
1468 
1469         contributorIndexes = new uint[](resultsCount);
1470         for (i = 0; i < resultsCount; i++) {
1471             contributorIndexes[i] = _contributorIndexes[i];
1472         }
1473         return contributorIndexes;
1474     }
1475 
1476     function getNow()
1477         constant
1478         returns(uint)
1479     {
1480         return now;
1481     }
1482 }