1 pragma solidity ^0.5.2;
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
46      * It will not be possible to call the functions with the `onlyOwner`
47      * modifier anymore.
48      * @notice Renouncing ownership will leave the contract without an owner,
49      * thereby removing any functionality that is only available to the owner.
50      */
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55 
56     /**
57      * @dev Allows the current owner to transfer control of the contract to a newOwner.
58      * @param newOwner The address to transfer ownership to.
59      */
60     function transferOwnership(address newOwner) public onlyOwner {
61         _transferOwnership(newOwner);
62     }
63 
64     /**
65      * @dev Transfers control of the contract to a newOwner.
66      * @param newOwner The address to transfer ownership to.
67      */
68     function _transferOwnership(address newOwner) internal {
69         require(newOwner != address(0));
70         emit OwnershipTransferred(_owner, newOwner);
71         _owner = newOwner;
72     }
73 }
74 
75 /**
76  * @title Secondary
77  * @dev A Secondary contract can only be used by its primary account (the one that created it)
78  */
79 contract Secondary {
80     address private _primary;
81 
82     event PrimaryTransferred(
83         address recipient
84     );
85 
86     /**
87      * @dev Sets the primary account to the one that is creating the Secondary contract.
88      */
89     constructor () internal {
90         _primary = msg.sender;
91         emit PrimaryTransferred(_primary);
92     }
93 
94     /**
95      * @dev Reverts if called from any account other than the primary.
96      */
97     modifier onlyPrimary() {
98         require(msg.sender == _primary);
99         _;
100     }
101 
102     /**
103      * @return the address of the primary.
104      */
105     function primary() public view returns (address) {
106         return _primary;
107     }
108 
109     /**
110      * @dev Transfers contract to a new primary.
111      * @param recipient The address of new primary.
112      */
113     function transferPrimary(address recipient) public onlyPrimary {
114         require(recipient != address(0));
115         _primary = recipient;
116         emit PrimaryTransferred(_primary);
117     }
118 }
119 
120 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 
126 interface IERC20 {
127     function transfer(address to, uint256 value) external returns (bool);
128 
129     function approve(address spender, uint256 value) external returns (bool);
130 
131     function transferFrom(address from, address to, uint256 value) external returns (bool);
132 
133     function totalSupply() external view returns (uint256);
134 
135     function balanceOf(address who) external view returns (uint256);
136 
137     function allowance(address owner, address spender) external view returns (uint256);
138 
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
145 
146 
147 /**
148  * @title SafeMath
149  * @dev Unsigned math operations with safety checks that revert on error
150  */
151 library SafeMath {
152     /**
153      * @dev Multiplies two unsigned integers, reverts on overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b);
165 
166         return c;
167     }
168 
169     /**
170      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Solidity only automatically asserts when dividing by 0
174         require(b > 0);
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177 
178         return c;
179     }
180 
181     /**
182      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b <= a);
186         uint256 c = a - b;
187 
188         return c;
189     }
190 
191     /**
192      * @dev Adds two unsigned integers, reverts on overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a);
197 
198         return c;
199     }
200 
201     /**
202      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
203      * reverts when dividing by zero.
204      */
205     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
206         require(b != 0);
207         return a % b;
208     }
209 }
210 
211 
212 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
213 /**
214  * @title Standard ERC20 token
215  *
216  * @dev Implementation of the basic standard token.
217  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
218  * Originally based on code by FirstBlood:
219  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
220  *
221  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
222  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
223  * compliant implementations may not do it.
224  */
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implementation of the basic standard token.
229  * https://eips.ethereum.org/EIPS/eip-20
230  * Originally based on code by FirstBlood:
231  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
232  *
233  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
234  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
235  * compliant implementations may not do it.
236  */
237 contract ERC20 is IERC20 {
238     using SafeMath for uint256;
239 
240     mapping (address => uint256) private _balances;
241 
242     mapping (address => mapping (address => uint256)) private _allowed;
243 
244     uint256 private _totalSupply;
245 
246     /**
247      * @dev Total number of tokens in existence
248      */
249     function totalSupply() public view returns (uint256) {
250         return _totalSupply;
251     }
252 
253     /**
254      * @dev Gets the balance of the specified address.
255      * @param owner The address to query the balance of.
256      * @return A uint256 representing the amount owned by the passed address.
257      */
258     function balanceOf(address owner) public view returns (uint256) {
259         return _balances[owner];
260     }
261 
262     /**
263      * @dev Function to check the amount of tokens that an owner allowed to a spender.
264      * @param owner address The address which owns the funds.
265      * @param spender address The address which will spend the funds.
266      * @return A uint256 specifying the amount of tokens still available for the spender.
267      */
268     function allowance(address owner, address spender) public view returns (uint256) {
269         return _allowed[owner][spender];
270     }
271 
272     /**
273      * @dev Transfer token to a specified address
274      * @param to The address to transfer to.
275      * @param value The amount to be transferred.
276      */
277     function transfer(address to, uint256 value) public returns (bool) {
278         _transfer(msg.sender, to, value);
279         return true;
280     }
281 
282     /**
283      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
284      * Beware that changing an allowance with this method brings the risk that someone may use both the old
285      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
286      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      * @param spender The address which will spend the funds.
289      * @param value The amount of tokens to be spent.
290      */
291     function approve(address spender, uint256 value) public returns (bool) {
292         _approve(msg.sender, spender, value);
293         return true;
294     }
295 
296     /**
297      * @dev Transfer tokens from one address to another.
298      * Note that while this function emits an Approval event, this is not required as per the specification,
299      * and other compliant implementations may not emit the event.
300      * @param from address The address which you want to send tokens from
301      * @param to address The address which you want to transfer to
302      * @param value uint256 the amount of tokens to be transferred
303      */
304     function transferFrom(address from, address to, uint256 value) public returns (bool) {
305         _transfer(from, to, value);
306         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
307         return true;
308     }
309 
310     /**
311      * @dev Increase the amount of tokens that an owner allowed to a spender.
312      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
313      * allowed value is better to use this function to avoid 2 calls (and wait until
314      * the first transaction is mined)
315      * From MonolithDAO Token.sol
316      * Emits an Approval event.
317      * @param spender The address which will spend the funds.
318      * @param addedValue The amount of tokens to increase the allowance by.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
321         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
322         return true;
323     }
324 
325     /**
326      * @dev Decrease the amount of tokens that an owner allowed to a spender.
327      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
328      * allowed value is better to use this function to avoid 2 calls (and wait until
329      * the first transaction is mined)
330      * From MonolithDAO Token.sol
331      * Emits an Approval event.
332      * @param spender The address which will spend the funds.
333      * @param subtractedValue The amount of tokens to decrease the allowance by.
334      */
335     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
336         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
337         return true;
338     }
339 
340     /**
341      * @dev Transfer token for a specified addresses
342      * @param from The address to transfer from.
343      * @param to The address to transfer to.
344      * @param value The amount to be transferred.
345      */
346     function _transfer(address from, address to, uint256 value) internal {
347         require(to != address(0));
348 
349         _balances[from] = _balances[from].sub(value);
350         _balances[to] = _balances[to].add(value);
351         emit Transfer(from, to, value);
352     }
353 
354     /**
355      * @dev Internal function that mints an amount of the token and assigns it to
356      * an account. This encapsulates the modification of balances such that the
357      * proper events are emitted.
358      * @param account The account that will receive the created tokens.
359      * @param value The amount that will be created.
360      */
361     function _mint(address account, uint256 value) internal {
362         require(account != address(0));
363 
364         _totalSupply = _totalSupply.add(value);
365         _balances[account] = _balances[account].add(value);
366         emit Transfer(address(0), account, value);
367     }
368 
369     /**
370      * @dev Internal function that burns an amount of the token of a given
371      * account.
372      * @param account The account whose tokens will be burnt.
373      * @param value The amount that will be burnt.
374      */
375     function _burn(address account, uint256 value) internal {
376         require(account != address(0));
377 
378         _totalSupply = _totalSupply.sub(value);
379         _balances[account] = _balances[account].sub(value);
380         emit Transfer(account, address(0), value);
381     }
382 
383     /**
384      * @dev Approve an address to spend another addresses' tokens.
385      * @param owner The address that owns the tokens.
386      * @param spender The address that will spend the tokens.
387      * @param value The number of tokens that can be spent.
388      */
389     function _approve(address owner, address spender, uint256 value) internal {
390         require(spender != address(0));
391         require(owner != address(0));
392 
393         _allowed[owner][spender] = value;
394         emit Approval(owner, spender, value);
395     }
396 
397     /**
398      * @dev Internal function that burns an amount of the token of a given
399      * account, deducting from the sender's allowance for said account. Uses the
400      * internal burn function.
401      * Emits an Approval event (reflecting the reduced allowance).
402      * @param account The account whose tokens will be burnt.
403      * @param value The amount that will be burnt.
404      */
405     function _burnFrom(address account, uint256 value) internal {
406         _burn(account, value);
407         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
408     }
409 }
410 
411 
412 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Burnable.sol
413 /**
414  * @title Burnable Token
415  * @dev Token that can be irreversibly burned (destroyed).
416  */
417 contract ERC20Burnable is ERC20 {
418     /**
419      * @dev Burns a specific amount of tokens.
420      * @param value The amount of token to be burned.
421      */
422     function burn(uint256 value) public {
423         _burn(msg.sender, value);
424     }
425 
426     /**
427      * @dev Burns a specific amount of tokens from the target address and decrements allowance
428      * @param from address The account whose tokens will be burned.
429      * @param value uint256 The amount of token to be burned.
430      */
431     function burnFrom(address from, uint256 value) public {
432         _burnFrom(from, value);
433     }
434 }
435 // File: node_modules\openzeppelin-solidity\contracts\access\Roles.sol
436 /**
437  * @title Roles
438  * @dev Library for managing addresses assigned to a Role.
439  */
440 library Roles {
441     struct Role {
442         mapping (address => bool) bearer;
443     }
444 
445     /**
446      * @dev give an account access to this role
447      */
448     function add(Role storage role, address account) internal {
449         require(account != address(0));
450         require(!has(role, account));
451 
452         role.bearer[account] = true;
453     }
454 
455     /**
456      * @dev remove an account's access to this role
457      */
458     function remove(Role storage role, address account) internal {
459         require(account != address(0));
460         require(has(role, account));
461 
462         role.bearer[account] = false;
463     }
464 
465     /**
466      * @dev check if an account has this role
467      * @return bool
468      */
469     function has(Role storage role, address account) internal view returns (bool) {
470         require(account != address(0));
471         return role.bearer[account];
472     }
473 }
474 
475 // File: node_modules\openzeppelin-solidity\contracts\access\roles\MinterRole.sol
476 contract MinterRole {
477     using Roles for Roles.Role;
478 
479     event MinterAdded(address indexed account);
480     event MinterRemoved(address indexed account);
481 
482     Roles.Role private _minters;
483 
484     constructor () internal {
485         _addMinter(msg.sender);
486     }
487 
488     modifier onlyMinter() {
489         require(isMinter(msg.sender));
490         _;
491     }
492 
493     function isMinter(address account) public view returns (bool) {
494         return _minters.has(account);
495     }
496 
497     function addMinter(address account) public onlyMinter {
498         _addMinter(account);
499     }
500 
501     function renounceMinter() public {
502         _removeMinter(msg.sender);
503     }
504 
505     function _addMinter(address account) internal {
506         _minters.add(account);
507         emit MinterAdded(account);
508     }
509 
510     function _removeMinter(address account) internal {
511         _minters.remove(account);
512         emit MinterRemoved(account);
513     }
514 }
515 
516 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Mintable.sol
517 
518 /**
519  * @title ERC20Mintable
520  * @dev ERC20 minting logic
521  */
522 contract ERC20Mintable is ERC20, MinterRole {
523     /**
524      * @dev Function to mint tokens
525      * @param to The address that will receive the minted tokens.
526      * @param value The amount of tokens to mint.
527      * @return A boolean that indicates if the operation was successful.
528      */
529     function mint(address to, uint256 value) public onlyMinter returns (bool) {
530         _mint(to, value);
531         return true;
532     }
533 }
534 
535 // File: contracts\ERC20Frozenable.sol
536 
537 
538 //truffle-flattener Token.sol
539 contract ERC20Frozenable is ERC20Burnable, ERC20Mintable, Ownable {
540     mapping (address => bool) private _frozenAccount;
541     event FrozenFunds(address target, bool frozen);
542 
543 
544     function frozenAccount(address _address) public view returns(bool isFrozen) {
545         return _frozenAccount[_address];
546     }
547 
548     function freezeAccount(address target, bool freeze)  public onlyOwner {
549         require(_frozenAccount[target] != freeze, "Same as current");
550         _frozenAccount[target] = freeze;
551         emit FrozenFunds(target, freeze);
552     }
553 
554     function _transfer(address from, address to, uint256 value) internal {
555         require(!_frozenAccount[from], "error - frozen");
556         require(!_frozenAccount[to], "error - frozen");
557         super._transfer(from, to, value);
558     }
559 
560 }
561 
562 // File: openzeppelin-solidity\contracts\token\ERC20\ERC20Detailed.sol
563 
564 /**
565  * @title ERC20Detailed token
566  * @dev The decimals are only for visualization purposes.
567  * All the operations are done using the smallest and indivisible token unit,
568  * just as on Ethereum all the operations are done in wei.
569  */
570 contract ERC20Detailed is IERC20 {
571     string private _name;
572     string private _symbol;
573     uint8 private _decimals;
574 
575     constructor (string memory name, string memory symbol, uint8 decimals) public {
576         _name = name;
577         _symbol = symbol;
578         _decimals = decimals;
579     }
580 
581     /**
582      * @return the name of the token.
583      */
584     function name() public view returns (string memory) {
585         return _name;
586     }
587 
588     /**
589      * @return the symbol of the token.
590      */
591     function symbol() public view returns (string memory) {
592         return _symbol;
593     }
594 
595     /**
596      * @return the number of decimals of the token.
597      */
598     function decimals() public view returns (uint8) {
599         return _decimals;
600     }
601 }
602 
603  /**
604   * @title Escrow
605   * @dev Base escrow contract, holds funds designated for a payee until they
606   * withdraw them.
607   * @dev Intended usage: This contract (and derived escrow contracts) should be a
608   * standalone contract, that only interacts with the contract that instantiated
609   * it. That way, it is guaranteed that all Ether will be handled according to
610   * the Escrow rules, and there is no need to check for payable functions or
611   * transfers in the inheritance tree. The contract that uses the escrow as its
612   * payment method should be its primary, and provide public methods redirecting
613   * to the escrow's deposit and withdraw.
614   */
615 contract Escrow is Secondary {
616     using SafeMath for uint256;
617 
618     event Deposited(address indexed payee, uint256 weiAmount);
619     event Withdrawn(address indexed payee, uint256 weiAmount);
620 
621     mapping(address => uint256) private _deposits;
622 
623     function depositsOf(address payee) public view returns (uint256) {
624         return _deposits[payee];
625     }
626 
627     /**
628      * @dev Stores the sent amount as credit to be withdrawn.
629      * @param payee The destination address of the funds.
630      */
631     function deposit(address payee) public onlyPrimary payable {
632         uint256 amount = msg.value;
633         _deposits[payee] = _deposits[payee].add(amount);
634 
635         emit Deposited(payee, amount);
636     }
637 
638     /**
639      * @dev Withdraw accumulated balance for a payee.
640      * @param payee The address whose funds will be withdrawn and transferred to.
641      */
642     function withdraw(address payable payee) public onlyPrimary {
643         uint256 payment = _deposits[payee];
644 
645         _deposits[payee] = 0;
646 
647         payee.transfer(payment);
648 
649         emit Withdrawn(payee, payment);
650     }
651 }
652 
653 /**
654  * @title PullPayment
655  * @dev Base contract supporting async send for pull payments. Inherit from this
656  * contract and use _asyncTransfer instead of send or transfer.
657  */
658 contract PullPayment {
659     Escrow private _escrow;
660 
661     constructor () internal {
662         _escrow = new Escrow();
663     }
664 
665     /**
666      * @dev Withdraw accumulated balance.
667      * @param payee Whose balance will be withdrawn.
668      */
669     function withdrawPayments(address payable payee) public {
670         _escrow.withdraw(payee);
671     }
672 
673     /**
674      * @dev Returns the credit owed to an address.
675      * @param dest The creditor's address.
676      */
677     function payments(address dest) public view returns (uint256) {
678         return _escrow.depositsOf(dest);
679     }
680 
681     /**
682      * @dev Called by the payer to store the sent amount as credit to be pulled.
683      * @param dest The destination address of the funds.
684      * @param amount The amount to transfer.
685      */
686     function _asyncTransfer(address dest, uint256 amount) internal {
687         _escrow.deposit.value(amount)(dest);
688     }
689 }
690 
691 contract PaymentSplitter {
692     using SafeMath for uint256;
693 
694     event PayeeAdded(address account, uint256 shares);
695     event PaymentReleased(address to, uint256 amount);
696     event PaymentReceived(address from, uint256 amount);
697 
698     uint256 private _totalShares;
699     uint256 private _totalReleased;
700 
701     mapping(address => uint256) private _shares;
702     mapping(address => uint256) private _released;
703     address[] private _payees;
704 
705     /**
706      * @dev Constructor
707      */
708     constructor (address[] memory payees, uint256[] memory shares) public payable {
709         require(payees.length == shares.length);
710         require(payees.length > 0);
711 
712         for (uint256 i = 0; i < payees.length; i++) {
713             _addPayee(payees[i], shares[i]);
714         }
715     }
716 
717     /**
718      * @dev payable fallback
719      */
720     function () external payable {
721         emit PaymentReceived(msg.sender, msg.value);
722     }
723 
724     /**
725      * @return the total shares of the contract.
726      */
727     function totalShares() public view returns (uint256) {
728         return _totalShares;
729     }
730 
731     /**
732      * @return the total amount already released.
733      */
734     function totalReleased() public view returns (uint256) {
735         return _totalReleased;
736     }
737 
738     /**
739      * @return the shares of an account.
740      */
741     function shares(address account) public view returns (uint256) {
742         return _shares[account];
743     }
744 
745     /**
746      * @return the amount already released to an account.
747      */
748     function released(address account) public view returns (uint256) {
749         return _released[account];
750     }
751 
752     /**
753      * @return the address of a payee.
754      */
755     function payee(uint256 index) public view returns (address) {
756         return _payees[index];
757     }
758 
759     /**
760      * @dev Release one of the payee's proportional payment.
761      * @param account Whose payments will be released.
762      */
763     function release(address payable account) public {
764         require(_shares[account] > 0);
765 
766         uint256 totalReceived = address(this).balance.add(_totalReleased);
767         uint256 payment = totalReceived.mul(_shares[account]).div(_totalShares).sub(_released[account]);
768 
769         require(payment != 0);
770 
771         _released[account] = _released[account].add(payment);
772         _totalReleased = _totalReleased.add(payment);
773 
774         account.transfer(payment);
775         emit PaymentReleased(account, payment);
776     }
777 
778     /**
779      * @dev Add a new payee to the contract.
780      * @param account The address of the payee to add.
781      * @param shares_ The number of shares owned by the payee.
782      */
783     function _addPayee(address account, uint256 shares_) private {
784         require(account != address(0));
785         require(shares_ > 0);
786         require(_shares[account] == 0);
787 
788         _payees.push(account);
789         _shares[account] = shares_;
790         _totalShares = _totalShares.add(shares_);
791         emit PayeeAdded(account, shares_);
792     }
793 }
794 
795 contract ConditionalEscrow is Escrow {
796     /**
797      * @dev Returns whether an address is allowed to withdraw their funds. To be
798      * implemented by derived contracts.
799      * @param payee The destination address of the funds.
800      */
801     function withdrawalAllowed(address payee) public view returns (bool);
802 
803     function withdraw(address payable payee) public {
804         require(withdrawalAllowed(payee));
805         super.withdraw(payee);
806     }
807 }
808 
809 
810 contract RefundEscrow is ConditionalEscrow {
811     enum State { Active, Refunding, Closed }
812 
813     event RefundsClosed();
814     event RefundsEnabled();
815 
816     State private _state;
817     address payable private _beneficiary;
818 
819     /**
820      * @dev Constructor.
821      * @param beneficiary The beneficiary of the deposits.
822      */
823     constructor (address payable beneficiary) public {
824         require(beneficiary != address(0));
825         _beneficiary = beneficiary;
826         _state = State.Active;
827     }
828 
829     /**
830      * @return the current state of the escrow.
831      */
832     function state() public view returns (State) {
833         return _state;
834     }
835 
836     /**
837      * @return the beneficiary of the escrow.
838      */
839     function beneficiary() public view returns (address) {
840         return _beneficiary;
841     }
842 
843     /**
844      * @dev Stores funds that may later be refunded.
845      * @param refundee The address funds will be sent to if a refund occurs.
846      */
847     function deposit(address refundee) public payable {
848         require(_state == State.Active);
849         super.deposit(refundee);
850     }
851 
852     /**
853      * @dev Allows for the beneficiary to withdraw their funds, rejecting
854      * further deposits.
855      */
856     function close() public onlyPrimary {
857         require(_state == State.Active);
858         _state = State.Closed;
859         emit RefundsClosed();
860     }
861 
862     /**
863      * @dev Allows for refunds to take place, rejecting further deposits.
864      */
865     function enableRefunds() public onlyPrimary {
866         require(_state == State.Active);
867         _state = State.Refunding;
868         emit RefundsEnabled();
869     }
870 
871     /**
872      * @dev Withdraws the beneficiary's funds.
873      */
874     function beneficiaryWithdraw() public {
875         require(_state == State.Closed);
876         _beneficiary.transfer(address(this).balance);
877     }
878 
879     /**
880      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
881      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
882      */
883     function withdrawalAllowed(address) public view returns (bool) {
884         return _state == State.Refunding;
885     }
886 }
887 // File: contracts\Token.sol
888 //truffle-flattener Token.sol
889 contract TTCBlocks is ERC20Frozenable, ERC20Detailed {
890 
891     constructor()
892     ERC20Detailed("TheTimesChain Coin", "TTC", 18)
893     public {
894         uint256 supply = 10000000000;
895         uint256 initialSupply = supply * uint(10) ** decimals();
896         _mint(msg.sender, initialSupply);
897     }
898 }