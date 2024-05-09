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
165 contract Presale {
166 
167   using SafeMath for uint256;
168   uint256 private weiRaised;
169   uint256 private startTime;
170   uint256 private endTime;
171   uint256 private rate;
172 
173   uint256 private cap;
174 
175   function Presale(uint256 _startTime, uint256 duration, uint256 _rate, uint256 _cap) public {
176     require(_rate > 0);
177     require(_cap > 0);
178     require(_startTime >= now);
179     require(duration > 0);
180 
181     rate = _rate;
182     cap = _cap;
183     startTime = _startTime;
184     endTime = startTime + duration * 1 days;
185     weiRaised = 0;
186   }
187 
188   function totalWei() public constant returns(uint256) {
189     return weiRaised;
190   }
191 
192   function capRemaining() public constant returns(uint256) {
193     return cap.sub(weiRaised);
194   }
195 
196   function totalCap() public constant returns(uint256) {
197     return cap;
198   }
199 
200   function buyTokens(address purchaser, uint256 value) internal returns(uint256) {
201     require(validPurchase(value));
202     uint256 tokens = rate.mul(value);
203     weiRaised = weiRaised.add(value);
204     return tokens;
205   }
206 
207   function hasEnded() internal constant returns(bool) {
208     return now > endTime || weiRaised >= cap;
209   }
210 
211   function hasStarted() internal constant returns(bool) {
212     return now > startTime;
213   }
214 
215   function validPurchase(uint256 value) internal view returns (bool) {
216     bool withinCap = weiRaised.add(value) <= cap;
217     return withinCap && withinPeriod();
218   }
219 
220   function presaleRate() public view returns(uint256) {
221     return rate;
222   }
223 
224   function withinPeriod () private constant returns(bool) {
225     return now >= startTime && now <= endTime;
226   }
227 }
228 
229 /**
230  * @title SafeERC20
231  * @dev Wrappers around ERC20 operations that throw on failure.
232  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
233  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
234  */
235 library SafeERC20 {
236   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
237     assert(token.transfer(to, value));
238   }
239 
240   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
241     assert(token.transferFrom(from, to, value));
242   }
243 
244   function safeApprove(ERC20 token, address spender, uint256 value) internal {
245     assert(token.approve(spender, value));
246   }
247 }
248 
249 /**
250  * @title Contracts that should be able to recover tokens
251  * @author SylTi
252  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
253  * This will prevent any accidental loss of tokens.
254  */
255 contract CanReclaimToken is Ownable {
256   using SafeERC20 for ERC20Basic;
257 
258   /**
259    * @dev Reclaim all ERC20Basic compatible tokens
260    * @param token ERC20Basic The address of the token contract
261    */
262   function reclaimToken(ERC20Basic token) external onlyOwner {
263     uint256 balance = token.balanceOf(this);
264     token.safeTransfer(owner, balance);
265   }
266 
267 }
268 
269 /// @title Vesting trustee contract for erc20 token.
270 contract VestingTrustee is Ownable, CanReclaimToken {
271     using SafeMath for uint256;
272 
273     // erc20 token contract.
274     ERC20 public token;
275 
276     // Vesting grant for a speicifc holder.
277     struct Grant {
278         uint256 value;
279         uint256 start;
280         uint256 cliff;
281         uint256 end;
282         uint256 installmentLength; // In seconds.
283         uint256 transferred;
284         bool revokable;
285         uint256 prevested;
286         uint256 vestingPercentage;
287     }
288 
289     // Holder to grant information mapping.
290     mapping (address => Grant) public grants;
291 
292     // Total tokens available for vesting.
293     uint256 public totalVesting;
294 
295     event NewGrant(address indexed _from, address indexed _to, uint256 _value);
296     event TokensUnlocked(address indexed _to, uint256 _value);
297     event GrantRevoked(address indexed _holder, uint256 _refund);
298 
299     /// @dev Constructor that initializes the address of the  token contract.
300     /// @param _token erc20 The address of the previously deployed token contract.
301     function VestingTrustee(address _token) {
302         require(_token != address(0));
303 
304         token = ERC20(_token);
305     }
306 
307     /// @dev Grant tokens to a specified address.
308     /// @param _to address The holder address.
309     /// @param _value uint256 The amount of tokens to be granted.
310     /// @param _start uint256 The beginning of the vesting period.
311     /// @param _cliff uint256 Duration of the cliff period (when the first installment is made).
312     /// @param _end uint256 The end of the vesting period.
313     /// @param _installmentLength uint256 The length of each vesting installment (in seconds).
314     /// @param _revokable bool Whether the grant is revokable or not.
315     function grant(address _to, uint256 _value, uint256 _start, uint256 _cliff, uint256 _end,
316         uint256 _installmentLength, uint256 vestingPercentage, uint256 prevested, bool _revokable)
317         external onlyOwner {
318 
319         require(_to != address(0));
320         require(_to != address(this)); // Don't allow holder to be this contract.
321         require(_value > 0);
322         require(_value.sub(prevested) > 0);
323         require(vestingPercentage > 0);
324 
325         // Require that every holder can be granted tokens only once.
326         require(grants[_to].value == 0);
327 
328         // Require for time ranges to be consistent and valid.
329         require(_start <= _cliff && _cliff <= _end);
330 
331         // Require installment length to be valid and no longer than (end - start).
332         require(_installmentLength > 0 && _installmentLength <= _end.sub(_start));
333 
334         // Grant must not exceed the total amount of tokens currently available for vesting.
335         require(totalVesting.add(_value.sub(prevested)) <= token.balanceOf(address(this)));
336 
337         // Assign a new grant.
338         grants[_to] = Grant({
339             value: _value,
340             start: _start,
341             cliff: _cliff,
342             end: _end,
343             installmentLength: _installmentLength,
344             transferred: prevested,
345             revokable: _revokable,
346             prevested: prevested,
347             vestingPercentage: vestingPercentage
348         });
349 
350         totalVesting = totalVesting.add(_value.sub(prevested));
351         NewGrant(msg.sender, _to, _value);
352     }
353 
354     /// @dev Revoke the grant of tokens of a specifed address.
355     /// @param _holder The address which will have its tokens revoked.
356     function revoke(address _holder) public onlyOwner {
357         Grant memory grant = grants[_holder];
358 
359         // Grant must be revokable.
360         require(grant.revokable);
361 
362         // Calculate amount of remaining tokens that are still available to be
363         // returned to owner.
364         uint256 refund = grant.value.sub(grant.transferred);
365 
366         // Remove grant information.
367         delete grants[_holder];
368 
369         // Update total vesting amount and transfer previously calculated tokens to owner.
370         totalVesting = totalVesting.sub(refund);
371         token.transfer(msg.sender, refund);
372 
373         GrantRevoked(_holder, refund);
374     }
375 
376     /// @dev Calculate the total amount of vested tokens of a holder at a given time.
377     /// @param _holder address The address of the holder.
378     /// @param _time uint256 The specific time to calculate against.
379     /// @return a uint256 Representing a holder's total amount of vested tokens.
380     function vestedTokens(address _holder, uint256 _time) external constant returns (uint256) {
381         Grant memory grant = grants[_holder];
382         if (grant.value == 0) {
383             return 0;
384         }
385 
386         return calculateVestedTokens(grant, _time);
387     }
388 
389     /// @dev Calculate amount of vested tokens at a specifc time.
390     /// @param _grant Grant The vesting grant.
391     /// @param _time uint256 The time to be checked
392     /// @return a uint256 Representing the amount of vested tokens of a specific grant.
393     function calculateVestedTokens(Grant _grant, uint256 _time) private constant returns (uint256) {
394         // If we're before the cliff, then nothing is vested.
395         if (_time < _grant.cliff) {
396             return _grant.prevested;
397         }
398 
399         // If we're after the end of the vesting period - everything is vested;
400         if (_time >= _grant.end) {
401             return _grant.value;
402         }
403 
404         // Calculate amount of installments past until now.
405         uint256 installmentsPast = _time.sub(_grant.cliff).div(_grant.installmentLength) + 1;
406 
407 
408         // Calculate and return installments that have passed according to vesting days that have passed.
409         return _grant.prevested.add(_grant.value.mul(installmentsPast.mul(_grant.vestingPercentage)).div(100));
410     }
411 
412     /// @dev Unlock vested tokens and transfer them to their holder.
413     /// @return a uint256 Representing the amount of vested tokens transferred to their holder.
414     function unlockVestedTokens() external {
415         Grant storage grant = grants[msg.sender];
416 
417         // Require that there will be funds left in grant to tranfser to holder.
418         require(grant.value != 0);
419 
420         // Get the total amount of vested tokens, acccording to grant.
421         uint256 vested = calculateVestedTokens(grant, now);
422         if (vested == 0) {
423             revert();
424         }
425 
426         // Make sure the holder doesn't transfer more than what he already has.
427         uint256 transferable = vested.sub(grant.transferred);
428         if (transferable == 0) {
429             revert();
430         }
431 
432         grant.transferred = grant.transferred.add(transferable);
433         totalVesting = totalVesting.sub(transferable);
434         token.transfer(msg.sender, transferable);
435         TokensUnlocked(msg.sender, transferable);
436     }
437 
438     function reclaimEther() external onlyOwner {
439       assert(owner.send(this.balance));
440     }
441 }
442 
443 contract Controlled {
444     /// @notice The address of the controller is the only address that can call
445     ///  a function with this modifier
446     modifier onlyController { require(msg.sender == controller); _; }
447 
448     address public controller;
449 
450     function Controlled() public { controller = msg.sender;}
451 
452     /// @notice Changes the controller of the contract
453     /// @param _newController The new controller of the contract
454     function changeController(address _newController) public onlyController {
455         controller = _newController;
456     }
457 }
458 
459 /// @dev The token controller contract must implement these functions
460 contract TokenController {
461     /// @notice Called when `_owner` sends ether to the MiniMe Token contract
462     /// @param _owner The address that sent the ether to create tokens
463     /// @return True if the ether is accepted, false if it throws
464     function proxyPayment(address _owner) public payable returns(bool);
465 
466     /// @notice Notifies the controller about a token transfer allowing the
467     ///  controller to react if desired
468     /// @param _from The origin of the transfer
469     /// @param _to The destination of the transfer
470     /// @param _amount The amount of the transfer
471     /// @return False if the controller does not authorize the transfer
472     function onTransfer(address _from, address _to, uint _amount) public returns(bool);
473 
474     /// @notice Notifies the controller about an approval allowing the
475     ///  controller to react if desired
476     /// @param _owner The address that calls `approve()`
477     /// @param _spender The spender in the `approve()` call
478     /// @param _amount The amount in the `approve()` call
479     /// @return False if the controller does not authorize the approval
480     function onApprove(address _owner, address _spender, uint _amount) public
481         returns(bool);
482 }
483 
484 /*
485     Copyright 2016, Jordi Baylina
486 
487     This program is free software: you can redistribute it and/or modify
488     it under the terms of the GNU General Public License as published by
489     the Free Software Foundation, either version 3 of the License, or
490     (at your option) any later version.
491 
492     This program is distributed in the hope that it will be useful,
493     but WITHOUT ANY WARRANTY; without even the implied warranty of
494     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
495     GNU General Public License for more details.
496 
497     You should have received a copy of the GNU General Public License
498     along with this program.  If not, see <http://www.gnu.org/licenses/>.
499  */
500 
501 /// @title MiniMeToken Contract
502 /// @author Jordi Baylina
503 /// @dev This token contract's goal is to make it easy for anyone to clone this
504 ///  token using the token distribution at a given block, this will allow DAO's
505 ///  and DApps to upgrade their features in a decentralized manner without
506 ///  affecting the original token
507 /// @dev It is ERC20 compliant, but still needs to under go further testing.
508 
509 
510 
511 
512 contract ApproveAndCallFallBack {
513     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
514 }
515 
516 /// @dev The actual token contract, the default controller is the msg.sender
517 ///  that deploys the contract, so usually this token will be deployed by a
518 ///  token controller contract, which Giveth will call a "Campaign"
519 contract MiniMeToken is Controlled {
520 
521     string public name;                //The Token's name: e.g. DigixDAO Tokens
522     uint8 public decimals;             //Number of decimals of the smallest unit
523     string public symbol;              //An identifier: e.g. REP
524     string public version = 'MMT_0.2'; //An arbitrary versioning scheme
525 
526 
527     /// @dev `Checkpoint` is the structure that attaches a block number to a
528     ///  given value, the block number attached is the one that last changed the
529     ///  value
530     struct  Checkpoint {
531 
532         // `fromBlock` is the block number that the value was generated from
533         uint128 fromBlock;
534 
535         // `value` is the amount of tokens at a specific block number
536         uint128 value;
537     }
538 
539     // `parentToken` is the Token address that was cloned to produce this token;
540     //  it will be 0x0 for a token that was not cloned
541     MiniMeToken public parentToken;
542 
543     // `parentSnapShotBlock` is the block number from the Parent Token that was
544     //  used to determine the initial distribution of the Clone Token
545     uint public parentSnapShotBlock;
546 
547     // `creationBlock` is the block number that the Clone Token was created
548     uint public creationBlock;
549 
550     // `balances` is the map that tracks the balance of each address, in this
551     //  contract when the balance changes the block number that the change
552     //  occurred is also included in the map
553     mapping (address => Checkpoint[]) balances;
554 
555     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
556     mapping (address => mapping (address => uint256)) allowed;
557 
558     // Tracks the history of the `totalSupply` of the token
559     Checkpoint[] totalSupplyHistory;
560 
561     // Flag that determines if the token is transferable or not.
562     bool public transfersEnabled;
563 
564     // The factory used to create new clone tokens
565     MiniMeTokenFactory public tokenFactory;
566 
567 ////////////////
568 // Constructor
569 ////////////////
570 
571     /// @notice Constructor to create a MiniMeToken
572     /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
573     ///  will create the Clone token contracts, the token factory needs to be
574     ///  deployed first
575     /// @param _parentToken Address of the parent token, set to 0x0 if it is a
576     ///  new token
577     /// @param _parentSnapShotBlock Block of the parent token that will
578     ///  determine the initial distribution of the clone token, set to 0 if it
579     ///  is a new token
580     /// @param _tokenName Name of the new token
581     /// @param _decimalUnits Number of decimals of the new token
582     /// @param _tokenSymbol Token Symbol for the new token
583     /// @param _transfersEnabled If true, tokens will be able to be transferred
584     function MiniMeToken(
585         address _tokenFactory,
586         address _parentToken,
587         uint _parentSnapShotBlock,
588         string _tokenName,
589         uint8 _decimalUnits,
590         string _tokenSymbol,
591         bool _transfersEnabled
592     ) public {
593         tokenFactory = MiniMeTokenFactory(_tokenFactory);
594         name = _tokenName;                                 // Set the name
595         decimals = _decimalUnits;                          // Set the decimals
596         symbol = _tokenSymbol;                             // Set the symbol
597         parentToken = MiniMeToken(_parentToken);
598         parentSnapShotBlock = _parentSnapShotBlock;
599         transfersEnabled = _transfersEnabled;
600         creationBlock = block.number;
601     }
602 
603 
604 ///////////////////
605 // ERC20 Methods
606 ///////////////////
607 
608     /// @notice Send `_amount` tokens to `_to` from `msg.sender`
609     /// @param _to The address of the recipient
610     /// @param _amount The amount of tokens to be transferred
611     /// @return Whether the transfer was successful or not
612     function transfer(address _to, uint256 _amount) public returns (bool success) {
613         require(transfersEnabled);
614         doTransfer(msg.sender, _to, _amount);
615         return true;
616     }
617 
618     /// @notice Send `_amount` tokens to `_to` from `_from` on the condition it
619     ///  is approved by `_from`
620     /// @param _from The address holding the tokens being transferred
621     /// @param _to The address of the recipient
622     /// @param _amount The amount of tokens to be transferred
623     /// @return True if the transfer was successful
624     function transferFrom(address _from, address _to, uint256 _amount
625     ) public returns (bool success) {
626 
627         // The controller of this contract can move tokens around at will,
628         //  this is important to recognize! Confirm that you trust the
629         //  controller of this contract, which in most situations should be
630         //  another open source smart contract or 0x0
631         if (msg.sender != controller) {
632             require(transfersEnabled);
633 
634             // The standard ERC 20 transferFrom functionality
635             require(allowed[_from][msg.sender] >= _amount);
636             allowed[_from][msg.sender] -= _amount;
637         }
638         doTransfer(_from, _to, _amount);
639         return true;
640     }
641 
642     /// @dev This is the actual transfer function in the token contract, it can
643     ///  only be called by other functions in this contract.
644     /// @param _from The address holding the tokens being transferred
645     /// @param _to The address of the recipient
646     /// @param _amount The amount of tokens to be transferred
647     /// @return True if the transfer was successful
648     function doTransfer(address _from, address _to, uint _amount
649     ) internal {
650 
651            if (_amount == 0) {
652                Transfer(_from, _to, _amount);    // Follow the spec to louch the event when transfer 0
653                return;
654            }
655 
656            require(parentSnapShotBlock < block.number);
657 
658            // Do not allow transfer to 0x0 or the token contract itself
659            require((_to != 0) && (_to != address(this)));
660 
661            // If the amount being transfered is more than the balance of the
662            //  account the transfer throws
663            var previousBalanceFrom = balanceOfAt(_from, block.number);
664 
665            require(previousBalanceFrom >= _amount);
666 
667            // Alerts the token controller of the transfer
668            if (isContract(controller)) {
669                require(TokenController(controller).onTransfer(_from, _to, _amount));
670            }
671 
672            // First update the balance array with the new value for the address
673            //  sending the tokens
674            updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
675 
676            // Then update the balance array with the new value for the address
677            //  receiving the tokens
678            var previousBalanceTo = balanceOfAt(_to, block.number);
679            require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
680            updateValueAtNow(balances[_to], previousBalanceTo + _amount);
681 
682            // An event to make the transfer easy to find on the blockchain
683            Transfer(_from, _to, _amount);
684 
685     }
686 
687     /// @param _owner The address that's balance is being requested
688     /// @return The balance of `_owner` at the current block
689     function balanceOf(address _owner) public constant returns (uint256 balance) {
690         return balanceOfAt(_owner, block.number);
691     }
692 
693     /// @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
694     ///  its behalf. This is a modified version of the ERC20 approve function
695     ///  to be a little bit safer
696     /// @param _spender The address of the account able to transfer the tokens
697     /// @param _amount The amount of tokens to be approved for transfer
698     /// @return True if the approval was successful
699     function approve(address _spender, uint256 _amount) public returns (bool success) {
700         require(transfersEnabled);
701 
702         // To change the approve amount you first have to reduce the addresses`
703         //  allowance to zero by calling `approve(_spender,0)` if it is not
704         //  already 0 to mitigate the race condition described here:
705         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
706         require((_amount == 0) || (allowed[msg.sender][_spender] == 0));
707 
708         // Alerts the token controller of the approve function call
709         if (isContract(controller)) {
710             require(TokenController(controller).onApprove(msg.sender, _spender, _amount));
711         }
712 
713         allowed[msg.sender][_spender] = _amount;
714         Approval(msg.sender, _spender, _amount);
715         return true;
716     }
717 
718     /// @dev This function makes it easy to read the `allowed[]` map
719     /// @param _owner The address of the account that owns the token
720     /// @param _spender The address of the account able to transfer the tokens
721     /// @return Amount of remaining tokens of _owner that _spender is allowed
722     ///  to spend
723     function allowance(address _owner, address _spender
724     ) public constant returns (uint256 remaining) {
725         return allowed[_owner][_spender];
726     }
727 
728     /// @notice `msg.sender` approves `_spender` to send `_amount` tokens on
729     ///  its behalf, and then a function is triggered in the contract that is
730     ///  being approved, `_spender`. This allows users to use their tokens to
731     ///  interact with contracts in one function call instead of two
732     /// @param _spender The address of the contract able to transfer the tokens
733     /// @param _amount The amount of tokens to be approved for transfer
734     /// @return True if the function call was successful
735     function approveAndCall(address _spender, uint256 _amount, bytes _extraData
736     ) public returns (bool success) {
737         require(approve(_spender, _amount));
738 
739         ApproveAndCallFallBack(_spender).receiveApproval(
740             msg.sender,
741             _amount,
742             this,
743             _extraData
744         );
745 
746         return true;
747     }
748 
749     /// @dev This function makes it easy to get the total number of tokens
750     /// @return The total number of tokens
751     function totalSupply() public constant returns (uint) {
752         return totalSupplyAt(block.number);
753     }
754 
755 
756 ////////////////
757 // Query balance and totalSupply in History
758 ////////////////
759 
760     /// @dev Queries the balance of `_owner` at a specific `_blockNumber`
761     /// @param _owner The address from which the balance will be retrieved
762     /// @param _blockNumber The block number when the balance is queried
763     /// @return The balance at `_blockNumber`
764     function balanceOfAt(address _owner, uint _blockNumber) public constant
765         returns (uint) {
766 
767         // These next few lines are used when the balance of the token is
768         //  requested before a check point was ever created for this token, it
769         //  requires that the `parentToken.balanceOfAt` be queried at the
770         //  genesis block for that token as this contains initial balance of
771         //  this token
772         if ((balances[_owner].length == 0)
773             || (balances[_owner][0].fromBlock > _blockNumber)) {
774             if (address(parentToken) != 0) {
775                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
776             } else {
777                 // Has no parent
778                 return 0;
779             }
780 
781         // This will return the expected balance during normal situations
782         } else {
783             return getValueAt(balances[_owner], _blockNumber);
784         }
785     }
786 
787     /// @notice Total amount of tokens at a specific `_blockNumber`.
788     /// @param _blockNumber The block number when the totalSupply is queried
789     /// @return The total amount of tokens at `_blockNumber`
790     function totalSupplyAt(uint _blockNumber) public constant returns(uint) {
791 
792         // These next few lines are used when the totalSupply of the token is
793         //  requested before a check point was ever created for this token, it
794         //  requires that the `parentToken.totalSupplyAt` be queried at the
795         //  genesis block for this token as that contains totalSupply of this
796         //  token at this block number.
797         if ((totalSupplyHistory.length == 0)
798             || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
799             if (address(parentToken) != 0) {
800                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
801             } else {
802                 return 0;
803             }
804 
805         // This will return the expected totalSupply during normal situations
806         } else {
807             return getValueAt(totalSupplyHistory, _blockNumber);
808         }
809     }
810 
811 ////////////////
812 // Clone Token Method
813 ////////////////
814 
815     /// @notice Creates a new clone token with the initial distribution being
816     ///  this token at `_snapshotBlock`
817     /// @param _cloneTokenName Name of the clone token
818     /// @param _cloneDecimalUnits Number of decimals of the smallest unit
819     /// @param _cloneTokenSymbol Symbol of the clone token
820     /// @param _snapshotBlock Block when the distribution of the parent token is
821     ///  copied to set the initial distribution of the new clone token;
822     ///  if the block is zero than the actual block, the current block is used
823     /// @param _transfersEnabled True if transfers are allowed in the clone
824     /// @return The address of the new MiniMeToken Contract
825     function createCloneToken(
826         string _cloneTokenName,
827         uint8 _cloneDecimalUnits,
828         string _cloneTokenSymbol,
829         uint _snapshotBlock,
830         bool _transfersEnabled
831         ) public returns(address) {
832         if (_snapshotBlock == 0) _snapshotBlock = block.number;
833         MiniMeToken cloneToken = tokenFactory.createCloneToken(
834             this,
835             _snapshotBlock,
836             _cloneTokenName,
837             _cloneDecimalUnits,
838             _cloneTokenSymbol,
839             _transfersEnabled
840             );
841 
842         cloneToken.changeController(msg.sender);
843 
844         // An event to make the token easy to find on the blockchain
845         NewCloneToken(address(cloneToken), _snapshotBlock);
846         return address(cloneToken);
847     }
848 
849 ////////////////
850 // Generate and destroy tokens
851 ////////////////
852 
853     /// @notice Generates `_amount` tokens that are assigned to `_owner`
854     /// @param _owner The address that will be assigned the new tokens
855     /// @param _amount The quantity of tokens generated
856     /// @return True if the tokens are generated correctly
857     function generateTokens(address _owner, uint _amount
858     ) public onlyController returns (bool) {
859         uint curTotalSupply = totalSupply();
860         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
861         uint previousBalanceTo = balanceOf(_owner);
862         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
863         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
864         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
865         Transfer(0, _owner, _amount);
866         return true;
867     }
868 
869 
870     /// @notice Burns `_amount` tokens from `_owner`
871     /// @param _owner The address that will lose the tokens
872     /// @param _amount The quantity of tokens to burn
873     /// @return True if the tokens are burned correctly
874     function destroyTokens(address _owner, uint _amount
875     ) onlyController public returns (bool) {
876         uint curTotalSupply = totalSupply();
877         require(curTotalSupply >= _amount);
878         uint previousBalanceFrom = balanceOf(_owner);
879         require(previousBalanceFrom >= _amount);
880         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
881         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
882         Transfer(_owner, 0, _amount);
883         return true;
884     }
885 
886 ////////////////
887 // Enable tokens transfers
888 ////////////////
889 
890 
891     /// @notice Enables token holders to transfer their tokens freely if true
892     /// @param _transfersEnabled True if transfers are allowed in the clone
893     function enableTransfers(bool _transfersEnabled) public onlyController {
894         transfersEnabled = _transfersEnabled;
895     }
896 
897 ////////////////
898 // Internal helper functions to query and set a value in a snapshot array
899 ////////////////
900 
901     /// @dev `getValueAt` retrieves the number of tokens at a given block number
902     /// @param checkpoints The history of values being queried
903     /// @param _block The block number to retrieve the value at
904     /// @return The number of tokens being queried
905     function getValueAt(Checkpoint[] storage checkpoints, uint _block
906     ) constant internal returns (uint) {
907         if (checkpoints.length == 0) return 0;
908 
909         // Shortcut for the actual value
910         if (_block >= checkpoints[checkpoints.length-1].fromBlock)
911             return checkpoints[checkpoints.length-1].value;
912         if (_block < checkpoints[0].fromBlock) return 0;
913 
914         // Binary search of the value in the array
915         uint min = 0;
916         uint max = checkpoints.length-1;
917         while (max > min) {
918             uint mid = (max + min + 1)/ 2;
919             if (checkpoints[mid].fromBlock<=_block) {
920                 min = mid;
921             } else {
922                 max = mid-1;
923             }
924         }
925         return checkpoints[min].value;
926     }
927 
928     /// @dev `updateValueAtNow` used to update the `balances` map and the
929     ///  `totalSupplyHistory`
930     /// @param checkpoints The history of data being updated
931     /// @param _value The new number of tokens
932     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value
933     ) internal  {
934         if ((checkpoints.length == 0)
935         || (checkpoints[checkpoints.length -1].fromBlock < block.number)) {
936                Checkpoint storage newCheckPoint = checkpoints[ checkpoints.length++ ];
937                newCheckPoint.fromBlock =  uint128(block.number);
938                newCheckPoint.value = uint128(_value);
939            } else {
940                Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
941                oldCheckPoint.value = uint128(_value);
942            }
943     }
944 
945     /// @dev Internal function to determine if an address is a contract
946     /// @param _addr The address being queried
947     /// @return True if `_addr` is a contract
948     function isContract(address _addr) constant internal returns(bool) {
949         uint size;
950         if (_addr == 0) return false;
951         assembly {
952             size := extcodesize(_addr)
953         }
954         return size>0;
955     }
956 
957     /// @dev Helper function to return a min betwen the two uints
958     function min(uint a, uint b) pure internal returns (uint) {
959         return a < b ? a : b;
960     }
961 
962     /// @notice The fallback function: If the contract's controller has not been
963     ///  set to 0, then the `proxyPayment` method is called which relays the
964     ///  ether and creates tokens as described in the token controller contract
965     function () public payable {
966         require(isContract(controller));
967         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
968     }
969 
970 //////////
971 // Safety Methods
972 //////////
973 
974     /// @notice This method can be used by the controller to extract mistakenly
975     ///  sent tokens to this contract.
976     /// @param _token The address of the token contract that you want to recover
977     ///  set to 0 in case you want to extract ether.
978     function claimTokens(address _token) public onlyController {
979         if (_token == 0x0) {
980             controller.transfer(this.balance);
981             return;
982         }
983 
984         MiniMeToken token = MiniMeToken(_token);
985         uint balance = token.balanceOf(this);
986         token.transfer(controller, balance);
987         ClaimedTokens(_token, controller, balance);
988     }
989 
990 ////////////////
991 // Events
992 ////////////////
993     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
994     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
995     event NewCloneToken(address indexed _cloneToken, uint _snapshotBlock);
996     event Approval(
997         address indexed _owner,
998         address indexed _spender,
999         uint256 _amount
1000         );
1001 
1002 }
1003 
1004 
1005 ////////////////
1006 // MiniMeTokenFactory
1007 ////////////////
1008 
1009 /// @dev This contract is used to generate clone contracts from a contract.
1010 ///  In solidity this is the way to create a contract from a contract of the
1011 ///  same class
1012 contract MiniMeTokenFactory {
1013 
1014     /// @notice Update the DApp by creating a new token with new functionalities
1015     ///  the msg.sender becomes the controller of this clone token
1016     /// @param _parentToken Address of the token being cloned
1017     /// @param _snapshotBlock Block of the parent token that will
1018     ///  determine the initial distribution of the clone token
1019     /// @param _tokenName Name of the new token
1020     /// @param _decimalUnits Number of decimals of the new token
1021     /// @param _tokenSymbol Token Symbol for the new token
1022     /// @param _transfersEnabled If true, tokens will be able to be transferred
1023     /// @return The address of the new token contract
1024     function createCloneToken(
1025         address _parentToken,
1026         uint _snapshotBlock,
1027         string _tokenName,
1028         uint8 _decimalUnits,
1029         string _tokenSymbol,
1030         bool _transfersEnabled
1031     ) public returns (MiniMeToken) {
1032         MiniMeToken newToken = new MiniMeToken(
1033             this,
1034             _parentToken,
1035             _snapshotBlock,
1036             _tokenName,
1037             _decimalUnits,
1038             _tokenSymbol,
1039             _transfersEnabled
1040             );
1041 
1042         newToken.changeController(msg.sender);
1043         return newToken;
1044     }
1045 }
1046 
1047 /**
1048  * @title Whitelist
1049  * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
1050  * @dev This simplifies the implementation of "user permissions".
1051  */
1052 contract Whitelist is Ownable {
1053   mapping(address => bool) public whitelist;
1054 
1055   event WhitelistedAddressAdded(address addr);
1056   event WhitelistedAddressRemoved(address addr);
1057 
1058   /**
1059    * @dev Throws if called by any account that's not whitelisted.
1060    */
1061   modifier onlyWhitelisted() {
1062     require(whitelist[msg.sender]);
1063     _;
1064   }
1065 
1066   /**
1067    * @dev add an address to the whitelist
1068    * @param addr address
1069    * @return true if the address was added to the whitelist, false if the address was already in the whitelist
1070    */
1071   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
1072     if (!whitelist[addr]) {
1073       whitelist[addr] = true;
1074       WhitelistedAddressAdded(addr);
1075       success = true;
1076     }
1077   }
1078 
1079   /**
1080    * @dev add addresses to the whitelist
1081    * @param addrs addresses
1082    * @return true if at least one address was added to the whitelist,
1083    * false if all addresses were already in the whitelist
1084    */
1085   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
1086     for (uint256 i = 0; i < addrs.length; i++) {
1087       if (addAddressToWhitelist(addrs[i])) {
1088         success = true;
1089       }
1090     }
1091   }
1092 
1093   /**
1094    * @dev remove an address from the whitelist
1095    * @param addr address
1096    * @return true if the address was removed from the whitelist,
1097    * false if the address wasn't in the whitelist in the first place
1098    */
1099   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
1100     if (whitelist[addr]) {
1101       whitelist[addr] = false;
1102       WhitelistedAddressRemoved(addr);
1103       success = true;
1104     }
1105   }
1106 
1107   /**
1108    * @dev remove addresses from the whitelist
1109    * @param addrs addresses
1110    * @return true if at least one address was removed from the whitelist,
1111    * false if all addresses weren't in the whitelist in the first place
1112    */
1113   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
1114     for (uint256 i = 0; i < addrs.length; i++) {
1115       if (removeAddressFromWhitelist(addrs[i])) {
1116         success = true;
1117       }
1118     }
1119   }
1120 
1121 }
1122 
1123 contract Crowdsale is Presale, Pausable, CanReclaimToken, Whitelist {
1124 
1125   using SafeMath for uint256;
1126   address public whitelistAddress;
1127   address public wallet; //wallet where the funds collected are transfered
1128   MiniMeToken public token; //ERC20 Token
1129   uint256 private weiRaised = 0; //WeiRaised during the public Sale
1130   uint256 private cap = 0; //Cap of the public Sale in Wei
1131   bool private publicSaleInitialized = false;
1132   bool private finalized = false;
1133   uint256 private tokensSold = 0; //tokens sold during the entire sale
1134   uint256 private startTime; //start time of the public sale initialized after the presale is over
1135   uint256 private endTime; //endtime of the public sale
1136   uint256 public maxTokens;
1137   mapping(address => uint256) public contributions; //contributions of each investor
1138   mapping(address => uint256) public investorCaps; //for whitelisting
1139   address[] public investors; //investor list who participate in the ICO
1140   address[] public founders; //list of founders
1141   address[] public advisors; //list of advisors
1142   VestingTrustee public trustee;
1143   address public reserveWallet; //reserveWallet where the unsold tokens will be sent to
1144 
1145   //Rate for each tier (no of tokens for 1 ETH)
1146   //Max wei for each tier
1147   struct Tier {
1148     uint256 rate;
1149     uint256 max;
1150   }
1151 
1152   uint public privateSaleTokensAvailable;
1153   uint public privateSaleTokensSold = 0;
1154   uint public publicTokensAvailable;
1155 
1156   uint8 public totalTiers = 0; //total Tiers in the public sale
1157   bool public tiersInitialized = false;
1158   uint256 public maxTiers = 6; //max tiers that can be in the publicsale
1159   Tier[6] public tiers; //array of tiers
1160 
1161   event TokenPurchase(address indexed purchaser, uint256 value, uint256 amount);
1162   enum Stage { Preparing, Presale, PresaleFinished, PublicSale, Success, Finalized }
1163 
1164   function Crowdsale(
1165     uint256 _presaleStartTime, //presale start time
1166     uint256 _presaleDuration, //presale duration in days
1167     uint256 _presaleRate, // presale rate. ie No of tokens per 1 ETH
1168     uint256 _presaleCap, // max wei that can raised
1169     address erc20Token, // Token used for the crowdsale
1170     address _wallet,
1171     uint8 _tiers,
1172     uint256 _cap,
1173     address _reserveWallet)
1174     public
1175     Presale(_presaleStartTime, _presaleDuration, _presaleRate, _presaleCap)
1176     {
1177       require(_wallet != address(0));
1178       require(erc20Token != address(0));
1179       require(_tiers > 0 && _tiers <= maxTiers);
1180       require(_cap > 0);
1181       require(_reserveWallet != address(0));
1182       token = MiniMeToken(erc20Token);
1183       wallet = _wallet;
1184       totalTiers = _tiers;
1185       cap = _cap;
1186       reserveWallet = _reserveWallet;
1187       trustee = new VestingTrustee(erc20Token);
1188       maxTokens = 1000000000 * (10 ** 18); // 1 B tokens
1189       privateSaleTokensAvailable = maxTokens.mul(22).div(100);
1190       publicTokensAvailable = maxTokens.mul(28).div(100);
1191       super.addAddressToWhitelist(msg.sender);
1192 
1193     }
1194 
1195   function() public payable {
1196     buyTokens(msg.sender, msg.value);
1197   }
1198 
1199   function getStage() public constant returns(Stage) {
1200     if (finalized) return Stage.Finalized;
1201     if (!tiersInitialized || !Presale.hasStarted()) return Stage.Preparing;
1202     if (!Presale.hasEnded()) return Stage.Presale;
1203     if (Presale.hasEnded() && !hasStarted()) return Stage.PresaleFinished;
1204     if (!hasEnded()) return Stage.PublicSale;
1205     if (hasEnded()) return Stage.Success;
1206     return Stage.Preparing;
1207   }
1208 
1209   modifier inStage(Stage _stage) {
1210     require(getStage() == _stage);
1211     _;
1212   }
1213 
1214   // rates for each tier and total wei in that tiers
1215   // they are added up together
1216   function initTiers(uint256[] rates, uint256[] totalWeis) public onlyWhitelisted returns(uint256) {
1217     require(token.controller() == address(this));
1218     require(!tiersInitialized);
1219     require(rates.length == totalTiers && rates.length == totalWeis.length);
1220     uint256 tierMax = 0;
1221 
1222     for (uint8 i=0; i < totalTiers; i++) {
1223 
1224       require(totalWeis[i] > 0 && rates[i] > 0);
1225 
1226       tierMax = tierMax.add(totalWeis[i]);
1227       tiers[i] = Tier({
1228         rate: rates[i],
1229         max: tierMax
1230       });
1231     }
1232 
1233     require(tierMax == cap);
1234     tiersInitialized = true;
1235     return tierMax;
1236   }
1237 
1238   // function for whitelisting investors with caps
1239   function setCapForParticipants(address[] participants, uint256[] caps) onlyWhitelisted public  {
1240     require(participants.length <= 50 && participants.length == caps.length);
1241     for (uint8 i=0; i < participants.length; i++) {
1242       investorCaps[participants[i]] = caps[i];
1243     }
1244   }
1245 
1246 
1247   function addGrant(address assignee, uint256 value, bool isFounder) public onlyWhitelisted whenNotPaused {
1248     require(value > 0);
1249     require(assignee != address(0));
1250     uint256 start;
1251     uint256 cliff;
1252     uint256 vestingPercentage;
1253     uint256 initialTokens;
1254     if(isFounder) {
1255       start = now;
1256       cliff = start + 12*30 days; //12 months
1257       vestingPercentage = 20; //20%
1258       founders.push(assignee);
1259     }
1260     else {
1261       // for advisors
1262       // transfer 10% of the tokens at start
1263       initialTokens = value.mul(10).div(100);
1264       transferTokens(assignee, initialTokens);
1265       start = now;
1266       cliff = start + 6*30 days;  //6 months
1267       vestingPercentage = 15; //15% for each installments
1268       advisors.push(assignee);
1269     }
1270 
1271     uint256 end = now + 3 * 1 years; //3 years
1272     uint256 installmentLength = 6 * 30 days; // 6 month installments
1273     bool revokable = true;
1274     transferTokens(trustee, value.sub(initialTokens));
1275     trustee.grant(assignee, value, start, cliff, end, installmentLength, vestingPercentage, initialTokens, revokable);
1276   }
1277 
1278   // called by the owner to close the crowdsale
1279   function finalize() public onlyWhitelisted inStage(Stage.Success) {
1280     require(!finalized);
1281     //trustee's ownership is transfered from the crowdsale to owner of the contract
1282     trustee.transferOwnership(msg.sender);
1283     //enable token transfer
1284     token.enableTransfers(true);
1285     //generate the unsold tokens to the reserve
1286     uint256 unsold = maxTokens.sub(token.totalSupply());
1287     transferTokens(reserveWallet, unsold);
1288 
1289     // change the token's controller to a zero Address so that it cannot
1290     // generate or destroy tokens
1291     token.changeController(0x0);
1292     finalized = true;
1293   }
1294 
1295   //start the public sale manually after the presale is over, duration is in days
1296   function startPublicSale(uint _startTime, uint _duration) public onlyWhitelisted inStage(Stage.PresaleFinished) {
1297     require(_startTime >= now);
1298     require(_duration > 0);
1299     startTime = _startTime;
1300     endTime = _startTime + _duration * 1 days;
1301     publicSaleInitialized = true;
1302   }
1303 
1304   // total wei raised in the presale and public sale
1305   function totalWei() public constant returns(uint256) {
1306     uint256 presaleWei = super.totalWei();
1307     return presaleWei.add(weiRaised);
1308   }
1309 
1310   function totalPublicSaleWei() public constant returns(uint256) {
1311     return weiRaised;
1312   }
1313   // total cap of the presale and public sale
1314   function totalCap() public constant returns(uint256) {
1315     uint256 presaleCap = super.totalCap();
1316     return presaleCap.add(cap);
1317   }
1318 
1319   // Total tokens sold duing the presale and public sale.
1320   // Total tokens has to divided by 10^18
1321   function totalTokens() public constant returns(uint256) {
1322     return tokensSold;
1323   }
1324 
1325   // MAIN BUYING Function
1326   function buyTokens(address purchaser, uint256 value) internal  whenNotPaused returns(uint256) {
1327     require(value > 0);
1328     Stage stage = getStage();
1329     require(stage == Stage.Presale || stage == Stage.PublicSale);
1330 
1331     //the purchase amount cannot be more than the whitelisted cap
1332     uint256 purchaseAmount = Math.min256(value, investorCaps[purchaser].sub(contributions[purchaser]));
1333     require(purchaseAmount > 0);
1334     uint256 numTokens;
1335 
1336     //call the presale contract
1337     if (stage == Stage.Presale) {
1338       if (Presale.totalWei().add(purchaseAmount) > Presale.totalCap()) {
1339         purchaseAmount = Presale.capRemaining();
1340       }
1341       numTokens = Presale.buyTokens(purchaser, purchaseAmount);
1342     } else if (stage == Stage.PublicSale) {
1343 
1344       uint totalWei = weiRaised.add(purchaseAmount);
1345       uint8 currentTier = getTier(weiRaised); //get current tier
1346       if (totalWei >= cap) { // will TOTAL_CAP(HARD_CAP) of the public sale be reached ?
1347         totalWei = cap;
1348         //purchase amount can be only be (CAP - WeiRaised)
1349         purchaseAmount = cap.sub(weiRaised);
1350       }
1351 
1352       // if the totalWei( weiRaised + msg.value) fits within current cap
1353       // number of tokens would be rate * purchaseAmount
1354       if (totalWei <= tiers[currentTier].max) {
1355         numTokens = purchaseAmount.mul(tiers[currentTier].rate);
1356       } else {
1357         //wei remaining in the current tier
1358         uint remaining = tiers[currentTier].max.sub(weiRaised);
1359         numTokens = remaining.mul(tiers[currentTier].rate);
1360 
1361         //wei in the next tier
1362         uint256 excess = totalWei.sub(tiers[currentTier].max);
1363         //number of tokens  = wei remaining in the next tier * rate of the next tier
1364         numTokens = numTokens.add(excess.mul(tiers[currentTier + 1].rate));
1365       }
1366 
1367       // update the total raised so far
1368       weiRaised = weiRaised.add(purchaseAmount);
1369     }
1370 
1371     // total tokens sold in the entire sale
1372     require(tokensSold.add(numTokens) <= publicTokensAvailable);
1373     tokensSold = tokensSold.add(numTokens);
1374 
1375     // forward funds to the wallet
1376     forwardFunds(purchaser, purchaseAmount);
1377     // transfer the tokens to the purchaser
1378     transferTokens(purchaser, numTokens);
1379 
1380     // return the remaining unused wei back
1381     if (value.sub(purchaseAmount) > 0) {
1382       msg.sender.transfer(value.sub(purchaseAmount));
1383     }
1384 
1385     //event
1386     TokenPurchase(purchaser, numTokens, purchaseAmount);
1387 
1388     return numTokens;
1389   }
1390 
1391 
1392 
1393   function forwardFunds(address purchaser, uint256 value) internal {
1394     //new investor
1395     if (contributions[purchaser] == 0) {
1396       investors.push(purchaser);
1397     }
1398     //add contribution to the purchaser
1399     contributions[purchaser] = contributions[purchaser].add(value);
1400     wallet.transfer(value);
1401   }
1402 
1403   function changeEndTime(uint _endTime) public onlyWhitelisted {
1404     endTime = _endTime;
1405   }
1406 
1407   function changeFundsWallet(address _newWallet) public onlyWhitelisted {
1408     require(_newWallet != address(0));
1409     wallet = _newWallet;
1410   }
1411 
1412   function changeTokenController() onlyWhitelisted public {
1413     token.changeController(msg.sender);
1414   }
1415 
1416   function changeTrusteeOwner() onlyWhitelisted public {
1417     trustee.transferOwnership(msg.sender);
1418   }
1419   function changeReserveWallet(address _reserve) public onlyWhitelisted {
1420     require(_reserve != address(0));
1421     reserveWallet = _reserve;
1422   }
1423 
1424   function setWhitelistAddress(address _whitelist) public onlyWhitelisted {
1425     require(_whitelist != address(0));
1426     whitelistAddress = _whitelist;
1427   }
1428 
1429   function transferTokens(address to, uint256 value) internal {
1430     token.generateTokens(to, value);
1431   }
1432 
1433   function sendPrivateSaleTokens(address to, uint256 value) public whenNotPaused onlyWhitelisted {
1434     require(privateSaleTokensSold.add(value) <= privateSaleTokensAvailable);
1435     privateSaleTokensSold = privateSaleTokensSold.add(value);
1436     transferTokens(to, value);
1437   }
1438 
1439   function hasEnded() internal constant returns(bool) {
1440     return now > endTime || weiRaised >= cap;
1441   }
1442 
1443   function hasStarted() internal constant returns(bool) {
1444     return publicSaleInitialized && now >= startTime;
1445   }
1446 
1447   function getTier(uint256 _weiRaised) internal constant returns(uint8) {
1448     for (uint8 i = 0; i < totalTiers; i++) {
1449       if (_weiRaised < tiers[i].max) {
1450         return i;
1451       }
1452     }
1453     //wont reach but for safety
1454     return totalTiers + 1;
1455   }
1456 
1457 
1458 
1459   function getCurrentTier() public constant returns(uint8) {
1460     return getTier(weiRaised);
1461   }
1462 
1463 
1464   // functions for the mini me token
1465   function proxyPayment(address _owner) public payable returns(bool) {
1466     return true;
1467   }
1468 
1469   function onApprove(address _owner, address _spender, uint _amount) public returns(bool) {
1470     return true;
1471   }
1472 
1473   function onTransfer(address _from, address _to, uint _amount) public returns(bool) {
1474     return true;
1475   }
1476 
1477   function getTokenSaleTime() public constant returns(uint256, uint256) {
1478     return (startTime, endTime);
1479   }
1480 }