1 pragma solidity ^0.4.11;
2 
3 contract ERC20Token {
4     /* This is a slight change to the ERC20 base standard.
5     function totalSupply() constant returns (uint256 supply);
6     is replaced with:
7     uint256 public totalSupply;
8     This automatically creates a getter function for the totalSupply.
9     This is moved to the base contract since public getter functions are not
10     currently recognised as an implementation of the matching abstract
11     function by the compiler.
12     */
13     /// total amount of tokens
14     uint256 public totalSupply;
15 
16     /// @param _owner The address from which the balance will be retrieved
17     /// @return The balance
18     function balanceOf(address _owner) constant returns (uint256 balance);
19 
20     /// @notice send `_value` token to `_to` from `msg.sender`
21     /// @param _to The address of the recipient
22     /// @param _value The amount of token to be transferred
23     /// @return Whether the transfer was successful or not
24     function transfer(address _to, uint256 _value) returns (bool success);
25 
26     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
27     /// @param _from The address of the sender
28     /// @param _to The address of the recipient
29     /// @param _value The amount of token to be transferred
30     /// @return Whether the transfer was successful or not
31     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
32 
33     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
34     /// @param _spender The address of the account able to transfer the tokens
35     /// @param _value The amount of tokens to be approved for transfer
36     /// @return Whether the approval was successful or not
37     function approve(address _spender, uint256 _value) returns (bool success);
38 
39     /// @param _owner The address of the account owning tokens
40     /// @param _spender The address of the account able to transfer the tokens
41     /// @return Amount of remaining tokens allowed to spent
42     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
43 
44     event Transfer(address indexed _from, address indexed _to, uint256 _value);
45     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
46 }
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
74 /// @dev The token controller contract must implement these functions
75 contract TokenController {
76     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
77     /// @param _owner The address that sent the ether to create tokens
78     /// @return True if the ether is accepted, false if it throws
79     function proxyPayment(address _owner) payable returns(bool);
80 
81     /// @notice Notifies the controller about a token transfer allowing the
82     ///  controller to react if desired
83     /// @param _from The origin of the transfer
84     /// @param _to The destination of the transfer
85     /// @param _amount The amount of the transfer
86     /// @return False if the controller does not authorize the transfer
87     function onTransfer(address _from, address _to, uint _amount) returns(bool);
88 
89     /// @notice Notifies the controller about an approval allowing the
90     ///  controller to react if desired
91     /// @param _owner The address that calls `approve()`
92     /// @param _spender The spender in the `approve()` call
93     /// @param _amount The amount in the `approve()` call
94     /// @return False if the controller does not authorize the approval
95     function onApprove(address _owner, address _spender, uint _amount)
96         returns(bool);
97 }
98 
99 contract Controlled {
100     /// @notice The address of the controller is the only address that can call
101     ///  a function with this modifier
102     modifier onlyController { if (msg.sender != controller) throw; _; }
103 
104     address public controller;
105 
106     function Controlled() { controller = msg.sender;}
107 
108     /// @notice Changes the controller of the contract
109     /// @param _newController The new controller of the contract
110     function changeController(address _newController) onlyController {
111         controller = _newController;
112     }
113 }
114 
115 contract ApproveAndCallFallBack {
116     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
117 }
118 
119 /// @dev The actual token contract, the default controller is the msg.sender
120 ///  that deploys the contract, so usually this token will be deployed by a
121 ///  token controller contract, which Giveth will call a "Campaign"
122 contract MiniMeToken is Controlled {
123 
124     string public name;                //The Token's name: e.g. DigixDAO Tokens
125     uint8 public decimals;             //Number of decimals of the smallest unit
126     string public symbol;              //An identifier: e.g. REP
127     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
128 
129 
130     /// @dev `Checkpoint` is the structure that attaches a block number to a
131     ///  given value, the block number attached is the one that last changed the
132     ///  value
133     struct  Checkpoint {
134 
135         // `fromBlock` is the block number that the value was generated from
136         uint128 fromBlock;
137 
138         // `value` is the amount of tokens at a specific block number
139         uint128 value;
140     }
141 
142     // `parentToken` is the Token address that was cloned to produce this token;
143     //  it will be 0x0 for a token that was not cloned
144     MiniMeToken public parentToken;
145 
146     // `parentSnapShotBlock` is the block number from the Parent Token that was
147     //  used to determine the initial distribution of the Clone Token
148     uint public parentSnapShotBlock;
149 
150     // `creationBlock` is the block number that the Clone Token was created
151     uint public creationBlock;
152 
153     // `balances` is the map that tracks the balance of each address, in this
154     //  contract when the balance changes the block number that the change
155     //  occurred is also included in the map
156     mapping (address => Checkpoint[]) balances;
157 
158     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
159     mapping (address => mapping (address => uint256)) allowed;
160 
161     // Tracks the history of the `totalSupply` of the token
162     Checkpoint[] totalSupplyHistory;
163 
164     // Flag that determines if the token is transferable or not.
165     bool public transfersEnabled;
166 
167     // The factory used to create new clone tokens
168     MiniMeTokenFactory public tokenFactory;
169 
170 ////////////////
171 // Constructor
172 ////////////////
173 
174     /// @notice Constructor to create a MiniMeToken
175     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
176     ///  will create the Clone token contracts, the token factory needs to be
177     ///  deployed first
178     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
179     ///  new token
180     /// @param _parentSnapShotBlock Block of the parent token that will
181     ///  determine the initial distribution of the clone token, set to 0 if it
182     ///  is a new token
183     /// @param _tokenName Name of the new token
184     /// @param _decimalUnits Number of decimals of the new token
185     /// @param _tokenSymbol Token Symbol for the new token
186     /// @param _transfersEnabled If true, tokens will be able to be transferred
187     function MiniMeToken(
188         address _tokenFactory,
189         address _parentToken,
190         uint _parentSnapShotBlock,
191         string _tokenName,
192         uint8 _decimalUnits,
193         string _tokenSymbol,
194         bool _transfersEnabled
195     ) {
196         tokenFactory = MiniMeTokenFactory(_tokenFactory);
197         name = _tokenName;                                 // Set the name
198         decimals = _decimalUnits;                          // Set the decimals
199         symbol = _tokenSymbol;                             // Set the symbol
200         parentToken = MiniMeToken(_parentToken);
201         parentSnapShotBlock = _parentSnapShotBlock;
202         transfersEnabled = _transfersEnabled;
203         creationBlock = getBlockNumber();
204     }
205 
206 
207 ///////////////////
208 // ERC20 Methods
209 ///////////////////
210 
211     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
212     /// @param _to The address of the recipient
213     /// @param _amount The amount of tokens to be transferred
214     /// @return Whether the transfer was successful or not
215     function transfer(address _to, uint256 _amount) returns (bool success) {
216         if (!transfersEnabled) throw;
217         return doTransfer(msg.sender, _to, _amount);
218     }
219 
220     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
221     ///  is approved by `_from`
222     /// @param _from The address holding the tokens being transferred
223     /// @param _to The address of the recipient
224     /// @param _amount The amount of tokens to be transferred
225     /// @return True if the transfer was successful
226     function transferFrom(address _from, address _to, uint256 _amount
227     ) returns (bool success) {
228 
229         // The controller of this contract can move tokens around at will,
230         //  this is important to recognize! Confirm that you trust the
231         //  controller of this contract, which in most situations should be
232         //  another open source smart contract or 0x0
233         if (msg.sender != controller) {
234             if (!transfersEnabled) throw;
235 
236             // The standard ERC 20 transferFrom functionality
237             if (allowed[_from][msg.sender] < _amount) return false;
238             allowed[_from][msg.sender] -= _amount;
239         }
240         return doTransfer(_from, _to, _amount);
241     }
242 
243     /// @dev This is the actual transfer function in the token contract, it can
244     ///  only be called by other functions in this contract.
245     /// @param _from The address holding the tokens being transferred
246     /// @param _to The address of the recipient
247     /// @param _amount The amount of tokens to be transferred
248     /// @return True if the transfer was successful
249     function doTransfer(address _from, address _to, uint _amount
250     ) internal returns(bool) {
251 
252            if (_amount == 0) {
253                return true;
254            }
255 
256            if (parentSnapShotBlock >= getBlockNumber()) throw;
257 
258            // Do not allow transfer to 0x0 or the token contract itself
259            if ((_to == 0) || (_to == address(this))) throw;
260 
261            // If the amount being transfered is more than the balance of the
262            //  account the transfer returns false
263            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
264            if (previousBalanceFrom < _amount) {
265                return false;
266            }
267 
268            // Alerts the token controller of the transfer
269            if (isContract(controller)) {
270                if (!TokenController(controller).onTransfer(_from, _to, _amount))
271                throw;
272            }
273 
274            // First update the balance array with the new value for the address
275            //  sending the tokens
276            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
277 
278            // Then update the balance array with the new value for the address
279            //  receiving the tokens
280            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
281            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
282            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
283 
284            // An event to make the transfer easy to find on the blockchain
285            Transfer(_from, _to, _amount);
286 
287            return true;
288     }
289 
290     /// @param _owner The address that's balance is being requested
291     /// @return The balance of `_owner` at the current block
292     function balanceOf(address _owner) constant returns (uint256 balance) {
293         return balanceOfAt(_owner, getBlockNumber());
294     }
295 
296     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
297     ///  its behalf. This is a modified version of the ERC20 approve function
298     ///  to be a little bit safer
299     /// @param _spender The address of the account able to transfer the tokens
300     /// @param _amount The amount of tokens to be approved for transfer
301     /// @return True if the approval was successful
302     function approve(address _spender, uint256 _amount) returns (bool success) {
303         if (!transfersEnabled) throw;
304 
305         // To change the approve amount you first have to reduce the addresses`
306         //  allowance to zero by calling `approve(_spender,0)` if it is not
307         //  already 0 to mitigate the race condition described here:
308         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
310 
311         // Alerts the token controller of the approve function call
312         if (isContract(controller)) {
313             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
314                 throw;
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
341         if (!approve(_spender, _amount)) throw;
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
356         return totalSupplyAt(getBlockNumber());
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
436         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
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
463         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
464         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
465         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
466         var previousBalanceTo = balanceOf(_owner);
467         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
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
480         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
481         if (curTotalSupply < _amount) throw;
482         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
483         var previousBalanceFrom = balanceOf(_owner);
484         if (previousBalanceFrom < _amount) throw;
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
539         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
540                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
541                newCheckPoint.fromBlock =  uint128(getBlockNumber());
542                newCheckPoint.value = uint128(_value);
543            } else {
544                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
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
570         if (isContract(controller)) {
571             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
572                 throw;
573         } else {
574             throw;
575         }
576     }
577 
578 
579 //////////
580 // Testing specific methods
581 //////////
582 
583     /// @notice This function is overridden by the test Mocks.
584     function getBlockNumber() internal constant returns (uint256) {
585         return block.number;
586     }
587 
588 //////////
589 // Safety Methods
590 //////////
591 
592     /// @notice This method can be used by the controller to extract mistakenly
593     ///  sent tokens to this contract.
594     /// @param _token The address of the token contract that you want to recover
595     ///  set to 0 in case you want to extract ether.
596     function claimTokens(address _token) onlyController {
597         if (_token == 0x0) {
598             controller.transfer(this.balance);
599             return;
600         }
601 
602         ERC20Token token = ERC20Token(_token);
603         uint balance = token.balanceOf(this);
604         token.transfer(controller, balance);
605         ClaimedTokens(_token, controller, balance);
606     }
607 
608 ////////////////
609 // Events
610 ////////////////
611 
612     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
613     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
614     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
615     event Approval(
616         address indexed _owner,
617         address indexed _spender,
618         uint256 _amount
619         );
620 
621 }
622 
623 
624 ////////////////
625 // MiniMeTokenFactory
626 ////////////////
627 
628 /// @dev This contract is used to generate clone contracts from a contract.
629 ///  In solidity this is the way to create a contract from a contract of the
630 ///  same class
631 contract MiniMeTokenFactory {
632 
633     /// @notice Update the DApp by creating a new token with new functionalities
634     ///  the msg.sender becomes the controller of this clone token
635     /// @param _parentToken Address of the token being cloned
636     /// @param _snapshotBlock Block of the parent token that will
637     ///  determine the initial distribution of the clone token
638     /// @param _tokenName Name of the new token
639     /// @param _decimalUnits Number of decimals of the new token
640     /// @param _tokenSymbol Token Symbol for the new token
641     /// @param _transfersEnabled If true, tokens will be able to be transferred
642     /// @return The address of the new token contract
643     function createCloneToken(
644         address _parentToken,
645         uint _snapshotBlock,
646         string _tokenName,
647         uint8 _decimalUnits,
648         string _tokenSymbol,
649         bool _transfersEnabled
650     ) returns (MiniMeToken) {
651         MiniMeToken newToken = new MiniMeToken(
652             this,
653             _parentToken,
654             _snapshotBlock,
655             _tokenName,
656             _decimalUnits,
657             _tokenSymbol,
658             _transfersEnabled
659             );
660 
661         newToken.changeController(msg.sender);
662         return newToken;
663     }
664 }
665 
666 contract ATT is MiniMeToken {
667 
668     function ATT(address _tokenFactory)
669             MiniMeToken(
670                 _tokenFactory,
671                 0x0,                     // no parent token
672                 0,                       // no snapshot block number from parent
673                 "Atmatrix Token",        // Token name
674                 18,                      // Decimals
675                 "ATT",                   // Symbol
676                 true                     // Enable transfers
677             ) {}
678 }