1 pragma solidity ^0.4.18;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: contracts/AddressWhitelist.sol
48 
49 // A simple contract that stores a whitelist of addresses, which the owner may update
50 contract AddressWhitelist is Ownable {
51     // the addresses that are included in the whitelist
52     mapping (address => bool) public whitelisted;
53 
54     function AddressWhitelist() public {
55     }
56 
57     function isWhitelisted(address addr) view public returns (bool) {
58         return whitelisted[addr];
59     }
60 
61     event LogWhitelistAdd(address indexed addr);
62 
63     // add these addresses to the whitelist
64     function addToWhitelist(address[] addresses) public onlyOwner returns (bool) {
65         for (uint i = 0; i < addresses.length; i++) {
66             if (!whitelisted[addresses[i]]) {
67                 whitelisted[addresses[i]] = true;
68                 LogWhitelistAdd(addresses[i]);
69             }
70         }
71 
72         return true;
73     }
74 
75     event LogWhitelistRemove(address indexed addr);
76 
77     // remove these addresses from the whitelist
78     function removeFromWhitelist(address[] addresses) public onlyOwner returns (bool) {
79         for (uint i = 0; i < addresses.length; i++) {
80             if (whitelisted[addresses[i]]) {
81                 whitelisted[addresses[i]] = false;
82                 LogWhitelistRemove(addresses[i]);
83             }
84         }
85 
86         return true;
87     }
88 }
89 
90 // File: contracts/KnowsTime.sol
91 
92 contract KnowsTime {
93     function KnowsTime() public {
94     }
95 
96     function currentTime() public view returns (uint) {
97         return now;
98     }
99 }
100 
101 // File: zeppelin-solidity/contracts/math/SafeMath.sol
102 
103 /**
104  * @title SafeMath
105  * @dev Math operations with safety checks that throw on error
106  */
107 library SafeMath {
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     if (a == 0) {
110       return 0;
111     }
112     uint256 c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   function div(uint256 a, uint256 b) internal pure returns (uint256) {
118     // assert(b > 0); // Solidity automatically throws when dividing by 0
119     uint256 c = a / b;
120     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121     return c;
122   }
123 
124   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125     assert(b <= a);
126     return a - b;
127   }
128 
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130     uint256 c = a + b;
131     assert(c >= a);
132     return c;
133   }
134 }
135 
136 // File: contracts/BntyExchangeRateCalculator.sol
137 
138 // This contract does the math to figure out the BNTY paid per WEI, based on the USD ether price
139 contract BntyExchangeRateCalculator is KnowsTime, Ownable {
140     using SafeMath for uint;
141 
142     uint public constant WEI_PER_ETH = 10 ** 18;
143 
144     uint public constant MICRODOLLARS_PER_DOLLAR = 10 ** 6;
145 
146     uint public bntyMicrodollarPrice;
147 
148     uint public USDEtherPrice;
149 
150     uint public fixUSDPriceTime;
151 
152     // a microdollar is one millionth of a dollar, or one ten-thousandth of a cent
153     function BntyExchangeRateCalculator(uint _bntyMicrodollarPrice, uint _USDEtherPrice, uint _fixUSDPriceTime)
154         public
155     {
156         require(_bntyMicrodollarPrice > 0);
157         require(_USDEtherPrice > 0);
158 
159         bntyMicrodollarPrice = _bntyMicrodollarPrice;
160         fixUSDPriceTime = _fixUSDPriceTime;
161         USDEtherPrice = _USDEtherPrice;
162     }
163 
164     // the owner can change the usd ether price
165     function setUSDEtherPrice(uint _USDEtherPrice) onlyOwner public {
166         require(currentTime() < fixUSDPriceTime);
167         require(_USDEtherPrice > 0);
168 
169         USDEtherPrice = _USDEtherPrice;
170     }
171 
172     // returns the number of wei some amount of usd
173     function usdToWei(uint usd) view public returns (uint) {
174         return WEI_PER_ETH.mul(usd).div(USDEtherPrice);
175     }
176 
177     // returns the number of bnty per some amount in wei
178     function weiToBnty(uint amtWei) view public returns (uint) {
179         return USDEtherPrice.mul(MICRODOLLARS_PER_DOLLAR).mul(amtWei).div(bntyMicrodollarPrice);
180     }
181 }
182 
183 // File: minimetoken/contracts/Controlled.sol
184 
185 contract Controlled {
186     /// @notice The address of the controller is the only address that can call
187     ///  a function with this modifier
188     modifier onlyController { require(msg.sender == controller); _; }
189 
190     address public controller;
191 
192     function Controlled() public { controller = msg.sender;}
193 
194     /// @notice Changes the controller of the contract
195     /// @param _newController The new controller of the contract
196     function changeController(address _newController) public onlyController {
197         controller = _newController;
198     }
199 }
200 
201 // File: minimetoken/contracts/TokenController.sol
202 
203 /// @dev The token controller contract must implement these functions
204 contract TokenController {
205     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
206     /// @param _owner The address that sent the ether to create tokens
207     /// @return True if the ether is accepted, false if it throws
208     function proxyPayment(address _owner) public payable returns(bool);
209 
210     /// @notice Notifies the controller about a token transfer allowing the
211     ///  controller to react if desired
212     /// @param _from The origin of the transfer
213     /// @param _to The destination of the transfer
214     /// @param _amount The amount of the transfer
215     /// @return False if the controller does not authorize the transfer
216     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
217 
218     /// @notice Notifies the controller about an approval allowing the
219     ///  controller to react if desired
220     /// @param _owner The address that calls `approve()`
221     /// @param _spender The spender in the `approve()` call
222     /// @param _amount The amount in the `approve()` call
223     /// @return False if the controller does not authorize the approval
224     function onApprove(address _owner, address _spender, uint _amount) public
225         returns(bool);
226 }
227 
228 // File: minimetoken/contracts/MiniMeToken.sol
229 
230 /*
231     Copyright 2016, Jordi Baylina
232 
233     This program is free software: you can redistribute it and/or modify
234     it under the terms of the GNU General Public License as published by
235     the Free Software Foundation, either version 3 of the License, or
236     (at your option) any later version.
237 
238     This program is distributed in the hope that it will be useful,
239     but WITHOUT ANY WARRANTY; without even the implied warranty of
240     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
241     GNU General Public License for more details.
242 
243     You should have received a copy of the GNU General Public License
244     along with this program.  If not, see <http://www.gnu.org/licenses/>.
245  */
246 
247 /// @title MiniMeToken Contract
248 /// @author Jordi Baylina
249 /// @dev This token contract's goal is to make it easy for anyone to clone this
250 ///  token using the token distribution at a given block, this will allow DAO's
251 ///  and DApps to upgrade their features in a decentralized manner without
252 ///  affecting the original token
253 /// @dev It is ERC20 compliant, but still needs to under go further testing.
254 
255 
256 
257 
258 contract ApproveAndCallFallBack {
259     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
260 }
261 
262 /// @dev The actual token contract, the default controller is the msg.sender
263 ///  that deploys the contract, so usually this token will be deployed by a
264 ///  token controller contract, which Giveth will call a "Campaign"
265 contract MiniMeToken is Controlled {
266 
267     string public name;                //The Token's name: e.g. DigixDAO Tokens
268     uint8 public decimals;             //Number of decimals of the smallest unit
269     string public symbol;              //An identifier: e.g. REP
270     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
271 
272 
273     /// @dev `Checkpoint` is the structure that attaches a block number to a
274     ///  given value, the block number attached is the one that last changed the
275     ///  value
276     struct  Checkpoint {
277 
278         // `fromBlock` is the block number that the value was generated from
279         uint128 fromBlock;
280 
281         // `value` is the amount of tokens at a specific block number
282         uint128 value;
283     }
284 
285     // `parentToken` is the Token address that was cloned to produce this token;
286     //  it will be 0x0 for a token that was not cloned
287     MiniMeToken public parentToken;
288 
289     // `parentSnapShotBlock` is the block number from the Parent Token that was
290     //  used to determine the initial distribution of the Clone Token
291     uint public parentSnapShotBlock;
292 
293     // `creationBlock` is the block number that the Clone Token was created
294     uint public creationBlock;
295 
296     // `balances` is the map that tracks the balance of each address, in this
297     //  contract when the balance changes the block number that the change
298     //  occurred is also included in the map
299     mapping (address => Checkpoint[]) balances;
300 
301     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
302     mapping (address => mapping (address => uint256)) allowed;
303 
304     // Tracks the history of the `totalSupply` of the token
305     Checkpoint[] totalSupplyHistory;
306 
307     // Flag that determines if the token is transferable or not.
308     bool public transfersEnabled;
309 
310     // The factory used to create new clone tokens
311     MiniMeTokenFactory public tokenFactory;
312 
313 ////////////////
314 // Constructor
315 ////////////////
316 
317     /// @notice Constructor to create a MiniMeToken
318     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
319     ///  will create the Clone token contracts, the token factory needs to be
320     ///  deployed first
321     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
322     ///  new token
323     /// @param _parentSnapShotBlock Block of the parent token that will
324     ///  determine the initial distribution of the clone token, set to 0 if it
325     ///  is a new token
326     /// @param _tokenName Name of the new token
327     /// @param _decimalUnits Number of decimals of the new token
328     /// @param _tokenSymbol Token Symbol for the new token
329     /// @param _transfersEnabled If true, tokens will be able to be transferred
330     function MiniMeToken(
331         address _tokenFactory,
332         address _parentToken,
333         uint _parentSnapShotBlock,
334         string _tokenName,
335         uint8 _decimalUnits,
336         string _tokenSymbol,
337         bool _transfersEnabled
338     ) public {
339         tokenFactory = MiniMeTokenFactory(_tokenFactory);
340         name = _tokenName;                                 // Set the name
341         decimals = _decimalUnits;                          // Set the decimals
342         symbol = _tokenSymbol;                             // Set the symbol
343         parentToken = MiniMeToken(_parentToken);
344         parentSnapShotBlock = _parentSnapShotBlock;
345         transfersEnabled = _transfersEnabled;
346         creationBlock = block.number;
347     }
348 
349 
350 ///////////////////
351 // ERC20 Methods
352 ///////////////////
353 
354     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
355     /// @param _to The address of the recipient
356     /// @param _amount The amount of tokens to be transferred
357     /// @return Whether the transfer was successful or not
358     function transfer(address _to, uint256 _amount) public returns (bool success) {
359         require(transfersEnabled);
360         return doTransfer(msg.sender, _to, _amount);
361     }
362 
363     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
364     ///  is approved by `_from`
365     /// @param _from The address holding the tokens being transferred
366     /// @param _to The address of the recipient
367     /// @param _amount The amount of tokens to be transferred
368     /// @return True if the transfer was successful
369     function transferFrom(address _from, address _to, uint256 _amount
370     ) public returns (bool success) {
371 
372         // The controller of this contract can move tokens around at will,
373 
374         //  controller of this contract, which in most situations should be
375         //  another open source smart contract or 0x0
376         if (msg.sender != controller) {
377             require(transfersEnabled);
378 
379             // The standard ERC 20 transferFrom functionality
380             if (allowed[_from][msg.sender] < _amount) return false;
381             allowed[_from][msg.sender] -= _amount;
382         }
383         return doTransfer(_from, _to, _amount);
384     }
385 
386     /// @dev This is the actual transfer function in the token contract, it can
387     ///  only be called by other functions in this contract.
388     /// @param _from The address holding the tokens being transferred
389     /// @param _to The address of the recipient
390     /// @param _amount The amount of tokens to be transferred
391     /// @return True if the transfer was successful
392     function doTransfer(address _from, address _to, uint _amount
393     ) internal returns(bool) {
394 
395            if (_amount == 0) {
396                return true;
397            }
398 
399            require(parentSnapShotBlock < block.number);
400 
401            // Do not allow transfer to 0x0 or the token contract itself
402            require((_to != 0) && (_to != address(this)));
403 
404            // If the amount being transfered is more than the balance of the
405            //  account the transfer returns false
406            var previousBalanceFrom = balanceOfAt(_from, block.number);
407            if (previousBalanceFrom < _amount) {
408                return false;
409            }
410 
411            // Alerts the token controller of the transfer
412            if (isContract(controller)) {
413                require(TokenController(controller).onTransfer(_from, _to, _amount));
414            }
415 
416            // First update the balance array with the new value for the address
417            //  sending the tokens
418            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
419 
420            // Then update the balance array with the new value for the address
421            //  receiving the tokens
422            var previousBalanceTo = balanceOfAt(_to, block.number);
423            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
424            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
425 
426            // An event to make the transfer easy to find on the blockchain
427            Transfer(_from, _to, _amount);
428 
429            return true;
430     }
431 
432     /// @param _owner The address that's balance is being requested
433     /// @return The balance of `_owner` at the current block
434     function balanceOf(address _owner) public constant returns (uint256 balance) {
435         return balanceOfAt(_owner, block.number);
436     }
437 
438     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
439     ///  its behalf. This is a modified version of the ERC20 approve function
440     ///  to be a little bit safer
441     /// @param _spender The address of the account able to transfer the tokens
442     /// @param _amount The amount of tokens to be approved for transfer
443     /// @return True if the approval was successful
444     function approve(address _spender, uint256 _amount) public returns (bool success) {
445         require(transfersEnabled);
446 
447         // To change the approve amount you first have to reduce the addresses`
448         //  allowance to zero by calling `approve(_spender,0)` if it is not
449         //  already 0 to mitigate the race condition described here:
450         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
452 
453         // Alerts the token controller of the approve function call
454         if (isContract(controller)) {
455             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
456         }
457 
458         allowed[msg.sender][_spender] = _amount;
459         Approval(msg.sender, _spender, _amount);
460         return true;
461     }
462 
463     /// @dev This function makes it easy to read the `allowed[]` map
464     /// @param _owner The address of the account that owns the token
465     /// @param _spender The address of the account able to transfer the tokens
466     /// @return Amount of remaining tokens of _owner that _spender is allowed
467     ///  to spend
468     function allowance(address _owner, address _spender
469     ) public constant returns (uint256 remaining) {
470         return allowed[_owner][_spender];
471     }
472 
473     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
474     ///  its behalf, and then a function is triggered in the contract that is
475     ///  being approved, `_spender`. This allows users to use their tokens to
476     ///  interact with contracts in one function call instead of two
477     /// @param _spender The address of the contract able to transfer the tokens
478     /// @param _amount The amount of tokens to be approved for transfer
479     /// @return True if the function call was successful
480     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
481     ) public returns (bool success) {
482         require(approve(_spender, _amount));
483 
484         ApproveAndCallFallBack(_spender).receiveApproval(
485             msg.sender,
486             _amount,
487             this,
488             _extraData
489         );
490 
491         return true;
492     }
493 
494     /// @dev This function makes it easy to get the total number of tokens
495     /// @return The total number of tokens
496     function totalSupply() public constant returns (uint) {
497         return totalSupplyAt(block.number);
498     }
499 
500 
501 ////////////////
502 // Query balance and totalSupply in History
503 ////////////////
504 
505     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
506     /// @param _owner The address from which the balance will be retrieved
507     /// @param _blockNumber The block number when the balance is queried
508     /// @return The balance at `_blockNumber`
509     function balanceOfAt(address _owner, uint _blockNumber) public constant
510         returns (uint) {
511 
512         // These next few lines are used when the balance of the token is
513         //  requested before a check point was ever created for this token, it
514         //  requires that the `parentToken.balanceOfAt` be queried at the
515         //  genesis block for that token as this contains initial balance of
516         //  this token
517         if ((balances[_owner].length == 0)
518             || (balances[_owner][0].fromBlock > _blockNumber)) {
519             if (address(parentToken) != 0) {
520                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
521             } else {
522                 // Has no parent
523                 return 0;
524             }
525 
526         // This will return the expected balance during normal situations
527         } else {
528             return getValueAt(balances[_owner], _blockNumber);
529         }
530     }
531 
532     /// @notice Total amount of tokens at a specific `_blockNumber`.
533     /// @param _blockNumber The block number when the totalSupply is queried
534     /// @return The total amount of tokens at `_blockNumber`
535     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
536 
537         // These next few lines are used when the totalSupply of the token is
538         //  requested before a check point was ever created for this token, it
539         //  requires that the `parentToken.totalSupplyAt` be queried at the
540         //  genesis block for this token as that contains totalSupply of this
541         //  token at this block number.
542         if ((totalSupplyHistory.length == 0)
543             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
544             if (address(parentToken) != 0) {
545                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
546             } else {
547                 return 0;
548             }
549 
550         // This will return the expected totalSupply during normal situations
551         } else {
552             return getValueAt(totalSupplyHistory, _blockNumber);
553         }
554     }
555 
556 ////////////////
557 // Clone Token Method
558 ////////////////
559 
560     /// @notice Creates a new clone token with the initial distribution being
561     ///  this token at `_snapshotBlock`
562     /// @param _cloneTokenName Name of the clone token
563     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
564     /// @param _cloneTokenSymbol Symbol of the clone token
565     /// @param _snapshotBlock Block when the distribution of the parent token is
566     ///  copied to set the initial distribution of the new clone token;
567     ///  if the block is zero than the actual block, the current block is used
568     /// @param _transfersEnabled True if transfers are allowed in the clone
569     /// @return The address of the new MiniMeToken Contract
570     function createCloneToken(
571         string _cloneTokenName,
572         uint8 _cloneDecimalUnits,
573         string _cloneTokenSymbol,
574         uint _snapshotBlock,
575         bool _transfersEnabled
576         ) public returns(address) {
577         if (_snapshotBlock == 0) _snapshotBlock = block.number;
578         MiniMeToken cloneToken = tokenFactory.createCloneToken(
579             this,
580             _snapshotBlock,
581             _cloneTokenName,
582             _cloneDecimalUnits,
583             _cloneTokenSymbol,
584             _transfersEnabled
585             );
586 
587         cloneToken.changeController(msg.sender);
588 
589         // An event to make the token easy to find on the blockchain
590         NewCloneToken(address(cloneToken), _snapshotBlock);
591         return address(cloneToken);
592     }
593 
594 ////////////////
595 // Generate and destroy tokens
596 ////////////////
597 
598     /// @notice Generates `_amount` tokens that are assigned to `_owner`
599     /// @param _owner The address that will be assigned the new tokens
600     /// @param _amount The quantity of tokens generated
601     /// @return True if the tokens are generated correctly
602     function generateTokens(address _owner, uint _amount
603     ) public onlyController returns (bool) {
604         uint curTotalSupply = totalSupply();
605         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
606         uint previousBalanceTo = balanceOf(_owner);
607         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
608         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
609         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
610         Transfer(0, _owner, _amount);
611         return true;
612     }
613 
614 
615     /// @notice Burns `_amount` tokens from `_owner`
616     /// @param _owner The address that will lose the tokens
617     /// @param _amount The quantity of tokens to burn
618     /// @return True if the tokens are burned correctly
619     function destroyTokens(address _owner, uint _amount
620     ) onlyController public returns (bool) {
621         uint curTotalSupply = totalSupply();
622         require(curTotalSupply >= _amount);
623         uint previousBalanceFrom = balanceOf(_owner);
624         require(previousBalanceFrom >= _amount);
625         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
626         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
627         Transfer(_owner, 0, _amount);
628         return true;
629     }
630 
631 ////////////////
632 // Enable tokens transfers
633 ////////////////
634 
635 
636     /// @notice Enables token holders to transfer their tokens freely if true
637     /// @param _transfersEnabled True if transfers are allowed in the clone
638     function enableTransfers(bool _transfersEnabled) public onlyController {
639         transfersEnabled = _transfersEnabled;
640     }
641 
642 ////////////////
643 // Internal helper functions to query and set a value in a snapshot array
644 ////////////////
645 
646     /// @dev `getValueAt` retrieves the number of tokens at a given block number
647     /// @param checkpoints The history of values being queried
648     /// @param _block The block number to retrieve the value at
649     /// @return The number of tokens being queried
650     function getValueAt(Checkpoint[] storage checkpoints, uint _block
651     ) constant internal returns (uint) {
652         if (checkpoints.length == 0) return 0;
653 
654         // Shortcut for the actual value
655         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
656             return checkpoints[checkpoints.length-1].value;
657         if (_block < checkpoints[0].fromBlock) return 0;
658 
659         // Binary search of the value in the array
660         uint min = 0;
661         uint max = checkpoints.length-1;
662         while (max > min) {
663             uint mid = (max + min + 1)/ 2;
664             if (checkpoints[mid].fromBlock<=_block) {
665                 min = mid;
666             } else {
667                 max = mid-1;
668             }
669         }
670         return checkpoints[min].value;
671     }
672 
673     /// @dev `updateValueAtNow` used to update the `balances` map and the
674     ///  `totalSupplyHistory`
675     /// @param checkpoints The history of data being updated
676     /// @param _value The new number of tokens
677     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
678     ) internal  {
679         if ((checkpoints.length == 0)
680         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
681                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
682                newCheckPoint.fromBlock =  uint128(block.number);
683                newCheckPoint.value = uint128(_value);
684            } else {
685                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
686                oldCheckPoint.value = uint128(_value);
687            }
688     }
689 
690     /// @dev Internal function to determine if an address is a contract
691     /// @param _addr The address being queried
692     /// @return True if `_addr` is a contract
693     function isContract(address _addr) constant internal returns(bool) {
694         uint size;
695         if (_addr == 0) return false;
696         assembly {
697             size := extcodesize(_addr)
698         }
699         return size>0;
700     }
701 
702     /// @dev Helper function to return a min betwen the two uints
703     function min(uint a, uint b) pure internal returns (uint) {
704         return a < b ? a : b;
705     }
706 
707     /// @notice The fallback function: If the contract's controller has not been
708     ///  set to 0, then the `proxyPayment` method is called which relays the
709     ///  ether and creates tokens as described in the token controller contract
710     function () public payable {
711         require(isContract(controller));
712         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
713     }
714 
715 //////////
716 // Safety Methods
717 //////////
718 
719     /// @notice This method can be used by the controller to extract mistakenly
720     ///  sent tokens to this contract.
721     /// @param _token The address of the token contract that you want to recover
722     ///  set to 0 in case you want to extract ether.
723     function claimTokens(address _token) public onlyController {
724         if (_token == 0x0) {
725             controller.transfer(this.balance);
726             return;
727         }
728 
729         MiniMeToken token = MiniMeToken(_token);
730         uint balance = token.balanceOf(this);
731         token.transfer(controller, balance);
732         ClaimedTokens(_token, controller, balance);
733     }
734 
735 ////////////////
736 // Events
737 ////////////////
738     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
739     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
740     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
741     event Approval(
742         address indexed _owner,
743         address indexed _spender,
744         uint256 _amount
745         );
746 
747 }
748 
749 
750 ////////////////
751 // MiniMeTokenFactory
752 ////////////////
753 
754 /// @dev This contract is used to generate clone contracts from a contract.
755 ///  In solidity this is the way to create a contract from a contract of the
756 ///  same class
757 contract MiniMeTokenFactory {
758 
759     /// @notice Update the DApp by creating a new token with new functionalities
760     ///  the msg.sender becomes the controller of this clone token
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
787         newToken.changeController(msg.sender);
788         return newToken;
789     }
790 }
791 
792 // File: contracts/Bounty0xToken.sol
793 
794 contract Bounty0xToken is MiniMeToken {
795     function Bounty0xToken(address _tokenFactory)
796         MiniMeToken(
797             _tokenFactory,
798             0x0,                        // no parent token
799             0,                          // no snapshot block number from parent
800             "Bounty0x Token",           // Token name
801             18   ,                      // Decimals
802             "BNTY",                     // Symbol
803             false                       // Disable transfers
804         )
805         public
806     {
807     }
808 
809     // generate tokens for many addresses with a single transaction
810     function generateTokensAll(address[] _owners, uint[] _amounts) onlyController public {
811         require(_owners.length == _amounts.length);
812 
813         for (uint i = 0; i < _owners.length; i++) {
814             require(generateTokens(_owners[i], _amounts[i]));
815         }
816     }
817 }
818 
819 // File: contracts/KnowsConstants.sol
820 
821 // These are the specifications of the contract, unlikely to change
822 contract KnowsConstants {
823     // The fixed USD price per BNTY
824     uint public constant FIXED_PRESALE_USD_ETHER_PRICE = 355;
825     uint public constant MICRO_DOLLARS_PER_BNTY_MAINSALE = 16500;
826     uint public constant MICRO_DOLLARS_PER_BNTY_PRESALE = 13200;
827 
828     // Contribution constants
829     uint public constant HARD_CAP_USD = 1500000;                           // in USD the maximum total collected amount
830     uint public constant MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD = 1500; // in USD the maximum contribution amount during the whitelist period
831     uint public constant MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD = 10000;  // in USD the maximum contribution amount after the whitelist period ends
832     uint public constant MAX_GAS_PRICE = 70 * (10 ** 9);                   // Max gas price of 70 gwei
833     uint public constant MAX_GAS = 500000;                                 // Max gas that can be sent with tx
834 
835     // Time constants
836     uint public constant SALE_START_DATE = 1513346400;                    // in unix timestamp Dec 15th @ 15:00 CET
837     uint public constant WHITELIST_END_DATE = SALE_START_DATE + 24 hours; // End whitelist 24 hours after sale start date/time
838     uint public constant LIMITS_END_DATE = SALE_START_DATE + 48 hours;    // End all limits 48 hours after the sale start date
839     uint public constant SALE_END_DATE = SALE_START_DATE + 4 weeks;       // end sale in four weeks
840     uint public constant UNFREEZE_DATE = SALE_START_DATE + 76 weeks;      // Bounty0x Reserve locked for 18 months
841 
842     function KnowsConstants() public {}
843 }
844 
845 // File: contracts/interfaces/Bounty0xPresaleI.sol
846 
847 /**
848  * This interface describes the only function we will be calling from the Bounty0xPresaleI contract
849  */
850 interface Bounty0xPresaleI {
851     function balanceOf(address addr) public returns (uint balance);
852 }
853 
854 // File: zeppelin-solidity/contracts/math/Math.sol
855 
856 /**
857  * @title Math
858  * @dev Assorted math operations
859  */
860 
861 library Math {
862   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
863     return a >= b ? a : b;
864   }
865 
866   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
867     return a < b ? a : b;
868   }
869 
870   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
871     return a >= b ? a : b;
872   }
873 
874   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
875     return a < b ? a : b;
876   }
877 }
878 
879 // File: contracts/Bounty0xPresaleDistributor.sol
880 
881 /*
882 This contract manages compensation of the presale investors, based on the contribution balances recorded in the presale
883 contract.
884 */
885 contract Bounty0xPresaleDistributor is KnowsConstants, BntyExchangeRateCalculator {
886     using SafeMath for uint;
887 
888     Bounty0xPresaleI public deployedPresaleContract;
889     Bounty0xToken public bounty0xToken;
890 
891     mapping(address => uint) public tokensPaid;
892 
893     function Bounty0xPresaleDistributor(Bounty0xToken _bounty0xToken, Bounty0xPresaleI _deployedPresaleContract)
894         BntyExchangeRateCalculator(MICRO_DOLLARS_PER_BNTY_PRESALE, FIXED_PRESALE_USD_ETHER_PRICE, 0)
895         public
896     {
897         bounty0xToken = _bounty0xToken;
898         deployedPresaleContract = _deployedPresaleContract;
899     }
900 
901     event OnPreSaleBuyerCompensated(address indexed contributor, uint numTokens);
902 
903     /**
904      * Compensate the presale investors at the addresses provider based on their contributions during the presale
905      */
906     function compensatePreSaleInvestors(address[] preSaleInvestors) public {
907         // iterate through each investor
908         for (uint i = 0; i < preSaleInvestors.length; i++) {
909             address investorAddress = preSaleInvestors[i];
910 
911             // the deployed presale contract tracked the balance of each contributor
912             uint weiContributed = deployedPresaleContract.balanceOf(investorAddress);
913 
914             // they contributed and haven't been paid
915             if (weiContributed > 0 && tokensPaid[investorAddress] == 0) {
916                 // convert the amount of wei they contributed to the bnty
917                 uint bntyCompensation = Math.min256(weiToBnty(weiContributed), bounty0xToken.balanceOf(this));
918 
919                 // mark them paid first
920                 tokensPaid[investorAddress] = bntyCompensation;
921 
922                 // transfer tokens to presale contributor address
923                 require(bounty0xToken.transfer(investorAddress, bntyCompensation));
924 
925                 // log the event
926                 OnPreSaleBuyerCompensated(investorAddress, bntyCompensation);
927             }
928         }
929     }
930 }
931 
932 // File: contracts/Bounty0xReserveHolder.sol
933 
934 /**
935  * @title Bounty0xReserveHolder
936  * @dev Bounty0xReserveHolder is a token holder contract that will allow a
937  * beneficiary to extract the tokens after a given release time
938  */
939 contract Bounty0xReserveHolder is KnowsConstants, KnowsTime {
940     // Bounty0xToken address
941     Bounty0xToken public token;
942 
943     // beneficiary of tokens after they are released
944     address public beneficiary;
945 
946     function Bounty0xReserveHolder(Bounty0xToken _token, address _beneficiary) public {
947         require(_token != address(0));
948         require(_beneficiary != address(0));
949 
950         token = _token;
951         beneficiary = _beneficiary;
952     }
953 
954     /**
955      * @notice Transfers tokens held by timelock to beneficiary.
956      */
957     function release() public {
958         require(currentTime() >= UNFREEZE_DATE);
959 
960         uint amount = token.balanceOf(this);
961         require(amount > 0);
962 
963         require(token.transfer(beneficiary, amount));
964     }
965 }
966 
967 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
968 
969 /**
970  * @title Pausable
971  * @dev Base contract which allows children to implement an emergency stop mechanism.
972  */
973 contract Pausable is Ownable {
974   event Pause();
975   event Unpause();
976 
977   bool public paused = false;
978 
979 
980   /**
981    * @dev Modifier to make a function callable only when the contract is not paused.
982    */
983   modifier whenNotPaused() {
984     require(!paused);
985     _;
986   }
987 
988   /**
989    * @dev Modifier to make a function callable only when the contract is paused.
990    */
991   modifier whenPaused() {
992     require(paused);
993     _;
994   }
995 
996   /**
997    * @dev called by the owner to pause, triggers stopped state
998    */
999   function pause() onlyOwner whenNotPaused public {
1000     paused = true;
1001     Pause();
1002   }
1003 
1004   /**
1005    * @dev called by the owner to unpause, returns to normal state
1006    */
1007   function unpause() onlyOwner whenPaused public {
1008     paused = false;
1009     Unpause();
1010   }
1011 }
1012 
1013 // File: contracts/Bounty0xCrowdsale.sol
1014 
1015 contract Bounty0xCrowdsale is KnowsTime, KnowsConstants, Ownable, BntyExchangeRateCalculator, AddressWhitelist, Pausable {
1016     using SafeMath for uint;
1017 
1018     // Crowdsale contracts
1019     Bounty0xToken public bounty0xToken;                                 // Reward tokens to compensate in
1020 
1021     // Contribution amounts
1022     mapping (address => uint) public contributionAmounts;            // The amount that each address has contributed
1023     uint public totalContributions;                                  // Total contributions given
1024 
1025     // Events
1026     event OnContribution(address indexed contributor, bool indexed duringWhitelistPeriod, uint indexed contributedWei, uint bntyAwarded, uint refundedWei);
1027     event OnWithdraw(address to, uint amount);
1028 
1029     function Bounty0xCrowdsale(Bounty0xToken _bounty0xToken, uint _USDEtherPrice)
1030         BntyExchangeRateCalculator(MICRO_DOLLARS_PER_BNTY_MAINSALE, _USDEtherPrice, SALE_START_DATE)
1031         public
1032     {
1033         bounty0xToken = _bounty0xToken;
1034     }
1035 
1036     // the crowdsale owner may withdraw any amount of ether from this contract at any time
1037     function withdraw(uint amount) public onlyOwner {
1038         msg.sender.transfer(amount);
1039         OnWithdraw(msg.sender, amount);
1040     }
1041 
1042     // All contributions come through the fallback function
1043     function () payable public whenNotPaused {
1044         uint time = currentTime();
1045 
1046         // require the sale has started
1047         require(time >= SALE_START_DATE);
1048 
1049         // require that the sale has not ended
1050         require(time < SALE_END_DATE);
1051 
1052         // maximum contribution from this transaction is tracked in this variable
1053         uint maximumContribution = usdToWei(HARD_CAP_USD).sub(totalContributions);
1054 
1055         // store whether the contribution is made during the whitelist period
1056         bool isDuringWhitelistPeriod = time < WHITELIST_END_DATE;
1057 
1058         // these limits are only checked during the limited period
1059         if (time < LIMITS_END_DATE) {
1060             // require that they have not overpaid their gas price
1061             require(tx.gasprice <= MAX_GAS_PRICE);
1062 
1063             // require that they haven't sent too much gas
1064             require(msg.gas <= MAX_GAS);
1065 
1066             // if we are in the WHITELIST period, we need to make sure the sender contributed to the presale
1067             if (isDuringWhitelistPeriod) {
1068                 require(isWhitelisted(msg.sender));
1069 
1070                 // the maximum contribution is set for the whitelist period
1071                 maximumContribution = Math.min256(
1072                     maximumContribution,
1073                     usdToWei(MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD).sub(contributionAmounts[msg.sender])
1074                 );
1075             } else {
1076                 // the maximum contribution is set for the limited period
1077                 maximumContribution = Math.min256(
1078                     maximumContribution,
1079                     usdToWei(MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD).sub(contributionAmounts[msg.sender])
1080                 );
1081             }
1082         }
1083 
1084         // calculate how much contribution is accepted and how much is refunded
1085         uint contribution = Math.min256(msg.value, maximumContribution);
1086         uint refundWei = msg.value.sub(contribution);
1087 
1088         // require that they are allowed to contribute more
1089         require(contribution > 0);
1090 
1091         // account contribution towards total
1092         totalContributions = totalContributions.add(contribution);
1093 
1094         // account contribution towards address total
1095         contributionAmounts[msg.sender] = contributionAmounts[msg.sender].add(contribution);
1096 
1097         // and send them some bnty
1098         uint amountBntyRewarded = Math.min256(weiToBnty(contribution), bounty0xToken.balanceOf(this));
1099         require(bounty0xToken.transfer(msg.sender, amountBntyRewarded));
1100 
1101         if (refundWei > 0) {
1102             msg.sender.transfer(refundWei);
1103         }
1104 
1105         // log the contribution
1106         OnContribution(msg.sender, isDuringWhitelistPeriod, contribution, amountBntyRewarded, refundWei);
1107     }
1108 }
1109 
1110 // File: contracts/CrowdsaleTokenController.sol
1111 
1112 contract CrowdsaleTokenController is Ownable, AddressWhitelist, TokenController {
1113     bool public whitelistOff;
1114     Bounty0xToken public token;
1115 
1116     function CrowdsaleTokenController(Bounty0xToken _token) public {
1117         token = _token;
1118     }
1119 
1120     // set the whitelistOff variable
1121     function setWhitelistOff(bool _whitelistOff) public onlyOwner {
1122         whitelistOff = _whitelistOff;
1123     }
1124 
1125     // the owner of the controller can change the controller to a new contract
1126     function changeController(address newController) public onlyOwner {
1127         token.changeController(newController);
1128     }
1129 
1130     // change whether transfers are enabled
1131     function enableTransfers(bool _transfersEnabled) public onlyOwner {
1132         token.enableTransfers(_transfersEnabled);
1133     }
1134 
1135     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1136     /// @param _owner The address that sent the ether to create tokens
1137     /// @return True if the ether is accepted, false if it throws
1138     function proxyPayment(address _owner) public payable returns (bool) {
1139         return false;
1140     }
1141 
1142     /// @notice Notifies the controller about a token transfer allowing the
1143     ///  controller to react if desired
1144     /// @param _from The origin of the transfer
1145     /// @param _to The destination of the transfer
1146     /// @param _amount The amount of the transfer
1147     /// @return False if the controller does not authorize the transfer
1148     function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
1149         return whitelistOff || isWhitelisted(_from);
1150     }
1151 
1152     /// @notice Notifies the controller about an approval allowing the
1153     ///  controller to react if desired
1154     /// @param _owner The address that calls `approve()`
1155     /// @param _spender The spender in the `approve()` call
1156     /// @param _amount The amount in the `approve()` call
1157     /// @return False if the controller does not authorize the approval
1158     function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
1159         return whitelistOff || isWhitelisted(_owner);
1160     }
1161 }