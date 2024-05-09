1 pragma solidity ^0.4.18;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Controlled {
6     /// @notice The address of the controller is the only address that can call
7     ///  a function with this modifier
8     modifier onlyController { require(msg.sender == controller); _; }
9 
10     address public controller;
11 
12     function Controlled() public { controller = msg.sender;}
13 
14     /// @notice Changes the controller of the contract
15     /// @param _newController The new controller of the contract
16     function changeController(address _newController) public onlyController {
17         controller = _newController;
18     }
19 }
20 contract TokenController {
21     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
22     /// @param _owner The address that sent the ether to create tokens
23     /// @return True if the ether is accepted, false if it throws
24     function proxyPayment(address _owner) public payable returns(bool);
25 
26     /// @notice Notifies the controller about a token transfer allowing the
27     ///  controller to react if desired
28     /// @param _from The origin of the transfer
29     /// @param _to The destination of the transfer
30     /// @param _amount The amount of the transfer
31     /// @return False if the controller does not authorize the transfer
32     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
33 
34     /// @notice Notifies the controller about an approval allowing the
35     ///  controller to react if desired
36     /// @param _owner The address that calls `approve()`
37     /// @param _spender The spender in the `approve()` call
38     /// @param _amount The amount in the `approve()` call
39     /// @return False if the controller does not authorize the approval
40     function onApprove(address _owner, address _spender, uint _amount) public
41         returns(bool);
42 }
43 library SafeMath {
44   function mul(uint a, uint b) internal returns (uint) {
45     uint c = a * b;
46     assert(a == 0 || c / a == b);
47     return c;
48   }
49 
50   function div(uint a, uint b) internal returns (uint) {
51     // assert(b > 0); // Solidity automatically throws when dividing by 0
52     uint c = a / b;
53     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
54     return c;
55   }
56 
57   function sub(uint a, uint b) internal returns (uint) {
58     assert(b <= a);
59     return a - b;
60   }
61 
62   function add(uint a, uint b) internal returns (uint) {
63     uint c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 
68   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a >= b ? a : b;
70   }
71 
72   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
73     return a < b ? a : b;
74   }
75 
76   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a >= b ? a : b;
78   }
79 
80   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
81     return a < b ? a : b;
82   }
83 
84   function assert(bool assertion) internal {
85     require (assertion);
86   }
87 }
88 
89 contract ERC20Basic {
90   function totalSupply() constant returns (uint);
91   function balanceOf(address who) constant returns (uint);
92   function transfer(address to, uint value) returns (bool);
93   event Transfer(address indexed from, address indexed to, uint value);
94 }
95 /*
96  * ERC20 interface
97  * see https://github.com/ethereum/EIPs/issues/20
98  *
99  * Slightly modified version of OpenZeppelin's ERC20
100  * Original can be found ./orig/ERC20.sol or https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/token/ERC20.sol
101  * Modifications:
102  * - Added doTransfer so it can be used in VestedToken with implmentation from MiniMe token
103  *
104  */
105 contract ERC20 is ERC20Basic {
106 
107   mapping(address => uint) balances;
108 
109   function allowance(address owner, address spender) constant returns (uint);
110   function transferFrom(address from, address to, uint value) returns (bool);
111   function approve(address spender, uint value) returns (bool);
112   function approveAndCall(address spender, uint256 value, bytes extraData) returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint value);
114 
115   function doTransfer(address _from, address _to, uint _amount) internal returns(bool);
116 }
117 
118 contract ApproveAndCallFallBack {
119     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
120 }
121 
122 /// @dev The actual token contract, the default controller is the msg.sender
123 ///  that deploys the contract, so usually this token will be deployed by a
124 ///  token controller contract, which Giveth will call a "Campaign"
125 contract MiniMeToken is Controlled {
126 
127     string public name;                //The Token's name: e.g. DigixDAO Tokens
128     uint8 public decimals;             //Number of decimals of the smallest unit
129     string public symbol;              //An identifier: e.g. REP
130     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
131 
132 
133     /// @dev `Checkpoint` is the structure that attaches a block number to a
134     ///  given value, the block number attached is the one that last changed the
135     ///  value
136     struct  Checkpoint {
137 
138         // `fromBlock` is the block number that the value was generated from
139         uint128 fromBlock;
140 
141         // `value` is the amount of tokens at a specific block number
142         uint128 value;
143     }
144 
145     // `parentToken` is the Token address that was cloned to produce this token;
146     //  it will be 0x0 for a token that was not cloned
147     MiniMeToken public parentToken;
148 
149     // `parentSnapShotBlock` is the block number from the Parent Token that was
150     //  used to determine the initial distribution of the Clone Token
151     uint public parentSnapShotBlock;
152 
153     // `creationBlock` is the block number that the Clone Token was created
154     uint public creationBlock;
155 
156     // `balances` is the map that tracks the balance of each address, in this
157     //  contract when the balance changes the block number that the change
158     //  occurred is also included in the map
159     mapping (address => Checkpoint[]) balances;
160 
161     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
162     mapping (address => mapping (address => uint256)) allowed;
163 
164     // Tracks the history of the `totalSupply` of the token
165     Checkpoint[] totalSupplyHistory;
166 
167     // Flag that determines if the token is transferable or not.
168     bool public transfersEnabled;
169 
170     // The factory used to create new clone tokens
171     MiniMeTokenFactory public tokenFactory;
172 
173 ////////////////
174 // Constructor
175 ////////////////
176 
177     /// @notice Constructor to create a MiniMeToken
178     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
179     ///  will create the Clone token contracts, the token factory needs to be
180     ///  deployed first
181     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
182     ///  new token
183     /// @param _parentSnapShotBlock Block of the parent token that will
184     ///  determine the initial distribution of the clone token, set to 0 if it
185     ///  is a new token
186     /// @param _tokenName Name of the new token
187     /// @param _decimalUnits Number of decimals of the new token
188     /// @param _tokenSymbol Token Symbol for the new token
189     /// @param _transfersEnabled If true, tokens will be able to be transferred
190     function MiniMeToken(
191         address _tokenFactory,
192         address _parentToken,
193         uint _parentSnapShotBlock,
194         string _tokenName,
195         uint8 _decimalUnits,
196         string _tokenSymbol,
197         bool _transfersEnabled
198     ) public {
199         tokenFactory = MiniMeTokenFactory(_tokenFactory);
200         name = _tokenName;                                 // Set the name
201         decimals = _decimalUnits;                          // Set the decimals
202         symbol = _tokenSymbol;                             // Set the symbol
203         parentToken = MiniMeToken(_parentToken);
204         parentSnapShotBlock = _parentSnapShotBlock;
205         transfersEnabled = _transfersEnabled;
206         creationBlock = block.number;
207     }
208 
209 
210 ///////////////////
211 // ERC20 Methods
212 ///////////////////
213 
214     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
215     /// @param _to The address of the recipient
216     /// @param _amount The amount of tokens to be transferred
217     /// @return Whether the transfer was successful or not
218     function transfer(address _to, uint256 _amount) public returns (bool success) {
219         require(transfersEnabled);
220         doTransfer(msg.sender, _to, _amount);
221         return true;
222     }
223 
224     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
225     ///  is approved by `_from`
226     /// @param _from The address holding the tokens being transferred
227     /// @param _to The address of the recipient
228     /// @param _amount The amount of tokens to be transferred
229     /// @return True if the transfer was successful
230     function transferFrom(address _from, address _to, uint256 _amount
231     ) public returns (bool success) {
232 
233         // The controller of this contract can move tokens around at will,
234         //  this is important to recognize! Confirm that you trust the
235         //  controller of this contract, which in most situations should be
236         //  another open source smart contract or 0x0
237         if (msg.sender != controller) {
238             require(transfersEnabled);
239 
240             // The standard ERC 20 transferFrom functionality
241             require(allowed[_from][msg.sender] >= _amount);
242             allowed[_from][msg.sender] -= _amount;
243         }
244         doTransfer(_from, _to, _amount);
245         return true;
246     }
247 
248     /// @dev This is the actual transfer function in the token contract, it can
249     ///  only be called by other functions in this contract.
250     /// @param _from The address holding the tokens being transferred
251     /// @param _to The address of the recipient
252     /// @param _amount The amount of tokens to be transferred
253     /// @return True if the transfer was successful
254     function doTransfer(address _from, address _to, uint _amount
255     ) internal {
256 
257            if (_amount == 0) {
258                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
259                return;
260            }
261 
262            require(parentSnapShotBlock < block.number);
263 
264            // Do not allow transfer to 0x0 or the token contract itself
265            require((_to != 0) && (_to != address(this)));
266 
267            // If the amount being transfered is more than the balance of the
268            //  account the transfer throws
269            var previousBalanceFrom = balanceOfAt(_from, block.number);
270 
271            require(previousBalanceFrom >= _amount);
272 
273            // Alerts the token controller of the transfer
274            if (isContract(controller)) {
275                require(TokenController(controller).onTransfer(_from, _to, _amount));
276            }
277 
278            // First update the balance array with the new value for the address
279            //  sending the tokens
280            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
281 
282            // Then update the balance array with the new value for the address
283            //  receiving the tokens
284            var previousBalanceTo = balanceOfAt(_to, block.number);
285            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
286            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
287 
288            // An event to make the transfer easy to find on the blockchain
289            Transfer(_from, _to, _amount);
290 
291     }
292 
293     /// @param _owner The address that's balance is being requested
294     /// @return The balance of `_owner` at the current block
295     function balanceOf(address _owner) public constant returns (uint256 balance) {
296         return balanceOfAt(_owner, block.number);
297     }
298 
299     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
300     ///  its behalf. This is a modified version of the ERC20 approve function
301     ///  to be a little bit safer
302     /// @param _spender The address of the account able to transfer the tokens
303     /// @param _amount The amount of tokens to be approved for transfer
304     /// @return True if the approval was successful
305     function approve(address _spender, uint256 _amount) public returns (bool success) {
306         require(transfersEnabled);
307 
308         // To change the approve amount you first have to reduce the addresses`
309         //  allowance to zero by calling `approve(_spender,0)` if it is not
310         //  already 0 to mitigate the race condition described here:
311         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
312         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
313 
314         // Alerts the token controller of the approve function call
315         if (isContract(controller)) {
316             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
317         }
318 
319         allowed[msg.sender][_spender] = _amount;
320         Approval(msg.sender, _spender, _amount);
321         return true;
322     }
323 
324     /// @dev This function makes it easy to read the `allowed[]` map
325     /// @param _owner The address of the account that owns the token
326     /// @param _spender The address of the account able to transfer the tokens
327     /// @return Amount of remaining tokens of _owner that _spender is allowed
328     ///  to spend
329     function allowance(address _owner, address _spender
330     ) public constant returns (uint256 remaining) {
331         return allowed[_owner][_spender];
332     }
333 
334     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
335     ///  its behalf, and then a function is triggered in the contract that is
336     ///  being approved, `_spender`. This allows users to use their tokens to
337     ///  interact with contracts in one function call instead of two
338     /// @param _spender The address of the contract able to transfer the tokens
339     /// @param _amount The amount of tokens to be approved for transfer
340     /// @return True if the function call was successful
341     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
342     ) public returns (bool success) {
343         require(approve(_spender, _amount));
344 
345         ApproveAndCallFallBack(_spender).receiveApproval(
346             msg.sender,
347             _amount,
348             this,
349             _extraData
350         );
351 
352         return true;
353     }
354 
355     /// @dev This function makes it easy to get the total number of tokens
356     /// @return The total number of tokens
357     function totalSupply() public constant returns (uint) {
358         return totalSupplyAt(block.number);
359     }
360 
361 
362 ////////////////
363 // Query balance and totalSupply in History
364 ////////////////
365 
366     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
367     /// @param _owner The address from which the balance will be retrieved
368     /// @param _blockNumber The block number when the balance is queried
369     /// @return The balance at `_blockNumber`
370     function balanceOfAt(address _owner, uint _blockNumber) public constant
371         returns (uint) {
372 
373         // These next few lines are used when the balance of the token is
374         //  requested before a check point was ever created for this token, it
375         //  requires that the `parentToken.balanceOfAt` be queried at the
376         //  genesis block for that token as this contains initial balance of
377         //  this token
378         if ((balances[_owner].length == 0)
379             || (balances[_owner][0].fromBlock > _blockNumber)) {
380             if (address(parentToken) != 0) {
381                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
382             } else {
383                 // Has no parent
384                 return 0;
385             }
386 
387         // This will return the expected balance during normal situations
388         } else {
389             return getValueAt(balances[_owner], _blockNumber);
390         }
391     }
392 
393     /// @notice Total amount of tokens at a specific `_blockNumber`.
394     /// @param _blockNumber The block number when the totalSupply is queried
395     /// @return The total amount of tokens at `_blockNumber`
396     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
397 
398         // These next few lines are used when the totalSupply of the token is
399         //  requested before a check point was ever created for this token, it
400         //  requires that the `parentToken.totalSupplyAt` be queried at the
401         //  genesis block for this token as that contains totalSupply of this
402         //  token at this block number.
403         if ((totalSupplyHistory.length == 0)
404             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
405             if (address(parentToken) != 0) {
406                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
407             } else {
408                 return 0;
409             }
410 
411         // This will return the expected totalSupply during normal situations
412         } else {
413             return getValueAt(totalSupplyHistory, _blockNumber);
414         }
415     }
416 
417 ////////////////
418 // Clone Token Method
419 ////////////////
420 
421     /// @notice Creates a new clone token with the initial distribution being
422     ///  this token at `_snapshotBlock`
423     /// @param _cloneTokenName Name of the clone token
424     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
425     /// @param _cloneTokenSymbol Symbol of the clone token
426     /// @param _snapshotBlock Block when the distribution of the parent token is
427     ///  copied to set the initial distribution of the new clone token;
428     ///  if the block is zero than the actual block, the current block is used
429     /// @param _transfersEnabled True if transfers are allowed in the clone
430     /// @return The address of the new MiniMeToken Contract
431     function createCloneToken(
432         string _cloneTokenName,
433         uint8 _cloneDecimalUnits,
434         string _cloneTokenSymbol,
435         uint _snapshotBlock,
436         bool _transfersEnabled
437         ) public returns(address) {
438         if (_snapshotBlock == 0) _snapshotBlock = block.number;
439         MiniMeToken cloneToken = tokenFactory.createCloneToken(
440             this,
441             _snapshotBlock,
442             _cloneTokenName,
443             _cloneDecimalUnits,
444             _cloneTokenSymbol,
445             _transfersEnabled
446             );
447 
448         cloneToken.changeController(msg.sender);
449 
450         // An event to make the token easy to find on the blockchain
451         NewCloneToken(address(cloneToken), _snapshotBlock);
452         return address(cloneToken);
453     }
454 
455 ////////////////
456 // Generate and destroy tokens
457 ////////////////
458 
459     /// @notice Generates `_amount` tokens that are assigned to `_owner`
460     /// @param _owner The address that will be assigned the new tokens
461     /// @param _amount The quantity of tokens generated
462     /// @return True if the tokens are generated correctly
463     function generateTokens(address _owner, uint _amount
464     ) public onlyController returns (bool) {
465         uint curTotalSupply = totalSupply();
466         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
467         uint previousBalanceTo = balanceOf(_owner);
468         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
469         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
470         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
471         Transfer(0, _owner, _amount);
472         return true;
473     }
474 
475 
476     /// @notice Burns `_amount` tokens from `_owner`
477     /// @param _owner The address that will lose the tokens
478     /// @param _amount The quantity of tokens to burn
479     /// @return True if the tokens are burned correctly
480     function destroyTokens(address _owner, uint _amount
481     ) onlyController public returns (bool) {
482         uint curTotalSupply = totalSupply();
483         require(curTotalSupply >= _amount);
484         uint previousBalanceFrom = balanceOf(_owner);
485         require(previousBalanceFrom >= _amount);
486         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
487         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
488         Transfer(_owner, 0, _amount);
489         return true;
490     }
491 
492 ////////////////
493 // Enable tokens transfers
494 ////////////////
495 
496 
497     /// @notice Enables token holders to transfer their tokens freely if true
498     /// @param _transfersEnabled True if transfers are allowed in the clone
499     function enableTransfers(bool _transfersEnabled) public onlyController {
500         transfersEnabled = _transfersEnabled;
501     }
502 
503 ////////////////
504 // Internal helper functions to query and set a value in a snapshot array
505 ////////////////
506 
507     /// @dev `getValueAt` retrieves the number of tokens at a given block number
508     /// @param checkpoints The history of values being queried
509     /// @param _block The block number to retrieve the value at
510     /// @return The number of tokens being queried
511     function getValueAt(Checkpoint[] storage checkpoints, uint _block
512     ) constant internal returns (uint) {
513         if (checkpoints.length == 0) return 0;
514 
515         // Shortcut for the actual value
516         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
517             return checkpoints[checkpoints.length-1].value;
518         if (_block < checkpoints[0].fromBlock) return 0;
519 
520         // Binary search of the value in the array
521         uint min = 0;
522         uint max = checkpoints.length-1;
523         while (max > min) {
524             uint mid = (max + min + 1)/ 2;
525             if (checkpoints[mid].fromBlock<=_block) {
526                 min = mid;
527             } else {
528                 max = mid-1;
529             }
530         }
531         return checkpoints[min].value;
532     }
533 
534     /// @dev `updateValueAtNow` used to update the `balances` map and the
535     ///  `totalSupplyHistory`
536     /// @param checkpoints The history of data being updated
537     /// @param _value The new number of tokens
538     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
539     ) internal  {
540         if ((checkpoints.length == 0)
541         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
542                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
543                newCheckPoint.fromBlock =  uint128(block.number);
544                newCheckPoint.value = uint128(_value);
545            } else {
546                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
547                oldCheckPoint.value = uint128(_value);
548            }
549     }
550 
551     /// @dev Internal function to determine if an address is a contract
552     /// @param _addr The address being queried
553     /// @return True if `_addr` is a contract
554     function isContract(address _addr) constant internal returns(bool) {
555         uint size;
556         if (_addr == 0) return false;
557         assembly {
558             size := extcodesize(_addr)
559         }
560         return size>0;
561     }
562 
563     /// @dev Helper function to return a min betwen the two uints
564     function min(uint a, uint b) pure internal returns (uint) {
565         return a < b ? a : b;
566     }
567 
568     /// @notice The fallback function: If the contract's controller has not been
569     ///  set to 0, then the `proxyPayment` method is called which relays the
570     ///  ether and creates tokens as described in the token controller contract
571     function () public payable {
572         require(isContract(controller));
573         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
574     }
575 
576 //////////
577 // Safety Methods
578 //////////
579 
580     /// @notice This method can be used by the controller to extract mistakenly
581     ///  sent tokens to this contract.
582     /// @param _token The address of the token contract that you want to recover
583     ///  set to 0 in case you want to extract ether.
584     function claimTokens(address _token) public onlyController {
585         if (_token == 0x0) {
586             controller.transfer(this.balance);
587             return;
588         }
589 
590         MiniMeToken token = MiniMeToken(_token);
591         uint balance = token.balanceOf(this);
592         token.transfer(controller, balance);
593         ClaimedTokens(_token, controller, balance);
594     }
595 
596 ////////////////
597 // Events
598 ////////////////
599     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
600     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
601     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
602     event Approval(
603         address indexed _owner,
604         address indexed _spender,
605         uint256 _amount
606         );
607 
608 }
609 
610 
611 ////////////////
612 // MiniMeTokenFactory
613 ////////////////
614 
615 /// @dev This contract is used to generate clone contracts from a contract.
616 ///  In solidity this is the way to create a contract from a contract of the
617 ///  same class
618 contract MiniMeTokenFactory {
619 
620     /// @notice Update the DApp by creating a new token with new functionalities
621     ///  the msg.sender becomes the controller of this clone token
622     /// @param _parentToken Address of the token being cloned
623     /// @param _snapshotBlock Block of the parent token that will
624     ///  determine the initial distribution of the clone token
625     /// @param _tokenName Name of the new token
626     /// @param _decimalUnits Number of decimals of the new token
627     /// @param _tokenSymbol Token Symbol for the new token
628     /// @param _transfersEnabled If true, tokens will be able to be transferred
629     /// @return The address of the new token contract
630     function createCloneToken(
631         address _parentToken,
632         uint _snapshotBlock,
633         string _tokenName,
634         uint8 _decimalUnits,
635         string _tokenSymbol,
636         bool _transfersEnabled
637     ) public returns (MiniMeToken) {
638         MiniMeToken newToken = new MiniMeToken(
639             this,
640             _parentToken,
641             _snapshotBlock,
642             _tokenName,
643             _decimalUnits,
644             _tokenSymbol,
645             _transfersEnabled
646             );
647 
648         newToken.changeController(msg.sender);
649         return newToken;
650     }
651 }
652 contract LimitedTransferToken is ERC20 {
653   // Checks whether it can transfer or otherwise throws.
654   modifier canTransfer(address _sender, uint _value) {
655    require(_value < transferableTokens(_sender, uint64(now)));
656    _;
657   }
658 
659   // Checks modifier and allows transfer if tokens are not locked.
660   function transfer(address _to, uint _value) canTransfer(msg.sender, _value) returns (bool) {
661    return super.transfer(_to, _value);
662   }
663 
664   // Checks modifier and allows transfer if tokens are not locked.
665   function transferFrom(address _from, address _to, uint _value) canTransfer(_from, _value) returns (bool) {
666    return super.transferFrom(_from, _to, _value);
667   }
668 
669   // Default transferable tokens function returns all tokens for a holder (no limit).
670   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
671     return balanceOf(holder);
672   }
673 }
674 
675 contract VestedToken is LimitedTransferToken, Controlled {
676   using SafeMath for uint;
677 
678   uint256 MAX_GRANTS_PER_ADDRESS = 20;
679 
680   struct TokenGrant {
681     address granter;     // 20 bytes
682     uint256 value;       // 32 bytes
683     uint64 cliff;
684     uint64 vesting;
685     uint64 start;        // 3 * 8 = 24 bytes
686     bool revokable;
687     bool burnsOnRevoke;  // 2 * 1 = 2 bits? or 2 bytes?
688   } // total 78 bytes = 3 sstore per operation (32 per sstore)
689 
690   mapping (address => TokenGrant[]) public grants;
691 
692   event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint256 grantId);
693 
694   /**
695    * @dev Grant tokens to a specified address
696    * @param _to address The address which the tokens will be granted to.
697    * @param _value uint256 The amount of tokens to be granted.
698    * @param _start uint64 Time of the beginning of the grant.
699    * @param _cliff uint64 Time of the cliff period.
700    * @param _vesting uint64 The vesting period.
701    */
702   function grantVestedTokens(
703     address _to,
704     uint256 _value,
705     uint64 _start,
706     uint64 _cliff,
707     uint64 _vesting,
708     bool _revokable,
709     bool _burnsOnRevoke
710   ) onlyController public {
711 
712     // Check for date inconsistencies that may cause unexpected behavior
713     require(_cliff > _start && _vesting > _cliff);
714 
715     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);   // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
716 
717     uint count = grants[_to].push(
718                 TokenGrant(
719                   _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
720                   _value,
721                   _cliff,
722                   _vesting,
723                   _start,
724                   _revokable,
725                   _burnsOnRevoke
726                 )
727               );
728 
729     transfer(_to, _value);
730 
731     NewTokenGrant(msg.sender, _to, _value, count - 1);
732   }
733 
734   /**
735    * @dev Revoke the grant of tokens of a specifed address.
736    * @param _holder The address which will have its tokens revoked.
737    * @param _grantId The id of the token grant.
738    */
739   function revokeTokenGrant(address _holder, uint _grantId) public {
740     TokenGrant storage grant = grants[_holder][_grantId];
741 
742     require(grant.revokable); // Check if grant was revokable
743     require(grant.granter == msg.sender); // Only granter can revoke it
744     require(_grantId >= grants[_holder].length);
745 
746     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
747 
748     uint256 nonVested = nonVestedTokens(grant, uint64(now));
749 
750     // remove grant from array
751     delete grants[_holder][_grantId];
752     grants[_holder][_grantId] = grants[_holder][grants[_holder].length - 1];
753     grants[_holder].length -= 1;
754 
755     // This will call MiniMe's doTransfer method, so token is transferred according to
756     // MiniMe Token logic
757     doTransfer(_holder, receiver, nonVested);
758 
759     Transfer(_holder, receiver, nonVested);
760   }
761 
762   /**
763    * @dev Revoke all grants of tokens of a specifed address.
764    * @param _holder The address which will have its tokens revoked.
765    */
766     function revokeAllTokenGrants(address _holder) {
767         var grantsCount = tokenGrantsCount(_holder);
768         for (uint i = 0; i < grantsCount; i++) {
769           revokeTokenGrant(_holder, 0);
770         }
771     }
772 
773   /**
774    * @dev Calculate the total amount of transferable tokens of a holder at a given time
775    * @param holder address The address of the holder
776    * @param time uint64 The specific time.
777    * @return An uint representing a holder's total amount of transferable tokens.
778    */
779   function transferableTokens(address holder, uint64 time) constant public returns (uint256) {
780     uint256 grantIndex = tokenGrantsCount(holder);
781 
782     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
783 
784     // Iterate through all the grants the holder has, and add all non-vested tokens
785     uint256 nonVested = 0;
786     for (uint256 i = 0; i < grantIndex; i++) {
787       nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
788     }
789 
790     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
791     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
792 
793     // Return the minimum of how many vested can transfer and other value
794     // in case there are other limiting transferability factors (default is balanceOf)
795     return SafeMath.min256(vestedTransferable, super.transferableTokens(holder, time));
796   }
797 
798   /**
799    * @dev Check the amount of grants that an address has.
800    * @param _holder The holder of the grants.
801    * @return A uint representing the total amount of grants.
802    */
803   function tokenGrantsCount(address _holder) constant returns (uint index) {
804     return grants[_holder].length;
805   }
806 
807   /**
808    * @dev Calculate amount of vested tokens at a specifc time.
809    * @param tokens uint256 The amount of tokens grantted.
810    * @param time uint64 The time to be checked
811    * @param start uint64 A time representing the begining of the grant
812    * @param cliff uint64 The cliff period.
813    * @param vesting uint64 The vesting period.
814    * @return An uint representing the amount of vested tokensof a specif grant.
815    *  transferableTokens
816    *   |                         _/--------   vestedTokens rect
817    *   |                       _/
818    *   |                     _/
819    *   |                   _/
820    *   |                 _/
821    *   |                /
822    *   |              .|
823    *   |            .  |
824    *   |          .    |
825    *   |        .      |
826    *   |      .        |
827    *   |    .          |
828    *   +===+===========+---------+----------> time
829    *      Start       Clift    Vesting
830    */
831   function calculateVestedTokens(
832     uint256 tokens,
833     uint256 time,
834     uint256 start,
835     uint256 cliff,
836     uint256 vesting) constant returns (uint256)
837     {
838       // Shortcuts for before cliff and after vesting cases.
839       if (time < cliff) return 0;
840       if (time >= vesting) return tokens;
841 
842       // Interpolate all vested tokens.
843       // As before cliff the shortcut returns 0, we can use just calculate a value
844       // in the vesting rect (as shown in above's figure)
845 
846       // vestedTokens = tokens * (time - start) / (vesting - start)
847       uint256 vestedTokens = SafeMath.div(
848                                     SafeMath.mul(
849                                       tokens,
850                                       SafeMath.sub(time, start)
851                                       ),
852                                     SafeMath.sub(vesting, start)
853                                     );
854 
855       return vestedTokens;
856   }
857 
858   /**
859    * @dev Get all information about a specifc grant.
860    * @param _holder The address which will have its tokens revoked.
861    * @param _grantId The id of the token grant.
862    * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
863    * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
864    */
865   function tokenGrant(address _holder, uint _grantId) constant returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
866     TokenGrant storage grant = grants[_holder][_grantId];
867 
868     granter = grant.granter;
869     value = grant.value;
870     start = grant.start;
871     cliff = grant.cliff;
872     vesting = grant.vesting;
873     revokable = grant.revokable;
874     burnsOnRevoke = grant.burnsOnRevoke;
875 
876     vested = vestedTokens(grant, uint64(now));
877   }
878 
879   /**
880    * @dev Get the amount of vested tokens at a specific time.
881    * @param grant TokenGrant The grant to be checked.
882    * @param time The time to be checked
883    * @return An uint representing the amount of vested tokens of a specific grant at a specific time.
884    */
885   function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
886     return calculateVestedTokens(
887       grant.value,
888       uint256(time),
889       uint256(grant.start),
890       uint256(grant.cliff),
891       uint256(grant.vesting)
892     );
893   }
894 
895   /**
896    * @dev Calculate the amount of non vested tokens at a specific time.
897    * @param grant TokenGrant The grant to be checked.
898    * @param time uint64 The time to be checked
899    * @return An uint representing the amount of non vested tokens of a specifc grant on the
900    * passed time frame.
901    */
902   function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
903     return grant.value.sub(vestedTokens(grant, time));
904   }
905 
906   /**
907    * @dev Calculate the date when the holder can trasfer all its tokens
908    * @param holder address The address of the holder
909    * @return An uint representing the date of the last transferable tokens.
910    */
911   function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
912     date = uint64(now);
913     uint256 grantIndex = grants[holder].length;
914     for (uint256 i = 0; i < grantIndex; i++) {
915       date = SafeMath.max64(grants[holder][i].vesting, date);
916     }
917   }
918 }
919 
920 contract AywakeToken is MiniMeToken {
921      function AywakeToken (address _controller, address _tokenFactory)
922         MiniMeToken(
923             _tokenFactory,
924             0x0,                        // no parent token
925             0,                          // no snapshot block number from parent
926             "AywakeToken",              // Token name
927             18,                         // Decimals
928             "AWK",                      // Symbol
929             true                        // Enable transfers
930             )
931     {
932         changeController(_controller);
933     }
934 }