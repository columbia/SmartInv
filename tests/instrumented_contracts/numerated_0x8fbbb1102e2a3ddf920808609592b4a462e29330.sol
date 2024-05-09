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
20 /**
21  * Math operations with safety checks
22  */
23 library SafeMath {
24   function mul(uint a, uint b) internal returns (uint) {
25     uint c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint a, uint b) internal returns (uint) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint a, uint b) internal returns (uint) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint a, uint b) internal returns (uint) {
43     uint c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 
48   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
49     return a >= b ? a : b;
50   }
51 
52   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
53     return a < b ? a : b;
54   }
55 
56   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
57     return a >= b ? a : b;
58   }
59 
60   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
61     return a < b ? a : b;
62   }
63 }
64 
65 
66 
67 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
68 ///  later changed
69 contract Owned {
70 
71     /// @dev `owner` is the only address that can call a function with this
72     /// modifier
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     address public owner;
79 
80     /// @notice The Constructor assigns the message sender to be `owner`
81     function Owned() {
82         owner = msg.sender;
83     }
84 
85     address public newOwner;
86 
87     /// @notice `owner` can step down and assign some other address to this role
88     /// @param _newOwner The address of the new owner. 0x0 can be used to create
89     function changeOwner(address _newOwner) onlyOwner {
90         if(msg.sender == owner) {
91             owner = _newOwner;
92         }
93     }
94 }
95 
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
260 
261 
262 
263 
264 
265 /// @dev The token controller contract must implement these functions
266 contract TokenController {
267     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
268     /// @param _owner The address that sent the ether to create tokens
269     /// @return True if the ether is accepted, false if it throws
270     function proxyPayment(address _owner) payable returns(bool);
271 
272     /// @notice Notifies the controller about a token transfer allowing the
273     ///  controller to react if desired
274     /// @param _from The origin of the transfer
275     /// @param _to The destination of the transfer
276     /// @param _amount The amount of the transfer
277     /// @return False if the controller does not authorize the transfer
278     function onTransfer(address _from, address _to, uint _amount) returns(bool);
279 
280     /// @notice Notifies the controller about an approval allowing the
281     ///  controller to react if desired
282     /// @param _owner The address that calls `approve()`
283     /// @param _spender The spender in the `approve()` call
284     /// @param _amount The amount in the `approve()` call
285     /// @return False if the controller does not authorize the approval
286     function onApprove(address _owner, address _spender, uint _amount)
287         returns(bool);
288 }
289 
290 contract Controlled {
291     /// @notice The address of the controller is the only address that can call
292     ///  a function with this modifier
293     modifier onlyController { require(msg.sender == controller); _; }
294 
295     address public controller;
296 
297     function Controlled() { controller = msg.sender;}
298 
299     /// @notice Changes the controller of the contract
300     /// @param _newController The new controller of the contract
301     function changeController(address _newController) onlyController {
302         controller = _newController;
303     }
304 }
305 
306 contract ApproveAndCallFallBack {
307     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
308 }
309 
310 /// @dev The actual token contract, the default controller is the msg.sender
311 ///  that deploys the contract, so usually this token will be deployed by a
312 ///  token controller contract, which Giveth will call a "Campaign"
313 contract MiniMeToken is Controlled {
314 
315     string public name;                //The Token's name: e.g. DigixDAO Tokens
316     uint8 public decimals;             //Number of decimals of the smallest unit
317     string public symbol;              //An identifier: e.g. REP
318     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
319 
320 
321     /// @dev `Checkpoint` is the structure that attaches a block number to a
322     ///  given value, the block number attached is the one that last changed the
323     ///  value
324     struct  Checkpoint {
325 
326         // `fromBlock` is the block number that the value was generated from
327         uint128 fromBlock;
328 
329         // `value` is the amount of tokens at a specific block number
330         uint128 value;
331     }
332 
333     // `parentToken` is the Token address that was cloned to produce this token;
334     //  it will be 0x0 for a token that was not cloned
335     MiniMeToken public parentToken;
336 
337     // `parentSnapShotBlock` is the block number from the Parent Token that was
338     //  used to determine the initial distribution of the Clone Token
339     uint public parentSnapShotBlock;
340 
341     // `creationBlock` is the block number that the Clone Token was created
342     uint public creationBlock;
343 
344     // `balances` is the map that tracks the balance of each address, in this
345     //  contract when the balance changes the block number that the change
346     //  occurred is also included in the map
347     mapping (address => Checkpoint[]) balances;
348 
349     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
350     mapping (address => mapping (address => uint256)) allowed;
351 
352     // Tracks the history of the `totalSupply` of the token
353     Checkpoint[] totalSupplyHistory;
354 
355     // Flag that determines if the token is transferable or not.
356     bool public transfersEnabled;
357 
358     // The factory used to create new clone tokens
359     MiniMeTokenFactory public tokenFactory;
360 
361 ////////////////
362 // Constructor
363 ////////////////
364 
365     /// @notice Constructor to create a MiniMeToken
366     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
367     ///  will create the Clone token contracts, the token factory needs to be
368     ///  deployed first
369     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
370     ///  new token
371     /// @param _parentSnapShotBlock Block of the parent token that will
372     ///  determine the initial distribution of the clone token, set to 0 if it
373     ///  is a new token
374     /// @param _tokenName Name of the new token
375     /// @param _decimalUnits Number of decimals of the new token
376     /// @param _tokenSymbol Token Symbol for the new token
377     /// @param _transfersEnabled If true, tokens will be able to be transferred
378     function MiniMeToken(
379         address _tokenFactory,
380         address _parentToken,
381         uint _parentSnapShotBlock,
382         string _tokenName,
383         uint8 _decimalUnits,
384         string _tokenSymbol,
385         bool _transfersEnabled
386     ) {
387         tokenFactory = MiniMeTokenFactory(_tokenFactory);
388         name = _tokenName;                                 // Set the name
389         decimals = _decimalUnits;                          // Set the decimals
390         symbol = _tokenSymbol;                             // Set the symbol
391         parentToken = MiniMeToken(_parentToken);
392         parentSnapShotBlock = _parentSnapShotBlock;
393         transfersEnabled = _transfersEnabled;
394         creationBlock = block.number;
395     }
396 
397 
398 ///////////////////
399 // ERC20 Methods
400 ///////////////////
401 
402     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
403     /// @param _to The address of the recipient
404     /// @param _amount The amount of tokens to be transferred
405     /// @return Whether the transfer was successful or not
406     function transfer(address _to, uint256 _amount) returns (bool success) {
407         require(transfersEnabled);
408         return doTransfer(msg.sender, _to, _amount);
409     }
410 
411     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
412     ///  is approved by `_from`
413     /// @param _from The address holding the tokens being transferred
414     /// @param _to The address of the recipient
415     /// @param _amount The amount of tokens to be transferred
416     /// @return True if the transfer was successful
417     function transferFrom(address _from, address _to, uint256 _amount
418     ) returns (bool success) {
419 
420         // The controller of this contract can move tokens around at will,
421         //  this is important to recognize! Confirm that you trust the
422         //  controller of this contract, which in most situations should be
423         //  another open source smart contract or 0x0
424         if (msg.sender != controller) {
425             require(transfersEnabled);
426 
427             // The standard ERC 20 transferFrom functionality
428             if (allowed[_from][msg.sender] < _amount) return false;
429             allowed[_from][msg.sender] -= _amount;
430         }
431         return doTransfer(_from, _to, _amount);
432     }
433 
434     /// @dev This is the actual transfer function in the token contract, it can
435     ///  only be called by other functions in this contract.
436     /// @param _from The address holding the tokens being transferred
437     /// @param _to The address of the recipient
438     /// @param _amount The amount of tokens to be transferred
439     /// @return True if the transfer was successful
440     function doTransfer(address _from, address _to, uint _amount
441     ) internal returns(bool) {
442 
443            if (_amount == 0) {
444                return true;
445            }
446 
447            require(parentSnapShotBlock < block.number);
448 
449            // Do not allow transfer to 0x0 or the token contract itself
450            require((_to != 0) && (_to != address(this)));
451 
452            // If the amount being transfered is more than the balance of the
453            //  account the transfer returns false
454            var previousBalanceFrom = balanceOfAt(_from, block.number);
455            if (previousBalanceFrom < _amount) {
456                return false;
457            }
458 
459            // Alerts the token controller of the transfer
460            if (isContract(controller)) {
461                require(TokenController(controller).onTransfer(_from, _to, _amount));
462            }
463 
464            // First update the balance array with the new value for the address
465            //  sending the tokens
466            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
467 
468            // Then update the balance array with the new value for the address
469            //  receiving the tokens
470            var previousBalanceTo = balanceOfAt(_to, block.number);
471            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
472            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
473 
474            // An event to make the transfer easy to find on the blockchain
475            Transfer(_from, _to, _amount);
476 
477            return true;
478     }
479 
480     /// @param _owner The address that's balance is being requested
481     /// @return The balance of `_owner` at the current block
482     function balanceOf(address _owner) constant returns (uint256 balance) {
483         return balanceOfAt(_owner, block.number);
484     }
485 
486     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
487     ///  its behalf. This is a modified version of the ERC20 approve function
488     ///  to be a little bit safer
489     /// @param _spender The address of the account able to transfer the tokens
490     /// @param _amount The amount of tokens to be approved for transfer
491     /// @return True if the approval was successful
492     function approve(address _spender, uint256 _amount) returns (bool success) {
493         require(transfersEnabled);
494 
495         // To change the approve amount you first have to reduce the addresses`
496         //  allowance to zero by calling `approve(_spender,0)` if it is not
497         //  already 0 to mitigate the race condition described here:
498         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
499         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
500 
501         // Alerts the token controller of the approve function call
502         if (isContract(controller)) {
503             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
504         }
505 
506         allowed[msg.sender][_spender] = _amount;
507         Approval(msg.sender, _spender, _amount);
508         return true;
509     }
510 
511     /// @dev This function makes it easy to read the `allowed[]` map
512     /// @param _owner The address of the account that owns the token
513     /// @param _spender The address of the account able to transfer the tokens
514     /// @return Amount of remaining tokens of _owner that _spender is allowed
515     ///  to spend
516     function allowance(address _owner, address _spender
517     ) constant returns (uint256 remaining) {
518         return allowed[_owner][_spender];
519     }
520 
521     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
522     ///  its behalf, and then a function is triggered in the contract that is
523     ///  being approved, `_spender`. This allows users to use their tokens to
524     ///  interact with contracts in one function call instead of two
525     /// @param _spender The address of the contract able to transfer the tokens
526     /// @param _amount The amount of tokens to be approved for transfer
527     /// @return True if the function call was successful
528     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
529     ) returns (bool success) {
530         require(approve(_spender, _amount));
531 
532         ApproveAndCallFallBack(_spender).receiveApproval(
533             msg.sender,
534             _amount,
535             this,
536             _extraData
537         );
538 
539         return true;
540     }
541 
542     /// @dev This function makes it easy to get the total number of tokens
543     /// @return The total number of tokens
544     function totalSupply() constant returns (uint) {
545         return totalSupplyAt(block.number);
546     }
547 
548 
549 ////////////////
550 // Query balance and totalSupply in History
551 ////////////////
552 
553     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
554     /// @param _owner The address from which the balance will be retrieved
555     /// @param _blockNumber The block number when the balance is queried
556     /// @return The balance at `_blockNumber`
557     function balanceOfAt(address _owner, uint _blockNumber) constant
558         returns (uint) {
559 
560         // These next few lines are used when the balance of the token is
561         //  requested before a check point was ever created for this token, it
562         //  requires that the `parentToken.balanceOfAt` be queried at the
563         //  genesis block for that token as this contains initial balance of
564         //  this token
565         if ((balances[_owner].length == 0)
566             || (balances[_owner][0].fromBlock > _blockNumber)) {
567             if (address(parentToken) != 0) {
568                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
569             } else {
570                 // Has no parent
571                 return 0;
572             }
573 
574         // This will return the expected balance during normal situations
575         } else {
576             return getValueAt(balances[_owner], _blockNumber);
577         }
578     }
579 
580     /// @notice Total amount of tokens at a specific `_blockNumber`.
581     /// @param _blockNumber The block number when the totalSupply is queried
582     /// @return The total amount of tokens at `_blockNumber`
583     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
584 
585         // These next few lines are used when the totalSupply of the token is
586         //  requested before a check point was ever created for this token, it
587         //  requires that the `parentToken.totalSupplyAt` be queried at the
588         //  genesis block for this token as that contains totalSupply of this
589         //  token at this block number.
590         if ((totalSupplyHistory.length == 0)
591             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
592             if (address(parentToken) != 0) {
593                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
594             } else {
595                 return 0;
596             }
597 
598         // This will return the expected totalSupply during normal situations
599         } else {
600             return getValueAt(totalSupplyHistory, _blockNumber);
601         }
602     }
603 
604 ////////////////
605 // Clone Token Method
606 ////////////////
607 
608     /// @notice Creates a new clone token with the initial distribution being
609     ///  this token at `_snapshotBlock`
610     /// @param _cloneTokenName Name of the clone token
611     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
612     /// @param _cloneTokenSymbol Symbol of the clone token
613     /// @param _snapshotBlock Block when the distribution of the parent token is
614     ///  copied to set the initial distribution of the new clone token;
615     ///  if the block is zero than the actual block, the current block is used
616     /// @param _transfersEnabled True if transfers are allowed in the clone
617     /// @return The address of the new MiniMeToken Contract
618     function createCloneToken(
619         string _cloneTokenName,
620         uint8 _cloneDecimalUnits,
621         string _cloneTokenSymbol,
622         uint _snapshotBlock,
623         bool _transfersEnabled
624         ) returns(address) {
625         if (_snapshotBlock == 0) _snapshotBlock = block.number;
626         MiniMeToken cloneToken = tokenFactory.createCloneToken(
627             this,
628             _snapshotBlock,
629             _cloneTokenName,
630             _cloneDecimalUnits,
631             _cloneTokenSymbol,
632             _transfersEnabled
633             );
634 
635         cloneToken.changeController(msg.sender);
636 
637         // An event to make the token easy to find on the blockchain
638         NewCloneToken(address(cloneToken), _snapshotBlock);
639         return address(cloneToken);
640     }
641 
642 ////////////////
643 // Generate and destroy tokens
644 ////////////////
645 
646     /// @notice Generates `_amount` tokens that are assigned to `_owner`
647     /// @param _owner The address that will be assigned the new tokens
648     /// @param _amount The quantity of tokens generated
649     /// @return True if the tokens are generated correctly
650     function generateTokens(address _owner, uint _amount
651     ) onlyController returns (bool) {
652         uint curTotalSupply = totalSupply();
653         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
654         uint previousBalanceTo = balanceOf(_owner);
655         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
656         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
657         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
658         Transfer(0, _owner, _amount);
659         return true;
660     }
661 
662 
663     /// @notice Burns `_amount` tokens from `_owner`
664     /// @param _owner The address that will lose the tokens
665     /// @param _amount The quantity of tokens to burn
666     /// @return True if the tokens are burned correctly
667     function destroyTokens(address _owner, uint _amount
668     ) onlyController returns (bool) {
669         uint curTotalSupply = totalSupply();
670         require(curTotalSupply >= _amount);
671         uint previousBalanceFrom = balanceOf(_owner);
672         require(previousBalanceFrom >= _amount);
673         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
674         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
675         Transfer(_owner, 0, _amount);
676         return true;
677     }
678 
679 ////////////////
680 // Enable tokens transfers
681 ////////////////
682 
683 
684     /// @notice Enables token holders to transfer their tokens freely if true
685     /// @param _transfersEnabled True if transfers are allowed in the clone
686     function enableTransfers(bool _transfersEnabled) onlyController {
687         transfersEnabled = _transfersEnabled;
688     }
689 
690 ////////////////
691 // Internal helper functions to query and set a value in a snapshot array
692 ////////////////
693 
694     /// @dev `getValueAt` retrieves the number of tokens at a given block number
695     /// @param checkpoints The history of values being queried
696     /// @param _block The block number to retrieve the value at
697     /// @return The number of tokens being queried
698     function getValueAt(Checkpoint[] storage checkpoints, uint _block
699     ) constant internal returns (uint) {
700         if (checkpoints.length == 0) return 0;
701 
702         // Shortcut for the actual value
703         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
704             return checkpoints[checkpoints.length-1].value;
705         if (_block < checkpoints[0].fromBlock) return 0;
706 
707         // Binary search of the value in the array
708         uint min = 0;
709         uint max = checkpoints.length-1;
710         while (max > min) {
711             uint mid = (max + min + 1)/ 2;
712             if (checkpoints[mid].fromBlock<=_block) {
713                 min = mid;
714             } else {
715                 max = mid-1;
716             }
717         }
718         return checkpoints[min].value;
719     }
720 
721     /// @dev `updateValueAtNow` used to update the `balances` map and the
722     ///  `totalSupplyHistory`
723     /// @param checkpoints The history of data being updated
724     /// @param _value The new number of tokens
725     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
726     ) internal  {
727         if ((checkpoints.length == 0)
728         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
729                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
730                newCheckPoint.fromBlock =  uint128(block.number);
731                newCheckPoint.value = uint128(_value);
732            } else {
733                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
734                oldCheckPoint.value = uint128(_value);
735            }
736     }
737 
738     /// @dev Internal function to determine if an address is a contract
739     /// @param _addr The address being queried
740     /// @return True if `_addr` is a contract
741     function isContract(address _addr) constant internal returns(bool) {
742         uint size;
743         if (_addr == 0) return false;
744         assembly {
745             size := extcodesize(_addr)
746         }
747         return size>0;
748     }
749 
750     /// @dev Helper function to return a min betwen the two uints
751     function min(uint a, uint b) internal returns (uint) {
752         return a < b ? a : b;
753     }
754 
755     /// @notice The fallback function: If the contract's controller has not been
756     ///  set to 0, then the `proxyPayment` method is called which relays the
757     ///  ether and creates tokens as described in the token controller contract
758     function ()  payable {
759         require(isContract(controller));
760         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
761     }
762 
763 //////////
764 // Safety Methods
765 //////////
766 
767     /// @notice This method can be used by the controller to extract mistakenly
768     ///  sent tokens to this contract.
769     /// @param _token The address of the token contract that you want to recover
770     ///  set to 0 in case you want to extract ether.
771     function claimTokens(address _token) onlyController {
772         if (_token == 0x0) {
773             controller.transfer(this.balance);
774             return;
775         }
776 
777         MiniMeToken token = MiniMeToken(_token);
778         uint balance = token.balanceOf(this);
779         token.transfer(controller, balance);
780         ClaimedTokens(_token, controller, balance);
781     }
782 
783 ////////////////
784 // Events
785 ////////////////
786     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
787     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
788     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
789     event Approval(
790         address indexed _owner,
791         address indexed _spender,
792         uint256 _amount
793         );
794 
795 }
796 
797 
798 ////////////////
799 // MiniMeTokenFactory
800 ////////////////
801 
802 /// @dev This contract is used to generate clone contracts from a contract.
803 ///  In solidity this is the way to create a contract from a contract of the
804 ///  same class
805 contract MiniMeTokenFactory {
806 
807     /// @notice Update the DApp by creating a new token with new functionalities
808     ///  the msg.sender becomes the controller of this clone token
809     /// @param _parentToken Address of the token being cloned
810     /// @param _snapshotBlock Block of the parent token that will
811     ///  determine the initial distribution of the clone token
812     /// @param _tokenName Name of the new token
813     /// @param _decimalUnits Number of decimals of the new token
814     /// @param _tokenSymbol Token Symbol for the new token
815     /// @param _transfersEnabled If true, tokens will be able to be transferred
816     /// @return The address of the new token contract
817     function createCloneToken(
818         address _parentToken,
819         uint _snapshotBlock,
820         string _tokenName,
821         uint8 _decimalUnits,
822         string _tokenSymbol,
823         bool _transfersEnabled
824     ) returns (MiniMeToken) 
825     {
826         MiniMeToken newToken = new MiniMeToken(
827             this,
828             _parentToken,
829             _snapshotBlock,
830             _tokenName,
831             _decimalUnits,
832             _tokenSymbol,
833             _transfersEnabled
834             );
835 
836         newToken.changeController(msg.sender);
837         return newToken;
838     }
839 }
840 
841 
842 contract SHP is MiniMeToken {
843     // @dev SHP constructor
844     function SHP(address _tokenFactory)
845             MiniMeToken(
846                 _tokenFactory,
847                 0x0,                             // no parent token
848                 0,                               // no snapshot block number from parent
849                 "Sharpe Platform Token",         // Token name
850                 18,                              // Decimals
851                 "SHP",                           // Symbol
852                 true                             // Enable transfers
853             ) {}
854 }
855 
856 
857 
858 contract TokenSale is Owned, TokenController {
859     using SafeMath for uint256;
860     
861     SHP public shp;
862     Trustee public trustee;
863 
864     address public etherEscrowAddress;
865     address public bountyAddress;
866     address public trusteeAddress;
867 
868     uint256 public founderTokenCount = 0;
869     uint256 public reserveTokenCount = 0;
870     uint256 public shpExchangeRate = 0;
871 
872     uint256 constant public CALLER_EXCHANGE_SHARE = 40;
873     uint256 constant public RESERVE_EXCHANGE_SHARE = 30;
874     uint256 constant public FOUNDER_EXCHANGE_SHARE = 20;
875     uint256 constant public BOUNTY_EXCHANGE_SHARE = 10;
876     uint256 constant public MAX_GAS_PRICE = 50000000000;
877 
878     bool public paused;
879     bool public closed;
880     bool public allowTransfer;
881 
882     mapping(address => bool) public approvedAddresses;
883 
884     event Contribution(uint256 etherAmount, address _caller);
885     event NewSale(address indexed caller, uint256 etherAmount, uint256 tokensGenerated);
886     event SaleClosed(uint256 when);
887     
888     modifier notPaused() {
889         require(!paused);
890         _;
891     }
892 
893     modifier notClosed() {
894         require(!closed);
895         _;
896     }
897 
898     modifier isValidated() {
899         require(msg.sender != 0x0);
900         require(msg.value > 0);
901         require(!isContract(msg.sender)); 
902         require(tx.gasprice <= MAX_GAS_PRICE);
903         _;
904     }
905 
906     function setShpExchangeRate(uint256 _shpExchangeRate) public onlyOwner {
907         shpExchangeRate = _shpExchangeRate;
908     }
909 
910     function setAllowTransfer(bool _allowTransfer) public onlyOwner {
911         allowTransfer = _allowTransfer;
912     }
913 
914     /// @notice This method sends the Ether received to the Ether escrow address
915     /// and generates the calculated number of SHP tokens, sending them to the caller's address.
916     /// It also generates the founder's tokens and the reserve tokens at the same time.
917     function doBuy(
918         address _caller,
919         uint256 etherAmount
920     )
921         internal
922     {
923 
924         Contribution(etherAmount, _caller);
925 
926         uint256 callerExchangeRate = shpExchangeRate.mul(CALLER_EXCHANGE_SHARE).div(100);
927         uint256 reserveExchangeRate = shpExchangeRate.mul(RESERVE_EXCHANGE_SHARE).div(100);
928         uint256 founderExchangeRate = shpExchangeRate.mul(FOUNDER_EXCHANGE_SHARE).div(100);
929         uint256 bountyExchangeRate = shpExchangeRate.mul(BOUNTY_EXCHANGE_SHARE).div(100);
930 
931         uint256 callerTokens = etherAmount.mul(callerExchangeRate);
932         uint256 callerTokensWithDiscount = applyDiscount(etherAmount, callerTokens);
933 
934         uint256 reserveTokens = etherAmount.mul(reserveExchangeRate);
935         uint256 founderTokens = etherAmount.mul(founderExchangeRate);
936         uint256 bountyTokens = etherAmount.mul(bountyExchangeRate);
937         uint256 vestingTokens = founderTokens.add(reserveTokens);
938 
939         founderTokenCount = founderTokenCount.add(founderTokens);
940         reserveTokenCount = reserveTokenCount.add(reserveTokens);
941 
942         shp.generateTokens(_caller, callerTokensWithDiscount);
943         shp.generateTokens(bountyAddress, bountyTokens);
944         shp.generateTokens(trusteeAddress, vestingTokens);
945 
946         NewSale(_caller, etherAmount, callerTokensWithDiscount);
947         NewSale(trusteeAddress, etherAmount, vestingTokens);
948         NewSale(bountyAddress, etherAmount, bountyTokens);
949 
950         etherEscrowAddress.transfer(etherAmount);
951         updateCounters(etherAmount);
952     }
953 
954     /// @notice Allows the owner to manually mint some SHP to an address if something goes wrong
955     /// @param _tokens the number of tokens to mint
956     /// @param _destination the address to send the tokens to
957     function mintTokens(
958         uint256 _tokens, 
959         address _destination
960     ) 
961         onlyOwner 
962     {
963         shp.generateTokens(_destination, _tokens);
964         NewSale(_destination, 0, _tokens);
965     }
966 
967     /// @notice Applies the discount based on the discount tiers
968     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
969     /// @param _contributorTokens The tokens allocated based on the contribution
970     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256);
971 
972     /// @notice Updates the counters for the amount of Ether paid
973     /// @param _etherAmount the amount of Ether paid
974     function updateCounters(uint256 _etherAmount) internal;
975     
976     /// @notice Parent constructor. This needs to be extended from the child contracts
977     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
978     /// @param _bountyAddress the address that will hold the bounty scheme SHP
979     /// @param _trusteeAddress the address that will hold the vesting SHP
980     /// @param _shpExchangeRate the initial SHP exchange rate
981     function TokenSale (
982         address _etherEscrowAddress,
983         address _bountyAddress,
984         address _trusteeAddress,
985         uint256 _shpExchangeRate
986     ) {
987         etherEscrowAddress = _etherEscrowAddress;
988         bountyAddress = _bountyAddress;
989         trusteeAddress = _trusteeAddress;
990         shpExchangeRate = _shpExchangeRate;
991         trustee = Trustee(_trusteeAddress);
992         paused = true;
993         closed = false;
994         allowTransfer = false;
995     }
996 
997     /// @notice Sets the SHP token smart contract
998     /// @param _shp the SHP token contract address
999     function setShp(address _shp) public onlyOwner {
1000         shp = SHP(_shp);
1001     }
1002 
1003     /// @notice Transfers ownership of the token smart contract and trustee
1004     /// @param _tokenController the address of the new token controller
1005     /// @param _trusteeOwner the address of the new trustee owner
1006     function transferOwnership(address _tokenController, address _trusteeOwner) public onlyOwner {
1007         require(closed);
1008         require(_tokenController != 0x0);
1009         require(_trusteeOwner != 0x0);
1010         shp.changeController(_tokenController);
1011         trustee.changeOwner(_trusteeOwner);
1012     }
1013 
1014     /// @notice Internal function to determine if an address is a contract
1015     /// @param _caller The address being queried
1016     /// @return True if `caller` is a contract
1017     function isContract(address _caller) internal constant returns (bool) {
1018         uint size;
1019         assembly { size := extcodesize(_caller) }
1020         return size > 0;
1021     }
1022 
1023     /// @notice Pauses the contribution if there is any issue
1024     function pauseContribution() public onlyOwner {
1025         paused = true;
1026     }
1027 
1028     /// @notice Resumes the contribution
1029     function resumeContribution() public onlyOwner {
1030         paused = false;
1031     }
1032 
1033     //////////
1034     // MiniMe Controller Interface functions
1035     //////////
1036 
1037     // In between the offering and the network. Default settings for allowing token transfers.
1038     function proxyPayment(address) public payable returns (bool) {
1039         return allowTransfer;
1040     }
1041 
1042     function onTransfer(address, address, uint256) public returns (bool) {
1043         return allowTransfer;
1044     }
1045 
1046     function onApprove(address, address, uint256) public returns (bool) {
1047         return allowTransfer;
1048     }
1049 }
1050 
1051 
1052 
1053 contract SharpeCrowdsale is TokenSale {
1054     using SafeMath for uint256;
1055  
1056     uint256 public etherPaid = 0;
1057     uint256 public totalContributions = 0;
1058 
1059     uint256 constant public FIRST_TIER_DISCOUNT = 5;
1060     uint256 constant public SECOND_TIER_DISCOUNT = 10;
1061     uint256 constant public THIRD_TIER_DISCOUNT = 20;
1062     uint256 constant public FOURTH_TIER_DISCOUNT = 30;
1063 
1064     uint256 public minPresaleContributionEther;
1065     uint256 public maxPresaleContributionEther;
1066     uint256 public minDiscountEther;
1067     uint256 public firstTierDiscountUpperLimitEther;
1068     uint256 public secondTierDiscountUpperLimitEther;
1069     uint256 public thirdTierDiscountUpperLimitEther;
1070     
1071     enum ContributionState {Paused, Resumed}
1072     event ContributionStateChanged(address caller, ContributionState contributionState);
1073     enum AllowedContributionState {Whitelisted, NotWhitelisted, AboveWhitelisted, BelowWhitelisted, WhitelistClosed}
1074     event AllowedContributionCheck(uint256 contribution, AllowedContributionState allowedContributionState);
1075     event ValidContributionCheck(uint256 contribution, bool isContributionValid);
1076     event DiscountApplied(uint256 etherAmount, uint256 tokens, uint256 discount);
1077     event ContributionRefund(uint256 etherAmount, address _caller);
1078     event CountersUpdated(uint256 preSaleEtherPaid, uint256 totalContributions);
1079     event WhitelistedUpdated(uint256 plannedContribution, bool contributed);
1080     event WhitelistedCounterUpdated(uint256 whitelistedPlannedContributions, uint256 usedContributions);
1081 
1082     modifier isValidContribution() {
1083         require(validContribution());
1084         _;
1085     }
1086 
1087     /// @notice called only once when the contract is initialized
1088     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1089     /// @param _bountyAddress the address that will hold the bounty SHP
1090     /// @param _trusteeAddress the address that will hold the vesting SHP
1091     /// @param _minDiscountEther Lower discount limit (WEI)
1092     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1093     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1094     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1095     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1096     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1097     /// @param _shpExchangeRate The initial SHP exchange rate
1098     function SharpeCrowdsale(
1099         address _etherEscrowAddress,
1100         address _bountyAddress,
1101         address _trusteeAddress,
1102         uint256 _minDiscountEther,
1103         uint256 _firstTierDiscountUpperLimitEther,
1104         uint256 _secondTierDiscountUpperLimitEther,
1105         uint256 _thirdTierDiscountUpperLimitEther,
1106         uint256 _minPresaleContributionEther,
1107         uint256 _maxPresaleContributionEther,
1108         uint256 _shpExchangeRate)
1109         TokenSale (
1110             _etherEscrowAddress,
1111             _bountyAddress,
1112             _trusteeAddress,
1113             _shpExchangeRate
1114         )
1115     {
1116         minDiscountEther = _minDiscountEther;
1117         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1118         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1119         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1120         minPresaleContributionEther = _minPresaleContributionEther;
1121         maxPresaleContributionEther = _maxPresaleContributionEther;
1122     }
1123 
1124     /// @notice Allows the owner to peg Ether values
1125     /// @param _minDiscountEther Lower discount limit (WEI)
1126     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1127     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1128     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1129     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1130     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1131     function pegEtherValues(
1132         uint256 _minDiscountEther,
1133         uint256 _firstTierDiscountUpperLimitEther,
1134         uint256 _secondTierDiscountUpperLimitEther,
1135         uint256 _thirdTierDiscountUpperLimitEther,
1136         uint256 _minPresaleContributionEther,
1137         uint256 _maxPresaleContributionEther
1138     ) 
1139         onlyOwner
1140     {
1141         minDiscountEther = _minDiscountEther;
1142         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1143         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1144         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1145         minPresaleContributionEther = _minPresaleContributionEther;
1146         maxPresaleContributionEther = _maxPresaleContributionEther;
1147     }
1148 
1149     /// @notice This function fires when someone sends Ether to the address of this contract.
1150     /// The ETH will be exchanged for SHP and it ensures contributions cannot be made from known addresses.
1151     function ()
1152         public
1153         payable
1154         isValidated
1155         notClosed
1156         notPaused
1157     {
1158         require(msg.value > 0);
1159         doBuy(msg.sender, msg.value);
1160     }
1161 
1162     /// @notice Public function enables closing of the pre-sale manually if necessary
1163     function closeSale() public onlyOwner {
1164         closed = true;
1165         SaleClosed(now);
1166     }
1167 
1168     /// @notice Ensure the contribution is valid
1169     /// @return Returns whether the contribution is valid or not
1170     function validContribution() private returns (bool) {
1171         bool isContributionValid = msg.value >= minPresaleContributionEther && msg.value <= maxPresaleContributionEther;
1172         ValidContributionCheck(msg.value, isContributionValid);
1173         return isContributionValid;
1174     }
1175 
1176     /// @notice Applies the discount based on the discount tiers
1177     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1178     /// @param _contributorTokens The tokens allocated based on the contribution
1179     function applyDiscount(
1180         uint256 _etherAmount, 
1181         uint256 _contributorTokens
1182     )
1183         internal
1184         constant
1185         returns (uint256)
1186     {
1187 
1188         uint256 discount = 0;
1189 
1190         if (_etherAmount > minDiscountEther && _etherAmount <= firstTierDiscountUpperLimitEther) {
1191             discount = _contributorTokens.mul(FIRST_TIER_DISCOUNT).div(100); // 5%
1192         } else if (_etherAmount > firstTierDiscountUpperLimitEther && _etherAmount <= secondTierDiscountUpperLimitEther) {
1193             discount = _contributorTokens.mul(SECOND_TIER_DISCOUNT).div(100); // 10%
1194         } else if (_etherAmount > secondTierDiscountUpperLimitEther && _etherAmount <= thirdTierDiscountUpperLimitEther) {
1195             discount = _contributorTokens.mul(THIRD_TIER_DISCOUNT).div(100); // 20%
1196         } else if (_etherAmount > thirdTierDiscountUpperLimitEther) {
1197             discount = _contributorTokens.mul(FOURTH_TIER_DISCOUNT).div(100); // 30%
1198         }
1199 
1200         DiscountApplied(_etherAmount, _contributorTokens, discount);
1201         return discount.add(_contributorTokens);
1202     }
1203 
1204     /// @notice Updates the counters for the amount of Ether paid
1205     /// @param _etherAmount the amount of Ether paid
1206     function updateCounters(uint256 _etherAmount) internal {
1207         etherPaid = etherPaid.add(_etherAmount);
1208         totalContributions = totalContributions.add(1);
1209         CountersUpdated(etherPaid, _etherAmount);
1210     }
1211 }