1 pragma solidity ^0.4.17;
2 
3 /*
4     Copyright 2016, Jordi Baylina
5 
6     This program is free software: you can redistribute it and/or modify
7     it under the terms of the GNU General Public License as published by
8     the Free Software Foundation, either version 3 of the License, or
9     (at your option) any later version.
10 
11     This program is distributed in the hope that it will be useful,
12     but WITHOUT ANY WARRANTY; without even the implied warranty of
13     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14     GNU General Public License for more details.
15 
16     You should have received a copy of the GNU General Public License
17     along with this program.  If not, see <http://www.gnu.org/licenses/>.
18  */
19 
20 /// @title MiniMeToken Contract
21 /// @author Jordi Baylina
22 /// @dev This token contract's goal is to make it easy for anyone to clone this
23 ///  token using the token distribution at a given block, this will allow DAO's
24 ///  and DApps to upgrade their features in a decentralized manner without
25 ///  affecting the original token
26 /// @dev It is ERC20 compliant, but still needs to under go further testing.
27 
28 
29 /// @dev The token controller contract must implement these functions
30 contract TokenController {
31     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
32     /// @param _owner The address that sent the ether to create tokens
33     /// @return True if the ether is accepted, false if it throws
34     function proxyPayment(address _owner) payable returns(bool);
35 
36     /// @notice Notifies the controller about a token transfer allowing the
37     ///  controller to react if desired
38     /// @param _from The origin of the transfer
39     /// @param _to The destination of the transfer
40     /// @param _amount The amount of the transfer
41     /// @return False if the controller does not authorize the transfer
42     function onTransfer(address _from, address _to, uint _amount) returns(bool);
43 
44     /// @notice Notifies the controller about an approval allowing the
45     ///  controller to react if desired
46     /// @param _owner The address that calls `approve()`
47     /// @param _spender The spender in the `approve()` call
48     /// @param _amount The amount in the `approve()` call
49     /// @return False if the controller does not authorize the approval
50     function onApprove(address _owner, address _spender, uint _amount)
51         returns(bool);
52 }
53 
54 contract Controlled {
55     /// @notice The address of the controller is the only address that can call
56     ///  a function with this modifier
57     modifier onlyController { require(msg.sender == controller); _; }
58 
59     address public controller;
60 
61     function Controlled() { controller = msg.sender;}
62 
63     /// @notice Changes the controller of the contract
64     /// @param _newController The new controller of the contract
65     function changeController(address _newController) onlyController {
66         controller = _newController;
67     }
68 }
69 
70 contract ApproveAndCallFallBack {
71     function receiveApproval(address from, uint256 _amount, address _token, bytes _data);
72 }
73 
74 /// @dev The actual token contract, the default controller is the msg.sender
75 ///  that deploys the contract, so usually this token will be deployed by a
76 ///  token controller contract, which Giveth will call a "Campaign"
77 contract MiniMeToken is Controlled {
78 
79     string public name;                //The Token's name: e.g. DigixDAO Tokens
80     uint8 public decimals;             //Number of decimals of the smallest unit
81     string public symbol;              //An identifier: e.g. REP
82     string public version = 'MMT_0.1'; //An arbitrary versioning scheme
83 
84 
85     /// @dev `Checkpoint` is the structure that attaches a block number to a
86     ///  given value, the block number attached is the one that last changed the
87     ///  value
88     struct  Checkpoint {
89 
90         // `fromBlock` is the block number that the value was generated from
91         uint128 fromBlock;
92 
93         // `value` is the amount of tokens at a specific block number
94         uint128 value;
95     }
96 
97     // `parentToken` is the Token address that was cloned to produce this token;
98     //  it will be 0x0 for a token that was not cloned
99     MiniMeToken public parentToken;
100 
101     // `parentSnapShotBlock` is the block number from the Parent Token that was
102     //  used to determine the initial distribution of the Clone Token
103     uint public parentSnapShotBlock;
104 
105     // `creationBlock` is the block number that the Clone Token was created
106     uint public creationBlock;
107 
108     // `balances` is the map that tracks the balance of each address, in this
109     //  contract when the balance changes the block number that the change
110     //  occurred is also included in the map
111     mapping (address => Checkpoint[]) balances;
112 
113     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
114     mapping (address => mapping (address => uint256)) allowed;
115 
116     // Tracks the history of the `totalSupply` of the token
117     Checkpoint[] totalSupplyHistory;
118 
119     // Flag that determines if the token is transferable or not.
120     bool public transfersEnabled;
121 
122     // The factory used to create new clone tokens
123     MiniMeTokenFactory public tokenFactory;
124 
125 ////////////////
126 // Constructor
127 ////////////////
128 
129     /// @notice Constructor to create a MiniMeToken
130     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
131     ///  will create the Clone token contracts, the token factory needs to be
132     ///  deployed first
133     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
134     ///  new token
135     /// @param _parentSnapShotBlock Block of the parent token that will
136     ///  determine the initial distribution of the clone token, set to 0 if it
137     ///  is a new token
138     /// @param _tokenName Name of the new token
139     /// @param _decimalUnits Number of decimals of the new token
140     /// @param _tokenSymbol Token Symbol for the new token
141     /// @param _transfersEnabled If true, tokens will be able to be transferred
142     function MiniMeToken(
143         address _tokenFactory,
144         address _parentToken,
145         uint _parentSnapShotBlock,
146         string _tokenName,
147         uint8 _decimalUnits,
148         string _tokenSymbol,
149         bool _transfersEnabled
150     ) {
151         tokenFactory = MiniMeTokenFactory(_tokenFactory);
152         name = _tokenName;                                 // Set the name
153         decimals = _decimalUnits;                          // Set the decimals
154         symbol = _tokenSymbol;                             // Set the symbol
155         parentToken = MiniMeToken(_parentToken);
156         parentSnapShotBlock = _parentSnapShotBlock;
157         transfersEnabled = _transfersEnabled;
158         creationBlock = block.number;
159     }
160 
161 
162 ///////////////////
163 // ERC20 Methods
164 ///////////////////
165 
166     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
167     /// @param _to The address of the recipient
168     /// @param _amount The amount of tokens to be transferred
169     /// @return Whether the transfer was successful or not
170     function transfer(address _to, uint256 _amount) returns (bool success) {
171         require(transfersEnabled);
172         return doTransfer(msg.sender, _to, _amount);
173     }
174 
175     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
176     ///  is approved by `_from`
177     /// @param _from The address holding the tokens being transferred
178     /// @param _to The address of the recipient
179     /// @param _amount The amount of tokens to be transferred
180     /// @return True if the transfer was successful
181     function transferFrom(address _from, address _to, uint256 _amount
182     ) returns (bool success) {
183 
184         // The controller of this contract can move tokens around at will,
185         //  this is important to recognize! Confirm that you trust the
186         //  controller of this contract, which in most situations should be
187         //  another open source smart contract or 0x0
188         if (msg.sender != controller) {
189             require(transfersEnabled);
190 
191             // The standard ERC 20 transferFrom functionality
192             if (allowed[_from][msg.sender] < _amount) return false;
193             allowed[_from][msg.sender] -= _amount;
194         }
195         return doTransfer(_from, _to, _amount);
196     }
197 
198     /// @dev This is the actual transfer function in the token contract, it can
199     ///  only be called by other functions in this contract.
200     /// @param _from The address holding the tokens being transferred
201     /// @param _to The address of the recipient
202     /// @param _amount The amount of tokens to be transferred
203     /// @return True if the transfer was successful
204     function doTransfer(address _from, address _to, uint _amount
205     ) internal returns(bool) {
206 
207            if (_amount == 0) {
208                return true;
209            }
210 
211            require(parentSnapShotBlock < block.number);
212 
213            // Do not allow transfer to 0x0 or the token contract itself
214            require((_to != 0) && (_to != address(this)));
215 
216            // If the amount being transfered is more than the balance of the
217            //  account the transfer returns false
218            var previousBalanceFrom = balanceOfAt(_from, block.number);
219            if (previousBalanceFrom < _amount) {
220                return false;
221            }
222 
223            // Alerts the token controller of the transfer
224            if (isContract(controller)) {
225                require(TokenController(controller).onTransfer(_from, _to, _amount));
226            }
227 
228            // First update the balance array with the new value for the address
229            //  sending the tokens
230            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
231 
232            // Then update the balance array with the new value for the address
233            //  receiving the tokens
234            var previousBalanceTo = balanceOfAt(_to, block.number);
235            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
236            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
237 
238            // An event to make the transfer easy to find on the blockchain
239            Transfer(_from, _to, _amount);
240 
241            return true;
242     }
243 
244     /// @param _owner The address that's balance is being requested
245     /// @return The balance of `_owner` at the current block
246     function balanceOf(address _owner) constant returns (uint256 balance) {
247         return balanceOfAt(_owner, block.number);
248     }
249 
250     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
251     ///  its behalf. This is a modified version of the ERC20 approve function
252     ///  to be a little bit safer
253     /// @param _spender The address of the account able to transfer the tokens
254     /// @param _amount The amount of tokens to be approved for transfer
255     /// @return True if the approval was successful
256     function approve(address _spender, uint256 _amount) returns (bool success) {
257         require(transfersEnabled);
258 
259         // To change the approve amount you first have to reduce the addresses`
260         //  allowance to zero by calling `approve(_spender,0)` if it is not
261         //  already 0 to mitigate the race condition described here:
262         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
264 
265         // Alerts the token controller of the approve function call
266         if (isContract(controller)) {
267             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
268         }
269 
270         allowed[msg.sender][_spender] = _amount;
271         Approval(msg.sender, _spender, _amount);
272         return true;
273     }
274 
275     /// @dev This function makes it easy to read the `allowed[]` map
276     /// @param _owner The address of the account that owns the token
277     /// @param _spender The address of the account able to transfer the tokens
278     /// @return Amount of remaining tokens of _owner that _spender is allowed
279     ///  to spend
280     function allowance(address _owner, address _spender
281     ) constant returns (uint256 remaining) {
282         return allowed[_owner][_spender];
283     }
284 
285     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
286     ///  its behalf, and then a function is triggered in the contract that is
287     ///  being approved, `_spender`. This allows users to use their tokens to
288     ///  interact with contracts in one function call instead of two
289     /// @param _spender The address of the contract able to transfer the tokens
290     /// @param _amount The amount of tokens to be approved for transfer
291     /// @return True if the function call was successful
292     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
293     ) returns (bool success) {
294         require(approve(_spender, _amount));
295 
296         ApproveAndCallFallBack(_spender).receiveApproval(
297             msg.sender,
298             _amount,
299             this,
300             _extraData
301         );
302 
303         return true;
304     }
305 
306     /// @dev This function makes it easy to get the total number of tokens
307     /// @return The total number of tokens
308     function totalSupply() constant returns (uint) {
309         return totalSupplyAt(block.number);
310     }
311 
312 
313 ////////////////
314 // Query balance and totalSupply in History
315 ////////////////
316 
317     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
318     /// @param _owner The address from which the balance will be retrieved
319     /// @param _blockNumber The block number when the balance is queried
320     /// @return The balance at `_blockNumber`
321     function balanceOfAt(address _owner, uint _blockNumber) constant
322         returns (uint) {
323 
324         // These next few lines are used when the balance of the token is
325         //  requested before a check point was ever created for this token, it
326         //  requires that the `parentToken.balanceOfAt` be queried at the
327         //  genesis block for that token as this contains initial balance of
328         //  this token
329         if ((balances[_owner].length == 0)
330             || (balances[_owner][0].fromBlock > _blockNumber)) {
331             if (address(parentToken) != 0) {
332                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
333             } else {
334                 // Has no parent
335                 return 0;
336             }
337 
338         // This will return the expected balance during normal situations
339         } else {
340             return getValueAt(balances[_owner], _blockNumber);
341         }
342     }
343 
344     /// @notice Total amount of tokens at a specific `_blockNumber`.
345     /// @param _blockNumber The block number when the totalSupply is queried
346     /// @return The total amount of tokens at `_blockNumber`
347     function totalSupplyAt(uint _blockNumber) constant returns(uint) {
348 
349         // These next few lines are used when the totalSupply of the token is
350         //  requested before a check point was ever created for this token, it
351         //  requires that the `parentToken.totalSupplyAt` be queried at the
352         //  genesis block for this token as that contains totalSupply of this
353         //  token at this block number.
354         if ((totalSupplyHistory.length == 0)
355             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
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
388         ) returns(address) {
389         if (_snapshotBlock == 0) _snapshotBlock = block.number;
390         MiniMeToken cloneToken = tokenFactory.createCloneToken(
391             this,
392             _snapshotBlock,
393             _cloneTokenName,
394             _cloneDecimalUnits,
395             _cloneTokenSymbol,
396             _transfersEnabled
397             );
398 
399         cloneToken.changeController(msg.sender);
400 
401         // An event to make the token easy to find on the blockchain
402         NewCloneToken(address(cloneToken), _snapshotBlock);
403         return address(cloneToken);
404     }
405 
406 ////////////////
407 // Generate and destroy tokens
408 ////////////////
409 
410     /// @notice Generates `_amount` tokens that are assigned to `_owner`
411     /// @param _owner The address that will be assigned the new tokens
412     /// @param _amount The quantity of tokens generated
413     /// @return True if the tokens are generated correctly
414     function generateTokens(address _owner, uint _amount
415     ) onlyController returns (bool) {
416         uint curTotalSupply = totalSupply();
417         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
418         uint previousBalanceTo = balanceOf(_owner);
419         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
420         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
421         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
422         Transfer(0, _owner, _amount);
423         return true;
424     }
425 
426 
427     /// @notice Burns `_amount` tokens from `_owner`
428     /// @param _owner The address that will lose the tokens
429     /// @param _amount The quantity of tokens to burn
430     /// @return True if the tokens are burned correctly
431     function destroyTokens(address _owner, uint _amount
432     ) onlyController returns (bool) {
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
450     function enableTransfers(bool _transfersEnabled) onlyController {
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
462     function getValueAt(Checkpoint[] storage checkpoints, uint _block
463     ) constant internal returns (uint) {
464         if (checkpoints.length == 0) return 0;
465 
466         // Shortcut for the actual value
467         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
468             return checkpoints[checkpoints.length-1].value;
469         if (_block < checkpoints[0].fromBlock) return 0;
470 
471         // Binary search of the value in the array
472         uint min = 0;
473         uint max = checkpoints.length-1;
474         while (max > min) {
475             uint mid = (max + min + 1)/ 2;
476             if (checkpoints[mid].fromBlock<=_block) {
477                 min = mid;
478             } else {
479                 max = mid-1;
480             }
481         }
482         return checkpoints[min].value;
483     }
484 
485     /// @dev `updateValueAtNow` used to update the `balances` map and the
486     ///  `totalSupplyHistory`
487     /// @param checkpoints The history of data being updated
488     /// @param _value The new number of tokens
489     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
490     ) internal  {
491         if ((checkpoints.length == 0)
492         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
493                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
494                newCheckPoint.fromBlock =  uint128(block.number);
495                newCheckPoint.value = uint128(_value);
496            } else {
497                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
498                oldCheckPoint.value = uint128(_value);
499            }
500     }
501 
502     /// @dev Internal function to determine if an address is a contract
503     /// @param _addr The address being queried
504     /// @return True if `_addr` is a contract
505     function isContract(address _addr) constant internal returns(bool) {
506         uint size;
507         if (_addr == 0) return false;
508         assembly {
509             size := extcodesize(_addr)
510         }
511         return size>0;
512     }
513 
514     /// @dev Helper function to return a min betwen the two uints
515     function min(uint a, uint b) internal returns (uint) {
516         return a < b ? a : b;
517     }
518 
519     /// @notice The fallback function: If the contract's controller has not been
520     ///  set to 0, then the `proxyPayment` method is called which relays the
521     ///  ether and creates tokens as described in the token controller contract
522     function ()  payable {
523         require(isContract(controller));
524         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
525     }
526 
527 //////////
528 // Safety Methods
529 //////////
530 
531     /// @notice This method can be used by the controller to extract mistakenly
532     ///  sent tokens to this contract.
533     /// @param _token The address of the token contract that you want to recover
534     ///  set to 0 in case you want to extract ether.
535     function claimTokens(address _token) onlyController {
536         if (_token == 0x0) {
537             controller.transfer(this.balance);
538             return;
539         }
540 
541         MiniMeToken token = MiniMeToken(_token);
542         uint balance = token.balanceOf(this);
543         token.transfer(controller, balance);
544         ClaimedTokens(_token, controller, balance);
545     }
546 
547 ////////////////
548 // Events
549 ////////////////
550     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
551     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
552     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
553     event Approval(
554         address indexed _owner,
555         address indexed _spender,
556         uint256 _amount
557         );
558 
559 }
560 
561 
562 ////////////////
563 // MiniMeTokenFactory
564 ////////////////
565 
566 /// @dev This contract is used to generate clone contracts from a contract.
567 ///  In solidity this is the way to create a contract from a contract of the
568 ///  same class
569 contract MiniMeTokenFactory {
570 
571     /// @notice Update the DApp by creating a new token with new functionalities
572     ///  the msg.sender becomes the controller of this clone token
573     /// @param _parentToken Address of the token being cloned
574     /// @param _snapshotBlock Block of the parent token that will
575     ///  determine the initial distribution of the clone token
576     /// @param _tokenName Name of the new token
577     /// @param _decimalUnits Number of decimals of the new token
578     /// @param _tokenSymbol Token Symbol for the new token
579     /// @param _transfersEnabled If true, tokens will be able to be transferred
580     /// @return The address of the new token contract
581     function createCloneToken(
582         address _parentToken,
583         uint _snapshotBlock,
584         string _tokenName,
585         uint8 _decimalUnits,
586         string _tokenSymbol,
587         bool _transfersEnabled
588     ) returns (MiniMeToken) {
589         MiniMeToken newToken = new MiniMeToken(
590             this,
591             _parentToken,
592             _snapshotBlock,
593             _tokenName,
594             _decimalUnits,
595             _tokenSymbol,
596             _transfersEnabled
597             );
598 
599         newToken.changeController(msg.sender);
600         return newToken;
601     }
602 }
603 
604 /**
605  * @title Ownable
606  * @dev The Ownable contract has an owner address, and provides basic authorization control
607  * functions, this simplifies the implementation of "user permissions".
608  */
609 contract Ownable {
610   address public owner;
611 
612 
613   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
614 
615 
616   /**
617    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
618    * account.
619    */
620   function Ownable() {
621     owner = msg.sender;
622   }
623 
624 
625   /**
626    * @dev Throws if called by any account other than the owner.
627    */
628   modifier onlyOwner() {
629     require(msg.sender == owner);
630     _;
631   }
632 
633 
634   /**
635    * @dev Allows the current owner to transfer control of the contract to a newOwner.
636    * @param newOwner The address to transfer ownership to.
637    */
638   function transferOwnership(address newOwner) onlyOwner public {
639     require(newOwner != address(0));
640     OwnershipTransferred(owner, newOwner);
641     owner = newOwner;
642   }
643 
644 }
645 
646 library SafeMath {
647   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
648     uint256 c = a * b;
649     assert(a == 0 || c / a == b);
650     return c;
651   }
652 
653   function div(uint256 a, uint256 b) internal constant returns (uint256) {
654     // assert(b > 0); // Solidity automatically throws when dividing by 0
655     uint256 c = a / b;
656     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
657     return c;
658   }
659 
660   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
661     assert(b <= a);
662     return a - b;
663   }
664 
665   function add(uint256 a, uint256 b) internal constant returns (uint256) {
666     uint256 c = a + b;
667     assert(c >= a);
668     return c;
669   }
670 }
671 
672 contract RealLandCrowdSale is TokenController, Ownable {
673   using SafeMath for uint;
674 
675   MiniMeToken public tokenContract;
676 
677   uint public PRICE = 10; //1 Ether buys 10 RLD
678   uint public MIN_PURCHASE = 10**17; // 0.1 Ether
679   uint public decimals = 8;
680   uint etherRatio = SafeMath.div(1 ether, 10**decimals);
681 
682   uint256 public saleStartTime = 1512475200;
683   uint256 public saleEndTime = 1517832000;
684 
685   uint256 public totalSupply = 70000000 * 10**decimals;
686 
687   address public team = 0x03c3CD159170Ab0912Cd00d7cACba79694A32127;
688   address public marketting = 0x135B6526943e15fD68EaA05be73f24d641c332D8;
689   address public ipoPlatform = 0x8A8eCFDf0eb6f8406C0AD344a6435D6BAf3110e4;
690   uint256 public teamPercentage = 25000000000000000000; //% * 10**18
691   uint256 public markettingPercentage = 25000000000000000000; //% * 10**18
692   uint256 public ipoPlatformPercentage = 50000000000000000000; //% * 10**18
693                                          
694   bool public tokensAllocated = false;
695 
696   modifier saleOpen {
697     require((getNow() >= saleStartTime) && (getNow() < saleEndTime));
698     _;
699   }
700 
701   modifier saleClosed {
702     require(getNow() >= saleEndTime);
703     _;
704   }
705 
706   modifier isMinimum {
707     require(msg.value >= MIN_PURCHASE);
708     _;
709   }
710 
711   function RealLandCrowdSale(address _tokenContract) {
712     tokenContract = MiniMeToken(_tokenContract);
713   }
714 
715   function () payable public {
716     buyTokens(msg.sender);
717   }
718 
719   function buyTokens(address _recipient) payable public saleOpen isMinimum {
720 
721     //Calculate tokens
722     uint tokens = msg.value.mul(PRICE);
723 
724     //Add on any bonus
725     uint bonus = SafeMath.add(100, bonusPercentage());
726     if (bonus != 100) {
727       tokens = tokens.mul(percent(bonus)).div(percent(100));
728     }
729 
730     tokens = tokens.div(etherRatio);
731 
732     require(tokenContract.totalSupply().add(tokens) <= bonusCap().mul(10**decimals));
733 
734     require(tokenContract.generateTokens(_recipient, tokens));
735 
736     //Transfer Ether to owner
737     owner.transfer(msg.value);
738 
739   }
740 
741   function allocateTokens() public onlyOwner saleClosed {
742     require(!tokensAllocated);
743     tokensAllocated = true;
744     uint256 remainingTokens = totalSupply.sub(tokenContract.totalSupply());
745     uint256 ipoPlatformTokens = remainingTokens.mul(ipoPlatformPercentage).div(percent(100));
746     uint256 markettingTokens = remainingTokens.mul(markettingPercentage).div(percent(100));
747     uint256 teamTokens = remainingTokens.sub(ipoPlatformTokens).sub(markettingTokens);
748     require(tokenContract.generateTokens(team, teamTokens));
749     require(tokenContract.generateTokens(marketting, markettingTokens));
750     require(tokenContract.generateTokens(ipoPlatform, ipoPlatformTokens));
751   }
752 
753   function bonusPercentage() public constant returns(uint256) {
754 
755     uint elapsed = SafeMath.sub(getNow(), saleStartTime);
756 
757     if (elapsed < 1 weeks) return 25;
758     if (elapsed < 2 weeks) return 22;
759     if (elapsed < 3 weeks) return 20;
760     if (elapsed < 4 weeks) return 17;
761     if (elapsed < 5 weeks) return 15;
762     if (elapsed < 6 weeks) return 10;
763     if (elapsed < 7 weeks) return 7;
764     if (elapsed < 8 weeks) return 5;
765     if (elapsed < 9 weeks) return 2;
766 
767     return 0;
768 
769   }
770 
771   function bonusCap() public constant returns(uint256) {
772 
773     uint elapsed = SafeMath.sub(getNow(), saleStartTime);
774 
775     if (elapsed < 1 weeks) return 1000000;
776     if (elapsed < 2 weeks) return 3000000;
777     if (elapsed < 3 weeks) return 5500000;
778     if (elapsed < 4 weeks) return 8500000;
779     if (elapsed < 5 weeks) return 12000000;
780     if (elapsed < 6 weeks) return 17000000;
781     if (elapsed < 7 weeks) return 24000000;
782     if (elapsed < 8 weeks) return 36000000;
783     if (elapsed < 9 weeks) return 56000000;
784 
785     return 70000000;
786 
787   }
788 
789   function percent(uint256 p) internal returns (uint256) {
790     return p.mul(10**18);
791   }
792 
793   //Function is mocked for tests
794   function getNow() internal constant returns (uint256) {
795     return now;
796   }
797 
798   //TokenController implementation
799 
800   /// @notice Called when `_owner` sends ether to the MiniMe Token contract
801   /// @param _owner The address that sent the ether to create tokens
802   /// @return True if the ether is accepted, false if it throws
803   function proxyPayment(address _owner) payable public returns(bool) {
804     return false;
805   }
806 
807   /// @notice Notifies the controller about a token transfer allowing the
808   ///  controller to react if desired
809   /// @param _from The origin of the transfer
810   /// @param _to The destination of the transfer
811   /// @param _amount The amount of the transfer
812   /// @return False if the controller does not authorize the transfer
813   function onTransfer(address _from, address _to, uint _amount) public saleClosed returns(bool) {
814     return true;
815   }
816 
817   /// @notice Notifies the controller about an approval allowing the
818   ///  controller to react if desired
819   /// @param _owner The address that calls `approve()`
820   /// @param _spender The spender in the `approve()` call
821   /// @param _amount The amount in the `approve()` call
822   /// @return False if the controller does not authorize the approval
823   function onApprove(address _owner, address _spender, uint _amount) public saleClosed returns(bool) {
824     return true;
825   }
826 
827 }