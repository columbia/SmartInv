1 pragma solidity ^0.4.11;
2 
3 /*
4   Copyright 2017, Anton Egorov (Mothership Foundation)
5   Copyright 2017, Klaus Hott (BlockchainLabs.nz)
6   Copyright 2017, Jordi Baylina (Giveth)
7 
8   This program is free software: you can redistribute it and/or modify
9   it under the terms of the GNU General Public License as published by
10   the Free Software Foundation, either version 3 of the License, or
11   (at your option) any later version.
12 
13   This program is distributed in the hope that it will be useful,
14   but WITHOUT ANY WARRANTY; without even the implied warranty of
15   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16   GNU General Public License for more details.
17 
18   You should have received a copy of the GNU General Public License
19   along with this program.  If not, see <http://www.gnu.org/licenses/>.
20 
21   Based on MineMeToken.sol from https://github.com/Giveth/minime
22   Original contract from https://github.com/status-im/status-network-token/blob/master/contracts/MiniMeToken.sol
23 */
24 
25 contract ERC20Token {
26   /* This is a slight change to the ERC20 base standard.
27      function totalSupply() constant returns (uint256 supply);
28      is replaced with:
29      uint256 public totalSupply;
30      This automatically creates a getter function for the totalSupply.
31      This is moved to the base contract since public getter functions are not
32      currently recognised as an implementation of the matching abstract
33      function by the compiler.
34   */
35   /// total amount of tokens
36   function totalSupply() constant returns (uint256 balance);
37 
38   /// @param _owner The address from which the balance will be retrieved
39   /// @return The balance
40   function balanceOf(address _owner) constant returns (uint256 balance);
41 
42   /// @notice send `_value` token to `_to` from `msg.sender`
43   /// @param _to The address of the recipient
44   /// @param _value The amount of token to be transferred
45   /// @return Whether the transfer was successful or not
46   function transfer(address _to, uint256 _value) returns (bool success);
47 
48   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
49   /// @param _from The address of the sender
50   /// @param _to The address of the recipient
51   /// @param _value The amount of token to be transferred
52   /// @return Whether the transfer was successful or not
53   function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
54 
55   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
56   /// @param _spender The address of the account able to transfer the tokens
57   /// @param _value The amount of tokens to be approved for transfer
58   /// @return Whether the approval was successful or not
59   function approve(address _spender, uint256 _value) returns (bool success);
60 
61   /// @param _owner The address of the account owning tokens
62   /// @param _spender The address of the account able to transfer the tokens
63   /// @return Amount of remaining tokens allowed to spent
64   function allowance(address _owner, address _spender) constant returns (uint256 remaining);
65 
66   event Transfer(address indexed _from, address indexed _to, uint256 _value);
67   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
68 }
69 
70 contract Controlled {
71   /// @notice The address of the controller is the only address that can call
72   ///  a function with this modifier
73   modifier onlyController { if (msg.sender != controller) throw; _; }
74 
75   address public controller;
76 
77   function Controlled() { controller = msg.sender;}
78 
79   /// @notice Changes the controller of the contract
80   /// @param _newController The new controller of the contract
81   function changeController(address _newController) onlyController {
82     controller = _newController;
83   }
84 }
85 
86 contract Burnable is Controlled {
87   /// @notice The address of the controller is the only address that can call
88   ///  a function with this modifier, also the burner can call but also the
89   /// target of the function must be the burner
90   modifier onlyControllerOrBurner(address target) {
91     assert(msg.sender == controller || (msg.sender == burner && msg.sender == target));
92     _;
93   }
94 
95   modifier onlyBurner {
96     assert(msg.sender == burner);
97     _;
98   }
99   address public burner;
100 
101   function Burnable() { burner = msg.sender;}
102 
103   /// @notice Changes the burner of the contract
104   /// @param _newBurner The new burner of the contract
105   function changeBurner(address _newBurner) onlyBurner {
106     burner = _newBurner;
107   }
108 }
109 
110 contract MiniMeTokenI is ERC20Token, Burnable {
111 
112       string public name;                //The Token's name: e.g. DigixDAO Tokens
113       uint8 public decimals;             //Number of decimals of the smallest unit
114       string public symbol;              //An identifier: e.g. REP
115       string public version = 'MMT_0.1'; //An arbitrary versioning scheme
116 
117 ///////////////////
118 // ERC20 Methods
119 ///////////////////
120 
121 
122     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
123     ///  its behalf, and then a function is triggered in the contract that is
124     ///  being approved, `_spender`. This allows users to use their tokens to
125     ///  interact with contracts in one function call instead of two
126     /// @param _spender The address of the contract able to transfer the tokens
127     /// @param _amount The amount of tokens to be approved for transfer
128     /// @return True if the function call was successful
129     function approveAndCall(
130         address _spender,
131         uint256 _amount,
132         bytes _extraData
133     ) returns (bool success);
134 
135 ////////////////
136 // Query balance and totalSupply in History
137 ////////////////
138 
139     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
140     /// @param _owner The address from which the balance will be retrieved
141     /// @param _blockNumber The block number when the balance is queried
142     /// @return The balance at `_blockNumber`
143     function balanceOfAt(
144         address _owner,
145         uint _blockNumber
146     ) constant returns (uint);
147 
148     /// @notice Total amount of tokens at a specific `_blockNumber`.
149     /// @param _blockNumber The block number when the totalSupply is queried
150     /// @return The total amount of tokens at `_blockNumber`
151     function totalSupplyAt(uint _blockNumber) constant returns(uint);
152 
153 ////////////////
154 // Clone Token Method
155 ////////////////
156 
157     /// @notice Creates a new clone token with the initial distribution being
158     ///  this token at `_snapshotBlock`
159     /// @param _cloneTokenName Name of the clone token
160     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
161     /// @param _cloneTokenSymbol Symbol of the clone token
162     /// @param _snapshotBlock Block when the distribution of the parent token is
163     ///  copied to set the initial distribution of the new clone token;
164     ///  if the block is zero than the actual block, the current block is used
165     /// @param _transfersEnabled True if transfers are allowed in the clone
166     /// @return The address of the new MiniMeToken Contract
167     function createCloneToken(
168         string _cloneTokenName,
169         uint8 _cloneDecimalUnits,
170         string _cloneTokenSymbol,
171         uint _snapshotBlock,
172         bool _transfersEnabled
173     ) returns(address);
174 
175 ////////////////
176 // Generate and destroy tokens
177 ////////////////
178 
179     /// @notice Generates `_amount` tokens that are assigned to `_owner`
180     /// @param _owner The address that will be assigned the new tokens
181     /// @param _amount The quantity of tokens generated
182     /// @return True if the tokens are generated correctly
183     function generateTokens(address _owner, uint _amount) returns (bool);
184 
185 
186     /// @notice Burns `_amount` tokens from `_owner`
187     /// @param _owner The address that will lose the tokens
188     /// @param _amount The quantity of tokens to burn
189     /// @return True if the tokens are burned correctly
190     function destroyTokens(address _owner, uint _amount) returns (bool);
191 
192 ////////////////
193 // Enable tokens transfers
194 ////////////////
195 
196     /// @notice Enables token holders to transfer their tokens freely if true
197     /// @param _transfersEnabled True if transfers are allowed in the clone
198     function enableTransfers(bool _transfersEnabled);
199 
200 //////////
201 // Safety Methods
202 //////////
203 
204     /// @notice This method can be used by the controller to extract mistakenly
205     ///  sent tokens to this contract.
206     /// @param _token The address of the token contract that you want to recover
207     ///  set to 0 in case you want to extract ether.
208     function claimTokens(address _token);
209 
210 ////////////////
211 // Events
212 ////////////////
213 
214     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
215     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
216 }
217 
218 /// @dev The token controller contract must implement these functions
219 contract TokenController {
220   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
221   /// @param _owner The address that sent the ether to create tokens
222   /// @return True if the ether is accepted, false if it throws
223   function proxyPayment(address _owner) payable returns(bool);
224 
225   /// @notice Notifies the controller about a token transfer allowing the
226   ///  controller to react if desired
227   /// @param _from The origin of the transfer
228   /// @param _to The destination of the transfer
229   /// @param _amount The amount of the transfer
230   /// @return False if the controller does not authorize the transfer
231   function onTransfer(address _from, address _to, uint _amount) returns(bool);
232 
233   /// @notice Notifies the controller about an approval allowing the
234   ///  controller to react if desired
235   /// @param _owner The address that calls `approve()`
236   /// @param _spender The spender in the `approve()` call
237   /// @param _amount The amount in the `approve()` call
238   /// @return False if the controller does not authorize the approval
239   function onApprove(address _owner, address _spender, uint _amount)
240     returns(bool);
241 }
242 
243 contract ApproveAndCallReceiver {
244   function receiveApproval(address _from, uint256 _amount, address _token, bytes _data);
245 }
246 
247 /// @title MiniMeToken Contract
248 /// @author Jordi Baylina
249 /// @dev This token contract's goal is to make it easy for anyone to clone this
250 ///  token using the token distribution at a given block, this will allow DAO's
251 ///  and DApps to upgrade their features in a decentralized manner without
252 ///  affecting the original token
253 /// @dev It is ERC20 compliant, but still needs to under go further testing.
254 
255 /// @dev The actual token contract, the default controller is the msg.sender
256 ///  that deploys the contract, so usually this token will be deployed by a
257 ///  token controller contract, which Giveth will call a "Campaign"
258 contract MiniMeToken is MiniMeTokenI {
259 
260     /// @dev `Checkpoint` is the structure that attaches a block number to a
261     ///  given value, the block number attached is the one that last changed the
262     ///  value
263     struct  Checkpoint {
264 
265         // `fromBlock` is the block number that the value was generated from
266         uint128 fromBlock;
267 
268         // `value` is the amount of tokens at a specific block number
269         uint128 value;
270     }
271 
272     // `parentToken` is the Token address that was cloned to produce this token;
273     //  it will be 0x0 for a token that was not cloned
274     MiniMeToken public parentToken;
275 
276     // `parentSnapShotBlock` is the block number from the Parent Token that was
277     //  used to determine the initial distribution of the Clone Token
278     uint public parentSnapShotBlock;
279 
280     // `creationBlock` is the block number that the Clone Token was created
281     uint public creationBlock;
282 
283     // `balances` is the map that tracks the balance of each address, in this
284     //  contract when the balance changes the block number that the change
285     //  occurred is also included in the map
286     mapping (address => Checkpoint[]) balances;
287 
288     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
289     mapping (address => mapping (address => uint256)) allowed;
290 
291     // Tracks the history of the `totalSupply` of the token
292     Checkpoint[] totalSupplyHistory;
293 
294     // Flag that determines if the token is transferable or not.
295     bool public transfersEnabled;
296 
297     // The factory used to create new clone tokens
298     MiniMeTokenFactory public tokenFactory;
299 
300 ////////////////
301 // Constructor
302 ////////////////
303 
304     /// @notice Constructor to create a MiniMeToken
305     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
306     ///  will create the Clone token contracts, the token factory needs to be
307     ///  deployed first
308     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
309     ///  new token
310     /// @param _parentSnapShotBlock Block of the parent token that will
311     ///  determine the initial distribution of the clone token, set to 0 if it
312     ///  is a new token
313     /// @param _tokenName Name of the new token
314     /// @param _decimalUnits Number of decimals of the new token
315     /// @param _tokenSymbol Token Symbol for the new token
316     /// @param _transfersEnabled If true, tokens will be able to be transferred
317     function MiniMeToken(
318         address _tokenFactory,
319         address _parentToken,
320         uint _parentSnapShotBlock,
321         string _tokenName,
322         uint8 _decimalUnits,
323         string _tokenSymbol,
324         bool _transfersEnabled
325     ) {
326         tokenFactory = MiniMeTokenFactory(_tokenFactory);
327         name = _tokenName;                                 // Set the name
328         decimals = _decimalUnits;                          // Set the decimals
329         symbol = _tokenSymbol;                             // Set the symbol
330         parentToken = MiniMeToken(_parentToken);
331         parentSnapShotBlock = _parentSnapShotBlock;
332         transfersEnabled = _transfersEnabled;
333         creationBlock = getBlockNumber();
334     }
335 
336 
337 ///////////////////
338 // ERC20 Methods
339 ///////////////////
340 
341     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
342     /// @param _to The address of the recipient
343     /// @param _amount The amount of tokens to be transferred
344     /// @return Whether the transfer was successful or not
345     function transfer(address _to, uint256 _amount) returns (bool success) {
346         if (!transfersEnabled) throw;
347         return doTransfer(msg.sender, _to, _amount);
348     }
349 
350     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
351     ///  is approved by `_from`
352     /// @param _from The address holding the tokens being transferred
353     /// @param _to The address of the recipient
354     /// @param _amount The amount of tokens to be transferred
355     /// @return True if the transfer was successful
356     function transferFrom(address _from, address _to, uint256 _amount
357     ) returns (bool success) {
358 
359         // The controller of this contract can move tokens around at will,
360         //  this is important to recognize! Confirm that you trust the
361         //  controller of this contract, which in most situations should be
362         //  another open source smart contract or 0x0
363         if (msg.sender != controller) {
364             if (!transfersEnabled) throw;
365 
366             // The standard ERC 20 transferFrom functionality
367             if (allowed[_from][msg.sender] < _amount) return false;
368             allowed[_from][msg.sender] -= _amount;
369         }
370         return doTransfer(_from, _to, _amount);
371     }
372 
373     /// @dev This is the actual transfer function in the token contract, it can
374     ///  only be called by other functions in this contract.
375     /// @param _from The address holding the tokens being transferred
376     /// @param _to The address of the recipient
377     /// @param _amount The amount of tokens to be transferred
378     /// @return True if the transfer was successful
379     function doTransfer(address _from, address _to, uint _amount
380     ) internal returns(bool) {
381 
382            if (_amount == 0) {
383                return true;
384            }
385 
386            if (parentSnapShotBlock >= getBlockNumber()) throw;
387 
388            // Do not allow transfer to 0x0 or the token contract itself
389            if ((_to == 0) || (_to == address(this))) throw;
390 
391            // If the amount being transfered is more than the balance of the
392            //  account the transfer returns false
393            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
394            if (previousBalanceFrom < _amount) {
395                return false;
396            }
397 
398            // Alerts the token controller of the transfer
399            if (isContract(controller)) {
400                if (!TokenController(controller).onTransfer(_from, _to, _amount))
401                throw;
402            }
403 
404            // First update the balance array with the new value for the address
405            //  sending the tokens
406            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
407 
408            // Then update the balance array with the new value for the address
409            //  receiving the tokens
410            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
411            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
412            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
413 
414            // An event to make the transfer easy to find on the blockchain
415            Transfer(_from, _to, _amount);
416 
417            return true;
418     }
419 
420     /// @param _owner The address that's balance is being requested
421     /// @return The balance of `_owner` at the current block
422     function balanceOf(address _owner) constant returns (uint256 balance) {
423         return balanceOfAt(_owner, getBlockNumber());
424     }
425 
426     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
427     ///  its behalf. This is a modified version of the ERC20 approve function
428     ///  to be a little bit safer
429     /// @param _spender The address of the account able to transfer the tokens
430     /// @param _amount The amount of tokens to be approved for transfer
431     /// @return True if the approval was successful
432     function approve(address _spender, uint256 _amount) returns (bool success) {
433         if (!transfersEnabled) throw;
434 
435         // To change the approve amount you first have to reduce the addresses`
436         //  allowance to zero by calling `approve(_spender,0)` if it is not
437         //  already 0 to mitigate the race condition described here:
438         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
439         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
440 
441         // Alerts the token controller of the approve function call
442         if (isContract(controller)) {
443             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
444                 throw;
445         }
446 
447         allowed[msg.sender][_spender] = _amount;
448         Approval(msg.sender, _spender, _amount);
449         return true;
450     }
451 
452     /// @dev This function makes it easy to read the `allowed[]` map
453     /// @param _owner The address of the account that owns the token
454     /// @param _spender The address of the account able to transfer the tokens
455     /// @return Amount of remaining tokens of _owner that _spender is allowed
456     ///  to spend
457     function allowance(address _owner, address _spender
458     ) constant returns (uint256 remaining) {
459         return allowed[_owner][_spender];
460     }
461 
462     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
463     ///  its behalf, and then a function is triggered in the contract that is
464     ///  being approved, `_spender`. This allows users to use their tokens to
465     ///  interact with contracts in one function call instead of two
466     /// @param _spender The address of the contract able to transfer the tokens
467     /// @param _amount The amount of tokens to be approved for transfer
468     /// @return True if the function call was successful
469     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
470     ) returns (bool success) {
471         if (!approve(_spender, _amount)) throw;
472 
473         // This portion is copied from ConsenSys's Standard Token Contract. It
474         //  calls the receiveApproval function that is part of the contract that
475         //  is being approved (`_spender`). The function should look like:
476         //  `receiveApproval(address _from, uint256 _amount, address
477         //  _tokenContract, bytes _extraData)` It is assumed that the call
478         //  *should* succeed, otherwise the plain vanilla approve would be used
479         ApproveAndCallReceiver(_spender).receiveApproval(
480             msg.sender,
481             _amount,
482             this,
483             _extraData
484         );
485 
486         return true;
487     }
488 
489     /// @dev This function makes it easy to get the total number of tokens
490     /// @return The total number of tokens
491     function totalSupply() constant returns (uint) {
492         return totalSupplyAt(getBlockNumber());
493     }
494 
495 
496 ////////////////
497 // Query balance and totalSupply in History
498 ////////////////
499 
500     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
501     /// @param _owner The address from which the balance will be retrieved
502     /// @param _blockNumber The block number when the balance is queried
503     /// @return The balance at `_blockNumber`
504     function balanceOfAt(address _owner, uint _blockNumber) constant
505         returns (uint) {
506 
507         // These next few lines are used when the balance of the token is
508         //  requested before a check point was ever created for this token, it
509         //  requires that the `parentToken.balanceOfAt` be queried at the
510         //  genesis block for that token as this contains initial balance of
511         //  this token
512         if ((balances[_owner].length == 0)
513             || (balances[_owner][0].fromBlock > _blockNumber)) {
514             if (address(parentToken) != 0) {
515                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
516             } else {
517                 // Has no parent
518                 return 0;
519             }
520 
521         // This will return the expected balance during normal situations
522         } else {
523             return getValueAt(balances[_owner], _blockNumber);
524         }
525     }
526 
527     /// @notice Total amount of tokens at a specific `_blockNumber`.
528     /// @param _blockNumber The block number when the totalSupply is queried
529     /// @return The total amount of tokens at `_blockNumber`
530     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
531 
532         // These next few lines are used when the totalSupply of the token is
533         //  requested before a check point was ever created for this token, it
534         //  requires that the `parentToken.totalSupplyAt` be queried at the
535         //  genesis block for this token as that contains totalSupply of this
536         //  token at this block number.
537         if ((totalSupplyHistory.length == 0)
538             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
539             if (address(parentToken) != 0) {
540                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
541             } else {
542                 return 0;
543             }
544 
545         // This will return the expected totalSupply during normal situations
546         } else {
547             return getValueAt(totalSupplyHistory, _blockNumber);
548         }
549     }
550 
551 ////////////////
552 // Clone Token Method
553 ////////////////
554 
555     /// @notice Creates a new clone token with the initial distribution being
556     ///  this token at `_snapshotBlock`
557     /// @param _cloneTokenName Name of the clone token
558     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
559     /// @param _cloneTokenSymbol Symbol of the clone token
560     /// @param _snapshotBlock Block when the distribution of the parent token is
561     ///  copied to set the initial distribution of the new clone token;
562     ///  if the block is zero than the actual block, the current block is used
563     /// @param _transfersEnabled True if transfers are allowed in the clone
564     /// @return The address of the new MiniMeToken Contract
565     function createCloneToken(
566         string _cloneTokenName,
567         uint8 _cloneDecimalUnits,
568         string _cloneTokenSymbol,
569         uint _snapshotBlock,
570         bool _transfersEnabled
571         ) returns(address) {
572         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
573         MiniMeToken cloneToken = tokenFactory.createCloneToken(
574             this,
575             _snapshotBlock,
576             _cloneTokenName,
577             _cloneDecimalUnits,
578             _cloneTokenSymbol,
579             _transfersEnabled
580             );
581 
582         cloneToken.changeController(msg.sender);
583 
584         // An event to make the token easy to find on the blockchain
585         NewCloneToken(address(cloneToken), _snapshotBlock);
586         return address(cloneToken);
587     }
588 
589 ////////////////
590 // Generate and destroy tokens
591 ////////////////
592 
593     /// @notice Generates `_amount` tokens that are assigned to `_owner`
594     /// @param _owner The address that will be assigned the new tokens
595     /// @param _amount The quantity of tokens generated
596     /// @return True if the tokens are generated correctly
597     function generateTokens(address _owner, uint _amount
598     ) onlyController returns (bool) {
599         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
600         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
601         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
602         var previousBalanceTo = balanceOf(_owner);
603         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
604         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
605         Transfer(0, _owner, _amount);
606         return true;
607     }
608 
609 
610     /// @notice Burns `_amount` tokens from `_owner`
611     /// @param _owner The address that will lose the tokens
612     /// @param _amount The quantity of tokens to burn
613     /// @return True if the tokens are burned correctly
614     function destroyTokens(address _owner, uint _amount
615     ) onlyControllerOrBurner(_owner) returns (bool) {
616         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
617         if (curTotalSupply < _amount) throw;
618         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
619         var previousBalanceFrom = balanceOf(_owner);
620         if (previousBalanceFrom < _amount) throw;
621         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
622         Transfer(_owner, 0, _amount);
623         return true;
624     }
625 
626 ////////////////
627 // Enable tokens transfers
628 ////////////////
629 
630 
631     /// @notice Enables token holders to transfer their tokens freely if true
632     /// @param _transfersEnabled True if transfers are allowed in the clone
633     function enableTransfers(bool _transfersEnabled) onlyController {
634         transfersEnabled = _transfersEnabled;
635     }
636 
637 ////////////////
638 // Internal helper functions to query and set a value in a snapshot array
639 ////////////////
640 
641     /// @dev `getValueAt` retrieves the number of tokens at a given block number
642     /// @param checkpoints The history of values being queried
643     /// @param _block The block number to retrieve the value at
644     /// @return The number of tokens being queried
645     function getValueAt(Checkpoint[] storage checkpoints, uint _block
646     ) constant internal returns (uint) {
647         if (checkpoints.length == 0) return 0;
648 
649         // Shortcut for the actual value
650         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
651             return checkpoints[checkpoints.length-1].value;
652         if (_block < checkpoints[0].fromBlock) return 0;
653 
654         // Binary search of the value in the array
655         uint min = 0;
656         uint max = checkpoints.length-1;
657         while (max > min) {
658             uint mid = (max + min + 1)/ 2;
659             if (checkpoints[mid].fromBlock<=_block) {
660                 min = mid;
661             } else {
662                 max = mid-1;
663             }
664         }
665         return checkpoints[min].value;
666     }
667 
668     /// @dev `updateValueAtNow` used to update the `balances` map and the
669     ///  `totalSupplyHistory`
670     /// @param checkpoints The history of data being updated
671     /// @param _value The new number of tokens
672     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
673     ) internal  {
674         if ((checkpoints.length == 0)
675         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
676                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
677                newCheckPoint.fromBlock =  uint128(getBlockNumber());
678                newCheckPoint.value = uint128(_value);
679            } else {
680                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
681                oldCheckPoint.value = uint128(_value);
682            }
683     }
684 
685     /// @dev Internal function to determine if an address is a contract
686     /// @param _addr The address being queried
687     /// @return True if `_addr` is a contract
688     function isContract(address _addr) constant internal returns(bool) {
689         uint size;
690         if (_addr == 0) return false;
691         assembly {
692             size := extcodesize(_addr)
693         }
694         return size>0;
695     }
696 
697     /// @dev Helper function to return a min betwen the two uints
698     function min(uint a, uint b) internal returns (uint) {
699         return a < b ? a : b;
700     }
701 
702     /// @notice The fallback function: If the contract's controller has not been
703     ///  set to 0, then the `proxyPayment` method is called which relays the
704     ///  ether and creates tokens as described in the token controller contract
705     function ()  payable {
706         if (isContract(controller)) {
707             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
708                 throw;
709         } else {
710             throw;
711         }
712     }
713 
714 
715 //////////
716 // Testing specific methods
717 //////////
718 
719     /// @notice This function is overridden by the test Mocks.
720     function getBlockNumber() internal constant returns (uint256) {
721         return block.number;
722     }
723 
724 //////////
725 // Safety Methods
726 //////////
727 
728     /// @notice This method can be used by the controller to extract mistakenly
729     ///  sent tokens to this contract.
730     /// @param _token The address of the token contract that you want to recover
731     ///  set to 0 in case you want to extract ether.
732     function claimTokens(address _token) onlyController {
733         if (_token == 0x0) {
734             controller.transfer(this.balance);
735             return;
736         }
737 
738         ERC20Token token = ERC20Token(_token);
739         uint balance = token.balanceOf(this);
740         token.transfer(controller, balance);
741         ClaimedTokens(_token, controller, balance);
742     }
743 
744 ////////////////
745 // Events
746 ////////////////
747 
748     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
749     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
750     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
751     event Approval(
752         address indexed _owner,
753         address indexed _spender,
754         uint256 _amount
755         );
756 
757 }
758 
759 
760 ////////////////
761 // MiniMeTokenFactory
762 ////////////////
763 
764 /// @dev This contract is used to generate clone contracts from a contract.
765 ///  In solidity this is the way to create a contract from a contract of the
766 ///  same class
767 contract MiniMeTokenFactory {
768 
769     /// @notice Update the DApp by creating a new token with new functionalities
770     ///  the msg.sender becomes the controller of this clone token
771     /// @param _parentToken Address of the token being cloned
772     /// @param _snapshotBlock Block of the parent token that will
773     ///  determine the initial distribution of the clone token
774     /// @param _tokenName Name of the new token
775     /// @param _decimalUnits Number of decimals of the new token
776     /// @param _tokenSymbol Token Symbol for the new token
777     /// @param _transfersEnabled If true, tokens will be able to be transferred
778     /// @return The address of the new token contract
779     function createCloneToken(
780         address _parentToken,
781         uint _snapshotBlock,
782         string _tokenName,
783         uint8 _decimalUnits,
784         string _tokenSymbol,
785         bool _transfersEnabled
786     ) returns (MiniMeToken) {
787         MiniMeToken newToken = new MiniMeToken(
788             this,
789             _parentToken,
790             _snapshotBlock,
791             _tokenName,
792             _decimalUnits,
793             _tokenSymbol,
794             _transfersEnabled
795             );
796 
797         newToken.changeController(msg.sender);
798         return newToken;
799     }
800 }
801 
802 contract MSP is MiniMeToken {
803 
804   function MSP(address _tokenFactory)
805     MiniMeToken(
806                 _tokenFactory,
807                 0x0,                // no parent token
808                 0,                  // no snapshot block number from parent
809                 "Mothership Token", // Token name
810                 18,                 // Decimals
811                 "MSP",              // Symbol
812                 true                // Enable transfers
813                 ) {}
814 }