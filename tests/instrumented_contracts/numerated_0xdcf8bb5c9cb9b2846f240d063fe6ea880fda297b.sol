1 pragma solidity ^0.4.18;
2 
3 // File: contracts/KnowsTime.sol
4 
5 contract KnowsTime {
6     function KnowsTime() public {
7     }
8 
9     function currentTime() public view returns (uint) {
10         return now;
11     }
12 }
13 
14 // File: zeppelin-solidity/contracts/math/SafeMath.sol
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59 
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62 
63   /**
64    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
65    * account.
66    */
67   function Ownable() public {
68     owner = msg.sender;
69   }
70 
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: contracts/BntyExchangeRateCalculator.sol
94 
95 // This contract does the math to figure out the BNTY paid per WEI, based on the USD ether price
96 contract BntyExchangeRateCalculator is KnowsTime, Ownable {
97     using SafeMath for uint;
98 
99     uint public constant WEI_PER_ETH = 10 ** 18;
100 
101     uint public constant MICRODOLLARS_PER_DOLLAR = 10 ** 6;
102 
103     uint public bntyMicrodollarPrice;
104 
105     uint public USDEtherPrice;
106 
107     uint public fixUSDPriceTime;
108 
109     // a microdollar is one millionth of a dollar, or one ten-thousandth of a cent
110     function BntyExchangeRateCalculator(uint _bntyMicrodollarPrice, uint _USDEtherPrice, uint _fixUSDPriceTime)
111         public
112     {
113         require(_bntyMicrodollarPrice > 0);
114         require(_USDEtherPrice > 0);
115 
116         bntyMicrodollarPrice = _bntyMicrodollarPrice;
117         fixUSDPriceTime = _fixUSDPriceTime;
118         USDEtherPrice = _USDEtherPrice;
119     }
120 
121     // the owner can change the usd ether price
122     function setUSDEtherPrice(uint _USDEtherPrice) onlyOwner public {
123         require(currentTime() < fixUSDPriceTime);
124         require(_USDEtherPrice > 0);
125 
126         USDEtherPrice = _USDEtherPrice;
127     }
128 
129     // returns the number of wei some amount of usd
130     function usdToWei(uint usd) view public returns (uint) {
131         return WEI_PER_ETH.mul(usd).div(USDEtherPrice);
132     }
133 
134     // returns the number of bnty per some amount in wei
135     function weiToBnty(uint amtWei) view public returns (uint) {
136         return USDEtherPrice.mul(MICRODOLLARS_PER_DOLLAR).mul(amtWei).div(bntyMicrodollarPrice);
137     }
138 }
139 
140 // File: minimetoken/contracts/Controlled.sol
141 
142 contract Controlled {
143     /// @notice The address of the controller is the only address that can call
144     ///  a function with this modifier
145     modifier onlyController { require(msg.sender == controller); _; }
146 
147     address public controller;
148 
149     function Controlled() public { controller = msg.sender;}
150 
151     /// @notice Changes the controller of the contract
152     /// @param _newController The new controller of the contract
153     function changeController(address _newController) public onlyController {
154         controller = _newController;
155     }
156 }
157 
158 // File: minimetoken/contracts/TokenController.sol
159 
160 /// @dev The token controller contract must implement these functions
161 contract TokenController {
162     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
163     /// @param _owner The address that sent the ether to create tokens
164     /// @return True if the ether is accepted, false if it throws
165     function proxyPayment(address _owner) public payable returns(bool);
166 
167     /// @notice Notifies the controller about a token transfer allowing the
168     ///  controller to react if desired
169     /// @param _from The origin of the transfer
170     /// @param _to The destination of the transfer
171     /// @param _amount The amount of the transfer
172     /// @return False if the controller does not authorize the transfer
173     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
174 
175     /// @notice Notifies the controller about an approval allowing the
176     ///  controller to react if desired
177     /// @param _owner The address that calls `approve()`
178     /// @param _spender The spender in the `approve()` call
179     /// @param _amount The amount in the `approve()` call
180     /// @return False if the controller does not authorize the approval
181     function onApprove(address _owner, address _spender, uint _amount) public
182         returns(bool);
183 }
184 
185 // File: minimetoken/contracts/MiniMeToken.sol
186 
187 /*
188     Copyright 2016, Jordi Baylina
189 
190     This program is free software: you can redistribute it and/or modify
191     it under the terms of the GNU General Public License as published by
192     the Free Software Foundation, either version 3 of the License, or
193     (at your option) any later version.
194 
195     This program is distributed in the hope that it will be useful,
196     but WITHOUT ANY WARRANTY; without even the implied warranty of
197     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
198     GNU General Public License for more details.
199 
200     You should have received a copy of the GNU General Public License
201     along with this program.  If not, see <http://www.gnu.org/licenses/>.
202  */
203 
204 /// @title MiniMeToken Contract
205 /// @author Jordi Baylina
206 /// @dev This token contract's goal is to make it easy for anyone to clone this
207 ///  token using the token distribution at a given block, this will allow DAO's
208 ///  and DApps to upgrade their features in a decentralized manner without
209 ///  affecting the original token
210 /// @dev It is ERC20 compliant, but still needs to under go further testing.
211 
212 
213 
214 
215 contract ApproveAndCallFallBack {
216     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
217 }
218 
219 /// @dev The actual token contract, the default controller is the msg.sender
220 ///  that deploys the contract, so usually this token will be deployed by a
221 ///  token controller contract, which Giveth will call a "Campaign"
222 contract MiniMeToken is Controlled {
223 
224     string public name;                //The Token's name: e.g. DigixDAO Tokens
225     uint8 public decimals;             //Number of decimals of the smallest unit
226     string public symbol;              //An identifier: e.g. REP
227     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
228 
229 
230     /// @dev `Checkpoint` is the structure that attaches a block number to a
231     ///  given value, the block number attached is the one that last changed the
232     ///  value
233     struct  Checkpoint {
234 
235         // `fromBlock` is the block number that the value was generated from
236         uint128 fromBlock;
237 
238         // `value` is the amount of tokens at a specific block number
239         uint128 value;
240     }
241 
242     // `parentToken` is the Token address that was cloned to produce this token;
243     //  it will be 0x0 for a token that was not cloned
244     MiniMeToken public parentToken;
245 
246     // `parentSnapShotBlock` is the block number from the Parent Token that was
247     //  used to determine the initial distribution of the Clone Token
248     uint public parentSnapShotBlock;
249 
250     // `creationBlock` is the block number that the Clone Token was created
251     uint public creationBlock;
252 
253     // `balances` is the map that tracks the balance of each address, in this
254     //  contract when the balance changes the block number that the change
255     //  occurred is also included in the map
256     mapping (address => Checkpoint[]) balances;
257 
258     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
259     mapping (address => mapping (address => uint256)) allowed;
260 
261     // Tracks the history of the `totalSupply` of the token
262     Checkpoint[] totalSupplyHistory;
263 
264     // Flag that determines if the token is transferable or not.
265     bool public transfersEnabled;
266 
267     // The factory used to create new clone tokens
268     MiniMeTokenFactory public tokenFactory;
269 
270 ////////////////
271 // Constructor
272 ////////////////
273 
274     /// @notice Constructor to create a MiniMeToken
275     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
276     ///  will create the Clone token contracts, the token factory needs to be
277     ///  deployed first
278     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
279     ///  new token
280     /// @param _parentSnapShotBlock Block of the parent token that will
281     ///  determine the initial distribution of the clone token, set to 0 if it
282     ///  is a new token
283     /// @param _tokenName Name of the new token
284     /// @param _decimalUnits Number of decimals of the new token
285     /// @param _tokenSymbol Token Symbol for the new token
286     /// @param _transfersEnabled If true, tokens will be able to be transferred
287     function MiniMeToken(
288         address _tokenFactory,
289         address _parentToken,
290         uint _parentSnapShotBlock,
291         string _tokenName,
292         uint8 _decimalUnits,
293         string _tokenSymbol,
294         bool _transfersEnabled
295     ) public {
296         tokenFactory = MiniMeTokenFactory(_tokenFactory);
297         name = _tokenName;                                 // Set the name
298         decimals = _decimalUnits;                          // Set the decimals
299         symbol = _tokenSymbol;                             // Set the symbol
300         parentToken = MiniMeToken(_parentToken);
301         parentSnapShotBlock = _parentSnapShotBlock;
302         transfersEnabled = _transfersEnabled;
303         creationBlock = block.number;
304     }
305 
306 
307 ///////////////////
308 // ERC20 Methods
309 ///////////////////
310 
311     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
312     /// @param _to The address of the recipient
313     /// @param _amount The amount of tokens to be transferred
314     /// @return Whether the transfer was successful or not
315     function transfer(address _to, uint256 _amount) public returns (bool success) {
316         require(transfersEnabled);
317         return doTransfer(msg.sender, _to, _amount);
318     }
319 
320     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
321     ///  is approved by `_from`
322     /// @param _from The address holding the tokens being transferred
323     /// @param _to The address of the recipient
324     /// @param _amount The amount of tokens to be transferred
325     /// @return True if the transfer was successful
326     function transferFrom(address _from, address _to, uint256 _amount
327     ) public returns (bool success) {
328 
329         // The controller of this contract can move tokens around at will,
330 
331         //  controller of this contract, which in most situations should be
332         //  another open source smart contract or 0x0
333         if (msg.sender != controller) {
334             require(transfersEnabled);
335 
336             // The standard ERC 20 transferFrom functionality
337             if (allowed[_from][msg.sender] < _amount) return false;
338             allowed[_from][msg.sender] -= _amount;
339         }
340         return doTransfer(_from, _to, _amount);
341     }
342 
343     /// @dev This is the actual transfer function in the token contract, it can
344     ///  only be called by other functions in this contract.
345     /// @param _from The address holding the tokens being transferred
346     /// @param _to The address of the recipient
347     /// @param _amount The amount of tokens to be transferred
348     /// @return True if the transfer was successful
349     function doTransfer(address _from, address _to, uint _amount
350     ) internal returns(bool) {
351 
352            if (_amount == 0) {
353                return true;
354            }
355 
356            require(parentSnapShotBlock < block.number);
357 
358            // Do not allow transfer to 0x0 or the token contract itself
359            require((_to != 0) && (_to != address(this)));
360 
361            // If the amount being transfered is more than the balance of the
362            //  account the transfer returns false
363            var previousBalanceFrom = balanceOfAt(_from, block.number);
364            if (previousBalanceFrom < _amount) {
365                return false;
366            }
367 
368            // Alerts the token controller of the transfer
369            if (isContract(controller)) {
370                require(TokenController(controller).onTransfer(_from, _to, _amount));
371            }
372 
373            // First update the balance array with the new value for the address
374            //  sending the tokens
375            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
376 
377            // Then update the balance array with the new value for the address
378            //  receiving the tokens
379            var previousBalanceTo = balanceOfAt(_to, block.number);
380            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
381            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
382 
383            // An event to make the transfer easy to find on the blockchain
384            Transfer(_from, _to, _amount);
385 
386            return true;
387     }
388 
389     /// @param _owner The address that's balance is being requested
390     /// @return The balance of `_owner` at the current block
391     function balanceOf(address _owner) public constant returns (uint256 balance) {
392         return balanceOfAt(_owner, block.number);
393     }
394 
395     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
396     ///  its behalf. This is a modified version of the ERC20 approve function
397     ///  to be a little bit safer
398     /// @param _spender The address of the account able to transfer the tokens
399     /// @param _amount The amount of tokens to be approved for transfer
400     /// @return True if the approval was successful
401     function approve(address _spender, uint256 _amount) public returns (bool success) {
402         require(transfersEnabled);
403 
404         // To change the approve amount you first have to reduce the addresses`
405         //  allowance to zero by calling `approve(_spender,0)` if it is not
406         //  already 0 to mitigate the race condition described here:
407         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
408         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
409 
410         // Alerts the token controller of the approve function call
411         if (isContract(controller)) {
412             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
413         }
414 
415         allowed[msg.sender][_spender] = _amount;
416         Approval(msg.sender, _spender, _amount);
417         return true;
418     }
419 
420     /// @dev This function makes it easy to read the `allowed[]` map
421     /// @param _owner The address of the account that owns the token
422     /// @param _spender The address of the account able to transfer the tokens
423     /// @return Amount of remaining tokens of _owner that _spender is allowed
424     ///  to spend
425     function allowance(address _owner, address _spender
426     ) public constant returns (uint256 remaining) {
427         return allowed[_owner][_spender];
428     }
429 
430     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
431     ///  its behalf, and then a function is triggered in the contract that is
432     ///  being approved, `_spender`. This allows users to use their tokens to
433     ///  interact with contracts in one function call instead of two
434     /// @param _spender The address of the contract able to transfer the tokens
435     /// @param _amount The amount of tokens to be approved for transfer
436     /// @return True if the function call was successful
437     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
438     ) public returns (bool success) {
439         require(approve(_spender, _amount));
440 
441         ApproveAndCallFallBack(_spender).receiveApproval(
442             msg.sender,
443             _amount,
444             this,
445             _extraData
446         );
447 
448         return true;
449     }
450 
451     /// @dev This function makes it easy to get the total number of tokens
452     /// @return The total number of tokens
453     function totalSupply() public constant returns (uint) {
454         return totalSupplyAt(block.number);
455     }
456 
457 
458 ////////////////
459 // Query balance and totalSupply in History
460 ////////////////
461 
462     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
463     /// @param _owner The address from which the balance will be retrieved
464     /// @param _blockNumber The block number when the balance is queried
465     /// @return The balance at `_blockNumber`
466     function balanceOfAt(address _owner, uint _blockNumber) public constant
467         returns (uint) {
468 
469         // These next few lines are used when the balance of the token is
470         //  requested before a check point was ever created for this token, it
471         //  requires that the `parentToken.balanceOfAt` be queried at the
472         //  genesis block for that token as this contains initial balance of
473         //  this token
474         if ((balances[_owner].length == 0)
475             || (balances[_owner][0].fromBlock > _blockNumber)) {
476             if (address(parentToken) != 0) {
477                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
478             } else {
479                 // Has no parent
480                 return 0;
481             }
482 
483         // This will return the expected balance during normal situations
484         } else {
485             return getValueAt(balances[_owner], _blockNumber);
486         }
487     }
488 
489     /// @notice Total amount of tokens at a specific `_blockNumber`.
490     /// @param _blockNumber The block number when the totalSupply is queried
491     /// @return The total amount of tokens at `_blockNumber`
492     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
493 
494         // These next few lines are used when the totalSupply of the token is
495         //  requested before a check point was ever created for this token, it
496         //  requires that the `parentToken.totalSupplyAt` be queried at the
497         //  genesis block for this token as that contains totalSupply of this
498         //  token at this block number.
499         if ((totalSupplyHistory.length == 0)
500             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
501             if (address(parentToken) != 0) {
502                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
503             } else {
504                 return 0;
505             }
506 
507         // This will return the expected totalSupply during normal situations
508         } else {
509             return getValueAt(totalSupplyHistory, _blockNumber);
510         }
511     }
512 
513 ////////////////
514 // Clone Token Method
515 ////////////////
516 
517     /// @notice Creates a new clone token with the initial distribution being
518     ///  this token at `_snapshotBlock`
519     /// @param _cloneTokenName Name of the clone token
520     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
521     /// @param _cloneTokenSymbol Symbol of the clone token
522     /// @param _snapshotBlock Block when the distribution of the parent token is
523     ///  copied to set the initial distribution of the new clone token;
524     ///  if the block is zero than the actual block, the current block is used
525     /// @param _transfersEnabled True if transfers are allowed in the clone
526     /// @return The address of the new MiniMeToken Contract
527     function createCloneToken(
528         string _cloneTokenName,
529         uint8 _cloneDecimalUnits,
530         string _cloneTokenSymbol,
531         uint _snapshotBlock,
532         bool _transfersEnabled
533         ) public returns(address) {
534         if (_snapshotBlock == 0) _snapshotBlock = block.number;
535         MiniMeToken cloneToken = tokenFactory.createCloneToken(
536             this,
537             _snapshotBlock,
538             _cloneTokenName,
539             _cloneDecimalUnits,
540             _cloneTokenSymbol,
541             _transfersEnabled
542             );
543 
544         cloneToken.changeController(msg.sender);
545 
546         // An event to make the token easy to find on the blockchain
547         NewCloneToken(address(cloneToken), _snapshotBlock);
548         return address(cloneToken);
549     }
550 
551 ////////////////
552 // Generate and destroy tokens
553 ////////////////
554 
555     /// @notice Generates `_amount` tokens that are assigned to `_owner`
556     /// @param _owner The address that will be assigned the new tokens
557     /// @param _amount The quantity of tokens generated
558     /// @return True if the tokens are generated correctly
559     function generateTokens(address _owner, uint _amount
560     ) public onlyController returns (bool) {
561         uint curTotalSupply = totalSupply();
562         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
563         uint previousBalanceTo = balanceOf(_owner);
564         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
565         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
566         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
567         Transfer(0, _owner, _amount);
568         return true;
569     }
570 
571 
572     /// @notice Burns `_amount` tokens from `_owner`
573     /// @param _owner The address that will lose the tokens
574     /// @param _amount The quantity of tokens to burn
575     /// @return True if the tokens are burned correctly
576     function destroyTokens(address _owner, uint _amount
577     ) onlyController public returns (bool) {
578         uint curTotalSupply = totalSupply();
579         require(curTotalSupply >= _amount);
580         uint previousBalanceFrom = balanceOf(_owner);
581         require(previousBalanceFrom >= _amount);
582         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
583         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
584         Transfer(_owner, 0, _amount);
585         return true;
586     }
587 
588 ////////////////
589 // Enable tokens transfers
590 ////////////////
591 
592 
593     /// @notice Enables token holders to transfer their tokens freely if true
594     /// @param _transfersEnabled True if transfers are allowed in the clone
595     function enableTransfers(bool _transfersEnabled) public onlyController {
596         transfersEnabled = _transfersEnabled;
597     }
598 
599 ////////////////
600 // Internal helper functions to query and set a value in a snapshot array
601 ////////////////
602 
603     /// @dev `getValueAt` retrieves the number of tokens at a given block number
604     /// @param checkpoints The history of values being queried
605     /// @param _block The block number to retrieve the value at
606     /// @return The number of tokens being queried
607     function getValueAt(Checkpoint[] storage checkpoints, uint _block
608     ) constant internal returns (uint) {
609         if (checkpoints.length == 0) return 0;
610 
611         // Shortcut for the actual value
612         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
613             return checkpoints[checkpoints.length-1].value;
614         if (_block < checkpoints[0].fromBlock) return 0;
615 
616         // Binary search of the value in the array
617         uint min = 0;
618         uint max = checkpoints.length-1;
619         while (max > min) {
620             uint mid = (max + min + 1)/ 2;
621             if (checkpoints[mid].fromBlock<=_block) {
622                 min = mid;
623             } else {
624                 max = mid-1;
625             }
626         }
627         return checkpoints[min].value;
628     }
629 
630     /// @dev `updateValueAtNow` used to update the `balances` map and the
631     ///  `totalSupplyHistory`
632     /// @param checkpoints The history of data being updated
633     /// @param _value The new number of tokens
634     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
635     ) internal  {
636         if ((checkpoints.length == 0)
637         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
638                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
639                newCheckPoint.fromBlock =  uint128(block.number);
640                newCheckPoint.value = uint128(_value);
641            } else {
642                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
643                oldCheckPoint.value = uint128(_value);
644            }
645     }
646 
647     /// @dev Internal function to determine if an address is a contract
648     /// @param _addr The address being queried
649     /// @return True if `_addr` is a contract
650     function isContract(address _addr) constant internal returns(bool) {
651         uint size;
652         if (_addr == 0) return false;
653         assembly {
654             size := extcodesize(_addr)
655         }
656         return size>0;
657     }
658 
659     /// @dev Helper function to return a min betwen the two uints
660     function min(uint a, uint b) pure internal returns (uint) {
661         return a < b ? a : b;
662     }
663 
664     /// @notice The fallback function: If the contract's controller has not been
665     ///  set to 0, then the `proxyPayment` method is called which relays the
666     ///  ether and creates tokens as described in the token controller contract
667     function () public payable {
668         require(isContract(controller));
669         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
670     }
671 
672 //////////
673 // Safety Methods
674 //////////
675 
676     /// @notice This method can be used by the controller to extract mistakenly
677     ///  sent tokens to this contract.
678     /// @param _token The address of the token contract that you want to recover
679     ///  set to 0 in case you want to extract ether.
680     function claimTokens(address _token) public onlyController {
681         if (_token == 0x0) {
682             controller.transfer(this.balance);
683             return;
684         }
685 
686         MiniMeToken token = MiniMeToken(_token);
687         uint balance = token.balanceOf(this);
688         token.transfer(controller, balance);
689         ClaimedTokens(_token, controller, balance);
690     }
691 
692 ////////////////
693 // Events
694 ////////////////
695     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
696     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
697     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
698     event Approval(
699         address indexed _owner,
700         address indexed _spender,
701         uint256 _amount
702         );
703 
704 }
705 
706 
707 ////////////////
708 // MiniMeTokenFactory
709 ////////////////
710 
711 /// @dev This contract is used to generate clone contracts from a contract.
712 ///  In solidity this is the way to create a contract from a contract of the
713 ///  same class
714 contract MiniMeTokenFactory {
715 
716     /// @notice Update the DApp by creating a new token with new functionalities
717     ///  the msg.sender becomes the controller of this clone token
718     /// @param _parentToken Address of the token being cloned
719     /// @param _snapshotBlock Block of the parent token that will
720     ///  determine the initial distribution of the clone token
721     /// @param _tokenName Name of the new token
722     /// @param _decimalUnits Number of decimals of the new token
723     /// @param _tokenSymbol Token Symbol for the new token
724     /// @param _transfersEnabled If true, tokens will be able to be transferred
725     /// @return The address of the new token contract
726     function createCloneToken(
727         address _parentToken,
728         uint _snapshotBlock,
729         string _tokenName,
730         uint8 _decimalUnits,
731         string _tokenSymbol,
732         bool _transfersEnabled
733     ) public returns (MiniMeToken) {
734         MiniMeToken newToken = new MiniMeToken(
735             this,
736             _parentToken,
737             _snapshotBlock,
738             _tokenName,
739             _decimalUnits,
740             _tokenSymbol,
741             _transfersEnabled
742             );
743 
744         newToken.changeController(msg.sender);
745         return newToken;
746     }
747 }
748 
749 // File: contracts/Bounty0xToken.sol
750 
751 contract Bounty0xToken is MiniMeToken {
752     function Bounty0xToken(address _tokenFactory)
753         MiniMeToken(
754             _tokenFactory,
755             0x0,                        // no parent token
756             0,                          // no snapshot block number from parent
757             "Bounty0x Token",           // Token name
758             18   ,                      // Decimals
759             "BNTY",                     // Symbol
760             false                       // Disable transfers
761         )
762         public
763     {
764     }
765 
766     // generate tokens for many addresses with a single transaction
767     function generateTokensAll(address[] _owners, uint[] _amounts) onlyController public {
768         require(_owners.length == _amounts.length);
769 
770         for (uint i = 0; i < _owners.length; i++) {
771             require(generateTokens(_owners[i], _amounts[i]));
772         }
773     }
774 }
775 
776 // File: contracts/KnowsConstants.sol
777 
778 // These are the specifications of the contract, unlikely to change
779 contract KnowsConstants {
780     // The fixed USD price per BNTY
781     uint public constant FIXED_PRESALE_USD_ETHER_PRICE = 355;
782     uint public constant MICRO_DOLLARS_PER_BNTY_MAINSALE = 16500;
783     uint public constant MICRO_DOLLARS_PER_BNTY_PRESALE = 13200;
784 
785     // Contribution constants
786     uint public constant HARD_CAP_USD = 1500000;                           // in USD the maximum total collected amount
787     uint public constant MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD = 1500; // in USD the maximum contribution amount during the whitelist period
788     uint public constant MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD = 10000;  // in USD the maximum contribution amount after the whitelist period ends
789     uint public constant MAX_GAS_PRICE = 70 * (10 ** 9);                   // Max gas price of 70 gwei
790     uint public constant MAX_GAS = 500000;                                 // Max gas that can be sent with tx
791 
792     // Time constants
793     uint public constant SALE_START_DATE = 1513346400;                    // in unix timestamp Dec 15th @ 15:00 CET
794     uint public constant WHITELIST_END_DATE = SALE_START_DATE + 24 hours; // End whitelist 24 hours after sale start date/time
795     uint public constant LIMITS_END_DATE = SALE_START_DATE + 48 hours;    // End all limits 48 hours after the sale start date
796     uint public constant SALE_END_DATE = SALE_START_DATE + 4 weeks;       // end sale in four weeks
797     uint public constant UNFREEZE_DATE = SALE_START_DATE + 76 weeks;      // Bounty0x Reserve locked for 18 months
798 
799     function KnowsConstants() public {}
800 }
801 
802 // File: contracts/interfaces/Bounty0xPresaleI.sol
803 
804 /**
805  * This interface describes the only function we will be calling from the Bounty0xPresaleI contract
806  */
807 interface Bounty0xPresaleI {
808     function balanceOf(address addr) public returns (uint balance);
809 }
810 
811 // File: zeppelin-solidity/contracts/math/Math.sol
812 
813 /**
814  * @title Math
815  * @dev Assorted math operations
816  */
817 
818 library Math {
819   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
820     return a >= b ? a : b;
821   }
822 
823   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
824     return a < b ? a : b;
825   }
826 
827   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
828     return a >= b ? a : b;
829   }
830 
831   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
832     return a < b ? a : b;
833   }
834 }
835 
836 // File: contracts/Bounty0xPresaleDistributor.sol
837 
838 /*
839 This contract manages compensation of the presale investors, based on the contribution balances recorded in the presale
840 contract.
841 */
842 contract Bounty0xPresaleDistributor is KnowsConstants, BntyExchangeRateCalculator {
843     using SafeMath for uint;
844 
845     Bounty0xPresaleI public deployedPresaleContract;
846     Bounty0xToken public bounty0xToken;
847 
848     mapping(address => uint) public tokensPaid;
849 
850     function Bounty0xPresaleDistributor(Bounty0xToken _bounty0xToken, Bounty0xPresaleI _deployedPresaleContract)
851         BntyExchangeRateCalculator(MICRO_DOLLARS_PER_BNTY_PRESALE, FIXED_PRESALE_USD_ETHER_PRICE, 0)
852         public
853     {
854         bounty0xToken = _bounty0xToken;
855         deployedPresaleContract = _deployedPresaleContract;
856     }
857 
858     event OnPreSaleBuyerCompensated(address indexed contributor, uint numTokens);
859 
860     /**
861      * Compensate the presale investors at the addresses provider based on their contributions during the presale
862      */
863     function compensatePreSaleInvestors(address[] preSaleInvestors) public {
864         // iterate through each investor
865         for (uint i = 0; i < preSaleInvestors.length; i++) {
866             address investorAddress = preSaleInvestors[i];
867 
868             // the deployed presale contract tracked the balance of each contributor
869             uint weiContributed = deployedPresaleContract.balanceOf(investorAddress);
870 
871             // they contributed and haven't been paid
872             if (weiContributed > 0 && tokensPaid[investorAddress] == 0) {
873                 // convert the amount of wei they contributed to the bnty
874                 uint bntyCompensation = Math.min256(weiToBnty(weiContributed), bounty0xToken.balanceOf(this));
875 
876                 // mark them paid first
877                 tokensPaid[investorAddress] = bntyCompensation;
878 
879                 // transfer tokens to presale contributor address
880                 require(bounty0xToken.transfer(investorAddress, bntyCompensation));
881 
882                 // log the event
883                 OnPreSaleBuyerCompensated(investorAddress, bntyCompensation);
884             }
885         }
886     }
887 }