1 // Sources flattened with hardhat v2.9.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Returns the amount of tokens in existence.
16      */
17     function totalSupply() external view returns (uint256);
18 
19     /**
20      * @dev Returns the amount of tokens owned by `account`.
21      */
22     function balanceOf(address account) external view returns (uint256);
23 
24     /**
25      * @dev Moves `amount` tokens from the caller's account to `to`.
26      *
27      * Returns a boolean value indicating whether the operation succeeded.
28      *
29      * Emits a {Transfer} event.
30      */
31     function transfer(address to, uint256 amount) external returns (bool);
32 
33     /**
34      * @dev Returns the remaining number of tokens that `spender` will be
35      * allowed to spend on behalf of `owner` through {transferFrom}. This is
36      * zero by default.
37      *
38      * This value changes when {approve} or {transferFrom} are called.
39      */
40     function allowance(address owner, address spender) external view returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `from` to `to` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address from,
69         address to,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface for the optional metadata functions from the ERC20 standard.
98  *
99  * _Available since v4.1._
100  */
101 interface IERC20Metadata is IERC20 {
102     /**
103      * @dev Returns the name of the token.
104      */
105     function name() external view returns (string memory);
106 
107     /**
108      * @dev Returns the symbol of the token.
109      */
110     function symbol() external view returns (string memory);
111 
112     /**
113      * @dev Returns the decimals places of the token.
114      */
115     function decimals() external view returns (uint8);
116 }
117 
118 
119 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 
147 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
148 
149 
150 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
151 
152 pragma solidity ^0.8.0;
153 
154 
155 
156 /**
157  * @dev Implementation of the {IERC20} interface.
158  *
159  * This implementation is agnostic to the way tokens are created. This means
160  * that a supply mechanism has to be added in a derived contract using {_mint}.
161  * For a generic mechanism see {ERC20PresetMinterPauser}.
162  *
163  * TIP: For a detailed writeup see our guide
164  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
165  * to implement supply mechanisms].
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `to` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address to, uint256 amount) public virtual override returns (bool) {
260         address owner = _msgSender();
261         _transfer(owner, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
276      * `transferFrom`. This is semantically equivalent to an infinite approval.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         address owner = _msgSender();
284         _approve(owner, spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * NOTE: Does not update the allowance if the current allowance
295      * is the maximum `uint256`.
296      *
297      * Requirements:
298      *
299      * - `from` and `to` cannot be the zero address.
300      * - `from` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``from``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         address spender = _msgSender();
310         _spendAllowance(from, spender, amount);
311         _transfer(from, to, amount);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         address owner = _msgSender();
329         _approve(owner, spender, _allowances[owner][spender] + addedValue);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         address owner = _msgSender();
349         uint256 currentAllowance = _allowances[owner][spender];
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         unchecked {
352             _approve(owner, spender, currentAllowance - subtractedValue);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves `amount` of tokens from `sender` to `recipient`.
360      *
361      * This internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `from` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {
377         require(from != address(0), "ERC20: transfer from the zero address");
378         require(to != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(from, to, amount);
381 
382         uint256 fromBalance = _balances[from];
383         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
384         unchecked {
385             _balances[from] = fromBalance - amount;
386         }
387         _balances[to] += amount;
388 
389         emit Transfer(from, to, amount);
390 
391         _afterTokenTransfer(from, to, amount);
392     }
393 
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405 
406         _beforeTokenTransfer(address(0), account, amount);
407 
408         _totalSupply += amount;
409         _balances[account] += amount;
410         emit Transfer(address(0), account, amount);
411 
412         _afterTokenTransfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         uint256 accountBalance = _balances[account];
432         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
433         unchecked {
434             _balances[account] = accountBalance - amount;
435         }
436         _totalSupply -= amount;
437 
438         emit Transfer(account, address(0), amount);
439 
440         _afterTokenTransfer(account, address(0), amount);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
445      *
446      * This internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an {Approval} event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(
457         address owner,
458         address spender,
459         uint256 amount
460     ) internal virtual {
461         require(owner != address(0), "ERC20: approve from the zero address");
462         require(spender != address(0), "ERC20: approve to the zero address");
463 
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467 
468     /**
469      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
470      *
471      * Does not update the allowance amount in case of infinite allowance.
472      * Revert if not enough allowance is available.
473      *
474      * Might emit an {Approval} event.
475      */
476     function _spendAllowance(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         uint256 currentAllowance = allowance(owner, spender);
482         if (currentAllowance != type(uint256).max) {
483             require(currentAllowance >= amount, "ERC20: insufficient allowance");
484             unchecked {
485                 _approve(owner, spender, currentAllowance - amount);
486             }
487         }
488     }
489 
490     /**
491      * @dev Hook that is called before any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * will be transferred to `to`.
498      * - when `from` is zero, `amount` tokens will be minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _beforeTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 
510     /**
511      * @dev Hook that is called after any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * has been transferred to `to`.
518      * - when `from` is zero, `amount` tokens have been minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _afterTokenTransfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {}
529 }
530 
531 
532 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
533 
534 
535 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 // CAUTION
540 // This version of SafeMath should only be used with Solidity 0.8 or later,
541 // because it relies on the compiler's built in overflow checks.
542 
543 /**
544  * @dev Wrappers over Solidity's arithmetic operations.
545  *
546  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
547  * now has built in overflow checking.
548  */
549 library SafeMath {
550     /**
551      * @dev Returns the addition of two unsigned integers, with an overflow flag.
552      *
553      * _Available since v3.4._
554      */
555     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         unchecked {
557             uint256 c = a + b;
558             if (c < a) return (false, 0);
559             return (true, c);
560         }
561     }
562 
563     /**
564      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
565      *
566      * _Available since v3.4._
567      */
568     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
569         unchecked {
570             if (b > a) return (false, 0);
571             return (true, a - b);
572         }
573     }
574 
575     /**
576      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
577      *
578      * _Available since v3.4._
579      */
580     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
583             // benefit is lost if 'b' is also tested.
584             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
585             if (a == 0) return (true, 0);
586             uint256 c = a * b;
587             if (c / a != b) return (false, 0);
588             return (true, c);
589         }
590     }
591 
592     /**
593      * @dev Returns the division of two unsigned integers, with a division by zero flag.
594      *
595      * _Available since v3.4._
596      */
597     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
598         unchecked {
599             if (b == 0) return (false, 0);
600             return (true, a / b);
601         }
602     }
603 
604     /**
605      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             if (b == 0) return (false, 0);
612             return (true, a % b);
613         }
614     }
615 
616     /**
617      * @dev Returns the addition of two unsigned integers, reverting on
618      * overflow.
619      *
620      * Counterpart to Solidity's `+` operator.
621      *
622      * Requirements:
623      *
624      * - Addition cannot overflow.
625      */
626     function add(uint256 a, uint256 b) internal pure returns (uint256) {
627         return a + b;
628     }
629 
630     /**
631      * @dev Returns the subtraction of two unsigned integers, reverting on
632      * overflow (when the result is negative).
633      *
634      * Counterpart to Solidity's `-` operator.
635      *
636      * Requirements:
637      *
638      * - Subtraction cannot overflow.
639      */
640     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
641         return a - b;
642     }
643 
644     /**
645      * @dev Returns the multiplication of two unsigned integers, reverting on
646      * overflow.
647      *
648      * Counterpart to Solidity's `*` operator.
649      *
650      * Requirements:
651      *
652      * - Multiplication cannot overflow.
653      */
654     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
655         return a * b;
656     }
657 
658     /**
659      * @dev Returns the integer division of two unsigned integers, reverting on
660      * division by zero. The result is rounded towards zero.
661      *
662      * Counterpart to Solidity's `/` operator.
663      *
664      * Requirements:
665      *
666      * - The divisor cannot be zero.
667      */
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         return a / b;
670     }
671 
672     /**
673      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
674      * reverting when dividing by zero.
675      *
676      * Counterpart to Solidity's `%` operator. This function uses a `revert`
677      * opcode (which leaves remaining gas untouched) while Solidity uses an
678      * invalid opcode to revert (consuming all remaining gas).
679      *
680      * Requirements:
681      *
682      * - The divisor cannot be zero.
683      */
684     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
685         return a % b;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
690      * overflow (when the result is negative).
691      *
692      * CAUTION: This function is deprecated because it requires allocating memory for the error
693      * message unnecessarily. For custom revert reasons use {trySub}.
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(
702         uint256 a,
703         uint256 b,
704         string memory errorMessage
705     ) internal pure returns (uint256) {
706         unchecked {
707             require(b <= a, errorMessage);
708             return a - b;
709         }
710     }
711 
712     /**
713      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
714      * division by zero. The result is rounded towards zero.
715      *
716      * Counterpart to Solidity's `/` operator. Note: this function uses a
717      * `revert` opcode (which leaves remaining gas untouched) while Solidity
718      * uses an invalid opcode to revert (consuming all remaining gas).
719      *
720      * Requirements:
721      *
722      * - The divisor cannot be zero.
723      */
724     function div(
725         uint256 a,
726         uint256 b,
727         string memory errorMessage
728     ) internal pure returns (uint256) {
729         unchecked {
730             require(b > 0, errorMessage);
731             return a / b;
732         }
733     }
734 
735     /**
736      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
737      * reverting with custom message when dividing by zero.
738      *
739      * CAUTION: This function is deprecated because it requires allocating memory for the error
740      * message unnecessarily. For custom revert reasons use {tryMod}.
741      *
742      * Counterpart to Solidity's `%` operator. This function uses a `revert`
743      * opcode (which leaves remaining gas untouched) while Solidity uses an
744      * invalid opcode to revert (consuming all remaining gas).
745      *
746      * Requirements:
747      *
748      * - The divisor cannot be zero.
749      */
750     function mod(
751         uint256 a,
752         uint256 b,
753         string memory errorMessage
754     ) internal pure returns (uint256) {
755         unchecked {
756             require(b > 0, errorMessage);
757             return a % b;
758         }
759     }
760 }
761 
762 
763 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.5.1
764 
765 
766 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
767 
768 pragma solidity ^0.8.1;
769 
770 /**
771  * @dev Collection of functions related to the address type
772  */
773 library AddressUpgradeable {
774     /**
775      * @dev Returns true if `account` is a contract.
776      *
777      * [IMPORTANT]
778      * ====
779      * It is unsafe to assume that an address for which this function returns
780      * false is an externally-owned account (EOA) and not a contract.
781      *
782      * Among others, `isContract` will return false for the following
783      * types of addresses:
784      *
785      *  - an externally-owned account
786      *  - a contract in construction
787      *  - an address where a contract will be created
788      *  - an address where a contract lived, but was destroyed
789      * ====
790      *
791      * [IMPORTANT]
792      * ====
793      * You shouldn't rely on `isContract` to protect against flash loan attacks!
794      *
795      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
796      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
797      * constructor.
798      * ====
799      */
800     function isContract(address account) internal view returns (bool) {
801         // This method relies on extcodesize/address.code.length, which returns 0
802         // for contracts in construction, since the code is only stored at the end
803         // of the constructor execution.
804 
805         return account.code.length > 0;
806     }
807 
808     /**
809      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
810      * `recipient`, forwarding all available gas and reverting on errors.
811      *
812      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
813      * of certain opcodes, possibly making contracts go over the 2300 gas limit
814      * imposed by `transfer`, making them unable to receive funds via
815      * `transfer`. {sendValue} removes this limitation.
816      *
817      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
818      *
819      * IMPORTANT: because control is transferred to `recipient`, care must be
820      * taken to not create reentrancy vulnerabilities. Consider using
821      * {ReentrancyGuard} or the
822      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
823      */
824     function sendValue(address payable recipient, uint256 amount) internal {
825         require(address(this).balance >= amount, "Address: insufficient balance");
826 
827         (bool success, ) = recipient.call{value: amount}("");
828         require(success, "Address: unable to send value, recipient may have reverted");
829     }
830 
831     /**
832      * @dev Performs a Solidity function call using a low level `call`. A
833      * plain `call` is an unsafe replacement for a function call: use this
834      * function instead.
835      *
836      * If `target` reverts with a revert reason, it is bubbled up by this
837      * function (like regular Solidity function calls).
838      *
839      * Returns the raw returned data. To convert to the expected return value,
840      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
841      *
842      * Requirements:
843      *
844      * - `target` must be a contract.
845      * - calling `target` with `data` must not revert.
846      *
847      * _Available since v3.1._
848      */
849     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
850         return functionCall(target, data, "Address: low-level call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
855      * `errorMessage` as a fallback revert reason when `target` reverts.
856      *
857      * _Available since v3.1._
858      */
859     function functionCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal returns (bytes memory) {
864         return functionCallWithValue(target, data, 0, errorMessage);
865     }
866 
867     /**
868      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
869      * but also transferring `value` wei to `target`.
870      *
871      * Requirements:
872      *
873      * - the calling contract must have an ETH balance of at least `value`.
874      * - the called Solidity function must be `payable`.
875      *
876      * _Available since v3.1._
877      */
878     function functionCallWithValue(
879         address target,
880         bytes memory data,
881         uint256 value
882     ) internal returns (bytes memory) {
883         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
888      * with `errorMessage` as a fallback revert reason when `target` reverts.
889      *
890      * _Available since v3.1._
891      */
892     function functionCallWithValue(
893         address target,
894         bytes memory data,
895         uint256 value,
896         string memory errorMessage
897     ) internal returns (bytes memory) {
898         require(address(this).balance >= value, "Address: insufficient balance for call");
899         require(isContract(target), "Address: call to non-contract");
900 
901         (bool success, bytes memory returndata) = target.call{value: value}(data);
902         return verifyCallResult(success, returndata, errorMessage);
903     }
904 
905     /**
906      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
907      * but performing a static call.
908      *
909      * _Available since v3.3._
910      */
911     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
912         return functionStaticCall(target, data, "Address: low-level static call failed");
913     }
914 
915     /**
916      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
917      * but performing a static call.
918      *
919      * _Available since v3.3._
920      */
921     function functionStaticCall(
922         address target,
923         bytes memory data,
924         string memory errorMessage
925     ) internal view returns (bytes memory) {
926         require(isContract(target), "Address: static call to non-contract");
927 
928         (bool success, bytes memory returndata) = target.staticcall(data);
929         return verifyCallResult(success, returndata, errorMessage);
930     }
931 
932     /**
933      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
934      * revert reason using the provided one.
935      *
936      * _Available since v4.3._
937      */
938     function verifyCallResult(
939         bool success,
940         bytes memory returndata,
941         string memory errorMessage
942     ) internal pure returns (bytes memory) {
943         if (success) {
944             return returndata;
945         } else {
946             // Look for revert reason and bubble it up if present
947             if (returndata.length > 0) {
948                 // The easiest way to bubble the revert reason is using memory via assembly
949 
950                 assembly {
951                     let returndata_size := mload(returndata)
952                     revert(add(32, returndata), returndata_size)
953                 }
954             } else {
955                 revert(errorMessage);
956             }
957         }
958     }
959 }
960 
961 
962 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.5.1
963 
964 
965 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
971  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
972  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
973  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
974  *
975  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
976  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
977  *
978  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
979  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
980  *
981  * [CAUTION]
982  * ====
983  * Avoid leaving a contract uninitialized.
984  *
985  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
986  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
987  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
988  *
989  * [.hljs-theme-light.nopadding]
990  * ```
991  * /// @custom:oz-upgrades-unsafe-allow constructor
992  * constructor() initializer {}
993  * ```
994  * ====
995  */
996 abstract contract Initializable {
997     /**
998      * @dev Indicates that the contract has been initialized.
999      */
1000     bool private _initialized;
1001 
1002     /**
1003      * @dev Indicates that the contract is in the process of being initialized.
1004      */
1005     bool private _initializing;
1006 
1007     /**
1008      * @dev Modifier to protect an initializer function from being invoked twice.
1009      */
1010     modifier initializer() {
1011         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
1012         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
1013         // contract may have been reentered.
1014         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
1015 
1016         bool isTopLevelCall = !_initializing;
1017         if (isTopLevelCall) {
1018             _initializing = true;
1019             _initialized = true;
1020         }
1021 
1022         _;
1023 
1024         if (isTopLevelCall) {
1025             _initializing = false;
1026         }
1027     }
1028 
1029     /**
1030      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
1031      * {initializer} modifier, directly or indirectly.
1032      */
1033     modifier onlyInitializing() {
1034         require(_initializing, "Initializable: contract is not initializing");
1035         _;
1036     }
1037 
1038     function _isConstructor() private view returns (bool) {
1039         return !AddressUpgradeable.isContract(address(this));
1040     }
1041 }
1042 
1043 
1044 // File contracts/common/EIP712Base.sol
1045 
1046 
1047 pragma solidity 0.8.9;
1048 
1049 contract EIP712Base is Initializable {
1050     struct EIP712Domain {
1051         string name;
1052         string version;
1053         address verifyingContract;
1054         bytes32 salt;
1055     }
1056 
1057     string constant public ERC712_VERSION = "1";
1058 
1059     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
1060         bytes(
1061             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
1062         )
1063     );
1064     bytes32 internal domainSeperator;
1065 
1066     // supposed to be called once while initializing.
1067     // one of the contractsa that inherits this contract follows proxy pattern
1068     // so it is not possible to do this in a constructor
1069     function _initializeEIP712(
1070         string memory name
1071     )
1072         internal
1073         initializer
1074     {
1075         _setDomainSeperator(name);
1076     }
1077 
1078     function _setDomainSeperator(string memory name) internal {
1079         domainSeperator = keccak256(
1080             abi.encode(
1081                 EIP712_DOMAIN_TYPEHASH,
1082                 keccak256(bytes(name)),
1083                 keccak256(bytes(ERC712_VERSION)),
1084                 address(this),
1085                 bytes32(getChainId())
1086             )
1087         );
1088     }
1089 
1090     function getDomainSeperator() public view returns (bytes32) {
1091         return domainSeperator;
1092     }
1093 
1094     function getChainId() public view returns (uint256) {
1095         uint256 id;
1096         assembly {
1097             id := chainid()
1098         }
1099         return id;
1100     }
1101 
1102     /**
1103      * Accept message hash and returns hash message in EIP712 compatible form
1104      * So that it can be used to recover signer from signature signed using EIP712 formatted data
1105      * https://eips.ethereum.org/EIPS/eip-712
1106      * "\\x19" makes the encoding deterministic
1107      * "\\x01" is the version byte to make it compatible to EIP-191
1108      */
1109     function toTypedMessageHash(bytes32 messageHash)
1110         internal
1111         view
1112         returns (bytes32)
1113     {
1114         return
1115             keccak256(
1116                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
1117             );
1118     }
1119 }
1120 
1121 
1122 // File contracts/common/NativeMetaTransaction.sol
1123 
1124 
1125 pragma solidity 0.8.9;
1126 
1127 
1128 contract NativeMetaTransaction is EIP712Base {
1129     using SafeMath for uint256;
1130     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
1131         bytes(
1132             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
1133         )
1134     );
1135     event MetaTransactionExecuted(
1136         address userAddress,
1137         address relayerAddress,
1138         bytes functionSignature
1139     );
1140     mapping(address => uint256) nonces;
1141 
1142     /*
1143      * Meta transaction structure.
1144      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
1145      * He should call the desired function directly in that case.
1146      */
1147     struct MetaTransaction {
1148         uint256 nonce;
1149         address from;
1150         bytes functionSignature;
1151     }
1152 
1153     function executeMetaTransaction(
1154         address userAddress,
1155         bytes memory functionSignature,
1156         bytes32 sigR,
1157         bytes32 sigS,
1158         uint8 sigV
1159     ) public payable returns (bytes memory) {
1160         MetaTransaction memory metaTx = MetaTransaction({
1161             nonce: nonces[userAddress],
1162             from: userAddress,
1163             functionSignature: functionSignature
1164         });
1165 
1166         require(
1167             verify(userAddress, metaTx, sigR, sigS, sigV),
1168             "Signer and signature do not match"
1169         );
1170 
1171         // increase nonce for user (to avoid re-use)
1172         nonces[userAddress] = nonces[userAddress].add(1);
1173 
1174         emit MetaTransactionExecuted(
1175             userAddress,
1176             msg.sender,
1177             functionSignature
1178         );
1179 
1180         // Append userAddress and relayer address at the end to extract it from calling context
1181         (bool success, bytes memory returnData) = address(this).call(
1182             abi.encodePacked(functionSignature, userAddress)
1183         );
1184         require(success, "Function call not successful");
1185 
1186         return returnData;
1187     }
1188 
1189     function hashMetaTransaction(MetaTransaction memory metaTx)
1190         internal
1191         pure
1192         returns (bytes32)
1193     {
1194         return
1195             keccak256(
1196                 abi.encode(
1197                     META_TRANSACTION_TYPEHASH,
1198                     metaTx.nonce,
1199                     metaTx.from,
1200                     keccak256(metaTx.functionSignature)
1201                 )
1202             );
1203     }
1204 
1205     function getNonce(address user) public view returns (uint256 nonce) {
1206         nonce = nonces[user];
1207     }
1208 
1209     function verify(
1210         address signer,
1211         MetaTransaction memory metaTx,
1212         bytes32 sigR,
1213         bytes32 sigS,
1214         uint8 sigV
1215     ) internal view returns (bool) {
1216         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
1217         return
1218             signer ==
1219             ecrecover(
1220                 toTypedMessageHash(hashMetaTransaction(metaTx)),
1221                 sigV,
1222                 sigR,
1223                 sigS
1224             );
1225     }
1226 }
1227 
1228 
1229 // File contracts/common/ContextMixin.sol
1230 
1231 
1232 pragma solidity 0.8.9;
1233 
1234 abstract contract ContextMixin {
1235     function msgSender()
1236         internal
1237         view
1238         returns (address sender)
1239     {
1240         if (msg.sender == address(this)) {
1241             bytes memory array = msg.data;
1242             uint256 index = msg.data.length;
1243             assembly {
1244                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1245                 sender := and(
1246                     mload(add(array, index)),
1247                     0xffffffffffffffffffffffffffffffffffffffff
1248                 )
1249             }
1250         } else {
1251             sender = msg.sender;
1252         }
1253         return sender;
1254     }
1255 }
1256 
1257 
1258 // File contracts/ethereum/VAIToken.sol
1259 
1260 
1261 pragma solidity 0.8.9;
1262 
1263 
1264 
1265 contract VAIToken is
1266     ERC20,
1267     NativeMetaTransaction,
1268     ContextMixin
1269 {
1270     constructor(string memory name_, string memory symbol_)
1271         ERC20(name_, symbol_)
1272     {
1273         _initializeEIP712(name_);
1274         super._mint(_msgSender(), 400_000_000 * 10 ** decimals());
1275     }
1276 
1277     function _msgSender()
1278         internal
1279         override
1280         view
1281         returns (address)
1282     {
1283         return ContextMixin.msgSender();
1284     }
1285 }