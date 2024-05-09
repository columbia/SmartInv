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
351 // File: contracts/crowdsale/interfaces/IGlobalIndex.sol
352 
353 interface IGlobalIndex {
354     function getControllerAddress() external view returns (address);
355     function setControllerAddress(address _newControllerAddress) external;
356 }
357 
358 // File: contracts/crowdsale/interfaces/ICRWDController.sol
359 
360 interface ICRWDController {
361     function buyFromCrowdsale(address _to, uint256 _amountInWei) external returns (uint256 _tokensCreated, uint256 _overpaidRefund); //from Crowdsale
362     function assignFromCrowdsale(address _to, uint256 _tokenAmount, bytes8 _tag) external returns (uint256 _tokensCreated); //from Crowdsale
363     function calcTokensForEth(uint256 _amountInWei) external view returns (uint256 _tokensWouldBeCreated); //from Crowdsale
364 }
365 
366 // File: openzeppelin-solidity/contracts/ownership/Secondary.sol
367 
368 /**
369  * @title Secondary
370  * @dev A Secondary contract can only be used by its primary account (the one that created it)
371  */
372 contract Secondary {
373     address private _primary;
374 
375     event PrimaryTransferred(
376         address recipient
377     );
378 
379     /**
380      * @dev Sets the primary account to the one that is creating the Secondary contract.
381      */
382     constructor () internal {
383         _primary = msg.sender;
384         emit PrimaryTransferred(_primary);
385     }
386 
387     /**
388      * @dev Reverts if called from any account other than the primary.
389      */
390     modifier onlyPrimary() {
391         require(msg.sender == _primary);
392         _;
393     }
394 
395     /**
396      * @return the address of the primary.
397      */
398     function primary() public view returns (address) {
399         return _primary;
400     }
401 
402     /**
403      * @dev Transfers contract to a new primary.
404      * @param recipient The address of new primary.
405      */
406     function transferPrimary(address recipient) public onlyPrimary {
407         require(recipient != address(0));
408         _primary = recipient;
409         emit PrimaryTransferred(_primary);
410     }
411 }
412 
413 // File: openzeppelin-solidity/contracts/payment/escrow/Escrow.sol
414 
415 /**
416  * @title Escrow
417  * @dev Base escrow contract, holds funds designated for a payee until they
418  * withdraw them.
419  * @dev Intended usage: This contract (and derived escrow contracts) should be a
420  * standalone contract, that only interacts with the contract that instantiated
421  * it. That way, it is guaranteed that all Ether will be handled according to
422  * the Escrow rules, and there is no need to check for payable functions or
423  * transfers in the inheritance tree. The contract that uses the escrow as its
424  * payment method should be its primary, and provide public methods redirecting
425  * to the escrow's deposit and withdraw.
426  */
427 contract Escrow is Secondary {
428     using SafeMath for uint256;
429 
430     event Deposited(address indexed payee, uint256 weiAmount);
431     event Withdrawn(address indexed payee, uint256 weiAmount);
432 
433     mapping(address => uint256) private _deposits;
434 
435     function depositsOf(address payee) public view returns (uint256) {
436         return _deposits[payee];
437     }
438 
439     /**
440     * @dev Stores the sent amount as credit to be withdrawn.
441     * @param payee The destination address of the funds.
442     */
443     function deposit(address payee) public onlyPrimary payable {
444         uint256 amount = msg.value;
445         _deposits[payee] = _deposits[payee].add(amount);
446 
447         emit Deposited(payee, amount);
448     }
449 
450     /**
451     * @dev Withdraw accumulated balance for a payee.
452     * @param payee The address whose funds will be withdrawn and transferred to.
453     */
454     function withdraw(address payable payee) public onlyPrimary {
455         uint256 payment = _deposits[payee];
456 
457         _deposits[payee] = 0;
458 
459         payee.transfer(payment);
460 
461         emit Withdrawn(payee, payment);
462     }
463 }
464 
465 // File: openzeppelin-solidity/contracts/payment/escrow/ConditionalEscrow.sol
466 
467 /**
468  * @title ConditionalEscrow
469  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
470  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
471  */
472 contract ConditionalEscrow is Escrow {
473     /**
474     * @dev Returns whether an address is allowed to withdraw their funds. To be
475     * implemented by derived contracts.
476     * @param payee The destination address of the funds.
477     */
478     function withdrawalAllowed(address payee) public view returns (bool);
479 
480     function withdraw(address payable payee) public {
481         require(withdrawalAllowed(payee));
482         super.withdraw(payee);
483     }
484 }
485 
486 // File: openzeppelin-solidity/contracts/payment/escrow/RefundEscrow.sol
487 
488 /**
489  * @title RefundEscrow
490  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
491  * parties.
492  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
493  * @dev The primary account (that is, the contract that instantiates this
494  * contract) may deposit, close the deposit period, and allow for either
495  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
496  * with RefundEscrow will be made through the primary contract. See the
497  * RefundableCrowdsale contract for an example of RefundEscrow’s use.
498  */
499 contract RefundEscrow is ConditionalEscrow {
500     enum State { Active, Refunding, Closed }
501 
502     event RefundsClosed();
503     event RefundsEnabled();
504 
505     State private _state;
506     address payable private _beneficiary;
507 
508     /**
509      * @dev Constructor.
510      * @param beneficiary The beneficiary of the deposits.
511      */
512     constructor (address payable beneficiary) public {
513         require(beneficiary != address(0));
514         _beneficiary = beneficiary;
515         _state = State.Active;
516     }
517 
518     /**
519      * @return the current state of the escrow.
520      */
521     function state() public view returns (State) {
522         return _state;
523     }
524 
525     /**
526      * @return the beneficiary of the escrow.
527      */
528     function beneficiary() public view returns (address) {
529         return _beneficiary;
530     }
531 
532     /**
533      * @dev Stores funds that may later be refunded.
534      * @param refundee The address funds will be sent to if a refund occurs.
535      */
536     function deposit(address refundee) public payable {
537         require(_state == State.Active);
538         super.deposit(refundee);
539     }
540 
541     /**
542      * @dev Allows for the beneficiary to withdraw their funds, rejecting
543      * further deposits.
544      */
545     function close() public onlyPrimary {
546         require(_state == State.Active);
547         _state = State.Closed;
548         emit RefundsClosed();
549     }
550 
551     /**
552      * @dev Allows for refunds to take place, rejecting further deposits.
553      */
554     function enableRefunds() public onlyPrimary {
555         require(_state == State.Active);
556         _state = State.Refunding;
557         emit RefundsEnabled();
558     }
559 
560     /**
561      * @dev Withdraws the beneficiary's funds.
562      */
563     function beneficiaryWithdraw() public {
564         require(_state == State.Closed);
565         _beneficiary.transfer(address(this).balance);
566     }
567 
568     /**
569      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overriden function receives a
570      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
571      */
572     function withdrawalAllowed(address) public view returns (bool) {
573         return _state == State.Refunding;
574     }
575 }
576 
577 // File: contracts/crowdsale/library/CrowdsaleL.sol
578 
579 /*
580     Copyright 2018, CONDA
581 
582     This program is free software: you can redistribute it and/or modify
583     it under the terms of the GNU General Public License as published by
584     the Free Software Foundation, either version 3 of the License, or
585     (at your option) any later version.
586 
587     This program is distributed in the hope that it will be useful,
588     but WITHOUT ANY WARRANTY; without even the implied warranty of
589     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
590     GNU General Public License for more details.
591 
592     You should have received a copy of the GNU General Public License
593     along with this program.  If not, see <http://www.gnu.org/licenses/>.
594 */
595 
596 
597 
598 
599 
600 
601 /** @title CrowdsaleL library. */
602 library CrowdsaleL {
603     using SafeMath for uint256;
604 
605 ///////////////////
606 // Structs
607 ///////////////////
608 
609     /// @dev All crowdsale states.
610     enum State { Draft, Started, Ended, Finalized, Refunding, Closed }
611 
612     struct Data {
613         // The token being sold type ERC20
614         address token;
615 
616         // status of crowdsale
617         State state;
618 
619         // the max cap of tokens being sold
620         uint256 cap;
621 
622         // the start time of crowdsale.
623         uint256 startTime;
624         
625         // the end time of crowdsale
626         uint256 endTime;
627 
628         // address where funds are collected
629         address payable wallet;
630 
631         // the global index holding contract addresses
632         IGlobalIndex globalIndex;
633 
634         // amount of tokens raised by money in all allowed currencies
635         uint256 tokensRaised;
636     }
637 
638     struct Roles {
639         // can assign tokens on off-chain payments
640         address tokenAssignmentControl;
641 
642         // role that can rescue accidentally sent tokens
643         address tokenRescueControl;
644     }
645 
646 ///////////////////
647 // Functions
648 ///////////////////
649 
650     /// @notice Initialize function for initial setup (during construction).
651     /// @param _assetToken The asset token being sold.
652     function init(Data storage _self, address _assetToken) public {
653         _self.token = _assetToken;
654         _self.state = State.Draft;
655     }
656 
657     /// @notice Confiugure function for setup (during negotiations).
658     /// @param _wallet beneficiary wallet on successful crowdsale.
659     /// @param _globalIndex the contract holding current contract addresses.
660     function configure(
661         Data storage _self, 
662         address payable _wallet, 
663         address _globalIndex)
664     public 
665     {
666         require(_self.state == CrowdsaleL.State.Draft, "not draft state");
667         require(_wallet != address(0), "wallet zero addr");
668         require(_globalIndex != address(0), "globalIdx zero addr");
669 
670         _self.wallet = _wallet;
671         _self.globalIndex = IGlobalIndex(_globalIndex);
672 
673         emit CrowdsaleConfigurationChanged(_wallet, _globalIndex);
674     }
675 
676     /// @notice Set roles/operators.
677     /// @param _tokenAssignmentControl token assignment control (off-chain payment).
678     /// @param _tokenRescueControl token rescue control (accidentally assigned tokens).
679     function setRoles(Roles storage _self, address _tokenAssignmentControl, address _tokenRescueControl) public {
680         require(_tokenAssignmentControl != address(0), "addr0");
681         require(_tokenRescueControl != address(0), "addr0");
682         
683         _self.tokenAssignmentControl = _tokenAssignmentControl;
684         _self.tokenRescueControl = _tokenRescueControl;
685 
686         emit RolesChanged(msg.sender, _tokenAssignmentControl, _tokenRescueControl);
687     }
688 
689     /// @notice gets current controller address.
690     function getControllerAddress(Data storage _self) public view returns (address) {
691         return IGlobalIndex(_self.globalIndex).getControllerAddress();
692     }
693 
694     /// @dev gets controller with interface for internal use.
695     function getController(Data storage _self) private view returns (ICRWDController) {
696         return ICRWDController(getControllerAddress(_self));
697     }
698 
699     /// @notice set cap.
700     /// @param _cap token cap of tokens being sold.
701     function setCap(Data storage _self, uint256 _cap) public {
702         // require(requireActiveOrDraftState(_self), "require active/draft"); // No! Could have been changed by AT owner...
703         // require(_cap > 0, "cap 0"); // No! Decided by AssetToken owner...
704         _self.cap = _cap;
705     }
706 
707     /// @notice Low level token purchase function with ether.
708     /// @param _beneficiary who receives tokens.
709     /// @param _investedAmount the invested ETH amount.
710     function buyTokensFor(Data storage _self, address _beneficiary, uint256 _investedAmount) 
711     public 
712     returns (uint256)
713     {
714         require(validPurchasePreCheck(_self), "invalid purchase precheck");
715 
716         (uint256 tokenAmount, uint256 overpaidRefund) = getController(_self).buyFromCrowdsale(_beneficiary, _investedAmount);
717 
718         if(tokenAmount == 0) {
719             // Special handling full refund if too little ETH (could be small drift depending on off-chain API accuracy)
720             overpaidRefund = _investedAmount;
721         }
722 
723         require(validPurchasePostCheck(_self, tokenAmount), "invalid purchase postcheck");
724         _self.tokensRaised = _self.tokensRaised.add(tokenAmount);
725 
726         emit TokenPurchase(msg.sender, _beneficiary, tokenAmount, overpaidRefund, "ETH");
727 
728         return overpaidRefund;
729     }
730 
731     /// @dev Fails if not active or draft state
732     function requireActiveOrDraftState(Data storage _self) public view returns (bool) {
733         require((_self.state == State.Draft) || (_self.state == State.Started), "only active or draft state");
734 
735         return true;
736     }
737 
738     /// @notice Valid start basic logic.
739     /// @dev In contract could be extended logic e.g. checking goal)
740     function validStart(Data storage _self) public view returns (bool) {
741         require(_self.wallet != address(0), "wallet is zero addr");
742         require(_self.token != address(0), "token is zero addr");
743         require(_self.cap > 0, "cap is 0");
744         require(_self.startTime != 0, "time not set");
745         require(now >= _self.startTime, "too early");
746 
747         return true;
748     }
749 
750     /// @notice Set the timeframe.
751     /// @param _startTime the start time of crowdsale.
752     /// @param _endTime the end time of crowdsale.
753     function setTime(Data storage _self, uint256 _startTime, uint256 _endTime) public
754     {
755         _self.startTime = _startTime;
756         _self.endTime = _endTime;
757 
758         emit CrowdsaleTimeChanged(_startTime, _endTime);
759     }
760 
761     /// @notice crowdsale has ended check.
762     /// @dev Same code if goal is used.
763     /// @return true if crowdsale event has ended
764     function hasEnded(Data storage _self) public view returns (bool) {
765         bool capReached = _self.tokensRaised >= _self.cap; 
766         bool endStateReached = (_self.state == CrowdsaleL.State.Ended || _self.state == CrowdsaleL.State.Finalized || _self.state == CrowdsaleL.State.Closed || _self.state == CrowdsaleL.State.Refunding);
767         
768         return endStateReached || capReached || now > _self.endTime;
769     }
770 
771     /// @notice Set from finalized to state closed.
772     /// @dev Must be called to close the crowdsale manually
773     function closeCrowdsale(Data storage _self) public {
774         require((_self.state == State.Finalized) || (_self.state == State.Refunding), "state");
775 
776         _self.state = State.Closed;
777     }
778 
779     /// @notice Checks if valid purchase before other ecosystem contracts roundtrip (fail early).
780     /// @return true if the transaction can buy tokens
781     function validPurchasePreCheck(Data storage _self) private view returns (bool) {
782         require(_self.state == State.Started, "not in state started");
783         bool withinPeriod = now >= _self.startTime && _self.endTime >= now;
784         require(withinPeriod, "not within period");
785 
786         return true;
787     }
788 
789     /// @notice Checks if valid purchase after other ecosystem contracts roundtrip (double check).
790     /// @return true if the transaction can buy tokens
791     function validPurchasePostCheck(Data storage _self, uint256 _tokensCreated) private view returns (bool) {
792         require(_self.state == State.Started, "not in state started");
793         bool withinCap = _self.tokensRaised.add(_tokensCreated) <= _self.cap; 
794         require(withinCap, "not within cap");
795 
796         return true;
797     }
798 
799     /// @notice simple token assignment.
800     function assignTokens(
801         Data storage _self, 
802         address _beneficiaryWallet, 
803         uint256 _tokenAmount, 
804         bytes8 _tag) 
805         public returns (uint256 _tokensCreated)
806     {
807         _tokensCreated = getController(_self).assignFromCrowdsale(
808             _beneficiaryWallet, 
809             _tokenAmount,
810             _tag);
811         
812         emit TokenPurchase(msg.sender, _beneficiaryWallet, _tokensCreated, 0, _tag);
813 
814         return _tokensCreated;
815     }
816 
817     /// @notice calc how much tokens you would receive for given ETH amount (all in unit WEI)
818     /// @dev no view keyword even if it SHOULD not change the state. But let's not trust other contracts...
819     function calcTokensForEth(Data storage _self, uint256 _ethAmountInWei) public view returns (uint256 _tokensWouldBeCreated) {
820         return getController(_self).calcTokensForEth(_ethAmountInWei);
821     }
822 
823     /// @notice If this contract gets a balance in some other ERC20 contract - or even iself - then we can rescue it.
824     /// @param _foreignTokenAddress token where contract has balance.
825     /// @param _to the beneficiary.
826     function rescueToken(Data storage _self, address _foreignTokenAddress, address _to) public
827     {
828         ERC20(_foreignTokenAddress).transfer(_to, ERC20(_foreignTokenAddress).balanceOf(address(this)));
829     }
830 
831 ///////////////////
832 // Events (must be redundant in calling contract to work!)
833 ///////////////////
834 
835     event TokenPurchase(address indexed invoker, address indexed beneficiary, uint256 tokenAmount, uint256 overpaidRefund, bytes8 tag);
836     event CrowdsaleTimeChanged(uint256 startTime, uint256 endTime);
837     event CrowdsaleConfigurationChanged(address wallet, address globalIndex);
838     event RolesChanged(address indexed initiator, address tokenAssignmentControl, address tokenRescueControl);
839 }
840 
841 // File: contracts/crowdsale/library/VaultGeneratorL.sol
842 
843 /*
844     Copyright 2018, CONDA
845 
846     This program is free software: you can redistribute it and/or modify
847     it under the terms of the GNU General Public License as published by
848     the Free Software Foundation, either version 3 of the License, or
849     (at your option) any later version.
850 
851     This program is distributed in the hope that it will be useful,
852     but WITHOUT ANY WARRANTY; without even the implied warranty of
853     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
854     GNU General Public License for more details.
855 
856     You should have received a copy of the GNU General Public License
857     along with this program.  If not, see <http://www.gnu.org/licenses/>.
858 */
859 
860 
861 /** @title VaultGeneratorL library. */
862 library VaultGeneratorL {
863 
864     /// @notice generate RefundEscrow vault.
865     /// @param _wallet beneficiary on success.
866     /// @return vault address that can be casted to interface.
867     function generateEthVault(address payable _wallet) public returns (address ethVaultInterface) {
868         return address(new RefundEscrow(_wallet));
869     }
870 }
871 
872 // File: contracts/crowdsale/interfaces/IBasicAssetToken.sol
873 
874 interface IBasicAssetToken {
875     //AssetToken specific
876     function getLimits() external view returns (uint256, uint256, uint256, uint256);
877     function isTokenAlive() external view returns (bool);
878 
879     //Mintable
880     function mint(address _to, uint256 _amount) external returns (bool);
881     function finishMinting() external returns (bool);
882 }
883 
884 // File: contracts/crowdsale/interface/EthVaultInterface.sol
885 
886 /**
887  * Based on OpenZeppelin RefundEscrow.sol
888  */
889 interface EthVaultInterface {
890 
891     event Closed();
892     event RefundsEnabled();
893 
894     /// @dev Stores funds that may later be refunded.
895     /// @param _refundee The address funds will be sent to if a refund occurs.
896     function deposit(address _refundee) external payable;
897 
898     /// @dev Allows for the beneficiary to withdraw their funds, rejecting
899     /// further deposits.
900     function close() external;
901 
902     /// @dev Allows for refunds to take place, rejecting further deposits.
903     function enableRefunds() external;
904 
905     /// @dev Withdraws the beneficiary's funds.
906     function beneficiaryWithdraw() external;
907 
908     /// @dev Returns whether refundees can withdraw their deposits (be refunded).
909     function withdrawalAllowed(address _payee) external view returns (bool);
910 
911     /// @dev Withdraw what someone paid into vault.
912     function withdraw(address _payee) external;
913 }
914 
915 // File: contracts/crowdsale/BasicAssetTokenCrowdsaleNoFeature.sol
916 
917 /*
918     Copyright 2018, CONDA
919 
920     This program is free software: you can redistribute it and/or modify
921     it under the terms of the GNU General Public License as published by
922     the Free Software Foundation, either version 3 of the License, or
923     (at your option) any later version.
924 
925     This program is distributed in the hope that it will be useful,
926     but WITHOUT ANY WARRANTY; without even the implied warranty of
927     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
928     GNU General Public License for more details.
929 
930     You should have received a copy of the GNU General Public License
931     along with this program.  If not, see <http://www.gnu.org/licenses/>.
932 */
933 
934 
935 
936 
937 
938 
939 
940 
941 /** @title BasicCompanyCrowdsale. Investment is stored in vault and forwarded to wallet on end. */
942 contract BasicAssetTokenCrowdsaleNoFeature is Ownable {
943     using SafeMath for uint256;
944     using CrowdsaleL for CrowdsaleL.Data;
945     using CrowdsaleL for CrowdsaleL.Roles;
946 
947     /**
948     * Crowdsale process has the following steps:
949     *   1) startCrowdsale
950     *   2) buyTokens
951     *   3) endCrowdsale
952     *   4) finalizeCrowdsale
953     */
954 
955 ///////////////////
956 // Variables
957 ///////////////////
958 
959     CrowdsaleL.Data crowdsaleData;
960     CrowdsaleL.Roles roles;
961 
962 ///////////////////
963 // Constructor
964 ///////////////////
965 
966     constructor(address _assetToken) public {
967         crowdsaleData.init(_assetToken);
968     }
969 
970 ///////////////////
971 // Modifier
972 ///////////////////
973 
974     modifier onlyTokenRescueControl() {
975         require(msg.sender == roles.tokenRescueControl, "rescueCtrl");
976         _;
977     }
978 
979 ///////////////////
980 // Simple state getters
981 ///////////////////
982 
983     function token() public view returns (address) {
984         return crowdsaleData.token;
985     }
986 
987     function wallet() public view returns (address) {
988         return crowdsaleData.wallet;
989     }
990 
991     function tokensRaised() public view returns (uint256) {
992         return crowdsaleData.tokensRaised;
993     }
994 
995     function cap() public view returns (uint256) {
996         return crowdsaleData.cap;
997     }
998 
999     function state() public view returns (CrowdsaleL.State) {
1000         return crowdsaleData.state;
1001     }
1002 
1003     function startTime() public view returns (uint256) {
1004         return crowdsaleData.startTime;
1005     }
1006 
1007     function endTime() public view returns (uint256) {
1008         return crowdsaleData.endTime;
1009     }
1010 
1011     function getControllerAddress() public view returns (address) {
1012         return address(crowdsaleData.getControllerAddress());
1013     }
1014 
1015 ///////////////////
1016 // Events
1017 ///////////////////
1018 
1019     event TokenPurchase(address indexed invoker, address indexed beneficiary, uint256 tokenAmount, uint256 overpaidRefund, bytes8 tag);
1020     event CrowdsaleTimeChanged(uint256 startTime, uint256 endTime);
1021     event CrowdsaleConfigurationChanged(address wallet, address globalIndex);
1022     event RolesChanged(address indexed initiator, address tokenAssignmentControl, address tokenRescueControl);
1023     event Started();
1024     event Ended();
1025     event Finalized();
1026 
1027 ///////////////////
1028 // Modifiers
1029 ///////////////////
1030 
1031     modifier onlyTokenAssignmentControl() {
1032         require(_isTokenAssignmentControl(), "only tokenAssignmentControl");
1033         _;
1034     }
1035 
1036     modifier onlyDraftState() {
1037         require(crowdsaleData.state == CrowdsaleL.State.Draft, "only draft state");
1038         _;
1039     }
1040 
1041     modifier onlyActive() {
1042         require(_isActive(), "only when active");
1043         _;
1044     }
1045 
1046     modifier onlyActiveOrDraftState() {
1047         require(_isActiveOrDraftState(), "only active/draft");
1048         _;
1049     }
1050 
1051     modifier onlyUnfinalized() {
1052         require(crowdsaleData.state != CrowdsaleL.State.Finalized, "only unfinalized");
1053         _;
1054     }
1055 
1056     /**
1057     * @dev is crowdsale active or draft state that can be overriden.
1058     */
1059     function _isActiveOrDraftState() internal view returns (bool) {
1060         return crowdsaleData.requireActiveOrDraftState();
1061     }
1062 
1063     /**
1064     * @dev is token assignmentcontrol that can be overriden.
1065     */
1066     function _isTokenAssignmentControl() internal view returns (bool) {
1067         return msg.sender == roles.tokenAssignmentControl;
1068     }
1069 
1070     /**
1071     * @dev is active check that can be overriden.
1072     */
1073     function _isActive() internal view returns (bool) {
1074         return crowdsaleData.state == CrowdsaleL.State.Started;
1075     }
1076  
1077 ///////////////////
1078 // Status Draft
1079 ///////////////////
1080 
1081     /// @notice set required data like wallet and global index.
1082     /// @param _wallet beneficiary of crowdsale.
1083     /// @param _globalIndex global index contract holding up2date contract addresses.
1084     function setCrowdsaleData(
1085         address payable _wallet,
1086         address _globalIndex)
1087     public
1088     onlyOwner 
1089     {
1090         crowdsaleData.configure(_wallet, _globalIndex);
1091     }
1092 
1093     /// @notice get token AssignmenControl who can assign tokens (off-chain payments).
1094     function getTokenAssignmentControl() public view returns (address) {
1095         return roles.tokenAssignmentControl;
1096     }
1097 
1098     /// @notice get token RescueControl who can rescue accidentally assigned tokens to this contract.
1099     function getTokenRescueControl() public view returns (address) {
1100         return roles.tokenRescueControl;
1101     }
1102 
1103     /// @notice set cap. That's the limit how much is accepted.
1104     /// @param _cap the cap in unit token (minted AssetToken)
1105     function setCap(uint256 _cap) internal onlyUnfinalized {
1106         crowdsaleData.setCap(_cap);
1107     }
1108 
1109     /// @notice set roles/operators.
1110     /// @param _tokenAssignmentControl can assign tokens (off-chain payments).
1111     /// @param _tokenRescueControl address that is allowed rescue tokens.
1112     function setRoles(address _tokenAssignmentControl, address _tokenRescueControl) public onlyOwner {
1113         roles.setRoles(_tokenAssignmentControl, _tokenRescueControl);
1114     }
1115 
1116     /// @notice set crowdsale timeframe.
1117     /// @param _startTime crowdsale start time.
1118     /// @param _endTime crowdsale end time.
1119     function setCrowdsaleTime(uint256 _startTime, uint256 _endTime) internal onlyUnfinalized {
1120         // require(_startTime >= now, "starTime in the past"); //when getting from AT that is possible
1121         require(_endTime >= _startTime, "endTime smaller start");
1122 
1123         crowdsaleData.setTime(_startTime, _endTime);
1124     }
1125 
1126     /// @notice Update metadata like cap, time etc. from AssetToken.
1127     /// @dev It is essential that this method is at least called before start and before end.
1128     function updateFromAssetToken() public {
1129         (uint256 _cap, /*goal*/, uint256 _startTime, uint256 _endTime) = IBasicAssetToken(crowdsaleData.token).getLimits();
1130         setCap(_cap);
1131         setCrowdsaleTime(_startTime, _endTime);
1132     }
1133 
1134 ///
1135 // Status Started
1136 ///
1137 
1138     /// @notice checks all variables and starts crowdsale
1139     function startCrowdsale() public onlyDraftState {
1140         updateFromAssetToken(); //IMPORTANT
1141         
1142         require(validStart(), "validStart");
1143         prepareStart();
1144         crowdsaleData.state = CrowdsaleL.State.Started;
1145         emit Started();
1146     }
1147 
1148     /// @dev Calc how many tokens you would receive for given ETH amount (all in unit WEI)
1149     function calcTokensForEth(uint256 _ethAmountInWei) public view returns (uint256 _tokensWouldBeCreated) {
1150         return crowdsaleData.calcTokensForEth(_ethAmountInWei);
1151     }
1152 
1153     /// @dev Can be overridden to add start validation logic. The overriding function
1154     ///  should call super.validStart() to ensure the chain of validation is
1155     ///  executed entirely.
1156     function validStart() internal view returns (bool) {
1157         return crowdsaleData.validStart();
1158     }
1159 
1160     /// @dev Can be overridden to add preparation logic. The overriding function
1161     ///  should call super.prepareStart() to ensure the chain of finalization is
1162     ///  executed entirely.
1163     function prepareStart() internal {
1164     }
1165 
1166     /// @dev Determines how ETH is stored/forwarded on purchases.
1167     /// @param _overpaidRefund overpaid ETH amount (because AssetToken is 0 decimals)
1168     function forwardWeiFunds(uint256 _overpaidRefund) internal {
1169         require(_overpaidRefund <= msg.value, "unrealistic overpay");
1170         crowdsaleData.wallet.transfer(msg.value.sub(_overpaidRefund));
1171         
1172         //send overpayment back to sender. notice: only safe because executed in the end!
1173         msg.sender.transfer(_overpaidRefund);
1174     }
1175 
1176 ///
1177 // Status Ended
1178 ///
1179 
1180     /// @dev Can be called by owner to end the crowdsale manually
1181     function endCrowdsale() public onlyOwner onlyActive {
1182         updateFromAssetToken();
1183 
1184         crowdsaleData.state = CrowdsaleL.State.Ended;
1185 
1186         emit Ended();
1187     }
1188 
1189 
1190 ///
1191 // Status Finalized
1192 ///
1193 
1194     /// @dev Must be called after crowdsale ends, to do some extra finalization.
1195     function finalizeCrowdsale() public {
1196         updateFromAssetToken(); //IMPORTANT
1197 
1198         require(crowdsaleData.state == CrowdsaleL.State.Ended || crowdsaleData.state == CrowdsaleL.State.Started, "state");
1199         require(hasEnded(), "not ended");
1200         crowdsaleData.state = CrowdsaleL.State.Finalized;
1201         
1202         finalization();
1203         emit Finalized();
1204     }
1205 
1206     /// @notice status if crowdsale has ended yet.
1207     /// @return true if crowdsale event has ended.
1208     function hasEnded() public view returns (bool) {
1209         return crowdsaleData.hasEnded();
1210     }
1211 
1212     /// @dev Can be overridden to add finalization logic. The overriding function
1213     ///  should call super.finalization() to ensure the chain of finalization is
1214     ///  executed entirely.
1215     function finalization() internal {
1216     }
1217     
1218 ///
1219 // Status Closed
1220 ///
1221 
1222     /// @dev Must be called to close the crowdsale manually. The overriding function
1223     /// should call super.closeCrowdsale()
1224     function closeCrowdsale() public onlyOwner {
1225         crowdsaleData.closeCrowdsale();
1226     }
1227 
1228 ////////////////
1229 // Rescue Tokens 
1230 ////////////////
1231 
1232     /// @dev Can rescue tokens accidentally assigned to this contract
1233     /// @param _foreignTokenAddress The address from which the balance will be retrieved
1234     /// @param _to beneficiary
1235     function rescueToken(address _foreignTokenAddress, address _to)
1236     public
1237     onlyTokenRescueControl
1238     {
1239         crowdsaleData.rescueToken(_foreignTokenAddress, _to);
1240     }
1241 }
1242 
1243 // File: contracts/crowdsale/feature/AssignTokensOffChainPaymentFeature.sol
1244 
1245 /*
1246     Copyright 2018, CONDA
1247 
1248     This program is free software: you can redistribute it and/or modify
1249     it under the terms of the GNU General Public License as published by
1250     the Free Software Foundation, either version 3 of the License, or
1251     (at your option) any later version.
1252 
1253     This program is distributed in the hope that it will be useful,
1254     but WITHOUT ANY WARRANTY; without even the implied warranty of
1255     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1256     GNU General Public License for more details.
1257 
1258     You should have received a copy of the GNU General Public License
1259     along with this program.  If not, see <http://www.gnu.org/licenses/>.
1260 */
1261 
1262 /** @title AssignTokensOffChainPaymentFeature that if inherited adds possibility mintFor(investorXY) without ETH payment. */
1263 contract AssignTokensOffChainPaymentFeature {
1264 
1265 ///////////////////
1266 // Modifiers
1267 ///////////////////
1268 
1269     modifier assignTokensPrerequisit {
1270         require(_assignTokensPrerequisit(), "assign prerequisit");
1271         _;
1272     }
1273 
1274 ///////////////////
1275 // Functions
1276 ///////////////////
1277 
1278     /// @notice If entitled call this method to assign tokens to beneficiary (use case: off-chain payment)
1279     /// @dev Token amount is assigned unmodified (no rate etc. on top)
1280     function assignTokensOffChainPayment(
1281         address _beneficiaryWallet, 
1282         uint256 _tokenAmount,
1283         bytes8 _tag) 
1284         public 
1285         assignTokensPrerequisit
1286     {
1287         _assignTokensOffChainPaymentAct(_beneficiaryWallet, _tokenAmount, _tag);
1288     }
1289 
1290 ///////////////////
1291 // Functions to override
1292 ///////////////////
1293 
1294     /// @dev Checks prerequisits (e.g. if active/draft crowdsale, permission) ***MUST OVERRIDE***
1295     function _assignTokensPrerequisit() internal view returns (bool) {
1296         revert("override assignTokensPrerequisit");
1297     }
1298 
1299     /// @dev Assign tokens act ***MUST OVERRIDE***
1300     function _assignTokensOffChainPaymentAct(address /*_beneficiaryWallet*/, uint256 /*_tokenAmount*/, bytes8 /*_tag*/) 
1301         internal returns (bool)
1302     {
1303         revert("override buyTokensWithEtherAct");
1304     }
1305 }
1306 
1307 // File: contracts/crowdsale/STOs/AssetTokenCrowdsaleT001.sol
1308 
1309 /// @title AssetTokenCrowdsaleT001. Functionality of BasicAssetTokenNoFeatures with the AssignTokensOffChainPaymentFeature feature.
1310 contract AssetTokenCrowdsaleT001 is BasicAssetTokenCrowdsaleNoFeature, AssignTokensOffChainPaymentFeature {
1311 
1312 ///////////////////
1313 // Constructor
1314 ///////////////////
1315 
1316     constructor(address _assetToken) public BasicAssetTokenCrowdsaleNoFeature(_assetToken) {
1317 
1318     }
1319 
1320 ///////////////////
1321 // Feature functions internal overrides
1322 ///////////////////
1323 
1324     /// @dev override of assign tokens prerequisit of possible features.
1325     function _assignTokensPrerequisit() internal view returns (bool) {
1326         return (_isTokenAssignmentControl() && _isActiveOrDraftState());
1327     }
1328 
1329     /// @dev method executed on assign tokens because of off-chain payment (if feature is inherited).
1330     function _assignTokensOffChainPaymentAct(address _beneficiaryWallet, uint256 _tokenAmount, bytes8 _tag)
1331         internal returns (bool) 
1332     {
1333         crowdsaleData.assignTokens(_beneficiaryWallet, _tokenAmount, _tag);
1334         return true;
1335     }
1336 }