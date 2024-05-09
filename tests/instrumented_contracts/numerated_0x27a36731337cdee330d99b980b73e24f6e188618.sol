1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Math
38  * @dev Assorted math operations
39  */
40 
41 library Math {
42   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
55     return a < b ? a : b;
56   }
57 }
58 
59 
60 // Slightly modified Zeppelin's Vested Token deriving MiniMeToken
61 
62 /*
63     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
64     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
65     Copyright 2017, Jordi Baylina (Giveth)
66 
67     Based on MiniMeToken.sol from https://github.com/Giveth/minime
68 */
69 
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
72 }
73 
74 /*
75     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
76     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
77     Copyright 2017, Jordi Baylina (Giveth)
78 
79     Based on MiniMeToken.sol from https://github.com/Giveth/minime
80  */
81 
82 contract Controlled {
83     address public controller;
84 
85     function Controlled() {
86          controller = msg.sender;
87     }
88 
89     /// @notice The address of the controller is the only address that can call
90     ///    a function with this modifier
91     modifier onlyController {
92         require(msg.sender == controller);
93         _;
94     }
95 
96     /// @notice Changes the controller of the contract
97     /// @param _newController The new controller of the contract
98     function changeController(address _newController) onlyController {
99         controller = _newController;
100     }
101 }
102 
103 /*
104     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
105     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
106     Copyright 2017, Jordi Baylina (Giveth)
107 
108     Based on MiniMeToken.sol from https://github.com/Giveth/minime
109  */
110 
111 /// @dev The token controller contract must implement these functions
112 contract TokenController {
113     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
114     /// @param _owner The address that sent the ether to create tokens
115     /// @return True if the ether is accepted, false if it throws
116     function proxyPayment(address _owner) payable returns(bool);
117 
118     /// @notice Notifies the controller about a token transfer allowing the
119     ///    controller to react if desired
120     /// @param _from The origin of the transfer
121     /// @param _to The destination of the transfer
122     /// @param _amount The amount of the transfer
123     /// @return False if the controller does not authorize the transfer
124     function onTransfer(address _from, address _to, uint _amount) returns(bool);
125 
126     /// @notice Notifies the controller about an approval allowing the
127     ///    controller to react if desired
128     /// @param _owner The address that calls `approve()`
129     /// @param _spender The spender in the `approve()` call
130     /// @param _amount The amount in the `approve()` call
131     /// @return False if the controller does not authorize the approval
132     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
133 }
134 
135 /*
136     Copyright 2016, Jordi Baylina
137 
138     This program is free software: you can redistribute it and/or modify
139     it under the terms of the GNU General Public License as published by
140     the Free Software Foundation, either version 3 of the License, or
141     (at your option) any later version.
142 
143     This program is distributed in the hope that it will be useful,
144     but WITHOUT ANY WARRANTY; without even the implied warranty of
145     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
146     GNU General Public License for more details.
147 
148     You should have received a copy of the GNU General Public License
149     along with this program.    If not, see <http://www.gnu.org/licenses/>.
150  */
151 
152 /// @title MiniMeToken Contract
153 /// @author Jordi Baylina
154 /// @dev This token contract's goal is to make it easy for anyone to clone this
155 ///    token using the token distribution at a given block, this will allow DAO's
156 ///    and DApps to upgrade their features in a decentralized manner without
157 ///    affecting the original token
158 /// @dev It is ERC20 compliant, but still needs to under go further testing.
159 
160 /// @dev The actual token contract, the default controller is the msg.sender
161 ///    that deploys the contract, so usually this token will be deployed by a
162 ///    token controller contract, which Giveth will call a "Campaign"
163 contract MiniMeToken is Controlled {
164 
165     string public name;               //The Token's name: e.g. DigixDAO Tokens
166     uint8 public decimals;             //Number of decimals of the smallest unit
167     string public symbol;               //An identifier: e.g. REP
168     string public version = "MMT_0.1"; //An arbitrary versioning scheme
169 
170 
171     /// @dev `Checkpoint` is the structure that attaches a block number to a
172     ///    given value, the block number attached is the one that last changed the
173     ///    value
174     struct    Checkpoint {
175 
176         // `fromBlock` is the block number that the value was generated from
177         uint128 fromBlock;
178 
179         // `value` is the amount of tokens at a specific block number
180         uint128 value;
181     }
182 
183     // `parentToken` is the Token address that was cloned to produce this token;
184     //    it will be 0x0 for a token that was not cloned
185     MiniMeToken public parentToken;
186 
187     // `parentSnapShotBlock` is the block number from the Parent Token that was
188     //    used to determine the initial distribution of the Clone Token
189     uint public parentSnapShotBlock;
190 
191     // `creationBlock` is the block number that the Clone Token was created
192     uint public creationBlock;
193 
194     // `balances` is the map that tracks the balance of each address, in this
195     //    contract when the balance changes the block number that the change
196     //    occurred is also included in the map
197     mapping (address => Checkpoint[]) balances;
198 
199     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
200     mapping (address => mapping (address => uint256)) allowed;
201 
202     // Tracks the history of the `totalSupply` of the token
203     Checkpoint[] totalSupplyHistory;
204 
205     // Flag that determines if the token is transferable or not.
206     bool public transfersEnabled;
207 
208     // The factory used to create new clone tokens
209     MiniMeTokenFactory public tokenFactory;
210 
211 ////////////////
212 // Constructor
213 ////////////////
214 
215     /// @notice Constructor to create a MiniMeToken
216     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
217     ///    will create the Clone token contracts, the token factory needs to be
218     ///    deployed first
219     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
220     ///    new token
221     /// @param _parentSnapShotBlock Block of the parent token that will
222     ///    determine the initial distribution of the clone token, set to 0 if it
223     ///    is a new token
224     /// @param _tokenName Name of the new token
225     /// @param _decimalUnits Number of decimals of the new token
226     /// @param _tokenSymbol Token Symbol for the new token
227     /// @param _transfersEnabled If true, tokens will be able to be transferred
228     function MiniMeToken(
229         address _tokenFactory,
230         address _parentToken,
231         uint _parentSnapShotBlock,
232         string _tokenName,
233         uint8 _decimalUnits,
234         string _tokenSymbol,
235         bool _transfersEnabled
236     ) {
237         tokenFactory = MiniMeTokenFactory(_tokenFactory);
238         name = _tokenName;                                // Set the name
239         decimals = _decimalUnits;                            // Set the decimals
240         symbol = _tokenSymbol;                             // Set the symbol
241         parentToken = MiniMeToken(_parentToken);
242         parentSnapShotBlock = _parentSnapShotBlock;
243         transfersEnabled = _transfersEnabled;
244         creationBlock = block.number;
245     }
246 
247 
248 ///////////////////
249 // ERC20 Methods
250 ///////////////////
251 
252     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
253     /// @param _to The address of the recipient
254     /// @param _amount The amount of tokens to be transferred
255     /// @return Whether the transfer was successful or not
256     function transfer(address _to, uint256 _amount) returns (bool success) {
257         require(transfersEnabled);
258         doTransfer(msg.sender, _to, _amount);
259         return true;
260     }
261 
262     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
263     ///    is approved by `_from`
264     /// @param _from The address holding the tokens being transferred
265     /// @param _to The address of the recipient
266     /// @param _amount The amount of tokens to be transferred
267     /// @return True if the transfer was successful
268     function transferFrom(address _from, address _to, uint256 _amount
269     ) returns (bool success) {
270 
271         // The controller of this contract can move tokens around at will,
272         //    this is important to recognize! Confirm that you trust the
273         //    controller of this contract, which in most situations should be
274         //    another open source smart contract or 0x0
275         if (msg.sender != controller) {
276             require(transfersEnabled);
277 
278             // The standard ERC 20 transferFrom functionality
279             require(allowed[_from][msg.sender] >= _amount);
280             allowed[_from][msg.sender] -= _amount;
281         }
282         doTransfer(_from, _to, _amount);
283         return true;
284     }
285 
286     /// @dev This is the actual transfer function in the token contract, it can
287     ///    only be called by other functions in this contract.
288     /// @param _from The address holding the tokens being transferred
289     /// @param _to The address of the recipient
290     /// @param _amount The amount of tokens to be transferred
291     /// @return True if the transfer was successful
292     function doTransfer(address _from, address _to, uint _amount
293     ) internal {
294 
295              if (_amount == 0) {
296              Transfer(_from, _to, _amount);    // Follow the spec to issue the event when transfer 0
297              return;
298              }
299 
300              require(parentSnapShotBlock < block.number);
301 
302              // Do not allow transfer to 0x0 or the token contract itself
303              require((_to != 0) && (_to != address(this)));
304 
305              // If the amount being transfered is more than the balance of the
306              //    account the transfer throws
307              uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
308              require(previousBalanceFrom >= _amount);
309 
310              // Alerts the token controller of the transfer
311              if (isContract(controller)) {
312                  require(TokenController(controller).onTransfer(_from, _to, _amount));
313              }
314 
315              // First update the balance array with the new value for the address
316              //    sending the tokens
317              updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
318 
319              // Then update the balance array with the new value for the address
320              //    receiving the tokens
321              uint256 previousBalanceTo = balanceOfAt(_to, block.number);
322              require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
323              updateValueAtNow(balances[_to], previousBalanceTo + _amount);
324 
325              // An event to make the transfer easy to find on the blockchain
326              Transfer(_from, _to, _amount);
327 
328     }
329 
330     /// @param _owner The address that's balance is being requested
331     /// @return The balance of `_owner` at the current block
332     function balanceOf(address _owner) public view returns (uint256 balance) {
333         return balanceOfAt(_owner, block.number);
334     }
335 
336     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
337     ///    its behalf. This is a modified version of the ERC20 approve function
338     ///    to be a little bit safer
339     /// @param _spender The address of the account able to transfer the tokens
340     /// @param _amount The amount of tokens to be approved for transfer
341     /// @return True if the approval was successful
342     function approve(address _spender, uint256 _amount) returns (bool success) {
343         require(transfersEnabled);
344 
345         // To change the approve amount you first have to reduce the addresses`
346         //    allowance to zero by calling `approve(_spender,0)` if it is not
347         //    already 0 to mitigate the race condition described here:
348         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
350 
351         // Alerts the token controller of the approve function call
352         if (isContract(controller)) {
353             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
354         }
355 
356         allowed[msg.sender][_spender] = _amount;
357         Approval(msg.sender, _spender, _amount);
358         return true;
359     }
360 
361     /// @dev This function makes it easy to read the `allowed[]` map
362     /// @param _owner The address of the account that owns the token
363     /// @param _spender The address of the account able to transfer the tokens
364     /// @return Amount of remaining tokens of _owner that _spender is allowed
365     ///    to spend
366     function allowance(address _owner, address _spender
367     ) public view returns (uint256 remaining) {
368         return allowed[_owner][_spender];
369     }
370 
371     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
372     ///    its behalf, and then a function is triggered in the contract that is
373     ///    being approved, `_spender`. This allows users to use their tokens to
374     ///    interact with contracts in one function call instead of two
375     /// @param _spender The address of the contract able to transfer the tokens
376     /// @param _amount The amount of tokens to be approved for transfer
377     /// @return True if the function call was successful
378     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
379     ) public returns (bool success) {
380         require(approve(_spender, _amount));
381 
382         ApproveAndCallFallBack(_spender).receiveApproval(
383             msg.sender,
384             _amount,
385             this,
386             _extraData
387         );
388 
389         return true;
390     }
391 
392     /// @dev This function makes it easy to get the total number of tokens
393     /// @return The total number of tokens
394     function totalSupply() constant returns (uint) {
395         return totalSupplyAt(block.number);
396     }
397 
398 
399 ////////////////
400 // Query balance and totalSupply in History
401 ////////////////
402 
403     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
404     /// @param _owner The address from which the balance will be retrieved
405     /// @param _blockNumber The block number when the balance is queried
406     /// @return The balance at `_blockNumber`
407     function balanceOfAt(address _owner, uint _blockNumber) public view
408         returns (uint) {
409 
410         // These next few lines are used when the balance of the token is
411         //    requested before a check point was ever created for this token, it
412         //    requires that the `parentToken.balanceOfAt` be queried at the
413         //    genesis block for that token as this contains initial balance of
414         //    this token
415         if ((balances[_owner].length == 0)
416             || (balances[_owner][0].fromBlock > _blockNumber)) {
417             if (address(parentToken) != 0) {
418                return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
419             } else {
420                // Has no parent
421                return 0;
422             }
423 
424         // This will return the expected balance during normal situations
425         } else {
426             return getValueAt(balances[_owner], _blockNumber);
427         }
428     }
429 
430     /// @notice Total amount of tokens at a specific `_blockNumber`.
431     /// @param _blockNumber The block number when the totalSupply is queried
432     /// @return The total amount of tokens at `_blockNumber`
433     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
434 
435         // These next few lines are used when the totalSupply of the token is
436         //    requested before a check point was ever created for this token, it
437         //    requires that the `parentToken.totalSupplyAt` be queried at the
438         //    genesis block for this token as that contains totalSupply of this
439         //    token at this block number.
440         if ((totalSupplyHistory.length == 0)
441             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
442             if (address(parentToken) != 0) {
443                return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
444             } else {
445                return 0;
446             }
447 
448         // This will return the expected totalSupply during normal situations
449         } else {
450             return getValueAt(totalSupplyHistory, _blockNumber);
451         }
452     }
453 
454 ////////////////
455 // Clone Token Method
456 ////////////////
457 
458     /// @notice Creates a new clone token with the initial distribution being
459     ///    this token at `_snapshotBlock`
460     /// @param _cloneTokenName Name of the clone token
461     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
462     /// @param _cloneTokenSymbol Symbol of the clone token
463     /// @param _snapshotBlock Block when the distribution of the parent token is
464     ///    copied to set the initial distribution of the new clone token;
465     ///    if the block is zero than the actual block, the current block is used
466     /// @param _transfersEnabled True if transfers are allowed in the clone
467     /// @return The address of the new MiniMeToken Contract
468     function createCloneToken(
469         string _cloneTokenName,
470         uint8 _cloneDecimalUnits,
471         string _cloneTokenSymbol,
472         uint _snapshotBlock,
473         bool _transfersEnabled
474         ) returns(address) {
475         if (_snapshotBlock == 0) _snapshotBlock = block.number;
476         MiniMeToken cloneToken = tokenFactory.createCloneToken(
477             this,
478             _snapshotBlock,
479             _cloneTokenName,
480             _cloneDecimalUnits,
481             _cloneTokenSymbol,
482             _transfersEnabled
483             );
484 
485         cloneToken.changeController(msg.sender);
486 
487         // An event to make the token easy to find on the blockchain
488         NewCloneToken(address(cloneToken), _snapshotBlock);
489         return address(cloneToken);
490     }
491 
492 ////////////////
493 // Generate and destroy tokens
494 ////////////////
495 
496     /// @notice Generates `_amount` tokens that are assigned to `_owner`
497     /// @param _owner The address that will be assigned the new tokens
498     /// @param _amount The quantity of tokens generated
499     /// @return True if the tokens are generated correctly
500     function generateTokens(address _owner, uint _amount
501     ) onlyController returns (bool) {
502         uint curTotalSupply = totalSupply();
503         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
504         uint previousBalanceTo = balanceOf(_owner);
505         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
506         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
507         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
508         Transfer(0, _owner, _amount);
509         return true;
510     }
511 
512 
513     /// @notice Burns `_amount` tokens from `_owner`
514     /// @param _owner The address that will lose the tokens
515     /// @param _amount The quantity of tokens to burn
516     /// @return True if the tokens are burned correctly
517     function destroyTokens(address _owner, uint256 _amount
518     ) onlyController returns (bool) {
519         uint256 curTotalSupply = totalSupply();
520         require(curTotalSupply >= _amount);
521         uint256 previousBalanceFrom = balanceOf(_owner);
522         require(previousBalanceFrom >= _amount);
523         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
524         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
525         Transfer(_owner, 0, _amount);
526         return true;
527     }
528 
529 ////////////////
530 // Enable tokens transfers
531 ////////////////
532 
533 
534     /// @notice Enables token holders to transfer their tokens freely if true
535     /// @param _transfersEnabled True if transfers are allowed in the clone
536     function enableTransfers(bool _transfersEnabled) onlyController {
537         transfersEnabled = _transfersEnabled;
538     }
539 
540 ////////////////
541 // Internal helper functions to query and set a value in a snapshot array
542 ////////////////
543 
544     /// @dev `getValueAt` retrieves the number of tokens at a given block number
545     /// @param checkpoints The history of values being queried
546     /// @param _block The block number to retrieve the value at
547     /// @return The number of tokens being queried
548     function getValueAt(Checkpoint[] storage checkpoints, uint _block
549     ) internal view returns (uint) {
550         if (checkpoints.length == 0) return 0;
551 
552         // Shortcut for the actual value
553         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
554             return checkpoints[checkpoints.length-1].value;
555         if (_block < checkpoints[0].fromBlock) return 0;
556 
557         // Binary search of the value in the array
558         uint min = 0;
559         uint max = checkpoints.length-1;
560         while (max > min) {
561             uint mid = (max + min + 1)/ 2;
562             if (checkpoints[mid].fromBlock<=_block) {
563                min = mid;
564             } else {
565                max = mid-1;
566             }
567         }
568         return checkpoints[min].value;
569     }
570 
571     /// @dev `updateValueAtNow` used to update the `balances` map and the
572     ///    `totalSupplyHistory`
573     /// @param checkpoints The history of data being updated
574     /// @param _value The new number of tokens
575     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
576     ) internal    {
577         if ((checkpoints.length == 0)
578         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
579                  Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
580                  newCheckPoint.fromBlock =    uint128(block.number);
581                  newCheckPoint.value = uint128(_value);
582              } else {
583                  Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
584                  oldCheckPoint.value = uint128(_value);
585              }
586     }
587 
588     /// @dev Internal function to determine if an address is a contract
589     /// @param _addr The address being queried
590     /// @return True if `_addr` is a contract
591     function isContract(address _addr) internal view returns(bool) {
592         uint size;
593         if (_addr == 0) return false;
594         assembly {
595             size := extcodesize(_addr)
596         }
597         return size > 0;
598     }
599 
600     /// @dev Helper function to return a min betwen the two uints
601     function min(uint a, uint b) internal pure returns (uint) {
602         return a < b ? a : b;
603     }
604 
605     /// @notice The fallback function: If the contract's controller has not been
606     ///    set to 0, then the `proxyPayment` method is called which relays the
607     ///    ether and creates tokens as described in the token controller contract
608     function ()    payable {
609         require(isContract(controller));
610         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
611     }
612 
613 //////////
614 // Safety Methods
615 //////////
616 
617     /// @notice This method can be used by the controller to extract mistakenly
618     ///    sent tokens to this contract.
619     /// @param _token The address of the token contract that you want to recover
620     ///    set to 0 in case you want to extract ether.
621     function claimTokens(address _token) onlyController {
622         if (_token == 0x0) {
623             controller.transfer(this.balance);
624             return;
625         }
626 
627         MiniMeToken token = MiniMeToken(_token);
628         uint balance = token.balanceOf(this);
629         token.transfer(controller, balance);
630         ClaimedTokens(_token, controller, balance);
631     }
632 
633 ////////////////
634 // Events
635 ////////////////
636     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
637     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
638     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
639     event Approval(
640         address indexed _owner,
641         address indexed _spender,
642         uint256 _amount
643         );
644 
645 }
646 
647 
648 ////////////////
649 // MiniMeTokenFactory
650 ////////////////
651 
652 /// @dev This contract is used to generate clone contracts from a contract.
653 ///    In solidity this is the way to create a contract from a contract of the
654 ///    same class
655 contract MiniMeTokenFactory {
656 
657     /// @notice Update the DApp by creating a new token with new functionalities
658     ///    the msg.sender becomes the controller of this clone token
659     /// @param _parentToken Address of the token being cloned
660     /// @param _snapshotBlock Block of the parent token that will
661     ///    determine the initial distribution of the clone token
662     /// @param _tokenName Name of the new token
663     /// @param _decimalUnits Number of decimals of the new token
664     /// @param _tokenSymbol Token Symbol for the new token
665     /// @param _transfersEnabled If true, tokens will be able to be transferred
666     /// @return The address of the new token contract
667     function createCloneToken(
668         address _parentToken,
669         uint _snapshotBlock,
670         string _tokenName,
671         uint8 _decimalUnits,
672         string _tokenSymbol,
673         bool _transfersEnabled
674     ) returns (MiniMeToken) {
675         MiniMeToken newToken = new MiniMeToken(
676             this,
677             _parentToken,
678             _snapshotBlock,
679             _tokenName,
680             _decimalUnits,
681             _tokenSymbol,
682             _transfersEnabled
683             );
684 
685         newToken.changeController(msg.sender);
686         return newToken;
687     }
688 }
689 
690 /**
691     * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
692     * Copyright 2017, Jorge Izquierdo (Aragon Foundation)
693     *
694     * Based on VestedToken.sol from https://github.com/OpenZeppelin/zeppelin-solidity
695     *
696     * Math – Copyright (c) 2016 Smart Contract Solutions, Inc.
697     * SafeMath – Copyright (c) 2016 Smart Contract Solutions, Inc.
698     * MiniMeToken – Copyright 2017, Jordi Baylina (Giveth)
699     **/
700 
701 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
702 // ability to createTokenGrants which are basically a transfer that limits the
703 // receiver of the tokens how can he spend them over time.
704 
705 // For simplicity, token grants are not saved in MiniMe type checkpoints.
706 // Vanilla cloning ESCBCoin will clone it into a MiniMeToken without vesting.
707 // More complex cloning could account for past vesting calendars.
708 
709 contract MiniMeIrrevocableVestedToken is MiniMeToken {
710 
711     using SafeMath for uint256;
712 
713     uint256 MAX_GRANTS_PER_ADDRESS = 20;
714     // Keep the struct at 2 stores (1 slot for value + 64 * 3 (dates) + 20 (address) = 2 slots
715     // (2nd slot is 212 bytes, lower than 256))
716     struct TokenGrant {
717     address granter;    // 20 bytes
718     uint256 value;         // 32 bytes
719     uint64 cliff;
720     uint64 vesting;
721     uint64 start;        // 3 * 8 = 24 bytes
722     bool revokable;
723     bool burnsOnRevoke;    // 2 * 1 = 2 bits? or 2 bytes?
724     } // total 78 bytes = 3 sstore per operation (32 per sstore)
725 
726     mapping (address => TokenGrant[]) public grants;
727 
728     event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting, uint256 grantId);
729 
730     mapping (address => bool) canCreateGrants;
731     address vestingWhitelister;
732 
733     modifier canTransfer(address _sender, uint _value) {
734     require(_value <= spendableBalanceOf(_sender));
735     _;
736     }
737 
738     modifier onlyVestingWhitelister {
739     require(msg.sender == vestingWhitelister);
740     _;
741     }
742 
743     function MiniMeIrrevocableVestedToken (
744         address _tokenFactory,
745         address _parentToken,
746         uint _parentSnapShotBlock,
747         string _tokenName,
748         uint8 _decimalUnits,
749         string _tokenSymbol,
750         bool _transfersEnabled
751     ) public MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
752     vestingWhitelister = msg.sender;
753     doSetCanCreateGrants(vestingWhitelister, true);
754     }
755 
756     // @dev Add canTransfer modifier before allowing transfer and transferFrom to go through
757     function transfer(address _to, uint _value)
758              canTransfer(msg.sender, _value)
759              public
760              returns (bool success) {
761     return super.transfer(_to, _value);
762     }
763 
764     function transferFrom(address _from, address _to, uint _value)
765              canTransfer(_from, _value)
766              public
767              returns (bool success) {
768     return super.transferFrom(_from, _to, _value);
769     }
770 
771     function spendableBalanceOf(address _holder) constant public returns (uint) {
772     return transferableTokens(_holder, uint64(now));
773     }
774 
775     /**
776     * @dev Grant tokens to a specified address
777     * @param _to address The address which the tokens will be granted to.
778     * @param _value uint256 The amount of tokens to be granted.
779     * @param _start uint64 Time of the beginning of the grant.
780     * @param _cliff uint64 Time of the cliff period.
781     * @param _vesting uint64 The vesting period.
782     * @param _revokable bool Token can be revoked with send amount to back.
783     * @param _burnsOnRevoke bool Token can be revoked with send amount to back and destroyed.
784     */
785     function grantVestedTokens(
786     address _to,
787     uint256 _value,
788     uint64 _start,
789     uint64 _cliff,
790     uint64 _vesting,
791     bool _revokable,
792     bool _burnsOnRevoke
793     ) public {
794 
795     // Check for date inconsistencies that may cause unexpected behavior
796     require(_cliff >= _start && _vesting >= _cliff);
797     require(canCreateGrants[msg.sender]);
798 
799     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);    // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
800 
801     uint256 count = grants[_to].push(
802                TokenGrant(
803                    _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
804                    _value,
805                    _cliff,
806                    _vesting,
807                    _start,
808                    _revokable,
809                    _burnsOnRevoke
810                )
811                );
812 
813     transfer(_to, _value);
814 
815     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start, count - 1);
816     }
817 
818     function setCanCreateGrants(address _addr, bool _allowed) onlyVestingWhitelister public {
819     doSetCanCreateGrants(_addr, _allowed);
820     }
821 
822     function doSetCanCreateGrants(address _addr, bool _allowed) internal {
823     canCreateGrants[_addr] = _allowed;
824     }
825 
826     function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
827     doSetCanCreateGrants(vestingWhitelister, false);
828     vestingWhitelister = _newWhitelister;
829     doSetCanCreateGrants(vestingWhitelister, true);
830     }
831 
832     /**
833     * @dev Revoke the grant of tokens of a specifed address.
834     * @param _holder The address which will have its tokens revoked.
835     * @param _grantId The id of the token grant.
836     */
837     function revokeTokenGrant(address _holder, uint256 _grantId) public {
838     TokenGrant storage grant = grants[_holder][_grantId];
839 
840     require(grant.revokable);
841     require(grant.granter == msg.sender); // Only granter can revoke it
842 
843     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
844 
845     uint256 nonVested = nonVestedTokens(grant, uint64(now));
846 
847     // remove grant from array
848     delete grants[_holder][_grantId];
849     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
850     grants[_holder].length -= 1;
851 
852     var previousBalanceReceiver = balanceOfAt(receiver, block.number);
853 
854     //balances[receiver] = balances[receiver].add(nonVested);
855     updateValueAtNow(balances[receiver], previousBalanceReceiver + nonVested);
856 
857     var previousBalance_holder = balanceOfAt(_holder, block.number);
858 
859     //balances[_holder] = balances[_holder].sub(nonVested);
860     updateValueAtNow(balances[_holder], previousBalance_holder - nonVested);
861 
862     Transfer(_holder, receiver, nonVested);
863     }
864 
865     /**
866     * @dev Calculate the total amount of transferable tokens of a holder at a given time
867     * @param holder address The address of the holder
868     * @param time uint64 The specific time.
869     * @return An uint256 representing a holder's total amount of transferable tokens.
870     */
871     function transferableTokens(address holder, uint64 time) public view returns (uint256) {
872     uint256 grantIndex = tokenGrantsCount(holder);
873 
874     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
875 
876     // Iterate through all the grants the holder has, and add all non-vested tokens
877     uint256 nonVested = 0;
878     for (uint256 i = 0; i < grantIndex; i++) {
879         nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
880     }
881 
882     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
883     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
884 
885     // Return the minimum of how many vested can transfer and other value
886     // in case there are other limiting transferability factors (default is balanceOf)
887     return Math.min256(vestedTransferable, balanceOf(holder));
888     }
889 
890     /**
891     * @dev Check the amount of grants that an address has.
892     * @param _holder The holder of the grants.
893     * @return A uint256 representing the total amount of grants.
894     */
895     function tokenGrantsCount(address _holder) public view returns (uint256 index) {
896     return grants[_holder].length;
897     }
898 
899     /**
900     * @dev Calculate amount of vested tokens at a specifc time.
901     * @param tokens uint256 The amount of tokens grantted.
902     * @param time uint64 The time to be checked
903     * @param start uint64 A time representing the begining of the grant
904     * @param cliff uint64 The cliff period.
905     * @param vesting uint64 The vesting period.
906     * @return An uint256 representing the amount of vested tokensof a specif grant.
907     *    transferableTokens
908     *    |                        _/--------    vestedTokens rect
909     *    |                        _/
910     *    |                    _/
911     *    |                    _/
912     *    |                 _/
913     *    |               /
914     *    |               .|
915     *    |            .    |
916     *    |            .    |
917     *    |        .        |
918     *    |        .        |
919     *    |    .            |
920     *    +===+===========+---------+----------> time
921     *        Start         Clift    Vesting
922     */
923     function calculateVestedTokens(
924     uint256 tokens,
925     uint256 time,
926     uint256 start,
927     uint256 cliff,
928     uint256 vesting) internal view returns (uint256)
929     {
930         // Shortcuts for before cliff and after vesting cases.
931         if (time < cliff) return 0;
932         if (time >= vesting) return tokens;
933 
934         // Interpolate all vested tokens.
935         // As before cliff the shortcut returns 0, we can use just calculate a value
936         // in the vesting rect (as shown in above's figure)
937 
938         // vestedTokens = tokens * (time - start) / (vesting - start)
939         uint256 vestedTokens = SafeMath.div(
940                                     SafeMath.mul(
941                                        tokens,
942                                        SafeMath.sub(time, start)
943                                        ),
944                                     SafeMath.sub(vesting, start)
945                                     );
946 
947         return vestedTokens;
948     }
949 
950     /**
951     * @dev Get all information about a specifc grant.
952     * @param _holder The address which will have its tokens revoked.
953     * @param _grantId The id of the token grant.
954     * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
955     * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
956     */
957     function tokenGrant(address _holder, uint256 _grantId) public view returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
958     TokenGrant storage grant = grants[_holder][_grantId];
959 
960     granter = grant.granter;
961     value = grant.value;
962     start = grant.start;
963     cliff = grant.cliff;
964     vesting = grant.vesting;
965     revokable = grant.revokable;
966     burnsOnRevoke = grant.burnsOnRevoke;
967 
968     vested = vestedTokens(grant, uint64(now));
969     }
970 
971     /**
972     * @dev Get the amount of vested tokens at a specific time.
973     * @param grant TokenGrant The grant to be checked.
974     * @param time The time to be checked
975     * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
976     */
977     function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
978     return calculateVestedTokens(
979         grant.value,
980         uint256(time),
981         uint256(grant.start),
982         uint256(grant.cliff),
983         uint256(grant.vesting)
984     );
985     }
986 
987     /**
988     * @dev Calculate the amount of non vested tokens at a specific time.
989     * @param grant TokenGrant The grant to be checked.
990     * @param time uint64 The time to be checked
991     * @return An uint256 representing the amount of non vested tokens of a specifc grant on the
992     * passed time frame.
993     */
994     function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
995     // Of all the tokens of the grant, how many of them are not vested?
996     // grantValue - vestedTokens
997     return grant.value.sub(vestedTokens(grant, time));
998     }
999 
1000     /**
1001     * @dev Calculate the date when the holder can trasfer all its tokens
1002     * @param holder address The address of the holder
1003     * @return An uint256 representing the date of the last transferable tokens.
1004     */
1005     function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
1006     date = uint64(now);
1007     uint256 grantIndex = grants[holder].length;
1008     for (uint256 i = 0; i < grantIndex; i++) {
1009         date = Math.max64(grants[holder][i].vesting, date);
1010     }
1011     }
1012 
1013 }
1014 
1015 /**
1016  * Dividends
1017  * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1018  * Copyright 2017, Adam Dossa
1019  * Based on ProfitSharingContract.sol from https://github.com/adamdossa/ProfitSharingContract
1020  **/
1021 
1022 contract MiniMeIrrVesDivToken is MiniMeIrrevocableVestedToken {
1023 
1024     event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _timestamp, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
1025     event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
1026     event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _timestamp, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
1027 
1028     uint256 public RECYCLE_TIME = 1 years;
1029 
1030     function MiniMeIrrVesDivToken (
1031          address _tokenFactory,
1032          address _parentToken,
1033          uint _parentSnapShotBlock,
1034          string _tokenName,
1035          uint8 _decimalUnits,
1036          string _tokenSymbol,
1037          bool _transfersEnabled
1038     ) public MiniMeIrrevocableVestedToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {}
1039 
1040     struct Dividend {
1041     uint256 blockNumber;
1042     uint256 timestamp;
1043     uint256 amount;
1044     uint256 claimedAmount;
1045     uint256 totalSupply;
1046     bool recycled;
1047     mapping (address => bool) claimed;
1048     }
1049 
1050     Dividend[] public dividends;
1051 
1052     mapping (address => uint256) dividendsClaimed;
1053 
1054     modifier validDividendIndex(uint256 _dividendIndex) {
1055     require(_dividendIndex < dividends.length);
1056     _;
1057     }
1058 
1059     function depositDividend() public payable
1060     onlyController
1061     {
1062     uint256 currentSupply = super.totalSupplyAt(block.number);
1063     uint256 dividendIndex = dividends.length;
1064     uint256 blockNumber = SafeMath.sub(block.number, 1);
1065     dividends.push(
1066          Dividend(
1067          blockNumber,
1068          getNow(),
1069          msg.value,
1070          0,
1071          currentSupply,
1072          false
1073          )
1074     );
1075     DividendDeposited(msg.sender, blockNumber, getNow(), msg.value, currentSupply, dividendIndex);
1076     }
1077 
1078     function claimDividend(uint256 _dividendIndex) public
1079     validDividendIndex(_dividendIndex)
1080     {
1081     Dividend storage dividend = dividends[_dividendIndex];
1082     require(dividend.claimed[msg.sender] == false);
1083     require(dividend.recycled == false);
1084     uint256 balance = super.balanceOfAt(msg.sender, dividend.blockNumber);
1085     uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
1086     dividend.claimed[msg.sender] = true;
1087     dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
1088     if (claim > 0) {
1089          msg.sender.transfer(claim);
1090          DividendClaimed(msg.sender, _dividendIndex, claim);
1091     }
1092     }
1093 
1094     function claimDividendAll() public {
1095     require(dividendsClaimed[msg.sender] < dividends.length);
1096     for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
1097          if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
1098          dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
1099          claimDividend(i);
1100          }
1101     }
1102     }
1103 
1104     function recycleDividend(uint256 _dividendIndex) public
1105     onlyController
1106     validDividendIndex(_dividendIndex)
1107     {
1108     Dividend storage dividend = dividends[_dividendIndex];
1109     require(dividend.recycled == false);
1110     require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
1111     dividends[_dividendIndex].recycled = true;
1112     uint256 currentSupply = super.totalSupplyAt(block.number);
1113     uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
1114     uint256 dividendIndex = dividends.length;
1115     uint256 blockNumber = SafeMath.sub(block.number, 1);
1116     dividends.push(
1117          Dividend(
1118          blockNumber,
1119          getNow(),
1120          remainingAmount,
1121          0,
1122          currentSupply,
1123          false
1124          )
1125     );
1126     DividendRecycled(msg.sender, blockNumber, getNow(), remainingAmount, currentSupply, dividendIndex);
1127     }
1128 
1129     function getNow() internal constant returns (uint256) {
1130     return now;
1131     }
1132 }
1133 
1134 /**
1135  * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1136  **/
1137 
1138 contract ESCBCoin is MiniMeIrrVesDivToken {
1139     // @dev ESCBCoin constructor just parametrizes the MiniMeIrrVesDivToken constructor
1140     function ESCBCoin (
1141       address _tokenFactory
1142     ) public MiniMeIrrVesDivToken(
1143     _tokenFactory,
1144     0x0,            // no parent token
1145     0,               // no snapshot block number from parent
1146     "ESCB token",    // Token name
1147     18,             // Decimals
1148     "ESCB",         // Symbol
1149     true            // Enable transfers
1150     ) {}
1151 }
1152 
1153 /**
1154     *    Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1155     *    Copyright 2017, Jorge Izquierdo (Aragon Foundation)
1156     **/
1157 
1158 /*
1159 
1160 @notice The ESCBCoinPlaceholder contract will take control over the ESCB coin after the sale
1161         is finalized and before the EscrowBlock Network is deployed.
1162 
1163         The contract allows for ESCBCoin transfers and transferFrom and implements the
1164         logic for transfering control of the token to the network when the sale
1165         asks it to do so.
1166 */
1167 
1168 contract ESCBCoinPlaceholder is TokenController {
1169     address public tokenSale;
1170     ESCBCoin public token;
1171 
1172     function ESCBCoinPlaceholder(address _sale, address _ESCBCoin) public {
1173     tokenSale = _sale;
1174     token = ESCBCoin(_ESCBCoin);
1175     }
1176 
1177     function changeController(address network) public {
1178     assert(msg.sender == tokenSale);
1179     token.changeController(network);
1180     selfdestruct(network); // network gets all amount
1181     }
1182 
1183     // In between the sale and the network. Default settings for allowing token transfers.
1184     function proxyPayment(address _owner) public payable returns (bool) {
1185     revert();
1186     return false;
1187     }
1188 
1189     function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
1190     return true;
1191     }
1192 
1193     function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
1194     return true;
1195     }
1196 }
1197 
1198 // @dev Contract to hold sale raised funds during the sale period.
1199 // Prevents attack in which the ESCB Multisig sends raised ether
1200 // to the sale contract to mint tokens to itself, and getting the
1201 // funds back immediately.
1202 
1203 contract AbstractSale {
1204     function saleFinalized() public returns (bool);
1205     function minGoalReached() public returns (bool);
1206 }
1207 
1208 contract SaleWallet {
1209     using SafeMath for uint256;
1210 
1211     enum State { Active, Refunding }
1212     State public currentState;
1213 
1214     mapping (address => uint256) public deposited;
1215 
1216     //Events
1217     event Withdrawal();
1218     event RefundsEnabled();
1219     event Refunded(address indexed beneficiary, uint256 weiAmount);
1220     event Deposit(address beneficiary, uint256 weiAmount);
1221 
1222     // Public variables
1223     address public multisig;
1224     AbstractSale public tokenSale;
1225 
1226     // @dev Constructor initializes public variables
1227     // @param _multisig The address of the multisig that will receive the funds
1228     // @param _tokenSale The address of the token sale
1229     function SaleWallet(address _multisig, address _tokenSale) {
1230     currentState = State.Active;
1231     multisig = _multisig;
1232     tokenSale = AbstractSale(_tokenSale);
1233     }
1234 
1235     // @dev Receive all sent funds and build the refund map
1236     function deposit(address investor, uint256 amount) public {
1237     require(currentState == State.Active);
1238     require(msg.sender == address(tokenSale));
1239     deposited[investor] = deposited[investor].add(amount);
1240     Deposit(investor, amount);
1241     }
1242 
1243     // @dev Withdraw function sends all the funds to the wallet if conditions are correct
1244     function withdraw() public {
1245     require(currentState == State.Active);
1246     assert(msg.sender == multisig);    // Only the multisig can request it
1247     if (tokenSale.minGoalReached()) {    // Allow when sale reached minimum goal
1248         return doWithdraw();
1249     }
1250     }
1251 
1252     function doWithdraw() internal {
1253     assert(multisig.send(this.balance));
1254     Withdrawal();
1255     }
1256 
1257     function enableRefunds() public {
1258     require(currentState == State.Active);
1259     assert(msg.sender == multisig);    // Only the multisig can request it
1260     require(!tokenSale.minGoalReached());    // Allow when minimum goal isn't reached
1261     require(tokenSale.saleFinalized()); // Allow when sale is finalized
1262     currentState = State.Refunding;
1263     RefundsEnabled();
1264     }
1265 
1266     function refund(address investor) public {
1267     require(currentState == State.Refunding);
1268     require(msg.sender == address(tokenSale));
1269     require(deposited[investor] != 0);
1270     uint256 depositedValue = deposited[investor];
1271     deposited[investor] = 0;
1272     assert(investor.send(depositedValue));
1273     Refunded(investor, depositedValue);
1274     }
1275 
1276     // @dev Receive all sent funds
1277     function () public payable {}
1278 }
1279 
1280 /**
1281  * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1282  * Copyright 2017, Jorge Izquierdo (Aragon Foundation)
1283  * Copyright 2017, Jordi Baylina (Giveth)
1284  *
1285  * Based on SampleCampaign-TokenController.sol from https://github.com/Giveth/minime
1286  **/
1287 
1288  
1289  contract ESCBTokenSale is TokenController {
1290    uint256 public initialTime;           // Time in which the sale starts. Inclusive. sale will be opened at initial time.
1291    uint256 public controlTime;           // The Unix time in which the sale needs to check on the refunding start.
1292    uint256 public price;                 // Number of wei-ESCBCoin tokens for 1 ether
1293    address public ESCBDevMultisig;       // The address to hold the funds donated
1294 
1295    uint256 public affiliateBonusPercent = 2;     // Purpose in percentage of payment via referral
1296    uint256 public totalCollected = 0;            // In wei
1297    bool public saleStopped = false;              // Has ESCB Dev stopped the sale?
1298    bool public saleFinalized = false;            // Has ESCB Dev finalized the sale?
1299 
1300    mapping (address => bool) public activated;   // Address confirmates that wants to activate the sale
1301 
1302    ESCBCoin public token;                         // The token
1303    ESCBCoinPlaceholder public networkPlaceholder; // The network placeholder
1304    SaleWallet public saleWallet;                  // Wallet that receives all sale funds
1305 
1306    uint256 constant public dust = 1 finney; // Minimum investment
1307    uint256 public minGoal;                  // amount of minimum fund in wei
1308    uint256 public goal;                     // Goal for IITO in wei
1309    uint256 public currentStage = 1;         // Current stage
1310    uint256 public allocatedStage = 1;       // Current stage when was allocated tokens for ESCB
1311    uint256 public usedTotalSupply = 0;      // This uses for calculation ESCB allocation part
1312 
1313    event ActivatedSale();
1314    event FinalizedSale();
1315    event NewBuyer(address indexed holder, uint256 ESCBCoinAmount, uint256 etherAmount);
1316    event NewExternalFoundation(address indexed holder, uint256 ESCBCoinAmount, uint256 etherAmount, bytes32 externalId);
1317    event AllocationForESCBFund(address indexed holder, uint256 ESCBCoinAmount);
1318    event NewStage(uint64 numberStage);
1319    // @dev There are several checks to make sure the parameters are acceptable
1320    // @param _initialTime The Unix time in which the sale starts
1321    // @param _controlTime The Unix time in which the sale needs to check on the refunding start
1322    // @param _ESCBDevMultisig The address that will store the donated funds and manager for the sale
1323    // @param _price The price. Price in wei-ESCBCoin per wei
1324    function ESCBTokenSale (uint _initialTime, uint _controlTime, address _ESCBDevMultisig, uint256 _price)
1325             non_zero_address(_ESCBDevMultisig) {
1326      assert (_initialTime >= getNow());
1327      assert (_initialTime < _controlTime);
1328 
1329      // Save constructor arguments as global variables
1330      initialTime = _initialTime;
1331      controlTime = _controlTime;
1332      ESCBDevMultisig = _ESCBDevMultisig;
1333      price = _price;
1334    }
1335 
1336    modifier only(address x) {
1337      require(msg.sender == x);
1338      _;
1339    }
1340 
1341    modifier only_before_sale {
1342      require(getNow() < initialTime);
1343      _;
1344    }
1345 
1346    modifier only_during_sale_period {
1347      require(getNow() >= initialTime);
1348 
1349      // if minimum goal is reached, then infinite time to reach the main goal
1350      require(getNow() < controlTime || minGoalReached());
1351      _;
1352    }
1353 
1354    modifier only_after_sale {
1355      require(getNow() >= controlTime || goalReached());
1356      _;
1357    }
1358 
1359    modifier only_sale_stopped {
1360      require(saleStopped);
1361      _;
1362    }
1363 
1364    modifier only_sale_not_stopped {
1365      require(!saleStopped);
1366      _;
1367    }
1368 
1369    modifier only_before_sale_activation {
1370      require(!isActivated());
1371      _;
1372    }
1373 
1374    modifier only_sale_activated {
1375      require(isActivated());
1376      _;
1377    }
1378 
1379    modifier only_finalized_sale {
1380      require(getNow() >= controlTime || goalReached());
1381      require(saleFinalized);
1382      _;
1383    }
1384 
1385    modifier non_zero_address(address x) {
1386      require(x != 0);
1387      _;
1388    }
1389 
1390    modifier minimum_value(uint256 x) {
1391      require(msg.value >= x);
1392      _;
1393    }
1394 
1395    // @notice Deploy ESCBCoin is called only once to setup all the needed contracts.
1396    // @param _token: Address of an instance of the ESCBCoin token
1397    // @param _networkPlaceholder: Address of an instance of ESCBCoinPlaceholder
1398    // @param _saleWallet: Address of the wallet receiving the funds of the sale
1399    // @param _minGoal: Minimum fund for success
1400    // @param _goal: The end fund amount
1401    function setESCBCoin(address _token, address _networkPlaceholder, address _saleWallet, uint256 _minGoal, uint256 _goal)
1402             payable
1403             non_zero_address(_token)
1404             only(ESCBDevMultisig)
1405             public {
1406 
1407      // 3 times by non_zero_address is not working for current compiler version
1408      require(_networkPlaceholder != 0);
1409      require(_saleWallet != 0);
1410 
1411      // Assert that the function hasn't been called before, as activate will happen at the end
1412      assert(!activated[this]);
1413 
1414      token = ESCBCoin(_token);
1415      networkPlaceholder = ESCBCoinPlaceholder(_networkPlaceholder);
1416      saleWallet = SaleWallet(_saleWallet);
1417 
1418      assert(token.controller() == address(this));             // sale is controller
1419      assert(token.totalSupply() == 0);                        // token is empty
1420 
1421      assert(networkPlaceholder.tokenSale() == address(this)); // placeholder has reference to Sale
1422      assert(networkPlaceholder.token() == address(token));    // placeholder has reference to ESCBCoin
1423 
1424      assert(saleWallet.multisig() == ESCBDevMultisig);        // receiving wallet must match
1425      assert(saleWallet.tokenSale() == address(this));         // watched token sale must be self
1426 
1427      assert(_minGoal > 0);                                   // minimum goal is not empty
1428      assert(_goal > 0);                                      // the main goal is not empty
1429      assert(_minGoal < _goal);                               // minimum goal is less than the main goal
1430 
1431      minGoal = _minGoal;
1432      goal = _goal;
1433 
1434      // Contract activates sale as all requirements are ready
1435      doActivateSale(this);
1436    }
1437 
1438    function activateSale()
1439             public {
1440      doActivateSale(msg.sender);
1441      ActivatedSale();
1442    }
1443 
1444    function doActivateSale(address _entity)
1445      non_zero_address(token) // cannot activate before setting token
1446      only_before_sale
1447      private {
1448      activated[_entity] = true;
1449    }
1450 
1451    // @notice Whether the needed accounts have activated the sale.
1452    // @return Is sale activated
1453    function isActivated()
1454             constant
1455             public
1456             returns (bool) {
1457      return activated[this] && activated[ESCBDevMultisig];
1458    }
1459 
1460    // @notice Get the price for tokens for the current stage
1461    // @param _amount the amount for which the price is requested
1462    // @return Number of wei-ESCBToken
1463    function getPrice(uint256 _amount)
1464             only_during_sale_period
1465             only_sale_not_stopped
1466             only_sale_activated
1467             constant
1468             public
1469             returns (uint256) {
1470      return priceForStage(SafeMath.mul(_amount, price));
1471    }
1472 
1473    // @notice Get the bonus tokens for a stage
1474    // @param _amount the amount of tokens
1475    // @return Number of wei-ESCBCoin with bonus for 1 wei
1476    function priceForStage(uint256 _amount)
1477             internal
1478             returns (uint256) {
1479 
1480      if (totalCollected >= 0 && totalCollected <= 80 ether) { // 1 ETH = 500 USD, then 40 000 USD 1 stage
1481        currentStage = 1;
1482        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 20), 100));
1483      }
1484 
1485      if (totalCollected > 80 ether && totalCollected <= 200 ether) { // 1 ETH = 500 USD, then 100 000 USD 2 stage
1486        currentStage = 2;
1487        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 18), 100));
1488      }
1489 
1490      if (totalCollected > 200 ether && totalCollected <= 400 ether) { // 1 ETH = 500 USD, then 200 000 USD 3 stage
1491        currentStage = 3;
1492        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 16), 100));
1493      }
1494 
1495      if (totalCollected > 400 ether && totalCollected <= 1000 ether) { // 1 ETH = 500 USD, then 500 000 USD 4 stage
1496        currentStage = 4;
1497        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 14), 100));
1498      }
1499 
1500      if (totalCollected > 1000 ether && totalCollected <= 2000 ether) { // 1 ETH = 500 USD, then 1 000 000 USD 5 stage
1501        currentStage = 5;
1502        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 12), 100));
1503      }
1504 
1505      if (totalCollected > 2000 ether && totalCollected <= 4000 ether) { // 1 ETH = 500 USD, then 2 000 000 USD 6 stage
1506        currentStage = 6;
1507        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 10), 100));
1508      }
1509 
1510      if (totalCollected > 4000 ether && totalCollected <= 8000 ether) { // 1 ETH = 500 USD, then 4 000 000 USD 7 stage
1511        currentStage = 7;
1512        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 8), 100));
1513      }
1514 
1515      if (totalCollected > 8000 ether && totalCollected <= 12000 ether) { // 1 ETH = 500 USD, then 6 000 000 USD 8 stage
1516        currentStage = 8;
1517        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 6), 100));
1518      }
1519 
1520      if (totalCollected > 12000 ether && totalCollected <= 16000 ether) { // 1 ETH = 500 USD, then 8 000 000 USD 9 stage
1521        currentStage = 9;
1522        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 4), 100));
1523      }
1524 
1525      if (totalCollected > 16000 ether && totalCollected <= 20000 ether) { // 1 ETH = 500 USD, then 10 000 000 USD 10 stage
1526        currentStage = 10;
1527        return SafeMath.add(_amount, SafeMath.div(SafeMath.mul(_amount, 2), 100));
1528      }
1529 
1530      if (totalCollected > 20000 ether) { // without bonus
1531        return _amount;
1532      }
1533    }
1534 
1535    // ESCBDevMultisig can use this function for allocation tokens
1536    // for ESCB Foundation by each stage, start from 2nd
1537    // Amount of stages can not be more than MAX_GRANTS_PER_ADDRESS
1538    function allocationForESCBbyStage()
1539             only(ESCBDevMultisig)
1540             public {
1541      if(currentStage > allocatedStage) {
1542        // ESCB Foundation owns 30% of the total number of emitted tokens.
1543        // totalSupply here 66%, then we 30%/66% to get amount 30% of tokens
1544        uint256 ESCBTokens = SafeMath.div(SafeMath.mul(SafeMath.sub(uint256(token.totalSupply()), usedTotalSupply), 15), 33);
1545        uint256 prevTotalSupply = uint256(token.totalSupply());
1546        if(token.generateTokens(address(this), ESCBTokens)) {
1547          allocatedStage = currentStage;
1548          usedTotalSupply = prevTotalSupply;
1549          uint64 cliffDate = uint64(SafeMath.add(uint256(now), 365 days));
1550          uint64 vestingDate = uint64(SafeMath.add(uint256(now), 547 days));
1551          token.grantVestedTokens(ESCBDevMultisig, ESCBTokens, uint64(now), cliffDate, vestingDate, true, false);
1552          AllocationForESCBFund(ESCBDevMultisig, ESCBTokens);
1553        } else {
1554          revert();
1555        }
1556      }
1557    }
1558 
1559    // @dev The fallback function is called when ether is sent to the contract, it
1560    // simply calls `doPayment()` with the address that sent the ether as the
1561    // `_owner`. Payable is a require solidity modifier for functions to receive
1562    // ether, without this modifier functions will throw if ether is sent to them
1563    function ()
1564             public
1565             payable {
1566      doPayment(msg.sender);
1567    }
1568 
1569  // @dev This function allow to get bonus tokens for a buyer and for referral
1570    function paymentAffiliate(address _referral)
1571             non_zero_address(_referral)
1572             payable
1573             public {
1574      uint256 boughtTokens = doPayment(msg.sender);
1575      uint256 affiliateBonus = SafeMath.div(
1576                                 SafeMath.mul(boughtTokens, affiliateBonusPercent), 100
1577                               ); // Calculate how many bonus tokens need to add
1578      assert(token.generateTokens(_referral, affiliateBonus));
1579      assert(token.generateTokens(msg.sender, affiliateBonus));
1580    }
1581 
1582  ////////////
1583  // Controller interface
1584  ////////////
1585 
1586    // @notice `proxyPayment()` allows the caller to send ether to the Token directly and
1587    // have the tokens created in an address of their choosing
1588    // @param _owner The address that will hold the newly created tokens
1589 
1590    function proxyPayment(address _owner)
1591             payable
1592             public
1593             returns (bool) {
1594      doPayment(_owner);
1595      return true;
1596    }
1597 
1598    // @notice Notifies the controller about a transfer, for this sale all
1599    //  transfers are allowed by default and no extra notifications are needed
1600    // @param _from The origin of the transfer
1601    // @param _to The destination of the transfer
1602    // @param _amount The amount of the transfer
1603    // @return False if the controller does not authorize the transfer
1604    function onTransfer(address _from, address _to, uint _amount)
1605             public
1606             returns (bool) {
1607      // Until the sale is finalized, only allows transfers originated by the sale contract.
1608      // When finalizeSale is called, this function will stop being called and will always be true.
1609      return _from == address(this);
1610    }
1611 
1612    // @notice Notifies the controller about an approval, for this sale all
1613    //  approvals are allowed by default and no extra notifications are needed
1614    // @param _owner The address that calls `approve()`
1615    // @param _spender The spender in the `approve()` call
1616    // @param _amount The amount in the `approve()` call
1617    // @return False if the controller does not authorize the approval
1618    function onApprove(address _owner, address _spender, uint _amount)
1619             public
1620             returns (bool) {
1621      // No approve/transferFrom during the sale
1622      return false;
1623    }
1624 
1625    // @dev `doPayment()` is an internal function that sends the ether that this
1626    //  contract receives to the ESCBDevMultisig and creates tokens in the address of the sender
1627    // @param _owner The address that will hold the newly created tokens
1628    function doPayment(address _owner)
1629             only_during_sale_period
1630             only_sale_not_stopped
1631             only_sale_activated
1632             non_zero_address(_owner)
1633             minimum_value(dust)
1634             internal
1635             returns (uint256) {
1636      assert(totalCollected + msg.value <= goal); // If goal is reached, throw
1637      uint256 boughtTokens = priceForStage(SafeMath.mul(msg.value, price)); // Calculate how many tokens bought
1638      saleWallet.transfer(msg.value); // Send funds to multisig
1639      saleWallet.deposit(_owner, msg.value); // Send info about deposit to multisig
1640      assert(token.generateTokens(_owner, boughtTokens)); // Allocate tokens.
1641      totalCollected = SafeMath.add(totalCollected, msg.value); // Save total collected amount
1642      NewBuyer(_owner, boughtTokens, msg.value);
1643 
1644      return boughtTokens;
1645    }
1646 
1647    // @notice Function for issuing new tokens for address which made purchasing not in
1648    // ETH currency, for example via cards or wire transfer.
1649    // @dev Only ESCB Dev can do it with the publishing of transaction id in an external system.
1650    // Any audits will be able to confirm eligibility of issuing in such case.
1651    // @param _owner The address that will hold the newly created tokens
1652    // @param _amount Amount of purchasing in ETH
1653    function issueWithExternalFoundation(address _owner, uint256 _amount, bytes32 _extId)
1654             only_during_sale_period
1655             only_sale_not_stopped
1656             only_sale_activated
1657             non_zero_address(_owner)
1658             only(ESCBDevMultisig)
1659             public
1660             returns (uint256) {
1661      assert(totalCollected + _amount <= goal); // If goal is reached, throw
1662      uint256 boughtTokens = priceForStage(SafeMath.mul(_amount, price)); // Calculate how many tokens bought
1663 
1664      assert(token.generateTokens(_owner, boughtTokens)); // Allocate tokens.
1665      totalCollected = SafeMath.add(totalCollected, _amount); // Save total collected amount
1666 
1667      // Events
1668      NewBuyer(_owner, boughtTokens, _amount);
1669      NewExternalFoundation(_owner, boughtTokens, _amount, _extId);
1670 
1671      return boughtTokens;
1672    }
1673 
1674    // @notice Function to stop sale for an emergency.
1675    // @dev Only ESCB Dev can do it after it has been activated.
1676    function emergencyStopSale()
1677             only_sale_activated
1678             only_sale_not_stopped
1679             only(ESCBDevMultisig)
1680             public {
1681      saleStopped = true;
1682    }
1683 
1684    // @notice Function to restart stopped sale.
1685    // @dev Only ESCB Dev can do it after it has been disabled and sale is ongoing.
1686    function restartSale()
1687             only_during_sale_period
1688             only_sale_stopped
1689             only(ESCBDevMultisig)
1690             public {
1691      saleStopped = false;
1692    }
1693 
1694    // @notice Finalizes sale when main goal is reached or if for control time the minimum goal was not reached.
1695    // @dev Transfers the token controller power to the ESCBCoinPlaceholder.
1696    function finalizeSale()
1697             only_after_sale
1698             only(ESCBDevMultisig)
1699             public {
1700      token.changeController(networkPlaceholder); // Sale loses token controller power in favor of network placeholder
1701      saleFinalized = true;  // Set finalized flag as true, that will allow enabling network deployment
1702      saleStopped = true;
1703      FinalizedSale();
1704    }
1705 
1706    // @notice Deploy ESCB Network contract.
1707    // @param _networkAddress: The address the network was deployed at.
1708    function deployNetwork(address _networkAddress)
1709             only_finalized_sale
1710             non_zero_address(_networkAddress)
1711             only(ESCBDevMultisig)
1712             public {
1713      networkPlaceholder.changeController(_networkAddress);
1714    }
1715 
1716    // @notice Set up new ESCB Dev.
1717    // @param _newMultisig: The address new ESCB Dev.
1718    function setESCBDevMultisig(address _newMultisig)
1719             non_zero_address(_newMultisig)
1720             only(ESCBDevMultisig)
1721             public {
1722      ESCBDevMultisig = _newMultisig;
1723    }
1724 
1725    // @notice Get current unix time stamp
1726    function getNow()
1727             constant
1728             internal
1729             returns (uint) {
1730      return now;
1731    }
1732 
1733    // @notice If crowdsale is unsuccessful, investors can claim refunds here
1734    function claimRefund()
1735             only_finalized_sale
1736             public {
1737      require(!minGoalReached());
1738      saleWallet.refund(msg.sender);
1739    }
1740 
1741    // @notice Check minimum goal for 1st stage
1742    function minGoalReached()
1743             public
1744             view
1745             returns (bool) {
1746      return totalCollected >= minGoal;
1747    }
1748 
1749    // @notice Check the main goal for 10th stage
1750    function goalReached()
1751             public
1752             view
1753             returns (bool) {
1754      return totalCollected >= goal;
1755    }
1756  }