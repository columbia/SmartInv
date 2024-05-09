1 pragma solidity ^0.4.11;
2 
3 /*
4    Copyright 2017 DappHub, LLC
5 
6    Licensed under the Apache License, Version 2.0 (the "License");
7    you may not use this file except in compliance with the License.
8    You may obtain a copy of the License at
9 
10        http://www.apache.org/licenses/LICENSE-2.0
11 
12    Unless required by applicable law or agreed to in writing, software
13    distributed under the License is distributed on an "AS IS" BASIS,
14    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
15    See the License for the specific language governing permissions and
16    limitations under the License.
17 */
18 
19 // Abstract contract for the full ERC 20 Token standard
20 // https://github.com/ethereum/EIPs/issues/20
21 
22 contract ERC20Token {
23 	function totalSupply() constant returns (uint supply);
24 
25 	/// @param _owner The address from which the balance will be retrieved
26 	/// @return The balance
27 	function balanceOf(address _owner) constant returns (uint256 balance);
28 
29 	/// @notice send `_value` token to `_to` from `msg.sender`
30 	/// @param _to The address of the recipient
31 	/// @param _value The amount of token to be transferred
32 	/// @return Whether the transfer was successful or not
33 	function transfer(address _to, uint256 _value) returns (bool success);
34 
35 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
36 	/// @param _from The address of the sender
37 	/// @param _to The address of the recipient
38 	/// @param _value The amount of token to be transferred
39 	/// @return Whether the transfer was successful or not
40 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
41 
42 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
43 	/// @param _spender The address of the account able to transfer the tokens
44 	/// @param _value The amount of tokens to be approved for transfer
45 	/// @return Whether the approval was successful or not
46 	function approve(address _spender, uint256 _value) returns (bool success);
47 
48 	/// @param _owner The address of the account owning tokens
49 	/// @param _spender The address of the account able to transfer the tokens
50 	/// @return Amount of remaining tokens allowed to spent
51 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
52 
53 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
54 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 pragma solidity ^0.4.11;
58 
59 /*
60     Copyright 2016, Jordi Baylina
61 
62     This program is free software: you can redistribute it and/or modify
63     it under the terms of the GNU General Public License as published by
64     the Free Software Foundation, either version 3 of the License, or
65     (at your option) any later version.
66 
67     This program is distributed in the hope that it will be useful,
68     but WITHOUT ANY WARRANTY; without even the implied warranty of
69     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
70     GNU General Public License for more details.
71 
72     You should have received a copy of the GNU General Public License
73     along with this program.  If not, see <http://www.gnu.org/licenses/>.
74  */
75 
76 /// @title MiniMeToken Contract
77 /// @author Jordi Baylina
78 /// @dev This token contract's goal is to make it easy for anyone to clone this
79 ///  token using the token distribution at a given block, this will allow DAO's
80 ///  and DApps to upgrade their features in a decentralized manner without
81 ///  affecting the original token
82 /// @dev It is ERC20 compliant, but still needs to under go further testing.
83 
84 
85 /// @dev The token controller contract must implement these functions
86 contract TokenController {
87     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
88     /// @param _owner The address that sent the ether to create tokens
89     /// @return True if the ether is accepted, false if it throws
90     function proxyPayment(address _owner) payable returns(bool);
91 
92     /// @notice Notifies the controller about a token transfer allowing the
93     ///  controller to react if desired
94     /// @param _from The origin of the transfer
95     /// @param _to The destination of the transfer
96     /// @param _amount The amount of the transfer
97     /// @return False if the controller does not authorize the transfer
98     function onTransfer(address _from, address _to, uint _amount) returns(bool);
99 
100     /// @notice Notifies the controller about an approval allowing the
101     ///  controller to react if desired
102     /// @param _owner The address that calls `approve()`
103     /// @param _spender The spender in the `approve()` call
104     /// @param _amount The amount in the `approve()` call
105     /// @return False if the controller does not authorize the approval
106     function onApprove(address _owner, address _spender, uint _amount)
107         returns(bool);
108 }
109 
110 contract Controlled {
111     /// @notice The address of the controller is the only address that can call
112     ///  a function with this modifier
113     modifier onlyController { if (msg.sender != controller) throw; _; }
114 
115     address public controller;
116 
117     function Controlled() { controller = msg.sender;}
118 
119     /// @notice Changes the controller of the contract
120     /// @param _newController The new controller of the contract
121     function changeController(address _newController) onlyController {
122         controller = _newController;
123     }
124 }
125 
126 contract ApproveAndCallFallBack {
127     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
128 }
129 
130 /// @dev The actual token contract, the default controller is the msg.sender
131 ///  that deploys the contract, so usually this token will be deployed by a
132 ///  token controller contract, which Giveth will call a "Campaign"
133 contract MiniMeToken is Controlled, ERC20Token {
134 
135     string public name;                //The Token's name: e.g. DigixDAO Tokens
136     uint8 public decimals;             //Number of decimals of the smallest unit
137     string public symbol;              //An identifier: e.g. REP
138     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
139 
140     /// @dev `Checkpoint` is the structure that attaches a block number to a
141     ///  given value, the block number attached is the one that last changed the
142     ///  value
143     struct  Checkpoint {
144 
145         // `fromBlock` is the block number that the value was generated from
146         uint128 fromBlock;
147 
148         // `value` is the amount of tokens at a specific block number
149         uint128 value;
150     }
151 
152     // `parentToken` is the Token address that was cloned to produce this token;
153     //  it will be 0x0 for a token that was not cloned
154     MiniMeToken public parentToken;
155 
156     // `parentSnapShotBlock` is the block number from the Parent Token that was
157     //  used to determine the initial distribution of the Clone Token
158     uint public parentSnapShotBlock;
159 
160     // `creationBlock` is the block number that the Clone Token was created
161     uint public creationBlock;
162 
163     // `balances` is the map that tracks the balance of each address, in this
164     //  contract when the balance changes the block number that the change
165     //  occurred is also included in the map
166     mapping (address => Checkpoint[]) balances;
167 
168     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
169     mapping (address => mapping (address => uint256)) allowed;
170 
171     // Tracks the history of the `totalSupply` of the token
172     Checkpoint[] totalSupplyHistory;
173 
174     // Flag that determines if the token is transferable or not.
175     bool public transfersEnabled;
176 
177     // The factory used to create new clone tokens
178     MiniMeTokenFactory public tokenFactory;
179 
180 ////////////////
181 // Constructor
182 ////////////////
183 
184     /// @notice Constructor to create a MiniMeToken
185     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
186     ///  will create the Clone token contracts, the token factory needs to be
187     ///  deployed first
188     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
189     ///  new token
190     /// @param _parentSnapShotBlock Block of the parent token that will
191     ///  determine the initial distribution of the clone token, set to 0 if it
192     ///  is a new token
193     /// @param _tokenName Name of the new token
194     /// @param _decimalUnits Number of decimals of the new token
195     /// @param _tokenSymbol Token Symbol for the new token
196     /// @param _transfersEnabled If true, tokens will be able to be transferred
197     function MiniMeToken(
198         address _tokenFactory,
199         address _parentToken,
200         uint _parentSnapShotBlock,
201         string _tokenName,
202         uint8 _decimalUnits,
203         string _tokenSymbol,
204         bool _transfersEnabled
205     ) {
206         tokenFactory = MiniMeTokenFactory(_tokenFactory);
207         name = _tokenName;                                 // Set the name
208         decimals = _decimalUnits;                          // Set the decimals
209         symbol = _tokenSymbol;                             // Set the symbol
210         parentToken = MiniMeToken(_parentToken);
211         parentSnapShotBlock = _parentSnapShotBlock;
212         transfersEnabled = _transfersEnabled;
213         creationBlock = block.number;
214     }
215 
216 
217 ///////////////////
218 // ERC20 Methods
219 ///////////////////
220 
221 	/**
222 	*
223 	* Fix for the ERC20 short address attack
224 	*
225 	* http://vessenes.com/the-erc20-short-address-attack-explained/
226 	*/
227 	modifier onlyPayloadSize(uint size) {
228 		if(msg.data.length != size + 4) {
229 		throw;
230 		}
231 		_;
232 	}
233 
234 	/// @notice Send `_amount` tokens to `_to` from `msg.sender`
235 	/// @param _to The address of the recipient
236 	/// @param _amount The amount of tokens to be transferred
237 	/// @return Whether the transfer was successful or not
238 	function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) returns (bool success) {
239 		if (!transfersEnabled) throw;
240 		return doTransfer(msg.sender, _to, _amount);
241     }
242 
243     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
244     ///  is approved by `_from`
245     /// @param _from The address holding the tokens being transferred
246     /// @param _to The address of the recipient
247     /// @param _amount The amount of tokens to be transferred
248     /// @return True if the transfer was successful
249     function transferFrom(address _from, address _to, uint256 _amount
250     ) returns (bool success) {
251 
252         // The controller of this contract can move tokens around at will,
253         //  this is important to recognize! Confirm that you trust the
254         //  controller of this contract, which in most situations should be
255         //  another open source smart contract or 0x0
256         if (msg.sender != controller) {
257             if (!transfersEnabled) throw;
258 
259             // The standard ERC 20 transferFrom functionality
260             if (allowed[_from][msg.sender] < _amount) return false;
261             allowed[_from][msg.sender] -= _amount;
262         }
263         return doTransfer(_from, _to, _amount);
264     }
265 
266     /// @dev This is the actual transfer function in the token contract, it can
267     ///  only be called by other functions in this contract.
268     /// @param _from The address holding the tokens being transferred
269     /// @param _to The address of the recipient
270     /// @param _amount The amount of tokens to be transferred
271     /// @return True if the transfer was successful
272     function doTransfer(address _from, address _to, uint _amount
273     ) internal returns(bool) {
274 
275            if (_amount == 0) {
276                return true;
277            }
278 
279            if (parentSnapShotBlock >= block.number) throw;
280 
281            // Do not allow transfer to 0x0 or the token contract itself
282            if ((_to == 0) || (_to == address(this))) throw;
283 
284            // If the amount being transfered is more than the balance of the
285            //  account the transfer returns false
286            var previousBalanceFrom = balanceOfAt(_from, block.number);
287            if (previousBalanceFrom < _amount) {
288                return false;
289            }
290 
291            // Alerts the token controller of the transfer
292            if (isContract(controller)) {
293                if (!TokenController(controller).onTransfer(_from, _to, _amount))
294                throw;
295            }
296 
297            // First update the balance array with the new value for the address
298            //  sending the tokens
299            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
300 
301            // Then update the balance array with the new value for the address
302            //  receiving the tokens
303            var previousBalanceTo = balanceOfAt(_to, block.number);
304            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
305            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
306 
307            // An event to make the transfer easy to find on the blockchain
308            Transfer(_from, _to, _amount);
309 
310            return true;
311     }
312 
313     /// @param _owner The address that's balance is being requested
314     /// @return The balance of `_owner` at the current block
315     function balanceOf(address _owner) constant returns (uint256 balance) {
316         return balanceOfAt(_owner, block.number);
317     }
318 
319     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
320     ///  its behalf. This is a modified version of the ERC20 approve function
321     ///  to be a little bit safer
322     /// @param _spender The address of the account able to transfer the tokens
323     /// @param _amount The amount of tokens to be approved for transfer
324     /// @return True if the approval was successful
325     function approve(address _spender, uint256 _amount) returns (bool success) {
326         if (!transfersEnabled) throw;
327 
328         // To change the approve amount you first have to reduce the addresses`
329         //  allowance to zero by calling `approve(_spender,0)` if it is not
330         //  already 0 to mitigate the race condition described here:
331         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
333 
334         // Alerts the token controller of the approve function call
335         if (isContract(controller)) {
336             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
337                 throw;
338         }
339 
340         allowed[msg.sender][_spender] = _amount;
341         Approval(msg.sender, _spender, _amount);
342         return true;
343     }
344 
345     /// @dev This function makes it easy to read the `allowed[]` map
346     /// @param _owner The address of the account that owns the token
347     /// @param _spender The address of the account able to transfer the tokens
348     /// @return Amount of remaining tokens of _owner that _spender is allowed
349     ///  to spend
350     function allowance(address _owner, address _spender
351     ) constant returns (uint256 remaining) {
352         return allowed[_owner][_spender];
353     }
354 
355     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
356     ///  its behalf, and then a function is triggered in the contract that is
357     ///  being approved, `_spender`. This allows users to use their tokens to
358     ///  interact with contracts in one function call instead of two
359     /// @param _spender The address of the contract able to transfer the tokens
360     /// @param _amount The amount of tokens to be approved for transfer
361     /// @return True if the function call was successful
362     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
363     ) returns (bool success) {
364         if (!approve(_spender, _amount)) throw;
365 
366         ApproveAndCallFallBack(_spender).receiveApproval(
367             msg.sender,
368             _amount,
369             this,
370             _extraData
371         );
372 
373         return true;
374     }
375 
376     /// @dev This function makes it easy to get the total number of tokens
377     /// @return The total number of tokens
378     function totalSupply() constant returns (uint) {
379         return totalSupplyAt(block.number);
380     }
381 
382 
383 ////////////////
384 // Query balance and totalSupply in History
385 ////////////////
386 
387     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
388     /// @param _owner The address from which the balance will be retrieved
389     /// @param _blockNumber The block number when the balance is queried
390     /// @return The balance at `_blockNumber`
391     function balanceOfAt(address _owner, uint _blockNumber) constant
392         returns (uint) {
393 
394         // These next few lines are used when the balance of the token is
395         //  requested before a check point was ever created for this token, it
396         //  requires that the `parentToken.balanceOfAt` be queried at the
397         //  genesis block for that token as this contains initial balance of
398         //  this token
399         if ((balances[_owner].length == 0)
400             || (balances[_owner][0].fromBlock > _blockNumber)) {
401             if (address(parentToken) != 0) {
402                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
403             } else {
404                 // Has no parent
405                 return 0;
406             }
407 
408         // This will return the expected balance during normal situations
409         } else {
410             return getValueAt(balances[_owner], _blockNumber);
411         }
412     }
413 
414     /// @notice Total amount of tokens at a specific `_blockNumber`.
415     /// @param _blockNumber The block number when the totalSupply is queried
416     /// @return The total amount of tokens at `_blockNumber`
417     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
418 
419         // These next few lines are used when the totalSupply of the token is
420         //  requested before a check point was ever created for this token, it
421         //  requires that the `parentToken.totalSupplyAt` be queried at the
422         //  genesis block for this token as that contains totalSupply of this
423         //  token at this block number.
424         if ((totalSupplyHistory.length == 0)
425             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
426             if (address(parentToken) != 0) {
427                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
428             } else {
429                 return 0;
430             }
431 
432         // This will return the expected totalSupply during normal situations
433         } else {
434             return getValueAt(totalSupplyHistory, _blockNumber);
435         }
436     }
437 
438 ////////////////
439 // Clone Token Method
440 ////////////////
441 
442     /// @notice Creates a new clone token with the initial distribution being
443     ///  this token at `_snapshotBlock`
444     /// @param _cloneTokenName Name of the clone token
445     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
446     /// @param _cloneTokenSymbol Symbol of the clone token
447     /// @param _snapshotBlock Block when the distribution of the parent token is
448     ///  copied to set the initial distribution of the new clone token;
449     ///  if the block is zero than the actual block, the current block is used
450     /// @param _transfersEnabled True if transfers are allowed in the clone
451     /// @return The address of the new MiniMeToken Contract
452     function createCloneToken(
453         string _cloneTokenName,
454         uint8 _cloneDecimalUnits,
455         string _cloneTokenSymbol,
456         uint _snapshotBlock,
457         bool _transfersEnabled
458         ) onlyController returns(address) {
459         if (_snapshotBlock == 0) _snapshotBlock = block.number;
460         MiniMeToken cloneToken = tokenFactory.createCloneToken(
461             this,
462             _snapshotBlock,
463             _cloneTokenName,
464             _cloneDecimalUnits,
465             _cloneTokenSymbol,
466             _transfersEnabled
467             );
468 
469         cloneToken.changeController(msg.sender);
470 
471         // An event to make the token easy to find on the blockchain
472         NewCloneToken(address(cloneToken), _snapshotBlock);
473         return address(cloneToken);
474     }
475 
476 ////////////////
477 // Generate and destroy tokens
478 ////////////////
479 
480     /// @notice Generates `_amount` tokens that are assigned to `_owner`
481     /// @param _owner The address that will be assigned the new tokens
482     /// @param _amount The quantity of tokens generated
483     /// @return True if the tokens are generated correctly
484     function generateTokens(address _owner, uint _amount) onlyController returns (bool) {
485         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
486         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
487 		
488         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
489         var previousBalanceTo = balanceOf(_owner);
490         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
491 		
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
504         uint curTotalSupply = getValueAt(totalSupplyHistory, block.number);
505         if (curTotalSupply < _amount) throw;
506         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
507         var previousBalanceFrom = balanceOf(_owner);
508         if (previousBalanceFrom < _amount) throw;
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
564                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
565                newCheckPoint.fromBlock =  uint128(block.number);
566                newCheckPoint.value = uint128(_value);
567            } else {
568                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
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
594         if (isContract(controller)) {
595             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
596                 throw;
597         } else {
598             throw;
599         }
600     }
601 
602 
603 	////////////////
604 	// Events
605 	////////////////
606 	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
607 	event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
608 	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
609 
610 }
611 
612 ////////////////
613 // MiniMeTokenFactory
614 ////////////////
615 
616 /// @dev This contract is used to generate clone contracts from a contract.
617 ///  In solidity this is the way to create a contract from a contract of the
618 ///  same class
619 contract MiniMeTokenFactory {
620 
621     /// @notice Update the DApp by creating a new token with new functionalities
622     ///  the msg.sender becomes the controller of this clone token
623     /// @param _parentToken Address of the token being cloned
624     /// @param _snapshotBlock Block of the parent token that will
625     ///  determine the initial distribution of the clone token
626     /// @param _tokenName Name of the new token
627     /// @param _decimalUnits Number of decimals of the new token
628     /// @param _tokenSymbol Token Symbol for the new token
629     /// @param _transfersEnabled If true, tokens will be able to be transferred
630     /// @return The address of the new token contract
631     function createCloneToken(
632         address _parentToken,
633         uint _snapshotBlock,
634         string _tokenName,
635         uint8 _decimalUnits,
636         string _tokenSymbol,
637         bool _transfersEnabled
638     ) returns (MiniMeToken) {
639         MiniMeToken newToken = new MiniMeToken(
640             this,
641             _parentToken,
642             _snapshotBlock,
643             _tokenName,
644             _decimalUnits,
645             _tokenSymbol,
646             _transfersEnabled
647             );
648 
649         newToken.changeController(msg.sender);
650         return newToken;
651     }
652 }
653 
654 /// @title Clit Token (CLIT) - Crowd funding code for CLIT Coin project
655 /// 
656 
657 
658 contract ClitCoinToken is MiniMeToken {
659 
660 
661 	function ClitCoinToken(
662 		//address _tokenFactory
663 	) MiniMeToken(
664 		0x0,
665 		0x0,            // no parent token
666 		0,              // no snapshot block number from parent
667 		"CLIT Token", 	// Token name
668 		0,              // Decimals
669 		"CLIT",         // Symbol
670 		false            // Enable transfers
671 	) {
672 		version = "CLIT 1.0";
673 	}
674 
675 
676 }
677 
678 /*
679  * Math operations with safety checks
680  */
681 contract SafeMath {
682   function mul(uint a, uint b) internal returns (uint) {
683     uint c = a * b;
684     assert(a == 0 || c / a == b);
685     return c;
686   }
687 
688   function div(uint a, uint b) internal returns (uint) {
689     assert(b > 0);
690     uint c = a / b;
691     assert(a == b * c + a % b);
692     return c;
693   }
694 
695   function sub(uint a, uint b) internal returns (uint) {
696     assert(b <= a);
697     return a - b;
698   }
699 
700   function add(uint a, uint b) internal returns (uint) {
701     uint c = a + b;
702     assert(c >= a);
703     return c;
704   }
705 }
706 
707 
708 contract ClitCrowdFunder is Controlled, SafeMath {
709 
710 	address public creator;
711     address public fundRecipient;
712 	
713 	// State variables
714     State public state = State.Fundraising; // initialize on create	
715     uint public fundingGoal; 
716 	uint public totalRaised;
717 	uint public currentBalance;
718 	uint public issuedTokenBalance;
719 	uint public totalTokensIssued;
720 	uint public capTokenAmount;
721 	uint public startBlockNumber;
722 	uint public endBlockNumber;
723 	uint public eolBlockNumber;
724 	
725 	uint public firstExchangeRatePeriod;
726 	uint public secondExchangeRatePeriod;
727 	uint public thirdExchangeRatePeriod;
728 	uint public fourthExchangeRatePeriod;
729 	
730 	uint public firstTokenExchangeRate;
731 	uint public secondTokenExchangeRate;
732 	uint public thirdTokenExchangeRate;
733 	uint public fourthTokenExchangeRate;
734 	uint public finalTokenExchangeRate;	
735 	
736 	bool public fundingGoalReached;
737 	
738     ClitCoinToken public exchangeToken;
739 	
740 	/* This generates a public event on the blockchain that will notify clients */
741 	event HardCapReached(address fundRecipient, uint amountRaised);
742 	event GoalReached(address fundRecipient, uint amountRaised);
743 	event FundTransfer(address backer, uint amount, bool isContribution);	
744 	event FrozenFunds(address target, bool frozen);
745 	event RefundPeriodStarted();
746 
747 	/* data structure to hold information about campaign contributors */
748 	mapping(address => uint256) private balanceOf;
749 	mapping (address => bool) private frozenAccount;
750 	
751 	// Data structures
752     enum State {
753 		Fundraising,
754 		ExpiredRefund,
755 		Successful,
756 		Closed
757 	}
758 	
759 	/*
760      *  Modifiers
761      */
762 
763 	modifier inState(State _state) {
764         if (state != _state) throw;
765         _;
766     }
767 	
768 	// Add one week to endBlockNumber
769 	modifier atEndOfLifecycle() {
770         if(!((state == State.ExpiredRefund && block.number > eolBlockNumber) || state == State.Successful)) {
771             throw;
772         }
773         _;
774     }
775 	
776 	modifier accountNotFrozen() {
777         if (frozenAccount[msg.sender] == true) throw;
778         _;
779     }
780 	
781     modifier minInvestment() {
782       // User has to send at least 0.01 Eth
783       require(msg.value >= 10 ** 16);
784       _;
785     }
786 	
787 	modifier isStarted() {
788 		require(block.number >= startBlockNumber);
789 		_;
790 	}
791 
792 	/*  at initialization, setup the owner */
793 	function ClitCrowdFunder(
794 		address _fundRecipient,
795 		uint _delayStartHours,
796 		ClitCoinToken _addressOfExchangeToken
797 	) {
798 		creator = msg.sender;
799 		
800 		fundRecipient = _fundRecipient;
801 		fundingGoal = 7000 * 1 ether;
802 		capTokenAmount = 140 * 10 ** 6;
803 		state = State.Fundraising;
804 		fundingGoalReached = false;
805 		
806 		totalRaised = 0;
807 		currentBalance = 0;
808 		totalTokensIssued = 0;
809 		issuedTokenBalance = 0;
810 		
811 		startBlockNumber = block.number + div(mul(3600, _delayStartHours), 14);
812 		endBlockNumber = startBlockNumber + div(mul(3600, 1080), 14); // 45 days 
813 		eolBlockNumber = endBlockNumber + div(mul(3600, 168), 14);  // one week - contract end of life
814 
815 		firstExchangeRatePeriod = startBlockNumber + div(mul(3600, 24), 14);   // First 24 hour sale 
816 		secondExchangeRatePeriod = firstExchangeRatePeriod + div(mul(3600, 240), 14); // Next 10 days
817 		thirdExchangeRatePeriod = secondExchangeRatePeriod + div(mul(3600, 240), 14); // Next 10 days
818 		fourthExchangeRatePeriod = thirdExchangeRatePeriod + div(mul(3600, 240), 14); // Next 10 days
819 		
820 		uint _tokenExchangeRate = 1000;
821 		firstTokenExchangeRate = (_tokenExchangeRate + 1000);	
822 		secondTokenExchangeRate = (_tokenExchangeRate + 500);
823 		thirdTokenExchangeRate = (_tokenExchangeRate + 300);
824 		fourthTokenExchangeRate = (_tokenExchangeRate + 100);
825 		finalTokenExchangeRate = _tokenExchangeRate;
826 		
827 		exchangeToken = ClitCoinToken(_addressOfExchangeToken);
828 	}
829 	
830 	function freezeAccount(address target, bool freeze) onlyController {
831         frozenAccount[target] = freeze;
832         FrozenFunds(target, freeze);
833     }	
834 	
835 	function getCurrentExchangeRate(uint amount) public constant returns(uint) {
836 		if (block.number <= firstExchangeRatePeriod) {
837 			return firstTokenExchangeRate * amount / 1 ether;
838 		} else if (block.number <= secondExchangeRatePeriod) {
839 			return secondTokenExchangeRate * amount / 1 ether;
840 		} else if (block.number <= thirdExchangeRatePeriod) {
841 			return thirdTokenExchangeRate * amount / 1 ether;
842 		} else if (block.number <= fourthExchangeRatePeriod) {
843 			return fourthTokenExchangeRate * amount / 1 ether;
844 		} else if (block.number <= endBlockNumber) {
845 			return finalTokenExchangeRate * amount / 1 ether;
846 		}
847 		
848 		return finalTokenExchangeRate * amount / 1 ether;
849 	}
850 
851 	function investment() public inState(State.Fundraising) isStarted accountNotFrozen minInvestment payable returns(uint)  {
852 		
853 		uint amount = msg.value;
854 		if (amount == 0) throw;
855 		
856 		balanceOf[msg.sender] += amount;	
857 		
858 		totalRaised += amount;
859 		currentBalance += amount;
860 						
861 		uint tokenAmount = getCurrentExchangeRate(amount);
862 		exchangeToken.generateTokens(msg.sender, tokenAmount);
863 		totalTokensIssued += tokenAmount;
864 		issuedTokenBalance += tokenAmount;
865 		
866 		FundTransfer(msg.sender, amount, true); 
867 		
868 		checkIfFundingCompleteOrExpired();
869 		
870 		return balanceOf[msg.sender];
871 	}
872 
873 	function checkIfFundingCompleteOrExpired() {
874 		if (block.number > endBlockNumber || totalTokensIssued >= capTokenAmount ) {
875 			// Hard limit reached
876 			if (currentBalance > fundingGoal || fundingGoalReached == true) {
877 				state = State.Successful;
878 				payOut();
879 				
880 				HardCapReached(fundRecipient, totalRaised);
881 				
882 				// Contract can be immediately closed out
883 				removeContract();
884 
885 			} else  {
886 				state = State.ExpiredRefund; // backers can now collect refunds by calling getRefund()
887 				
888 				RefundPeriodStarted();
889 			}
890 		} else if (currentBalance > fundingGoal && fundingGoalReached == false) {
891 			// Once goal reached
892 			fundingGoalReached = true;
893 			
894 			state = State.Successful;
895 			payOut();
896 			
897 			// Continue allowing users to buy in
898 			state = State.Fundraising;
899 			
900 			// currentBalance is zero after pay out
901 			GoalReached(fundRecipient, totalRaised);
902 		}
903 	}
904 
905 	function payOut() public inState(State.Successful) {
906 		// Ethereum balance
907 		var amount = currentBalance;
908 		currentBalance = 0;
909 
910 		fundRecipient.transfer(amount);
911 		
912 		// Update the token reserve amount so that 50% of tokens remain in reserve
913 		var tokenCount = issuedTokenBalance;
914 		issuedTokenBalance = 0;
915 		
916 		exchangeToken.generateTokens(fundRecipient, tokenCount);		
917 	}
918 
919 	function getRefund() public inState(State.ExpiredRefund) {	
920 		uint amountToRefund = balanceOf[msg.sender];
921 		balanceOf[msg.sender] = 0;
922 		
923 		// throws error if fails
924 		msg.sender.transfer(amountToRefund);
925 		currentBalance -= amountToRefund;
926 		
927 		FundTransfer(msg.sender, amountToRefund, false);
928 	}
929 	
930 	function removeContract() public atEndOfLifecycle {		
931 		state = State.Closed;
932 		
933 		// Allow clit owners to freely trade coins on the open market
934 		exchangeToken.enableTransfers(true);
935 		
936 		// Restore ownership to controller
937 		exchangeToken.changeController(controller);
938 
939 		selfdestruct(msg.sender);
940 	}
941 	
942 	/* The function without name is the default function that is called whenever anyone sends funds to a contract */
943 	function () payable { 
944 		investment(); 
945 	}	
946 
947 }