1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
30 
31 
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
110 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
111 
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
328 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2
329 
330 
331 
332 pragma solidity >=0.6.0 <0.8.0;
333 
334 
335 
336 /**
337  * @dev Implementation of the {IERC20} interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using {_mint}.
341  * For a generic mechanism see {ERC20PresetMinterPauser}.
342  *
343  * TIP: For a detailed writeup see our guide
344  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
345  * to implement supply mechanisms].
346  *
347  * We have followed general OpenZeppelin guidelines: functions revert instead
348  * of returning `false` on failure. This behavior is nonetheless conventional
349  * and does not conflict with the expectations of ERC20 applications.
350  *
351  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
352  * This allows applications to reconstruct the allowance for all accounts just
353  * by listening to said events. Other implementations of the EIP may not emit
354  * these events, as it isn't required by the specification.
355  *
356  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
357  * functions have been added to mitigate the well-known issues around setting
358  * allowances. See {IERC20-approve}.
359  */
360 contract ERC20 is Context, IERC20 {
361     using SafeMath for uint256;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     string private _name;
370     string private _symbol;
371     uint8 private _decimals;
372 
373     /**
374      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
375      * a default value of 18.
376      *
377      * To select a different value for {decimals}, use {_setupDecimals}.
378      *
379      * All three of these values are immutable: they can only be set once during
380      * construction.
381      */
382     constructor (string memory name_, string memory symbol_) public {
383         _name = name_;
384         _symbol = symbol_;
385         _decimals = 18;
386     }
387 
388     /**
389      * @dev Returns the name of the token.
390      */
391     function name() public view virtual returns (string memory) {
392         return _name;
393     }
394 
395     /**
396      * @dev Returns the symbol of the token, usually a shorter version of the
397      * name.
398      */
399     function symbol() public view virtual returns (string memory) {
400         return _symbol;
401     }
402 
403     /**
404      * @dev Returns the number of decimals used to get its user representation.
405      * For example, if `decimals` equals `2`, a balance of `505` tokens should
406      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
407      *
408      * Tokens usually opt for a value of 18, imitating the relationship between
409      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
410      * called.
411      *
412      * NOTE: This information is only used for _display_ purposes: it in
413      * no way affects any of the arithmetic of the contract, including
414      * {IERC20-balanceOf} and {IERC20-transfer}.
415      */
416     function decimals() public view virtual returns (uint8) {
417         return _decimals;
418     }
419 
420     /**
421      * @dev See {IERC20-totalSupply}.
422      */
423     function totalSupply() public view virtual override returns (uint256) {
424         return _totalSupply;
425     }
426 
427     /**
428      * @dev See {IERC20-balanceOf}.
429      */
430     function balanceOf(address account) public view virtual override returns (uint256) {
431         return _balances[account];
432     }
433 
434     /**
435      * @dev See {IERC20-transfer}.
436      *
437      * Requirements:
438      *
439      * - `recipient` cannot be the zero address.
440      * - the caller must have a balance of at least `amount`.
441      */
442     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
443         _transfer(_msgSender(), recipient, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-allowance}.
449      */
450     function allowance(address owner, address spender) public view virtual override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     /**
455      * @dev See {IERC20-approve}.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(address spender, uint256 amount) public virtual override returns (bool) {
462         _approve(_msgSender(), spender, amount);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-transferFrom}.
468      *
469      * Emits an {Approval} event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of {ERC20}.
471      *
472      * Requirements:
473      *
474      * - `sender` and `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      * - the caller must have allowance for ``sender``'s tokens of at least
477      * `amount`.
478      */
479     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
480         _transfer(sender, recipient, amount);
481         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically increases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      */
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
499         return true;
500     }
501 
502     /**
503      * @dev Atomically decreases the allowance granted to `spender` by the caller.
504      *
505      * This is an alternative to {approve} that can be used as a mitigation for
506      * problems described in {IERC20-approve}.
507      *
508      * Emits an {Approval} event indicating the updated allowance.
509      *
510      * Requirements:
511      *
512      * - `spender` cannot be the zero address.
513      * - `spender` must have allowance for the caller of at least
514      * `subtractedValue`.
515      */
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520 
521     /**
522      * @dev Moves tokens `amount` from `sender` to `recipient`.
523      *
524      * This is internal function is equivalent to {transfer}, and can be used to
525      * e.g. implement automatic token fees, slashing mechanisms, etc.
526      *
527      * Emits a {Transfer} event.
528      *
529      * Requirements:
530      *
531      * - `sender` cannot be the zero address.
532      * - `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      */
535     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
536         require(sender != address(0), "ERC20: transfer from the zero address");
537         require(recipient != address(0), "ERC20: transfer to the zero address");
538 
539         _beforeTokenTransfer(sender, recipient, amount);
540 
541         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
542         _balances[recipient] = _balances[recipient].add(amount);
543         emit Transfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `to` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _beforeTokenTransfer(address(0), account, amount);
559 
560         _totalSupply = _totalSupply.add(amount);
561         _balances[account] = _balances[account].add(amount);
562         emit Transfer(address(0), account, amount);
563     }
564 
565     /**
566      * @dev Destroys `amount` tokens from `account`, reducing the
567      * total supply.
568      *
569      * Emits a {Transfer} event with `to` set to the zero address.
570      *
571      * Requirements:
572      *
573      * - `account` cannot be the zero address.
574      * - `account` must have at least `amount` tokens.
575      */
576     function _burn(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: burn from the zero address");
578 
579         _beforeTokenTransfer(account, address(0), amount);
580 
581         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
582         _totalSupply = _totalSupply.sub(amount);
583         emit Transfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
588      *
589      * This internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(address owner, address spender, uint256 amount) internal virtual {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     /**
608      * @dev Sets {decimals} to a value other than the default one of 18.
609      *
610      * WARNING: This function should only be called from the constructor. Most
611      * applications that interact with token contracts will not expect
612      * {decimals} to ever change, and may work incorrectly if it does.
613      */
614     function _setupDecimals(uint8 decimals_) internal virtual {
615         _decimals = decimals_;
616     }
617 
618     /**
619      * @dev Hook that is called before any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * will be to transferred to `to`.
626      * - when `from` is zero, `amount` tokens will be minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
633 }
634 
635 
636 // File @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol@v3.4.2
637 
638 
639 
640 pragma solidity >=0.6.0 <0.8.0;
641 
642 
643 /**
644  * @dev Extension of {ERC20} that allows token holders to destroy both their own
645  * tokens and those that they have an allowance for, in a way that can be
646  * recognized off-chain (via event analysis).
647  */
648 abstract contract ERC20Burnable is Context, ERC20 {
649     using SafeMath for uint256;
650 
651     /**
652      * @dev Destroys `amount` tokens from the caller.
653      *
654      * See {ERC20-_burn}.
655      */
656     function burn(uint256 amount) public virtual {
657         _burn(_msgSender(), amount);
658     }
659 
660     /**
661      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
662      * allowance.
663      *
664      * See {ERC20-_burn} and {ERC20-allowance}.
665      *
666      * Requirements:
667      *
668      * - the caller must have allowance for ``accounts``'s tokens of at least
669      * `amount`.
670      */
671     function burnFrom(address account, uint256 amount) public virtual {
672         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
673 
674         _approve(account, _msgSender(), decreasedAllowance);
675         _burn(account, amount);
676     }
677 }
678 
679 
680 // File @openzeppelin/contracts/math/Math.sol@v3.4.2
681 
682 
683 
684 pragma solidity >=0.6.0 <0.8.0;
685 
686 /**
687  * @dev Standard math utilities missing in the Solidity language.
688  */
689 library Math {
690     /**
691      * @dev Returns the largest of two numbers.
692      */
693     function max(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a >= b ? a : b;
695     }
696 
697     /**
698      * @dev Returns the smallest of two numbers.
699      */
700     function min(uint256 a, uint256 b) internal pure returns (uint256) {
701         return a < b ? a : b;
702     }
703 
704     /**
705      * @dev Returns the average of two numbers. The result is rounded towards
706      * zero.
707      */
708     function average(uint256 a, uint256 b) internal pure returns (uint256) {
709         // (a + b) / 2 can overflow, so we distribute
710         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
711     }
712 }
713 
714 
715 // File contracts/lib/SafeMath8.sol
716 
717 
718 
719 pragma solidity 0.6.12;
720 
721 /**
722  * @dev Wrappers over Solidity's arithmetic operations with added overflow
723  * checks.
724  *
725  * Arithmetic operations in Solidity wrap on overflow. This can easily result
726  * in bugs, because programmers usually assume that an overflow raises an
727  * error, which is the standard behavior in high level programming languages.
728  * `SafeMath` restores this intuition by reverting the transaction when an
729  * operation overflows.
730  *
731  * Using this library instead of the unchecked operations eliminates an entire
732  * class of bugs, so it's recommended to use it always.
733  */
734 library SafeMath8 {
735     /**
736      * @dev Returns the addition of two unsigned integers, reverting on
737      * overflow.
738      *
739      * Counterpart to Solidity's `+` operator.
740      *
741      * Requirements:
742      *
743      * - Addition cannot overflow.
744      */
745     function add(uint8 a, uint8 b) internal pure returns (uint8) {
746         uint8 c = a + b;
747         require(c >= a, "SafeMath: addition overflow");
748 
749         return c;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting on
754      * overflow (when the result is negative).
755      *
756      * Counterpart to Solidity's `-` operator.
757      *
758      * Requirements:
759      *
760      * - Subtraction cannot overflow.
761      */
762     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
763         return sub(a, b, "SafeMath: subtraction overflow");
764     }
765 
766     /**
767      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
768      * overflow (when the result is negative).
769      *
770      * Counterpart to Solidity's `-` operator.
771      *
772      * Requirements:
773      *
774      * - Subtraction cannot overflow.
775      */
776     function sub(uint8 a, uint8 b, string memory errorMessage) internal pure returns (uint8) {
777         require(b <= a, errorMessage);
778         uint8 c = a - b;
779 
780         return c;
781     }
782 
783     /**
784      * @dev Returns the multiplication of two unsigned integers, reverting on
785      * overflow.
786      *
787      * Counterpart to Solidity's `*` operator.
788      *
789      * Requirements:
790      *
791      * - Multiplication cannot overflow.
792      */
793     function mul(uint8 a, uint8 b) internal pure returns (uint8) {
794         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795         // benefit is lost if 'b' is also tested.
796         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
797         if (a == 0) {
798             return 0;
799         }
800 
801         uint8 c = a * b;
802         require(c / a == b, "SafeMath: multiplication overflow");
803 
804         return c;
805     }
806 
807     /**
808      * @dev Returns the integer division of two unsigned integers. Reverts on
809      * division by zero. The result is rounded towards zero.
810      *
811      * Counterpart to Solidity's `/` operator. Note: this function uses a
812      * `revert` opcode (which leaves remaining gas untouched) while Solidity
813      * uses an invalid opcode to revert (consuming all remaining gas).
814      *
815      * Requirements:
816      *
817      * - The divisor cannot be zero.
818      */
819     function div(uint8 a, uint8 b) internal pure returns (uint8) {
820         return div(a, b, "SafeMath: division by zero");
821     }
822 
823     /**
824      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
825      * division by zero. The result is rounded towards zero.
826      *
827      * Counterpart to Solidity's `/` operator. Note: this function uses a
828      * `revert` opcode (which leaves remaining gas untouched) while Solidity
829      * uses an invalid opcode to revert (consuming all remaining gas).
830      *
831      * Requirements:
832      *
833      * - The divisor cannot be zero.
834      */
835     function div(uint8 a, uint8 b, string memory errorMessage) internal pure returns (uint8) {
836         require(b > 0, errorMessage);
837         uint8 c = a / b;
838         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
839 
840         return c;
841     }
842 
843     /**
844      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
845      * Reverts when dividing by zero.
846      *
847      * Counterpart to Solidity's `%` operator. This function uses a `revert`
848      * opcode (which leaves remaining gas untouched) while Solidity uses an
849      * invalid opcode to revert (consuming all remaining gas).
850      *
851      * Requirements:
852      *
853      * - The divisor cannot be zero.
854      */
855     function mod(uint8 a, uint8 b) internal pure returns (uint8) {
856         return mod(a, b, "SafeMath: modulo by zero");
857     }
858 
859     /**
860      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
861      * Reverts with custom message when dividing by zero.
862      *
863      * Counterpart to Solidity's `%` operator. This function uses a `revert`
864      * opcode (which leaves remaining gas untouched) while Solidity uses an
865      * invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function mod(uint8 a, uint8 b, string memory errorMessage) internal pure returns (uint8) {
872         require(b != 0, errorMessage);
873         return a % b;
874     }
875 }
876 
877 
878 // File @openzeppelin/contracts/GSN/Context.sol@v3.4.2
879 
880 
881 
882 pragma solidity >=0.6.0 <0.8.0;
883 
884 
885 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
886 
887 
888 
889 pragma solidity >=0.6.0 <0.8.0;
890 
891 /**
892  * @dev Contract module which provides a basic access control mechanism, where
893  * there is an account (an owner) that can be granted exclusive access to
894  * specific functions.
895  *
896  * By default, the owner account will be the one that deploys the contract. This
897  * can later be changed with {transferOwnership}.
898  *
899  * This module is used through inheritance. It will make available the modifier
900  * `onlyOwner`, which can be applied to your functions to restrict their use to
901  * the owner.
902  */
903 abstract contract Ownable is Context {
904     address private _owner;
905 
906     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
907 
908     /**
909      * @dev Initializes the contract setting the deployer as the initial owner.
910      */
911     constructor () internal {
912         address msgSender = _msgSender();
913         _owner = msgSender;
914         emit OwnershipTransferred(address(0), msgSender);
915     }
916 
917     /**
918      * @dev Returns the address of the current owner.
919      */
920     function owner() public view virtual returns (address) {
921         return _owner;
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         require(owner() == _msgSender(), "Ownable: caller is not the owner");
929         _;
930     }
931 
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         emit OwnershipTransferred(_owner, address(0));
941         _owner = address(0);
942     }
943 
944     /**
945      * @dev Transfers ownership of the contract to a new account (`newOwner`).
946      * Can only be called by the current owner.
947      */
948     function transferOwnership(address newOwner) public virtual onlyOwner {
949         require(newOwner != address(0), "Ownable: new owner is the zero address");
950         emit OwnershipTransferred(_owner, newOwner);
951         _owner = newOwner;
952     }
953 }
954 
955 
956 // File contracts/owner/Operator.sol
957 
958 
959 
960 pragma solidity 0.6.12;
961 
962 
963 contract Operator is Context, Ownable {
964     address private _operator;
965 
966     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
967 
968     constructor() internal {
969         _operator = _msgSender();
970         emit OperatorTransferred(address(0), _operator);
971     }
972 
973     function operator() public view returns (address) {
974         return _operator;
975     }
976 
977     modifier onlyOperator() {
978         require(_operator == msg.sender, "operator: caller is not the operator");
979         _;
980     }
981 
982     function isOperator() public view returns (bool) {
983         return _msgSender() == _operator;
984     }
985 
986     function transferOperator(address newOperator_) public onlyOwner {
987         _transferOperator(newOperator_);
988     }
989 
990     function _transferOperator(address newOperator_) internal {
991         require(newOperator_ != address(0), "operator: zero address given for new operator");
992         emit OperatorTransferred(address(0), newOperator_);
993         _operator = newOperator_;
994     }
995 }
996 
997 
998 // File contracts/interfaces/IOracle.sol
999 
1000 
1001 
1002 pragma solidity 0.6.12;
1003 
1004 interface IOracle {
1005     function update() external;
1006 
1007     function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);
1008 
1009     function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
1010 }
1011 
1012 
1013 contract Gldm is ERC20Burnable, Operator {
1014     using SafeMath8 for uint8;
1015     using SafeMath for uint256;
1016 
1017     // Initial distribution for the first 96h genesis pools
1018     uint256 public constant INITIAL_GENESIS_POOL_DISTRIBUTION = 2500 ether;
1019     
1020     // Have the rewards been distributed to the pools
1021     bool public rewardPoolDistributed = false;
1022 
1023     /* ================= Taxation =============== */
1024     // Address of the Oracle
1025     address public gldmOracle;
1026     // Address of the Tax Office
1027     address public taxOffice;
1028 
1029     // Current tax rate
1030     uint256 public taxRate;
1031     // Price threshold below which taxes will get burned
1032     uint256 public burnThreshold = 1.10e18;
1033     // Address of the tax collector wallet
1034     address public taxCollectorAddress;
1035 
1036     // Should the taxes be calculated using the tax tiers
1037     bool public autoCalculateTax;
1038 
1039     // Tax Tiers
1040     uint256[] public taxTiersTwaps = [0, 5e17, 6e17, 7e17, 8e17, 9e17, 9.5e17, 1e18, 1.05e18, 1.10e18, 1.20e18, 1.30e18, 1.40e18, 1.50e18];
1041     uint256[] public taxTiersRates = [2000, 1900, 1800, 1700, 1600, 1500, 1500, 1500, 1500, 1400, 900, 400, 200, 100];
1042 
1043     // Sender addresses excluded from Tax
1044     mapping(address => bool) public excludedAddresses;
1045 
1046     event TaxOfficeTransferred(address oldAddress, address newAddress);
1047 
1048     modifier onlyTaxOffice() {
1049         require(taxOffice == msg.sender, "Caller is not the tax office");
1050         _;
1051     }
1052 
1053     modifier onlyOperatorOrTaxOffice() {
1054         require(isOperator() || taxOffice == msg.sender, "Caller is not the operator or the tax office");
1055         _;
1056     }
1057 
1058     /**
1059      * @notice Constructs the GLDM ERC-20 contract.
1060      */
1061     constructor(uint256 _taxRate, address _taxCollectorAddress) public ERC20("GoldMint", "GLDM") {
1062         // Mints 1 GLDM to contract creator for initial pool setup
1063         require(_taxRate < 10000, "tax equal or bigger to 100%");
1064         require(_taxCollectorAddress != address(0), "tax collector address must be non-zero address");
1065 
1066         excludeAddress(address(this));
1067 
1068         _mint(msg.sender, 1 ether);
1069         taxRate = _taxRate;
1070         taxCollectorAddress = _taxCollectorAddress;
1071     }
1072 
1073     /* ============= Taxation ============= */
1074 
1075     function getTaxTiersTwapsCount() public view returns (uint256 count) {
1076         return taxTiersTwaps.length;
1077     }
1078 
1079     function getTaxTiersRatesCount() public view returns (uint256 count) {
1080         return taxTiersRates.length;
1081     }
1082 
1083     function isAddressExcluded(address _address) public view returns (bool) {
1084         return excludedAddresses[_address];
1085     }
1086 
1087     function setTaxTiersTwap(uint8 _index, uint256 _value) public onlyTaxOffice returns (bool) {
1088         require(_index >= 0, "Index has to be higher than 0");
1089         require(_index < getTaxTiersTwapsCount(), "Index has to lower than count of tax tiers");
1090         if (_index > 0) {
1091             require(_value > taxTiersTwaps[_index - 1]);
1092         }
1093         if (_index < getTaxTiersTwapsCount().sub(1)) {
1094             require(_value < taxTiersTwaps[_index + 1]);
1095         }
1096         taxTiersTwaps[_index] = _value;
1097         return true;
1098     }
1099 
1100     function setTaxTiersRate(uint8 _index, uint256 _value) public onlyTaxOffice returns (bool) {
1101         require(_index >= 0, "Index has to be higher than 0");
1102         require(_index < getTaxTiersRatesCount(), "Index has to lower than count of tax tiers");
1103         taxTiersRates[_index] = _value;
1104         return true;
1105     }
1106 
1107     function setBurnThreshold(uint256 _burnThreshold) public onlyTaxOffice returns (bool) {
1108         burnThreshold = _burnThreshold;
1109     }
1110 
1111     function _getGldmPrice() internal view returns (uint256 _gldmPrice) {
1112         try IOracle(gldmOracle).consult(address(this), 1e18) returns (uint144 _price) {
1113             return uint256(_price);
1114         } catch {
1115             revert("Gldm: failed to fetch GLDM price from Oracle");
1116         }
1117     }
1118 
1119     function _updateTaxRate(uint256 _gldmPrice) internal returns (uint256) {
1120         if (autoCalculateTax) {
1121             for (uint8 tierId = uint8(getTaxTiersTwapsCount()).sub(1); tierId >= 0; --tierId) {
1122                 if (_gldmPrice >= taxTiersTwaps[tierId]) {
1123                     require(taxTiersRates[tierId] < 10000, "tax equal or bigger to 100%");
1124                     taxRate = taxTiersRates[tierId];
1125                     return taxTiersRates[tierId];
1126                 }
1127             }
1128         }
1129     }
1130 
1131     function enableAutoCalculateTax() public onlyTaxOffice {
1132         autoCalculateTax = true;
1133     }
1134 
1135     function disableAutoCalculateTax() public onlyTaxOffice {
1136         autoCalculateTax = false;
1137     }
1138 
1139     function setGldmOracle(address _gldmOracle) public onlyOperatorOrTaxOffice {
1140         require(_gldmOracle != address(0), "oracle address cannot be 0 address");
1141         gldmOracle = _gldmOracle;
1142     }
1143 
1144     function setTaxOffice(address _taxOffice) public onlyOperatorOrTaxOffice {
1145         require(_taxOffice != address(0), "tax office address cannot be 0 address");
1146         emit TaxOfficeTransferred(taxOffice, _taxOffice);
1147         taxOffice = _taxOffice;
1148     }
1149 
1150     function setTaxCollectorAddress(address _taxCollectorAddress) public onlyTaxOffice {
1151         require(_taxCollectorAddress != address(0), "tax collector address must be non-zero address");
1152         taxCollectorAddress = _taxCollectorAddress;
1153     }
1154 
1155     function setTaxRate(uint256 _taxRate) public onlyTaxOffice {
1156         require(!autoCalculateTax, "auto calculate tax cannot be enabled");
1157         require(_taxRate < 10000, "tax equal or bigger to 100%");
1158         taxRate = _taxRate;
1159     }
1160 
1161     function excludeAddress(address _address) public onlyOperatorOrTaxOffice returns (bool) {
1162         require(!excludedAddresses[_address], "address can't be excluded");
1163         excludedAddresses[_address] = true;
1164         return true;
1165     }
1166 
1167     function includeAddress(address _address) public onlyOperatorOrTaxOffice returns (bool) {
1168         require(excludedAddresses[_address], "address can't be included");
1169         excludedAddresses[_address] = false;
1170         return true;
1171     }
1172 
1173     /**
1174      * @notice Operator mints GLDM to a recipient
1175      * @param recipient_ The address of recipient
1176      * @param amount_ The amount of GLDM to mint to
1177      * @return whether the process has been done
1178      */
1179     function mint(address recipient_, uint256 amount_) public onlyOperator returns (bool) {
1180         uint256 balanceBefore = balanceOf(recipient_);
1181         _mint(recipient_, amount_);
1182         uint256 balanceAfter = balanceOf(recipient_);
1183 
1184         return balanceAfter > balanceBefore;
1185     }
1186 
1187     function burn(uint256 amount) public override {
1188         super.burn(amount);
1189     }
1190 
1191     function burnFrom(address account, uint256 amount) public override onlyOperator {
1192         super.burnFrom(account, amount);
1193     }
1194 
1195     function transferFrom(
1196         address sender,
1197         address recipient,
1198         uint256 amount
1199     ) public override returns (bool) {
1200         uint256 currentTaxRate = 0;
1201         bool burnTax = false;
1202 
1203         if (autoCalculateTax) {
1204             uint256 currentGldmPrice = _getGldmPrice();
1205             currentTaxRate = _updateTaxRate(currentGldmPrice);
1206             if (currentGldmPrice < burnThreshold) {
1207                 burnTax = true;
1208             }
1209         }
1210 
1211         if (currentTaxRate == 0 || excludedAddresses[sender]) {
1212             _transfer(sender, recipient, amount);
1213         } else {
1214             _transferWithTax(sender, recipient, amount, burnTax);
1215         }
1216 
1217         _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "ERC20: transfer amount exceeds allowance"));
1218         return true;
1219     }
1220 
1221     function _transferWithTax(
1222         address sender,
1223         address recipient,
1224         uint256 amount,
1225         bool burnTax
1226     ) internal returns (bool) {
1227         uint256 taxAmount = amount.mul(taxRate).div(10000);
1228         uint256 amountAfterTax = amount.sub(taxAmount);
1229 
1230         if (burnTax) {
1231             // Burn tax
1232             super.burnFrom(sender, taxAmount);
1233         } else {
1234             // Transfer tax to tax collector
1235             _transfer(sender, taxCollectorAddress, taxAmount);
1236         }
1237 
1238         // Transfer amount after tax to recipient
1239         _transfer(sender, recipient, amountAfterTax);
1240 
1241         return true;
1242     }
1243 
1244     /**
1245      * @notice distribute to reward pool (only once)
1246      */
1247     function distributeReward(
1248         address _genesisPool
1249     ) external onlyOperator {
1250         require(!rewardPoolDistributed, "only can distribute once");
1251         require(_genesisPool != address(0), "!_genesisPool");
1252         rewardPoolDistributed = true;
1253         _mint(_genesisPool, INITIAL_GENESIS_POOL_DISTRIBUTION);
1254    }
1255 
1256     function governanceRecoverUnsupported(
1257         IERC20 _token,
1258         uint256 _amount,
1259         address _to
1260     ) external onlyOperator {
1261         _token.transfer(_to, _amount);
1262     }
1263 }