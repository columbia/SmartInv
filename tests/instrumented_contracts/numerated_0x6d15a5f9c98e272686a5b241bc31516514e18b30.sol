1 pragma solidity 0.4.15;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
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
46 }
47 
48 
49 /// @dev `Owned` is a base level contract that assigns an `owner` that can be
50 ///  later changed
51 contract Owned {
52 
53     /// @dev `owner` is the only address that can call a function with this
54     /// modifier
55     modifier onlyOwner() {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     address public owner;
61 
62     /// @notice The Constructor assigns the message sender to be `owner`
63     function Owned() {
64         owner = msg.sender;
65     }
66 
67     address public newOwner;
68 
69     /// @notice `owner` can step down and assign some other address to this role
70     /// @param _newOwner The address of the new owner. 0x0 can be used to create
71     function changeOwner(address _newOwner) onlyOwner {
72         if(msg.sender == owner) {
73             owner = _newOwner;
74         }
75     }
76 }
77 
78 /*
79     Copyright 2016, Jordi Baylina
80 
81     This program is free software: you can redistribute it and/or modify
82     it under the terms of the GNU General Public License as published by
83     the Free Software Foundation, either version 3 of the License, or
84     (at your option) any later version.
85 
86     This program is distributed in the hope that it will be useful,
87     but WITHOUT ANY WARRANTY; without even the implied warranty of
88     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
89     GNU General Public License for more details.
90 
91     You should have received a copy of the GNU General Public License
92     along with this program.  If not, see <http://www.gnu.org/licenses/>.
93  */
94 
95 /// @title MiniMeToken Contract
96 /// @author Jordi Baylina
97 /// @dev This token contract's goal is to make it easy for anyone to clone this
98 ///  token using the token distribution at a given block, this will allow DAO's
99 ///  and DApps to upgrade their features in a decentralized manner without
100 ///  affecting the original token
101 /// @dev It is ERC20 compliant, but still needs to under go further testing.
102 
103 
104 /// @dev The token controller contract must implement these functions
105 contract TokenController {
106     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
107     /// @param _owner The address that sent the ether to create tokens
108     /// @return True if the ether is accepted, false if it throws
109     function proxyPayment(address _owner) payable returns(bool);
110 
111     /// @notice Notifies the controller about a token transfer allowing the
112     ///  controller to react if desired
113     /// @param _from The origin of the transfer
114     /// @param _to The destination of the transfer
115     /// @param _amount The amount of the transfer
116     /// @return False if the controller does not authorize the transfer
117     function onTransfer(address _from, address _to, uint _amount) returns(bool);
118 
119     /// @notice Notifies the controller about an approval allowing the
120     ///  controller to react if desired
121     /// @param _owner The address that calls `approve()`
122     /// @param _spender The spender in the `approve()` call
123     /// @param _amount The amount in the `approve()` call
124     /// @return False if the controller does not authorize the approval
125     function onApprove(address _owner, address _spender, uint _amount)
126         returns(bool);
127 }
128 
129 contract Controlled {
130     /// @notice The address of the controller is the only address that can call
131     ///  a function with this modifier
132     modifier onlyController { require(msg.sender == controller); _; }
133 
134     address public controller;
135 
136     function Controlled() { controller = msg.sender;}
137 
138     /// @notice Changes the controller of the contract
139     /// @param _newController The new controller of the contract
140     function changeController(address _newController) onlyController {
141         controller = _newController;
142     }
143 }
144 
145 contract ApproveAndCallFallBack {
146     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
147 }
148 
149 /// @dev The actual token contract, the default controller is the msg.sender
150 ///  that deploys the contract, so usually this token will be deployed by a
151 ///  token controller contract, which Giveth will call a "Campaign"
152 contract MiniMeToken is Controlled {
153 
154     string public name;                //The Token's name: e.g. DigixDAO Tokens
155     uint8 public decimals;             //Number of decimals of the smallest unit
156     string public symbol;              //An identifier: e.g. REP
157     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
158 
159 
160     /// @dev `Checkpoint` is the structure that attaches a block number to a
161     ///  given value, the block number attached is the one that last changed the
162     ///  value
163     struct  Checkpoint {
164 
165         // `fromBlock` is the block number that the value was generated from
166         uint128 fromBlock;
167 
168         // `value` is the amount of tokens at a specific block number
169         uint128 value;
170     }
171 
172     // `parentToken` is the Token address that was cloned to produce this token;
173     //  it will be 0x0 for a token that was not cloned
174     MiniMeToken public parentToken;
175 
176     // `parentSnapShotBlock` is the block number from the Parent Token that was
177     //  used to determine the initial distribution of the Clone Token
178     uint public parentSnapShotBlock;
179 
180     // `creationBlock` is the block number that the Clone Token was created
181     uint public creationBlock;
182 
183     // `balances` is the map that tracks the balance of each address, in this
184     //  contract when the balance changes the block number that the change
185     //  occurred is also included in the map
186     mapping (address => Checkpoint[]) balances;
187 
188     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
189     mapping (address => mapping (address => uint256)) allowed;
190 
191     // Tracks the history of the `totalSupply` of the token
192     Checkpoint[] totalSupplyHistory;
193 
194     // Flag that determines if the token is transferable or not.
195     bool public transfersEnabled;
196 
197     // The factory used to create new clone tokens
198     MiniMeTokenFactory public tokenFactory;
199 
200 ////////////////
201 // Constructor
202 ////////////////
203 
204     /// @notice Constructor to create a MiniMeToken
205     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
206     ///  will create the Clone token contracts, the token factory needs to be
207     ///  deployed first
208     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
209     ///  new token
210     /// @param _parentSnapShotBlock Block of the parent token that will
211     ///  determine the initial distribution of the clone token, set to 0 if it
212     ///  is a new token
213     /// @param _tokenName Name of the new token
214     /// @param _decimalUnits Number of decimals of the new token
215     /// @param _tokenSymbol Token Symbol for the new token
216     /// @param _transfersEnabled If true, tokens will be able to be transferred
217     function MiniMeToken(
218         address _tokenFactory,
219         address _parentToken,
220         uint _parentSnapShotBlock,
221         string _tokenName,
222         uint8 _decimalUnits,
223         string _tokenSymbol,
224         bool _transfersEnabled
225     ) {
226         tokenFactory = MiniMeTokenFactory(_tokenFactory);
227         name = _tokenName;                                 // Set the name
228         decimals = _decimalUnits;                          // Set the decimals
229         symbol = _tokenSymbol;                             // Set the symbol
230         parentToken = MiniMeToken(_parentToken);
231         parentSnapShotBlock = _parentSnapShotBlock;
232         transfersEnabled = _transfersEnabled;
233         creationBlock = block.number;
234     }
235 
236 
237 ///////////////////
238 // ERC20 Methods
239 ///////////////////
240 
241     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
242     /// @param _to The address of the recipient
243     /// @param _amount The amount of tokens to be transferred
244     /// @return Whether the transfer was successful or not
245     function transfer(address _to, uint256 _amount) returns (bool success) {
246         require(transfersEnabled);
247         return doTransfer(msg.sender, _to, _amount);
248     }
249 
250     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
251     ///  is approved by `_from`
252     /// @param _from The address holding the tokens being transferred
253     /// @param _to The address of the recipient
254     /// @param _amount The amount of tokens to be transferred
255     /// @return True if the transfer was successful
256     function transferFrom(address _from, address _to, uint256 _amount
257     ) returns (bool success) {
258 
259         // The controller of this contract can move tokens around at will,
260         //  this is important to recognize! Confirm that you trust the
261         //  controller of this contract, which in most situations should be
262         //  another open source smart contract or 0x0
263         if (msg.sender != controller) {
264             require(transfersEnabled);
265 
266             // The standard ERC 20 transferFrom functionality
267             if (allowed[_from][msg.sender] < _amount) return false;
268             allowed[_from][msg.sender] -= _amount;
269         }
270         return doTransfer(_from, _to, _amount);
271     }
272 
273     /// @dev This is the actual transfer function in the token contract, it can
274     ///  only be called by other functions in this contract.
275     /// @param _from The address holding the tokens being transferred
276     /// @param _to The address of the recipient
277     /// @param _amount The amount of tokens to be transferred
278     /// @return True if the transfer was successful
279     function doTransfer(address _from, address _to, uint _amount
280     ) internal returns(bool) {
281 
282            if (_amount == 0) {
283                return true;
284            }
285 
286            require(parentSnapShotBlock < block.number);
287 
288            // Do not allow transfer to 0x0 or the token contract itself
289            require((_to != 0) && (_to != address(this)));
290 
291            // If the amount being transfered is more than the balance of the
292            //  account the transfer returns false
293            var previousBalanceFrom = balanceOfAt(_from, block.number);
294            if (previousBalanceFrom < _amount) {
295                return false;
296            }
297 
298            // Alerts the token controller of the transfer
299            if (isContract(controller)) {
300                require(TokenController(controller).onTransfer(_from, _to, _amount));
301            }
302 
303            // First update the balance array with the new value for the address
304            //  sending the tokens
305            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
306 
307            // Then update the balance array with the new value for the address
308            //  receiving the tokens
309            var previousBalanceTo = balanceOfAt(_to, block.number);
310            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
311            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
312 
313            // An event to make the transfer easy to find on the blockchain
314            Transfer(_from, _to, _amount);
315 
316            return true;
317     }
318 
319     /// @param _owner The address that's balance is being requested
320     /// @return The balance of `_owner` at the current block
321     function balanceOf(address _owner) constant returns (uint256 balance) {
322         return balanceOfAt(_owner, block.number);
323     }
324 
325     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
326     ///  its behalf. This is a modified version of the ERC20 approve function
327     ///  to be a little bit safer
328     /// @param _spender The address of the account able to transfer the tokens
329     /// @param _amount The amount of tokens to be approved for transfer
330     /// @return True if the approval was successful
331     function approve(address _spender, uint256 _amount) returns (bool success) {
332         require(transfersEnabled);
333 
334         // To change the approve amount you first have to reduce the addresses`
335         //  allowance to zero by calling `approve(_spender,0)` if it is not
336         //  already 0 to mitigate the race condition described here:
337         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
338         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
339 
340         // Alerts the token controller of the approve function call
341         if (isContract(controller)) {
342             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
343         }
344 
345         allowed[msg.sender][_spender] = _amount;
346         Approval(msg.sender, _spender, _amount);
347         return true;
348     }
349 
350     /// @dev This function makes it easy to read the `allowed[]` map
351     /// @param _owner The address of the account that owns the token
352     /// @param _spender The address of the account able to transfer the tokens
353     /// @return Amount of remaining tokens of _owner that _spender is allowed
354     ///  to spend
355     function allowance(address _owner, address _spender
356     ) constant returns (uint256 remaining) {
357         return allowed[_owner][_spender];
358     }
359 
360     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
361     ///  its behalf, and then a function is triggered in the contract that is
362     ///  being approved, `_spender`. This allows users to use their tokens to
363     ///  interact with contracts in one function call instead of two
364     /// @param _spender The address of the contract able to transfer the tokens
365     /// @param _amount The amount of tokens to be approved for transfer
366     /// @return True if the function call was successful
367     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
368     ) returns (bool success) {
369         require(approve(_spender, _amount));
370 
371         ApproveAndCallFallBack(_spender).receiveApproval(
372             msg.sender,
373             _amount,
374             this,
375             _extraData
376         );
377 
378         return true;
379     }
380 
381     /// @dev This function makes it easy to get the total number of tokens
382     /// @return The total number of tokens
383     function totalSupply() constant returns (uint) {
384         return totalSupplyAt(block.number);
385     }
386 
387 
388 ////////////////
389 // Query balance and totalSupply in History
390 ////////////////
391 
392     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
393     /// @param _owner The address from which the balance will be retrieved
394     /// @param _blockNumber The block number when the balance is queried
395     /// @return The balance at `_blockNumber`
396     function balanceOfAt(address _owner, uint _blockNumber) constant
397         returns (uint) {
398 
399         // These next few lines are used when the balance of the token is
400         //  requested before a check point was ever created for this token, it
401         //  requires that the `parentToken.balanceOfAt` be queried at the
402         //  genesis block for that token as this contains initial balance of
403         //  this token
404         if ((balances[_owner].length == 0)
405             || (balances[_owner][0].fromBlock > _blockNumber)) {
406             if (address(parentToken) != 0) {
407                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
408             } else {
409                 // Has no parent
410                 return 0;
411             }
412 
413         // This will return the expected balance during normal situations
414         } else {
415             return getValueAt(balances[_owner], _blockNumber);
416         }
417     }
418 
419     /// @notice Total amount of tokens at a specific `_blockNumber`.
420     /// @param _blockNumber The block number when the totalSupply is queried
421     /// @return The total amount of tokens at `_blockNumber`
422     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
423 
424         // These next few lines are used when the totalSupply of the token is
425         //  requested before a check point was ever created for this token, it
426         //  requires that the `parentToken.totalSupplyAt` be queried at the
427         //  genesis block for this token as that contains totalSupply of this
428         //  token at this block number.
429         if ((totalSupplyHistory.length == 0)
430             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
431             if (address(parentToken) != 0) {
432                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
433             } else {
434                 return 0;
435             }
436 
437         // This will return the expected totalSupply during normal situations
438         } else {
439             return getValueAt(totalSupplyHistory, _blockNumber);
440         }
441     }
442 
443 ////////////////
444 // Clone Token Method
445 ////////////////
446 
447     /// @notice Creates a new clone token with the initial distribution being
448     ///  this token at `_snapshotBlock`
449     /// @param _cloneTokenName Name of the clone token
450     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
451     /// @param _cloneTokenSymbol Symbol of the clone token
452     /// @param _snapshotBlock Block when the distribution of the parent token is
453     ///  copied to set the initial distribution of the new clone token;
454     ///  if the block is zero than the actual block, the current block is used
455     /// @param _transfersEnabled True if transfers are allowed in the clone
456     /// @return The address of the new MiniMeToken Contract
457     function createCloneToken(
458         string _cloneTokenName,
459         uint8 _cloneDecimalUnits,
460         string _cloneTokenSymbol,
461         uint _snapshotBlock,
462         bool _transfersEnabled
463         ) returns(address) {
464         if (_snapshotBlock == 0) _snapshotBlock = block.number;
465         MiniMeToken cloneToken = tokenFactory.createCloneToken(
466             this,
467             _snapshotBlock,
468             _cloneTokenName,
469             _cloneDecimalUnits,
470             _cloneTokenSymbol,
471             _transfersEnabled
472             );
473 
474         cloneToken.changeController(msg.sender);
475 
476         // An event to make the token easy to find on the blockchain
477         NewCloneToken(address(cloneToken), _snapshotBlock);
478         return address(cloneToken);
479     }
480 
481 ////////////////
482 // Generate and destroy tokens
483 ////////////////
484 
485     /// @notice Generates `_amount` tokens that are assigned to `_owner`
486     /// @param _owner The address that will be assigned the new tokens
487     /// @param _amount The quantity of tokens generated
488     /// @return True if the tokens are generated correctly
489     function generateTokens(address _owner, uint _amount
490     ) onlyController returns (bool) {
491         uint curTotalSupply = totalSupply();
492         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
493         uint previousBalanceTo = balanceOf(_owner);
494         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
495         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
496         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
497         Transfer(0, _owner, _amount);
498         return true;
499     }
500 
501 
502     /// @notice Burns `_amount` tokens from `_owner`
503     /// @param _owner The address that will lose the tokens
504     /// @param _amount The quantity of tokens to burn
505     /// @return True if the tokens are burned correctly
506     function destroyTokens(address _owner, uint _amount
507     ) onlyController returns (bool) {
508         uint curTotalSupply = totalSupply();
509         require(curTotalSupply >= _amount);
510         uint previousBalanceFrom = balanceOf(_owner);
511         require(previousBalanceFrom >= _amount);
512         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
513         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
514         Transfer(_owner, 0, _amount);
515         return true;
516     }
517 
518 ////////////////
519 // Enable tokens transfers
520 ////////////////
521 
522 
523     /// @notice Enables token holders to transfer their tokens freely if true
524     /// @param _transfersEnabled True if transfers are allowed in the clone
525     function enableTransfers(bool _transfersEnabled) onlyController {
526         transfersEnabled = _transfersEnabled;
527     }
528 
529 ////////////////
530 // Internal helper functions to query and set a value in a snapshot array
531 ////////////////
532 
533     /// @dev `getValueAt` retrieves the number of tokens at a given block number
534     /// @param checkpoints The history of values being queried
535     /// @param _block The block number to retrieve the value at
536     /// @return The number of tokens being queried
537     function getValueAt(Checkpoint[] storage checkpoints, uint _block
538     ) constant internal returns (uint) {
539         if (checkpoints.length == 0) return 0;
540 
541         // Shortcut for the actual value
542         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
543             return checkpoints[checkpoints.length-1].value;
544         if (_block < checkpoints[0].fromBlock) return 0;
545 
546         // Binary search of the value in the array
547         uint min = 0;
548         uint max = checkpoints.length-1;
549         while (max > min) {
550             uint mid = (max + min + 1)/ 2;
551             if (checkpoints[mid].fromBlock<=_block) {
552                 min = mid;
553             } else {
554                 max = mid-1;
555             }
556         }
557         return checkpoints[min].value;
558     }
559 
560     /// @dev `updateValueAtNow` used to update the `balances` map and the
561     ///  `totalSupplyHistory`
562     /// @param checkpoints The history of data being updated
563     /// @param _value The new number of tokens
564     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
565     ) internal  {
566         if ((checkpoints.length == 0)
567         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
568                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
569                newCheckPoint.fromBlock =  uint128(block.number);
570                newCheckPoint.value = uint128(_value);
571            } else {
572                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
573                oldCheckPoint.value = uint128(_value);
574            }
575     }
576 
577     /// @dev Internal function to determine if an address is a contract
578     /// @param _addr The address being queried
579     /// @return True if `_addr` is a contract
580     function isContract(address _addr) constant internal returns(bool) {
581         uint size;
582         if (_addr == 0) return false;
583         assembly {
584             size := extcodesize(_addr)
585         }
586         return size>0;
587     }
588 
589     /// @dev Helper function to return a min betwen the two uints
590     function min(uint a, uint b) internal returns (uint) {
591         return a < b ? a : b;
592     }
593 
594     /// @notice The fallback function: If the contract's controller has not been
595     ///  set to 0, then the `proxyPayment` method is called which relays the
596     ///  ether and creates tokens as described in the token controller contract
597     function ()  payable {
598         require(isContract(controller));
599         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
600     }
601 
602 //////////
603 // Safety Methods
604 //////////
605 
606     /// @notice This method can be used by the controller to extract mistakenly
607     ///  sent tokens to this contract.
608     /// @param _token The address of the token contract that you want to recover
609     ///  set to 0 in case you want to extract ether.
610     function claimTokens(address _token) onlyController {
611         if (_token == 0x0) {
612             controller.transfer(this.balance);
613             return;
614         }
615 
616         MiniMeToken token = MiniMeToken(_token);
617         uint balance = token.balanceOf(this);
618         token.transfer(controller, balance);
619         ClaimedTokens(_token, controller, balance);
620     }
621 
622 ////////////////
623 // Events
624 ////////////////
625     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
626     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
627     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
628     event Approval(
629         address indexed _owner,
630         address indexed _spender,
631         uint256 _amount
632         );
633 
634 }
635 
636 
637 ////////////////
638 // MiniMeTokenFactory
639 ////////////////
640 
641 /// @dev This contract is used to generate clone contracts from a contract.
642 ///  In solidity this is the way to create a contract from a contract of the
643 ///  same class
644 contract MiniMeTokenFactory {
645 
646     /// @notice Update the DApp by creating a new token with new functionalities
647     ///  the msg.sender becomes the controller of this clone token
648     /// @param _parentToken Address of the token being cloned
649     /// @param _snapshotBlock Block of the parent token that will
650     ///  determine the initial distribution of the clone token
651     /// @param _tokenName Name of the new token
652     /// @param _decimalUnits Number of decimals of the new token
653     /// @param _tokenSymbol Token Symbol for the new token
654     /// @param _transfersEnabled If true, tokens will be able to be transferred
655     /// @return The address of the new token contract
656     function createCloneToken(
657         address _parentToken,
658         uint _snapshotBlock,
659         string _tokenName,
660         uint8 _decimalUnits,
661         string _tokenSymbol,
662         bool _transfersEnabled
663     ) returns (MiniMeToken) 
664     {
665         MiniMeToken newToken = new MiniMeToken(
666             this,
667             _parentToken,
668             _snapshotBlock,
669             _tokenName,
670             _decimalUnits,
671             _tokenSymbol,
672             _transfersEnabled
673             );
674 
675         newToken.changeController(msg.sender);
676         return newToken;
677     }
678 }
679 
680 contract SHP is MiniMeToken {
681     // @dev SHP constructor
682     function SHP(address _tokenFactory)
683             MiniMeToken(
684                 _tokenFactory,
685                 0x0,                             // no parent token
686                 0,                               // no snapshot block number from parent
687                 "Sharpe Platform Token",         // Token name
688                 18,                              // Decimals
689                 "SHP",                           // Symbol
690                 true                             // Enable transfers
691             ) {}
692 }
693 
694 /// @title Vesting trustee
695 contract Trustee is Owned {
696     using SafeMath for uint256;
697 
698     // The address of the SHP ERC20 token.
699     SHP public shp;
700 
701     struct Grant {
702         uint256 value;
703         uint256 start;
704         uint256 cliff;
705         uint256 end;
706         uint256 transferred;
707         bool revokable;
708     }
709 
710     // Grants holder.
711     mapping (address => Grant) public grants;
712 
713     // Total tokens available for vesting.
714     uint256 public totalVesting;
715 
716     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
717     event UnlockGrant(address indexed _holder, uint256 _value);
718     event RevokeGrant(address indexed _holder, uint256 _refund);
719 
720     /// @dev Constructor that initializes the address of the SHP contract.
721     /// @param _shp SHP The address of the previously deployed SHP smart contract.
722     function Trustee(SHP _shp) {
723         require(_shp != address(0));
724         shp = _shp;
725     }
726 
727     /// @dev Grant tokens to a specified address.
728     /// @param _to address The address to grant tokens to.
729     /// @param _value uint256 The amount of tokens to be granted.
730     /// @param _start uint256 The beginning of the vesting period.
731     /// @param _cliff uint256 Duration of the cliff period.
732     /// @param _end uint256 The end of the vesting period.
733     /// @param _revokable bool Whether the grant is revokable or not.
734     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end, bool _revokable)
735         public onlyOwner {
736         require(_to != address(0));
737         require(_value > 0);
738 
739         // Make sure that a single address can be granted tokens only once.
740         require(grants[_to].value == 0);
741 
742         // Check for date inconsistencies that may cause unexpected behavior.
743         require(_start <= _cliff && _cliff <= _end);
744 
745         // Check that this grant doesn't exceed the total amount of tokens currently available for vesting.
746         require(totalVesting.add(_value) <= shp.balanceOf(address(this)));
747 
748         // Assign a new grant.
749         grants[_to] = Grant({
750             value: _value,
751             start: _start,
752             cliff: _cliff,
753             end: _end,
754             transferred: 0,
755             revokable: _revokable
756         });
757 
758         // Tokens granted, reduce the total amount available for vesting.
759         totalVesting = totalVesting.add(_value);
760 
761         NewGrant(msg.sender, _to, _value);
762     }
763 
764     /// @dev Revoke the grant of tokens of a specifed address.
765     /// @param _holder The address which will have its tokens revoked.
766     function revoke(address _holder) public onlyOwner {
767         Grant grant = grants[_holder];
768 
769         require(grant.revokable);
770 
771         // Send the remaining SHP back to the owner.
772         uint256 refund = grant.value.sub(grant.transferred);
773 
774         // Remove the grant.
775         delete grants[_holder];
776 
777         totalVesting = totalVesting.sub(refund);
778         shp.transfer(msg.sender, refund);
779 
780         RevokeGrant(_holder, refund);
781     }
782 
783     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
784     /// @param _holder address The address of the holder.
785     /// @param _time uint256 The specific time.
786     /// @return a uint256 representing a holder's total amount of vested tokens.
787     function vestedTokens(address _holder, uint256 _time) public constant returns (uint256) {
788         Grant grant = grants[_holder];
789         if (grant.value == 0) {
790             return 0;
791         }
792 
793         return calculateVestedTokens(grant, _time);
794     }
795 
796     /// @dev Calculate amount of vested tokens at a specifc time.
797     /// @param _grant Grant The vesting grant.
798     /// @param _time uint256 The time to be checked
799     /// @return An uint256 representing the amount of vested tokens of a specific grant.
800     ///   |                         _/--------   vestedTokens rect
801     ///   |                       _/
802     ///   |                     _/
803     ///   |                   _/
804     ///   |                 _/
805     ///   |                /
806     ///   |              .|
807     ///   |            .  |
808     ///   |          .    |
809     ///   |        .      |
810     ///   |      .        |
811     ///   |    .          |
812     ///   +===+===========+---------+----------> time
813     ///     Start       Cliff      End
814     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
815         // If we're before the cliff, then nothing is vested.
816         if (_time < _grant.cliff) {
817             return 0;
818         }
819 
820         // If we're after the end of the vesting period - everything is vested;
821         if (_time >= _grant.end) {
822             return _grant.value;
823         }
824 
825         // Interpolate all vested tokens: vestedTokens = tokens/// (time - start) / (end - start)
826          return _grant.value.mul(_time.sub(_grant.start)).div(_grant.end.sub(_grant.start));
827     }
828 
829     /// @dev Unlock vested tokens and transfer them to their holder.
830     /// @return a uint256 representing the amount of vested tokens transferred to their holder.
831     function unlockVestedTokens() public {
832         Grant grant = grants[msg.sender];
833         require(grant.value != 0);
834 
835         // Get the total amount of vested tokens, acccording to grant.
836         uint256 vested = calculateVestedTokens(grant, now);
837         if (vested == 0) {
838             return;
839         }
840 
841         // Make sure the holder doesn't transfer more than what he already has.
842         uint256 transferable = vested.sub(grant.transferred);
843         if (transferable == 0) {
844             return;
845         }
846 
847         grant.transferred = grant.transferred.add(transferable);
848         totalVesting = totalVesting.sub(transferable);
849         shp.transfer(msg.sender, transferable);
850 
851         UnlockGrant(msg.sender, transferable);
852     }
853 }