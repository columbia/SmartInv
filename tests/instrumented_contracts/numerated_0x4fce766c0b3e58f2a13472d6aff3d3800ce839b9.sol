1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-24
3 */
4 
5 pragma solidity ^0.5.17;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13     address private _owner;
14 
15     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17     /**
18      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19      * account.
20      */
21     constructor () internal {
22         _owner = msg.sender;
23         emit OwnershipTransferred(address(0), _owner);
24     }
25 
26     /**
27      * @return the address of the owner.
28      */
29     function owner() public view returns (address) {
30         return _owner;
31     }
32 
33     /**
34      * @dev Throws if called by any account other than the owner.
35      */
36     modifier onlyOwner() {
37         require(isOwner());
38         _;
39     }
40 
41     /**
42      * @return true if `msg.sender` is the owner of the contract.
43      */
44     function isOwner() public view returns (bool) {
45         return msg.sender == _owner;
46     }
47 
48     /**
49      * @dev Allows the current owner to relinquish control of the contract.
50      * It will not be possible to call the functions with the `onlyOwner`
51      * modifier anymore.
52      * @notice Renouncing ownership will leave the contract without an owner,
53      * thereby removing any functionality that is only available to the owner.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 /**
80  * @title Secondary
81  * @dev A Secondary contract can only be used by its primary account (the one that created it)
82  */
83 contract Secondary {
84     address private _primary;
85 
86     event PrimaryTransferred(
87         address recipient
88     );
89 
90     /**
91      * @dev Sets the primary account to the one that is creating the Secondary contract.
92      */
93     constructor () internal {
94         _primary = msg.sender;
95         emit PrimaryTransferred(_primary);
96     }
97 
98     /**
99      * @dev Reverts if called from any account other than the primary.
100      */
101     modifier onlyPrimary() {
102         require(msg.sender == _primary);
103         _;
104     }
105 
106     /**
107      * @return the address of the primary.
108      */
109     function primary() public view returns (address) {
110         return _primary;
111     }
112 
113     /**
114      * @dev Transfers contract to a new primary.
115      * @param recipient The address of new primary.
116      */
117     function transferPrimary(address recipient) public onlyPrimary {
118         require(recipient != address(0));
119         _primary = recipient;
120         emit PrimaryTransferred(_primary);
121     }
122 }
123 
124 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
125 /**
126  * @title ERC20 interface
127  * @dev see https://github.com/ethereum/EIPs/issues/20
128  */
129 
130 interface IERC20 {
131     function transfer(address to, uint256 value) external returns (bool);
132 
133     function approve(address spender, uint256 value) external returns (bool);
134 
135     function transferFrom(address from, address to, uint256 value) external returns (bool);
136 
137     function totalSupply() external view returns (uint256);
138 
139     function balanceOf(address who) external view returns (uint256);
140 
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
149 
150 
151 /**
152  * @title SafeMath
153  * @dev Unsigned math operations with safety checks that revert on error
154  */
155 library SafeMath {
156     /**
157      * @dev Multiplies two unsigned integers, reverts on overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b);
169 
170         return c;
171     }
172 
173     /**
174      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181 
182         return c;
183     }
184 
185     /**
186      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
187      */
188     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b <= a);
190         uint256 c = a - b;
191 
192         return c;
193     }
194 
195     /**
196      * @dev Adds two unsigned integers, reverts on overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a);
201 
202         return c;
203     }
204 
205     /**
206      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
207      * reverts when dividing by zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         require(b != 0);
211         return a % b;
212     }
213 }
214 
215 
216 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
217 /**
218  * @title Standard ERC20 token
219  *
220  * @dev Implementation of the basic standard token.
221  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
222  * Originally based on code by FirstBlood:
223  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
224  *
225  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
226  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
227  * compliant implementations may not do it.
228  */
229 /**
230  * @title Standard ERC20 token
231  *
232  * @dev Implementation of the basic standard token.
233  * https://eips.ethereum.org/EIPS/eip-20
234  * Originally based on code by FirstBlood:
235  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
236  *
237  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
238  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
239  * compliant implementations may not do it.
240  */
241 contract ERC20 is IERC20 {
242     using SafeMath for uint256;
243 
244     mapping (address => uint256) private _balances;
245 
246     mapping (address => mapping (address => uint256)) private _allowed;
247 
248     uint256 private _totalSupply;
249 
250     /**
251      * @dev Total number of tokens in existence
252      */
253     function totalSupply() public view returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev Gets the balance of the specified address.
259      * @param owner The address to query the balance of.
260      * @return A uint256 representing the amount owned by the passed address.
261      */
262     function balanceOf(address owner) public view returns (uint256) {
263         return _balances[owner];
264     }
265 
266     /**
267      * @dev Function to check the amount of tokens that an owner allowed to a spender.
268      * @param owner address The address which owns the funds.
269      * @param spender address The address which will spend the funds.
270      * @return A uint256 specifying the amount of tokens still available for the spender.
271      */
272     function allowance(address owner, address spender) public view returns (uint256) {
273         return _allowed[owner][spender];
274     }
275 
276     /**
277      * @dev Transfer token to a specified address
278      * @param to The address to transfer to.
279      * @param value The amount to be transferred.
280      */
281     function transfer(address to, uint256 value) public returns (bool) {
282         _transfer(msg.sender, to, value);
283         return true;
284     }
285 
286     /**
287      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
288      * Beware that changing an allowance with this method brings the risk that someone may use both the old
289      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
290      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
291      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
292      * @param spender The address which will spend the funds.
293      * @param value The amount of tokens to be spent.
294      */
295     function approve(address spender, uint256 value) public returns (bool) {
296         _approve(msg.sender, spender, value);
297         return true;
298     }
299 
300     /**
301      * @dev Transfer tokens from one address to another.
302      * Note that while this function emits an Approval event, this is not required as per the specification,
303      * and other compliant implementations may not emit the event.
304      * @param from address The address which you want to send tokens from
305      * @param to address The address which you want to transfer to
306      * @param value uint256 the amount of tokens to be transferred
307      */
308     function transferFrom(address from, address to, uint256 value) public returns (bool) {
309         _transfer(from, to, value);
310         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
311         return true;
312     }
313 
314     /**
315      * @dev Increase the amount of tokens that an owner allowed to a spender.
316      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
317      * allowed value is better to use this function to avoid 2 calls (and wait until
318      * the first transaction is mined)
319      * From MonolithDAO Token.sol
320      * Emits an Approval event.
321      * @param spender The address which will spend the funds.
322      * @param addedValue The amount of tokens to increase the allowance by.
323      */
324     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
325         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
326         return true;
327     }
328 
329     /**
330      * @dev Decrease the amount of tokens that an owner allowed to a spender.
331      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
332      * allowed value is better to use this function to avoid 2 calls (and wait until
333      * the first transaction is mined)
334      * From MonolithDAO Token.sol
335      * Emits an Approval event.
336      * @param spender The address which will spend the funds.
337      * @param subtractedValue The amount of tokens to decrease the allowance by.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
340         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
341         return true;
342     }
343 
344     /**
345      * @dev Transfer token for a specified addresses
346      * @param from The address to transfer from.
347      * @param to The address to transfer to.
348      * @param value The amount to be transferred.
349      */
350     function _transfer(address from, address to, uint256 value) internal {
351         require(to != address(0));
352 
353         _balances[from] = _balances[from].sub(value);
354         _balances[to] = _balances[to].add(value);
355         emit Transfer(from, to, value);
356     }
357 
358     /**
359      * @dev Internal function that mints an amount of the token and assigns it to
360      * an account. This encapsulates the modification of balances such that the
361      * proper events are emitted.
362      * @param account The account that will receive the created tokens.
363      * @param value The amount that will be created.
364      */
365     function _mint(address account, uint256 value) internal {
366         require(account != address(0));
367 
368         _totalSupply = _totalSupply.add(value);
369         _balances[account] = _balances[account].add(value);
370         emit Transfer(address(0), account, value);
371     }
372 
373     /**
374      * @dev Internal function that burns an amount of the token of a given
375      * account.
376      * @param account The account whose tokens will be burnt.
377      * @param value The amount that will be burnt.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0));
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Approve an address to spend another addresses' tokens.
389      * @param owner The address that owns the tokens.
390      * @param spender The address that will spend the tokens.
391      * @param value The number of tokens that can be spent.
392      */
393     function _approve(address owner, address spender, uint256 value) internal {
394         require(spender != address(0));
395         require(owner != address(0));
396 
397         _allowed[owner][spender] = value;
398         emit Approval(owner, spender, value);
399     }
400 
401     /**
402      * @dev Internal function that burns an amount of the token of a given
403      * account, deducting from the sender's allowance for said account. Uses the
404      * internal burn function.
405      * Emits an Approval event (reflecting the reduced allowance).
406      * @param account The account whose tokens will be burnt.
407      * @param value The amount that will be burnt.
408      */
409     function _burnFrom(address account, uint256 value) internal {
410         _burn(account, value);
411         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
412     }
413 }
414 
415 
416 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
417 /**
418  * @title Burnable Token
419  * @dev Token that can be irreversibly burned (destroyed).
420  */
421 contract ERC20Burnable is ERC20 {
422     /**
423      * @dev Burns a specific amount of tokens.
424      * @param value The amount of token to be burned.
425      */
426     function burn(uint256 value) public {
427         _burn(msg.sender, value);
428     }
429 
430     /**
431      * @dev Burns a specific amount of tokens from the target address and decrements allowance
432      * @param from address The account whose tokens will be burned.
433      * @param value uint256 The amount of token to be burned.
434      */
435     function burnFrom(address from, uint256 value) public {
436         _burnFrom(from, value);
437     }
438 }
439 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
440 /**
441  * @title Roles
442  * @dev Library for managing addresses assigned to a Role.
443  */
444 library Roles {
445     struct Role {
446         mapping (address => bool) bearer;
447     }
448 
449     /**
450      * @dev give an account access to this role
451      */
452     function add(Role storage role, address account) internal {
453         require(account != address(0));
454         require(!has(role, account));
455 
456         role.bearer[account] = true;
457     }
458 
459     /**
460      * @dev remove an account's access to this role
461      */
462     function remove(Role storage role, address account) internal {
463         require(account != address(0));
464         require(has(role, account));
465 
466         role.bearer[account] = false;
467     }
468 
469     /**
470      * @dev check if an account has this role
471      * @return bool
472      */
473     function has(Role storage role, address account) internal view returns (bool) {
474         require(account != address(0));
475         return role.bearer[account];
476     }
477 }
478 
479 // File: node_modules\openzeppelin-solidity\contracts\access\roles\MinterRole.sol
480 contract MinterRole {
481     using Roles for Roles.Role;
482 
483     event MinterAdded(address indexed account);
484     event MinterRemoved(address indexed account);
485 
486     Roles.Role private _minters;
487 
488     constructor () internal {
489         _addMinter(msg.sender);
490     }
491 
492     modifier onlyMinter() {
493         require(isMinter(msg.sender));
494         _;
495     }
496 
497     function isMinter(address account) public view returns (bool) {
498         return _minters.has(account);
499     }
500 
501     function addMinter(address account) public onlyMinter {
502         _addMinter(account);
503     }
504 
505     function renounceMinter() public {
506         _removeMinter(msg.sender);
507     }
508 
509     function _addMinter(address account) internal {
510         _minters.add(account);
511         emit MinterAdded(account);
512     }
513 
514     function _removeMinter(address account) internal {
515         _minters.remove(account);
516         emit MinterRemoved(account);
517     }
518 }
519 
520 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Mintable.sol
521 
522 /**
523  * @title ERC20Mintable
524  * @dev ERC20 minting logic
525  */
526 contract ERC20Mintable is ERC20, MinterRole {
527     /**
528      * @dev Function to mint tokens
529      * @param to The address that will receive the minted tokens.
530      * @param value The amount of tokens to mint.
531      * @return A boolean that indicates if the operation was successful.
532      */
533     function mint(address to, uint256 value) public onlyMinter returns (bool) {
534         _mint(to, value);
535         return true;
536     }
537 }
538 
539 // File: contracts\ERC20Frozenable.sol
540 
541 
542 //truffle-flattener Token.sol
543 contract ERC20Frozenable is ERC20Burnable, ERC20Mintable, Ownable {
544     mapping (address => bool) private _frozenAccount;
545     event FrozenFunds(address target, bool frozen);
546 
547 
548     function frozenAccount(address _address) public view returns(bool isFrozen) {
549         return _frozenAccount[_address];
550     }
551 
552     function freezeAccount(address target, bool freeze)  public onlyOwner {
553         require(_frozenAccount[target] != freeze, "Same as current");
554         _frozenAccount[target] = freeze;
555         emit FrozenFunds(target, freeze);
556     }
557 
558     function _transfer(address from, address to, uint256 value) internal {
559         require(!_frozenAccount[from], "error - frozen");
560         require(!_frozenAccount[to], "error - frozen");
561         super._transfer(from, to, value);
562     }
563 
564 }
565 
566 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
567 
568 /**
569  * @title ERC20Detailed token
570  * @dev The decimals are only for visualization purposes.
571  * All the operations are done using the smallest and indivisible token unit,
572  * just as on Ethereum all the operations are done in wei.
573  */
574 contract ERC20Detailed is IERC20 {
575     string private _name;
576     string private _symbol;
577     uint8 private _decimals;
578 
579     constructor (string memory name, string memory symbol, uint8 decimals) public {
580         _name = name;
581         _symbol = symbol;
582         _decimals = decimals;
583     }
584 
585     /**
586      * @return the name of the token.
587      */
588     function name() public view returns (string memory) {
589         return _name;
590     }
591 
592     /**
593      * @return the symbol of the token.
594      */
595     function symbol() public view returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @return the number of decimals of the token.
601      */
602     function decimals() public view returns (uint8) {
603         return _decimals;
604     }
605 }
606 
607  /**
608   * @title Escrow
609   * @dev Base escrow contract, holds funds designated for a payee until they
610   * withdraw them.
611   * @dev Intended usage: This contract (and derived escrow contracts) should be a
612   * standalone contract, that only interacts with the contract that instantiated
613   * it. That way, it is guaranteed that all Ether will be handled according to
614   * the Escrow rules, and there is no need to check for payable functions or
615   * transfers in the inheritance tree. The contract that uses the escrow as its
616   * payment method should be its primary, and provide public methods redirecting
617   * to the escrow's deposit and withdraw.
618   */
619 contract Escrow is Secondary {
620     using SafeMath for uint256;
621 
622     event Deposited(address indexed payee, uint256 weiAmount);
623     event Withdrawn(address indexed payee, uint256 weiAmount);
624 
625     mapping(address => uint256) private _deposits;
626 
627     function depositsOf(address payee) public view returns (uint256) {
628         return _deposits[payee];
629     }
630 
631     /**
632      * @dev Stores the sent amount as credit to be withdrawn.
633      * @param payee The destination address of the funds.
634      */
635     function deposit(address payee) public onlyPrimary payable {
636         uint256 amount = msg.value;
637         _deposits[payee] = _deposits[payee].add(amount);
638 
639         emit Deposited(payee, amount);
640     }
641 
642     /**
643      * @dev Withdraw accumulated balance for a payee.
644      * @param payee The address whose funds will be withdrawn and transferred to.
645      */
646     function withdraw(address payable payee) public onlyPrimary {
647         uint256 payment = _deposits[payee];
648 
649         _deposits[payee] = 0;
650 
651         payee.transfer(payment);
652 
653         emit Withdrawn(payee, payment);
654     }
655 }
656 
657 /**
658  * @title PullPayment
659  * @dev Base contract supporting async send for pull payments. Inherit from this
660  * contract and use _asyncTransfer instead of send or transfer.
661  */
662 contract PullPayment {
663     Escrow private _escrow;
664 
665     constructor () internal {
666         _escrow = new Escrow();
667     }
668 
669     /**
670      * @dev Withdraw accumulated balance.
671      * @param payee Whose balance will be withdrawn.
672      */
673     function withdrawPayments(address payable payee) public {
674         _escrow.withdraw(payee);
675     }
676 
677     /**
678      * @dev Returns the credit owed to an address.
679      * @param dest The creditor's address.
680      */
681     function payments(address dest) public view returns (uint256) {
682         return _escrow.depositsOf(dest);
683     }
684 
685     /**
686      * @dev Called by the payer to store the sent amount as credit to be pulled.
687      * @param dest The destination address of the funds.
688      * @param amount The amount to transfer.
689      */
690     function _asyncTransfer(address dest, uint256 amount) internal {
691         _escrow.deposit.value(amount)(dest);
692     }
693 }
694 
695 contract PaymentSplitter {
696     using SafeMath for uint256;
697 
698     event PayeeAdded(address account, uint256 shares);
699     event PaymentReleased(address to, uint256 amount);
700     event PaymentReceived(address from, uint256 amount);
701 
702     uint256 private _totalShares;
703     uint256 private _totalReleased;
704 
705     mapping(address => uint256) private _shares;
706     mapping(address => uint256) private _released;
707     address[] private _payees;
708 
709     /**
710      * @dev Constructor
711      */
712     constructor (address[] memory payees, uint256[] memory shares) public payable {
713         require(payees.length == shares.length);
714         require(payees.length > 0);
715 
716         for (uint256 i = 0; i < payees.length; i++) {
717             _addPayee(payees[i], shares[i]);
718         }
719     }
720 
721     /**
722      * @dev payable fallback
723      */
724     function () external payable {
725         emit PaymentReceived(msg.sender, msg.value);
726     }
727 
728     /**
729      * @return the total shares of the contract.
730      */
731     function totalShares() public view returns (uint256) {
732         return _totalShares;
733     }
734 
735     /**
736      * @return the total amount already released.
737      */
738     function totalReleased() public view returns (uint256) {
739         return _totalReleased;
740     }
741 
742     /**
743      * @return the shares of an account.
744      */
745     function shares(address account) public view returns (uint256) {
746         return _shares[account];
747     }
748 
749     /**
750      * @return the amount already released to an account.
751      */
752     function released(address account) public view returns (uint256) {
753         return _released[account];
754     }
755 
756     /**
757      * @return the address of a payee.
758      */
759     function payee(uint256 index) public view returns (address) {
760         return _payees[index];
761     }
762 
763     /**
764      * @dev Release one of the payee's proportional payment.
765      * @param account Whose payments will be released.
766      */
767     function release(address payable account) public {
768         require(_shares[account] > 0);
769 
770         uint256 totalReceived = address(this).balance.add(_totalReleased);
771         uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);
772 
773         require(payment != 0);
774 
775         _released[account] = _released[account].add(payment);
776         _totalReleased = _totalReleased.add(payment);
777 
778         account.transfer(payment);
779         emit PaymentReleased(account, payment);
780     }
781 
782     /**
783      * @dev Add a new payee to the contract.
784      * @param account The address of the payee to add.
785      * @param shares_ The number of shares owned by the payee.
786      */
787     function _addPayee(address account, uint256 shares_) private {
788         require(account != address(0));
789         require(shares_ > 0);
790         require(_shares[account] == 0);
791 
792         _payees.push(account);
793         _shares[account] = shares_;
794         _totalShares = _totalShares.add(shares_);
795         emit PayeeAdded(account, shares_);
796     }
797 }
798 
799 contract ConditionalEscrow is Escrow {
800     /**
801      * @dev Returns whether an address is allowed to withdraw their funds. To be
802      * implemented by derived contracts.
803      * @param payee The destination address of the funds.
804      */
805     function withdrawalAllowed(address payee) public view returns (bool);
806 
807     function withdraw(address payable payee) public {
808         require(withdrawalAllowed(payee));
809         super.withdraw(payee);
810     }
811 }
812 
813 
814 contract RefundEscrow is ConditionalEscrow {
815     enum State { Active, Refunding, Closed }
816 
817     event RefundsClosed();
818     event RefundsEnabled();
819 
820     State private _state;
821     address payable private _beneficiary;
822 
823     /**
824      * @dev Constructor.
825      * @param beneficiary The beneficiary of the deposits.
826      */
827     constructor (address payable beneficiary) public {
828         require(beneficiary != address(0));
829         _beneficiary = beneficiary;
830         _state = State.Active;
831     }
832 
833     /**
834      * @return the current state of the escrow.
835      */
836     function state() public view returns (State) {
837         return _state;
838     }
839 
840     /**
841      * @return the beneficiary of the escrow.
842      */
843     function beneficiary() public view returns (address) {
844         return _beneficiary;
845     }
846 
847     /**
848      * @dev Stores funds that may later be refunded.
849      * @param refundee The address funds will be sent to if a refund occurs.
850      */
851     function deposit(address refundee) public payable {
852         require(_state == State.Active);
853         super.deposit(refundee);
854     }
855 
856     /**
857      * @dev Allows for the beneficiary to withdraw their funds, rejecting
858      * further deposits.
859      */
860     function close() public onlyPrimary {
861         require(_state == State.Active);
862         _state = State.Closed;
863         emit RefundsClosed();
864     }
865 
866     /**
867      * @dev Allows for refunds to take place, rejecting further deposits.
868      */
869     function enableRefunds() public onlyPrimary {
870         require(_state == State.Active);
871         _state = State.Refunding;
872         emit RefundsEnabled();
873     }
874 
875     /**
876      * @dev Withdraws the beneficiary's funds.
877      */
878     function beneficiaryWithdraw() public {
879         require(_state == State.Closed);
880         _beneficiary.transfer(address(this).balance);
881     }
882 
883     /**
884      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
885      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
886      */
887     function withdrawalAllowed(address) public view returns (bool) {
888         return _state == State.Refunding;
889     }
890 }
891 // File: contracts\Token.sol
892 //truffle-flattener Token.sol
893 contract Blocks is ERC20Frozenable, ERC20Detailed {
894 
895     constructor()
896     ERC20Detailed("Frutti Dino", "FDT", 18)
897     public {
898         uint256 supply = 1000000000;
899         uint256 initialSupply = supply * uint(10) ** decimals();
900         _mint(msg.sender, initialSupply);
901     }
902 }