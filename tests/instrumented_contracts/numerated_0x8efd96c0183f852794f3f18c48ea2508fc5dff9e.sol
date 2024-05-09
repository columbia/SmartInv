1 pragma solidity 0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address private _owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor () internal {
18         _owner = msg.sender;
19         emit OwnershipTransferred(address(0), _owner);
20     }
21 
22     /**
23      * @return the address of the owner.
24      */
25     function owner() public view returns (address) {
26         return _owner;
27     }
28 
29     /**
30      * @dev Throws if called by any account other than the owner.
31      */
32     modifier onlyOwner() {
33         require(isOwner());
34         _;
35     }
36 
37     /**
38      * @return true if `msg.sender` is the owner of the contract.
39      */
40     function isOwner() public view returns (bool) {
41         return msg.sender == _owner;
42     }
43 
44     /**
45      * @dev Allows the current owner to relinquish control of the contract.
46      * @notice Renouncing to ownership will leave the contract without an owner.
47      * It will not be possible to call the functions with the `onlyOwner`
48      * modifier anymore.
49      */
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) public onlyOwner {
60         _transferOwnership(newOwner);
61     }
62 
63     /**
64      * @dev Transfers control of the contract to a newOwner.
65      * @param newOwner The address to transfer ownership to.
66      */
67     function _transferOwnership(address newOwner) internal {
68         require(newOwner != address(0));
69         emit OwnershipTransferred(_owner, newOwner);
70         _owner = newOwner;
71     }
72 }
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that revert on error
77  */
78 library SafeMath {
79     int256 constant private INT256_MIN = -2**255;
80 
81     /**
82     * @dev Multiplies two unsigned integers, reverts on overflow.
83     */
84     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
86         // benefit is lost if 'b' is also tested.
87         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
88         if (a == 0) {
89             return 0;
90         }
91 
92         uint256 c = a * b;
93         require(c / a == b);
94 
95         return c;
96     }
97 
98     /**
99     * @dev Multiplies two signed integers, reverts on overflow.
100     */
101     function mul(int256 a, int256 b) internal pure returns (int256) {
102         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
103         // benefit is lost if 'b' is also tested.
104         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
105         if (a == 0) {
106             return 0;
107         }
108 
109         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
110 
111         int256 c = a * b;
112         require(c / a == b);
113 
114         return c;
115     }
116 
117     /**
118     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
119     */
120     function div(uint256 a, uint256 b) internal pure returns (uint256) {
121         // Solidity only automatically asserts when dividing by 0
122         require(b > 0);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
131     */
132     function div(int256 a, int256 b) internal pure returns (int256) {
133         require(b != 0); // Solidity only automatically asserts when dividing by 0
134         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
135 
136         int256 c = a / b;
137 
138         return c;
139     }
140 
141     /**
142     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
143     */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         require(b <= a);
146         uint256 c = a - b;
147 
148         return c;
149     }
150 
151     /**
152     * @dev Subtracts two signed integers, reverts on overflow.
153     */
154     function sub(int256 a, int256 b) internal pure returns (int256) {
155         int256 c = a - b;
156         require((b >= 0 && c <= a) || (b < 0 && c > a));
157 
158         return c;
159     }
160 
161     /**
162     * @dev Adds two unsigned integers, reverts on overflow.
163     */
164     function add(uint256 a, uint256 b) internal pure returns (uint256) {
165         uint256 c = a + b;
166         require(c >= a);
167 
168         return c;
169     }
170 
171     /**
172     * @dev Adds two signed integers, reverts on overflow.
173     */
174     function add(int256 a, int256 b) internal pure returns (int256) {
175         int256 c = a + b;
176         require((b >= 0 && c >= a) || (b < 0 && c < a));
177 
178         return c;
179     }
180 
181     /**
182     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
183     * reverts when dividing by zero.
184     */
185     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
186         require(b != 0);
187         return a % b;
188     }
189 }
190 
191 /**
192   * @title Escrow (based on openzeppelin version with one function to withdraw funds to the wallet)
193   * @dev Base escrow contract, holds funds destinated to a payee until they
194   * withdraw them. The contract that uses the escrow as its payment method
195   * should be its owner, and provide public methods redirecting to the escrow's
196   * deposit and withdraw.
197   */
198 contract Escrow is Ownable {
199     using SafeMath for uint256;
200 
201     event Deposited(address indexed payee, uint256 weiAmount);
202     event Withdrawn(address indexed payee, uint256 weiAmount);
203 
204     mapping(address => uint256) private deposits;
205 
206     /**
207       * @dev Stores the sent amount as credit to be withdrawn.
208       * @param _payee The destination address of the funds.
209       */
210     function deposit(address _payee) public onlyOwner payable {
211         uint256 amount = msg.value;
212         deposits[_payee] = deposits[_payee].add(amount);
213 
214         emit Deposited(_payee, amount);
215     }
216 
217     /**
218       * @dev Withdraw accumulated balance for a payee.
219       * @param _payee The address whose funds will be withdrawn and transferred to.
220       * @return Amount withdrawn
221       */
222     function withdraw(address _payee) public onlyOwner returns(uint256) {
223         uint256 payment = deposits[_payee];
224 
225         assert(address(this).balance >= payment);
226 
227         deposits[_payee] = 0;
228 
229         _payee.transfer(payment);
230 
231         emit Withdrawn(_payee, payment);
232         return payment;
233     }
234 
235     /**
236       * @dev Withdraws the wallet's funds.
237       * @param _wallet address the funds will be transferred to.
238       */
239     function beneficiaryWithdraw(address _wallet) public onlyOwner {
240         uint256 _amount = address(this).balance;
241         
242         _wallet.transfer(_amount);
243 
244         emit Withdrawn(_wallet, _amount);
245     }
246 
247     /**
248       * @dev Returns the deposited amount of the given address.
249       * @param _payee address of the payee of which to return the deposted amount.
250       * @return Deposited amount by the address given as argument.
251       */
252     function depositsOf(address _payee) public view returns(uint256) {
253         return deposits[_payee];
254     }
255 }
256 
257 /**
258   * @title PullPayment (based on openzeppelin version with one function to withdraw funds to the wallet)
259   * @dev Base contract supporting async send for pull payments. Inherit from this
260   * contract and use asyncTransfer instead of send or transfer.
261   */
262 contract PullPayment {
263     Escrow private escrow;
264 
265     constructor() public {
266         escrow = new Escrow();
267     }
268 
269     /**
270       * @dev Returns the credit owed to an address.
271       * @param _dest The creditor's address.
272       * @return Deposited amount by the address given as argument.
273       */
274     function payments(address _dest) public view returns(uint256) {
275         return escrow.depositsOf(_dest);
276     }
277 
278     /**
279       * @dev Withdraw accumulated balance, called by payee.
280       * @param _payee The address whose funds will be withdrawn and transferred to.
281       * @return Amount withdrawn
282       */
283     function _withdrawPayments(address _payee) internal returns(uint256) {
284         uint256 payment = escrow.withdraw(_payee);
285 
286         return payment;
287     }
288 
289     /**
290       * @dev Called by the payer to store the sent amount as credit to be pulled.
291       * @param _dest The destination address of the funds.
292       * @param _amount The amount to transfer.
293       */
294     function _asyncTransfer(address _dest, uint256 _amount) internal {
295         escrow.deposit.value(_amount)(_dest);
296     }
297 
298     /**
299       * @dev Withdraws the wallet's funds.
300       * @param _wallet address the funds will be transferred to.
301       */
302     function _withdrawFunds(address _wallet) internal {
303         escrow.beneficiaryWithdraw(_wallet);
304     }
305 }
306 
307 /** @title VestedCrowdsale
308   * @dev Extension of Crowdsale to allow a vested distribution of tokens
309   * Users have to individually claim their tokens
310   */
311 contract VestedCrowdsale {
312     using SafeMath for uint256;
313 
314     mapping (address => uint256) public withdrawn;
315     mapping (address => uint256) public contributions;
316     mapping (address => uint256) public contributionsRound;
317     uint256 public vestedTokens;
318 
319     /**
320       * @dev Gives how much a user is allowed to withdraw at the current moment
321       * @param _beneficiary The address of the user asking how much he's allowed
322       * to withdraw
323       * @return Amount _beneficiary is allowed to withdraw
324       */
325     function getWithdrawableAmount(address _beneficiary) public view returns(uint256) {
326         uint256 step = _getVestingStep(_beneficiary);
327         uint256 valueByStep = _getValueByStep(_beneficiary);
328         uint256 result = step.mul(valueByStep).sub(withdrawn[_beneficiary]);
329 
330         return result;
331     }
332 
333     /**
334       * @dev Gives the step of the vesting (starts from 0 to steps)
335       * @param _beneficiary The address of the user asking how much he's allowed
336       * to withdraw
337       * @return The vesting step for _beneficiary
338       */
339     function _getVestingStep(address _beneficiary) internal view returns(uint8) {
340         require(contributions[_beneficiary] != 0);
341         require(contributionsRound[_beneficiary] > 0 && contributionsRound[_beneficiary] < 4);
342 
343         uint256 march31 = 1554019200;
344         uint256 april30 = 1556611200;
345         uint256 may31 = 1559289600;
346         uint256 june30 = 1561881600;
347         uint256 july31 = 1564560000;
348         uint256 sept30 = 1569830400;
349         uint256 contributionRound = contributionsRound[_beneficiary];
350 
351         // vesting for private sale contributors
352         if (contributionRound == 1) {
353             if (block.timestamp < march31) {
354                 return 0;
355             }
356             if (block.timestamp < june30) {
357                 return 1;
358             }
359             if (block.timestamp < sept30) {
360                 return 2;
361             }
362 
363             return 3;
364         }
365         // vesting for pre ico contributors
366         if (contributionRound == 2) {
367             if (block.timestamp < april30) {
368                 return 0;
369             }
370             if (block.timestamp < july31) {
371                 return 1;
372             }
373 
374             return 2;
375         }
376         // vesting for ico contributors
377         if (contributionRound == 3) {
378             if (block.timestamp < may31) {
379                 return 0;
380             }
381 
382             return 1;
383         }
384     }
385 
386     /**
387       * @dev Gives the amount a user is allowed to withdraw by step
388       * @param _beneficiary The address of the user asking how much he's allowed
389       * to withdraw
390       * @return How much a user is allowed to withdraw by step
391       */
392     function _getValueByStep(address _beneficiary) internal view returns(uint256) {
393         require(contributions[_beneficiary] != 0);
394         require(contributionsRound[_beneficiary] > 0 && contributionsRound[_beneficiary] < 4);
395 
396         uint256 contributionRound = contributionsRound[_beneficiary];
397         uint256 amount;
398         uint256 rate;
399 
400         if (contributionRound == 1) {
401             rate = 416700;
402             amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
403             return amount;
404         } else if (contributionRound == 2) {
405             rate = 312500;
406             amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
407             return amount;
408         }
409 
410         rate = 250000;
411         amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
412         return amount;
413     }
414 }
415 
416 /**
417   * @title Whitelist
418   * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
419   * This simplifies the implementation of "user permissions".
420   */
421 contract Whitelist is Ownable {
422     // Whitelisted address
423     mapping(address => bool) public whitelist;
424 
425     event AddedBeneficiary(address indexed _beneficiary);
426     event RemovedBeneficiary(address indexed _beneficiary);
427 
428     /**
429       * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
430       * @param _beneficiaries Addresses to be added to the whitelist
431       */
432     function addAddressToWhitelist(address[] _beneficiaries) public onlyOwner {
433         for (uint256 i = 0; i < _beneficiaries.length; i++) {
434             whitelist[_beneficiaries[i]] = true;
435 
436             emit AddedBeneficiary(_beneficiaries[i]);
437         }
438     }
439 
440     /**
441       * @dev Adds list of address to whitelist. Not overloaded due to limitations with truffle testing.
442       * @param _beneficiary Address to be added to the whitelist
443       */
444     function addToWhitelist(address _beneficiary) public onlyOwner {
445         whitelist[_beneficiary] = true;
446 
447         emit AddedBeneficiary(_beneficiary);
448     }
449 
450     /**
451       * @dev Removes single address from whitelist.
452       * @param _beneficiary Address to be removed to the whitelist
453       */
454     function removeFromWhitelist(address _beneficiary) public onlyOwner {
455         whitelist[_beneficiary] = false;
456 
457         emit RemovedBeneficiary(_beneficiary);
458     }
459 }
460 
461 /**
462  * @title Roles
463  * @dev Library for managing addresses assigned to a Role.
464  */
465 library Roles {
466     struct Role {
467         mapping (address => bool) bearer;
468     }
469 
470     /**
471      * @dev give an account access to this role
472      */
473     function add(Role storage role, address account) internal {
474         require(account != address(0));
475         require(!has(role, account));
476 
477         role.bearer[account] = true;
478     }
479 
480     /**
481      * @dev remove an account's access to this role
482      */
483     function remove(Role storage role, address account) internal {
484         require(account != address(0));
485         require(has(role, account));
486 
487         role.bearer[account] = false;
488     }
489 
490     /**
491      * @dev check if an account has this role
492      * @return bool
493      */
494     function has(Role storage role, address account) internal view returns (bool) {
495         require(account != address(0));
496         return role.bearer[account];
497     }
498 }
499 
500 contract PauserRole {
501     using Roles for Roles.Role;
502 
503     event PauserAdded(address indexed account);
504     event PauserRemoved(address indexed account);
505 
506     Roles.Role private _pausers;
507 
508     constructor () internal {
509         _addPauser(msg.sender);
510     }
511 
512     modifier onlyPauser() {
513         require(isPauser(msg.sender));
514         _;
515     }
516 
517     function isPauser(address account) public view returns (bool) {
518         return _pausers.has(account);
519     }
520 
521     function addPauser(address account) public onlyPauser {
522         _addPauser(account);
523     }
524 
525     function renouncePauser() public {
526         _removePauser(msg.sender);
527     }
528 
529     function _addPauser(address account) internal {
530         _pausers.add(account);
531         emit PauserAdded(account);
532     }
533 
534     function _removePauser(address account) internal {
535         _pausers.remove(account);
536         emit PauserRemoved(account);
537     }
538 }
539 
540 /**
541  * @title Pausable
542  * @dev Base contract which allows children to implement an emergency stop mechanism.
543  */
544 contract Pausable is PauserRole {
545     event Paused(address account);
546     event Unpaused(address account);
547 
548     bool private _paused;
549 
550     constructor () internal {
551         _paused = false;
552     }
553 
554     /**
555      * @return true if the contract is paused, false otherwise.
556      */
557     function paused() public view returns (bool) {
558         return _paused;
559     }
560 
561     /**
562      * @dev Modifier to make a function callable only when the contract is not paused.
563      */
564     modifier whenNotPaused() {
565         require(!_paused);
566         _;
567     }
568 
569     /**
570      * @dev Modifier to make a function callable only when the contract is paused.
571      */
572     modifier whenPaused() {
573         require(_paused);
574         _;
575     }
576 
577     /**
578      * @dev called by the owner to pause, triggers stopped state
579      */
580     function pause() public onlyPauser whenNotPaused {
581         _paused = true;
582         emit Paused(msg.sender);
583     }
584 
585     /**
586      * @dev called by the owner to unpause, returns to normal state
587      */
588     function unpause() public onlyPauser whenPaused {
589         _paused = false;
590         emit Unpaused(msg.sender);
591     }
592 }
593 
594 /**
595  * @title ERC20 interface
596  * @dev see https://github.com/ethereum/EIPs/issues/20
597  */
598 interface IERC20 {
599     function totalSupply() external view returns (uint256);
600 
601     function balanceOf(address who) external view returns (uint256);
602 
603     function allowance(address owner, address spender) external view returns (uint256);
604 
605     function transfer(address to, uint256 value) external returns (bool);
606 
607     function approve(address spender, uint256 value) external returns (bool);
608 
609     function transferFrom(address from, address to, uint256 value) external returns (bool);
610 
611     event Transfer(address indexed from, address indexed to, uint256 value);
612 
613     event Approval(address indexed owner, address indexed spender, uint256 value);
614 }
615 
616 /**
617  * @title Standard ERC20 token
618  *
619  * @dev Implementation of the basic standard token.
620  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
621  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
622  *
623  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
624  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
625  * compliant implementations may not do it.
626  */
627 contract ERC20 is IERC20 {
628     using SafeMath for uint256;
629 
630     mapping (address => uint256) private _balances;
631 
632     mapping (address => mapping (address => uint256)) private _allowed;
633 
634     uint256 private _totalSupply;
635 
636     /**
637     * @dev Total number of tokens in existence
638     */
639     function totalSupply() public view returns (uint256) {
640         return _totalSupply;
641     }
642 
643     /**
644     * @dev Gets the balance of the specified address.
645     * @param owner The address to query the balance of.
646     * @return An uint256 representing the amount owned by the passed address.
647     */
648     function balanceOf(address owner) public view returns (uint256) {
649         return _balances[owner];
650     }
651 
652     /**
653      * @dev Function to check the amount of tokens that an owner allowed to a spender.
654      * @param owner address The address which owns the funds.
655      * @param spender address The address which will spend the funds.
656      * @return A uint256 specifying the amount of tokens still available for the spender.
657      */
658     function allowance(address owner, address spender) public view returns (uint256) {
659         return _allowed[owner][spender];
660     }
661 
662     /**
663     * @dev Transfer token for a specified address
664     * @param to The address to transfer to.
665     * @param value The amount to be transferred.
666     */
667     function transfer(address to, uint256 value) public returns (bool) {
668         _transfer(msg.sender, to, value);
669         return true;
670     }
671 
672     /**
673      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
674      * Beware that changing an allowance with this method brings the risk that someone may use both the old
675      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
676      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
677      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
678      * @param spender The address which will spend the funds.
679      * @param value The amount of tokens to be spent.
680      */
681     function approve(address spender, uint256 value) public returns (bool) {
682         require(spender != address(0));
683 
684         _allowed[msg.sender][spender] = value;
685         emit Approval(msg.sender, spender, value);
686         return true;
687     }
688 
689     /**
690      * @dev Transfer tokens from one address to another.
691      * Note that while this function emits an Approval event, this is not required as per the specification,
692      * and other compliant implementations may not emit the event.
693      * @param from address The address which you want to send tokens from
694      * @param to address The address which you want to transfer to
695      * @param value uint256 the amount of tokens to be transferred
696      */
697     function transferFrom(address from, address to, uint256 value) public returns (bool) {
698         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
699         _transfer(from, to, value);
700         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
701         return true;
702     }
703 
704     /**
705      * @dev Increase the amount of tokens that an owner allowed to a spender.
706      * approve should be called when allowed_[_spender] == 0. To increment
707      * allowed value is better to use this function to avoid 2 calls (and wait until
708      * the first transaction is mined)
709      * From MonolithDAO Token.sol
710      * Emits an Approval event.
711      * @param spender The address which will spend the funds.
712      * @param addedValue The amount of tokens to increase the allowance by.
713      */
714     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
715         require(spender != address(0));
716 
717         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
718         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
719         return true;
720     }
721 
722     /**
723      * @dev Decrease the amount of tokens that an owner allowed to a spender.
724      * approve should be called when allowed_[_spender] == 0. To decrement
725      * allowed value is better to use this function to avoid 2 calls (and wait until
726      * the first transaction is mined)
727      * From MonolithDAO Token.sol
728      * Emits an Approval event.
729      * @param spender The address which will spend the funds.
730      * @param subtractedValue The amount of tokens to decrease the allowance by.
731      */
732     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
733         require(spender != address(0));
734 
735         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
736         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
737         return true;
738     }
739 
740     /**
741     * @dev Transfer token for a specified addresses
742     * @param from The address to transfer from.
743     * @param to The address to transfer to.
744     * @param value The amount to be transferred.
745     */
746     function _transfer(address from, address to, uint256 value) internal {
747         require(to != address(0));
748 
749         _balances[from] = _balances[from].sub(value);
750         _balances[to] = _balances[to].add(value);
751         emit Transfer(from, to, value);
752     }
753 
754     /**
755      * @dev Internal function that mints an amount of the token and assigns it to
756      * an account. This encapsulates the modification of balances such that the
757      * proper events are emitted.
758      * @param account The account that will receive the created tokens.
759      * @param value The amount that will be created.
760      */
761     function _mint(address account, uint256 value) internal {
762         require(account != address(0));
763 
764         _totalSupply = _totalSupply.add(value);
765         _balances[account] = _balances[account].add(value);
766         emit Transfer(address(0), account, value);
767     }
768 
769     /**
770      * @dev Internal function that burns an amount of the token of a given
771      * account.
772      * @param account The account whose tokens will be burnt.
773      * @param value The amount that will be burnt.
774      */
775     function _burn(address account, uint256 value) internal {
776         require(account != address(0));
777 
778         _totalSupply = _totalSupply.sub(value);
779         _balances[account] = _balances[account].sub(value);
780         emit Transfer(account, address(0), value);
781     }
782 
783     /**
784      * @dev Internal function that burns an amount of the token of a given
785      * account, deducting from the sender's allowance for said account. Uses the
786      * internal burn function.
787      * Emits an Approval event (reflecting the reduced allowance).
788      * @param account The account whose tokens will be burnt.
789      * @param value The amount that will be burnt.
790      */
791     function _burnFrom(address account, uint256 value) internal {
792         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
793         _burn(account, value);
794         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
795     }
796 }
797 
798 /**
799  * @title Burnable Token
800  * @dev Token that can be irreversibly burned (destroyed).
801  */
802 contract ERC20Burnable is ERC20 {
803     /**
804      * @dev Burns a specific amount of tokens.
805      * @param value The amount of token to be burned.
806      */
807     function burn(uint256 value) public {
808         _burn(msg.sender, value);
809     }
810 
811     /**
812      * @dev Burns a specific amount of tokens from the target address and decrements allowance
813      * @param from address The address which you want to send tokens from
814      * @param value uint256 The amount of token to be burned
815      */
816     function burnFrom(address from, uint256 value) public {
817         _burnFrom(from, value);
818     }
819 }
820 
821 /**
822   * @title DSLACrowdsale
823   * @dev Crowdsale is a base contract for managing a token crowdsale,
824   * allowing investors to purchase tokens with ether
825   */
826 contract DSLACrowdsale is VestedCrowdsale, Whitelist, Pausable, PullPayment {
827     // struct to store ico rounds details
828     struct IcoRound {
829         uint256 rate;
830         uint256 individualFloor;
831         uint256 individualCap;
832         uint256 softCap;
833         uint256 hardCap;
834     }
835 
836     // mapping ico rounds
837     mapping (uint256 => IcoRound) public icoRounds;
838     // The token being sold
839     ERC20Burnable private _token;
840     // Address where funds are collected
841     address private _wallet;
842     // Amount of wei raised
843     uint256 private totalContributionAmount;
844     // Tokens to sell = 5 Billions * 10^18 = 5 * 10^27 = 5000000000000000000000000000
845     uint256 public constant TOKENSFORSALE = 5000000000000000000000000000;
846     // Current ico round
847     uint256 public currentIcoRound;
848     // Distributed Tokens
849     uint256 public distributedTokens;
850     // Amount of wei raised from other currencies
851     uint256 public weiRaisedFromOtherCurrencies;
852     // Refund period on
853     bool public isRefunding = false;
854     // Finalized crowdsale off
855     bool public isFinalized = false;
856     // Refunding deadline
857     uint256 public refundDeadline;
858 
859     /**
860       * Event for token purchase logging
861       * @param purchaser who paid for the tokens
862       * @param beneficiary who got the tokens
863       * @param value weis paid for purchase
864       * @param amount amount of tokens purchased
865       */
866     event TokensPurchased(
867         address indexed purchaser,
868         address indexed beneficiary,
869         uint256 value,
870         uint256 amount
871     );
872 
873     /**
874       * @param wallet Address where collected funds will be forwarded to
875       * @param token Address of the token being sold
876       */
877     constructor(address wallet, ERC20Burnable token) public {
878         require(wallet != address(0) && token != address(0));
879 
880         icoRounds[1] = IcoRound(
881             416700,
882             3 ether,
883             600 ether,
884             0,
885             1200 ether
886         );
887 
888         icoRounds[2] = IcoRound(
889             312500,
890             12 ether,
891             5000 ether,
892             0,
893             6000 ether
894         );
895 
896         icoRounds[3] = IcoRound(
897             250000,
898             3 ether,
899             30 ether,
900             7200 ether,
901             17200 ether
902         );
903 
904         _wallet = wallet;
905         _token = token;
906     }
907 
908     /**
909       * @dev fallback function ***DO NOT OVERRIDE***
910       */
911     function () external payable {
912         buyTokens(msg.sender);
913     }
914 
915     /**
916       * @dev low level token purchase ***DO NOT OVERRIDE***
917       * @param _contributor Address performing the token purchase
918       */
919     function buyTokens(address _contributor) public payable {
920         require(whitelist[_contributor]);
921 
922         uint256 contributionAmount = msg.value;
923 
924         _preValidatePurchase(_contributor, contributionAmount, currentIcoRound);
925 
926         totalContributionAmount = totalContributionAmount.add(contributionAmount);
927 
928         uint tokenAmount = _handlePurchase(contributionAmount, currentIcoRound, _contributor);
929 
930         emit TokensPurchased(msg.sender, _contributor, contributionAmount, tokenAmount);
931 
932         _forwardFunds();
933     }
934 
935     /**
936       * @dev Function to go to the next round
937       * @return True bool when round is incremented
938       */
939     function goToNextRound() public onlyOwner returns(bool) {
940         require(currentIcoRound >= 0 && currentIcoRound < 3);
941 
942         currentIcoRound = currentIcoRound + 1;
943 
944         return true;
945     }
946 
947     /**
948       * @dev Manually adds a contributor's contribution for private presale period
949       * @param _contributor The address of the contributor
950       * @param _contributionAmount Amount of wei contributed
951       */
952     function addPrivateSaleContributors(address _contributor, uint256 _contributionAmount)
953     public onlyOwner
954     {
955         uint privateSaleRound = 1;
956         _preValidatePurchase(_contributor, _contributionAmount, privateSaleRound);
957 
958         totalContributionAmount = totalContributionAmount.add(_contributionAmount);
959 
960         addToWhitelist(_contributor);
961 
962         _handlePurchase(_contributionAmount, privateSaleRound, _contributor);
963     }
964 
965     /**
966       * @dev Manually adds a contributor's contribution with other currencies
967       * @param _contributor The address of the contributor
968       * @param _contributionAmount Amount of wei contributed
969       * @param _round contribution round
970       */
971     function addOtherCurrencyContributors(address _contributor, uint256 _contributionAmount, uint256 _round)
972     public onlyOwner
973     {
974         _preValidatePurchase(_contributor, _contributionAmount, _round);
975 
976         weiRaisedFromOtherCurrencies = weiRaisedFromOtherCurrencies.add(_contributionAmount);
977 
978         addToWhitelist(_contributor);
979 
980         _handlePurchase(_contributionAmount, _round, _contributor);
981     }
982 
983     /**
984       * @dev Function to close refunding period
985       * @return True bool
986       */
987     function closeRefunding() public returns(bool) {
988         require(isRefunding);
989         require(block.timestamp > refundDeadline);
990 
991         isRefunding = false;
992 
993         _withdrawFunds(wallet());
994 
995         return true;
996     }
997 
998     /**
999       * @dev Function to close the crowdsale
1000       * @return True bool
1001       */
1002     function closeCrowdsale() public onlyOwner returns(bool) {
1003         require(currentIcoRound > 0 && currentIcoRound < 4);
1004 
1005         currentIcoRound = 4;
1006 
1007         return true;
1008     }
1009 
1010     /**
1011       * @dev Function to finalize the crowdsale
1012       * @param _burn bool burn unsold tokens when true
1013       * @return True bool
1014       */
1015     function finalizeCrowdsale(bool _burn) public onlyOwner returns(bool) {
1016         require(currentIcoRound == 4 && !isRefunding);
1017 
1018         if (raisedFunds() < icoRounds[3].softCap) {
1019             isRefunding = true;
1020             refundDeadline = block.timestamp + 4 weeks;
1021 
1022             return true;
1023         }
1024 
1025         require(!isFinalized);
1026 
1027         _withdrawFunds(wallet());
1028         isFinalized = true;
1029 
1030         if (_burn) {
1031             _burnUnsoldTokens();
1032         } else {
1033             _withdrawUnsoldTokens();
1034         }
1035 
1036         return  true;
1037     }
1038 
1039     /**
1040       * @dev Investors can claim refunds here if crowdsale is unsuccessful
1041       */
1042     function claimRefund() public {
1043         require(isRefunding);
1044         require(block.timestamp <= refundDeadline);
1045         require(payments(msg.sender) > 0);
1046 
1047         uint256 payment = _withdrawPayments(msg.sender);
1048 
1049         totalContributionAmount = totalContributionAmount.sub(payment);
1050     }
1051 
1052     /**
1053       * @dev Allows the sender to claim the tokens he is allowed to withdraw
1054       */
1055     function claimTokens() public {
1056         require(getWithdrawableAmount(msg.sender) != 0);
1057 
1058         uint256 amount = getWithdrawableAmount(msg.sender);
1059         withdrawn[msg.sender] = withdrawn[msg.sender].add(amount);
1060 
1061         _deliverTokens(msg.sender, amount);
1062     }
1063 
1064     /**
1065       * @dev returns the token being sold
1066       * @return the token being sold
1067       */
1068     function token() public view returns(ERC20Burnable) {
1069         return _token;
1070     }
1071 
1072     /**
1073       * @dev returns the wallet address that collects the funds
1074       * @return the address where funds are collected
1075       */
1076     function wallet() public view returns(address) {
1077         return _wallet;
1078     }
1079 
1080     /**
1081       * @dev Returns the total of raised funds
1082       * @return total amount of raised funds
1083       */
1084     function raisedFunds() public view returns(uint256) {
1085         return totalContributionAmount.add(weiRaisedFromOtherCurrencies);
1086     }
1087 
1088     // -----------------------------------------
1089     // Internal interface
1090     // -----------------------------------------
1091     /**
1092       * @dev Source of tokens. Override this method to modify the way in which
1093       * the crowdsale ultimately gets and sends its tokens.
1094       * @param _beneficiary Address performing the token purchase
1095       * @param _tokenAmount Number of tokens to be emitted
1096       */
1097     function _deliverTokens(address _beneficiary, uint256 _tokenAmount)
1098     internal
1099     {
1100         _token.transfer(_beneficiary, _tokenAmount);
1101     }
1102 
1103     /**
1104       * @dev Determines how ETH is stored/forwarded on purchases.
1105       */
1106     function _forwardFunds()
1107     internal
1108     {
1109         if (currentIcoRound == 2 || currentIcoRound == 3) {
1110             _asyncTransfer(msg.sender, msg.value);
1111         } else {
1112             _wallet.transfer(msg.value);
1113         }
1114     }
1115 
1116     /**
1117       * @dev Gets tokens allowed to deliver in the given round
1118       * @param _tokenAmount total amount of tokens involved in the purchase
1119       * @param _round Round in which the purchase is happening
1120       * @return Returns the amount of tokens allowed to deliver
1121       */
1122     function _getTokensToDeliver(uint _tokenAmount, uint _round)
1123     internal pure returns(uint)
1124     {
1125         require(_round > 0 && _round < 4);
1126         uint deliverPercentage = _round.mul(25);
1127 
1128         return _tokenAmount.mul(deliverPercentage).div(100);
1129     }
1130 
1131     /**
1132       * @dev Handles token purchasing
1133       * @param _contributor Address performing the token purchase
1134       * @param _contributionAmount Value in wei involved in the purchase
1135       * @param _round Round in which the purchase is happening
1136       * @return Returns the amount of tokens purchased
1137       */
1138     function _handlePurchase(uint _contributionAmount, uint _round, address _contributor)
1139     internal returns(uint) {
1140         uint256 soldTokens = distributedTokens.add(vestedTokens);
1141         uint256 tokenAmount = _getTokenAmount(_contributionAmount, _round);
1142 
1143         require(tokenAmount.add(soldTokens) <= TOKENSFORSALE);
1144 
1145         contributions[_contributor] = contributions[_contributor].add(_contributionAmount);
1146         contributionsRound[_contributor] = _round;
1147 
1148         uint tokensToDeliver = _getTokensToDeliver(tokenAmount, _round);
1149         uint tokensToVest = tokenAmount.sub(tokensToDeliver);
1150 
1151         distributedTokens = distributedTokens.add(tokensToDeliver);
1152         vestedTokens = vestedTokens.add(tokensToVest);
1153 
1154         _deliverTokens(_contributor, tokensToDeliver);
1155 
1156         return tokenAmount;
1157     }
1158 
1159     /**
1160       * @dev Validation of an incoming purchase.
1161       * @param _contributor Address performing the token purchase
1162       * @param _contributionAmount Value in wei involved in the purchase
1163       * @param _round Round in which the purchase is happening
1164       */
1165     function _preValidatePurchase(address _contributor, uint256 _contributionAmount, uint _round)
1166     internal view
1167     {
1168         require(_contributor != address(0));
1169         require(currentIcoRound > 0 && currentIcoRound < 4);
1170         require(_round > 0 && _round < 4);
1171         require(contributions[_contributor] == 0);
1172         require(_contributionAmount >= icoRounds[_round].individualFloor);
1173         require(_contributionAmount < icoRounds[_round].individualCap);
1174         require(_doesNotExceedHardCap(_contributionAmount, _round));
1175     }
1176 
1177     /**
1178       * @dev define the way in which ether is converted to tokens.
1179       * @param _contributionAmount Value in wei to be converted into tokens
1180       * @return Number of tokens that can be purchased with the specified _contributionAmount
1181       */
1182     function _getTokenAmount(uint256 _contributionAmount, uint256 _round)
1183     internal view returns(uint256)
1184     {
1185         uint256 _rate = icoRounds[_round].rate;
1186         return _contributionAmount.mul(_rate);
1187     }
1188 
1189     /**
1190       * @dev Checks if current round hardcap will not be exceeded by a new contribution
1191       * @param _contributionAmount purchase amount in Wei
1192       * @param _round Round in which the purchase is happening
1193       * @return true when current hardcap is not exceeded, false if exceeded
1194       */
1195     function _doesNotExceedHardCap(uint _contributionAmount, uint _round)
1196     internal view returns(bool)
1197     {
1198         uint roundHardCap = icoRounds[_round].hardCap;
1199         return totalContributionAmount.add(_contributionAmount) <= roundHardCap;
1200     }
1201 
1202     /**
1203       * @dev Function to burn unsold tokens
1204       */
1205     function _burnUnsoldTokens()
1206     internal
1207     {
1208         uint256 tokensToBurn = TOKENSFORSALE.sub(vestedTokens).sub(distributedTokens);
1209 
1210         _token.burn(tokensToBurn);
1211     }
1212 
1213     /**
1214       * @dev Transfer the unsold tokens to the funds collecting address
1215       */
1216     function _withdrawUnsoldTokens()
1217     internal {
1218         uint256 tokensToWithdraw = TOKENSFORSALE.sub(vestedTokens).sub(distributedTokens);
1219 
1220         _token.transfer(_wallet, tokensToWithdraw);
1221     }
1222 }