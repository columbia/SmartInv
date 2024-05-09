1 pragma solidity ^0.5.0;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Unsigned math operations with safety checks that revert on error
8  */
9 library SafeMath {
10     /**
11     * @dev Multiplies two unsigned integers, reverts on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
15         // benefit is lost if 'b' is also tested.
16         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17         if (a == 0) {
18             return 0;
19         }
20 
21         uint256 c = a * b;
22         require(c / a == b);
23 
24         return c;
25     }
26 
27     /**
28     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
29     */
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         // Solidity only automatically asserts when dividing by 0
32         require(b > 0);
33         uint256 c = a / b;
34         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35 
36         return c;
37     }
38 
39     /**
40     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
41     */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a);
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50     * @dev Adds two unsigned integers, reverts on overflow.
51     */
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a);
55 
56         return c;
57     }
58 
59     /**
60     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
61     * reverts when dividing by zero.
62     */
63     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
64         require(b != 0);
65         return a % b;
66     }
67 }
68 
69 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
70 
71 /**
72  * @title Ownable
73  * @dev The Ownable contract has an owner address, and provides basic authorization control
74  * functions, this simplifies the implementation of "user permissions".
75  */
76 contract Ownable {
77     address private _owner;
78 
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     /**
82      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
83      * account.
84      */
85     constructor () internal {
86         _owner = msg.sender;
87         emit OwnershipTransferred(address(0), _owner);
88     }
89 
90     /**
91      * @return the address of the owner.
92      */
93     function owner() public view returns (address) {
94         return _owner;
95     }
96 
97     /**
98      * @dev Throws if called by any account other than the owner.
99      */
100     modifier onlyOwner() {
101         require(isOwner());
102         _;
103     }
104 
105     /**
106      * @return true if `msg.sender` is the owner of the contract.
107      */
108     function isOwner() public view returns (bool) {
109         return msg.sender == _owner;
110     }
111 
112     /**
113      * @dev Allows the current owner to relinquish control of the contract.
114      * @notice Renouncing to ownership will leave the contract without an owner.
115      * It will not be possible to call the functions with the `onlyOwner`
116      * modifier anymore.
117      */
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipTransferred(_owner, address(0));
120         _owner = address(0);
121     }
122 
123     /**
124      * @dev Allows the current owner to transfer control of the contract to a newOwner.
125      * @param newOwner The address to transfer ownership to.
126      */
127     function transferOwnership(address newOwner) public onlyOwner {
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function _transferOwnership(address newOwner) internal {
136         require(newOwner != address(0));
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
143 
144 /**
145  * @title ERC20 interface
146  * @dev see https://github.com/ethereum/EIPs/issues/20
147  */
148 interface IERC20 {
149     function transfer(address to, uint256 value) external returns (bool);
150 
151     function approve(address spender, uint256 value) external returns (bool);
152 
153     function transferFrom(address from, address to, uint256 value) external returns (bool);
154 
155     function totalSupply() external view returns (uint256);
156 
157     function balanceOf(address who) external view returns (uint256);
158 
159     function allowance(address owner, address spender) external view returns (uint256);
160 
161     event Transfer(address indexed from, address indexed to, uint256 value);
162 
163     event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
173  * Originally based on code by FirstBlood:
174  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
175  *
176  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
177  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
178  * compliant implementations may not do it.
179  */
180 contract ERC20 is IERC20 {
181     using SafeMath for uint256;
182 
183     mapping (address => uint256) private _balances;
184 
185     mapping (address => mapping (address => uint256)) private _allowed;
186 
187     uint256 private _totalSupply;
188 
189     /**
190     * @dev Total number of tokens in existence
191     */
192     function totalSupply() public view returns (uint256) {
193         return _totalSupply;
194     }
195 
196     /**
197     * @dev Gets the balance of the specified address.
198     * @param owner The address to query the balance of.
199     * @return An uint256 representing the amount owned by the passed address.
200     */
201     function balanceOf(address owner) public view returns (uint256) {
202         return _balances[owner];
203     }
204 
205     /**
206      * @dev Function to check the amount of tokens that an owner allowed to a spender.
207      * @param owner address The address which owns the funds.
208      * @param spender address The address which will spend the funds.
209      * @return A uint256 specifying the amount of tokens still available for the spender.
210      */
211     function allowance(address owner, address spender) public view returns (uint256) {
212         return _allowed[owner][spender];
213     }
214 
215     /**
216     * @dev Transfer token for a specified address
217     * @param to The address to transfer to.
218     * @param value The amount to be transferred.
219     */
220     function transfer(address to, uint256 value) public returns (bool) {
221         _transfer(msg.sender, to, value);
222         return true;
223     }
224 
225     /**
226      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227      * Beware that changing an allowance with this method brings the risk that someone may use both the old
228      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231      * @param spender The address which will spend the funds.
232      * @param value The amount of tokens to be spent.
233      */
234     function approve(address spender, uint256 value) public returns (bool) {
235         require(spender != address(0));
236 
237         _allowed[msg.sender][spender] = value;
238         emit Approval(msg.sender, spender, value);
239         return true;
240     }
241 
242     /**
243      * @dev Transfer tokens from one address to another.
244      * Note that while this function emits an Approval event, this is not required as per the specification,
245      * and other compliant implementations may not emit the event.
246      * @param from address The address which you want to send tokens from
247      * @param to address The address which you want to transfer to
248      * @param value uint256 the amount of tokens to be transferred
249      */
250     function transferFrom(address from, address to, uint256 value) public returns (bool) {
251         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
252         _transfer(from, to, value);
253         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
254         return true;
255     }
256 
257     /**
258      * @dev Increase the amount of tokens that an owner allowed to a spender.
259      * approve should be called when allowed_[_spender] == 0. To increment
260      * allowed value is better to use this function to avoid 2 calls (and wait until
261      * the first transaction is mined)
262      * From MonolithDAO Token.sol
263      * Emits an Approval event.
264      * @param spender The address which will spend the funds.
265      * @param addedValue The amount of tokens to increase the allowance by.
266      */
267     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
268         require(spender != address(0));
269 
270         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
271         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
272         return true;
273     }
274 
275     /**
276      * @dev Decrease the amount of tokens that an owner allowed to a spender.
277      * approve should be called when allowed_[_spender] == 0. To decrement
278      * allowed value is better to use this function to avoid 2 calls (and wait until
279      * the first transaction is mined)
280      * From MonolithDAO Token.sol
281      * Emits an Approval event.
282      * @param spender The address which will spend the funds.
283      * @param subtractedValue The amount of tokens to decrease the allowance by.
284      */
285     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
286         require(spender != address(0));
287 
288         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
289         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
290         return true;
291     }
292 
293     /**
294     * @dev Transfer token for a specified addresses
295     * @param from The address to transfer from.
296     * @param to The address to transfer to.
297     * @param value The amount to be transferred.
298     */
299     function _transfer(address from, address to, uint256 value) internal {
300         require(to != address(0));
301 
302         _balances[from] = _balances[from].sub(value);
303         _balances[to] = _balances[to].add(value);
304         emit Transfer(from, to, value);
305     }
306 
307     /**
308      * @dev Internal function that mints an amount of the token and assigns it to
309      * an account. This encapsulates the modification of balances such that the
310      * proper events are emitted.
311      * @param account The account that will receive the created tokens.
312      * @param value The amount that will be created.
313      */
314     function _mint(address account, uint256 value) internal {
315         require(account != address(0));
316 
317         _totalSupply = _totalSupply.add(value);
318         _balances[account] = _balances[account].add(value);
319         emit Transfer(address(0), account, value);
320     }
321 
322     /**
323      * @dev Internal function that burns an amount of the token of a given
324      * account.
325      * @param account The account whose tokens will be burnt.
326      * @param value The amount that will be burnt.
327      */
328     function _burn(address account, uint256 value) internal {
329         require(account != address(0));
330 
331         _totalSupply = _totalSupply.sub(value);
332         _balances[account] = _balances[account].sub(value);
333         emit Transfer(account, address(0), value);
334     }
335 
336     /**
337      * @dev Internal function that burns an amount of the token of a given
338      * account, deducting from the sender's allowance for said account. Uses the
339      * internal burn function.
340      * Emits an Approval event (reflecting the reduced allowance).
341      * @param account The account whose tokens will be burnt.
342      * @param value The amount that will be burnt.
343      */
344     function _burnFrom(address account, uint256 value) internal {
345         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
346         _burn(account, value);
347         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
348     }
349 }
350 
351 // File: contracts/crowdsale/interfaces/IGlobalIndexControllerLocation.sol
352 
353 interface IGlobalIndexControllerLocation {
354     function getControllerAddress() external view returns (address);
355 }
356 
357 // File: contracts/crowdsale/interfaces/ICRWDControllerTokenSale.sol
358 
359 interface ICRWDControllerTokenSale {
360     function buyFromCrowdsale(address _to, uint256 _amountInWei) external returns (uint256 _tokensCreated, uint256 _overpaidRefund);
361     function assignFromCrowdsale(address _to, uint256 _tokenAmount, bytes8 _tag) external returns (uint256 _tokensCreated);
362     function calcTokensForEth(uint256 _amountInWei) external view returns (uint256 _tokensWouldBeCreated);
363 }
364 
365 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
366 
367 /**
368  * @title Secondary
369  * @dev A Secondary contract can only be used by its primary account (the one that created it)
370  */
371 contract Secondary {
372     address private _primary;
373 
374     event PrimaryTransferred(
375         address recipient
376     );
377 
378     /**
379      * @dev Sets the primary account to the one that is creating the Secondary contract.
380      */
381     constructor () internal {
382         _primary = msg.sender;
383         emit PrimaryTransferred(_primary);
384     }
385 
386     /**
387      * @dev Reverts if called from any account other than the primary.
388      */
389     modifier onlyPrimary() {
390         require(msg.sender == _primary);
391         _;
392     }
393 
394     /**
395      * @return the address of the primary.
396      */
397     function primary() public view returns (address) {
398         return _primary;
399     }
400 
401     /**
402      * @dev Transfers contract to a new primary.
403      * @param recipient The address of new primary.
404      */
405     function transferPrimary(address recipient) public onlyPrimary {
406         require(recipient != address(0));
407         _primary = recipient;
408         emit PrimaryTransferred(_primary);
409     }
410 }
411 
412 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
413 
414 /**
415  * @title Escrow
416  * @dev Base escrow contract, holds funds designated for a payee until they
417  * withdraw them.
418  * @dev Intended usage: This contract (and derived escrow contracts) should be a
419  * standalone contract, that only interacts with the contract that instantiated
420  * it. That way, it is guaranteed that all Ether will be handled according to
421  * the Escrow rules, and there is no need to check for payable functions or
422  * transfers in the inheritance tree. The contract that uses the escrow as its
423  * payment method should be its primary, and provide public methods redirecting
424  * to the escrow's deposit and withdraw.
425  */
426 contract Escrow is Secondary {
427     using SafeMath for uint256;
428 
429     event Deposited(address indexed payee, uint256 weiAmount);
430     event Withdrawn(address indexed payee, uint256 weiAmount);
431 
432     mapping(address => uint256) private _deposits;
433 
434     function depositsOf(address payee) public view returns (uint256) {
435         return _deposits[payee];
436     }
437 
438     /**
439     * @dev Stores the sent amount as credit to be withdrawn.
440     * @param payee The destination address of the funds.
441     */
442     function deposit(address payee) public onlyPrimary payable {
443         uint256 amount = msg.value;
444         _deposits[payee] = _deposits[payee].add(amount);
445 
446         emit Deposited(payee, amount);
447     }
448 
449     /**
450     * @dev Withdraw accumulated balance for a payee.
451     * @param payee The address whose funds will be withdrawn and transferred to.
452     */
453     function withdraw(address payable payee) public onlyPrimary {
454         uint256 payment = _deposits[payee];
455 
456         _deposits[payee] = 0;
457 
458         payee.transfer(payment);
459 
460         emit Withdrawn(payee, payment);
461     }
462 }
463 
464 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
465 
466 /**
467  * @title ConditionalEscrow
468  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
469  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
470  */
471 contract ConditionalEscrow is Escrow {
472     /**
473     * @dev Returns whether an address is allowed to withdraw their funds. To be
474     * implemented by derived contracts.
475     * @param payee The destination address of the funds.
476     */
477     function withdrawalAllowed(address payee) public view returns (bool);
478 
479     function withdraw(address payable payee) public {
480         require(withdrawalAllowed(payee));
481         super.withdraw(payee);
482     }
483 }
484 
485 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
486 
487 /**
488  * @title RefundEscrow
489  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
490  * parties.
491  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
492  * @dev The primary account (that is, the contract that instantiates this
493  * contract) may deposit, close the deposit period, and allow for either
494  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
495  * with RefundEscrow will be made through the primary contract. See the
496  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
497  */
498 contract RefundEscrow is ConditionalEscrow {
499     enum State { Active, Refunding, Closed }
500 
501     event RefundsClosed();
502     event RefundsEnabled();
503 
504     State private _state;
505     address payable private _beneficiary;
506 
507     /**
508      * @dev Constructor.
509      * @param beneficiary The beneficiary of the deposits.
510      */
511     constructor (address payable beneficiary) public {
512         require(beneficiary != address(0));
513         _beneficiary = beneficiary;
514         _state = State.Active;
515     }
516 
517     /**
518      * @return the current state of the escrow.
519      */
520     function state() public view returns (State) {
521         return _state;
522     }
523 
524     /**
525      * @return the beneficiary of the escrow.
526      */
527     function beneficiary() public view returns (address) {
528         return _beneficiary;
529     }
530 
531     /**
532      * @dev Stores funds that may later be refunded.
533      * @param refundee The address funds will be sent to if a refund occurs.
534      */
535     function deposit(address refundee) public payable {
536         require(_state == State.Active);
537         super.deposit(refundee);
538     }
539 
540     /**
541      * @dev Allows for the beneficiary to withdraw their funds, rejecting
542      * further deposits.
543      */
544     function close() public onlyPrimary {
545         require(_state == State.Active);
546         _state = State.Closed;
547         emit RefundsClosed();
548     }
549 
550     /**
551      * @dev Allows for refunds to take place, rejecting further deposits.
552      */
553     function enableRefunds() public onlyPrimary {
554         require(_state == State.Active);
555         _state = State.Refunding;
556         emit RefundsEnabled();
557     }
558 
559     /**
560      * @dev Withdraws the beneficiary's funds.
561      */
562     function beneficiaryWithdraw() public {
563         require(_state == State.Closed);
564         _beneficiary.transfer(address(this).balance);
565     }
566 
567     /**
568      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overriden function receives a
569      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
570      */
571     function withdrawalAllowed(address) public view returns (bool) {
572         return _state == State.Refunding;
573     }
574 }
575 
576 // File: contracts/crowdsale/library/CrowdsaleL.sol
577 
578 /*
579     Copyright 2018, CONDA
580 
581     This program is free software: you can redistribute it and/or modify
582     it under the terms of the GNU General Public License as published by
583     the Free Software Foundation, either version 3 of the License, or
584     (at your option) any later version.
585 
586     This program is distributed in the hope that it will be useful,
587     but WITHOUT ANY WARRANTY; without even the implied warranty of
588     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
589     GNU General Public License for more details.
590 
591     You should have received a copy of the GNU General Public License
592     along with this program.  If not, see <http://www.gnu.org/licenses/>.
593 */
594 
595 
596 
597 
598 
599 
600 /** @title CrowdsaleL library. */
601 library CrowdsaleL {
602     using SafeMath for uint256;
603 
604 ///////////////////
605 // Structs
606 ///////////////////
607 
608     /// @dev All crowdsale states.
609     enum State { Draft, Started, Ended, Finalized, Refunding, Closed }
610 
611     struct Data {
612         // The token being sold type ERC20
613         address token;
614 
615         // status of crowdsale
616         State state;
617 
618         // the max cap of tokens being sold
619         uint256 cap;
620 
621         // the start time of crowdsale.
622         uint256 startTime;
623         
624         // the end time of crowdsale
625         uint256 endTime;
626 
627         // address where funds are collected
628         address payable wallet;
629 
630         // the global index holding contract addresses
631         IGlobalIndexControllerLocation globalIndex;
632 
633         // amount of tokens raised by money in all allowed currencies
634         uint256 tokensRaised;
635     }
636 
637     struct Roles {
638         // can assign tokens on off-chain payments
639         address tokenAssignmentControl;
640 
641         // role that can rescue accidentally sent tokens
642         address tokenRescueControl;
643     }
644 
645 ///////////////////
646 // Functions
647 ///////////////////
648 
649     /// @notice Initialize function for initial setup (during construction).
650     /// @param _assetToken The asset token being sold.
651     function init(Data storage _self, address _assetToken) public {
652         _self.token = _assetToken;
653         _self.state = State.Draft;
654     }
655 
656     /// @notice Confiugure function for setup (during negotiations).
657     /// @param _wallet beneficiary wallet on successful crowdsale.
658     /// @param _globalIndex the contract holding current contract addresses.
659     function configure(
660         Data storage _self, 
661         address payable _wallet, 
662         address _globalIndex)
663     public 
664     {
665         require(_self.state == CrowdsaleL.State.Draft, "not draft state");
666         require(_wallet != address(0), "wallet zero addr");
667         require(_globalIndex != address(0), "globalIdx zero addr");
668 
669         _self.wallet = _wallet;
670         _self.globalIndex = IGlobalIndexControllerLocation(_globalIndex);
671 
672         emit CrowdsaleConfigurationChanged(_wallet, _globalIndex);
673     }
674 
675     /// @notice Set roles/operators.
676     /// @param _tokenAssignmentControl token assignment control (off-chain payment).
677     /// @param _tokenRescueControl token rescue control (accidentally assigned tokens).
678     function setRoles(Roles storage _self, address _tokenAssignmentControl, address _tokenRescueControl) public {
679         require(_tokenAssignmentControl != address(0), "addr0");
680         require(_tokenRescueControl != address(0), "addr0");
681         
682         _self.tokenAssignmentControl = _tokenAssignmentControl;
683         _self.tokenRescueControl = _tokenRescueControl;
684 
685         emit RolesChanged(msg.sender, _tokenAssignmentControl, _tokenRescueControl);
686     }
687 
688     /// @notice gets current controller address.
689     function getControllerAddress(Data storage _self) public view returns (address) {
690         return IGlobalIndexControllerLocation(_self.globalIndex).getControllerAddress();
691     }
692 
693     /// @dev gets controller with interface for internal use.
694     function getController(Data storage _self) private view returns (ICRWDControllerTokenSale) {
695         return ICRWDControllerTokenSale(getControllerAddress(_self));
696     }
697 
698     /// @notice set cap.
699     /// @param _cap token cap of tokens being sold.
700     function setCap(Data storage _self, uint256 _cap) public {
701         // require(requireActiveOrDraftState(_self), "require active/draft"); // No! Could have been changed by AT owner...
702         // require(_cap > 0, "cap 0"); // No! Decided by AssetToken owner...
703         _self.cap = _cap;
704     }
705 
706     /// @notice Low level token purchase function with ether.
707     /// @param _beneficiary who receives tokens.
708     /// @param _investedAmount the invested ETH amount.
709     function buyTokensFor(Data storage _self, address _beneficiary, uint256 _investedAmount) 
710     public 
711     returns (uint256)
712     {
713         require(validPurchasePreCheck(_self), "invalid purchase precheck");
714 
715         (uint256 tokenAmount, uint256 overpaidRefund) = getController(_self).buyFromCrowdsale(_beneficiary, _investedAmount);
716 
717         if(tokenAmount == 0) {
718             // Special handling full refund if too little ETH (could be small drift depending on off-chain API accuracy)
719             overpaidRefund = _investedAmount;
720         }
721 
722         require(validPurchasePostCheck(_self, tokenAmount), "invalid purchase postcheck");
723         _self.tokensRaised = _self.tokensRaised.add(tokenAmount);
724 
725         emit TokenPurchase(msg.sender, _beneficiary, tokenAmount, overpaidRefund, "ETH");
726 
727         return overpaidRefund;
728     }
729 
730     /// @dev Fails if not active or draft state
731     function requireActiveOrDraftState(Data storage _self) public view returns (bool) {
732         require((_self.state == State.Draft) || (_self.state == State.Started), "only active or draft state");
733 
734         return true;
735     }
736 
737     /// @notice Valid start basic logic.
738     /// @dev In contract could be extended logic e.g. checking goal)
739     function validStart(Data storage _self) public view returns (bool) {
740         require(_self.wallet != address(0), "wallet is zero addr");
741         require(_self.token != address(0), "token is zero addr");
742         require(_self.cap > 0, "cap is 0");
743         require(_self.startTime != 0, "time not set");
744         require(now >= _self.startTime, "too early");
745 
746         return true;
747     }
748 
749     /// @notice Set the timeframe.
750     /// @param _startTime the start time of crowdsale.
751     /// @param _endTime the end time of crowdsale.
752     function setTime(Data storage _self, uint256 _startTime, uint256 _endTime) public
753     {
754         _self.startTime = _startTime;
755         _self.endTime = _endTime;
756 
757         emit CrowdsaleTimeChanged(_startTime, _endTime);
758     }
759 
760     /// @notice crowdsale has ended check.
761     /// @dev Same code if goal is used.
762     /// @return true if crowdsale event has ended
763     function hasEnded(Data storage _self) public view returns (bool) {
764         bool capReached = _self.tokensRaised >= _self.cap; 
765         bool endStateReached = (_self.state == CrowdsaleL.State.Ended || _self.state == CrowdsaleL.State.Finalized || _self.state == CrowdsaleL.State.Closed || _self.state == CrowdsaleL.State.Refunding);
766         
767         return endStateReached || capReached || now > _self.endTime;
768     }
769 
770     /// @notice Set from finalized to state closed.
771     /// @dev Must be called to close the crowdsale manually
772     function closeCrowdsale(Data storage _self) public {
773         require((_self.state == State.Finalized) || (_self.state == State.Refunding), "state");
774 
775         _self.state = State.Closed;
776     }
777 
778     /// @notice Checks if valid purchase before other ecosystem contracts roundtrip (fail early).
779     /// @return true if the transaction can buy tokens
780     function validPurchasePreCheck(Data storage _self) private view returns (bool) {
781         require(_self.state == State.Started, "not in state started");
782         bool withinPeriod = now >= _self.startTime && _self.endTime >= now;
783         require(withinPeriod, "not within period");
784 
785         return true;
786     }
787 
788     /// @notice Checks if valid purchase after other ecosystem contracts roundtrip (double check).
789     /// @return true if the transaction can buy tokens
790     function validPurchasePostCheck(Data storage _self, uint256 _tokensCreated) private view returns (bool) {
791         require(_self.state == State.Started, "not in state started");
792         bool withinCap = _self.tokensRaised.add(_tokensCreated) <= _self.cap; 
793         require(withinCap, "not within cap");
794 
795         return true;
796     }
797 
798     /// @notice simple token assignment.
799     function assignTokens(
800         Data storage _self, 
801         address _beneficiaryWallet, 
802         uint256 _tokenAmount, 
803         bytes8 _tag) 
804         public returns (uint256 _tokensCreated)
805     {
806         _tokensCreated = getController(_self).assignFromCrowdsale(
807             _beneficiaryWallet, 
808             _tokenAmount,
809             _tag);
810         
811         emit TokenPurchase(msg.sender, _beneficiaryWallet, _tokensCreated, 0, _tag);
812 
813         return _tokensCreated;
814     }
815 
816     /// @notice calc how much tokens you would receive for given ETH amount (all in unit WEI)
817     /// @dev no view keyword even if it SHOULD not change the state. But let's not trust other contracts...
818     function calcTokensForEth(Data storage _self, uint256 _ethAmountInWei) public view returns (uint256 _tokensWouldBeCreated) {
819         return getController(_self).calcTokensForEth(_ethAmountInWei);
820     }
821 
822     /// @notice If this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
823     /// @param _foreignTokenAddress token where contract has balance.
824     /// @param _to the beneficiary.
825     function rescueToken(Data storage _self, address _foreignTokenAddress, address _to) public
826     {
827         ERC20(_foreignTokenAddress).transfer(_to, ERC20(_foreignTokenAddress).balanceOf(address(this)));
828     }
829 
830 ///////////////////
831 // Events (must be redundant in calling contract to work!)
832 ///////////////////
833 
834     event TokenPurchase(address indexed invoker, address indexed beneficiary, uint256 tokenAmount, uint256 overpaidRefund, bytes8 tag);
835     event CrowdsaleTimeChanged(uint256 startTime, uint256 endTime);
836     event CrowdsaleConfigurationChanged(address wallet, address globalIndex);
837     event RolesChanged(address indexed initiator, address tokenAssignmentControl, address tokenRescueControl);
838 }
839 
840 // File: contracts/crowdsale/library/VaultGeneratorL.sol
841 
842 /*
843     Copyright 2018, CONDA
844 
845     This program is free software: you can redistribute it and/or modify
846     it under the terms of the GNU General Public License as published by
847     the Free Software Foundation, either version 3 of the License, or
848     (at your option) any later version.
849 
850     This program is distributed in the hope that it will be useful,
851     but WITHOUT ANY WARRANTY; without even the implied warranty of
852     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
853     GNU General Public License for more details.
854 
855     You should have received a copy of the GNU General Public License
856     along with this program.  If not, see <http://www.gnu.org/licenses/>.
857 */
858 
859 
860 /** @title VaultGeneratorL library. */
861 library VaultGeneratorL {
862 
863     /// @notice generate RefundEscrow vault.
864     /// @param _wallet beneficiary on success.
865     /// @return vault address that can be casted to interface.
866     function generateEthVault(address payable _wallet) public returns (address ethVaultInterface) {
867         return address(new RefundEscrow(_wallet));
868     }
869 }
870 
871 // File: contracts/crowdsale/interfaces/IBasicAssetToken.sol
872 
873 interface IBasicAssetToken {
874     //AssetToken specific
875     function getLimits() external view returns (uint256, uint256, uint256, uint256);
876     function isTokenAlive() external view returns (bool);
877 
878     //Mintable
879     function mint(address _to, uint256 _amount) external returns (bool);
880     function finishMinting() external returns (bool);
881 }
882 
883 // File: contracts/crowdsale/interface/EthVaultInterface.sol
884 
885 /**
886  * Based on OpenZeppelin RefundEscrow.sol
887  */
888 interface EthVaultInterface {
889 
890     event Closed();
891     event RefundsEnabled();
892 
893     /// @dev Stores funds that may later be refunded.
894     /// @param _refundee The address funds will be sent to if a refund occurs.
895     function deposit(address _refundee) external payable;
896 
897     /// @dev Allows for the beneficiary to withdraw their funds, rejecting
898     /// further deposits.
899     function close() external;
900 
901     /// @dev Allows for refunds to take place, rejecting further deposits.
902     function enableRefunds() external;
903 
904     /// @dev Withdraws the beneficiary's funds.
905     function beneficiaryWithdraw() external;
906 
907     /// @dev Returns whether refundees can withdraw their deposits (be refunded).
908     function withdrawalAllowed(address _payee) external view returns (bool);
909 
910     /// @dev Withdraw what someone paid into vault.
911     function withdraw(address _payee) external;
912 }
913 
914 // File: contracts/crowdsale/BasicAssetTokenCrowdsaleNoFeature.sol
915 
916 /*
917     Copyright 2018, CONDA
918 
919     This program is free software: you can redistribute it and/or modify
920     it under the terms of the GNU General Public License as published by
921     the Free Software Foundation, either version 3 of the License, or
922     (at your option) any later version.
923 
924     This program is distributed in the hope that it will be useful,
925     but WITHOUT ANY WARRANTY; without even the implied warranty of
926     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
927     GNU General Public License for more details.
928 
929     You should have received a copy of the GNU General Public License
930     along with this program.  If not, see <http://www.gnu.org/licenses/>.
931 */
932 
933 
934 
935 
936 
937 
938 
939 
940 /** @title BasicCompanyCrowdsale. Investment is stored in vault and forwarded to wallet on end. */
941 contract BasicAssetTokenCrowdsaleNoFeature is Ownable {
942     using SafeMath for uint256;
943     using CrowdsaleL for CrowdsaleL.Data;
944     using CrowdsaleL for CrowdsaleL.Roles;
945 
946     /**
947     * Crowdsale process has the following steps:
948     *   1) startCrowdsale
949     *   2) buyTokens
950     *   3) endCrowdsale
951     *   4) finalizeCrowdsale
952     */
953 
954 ///////////////////
955 // Variables
956 ///////////////////
957 
958     CrowdsaleL.Data crowdsaleData;
959     CrowdsaleL.Roles roles;
960 
961 ///////////////////
962 // Constructor
963 ///////////////////
964 
965     constructor(address _assetToken) public {
966         crowdsaleData.init(_assetToken);
967     }
968 
969 ///////////////////
970 // Modifier
971 ///////////////////
972 
973     modifier onlyTokenRescueControl() {
974         require(msg.sender == roles.tokenRescueControl, "rescueCtrl");
975         _;
976     }
977 
978 ///////////////////
979 // Simple state getters
980 ///////////////////
981 
982     function token() public view returns (address) {
983         return crowdsaleData.token;
984     }
985 
986     function wallet() public view returns (address) {
987         return crowdsaleData.wallet;
988     }
989 
990     function tokensRaised() public view returns (uint256) {
991         return crowdsaleData.tokensRaised;
992     }
993 
994     function cap() public view returns (uint256) {
995         return crowdsaleData.cap;
996     }
997 
998     function state() public view returns (CrowdsaleL.State) {
999         return crowdsaleData.state;
1000     }
1001 
1002     function startTime() public view returns (uint256) {
1003         return crowdsaleData.startTime;
1004     }
1005 
1006     function endTime() public view returns (uint256) {
1007         return crowdsaleData.endTime;
1008     }
1009 
1010     function getControllerAddress() public view returns (address) {
1011         return address(crowdsaleData.getControllerAddress());
1012     }
1013 
1014 ///////////////////
1015 // Events
1016 ///////////////////
1017 
1018     event TokenPurchase(address indexed invoker, address indexed beneficiary, uint256 tokenAmount, uint256 overpaidRefund, bytes8 tag);
1019     event CrowdsaleTimeChanged(uint256 startTime, uint256 endTime);
1020     event CrowdsaleConfigurationChanged(address wallet, address globalIndex);
1021     event RolesChanged(address indexed initiator, address tokenAssignmentControl, address tokenRescueControl);
1022     event Started();
1023     event Ended();
1024     event Finalized();
1025 
1026 ///////////////////
1027 // Modifiers
1028 ///////////////////
1029 
1030     modifier onlyTokenAssignmentControl() {
1031         require(_isTokenAssignmentControl(), "only tokenAssignmentControl");
1032         _;
1033     }
1034 
1035     modifier onlyDraftState() {
1036         require(crowdsaleData.state == CrowdsaleL.State.Draft, "only draft state");
1037         _;
1038     }
1039 
1040     modifier onlyActive() {
1041         require(_isActive(), "only when active");
1042         _;
1043     }
1044 
1045     modifier onlyActiveOrDraftState() {
1046         require(_isActiveOrDraftState(), "only active/draft");
1047         _;
1048     }
1049 
1050     modifier onlyUnfinalized() {
1051         require(crowdsaleData.state != CrowdsaleL.State.Finalized, "only unfinalized");
1052         _;
1053     }
1054 
1055     /**
1056     * @dev is crowdsale active or draft state that can be overriden.
1057     */
1058     function _isActiveOrDraftState() internal view returns (bool) {
1059         return crowdsaleData.requireActiveOrDraftState();
1060     }
1061 
1062     /**
1063     * @dev is token assignmentcontrol that can be overriden.
1064     */
1065     function _isTokenAssignmentControl() internal view returns (bool) {
1066         return msg.sender == roles.tokenAssignmentControl;
1067     }
1068 
1069     /**
1070     * @dev is active check that can be overriden.
1071     */
1072     function _isActive() internal view returns (bool) {
1073         return crowdsaleData.state == CrowdsaleL.State.Started;
1074     }
1075  
1076 ///////////////////
1077 // Status Draft
1078 ///////////////////
1079 
1080     /// @notice set required data like wallet and global index.
1081     /// @param _wallet beneficiary of crowdsale.
1082     /// @param _globalIndex global index contract holding up2date contract addresses.
1083     function setCrowdsaleData(
1084         address payable _wallet,
1085         address _globalIndex)
1086     public
1087     onlyOwner 
1088     {
1089         crowdsaleData.configure(_wallet, _globalIndex);
1090     }
1091 
1092     /// @notice get token AssignmenControl who can assign tokens (off-chain payments).
1093     function getTokenAssignmentControl() public view returns (address) {
1094         return roles.tokenAssignmentControl;
1095     }
1096 
1097     /// @notice get token RescueControl who can rescue accidentally assigned tokens to this contract.
1098     function getTokenRescueControl() public view returns (address) {
1099         return roles.tokenRescueControl;
1100     }
1101 
1102     /// @notice set cap. That's the limit how much is accepted.
1103     /// @param _cap the cap in unit token (minted AssetToken)
1104     function setCap(uint256 _cap) internal onlyUnfinalized {
1105         crowdsaleData.setCap(_cap);
1106     }
1107 
1108     /// @notice set roles/operators.
1109     /// @param _tokenAssignmentControl can assign tokens (off-chain payments).
1110     /// @param _tokenRescueControl address that is allowed rescue tokens.
1111     function setRoles(address _tokenAssignmentControl, address _tokenRescueControl) public onlyOwner {
1112         roles.setRoles(_tokenAssignmentControl, _tokenRescueControl);
1113     }
1114 
1115     /// @notice set crowdsale timeframe.
1116     /// @param _startTime crowdsale start time.
1117     /// @param _endTime crowdsale end time.
1118     function setCrowdsaleTime(uint256 _startTime, uint256 _endTime) internal onlyUnfinalized {
1119         // require(_startTime >= now, "starTime in the past"); //when getting from AT that is possible
1120         require(_endTime >= _startTime, "endTime smaller start");
1121 
1122         crowdsaleData.setTime(_startTime, _endTime);
1123     }
1124 
1125     /// @notice Update metadata like cap, time etc. from AssetToken.
1126     /// @dev It is essential that this method is at least called before start and before end.
1127     function updateFromAssetToken() public {
1128         (uint256 _cap, /*goal*/, uint256 _startTime, uint256 _endTime) = IBasicAssetToken(crowdsaleData.token).getLimits();
1129         setCap(_cap);
1130         setCrowdsaleTime(_startTime, _endTime);
1131     }
1132 
1133 ///
1134 // Status Started
1135 ///
1136 
1137     /// @notice checks all variables and starts crowdsale
1138     function startCrowdsale() public onlyDraftState {
1139         updateFromAssetToken(); //IMPORTANT
1140         
1141         require(validStart(), "validStart");
1142         prepareStart();
1143         crowdsaleData.state = CrowdsaleL.State.Started;
1144         emit Started();
1145     }
1146 
1147     /// @dev Calc how many tokens you would receive for given ETH amount (all in unit WEI)
1148     function calcTokensForEth(uint256 _ethAmountInWei) public view returns (uint256 _tokensWouldBeCreated) {
1149         return crowdsaleData.calcTokensForEth(_ethAmountInWei);
1150     }
1151 
1152     /// @dev Can be overridden to add start validation logic. The overriding function
1153     ///  should call super.validStart() to ensure the chain of validation is
1154     ///  executed entirely.
1155     function validStart() internal view returns (bool) {
1156         return crowdsaleData.validStart();
1157     }
1158 
1159     /// @dev Can be overridden to add preparation logic. The overriding function
1160     ///  should call super.prepareStart() to ensure the chain of finalization is
1161     ///  executed entirely.
1162     function prepareStart() internal {
1163     }
1164 
1165     /// @dev Determines how ETH is stored/forwarded on purchases.
1166     /// @param _overpaidRefund overpaid ETH amount (because AssetToken is 0 decimals)
1167     function forwardWeiFunds(uint256 _overpaidRefund) internal {
1168         require(_overpaidRefund <= msg.value, "unrealistic overpay");
1169         crowdsaleData.wallet.transfer(msg.value.sub(_overpaidRefund));
1170         
1171         //send overpayment back to sender. notice: only safe because executed in the end!
1172         msg.sender.transfer(_overpaidRefund);
1173     }
1174 
1175 ///
1176 // Status Ended
1177 ///
1178 
1179     /// @dev Can be called by owner to end the crowdsale manually
1180     function endCrowdsale() public onlyOwner onlyActive {
1181         updateFromAssetToken();
1182 
1183         crowdsaleData.state = CrowdsaleL.State.Ended;
1184 
1185         emit Ended();
1186     }
1187 
1188 
1189 ///
1190 // Status Finalized
1191 ///
1192 
1193     /// @dev Must be called after crowdsale ends, to do some extra finalization.
1194     function finalizeCrowdsale() public {
1195         updateFromAssetToken(); //IMPORTANT
1196 
1197         require(crowdsaleData.state == CrowdsaleL.State.Ended || crowdsaleData.state == CrowdsaleL.State.Started, "state");
1198         require(hasEnded(), "not ended");
1199         crowdsaleData.state = CrowdsaleL.State.Finalized;
1200         
1201         finalization();
1202         emit Finalized();
1203     }
1204 
1205     /// @notice status if crowdsale has ended yet.
1206     /// @return true if crowdsale event has ended.
1207     function hasEnded() public view returns (bool) {
1208         return crowdsaleData.hasEnded();
1209     }
1210 
1211     /// @dev Can be overridden to add finalization logic. The overriding function
1212     ///  should call super.finalization() to ensure the chain of finalization is
1213     ///  executed entirely.
1214     function finalization() internal {
1215     }
1216     
1217 ///
1218 // Status Closed
1219 ///
1220 
1221     /// @dev Must be called to close the crowdsale manually. The overriding function
1222     /// should call super.closeCrowdsale()
1223     function closeCrowdsale() public onlyOwner {
1224         crowdsaleData.closeCrowdsale();
1225     }
1226 
1227 ////////////////
1228 // Rescue Tokens 
1229 ////////////////
1230 
1231     /// @dev Can rescue tokens accidentally assigned to this contract
1232     /// @param _foreignTokenAddress The address from which the balance will be retrieved
1233     /// @param _to beneficiary
1234     function rescueToken(address _foreignTokenAddress, address _to)
1235     public
1236     onlyTokenRescueControl
1237     {
1238         crowdsaleData.rescueToken(_foreignTokenAddress, _to);
1239     }
1240 }
1241 
1242 // File: contracts/crowdsale/feature/AssignTokensOffChainPaymentFeature.sol
1243 
1244 /*
1245     Copyright 2018, CONDA
1246 
1247     This program is free software: you can redistribute it and/or modify
1248     it under the terms of the GNU General Public License as published by
1249     the Free Software Foundation, either version 3 of the License, or
1250     (at your option) any later version.
1251 
1252     This program is distributed in the hope that it will be useful,
1253     but WITHOUT ANY WARRANTY; without even the implied warranty of
1254     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1255     GNU General Public License for more details.
1256 
1257     You should have received a copy of the GNU General Public License
1258     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1259 */
1260 
1261 /** @title AssignTokensOffChainPaymentFeature that if inherited adds possibility mintFor(investorXY) without ETH payment. */
1262 contract AssignTokensOffChainPaymentFeature {
1263 
1264 ///////////////////
1265 // Modifiers
1266 ///////////////////
1267 
1268     modifier assignTokensPrerequisit {
1269         require(_assignTokensPrerequisit(), "assign prerequisit");
1270         _;
1271     }
1272 
1273 ///////////////////
1274 // Functions
1275 ///////////////////
1276 
1277     /// @notice If entitled call this method to assign tokens to beneficiary (use case: off-chain payment)
1278     /// @dev Token amount is assigned unmodified (no rate etc. on top)
1279     function assignTokensOffChainPayment(
1280         address _beneficiaryWallet, 
1281         uint256 _tokenAmount,
1282         bytes8 _tag) 
1283         public 
1284         assignTokensPrerequisit
1285     {
1286         _assignTokensOffChainPaymentAct(_beneficiaryWallet, _tokenAmount, _tag);
1287     }
1288 
1289 ///////////////////
1290 // Functions to override
1291 ///////////////////
1292 
1293     /// @dev Checks prerequisits (e.g. if active/draft crowdsale, permission) ***MUST OVERRIDE***
1294     function _assignTokensPrerequisit() internal view returns (bool) {
1295         revert("override assignTokensPrerequisit");
1296     }
1297 
1298     /// @dev Assign tokens act ***MUST OVERRIDE***
1299     function _assignTokensOffChainPaymentAct(address /*_beneficiaryWallet*/, uint256 /*_tokenAmount*/, bytes8 /*_tag*/) 
1300         internal returns (bool)
1301     {
1302         revert("override buyTokensWithEtherAct");
1303     }
1304 }
1305 
1306 // File: contracts/crowdsale/STOs/AssetTokenCrowdsaleT001.sol
1307 
1308 /// @title AssetTokenCrowdsaleT001. Functionality of BasicAssetTokenNoFeatures with the AssignTokensOffChainPaymentFeature feature.
1309 contract AssetTokenCrowdsaleT001 is BasicAssetTokenCrowdsaleNoFeature, AssignTokensOffChainPaymentFeature {
1310 
1311 ///////////////////
1312 // Constructor
1313 ///////////////////
1314 
1315     constructor(address _assetToken) public BasicAssetTokenCrowdsaleNoFeature(_assetToken) {
1316 
1317     }
1318 
1319 ///////////////////
1320 // Feature functions internal overrides
1321 ///////////////////
1322 
1323     /// @dev override of assign tokens prerequisit of possible features.
1324     function _assignTokensPrerequisit() internal view returns (bool) {
1325         return (_isTokenAssignmentControl() && _isActiveOrDraftState());
1326     }
1327 
1328     /// @dev method executed on assign tokens because of off-chain payment (if feature is inherited).
1329     function _assignTokensOffChainPaymentAct(address _beneficiaryWallet, uint256 _tokenAmount, bytes8 _tag)
1330         internal returns (bool) 
1331     {
1332         crowdsaleData.assignTokens(_beneficiaryWallet, _tokenAmount, _tag);
1333         return true;
1334     }
1335 }