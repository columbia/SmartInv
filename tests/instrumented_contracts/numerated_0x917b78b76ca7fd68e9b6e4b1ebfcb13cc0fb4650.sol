1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
4 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `to`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address to, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `from` to `to` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address from,
67         address to,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 
87 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.5.0
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Interface for the optional metadata functions from the ERC20 standard.
96  *
97  * _Available since v4.1._
98  */
99 interface IERC20Metadata is IERC20 {
100     /**
101      * @dev Returns the name of the token.
102      */
103     function name() external view returns (string memory);
104 
105     /**
106      * @dev Returns the symbol of the token.
107      */
108     function symbol() external view returns (string memory);
109 
110     /**
111      * @dev Returns the decimals places of the token.
112      */
113     function decimals() external view returns (uint8);
114 }
115 
116 
117 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 
145 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.5.0
146 
147 
148 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `to` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address to, uint256 amount) public virtual override returns (bool) {
258         address owner = _msgSender();
259         _transfer(owner, to, amount);
260         return true;
261     }
262 
263     /**
264      * @dev See {IERC20-allowance}.
265      */
266     function allowance(address owner, address spender) public view virtual override returns (uint256) {
267         return _allowances[owner][spender];
268     }
269 
270     /**
271      * @dev See {IERC20-approve}.
272      *
273      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
274      * `transferFrom`. This is semantically equivalent to an infinite approval.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         address owner = _msgSender();
282         _approve(owner, spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * NOTE: Does not update the allowance if the current allowance
293      * is the maximum `uint256`.
294      *
295      * Requirements:
296      *
297      * - `from` and `to` cannot be the zero address.
298      * - `from` must have a balance of at least `amount`.
299      * - the caller must have allowance for ``from``'s tokens of at least
300      * `amount`.
301      */
302     function transferFrom(
303         address from,
304         address to,
305         uint256 amount
306     ) public virtual override returns (bool) {
307         address spender = _msgSender();
308         _spendAllowance(from, spender, amount);
309         _transfer(from, to, amount);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically increases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
326         address owner = _msgSender();
327         _approve(owner, spender, _allowances[owner][spender] + addedValue);
328         return true;
329     }
330 
331     /**
332      * @dev Atomically decreases the allowance granted to `spender` by the caller.
333      *
334      * This is an alternative to {approve} that can be used as a mitigation for
335      * problems described in {IERC20-approve}.
336      *
337      * Emits an {Approval} event indicating the updated allowance.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      * - `spender` must have allowance for the caller of at least
343      * `subtractedValue`.
344      */
345     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
346         address owner = _msgSender();
347         uint256 currentAllowance = _allowances[owner][spender];
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(owner, spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `sender` to `recipient`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `from` cannot be the zero address.
367      * - `to` cannot be the zero address.
368      * - `from` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address from,
372         address to,
373         uint256 amount
374     ) internal virtual {
375         require(from != address(0), "ERC20: transfer from the zero address");
376         require(to != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(from, to, amount);
379 
380         uint256 fromBalance = _balances[from];
381         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[from] = fromBalance - amount;
384         }
385         _balances[to] += amount;
386 
387         emit Transfer(from, to, amount);
388 
389         _afterTokenTransfer(from, to, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         _balances[account] += amount;
408         emit Transfer(address(0), account, amount);
409 
410         _afterTokenTransfer(address(0), account, amount);
411     }
412 
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         _beforeTokenTransfer(account, address(0), amount);
428 
429         uint256 accountBalance = _balances[account];
430         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
431         unchecked {
432             _balances[account] = accountBalance - amount;
433         }
434         _totalSupply -= amount;
435 
436         emit Transfer(account, address(0), amount);
437 
438         _afterTokenTransfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
468      *
469      * Does not update the allowance amount in case of infinite allowance.
470      * Revert if not enough allowance is available.
471      *
472      * Might emit an {Approval} event.
473      */
474     function _spendAllowance(
475         address owner,
476         address spender,
477         uint256 amount
478     ) internal virtual {
479         uint256 currentAllowance = allowance(owner, spender);
480         if (currentAllowance != type(uint256).max) {
481             require(currentAllowance >= amount, "ERC20: insufficient allowance");
482             unchecked {
483                 _approve(owner, spender, currentAllowance - amount);
484             }
485         }
486     }
487 
488     /**
489      * @dev Hook that is called before any transfer of tokens. This includes
490      * minting and burning.
491      *
492      * Calling conditions:
493      *
494      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
495      * will be transferred to `to`.
496      * - when `from` is zero, `amount` tokens will be minted for `to`.
497      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
498      * - `from` and `to` are never both zero.
499      *
500      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
501      */
502     function _beforeTokenTransfer(
503         address from,
504         address to,
505         uint256 amount
506     ) internal virtual {}
507 
508     /**
509      * @dev Hook that is called after any transfer of tokens. This includes
510      * minting and burning.
511      *
512      * Calling conditions:
513      *
514      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
515      * has been transferred to `to`.
516      * - when `from` is zero, `amount` tokens have been minted for `to`.
517      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
518      * - `from` and `to` are never both zero.
519      *
520      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
521      */
522     function _afterTokenTransfer(
523         address from,
524         address to,
525         uint256 amount
526     ) internal virtual {}
527 }
528 
529 
530 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.5.0
531 
532 
533 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @dev Extension of {ERC20} that allows token holders to destroy both their own
540  * tokens and those that they have an allowance for, in a way that can be
541  * recognized off-chain (via event analysis).
542  */
543 abstract contract ERC20Burnable is Context, ERC20 {
544     /**
545      * @dev Destroys `amount` tokens from the caller.
546      *
547      * See {ERC20-_burn}.
548      */
549     function burn(uint256 amount) public virtual {
550         _burn(_msgSender(), amount);
551     }
552 
553     /**
554      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
555      * allowance.
556      *
557      * See {ERC20-_burn} and {ERC20-allowance}.
558      *
559      * Requirements:
560      *
561      * - the caller must have allowance for ``accounts``'s tokens of at least
562      * `amount`.
563      */
564     function burnFrom(address account, uint256 amount) public virtual {
565         _spendAllowance(account, _msgSender(), amount);
566         _burn(account, amount);
567     }
568 }
569 
570 
571 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
572 
573 
574 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
575 
576 pragma solidity ^0.8.0;
577 
578 // CAUTION
579 // This version of SafeMath should only be used with Solidity 0.8 or later,
580 // because it relies on the compiler's built in overflow checks.
581 
582 /**
583  * @dev Wrappers over Solidity's arithmetic operations.
584  *
585  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
586  * now has built in overflow checking.
587  */
588 library SafeMath {
589     /**
590      * @dev Returns the addition of two unsigned integers, with an overflow flag.
591      *
592      * _Available since v3.4._
593      */
594     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
595         unchecked {
596             uint256 c = a + b;
597             if (c < a) return (false, 0);
598             return (true, c);
599         }
600     }
601 
602     /**
603      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
604      *
605      * _Available since v3.4._
606      */
607     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b > a) return (false, 0);
610             return (true, a - b);
611         }
612     }
613 
614     /**
615      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
616      *
617      * _Available since v3.4._
618      */
619     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
622             // benefit is lost if 'b' is also tested.
623             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
624             if (a == 0) return (true, 0);
625             uint256 c = a * b;
626             if (c / a != b) return (false, 0);
627             return (true, c);
628         }
629     }
630 
631     /**
632      * @dev Returns the division of two unsigned integers, with a division by zero flag.
633      *
634      * _Available since v3.4._
635      */
636     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
637         unchecked {
638             if (b == 0) return (false, 0);
639             return (true, a / b);
640         }
641     }
642 
643     /**
644      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
645      *
646      * _Available since v3.4._
647      */
648     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
649         unchecked {
650             if (b == 0) return (false, 0);
651             return (true, a % b);
652         }
653     }
654 
655     /**
656      * @dev Returns the addition of two unsigned integers, reverting on
657      * overflow.
658      *
659      * Counterpart to Solidity's `+` operator.
660      *
661      * Requirements:
662      *
663      * - Addition cannot overflow.
664      */
665     function add(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a + b;
667     }
668 
669     /**
670      * @dev Returns the subtraction of two unsigned integers, reverting on
671      * overflow (when the result is negative).
672      *
673      * Counterpart to Solidity's `-` operator.
674      *
675      * Requirements:
676      *
677      * - Subtraction cannot overflow.
678      */
679     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
680         return a - b;
681     }
682 
683     /**
684      * @dev Returns the multiplication of two unsigned integers, reverting on
685      * overflow.
686      *
687      * Counterpart to Solidity's `*` operator.
688      *
689      * Requirements:
690      *
691      * - Multiplication cannot overflow.
692      */
693     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
694         return a * b;
695     }
696 
697     /**
698      * @dev Returns the integer division of two unsigned integers, reverting on
699      * division by zero. The result is rounded towards zero.
700      *
701      * Counterpart to Solidity's `/` operator.
702      *
703      * Requirements:
704      *
705      * - The divisor cannot be zero.
706      */
707     function div(uint256 a, uint256 b) internal pure returns (uint256) {
708         return a / b;
709     }
710 
711     /**
712      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
713      * reverting when dividing by zero.
714      *
715      * Counterpart to Solidity's `%` operator. This function uses a `revert`
716      * opcode (which leaves remaining gas untouched) while Solidity uses an
717      * invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
724         return a % b;
725     }
726 
727     /**
728      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
729      * overflow (when the result is negative).
730      *
731      * CAUTION: This function is deprecated because it requires allocating memory for the error
732      * message unnecessarily. For custom revert reasons use {trySub}.
733      *
734      * Counterpart to Solidity's `-` operator.
735      *
736      * Requirements:
737      *
738      * - Subtraction cannot overflow.
739      */
740     function sub(
741         uint256 a,
742         uint256 b,
743         string memory errorMessage
744     ) internal pure returns (uint256) {
745         unchecked {
746             require(b <= a, errorMessage);
747             return a - b;
748         }
749     }
750 
751     /**
752      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
753      * division by zero. The result is rounded towards zero.
754      *
755      * Counterpart to Solidity's `/` operator. Note: this function uses a
756      * `revert` opcode (which leaves remaining gas untouched) while Solidity
757      * uses an invalid opcode to revert (consuming all remaining gas).
758      *
759      * Requirements:
760      *
761      * - The divisor cannot be zero.
762      */
763     function div(
764         uint256 a,
765         uint256 b,
766         string memory errorMessage
767     ) internal pure returns (uint256) {
768         unchecked {
769             require(b > 0, errorMessage);
770             return a / b;
771         }
772     }
773 
774     /**
775      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
776      * reverting with custom message when dividing by zero.
777      *
778      * CAUTION: This function is deprecated because it requires allocating memory for the error
779      * message unnecessarily. For custom revert reasons use {tryMod}.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(
790         uint256 a,
791         uint256 b,
792         string memory errorMessage
793     ) internal pure returns (uint256) {
794         unchecked {
795             require(b > 0, errorMessage);
796             return a % b;
797         }
798     }
799 }
800 
801 
802 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
803 
804 
805 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
806 
807 pragma solidity ^0.8.0;
808 
809 /**
810  * @dev Contract module which provides a basic access control mechanism, where
811  * there is an account (an owner) that can be granted exclusive access to
812  * specific functions.
813  *
814  * By default, the owner account will be the one that deploys the contract. This
815  * can later be changed with {transferOwnership}.
816  *
817  * This module is used through inheritance. It will make available the modifier
818  * `onlyOwner`, which can be applied to your functions to restrict their use to
819  * the owner.
820  */
821 abstract contract Ownable is Context {
822     address private _owner;
823 
824     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
825 
826     /**
827      * @dev Initializes the contract setting the deployer as the initial owner.
828      */
829     constructor() {
830         _transferOwnership(_msgSender());
831     }
832 
833     /**
834      * @dev Returns the address of the current owner.
835      */
836     function owner() public view virtual returns (address) {
837         return _owner;
838     }
839 
840     /**
841      * @dev Throws if called by any account other than the owner.
842      */
843     modifier onlyOwner() {
844         require(owner() == _msgSender(), "Ownable: caller is not the owner");
845         _;
846     }
847 
848     /**
849      * @dev Leaves the contract without owner. It will not be possible to call
850      * `onlyOwner` functions anymore. Can only be called by the current owner.
851      *
852      * NOTE: Renouncing ownership will leave the contract without an owner,
853      * thereby removing any functionality that is only available to the owner.
854      */
855     function renounceOwnership() public virtual onlyOwner {
856         _transferOwnership(address(0));
857     }
858 
859     /**
860      * @dev Transfers ownership of the contract to a new account (`newOwner`).
861      * Can only be called by the current owner.
862      */
863     function transferOwnership(address newOwner) public virtual onlyOwner {
864         require(newOwner != address(0), "Ownable: new owner is the zero address");
865         _transferOwnership(newOwner);
866     }
867 
868     /**
869      * @dev Transfers ownership of the contract to a new account (`newOwner`).
870      * Internal function without access restriction.
871      */
872     function _transferOwnership(address newOwner) internal virtual {
873         address oldOwner = _owner;
874         _owner = newOwner;
875         emit OwnershipTransferred(oldOwner, newOwner);
876     }
877 }
878 
879 
880 // File contracts/lib/Operator.sol
881 
882 
883 
884 pragma solidity 0.8.1;
885 contract Operator is Context, Ownable {
886     address private _operator;
887 
888     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
889 
890     constructor() {
891         _operator = _msgSender();
892         emit OperatorTransferred(address(0), _operator);
893     }
894 
895     function operator() public view returns (address) {
896         return _operator;
897     }
898 
899     modifier onlyOperator() {
900         require(_operator == msg.sender, "operator: caller is not the operator");
901         _;
902     }
903 
904     function isOperator() public view returns (bool) {
905         return _msgSender() == _operator;
906     }
907 
908     function transferOperator(address newOperator_) public onlyOwner {
909         _transferOperator(newOperator_);
910     }
911 
912     function _transferOperator(address newOperator_) internal {
913         require(newOperator_ != address(0), "operator: zero address given for new operator");
914         emit OperatorTransferred(address(0), newOperator_);
915         _operator = newOperator_;
916     }
917 }
918 
919 
920 // File contracts/interfaces/IOracle.sol
921 
922 
923 pragma solidity 0.8.1;
924 
925 interface IOracle {
926     function update() external;
927 
928     function consult(address _token, uint256 _amountIn) external view returns (uint144 amountOut);
929 
930     function twap(address _token, uint256 _amountIn) external view returns (uint144 _amountOut);
931 }
932 
933 
934 // File contracts/tokens/vAPE.sol
935 
936 
937 pragma solidity 0.8.1;
938 contract vApe is ERC20Burnable, Operator {
939     using SafeMath for uint8;
940     using SafeMath for uint256;
941 
942     // Initial distribution for the first 3 day genesis pools
943     uint256 public constant INITIAL_GENESIS_POOL_DISTRIBUTION = 11000 ether;
944     // Initial distribution for the vApe LP reward pools
945     uint256 public constant INITIAL_VAPE_POOL_DISTRIBUTION = 140000 ether;
946     // Distribution for airdrops wallet
947     uint256 public constant INITIAL_AIRDROP_WALLET_DISTRIBUTION = 9000 ether;
948 
949     // Have the rewards been distributed to the pools
950     bool public rewardPoolDistributed = false;
951 
952     /* ================= Taxation =============== */
953     /* ================= NOT IN USE ============= */
954     // Address of the Oracle
955     address public vapeOracle;
956     // Address of the Tax Office
957     address public taxOffice;
958 
959     // Current tax rate
960     uint256 public taxRate;
961     // Price threshold below which taxes will get burned
962     uint256 public burnThreshold = 1.10e18;
963     // Address of the tax collector wallet
964     address public taxCollectorAddress;
965 
966     // Should the taxes be calculated using the tax tiers
967     bool public autoCalculateTax;
968 
969     // Tax Tiers
970     uint256[] public taxTiersTwaps = [0, 5e17, 6e17, 7e17, 8e17, 9e17, 9.5e17, 1e18, 1.05e18, 1.10e18, 1.20e18, 1.30e18, 1.40e18, 1.50e18];
971     uint256[] public taxTiersRates = [2000, 1900, 1800, 1700, 1600, 1500, 1500, 1500, 1500, 1400, 900, 400, 200, 100];
972 
973     // Sender addresses excluded from Tax
974     mapping(address => bool) public excludedAddresses;
975 
976     event TaxOfficeTransferred(address oldAddress, address newAddress);
977 
978     modifier onlyTaxOffice() {
979         require(taxOffice == msg.sender, "Caller is not the tax office");
980         _;
981     }
982 
983     modifier onlyOperatorOrTaxOffice() {
984         require(isOperator() || taxOffice == msg.sender, "Caller is not the operator or the tax office");
985         _;
986     }
987     /* ================= NOT IN USE ============= */
988     /* ================= End Taxation =============== */
989 
990     /**
991      * @notice Constructs the Ape ERC-20 contract.
992      */
993     constructor() ERC20("vAPE", "vAPE") {
994         // Mints 2 vApe to contract creator for initial LP setup
995         excludeAddress(address(this));
996         _mint(msg.sender, 2 ether);
997         taxRate = 0;
998         taxCollectorAddress = msg.sender;
999     }
1000 
1001     /* ============= Taxation ============= */
1002     /* ============= NOT IN USE =========== */
1003 
1004     function getTaxTiersTwapsCount() public view returns (uint256 count) {
1005         return taxTiersTwaps.length;
1006     }
1007 
1008     function getTaxTiersRatesCount() public view returns (uint256 count) {
1009         return taxTiersRates.length;
1010     }
1011 
1012     function isAddressExcluded(address _address) public view returns (bool) {
1013         return excludedAddresses[_address];
1014     }
1015 
1016     function setTaxTiersTwap(uint8 _index, uint256 _value) public onlyTaxOffice returns (bool) {
1017         require(_index >= 0, "Index has to be higher than 0");
1018         require(_index < getTaxTiersTwapsCount(), "Index has to lower than count of tax tiers");
1019         if (_index > 0) {
1020             require(_value > taxTiersTwaps[_index - 1]);
1021         }
1022         if (_index < getTaxTiersTwapsCount().sub(1)) {
1023             require(_value < taxTiersTwaps[_index + 1]);
1024         }
1025         taxTiersTwaps[_index] = _value;
1026         return true;
1027     }
1028 
1029     function setTaxTiersRate(uint8 _index, uint256 _value) public onlyTaxOffice returns (bool) {
1030         require(_index >= 0, "Index has to be higher than 0");
1031         require(_index < getTaxTiersRatesCount(), "Index has to lower than count of tax tiers");
1032         taxTiersRates[_index] = _value;
1033         return true;
1034     }
1035 
1036     function setBurnThreshold(uint256 _burnThreshold) public onlyTaxOffice returns (bool) {
1037         burnThreshold = _burnThreshold;
1038         return true;
1039     }
1040 
1041     function _getVapePrice() internal view returns (uint256 _vapePrice) {
1042         try IOracle(vapeOracle).consult(address(this), 1e18) returns (uint144 _price) {
1043             return uint256(_price);
1044         } catch {
1045             revert("vApe: failed to fetch vApe price from Oracle");
1046         }
1047     }
1048 
1049     function _updateTaxRate(uint256 _vapePrice) internal returns (uint256){
1050         if (autoCalculateTax) {
1051             for (uint8 tierId = uint8(getTaxTiersTwapsCount().sub(1)); tierId >= 0; --tierId) {
1052                 if (_vapePrice >= taxTiersTwaps[tierId]) {
1053                     require(taxTiersRates[tierId] < 10000, "tax equal or bigger to 100%");
1054                     taxRate = taxTiersRates[tierId];
1055                     return taxTiersRates[tierId];
1056                 }
1057             }
1058         }
1059         return 0;
1060     }
1061 
1062     function enableAutoCalculateTax() public onlyTaxOffice {
1063         autoCalculateTax = true;
1064     }
1065 
1066     function disableAutoCalculateTax() public onlyTaxOffice {
1067         autoCalculateTax = false;
1068     }
1069 
1070     function setVapeOracle(address _vapeOracle) public onlyOperatorOrTaxOffice {
1071         require(_vapeOracle != address(0), "oracle address cannot be 0 address");
1072         vapeOracle = _vapeOracle;
1073     }
1074 
1075     function setTaxOffice(address _taxOffice) public onlyOperatorOrTaxOffice {
1076         require(_taxOffice != address(0), "tax office address cannot be 0 address");
1077         emit TaxOfficeTransferred(taxOffice, _taxOffice);
1078         taxOffice = _taxOffice;
1079     }
1080 
1081     function setTaxCollectorAddress(address _taxCollectorAddress) public onlyTaxOffice {
1082         require(_taxCollectorAddress != address(0), "tax collector address must be non-zero address");
1083         taxCollectorAddress = _taxCollectorAddress;
1084     }
1085 
1086     function setTaxRate(uint256 _taxRate) public onlyTaxOffice {
1087         require(!autoCalculateTax, "auto calculate tax cannot be enabled");
1088         require(_taxRate < 10000, "tax equal or bigger to 100%");
1089         taxRate = _taxRate;
1090     }
1091 
1092     function excludeAddress(address _address) public onlyOperatorOrTaxOffice returns (bool) {
1093         require(!excludedAddresses[_address], "address can't be excluded");
1094         excludedAddresses[_address] = true;
1095         return true;
1096     }
1097 
1098     function includeAddress(address _address) public onlyOperatorOrTaxOffice returns (bool) {
1099         require(excludedAddresses[_address], "address can't be included");
1100         excludedAddresses[_address] = false;
1101         return true;
1102     }
1103 
1104     /* ============= NOT IN USE =========== */
1105     /* ============= End Taxation ============= */
1106 
1107     /**
1108      * @notice Operator mints vApe to a recipient
1109      * @param recipient_ The address of recipient
1110      * @param amount_ The amount of vApe to mint to
1111      * @return whether the process has been done
1112      */
1113     function mint(address recipient_, uint256 amount_) public onlyOperator returns (bool) {
1114         uint256 balanceBefore = balanceOf(recipient_);
1115         _mint(recipient_, amount_);
1116         uint256 balanceAfter = balanceOf(recipient_);
1117 
1118         return balanceAfter > balanceBefore;
1119     }
1120 
1121     function burn(uint256 amount) public override {
1122         super.burn(amount);
1123     }
1124 
1125     function burnFrom(address account, uint256 amount) public override onlyOperator {
1126         super.burnFrom(account, amount);
1127     }
1128 
1129     function transferFrom(
1130         address sender,
1131         address recipient,
1132         uint256 amount
1133     ) public override returns (bool) {
1134         uint256 currentTaxRate = 0;
1135         bool burnTax = false;
1136 
1137         if (autoCalculateTax) {
1138             uint256 currentVapePrice = _getVapePrice();
1139             currentTaxRate = _updateTaxRate(currentVapePrice);
1140             if (currentVapePrice < burnThreshold) {
1141                 burnTax = true;
1142             }
1143         }
1144 
1145         if (currentTaxRate == 0 || excludedAddresses[sender]) {
1146             _transfer(sender, recipient, amount);
1147         } else {
1148             _transferWithTax(sender, recipient, amount, burnTax);
1149         }
1150 
1151         _approve(sender, _msgSender(), allowance(sender, _msgSender()).sub(amount, "ERC20: transfer amount exceeds allowance"));
1152         return true;
1153     }
1154 
1155     function _transferWithTax(
1156         address sender,
1157         address recipient,
1158         uint256 amount,
1159         bool burnTax
1160     ) internal returns (bool) {
1161         uint256 taxAmount = amount.mul(taxRate).div(10000);
1162         uint256 amountAfterTax = amount.sub(taxAmount);
1163 
1164         if(burnTax) {
1165             // Burn tax
1166             super.burnFrom(sender, taxAmount);
1167         } else {
1168             // Transfer tax to tax collector
1169             _transfer(sender, taxCollectorAddress, taxAmount);
1170         }
1171 
1172         // Transfer amount after tax to recipient
1173         _transfer(sender, recipient, amountAfterTax);
1174 
1175         return true;
1176     }
1177 
1178     /**
1179      * @notice distribute to reward pool (only once)
1180      */
1181     function distributeReward(
1182         address _genesisPool,
1183         address _vapePool,
1184         address _airdropWallet
1185     ) external onlyOperator {
1186         require(!rewardPoolDistributed, "only can distribute once");
1187         require(_genesisPool != address(0), "!_genesisPool");
1188         require(_vapePool != address(0), "!_vapePool");
1189         require(_airdropWallet != address(0), "!_airdropWallet");
1190         rewardPoolDistributed = true;
1191         _mint(_genesisPool, INITIAL_GENESIS_POOL_DISTRIBUTION);
1192         _mint(_vapePool, INITIAL_VAPE_POOL_DISTRIBUTION);
1193         _mint(_airdropWallet, INITIAL_AIRDROP_WALLET_DISTRIBUTION);
1194     }
1195 
1196     function governanceRecoverUnsupported(
1197         IERC20 _token,
1198         uint256 _amount,
1199         address _to
1200     ) external onlyOperator {
1201         _token.transfer(_to, _amount);
1202     }
1203 }