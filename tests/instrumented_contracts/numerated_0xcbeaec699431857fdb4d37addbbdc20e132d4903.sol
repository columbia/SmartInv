1 pragma solidity ^0.4.11;
2 contract ERC20Token {
3     /* This is a slight change to the ERC20 base standard.
4     function totalSupply() constant returns (uint256 supply);
5     is replaced with:
6     uint256 public totalSupply;
7     This automatically creates a getter function for the totalSupply.
8     This is moved to the base contract since public getter functions are not
9     currently recognised as an implementation of the matching abstract
10     function by the compiler.
11     */
12     /// total amount of tokens
13     uint256 public totalSupply;
14 
15     /// @param _owner The address from which the balance will be retrieved
16     /// @return The balance
17     function balanceOf(address _owner) constant returns (uint256 balance);
18 
19     /// @notice send `_value` token to `_to` from `msg.sender`
20     /// @param _to The address of the recipient
21     /// @param _value The amount of token to be transferred
22     /// @return Whether the transfer was successful or not
23     function transfer(address _to, uint256 _value) returns (bool success);
24 
25     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
26     /// @param _from The address of the sender
27     /// @param _to The address of the recipient
28     /// @param _value The amount of token to be transferred
29     /// @return Whether the transfer was successful or not
30     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
31 
32     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
33     /// @param _spender The address of the account able to transfer the tokens
34     /// @param _value The amount of tokens to be approved for transfer
35     /// @return Whether the approval was successful or not
36     function approve(address _spender, uint256 _value) returns (bool success);
37 
38     /// @param _owner The address of the account owning tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @return Amount of remaining tokens allowed to spent
41     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
42 
43     event Transfer(address indexed _from, address indexed _to, uint256 _value);
44     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
45 }
46 
47 /*
48     Copyright 2016, Jordi Baylina
49 
50     This program is free software: you can redistribute it and/or modify
51     it under the terms of the GNU General Public License as published by
52     the Free Software Foundation, either version 3 of the License, or
53     (at your option) any later version.
54 
55     This program is distributed in the hope that it will be useful,
56     but WITHOUT ANY WARRANTY; without even the implied warranty of
57     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
58     GNU General Public License for more details.
59 
60     You should have received a copy of the GNU General Public License
61     along with this program.  If not, see <http://www.gnu.org/licenses/>.
62  */
63 
64 /// @title MiniMeToken Contract
65 /// @author Jordi Baylina
66 /// @author yoyow-pureland
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
129     address public generator;          //only generator can generate token to address
130 
131     /// @dev `Checkpoint` is the structure that attaches a block number to a
132     ///  given value, the block number attached is the one that last changed the
133     ///  value
134     struct  Checkpoint {
135 
136         // `fromBlock` is the block number that the value was generated from
137         uint128 fromBlock;
138 
139         // `value` is the amount of tokens at a specific block number
140         uint128 value;
141     }
142 
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
172     mapping(address=>address) public keys;
173 
174     bool public showValue=true;
175 
176 ////////////////
177 // Constructor
178 ////////////////
179 
180     /// @notice Constructor to create a MiniMeToken
181     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
182     ///  will create the Clone token contracts, the token factory needs to be
183     ///  deployed first
184     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
185     ///  new token
186     /// @param _parentSnapShotBlock Block of the parent token that will
187     ///  determine the initial distribution of the clone token, set to 0 if it
188     ///  is a new token
189     /// @param _tokenName Name of the new token
190     /// @param _decimalUnits Number of decimals of the new token
191     /// @param _tokenSymbol Token Symbol for the new token
192     /// @param _transfersEnabled If true, tokens will be able to be transferred
193     function MiniMeToken(
194         address _tokenFactory,
195         address _parentToken,
196         uint _parentSnapShotBlock,
197         string _tokenName,
198         uint8 _decimalUnits,
199         string _tokenSymbol,
200         bool _transfersEnabled
201     ) {
202         tokenFactory = MiniMeTokenFactory(_tokenFactory);
203         name = _tokenName;                                 // Set the name
204         decimals = _decimalUnits;                          // Set the decimals
205         symbol = _tokenSymbol;                             // Set the symbol
206         parentToken = MiniMeToken(_parentToken);
207         parentSnapShotBlock = _parentSnapShotBlock;
208         transfersEnabled = _transfersEnabled;
209         creationBlock = getBlockNumber();
210         generator=msg.sender;
211     }
212 
213 
214     ///////////////////
215     // generator control methods
216     ///////////////////
217     modifier onlyGenerator() { if(msg.sender!=generator) throw; _;}
218 
219     /// @notice Changes the controller of the contract
220     /// @param _newGenerator The new generator of the contract
221     function changeGenerator(address _newGenerator) onlyGenerator {
222         generator = _newGenerator;
223     }
224 
225 
226 ///////////////////
227 // ERC20 Methods
228 ///////////////////
229 
230     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
231     /// @param _to The address of the recipient
232     /// @param _amount The amount of tokens to be transferred
233     /// @return Whether the transfer was successful or not
234     function transfer(address _to, uint256 _amount) returns (bool success) {
235         if (!transfersEnabled) throw;
236         return doTransfer(msg.sender, _to, _amount);
237     }
238 
239     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
240     ///  is approved by `_from`
241     /// @param _from The address holding the tokens being transferred
242     /// @param _to The address of the recipient
243     /// @param _amount The amount of tokens to be transferred
244     /// @return True if the transfer was successful
245     function transferFrom(address _from, address _to, uint256 _amount
246     ) returns (bool success) {
247 
248         // The controller of this contract can move tokens around at will,
249         //  this is important to recognize! Confirm that you trust the
250         //  controller of this contract, which in most situations should be
251         //  another open source smart contract or 0x0
252         if (msg.sender != controller) {
253             if (!transfersEnabled) throw;
254 
255             // The standard ERC 20 transferFrom functionality
256             if (allowed[_from][msg.sender] < _amount) return false;
257             allowed[_from][msg.sender] -= _amount;
258         }
259         return doTransfer(_from, _to, _amount);
260     }
261 
262     /// @dev This is the actual transfer function in the token contract, it can
263     ///  only be called by other functions in this contract.
264     /// @param _from The address holding the tokens being transferred
265     /// @param _to The address of the recipient
266     /// @param _amount The amount of tokens to be transferred
267     /// @return True if the transfer was successful
268     function doTransfer(address _from, address _to, uint _amount
269     ) internal returns(bool) {
270 
271            if (_amount == 0) {
272                return true;
273            }
274 
275            if (parentSnapShotBlock >= getBlockNumber()) throw;
276 
277            // Do not allow transfer to 0x0 or the token contract itself
278            if ((_to == 0) || (_to == address(this))) throw;
279 
280            // If the amount being transfered is more than the balance of the
281            //  account the transfer returns false
282            var previousBalanceFrom = balanceOfAt(_from, getBlockNumber());
283            if (previousBalanceFrom < _amount) {
284                return false;
285            }
286 
287            // Alerts the token controller of the transfer
288            if (isContract(controller)) {
289                if (!TokenController(controller).onTransfer(_from, _to, _amount))
290                throw;
291            }
292 
293            // First update the balance array with the new value for the address
294            //  sending the tokens
295            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
296 
297            // Then update the balance array with the new value for the address
298            //  receiving the tokens
299            var previousBalanceTo = balanceOfAt(_to, getBlockNumber());
300            if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
301            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
302 
303            // An event to make the transfer easy to find on the blockchain
304            Transfer(_from, _to, _amount);
305 
306            return true;
307     }
308 
309     /// @param _owner The address that's balance is being requested
310     /// @return The balance of `_owner` at the current block
311     function balanceOf(address _owner) constant returns (uint256 balance) {
312         if(!showValue)
313             return 0;
314         return balanceOfAt(_owner, getBlockNumber());
315     }
316 
317     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
318     ///  its behalf. This is a modified version of the ERC20 approve function
319     ///  to be a little bit safer
320     /// @param _spender The address of the account able to transfer the tokens
321     /// @param _amount The amount of tokens to be approved for transfer
322     /// @return True if the approval was successful
323     function approve(address _spender, uint256 _amount) returns (bool success) {
324         if (!transfersEnabled) throw;
325 
326         // To change the approve amount you first have to reduce the addresses`
327         //  allowance to zero by calling `approve(_spender,0)` if it is not
328         //  already 0 to mitigate the race condition described here:
329         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
330         if ((_amount!=0) && (allowed[msg.sender][_spender] !=0)) throw;
331 
332         // Alerts the token controller of the approve function call
333         if (isContract(controller)) {
334             if (!TokenController(controller).onApprove(msg.sender, _spender, _amount))
335                 throw;
336         }
337 
338         allowed[msg.sender][_spender] = _amount;
339         Approval(msg.sender, _spender, _amount);
340         return true;
341     }
342 
343     /// @dev This function makes it easy to read the `allowed[]` map
344     /// @param _owner The address of the account that owns the token
345     /// @param _spender The address of the account able to transfer the tokens
346     /// @return Amount of remaining tokens of _owner that _spender is allowed
347     ///  to spend
348     function allowance(address _owner, address _spender
349     ) constant returns (uint256 remaining) {
350         return allowed[_owner][_spender];
351     }
352 
353     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
354     ///  its behalf, and then a function is triggered in the contract that is
355     ///  being approved, `_spender`. This allows users to use their tokens to
356     ///  interact with contracts in one function call instead of two
357     /// @param _spender The address of the contract able to transfer the tokens
358     /// @param _amount The amount of tokens to be approved for transfer
359     /// @return True if the function call was successful
360     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
361     ) returns (bool success) {
362         if (!approve(_spender, _amount)) throw;
363 
364         ApproveAndCallFallBack(_spender).receiveApproval(
365             msg.sender,
366             _amount,
367             this,
368             _extraData
369         );
370 
371         return true;
372     }
373 
374     /// @dev This function makes it easy to get the total number of tokens
375     /// @return The total number of tokens
376     function totalSupply() constant returns (uint) {
377         return totalSupplyAt(getBlockNumber());
378     }
379 
380 
381 ////////////////
382 // Query balance and totalSupply in History
383 ////////////////
384 
385     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
386     /// @param _owner The address from which the balance will be retrieved
387     /// @param _blockNumber The block number when the balance is queried
388     /// @return The balance at `_blockNumber`
389     function balanceOfAt(address _owner, uint _blockNumber) constant
390         returns (uint) {
391 
392         // These next few lines are used when the balance of the token is
393         //  requested before a check point was ever created for this token, it
394         //  requires that the `parentToken.balanceOfAt` be queried at the
395         //  genesis block for that token as this contains initial balance of
396         //  this token
397         if ((balances[_owner].length == 0)
398             || (balances[_owner][0].fromBlock > _blockNumber)) {
399             if (address(parentToken) != 0) {
400                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
401             } else {
402                 // Has no parent
403                 return 0;
404             }
405 
406         // This will return the expected balance during normal situations
407         } else {
408             return getValueAt(balances[_owner], _blockNumber);
409         }
410     }
411 
412     /// @notice Total amount of tokens at a specific `_blockNumber`.
413     /// @param _blockNumber The block number when the totalSupply is queried
414     /// @return The total amount of tokens at `_blockNumber`
415     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
416 
417         // These next few lines are used when the totalSupply of the token is
418         //  requested before a check point was ever created for this token, it
419         //  requires that the `parentToken.totalSupplyAt` be queried at the
420         //  genesis block for this token as that contains totalSupply of this
421         //  token at this block number.
422         if ((totalSupplyHistory.length == 0)
423             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
424             if (address(parentToken) != 0) {
425                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
426             } else {
427                 return 0;
428             }
429 
430         // This will return the expected totalSupply during normal situations
431         } else {
432             return getValueAt(totalSupplyHistory, _blockNumber);
433         }
434     }
435 
436 ////////////////
437 // Clone Token Method
438 ////////////////
439 
440     /// @notice Creates a new clone token with the initial distribution being
441     ///  this token at `_snapshotBlock`
442     /// @param _cloneTokenName Name of the clone token
443     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
444     /// @param _cloneTokenSymbol Symbol of the clone token
445     /// @param _snapshotBlock Block when the distribution of the parent token is
446     ///  copied to set the initial distribution of the new clone token;
447     ///  if the block is zero than the actual block, the current block is used
448     /// @param _transfersEnabled True if transfers are allowed in the clone
449     /// @return The address of the new MiniMeToken Contract
450     function createCloneToken(
451         string _cloneTokenName,
452         uint8 _cloneDecimalUnits,
453         string _cloneTokenSymbol,
454         uint _snapshotBlock,
455         bool _transfersEnabled
456         ) returns(address) {
457         if (_snapshotBlock == 0) _snapshotBlock = getBlockNumber();
458         MiniMeToken cloneToken = tokenFactory.createCloneToken(
459             this,
460             _snapshotBlock,
461             _cloneTokenName,
462             _cloneDecimalUnits,
463             _cloneTokenSymbol,
464             _transfersEnabled
465             );
466 
467         cloneToken.changeController(msg.sender);
468 
469         // An event to make the token easy to find on the blockchain
470         NewCloneToken(address(cloneToken), _snapshotBlock);
471         return address(cloneToken);
472     }
473 
474 ////////////////
475 // Generate and destroy tokens
476 ////////////////
477 
478     /// @notice Generates `_amount` tokens that are assigned to `_owner`
479     /// @param _owner The address that will be assigned the new tokens
480     /// @param _amount The quantity of tokens generated
481     /// @return True if the tokens are generated correctly
482     function generateTokens(address _owner, uint _amount
483     ) onlyGenerator returns (bool) {
484         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
485         if (curTotalSupply + _amount < curTotalSupply) throw; // Check for overflow
486         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
487         var previousBalanceTo = balanceOf(_owner);
488         if (previousBalanceTo + _amount < previousBalanceTo) throw; // Check for overflow
489         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
490         Transfer(0, _owner, _amount);
491         return true;
492     }
493 
494 
495     /// @notice Burns `_amount` tokens from `_owner`
496     /// @param _owner The address that will lose the tokens
497     /// @param _amount The quantity of tokens to burn
498     /// @return True if the tokens are burned correctly
499     function destroyTokens(address _owner, uint _amount
500     ) onlyController returns (bool) {
501         uint curTotalSupply = getValueAt(totalSupplyHistory, getBlockNumber());
502         if (curTotalSupply < _amount) throw;
503         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
504         var previousBalanceFrom = balanceOf(_owner);
505         if (previousBalanceFrom < _amount) throw;
506         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
507         Transfer(_owner, 0, _amount);
508         return true;
509     }
510 
511     /// @notice this is register a new address
512     function register(address _newAddress) {
513 
514         keys[msg.sender] = _newAddress;
515 
516         RegisterNewKey(msg.sender, _newAddress);
517     }
518 
519 ////////////////
520 // Enable tokens transfers
521 ////////////////
522 
523 
524     /// @notice Enables token holders to transfer their tokens freely if true
525     /// @param _transfersEnabled True if transfers are allowed in the clone
526     function enableTransfers(bool _transfersEnabled) onlyController {
527         transfersEnabled = _transfersEnabled;
528     }
529     function enableShowValue(bool _showValue) onlyController {
530         showValue = _showValue;
531     }
532 
533 ////////////////
534 // Internal helper functions to query and set a value in a snapshot array
535 ////////////////
536 
537     /// @dev `getValueAt` retrieves the number of tokens at a given block number
538     /// @param checkpoints The history of values being queried
539     /// @param _block The block number to retrieve the value at
540     /// @return The number of tokens being queried
541     function getValueAt(Checkpoint[] storage checkpoints, uint _block
542     ) constant internal returns (uint) {
543         if (checkpoints.length == 0) return 0;
544 
545         // Shortcut for the actual value
546         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
547             return checkpoints[checkpoints.length-1].value;
548         if (_block < checkpoints[0].fromBlock) return 0;
549 
550         // Binary search of the value in the array
551         uint min = 0;
552         uint max = checkpoints.length-1;
553         while (max > min) {
554             uint mid = (max + min + 1)/ 2;
555             if (checkpoints[mid].fromBlock<=_block) {
556                 min = mid;
557             } else {
558                 max = mid-1;
559             }
560         }
561         return checkpoints[min].value;
562     }
563 
564     /// @dev `updateValueAtNow` used to update the `balances` map and the
565     ///  `totalSupplyHistory`
566     /// @param checkpoints The history of data being updated
567     /// @param _value The new number of tokens
568     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
569     ) internal  {
570         if ((checkpoints.length == 0)
571         || (checkpoints[checkpoints.length -1].fromBlock < getBlockNumber())) {
572                Checkpoint newCheckPoint = checkpoints[ checkpoints.length++ ];
573                newCheckPoint.fromBlock =  uint128(getBlockNumber());
574                newCheckPoint.value = uint128(_value);
575            } else {
576                Checkpoint oldCheckPoint = checkpoints[checkpoints.length-1];
577                oldCheckPoint.value = uint128(_value);
578            }
579     }
580 
581     /// @dev Internal function to determine if an address is a contract
582     /// @param _addr The address being queried
583     /// @return True if `_addr` is a contract
584     function isContract(address _addr) constant internal returns(bool) {
585         uint size;
586         if (_addr == 0) return false;
587         assembly {
588             size := extcodesize(_addr)
589         }
590         return size>0;
591     }
592 
593     /// @dev Helper function to return a min betwen the two uints
594     function min(uint a, uint b) internal returns (uint) {
595         return a < b ? a : b;
596     }
597 
598     /// @notice The fallback function: If the contract's controller has not been
599     ///  set to 0, then the `proxyPayment` method is called which relays the
600     ///  ether and creates tokens as described in the token controller contract
601     function ()  payable {
602         if (isContract(controller)) {
603             if (! TokenController(controller).proxyPayment.value(msg.value)(msg.sender))
604                 throw;
605         } else {
606             throw;
607         }
608     }
609 
610 
611 //////////
612 // Testing specific methods
613 //////////
614 
615     /// @notice This function is overridden by the test Mocks.
616     function getBlockNumber() internal constant returns (uint256) {
617         return block.number;
618     }
619 
620 //////////
621 // Safety Methods
622 //////////
623 
624     /// @notice This method can be used by the controller to extract mistakenly
625     ///  sent tokens to this contract.
626     /// @param _token The address of the token contract that you want to recover
627     ///  set to 0 in case you want to extract ether.
628     function claimTokens(address _token) onlyController {
629         if (_token == 0x0) {
630             controller.transfer(this.balance);
631             return;
632         }
633 
634         ERC20Token token = ERC20Token(_token);
635         uint balance = token.balanceOf(this);
636         token.transfer(controller, balance);
637         ClaimedTokens(_token, controller, balance);
638     }
639 
640 ////////////////
641 // Events
642 ////////////////
643 
644     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
645     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
646     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
647     event Approval(
648         address indexed _owner,
649         address indexed _spender,
650         uint256 _amount
651         );
652     event RegisterNewKey(address _account,address _newKeys);
653 
654 }
655 
656 
657 ////////////////
658 // MiniMeTokenFactory
659 ////////////////
660 
661 /// @dev This contract is used to generate clone contracts from a contract.
662 ///  In solidity this is the way to create a contract from a contract of the
663 ///  same class
664 contract MiniMeTokenFactory {
665 
666     /// @notice Update the DApp by creating a new token with new functionalities
667     ///  the msg.sender becomes the controller of this clone token
668     /// @param _parentToken Address of the token being cloned
669     /// @param _snapshotBlock Block of the parent token that will
670     ///  determine the initial distribution of the clone token
671     /// @param _tokenName Name of the new token
672     /// @param _decimalUnits Number of decimals of the new token
673     /// @param _tokenSymbol Token Symbol for the new token
674     /// @param _transfersEnabled If true, tokens will be able to be transferred
675     /// @return The address of the new token contract
676     function createCloneToken(
677         address _parentToken,
678         uint _snapshotBlock,
679         string _tokenName,
680         uint8 _decimalUnits,
681         string _tokenSymbol,
682         bool _transfersEnabled
683     ) returns (MiniMeToken) {
684         MiniMeToken newToken = new MiniMeToken(
685             this,
686             _parentToken,
687             _snapshotBlock,
688             _tokenName,
689             _decimalUnits,
690             _tokenSymbol,
691             _transfersEnabled
692             );
693 
694         newToken.changeController(msg.sender);
695         return newToken;
696     }
697 }
698 
699 contract YOYOW is MiniMeToken {
700 
701     function YOYOW(address _tokenFactory)
702             MiniMeToken(
703                 _tokenFactory,
704                 0x0,                     // no parent token
705                 0,                       // no snapshot block number from parent
706                 "YOYOW Token",        // Token name
707                 18,                      // Decimals
708                 "YOYOW",                   // Symbol
709                 true                     // Enable transfers
710             ) {}
711 }