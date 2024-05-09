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
76  * @dev Unsigned math operations with safety checks that revert on error
77  */
78 library SafeMath {
79     /**
80     * @dev Multiplies two unsigned integers, reverts on overflow.
81     */
82     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
83         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
84         // benefit is lost if 'b' is also tested.
85         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
86         if (a == 0) {
87             return 0;
88         }
89 
90         uint256 c = a * b;
91         require(c / a == b);
92 
93         return c;
94     }
95 
96     /**
97     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
98     */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     /**
109     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
110     */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         require(b <= a);
113         uint256 c = a - b;
114 
115         return c;
116     }
117 
118     /**
119     * @dev Adds two unsigned integers, reverts on overflow.
120     */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a);
124 
125         return c;
126     }
127 
128     /**
129     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
130     * reverts when dividing by zero.
131     */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         require(b != 0);
134         return a % b;
135     }
136 }
137 
138 
139 /**
140   * @title Escrow (based on openzeppelin version with one function to withdraw funds to the wallet)
141   * @dev Base escrow contract, holds funds destinated to a payee until they
142   * withdraw them. The contract that uses the escrow as its payment method
143   * should be its owner, and provide public methods redirecting to the escrow's
144   * deposit and withdraw.
145   */
146 contract Escrow is Ownable {
147     using SafeMath for uint256;
148 
149     event Deposited(address indexed payee, uint256 weiAmount);
150     event Withdrawn(address indexed payee, uint256 weiAmount);
151 
152     mapping(address => uint256) private deposits;
153 
154     /**
155       * @dev Stores the sent amount as credit to be withdrawn.
156       * @param _payee The destination address of the funds.
157       */
158     function deposit(address _payee) public onlyOwner payable {
159         uint256 amount = msg.value;
160         deposits[_payee] = deposits[_payee].add(amount);
161 
162         emit Deposited(_payee, amount);
163     }
164 
165     /**
166       * @dev Withdraw accumulated balance for a payee.
167       * @param _payee The address whose funds will be withdrawn and transferred to.
168       * @return Amount withdrawn
169       */
170     function withdraw(address _payee) public onlyOwner returns(uint256) {
171         uint256 payment = deposits[_payee];
172 
173         assert(address(this).balance >= payment);
174 
175         deposits[_payee] = 0;
176 
177         _payee.transfer(payment);
178 
179         emit Withdrawn(_payee, payment);
180         return payment;
181     }
182 
183     /**
184       * @dev Withdraws the wallet's funds.
185       * @param _wallet address the funds will be transferred to.
186       */
187     function beneficiaryWithdraw(address _wallet) public onlyOwner {
188         uint256 _amount = address(this).balance;
189         
190         _wallet.transfer(_amount);
191 
192         emit Withdrawn(_wallet, _amount);
193     }
194 
195     /**
196       * @dev Returns the deposited amount of the given address.
197       * @param _payee address of the payee of which to return the deposted amount.
198       * @return Deposited amount by the address given as argument.
199       */
200     function depositsOf(address _payee) public view returns(uint256) {
201         return deposits[_payee];
202     }
203 }
204 
205 /**
206   * @title PullPayment (based on openzeppelin version with one function to withdraw funds to the wallet)
207   * @dev Base contract supporting async send for pull payments. Inherit from this
208   * contract and use asyncTransfer instead of send or transfer.
209   */
210 contract PullPayment {
211     Escrow private escrow;
212 
213     constructor() public {
214         escrow = new Escrow();
215     }
216 
217     /**
218       * @dev Returns the credit owed to an address.
219       * @param _dest The creditor's address.
220       * @return Deposited amount by the address given as argument.
221       */
222     function payments(address _dest) public view returns(uint256) {
223         return escrow.depositsOf(_dest);
224     }
225 
226     /**
227       * @dev Withdraw accumulated balance, called by payee.
228       * @param _payee The address whose funds will be withdrawn and transferred to.
229       * @return Amount withdrawn
230       */
231     function _withdrawPayments(address _payee) internal returns(uint256) {
232         uint256 payment = escrow.withdraw(_payee);
233 
234         return payment;
235     }
236 
237     /**
238       * @dev Called by the payer to store the sent amount as credit to be pulled.
239       * @param _dest The destination address of the funds.
240       * @param _amount The amount to transfer.
241       */
242     function _asyncTransfer(address _dest, uint256 _amount) internal {
243         escrow.deposit.value(_amount)(_dest);
244     }
245 
246     /**
247       * @dev Withdraws the wallet's funds.
248       * @param _wallet address the funds will be transferred to.
249       */
250     function _withdrawFunds(address _wallet) internal {
251         escrow.beneficiaryWithdraw(_wallet);
252     }
253 }
254 
255 /** @title VestedCrowdsale
256   * @dev Extension of Crowdsale to allow a vested distribution of tokens
257   * Users have to individually claim their tokens
258   */
259 contract VestedCrowdsale {
260     using SafeMath for uint256;
261 
262     mapping (address => uint256) public withdrawn;
263     mapping (address => uint256) public contributions;
264     mapping (address => uint256) public contributionsRound;
265     uint256 public vestedTokens;
266 
267     /**
268       * @dev Gives how much a user is allowed to withdraw at the current moment
269       * @param _beneficiary The address of the user asking how much he's allowed
270       * to withdraw
271       * @return Amount _beneficiary is allowed to withdraw
272       */
273     function getWithdrawableAmount(address _beneficiary) public view returns(uint256) {
274         uint256 step = _getVestingStep(_beneficiary);
275         uint256 valueByStep = _getValueByStep(_beneficiary);
276         uint256 result = step.mul(valueByStep).sub(withdrawn[_beneficiary]);
277 
278         return result;
279     }
280 
281     /**
282       * @dev Gives the step of the vesting (starts from 0 to steps)
283       * @param _beneficiary The address of the user asking how much he's allowed
284       * to withdraw
285       * @return The vesting step for _beneficiary
286       */
287     function _getVestingStep(address _beneficiary) internal view returns(uint8) {
288         require(contributions[_beneficiary] != 0);
289         require(contributionsRound[_beneficiary] > 0 && contributionsRound[_beneficiary] < 4);
290 
291         uint256 march31 = 1554019200;
292         uint256 april30 = 1556611200;
293         uint256 may31 = 1559289600;
294         uint256 june30 = 1561881600;
295         uint256 july31 = 1564560000;
296         uint256 sept30 = 1569830400;
297         uint256 contributionRound = contributionsRound[_beneficiary];
298 
299         // vesting for private sale contributors
300         if (contributionRound == 1) {
301             if (block.timestamp < march31) {
302                 return 0;
303             }
304             if (block.timestamp < june30) {
305                 return 1;
306             }
307             if (block.timestamp < sept30) {
308                 return 2;
309             }
310 
311             return 3;
312         }
313         // vesting for pre ico contributors
314         if (contributionRound == 2) {
315             if (block.timestamp < april30) {
316                 return 0;
317             }
318             if (block.timestamp < july31) {
319                 return 1;
320             }
321 
322             return 2;
323         }
324         // vesting for ico contributors
325         if (contributionRound == 3) {
326             if (block.timestamp < may31) {
327                 return 0;
328             }
329 
330             return 1;
331         }
332     }
333 
334     /**
335       * @dev Gives the amount a user is allowed to withdraw by step
336       * @param _beneficiary The address of the user asking how much he's allowed
337       * to withdraw
338       * @return How much a user is allowed to withdraw by step
339       */
340     function _getValueByStep(address _beneficiary) internal view returns(uint256) {
341         require(contributions[_beneficiary] != 0);
342         require(contributionsRound[_beneficiary] > 0 && contributionsRound[_beneficiary] < 4);
343 
344         uint256 contributionRound = contributionsRound[_beneficiary];
345         uint256 amount;
346         uint256 rate;
347 
348         if (contributionRound == 1) {
349             rate = 416700;
350             amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
351             return amount;
352         } else if (contributionRound == 2) {
353             rate = 312500;
354             amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
355             return amount;
356         }
357 
358         rate = 250000;
359         amount = contributions[_beneficiary].mul(rate).mul(25).div(100);
360         return amount;
361     }
362 }
363 
364 /**
365   * @title Whitelist
366   * @dev The Whitelist contract has a whitelist of addresses, and provides basic authorization control functions.
367   * This simplifies the implementation of "user permissions".
368   */
369 contract Whitelist is Ownable {
370     // Whitelisted address
371     mapping(address => bool) public whitelist;
372 
373     event AddedBeneficiary(address indexed _beneficiary);
374     event RemovedBeneficiary(address indexed _beneficiary);
375 
376     /**
377       * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
378       * @param _beneficiaries Addresses to be added to the whitelist
379       */
380     function addAddressToWhitelist(address[] _beneficiaries) public onlyOwner {
381         for (uint256 i = 0; i < _beneficiaries.length; i++) {
382             whitelist[_beneficiaries[i]] = true;
383 
384             emit AddedBeneficiary(_beneficiaries[i]);
385         }
386     }
387 
388     /**
389       * @dev Adds list of address to whitelist. Not overloaded due to limitations with truffle testing.
390       * @param _beneficiary Address to be added to the whitelist
391       */
392     function addToWhitelist(address _beneficiary) public onlyOwner {
393         whitelist[_beneficiary] = true;
394 
395         emit AddedBeneficiary(_beneficiary);
396     }
397 
398     /**
399       * @dev Removes single address from whitelist.
400       * @param _beneficiary Address to be removed to the whitelist
401       */
402     function removeFromWhitelist(address _beneficiary) public onlyOwner {
403         whitelist[_beneficiary] = false;
404 
405         emit RemovedBeneficiary(_beneficiary);
406     }
407 }
408 
409 /**
410  * @title Roles
411  * @dev Library for managing addresses assigned to a Role.
412  */
413 library Roles {
414     struct Role {
415         mapping (address => bool) bearer;
416     }
417 
418     /**
419      * @dev give an account access to this role
420      */
421     function add(Role storage role, address account) internal {
422         require(account != address(0));
423         require(!has(role, account));
424 
425         role.bearer[account] = true;
426     }
427 
428     /**
429      * @dev remove an account's access to this role
430      */
431     function remove(Role storage role, address account) internal {
432         require(account != address(0));
433         require(has(role, account));
434 
435         role.bearer[account] = false;
436     }
437 
438     /**
439      * @dev check if an account has this role
440      * @return bool
441      */
442     function has(Role storage role, address account) internal view returns (bool) {
443         require(account != address(0));
444         return role.bearer[account];
445     }
446 }
447 
448 contract PauserRole {
449     using Roles for Roles.Role;
450 
451     event PauserAdded(address indexed account);
452     event PauserRemoved(address indexed account);
453 
454     Roles.Role private _pausers;
455 
456     constructor () internal {
457         _addPauser(msg.sender);
458     }
459 
460     modifier onlyPauser() {
461         require(isPauser(msg.sender));
462         _;
463     }
464 
465     function isPauser(address account) public view returns (bool) {
466         return _pausers.has(account);
467     }
468 
469     function addPauser(address account) public onlyPauser {
470         _addPauser(account);
471     }
472 
473     function renouncePauser() public {
474         _removePauser(msg.sender);
475     }
476 
477     function _addPauser(address account) internal {
478         _pausers.add(account);
479         emit PauserAdded(account);
480     }
481 
482     function _removePauser(address account) internal {
483         _pausers.remove(account);
484         emit PauserRemoved(account);
485     }
486 }
487 
488 /**
489  * @title Pausable
490  * @dev Base contract which allows children to implement an emergency stop mechanism.
491  */
492 contract Pausable is PauserRole {
493     event Paused(address account);
494     event Unpaused(address account);
495 
496     bool private _paused;
497 
498     constructor () internal {
499         _paused = false;
500     }
501 
502     /**
503      * @return true if the contract is paused, false otherwise.
504      */
505     function paused() public view returns (bool) {
506         return _paused;
507     }
508 
509     /**
510      * @dev Modifier to make a function callable only when the contract is not paused.
511      */
512     modifier whenNotPaused() {
513         require(!_paused);
514         _;
515     }
516 
517     /**
518      * @dev Modifier to make a function callable only when the contract is paused.
519      */
520     modifier whenPaused() {
521         require(_paused);
522         _;
523     }
524 
525     /**
526      * @dev called by the owner to pause, triggers stopped state
527      */
528     function pause() public onlyPauser whenNotPaused {
529         _paused = true;
530         emit Paused(msg.sender);
531     }
532 
533     /**
534      * @dev called by the owner to unpause, returns to normal state
535      */
536     function unpause() public onlyPauser whenPaused {
537         _paused = false;
538         emit Unpaused(msg.sender);
539     }
540 }
541 
542 /**
543  * @title ERC20 interface
544  * @dev see https://github.com/ethereum/EIPs/issues/20
545  */
546 interface IERC20 {
547     function totalSupply() external view returns (uint256);
548 
549     function balanceOf(address who) external view returns (uint256);
550 
551     function allowance(address owner, address spender) external view returns (uint256);
552 
553     function transfer(address to, uint256 value) external returns (bool);
554 
555     function approve(address spender, uint256 value) external returns (bool);
556 
557     function transferFrom(address from, address to, uint256 value) external returns (bool);
558 
559     event Transfer(address indexed from, address indexed to, uint256 value);
560 
561     event Approval(address indexed owner, address indexed spender, uint256 value);
562 }
563 
564 /**
565  * @title Standard ERC20 token
566  *
567  * @dev Implementation of the basic standard token.
568  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
569  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
570  *
571  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
572  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
573  * compliant implementations may not do it.
574  */
575 contract ERC20 is IERC20 {
576     using SafeMath for uint256;
577 
578     mapping (address => uint256) private _balances;
579 
580     mapping (address => mapping (address => uint256)) private _allowed;
581 
582     uint256 private _totalSupply;
583 
584     /**
585     * @dev Total number of tokens in existence
586     */
587     function totalSupply() public view returns (uint256) {
588         return _totalSupply;
589     }
590 
591     /**
592     * @dev Gets the balance of the specified address.
593     * @param owner The address to query the balance of.
594     * @return An uint256 representing the amount owned by the passed address.
595     */
596     function balanceOf(address owner) public view returns (uint256) {
597         return _balances[owner];
598     }
599 
600     /**
601      * @dev Function to check the amount of tokens that an owner allowed to a spender.
602      * @param owner address The address which owns the funds.
603      * @param spender address The address which will spend the funds.
604      * @return A uint256 specifying the amount of tokens still available for the spender.
605      */
606     function allowance(address owner, address spender) public view returns (uint256) {
607         return _allowed[owner][spender];
608     }
609 
610     /**
611     * @dev Transfer token for a specified address
612     * @param to The address to transfer to.
613     * @param value The amount to be transferred.
614     */
615     function transfer(address to, uint256 value) public returns (bool) {
616         _transfer(msg.sender, to, value);
617         return true;
618     }
619 
620     /**
621      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
622      * Beware that changing an allowance with this method brings the risk that someone may use both the old
623      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
624      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
625      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
626      * @param spender The address which will spend the funds.
627      * @param value The amount of tokens to be spent.
628      */
629     function approve(address spender, uint256 value) public returns (bool) {
630         require(spender != address(0));
631 
632         _allowed[msg.sender][spender] = value;
633         emit Approval(msg.sender, spender, value);
634         return true;
635     }
636 
637     /**
638      * @dev Transfer tokens from one address to another.
639      * Note that while this function emits an Approval event, this is not required as per the specification,
640      * and other compliant implementations may not emit the event.
641      * @param from address The address which you want to send tokens from
642      * @param to address The address which you want to transfer to
643      * @param value uint256 the amount of tokens to be transferred
644      */
645     function transferFrom(address from, address to, uint256 value) public returns (bool) {
646         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
647         _transfer(from, to, value);
648         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
649         return true;
650     }
651 
652     /**
653      * @dev Increase the amount of tokens that an owner allowed to a spender.
654      * approve should be called when allowed_[_spender] == 0. To increment
655      * allowed value is better to use this function to avoid 2 calls (and wait until
656      * the first transaction is mined)
657      * From MonolithDAO Token.sol
658      * Emits an Approval event.
659      * @param spender The address which will spend the funds.
660      * @param addedValue The amount of tokens to increase the allowance by.
661      */
662     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
663         require(spender != address(0));
664 
665         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
666         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
667         return true;
668     }
669 
670     /**
671      * @dev Decrease the amount of tokens that an owner allowed to a spender.
672      * approve should be called when allowed_[_spender] == 0. To decrement
673      * allowed value is better to use this function to avoid 2 calls (and wait until
674      * the first transaction is mined)
675      * From MonolithDAO Token.sol
676      * Emits an Approval event.
677      * @param spender The address which will spend the funds.
678      * @param subtractedValue The amount of tokens to decrease the allowance by.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
681         require(spender != address(0));
682 
683         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
684         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
685         return true;
686     }
687 
688     /**
689     * @dev Transfer token for a specified addresses
690     * @param from The address to transfer from.
691     * @param to The address to transfer to.
692     * @param value The amount to be transferred.
693     */
694     function _transfer(address from, address to, uint256 value) internal {
695         require(to != address(0));
696 
697         _balances[from] = _balances[from].sub(value);
698         _balances[to] = _balances[to].add(value);
699         emit Transfer(from, to, value);
700     }
701 
702     /**
703      * @dev Internal function that mints an amount of the token and assigns it to
704      * an account. This encapsulates the modification of balances such that the
705      * proper events are emitted.
706      * @param account The account that will receive the created tokens.
707      * @param value The amount that will be created.
708      */
709     function _mint(address account, uint256 value) internal {
710         require(account != address(0));
711 
712         _totalSupply = _totalSupply.add(value);
713         _balances[account] = _balances[account].add(value);
714         emit Transfer(address(0), account, value);
715     }
716 
717     /**
718      * @dev Internal function that burns an amount of the token of a given
719      * account.
720      * @param account The account whose tokens will be burnt.
721      * @param value The amount that will be burnt.
722      */
723     function _burn(address account, uint256 value) internal {
724         require(account != address(0));
725 
726         _totalSupply = _totalSupply.sub(value);
727         _balances[account] = _balances[account].sub(value);
728         emit Transfer(account, address(0), value);
729     }
730 
731     /**
732      * @dev Internal function that burns an amount of the token of a given
733      * account, deducting from the sender's allowance for said account. Uses the
734      * internal burn function.
735      * Emits an Approval event (reflecting the reduced allowance).
736      * @param account The account whose tokens will be burnt.
737      * @param value The amount that will be burnt.
738      */
739     function _burnFrom(address account, uint256 value) internal {
740         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
741         _burn(account, value);
742         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
743     }
744 }
745 
746 /**
747  * @title Burnable Token
748  * @dev Token that can be irreversibly burned (destroyed).
749  */
750 contract ERC20Burnable is ERC20 {
751     /**
752      * @dev Burns a specific amount of tokens.
753      * @param value The amount of token to be burned.
754      */
755     function burn(uint256 value) public {
756         _burn(msg.sender, value);
757     }
758 
759     /**
760      * @dev Burns a specific amount of tokens from the target address and decrements allowance
761      * @param from address The address which you want to send tokens from
762      * @param value uint256 The amount of token to be burned
763      */
764     function burnFrom(address from, uint256 value) public {
765         _burnFrom(from, value);
766     }
767 }
768 
769 /**
770   * @title DSLACrowdsale
771   * @dev Crowdsale is a base contract for managing a token crowdsale,
772   * allowing investors to purchase tokens with ether
773   */
774 contract DSLACrowdsale is VestedCrowdsale, Whitelist, Pausable, PullPayment {
775     // struct to store ico rounds details
776     struct IcoRound {
777         uint256 rate;
778         uint256 individualFloor;
779         uint256 individualCap;
780         uint256 softCap;
781         uint256 hardCap;
782     }
783 
784     // mapping ico rounds
785     mapping (uint256 => IcoRound) public icoRounds;
786     // The token being sold
787     ERC20Burnable private _token;
788     // Address where funds are collected
789     address private _wallet;
790     // Amount of wei raised
791     uint256 private totalContributionAmount;
792     // Tokens to sell = 5 Billions * 10^18 = 5 * 10^27 = 5000000000000000000000000000
793     uint256 public constant TOKENSFORSALE = 5000000000000000000000000000;
794     // Current ico round
795     uint256 public currentIcoRound;
796     // Distributed Tokens
797     uint256 public distributedTokens;
798     // Amount of wei raised from other currencies
799     uint256 public weiRaisedFromOtherCurrencies;
800     // Refund period on
801     bool public isRefunding = false;
802     // Finalized crowdsale off
803     bool public isFinalized = false;
804     // Refunding deadline
805     uint256 public refundDeadline;
806 
807     /**
808       * Event for token purchase logging
809       * @param purchaser who paid for the tokens
810       * @param beneficiary who got the tokens
811       * @param value weis paid for purchase
812       * @param amount amount of tokens purchased
813       */
814     event TokensPurchased(
815         address indexed purchaser,
816         address indexed beneficiary,
817         uint256 value,
818         uint256 amount
819     );
820 
821     /**
822       * @param wallet Address where collected funds will be forwarded to
823       * @param token Address of the token being sold
824       */
825     constructor(address wallet, ERC20Burnable token) public {
826         require(wallet != address(0) && token != address(0));
827 
828         icoRounds[1] = IcoRound(
829             416700,
830             3 ether,
831             600 ether,
832             0,
833             1200 ether
834         );
835 
836         icoRounds[2] = IcoRound(
837             312500,
838             12 ether,
839             5000 ether,
840             0,
841             6000 ether
842         );
843 
844         icoRounds[3] = IcoRound(
845             250000,
846             3 ether,
847             30 ether,
848             7200 ether,
849             17200 ether
850         );
851 
852         _wallet = wallet;
853         _token = token;
854     }
855 
856     /**
857       * @dev fallback function ***DO NOT OVERRIDE***
858       */
859     function () external payable {
860         buyTokens(msg.sender);
861     }
862 
863     /**
864       * @dev low level token purchase ***DO NOT OVERRIDE***
865       * @param _contributor Address performing the token purchase
866       */
867     function buyTokens(address _contributor) public payable {
868         require(whitelist[_contributor]);
869 
870         uint256 contributionAmount = msg.value;
871 
872         _preValidatePurchase(_contributor, contributionAmount, currentIcoRound);
873 
874         totalContributionAmount = totalContributionAmount.add(contributionAmount);
875 
876         uint tokenAmount = _handlePurchase(contributionAmount, currentIcoRound, _contributor);
877 
878         emit TokensPurchased(msg.sender, _contributor, contributionAmount, tokenAmount);
879 
880         _forwardFunds();
881     }
882 
883     /**
884       * @dev Function to go to the next round
885       * @return True bool when round is incremented
886       */
887     function goToNextRound() public onlyOwner returns(bool) {
888         require(currentIcoRound >= 0 && currentIcoRound < 3);
889 
890         currentIcoRound = currentIcoRound + 1;
891 
892         return true;
893     }
894 
895     /**
896       * @dev Manually adds a contributor's contribution for private presale period
897       * @param _contributor The address of the contributor
898       * @param _contributionAmount Amount of wei contributed
899       */
900     function addPrivateSaleContributors(address _contributor, uint256 _contributionAmount)
901     public onlyOwner
902     {
903         uint privateSaleRound = 1;
904         _preValidatePurchase(_contributor, _contributionAmount, privateSaleRound);
905 
906         totalContributionAmount = totalContributionAmount.add(_contributionAmount);
907 
908         addToWhitelist(_contributor);
909 
910         _handlePurchase(_contributionAmount, privateSaleRound, _contributor);
911     }
912 
913     /**
914       * @dev Manually adds a contributor's contribution with other currencies
915       * @param _contributor The address of the contributor
916       * @param _contributionAmount Amount of wei contributed
917       * @param _round contribution round
918       */
919     function addOtherCurrencyContributors(address _contributor, uint256 _contributionAmount, uint256 _round)
920     public onlyOwner
921     {
922         _preValidatePurchase(_contributor, _contributionAmount, _round);
923 
924         weiRaisedFromOtherCurrencies = weiRaisedFromOtherCurrencies.add(_contributionAmount);
925 
926         addToWhitelist(_contributor);
927 
928         _handlePurchase(_contributionAmount, _round, _contributor);
929     }
930 
931     /**
932       * @dev Function to close refunding period
933       * @return True bool
934       */
935     function closeRefunding() public returns(bool) {
936         require(isRefunding);
937         require(block.timestamp > refundDeadline);
938 
939         isRefunding = false;
940 
941         _withdrawFunds(wallet());
942 
943         return true;
944     }
945 
946     /**
947       * @dev Function to close the crowdsale
948       * @return True bool
949       */
950     function closeCrowdsale() public onlyOwner returns(bool) {
951         require(currentIcoRound > 0 && currentIcoRound < 4);
952 
953         currentIcoRound = 4;
954 
955         return true;
956     }
957 
958     /**
959       * @dev Function to finalize the crowdsale
960       * @param _burn bool burn unsold tokens when true
961       * @return True bool
962       */
963     function finalizeCrowdsale(bool _burn) public onlyOwner returns(bool) {
964         require(currentIcoRound == 4 && !isRefunding);
965 
966         if (raisedFunds() < icoRounds[3].softCap) {
967             isRefunding = true;
968             refundDeadline = block.timestamp + 4 weeks;
969 
970             return true;
971         }
972 
973         require(!isFinalized);
974 
975         _withdrawFunds(wallet());
976         isFinalized = true;
977 
978         if (_burn) {
979             _burnUnsoldTokens();
980         } else {
981             _withdrawUnsoldTokens();
982         }
983 
984         return  true;
985     }
986 
987     /**
988       * @dev Investors can claim refunds here if crowdsale is unsuccessful
989       */
990     function claimRefund() public {
991         require(isRefunding);
992         require(block.timestamp <= refundDeadline);
993         require(payments(msg.sender) > 0);
994 
995         uint256 payment = _withdrawPayments(msg.sender);
996 
997         totalContributionAmount = totalContributionAmount.sub(payment);
998     }
999 
1000     /**
1001       * @dev Allows the sender to claim the tokens he is allowed to withdraw
1002       */
1003     function claimTokens() public {
1004         require(getWithdrawableAmount(msg.sender) != 0);
1005 
1006         uint256 amount = getWithdrawableAmount(msg.sender);
1007         withdrawn[msg.sender] = withdrawn[msg.sender].add(amount);
1008 
1009         _deliverTokens(msg.sender, amount);
1010     }
1011 
1012     /**
1013       * @dev returns the token being sold
1014       * @return the token being sold
1015       */
1016     function token() public view returns(ERC20Burnable) {
1017         return _token;
1018     }
1019 
1020     /**
1021       * @dev returns the wallet address that collects the funds
1022       * @return the address where funds are collected
1023       */
1024     function wallet() public view returns(address) {
1025         return _wallet;
1026     }
1027 
1028     /**
1029       * @dev Returns the total of raised funds
1030       * @return total amount of raised funds
1031       */
1032     function raisedFunds() public view returns(uint256) {
1033         return totalContributionAmount.add(weiRaisedFromOtherCurrencies);
1034     }
1035 
1036     // -----------------------------------------
1037     // Internal interface
1038     // -----------------------------------------
1039     /**
1040       * @dev Source of tokens. Override this method to modify the way in which
1041       * the crowdsale ultimately gets and sends its tokens.
1042       * @param _beneficiary Address performing the token purchase
1043       * @param _tokenAmount Number of tokens to be emitted
1044       */
1045     function _deliverTokens(address _beneficiary, uint256 _tokenAmount)
1046     internal
1047     {
1048         _token.transfer(_beneficiary, _tokenAmount);
1049     }
1050 
1051     /**
1052       * @dev Determines how ETH is stored/forwarded on purchases.
1053       */
1054     function _forwardFunds()
1055     internal
1056     {
1057         if (currentIcoRound == 2 || currentIcoRound == 3) {
1058             _asyncTransfer(msg.sender, msg.value);
1059         } else {
1060             _wallet.transfer(msg.value);
1061         }
1062     }
1063 
1064     /**
1065       * @dev Gets tokens allowed to deliver in the given round
1066       * @param _tokenAmount total amount of tokens involved in the purchase
1067       * @param _round Round in which the purchase is happening
1068       * @return Returns the amount of tokens allowed to deliver
1069       */
1070     function _getTokensToDeliver(uint _tokenAmount, uint _round)
1071     internal pure returns(uint)
1072     {
1073         require(_round > 0 && _round < 4);
1074         uint deliverPercentage = _round.mul(25);
1075 
1076         return _tokenAmount.mul(deliverPercentage).div(100);
1077     }
1078 
1079     /**
1080       * @dev Handles token purchasing
1081       * @param _contributor Address performing the token purchase
1082       * @param _contributionAmount Value in wei involved in the purchase
1083       * @param _round Round in which the purchase is happening
1084       * @return Returns the amount of tokens purchased
1085       */
1086     function _handlePurchase(uint _contributionAmount, uint _round, address _contributor)
1087     internal returns(uint) {
1088         uint256 soldTokens = distributedTokens.add(vestedTokens);
1089         uint256 tokenAmount = _getTokenAmount(_contributionAmount, _round);
1090 
1091         require(tokenAmount.add(soldTokens) <= TOKENSFORSALE);
1092 
1093         contributions[_contributor] = contributions[_contributor].add(_contributionAmount);
1094         contributionsRound[_contributor] = _round;
1095 
1096         uint tokensToDeliver = _getTokensToDeliver(tokenAmount, _round);
1097         uint tokensToVest = tokenAmount.sub(tokensToDeliver);
1098 
1099         distributedTokens = distributedTokens.add(tokensToDeliver);
1100         vestedTokens = vestedTokens.add(tokensToVest);
1101 
1102         _deliverTokens(_contributor, tokensToDeliver);
1103 
1104         return tokenAmount;
1105     }
1106 
1107     /**
1108       * @dev Validation of an incoming purchase.
1109       * @param _contributor Address performing the token purchase
1110       * @param _contributionAmount Value in wei involved in the purchase
1111       * @param _round Round in which the purchase is happening
1112       */
1113     function _preValidatePurchase(address _contributor, uint256 _contributionAmount, uint _round)
1114     internal view
1115     {
1116         require(_contributor != address(0));
1117         require(currentIcoRound > 0 && currentIcoRound < 4);
1118         require(_round > 0 && _round < 4);
1119         require(contributions[_contributor] == 0);
1120         require(_contributionAmount >= icoRounds[_round].individualFloor);
1121         require(_contributionAmount < icoRounds[_round].individualCap);
1122         require(_doesNotExceedHardCap(_contributionAmount, _round));
1123     }
1124 
1125     /**
1126       * @dev define the way in which ether is converted to tokens.
1127       * @param _contributionAmount Value in wei to be converted into tokens
1128       * @return Number of tokens that can be purchased with the specified _contributionAmount
1129       */
1130     function _getTokenAmount(uint256 _contributionAmount, uint256 _round)
1131     internal view returns(uint256)
1132     {
1133         uint256 _rate = icoRounds[_round].rate;
1134         return _contributionAmount.mul(_rate);
1135     }
1136 
1137     /**
1138       * @dev Checks if current round hardcap will not be exceeded by a new contribution
1139       * @param _contributionAmount purchase amount in Wei
1140       * @param _round Round in which the purchase is happening
1141       * @return true when current hardcap is not exceeded, false if exceeded
1142       */
1143     function _doesNotExceedHardCap(uint _contributionAmount, uint _round)
1144     internal view returns(bool)
1145     {
1146         uint roundHardCap = icoRounds[_round].hardCap;
1147         return totalContributionAmount.add(_contributionAmount) <= roundHardCap;
1148     }
1149 
1150     /**
1151       * @dev Function to burn unsold tokens
1152       */
1153     function _burnUnsoldTokens()
1154     internal
1155     {
1156         uint256 tokensToBurn = TOKENSFORSALE.sub(vestedTokens).sub(distributedTokens);
1157 
1158         _token.burn(tokensToBurn);
1159     }
1160 
1161     /**
1162       * @dev Transfer the unsold tokens to the funds collecting address
1163       */
1164     function _withdrawUnsoldTokens()
1165     internal {
1166         uint256 tokensToWithdraw = TOKENSFORSALE.sub(vestedTokens).sub(distributedTokens);
1167 
1168         _token.transfer(_wallet, tokensToWithdraw);
1169     }
1170 }