1 pragma solidity ^0.4.19;
2 
3 pragma solidity ^0.4.19;
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 /**
39  * @title Math
40  * @dev Assorted math operations
41  */
42 
43 library Math {
44   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
45     return a >= b ? a : b;
46   }
47 
48   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
49     return a < b ? a : b;
50   }
51 
52   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
53     return a >= b ? a : b;
54   }
55 
56   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
57     return a < b ? a : b;
58   }
59 }
60 
61 
62 // Slightly modified Zeppelin's Vested Token deriving MiniMeToken
63 
64 /*
65     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
66     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
67     Copyright 2017, Jordi Baylina (Giveth)
68 
69     Based on MiniMeToken.sol from https://github.com/Giveth/minime
70 */
71 
72 contract ApproveAndCallFallBack {
73     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
74 }
75 
76 /*
77     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
78     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
79     Copyright 2017, Jordi Baylina (Giveth)
80 
81     Based on MiniMeToken.sol from https://github.com/Giveth/minime
82  */
83 
84 contract Controlled {
85     address public controller;
86 
87     function Controlled() {
88          controller = msg.sender;
89     }
90 
91     /// @notice The address of the controller is the only address that can call
92     ///    a function with this modifier
93     modifier onlyController {
94         require(msg.sender == controller);
95         _;
96     }
97 
98     /// @notice Changes the controller of the contract
99     /// @param _newController The new controller of the contract
100     function changeController(address _newController) onlyController {
101         controller = _newController;
102     }
103 }
104 
105 /*
106     Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
107     Copyright 2017, Jorge Izquierdo (Aragon Foundation)
108     Copyright 2017, Jordi Baylina (Giveth)
109 
110     Based on MiniMeToken.sol from https://github.com/Giveth/minime
111  */
112 
113 /// @dev The token controller contract must implement these functions
114 contract TokenController {
115     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
116     /// @param _owner The address that sent the ether to create tokens
117     /// @return True if the ether is accepted, false if it throws
118     function proxyPayment(address _owner) payable returns(bool);
119 
120     /// @notice Notifies the controller about a token transfer allowing the
121     ///    controller to react if desired
122     /// @param _from The origin of the transfer
123     /// @param _to The destination of the transfer
124     /// @param _amount The amount of the transfer
125     /// @return False if the controller does not authorize the transfer
126     function onTransfer(address _from, address _to, uint _amount) returns(bool);
127 
128     /// @notice Notifies the controller about an approval allowing the
129     ///    controller to react if desired
130     /// @param _owner The address that calls `approve()`
131     /// @param _spender The spender in the `approve()` call
132     /// @param _amount The amount in the `approve()` call
133     /// @return False if the controller does not authorize the approval
134     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
135 }
136 
137 /*
138     Copyright 2016, Jordi Baylina
139 
140     This program is free software: you can redistribute it and/or modify
141     it under the terms of the GNU General Public License as published by
142     the Free Software Foundation, either version 3 of the License, or
143     (at your option) any later version.
144 
145     This program is distributed in the hope that it will be useful,
146     but WITHOUT ANY WARRANTY; without even the implied warranty of
147     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.    See the
148     GNU General Public License for more details.
149 
150     You should have received a copy of the GNU General Public License
151     along with this program.    If not, see <http://www.gnu.org/licenses/>.
152  */
153 
154 /// @title MiniMeToken Contract
155 /// @author Jordi Baylina
156 /// @dev This token contract's goal is to make it easy for anyone to clone this
157 ///    token using the token distribution at a given block, this will allow DAO's
158 ///    and DApps to upgrade their features in a decentralized manner without
159 ///    affecting the original token
160 /// @dev It is ERC20 compliant, but still needs to under go further testing.
161 
162 /// @dev The actual token contract, the default controller is the msg.sender
163 ///    that deploys the contract, so usually this token will be deployed by a
164 ///    token controller contract, which Giveth will call a "Campaign"
165 contract MiniMeToken is Controlled {
166 
167     string public name;               //The Token's name: e.g. DigixDAO Tokens
168     uint8 public decimals;             //Number of decimals of the smallest unit
169     string public symbol;               //An identifier: e.g. REP
170     string public version = "MMT_0.1"; //An arbitrary versioning scheme
171 
172 
173     /// @dev `Checkpoint` is the structure that attaches a block number to a
174     ///    given value, the block number attached is the one that last changed the
175     ///    value
176     struct    Checkpoint {
177 
178         // `fromBlock` is the block number that the value was generated from
179         uint128 fromBlock;
180 
181         // `value` is the amount of tokens at a specific block number
182         uint128 value;
183     }
184 
185     // `parentToken` is the Token address that was cloned to produce this token;
186     //    it will be 0x0 for a token that was not cloned
187     MiniMeToken public parentToken;
188 
189     // `parentSnapShotBlock` is the block number from the Parent Token that was
190     //    used to determine the initial distribution of the Clone Token
191     uint public parentSnapShotBlock;
192 
193     // `creationBlock` is the block number that the Clone Token was created
194     uint public creationBlock;
195 
196     // `balances` is the map that tracks the balance of each address, in this
197     //    contract when the balance changes the block number that the change
198     //    occurred is also included in the map
199     mapping (address => Checkpoint[]) balances;
200 
201     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
202     mapping (address => mapping (address => uint256)) allowed;
203 
204     // Tracks the history of the `totalSupply` of the token
205     Checkpoint[] totalSupplyHistory;
206 
207     // Flag that determines if the token is transferable or not.
208     bool public transfersEnabled;
209 
210     // The factory used to create new clone tokens
211     MiniMeTokenFactory public tokenFactory;
212 
213 ////////////////
214 // Constructor
215 ////////////////
216 
217     /// @notice Constructor to create a MiniMeToken
218     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
219     ///    will create the Clone token contracts, the token factory needs to be
220     ///    deployed first
221     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
222     ///    new token
223     /// @param _parentSnapShotBlock Block of the parent token that will
224     ///    determine the initial distribution of the clone token, set to 0 if it
225     ///    is a new token
226     /// @param _tokenName Name of the new token
227     /// @param _decimalUnits Number of decimals of the new token
228     /// @param _tokenSymbol Token Symbol for the new token
229     /// @param _transfersEnabled If true, tokens will be able to be transferred
230     function MiniMeToken(
231         address _tokenFactory,
232         address _parentToken,
233         uint _parentSnapShotBlock,
234         string _tokenName,
235         uint8 _decimalUnits,
236         string _tokenSymbol,
237         bool _transfersEnabled
238     ) {
239         tokenFactory = MiniMeTokenFactory(_tokenFactory);
240         name = _tokenName;                                // Set the name
241         decimals = _decimalUnits;                            // Set the decimals
242         symbol = _tokenSymbol;                             // Set the symbol
243         parentToken = MiniMeToken(_parentToken);
244         parentSnapShotBlock = _parentSnapShotBlock;
245         transfersEnabled = _transfersEnabled;
246         creationBlock = block.number;
247     }
248 
249 
250 ///////////////////
251 // ERC20 Methods
252 ///////////////////
253 
254     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
255     /// @param _to The address of the recipient
256     /// @param _amount The amount of tokens to be transferred
257     /// @return Whether the transfer was successful or not
258     function transfer(address _to, uint256 _amount) returns (bool success) {
259         require(transfersEnabled);
260         doTransfer(msg.sender, _to, _amount);
261         return true;
262     }
263 
264     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
265     ///    is approved by `_from`
266     /// @param _from The address holding the tokens being transferred
267     /// @param _to The address of the recipient
268     /// @param _amount The amount of tokens to be transferred
269     /// @return True if the transfer was successful
270     function transferFrom(address _from, address _to, uint256 _amount
271     ) returns (bool success) {
272 
273         // The controller of this contract can move tokens around at will,
274         //    this is important to recognize! Confirm that you trust the
275         //    controller of this contract, which in most situations should be
276         //    another open source smart contract or 0x0
277         if (msg.sender != controller) {
278             require(transfersEnabled);
279 
280             // The standard ERC 20 transferFrom functionality
281             require(allowed[_from][msg.sender] >= _amount);
282             allowed[_from][msg.sender] -= _amount;
283         }
284         doTransfer(_from, _to, _amount);
285         return true;
286     }
287 
288     /// @dev This is the actual transfer function in the token contract, it can
289     ///    only be called by other functions in this contract.
290     /// @param _from The address holding the tokens being transferred
291     /// @param _to The address of the recipient
292     /// @param _amount The amount of tokens to be transferred
293     /// @return True if the transfer was successful
294     function doTransfer(address _from, address _to, uint _amount
295     ) internal {
296 
297              if (_amount == 0) {
298              Transfer(_from, _to, _amount);    // Follow the spec to issue the event when transfer 0
299              return;
300              }
301 
302              require(parentSnapShotBlock < block.number);
303 
304              // Do not allow transfer to 0x0 or the token contract itself
305              require((_to != 0) && (_to != address(this)));
306 
307              // If the amount being transfered is more than the balance of the
308              //    account the transfer throws
309              uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
310              require(previousBalanceFrom >= _amount);
311 
312              // Alerts the token controller of the transfer
313              if (isContract(controller)) {
314                  require(TokenController(controller).onTransfer(_from, _to, _amount));
315              }
316 
317              // First update the balance array with the new value for the address
318              //    sending the tokens
319              updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
320 
321              // Then update the balance array with the new value for the address
322              //    receiving the tokens
323              uint256 previousBalanceTo = balanceOfAt(_to, block.number);
324              require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
325              updateValueAtNow(balances[_to], previousBalanceTo + _amount);
326 
327              // An event to make the transfer easy to find on the blockchain
328              Transfer(_from, _to, _amount);
329 
330     }
331 
332     /// @param _owner The address that's balance is being requested
333     /// @return The balance of `_owner` at the current block
334     function balanceOf(address _owner) public view returns (uint256 balance) {
335         return balanceOfAt(_owner, block.number);
336     }
337 
338     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
339     ///    its behalf. This is a modified version of the ERC20 approve function
340     ///    to be a little bit safer
341     /// @param _spender The address of the account able to transfer the tokens
342     /// @param _amount The amount of tokens to be approved for transfer
343     /// @return True if the approval was successful
344     function approve(address _spender, uint256 _amount) returns (bool success) {
345         require(transfersEnabled);
346 
347         // To change the approve amount you first have to reduce the addresses`
348         //    allowance to zero by calling `approve(_spender,0)` if it is not
349         //    already 0 to mitigate the race condition described here:
350         //    https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
351         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
352 
353         // Alerts the token controller of the approve function call
354         if (isContract(controller)) {
355             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
356         }
357 
358         allowed[msg.sender][_spender] = _amount;
359         Approval(msg.sender, _spender, _amount);
360         return true;
361     }
362 
363     /// @dev This function makes it easy to read the `allowed[]` map
364     /// @param _owner The address of the account that owns the token
365     /// @param _spender The address of the account able to transfer the tokens
366     /// @return Amount of remaining tokens of _owner that _spender is allowed
367     ///    to spend
368     function allowance(address _owner, address _spender
369     ) public view returns (uint256 remaining) {
370         return allowed[_owner][_spender];
371     }
372 
373     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
374     ///    its behalf, and then a function is triggered in the contract that is
375     ///    being approved, `_spender`. This allows users to use their tokens to
376     ///    interact with contracts in one function call instead of two
377     /// @param _spender The address of the contract able to transfer the tokens
378     /// @param _amount The amount of tokens to be approved for transfer
379     /// @return True if the function call was successful
380     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
381     ) public returns (bool success) {
382         require(approve(_spender, _amount));
383 
384         ApproveAndCallFallBack(_spender).receiveApproval(
385             msg.sender,
386             _amount,
387             this,
388             _extraData
389         );
390 
391         return true;
392     }
393 
394     /// @dev This function makes it easy to get the total number of tokens
395     /// @return The total number of tokens
396     function totalSupply() constant returns (uint) {
397         return totalSupplyAt(block.number);
398     }
399 
400 
401 ////////////////
402 // Query balance and totalSupply in History
403 ////////////////
404 
405     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
406     /// @param _owner The address from which the balance will be retrieved
407     /// @param _blockNumber The block number when the balance is queried
408     /// @return The balance at `_blockNumber`
409     function balanceOfAt(address _owner, uint _blockNumber) public view
410         returns (uint) {
411 
412         // These next few lines are used when the balance of the token is
413         //    requested before a check point was ever created for this token, it
414         //    requires that the `parentToken.balanceOfAt` be queried at the
415         //    genesis block for that token as this contains initial balance of
416         //    this token
417         if ((balances[_owner].length == 0)
418             || (balances[_owner][0].fromBlock > _blockNumber)) {
419             if (address(parentToken) != 0) {
420                return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
421             } else {
422                // Has no parent
423                return 0;
424             }
425 
426         // This will return the expected balance during normal situations
427         } else {
428             return getValueAt(balances[_owner], _blockNumber);
429         }
430     }
431 
432     /// @notice Total amount of tokens at a specific `_blockNumber`.
433     /// @param _blockNumber The block number when the totalSupply is queried
434     /// @return The total amount of tokens at `_blockNumber`
435     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
436 
437         // These next few lines are used when the totalSupply of the token is
438         //    requested before a check point was ever created for this token, it
439         //    requires that the `parentToken.totalSupplyAt` be queried at the
440         //    genesis block for this token as that contains totalSupply of this
441         //    token at this block number.
442         if ((totalSupplyHistory.length == 0)
443             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
444             if (address(parentToken) != 0) {
445                return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
446             } else {
447                return 0;
448             }
449 
450         // This will return the expected totalSupply during normal situations
451         } else {
452             return getValueAt(totalSupplyHistory, _blockNumber);
453         }
454     }
455 
456 ////////////////
457 // Clone Token Method
458 ////////////////
459 
460     /// @notice Creates a new clone token with the initial distribution being
461     ///    this token at `_snapshotBlock`
462     /// @param _cloneTokenName Name of the clone token
463     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
464     /// @param _cloneTokenSymbol Symbol of the clone token
465     /// @param _snapshotBlock Block when the distribution of the parent token is
466     ///    copied to set the initial distribution of the new clone token;
467     ///    if the block is zero than the actual block, the current block is used
468     /// @param _transfersEnabled True if transfers are allowed in the clone
469     /// @return The address of the new MiniMeToken Contract
470     function createCloneToken(
471         string _cloneTokenName,
472         uint8 _cloneDecimalUnits,
473         string _cloneTokenSymbol,
474         uint _snapshotBlock,
475         bool _transfersEnabled
476         ) returns(address) {
477         if (_snapshotBlock == 0) _snapshotBlock = block.number;
478         MiniMeToken cloneToken = tokenFactory.createCloneToken(
479             this,
480             _snapshotBlock,
481             _cloneTokenName,
482             _cloneDecimalUnits,
483             _cloneTokenSymbol,
484             _transfersEnabled
485             );
486 
487         cloneToken.changeController(msg.sender);
488 
489         // An event to make the token easy to find on the blockchain
490         NewCloneToken(address(cloneToken), _snapshotBlock);
491         return address(cloneToken);
492     }
493 
494 ////////////////
495 // Generate and destroy tokens
496 ////////////////
497 
498     /// @notice Generates `_amount` tokens that are assigned to `_owner`
499     /// @param _owner The address that will be assigned the new tokens
500     /// @param _amount The quantity of tokens generated
501     /// @return True if the tokens are generated correctly
502     function generateTokens(address _owner, uint _amount
503     ) onlyController returns (bool) {
504         uint curTotalSupply = totalSupply();
505         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
506         uint previousBalanceTo = balanceOf(_owner);
507         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
508         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
509         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
510         Transfer(0, _owner, _amount);
511         return true;
512     }
513 
514 
515     /// @notice Burns `_amount` tokens from `_owner`
516     /// @param _owner The address that will lose the tokens
517     /// @param _amount The quantity of tokens to burn
518     /// @return True if the tokens are burned correctly
519     function destroyTokens(address _owner, uint256 _amount
520     ) onlyController returns (bool) {
521         uint256 curTotalSupply = totalSupply();
522         require(curTotalSupply >= _amount);
523         uint256 previousBalanceFrom = balanceOf(_owner);
524         require(previousBalanceFrom >= _amount);
525         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
526         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
527         Transfer(_owner, 0, _amount);
528         return true;
529     }
530 
531 ////////////////
532 // Enable tokens transfers
533 ////////////////
534 
535 
536     /// @notice Enables token holders to transfer their tokens freely if true
537     /// @param _transfersEnabled True if transfers are allowed in the clone
538     function enableTransfers(bool _transfersEnabled) onlyController {
539         transfersEnabled = _transfersEnabled;
540     }
541 
542 ////////////////
543 // Internal helper functions to query and set a value in a snapshot array
544 ////////////////
545 
546     /// @dev `getValueAt` retrieves the number of tokens at a given block number
547     /// @param checkpoints The history of values being queried
548     /// @param _block The block number to retrieve the value at
549     /// @return The number of tokens being queried
550     function getValueAt(Checkpoint[] storage checkpoints, uint _block
551     ) internal view returns (uint) {
552         if (checkpoints.length == 0) return 0;
553 
554         // Shortcut for the actual value
555         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
556             return checkpoints[checkpoints.length-1].value;
557         if (_block < checkpoints[0].fromBlock) return 0;
558 
559         // Binary search of the value in the array
560         uint min = 0;
561         uint max = checkpoints.length-1;
562         while (max > min) {
563             uint mid = (max + min + 1)/ 2;
564             if (checkpoints[mid].fromBlock<=_block) {
565                min = mid;
566             } else {
567                max = mid-1;
568             }
569         }
570         return checkpoints[min].value;
571     }
572 
573     /// @dev `updateValueAtNow` used to update the `balances` map and the
574     ///    `totalSupplyHistory`
575     /// @param checkpoints The history of data being updated
576     /// @param _value The new number of tokens
577     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
578     ) internal    {
579         if ((checkpoints.length == 0)
580         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
581                  Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
582                  newCheckPoint.fromBlock =    uint128(block.number);
583                  newCheckPoint.value = uint128(_value);
584              } else {
585                  Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
586                  oldCheckPoint.value = uint128(_value);
587              }
588     }
589 
590     /// @dev Internal function to determine if an address is a contract
591     /// @param _addr The address being queried
592     /// @return True if `_addr` is a contract
593     function isContract(address _addr) internal view returns(bool) {
594         uint size;
595         if (_addr == 0) return false;
596         assembly {
597             size := extcodesize(_addr)
598         }
599         return size > 0;
600     }
601 
602     /// @dev Helper function to return a min betwen the two uints
603     function min(uint a, uint b) internal pure returns (uint) {
604         return a < b ? a : b;
605     }
606 
607     /// @notice The fallback function: If the contract's controller has not been
608     ///    set to 0, then the `proxyPayment` method is called which relays the
609     ///    ether and creates tokens as described in the token controller contract
610     function ()    payable {
611         require(isContract(controller));
612         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
613     }
614 
615 //////////
616 // Safety Methods
617 //////////
618 
619     /// @notice This method can be used by the controller to extract mistakenly
620     ///    sent tokens to this contract.
621     /// @param _token The address of the token contract that you want to recover
622     ///    set to 0 in case you want to extract ether.
623     function claimTokens(address _token) onlyController {
624         if (_token == 0x0) {
625             controller.transfer(this.balance);
626             return;
627         }
628 
629         MiniMeToken token = MiniMeToken(_token);
630         uint balance = token.balanceOf(this);
631         token.transfer(controller, balance);
632         ClaimedTokens(_token, controller, balance);
633     }
634 
635 ////////////////
636 // Events
637 ////////////////
638     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
639     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
640     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
641     event Approval(
642         address indexed _owner,
643         address indexed _spender,
644         uint256 _amount
645         );
646 
647 }
648 
649 
650 ////////////////
651 // MiniMeTokenFactory
652 ////////////////
653 
654 /// @dev This contract is used to generate clone contracts from a contract.
655 ///    In solidity this is the way to create a contract from a contract of the
656 ///    same class
657 contract MiniMeTokenFactory {
658 
659     /// @notice Update the DApp by creating a new token with new functionalities
660     ///    the msg.sender becomes the controller of this clone token
661     /// @param _parentToken Address of the token being cloned
662     /// @param _snapshotBlock Block of the parent token that will
663     ///    determine the initial distribution of the clone token
664     /// @param _tokenName Name of the new token
665     /// @param _decimalUnits Number of decimals of the new token
666     /// @param _tokenSymbol Token Symbol for the new token
667     /// @param _transfersEnabled If true, tokens will be able to be transferred
668     /// @return The address of the new token contract
669     function createCloneToken(
670         address _parentToken,
671         uint _snapshotBlock,
672         string _tokenName,
673         uint8 _decimalUnits,
674         string _tokenSymbol,
675         bool _transfersEnabled
676     ) returns (MiniMeToken) {
677         MiniMeToken newToken = new MiniMeToken(
678             this,
679             _parentToken,
680             _snapshotBlock,
681             _tokenName,
682             _decimalUnits,
683             _tokenSymbol,
684             _transfersEnabled
685             );
686 
687         newToken.changeController(msg.sender);
688         return newToken;
689     }
690 }
691 
692 /**
693     * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
694     * Copyright 2017, Jorge Izquierdo (Aragon Foundation)
695     *
696     * Based on VestedToken.sol from https://github.com/OpenZeppelin/zeppelin-solidity
697     *
698     * Math – Copyright (c) 2016 Smart Contract Solutions, Inc.
699     * SafeMath – Copyright (c) 2016 Smart Contract Solutions, Inc.
700     * MiniMeToken – Copyright 2017, Jordi Baylina (Giveth)
701     **/
702 
703 // @dev MiniMeIrrevocableVestedToken is a derived version of MiniMeToken adding the
704 // ability to createTokenGrants which are basically a transfer that limits the
705 // receiver of the tokens how can he spend them over time.
706 
707 // For simplicity, token grants are not saved in MiniMe type checkpoints.
708 // Vanilla cloning ESCBCoin will clone it into a MiniMeToken without vesting.
709 // More complex cloning could account for past vesting calendars.
710 
711 contract MiniMeIrrevocableVestedToken is MiniMeToken {
712 
713     using SafeMath for uint256;
714 
715     uint256 MAX_GRANTS_PER_ADDRESS = 20;
716     // Keep the struct at 2 stores (1 slot for value + 64 * 3 (dates) + 20 (address) = 2 slots
717     // (2nd slot is 212 bytes, lower than 256))
718     struct TokenGrant {
719     address granter;    // 20 bytes
720     uint256 value;         // 32 bytes
721     uint64 cliff;
722     uint64 vesting;
723     uint64 start;        // 3 * 8 = 24 bytes
724     bool revokable;
725     bool burnsOnRevoke;    // 2 * 1 = 2 bits? or 2 bytes?
726     } // total 78 bytes = 3 sstore per operation (32 per sstore)
727 
728     mapping (address => TokenGrant[]) public grants;
729 
730     event NewTokenGrant(address indexed from, address indexed to, uint256 value, uint64 start, uint64 cliff, uint64 vesting, uint256 grantId);
731 
732     mapping (address => bool) canCreateGrants;
733     address vestingWhitelister;
734 
735     modifier canTransfer(address _sender, uint _value) {
736     require(_value <= spendableBalanceOf(_sender));
737     _;
738     }
739 
740     modifier onlyVestingWhitelister {
741     require(msg.sender == vestingWhitelister);
742     _;
743     }
744 
745     function MiniMeIrrevocableVestedToken (
746         address _tokenFactory,
747         address _parentToken,
748         uint _parentSnapShotBlock,
749         string _tokenName,
750         uint8 _decimalUnits,
751         string _tokenSymbol,
752         bool _transfersEnabled
753     ) public MiniMeToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {
754     vestingWhitelister = msg.sender;
755     doSetCanCreateGrants(vestingWhitelister, true);
756     }
757 
758     // @dev Add canTransfer modifier before allowing transfer and transferFrom to go through
759     function transfer(address _to, uint _value)
760              canTransfer(msg.sender, _value)
761              public
762              returns (bool success) {
763     return super.transfer(_to, _value);
764     }
765 
766     function transferFrom(address _from, address _to, uint _value)
767              canTransfer(_from, _value)
768              public
769              returns (bool success) {
770     return super.transferFrom(_from, _to, _value);
771     }
772 
773     function spendableBalanceOf(address _holder) constant public returns (uint) {
774     return transferableTokens(_holder, uint64(now));
775     }
776 
777     /**
778     * @dev Grant tokens to a specified address
779     * @param _to address The address which the tokens will be granted to.
780     * @param _value uint256 The amount of tokens to be granted.
781     * @param _start uint64 Time of the beginning of the grant.
782     * @param _cliff uint64 Time of the cliff period.
783     * @param _vesting uint64 The vesting period.
784     * @param _revokable bool Token can be revoked with send amount to back.
785     * @param _burnsOnRevoke bool Token can be revoked with send amount to back and destroyed.
786     */
787     function grantVestedTokens(
788     address _to,
789     uint256 _value,
790     uint64 _start,
791     uint64 _cliff,
792     uint64 _vesting,
793     bool _revokable,
794     bool _burnsOnRevoke
795     ) public {
796 
797     // Check for date inconsistencies that may cause unexpected behavior
798     require(_cliff >= _start && _vesting >= _cliff);
799     require(canCreateGrants[msg.sender]);
800 
801     require(tokenGrantsCount(_to) < MAX_GRANTS_PER_ADDRESS);    // To prevent a user being spammed and have his balance locked (out of gas attack when calculating vesting).
802 
803     uint256 count = grants[_to].push(
804                TokenGrant(
805                    _revokable ? msg.sender : 0, // avoid storing an extra 20 bytes when it is non-revokable
806                    _value,
807                    _cliff,
808                    _vesting,
809                    _start,
810                    _revokable,
811                    _burnsOnRevoke
812                )
813                );
814 
815     transfer(_to, _value);
816 
817     NewTokenGrant(msg.sender, _to, _value, _cliff, _vesting, _start, count - 1);
818     }
819 
820     function setCanCreateGrants(address _addr, bool _allowed) onlyVestingWhitelister public {
821     doSetCanCreateGrants(_addr, _allowed);
822     }
823 
824     function doSetCanCreateGrants(address _addr, bool _allowed) internal {
825     canCreateGrants[_addr] = _allowed;
826     }
827 
828     function changeVestingWhitelister(address _newWhitelister) onlyVestingWhitelister public {
829     doSetCanCreateGrants(vestingWhitelister, false);
830     vestingWhitelister = _newWhitelister;
831     doSetCanCreateGrants(vestingWhitelister, true);
832     }
833 
834     /**
835     * @dev Revoke the grant of tokens of a specifed address.
836     * @param _holder The address which will have its tokens revoked.
837     * @param _grantId The id of the token grant.
838     */
839     function revokeTokenGrant(address _holder, uint256 _grantId) public {
840     TokenGrant storage grant = grants[_holder][_grantId];
841 
842     require(grant.revokable);
843     require(grant.granter == msg.sender); // Only granter can revoke it
844 
845     address receiver = grant.burnsOnRevoke ? 0xdead : msg.sender;
846 
847     uint256 nonVested = nonVestedTokens(grant, uint64(now));
848 
849     // remove grant from array
850     delete grants[_holder][_grantId];
851     grants[_holder][_grantId] = grants[_holder][grants[_holder].length.sub(1)];
852     grants[_holder].length -= 1;
853 
854     var previousBalanceReceiver = balanceOfAt(receiver, block.number);
855 
856     //balances[receiver] = balances[receiver].add(nonVested);
857     updateValueAtNow(balances[receiver], previousBalanceReceiver + nonVested);
858 
859     var previousBalance_holder = balanceOfAt(_holder, block.number);
860 
861     //balances[_holder] = balances[_holder].sub(nonVested);
862     updateValueAtNow(balances[_holder], previousBalance_holder - nonVested);
863 
864     Transfer(_holder, receiver, nonVested);
865     }
866 
867     /**
868     * @dev Calculate the total amount of transferable tokens of a holder at a given time
869     * @param holder address The address of the holder
870     * @param time uint64 The specific time.
871     * @return An uint256 representing a holder's total amount of transferable tokens.
872     */
873     function transferableTokens(address holder, uint64 time) public view returns (uint256) {
874     uint256 grantIndex = tokenGrantsCount(holder);
875 
876     if (grantIndex == 0) return balanceOf(holder); // shortcut for holder without grants
877 
878     // Iterate through all the grants the holder has, and add all non-vested tokens
879     uint256 nonVested = 0;
880     for (uint256 i = 0; i < grantIndex; i++) {
881         nonVested = SafeMath.add(nonVested, nonVestedTokens(grants[holder][i], time));
882     }
883 
884     // Balance - totalNonVested is the amount of tokens a holder can transfer at any given time
885     uint256 vestedTransferable = SafeMath.sub(balanceOf(holder), nonVested);
886 
887     // Return the minimum of how many vested can transfer and other value
888     // in case there are other limiting transferability factors (default is balanceOf)
889     return Math.min256(vestedTransferable, balanceOf(holder));
890     }
891 
892     /**
893     * @dev Check the amount of grants that an address has.
894     * @param _holder The holder of the grants.
895     * @return A uint256 representing the total amount of grants.
896     */
897     function tokenGrantsCount(address _holder) public view returns (uint256 index) {
898     return grants[_holder].length;
899     }
900 
901     /**
902     * @dev Calculate amount of vested tokens at a specifc time.
903     * @param tokens uint256 The amount of tokens grantted.
904     * @param time uint64 The time to be checked
905     * @param start uint64 A time representing the begining of the grant
906     * @param cliff uint64 The cliff period.
907     * @param vesting uint64 The vesting period.
908     * @return An uint256 representing the amount of vested tokensof a specif grant.
909     *    transferableTokens
910     *    |                        _/--------    vestedTokens rect
911     *    |                        _/
912     *    |                    _/
913     *    |                    _/
914     *    |                 _/
915     *    |               /
916     *    |               .|
917     *    |            .    |
918     *    |            .    |
919     *    |        .        |
920     *    |        .        |
921     *    |    .            |
922     *    +===+===========+---------+----------> time
923     *        Start         Clift    Vesting
924     */
925     function calculateVestedTokens(
926     uint256 tokens,
927     uint256 time,
928     uint256 start,
929     uint256 cliff,
930     uint256 vesting) internal view returns (uint256)
931     {
932         // Shortcuts for before cliff and after vesting cases.
933         if (time < cliff) return 0;
934         if (time >= vesting) return tokens;
935 
936         // Interpolate all vested tokens.
937         // As before cliff the shortcut returns 0, we can use just calculate a value
938         // in the vesting rect (as shown in above's figure)
939 
940         // vestedTokens = tokens * (time - start) / (vesting - start)
941         uint256 vestedTokens = SafeMath.div(
942                                     SafeMath.mul(
943                                        tokens,
944                                        SafeMath.sub(time, start)
945                                        ),
946                                     SafeMath.sub(vesting, start)
947                                     );
948 
949         return vestedTokens;
950     }
951 
952     /**
953     * @dev Get all information about a specifc grant.
954     * @param _holder The address which will have its tokens revoked.
955     * @param _grantId The id of the token grant.
956     * @return Returns all the values that represent a TokenGrant(address, value, start, cliff,
957     * revokability, burnsOnRevoke, and vesting) plus the vested value at the current time.
958     */
959     function tokenGrant(address _holder, uint256 _grantId) public view returns (address granter, uint256 value, uint256 vested, uint64 start, uint64 cliff, uint64 vesting, bool revokable, bool burnsOnRevoke) {
960     TokenGrant storage grant = grants[_holder][_grantId];
961 
962     granter = grant.granter;
963     value = grant.value;
964     start = grant.start;
965     cliff = grant.cliff;
966     vesting = grant.vesting;
967     revokable = grant.revokable;
968     burnsOnRevoke = grant.burnsOnRevoke;
969 
970     vested = vestedTokens(grant, uint64(now));
971     }
972 
973     /**
974     * @dev Get the amount of vested tokens at a specific time.
975     * @param grant TokenGrant The grant to be checked.
976     * @param time The time to be checked
977     * @return An uint256 representing the amount of vested tokens of a specific grant at a specific time.
978     */
979     function vestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
980     return calculateVestedTokens(
981         grant.value,
982         uint256(time),
983         uint256(grant.start),
984         uint256(grant.cliff),
985         uint256(grant.vesting)
986     );
987     }
988 
989     /**
990     * @dev Calculate the amount of non vested tokens at a specific time.
991     * @param grant TokenGrant The grant to be checked.
992     * @param time uint64 The time to be checked
993     * @return An uint256 representing the amount of non vested tokens of a specifc grant on the
994     * passed time frame.
995     */
996     function nonVestedTokens(TokenGrant grant, uint64 time) private constant returns (uint256) {
997     // Of all the tokens of the grant, how many of them are not vested?
998     // grantValue - vestedTokens
999     return grant.value.sub(vestedTokens(grant, time));
1000     }
1001 
1002     /**
1003     * @dev Calculate the date when the holder can trasfer all its tokens
1004     * @param holder address The address of the holder
1005     * @return An uint256 representing the date of the last transferable tokens.
1006     */
1007     function lastTokenIsTransferableDate(address holder) constant public returns (uint64 date) {
1008     date = uint64(now);
1009     uint256 grantIndex = grants[holder].length;
1010     for (uint256 i = 0; i < grantIndex; i++) {
1011         date = Math.max64(grants[holder][i].vesting, date);
1012     }
1013     }
1014 
1015 }
1016 
1017 /**
1018  * Dividends
1019  * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1020  * Copyright 2017, Adam Dossa
1021  * Based on ProfitSharingContract.sol from https://github.com/adamdossa/ProfitSharingContract
1022  **/
1023 
1024 contract MiniMeIrrVesDivToken is MiniMeIrrevocableVestedToken {
1025 
1026     event DividendDeposited(address indexed _depositor, uint256 _blockNumber, uint256 _timestamp, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
1027     event DividendClaimed(address indexed _claimer, uint256 _dividendIndex, uint256 _claim);
1028     event DividendRecycled(address indexed _recycler, uint256 _blockNumber, uint256 _timestamp, uint256 _amount, uint256 _totalSupply, uint256 _dividendIndex);
1029 
1030     uint256 public RECYCLE_TIME = 1 years;
1031 
1032     function MiniMeIrrVesDivToken (
1033          address _tokenFactory,
1034          address _parentToken,
1035          uint _parentSnapShotBlock,
1036          string _tokenName,
1037          uint8 _decimalUnits,
1038          string _tokenSymbol,
1039          bool _transfersEnabled
1040     ) public MiniMeIrrevocableVestedToken(_tokenFactory, _parentToken, _parentSnapShotBlock, _tokenName, _decimalUnits, _tokenSymbol, _transfersEnabled) {}
1041 
1042     struct Dividend {
1043     uint256 blockNumber;
1044     uint256 timestamp;
1045     uint256 amount;
1046     uint256 claimedAmount;
1047     uint256 totalSupply;
1048     bool recycled;
1049     mapping (address => bool) claimed;
1050     }
1051 
1052     Dividend[] public dividends;
1053 
1054     mapping (address => uint256) dividendsClaimed;
1055 
1056     modifier validDividendIndex(uint256 _dividendIndex) {
1057     require(_dividendIndex < dividends.length);
1058     _;
1059     }
1060 
1061     function depositDividend() public payable
1062     onlyController
1063     {
1064     uint256 currentSupply = super.totalSupplyAt(block.number);
1065     uint256 dividendIndex = dividends.length;
1066     uint256 blockNumber = SafeMath.sub(block.number, 1);
1067     dividends.push(
1068          Dividend(
1069          blockNumber,
1070          getNow(),
1071          msg.value,
1072          0,
1073          currentSupply,
1074          false
1075          )
1076     );
1077     DividendDeposited(msg.sender, blockNumber, getNow(), msg.value, currentSupply, dividendIndex);
1078     }
1079 
1080     function claimDividend(uint256 _dividendIndex) public
1081     validDividendIndex(_dividendIndex)
1082     {
1083     Dividend storage dividend = dividends[_dividendIndex];
1084     require(dividend.claimed[msg.sender] == false);
1085     require(dividend.recycled == false);
1086     uint256 balance = super.balanceOfAt(msg.sender, dividend.blockNumber);
1087     uint256 claim = balance.mul(dividend.amount).div(dividend.totalSupply);
1088     dividend.claimed[msg.sender] = true;
1089     dividend.claimedAmount = SafeMath.add(dividend.claimedAmount, claim);
1090     if (claim > 0) {
1091          msg.sender.transfer(claim);
1092          DividendClaimed(msg.sender, _dividendIndex, claim);
1093     }
1094     }
1095 
1096     function claimDividendAll() public {
1097     require(dividendsClaimed[msg.sender] < dividends.length);
1098     for (uint i = dividendsClaimed[msg.sender]; i < dividends.length; i++) {
1099          if ((dividends[i].claimed[msg.sender] == false) && (dividends[i].recycled == false)) {
1100          dividendsClaimed[msg.sender] = SafeMath.add(i, 1);
1101          claimDividend(i);
1102          }
1103     }
1104     }
1105 
1106     function recycleDividend(uint256 _dividendIndex) public
1107     onlyController
1108     validDividendIndex(_dividendIndex)
1109     {
1110     Dividend storage dividend = dividends[_dividendIndex];
1111     require(dividend.recycled == false);
1112     require(dividend.timestamp < SafeMath.sub(getNow(), RECYCLE_TIME));
1113     dividends[_dividendIndex].recycled = true;
1114     uint256 currentSupply = super.totalSupplyAt(block.number);
1115     uint256 remainingAmount = SafeMath.sub(dividend.amount, dividend.claimedAmount);
1116     uint256 dividendIndex = dividends.length;
1117     uint256 blockNumber = SafeMath.sub(block.number, 1);
1118     dividends.push(
1119          Dividend(
1120          blockNumber,
1121          getNow(),
1122          remainingAmount,
1123          0,
1124          currentSupply,
1125          false
1126          )
1127     );
1128     DividendRecycled(msg.sender, blockNumber, getNow(), remainingAmount, currentSupply, dividendIndex);
1129     }
1130 
1131     function getNow() internal constant returns (uint256) {
1132     return now;
1133     }
1134 }
1135 
1136 /**
1137  * Copyright 2018, Konstantin Viktorov (EscrowBlock Foundation)
1138  **/
1139 
1140 contract ESCBCoin is MiniMeIrrVesDivToken {
1141   // @dev ESCBCoin constructor just parametrizes the MiniMeIrrVesDivToken constructor
1142   function ESCBCoin (
1143     address _tokenFactory
1144   ) public MiniMeIrrVesDivToken(
1145     _tokenFactory,
1146     0x0,            // no parent token
1147     0,              // no snapshot block number from parent
1148     "ESCB token",   // Token name
1149     18,             // Decimals
1150     "ESCB",         // Symbol
1151     true            // Enable transfers
1152     ) {}
1153 }