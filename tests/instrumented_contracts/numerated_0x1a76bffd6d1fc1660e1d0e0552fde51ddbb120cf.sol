1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 
6 
7 
8 
9 
10 
11 
12 /*
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with GSN meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 
34 
35 
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 
113 
114 
115 /**
116  * @dev Wrappers over Solidity's arithmetic operations with added overflow
117  * checks.
118  *
119  * Arithmetic operations in Solidity wrap on overflow. This can easily result
120  * in bugs, because programmers usually assume that an overflow raises an
121  * error, which is the standard behavior in high level programming languages.
122  * `SafeMath` restores this intuition by reverting the transaction when an
123  * operation overflows.
124  *
125  * Using this library instead of the unchecked operations eliminates an entire
126  * class of bugs, so it's recommended to use it always.
127  */
128 library SafeMath {
129     /**
130      * @dev Returns the addition of two unsigned integers, reverting on
131      * overflow.
132      *
133      * Counterpart to Solidity's `+` operator.
134      *
135      * Requirements:
136      *
137      * - Addition cannot overflow.
138      */
139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
140         uint256 c = a + b;
141         require(c >= a, "SafeMath: addition overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         uint256 c = a - b;
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the multiplication of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `*` operator.
182      *
183      * Requirements:
184      *
185      * - Multiplication cannot overflow.
186      */
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189         // benefit is lost if 'b' is also tested.
190         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191         if (a == 0) {
192             return 0;
193         }
194 
195         uint256 c = a * b;
196         require(c / a == b, "SafeMath: multiplication overflow");
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b) internal pure returns (uint256) {
214         return div(a, b, "SafeMath: division by zero");
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b > 0, errorMessage);
231         uint256 c = a / b;
232         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234         return c;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return mod(a, b, "SafeMath: modulo by zero");
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * Reverts with custom message when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 
272 /**
273  * @dev Implementation of the {IERC20} interface.
274  *
275  * This implementation is agnostic to the way tokens are created. This means
276  * that a supply mechanism has to be added in a derived contract using {_mint}.
277  * For a generic mechanism see {ERC20PresetMinterPauser}.
278  *
279  * TIP: For a detailed writeup see our guide
280  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
281  * to implement supply mechanisms].
282  *
283  * We have followed general OpenZeppelin guidelines: functions revert instead
284  * of returning `false` on failure. This behavior is nonetheless conventional
285  * and does not conflict with the expectations of ERC20 applications.
286  *
287  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
288  * This allows applications to reconstruct the allowance for all accounts just
289  * by listening to said events. Other implementations of the EIP may not emit
290  * these events, as it isn't required by the specification.
291  *
292  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
293  * functions have been added to mitigate the well-known issues around setting
294  * allowances. See {IERC20-approve}.
295  */
296 contract ERC20 is Context, IERC20 {
297     using SafeMath for uint256;
298 
299     mapping (address => uint256) private _balances;
300 
301     mapping (address => mapping (address => uint256)) private _allowances;
302 
303     uint256 private _totalSupply;
304 
305     string private _name;
306     string private _symbol;
307     uint8 private _decimals;
308 
309     /**
310      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
311      * a default value of 18.
312      *
313      * To select a different value for {decimals}, use {_setupDecimals}.
314      *
315      * All three of these values are immutable: they can only be set once during
316      * construction.
317      */
318     constructor (string memory name_, string memory symbol_) public {
319         _name = name_;
320         _symbol = symbol_;
321         _decimals = 18;
322     }
323 
324     /**
325      * @dev Returns the name of the token.
326      */
327     function name() public view returns (string memory) {
328         return _name;
329     }
330 
331     /**
332      * @dev Returns the symbol of the token, usually a shorter version of the
333      * name.
334      */
335     function symbol() public view returns (string memory) {
336         return _symbol;
337     }
338 
339     /**
340      * @dev Returns the number of decimals used to get its user representation.
341      * For example, if `decimals` equals `2`, a balance of `505` tokens should
342      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
343      *
344      * Tokens usually opt for a value of 18, imitating the relationship between
345      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
346      * called.
347      *
348      * NOTE: This information is only used for _display_ purposes: it in
349      * no way affects any of the arithmetic of the contract, including
350      * {IERC20-balanceOf} and {IERC20-transfer}.
351      */
352     function decimals() public view returns (uint8) {
353         return _decimals;
354     }
355 
356     /**
357      * @dev See {IERC20-totalSupply}.
358      */
359     function totalSupply() public view override returns (uint256) {
360         return _totalSupply;
361     }
362 
363     /**
364      * @dev See {IERC20-balanceOf}.
365      */
366     function balanceOf(address account) public view override returns (uint256) {
367         return _balances[account];
368     }
369 
370     /**
371      * @dev See {IERC20-transfer}.
372      *
373      * Requirements:
374      *
375      * - `recipient` cannot be the zero address.
376      * - the caller must have a balance of at least `amount`.
377      */
378     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
379         _transfer(_msgSender(), recipient, amount);
380         return true;
381     }
382 
383     /**
384      * @dev See {IERC20-allowance}.
385      */
386     function allowance(address owner, address spender) public view virtual override returns (uint256) {
387         return _allowances[owner][spender];
388     }
389 
390     /**
391      * @dev See {IERC20-approve}.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function approve(address spender, uint256 amount) public virtual override returns (bool) {
398         _approve(_msgSender(), spender, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-transferFrom}.
404      *
405      * Emits an {Approval} event indicating the updated allowance. This is not
406      * required by the EIP. See the note at the beginning of {ERC20}.
407      *
408      * Requirements:
409      *
410      * - `sender` and `recipient` cannot be the zero address.
411      * - `sender` must have a balance of at least `amount`.
412      * - the caller must have allowance for ``sender``'s tokens of at least
413      * `amount`.
414      */
415     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
416         _transfer(sender, recipient, amount);
417         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
418         return true;
419     }
420 
421     /**
422      * @dev Atomically increases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      */
433     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
434         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
435         return true;
436     }
437 
438     /**
439      * @dev Atomically decreases the allowance granted to `spender` by the caller.
440      *
441      * This is an alternative to {approve} that can be used as a mitigation for
442      * problems described in {IERC20-approve}.
443      *
444      * Emits an {Approval} event indicating the updated allowance.
445      *
446      * Requirements:
447      *
448      * - `spender` cannot be the zero address.
449      * - `spender` must have allowance for the caller of at least
450      * `subtractedValue`.
451      */
452     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
453         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
454         return true;
455     }
456 
457     /**
458      * @dev Moves tokens `amount` from `sender` to `recipient`.
459      *
460      * This is internal function is equivalent to {transfer}, and can be used to
461      * e.g. implement automatic token fees, slashing mechanisms, etc.
462      *
463      * Emits a {Transfer} event.
464      *
465      * Requirements:
466      *
467      * - `sender` cannot be the zero address.
468      * - `recipient` cannot be the zero address.
469      * - `sender` must have a balance of at least `amount`.
470      */
471     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
472         require(sender != address(0), "ERC20: transfer from the zero address");
473         require(recipient != address(0), "ERC20: transfer to the zero address");
474 
475         _beforeTokenTransfer(sender, recipient, amount);
476 
477         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
478         _balances[recipient] = _balances[recipient].add(amount);
479         emit Transfer(sender, recipient, amount);
480     }
481 
482     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
483      * the total supply.
484      *
485      * Emits a {Transfer} event with `from` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `to` cannot be the zero address.
490      */
491     function _mint(address account, uint256 amount) internal virtual {
492         require(account != address(0), "ERC20: mint to the zero address");
493 
494         _beforeTokenTransfer(address(0), account, amount);
495 
496         _totalSupply = _totalSupply.add(amount);
497         _balances[account] = _balances[account].add(amount);
498         emit Transfer(address(0), account, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`, reducing the
503      * total supply.
504      *
505      * Emits a {Transfer} event with `to` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      * - `account` must have at least `amount` tokens.
511      */
512     function _burn(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: burn from the zero address");
514 
515         _beforeTokenTransfer(account, address(0), amount);
516 
517         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
518         _totalSupply = _totalSupply.sub(amount);
519         emit Transfer(account, address(0), amount);
520     }
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
524      *
525      * This internal function is equivalent to `approve`, and can be used to
526      * e.g. set automatic allowances for certain subsystems, etc.
527      *
528      * Emits an {Approval} event.
529      *
530      * Requirements:
531      *
532      * - `owner` cannot be the zero address.
533      * - `spender` cannot be the zero address.
534      */
535     function _approve(address owner, address spender, uint256 amount) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Sets {decimals} to a value other than the default one of 18.
545      *
546      * WARNING: This function should only be called from the constructor. Most
547      * applications that interact with token contracts will not expect
548      * {decimals} to ever change, and may work incorrectly if it does.
549      */
550     function _setupDecimals(uint8 decimals_) internal {
551         _decimals = decimals_;
552     }
553 
554     /**
555      * @dev Hook that is called before any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * will be to transferred to `to`.
562      * - when `from` is zero, `amount` tokens will be minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
569 }
570 
571 
572 
573 
574 
575 
576 /**
577  * @dev Contract module which provides a basic access control mechanism, where
578  * there is an account (an owner) that can be granted exclusive access to
579  * specific functions.
580  *
581  * By default, the owner account will be the one that deploys the contract. This
582  * can later be changed with {transferOwnership}.
583  *
584  * This module is used through inheritance. It will make available the modifier
585  * `onlyOwner`, which can be applied to your functions to restrict their use to
586  * the owner.
587  */
588 abstract contract Ownable is Context {
589     address private _owner;
590 
591     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
592 
593     /**
594      * @dev Initializes the contract setting the deployer as the initial owner.
595      */
596     constructor () internal {
597         address msgSender = _msgSender();
598         _owner = msgSender;
599         emit OwnershipTransferred(address(0), msgSender);
600     }
601 
602     /**
603      * @dev Returns the address of the current owner.
604      */
605     function owner() public view returns (address) {
606         return _owner;
607     }
608 
609     /**
610      * @dev Throws if called by any account other than the owner.
611      */
612     modifier onlyOwner() {
613         require(_owner == _msgSender(), "Ownable: caller is not the owner");
614         _;
615     }
616 
617     /**
618      * @dev Leaves the contract without owner. It will not be possible to call
619      * `onlyOwner` functions anymore. Can only be called by the current owner.
620      *
621      * NOTE: Renouncing ownership will leave the contract without an owner,
622      * thereby removing any functionality that is only available to the owner.
623      */
624     function renounceOwnership() public virtual onlyOwner {
625         emit OwnershipTransferred(_owner, address(0));
626         _owner = address(0);
627     }
628 
629     /**
630      * @dev Transfers ownership of the contract to a new account (`newOwner`).
631      * Can only be called by the current owner.
632      */
633     function transferOwnership(address newOwner) public virtual onlyOwner {
634         require(newOwner != address(0), "Ownable: new owner is the zero address");
635         emit OwnershipTransferred(_owner, newOwner);
636         _owner = newOwner;
637     }
638 }
639 
640 
641 /**
642  * @title ERC1404
643  * @dev Security token standard
644  * Inherit from this contract to implement your own ERC-1404 token
645  */
646 abstract contract ERC1404 is ERC20 {
647     /// @notice Detects if a transfer will be reverted and if so returns an appropriate reference code
648     /// @param from Sending address
649     /// @param to Receiving address
650     /// @param value Amount of tokens being transferred
651     /// @return restrictionCode by which to reference message for rejection reasoning
652     /// @dev Overwrite with your custom transfer restriction logic
653     function detectTransferRestriction (address from, address to, uint256 value) public view virtual returns (uint8 restrictionCode);
654 
655     /// @notice Returns a human-readable message for a given restriction code
656     /// @param restrictionCode Identifier for looking up a message
657     /// @return message showing the restriction's reasoning
658     /// @dev Overwrite with your custom message and restrictionCode handling
659     function messageForTransferRestriction (uint8 restrictionCode) public view virtual returns (string memory message);
660 }
661 
662 /**
663  * @title Managed
664  * @dev The Managed contract has an a managers mapping, and provides basic authorization control via manager/owner
665  * modifiers as well as manager addition/removal/checks via functions".
666  */
667 contract Managed is Ownable {
668     mapping (address => bool) public managers;
669 
670     modifier onlyManager () {
671         require(isManager(), "Only managers may perform this action");
672         _;
673     }
674 
675     modifier onlyManagerOrOwner () {
676         require(
677             checkManagerStatus(msg.sender) || msg.sender == owner(),
678             "Only managers or owners may perform this action"
679         );
680         _;
681     }
682 
683     function checkManagerStatus (address managerAddress) public view returns (bool status) {
684         status = managers[managerAddress];
685     }
686 
687     function isManager () public view returns (bool status) {
688         status = checkManagerStatus(msg.sender);
689     }
690 
691     function addManager (address managerAddress) public onlyOwner {
692         managers[managerAddress] = true;
693     }
694 
695     function removeManager (address managerAddress) public onlyOwner {
696         managers[managerAddress] = false;
697     }
698 }
699 
700 /**
701  * @title RstToken
702  * @dev The RstToken contract inherits the ERC1404 security token contract.
703  * Transacting abilities are managed through a whitelist. The whitelist is managed by owner and delegators
704  * manage the list".
705  */
706 contract RstToken is ERC1404, Managed {
707     uint8 public constant SUCCESS_CODE = 0;
708     uint8 public constant SEND_NOT_ALLOWED_CODE = 1;
709     uint8 public constant RECEIVE_NOT_ALLOWED_CODE = 2;
710     string public constant SUCCESS_MESSAGE = "SUCCESS";
711     string public constant SEND_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED";
712     string public constant RECEIVE_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED";
713     mapping (uint8 => string) public messages;
714     mapping (address => bool) public whitelist;
715 
716     modifier notRestricted (address from, address to, uint256 value) {
717         uint8 restrictionCode = detectTransferRestriction(from, to, value);
718         require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
719         _;
720     }
721 
722     constructor () public ERC20("Realio Security Token", "RST"){
723         messages[0] = SUCCESS_MESSAGE;
724         messages[1] = SEND_NOT_ALLOWED_ERROR;
725         messages[2] = RECEIVE_NOT_ALLOWED_ERROR;
726         _mint(msg.sender, 50000000000000000000000000);
727     }
728 
729     function messageForTransferRestriction (uint8 restrictionCode)
730     public
731     view
732     virtual
733     override
734     returns (string memory message)
735     {
736         message = messages[restrictionCode];
737     }
738 
739 
740     function detectTransferRestriction (address from, address to, uint value)
741     public
742     view
743     override
744     returns (uint8 restrictionCode)
745     {
746         if (!whitelist[from]) {
747             restrictionCode = SEND_NOT_ALLOWED_CODE; // sender address not whitelisted
748         } else if (!whitelist[to]) {
749             restrictionCode = RECEIVE_NOT_ALLOWED_CODE; // receiver address not whitelisted
750         } else {
751             restrictionCode = SUCCESS_CODE; // successful transfer (required)
752         }
753     }
754 
755     function transfer (address to, uint256 value)
756     public
757     override
758     notRestricted(msg.sender, to, value)
759     returns (bool success)
760     {
761         success = super.transfer(to, value);
762     }
763 
764     function transferFrom (address from, address to, uint256 value)
765     public
766     override
767     notRestricted(from, to, value)
768     returns (bool success)
769     {
770         success = super.transferFrom(from, to, value);
771     }
772 
773     function approve(address spender, uint256 amount)
774     public
775     override
776     notRestricted(msg.sender, spender, amount)
777     returns (bool success)
778     {
779         success = super.approve(spender, amount);
780     }
781 
782     function addToWhitelist (address operator)
783     public onlyManagerOrOwner
784     {
785         whitelist[operator] = true;
786     }
787 
788     function removeFromWhitelist (address operator)
789     public onlyManagerOrOwner
790     {
791         whitelist[operator] = false;
792     }
793 }