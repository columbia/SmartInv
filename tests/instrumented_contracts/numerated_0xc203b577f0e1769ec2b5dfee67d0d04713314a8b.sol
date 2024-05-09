1 pragma solidity 0.4.15;
2 
3 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
4 ///  later changed
5 contract Owned {
6 
7     /// @dev `owner` is the only address that can call a function with this
8     /// modifier
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13 
14     address public owner;
15 
16     /// @notice The Constructor assigns the message sender to be `owner`
17     function Owned() {
18         owner = msg.sender;
19     }
20 
21     address public newOwner;
22 
23     /// @notice `owner` can step down and assign some other address to this role
24     /// @param _newOwner The address of the new owner. 0x0 can be used to create
25     function changeOwner(address _newOwner) onlyOwner {
26         if(msg.sender == owner) {
27             owner = _newOwner;
28         }
29     }
30 }
31 
32 
33 /**
34  * Math operations with safety checks
35  */
36 library SafeMath {
37   function mul(uint a, uint b) internal returns (uint) {
38     uint c = a * b;
39     assert(a == 0 || c / a == b);
40     return c;
41   }
42 
43   function div(uint a, uint b) internal returns (uint) {
44     // assert(b > 0); // Solidity automatically throws when dividing by 0
45     uint c = a / b;
46     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47     return c;
48   }
49 
50   function sub(uint a, uint b) internal returns (uint) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   function add(uint a, uint b) internal returns (uint) {
56     uint c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 
61   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
62     return a >= b ? a : b;
63   }
64 
65   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
66     return a < b ? a : b;
67   }
68 
69   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
70     return a >= b ? a : b;
71   }
72 
73   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
74     return a < b ? a : b;
75   }
76 }
77 
78 /// @title Vesting trustee
79 contract Trustee is Owned {
80     using SafeMath for uint256;
81 
82     // The address of the SHP ERC20 token.
83     SHP public shp;
84 
85     struct Grant {
86         uint256 value;
87         uint256 start;
88         uint256 cliff;
89         uint256 end;
90         uint256 transferred;
91         bool revokable;
92     }
93 
94     // Grants holder.
95     mapping (address => Grant) public grants;
96 
97     // Total tokens available for vesting.
98     uint256 public totalVesting;
99 
100     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
101     event UnlockGrant(address indexed _holder, uint256 _value);
102     event RevokeGrant(address indexed _holder, uint256 _refund);
103 
104     /// @dev Constructor that initializes the address of the SHP contract.
105     /// @param _shp SHP The address of the previously deployed SHP smart contract.
106     function Trustee(SHP _shp) {
107         require(_shp != address(0));
108         shp = _shp;
109     }
110 
111     /// @dev Grant tokens to a specified address.
112     /// @param _to address The address to grant tokens to.
113     /// @param _value uint256 The amount of tokens to be granted.
114     /// @param _start uint256 The beginning of the vesting period.
115     /// @param _cliff uint256 Duration of the cliff period.
116     /// @param _end uint256 The end of the vesting period.
117     /// @param _revokable bool Whether the grant is revokable or not.
118     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
119         public onlyOwner {
120         require(_to != address(0));
121         require(_value > 0);
122 
123         // Make sure that a single address can be granted tokens only once.
124         require(grants[_to].value == 0);
125 
126         // Check for date inconsistencies that may cause unexpected behavior.
127         require(_start <= _cliff && _cliff <= _end);
128 
129         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
130         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
131 
132         // Assign a new grant.
133         grants[_to] = Grant({
134             value: _value,
135             start: _start,
136             cliff: _cliff,
137             end: _end,
138             transferred: 0,
139             revokable: _revokable
140         });
141 
142         // Tokens granted, reduce the total amount available for vesting.
143         totalVesting = totalVesting.add(_value);
144 
145         NewGrant(msg.sender, _to, _value);
146     }
147 
148     /// @dev Revoke the grant of tokens of a specifed address.
149     /// @param _holder The address which will have its tokens revoked.
150     function revoke(address _holder) public onlyOwner {
151         Grant grant = grants[_holder];
152 
153         require(grant.revokable);
154 
155         // Send the remaining SHP back to the owner.
156         uint256 refund = grant.value.sub(grant.transferred);
157 
158         // Remove the grant.
159         delete grants[_holder];
160 
161         totalVesting = totalVesting.sub(refund);
162         shp.transfer(msg.sender, refund);
163 
164         RevokeGrant(_holder, refund);
165     }
166 
167     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
168     /// @param _holder address The address of the holder.
169     /// @param _time uint256 The specific time.
170     /// @return a uint256 representing a holder's total amount of vested tokens.
171     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
172         Grant grant = grants[_holder];
173         if (grant.value == 0) {
174             return 0;
175         }
176 
177         return calculateVestedTokens(grant, _time);
178     }
179 
180     /// @dev Calculate amount of vested tokens at a specifc time.
181     /// @param _grant Grant The vesting grant.
182     /// @param _time uint256 The time to be checked
183     /// @return An uint256 representing the amount of vested tokens of a specific grant.
184     ///   |                         _/--------   vestedTokens rect
185     ///   |                       _/
186     ///   |                     _/
187     ///   |                   _/
188     ///   |                 _/
189     ///   |                /
190     ///   |              .|
191     ///   |            .  |
192     ///   |          .    |
193     ///   |        .      |
194     ///   |      .        |
195     ///   |    .          |
196     ///   +===+===========+---------+----------> time
197     ///     Start       Cliff      End
198     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
199         // If we're before the cliff, then nothing is vested.
200         if (_time < _grant.cliff) {
201             return 0;
202         }
203 
204         // If we're after the end of the vesting period - everything is vested;
205         if (_time >= _grant.end) {
206             return _grant.value;
207         }
208 
209         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
210          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
211     }
212 
213     /// @dev Unlock vested tokens and transfer them to their holder.
214     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
215     function unlockVestedTokens() public {
216         Grant grant = grants[msg.sender];
217         require(grant.value != 0);
218 
219         // Get the total amount of vested tokens, acccording to grant.
220         uint256 vested = calculateVestedTokens(grant, now);
221         if (vested == 0) {
222             return;
223         }
224 
225         // Make sure the holder doesn't transfer more than what he already has.
226         uint256 transferable = vested.sub(grant.transferred);
227         if (transferable == 0) {
228             return;
229         }
230 
231         grant.transferred = grant.transferred.add(transferable);
232         totalVesting = totalVesting.sub(transferable);
233         shp.transfer(msg.sender, transferable);
234 
235         UnlockGrant(msg.sender, transferable);
236     }
237 }
238 
239 /// @dev The token controller contract must implement these functions
240 contract TokenController {
241     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
242     /// @param _owner The address that sent the ether to create tokens
243     /// @return True if the ether is accepted, false if it throws
244     function proxyPayment(address _owner) payable returns(bool);
245 
246     /// @notice Notifies the controller about a token transfer allowing the
247     ///  controller to react if desired
248     /// @param _from The origin of the transfer
249     /// @param _to The destination of the transfer
250     /// @param _amount The amount of the transfer
251     /// @return False if the controller does not authorize the transfer
252     function onTransfer(address _from, address _to, uint _amount) returns(bool);
253 
254     /// @notice Notifies the controller about an approval allowing the
255     ///  controller to react if desired
256     /// @param _owner The address that calls `approve()`
257     /// @param _spender The spender in the `approve()` call
258     /// @param _amount The amount in the `approve()` call
259     /// @return False if the controller does not authorize the approval
260     function onApprove(address _owner, address _spender, uint _amount)
261         returns(bool);
262 }
263 
264 contract Controlled {
265     /// @notice The address of the controller is the only address that can call
266     ///  a function with this modifier
267     modifier onlyController { require(msg.sender == controller); _; }
268 
269     address public controller;
270 
271     function Controlled() { controller = msg.sender;}
272 
273     /// @notice Changes the controller of the contract
274     /// @param _newController The new controller of the contract
275     function changeController(address _newController) onlyController {
276         controller = _newController;
277     }
278 }
279 
280 contract ApproveAndCallFallBack {
281     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
282 }
283 
284 /// @dev The actual token contract, the default controller is the msg.sender
285 ///  that deploys the contract, so usually this token will be deployed by a
286 ///  token controller contract, which Giveth will call a "Campaign"
287 contract MiniMeToken is Controlled {
288 
289     string public name;                //The Token's name: e.g. DigixDAO Tokens
290     uint8 public decimals;             //Number of decimals of the smallest unit
291     string public symbol;              //An identifier: e.g. REP
292     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
293 
294 
295     /// @dev `Checkpoint` is the structure that attaches a block number to a
296     ///  given value, the block number attached is the one that last changed the
297     ///  value
298     struct  Checkpoint {
299 
300         // `fromBlock` is the block number that the value was generated from
301         uint128 fromBlock;
302 
303         // `value` is the amount of tokens at a specific block number
304         uint128 value;
305     }
306 
307     // `parentToken` is the Token address that was cloned to produce this token;
308     //  it will be 0x0 for a token that was not cloned
309     MiniMeToken public parentToken;
310 
311     // `parentSnapShotBlock` is the block number from the Parent Token that was
312     //  used to determine the initial distribution of the Clone Token
313     uint public parentSnapShotBlock;
314 
315     // `creationBlock` is the block number that the Clone Token was created
316     uint public creationBlock;
317 
318     // `balances` is the map that tracks the balance of each address, in this
319     //  contract when the balance changes the block number that the change
320     //  occurred is also included in the map
321     mapping (address => Checkpoint[]) balances;
322 
323     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
324     mapping (address => mapping (address => uint256)) allowed;
325 
326     // Tracks the history of the `totalSupply` of the token
327     Checkpoint[] totalSupplyHistory;
328 
329     // Flag that determines if the token is transferable or not.
330     bool public transfersEnabled;
331 
332     // The factory used to create new clone tokens
333     MiniMeTokenFactory public tokenFactory;
334 
335 ////////////////
336 // Constructor
337 ////////////////
338 
339     /// @notice Constructor to create a MiniMeToken
340     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
341     ///  will create the Clone token contracts, the token factory needs to be
342     ///  deployed first
343     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
344     ///  new token
345     /// @param _parentSnapShotBlock Block of the parent token that will
346     ///  determine the initial distribution of the clone token, set to 0 if it
347     ///  is a new token
348     /// @param _tokenName Name of the new token
349     /// @param _decimalUnits Number of decimals of the new token
350     /// @param _tokenSymbol Token Symbol for the new token
351     /// @param _transfersEnabled If true, tokens will be able to be transferred
352     function MiniMeToken(
353         address _tokenFactory,
354         address _parentToken,
355         uint _parentSnapShotBlock,
356         string _tokenName,
357         uint8 _decimalUnits,
358         string _tokenSymbol,
359         bool _transfersEnabled
360     ) {
361         tokenFactory = MiniMeTokenFactory(_tokenFactory);
362         name = _tokenName;                                 // Set the name
363         decimals = _decimalUnits;                          // Set the decimals
364         symbol = _tokenSymbol;                             // Set the symbol
365         parentToken = MiniMeToken(_parentToken);
366         parentSnapShotBlock = _parentSnapShotBlock;
367         transfersEnabled = _transfersEnabled;
368         creationBlock = block.number;
369     }
370 
371 
372 ///////////////////
373 // ERC20 Methods
374 ///////////////////
375 
376     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
377     /// @param _to The address of the recipient
378     /// @param _amount The amount of tokens to be transferred
379     /// @return Whether the transfer was successful or not
380     function transfer(address _to, uint256 _amount) returns (bool success) {
381         require(transfersEnabled);
382         return doTransfer(msg.sender, _to, _amount);
383     }
384 
385     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
386     ///  is approved by `_from`
387     /// @param _from The address holding the tokens being transferred
388     /// @param _to The address of the recipient
389     /// @param _amount The amount of tokens to be transferred
390     /// @return True if the transfer was successful
391     function transferFrom(address _from, address _to, uint256 _amount
392     ) returns (bool success) {
393 
394         // The controller of this contract can move tokens around at will,
395         //  this is important to recognize! Confirm that you trust the
396         //  controller of this contract, which in most situations should be
397         //  another open source smart contract or 0x0
398         if (msg.sender != controller) {
399             require(transfersEnabled);
400 
401             // The standard ERC 20 transferFrom functionality
402             if (allowed[_from][msg.sender] < _amount) return false;
403             allowed[_from][msg.sender] -= _amount;
404         }
405         return doTransfer(_from, _to, _amount);
406     }
407 
408     /// @dev This is the actual transfer function in the token contract, it can
409     ///  only be called by other functions in this contract.
410     /// @param _from The address holding the tokens being transferred
411     /// @param _to The address of the recipient
412     /// @param _amount The amount of tokens to be transferred
413     /// @return True if the transfer was successful
414     function doTransfer(address _from, address _to, uint _amount
415     ) internal returns(bool) {
416 
417            if (_amount == 0) {
418                return true;
419            }
420 
421            require(parentSnapShotBlock < block.number);
422 
423            // Do not allow transfer to 0x0 or the token contract itself
424            require((_to != 0) && (_to != address(this)));
425 
426            // If the amount being transfered is more than the balance of the
427            //  account the transfer returns false
428            var previousBalanceFrom = balanceOfAt(_from, block.number);
429            if (previousBalanceFrom < _amount) {
430                return false;
431            }
432 
433            // Alerts the token controller of the transfer
434            if (isContract(controller)) {
435                require(TokenController(controller).onTransfer(_from, _to, _amount));
436            }
437 
438            // First update the balance array with the new value for the address
439            //  sending the tokens
440            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
441 
442            // Then update the balance array with the new value for the address
443            //  receiving the tokens
444            var previousBalanceTo = balanceOfAt(_to, block.number);
445            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
446            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
447 
448            // An event to make the transfer easy to find on the blockchain
449            Transfer(_from, _to, _amount);
450 
451            return true;
452     }
453 
454     /// @param _owner The address that's balance is being requested
455     /// @return The balance of `_owner` at the current block
456     function balanceOf(address _owner) constant returns (uint256 balance) {
457         return balanceOfAt(_owner, block.number);
458     }
459 
460     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
461     ///  its behalf. This is a modified version of the ERC20 approve function
462     ///  to be a little bit safer
463     /// @param _spender The address of the account able to transfer the tokens
464     /// @param _amount The amount of tokens to be approved for transfer
465     /// @return True if the approval was successful
466     function approve(address _spender, uint256 _amount) returns (bool success) {
467         require(transfersEnabled);
468 
469         // To change the approve amount you first have to reduce the addresses`
470         //  allowance to zero by calling `approve(_spender,0)` if it is not
471         //  already 0 to mitigate the race condition described here:
472         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
473         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
474 
475         // Alerts the token controller of the approve function call
476         if (isContract(controller)) {
477             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
478         }
479 
480         allowed[msg.sender][_spender] = _amount;
481         Approval(msg.sender, _spender, _amount);
482         return true;
483     }
484 
485     /// @dev This function makes it easy to read the `allowed[]` map
486     /// @param _owner The address of the account that owns the token
487     /// @param _spender The address of the account able to transfer the tokens
488     /// @return Amount of remaining tokens of _owner that _spender is allowed
489     ///  to spend
490     function allowance(address _owner, address _spender
491     ) constant returns (uint256 remaining) {
492         return allowed[_owner][_spender];
493     }
494 
495     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
496     ///  its behalf, and then a function is triggered in the contract that is
497     ///  being approved, `_spender`. This allows users to use their tokens to
498     ///  interact with contracts in one function call instead of two
499     /// @param _spender The address of the contract able to transfer the tokens
500     /// @param _amount The amount of tokens to be approved for transfer
501     /// @return True if the function call was successful
502     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
503     ) returns (bool success) {
504         require(approve(_spender, _amount));
505 
506         ApproveAndCallFallBack(_spender).receiveApproval(
507             msg.sender,
508             _amount,
509             this,
510             _extraData
511         );
512 
513         return true;
514     }
515 
516     /// @dev This function makes it easy to get the total number of tokens
517     /// @return The total number of tokens
518     function totalSupply() constant returns (uint) {
519         return totalSupplyAt(block.number);
520     }
521 
522 
523 ////////////////
524 // Query balance and totalSupply in History
525 ////////////////
526 
527     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
528     /// @param _owner The address from which the balance will be retrieved
529     /// @param _blockNumber The block number when the balance is queried
530     /// @return The balance at `_blockNumber`
531     function balanceOfAt(address _owner, uint _blockNumber) constant
532         returns (uint) {
533 
534         // These next few lines are used when the balance of the token is
535         //  requested before a check point was ever created for this token, it
536         //  requires that the `parentToken.balanceOfAt` be queried at the
537         //  genesis block for that token as this contains initial balance of
538         //  this token
539         if ((balances[_owner].length == 0)
540             || (balances[_owner][0].fromBlock > _blockNumber)) {
541             if (address(parentToken) != 0) {
542                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
543             } else {
544                 // Has no parent
545                 return 0;
546             }
547 
548         // This will return the expected balance during normal situations
549         } else {
550             return getValueAt(balances[_owner], _blockNumber);
551         }
552     }
553 
554     /// @notice Total amount of tokens at a specific `_blockNumber`.
555     /// @param _blockNumber The block number when the totalSupply is queried
556     /// @return The total amount of tokens at `_blockNumber`
557     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
558 
559         // These next few lines are used when the totalSupply of the token is
560         //  requested before a check point was ever created for this token, it
561         //  requires that the `parentToken.totalSupplyAt` be queried at the
562         //  genesis block for this token as that contains totalSupply of this
563         //  token at this block number.
564         if ((totalSupplyHistory.length == 0)
565             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
566             if (address(parentToken) != 0) {
567                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
568             } else {
569                 return 0;
570             }
571 
572         // This will return the expected totalSupply during normal situations
573         } else {
574             return getValueAt(totalSupplyHistory, _blockNumber);
575         }
576     }
577 
578 ////////////////
579 // Clone Token Method
580 ////////////////
581 
582     /// @notice Creates a new clone token with the initial distribution being
583     ///  this token at `_snapshotBlock`
584     /// @param _cloneTokenName Name of the clone token
585     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
586     /// @param _cloneTokenSymbol Symbol of the clone token
587     /// @param _snapshotBlock Block when the distribution of the parent token is
588     ///  copied to set the initial distribution of the new clone token;
589     ///  if the block is zero than the actual block, the current block is used
590     /// @param _transfersEnabled True if transfers are allowed in the clone
591     /// @return The address of the new MiniMeToken Contract
592     function createCloneToken(
593         string _cloneTokenName,
594         uint8 _cloneDecimalUnits,
595         string _cloneTokenSymbol,
596         uint _snapshotBlock,
597         bool _transfersEnabled
598         ) returns(address) {
599         if (_snapshotBlock == 0) _snapshotBlock = block.number;
600         MiniMeToken cloneToken = tokenFactory.createCloneToken(
601             this,
602             _snapshotBlock,
603             _cloneTokenName,
604             _cloneDecimalUnits,
605             _cloneTokenSymbol,
606             _transfersEnabled
607             );
608 
609         cloneToken.changeController(msg.sender);
610 
611         // An event to make the token easy to find on the blockchain
612         NewCloneToken(address(cloneToken), _snapshotBlock);
613         return address(cloneToken);
614     }
615 
616 ////////////////
617 // Generate and destroy tokens
618 ////////////////
619 
620     /// @notice Generates `_amount` tokens that are assigned to `_owner`
621     /// @param _owner The address that will be assigned the new tokens
622     /// @param _amount The quantity of tokens generated
623     /// @return True if the tokens are generated correctly
624     function generateTokens(address _owner, uint _amount
625     ) onlyController returns (bool) {
626         uint curTotalSupply = totalSupply();
627         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
628         uint previousBalanceTo = balanceOf(_owner);
629         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
630         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
631         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
632         Transfer(0, _owner, _amount);
633         return true;
634     }
635 
636 
637     /// @notice Burns `_amount` tokens from `_owner`
638     /// @param _owner The address that will lose the tokens
639     /// @param _amount The quantity of tokens to burn
640     /// @return True if the tokens are burned correctly
641     function destroyTokens(address _owner, uint _amount
642     ) onlyController returns (bool) {
643         uint curTotalSupply = totalSupply();
644         require(curTotalSupply >= _amount);
645         uint previousBalanceFrom = balanceOf(_owner);
646         require(previousBalanceFrom >= _amount);
647         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
648         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
649         Transfer(_owner, 0, _amount);
650         return true;
651     }
652 
653 ////////////////
654 // Enable tokens transfers
655 ////////////////
656 
657 
658     /// @notice Enables token holders to transfer their tokens freely if true
659     /// @param _transfersEnabled True if transfers are allowed in the clone
660     function enableTransfers(bool _transfersEnabled) onlyController {
661         transfersEnabled = _transfersEnabled;
662     }
663 
664 ////////////////
665 // Internal helper functions to query and set a value in a snapshot array
666 ////////////////
667 
668     /// @dev `getValueAt` retrieves the number of tokens at a given block number
669     /// @param checkpoints The history of values being queried
670     /// @param _block The block number to retrieve the value at
671     /// @return The number of tokens being queried
672     function getValueAt(Checkpoint[] storage checkpoints, uint _block
673     ) constant internal returns (uint) {
674         if (checkpoints.length == 0) return 0;
675 
676         // Shortcut for the actual value
677         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
678             return checkpoints[checkpoints.length-1].value;
679         if (_block < checkpoints[0].fromBlock) return 0;
680 
681         // Binary search of the value in the array
682         uint min = 0;
683         uint max = checkpoints.length-1;
684         while (max > min) {
685             uint mid = (max + min + 1)/ 2;
686             if (checkpoints[mid].fromBlock<=_block) {
687                 min = mid;
688             } else {
689                 max = mid-1;
690             }
691         }
692         return checkpoints[min].value;
693     }
694 
695     /// @dev `updateValueAtNow` used to update the `balances` map and the
696     ///  `totalSupplyHistory`
697     /// @param checkpoints The history of data being updated
698     /// @param _value The new number of tokens
699     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
700     ) internal  {
701         if ((checkpoints.length == 0)
702         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
703                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
704                newCheckPoint.fromBlock =  uint128(block.number);
705                newCheckPoint.value = uint128(_value);
706            } else {
707                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
708                oldCheckPoint.value = uint128(_value);
709            }
710     }
711 
712     /// @dev Internal function to determine if an address is a contract
713     /// @param _addr The address being queried
714     /// @return True if `_addr` is a contract
715     function isContract(address _addr) constant internal returns(bool) {
716         uint size;
717         if (_addr == 0) return false;
718         assembly {
719             size := extcodesize(_addr)
720         }
721         return size>0;
722     }
723 
724     /// @dev Helper function to return a min betwen the two uints
725     function min(uint a, uint b) internal returns (uint) {
726         return a < b ? a : b;
727     }
728 
729     /// @notice The fallback function: If the contract's controller has not been
730     ///  set to 0, then the `proxyPayment` method is called which relays the
731     ///  ether and creates tokens as described in the token controller contract
732     function ()  payable {
733         require(isContract(controller));
734         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
735     }
736 
737 //////////
738 // Safety Methods
739 //////////
740 
741     /// @notice This method can be used by the controller to extract mistakenly
742     ///  sent tokens to this contract.
743     /// @param _token The address of the token contract that you want to recover
744     ///  set to 0 in case you want to extract ether.
745     function claimTokens(address _token) onlyController {
746         if (_token == 0x0) {
747             controller.transfer(this.balance);
748             return;
749         }
750 
751         MiniMeToken token = MiniMeToken(_token);
752         uint balance = token.balanceOf(this);
753         token.transfer(controller, balance);
754         ClaimedTokens(_token, controller, balance);
755     }
756 
757 ////////////////
758 // Events
759 ////////////////
760     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
761     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
762     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
763     event Approval(
764         address indexed _owner,
765         address indexed _spender,
766         uint256 _amount
767         );
768 
769 }
770 
771 
772 ////////////////
773 // MiniMeTokenFactory
774 ////////////////
775 
776 /// @dev This contract is used to generate clone contracts from a contract.
777 ///  In solidity this is the way to create a contract from a contract of the
778 ///  same class
779 contract MiniMeTokenFactory {
780 
781     /// @notice Update the DApp by creating a new token with new functionalities
782     ///  the msg.sender becomes the controller of this clone token
783     /// @param _parentToken Address of the token being cloned
784     /// @param _snapshotBlock Block of the parent token that will
785     ///  determine the initial distribution of the clone token
786     /// @param _tokenName Name of the new token
787     /// @param _decimalUnits Number of decimals of the new token
788     /// @param _tokenSymbol Token Symbol for the new token
789     /// @param _transfersEnabled If true, tokens will be able to be transferred
790     /// @return The address of the new token contract
791     function createCloneToken(
792         address _parentToken,
793         uint _snapshotBlock,
794         string _tokenName,
795         uint8 _decimalUnits,
796         string _tokenSymbol,
797         bool _transfersEnabled
798     ) returns (MiniMeToken) 
799     {
800         MiniMeToken newToken = new MiniMeToken(
801             this,
802             _parentToken,
803             _snapshotBlock,
804             _tokenName,
805             _decimalUnits,
806             _tokenSymbol,
807             _transfersEnabled
808             );
809 
810         newToken.changeController(msg.sender);
811         return newToken;
812     }
813 }
814 
815 contract SHP is MiniMeToken {
816     // @dev SHP constructor
817     function SHP(address _tokenFactory)
818             MiniMeToken(
819                 _tokenFactory,
820                 0x0,                             // no parent token
821                 0,                               // no snapshot block number from parent
822                 "Sharpe Platform Token",         // Token name
823                 18,                              // Decimals
824                 "SHP",                           // Symbol
825                 true                             // Enable transfers
826             ) {}
827 }
828 
829 contract AffiliateUtility is Owned {
830     using SafeMath for uint256;
831     
832     uint256 public tierTwoMin;
833     uint256 public tierThreeMin;
834 
835     uint256 public constant TIER1_PERCENT = 3;
836     uint256 public constant TIER2_PERCENT = 4;
837     uint256 public constant TIER3_PERCENT = 5;
838     
839     mapping (address => Affiliate) private affiliates;
840 
841     event AffiliateReceived(address affiliateAddress, address investorAddress, bool valid);
842 
843     struct Affiliate {
844         address etherAddress;
845         bool isPresent;
846     }
847 
848     function AffiliateUtility(uint256 _tierTwoMin, uint256 _tierThreeMin) {
849         setTiers(_tierTwoMin, _tierThreeMin);
850     }
851 
852     /// @notice sets the Ether to Dollar exhchange rate
853     /// @param _tierTwoMin the tier 2 min (in WEI)
854     /// @param _tierThreeMin the tier 3 min (in WEI)
855     function setTiers(uint256 _tierTwoMin, uint256 _tierThreeMin) onlyOwner {
856         tierTwoMin = _tierTwoMin;
857         tierThreeMin = _tierThreeMin;
858     }
859 
860     /// @notice This adds an affiliate Ethereum address to our whitelist
861     /// @param _investor The investor's address
862     /// @param _affiliate The Ethereum address of the affiliate
863     function addAffiliate(address _investor, address _affiliate) onlyOwner {
864         affiliates[_investor] = Affiliate(_affiliate, true);
865     }
866 
867     /// @notice calculates and returns the amount to token minted for affilliate
868     /// @param _investor address of the investor
869     /// @param _contributorTokens amount of SHP tokens minted for contributor
870     /// @param _contributionValue amount of ETH contributed
871     /// @return tuple of two values (affiliateBonus, contributorBouns)
872     function applyAffiliate(
873         address _investor, 
874         uint256 _contributorTokens, 
875         uint256 _contributionValue
876     )
877         public 
878         returns(uint256, uint256) 
879     {
880         if (getAffiliate(_investor) == address(0)) {
881             return (0, 0);
882         }
883 
884         uint256 contributorBonus = _contributorTokens.div(100);
885         uint256 affiliateBonus = 0;
886 
887         if (_contributionValue < tierTwoMin) {
888             affiliateBonus = _contributorTokens.mul(TIER1_PERCENT).div(100);
889         } else if (_contributionValue >= tierTwoMin && _contributionValue < tierThreeMin) {
890             affiliateBonus = _contributorTokens.mul(TIER2_PERCENT).div(100);
891         } else {
892             affiliateBonus = _contributorTokens.mul(TIER3_PERCENT).div(100);
893         }
894 
895         return(affiliateBonus, contributorBonus);
896     }
897 
898     /// @notice Fetches the Ethereum address of a valid affiliate
899     /// @param _investor The Ethereum address of the investor
900     /// @return The Ethereum address as an address type
901     function getAffiliate(address _investor) constant returns(address) {
902         return affiliates[_investor].etherAddress;
903     }
904 
905     /// @notice Checks if an affiliate is valid
906     /// @param _investor The Ethereum address of the investor
907     /// @return True or False
908     function isAffiliateValid(address _investor) constant public returns(bool) {
909         Affiliate memory affiliate = affiliates[_investor];
910         AffiliateReceived(affiliate.etherAddress, _investor, affiliate.isPresent);
911         return affiliate.isPresent;
912     }
913 }
914 
915 contract SCD is MiniMeToken {
916     // @dev SCD constructor
917     function SCD(address _tokenFactory)
918             MiniMeToken(
919                 _tokenFactory,
920                 0x0,                             // no parent token
921                 0,                               // no snapshot block number from parent
922                 "Sharpe Crypto-Derivative",      // Token name
923                 18,                              // Decimals
924                 "SCD",                           // Symbol
925                 true                             // Enable transfers
926             ) {}
927 }
928 
929 
930 contract TokenSale is Owned, TokenController {
931     using SafeMath for uint256;
932     
933     SHP public shp;
934     AffiliateUtility public affiliateUtility;
935     Trustee public trustee;
936 
937     address public etherEscrowAddress;
938     address public bountyAddress;
939     address public trusteeAddress;
940     address public apiAddress;
941 
942     uint256 public founderTokenCount = 0;
943     uint256 public reserveTokenCount = 0;
944 
945     uint256 constant public CALLER_EXCHANGE_RATE = 2000;
946     uint256 constant public RESERVE_EXCHANGE_RATE = 1500;
947     uint256 constant public FOUNDER_EXCHANGE_RATE = 1000;
948     uint256 constant public BOUNTY_EXCHANGE_RATE = 500;
949     uint256 constant public MAX_GAS_PRICE = 50000000000;
950 
951     bool public paused;
952     bool public closed;
953 
954     mapping(address => bool) public approvedAddresses;
955 
956     event Contribution(uint256 etherAmount, address _caller);
957     event NewSale(address indexed caller, uint256 etherAmount, uint256 tokensGenerated);
958     event SaleClosed(uint256 when);
959     
960     modifier notPaused() {
961         require(!paused);
962         _;
963     }
964 
965     modifier notClosed() {
966         require(!closed);
967         _;
968     }
969 
970     modifier onlyApi() {
971         require(msg.sender == apiAddress);
972         _;
973     }
974 
975     modifier isValidated() {
976         require(msg.sender != 0x0);
977         require(msg.value > 0);
978         require(!isContract(msg.sender)); 
979         require(tx.gasprice <= MAX_GAS_PRICE);
980         _;
981     }
982 
983     modifier isApproved() {
984         require(approvedAddresses[msg.sender]);
985         _;
986     }
987 
988     /// @notice Adds an approved address for the sale
989     /// @param _addr The address to approve for contribution
990     function approveAddress(address _addr) public onlyApi {
991         approvedAddresses[_addr] = true;
992     }
993 
994     /// @notice This method sends the Ether received to the Ether escrow address
995     /// and generates the calculated number of SHP tokens, sending them to the caller's address.
996     /// It also generates the founder's tokens and the reserve tokens at the same time.
997     function doBuy(
998         address _caller,
999         uint256 etherAmount
1000     )
1001         internal
1002     {
1003 
1004         Contribution(etherAmount, _caller);
1005 
1006         uint256 callerTokens = etherAmount.mul(CALLER_EXCHANGE_RATE);
1007         uint256 callerTokensWithDiscount = applyDiscount(etherAmount, callerTokens);
1008 
1009         uint256 reserveTokens = etherAmount.mul(RESERVE_EXCHANGE_RATE);
1010         uint256 founderTokens = etherAmount.mul(FOUNDER_EXCHANGE_RATE);
1011         uint256 bountyTokens = etherAmount.mul(BOUNTY_EXCHANGE_RATE);
1012         uint256 vestingTokens = founderTokens.add(reserveTokens);
1013 
1014         founderTokenCount = founderTokenCount.add(founderTokens);
1015         reserveTokenCount = reserveTokenCount.add(reserveTokens);
1016 
1017         payAffiliate(callerTokensWithDiscount, msg.value, msg.sender);
1018 
1019         shp.generateTokens(_caller, callerTokensWithDiscount);
1020         shp.generateTokens(bountyAddress, bountyTokens);
1021         shp.generateTokens(trusteeAddress, vestingTokens);
1022 
1023         NewSale(_caller, etherAmount, callerTokensWithDiscount);
1024         NewSale(trusteeAddress, etherAmount, vestingTokens);
1025         NewSale(bountyAddress, etherAmount, bountyTokens);
1026 
1027         etherEscrowAddress.transfer(etherAmount);
1028         updateCounters(etherAmount);
1029     }
1030 
1031     /// @notice Applies the discount based on the discount tiers
1032     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1033     /// @param _contributorTokens The tokens allocated based on the contribution
1034     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256);
1035 
1036     /// @notice Updates the counters for the amount of Ether paid
1037     /// @param _etherAmount the amount of Ether paid
1038     function updateCounters(uint256 _etherAmount) internal;
1039     
1040     /// @notice Parent constructor. This needs to be extended from the child contracts
1041     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1042     /// @param _bountyAddress the address that will hold the bounty scheme SHP
1043     /// @param _trusteeAddress the address that will hold the vesting SHP
1044     /// @param _affiliateUtilityAddress address of the deployed AffiliateUtility contract.
1045     function TokenSale (
1046         address _etherEscrowAddress,
1047         address _bountyAddress,
1048         address _trusteeAddress,
1049         address _affiliateUtilityAddress,
1050         address _apiAddress
1051     ) {
1052         etherEscrowAddress = _etherEscrowAddress;
1053         bountyAddress = _bountyAddress;
1054         trusteeAddress = _trusteeAddress;
1055         apiAddress = _apiAddress;
1056         affiliateUtility = AffiliateUtility(_affiliateUtilityAddress);
1057         trustee = Trustee(_trusteeAddress);
1058         paused = true;
1059         closed = false;
1060     }
1061 
1062     /// @notice Pays an affiliate if they are valid and present in the transaction data
1063     /// @param _tokens The contribution tokens used to calculate affiliate payment amount
1064     /// @param _etherValue The Ether value sent
1065     /// @param _caller The address of the caller
1066     function payAffiliate(uint256 _tokens, uint256 _etherValue, address _caller) internal {
1067         if (affiliateUtility.isAffiliateValid(_caller)) {
1068             address affiliate = affiliateUtility.getAffiliate(_caller);
1069             var (affiliateBonus, contributorBonus) = affiliateUtility.applyAffiliate(_caller, _tokens, _etherValue);
1070             shp.generateTokens(affiliate, affiliateBonus);
1071             shp.generateTokens(_caller, contributorBonus);
1072         }
1073     }
1074 
1075     /// @notice Sets the SHP token smart contract
1076     /// @param _shp the SHP token contract address
1077     function setShp(address _shp) public onlyOwner {
1078         shp = SHP(_shp);
1079     }
1080 
1081     /// @notice Transfers ownership of the token smart contract and trustee
1082     /// @param _tokenController the address of the new token controller
1083     /// @param _trusteeOwner the address of the new trustee owner
1084     function transferOwnership(address _tokenController, address _trusteeOwner) public onlyOwner {
1085         require(closed);
1086         require(_tokenController != 0x0);
1087         require(_trusteeOwner != 0x0);
1088         shp.changeController(_tokenController);
1089         trustee.changeOwner(_trusteeOwner);
1090     }
1091 
1092     /// @notice Internal function to determine if an address is a contract
1093     /// @param _caller The address being queried
1094     /// @return True if `caller` is a contract
1095     function isContract(address _caller) internal constant returns (bool) {
1096         uint size;
1097         assembly { size := extcodesize(_caller) }
1098         return size > 0;
1099     }
1100 
1101     /// @notice Pauses the contribution if there is any issue
1102     function pauseContribution() public onlyOwner {
1103         paused = true;
1104     }
1105 
1106     /// @notice Resumes the contribution
1107     function resumeContribution() public onlyOwner {
1108         paused = false;
1109     }
1110 
1111     //////////
1112     // MiniMe Controller Interface functions
1113     //////////
1114 
1115     // In between the offering and the network. Default settings for allowing token transfers.
1116     function proxyPayment(address) public payable returns (bool) {
1117         return false;
1118     }
1119 
1120     function onTransfer(address, address, uint256) public returns (bool) {
1121         return false;
1122     }
1123 
1124     function onApprove(address, address, uint256) public returns (bool) {
1125         return false;
1126     }
1127 }
1128 
1129 
1130 contract SharpePresale is TokenSale {
1131     using SafeMath for uint256;
1132  
1133     mapping(address => uint256) public whitelist;
1134     
1135     uint256 public preSaleEtherPaid = 0;
1136     uint256 public totalContributions = 0;
1137     uint256 public whitelistedPlannedContributions = 0;
1138 
1139     uint256 constant public FIRST_TIER_DISCOUNT = 10;
1140     uint256 constant public SECOND_TIER_DISCOUNT = 20;
1141     uint256 constant public THIRD_TIER_DISCOUNT = 30;
1142 
1143     uint256 public minPresaleContributionEther;
1144     uint256 public maxPresaleContributionEther;
1145 
1146     uint256 public firstTierDiscountUpperLimitEther;
1147     uint256 public secondTierDiscountUpperLimitEther;
1148     uint256 public thirdTierDiscountUpperLimitEther;
1149 
1150     uint256 public preSaleCap;
1151     uint256 public honourWhitelistEnd;
1152 
1153     address public presaleAddress;
1154     
1155     enum ContributionState {Paused, Resumed}
1156     event ContributionStateChanged(address caller, ContributionState contributionState);
1157     enum AllowedContributionState {Whitelisted, NotWhitelisted, AboveWhitelisted, BelowWhitelisted, WhitelistClosed}
1158     event AllowedContributionCheck(uint256 contribution, AllowedContributionState allowedContributionState);
1159     event ValidContributionCheck(uint256 contribution, bool isContributionValid);
1160     event DiscountApplied(uint256 etherAmount, uint256 tokens, uint256 discount);
1161     event ContributionRefund(uint256 etherAmount, address _caller);
1162     event CountersUpdated(uint256 preSaleEtherPaid, uint256 totalContributions);
1163     event WhitelistedUpdated(uint256 plannedContribution, bool contributed);
1164     event WhitelistedCounterUpdated(uint256 whitelistedPlannedContributions, uint256 usedContributions);
1165 
1166     modifier isValidContribution() {
1167         require(validContribution());
1168         _;
1169     }
1170 
1171     /// @notice called only once when the contract is initialized
1172     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1173     /// @param _bountyAddress the address that will hold the bounty SHP
1174     /// @param _trusteeAddress the address that will hold the vesting SHP
1175     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1176     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1177     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1178     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1179     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1180     /// @param _preSaleCap Presale cap (WEI)
1181     /// @param _honourWhitelistEnd End time of whitelist period
1182     function SharpePresale(
1183         address _etherEscrowAddress,
1184         address _bountyAddress,
1185         address _trusteeAddress,
1186         address _affiliateUtilityAddress,
1187         address _apiAddress,
1188         uint256 _firstTierDiscountUpperLimitEther,
1189         uint256 _secondTierDiscountUpperLimitEther,
1190         uint256 _thirdTierDiscountUpperLimitEther,
1191         uint256 _minPresaleContributionEther,
1192         uint256 _maxPresaleContributionEther,
1193         uint256 _preSaleCap,
1194         uint256 _honourWhitelistEnd)
1195         TokenSale (
1196             _etherEscrowAddress,
1197             _bountyAddress,
1198             _trusteeAddress,
1199             _affiliateUtilityAddress,
1200             _apiAddress
1201         )
1202     {
1203         honourWhitelistEnd = _honourWhitelistEnd;
1204         presaleAddress = address(this);
1205         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1206         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1207         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1208         minPresaleContributionEther = _minPresaleContributionEther;
1209         maxPresaleContributionEther = _maxPresaleContributionEther;
1210         preSaleCap = _preSaleCap;
1211     }
1212 
1213     /// @notice Adds to the whitelist
1214     /// @param _sender The address to whitelist
1215     /// @param _plannedContribution The planned contribution (WEI)
1216     function addToWhitelist(address _sender, uint256 _plannedContribution) public onlyOwner {
1217         require(whitelist[_sender] == 0);
1218         
1219         whitelist[_sender] = _plannedContribution;
1220         whitelistedPlannedContributions = whitelistedPlannedContributions.add(_plannedContribution);
1221     }
1222 
1223     /// @notice This function fires when someone sends Ether to the address of this contract.
1224     /// The ETH will be exchanged for SHP and it ensures contributions cannot be made from known addresses.
1225     function ()
1226         public
1227         payable
1228         isValidated
1229         notClosed
1230         notPaused
1231         isApproved
1232     {
1233         address caller = msg.sender;
1234         processPreSale(caller);
1235     }
1236 
1237     /// @notice Processes the presale if the allowed contribution is more than zero
1238     /// @param _caller the address sending the Ether
1239     function processPreSale(address _caller) private {
1240         var (allowedContribution, refundAmount) = processContribution();
1241         assert(msg.value==allowedContribution.add(refundAmount));
1242         if (allowedContribution > 0) {
1243             doBuy(_caller, allowedContribution);
1244             if (refundAmount > 0) {
1245                 msg.sender.transfer(refundAmount);
1246                 closePreSale();
1247             }
1248 
1249             // Covering the edge case where the last contribution equals the remaining cap
1250             uint256 tillCap = remainingCap();
1251             if (tillCap == 0) {
1252                 closePreSale();
1253             }
1254 
1255         } else {
1256             revert();
1257         }
1258     }
1259 
1260     /// @notice Returns true if the whitelist period is still active, false otherwise.
1261     /// When whitelist period ends, it will transfer any unclaimed planned contributions to the pre-sale cap. 
1262     function honourWhitelist() private returns (bool) {
1263         bool honourWhitelist = true;
1264         if (honourWhitelistEnd <= now) {
1265             honourWhitelist = false;
1266             preSaleCap = preSaleCap.add(whitelistedPlannedContributions);
1267             whitelistedPlannedContributions = 0;
1268             WhitelistedCounterUpdated(whitelistedPlannedContributions, 0);
1269         }
1270         return honourWhitelist;
1271     }
1272 
1273     /// @notice Returns the contribution to be used as part of the transaction, and any refund value if expected.  
1274     function processContribution() private isValidContribution returns (uint256, uint256) {
1275         var (allowedContribution, refundAmount) = getAllowedContribution();
1276         
1277         if (!honourWhitelist()) {
1278             AllowedContributionCheck(allowedContribution, AllowedContributionState.WhitelistClosed);
1279             return (allowedContribution, refundAmount);
1280         }
1281         
1282         if (whitelist[msg.sender] > 0) {
1283             return processWhitelistedContribution(allowedContribution, refundAmount);
1284         } 
1285 
1286         AllowedContributionCheck(allowedContribution, AllowedContributionState.NotWhitelisted);
1287         return (allowedContribution, refundAmount);
1288     }
1289 
1290     /// @notice Returns the contribution to be used for a sender that had previously been whitelisted, and any refund value if expected.
1291     function processWhitelistedContribution(uint256 allowedContribution, uint256 refundAmount) private returns (uint256, uint256) {
1292         uint256 plannedContribution = whitelist[msg.sender];
1293         
1294         whitelist[msg.sender] = 0;
1295         WhitelistedUpdated(plannedContribution, true);
1296         
1297         if (msg.value > plannedContribution) {
1298             return handleAbovePlannedWhitelistedContribution(allowedContribution, plannedContribution, refundAmount);
1299         }
1300         
1301         if (msg.value < plannedContribution) {
1302             return handleBelowPlannedWhitelistedContribution(plannedContribution);
1303         }
1304         
1305         return handlePlannedWhitelistedContribution(plannedContribution);
1306     }
1307 
1308     /// @notice Returns the contribution and refund value to be used when the transaction value equals the whitelisted contribution for the sender.
1309     /// Note that refund value will always be 0 in this case, as the planned contribution for the sender and transaction value match.
1310     function handlePlannedWhitelistedContribution(uint256 plannedContribution) private returns (uint256, uint256) {
1311         updateWhitelistedContribution(plannedContribution);
1312         AllowedContributionCheck(plannedContribution, AllowedContributionState.Whitelisted);
1313         return (plannedContribution, 0);
1314     }
1315     
1316     /// @notice Returns the contribution and refund value to be used when the transaction value is higher than the whitelisted contribution for the sender.
1317     /// Note that only in this case, the refund value will not be 0.
1318     function handleAbovePlannedWhitelistedContribution(uint256 allowedContribution, uint256 plannedContribution, uint256 refundAmount) private returns (uint256, uint256) {
1319         updateWhitelistedContribution(plannedContribution);
1320         AllowedContributionCheck(allowedContribution, AllowedContributionState.AboveWhitelisted);
1321         return (allowedContribution, refundAmount);
1322     }
1323 
1324     /// @notice Returns the contribution and refund value to be used when the transaction value is lower than the whitelisted contribution for the sender.
1325     /// Note that refund value will always be 0 in this case, as transaction value is below the planned contribution for this sender.
1326     function handleBelowPlannedWhitelistedContribution(uint256 plannedContribution) private returns (uint256, uint256) {
1327         uint256 belowPlanned = plannedContribution.sub(msg.value);
1328         preSaleCap = preSaleCap.add(belowPlanned);
1329         
1330         updateWhitelistedContribution(msg.value);
1331         AllowedContributionCheck(msg.value, AllowedContributionState.BelowWhitelisted);
1332         return (msg.value, 0);
1333     }
1334 
1335     /// @notice Updates the whitelistedPlannedContributions counter, subtracting the contribution about to be applied.
1336     function updateWhitelistedContribution(uint256 plannedContribution) private {
1337         whitelistedPlannedContributions = whitelistedPlannedContributions.sub(plannedContribution);
1338         WhitelistedCounterUpdated(whitelistedPlannedContributions, plannedContribution);
1339     }
1340 
1341     /// @notice Calculates the allowed contribution based on the transaction value and amount remaining till cap.
1342     /// If the transaction contribution is higher than cap, will return the excess amount to be refunded to sender.
1343     /// @return the allowed contribution and refund amount (if any). All in WEI.
1344     function getAllowedContribution() private returns (uint256, uint256) {
1345         uint256 allowedContribution = msg.value;
1346         uint256 tillCap = remainingCap();
1347         uint256 refundAmount = 0;
1348         if (msg.value > tillCap) {
1349             allowedContribution = tillCap;
1350             refundAmount = msg.value.sub(allowedContribution);
1351             ContributionRefund(refundAmount, msg.sender);
1352         }
1353         return (allowedContribution, refundAmount);
1354     }
1355 
1356     /// @notice Returns the Ether amount remaining until the hard-cap
1357     /// @return the remaining cap in WEI
1358     function remainingCap() private returns (uint256) {
1359         return preSaleCap.sub(preSaleEtherPaid);
1360     }
1361 
1362     /// @notice Public function enables closing of the pre-sale manually if necessary
1363     function closeSale() public onlyOwner {
1364         closePreSale();
1365     }
1366 
1367     /// @notice Private function used to close the pre-sale when the hard-cap is hit
1368     function closePreSale() private {
1369         closed = true;
1370         SaleClosed(now);
1371     }
1372 
1373     /// @notice Ensure the contribution is valid
1374     /// @return Returns whether the contribution is valid or not
1375     function validContribution() private returns (bool) {
1376         bool isContributionValid = msg.value >= minPresaleContributionEther && msg.value <= maxPresaleContributionEther;
1377         ValidContributionCheck(msg.value, isContributionValid);
1378         return isContributionValid;
1379     }
1380 
1381     /// @notice Applies the discount based on the discount tiers
1382     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1383     /// @param _contributorTokens The tokens allocated based on the contribution
1384     function applyDiscount(
1385         uint256 _etherAmount, 
1386         uint256 _contributorTokens
1387     )
1388         internal
1389         constant
1390         returns (uint256)
1391     {
1392 
1393         uint256 discount = 0;
1394 
1395         if (_etherAmount <= firstTierDiscountUpperLimitEther) {
1396             discount = _contributorTokens.mul(FIRST_TIER_DISCOUNT).div(100);
1397         } else if (_etherAmount > firstTierDiscountUpperLimitEther && _etherAmount <= secondTierDiscountUpperLimitEther) {
1398             discount = _contributorTokens.mul(SECOND_TIER_DISCOUNT).div(100);
1399         } else {
1400             discount = _contributorTokens.mul(THIRD_TIER_DISCOUNT).div(100);
1401         }
1402 
1403         DiscountApplied(_etherAmount, _contributorTokens, discount);
1404         return discount.add(_contributorTokens);
1405     }
1406 
1407     /// @notice Updates the counters for the amount of Ether paid
1408     /// @param _etherAmount the amount of Ether paid
1409     function updateCounters(uint256 _etherAmount) internal {
1410         preSaleEtherPaid = preSaleEtherPaid.add(_etherAmount);
1411         totalContributions = totalContributions.add(1);
1412         CountersUpdated(preSaleEtherPaid, _etherAmount);
1413     }
1414 }