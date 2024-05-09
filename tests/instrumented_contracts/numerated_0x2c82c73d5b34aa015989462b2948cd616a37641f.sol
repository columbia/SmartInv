1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   function Ownable() {
50     owner = msg.sender;
51   }
52 
53 
54   /**
55    * @dev Throws if called by any account other than the owner.
56    */
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner public {
68     require(newOwner != address(0));
69     OwnershipTransferred(owner, newOwner);
70     owner = newOwner;
71   }
72 
73 }
74 /*
75  * Contract that is working with ERC223 tokens
76  * This is an implementation of ContractReceiver provided here:
77  * https://github.com/Dexaran/ERC223-token-standard/blob/Recommended/Receiver_Interface.sol
78  */
79 
80  contract ContractReceiver {
81 
82     function tokenFallback(address _from, uint _value, bytes _data);
83 
84 }
85 /*
86     Copyright 2016, Jordi Baylina
87 
88     This program is free software: you can redistribute it and/or modify
89     it under the terms of the GNU General Public License as published by
90     the Free Software Foundation, either version 3 of the License, or
91     (at your option) any later version.
92 
93     This program is distributed in the hope that it will be useful,
94     but WITHOUT ANY WARRANTY; without even the implied warranty of
95     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
96     GNU General Public License for more details.
97 
98     You should have received a copy of the GNU General Public License
99     along with this program.  If not, see <http://www.gnu.org/licenses/>.
100  */
101 
102 /// @title MiniMeToken Contract
103 /// @author Jordi Baylina
104 /// @dev This token contract's goal is to make it easy for anyone to clone this
105 ///  token using the token distribution at a given block, this will allow DAO's
106 ///  and DApps to upgrade their features in a decentralized manner without
107 ///  affecting the original token
108 /// @dev It is ERC20 compliant, but still needs to under go further testing.
109 
110 
111 /// @dev The token controller contract must implement these functions
112 contract TokenController {
113     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
114     /// @param _owner The address that sent the ether to create tokens
115     /// @return True if the ether is accepted, false if it throws
116     function proxyPayment(address _owner) payable returns(bool);
117 
118     /// @notice Notifies the controller about a token transfer allowing the
119     ///  controller to react if desired
120     /// @param _from The origin of the transfer
121     /// @param _to The destination of the transfer
122     /// @param _amount The amount of the transfer
123     /// @return False if the controller does not authorize the transfer
124     function onTransfer(address _from, address _to, uint _amount) returns(bool);
125 
126     /// @notice Notifies the controller about an approval allowing the
127     ///  controller to react if desired
128     /// @param _owner The address that calls `approve()`
129     /// @param _spender The spender in the `approve()` call
130     /// @param _amount The amount in the `approve()` call
131     /// @return False if the controller does not authorize the approval
132     function onApprove(address _owner, address _spender, uint _amount)
133         returns(bool);
134 }
135 
136 contract Controlled {
137     /// @notice The address of the controller is the only address that can call
138     ///  a function with this modifier
139     modifier onlyController { require(msg.sender == controller); _; }
140 
141     address public controller;
142 
143     function Controlled() { controller = msg.sender;}
144 
145     /// @notice Changes the controller of the contract
146     /// @param _newController The new controller of the contract
147     function changeController(address _newController) onlyController {
148         controller = _newController;
149     }
150 }
151 
152 contract ApproveAndCallFallBack {
153     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
154 }
155 
156 /// @dev The actual token contract, the default controller is the msg.sender
157 ///  that deploys the contract, so usually this token will be deployed by a
158 ///  token controller contract, which Giveth will call a "Campaign"
159 contract MiniMeToken is Controlled {
160 
161     string public name;                //The Token's name: e.g. DigixDAO Tokens
162     uint8 public decimals;             //Number of decimals of the smallest unit
163     string public symbol;              //An identifier: e.g. REP
164     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
165 
166 
167     /// @dev `Checkpoint` is the structure that attaches a block number to a
168     ///  given value, the block number attached is the one that last changed the
169     ///  value
170     struct  Checkpoint {
171 
172         // `fromBlock` is the block number that the value was generated from
173         uint128 fromBlock;
174 
175         // `value` is the amount of tokens at a specific block number
176         uint128 value;
177     }
178 
179     // `parentToken` is the Token address that was cloned to produce this token;
180     //  it will be 0x0 for a token that was not cloned
181     MiniMeToken public parentToken;
182 
183     // `parentSnapShotBlock` is the block number from the Parent Token that was
184     //  used to determine the initial distribution of the Clone Token
185     uint public parentSnapShotBlock;
186 
187     // `creationBlock` is the block number that the Clone Token was created
188     uint public creationBlock;
189 
190     // `balances` is the map that tracks the balance of each address, in this
191     //  contract when the balance changes the block number that the change
192     //  occurred is also included in the map
193     mapping (address => Checkpoint[]) balances;
194 
195     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
196     mapping (address => mapping (address => uint256)) allowed;
197 
198     // Tracks the history of the `totalSupply` of the token
199     Checkpoint[] totalSupplyHistory;
200 
201     // Flag that determines if the token is transferable or not.
202     bool public transfersEnabled;
203 
204     // The factory used to create new clone tokens
205     MiniMeTokenFactory public tokenFactory;
206 
207 ////////////////
208 // Constructor
209 ////////////////
210 
211     /// @notice Constructor to create a MiniMeToken
212     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
213     ///  will create the Clone token contracts, the token factory needs to be
214     ///  deployed first
215     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
216     ///  new token
217     /// @param _parentSnapShotBlock Block of the parent token that will
218     ///  determine the initial distribution of the clone token, set to 0 if it
219     ///  is a new token
220     /// @param _tokenName Name of the new token
221     /// @param _decimalUnits Number of decimals of the new token
222     /// @param _tokenSymbol Token Symbol for the new token
223     /// @param _transfersEnabled If true, tokens will be able to be transferred
224     function MiniMeToken(
225         address _tokenFactory,
226         address _parentToken,
227         uint _parentSnapShotBlock,
228         string _tokenName,
229         uint8 _decimalUnits,
230         string _tokenSymbol,
231         bool _transfersEnabled
232     ) {
233         tokenFactory = MiniMeTokenFactory(_tokenFactory);
234         name = _tokenName;                                 // Set the name
235         decimals = _decimalUnits;                          // Set the decimals
236         symbol = _tokenSymbol;                             // Set the symbol
237         parentToken = MiniMeToken(_parentToken);
238         parentSnapShotBlock = _parentSnapShotBlock;
239         transfersEnabled = _transfersEnabled;
240         creationBlock = block.number;
241     }
242 
243 
244 ///////////////////
245 // ERC20 Methods
246 ///////////////////
247 
248     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
249     /// @param _to The address of the recipient
250     /// @param _amount The amount of tokens to be transferred
251     /// @return Whether the transfer was successful or not
252     function transfer(address _to, uint256 _amount) returns (bool success) {
253         require(transfersEnabled);
254         return doTransfer(msg.sender, _to, _amount);
255     }
256 
257     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
258     ///  is approved by `_from`
259     /// @param _from The address holding the tokens being transferred
260     /// @param _to The address of the recipient
261     /// @param _amount The amount of tokens to be transferred
262     /// @return True if the transfer was successful
263     function transferFrom(address _from, address _to, uint256 _amount
264     ) returns (bool success) {
265 
266         // The controller of this contract can move tokens around at will,
267         //  this is important to recognize! Confirm that you trust the
268         //  controller of this contract, which in most situations should be
269         //  another open source smart contract or 0x0
270         if (msg.sender != controller) {
271             require(transfersEnabled);
272 
273             // The standard ERC 20 transferFrom functionality
274             if (allowed[_from][msg.sender] < _amount) return false;
275             allowed[_from][msg.sender] -= _amount;
276         }
277         return doTransfer(_from, _to, _amount);
278     }
279 
280     /// @dev This is the actual transfer function in the token contract, it can
281     ///  only be called by other functions in this contract.
282     /// @param _from The address holding the tokens being transferred
283     /// @param _to The address of the recipient
284     /// @param _amount The amount of tokens to be transferred
285     /// @return True if the transfer was successful
286     function doTransfer(address _from, address _to, uint _amount
287     ) internal returns(bool) {
288 
289            if (_amount == 0) {
290                return true;
291            }
292 
293            require(parentSnapShotBlock < block.number);
294 
295            // Do not allow transfer to 0x0 or the token contract itself
296            require((_to != 0) && (_to != address(this)));
297 
298            // If the amount being transfered is more than the balance of the
299            //  account the transfer returns false
300            var previousBalanceFrom = balanceOfAt(_from, block.number);
301            if (previousBalanceFrom < _amount) {
302                return false;
303            }
304 
305            // Alerts the token controller of the transfer
306            if (isContract(controller)) {
307                require(TokenController(controller).onTransfer(_from, _to, _amount));
308            }
309 
310            // First update the balance array with the new value for the address
311            //  sending the tokens
312            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
313 
314            // Then update the balance array with the new value for the address
315            //  receiving the tokens
316            var previousBalanceTo = balanceOfAt(_to, block.number);
317            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
318            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
319 
320            // An event to make the transfer easy to find on the blockchain
321            Transfer(_from, _to, _amount);
322 
323            return true;
324     }
325 
326     /// @param _owner The address that's balance is being requested
327     /// @return The balance of `_owner` at the current block
328     function balanceOf(address _owner) constant returns (uint256 balance) {
329         return balanceOfAt(_owner, block.number);
330     }
331 
332     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
333     ///  its behalf. This is a modified version of the ERC20 approve function
334     ///  to be a little bit safer
335     /// @param _spender The address of the account able to transfer the tokens
336     /// @param _amount The amount of tokens to be approved for transfer
337     /// @return True if the approval was successful
338     function approve(address _spender, uint256 _amount) returns (bool success) {
339         require(transfersEnabled);
340 
341         // To change the approve amount you first have to reduce the addresses`
342         //  allowance to zero by calling `approve(_spender,0)` if it is not
343         //  already 0 to mitigate the race condition described here:
344         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
345         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
346 
347         // Alerts the token controller of the approve function call
348         if (isContract(controller)) {
349             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
350         }
351 
352         allowed[msg.sender][_spender] = _amount;
353         Approval(msg.sender, _spender, _amount);
354         return true;
355     }
356 
357     /// @dev This function makes it easy to read the `allowed[]` map
358     /// @param _owner The address of the account that owns the token
359     /// @param _spender The address of the account able to transfer the tokens
360     /// @return Amount of remaining tokens of _owner that _spender is allowed
361     ///  to spend
362     function allowance(address _owner, address _spender
363     ) constant returns (uint256 remaining) {
364         return allowed[_owner][_spender];
365     }
366 
367     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
368     ///  its behalf, and then a function is triggered in the contract that is
369     ///  being approved, `_spender`. This allows users to use their tokens to
370     ///  interact with contracts in one function call instead of two
371     /// @param _spender The address of the contract able to transfer the tokens
372     /// @param _amount The amount of tokens to be approved for transfer
373     /// @return True if the function call was successful
374     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
375     ) returns (bool success) {
376         require(approve(_spender, _amount));
377 
378         ApproveAndCallFallBack(_spender).receiveApproval(
379             msg.sender,
380             _amount,
381             this,
382             _extraData
383         );
384 
385         return true;
386     }
387 
388     /// @dev This function makes it easy to get the total number of tokens
389     /// @return The total number of tokens
390     function totalSupply() constant returns (uint) {
391         return totalSupplyAt(block.number);
392     }
393 
394 
395 ////////////////
396 // Query balance and totalSupply in History
397 ////////////////
398 
399     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
400     /// @param _owner The address from which the balance will be retrieved
401     /// @param _blockNumber The block number when the balance is queried
402     /// @return The balance at `_blockNumber`
403     function balanceOfAt(address _owner, uint _blockNumber) constant
404         returns (uint) {
405 
406         // These next few lines are used when the balance of the token is
407         //  requested before a check point was ever created for this token, it
408         //  requires that the `parentToken.balanceOfAt` be queried at the
409         //  genesis block for that token as this contains initial balance of
410         //  this token
411         if ((balances[_owner].length == 0)
412             || (balances[_owner][0].fromBlock > _blockNumber)) {
413             if (address(parentToken) != 0) {
414                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
415             } else {
416                 // Has no parent
417                 return 0;
418             }
419 
420         // This will return the expected balance during normal situations
421         } else {
422             return getValueAt(balances[_owner], _blockNumber);
423         }
424     }
425 
426     /// @notice Total amount of tokens at a specific `_blockNumber`.
427     /// @param _blockNumber The block number when the totalSupply is queried
428     /// @return The total amount of tokens at `_blockNumber`
429     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
430 
431         // These next few lines are used when the totalSupply of the token is
432         //  requested before a check point was ever created for this token, it
433         //  requires that the `parentToken.totalSupplyAt` be queried at the
434         //  genesis block for this token as that contains totalSupply of this
435         //  token at this block number.
436         if ((totalSupplyHistory.length == 0)
437             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
438             if (address(parentToken) != 0) {
439                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
440             } else {
441                 return 0;
442             }
443 
444         // This will return the expected totalSupply during normal situations
445         } else {
446             return getValueAt(totalSupplyHistory, _blockNumber);
447         }
448     }
449 
450 ////////////////
451 // Clone Token Method
452 ////////////////
453 
454     /// @notice Creates a new clone token with the initial distribution being
455     ///  this token at `_snapshotBlock`
456     /// @param _cloneTokenName Name of the clone token
457     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
458     /// @param _cloneTokenSymbol Symbol of the clone token
459     /// @param _snapshotBlock Block when the distribution of the parent token is
460     ///  copied to set the initial distribution of the new clone token;
461     ///  if the block is zero than the actual block, the current block is used
462     /// @param _transfersEnabled True if transfers are allowed in the clone
463     /// @return The address of the new MiniMeToken Contract
464     function createCloneToken(
465         string _cloneTokenName,
466         uint8 _cloneDecimalUnits,
467         string _cloneTokenSymbol,
468         uint _snapshotBlock,
469         bool _transfersEnabled
470         ) returns(address) {
471         if (_snapshotBlock == 0) _snapshotBlock = block.number;
472         MiniMeToken cloneToken = tokenFactory.createCloneToken(
473             this,
474             _snapshotBlock,
475             _cloneTokenName,
476             _cloneDecimalUnits,
477             _cloneTokenSymbol,
478             _transfersEnabled
479             );
480 
481         cloneToken.changeController(msg.sender);
482 
483         // An event to make the token easy to find on the blockchain
484         NewCloneToken(address(cloneToken), _snapshotBlock);
485         return address(cloneToken);
486     }
487 
488 ////////////////
489 // Generate and destroy tokens
490 ////////////////
491 
492     /// @notice Generates `_amount` tokens that are assigned to `_owner`
493     /// @param _owner The address that will be assigned the new tokens
494     /// @param _amount The quantity of tokens generated
495     /// @return True if the tokens are generated correctly
496     function generateTokens(address _owner, uint _amount
497     ) onlyController returns (bool) {
498         uint curTotalSupply = totalSupply();
499         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
500         uint previousBalanceTo = balanceOf(_owner);
501         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
502         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
503         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
504         Transfer(0, _owner, _amount);
505         return true;
506     }
507 
508 
509     /// @notice Burns `_amount` tokens from `_owner`
510     /// @param _owner The address that will lose the tokens
511     /// @param _amount The quantity of tokens to burn
512     /// @return True if the tokens are burned correctly
513     function destroyTokens(address _owner, uint _amount
514     ) onlyController returns (bool) {
515         uint curTotalSupply = totalSupply();
516         require(curTotalSupply >= _amount);
517         uint previousBalanceFrom = balanceOf(_owner);
518         require(previousBalanceFrom >= _amount);
519         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
520         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
521         Transfer(_owner, 0, _amount);
522         return true;
523     }
524 
525 ////////////////
526 // Enable tokens transfers
527 ////////////////
528 
529 
530     /// @notice Enables token holders to transfer their tokens freely if true
531     /// @param _transfersEnabled True if transfers are allowed in the clone
532     function enableTransfers(bool _transfersEnabled) onlyController {
533         transfersEnabled = _transfersEnabled;
534     }
535 
536 ////////////////
537 // Internal helper functions to query and set a value in a snapshot array
538 ////////////////
539 
540     /// @dev `getValueAt` retrieves the number of tokens at a given block number
541     /// @param checkpoints The history of values being queried
542     /// @param _block The block number to retrieve the value at
543     /// @return The number of tokens being queried
544     function getValueAt(Checkpoint[] storage checkpoints, uint _block
545     ) constant internal returns (uint) {
546         if (checkpoints.length == 0) return 0;
547 
548         // Shortcut for the actual value
549         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
550             return checkpoints[checkpoints.length-1].value;
551         if (_block < checkpoints[0].fromBlock) return 0;
552 
553         // Binary search of the value in the array
554         uint min = 0;
555         uint max = checkpoints.length-1;
556         while (max > min) {
557             uint mid = (max + min + 1)/ 2;
558             if (checkpoints[mid].fromBlock<=_block) {
559                 min = mid;
560             } else {
561                 max = mid-1;
562             }
563         }
564         return checkpoints[min].value;
565     }
566 
567     /// @dev `updateValueAtNow` used to update the `balances` map and the
568     ///  `totalSupplyHistory`
569     /// @param checkpoints The history of data being updated
570     /// @param _value The new number of tokens
571     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
572     ) internal  {
573         if ((checkpoints.length == 0)
574         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
575                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
576                newCheckPoint.fromBlock =  uint128(block.number);
577                newCheckPoint.value = uint128(_value);
578            } else {
579                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
580                oldCheckPoint.value = uint128(_value);
581            }
582     }
583 
584     /// @dev Internal function to determine if an address is a contract
585     /// @param _addr The address being queried
586     /// @return True if `_addr` is a contract
587     function isContract(address _addr) constant internal returns(bool) {
588         uint size;
589         if (_addr == 0) return false;
590         assembly {
591             size := extcodesize(_addr)
592         }
593         return size>0;
594     }
595 
596     /// @dev Helper function to return a min betwen the two uints
597     function min(uint a, uint b) internal returns (uint) {
598         return a < b ? a : b;
599     }
600 
601     /// @notice The fallback function: If the contract's controller has not been
602     ///  set to 0, then the `proxyPayment` method is called which relays the
603     ///  ether and creates tokens as described in the token controller contract
604     function ()  payable {
605         require(isContract(controller));
606         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
607     }
608 
609 //////////
610 // Safety Methods
611 //////////
612 
613     /// @notice This method can be used by the controller to extract mistakenly
614     ///  sent tokens to this contract.
615     /// @param _token The address of the token contract that you want to recover
616     ///  set to 0 in case you want to extract ether.
617     function claimTokens(address _token) onlyController {
618         if (_token == 0x0) {
619             controller.transfer(this.balance);
620             return;
621         }
622 
623         MiniMeToken token = MiniMeToken(_token);
624         uint balance = token.balanceOf(this);
625         token.transfer(controller, balance);
626         ClaimedTokens(_token, controller, balance);
627     }
628 
629 ////////////////
630 // Events
631 ////////////////
632     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
633     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
634     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
635     event Approval(
636         address indexed _owner,
637         address indexed _spender,
638         uint256 _amount
639         );
640 
641 }
642 
643 
644 ////////////////
645 // MiniMeTokenFactory
646 ////////////////
647 
648 /// @dev This contract is used to generate clone contracts from a contract.
649 ///  In solidity this is the way to create a contract from a contract of the
650 ///  same class
651 contract MiniMeTokenFactory {
652 
653     /// @notice Update the DApp by creating a new token with new functionalities
654     ///  the msg.sender becomes the controller of this clone token
655     /// @param _parentToken Address of the token being cloned
656     /// @param _snapshotBlock Block of the parent token that will
657     ///  determine the initial distribution of the clone token
658     /// @param _tokenName Name of the new token
659     /// @param _decimalUnits Number of decimals of the new token
660     /// @param _tokenSymbol Token Symbol for the new token
661     /// @param _transfersEnabled If true, tokens will be able to be transferred
662     /// @return The address of the new token contract
663     function createCloneToken(
664         address _parentToken,
665         uint _snapshotBlock,
666         string _tokenName,
667         uint8 _decimalUnits,
668         string _tokenSymbol,
669         bool _transfersEnabled
670     ) returns (MiniMeToken) {
671         MiniMeToken newToken = new MiniMeToken(
672             this,
673             _parentToken,
674             _snapshotBlock,
675             _tokenName,
676             _decimalUnits,
677             _tokenSymbol,
678             _transfersEnabled
679             );
680 
681         newToken.changeController(msg.sender);
682         return newToken;
683     }
684 }
685 contract TokenBurner {
686     function burn(address , uint )
687     returns (bool result) {
688         return false;
689     }
690 }
691 
692 contract SpectreToken is MiniMeToken, Ownable, ContractReceiver {
693 
694     event WalletAddressesSet(address _spectreTeam, address _managementLocked, address _optionPool);
695 
696     TokenBurner public tokenBurner;
697 
698     //Spectre addresses
699     address public spectreTeam;
700     address public managementLocked;
701     address public optionPool;
702     bool public walletAddressesSet;
703 
704     //In percentages of tokens allocated to Spectre
705     uint256 public SPECTRE_BOUNTY_ADVISORY_DEV_TEAM_ALLOC = 42;
706     uint256 public MANAGEMENT_LOCKED_ALLOC = 18;
707     uint256 public OPTION_POOL_ALLOC = 40;
708 
709     //Lock up periods
710     uint256 public LOCK_START_TIME = 1512896400;
711     uint256 public MANAGEMENT_LOCKED_PERIOD = LOCK_START_TIME + 180 days;
712     uint256 public OPTION_POOL_PERIOD = LOCK_START_TIME + 365 days;
713     mapping (address => uint) public lockedBalances;
714 
715     function setTokenBurner(address _tokenBurner) onlyOwner public {
716       tokenBurner = TokenBurner(_tokenBurner);
717     }
718 
719     function setWalletAddresses(address _spectreTeam, address _managementLocked, address _optionPool) onlyOwner public {
720       require(!walletAddressesSet);
721       require(_spectreTeam != address(0));
722       require(_managementLocked != address(0));
723       require(_optionPool != address(0));
724       spectreTeam = _spectreTeam;
725       managementLocked = _managementLocked;
726       optionPool = _optionPool;
727       walletAddressesSet = true;
728       WalletAddressesSet(spectreTeam, managementLocked, optionPool);
729     }
730 
731     // allows a token holder to burn tokens
732     // requires tokenBurner to be set to a valid contract address
733     // tokenBurner can take any appropriate action
734     function burn(uint256 _amount) public {
735       uint curTotalSupply = totalSupply();
736       require(curTotalSupply >= _amount);
737       uint previousBalanceFrom = balanceOf(msg.sender);
738       require(previousBalanceFrom >= _amount);
739       updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
740       updateValueAtNow(balances[msg.sender], previousBalanceFrom - _amount);
741       assert(tokenBurner.burn(msg.sender, _amount));
742       Transfer(msg.sender, 0, _amount);
743     }
744 
745     //@notice function to accept incoming token transfers from SPECT
746     //@notice _from - address that is transferring tokens
747     //@notice _value - amount of tokens being transferred
748     //@notice _data - ignored - no data is expected
749     function tokenFallback(address _from, uint _value, bytes _data) public {
750       require(walletAddressesSet);
751       //First we generate tokens for user that is transferring
752       generateTokens(_from, _value);
753       //Then we generate Spectre team tokens
754       generateSpectreTokens(_value);
755     }
756 
757     function generateSpectreTokens(uint256 _value) internal {
758       //Calculate amounts for each Spectre Wallet
759       uint256 managementLockedAlloc = SafeMath.div(SafeMath.mul(_value, percent(MANAGEMENT_LOCKED_ALLOC)), percent(100));
760       uint256 optionPoolAlloc = SafeMath.div(SafeMath.mul(_value, percent(OPTION_POOL_ALLOC)), percent(100));
761       //Account for any rounding errors by using subtraction rather than allocation
762       //spectreTeam allocation is for bounty, dev, and advisory allocations
763       //quantity should correspond to SPECTRE_BOUNTY_ADVISORY_DEV_TEAM_ALLOC percentage
764       uint256 spectreTeamAlloc = SafeMath.sub(_value, SafeMath.add(managementLockedAlloc, optionPoolAlloc));
765       //Assert invariant
766       assert(SafeMath.add(SafeMath.add(managementLockedAlloc, optionPoolAlloc), spectreTeamAlloc) == _value);
767       //Generate team tokens
768       generateTokens(spectreTeam, spectreTeamAlloc);
769       generateTokens(managementLocked, managementLockedAlloc);
770       generateTokens(optionPool, optionPoolAlloc);
771       //Lock balances - no locks for spectreTeam
772       lockedBalances[managementLocked] = SafeMath.add(managementLockedAlloc, lockedBalances[managementLocked]);
773       lockedBalances[optionPool] = SafeMath.add(optionPoolAlloc, lockedBalances[optionPool]);
774     }
775 
776     // Check token locks before transferring
777     function transfer(address _to, uint _value) returns (bool success) {
778       require(checkLockedBalance(msg.sender, _value));
779       require(super.transfer(_to, _value));
780       return true;
781     }
782 
783     // Override this to enforce locking periods
784     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
785       require(checkLockedBalance(_from, _value));
786       require(super.transferFrom(_from, _to, _value));
787       return true;
788     }
789 
790     //Check whether transfer is valid for locked tokens
791     function checkLockedBalance(address _holder, uint256 _value) public constant returns (bool success) {
792       if ((_holder != managementLocked) && (_holder != optionPool)) {
793         return true;
794       }
795       if ((_holder == managementLocked) && (getNow() > MANAGEMENT_LOCKED_PERIOD)) {
796         return true;
797       }
798       if ((_holder == optionPool) && (getNow() > OPTION_POOL_PERIOD)) {
799         return true;
800       }
801       return (SafeMath.sub(balanceOf(_holder), _value) >= lockedBalances[_holder]);
802     }
803 
804     function percent(uint256 p) constant internal returns (uint256) {
805       return SafeMath.mul(p, 10**16);
806     }
807 
808     function getNow() internal constant returns (uint256) {
809       return now;
810     }
811 }
812 
813 contract SpectreUtilityToken is SpectreToken {
814 
815     function SpectreUtilityToken(address _tokenFactory)
816       MiniMeToken(
817         _tokenFactory,
818         0x0,                     // no parent token
819         0,                       // no snapshot block number from parent
820         "Spectre.ai U-Token",           // Token name
821         18,                       // Decimals
822         "SXUT",                   // Symbol
823         true                    // Enable transfers
824       )
825     {}
826 
827 }