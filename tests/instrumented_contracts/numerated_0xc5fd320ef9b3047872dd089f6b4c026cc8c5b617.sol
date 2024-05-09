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
19 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
20 ///  later changed
21 contract Owned {
22 
23     /// @dev `owner` is the only address that can call a function with this
24     /// modifier
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     address public owner;
31 
32     /// @notice The Constructor assigns the message sender to be `owner`
33     function Owned() {
34         owner = msg.sender;
35     }
36 
37     address public newOwner;
38 
39     /// @notice `owner` can step down and assign some other address to this role
40     /// @param _newOwner The address of the new owner. 0x0 can be used to create
41     function changeOwner(address _newOwner) onlyOwner {
42         if(msg.sender == owner) {
43             owner = _newOwner;
44         }
45     }
46 }
47 
48 
49 
50 /**
51  * Math operations with safety checks
52  */
53 library SafeMath {
54   function mul(uint a, uint b) internal returns (uint) {
55     uint c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59 
60   function div(uint a, uint b) internal returns (uint) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66 
67   function sub(uint a, uint b) internal returns (uint) {
68     assert(b <= a);
69     return a - b;
70   }
71 
72   function add(uint a, uint b) internal returns (uint) {
73     uint c = a + b;
74     assert(c >= a);
75     return c;
76   }
77 
78   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
79     return a >= b ? a : b;
80   }
81 
82   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
83     return a < b ? a : b;
84   }
85 
86   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
87     return a >= b ? a : b;
88   }
89 
90   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
91     return a < b ? a : b;
92   }
93 }
94 
95 
96 
97 
98 
99 
100 /// @dev The token controller contract must implement these functions
101 contract TokenController {
102     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
103     /// @param _owner The address that sent the ether to create tokens
104     /// @return True if the ether is accepted, false if it throws
105     function proxyPayment(address _owner) payable returns(bool);
106 
107     /// @notice Notifies the controller about a token transfer allowing the
108     ///  controller to react if desired
109     /// @param _from The origin of the transfer
110     /// @param _to The destination of the transfer
111     /// @param _amount The amount of the transfer
112     /// @return False if the controller does not authorize the transfer
113     function onTransfer(address _from, address _to, uint _amount) returns(bool);
114 
115     /// @notice Notifies the controller about an approval allowing the
116     ///  controller to react if desired
117     /// @param _owner The address that calls `approve()`
118     /// @param _spender The spender in the `approve()` call
119     /// @param _amount The amount in the `approve()` call
120     /// @return False if the controller does not authorize the approval
121     function onApprove(address _owner, address _spender, uint _amount)
122         returns(bool);
123 }
124 
125 contract Controlled {
126     /// @notice The address of the controller is the only address that can call
127     ///  a function with this modifier
128     modifier onlyController { require(msg.sender == controller); _; }
129 
130     address public controller;
131 
132     function Controlled() { controller = msg.sender;}
133 
134     /// @notice Changes the controller of the contract
135     /// @param _newController The new controller of the contract
136     function changeController(address _newController) onlyController {
137         controller = _newController;
138     }
139 }
140 
141 contract ApproveAndCallFallBack {
142     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
143 }
144 
145 /// @dev The actual token contract, the default controller is the msg.sender
146 ///  that deploys the contract, so usually this token will be deployed by a
147 ///  token controller contract, which Giveth will call a "Campaign"
148 contract MiniMeToken is Controlled {
149 
150     string public name;                //The Token's name: e.g. DigixDAO Tokens
151     uint8 public decimals;             //Number of decimals of the smallest unit
152     string public symbol;              //An identifier: e.g. REP
153     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
154 
155 
156     /// @dev `Checkpoint` is the structure that attaches a block number to a
157     ///  given value, the block number attached is the one that last changed the
158     ///  value
159     struct  Checkpoint {
160 
161         // `fromBlock` is the block number that the value was generated from
162         uint128 fromBlock;
163 
164         // `value` is the amount of tokens at a specific block number
165         uint128 value;
166     }
167 
168     // `parentToken` is the Token address that was cloned to produce this token;
169     //  it will be 0x0 for a token that was not cloned
170     MiniMeToken public parentToken;
171 
172     // `parentSnapShotBlock` is the block number from the Parent Token that was
173     //  used to determine the initial distribution of the Clone Token
174     uint public parentSnapShotBlock;
175 
176     // `creationBlock` is the block number that the Clone Token was created
177     uint public creationBlock;
178 
179     // `balances` is the map that tracks the balance of each address, in this
180     //  contract when the balance changes the block number that the change
181     //  occurred is also included in the map
182     mapping (address => Checkpoint[]) balances;
183 
184     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
185     mapping (address => mapping (address => uint256)) allowed;
186 
187     // Tracks the history of the `totalSupply` of the token
188     Checkpoint[] totalSupplyHistory;
189 
190     // Flag that determines if the token is transferable or not.
191     bool public transfersEnabled;
192 
193     // The factory used to create new clone tokens
194     MiniMeTokenFactory public tokenFactory;
195 
196 ////////////////
197 // Constructor
198 ////////////////
199 
200     /// @notice Constructor to create a MiniMeToken
201     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
202     ///  will create the Clone token contracts, the token factory needs to be
203     ///  deployed first
204     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
205     ///  new token
206     /// @param _parentSnapShotBlock Block of the parent token that will
207     ///  determine the initial distribution of the clone token, set to 0 if it
208     ///  is a new token
209     /// @param _tokenName Name of the new token
210     /// @param _decimalUnits Number of decimals of the new token
211     /// @param _tokenSymbol Token Symbol for the new token
212     /// @param _transfersEnabled If true, tokens will be able to be transferred
213     function MiniMeToken(
214         address _tokenFactory,
215         address _parentToken,
216         uint _parentSnapShotBlock,
217         string _tokenName,
218         uint8 _decimalUnits,
219         string _tokenSymbol,
220         bool _transfersEnabled
221     ) {
222         tokenFactory = MiniMeTokenFactory(_tokenFactory);
223         name = _tokenName;                                 // Set the name
224         decimals = _decimalUnits;                          // Set the decimals
225         symbol = _tokenSymbol;                             // Set the symbol
226         parentToken = MiniMeToken(_parentToken);
227         parentSnapShotBlock = _parentSnapShotBlock;
228         transfersEnabled = _transfersEnabled;
229         creationBlock = block.number;
230     }
231 
232 
233 ///////////////////
234 // ERC20 Methods
235 ///////////////////
236 
237     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
238     /// @param _to The address of the recipient
239     /// @param _amount The amount of tokens to be transferred
240     /// @return Whether the transfer was successful or not
241     function transfer(address _to, uint256 _amount) returns (bool success) {
242         require(transfersEnabled);
243         return doTransfer(msg.sender, _to, _amount);
244     }
245 
246     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
247     ///  is approved by `_from`
248     /// @param _from The address holding the tokens being transferred
249     /// @param _to The address of the recipient
250     /// @param _amount The amount of tokens to be transferred
251     /// @return True if the transfer was successful
252     function transferFrom(address _from, address _to, uint256 _amount
253     ) returns (bool success) {
254 
255         // The controller of this contract can move tokens around at will,
256         //  this is important to recognize! Confirm that you trust the
257         //  controller of this contract, which in most situations should be
258         //  another open source smart contract or 0x0
259         if (msg.sender != controller) {
260             require(transfersEnabled);
261 
262             // The standard ERC 20 transferFrom functionality
263             if (allowed[_from][msg.sender] < _amount) return false;
264             allowed[_from][msg.sender] -= _amount;
265         }
266         return doTransfer(_from, _to, _amount);
267     }
268 
269     /// @dev This is the actual transfer function in the token contract, it can
270     ///  only be called by other functions in this contract.
271     /// @param _from The address holding the tokens being transferred
272     /// @param _to The address of the recipient
273     /// @param _amount The amount of tokens to be transferred
274     /// @return True if the transfer was successful
275     function doTransfer(address _from, address _to, uint _amount
276     ) internal returns(bool) {
277 
278            if (_amount == 0) {
279                return true;
280            }
281 
282            require(parentSnapShotBlock < block.number);
283 
284            // Do not allow transfer to 0x0 or the token contract itself
285            require((_to != 0) && (_to != address(this)));
286 
287            // If the amount being transfered is more than the balance of the
288            //  account the transfer returns false
289            var previousBalanceFrom = balanceOfAt(_from, block.number);
290            if (previousBalanceFrom < _amount) {
291                return false;
292            }
293 
294            // Alerts the token controller of the transfer
295            if (isContract(controller)) {
296                require(TokenController(controller).onTransfer(_from, _to, _amount));
297            }
298 
299            // First update the balance array with the new value for the address
300            //  sending the tokens
301            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
302 
303            // Then update the balance array with the new value for the address
304            //  receiving the tokens
305            var previousBalanceTo = balanceOfAt(_to, block.number);
306            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
307            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
308 
309            // An event to make the transfer easy to find on the blockchain
310            Transfer(_from, _to, _amount);
311 
312            return true;
313     }
314 
315     /// @param _owner The address that's balance is being requested
316     /// @return The balance of `_owner` at the current block
317     function balanceOf(address _owner) constant returns (uint256 balance) {
318         return balanceOfAt(_owner, block.number);
319     }
320 
321     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
322     ///  its behalf. This is a modified version of the ERC20 approve function
323     ///  to be a little bit safer
324     /// @param _spender The address of the account able to transfer the tokens
325     /// @param _amount The amount of tokens to be approved for transfer
326     /// @return True if the approval was successful
327     function approve(address _spender, uint256 _amount) returns (bool success) {
328         require(transfersEnabled);
329 
330         // To change the approve amount you first have to reduce the addresses`
331         //  allowance to zero by calling `approve(_spender,0)` if it is not
332         //  already 0 to mitigate the race condition described here:
333         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
334         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
335 
336         // Alerts the token controller of the approve function call
337         if (isContract(controller)) {
338             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
339         }
340 
341         allowed[msg.sender][_spender] = _amount;
342         Approval(msg.sender, _spender, _amount);
343         return true;
344     }
345 
346     /// @dev This function makes it easy to read the `allowed[]` map
347     /// @param _owner The address of the account that owns the token
348     /// @param _spender The address of the account able to transfer the tokens
349     /// @return Amount of remaining tokens of _owner that _spender is allowed
350     ///  to spend
351     function allowance(address _owner, address _spender
352     ) constant returns (uint256 remaining) {
353         return allowed[_owner][_spender];
354     }
355 
356     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
357     ///  its behalf, and then a function is triggered in the contract that is
358     ///  being approved, `_spender`. This allows users to use their tokens to
359     ///  interact with contracts in one function call instead of two
360     /// @param _spender The address of the contract able to transfer the tokens
361     /// @param _amount The amount of tokens to be approved for transfer
362     /// @return True if the function call was successful
363     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
364     ) returns (bool success) {
365         require(approve(_spender, _amount));
366 
367         ApproveAndCallFallBack(_spender).receiveApproval(
368             msg.sender,
369             _amount,
370             this,
371             _extraData
372         );
373 
374         return true;
375     }
376 
377     /// @dev This function makes it easy to get the total number of tokens
378     /// @return The total number of tokens
379     function totalSupply() constant returns (uint) {
380         return totalSupplyAt(block.number);
381     }
382 
383 
384 ////////////////
385 // Query balance and totalSupply in History
386 ////////////////
387 
388     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
389     /// @param _owner The address from which the balance will be retrieved
390     /// @param _blockNumber The block number when the balance is queried
391     /// @return The balance at `_blockNumber`
392     function balanceOfAt(address _owner, uint _blockNumber) constant
393         returns (uint) {
394 
395         // These next few lines are used when the balance of the token is
396         //  requested before a check point was ever created for this token, it
397         //  requires that the `parentToken.balanceOfAt` be queried at the
398         //  genesis block for that token as this contains initial balance of
399         //  this token
400         if ((balances[_owner].length == 0)
401             || (balances[_owner][0].fromBlock > _blockNumber)) {
402             if (address(parentToken) != 0) {
403                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
404             } else {
405                 // Has no parent
406                 return 0;
407             }
408 
409         // This will return the expected balance during normal situations
410         } else {
411             return getValueAt(balances[_owner], _blockNumber);
412         }
413     }
414 
415     /// @notice Total amount of tokens at a specific `_blockNumber`.
416     /// @param _blockNumber The block number when the totalSupply is queried
417     /// @return The total amount of tokens at `_blockNumber`
418     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
419 
420         // These next few lines are used when the totalSupply of the token is
421         //  requested before a check point was ever created for this token, it
422         //  requires that the `parentToken.totalSupplyAt` be queried at the
423         //  genesis block for this token as that contains totalSupply of this
424         //  token at this block number.
425         if ((totalSupplyHistory.length == 0)
426             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
427             if (address(parentToken) != 0) {
428                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
429             } else {
430                 return 0;
431             }
432 
433         // This will return the expected totalSupply during normal situations
434         } else {
435             return getValueAt(totalSupplyHistory, _blockNumber);
436         }
437     }
438 
439 ////////////////
440 // Clone Token Method
441 ////////////////
442 
443     /// @notice Creates a new clone token with the initial distribution being
444     ///  this token at `_snapshotBlock`
445     /// @param _cloneTokenName Name of the clone token
446     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
447     /// @param _cloneTokenSymbol Symbol of the clone token
448     /// @param _snapshotBlock Block when the distribution of the parent token is
449     ///  copied to set the initial distribution of the new clone token;
450     ///  if the block is zero than the actual block, the current block is used
451     /// @param _transfersEnabled True if transfers are allowed in the clone
452     /// @return The address of the new MiniMeToken Contract
453     function createCloneToken(
454         string _cloneTokenName,
455         uint8 _cloneDecimalUnits,
456         string _cloneTokenSymbol,
457         uint _snapshotBlock,
458         bool _transfersEnabled
459         ) returns(address) {
460         if (_snapshotBlock == 0) _snapshotBlock = block.number;
461         MiniMeToken cloneToken = tokenFactory.createCloneToken(
462             this,
463             _snapshotBlock,
464             _cloneTokenName,
465             _cloneDecimalUnits,
466             _cloneTokenSymbol,
467             _transfersEnabled
468             );
469 
470         cloneToken.changeController(msg.sender);
471 
472         // An event to make the token easy to find on the blockchain
473         NewCloneToken(address(cloneToken), _snapshotBlock);
474         return address(cloneToken);
475     }
476 
477 ////////////////
478 // Generate and destroy tokens
479 ////////////////
480 
481     /// @notice Generates `_amount` tokens that are assigned to `_owner`
482     /// @param _owner The address that will be assigned the new tokens
483     /// @param _amount The quantity of tokens generated
484     /// @return True if the tokens are generated correctly
485     function generateTokens(address _owner, uint _amount
486     ) onlyController returns (bool) {
487         uint curTotalSupply = totalSupply();
488         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
489         uint previousBalanceTo = balanceOf(_owner);
490         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
491         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
492         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
493         Transfer(0, _owner, _amount);
494         return true;
495     }
496 
497 
498     /// @notice Burns `_amount` tokens from `_owner`
499     /// @param _owner The address that will lose the tokens
500     /// @param _amount The quantity of tokens to burn
501     /// @return True if the tokens are burned correctly
502     function destroyTokens(address _owner, uint _amount
503     ) onlyController returns (bool) {
504         uint curTotalSupply = totalSupply();
505         require(curTotalSupply >= _amount);
506         uint previousBalanceFrom = balanceOf(_owner);
507         require(previousBalanceFrom >= _amount);
508         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
509         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
510         Transfer(_owner, 0, _amount);
511         return true;
512     }
513 
514 ////////////////
515 // Enable tokens transfers
516 ////////////////
517 
518 
519     /// @notice Enables token holders to transfer their tokens freely if true
520     /// @param _transfersEnabled True if transfers are allowed in the clone
521     function enableTransfers(bool _transfersEnabled) onlyController {
522         transfersEnabled = _transfersEnabled;
523     }
524 
525 ////////////////
526 // Internal helper functions to query and set a value in a snapshot array
527 ////////////////
528 
529     /// @dev `getValueAt` retrieves the number of tokens at a given block number
530     /// @param checkpoints The history of values being queried
531     /// @param _block The block number to retrieve the value at
532     /// @return The number of tokens being queried
533     function getValueAt(Checkpoint[] storage checkpoints, uint _block
534     ) constant internal returns (uint) {
535         if (checkpoints.length == 0) return 0;
536 
537         // Shortcut for the actual value
538         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
539             return checkpoints[checkpoints.length-1].value;
540         if (_block < checkpoints[0].fromBlock) return 0;
541 
542         // Binary search of the value in the array
543         uint min = 0;
544         uint max = checkpoints.length-1;
545         while (max > min) {
546             uint mid = (max + min + 1)/ 2;
547             if (checkpoints[mid].fromBlock<=_block) {
548                 min = mid;
549             } else {
550                 max = mid-1;
551             }
552         }
553         return checkpoints[min].value;
554     }
555 
556     /// @dev `updateValueAtNow` used to update the `balances` map and the
557     ///  `totalSupplyHistory`
558     /// @param checkpoints The history of data being updated
559     /// @param _value The new number of tokens
560     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
561     ) internal  {
562         if ((checkpoints.length == 0)
563         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
564                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
565                newCheckPoint.fromBlock =  uint128(block.number);
566                newCheckPoint.value = uint128(_value);
567            } else {
568                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
569                oldCheckPoint.value = uint128(_value);
570            }
571     }
572 
573     /// @dev Internal function to determine if an address is a contract
574     /// @param _addr The address being queried
575     /// @return True if `_addr` is a contract
576     function isContract(address _addr) constant internal returns(bool) {
577         uint size;
578         if (_addr == 0) return false;
579         assembly {
580             size := extcodesize(_addr)
581         }
582         return size>0;
583     }
584 
585     /// @dev Helper function to return a min betwen the two uints
586     function min(uint a, uint b) internal returns (uint) {
587         return a < b ? a : b;
588     }
589 
590     /// @notice The fallback function: If the contract's controller has not been
591     ///  set to 0, then the `proxyPayment` method is called which relays the
592     ///  ether and creates tokens as described in the token controller contract
593     function ()  payable {
594         require(isContract(controller));
595         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
596     }
597 
598 //////////
599 // Safety Methods
600 //////////
601 
602     /// @notice This method can be used by the controller to extract mistakenly
603     ///  sent tokens to this contract.
604     /// @param _token The address of the token contract that you want to recover
605     ///  set to 0 in case you want to extract ether.
606     function claimTokens(address _token) onlyController {
607         if (_token == 0x0) {
608             controller.transfer(this.balance);
609             return;
610         }
611 
612         MiniMeToken token = MiniMeToken(_token);
613         uint balance = token.balanceOf(this);
614         token.transfer(controller, balance);
615         ClaimedTokens(_token, controller, balance);
616     }
617 
618 ////////////////
619 // Events
620 ////////////////
621     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
622     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
623     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
624     event Approval(
625         address indexed _owner,
626         address indexed _spender,
627         uint256 _amount
628         );
629 
630 }
631 
632 
633 ////////////////
634 // MiniMeTokenFactory
635 ////////////////
636 
637 /// @dev This contract is used to generate clone contracts from a contract.
638 ///  In solidity this is the way to create a contract from a contract of the
639 ///  same class
640 contract MiniMeTokenFactory {
641 
642     /// @notice Update the DApp by creating a new token with new functionalities
643     ///  the msg.sender becomes the controller of this clone token
644     /// @param _parentToken Address of the token being cloned
645     /// @param _snapshotBlock Block of the parent token that will
646     ///  determine the initial distribution of the clone token
647     /// @param _tokenName Name of the new token
648     /// @param _decimalUnits Number of decimals of the new token
649     /// @param _tokenSymbol Token Symbol for the new token
650     /// @param _transfersEnabled If true, tokens will be able to be transferred
651     /// @return The address of the new token contract
652     function createCloneToken(
653         address _parentToken,
654         uint _snapshotBlock,
655         string _tokenName,
656         uint8 _decimalUnits,
657         string _tokenSymbol,
658         bool _transfersEnabled
659     ) returns (MiniMeToken) 
660     {
661         MiniMeToken newToken = new MiniMeToken(
662             this,
663             _parentToken,
664             _snapshotBlock,
665             _tokenName,
666             _decimalUnits,
667             _tokenSymbol,
668             _transfersEnabled
669             );
670 
671         newToken.changeController(msg.sender);
672         return newToken;
673     }
674 }
675 
676 
677 contract SHP is MiniMeToken {
678     // @dev SHP constructor
679     function SHP(address _tokenFactory)
680             MiniMeToken(
681                 _tokenFactory,
682                 0x0,                             // no parent token
683                 0,                               // no snapshot block number from parent
684                 "Sharpe Platform Token",         // Token name
685                 18,                              // Decimals
686                 "SHP",                           // Symbol
687                 true                             // Enable transfers
688             ) {}
689 }
690 
691 
692 
693 
694 
695 /// @title Vesting trustee
696 contract Trustee is Owned {
697     using SafeMath for uint256;
698 
699     // The address of the SHP ERC20 token.
700     SHP public shp;
701 
702     struct Grant {
703         uint256 value;
704         uint256 start;
705         uint256 cliff;
706         uint256 end;
707         uint256 transferred;
708         bool revokable;
709     }
710 
711     // Grants holder.
712     mapping (address => Grant) public grants;
713 
714     // Total tokens available for vesting.
715     uint256 public totalVesting;
716 
717     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
718     event UnlockGrant(address indexed _holder, uint256 _value);
719     event RevokeGrant(address indexed _holder, uint256 _refund);
720 
721     /// @dev Constructor that initializes the address of the SHP contract.
722     /// @param _shp SHP The address of the previously deployed SHP smart contract.
723     function Trustee(SHP _shp) {
724         require(_shp != address(0));
725         shp = _shp;
726     }
727 
728     /// @dev Grant tokens to a specified address.
729     /// @param _to address The address to grant tokens to.
730     /// @param _value uint256 The amount of tokens to be granted.
731     /// @param _start uint256 The beginning of the vesting period.
732     /// @param _cliff uint256 Duration of the cliff period.
733     /// @param _end uint256 The end of the vesting period.
734     /// @param _revokable bool Whether the grant is revokable or not.
735     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
736         public onlyOwner {
737         require(_to != address(0));
738         require(_value > 0);
739 
740         // Make sure that a single address can be granted tokens only once.
741         require(grants[_to].value == 0);
742 
743         // Check for date inconsistencies that may cause unexpected behavior.
744         require(_start <= _cliff && _cliff <= _end);
745 
746         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
747         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
748 
749         // Assign a new grant.
750         grants[_to] = Grant({
751             value: _value,
752             start: _start,
753             cliff: _cliff,
754             end: _end,
755             transferred: 0,
756             revokable: _revokable
757         });
758 
759         // Tokens granted, reduce the total amount available for vesting.
760         totalVesting = totalVesting.add(_value);
761 
762         NewGrant(msg.sender, _to, _value);
763     }
764 
765     /// @dev Revoke the grant of tokens of a specifed address.
766     /// @param _holder The address which will have its tokens revoked.
767     function revoke(address _holder) public onlyOwner {
768         Grant grant = grants[_holder];
769 
770         require(grant.revokable);
771 
772         // Send the remaining SHP back to the owner.
773         uint256 refund = grant.value.sub(grant.transferred);
774 
775         // Remove the grant.
776         delete grants[_holder];
777 
778         totalVesting = totalVesting.sub(refund);
779         shp.transfer(msg.sender, refund);
780 
781         RevokeGrant(_holder, refund);
782     }
783 
784     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
785     /// @param _holder address The address of the holder.
786     /// @param _time uint256 The specific time.
787     /// @return a uint256 representing a holder's total amount of vested tokens.
788     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
789         Grant grant = grants[_holder];
790         if (grant.value == 0) {
791             return 0;
792         }
793 
794         return calculateVestedTokens(grant, _time);
795     }
796 
797     /// @dev Calculate amount of vested tokens at a specifc time.
798     /// @param _grant Grant The vesting grant.
799     /// @param _time uint256 The time to be checked
800     /// @return An uint256 representing the amount of vested tokens of a specific grant.
801     ///   |                         _/--------   vestedTokens rect
802     ///   |                       _/
803     ///   |                     _/
804     ///   |                   _/
805     ///   |                 _/
806     ///   |                /
807     ///   |              .|
808     ///   |            .  |
809     ///   |          .    |
810     ///   |        .      |
811     ///   |      .        |
812     ///   |    .          |
813     ///   +===+===========+---------+----------> time
814     ///     Start       Cliff      End
815     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
816         // If we're before the cliff, then nothing is vested.
817         if (_time < _grant.cliff) {
818             return 0;
819         }
820 
821         // If we're after the end of the vesting period - everything is vested;
822         if (_time >= _grant.end) {
823             return _grant.value;
824         }
825 
826         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
827          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
828     }
829 
830     /// @dev Unlock vested tokens and transfer them to their holder.
831     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
832     function unlockVestedTokens() public {
833         Grant grant = grants[msg.sender];
834         require(grant.value != 0);
835 
836         // Get the total amount of vested tokens, acccording to grant.
837         uint256 vested = calculateVestedTokens(grant, now);
838         if (vested == 0) {
839             return;
840         }
841 
842         // Make sure the holder doesn't transfer more than what he already has.
843         uint256 transferable = vested.sub(grant.transferred);
844         if (transferable == 0) {
845             return;
846         }
847 
848         grant.transferred = grant.transferred.add(transferable);
849         totalVesting = totalVesting.sub(transferable);
850         shp.transfer(msg.sender, transferable);
851 
852         UnlockGrant(msg.sender, transferable);
853     }
854 }
855 
856 
857 contract TokenSale is Owned, TokenController {
858     using SafeMath for uint256;
859     
860     SHP public shp;
861     Trustee public trustee;
862 
863     address public etherEscrowAddress;
864     address public bountyAddress;
865     address public trusteeAddress;
866 
867     uint256 public founderTokenCount = 0;
868     uint256 public reserveTokenCount = 0;
869     uint256 public shpExchangeRate = 0;
870 
871     uint256 constant public CALLER_EXCHANGE_SHARE = 40;
872     uint256 constant public RESERVE_EXCHANGE_SHARE = 30;
873     uint256 constant public FOUNDER_EXCHANGE_SHARE = 20;
874     uint256 constant public BOUNTY_EXCHANGE_SHARE = 10;
875     uint256 constant public MAX_GAS_PRICE = 5000000000000;
876 
877     bool public paused;
878     bool public closed;
879     bool public allowTransfer;
880 
881     mapping(address => bool) public approvedAddresses;
882 
883     event Contribution(uint256 etherAmount, address _caller);
884     event NewSale(address indexed caller, uint256 etherAmount, uint256 tokensGenerated);
885     event SaleClosed(uint256 when);
886     
887     modifier notPaused() {
888         require(!paused);
889         _;
890     }
891 
892     modifier notClosed() {
893         require(!closed);
894         _;
895     }
896 
897     modifier isValidated() {
898         require(msg.sender != 0x0);
899         require(msg.value > 0);
900         require(!isContract(msg.sender)); 
901         require(tx.gasprice <= MAX_GAS_PRICE);
902         _;
903     }
904 
905     function setShpExchangeRate(uint256 _shpExchangeRate) public onlyOwner {
906         shpExchangeRate = _shpExchangeRate;
907     }
908 
909     function setAllowTransfer(bool _allowTransfer) public onlyOwner {
910         allowTransfer = _allowTransfer;
911     }
912 
913     /// @notice This method sends the Ether received to the Ether escrow address
914     /// and generates the calculated number of SHP tokens, sending them to the caller's address.
915     /// It also generates the founder's tokens and the reserve tokens at the same time.
916     function doBuy(
917         address _caller,
918         uint256 etherAmount
919     )
920         internal
921     {
922 
923         Contribution(etherAmount, _caller);
924 
925         uint256 callerExchangeRate = shpExchangeRate.mul(CALLER_EXCHANGE_SHARE).div(100);
926         uint256 reserveExchangeRate = shpExchangeRate.mul(RESERVE_EXCHANGE_SHARE).div(100);
927         uint256 founderExchangeRate = shpExchangeRate.mul(FOUNDER_EXCHANGE_SHARE).div(100);
928         uint256 bountyExchangeRate = shpExchangeRate.mul(BOUNTY_EXCHANGE_SHARE).div(100);
929 
930         uint256 callerTokens = etherAmount.mul(callerExchangeRate);
931         uint256 callerTokensWithDiscount = applyDiscount(etherAmount, callerTokens);
932 
933         uint256 reserveTokens = etherAmount.mul(reserveExchangeRate);
934         uint256 founderTokens = etherAmount.mul(founderExchangeRate);
935         uint256 bountyTokens = etherAmount.mul(bountyExchangeRate);
936         uint256 vestingTokens = founderTokens.add(reserveTokens);
937 
938         founderTokenCount = founderTokenCount.add(founderTokens);
939         reserveTokenCount = reserveTokenCount.add(reserveTokens);
940 
941         shp.generateTokens(_caller, callerTokensWithDiscount);
942         shp.generateTokens(bountyAddress, bountyTokens);
943         shp.generateTokens(trusteeAddress, vestingTokens);
944 
945         NewSale(_caller, etherAmount, callerTokensWithDiscount);
946         NewSale(trusteeAddress, etherAmount, vestingTokens);
947         NewSale(bountyAddress, etherAmount, bountyTokens);
948 
949         etherEscrowAddress.transfer(etherAmount);
950         updateCounters(etherAmount);
951     }
952 
953     /// @notice Allows the owner to manually mint some SHP to an address if something goes wrong
954     /// @param _tokens the number of tokens to mint
955     /// @param _destination the address to send the tokens to
956     function mintTokens(
957         uint256 _tokens, 
958         address _destination
959     ) 
960         onlyOwner 
961     {
962         shp.generateTokens(_destination, _tokens);
963         NewSale(_destination, 0, _tokens);
964     }
965 
966     /// @notice Allows the owner to manually destroy some SHP to an address if something goes wrong
967     /// @param _tokens the number of tokens to mint
968     /// @param _destination the address to send the tokens to
969     function destroyTokens(
970         uint256 _tokens, 
971         address _destination
972     ) 
973         onlyOwner 
974     {
975         shp.destroyTokens(_destination, _tokens);
976     }
977 
978     /// @notice Applies the discount based on the discount tiers
979     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
980     /// @param _contributorTokens The tokens allocated based on the contribution
981     function applyDiscount(uint256 _etherAmount, uint256 _contributorTokens) internal constant returns (uint256);
982 
983     /// @notice Updates the counters for the amount of Ether paid
984     /// @param _etherAmount the amount of Ether paid
985     function updateCounters(uint256 _etherAmount) internal;
986     
987     /// @notice Parent constructor. This needs to be extended from the child contracts
988     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
989     /// @param _bountyAddress the address that will hold the bounty scheme SHP
990     /// @param _trusteeAddress the address that will hold the vesting SHP
991     /// @param _shpExchangeRate the initial SHP exchange rate
992     function TokenSale (
993         address _etherEscrowAddress,
994         address _bountyAddress,
995         address _trusteeAddress,
996         uint256 _shpExchangeRate
997     ) {
998         etherEscrowAddress = _etherEscrowAddress;
999         bountyAddress = _bountyAddress;
1000         trusteeAddress = _trusteeAddress;
1001         shpExchangeRate = _shpExchangeRate;
1002         trustee = Trustee(_trusteeAddress);
1003         paused = true;
1004         closed = false;
1005         allowTransfer = false;
1006     }
1007 
1008     /// @notice Sets the SHP token smart contract
1009     /// @param _shp the SHP token contract address
1010     function setShp(address _shp) public onlyOwner {
1011         shp = SHP(_shp);
1012     }
1013 
1014     /// @notice Transfers ownership of the token smart contract and trustee
1015     /// @param _tokenController the address of the new token controller
1016     /// @param _trusteeOwner the address of the new trustee owner
1017     function transferOwnership(address _tokenController, address _trusteeOwner) public onlyOwner {
1018         require(closed);
1019         require(_tokenController != 0x0);
1020         require(_trusteeOwner != 0x0);
1021         shp.changeController(_tokenController);
1022         trustee.changeOwner(_trusteeOwner);
1023     }
1024 
1025     /// @notice Internal function to determine if an address is a contract
1026     /// @param _caller The address being queried
1027     /// @return True if `caller` is a contract
1028     function isContract(address _caller) internal constant returns (bool) {
1029         uint size;
1030         assembly { size := extcodesize(_caller) }
1031         return size > 0;
1032     }
1033 
1034     /// @notice Pauses the contribution if there is any issue
1035     function pauseContribution() public onlyOwner {
1036         paused = true;
1037     }
1038 
1039     /// @notice Resumes the contribution
1040     function resumeContribution() public onlyOwner {
1041         paused = false;
1042     }
1043 
1044     //////////
1045     // MiniMe Controller Interface functions
1046     //////////
1047 
1048     // In between the offering and the network. Default settings for allowing token transfers.
1049     function proxyPayment(address) public payable returns (bool) {
1050         return allowTransfer;
1051     }
1052 
1053     function onTransfer(address, address, uint256) public returns (bool) {
1054         return allowTransfer;
1055     }
1056 
1057     function onApprove(address, address, uint256) public returns (bool) {
1058         return allowTransfer;
1059     }
1060 }
1061 
1062 contract SharpeCrowdsale is TokenSale {
1063     using SafeMath for uint256;
1064  
1065     uint256 public etherPaid = 0;
1066     uint256 public totalContributions = 0;
1067 
1068     uint256 constant public FIRST_TIER_DISCOUNT = 5;
1069     uint256 constant public SECOND_TIER_DISCOUNT = 10;
1070     uint256 constant public THIRD_TIER_DISCOUNT = 20;
1071     uint256 constant public FOURTH_TIER_DISCOUNT = 30;
1072 
1073     uint256 public minPresaleContributionEther;
1074     uint256 public maxPresaleContributionEther;
1075     uint256 public minDiscountEther;
1076     uint256 public firstTierDiscountUpperLimitEther;
1077     uint256 public secondTierDiscountUpperLimitEther;
1078     uint256 public thirdTierDiscountUpperLimitEther;
1079     
1080     enum ContributionState {Paused, Resumed}
1081     event ContributionStateChanged(address caller, ContributionState contributionState);
1082     enum AllowedContributionState {Whitelisted, NotWhitelisted, AboveWhitelisted, BelowWhitelisted, WhitelistClosed}
1083     event AllowedContributionCheck(uint256 contribution, AllowedContributionState allowedContributionState);
1084     event ValidContributionCheck(uint256 contribution, bool isContributionValid);
1085     event DiscountApplied(uint256 etherAmount, uint256 tokens, uint256 discount);
1086     event ContributionRefund(uint256 etherAmount, address _caller);
1087     event CountersUpdated(uint256 preSaleEtherPaid, uint256 totalContributions);
1088     event WhitelistedUpdated(uint256 plannedContribution, bool contributed);
1089     event WhitelistedCounterUpdated(uint256 whitelistedPlannedContributions, uint256 usedContributions);
1090 
1091     modifier isValidContribution() {
1092         require(validContribution());
1093         _;
1094     }
1095 
1096     /// @notice called only once when the contract is initialized
1097     /// @param _etherEscrowAddress the address that will hold the crowd funded Ether
1098     /// @param _bountyAddress the address that will hold the bounty SHP
1099     /// @param _trusteeAddress the address that will hold the vesting SHP
1100     /// @param _minDiscountEther Lower discount limit (WEI)
1101     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1102     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1103     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1104     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1105     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1106     /// @param _shpExchangeRate The initial SHP exchange rate
1107     function SharpeCrowdsale(
1108         address _etherEscrowAddress,
1109         address _bountyAddress,
1110         address _trusteeAddress,
1111         uint256 _minDiscountEther,
1112         uint256 _firstTierDiscountUpperLimitEther,
1113         uint256 _secondTierDiscountUpperLimitEther,
1114         uint256 _thirdTierDiscountUpperLimitEther,
1115         uint256 _minPresaleContributionEther,
1116         uint256 _maxPresaleContributionEther,
1117         uint256 _shpExchangeRate)
1118         TokenSale (
1119             _etherEscrowAddress,
1120             _bountyAddress,
1121             _trusteeAddress,
1122             _shpExchangeRate
1123         )
1124     {
1125         minDiscountEther = _minDiscountEther;
1126         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1127         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1128         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1129         minPresaleContributionEther = _minPresaleContributionEther;
1130         maxPresaleContributionEther = _maxPresaleContributionEther;
1131     }
1132 
1133     /// @notice Allows the owner to peg Ether values
1134     /// @param _minDiscountEther Lower discount limit (WEI)
1135     /// @param _firstTierDiscountUpperLimitEther First discount limits (WEI)
1136     /// @param _secondTierDiscountUpperLimitEther Second discount limits (WEI)
1137     /// @param _thirdTierDiscountUpperLimitEther Third discount limits (WEI)
1138     /// @param _minPresaleContributionEther Lower contribution range (WEI)
1139     /// @param _maxPresaleContributionEther Upper contribution range (WEI)
1140     function pegEtherValues(
1141         uint256 _minDiscountEther,
1142         uint256 _firstTierDiscountUpperLimitEther,
1143         uint256 _secondTierDiscountUpperLimitEther,
1144         uint256 _thirdTierDiscountUpperLimitEther,
1145         uint256 _minPresaleContributionEther,
1146         uint256 _maxPresaleContributionEther
1147     ) 
1148         onlyOwner
1149     {
1150         minDiscountEther = _minDiscountEther;
1151         firstTierDiscountUpperLimitEther = _firstTierDiscountUpperLimitEther;
1152         secondTierDiscountUpperLimitEther = _secondTierDiscountUpperLimitEther;
1153         thirdTierDiscountUpperLimitEther = _thirdTierDiscountUpperLimitEther;
1154         minPresaleContributionEther = _minPresaleContributionEther;
1155         maxPresaleContributionEther = _maxPresaleContributionEther;
1156     }
1157 
1158     /// @notice This function fires when someone sends Ether to the address of this contract.
1159     /// The ETH will be exchanged for SHP and it ensures contributions cannot be made from known addresses.
1160     function ()
1161         public
1162         payable
1163         isValidated
1164         notClosed
1165         notPaused
1166     {
1167         require(msg.value > 0);
1168         doBuy(msg.sender, msg.value);
1169     }
1170 
1171     /// @notice Public function enables closing of the pre-sale manually if necessary
1172     function closeSale() public onlyOwner {
1173         closed = true;
1174         SaleClosed(now);
1175     }
1176 
1177     /// @notice Ensure the contribution is valid
1178     /// @return Returns whether the contribution is valid or not
1179     function validContribution() private returns (bool) {
1180         bool isContributionValid = msg.value >= minPresaleContributionEther && msg.value <= maxPresaleContributionEther;
1181         ValidContributionCheck(msg.value, isContributionValid);
1182         return isContributionValid;
1183     }
1184 
1185     /// @notice Applies the discount based on the discount tiers
1186     /// @param _etherAmount The amount of ether used to evaluate the tier the contribution lies within
1187     /// @param _contributorTokens The tokens allocated based on the contribution
1188     function applyDiscount(
1189         uint256 _etherAmount, 
1190         uint256 _contributorTokens
1191     )
1192         internal
1193         constant
1194         returns (uint256)
1195     {
1196 
1197         uint256 discount = 0;
1198 
1199         if (_etherAmount > minDiscountEther && _etherAmount <= firstTierDiscountUpperLimitEther) {
1200             discount = _contributorTokens.mul(FIRST_TIER_DISCOUNT).div(100); // 5%
1201         } else if (_etherAmount > firstTierDiscountUpperLimitEther && _etherAmount <= secondTierDiscountUpperLimitEther) {
1202             discount = _contributorTokens.mul(SECOND_TIER_DISCOUNT).div(100); // 10%
1203         } else if (_etherAmount > secondTierDiscountUpperLimitEther && _etherAmount <= thirdTierDiscountUpperLimitEther) {
1204             discount = _contributorTokens.mul(THIRD_TIER_DISCOUNT).div(100); // 20%
1205         } else if (_etherAmount > thirdTierDiscountUpperLimitEther) {
1206             discount = _contributorTokens.mul(FOURTH_TIER_DISCOUNT).div(100); // 30%
1207         }
1208 
1209         DiscountApplied(_etherAmount, _contributorTokens, discount);
1210         return discount.add(_contributorTokens);
1211     }
1212 
1213     /// @notice Updates the counters for the amount of Ether paid
1214     /// @param _etherAmount the amount of Ether paid
1215     function updateCounters(uint256 _etherAmount) internal {
1216         etherPaid = etherPaid.add(_etherAmount);
1217         totalContributions = totalContributions.add(1);
1218         CountersUpdated(etherPaid, _etherAmount);
1219     }
1220 }