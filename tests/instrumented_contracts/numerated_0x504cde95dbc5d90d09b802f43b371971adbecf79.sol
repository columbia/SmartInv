1 // Sources flattened with hardhat v2.0.5 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 
326 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
327 
328 pragma solidity >=0.6.0 <0.8.0;
329 
330 
331 
332 /**
333  * @dev Implementation of the {IERC20} interface.
334  *
335  * This implementation is agnostic to the way tokens are created. This means
336  * that a supply mechanism has to be added in a derived contract using {_mint}.
337  * For a generic mechanism see {ERC20PresetMinterPauser}.
338  *
339  * TIP: For a detailed writeup see our guide
340  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
341  * to implement supply mechanisms].
342  *
343  * We have followed general OpenZeppelin guidelines: functions revert instead
344  * of returning `false` on failure. This behavior is nonetheless conventional
345  * and does not conflict with the expectations of ERC20 applications.
346  *
347  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
348  * This allows applications to reconstruct the allowance for all accounts just
349  * by listening to said events. Other implementations of the EIP may not emit
350  * these events, as it isn't required by the specification.
351  *
352  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
353  * functions have been added to mitigate the well-known issues around setting
354  * allowances. See {IERC20-approve}.
355  */
356 contract ERC20 is Context, IERC20 {
357     using SafeMath for uint256;
358 
359     mapping (address => uint256) private _balances;
360 
361     mapping (address => mapping (address => uint256)) private _allowances;
362 
363     uint256 private _totalSupply;
364 
365     string private _name;
366     string private _symbol;
367     uint8 private _decimals;
368 
369     /**
370      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
371      * a default value of 18.
372      *
373      * To select a different value for {decimals}, use {_setupDecimals}.
374      *
375      * All three of these values are immutable: they can only be set once during
376      * construction.
377      */
378     constructor (string memory name_, string memory symbol_) public {
379         _name = name_;
380         _symbol = symbol_;
381         _decimals = 18;
382     }
383 
384     /**
385      * @dev Returns the name of the token.
386      */
387     function name() public view virtual returns (string memory) {
388         return _name;
389     }
390 
391     /**
392      * @dev Returns the symbol of the token, usually a shorter version of the
393      * name.
394      */
395     function symbol() public view virtual returns (string memory) {
396         return _symbol;
397     }
398 
399     /**
400      * @dev Returns the number of decimals used to get its user representation.
401      * For example, if `decimals` equals `2`, a balance of `505` tokens should
402      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
403      *
404      * Tokens usually opt for a value of 18, imitating the relationship between
405      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
406      * called.
407      *
408      * NOTE: This information is only used for _display_ purposes: it in
409      * no way affects any of the arithmetic of the contract, including
410      * {IERC20-balanceOf} and {IERC20-transfer}.
411      */
412     function decimals() public view virtual returns (uint8) {
413         return _decimals;
414     }
415 
416     /**
417      * @dev See {IERC20-totalSupply}.
418      */
419     function totalSupply() public view virtual override returns (uint256) {
420         return _totalSupply;
421     }
422 
423     /**
424      * @dev See {IERC20-balanceOf}.
425      */
426     function balanceOf(address account) public view virtual override returns (uint256) {
427         return _balances[account];
428     }
429 
430     /**
431      * @dev See {IERC20-transfer}.
432      *
433      * Requirements:
434      *
435      * - `recipient` cannot be the zero address.
436      * - the caller must have a balance of at least `amount`.
437      */
438     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
439         _transfer(_msgSender(), recipient, amount);
440         return true;
441     }
442 
443     /**
444      * @dev See {IERC20-allowance}.
445      */
446     function allowance(address owner, address spender) public view virtual override returns (uint256) {
447         return _allowances[owner][spender];
448     }
449 
450     /**
451      * @dev See {IERC20-approve}.
452      *
453      * Requirements:
454      *
455      * - `spender` cannot be the zero address.
456      */
457     function approve(address spender, uint256 amount) public virtual override returns (bool) {
458         _approve(_msgSender(), spender, amount);
459         return true;
460     }
461 
462     /**
463      * @dev See {IERC20-transferFrom}.
464      *
465      * Emits an {Approval} event indicating the updated allowance. This is not
466      * required by the EIP. See the note at the beginning of {ERC20}.
467      *
468      * Requirements:
469      *
470      * - `sender` and `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      * - the caller must have allowance for ``sender``'s tokens of at least
473      * `amount`.
474      */
475     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
476         _transfer(sender, recipient, amount);
477         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically increases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      */
493     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
495         return true;
496     }
497 
498     /**
499      * @dev Atomically decreases the allowance granted to `spender` by the caller.
500      *
501      * This is an alternative to {approve} that can be used as a mitigation for
502      * problems described in {IERC20-approve}.
503      *
504      * Emits an {Approval} event indicating the updated allowance.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      * - `spender` must have allowance for the caller of at least
510      * `subtractedValue`.
511      */
512     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
513         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
514         return true;
515     }
516 
517     /**
518      * @dev Moves tokens `amount` from `sender` to `recipient`.
519      *
520      * This is internal function is equivalent to {transfer}, and can be used to
521      * e.g. implement automatic token fees, slashing mechanisms, etc.
522      *
523      * Emits a {Transfer} event.
524      *
525      * Requirements:
526      *
527      * - `sender` cannot be the zero address.
528      * - `recipient` cannot be the zero address.
529      * - `sender` must have a balance of at least `amount`.
530      */
531     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
532         require(sender != address(0), "ERC20: transfer from the zero address");
533         require(recipient != address(0), "ERC20: transfer to the zero address");
534 
535         _beforeTokenTransfer(sender, recipient, amount);
536 
537         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
538         _balances[recipient] = _balances[recipient].add(amount);
539         emit Transfer(sender, recipient, amount);
540     }
541 
542     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
543      * the total supply.
544      *
545      * Emits a {Transfer} event with `from` set to the zero address.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      */
551     function _mint(address account, uint256 amount) internal virtual {
552         require(account != address(0), "ERC20: mint to the zero address");
553 
554         _beforeTokenTransfer(address(0), account, amount);
555 
556         _totalSupply = _totalSupply.add(amount);
557         _balances[account] = _balances[account].add(amount);
558         emit Transfer(address(0), account, amount);
559     }
560 
561     /**
562      * @dev Destroys `amount` tokens from `account`, reducing the
563      * total supply.
564      *
565      * Emits a {Transfer} event with `to` set to the zero address.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      * - `account` must have at least `amount` tokens.
571      */
572     function _burn(address account, uint256 amount) internal virtual {
573         require(account != address(0), "ERC20: burn from the zero address");
574 
575         _beforeTokenTransfer(account, address(0), amount);
576 
577         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
578         _totalSupply = _totalSupply.sub(amount);
579         emit Transfer(account, address(0), amount);
580     }
581 
582     /**
583      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
584      *
585      * This internal function is equivalent to `approve`, and can be used to
586      * e.g. set automatic allowances for certain subsystems, etc.
587      *
588      * Emits an {Approval} event.
589      *
590      * Requirements:
591      *
592      * - `owner` cannot be the zero address.
593      * - `spender` cannot be the zero address.
594      */
595     function _approve(address owner, address spender, uint256 amount) internal virtual {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     /**
604      * @dev Sets {decimals} to a value other than the default one of 18.
605      *
606      * WARNING: This function should only be called from the constructor. Most
607      * applications that interact with token contracts will not expect
608      * {decimals} to ever change, and may work incorrectly if it does.
609      */
610     function _setupDecimals(uint8 decimals_) internal virtual {
611         _decimals = decimals_;
612     }
613 
614     /**
615      * @dev Hook that is called before any transfer of tokens. This includes
616      * minting and burning.
617      *
618      * Calling conditions:
619      *
620      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
621      * will be to transferred to `to`.
622      * - when `from` is zero, `amount` tokens will be minted for `to`.
623      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
624      * - `from` and `to` are never both zero.
625      *
626      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
627      */
628     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
629 }
630 
631 
632 // File @openzeppelin/contracts/utils/Pausable.sol@v3.4.1
633 
634 pragma solidity >=0.6.0 <0.8.0;
635 
636 /**
637  * @dev Contract module which allows children to implement an emergency stop
638  * mechanism that can be triggered by an authorized account.
639  *
640  * This module is used through inheritance. It will make available the
641  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
642  * the functions of your contract. Note that they will not be pausable by
643  * simply including this module, only once the modifiers are put in place.
644  */
645 abstract contract Pausable is Context {
646     /**
647      * @dev Emitted when the pause is triggered by `account`.
648      */
649     event Paused(address account);
650 
651     /**
652      * @dev Emitted when the pause is lifted by `account`.
653      */
654     event Unpaused(address account);
655 
656     bool private _paused;
657 
658     /**
659      * @dev Initializes the contract in unpaused state.
660      */
661     constructor () internal {
662         _paused = false;
663     }
664 
665     /**
666      * @dev Returns true if the contract is paused, and false otherwise.
667      */
668     function paused() public view virtual returns (bool) {
669         return _paused;
670     }
671 
672     /**
673      * @dev Modifier to make a function callable only when the contract is not paused.
674      *
675      * Requirements:
676      *
677      * - The contract must not be paused.
678      */
679     modifier whenNotPaused() {
680         require(!paused(), "Pausable: paused");
681         _;
682     }
683 
684     /**
685      * @dev Modifier to make a function callable only when the contract is paused.
686      *
687      * Requirements:
688      *
689      * - The contract must be paused.
690      */
691     modifier whenPaused() {
692         require(paused(), "Pausable: not paused");
693         _;
694     }
695 
696     /**
697      * @dev Triggers stopped state.
698      *
699      * Requirements:
700      *
701      * - The contract must not be paused.
702      */
703     function _pause() internal virtual whenNotPaused {
704         _paused = true;
705         emit Paused(_msgSender());
706     }
707 
708     /**
709      * @dev Returns to normal state.
710      *
711      * Requirements:
712      *
713      * - The contract must be paused.
714      */
715     function _unpause() internal virtual whenPaused {
716         _paused = false;
717         emit Unpaused(_msgSender());
718     }
719 }
720 
721 
722 // File @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol@v3.4.1
723 
724 pragma solidity >=0.6.0 <0.8.0;
725 
726 
727 /**
728  * @dev ERC20 token with pausable token transfers, minting and burning.
729  *
730  * Useful for scenarios such as preventing trades until the end of an evaluation
731  * period, or having an emergency switch for freezing all token transfers in the
732  * event of a large bug.
733  */
734 abstract contract ERC20Pausable is ERC20, Pausable {
735     /**
736      * @dev See {ERC20-_beforeTokenTransfer}.
737      *
738      * Requirements:
739      *
740      * - the contract must not be paused.
741      */
742     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
743         super._beforeTokenTransfer(from, to, amount);
744 
745         require(!paused(), "ERC20Pausable: token transfer while paused");
746     }
747 }
748 
749 
750 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
751 
752 pragma solidity >=0.6.0 <0.8.0;
753 
754 /**
755  * @dev Contract module which provides a basic access control mechanism, where
756  * there is an account (an owner) that can be granted exclusive access to
757  * specific functions.
758  *
759  * By default, the owner account will be the one that deploys the contract. This
760  * can later be changed with {transferOwnership}.
761  *
762  * This module is used through inheritance. It will make available the modifier
763  * `onlyOwner`, which can be applied to your functions to restrict their use to
764  * the owner.
765  */
766 abstract contract Ownable is Context {
767     address private _owner;
768 
769     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
770 
771     /**
772      * @dev Initializes the contract setting the deployer as the initial owner.
773      */
774     constructor () internal {
775         address msgSender = _msgSender();
776         _owner = msgSender;
777         emit OwnershipTransferred(address(0), msgSender);
778     }
779 
780     /**
781      * @dev Returns the address of the current owner.
782      */
783     function owner() public view virtual returns (address) {
784         return _owner;
785     }
786 
787     /**
788      * @dev Throws if called by any account other than the owner.
789      */
790     modifier onlyOwner() {
791         require(owner() == _msgSender(), "Ownable: caller is not the owner");
792         _;
793     }
794 
795     /**
796      * @dev Leaves the contract without owner. It will not be possible to call
797      * `onlyOwner` functions anymore. Can only be called by the current owner.
798      *
799      * NOTE: Renouncing ownership will leave the contract without an owner,
800      * thereby removing any functionality that is only available to the owner.
801      */
802     function renounceOwnership() public virtual onlyOwner {
803         emit OwnershipTransferred(_owner, address(0));
804         _owner = address(0);
805     }
806 
807     /**
808      * @dev Transfers ownership of the contract to a new account (`newOwner`).
809      * Can only be called by the current owner.
810      */
811     function transferOwnership(address newOwner) public virtual onlyOwner {
812         require(newOwner != address(0), "Ownable: new owner is the zero address");
813         emit OwnershipTransferred(_owner, newOwner);
814         _owner = newOwner;
815     }
816 }
817 
818 
819 // File @openzeppelin/contracts/utils/EnumerableSet.sol@v3.4.1
820 
821 pragma solidity >=0.6.0 <0.8.0;
822 
823 /**
824  * @dev Library for managing
825  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
826  * types.
827  *
828  * Sets have the following properties:
829  *
830  * - Elements are added, removed, and checked for existence in constant time
831  * (O(1)).
832  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
833  *
834  * ```
835  * contract Example {
836  *     // Add the library methods
837  *     using EnumerableSet for EnumerableSet.AddressSet;
838  *
839  *     // Declare a set state variable
840  *     EnumerableSet.AddressSet private mySet;
841  * }
842  * ```
843  *
844  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
845  * and `uint256` (`UintSet`) are supported.
846  */
847 library EnumerableSet {
848     // To implement this library for multiple types with as little code
849     // repetition as possible, we write it in terms of a generic Set type with
850     // bytes32 values.
851     // The Set implementation uses private functions, and user-facing
852     // implementations (such as AddressSet) are just wrappers around the
853     // underlying Set.
854     // This means that we can only create new EnumerableSets for types that fit
855     // in bytes32.
856 
857     struct Set {
858         // Storage of set values
859         bytes32[] _values;
860 
861         // Position of the value in the `values` array, plus 1 because index 0
862         // means a value is not in the set.
863         mapping (bytes32 => uint256) _indexes;
864     }
865 
866     /**
867      * @dev Add a value to a set. O(1).
868      *
869      * Returns true if the value was added to the set, that is if it was not
870      * already present.
871      */
872     function _add(Set storage set, bytes32 value) private returns (bool) {
873         if (!_contains(set, value)) {
874             set._values.push(value);
875             // The value is stored at length-1, but we add 1 to all indexes
876             // and use 0 as a sentinel value
877             set._indexes[value] = set._values.length;
878             return true;
879         } else {
880             return false;
881         }
882     }
883 
884     /**
885      * @dev Removes a value from a set. O(1).
886      *
887      * Returns true if the value was removed from the set, that is if it was
888      * present.
889      */
890     function _remove(Set storage set, bytes32 value) private returns (bool) {
891         // We read and store the value's index to prevent multiple reads from the same storage slot
892         uint256 valueIndex = set._indexes[value];
893 
894         if (valueIndex != 0) { // Equivalent to contains(set, value)
895             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
896             // the array, and then remove the last element (sometimes called as 'swap and pop').
897             // This modifies the order of the array, as noted in {at}.
898 
899             uint256 toDeleteIndex = valueIndex - 1;
900             uint256 lastIndex = set._values.length - 1;
901 
902             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
903             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
904 
905             bytes32 lastvalue = set._values[lastIndex];
906 
907             // Move the last value to the index where the value to delete is
908             set._values[toDeleteIndex] = lastvalue;
909             // Update the index for the moved value
910             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
911 
912             // Delete the slot where the moved value was stored
913             set._values.pop();
914 
915             // Delete the index for the deleted slot
916             delete set._indexes[value];
917 
918             return true;
919         } else {
920             return false;
921         }
922     }
923 
924     /**
925      * @dev Returns true if the value is in the set. O(1).
926      */
927     function _contains(Set storage set, bytes32 value) private view returns (bool) {
928         return set._indexes[value] != 0;
929     }
930 
931     /**
932      * @dev Returns the number of values on the set. O(1).
933      */
934     function _length(Set storage set) private view returns (uint256) {
935         return set._values.length;
936     }
937 
938    /**
939     * @dev Returns the value stored at position `index` in the set. O(1).
940     *
941     * Note that there are no guarantees on the ordering of values inside the
942     * array, and it may change when more values are added or removed.
943     *
944     * Requirements:
945     *
946     * - `index` must be strictly less than {length}.
947     */
948     function _at(Set storage set, uint256 index) private view returns (bytes32) {
949         require(set._values.length > index, "EnumerableSet: index out of bounds");
950         return set._values[index];
951     }
952 
953     // Bytes32Set
954 
955     struct Bytes32Set {
956         Set _inner;
957     }
958 
959     /**
960      * @dev Add a value to a set. O(1).
961      *
962      * Returns true if the value was added to the set, that is if it was not
963      * already present.
964      */
965     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
966         return _add(set._inner, value);
967     }
968 
969     /**
970      * @dev Removes a value from a set. O(1).
971      *
972      * Returns true if the value was removed from the set, that is if it was
973      * present.
974      */
975     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
976         return _remove(set._inner, value);
977     }
978 
979     /**
980      * @dev Returns true if the value is in the set. O(1).
981      */
982     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
983         return _contains(set._inner, value);
984     }
985 
986     /**
987      * @dev Returns the number of values in the set. O(1).
988      */
989     function length(Bytes32Set storage set) internal view returns (uint256) {
990         return _length(set._inner);
991     }
992 
993    /**
994     * @dev Returns the value stored at position `index` in the set. O(1).
995     *
996     * Note that there are no guarantees on the ordering of values inside the
997     * array, and it may change when more values are added or removed.
998     *
999     * Requirements:
1000     *
1001     * - `index` must be strictly less than {length}.
1002     */
1003     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1004         return _at(set._inner, index);
1005     }
1006 
1007     // AddressSet
1008 
1009     struct AddressSet {
1010         Set _inner;
1011     }
1012 
1013     /**
1014      * @dev Add a value to a set. O(1).
1015      *
1016      * Returns true if the value was added to the set, that is if it was not
1017      * already present.
1018      */
1019     function add(AddressSet storage set, address value) internal returns (bool) {
1020         return _add(set._inner, bytes32(uint256(uint160(value))));
1021     }
1022 
1023     /**
1024      * @dev Removes a value from a set. O(1).
1025      *
1026      * Returns true if the value was removed from the set, that is if it was
1027      * present.
1028      */
1029     function remove(AddressSet storage set, address value) internal returns (bool) {
1030         return _remove(set._inner, bytes32(uint256(uint160(value))));
1031     }
1032 
1033     /**
1034      * @dev Returns true if the value is in the set. O(1).
1035      */
1036     function contains(AddressSet storage set, address value) internal view returns (bool) {
1037         return _contains(set._inner, bytes32(uint256(uint160(value))));
1038     }
1039 
1040     /**
1041      * @dev Returns the number of values in the set. O(1).
1042      */
1043     function length(AddressSet storage set) internal view returns (uint256) {
1044         return _length(set._inner);
1045     }
1046 
1047    /**
1048     * @dev Returns the value stored at position `index` in the set. O(1).
1049     *
1050     * Note that there are no guarantees on the ordering of values inside the
1051     * array, and it may change when more values are added or removed.
1052     *
1053     * Requirements:
1054     *
1055     * - `index` must be strictly less than {length}.
1056     */
1057     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1058         return address(uint160(uint256(_at(set._inner, index))));
1059     }
1060 
1061 
1062     // UintSet
1063 
1064     struct UintSet {
1065         Set _inner;
1066     }
1067 
1068     /**
1069      * @dev Add a value to a set. O(1).
1070      *
1071      * Returns true if the value was added to the set, that is if it was not
1072      * already present.
1073      */
1074     function add(UintSet storage set, uint256 value) internal returns (bool) {
1075         return _add(set._inner, bytes32(value));
1076     }
1077 
1078     /**
1079      * @dev Removes a value from a set. O(1).
1080      *
1081      * Returns true if the value was removed from the set, that is if it was
1082      * present.
1083      */
1084     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1085         return _remove(set._inner, bytes32(value));
1086     }
1087 
1088     /**
1089      * @dev Returns true if the value is in the set. O(1).
1090      */
1091     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1092         return _contains(set._inner, bytes32(value));
1093     }
1094 
1095     /**
1096      * @dev Returns the number of values on the set. O(1).
1097      */
1098     function length(UintSet storage set) internal view returns (uint256) {
1099         return _length(set._inner);
1100     }
1101 
1102    /**
1103     * @dev Returns the value stored at position `index` in the set. O(1).
1104     *
1105     * Note that there are no guarantees on the ordering of values inside the
1106     * array, and it may change when more values are added or removed.
1107     *
1108     * Requirements:
1109     *
1110     * - `index` must be strictly less than {length}.
1111     */
1112     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1113         return uint256(_at(set._inner, index));
1114     }
1115 }
1116 
1117 
1118 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
1119 
1120 pragma solidity >=0.6.2 <0.8.0;
1121 
1122 /**
1123  * @dev Collection of functions related to the address type
1124  */
1125 library Address {
1126     /**
1127      * @dev Returns true if `account` is a contract.
1128      *
1129      * [IMPORTANT]
1130      * ====
1131      * It is unsafe to assume that an address for which this function returns
1132      * false is an externally-owned account (EOA) and not a contract.
1133      *
1134      * Among others, `isContract` will return false for the following
1135      * types of addresses:
1136      *
1137      *  - an externally-owned account
1138      *  - a contract in construction
1139      *  - an address where a contract will be created
1140      *  - an address where a contract lived, but was destroyed
1141      * ====
1142      */
1143     function isContract(address account) internal view returns (bool) {
1144         // This method relies on extcodesize, which returns 0 for contracts in
1145         // construction, since the code is only stored at the end of the
1146         // constructor execution.
1147 
1148         uint256 size;
1149         // solhint-disable-next-line no-inline-assembly
1150         assembly { size := extcodesize(account) }
1151         return size > 0;
1152     }
1153 
1154     /**
1155      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1156      * `recipient`, forwarding all available gas and reverting on errors.
1157      *
1158      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1159      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1160      * imposed by `transfer`, making them unable to receive funds via
1161      * `transfer`. {sendValue} removes this limitation.
1162      *
1163      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1164      *
1165      * IMPORTANT: because control is transferred to `recipient`, care must be
1166      * taken to not create reentrancy vulnerabilities. Consider using
1167      * {ReentrancyGuard} or the
1168      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1169      */
1170     function sendValue(address payable recipient, uint256 amount) internal {
1171         require(address(this).balance >= amount, "Address: insufficient balance");
1172 
1173         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1174         (bool success, ) = recipient.call{ value: amount }("");
1175         require(success, "Address: unable to send value, recipient may have reverted");
1176     }
1177 
1178     /**
1179      * @dev Performs a Solidity function call using a low level `call`. A
1180      * plain`call` is an unsafe replacement for a function call: use this
1181      * function instead.
1182      *
1183      * If `target` reverts with a revert reason, it is bubbled up by this
1184      * function (like regular Solidity function calls).
1185      *
1186      * Returns the raw returned data. To convert to the expected return value,
1187      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1188      *
1189      * Requirements:
1190      *
1191      * - `target` must be a contract.
1192      * - calling `target` with `data` must not revert.
1193      *
1194      * _Available since v3.1._
1195      */
1196     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1197       return functionCall(target, data, "Address: low-level call failed");
1198     }
1199 
1200     /**
1201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1202      * `errorMessage` as a fallback revert reason when `target` reverts.
1203      *
1204      * _Available since v3.1._
1205      */
1206     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1207         return functionCallWithValue(target, data, 0, errorMessage);
1208     }
1209 
1210     /**
1211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1212      * but also transferring `value` wei to `target`.
1213      *
1214      * Requirements:
1215      *
1216      * - the calling contract must have an ETH balance of at least `value`.
1217      * - the called Solidity function must be `payable`.
1218      *
1219      * _Available since v3.1._
1220      */
1221     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1223     }
1224 
1225     /**
1226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1227      * with `errorMessage` as a fallback revert reason when `target` reverts.
1228      *
1229      * _Available since v3.1._
1230      */
1231     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1232         require(address(this).balance >= value, "Address: insufficient balance for call");
1233         require(isContract(target), "Address: call to non-contract");
1234 
1235         // solhint-disable-next-line avoid-low-level-calls
1236         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1237         return _verifyCallResult(success, returndata, errorMessage);
1238     }
1239 
1240     /**
1241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1242      * but performing a static call.
1243      *
1244      * _Available since v3.3._
1245      */
1246     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1247         return functionStaticCall(target, data, "Address: low-level static call failed");
1248     }
1249 
1250     /**
1251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1252      * but performing a static call.
1253      *
1254      * _Available since v3.3._
1255      */
1256     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1257         require(isContract(target), "Address: static call to non-contract");
1258 
1259         // solhint-disable-next-line avoid-low-level-calls
1260         (bool success, bytes memory returndata) = target.staticcall(data);
1261         return _verifyCallResult(success, returndata, errorMessage);
1262     }
1263 
1264     /**
1265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1266      * but performing a delegate call.
1267      *
1268      * _Available since v3.4._
1269      */
1270     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1271         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1272     }
1273 
1274     /**
1275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1276      * but performing a delegate call.
1277      *
1278      * _Available since v3.4._
1279      */
1280     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1281         require(isContract(target), "Address: delegate call to non-contract");
1282 
1283         // solhint-disable-next-line avoid-low-level-calls
1284         (bool success, bytes memory returndata) = target.delegatecall(data);
1285         return _verifyCallResult(success, returndata, errorMessage);
1286     }
1287 
1288     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1289         if (success) {
1290             return returndata;
1291         } else {
1292             // Look for revert reason and bubble it up if present
1293             if (returndata.length > 0) {
1294                 // The easiest way to bubble the revert reason is using memory via assembly
1295 
1296                 // solhint-disable-next-line no-inline-assembly
1297                 assembly {
1298                     let returndata_size := mload(returndata)
1299                     revert(add(32, returndata), returndata_size)
1300                 }
1301             } else {
1302                 revert(errorMessage);
1303             }
1304         }
1305     }
1306 }
1307 
1308 
1309 // File @openzeppelin/contracts/access/AccessControl.sol@v3.4.1
1310 
1311 pragma solidity >=0.6.0 <0.8.0;
1312 
1313 
1314 
1315 /**
1316  * @dev Contract module that allows children to implement role-based access
1317  * control mechanisms.
1318  *
1319  * Roles are referred to by their `bytes32` identifier. These should be exposed
1320  * in the external API and be unique. The best way to achieve this is by
1321  * using `public constant` hash digests:
1322  *
1323  * ```
1324  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1325  * ```
1326  *
1327  * Roles can be used to represent a set of permissions. To restrict access to a
1328  * function call, use {hasRole}:
1329  *
1330  * ```
1331  * function foo() public {
1332  *     require(hasRole(MY_ROLE, msg.sender));
1333  *     ...
1334  * }
1335  * ```
1336  *
1337  * Roles can be granted and revoked dynamically via the {grantRole} and
1338  * {revokeRole} functions. Each role has an associated admin role, and only
1339  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1340  *
1341  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1342  * that only accounts with this role will be able to grant or revoke other
1343  * roles. More complex role relationships can be created by using
1344  * {_setRoleAdmin}.
1345  *
1346  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1347  * grant and revoke this role. Extra precautions should be taken to secure
1348  * accounts that have been granted it.
1349  */
1350 abstract contract AccessControl is Context {
1351     using EnumerableSet for EnumerableSet.AddressSet;
1352     using Address for address;
1353 
1354     struct RoleData {
1355         EnumerableSet.AddressSet members;
1356         bytes32 adminRole;
1357     }
1358 
1359     mapping (bytes32 => RoleData) private _roles;
1360 
1361     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1362 
1363     /**
1364      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1365      *
1366      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1367      * {RoleAdminChanged} not being emitted signaling this.
1368      *
1369      * _Available since v3.1._
1370      */
1371     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1372 
1373     /**
1374      * @dev Emitted when `account` is granted `role`.
1375      *
1376      * `sender` is the account that originated the contract call, an admin role
1377      * bearer except when using {_setupRole}.
1378      */
1379     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1380 
1381     /**
1382      * @dev Emitted when `account` is revoked `role`.
1383      *
1384      * `sender` is the account that originated the contract call:
1385      *   - if using `revokeRole`, it is the admin role bearer
1386      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1387      */
1388     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1389 
1390     /**
1391      * @dev Returns `true` if `account` has been granted `role`.
1392      */
1393     function hasRole(bytes32 role, address account) public view returns (bool) {
1394         return _roles[role].members.contains(account);
1395     }
1396 
1397     /**
1398      * @dev Returns the number of accounts that have `role`. Can be used
1399      * together with {getRoleMember} to enumerate all bearers of a role.
1400      */
1401     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1402         return _roles[role].members.length();
1403     }
1404 
1405     /**
1406      * @dev Returns one of the accounts that have `role`. `index` must be a
1407      * value between 0 and {getRoleMemberCount}, non-inclusive.
1408      *
1409      * Role bearers are not sorted in any particular way, and their ordering may
1410      * change at any point.
1411      *
1412      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1413      * you perform all queries on the same block. See the following
1414      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1415      * for more information.
1416      */
1417     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1418         return _roles[role].members.at(index);
1419     }
1420 
1421     /**
1422      * @dev Returns the admin role that controls `role`. See {grantRole} and
1423      * {revokeRole}.
1424      *
1425      * To change a role's admin, use {_setRoleAdmin}.
1426      */
1427     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1428         return _roles[role].adminRole;
1429     }
1430 
1431     /**
1432      * @dev Grants `role` to `account`.
1433      *
1434      * If `account` had not been already granted `role`, emits a {RoleGranted}
1435      * event.
1436      *
1437      * Requirements:
1438      *
1439      * - the caller must have ``role``'s admin role.
1440      */
1441     function grantRole(bytes32 role, address account) public virtual {
1442         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1443 
1444         _grantRole(role, account);
1445     }
1446 
1447     /**
1448      * @dev Revokes `role` from `account`.
1449      *
1450      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1451      *
1452      * Requirements:
1453      *
1454      * - the caller must have ``role``'s admin role.
1455      */
1456     function revokeRole(bytes32 role, address account) public virtual {
1457         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1458 
1459         _revokeRole(role, account);
1460     }
1461 
1462     /**
1463      * @dev Revokes `role` from the calling account.
1464      *
1465      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1466      * purpose is to provide a mechanism for accounts to lose their privileges
1467      * if they are compromised (such as when a trusted device is misplaced).
1468      *
1469      * If the calling account had been granted `role`, emits a {RoleRevoked}
1470      * event.
1471      *
1472      * Requirements:
1473      *
1474      * - the caller must be `account`.
1475      */
1476     function renounceRole(bytes32 role, address account) public virtual {
1477         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1478 
1479         _revokeRole(role, account);
1480     }
1481 
1482     /**
1483      * @dev Grants `role` to `account`.
1484      *
1485      * If `account` had not been already granted `role`, emits a {RoleGranted}
1486      * event. Note that unlike {grantRole}, this function doesn't perform any
1487      * checks on the calling account.
1488      *
1489      * [WARNING]
1490      * ====
1491      * This function should only be called from the constructor when setting
1492      * up the initial roles for the system.
1493      *
1494      * Using this function in any other way is effectively circumventing the admin
1495      * system imposed by {AccessControl}.
1496      * ====
1497      */
1498     function _setupRole(bytes32 role, address account) internal virtual {
1499         _grantRole(role, account);
1500     }
1501 
1502     /**
1503      * @dev Sets `adminRole` as ``role``'s admin role.
1504      *
1505      * Emits a {RoleAdminChanged} event.
1506      */
1507     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1508         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1509         _roles[role].adminRole = adminRole;
1510     }
1511 
1512     function _grantRole(bytes32 role, address account) private {
1513         if (_roles[role].members.add(account)) {
1514             emit RoleGranted(role, account, _msgSender());
1515         }
1516     }
1517 
1518     function _revokeRole(bytes32 role, address account) private {
1519         if (_roles[role].members.remove(account)) {
1520             emit RoleRevoked(role, account, _msgSender());
1521         }
1522     }
1523 }
1524 
1525 
1526 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.1
1527 
1528 pragma solidity >=0.6.0 <0.8.0;
1529 
1530 
1531 /**
1532  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1533  * tokens and those that they have an allowance for, in a way that can be
1534  * recognized off-chain (via event analysis).
1535  */
1536 abstract contract ERC20Burnable is Context, ERC20 {
1537     using SafeMath for uint256;
1538 
1539     /**
1540      * @dev Destroys `amount` tokens from the caller.
1541      *
1542      * See {ERC20-_burn}.
1543      */
1544     function burn(uint256 amount) public virtual {
1545         _burn(_msgSender(), amount);
1546     }
1547 
1548     /**
1549      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1550      * allowance.
1551      *
1552      * See {ERC20-_burn} and {ERC20-allowance}.
1553      *
1554      * Requirements:
1555      *
1556      * - the caller must have allowance for ``accounts``'s tokens of at least
1557      * `amount`.
1558      */
1559     function burnFrom(address account, uint256 amount) public virtual {
1560         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
1561 
1562         _approve(account, _msgSender(), decreasedAllowance);
1563         _burn(account, amount);
1564     }
1565 }
1566 
1567 
1568 // File @openzeppelin/contracts/presets/ERC20PresetMinterPauser.sol@v3.4.1
1569 
1570 pragma solidity >=0.6.0 <0.8.0;
1571 
1572 
1573 
1574 
1575 
1576 /**
1577  * @dev {ERC20} token, including:
1578  *
1579  *  - ability for holders to burn (destroy) their tokens
1580  *  - a minter role that allows for token minting (creation)
1581  *  - a pauser role that allows to stop all token transfers
1582  *
1583  * This contract uses {AccessControl} to lock permissioned functions using the
1584  * different roles - head to its documentation for details.
1585  *
1586  * The account that deploys the contract will be granted the minter and pauser
1587  * roles, as well as the default admin role, which will let it grant both minter
1588  * and pauser roles to other accounts.
1589  */
1590 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1591     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1592     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1593 
1594     /**
1595      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1596      * account that deploys the contract.
1597      *
1598      * See {ERC20-constructor}.
1599      */
1600     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1601         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1602 
1603         _setupRole(MINTER_ROLE, _msgSender());
1604         _setupRole(PAUSER_ROLE, _msgSender());
1605     }
1606 
1607     /**
1608      * @dev Creates `amount` new tokens for `to`.
1609      *
1610      * See {ERC20-_mint}.
1611      *
1612      * Requirements:
1613      *
1614      * - the caller must have the `MINTER_ROLE`.
1615      */
1616     function mint(address to, uint256 amount) public virtual {
1617         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1618         _mint(to, amount);
1619     }
1620 
1621     /**
1622      * @dev Pauses all token transfers.
1623      *
1624      * See {ERC20Pausable} and {Pausable-_pause}.
1625      *
1626      * Requirements:
1627      *
1628      * - the caller must have the `PAUSER_ROLE`.
1629      */
1630     function pause() public virtual {
1631         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1632         _pause();
1633     }
1634 
1635     /**
1636      * @dev Unpauses all token transfers.
1637      *
1638      * See {ERC20Pausable} and {Pausable-_unpause}.
1639      *
1640      * Requirements:
1641      *
1642      * - the caller must have the `PAUSER_ROLE`.
1643      */
1644     function unpause() public virtual {
1645         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1646         _unpause();
1647     }
1648 
1649     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1650         super._beforeTokenTransfer(from, to, amount);
1651     }
1652 }
1653 
1654 
1655 // File contracts/CentralexToken.sol
1656 
1657 pragma solidity 0.7.0;
1658 
1659 
1660 
1661 
1662 
1663 contract CentralexToken is ERC20, ERC20Pausable, Ownable {
1664 
1665     constructor() ERC20("Centralex Token", "CenX") {
1666         _mint(msg.sender, 5 * 1e8 ether);
1667     }
1668 
1669     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1670         super._beforeTokenTransfer(from, to, amount);
1671     }
1672 
1673     /**
1674      * @dev Pauses all token transfers.
1675      *
1676      * See {ERC20Pausable} and {Pausable-_pause}.
1677      *
1678      */
1679     function pause() external onlyOwner {
1680         _pause();
1681     }
1682 
1683     /**
1684      * @dev Unpauses all token transfers.
1685      *
1686      * See {ERC20Pausable} and {Pausable-_unpause}.
1687      *
1688      */
1689     function unpause() external onlyOwner {
1690         _unpause();
1691     }
1692 }
