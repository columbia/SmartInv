1 pragma solidity 0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
32     uint256 c = a * b;
33     assert(a == 0 || c / a == b);
34     return c;
35   }
36 
37   function div(uint256 a, uint256 b) internal constant returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   function add(uint256 a, uint256 b) internal constant returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 /**
57  * @title Math
58  * @dev Assorted math operations
59  */
60 
61 library Math {
62   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
63     return a >= b ? a : b;
64   }
65 
66   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a < b ? a : b;
68   }
69 
70   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
71     return a >= b ? a : b;
72   }
73 
74   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a < b ? a : b;
76   }
77 }
78 
79 /**
80  * @title Ownable
81  * @dev The Ownable contract has an owner address, and provides basic authorization control
82  * functions, this simplifies the implementation of "user permissions".
83  */
84 contract Ownable {
85   address public owner;
86 
87 
88   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90 
91   /**
92    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
93    * account.
94    */
95   function Ownable() {
96     owner = msg.sender;
97   }
98 
99 
100   /**
101    * @dev Throws if called by any account other than the owner.
102    */
103   modifier onlyOwner() {
104     require(msg.sender == owner);
105     _;
106   }
107 
108 
109   /**
110    * @dev Allows the current owner to transfer control of the contract to a newOwner.
111    * @param newOwner The address to transfer ownership to.
112    */
113   function transferOwnership(address newOwner) onlyOwner public {
114     require(newOwner != address(0));
115     OwnershipTransferred(owner, newOwner);
116     owner = newOwner;
117   }
118 
119 }
120 
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133    * @dev Modifier to make a function callable only when the contract is not paused.
134    */
135   modifier whenNotPaused() {
136     require(!paused);
137     _;
138   }
139 
140   /**
141    * @dev Modifier to make a function callable only when the contract is paused.
142    */
143   modifier whenPaused() {
144     require(paused);
145     _;
146   }
147 
148   /**
149    * @dev called by the owner to pause, triggers stopped state
150    */
151   function pause() onlyOwner whenNotPaused public {
152     paused = true;
153     Pause();
154   }
155 
156   /**
157    * @dev called by the owner to unpause, returns to normal state
158    */
159   function unpause() onlyOwner whenPaused public {
160     paused = false;
161     Unpause();
162   }
163 }
164 
165 /**
166  * @title Whitelist
167  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
168  * @dev This simplifies the implementation of "user permissions".
169  */
170 contract Whitelist is Ownable {
171   mapping(address => bool) public whitelist;
172 
173   event WhitelistedAddressAdded(address addr);
174   event WhitelistedAddressRemoved(address addr);
175 
176   /**
177    * @dev Throws if called by any account that's not whitelisted.
178    */
179   modifier onlyWhitelisted() {
180     require(whitelist[msg.sender]);
181     _;
182   }
183 
184   /**
185    * @dev add an address to the whitelist
186    * @param addr address
187    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
188    */
189   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
190     if (!whitelist[addr]) {
191       whitelist[addr] = true;
192       WhitelistedAddressAdded(addr);
193       success = true;
194     }
195   }
196 
197   /**
198    * @dev add addresses to the whitelist
199    * @param addrs addresses
200    * @return true if at least one address was added to the whitelist,
201    * false if all addresses were already in the whitelist
202    */
203   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
204     for (uint256 i = 0; i < addrs.length; i++) {
205       if (addAddressToWhitelist(addrs[i])) {
206         success = true;
207       }
208     }
209   }
210 
211   /**
212    * @dev remove an address from the whitelist
213    * @param addr address
214    * @return true if the address was removed from the whitelist,
215    * false if the address wasn't in the whitelist in the first place
216    */
217   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
218     if (whitelist[addr]) {
219       whitelist[addr] = false;
220       WhitelistedAddressRemoved(addr);
221       success = true;
222     }
223   }
224 
225   /**
226    * @dev remove addresses from the whitelist
227    * @param addrs addresses
228    * @return true if at least one address was removed from the whitelist,
229    * false if all addresses weren't in the whitelist in the first place
230    */
231   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
232     for (uint256 i = 0; i < addrs.length; i++) {
233       if (removeAddressFromWhitelist(addrs[i])) {
234         success = true;
235       }
236     }
237   }
238 
239 }
240 
241 contract Presale is Whitelist {
242 
243   using SafeMath for uint256;
244   uint256 private weiRaised;
245   uint256 private startTime;
246   uint256 private endTime;
247   uint256 private rate;
248 
249   uint256 private cap;
250 
251   function Presale(uint256 _startTime, uint256 duration, uint256 _rate, uint256 _cap) public {
252     require(_rate > 0);
253     require(_cap > 0);
254     require(_startTime >= now);
255     require(duration > 0);
256 
257     rate = _rate;
258     cap = _cap;
259     startTime = _startTime;
260     endTime = startTime + duration * 1 days;
261     weiRaised = 0;
262   }
263 
264   function totalWei() public constant returns(uint256) {
265     return weiRaised;
266   }
267 
268   function capRemaining() public constant returns(uint256) {
269     return cap.sub(weiRaised);
270   }
271 
272   function totalCap() public constant returns(uint256) {
273     return cap;
274   }
275 
276   function buyTokens(address purchaser, uint256 value) internal returns(uint256) {
277     require(validPurchase(value));
278     uint256 tokens = rate.mul(value);
279     weiRaised = weiRaised.add(value);
280     return tokens;
281   }
282 
283   function hasEnded() internal constant returns(bool) {
284     return now > endTime || weiRaised >= cap;
285   }
286 
287   function hasStarted() internal constant returns(bool) {
288     return now > startTime;
289   }
290 
291   function validPurchase(uint256 value) internal view returns (bool) {
292     bool withinCap = weiRaised.add(value) <= cap;
293     return withinCap && withinPeriod();
294   }
295 
296   function presaleRate() public view returns(uint256) {
297     return rate;
298   }
299 
300   function withinPeriod () private constant returns(bool) {
301     return now >= startTime && now <= endTime;
302   }
303 
304   function increasePresaleEndTime(uint _days) public onlyWhitelisted {
305     endTime = endTime + _days * 1 days;
306   }
307 
308   function getPresaleEndTime() public constant returns(uint) {
309     return endTime;
310   }
311 }
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure.
316  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
317  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
318  */
319 library SafeERC20 {
320   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
321     assert(token.transfer(to, value));
322   }
323 
324   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
325     assert(token.transferFrom(from, to, value));
326   }
327 
328   function safeApprove(ERC20 token, address spender, uint256 value) internal {
329     assert(token.approve(spender, value));
330   }
331 }
332 
333 /**
334  * @title Contracts that should be able to recover tokens
335  * @author SylTi
336  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
337  * This will prevent any accidental loss of tokens.
338  */
339 contract CanReclaimToken is Ownable {
340   using SafeERC20 for ERC20Basic;
341 
342   /**
343    * @dev Reclaim all ERC20Basic compatible tokens
344    * @param token ERC20Basic The address of the token contract
345    */
346   function reclaimToken(ERC20Basic token) external onlyOwner {
347     uint256 balance = token.balanceOf(this);
348     token.safeTransfer(owner, balance);
349   }
350 
351 }
352 
353 /// @title Vesting trustee contract for erc20 token.
354 contract VestingTrustee is Ownable, CanReclaimToken {
355     using SafeMath for uint256;
356 
357     // erc20 token contract.
358     ERC20 public token;
359 
360     // Vesting grant for a speicifc holder.
361     struct Grant {
362         uint256 value;
363         uint256 start;
364         uint256 cliff;
365         uint256 end;
366         uint256 installmentLength; // In seconds.
367         uint256 transferred;
368         bool revokable;
369         uint256 prevested;
370         uint256 vestingPercentage;
371     }
372 
373     // Holder to grant information mapping.
374     mapping (address => Grant) public grants;
375 
376     // Total tokens available for vesting.
377     uint256 public totalVesting;
378 
379     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
380     event TokensUnlocked(address indexed _to, uint256 _value);
381     event GrantRevoked(address indexed _holder, uint256 _refund);
382 
383     /// @dev Constructor that initializes the address of the  token contract.
384     /// @param _token erc20 The address of the previously deployed token contract.
385     function VestingTrustee(address _token) {
386         require(_token != address(0));
387 
388         token = ERC20(_token);
389     }
390 
391     /// @dev Grant tokens to a specified address.
392     /// @param _to address The holder address.
393     /// @param _value uint256 The amount of tokens to be granted.
394     /// @param _start uint256 The beginning of the vesting period.
395     /// @param _cliff uint256 Duration of the cliff period (when the first installment is made).
396     /// @param _end uint256 The end of the vesting period.
397     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
398     /// @param _revokable bool Whether the grant is revokable or not.
399     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
400         uint256 _installmentLength, uint256 vestingPercentage, uint256 prevested, bool _revokable)
401         external onlyOwner {
402 
403         require(_to != address(0));
404         require(_to != address(this)); // Don't allow holder to be this contract.
405         require(_value > 0);
406         require(_value.sub(prevested) > 0);
407         require(vestingPercentage > 0);
408 
409         // Require that every holder can be granted tokens only once.
410         require(grants[_to].value == 0);
411 
412         // Require for time ranges to be consistent and valid.
413         require(_start <= _cliff && _cliff <= _end);
414 
415         // Require installment length to be valid and no longer than (end - start).
416         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
417 
418         // Grant must not exceed the total amount of tokens currently available for vesting.
419         require(totalVesting.add(_value.sub(prevested)) <= token.balanceOf(address(this)));
420 
421         // Assign a new grant.
422         grants[_to] = Grant({
423             value: _value,
424             start: _start,
425             cliff: _cliff,
426             end: _end,
427             installmentLength: _installmentLength,
428             transferred: prevested,
429             revokable: _revokable,
430             prevested: prevested,
431             vestingPercentage: vestingPercentage
432         });
433 
434         totalVesting = totalVesting.add(_value.sub(prevested));
435         NewGrant(msg.sender, _to, _value);
436     }
437 
438     /// @dev Revoke the grant of tokens of a specifed address.
439     /// @param _holder The address which will have its tokens revoked.
440     function revoke(address _holder) public onlyOwner {
441         Grant memory grant = grants[_holder];
442 
443         // Grant must be revokable.
444         require(grant.revokable);
445 
446         // Calculate amount of remaining tokens that are still available to be
447         // returned to owner.
448         uint256 refund = grant.value.sub(grant.transferred);
449 
450         // Remove grant information.
451         delete grants[_holder];
452 
453         // Update total vesting amount and transfer previously calculated tokens to owner.
454         totalVesting = totalVesting.sub(refund);
455         token.transfer(msg.sender, refund);
456 
457         GrantRevoked(_holder, refund);
458     }
459 
460     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
461     /// @param _holder address The address of the holder.
462     /// @param _time uint256 The specific time to calculate against.
463     /// @return a uint256 Representing a holder's total amount of vested tokens.
464     function vestedTokens(address _holder, uint256 _time) external constant returns (uint256) {
465         Grant memory grant = grants[_holder];
466         if (grant.value == 0) {
467             return 0;
468         }
469 
470         return calculateVestedTokens(grant, _time);
471     }
472 
473     /// @dev Calculate amount of vested tokens at a specifc time.
474     /// @param _grant Grant The vesting grant.
475     /// @param _time uint256 The time to be checked
476     /// @return a uint256 Representing the amount of vested tokens of a specific grant.
477     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
478         // If we're before the cliff, then nothing is vested.
479         if (_time < _grant.cliff) {
480             return _grant.prevested;
481         }
482 
483         // If we're after the end of the vesting period - everything is vested;
484         if (_time >= _grant.end) {
485             return _grant.value;
486         }
487 
488         // Calculate amount of installments past until now.
489         uint256 installmentsPast = _time.sub(_grant.cliff).div(_grant.installmentLength) + 1;
490 
491 
492         // Calculate and return installments that have passed according to vesting days that have passed.
493         return _grant.prevested.add(_grant.value.mul(installmentsPast.mul(_grant.vestingPercentage)).div(100));
494     }
495 
496     /// @dev Unlock vested tokens and transfer them to their holder.
497     /// @return a uint256 Representing the amount of vested tokens transferred to their holder.
498     function unlockVestedTokens() external {
499         Grant storage grant = grants[msg.sender];
500 
501         // Require that there will be funds left in grant to tranfser to holder.
502         require(grant.value != 0);
503 
504         // Get the total amount of vested tokens, acccording to grant.
505         uint256 vested = calculateVestedTokens(grant, now);
506         if (vested == 0) {
507             revert();
508         }
509 
510         // Make sure the holder doesn't transfer more than what he already has.
511         uint256 transferable = vested.sub(grant.transferred);
512         if (transferable == 0) {
513             revert();
514         }
515 
516         grant.transferred = grant.transferred.add(transferable);
517         totalVesting = totalVesting.sub(transferable);
518         token.transfer(msg.sender, transferable);
519         TokensUnlocked(msg.sender, transferable);
520     }
521 
522     function reclaimEther() external onlyOwner {
523       assert(owner.send(this.balance));
524     }
525 }
526 
527 contract Controlled {
528     /// @notice The address of the controller is the only address that can call
529     ///  a function with this modifier
530     modifier onlyController { require(msg.sender == controller); _; }
531 
532     address public controller;
533 
534     function Controlled() public { controller = msg.sender;}
535 
536     /// @notice Changes the controller of the contract
537     /// @param _newController The new controller of the contract
538     function changeController(address _newController) public onlyController {
539         controller = _newController;
540     }
541 }
542 
543 /// @dev The token controller contract must implement these functions
544 contract TokenController {
545     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
546     /// @param _owner The address that sent the ether to create tokens
547     /// @return True if the ether is accepted, false if it throws
548     function proxyPayment(address _owner) public payable returns(bool);
549 
550     /// @notice Notifies the controller about a token transfer allowing the
551     ///  controller to react if desired
552     /// @param _from The origin of the transfer
553     /// @param _to The destination of the transfer
554     /// @param _amount The amount of the transfer
555     /// @return False if the controller does not authorize the transfer
556     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
557 
558     /// @notice Notifies the controller about an approval allowing the
559     ///  controller to react if desired
560     /// @param _owner The address that calls `approve()`
561     /// @param _spender The spender in the `approve()` call
562     /// @param _amount The amount in the `approve()` call
563     /// @return False if the controller does not authorize the approval
564     function onApprove(address _owner, address _spender, uint _amount) public
565         returns(bool);
566 }
567 
568 /*
569     Copyright 2016, Jordi Baylina
570 
571     This program is free software: you can redistribute it and/or modify
572     it under the terms of the GNU General Public License as published by
573     the Free Software Foundation, either version 3 of the License, or
574     (at your option) any later version.
575 
576     This program is distributed in the hope that it will be useful,
577     but WITHOUT ANY WARRANTY; without even the implied warranty of
578     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
579     GNU General Public License for more details.
580 
581     You should have received a copy of the GNU General Public License
582     along with this program.  If not, see <http://www.gnu.org/licenses/>.
583  */
584 
585 /// @title MiniMeToken Contract
586 /// @author Jordi Baylina
587 /// @dev This token contract's goal is to make it easy for anyone to clone this
588 ///  token using the token distribution at a given block, this will allow DAO's
589 ///  and DApps to upgrade their features in a decentralized manner without
590 ///  affecting the original token
591 /// @dev It is ERC20 compliant, but still needs to under go further testing.
592 
593 
594 
595 
596 contract ApproveAndCallFallBack {
597     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
598 }
599 
600 /// @dev The actual token contract, the default controller is the msg.sender
601 ///  that deploys the contract, so usually this token will be deployed by a
602 ///  token controller contract, which Giveth will call a "Campaign"
603 contract MiniMeToken is Controlled {
604 
605     string public name;                //The Token's name: e.g. DigixDAO Tokens
606     uint8 public decimals;             //Number of decimals of the smallest unit
607     string public symbol;              //An identifier: e.g. REP
608     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
609 
610 
611     /// @dev `Checkpoint` is the structure that attaches a block number to a
612     ///  given value, the block number attached is the one that last changed the
613     ///  value
614     struct  Checkpoint {
615 
616         // `fromBlock` is the block number that the value was generated from
617         uint128 fromBlock;
618 
619         // `value` is the amount of tokens at a specific block number
620         uint128 value;
621     }
622 
623     // `parentToken` is the Token address that was cloned to produce this token;
624     //  it will be 0x0 for a token that was not cloned
625     MiniMeToken public parentToken;
626 
627     // `parentSnapShotBlock` is the block number from the Parent Token that was
628     //  used to determine the initial distribution of the Clone Token
629     uint public parentSnapShotBlock;
630 
631     // `creationBlock` is the block number that the Clone Token was created
632     uint public creationBlock;
633 
634     // `balances` is the map that tracks the balance of each address, in this
635     //  contract when the balance changes the block number that the change
636     //  occurred is also included in the map
637     mapping (address => Checkpoint[]) balances;
638 
639     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
640     mapping (address => mapping (address => uint256)) allowed;
641 
642     // Tracks the history of the `totalSupply` of the token
643     Checkpoint[] totalSupplyHistory;
644 
645     // Flag that determines if the token is transferable or not.
646     bool public transfersEnabled;
647 
648     // The factory used to create new clone tokens
649     MiniMeTokenFactory public tokenFactory;
650 
651 ////////////////
652 // Constructor
653 ////////////////
654 
655     /// @notice Constructor to create a MiniMeToken
656     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
657     ///  will create the Clone token contracts, the token factory needs to be
658     ///  deployed first
659     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
660     ///  new token
661     /// @param _parentSnapShotBlock Block of the parent token that will
662     ///  determine the initial distribution of the clone token, set to 0 if it
663     ///  is a new token
664     /// @param _tokenName Name of the new token
665     /// @param _decimalUnits Number of decimals of the new token
666     /// @param _tokenSymbol Token Symbol for the new token
667     /// @param _transfersEnabled If true, tokens will be able to be transferred
668     function MiniMeToken(
669         address _tokenFactory,
670         address _parentToken,
671         uint _parentSnapShotBlock,
672         string _tokenName,
673         uint8 _decimalUnits,
674         string _tokenSymbol,
675         bool _transfersEnabled
676     ) public {
677         tokenFactory = MiniMeTokenFactory(_tokenFactory);
678         name = _tokenName;                                 // Set the name
679         decimals = _decimalUnits;                          // Set the decimals
680         symbol = _tokenSymbol;                             // Set the symbol
681         parentToken = MiniMeToken(_parentToken);
682         parentSnapShotBlock = _parentSnapShotBlock;
683         transfersEnabled = _transfersEnabled;
684         creationBlock = block.number;
685     }
686 
687 
688 ///////////////////
689 // ERC20 Methods
690 ///////////////////
691 
692     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
693     /// @param _to The address of the recipient
694     /// @param _amount The amount of tokens to be transferred
695     /// @return Whether the transfer was successful or not
696     function transfer(address _to, uint256 _amount) public returns (bool success) {
697         require(transfersEnabled);
698         doTransfer(msg.sender, _to, _amount);
699         return true;
700     }
701 
702     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
703     ///  is approved by `_from`
704     /// @param _from The address holding the tokens being transferred
705     /// @param _to The address of the recipient
706     /// @param _amount The amount of tokens to be transferred
707     /// @return True if the transfer was successful
708     function transferFrom(address _from, address _to, uint256 _amount
709     ) public returns (bool success) {
710 
711         // The controller of this contract can move tokens around at will,
712         //  this is important to recognize! Confirm that you trust the
713         //  controller of this contract, which in most situations should be
714         //  another open source smart contract or 0x0
715         if (msg.sender != controller) {
716             require(transfersEnabled);
717 
718             // The standard ERC 20 transferFrom functionality
719             require(allowed[_from][msg.sender] >= _amount);
720             allowed[_from][msg.sender] -= _amount;
721         }
722         doTransfer(_from, _to, _amount);
723         return true;
724     }
725 
726     /// @dev This is the actual transfer function in the token contract, it can
727     ///  only be called by other functions in this contract.
728     /// @param _from The address holding the tokens being transferred
729     /// @param _to The address of the recipient
730     /// @param _amount The amount of tokens to be transferred
731     /// @return True if the transfer was successful
732     function doTransfer(address _from, address _to, uint _amount
733     ) internal {
734 
735            if (_amount == 0) {
736                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
737                return;
738            }
739 
740            require(parentSnapShotBlock < block.number);
741 
742            // Do not allow transfer to 0x0 or the token contract itself
743            require((_to != 0) && (_to != address(this)));
744 
745            // If the amount being transfered is more than the balance of the
746            //  account the transfer throws
747            var previousBalanceFrom = balanceOfAt(_from, block.number);
748 
749            require(previousBalanceFrom >= _amount);
750 
751            // Alerts the token controller of the transfer
752            if (isContract(controller)) {
753                require(TokenController(controller).onTransfer(_from, _to, _amount));
754            }
755 
756            // First update the balance array with the new value for the address
757            //  sending the tokens
758            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
759 
760            // Then update the balance array with the new value for the address
761            //  receiving the tokens
762            var previousBalanceTo = balanceOfAt(_to, block.number);
763            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
764            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
765 
766            // An event to make the transfer easy to find on the blockchain
767            Transfer(_from, _to, _amount);
768 
769     }
770 
771     /// @param _owner The address that's balance is being requested
772     /// @return The balance of `_owner` at the current block
773     function balanceOf(address _owner) public constant returns (uint256 balance) {
774         return balanceOfAt(_owner, block.number);
775     }
776 
777     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
778     ///  its behalf. This is a modified version of the ERC20 approve function
779     ///  to be a little bit safer
780     /// @param _spender The address of the account able to transfer the tokens
781     /// @param _amount The amount of tokens to be approved for transfer
782     /// @return True if the approval was successful
783     function approve(address _spender, uint256 _amount) public returns (bool success) {
784         require(transfersEnabled);
785 
786         // To change the approve amount you first have to reduce the addresses`
787         //  allowance to zero by calling `approve(_spender,0)` if it is not
788         //  already 0 to mitigate the race condition described here:
789         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
790         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
791 
792         // Alerts the token controller of the approve function call
793         if (isContract(controller)) {
794             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
795         }
796 
797         allowed[msg.sender][_spender] = _amount;
798         Approval(msg.sender, _spender, _amount);
799         return true;
800     }
801 
802     /// @dev This function makes it easy to read the `allowed[]` map
803     /// @param _owner The address of the account that owns the token
804     /// @param _spender The address of the account able to transfer the tokens
805     /// @return Amount of remaining tokens of _owner that _spender is allowed
806     ///  to spend
807     function allowance(address _owner, address _spender
808     ) public constant returns (uint256 remaining) {
809         return allowed[_owner][_spender];
810     }
811 
812     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
813     ///  its behalf, and then a function is triggered in the contract that is
814     ///  being approved, `_spender`. This allows users to use their tokens to
815     ///  interact with contracts in one function call instead of two
816     /// @param _spender The address of the contract able to transfer the tokens
817     /// @param _amount The amount of tokens to be approved for transfer
818     /// @return True if the function call was successful
819     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
820     ) public returns (bool success) {
821         require(approve(_spender, _amount));
822 
823         ApproveAndCallFallBack(_spender).receiveApproval(
824             msg.sender,
825             _amount,
826             this,
827             _extraData
828         );
829 
830         return true;
831     }
832 
833     /// @dev This function makes it easy to get the total number of tokens
834     /// @return The total number of tokens
835     function totalSupply() public constant returns (uint) {
836         return totalSupplyAt(block.number);
837     }
838 
839 
840 ////////////////
841 // Query balance and totalSupply in History
842 ////////////////
843 
844     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
845     /// @param _owner The address from which the balance will be retrieved
846     /// @param _blockNumber The block number when the balance is queried
847     /// @return The balance at `_blockNumber`
848     function balanceOfAt(address _owner, uint _blockNumber) public constant
849         returns (uint) {
850 
851         // These next few lines are used when the balance of the token is
852         //  requested before a check point was ever created for this token, it
853         //  requires that the `parentToken.balanceOfAt` be queried at the
854         //  genesis block for that token as this contains initial balance of
855         //  this token
856         if ((balances[_owner].length == 0)
857             || (balances[_owner][0].fromBlock > _blockNumber)) {
858             if (address(parentToken) != 0) {
859                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
860             } else {
861                 // Has no parent
862                 return 0;
863             }
864 
865         // This will return the expected balance during normal situations
866         } else {
867             return getValueAt(balances[_owner], _blockNumber);
868         }
869     }
870 
871     /// @notice Total amount of tokens at a specific `_blockNumber`.
872     /// @param _blockNumber The block number when the totalSupply is queried
873     /// @return The total amount of tokens at `_blockNumber`
874     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
875 
876         // These next few lines are used when the totalSupply of the token is
877         //  requested before a check point was ever created for this token, it
878         //  requires that the `parentToken.totalSupplyAt` be queried at the
879         //  genesis block for this token as that contains totalSupply of this
880         //  token at this block number.
881         if ((totalSupplyHistory.length == 0)
882             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
883             if (address(parentToken) != 0) {
884                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
885             } else {
886                 return 0;
887             }
888 
889         // This will return the expected totalSupply during normal situations
890         } else {
891             return getValueAt(totalSupplyHistory, _blockNumber);
892         }
893     }
894 
895 ////////////////
896 // Clone Token Method
897 ////////////////
898 
899     /// @notice Creates a new clone token with the initial distribution being
900     ///  this token at `_snapshotBlock`
901     /// @param _cloneTokenName Name of the clone token
902     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
903     /// @param _cloneTokenSymbol Symbol of the clone token
904     /// @param _snapshotBlock Block when the distribution of the parent token is
905     ///  copied to set the initial distribution of the new clone token;
906     ///  if the block is zero than the actual block, the current block is used
907     /// @param _transfersEnabled True if transfers are allowed in the clone
908     /// @return The address of the new MiniMeToken Contract
909     function createCloneToken(
910         string _cloneTokenName,
911         uint8 _cloneDecimalUnits,
912         string _cloneTokenSymbol,
913         uint _snapshotBlock,
914         bool _transfersEnabled
915         ) public returns(address) {
916         if (_snapshotBlock == 0) _snapshotBlock = block.number;
917         MiniMeToken cloneToken = tokenFactory.createCloneToken(
918             this,
919             _snapshotBlock,
920             _cloneTokenName,
921             _cloneDecimalUnits,
922             _cloneTokenSymbol,
923             _transfersEnabled
924             );
925 
926         cloneToken.changeController(msg.sender);
927 
928         // An event to make the token easy to find on the blockchain
929         NewCloneToken(address(cloneToken), _snapshotBlock);
930         return address(cloneToken);
931     }
932 
933 ////////////////
934 // Generate and destroy tokens
935 ////////////////
936 
937     /// @notice Generates `_amount` tokens that are assigned to `_owner`
938     /// @param _owner The address that will be assigned the new tokens
939     /// @param _amount The quantity of tokens generated
940     /// @return True if the tokens are generated correctly
941     function generateTokens(address _owner, uint _amount
942     ) public onlyController returns (bool) {
943         uint curTotalSupply = totalSupply();
944         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
945         uint previousBalanceTo = balanceOf(_owner);
946         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
947         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
948         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
949         Transfer(0, _owner, _amount);
950         return true;
951     }
952 
953 
954     /// @notice Burns `_amount` tokens from `_owner`
955     /// @param _owner The address that will lose the tokens
956     /// @param _amount The quantity of tokens to burn
957     /// @return True if the tokens are burned correctly
958     function destroyTokens(address _owner, uint _amount
959     ) onlyController public returns (bool) {
960         uint curTotalSupply = totalSupply();
961         require(curTotalSupply >= _amount);
962         uint previousBalanceFrom = balanceOf(_owner);
963         require(previousBalanceFrom >= _amount);
964         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
965         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
966         Transfer(_owner, 0, _amount);
967         return true;
968     }
969 
970 ////////////////
971 // Enable tokens transfers
972 ////////////////
973 
974 
975     /// @notice Enables token holders to transfer their tokens freely if true
976     /// @param _transfersEnabled True if transfers are allowed in the clone
977     function enableTransfers(bool _transfersEnabled) public onlyController {
978         transfersEnabled = _transfersEnabled;
979     }
980 
981 ////////////////
982 // Internal helper functions to query and set a value in a snapshot array
983 ////////////////
984 
985     /// @dev `getValueAt` retrieves the number of tokens at a given block number
986     /// @param checkpoints The history of values being queried
987     /// @param _block The block number to retrieve the value at
988     /// @return The number of tokens being queried
989     function getValueAt(Checkpoint[] storage checkpoints, uint _block
990     ) constant internal returns (uint) {
991         if (checkpoints.length == 0) return 0;
992 
993         // Shortcut for the actual value
994         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
995             return checkpoints[checkpoints.length-1].value;
996         if (_block < checkpoints[0].fromBlock) return 0;
997 
998         // Binary search of the value in the array
999         uint min = 0;
1000         uint max = checkpoints.length-1;
1001         while (max > min) {
1002             uint mid = (max + min + 1)/ 2;
1003             if (checkpoints[mid].fromBlock<=_block) {
1004                 min = mid;
1005             } else {
1006                 max = mid-1;
1007             }
1008         }
1009         return checkpoints[min].value;
1010     }
1011 
1012     /// @dev `updateValueAtNow` used to update the `balances` map and the
1013     ///  `totalSupplyHistory`
1014     /// @param checkpoints The history of data being updated
1015     /// @param _value The new number of tokens
1016     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
1017     ) internal  {
1018         if ((checkpoints.length == 0)
1019         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
1020                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
1021                newCheckPoint.fromBlock =  uint128(block.number);
1022                newCheckPoint.value = uint128(_value);
1023            } else {
1024                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
1025                oldCheckPoint.value = uint128(_value);
1026            }
1027     }
1028 
1029     /// @dev Internal function to determine if an address is a contract
1030     /// @param _addr The address being queried
1031     /// @return True if `_addr` is a contract
1032     function isContract(address _addr) constant internal returns(bool) {
1033         uint size;
1034         if (_addr == 0) return false;
1035         assembly {
1036             size := extcodesize(_addr)
1037         }
1038         return size>0;
1039     }
1040 
1041     /// @dev Helper function to return a min betwen the two uints
1042     function min(uint a, uint b) pure internal returns (uint) {
1043         return a < b ? a : b;
1044     }
1045 
1046     /// @notice The fallback function: If the contract's controller has not been
1047     ///  set to 0, then the `proxyPayment` method is called which relays the
1048     ///  ether and creates tokens as described in the token controller contract
1049     function () public payable {
1050         require(isContract(controller));
1051         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
1052     }
1053 
1054 //////////
1055 // Safety Methods
1056 //////////
1057 
1058     /// @notice This method can be used by the controller to extract mistakenly
1059     ///  sent tokens to this contract.
1060     /// @param _token The address of the token contract that you want to recover
1061     ///  set to 0 in case you want to extract ether.
1062     function claimTokens(address _token) public onlyController {
1063         if (_token == 0x0) {
1064             controller.transfer(this.balance);
1065             return;
1066         }
1067 
1068         MiniMeToken token = MiniMeToken(_token);
1069         uint balance = token.balanceOf(this);
1070         token.transfer(controller, balance);
1071         ClaimedTokens(_token, controller, balance);
1072     }
1073 
1074 ////////////////
1075 // Events
1076 ////////////////
1077     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1078     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1079     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
1080     event Approval(
1081         address indexed _owner,
1082         address indexed _spender,
1083         uint256 _amount
1084         );
1085 
1086 }
1087 
1088 
1089 ////////////////
1090 // MiniMeTokenFactory
1091 ////////////////
1092 
1093 /// @dev This contract is used to generate clone contracts from a contract.
1094 ///  In solidity this is the way to create a contract from a contract of the
1095 ///  same class
1096 contract MiniMeTokenFactory {
1097 
1098     /// @notice Update the DApp by creating a new token with new functionalities
1099     ///  the msg.sender becomes the controller of this clone token
1100     /// @param _parentToken Address of the token being cloned
1101     /// @param _snapshotBlock Block of the parent token that will
1102     ///  determine the initial distribution of the clone token
1103     /// @param _tokenName Name of the new token
1104     /// @param _decimalUnits Number of decimals of the new token
1105     /// @param _tokenSymbol Token Symbol for the new token
1106     /// @param _transfersEnabled If true, tokens will be able to be transferred
1107     /// @return The address of the new token contract
1108     function createCloneToken(
1109         address _parentToken,
1110         uint _snapshotBlock,
1111         string _tokenName,
1112         uint8 _decimalUnits,
1113         string _tokenSymbol,
1114         bool _transfersEnabled
1115     ) public returns (MiniMeToken) {
1116         MiniMeToken newToken = new MiniMeToken(
1117             this,
1118             _parentToken,
1119             _snapshotBlock,
1120             _tokenName,
1121             _decimalUnits,
1122             _tokenSymbol,
1123             _transfersEnabled
1124             );
1125 
1126         newToken.changeController(msg.sender);
1127         return newToken;
1128     }
1129 }
1130 
1131 contract Crowdsale is Presale, Pausable, CanReclaimToken {
1132 
1133   using SafeMath for uint256;
1134   address public whitelistAddress;
1135   address public wallet; //wallet where the funds collected are transfered
1136   MiniMeToken public token; //ERC20 Token
1137   uint256 private weiRaised = 0; //WeiRaised during the public Sale
1138   uint256 private cap = 0; //Cap of the public Sale in Wei
1139   bool private publicSaleInitialized = false;
1140   bool private finalized = false;
1141   uint256 private tokensSold = 0; //tokens sold during the entire sale
1142   uint256 private startTime; //start time of the public sale initialized after the presale is over
1143   uint256 private endTime; //endtime of the public sale
1144   uint256 public maxTokens;
1145   mapping(address => uint256) public contributions; //contributions of each investor
1146   mapping(address => uint256) public investorCaps; //for whitelisting
1147   address[] public investors; //investor list who participate in the ICO
1148   address[] public founders; //list of founders
1149   address[] public advisors; //list of advisors
1150   VestingTrustee public trustee;
1151   address public reserveWallet; //reserveWallet where the unsold tokens will be sent to
1152 
1153   //Rate for each tier (no of tokens for 1 ETH)
1154   //Max wei for each tier
1155   struct Tier {
1156     uint256 rate;
1157     uint256 max;
1158   }
1159 
1160   uint public privateSaleTokensAvailable;
1161   uint public privateSaleTokensSold = 0;
1162   uint public publicTokensAvailable;
1163 
1164   uint8 public totalTiers = 0; //total Tiers in the public sale
1165   bool public tiersInitialized = false;
1166   uint256 public maxTiers = 6; //max tiers that can be in the publicsale
1167   Tier[6] public tiers; //array of tiers
1168 
1169   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
1170   enum Stage { Preparing, Presale, PresaleFinished, PublicSale, Success, Finalized }
1171 
1172   function Crowdsale(
1173     uint256 _presaleStartTime, //presale start time
1174     uint256 _presaleDuration, //presale duration in days
1175     uint256 _presaleRate, // presale rate. ie No of tokens per 1 ETH
1176     uint256 _presaleCap, // max wei that can raised
1177     address erc20Token, // Token used for the crowdsale
1178     address _wallet,
1179     uint8 _tiers,
1180     uint256 _cap,
1181     address _reserveWallet)
1182     public
1183     Presale(_presaleStartTime, _presaleDuration, _presaleRate, _presaleCap)
1184     {
1185       require(_wallet != address(0));
1186       require(erc20Token != address(0));
1187       require(_tiers > 0 && _tiers <= maxTiers);
1188       require(_cap > 0);
1189       require(_reserveWallet != address(0));
1190       token = MiniMeToken(erc20Token);
1191       wallet = _wallet;
1192       totalTiers = _tiers;
1193       cap = _cap;
1194       reserveWallet = _reserveWallet;
1195       trustee = new VestingTrustee(erc20Token);
1196       maxTokens = 1000000000 * (10 ** 18); // 1 B tokens
1197       tokensSold = token.totalSupply();
1198       privateSaleTokensAvailable = maxTokens.mul(22).div(100);
1199       publicTokensAvailable = maxTokens.mul(28).div(100);
1200       super.addAddressToWhitelist(msg.sender);
1201     }
1202 
1203   function() public payable {
1204     buyTokens(msg.sender, msg.value);
1205   }
1206 
1207   function getStage() public constant returns(Stage) {
1208     if (finalized) return Stage.Finalized;
1209     if (!tiersInitialized || !Presale.hasStarted()) return Stage.Preparing;
1210     if (!Presale.hasEnded()) return Stage.Presale;
1211     if (Presale.hasEnded() && !hasStarted()) return Stage.PresaleFinished;
1212     if (!hasEnded()) return Stage.PublicSale;
1213     if (hasEnded()) return Stage.Success;
1214     return Stage.Preparing;
1215   }
1216 
1217   modifier inStage(Stage _stage) {
1218     require(getStage() == _stage);
1219     _;
1220   }
1221 
1222   // rates for each tier and total wei in that tiers
1223   // they are added up together
1224   function initTiers(uint256[] rates, uint256[] totalWeis) public onlyWhitelisted returns(uint256) {
1225     require(token.controller() == address(this));
1226     require(!tiersInitialized);
1227     require(rates.length == totalTiers && rates.length == totalWeis.length);
1228     uint256 tierMax = 0;
1229 
1230     for (uint8 i=0; i < totalTiers; i++) {
1231 
1232       require(totalWeis[i] > 0 && rates[i] > 0);
1233 
1234       tierMax = tierMax.add(totalWeis[i]);
1235       tiers[i] = Tier({
1236         rate: rates[i],
1237         max: tierMax
1238       });
1239     }
1240 
1241     require(tierMax == cap);
1242     tiersInitialized = true;
1243     return tierMax;
1244   }
1245 
1246   // function for whitelisting investors with caps
1247   function setCapForParticipants(address[] participants, uint256[] caps) onlyWhitelisted public  {
1248     require(participants.length <= 50 && participants.length == caps.length);
1249     for (uint8 i=0; i < participants.length; i++) {
1250       investorCaps[participants[i]] = caps[i];
1251     }
1252   }
1253 
1254 
1255   function addGrant(address assignee, uint256 value, bool isFounder) public onlyWhitelisted whenNotPaused {
1256     require(value > 0);
1257     require(assignee != address(0));
1258     uint256 start;
1259     uint256 cliff;
1260     uint256 vestingPercentage;
1261     uint256 initialTokens;
1262     if(isFounder) {
1263       start = now;
1264       cliff = start + 12*30 days; //12 months
1265       vestingPercentage = 20; //20%
1266       founders.push(assignee);
1267     }
1268     else {
1269       // for advisors
1270       // transfer 10% of the tokens at start
1271       initialTokens = value.mul(10).div(100);
1272       transferTokens(assignee, initialTokens);
1273       start = now;
1274       cliff = start + 6*30 days;  //6 months
1275       vestingPercentage = 15; //15% for each installments
1276       advisors.push(assignee);
1277     }
1278 
1279     uint256 end = now + 3 * 1 years; //3 years
1280     uint256 installmentLength = 6 * 30 days; // 6 month installments
1281     bool revokable = true;
1282     transferTokens(trustee, value.sub(initialTokens));
1283     trustee.grant(assignee, value, start, cliff, end, installmentLength, vestingPercentage, initialTokens, revokable);
1284   }
1285 
1286   // called by the owner to close the crowdsale
1287   function finalize() public onlyWhitelisted inStage(Stage.Success) {
1288     require(!finalized);
1289     //trustee's ownership is transfered from the crowdsale to owner of the contract
1290     trustee.transferOwnership(msg.sender);
1291     //enable token transfer
1292     token.enableTransfers(true);
1293     //generate the unsold tokens to the reserve
1294     uint256 unsold = maxTokens.sub(token.totalSupply());
1295     transferTokens(reserveWallet, unsold);
1296 
1297     // change the token's controller to a zero Address so that it cannot
1298     // generate or destroy tokens
1299     token.changeController(0x0);
1300     finalized = true;
1301   }
1302 
1303   //start the public sale manually after the presale is over, duration is in days
1304   function startPublicSale(uint _startTime, uint _duration) public onlyWhitelisted inStage(Stage.PresaleFinished) {
1305     require(_startTime >= now);
1306     require(_duration > 0);
1307     startTime = _startTime;
1308     endTime = _startTime + _duration * 1 days;
1309     publicSaleInitialized = true;
1310   }
1311 
1312   // total wei raised in the presale and public sale
1313   function totalWei() public constant returns(uint256) {
1314     uint256 presaleWei = super.totalWei();
1315     return presaleWei.add(weiRaised);
1316   }
1317 
1318   function totalPublicSaleWei() public constant returns(uint256) {
1319     return weiRaised;
1320   }
1321   // total cap of the presale and public sale
1322   function totalCap() public constant returns(uint256) {
1323     uint256 presaleCap = super.totalCap();
1324     return presaleCap.add(cap);
1325   }
1326 
1327   // Total tokens sold duing the presale and public sale.
1328   // Total tokens has to divided by 10^18
1329   function totalTokens() public constant returns(uint256) {
1330     return tokensSold;
1331   }
1332 
1333   // MAIN BUYING Function
1334   function buyTokens(address purchaser, uint256 value) internal  whenNotPaused returns(uint256) {
1335     require(value > 0);
1336     Stage stage = getStage();
1337     require(stage == Stage.Presale || stage == Stage.PublicSale);
1338 
1339     //the purchase amount cannot be more than the whitelisted cap
1340     uint256 purchaseAmount = Math.min256(value, investorCaps[purchaser].sub(contributions[purchaser]));
1341     require(purchaseAmount > 0);
1342     uint256 numTokens;
1343 
1344     //call the presale contract
1345     if (stage == Stage.Presale) {
1346       if (Presale.totalWei().add(purchaseAmount) > Presale.totalCap()) {
1347         purchaseAmount = Presale.capRemaining();
1348       }
1349       numTokens = Presale.buyTokens(purchaser, purchaseAmount);
1350     } else if (stage == Stage.PublicSale) {
1351 
1352       uint totalWei = weiRaised.add(purchaseAmount);
1353       uint8 currentTier = getTier(weiRaised); //get current tier
1354       if (totalWei >= cap) { // will TOTAL_CAP(HARD_CAP) of the public sale be reached ?
1355         totalWei = cap;
1356         //purchase amount can be only be (CAP - WeiRaised)
1357         purchaseAmount = cap.sub(weiRaised);
1358       }
1359 
1360       // if the totalWei( weiRaised + msg.value) fits within current cap
1361       // number of tokens would be rate * purchaseAmount
1362       if (totalWei <= tiers[currentTier].max) {
1363         numTokens = purchaseAmount.mul(tiers[currentTier].rate);
1364       } else {
1365         //wei remaining in the current tier
1366         uint remaining = tiers[currentTier].max.sub(weiRaised);
1367         numTokens = remaining.mul(tiers[currentTier].rate);
1368 
1369         //wei in the next tier
1370         uint256 excess = totalWei.sub(tiers[currentTier].max);
1371         //number of tokens  = wei remaining in the next tier * rate of the next tier
1372         numTokens = numTokens.add(excess.mul(tiers[currentTier + 1].rate));
1373       }
1374 
1375       // update the total raised so far
1376       weiRaised = weiRaised.add(purchaseAmount);
1377     }
1378 
1379     // total tokens sold in the entire sale
1380     require(tokensSold.add(numTokens) <= publicTokensAvailable);
1381     tokensSold = tokensSold.add(numTokens);
1382 
1383     // forward funds to the wallet
1384     forwardFunds(purchaser, purchaseAmount);
1385     // transfer the tokens to the purchaser
1386     transferTokens(purchaser, numTokens);
1387 
1388     // return the remaining unused wei back
1389     if (value.sub(purchaseAmount) > 0) {
1390       msg.sender.transfer(value.sub(purchaseAmount));
1391     }
1392 
1393     //event
1394     TokenPurchase(purchaser, numTokens, purchaseAmount);
1395 
1396     return numTokens;
1397   }
1398 
1399 
1400 
1401   function forwardFunds(address purchaser, uint256 value) internal {
1402     //add contribution to the purchaser
1403     contributions[purchaser] = contributions[purchaser].add(value);
1404     wallet.transfer(value);
1405   }
1406 
1407   function changeEndTime(uint _endTime) public onlyWhitelisted {
1408     endTime = _endTime;
1409   }
1410 
1411   function changeFundsWallet(address _newWallet) public onlyWhitelisted {
1412     require(_newWallet != address(0));
1413     wallet = _newWallet;
1414   }
1415 
1416   function changeTokenController() onlyWhitelisted public {
1417     token.changeController(msg.sender);
1418   }
1419 
1420   function changeTrusteeOwner() onlyWhitelisted public {
1421     trustee.transferOwnership(msg.sender);
1422   }
1423   function changeReserveWallet(address _reserve) public onlyWhitelisted {
1424     require(_reserve != address(0));
1425     reserveWallet = _reserve;
1426   }
1427 
1428   function setWhitelistAddress(address _whitelist) public onlyWhitelisted {
1429     require(_whitelist != address(0));
1430     whitelistAddress = _whitelist;
1431   }
1432 
1433   function transferTokens(address to, uint256 value) internal {
1434     uint totalSupply = token.totalSupply();
1435     require(totalSupply.add(value) <= maxTokens);
1436     token.generateTokens(to, value);
1437   }
1438 
1439   function sendPrivateSaleTokens(address to, uint256 value) public whenNotPaused onlyWhitelisted {
1440     require(privateSaleTokensSold.add(value) <= privateSaleTokensAvailable);
1441     privateSaleTokensSold = privateSaleTokensSold.add(value);
1442     transferTokens(to, value);
1443   }
1444 
1445   function hasEnded() internal constant returns(bool) {
1446     return now > endTime || weiRaised >= cap;
1447   }
1448 
1449   function hasStarted() internal constant returns(bool) {
1450     return publicSaleInitialized && now >= startTime;
1451   }
1452 
1453   function getTier(uint256 _weiRaised) internal constant returns(uint8) {
1454     for (uint8 i = 0; i < totalTiers; i++) {
1455       if (_weiRaised < tiers[i].max) {
1456         return i;
1457       }
1458     }
1459     //wont reach but for safety
1460     return totalTiers + 1;
1461   }
1462 
1463 
1464 
1465   function getCurrentTier() public constant returns(uint8) {
1466     return getTier(weiRaised);
1467   }
1468 
1469 
1470   // functions for the mini me token
1471   function proxyPayment(address _owner) public payable returns(bool) {
1472     return true;
1473   }
1474 
1475   function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
1476     return true;
1477   }
1478 
1479   function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
1480     return true;
1481   }
1482 
1483   function getTokenSaleTime() public constant returns(uint256, uint256) {
1484     return (startTime, endTime);
1485   }
1486 }