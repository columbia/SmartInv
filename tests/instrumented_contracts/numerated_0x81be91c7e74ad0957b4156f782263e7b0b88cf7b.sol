1 pragma solidity ^0.4.13;
2 
3 /*
4  Proxy Token (PXY) - Crowd funding code for Proxycard Crowd funding campaign 
5  and token used for transactions handled by Proxycard
6  
7  Portions Copyright 2017 Proxy LLC
8  Other portions Copyright as indicated.
9  
10 */ 
11 
12 // Abstract contract for the full ERC 20 Token standard
13 // https://github.com/ethereum/EIPs/issues/20
14 
15 contract ERC20Token {
16 	function totalSupply() constant returns (uint supply);
17 
18 	/// @param _owner The address from which the balance will be retrieved
19 	/// @return The balance
20 	function balanceOf(address _owner) constant returns (uint256 balance);
21 
22 	/// @notice send `_value` token to `_to` from `msg.sender`
23 	/// @param _to The address of the recipient
24 	/// @param _value The amount of token to be transferred
25 	/// @return Whether the transfer was successful or not
26 	function transfer(address _to, uint256 _value) returns (bool success);
27 
28 	/// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
29 	/// @param _from The address of the sender
30 	/// @param _to The address of the recipient
31 	/// @param _value The amount of token to be transferred
32 	/// @return Whether the transfer was successful or not
33 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
34 
35 	/// @notice `msg.sender` approves `_spender` to spend `_value` tokens
36 	/// @param _spender The address of the account able to transfer the tokens
37 	/// @param _value The amount of tokens to be approved for transfer
38 	/// @return Whether the approval was successful or not
39 	function approve(address _spender, uint256 _value) returns (bool success);
40 
41 	/// @param _owner The address of the account owning tokens
42 	/// @param _spender The address of the account able to transfer the tokens
43 	/// @return Amount of remaining tokens allowed to spent
44 	function allowance(address _owner, address _spender) constant returns (uint256 remaining);
45 
46 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
47 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
48 }
49 
50 /*
51     Copyright 2016, Jordi Baylina
52 
53     This program is free software: you can redistribute it and/or modify
54     it under the terms of the GNU General Public License as published by
55     the Free Software Foundation, either version 3 of the License, or
56     (at your option) any later version.
57 
58     This program is distributed in the hope that it will be useful,
59     but WITHOUT ANY WARRANTY; without even the implied warranty of
60     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
61     GNU General Public License for more details.
62 
63     You should have received a copy of the GNU General Public License
64     along with this program.  If not, see <http://www.gnu.org/licenses/>.
65  */
66 
67 /// @title MiniMeToken Contract
68 /// @author Jordi Baylina
69 /// @dev This token contract's goal is to make it easy for anyone to clone this
70 ///  token using the token distribution at a given block, this will allow DAO's
71 ///  and DApps to upgrade their features in a decentralized manner without
72 ///  affecting the original token
73 /// @dev It is ERC20 compliant, but still needs to under go further testing.
74 
75 
76 /// @dev The token controller contract must implement these functions
77 contract TokenController {
78     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
79     /// @param _owner The address that sent the ether to create tokens
80     /// @return True if the ether is accepted, false if it throws
81     function proxyPayment(address _owner) payable returns(bool);
82 
83     /// @notice Notifies the controller about a token transfer allowing the
84     ///  controller to react if desired
85     /// @param _from The origin of the transfer
86     /// @param _to The destination of the transfer
87     /// @param _amount The amount of the transfer
88     /// @return False if the controller does not authorize the transfer
89     function onTransfer(address _from, address _to, uint _amount) returns(bool);
90 
91     /// @notice Notifies the controller about an approval allowing the
92     ///  controller to react if desired
93     /// @param _owner The address that calls `approve()`
94     /// @param _spender The spender in the `approve()` call
95     /// @param _amount The amount in the `approve()` call
96     /// @return False if the controller does not authorize the approval
97     function onApprove(address _owner, address _spender, uint _amount)
98         returns(bool);
99 }
100 
101 contract Controlled {
102     /// @notice The address of the controller is the only address that can call
103     ///  a function with this modifier
104     modifier onlyController { require(msg.sender == controller); _; }
105 
106     address public controller;
107 
108     function Controlled() { controller = msg.sender;}
109 
110     /// @notice Changes the controller of the contract
111     /// @param _newController The new controller of the contract
112     function changeController(address _newController) onlyController {
113         controller = _newController;
114     }
115 }
116 
117 contract ApproveAndCallFallBack {
118     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
119 }
120 
121 /// @dev The actual token contract, the default controller is the msg.sender
122 ///  that deploys the contract, so usually this token will be deployed by a
123 ///  token controller contract, which Giveth will call a "Campaign"
124 contract MiniMeToken is Controlled {
125 
126     string public name;                //The Token's name: e.g. DigixDAO Tokens
127     uint8 public decimals;             //Number of decimals of the smallest unit
128     string public symbol;              //An identifier: e.g. REP
129     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
130 
131 
132     /// @dev `Checkpoint` is the structure that attaches a block number to a
133     ///  given value, the block number attached is the one that last changed the
134     ///  value
135     struct  Checkpoint {
136 
137         // `fromBlock` is the block number that the value was generated from
138         uint128 fromBlock;
139 
140         // `value` is the amount of tokens at a specific block number
141         uint128 value;
142     }
143 
144     // `parentToken` is the Token address that was cloned to produce this token;
145     //  it will be 0x0 for a token that was not cloned
146     MiniMeToken public parentToken;
147 
148     // `parentSnapShotBlock` is the block number from the Parent Token that was
149     //  used to determine the initial distribution of the Clone Token
150     uint public parentSnapShotBlock;
151 
152     // `creationBlock` is the block number that the Clone Token was created
153     uint public creationBlock;
154 
155     // `balances` is the map that tracks the balance of each address, in this
156     //  contract when the balance changes the block number that the change
157     //  occurred is also included in the map
158     mapping (address => Checkpoint[]) balances;
159 
160     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
161     mapping (address => mapping (address => uint256)) allowed;
162 
163     // Tracks the history of the `totalSupply` of the token
164     Checkpoint[] totalSupplyHistory;
165 
166     // Flag that determines if the token is transferable or not.
167     bool public transfersEnabled;
168 
169     // The factory used to create new clone tokens
170     MiniMeTokenFactory public tokenFactory;
171 
172 ////////////////
173 // Constructor
174 ////////////////
175 
176     /// @notice Constructor to create a MiniMeToken
177     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
178     ///  will create the Clone token contracts, the token factory needs to be
179     ///  deployed first
180     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
181     ///  new token
182     /// @param _parentSnapShotBlock Block of the parent token that will
183     ///  determine the initial distribution of the clone token, set to 0 if it
184     ///  is a new token
185     /// @param _tokenName Name of the new token
186     /// @param _decimalUnits Number of decimals of the new token
187     /// @param _tokenSymbol Token Symbol for the new token
188     /// @param _transfersEnabled If true, tokens will be able to be transferred
189     function MiniMeToken(
190         address _tokenFactory,
191         address _parentToken,
192         uint _parentSnapShotBlock,
193         string _tokenName,
194         uint8 _decimalUnits,
195         string _tokenSymbol,
196         bool _transfersEnabled
197     ) {
198         tokenFactory = MiniMeTokenFactory(_tokenFactory);
199         name = _tokenName;                                 // Set the name
200         decimals = _decimalUnits;                          // Set the decimals
201         symbol = _tokenSymbol;                             // Set the symbol
202         parentToken = MiniMeToken(_parentToken);
203         parentSnapShotBlock = _parentSnapShotBlock;
204         transfersEnabled = _transfersEnabled;
205         creationBlock = block.number;
206     }
207 
208 
209 ///////////////////
210 // ERC20 Methods
211 ///////////////////
212 
213     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
214     /// @param _to The address of the recipient
215     /// @param _amount The amount of tokens to be transferred
216     /// @return Whether the transfer was successful or not
217     function transfer(address _to, uint256 _amount) returns (bool success) {
218         require(transfersEnabled);
219         return doTransfer(msg.sender, _to, _amount);
220     }
221 
222     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
223     ///  is approved by `_from`
224     /// @param _from The address holding the tokens being transferred
225     /// @param _to The address of the recipient
226     /// @param _amount The amount of tokens to be transferred
227     /// @return True if the transfer was successful
228     function transferFrom(address _from, address _to, uint256 _amount
229     ) returns (bool success) {
230 
231         // The controller of this contract can move tokens around at will,
232         //  this is important to recognize! Confirm that you trust the
233         //  controller of this contract, which in most situations should be
234         //  another open source smart contract or 0x0
235         if (msg.sender != controller) {
236             require(transfersEnabled);
237 
238             // The standard ERC 20 transferFrom functionality
239             if (allowed[_from][msg.sender] < _amount) return false;
240             allowed[_from][msg.sender] -= _amount;
241         }
242         return doTransfer(_from, _to, _amount);
243     }
244 
245     /// @dev This is the actual transfer function in the token contract, it can
246     ///  only be called by other functions in this contract.
247     /// @param _from The address holding the tokens being transferred
248     /// @param _to The address of the recipient
249     /// @param _amount The amount of tokens to be transferred
250     /// @return True if the transfer was successful
251     function doTransfer(address _from, address _to, uint _amount
252     ) internal returns(bool) {
253 
254            if (_amount == 0) {
255                return true;
256            }
257 
258            require(parentSnapShotBlock < block.number);
259 
260            // Do not allow transfer to 0x0 or the token contract itself
261            require((_to != 0) && (_to != address(this)));
262 
263            // If the amount being transfered is more than the balance of the
264            //  account the transfer returns false
265            var previousBalanceFrom = balanceOfAt(_from, block.number);
266            if (previousBalanceFrom < _amount) {
267                return false;
268            }
269 
270            // Alerts the token controller of the transfer
271            if (isContract(controller)) {
272                require(TokenController(controller).onTransfer(_from, _to, _amount));
273            }
274 
275            // First update the balance array with the new value for the address
276            //  sending the tokens
277            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
278 
279            // Then update the balance array with the new value for the address
280            //  receiving the tokens
281            var previousBalanceTo = balanceOfAt(_to, block.number);
282            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
283            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
284 
285            // An event to make the transfer easy to find on the blockchain
286            Transfer(_from, _to, _amount);
287 
288            return true;
289     }
290 
291     /// @param _owner The address that's balance is being requested
292     /// @return The balance of `_owner` at the current block
293     function balanceOf(address _owner) constant returns (uint256 balance) {
294         return balanceOfAt(_owner, block.number);
295     }
296 
297     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
298     ///  its behalf. This is a modified version of the ERC20 approve function
299     ///  to be a little bit safer
300     /// @param _spender The address of the account able to transfer the tokens
301     /// @param _amount The amount of tokens to be approved for transfer
302     /// @return True if the approval was successful
303     function approve(address _spender, uint256 _amount) returns (bool success) {
304         require(transfersEnabled);
305 
306         // To change the approve amount you first have to reduce the addresses`
307         //  allowance to zero by calling `approve(_spender,0)` if it is not
308         //  already 0 to mitigate the race condition described here:
309         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
311 
312         // Alerts the token controller of the approve function call
313         if (isContract(controller)) {
314             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
315         }
316 
317         allowed[msg.sender][_spender] = _amount;
318         Approval(msg.sender, _spender, _amount);
319         return true;
320     }
321 
322     /// @dev This function makes it easy to read the `allowed[]` map
323     /// @param _owner The address of the account that owns the token
324     /// @param _spender The address of the account able to transfer the tokens
325     /// @return Amount of remaining tokens of _owner that _spender is allowed
326     ///  to spend
327     function allowance(address _owner, address _spender
328     ) constant returns (uint256 remaining) {
329         return allowed[_owner][_spender];
330     }
331 
332     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
333     ///  its behalf, and then a function is triggered in the contract that is
334     ///  being approved, `_spender`. This allows users to use their tokens to
335     ///  interact with contracts in one function call instead of two
336     /// @param _spender The address of the contract able to transfer the tokens
337     /// @param _amount The amount of tokens to be approved for transfer
338     /// @return True if the function call was successful
339     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
340     ) returns (bool success) {
341         require(approve(_spender, _amount));
342 
343         ApproveAndCallFallBack(_spender).receiveApproval(
344             msg.sender,
345             _amount,
346             this,
347             _extraData
348         );
349 
350         return true;
351     }
352 
353     /// @dev This function makes it easy to get the total number of tokens
354     /// @return The total number of tokens
355     function totalSupply() constant returns (uint) {
356         return totalSupplyAt(block.number);
357     }
358 
359 
360 ////////////////
361 // Query balance and totalSupply in History
362 ////////////////
363 
364     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
365     /// @param _owner The address from which the balance will be retrieved
366     /// @param _blockNumber The block number when the balance is queried
367     /// @return The balance at `_blockNumber`
368     function balanceOfAt(address _owner, uint _blockNumber) constant
369         returns (uint) {
370 
371         // These next few lines are used when the balance of the token is
372         //  requested before a check point was ever created for this token, it
373         //  requires that the `parentToken.balanceOfAt` be queried at the
374         //  genesis block for that token as this contains initial balance of
375         //  this token
376         if ((balances[_owner].length == 0)
377             || (balances[_owner][0].fromBlock > _blockNumber)) {
378             if (address(parentToken) != 0) {
379                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
380             } else {
381                 // Has no parent
382                 return 0;
383             }
384 
385         // This will return the expected balance during normal situations
386         } else {
387             return getValueAt(balances[_owner], _blockNumber);
388         }
389     }
390 
391     /// @notice Total amount of tokens at a specific `_blockNumber`.
392     /// @param _blockNumber The block number when the totalSupply is queried
393     /// @return The total amount of tokens at `_blockNumber`
394     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
395 
396         // These next few lines are used when the totalSupply of the token is
397         //  requested before a check point was ever created for this token, it
398         //  requires that the `parentToken.totalSupplyAt` be queried at the
399         //  genesis block for this token as that contains totalSupply of this
400         //  token at this block number.
401         if ((totalSupplyHistory.length == 0)
402             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
403             if (address(parentToken) != 0) {
404                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
405             } else {
406                 return 0;
407             }
408 
409         // This will return the expected totalSupply during normal situations
410         } else {
411             return getValueAt(totalSupplyHistory, _blockNumber);
412         }
413     }
414 
415 ////////////////
416 // Clone Token Method
417 ////////////////
418 
419     /// @notice Creates a new clone token with the initial distribution being
420     ///  this token at `_snapshotBlock`
421     /// @param _cloneTokenName Name of the clone token
422     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
423     /// @param _cloneTokenSymbol Symbol of the clone token
424     /// @param _snapshotBlock Block when the distribution of the parent token is
425     ///  copied to set the initial distribution of the new clone token;
426     ///  if the block is zero than the actual block, the current block is used
427     /// @param _transfersEnabled True if transfers are allowed in the clone
428     /// @return The address of the new MiniMeToken Contract
429     function createCloneToken(
430         string _cloneTokenName,
431         uint8 _cloneDecimalUnits,
432         string _cloneTokenSymbol,
433         uint _snapshotBlock,
434         bool _transfersEnabled
435         ) returns(address) {
436         if (_snapshotBlock == 0) _snapshotBlock = block.number;
437         MiniMeToken cloneToken = tokenFactory.createCloneToken(
438             this,
439             _snapshotBlock,
440             _cloneTokenName,
441             _cloneDecimalUnits,
442             _cloneTokenSymbol,
443             _transfersEnabled
444             );
445 
446         cloneToken.changeController(msg.sender);
447 
448         // An event to make the token easy to find on the blockchain
449         NewCloneToken(address(cloneToken), _snapshotBlock);
450         return address(cloneToken);
451     }
452 
453 ////////////////
454 // Generate and destroy tokens
455 ////////////////
456 
457     /// @notice Generates `_amount` tokens that are assigned to `_owner`
458     /// @param _owner The address that will be assigned the new tokens
459     /// @param _amount The quantity of tokens generated
460     /// @return True if the tokens are generated correctly
461     function generateTokens(address _owner, uint _amount
462     ) onlyController returns (bool) {
463         uint curTotalSupply = totalSupply();
464         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
465         uint previousBalanceTo = balanceOf(_owner);
466         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
467         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
468         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
469         Transfer(0, _owner, _amount);
470         return true;
471     }
472 
473 
474     /// @notice Burns `_amount` tokens from `_owner`
475     /// @param _owner The address that will lose the tokens
476     /// @param _amount The quantity of tokens to burn
477     /// @return True if the tokens are burned correctly
478     function destroyTokens(address _owner, uint _amount
479     ) onlyController returns (bool) {
480         uint curTotalSupply = totalSupply();
481         require(curTotalSupply >= _amount);
482         uint previousBalanceFrom = balanceOf(_owner);
483         require(previousBalanceFrom >= _amount);
484         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
485         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
486         Transfer(_owner, 0, _amount);
487         return true;
488     }
489 
490 ////////////////
491 // Enable tokens transfers
492 ////////////////
493 
494 
495     /// @notice Enables token holders to transfer their tokens freely if true
496     /// @param _transfersEnabled True if transfers are allowed in the clone
497     function enableTransfers(bool _transfersEnabled) onlyController {
498         transfersEnabled = _transfersEnabled;
499     }
500 
501 ////////////////
502 // Internal helper functions to query and set a value in a snapshot array
503 ////////////////
504 
505     /// @dev `getValueAt` retrieves the number of tokens at a given block number
506     /// @param checkpoints The history of values being queried
507     /// @param _block The block number to retrieve the value at
508     /// @return The number of tokens being queried
509     function getValueAt(Checkpoint[] storage checkpoints, uint _block
510     ) constant internal returns (uint) {
511         if (checkpoints.length == 0) return 0;
512 
513         // Shortcut for the actual value
514         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
515             return checkpoints[checkpoints.length-1].value;
516         if (_block < checkpoints[0].fromBlock) return 0;
517 
518         // Binary search of the value in the array
519         uint min = 0;
520         uint max = checkpoints.length-1;
521         while (max > min) {
522             uint mid = (max + min + 1)/ 2;
523             if (checkpoints[mid].fromBlock<=_block) {
524                 min = mid;
525             } else {
526                 max = mid-1;
527             }
528         }
529         return checkpoints[min].value;
530     }
531 
532     /// @dev `updateValueAtNow` used to update the `balances` map and the
533     ///  `totalSupplyHistory`
534     /// @param checkpoints The history of data being updated
535     /// @param _value The new number of tokens
536     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
537     ) internal  {
538         if ((checkpoints.length == 0)
539         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
540                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
541                newCheckPoint.fromBlock =  uint128(block.number);
542                newCheckPoint.value = uint128(_value);
543            } else {
544                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
545                oldCheckPoint.value = uint128(_value);
546            }
547     }
548 
549     /// @dev Internal function to determine if an address is a contract
550     /// @param _addr The address being queried
551     /// @return True if `_addr` is a contract
552     function isContract(address _addr) constant internal returns(bool) {
553         uint size;
554         if (_addr == 0) return false;
555         assembly {
556             size := extcodesize(_addr)
557         }
558         return size>0;
559     }
560 
561     /// @dev Helper function to return a min betwen the two uints
562     function min(uint a, uint b) internal returns (uint) {
563         return a < b ? a : b;
564     }
565 
566     /// @notice The fallback function: If the contract's controller has not been
567     ///  set to 0, then the `proxyPayment` method is called which relays the
568     ///  ether and creates tokens as described in the token controller contract
569     function ()  payable {
570         require(isContract(controller));
571         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
572     }
573 
574 //////////
575 // Safety Methods
576 //////////
577 
578     /// @notice This method can be used by the controller to extract mistakenly
579     ///  sent tokens to this contract.
580     /// @param _token The address of the token contract that you want to recover
581     ///  set to 0 in case you want to extract ether.
582     function claimTokens(address _token) onlyController {
583         if (_token == 0x0) {
584             controller.transfer(this.balance);
585             return;
586         }
587 
588         MiniMeToken token = MiniMeToken(_token);
589         uint balance = token.balanceOf(this);
590         token.transfer(controller, balance);
591         ClaimedTokens(_token, controller, balance);
592     }
593 
594 ////////////////
595 // Events
596 ////////////////
597     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
598     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
599     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
600     event Approval(
601         address indexed _owner,
602         address indexed _spender,
603         uint256 _amount
604         );
605 
606 }
607 
608 
609 ////////////////
610 // MiniMeTokenFactory
611 ////////////////
612 
613 /// @dev This contract is used to generate clone contracts from a contract.
614 ///  In solidity this is the way to create a contract from a contract of the
615 ///  same class
616 contract MiniMeTokenFactory {
617 
618     /// @notice Update the DApp by creating a new token with new functionalities
619     ///  the msg.sender becomes the controller of this clone token
620     /// @param _parentToken Address of the token being cloned
621     /// @param _snapshotBlock Block of the parent token that will
622     ///  determine the initial distribution of the clone token
623     /// @param _tokenName Name of the new token
624     /// @param _decimalUnits Number of decimals of the new token
625     /// @param _tokenSymbol Token Symbol for the new token
626     /// @param _transfersEnabled If true, tokens will be able to be transferred
627     /// @return The address of the new token contract
628     function createCloneToken(
629         address _parentToken,
630         uint _snapshotBlock,
631         string _tokenName,
632         uint8 _decimalUnits,
633         string _tokenSymbol,
634         bool _transfersEnabled
635     ) returns (MiniMeToken) {
636         MiniMeToken newToken = new MiniMeToken(
637             this,
638             _parentToken,
639             _snapshotBlock,
640             _tokenName,
641             _decimalUnits,
642             _tokenSymbol,
643             _transfersEnabled
644             );
645 
646         newToken.changeController(msg.sender);
647         return newToken;
648     }
649 }
650 
651 /*
652     Copyright 2017 ProxyCoin
653 */
654 
655 contract ProxyToken is MiniMeToken {
656 
657 	function ProxyToken()  MiniMeToken(
658 		0x0,
659 		0x0,            // no parent token
660 		0,              // no snapshot block number from parent
661 		"Proxy Token", 	// Token name
662 		6,              // Decimals
663 		"PRXY",         // Symbol
664 		true            // Enable transfers
665 	) {
666 		version = "Proxy 1.1";
667 	}
668 }