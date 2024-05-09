1 pragma solidity ^0.4.18;
2 
3 /*
4   Copyright 2017, Anton Egorov (Mothership Foundation)
5   Copyright 2017, An Hoang Phan Ngo (Mothership Foundation)
6   Copyright 2017, Joel Mislav Kunst (Mothership Fundation)
7   Copyright 2016, Jordi Baylina
8 
9   This program is free software: you can redistribute it and/or modify
10   it under the terms of the GNU General Public License as published by
11   the Free Software Foundation, either version 3 of the License, or
12   (at your option) any later version.
13 
14   This program is distributed in the hope that it will be useful,
15   but WITHOUT ANY WARRANTY; without even the implied warranty of
16   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17   GNU General Public License for more details.
18 
19   You should have received a copy of the GNU General Public License
20   along with this program. If not, see <http://www.gnu.org/licenses/>.
21 */
22 
23 // File: contracts/interface/ApproveAndCallFallBack.sol
24 
25 contract ApproveAndCallFallBack {
26   function receiveApproval(
27     address _from,
28     uint256 _amount,
29     address _token,
30     bytes _data) public;
31 }
32 
33 // File: contracts/interface/Controlled.sol
34 
35 contract Controlled {
36   /// @notice The address of the controller is the only address that can call
37   ///  a function with this modifier
38   modifier onlyController {
39     require(msg.sender == controller);
40     _;
41   }
42 
43   address public controller;
44 
45   function Controlled() public { controller = msg.sender; }
46 
47   /// @notice Changes the controller of the contract
48   /// @param _newController The new controller of the contract
49   function changeController(address _newController) public onlyController {
50     controller = _newController;
51   }
52 }
53 
54 // File: contracts/interface/Burnable.sol
55 
56 /// @dev Burnable introduces a burner role, which could be used to destroy
57 ///  tokens. The burner address could be changed by himself.
58 contract Burnable is Controlled {
59   address public burner;
60 
61   /// @notice The function with this modifier could be called by a controller
62   /// as well as by a burner. But burner could use the onlt his/her address as
63   /// a target.
64   modifier onlyControllerOrBurner(address target) {
65     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
66     _;
67   }
68 
69   modifier onlyBurner {
70     assert(msg.sender == burner);
71     _;
72   }
73 
74   /// Contract creator become a burner by default
75   function Burnable() public { burner = msg.sender;}
76 
77   /// @notice Change a burner address
78   /// @param _newBurner The new burner address
79   function changeBurner(address _newBurner) public onlyBurner {
80     burner = _newBurner;
81   }
82 }
83 
84 // File: contracts/interface/ERC20Token.sol
85 
86 // @dev Abstract contract for the full ERC 20 Token standard
87 //  https://github.com/ethereum/EIPs/issues/20
88 contract ERC20Token {
89   /// total amount of tokens
90   function totalSupply() public view returns (uint256 balance);
91 
92   /// @param _owner The address from which the balance will be retrieved
93   /// @return The balance
94   function balanceOf(address _owner) public view returns (uint256 balance);
95 
96   /// @notice send `_value` token to `_to` from `msg.sender`
97   /// @param _to The address of the recipient
98   /// @param _value The amount of token to be transferred
99   /// @return Whether the transfer was successful or not
100   function transfer(address _to, uint256 _value) public returns (bool success);
101 
102   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
103   /// @param _from The address of the sender
104   /// @param _to The address of the recipient
105   /// @param _value The amount of token to be transferred
106   /// @return Whether the transfer was successful or not
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
108 
109   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
110   /// @param _spender The address of the account able to transfer the tokens
111   /// @param _value The amount of tokens to be approved for transfer
112   /// @return Whether the approval was successful or not
113   function approve(address _spender, uint256 _value) public returns (bool success);
114 
115   /// @param _owner The address of the account owning tokens
116   /// @param _spender The address of the account able to transfer the tokens
117   /// @return Amount of remaining tokens allowed to spent
118   function allowance(address _owner, address _spender) public view returns (uint256 remaining);
119 
120   event Transfer(address indexed _from, address indexed _to, uint256 _value);
121   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122 }
123 
124 // File: contracts/interface/MiniMeTokenI.sol
125 
126 /// @dev MiniMeToken interface. Using this interface instead of whole contracts
127 ///  will reduce contract sise and gas cost
128 contract MiniMeTokenI is ERC20Token, Burnable {
129 
130   string public name;                //The Token's name: e.g. DigixDAO Tokens
131   uint8 public decimals;             //Number of decimals of the smallest unit
132   string public symbol;              //An identifier: e.g. REP
133   string public version = "MMT_0.1"; //An arbitrary versioning scheme
134 
135 ///////////////////
136 // ERC20 Methods
137 ///////////////////
138 
139   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
140   ///  its behalf, and then a function is triggered in the contract that is
141   ///  being approved, `_spender`. This allows users to use their tokens to
142   ///  interact with contracts in one function call instead of two
143   /// @param _spender The address of the contract able to transfer the tokens
144   /// @param _amount The amount of tokens to be approved for transfer
145   /// @return True if the function call was successful
146   function approveAndCall(
147     address _spender,
148     uint256 _amount,
149     bytes _extraData) public returns (bool success);
150 
151 ////////////////
152 // Query balance and totalSupply in History
153 ////////////////
154 
155   /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
156   /// @param _owner The address from which the balance will be retrieved
157   /// @param _blockNumber The block number when the balance is queried
158   /// @return The balance at `_blockNumber`
159   function balanceOfAt(
160     address _owner,
161     uint _blockNumber) public constant returns (uint);
162 
163   /// @notice Total amount of tokens at a specific `_blockNumber`.
164   /// @param _blockNumber The block number when the totalSupply is queried
165   /// @return The total amount of tokens at `_blockNumber`
166   function totalSupplyAt(uint _blockNumber) public constant returns(uint);
167 
168 ////////////////
169 // Generate and destroy tokens
170 ////////////////
171 
172   /// @notice Generates `_amount` tokens that are assigned to `_owner`
173   /// @param _owner The address that will be assigned the new tokens
174   /// @param _amount The quantity of tokens generated
175   /// @return True if the tokens are generated correctly
176   function mintTokens(address _owner, uint _amount) public returns (bool);
177 
178 
179   /// @notice Burns `_amount` tokens from `_owner`
180   /// @param _owner The address that will lose the tokens
181   /// @param _amount The quantity of tokens to burn
182   /// @return True if the tokens are burned correctly
183   function destroyTokens(address _owner, uint _amount) public returns (bool);
184 
185 /////////////////
186 // Finalize 
187 ////////////////
188   function finalize() public;
189 
190 //////////
191 // Safety Methods
192 //////////
193 
194   /// @notice This method can be used by the controller to extract mistakenly
195   ///  sent tokens to this contract.
196   /// @param _token The address of the token contract that you want to recover
197   ///  set to 0 in case you want to extract ether.
198   function claimTokens(address _token) public;
199 
200 ////////////////
201 // Events
202 ////////////////
203 
204   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
205 }
206 
207 // File: contracts/interface/TokenController.sol
208 
209 /// @dev The token controller contract must implement these functions
210 contract TokenController {
211     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
212     /// @param _owner The address that sent the ether to create tokens
213     /// @return True if the ether is accepted, false if it throws
214   function proxyMintTokens(
215     address _owner, 
216     uint _amount,
217     bytes32 _paidTxID) public returns(bool);
218 
219     /// @notice Notifies the controller about a token transfer allowing the
220     ///  controller to react if desired
221     /// @param _from The origin of the transfer
222     /// @param _to The destination of the transfer
223     /// @param _amount The amount of the transfer
224     /// @return False if the controller does not authorize the transfer
225   function onTransfer(address _from, address _to, uint _amount) public returns(bool);
226 
227     /// @notice Notifies the controller about an approval allowing the
228     ///  controller to react if desired
229     /// @param _owner The address that calls `approve()`
230     /// @param _spender The spender in the `approve()` call
231     /// @param _amount The amount in the `approve()` call
232     /// @return False if the controller does not authorize the approval
233   function onApprove(address _owner, address _spender, uint _amount) public
234     returns(bool);
235 }
236 
237 // File: contracts/MiniMeToken.sol
238 
239 /// @title MiniMeToken Contract
240 /// @dev The actual token contract, the default controller is the msg.sender
241 ///  that deploys the contract, so usually this token will be deployed by a
242 ///  token controller contract, which Giveth will call a "Campaign"
243 contract MiniMeToken is MiniMeTokenI {
244 
245   /// @dev `Checkpoint` is the structure that attaches a block number to a
246   ///  given value, the block number attached is the one that last changed the
247   ///  value
248   struct Checkpoint {
249 
250     // `fromBlock` is the block number that the value was generated from
251     uint128 fromBlock;
252 
253     // `value` is the amount of tokens at a specific block number
254     uint128 value;
255   }
256 
257   // `parentToken` is the Token address that was cloned to produce this token;
258   //  it will be 0x0 for a token that was not cloned
259   MiniMeToken public parentToken;
260 
261   // `parentSnapShotBlock` is the block number from the Parent Token that was
262   //  used to determine the initial distribution of the Clone Token
263   uint public parentSnapShotBlock;
264 
265   // `creationBlock` is the block number that the Clone Token was created
266   uint public creationBlock;
267 
268   // `balances` is the map that tracks the balance of each address, in this
269   //  contract when the balance changes the block number that the change
270   //  occurred is also included in the map
271   mapping (address => Checkpoint[]) balances;
272 
273   // `allowed` tracks any extra transfer rights as in all ERC20 tokens
274   mapping (address => mapping (address => uint256)) allowed;
275 
276   // Tracks the history of the `totalSupply` of the token
277   Checkpoint[] totalSupplyHistory;
278 
279 
280   bool public finalized;
281 
282   modifier notFinalized() {
283     require(!finalized);
284     _;
285   }
286 
287 ////////////////
288 // Constructor
289 ////////////////
290 
291   /// @notice Constructor to create a MiniMeToken
292   /// @param _parentToken Address of the parent token, set to 0x0 if it is a
293   ///  new token
294   /// @param _parentSnapShotBlock Block of the parent token that will
295   ///  determine the initial distribution of the clone token, set to 0 if it
296   ///  is a new token
297   /// @param _tokenName Name of the new token
298   /// @param _decimalUnits Number of decimals of the new token
299   /// @param _tokenSymbol Token Symbol for the new token
300   function MiniMeToken(
301     address _parentToken,
302     uint _parentSnapShotBlock,
303     string _tokenName,
304     uint8 _decimalUnits,
305     string _tokenSymbol
306   ) public
307   {
308     name = _tokenName;                                 // Set the name
309     decimals = _decimalUnits;                          // Set the decimals
310     symbol = _tokenSymbol;                             // Set the symbol
311     parentToken = MiniMeToken(_parentToken);
312     parentSnapShotBlock = _parentSnapShotBlock;
313     creationBlock = block.number;
314   }
315 
316 ///////////////////
317 // ERC20 Methods
318 ///////////////////
319 
320   /// @notice Send `_amount` tokens to `_to` from `msg.sender`
321   /// @param _to The address of the recipient
322   /// @param _amount The amount of tokens to be transferred
323   /// @return Whether the transfer was successful or not
324   function transfer(address _to, uint256 _amount) public returns (bool success) {
325     return doTransfer(msg.sender, _to, _amount);
326   }
327 
328   /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
329   ///  is approved by `_from`
330   /// @param _from The address holding the tokens being transferred
331   /// @param _to The address of the recipient
332   /// @param _amount The amount of tokens to be transferred
333   /// @return True if the transfer was successful
334   function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
335     // The standard ERC 20 transferFrom functionality
336     require(allowed[_from][msg.sender] >= _amount);
337     allowed[_from][msg.sender] -= _amount;
338 
339     return doTransfer(_from, _to, _amount);
340   }
341 
342   /// @dev This is the actual transfer function in the token contract, it can
343   ///  only be called by other functions in this contract.
344   /// @param _from The address holding the tokens being transferred
345   /// @param _to The address of the recipient
346   /// @param _amount The amount of tokens to be transferred
347   /// @return True if the transfer was successful
348   function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
349     if (_amount == 0) {
350       return true;
351     }
352 
353     require(parentSnapShotBlock < block.number);
354 
355     // Do not allow transfer to 0x0 or the token contract itself
356     require((_to != 0) && (_to != address(this)));
357 
358     // If the amount being transfered is more than the balance of the
359     //  account the transfer returns false
360     var previousBalanceFrom = balanceOfAt(_from, block.number);
361     if (previousBalanceFrom < _amount) {
362       return false;
363     }
364 
365     // Alerts the token controller of the transfer
366     // Check for transfer enable from controller
367     if (isContract(controller)) {
368       require(TokenController(controller).onTransfer(_from, _to, _amount));
369     }
370 
371     // First update the balance array with the new value for the address
372     //  sending the tokens
373     updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
374 
375     // Then update the balance array with the new value for the address
376     //  receiving the tokens
377     var previousBalanceTo = balanceOfAt(_to, block.number);
378     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
379     updateValueAtNow(balances[_to], previousBalanceTo + _amount);
380 
381     // An event to make the transfer easy to find on the blockchain
382     Transfer(_from, _to, _amount);
383 
384     return true;
385   }
386 
387   /// @param _owner The address that's balance is being requested
388   /// @return The balance of `_owner` at the current block
389   function balanceOf(address _owner) public view returns (uint256 balance) {
390     return balanceOfAt(_owner, block.number);
391   }
392 
393   /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
394   ///  its behalf. This is a modified version of the ERC20 approve function
395   ///  to be a little bit safer
396   /// @param _spender The address of the account able to transfer the tokens
397   /// @param _amount The amount of tokens to be approved for transfer
398   /// @return True if the approval was successful
399   function approve(address _spender, uint256 _amount) public returns (bool success) {
400 
401     // To change the approve amount you first have to reduce the addresses`
402     //  allowance to zero by calling `approve(_spender,0)` if it is not
403     //  already 0 to mitigate the race condition described here:
404     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405     require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
406 
407     // Alerts the token controller of the approve function call
408     if (isContract(controller)) {
409       require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
410     }
411 
412     allowed[msg.sender][_spender] = _amount;
413     Approval(msg.sender, _spender, _amount);
414     return true;
415   }
416 
417   /// @dev This function makes it easy to read the `allowed[]` map
418   /// @param _owner The address of the account that owns the token
419   /// @param _spender The address of the account able to transfer the tokens
420   /// @return Amount of remaining tokens of _owner that _spender is allowed
421   ///  to spend
422   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
423     return allowed[_owner][_spender];
424   }
425 
426   /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
427   ///  its behalf, and then a function is triggered in the contract that is
428   ///  being approved, `_spender`. This allows users to use their tokens to
429   ///  interact with contracts in one function call instead of two
430   /// @param _spender The address of the contract able to transfer the tokens
431   /// @param _amount The amount of tokens to be approved for transfer
432   /// @return True if the function call was successful
433   function approveAndCall(address _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
434     require(approve(_spender, _amount));
435 
436     ApproveAndCallFallBack(_spender).receiveApproval(
437       msg.sender,
438       _amount,
439       this,
440       _extraData
441     );
442 
443     return true;
444   }
445 
446   /// @dev This function makes it easy to get the total number of tokens
447   /// @return The total number of tokens
448   function totalSupply() public view returns (uint) {
449     return totalSupplyAt(block.number);
450   }
451 
452 ////////////////
453 // Query balance and totalSupply in History
454 ////////////////
455 
456   /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
457   /// @param _owner The address from which the balance will be retrieved
458   /// @param _blockNumber The block number when the balance is queried
459   /// @return The balance at `_blockNumber`
460   function balanceOfAt(address _owner, uint _blockNumber) public view returns (uint) {
461 
462     // These next few lines are used when the balance of the token is
463     //  requested before a check point was ever created for this token, it
464     //  requires that the `parentToken.balanceOfAt` be queried at the
465     //  genesis block for that token as this contains initial balance of
466     //  this token
467     if ((balances[_owner].length == 0) ||
468         (balances[_owner][0].fromBlock > _blockNumber)) {
469       if (address(parentToken) != 0) {
470         return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
471       } else {
472         // Has no parent
473         return 0;
474       }
475 
476         // This will return the expected balance during normal situations
477      } else {
478       return getValueAt(balances[_owner], _blockNumber);
479      }
480   }
481 
482   /// @notice Total amount of tokens at a specific `_blockNumber`.
483   /// @param _blockNumber The block number when the totalSupply is queried
484   /// @return The total amount of tokens at `_blockNumber`
485   function totalSupplyAt(uint _blockNumber) public view returns(uint) {
486 
487     // These next few lines are used when the totalSupply of the token is
488     //  requested before a check point was ever created for this token, it
489     //  requires that the `parentToken.totalSupplyAt` be queried at the
490     //  genesis block for this token as that contains totalSupply of this
491     //  token at this block number.
492     if ((totalSupplyHistory.length == 0) ||
493         (totalSupplyHistory[0].fromBlock > _blockNumber)) {
494       if (address(parentToken) != 0) {
495         return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
496       } else {
497         return 0;
498       }
499 
500         // This will return the expected totalSupply during normal situations
501      } else {
502       return getValueAt(totalSupplyHistory, _blockNumber);
503      }
504   }
505 
506 ////////////////
507 // Mint and destroy tokens
508 ////////////////
509 
510   /// @notice Mint `_amount` tokens that are assigned to `_owner`
511   /// @param _owner The address that will be assigned the new tokens
512   /// @param _amount The quantity of tokens minted
513   /// @return True if the tokens are minted correctly
514   function mintTokens(address _owner, uint _amount) public onlyController notFinalized returns (bool) {
515     uint curTotalSupply = totalSupply();
516     require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
517     uint previousBalanceTo = balanceOf(_owner);
518     require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
519     updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
520     updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
521     Transfer(0, _owner, _amount);
522     return true;
523   }
524 
525   /// @notice Burns `_amount` tokens from `_owner`
526   /// @param _owner The address that will lose the tokens
527   /// @param _amount The quantity of tokens to burn
528   /// @return True if the tokens are burned correctly
529   function destroyTokens(address _owner, uint _amount) public onlyControllerOrBurner(_owner) returns (bool) {
530     uint curTotalSupply = totalSupply();
531     require(curTotalSupply >= _amount);
532     uint previousBalanceFrom = balanceOf(_owner);
533     require(previousBalanceFrom >= _amount);
534     updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
535     updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
536     Transfer(_owner, 0, _amount);
537     return true;
538   }
539 
540 ////////////////
541 // Internal helper functions to query and set a value in a snapshot array
542 ////////////////
543 
544   /// @dev `getValueAt` retrieves the number of tokens at a given block number
545   /// @param checkpoints The history of values being queried
546   /// @param _block The block number to retrieve the value at
547   /// @return The number of tokens being queried
548   function getValueAt(Checkpoint[] storage checkpoints, uint _block) internal view returns (uint) {
549     if (checkpoints.length == 0)
550       return 0;
551 
552     // Shortcut for the actual value
553     if (_block >= checkpoints[checkpoints.length-1].fromBlock)
554       return checkpoints[checkpoints.length-1].value;
555     if (_block < checkpoints[0].fromBlock)
556       return 0;
557 
558     // Binary search of the value in the array
559     uint min = 0;
560     uint max = checkpoints.length-1;
561     while (max > min) {
562       uint mid = (max + min + 1) / 2;
563       if (checkpoints[mid].fromBlock<=_block) {
564         min = mid;
565       } else {
566         max = mid-1;
567       }
568     }
569     return checkpoints[min].value;
570   }
571 
572   /// @dev `updateValueAtNow` used to update the `balances` map and the
573   ///  `totalSupplyHistory`
574   /// @param checkpoints The history of data being updated
575   /// @param _value The new number of tokens
576   function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
577     if ((checkpoints.length == 0) ||
578       (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
579       Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
580       newCheckPoint.fromBlock = uint128(block.number);
581       newCheckPoint.value = uint128(_value);
582     } else {
583       Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
584       oldCheckPoint.value = uint128(_value);
585     }
586   }
587 
588   /// @dev Internal function to determine if an address is a contract
589   /// @param _addr The address being queried
590   /// @return True if `_addr` is a contract
591   function isContract(address _addr) internal view returns(bool) {
592     uint size;
593     if (_addr == 0)
594       return false;
595     assembly {
596       size := extcodesize(_addr)
597     }
598     return size>0;
599   }
600 
601   /// @dev Helper function to return a min betwen the two uints
602   function min(uint a, uint b) pure internal returns (uint) {
603     return a < b ? a : b;
604   }
605 
606 //////////
607 // Safety Methods
608 //////////
609 
610   /// @notice This method can be used by the controller to extract mistakenly
611   ///  sent tokens to this contract.
612   /// @param _token The address of the token contract that you want to recover
613   ///  set to 0 in case you want to extract ether.
614   function claimTokens(address _token) public onlyController {
615     if (_token == 0x0) {
616       controller.transfer(this.balance);
617       return;
618     }
619 
620     ERC20Token otherToken = ERC20Token(_token);
621     uint balance = otherToken.balanceOf(this);
622     otherToken.transfer(controller, balance);
623     ClaimedTokens(_token, controller, balance);
624   }
625 
626   function finalize() public onlyController notFinalized {
627     finalized = true;
628   }
629 
630 ////////////////
631 // Events
632 ////////////////
633 
634   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
635   event Transfer(address indexed _from, address indexed _to, uint256 _amount);
636   event Approval(
637     address indexed _owner,
638     address indexed _spender,
639     uint256 _amount
640   );
641 
642 }
643 
644 // File: contracts/SEN.sol
645 
646 contract SEN is MiniMeToken {
647   function SEN() public MiniMeToken(
648     0x0,                // no parent token
649     0,                  // no snapshot block number from parent
650     "Consensus Token",  // Token name
651     18,                 // Decimals
652     "SEN"              // Symbolh
653   )
654   {}
655 }