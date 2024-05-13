1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-19
3 */
4 
5 // Sources flattened with hardhat v2.9.1 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.0
8 
9 
10 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 // CAUTION
15 // This version of SafeMath should only be used with Solidity 0.8 or later,
16 // because it relies on the compiler's built in overflow checks.
17 
18 /**
19  * @dev Wrappers over Solidity's arithmetic operations.
20  *
21  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
22  * now has built in overflow checking.
23  */
24 library SafeMath {
25     /**
26      * @dev Returns the addition of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._ 
29      */
30     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             uint256 c = a + b;
33             if (c < a) return (false, 0);
34             return (true, c);
35         }
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
40      *
41      * _Available since v3.4._
42      */
43     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
44         unchecked {
45             if (b > a) return (false, 0);
46             return (true, a - b);
47         }
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
52      *
53      * _Available since v3.4._
54      */
55     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
56         unchecked {
57             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
58             // benefit is lost if 'b' is also tested.
59             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
60             if (a == 0) return (true, 0);
61             uint256 c = a * b;
62             if (c / a != b) return (false, 0);
63             return (true, c);
64         }
65     }
66 
67     /**
68      * @dev Returns the division of two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         unchecked {
74             if (b == 0) return (false, 0);
75             return (true, a / b);
76         }
77     }
78 
79     /**
80      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
81      *
82      * _Available since v3.4._
83      */
84     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
85         unchecked {
86             if (b == 0) return (false, 0);
87             return (true, a % b);
88         }
89     }
90 
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      *
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         return a + b;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return a - b;
117     }
118 
119     /**
120      * @dev Returns the multiplication of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `*` operator.
124      *
125      * Requirements:
126      *
127      * - Multiplication cannot overflow.
128      */
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a * b;
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers, reverting on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator.
138      *
139      * Requirements:
140      *
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return a / b;
145     }
146 
147     /**
148      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
149      * reverting when dividing by zero.
150      *
151      * Counterpart to Solidity's `%` operator. This function uses a `revert`
152      * opcode (which leaves remaining gas untouched) while Solidity uses an
153      * invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a % b;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * CAUTION: This function is deprecated because it requires allocating memory for the error
168      * message unnecessarily. For custom revert reasons use {trySub}.
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(
177         uint256 a,
178         uint256 b,
179         string memory errorMessage
180     ) internal pure returns (uint256) {
181         unchecked {
182             require(b <= a, errorMessage);
183             return a - b;
184         }
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(
200         uint256 a,
201         uint256 b,
202         string memory errorMessage
203     ) internal pure returns (uint256) {
204         unchecked {
205             require(b > 0, errorMessage);
206             return a / b;
207         }
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * reverting with custom message when dividing by zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryMod}.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(
226         uint256 a,
227         uint256 b,
228         string memory errorMessage
229     ) internal pure returns (uint256) {
230         unchecked {
231             require(b > 0, errorMessage);
232             return a % b;
233         }
234     }
235 }
236 
237 
238 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
239 
240 
241 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Interface of the ERC20 standard as defined in the EIP.
247  */
248 interface IERC20 {
249     /**
250      * @dev Emitted when `value` tokens are moved from one account (`from`) to
251      * another (`to`).
252      *
253      * Note that `value` may be zero.
254      */
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     /**
258      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
259      * a call to {approve}. `value` is the new allowance.
260      */
261     event Approval(address indexed owner, address indexed spender, uint256 value);
262 
263     /**
264      * @dev Returns the amount of tokens in existence.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     /**
269      * @dev Returns the amount of tokens owned by `account`.
270      */
271     function balanceOf(address account) external view returns (uint256);
272 
273     /**
274      * @dev Moves `amount` tokens from the caller's account to `to`.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transfer(address to, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Returns the remaining number of tokens that `spender` will be
284      * allowed to spend on behalf of `owner` through {transferFrom}. This is
285      * zero by default.
286      *
287      * This value changes when {approve} or {transferFrom} are called.
288      */
289     function allowance(address owner, address spender) external view returns (uint256);
290 
291     /**
292      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * IMPORTANT: Beware that changing an allowance with this method brings the risk
297      * that someone may use both the old and the new allowance by unfortunate
298      * transaction ordering. One possible solution to mitigate this race
299      * condition is to first reduce the spender's allowance to 0 and set the
300      * desired value afterwards:
301      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address spender, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Moves `amount` tokens from `from` to `to` using the
309      * allowance mechanism. `amount` is then deducted from the caller's
310      * allowance.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address from,
318         address to,
319         uint256 amount
320     ) external returns (bool);
321 }
322 
323 
324 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.7.0
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface for the optional metadata functions from the ERC20 standard.
333  *
334  * _Available since v4.1._
335  */
336 interface IERC20Metadata is IERC20 {
337     /**
338      * @dev Returns the name of the token.
339      */
340     function name() external view returns (string memory);
341 
342     /**
343      * @dev Returns the symbol of the token.
344      */
345     function symbol() external view returns (string memory);
346 
347     /**
348      * @dev Returns the decimals places of the token.
349      */
350     function decimals() external view returns (uint8);
351 }
352 
353 
354 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @dev Provides information about the current execution context, including the
363  * sender of the transaction and its data. While these are generally available
364  * via msg.sender and msg.data, they should not be accessed in such a direct
365  * manner, since when dealing with meta-transactions the account sending and
366  * paying for execution may not be the actual sender (as far as an application
367  * is concerned).
368  *
369  * This contract is only required for intermediate, library-like contracts.
370  */
371 abstract contract Context {
372     function _msgSender() internal view virtual returns (address) {
373         return msg.sender;
374     }
375 
376     function _msgData() internal view virtual returns (bytes calldata) {
377         return msg.data;
378     }
379 }
380 
381 
382 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.7.0
383 
384 
385 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 
391 /**
392  * @dev Implementation of the {IERC20} interface.
393  *
394  * This implementation is agnostic to the way tokens are created. This means
395  * that a supply mechanism has to be added in a derived contract using {_mint}.
396  * For a generic mechanism see {ERC20PresetMinterPauser}.
397  *
398  * TIP: For a detailed writeup see our guide
399  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
400  * to implement supply mechanisms].
401  *
402  * We have followed general OpenZeppelin Contracts guidelines: functions revert
403  * instead returning `false` on failure. This behavior is nonetheless
404  * conventional and does not conflict with the expectations of ERC20
405  * applications.
406  *
407  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
408  * This allows applications to reconstruct the allowance for all accounts just
409  * by listening to said events. Other implementations of the EIP may not emit
410  * these events, as it isn't required by the specification.
411  *
412  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
413  * functions have been added to mitigate the well-known issues around setting
414  * allowances. See {IERC20-approve}.
415  */
416 contract ERC20 is Context, IERC20, IERC20Metadata {
417     mapping(address => uint256) private _balances;
418 
419     mapping(address => mapping(address => uint256)) private _allowances;
420 
421     uint256 private _totalSupply;
422 
423     string private _name;
424     string private _symbol;
425 
426     /**
427      * @dev Sets the values for {name} and {symbol}.
428      *
429      * The default value of {decimals} is 18. To select a different value for
430      * {decimals} you should overload it.
431      *
432      * All two of these values are immutable: they can only be set once during
433      * construction.
434      */
435     constructor(string memory name_, string memory symbol_) {
436         _name = name_;
437         _symbol = symbol_;
438     }
439 
440     /**
441      * @dev Returns the name of the token.
442      */
443     function name() public view virtual override returns (string memory) {
444         return _name;
445     }
446 
447     /**
448      * @dev Returns the symbol of the token, usually a shorter version of the
449      * name.
450      */
451     function symbol() public view virtual override returns (string memory) {
452         return _symbol;
453     }
454 
455     /**
456      * @dev Returns the number of decimals used to get its user representation.
457      * For example, if `decimals` equals `2`, a balance of `505` tokens should
458      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
459      *
460      * Tokens usually opt for a value of 18, imitating the relationship between
461      * Ether and Wei. This is the value {ERC20} uses, unless this function is
462      * overridden;
463      *
464      * NOTE: This information is only used for _display_ purposes: it in
465      * no way affects any of the arithmetic of the contract, including
466      * {IERC20-balanceOf} and {IERC20-transfer}.
467      */
468     function decimals() public view virtual override returns (uint8) {
469         return 18;
470     }
471 
472     /**
473      * @dev See {IERC20-totalSupply}.
474      */
475     function totalSupply() public view virtual override returns (uint256) {
476         return _totalSupply;
477     }
478 
479     /**
480      * @dev See {IERC20-balanceOf}.
481      */
482     function balanceOf(address account) public view virtual override returns (uint256) {
483         return _balances[account];
484     }
485 
486     /**
487      * @dev See {IERC20-transfer}.
488      *
489      * Requirements:
490      *
491      * - `to` cannot be the zero address.
492      * - the caller must have a balance of at least `amount`.
493      */
494     function transfer(address to, uint256 amount) public virtual override returns (bool) {
495         address owner = _msgSender();
496         _transfer(owner, to, amount);
497         return true;
498     }
499 
500     /**
501      * @dev See {IERC20-allowance}.
502      */
503     function allowance(address owner, address spender) public view virtual override returns (uint256) {
504         return _allowances[owner][spender];
505     }
506 
507     /**
508      * @dev See {IERC20-approve}.
509      *
510      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
511      * `transferFrom`. This is semantically equivalent to an infinite approval.
512      *
513      * Requirements:
514      *
515      * - `spender` cannot be the zero address.
516      */
517     function approve(address spender, uint256 amount) public virtual override returns (bool) {
518         address owner = _msgSender();
519         _approve(owner, spender, amount);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-transferFrom}.
525      *
526      * Emits an {Approval} event indicating the updated allowance. This is not
527      * required by the EIP. See the note at the beginning of {ERC20}.
528      *
529      * NOTE: Does not update the allowance if the current allowance
530      * is the maximum `uint256`.
531      *
532      * Requirements:
533      *
534      * - `from` and `to` cannot be the zero address.
535      * - `from` must have a balance of at least `amount`.
536      * - the caller must have allowance for ``from``'s tokens of at least
537      * `amount`.
538      */
539     function transferFrom(
540         address from,
541         address to,
542         uint256 amount
543     ) public virtual override returns (bool) {
544         address spender = _msgSender();
545         _spendAllowance(from, spender, amount);
546         _transfer(from, to, amount);
547         return true;
548     }
549 
550     /**
551      * @dev Atomically increases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
563         address owner = _msgSender();
564         _approve(owner, spender, allowance(owner, spender) + addedValue);
565         return true;
566     }
567 
568     /**
569      * @dev Atomically decreases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      * - `spender` must have allowance for the caller of at least
580      * `subtractedValue`.
581      */
582     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
583         address owner = _msgSender();
584         uint256 currentAllowance = allowance(owner, spender);
585         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
586         unchecked {
587             _approve(owner, spender, currentAllowance - subtractedValue);
588         }
589 
590         return true;
591     }
592 
593     /**
594      * @dev Moves `amount` of tokens from `from` to `to`.
595      *
596      * This internal function is equivalent to {transfer}, and can be used to
597      * e.g. implement automatic token fees, slashing mechanisms, etc.
598      *
599      * Emits a {Transfer} event.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `from` must have a balance of at least `amount`.
606      */
607     function _transfer(
608         address from,
609         address to,
610         uint256 amount
611     ) internal virtual {
612         require(from != address(0), "ERC20: transfer from the zero address");
613         require(to != address(0), "ERC20: transfer to the zero address");
614 
615         _beforeTokenTransfer(from, to, amount);
616 
617         uint256 fromBalance = _balances[from];
618         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
619         unchecked {
620             _balances[from] = fromBalance - amount;
621         }
622         _balances[to] += amount;
623 
624         emit Transfer(from, to, amount);
625 
626         _afterTokenTransfer(from, to, amount);
627     }
628 
629     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
630      * the total supply.
631      *
632      * Emits a {Transfer} event with `from` set to the zero address.
633      *
634      * Requirements:
635      *
636      * - `account` cannot be the zero address.
637      */
638     function _mint(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: mint to the zero address");
640 
641         _beforeTokenTransfer(address(0), account, amount);
642 
643         _totalSupply += amount;
644         _balances[account] += amount;
645         emit Transfer(address(0), account, amount);
646 
647         _afterTokenTransfer(address(0), account, amount);
648     }
649 
650     /**
651      * @dev Destroys `amount` tokens from `account`, reducing the
652      * total supply.
653      *
654      * Emits a {Transfer} event with `to` set to the zero address.
655      *
656      * Requirements:
657      *
658      * - `account` cannot be the zero address.
659      * - `account` must have at least `amount` tokens.
660      */
661     function _burn(address account, uint256 amount) internal virtual {
662         require(account != address(0), "ERC20: burn from the zero address");
663 
664         _beforeTokenTransfer(account, address(0), amount);
665 
666         uint256 accountBalance = _balances[account];
667         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
668         unchecked {
669             _balances[account] = accountBalance - amount;
670         }
671         _totalSupply -= amount;
672 
673         emit Transfer(account, address(0), amount);
674 
675         _afterTokenTransfer(account, address(0), amount);
676     }
677 
678     /**
679      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
680      *
681      * This internal function is equivalent to `approve`, and can be used to
682      * e.g. set automatic allowances for certain subsystems, etc.
683      *
684      * Emits an {Approval} event.
685      *
686      * Requirements:
687      *
688      * - `owner` cannot be the zero address.
689      * - `spender` cannot be the zero address.
690      */
691     function _approve(
692         address owner,
693         address spender,
694         uint256 amount
695     ) internal virtual {
696         require(owner != address(0), "ERC20: approve from the zero address");
697         require(spender != address(0), "ERC20: approve to the zero address");
698 
699         _allowances[owner][spender] = amount;
700         emit Approval(owner, spender, amount);
701     }
702 
703     /**
704      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
705      *
706      * Does not update the allowance amount in case of infinite allowance.
707      * Revert if not enough allowance is available.
708      *
709      * Might emit an {Approval} event.
710      */
711     function _spendAllowance(
712         address owner,
713         address spender,
714         uint256 amount
715     ) internal virtual {
716         uint256 currentAllowance = allowance(owner, spender);
717         if (currentAllowance != type(uint256).max) {
718             require(currentAllowance >= amount, "ERC20: insufficient allowance");
719             unchecked {
720                 _approve(owner, spender, currentAllowance - amount);
721             }
722         }
723     }
724 
725     /**
726      * @dev Hook that is called before any transfer of tokens. This includes
727      * minting and burning.
728      *
729      * Calling conditions:
730      *
731      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
732      * will be transferred to `to`.
733      * - when `from` is zero, `amount` tokens will be minted for `to`.
734      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
735      * - `from` and `to` are never both zero.
736      *
737      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
738      */
739     function _beforeTokenTransfer(
740         address from,
741         address to,
742         uint256 amount
743     ) internal virtual {}
744 
745     /**
746      * @dev Hook that is called after any transfer of tokens. This includes
747      * minting and burning.
748      *
749      * Calling conditions:
750      *
751      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
752      * has been transferred to `to`.
753      * - when `from` is zero, `amount` tokens have been minted for `to`.
754      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
755      * - `from` and `to` are never both zero.
756      *
757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
758      */
759     function _afterTokenTransfer(
760         address from,
761         address to,
762         uint256 amount
763     ) internal virtual {}
764 }
765 
766 
767 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 /**
775  * @dev Interface of the ERC165 standard, as defined in the
776  * https://eips.ethereum.org/EIPS/eip-165[EIP].
777  *
778  * Implementers can declare support of contract interfaces, which can then be
779  * queried by others ({ERC165Checker}).
780  *
781  * For an implementation, see {ERC165}.
782  */
783 interface IERC165 {
784     /**
785      * @dev Returns true if this contract implements the interface defined by
786      * `interfaceId`. See the corresponding
787      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
788      * to learn more about how these ids are created.
789      *
790      * This function call must use less than 30 000 gas.
791      */
792     function supportsInterface(bytes4 interfaceId) external view returns (bool);
793 }
794 
795 
796 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.0
797 
798 
799 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev _Available since v3.1._
805  */
806 interface IERC1155Receiver is IERC165 {
807     /**
808      * @dev Handles the receipt of a single ERC1155 token type. This function is
809      * called at the end of a `safeTransferFrom` after the balance has been updated.
810      *
811      * NOTE: To accept the transfer, this must return
812      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
813      * (i.e. 0xf23a6e61, or its own function selector).
814      *
815      * @param operator The address which initiated the transfer (i.e. msg.sender)
816      * @param from The address which previously owned the token
817      * @param id The ID of the token being transferred
818      * @param value The amount of tokens being transferred
819      * @param data Additional data with no specified format
820      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
821      */
822     function onERC1155Received(
823         address operator,
824         address from,
825         uint256 id,
826         uint256 value,
827         bytes calldata data
828     ) external returns (bytes4);
829 
830     /**
831      * @dev Handles the receipt of a multiple ERC1155 token types. This function
832      * is called at the end of a `safeBatchTransferFrom` after the balances have
833      * been updated.
834      *
835      * NOTE: To accept the transfer(s), this must return
836      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
837      * (i.e. 0xbc197c81, or its own function selector).
838      *
839      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
840      * @param from The address which previously owned the token
841      * @param ids An array containing ids of each token being transferred (order and length must match values array)
842      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
843      * @param data Additional data with no specified format
844      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
845      */
846     function onERC1155BatchReceived(
847         address operator,
848         address from,
849         uint256[] calldata ids,
850         uint256[] calldata values,
851         bytes calldata data
852     ) external returns (bytes4);
853 }
854 
855 
856 // File @chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol@v0.4.1
857 
858 
859 pragma solidity ^0.8.0;
860 
861 interface AggregatorV3Interface {
862   function decimals() external view returns (uint8);
863 
864   function description() external view returns (string memory);
865 
866   function version() external view returns (uint256);
867 
868   // getRoundData and latestRoundData should both raise "No data present"
869   // if they do not have data to report, instead of returning unset values
870   // which could be misinterpreted as actual reported values.
871   function getRoundData(uint80 _roundId)
872     external
873     view
874     returns (
875       uint80 roundId,
876       int256 answer,
877       uint256 startedAt,
878       uint256 updatedAt,
879       uint80 answeredInRound
880     );
881 
882   function latestRoundData()
883     external
884     view
885     returns (
886       uint80 roundId,
887       int256 answer,
888       uint256 startedAt,
889       uint256 updatedAt,
890       uint80 answeredInRound
891     );
892 }
893 
894 
895 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
896 
897 
898 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 /**
903  * @dev Contract module which provides a basic access control mechanism, where
904  * there is an account (an owner) that can be granted exclusive access to
905  * specific functions.
906  *
907  * By default, the owner account will be the one that deploys the contract. This
908  * can later be changed with {transferOwnership}.
909  *
910  * This module is used through inheritance. It will make available the modifier
911  * `onlyOwner`, which can be applied to your functions to restrict their use to
912  * the owner.
913  */
914 abstract contract Ownable is Context {
915     address private _owner;
916 
917     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
918 
919     /**
920      * @dev Initializes the contract setting the deployer as the initial owner.
921      */
922     constructor() {
923         _transferOwnership(_msgSender());
924     }
925 
926     /**
927      * @dev Throws if called by any account other than the owner.
928      */
929     modifier onlyOwner() {
930         _checkOwner();
931         _;
932     }
933 
934     /**
935      * @dev Returns the address of the current owner.
936      */
937     function owner() public view virtual returns (address) {
938         return _owner;
939     }
940 
941     /**
942      * @dev Throws if the sender is not the owner.
943      */
944     function _checkOwner() internal view virtual {
945         require(owner() == _msgSender(), "Ownable: caller is not the owner");
946     }
947 
948     /**
949      * @dev Leaves the contract without owner. It will not be possible to call
950      * `onlyOwner` functions anymore. Can only be called by the current owner.
951      *
952      * NOTE: Renouncing ownership will leave the contract without an owner,
953      * thereby removing any functionality that is only available to the owner.
954      */
955     function renounceOwnership() public virtual onlyOwner {
956         _transferOwnership(address(0));
957     }
958 
959     /**
960      * @dev Transfers ownership of the contract to a new account (`newOwner`).
961      * Can only be called by the current owner.
962      */
963     function transferOwnership(address newOwner) public virtual onlyOwner {
964         require(newOwner != address(0), "Ownable: new owner is the zero address");
965         _transferOwnership(newOwner);
966     }
967 
968     /**
969      * @dev Transfers ownership of the contract to a new account (`newOwner`).
970      * Internal function without access restriction.
971      */
972     function _transferOwnership(address newOwner) internal virtual {
973         address oldOwner = _owner;
974         _owner = newOwner;
975         emit OwnershipTransferred(oldOwner, newOwner);
976     }
977 }
978 
979 
980 // File contracts/JAY.sol
981 
982 //SPDX-License-Identifier: MIT
983 pragma solidity ^0.8.0;
984 
985 
986 
987 interface IERC721 {
988     function safeTransferFrom(
989         address from,
990         address to,
991         uint256 tokenId
992     ) external;
993 
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) external;
999 }
1000 
1001 interface IERC1155 {
1002     function safeTransferFrom(
1003         address from,
1004         address to,
1005         uint256 id,
1006         uint256 amount,
1007         bytes calldata data
1008     ) external;
1009 }
1010 
1011 contract JAY is ERC20, Ownable {
1012     using SafeMath for uint256;
1013     AggregatorV3Interface internal priceFeed;
1014 
1015     address private dev;
1016     uint256 public constant MIN = 1000;
1017     bool private start = false;
1018     bool private lockDev = false;
1019 
1020     uint256 private nftsBought;
1021     uint256 private nftsSold;
1022 
1023     uint256 private buyNftFeeEth = 0.01 * 10**18;
1024     uint256 private buyNftFeeJay = 10 * 10**18;
1025 
1026     uint256 private sellNftFeeEth = 0.001 * 10**18;
1027 
1028     uint256 private constant USD_PRICE_SELL = 2 * 10**18;
1029     uint256 private constant USD_PRICE_BUY = 10 * 10**18;
1030 
1031     uint256 private nextFeeUpdate = block.timestamp.add(7 days);
1032 
1033     event Price(uint256 time, uint256 price);
1034 
1035     constructor() payable ERC20("JayPeggers", "JAY") {
1036         require(msg.value == 2 * 10**18);
1037         dev = msg.sender;
1038         _mint(msg.sender, 2 * 10**18 * MIN);
1039         emit Price(block.timestamp, JAYtoETH(1 * 10**18));
1040         priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419); //main
1041     }
1042 
1043     function updateDevWallet(address _address) public onlyOwner {
1044         require(lockDev == false);
1045         dev = _address;
1046     }
1047     function lockDevWallet() public onlyOwner {
1048         lockDev = true;
1049     }
1050 
1051     function startJay() public onlyOwner {
1052         start = true;
1053     }
1054 
1055     // Buy NFTs from Vault
1056     function buyNFTs(
1057         address[] calldata erc721TokenAddress,
1058         uint256[] calldata erc721Ids,
1059         address[] calldata erc1155TokenAddress,
1060         uint256[] calldata erc1155Ids,
1061         uint256[] calldata erc1155Amounts
1062     ) public payable {
1063         uint256 total = erc721TokenAddress.length;
1064         if (total != 0) buyERC721(erc721TokenAddress, erc721Ids);
1065 
1066         if (erc1155TokenAddress.length != 0)
1067             total = total.add(
1068                 buyERC1155(erc1155TokenAddress, erc1155Ids, erc1155Amounts)
1069             );
1070 
1071         require(
1072             msg.value >= (total).mul(buyNftFeeEth),
1073             "You need to pay ETH more"
1074         );
1075         (bool success, ) = dev.call{value: msg.value.div(2)}("");
1076         require(success, "ETH Transfer failed.");
1077         _burn(msg.sender, total.mul(buyNftFeeJay));
1078         nftsBought += total;
1079 
1080         emit Price(block.timestamp, JAYtoETH(1 * 10**18));
1081     }
1082 
1083     function buyERC721(address[] calldata _tokenAddress, uint256[] calldata ids)
1084         internal
1085     {
1086         for (uint256 id = 0; id < ids.length; id++) {
1087             IERC721(_tokenAddress[id]).safeTransferFrom(
1088                 address(this),
1089                 msg.sender,
1090                 ids[id]
1091             );
1092         }
1093     }
1094 
1095     function buyERC1155(
1096         address[] calldata _tokenAddress,
1097         uint256[] calldata ids,
1098         uint256[] calldata amounts
1099     ) internal returns (uint256) {
1100         uint256 amount = 0;
1101         for (uint256 id = 0; id < ids.length; id++) {
1102             amount = amount.add(amounts[id]);
1103             IERC1155(_tokenAddress[id]).safeTransferFrom(
1104                 address(this),
1105                 msg.sender,
1106                 ids[id],
1107                 amounts[id],
1108                 ""
1109             );
1110         }
1111         return amount;
1112     }
1113 
1114     // Sell NFTs (Buy Jay)
1115     function buyJay(
1116         address[] calldata erc721TokenAddress,
1117         uint256[] calldata erc721Ids,
1118         address[] calldata erc1155TokenAddress,
1119         uint256[] calldata erc1155Ids,
1120         uint256[] calldata erc1155Amounts
1121     ) public payable {
1122         require(start, "Not started!");
1123         uint256 total = erc721TokenAddress.length;
1124         if (total != 0) buyJayWithERC721(erc721TokenAddress, erc721Ids);
1125 
1126         if (erc1155TokenAddress.length != 0)
1127             total = total.add(
1128                 buyJayWithERC1155(
1129                     erc1155TokenAddress,
1130                     erc1155Ids,
1131                     erc1155Amounts
1132                 )
1133             );
1134 
1135         if (total >= 100)
1136             require(
1137                 msg.value >= (total).mul(sellNftFeeEth).div(2),
1138                 "You need to pay ETH more"
1139             );
1140         else
1141             require(
1142                 msg.value >= (total).mul(sellNftFeeEth),
1143                 "You need to pay ETH more"
1144             );
1145 
1146         _mint(msg.sender, ETHtoJAY(msg.value).mul(97).div(100));
1147 
1148         (bool success, ) = dev.call{value: msg.value.div(34)}("");
1149         require(success, "ETH Transfer failed.");
1150 
1151         nftsSold += total;
1152 
1153         emit Price(block.timestamp, JAYtoETH(1 * 10**18));
1154     }
1155 
1156     function buyJayWithERC721(
1157         address[] calldata _tokenAddress,
1158         uint256[] calldata ids
1159     ) internal {
1160         for (uint256 id = 0; id < ids.length; id++) {
1161             IERC721(_tokenAddress[id]).transferFrom(
1162                 msg.sender,
1163                 address(this),
1164                 ids[id]
1165             );
1166         }
1167     }
1168 
1169     function buyJayWithERC1155(
1170         address[] calldata _tokenAddress,
1171         uint256[] calldata ids,
1172         uint256[] calldata amounts
1173     ) internal returns (uint256) {
1174         uint256 amount = 0;
1175         for (uint256 id = 0; id < ids.length; id++) {
1176             amount = amount.add(amounts[id]);
1177             IERC1155(_tokenAddress[id]).safeTransferFrom(
1178                 msg.sender,
1179                 address(this),
1180                 ids[id],
1181                 amounts[id],
1182                 ""
1183             );
1184         }
1185         return amount;
1186     }
1187 
1188     // Sell Jay
1189     function sell(uint256 value) public {
1190         require(value > MIN, "Dude tf");
1191 
1192         uint256 eth = JAYtoETH(value);
1193         _burn(msg.sender, value);
1194 
1195         (bool success, ) = msg.sender.call{value: eth.mul(90).div(100)}("");
1196         require(success, "ETH Transfer failed.");
1197         (bool success2, ) = dev.call{value: eth.div(33)}("");
1198         require(success2, "ETH Transfer failed.");
1199 
1200         emit Price(block.timestamp, JAYtoETH(1 * 10**18));
1201     }
1202 
1203     // Buy Jay (No NFT)
1204     function buyJayNoNFT() public payable {
1205         require(msg.value > MIN, "must trade over min");
1206         require(start, "Not started!");
1207 
1208         _mint(msg.sender, ETHtoJAY(msg.value).mul(85).div(100));
1209 
1210         (bool success, ) = dev.call{value: msg.value.div(20)}("");
1211         require(success, "ETH Transfer failed.");
1212 
1213         emit Price(block.timestamp, JAYtoETH(1 * 10**18));
1214     }
1215 
1216     //utils
1217     function getBuyJayNoNFT(uint256 amount) public view returns (uint256) {
1218         return
1219             amount.mul(totalSupply()).div(address(this).balance).mul(85).div(
1220                 100
1221             );
1222     }
1223 
1224     function getBuyJayNFT(uint256 amount) public view returns (uint256) {
1225         return
1226             amount.mul(totalSupply()).div(address(this).balance).mul(97).div(
1227                 100
1228             );
1229     }
1230 
1231     function JAYtoETH(uint256 value) public view returns (uint256) {
1232         return (value * address(this).balance).div(totalSupply());
1233     }
1234 
1235     function ETHtoJAY(uint256 value) public view returns (uint256) {
1236         return value.mul(totalSupply()).div(address(this).balance.sub(value));
1237     }
1238 
1239     // chainlink pricefeed / fee updater
1240     function getFees()
1241         public
1242         view
1243         returns (
1244             uint256,
1245             uint256,
1246             uint256,
1247             uint256
1248         )
1249     {
1250         return (sellNftFeeEth, buyNftFeeEth, buyNftFeeJay, nextFeeUpdate);
1251     }
1252 
1253     function getTotals()
1254         public
1255         view
1256         returns (
1257             uint256,
1258             uint256
1259         )
1260     {
1261         return (nftsBought, nftsSold);
1262     }
1263 
1264 
1265     function updateFees()
1266         public
1267         returns (
1268             uint256,
1269             uint256,
1270             uint256,
1271             uint256
1272         )
1273     {
1274         (
1275             uint80 roundID,
1276             int256 price,
1277             uint256 startedAt,
1278             uint256 timeStamp,
1279             uint80 answeredInRound
1280         ) = priceFeed.latestRoundData();
1281         uint256 _price = uint256(price).mul(1 * 10**10);
1282         require(
1283             timeStamp > nextFeeUpdate,
1284             "Fee update every 24 hrs"
1285         );
1286 
1287         uint256 _sellNftFeeEth;
1288         if (_price > USD_PRICE_SELL) {
1289             uint256 _p = _price.div(USD_PRICE_SELL);
1290             _sellNftFeeEth = uint256(1 * 10**18).div(_p);
1291         } else {
1292             _sellNftFeeEth = USD_PRICE_SELL.div(_price);
1293         }
1294 
1295         require(
1296             owner() == msg.sender ||
1297                 (sellNftFeeEth.div(2) < _sellNftFeeEth &&
1298                     sellNftFeeEth.mul(150) > _sellNftFeeEth),
1299             "Fee swing too high"
1300         );
1301 
1302         sellNftFeeEth = _sellNftFeeEth;
1303 
1304         if (_price > USD_PRICE_BUY) {
1305             uint256 _p = _price.div(USD_PRICE_BUY);
1306             buyNftFeeEth = uint256(1 * 10**18).div(_p);
1307         } else {
1308             buyNftFeeEth = USD_PRICE_BUY.div(_price);
1309         }
1310         buyNftFeeJay = ETHtoJAY(buyNftFeeEth);
1311 
1312         nextFeeUpdate = timeStamp.add(24 hours);
1313         return (sellNftFeeEth, buyNftFeeEth, buyNftFeeJay, nextFeeUpdate);
1314     }
1315 
1316     function getLatestPrice() public view returns (int256) {
1317         (
1318             uint80 roundID,
1319             int256 price,
1320             uint256 startedAt,
1321             uint256 timeStamp,
1322             uint80 answeredInRound
1323         ) = priceFeed.latestRoundData();
1324         return price;
1325     }
1326 
1327     //receiver helpers
1328     function deposit() public payable {}
1329 
1330     receive() external payable {}
1331 
1332     fallback() external payable {}
1333 
1334     function onERC1155Received(
1335         address,
1336         address from,
1337         uint256 id,
1338         uint256 amount,
1339         bytes calldata data
1340     ) external pure returns (bytes4) {
1341         return IERC1155Receiver.onERC1155Received.selector;
1342     }
1343 }