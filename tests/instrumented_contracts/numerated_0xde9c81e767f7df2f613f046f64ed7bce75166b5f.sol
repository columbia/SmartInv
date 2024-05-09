1 pragma solidity ^0.4.18;
2 
3 // File: contracts/KnowsConstants.sol
4 
5 // These are the specifications of the contract, unlikely to change
6 contract KnowsConstants {
7     // The fixed USD price per BNTY
8     uint public constant FIXED_PRESALE_USD_ETHER_PRICE = 355;
9     uint public constant MICRO_DOLLARS_PER_BNTY_MAINSALE = 16500;
10     uint public constant MICRO_DOLLARS_PER_BNTY_PRESALE = 13200;
11 
12     // Contribution constants
13     uint public constant HARD_CAP_USD = 1500000;                           // in USD the maximum total collected amount
14     uint public constant MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD = 1500; // in USD the maximum contribution amount during the whitelist period
15     uint public constant MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD = 10000;  // in USD the maximum contribution amount after the whitelist period ends
16     uint public constant MAX_GAS_PRICE = 70 * (10 ** 9);                   // Max gas price of 70 gwei
17     uint public constant MAX_GAS = 500000;                                 // Max gas that can be sent with tx
18 
19     // Time constants
20     uint public constant SALE_START_DATE = 1513346400;                    // in unix timestamp Dec 15th @ 15:00 CET
21     uint public constant WHITELIST_END_DATE = SALE_START_DATE + 24 hours; // End whitelist 24 hours after sale start date/time
22     uint public constant LIMITS_END_DATE = SALE_START_DATE + 48 hours;    // End all limits 48 hours after the sale start date
23     uint public constant SALE_END_DATE = SALE_START_DATE + 4 weeks;       // end sale in four weeks
24     uint public constant UNFREEZE_DATE = SALE_START_DATE + 76 weeks;      // Bounty0x Reserve locked for 18 months
25 
26     function KnowsConstants() public {}
27 }
28 
29 // File: zeppelin-solidity/contracts/math/SafeMath.sol
30 
31 /**
32  * @title SafeMath
33  * @dev Math operations with safety checks that throw on error
34  */
35 library SafeMath {
36   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37     if (a == 0) {
38       return 0;
39     }
40     uint256 c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     // assert(b > 0); // Solidity automatically throws when dividing by 0
47     uint256 c = a / b;
48     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
49     return c;
50   }
51 
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     assert(c >= a);
60     return c;
61   }
62 }
63 
64 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
65 
66 /**
67  * @title Ownable
68  * @dev The Ownable contract has an owner address, and provides basic authorization control
69  * functions, this simplifies the implementation of "user permissions".
70  */
71 contract Ownable {
72   address public owner;
73 
74 
75   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77 
78   /**
79    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
80    * account.
81    */
82   function Ownable() public {
83     owner = msg.sender;
84   }
85 
86 
87   /**
88    * @dev Throws if called by any account other than the owner.
89    */
90   modifier onlyOwner() {
91     require(msg.sender == owner);
92     _;
93   }
94 
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 
106 }
107 
108 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
109 
110 /**
111  * @title ERC20Basic
112  * @dev Simpler version of ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/179
114  */
115 contract ERC20Basic {
116   uint256 public totalSupply;
117   function balanceOf(address who) public view returns (uint256);
118   function transfer(address to, uint256 value) public returns (bool);
119   event Transfer(address indexed from, address indexed to, uint256 value);
120 }
121 
122 // File: zeppelin-solidity/contracts/token/ERC20.sol
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public view returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 // File: zeppelin-solidity/contracts/token/SafeERC20.sol
136 
137 /**
138  * @title SafeERC20
139  * @dev Wrappers around ERC20 operations that throw on failure.
140  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
141  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
142  */
143 library SafeERC20 {
144   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
145     assert(token.transfer(to, value));
146   }
147 
148   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
149     assert(token.transferFrom(from, to, value));
150   }
151 
152   function safeApprove(ERC20 token, address spender, uint256 value) internal {
153     assert(token.approve(spender, value));
154   }
155 }
156 
157 // File: zeppelin-solidity/contracts/token/TokenVesting.sol
158 
159 /**
160  * @title TokenVesting
161  * @dev A token holder contract that can release its token balance gradually like a
162  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
163  * owner.
164  */
165 contract TokenVesting is Ownable {
166   using SafeMath for uint256;
167   using SafeERC20 for ERC20Basic;
168 
169   event Released(uint256 amount);
170   event Revoked();
171 
172   // beneficiary of tokens after they are released
173   address public beneficiary;
174 
175   uint256 public cliff;
176   uint256 public start;
177   uint256 public duration;
178 
179   bool public revocable;
180 
181   mapping (address => uint256) public released;
182   mapping (address => bool) public revoked;
183 
184   /**
185    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
186    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
187    * of the balance will have vested.
188    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
189    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
190    * @param _duration duration in seconds of the period in which the tokens will vest
191    * @param _revocable whether the vesting is revocable or not
192    */
193   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
194     require(_beneficiary != address(0));
195     require(_cliff <= _duration);
196 
197     beneficiary = _beneficiary;
198     revocable = _revocable;
199     duration = _duration;
200     cliff = _start.add(_cliff);
201     start = _start;
202   }
203 
204   /**
205    * @notice Transfers vested tokens to beneficiary.
206    * @param token ERC20 token which is being vested
207    */
208   function release(ERC20Basic token) public {
209     uint256 unreleased = releasableAmount(token);
210 
211     require(unreleased > 0);
212 
213     released[token] = released[token].add(unreleased);
214 
215     token.safeTransfer(beneficiary, unreleased);
216 
217     Released(unreleased);
218   }
219 
220   /**
221    * @notice Allows the owner to revoke the vesting. Tokens already vested
222    * remain in the contract, the rest are returned to the owner.
223    * @param token ERC20 token which is being vested
224    */
225   function revoke(ERC20Basic token) public onlyOwner {
226     require(revocable);
227     require(!revoked[token]);
228 
229     uint256 balance = token.balanceOf(this);
230 
231     uint256 unreleased = releasableAmount(token);
232     uint256 refund = balance.sub(unreleased);
233 
234     revoked[token] = true;
235 
236     token.safeTransfer(owner, refund);
237 
238     Revoked();
239   }
240 
241   /**
242    * @dev Calculates the amount that has already vested but hasn't been released yet.
243    * @param token ERC20 token which is being vested
244    */
245   function releasableAmount(ERC20Basic token) public view returns (uint256) {
246     return vestedAmount(token).sub(released[token]);
247   }
248 
249   /**
250    * @dev Calculates the amount that has already vested.
251    * @param token ERC20 token which is being vested
252    */
253   function vestedAmount(ERC20Basic token) public view returns (uint256) {
254     uint256 currentBalance = token.balanceOf(this);
255     uint256 totalBalance = currentBalance.add(released[token]);
256 
257     if (now < cliff) {
258       return 0;
259     } else if (now >= start.add(duration) || revoked[token]) {
260       return totalBalance;
261     } else {
262       return totalBalance.mul(now.sub(start)).div(duration);
263     }
264   }
265 }
266 
267 // File: contracts/Bounty0xTokenVesting.sol
268 
269 contract Bounty0xTokenVesting is KnowsConstants, TokenVesting {
270     function Bounty0xTokenVesting(address _beneficiary, uint durationWeeks)
271         TokenVesting(_beneficiary, WHITELIST_END_DATE, 0, durationWeeks * 1 weeks, false)
272         public
273     {
274     }
275 }
276 
277 // File: contracts/AddressWhitelist.sol
278 
279 // A simple contract that stores a whitelist of addresses, which the owner may update
280 contract AddressWhitelist is Ownable {
281     // the addresses that are included in the whitelist
282     mapping (address => bool) public whitelisted;
283 
284     function AddressWhitelist() public {
285     }
286 
287     function isWhitelisted(address addr) view public returns (bool) {
288         return whitelisted[addr];
289     }
290 
291     event LogWhitelistAdd(address indexed addr);
292 
293     // add these addresses to the whitelist
294     function addToWhitelist(address[] addresses) public onlyOwner returns (bool) {
295         for (uint i = 0; i < addresses.length; i++) {
296             if (!whitelisted[addresses[i]]) {
297                 whitelisted[addresses[i]] = true;
298                 LogWhitelistAdd(addresses[i]);
299             }
300         }
301 
302         return true;
303     }
304 
305     event LogWhitelistRemove(address indexed addr);
306 
307     // remove these addresses from the whitelist
308     function removeFromWhitelist(address[] addresses) public onlyOwner returns (bool) {
309         for (uint i = 0; i < addresses.length; i++) {
310             if (whitelisted[addresses[i]]) {
311                 whitelisted[addresses[i]] = false;
312                 LogWhitelistRemove(addresses[i]);
313             }
314         }
315 
316         return true;
317     }
318 }
319 
320 // File: contracts/KnowsTime.sol
321 
322 contract KnowsTime {
323     function KnowsTime() public {
324     }
325 
326     function currentTime() public view returns (uint) {
327         return now;
328     }
329 }
330 
331 // File: contracts/BntyExchangeRateCalculator.sol
332 
333 // This contract does the math to figure out the BNTY paid per WEI, based on the USD ether price
334 contract BntyExchangeRateCalculator is KnowsTime, Ownable {
335     using SafeMath for uint;
336 
337     uint public constant WEI_PER_ETH = 10 ** 18;
338 
339     uint public constant MICRODOLLARS_PER_DOLLAR = 10 ** 6;
340 
341     uint public bntyMicrodollarPrice;
342 
343     uint public USDEtherPrice;
344 
345     uint public fixUSDPriceTime;
346 
347     // a microdollar is one millionth of a dollar, or one ten-thousandth of a cent
348     function BntyExchangeRateCalculator(uint _bntyMicrodollarPrice, uint _USDEtherPrice, uint _fixUSDPriceTime)
349         public
350     {
351         require(_bntyMicrodollarPrice > 0);
352         require(_USDEtherPrice > 0);
353 
354         bntyMicrodollarPrice = _bntyMicrodollarPrice;
355         fixUSDPriceTime = _fixUSDPriceTime;
356         USDEtherPrice = _USDEtherPrice;
357     }
358 
359     // the owner can change the usd ether price
360     function setUSDEtherPrice(uint _USDEtherPrice) onlyOwner public {
361         require(currentTime() < fixUSDPriceTime);
362         require(_USDEtherPrice > 0);
363 
364         USDEtherPrice = _USDEtherPrice;
365     }
366 
367     // returns the number of wei some amount of usd
368     function usdToWei(uint usd) view public returns (uint) {
369         return WEI_PER_ETH.mul(usd).div(USDEtherPrice);
370     }
371 
372     // returns the number of bnty per some amount in wei
373     function weiToBnty(uint amtWei) view public returns (uint) {
374         return USDEtherPrice.mul(MICRODOLLARS_PER_DOLLAR).mul(amtWei).div(bntyMicrodollarPrice);
375     }
376 }
377 
378 // File: minimetoken/contracts/Controlled.sol
379 
380 contract Controlled {
381     /// @notice The address of the controller is the only address that can call
382     ///  a function with this modifier
383     modifier onlyController { require(msg.sender == controller); _; }
384 
385     address public controller;
386 
387     function Controlled() public { controller = msg.sender;}
388 
389     /// @notice Changes the controller of the contract
390     /// @param _newController The new controller of the contract
391     function changeController(address _newController) public onlyController {
392         controller = _newController;
393     }
394 }
395 
396 // File: minimetoken/contracts/TokenController.sol
397 
398 /// @dev The token controller contract must implement these functions
399 contract TokenController {
400     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
401     /// @param _owner The address that sent the ether to create tokens
402     /// @return True if the ether is accepted, false if it throws
403     function proxyPayment(address _owner) public payable returns(bool);
404 
405     /// @notice Notifies the controller about a token transfer allowing the
406     ///  controller to react if desired
407     /// @param _from The origin of the transfer
408     /// @param _to The destination of the transfer
409     /// @param _amount The amount of the transfer
410     /// @return False if the controller does not authorize the transfer
411     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
412 
413     /// @notice Notifies the controller about an approval allowing the
414     ///  controller to react if desired
415     /// @param _owner The address that calls `approve()`
416     /// @param _spender The spender in the `approve()` call
417     /// @param _amount The amount in the `approve()` call
418     /// @return False if the controller does not authorize the approval
419     function onApprove(address _owner, address _spender, uint _amount) public
420         returns(bool);
421 }
422 
423 // File: minimetoken/contracts/MiniMeToken.sol
424 
425 /*
426     Copyright 2016, Jordi Baylina
427 
428     This program is free software: you can redistribute it and/or modify
429     it under the terms of the GNU General Public License as published by
430     the Free Software Foundation, either version 3 of the License, or
431     (at your option) any later version.
432 
433     This program is distributed in the hope that it will be useful,
434     but WITHOUT ANY WARRANTY; without even the implied warranty of
435     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
436     GNU General Public License for more details.
437 
438     You should have received a copy of the GNU General Public License
439     along with this program.  If not, see <http://www.gnu.org/licenses/>.
440  */
441 
442 /// @title MiniMeToken Contract
443 /// @author Jordi Baylina
444 /// @dev This token contract's goal is to make it easy for anyone to clone this
445 ///  token using the token distribution at a given block, this will allow DAO's
446 ///  and DApps to upgrade their features in a decentralized manner without
447 ///  affecting the original token
448 /// @dev It is ERC20 compliant, but still needs to under go further testing.
449 
450 
451 
452 
453 contract ApproveAndCallFallBack {
454     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
455 }
456 
457 /// @dev The actual token contract, the default controller is the msg.sender
458 ///  that deploys the contract, so usually this token will be deployed by a
459 ///  token controller contract, which Giveth will call a "Campaign"
460 contract MiniMeToken is Controlled {
461 
462     string public name;                //The Token's name: e.g. DigixDAO Tokens
463     uint8 public decimals;             //Number of decimals of the smallest unit
464     string public symbol;              //An identifier: e.g. REP
465     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
466 
467 
468     /// @dev `Checkpoint` is the structure that attaches a block number to a
469     ///  given value, the block number attached is the one that last changed the
470     ///  value
471     struct  Checkpoint {
472 
473         // `fromBlock` is the block number that the value was generated from
474         uint128 fromBlock;
475 
476         // `value` is the amount of tokens at a specific block number
477         uint128 value;
478     }
479 
480     // `parentToken` is the Token address that was cloned to produce this token;
481     //  it will be 0x0 for a token that was not cloned
482     MiniMeToken public parentToken;
483 
484     // `parentSnapShotBlock` is the block number from the Parent Token that was
485     //  used to determine the initial distribution of the Clone Token
486     uint public parentSnapShotBlock;
487 
488     // `creationBlock` is the block number that the Clone Token was created
489     uint public creationBlock;
490 
491     // `balances` is the map that tracks the balance of each address, in this
492     //  contract when the balance changes the block number that the change
493     //  occurred is also included in the map
494     mapping (address => Checkpoint[]) balances;
495 
496     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
497     mapping (address => mapping (address => uint256)) allowed;
498 
499     // Tracks the history of the `totalSupply` of the token
500     Checkpoint[] totalSupplyHistory;
501 
502     // Flag that determines if the token is transferable or not.
503     bool public transfersEnabled;
504 
505     // The factory used to create new clone tokens
506     MiniMeTokenFactory public tokenFactory;
507 
508 ////////////////
509 // Constructor
510 ////////////////
511 
512     /// @notice Constructor to create a MiniMeToken
513     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
514     ///  will create the Clone token contracts, the token factory needs to be
515     ///  deployed first
516     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
517     ///  new token
518     /// @param _parentSnapShotBlock Block of the parent token that will
519     ///  determine the initial distribution of the clone token, set to 0 if it
520     ///  is a new token
521     /// @param _tokenName Name of the new token
522     /// @param _decimalUnits Number of decimals of the new token
523     /// @param _tokenSymbol Token Symbol for the new token
524     /// @param _transfersEnabled If true, tokens will be able to be transferred
525     function MiniMeToken(
526         address _tokenFactory,
527         address _parentToken,
528         uint _parentSnapShotBlock,
529         string _tokenName,
530         uint8 _decimalUnits,
531         string _tokenSymbol,
532         bool _transfersEnabled
533     ) public {
534         tokenFactory = MiniMeTokenFactory(_tokenFactory);
535         name = _tokenName;                                 // Set the name
536         decimals = _decimalUnits;                          // Set the decimals
537         symbol = _tokenSymbol;                             // Set the symbol
538         parentToken = MiniMeToken(_parentToken);
539         parentSnapShotBlock = _parentSnapShotBlock;
540         transfersEnabled = _transfersEnabled;
541         creationBlock = block.number;
542     }
543 
544 
545 ///////////////////
546 // ERC20 Methods
547 ///////////////////
548 
549     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
550     /// @param _to The address of the recipient
551     /// @param _amount The amount of tokens to be transferred
552     /// @return Whether the transfer was successful or not
553     function transfer(address _to, uint256 _amount) public returns (bool success) {
554         require(transfersEnabled);
555         return doTransfer(msg.sender, _to, _amount);
556     }
557 
558     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
559     ///  is approved by `_from`
560     /// @param _from The address holding the tokens being transferred
561     /// @param _to The address of the recipient
562     /// @param _amount The amount of tokens to be transferred
563     /// @return True if the transfer was successful
564     function transferFrom(address _from, address _to, uint256 _amount
565     ) public returns (bool success) {
566 
567         // The controller of this contract can move tokens around at will,
568 
569         //  controller of this contract, which in most situations should be
570         //  another open source smart contract or 0x0
571         if (msg.sender != controller) {
572             require(transfersEnabled);
573 
574             // The standard ERC 20 transferFrom functionality
575             if (allowed[_from][msg.sender] < _amount) return false;
576             allowed[_from][msg.sender] -= _amount;
577         }
578         return doTransfer(_from, _to, _amount);
579     }
580 
581     /// @dev This is the actual transfer function in the token contract, it can
582     ///  only be called by other functions in this contract.
583     /// @param _from The address holding the tokens being transferred
584     /// @param _to The address of the recipient
585     /// @param _amount The amount of tokens to be transferred
586     /// @return True if the transfer was successful
587     function doTransfer(address _from, address _to, uint _amount
588     ) internal returns(bool) {
589 
590            if (_amount == 0) {
591                return true;
592            }
593 
594            require(parentSnapShotBlock < block.number);
595 
596            // Do not allow transfer to 0x0 or the token contract itself
597            require((_to != 0) && (_to != address(this)));
598 
599            // If the amount being transfered is more than the balance of the
600            //  account the transfer returns false
601            var previousBalanceFrom = balanceOfAt(_from, block.number);
602            if (previousBalanceFrom < _amount) {
603                return false;
604            }
605 
606            // Alerts the token controller of the transfer
607            if (isContract(controller)) {
608                require(TokenController(controller).onTransfer(_from, _to, _amount));
609            }
610 
611            // First update the balance array with the new value for the address
612            //  sending the tokens
613            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
614 
615            // Then update the balance array with the new value for the address
616            //  receiving the tokens
617            var previousBalanceTo = balanceOfAt(_to, block.number);
618            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
619            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
620 
621            // An event to make the transfer easy to find on the blockchain
622            Transfer(_from, _to, _amount);
623 
624            return true;
625     }
626 
627     /// @param _owner The address that's balance is being requested
628     /// @return The balance of `_owner` at the current block
629     function balanceOf(address _owner) public constant returns (uint256 balance) {
630         return balanceOfAt(_owner, block.number);
631     }
632 
633     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
634     ///  its behalf. This is a modified version of the ERC20 approve function
635     ///  to be a little bit safer
636     /// @param _spender The address of the account able to transfer the tokens
637     /// @param _amount The amount of tokens to be approved for transfer
638     /// @return True if the approval was successful
639     function approve(address _spender, uint256 _amount) public returns (bool success) {
640         require(transfersEnabled);
641 
642         // To change the approve amount you first have to reduce the addresses`
643         //  allowance to zero by calling `approve(_spender,0)` if it is not
644         //  already 0 to mitigate the race condition described here:
645         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
646         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
647 
648         // Alerts the token controller of the approve function call
649         if (isContract(controller)) {
650             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
651         }
652 
653         allowed[msg.sender][_spender] = _amount;
654         Approval(msg.sender, _spender, _amount);
655         return true;
656     }
657 
658     /// @dev This function makes it easy to read the `allowed[]` map
659     /// @param _owner The address of the account that owns the token
660     /// @param _spender The address of the account able to transfer the tokens
661     /// @return Amount of remaining tokens of _owner that _spender is allowed
662     ///  to spend
663     function allowance(address _owner, address _spender
664     ) public constant returns (uint256 remaining) {
665         return allowed[_owner][_spender];
666     }
667 
668     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
669     ///  its behalf, and then a function is triggered in the contract that is
670     ///  being approved, `_spender`. This allows users to use their tokens to
671     ///  interact with contracts in one function call instead of two
672     /// @param _spender The address of the contract able to transfer the tokens
673     /// @param _amount The amount of tokens to be approved for transfer
674     /// @return True if the function call was successful
675     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
676     ) public returns (bool success) {
677         require(approve(_spender, _amount));
678 
679         ApproveAndCallFallBack(_spender).receiveApproval(
680             msg.sender,
681             _amount,
682             this,
683             _extraData
684         );
685 
686         return true;
687     }
688 
689     /// @dev This function makes it easy to get the total number of tokens
690     /// @return The total number of tokens
691     function totalSupply() public constant returns (uint) {
692         return totalSupplyAt(block.number);
693     }
694 
695 
696 ////////////////
697 // Query balance and totalSupply in History
698 ////////////////
699 
700     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
701     /// @param _owner The address from which the balance will be retrieved
702     /// @param _blockNumber The block number when the balance is queried
703     /// @return The balance at `_blockNumber`
704     function balanceOfAt(address _owner, uint _blockNumber) public constant
705         returns (uint) {
706 
707         // These next few lines are used when the balance of the token is
708         //  requested before a check point was ever created for this token, it
709         //  requires that the `parentToken.balanceOfAt` be queried at the
710         //  genesis block for that token as this contains initial balance of
711         //  this token
712         if ((balances[_owner].length == 0)
713             || (balances[_owner][0].fromBlock > _blockNumber)) {
714             if (address(parentToken) != 0) {
715                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
716             } else {
717                 // Has no parent
718                 return 0;
719             }
720 
721         // This will return the expected balance during normal situations
722         } else {
723             return getValueAt(balances[_owner], _blockNumber);
724         }
725     }
726 
727     /// @notice Total amount of tokens at a specific `_blockNumber`.
728     /// @param _blockNumber The block number when the totalSupply is queried
729     /// @return The total amount of tokens at `_blockNumber`
730     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
731 
732         // These next few lines are used when the totalSupply of the token is
733         //  requested before a check point was ever created for this token, it
734         //  requires that the `parentToken.totalSupplyAt` be queried at the
735         //  genesis block for this token as that contains totalSupply of this
736         //  token at this block number.
737         if ((totalSupplyHistory.length == 0)
738             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
739             if (address(parentToken) != 0) {
740                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
741             } else {
742                 return 0;
743             }
744 
745         // This will return the expected totalSupply during normal situations
746         } else {
747             return getValueAt(totalSupplyHistory, _blockNumber);
748         }
749     }
750 
751 ////////////////
752 // Clone Token Method
753 ////////////////
754 
755     /// @notice Creates a new clone token with the initial distribution being
756     ///  this token at `_snapshotBlock`
757     /// @param _cloneTokenName Name of the clone token
758     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
759     /// @param _cloneTokenSymbol Symbol of the clone token
760     /// @param _snapshotBlock Block when the distribution of the parent token is
761     ///  copied to set the initial distribution of the new clone token;
762     ///  if the block is zero than the actual block, the current block is used
763     /// @param _transfersEnabled True if transfers are allowed in the clone
764     /// @return The address of the new MiniMeToken Contract
765     function createCloneToken(
766         string _cloneTokenName,
767         uint8 _cloneDecimalUnits,
768         string _cloneTokenSymbol,
769         uint _snapshotBlock,
770         bool _transfersEnabled
771         ) public returns(address) {
772         if (_snapshotBlock == 0) _snapshotBlock = block.number;
773         MiniMeToken cloneToken = tokenFactory.createCloneToken(
774             this,
775             _snapshotBlock,
776             _cloneTokenName,
777             _cloneDecimalUnits,
778             _cloneTokenSymbol,
779             _transfersEnabled
780             );
781 
782         cloneToken.changeController(msg.sender);
783 
784         // An event to make the token easy to find on the blockchain
785         NewCloneToken(address(cloneToken), _snapshotBlock);
786         return address(cloneToken);
787     }
788 
789 ////////////////
790 // Generate and destroy tokens
791 ////////////////
792 
793     /// @notice Generates `_amount` tokens that are assigned to `_owner`
794     /// @param _owner The address that will be assigned the new tokens
795     /// @param _amount The quantity of tokens generated
796     /// @return True if the tokens are generated correctly
797     function generateTokens(address _owner, uint _amount
798     ) public onlyController returns (bool) {
799         uint curTotalSupply = totalSupply();
800         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
801         uint previousBalanceTo = balanceOf(_owner);
802         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
803         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
804         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
805         Transfer(0, _owner, _amount);
806         return true;
807     }
808 
809 
810     /// @notice Burns `_amount` tokens from `_owner`
811     /// @param _owner The address that will lose the tokens
812     /// @param _amount The quantity of tokens to burn
813     /// @return True if the tokens are burned correctly
814     function destroyTokens(address _owner, uint _amount
815     ) onlyController public returns (bool) {
816         uint curTotalSupply = totalSupply();
817         require(curTotalSupply >= _amount);
818         uint previousBalanceFrom = balanceOf(_owner);
819         require(previousBalanceFrom >= _amount);
820         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
821         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
822         Transfer(_owner, 0, _amount);
823         return true;
824     }
825 
826 ////////////////
827 // Enable tokens transfers
828 ////////////////
829 
830 
831     /// @notice Enables token holders to transfer their tokens freely if true
832     /// @param _transfersEnabled True if transfers are allowed in the clone
833     function enableTransfers(bool _transfersEnabled) public onlyController {
834         transfersEnabled = _transfersEnabled;
835     }
836 
837 ////////////////
838 // Internal helper functions to query and set a value in a snapshot array
839 ////////////////
840 
841     /// @dev `getValueAt` retrieves the number of tokens at a given block number
842     /// @param checkpoints The history of values being queried
843     /// @param _block The block number to retrieve the value at
844     /// @return The number of tokens being queried
845     function getValueAt(Checkpoint[] storage checkpoints, uint _block
846     ) constant internal returns (uint) {
847         if (checkpoints.length == 0) return 0;
848 
849         // Shortcut for the actual value
850         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
851             return checkpoints[checkpoints.length-1].value;
852         if (_block < checkpoints[0].fromBlock) return 0;
853 
854         // Binary search of the value in the array
855         uint min = 0;
856         uint max = checkpoints.length-1;
857         while (max > min) {
858             uint mid = (max + min + 1)/ 2;
859             if (checkpoints[mid].fromBlock<=_block) {
860                 min = mid;
861             } else {
862                 max = mid-1;
863             }
864         }
865         return checkpoints[min].value;
866     }
867 
868     /// @dev `updateValueAtNow` used to update the `balances` map and the
869     ///  `totalSupplyHistory`
870     /// @param checkpoints The history of data being updated
871     /// @param _value The new number of tokens
872     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
873     ) internal  {
874         if ((checkpoints.length == 0)
875         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
876                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
877                newCheckPoint.fromBlock =  uint128(block.number);
878                newCheckPoint.value = uint128(_value);
879            } else {
880                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
881                oldCheckPoint.value = uint128(_value);
882            }
883     }
884 
885     /// @dev Internal function to determine if an address is a contract
886     /// @param _addr The address being queried
887     /// @return True if `_addr` is a contract
888     function isContract(address _addr) constant internal returns(bool) {
889         uint size;
890         if (_addr == 0) return false;
891         assembly {
892             size := extcodesize(_addr)
893         }
894         return size>0;
895     }
896 
897     /// @dev Helper function to return a min betwen the two uints
898     function min(uint a, uint b) pure internal returns (uint) {
899         return a < b ? a : b;
900     }
901 
902     /// @notice The fallback function: If the contract's controller has not been
903     ///  set to 0, then the `proxyPayment` method is called which relays the
904     ///  ether and creates tokens as described in the token controller contract
905     function () public payable {
906         require(isContract(controller));
907         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
908     }
909 
910 //////////
911 // Safety Methods
912 //////////
913 
914     /// @notice This method can be used by the controller to extract mistakenly
915     ///  sent tokens to this contract.
916     /// @param _token The address of the token contract that you want to recover
917     ///  set to 0 in case you want to extract ether.
918     function claimTokens(address _token) public onlyController {
919         if (_token == 0x0) {
920             controller.transfer(this.balance);
921             return;
922         }
923 
924         MiniMeToken token = MiniMeToken(_token);
925         uint balance = token.balanceOf(this);
926         token.transfer(controller, balance);
927         ClaimedTokens(_token, controller, balance);
928     }
929 
930 ////////////////
931 // Events
932 ////////////////
933     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
934     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
935     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
936     event Approval(
937         address indexed _owner,
938         address indexed _spender,
939         uint256 _amount
940         );
941 
942 }
943 
944 
945 ////////////////
946 // MiniMeTokenFactory
947 ////////////////
948 
949 /// @dev This contract is used to generate clone contracts from a contract.
950 ///  In solidity this is the way to create a contract from a contract of the
951 ///  same class
952 contract MiniMeTokenFactory {
953 
954     /// @notice Update the DApp by creating a new token with new functionalities
955     ///  the msg.sender becomes the controller of this clone token
956     /// @param _parentToken Address of the token being cloned
957     /// @param _snapshotBlock Block of the parent token that will
958     ///  determine the initial distribution of the clone token
959     /// @param _tokenName Name of the new token
960     /// @param _decimalUnits Number of decimals of the new token
961     /// @param _tokenSymbol Token Symbol for the new token
962     /// @param _transfersEnabled If true, tokens will be able to be transferred
963     /// @return The address of the new token contract
964     function createCloneToken(
965         address _parentToken,
966         uint _snapshotBlock,
967         string _tokenName,
968         uint8 _decimalUnits,
969         string _tokenSymbol,
970         bool _transfersEnabled
971     ) public returns (MiniMeToken) {
972         MiniMeToken newToken = new MiniMeToken(
973             this,
974             _parentToken,
975             _snapshotBlock,
976             _tokenName,
977             _decimalUnits,
978             _tokenSymbol,
979             _transfersEnabled
980             );
981 
982         newToken.changeController(msg.sender);
983         return newToken;
984     }
985 }
986 
987 // File: contracts/Bounty0xToken.sol
988 
989 contract Bounty0xToken is MiniMeToken {
990     function Bounty0xToken(address _tokenFactory)
991         MiniMeToken(
992             _tokenFactory,
993             0x0,                        // no parent token
994             0,                          // no snapshot block number from parent
995             "Bounty0x Token",           // Token name
996             18   ,                      // Decimals
997             "BNTY",                     // Symbol
998             false                       // Disable transfers
999         )
1000         public
1001     {
1002     }
1003 
1004     // generate tokens for many addresses with a single transaction
1005     function generateTokensAll(address[] _owners, uint[] _amounts) onlyController public {
1006         require(_owners.length == _amounts.length);
1007 
1008         for (uint i = 0; i < _owners.length; i++) {
1009             require(generateTokens(_owners[i], _amounts[i]));
1010         }
1011     }
1012 }
1013 
1014 // File: contracts/interfaces/Bounty0xPresaleI.sol
1015 
1016 /**
1017  * This interface describes the only function we will be calling from the Bounty0xPresaleI contract
1018  */
1019 interface Bounty0xPresaleI {
1020     function balanceOf(address addr) public returns (uint balance);
1021 }
1022 
1023 // File: zeppelin-solidity/contracts/math/Math.sol
1024 
1025 /**
1026  * @title Math
1027  * @dev Assorted math operations
1028  */
1029 
1030 library Math {
1031   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
1032     return a >= b ? a : b;
1033   }
1034 
1035   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
1036     return a < b ? a : b;
1037   }
1038 
1039   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
1040     return a >= b ? a : b;
1041   }
1042 
1043   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
1044     return a < b ? a : b;
1045   }
1046 }
1047 
1048 // File: contracts/Bounty0xPresaleDistributor.sol
1049 
1050 /*
1051 This contract manages compensation of the presale investors, based on the contribution balances recorded in the presale
1052 contract.
1053 */
1054 contract Bounty0xPresaleDistributor is KnowsConstants, BntyExchangeRateCalculator {
1055     using SafeMath for uint;
1056 
1057     Bounty0xPresaleI public deployedPresaleContract;
1058     Bounty0xToken public bounty0xToken;
1059 
1060     mapping(address => uint) public tokensPaid;
1061 
1062     function Bounty0xPresaleDistributor(Bounty0xToken _bounty0xToken, Bounty0xPresaleI _deployedPresaleContract)
1063         BntyExchangeRateCalculator(MICRO_DOLLARS_PER_BNTY_PRESALE, FIXED_PRESALE_USD_ETHER_PRICE, 0)
1064         public
1065     {
1066         bounty0xToken = _bounty0xToken;
1067         deployedPresaleContract = _deployedPresaleContract;
1068     }
1069 
1070     event OnPreSaleBuyerCompensated(address indexed contributor, uint numTokens);
1071 
1072     /**
1073      * Compensate the presale investors at the addresses provider based on their contributions during the presale
1074      */
1075     function compensatePreSaleInvestors(address[] preSaleInvestors) public {
1076         // iterate through each investor
1077         for (uint i = 0; i < preSaleInvestors.length; i++) {
1078             address investorAddress = preSaleInvestors[i];
1079 
1080             // the deployed presale contract tracked the balance of each contributor
1081             uint weiContributed = deployedPresaleContract.balanceOf(investorAddress);
1082 
1083             // they contributed and haven't been paid
1084             if (weiContributed > 0 && tokensPaid[investorAddress] == 0) {
1085                 // convert the amount of wei they contributed to the bnty
1086                 uint bntyCompensation = Math.min256(weiToBnty(weiContributed), bounty0xToken.balanceOf(this));
1087 
1088                 // mark them paid first
1089                 tokensPaid[investorAddress] = bntyCompensation;
1090 
1091                 // transfer tokens to presale contributor address
1092                 require(bounty0xToken.transfer(investorAddress, bntyCompensation));
1093 
1094                 // log the event
1095                 OnPreSaleBuyerCompensated(investorAddress, bntyCompensation);
1096             }
1097         }
1098     }
1099 }
1100 
1101 // File: contracts/Bounty0xReserveHolder.sol
1102 
1103 /**
1104  * @title Bounty0xReserveHolder
1105  * @dev Bounty0xReserveHolder is a token holder contract that will allow a
1106  * beneficiary to extract the tokens after a given release time
1107  */
1108 contract Bounty0xReserveHolder is KnowsConstants, KnowsTime {
1109     // Bounty0xToken address
1110     Bounty0xToken public token;
1111 
1112     // beneficiary of tokens after they are released
1113     address public beneficiary;
1114 
1115     function Bounty0xReserveHolder(Bounty0xToken _token, address _beneficiary) public {
1116         require(_token != address(0));
1117         require(_beneficiary != address(0));
1118 
1119         token = _token;
1120         beneficiary = _beneficiary;
1121     }
1122 
1123     /**
1124      * @notice Transfers tokens held by timelock to beneficiary.
1125      */
1126     function release() public {
1127         require(currentTime() >= UNFREEZE_DATE);
1128 
1129         uint amount = token.balanceOf(this);
1130         require(amount > 0);
1131 
1132         require(token.transfer(beneficiary, amount));
1133     }
1134 }
1135 
1136 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
1137 
1138 /**
1139  * @title Pausable
1140  * @dev Base contract which allows children to implement an emergency stop mechanism.
1141  */
1142 contract Pausable is Ownable {
1143   event Pause();
1144   event Unpause();
1145 
1146   bool public paused = false;
1147 
1148 
1149   /**
1150    * @dev Modifier to make a function callable only when the contract is not paused.
1151    */
1152   modifier whenNotPaused() {
1153     require(!paused);
1154     _;
1155   }
1156 
1157   /**
1158    * @dev Modifier to make a function callable only when the contract is paused.
1159    */
1160   modifier whenPaused() {
1161     require(paused);
1162     _;
1163   }
1164 
1165   /**
1166    * @dev called by the owner to pause, triggers stopped state
1167    */
1168   function pause() onlyOwner whenNotPaused public {
1169     paused = true;
1170     Pause();
1171   }
1172 
1173   /**
1174    * @dev called by the owner to unpause, returns to normal state
1175    */
1176   function unpause() onlyOwner whenPaused public {
1177     paused = false;
1178     Unpause();
1179   }
1180 }
1181 
1182 // File: contracts/Bounty0xCrowdsale.sol
1183 
1184 contract Bounty0xCrowdsale is KnowsTime, KnowsConstants, Ownable, BntyExchangeRateCalculator, AddressWhitelist, Pausable {
1185     using SafeMath for uint;
1186 
1187     // Crowdsale contracts
1188     Bounty0xToken public bounty0xToken;                                 // Reward tokens to compensate in
1189 
1190     // Contribution amounts
1191     mapping (address => uint) public contributionAmounts;            // The amount that each address has contributed
1192     uint public totalContributions;                                  // Total contributions given
1193 
1194     // Events
1195     event OnContribution(address indexed contributor, bool indexed duringWhitelistPeriod, uint indexed contributedWei, uint bntyAwarded, uint refundedWei);
1196     event OnWithdraw(address to, uint amount);
1197 
1198     function Bounty0xCrowdsale(Bounty0xToken _bounty0xToken, uint _USDEtherPrice)
1199         BntyExchangeRateCalculator(MICRO_DOLLARS_PER_BNTY_MAINSALE, _USDEtherPrice, SALE_START_DATE)
1200         public
1201     {
1202         bounty0xToken = _bounty0xToken;
1203     }
1204 
1205     // the crowdsale owner may withdraw any amount of ether from this contract at any time
1206     function withdraw(uint amount) public onlyOwner {
1207         msg.sender.transfer(amount);
1208         OnWithdraw(msg.sender, amount);
1209     }
1210 
1211     // All contributions come through the fallback function
1212     function () payable public whenNotPaused {
1213         uint time = currentTime();
1214 
1215         // require the sale has started
1216         require(time >= SALE_START_DATE);
1217 
1218         // require that the sale has not ended
1219         require(time < SALE_END_DATE);
1220 
1221         // maximum contribution from this transaction is tracked in this variable
1222         uint maximumContribution = usdToWei(HARD_CAP_USD).sub(totalContributions);
1223 
1224         // store whether the contribution is made during the whitelist period
1225         bool isDuringWhitelistPeriod = time < WHITELIST_END_DATE;
1226 
1227         // these limits are only checked during the limited period
1228         if (time < LIMITS_END_DATE) {
1229             // require that they have not overpaid their gas price
1230             require(tx.gasprice <= MAX_GAS_PRICE);
1231 
1232             // require that they haven't sent too much gas
1233             require(msg.gas <= MAX_GAS);
1234 
1235             // if we are in the WHITELIST period, we need to make sure the sender contributed to the presale
1236             if (isDuringWhitelistPeriod) {
1237                 require(isWhitelisted(msg.sender));
1238 
1239                 // the maximum contribution is set for the whitelist period
1240                 maximumContribution = Math.min256(
1241                     maximumContribution,
1242                     usdToWei(MAXIMUM_CONTRIBUTION_WHITELIST_PERIOD_USD).sub(contributionAmounts[msg.sender])
1243                 );
1244             } else {
1245                 // the maximum contribution is set for the limited period
1246                 maximumContribution = Math.min256(
1247                     maximumContribution,
1248                     usdToWei(MAXIMUM_CONTRIBUTION_LIMITED_PERIOD_USD).sub(contributionAmounts[msg.sender])
1249                 );
1250             }
1251         }
1252 
1253         // calculate how much contribution is accepted and how much is refunded
1254         uint contribution = Math.min256(msg.value, maximumContribution);
1255         uint refundWei = msg.value.sub(contribution);
1256 
1257         // require that they are allowed to contribute more
1258         require(contribution > 0);
1259 
1260         // account contribution towards total
1261         totalContributions = totalContributions.add(contribution);
1262 
1263         // account contribution towards address total
1264         contributionAmounts[msg.sender] = contributionAmounts[msg.sender].add(contribution);
1265 
1266         // and send them some bnty
1267         uint amountBntyRewarded = Math.min256(weiToBnty(contribution), bounty0xToken.balanceOf(this));
1268         require(bounty0xToken.transfer(msg.sender, amountBntyRewarded));
1269 
1270         if (refundWei > 0) {
1271             msg.sender.transfer(refundWei);
1272         }
1273 
1274         // log the contribution
1275         OnContribution(msg.sender, isDuringWhitelistPeriod, contribution, amountBntyRewarded, refundWei);
1276     }
1277 }
1278 
1279 // File: contracts/CrowdsaleTokenController.sol
1280 
1281 contract CrowdsaleTokenController is Ownable, AddressWhitelist, TokenController {
1282     bool public whitelistOff;
1283     Bounty0xToken public token;
1284 
1285     function CrowdsaleTokenController(Bounty0xToken _token) public {
1286         token = _token;
1287     }
1288 
1289     // set the whitelistOff variable
1290     function setWhitelistOff(bool _whitelistOff) public onlyOwner {
1291         whitelistOff = _whitelistOff;
1292     }
1293 
1294     // the owner of the controller can change the controller to a new contract
1295     function changeController(address newController) public onlyOwner {
1296         token.changeController(newController);
1297     }
1298 
1299     // change whether transfers are enabled
1300     function enableTransfers(bool _transfersEnabled) public onlyOwner {
1301         token.enableTransfers(_transfersEnabled);
1302     }
1303 
1304     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
1305     /// @param _owner The address that sent the ether to create tokens
1306     /// @return True if the ether is accepted, false if it throws
1307     function proxyPayment(address _owner) public payable returns (bool) {
1308         return false;
1309     }
1310 
1311     /// @notice Notifies the controller about a token transfer allowing the
1312     ///  controller to react if desired
1313     /// @param _from The origin of the transfer
1314     /// @param _to The destination of the transfer
1315     /// @param _amount The amount of the transfer
1316     /// @return False if the controller does not authorize the transfer
1317     function onTransfer(address _from, address _to, uint _amount) public returns (bool) {
1318         return whitelistOff || isWhitelisted(_from);
1319     }
1320 
1321     /// @notice Notifies the controller about an approval allowing the
1322     ///  controller to react if desired
1323     /// @param _owner The address that calls `approve()`
1324     /// @param _spender The spender in the `approve()` call
1325     /// @param _amount The amount in the `approve()` call
1326     /// @return False if the controller does not authorize the approval
1327     function onApprove(address _owner, address _spender, uint _amount) public returns (bool) {
1328         return whitelistOff || isWhitelisted(_owner);
1329     }
1330 }