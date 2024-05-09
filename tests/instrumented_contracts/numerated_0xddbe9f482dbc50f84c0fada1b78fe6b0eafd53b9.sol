1 pragma solidity 0.4.15;
2 
3 
4 /**
5  * Math operations with safety checks
6  */
7 library SafeMath {
8   function mul(uint a, uint b) internal returns (uint) {
9     uint c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint a, uint b) internal returns (uint) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint a, uint b) internal returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint a, uint b) internal returns (uint) {
27     uint c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
33     return a >= b ? a : b;
34   }
35 
36   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a < b ? a : b;
38   }
39 
40   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
41     return a >= b ? a : b;
42   }
43 
44   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a < b ? a : b;
46   }
47 }
48 
49 
50 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
51 ///  later changed
52 contract Owned {
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
64     function Owned() {
65         owner = msg.sender;
66     }
67 
68     address public newOwner;
69 
70     /// @notice `owner` can step down and assign some other address to this role
71     /// @param _newOwner The address of the new owner. 0x0 can be used to create
72     function changeOwner(address _newOwner) onlyOwner {
73         if(msg.sender == owner) {
74             owner = _newOwner;
75         }
76     }
77 }
78 
79 
80 /// @title Vesting trustee
81 contract Trustee is Owned {
82     using SafeMath for uint256;
83 
84     // The address of the SHP ERC20 token.
85     SHP public shp;
86 
87     struct Grant {
88         uint256 value;
89         uint256 start;
90         uint256 cliff;
91         uint256 end;
92         uint256 transferred;
93         bool revokable;
94     }
95 
96     // Grants holder.
97     mapping (address => Grant) public grants;
98 
99     // Total tokens available for vesting.
100     uint256 public totalVesting;
101 
102     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
103     event UnlockGrant(address indexed _holder, uint256 _value);
104     event RevokeGrant(address indexed _holder, uint256 _refund);
105 
106     /// @dev Constructor that initializes the address of the SHP contract.
107     /// @param _shp SHP The address of the previously deployed SHP smart contract.
108     function Trustee(SHP _shp) {
109         require(_shp != address(0));
110         shp = _shp;
111     }
112 
113     /// @dev Grant tokens to a specified address.
114     /// @param _to address The address to grant tokens to.
115     /// @param _value uint256 The amount of tokens to be granted.
116     /// @param _start uint256 The beginning of the vesting period.
117     /// @param _cliff uint256 Duration of the cliff period.
118     /// @param _end uint256 The end of the vesting period.
119     /// @param _revokable bool Whether the grant is revokable or not.
120     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
121         public onlyOwner {
122         require(_to != address(0));
123         require(_value > 0);
124 
125         // Make sure that a single address can be granted tokens only once.
126         require(grants[_to].value == 0);
127 
128         // Check for date inconsistencies that may cause unexpected behavior.
129         require(_start <= _cliff && _cliff <= _end);
130 
131         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
132         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
133 
134         // Assign a new grant.
135         grants[_to] = Grant({
136             value: _value,
137             start: _start,
138             cliff: _cliff,
139             end: _end,
140             transferred: 0,
141             revokable: _revokable
142         });
143 
144         // Tokens granted, reduce the total amount available for vesting.
145         totalVesting = totalVesting.add(_value);
146 
147         NewGrant(msg.sender, _to, _value);
148     }
149 
150     /// @dev Revoke the grant of tokens of a specifed address.
151     /// @param _holder The address which will have its tokens revoked.
152     function revoke(address _holder) public onlyOwner {
153         Grant grant = grants[_holder];
154 
155         require(grant.revokable);
156 
157         // Send the remaining SHP back to the owner.
158         uint256 refund = grant.value.sub(grant.transferred);
159 
160         // Remove the grant.
161         delete grants[_holder];
162 
163         totalVesting = totalVesting.sub(refund);
164         shp.transfer(msg.sender, refund);
165 
166         RevokeGrant(_holder, refund);
167     }
168 
169     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
170     /// @param _holder address The address of the holder.
171     /// @param _time uint256 The specific time.
172     /// @return a uint256 representing a holder's total amount of vested tokens.
173     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
174         Grant grant = grants[_holder];
175         if (grant.value == 0) {
176             return 0;
177         }
178 
179         return calculateVestedTokens(grant, _time);
180     }
181 
182     /// @dev Calculate amount of vested tokens at a specifc time.
183     /// @param _grant Grant The vesting grant.
184     /// @param _time uint256 The time to be checked
185     /// @return An uint256 representing the amount of vested tokens of a specific grant.
186     ///   |                         _/--------   vestedTokens rect
187     ///   |                       _/
188     ///   |                     _/
189     ///   |                   _/
190     ///   |                 _/
191     ///   |                /
192     ///   |              .|
193     ///   |            .  |
194     ///   |          .    |
195     ///   |        .      |
196     ///   |      .        |
197     ///   |    .          |
198     ///   +===+===========+---------+----------> time
199     ///     Start       Cliff      End
200     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
201         // If we're before the cliff, then nothing is vested.
202         if (_time < _grant.cliff) {
203             return 0;
204         }
205 
206         // If we're after the end of the vesting period - everything is vested;
207         if (_time >= _grant.end) {
208             return _grant.value;
209         }
210 
211         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
212          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
213     }
214 
215     /// @dev Unlock vested tokens and transfer them to their holder.
216     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
217     function unlockVestedTokens() public {
218         Grant grant = grants[msg.sender];
219         require(grant.value != 0);
220 
221         // Get the total amount of vested tokens, acccording to grant.
222         uint256 vested = calculateVestedTokens(grant, now);
223         if (vested == 0) {
224             return;
225         }
226 
227         // Make sure the holder doesn't transfer more than what he already has.
228         uint256 transferable = vested.sub(grant.transferred);
229         if (transferable == 0) {
230             return;
231         }
232 
233         grant.transferred = grant.transferred.add(transferable);
234         totalVesting = totalVesting.sub(transferable);
235         shp.transfer(msg.sender, transferable);
236 
237         UnlockGrant(msg.sender, transferable);
238     }
239 }
240 
241 /*
242     Copyright 2016, Jordi Baylina
243 
244     This program is free software: you can redistribute it and/or modify
245     it under the terms of the GNU General Public License as published by
246     the Free Software Foundation, either version 3 of the License, or
247     (at your option) any later version.
248 
249     This program is distributed in the hope that it will be useful,
250     but WITHOUT ANY WARRANTY; without even the implied warranty of
251     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
252     GNU General Public License for more details.
253 
254     You should have received a copy of the GNU General Public License
255     along with this program.  If not, see <http://www.gnu.org/licenses/>.
256  */
257 
258 /// @title MiniMeToken Contract
259 /// @author Jordi Baylina
260 /// @dev This token contract's goal is to make it easy for anyone to clone this
261 ///  token using the token distribution at a given block, this will allow DAO's
262 ///  and DApps to upgrade their features in a decentralized manner without
263 ///  affecting the original token
264 /// @dev It is ERC20 compliant, but still needs to under go further testing.
265 
266 
267 /// @dev The token controller contract must implement these functions
268 contract TokenController {
269     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
270     /// @param _owner The address that sent the ether to create tokens
271     /// @return True if the ether is accepted, false if it throws
272     function proxyPayment(address _owner) payable returns(bool);
273 
274     /// @notice Notifies the controller about a token transfer allowing the
275     ///  controller to react if desired
276     /// @param _from The origin of the transfer
277     /// @param _to The destination of the transfer
278     /// @param _amount The amount of the transfer
279     /// @return False if the controller does not authorize the transfer
280     function onTransfer(address _from, address _to, uint _amount) returns(bool);
281 
282     /// @notice Notifies the controller about an approval allowing the
283     ///  controller to react if desired
284     /// @param _owner The address that calls `approve()`
285     /// @param _spender The spender in the `approve()` call
286     /// @param _amount The amount in the `approve()` call
287     /// @return False if the controller does not authorize the approval
288     function onApprove(address _owner, address _spender, uint _amount)
289         returns(bool);
290 }
291 
292 contract Controlled {
293     /// @notice The address of the controller is the only address that can call
294     ///  a function with this modifier
295     modifier onlyController { require(msg.sender == controller); _; }
296 
297     address public controller;
298 
299     function Controlled() { controller = msg.sender;}
300 
301     /// @notice Changes the controller of the contract
302     /// @param _newController The new controller of the contract
303     function changeController(address _newController) onlyController {
304         controller = _newController;
305     }
306 }
307 
308 contract ApproveAndCallFallBack {
309     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
310 }
311 
312 /// @dev The actual token contract, the default controller is the msg.sender
313 ///  that deploys the contract, so usually this token will be deployed by a
314 ///  token controller contract, which Giveth will call a "Campaign"
315 contract MiniMeToken is Controlled {
316 
317     string public name;                //The Token's name: e.g. DigixDAO Tokens
318     uint8 public decimals;             //Number of decimals of the smallest unit
319     string public symbol;              //An identifier: e.g. REP
320     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
321 
322 
323     /// @dev `Checkpoint` is the structure that attaches a block number to a
324     ///  given value, the block number attached is the one that last changed the
325     ///  value
326     struct  Checkpoint {
327 
328         // `fromBlock` is the block number that the value was generated from
329         uint128 fromBlock;
330 
331         // `value` is the amount of tokens at a specific block number
332         uint128 value;
333     }
334 
335     // `parentToken` is the Token address that was cloned to produce this token;
336     //  it will be 0x0 for a token that was not cloned
337     MiniMeToken public parentToken;
338 
339     // `parentSnapShotBlock` is the block number from the Parent Token that was
340     //  used to determine the initial distribution of the Clone Token
341     uint public parentSnapShotBlock;
342 
343     // `creationBlock` is the block number that the Clone Token was created
344     uint public creationBlock;
345 
346     // `balances` is the map that tracks the balance of each address, in this
347     //  contract when the balance changes the block number that the change
348     //  occurred is also included in the map
349     mapping (address => Checkpoint[]) balances;
350 
351     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
352     mapping (address => mapping (address => uint256)) allowed;
353 
354     // Tracks the history of the `totalSupply` of the token
355     Checkpoint[] totalSupplyHistory;
356 
357     // Flag that determines if the token is transferable or not.
358     bool public transfersEnabled;
359 
360     // The factory used to create new clone tokens
361     MiniMeTokenFactory public tokenFactory;
362 
363 ////////////////
364 // Constructor
365 ////////////////
366 
367     /// @notice Constructor to create a MiniMeToken
368     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
369     ///  will create the Clone token contracts, the token factory needs to be
370     ///  deployed first
371     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
372     ///  new token
373     /// @param _parentSnapShotBlock Block of the parent token that will
374     ///  determine the initial distribution of the clone token, set to 0 if it
375     ///  is a new token
376     /// @param _tokenName Name of the new token
377     /// @param _decimalUnits Number of decimals of the new token
378     /// @param _tokenSymbol Token Symbol for the new token
379     /// @param _transfersEnabled If true, tokens will be able to be transferred
380     function MiniMeToken(
381         address _tokenFactory,
382         address _parentToken,
383         uint _parentSnapShotBlock,
384         string _tokenName,
385         uint8 _decimalUnits,
386         string _tokenSymbol,
387         bool _transfersEnabled
388     ) {
389         tokenFactory = MiniMeTokenFactory(_tokenFactory);
390         name = _tokenName;                                 // Set the name
391         decimals = _decimalUnits;                          // Set the decimals
392         symbol = _tokenSymbol;                             // Set the symbol
393         parentToken = MiniMeToken(_parentToken);
394         parentSnapShotBlock = _parentSnapShotBlock;
395         transfersEnabled = _transfersEnabled;
396         creationBlock = block.number;
397     }
398 
399 
400 ///////////////////
401 // ERC20 Methods
402 ///////////////////
403 
404     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
405     /// @param _to The address of the recipient
406     /// @param _amount The amount of tokens to be transferred
407     /// @return Whether the transfer was successful or not
408     function transfer(address _to, uint256 _amount) returns (bool success) {
409         require(transfersEnabled);
410         return doTransfer(msg.sender, _to, _amount);
411     }
412 
413     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
414     ///  is approved by `_from`
415     /// @param _from The address holding the tokens being transferred
416     /// @param _to The address of the recipient
417     /// @param _amount The amount of tokens to be transferred
418     /// @return True if the transfer was successful
419     function transferFrom(address _from, address _to, uint256 _amount
420     ) returns (bool success) {
421 
422         // The controller of this contract can move tokens around at will,
423         //  this is important to recognize! Confirm that you trust the
424         //  controller of this contract, which in most situations should be
425         //  another open source smart contract or 0x0
426         if (msg.sender != controller) {
427             require(transfersEnabled);
428 
429             // The standard ERC 20 transferFrom functionality
430             if (allowed[_from][msg.sender] < _amount) return false;
431             allowed[_from][msg.sender] -= _amount;
432         }
433         return doTransfer(_from, _to, _amount);
434     }
435 
436     /// @dev This is the actual transfer function in the token contract, it can
437     ///  only be called by other functions in this contract.
438     /// @param _from The address holding the tokens being transferred
439     /// @param _to The address of the recipient
440     /// @param _amount The amount of tokens to be transferred
441     /// @return True if the transfer was successful
442     function doTransfer(address _from, address _to, uint _amount
443     ) internal returns(bool) {
444 
445            if (_amount == 0) {
446                return true;
447            }
448 
449            require(parentSnapShotBlock < block.number);
450 
451            // Do not allow transfer to 0x0 or the token contract itself
452            require((_to != 0) && (_to != address(this)));
453 
454            // If the amount being transfered is more than the balance of the
455            //  account the transfer returns false
456            var previousBalanceFrom = balanceOfAt(_from, block.number);
457            if (previousBalanceFrom < _amount) {
458                return false;
459            }
460 
461            // Alerts the token controller of the transfer
462            if (isContract(controller)) {
463                require(TokenController(controller).onTransfer(_from, _to, _amount));
464            }
465 
466            // First update the balance array with the new value for the address
467            //  sending the tokens
468            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
469 
470            // Then update the balance array with the new value for the address
471            //  receiving the tokens
472            var previousBalanceTo = balanceOfAt(_to, block.number);
473            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
474            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
475 
476            // An event to make the transfer easy to find on the blockchain
477            Transfer(_from, _to, _amount);
478 
479            return true;
480     }
481 
482     /// @param _owner The address that's balance is being requested
483     /// @return The balance of `_owner` at the current block
484     function balanceOf(address _owner) constant returns (uint256 balance) {
485         return balanceOfAt(_owner, block.number);
486     }
487 
488     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
489     ///  its behalf. This is a modified version of the ERC20 approve function
490     ///  to be a little bit safer
491     /// @param _spender The address of the account able to transfer the tokens
492     /// @param _amount The amount of tokens to be approved for transfer
493     /// @return True if the approval was successful
494     function approve(address _spender, uint256 _amount) returns (bool success) {
495         require(transfersEnabled);
496 
497         // To change the approve amount you first have to reduce the addresses`
498         //  allowance to zero by calling `approve(_spender,0)` if it is not
499         //  already 0 to mitigate the race condition described here:
500         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
501         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
502 
503         // Alerts the token controller of the approve function call
504         if (isContract(controller)) {
505             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
506         }
507 
508         allowed[msg.sender][_spender] = _amount;
509         Approval(msg.sender, _spender, _amount);
510         return true;
511     }
512 
513     /// @dev This function makes it easy to read the `allowed[]` map
514     /// @param _owner The address of the account that owns the token
515     /// @param _spender The address of the account able to transfer the tokens
516     /// @return Amount of remaining tokens of _owner that _spender is allowed
517     ///  to spend
518     function allowance(address _owner, address _spender
519     ) constant returns (uint256 remaining) {
520         return allowed[_owner][_spender];
521     }
522 
523     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
524     ///  its behalf, and then a function is triggered in the contract that is
525     ///  being approved, `_spender`. This allows users to use their tokens to
526     ///  interact with contracts in one function call instead of two
527     /// @param _spender The address of the contract able to transfer the tokens
528     /// @param _amount The amount of tokens to be approved for transfer
529     /// @return True if the function call was successful
530     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
531     ) returns (bool success) {
532         require(approve(_spender, _amount));
533 
534         ApproveAndCallFallBack(_spender).receiveApproval(
535             msg.sender,
536             _amount,
537             this,
538             _extraData
539         );
540 
541         return true;
542     }
543 
544     /// @dev This function makes it easy to get the total number of tokens
545     /// @return The total number of tokens
546     function totalSupply() constant returns (uint) {
547         return totalSupplyAt(block.number);
548     }
549 
550 
551 ////////////////
552 // Query balance and totalSupply in History
553 ////////////////
554 
555     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
556     /// @param _owner The address from which the balance will be retrieved
557     /// @param _blockNumber The block number when the balance is queried
558     /// @return The balance at `_blockNumber`
559     function balanceOfAt(address _owner, uint _blockNumber) constant
560         returns (uint) {
561 
562         // These next few lines are used when the balance of the token is
563         //  requested before a check point was ever created for this token, it
564         //  requires that the `parentToken.balanceOfAt` be queried at the
565         //  genesis block for that token as this contains initial balance of
566         //  this token
567         if ((balances[_owner].length == 0)
568             || (balances[_owner][0].fromBlock > _blockNumber)) {
569             if (address(parentToken) != 0) {
570                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
571             } else {
572                 // Has no parent
573                 return 0;
574             }
575 
576         // This will return the expected balance during normal situations
577         } else {
578             return getValueAt(balances[_owner], _blockNumber);
579         }
580     }
581 
582     /// @notice Total amount of tokens at a specific `_blockNumber`.
583     /// @param _blockNumber The block number when the totalSupply is queried
584     /// @return The total amount of tokens at `_blockNumber`
585     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
586 
587         // These next few lines are used when the totalSupply of the token is
588         //  requested before a check point was ever created for this token, it
589         //  requires that the `parentToken.totalSupplyAt` be queried at the
590         //  genesis block for this token as that contains totalSupply of this
591         //  token at this block number.
592         if ((totalSupplyHistory.length == 0)
593             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
594             if (address(parentToken) != 0) {
595                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
596             } else {
597                 return 0;
598             }
599 
600         // This will return the expected totalSupply during normal situations
601         } else {
602             return getValueAt(totalSupplyHistory, _blockNumber);
603         }
604     }
605 
606 ////////////////
607 // Clone Token Method
608 ////////////////
609 
610     /// @notice Creates a new clone token with the initial distribution being
611     ///  this token at `_snapshotBlock`
612     /// @param _cloneTokenName Name of the clone token
613     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
614     /// @param _cloneTokenSymbol Symbol of the clone token
615     /// @param _snapshotBlock Block when the distribution of the parent token is
616     ///  copied to set the initial distribution of the new clone token;
617     ///  if the block is zero than the actual block, the current block is used
618     /// @param _transfersEnabled True if transfers are allowed in the clone
619     /// @return The address of the new MiniMeToken Contract
620     function createCloneToken(
621         string _cloneTokenName,
622         uint8 _cloneDecimalUnits,
623         string _cloneTokenSymbol,
624         uint _snapshotBlock,
625         bool _transfersEnabled
626         ) returns(address) {
627         if (_snapshotBlock == 0) _snapshotBlock = block.number;
628         MiniMeToken cloneToken = tokenFactory.createCloneToken(
629             this,
630             _snapshotBlock,
631             _cloneTokenName,
632             _cloneDecimalUnits,
633             _cloneTokenSymbol,
634             _transfersEnabled
635             );
636 
637         cloneToken.changeController(msg.sender);
638 
639         // An event to make the token easy to find on the blockchain
640         NewCloneToken(address(cloneToken), _snapshotBlock);
641         return address(cloneToken);
642     }
643 
644 ////////////////
645 // Generate and destroy tokens
646 ////////////////
647 
648     /// @notice Generates `_amount` tokens that are assigned to `_owner`
649     /// @param _owner The address that will be assigned the new tokens
650     /// @param _amount The quantity of tokens generated
651     /// @return True if the tokens are generated correctly
652     function generateTokens(address _owner, uint _amount
653     ) onlyController returns (bool) {
654         uint curTotalSupply = totalSupply();
655         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
656         uint previousBalanceTo = balanceOf(_owner);
657         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
658         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
659         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
660         Transfer(0, _owner, _amount);
661         return true;
662     }
663 
664 
665     /// @notice Burns `_amount` tokens from `_owner`
666     /// @param _owner The address that will lose the tokens
667     /// @param _amount The quantity of tokens to burn
668     /// @return True if the tokens are burned correctly
669     function destroyTokens(address _owner, uint _amount
670     ) onlyController returns (bool) {
671         uint curTotalSupply = totalSupply();
672         require(curTotalSupply >= _amount);
673         uint previousBalanceFrom = balanceOf(_owner);
674         require(previousBalanceFrom >= _amount);
675         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
676         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
677         Transfer(_owner, 0, _amount);
678         return true;
679     }
680 
681 ////////////////
682 // Enable tokens transfers
683 ////////////////
684 
685 
686     /// @notice Enables token holders to transfer their tokens freely if true
687     /// @param _transfersEnabled True if transfers are allowed in the clone
688     function enableTransfers(bool _transfersEnabled) onlyController {
689         transfersEnabled = _transfersEnabled;
690     }
691 
692 ////////////////
693 // Internal helper functions to query and set a value in a snapshot array
694 ////////////////
695 
696     /// @dev `getValueAt` retrieves the number of tokens at a given block number
697     /// @param checkpoints The history of values being queried
698     /// @param _block The block number to retrieve the value at
699     /// @return The number of tokens being queried
700     function getValueAt(Checkpoint[] storage checkpoints, uint _block
701     ) constant internal returns (uint) {
702         if (checkpoints.length == 0) return 0;
703 
704         // Shortcut for the actual value
705         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
706             return checkpoints[checkpoints.length-1].value;
707         if (_block < checkpoints[0].fromBlock) return 0;
708 
709         // Binary search of the value in the array
710         uint min = 0;
711         uint max = checkpoints.length-1;
712         while (max > min) {
713             uint mid = (max + min + 1)/ 2;
714             if (checkpoints[mid].fromBlock<=_block) {
715                 min = mid;
716             } else {
717                 max = mid-1;
718             }
719         }
720         return checkpoints[min].value;
721     }
722 
723     /// @dev `updateValueAtNow` used to update the `balances` map and the
724     ///  `totalSupplyHistory`
725     /// @param checkpoints The history of data being updated
726     /// @param _value The new number of tokens
727     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
728     ) internal  {
729         if ((checkpoints.length == 0)
730         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
731                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
732                newCheckPoint.fromBlock =  uint128(block.number);
733                newCheckPoint.value = uint128(_value);
734            } else {
735                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
736                oldCheckPoint.value = uint128(_value);
737            }
738     }
739 
740     /// @dev Internal function to determine if an address is a contract
741     /// @param _addr The address being queried
742     /// @return True if `_addr` is a contract
743     function isContract(address _addr) constant internal returns(bool) {
744         uint size;
745         if (_addr == 0) return false;
746         assembly {
747             size := extcodesize(_addr)
748         }
749         return size>0;
750     }
751 
752     /// @dev Helper function to return a min betwen the two uints
753     function min(uint a, uint b) internal returns (uint) {
754         return a < b ? a : b;
755     }
756 
757     /// @notice The fallback function: If the contract's controller has not been
758     ///  set to 0, then the `proxyPayment` method is called which relays the
759     ///  ether and creates tokens as described in the token controller contract
760     function ()  payable {
761         require(isContract(controller));
762         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
763     }
764 
765 //////////
766 // Safety Methods
767 //////////
768 
769     /// @notice This method can be used by the controller to extract mistakenly
770     ///  sent tokens to this contract.
771     /// @param _token The address of the token contract that you want to recover
772     ///  set to 0 in case you want to extract ether.
773     function claimTokens(address _token) onlyController {
774         if (_token == 0x0) {
775             controller.transfer(this.balance);
776             return;
777         }
778 
779         MiniMeToken token = MiniMeToken(_token);
780         uint balance = token.balanceOf(this);
781         token.transfer(controller, balance);
782         ClaimedTokens(_token, controller, balance);
783     }
784 
785 ////////////////
786 // Events
787 ////////////////
788     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
789     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
790     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
791     event Approval(
792         address indexed _owner,
793         address indexed _spender,
794         uint256 _amount
795         );
796 
797 }
798 
799 
800 ////////////////
801 // MiniMeTokenFactory
802 ////////////////
803 
804 /// @dev This contract is used to generate clone contracts from a contract.
805 ///  In solidity this is the way to create a contract from a contract of the
806 ///  same class
807 contract MiniMeTokenFactory {
808 
809     /// @notice Update the DApp by creating a new token with new functionalities
810     ///  the msg.sender becomes the controller of this clone token
811     /// @param _parentToken Address of the token being cloned
812     /// @param _snapshotBlock Block of the parent token that will
813     ///  determine the initial distribution of the clone token
814     /// @param _tokenName Name of the new token
815     /// @param _decimalUnits Number of decimals of the new token
816     /// @param _tokenSymbol Token Symbol for the new token
817     /// @param _transfersEnabled If true, tokens will be able to be transferred
818     /// @return The address of the new token contract
819     function createCloneToken(
820         address _parentToken,
821         uint _snapshotBlock,
822         string _tokenName,
823         uint8 _decimalUnits,
824         string _tokenSymbol,
825         bool _transfersEnabled
826     ) returns (MiniMeToken) 
827     {
828         MiniMeToken newToken = new MiniMeToken(
829             this,
830             _parentToken,
831             _snapshotBlock,
832             _tokenName,
833             _decimalUnits,
834             _tokenSymbol,
835             _transfersEnabled
836             );
837 
838         newToken.changeController(msg.sender);
839         return newToken;
840     }
841 }
842 
843 contract SHP is MiniMeToken {
844     // @dev SHP constructor
845     function SHP(address _tokenFactory)
846             MiniMeToken(
847                 _tokenFactory,
848                 0x0,                             // no parent token
849                 0,                               // no snapshot block number from parent
850                 "Sharpe Platform Token",         // Token name
851                 18,                              // Decimals
852                 "SHP",                           // Symbol
853                 true                             // Enable transfers
854             ) {}
855 }
856 
857 contract SHPController is Owned, TokenController {
858 
859     SHP public shp;
860     Trustee public trustee;
861 
862     bool public grantsCreated = false;
863     bool public tokenCountSet = false;
864 
865     address public reserveAddress;
866     address public foundersAddress;
867     uint256 public reserveTokens = 0;
868     uint256 public foundersTokens = 0;
869     uint256 public WEEKS_26 = 26 weeks;
870     uint256 public WEEKS_104 = 104 weeks;
871 
872     modifier grantsNotCreated() {
873         require(!grantsCreated);
874         _;
875     }
876 
877     modifier tokenCountNotSet() {
878         require(!tokenCountSet);
879         _;
880     }
881 
882     function SHPController(
883         address _reserveAddress, 
884         address _foundersAddress
885     ) {
886         reserveAddress = _reserveAddress;
887         foundersAddress = _foundersAddress;
888     }
889 
890     function () public payable {
891         revert();
892     }
893 
894     function setTokenCounts(
895         uint256 _reserveTokens,
896         uint256 _foundersTokens
897     ) 
898         public 
899         onlyOwner
900         tokenCountNotSet
901     {
902         reserveTokens = _reserveTokens;
903         foundersTokens = _foundersTokens;
904         tokenCountSet = true;
905     }
906 
907     function setContracts(address _shpAddress, address _trusteeAddress) public onlyOwner {
908         shp = SHP(_shpAddress);
909         trustee = Trustee(_trusteeAddress);
910     }
911 
912     function createVestingGrants() public onlyOwner grantsNotCreated {
913         uint256 cliff = now + WEEKS_26;
914         uint256 end = now + WEEKS_104;
915         trustee.grant(reserveAddress, reserveTokens, now, cliff, end, false);
916         trustee.grant(foundersAddress, foundersTokens, now, cliff, end, false);
917         grantsCreated = true;
918     }
919 
920     //////////
921     // MiniMe Controller Interface functions
922     //////////
923 
924     // In between the offering and the network. Default settings for allowing token transfers.
925     function proxyPayment(address) public payable returns (bool) {
926         return false;
927     }
928 
929     function onTransfer(address, address, uint256) public returns (bool) {
930         return true;
931     }
932 
933     function onApprove(address, address, uint256) public returns (bool) {
934         return true;
935     }
936 }