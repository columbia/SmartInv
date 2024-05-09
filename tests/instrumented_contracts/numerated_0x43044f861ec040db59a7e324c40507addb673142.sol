1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
28 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/Pausable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 
35 /**
36  * @dev Contract module which allows children to implement an emergency stop
37  * mechanism that can be triggered by an authorized account.
38  *
39  * This module is used through inheritance. It will make available the
40  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
41  * the functions of your contract. Note that they will not be pausable by
42  * simply including this module, only once the modifiers are put in place.
43  */
44 contract Pausable is Context {
45     /**
46      * @dev Emitted when the pause is triggered by `account`.
47      */
48     event Paused(address account);
49 
50     /**
51      * @dev Emitted when the pause is lifted by `account`.
52      */
53     event Unpaused(address account);
54 
55     bool private _paused;
56 
57     /**
58      * @dev Initializes the contract in unpaused state.
59      */
60     constructor () internal {
61         _paused = false;
62     }
63 
64     /**
65      * @dev Returns true if the contract is paused, and false otherwise.
66      */
67     function paused() public view returns (bool) {
68         return _paused;
69     }
70 
71     /**
72      * @dev Modifier to make a function callable only when the contract is not paused.
73      *
74      * Requirements:
75      *
76      * - The contract must not be paused.
77      */
78     modifier whenNotPaused() {
79         require(!_paused, "Pausable: paused");
80         _;
81     }
82 
83     /**
84      * @dev Modifier to make a function callable only when the contract is paused.
85      *
86      * Requirements:
87      *
88      * - The contract must be paused.
89      */
90     modifier whenPaused() {
91         require(_paused, "Pausable: not paused");
92         _;
93     }
94 
95     /**
96      * @dev Triggers stopped state.
97      *
98      * Requirements:
99      *
100      * - The contract must not be paused.
101      */
102     function _pause() internal virtual whenNotPaused {
103         _paused = true;
104         emit Paused(_msgSender());
105     }
106 
107     /**
108      * @dev Returns to normal state.
109      *
110      * Requirements:
111      *
112      * - The contract must be paused.
113      */
114     function _unpause() internal virtual whenPaused {
115         _paused = false;
116         emit Unpaused(_msgSender());
117     }
118 }
119 
120 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/IERC20.sol
121 
122 // SPDX-License-Identifier: MIT
123 
124 pragma solidity ^0.6.0;
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 
201 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20.sol
202 
203 // SPDX-License-Identifier: MIT
204 
205 pragma solidity ^0.6.0;
206 
207 
208 
209 
210 
211 /**
212  * @dev Implementation of the {IERC20} interface.
213  *
214  * This implementation is agnostic to the way tokens are created. This means
215  * that a supply mechanism has to be added in a derived contract using {_mint}.
216  * For a generic mechanism see {ERC20PresetMinterPauser}.
217  *
218  * TIP: For a detailed writeup see our guide
219  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
220  * to implement supply mechanisms].
221  *
222  * We have followed general OpenZeppelin guidelines: functions revert instead
223  * of returning `false` on failure. This behavior is nonetheless conventional
224  * and does not conflict with the expectations of ERC20 applications.
225  *
226  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
227  * This allows applications to reconstruct the allowance for all accounts just
228  * by listening to said events. Other implementations of the EIP may not emit
229  * these events, as it isn't required by the specification.
230  *
231  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
232  * functions have been added to mitigate the well-known issues around setting
233  * allowances. See {IERC20-approve}.
234  */
235 contract ERC20 is Context, IERC20 {
236     using SafeMath for uint256;
237     using Address for address;
238 
239     mapping (address => uint256) private _balances;
240 
241     mapping (address => mapping (address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247     uint8 private _decimals;
248 
249     /**
250      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
251      * a default value of 18.
252      *
253      * To select a different value for {decimals}, use {_setupDecimals}.
254      *
255      * All three of these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor (string memory name, string memory symbol) public {
259         _name = name;
260         _symbol = symbol;
261         _decimals = 18;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
286      * called.
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view returns (uint8) {
293         return _decimals;
294     }
295 
296     /**
297      * @dev See {IERC20-totalSupply}.
298      */
299     function totalSupply() public view override returns (uint256) {
300         return _totalSupply;
301     }
302 
303     /**
304      * @dev See {IERC20-balanceOf}.
305      */
306     function balanceOf(address account) public view override returns (uint256) {
307         return _balances[account];
308     }
309 
310     /**
311      * @dev See {IERC20-transfer}.
312      *
313      * Requirements:
314      *
315      * - `recipient` cannot be the zero address.
316      * - the caller must have a balance of at least `amount`.
317      */
318     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
319         _transfer(_msgSender(), recipient, amount);
320         return true;
321     }
322 
323     /**
324      * @dev See {IERC20-allowance}.
325      */
326     function allowance(address owner, address spender) public view virtual override returns (uint256) {
327         return _allowances[owner][spender];
328     }
329 
330     /**
331      * @dev See {IERC20-approve}.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      */
337     function approve(address spender, uint256 amount) public virtual override returns (bool) {
338         _approve(_msgSender(), spender, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-transferFrom}.
344      *
345      * Emits an {Approval} event indicating the updated allowance. This is not
346      * required by the EIP. See the note at the beginning of {ERC20};
347      *
348      * Requirements:
349      * - `sender` and `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      * - the caller must have allowance for ``sender``'s tokens of at least
352      * `amount`.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(sender, recipient, amount);
356         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
357         return true;
358     }
359 
360     /**
361      * @dev Atomically increases the allowance granted to `spender` by the caller.
362      *
363      * This is an alternative to {approve} that can be used as a mitigation for
364      * problems described in {IERC20-approve}.
365      *
366      * Emits an {Approval} event indicating the updated allowance.
367      *
368      * Requirements:
369      *
370      * - `spender` cannot be the zero address.
371      */
372     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
373         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
374         return true;
375     }
376 
377     /**
378      * @dev Atomically decreases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      * - `spender` must have allowance for the caller of at least
389      * `subtractedValue`.
390      */
391     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
393         return true;
394     }
395 
396     /**
397      * @dev Moves tokens `amount` from `sender` to `recipient`.
398      *
399      * This is internal function is equivalent to {transfer}, and can be used to
400      * e.g. implement automatic token fees, slashing mechanisms, etc.
401      *
402      * Emits a {Transfer} event.
403      *
404      * Requirements:
405      *
406      * - `sender` cannot be the zero address.
407      * - `recipient` cannot be the zero address.
408      * - `sender` must have a balance of at least `amount`.
409      */
410     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
411         require(sender != address(0), "ERC20: transfer from the zero address");
412         require(recipient != address(0), "ERC20: transfer to the zero address");
413 
414         _beforeTokenTransfer(sender, recipient, amount);
415 
416         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
417         _balances[recipient] = _balances[recipient].add(amount);
418         emit Transfer(sender, recipient, amount);
419     }
420 
421     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
422      * the total supply.
423      *
424      * Emits a {Transfer} event with `from` set to the zero address.
425      *
426      * Requirements
427      *
428      * - `to` cannot be the zero address.
429      */
430     function _mint(address account, uint256 amount) internal virtual {
431         require(account != address(0), "ERC20: mint to the zero address");
432 
433         _beforeTokenTransfer(address(0), account, amount);
434 
435         _totalSupply = _totalSupply.add(amount);
436         _balances[account] = _balances[account].add(amount);
437         emit Transfer(address(0), account, amount);
438     }
439 
440     /**
441      * @dev Destroys `amount` tokens from `account`, reducing the
442      * total supply.
443      *
444      * Emits a {Transfer} event with `to` set to the zero address.
445      *
446      * Requirements
447      *
448      * - `account` cannot be the zero address.
449      * - `account` must have at least `amount` tokens.
450      */
451     function _burn(address account, uint256 amount) internal virtual {
452         require(account != address(0), "ERC20: burn from the zero address");
453 
454         _beforeTokenTransfer(account, address(0), amount);
455 
456         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
457         _totalSupply = _totalSupply.sub(amount);
458         emit Transfer(account, address(0), amount);
459     }
460 
461     /**
462      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
463      *
464      * This is internal function is equivalent to `approve`, and can be used to
465      * e.g. set automatic allowances for certain subsystems, etc.
466      *
467      * Emits an {Approval} event.
468      *
469      * Requirements:
470      *
471      * - `owner` cannot be the zero address.
472      * - `spender` cannot be the zero address.
473      */
474     function _approve(address owner, address spender, uint256 amount) internal virtual {
475         require(owner != address(0), "ERC20: approve from the zero address");
476         require(spender != address(0), "ERC20: approve to the zero address");
477 
478         _allowances[owner][spender] = amount;
479         emit Approval(owner, spender, amount);
480     }
481 
482     /**
483      * @dev Sets {decimals} to a value other than the default one of 18.
484      *
485      * WARNING: This function should only be called from the constructor. Most
486      * applications that interact with token contracts will not expect
487      * {decimals} to ever change, and may work incorrectly if it does.
488      */
489     function _setupDecimals(uint8 decimals_) internal {
490         _decimals = decimals_;
491     }
492 
493     /**
494      * @dev Hook that is called before any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * will be to transferred to `to`.
501      * - when `from` is zero, `amount` tokens will be minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
508 }
509 
510 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20Capped.sol
511 
512 // SPDX-License-Identifier: MIT
513 
514 pragma solidity ^0.6.0;
515 
516 
517 /**
518  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
519  */
520 abstract contract ERC20Capped is ERC20 {
521     uint256 private _cap;
522 
523     /**
524      * @dev Sets the value of the `cap`. This value is immutable, it can only be
525      * set once during construction.
526      */
527     constructor (uint256 cap) public {
528         require(cap > 0, "ERC20Capped: cap is 0");
529         _cap = cap;
530     }
531 
532     /**
533      * @dev Returns the cap on the token's total supply.
534      */
535     function cap() public view returns (uint256) {
536         return _cap;
537     }
538 
539     /**
540      * @dev See {ERC20-_beforeTokenTransfer}.
541      *
542      * Requirements:
543      *
544      * - minted tokens must not cause the total supply to go over the cap.
545      */
546     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
547         super._beforeTokenTransfer(from, to, amount);
548 
549         if (from == address(0)) { // When minting tokens
550             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
551         }
552     }
553 }
554 
555 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20Pausable.sol
556 
557 // SPDX-License-Identifier: MIT
558 
559 pragma solidity ^0.6.0;
560 
561 
562 
563 /**
564  * @dev ERC20 token with pausable token transfers, minting and burning.
565  *
566  * Useful for scenarios such as preventing trades until the end of an evaluation
567  * period, or having an emergency switch for freezing all token transfers in the
568  * event of a large bug.
569  */
570 abstract contract ERC20Pausable is ERC20, Pausable {
571     /**
572      * @dev See {ERC20-_beforeTokenTransfer}.
573      *
574      * Requirements:
575      *
576      * - the contract must not be paused.
577      */
578     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
579         super._beforeTokenTransfer(from, to, amount);
580 
581         require(!paused(), "ERC20Pausable: token transfer while paused");
582     }
583 }
584 
585 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/token/ERC20/ERC20Burnable.sol
586 
587 // SPDX-License-Identifier: MIT
588 
589 pragma solidity ^0.6.0;
590 
591 
592 
593 /**
594  * @dev Extension of {ERC20} that allows token holders to destroy both their own
595  * tokens and those that they have an allowance for, in a way that can be
596  * recognized off-chain (via event analysis).
597  */
598 abstract contract ERC20Burnable is Context, ERC20 {
599     /**
600      * @dev Destroys `amount` tokens from the caller.
601      *
602      * See {ERC20-_burn}.
603      */
604     function burn(uint256 amount) public virtual {
605         _burn(_msgSender(), amount);
606     }
607 
608     /**
609      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
610      * allowance.
611      *
612      * See {ERC20-_burn} and {ERC20-allowance}.
613      *
614      * Requirements:
615      *
616      * - the caller must have allowance for ``accounts``'s tokens of at least
617      * `amount`.
618      */
619     function burnFrom(address account, uint256 amount) public virtual {
620         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
621 
622         _approve(account, _msgSender(), decreasedAllowance);
623         _burn(account, amount);
624     }
625 }
626 
627 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/math/SafeMath.sol
628 
629 // SPDX-License-Identifier: MIT
630 
631 pragma solidity ^0.6.0;
632 
633 /**
634  * @dev Wrappers over Solidity's arithmetic operations with added overflow
635  * checks.
636  *
637  * Arithmetic operations in Solidity wrap on overflow. This can easily result
638  * in bugs, because programmers usually assume that an overflow raises an
639  * error, which is the standard behavior in high level programming languages.
640  * `SafeMath` restores this intuition by reverting the transaction when an
641  * operation overflows.
642  *
643  * Using this library instead of the unchecked operations eliminates an entire
644  * class of bugs, so it's recommended to use it always.
645  */
646 library SafeMath {
647     /**
648      * @dev Returns the addition of two unsigned integers, reverting on
649      * overflow.
650      *
651      * Counterpart to Solidity's `+` operator.
652      *
653      * Requirements:
654      *
655      * - Addition cannot overflow.
656      */
657     function add(uint256 a, uint256 b) internal pure returns (uint256) {
658         uint256 c = a + b;
659         require(c >= a, "SafeMath: addition overflow");
660 
661         return c;
662     }
663 
664     /**
665      * @dev Returns the subtraction of two unsigned integers, reverting on
666      * overflow (when the result is negative).
667      *
668      * Counterpart to Solidity's `-` operator.
669      *
670      * Requirements:
671      *
672      * - Subtraction cannot overflow.
673      */
674     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
675         return sub(a, b, "SafeMath: subtraction overflow");
676     }
677 
678     /**
679      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
680      * overflow (when the result is negative).
681      *
682      * Counterpart to Solidity's `-` operator.
683      *
684      * Requirements:
685      *
686      * - Subtraction cannot overflow.
687      */
688     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
689         require(b <= a, errorMessage);
690         uint256 c = a - b;
691 
692         return c;
693     }
694 
695     /**
696      * @dev Returns the multiplication of two unsigned integers, reverting on
697      * overflow.
698      *
699      * Counterpart to Solidity's `*` operator.
700      *
701      * Requirements:
702      *
703      * - Multiplication cannot overflow.
704      */
705     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
706         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
707         // benefit is lost if 'b' is also tested.
708         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
709         if (a == 0) {
710             return 0;
711         }
712 
713         uint256 c = a * b;
714         require(c / a == b, "SafeMath: multiplication overflow");
715 
716         return c;
717     }
718 
719     /**
720      * @dev Returns the integer division of two unsigned integers. Reverts on
721      * division by zero. The result is rounded towards zero.
722      *
723      * Counterpart to Solidity's `/` operator. Note: this function uses a
724      * `revert` opcode (which leaves remaining gas untouched) while Solidity
725      * uses an invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function div(uint256 a, uint256 b) internal pure returns (uint256) {
732         return div(a, b, "SafeMath: division by zero");
733     }
734 
735     /**
736      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
737      * division by zero. The result is rounded towards zero.
738      *
739      * Counterpart to Solidity's `/` operator. Note: this function uses a
740      * `revert` opcode (which leaves remaining gas untouched) while Solidity
741      * uses an invalid opcode to revert (consuming all remaining gas).
742      *
743      * Requirements:
744      *
745      * - The divisor cannot be zero.
746      */
747     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
748         require(b > 0, errorMessage);
749         uint256 c = a / b;
750         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
751 
752         return c;
753     }
754 
755     /**
756      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
757      * Reverts when dividing by zero.
758      *
759      * Counterpart to Solidity's `%` operator. This function uses a `revert`
760      * opcode (which leaves remaining gas untouched) while Solidity uses an
761      * invalid opcode to revert (consuming all remaining gas).
762      *
763      * Requirements:
764      *
765      * - The divisor cannot be zero.
766      */
767     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
768         return mod(a, b, "SafeMath: modulo by zero");
769     }
770 
771     /**
772      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
773      * Reverts with custom message when dividing by zero.
774      *
775      * Counterpart to Solidity's `%` operator. This function uses a `revert`
776      * opcode (which leaves remaining gas untouched) while Solidity uses an
777      * invalid opcode to revert (consuming all remaining gas).
778      *
779      * Requirements:
780      *
781      * - The divisor cannot be zero.
782      */
783     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
784         require(b != 0, errorMessage);
785         return a % b;
786     }
787 }
788 
789 
790 
791 
792 
793 
794 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/Address.sol
795 
796 // SPDX-License-Identifier: MIT
797 
798 pragma solidity ^0.6.2;
799 
800 /**
801  * @dev Collection of functions related to the address type
802  */
803 library Address {
804     /**
805      * @dev Returns true if `account` is a contract.
806      *
807      * [IMPORTANT]
808      * ====
809      * It is unsafe to assume that an address for which this function returns
810      * false is an externally-owned account (EOA) and not a contract.
811      *
812      * Among others, `isContract` will return false for the following
813      * types of addresses:
814      *
815      *  - an externally-owned account
816      *  - a contract in construction
817      *  - an address where a contract will be created
818      *  - an address where a contract lived, but was destroyed
819      * ====
820      */
821     function isContract(address account) internal view returns (bool) {
822         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
823         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
824         // for accounts without code, i.e. `keccak256('')`
825         bytes32 codehash;
826         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
827         // solhint-disable-next-line no-inline-assembly
828         assembly { codehash := extcodehash(account) }
829         return (codehash != accountHash && codehash != 0x0);
830     }
831 
832     /**
833      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
834      * `recipient`, forwarding all available gas and reverting on errors.
835      *
836      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
837      * of certain opcodes, possibly making contracts go over the 2300 gas limit
838      * imposed by `transfer`, making them unable to receive funds via
839      * `transfer`. {sendValue} removes this limitation.
840      *
841      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
842      *
843      * IMPORTANT: because control is transferred to `recipient`, care must be
844      * taken to not create reentrancy vulnerabilities. Consider using
845      * {ReentrancyGuard} or the
846      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
847      */
848     function sendValue(address payable recipient, uint256 amount) internal {
849         require(address(this).balance >= amount, "Address: insufficient balance");
850 
851         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
852         (bool success, ) = recipient.call{ value: amount }("");
853         require(success, "Address: unable to send value, recipient may have reverted");
854     }
855 
856     /**
857      * @dev Performs a Solidity function call using a low level `call`. A
858      * plain`call` is an unsafe replacement for a function call: use this
859      * function instead.
860      *
861      * If `target` reverts with a revert reason, it is bubbled up by this
862      * function (like regular Solidity function calls).
863      *
864      * Returns the raw returned data. To convert to the expected return value,
865      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
866      *
867      * Requirements:
868      *
869      * - `target` must be a contract.
870      * - calling `target` with `data` must not revert.
871      *
872      * _Available since v3.1._
873      */
874     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
875       return functionCall(target, data, "Address: low-level call failed");
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
880      * `errorMessage` as a fallback revert reason when `target` reverts.
881      *
882      * _Available since v3.1._
883      */
884     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
885         return _functionCallWithValue(target, data, 0, errorMessage);
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
890      * but also transferring `value` wei to `target`.
891      *
892      * Requirements:
893      *
894      * - the calling contract must have an ETH balance of at least `value`.
895      * - the called Solidity function must be `payable`.
896      *
897      * _Available since v3.1._
898      */
899     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
900         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
901     }
902 
903     /**
904      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
905      * with `errorMessage` as a fallback revert reason when `target` reverts.
906      *
907      * _Available since v3.1._
908      */
909     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
910         require(address(this).balance >= value, "Address: insufficient balance for call");
911         return _functionCallWithValue(target, data, value, errorMessage);
912     }
913 
914     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
915         require(isContract(target), "Address: call to non-contract");
916 
917         // solhint-disable-next-line avoid-low-level-calls
918         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
919         if (success) {
920             return returndata;
921         } else {
922             // Look for revert reason and bubble it up if present
923             if (returndata.length > 0) {
924                 // The easiest way to bubble the revert reason is using memory via assembly
925 
926                 // solhint-disable-next-line no-inline-assembly
927                 assembly {
928                     let returndata_size := mload(returndata)
929                     revert(add(32, returndata), returndata_size)
930                 }
931             } else {
932                 revert(errorMessage);
933             }
934         }
935     }
936 }
937 
938 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/utils/EnumerableSet.sol
939 
940 // SPDX-License-Identifier: MIT
941 
942 pragma solidity ^0.6.0;
943 
944 /**
945  * @dev Library for managing
946  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
947  * types.
948  *
949  * Sets have the following properties:
950  *
951  * - Elements are added, removed, and checked for existence in constant time
952  * (O(1)).
953  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
954  *
955  * ```
956  * contract Example {
957  *     // Add the library methods
958  *     using EnumerableSet for EnumerableSet.AddressSet;
959  *
960  *     // Declare a set state variable
961  *     EnumerableSet.AddressSet private mySet;
962  * }
963  * ```
964  *
965  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
966  * (`UintSet`) are supported.
967  */
968 library EnumerableSet {
969     // To implement this library for multiple types with as little code
970     // repetition as possible, we write it in terms of a generic Set type with
971     // bytes32 values.
972     // The Set implementation uses private functions, and user-facing
973     // implementations (such as AddressSet) are just wrappers around the
974     // underlying Set.
975     // This means that we can only create new EnumerableSets for types that fit
976     // in bytes32.
977 
978     struct Set {
979         // Storage of set values
980         bytes32[] _values;
981 
982         // Position of the value in the `values` array, plus 1 because index 0
983         // means a value is not in the set.
984         mapping (bytes32 => uint256) _indexes;
985     }
986 
987     /**
988      * @dev Add a value to a set. O(1).
989      *
990      * Returns true if the value was added to the set, that is if it was not
991      * already present.
992      */
993     function _add(Set storage set, bytes32 value) private returns (bool) {
994         if (!_contains(set, value)) {
995             set._values.push(value);
996             // The value is stored at length-1, but we add 1 to all indexes
997             // and use 0 as a sentinel value
998             set._indexes[value] = set._values.length;
999             return true;
1000         } else {
1001             return false;
1002         }
1003     }
1004 
1005     /**
1006      * @dev Removes a value from a set. O(1).
1007      *
1008      * Returns true if the value was removed from the set, that is if it was
1009      * present.
1010      */
1011     function _remove(Set storage set, bytes32 value) private returns (bool) {
1012         // We read and store the value's index to prevent multiple reads from the same storage slot
1013         uint256 valueIndex = set._indexes[value];
1014 
1015         if (valueIndex != 0) { // Equivalent to contains(set, value)
1016             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1017             // the array, and then remove the last element (sometimes called as 'swap and pop').
1018             // This modifies the order of the array, as noted in {at}.
1019 
1020             uint256 toDeleteIndex = valueIndex - 1;
1021             uint256 lastIndex = set._values.length - 1;
1022 
1023             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1024             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1025 
1026             bytes32 lastvalue = set._values[lastIndex];
1027 
1028             // Move the last value to the index where the value to delete is
1029             set._values[toDeleteIndex] = lastvalue;
1030             // Update the index for the moved value
1031             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1032 
1033             // Delete the slot where the moved value was stored
1034             set._values.pop();
1035 
1036             // Delete the index for the deleted slot
1037             delete set._indexes[value];
1038 
1039             return true;
1040         } else {
1041             return false;
1042         }
1043     }
1044 
1045     /**
1046      * @dev Returns true if the value is in the set. O(1).
1047      */
1048     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1049         return set._indexes[value] != 0;
1050     }
1051 
1052     /**
1053      * @dev Returns the number of values on the set. O(1).
1054      */
1055     function _length(Set storage set) private view returns (uint256) {
1056         return set._values.length;
1057     }
1058 
1059    /**
1060     * @dev Returns the value stored at position `index` in the set. O(1).
1061     *
1062     * Note that there are no guarantees on the ordering of values inside the
1063     * array, and it may change when more values are added or removed.
1064     *
1065     * Requirements:
1066     *
1067     * - `index` must be strictly less than {length}.
1068     */
1069     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1070         require(set._values.length > index, "EnumerableSet: index out of bounds");
1071         return set._values[index];
1072     }
1073 
1074     // AddressSet
1075 
1076     struct AddressSet {
1077         Set _inner;
1078     }
1079 
1080     /**
1081      * @dev Add a value to a set. O(1).
1082      *
1083      * Returns true if the value was added to the set, that is if it was not
1084      * already present.
1085      */
1086     function add(AddressSet storage set, address value) internal returns (bool) {
1087         return _add(set._inner, bytes32(uint256(value)));
1088     }
1089 
1090     /**
1091      * @dev Removes a value from a set. O(1).
1092      *
1093      * Returns true if the value was removed from the set, that is if it was
1094      * present.
1095      */
1096     function remove(AddressSet storage set, address value) internal returns (bool) {
1097         return _remove(set._inner, bytes32(uint256(value)));
1098     }
1099 
1100     /**
1101      * @dev Returns true if the value is in the set. O(1).
1102      */
1103     function contains(AddressSet storage set, address value) internal view returns (bool) {
1104         return _contains(set._inner, bytes32(uint256(value)));
1105     }
1106 
1107     /**
1108      * @dev Returns the number of values in the set. O(1).
1109      */
1110     function length(AddressSet storage set) internal view returns (uint256) {
1111         return _length(set._inner);
1112     }
1113 
1114    /**
1115     * @dev Returns the value stored at position `index` in the set. O(1).
1116     *
1117     * Note that there are no guarantees on the ordering of values inside the
1118     * array, and it may change when more values are added or removed.
1119     *
1120     * Requirements:
1121     *
1122     * - `index` must be strictly less than {length}.
1123     */
1124     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1125         return address(uint256(_at(set._inner, index)));
1126     }
1127 
1128 
1129     // UintSet
1130 
1131     struct UintSet {
1132         Set _inner;
1133     }
1134 
1135     /**
1136      * @dev Add a value to a set. O(1).
1137      *
1138      * Returns true if the value was added to the set, that is if it was not
1139      * already present.
1140      */
1141     function add(UintSet storage set, uint256 value) internal returns (bool) {
1142         return _add(set._inner, bytes32(value));
1143     }
1144 
1145     /**
1146      * @dev Removes a value from a set. O(1).
1147      *
1148      * Returns true if the value was removed from the set, that is if it was
1149      * present.
1150      */
1151     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1152         return _remove(set._inner, bytes32(value));
1153     }
1154 
1155     /**
1156      * @dev Returns true if the value is in the set. O(1).
1157      */
1158     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1159         return _contains(set._inner, bytes32(value));
1160     }
1161 
1162     /**
1163      * @dev Returns the number of values on the set. O(1).
1164      */
1165     function length(UintSet storage set) internal view returns (uint256) {
1166         return _length(set._inner);
1167     }
1168 
1169    /**
1170     * @dev Returns the value stored at position `index` in the set. O(1).
1171     *
1172     * Note that there are no guarantees on the ordering of values inside the
1173     * array, and it may change when more values are added or removed.
1174     *
1175     * Requirements:
1176     *
1177     * - `index` must be strictly less than {length}.
1178     */
1179     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1180         return uint256(_at(set._inner, index));
1181     }
1182 }
1183 
1184 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/access/AccessControl.sol
1185 
1186 // SPDX-License-Identifier: MIT
1187 
1188 pragma solidity ^0.6.0;
1189 
1190 
1191 
1192 
1193 /**
1194  * @dev Contract module that allows children to implement role-based access
1195  * control mechanisms.
1196  *
1197  * Roles are referred to by their `bytes32` identifier. These should be exposed
1198  * in the external API and be unique. The best way to achieve this is by
1199  * using `public constant` hash digests:
1200  *
1201  * ```
1202  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1203  * ```
1204  *
1205  * Roles can be used to represent a set of permissions. To restrict access to a
1206  * function call, use {hasRole}:
1207  *
1208  * ```
1209  * function foo() public {
1210  *     require(hasRole(MY_ROLE, msg.sender));
1211  *     ...
1212  * }
1213  * ```
1214  *
1215  * Roles can be granted and revoked dynamically via the {grantRole} and
1216  * {revokeRole} functions. Each role has an associated admin role, and only
1217  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1218  *
1219  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1220  * that only accounts with this role will be able to grant or revoke other
1221  * roles. More complex role relationships can be created by using
1222  * {_setRoleAdmin}.
1223  *
1224  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1225  * grant and revoke this role. Extra precautions should be taken to secure
1226  * accounts that have been granted it.
1227  */
1228 abstract contract AccessControl is Context {
1229     using EnumerableSet for EnumerableSet.AddressSet;
1230     using Address for address;
1231 
1232     struct RoleData {
1233         EnumerableSet.AddressSet members;
1234         bytes32 adminRole;
1235     }
1236 
1237     mapping (bytes32 => RoleData) private _roles;
1238 
1239     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1240 
1241     /**
1242      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1243      *
1244      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1245      * {RoleAdminChanged} not being emitted signaling this.
1246      *
1247      * _Available since v3.1._
1248      */
1249     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1250 
1251     /**
1252      * @dev Emitted when `account` is granted `role`.
1253      *
1254      * `sender` is the account that originated the contract call, an admin role
1255      * bearer except when using {_setupRole}.
1256      */
1257     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1258 
1259     /**
1260      * @dev Emitted when `account` is revoked `role`.
1261      *
1262      * `sender` is the account that originated the contract call:
1263      *   - if using `revokeRole`, it is the admin role bearer
1264      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1265      */
1266     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1267 
1268     /**
1269      * @dev Returns `true` if `account` has been granted `role`.
1270      */
1271     function hasRole(bytes32 role, address account) public view returns (bool) {
1272         return _roles[role].members.contains(account);
1273     }
1274 
1275     /**
1276      * @dev Returns the number of accounts that have `role`. Can be used
1277      * together with {getRoleMember} to enumerate all bearers of a role.
1278      */
1279     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1280         return _roles[role].members.length();
1281     }
1282 
1283     /**
1284      * @dev Returns one of the accounts that have `role`. `index` must be a
1285      * value between 0 and {getRoleMemberCount}, non-inclusive.
1286      *
1287      * Role bearers are not sorted in any particular way, and their ordering may
1288      * change at any point.
1289      *
1290      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1291      * you perform all queries on the same block. See the following
1292      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1293      * for more information.
1294      */
1295     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1296         return _roles[role].members.at(index);
1297     }
1298 
1299     /**
1300      * @dev Returns the admin role that controls `role`. See {grantRole} and
1301      * {revokeRole}.
1302      *
1303      * To change a role's admin, use {_setRoleAdmin}.
1304      */
1305     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1306         return _roles[role].adminRole;
1307     }
1308 
1309     /**
1310      * @dev Grants `role` to `account`.
1311      *
1312      * If `account` had not been already granted `role`, emits a {RoleGranted}
1313      * event.
1314      *
1315      * Requirements:
1316      *
1317      * - the caller must have ``role``'s admin role.
1318      */
1319     function grantRole(bytes32 role, address account) public virtual {
1320         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1321 
1322         _grantRole(role, account);
1323     }
1324 
1325     /**
1326      * @dev Revokes `role` from `account`.
1327      *
1328      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1329      *
1330      * Requirements:
1331      *
1332      * - the caller must have ``role``'s admin role.
1333      */
1334     function revokeRole(bytes32 role, address account) public virtual {
1335         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1336 
1337         _revokeRole(role, account);
1338     }
1339 
1340     /**
1341      * @dev Revokes `role` from the calling account.
1342      *
1343      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1344      * purpose is to provide a mechanism for accounts to lose their privileges
1345      * if they are compromised (such as when a trusted device is misplaced).
1346      *
1347      * If the calling account had been granted `role`, emits a {RoleRevoked}
1348      * event.
1349      *
1350      * Requirements:
1351      *
1352      * - the caller must be `account`.
1353      */
1354     function renounceRole(bytes32 role, address account) public virtual {
1355         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1356 
1357         _revokeRole(role, account);
1358     }
1359 
1360     /**
1361      * @dev Grants `role` to `account`.
1362      *
1363      * If `account` had not been already granted `role`, emits a {RoleGranted}
1364      * event. Note that unlike {grantRole}, this function doesn't perform any
1365      * checks on the calling account.
1366      *
1367      * [WARNING]
1368      * ====
1369      * This function should only be called from the constructor when setting
1370      * up the initial roles for the system.
1371      *
1372      * Using this function in any other way is effectively circumventing the admin
1373      * system imposed by {AccessControl}.
1374      * ====
1375      */
1376     function _setupRole(bytes32 role, address account) internal virtual {
1377         _grantRole(role, account);
1378     }
1379 
1380     /**
1381      * @dev Sets `adminRole` as ``role``'s admin role.
1382      *
1383      * Emits a {RoleAdminChanged} event.
1384      */
1385     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1386         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1387         _roles[role].adminRole = adminRole;
1388     }
1389 
1390     function _grantRole(bytes32 role, address account) private {
1391         if (_roles[role].members.add(account)) {
1392             emit RoleGranted(role, account, _msgSender());
1393         }
1394     }
1395 
1396     function _revokeRole(bytes32 role, address account) private {
1397         if (_roles[role].members.remove(account)) {
1398             emit RoleRevoked(role, account, _msgSender());
1399         }
1400     }
1401 }
1402 
1403 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.1.0/contracts/presets/ERC20PresetMinterPauser.sol
1404 
1405 // SPDX-License-Identifier: MIT
1406 
1407 pragma solidity ^0.6.0;
1408 
1409 
1410 
1411 
1412 
1413 
1414 /**
1415  * @dev {ERC20} token, including:
1416  *
1417  *  - ability for holders to burn (destroy) their tokens
1418  *  - a minter role that allows for token minting (creation)
1419  *  - a pauser role that allows to stop all token transfers
1420  *
1421  * This contract uses {AccessControl} to lock permissioned functions using the
1422  * different roles - head to its documentation for details.
1423  *
1424  * The account that deploys the contract will be granted the minter and pauser
1425  * roles, as well as the default admin role, which will let it grant both minter
1426  * and pauser roles to other accounts.
1427  */
1428 contract ERC20PresetMinterPauser is Context, AccessControl, ERC20Burnable, ERC20Pausable {
1429     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1430     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1431 
1432     /**
1433      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` and `PAUSER_ROLE` to the
1434      * account that deploys the contract.
1435      *
1436      * See {ERC20-constructor}.
1437      */
1438     constructor(string memory name, string memory symbol) public ERC20(name, symbol) {
1439         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1440 
1441         _setupRole(MINTER_ROLE, _msgSender());
1442         _setupRole(PAUSER_ROLE, _msgSender());
1443     }
1444 
1445     /**
1446      * @dev Creates `amount` new tokens for `to`.
1447      *
1448      * See {ERC20-_mint}.
1449      *
1450      * Requirements:
1451      *
1452      * - the caller must have the `MINTER_ROLE`.
1453      */
1454     function mint(address to, uint256 amount) public virtual {
1455         require(hasRole(MINTER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have minter role to mint");
1456         _mint(to, amount);
1457     }
1458 
1459     /**
1460      * @dev Pauses all token transfers.
1461      *
1462      * See {ERC20Pausable} and {Pausable-_pause}.
1463      *
1464      * Requirements:
1465      *
1466      * - the caller must have the `PAUSER_ROLE`.
1467      */
1468     function pause() public virtual {
1469         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to pause");
1470         _pause();
1471     }
1472 
1473     /**
1474      * @dev Unpauses all token transfers.
1475      *
1476      * See {ERC20Pausable} and {Pausable-_unpause}.
1477      *
1478      * Requirements:
1479      *
1480      * - the caller must have the `PAUSER_ROLE`.
1481      */
1482     function unpause() public virtual {
1483         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC20PresetMinterPauser: must have pauser role to unpause");
1484         _unpause();
1485     }
1486 
1487     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Pausable) {
1488         super._beforeTokenTransfer(from, to, amount);
1489     }
1490 }
1491 
1492 // File: browser/CAPToken.sol
1493 
1494 pragma solidity ^0.6.2;
1495 
1496 
1497 
1498 
1499 contract CAPToken is ERC20PresetMinterPauser, ERC20Capped {
1500 
1501     constructor (string memory name, string memory symbol, uint256 cap) public ERC20PresetMinterPauser(name, symbol) ERC20Capped(cap) {}
1502     
1503     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20PresetMinterPauser, ERC20Capped) {
1504         super._beforeTokenTransfer(from, to, amount);
1505     }
1506     
1507 }