1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 
66 /**
67  * @title SafeMath
68  * @dev Math operations with safety checks that throw on error
69  */
70 library SafeMath {
71 
72   /**
73   * @dev Multiplies two numbers, throws on overflow.
74   */
75   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
76     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
77     // benefit is lost if 'b' is also tested.
78     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
79     if (_a == 0) {
80       return 0;
81     }
82 
83     c = _a * _b;
84     assert(c / _a == _b);
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers, truncating the quotient.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     // assert(_b > 0); // Solidity automatically throws when dividing by 0
93     // uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95     return _a / _b;
96   }
97 
98   /**
99   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
100   */
101   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
102     assert(_b <= _a);
103     return _a - _b;
104   }
105 
106   /**
107   * @dev Adds two numbers, throws on overflow.
108   */
109   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
110     c = _a + _b;
111     assert(c >= _a);
112     return c;
113   }
114 }
115 
116 /**
117  * @title Helps contracts guard against reentrancy attacks.
118  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
119  * @dev If you mark a function `nonReentrant`, you should also
120  * mark it `external`.
121  */
122 contract ReentrancyGuard {
123 
124   /// @dev Constant for unlocked guard state - non-zero to prevent extra gas costs.
125   /// See: https://github.com/OpenZeppelin/openzeppelin-solidity/issues/1056
126   uint private constant REENTRANCY_GUARD_FREE = 1;
127 
128   /// @dev Constant for locked guard state
129   uint private constant REENTRANCY_GUARD_LOCKED = 2;
130 
131   /**
132    * @dev We use a single lock for the whole contract.
133    */
134   uint private reentrancyLock = REENTRANCY_GUARD_FREE;
135 
136   /**
137    * @dev Prevents a contract from calling itself, directly or indirectly.
138    * If you mark a function `nonReentrant`, you should also
139    * mark it `external`. Calling one `nonReentrant` function from
140    * another is not supported. Instead, you can implement a
141    * `private` function doing the actual work, and an `external`
142    * wrapper marked as `nonReentrant`.
143    */
144   modifier nonReentrant() {
145     require(reentrancyLock == REENTRANCY_GUARD_FREE);
146     reentrancyLock = REENTRANCY_GUARD_LOCKED;
147     _;
148     reentrancyLock = REENTRANCY_GUARD_FREE;
149   }
150 
151 }
152 
153 
154 /**
155  * @title ERC20Basic
156  * @dev Simpler version of ERC20 interface
157  * See https://github.com/ethereum/EIPs/issues/179
158  */
159 contract ERC20Basic {
160   function totalSupply() public view returns (uint256);
161   function balanceOf(address _who) public view returns (uint256);
162   function transfer(address _to, uint256 _value) public returns (bool);
163   event Transfer(address indexed from, address indexed to, uint256 value);
164 }
165 
166 
167 /**
168  * @title ERC20 interface
169  * @dev see https://github.com/ethereum/EIPs/issues/20
170  */
171 contract ERC20 is ERC20Basic {
172   function allowance(address _owner, address _spender)
173     public view returns (uint256);
174 
175   function transferFrom(address _from, address _to, uint256 _value)
176     public returns (bool);
177 
178   function approve(address _spender, uint256 _value) public returns (bool);
179   event Approval(
180     address indexed owner,
181     address indexed spender,
182     uint256 value
183   );
184 }
185 
186 
187 /**
188  * @title DetailedERC20 token
189  * @dev The decimals are only for visualization purposes.
190  * All the operations are done using the smallest and indivisible token unit,
191  * just as on Ethereum all the operations are done in wei.
192  */
193 contract DetailedERC20 is ERC20 {
194   string public name;
195   string public symbol;
196   uint8 public decimals;
197 
198   constructor(string _name, string _symbol, uint8 _decimals) public {
199     name = _name;
200     symbol = _symbol;
201     decimals = _decimals;
202   }
203 }
204 
205 
206 /// @dev The token controller contract must implement these functions
207 contract TokenController {
208     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
209     /// @param _owner The address that sent the ether to create tokens
210     /// @return True if the ether is accepted, false if it throws
211     function proxyPayment(address _owner) public payable returns(bool);
212 
213     /// @notice Notifies the controller about a token transfer allowing the
214     ///  controller to react if desired
215     /// @param _from The origin of the transfer
216     /// @param _to The destination of the transfer
217     /// @param _amount The amount of the transfer
218     /// @return False if the controller does not authorize the transfer
219     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
220 
221     /// @notice Notifies the controller about an approval allowing the
222     ///  controller to react if desired
223     /// @param _owner The address that calls `approve()`
224     /// @param _spender The spender in the `approve()` call
225     /// @param _amount The amount in the `approve()` call
226     /// @return False if the controller does not authorize the approval
227     function onApprove(address _owner, address _spender, uint _amount) public
228         returns(bool);
229 }
230 
231 /*
232     Copyright 2016, Jordi Baylina
233 
234     This program is free software: you can redistribute it and/or modify
235     it under the terms of the GNU General Public License as published by
236     the Free Software Foundation, either version 3 of the License, or
237     (at your option) any later version.
238 
239     This program is distributed in the hope that it will be useful,
240     but WITHOUT ANY WARRANTY; without even the implied warranty of
241     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
242     GNU General Public License for more details.
243 
244     You should have received a copy of the GNU General Public License
245     along with this program.  If not, see <http://www.gnu.org/licenses/>.
246  */
247 
248 /// @title MiniMeToken Contract
249 /// @author Jordi Baylina
250 /// @dev This token contract's goal is to make it easy for anyone to clone this
251 ///  token using the token distribution at a given block, this will allow DAO's
252 ///  and DApps to upgrade their features in a decentralized manner without
253 ///  affecting the original token
254 /// @dev It is ERC20 compliant, but still needs to under go further testing.
255 
256 contract ApproveAndCallFallBack {
257     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
258 }
259 
260 /// @dev The actual token contract, the default owner is the msg.sender
261 ///  that deploys the contract, so usually this token will be deployed by a
262 ///  token owner contract, which Giveth will call a "Campaign"
263 contract MiniMeToken is Ownable {
264 
265     string public name;                //The Token's name: e.g. DigixDAO Tokens
266     uint8 public decimals;             //Number of decimals of the smallest unit
267     string public symbol;              //An identifier: e.g. REP
268     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
269 
270 
271     /// @dev `Checkpoint` is the structure that attaches a block number to a
272     ///  given value, the block number attached is the one that last changed the
273     ///  value
274     struct  Checkpoint {
275 
276         // `fromBlock` is the block number that the value was generated from
277         uint128 fromBlock;
278 
279         // `value` is the amount of tokens at a specific block number
280         uint128 value;
281     }
282 
283     // `parentToken` is the Token address that was cloned to produce this token;
284     //  it will be 0x0 for a token that was not cloned
285     MiniMeToken public parentToken;
286 
287     // `parentSnapShotBlock` is the block number from the Parent Token that was
288     //  used to determine the initial distribution of the Clone Token
289     uint public parentSnapShotBlock;
290 
291     // `creationBlock` is the block number that the Clone Token was created
292     uint public creationBlock;
293 
294     // `balances` is the map that tracks the balance of each address, in this
295     //  contract when the balance changes the block number that the change
296     //  occurred is also included in the map
297     mapping (address => Checkpoint[]) balances;
298 
299     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
300     mapping (address => mapping (address => uint256)) allowed;
301 
302     // Tracks the history of the `totalSupply` of the token
303     Checkpoint[] totalSupplyHistory;
304 
305     // Flag that determines if the token is transferable or not.
306     bool public transfersEnabled;
307 
308     // The factory used to create new clone tokens
309     MiniMeTokenFactory public tokenFactory;
310 
311 ////////////////
312 // Constructor
313 ////////////////
314 
315     /// @notice Constructor to create a MiniMeToken
316     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
317     ///  will create the Clone token contracts, the token factory needs to be
318     ///  deployed first
319     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
320     ///  new token
321     /// @param _parentSnapShotBlock Block of the parent token that will
322     ///  determine the initial distribution of the clone token, set to 0 if it
323     ///  is a new token
324     /// @param _tokenName Name of the new token
325     /// @param _decimalUnits Number of decimals of the new token
326     /// @param _tokenSymbol Token Symbol for the new token
327     /// @param _transfersEnabled If true, tokens will be able to be transferred
328     constructor(
329         address _tokenFactory,
330         address _parentToken,
331         uint _parentSnapShotBlock,
332         string _tokenName,
333         uint8 _decimalUnits,
334         string _tokenSymbol,
335         bool _transfersEnabled
336     ) public {
337         tokenFactory = MiniMeTokenFactory(_tokenFactory);
338         name = _tokenName;                                 // Set the name
339         decimals = _decimalUnits;                          // Set the decimals
340         symbol = _tokenSymbol;                             // Set the symbol
341         parentToken = MiniMeToken(_parentToken);
342         parentSnapShotBlock = _parentSnapShotBlock;
343         transfersEnabled = _transfersEnabled;
344         creationBlock = block.number;
345     }
346 
347 
348 ///////////////////
349 // ERC20 Methods
350 ///////////////////
351 
352     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
353     /// @param _to The address of the recipient
354     /// @param _amount The amount of tokens to be transferred
355     /// @return Whether the transfer was successful or not
356     function transfer(address _to, uint256 _amount) public returns (bool success) {
357         require(transfersEnabled);
358         doTransfer(msg.sender, _to, _amount);
359         return true;
360     }
361 
362     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
363     ///  is approved by `_from`
364     /// @param _from The address holding the tokens being transferred
365     /// @param _to The address of the recipient
366     /// @param _amount The amount of tokens to be transferred
367     /// @return True if the transfer was successful
368     function transferFrom(address _from, address _to, uint256 _amount
369     ) public returns (bool success) {
370 
371         // The owner of this contract can move tokens around at will,
372         //  this is important to recognize! Confirm that you trust the
373         //  owner of this contract, which in most situations should be
374         //  another open source smart contract or 0x0
375         if (msg.sender != owner) {
376             require(transfersEnabled);
377 
378             // The standard ERC 20 transferFrom functionality
379             require(allowed[_from][msg.sender] >= _amount);
380             allowed[_from][msg.sender] -= _amount;
381         }
382         doTransfer(_from, _to, _amount);
383         return true;
384     }
385 
386     /// @dev This is the actual transfer function in the token contract, it can
387     ///  only be called by other functions in this contract.
388     /// @param _from The address holding the tokens being transferred
389     /// @param _to The address of the recipient
390     /// @param _amount The amount of tokens to be transferred
391     /// @return True if the transfer was successful
392     function doTransfer(address _from, address _to, uint _amount
393     ) internal {
394 
395            if (_amount == 0) {
396                emit Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
397                return;
398            }
399 
400            require(parentSnapShotBlock < block.number);
401 
402            // Do not allow transfer to 0x0 or the token contract itself
403            require((_to != 0) && (_to != address(this)));
404 
405            // If the amount being transfered is more than the balance of the
406            //  account the transfer throws
407            uint previousBalanceFrom = balanceOfAt(_from, block.number);
408 
409            require(previousBalanceFrom >= _amount);
410 
411            // Alerts the token owner of the transfer
412            if (isContract(owner)) {
413                require(TokenController(owner).onTransfer(_from, _to, _amount));
414            }
415 
416            // First update the balance array with the new value for the address
417            //  sending the tokens
418            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
419 
420            // Then update the balance array with the new value for the address
421            //  receiving the tokens
422            uint previousBalanceTo = balanceOfAt(_to, block.number);
423            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
424            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
425 
426            // An event to make the transfer easy to find on the blockchain
427            emit Transfer(_from, _to, _amount);
428 
429     }
430 
431     /// @param _owner The address that's balance is being requested
432     /// @return The balance of `_owner` at the current block
433     function balanceOf(address _owner) public constant returns (uint256 balance) {
434         return balanceOfAt(_owner, block.number);
435     }
436 
437     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
438     ///  its behalf. This is a modified version of the ERC20 approve function
439     ///  to be a little bit safer
440     /// @param _spender The address of the account able to transfer the tokens
441     /// @param _amount The amount of tokens to be approved for transfer
442     /// @return True if the approval was successful
443     function approve(address _spender, uint256 _amount) public returns (bool success) {
444         require(transfersEnabled);
445 
446         // To change the approve amount you first have to reduce the addresses`
447         //  allowance to zero by calling `approve(_spender,0)` if it is not
448         //  already 0 to mitigate the race condition described here:
449         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
450         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
451 
452         // Alerts the token owner of the approve function call
453         if (isContract(owner)) {
454             require(TokenController(owner).onApprove(msg.sender, _spender, _amount));
455         }
456 
457         allowed[msg.sender][_spender] = _amount;
458         emit Approval(msg.sender, _spender, _amount);
459         return true;
460     }
461 
462     /// @dev This function makes it easy to read the `allowed[]` map
463     /// @param _owner The address of the account that owns the token
464     /// @param _spender The address of the account able to transfer the tokens
465     /// @return Amount of remaining tokens of _owner that _spender is allowed
466     ///  to spend
467     function allowance(address _owner, address _spender
468     ) public constant returns (uint256 remaining) {
469         return allowed[_owner][_spender];
470     }
471 
472     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
473     ///  its behalf, and then a function is triggered in the contract that is
474     ///  being approved, `_spender`. This allows users to use their tokens to
475     ///  interact with contracts in one function call instead of two
476     /// @param _spender The address of the contract able to transfer the tokens
477     /// @param _amount The amount of tokens to be approved for transfer
478     /// @return True if the function call was successful
479     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
480     ) public returns (bool success) {
481         require(approve(_spender, _amount));
482 
483         ApproveAndCallFallBack(_spender).receiveApproval(
484             msg.sender,
485             _amount,
486             this,
487             _extraData
488         );
489 
490         return true;
491     }
492 
493     /// @dev This function makes it easy to get the total number of tokens
494     /// @return The total number of tokens
495     function totalSupply() public constant returns (uint) {
496         return totalSupplyAt(block.number);
497     }
498 
499 
500 ////////////////
501 // Query balance and totalSupply in History
502 ////////////////
503 
504     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
505     /// @param _owner The address from which the balance will be retrieved
506     /// @param _blockNumber The block number when the balance is queried
507     /// @return The balance at `_blockNumber`
508     function balanceOfAt(address _owner, uint _blockNumber) public constant
509         returns (uint) {
510 
511         // These next few lines are used when the balance of the token is
512         //  requested before a check point was ever created for this token, it
513         //  requires that the `parentToken.balanceOfAt` be queried at the
514         //  genesis block for that token as this contains initial balance of
515         //  this token
516         if ((balances[_owner].length == 0)
517             || (balances[_owner][0].fromBlock > _blockNumber)) {
518             if (address(parentToken) != 0) {
519                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
520             } else {
521                 // Has no parent
522                 return 0;
523             }
524 
525         // This will return the expected balance during normal situations
526         } else {
527             return getValueAt(balances[_owner], _blockNumber);
528         }
529     }
530 
531     /// @notice Total amount of tokens at a specific `_blockNumber`.
532     /// @param _blockNumber The block number when the totalSupply is queried
533     /// @return The total amount of tokens at `_blockNumber`
534     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
535 
536         // These next few lines are used when the totalSupply of the token is
537         //  requested before a check point was ever created for this token, it
538         //  requires that the `parentToken.totalSupplyAt` be queried at the
539         //  genesis block for this token as that contains totalSupply of this
540         //  token at this block number.
541         if ((totalSupplyHistory.length == 0)
542             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
543             if (address(parentToken) != 0) {
544                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
545             } else {
546                 return 0;
547             }
548 
549         // This will return the expected totalSupply during normal situations
550         } else {
551             return getValueAt(totalSupplyHistory, _blockNumber);
552         }
553     }
554 
555 ////////////////
556 // Clone Token Method
557 ////////////////
558 
559     /// @notice Creates a new clone token with the initial distribution being
560     ///  this token at `_snapshotBlock`
561     /// @param _cloneTokenName Name of the clone token
562     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
563     /// @param _cloneTokenSymbol Symbol of the clone token
564     /// @param _snapshotBlock Block when the distribution of the parent token is
565     ///  copied to set the initial distribution of the new clone token;
566     ///  if the block is zero than the actual block, the current block is used
567     /// @param _transfersEnabled True if transfers are allowed in the clone
568     /// @return The address of the new MiniMeToken Contract
569     function createCloneToken(
570         string _cloneTokenName,
571         uint8 _cloneDecimalUnits,
572         string _cloneTokenSymbol,
573         uint _snapshotBlock,
574         bool _transfersEnabled
575         ) public returns(address) {
576         if (_snapshotBlock == 0) _snapshotBlock = block.number;
577         MiniMeToken cloneToken = tokenFactory.createCloneToken(
578             this,
579             _snapshotBlock,
580             _cloneTokenName,
581             _cloneDecimalUnits,
582             _cloneTokenSymbol,
583             _transfersEnabled
584             );
585 
586         cloneToken.transferOwnership(msg.sender);
587 
588         // An event to make the token easy to find on the blockchain
589         emit NewCloneToken(address(cloneToken), _snapshotBlock);
590         return address(cloneToken);
591     }
592 
593 ////////////////
594 // Generate and destroy tokens
595 ////////////////
596 
597     /// @notice Generates `_amount` tokens that are assigned to `_owner`
598     /// @param _owner The address that will be assigned the new tokens
599     /// @param _amount The quantity of tokens generated
600     /// @return True if the tokens are generated correctly
601     function generateTokens(address _owner, uint _amount
602     ) public onlyOwner returns (bool) {
603         uint curTotalSupply = totalSupply();
604         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
605         uint previousBalanceTo = balanceOf(_owner);
606         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
607         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
608         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
609         emit Transfer(0, _owner, _amount);
610         return true;
611     }
612 
613 
614     /// @notice Burns `_amount` tokens from `_owner`
615     /// @param _owner The address that will lose the tokens
616     /// @param _amount The quantity of tokens to burn
617     /// @return True if the tokens are burned correctly
618     function destroyTokens(address _owner, uint _amount
619     ) onlyOwner public returns (bool) {
620         uint curTotalSupply = totalSupply();
621         require(curTotalSupply >= _amount);
622         uint previousBalanceFrom = balanceOf(_owner);
623         require(previousBalanceFrom >= _amount);
624         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
625         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
626         emit Transfer(_owner, 0, _amount);
627         return true;
628     }
629 
630 ////////////////
631 // Enable tokens transfers
632 ////////////////
633 
634 
635     /// @notice Enables token holders to transfer their tokens freely if true
636     /// @param _transfersEnabled True if transfers are allowed in the clone
637     function enableTransfers(bool _transfersEnabled) public onlyOwner {
638         transfersEnabled = _transfersEnabled;
639     }
640 
641 ////////////////
642 // Internal helper functions to query and set a value in a snapshot array
643 ////////////////
644 
645     /// @dev `getValueAt` retrieves the number of tokens at a given block number
646     /// @param checkpoints The history of values being queried
647     /// @param _block The block number to retrieve the value at
648     /// @return The number of tokens being queried
649     function getValueAt(Checkpoint[] storage checkpoints, uint _block
650     ) constant internal returns (uint) {
651         if (checkpoints.length == 0) return 0;
652 
653         // Shortcut for the actual value
654         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
655             return checkpoints[checkpoints.length-1].value;
656         if (_block < checkpoints[0].fromBlock) return 0;
657 
658         // Binary search of the value in the array
659         uint min = 0;
660         uint max = checkpoints.length-1;
661         while (max > min) {
662             uint mid = (max + min + 1)/ 2;
663             if (checkpoints[mid].fromBlock<=_block) {
664                 min = mid;
665             } else {
666                 max = mid-1;
667             }
668         }
669         return checkpoints[min].value;
670     }
671 
672     /// @dev `updateValueAtNow` used to update the `balances` map and the
673     ///  `totalSupplyHistory`
674     /// @param checkpoints The history of data being updated
675     /// @param _value The new number of tokens
676     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
677     ) internal  {
678         if ((checkpoints.length == 0)
679         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
680                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
681                newCheckPoint.fromBlock =  uint128(block.number);
682                newCheckPoint.value = uint128(_value);
683            } else {
684                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
685                oldCheckPoint.value = uint128(_value);
686            }
687     }
688 
689     /// @dev Internal function to determine if an address is a contract
690     /// @param _addr The address being queried
691     /// @return True if `_addr` is a contract
692     function isContract(address _addr) constant internal returns(bool) {
693         uint size;
694         if (_addr == 0) return false;
695         assembly {
696             size := extcodesize(_addr)
697         }
698         return size>0;
699     }
700 
701     /// @dev Helper function to return a min betwen the two uints
702     function min(uint a, uint b) pure internal returns (uint) {
703         return a < b ? a : b;
704     }
705 
706     /// @notice The fallback function: If the contract's owner has not been
707     ///  set to 0, then the `proxyPayment` method is called which relays the
708     ///  ether and creates tokens as described in the token owner contract
709     function () public payable {
710         require(isContract(owner));
711         require(TokenController(owner).proxyPayment.value(msg.value)(msg.sender));
712     }
713 
714 //////////
715 // Safety Methods
716 //////////
717 
718     /// @notice This method can be used by the owner to extract mistakenly
719     ///  sent tokens to this contract.
720     /// @param _token The address of the token contract that you want to recover
721     ///  set to 0 in case you want to extract ether.
722     function claimTokens(address _token) public onlyOwner {
723         if (_token == 0x0) {
724             owner.transfer(address(this).balance);
725             return;
726         }
727 
728         MiniMeToken token = MiniMeToken(_token);
729         uint balance = token.balanceOf(this);
730         token.transfer(owner, balance);
731         emit ClaimedTokens(_token, owner, balance);
732     }
733 
734 ////////////////
735 // Events
736 ////////////////
737     event ClaimedTokens(address indexed _token, address indexed _owner, uint _amount);
738     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
739     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
740     event Approval(
741         address indexed _owner,
742         address indexed _spender,
743         uint256 _amount
744         );
745 
746 }
747 
748 
749 ////////////////
750 // MiniMeTokenFactory
751 ////////////////
752 
753 /// @dev This contract is used to generate clone contracts from a contract.
754 ///  In solidity this is the way to create a contract from a contract of the
755 ///  same class
756 contract MiniMeTokenFactory {
757     event CreatedToken(string symbol, address addr);
758 
759     /// @notice Update the DApp by creating a new token with new functionalities
760     ///  the msg.sender becomes the owner of this clone token
761     /// @param _parentToken Address of the token being cloned
762     /// @param _snapshotBlock Block of the parent token that will
763     ///  determine the initial distribution of the clone token
764     /// @param _tokenName Name of the new token
765     /// @param _decimalUnits Number of decimals of the new token
766     /// @param _tokenSymbol Token Symbol for the new token
767     /// @param _transfersEnabled If true, tokens will be able to be transferred
768     /// @return The address of the new token contract
769     function createCloneToken(
770         address _parentToken,
771         uint _snapshotBlock,
772         string _tokenName,
773         uint8 _decimalUnits,
774         string _tokenSymbol,
775         bool _transfersEnabled
776     ) public returns (MiniMeToken) {
777         MiniMeToken newToken = new MiniMeToken(
778             this,
779             _parentToken,
780             _snapshotBlock,
781             _tokenName,
782             _decimalUnits,
783             _tokenSymbol,
784             _transfersEnabled
785             );
786 
787         newToken.transferOwnership(msg.sender);
788         emit CreatedToken(_tokenSymbol, address(newToken));
789         return newToken;
790     }
791 }
792 
793 /// @title Kyber Network interface
794 interface KyberNetworkProxyInterface {
795     function maxGasPrice() public view returns(uint);
796     function getUserCapInWei(address user) public view returns(uint);
797     function getUserCapInTokenWei(address user, DetailedERC20 token) public view returns(uint);
798     function enabled() public view returns(bool);
799     function info(bytes32 id) public view returns(uint);
800 
801     function getExpectedRate(DetailedERC20 src, DetailedERC20 dest, uint srcQty) public view
802         returns (uint expectedRate, uint slippageRate);
803 
804     function tradeWithHint(DetailedERC20 src, uint srcAmount, DetailedERC20 dest, address destAddress, uint maxDestAmount,
805         uint minConversionRate, address walletId, bytes hint) public payable returns(uint);
806 }
807 
808 
809 contract IAO is Ownable, ReentrancyGuard, TokenController {
810     using SafeMath for uint256;
811 
812     modifier onlyActive {
813         require(isActive, "IAO is not active");
814         _;
815     }
816 
817     DetailedERC20 constant internal ETH_TOKEN_ADDRESS = DetailedERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
818 
819     uint256 constant PRECISION = 10 ** 18; // we use 18 decimals
820     uint256 constant MAX_DONATION = 100 * (10 ** 18); // max donation is 100 DAI
821     uint256 constant KRO_RATE = 5 * (10 ** 17); // 1 DAI == 0.5 KRO
822     uint256 constant REFERRAL_BONUS = 10 * (10 ** 16); // 5% bonus for getting referred
823     address constant DAI_ADDR = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;
824     address constant KYBER_ADDR = 0x818E6FECD516Ecc3849DAf6845e3EC868087B755;
825 
826     address public kroAddr;
827     address public beneficiary;
828     bytes32 public secretHash;
829     bool public isActive;
830 
831     event Register(address indexed _manager, uint256 indexed _block, uint256 _donationInDAI);
832 
833 
834     // admin & internal functions
835 
836     constructor (address _kroAddr, address _beneficiary, bytes32 _secretHash) public {
837         kroAddr = _kroAddr;
838         beneficiary = _beneficiary;
839         secretHash = _secretHash;
840     }
841     
842 
843     function setActive(bool _isActive) onlyOwner public {
844         isActive = _isActive;
845     }
846 
847 
848     function transferKROContractOwnership(address _newOwner, string _secret) public onlyOwner {
849         require(!isActive, "IAO is not over"); // can only transfer ownership when IAO is over
850         require(keccak256(abi.encodePacked(_secret)) == secretHash, "Secret incorrect"); // need to provide the correct secret
851 
852         // transfer ownership
853         Ownable kro = Ownable(kroAddr);
854         kro.transferOwnership(_newOwner);
855     }
856 
857 
858     function _register(uint256 _donationInDAI, address _referrer) internal onlyActive {
859         require(_donationInDAI > 0 && _donationInDAI <= MAX_DONATION, "Donation out of range");
860         require(_referrer != msg.sender, "Can't refer self");
861 
862         MiniMeToken kro = MiniMeToken(kroAddr);
863         require(kro.balanceOf(msg.sender) == 0, "Already joined"); // each address can only join the IAO once
864 
865         // mint KRO for msg.sender
866         uint256 kroAmount = _donationInDAI.mul(KRO_RATE).div(PRECISION);
867         require(kro.generateTokens(msg.sender, kroAmount), "Failed minting");
868 
869         // mint KRO for referral program
870         if (_referrer != address(0) && kro.balanceOf(_referrer) > 0) {
871             uint256 bonusAmount = kroAmount.mul(REFERRAL_BONUS).div(PRECISION);
872             require(kro.generateTokens(msg.sender, bonusAmount), "Failed minting sender bonus");
873             require(kro.generateTokens(_referrer, bonusAmount), "Failed minting referrer bonus");
874         }
875 
876         // transfer DAI to beneficiary
877         DetailedERC20 dai = DetailedERC20(DAI_ADDR);
878         require(dai.transfer(beneficiary, _donationInDAI), "Failed DAI transfer to beneficiary");
879         
880         // emit events
881         emit Register(msg.sender, block.number, _donationInDAI);
882     }
883 
884 
885     // MiniMe TokenController functions, not used right now
886 
887     function proxyPayment(address _owner) public payable returns(bool) {
888         return false;
889     }
890 
891 
892     function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
893         return false;
894     }
895 
896 
897     function onApprove(address _owner, address _spender, uint _amount) public
898         returns(bool) {
899         return false;
900     }
901 
902 
903     // registration functions
904 
905     function registerWithDAI(uint256 _donationInDAI, address _referrer) public nonReentrant {
906         DetailedERC20 dai = DetailedERC20(DAI_ADDR);
907         require(dai.transferFrom(msg.sender, this, _donationInDAI), "Failed DAI transfer to IAO");
908         _register(_donationInDAI, _referrer);
909     }
910 
911 
912     function registerWithETH(address _referrer) public payable nonReentrant {
913         DetailedERC20 dai = DetailedERC20(DAI_ADDR);
914         KyberNetworkProxyInterface kyber = KyberNetworkProxyInterface(KYBER_ADDR);
915         uint256 daiRate;
916         bytes memory hint;
917 
918         // trade ETH for DAI
919         (,daiRate) = kyber.getExpectedRate(ETH_TOKEN_ADDRESS, dai, msg.value);
920         require(daiRate > 0, "Zero price");
921         uint256 receivedDAI = kyber.tradeWithHint.value(msg.value)(ETH_TOKEN_ADDRESS, msg.value, dai, this, MAX_DONATION * 2, daiRate, 0, hint);
922         
923         // if DAI value is greater than maximum allowed, return excess DAI to msg.sender
924         if (receivedDAI > MAX_DONATION) {
925             require(dai.transfer(msg.sender, receivedDAI.sub(MAX_DONATION)), "Excess DAI transfer failed");
926             receivedDAI = MAX_DONATION;
927         }
928 
929         // register new manager
930         _register(receivedDAI, _referrer);
931     }
932 
933     // _donationInTokens should use 18 decimals precision, regardless of the token's precision
934     function registerWithToken(address _token, uint256 _donationInTokens, address _referrer) public nonReentrant {
935         require(_token != address(0) && _token != address(ETH_TOKEN_ADDRESS) && _token != DAI_ADDR, "Invalid token");
936         DetailedERC20 token = DetailedERC20(_token);
937         require(token.totalSupply() > 0, "Zero token supply");
938 
939         DetailedERC20 dai = DetailedERC20(DAI_ADDR);
940         KyberNetworkProxyInterface kyber = KyberNetworkProxyInterface(KYBER_ADDR);
941         uint256 daiRate;
942         bytes memory hint;
943 
944         // transfer tokens to this contract
945         require(token.transferFrom(msg.sender, this, _donationInTokens), "Failed token transfer to IAO");
946 
947         // trade tokens for DAI
948         (,daiRate) = kyber.getExpectedRate(token, dai, _donationInTokens);
949         require(daiRate > 0, "Zero price");
950         require(token.approve(KYBER_ADDR, _donationInTokens.mul(PRECISION).div(10**uint256(token.decimals()))), "Token approval failed");
951         uint256 receivedDAI = kyber.tradeWithHint(token, _donationInTokens, dai, this, MAX_DONATION * 2, daiRate, 0, hint);
952 
953         // if DAI value is greater than maximum allowed, return excess DAI to msg.sender
954         if (receivedDAI > MAX_DONATION) {
955             require(dai.transfer(msg.sender, receivedDAI.sub(MAX_DONATION)), "Excess DAI transfer failed");
956             receivedDAI = MAX_DONATION;
957         }
958 
959         // register new manager
960         _register(receivedDAI, _referrer);
961     }
962 
963 
964     function () public payable nonReentrant {
965         registerWithETH(address(0));
966     }
967 }