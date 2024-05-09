1 pragma solidity ^0.4.18;
2 
3 contract Controlled {
4     /// @notice The address of the controller is the only address that can call
5     ///  a function with this modifier
6     modifier onlyController { require(msg.sender == controller); _; }
7 
8     address public controller;
9 
10     function Controlled() public { controller = msg.sender;}
11 
12     /// @notice Changes the controller of the contract
13     /// @param _newController The new controller of the contract
14     function changeController(address _newController) public onlyController {
15         controller = _newController;
16     }
17 }
18 
19 pragma solidity ^0.4.18;
20 
21 /// @dev The token controller contract must implement these functions
22 contract TokenController {
23     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
24     /// @param _owner The address that sent the ether to create tokens
25     /// @return True if the ether is accepted, false if it throws
26     function proxyPayment(address _owner) public payable returns(bool);
27 
28     /// @notice Notifies the controller about a token transfer allowing the
29     ///  controller to react if desired
30     /// @param _from The origin of the transfer
31     /// @param _to The destination of the transfer
32     /// @param _amount The amount of the transfer
33     /// @return False if the controller does not authorize the transfer
34     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
35 
36     /// @notice Notifies the controller about an approval allowing the
37     ///  controller to react if desired
38     /// @param _owner The address that calls `approve()`
39     /// @param _spender The spender in the `approve()` call
40     /// @param _amount The amount in the `approve()` call
41     /// @return False if the controller does not authorize the approval
42     function onApprove(address _owner, address _spender, uint _amount) public
43         returns(bool);
44 }
45 
46 pragma solidity ^0.4.18;
47 
48 /*
49     Copyright 2016, Jordi Baylina
50 
51     This program is free software: you can redistribute it and/or modify
52     it under the terms of the GNU General Public License as published by
53     the Free Software Foundation, either version 3 of the License, or
54     (at your option) any later version.
55 
56     This program is distributed in the hope that it will be useful,
57     but WITHOUT ANY WARRANTY; without even the implied warranty of
58     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
59     GNU General Public License for more details.
60 
61     You should have received a copy of the GNU General Public License
62     along with this program.  If not, see <http://www.gnu.org/licenses/>.
63  */
64 
65 /// @title MiniMeToken Contract
66 /// @author Jordi Baylina
67 /// @dev This token contract's goal is to make it easy for anyone to clone this
68 ///  token using the token distribution at a given block, this will allow DAO's
69 ///  and DApps to upgrade their features in a decentralized manner without
70 ///  affecting the original token
71 /// @dev It is ERC20 compliant, but still needs to under go further testing.
72 
73 
74 
75 contract ApproveAndCallFallBack {
76     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
77 }
78 
79 /// @dev The actual token contract, the default controller is the msg.sender
80 ///  that deploys the contract, so usually this token will be deployed by a
81 ///  token controller contract, which Giveth will call a "Campaign"
82 contract MiniMeToken is Controlled {
83 
84     string public name;                //The Token's name: e.g. DigixDAO Tokens
85     uint8 public decimals;             //Number of decimals of the smallest unit
86     string public symbol;              //An identifier: e.g. REP
87     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
88 
89 
90     /// @dev `Checkpoint` is the structure that attaches a block number to a
91     ///  given value, the block number attached is the one that last changed the
92     ///  value
93     struct  Checkpoint {
94 
95         // `fromBlock` is the block number that the value was generated from
96         uint128 fromBlock;
97 
98         // `value` is the amount of tokens at a specific block number
99         uint128 value;
100     }
101 
102     // `parentToken` is the Token address that was cloned to produce this token;
103     //  it will be 0x0 for a token that was not cloned
104     MiniMeToken public parentToken;
105 
106     // `parentSnapShotBlock` is the block number from the Parent Token that was
107     //  used to determine the initial distribution of the Clone Token
108     uint public parentSnapShotBlock;
109 
110     // `creationBlock` is the block number that the Clone Token was created
111     uint public creationBlock;
112 
113     // `balances` is the map that tracks the balance of each address, in this
114     //  contract when the balance changes the block number that the change
115     //  occurred is also included in the map
116     mapping (address => Checkpoint[]) balances;
117 
118     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
119     mapping (address => mapping (address => uint256)) allowed;
120 
121     // Tracks the history of the `totalSupply` of the token
122     Checkpoint[] totalSupplyHistory;
123 
124     // Flag that determines if the token is transferable or not.
125     bool public transfersEnabled;
126 
127     // The factory used to create new clone tokens
128     MiniMeTokenFactory public tokenFactory;
129 
130 ////////////////
131 // Constructor
132 ////////////////
133 
134     /// @notice Constructor to create a MiniMeToken
135     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
136     ///  will create the Clone token contracts, the token factory needs to be
137     ///  deployed first
138     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
139     ///  new token
140     /// @param _parentSnapShotBlock Block of the parent token that will
141     ///  determine the initial distribution of the clone token, set to 0 if it
142     ///  is a new token
143     /// @param _tokenName Name of the new token
144     /// @param _decimalUnits Number of decimals of the new token
145     /// @param _tokenSymbol Token Symbol for the new token
146     /// @param _transfersEnabled If true, tokens will be able to be transferred
147     function MiniMeToken(
148         address _tokenFactory,
149         address _parentToken,
150         uint _parentSnapShotBlock,
151         string _tokenName,
152         uint8 _decimalUnits,
153         string _tokenSymbol,
154         bool _transfersEnabled
155     ) public {
156         tokenFactory = MiniMeTokenFactory(_tokenFactory);
157         name = _tokenName;                                 // Set the name
158         decimals = _decimalUnits;                          // Set the decimals
159         symbol = _tokenSymbol;                             // Set the symbol
160         parentToken = MiniMeToken(_parentToken);
161         parentSnapShotBlock = _parentSnapShotBlock;
162         transfersEnabled = _transfersEnabled;
163         creationBlock = block.number;
164     }
165 
166 
167 ///////////////////
168 // ERC20 Methods
169 ///////////////////
170 
171     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
172     /// @param _to The address of the recipient
173     /// @param _amount The amount of tokens to be transferred
174     /// @return Whether the transfer was successful or not
175     function transfer(address _to, uint256 _amount) public returns (bool success) {
176         require(transfersEnabled);
177         doTransfer(msg.sender, _to, _amount);
178         return true;
179     }
180 
181     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
182     ///  is approved by `_from`
183     /// @param _from The address holding the tokens being transferred
184     /// @param _to The address of the recipient
185     /// @param _amount The amount of tokens to be transferred
186     /// @return True if the transfer was successful
187     function transferFrom(address _from, address _to, uint256 _amount
188     ) public returns (bool success) {
189 
190         // The controller of this contract can move tokens around at will,
191         //  this is important to recognize! Confirm that you trust the
192         //  controller of this contract, which in most situations should be
193         //  another open source smart contract or 0x0
194         if (msg.sender != controller) {
195             require(transfersEnabled);
196 
197             // The standard ERC 20 transferFrom functionality
198             require(allowed[_from][msg.sender] >= _amount);
199             allowed[_from][msg.sender] -= _amount;
200         }
201         doTransfer(_from, _to, _amount);
202         return true;
203     }
204 
205     /// @dev This is the actual transfer function in the token contract, it can
206     ///  only be called by other functions in this contract.
207     /// @param _from The address holding the tokens being transferred
208     /// @param _to The address of the recipient
209     /// @param _amount The amount of tokens to be transferred
210     /// @return True if the transfer was successful
211     function doTransfer(address _from, address _to, uint _amount
212     ) internal {
213 
214            if (_amount == 0) {
215                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
216                return;
217            }
218 
219            require(parentSnapShotBlock < block.number);
220 
221            // Do not allow transfer to 0x0 or the token contract itself
222            require((_to != 0) && (_to != address(this)));
223 
224            // If the amount being transfered is more than the balance of the
225            //  account the transfer throws
226            var previousBalanceFrom = balanceOfAt(_from, block.number);
227 
228            require(previousBalanceFrom >= _amount);
229 
230            // Alerts the token controller of the transfer
231            if (isContract(controller)) {
232                require(TokenController(controller).onTransfer(_from, _to, _amount));
233            }
234 
235            // First update the balance array with the new value for the address
236            //  sending the tokens
237            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
238 
239            // Then update the balance array with the new value for the address
240            //  receiving the tokens
241            var previousBalanceTo = balanceOfAt(_to, block.number);
242            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
243            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
244 
245            // An event to make the transfer easy to find on the blockchain
246            Transfer(_from, _to, _amount);
247 
248     }
249 
250     /// @param _owner The address that's balance is being requested
251     /// @return The balance of `_owner` at the current block
252     function balanceOf(address _owner) public constant returns (uint256 balance) {
253         return balanceOfAt(_owner, block.number);
254     }
255 
256     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
257     ///  its behalf. This is a modified version of the ERC20 approve function
258     ///  to be a little bit safer
259     /// @param _spender The address of the account able to transfer the tokens
260     /// @param _amount The amount of tokens to be approved for transfer
261     /// @return True if the approval was successful
262     function approve(address _spender, uint256 _amount) public returns (bool success) {
263         require(transfersEnabled);
264 
265         // To change the approve amount you first have to reduce the addresses`
266         //  allowance to zero by calling `approve(_spender,0)` if it is not
267         //  already 0 to mitigate the race condition described here:
268         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
269         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
270 
271         // Alerts the token controller of the approve function call
272         if (isContract(controller)) {
273             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
274         }
275 
276         allowed[msg.sender][_spender] = _amount;
277         Approval(msg.sender, _spender, _amount);
278         return true;
279     }
280 
281     /// @dev This function makes it easy to read the `allowed[]` map
282     /// @param _owner The address of the account that owns the token
283     /// @param _spender The address of the account able to transfer the tokens
284     /// @return Amount of remaining tokens of _owner that _spender is allowed
285     ///  to spend
286     function allowance(address _owner, address _spender
287     ) public constant returns (uint256 remaining) {
288         return allowed[_owner][_spender];
289     }
290 
291     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
292     ///  its behalf, and then a function is triggered in the contract that is
293     ///  being approved, `_spender`. This allows users to use their tokens to
294     ///  interact with contracts in one function call instead of two
295     /// @param _spender The address of the contract able to transfer the tokens
296     /// @param _amount The amount of tokens to be approved for transfer
297     /// @return True if the function call was successful
298     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
299     ) public returns (bool success) {
300         require(approve(_spender, _amount));
301 
302         ApproveAndCallFallBack(_spender).receiveApproval(
303             msg.sender,
304             _amount,
305             this,
306             _extraData
307         );
308 
309         return true;
310     }
311 
312     /// @dev This function makes it easy to get the total number of tokens
313     /// @return The total number of tokens
314     function totalSupply() public constant returns (uint) {
315         return totalSupplyAt(block.number);
316     }
317 
318 
319 ////////////////
320 // Query balance and totalSupply in History
321 ////////////////
322 
323     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
324     /// @param _owner The address from which the balance will be retrieved
325     /// @param _blockNumber The block number when the balance is queried
326     /// @return The balance at `_blockNumber`
327     function balanceOfAt(address _owner, uint _blockNumber) public constant
328         returns (uint) {
329 
330         // These next few lines are used when the balance of the token is
331         //  requested before a check point was ever created for this token, it
332         //  requires that the `parentToken.balanceOfAt` be queried at the
333         //  genesis block for that token as this contains initial balance of
334         //  this token
335         if ((balances[_owner].length == 0)
336             || (balances[_owner][0].fromBlock > _blockNumber)) {
337             if (address(parentToken) != 0) {
338                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
339             } else {
340                 // Has no parent
341                 return 0;
342             }
343 
344         // This will return the expected balance during normal situations
345         } else {
346             return getValueAt(balances[_owner], _blockNumber);
347         }
348     }
349 
350     /// @notice Total amount of tokens at a specific `_blockNumber`.
351     /// @param _blockNumber The block number when the totalSupply is queried
352     /// @return The total amount of tokens at `_blockNumber`
353     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
354 
355         // These next few lines are used when the totalSupply of the token is
356         //  requested before a check point was ever created for this token, it
357         //  requires that the `parentToken.totalSupplyAt` be queried at the
358         //  genesis block for this token as that contains totalSupply of this
359         //  token at this block number.
360         if ((totalSupplyHistory.length == 0)
361             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
362             if (address(parentToken) != 0) {
363                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
364             } else {
365                 return 0;
366             }
367 
368         // This will return the expected totalSupply during normal situations
369         } else {
370             return getValueAt(totalSupplyHistory, _blockNumber);
371         }
372     }
373 
374 ////////////////
375 // Clone Token Method
376 ////////////////
377 
378     /// @notice Creates a new clone token with the initial distribution being
379     ///  this token at `_snapshotBlock`
380     /// @param _cloneTokenName Name of the clone token
381     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
382     /// @param _cloneTokenSymbol Symbol of the clone token
383     /// @param _snapshotBlock Block when the distribution of the parent token is
384     ///  copied to set the initial distribution of the new clone token;
385     ///  if the block is zero than the actual block, the current block is used
386     /// @param _transfersEnabled True if transfers are allowed in the clone
387     /// @return The address of the new MiniMeToken Contract
388     function createCloneToken(
389         string _cloneTokenName,
390         uint8 _cloneDecimalUnits,
391         string _cloneTokenSymbol,
392         uint _snapshotBlock,
393         bool _transfersEnabled
394         ) public returns(address) {
395         if (_snapshotBlock == 0) _snapshotBlock = block.number;
396         MiniMeToken cloneToken = tokenFactory.createCloneToken(
397             this,
398             _snapshotBlock,
399             _cloneTokenName,
400             _cloneDecimalUnits,
401             _cloneTokenSymbol,
402             _transfersEnabled
403             );
404 
405         cloneToken.changeController(msg.sender);
406 
407         // An event to make the token easy to find on the blockchain
408         NewCloneToken(address(cloneToken), _snapshotBlock);
409         return address(cloneToken);
410     }
411 
412 ////////////////
413 // Generate and destroy tokens
414 ////////////////
415 
416     /// @notice Generates `_amount` tokens that are assigned to `_owner`
417     /// @param _owner The address that will be assigned the new tokens
418     /// @param _amount The quantity of tokens generated
419     /// @return True if the tokens are generated correctly
420     function generateTokens(address _owner, uint _amount
421     ) public onlyController returns (bool) {
422         uint curTotalSupply = totalSupply();
423         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
424         uint previousBalanceTo = balanceOf(_owner);
425         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
426         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
427         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
428         Transfer(0, _owner, _amount);
429         return true;
430     }
431 
432 
433     /// @notice Burns `_amount` tokens from `_owner`
434     /// @param _owner The address that will lose the tokens
435     /// @param _amount The quantity of tokens to burn
436     /// @return True if the tokens are burned correctly
437     function destroyTokens(address _owner, uint _amount
438     ) onlyController public returns (bool) {
439         uint curTotalSupply = totalSupply();
440         require(curTotalSupply >= _amount);
441         uint previousBalanceFrom = balanceOf(_owner);
442         require(previousBalanceFrom >= _amount);
443         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
444         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
445         Transfer(_owner, 0, _amount);
446         return true;
447     }
448 
449 ////////////////
450 // Enable tokens transfers
451 ////////////////
452 
453 
454     /// @notice Enables token holders to transfer their tokens freely if true
455     /// @param _transfersEnabled True if transfers are allowed in the clone
456     function enableTransfers(bool _transfersEnabled) public onlyController {
457         transfersEnabled = _transfersEnabled;
458     }
459 
460 ////////////////
461 // Internal helper functions to query and set a value in a snapshot array
462 ////////////////
463 
464     /// @dev `getValueAt` retrieves the number of tokens at a given block number
465     /// @param checkpoints The history of values being queried
466     /// @param _block The block number to retrieve the value at
467     /// @return The number of tokens being queried
468     function getValueAt(Checkpoint[] storage checkpoints, uint _block
469     ) constant internal returns (uint) {
470         if (checkpoints.length == 0) return 0;
471 
472         // Shortcut for the actual value
473         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
474             return checkpoints[checkpoints.length-1].value;
475         if (_block < checkpoints[0].fromBlock) return 0;
476 
477         // Binary search of the value in the array
478         uint min = 0;
479         uint max = checkpoints.length-1;
480         while (max > min) {
481             uint mid = (max + min + 1)/ 2;
482             if (checkpoints[mid].fromBlock<=_block) {
483                 min = mid;
484             } else {
485                 max = mid-1;
486             }
487         }
488         return checkpoints[min].value;
489     }
490 
491     /// @dev `updateValueAtNow` used to update the `balances` map and the
492     ///  `totalSupplyHistory`
493     /// @param checkpoints The history of data being updated
494     /// @param _value The new number of tokens
495     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
496     ) internal  {
497         if ((checkpoints.length == 0)
498         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
499                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
500                newCheckPoint.fromBlock =  uint128(block.number);
501                newCheckPoint.value = uint128(_value);
502            } else {
503                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
504                oldCheckPoint.value = uint128(_value);
505            }
506     }
507 
508     /// @dev Internal function to determine if an address is a contract
509     /// @param _addr The address being queried
510     /// @return True if `_addr` is a contract
511     function isContract(address _addr) constant internal returns(bool) {
512         uint size;
513         if (_addr == 0) return false;
514         assembly {
515             size := extcodesize(_addr)
516         }
517         return size>0;
518     }
519 
520     /// @dev Helper function to return a min betwen the two uints
521     function min(uint a, uint b) pure internal returns (uint) {
522         return a < b ? a : b;
523     }
524 
525     /// @notice The fallback function: If the contract's controller has not been
526     ///  set to 0, then the `proxyPayment` method is called which relays the
527     ///  ether and creates tokens as described in the token controller contract
528     function () public payable {
529         require(isContract(controller));
530         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
531     }
532 
533 //////////
534 // Safety Methods
535 //////////
536 
537     /// @notice This method can be used by the controller to extract mistakenly
538     ///  sent tokens to this contract.
539     /// @param _token The address of the token contract that you want to recover
540     ///  set to 0 in case you want to extract ether.
541     function claimTokens(address _token) public onlyController {
542         if (_token == 0x0) {
543             controller.transfer(this.balance);
544             return;
545         }
546 
547         MiniMeToken token = MiniMeToken(_token);
548         uint balance = token.balanceOf(this);
549         token.transfer(controller, balance);
550         ClaimedTokens(_token, controller, balance);
551     }
552 
553 ////////////////
554 // Events
555 ////////////////
556     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
557     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
558     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
559     event Approval(
560         address indexed _owner,
561         address indexed _spender,
562         uint256 _amount
563         );
564 
565 }
566 
567 
568 ////////////////
569 // MiniMeTokenFactory
570 ////////////////
571 
572 /// @dev This contract is used to generate clone contracts from a contract.
573 ///  In solidity this is the way to create a contract from a contract of the
574 ///  same class
575 contract MiniMeTokenFactory {
576 
577     /// @notice Update the DApp by creating a new token with new functionalities
578     ///  the msg.sender becomes the controller of this clone token
579     /// @param _parentToken Address of the token being cloned
580     /// @param _snapshotBlock Block of the parent token that will
581     ///  determine the initial distribution of the clone token
582     /// @param _tokenName Name of the new token
583     /// @param _decimalUnits Number of decimals of the new token
584     /// @param _tokenSymbol Token Symbol for the new token
585     /// @param _transfersEnabled If true, tokens will be able to be transferred
586     /// @return The address of the new token contract
587     function createCloneToken(
588         address _parentToken,
589         uint _snapshotBlock,
590         string _tokenName,
591         uint8 _decimalUnits,
592         string _tokenSymbol,
593         bool _transfersEnabled
594     ) public returns (MiniMeToken) {
595         MiniMeToken newToken = new MiniMeToken(
596             this,
597             _parentToken,
598             _snapshotBlock,
599             _tokenName,
600             _decimalUnits,
601             _tokenSymbol,
602             _transfersEnabled
603             );
604 
605         newToken.changeController(msg.sender);
606         return newToken;
607     }
608 }
609 
610 pragma solidity ^0.4.18;
611 
612 
613 /**
614  * @title SafeMath
615  * @dev Math operations with safety checks that throw on error
616  */
617 library SafeMath {
618 
619   /**
620   * @dev Multiplies two numbers, throws on overflow.
621   */
622   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
623     if (a == 0) {
624       return 0;
625     }
626     uint256 c = a * b;
627     assert(c / a == b);
628     return c;
629   }
630 
631   /**
632   * @dev Integer division of two numbers, truncating the quotient.
633   */
634   function div(uint256 a, uint256 b) internal pure returns (uint256) {
635     // assert(b > 0); // Solidity automatically throws when dividing by 0
636     uint256 c = a / b;
637     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
638     return c;
639   }
640 
641   /**
642   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
643   */
644   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
645     assert(b <= a);
646     return a - b;
647   }
648 
649   /**
650   * @dev Adds two numbers, throws on overflow.
651   */
652   function add(uint256 a, uint256 b) internal pure returns (uint256) {
653     uint256 c = a + b;
654     assert(c >= a);
655     return c;
656   }
657 }
658 
659 pragma solidity ^0.4.18;
660 
661 /*
662     Copyright 2016, Jordi Baylina
663 
664     This program is free software: you can redistribute it and/or modify
665     it under the terms of the GNU General Public License as published by
666     the Free Software Foundation, either version 3 of the License, or
667     (at your option) any later version.
668 
669     This program is distributed in the hope that it will be useful,
670     but WITHOUT ANY WARRANTY; without even the implied warranty of
671     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
672     GNU General Public License for more details.
673 
674     You should have received a copy of the GNU General Public License
675     along with this program.  If not, see <http://www.gnu.org/licenses/>.
676  */
677 
678 /// @title MiniMeToken Contract
679 /// @author Jordi Baylina
680 /// @dev This token contract's goal is to make it easy for anyone to clone this
681 ///  token using the token distribution at a given block, this will allow DAO's
682 ///  and DApps to upgrade their features in a decentralized manner without
683 ///  affecting the original token
684 /// @dev It is ERC20 compliant, but still needs to under go further testing.
685 
686 
687 
688 
689 
690 /// @dev The actual token contract, the default controller is the msg.sender
691 contract MiniMeMultiplyToken is MiniMeToken {
692 
693     uint8 public multiplyParent;             //Number of Multiply of parents Token balances
694 
695 ////////////////
696 // Constructor
697 ////////////////
698 
699     /// @notice Constructor to create a MiniMeToken
700     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
701     ///  will create the Clone token contracts, the token factory needs to be
702     ///  deployed first
703     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
704     ///  new token
705     /// @param _parentSnapShotBlock Block of the parent token that will
706     ///  determine the initial distribution of the clone token, set to 0 if it
707     ///  is a new token
708     /// @param _tokenName Name of the new token
709     /// @param _decimalUnits Number of decimals of the new token
710     /// @param _tokenSymbol Token Symbol for the new token
711     /// @param _transfersEnabled If true, tokens will be able to be transferred
712     function MiniMeMultiplyToken(
713         address _tokenFactory,
714         address _parentToken,
715         uint _parentSnapShotBlock,
716         string _tokenName,
717         uint8 _decimalUnits,
718         uint8 _multiplyParent,
719         string _tokenSymbol,
720         bool _transfersEnabled
721     ) public MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
722         multiplyParent = _multiplyParent;                  // Set the multiply
723     }
724 
725 
726 ////////////////
727 // Query balance and totalSupply in History
728 ////////////////
729 
730     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
731     /// @param _owner The address from which the balance will be retrieved
732     /// @param _blockNumber The block number when the balance is queried
733     /// @return The balance at `_blockNumber`
734     function balanceOfAt(address _owner, uint _blockNumber) public constant
735         returns (uint) {
736 
737         // These next few lines are used when the balance of the token is
738         //  requested before a check point was ever created for this token, it
739         //  requires that the `parentToken.balanceOfAt` be queried at the
740         //  genesis block for that token as this contains initial balance of
741         //  this token
742         if ((balances[_owner].length == 0)
743             || (balances[_owner][0].fromBlock > _blockNumber)) {
744             if (address(parentToken) != 0) {
745                 return SafeMath.mul(parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock)), multiplyParent);
746             } else {
747                 // Has no parent
748                 return 0;
749             }
750 
751         // This will return the expected balance during normal situations
752         } else {
753             return getValueAt(balances[_owner], _blockNumber);
754         }
755     }
756 
757     /// @notice Total amount of tokens at a specific `_blockNumber`.
758     /// @param _blockNumber The block number when the totalSupply is queried
759     /// @return The total amount of tokens at `_blockNumber`
760     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
761 
762         // These next few lines are used when the totalSupply of the token is
763         //  requested before a check point was ever created for this token, it
764         //  requires that the `parentToken.totalSupplyAt` be queried at the
765         //  genesis block for this token as that contains totalSupply of this
766         //  token at this block number.
767         if ((totalSupplyHistory.length == 0)
768             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
769             if (address(parentToken) != 0) {
770                 return SafeMath.mul(parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock)), multiplyParent);
771             } else {
772                 return 0;
773             }
774 
775         // This will return the expected totalSupply during normal situations
776         } else {
777             return getValueAt(totalSupplyHistory, _blockNumber);
778         }
779     }
780 }
781 
782 pragma solidity^0.4.18;
783 
784 
785 contract RankingBallGoldClone is MiniMeMultiplyToken {
786     function RankingBallGoldClone(address _tokenFactory, address parent, uint snapshot, uint8 multiply)
787       MiniMeMultiplyToken(
788         _tokenFactory,
789         parent,                     // no parent token
790         snapshot,                   // no snapshot block number from parent
791         "Global Digital Content",  // Token name
792         18,                      // Decimals
793         multiply,                // Multiply Number of parent Balance
794         "GDC",                   // Symbol
795         true                     // Enable transfers
796       ) {}
797 }