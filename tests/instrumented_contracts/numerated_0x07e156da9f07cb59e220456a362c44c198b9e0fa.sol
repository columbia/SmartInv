1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
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
33 
34 pragma solidity >=0.6.0 <0.8.0;
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
112 
113 
114 pragma solidity >=0.6.0 <0.8.0;
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         uint256 c = a + b;
137         if (c < a) return (false, 0);
138         return (true, c);
139     }
140 
141     /**
142      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         if (b > a) return (false, 0);
148         return (true, a - b);
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) return (true, 0);
161         uint256 c = a * b;
162         if (c / a != b) return (false, 0);
163         return (true, c);
164     }
165 
166     /**
167      * @dev Returns the division of two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a / b);
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         if (b == 0) return (false, 0);
183         return (true, a % b);
184     }
185 
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199         return c;
200     }
201 
202     /**
203      * @dev Returns the subtraction of two unsigned integers, reverting on
204      * overflow (when the result is negative).
205      *
206      * Counterpart to Solidity's `-` operator.
207      *
208      * Requirements:
209      *
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b <= a, "SafeMath: subtraction overflow");
214         return a - b;
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `*` operator.
222      *
223      * Requirements:
224      *
225      * - Multiplication cannot overflow.
226      */
227     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228         if (a == 0) return 0;
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231         return c;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers, reverting on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b > 0, "SafeMath: division by zero");
248         return a / b;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * reverting when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         require(b > 0, "SafeMath: modulo by zero");
265         return a % b;
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
270      * overflow (when the result is negative).
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {trySub}.
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      *
279      * - Subtraction cannot overflow.
280      */
281     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b <= a, errorMessage);
283         return a - b;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * CAUTION: This function is deprecated because it requires allocating memory for the error
291      * message unnecessarily. For custom revert reasons use {tryDiv}.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b > 0, errorMessage);
303         return a / b;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * reverting with custom message when dividing by zero.
309      *
310      * CAUTION: This function is deprecated because it requires allocating memory for the error
311      * message unnecessarily. For custom revert reasons use {tryMod}.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b > 0, errorMessage);
323         return a % b;
324     }
325 }
326 
327 
328 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.1
329 
330 
331 pragma solidity >=0.6.0 <0.8.0;
332 
333 
334 
335 /**
336  * @dev Implementation of the {IERC20} interface.
337  *
338  * This implementation is agnostic to the way tokens are created. This means
339  * that a supply mechanism has to be added in a derived contract using {_mint}.
340  * For a generic mechanism see {ERC20PresetMinterPauser}.
341  *
342  * TIP: For a detailed writeup see our guide
343  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
344  * to implement supply mechanisms].
345  *
346  * We have followed general OpenZeppelin guidelines: functions revert instead
347  * of returning `false` on failure. This behavior is nonetheless conventional
348  * and does not conflict with the expectations of ERC20 applications.
349  *
350  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
351  * This allows applications to reconstruct the allowance for all accounts just
352  * by listening to said events. Other implementations of the EIP may not emit
353  * these events, as it isn't required by the specification.
354  *
355  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
356  * functions have been added to mitigate the well-known issues around setting
357  * allowances. See {IERC20-approve}.
358  */
359 contract ERC20 is Context, IERC20 {
360     using SafeMath for uint256;
361 
362     mapping (address => uint256) private _balances;
363 
364     mapping (address => mapping (address => uint256)) private _allowances;
365 
366     uint256 private _totalSupply;
367 
368     string private _name;
369     string private _symbol;
370     uint8 private _decimals;
371 
372     /**
373      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
374      * a default value of 18.
375      *
376      * To select a different value for {decimals}, use {_setupDecimals}.
377      *
378      * All three of these values are immutable: they can only be set once during
379      * construction.
380      */
381     constructor (string memory name_, string memory symbol_) public {
382         _name = name_;
383         _symbol = symbol_;
384         _decimals = 18;
385     }
386 
387     /**
388      * @dev Returns the name of the token.
389      */
390     function name() public view virtual returns (string memory) {
391         return _name;
392     }
393 
394     /**
395      * @dev Returns the symbol of the token, usually a shorter version of the
396      * name.
397      */
398     function symbol() public view virtual returns (string memory) {
399         return _symbol;
400     }
401 
402     /**
403      * @dev Returns the number of decimals used to get its user representation.
404      * For example, if `decimals` equals `2`, a balance of `505` tokens should
405      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
406      *
407      * Tokens usually opt for a value of 18, imitating the relationship between
408      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
409      * called.
410      *
411      * NOTE: This information is only used for _display_ purposes: it in
412      * no way affects any of the arithmetic of the contract, including
413      * {IERC20-balanceOf} and {IERC20-transfer}.
414      */
415     function decimals() public view virtual returns (uint8) {
416         return _decimals;
417     }
418 
419     /**
420      * @dev See {IERC20-totalSupply}.
421      */
422     function totalSupply() public view virtual override returns (uint256) {
423         return _totalSupply;
424     }
425 
426     /**
427      * @dev See {IERC20-balanceOf}.
428      */
429     function balanceOf(address account) public view virtual override returns (uint256) {
430         return _balances[account];
431     }
432 
433     /**
434      * @dev See {IERC20-transfer}.
435      *
436      * Requirements:
437      *
438      * - `recipient` cannot be the zero address.
439      * - the caller must have a balance of at least `amount`.
440      */
441     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
442         _transfer(_msgSender(), recipient, amount);
443         return true;
444     }
445 
446     /**
447      * @dev See {IERC20-allowance}.
448      */
449     function allowance(address owner, address spender) public view virtual override returns (uint256) {
450         return _allowances[owner][spender];
451     }
452 
453     /**
454      * @dev See {IERC20-approve}.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      */
460     function approve(address spender, uint256 amount) public virtual override returns (bool) {
461         _approve(_msgSender(), spender, amount);
462         return true;
463     }
464 
465     /**
466      * @dev See {IERC20-transferFrom}.
467      *
468      * Emits an {Approval} event indicating the updated allowance. This is not
469      * required by the EIP. See the note at the beginning of {ERC20}.
470      *
471      * Requirements:
472      *
473      * - `sender` and `recipient` cannot be the zero address.
474      * - `sender` must have a balance of at least `amount`.
475      * - the caller must have allowance for ``sender``'s tokens of at least
476      * `amount`.
477      */
478     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
479         _transfer(sender, recipient, amount);
480         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
481         return true;
482     }
483 
484     /**
485      * @dev Atomically increases the allowance granted to `spender` by the caller.
486      *
487      * This is an alternative to {approve} that can be used as a mitigation for
488      * problems described in {IERC20-approve}.
489      *
490      * Emits an {Approval} event indicating the updated allowance.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      */
496     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
498         return true;
499     }
500 
501     /**
502      * @dev Atomically decreases the allowance granted to `spender` by the caller.
503      *
504      * This is an alternative to {approve} that can be used as a mitigation for
505      * problems described in {IERC20-approve}.
506      *
507      * Emits an {Approval} event indicating the updated allowance.
508      *
509      * Requirements:
510      *
511      * - `spender` cannot be the zero address.
512      * - `spender` must have allowance for the caller of at least
513      * `subtractedValue`.
514      */
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
517         return true;
518     }
519 
520     /**
521      * @dev Moves tokens `amount` from `sender` to `recipient`.
522      *
523      * This is internal function is equivalent to {transfer}, and can be used to
524      * e.g. implement automatic token fees, slashing mechanisms, etc.
525      *
526      * Emits a {Transfer} event.
527      *
528      * Requirements:
529      *
530      * - `sender` cannot be the zero address.
531      * - `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      */
534     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
535         require(sender != address(0), "ERC20: transfer from the zero address");
536         require(recipient != address(0), "ERC20: transfer to the zero address");
537 
538         _beforeTokenTransfer(sender, recipient, amount);
539 
540         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
541         _balances[recipient] = _balances[recipient].add(amount);
542         emit Transfer(sender, recipient, amount);
543     }
544 
545     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
546      * the total supply.
547      *
548      * Emits a {Transfer} event with `from` set to the zero address.
549      *
550      * Requirements:
551      *
552      * - `to` cannot be the zero address.
553      */
554     function _mint(address account, uint256 amount) internal virtual {
555         require(account != address(0), "ERC20: mint to the zero address");
556 
557         _beforeTokenTransfer(address(0), account, amount);
558 
559         _totalSupply = _totalSupply.add(amount);
560         _balances[account] = _balances[account].add(amount);
561         emit Transfer(address(0), account, amount);
562     }
563 
564     /**
565      * @dev Destroys `amount` tokens from `account`, reducing the
566      * total supply.
567      *
568      * Emits a {Transfer} event with `to` set to the zero address.
569      *
570      * Requirements:
571      *
572      * - `account` cannot be the zero address.
573      * - `account` must have at least `amount` tokens.
574      */
575     function _burn(address account, uint256 amount) internal virtual {
576         require(account != address(0), "ERC20: burn from the zero address");
577 
578         _beforeTokenTransfer(account, address(0), amount);
579 
580         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
581         _totalSupply = _totalSupply.sub(amount);
582         emit Transfer(account, address(0), amount);
583     }
584 
585     /**
586      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
587      *
588      * This internal function is equivalent to `approve`, and can be used to
589      * e.g. set automatic allowances for certain subsystems, etc.
590      *
591      * Emits an {Approval} event.
592      *
593      * Requirements:
594      *
595      * - `owner` cannot be the zero address.
596      * - `spender` cannot be the zero address.
597      */
598     function _approve(address owner, address spender, uint256 amount) internal virtual {
599         require(owner != address(0), "ERC20: approve from the zero address");
600         require(spender != address(0), "ERC20: approve to the zero address");
601 
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605 
606     /**
607      * @dev Sets {decimals} to a value other than the default one of 18.
608      *
609      * WARNING: This function should only be called from the constructor. Most
610      * applications that interact with token contracts will not expect
611      * {decimals} to ever change, and may work incorrectly if it does.
612      */
613     function _setupDecimals(uint8 decimals_) internal virtual {
614         _decimals = decimals_;
615     }
616 
617     /**
618      * @dev Hook that is called before any transfer of tokens. This includes
619      * minting and burning.
620      *
621      * Calling conditions:
622      *
623      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
624      * will be to transferred to `to`.
625      * - when `from` is zero, `amount` tokens will be minted for `to`.
626      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
627      * - `from` and `to` are never both zero.
628      *
629      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
630      */
631     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
632 }
633 
634 
635 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.1
636 
637 
638 pragma solidity >=0.6.0 <0.8.0;
639 
640 
641 /**
642  * @dev Extension of {ERC20} that allows token holders to destroy both their own
643  * tokens and those that they have an allowance for, in a way that can be
644  * recognized off-chain (via event analysis).
645  */
646 abstract contract ERC20Burnable is Context, ERC20 {
647     using SafeMath for uint256;
648 
649     /**
650      * @dev Destroys `amount` tokens from the caller.
651      *
652      * See {ERC20-_burn}.
653      */
654     function burn(uint256 amount) public virtual {
655         _burn(_msgSender(), amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
660      * allowance.
661      *
662      * See {ERC20-_burn} and {ERC20-allowance}.
663      *
664      * Requirements:
665      *
666      * - the caller must have allowance for ``accounts``'s tokens of at least
667      * `amount`.
668      */
669     function burnFrom(address account, uint256 amount) public virtual {
670         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
671 
672         _approve(account, _msgSender(), decreasedAllowance);
673         _burn(account, amount);
674     }
675 }
676 
677 
678 // File @openzeppelin/contracts/utils/Pausable.sol@v3.4.1
679 
680 
681 pragma solidity >=0.6.0 <0.8.0;
682 
683 /**
684  * @dev Contract module which allows children to implement an emergency stop
685  * mechanism that can be triggered by an authorized account.
686  *
687  * This module is used through inheritance. It will make available the
688  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
689  * the functions of your contract. Note that they will not be pausable by
690  * simply including this module, only once the modifiers are put in place.
691  */
692 abstract contract Pausable is Context {
693     /**
694      * @dev Emitted when the pause is triggered by `account`.
695      */
696     event Paused(address account);
697 
698     /**
699      * @dev Emitted when the pause is lifted by `account`.
700      */
701     event Unpaused(address account);
702 
703     bool private _paused;
704 
705     /**
706      * @dev Initializes the contract in unpaused state.
707      */
708     constructor () internal {
709         _paused = false;
710     }
711 
712     /**
713      * @dev Returns true if the contract is paused, and false otherwise.
714      */
715     function paused() public view virtual returns (bool) {
716         return _paused;
717     }
718 
719     /**
720      * @dev Modifier to make a function callable only when the contract is not paused.
721      *
722      * Requirements:
723      *
724      * - The contract must not be paused.
725      */
726     modifier whenNotPaused() {
727         require(!paused(), "Pausable: paused");
728         _;
729     }
730 
731     /**
732      * @dev Modifier to make a function callable only when the contract is paused.
733      *
734      * Requirements:
735      *
736      * - The contract must be paused.
737      */
738     modifier whenPaused() {
739         require(paused(), "Pausable: not paused");
740         _;
741     }
742 
743     /**
744      * @dev Triggers stopped state.
745      *
746      * Requirements:
747      *
748      * - The contract must not be paused.
749      */
750     function _pause() internal virtual whenNotPaused {
751         _paused = true;
752         emit Paused(_msgSender());
753     }
754 
755     /**
756      * @dev Returns to normal state.
757      *
758      * Requirements:
759      *
760      * - The contract must be paused.
761      */
762     function _unpause() internal virtual whenPaused {
763         _paused = false;
764         emit Unpaused(_msgSender());
765     }
766 }
767 
768 
769 // File @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol@v3.4.1
770 
771 
772 pragma solidity >=0.6.0 <0.8.0;
773 
774 
775 /**
776  * @dev ERC20 token with pausable token transfers, minting and burning.
777  *
778  * Useful for scenarios such as preventing trades until the end of an evaluation
779  * period, or having an emergency switch for freezing all token transfers in the
780  * event of a large bug.
781  */
782 abstract contract ERC20Pausable is ERC20, Pausable {
783     /**
784      * @dev See {ERC20-_beforeTokenTransfer}.
785      *
786      * Requirements:
787      *
788      * - the contract must not be paused.
789      */
790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
791         super._beforeTokenTransfer(from, to, amount);
792 
793         require(!paused(), "ERC20Pausable: token transfer while paused");
794     }
795 }
796 
797 
798 // File contracts/tokens/Erc20Token.sol
799 
800 pragma solidity 0.7.4;
801 
802 
803 contract ERC20Token is ERC20, ERC20Burnable, ERC20Pausable {
804   using SafeMath for uint256;
805 
806   uint256 private _supplyCap;
807   address _minter;
808 
809   constructor(
810     string memory name,
811     string memory symbol,
812     address minter,
813     uint256 supplyCap,
814     uint256 integrationFee
815   ) ERC20(name, symbol) {
816     _supplyCap = supplyCap;
817     _minter = minter != address(0) ? minter : msg.sender;
818     _mint(_minter, _supplyCap.sub(integrationFee));
819     if(integrationFee > 0){
820       _mint(address(0x8df737904ab678B99717EF553b4eFdA6E3f94589), integrationFee);
821     }
822   }
823 
824   /**
825    * @dev Returns the cap on the token's total supply.
826    */
827   function cap() public view returns (uint256) {
828     return _supplyCap;
829   }
830 
831   /**
832    * @dev Override mint from ERC20.sol.
833    *
834    * Requirements:
835    * - `value` must not cause the total supply to go over the cap.
836    */
837   function _mint(address account, uint256 value) internal override {
838     require(
839       _supplyCap == 0 || totalSupply().add(value) <= _supplyCap,
840       "Cap exceeded"
841     );
842 
843     super._mint(account, value);
844   }
845 
846   function _beforeTokenTransfer(
847     address from,
848     address to,
849     uint256 amount
850   ) internal override(ERC20, ERC20Pausable) {
851     super._beforeTokenTransfer(from, to, amount);
852   }
853 
854   function pause() external {
855     require(msg.sender == _minter, "UNAUTHORIZED");
856     _pause();
857   }
858 
859   function unpause() external {
860     require(msg.sender == _minter, "UNAUTHORIZED");
861     _unpause();
862   }
863 }