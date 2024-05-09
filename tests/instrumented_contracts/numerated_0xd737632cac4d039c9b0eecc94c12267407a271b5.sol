1 // File: @aragon/apps-shared-minime/contracts/ITokenController.sol
2 
3 pragma solidity ^0.4.24;
4 
5 /// @dev The token controller contract must implement these functions
6 
7 
8 interface ITokenController {
9     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
10     /// @param _owner The address that sent the ether to create tokens
11     /// @return True if the ether is accepted, false if it throws
12     function proxyPayment(address _owner) external payable returns(bool);
13 
14     /// @notice Notifies the controller about a token transfer allowing the
15     ///  controller to react if desired
16     /// @param _from The origin of the transfer
17     /// @param _to The destination of the transfer
18     /// @param _amount The amount of the transfer
19     /// @return False if the controller does not authorize the transfer
20     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
21 
22     /// @notice Notifies the controller about an approval allowing the
23     ///  controller to react if desired
24     /// @param _owner The address that calls `approve()`
25     /// @param _spender The spender in the `approve()` call
26     /// @param _amount The amount in the `approve()` call
27     /// @return False if the controller does not authorize the approval
28     function onApprove(address _owner, address _spender, uint _amount) external returns(bool);
29 }
30 
31 // File: @aragon/apps-shared-minime/contracts/MiniMeToken.sol
32 
33 pragma solidity ^0.4.24;
34 
35 /*
36     Copyright 2016, Jordi Baylina
37     This program is free software: you can redistribute it and/or modify
38     it under the terms of the GNU General Public License as published by
39     the Free Software Foundation, either version 3 of the License, or
40     (at your option) any later version.
41     This program is distributed in the hope that it will be useful,
42     but WITHOUT ANY WARRANTY; without even the implied warranty of
43     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
44     GNU General Public License for more details.
45     You should have received a copy of the GNU General Public License
46     along with this program.  If not, see <http://www.gnu.org/licenses/>.
47  */
48 
49 /// @title MiniMeToken Contract
50 /// @author Jordi Baylina
51 /// @dev This token contract's goal is to make it easy for anyone to clone this
52 ///  token using the token distribution at a given block, this will allow DAO's
53 ///  and DApps to upgrade their features in a decentralized manner without
54 ///  affecting the original token
55 /// @dev It is ERC20 compliant, but still needs to under go further testing.
56 
57 
58 contract Controlled {
59     /// @notice The address of the controller is the only address that can call
60     ///  a function with this modifier
61     modifier onlyController {
62         require(msg.sender == controller);
63         _;
64     }
65 
66     address public controller;
67 
68     function Controlled()  public { controller = msg.sender;}
69 
70     /// @notice Changes the controller of the contract
71     /// @param _newController The new controller of the contract
72     function changeController(address _newController) onlyController  public {
73         controller = _newController;
74     }
75 }
76 
77 contract ApproveAndCallFallBack {
78     function receiveApproval(
79         address from,
80         uint256 _amount,
81         address _token,
82         bytes _data
83     ) public;
84 }
85 
86 /// @dev The actual token contract, the default controller is the msg.sender
87 ///  that deploys the contract, so usually this token will be deployed by a
88 ///  token controller contract, which Giveth will call a "Campaign"
89 contract MiniMeToken is Controlled {
90 
91     string public name;                //The Token's name: e.g. DigixDAO Tokens
92     uint8 public decimals;             //Number of decimals of the smallest unit
93     string public symbol;              //An identifier: e.g. REP
94     string public version = "MMT_0.1"; //An arbitrary versioning scheme
95 
96 
97     /// @dev `Checkpoint` is the structure that attaches a block number to a
98     ///  given value, the block number attached is the one that last changed the
99     ///  value
100     struct Checkpoint {
101 
102         // `fromBlock` is the block number that the value was generated from
103         uint128 fromBlock;
104 
105         // `value` is the amount of tokens at a specific block number
106         uint128 value;
107     }
108 
109     // `parentToken` is the Token address that was cloned to produce this token;
110     //  it will be 0x0 for a token that was not cloned
111     MiniMeToken public parentToken;
112 
113     // `parentSnapShotBlock` is the block number from the Parent Token that was
114     //  used to determine the initial distribution of the Clone Token
115     uint public parentSnapShotBlock;
116 
117     // `creationBlock` is the block number that the Clone Token was created
118     uint public creationBlock;
119 
120     // `balances` is the map that tracks the balance of each address, in this
121     //  contract when the balance changes the block number that the change
122     //  occurred is also included in the map
123     mapping (address => Checkpoint[]) balances;
124 
125     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
126     mapping (address => mapping (address => uint256)) allowed;
127 
128     // Tracks the history of the `totalSupply` of the token
129     Checkpoint[] totalSupplyHistory;
130 
131     // Flag that determines if the token is transferable or not.
132     bool public transfersEnabled;
133 
134     // The factory used to create new clone tokens
135     MiniMeTokenFactory public tokenFactory;
136 
137 ////////////////
138 // Constructor
139 ////////////////
140 
141     /// @notice Constructor to create a MiniMeToken
142     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
143     ///  will create the Clone token contracts, the token factory needs to be
144     ///  deployed first
145     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
146     ///  new token
147     /// @param _parentSnapShotBlock Block of the parent token that will
148     ///  determine the initial distribution of the clone token, set to 0 if it
149     ///  is a new token
150     /// @param _tokenName Name of the new token
151     /// @param _decimalUnits Number of decimals of the new token
152     /// @param _tokenSymbol Token Symbol for the new token
153     /// @param _transfersEnabled If true, tokens will be able to be transferred
154     function MiniMeToken(
155         MiniMeTokenFactory _tokenFactory,
156         MiniMeToken _parentToken,
157         uint _parentSnapShotBlock,
158         string _tokenName,
159         uint8 _decimalUnits,
160         string _tokenSymbol,
161         bool _transfersEnabled
162     )  public
163     {
164         tokenFactory = _tokenFactory;
165         name = _tokenName;                                 // Set the name
166         decimals = _decimalUnits;                          // Set the decimals
167         symbol = _tokenSymbol;                             // Set the symbol
168         parentToken = _parentToken;
169         parentSnapShotBlock = _parentSnapShotBlock;
170         transfersEnabled = _transfersEnabled;
171         creationBlock = block.number;
172     }
173 
174 
175 ///////////////////
176 // ERC20 Methods
177 ///////////////////
178 
179     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
180     /// @param _to The address of the recipient
181     /// @param _amount The amount of tokens to be transferred
182     /// @return Whether the transfer was successful or not
183     function transfer(address _to, uint256 _amount) public returns (bool success) {
184         require(transfersEnabled);
185         return doTransfer(msg.sender, _to, _amount);
186     }
187 
188     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
189     ///  is approved by `_from`
190     /// @param _from The address holding the tokens being transferred
191     /// @param _to The address of the recipient
192     /// @param _amount The amount of tokens to be transferred
193     /// @return True if the transfer was successful
194     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
195 
196         // The controller of this contract can move tokens around at will,
197         //  this is important to recognize! Confirm that you trust the
198         //  controller of this contract, which in most situations should be
199         //  another open source smart contract or 0x0
200         if (msg.sender != controller) {
201             require(transfersEnabled);
202 
203             // The standard ERC 20 transferFrom functionality
204             if (allowed[_from][msg.sender] < _amount)
205                 return false;
206             allowed[_from][msg.sender] -= _amount;
207         }
208         return doTransfer(_from, _to, _amount);
209     }
210 
211     /// @dev This is the actual transfer function in the token contract, it can
212     ///  only be called by other functions in this contract.
213     /// @param _from The address holding the tokens being transferred
214     /// @param _to The address of the recipient
215     /// @param _amount The amount of tokens to be transferred
216     /// @return True if the transfer was successful
217     function doTransfer(address _from, address _to, uint _amount) internal returns(bool) {
218         if (_amount == 0) {
219             return true;
220         }
221         require(parentSnapShotBlock < block.number);
222         // Do not allow transfer to 0x0 or the token contract itself
223         require((_to != 0) && (_to != address(this)));
224         // If the amount being transfered is more than the balance of the
225         //  account the transfer returns false
226         var previousBalanceFrom = balanceOfAt(_from, block.number);
227         if (previousBalanceFrom < _amount) {
228             return false;
229         }
230         // Alerts the token controller of the transfer
231         if (isContract(controller)) {
232             // Adding the ` == true` makes the linter shut up so...
233             require(ITokenController(controller).onTransfer(_from, _to, _amount) == true);
234         }
235         // First update the balance array with the new value for the address
236         //  sending the tokens
237         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
238         // Then update the balance array with the new value for the address
239         //  receiving the tokens
240         var previousBalanceTo = balanceOfAt(_to, block.number);
241         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
242         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
243         // An event to make the transfer easy to find on the blockchain
244         Transfer(_from, _to, _amount);
245         return true;
246     }
247 
248     /// @param _owner The address that's balance is being requested
249     /// @return The balance of `_owner` at the current block
250     function balanceOf(address _owner) public constant returns (uint256 balance) {
251         return balanceOfAt(_owner, block.number);
252     }
253 
254     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
255     ///  its behalf. This is a modified version of the ERC20 approve function
256     ///  to be a little bit safer
257     /// @param _spender The address of the account able to transfer the tokens
258     /// @param _amount The amount of tokens to be approved for transfer
259     /// @return True if the approval was successful
260     function approve(address _spender, uint256 _amount) public returns (bool success) {
261         require(transfersEnabled);
262 
263         // To change the approve amount you first have to reduce the addresses`
264         //  allowance to zero by calling `approve(_spender,0)` if it is not
265         //  already 0 to mitigate the race condition described here:
266         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
268 
269         // Alerts the token controller of the approve function call
270         if (isContract(controller)) {
271             // Adding the ` == true` makes the linter shut up so...
272             require(ITokenController(controller).onApprove(msg.sender, _spender, _amount) == true);
273         }
274 
275         allowed[msg.sender][_spender] = _amount;
276         Approval(msg.sender, _spender, _amount);
277         return true;
278     }
279 
280     /// @dev This function makes it easy to read the `allowed[]` map
281     /// @param _owner The address of the account that owns the token
282     /// @param _spender The address of the account able to transfer the tokens
283     /// @return Amount of remaining tokens of _owner that _spender is allowed
284     ///  to spend
285     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
286         return allowed[_owner][_spender];
287     }
288 
289     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
290     ///  its behalf, and then a function is triggered in the contract that is
291     ///  being approved, `_spender`. This allows users to use their tokens to
292     ///  interact with contracts in one function call instead of two
293     /// @param _spender The address of the contract able to transfer the tokens
294     /// @param _amount The amount of tokens to be approved for transfer
295     /// @return True if the function call was successful
296     function approveAndCall(ApproveAndCallFallBack _spender, uint256 _amount, bytes _extraData) public returns (bool success) {
297         require(approve(_spender, _amount));
298 
299         _spender.receiveApproval(
300             msg.sender,
301             _amount,
302             this,
303             _extraData
304         );
305 
306         return true;
307     }
308 
309     /// @dev This function makes it easy to get the total number of tokens
310     /// @return The total number of tokens
311     function totalSupply() public constant returns (uint) {
312         return totalSupplyAt(block.number);
313     }
314 
315 
316 ////////////////
317 // Query balance and totalSupply in History
318 ////////////////
319 
320     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
321     /// @param _owner The address from which the balance will be retrieved
322     /// @param _blockNumber The block number when the balance is queried
323     /// @return The balance at `_blockNumber`
324     function balanceOfAt(address _owner, uint _blockNumber) public constant returns (uint) {
325 
326         // These next few lines are used when the balance of the token is
327         //  requested before a check point was ever created for this token, it
328         //  requires that the `parentToken.balanceOfAt` be queried at the
329         //  genesis block for that token as this contains initial balance of
330         //  this token
331         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
332             if (address(parentToken) != 0) {
333                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
334             } else {
335                 // Has no parent
336                 return 0;
337             }
338 
339         // This will return the expected balance during normal situations
340         } else {
341             return getValueAt(balances[_owner], _blockNumber);
342         }
343     }
344 
345     /// @notice Total amount of tokens at a specific `_blockNumber`.
346     /// @param _blockNumber The block number when the totalSupply is queried
347     /// @return The total amount of tokens at `_blockNumber`
348     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
349 
350         // These next few lines are used when the totalSupply of the token is
351         //  requested before a check point was ever created for this token, it
352         //  requires that the `parentToken.totalSupplyAt` be queried at the
353         //  genesis block for this token as that contains totalSupply of this
354         //  token at this block number.
355         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
356             if (address(parentToken) != 0) {
357                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
358             } else {
359                 return 0;
360             }
361 
362         // This will return the expected totalSupply during normal situations
363         } else {
364             return getValueAt(totalSupplyHistory, _blockNumber);
365         }
366     }
367 
368 ////////////////
369 // Clone Token Method
370 ////////////////
371 
372     /// @notice Creates a new clone token with the initial distribution being
373     ///  this token at `_snapshotBlock`
374     /// @param _cloneTokenName Name of the clone token
375     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
376     /// @param _cloneTokenSymbol Symbol of the clone token
377     /// @param _snapshotBlock Block when the distribution of the parent token is
378     ///  copied to set the initial distribution of the new clone token;
379     ///  if the block is zero than the actual block, the current block is used
380     /// @param _transfersEnabled True if transfers are allowed in the clone
381     /// @return The address of the new MiniMeToken Contract
382     function createCloneToken(
383         string _cloneTokenName,
384         uint8 _cloneDecimalUnits,
385         string _cloneTokenSymbol,
386         uint _snapshotBlock,
387         bool _transfersEnabled
388     ) public returns(MiniMeToken)
389     {
390         uint256 snapshot = _snapshotBlock == 0 ? block.number - 1 : _snapshotBlock;
391 
392         MiniMeToken cloneToken = tokenFactory.createCloneToken(
393             this,
394             snapshot,
395             _cloneTokenName,
396             _cloneDecimalUnits,
397             _cloneTokenSymbol,
398             _transfersEnabled
399         );
400 
401         cloneToken.changeController(msg.sender);
402 
403         // An event to make the token easy to find on the blockchain
404         NewCloneToken(address(cloneToken), snapshot);
405         return cloneToken;
406     }
407 
408 ////////////////
409 // Generate and destroy tokens
410 ////////////////
411 
412     /// @notice Generates `_amount` tokens that are assigned to `_owner`
413     /// @param _owner The address that will be assigned the new tokens
414     /// @param _amount The quantity of tokens generated
415     /// @return True if the tokens are generated correctly
416     function generateTokens(address _owner, uint _amount) onlyController public returns (bool) {
417         uint curTotalSupply = totalSupply();
418         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
419         uint previousBalanceTo = balanceOf(_owner);
420         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
421         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
422         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
423         Transfer(0, _owner, _amount);
424         return true;
425     }
426 
427 
428     /// @notice Burns `_amount` tokens from `_owner`
429     /// @param _owner The address that will lose the tokens
430     /// @param _amount The quantity of tokens to burn
431     /// @return True if the tokens are burned correctly
432     function destroyTokens(address _owner, uint _amount) onlyController public returns (bool) {
433         uint curTotalSupply = totalSupply();
434         require(curTotalSupply >= _amount);
435         uint previousBalanceFrom = balanceOf(_owner);
436         require(previousBalanceFrom >= _amount);
437         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
438         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
439         Transfer(_owner, 0, _amount);
440         return true;
441     }
442 
443 ////////////////
444 // Enable tokens transfers
445 ////////////////
446 
447 
448     /// @notice Enables token holders to transfer their tokens freely if true
449     /// @param _transfersEnabled True if transfers are allowed in the clone
450     function enableTransfers(bool _transfersEnabled) onlyController public {
451         transfersEnabled = _transfersEnabled;
452     }
453 
454 ////////////////
455 // Internal helper functions to query and set a value in a snapshot array
456 ////////////////
457 
458     /// @dev `getValueAt` retrieves the number of tokens at a given block number
459     /// @param checkpoints The history of values being queried
460     /// @param _block The block number to retrieve the value at
461     /// @return The number of tokens being queried
462     function getValueAt(Checkpoint[] storage checkpoints, uint _block) constant internal returns (uint) {
463         if (checkpoints.length == 0)
464             return 0;
465 
466         // Shortcut for the actual value
467         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
468             return checkpoints[checkpoints.length-1].value;
469         if (_block < checkpoints[0].fromBlock)
470             return 0;
471 
472         // Binary search of the value in the array
473         uint min = 0;
474         uint max = checkpoints.length-1;
475         while (max > min) {
476             uint mid = (max + min + 1) / 2;
477             if (checkpoints[mid].fromBlock<=_block) {
478                 min = mid;
479             } else {
480                 max = mid-1;
481             }
482         }
483         return checkpoints[min].value;
484     }
485 
486     /// @dev `updateValueAtNow` used to update the `balances` map and the
487     ///  `totalSupplyHistory`
488     /// @param checkpoints The history of data being updated
489     /// @param _value The new number of tokens
490     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
491         if ((checkpoints.length == 0) || (checkpoints[checkpoints.length - 1].fromBlock < block.number)) {
492             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
493             newCheckPoint.fromBlock = uint128(block.number);
494             newCheckPoint.value = uint128(_value);
495         } else {
496             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length - 1];
497             oldCheckPoint.value = uint128(_value);
498         }
499     }
500 
501     /// @dev Internal function to determine if an address is a contract
502     /// @param _addr The address being queried
503     /// @return True if `_addr` is a contract
504     function isContract(address _addr) constant internal returns(bool) {
505         uint size;
506         if (_addr == 0)
507             return false;
508 
509         assembly {
510             size := extcodesize(_addr)
511         }
512 
513         return size>0;
514     }
515 
516     /// @dev Helper function to return a min betwen the two uints
517     function min(uint a, uint b) pure internal returns (uint) {
518         return a < b ? a : b;
519     }
520 
521     /// @notice The fallback function: If the contract's controller has not been
522     ///  set to 0, then the `proxyPayment` method is called which relays the
523     ///  ether and creates tokens as described in the token controller contract
524     function () external payable {
525         require(isContract(controller));
526         // Adding the ` == true` makes the linter shut up so...
527         require(ITokenController(controller).proxyPayment.value(msg.value)(msg.sender) == true);
528     }
529 
530 //////////
531 // Safety Methods
532 //////////
533 
534     /// @notice This method can be used by the controller to extract mistakenly
535     ///  sent tokens to this contract.
536     /// @param _token The address of the token contract that you want to recover
537     ///  set to 0 in case you want to extract ether.
538     function claimTokens(address _token) onlyController public {
539         if (_token == 0x0) {
540             controller.transfer(this.balance);
541             return;
542         }
543 
544         MiniMeToken token = MiniMeToken(_token);
545         uint balance = token.balanceOf(this);
546         token.transfer(controller, balance);
547         ClaimedTokens(_token, controller, balance);
548     }
549 
550 ////////////////
551 // Events
552 ////////////////
553     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
554     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
555     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
556     event Approval(
557         address indexed _owner,
558         address indexed _spender,
559         uint256 _amount
560         );
561 
562 }
563 
564 
565 ////////////////
566 // MiniMeTokenFactory
567 ////////////////
568 
569 /// @dev This contract is used to generate clone contracts from a contract.
570 ///  In solidity this is the way to create a contract from a contract of the
571 ///  same class
572 contract MiniMeTokenFactory {
573 
574     /// @notice Update the DApp by creating a new token with new functionalities
575     ///  the msg.sender becomes the controller of this clone token
576     /// @param _parentToken Address of the token being cloned
577     /// @param _snapshotBlock Block of the parent token that will
578     ///  determine the initial distribution of the clone token
579     /// @param _tokenName Name of the new token
580     /// @param _decimalUnits Number of decimals of the new token
581     /// @param _tokenSymbol Token Symbol for the new token
582     /// @param _transfersEnabled If true, tokens will be able to be transferred
583     /// @return The address of the new token contract
584     function createCloneToken(
585         MiniMeToken _parentToken,
586         uint _snapshotBlock,
587         string _tokenName,
588         uint8 _decimalUnits,
589         string _tokenSymbol,
590         bool _transfersEnabled
591     ) public returns (MiniMeToken)
592     {
593         MiniMeToken newToken = new MiniMeToken(
594             this,
595             _parentToken,
596             _snapshotBlock,
597             _tokenName,
598             _decimalUnits,
599             _tokenSymbol,
600             _transfersEnabled
601         );
602 
603         newToken.changeController(msg.sender);
604         return newToken;
605     }
606 }
607 
608 // File: @aragon/templates-shared/contracts/TokenCache.sol
609 
610 pragma solidity 0.4.24;
611 
612 
613 
614 contract TokenCache {
615     string constant private ERROR_MISSING_TOKEN_CACHE = "TEMPLATE_MISSING_TOKEN_CACHE";
616 
617     mapping (address => address) internal tokenCache;
618 
619     function _cacheToken(MiniMeToken _token, address _owner) internal {
620         tokenCache[_owner] = _token;
621     }
622 
623     function _popTokenCache(address _owner) internal returns (MiniMeToken) {
624         require(tokenCache[_owner] != address(0), ERROR_MISSING_TOKEN_CACHE);
625 
626         MiniMeToken token = MiniMeToken(tokenCache[_owner]);
627         delete tokenCache[_owner];
628         return token;
629     }
630 }
631 
632 // File: @aragon/apps-agent/contracts/standards/ERC1271.sol
633 
634 pragma solidity 0.4.24;
635 
636 // ERC1271 on Feb 12th, 2019: https://github.com/ethereum/EIPs/blob/a97dc434930d0ccc4461c97d8c7a920dc585adf2/EIPS/eip-1271.md
637 // Using `isValidSignature(bytes32,bytes)` even though the standard still hasn't been modified
638 // Rationale: https://github.com/ethereum/EIPs/issues/1271#issuecomment-462719728
639 
640 
641 contract ERC1271 {
642     bytes4 constant public ERC1271_INTERFACE_ID = 0xfb855dc9; // this.isValidSignature.selector
643 
644     bytes4 constant public ERC1271_RETURN_VALID_SIGNATURE =   0x20c13b0b; // TODO: Likely needs to be updated
645     bytes4 constant public ERC1271_RETURN_INVALID_SIGNATURE = 0x00000000;
646 
647     /**
648     * @dev Function must be implemented by deriving contract
649     * @param _hash Arbitrary length data signed on the behalf of address(this)
650     * @param _signature Signature byte array associated with _data
651     * @return A bytes4 magic value 0x20c13b0b if the signature check passes, 0x00000000 if not
652     *
653     * MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
654     * MUST allow external calls
655     */
656     function isValidSignature(bytes32 _hash, bytes memory _signature) public view returns (bytes4);
657 
658     function returnIsValidSignatureMagicNumber(bool isValid) internal pure returns (bytes4) {
659         return isValid ? ERC1271_RETURN_VALID_SIGNATURE : ERC1271_RETURN_INVALID_SIGNATURE;
660     }
661 }
662 
663 
664 contract ERC1271Bytes is ERC1271 {
665     /**
666     * @dev Default behavior of `isValidSignature(bytes,bytes)`, can be overloaded for custom validation
667     * @param _data Arbitrary length data signed on the behalf of address(this)
668     * @param _signature Signature byte array associated with _data
669     * @return A bytes4 magic value 0x20c13b0b if the signature check passes, 0x00000000 if not
670     *
671     * MUST NOT modify state (using STATICCALL for solc < 0.5, view modifier for solc > 0.5)
672     * MUST allow external calls
673     */
674     function isValidSignature(bytes _data, bytes _signature) public view returns (bytes4) {
675         return isValidSignature(keccak256(_data), _signature);
676     }
677 }
678 
679 // File: @aragon/apps-agent/contracts/SignatureValidator.sol
680 
681 pragma solidity 0.4.24;
682 
683 // Inspired by https://github.com/horizon-games/multi-token-standard/blob/319740cf2a78b8816269ae49a09c537b3fd7303b/contracts/utils/SignatureValidator.sol
684 // This should probably be moved into aOS: https://github.com/aragon/aragonOS/pull/442
685 
686 
687 
688 library SignatureValidator {
689     enum SignatureMode {
690         Invalid, // 0x00
691         EIP712,  // 0x01
692         EthSign, // 0x02
693         ERC1271, // 0x03
694         NMode    // 0x04, to check if mode is specified, leave at the end
695     }
696 
697     // bytes4(keccak256("isValidSignature(bytes,bytes)")
698     bytes4 public constant ERC1271_RETURN_VALID_SIGNATURE = 0x20c13b0b;
699     uint256 internal constant ERC1271_ISVALIDSIG_MAX_GAS = 250000;
700 
701     string private constant ERROR_INVALID_LENGTH_POP_BYTE = "SIGVAL_INVALID_LENGTH_POP_BYTE";
702 
703     /// @dev Validates that a hash was signed by a specified signer.
704     /// @param hash Hash which was signed.
705     /// @param signer Address of the signer.
706     /// @param signature ECDSA signature along with the mode (0 = Invalid, 1 = EIP712, 2 = EthSign, 3 = ERC1271) {mode}{r}{s}{v}.
707     /// @return Returns whether signature is from a specified user.
708     function isValidSignature(bytes32 hash, address signer, bytes signature) internal view returns (bool) {
709         if (signature.length == 0) {
710             return false;
711         }
712 
713         uint8 modeByte = uint8(signature[0]);
714         if (modeByte >= uint8(SignatureMode.NMode)) {
715             return false;
716         }
717         SignatureMode mode = SignatureMode(modeByte);
718 
719         if (mode == SignatureMode.EIP712) {
720             return ecVerify(hash, signer, signature);
721         } else if (mode == SignatureMode.EthSign) {
722             return ecVerify(
723                 keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)),
724                 signer,
725                 signature
726             );
727         } else if (mode == SignatureMode.ERC1271) {
728             // Pop the mode byte before sending it down the validation chain
729             return safeIsValidSignature(signer, hash, popFirstByte(signature));
730         } else {
731             return false;
732         }
733     }
734 
735     function ecVerify(bytes32 hash, address signer, bytes memory signature) private pure returns (bool) {
736         (bool badSig, bytes32 r, bytes32 s, uint8 v) = unpackEcSig(signature);
737 
738         if (badSig) {
739             return false;
740         }
741 
742         return signer == ecrecover(hash, v, r, s);
743     }
744 
745     function unpackEcSig(bytes memory signature) private pure returns (bool badSig, bytes32 r, bytes32 s, uint8 v) {
746         if (signature.length != 66) {
747             badSig = true;
748             return;
749         }
750 
751         v = uint8(signature[65]);
752         assembly {
753             r := mload(add(signature, 33))
754             s := mload(add(signature, 65))
755         }
756 
757         // Allow signature version to be 0 or 1
758         if (v < 27) {
759             v += 27;
760         }
761 
762         if (v != 27 && v != 28) {
763             badSig = true;
764         }
765     }
766 
767     function popFirstByte(bytes memory input) private pure returns (bytes memory output) {
768         uint256 inputLength = input.length;
769         require(inputLength > 0, ERROR_INVALID_LENGTH_POP_BYTE);
770 
771         output = new bytes(inputLength - 1);
772 
773         if (output.length == 0) {
774             return output;
775         }
776 
777         uint256 inputPointer;
778         uint256 outputPointer;
779         assembly {
780             inputPointer := add(input, 0x21)
781             outputPointer := add(output, 0x20)
782         }
783         memcpy(outputPointer, inputPointer, output.length);
784     }
785 
786     function safeIsValidSignature(address validator, bytes32 hash, bytes memory signature) private view returns (bool) {
787         bytes memory data = abi.encodeWithSelector(ERC1271(validator).isValidSignature.selector, hash, signature);
788         bytes4 erc1271Return = safeBytes4StaticCall(validator, data, ERC1271_ISVALIDSIG_MAX_GAS);
789         return erc1271Return == ERC1271_RETURN_VALID_SIGNATURE;
790     }
791 
792     function safeBytes4StaticCall(address target, bytes data, uint256 maxGas) private view returns (bytes4 ret) {
793         uint256 gasLeft = gasleft();
794 
795         uint256 callGas = gasLeft > maxGas ? maxGas : gasLeft;
796         bool ok;
797         assembly {
798             ok := staticcall(callGas, target, add(data, 0x20), mload(data), 0, 0)
799         }
800 
801         if (!ok) {
802             return;
803         }
804 
805         uint256 size;
806         assembly { size := returndatasize }
807         if (size != 32) {
808             return;
809         }
810 
811         assembly {
812             let ptr := mload(0x40)       // get next free memory ptr
813             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
814             ret := mload(ptr)            // read data at ptr and set it to be returned
815         }
816 
817         return ret;
818     }
819 
820     // From: https://github.com/Arachnid/solidity-stringutils/blob/01e955c1d6/src/strings.sol
821     function memcpy(uint256 dest, uint256 src, uint256 len) private pure {
822         // Copy word-length chunks while possible
823         for (; len >= 32; len -= 32) {
824             assembly {
825                 mstore(dest, mload(src))
826             }
827             dest += 32;
828             src += 32;
829         }
830 
831         // Copy remaining bytes
832         uint mask = 256 ** (32 - len) - 1;
833         assembly {
834             let srcpart := and(mload(src), not(mask))
835             let destpart := and(mload(dest), mask)
836             mstore(dest, or(destpart, srcpart))
837         }
838     }
839 }
840 
841 // File: @aragon/apps-agent/contracts/standards/IERC165.sol
842 
843 pragma solidity 0.4.24;
844 
845 
846 interface IERC165 {
847     function supportsInterface(bytes4 interfaceId) external pure returns (bool);
848 }
849 
850 // File: @aragon/os/contracts/common/UnstructuredStorage.sol
851 
852 /*
853  * SPDX-License-Identitifer:    MIT
854  */
855 
856 pragma solidity ^0.4.24;
857 
858 
859 library UnstructuredStorage {
860     function getStorageBool(bytes32 position) internal view returns (bool data) {
861         assembly { data := sload(position) }
862     }
863 
864     function getStorageAddress(bytes32 position) internal view returns (address data) {
865         assembly { data := sload(position) }
866     }
867 
868     function getStorageBytes32(bytes32 position) internal view returns (bytes32 data) {
869         assembly { data := sload(position) }
870     }
871 
872     function getStorageUint256(bytes32 position) internal view returns (uint256 data) {
873         assembly { data := sload(position) }
874     }
875 
876     function setStorageBool(bytes32 position, bool data) internal {
877         assembly { sstore(position, data) }
878     }
879 
880     function setStorageAddress(bytes32 position, address data) internal {
881         assembly { sstore(position, data) }
882     }
883 
884     function setStorageBytes32(bytes32 position, bytes32 data) internal {
885         assembly { sstore(position, data) }
886     }
887 
888     function setStorageUint256(bytes32 position, uint256 data) internal {
889         assembly { sstore(position, data) }
890     }
891 }
892 
893 // File: @aragon/os/contracts/acl/IACL.sol
894 
895 /*
896  * SPDX-License-Identitifer:    MIT
897  */
898 
899 pragma solidity ^0.4.24;
900 
901 
902 interface IACL {
903     function initialize(address permissionsCreator) external;
904 
905     // TODO: this should be external
906     // See https://github.com/ethereum/solidity/issues/4832
907     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
908 }
909 
910 // File: @aragon/os/contracts/common/IVaultRecoverable.sol
911 
912 /*
913  * SPDX-License-Identitifer:    MIT
914  */
915 
916 pragma solidity ^0.4.24;
917 
918 
919 interface IVaultRecoverable {
920     event RecoverToVault(address indexed vault, address indexed token, uint256 amount);
921 
922     function transferToVault(address token) external;
923 
924     function allowRecoverability(address token) external view returns (bool);
925     function getRecoveryVault() external view returns (address);
926 }
927 
928 // File: @aragon/os/contracts/kernel/IKernel.sol
929 
930 /*
931  * SPDX-License-Identitifer:    MIT
932  */
933 
934 pragma solidity ^0.4.24;
935 
936 
937 
938 
939 interface IKernelEvents {
940     event SetApp(bytes32 indexed namespace, bytes32 indexed appId, address app);
941 }
942 
943 
944 // This should be an interface, but interfaces can't inherit yet :(
945 contract IKernel is IKernelEvents, IVaultRecoverable {
946     function acl() public view returns (IACL);
947     function hasPermission(address who, address where, bytes32 what, bytes how) public view returns (bool);
948 
949     function setApp(bytes32 namespace, bytes32 appId, address app) public;
950     function getApp(bytes32 namespace, bytes32 appId) public view returns (address);
951 }
952 
953 // File: @aragon/os/contracts/apps/AppStorage.sol
954 
955 /*
956  * SPDX-License-Identitifer:    MIT
957  */
958 
959 pragma solidity ^0.4.24;
960 
961 
962 
963 
964 contract AppStorage {
965     using UnstructuredStorage for bytes32;
966 
967     /* Hardcoded constants to save gas
968     bytes32 internal constant KERNEL_POSITION = keccak256("aragonOS.appStorage.kernel");
969     bytes32 internal constant APP_ID_POSITION = keccak256("aragonOS.appStorage.appId");
970     */
971     bytes32 internal constant KERNEL_POSITION = 0x4172f0f7d2289153072b0a6ca36959e0cbe2efc3afe50fc81636caa96338137b;
972     bytes32 internal constant APP_ID_POSITION = 0xd625496217aa6a3453eecb9c3489dc5a53e6c67b444329ea2b2cbc9ff547639b;
973 
974     function kernel() public view returns (IKernel) {
975         return IKernel(KERNEL_POSITION.getStorageAddress());
976     }
977 
978     function appId() public view returns (bytes32) {
979         return APP_ID_POSITION.getStorageBytes32();
980     }
981 
982     function setKernel(IKernel _kernel) internal {
983         KERNEL_POSITION.setStorageAddress(address(_kernel));
984     }
985 
986     function setAppId(bytes32 _appId) internal {
987         APP_ID_POSITION.setStorageBytes32(_appId);
988     }
989 }
990 
991 // File: @aragon/os/contracts/acl/ACLSyntaxSugar.sol
992 
993 /*
994  * SPDX-License-Identitifer:    MIT
995  */
996 
997 pragma solidity ^0.4.24;
998 
999 
1000 contract ACLSyntaxSugar {
1001     function arr() internal pure returns (uint256[]) {
1002         return new uint256[](0);
1003     }
1004 
1005     function arr(bytes32 _a) internal pure returns (uint256[] r) {
1006         return arr(uint256(_a));
1007     }
1008 
1009     function arr(bytes32 _a, bytes32 _b) internal pure returns (uint256[] r) {
1010         return arr(uint256(_a), uint256(_b));
1011     }
1012 
1013     function arr(address _a) internal pure returns (uint256[] r) {
1014         return arr(uint256(_a));
1015     }
1016 
1017     function arr(address _a, address _b) internal pure returns (uint256[] r) {
1018         return arr(uint256(_a), uint256(_b));
1019     }
1020 
1021     function arr(address _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
1022         return arr(uint256(_a), _b, _c);
1023     }
1024 
1025     function arr(address _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
1026         return arr(uint256(_a), _b, _c, _d);
1027     }
1028 
1029     function arr(address _a, uint256 _b) internal pure returns (uint256[] r) {
1030         return arr(uint256(_a), uint256(_b));
1031     }
1032 
1033     function arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
1034         return arr(uint256(_a), uint256(_b), _c, _d, _e);
1035     }
1036 
1037     function arr(address _a, address _b, address _c) internal pure returns (uint256[] r) {
1038         return arr(uint256(_a), uint256(_b), uint256(_c));
1039     }
1040 
1041     function arr(address _a, address _b, uint256 _c) internal pure returns (uint256[] r) {
1042         return arr(uint256(_a), uint256(_b), uint256(_c));
1043     }
1044 
1045     function arr(uint256 _a) internal pure returns (uint256[] r) {
1046         r = new uint256[](1);
1047         r[0] = _a;
1048     }
1049 
1050     function arr(uint256 _a, uint256 _b) internal pure returns (uint256[] r) {
1051         r = new uint256[](2);
1052         r[0] = _a;
1053         r[1] = _b;
1054     }
1055 
1056     function arr(uint256 _a, uint256 _b, uint256 _c) internal pure returns (uint256[] r) {
1057         r = new uint256[](3);
1058         r[0] = _a;
1059         r[1] = _b;
1060         r[2] = _c;
1061     }
1062 
1063     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d) internal pure returns (uint256[] r) {
1064         r = new uint256[](4);
1065         r[0] = _a;
1066         r[1] = _b;
1067         r[2] = _c;
1068         r[3] = _d;
1069     }
1070 
1071     function arr(uint256 _a, uint256 _b, uint256 _c, uint256 _d, uint256 _e) internal pure returns (uint256[] r) {
1072         r = new uint256[](5);
1073         r[0] = _a;
1074         r[1] = _b;
1075         r[2] = _c;
1076         r[3] = _d;
1077         r[4] = _e;
1078     }
1079 }
1080 
1081 
1082 contract ACLHelpers {
1083     function decodeParamOp(uint256 _x) internal pure returns (uint8 b) {
1084         return uint8(_x >> (8 * 30));
1085     }
1086 
1087     function decodeParamId(uint256 _x) internal pure returns (uint8 b) {
1088         return uint8(_x >> (8 * 31));
1089     }
1090 
1091     function decodeParamsList(uint256 _x) internal pure returns (uint32 a, uint32 b, uint32 c) {
1092         a = uint32(_x);
1093         b = uint32(_x >> (8 * 4));
1094         c = uint32(_x >> (8 * 8));
1095     }
1096 }
1097 
1098 // File: @aragon/os/contracts/common/Uint256Helpers.sol
1099 
1100 pragma solidity ^0.4.24;
1101 
1102 
1103 library Uint256Helpers {
1104     uint256 private constant MAX_UINT64 = uint64(-1);
1105 
1106     string private constant ERROR_NUMBER_TOO_BIG = "UINT64_NUMBER_TOO_BIG";
1107 
1108     function toUint64(uint256 a) internal pure returns (uint64) {
1109         require(a <= MAX_UINT64, ERROR_NUMBER_TOO_BIG);
1110         return uint64(a);
1111     }
1112 }
1113 
1114 // File: @aragon/os/contracts/common/TimeHelpers.sol
1115 
1116 /*
1117  * SPDX-License-Identitifer:    MIT
1118  */
1119 
1120 pragma solidity ^0.4.24;
1121 
1122 
1123 
1124 contract TimeHelpers {
1125     using Uint256Helpers for uint256;
1126 
1127     /**
1128     * @dev Returns the current block number.
1129     *      Using a function rather than `block.number` allows us to easily mock the block number in
1130     *      tests.
1131     */
1132     function getBlockNumber() internal view returns (uint256) {
1133         return block.number;
1134     }
1135 
1136     /**
1137     * @dev Returns the current block number, converted to uint64.
1138     *      Using a function rather than `block.number` allows us to easily mock the block number in
1139     *      tests.
1140     */
1141     function getBlockNumber64() internal view returns (uint64) {
1142         return getBlockNumber().toUint64();
1143     }
1144 
1145     /**
1146     * @dev Returns the current timestamp.
1147     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1148     *      tests.
1149     */
1150     function getTimestamp() internal view returns (uint256) {
1151         return block.timestamp; // solium-disable-line security/no-block-members
1152     }
1153 
1154     /**
1155     * @dev Returns the current timestamp, converted to uint64.
1156     *      Using a function rather than `block.timestamp` allows us to easily mock it in
1157     *      tests.
1158     */
1159     function getTimestamp64() internal view returns (uint64) {
1160         return getTimestamp().toUint64();
1161     }
1162 }
1163 
1164 // File: @aragon/os/contracts/common/Initializable.sol
1165 
1166 /*
1167  * SPDX-License-Identitifer:    MIT
1168  */
1169 
1170 pragma solidity ^0.4.24;
1171 
1172 
1173 
1174 
1175 contract Initializable is TimeHelpers {
1176     using UnstructuredStorage for bytes32;
1177 
1178     // keccak256("aragonOS.initializable.initializationBlock")
1179     bytes32 internal constant INITIALIZATION_BLOCK_POSITION = 0xebb05b386a8d34882b8711d156f463690983dc47815980fb82aeeff1aa43579e;
1180 
1181     string private constant ERROR_ALREADY_INITIALIZED = "INIT_ALREADY_INITIALIZED";
1182     string private constant ERROR_NOT_INITIALIZED = "INIT_NOT_INITIALIZED";
1183 
1184     modifier onlyInit {
1185         require(getInitializationBlock() == 0, ERROR_ALREADY_INITIALIZED);
1186         _;
1187     }
1188 
1189     modifier isInitialized {
1190         require(hasInitialized(), ERROR_NOT_INITIALIZED);
1191         _;
1192     }
1193 
1194     /**
1195     * @return Block number in which the contract was initialized
1196     */
1197     function getInitializationBlock() public view returns (uint256) {
1198         return INITIALIZATION_BLOCK_POSITION.getStorageUint256();
1199     }
1200 
1201     /**
1202     * @return Whether the contract has been initialized by the time of the current block
1203     */
1204     function hasInitialized() public view returns (bool) {
1205         uint256 initializationBlock = getInitializationBlock();
1206         return initializationBlock != 0 && getBlockNumber() >= initializationBlock;
1207     }
1208 
1209     /**
1210     * @dev Function to be called by top level contract after initialization has finished.
1211     */
1212     function initialized() internal onlyInit {
1213         INITIALIZATION_BLOCK_POSITION.setStorageUint256(getBlockNumber());
1214     }
1215 
1216     /**
1217     * @dev Function to be called by top level contract after initialization to enable the contract
1218     *      at a future block number rather than immediately.
1219     */
1220     function initializedAt(uint256 _blockNumber) internal onlyInit {
1221         INITIALIZATION_BLOCK_POSITION.setStorageUint256(_blockNumber);
1222     }
1223 }
1224 
1225 // File: @aragon/os/contracts/common/Petrifiable.sol
1226 
1227 /*
1228  * SPDX-License-Identitifer:    MIT
1229  */
1230 
1231 pragma solidity ^0.4.24;
1232 
1233 
1234 
1235 contract Petrifiable is Initializable {
1236     // Use block UINT256_MAX (which should be never) as the initializable date
1237     uint256 internal constant PETRIFIED_BLOCK = uint256(-1);
1238 
1239     function isPetrified() public view returns (bool) {
1240         return getInitializationBlock() == PETRIFIED_BLOCK;
1241     }
1242 
1243     /**
1244     * @dev Function to be called by top level contract to prevent being initialized.
1245     *      Useful for freezing base contracts when they're used behind proxies.
1246     */
1247     function petrify() internal onlyInit {
1248         initializedAt(PETRIFIED_BLOCK);
1249     }
1250 }
1251 
1252 // File: @aragon/os/contracts/common/Autopetrified.sol
1253 
1254 /*
1255  * SPDX-License-Identitifer:    MIT
1256  */
1257 
1258 pragma solidity ^0.4.24;
1259 
1260 
1261 
1262 contract Autopetrified is Petrifiable {
1263     constructor() public {
1264         // Immediately petrify base (non-proxy) instances of inherited contracts on deploy.
1265         // This renders them uninitializable (and unusable without a proxy).
1266         petrify();
1267     }
1268 }
1269 
1270 // File: @aragon/os/contracts/common/ConversionHelpers.sol
1271 
1272 pragma solidity ^0.4.24;
1273 
1274 
1275 library ConversionHelpers {
1276     string private constant ERROR_IMPROPER_LENGTH = "CONVERSION_IMPROPER_LENGTH";
1277 
1278     function dangerouslyCastUintArrayToBytes(uint256[] memory _input) internal pure returns (bytes memory output) {
1279         // Force cast the uint256[] into a bytes array, by overwriting its length
1280         // Note that the bytes array doesn't need to be initialized as we immediately overwrite it
1281         // with the input and a new length. The input becomes invalid from this point forward.
1282         uint256 byteLength = _input.length * 32;
1283         assembly {
1284             output := _input
1285             mstore(output, byteLength)
1286         }
1287     }
1288 
1289     function dangerouslyCastBytesToUintArray(bytes memory _input) internal pure returns (uint256[] memory output) {
1290         // Force cast the bytes array into a uint256[], by overwriting its length
1291         // Note that the uint256[] doesn't need to be initialized as we immediately overwrite it
1292         // with the input and a new length. The input becomes invalid from this point forward.
1293         uint256 intsLength = _input.length / 32;
1294         require(_input.length == intsLength * 32, ERROR_IMPROPER_LENGTH);
1295 
1296         assembly {
1297             output := _input
1298             mstore(output, intsLength)
1299         }
1300     }
1301 }
1302 
1303 // File: @aragon/os/contracts/common/ReentrancyGuard.sol
1304 
1305 /*
1306  * SPDX-License-Identitifer:    MIT
1307  */
1308 
1309 pragma solidity ^0.4.24;
1310 
1311 
1312 
1313 contract ReentrancyGuard {
1314     using UnstructuredStorage for bytes32;
1315 
1316     /* Hardcoded constants to save gas
1317     bytes32 internal constant REENTRANCY_MUTEX_POSITION = keccak256("aragonOS.reentrancyGuard.mutex");
1318     */
1319     bytes32 private constant REENTRANCY_MUTEX_POSITION = 0xe855346402235fdd185c890e68d2c4ecad599b88587635ee285bce2fda58dacb;
1320 
1321     string private constant ERROR_REENTRANT = "REENTRANCY_REENTRANT_CALL";
1322 
1323     modifier nonReentrant() {
1324         // Ensure mutex is unlocked
1325         require(!REENTRANCY_MUTEX_POSITION.getStorageBool(), ERROR_REENTRANT);
1326 
1327         // Lock mutex before function call
1328         REENTRANCY_MUTEX_POSITION.setStorageBool(true);
1329 
1330         // Perform function call
1331         _;
1332 
1333         // Unlock mutex after function call
1334         REENTRANCY_MUTEX_POSITION.setStorageBool(false);
1335     }
1336 }
1337 
1338 // File: @aragon/os/contracts/lib/token/ERC20.sol
1339 
1340 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/a9f910d34f0ab33a1ae5e714f69f9596a02b4d91/contracts/token/ERC20/ERC20.sol
1341 
1342 pragma solidity ^0.4.24;
1343 
1344 
1345 /**
1346  * @title ERC20 interface
1347  * @dev see https://github.com/ethereum/EIPs/issues/20
1348  */
1349 contract ERC20 {
1350     function totalSupply() public view returns (uint256);
1351 
1352     function balanceOf(address _who) public view returns (uint256);
1353 
1354     function allowance(address _owner, address _spender)
1355         public view returns (uint256);
1356 
1357     function transfer(address _to, uint256 _value) public returns (bool);
1358 
1359     function approve(address _spender, uint256 _value)
1360         public returns (bool);
1361 
1362     function transferFrom(address _from, address _to, uint256 _value)
1363         public returns (bool);
1364 
1365     event Transfer(
1366         address indexed from,
1367         address indexed to,
1368         uint256 value
1369     );
1370 
1371     event Approval(
1372         address indexed owner,
1373         address indexed spender,
1374         uint256 value
1375     );
1376 }
1377 
1378 // File: @aragon/os/contracts/common/EtherTokenConstant.sol
1379 
1380 /*
1381  * SPDX-License-Identitifer:    MIT
1382  */
1383 
1384 pragma solidity ^0.4.24;
1385 
1386 
1387 // aragonOS and aragon-apps rely on address(0) to denote native ETH, in
1388 // contracts where both tokens and ETH are accepted
1389 contract EtherTokenConstant {
1390     address internal constant ETH = address(0);
1391 }
1392 
1393 // File: @aragon/os/contracts/common/IsContract.sol
1394 
1395 /*
1396  * SPDX-License-Identitifer:    MIT
1397  */
1398 
1399 pragma solidity ^0.4.24;
1400 
1401 
1402 contract IsContract {
1403     /*
1404     * NOTE: this should NEVER be used for authentication
1405     * (see pitfalls: https://github.com/fergarrui/ethereum-security/tree/master/contracts/extcodesize).
1406     *
1407     * This is only intended to be used as a sanity check that an address is actually a contract,
1408     * RATHER THAN an address not being a contract.
1409     */
1410     function isContract(address _target) internal view returns (bool) {
1411         if (_target == address(0)) {
1412             return false;
1413         }
1414 
1415         uint256 size;
1416         assembly { size := extcodesize(_target) }
1417         return size > 0;
1418     }
1419 }
1420 
1421 // File: @aragon/os/contracts/common/SafeERC20.sol
1422 
1423 // Inspired by AdEx (https://github.com/AdExNetwork/adex-protocol-eth/blob/b9df617829661a7518ee10f4cb6c4108659dd6d5/contracts/libs/SafeERC20.sol)
1424 // and 0x (https://github.com/0xProject/0x-monorepo/blob/737d1dc54d72872e24abce5a1dbe1b66d35fa21a/contracts/protocol/contracts/protocol/AssetProxy/ERC20Proxy.sol#L143)
1425 
1426 pragma solidity ^0.4.24;
1427 
1428 
1429 
1430 library SafeERC20 {
1431     // Before 0.5, solidity has a mismatch between `address.transfer()` and `token.transfer()`:
1432     // https://github.com/ethereum/solidity/issues/3544
1433     bytes4 private constant TRANSFER_SELECTOR = 0xa9059cbb;
1434 
1435     string private constant ERROR_TOKEN_BALANCE_REVERTED = "SAFE_ERC_20_BALANCE_REVERTED";
1436     string private constant ERROR_TOKEN_ALLOWANCE_REVERTED = "SAFE_ERC_20_ALLOWANCE_REVERTED";
1437 
1438     function invokeAndCheckSuccess(address _addr, bytes memory _calldata)
1439         private
1440         returns (bool)
1441     {
1442         bool ret;
1443         assembly {
1444             let ptr := mload(0x40)    // free memory pointer
1445 
1446             let success := call(
1447                 gas,                  // forward all gas
1448                 _addr,                // address
1449                 0,                    // no value
1450                 add(_calldata, 0x20), // calldata start
1451                 mload(_calldata),     // calldata length
1452                 ptr,                  // write output over free memory
1453                 0x20                  // uint256 return
1454             )
1455 
1456             if gt(success, 0) {
1457                 // Check number of bytes returned from last function call
1458                 switch returndatasize
1459 
1460                 // No bytes returned: assume success
1461                 case 0 {
1462                     ret := 1
1463                 }
1464 
1465                 // 32 bytes returned: check if non-zero
1466                 case 0x20 {
1467                     // Only return success if returned data was true
1468                     // Already have output in ptr
1469                     ret := eq(mload(ptr), 1)
1470                 }
1471 
1472                 // Not sure what was returned: don't mark as success
1473                 default { }
1474             }
1475         }
1476         return ret;
1477     }
1478 
1479     function staticInvoke(address _addr, bytes memory _calldata)
1480         private
1481         view
1482         returns (bool, uint256)
1483     {
1484         bool success;
1485         uint256 ret;
1486         assembly {
1487             let ptr := mload(0x40)    // free memory pointer
1488 
1489             success := staticcall(
1490                 gas,                  // forward all gas
1491                 _addr,                // address
1492                 add(_calldata, 0x20), // calldata start
1493                 mload(_calldata),     // calldata length
1494                 ptr,                  // write output over free memory
1495                 0x20                  // uint256 return
1496             )
1497 
1498             if gt(success, 0) {
1499                 ret := mload(ptr)
1500             }
1501         }
1502         return (success, ret);
1503     }
1504 
1505     /**
1506     * @dev Same as a standards-compliant ERC20.transfer() that never reverts (returns false).
1507     *      Note that this makes an external call to the token.
1508     */
1509     function safeTransfer(ERC20 _token, address _to, uint256 _amount) internal returns (bool) {
1510         bytes memory transferCallData = abi.encodeWithSelector(
1511             TRANSFER_SELECTOR,
1512             _to,
1513             _amount
1514         );
1515         return invokeAndCheckSuccess(_token, transferCallData);
1516     }
1517 
1518     /**
1519     * @dev Same as a standards-compliant ERC20.transferFrom() that never reverts (returns false).
1520     *      Note that this makes an external call to the token.
1521     */
1522     function safeTransferFrom(ERC20 _token, address _from, address _to, uint256 _amount) internal returns (bool) {
1523         bytes memory transferFromCallData = abi.encodeWithSelector(
1524             _token.transferFrom.selector,
1525             _from,
1526             _to,
1527             _amount
1528         );
1529         return invokeAndCheckSuccess(_token, transferFromCallData);
1530     }
1531 
1532     /**
1533     * @dev Same as a standards-compliant ERC20.approve() that never reverts (returns false).
1534     *      Note that this makes an external call to the token.
1535     */
1536     function safeApprove(ERC20 _token, address _spender, uint256 _amount) internal returns (bool) {
1537         bytes memory approveCallData = abi.encodeWithSelector(
1538             _token.approve.selector,
1539             _spender,
1540             _amount
1541         );
1542         return invokeAndCheckSuccess(_token, approveCallData);
1543     }
1544 
1545     /**
1546     * @dev Static call into ERC20.balanceOf().
1547     * Reverts if the call fails for some reason (should never fail).
1548     */
1549     function staticBalanceOf(ERC20 _token, address _owner) internal view returns (uint256) {
1550         bytes memory balanceOfCallData = abi.encodeWithSelector(
1551             _token.balanceOf.selector,
1552             _owner
1553         );
1554 
1555         (bool success, uint256 tokenBalance) = staticInvoke(_token, balanceOfCallData);
1556         require(success, ERROR_TOKEN_BALANCE_REVERTED);
1557 
1558         return tokenBalance;
1559     }
1560 
1561     /**
1562     * @dev Static call into ERC20.allowance().
1563     * Reverts if the call fails for some reason (should never fail).
1564     */
1565     function staticAllowance(ERC20 _token, address _owner, address _spender) internal view returns (uint256) {
1566         bytes memory allowanceCallData = abi.encodeWithSelector(
1567             _token.allowance.selector,
1568             _owner,
1569             _spender
1570         );
1571 
1572         (bool success, uint256 allowance) = staticInvoke(_token, allowanceCallData);
1573         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
1574 
1575         return allowance;
1576     }
1577 
1578     /**
1579     * @dev Static call into ERC20.totalSupply().
1580     * Reverts if the call fails for some reason (should never fail).
1581     */
1582     function staticTotalSupply(ERC20 _token) internal view returns (uint256) {
1583         bytes memory totalSupplyCallData = abi.encodeWithSelector(_token.totalSupply.selector);
1584 
1585         (bool success, uint256 totalSupply) = staticInvoke(_token, totalSupplyCallData);
1586         require(success, ERROR_TOKEN_ALLOWANCE_REVERTED);
1587 
1588         return totalSupply;
1589     }
1590 }
1591 
1592 // File: @aragon/os/contracts/common/VaultRecoverable.sol
1593 
1594 /*
1595  * SPDX-License-Identitifer:    MIT
1596  */
1597 
1598 pragma solidity ^0.4.24;
1599 
1600 
1601 
1602 
1603 
1604 
1605 
1606 contract VaultRecoverable is IVaultRecoverable, EtherTokenConstant, IsContract {
1607     using SafeERC20 for ERC20;
1608 
1609     string private constant ERROR_DISALLOWED = "RECOVER_DISALLOWED";
1610     string private constant ERROR_VAULT_NOT_CONTRACT = "RECOVER_VAULT_NOT_CONTRACT";
1611     string private constant ERROR_TOKEN_TRANSFER_FAILED = "RECOVER_TOKEN_TRANSFER_FAILED";
1612 
1613     /**
1614      * @notice Send funds to recovery Vault. This contract should never receive funds,
1615      *         but in case it does, this function allows one to recover them.
1616      * @param _token Token balance to be sent to recovery vault.
1617      */
1618     function transferToVault(address _token) external {
1619         require(allowRecoverability(_token), ERROR_DISALLOWED);
1620         address vault = getRecoveryVault();
1621         require(isContract(vault), ERROR_VAULT_NOT_CONTRACT);
1622 
1623         uint256 balance;
1624         if (_token == ETH) {
1625             balance = address(this).balance;
1626             vault.transfer(balance);
1627         } else {
1628             ERC20 token = ERC20(_token);
1629             balance = token.staticBalanceOf(this);
1630             require(token.safeTransfer(vault, balance), ERROR_TOKEN_TRANSFER_FAILED);
1631         }
1632 
1633         emit RecoverToVault(vault, _token, balance);
1634     }
1635 
1636     /**
1637     * @dev By default deriving from AragonApp makes it recoverable
1638     * @param token Token address that would be recovered
1639     * @return bool whether the app allows the recovery
1640     */
1641     function allowRecoverability(address token) public view returns (bool) {
1642         return true;
1643     }
1644 
1645     // Cast non-implemented interface to be public so we can use it internally
1646     function getRecoveryVault() public view returns (address);
1647 }
1648 
1649 // File: @aragon/os/contracts/evmscript/IEVMScriptExecutor.sol
1650 
1651 /*
1652  * SPDX-License-Identitifer:    MIT
1653  */
1654 
1655 pragma solidity ^0.4.24;
1656 
1657 
1658 interface IEVMScriptExecutor {
1659     function execScript(bytes script, bytes input, address[] blacklist) external returns (bytes);
1660     function executorType() external pure returns (bytes32);
1661 }
1662 
1663 // File: @aragon/os/contracts/evmscript/IEVMScriptRegistry.sol
1664 
1665 /*
1666  * SPDX-License-Identitifer:    MIT
1667  */
1668 
1669 pragma solidity ^0.4.24;
1670 
1671 
1672 
1673 contract EVMScriptRegistryConstants {
1674     /* Hardcoded constants to save gas
1675     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = apmNamehash("evmreg");
1676     */
1677     bytes32 internal constant EVMSCRIPT_REGISTRY_APP_ID = 0xddbcfd564f642ab5627cf68b9b7d374fb4f8a36e941a75d89c87998cef03bd61;
1678 }
1679 
1680 
1681 interface IEVMScriptRegistry {
1682     function addScriptExecutor(IEVMScriptExecutor executor) external returns (uint id);
1683     function disableScriptExecutor(uint256 executorId) external;
1684 
1685     // TODO: this should be external
1686     // See https://github.com/ethereum/solidity/issues/4832
1687     function getScriptExecutor(bytes script) public view returns (IEVMScriptExecutor);
1688 }
1689 
1690 // File: @aragon/os/contracts/kernel/KernelConstants.sol
1691 
1692 /*
1693  * SPDX-License-Identitifer:    MIT
1694  */
1695 
1696 pragma solidity ^0.4.24;
1697 
1698 
1699 contract KernelAppIds {
1700     /* Hardcoded constants to save gas
1701     bytes32 internal constant KERNEL_CORE_APP_ID = apmNamehash("kernel");
1702     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = apmNamehash("acl");
1703     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = apmNamehash("vault");
1704     */
1705     bytes32 internal constant KERNEL_CORE_APP_ID = 0x3b4bf6bf3ad5000ecf0f989d5befde585c6860fea3e574a4fab4c49d1c177d9c;
1706     bytes32 internal constant KERNEL_DEFAULT_ACL_APP_ID = 0xe3262375f45a6e2026b7e7b18c2b807434f2508fe1a2a3dfb493c7df8f4aad6a;
1707     bytes32 internal constant KERNEL_DEFAULT_VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
1708 }
1709 
1710 
1711 contract KernelNamespaceConstants {
1712     /* Hardcoded constants to save gas
1713     bytes32 internal constant KERNEL_CORE_NAMESPACE = keccak256("core");
1714     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = keccak256("base");
1715     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = keccak256("app");
1716     */
1717     bytes32 internal constant KERNEL_CORE_NAMESPACE = 0xc681a85306374a5ab27f0bbc385296a54bcd314a1948b6cf61c4ea1bc44bb9f8;
1718     bytes32 internal constant KERNEL_APP_BASES_NAMESPACE = 0xf1f3eb40f5bc1ad1344716ced8b8a0431d840b5783aea1fd01786bc26f35ac0f;
1719     bytes32 internal constant KERNEL_APP_ADDR_NAMESPACE = 0xd6f028ca0e8edb4a8c9757ca4fdccab25fa1e0317da1188108f7d2dee14902fb;
1720 }
1721 
1722 // File: @aragon/os/contracts/evmscript/EVMScriptRunner.sol
1723 
1724 /*
1725  * SPDX-License-Identitifer:    MIT
1726  */
1727 
1728 pragma solidity ^0.4.24;
1729 
1730 
1731 
1732 
1733 
1734 
1735 
1736 contract EVMScriptRunner is AppStorage, Initializable, EVMScriptRegistryConstants, KernelNamespaceConstants {
1737     string private constant ERROR_EXECUTOR_UNAVAILABLE = "EVMRUN_EXECUTOR_UNAVAILABLE";
1738     string private constant ERROR_PROTECTED_STATE_MODIFIED = "EVMRUN_PROTECTED_STATE_MODIFIED";
1739 
1740     /* This is manually crafted in assembly
1741     string private constant ERROR_EXECUTOR_INVALID_RETURN = "EVMRUN_EXECUTOR_INVALID_RETURN";
1742     */
1743 
1744     event ScriptResult(address indexed executor, bytes script, bytes input, bytes returnData);
1745 
1746     function getEVMScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
1747         return IEVMScriptExecutor(getEVMScriptRegistry().getScriptExecutor(_script));
1748     }
1749 
1750     function getEVMScriptRegistry() public view returns (IEVMScriptRegistry) {
1751         address registryAddr = kernel().getApp(KERNEL_APP_ADDR_NAMESPACE, EVMSCRIPT_REGISTRY_APP_ID);
1752         return IEVMScriptRegistry(registryAddr);
1753     }
1754 
1755     function runScript(bytes _script, bytes _input, address[] _blacklist)
1756         internal
1757         isInitialized
1758         protectState
1759         returns (bytes)
1760     {
1761         IEVMScriptExecutor executor = getEVMScriptExecutor(_script);
1762         require(address(executor) != address(0), ERROR_EXECUTOR_UNAVAILABLE);
1763 
1764         bytes4 sig = executor.execScript.selector;
1765         bytes memory data = abi.encodeWithSelector(sig, _script, _input, _blacklist);
1766 
1767         bytes memory output;
1768         assembly {
1769             let success := delegatecall(
1770                 gas,                // forward all gas
1771                 executor,           // address
1772                 add(data, 0x20),    // calldata start
1773                 mload(data),        // calldata length
1774                 0,                  // don't write output (we'll handle this ourselves)
1775                 0                   // don't write output
1776             )
1777 
1778             output := mload(0x40) // free mem ptr get
1779 
1780             switch success
1781             case 0 {
1782                 // If the call errored, forward its full error data
1783                 returndatacopy(output, 0, returndatasize)
1784                 revert(output, returndatasize)
1785             }
1786             default {
1787                 switch gt(returndatasize, 0x3f)
1788                 case 0 {
1789                     // Need at least 0x40 bytes returned for properly ABI-encoded bytes values,
1790                     // revert with "EVMRUN_EXECUTOR_INVALID_RETURN"
1791                     // See remix: doing a `revert("EVMRUN_EXECUTOR_INVALID_RETURN")` always results in
1792                     // this memory layout
1793                     mstore(output, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
1794                     mstore(add(output, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
1795                     mstore(add(output, 0x24), 0x000000000000000000000000000000000000000000000000000000000000001e) // reason length
1796                     mstore(add(output, 0x44), 0x45564d52554e5f4558454355544f525f494e56414c49445f52455455524e0000) // reason
1797 
1798                     revert(output, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
1799                 }
1800                 default {
1801                     // Copy result
1802                     //
1803                     // Needs to perform an ABI decode for the expected `bytes` return type of
1804                     // `executor.execScript()` as solidity will automatically ABI encode the returned bytes as:
1805                     //    [ position of the first dynamic length return value = 0x20 (32 bytes) ]
1806                     //    [ output length (32 bytes) ]
1807                     //    [ output content (N bytes) ]
1808                     //
1809                     // Perform the ABI decode by ignoring the first 32 bytes of the return data
1810                     let copysize := sub(returndatasize, 0x20)
1811                     returndatacopy(output, 0x20, copysize)
1812 
1813                     mstore(0x40, add(output, copysize)) // free mem ptr set
1814                 }
1815             }
1816         }
1817 
1818         emit ScriptResult(address(executor), _script, _input, output);
1819 
1820         return output;
1821     }
1822 
1823     modifier protectState {
1824         address preKernel = address(kernel());
1825         bytes32 preAppId = appId();
1826         _; // exec
1827         require(address(kernel()) == preKernel, ERROR_PROTECTED_STATE_MODIFIED);
1828         require(appId() == preAppId, ERROR_PROTECTED_STATE_MODIFIED);
1829     }
1830 }
1831 
1832 // File: @aragon/os/contracts/apps/AragonApp.sol
1833 
1834 /*
1835  * SPDX-License-Identitifer:    MIT
1836  */
1837 
1838 pragma solidity ^0.4.24;
1839 
1840 
1841 
1842 
1843 
1844 
1845 
1846 
1847 
1848 // Contracts inheriting from AragonApp are, by default, immediately petrified upon deployment so
1849 // that they can never be initialized.
1850 // Unless overriden, this behaviour enforces those contracts to be usable only behind an AppProxy.
1851 // ReentrancyGuard, EVMScriptRunner, and ACLSyntaxSugar are not directly used by this contract, but
1852 // are included so that they are automatically usable by subclassing contracts
1853 contract AragonApp is AppStorage, Autopetrified, VaultRecoverable, ReentrancyGuard, EVMScriptRunner, ACLSyntaxSugar {
1854     string private constant ERROR_AUTH_FAILED = "APP_AUTH_FAILED";
1855 
1856     modifier auth(bytes32 _role) {
1857         require(canPerform(msg.sender, _role, new uint256[](0)), ERROR_AUTH_FAILED);
1858         _;
1859     }
1860 
1861     modifier authP(bytes32 _role, uint256[] _params) {
1862         require(canPerform(msg.sender, _role, _params), ERROR_AUTH_FAILED);
1863         _;
1864     }
1865 
1866     /**
1867     * @dev Check whether an action can be performed by a sender for a particular role on this app
1868     * @param _sender Sender of the call
1869     * @param _role Role on this app
1870     * @param _params Permission params for the role
1871     * @return Boolean indicating whether the sender has the permissions to perform the action.
1872     *         Always returns false if the app hasn't been initialized yet.
1873     */
1874     function canPerform(address _sender, bytes32 _role, uint256[] _params) public view returns (bool) {
1875         if (!hasInitialized()) {
1876             return false;
1877         }
1878 
1879         IKernel linkedKernel = kernel();
1880         if (address(linkedKernel) == address(0)) {
1881             return false;
1882         }
1883 
1884         return linkedKernel.hasPermission(
1885             _sender,
1886             address(this),
1887             _role,
1888             ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)
1889         );
1890     }
1891 
1892     /**
1893     * @dev Get the recovery vault for the app
1894     * @return Recovery vault address for the app
1895     */
1896     function getRecoveryVault() public view returns (address) {
1897         // Funds recovery via a vault is only available when used with a kernel
1898         return kernel().getRecoveryVault(); // if kernel is not set, it will revert
1899     }
1900 }
1901 
1902 // File: @aragon/os/contracts/common/DepositableStorage.sol
1903 
1904 pragma solidity 0.4.24;
1905 
1906 
1907 
1908 contract DepositableStorage {
1909     using UnstructuredStorage for bytes32;
1910 
1911     // keccak256("aragonOS.depositableStorage.depositable")
1912     bytes32 internal constant DEPOSITABLE_POSITION = 0x665fd576fbbe6f247aff98f5c94a561e3f71ec2d3c988d56f12d342396c50cea;
1913 
1914     function isDepositable() public view returns (bool) {
1915         return DEPOSITABLE_POSITION.getStorageBool();
1916     }
1917 
1918     function setDepositable(bool _depositable) internal {
1919         DEPOSITABLE_POSITION.setStorageBool(_depositable);
1920     }
1921 }
1922 
1923 // File: @aragon/apps-vault/contracts/Vault.sol
1924 
1925 pragma solidity 0.4.24;
1926 
1927 
1928 
1929 
1930 
1931 
1932 
1933 contract Vault is EtherTokenConstant, AragonApp, DepositableStorage {
1934     using SafeERC20 for ERC20;
1935 
1936     bytes32 public constant TRANSFER_ROLE = keccak256("TRANSFER_ROLE");
1937 
1938     string private constant ERROR_DATA_NON_ZERO = "VAULT_DATA_NON_ZERO";
1939     string private constant ERROR_NOT_DEPOSITABLE = "VAULT_NOT_DEPOSITABLE";
1940     string private constant ERROR_DEPOSIT_VALUE_ZERO = "VAULT_DEPOSIT_VALUE_ZERO";
1941     string private constant ERROR_TRANSFER_VALUE_ZERO = "VAULT_TRANSFER_VALUE_ZERO";
1942     string private constant ERROR_SEND_REVERTED = "VAULT_SEND_REVERTED";
1943     string private constant ERROR_VALUE_MISMATCH = "VAULT_VALUE_MISMATCH";
1944     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "VAULT_TOKEN_TRANSFER_FROM_REVERT";
1945     string private constant ERROR_TOKEN_TRANSFER_REVERTED = "VAULT_TOKEN_TRANSFER_REVERTED";
1946 
1947     event VaultTransfer(address indexed token, address indexed to, uint256 amount);
1948     event VaultDeposit(address indexed token, address indexed sender, uint256 amount);
1949 
1950     /**
1951     * @dev On a normal send() or transfer() this fallback is never executed as it will be
1952     *      intercepted by the Proxy (see aragonOS#281)
1953     */
1954     function () external payable isInitialized {
1955         require(msg.data.length == 0, ERROR_DATA_NON_ZERO);
1956         _deposit(ETH, msg.value);
1957     }
1958 
1959     /**
1960     * @notice Initialize Vault app
1961     * @dev As an AragonApp it needs to be initialized in order for roles (`auth` and `authP`) to work
1962     */
1963     function initialize() external onlyInit {
1964         initialized();
1965         setDepositable(true);
1966     }
1967 
1968     /**
1969     * @notice Deposit `_value` `_token` to the vault
1970     * @param _token Address of the token being transferred
1971     * @param _value Amount of tokens being transferred
1972     */
1973     function deposit(address _token, uint256 _value) external payable isInitialized {
1974         _deposit(_token, _value);
1975     }
1976 
1977     /**
1978     * @notice Transfer `_value` `_token` from the Vault to `_to`
1979     * @param _token Address of the token being transferred
1980     * @param _to Address of the recipient of tokens
1981     * @param _value Amount of tokens being transferred
1982     */
1983     /* solium-disable-next-line function-order */
1984     function transfer(address _token, address _to, uint256 _value)
1985         external
1986         authP(TRANSFER_ROLE, arr(_token, _to, _value))
1987     {
1988         require(_value > 0, ERROR_TRANSFER_VALUE_ZERO);
1989 
1990         if (_token == ETH) {
1991             require(_to.send(_value), ERROR_SEND_REVERTED);
1992         } else {
1993             require(ERC20(_token).safeTransfer(_to, _value), ERROR_TOKEN_TRANSFER_REVERTED);
1994         }
1995 
1996         emit VaultTransfer(_token, _to, _value);
1997     }
1998 
1999     function balance(address _token) public view returns (uint256) {
2000         if (_token == ETH) {
2001             return address(this).balance;
2002         } else {
2003             return ERC20(_token).staticBalanceOf(address(this));
2004         }
2005     }
2006 
2007     /**
2008     * @dev Disable recovery escape hatch, as it could be used
2009     *      maliciously to transfer funds away from the vault
2010     */
2011     function allowRecoverability(address) public view returns (bool) {
2012         return false;
2013     }
2014 
2015     function _deposit(address _token, uint256 _value) internal {
2016         require(isDepositable(), ERROR_NOT_DEPOSITABLE);
2017         require(_value > 0, ERROR_DEPOSIT_VALUE_ZERO);
2018 
2019         if (_token == ETH) {
2020             // Deposit is implicit in this case
2021             require(msg.value == _value, ERROR_VALUE_MISMATCH);
2022         } else {
2023             require(
2024                 ERC20(_token).safeTransferFrom(msg.sender, address(this), _value),
2025                 ERROR_TOKEN_TRANSFER_FROM_REVERTED
2026             );
2027         }
2028 
2029         emit VaultDeposit(_token, msg.sender, _value);
2030     }
2031 }
2032 
2033 // File: @aragon/os/contracts/common/IForwarder.sol
2034 
2035 /*
2036  * SPDX-License-Identitifer:    MIT
2037  */
2038 
2039 pragma solidity ^0.4.24;
2040 
2041 
2042 interface IForwarder {
2043     function isForwarder() external pure returns (bool);
2044 
2045     // TODO: this should be external
2046     // See https://github.com/ethereum/solidity/issues/4832
2047     function canForward(address sender, bytes evmCallScript) public view returns (bool);
2048 
2049     // TODO: this should be external
2050     // See https://github.com/ethereum/solidity/issues/4832
2051     function forward(bytes evmCallScript) public;
2052 }
2053 
2054 // File: @aragon/apps-agent/contracts/Agent.sol
2055 
2056 /*
2057  * SPDX-License-Identitifer:    GPL-3.0-or-later
2058  */
2059 
2060 pragma solidity 0.4.24;
2061 
2062 
2063 
2064 
2065 
2066 
2067 
2068 contract Agent is IERC165, ERC1271Bytes, IForwarder, IsContract, Vault {
2069     /* Hardcoded constants to save gas
2070     bytes32 public constant EXECUTE_ROLE = keccak256("EXECUTE_ROLE");
2071     bytes32 public constant SAFE_EXECUTE_ROLE = keccak256("SAFE_EXECUTE_ROLE");
2072     bytes32 public constant ADD_PROTECTED_TOKEN_ROLE = keccak256("ADD_PROTECTED_TOKEN_ROLE");
2073     bytes32 public constant REMOVE_PROTECTED_TOKEN_ROLE = keccak256("REMOVE_PROTECTED_TOKEN_ROLE");
2074     bytes32 public constant ADD_PRESIGNED_HASH_ROLE = keccak256("ADD_PRESIGNED_HASH_ROLE");
2075     bytes32 public constant DESIGNATE_SIGNER_ROLE = keccak256("DESIGNATE_SIGNER_ROLE");
2076     bytes32 public constant RUN_SCRIPT_ROLE = keccak256("RUN_SCRIPT_ROLE");
2077     */
2078 
2079     bytes32 public constant EXECUTE_ROLE = 0xcebf517aa4440d1d125e0355aae64401211d0848a23c02cc5d29a14822580ba4;
2080     bytes32 public constant SAFE_EXECUTE_ROLE = 0x0a1ad7b87f5846153c6d5a1f761d71c7d0cfd122384f56066cd33239b7933694;
2081     bytes32 public constant ADD_PROTECTED_TOKEN_ROLE = 0x6eb2a499556bfa2872f5aa15812b956cc4a71b4d64eb3553f7073c7e41415aaa;
2082     bytes32 public constant REMOVE_PROTECTED_TOKEN_ROLE = 0x71eee93d500f6f065e38b27d242a756466a00a52a1dbcd6b4260f01a8640402a;
2083     bytes32 public constant ADD_PRESIGNED_HASH_ROLE = 0x0b29780bb523a130b3b01f231ef49ed2fa2781645591a0b0a44ca98f15a5994c;
2084     bytes32 public constant DESIGNATE_SIGNER_ROLE = 0x23ce341656c3f14df6692eebd4757791e33662b7dcf9970c8308303da5472b7c;
2085     bytes32 public constant RUN_SCRIPT_ROLE = 0xb421f7ad7646747f3051c50c0b8e2377839296cd4973e27f63821d73e390338f;
2086 
2087     uint256 public constant PROTECTED_TOKENS_CAP = 10;
2088 
2089     bytes4 private constant ERC165_INTERFACE_ID = 0x01ffc9a7;
2090 
2091     string private constant ERROR_TARGET_PROTECTED = "AGENT_TARGET_PROTECTED";
2092     string private constant ERROR_PROTECTED_TOKENS_MODIFIED = "AGENT_PROTECTED_TOKENS_MODIFIED";
2093     string private constant ERROR_PROTECTED_BALANCE_LOWERED = "AGENT_PROTECTED_BALANCE_LOWERED";
2094     string private constant ERROR_TOKENS_CAP_REACHED = "AGENT_TOKENS_CAP_REACHED";
2095     string private constant ERROR_TOKEN_NOT_ERC20 = "AGENT_TOKEN_NOT_ERC20";
2096     string private constant ERROR_TOKEN_ALREADY_PROTECTED = "AGENT_TOKEN_ALREADY_PROTECTED";
2097     string private constant ERROR_TOKEN_NOT_PROTECTED = "AGENT_TOKEN_NOT_PROTECTED";
2098     string private constant ERROR_DESIGNATED_TO_SELF = "AGENT_DESIGNATED_TO_SELF";
2099     string private constant ERROR_CAN_NOT_FORWARD = "AGENT_CAN_NOT_FORWARD";
2100 
2101     mapping (bytes32 => bool) public isPresigned;
2102     address public designatedSigner;
2103     address[] public protectedTokens;
2104 
2105     event SafeExecute(address indexed sender, address indexed target, bytes data);
2106     event Execute(address indexed sender, address indexed target, uint256 ethValue, bytes data);
2107     event AddProtectedToken(address indexed token);
2108     event RemoveProtectedToken(address indexed token);
2109     event PresignHash(address indexed sender, bytes32 indexed hash);
2110     event SetDesignatedSigner(address indexed sender, address indexed oldSigner, address indexed newSigner);
2111 
2112     /**
2113     * @notice Execute '`@radspec(_target, _data)`' on `_target``_ethValue == 0 ? '' : ' (Sending' + @tokenAmount(0x0000000000000000000000000000000000000000, _ethValue) + ')'`
2114     * @param _target Address where the action is being executed
2115     * @param _ethValue Amount of ETH from the contract that is sent with the action
2116     * @param _data Calldata for the action
2117     * @return Exits call frame forwarding the return data of the executed call (either error or success data)
2118     */
2119     function execute(address _target, uint256 _ethValue, bytes _data)
2120         external // This function MUST always be external as the function performs a low level return, exiting the Agent app execution context
2121         authP(EXECUTE_ROLE, arr(_target, _ethValue, uint256(_getSig(_data)))) // bytes4 casted as uint256 sets the bytes as the LSBs
2122     {
2123         bool result = _target.call.value(_ethValue)(_data);
2124 
2125         if (result) {
2126             emit Execute(msg.sender, _target, _ethValue, _data);
2127         }
2128 
2129         assembly {
2130             let ptr := mload(0x40)
2131             returndatacopy(ptr, 0, returndatasize)
2132 
2133             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
2134             // if the call returned error data, forward it
2135             switch result case 0 { revert(ptr, returndatasize) }
2136             default { return(ptr, returndatasize) }
2137         }
2138     }
2139 
2140     /**
2141     * @notice Execute '`@radspec(_target, _data)`' on `_target` ensuring that protected tokens can't be spent
2142     * @param _target Address where the action is being executed
2143     * @param _data Calldata for the action
2144     * @return Exits call frame forwarding the return data of the executed call (either error or success data)
2145     */
2146     function safeExecute(address _target, bytes _data)
2147         external // This function MUST always be external as the function performs a low level return, exiting the Agent app execution context
2148         authP(SAFE_EXECUTE_ROLE, arr(_target, uint256(_getSig(_data)))) // bytes4 casted as uint256 sets the bytes as the LSBs
2149     {
2150         uint256 protectedTokensLength = protectedTokens.length;
2151         address[] memory protectedTokens_ = new address[](protectedTokensLength);
2152         uint256[] memory balances = new uint256[](protectedTokensLength);
2153 
2154         for (uint256 i = 0; i < protectedTokensLength; i++) {
2155             address token = protectedTokens[i];
2156             require(_target != token, ERROR_TARGET_PROTECTED);
2157             // we copy the protected tokens array to check whether the storage array has been modified during the underlying call
2158             protectedTokens_[i] = token;
2159             // we copy the balances to check whether they have been modified during the underlying call
2160             balances[i] = balance(token);
2161         }
2162 
2163         bool result = _target.call(_data);
2164 
2165         bytes32 ptr;
2166         uint256 size;
2167         assembly {
2168             size := returndatasize
2169             ptr := mload(0x40)
2170             mstore(0x40, add(ptr, returndatasize))
2171             returndatacopy(ptr, 0, returndatasize)
2172         }
2173 
2174         if (result) {
2175             // if the underlying call has succeeded, we check that the protected tokens
2176             // and their balances have not been modified and return the call's return data
2177             require(protectedTokens.length == protectedTokensLength, ERROR_PROTECTED_TOKENS_MODIFIED);
2178             for (uint256 j = 0; j < protectedTokensLength; j++) {
2179                 require(protectedTokens[j] == protectedTokens_[j], ERROR_PROTECTED_TOKENS_MODIFIED);
2180                 require(balance(protectedTokens[j]) >= balances[j], ERROR_PROTECTED_BALANCE_LOWERED);
2181             }
2182 
2183             emit SafeExecute(msg.sender, _target, _data);
2184 
2185             assembly {
2186                 return(ptr, size)
2187             }
2188         } else {
2189             // if the underlying call has failed, we revert and forward returned error data
2190             assembly {
2191                 revert(ptr, size)
2192             }
2193         }
2194     }
2195 
2196     /**
2197     * @notice Add `_token.symbol(): string` to the list of protected tokens
2198     * @param _token Address of the token to be protected
2199     */
2200     function addProtectedToken(address _token) external authP(ADD_PROTECTED_TOKEN_ROLE, arr(_token)) {
2201         require(protectedTokens.length < PROTECTED_TOKENS_CAP, ERROR_TOKENS_CAP_REACHED);
2202         require(_isERC20(_token), ERROR_TOKEN_NOT_ERC20);
2203         require(!_tokenIsProtected(_token), ERROR_TOKEN_ALREADY_PROTECTED);
2204 
2205         _addProtectedToken(_token);
2206     }
2207 
2208     /**
2209     * @notice Remove `_token.symbol(): string` from the list of protected tokens
2210     * @param _token Address of the token to be unprotected
2211     */
2212     function removeProtectedToken(address _token) external authP(REMOVE_PROTECTED_TOKEN_ROLE, arr(_token)) {
2213         require(_tokenIsProtected(_token), ERROR_TOKEN_NOT_PROTECTED);
2214 
2215         _removeProtectedToken(_token);
2216     }
2217 
2218     /**
2219     * @notice Pre-sign hash `_hash`
2220     * @param _hash Hash that will be considered signed regardless of the signature checked with 'isValidSignature()'
2221     */
2222     function presignHash(bytes32 _hash)
2223         external
2224         authP(ADD_PRESIGNED_HASH_ROLE, arr(_hash))
2225     {
2226         isPresigned[_hash] = true;
2227 
2228         emit PresignHash(msg.sender, _hash);
2229     }
2230 
2231     /**
2232     * @notice Set `_designatedSigner` as the designated signer of the app, which will be able to sign messages on behalf of the app
2233     * @param _designatedSigner Address that will be able to sign messages on behalf of the app
2234     */
2235     function setDesignatedSigner(address _designatedSigner)
2236         external
2237         authP(DESIGNATE_SIGNER_ROLE, arr(_designatedSigner))
2238     {
2239         // Prevent an infinite loop by setting the app itself as its designated signer.
2240         // An undetectable loop can be created by setting a different contract as the
2241         // designated signer which calls back into `isValidSignature`.
2242         // Given that `isValidSignature` is always called with just 50k gas, the max
2243         // damage of the loop is wasting 50k gas.
2244         require(_designatedSigner != address(this), ERROR_DESIGNATED_TO_SELF);
2245 
2246         address oldDesignatedSigner = designatedSigner;
2247         designatedSigner = _designatedSigner;
2248 
2249         emit SetDesignatedSigner(msg.sender, oldDesignatedSigner, _designatedSigner);
2250     }
2251 
2252     // Forwarding fns
2253 
2254     /**
2255     * @notice Tells whether the Agent app is a forwarder or not
2256     * @dev IForwarder interface conformance
2257     * @return Always true
2258     */
2259     function isForwarder() external pure returns (bool) {
2260         return true;
2261     }
2262 
2263     /**
2264     * @notice Execute the script as the Agent app
2265     * @dev IForwarder interface conformance. Forwards any token holder action.
2266     * @param _evmScript Script being executed
2267     */
2268     function forward(bytes _evmScript) public {
2269         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
2270 
2271         bytes memory input = ""; // no input
2272         address[] memory blacklist = new address[](0); // no addr blacklist, can interact with anything
2273         runScript(_evmScript, input, blacklist);
2274         // We don't need to emit an event here as EVMScriptRunner will emit ScriptResult if successful
2275     }
2276 
2277     /**
2278     * @notice Tells whether `_sender` can forward actions or not
2279     * @dev IForwarder interface conformance
2280     * @param _sender Address of the account intending to forward an action
2281     * @return True if the given address can run scripts, false otherwise
2282     */
2283     function canForward(address _sender, bytes _evmScript) public view returns (bool) {
2284         // Note that `canPerform()` implicitly does an initialization check itself
2285         return canPerform(_sender, RUN_SCRIPT_ROLE, arr(_getScriptACLParam(_evmScript)));
2286     }
2287 
2288     // ERC-165 conformance
2289 
2290     /**
2291      * @notice Tells whether this contract supports a given ERC-165 interface
2292      * @param _interfaceId Interface bytes to check
2293      * @return True if this contract supports the interface
2294      */
2295     function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
2296         return
2297             _interfaceId == ERC1271_INTERFACE_ID ||
2298             _interfaceId == ERC165_INTERFACE_ID;
2299     }
2300 
2301     // ERC-1271 conformance
2302 
2303     /**
2304      * @notice Tells whether a signature is seen as valid by this contract through ERC-1271
2305      * @param _hash Arbitrary length data signed on the behalf of address (this)
2306      * @param _signature Signature byte array associated with _data
2307      * @return The ERC-1271 magic value if the signature is valid
2308      */
2309     function isValidSignature(bytes32 _hash, bytes _signature) public view returns (bytes4) {
2310         // Short-circuit in case the hash was presigned. Optimization as performing calls
2311         // and ecrecover is more expensive than an SLOAD.
2312         if (isPresigned[_hash]) {
2313             return returnIsValidSignatureMagicNumber(true);
2314         }
2315 
2316         bool isValid;
2317         if (designatedSigner == address(0)) {
2318             isValid = false;
2319         } else {
2320             isValid = SignatureValidator.isValidSignature(_hash, designatedSigner, _signature);
2321         }
2322 
2323         return returnIsValidSignatureMagicNumber(isValid);
2324     }
2325 
2326     // Getters
2327 
2328     function getProtectedTokensLength() public view isInitialized returns (uint256) {
2329         return protectedTokens.length;
2330     }
2331 
2332     // Internal fns
2333 
2334     function _addProtectedToken(address _token) internal {
2335         protectedTokens.push(_token);
2336 
2337         emit AddProtectedToken(_token);
2338     }
2339 
2340     function _removeProtectedToken(address _token) internal {
2341         protectedTokens[_protectedTokenIndex(_token)] = protectedTokens[protectedTokens.length - 1];
2342         protectedTokens.length--;
2343 
2344         emit RemoveProtectedToken(_token);
2345     }
2346 
2347     function _isERC20(address _token) internal view returns (bool) {
2348         if (!isContract(_token)) {
2349             return false;
2350         }
2351 
2352         // Throwaway sanity check to make sure the token's `balanceOf()` does not error (for now)
2353         balance(_token);
2354 
2355         return true;
2356     }
2357 
2358     function _protectedTokenIndex(address _token) internal view returns (uint256) {
2359         for (uint i = 0; i < protectedTokens.length; i++) {
2360             if (protectedTokens[i] == _token) {
2361               return i;
2362             }
2363         }
2364 
2365         revert(ERROR_TOKEN_NOT_PROTECTED);
2366     }
2367 
2368     function _tokenIsProtected(address _token) internal view returns (bool) {
2369         for (uint256 i = 0; i < protectedTokens.length; i++) {
2370             if (protectedTokens[i] == _token) {
2371                 return true;
2372             }
2373         }
2374 
2375         return false;
2376     }
2377 
2378     function _getScriptACLParam(bytes _evmScript) internal pure returns (uint256) {
2379         return uint256(keccak256(abi.encodePacked(_evmScript)));
2380     }
2381 
2382     function _getSig(bytes _data) internal pure returns (bytes4 sig) {
2383         if (_data.length < 4) {
2384             return;
2385         }
2386 
2387         assembly { sig := mload(add(_data, 0x20)) }
2388     }
2389 }
2390 
2391 // File: @aragon/os/contracts/lib/math/SafeMath.sol
2392 
2393 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
2394 // Adapted to use pragma ^0.4.24 and satisfy our linter rules
2395 
2396 pragma solidity ^0.4.24;
2397 
2398 
2399 /**
2400  * @title SafeMath
2401  * @dev Math operations with safety checks that revert on error
2402  */
2403 library SafeMath {
2404     string private constant ERROR_ADD_OVERFLOW = "MATH_ADD_OVERFLOW";
2405     string private constant ERROR_SUB_UNDERFLOW = "MATH_SUB_UNDERFLOW";
2406     string private constant ERROR_MUL_OVERFLOW = "MATH_MUL_OVERFLOW";
2407     string private constant ERROR_DIV_ZERO = "MATH_DIV_ZERO";
2408 
2409     /**
2410     * @dev Multiplies two numbers, reverts on overflow.
2411     */
2412     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
2413         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
2414         // benefit is lost if 'b' is also tested.
2415         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
2416         if (_a == 0) {
2417             return 0;
2418         }
2419 
2420         uint256 c = _a * _b;
2421         require(c / _a == _b, ERROR_MUL_OVERFLOW);
2422 
2423         return c;
2424     }
2425 
2426     /**
2427     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2428     */
2429     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
2430         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
2431         uint256 c = _a / _b;
2432         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2433 
2434         return c;
2435     }
2436 
2437     /**
2438     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2439     */
2440     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
2441         require(_b <= _a, ERROR_SUB_UNDERFLOW);
2442         uint256 c = _a - _b;
2443 
2444         return c;
2445     }
2446 
2447     /**
2448     * @dev Adds two numbers, reverts on overflow.
2449     */
2450     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
2451         uint256 c = _a + _b;
2452         require(c >= _a, ERROR_ADD_OVERFLOW);
2453 
2454         return c;
2455     }
2456 
2457     /**
2458     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2459     * reverts when dividing by zero.
2460     */
2461     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2462         require(b != 0, ERROR_DIV_ZERO);
2463         return a % b;
2464     }
2465 }
2466 
2467 // File: @aragon/os/contracts/lib/math/SafeMath64.sol
2468 
2469 // See https://github.com/OpenZeppelin/openzeppelin-solidity/blob/d51e38758e1d985661534534d5c61e27bece5042/contracts/math/SafeMath.sol
2470 // Adapted for uint64, pragma ^0.4.24, and satisfying our linter rules
2471 // Also optimized the mul() implementation, see https://github.com/aragon/aragonOS/pull/417
2472 
2473 pragma solidity ^0.4.24;
2474 
2475 
2476 /**
2477  * @title SafeMath64
2478  * @dev Math operations for uint64 with safety checks that revert on error
2479  */
2480 library SafeMath64 {
2481     string private constant ERROR_ADD_OVERFLOW = "MATH64_ADD_OVERFLOW";
2482     string private constant ERROR_SUB_UNDERFLOW = "MATH64_SUB_UNDERFLOW";
2483     string private constant ERROR_MUL_OVERFLOW = "MATH64_MUL_OVERFLOW";
2484     string private constant ERROR_DIV_ZERO = "MATH64_DIV_ZERO";
2485 
2486     /**
2487     * @dev Multiplies two numbers, reverts on overflow.
2488     */
2489     function mul(uint64 _a, uint64 _b) internal pure returns (uint64) {
2490         uint256 c = uint256(_a) * uint256(_b);
2491         require(c < 0x010000000000000000, ERROR_MUL_OVERFLOW); // 2**64 (less gas this way)
2492 
2493         return uint64(c);
2494     }
2495 
2496     /**
2497     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
2498     */
2499     function div(uint64 _a, uint64 _b) internal pure returns (uint64) {
2500         require(_b > 0, ERROR_DIV_ZERO); // Solidity only automatically asserts when dividing by 0
2501         uint64 c = _a / _b;
2502         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
2503 
2504         return c;
2505     }
2506 
2507     /**
2508     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
2509     */
2510     function sub(uint64 _a, uint64 _b) internal pure returns (uint64) {
2511         require(_b <= _a, ERROR_SUB_UNDERFLOW);
2512         uint64 c = _a - _b;
2513 
2514         return c;
2515     }
2516 
2517     /**
2518     * @dev Adds two numbers, reverts on overflow.
2519     */
2520     function add(uint64 _a, uint64 _b) internal pure returns (uint64) {
2521         uint64 c = _a + _b;
2522         require(c >= _a, ERROR_ADD_OVERFLOW);
2523 
2524         return c;
2525     }
2526 
2527     /**
2528     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
2529     * reverts when dividing by zero.
2530     */
2531     function mod(uint64 a, uint64 b) internal pure returns (uint64) {
2532         require(b != 0, ERROR_DIV_ZERO);
2533         return a % b;
2534     }
2535 }
2536 
2537 // File: @aragon/apps-voting/contracts/Voting.sol
2538 
2539 /*
2540  * SPDX-License-Identitifer:    GPL-3.0-or-later
2541  */
2542 
2543 pragma solidity 0.4.24;
2544 
2545 
2546 
2547 
2548 
2549 
2550 
2551 contract Voting is IForwarder, AragonApp {
2552     using SafeMath for uint256;
2553     using SafeMath64 for uint64;
2554 
2555     bytes32 public constant CREATE_VOTES_ROLE = keccak256("CREATE_VOTES_ROLE");
2556     bytes32 public constant MODIFY_SUPPORT_ROLE = keccak256("MODIFY_SUPPORT_ROLE");
2557     bytes32 public constant MODIFY_QUORUM_ROLE = keccak256("MODIFY_QUORUM_ROLE");
2558 
2559     uint64 public constant PCT_BASE = 10 ** 18; // 0% = 0; 1% = 10^16; 100% = 10^18
2560 
2561     string private constant ERROR_NO_VOTE = "VOTING_NO_VOTE";
2562     string private constant ERROR_INIT_PCTS = "VOTING_INIT_PCTS";
2563     string private constant ERROR_CHANGE_SUPPORT_PCTS = "VOTING_CHANGE_SUPPORT_PCTS";
2564     string private constant ERROR_CHANGE_QUORUM_PCTS = "VOTING_CHANGE_QUORUM_PCTS";
2565     string private constant ERROR_INIT_SUPPORT_TOO_BIG = "VOTING_INIT_SUPPORT_TOO_BIG";
2566     string private constant ERROR_CHANGE_SUPPORT_TOO_BIG = "VOTING_CHANGE_SUPP_TOO_BIG";
2567     string private constant ERROR_CAN_NOT_VOTE = "VOTING_CAN_NOT_VOTE";
2568     string private constant ERROR_CAN_NOT_EXECUTE = "VOTING_CAN_NOT_EXECUTE";
2569     string private constant ERROR_CAN_NOT_FORWARD = "VOTING_CAN_NOT_FORWARD";
2570     string private constant ERROR_NO_VOTING_POWER = "VOTING_NO_VOTING_POWER";
2571 
2572     enum VoterState { Absent, Yea, Nay }
2573 
2574     struct Vote {
2575         bool executed;
2576         uint64 startDate;
2577         uint64 snapshotBlock;
2578         uint64 supportRequiredPct;
2579         uint64 minAcceptQuorumPct;
2580         uint256 yea;
2581         uint256 nay;
2582         uint256 votingPower;
2583         bytes executionScript;
2584         mapping (address => VoterState) voters;
2585     }
2586 
2587     MiniMeToken public token;
2588     uint64 public supportRequiredPct;
2589     uint64 public minAcceptQuorumPct;
2590     uint64 public voteTime;
2591 
2592     // We are mimicing an array, we use a mapping instead to make app upgrade more graceful
2593     mapping (uint256 => Vote) internal votes;
2594     uint256 public votesLength;
2595 
2596     event StartVote(uint256 indexed voteId, address indexed creator, string metadata);
2597     event CastVote(uint256 indexed voteId, address indexed voter, bool supports, uint256 stake);
2598     event ExecuteVote(uint256 indexed voteId);
2599     event ChangeSupportRequired(uint64 supportRequiredPct);
2600     event ChangeMinQuorum(uint64 minAcceptQuorumPct);
2601 
2602     modifier voteExists(uint256 _voteId) {
2603         require(_voteId < votesLength, ERROR_NO_VOTE);
2604         _;
2605     }
2606 
2607     /**
2608     * @notice Initialize Voting app with `_token.symbol(): string` for governance, minimum support of `@formatPct(_supportRequiredPct)`%, minimum acceptance quorum of `@formatPct(_minAcceptQuorumPct)`%, and a voting duration of `@transformTime(_voteTime)`
2609     * @param _token MiniMeToken Address that will be used as governance token
2610     * @param _supportRequiredPct Percentage of yeas in casted votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2611     * @param _minAcceptQuorumPct Percentage of yeas in total possible votes for a vote to succeed (expressed as a percentage of 10^18; eg. 10^16 = 1%, 10^18 = 100%)
2612     * @param _voteTime Seconds that a vote will be open for token holders to vote (unless enough yeas or nays have been cast to make an early decision)
2613     */
2614     function initialize(
2615         MiniMeToken _token,
2616         uint64 _supportRequiredPct,
2617         uint64 _minAcceptQuorumPct,
2618         uint64 _voteTime
2619     )
2620         external
2621         onlyInit
2622     {
2623         initialized();
2624 
2625         require(_minAcceptQuorumPct <= _supportRequiredPct, ERROR_INIT_PCTS);
2626         require(_supportRequiredPct < PCT_BASE, ERROR_INIT_SUPPORT_TOO_BIG);
2627 
2628         token = _token;
2629         supportRequiredPct = _supportRequiredPct;
2630         minAcceptQuorumPct = _minAcceptQuorumPct;
2631         voteTime = _voteTime;
2632     }
2633 
2634     /**
2635     * @notice Change required support to `@formatPct(_supportRequiredPct)`%
2636     * @param _supportRequiredPct New required support
2637     */
2638     function changeSupportRequiredPct(uint64 _supportRequiredPct)
2639         external
2640         authP(MODIFY_SUPPORT_ROLE, arr(uint256(_supportRequiredPct), uint256(supportRequiredPct)))
2641     {
2642         require(minAcceptQuorumPct <= _supportRequiredPct, ERROR_CHANGE_SUPPORT_PCTS);
2643         require(_supportRequiredPct < PCT_BASE, ERROR_CHANGE_SUPPORT_TOO_BIG);
2644         supportRequiredPct = _supportRequiredPct;
2645 
2646         emit ChangeSupportRequired(_supportRequiredPct);
2647     }
2648 
2649     /**
2650     * @notice Change minimum acceptance quorum to `@formatPct(_minAcceptQuorumPct)`%
2651     * @param _minAcceptQuorumPct New acceptance quorum
2652     */
2653     function changeMinAcceptQuorumPct(uint64 _minAcceptQuorumPct)
2654         external
2655         authP(MODIFY_QUORUM_ROLE, arr(uint256(_minAcceptQuorumPct), uint256(minAcceptQuorumPct)))
2656     {
2657         require(_minAcceptQuorumPct <= supportRequiredPct, ERROR_CHANGE_QUORUM_PCTS);
2658         minAcceptQuorumPct = _minAcceptQuorumPct;
2659 
2660         emit ChangeMinQuorum(_minAcceptQuorumPct);
2661     }
2662 
2663     /**
2664     * @notice Create a new vote about "`_metadata`"
2665     * @param _executionScript EVM script to be executed on approval
2666     * @param _metadata Vote metadata
2667     * @return voteId Id for newly created vote
2668     */
2669     function newVote(bytes _executionScript, string _metadata) external auth(CREATE_VOTES_ROLE) returns (uint256 voteId) {
2670         return _newVote(_executionScript, _metadata, true, true);
2671     }
2672 
2673     /**
2674     * @notice Create a new vote about "`_metadata`"
2675     * @param _executionScript EVM script to be executed on approval
2676     * @param _metadata Vote metadata
2677     * @param _castVote Whether to also cast newly created vote
2678     * @param _executesIfDecided Whether to also immediately execute newly created vote if decided
2679     * @return voteId id for newly created vote
2680     */
2681     function newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
2682         external
2683         auth(CREATE_VOTES_ROLE)
2684         returns (uint256 voteId)
2685     {
2686         return _newVote(_executionScript, _metadata, _castVote, _executesIfDecided);
2687     }
2688 
2689     /**
2690     * @notice Vote `_supports ? 'yes' : 'no'` in vote #`_voteId`
2691     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2692     *      created via `newVote(),` which requires initialization
2693     * @param _voteId Id for vote
2694     * @param _supports Whether voter supports the vote
2695     * @param _executesIfDecided Whether the vote should execute its action if it becomes decided
2696     */
2697     function vote(uint256 _voteId, bool _supports, bool _executesIfDecided) external voteExists(_voteId) {
2698         require(_canVote(_voteId, msg.sender), ERROR_CAN_NOT_VOTE);
2699         _vote(_voteId, _supports, msg.sender, _executesIfDecided);
2700     }
2701 
2702     /**
2703     * @notice Execute vote #`_voteId`
2704     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2705     *      created via `newVote(),` which requires initialization
2706     * @param _voteId Id for vote
2707     */
2708     function executeVote(uint256 _voteId) external voteExists(_voteId) {
2709         _executeVote(_voteId);
2710     }
2711 
2712     // Forwarding fns
2713 
2714     function isForwarder() external pure returns (bool) {
2715         return true;
2716     }
2717 
2718     /**
2719     * @notice Creates a vote to execute the desired action, and casts a support vote if possible
2720     * @dev IForwarder interface conformance
2721     * @param _evmScript Start vote with script
2722     */
2723     function forward(bytes _evmScript) public {
2724         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
2725         _newVote(_evmScript, "", true, true);
2726     }
2727 
2728     function canForward(address _sender, bytes) public view returns (bool) {
2729         // Note that `canPerform()` implicitly does an initialization check itself
2730         return canPerform(_sender, CREATE_VOTES_ROLE, arr());
2731     }
2732 
2733     // Getter fns
2734 
2735     /**
2736     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2737     *      created via `newVote(),` which requires initialization
2738     */
2739     function canExecute(uint256 _voteId) public view voteExists(_voteId) returns (bool) {
2740         return _canExecute(_voteId);
2741     }
2742 
2743     /**
2744     * @dev Initialization check is implicitly provided by `voteExists()` as new votes can only be
2745     *      created via `newVote(),` which requires initialization
2746     */
2747     function canVote(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (bool) {
2748         return _canVote(_voteId, _voter);
2749     }
2750 
2751     function getVote(uint256 _voteId)
2752         public
2753         view
2754         voteExists(_voteId)
2755         returns (
2756             bool open,
2757             bool executed,
2758             uint64 startDate,
2759             uint64 snapshotBlock,
2760             uint64 supportRequired,
2761             uint64 minAcceptQuorum,
2762             uint256 yea,
2763             uint256 nay,
2764             uint256 votingPower,
2765             bytes script
2766         )
2767     {
2768         Vote storage vote_ = votes[_voteId];
2769 
2770         open = _isVoteOpen(vote_);
2771         executed = vote_.executed;
2772         startDate = vote_.startDate;
2773         snapshotBlock = vote_.snapshotBlock;
2774         supportRequired = vote_.supportRequiredPct;
2775         minAcceptQuorum = vote_.minAcceptQuorumPct;
2776         yea = vote_.yea;
2777         nay = vote_.nay;
2778         votingPower = vote_.votingPower;
2779         script = vote_.executionScript;
2780     }
2781 
2782     function getVoterState(uint256 _voteId, address _voter) public view voteExists(_voteId) returns (VoterState) {
2783         return votes[_voteId].voters[_voter];
2784     }
2785 
2786     // Internal fns
2787 
2788     function _newVote(bytes _executionScript, string _metadata, bool _castVote, bool _executesIfDecided)
2789         internal
2790         returns (uint256 voteId)
2791     {
2792         uint64 snapshotBlock = getBlockNumber64() - 1; // avoid double voting in this very block
2793         uint256 votingPower = token.totalSupplyAt(snapshotBlock);
2794         require(votingPower > 0, ERROR_NO_VOTING_POWER);
2795 
2796         voteId = votesLength++;
2797 
2798         Vote storage vote_ = votes[voteId];
2799         vote_.startDate = getTimestamp64();
2800         vote_.snapshotBlock = snapshotBlock;
2801         vote_.supportRequiredPct = supportRequiredPct;
2802         vote_.minAcceptQuorumPct = minAcceptQuorumPct;
2803         vote_.votingPower = votingPower;
2804         vote_.executionScript = _executionScript;
2805 
2806         emit StartVote(voteId, msg.sender, _metadata);
2807 
2808         if (_castVote && _canVote(voteId, msg.sender)) {
2809             _vote(voteId, true, msg.sender, _executesIfDecided);
2810         }
2811     }
2812 
2813     function _vote(
2814         uint256 _voteId,
2815         bool _supports,
2816         address _voter,
2817         bool _executesIfDecided
2818     ) internal
2819     {
2820         Vote storage vote_ = votes[_voteId];
2821 
2822         // This could re-enter, though we can assume the governance token is not malicious
2823         uint256 voterStake = token.balanceOfAt(_voter, vote_.snapshotBlock);
2824         VoterState state = vote_.voters[_voter];
2825 
2826         // If voter had previously voted, decrease count
2827         if (state == VoterState.Yea) {
2828             vote_.yea = vote_.yea.sub(voterStake);
2829         } else if (state == VoterState.Nay) {
2830             vote_.nay = vote_.nay.sub(voterStake);
2831         }
2832 
2833         if (_supports) {
2834             vote_.yea = vote_.yea.add(voterStake);
2835         } else {
2836             vote_.nay = vote_.nay.add(voterStake);
2837         }
2838 
2839         vote_.voters[_voter] = _supports ? VoterState.Yea : VoterState.Nay;
2840 
2841         emit CastVote(_voteId, _voter, _supports, voterStake);
2842 
2843         if (_executesIfDecided && _canExecute(_voteId)) {
2844             // We've already checked if the vote can be executed with `_canExecute()`
2845             _unsafeExecuteVote(_voteId);
2846         }
2847     }
2848 
2849     function _executeVote(uint256 _voteId) internal {
2850         require(_canExecute(_voteId), ERROR_CAN_NOT_EXECUTE);
2851         _unsafeExecuteVote(_voteId);
2852     }
2853 
2854     /**
2855     * @dev Unsafe version of _executeVote that assumes you have already checked if the vote can be executed
2856     */
2857     function _unsafeExecuteVote(uint256 _voteId) internal {
2858         Vote storage vote_ = votes[_voteId];
2859 
2860         vote_.executed = true;
2861 
2862         bytes memory input = new bytes(0); // TODO: Consider input for voting scripts
2863         runScript(vote_.executionScript, input, new address[](0));
2864 
2865         emit ExecuteVote(_voteId);
2866     }
2867 
2868     function _canExecute(uint256 _voteId) internal view returns (bool) {
2869         Vote storage vote_ = votes[_voteId];
2870 
2871         if (vote_.executed) {
2872             return false;
2873         }
2874 
2875         // Voting is already decided
2876         if (_isValuePct(vote_.yea, vote_.votingPower, vote_.supportRequiredPct)) {
2877             return true;
2878         }
2879 
2880         // Vote ended?
2881         if (_isVoteOpen(vote_)) {
2882             return false;
2883         }
2884         // Has enough support?
2885         uint256 totalVotes = vote_.yea.add(vote_.nay);
2886         if (!_isValuePct(vote_.yea, totalVotes, vote_.supportRequiredPct)) {
2887             return false;
2888         }
2889         // Has min quorum?
2890         if (!_isValuePct(vote_.yea, vote_.votingPower, vote_.minAcceptQuorumPct)) {
2891             return false;
2892         }
2893 
2894         return true;
2895     }
2896 
2897     function _canVote(uint256 _voteId, address _voter) internal view returns (bool) {
2898         Vote storage vote_ = votes[_voteId];
2899 
2900         return _isVoteOpen(vote_) && token.balanceOfAt(_voter, vote_.snapshotBlock) > 0;
2901     }
2902 
2903     function _isVoteOpen(Vote storage vote_) internal view returns (bool) {
2904         return getTimestamp64() < vote_.startDate.add(voteTime) && !vote_.executed;
2905     }
2906 
2907     /**
2908     * @dev Calculates whether `_value` is more than a percentage `_pct` of `_total`
2909     */
2910     function _isValuePct(uint256 _value, uint256 _total, uint256 _pct) internal pure returns (bool) {
2911         if (_total == 0) {
2912             return false;
2913         }
2914 
2915         uint256 computedPct = _value.mul(PCT_BASE) / _total;
2916         return computedPct > _pct;
2917     }
2918 }
2919 
2920 // File: @aragon/ppf-contracts/contracts/IFeed.sol
2921 
2922 pragma solidity ^0.4.18;
2923 
2924 interface IFeed {
2925     function ratePrecision() external pure returns (uint256);
2926     function get(address base, address quote) external view returns (uint128 xrt, uint64 when);
2927 }
2928 
2929 // File: @aragon/apps-finance/contracts/Finance.sol
2930 
2931 /*
2932  * SPDX-License-Identitifer:    GPL-3.0-or-later
2933  */
2934 
2935 pragma solidity 0.4.24;
2936 
2937 
2938 
2939 
2940 
2941 
2942 
2943 
2944 
2945 
2946 contract Finance is EtherTokenConstant, IsContract, AragonApp {
2947     using SafeMath for uint256;
2948     using SafeMath64 for uint64;
2949     using SafeERC20 for ERC20;
2950 
2951     bytes32 public constant CREATE_PAYMENTS_ROLE = keccak256("CREATE_PAYMENTS_ROLE");
2952     bytes32 public constant CHANGE_PERIOD_ROLE = keccak256("CHANGE_PERIOD_ROLE");
2953     bytes32 public constant CHANGE_BUDGETS_ROLE = keccak256("CHANGE_BUDGETS_ROLE");
2954     bytes32 public constant EXECUTE_PAYMENTS_ROLE = keccak256("EXECUTE_PAYMENTS_ROLE");
2955     bytes32 public constant MANAGE_PAYMENTS_ROLE = keccak256("MANAGE_PAYMENTS_ROLE");
2956 
2957     uint256 internal constant NO_SCHEDULED_PAYMENT = 0;
2958     uint256 internal constant NO_TRANSACTION = 0;
2959     uint256 internal constant MAX_SCHEDULED_PAYMENTS_PER_TX = 20;
2960     uint256 internal constant MAX_UINT256 = uint256(-1);
2961     uint64 internal constant MAX_UINT64 = uint64(-1);
2962     uint64 internal constant MINIMUM_PERIOD = uint64(1 days);
2963 
2964     string private constant ERROR_COMPLETE_TRANSITION = "FINANCE_COMPLETE_TRANSITION";
2965     string private constant ERROR_NO_SCHEDULED_PAYMENT = "FINANCE_NO_SCHEDULED_PAYMENT";
2966     string private constant ERROR_NO_TRANSACTION = "FINANCE_NO_TRANSACTION";
2967     string private constant ERROR_NO_PERIOD = "FINANCE_NO_PERIOD";
2968     string private constant ERROR_VAULT_NOT_CONTRACT = "FINANCE_VAULT_NOT_CONTRACT";
2969     string private constant ERROR_SET_PERIOD_TOO_SHORT = "FINANCE_SET_PERIOD_TOO_SHORT";
2970     string private constant ERROR_NEW_PAYMENT_AMOUNT_ZERO = "FINANCE_NEW_PAYMENT_AMOUNT_ZERO";
2971     string private constant ERROR_NEW_PAYMENT_INTERVAL_ZERO = "FINANCE_NEW_PAYMENT_INTRVL_ZERO";
2972     string private constant ERROR_NEW_PAYMENT_EXECS_ZERO = "FINANCE_NEW_PAYMENT_EXECS_ZERO";
2973     string private constant ERROR_NEW_PAYMENT_IMMEDIATE = "FINANCE_NEW_PAYMENT_IMMEDIATE";
2974     string private constant ERROR_RECOVER_AMOUNT_ZERO = "FINANCE_RECOVER_AMOUNT_ZERO";
2975     string private constant ERROR_DEPOSIT_AMOUNT_ZERO = "FINANCE_DEPOSIT_AMOUNT_ZERO";
2976     string private constant ERROR_ETH_VALUE_MISMATCH = "FINANCE_ETH_VALUE_MISMATCH";
2977     string private constant ERROR_BUDGET = "FINANCE_BUDGET";
2978     string private constant ERROR_EXECUTE_PAYMENT_NUM = "FINANCE_EXECUTE_PAYMENT_NUM";
2979     string private constant ERROR_EXECUTE_PAYMENT_TIME = "FINANCE_EXECUTE_PAYMENT_TIME";
2980     string private constant ERROR_PAYMENT_RECEIVER = "FINANCE_PAYMENT_RECEIVER";
2981     string private constant ERROR_TOKEN_TRANSFER_FROM_REVERTED = "FINANCE_TKN_TRANSFER_FROM_REVERT";
2982     string private constant ERROR_TOKEN_APPROVE_FAILED = "FINANCE_TKN_APPROVE_FAILED";
2983     string private constant ERROR_PAYMENT_INACTIVE = "FINANCE_PAYMENT_INACTIVE";
2984     string private constant ERROR_REMAINING_BUDGET = "FINANCE_REMAINING_BUDGET";
2985 
2986     // Order optimized for storage
2987     struct ScheduledPayment {
2988         address token;
2989         address receiver;
2990         address createdBy;
2991         bool inactive;
2992         uint256 amount;
2993         uint64 initialPaymentTime;
2994         uint64 interval;
2995         uint64 maxExecutions;
2996         uint64 executions;
2997     }
2998 
2999     // Order optimized for storage
3000     struct Transaction {
3001         address token;
3002         address entity;
3003         bool isIncoming;
3004         uint256 amount;
3005         uint256 paymentId;
3006         uint64 paymentExecutionNumber;
3007         uint64 date;
3008         uint64 periodId;
3009     }
3010 
3011     struct TokenStatement {
3012         uint256 expenses;
3013         uint256 income;
3014     }
3015 
3016     struct Period {
3017         uint64 startTime;
3018         uint64 endTime;
3019         uint256 firstTransactionId;
3020         uint256 lastTransactionId;
3021         mapping (address => TokenStatement) tokenStatement;
3022     }
3023 
3024     struct Settings {
3025         uint64 periodDuration;
3026         mapping (address => uint256) budgets;
3027         mapping (address => bool) hasBudget;
3028     }
3029 
3030     Vault public vault;
3031     Settings internal settings;
3032 
3033     // We are mimicing arrays, we use mappings instead to make app upgrade more graceful
3034     mapping (uint256 => ScheduledPayment) internal scheduledPayments;
3035     // Payments start at index 1, to allow us to use scheduledPayments[0] for transactions that are not
3036     // linked to a scheduled payment
3037     uint256 public paymentsNextIndex;
3038 
3039     mapping (uint256 => Transaction) internal transactions;
3040     uint256 public transactionsNextIndex;
3041 
3042     mapping (uint64 => Period) internal periods;
3043     uint64 public periodsLength;
3044 
3045     event NewPeriod(uint64 indexed periodId, uint64 periodStarts, uint64 periodEnds);
3046     event SetBudget(address indexed token, uint256 amount, bool hasBudget);
3047     event NewPayment(uint256 indexed paymentId, address indexed recipient, uint64 maxExecutions, string reference);
3048     event NewTransaction(uint256 indexed transactionId, bool incoming, address indexed entity, uint256 amount, string reference);
3049     event ChangePaymentState(uint256 indexed paymentId, bool active);
3050     event ChangePeriodDuration(uint64 newDuration);
3051     event PaymentFailure(uint256 paymentId);
3052 
3053     // Modifier used by all methods that impact accounting to make sure accounting period
3054     // is changed before the operation if needed
3055     // NOTE: its use **MUST** be accompanied by an initialization check
3056     modifier transitionsPeriod {
3057         bool completeTransition = _tryTransitionAccountingPeriod(getMaxPeriodTransitions());
3058         require(completeTransition, ERROR_COMPLETE_TRANSITION);
3059         _;
3060     }
3061 
3062     modifier scheduledPaymentExists(uint256 _paymentId) {
3063         require(_paymentId > 0 && _paymentId < paymentsNextIndex, ERROR_NO_SCHEDULED_PAYMENT);
3064         _;
3065     }
3066 
3067     modifier transactionExists(uint256 _transactionId) {
3068         require(_transactionId > 0 && _transactionId < transactionsNextIndex, ERROR_NO_TRANSACTION);
3069         _;
3070     }
3071 
3072     modifier periodExists(uint64 _periodId) {
3073         require(_periodId < periodsLength, ERROR_NO_PERIOD);
3074         _;
3075     }
3076 
3077     /**
3078      * @notice Deposit ETH to the Vault, to avoid locking them in this Finance app forever
3079      * @dev Send ETH to Vault. Send all the available balance.
3080      */
3081     function () external payable isInitialized transitionsPeriod {
3082         require(msg.value > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
3083         _deposit(
3084             ETH,
3085             msg.value,
3086             "Ether transfer to Finance app",
3087             msg.sender,
3088             true
3089         );
3090     }
3091 
3092     /**
3093     * @notice Initialize Finance app for Vault at `_vault` with period length of `@transformTime(_periodDuration)`
3094     * @param _vault Address of the vault Finance will rely on (non changeable)
3095     * @param _periodDuration Duration in seconds of each period
3096     */
3097     function initialize(Vault _vault, uint64 _periodDuration) external onlyInit {
3098         initialized();
3099 
3100         require(isContract(_vault), ERROR_VAULT_NOT_CONTRACT);
3101         vault = _vault;
3102 
3103         require(_periodDuration >= MINIMUM_PERIOD, ERROR_SET_PERIOD_TOO_SHORT);
3104         settings.periodDuration = _periodDuration;
3105 
3106         // Reserve the first scheduled payment index as an unused index for transactions not linked
3107         // to a scheduled payment
3108         scheduledPayments[0].inactive = true;
3109         paymentsNextIndex = 1;
3110 
3111         // Reserve the first transaction index as an unused index for periods with no transactions
3112         transactionsNextIndex = 1;
3113 
3114         // Start the first period
3115         _newPeriod(getTimestamp64());
3116     }
3117 
3118     /**
3119     * @notice Deposit `@tokenAmount(_token, _amount)`
3120     * @dev Deposit for approved ERC20 tokens or ETH
3121     * @param _token Address of deposited token
3122     * @param _amount Amount of tokens sent
3123     * @param _reference Reason for payment
3124     */
3125     function deposit(address _token, uint256 _amount, string _reference) external payable isInitialized transitionsPeriod {
3126         require(_amount > 0, ERROR_DEPOSIT_AMOUNT_ZERO);
3127         if (_token == ETH) {
3128             // Ensure that the ETH sent with the transaction equals the amount in the deposit
3129             require(msg.value == _amount, ERROR_ETH_VALUE_MISMATCH);
3130         }
3131 
3132         _deposit(
3133             _token,
3134             _amount,
3135             _reference,
3136             msg.sender,
3137             true
3138         );
3139     }
3140 
3141     /**
3142     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver` for '`_reference`'
3143     * @dev Note that this function is protected by the `CREATE_PAYMENTS_ROLE` but uses `MAX_UINT256`
3144     *      as its interval auth parameter (as a sentinel value for "never repeating").
3145     *      While this protects against most cases (you typically want to set a baseline requirement
3146     *      for interval time), it does mean users will have to explicitly check for this case when
3147     *      granting a permission that includes a upperbound requirement on the interval time.
3148     * @param _token Address of token for payment
3149     * @param _receiver Address that will receive payment
3150     * @param _amount Tokens that are paid every time the payment is due
3151     * @param _reference String detailing payment reason
3152     */
3153     function newImmediatePayment(address _token, address _receiver, uint256 _amount, string _reference)
3154         external
3155         // Use MAX_UINT256 as the interval parameter, as this payment will never repeat
3156         // Payment time parameter is left as the last param as it was added later
3157         authP(CREATE_PAYMENTS_ROLE, _arr(_token, _receiver, _amount, MAX_UINT256, uint256(1), getTimestamp()))
3158         transitionsPeriod
3159     {
3160         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
3161 
3162         _makePaymentTransaction(
3163             _token,
3164             _receiver,
3165             _amount,
3166             NO_SCHEDULED_PAYMENT,   // unrelated to any payment id; it isn't created
3167             0,   // also unrelated to any payment executions
3168             _reference
3169         );
3170     }
3171 
3172     /**
3173     * @notice Create a new payment of `@tokenAmount(_token, _amount)` to `_receiver` for `_reference`, executing `_maxExecutions` times at intervals of `@transformTime(_interval)`
3174     * @dev See `newImmediatePayment()` for limitations on how the interval auth parameter can be used
3175     * @param _token Address of token for payment
3176     * @param _receiver Address that will receive payment
3177     * @param _amount Tokens that are paid every time the payment is due
3178     * @param _initialPaymentTime Timestamp for when the first payment is done
3179     * @param _interval Number of seconds that need to pass between payment transactions
3180     * @param _maxExecutions Maximum instances a payment can be executed
3181     * @param _reference String detailing payment reason
3182     */
3183     function newScheduledPayment(
3184         address _token,
3185         address _receiver,
3186         uint256 _amount,
3187         uint64 _initialPaymentTime,
3188         uint64 _interval,
3189         uint64 _maxExecutions,
3190         string _reference
3191     )
3192         external
3193         // Payment time parameter is left as the last param as it was added later
3194         authP(CREATE_PAYMENTS_ROLE, _arr(_token, _receiver, _amount, uint256(_interval), uint256(_maxExecutions), uint256(_initialPaymentTime)))
3195         transitionsPeriod
3196         returns (uint256 paymentId)
3197     {
3198         require(_amount > 0, ERROR_NEW_PAYMENT_AMOUNT_ZERO);
3199         require(_interval > 0, ERROR_NEW_PAYMENT_INTERVAL_ZERO);
3200         require(_maxExecutions > 0, ERROR_NEW_PAYMENT_EXECS_ZERO);
3201 
3202         // Token budget must not be set at all or allow at least one instance of this payment each period
3203         require(!settings.hasBudget[_token] || settings.budgets[_token] >= _amount, ERROR_BUDGET);
3204 
3205         // Don't allow creating single payments that are immediately executable, use `newImmediatePayment()` instead
3206         if (_maxExecutions == 1) {
3207             require(_initialPaymentTime > getTimestamp64(), ERROR_NEW_PAYMENT_IMMEDIATE);
3208         }
3209 
3210         paymentId = paymentsNextIndex++;
3211         emit NewPayment(paymentId, _receiver, _maxExecutions, _reference);
3212 
3213         ScheduledPayment storage payment = scheduledPayments[paymentId];
3214         payment.token = _token;
3215         payment.receiver = _receiver;
3216         payment.amount = _amount;
3217         payment.initialPaymentTime = _initialPaymentTime;
3218         payment.interval = _interval;
3219         payment.maxExecutions = _maxExecutions;
3220         payment.createdBy = msg.sender;
3221 
3222         // We skip checking how many times the new payment was executed to allow creating new
3223         // scheduled payments before having enough vault balance
3224         _executePayment(paymentId);
3225     }
3226 
3227     /**
3228     * @notice Change period duration to `@transformTime(_periodDuration)`, effective for next accounting period
3229     * @param _periodDuration Duration in seconds for accounting periods
3230     */
3231     function setPeriodDuration(uint64 _periodDuration)
3232         external
3233         authP(CHANGE_PERIOD_ROLE, arr(uint256(_periodDuration), uint256(settings.periodDuration)))
3234         transitionsPeriod
3235     {
3236         require(_periodDuration >= MINIMUM_PERIOD, ERROR_SET_PERIOD_TOO_SHORT);
3237         settings.periodDuration = _periodDuration;
3238         emit ChangePeriodDuration(_periodDuration);
3239     }
3240 
3241     /**
3242     * @notice Set budget for `_token.symbol(): string` to `@tokenAmount(_token, _amount, false)`, effective immediately
3243     * @param _token Address for token
3244     * @param _amount New budget amount
3245     */
3246     function setBudget(
3247         address _token,
3248         uint256 _amount
3249     )
3250         external
3251         authP(CHANGE_BUDGETS_ROLE, arr(_token, _amount, settings.budgets[_token], uint256(settings.hasBudget[_token] ? 1 : 0)))
3252         transitionsPeriod
3253     {
3254         settings.budgets[_token] = _amount;
3255         if (!settings.hasBudget[_token]) {
3256             settings.hasBudget[_token] = true;
3257         }
3258         emit SetBudget(_token, _amount, true);
3259     }
3260 
3261     /**
3262     * @notice Remove spending limit for `_token.symbol(): string`, effective immediately
3263     * @param _token Address for token
3264     */
3265     function removeBudget(address _token)
3266         external
3267         authP(CHANGE_BUDGETS_ROLE, arr(_token, uint256(0), settings.budgets[_token], uint256(settings.hasBudget[_token] ? 1 : 0)))
3268         transitionsPeriod
3269     {
3270         settings.budgets[_token] = 0;
3271         settings.hasBudget[_token] = false;
3272         emit SetBudget(_token, 0, false);
3273     }
3274 
3275     /**
3276     * @notice Execute pending payment #`_paymentId`
3277     * @dev Executes any payment (requires role)
3278     * @param _paymentId Identifier for payment
3279     */
3280     function executePayment(uint256 _paymentId)
3281         external
3282         authP(EXECUTE_PAYMENTS_ROLE, arr(_paymentId, scheduledPayments[_paymentId].amount))
3283         scheduledPaymentExists(_paymentId)
3284         transitionsPeriod
3285     {
3286         _executePaymentAtLeastOnce(_paymentId);
3287     }
3288 
3289     /**
3290     * @notice Execute pending payment #`_paymentId`
3291     * @dev Always allow receiver of a payment to trigger execution
3292     *      Initialization check is implicitly provided by `scheduledPaymentExists()` as new
3293     *      scheduled payments can only be created via `newScheduledPayment(),` which requires initialization
3294     * @param _paymentId Identifier for payment
3295     */
3296     function receiverExecutePayment(uint256 _paymentId) external scheduledPaymentExists(_paymentId) transitionsPeriod {
3297         require(scheduledPayments[_paymentId].receiver == msg.sender, ERROR_PAYMENT_RECEIVER);
3298         _executePaymentAtLeastOnce(_paymentId);
3299     }
3300 
3301     /**
3302     * @notice `_active ? 'Activate' : 'Disable'` payment #`_paymentId`
3303     * @dev Note that we do not require this action to transition periods, as it doesn't directly
3304     *      impact any accounting periods.
3305     *      Not having to transition periods also makes disabling payments easier to prevent funds
3306     *      from being pulled out in the event of a breach.
3307     * @param _paymentId Identifier for payment
3308     * @param _active Whether it will be active or inactive
3309     */
3310     function setPaymentStatus(uint256 _paymentId, bool _active)
3311         external
3312         authP(MANAGE_PAYMENTS_ROLE, arr(_paymentId, uint256(_active ? 1 : 0)))
3313         scheduledPaymentExists(_paymentId)
3314     {
3315         scheduledPayments[_paymentId].inactive = !_active;
3316         emit ChangePaymentState(_paymentId, _active);
3317     }
3318 
3319     /**
3320      * @notice Send tokens held in this contract to the Vault
3321      * @dev Allows making a simple payment from this contract to the Vault, to avoid locked tokens.
3322      *      This contract should never receive tokens with a simple transfer call, but in case it
3323      *      happens, this function allows for their recovery.
3324      * @param _token Token whose balance is going to be transferred.
3325      */
3326     function recoverToVault(address _token) external isInitialized transitionsPeriod {
3327         uint256 amount = _token == ETH ? address(this).balance : ERC20(_token).staticBalanceOf(address(this));
3328         require(amount > 0, ERROR_RECOVER_AMOUNT_ZERO);
3329 
3330         _deposit(
3331             _token,
3332             amount,
3333             "Recover to Vault",
3334             address(this),
3335             false
3336         );
3337     }
3338 
3339     /**
3340     * @notice Transition accounting period if needed
3341     * @dev Transitions accounting periods if needed. For preventing OOG attacks, a maxTransitions
3342     *      param is provided. If more than the specified number of periods need to be transitioned,
3343     *      it will return false.
3344     * @param _maxTransitions Maximum periods that can be transitioned
3345     * @return success Boolean indicating whether the accounting period is the correct one (if false,
3346     *                 maxTransitions was surpased and another call is needed)
3347     */
3348     function tryTransitionAccountingPeriod(uint64 _maxTransitions) external isInitialized returns (bool success) {
3349         return _tryTransitionAccountingPeriod(_maxTransitions);
3350     }
3351 
3352     // Getter fns
3353 
3354     /**
3355     * @dev Disable recovery escape hatch if the app has been initialized, as it could be used
3356     *      maliciously to transfer funds in the Finance app to another Vault
3357     *      finance#recoverToVault() should be used to recover funds to the Finance's vault
3358     */
3359     function allowRecoverability(address) public view returns (bool) {
3360         return !hasInitialized();
3361     }
3362 
3363     function getPayment(uint256 _paymentId)
3364         public
3365         view
3366         scheduledPaymentExists(_paymentId)
3367         returns (
3368             address token,
3369             address receiver,
3370             uint256 amount,
3371             uint64 initialPaymentTime,
3372             uint64 interval,
3373             uint64 maxExecutions,
3374             bool inactive,
3375             uint64 executions,
3376             address createdBy
3377         )
3378     {
3379         ScheduledPayment storage payment = scheduledPayments[_paymentId];
3380 
3381         token = payment.token;
3382         receiver = payment.receiver;
3383         amount = payment.amount;
3384         initialPaymentTime = payment.initialPaymentTime;
3385         interval = payment.interval;
3386         maxExecutions = payment.maxExecutions;
3387         executions = payment.executions;
3388         inactive = payment.inactive;
3389         createdBy = payment.createdBy;
3390     }
3391 
3392     function getTransaction(uint256 _transactionId)
3393         public
3394         view
3395         transactionExists(_transactionId)
3396         returns (
3397             uint64 periodId,
3398             uint256 amount,
3399             uint256 paymentId,
3400             uint64 paymentExecutionNumber,
3401             address token,
3402             address entity,
3403             bool isIncoming,
3404             uint64 date
3405         )
3406     {
3407         Transaction storage transaction = transactions[_transactionId];
3408 
3409         token = transaction.token;
3410         entity = transaction.entity;
3411         isIncoming = transaction.isIncoming;
3412         date = transaction.date;
3413         periodId = transaction.periodId;
3414         amount = transaction.amount;
3415         paymentId = transaction.paymentId;
3416         paymentExecutionNumber = transaction.paymentExecutionNumber;
3417     }
3418 
3419     function getPeriod(uint64 _periodId)
3420         public
3421         view
3422         periodExists(_periodId)
3423         returns (
3424             bool isCurrent,
3425             uint64 startTime,
3426             uint64 endTime,
3427             uint256 firstTransactionId,
3428             uint256 lastTransactionId
3429         )
3430     {
3431         Period storage period = periods[_periodId];
3432 
3433         isCurrent = _currentPeriodId() == _periodId;
3434 
3435         startTime = period.startTime;
3436         endTime = period.endTime;
3437         firstTransactionId = period.firstTransactionId;
3438         lastTransactionId = period.lastTransactionId;
3439     }
3440 
3441     function getPeriodTokenStatement(uint64 _periodId, address _token)
3442         public
3443         view
3444         periodExists(_periodId)
3445         returns (uint256 expenses, uint256 income)
3446     {
3447         TokenStatement storage tokenStatement = periods[_periodId].tokenStatement[_token];
3448         expenses = tokenStatement.expenses;
3449         income = tokenStatement.income;
3450     }
3451 
3452     /**
3453     * @dev We have to check for initialization as periods are only valid after initializing
3454     */
3455     function currentPeriodId() public view isInitialized returns (uint64) {
3456         return _currentPeriodId();
3457     }
3458 
3459     /**
3460     * @dev We have to check for initialization as periods are only valid after initializing
3461     */
3462     function getPeriodDuration() public view isInitialized returns (uint64) {
3463         return settings.periodDuration;
3464     }
3465 
3466     /**
3467     * @dev We have to check for initialization as budgets are only valid after initializing
3468     */
3469     function getBudget(address _token) public view isInitialized returns (uint256 budget, bool hasBudget) {
3470         budget = settings.budgets[_token];
3471         hasBudget = settings.hasBudget[_token];
3472     }
3473 
3474     /**
3475     * @dev We have to check for initialization as budgets are only valid after initializing
3476     */
3477     function getRemainingBudget(address _token) public view isInitialized returns (uint256) {
3478         return _getRemainingBudget(_token);
3479     }
3480 
3481     /**
3482     * @dev We have to check for initialization as budgets are only valid after initializing
3483     */
3484     function canMakePayment(address _token, uint256 _amount) public view isInitialized returns (bool) {
3485         return _canMakePayment(_token, _amount);
3486     }
3487 
3488     /**
3489     * @dev Initialization check is implicitly provided by `scheduledPaymentExists()` as new
3490     *      scheduled payments can only be created via `newScheduledPayment(),` which requires initialization
3491     */
3492     function nextPaymentTime(uint256 _paymentId) public view scheduledPaymentExists(_paymentId) returns (uint64) {
3493         return _nextPaymentTime(_paymentId);
3494     }
3495 
3496     // Internal fns
3497 
3498     function _deposit(address _token, uint256 _amount, string _reference, address _sender, bool _isExternalDeposit) internal {
3499         _recordIncomingTransaction(
3500             _token,
3501             _sender,
3502             _amount,
3503             _reference
3504         );
3505 
3506         if (_token == ETH) {
3507             vault.deposit.value(_amount)(ETH, _amount);
3508         } else {
3509             // First, transfer the tokens to Finance if necessary
3510             // External deposit will be false when the assets were already in the Finance app
3511             // and just need to be transferred to the Vault
3512             if (_isExternalDeposit) {
3513                 // This assumes the sender has approved the tokens for Finance
3514                 require(
3515                     ERC20(_token).safeTransferFrom(msg.sender, address(this), _amount),
3516                     ERROR_TOKEN_TRANSFER_FROM_REVERTED
3517                 );
3518             }
3519             // Approve the tokens for the Vault (it does the actual transferring)
3520             require(ERC20(_token).safeApprove(vault, _amount), ERROR_TOKEN_APPROVE_FAILED);
3521             // Finally, initiate the deposit
3522             vault.deposit(_token, _amount);
3523         }
3524     }
3525 
3526     function _executePayment(uint256 _paymentId) internal returns (uint256) {
3527         ScheduledPayment storage payment = scheduledPayments[_paymentId];
3528         require(!payment.inactive, ERROR_PAYMENT_INACTIVE);
3529 
3530         uint64 paid = 0;
3531         while (_nextPaymentTime(_paymentId) <= getTimestamp64() && paid < MAX_SCHEDULED_PAYMENTS_PER_TX) {
3532             if (!_canMakePayment(payment.token, payment.amount)) {
3533                 emit PaymentFailure(_paymentId);
3534                 break;
3535             }
3536 
3537             // The while() predicate prevents these two from ever overflowing
3538             payment.executions += 1;
3539             paid += 1;
3540 
3541             // We've already checked the remaining budget with `_canMakePayment()`
3542             _unsafeMakePaymentTransaction(
3543                 payment.token,
3544                 payment.receiver,
3545                 payment.amount,
3546                 _paymentId,
3547                 payment.executions,
3548                 ""
3549             );
3550         }
3551 
3552         return paid;
3553     }
3554 
3555     function _executePaymentAtLeastOnce(uint256 _paymentId) internal {
3556         uint256 paid = _executePayment(_paymentId);
3557         if (paid == 0) {
3558             if (_nextPaymentTime(_paymentId) <= getTimestamp64()) {
3559                 revert(ERROR_EXECUTE_PAYMENT_NUM);
3560             } else {
3561                 revert(ERROR_EXECUTE_PAYMENT_TIME);
3562             }
3563         }
3564     }
3565 
3566     function _makePaymentTransaction(
3567         address _token,
3568         address _receiver,
3569         uint256 _amount,
3570         uint256 _paymentId,
3571         uint64 _paymentExecutionNumber,
3572         string _reference
3573     )
3574         internal
3575     {
3576         require(_getRemainingBudget(_token) >= _amount, ERROR_REMAINING_BUDGET);
3577         _unsafeMakePaymentTransaction(_token, _receiver, _amount, _paymentId, _paymentExecutionNumber, _reference);
3578     }
3579 
3580     /**
3581     * @dev Unsafe version of _makePaymentTransaction that assumes you have already checked the
3582     *      remaining budget
3583     */
3584     function _unsafeMakePaymentTransaction(
3585         address _token,
3586         address _receiver,
3587         uint256 _amount,
3588         uint256 _paymentId,
3589         uint64 _paymentExecutionNumber,
3590         string _reference
3591     )
3592         internal
3593     {
3594         _recordTransaction(
3595             false,
3596             _token,
3597             _receiver,
3598             _amount,
3599             _paymentId,
3600             _paymentExecutionNumber,
3601             _reference
3602         );
3603 
3604         vault.transfer(_token, _receiver, _amount);
3605     }
3606 
3607     function _newPeriod(uint64 _startTime) internal returns (Period storage) {
3608         // There should be no way for this to overflow since each period is at least one day
3609         uint64 newPeriodId = periodsLength++;
3610 
3611         Period storage period = periods[newPeriodId];
3612         period.startTime = _startTime;
3613 
3614         // Be careful here to not overflow; if startTime + periodDuration overflows, we set endTime
3615         // to MAX_UINT64 (let's assume that's the end of time for now).
3616         uint64 endTime = _startTime + settings.periodDuration - 1;
3617         if (endTime < _startTime) { // overflowed
3618             endTime = MAX_UINT64;
3619         }
3620         period.endTime = endTime;
3621 
3622         emit NewPeriod(newPeriodId, period.startTime, period.endTime);
3623 
3624         return period;
3625     }
3626 
3627     function _recordIncomingTransaction(
3628         address _token,
3629         address _sender,
3630         uint256 _amount,
3631         string _reference
3632     )
3633         internal
3634     {
3635         _recordTransaction(
3636             true, // incoming transaction
3637             _token,
3638             _sender,
3639             _amount,
3640             NO_SCHEDULED_PAYMENT, // unrelated to any existing payment
3641             0, // and no payment executions
3642             _reference
3643         );
3644     }
3645 
3646     function _recordTransaction(
3647         bool _incoming,
3648         address _token,
3649         address _entity,
3650         uint256 _amount,
3651         uint256 _paymentId,
3652         uint64 _paymentExecutionNumber,
3653         string _reference
3654     )
3655         internal
3656     {
3657         uint64 periodId = _currentPeriodId();
3658         TokenStatement storage tokenStatement = periods[periodId].tokenStatement[_token];
3659         if (_incoming) {
3660             tokenStatement.income = tokenStatement.income.add(_amount);
3661         } else {
3662             tokenStatement.expenses = tokenStatement.expenses.add(_amount);
3663         }
3664 
3665         uint256 transactionId = transactionsNextIndex++;
3666 
3667         Transaction storage transaction = transactions[transactionId];
3668         transaction.token = _token;
3669         transaction.entity = _entity;
3670         transaction.isIncoming = _incoming;
3671         transaction.amount = _amount;
3672         transaction.paymentId = _paymentId;
3673         transaction.paymentExecutionNumber = _paymentExecutionNumber;
3674         transaction.date = getTimestamp64();
3675         transaction.periodId = periodId;
3676 
3677         Period storage period = periods[periodId];
3678         if (period.firstTransactionId == NO_TRANSACTION) {
3679             period.firstTransactionId = transactionId;
3680         }
3681 
3682         emit NewTransaction(transactionId, _incoming, _entity, _amount, _reference);
3683     }
3684 
3685     function _tryTransitionAccountingPeriod(uint64 _maxTransitions) internal returns (bool success) {
3686         Period storage currentPeriod = periods[_currentPeriodId()];
3687         uint64 timestamp = getTimestamp64();
3688 
3689         // Transition periods if necessary
3690         while (timestamp > currentPeriod.endTime) {
3691             if (_maxTransitions == 0) {
3692                 // Required number of transitions is over allowed number, return false indicating
3693                 // it didn't fully transition
3694                 return false;
3695             }
3696             // We're already protected from underflowing above
3697             _maxTransitions -= 1;
3698 
3699             // If there were any transactions in period, record which was the last
3700             // In case 0 transactions occured, first and last tx id will be 0
3701             if (currentPeriod.firstTransactionId != NO_TRANSACTION) {
3702                 currentPeriod.lastTransactionId = transactionsNextIndex.sub(1);
3703             }
3704 
3705             // New period starts at end time + 1
3706             currentPeriod = _newPeriod(currentPeriod.endTime.add(1));
3707         }
3708 
3709         return true;
3710     }
3711 
3712     function _canMakePayment(address _token, uint256 _amount) internal view returns (bool) {
3713         return _getRemainingBudget(_token) >= _amount && vault.balance(_token) >= _amount;
3714     }
3715 
3716     function _currentPeriodId() internal view returns (uint64) {
3717         // There is no way for this to overflow if protected by an initialization check
3718         return periodsLength - 1;
3719     }
3720 
3721     function _getRemainingBudget(address _token) internal view returns (uint256) {
3722         if (!settings.hasBudget[_token]) {
3723             return MAX_UINT256;
3724         }
3725 
3726         uint256 budget = settings.budgets[_token];
3727         uint256 spent = periods[_currentPeriodId()].tokenStatement[_token].expenses;
3728 
3729         // A budget decrease can cause the spent amount to be greater than period budget
3730         // If so, return 0 to not allow more spending during period
3731         if (spent >= budget) {
3732             return 0;
3733         }
3734 
3735         // We're already protected from the overflow above
3736         return budget - spent;
3737     }
3738 
3739     function _nextPaymentTime(uint256 _paymentId) internal view returns (uint64) {
3740         ScheduledPayment storage payment = scheduledPayments[_paymentId];
3741 
3742         if (payment.executions >= payment.maxExecutions) {
3743             return MAX_UINT64; // re-executes in some billions of years time... should not need to worry
3744         }
3745 
3746         // Split in multiple lines to circumvent linter warning
3747         uint64 increase = payment.executions.mul(payment.interval);
3748         uint64 nextPayment = payment.initialPaymentTime.add(increase);
3749         return nextPayment;
3750     }
3751 
3752     // Syntax sugar
3753 
3754     function _arr(address _a, address _b, uint256 _c, uint256 _d, uint256 _e, uint256 _f) internal pure returns (uint256[] r) {
3755         r = new uint256[](6);
3756         r[0] = uint256(_a);
3757         r[1] = uint256(_b);
3758         r[2] = _c;
3759         r[3] = _d;
3760         r[4] = _e;
3761         r[5] = _f;
3762     }
3763 
3764     // Mocked fns (overrided during testing)
3765     // Must be view for mocking purposes
3766 
3767     function getMaxPeriodTransitions() internal view returns (uint64) { return MAX_UINT64; }
3768 }
3769 
3770 // File: @aragon/apps-payroll/contracts/Payroll.sol
3771 
3772 pragma solidity 0.4.24;
3773 
3774 
3775 
3776 
3777 
3778 
3779 
3780 
3781 
3782 
3783 /**
3784  * @title Payroll in multiple currencies
3785  */
3786 contract Payroll is EtherTokenConstant, IForwarder, IsContract, AragonApp {
3787     using SafeMath for uint256;
3788     using SafeMath64 for uint64;
3789 
3790     /* Hardcoded constants to save gas
3791     * bytes32 constant public ADD_EMPLOYEE_ROLE = keccak256("ADD_EMPLOYEE_ROLE");
3792     * bytes32 constant public TERMINATE_EMPLOYEE_ROLE = keccak256("TERMINATE_EMPLOYEE_ROLE");
3793     * bytes32 constant public SET_EMPLOYEE_SALARY_ROLE = keccak256("SET_EMPLOYEE_SALARY_ROLE");
3794     * bytes32 constant public ADD_BONUS_ROLE = keccak256("ADD_BONUS_ROLE");
3795     * bytes32 constant public ADD_REIMBURSEMENT_ROLE = keccak256("ADD_REIMBURSEMENT_ROLE");
3796     * bytes32 constant public MANAGE_ALLOWED_TOKENS_ROLE = keccak256("MANAGE_ALLOWED_TOKENS_ROLE");
3797     * bytes32 constant public MODIFY_PRICE_FEED_ROLE = keccak256("MODIFY_PRICE_FEED_ROLE");
3798     * bytes32 constant public MODIFY_RATE_EXPIRY_ROLE = keccak256("MODIFY_RATE_EXPIRY_ROLE");
3799     */
3800 
3801     bytes32 constant public ADD_EMPLOYEE_ROLE = 0x9ecdc3c63716b45d0756eece5fe1614cae1889ec5a1ce62b3127c1f1f1615d6e;
3802     bytes32 constant public TERMINATE_EMPLOYEE_ROLE = 0x69c67f914d12b6440e7ddf01961214818d9158fbcb19211e0ff42800fdea9242;
3803     bytes32 constant public SET_EMPLOYEE_SALARY_ROLE = 0xea9ac65018da2421cf419ee2152371440c08267a193a33ccc1e39545d197e44d;
3804     bytes32 constant public ADD_BONUS_ROLE = 0xceca7e2f5eb749a87aaf68f3f76d6b9251aa2f4600f13f93c5a4adf7a72df4ae;
3805     bytes32 constant public ADD_REIMBURSEMENT_ROLE = 0x90698b9d54427f1e41636025017309bdb1b55320da960c8845bab0a504b01a16;
3806     bytes32 constant public MANAGE_ALLOWED_TOKENS_ROLE = 0x0be34987c45700ee3fae8c55e270418ba903337decc6bacb1879504be9331c06;
3807     bytes32 constant public MODIFY_PRICE_FEED_ROLE = 0x74350efbcba8b85341c5bbf70cc34e2a585fc1463524773a12fa0a71d4eb9302;
3808     bytes32 constant public MODIFY_RATE_EXPIRY_ROLE = 0x79fe989a8899060dfbdabb174ebb96616fa9f1d9dadd739f8d814cbab452404e;
3809 
3810     uint256 internal constant MAX_ALLOWED_TOKENS = 20; // prevent OOG issues with `payday()`
3811     uint64 internal constant MIN_RATE_EXPIRY = uint64(1 minutes); // 1 min == ~4 block window to mine both a price feed update and a payout
3812 
3813     uint256 internal constant MAX_UINT256 = uint256(-1);
3814     uint64 internal constant MAX_UINT64 = uint64(-1);
3815 
3816     string private constant ERROR_EMPLOYEE_DOESNT_EXIST = "PAYROLL_EMPLOYEE_DOESNT_EXIST";
3817     string private constant ERROR_NON_ACTIVE_EMPLOYEE = "PAYROLL_NON_ACTIVE_EMPLOYEE";
3818     string private constant ERROR_SENDER_DOES_NOT_MATCH = "PAYROLL_SENDER_DOES_NOT_MATCH";
3819     string private constant ERROR_FINANCE_NOT_CONTRACT = "PAYROLL_FINANCE_NOT_CONTRACT";
3820     string private constant ERROR_TOKEN_ALREADY_SET = "PAYROLL_TOKEN_ALREADY_SET";
3821     string private constant ERROR_MAX_ALLOWED_TOKENS = "PAYROLL_MAX_ALLOWED_TOKENS";
3822     string private constant ERROR_MIN_RATES_MISMATCH = "PAYROLL_MIN_RATES_MISMATCH";
3823     string private constant ERROR_TOKEN_ALLOCATION_MISMATCH = "PAYROLL_TOKEN_ALLOCATION_MISMATCH";
3824     string private constant ERROR_NOT_ALLOWED_TOKEN = "PAYROLL_NOT_ALLOWED_TOKEN";
3825     string private constant ERROR_DISTRIBUTION_NOT_FULL = "PAYROLL_DISTRIBUTION_NOT_FULL";
3826     string private constant ERROR_INVALID_PAYMENT_TYPE = "PAYROLL_INVALID_PAYMENT_TYPE";
3827     string private constant ERROR_NOTHING_PAID = "PAYROLL_NOTHING_PAID";
3828     string private constant ERROR_CAN_NOT_FORWARD = "PAYROLL_CAN_NOT_FORWARD";
3829     string private constant ERROR_EMPLOYEE_NULL_ADDRESS = "PAYROLL_EMPLOYEE_NULL_ADDRESS";
3830     string private constant ERROR_EMPLOYEE_ALREADY_EXIST = "PAYROLL_EMPLOYEE_ALREADY_EXIST";
3831     string private constant ERROR_FEED_NOT_CONTRACT = "PAYROLL_FEED_NOT_CONTRACT";
3832     string private constant ERROR_EXPIRY_TIME_TOO_SHORT = "PAYROLL_EXPIRY_TIME_TOO_SHORT";
3833     string private constant ERROR_PAST_TERMINATION_DATE = "PAYROLL_PAST_TERMINATION_DATE";
3834     string private constant ERROR_EXCHANGE_RATE_TOO_LOW = "PAYROLL_EXCHANGE_RATE_TOO_LOW";
3835     string private constant ERROR_LAST_PAYROLL_DATE_TOO_BIG = "PAYROLL_LAST_DATE_TOO_BIG";
3836     string private constant ERROR_INVALID_REQUESTED_AMOUNT = "PAYROLL_INVALID_REQUESTED_AMT";
3837 
3838     enum PaymentType { Payroll, Reimbursement, Bonus }
3839 
3840     struct Employee {
3841         address accountAddress; // unique, but can be changed over time
3842         uint256 denominationTokenSalary; // salary per second in denomination Token
3843         uint256 accruedSalary; // keep track of any leftover accrued salary when changing salaries
3844         uint256 bonus;
3845         uint256 reimbursements;
3846         uint64 lastPayroll;
3847         uint64 endDate;
3848         address[] allocationTokenAddresses;
3849         mapping(address => uint256) allocationTokens;
3850     }
3851 
3852     Finance public finance;
3853     address public denominationToken;
3854     IFeed public feed;
3855     uint64 public rateExpiryTime;
3856 
3857     // Employees start at index 1, to allow us to use employees[0] to check for non-existent employees
3858     uint256 public nextEmployee;
3859     mapping(uint256 => Employee) internal employees;     // employee ID -> employee
3860     mapping(address => uint256) internal employeeIds;    // employee address -> employee ID
3861 
3862     mapping(address => bool) internal allowedTokens;
3863 
3864     event AddEmployee(
3865         uint256 indexed employeeId,
3866         address indexed accountAddress,
3867         uint256 initialDenominationSalary,
3868         uint64 startDate,
3869         string role
3870     );
3871     event TerminateEmployee(uint256 indexed employeeId, uint64 endDate);
3872     event SetEmployeeSalary(uint256 indexed employeeId, uint256 denominationSalary);
3873     event AddEmployeeAccruedSalary(uint256 indexed employeeId, uint256 amount);
3874     event AddEmployeeBonus(uint256 indexed employeeId, uint256 amount);
3875     event AddEmployeeReimbursement(uint256 indexed employeeId, uint256 amount);
3876     event ChangeAddressByEmployee(uint256 indexed employeeId, address indexed newAccountAddress, address indexed oldAccountAddress);
3877     event DetermineAllocation(uint256 indexed employeeId);
3878     event SendPayment(
3879         uint256 indexed employeeId,
3880         address indexed accountAddress,
3881         address indexed token,
3882         uint256 amount,
3883         uint256 exchangeRate,
3884         string paymentReference
3885     );
3886     event SetAllowedToken(address indexed token, bool allowed);
3887     event SetPriceFeed(address indexed feed);
3888     event SetRateExpiryTime(uint64 time);
3889 
3890     // Check employee exists by ID
3891     modifier employeeIdExists(uint256 _employeeId) {
3892         require(_employeeExists(_employeeId), ERROR_EMPLOYEE_DOESNT_EXIST);
3893         _;
3894     }
3895 
3896     // Check employee exists and is still active
3897     modifier employeeActive(uint256 _employeeId) {
3898         // No need to check for existence as _isEmployeeIdActive() is false for non-existent employees
3899         require(_isEmployeeIdActive(_employeeId), ERROR_NON_ACTIVE_EMPLOYEE);
3900         _;
3901     }
3902 
3903     // Check sender matches an existing employee
3904     modifier employeeMatches {
3905         require(employees[employeeIds[msg.sender]].accountAddress == msg.sender, ERROR_SENDER_DOES_NOT_MATCH);
3906         _;
3907     }
3908 
3909     /**
3910      * @notice Initialize Payroll app for Finance at `_finance` and price feed at `_priceFeed`, setting denomination token to `_token` and exchange rate expiry time to `@transformTime(_rateExpiryTime)`
3911      * @dev Note that we do not require _denominationToken to be a contract, as it may be a "fake"
3912      *      address used by the price feed to denominate fiat currencies
3913      * @param _finance Address of the Finance app this Payroll app will rely on for payments (non-changeable)
3914      * @param _denominationToken Address of the denomination token used for salary accounting
3915      * @param _priceFeed Address of the price feed
3916      * @param _rateExpiryTime Acceptable expiry time in seconds for the price feed's exchange rates
3917      */
3918     function initialize(Finance _finance, address _denominationToken, IFeed _priceFeed, uint64 _rateExpiryTime) external onlyInit {
3919         initialized();
3920 
3921         require(isContract(_finance), ERROR_FINANCE_NOT_CONTRACT);
3922         finance = _finance;
3923 
3924         denominationToken = _denominationToken;
3925         _setPriceFeed(_priceFeed);
3926         _setRateExpiryTime(_rateExpiryTime);
3927 
3928         // Employees start at index 1, to allow us to use employees[0] to check for non-existent employees
3929         nextEmployee = 1;
3930     }
3931 
3932     /**
3933      * @notice `_allowed ? 'Add' : 'Remove'` `_token.symbol(): string` `_allowed ? 'to' : 'from'` the set of allowed tokens
3934      * @param _token Address of the token to be added or removed from the list of allowed tokens for payments
3935      * @param _allowed Boolean to tell whether the given token should be added or removed from the list
3936      */
3937     function setAllowedToken(address _token, bool _allowed) external authP(MANAGE_ALLOWED_TOKENS_ROLE, arr(_token)) {
3938         require(allowedTokens[_token] != _allowed, ERROR_TOKEN_ALREADY_SET);
3939         allowedTokens[_token] = _allowed;
3940         emit SetAllowedToken(_token, _allowed);
3941     }
3942 
3943     /**
3944      * @notice Set the price feed for exchange rates to `_feed`
3945      * @param _feed Address of the new price feed instance
3946      */
3947     function setPriceFeed(IFeed _feed) external authP(MODIFY_PRICE_FEED_ROLE, arr(_feed, feed)) {
3948         _setPriceFeed(_feed);
3949     }
3950 
3951     /**
3952      * @notice Set the acceptable expiry time for the price feed's exchange rates to `@transformTime(_time)`
3953      * @dev Exchange rates older than the given value won't be accepted for payments and will cause payouts to revert
3954      * @param _time The expiration time in seconds for exchange rates
3955      */
3956     function setRateExpiryTime(uint64 _time) external authP(MODIFY_RATE_EXPIRY_ROLE, arr(uint256(_time), uint256(rateExpiryTime))) {
3957         _setRateExpiryTime(_time);
3958     }
3959 
3960     /**
3961      * @notice Add employee with address `_accountAddress` to payroll with an salary of `_initialDenominationSalary` per second, starting on `@formatDate(_startDate)`
3962      * @param _accountAddress Employee's address to receive payroll
3963      * @param _initialDenominationSalary Employee's salary, per second in denomination token
3964      * @param _startDate Employee's starting timestamp in seconds (it actually sets their initial lastPayroll value)
3965      * @param _role Employee's role
3966      */
3967     function addEmployee(address _accountAddress, uint256 _initialDenominationSalary, uint64 _startDate, string _role)
3968         external
3969         authP(ADD_EMPLOYEE_ROLE, arr(_accountAddress, _initialDenominationSalary, uint256(_startDate)))
3970     {
3971         _addEmployee(_accountAddress, _initialDenominationSalary, _startDate, _role);
3972     }
3973 
3974     /**
3975      * @notice Add `_amount` to bonus for employee #`_employeeId`
3976      * @param _employeeId Employee's identifier
3977      * @param _amount Amount to be added to the employee's bonuses in denomination token
3978      */
3979     function addBonus(uint256 _employeeId, uint256 _amount)
3980         external
3981         authP(ADD_BONUS_ROLE, arr(_employeeId, _amount))
3982         employeeActive(_employeeId)
3983     {
3984         _addBonus(_employeeId, _amount);
3985     }
3986 
3987     /**
3988      * @notice Add `_amount` to reimbursements for employee #`_employeeId`
3989      * @param _employeeId Employee's identifier
3990      * @param _amount Amount to be added to the employee's reimbursements in denomination token
3991      */
3992     function addReimbursement(uint256 _employeeId, uint256 _amount)
3993         external
3994         authP(ADD_REIMBURSEMENT_ROLE, arr(_employeeId, _amount))
3995         employeeActive(_employeeId)
3996     {
3997         _addReimbursement(_employeeId, _amount);
3998     }
3999 
4000     /**
4001      * @notice Set employee #`_employeeId`'s salary to `_denominationSalary` per second
4002      * @dev This reverts if either the employee's owed salary or accrued salary overflows, to avoid
4003      *      losing any accrued salary for an employee due to the employer changing their salary.
4004      * @param _employeeId Employee's identifier
4005      * @param _denominationSalary Employee's new salary, per second in denomination token
4006      */
4007     function setEmployeeSalary(uint256 _employeeId, uint256 _denominationSalary)
4008         external
4009         authP(SET_EMPLOYEE_SALARY_ROLE, arr(_employeeId, _denominationSalary, employees[_employeeId].denominationTokenSalary))
4010         employeeActive(_employeeId)
4011     {
4012         Employee storage employee = employees[_employeeId];
4013 
4014         // Accrue employee's owed salary; don't cap to revert on overflow
4015         uint256 owed = _getOwedSalarySinceLastPayroll(employee, false);
4016         _addAccruedSalary(_employeeId, owed);
4017 
4018         // Update employee to track the new salary and payment date
4019         employee.lastPayroll = getTimestamp64();
4020         employee.denominationTokenSalary = _denominationSalary;
4021 
4022         emit SetEmployeeSalary(_employeeId, _denominationSalary);
4023     }
4024 
4025     /**
4026      * @notice Terminate employee #`_employeeId` on `@formatDate(_endDate)`
4027      * @param _employeeId Employee's identifier
4028      * @param _endDate Termination timestamp in seconds
4029      */
4030     function terminateEmployee(uint256 _employeeId, uint64 _endDate)
4031         external
4032         authP(TERMINATE_EMPLOYEE_ROLE, arr(_employeeId, uint256(_endDate)))
4033         employeeActive(_employeeId)
4034     {
4035         _terminateEmployee(_employeeId, _endDate);
4036     }
4037 
4038     /**
4039      * @notice Change your employee account address to `_newAccountAddress`
4040      * @dev Initialization check is implicitly provided by `employeeMatches` as new employees can
4041      *      only be added via `addEmployee(),` which requires initialization.
4042      *      As the employee is allowed to call this, we enforce non-reentrancy.
4043      * @param _newAccountAddress New address to receive payments for the requesting employee
4044      */
4045     function changeAddressByEmployee(address _newAccountAddress) external employeeMatches nonReentrant {
4046         uint256 employeeId = employeeIds[msg.sender];
4047         address oldAddress = employees[employeeId].accountAddress;
4048 
4049         _setEmployeeAddress(employeeId, _newAccountAddress);
4050         // Don't delete the old address until after setting the new address to check that the
4051         // employee specified a new address
4052         delete employeeIds[oldAddress];
4053 
4054         emit ChangeAddressByEmployee(employeeId, _newAccountAddress, oldAddress);
4055     }
4056 
4057     /**
4058      * @notice Set the token distribution for your payments
4059      * @dev Initialization check is implicitly provided by `employeeMatches` as new employees can
4060      *      only be added via `addEmployee(),` which requires initialization.
4061      *      As the employee is allowed to call this, we enforce non-reentrancy.
4062      * @param _tokens Array of token addresses; they must belong to the list of allowed tokens
4063      * @param _distribution Array with each token's corresponding proportions (must be integers summing to 100)
4064      */
4065     function determineAllocation(address[] _tokens, uint256[] _distribution) external employeeMatches nonReentrant {
4066         // Check array lengthes match
4067         require(_tokens.length <= MAX_ALLOWED_TOKENS, ERROR_MAX_ALLOWED_TOKENS);
4068         require(_tokens.length == _distribution.length, ERROR_TOKEN_ALLOCATION_MISMATCH);
4069 
4070         uint256 employeeId = employeeIds[msg.sender];
4071         Employee storage employee = employees[employeeId];
4072 
4073         // Delete previous token allocations
4074         address[] memory previousAllowedTokenAddresses = employee.allocationTokenAddresses;
4075         for (uint256 j = 0; j < previousAllowedTokenAddresses.length; j++) {
4076             delete employee.allocationTokens[previousAllowedTokenAddresses[j]];
4077         }
4078         delete employee.allocationTokenAddresses;
4079 
4080         // Set distributions only if given tokens are allowed
4081         for (uint256 i = 0; i < _tokens.length; i++) {
4082             employee.allocationTokenAddresses.push(_tokens[i]);
4083             employee.allocationTokens[_tokens[i]] = _distribution[i];
4084         }
4085 
4086         _ensureEmployeeTokenAllocationsIsValid(employee);
4087         emit DetermineAllocation(employeeId);
4088     }
4089 
4090     /**
4091      * @notice Request your `_type == 0 ? 'salary' : _type == 1 ? 'reimbursements' : 'bonus'`
4092      * @dev Reverts if no payments were made.
4093      *      Initialization check is implicitly provided by `employeeMatches` as new employees can
4094      *      only be added via `addEmployee(),` which requires initialization.
4095      *      As the employee is allowed to call this, we enforce non-reentrancy.
4096      * @param _type Payment type being requested (Payroll, Reimbursement or Bonus)
4097      * @param _requestedAmount Requested amount to pay for the payment type. Must be less than or equal to total owed amount for the payment type, or zero to request all.
4098      * @param _minRates Array of employee's minimum acceptable rates for their allowed payment tokens
4099      */
4100     function payday(PaymentType _type, uint256 _requestedAmount, uint256[] _minRates) external employeeMatches nonReentrant {
4101         uint256 paymentAmount;
4102         uint256 employeeId = employeeIds[msg.sender];
4103         Employee storage employee = employees[employeeId];
4104         _ensureEmployeeTokenAllocationsIsValid(employee);
4105         require(_minRates.length == 0 || _minRates.length == employee.allocationTokenAddresses.length, ERROR_MIN_RATES_MISMATCH);
4106 
4107         // Do internal employee accounting
4108         if (_type == PaymentType.Payroll) {
4109             // Salary is capped here to avoid reverting at this point if it becomes too big
4110             // (so employees aren't DDOSed if their salaries get too large)
4111             // If we do use a capped value, the employee's lastPayroll date will be adjusted accordingly
4112             uint256 totalOwedSalary = _getTotalOwedCappedSalary(employee);
4113             paymentAmount = _ensurePaymentAmount(totalOwedSalary, _requestedAmount);
4114             _updateEmployeeAccountingBasedOnPaidSalary(employee, paymentAmount);
4115         } else if (_type == PaymentType.Reimbursement) {
4116             uint256 owedReimbursements = employee.reimbursements;
4117             paymentAmount = _ensurePaymentAmount(owedReimbursements, _requestedAmount);
4118             employee.reimbursements = owedReimbursements.sub(paymentAmount);
4119         } else if (_type == PaymentType.Bonus) {
4120             uint256 owedBonusAmount = employee.bonus;
4121             paymentAmount = _ensurePaymentAmount(owedBonusAmount, _requestedAmount);
4122             employee.bonus = owedBonusAmount.sub(paymentAmount);
4123         } else {
4124             revert(ERROR_INVALID_PAYMENT_TYPE);
4125         }
4126 
4127         // Actually transfer the owed funds
4128         require(_transferTokensAmount(employeeId, _type, paymentAmount, _minRates), ERROR_NOTHING_PAID);
4129         _removeEmployeeIfTerminatedAndPaidOut(employeeId);
4130     }
4131 
4132     // Forwarding fns
4133 
4134     /**
4135      * @dev IForwarder interface conformance. Tells whether the Payroll app is a forwarder or not.
4136      * @return Always true
4137      */
4138     function isForwarder() external pure returns (bool) {
4139         return true;
4140     }
4141 
4142     /**
4143      * @notice Execute desired action as an active employee
4144      * @dev IForwarder interface conformance. Allows active employees to run EVMScripts in the context of the Payroll app.
4145      * @param _evmScript Script being executed
4146      */
4147     function forward(bytes _evmScript) public {
4148         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
4149         bytes memory input = new bytes(0); // TODO: Consider input for this
4150 
4151         // Add the Finance app to the blacklist to disallow employees from executing actions on the
4152         // Finance app from Payroll's context (since Payroll requires permissions on Finance)
4153         address[] memory blacklist = new address[](1);
4154         blacklist[0] = address(finance);
4155 
4156         runScript(_evmScript, input, blacklist);
4157     }
4158 
4159     /**
4160      * @dev IForwarder interface conformance. Tells whether a given address can forward actions or not.
4161      * @param _sender Address of the account intending to forward an action
4162      * @return True if the given address is an active employee, false otherwise
4163      */
4164     function canForward(address _sender, bytes) public view returns (bool) {
4165         return _isEmployeeIdActive(employeeIds[_sender]);
4166     }
4167 
4168     // Getter fns
4169 
4170     /**
4171      * @dev Return employee's identifier by their account address
4172      * @param _accountAddress Employee's address to receive payments
4173      * @return Employee's identifier
4174      */
4175     function getEmployeeIdByAddress(address _accountAddress) public view returns (uint256) {
4176         require(employeeIds[_accountAddress] != uint256(0), ERROR_EMPLOYEE_DOESNT_EXIST);
4177         return employeeIds[_accountAddress];
4178     }
4179 
4180     /**
4181      * @dev Return all information for employee by their ID
4182      * @param _employeeId Employee's identifier
4183      * @return Employee's address to receive payments
4184      * @return Employee's salary, per second in denomination token
4185      * @return Employee's accrued salary
4186      * @return Employee's bonus amount
4187      * @return Employee's reimbursements amount
4188      * @return Employee's last payment date
4189      * @return Employee's termination date (max uint64 if none)
4190      * @return Employee's allowed payment tokens
4191      */
4192     function getEmployee(uint256 _employeeId)
4193         public
4194         view
4195         employeeIdExists(_employeeId)
4196         returns (
4197             address accountAddress,
4198             uint256 denominationSalary,
4199             uint256 accruedSalary,
4200             uint256 bonus,
4201             uint256 reimbursements,
4202             uint64 lastPayroll,
4203             uint64 endDate,
4204             address[] allocationTokens
4205         )
4206     {
4207         Employee storage employee = employees[_employeeId];
4208 
4209         accountAddress = employee.accountAddress;
4210         denominationSalary = employee.denominationTokenSalary;
4211         accruedSalary = employee.accruedSalary;
4212         bonus = employee.bonus;
4213         reimbursements = employee.reimbursements;
4214         lastPayroll = employee.lastPayroll;
4215         endDate = employee.endDate;
4216         allocationTokens = employee.allocationTokenAddresses;
4217     }
4218 
4219     /**
4220      * @dev Get owed salary since last payroll for an employee. It will take into account the accrued salary as well.
4221      *      The result will be capped to max uint256 to avoid having an overflow.
4222      * @return Employee's total owed salary: current owed payroll since the last payroll date, plus the accrued salary.
4223      */
4224     function getTotalOwedSalary(uint256 _employeeId) public view employeeIdExists(_employeeId) returns (uint256) {
4225         return _getTotalOwedCappedSalary(employees[_employeeId]);
4226     }
4227 
4228     /**
4229      * @dev Get an employee's payment allocation for a token
4230      * @param _employeeId Employee's identifier
4231      * @param _token Token to query the payment allocation for
4232      * @return Employee's payment allocation for the token being queried
4233      */
4234     function getAllocation(uint256 _employeeId, address _token) public view employeeIdExists(_employeeId) returns (uint256) {
4235         return employees[_employeeId].allocationTokens[_token];
4236     }
4237 
4238     /**
4239      * @dev Check if a token is allowed to be used for payments
4240      * @param _token Address of the token to be checked
4241      * @return True if the given token is allowed, false otherwise
4242      */
4243     function isTokenAllowed(address _token) public view isInitialized returns (bool) {
4244         return allowedTokens[_token];
4245     }
4246 
4247     // Internal fns
4248 
4249     /**
4250      * @dev Set the price feed used for exchange rates
4251      * @param _feed Address of the new price feed instance
4252      */
4253     function _setPriceFeed(IFeed _feed) internal {
4254         require(isContract(_feed), ERROR_FEED_NOT_CONTRACT);
4255         feed = _feed;
4256         emit SetPriceFeed(feed);
4257     }
4258 
4259     /**
4260      * @dev Set the exchange rate expiry time in seconds.
4261      *      Exchange rates older than the given value won't be accepted for payments and will cause
4262      *      payouts to revert.
4263      * @param _time The expiration time in seconds for exchange rates
4264      */
4265     function _setRateExpiryTime(uint64 _time) internal {
4266         // Require a sane minimum for the rate expiry time
4267         require(_time >= MIN_RATE_EXPIRY, ERROR_EXPIRY_TIME_TOO_SHORT);
4268         rateExpiryTime = _time;
4269         emit SetRateExpiryTime(rateExpiryTime);
4270     }
4271 
4272     /**
4273      * @dev Add a new employee to Payroll
4274      * @param _accountAddress Employee's address to receive payroll
4275      * @param _initialDenominationSalary Employee's salary, per second in denomination token
4276      * @param _startDate Employee's starting timestamp in seconds
4277      * @param _role Employee's role
4278      */
4279     function _addEmployee(address _accountAddress, uint256 _initialDenominationSalary, uint64 _startDate, string _role) internal {
4280         uint256 employeeId = nextEmployee++;
4281 
4282         _setEmployeeAddress(employeeId, _accountAddress);
4283 
4284         Employee storage employee = employees[employeeId];
4285         employee.denominationTokenSalary = _initialDenominationSalary;
4286         employee.lastPayroll = _startDate;
4287         employee.endDate = MAX_UINT64;
4288 
4289         emit AddEmployee(employeeId, _accountAddress, _initialDenominationSalary, _startDate, _role);
4290     }
4291 
4292     /**
4293      * @dev Add amount to an employee's bonuses
4294      * @param _employeeId Employee's identifier
4295      * @param _amount Amount be added to the employee's bonuses in denomination token
4296      */
4297     function _addBonus(uint256 _employeeId, uint256 _amount) internal {
4298         Employee storage employee = employees[_employeeId];
4299         employee.bonus = employee.bonus.add(_amount);
4300         emit AddEmployeeBonus(_employeeId, _amount);
4301     }
4302 
4303     /**
4304      * @dev Add amount to an employee's reimbursements
4305      * @param _employeeId Employee's identifier
4306      * @param _amount Amount be added to the employee's reimbursements in denomination token
4307      */
4308     function _addReimbursement(uint256 _employeeId, uint256 _amount) internal {
4309         Employee storage employee = employees[_employeeId];
4310         employee.reimbursements = employee.reimbursements.add(_amount);
4311         emit AddEmployeeReimbursement(_employeeId, _amount);
4312     }
4313 
4314     /**
4315      * @dev Add amount to an employee's accrued salary
4316      * @param _employeeId Employee's identifier
4317      * @param _amount Amount be added to the employee's accrued salary in denomination token
4318      */
4319     function _addAccruedSalary(uint256 _employeeId, uint256 _amount) internal {
4320         Employee storage employee = employees[_employeeId];
4321         employee.accruedSalary = employee.accruedSalary.add(_amount);
4322         emit AddEmployeeAccruedSalary(_employeeId, _amount);
4323     }
4324 
4325     /**
4326      * @dev Set an employee's account address
4327      * @param _employeeId Employee's identifier
4328      * @param _accountAddress Employee's address to receive payroll
4329      */
4330     function _setEmployeeAddress(uint256 _employeeId, address _accountAddress) internal {
4331         // Check address is non-null
4332         require(_accountAddress != address(0), ERROR_EMPLOYEE_NULL_ADDRESS);
4333         // Check address isn't already being used
4334         require(employeeIds[_accountAddress] == uint256(0), ERROR_EMPLOYEE_ALREADY_EXIST);
4335 
4336         employees[_employeeId].accountAddress = _accountAddress;
4337 
4338         // Create IDs mapping
4339         employeeIds[_accountAddress] = _employeeId;
4340     }
4341 
4342     /**
4343      * @dev Terminate employee on end date
4344      * @param _employeeId Employee's identifier
4345      * @param _endDate Termination timestamp in seconds
4346      */
4347     function _terminateEmployee(uint256 _employeeId, uint64 _endDate) internal {
4348         // Prevent past termination dates
4349         require(_endDate >= getTimestamp64(), ERROR_PAST_TERMINATION_DATE);
4350         employees[_employeeId].endDate = _endDate;
4351         emit TerminateEmployee(_employeeId, _endDate);
4352     }
4353 
4354     /**
4355      * @dev Loop over allowed tokens to send requested amount to the employee in their desired allocation
4356      * @param _employeeId Employee's identifier
4357      * @param _totalAmount Total amount to be transferred to the employee distributed in accordance to the employee's token allocation.
4358      * @param _type Payment type being transferred (Payroll, Reimbursement or Bonus)
4359      * @param _minRates Array of employee's minimum acceptable rates for their allowed payment tokens
4360      * @return True if there was at least one token transfer
4361      */
4362     function _transferTokensAmount(uint256 _employeeId, PaymentType _type, uint256 _totalAmount, uint256[] _minRates) internal returns (bool somethingPaid) {
4363         if (_totalAmount == 0) {
4364             return false;
4365         }
4366 
4367         Employee storage employee = employees[_employeeId];
4368         address employeeAddress = employee.accountAddress;
4369         string memory paymentReference = _paymentReferenceFor(_type);
4370 
4371         address[] storage allocationTokenAddresses = employee.allocationTokenAddresses;
4372         for (uint256 i = 0; i < allocationTokenAddresses.length; i++) {
4373             address token = allocationTokenAddresses[i];
4374             uint256 tokenAllocation = employee.allocationTokens[token];
4375             if (tokenAllocation != uint256(0)) {
4376                 // Get the exchange rate for the payout token in denomination token,
4377                 // as we do accounting in denomination tokens
4378                 uint256 exchangeRate = _getExchangeRateInDenominationToken(token);
4379                 require(_minRates.length > 0 ? exchangeRate >= _minRates[i] : exchangeRate > 0, ERROR_EXCHANGE_RATE_TOO_LOW);
4380 
4381                 // Convert amount (in denomination tokens) to payout token and apply allocation
4382                 uint256 tokenAmount = _totalAmount.mul(exchangeRate).mul(tokenAllocation);
4383                 // Divide by 100 for the allocation percentage and by the exchange rate precision
4384                 tokenAmount = tokenAmount.div(100).div(feed.ratePrecision());
4385 
4386                 // Finance reverts if the payment wasn't possible
4387                 finance.newImmediatePayment(token, employeeAddress, tokenAmount, paymentReference);
4388                 emit SendPayment(_employeeId, employeeAddress, token, tokenAmount, exchangeRate, paymentReference);
4389                 somethingPaid = true;
4390             }
4391         }
4392     }
4393 
4394     /**
4395      * @dev Remove employee if there are no owed funds and employee's end date has been reached
4396      * @param _employeeId Employee's identifier
4397      */
4398     function _removeEmployeeIfTerminatedAndPaidOut(uint256 _employeeId) internal {
4399         Employee storage employee = employees[_employeeId];
4400 
4401         if (
4402             employee.lastPayroll == employee.endDate &&
4403             (employee.accruedSalary == 0 && employee.bonus == 0 && employee.reimbursements == 0)
4404         ) {
4405             delete employeeIds[employee.accountAddress];
4406             delete employees[_employeeId];
4407         }
4408     }
4409 
4410     /**
4411      * @dev Updates the accrued salary and payroll date of an employee based on a payment amount and
4412      *      their currently owed salary since last payroll date
4413      * @param _employee Employee struct in storage
4414      * @param _paymentAmount Amount being paid to the employee
4415      */
4416     function _updateEmployeeAccountingBasedOnPaidSalary(Employee storage _employee, uint256 _paymentAmount) internal {
4417         uint256 accruedSalary = _employee.accruedSalary;
4418 
4419         if (_paymentAmount <= accruedSalary) {
4420             // Employee is only cashing out some previously owed salary so we don't need to update
4421             // their last payroll date
4422             // No need to use SafeMath as we already know _paymentAmount <= accruedSalary
4423             _employee.accruedSalary = accruedSalary - _paymentAmount;
4424             return;
4425         }
4426 
4427         // Employee is cashing out some of their currently owed salary so their last payroll date
4428         // needs to be modified based on the amount of salary paid
4429         uint256 currentSalaryPaid = _paymentAmount;
4430         if (accruedSalary > 0) {
4431             // Employee is cashing out a mixed amount between previous and current owed salaries;
4432             // first use up their accrued salary
4433             // No need to use SafeMath here as we already know _paymentAmount > accruedSalary
4434             currentSalaryPaid = _paymentAmount - accruedSalary;
4435             // We finally need to clear their accrued salary
4436             _employee.accruedSalary = 0;
4437         }
4438 
4439         uint256 salary = _employee.denominationTokenSalary;
4440         uint256 timeDiff = currentSalaryPaid.div(salary);
4441 
4442         // If they're being paid an amount that doesn't match perfectly with the adjusted time
4443         // (up to a seconds' worth of salary), add the second and put the extra remaining salary
4444         // into their accrued salary
4445         uint256 extraSalary = currentSalaryPaid % salary;
4446         if (extraSalary > 0) {
4447             timeDiff = timeDiff.add(1);
4448             _employee.accruedSalary = salary - extraSalary;
4449         }
4450 
4451         uint256 lastPayrollDate = uint256(_employee.lastPayroll).add(timeDiff);
4452         // Even though this function should never receive a currentSalaryPaid value that would
4453         // result in the lastPayrollDate being higher than the current time,
4454         // let's double check to be safe
4455         require(lastPayrollDate <= uint256(getTimestamp64()), ERROR_LAST_PAYROLL_DATE_TOO_BIG);
4456         // Already know lastPayrollDate must fit in uint64 from above
4457         _employee.lastPayroll = uint64(lastPayrollDate);
4458     }
4459 
4460     /**
4461      * @dev Tell whether an employee is registered in this Payroll or not
4462      * @param _employeeId Employee's identifier
4463      * @return True if the given employee ID belongs to an registered employee, false otherwise
4464      */
4465     function _employeeExists(uint256 _employeeId) internal view returns (bool) {
4466         return employees[_employeeId].accountAddress != address(0);
4467     }
4468 
4469     /**
4470      * @dev Tell whether an employee has a valid token allocation or not.
4471      *      A valid allocation is one that sums to 100 and only includes allowed tokens.
4472      * @param _employee Employee struct in storage
4473      * @return Reverts if employee's allocation is invalid
4474      */
4475     function _ensureEmployeeTokenAllocationsIsValid(Employee storage _employee) internal view {
4476         uint256 sum = 0;
4477         address[] memory allocationTokenAddresses = _employee.allocationTokenAddresses;
4478         for (uint256 i = 0; i < allocationTokenAddresses.length; i++) {
4479             address token = allocationTokenAddresses[i];
4480             require(allowedTokens[token], ERROR_NOT_ALLOWED_TOKEN);
4481             sum = sum.add(_employee.allocationTokens[token]);
4482         }
4483         require(sum == 100, ERROR_DISTRIBUTION_NOT_FULL);
4484     }
4485 
4486     /**
4487      * @dev Tell whether an employee is still active or not
4488      * @param _employee Employee struct in storage
4489      * @return True if the employee exists and has an end date that has not been reached yet, false otherwise
4490      */
4491     function _isEmployeeActive(Employee storage _employee) internal view returns (bool) {
4492         return _employee.endDate >= getTimestamp64();
4493     }
4494 
4495     /**
4496      * @dev Tell whether an employee id is still active or not
4497      * @param _employeeId Employee's identifier
4498      * @return True if the employee exists and has an end date that has not been reached yet, false otherwise
4499      */
4500     function _isEmployeeIdActive(uint256 _employeeId) internal view returns (bool) {
4501         return _isEmployeeActive(employees[_employeeId]);
4502     }
4503 
4504     /**
4505      * @dev Get exchange rate for a token based on the denomination token.
4506      *      As an example, if the denomination token was USD and ETH's price was 100USD,
4507      *      this would return 0.01 * precision rate for ETH.
4508      * @param _token Token to get price of in denomination tokens
4509      * @return Exchange rate (multiplied by the PPF rate precision)
4510      */
4511     function _getExchangeRateInDenominationToken(address _token) internal view returns (uint256) {
4512         // xrt is the number of `_token` that can be exchanged for one `denominationToken`
4513         (uint128 xrt, uint64 when) = feed.get(
4514             denominationToken,  // Base (e.g. USD)
4515             _token              // Quote (e.g. ETH)
4516         );
4517 
4518         // Check the price feed is recent enough
4519         if (getTimestamp64().sub(when) >= rateExpiryTime) {
4520             return 0;
4521         }
4522 
4523         return uint256(xrt);
4524     }
4525 
4526     /**
4527      * @dev Get owed salary since last payroll for an employee
4528      * @param _employee Employee struct in storage
4529      * @param _capped Safely cap the owed salary at max uint
4530      * @return Owed salary in denomination tokens since last payroll for the employee.
4531      *         If _capped is false, it reverts in case of an overflow.
4532      */
4533     function _getOwedSalarySinceLastPayroll(Employee storage _employee, bool _capped) internal view returns (uint256) {
4534         uint256 timeDiff = _getOwedPayrollPeriod(_employee);
4535         if (timeDiff == 0) {
4536             return 0;
4537         }
4538         uint256 salary = _employee.denominationTokenSalary;
4539 
4540         if (_capped) {
4541             // Return max uint if the result overflows
4542             uint256 result = salary * timeDiff;
4543             return (result / timeDiff != salary) ? MAX_UINT256 : result;
4544         } else {
4545             return salary.mul(timeDiff);
4546         }
4547     }
4548 
4549     /**
4550      * @dev Get owed payroll period for an employee
4551      * @param _employee Employee struct in storage
4552      * @return Owed time in seconds since the employee's last payroll date
4553      */
4554     function _getOwedPayrollPeriod(Employee storage _employee) internal view returns (uint256) {
4555         // Get the min of current date and termination date
4556         uint64 date = _isEmployeeActive(_employee) ? getTimestamp64() : _employee.endDate;
4557 
4558         // Make sure we don't revert if we try to get the owed salary for an employee whose last
4559         // payroll date is now or in the future
4560         // This can happen either by adding new employees with start dates in the future, to allow
4561         // us to change their salary before their start date, or by terminating an employee and
4562         // paying out their full owed salary
4563         if (date <= _employee.lastPayroll) {
4564             return 0;
4565         }
4566 
4567         // Return time diff in seconds, no need to use SafeMath as the underflow was covered by the previous check
4568         return uint256(date - _employee.lastPayroll);
4569     }
4570 
4571     /**
4572      * @dev Get owed salary since last payroll for an employee. It will take into account the accrued salary as well.
4573      *      The result will be capped to max uint256 to avoid having an overflow.
4574      * @param _employee Employee struct in storage
4575      * @return Employee's total owed salary: current owed payroll since the last payroll date, plus the accrued salary.
4576      */
4577     function _getTotalOwedCappedSalary(Employee storage _employee) internal view returns (uint256) {
4578         uint256 currentOwedSalary = _getOwedSalarySinceLastPayroll(_employee, true); // cap amount
4579         uint256 totalOwedSalary = currentOwedSalary + _employee.accruedSalary;
4580         if (totalOwedSalary < currentOwedSalary) {
4581             totalOwedSalary = MAX_UINT256;
4582         }
4583         return totalOwedSalary;
4584     }
4585 
4586     /**
4587      * @dev Get payment reference for a given payment type
4588      * @param _type Payment type to query the reference of
4589      * @return Payment reference for the given payment type
4590      */
4591     function _paymentReferenceFor(PaymentType _type) internal pure returns (string memory) {
4592         if (_type == PaymentType.Payroll) {
4593             return "Employee salary";
4594         } else if (_type == PaymentType.Reimbursement) {
4595             return "Employee reimbursement";
4596         } if (_type == PaymentType.Bonus) {
4597             return "Employee bonus";
4598         }
4599         revert(ERROR_INVALID_PAYMENT_TYPE);
4600     }
4601 
4602     function _ensurePaymentAmount(uint256 _owedAmount, uint256 _requestedAmount) private pure returns (uint256) {
4603         require(_owedAmount > 0, ERROR_NOTHING_PAID);
4604         require(_owedAmount >= _requestedAmount, ERROR_INVALID_REQUESTED_AMOUNT);
4605         return _requestedAmount > 0 ? _requestedAmount : _owedAmount;
4606     }
4607 }
4608 
4609 // File: @aragon/apps-token-manager/contracts/TokenManager.sol
4610 
4611 /*
4612  * SPDX-License-Identitifer:    GPL-3.0-or-later
4613  */
4614 
4615 /* solium-disable function-order */
4616 
4617 pragma solidity 0.4.24;
4618 
4619 
4620 
4621 
4622 
4623 
4624 
4625 contract TokenManager is ITokenController, IForwarder, AragonApp {
4626     using SafeMath for uint256;
4627 
4628     bytes32 public constant MINT_ROLE = keccak256("MINT_ROLE");
4629     bytes32 public constant ISSUE_ROLE = keccak256("ISSUE_ROLE");
4630     bytes32 public constant ASSIGN_ROLE = keccak256("ASSIGN_ROLE");
4631     bytes32 public constant REVOKE_VESTINGS_ROLE = keccak256("REVOKE_VESTINGS_ROLE");
4632     bytes32 public constant BURN_ROLE = keccak256("BURN_ROLE");
4633 
4634     uint256 public constant MAX_VESTINGS_PER_ADDRESS = 50;
4635 
4636     string private constant ERROR_CALLER_NOT_TOKEN = "TM_CALLER_NOT_TOKEN";
4637     string private constant ERROR_NO_VESTING = "TM_NO_VESTING";
4638     string private constant ERROR_TOKEN_CONTROLLER = "TM_TOKEN_CONTROLLER";
4639     string private constant ERROR_MINT_RECEIVER_IS_TM = "TM_MINT_RECEIVER_IS_TM";
4640     string private constant ERROR_VESTING_TO_TM = "TM_VESTING_TO_TM";
4641     string private constant ERROR_TOO_MANY_VESTINGS = "TM_TOO_MANY_VESTINGS";
4642     string private constant ERROR_WRONG_CLIFF_DATE = "TM_WRONG_CLIFF_DATE";
4643     string private constant ERROR_VESTING_NOT_REVOKABLE = "TM_VESTING_NOT_REVOKABLE";
4644     string private constant ERROR_REVOKE_TRANSFER_FROM_REVERTED = "TM_REVOKE_TRANSFER_FROM_REVERTED";
4645     string private constant ERROR_CAN_NOT_FORWARD = "TM_CAN_NOT_FORWARD";
4646     string private constant ERROR_BALANCE_INCREASE_NOT_ALLOWED = "TM_BALANCE_INC_NOT_ALLOWED";
4647     string private constant ERROR_ASSIGN_TRANSFER_FROM_REVERTED = "TM_ASSIGN_TRANSFER_FROM_REVERTED";
4648 
4649     struct TokenVesting {
4650         uint256 amount;
4651         uint64 start;
4652         uint64 cliff;
4653         uint64 vesting;
4654         bool revokable;
4655     }
4656 
4657     // Note that we COMPLETELY trust this MiniMeToken to not be malicious for proper operation of this contract
4658     MiniMeToken public token;
4659     uint256 public maxAccountTokens;
4660 
4661     // We are mimicing an array in the inner mapping, we use a mapping instead to make app upgrade more graceful
4662     mapping (address => mapping (uint256 => TokenVesting)) internal vestings;
4663     mapping (address => uint256) public vestingsLengths;
4664 
4665     // Other token specific events can be watched on the token address directly (avoids duplication)
4666     event NewVesting(address indexed receiver, uint256 vestingId, uint256 amount);
4667     event RevokeVesting(address indexed receiver, uint256 vestingId, uint256 nonVestedAmount);
4668 
4669     modifier onlyToken() {
4670         require(msg.sender == address(token), ERROR_CALLER_NOT_TOKEN);
4671         _;
4672     }
4673 
4674     modifier vestingExists(address _holder, uint256 _vestingId) {
4675         // TODO: it's not checking for gaps that may appear because of deletes in revokeVesting function
4676         require(_vestingId < vestingsLengths[_holder], ERROR_NO_VESTING);
4677         _;
4678     }
4679 
4680     /**
4681     * @notice Initialize Token Manager for `_token.symbol(): string`, whose tokens are `transferable ? 'not' : ''` transferable`_maxAccountTokens > 0 ? ' and limited to a maximum of ' + @tokenAmount(_token, _maxAccountTokens, false) + ' per account' : ''`
4682     * @param _token MiniMeToken address for the managed token (Token Manager instance must be already set as the token controller)
4683     * @param _transferable whether the token can be transferred by holders
4684     * @param _maxAccountTokens Maximum amount of tokens an account can have (0 for infinite tokens)
4685     */
4686     function initialize(
4687         MiniMeToken _token,
4688         bool _transferable,
4689         uint256 _maxAccountTokens
4690     )
4691         external
4692         onlyInit
4693     {
4694         initialized();
4695 
4696         require(_token.controller() == address(this), ERROR_TOKEN_CONTROLLER);
4697 
4698         token = _token;
4699         maxAccountTokens = _maxAccountTokens == 0 ? uint256(-1) : _maxAccountTokens;
4700 
4701         if (token.transfersEnabled() != _transferable) {
4702             token.enableTransfers(_transferable);
4703         }
4704     }
4705 
4706     /**
4707     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for `_receiver`
4708     * @param _receiver The address receiving the tokens, cannot be the Token Manager itself (use `issue()` instead)
4709     * @param _amount Number of tokens minted
4710     */
4711     function mint(address _receiver, uint256 _amount) external authP(MINT_ROLE, arr(_receiver, _amount)) {
4712         require(_receiver != address(this), ERROR_MINT_RECEIVER_IS_TM);
4713         _mint(_receiver, _amount);
4714     }
4715 
4716     /**
4717     * @notice Mint `@tokenAmount(self.token(): address, _amount, false)` tokens for the Token Manager
4718     * @param _amount Number of tokens minted
4719     */
4720     function issue(uint256 _amount) external authP(ISSUE_ROLE, arr(_amount)) {
4721         _mint(address(this), _amount);
4722     }
4723 
4724     /**
4725     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings
4726     * @param _receiver The address receiving the tokens
4727     * @param _amount Number of tokens transferred
4728     */
4729     function assign(address _receiver, uint256 _amount) external authP(ASSIGN_ROLE, arr(_receiver, _amount)) {
4730         _assign(_receiver, _amount);
4731     }
4732 
4733     /**
4734     * @notice Burn `@tokenAmount(self.token(): address, _amount, false)` tokens from `_holder`
4735     * @param _holder Holder of tokens being burned
4736     * @param _amount Number of tokens being burned
4737     */
4738     function burn(address _holder, uint256 _amount) external authP(BURN_ROLE, arr(_holder, _amount)) {
4739         // minime.destroyTokens() never returns false, only reverts on failure
4740         token.destroyTokens(_holder, _amount);
4741     }
4742 
4743     /**
4744     * @notice Assign `@tokenAmount(self.token(): address, _amount, false)` tokens to `_receiver` from the Token Manager's holdings with a `_revokable : 'revokable' : ''` vesting starting at `@formatDate(_start)`, cliff at `@formatDate(_cliff)` (first portion of tokens transferable), and completed vesting at `@formatDate(_vested)` (all tokens transferable)
4745     * @param _receiver The address receiving the tokens, cannot be Token Manager itself
4746     * @param _amount Number of tokens vested
4747     * @param _start Date the vesting calculations start
4748     * @param _cliff Date when the initial portion of tokens are transferable
4749     * @param _vested Date when all tokens are transferable
4750     * @param _revokable Whether the vesting can be revoked by the Token Manager
4751     */
4752     function assignVested(
4753         address _receiver,
4754         uint256 _amount,
4755         uint64 _start,
4756         uint64 _cliff,
4757         uint64 _vested,
4758         bool _revokable
4759     )
4760         external
4761         authP(ASSIGN_ROLE, arr(_receiver, _amount))
4762         returns (uint256)
4763     {
4764         require(_receiver != address(this), ERROR_VESTING_TO_TM);
4765         require(vestingsLengths[_receiver] < MAX_VESTINGS_PER_ADDRESS, ERROR_TOO_MANY_VESTINGS);
4766         require(_start <= _cliff && _cliff <= _vested, ERROR_WRONG_CLIFF_DATE);
4767 
4768         uint256 vestingId = vestingsLengths[_receiver]++;
4769         vestings[_receiver][vestingId] = TokenVesting(
4770             _amount,
4771             _start,
4772             _cliff,
4773             _vested,
4774             _revokable
4775         );
4776 
4777         _assign(_receiver, _amount);
4778 
4779         emit NewVesting(_receiver, vestingId, _amount);
4780 
4781         return vestingId;
4782     }
4783 
4784     /**
4785     * @notice Revoke vesting #`_vestingId` from `_holder`, returning unvested tokens to the Token Manager
4786     * @param _holder Address whose vesting to revoke
4787     * @param _vestingId Numeric id of the vesting
4788     */
4789     function revokeVesting(address _holder, uint256 _vestingId)
4790         external
4791         authP(REVOKE_VESTINGS_ROLE, arr(_holder))
4792         vestingExists(_holder, _vestingId)
4793     {
4794         TokenVesting storage v = vestings[_holder][_vestingId];
4795         require(v.revokable, ERROR_VESTING_NOT_REVOKABLE);
4796 
4797         uint256 nonVested = _calculateNonVestedTokens(
4798             v.amount,
4799             getTimestamp(),
4800             v.start,
4801             v.cliff,
4802             v.vesting
4803         );
4804 
4805         // To make vestingIds immutable over time, we just zero out the revoked vesting
4806         // Clearing this out also allows the token transfer back to the Token Manager to succeed
4807         delete vestings[_holder][_vestingId];
4808 
4809         // transferFrom always works as controller
4810         // onTransfer hook always allows if transfering to token controller
4811         require(token.transferFrom(_holder, address(this), nonVested), ERROR_REVOKE_TRANSFER_FROM_REVERTED);
4812 
4813         emit RevokeVesting(_holder, _vestingId, nonVested);
4814     }
4815 
4816     // ITokenController fns
4817     // `onTransfer()`, `onApprove()`, and `proxyPayment()` are callbacks from the MiniMe token
4818     // contract and are only meant to be called through the managed MiniMe token that gets assigned
4819     // during initialization.
4820 
4821     /*
4822     * @dev Notifies the controller about a token transfer allowing the controller to decide whether
4823     *      to allow it or react if desired (only callable from the token).
4824     *      Initialization check is implicitly provided by `onlyToken()`.
4825     * @param _from The origin of the transfer
4826     * @param _to The destination of the transfer
4827     * @param _amount The amount of the transfer
4828     * @return False if the controller does not authorize the transfer
4829     */
4830     function onTransfer(address _from, address _to, uint256 _amount) external onlyToken returns (bool) {
4831         return _isBalanceIncreaseAllowed(_to, _amount) && _transferableBalance(_from, getTimestamp()) >= _amount;
4832     }
4833 
4834     /**
4835     * @dev Notifies the controller about an approval allowing the controller to react if desired
4836     *      Initialization check is implicitly provided by `onlyToken()`.
4837     * @return False if the controller does not authorize the approval
4838     */
4839     function onApprove(address, address, uint) external onlyToken returns (bool) {
4840         return true;
4841     }
4842 
4843     /**
4844     * @dev Called when ether is sent to the MiniMe Token contract
4845     *      Initialization check is implicitly provided by `onlyToken()`.
4846     * @return True if the ether is accepted, false for it to throw
4847     */
4848     function proxyPayment(address) external payable onlyToken returns (bool) {
4849         return false;
4850     }
4851 
4852     // Forwarding fns
4853 
4854     function isForwarder() external pure returns (bool) {
4855         return true;
4856     }
4857 
4858     /**
4859     * @notice Execute desired action as a token holder
4860     * @dev IForwarder interface conformance. Forwards any token holder action.
4861     * @param _evmScript Script being executed
4862     */
4863     function forward(bytes _evmScript) public {
4864         require(canForward(msg.sender, _evmScript), ERROR_CAN_NOT_FORWARD);
4865         bytes memory input = new bytes(0); // TODO: Consider input for this
4866 
4867         // Add the managed token to the blacklist to disallow a token holder from executing actions
4868         // on the token controller's (this contract) behalf
4869         address[] memory blacklist = new address[](1);
4870         blacklist[0] = address(token);
4871 
4872         runScript(_evmScript, input, blacklist);
4873     }
4874 
4875     function canForward(address _sender, bytes) public view returns (bool) {
4876         return hasInitialized() && token.balanceOf(_sender) > 0;
4877     }
4878 
4879     // Getter fns
4880 
4881     function getVesting(
4882         address _recipient,
4883         uint256 _vestingId
4884     )
4885         public
4886         view
4887         vestingExists(_recipient, _vestingId)
4888         returns (
4889             uint256 amount,
4890             uint64 start,
4891             uint64 cliff,
4892             uint64 vesting,
4893             bool revokable
4894         )
4895     {
4896         TokenVesting storage tokenVesting = vestings[_recipient][_vestingId];
4897         amount = tokenVesting.amount;
4898         start = tokenVesting.start;
4899         cliff = tokenVesting.cliff;
4900         vesting = tokenVesting.vesting;
4901         revokable = tokenVesting.revokable;
4902     }
4903 
4904     function spendableBalanceOf(address _holder) public view isInitialized returns (uint256) {
4905         return _transferableBalance(_holder, getTimestamp());
4906     }
4907 
4908     function transferableBalance(address _holder, uint256 _time) public view isInitialized returns (uint256) {
4909         return _transferableBalance(_holder, _time);
4910     }
4911 
4912     /**
4913     * @dev Disable recovery escape hatch for own token,
4914     *      as the it has the concept of issuing tokens without assigning them
4915     */
4916     function allowRecoverability(address _token) public view returns (bool) {
4917         return _token != address(token);
4918     }
4919 
4920     // Internal fns
4921 
4922     function _assign(address _receiver, uint256 _amount) internal {
4923         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
4924         // Must use transferFrom() as transfer() does not give the token controller full control
4925         require(token.transferFrom(address(this), _receiver, _amount), ERROR_ASSIGN_TRANSFER_FROM_REVERTED);
4926     }
4927 
4928     function _mint(address _receiver, uint256 _amount) internal {
4929         require(_isBalanceIncreaseAllowed(_receiver, _amount), ERROR_BALANCE_INCREASE_NOT_ALLOWED);
4930         token.generateTokens(_receiver, _amount); // minime.generateTokens() never returns false
4931     }
4932 
4933     function _isBalanceIncreaseAllowed(address _receiver, uint256 _inc) internal view returns (bool) {
4934         // Max balance doesn't apply to the token manager itself
4935         if (_receiver == address(this)) {
4936             return true;
4937         }
4938         return token.balanceOf(_receiver).add(_inc) <= maxAccountTokens;
4939     }
4940 
4941     /**
4942     * @dev Calculate amount of non-vested tokens at a specifc time
4943     * @param tokens The total amount of tokens vested
4944     * @param time The time at which to check
4945     * @param start The date vesting started
4946     * @param cliff The cliff period
4947     * @param vested The fully vested date
4948     * @return The amount of non-vested tokens of a specific grant
4949     *  transferableTokens
4950     *   |                         _/--------   vestedTokens rect
4951     *   |                       _/
4952     *   |                     _/
4953     *   |                   _/
4954     *   |                 _/
4955     *   |                /
4956     *   |              .|
4957     *   |            .  |
4958     *   |          .    |
4959     *   |        .      |
4960     *   |      .        |
4961     *   |    .          |
4962     *   +===+===========+---------+----------> time
4963     *      Start       Cliff    Vested
4964     */
4965     function _calculateNonVestedTokens(
4966         uint256 tokens,
4967         uint256 time,
4968         uint256 start,
4969         uint256 cliff,
4970         uint256 vested
4971     )
4972         private
4973         pure
4974         returns (uint256)
4975     {
4976         // Shortcuts for before cliff and after vested cases.
4977         if (time >= vested) {
4978             return 0;
4979         }
4980         if (time < cliff) {
4981             return tokens;
4982         }
4983 
4984         // Interpolate all vested tokens.
4985         // As before cliff the shortcut returns 0, we can just calculate a value
4986         // in the vesting rect (as shown in above's figure)
4987 
4988         // vestedTokens = tokens * (time - start) / (vested - start)
4989         // In assignVesting we enforce start <= cliff <= vested
4990         // Here we shortcut time >= vested and time < cliff,
4991         // so no division by 0 is possible
4992         uint256 vestedTokens = tokens.mul(time.sub(start)) / vested.sub(start);
4993 
4994         // tokens - vestedTokens
4995         return tokens.sub(vestedTokens);
4996     }
4997 
4998     function _transferableBalance(address _holder, uint256 _time) internal view returns (uint256) {
4999         uint256 transferable = token.balanceOf(_holder);
5000 
5001         // This check is not strictly necessary for the current version of this contract, as
5002         // Token Managers now cannot assign vestings to themselves.
5003         // However, this was a possibility in the past, so in case there were vestings assigned to
5004         // themselves, this will still return the correct value (entire balance, as the Token
5005         // Manager does not have a spending limit on its own balance).
5006         if (_holder != address(this)) {
5007             uint256 vestingsCount = vestingsLengths[_holder];
5008             for (uint256 i = 0; i < vestingsCount; i++) {
5009                 TokenVesting storage v = vestings[_holder][i];
5010                 uint256 nonTransferable = _calculateNonVestedTokens(
5011                     v.amount,
5012                     _time,
5013                     v.start,
5014                     v.cliff,
5015                     v.vesting
5016                 );
5017                 transferable = transferable.sub(nonTransferable);
5018             }
5019         }
5020 
5021         return transferable;
5022     }
5023 }
5024 
5025 // File: @aragon/apps-survey/contracts/Survey.sol
5026 
5027 /*
5028  * SPDX-License-Identitifer:    GPL-3.0-or-later
5029  */
5030 
5031 pragma solidity 0.4.24;
5032 
5033 
5034 
5035 
5036 
5037 
5038 contract Survey is AragonApp {
5039     using SafeMath for uint256;
5040     using SafeMath64 for uint64;
5041 
5042     bytes32 public constant CREATE_SURVEYS_ROLE = keccak256("CREATE_SURVEYS_ROLE");
5043     bytes32 public constant MODIFY_PARTICIPATION_ROLE = keccak256("MODIFY_PARTICIPATION_ROLE");
5044 
5045     uint64 public constant PCT_BASE = 10 ** 18; // 0% = 0; 1% = 10^16; 100% = 10^18
5046     uint256 public constant ABSTAIN_VOTE = 0;
5047 
5048     string private constant ERROR_MIN_PARTICIPATION = "SURVEY_MIN_PARTICIPATION";
5049     string private constant ERROR_NO_SURVEY = "SURVEY_NO_SURVEY";
5050     string private constant ERROR_NO_VOTING_POWER = "SURVEY_NO_VOTING_POWER";
5051     string private constant ERROR_CAN_NOT_VOTE = "SURVEY_CAN_NOT_VOTE";
5052     string private constant ERROR_VOTE_WRONG_INPUT = "SURVEY_VOTE_WRONG_INPUT";
5053     string private constant ERROR_VOTE_WRONG_OPTION = "SURVEY_VOTE_WRONG_OPTION";
5054     string private constant ERROR_NO_STAKE = "SURVEY_NO_STAKE";
5055     string private constant ERROR_OPTIONS_NOT_ORDERED = "SURVEY_OPTIONS_NOT_ORDERED";
5056     string private constant ERROR_NO_OPTION = "SURVEY_NO_OPTION";
5057 
5058     struct OptionCast {
5059         uint256 optionId;
5060         uint256 stake;
5061     }
5062 
5063     /* Allows for multiple option votes.
5064      * Index 0 is always used for the ABSTAIN_VOTE option, that's calculated automatically by the
5065      * contract.
5066      */
5067     struct MultiOptionVote {
5068         uint256 optionsCastedLength;
5069         // `castedVotes` simulates an array
5070         // Each OptionCast in `castedVotes` must be ordered by ascending option IDs
5071         mapping (uint256 => OptionCast) castedVotes;
5072     }
5073 
5074     struct SurveyStruct {
5075         uint64 startDate;
5076         uint64 snapshotBlock;
5077         uint64 minParticipationPct;
5078         uint256 options;
5079         uint256 votingPower;                    // total tokens that can cast a vote
5080         uint256 participation;                  // tokens that casted a vote
5081 
5082         // Note that option IDs are from 1 to `options`, due to ABSTAIN_VOTE taking 0
5083         mapping (uint256 => uint256) optionPower;       // option ID -> voting power for option
5084         mapping (address => MultiOptionVote) votes;     // voter -> options voted, with its stakes
5085     }
5086 
5087     MiniMeToken public token;
5088     uint64 public minParticipationPct;
5089     uint64 public surveyTime;
5090 
5091     // We are mimicing an array, we use a mapping instead to make app upgrade more graceful
5092     mapping (uint256 => SurveyStruct) internal surveys;
5093     uint256 public surveysLength;
5094 
5095     event StartSurvey(uint256 indexed surveyId, address indexed creator, string metadata);
5096     event CastVote(uint256 indexed surveyId, address indexed voter, uint256 option, uint256 stake, uint256 optionPower);
5097     event ResetVote(uint256 indexed surveyId, address indexed voter, uint256 option, uint256 previousStake, uint256 optionPower);
5098     event ChangeMinParticipation(uint64 minParticipationPct);
5099 
5100     modifier acceptableMinParticipationPct(uint64 _minParticipationPct) {
5101         require(_minParticipationPct > 0 && _minParticipationPct <= PCT_BASE, ERROR_MIN_PARTICIPATION);
5102         _;
5103     }
5104 
5105     modifier surveyExists(uint256 _surveyId) {
5106         require(_surveyId < surveysLength, ERROR_NO_SURVEY);
5107         _;
5108     }
5109 
5110     /**
5111     * @notice Initialize Survey app with `_token.symbol(): string` for governance, minimum acceptance participation of `@formatPct(_minParticipationPct)`%, and a voting duration of `@transformTime(_surveyTime)`
5112     * @param _token MiniMeToken address that will be used as governance token
5113     * @param _minParticipationPct Percentage of total voting power that must participate in a survey for it to be taken into account (expressed as a 10^18 percentage, (eg 10^16 = 1%, 10^18 = 100%)
5114     * @param _surveyTime Seconds that a survey will be open for token holders to vote
5115     */
5116     function initialize(
5117         MiniMeToken _token,
5118         uint64 _minParticipationPct,
5119         uint64 _surveyTime
5120     )
5121         external
5122         onlyInit
5123         acceptableMinParticipationPct(_minParticipationPct)
5124     {
5125         initialized();
5126 
5127         token = _token;
5128         minParticipationPct = _minParticipationPct;
5129         surveyTime = _surveyTime;
5130     }
5131 
5132     /**
5133     * @notice Change minimum acceptance participation to `@formatPct(_minParticipationPct)`%
5134     * @param _minParticipationPct New acceptance participation
5135     */
5136     function changeMinAcceptParticipationPct(uint64 _minParticipationPct)
5137         external
5138         authP(MODIFY_PARTICIPATION_ROLE, arr(uint256(_minParticipationPct), uint256(minParticipationPct)))
5139         acceptableMinParticipationPct(_minParticipationPct)
5140     {
5141         minParticipationPct = _minParticipationPct;
5142 
5143         emit ChangeMinParticipation(_minParticipationPct);
5144     }
5145 
5146     /**
5147     * @notice Create a new non-binding survey about "`_metadata`"
5148     * @param _metadata Survey metadata
5149     * @param _options Number of options voters can decide between
5150     * @return surveyId id for newly created survey
5151     */
5152     function newSurvey(string _metadata, uint256 _options) external auth(CREATE_SURVEYS_ROLE) returns (uint256 surveyId) {
5153         uint64 snapshotBlock = getBlockNumber64() - 1; // avoid double voting in this very block
5154         uint256 votingPower = token.totalSupplyAt(snapshotBlock);
5155         require(votingPower > 0, ERROR_NO_VOTING_POWER);
5156 
5157         surveyId = surveysLength++;
5158 
5159         SurveyStruct storage survey = surveys[surveyId];
5160         survey.startDate = getTimestamp64();
5161         survey.snapshotBlock = snapshotBlock; // avoid double voting in this very block
5162         survey.minParticipationPct = minParticipationPct;
5163         survey.options = _options;
5164         survey.votingPower = votingPower;
5165 
5166         emit StartSurvey(surveyId, msg.sender, _metadata);
5167     }
5168 
5169     /**
5170     * @notice Reset previously casted vote in survey #`_surveyId`, if any.
5171     * @dev Initialization check is implicitly provided by `surveyExists()` as new surveys can only
5172     *      be created via `newSurvey(),` which requires initialization
5173     * @param _surveyId Id for survey
5174     */
5175     function resetVote(uint256 _surveyId) external surveyExists(_surveyId) {
5176         require(canVote(_surveyId, msg.sender), ERROR_CAN_NOT_VOTE);
5177 
5178         _resetVote(_surveyId);
5179     }
5180 
5181     /**
5182     * @notice Vote for multiple options in survey #`_surveyId`.
5183     * @dev Initialization check is implicitly provided by `surveyExists()` as new surveys can only
5184     *      be created via `newSurvey(),` which requires initialization
5185     * @param _surveyId Id for survey
5186     * @param _optionIds Array with indexes of supported options
5187     * @param _stakes Number of tokens assigned to each option
5188     */
5189     function voteOptions(uint256 _surveyId, uint256[] _optionIds, uint256[] _stakes)
5190         external
5191         surveyExists(_surveyId)
5192     {
5193         require(_optionIds.length == _stakes.length && _optionIds.length > 0, ERROR_VOTE_WRONG_INPUT);
5194         require(canVote(_surveyId, msg.sender), ERROR_CAN_NOT_VOTE);
5195 
5196         _voteOptions(_surveyId, _optionIds, _stakes);
5197     }
5198 
5199     /**
5200     * @notice Vote option #`_optionId` in survey #`_surveyId`.
5201     * @dev Initialization check is implicitly provided by `surveyExists()` as new surveys can only
5202     *      be created via `newSurvey(),` which requires initialization
5203     * @dev It will use the whole balance.
5204     * @param _surveyId Id for survey
5205     * @param _optionId Index of supported option
5206     */
5207     function voteOption(uint256 _surveyId, uint256 _optionId) external surveyExists(_surveyId) {
5208         require(canVote(_surveyId, msg.sender), ERROR_CAN_NOT_VOTE);
5209 
5210         SurveyStruct storage survey = surveys[_surveyId];
5211         // This could re-enter, though we can asume the governance token is not maliciuous
5212         uint256 voterStake = token.balanceOfAt(msg.sender, survey.snapshotBlock);
5213         uint256[] memory options = new uint256[](1);
5214         uint256[] memory stakes = new uint256[](1);
5215         options[0] = _optionId;
5216         stakes[0] = voterStake;
5217 
5218         _voteOptions(_surveyId, options, stakes);
5219     }
5220 
5221     // Getter fns
5222 
5223     function canVote(uint256 _surveyId, address _voter) public view surveyExists(_surveyId) returns (bool) {
5224         SurveyStruct storage survey = surveys[_surveyId];
5225 
5226         return _isSurveyOpen(survey) && token.balanceOfAt(_voter, survey.snapshotBlock) > 0;
5227     }
5228 
5229     function getSurvey(uint256 _surveyId)
5230         public
5231         view
5232         surveyExists(_surveyId)
5233         returns (
5234             bool open,
5235             uint64 startDate,
5236             uint64 snapshotBlock,
5237             uint64 minParticipation,
5238             uint256 votingPower,
5239             uint256 participation,
5240             uint256 options
5241         )
5242     {
5243         SurveyStruct storage survey = surveys[_surveyId];
5244 
5245         open = _isSurveyOpen(survey);
5246         startDate = survey.startDate;
5247         snapshotBlock = survey.snapshotBlock;
5248         minParticipation = survey.minParticipationPct;
5249         votingPower = survey.votingPower;
5250         participation = survey.participation;
5251         options = survey.options;
5252     }
5253 
5254     /**
5255     * @dev This is not meant to be used on-chain
5256     */
5257     /* solium-disable-next-line function-order */
5258     function getVoterState(uint256 _surveyId, address _voter)
5259         external
5260         view
5261         surveyExists(_surveyId)
5262         returns (uint256[] options, uint256[] stakes)
5263     {
5264         MultiOptionVote storage vote = surveys[_surveyId].votes[_voter];
5265 
5266         if (vote.optionsCastedLength == 0) {
5267             return (new uint256[](0), new uint256[](0));
5268         }
5269 
5270         options = new uint256[](vote.optionsCastedLength + 1);
5271         stakes = new uint256[](vote.optionsCastedLength + 1);
5272         for (uint256 i = 0; i <= vote.optionsCastedLength; i++) {
5273             options[i] = vote.castedVotes[i].optionId;
5274             stakes[i] = vote.castedVotes[i].stake;
5275         }
5276     }
5277 
5278     function getOptionPower(uint256 _surveyId, uint256 _optionId) public view surveyExists(_surveyId) returns (uint256) {
5279         SurveyStruct storage survey = surveys[_surveyId];
5280         require(_optionId <= survey.options, ERROR_NO_OPTION);
5281 
5282         return survey.optionPower[_optionId];
5283     }
5284 
5285     function isParticipationAchieved(uint256 _surveyId) public view surveyExists(_surveyId) returns (bool) {
5286         SurveyStruct storage survey = surveys[_surveyId];
5287         // votingPower is always > 0
5288         uint256 participationPct = survey.participation.mul(PCT_BASE) / survey.votingPower;
5289         return participationPct >= survey.minParticipationPct;
5290     }
5291 
5292     // Internal fns
5293 
5294     /*
5295     * @dev Assumes the survey exists and that msg.sender can vote
5296     */
5297     function _resetVote(uint256 _surveyId) internal {
5298         SurveyStruct storage survey = surveys[_surveyId];
5299         MultiOptionVote storage previousVote = survey.votes[msg.sender];
5300         if (previousVote.optionsCastedLength > 0) {
5301             // Voter removes their vote (index 0 is the abstain vote)
5302             for (uint256 i = 1; i <= previousVote.optionsCastedLength; i++) {
5303                 OptionCast storage previousOptionCast = previousVote.castedVotes[i];
5304                 uint256 previousOptionPower = survey.optionPower[previousOptionCast.optionId];
5305                 uint256 currentOptionPower = previousOptionPower.sub(previousOptionCast.stake);
5306                 survey.optionPower[previousOptionCast.optionId] = currentOptionPower;
5307 
5308                 emit ResetVote(_surveyId, msg.sender, previousOptionCast.optionId, previousOptionCast.stake, currentOptionPower);
5309             }
5310 
5311             // Compute previously casted votes (i.e. substract non-used tokens from stake)
5312             uint256 voterStake = token.balanceOfAt(msg.sender, survey.snapshotBlock);
5313             uint256 previousParticipation = voterStake.sub(previousVote.castedVotes[0].stake);
5314             // And remove it from total participation
5315             survey.participation = survey.participation.sub(previousParticipation);
5316 
5317             // Reset previously voted options
5318             delete survey.votes[msg.sender];
5319         }
5320     }
5321 
5322     /*
5323     * @dev Assumes the survey exists and that msg.sender can vote
5324     */
5325     function _voteOptions(uint256 _surveyId, uint256[] _optionIds, uint256[] _stakes) internal {
5326         SurveyStruct storage survey = surveys[_surveyId];
5327         MultiOptionVote storage senderVotes = survey.votes[msg.sender];
5328 
5329         // Revert previous votes, if any
5330         _resetVote(_surveyId);
5331 
5332         uint256 totalVoted = 0;
5333         // Reserve first index for ABSTAIN_VOTE
5334         senderVotes.castedVotes[0] = OptionCast({ optionId: ABSTAIN_VOTE, stake: 0 });
5335         for (uint256 optionIndex = 1; optionIndex <= _optionIds.length; optionIndex++) {
5336             // Voters don't specify that they're abstaining,
5337             // but we still keep track of this by reserving the first index of a survey's votes.
5338             // We subtract 1 from the indexes of the arrays passed in by the voter to account for this.
5339             uint256 optionId = _optionIds[optionIndex - 1];
5340             uint256 stake = _stakes[optionIndex - 1];
5341 
5342             require(optionId != ABSTAIN_VOTE && optionId <= survey.options, ERROR_VOTE_WRONG_OPTION);
5343             require(stake > 0, ERROR_NO_STAKE);
5344             // Let's avoid repeating an option by making sure that ascending order is preserved in
5345             // the options array by checking that the current optionId is larger than the last one
5346             // we added
5347             require(senderVotes.castedVotes[optionIndex - 1].optionId < optionId, ERROR_OPTIONS_NOT_ORDERED);
5348 
5349             // Register voter amount
5350             senderVotes.castedVotes[optionIndex] = OptionCast({ optionId: optionId, stake: stake });
5351 
5352             // Add to total option support
5353             survey.optionPower[optionId] = survey.optionPower[optionId].add(stake);
5354 
5355             // Keep track of stake used so far
5356             totalVoted = totalVoted.add(stake);
5357 
5358             emit CastVote(_surveyId, msg.sender, optionId, stake, survey.optionPower[optionId]);
5359         }
5360 
5361         // Compute and register non used tokens
5362         // Implictly we are doing require(totalVoted <= voterStake) too
5363         // (as stated before, index 0 is for ABSTAIN_VOTE option)
5364         uint256 voterStake = token.balanceOfAt(msg.sender, survey.snapshotBlock);
5365         senderVotes.castedVotes[0].stake = voterStake.sub(totalVoted);
5366 
5367         // Register number of options voted
5368         senderVotes.optionsCastedLength = _optionIds.length;
5369 
5370         // Add voter tokens to participation
5371         survey.participation = survey.participation.add(totalVoted);
5372         assert(survey.participation <= survey.votingPower);
5373     }
5374 
5375     function _isSurveyOpen(SurveyStruct storage _survey) internal view returns (bool) {
5376         return getTimestamp64() < _survey.startDate.add(surveyTime);
5377     }
5378 }
5379 
5380 // File: @aragon/os/contracts/acl/IACLOracle.sol
5381 
5382 /*
5383  * SPDX-License-Identitifer:    MIT
5384  */
5385 
5386 pragma solidity ^0.4.24;
5387 
5388 
5389 interface IACLOracle {
5390     function canPerform(address who, address where, bytes32 what, uint256[] how) external view returns (bool);
5391 }
5392 
5393 // File: @aragon/os/contracts/acl/ACL.sol
5394 
5395 pragma solidity 0.4.24;
5396 
5397 
5398 
5399 
5400 
5401 
5402 
5403 
5404 /* solium-disable function-order */
5405 // Allow public initialize() to be first
5406 contract ACL is IACL, TimeHelpers, AragonApp, ACLHelpers {
5407     /* Hardcoded constants to save gas
5408     bytes32 public constant CREATE_PERMISSIONS_ROLE = keccak256("CREATE_PERMISSIONS_ROLE");
5409     */
5410     bytes32 public constant CREATE_PERMISSIONS_ROLE = 0x0b719b33c83b8e5d300c521cb8b54ae9bd933996a14bef8c2f4e0285d2d2400a;
5411 
5412     enum Op { NONE, EQ, NEQ, GT, LT, GTE, LTE, RET, NOT, AND, OR, XOR, IF_ELSE } // op types
5413 
5414     struct Param {
5415         uint8 id;
5416         uint8 op;
5417         uint240 value; // even though value is an uint240 it can store addresses
5418         // in the case of 32 byte hashes losing 2 bytes precision isn't a huge deal
5419         // op and id take less than 1 byte each so it can be kept in 1 sstore
5420     }
5421 
5422     uint8 internal constant BLOCK_NUMBER_PARAM_ID = 200;
5423     uint8 internal constant TIMESTAMP_PARAM_ID    = 201;
5424     // 202 is unused
5425     uint8 internal constant ORACLE_PARAM_ID       = 203;
5426     uint8 internal constant LOGIC_OP_PARAM_ID     = 204;
5427     uint8 internal constant PARAM_VALUE_PARAM_ID  = 205;
5428     // TODO: Add execution times param type?
5429 
5430     /* Hardcoded constant to save gas
5431     bytes32 public constant EMPTY_PARAM_HASH = keccak256(uint256(0));
5432     */
5433     bytes32 public constant EMPTY_PARAM_HASH = 0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563;
5434     bytes32 public constant NO_PERMISSION = bytes32(0);
5435     address public constant ANY_ENTITY = address(-1);
5436     address public constant BURN_ENTITY = address(1); // address(0) is already used as "no permission manager"
5437 
5438     uint256 internal constant ORACLE_CHECK_GAS = 30000;
5439 
5440     string private constant ERROR_AUTH_INIT_KERNEL = "ACL_AUTH_INIT_KERNEL";
5441     string private constant ERROR_AUTH_NO_MANAGER = "ACL_AUTH_NO_MANAGER";
5442     string private constant ERROR_EXISTENT_MANAGER = "ACL_EXISTENT_MANAGER";
5443 
5444     // Whether someone has a permission
5445     mapping (bytes32 => bytes32) internal permissions; // permissions hash => params hash
5446     mapping (bytes32 => Param[]) internal permissionParams; // params hash => params
5447 
5448     // Who is the manager of a permission
5449     mapping (bytes32 => address) internal permissionManager;
5450 
5451     event SetPermission(address indexed entity, address indexed app, bytes32 indexed role, bool allowed);
5452     event SetPermissionParams(address indexed entity, address indexed app, bytes32 indexed role, bytes32 paramsHash);
5453     event ChangePermissionManager(address indexed app, bytes32 indexed role, address indexed manager);
5454 
5455     modifier onlyPermissionManager(address _app, bytes32 _role) {
5456         require(msg.sender == getPermissionManager(_app, _role), ERROR_AUTH_NO_MANAGER);
5457         _;
5458     }
5459 
5460     modifier noPermissionManager(address _app, bytes32 _role) {
5461         // only allow permission creation (or re-creation) when there is no manager
5462         require(getPermissionManager(_app, _role) == address(0), ERROR_EXISTENT_MANAGER);
5463         _;
5464     }
5465 
5466     /**
5467     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
5468     * @notice Initialize an ACL instance and set `_permissionsCreator` as the entity that can create other permissions
5469     * @param _permissionsCreator Entity that will be given permission over createPermission
5470     */
5471     function initialize(address _permissionsCreator) public onlyInit {
5472         initialized();
5473         require(msg.sender == address(kernel()), ERROR_AUTH_INIT_KERNEL);
5474 
5475         _createPermission(_permissionsCreator, this, CREATE_PERMISSIONS_ROLE, _permissionsCreator);
5476     }
5477 
5478     /**
5479     * @dev Creates a permission that wasn't previously set and managed.
5480     *      If a created permission is removed it is possible to reset it with createPermission.
5481     *      This is the **ONLY** way to create permissions and set managers to permissions that don't
5482     *      have a manager.
5483     *      In terms of the ACL being initialized, this function implicitly protects all the other
5484     *      state-changing external functions, as they all require the sender to be a manager.
5485     * @notice Create a new permission granting `_entity` the ability to perform actions requiring `_role` on `_app`, setting `_manager` as the permission's manager
5486     * @param _entity Address of the whitelisted entity that will be able to perform the role
5487     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
5488     * @param _role Identifier for the group of actions in app given access to perform
5489     * @param _manager Address of the entity that will be able to grant and revoke the permission further.
5490     */
5491     function createPermission(address _entity, address _app, bytes32 _role, address _manager)
5492         external
5493         auth(CREATE_PERMISSIONS_ROLE)
5494         noPermissionManager(_app, _role)
5495     {
5496         _createPermission(_entity, _app, _role, _manager);
5497     }
5498 
5499     /**
5500     * @dev Grants permission if allowed. This requires `msg.sender` to be the permission manager
5501     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
5502     * @param _entity Address of the whitelisted entity that will be able to perform the role
5503     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
5504     * @param _role Identifier for the group of actions in app given access to perform
5505     */
5506     function grantPermission(address _entity, address _app, bytes32 _role)
5507         external
5508     {
5509         grantPermissionP(_entity, _app, _role, new uint256[](0));
5510     }
5511 
5512     /**
5513     * @dev Grants a permission with parameters if allowed. This requires `msg.sender` to be the permission manager
5514     * @notice Grant `_entity` the ability to perform actions requiring `_role` on `_app`
5515     * @param _entity Address of the whitelisted entity that will be able to perform the role
5516     * @param _app Address of the app in which the role will be allowed (requires app to depend on kernel for ACL)
5517     * @param _role Identifier for the group of actions in app given access to perform
5518     * @param _params Permission parameters
5519     */
5520     function grantPermissionP(address _entity, address _app, bytes32 _role, uint256[] _params)
5521         public
5522         onlyPermissionManager(_app, _role)
5523     {
5524         bytes32 paramsHash = _params.length > 0 ? _saveParams(_params) : EMPTY_PARAM_HASH;
5525         _setPermission(_entity, _app, _role, paramsHash);
5526     }
5527 
5528     /**
5529     * @dev Revokes permission if allowed. This requires `msg.sender` to be the the permission manager
5530     * @notice Revoke from `_entity` the ability to perform actions requiring `_role` on `_app`
5531     * @param _entity Address of the whitelisted entity to revoke access from
5532     * @param _app Address of the app in which the role will be revoked
5533     * @param _role Identifier for the group of actions in app being revoked
5534     */
5535     function revokePermission(address _entity, address _app, bytes32 _role)
5536         external
5537         onlyPermissionManager(_app, _role)
5538     {
5539         _setPermission(_entity, _app, _role, NO_PERMISSION);
5540     }
5541 
5542     /**
5543     * @notice Set `_newManager` as the manager of `_role` in `_app`
5544     * @param _newManager Address for the new manager
5545     * @param _app Address of the app in which the permission management is being transferred
5546     * @param _role Identifier for the group of actions being transferred
5547     */
5548     function setPermissionManager(address _newManager, address _app, bytes32 _role)
5549         external
5550         onlyPermissionManager(_app, _role)
5551     {
5552         _setPermissionManager(_newManager, _app, _role);
5553     }
5554 
5555     /**
5556     * @notice Remove the manager of `_role` in `_app`
5557     * @param _app Address of the app in which the permission is being unmanaged
5558     * @param _role Identifier for the group of actions being unmanaged
5559     */
5560     function removePermissionManager(address _app, bytes32 _role)
5561         external
5562         onlyPermissionManager(_app, _role)
5563     {
5564         _setPermissionManager(address(0), _app, _role);
5565     }
5566 
5567     /**
5568     * @notice Burn non-existent `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
5569     * @param _app Address of the app in which the permission is being burned
5570     * @param _role Identifier for the group of actions being burned
5571     */
5572     function createBurnedPermission(address _app, bytes32 _role)
5573         external
5574         auth(CREATE_PERMISSIONS_ROLE)
5575         noPermissionManager(_app, _role)
5576     {
5577         _setPermissionManager(BURN_ENTITY, _app, _role);
5578     }
5579 
5580     /**
5581     * @notice Burn `_role` in `_app`, so no modification can be made to it (grant, revoke, permission manager)
5582     * @param _app Address of the app in which the permission is being burned
5583     * @param _role Identifier for the group of actions being burned
5584     */
5585     function burnPermissionManager(address _app, bytes32 _role)
5586         external
5587         onlyPermissionManager(_app, _role)
5588     {
5589         _setPermissionManager(BURN_ENTITY, _app, _role);
5590     }
5591 
5592     /**
5593      * @notice Get parameters for permission array length
5594      * @param _entity Address of the whitelisted entity that will be able to perform the role
5595      * @param _app Address of the app
5596      * @param _role Identifier for a group of actions in app
5597      * @return Length of the array
5598      */
5599     function getPermissionParamsLength(address _entity, address _app, bytes32 _role) external view returns (uint) {
5600         return permissionParams[permissions[permissionHash(_entity, _app, _role)]].length;
5601     }
5602 
5603     /**
5604     * @notice Get parameter for permission
5605     * @param _entity Address of the whitelisted entity that will be able to perform the role
5606     * @param _app Address of the app
5607     * @param _role Identifier for a group of actions in app
5608     * @param _index Index of parameter in the array
5609     * @return Parameter (id, op, value)
5610     */
5611     function getPermissionParam(address _entity, address _app, bytes32 _role, uint _index)
5612         external
5613         view
5614         returns (uint8, uint8, uint240)
5615     {
5616         Param storage param = permissionParams[permissions[permissionHash(_entity, _app, _role)]][_index];
5617         return (param.id, param.op, param.value);
5618     }
5619 
5620     /**
5621     * @dev Get manager for permission
5622     * @param _app Address of the app
5623     * @param _role Identifier for a group of actions in app
5624     * @return address of the manager for the permission
5625     */
5626     function getPermissionManager(address _app, bytes32 _role) public view returns (address) {
5627         return permissionManager[roleHash(_app, _role)];
5628     }
5629 
5630     /**
5631     * @dev Function called by apps to check ACL on kernel or to check permission statu
5632     * @param _who Sender of the original call
5633     * @param _where Address of the app
5634     * @param _where Identifier for a group of actions in app
5635     * @param _how Permission parameters
5636     * @return boolean indicating whether the ACL allows the role or not
5637     */
5638     function hasPermission(address _who, address _where, bytes32 _what, bytes memory _how) public view returns (bool) {
5639         return hasPermission(_who, _where, _what, ConversionHelpers.dangerouslyCastBytesToUintArray(_how));
5640     }
5641 
5642     function hasPermission(address _who, address _where, bytes32 _what, uint256[] memory _how) public view returns (bool) {
5643         bytes32 whoParams = permissions[permissionHash(_who, _where, _what)];
5644         if (whoParams != NO_PERMISSION && evalParams(whoParams, _who, _where, _what, _how)) {
5645             return true;
5646         }
5647 
5648         bytes32 anyParams = permissions[permissionHash(ANY_ENTITY, _where, _what)];
5649         if (anyParams != NO_PERMISSION && evalParams(anyParams, ANY_ENTITY, _where, _what, _how)) {
5650             return true;
5651         }
5652 
5653         return false;
5654     }
5655 
5656     function hasPermission(address _who, address _where, bytes32 _what) public view returns (bool) {
5657         uint256[] memory empty = new uint256[](0);
5658         return hasPermission(_who, _where, _what, empty);
5659     }
5660 
5661     function evalParams(
5662         bytes32 _paramsHash,
5663         address _who,
5664         address _where,
5665         bytes32 _what,
5666         uint256[] _how
5667     ) public view returns (bool)
5668     {
5669         if (_paramsHash == EMPTY_PARAM_HASH) {
5670             return true;
5671         }
5672 
5673         return _evalParam(_paramsHash, 0, _who, _where, _what, _how);
5674     }
5675 
5676     /**
5677     * @dev Internal createPermission for access inside the kernel (on instantiation)
5678     */
5679     function _createPermission(address _entity, address _app, bytes32 _role, address _manager) internal {
5680         _setPermission(_entity, _app, _role, EMPTY_PARAM_HASH);
5681         _setPermissionManager(_manager, _app, _role);
5682     }
5683 
5684     /**
5685     * @dev Internal function called to actually save the permission
5686     */
5687     function _setPermission(address _entity, address _app, bytes32 _role, bytes32 _paramsHash) internal {
5688         permissions[permissionHash(_entity, _app, _role)] = _paramsHash;
5689         bool entityHasPermission = _paramsHash != NO_PERMISSION;
5690         bool permissionHasParams = entityHasPermission && _paramsHash != EMPTY_PARAM_HASH;
5691 
5692         emit SetPermission(_entity, _app, _role, entityHasPermission);
5693         if (permissionHasParams) {
5694             emit SetPermissionParams(_entity, _app, _role, _paramsHash);
5695         }
5696     }
5697 
5698     function _saveParams(uint256[] _encodedParams) internal returns (bytes32) {
5699         bytes32 paramHash = keccak256(abi.encodePacked(_encodedParams));
5700         Param[] storage params = permissionParams[paramHash];
5701 
5702         if (params.length == 0) { // params not saved before
5703             for (uint256 i = 0; i < _encodedParams.length; i++) {
5704                 uint256 encodedParam = _encodedParams[i];
5705                 Param memory param = Param(decodeParamId(encodedParam), decodeParamOp(encodedParam), uint240(encodedParam));
5706                 params.push(param);
5707             }
5708         }
5709 
5710         return paramHash;
5711     }
5712 
5713     function _evalParam(
5714         bytes32 _paramsHash,
5715         uint32 _paramId,
5716         address _who,
5717         address _where,
5718         bytes32 _what,
5719         uint256[] _how
5720     ) internal view returns (bool)
5721     {
5722         if (_paramId >= permissionParams[_paramsHash].length) {
5723             return false; // out of bounds
5724         }
5725 
5726         Param memory param = permissionParams[_paramsHash][_paramId];
5727 
5728         if (param.id == LOGIC_OP_PARAM_ID) {
5729             return _evalLogic(param, _paramsHash, _who, _where, _what, _how);
5730         }
5731 
5732         uint256 value;
5733         uint256 comparedTo = uint256(param.value);
5734 
5735         // get value
5736         if (param.id == ORACLE_PARAM_ID) {
5737             value = checkOracle(IACLOracle(param.value), _who, _where, _what, _how) ? 1 : 0;
5738             comparedTo = 1;
5739         } else if (param.id == BLOCK_NUMBER_PARAM_ID) {
5740             value = getBlockNumber();
5741         } else if (param.id == TIMESTAMP_PARAM_ID) {
5742             value = getTimestamp();
5743         } else if (param.id == PARAM_VALUE_PARAM_ID) {
5744             value = uint256(param.value);
5745         } else {
5746             if (param.id >= _how.length) {
5747                 return false;
5748             }
5749             value = uint256(uint240(_how[param.id])); // force lost precision
5750         }
5751 
5752         if (Op(param.op) == Op.RET) {
5753             return uint256(value) > 0;
5754         }
5755 
5756         return compare(value, Op(param.op), comparedTo);
5757     }
5758 
5759     function _evalLogic(Param _param, bytes32 _paramsHash, address _who, address _where, bytes32 _what, uint256[] _how)
5760         internal
5761         view
5762         returns (bool)
5763     {
5764         if (Op(_param.op) == Op.IF_ELSE) {
5765             uint32 conditionParam;
5766             uint32 successParam;
5767             uint32 failureParam;
5768 
5769             (conditionParam, successParam, failureParam) = decodeParamsList(uint256(_param.value));
5770             bool result = _evalParam(_paramsHash, conditionParam, _who, _where, _what, _how);
5771 
5772             return _evalParam(_paramsHash, result ? successParam : failureParam, _who, _where, _what, _how);
5773         }
5774 
5775         uint32 param1;
5776         uint32 param2;
5777 
5778         (param1, param2,) = decodeParamsList(uint256(_param.value));
5779         bool r1 = _evalParam(_paramsHash, param1, _who, _where, _what, _how);
5780 
5781         if (Op(_param.op) == Op.NOT) {
5782             return !r1;
5783         }
5784 
5785         if (r1 && Op(_param.op) == Op.OR) {
5786             return true;
5787         }
5788 
5789         if (!r1 && Op(_param.op) == Op.AND) {
5790             return false;
5791         }
5792 
5793         bool r2 = _evalParam(_paramsHash, param2, _who, _where, _what, _how);
5794 
5795         if (Op(_param.op) == Op.XOR) {
5796             return r1 != r2;
5797         }
5798 
5799         return r2; // both or and and depend on result of r2 after checks
5800     }
5801 
5802     function compare(uint256 _a, Op _op, uint256 _b) internal pure returns (bool) {
5803         if (_op == Op.EQ)  return _a == _b;                              // solium-disable-line lbrace
5804         if (_op == Op.NEQ) return _a != _b;                              // solium-disable-line lbrace
5805         if (_op == Op.GT)  return _a > _b;                               // solium-disable-line lbrace
5806         if (_op == Op.LT)  return _a < _b;                               // solium-disable-line lbrace
5807         if (_op == Op.GTE) return _a >= _b;                              // solium-disable-line lbrace
5808         if (_op == Op.LTE) return _a <= _b;                              // solium-disable-line lbrace
5809         return false;
5810     }
5811 
5812     function checkOracle(IACLOracle _oracleAddr, address _who, address _where, bytes32 _what, uint256[] _how) internal view returns (bool) {
5813         bytes4 sig = _oracleAddr.canPerform.selector;
5814 
5815         // a raw call is required so we can return false if the call reverts, rather than reverting
5816         bytes memory checkCalldata = abi.encodeWithSelector(sig, _who, _where, _what, _how);
5817         uint256 oracleCheckGas = ORACLE_CHECK_GAS;
5818 
5819         bool ok;
5820         assembly {
5821             ok := staticcall(oracleCheckGas, _oracleAddr, add(checkCalldata, 0x20), mload(checkCalldata), 0, 0)
5822         }
5823 
5824         if (!ok) {
5825             return false;
5826         }
5827 
5828         uint256 size;
5829         assembly { size := returndatasize }
5830         if (size != 32) {
5831             return false;
5832         }
5833 
5834         bool result;
5835         assembly {
5836             let ptr := mload(0x40)       // get next free memory ptr
5837             returndatacopy(ptr, 0, size) // copy return from above `staticcall`
5838             result := mload(ptr)         // read data at ptr and set it to result
5839             mstore(ptr, 0)               // set pointer memory to 0 so it still is the next free ptr
5840         }
5841 
5842         return result;
5843     }
5844 
5845     /**
5846     * @dev Internal function that sets management
5847     */
5848     function _setPermissionManager(address _newManager, address _app, bytes32 _role) internal {
5849         permissionManager[roleHash(_app, _role)] = _newManager;
5850         emit ChangePermissionManager(_app, _role, _newManager);
5851     }
5852 
5853     function roleHash(address _where, bytes32 _what) internal pure returns (bytes32) {
5854         return keccak256(abi.encodePacked("ROLE", _where, _what));
5855     }
5856 
5857     function permissionHash(address _who, address _where, bytes32 _what) internal pure returns (bytes32) {
5858         return keccak256(abi.encodePacked("PERMISSION", _who, _where, _what));
5859     }
5860 }
5861 
5862 // File: @aragon/os/contracts/apm/Repo.sol
5863 
5864 pragma solidity 0.4.24;
5865 
5866 
5867 
5868 /* solium-disable function-order */
5869 // Allow public initialize() to be first
5870 contract Repo is AragonApp {
5871     /* Hardcoded constants to save gas
5872     bytes32 public constant CREATE_VERSION_ROLE = keccak256("CREATE_VERSION_ROLE");
5873     */
5874     bytes32 public constant CREATE_VERSION_ROLE = 0x1f56cfecd3595a2e6cc1a7e6cb0b20df84cdbd92eff2fee554e70e4e45a9a7d8;
5875 
5876     string private constant ERROR_INVALID_BUMP = "REPO_INVALID_BUMP";
5877     string private constant ERROR_INVALID_VERSION = "REPO_INVALID_VERSION";
5878     string private constant ERROR_INEXISTENT_VERSION = "REPO_INEXISTENT_VERSION";
5879 
5880     struct Version {
5881         uint16[3] semanticVersion;
5882         address contractAddress;
5883         bytes contentURI;
5884     }
5885 
5886     uint256 internal versionsNextIndex;
5887     mapping (uint256 => Version) internal versions;
5888     mapping (bytes32 => uint256) internal versionIdForSemantic;
5889     mapping (address => uint256) internal latestVersionIdForContract;
5890 
5891     event NewVersion(uint256 versionId, uint16[3] semanticVersion);
5892 
5893     /**
5894     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
5895     * @notice Initialize this Repo
5896     */
5897     function initialize() public onlyInit {
5898         initialized();
5899         versionsNextIndex = 1;
5900     }
5901 
5902     /**
5903     * @notice Create new version with contract `_contractAddress` and content `@fromHex(_contentURI)`
5904     * @param _newSemanticVersion Semantic version for new repo version
5905     * @param _contractAddress address for smart contract logic for version (if set to 0, it uses last versions' contractAddress)
5906     * @param _contentURI External URI for fetching new version's content
5907     */
5908     function newVersion(
5909         uint16[3] _newSemanticVersion,
5910         address _contractAddress,
5911         bytes _contentURI
5912     ) public auth(CREATE_VERSION_ROLE)
5913     {
5914         address contractAddress = _contractAddress;
5915         uint256 lastVersionIndex = versionsNextIndex - 1;
5916 
5917         uint16[3] memory lastSematicVersion;
5918 
5919         if (lastVersionIndex > 0) {
5920             Version storage lastVersion = versions[lastVersionIndex];
5921             lastSematicVersion = lastVersion.semanticVersion;
5922 
5923             if (contractAddress == address(0)) {
5924                 contractAddress = lastVersion.contractAddress;
5925             }
5926             // Only allows smart contract change on major version bumps
5927             require(
5928                 lastVersion.contractAddress == contractAddress || _newSemanticVersion[0] > lastVersion.semanticVersion[0],
5929                 ERROR_INVALID_VERSION
5930             );
5931         }
5932 
5933         require(isValidBump(lastSematicVersion, _newSemanticVersion), ERROR_INVALID_BUMP);
5934 
5935         uint256 versionId = versionsNextIndex++;
5936         versions[versionId] = Version(_newSemanticVersion, contractAddress, _contentURI);
5937         versionIdForSemantic[semanticVersionHash(_newSemanticVersion)] = versionId;
5938         latestVersionIdForContract[contractAddress] = versionId;
5939 
5940         emit NewVersion(versionId, _newSemanticVersion);
5941     }
5942 
5943     function getLatest() public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
5944         return getByVersionId(versionsNextIndex - 1);
5945     }
5946 
5947     function getLatestForContractAddress(address _contractAddress)
5948         public
5949         view
5950         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
5951     {
5952         return getByVersionId(latestVersionIdForContract[_contractAddress]);
5953     }
5954 
5955     function getBySemanticVersion(uint16[3] _semanticVersion)
5956         public
5957         view
5958         returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI)
5959     {
5960         return getByVersionId(versionIdForSemantic[semanticVersionHash(_semanticVersion)]);
5961     }
5962 
5963     function getByVersionId(uint _versionId) public view returns (uint16[3] semanticVersion, address contractAddress, bytes contentURI) {
5964         require(_versionId > 0 && _versionId < versionsNextIndex, ERROR_INEXISTENT_VERSION);
5965         Version storage version = versions[_versionId];
5966         return (version.semanticVersion, version.contractAddress, version.contentURI);
5967     }
5968 
5969     function getVersionsCount() public view returns (uint256) {
5970         return versionsNextIndex - 1;
5971     }
5972 
5973     function isValidBump(uint16[3] _oldVersion, uint16[3] _newVersion) public pure returns (bool) {
5974         bool hasBumped;
5975         uint i = 0;
5976         while (i < 3) {
5977             if (hasBumped) {
5978                 if (_newVersion[i] != 0) {
5979                     return false;
5980                 }
5981             } else if (_newVersion[i] != _oldVersion[i]) {
5982                 if (_oldVersion[i] > _newVersion[i] || _newVersion[i] - _oldVersion[i] != 1) {
5983                     return false;
5984                 }
5985                 hasBumped = true;
5986             }
5987             i++;
5988         }
5989         return hasBumped;
5990     }
5991 
5992     function semanticVersionHash(uint16[3] version) internal pure returns (bytes32) {
5993         return keccak256(abi.encodePacked(version[0], version[1], version[2]));
5994     }
5995 }
5996 
5997 // File: @aragon/os/contracts/apm/APMNamehash.sol
5998 
5999 /*
6000  * SPDX-License-Identitifer:    MIT
6001  */
6002 
6003 pragma solidity ^0.4.24;
6004 
6005 
6006 contract APMNamehash {
6007     /* Hardcoded constants to save gas
6008     bytes32 internal constant APM_NODE = keccak256(abi.encodePacked(ETH_TLD_NODE, keccak256(abi.encodePacked("aragonpm"))));
6009     */
6010     bytes32 internal constant APM_NODE = 0x9065c3e7f7b7ef1ef4e53d2d0b8e0cef02874ab020c1ece79d5f0d3d0111c0ba;
6011 
6012     function apmNamehash(string name) internal pure returns (bytes32) {
6013         return keccak256(abi.encodePacked(APM_NODE, keccak256(bytes(name))));
6014     }
6015 }
6016 
6017 // File: @aragon/os/contracts/kernel/KernelStorage.sol
6018 
6019 pragma solidity 0.4.24;
6020 
6021 
6022 contract KernelStorage {
6023     // namespace => app id => address
6024     mapping (bytes32 => mapping (bytes32 => address)) public apps;
6025     bytes32 public recoveryVaultAppId;
6026 }
6027 
6028 // File: @aragon/os/contracts/lib/misc/ERCProxy.sol
6029 
6030 /*
6031  * SPDX-License-Identitifer:    MIT
6032  */
6033 
6034 pragma solidity ^0.4.24;
6035 
6036 
6037 contract ERCProxy {
6038     uint256 internal constant FORWARDING = 1;
6039     uint256 internal constant UPGRADEABLE = 2;
6040 
6041     function proxyType() public pure returns (uint256 proxyTypeId);
6042     function implementation() public view returns (address codeAddr);
6043 }
6044 
6045 // File: @aragon/os/contracts/common/DelegateProxy.sol
6046 
6047 pragma solidity 0.4.24;
6048 
6049 
6050 
6051 
6052 contract DelegateProxy is ERCProxy, IsContract {
6053     uint256 internal constant FWD_GAS_LIMIT = 10000;
6054 
6055     /**
6056     * @dev Performs a delegatecall and returns whatever the delegatecall returned (entire context execution will return!)
6057     * @param _dst Destination address to perform the delegatecall
6058     * @param _calldata Calldata for the delegatecall
6059     */
6060     function delegatedFwd(address _dst, bytes _calldata) internal {
6061         require(isContract(_dst));
6062         uint256 fwdGasLimit = FWD_GAS_LIMIT;
6063 
6064         assembly {
6065             let result := delegatecall(sub(gas, fwdGasLimit), _dst, add(_calldata, 0x20), mload(_calldata), 0, 0)
6066             let size := returndatasize
6067             let ptr := mload(0x40)
6068             returndatacopy(ptr, 0, size)
6069 
6070             // revert instead of invalid() bc if the underlying call failed with invalid() it already wasted gas.
6071             // if the call returned error data, forward it
6072             switch result case 0 { revert(ptr, size) }
6073             default { return(ptr, size) }
6074         }
6075     }
6076 }
6077 
6078 // File: @aragon/os/contracts/common/DepositableDelegateProxy.sol
6079 
6080 pragma solidity 0.4.24;
6081 
6082 
6083 
6084 
6085 contract DepositableDelegateProxy is DepositableStorage, DelegateProxy {
6086     event ProxyDeposit(address sender, uint256 value);
6087 
6088     function () external payable {
6089         uint256 forwardGasThreshold = FWD_GAS_LIMIT;
6090         bytes32 isDepositablePosition = DEPOSITABLE_POSITION;
6091 
6092         // Optimized assembly implementation to prevent EIP-1884 from breaking deposits, reference code in Solidity:
6093         // https://github.com/aragon/aragonOS/blob/v4.2.1/contracts/common/DepositableDelegateProxy.sol#L10-L20
6094         assembly {
6095             // Continue only if the gas left is lower than the threshold for forwarding to the implementation code,
6096             // otherwise continue outside of the assembly block.
6097             if lt(gas, forwardGasThreshold) {
6098                 // Only accept the deposit and emit an event if all of the following are true:
6099                 // the proxy accepts deposits (isDepositable), msg.data.length == 0, and msg.value > 0
6100                 if and(and(sload(isDepositablePosition), iszero(calldatasize)), gt(callvalue, 0)) {
6101                     // Equivalent Solidity code for emitting the event:
6102                     // emit ProxyDeposit(msg.sender, msg.value);
6103 
6104                     let logData := mload(0x40) // free memory pointer
6105                     mstore(logData, caller) // add 'msg.sender' to the log data (first event param)
6106                     mstore(add(logData, 0x20), callvalue) // add 'msg.value' to the log data (second event param)
6107 
6108                     // Emit an event with one topic to identify the event: keccak256('ProxyDeposit(address,uint256)') = 0x15ee...dee1
6109                     log1(logData, 0x40, 0x15eeaa57c7bd188c1388020bcadc2c436ec60d647d36ef5b9eb3c742217ddee1)
6110 
6111                     stop() // Stop. Exits execution context
6112                 }
6113 
6114                 // If any of above checks failed, revert the execution (if ETH was sent, it is returned to the sender)
6115                 revert(0, 0)
6116             }
6117         }
6118 
6119         address target = implementation();
6120         delegatedFwd(target, msg.data);
6121     }
6122 }
6123 
6124 // File: @aragon/os/contracts/apps/AppProxyBase.sol
6125 
6126 pragma solidity 0.4.24;
6127 
6128 
6129 
6130 
6131 
6132 
6133 contract AppProxyBase is AppStorage, DepositableDelegateProxy, KernelNamespaceConstants {
6134     /**
6135     * @dev Initialize AppProxy
6136     * @param _kernel Reference to organization kernel for the app
6137     * @param _appId Identifier for app
6138     * @param _initializePayload Payload for call to be made after setup to initialize
6139     */
6140     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public {
6141         setKernel(_kernel);
6142         setAppId(_appId);
6143 
6144         // Implicit check that kernel is actually a Kernel
6145         // The EVM doesn't actually provide a way for us to make sure, but we can force a revert to
6146         // occur if the kernel is set to 0x0 or a non-code address when we try to call a method on
6147         // it.
6148         address appCode = getAppBase(_appId);
6149 
6150         // If initialize payload is provided, it will be executed
6151         if (_initializePayload.length > 0) {
6152             require(isContract(appCode));
6153             // Cannot make delegatecall as a delegateproxy.delegatedFwd as it
6154             // returns ending execution context and halts contract deployment
6155             require(appCode.delegatecall(_initializePayload));
6156         }
6157     }
6158 
6159     function getAppBase(bytes32 _appId) internal view returns (address) {
6160         return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
6161     }
6162 }
6163 
6164 // File: @aragon/os/contracts/apps/AppProxyUpgradeable.sol
6165 
6166 pragma solidity 0.4.24;
6167 
6168 
6169 
6170 contract AppProxyUpgradeable is AppProxyBase {
6171     /**
6172     * @dev Initialize AppProxyUpgradeable (makes it an upgradeable Aragon app)
6173     * @param _kernel Reference to organization kernel for the app
6174     * @param _appId Identifier for app
6175     * @param _initializePayload Payload for call to be made after setup to initialize
6176     */
6177     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
6178         AppProxyBase(_kernel, _appId, _initializePayload)
6179         public // solium-disable-line visibility-first
6180     {
6181         // solium-disable-previous-line no-empty-blocks
6182     }
6183 
6184     /**
6185      * @dev ERC897, the address the proxy would delegate calls to
6186      */
6187     function implementation() public view returns (address) {
6188         return getAppBase(appId());
6189     }
6190 
6191     /**
6192      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
6193      */
6194     function proxyType() public pure returns (uint256 proxyTypeId) {
6195         return UPGRADEABLE;
6196     }
6197 }
6198 
6199 // File: @aragon/os/contracts/apps/AppProxyPinned.sol
6200 
6201 pragma solidity 0.4.24;
6202 
6203 
6204 
6205 
6206 
6207 contract AppProxyPinned is IsContract, AppProxyBase {
6208     using UnstructuredStorage for bytes32;
6209 
6210     // keccak256("aragonOS.appStorage.pinnedCode")
6211     bytes32 internal constant PINNED_CODE_POSITION = 0xdee64df20d65e53d7f51cb6ab6d921a0a6a638a91e942e1d8d02df28e31c038e;
6212 
6213     /**
6214     * @dev Initialize AppProxyPinned (makes it an un-upgradeable Aragon app)
6215     * @param _kernel Reference to organization kernel for the app
6216     * @param _appId Identifier for app
6217     * @param _initializePayload Payload for call to be made after setup to initialize
6218     */
6219     constructor(IKernel _kernel, bytes32 _appId, bytes _initializePayload)
6220         AppProxyBase(_kernel, _appId, _initializePayload)
6221         public // solium-disable-line visibility-first
6222     {
6223         setPinnedCode(getAppBase(_appId));
6224         require(isContract(pinnedCode()));
6225     }
6226 
6227     /**
6228      * @dev ERC897, the address the proxy would delegate calls to
6229      */
6230     function implementation() public view returns (address) {
6231         return pinnedCode();
6232     }
6233 
6234     /**
6235      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
6236      */
6237     function proxyType() public pure returns (uint256 proxyTypeId) {
6238         return FORWARDING;
6239     }
6240 
6241     function setPinnedCode(address _pinnedCode) internal {
6242         PINNED_CODE_POSITION.setStorageAddress(_pinnedCode);
6243     }
6244 
6245     function pinnedCode() internal view returns (address) {
6246         return PINNED_CODE_POSITION.getStorageAddress();
6247     }
6248 }
6249 
6250 // File: @aragon/os/contracts/factory/AppProxyFactory.sol
6251 
6252 pragma solidity 0.4.24;
6253 
6254 
6255 
6256 
6257 contract AppProxyFactory {
6258     event NewAppProxy(address proxy, bool isUpgradeable, bytes32 appId);
6259 
6260     /**
6261     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId`
6262     * @param _kernel App's Kernel reference
6263     * @param _appId Identifier for app
6264     * @return AppProxyUpgradeable
6265     */
6266     function newAppProxy(IKernel _kernel, bytes32 _appId) public returns (AppProxyUpgradeable) {
6267         return newAppProxy(_kernel, _appId, new bytes(0));
6268     }
6269 
6270     /**
6271     * @notice Create a new upgradeable app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
6272     * @param _kernel App's Kernel reference
6273     * @param _appId Identifier for app
6274     * @return AppProxyUpgradeable
6275     */
6276     function newAppProxy(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyUpgradeable) {
6277         AppProxyUpgradeable proxy = new AppProxyUpgradeable(_kernel, _appId, _initializePayload);
6278         emit NewAppProxy(address(proxy), true, _appId);
6279         return proxy;
6280     }
6281 
6282     /**
6283     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId`
6284     * @param _kernel App's Kernel reference
6285     * @param _appId Identifier for app
6286     * @return AppProxyPinned
6287     */
6288     function newAppProxyPinned(IKernel _kernel, bytes32 _appId) public returns (AppProxyPinned) {
6289         return newAppProxyPinned(_kernel, _appId, new bytes(0));
6290     }
6291 
6292     /**
6293     * @notice Create a new pinned app instance on `_kernel` with identifier `_appId` and initialization payload `_initializePayload`
6294     * @param _kernel App's Kernel reference
6295     * @param _appId Identifier for app
6296     * @param _initializePayload Proxy initialization payload
6297     * @return AppProxyPinned
6298     */
6299     function newAppProxyPinned(IKernel _kernel, bytes32 _appId, bytes _initializePayload) public returns (AppProxyPinned) {
6300         AppProxyPinned proxy = new AppProxyPinned(_kernel, _appId, _initializePayload);
6301         emit NewAppProxy(address(proxy), false, _appId);
6302         return proxy;
6303     }
6304 }
6305 
6306 // File: @aragon/os/contracts/kernel/Kernel.sol
6307 
6308 pragma solidity 0.4.24;
6309 
6310 
6311 
6312 
6313 
6314 
6315 
6316 
6317 
6318 
6319 
6320 
6321 
6322 // solium-disable-next-line max-len
6323 contract Kernel is IKernel, KernelStorage, KernelAppIds, KernelNamespaceConstants, Petrifiable, IsContract, VaultRecoverable, AppProxyFactory, ACLSyntaxSugar {
6324     /* Hardcoded constants to save gas
6325     bytes32 public constant APP_MANAGER_ROLE = keccak256("APP_MANAGER_ROLE");
6326     */
6327     bytes32 public constant APP_MANAGER_ROLE = 0xb6d92708f3d4817afc106147d969e229ced5c46e65e0a5002a0d391287762bd0;
6328 
6329     string private constant ERROR_APP_NOT_CONTRACT = "KERNEL_APP_NOT_CONTRACT";
6330     string private constant ERROR_INVALID_APP_CHANGE = "KERNEL_INVALID_APP_CHANGE";
6331     string private constant ERROR_AUTH_FAILED = "KERNEL_AUTH_FAILED";
6332 
6333     /**
6334     * @dev Constructor that allows the deployer to choose if the base instance should be petrified immediately.
6335     * @param _shouldPetrify Immediately petrify this instance so that it can never be initialized
6336     */
6337     constructor(bool _shouldPetrify) public {
6338         if (_shouldPetrify) {
6339             petrify();
6340         }
6341     }
6342 
6343     /**
6344     * @dev Initialize can only be called once. It saves the block number in which it was initialized.
6345     * @notice Initialize this kernel instance along with its ACL and set `_permissionsCreator` as the entity that can create other permissions
6346     * @param _baseAcl Address of base ACL app
6347     * @param _permissionsCreator Entity that will be given permission over createPermission
6348     */
6349     function initialize(IACL _baseAcl, address _permissionsCreator) public onlyInit {
6350         initialized();
6351 
6352         // Set ACL base
6353         _setApp(KERNEL_APP_BASES_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, _baseAcl);
6354 
6355         // Create ACL instance and attach it as the default ACL app
6356         IACL acl = IACL(newAppProxy(this, KERNEL_DEFAULT_ACL_APP_ID));
6357         acl.initialize(_permissionsCreator);
6358         _setApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID, acl);
6359 
6360         recoveryVaultAppId = KERNEL_DEFAULT_VAULT_APP_ID;
6361     }
6362 
6363     /**
6364     * @dev Create a new instance of an app linked to this kernel
6365     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`
6366     * @param _appId Identifier for app
6367     * @param _appBase Address of the app's base implementation
6368     * @return AppProxy instance
6369     */
6370     function newAppInstance(bytes32 _appId, address _appBase)
6371         public
6372         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
6373         returns (ERCProxy appProxy)
6374     {
6375         return newAppInstance(_appId, _appBase, new bytes(0), false);
6376     }
6377 
6378     /**
6379     * @dev Create a new instance of an app linked to this kernel and set its base
6380     *      implementation if it was not already set
6381     * @notice Create a new upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
6382     * @param _appId Identifier for app
6383     * @param _appBase Address of the app's base implementation
6384     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
6385     * @param _setDefault Whether the app proxy app is the default one.
6386     *        Useful when the Kernel needs to know of an instance of a particular app,
6387     *        like Vault for escape hatch mechanism.
6388     * @return AppProxy instance
6389     */
6390     function newAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
6391         public
6392         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
6393         returns (ERCProxy appProxy)
6394     {
6395         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
6396         appProxy = newAppProxy(this, _appId, _initializePayload);
6397         // By calling setApp directly and not the internal functions, we make sure the params are checked
6398         // and it will only succeed if sender has permissions to set something to the namespace.
6399         if (_setDefault) {
6400             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
6401         }
6402     }
6403 
6404     /**
6405     * @dev Create a new pinned instance of an app linked to this kernel
6406     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`.
6407     * @param _appId Identifier for app
6408     * @param _appBase Address of the app's base implementation
6409     * @return AppProxy instance
6410     */
6411     function newPinnedAppInstance(bytes32 _appId, address _appBase)
6412         public
6413         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
6414         returns (ERCProxy appProxy)
6415     {
6416         return newPinnedAppInstance(_appId, _appBase, new bytes(0), false);
6417     }
6418 
6419     /**
6420     * @dev Create a new pinned instance of an app linked to this kernel and set
6421     *      its base implementation if it was not already set
6422     * @notice Create a new non-upgradeable instance of `_appId` app linked to the Kernel, setting its code to `_appBase`. `_setDefault ? 'Also sets it as the default app instance.':''`
6423     * @param _appId Identifier for app
6424     * @param _appBase Address of the app's base implementation
6425     * @param _initializePayload Payload for call made by the proxy during its construction to initialize
6426     * @param _setDefault Whether the app proxy app is the default one.
6427     *        Useful when the Kernel needs to know of an instance of a particular app,
6428     *        like Vault for escape hatch mechanism.
6429     * @return AppProxy instance
6430     */
6431     function newPinnedAppInstance(bytes32 _appId, address _appBase, bytes _initializePayload, bool _setDefault)
6432         public
6433         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_BASES_NAMESPACE, _appId))
6434         returns (ERCProxy appProxy)
6435     {
6436         _setAppIfNew(KERNEL_APP_BASES_NAMESPACE, _appId, _appBase);
6437         appProxy = newAppProxyPinned(this, _appId, _initializePayload);
6438         // By calling setApp directly and not the internal functions, we make sure the params are checked
6439         // and it will only succeed if sender has permissions to set something to the namespace.
6440         if (_setDefault) {
6441             setApp(KERNEL_APP_ADDR_NAMESPACE, _appId, appProxy);
6442         }
6443     }
6444 
6445     /**
6446     * @dev Set the resolving address of an app instance or base implementation
6447     * @notice Set the resolving address of `_appId` in namespace `_namespace` to `_app`
6448     * @param _namespace App namespace to use
6449     * @param _appId Identifier for app
6450     * @param _app Address of the app instance or base implementation
6451     * @return ID of app
6452     */
6453     function setApp(bytes32 _namespace, bytes32 _appId, address _app)
6454         public
6455         auth(APP_MANAGER_ROLE, arr(_namespace, _appId))
6456     {
6457         _setApp(_namespace, _appId, _app);
6458     }
6459 
6460     /**
6461     * @dev Set the default vault id for the escape hatch mechanism
6462     * @param _recoveryVaultAppId Identifier of the recovery vault app
6463     */
6464     function setRecoveryVaultAppId(bytes32 _recoveryVaultAppId)
6465         public
6466         auth(APP_MANAGER_ROLE, arr(KERNEL_APP_ADDR_NAMESPACE, _recoveryVaultAppId))
6467     {
6468         recoveryVaultAppId = _recoveryVaultAppId;
6469     }
6470 
6471     // External access to default app id and namespace constants to mimic default getters for constants
6472     /* solium-disable function-order, mixedcase */
6473     function CORE_NAMESPACE() external pure returns (bytes32) { return KERNEL_CORE_NAMESPACE; }
6474     function APP_BASES_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_BASES_NAMESPACE; }
6475     function APP_ADDR_NAMESPACE() external pure returns (bytes32) { return KERNEL_APP_ADDR_NAMESPACE; }
6476     function KERNEL_APP_ID() external pure returns (bytes32) { return KERNEL_CORE_APP_ID; }
6477     function DEFAULT_ACL_APP_ID() external pure returns (bytes32) { return KERNEL_DEFAULT_ACL_APP_ID; }
6478     /* solium-enable function-order, mixedcase */
6479 
6480     /**
6481     * @dev Get the address of an app instance or base implementation
6482     * @param _namespace App namespace to use
6483     * @param _appId Identifier for app
6484     * @return Address of the app
6485     */
6486     function getApp(bytes32 _namespace, bytes32 _appId) public view returns (address) {
6487         return apps[_namespace][_appId];
6488     }
6489 
6490     /**
6491     * @dev Get the address of the recovery Vault instance (to recover funds)
6492     * @return Address of the Vault
6493     */
6494     function getRecoveryVault() public view returns (address) {
6495         return apps[KERNEL_APP_ADDR_NAMESPACE][recoveryVaultAppId];
6496     }
6497 
6498     /**
6499     * @dev Get the installed ACL app
6500     * @return ACL app
6501     */
6502     function acl() public view returns (IACL) {
6503         return IACL(getApp(KERNEL_APP_ADDR_NAMESPACE, KERNEL_DEFAULT_ACL_APP_ID));
6504     }
6505 
6506     /**
6507     * @dev Function called by apps to check ACL on kernel or to check permission status
6508     * @param _who Sender of the original call
6509     * @param _where Address of the app
6510     * @param _what Identifier for a group of actions in app
6511     * @param _how Extra data for ACL auth
6512     * @return Boolean indicating whether the ACL allows the role or not.
6513     *         Always returns false if the kernel hasn't been initialized yet.
6514     */
6515     function hasPermission(address _who, address _where, bytes32 _what, bytes _how) public view returns (bool) {
6516         IACL defaultAcl = acl();
6517         return address(defaultAcl) != address(0) && // Poor man's initialization check (saves gas)
6518             defaultAcl.hasPermission(_who, _where, _what, _how);
6519     }
6520 
6521     function _setApp(bytes32 _namespace, bytes32 _appId, address _app) internal {
6522         require(isContract(_app), ERROR_APP_NOT_CONTRACT);
6523         apps[_namespace][_appId] = _app;
6524         emit SetApp(_namespace, _appId, _app);
6525     }
6526 
6527     function _setAppIfNew(bytes32 _namespace, bytes32 _appId, address _app) internal {
6528         address app = getApp(_namespace, _appId);
6529         if (app != address(0)) {
6530             // The only way to set an app is if it passes the isContract check, so no need to check it again
6531             require(app == _app, ERROR_INVALID_APP_CHANGE);
6532         } else {
6533             _setApp(_namespace, _appId, _app);
6534         }
6535     }
6536 
6537     modifier auth(bytes32 _role, uint256[] memory _params) {
6538         require(
6539             hasPermission(msg.sender, address(this), _role, ConversionHelpers.dangerouslyCastUintArrayToBytes(_params)),
6540             ERROR_AUTH_FAILED
6541         );
6542         _;
6543     }
6544 }
6545 
6546 // File: @aragon/os/contracts/lib/ens/AbstractENS.sol
6547 
6548 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/AbstractENS.sol
6549 
6550 pragma solidity ^0.4.15;
6551 
6552 
6553 interface AbstractENS {
6554     function owner(bytes32 _node) public constant returns (address);
6555     function resolver(bytes32 _node) public constant returns (address);
6556     function ttl(bytes32 _node) public constant returns (uint64);
6557     function setOwner(bytes32 _node, address _owner) public;
6558     function setSubnodeOwner(bytes32 _node, bytes32 label, address _owner) public;
6559     function setResolver(bytes32 _node, address _resolver) public;
6560     function setTTL(bytes32 _node, uint64 _ttl) public;
6561 
6562     // Logged when the owner of a node assigns a new owner to a subnode.
6563     event NewOwner(bytes32 indexed _node, bytes32 indexed _label, address _owner);
6564 
6565     // Logged when the owner of a node transfers ownership to a new account.
6566     event Transfer(bytes32 indexed _node, address _owner);
6567 
6568     // Logged when the resolver for a node changes.
6569     event NewResolver(bytes32 indexed _node, address _resolver);
6570 
6571     // Logged when the TTL of a node changes
6572     event NewTTL(bytes32 indexed _node, uint64 _ttl);
6573 }
6574 
6575 // File: @aragon/os/contracts/lib/ens/ENS.sol
6576 
6577 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/ENS.sol
6578 
6579 pragma solidity ^0.4.0;
6580 
6581 
6582 /**
6583  * The ENS registry contract.
6584  */
6585 contract ENS is AbstractENS {
6586     struct Record {
6587         address owner;
6588         address resolver;
6589         uint64 ttl;
6590     }
6591 
6592     mapping(bytes32=>Record) records;
6593 
6594     // Permits modifications only by the owner of the specified node.
6595     modifier only_owner(bytes32 node) {
6596         if (records[node].owner != msg.sender) throw;
6597         _;
6598     }
6599 
6600     /**
6601      * Constructs a new ENS registrar.
6602      */
6603     function ENS() public {
6604         records[0].owner = msg.sender;
6605     }
6606 
6607     /**
6608      * Returns the address that owns the specified node.
6609      */
6610     function owner(bytes32 node) public constant returns (address) {
6611         return records[node].owner;
6612     }
6613 
6614     /**
6615      * Returns the address of the resolver for the specified node.
6616      */
6617     function resolver(bytes32 node) public constant returns (address) {
6618         return records[node].resolver;
6619     }
6620 
6621     /**
6622      * Returns the TTL of a node, and any records associated with it.
6623      */
6624     function ttl(bytes32 node) public constant returns (uint64) {
6625         return records[node].ttl;
6626     }
6627 
6628     /**
6629      * Transfers ownership of a node to a new address. May only be called by the current
6630      * owner of the node.
6631      * @param node The node to transfer ownership of.
6632      * @param owner The address of the new owner.
6633      */
6634     function setOwner(bytes32 node, address owner) only_owner(node) public {
6635         Transfer(node, owner);
6636         records[node].owner = owner;
6637     }
6638 
6639     /**
6640      * Transfers ownership of a subnode keccak256(node, label) to a new address. May only be
6641      * called by the owner of the parent node.
6642      * @param node The parent node.
6643      * @param label The hash of the label specifying the subnode.
6644      * @param owner The address of the new owner.
6645      */
6646     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) only_owner(node) public {
6647         var subnode = keccak256(node, label);
6648         NewOwner(node, label, owner);
6649         records[subnode].owner = owner;
6650     }
6651 
6652     /**
6653      * Sets the resolver address for the specified node.
6654      * @param node The node to update.
6655      * @param resolver The address of the resolver.
6656      */
6657     function setResolver(bytes32 node, address resolver) only_owner(node) public {
6658         NewResolver(node, resolver);
6659         records[node].resolver = resolver;
6660     }
6661 
6662     /**
6663      * Sets the TTL for the specified node.
6664      * @param node The node to update.
6665      * @param ttl The TTL in seconds.
6666      */
6667     function setTTL(bytes32 node, uint64 ttl) only_owner(node) public {
6668         NewTTL(node, ttl);
6669         records[node].ttl = ttl;
6670     }
6671 }
6672 
6673 // File: @aragon/os/contracts/lib/ens/PublicResolver.sol
6674 
6675 // See https://github.com/ensdomains/ens/blob/7e377df83f/contracts/PublicResolver.sol
6676 
6677 pragma solidity ^0.4.0;
6678 
6679 
6680 /**
6681  * A simple resolver anyone can use; only allows the owner of a node to set its
6682  * address.
6683  */
6684 contract PublicResolver {
6685     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
6686     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
6687     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
6688     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
6689     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
6690     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
6691     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
6692 
6693     event AddrChanged(bytes32 indexed node, address a);
6694     event ContentChanged(bytes32 indexed node, bytes32 hash);
6695     event NameChanged(bytes32 indexed node, string name);
6696     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
6697     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
6698     event TextChanged(bytes32 indexed node, string indexed indexedKey, string key);
6699 
6700     struct PublicKey {
6701         bytes32 x;
6702         bytes32 y;
6703     }
6704 
6705     struct Record {
6706         address addr;
6707         bytes32 content;
6708         string name;
6709         PublicKey pubkey;
6710         mapping(string=>string) text;
6711         mapping(uint256=>bytes) abis;
6712     }
6713 
6714     AbstractENS ens;
6715     mapping(bytes32=>Record) records;
6716 
6717     modifier only_owner(bytes32 node) {
6718         if (ens.owner(node) != msg.sender) throw;
6719         _;
6720     }
6721 
6722     /**
6723      * Constructor.
6724      * @param ensAddr The ENS registrar contract.
6725      */
6726     function PublicResolver(AbstractENS ensAddr) public {
6727         ens = ensAddr;
6728     }
6729 
6730     /**
6731      * Returns true if the resolver implements the interface specified by the provided hash.
6732      * @param interfaceID The ID of the interface to check for.
6733      * @return True if the contract implements the requested interface.
6734      */
6735     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
6736         return interfaceID == ADDR_INTERFACE_ID ||
6737                interfaceID == CONTENT_INTERFACE_ID ||
6738                interfaceID == NAME_INTERFACE_ID ||
6739                interfaceID == ABI_INTERFACE_ID ||
6740                interfaceID == PUBKEY_INTERFACE_ID ||
6741                interfaceID == TEXT_INTERFACE_ID ||
6742                interfaceID == INTERFACE_META_ID;
6743     }
6744 
6745     /**
6746      * Returns the address associated with an ENS node.
6747      * @param node The ENS node to query.
6748      * @return The associated address.
6749      */
6750     function addr(bytes32 node) public constant returns (address ret) {
6751         ret = records[node].addr;
6752     }
6753 
6754     /**
6755      * Sets the address associated with an ENS node.
6756      * May only be called by the owner of that node in the ENS registry.
6757      * @param node The node to update.
6758      * @param addr The address to set.
6759      */
6760     function setAddr(bytes32 node, address addr) only_owner(node) public {
6761         records[node].addr = addr;
6762         AddrChanged(node, addr);
6763     }
6764 
6765     /**
6766      * Returns the content hash associated with an ENS node.
6767      * Note that this resource type is not standardized, and will likely change
6768      * in future to a resource type based on multihash.
6769      * @param node The ENS node to query.
6770      * @return The associated content hash.
6771      */
6772     function content(bytes32 node) public constant returns (bytes32 ret) {
6773         ret = records[node].content;
6774     }
6775 
6776     /**
6777      * Sets the content hash associated with an ENS node.
6778      * May only be called by the owner of that node in the ENS registry.
6779      * Note that this resource type is not standardized, and will likely change
6780      * in future to a resource type based on multihash.
6781      * @param node The node to update.
6782      * @param hash The content hash to set
6783      */
6784     function setContent(bytes32 node, bytes32 hash) only_owner(node) public {
6785         records[node].content = hash;
6786         ContentChanged(node, hash);
6787     }
6788 
6789     /**
6790      * Returns the name associated with an ENS node, for reverse records.
6791      * Defined in EIP181.
6792      * @param node The ENS node to query.
6793      * @return The associated name.
6794      */
6795     function name(bytes32 node) public constant returns (string ret) {
6796         ret = records[node].name;
6797     }
6798 
6799     /**
6800      * Sets the name associated with an ENS node, for reverse records.
6801      * May only be called by the owner of that node in the ENS registry.
6802      * @param node The node to update.
6803      * @param name The name to set.
6804      */
6805     function setName(bytes32 node, string name) only_owner(node) public {
6806         records[node].name = name;
6807         NameChanged(node, name);
6808     }
6809 
6810     /**
6811      * Returns the ABI associated with an ENS node.
6812      * Defined in EIP205.
6813      * @param node The ENS node to query
6814      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
6815      * @return contentType The content type of the return value
6816      * @return data The ABI data
6817      */
6818     function ABI(bytes32 node, uint256 contentTypes) public constant returns (uint256 contentType, bytes data) {
6819         var record = records[node];
6820         for(contentType = 1; contentType <= contentTypes; contentType <<= 1) {
6821             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
6822                 data = record.abis[contentType];
6823                 return;
6824             }
6825         }
6826         contentType = 0;
6827     }
6828 
6829     /**
6830      * Sets the ABI associated with an ENS node.
6831      * Nodes may have one ABI of each content type. To remove an ABI, set it to
6832      * the empty string.
6833      * @param node The node to update.
6834      * @param contentType The content type of the ABI
6835      * @param data The ABI data.
6836      */
6837     function setABI(bytes32 node, uint256 contentType, bytes data) only_owner(node) public {
6838         // Content types must be powers of 2
6839         if (((contentType - 1) & contentType) != 0) throw;
6840 
6841         records[node].abis[contentType] = data;
6842         ABIChanged(node, contentType);
6843     }
6844 
6845     /**
6846      * Returns the SECP256k1 public key associated with an ENS node.
6847      * Defined in EIP 619.
6848      * @param node The ENS node to query
6849      * @return x, y the X and Y coordinates of the curve point for the public key.
6850      */
6851     function pubkey(bytes32 node) public constant returns (bytes32 x, bytes32 y) {
6852         return (records[node].pubkey.x, records[node].pubkey.y);
6853     }
6854 
6855     /**
6856      * Sets the SECP256k1 public key associated with an ENS node.
6857      * @param node The ENS node to query
6858      * @param x the X coordinate of the curve point for the public key.
6859      * @param y the Y coordinate of the curve point for the public key.
6860      */
6861     function setPubkey(bytes32 node, bytes32 x, bytes32 y) only_owner(node) public {
6862         records[node].pubkey = PublicKey(x, y);
6863         PubkeyChanged(node, x, y);
6864     }
6865 
6866     /**
6867      * Returns the text data associated with an ENS node and key.
6868      * @param node The ENS node to query.
6869      * @param key The text data key to query.
6870      * @return The associated text data.
6871      */
6872     function text(bytes32 node, string key) public constant returns (string ret) {
6873         ret = records[node].text[key];
6874     }
6875 
6876     /**
6877      * Sets the text data associated with an ENS node and key.
6878      * May only be called by the owner of that node in the ENS registry.
6879      * @param node The node to update.
6880      * @param key The key to set.
6881      * @param value The text data value to set.
6882      */
6883     function setText(bytes32 node, string key, string value) only_owner(node) public {
6884         records[node].text[key] = value;
6885         TextChanged(node, key, key);
6886     }
6887 }
6888 
6889 // File: @aragon/os/contracts/kernel/KernelProxy.sol
6890 
6891 pragma solidity 0.4.24;
6892 
6893 
6894 
6895 
6896 
6897 
6898 
6899 contract KernelProxy is IKernelEvents, KernelStorage, KernelAppIds, KernelNamespaceConstants, IsContract, DepositableDelegateProxy {
6900     /**
6901     * @dev KernelProxy is a proxy contract to a kernel implementation. The implementation
6902     *      can update the reference, which effectively upgrades the contract
6903     * @param _kernelImpl Address of the contract used as implementation for kernel
6904     */
6905     constructor(IKernel _kernelImpl) public {
6906         require(isContract(address(_kernelImpl)));
6907         apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID] = _kernelImpl;
6908 
6909         // Note that emitting this event is important for verifying that a KernelProxy instance
6910         // was never upgraded to a malicious Kernel logic contract over its lifespan.
6911         // This starts the "chain of trust", that can be followed through later SetApp() events
6912         // emitted during kernel upgrades.
6913         emit SetApp(KERNEL_CORE_NAMESPACE, KERNEL_CORE_APP_ID, _kernelImpl);
6914     }
6915 
6916     /**
6917      * @dev ERC897, whether it is a forwarding (1) or an upgradeable (2) proxy
6918      */
6919     function proxyType() public pure returns (uint256 proxyTypeId) {
6920         return UPGRADEABLE;
6921     }
6922 
6923     /**
6924     * @dev ERC897, the address the proxy would delegate calls to
6925     */
6926     function implementation() public view returns (address) {
6927         return apps[KERNEL_CORE_NAMESPACE][KERNEL_CORE_APP_ID];
6928     }
6929 }
6930 
6931 // File: @aragon/os/contracts/evmscript/ScriptHelpers.sol
6932 
6933 /*
6934  * SPDX-License-Identitifer:    MIT
6935  */
6936 
6937 pragma solidity ^0.4.24;
6938 
6939 
6940 library ScriptHelpers {
6941     function getSpecId(bytes _script) internal pure returns (uint32) {
6942         return uint32At(_script, 0);
6943     }
6944 
6945     function uint256At(bytes _data, uint256 _location) internal pure returns (uint256 result) {
6946         assembly {
6947             result := mload(add(_data, add(0x20, _location)))
6948         }
6949     }
6950 
6951     function addressAt(bytes _data, uint256 _location) internal pure returns (address result) {
6952         uint256 word = uint256At(_data, _location);
6953 
6954         assembly {
6955             result := div(and(word, 0xffffffffffffffffffffffffffffffffffffffff000000000000000000000000),
6956             0x1000000000000000000000000)
6957         }
6958     }
6959 
6960     function uint32At(bytes _data, uint256 _location) internal pure returns (uint32 result) {
6961         uint256 word = uint256At(_data, _location);
6962 
6963         assembly {
6964             result := div(and(word, 0xffffffff00000000000000000000000000000000000000000000000000000000),
6965             0x100000000000000000000000000000000000000000000000000000000)
6966         }
6967     }
6968 
6969     function locationOf(bytes _data, uint256 _location) internal pure returns (uint256 result) {
6970         assembly {
6971             result := add(_data, add(0x20, _location))
6972         }
6973     }
6974 
6975     function toBytes(bytes4 _sig) internal pure returns (bytes) {
6976         bytes memory payload = new bytes(4);
6977         assembly { mstore(add(payload, 0x20), _sig) }
6978         return payload;
6979     }
6980 }
6981 
6982 // File: @aragon/os/contracts/evmscript/EVMScriptRegistry.sol
6983 
6984 pragma solidity 0.4.24;
6985 
6986 
6987 
6988 
6989 
6990 
6991 /* solium-disable function-order */
6992 // Allow public initialize() to be first
6993 contract EVMScriptRegistry is IEVMScriptRegistry, EVMScriptRegistryConstants, AragonApp {
6994     using ScriptHelpers for bytes;
6995 
6996     /* Hardcoded constants to save gas
6997     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = keccak256("REGISTRY_ADD_EXECUTOR_ROLE");
6998     bytes32 public constant REGISTRY_MANAGER_ROLE = keccak256("REGISTRY_MANAGER_ROLE");
6999     */
7000     bytes32 public constant REGISTRY_ADD_EXECUTOR_ROLE = 0xc4e90f38eea8c4212a009ca7b8947943ba4d4a58d19b683417f65291d1cd9ed2;
7001     // WARN: Manager can censor all votes and the like happening in an org
7002     bytes32 public constant REGISTRY_MANAGER_ROLE = 0xf7a450ef335e1892cb42c8ca72e7242359d7711924b75db5717410da3f614aa3;
7003 
7004     uint256 internal constant SCRIPT_START_LOCATION = 4;
7005 
7006     string private constant ERROR_INEXISTENT_EXECUTOR = "EVMREG_INEXISTENT_EXECUTOR";
7007     string private constant ERROR_EXECUTOR_ENABLED = "EVMREG_EXECUTOR_ENABLED";
7008     string private constant ERROR_EXECUTOR_DISABLED = "EVMREG_EXECUTOR_DISABLED";
7009     string private constant ERROR_SCRIPT_LENGTH_TOO_SHORT = "EVMREG_SCRIPT_LENGTH_TOO_SHORT";
7010 
7011     struct ExecutorEntry {
7012         IEVMScriptExecutor executor;
7013         bool enabled;
7014     }
7015 
7016     uint256 private executorsNextIndex;
7017     mapping (uint256 => ExecutorEntry) public executors;
7018 
7019     event EnableExecutor(uint256 indexed executorId, address indexed executorAddress);
7020     event DisableExecutor(uint256 indexed executorId, address indexed executorAddress);
7021 
7022     modifier executorExists(uint256 _executorId) {
7023         require(_executorId > 0 && _executorId < executorsNextIndex, ERROR_INEXISTENT_EXECUTOR);
7024         _;
7025     }
7026 
7027     /**
7028     * @notice Initialize the registry
7029     */
7030     function initialize() public onlyInit {
7031         initialized();
7032         // Create empty record to begin executor IDs at 1
7033         executorsNextIndex = 1;
7034     }
7035 
7036     /**
7037     * @notice Add a new script executor with address `_executor` to the registry
7038     * @param _executor Address of the IEVMScriptExecutor that will be added to the registry
7039     * @return id Identifier of the executor in the registry
7040     */
7041     function addScriptExecutor(IEVMScriptExecutor _executor) external auth(REGISTRY_ADD_EXECUTOR_ROLE) returns (uint256 id) {
7042         uint256 executorId = executorsNextIndex++;
7043         executors[executorId] = ExecutorEntry(_executor, true);
7044         emit EnableExecutor(executorId, _executor);
7045         return executorId;
7046     }
7047 
7048     /**
7049     * @notice Disable script executor with ID `_executorId`
7050     * @param _executorId Identifier of the executor in the registry
7051     */
7052     function disableScriptExecutor(uint256 _executorId)
7053         external
7054         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
7055     {
7056         // Note that we don't need to check for an executor's existence in this case, as only
7057         // existing executors can be enabled
7058         ExecutorEntry storage executorEntry = executors[_executorId];
7059         require(executorEntry.enabled, ERROR_EXECUTOR_DISABLED);
7060         executorEntry.enabled = false;
7061         emit DisableExecutor(_executorId, executorEntry.executor);
7062     }
7063 
7064     /**
7065     * @notice Enable script executor with ID `_executorId`
7066     * @param _executorId Identifier of the executor in the registry
7067     */
7068     function enableScriptExecutor(uint256 _executorId)
7069         external
7070         authP(REGISTRY_MANAGER_ROLE, arr(_executorId))
7071         executorExists(_executorId)
7072     {
7073         ExecutorEntry storage executorEntry = executors[_executorId];
7074         require(!executorEntry.enabled, ERROR_EXECUTOR_ENABLED);
7075         executorEntry.enabled = true;
7076         emit EnableExecutor(_executorId, executorEntry.executor);
7077     }
7078 
7079     /**
7080     * @dev Get the script executor that can execute a particular script based on its first 4 bytes
7081     * @param _script EVMScript being inspected
7082     */
7083     function getScriptExecutor(bytes _script) public view returns (IEVMScriptExecutor) {
7084         require(_script.length >= SCRIPT_START_LOCATION, ERROR_SCRIPT_LENGTH_TOO_SHORT);
7085         uint256 id = _script.getSpecId();
7086 
7087         // Note that we don't need to check for an executor's existence in this case, as only
7088         // existing executors can be enabled
7089         ExecutorEntry storage entry = executors[id];
7090         return entry.enabled ? entry.executor : IEVMScriptExecutor(0);
7091     }
7092 }
7093 
7094 // File: @aragon/os/contracts/evmscript/executors/BaseEVMScriptExecutor.sol
7095 
7096 /*
7097  * SPDX-License-Identitifer:    MIT
7098  */
7099 
7100 pragma solidity ^0.4.24;
7101 
7102 
7103 
7104 
7105 contract BaseEVMScriptExecutor is IEVMScriptExecutor, Autopetrified {
7106     uint256 internal constant SCRIPT_START_LOCATION = 4;
7107 }
7108 
7109 // File: @aragon/os/contracts/evmscript/executors/CallsScript.sol
7110 
7111 pragma solidity 0.4.24;
7112 
7113 // Inspired by https://github.com/reverendus/tx-manager
7114 
7115 
7116 
7117 
7118 contract CallsScript is BaseEVMScriptExecutor {
7119     using ScriptHelpers for bytes;
7120 
7121     /* Hardcoded constants to save gas
7122     bytes32 internal constant EXECUTOR_TYPE = keccak256("CALLS_SCRIPT");
7123     */
7124     bytes32 internal constant EXECUTOR_TYPE = 0x2dc858a00f3e417be1394b87c07158e989ec681ce8cc68a9093680ac1a870302;
7125 
7126     string private constant ERROR_BLACKLISTED_CALL = "EVMCALLS_BLACKLISTED_CALL";
7127     string private constant ERROR_INVALID_LENGTH = "EVMCALLS_INVALID_LENGTH";
7128 
7129     /* This is manually crafted in assembly
7130     string private constant ERROR_CALL_REVERTED = "EVMCALLS_CALL_REVERTED";
7131     */
7132 
7133     event LogScriptCall(address indexed sender, address indexed src, address indexed dst);
7134 
7135     /**
7136     * @notice Executes a number of call scripts
7137     * @param _script [ specId (uint32) ] many calls with this structure ->
7138     *    [ to (address: 20 bytes) ] [ calldataLength (uint32: 4 bytes) ] [ calldata (calldataLength bytes) ]
7139     * @param _blacklist Addresses the script cannot call to, or will revert.
7140     * @return Always returns empty byte array
7141     */
7142     function execScript(bytes _script, bytes, address[] _blacklist) external isInitialized returns (bytes) {
7143         uint256 location = SCRIPT_START_LOCATION; // first 32 bits are spec id
7144         while (location < _script.length) {
7145             // Check there's at least address + calldataLength available
7146             require(_script.length - location >= 0x18, ERROR_INVALID_LENGTH);
7147 
7148             address contractAddress = _script.addressAt(location);
7149             // Check address being called is not blacklist
7150             for (uint256 i = 0; i < _blacklist.length; i++) {
7151                 require(contractAddress != _blacklist[i], ERROR_BLACKLISTED_CALL);
7152             }
7153 
7154             // logged before execution to ensure event ordering in receipt
7155             // if failed entire execution is reverted regardless
7156             emit LogScriptCall(msg.sender, address(this), contractAddress);
7157 
7158             uint256 calldataLength = uint256(_script.uint32At(location + 0x14));
7159             uint256 startOffset = location + 0x14 + 0x04;
7160             uint256 calldataStart = _script.locationOf(startOffset);
7161 
7162             // compute end of script / next location
7163             location = startOffset + calldataLength;
7164             require(location <= _script.length, ERROR_INVALID_LENGTH);
7165 
7166             bool success;
7167             assembly {
7168                 success := call(
7169                     sub(gas, 5000),       // forward gas left - 5000
7170                     contractAddress,      // address
7171                     0,                    // no value
7172                     calldataStart,        // calldata start
7173                     calldataLength,       // calldata length
7174                     0,                    // don't write output
7175                     0                     // don't write output
7176                 )
7177 
7178                 switch success
7179                 case 0 {
7180                     let ptr := mload(0x40)
7181 
7182                     switch returndatasize
7183                     case 0 {
7184                         // No error data was returned, revert with "EVMCALLS_CALL_REVERTED"
7185                         // See remix: doing a `revert("EVMCALLS_CALL_REVERTED")` always results in
7186                         // this memory layout
7187                         mstore(ptr, 0x08c379a000000000000000000000000000000000000000000000000000000000)         // error identifier
7188                         mstore(add(ptr, 0x04), 0x0000000000000000000000000000000000000000000000000000000000000020) // starting offset
7189                         mstore(add(ptr, 0x24), 0x0000000000000000000000000000000000000000000000000000000000000016) // reason length
7190                         mstore(add(ptr, 0x44), 0x45564d43414c4c535f43414c4c5f524556455254454400000000000000000000) // reason
7191 
7192                         revert(ptr, 100) // 100 = 4 + 3 * 32 (error identifier + 3 words for the ABI encoded error)
7193                     }
7194                     default {
7195                         // Forward the full error data
7196                         returndatacopy(ptr, 0, returndatasize)
7197                         revert(ptr, returndatasize)
7198                     }
7199                 }
7200                 default { }
7201             }
7202         }
7203         // No need to allocate empty bytes for the return as this can only be called via an delegatecall
7204         // (due to the isInitialized modifier)
7205     }
7206 
7207     function executorType() external pure returns (bytes32) {
7208         return EXECUTOR_TYPE;
7209     }
7210 }
7211 
7212 // File: @aragon/os/contracts/factory/EVMScriptRegistryFactory.sol
7213 
7214 pragma solidity 0.4.24;
7215 
7216 
7217 
7218 
7219 
7220 
7221 
7222 contract EVMScriptRegistryFactory is EVMScriptRegistryConstants {
7223     EVMScriptRegistry public baseReg;
7224     IEVMScriptExecutor public baseCallScript;
7225 
7226     /**
7227     * @notice Create a new EVMScriptRegistryFactory.
7228     */
7229     constructor() public {
7230         baseReg = new EVMScriptRegistry();
7231         baseCallScript = IEVMScriptExecutor(new CallsScript());
7232     }
7233 
7234     /**
7235     * @notice Install a new pinned instance of EVMScriptRegistry on `_dao`.
7236     * @param _dao Kernel
7237     * @return Installed EVMScriptRegistry
7238     */
7239     function newEVMScriptRegistry(Kernel _dao) public returns (EVMScriptRegistry reg) {
7240         bytes memory initPayload = abi.encodeWithSelector(reg.initialize.selector);
7241         reg = EVMScriptRegistry(_dao.newPinnedAppInstance(EVMSCRIPT_REGISTRY_APP_ID, baseReg, initPayload, true));
7242 
7243         ACL acl = ACL(_dao.acl());
7244 
7245         acl.createPermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE(), this);
7246 
7247         reg.addScriptExecutor(baseCallScript);     // spec 1 = CallsScript
7248 
7249         // Clean up the permissions
7250         acl.revokePermission(this, reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
7251         acl.removePermissionManager(reg, reg.REGISTRY_ADD_EXECUTOR_ROLE());
7252 
7253         return reg;
7254     }
7255 }
7256 
7257 // File: @aragon/os/contracts/factory/DAOFactory.sol
7258 
7259 pragma solidity 0.4.24;
7260 
7261 
7262 
7263 
7264 
7265 
7266 
7267 
7268 contract DAOFactory {
7269     IKernel public baseKernel;
7270     IACL public baseACL;
7271     EVMScriptRegistryFactory public regFactory;
7272 
7273     event DeployDAO(address dao);
7274     event DeployEVMScriptRegistry(address reg);
7275 
7276     /**
7277     * @notice Create a new DAOFactory, creating DAOs with Kernels proxied to `_baseKernel`, ACLs proxied to `_baseACL`, and new EVMScriptRegistries created from `_regFactory`.
7278     * @param _baseKernel Base Kernel
7279     * @param _baseACL Base ACL
7280     * @param _regFactory EVMScriptRegistry factory
7281     */
7282     constructor(IKernel _baseKernel, IACL _baseACL, EVMScriptRegistryFactory _regFactory) public {
7283         // No need to init as it cannot be killed by devops199
7284         if (address(_regFactory) != address(0)) {
7285             regFactory = _regFactory;
7286         }
7287 
7288         baseKernel = _baseKernel;
7289         baseACL = _baseACL;
7290     }
7291 
7292     /**
7293     * @notice Create a new DAO with `_root` set as the initial admin
7294     * @param _root Address that will be granted control to setup DAO permissions
7295     * @return Newly created DAO
7296     */
7297     function newDAO(address _root) public returns (Kernel) {
7298         Kernel dao = Kernel(new KernelProxy(baseKernel));
7299 
7300         if (address(regFactory) == address(0)) {
7301             dao.initialize(baseACL, _root);
7302         } else {
7303             dao.initialize(baseACL, this);
7304 
7305             ACL acl = ACL(dao.acl());
7306             bytes32 permRole = acl.CREATE_PERMISSIONS_ROLE();
7307             bytes32 appManagerRole = dao.APP_MANAGER_ROLE();
7308 
7309             acl.grantPermission(regFactory, acl, permRole);
7310 
7311             acl.createPermission(regFactory, dao, appManagerRole, this);
7312 
7313             EVMScriptRegistry reg = regFactory.newEVMScriptRegistry(dao);
7314             emit DeployEVMScriptRegistry(address(reg));
7315 
7316             // Clean up permissions
7317             // First, completely reset the APP_MANAGER_ROLE
7318             acl.revokePermission(regFactory, dao, appManagerRole);
7319             acl.removePermissionManager(dao, appManagerRole);
7320 
7321             // Then, make root the only holder and manager of CREATE_PERMISSIONS_ROLE
7322             acl.revokePermission(regFactory, acl, permRole);
7323             acl.revokePermission(this, acl, permRole);
7324             acl.grantPermission(_root, acl, permRole);
7325             acl.setPermissionManager(_root, acl, permRole);
7326         }
7327 
7328         emit DeployDAO(address(dao));
7329 
7330         return dao;
7331     }
7332 }
7333 
7334 // File: @aragon/id/contracts/ens/IPublicResolver.sol
7335 
7336 pragma solidity ^0.4.0;
7337 
7338 
7339 interface IPublicResolver {
7340     function supportsInterface(bytes4 interfaceID) constant returns (bool);
7341     function addr(bytes32 node) constant returns (address ret);
7342     function setAddr(bytes32 node, address addr);
7343     function hash(bytes32 node) constant returns (bytes32 ret);
7344     function setHash(bytes32 node, bytes32 hash);
7345 }
7346 
7347 // File: @aragon/id/contracts/IFIFSResolvingRegistrar.sol
7348 
7349 pragma solidity 0.4.24;
7350 
7351 
7352 
7353 interface IFIFSResolvingRegistrar {
7354     function register(bytes32 _subnode, address _owner) external;
7355     function registerWithResolver(bytes32 _subnode, address _owner, IPublicResolver _resolver) public;
7356 }
7357 
7358 // File: @aragon/templates-shared/contracts/BaseTemplate.sol
7359 
7360 pragma solidity 0.4.24;
7361 
7362 
7363 
7364 
7365 
7366 
7367 
7368 
7369 
7370 
7371 
7372 
7373 
7374 
7375 
7376 
7377 
7378 
7379 
7380 
7381 contract BaseTemplate is APMNamehash, IsContract {
7382     using Uint256Helpers for uint256;
7383 
7384     /* Hardcoded constant to save gas
7385     * bytes32 constant internal AGENT_APP_ID = apmNamehash("agent");                  // agent.aragonpm.eth
7386     * bytes32 constant internal VAULT_APP_ID = apmNamehash("vault");                  // vault.aragonpm.eth
7387     * bytes32 constant internal VOTING_APP_ID = apmNamehash("voting");                // voting.aragonpm.eth
7388     * bytes32 constant internal SURVEY_APP_ID = apmNamehash("survey");                // survey.aragonpm.eth
7389     * bytes32 constant internal PAYROLL_APP_ID = apmNamehash("payroll");              // payroll.aragonpm.eth
7390     * bytes32 constant internal FINANCE_APP_ID = apmNamehash("finance");              // finance.aragonpm.eth
7391     * bytes32 constant internal TOKEN_MANAGER_APP_ID = apmNamehash("token-manager");  // token-manager.aragonpm.eth
7392     */
7393     bytes32 constant internal AGENT_APP_ID = 0x9ac98dc5f995bf0211ed589ef022719d1487e5cb2bab505676f0d084c07cf89a;
7394     bytes32 constant internal VAULT_APP_ID = 0x7e852e0fcfce6551c13800f1e7476f982525c2b5277ba14b24339c68416336d1;
7395     bytes32 constant internal VOTING_APP_ID = 0x9fa3927f639745e587912d4b0fea7ef9013bf93fb907d29faeab57417ba6e1d4;
7396     bytes32 constant internal PAYROLL_APP_ID = 0x463f596a96d808cb28b5d080181e4a398bc793df2c222f6445189eb801001991;
7397     bytes32 constant internal FINANCE_APP_ID = 0xbf8491150dafc5dcaee5b861414dca922de09ccffa344964ae167212e8c673ae;
7398     bytes32 constant internal TOKEN_MANAGER_APP_ID = 0x6b20a3010614eeebf2138ccec99f028a61c811b3b1a3343b6ff635985c75c91f;
7399     bytes32 constant internal SURVEY_APP_ID = 0x030b2ab880b88e228f2da5a3d19a2a31bc10dbf91fb1143776a6de489389471e;
7400 
7401     string constant private ERROR_ENS_NOT_CONTRACT = "TEMPLATE_ENS_NOT_CONTRACT";
7402     string constant private ERROR_DAO_FACTORY_NOT_CONTRACT = "TEMPLATE_DAO_FAC_NOT_CONTRACT";
7403     string constant private ERROR_ARAGON_ID_NOT_PROVIDED = "TEMPLATE_ARAGON_ID_NOT_PROVIDED";
7404     string constant private ERROR_ARAGON_ID_NOT_CONTRACT = "TEMPLATE_ARAGON_ID_NOT_CONTRACT";
7405     string constant private ERROR_MINIME_FACTORY_NOT_PROVIDED = "TEMPLATE_MINIME_FAC_NOT_PROVIDED";
7406     string constant private ERROR_MINIME_FACTORY_NOT_CONTRACT = "TEMPLATE_MINIME_FAC_NOT_CONTRACT";
7407     string constant private ERROR_CANNOT_CAST_VALUE_TO_ADDRESS = "TEMPLATE_CANNOT_CAST_VALUE_TO_ADDRESS";
7408     string constant private ERROR_INVALID_ID = "TEMPLATE_INVALID_ID";
7409 
7410     ENS internal ens;
7411     DAOFactory internal daoFactory;
7412     MiniMeTokenFactory internal miniMeFactory;
7413     IFIFSResolvingRegistrar internal aragonID;
7414 
7415     event DeployDao(address dao);
7416     event SetupDao(address dao);
7417     event DeployToken(address token);
7418     event InstalledApp(address appProxy, bytes32 appId);
7419 
7420     constructor(DAOFactory _daoFactory, ENS _ens, MiniMeTokenFactory _miniMeFactory, IFIFSResolvingRegistrar _aragonID) public {
7421         require(isContract(address(_ens)), ERROR_ENS_NOT_CONTRACT);
7422         require(isContract(address(_daoFactory)), ERROR_DAO_FACTORY_NOT_CONTRACT);
7423 
7424         ens = _ens;
7425         aragonID = _aragonID;
7426         daoFactory = _daoFactory;
7427         miniMeFactory = _miniMeFactory;
7428     }
7429 
7430     /**
7431     * @dev Create a DAO using the DAO Factory and grant the template root permissions so it has full
7432     *      control during setup. Once the DAO setup has finished, it is recommended to call the
7433     *      `_transferRootPermissionsFromTemplateAndFinalizeDAO()` helper to transfer the root
7434     *      permissions to the end entity in control of the organization.
7435     */
7436     function _createDAO() internal returns (Kernel dao, ACL acl) {
7437         dao = daoFactory.newDAO(this);
7438         emit DeployDao(address(dao));
7439         acl = ACL(dao.acl());
7440         _createPermissionForTemplate(acl, dao, dao.APP_MANAGER_ROLE());
7441     }
7442 
7443     /* ACL */
7444 
7445     function _createPermissions(ACL _acl, address[] memory _grantees, address _app, bytes32 _permission, address _manager) internal {
7446         _acl.createPermission(_grantees[0], _app, _permission, address(this));
7447         for (uint256 i = 1; i < _grantees.length; i++) {
7448             _acl.grantPermission(_grantees[i], _app, _permission);
7449         }
7450         _acl.revokePermission(address(this), _app, _permission);
7451         _acl.setPermissionManager(_manager, _app, _permission);
7452     }
7453 
7454     function _createPermissionForTemplate(ACL _acl, address _app, bytes32 _permission) internal {
7455         _acl.createPermission(address(this), _app, _permission, address(this));
7456     }
7457 
7458     function _removePermissionFromTemplate(ACL _acl, address _app, bytes32 _permission) internal {
7459         _acl.revokePermission(address(this), _app, _permission);
7460         _acl.removePermissionManager(_app, _permission);
7461     }
7462 
7463     function _transferRootPermissionsFromTemplateAndFinalizeDAO(Kernel _dao, address _to) internal {
7464         _transferRootPermissionsFromTemplateAndFinalizeDAO(_dao, _to, _to);
7465     }
7466 
7467     function _transferRootPermissionsFromTemplateAndFinalizeDAO(Kernel _dao, address _to, address _manager) internal {
7468         ACL _acl = ACL(_dao.acl());
7469         _transferPermissionFromTemplate(_acl, _dao, _to, _dao.APP_MANAGER_ROLE(), _manager);
7470         _transferPermissionFromTemplate(_acl, _acl, _to, _acl.CREATE_PERMISSIONS_ROLE(), _manager);
7471         emit SetupDao(_dao);
7472     }
7473 
7474     function _transferPermissionFromTemplate(ACL _acl, address _app, address _to, bytes32 _permission, address _manager) internal {
7475         _acl.grantPermission(_to, _app, _permission);
7476         _acl.revokePermission(address(this), _app, _permission);
7477         _acl.setPermissionManager(_manager, _app, _permission);
7478     }
7479 
7480     /* AGENT */
7481 
7482     function _installDefaultAgentApp(Kernel _dao) internal returns (Agent) {
7483         bytes memory initializeData = abi.encodeWithSelector(Agent(0).initialize.selector);
7484         Agent agent = Agent(_installDefaultApp(_dao, AGENT_APP_ID, initializeData));
7485         // We assume that installing the Agent app as a default app means the DAO should have its
7486         // Vault replaced by the Agent. Thus, we also set the DAO's recovery app to the Agent.
7487         _dao.setRecoveryVaultAppId(AGENT_APP_ID);
7488         return agent;
7489     }
7490 
7491     function _installNonDefaultAgentApp(Kernel _dao) internal returns (Agent) {
7492         bytes memory initializeData = abi.encodeWithSelector(Agent(0).initialize.selector);
7493         return Agent(_installNonDefaultApp(_dao, AGENT_APP_ID, initializeData));
7494     }
7495 
7496     function _createAgentPermissions(ACL _acl, Agent _agent, address _grantee, address _manager) internal {
7497         _acl.createPermission(_grantee, _agent, _agent.EXECUTE_ROLE(), _manager);
7498         _acl.createPermission(_grantee, _agent, _agent.RUN_SCRIPT_ROLE(), _manager);
7499     }
7500 
7501     /* VAULT */
7502 
7503     function _installVaultApp(Kernel _dao) internal returns (Vault) {
7504         bytes memory initializeData = abi.encodeWithSelector(Vault(0).initialize.selector);
7505         return Vault(_installDefaultApp(_dao, VAULT_APP_ID, initializeData));
7506     }
7507 
7508     function _createVaultPermissions(ACL _acl, Vault _vault, address _grantee, address _manager) internal {
7509         _acl.createPermission(_grantee, _vault, _vault.TRANSFER_ROLE(), _manager);
7510     }
7511 
7512     /* VOTING */
7513 
7514     function _installVotingApp(Kernel _dao, MiniMeToken _token, uint64[3] memory _votingSettings) internal returns (Voting) {
7515         return _installVotingApp(_dao, _token, _votingSettings[0], _votingSettings[1], _votingSettings[2]);
7516     }
7517 
7518     function _installVotingApp(
7519         Kernel _dao,
7520         MiniMeToken _token,
7521         uint64 _support,
7522         uint64 _acceptance,
7523         uint64 _duration
7524     )
7525         internal returns (Voting)
7526     {
7527         bytes memory initializeData = abi.encodeWithSelector(Voting(0).initialize.selector, _token, _support, _acceptance, _duration);
7528         return Voting(_installNonDefaultApp(_dao, VOTING_APP_ID, initializeData));
7529     }
7530 
7531     function _createVotingPermissions(
7532         ACL _acl,
7533         Voting _voting,
7534         address _settingsGrantee,
7535         address _createVotesGrantee,
7536         address _manager
7537     )
7538         internal
7539     {
7540         _acl.createPermission(_settingsGrantee, _voting, _voting.MODIFY_QUORUM_ROLE(), _manager);
7541         _acl.createPermission(_settingsGrantee, _voting, _voting.MODIFY_SUPPORT_ROLE(), _manager);
7542         _acl.createPermission(_createVotesGrantee, _voting, _voting.CREATE_VOTES_ROLE(), _manager);
7543     }
7544 
7545     /* SURVEY */
7546 
7547     function _installSurveyApp(Kernel _dao, MiniMeToken _token, uint64 _minParticipationPct, uint64 _surveyTime) internal returns (Survey) {
7548         bytes memory initializeData = abi.encodeWithSelector(Survey(0).initialize.selector, _token, _minParticipationPct, _surveyTime);
7549         return Survey(_installNonDefaultApp(_dao, SURVEY_APP_ID, initializeData));
7550     }
7551 
7552     function _createSurveyPermissions(ACL _acl, Survey _survey, address _grantee, address _manager) internal {
7553         _acl.createPermission(_grantee, _survey, _survey.CREATE_SURVEYS_ROLE(), _manager);
7554         _acl.createPermission(_grantee, _survey, _survey.MODIFY_PARTICIPATION_ROLE(), _manager);
7555     }
7556 
7557     /* PAYROLL */
7558 
7559     function _installPayrollApp(
7560         Kernel _dao,
7561         Finance _finance,
7562         address _denominationToken,
7563         IFeed _priceFeed,
7564         uint64 _rateExpiryTime
7565     )
7566         internal returns (Payroll)
7567     {
7568         bytes memory initializeData = abi.encodeWithSelector(
7569             Payroll(0).initialize.selector,
7570             _finance,
7571             _denominationToken,
7572             _priceFeed,
7573             _rateExpiryTime
7574         );
7575         return Payroll(_installNonDefaultApp(_dao, PAYROLL_APP_ID, initializeData));
7576     }
7577 
7578     /**
7579     * @dev Internal function to configure payroll permissions. Note that we allow defining different managers for
7580     *      payroll since it may be useful to have one control the payroll settings (rate expiration, price feed,
7581     *      and allowed tokens), and another one to control the employee functionality (bonuses, salaries,
7582     *      reimbursements, employees, etc).
7583     * @param _acl ACL instance being configured
7584     * @param _acl Payroll app being configured
7585     * @param _employeeManager Address that will receive permissions to handle employee payroll functionality
7586     * @param _settingsManager Address that will receive permissions to manage payroll settings
7587     * @param _permissionsManager Address that will be the ACL manager for the payroll permissions
7588     */
7589     function _createPayrollPermissions(
7590         ACL _acl,
7591         Payroll _payroll,
7592         address _employeeManager,
7593         address _settingsManager,
7594         address _permissionsManager
7595     )
7596         internal
7597     {
7598         _acl.createPermission(_employeeManager, _payroll, _payroll.ADD_BONUS_ROLE(), _permissionsManager);
7599         _acl.createPermission(_employeeManager, _payroll, _payroll.ADD_EMPLOYEE_ROLE(), _permissionsManager);
7600         _acl.createPermission(_employeeManager, _payroll, _payroll.ADD_REIMBURSEMENT_ROLE(), _permissionsManager);
7601         _acl.createPermission(_employeeManager, _payroll, _payroll.TERMINATE_EMPLOYEE_ROLE(), _permissionsManager);
7602         _acl.createPermission(_employeeManager, _payroll, _payroll.SET_EMPLOYEE_SALARY_ROLE(), _permissionsManager);
7603 
7604         _acl.createPermission(_settingsManager, _payroll, _payroll.MODIFY_PRICE_FEED_ROLE(), _permissionsManager);
7605         _acl.createPermission(_settingsManager, _payroll, _payroll.MODIFY_RATE_EXPIRY_ROLE(), _permissionsManager);
7606         _acl.createPermission(_settingsManager, _payroll, _payroll.MANAGE_ALLOWED_TOKENS_ROLE(), _permissionsManager);
7607     }
7608 
7609     function _unwrapPayrollSettings(
7610         uint256[4] memory _payrollSettings
7611     )
7612         internal pure returns (address denominationToken, IFeed priceFeed, uint64 rateExpiryTime, address employeeManager)
7613     {
7614         denominationToken = _toAddress(_payrollSettings[0]);
7615         priceFeed = IFeed(_toAddress(_payrollSettings[1]));
7616         rateExpiryTime = _payrollSettings[2].toUint64();
7617         employeeManager = _toAddress(_payrollSettings[3]);
7618     }
7619 
7620     /* FINANCE */
7621 
7622     function _installFinanceApp(Kernel _dao, Vault _vault, uint64 _periodDuration) internal returns (Finance) {
7623         bytes memory initializeData = abi.encodeWithSelector(Finance(0).initialize.selector, _vault, _periodDuration);
7624         return Finance(_installNonDefaultApp(_dao, FINANCE_APP_ID, initializeData));
7625     }
7626 
7627     function _createFinancePermissions(ACL _acl, Finance _finance, address _grantee, address _manager) internal {
7628         _acl.createPermission(_grantee, _finance, _finance.EXECUTE_PAYMENTS_ROLE(), _manager);
7629         _acl.createPermission(_grantee, _finance, _finance.MANAGE_PAYMENTS_ROLE(), _manager);
7630     }
7631 
7632     function _createFinanceCreatePaymentsPermission(ACL _acl, Finance _finance, address _grantee, address _manager) internal {
7633         _acl.createPermission(_grantee, _finance, _finance.CREATE_PAYMENTS_ROLE(), _manager);
7634     }
7635 
7636     function _grantCreatePaymentPermission(ACL _acl, Finance _finance, address _to) internal {
7637         _acl.grantPermission(_to, _finance, _finance.CREATE_PAYMENTS_ROLE());
7638     }
7639 
7640     function _transferCreatePaymentManagerFromTemplate(ACL _acl, Finance _finance, address _manager) internal {
7641         _acl.setPermissionManager(_manager, _finance, _finance.CREATE_PAYMENTS_ROLE());
7642     }
7643 
7644     /* TOKEN MANAGER */
7645 
7646     function _installTokenManagerApp(
7647         Kernel _dao,
7648         MiniMeToken _token,
7649         bool _transferable,
7650         uint256 _maxAccountTokens
7651     )
7652         internal returns (TokenManager)
7653     {
7654         TokenManager tokenManager = TokenManager(_installNonDefaultApp(_dao, TOKEN_MANAGER_APP_ID));
7655         _token.changeController(tokenManager);
7656         tokenManager.initialize(_token, _transferable, _maxAccountTokens);
7657         return tokenManager;
7658     }
7659 
7660     function _createTokenManagerPermissions(ACL _acl, TokenManager _tokenManager, address _grantee, address _manager) internal {
7661         _acl.createPermission(_grantee, _tokenManager, _tokenManager.MINT_ROLE(), _manager);
7662         _acl.createPermission(_grantee, _tokenManager, _tokenManager.BURN_ROLE(), _manager);
7663     }
7664 
7665     function _mintTokens(ACL _acl, TokenManager _tokenManager, address[] memory _holders, uint256[] memory _stakes) internal {
7666         _createPermissionForTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7667         for (uint256 i = 0; i < _holders.length; i++) {
7668             _tokenManager.mint(_holders[i], _stakes[i]);
7669         }
7670         _removePermissionFromTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7671     }
7672 
7673     function _mintTokens(ACL _acl, TokenManager _tokenManager, address[] memory _holders, uint256 _stake) internal {
7674         _createPermissionForTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7675         for (uint256 i = 0; i < _holders.length; i++) {
7676             _tokenManager.mint(_holders[i], _stake);
7677         }
7678         _removePermissionFromTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7679     }
7680 
7681     function _mintTokens(ACL _acl, TokenManager _tokenManager, address _holder, uint256 _stake) internal {
7682         _createPermissionForTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7683         _tokenManager.mint(_holder, _stake);
7684         _removePermissionFromTemplate(_acl, _tokenManager, _tokenManager.MINT_ROLE());
7685     }
7686 
7687     /* EVM SCRIPTS */
7688 
7689     function _createEvmScriptsRegistryPermissions(ACL _acl, address _grantee, address _manager) internal {
7690         EVMScriptRegistry registry = EVMScriptRegistry(_acl.getEVMScriptRegistry());
7691         _acl.createPermission(_grantee, registry, registry.REGISTRY_MANAGER_ROLE(), _manager);
7692         _acl.createPermission(_grantee, registry, registry.REGISTRY_ADD_EXECUTOR_ROLE(), _manager);
7693     }
7694 
7695     /* APPS */
7696 
7697     function _installNonDefaultApp(Kernel _dao, bytes32 _appId) internal returns (address) {
7698         return _installNonDefaultApp(_dao, _appId, new bytes(0));
7699     }
7700 
7701     function _installNonDefaultApp(Kernel _dao, bytes32 _appId, bytes memory _initializeData) internal returns (address) {
7702         return _installApp(_dao, _appId, _initializeData, false);
7703     }
7704 
7705     function _installDefaultApp(Kernel _dao, bytes32 _appId) internal returns (address) {
7706         return _installDefaultApp(_dao, _appId, new bytes(0));
7707     }
7708 
7709     function _installDefaultApp(Kernel _dao, bytes32 _appId, bytes memory _initializeData) internal returns (address) {
7710         return _installApp(_dao, _appId, _initializeData, true);
7711     }
7712 
7713     function _installApp(Kernel _dao, bytes32 _appId, bytes memory _initializeData, bool _setDefault) internal returns (address) {
7714         address latestBaseAppAddress = _latestVersionAppBase(_appId);
7715         address instance = address(_dao.newAppInstance(_appId, latestBaseAppAddress, _initializeData, _setDefault));
7716         emit InstalledApp(instance, _appId);
7717         return instance;
7718     }
7719 
7720     function _latestVersionAppBase(bytes32 _appId) internal view returns (address base) {
7721         Repo repo = Repo(PublicResolver(ens.resolver(_appId)).addr(_appId));
7722         (,base,) = repo.getLatest();
7723     }
7724 
7725     /* TOKEN */
7726 
7727     function _createToken(string memory _name, string memory _symbol, uint8 _decimals) internal returns (MiniMeToken) {
7728         require(address(miniMeFactory) != address(0), ERROR_MINIME_FACTORY_NOT_PROVIDED);
7729         MiniMeToken token = miniMeFactory.createCloneToken(MiniMeToken(address(0)), 0, _name, _decimals, _symbol, true);
7730         emit DeployToken(address(token));
7731         return token;
7732     }
7733 
7734     function _ensureMiniMeFactoryIsValid(address _miniMeFactory) internal view {
7735         require(isContract(address(_miniMeFactory)), ERROR_MINIME_FACTORY_NOT_CONTRACT);
7736     }
7737 
7738     /* IDS */
7739 
7740     function _validateId(string memory _id) internal pure {
7741         require(bytes(_id).length > 0, ERROR_INVALID_ID);
7742     }
7743 
7744     function _registerID(string memory _name, address _owner) internal {
7745         require(address(aragonID) != address(0), ERROR_ARAGON_ID_NOT_PROVIDED);
7746         aragonID.register(keccak256(abi.encodePacked(_name)), _owner);
7747     }
7748 
7749     function _ensureAragonIdIsValid(address _aragonID) internal view {
7750         require(isContract(address(_aragonID)), ERROR_ARAGON_ID_NOT_CONTRACT);
7751     }
7752 
7753     /* HELPERS */
7754 
7755     function _toAddress(uint256 _value) private pure returns (address) {
7756         require(_value <= uint160(-1), ERROR_CANNOT_CAST_VALUE_TO_ADDRESS);
7757         return address(_value);
7758     }
7759 }
7760 
7761 // File: contracts/CompanyTemplate.sol
7762 
7763 pragma solidity 0.4.24;
7764 
7765 
7766 
7767 
7768 contract CompanyTemplate is BaseTemplate, TokenCache {
7769     string constant private ERROR_EMPTY_HOLDERS = "COMPANY_EMPTY_HOLDERS";
7770     string constant private ERROR_BAD_HOLDERS_STAKES_LEN = "COMPANY_BAD_HOLDERS_STAKES_LEN";
7771     string constant private ERROR_BAD_VOTE_SETTINGS = "COMPANY_BAD_VOTE_SETTINGS";
7772     string constant private ERROR_BAD_PAYROLL_SETTINGS = "COMPANY_BAD_PAYROLL_SETTINGS";
7773 
7774     bool constant private TOKEN_TRANSFERABLE = true;
7775     uint8 constant private TOKEN_DECIMALS = uint8(18);
7776     uint256 constant private TOKEN_MAX_PER_ACCOUNT = uint256(0);
7777     uint64 constant private DEFAULT_FINANCE_PERIOD = uint64(30 days);
7778 
7779     constructor(DAOFactory _daoFactory, ENS _ens, MiniMeTokenFactory _miniMeFactory, IFIFSResolvingRegistrar _aragonID)
7780         BaseTemplate(_daoFactory, _ens, _miniMeFactory, _aragonID)
7781         public
7782     {
7783         _ensureAragonIdIsValid(_aragonID);
7784         _ensureMiniMeFactoryIsValid(_miniMeFactory);
7785     }
7786 
7787     /**
7788     * @dev Create a new MiniMe token and deploy a Company DAO. This function does not allow Payroll
7789     *      to be setup due to gas limits.
7790     * @param _tokenName String with the name for the token used by share holders in the organization
7791     * @param _tokenSymbol String with the symbol for the token used by share holders in the organization
7792     * @param _id String with the name for org, will assign `[id].aragonid.eth`
7793     * @param _holders Array of token holder addresses
7794     * @param _stakes Array of token stakes for holders (token has 18 decimals, multiply token amount `* 10^18`)
7795     * @param _votingSettings Array of [supportRequired, minAcceptanceQuorum, voteDuration] to set up the voting app of the organization
7796     * @param _financePeriod Initial duration for accounting periods, it can be set to zero in order to use the default of 30 days.
7797     * @param _useAgentAsVault Boolean to tell whether to use an Agent app as a more advanced form of Vault app
7798     */
7799     function newTokenAndInstance(
7800         string _tokenName,
7801         string _tokenSymbol,
7802         string _id,
7803         address[] _holders,
7804         uint256[] _stakes,
7805         uint64[3] _votingSettings,
7806         uint64 _financePeriod,
7807         bool _useAgentAsVault
7808     )
7809         external
7810     {
7811         newToken(_tokenName, _tokenSymbol);
7812         newInstance(_id, _holders, _stakes, _votingSettings, _financePeriod, _useAgentAsVault);
7813     }
7814 
7815     /**
7816     * @dev Create a new MiniMe token and cache it for the user
7817     * @param _name String with the name for the token used by share holders in the organization
7818     * @param _symbol String with the symbol for the token used by share holders in the organization
7819     */
7820     function newToken(string memory _name, string memory _symbol) public returns (MiniMeToken) {
7821         MiniMeToken token = _createToken(_name, _symbol, TOKEN_DECIMALS);
7822         _cacheToken(token, msg.sender);
7823         return token;
7824     }
7825 
7826     /**
7827     * @dev Deploy a Company DAO using a previously cached MiniMe token
7828     * @param _id String with the name for org, will assign `[id].aragonid.eth`
7829     * @param _holders Array of token holder addresses
7830     * @param _stakes Array of token stakes for holders (token has 18 decimals, multiply token amount `* 10^18`)
7831     * @param _votingSettings Array of [supportRequired, minAcceptanceQuorum, voteDuration] to set up the voting app of the organization
7832     * @param _financePeriod Initial duration for accounting periods, it can be set to zero in order to use the default of 30 days.
7833     * @param _useAgentAsVault Boolean to tell whether to use an Agent app as a more advanced form of Vault app
7834     */
7835     function newInstance(
7836         string memory _id,
7837         address[] memory _holders,
7838         uint256[] memory _stakes,
7839         uint64[3] memory _votingSettings,
7840         uint64 _financePeriod,
7841         bool _useAgentAsVault
7842     )
7843         public
7844     {
7845         _validateId(_id);
7846         _ensureCompanySettings(_holders, _stakes, _votingSettings);
7847 
7848         (Kernel dao, ACL acl) = _createDAO();
7849         (Finance finance, Voting voting) = _setupApps(dao, acl, _holders, _stakes, _votingSettings, _financePeriod, _useAgentAsVault);
7850         _transferCreatePaymentManagerFromTemplate(acl, finance, voting);
7851         _transferRootPermissionsFromTemplateAndFinalizeDAO(dao, voting);
7852         _registerID(_id, dao);
7853     }
7854 
7855     /**
7856     * @dev Deploy a Company DAO using a previously cached MiniMe token
7857     * @param _id String with the name for org, will assign `[id].aragonid.eth`
7858     * @param _holders Array of token holder addresses
7859     * @param _stakes Array of token stakes for holders (token has 18 decimals, multiply token amount `* 10^18`)
7860     * @param _votingSettings Array of [supportRequired, minAcceptanceQuorum, voteDuration] to set up the voting app of the organization
7861     * @param _financePeriod Initial duration for accounting periods, it can be set to zero in order to use the default of 30 days.
7862     * @param _useAgentAsVault Boolean to tell whether to use an Agent app as a more advanced form of Vault app
7863     * @param _payrollSettings Array of [address denominationToken , IFeed priceFeed, uint64 rateExpiryTime, address employeeManager]
7864              for the payroll app. The `employeeManager` can be set to `0x0` in order to use the voting app as the employee manager.
7865     */
7866     function newInstance(
7867         string memory _id,
7868         address[] memory _holders,
7869         uint256[] memory _stakes,
7870         uint64[3] memory _votingSettings,
7871         uint64 _financePeriod,
7872         bool _useAgentAsVault,
7873         uint256[4] memory _payrollSettings
7874     )
7875         public
7876     {
7877         _validateId(_id);
7878         _ensureCompanySettings(_holders, _stakes, _votingSettings, _payrollSettings);
7879 
7880         (Kernel dao, ACL acl) = _createDAO();
7881         (Finance finance, Voting voting) = _setupApps(dao, acl, _holders, _stakes, _votingSettings, _financePeriod, _useAgentAsVault);
7882         _setupPayrollApp(dao, acl, finance, voting, _payrollSettings);
7883         _transferCreatePaymentManagerFromTemplate(acl, finance, voting);
7884         _transferRootPermissionsFromTemplateAndFinalizeDAO(dao, voting);
7885         _registerID(_id, dao);
7886     }
7887 
7888     function _setupApps(
7889         Kernel _dao,
7890         ACL _acl,
7891         address[] memory _holders,
7892         uint256[] memory _stakes,
7893         uint64[3] memory _votingSettings,
7894         uint64 _financePeriod,
7895         bool _useAgentAsVault
7896     )
7897         internal
7898         returns (Finance, Voting)
7899     {
7900         MiniMeToken token = _popTokenCache(msg.sender);
7901         Vault agentOrVault = _useAgentAsVault ? _installDefaultAgentApp(_dao) : _installVaultApp(_dao);
7902         Finance finance = _installFinanceApp(_dao, agentOrVault, _financePeriod == 0 ? DEFAULT_FINANCE_PERIOD : _financePeriod);
7903         TokenManager tokenManager = _installTokenManagerApp(_dao, token, TOKEN_TRANSFERABLE, TOKEN_MAX_PER_ACCOUNT);
7904         Voting voting = _installVotingApp(_dao, token, _votingSettings);
7905 
7906         _mintTokens(_acl, tokenManager, _holders, _stakes);
7907         _setupPermissions(_acl, agentOrVault, voting, finance, tokenManager, _useAgentAsVault);
7908 
7909         return (finance, voting);
7910     }
7911 
7912     function _setupPayrollApp(Kernel _dao, ACL _acl, Finance _finance, Voting _voting, uint256[4] memory _payrollSettings) internal {
7913         (address denominationToken, IFeed priceFeed, uint64 rateExpiryTime, address employeeManager) = _unwrapPayrollSettings(_payrollSettings);
7914         address manager = employeeManager == address(0) ? _voting : employeeManager;
7915 
7916         Payroll payroll = _installPayrollApp(_dao, _finance, denominationToken, priceFeed, rateExpiryTime);
7917         _createPayrollPermissions(_acl, payroll, manager, _voting, _voting);
7918         _grantCreatePaymentPermission(_acl, _finance, payroll);
7919     }
7920 
7921     function _setupPermissions(
7922         ACL _acl,
7923         Vault _agentOrVault,
7924         Voting _voting,
7925         Finance _finance,
7926         TokenManager _tokenManager,
7927         bool _useAgentAsVault
7928     )
7929         internal
7930     {
7931         if (_useAgentAsVault) {
7932             _createAgentPermissions(_acl, Agent(_agentOrVault), _voting, _voting);
7933         }
7934         _createVaultPermissions(_acl, _agentOrVault, _finance, _voting);
7935         _createFinancePermissions(_acl, _finance, _voting, _voting);
7936         _createFinanceCreatePaymentsPermission(_acl, _finance, _voting, address(this));
7937         _createEvmScriptsRegistryPermissions(_acl, _voting, _voting);
7938         _createVotingPermissions(_acl, _voting, _voting, _tokenManager, _voting);
7939         _createTokenManagerPermissions(_acl, _tokenManager, _voting, _voting);
7940     }
7941 
7942     function _ensureCompanySettings(
7943         address[] memory _holders,
7944         uint256[] memory _stakes,
7945         uint64[3] memory _votingSettings,
7946         uint256[4] memory _payrollSettings
7947     )
7948         private
7949         pure
7950     {
7951         _ensureCompanySettings(_holders, _stakes, _votingSettings);
7952         require(_payrollSettings.length == 4, ERROR_BAD_PAYROLL_SETTINGS);
7953     }
7954 
7955     function _ensureCompanySettings(address[] memory _holders, uint256[] memory _stakes, uint64[3] memory _votingSettings) private pure {
7956         require(_holders.length > 0, ERROR_EMPTY_HOLDERS);
7957         require(_holders.length == _stakes.length, ERROR_BAD_HOLDERS_STAKES_LEN);
7958         require(_votingSettings.length == 3, ERROR_BAD_VOTE_SETTINGS);
7959     }
7960 }