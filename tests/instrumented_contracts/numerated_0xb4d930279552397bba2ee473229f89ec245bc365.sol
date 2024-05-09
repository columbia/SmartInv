1 // File: browser/Pausable.sol
2 
3 
4 
5 // SPDX-License-Identifier: MIT
6 
7 
8 // File: browser/Context.sol
9 
10 
11 
12 pragma solidity >=0.6.0 <0.8.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 // File: browser/Address.sol
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 
41 /**
42  * @dev Contract module which allows children to implement an emergency stop
43  * mechanism that can be triggered by an authorized account.
44  *
45  * This module is used through inheritance. It will make available the
46  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
47  * the functions of your contract. Note that they will not be pausable by
48  * simply including this module, only once the modifiers are put in place.
49  */
50 abstract contract Pausable is Context {
51     /**
52      * @dev Emitted when the pause is triggered by `account`.
53      */
54     event Paused(address account);
55 
56     /**
57      * @dev Emitted when the pause is lifted by `account`.
58      */
59     event Unpaused(address account);
60 
61     bool private _paused;
62 
63     /**
64      * @dev Initializes the contract in unpaused state.
65      */
66     constructor () internal {
67         _paused = false;
68     }
69 
70     /**
71      * @dev Returns true if the contract is paused, and false otherwise.
72      */
73     function paused() public view returns (bool) {
74         return _paused;
75     }
76 
77     /**
78      * @dev Modifier to make a function callable only when the contract is not paused.
79      *
80      * Requirements:
81      *
82      * - The contract must not be paused.
83      */
84     modifier whenNotPaused() {
85         require(!_paused, "Pausable: paused");
86         _;
87     }
88 
89     /**
90      * @dev Modifier to make a function callable only when the contract is paused.
91      *
92      * Requirements:
93      *
94      * - The contract must be paused.
95      */
96     modifier whenPaused() {
97         require(_paused, "Pausable: not paused");
98         _;
99     }
100 
101     /**
102      * @dev Triggers stopped state.
103      *
104      * Requirements:
105      *
106      * - The contract must not be paused.
107      */
108     function _pause() internal virtual whenNotPaused {
109         _paused = true;
110         emit Paused(_msgSender());
111     }
112 
113     /**
114      * @dev Returns to normal state.
115      *
116      * Requirements:
117      *
118      * - The contract must be paused.
119      */
120     function _unpause() internal virtual whenPaused {
121         _paused = false;
122         emit Unpaused(_msgSender());
123     }
124 }
125 
126 // File: browser/ERC20Pausable.sol
127 
128 
129 // File: browser/IERC20.sol
130 
131 
132 
133 pragma solidity >=0.6.0 <0.8.0;
134 
135 /**
136  * @dev Interface of the ERC20 standard as defined in the EIP.
137  */
138 interface IERC20 {
139     /**
140      * @dev Returns the amount of tokens in existence.
141      */
142     function totalSupply() external view returns (uint256);
143 
144     /**
145      * @dev Returns the amount of tokens owned by `account`.
146      */
147     function balanceOf(address account) external view returns (uint256);
148 
149     /**
150      * @dev Moves `amount` tokens from the caller's account to `recipient`.
151      *
152      * Returns a boolean value indicating whether the operation succeeded.
153      *
154      * Emits a {Transfer} event.
155      */
156     function transfer(address recipient, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Returns the remaining number of tokens that `spender` will be
160      * allowed to spend on behalf of `owner` through {transferFrom}. This is
161      * zero by default.
162      *
163      * This value changes when {approve} or {transferFrom} are called.
164      */
165     function allowance(address owner, address spender) external view returns (uint256);
166 
167     /**
168      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * IMPORTANT: Beware that changing an allowance with this method brings the risk
173      * that someone may use both the old and the new allowance by unfortunate
174      * transaction ordering. One possible solution to mitigate this race
175      * condition is to first reduce the spender's allowance to 0 and set the
176      * desired value afterwards:
177      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address spender, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Moves `amount` tokens from `sender` to `recipient` using the
185      * allowance mechanism. `amount` is then deducted from the caller's
186      * allowance.
187      *
188      * Returns a boolean value indicating whether the operation succeeded.
189      *
190      * Emits a {Transfer} event.
191      */
192     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Emitted when `value` tokens are moved from one account (`from`) to
196      * another (`to`).
197      *
198      * Note that `value` may be zero.
199      */
200     event Transfer(address indexed from, address indexed to, uint256 value);
201 
202     /**
203      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204      * a call to {approve}. `value` is the new allowance.
205      */
206     event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 // File: browser/ERC20.sol
210 
211 
212 
213 pragma solidity >=0.6.0 <0.8.0;
214 
215 
216 
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin guidelines: functions revert instead
230  * of returning `false` on failure. This behavior is nonetheless conventional
231  * and does not conflict with the expectations of ERC20 applications.
232  *
233  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
234  * This allows applications to reconstruct the allowance for all accounts just
235  * by listening to said events. Other implementations of the EIP may not emit
236  * these events, as it isn't required by the specification.
237  *
238  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
239  * functions have been added to mitigate the well-known issues around setting
240  * allowances. See {IERC20-approve}.
241  */
242 contract ERC20 is Context, IERC20 {
243     using SafeMath for uint256;
244 
245     mapping (address => uint256) private _balances;
246 
247     mapping (address => mapping (address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253     uint8 private _decimals;
254 
255     /**
256      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
257      * a default value of 18.
258      *
259      * To select a different value for {decimals}, use {_setupDecimals}.
260      *
261      * All three of these values are immutable: they can only be set once during
262      * construction.
263      */
264     constructor (string memory name_, string memory symbol_) public {
265         _name = name_;
266         _symbol = symbol_;
267         _decimals = 18;
268     }
269 
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() public view returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @dev Returns the symbol of the token, usually a shorter version of the
279      * name.
280      */
281     function symbol() public view returns (string memory) {
282         return _symbol;
283     }
284 
285     /**
286      * @dev Returns the number of decimals used to get its user representation.
287      * For example, if `decimals` equals `2`, a balance of `505` tokens should
288      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
289      *
290      * Tokens usually opt for a value of 18, imitating the relationship between
291      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
292      * called.
293      *
294      * NOTE: This information is only used for _display_ purposes: it in
295      * no way affects any of the arithmetic of the contract, including
296      * {IERC20-balanceOf} and {IERC20-transfer}.
297      */
298     function decimals() public view returns (uint8) {
299         return _decimals;
300     }
301 
302     /**
303      * @dev See {IERC20-totalSupply}.
304      */
305     function totalSupply() public view override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     /**
310      * @dev See {IERC20-balanceOf}.
311      */
312     function balanceOf(address account) public view override returns (uint256) {
313         return _balances[account];
314     }
315 
316     /**
317      * @dev See {IERC20-transfer}.
318      *
319      * Requirements:
320      *
321      * - `recipient` cannot be the zero address.
322      * - the caller must have a balance of at least `amount`.
323      */
324     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender) public view virtual override returns (uint256) {
333         return _allowances[owner][spender];
334     }
335 
336     /**
337      * @dev See {IERC20-approve}.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function approve(address spender, uint256 amount) public virtual override returns (bool) {
344         _approve(_msgSender(), spender, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-transferFrom}.
350      *
351      * Emits an {Approval} event indicating the updated allowance. This is not
352      * required by the EIP. See the note at the beginning of {ERC20}.
353      *
354      * Requirements:
355      *
356      * - `sender` and `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``sender``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
362         _transfer(sender, recipient, amount);
363         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
364         return true;
365     }
366 
367     /**
368      * @dev Atomically increases the allowance granted to `spender` by the caller.
369      *
370      * This is an alternative to {approve} that can be used as a mitigation for
371      * problems described in {IERC20-approve}.
372      *
373      * Emits an {Approval} event indicating the updated allowance.
374      *
375      * Requirements:
376      *
377      * - `spender` cannot be the zero address.
378      */
379     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
380         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
381         return true;
382     }
383 
384     /**
385      * @dev Atomically decreases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      * - `spender` must have allowance for the caller of at least
396      * `subtractedValue`.
397      */
398     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
400         return true;
401     }
402 
403     /**
404      * @dev Moves tokens `amount` from `sender` to `recipient`.
405      *
406      * This is internal function is equivalent to {transfer}, and can be used to
407      * e.g. implement automatic token fees, slashing mechanisms, etc.
408      *
409      * Emits a {Transfer} event.
410      *
411      * Requirements:
412      *
413      * - `sender` cannot be the zero address.
414      * - `recipient` cannot be the zero address.
415      * - `sender` must have a balance of at least `amount`.
416      */
417     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
418         require(sender != address(0), "ERC20: transfer from the zero address");
419         require(recipient != address(0), "ERC20: transfer to the zero address");
420 
421         _beforeTokenTransfer(sender, recipient, amount);
422 
423         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
424         _balances[recipient] = _balances[recipient].add(amount);
425         emit Transfer(sender, recipient, amount);
426     }
427 
428     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
429      * the total supply.
430      *
431      * Emits a {Transfer} event with `from` set to the zero address.
432      *
433      * Requirements:
434      *
435      * - `to` cannot be the zero address.
436      */
437     function _mint(address account, uint256 amount) internal virtual {
438         require(account != address(0), "ERC20: mint to the zero address");
439 
440         _beforeTokenTransfer(address(0), account, amount);
441 
442         _totalSupply = _totalSupply.add(amount);
443         _balances[account] = _balances[account].add(amount);
444         emit Transfer(address(0), account, amount);
445     }
446 
447     /**
448      * @dev Destroys `amount` tokens from `account`, reducing the
449      * total supply.
450      *
451      * Emits a {Transfer} event with `to` set to the zero address.
452      *
453      * Requirements:
454      *
455      * - `account` cannot be the zero address.
456      * - `account` must have at least `amount` tokens.
457      */
458     function _burn(address account, uint256 amount) internal virtual {
459         require(account != address(0), "ERC20: burn from the zero address");
460 
461         _beforeTokenTransfer(account, address(0), amount);
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
470      *
471      * This internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal virtual {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Sets {decimals} to a value other than the default one of 18.
491      *
492      * WARNING: This function should only be called from the constructor. Most
493      * applications that interact with token contracts will not expect
494      * {decimals} to ever change, and may work incorrectly if it does.
495      */
496     function _setupDecimals(uint8 decimals_) internal {
497         _decimals = decimals_;
498     }
499 
500     /**
501      * @dev Hook that is called before any transfer of tokens. This includes
502      * minting and burning.
503      *
504      * Calling conditions:
505      *
506      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
507      * will be to transferred to `to`.
508      * - when `from` is zero, `amount` tokens will be minted for `to`.
509      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
510      * - `from` and `to` are never both zero.
511      *
512      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
513      */
514     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
515 }
516 
517 
518 pragma solidity >=0.6.0 <0.8.0;
519 
520 
521 
522 /**
523  * @dev ERC20 token with pausable token transfers, minting and burning.
524  *
525  * Useful for scenarios such as preventing trades until the end of an evaluation
526  * period, or having an emergency switch for freezing all token transfers in the
527  * event of a large bug.
528  */
529 abstract contract ERC20Pausable is ERC20, Pausable {
530     /**
531      * @dev See {ERC20-_beforeTokenTransfer}.
532      *
533      * Requirements:
534      *
535      * - the contract must not be paused.
536      */
537     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
538         super._beforeTokenTransfer(from, to, amount);
539 
540         require(!paused(), "ERC20Pausable: token transfer while paused");
541     }
542 }
543 
544 // File: browser/ERC20Burnable.sol
545 
546 
547 
548 pragma solidity >=0.6.0 <0.8.0;
549 
550 
551 
552 /**
553  * @dev Extension of {ERC20} that allows token holders to destroy both their own
554  * tokens and those that they have an allowance for, in a way that can be
555  * recognized off-chain (via event analysis).
556  */
557 abstract contract ERC20Burnable is Context, ERC20 {
558     using SafeMath for uint256;
559 
560     /**
561      * @dev Destroys `amount` tokens from the caller.
562      *
563      * See {ERC20-_burn}.
564      */
565     function burn(uint256 amount) public virtual {
566         _burn(_msgSender(), amount);
567     }
568 
569     /**
570      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
571      * allowance.
572      *
573      * See {ERC20-_burn} and {ERC20-allowance}.
574      *
575      * Requirements:
576      *
577      * - the caller must have allowance for ``accounts``'s tokens of at least
578      * `amount`.
579      */
580     function burnFrom(address account, uint256 amount) public virtual {
581         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
582 
583         _approve(account, _msgSender(), decreasedAllowance);
584         _burn(account, amount);
585     }
586 }
587 
588 // File: browser/SafeMath.sol
589 
590 
591 
592 pragma solidity >=0.6.0 <0.8.0;
593 
594 /**
595  * @dev Wrappers over Solidity's arithmetic operations with added overflow
596  * checks.
597  *
598  * Arithmetic operations in Solidity wrap on overflow. This can easily result
599  * in bugs, because programmers usually assume that an overflow raises an
600  * error, which is the standard behavior in high level programming languages.
601  * `SafeMath` restores this intuition by reverting the transaction when an
602  * operation overflows.
603  *
604  * Using this library instead of the unchecked operations eliminates an entire
605  * class of bugs, so it's recommended to use it always.
606  */
607 library SafeMath {
608     /**
609      * @dev Returns the addition of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `+` operator.
613      *
614      * Requirements:
615      *
616      * - Addition cannot overflow.
617      */
618     function add(uint256 a, uint256 b) internal pure returns (uint256) {
619         uint256 c = a + b;
620         require(c >= a, "SafeMath: addition overflow");
621 
622         return c;
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting on
627      * overflow (when the result is negative).
628      *
629      * Counterpart to Solidity's `-` operator.
630      *
631      * Requirements:
632      *
633      * - Subtraction cannot overflow.
634      */
635     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
636         return sub(a, b, "SafeMath: subtraction overflow");
637     }
638 
639     /**
640      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
641      * overflow (when the result is negative).
642      *
643      * Counterpart to Solidity's `-` operator.
644      *
645      * Requirements:
646      *
647      * - Subtraction cannot overflow.
648      */
649     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
650         require(b <= a, errorMessage);
651         uint256 c = a - b;
652 
653         return c;
654     }
655 
656     /**
657      * @dev Returns the multiplication of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `*` operator.
661      *
662      * Requirements:
663      *
664      * - Multiplication cannot overflow.
665      */
666     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
667         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
668         // benefit is lost if 'b' is also tested.
669         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
670         if (a == 0) {
671             return 0;
672         }
673 
674         uint256 c = a * b;
675         require(c / a == b, "SafeMath: multiplication overflow");
676 
677         return c;
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers. Reverts on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator. Note: this function uses a
685      * `revert` opcode (which leaves remaining gas untouched) while Solidity
686      * uses an invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function div(uint256 a, uint256 b) internal pure returns (uint256) {
693         return div(a, b, "SafeMath: division by zero");
694     }
695 
696     /**
697      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
698      * division by zero. The result is rounded towards zero.
699      *
700      * Counterpart to Solidity's `/` operator. Note: this function uses a
701      * `revert` opcode (which leaves remaining gas untouched) while Solidity
702      * uses an invalid opcode to revert (consuming all remaining gas).
703      *
704      * Requirements:
705      *
706      * - The divisor cannot be zero.
707      */
708     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
709         require(b > 0, errorMessage);
710         uint256 c = a / b;
711         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
712 
713         return c;
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * Reverts when dividing by zero.
719      *
720      * Counterpart to Solidity's `%` operator. This function uses a `revert`
721      * opcode (which leaves remaining gas untouched) while Solidity uses an
722      * invalid opcode to revert (consuming all remaining gas).
723      *
724      * Requirements:
725      *
726      * - The divisor cannot be zero.
727      */
728     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
729         return mod(a, b, "SafeMath: modulo by zero");
730     }
731 
732     /**
733      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
734      * Reverts with custom message when dividing by zero.
735      *
736      * Counterpart to Solidity's `%` operator. This function uses a `revert`
737      * opcode (which leaves remaining gas untouched) while Solidity uses an
738      * invalid opcode to revert (consuming all remaining gas).
739      *
740      * Requirements:
741      *
742      * - The divisor cannot be zero.
743      */
744     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
745         require(b != 0, errorMessage);
746         return a % b;
747     }
748 }
749 
750 
751 
752 pragma solidity >=0.6.2 <0.8.0;
753 
754 /**
755  * @dev Collection of functions related to the address type
756  */
757 library Address {
758     /**
759      * @dev Returns true if `account` is a contract.
760      *
761      * [IMPORTANT]
762      * ====
763      * It is unsafe to assume that an address for which this function returns
764      * false is an externally-owned account (EOA) and not a contract.
765      *
766      * Among others, `isContract` will return false for the following
767      * types of addresses:
768      *
769      *  - an externally-owned account
770      *  - a contract in construction
771      *  - an address where a contract will be created
772      *  - an address where a contract lived, but was destroyed
773      * ====
774      */
775     function isContract(address account) internal view returns (bool) {
776         // This method relies on extcodesize, which returns 0 for contracts in
777         // construction, since the code is only stored at the end of the
778         // constructor execution.
779 
780         uint256 size;
781         // solhint-disable-next-line no-inline-assembly
782         assembly { size := extcodesize(account) }
783         return size > 0;
784     }
785 
786     /**
787      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
788      * `recipient`, forwarding all available gas and reverting on errors.
789      *
790      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
791      * of certain opcodes, possibly making contracts go over the 2300 gas limit
792      * imposed by `transfer`, making them unable to receive funds via
793      * `transfer`. {sendValue} removes this limitation.
794      *
795      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
796      *
797      * IMPORTANT: because control is transferred to `recipient`, care must be
798      * taken to not create reentrancy vulnerabilities. Consider using
799      * {ReentrancyGuard} or the
800      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
801      */
802     function sendValue(address payable recipient, uint256 amount) internal {
803         require(address(this).balance >= amount, "Address: insufficient balance");
804 
805         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
806         (bool success, ) = recipient.call{ value: amount }("");
807         require(success, "Address: unable to send value, recipient may have reverted");
808     }
809 
810     /**
811      * @dev Performs a Solidity function call using a low level `call`. A
812      * plain`call` is an unsafe replacement for a function call: use this
813      * function instead.
814      *
815      * If `target` reverts with a revert reason, it is bubbled up by this
816      * function (like regular Solidity function calls).
817      *
818      * Returns the raw returned data. To convert to the expected return value,
819      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
820      *
821      * Requirements:
822      *
823      * - `target` must be a contract.
824      * - calling `target` with `data` must not revert.
825      *
826      * _Available since v3.1._
827      */
828     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
829       return functionCall(target, data, "Address: low-level call failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
834      * `errorMessage` as a fallback revert reason when `target` reverts.
835      *
836      * _Available since v3.1._
837      */
838     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, 0, errorMessage);
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
844      * but also transferring `value` wei to `target`.
845      *
846      * Requirements:
847      *
848      * - the calling contract must have an ETH balance of at least `value`.
849      * - the called Solidity function must be `payable`.
850      *
851      * _Available since v3.1._
852      */
853     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
854         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
855     }
856 
857     /**
858      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
859      * with `errorMessage` as a fallback revert reason when `target` reverts.
860      *
861      * _Available since v3.1._
862      */
863     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
864         require(address(this).balance >= value, "Address: insufficient balance for call");
865         require(isContract(target), "Address: call to non-contract");
866 
867         // solhint-disable-next-line avoid-low-level-calls
868         (bool success, bytes memory returndata) = target.call{ value: value }(data);
869         return _verifyCallResult(success, returndata, errorMessage);
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
874      * but performing a static call.
875      *
876      * _Available since v3.3._
877      */
878     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
879         return functionStaticCall(target, data, "Address: low-level static call failed");
880     }
881 
882     /**
883      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
884      * but performing a static call.
885      *
886      * _Available since v3.3._
887      */
888     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
889         require(isContract(target), "Address: static call to non-contract");
890 
891         // solhint-disable-next-line avoid-low-level-calls
892         (bool success, bytes memory returndata) = target.staticcall(data);
893         return _verifyCallResult(success, returndata, errorMessage);
894     }
895 
896     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
897         if (success) {
898             return returndata;
899         } else {
900             // Look for revert reason and bubble it up if present
901             if (returndata.length > 0) {
902                 // The easiest way to bubble the revert reason is using memory via assembly
903 
904                 // solhint-disable-next-line no-inline-assembly
905                 assembly {
906                     let returndata_size := mload(returndata)
907                     revert(add(32, returndata), returndata_size)
908                 }
909             } else {
910                 revert(errorMessage);
911             }
912         }
913     }
914 }
915 
916 // File: browser/EnumerableSet.sol
917 
918 
919 
920 pragma solidity >=0.6.0 <0.8.0;
921 
922 /**
923  * @dev Library for managing
924  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
925  * types.
926  *
927  * Sets have the following properties:
928  *
929  * - Elements are added, removed, and checked for existence in constant time
930  * (O(1)).
931  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
932  *
933  * ```
934  * contract Example {
935  *     // Add the library methods
936  *     using EnumerableSet for EnumerableSet.AddressSet;
937  *
938  *     // Declare a set state variable
939  *     EnumerableSet.AddressSet private mySet;
940  * }
941  * ```
942  *
943  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
944  * and `uint256` (`UintSet`) are supported.
945  */
946 library EnumerableSet {
947     // To implement this library for multiple types with as little code
948     // repetition as possible, we write it in terms of a generic Set type with
949     // bytes32 values.
950     // The Set implementation uses private functions, and user-facing
951     // implementations (such as AddressSet) are just wrappers around the
952     // underlying Set.
953     // This means that we can only create new EnumerableSets for types that fit
954     // in bytes32.
955 
956     struct Set {
957         // Storage of set values
958         bytes32[] _values;
959 
960         // Position of the value in the `values` array, plus 1 because index 0
961         // means a value is not in the set.
962         mapping (bytes32 => uint256) _indexes;
963     }
964 
965     /**
966      * @dev Add a value to a set. O(1).
967      *
968      * Returns true if the value was added to the set, that is if it was not
969      * already present.
970      */
971     function _add(Set storage set, bytes32 value) private returns (bool) {
972         if (!_contains(set, value)) {
973             set._values.push(value);
974             // The value is stored at length-1, but we add 1 to all indexes
975             // and use 0 as a sentinel value
976             set._indexes[value] = set._values.length;
977             return true;
978         } else {
979             return false;
980         }
981     }
982 
983     /**
984      * @dev Removes a value from a set. O(1).
985      *
986      * Returns true if the value was removed from the set, that is if it was
987      * present.
988      */
989     function _remove(Set storage set, bytes32 value) private returns (bool) {
990         // We read and store the value's index to prevent multiple reads from the same storage slot
991         uint256 valueIndex = set._indexes[value];
992 
993         if (valueIndex != 0) { // Equivalent to contains(set, value)
994             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
995             // the array, and then remove the last element (sometimes called as 'swap and pop').
996             // This modifies the order of the array, as noted in {at}.
997 
998             uint256 toDeleteIndex = valueIndex - 1;
999             uint256 lastIndex = set._values.length - 1;
1000 
1001             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1002             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1003 
1004             bytes32 lastvalue = set._values[lastIndex];
1005 
1006             // Move the last value to the index where the value to delete is
1007             set._values[toDeleteIndex] = lastvalue;
1008             // Update the index for the moved value
1009             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1010 
1011             // Delete the slot where the moved value was stored
1012             set._values.pop();
1013 
1014             // Delete the index for the deleted slot
1015             delete set._indexes[value];
1016 
1017             return true;
1018         } else {
1019             return false;
1020         }
1021     }
1022 
1023     /**
1024      * @dev Returns true if the value is in the set. O(1).
1025      */
1026     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1027         return set._indexes[value] != 0;
1028     }
1029 
1030     /**
1031      * @dev Returns the number of values on the set. O(1).
1032      */
1033     function _length(Set storage set) private view returns (uint256) {
1034         return set._values.length;
1035     }
1036 
1037    /**
1038     * @dev Returns the value stored at position `index` in the set. O(1).
1039     *
1040     * Note that there are no guarantees on the ordering of values inside the
1041     * array, and it may change when more values are added or removed.
1042     *
1043     * Requirements:
1044     *
1045     * - `index` must be strictly less than {length}.
1046     */
1047     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1048         require(set._values.length > index, "EnumerableSet: index out of bounds");
1049         return set._values[index];
1050     }
1051 
1052     // Bytes32Set
1053 
1054     struct Bytes32Set {
1055         Set _inner;
1056     }
1057 
1058     /**
1059      * @dev Add a value to a set. O(1).
1060      *
1061      * Returns true if the value was added to the set, that is if it was not
1062      * already present.
1063      */
1064     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1065         return _add(set._inner, value);
1066     }
1067 
1068     /**
1069      * @dev Removes a value from a set. O(1).
1070      *
1071      * Returns true if the value was removed from the set, that is if it was
1072      * present.
1073      */
1074     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1075         return _remove(set._inner, value);
1076     }
1077 
1078     /**
1079      * @dev Returns true if the value is in the set. O(1).
1080      */
1081     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1082         return _contains(set._inner, value);
1083     }
1084 
1085     /**
1086      * @dev Returns the number of values in the set. O(1).
1087      */
1088     function length(Bytes32Set storage set) internal view returns (uint256) {
1089         return _length(set._inner);
1090     }
1091 
1092    /**
1093     * @dev Returns the value stored at position `index` in the set. O(1).
1094     *
1095     * Note that there are no guarantees on the ordering of values inside the
1096     * array, and it may change when more values are added or removed.
1097     *
1098     * Requirements:
1099     *
1100     * - `index` must be strictly less than {length}.
1101     */
1102     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1103         return _at(set._inner, index);
1104     }
1105 
1106     // AddressSet
1107 
1108     struct AddressSet {
1109         Set _inner;
1110     }
1111 
1112     /**
1113      * @dev Add a value to a set. O(1).
1114      *
1115      * Returns true if the value was added to the set, that is if it was not
1116      * already present.
1117      */
1118     function add(AddressSet storage set, address value) internal returns (bool) {
1119         return _add(set._inner, bytes32(uint256(value)));
1120     }
1121 
1122     /**
1123      * @dev Removes a value from a set. O(1).
1124      *
1125      * Returns true if the value was removed from the set, that is if it was
1126      * present.
1127      */
1128     function remove(AddressSet storage set, address value) internal returns (bool) {
1129         return _remove(set._inner, bytes32(uint256(value)));
1130     }
1131 
1132     /**
1133      * @dev Returns true if the value is in the set. O(1).
1134      */
1135     function contains(AddressSet storage set, address value) internal view returns (bool) {
1136         return _contains(set._inner, bytes32(uint256(value)));
1137     }
1138 
1139     /**
1140      * @dev Returns the number of values in the set. O(1).
1141      */
1142     function length(AddressSet storage set) internal view returns (uint256) {
1143         return _length(set._inner);
1144     }
1145 
1146    /**
1147     * @dev Returns the value stored at position `index` in the set. O(1).
1148     *
1149     * Note that there are no guarantees on the ordering of values inside the
1150     * array, and it may change when more values are added or removed.
1151     *
1152     * Requirements:
1153     *
1154     * - `index` must be strictly less than {length}.
1155     */
1156     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1157         return address(uint256(_at(set._inner, index)));
1158     }
1159 
1160 
1161     // UintSet
1162 
1163     struct UintSet {
1164         Set _inner;
1165     }
1166 
1167     /**
1168      * @dev Add a value to a set. O(1).
1169      *
1170      * Returns true if the value was added to the set, that is if it was not
1171      * already present.
1172      */
1173     function add(UintSet storage set, uint256 value) internal returns (bool) {
1174         return _add(set._inner, bytes32(value));
1175     }
1176 
1177     /**
1178      * @dev Removes a value from a set. O(1).
1179      *
1180      * Returns true if the value was removed from the set, that is if it was
1181      * present.
1182      */
1183     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1184         return _remove(set._inner, bytes32(value));
1185     }
1186 
1187     /**
1188      * @dev Returns true if the value is in the set. O(1).
1189      */
1190     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1191         return _contains(set._inner, bytes32(value));
1192     }
1193 
1194     /**
1195      * @dev Returns the number of values on the set. O(1).
1196      */
1197     function length(UintSet storage set) internal view returns (uint256) {
1198         return _length(set._inner);
1199     }
1200 
1201    /**
1202     * @dev Returns the value stored at position `index` in the set. O(1).
1203     *
1204     * Note that there are no guarantees on the ordering of values inside the
1205     * array, and it may change when more values are added or removed.
1206     *
1207     * Requirements:
1208     *
1209     * - `index` must be strictly less than {length}.
1210     */
1211     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1212         return uint256(_at(set._inner, index));
1213     }
1214 }
1215 
1216 // File: browser/AccessControl.sol
1217 
1218 
1219 
1220 pragma solidity >=0.6.0 <0.8.0;
1221 
1222 
1223 
1224 
1225 /**
1226  * @dev Contract module that allows children to implement role-based access
1227  * control mechanisms.
1228  *
1229  * Roles are referred to by their `bytes32` identifier. These should be exposed
1230  * in the external API and be unique. The best way to achieve this is by
1231  * using `public constant` hash digests:
1232  *
1233  * ```
1234  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1235  * ```
1236  *
1237  * Roles can be used to represent a set of permissions. To restrict access to a
1238  * function call, use {hasRole}:
1239  *
1240  * ```
1241  * function foo() public {
1242  *     require(hasRole(MY_ROLE, msg.sender));
1243  *     ...
1244  * }
1245  * ```
1246  *
1247  * Roles can be granted and revoked dynamically via the {grantRole} and
1248  * {revokeRole} functions. Each role has an associated admin role, and only
1249  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1250  *
1251  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1252  * that only accounts with this role will be able to grant or revoke other
1253  * roles. More complex role relationships can be created by using
1254  * {_setRoleAdmin}.
1255  *
1256  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1257  * grant and revoke this role. Extra precautions should be taken to secure
1258  * accounts that have been granted it.
1259  */
1260 abstract contract AccessControl is Context {
1261     using EnumerableSet for EnumerableSet.AddressSet;
1262     using Address for address;
1263 
1264     struct RoleData {
1265         EnumerableSet.AddressSet members;
1266         bytes32 adminRole;
1267     }
1268 
1269     mapping (bytes32 => RoleData) private _roles;
1270 
1271     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1272 
1273     /**
1274      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1275      *
1276      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1277      * {RoleAdminChanged} not being emitted signaling this.
1278      *
1279      * _Available since v3.1._
1280      */
1281     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1282 
1283     /**
1284      * @dev Emitted when `account` is granted `role`.
1285      *
1286      * `sender` is the account that originated the contract call, an admin role
1287      * bearer except when using {_setupRole}.
1288      */
1289     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1290 
1291     /**
1292      * @dev Emitted when `account` is revoked `role`.
1293      *
1294      * `sender` is the account that originated the contract call:
1295      *   - if using `revokeRole`, it is the admin role bearer
1296      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1297      */
1298     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1299 
1300     /**
1301      * @dev Returns `true` if `account` has been granted `role`.
1302      */
1303     function hasRole(bytes32 role, address account) public view returns (bool) {
1304         return _roles[role].members.contains(account);
1305     }
1306 
1307     /**
1308      * @dev Returns the number of accounts that have `role`. Can be used
1309      * together with {getRoleMember} to enumerate all bearers of a role.
1310      */
1311     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1312         return _roles[role].members.length();
1313     }
1314 
1315     /**
1316      * @dev Returns one of the accounts that have `role`. `index` must be a
1317      * value between 0 and {getRoleMemberCount}, non-inclusive.
1318      *
1319      * Role bearers are not sorted in any particular way, and their ordering may
1320      * change at any point.
1321      *
1322      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1323      * you perform all queries on the same block. See the following
1324      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1325      * for more information.
1326      */
1327     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1328         return _roles[role].members.at(index);
1329     }
1330 
1331     /**
1332      * @dev Returns the admin role that controls `role`. See {grantRole} and
1333      * {revokeRole}.
1334      *
1335      * To change a role's admin, use {_setRoleAdmin}.
1336      */
1337     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1338         return _roles[role].adminRole;
1339     }
1340 
1341     /**
1342      * @dev Grants `role` to `account`.
1343      *
1344      * If `account` had not been already granted `role`, emits a {RoleGranted}
1345      * event.
1346      *
1347      * Requirements:
1348      *
1349      * - the caller must have ``role``'s admin role.
1350      */
1351     function grantRole(bytes32 role, address account) public virtual {
1352         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1353 
1354         _grantRole(role, account);
1355     }
1356 
1357     /**
1358      * @dev Revokes `role` from `account`.
1359      *
1360      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1361      *
1362      * Requirements:
1363      *
1364      * - the caller must have ``role``'s admin role.
1365      */
1366     function revokeRole(bytes32 role, address account) public virtual {
1367         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1368 
1369         _revokeRole(role, account);
1370     }
1371 
1372     /**
1373      * @dev Revokes `role` from the calling account.
1374      *
1375      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1376      * purpose is to provide a mechanism for accounts to lose their privileges
1377      * if they are compromised (such as when a trusted device is misplaced).
1378      *
1379      * If the calling account had been granted `role`, emits a {RoleRevoked}
1380      * event.
1381      *
1382      * Requirements:
1383      *
1384      * - the caller must be `account`.
1385      */
1386     function renounceRole(bytes32 role, address account) public virtual {
1387         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1388 
1389         _revokeRole(role, account);
1390     }
1391 
1392     /**
1393      * @dev Grants `role` to `account`.
1394      *
1395      * If `account` had not been already granted `role`, emits a {RoleGranted}
1396      * event. Note that unlike {grantRole}, this function doesn't perform any
1397      * checks on the calling account.
1398      *
1399      * [WARNING]
1400      * ====
1401      * This function should only be called from the constructor when setting
1402      * up the initial roles for the system.
1403      *
1404      * Using this function in any other way is effectively circumventing the admin
1405      * system imposed by {AccessControl}.
1406      * ====
1407      */
1408     function _setupRole(bytes32 role, address account) internal virtual {
1409         _grantRole(role, account);
1410     }
1411 
1412     /**
1413      * @dev Sets `adminRole` as ``role``'s admin role.
1414      *
1415      * Emits a {RoleAdminChanged} event.
1416      */
1417     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1418         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1419         _roles[role].adminRole = adminRole;
1420     }
1421 
1422     function _grantRole(bytes32 role, address account) private {
1423         if (_roles[role].members.add(account)) {
1424             emit RoleGranted(role, account, _msgSender());
1425         }
1426     }
1427 
1428     function _revokeRole(bytes32 role, address account) private {
1429         if (_roles[role].members.remove(account)) {
1430             emit RoleRevoked(role, account, _msgSender());
1431         }
1432     }
1433 }
1434 
1435 // File: browser/ERC20PresetMinterPauser.sol
1436 
1437 
1438 
1439 pragma solidity >=0.6.0 <0.8.0;
1440 
1441 
1442 
1443 
1444 
1445 
1446 /**
1447  * @dev {ERC20} token, including:
1448  *
1449  *  - ability for holders to burn (destroy) their tokens
1450  *  - a minter role that allows for token minting (creation)
1451  *  - a pauser role that allows to stop all token transfers
1452  *
1453  * This contract uses {AccessControl} to lock permissioned functions using the
1454  * different roles - head to its documentation for details.
1455  *
1456  * The account that deploys the contract will be granted the minter and pauser
1457  * roles, as well as the default admin role, which will let it grant both minter
1458  * and pauser roles to other accounts.
1459  */
1460 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1461     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1462     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1463 
1464     /**
1465      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1466      * account that deploys the contract.
1467      *
1468      * See {ERC20-constructor}.
1469      */
1470     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1471         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1472 
1473         _setupRole(MINTER_ROLE, _msgSender());
1474         _setupRole(PAUSER_ROLE, _msgSender());
1475     }
1476 
1477     /**
1478      * @dev Creates `amount` new tokens for `to`.
1479      *
1480      * See {ERC20-_mint}.
1481      *
1482      * Requirements:
1483      *
1484      * - the caller must have the `MINTER_ROLE`.
1485      */
1486     function mint(address to, uint256 amount) public virtual {
1487         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1488         _mint(to, amount);
1489     }
1490 
1491     /**
1492      * @dev Pauses all token transfers.
1493      *
1494      * See {ERC20Pausable} and {Pausable-_pause}.
1495      *
1496      * Requirements:
1497      *
1498      * - the caller must have the `PAUSER_ROLE`.
1499      */
1500     function pause() public virtual {
1501         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1502         _pause();
1503     }
1504 
1505     /**
1506      * @dev Unpauses all token transfers.
1507      *
1508      * See {ERC20Pausable} and {Pausable-_unpause}.
1509      *
1510      * Requirements:
1511      *
1512      * - the caller must have the `PAUSER_ROLE`.
1513      */
1514     function unpause() public virtual {
1515         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1516         _unpause();
1517     }
1518 
1519     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1520         super._beforeTokenTransfer(from, to, amount);
1521     }
1522 }
1523 
1524 // File: browser/MahaToken.sol
1525 
1526 pragma solidity ^0.6.0;
1527 
1528 
1529 
1530 contract MahaToken is ERC20PresetMinterPauser {
1531     address public upgradedAddress;
1532     bool public deprecated;
1533     string public contactInformation = "contact@mahadao.com";
1534     string public reason;
1535     string public link = "https://mahadao.com";
1536     string public url = "https://mahadao.com";
1537     string public website = "https://mahadao.com"; 
1538     
1539     constructor () public ERC20PresetMinterPauser ("MahaDAO", "MAHA") {}
1540 }