1 pragma solidity 0.4.15;
2 
3 /*    
4     This program is free software: you can redistribute it and/or modify
5     it under the terms of the GNU General Public License as published by
6     the Free Software Foundation, either version 3 of the License, or
7     (at your option) any later version.
8 
9     This program is distributed in the hope that it will be useful,
10     but WITHOUT ANY WARRANTY; without even the implied warranty of
11     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12     GNU General Public License for more details.
13 
14     You should have received a copy of the GNU General Public License
15     along with this program.  If not, see <http://www.gnu.org/licenses/>.
16  */
17 
18  
19 
20 
21 
22 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
23 ///  later changed
24 contract Owned {
25 
26     /// @dev `owner` is the only address that can call a function with this
27     /// modifier
28     modifier onlyOwner() {
29         require(msg.sender == owner);
30         _;
31     }
32 
33     address public owner;
34 
35     /// @notice The Constructor assigns the message sender to be `owner`
36     function Owned() {
37         owner = msg.sender;
38     }
39 
40     address public newOwner;
41 
42     /// @notice `owner` can step down and assign some other address to this role
43     /// @param _newOwner The address of the new owner. 0x0 can be used to create
44     function changeOwner(address _newOwner) onlyOwner {
45         if(msg.sender == owner) {
46             owner = _newOwner;
47         }
48     }
49 }
50 
51 
52 /**
53  * Math operations with safety checks
54  */
55 library SafeMath {
56   function mul(uint a, uint b) internal returns (uint) {
57     uint c = a * b;
58     assert(a == 0 || c / a == b);
59     return c;
60   }
61 
62   function div(uint a, uint b) internal returns (uint) {
63     // assert(b > 0); // Solidity automatically throws when dividing by 0
64     uint c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66     return c;
67   }
68 
69   function sub(uint a, uint b) internal returns (uint) {
70     assert(b <= a);
71     return a - b;
72   }
73 
74   function add(uint a, uint b) internal returns (uint) {
75     uint c = a + b;
76     assert(c >= a);
77     return c;
78   }
79 
80   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
81     return a >= b ? a : b;
82   }
83 
84   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
85     return a < b ? a : b;
86   }
87 
88   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
89     return a >= b ? a : b;
90   }
91 
92   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
93     return a < b ? a : b;
94   }
95 }
96 
97 
98 
99 /// @title Vesting trustee
100 contract Trustee is Owned {
101     using SafeMath for uint256;
102 
103     // The address of the SHP ERC20 token.
104     SHP public shp;
105 
106     struct Grant {
107         uint256 value;
108         uint256 start;
109         uint256 cliff;
110         uint256 end;
111         uint256 transferred;
112         bool revokable;
113     }
114 
115     // Grants holder.
116     mapping (address => Grant) public grants;
117 
118     // Total tokens available for vesting.
119     uint256 public totalVesting;
120 
121     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
122     event UnlockGrant(address indexed _holder, uint256 _value);
123     event RevokeGrant(address indexed _holder, uint256 _refund);
124 
125     /// @dev Constructor that initializes the address of the SHP contract.
126     /// @param _shp SHP The address of the previously deployed SHP smart contract.
127     function Trustee(SHP _shp) {
128         require(_shp != address(0));
129         shp = _shp;
130     }
131 
132     /// @dev Grant tokens to a specified address.
133     /// @param _to address The address to grant tokens to.
134     /// @param _value uint256 The amount of tokens to be granted.
135     /// @param _start uint256 The beginning of the vesting period.
136     /// @param _cliff uint256 Duration of the cliff period.
137     /// @param _end uint256 The end of the vesting period.
138     /// @param _revokable bool Whether the grant is revokable or not.
139     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
140         public onlyOwner {
141         require(_to != address(0));
142         require(_value > 0);
143 
144         // Make sure that a single address can be granted tokens only once.
145         require(grants[_to].value == 0);
146 
147         // Check for date inconsistencies that may cause unexpected behavior.
148         require(_start <= _cliff && _cliff <= _end);
149 
150         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
151         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
152 
153         // Assign a new grant.
154         grants[_to] = Grant({
155             value: _value,
156             start: _start,
157             cliff: _cliff,
158             end: _end,
159             transferred: 0,
160             revokable: _revokable
161         });
162 
163         // Tokens granted, reduce the total amount available for vesting.
164         totalVesting = totalVesting.add(_value);
165 
166         NewGrant(msg.sender, _to, _value);
167     }
168 
169     /// @dev Revoke the grant of tokens of a specifed address.
170     /// @param _holder The address which will have its tokens revoked.
171     function revoke(address _holder) public onlyOwner {
172         Grant grant = grants[_holder];
173 
174         require(grant.revokable);
175 
176         // Send the remaining SHP back to the owner.
177         uint256 refund = grant.value.sub(grant.transferred);
178 
179         // Remove the grant.
180         delete grants[_holder];
181 
182         totalVesting = totalVesting.sub(refund);
183         shp.transfer(msg.sender, refund);
184 
185         RevokeGrant(_holder, refund);
186     }
187 
188     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
189     /// @param _holder address The address of the holder.
190     /// @param _time uint256 The specific time.
191     /// @return a uint256 representing a holder's total amount of vested tokens.
192     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
193         Grant grant = grants[_holder];
194         if (grant.value == 0) {
195             return 0;
196         }
197 
198         return calculateVestedTokens(grant, _time);
199     }
200 
201     /// @dev Calculate amount of vested tokens at a specifc time.
202     /// @param _grant Grant The vesting grant.
203     /// @param _time uint256 The time to be checked
204     /// @return An uint256 representing the amount of vested tokens of a specific grant.
205     ///   |                         _/--------   vestedTokens rect
206     ///   |                       _/
207     ///   |                     _/
208     ///   |                   _/
209     ///   |                 _/
210     ///   |                /
211     ///   |              .|
212     ///   |            .  |
213     ///   |          .    |
214     ///   |        .      |
215     ///   |      .        |
216     ///   |    .          |
217     ///   +===+===========+---------+----------> time
218     ///     Start       Cliff      End
219     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
220         // If we're before the cliff, then nothing is vested.
221         if (_time < _grant.cliff) {
222             return 0;
223         }
224 
225         // If we're after the end of the vesting period - everything is vested;
226         if (_time >= _grant.end) {
227             return _grant.value;
228         }
229 
230         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
231          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
232     }
233 
234     /// @dev Unlock vested tokens and transfer them to their holder.
235     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
236     function unlockVestedTokens() public {
237         Grant grant = grants[msg.sender];
238         require(grant.value != 0);
239 
240         // Get the total amount of vested tokens, acccording to grant.
241         uint256 vested = calculateVestedTokens(grant, now);
242         if (vested == 0) {
243             return;
244         }
245 
246         // Make sure the holder doesn't transfer more than what he already has.
247         uint256 transferable = vested.sub(grant.transferred);
248         if (transferable == 0) {
249             return;
250         }
251 
252         grant.transferred = grant.transferred.add(transferable);
253         totalVesting = totalVesting.sub(transferable);
254         shp.transfer(msg.sender, transferable);
255 
256         UnlockGrant(msg.sender, transferable);
257     }
258 }
259 
260 /// @dev The token controller contract must implement these functions
261 contract TokenController {
262     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
263     /// @param _owner The address that sent the ether to create tokens
264     /// @return True if the ether is accepted, false if it throws
265     function proxyPayment(address _owner) payable returns(bool);
266 
267     /// @notice Notifies the controller about a token transfer allowing the
268     ///  controller to react if desired
269     /// @param _from The origin of the transfer
270     /// @param _to The destination of the transfer
271     /// @param _amount The amount of the transfer
272     /// @return False if the controller does not authorize the transfer
273     function onTransfer(address _from, address _to, uint _amount) returns(bool);
274 
275     /// @notice Notifies the controller about an approval allowing the
276     ///  controller to react if desired
277     /// @param _owner The address that calls `approve()`
278     /// @param _spender The spender in the `approve()` call
279     /// @param _amount The amount in the `approve()` call
280     /// @return False if the controller does not authorize the approval
281     function onApprove(address _owner, address _spender, uint _amount)
282         returns(bool);
283 }
284 
285 contract Controlled {
286     /// @notice The address of the controller is the only address that can call
287     ///  a function with this modifier
288     modifier onlyController { require(msg.sender == controller); _; }
289 
290     address public controller;
291 
292     function Controlled() { controller = msg.sender;}
293 
294     /// @notice Changes the controller of the contract
295     /// @param _newController The new controller of the contract
296     function changeController(address _newController) onlyController {
297         controller = _newController;
298     }
299 }
300 
301 contract ApproveAndCallFallBack {
302     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
303 }
304 
305 /// @dev The actual token contract, the default controller is the msg.sender
306 ///  that deploys the contract, so usually this token will be deployed by a
307 ///  token controller contract, which Giveth will call a "Campaign"
308 contract MiniMeToken is Controlled {
309 
310     string public name;                //The Token's name: e.g. DigixDAO Tokens
311     uint8 public decimals;             //Number of decimals of the smallest unit
312     string public symbol;              //An identifier: e.g. REP
313     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
314 
315 
316     /// @dev `Checkpoint` is the structure that attaches a block number to a
317     ///  given value, the block number attached is the one that last changed the
318     ///  value
319     struct  Checkpoint {
320 
321         // `fromBlock` is the block number that the value was generated from
322         uint128 fromBlock;
323 
324         // `value` is the amount of tokens at a specific block number
325         uint128 value;
326     }
327 
328     // `parentToken` is the Token address that was cloned to produce this token;
329     //  it will be 0x0 for a token that was not cloned
330     MiniMeToken public parentToken;
331 
332     // `parentSnapShotBlock` is the block number from the Parent Token that was
333     //  used to determine the initial distribution of the Clone Token
334     uint public parentSnapShotBlock;
335 
336     // `creationBlock` is the block number that the Clone Token was created
337     uint public creationBlock;
338 
339     // `balances` is the map that tracks the balance of each address, in this
340     //  contract when the balance changes the block number that the change
341     //  occurred is also included in the map
342     mapping (address => Checkpoint[]) balances;
343 
344     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
345     mapping (address => mapping (address => uint256)) allowed;
346 
347     // Tracks the history of the `totalSupply` of the token
348     Checkpoint[] totalSupplyHistory;
349 
350     // Flag that determines if the token is transferable or not.
351     bool public transfersEnabled;
352 
353     // The factory used to create new clone tokens
354     MiniMeTokenFactory public tokenFactory;
355 
356 ////////////////
357 // Constructor
358 ////////////////
359 
360     /// @notice Constructor to create a MiniMeToken
361     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
362     ///  will create the Clone token contracts, the token factory needs to be
363     ///  deployed first
364     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
365     ///  new token
366     /// @param _parentSnapShotBlock Block of the parent token that will
367     ///  determine the initial distribution of the clone token, set to 0 if it
368     ///  is a new token
369     /// @param _tokenName Name of the new token
370     /// @param _decimalUnits Number of decimals of the new token
371     /// @param _tokenSymbol Token Symbol for the new token
372     /// @param _transfersEnabled If true, tokens will be able to be transferred
373     function MiniMeToken(
374         address _tokenFactory,
375         address _parentToken,
376         uint _parentSnapShotBlock,
377         string _tokenName,
378         uint8 _decimalUnits,
379         string _tokenSymbol,
380         bool _transfersEnabled
381     ) {
382         tokenFactory = MiniMeTokenFactory(_tokenFactory);
383         name = _tokenName;                                 // Set the name
384         decimals = _decimalUnits;                          // Set the decimals
385         symbol = _tokenSymbol;                             // Set the symbol
386         parentToken = MiniMeToken(_parentToken);
387         parentSnapShotBlock = _parentSnapShotBlock;
388         transfersEnabled = _transfersEnabled;
389         creationBlock = block.number;
390     }
391 
392 
393 ///////////////////
394 // ERC20 Methods
395 ///////////////////
396 
397     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
398     /// @param _to The address of the recipient
399     /// @param _amount The amount of tokens to be transferred
400     /// @return Whether the transfer was successful or not
401     function transfer(address _to, uint256 _amount) returns (bool success) {
402         require(transfersEnabled);
403         return doTransfer(msg.sender, _to, _amount);
404     }
405 
406     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
407     ///  is approved by `_from`
408     /// @param _from The address holding the tokens being transferred
409     /// @param _to The address of the recipient
410     /// @param _amount The amount of tokens to be transferred
411     /// @return True if the transfer was successful
412     function transferFrom(address _from, address _to, uint256 _amount
413     ) returns (bool success) {
414 
415         // The controller of this contract can move tokens around at will,
416         //  this is important to recognize! Confirm that you trust the
417         //  controller of this contract, which in most situations should be
418         //  another open source smart contract or 0x0
419         if (msg.sender != controller) {
420             require(transfersEnabled);
421 
422             // The standard ERC 20 transferFrom functionality
423             if (allowed[_from][msg.sender] < _amount) return false;
424             allowed[_from][msg.sender] -= _amount;
425         }
426         return doTransfer(_from, _to, _amount);
427     }
428 
429     /// @dev This is the actual transfer function in the token contract, it can
430     ///  only be called by other functions in this contract.
431     /// @param _from The address holding the tokens being transferred
432     /// @param _to The address of the recipient
433     /// @param _amount The amount of tokens to be transferred
434     /// @return True if the transfer was successful
435     function doTransfer(address _from, address _to, uint _amount
436     ) internal returns(bool) {
437 
438            if (_amount == 0) {
439                return true;
440            }
441 
442            require(parentSnapShotBlock < block.number);
443 
444            // Do not allow transfer to 0x0 or the token contract itself
445            require((_to != 0) && (_to != address(this)));
446 
447            // If the amount being transfered is more than the balance of the
448            //  account the transfer returns false
449            var previousBalanceFrom = balanceOfAt(_from, block.number);
450            if (previousBalanceFrom < _amount) {
451                return false;
452            }
453 
454            // Alerts the token controller of the transfer
455            if (isContract(controller)) {
456                require(TokenController(controller).onTransfer(_from, _to, _amount));
457            }
458 
459            // First update the balance array with the new value for the address
460            //  sending the tokens
461            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
462 
463            // Then update the balance array with the new value for the address
464            //  receiving the tokens
465            var previousBalanceTo = balanceOfAt(_to, block.number);
466            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
467            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
468 
469            // An event to make the transfer easy to find on the blockchain
470            Transfer(_from, _to, _amount);
471 
472            return true;
473     }
474 
475     /// @param _owner The address that's balance is being requested
476     /// @return The balance of `_owner` at the current block
477     function balanceOf(address _owner) constant returns (uint256 balance) {
478         return balanceOfAt(_owner, block.number);
479     }
480 
481     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
482     ///  its behalf. This is a modified version of the ERC20 approve function
483     ///  to be a little bit safer
484     /// @param _spender The address of the account able to transfer the tokens
485     /// @param _amount The amount of tokens to be approved for transfer
486     /// @return True if the approval was successful
487     function approve(address _spender, uint256 _amount) returns (bool success) {
488         require(transfersEnabled);
489 
490         // To change the approve amount you first have to reduce the addresses`
491         //  allowance to zero by calling `approve(_spender,0)` if it is not
492         //  already 0 to mitigate the race condition described here:
493         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
494         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
495 
496         // Alerts the token controller of the approve function call
497         if (isContract(controller)) {
498             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
499         }
500 
501         allowed[msg.sender][_spender] = _amount;
502         Approval(msg.sender, _spender, _amount);
503         return true;
504     }
505 
506     /// @dev This function makes it easy to read the `allowed[]` map
507     /// @param _owner The address of the account that owns the token
508     /// @param _spender The address of the account able to transfer the tokens
509     /// @return Amount of remaining tokens of _owner that _spender is allowed
510     ///  to spend
511     function allowance(address _owner, address _spender
512     ) constant returns (uint256 remaining) {
513         return allowed[_owner][_spender];
514     }
515 
516     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
517     ///  its behalf, and then a function is triggered in the contract that is
518     ///  being approved, `_spender`. This allows users to use their tokens to
519     ///  interact with contracts in one function call instead of two
520     /// @param _spender The address of the contract able to transfer the tokens
521     /// @param _amount The amount of tokens to be approved for transfer
522     /// @return True if the function call was successful
523     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
524     ) returns (bool success) {
525         require(approve(_spender, _amount));
526 
527         ApproveAndCallFallBack(_spender).receiveApproval(
528             msg.sender,
529             _amount,
530             this,
531             _extraData
532         );
533 
534         return true;
535     }
536 
537     /// @dev This function makes it easy to get the total number of tokens
538     /// @return The total number of tokens
539     function totalSupply() constant returns (uint) {
540         return totalSupplyAt(block.number);
541     }
542 
543 
544 ////////////////
545 // Query balance and totalSupply in History
546 ////////////////
547 
548     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
549     /// @param _owner The address from which the balance will be retrieved
550     /// @param _blockNumber The block number when the balance is queried
551     /// @return The balance at `_blockNumber`
552     function balanceOfAt(address _owner, uint _blockNumber) constant
553         returns (uint) {
554 
555         // These next few lines are used when the balance of the token is
556         //  requested before a check point was ever created for this token, it
557         //  requires that the `parentToken.balanceOfAt` be queried at the
558         //  genesis block for that token as this contains initial balance of
559         //  this token
560         if ((balances[_owner].length == 0)
561             || (balances[_owner][0].fromBlock > _blockNumber)) {
562             if (address(parentToken) != 0) {
563                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
564             } else {
565                 // Has no parent
566                 return 0;
567             }
568 
569         // This will return the expected balance during normal situations
570         } else {
571             return getValueAt(balances[_owner], _blockNumber);
572         }
573     }
574 
575     /// @notice Total amount of tokens at a specific `_blockNumber`.
576     /// @param _blockNumber The block number when the totalSupply is queried
577     /// @return The total amount of tokens at `_blockNumber`
578     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
579 
580         // These next few lines are used when the totalSupply of the token is
581         //  requested before a check point was ever created for this token, it
582         //  requires that the `parentToken.totalSupplyAt` be queried at the
583         //  genesis block for this token as that contains totalSupply of this
584         //  token at this block number.
585         if ((totalSupplyHistory.length == 0)
586             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
587             if (address(parentToken) != 0) {
588                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
589             } else {
590                 return 0;
591             }
592 
593         // This will return the expected totalSupply during normal situations
594         } else {
595             return getValueAt(totalSupplyHistory, _blockNumber);
596         }
597     }
598 
599 ////////////////
600 // Clone Token Method
601 ////////////////
602 
603     /// @notice Creates a new clone token with the initial distribution being
604     ///  this token at `_snapshotBlock`
605     /// @param _cloneTokenName Name of the clone token
606     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
607     /// @param _cloneTokenSymbol Symbol of the clone token
608     /// @param _snapshotBlock Block when the distribution of the parent token is
609     ///  copied to set the initial distribution of the new clone token;
610     ///  if the block is zero than the actual block, the current block is used
611     /// @param _transfersEnabled True if transfers are allowed in the clone
612     /// @return The address of the new MiniMeToken Contract
613     function createCloneToken(
614         string _cloneTokenName,
615         uint8 _cloneDecimalUnits,
616         string _cloneTokenSymbol,
617         uint _snapshotBlock,
618         bool _transfersEnabled
619         ) returns(address) {
620         if (_snapshotBlock == 0) _snapshotBlock = block.number;
621         MiniMeToken cloneToken = tokenFactory.createCloneToken(
622             this,
623             _snapshotBlock,
624             _cloneTokenName,
625             _cloneDecimalUnits,
626             _cloneTokenSymbol,
627             _transfersEnabled
628             );
629 
630         cloneToken.changeController(msg.sender);
631 
632         // An event to make the token easy to find on the blockchain
633         NewCloneToken(address(cloneToken), _snapshotBlock);
634         return address(cloneToken);
635     }
636 
637 ////////////////
638 // Generate and destroy tokens
639 ////////////////
640 
641     /// @notice Generates `_amount` tokens that are assigned to `_owner`
642     /// @param _owner The address that will be assigned the new tokens
643     /// @param _amount The quantity of tokens generated
644     /// @return True if the tokens are generated correctly
645     function generateTokens(address _owner, uint _amount
646     ) onlyController returns (bool) {
647         uint curTotalSupply = totalSupply();
648         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
649         uint previousBalanceTo = balanceOf(_owner);
650         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
651         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
652         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
653         Transfer(0, _owner, _amount);
654         return true;
655     }
656 
657 
658     /// @notice Burns `_amount` tokens from `_owner`
659     /// @param _owner The address that will lose the tokens
660     /// @param _amount The quantity of tokens to burn
661     /// @return True if the tokens are burned correctly
662     function destroyTokens(address _owner, uint _amount
663     ) onlyController returns (bool) {
664         uint curTotalSupply = totalSupply();
665         require(curTotalSupply >= _amount);
666         uint previousBalanceFrom = balanceOf(_owner);
667         require(previousBalanceFrom >= _amount);
668         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
669         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
670         Transfer(_owner, 0, _amount);
671         return true;
672     }
673 
674 ////////////////
675 // Enable tokens transfers
676 ////////////////
677 
678 
679     /// @notice Enables token holders to transfer their tokens freely if true
680     /// @param _transfersEnabled True if transfers are allowed in the clone
681     function enableTransfers(bool _transfersEnabled) onlyController {
682         transfersEnabled = _transfersEnabled;
683     }
684 
685 ////////////////
686 // Internal helper functions to query and set a value in a snapshot array
687 ////////////////
688 
689     /// @dev `getValueAt` retrieves the number of tokens at a given block number
690     /// @param checkpoints The history of values being queried
691     /// @param _block The block number to retrieve the value at
692     /// @return The number of tokens being queried
693     function getValueAt(Checkpoint[] storage checkpoints, uint _block
694     ) constant internal returns (uint) {
695         if (checkpoints.length == 0) return 0;
696 
697         // Shortcut for the actual value
698         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
699             return checkpoints[checkpoints.length-1].value;
700         if (_block < checkpoints[0].fromBlock) return 0;
701 
702         // Binary search of the value in the array
703         uint min = 0;
704         uint max = checkpoints.length-1;
705         while (max > min) {
706             uint mid = (max + min + 1)/ 2;
707             if (checkpoints[mid].fromBlock<=_block) {
708                 min = mid;
709             } else {
710                 max = mid-1;
711             }
712         }
713         return checkpoints[min].value;
714     }
715 
716     /// @dev `updateValueAtNow` used to update the `balances` map and the
717     ///  `totalSupplyHistory`
718     /// @param checkpoints The history of data being updated
719     /// @param _value The new number of tokens
720     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
721     ) internal  {
722         if ((checkpoints.length == 0)
723         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
724                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
725                newCheckPoint.fromBlock =  uint128(block.number);
726                newCheckPoint.value = uint128(_value);
727            } else {
728                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
729                oldCheckPoint.value = uint128(_value);
730            }
731     }
732 
733     /// @dev Internal function to determine if an address is a contract
734     /// @param _addr The address being queried
735     /// @return True if `_addr` is a contract
736     function isContract(address _addr) constant internal returns(bool) {
737         uint size;
738         if (_addr == 0) return false;
739         assembly {
740             size := extcodesize(_addr)
741         }
742         return size>0;
743     }
744 
745     /// @dev Helper function to return a min betwen the two uints
746     function min(uint a, uint b) internal returns (uint) {
747         return a < b ? a : b;
748     }
749 
750     /// @notice The fallback function: If the contract's controller has not been
751     ///  set to 0, then the `proxyPayment` method is called which relays the
752     ///  ether and creates tokens as described in the token controller contract
753     function ()  payable {
754         require(isContract(controller));
755         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
756     }
757 
758 //////////
759 // Safety Methods
760 //////////
761 
762     /// @notice This method can be used by the controller to extract mistakenly
763     ///  sent tokens to this contract.
764     /// @param _token The address of the token contract that you want to recover
765     ///  set to 0 in case you want to extract ether.
766     function claimTokens(address _token) onlyController {
767         if (_token == 0x0) {
768             controller.transfer(this.balance);
769             return;
770         }
771 
772         MiniMeToken token = MiniMeToken(_token);
773         uint balance = token.balanceOf(this);
774         token.transfer(controller, balance);
775         ClaimedTokens(_token, controller, balance);
776     }
777 
778 ////////////////
779 // Events
780 ////////////////
781     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
782     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
783     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
784     event Approval(
785         address indexed _owner,
786         address indexed _spender,
787         uint256 _amount
788         );
789 
790 }
791 
792 
793 contract TokenSale is Owned, TokenController {
794     using SafeMath for uint256;
795     
796     SHP public shp;
797     Trustee public trustee;
798 
799     address public etherEscrowAddress;
800     address public bountyAddress;
801     address public trusteeAddress;
802 
803     uint256 public founderTokenCount = 0;
804     uint256 public reserveTokenCount = 0;
805     uint256 public shpExchangeRate = 0;
806 
807     uint256 constant public CALLER_EXCHANGE_SHARE = 40;
808     uint256 constant public RESERVE_EXCHANGE_SHARE = 30;
809     uint256 constant public FOUNDER_EXCHANGE_SHARE = 20;
810     uint256 constant public BOUNTY_EXCHANGE_SHARE = 10;
811     uint256 constant public MAX_GAS_PRICE = 5000000000000;
812 
813     bool public paused;
814     bool public closed;
815     bool public allowTransfer;
816 
817     mapping(address => bool) public approvedAddresses;
818 
819     event Contribution(uint256 etherAmount, address _caller);
820     event NewSale(address indexed caller, uint256 etherAmount, uint256 tokensGenerated);
821     event SaleClosed(uint256 when);
822     
823     modifier notPaused() {
824         require(!paused);
825         _;
826     }
827 
828     modifier notClosed() {
829         require(!closed);
830         _;
831     }
832 
833     modifier isValidated() {
834         require(msg.sender != 0x0);
835         require(msg.value > 0);
836         require(!isContract(msg.sender)); 
837         require(tx.gasprice <= MAX_GAS_PRICE);
838         _;
839     }
840 
841     function setShpExchangeRate(uint256 _shpExchangeRate) public onlyOwner {
842         shpExchangeRate = _shpExchangeRate;
843     }
844 
845     function setAllowTransfer(bool _allowTransfer) public onlyOwner {
846         allowTransfer = _allowTransfer;
847     }
848 
849     /// @notice This method sends the Ether received to the Ether escrow address
850     /// and generates the calculated number of SHP tokens, sending them to the caller's address.
851     /// It also generates the founder's tokens and the reserve tokens at the same time.
852     function doBuy(
853         address _caller,
854         uint256 etherAmount
855     )
856         internal
857     {
858 
859         Contribution(etherAmount, _caller);
860 
861         uint256 callerExchangeRate = shpExchangeRate.mul(CALLER_EXCHANGE_SHARE).div(100);
862         uint256 reserveExchangeRate = shpExchangeRate.mul(RESERVE_EXCHANGE_SHARE).div(100);
863         uint256 founderExchangeRate = shpExchangeRate.mul(FOUNDER_EXCHANGE_SHARE).div(100);
864         uint256 bountyExchangeRate = shpExchangeRate.mul(BOUNTY_EXCHANGE_SHARE).div(100);
865 
866         uint256 callerTokens = etherAmount.mul(callerExchangeRate);
867         uint256 callerTokensWithDiscount = applyDiscount(etherAmount, callerTokens);
868 
869         uint256 reserveTokens = etherAmount.mul(reserveExchangeRate);
870         uint256 founderTokens = etherAmount.mul(founderExchangeRate);
871         uint256 bountyTokens = etherAmount.mul(bountyExchangeRate);
872         uint256 vestingTokens = founderTokens.add(reserveTokens);
873 
874         founderTokenCount = founderTokenCount.add(founderTokens);
875         reserveTokenCount = reserveTokenCount.add(reserveTokens);
876 
877         shp.generateTokens(_caller, callerTokensWithDiscount);
878         shp.generateTokens(bountyAddress, bountyTokens);
879         shp.generateTokens(trusteeAddress, vestingTokens);
880 
881         NewSale(_caller, etherAmount, callerTokensWithDiscount);
882         NewSale(trusteeAddress, etherAmount, vestingTokens);
883         NewSale(bountyAddress, etherAmount, bountyTokens);
884 
885         etherEscrowAddress.transfer(etherAmount);
886         updateCounters(etherAmount);
887     }
888 
889     /// @notice Allows the owner to manually mint some SHP to an address if something goes wrong
890     /// @param _tokens the number of tokens to mint
891     /// @param _destination the address to send the tokens to
892     function mintTokens(
893         uint256 _tokens, 
894         address _destination
895     ) 
896         onlyOwner 
897     {
898         shp.generateTokens(_destination, _tokens);
899         NewSale(_destination, 0, _tokens);
900     }
901 
902     /// @notice Applies the discount based on the discount tiers
903     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
904     /// @param _contributorTokens The tokens allocated based on the contribution
905     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256);
906 
907     /// @notice Updates the counters for the amount of Ether paid
908     /// @param _etherAmount the amount of Ether paid
909     function updateCounters(uint256 _etherAmount) internal;
910     
911     /// @notice Parent constructor. This needs to be extended from the child contracts
912     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
913     /// @param _bountyAddress the address that will hold the bounty scheme SHP
914     /// @param _trusteeAddress the address that will hold the vesting SHP
915     /// @param _shpExchangeRate the initial SHP exchange rate
916     function TokenSale (
917         address _etherEscrowAddress,
918         address _bountyAddress,
919         address _trusteeAddress,
920         uint256 _shpExchangeRate
921     ) {
922         etherEscrowAddress = _etherEscrowAddress;
923         bountyAddress = _bountyAddress;
924         trusteeAddress = _trusteeAddress;
925         shpExchangeRate = _shpExchangeRate;
926         trustee = Trustee(_trusteeAddress);
927         paused = true;
928         closed = false;
929         allowTransfer = false;
930     }
931 
932     /// @notice Sets the SHP token smart contract
933     /// @param _shp the SHP token contract address
934     function setShp(address _shp) public onlyOwner {
935         shp = SHP(_shp);
936     }
937 
938     /// @notice Transfers ownership of the token smart contract and trustee
939     /// @param _tokenController the address of the new token controller
940     /// @param _trusteeOwner the address of the new trustee owner
941     function transferOwnership(address _tokenController, address _trusteeOwner) public onlyOwner {
942         require(closed);
943         require(_tokenController != 0x0);
944         require(_trusteeOwner != 0x0);
945         shp.changeController(_tokenController);
946         trustee.changeOwner(_trusteeOwner);
947     }
948 
949     /// @notice Internal function to determine if an address is a contract
950     /// @param _caller The address being queried
951     /// @return True if `caller` is a contract
952     function isContract(address _caller) internal constant returns (bool) {
953         uint size;
954         assembly { size := extcodesize(_caller) }
955         return size > 0;
956     }
957 
958     /// @notice Pauses the contribution if there is any issue
959     function pauseContribution() public onlyOwner {
960         paused = true;
961     }
962 
963     /// @notice Resumes the contribution
964     function resumeContribution() public onlyOwner {
965         paused = false;
966     }
967 
968     //////////
969     // MiniMe Controller Interface functions
970     //////////
971 
972     // In between the offering and the network. Default settings for allowing token transfers.
973     function proxyPayment(address) public payable returns (bool) {
974         return allowTransfer;
975     }
976 
977     function onTransfer(address, address, uint256) public returns (bool) {
978         return allowTransfer;
979     }
980 
981     function onApprove(address, address, uint256) public returns (bool) {
982         return allowTransfer;
983     }
984 }
985 
986 
987 ////////////////
988 // MiniMeTokenFactory
989 ////////////////
990 
991 /// @dev This contract is used to generate clone contracts from a contract.
992 ///  In solidity this is the way to create a contract from a contract of the
993 ///  same class
994 contract MiniMeTokenFactory {
995 
996     /// @notice Update the DApp by creating a new token with new functionalities
997     ///  the msg.sender becomes the controller of this clone token
998     /// @param _parentToken Address of the token being cloned
999     /// @param _snapshotBlock Block of the parent token that will
1000     ///  determine the initial distribution of the clone token
1001     /// @param _tokenName Name of the new token
1002     /// @param _decimalUnits Number of decimals of the new token
1003     /// @param _tokenSymbol Token Symbol for the new token
1004     /// @param _transfersEnabled If true, tokens will be able to be transferred
1005     /// @return The address of the new token contract
1006     function createCloneToken(
1007         address _parentToken,
1008         uint _snapshotBlock,
1009         string _tokenName,
1010         uint8 _decimalUnits,
1011         string _tokenSymbol,
1012         bool _transfersEnabled
1013     ) returns (MiniMeToken) 
1014     {
1015         MiniMeToken newToken = new MiniMeToken(
1016             this,
1017             _parentToken,
1018             _snapshotBlock,
1019             _tokenName,
1020             _decimalUnits,
1021             _tokenSymbol,
1022             _transfersEnabled
1023             );
1024 
1025         newToken.changeController(msg.sender);
1026         return newToken;
1027     }
1028 }
1029 
1030 
1031 contract SHP is MiniMeToken {
1032     // @dev SHP constructor
1033     function SHP(address _tokenFactory)
1034             MiniMeToken(
1035                 _tokenFactory,
1036                 0x0,                             // no parent token
1037                 0,                               // no snapshot block number from parent
1038                 "Sharpe Platform Token",         // Token name
1039                 18,                              // Decimals
1040                 "SHP",                           // Symbol
1041                 true                             // Enable transfers
1042             ) {}
1043 }
1044 
1045 
1046 contract SharpeCrowdsale is TokenSale {
1047     using SafeMath for uint256;
1048  
1049     uint256 public etherPaid = 0;
1050     uint256 public totalContributions = 0;
1051 
1052     uint256 constant public FIRST_TIER_DISCOUNT = 5;
1053     uint256 constant public SECOND_TIER_DISCOUNT = 10;
1054     uint256 constant public THIRD_TIER_DISCOUNT = 20;
1055     uint256 constant public FOURTH_TIER_DISCOUNT = 30;
1056 
1057     uint256 public minPresaleContributionEther;
1058     uint256 public maxPresaleContributionEther;
1059     uint256 public minDiscountEther;
1060     uint256 public firstTierDiscountUpperLimitEther;
1061     uint256 public secondTierDiscountUpperLimitEther;
1062     uint256 public thirdTierDiscountUpperLimitEther;
1063     
1064     enum ContributionState {Paused, Resumed}
1065     event ContributionStateChanged(address caller, ContributionState contributionState);
1066     enum AllowedContributionState {Whitelisted, NotWhitelisted, AboveWhitelisted, BelowWhitelisted, WhitelistClosed}
1067     event AllowedContributionCheck(uint256 contribution, AllowedContributionState allowedContributionState);
1068     event ValidContributionCheck(uint256 contribution, bool isContributionValid);
1069     event DiscountApplied(uint256 etherAmount, uint256 tokens, uint256 discount);
1070     event ContributionRefund(uint256 etherAmount, address _caller);
1071     event CountersUpdated(uint256 preSaleEtherPaid, uint256 totalContributions);
1072     event WhitelistedUpdated(uint256 plannedContribution, bool contributed);
1073     event WhitelistedCounterUpdated(uint256 whitelistedPlannedContributions, uint256 usedContributions);
1074 
1075     modifier isValidContribution() {
1076         require(validContribution());
1077         _;
1078     }
1079 
1080     /// @notice called only once when the contract is initialized
1081     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1082     /// @param _bountyAddress the address that will hold the bounty SHP
1083     /// @param _trusteeAddress the address that will hold the vesting SHP
1084     /// @param _minDiscountEther Lower discount limit (WEI)
1085     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1086     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1087     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1088     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1089     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1090     /// @param _shpExchangeRate The initial SHP exchange rate
1091     function SharpeCrowdsale(
1092         address _etherEscrowAddress,
1093         address _bountyAddress,
1094         address _trusteeAddress,
1095         uint256 _minDiscountEther,
1096         uint256 _firstTierDiscountUpperLimitEther,
1097         uint256 _secondTierDiscountUpperLimitEther,
1098         uint256 _thirdTierDiscountUpperLimitEther,
1099         uint256 _minPresaleContributionEther,
1100         uint256 _maxPresaleContributionEther,
1101         uint256 _shpExchangeRate)
1102         TokenSale (
1103             _etherEscrowAddress,
1104             _bountyAddress,
1105             _trusteeAddress,
1106             _shpExchangeRate
1107         )
1108     {
1109         minDiscountEther = _minDiscountEther;
1110         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1111         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1112         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1113         minPresaleContributionEther = _minPresaleContributionEther;
1114         maxPresaleContributionEther = _maxPresaleContributionEther;
1115     }
1116 
1117     /// @notice Allows the owner to peg Ether values
1118     /// @param _minDiscountEther Lower discount limit (WEI)
1119     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1120     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1121     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1122     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1123     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1124     function pegEtherValues(
1125         uint256 _minDiscountEther,
1126         uint256 _firstTierDiscountUpperLimitEther,
1127         uint256 _secondTierDiscountUpperLimitEther,
1128         uint256 _thirdTierDiscountUpperLimitEther,
1129         uint256 _minPresaleContributionEther,
1130         uint256 _maxPresaleContributionEther
1131     ) 
1132         onlyOwner
1133     {
1134         minDiscountEther = _minDiscountEther;
1135         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1136         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1137         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1138         minPresaleContributionEther = _minPresaleContributionEther;
1139         maxPresaleContributionEther = _maxPresaleContributionEther;
1140     }
1141 
1142     /// @notice This function fires when someone sends Ether to the address of this contract.
1143     /// The ETH will be exchanged for SHP and it ensures contributions cannot be made from known addresses.
1144     function ()
1145         public
1146         payable
1147         isValidated
1148         notClosed
1149         notPaused
1150     {
1151         require(msg.value > 0);
1152         doBuy(msg.sender, msg.value);
1153     }
1154 
1155     /// @notice Public function enables closing of the pre-sale manually if necessary
1156     function closeSale() public onlyOwner {
1157         closed = true;
1158         SaleClosed(now);
1159     }
1160 
1161     /// @notice Ensure the contribution is valid
1162     /// @return Returns whether the contribution is valid or not
1163     function validContribution() private returns (bool) {
1164         bool isContributionValid = msg.value >= minPresaleContributionEther && msg.value <= maxPresaleContributionEther;
1165         ValidContributionCheck(msg.value, isContributionValid);
1166         return isContributionValid;
1167     }
1168 
1169     /// @notice Applies the discount based on the discount tiers
1170     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1171     /// @param _contributorTokens The tokens allocated based on the contribution
1172     function applyDiscount(
1173         uint256 _etherAmount, 
1174         uint256 _contributorTokens
1175     )
1176         internal
1177         constant
1178         returns (uint256)
1179     {
1180 
1181         uint256 discount = 0;
1182 
1183         if (_etherAmount > minDiscountEther && _etherAmount <= firstTierDiscountUpperLimitEther) {
1184             discount = _contributorTokens.mul(FIRST_TIER_DISCOUNT).div(100); // 5%
1185         } else if (_etherAmount > firstTierDiscountUpperLimitEther && _etherAmount <= secondTierDiscountUpperLimitEther) {
1186             discount = _contributorTokens.mul(SECOND_TIER_DISCOUNT).div(100); // 10%
1187         } else if (_etherAmount > secondTierDiscountUpperLimitEther && _etherAmount <= thirdTierDiscountUpperLimitEther) {
1188             discount = _contributorTokens.mul(THIRD_TIER_DISCOUNT).div(100); // 20%
1189         } else if (_etherAmount > thirdTierDiscountUpperLimitEther) {
1190             discount = _contributorTokens.mul(FOURTH_TIER_DISCOUNT).div(100); // 30%
1191         }
1192 
1193         DiscountApplied(_etherAmount, _contributorTokens, discount);
1194         return discount.add(_contributorTokens);
1195     }
1196 
1197     /// @notice Updates the counters for the amount of Ether paid
1198     /// @param _etherAmount the amount of Ether paid
1199     function updateCounters(uint256 _etherAmount) internal {
1200         etherPaid = etherPaid.add(_etherAmount);
1201         totalContributions = totalContributions.add(1);
1202         CountersUpdated(etherPaid, _etherAmount);
1203     }
1204 }