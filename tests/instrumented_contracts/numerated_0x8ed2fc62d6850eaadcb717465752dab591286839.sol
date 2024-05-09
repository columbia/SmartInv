1 /**
2 
3 Step into the Future with Project E L Y S S A!
4 
5 Elyssa is a groundbreaking initiative that aims to revolutionize
6 DeSci, Digital Assets and Education through its innovative Augmented Reality applications.
7 
8 Website: http://elyssa.io
9 Telegram: https://t.me/ElyssaAR
10 Twitter: https://twitter.com/ElyssaAR
11 
12  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
13  */
14 
15 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
16 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
17 
18 pragma solidity ^0.8.17;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Emitted when `value` tokens are moved from one account (`from`) to
26      * another (`to`).
27      *
28      * Note that `value` may be zero.
29      */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /**
33      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
34      * a call to {approve}. `value` is the new allowance.
35      */
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `to`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address to, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * ////IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `from` to `to` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address from, address to, uint256 amount) external returns (bool);
92 }
93 
94 /**
95  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
96  */
97 
98 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
99 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 /**
122  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
123  */
124 
125 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
126 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
127 
128 ////import "../IERC20.sol";
129 
130 /**
131  * @dev Interface for the optional metadata functions from the ERC20 standard.
132  *
133  * _Available since v4.1._
134  */
135 interface IERC20Metadata is IERC20 {
136     /**
137      * @dev Returns the name of the token.
138      */
139     function name() external view returns (string memory);
140 
141     /**
142      * @dev Returns the symbol of the token.
143      */
144     function symbol() external view returns (string memory);
145 
146     /**
147      * @dev Returns the decimals places of the token.
148      */
149     function decimals() external view returns (uint8);
150 }
151 
152 /**
153  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
154  */
155 
156 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
157 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
158 
159 ////import "./IERC20.sol";
160 ////import "./extensions/IERC20Metadata.sol";
161 ////import "../../utils/Context.sol";
162 
163 /**
164  * @dev Implementation of the {IERC20} interface.
165  *
166  * This implementation is agnostic to the way tokens are created. This means
167  * that a supply mechanism has to be added in a derived contract using {_mint}.
168  * For a generic mechanism see {ERC20PresetMinterPauser}.
169  *
170  * TIP: For a detailed writeup see our guide
171  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
172  * to implement supply mechanisms].
173  *
174  * We have followed general OpenZeppelin Contracts guidelines: functions revert
175  * instead returning `false` on failure. This behavior is nonetheless
176  * conventional and does not conflict with the expectations of ERC20
177  * applications.
178  *
179  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
180  * This allows applications to reconstruct the allowance for all accounts just
181  * by listening to said events. Other implementations of the EIP may not emit
182  * these events, as it isn't required by the specification.
183  *
184  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
185  * functions have been added to mitigate the well-known issues around setting
186  * allowances. See {IERC20-approve}.
187  */
188 contract ERC20 is Context, IERC20, IERC20Metadata {
189     mapping(address => uint256) private _balances;
190 
191     mapping(address => mapping(address => uint256)) private _allowances;
192 
193     uint256 private _totalSupply;
194 
195     string private _name;
196     string private _symbol;
197 
198     /**
199      * @dev Sets the values for {name} and {symbol}.
200      *
201      * The default value of {decimals} is 18. To select a different value for
202      * {decimals} you should overload it.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the value {ERC20} uses, unless this function is
234      * overridden;
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account) public view virtual override returns (uint256) {
255         return _balances[account];
256     }
257 
258     /**
259      * @dev See {IERC20-transfer}.
260      *
261      * Requirements:
262      *
263      * - `to` cannot be the zero address.
264      * - the caller must have a balance of at least `amount`.
265      */
266     function transfer(address to, uint256 amount) public virtual override returns (bool) {
267         address owner = _msgSender();
268         _transfer(owner, to, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-allowance}.
274      */
275     function allowance(address owner, address spender) public view virtual override returns (uint256) {
276         return _allowances[owner][spender];
277     }
278 
279     /**
280      * @dev See {IERC20-approve}.
281      *
282      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
283      * `transferFrom`. This is semantically equivalent to an infinite approval.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         address owner = _msgSender();
291         _approve(owner, spender, amount);
292         return true;
293     }
294 
295     /**
296      * @dev See {IERC20-transferFrom}.
297      *
298      * Emits an {Approval} event indicating the updated allowance. This is not
299      * required by the EIP. See the note at the beginning of {ERC20}.
300      *
301      * NOTE: Does not update the allowance if the current allowance
302      * is the maximum `uint256`.
303      *
304      * Requirements:
305      *
306      * - `from` and `to` cannot be the zero address.
307      * - `from` must have a balance of at least `amount`.
308      * - the caller must have allowance for ``from``'s tokens of at least
309      * `amount`.
310      */
311     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
312         address spender = _msgSender();
313         _spendAllowance(from, spender, amount);
314         _transfer(from, to, amount);
315         return true;
316     }
317 
318     /**
319      * @dev Atomically increases the allowance granted to `spender` by the caller.
320      *
321      * This is an alternative to {approve} that can be used as a mitigation for
322      * problems described in {IERC20-approve}.
323      *
324      * Emits an {Approval} event indicating the updated allowance.
325      *
326      * Requirements:
327      *
328      * - `spender` cannot be the zero address.
329      */
330     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
331         address owner = _msgSender();
332         _approve(owner, spender, allowance(owner, spender) + addedValue);
333         return true;
334     }
335 
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         address owner = _msgSender();
352         uint256 currentAllowance = allowance(owner, spender);
353         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
354         unchecked {
355             _approve(owner, spender, currentAllowance - subtractedValue);
356         }
357 
358         return true;
359     }
360 
361     /**
362      * @dev Moves `amount` of tokens from `from` to `to`.
363      *
364      * This internal function is equivalent to {transfer}, and can be used to
365      * e.g. implement automatic token fees, slashing mechanisms, etc.
366      *
367      * Emits a {Transfer} event.
368      *
369      * Requirements:
370      *
371      * - `from` cannot be the zero address.
372      * - `to` cannot be the zero address.
373      * - `from` must have a balance of at least `amount`.
374      */
375     function _transfer(address from, address to, uint256 amount) internal virtual {
376         require(from != address(0), "ERC20: transfer from the zero address");
377         require(to != address(0), "ERC20: transfer to the zero address");
378 
379         _beforeTokenTransfer(from, to, amount);
380 
381         uint256 fromBalance = _balances[from];
382         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
383         unchecked {
384             _balances[from] = fromBalance - amount;
385             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
386             // decrementing then incrementing.
387             _balances[to] += amount;
388         }
389 
390         emit Transfer(from, to, amount);
391 
392         _afterTokenTransfer(from, to, amount);
393     }
394 
395     /**
396      * @dev Creates `amount` tokens and assigns them to `account`, increasing
397      * the total supply.
398      *
399      * Emits a {Transfer} event with `from` set to the zero address.
400      *
401      * Requirements:
402      *
403      * - `account` cannot be the zero address.
404      */
405     function _mint(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: mint to the zero address");
407 
408         _beforeTokenTransfer(address(0), account, amount);
409 
410         _totalSupply += amount;
411         unchecked {
412             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
413             _balances[account] += amount;
414         }
415         emit Transfer(address(0), account, amount);
416 
417         _afterTokenTransfer(address(0), account, amount);
418     }
419 
420     /**
421      * @dev Destroys `amount` tokens from `account`, reducing the
422      * total supply.
423      *
424      * Emits a {Transfer} event with `to` set to the zero address.
425      *
426      * Requirements:
427      *
428      * - `account` cannot be the zero address.
429      * - `account` must have at least `amount` tokens.
430      */
431     function _burn(address account, uint256 amount) internal virtual {
432         require(account != address(0), "ERC20: burn from the zero address");
433 
434         _beforeTokenTransfer(account, address(0), amount);
435 
436         uint256 accountBalance = _balances[account];
437         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
438         unchecked {
439             _balances[account] = accountBalance - amount;
440             // Overflow not possible: amount <= accountBalance <= totalSupply.
441             _totalSupply -= amount;
442         }
443 
444         emit Transfer(account, address(0), amount);
445 
446         _afterTokenTransfer(account, address(0), amount);
447     }
448 
449     /**
450      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
451      *
452      * This internal function is equivalent to `approve`, and can be used to
453      * e.g. set automatic allowances for certain subsystems, etc.
454      *
455      * Emits an {Approval} event.
456      *
457      * Requirements:
458      *
459      * - `owner` cannot be the zero address.
460      * - `spender` cannot be the zero address.
461      */
462     function _approve(address owner, address spender, uint256 amount) internal virtual {
463         require(owner != address(0), "ERC20: approve from the zero address");
464         require(spender != address(0), "ERC20: approve to the zero address");
465 
466         _allowances[owner][spender] = amount;
467         emit Approval(owner, spender, amount);
468     }
469 
470     /**
471      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
472      *
473      * Does not update the allowance amount in case of infinite allowance.
474      * Revert if not enough allowance is available.
475      *
476      * Might emit an {Approval} event.
477      */
478     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
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
502     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
503 
504     /**
505      * @dev Hook that is called after any transfer of tokens. This includes
506      * minting and burning.
507      *
508      * Calling conditions:
509      *
510      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
511      * has been transferred to `to`.
512      * - when `from` is zero, `amount` tokens have been minted for `to`.
513      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
514      * - `from` and `to` are never both zero.
515      *
516      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
517      */
518     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
519 }
520 
521 /**
522  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
523  */
524 
525 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
526 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
527 
528 // CAUTION
529 // This version of SafeMath should only be used with Solidity 0.8 or later,
530 // because it relies on the compiler's built in overflow checks.
531 
532 /**
533  * @dev Wrappers over Solidity's arithmetic operations.
534  *
535  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
536  * now has built in overflow checking.
537  */
538 library SafeMath {
539     /**
540      * @dev Returns the addition of two unsigned integers, with an overflow flag.
541      *
542      * _Available since v3.4._
543      */
544     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
545         unchecked {
546             uint256 c = a + b;
547             if (c < a) return (false, 0);
548             return (true, c);
549         }
550     }
551 
552     /**
553      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
554      *
555      * _Available since v3.4._
556      */
557     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         unchecked {
559             if (b > a) return (false, 0);
560             return (true, a - b);
561         }
562     }
563 
564     /**
565      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
566      *
567      * _Available since v3.4._
568      */
569     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
570         unchecked {
571             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
572             // benefit is lost if 'b' is also tested.
573             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
574             if (a == 0) return (true, 0);
575             uint256 c = a * b;
576             if (c / a != b) return (false, 0);
577             return (true, c);
578         }
579     }
580 
581     /**
582      * @dev Returns the division of two unsigned integers, with a division by zero flag.
583      *
584      * _Available since v3.4._
585      */
586     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             if (b == 0) return (false, 0);
589             return (true, a / b);
590         }
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             if (b == 0) return (false, 0);
601             return (true, a % b);
602         }
603     }
604 
605     /**
606      * @dev Returns the addition of two unsigned integers, reverting on
607      * overflow.
608      *
609      * Counterpart to Solidity's `+` operator.
610      *
611      * Requirements:
612      *
613      * - Addition cannot overflow.
614      */
615     function add(uint256 a, uint256 b) internal pure returns (uint256) {
616         return a + b;
617     }
618 
619     /**
620      * @dev Returns the subtraction of two unsigned integers, reverting on
621      * overflow (when the result is negative).
622      *
623      * Counterpart to Solidity's `-` operator.
624      *
625      * Requirements:
626      *
627      * - Subtraction cannot overflow.
628      */
629     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
630         return a - b;
631     }
632 
633     /**
634      * @dev Returns the multiplication of two unsigned integers, reverting on
635      * overflow.
636      *
637      * Counterpart to Solidity's `*` operator.
638      *
639      * Requirements:
640      *
641      * - Multiplication cannot overflow.
642      */
643     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
644         return a * b;
645     }
646 
647     /**
648      * @dev Returns the integer division of two unsigned integers, reverting on
649      * division by zero. The result is rounded towards zero.
650      *
651      * Counterpart to Solidity's `/` operator.
652      *
653      * Requirements:
654      *
655      * - The divisor cannot be zero.
656      */
657     function div(uint256 a, uint256 b) internal pure returns (uint256) {
658         return a / b;
659     }
660 
661     /**
662      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
663      * reverting when dividing by zero.
664      *
665      * Counterpart to Solidity's `%` operator. This function uses a `revert`
666      * opcode (which leaves remaining gas untouched) while Solidity uses an
667      * invalid opcode to revert (consuming all remaining gas).
668      *
669      * Requirements:
670      *
671      * - The divisor cannot be zero.
672      */
673     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
674         return a % b;
675     }
676 
677     /**
678      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
679      * overflow (when the result is negative).
680      *
681      * CAUTION: This function is deprecated because it requires allocating memory for the error
682      * message unnecessarily. For custom revert reasons use {trySub}.
683      *
684      * Counterpart to Solidity's `-` operator.
685      *
686      * Requirements:
687      *
688      * - Subtraction cannot overflow.
689      */
690     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
691         unchecked {
692             require(b <= a, errorMessage);
693             return a - b;
694         }
695     }
696 
697     /**
698      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
699      * division by zero. The result is rounded towards zero.
700      *
701      * Counterpart to Solidity's `/` operator. Note: this function uses a
702      * `revert` opcode (which leaves remaining gas untouched) while Solidity
703      * uses an invalid opcode to revert (consuming all remaining gas).
704      *
705      * Requirements:
706      *
707      * - The divisor cannot be zero.
708      */
709     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
710         unchecked {
711             require(b > 0, errorMessage);
712             return a / b;
713         }
714     }
715 
716     /**
717      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
718      * reverting with custom message when dividing by zero.
719      *
720      * CAUTION: This function is deprecated because it requires allocating memory for the error
721      * message unnecessarily. For custom revert reasons use {tryMod}.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
732         unchecked {
733             require(b > 0, errorMessage);
734             return a % b;
735         }
736     }
737 }
738 
739 /**
740  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
741  */
742 
743 ////// SPDX-License-Identifier-FLATTEN-SUPPRESS-WARNING: MIT
744 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
745 
746 ////import "../utils/Context.sol";
747 
748 /**
749  * @dev Contract module which provides a basic access control mechanism, where
750  * there is an account (an owner) that can be granted exclusive access to
751  * specific functions.
752  *
753  * By default, the owner account will be the one that deploys the contract. This
754  * can later be changed with {transferOwnership}.
755  *
756  * This module is used through inheritance. It will make available the modifier
757  * `onlyOwner`, which can be applied to your functions to restrict their use to
758  * the owner.
759  */
760 abstract contract Ownable is Context {
761     address private _owner;
762 
763     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
764 
765     /**
766      * @dev Initializes the contract setting the deployer as the initial owner.
767      */
768     constructor() {
769         _transferOwnership(_msgSender());
770     }
771 
772     /**
773      * @dev Throws if called by any account other than the owner.
774      */
775     modifier onlyOwner() {
776         _checkOwner();
777         _;
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
788      * @dev Throws if the sender is not the owner.
789      */
790     function _checkOwner() internal view virtual {
791         require(owner() == _msgSender(), "Ownable: caller is not the owner");
792     }
793 
794     /**
795      * @dev Leaves the contract without owner. It will not be possible to call
796      * `onlyOwner` functions anymore. Can only be called by the current owner.
797      *
798      * NOTE: Renouncing ownership will leave the contract without an owner,
799      * thereby removing any functionality that is only available to the owner.
800      */
801     function renounceOwnership() public virtual onlyOwner {
802         _transferOwnership(address(0));
803     }
804 
805     /**
806      * @dev Transfers ownership of the contract to a new account (`newOwner`).
807      * Can only be called by the current owner.
808      */
809     function transferOwnership(address newOwner) public virtual onlyOwner {
810         require(newOwner != address(0), "Ownable: new owner is the zero address");
811         _transferOwnership(newOwner);
812     }
813 
814     /**
815      * @dev Transfers ownership of the contract to a new account (`newOwner`).
816      * Internal function without access restriction.
817      */
818     function _transferOwnership(address newOwner) internal virtual {
819         address oldOwner = _owner;
820         _owner = newOwner;
821         emit OwnershipTransferred(oldOwner, newOwner);
822     }
823 }
824 
825 /**
826  *  SourceUnit: /home/roholah/Desktop/Deploy-BSC-Token/contracts/Token.sol
827  */
828 
829 //SPDX-License-Identifier: MIT
830 
831 ////import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
832 ////import "@openzeppelin/contracts/access/Ownable.sol";
833 ////import "@openzeppelin/contracts/utils/math/SafeMath.sol";
834 ////import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
835 
836 interface DexFactory {
837     function createPair(address tokenA, address tokenB) external returns (address pair);
838 }
839 
840 interface DexRouter {
841     function factory() external pure returns (address);
842 
843     function WETH() external pure returns (address);
844 
845     function addLiquidityETH(
846         address token,
847         uint256 amountTokenDesired,
848         uint256 amountTokenMin,
849         uint256 amountETHMin,
850         address to,
851         uint256 deadline
852     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
853 
854     function swapExactTokensForETHSupportingFeeOnTransferTokens(
855         uint256 amountIn,
856         uint256 amountOutMin,
857         address[] calldata path,
858         address to,
859         uint256 deadline
860     ) external;
861 }
862 
863 contract ELY is ERC20, Ownable {
864     struct Tax {
865         uint256 marketingTax;
866     }
867 
868     uint256 private constant _totalSupply = 1e7 * 1e18;
869 
870     //Router
871     DexRouter public immutable uniswapRouter;
872     address public immutable pairAddress;
873 
874     //Taxes
875     Tax public buyTaxes = Tax(20);
876     Tax public sellTaxes = Tax(40);
877     Tax public transferTaxes = Tax(0);
878 
879     //Whitelisting from taxes/maxwallet/txlimit/etc
880     mapping(address => bool) private whitelisted;
881 
882     //Anti-bot and limitations
883     uint256 public startBlock = 0;
884     uint256 public deadBlocks = 5;
885     uint256 public maxWallet = _totalSupply * 2 / 100;
886     mapping(address => bool) public isBlacklisted;
887 
888     //Swapping
889     uint256 public swapTokensAtAmount = _totalSupply / 100000; //after 0.001% of total supply, swap them
890     bool public swapAndLiquifyEnabled = true;
891     bool public isSwapping = false;
892 
893     //Wallets
894     address public marketingWallet = 0xAfE6B307562E3b90a649E423e4Cb17bfF3Df90ea;
895 
896     //Events
897     event marketingWalletChanged(address indexed _trWallet);
898     event SwapThresholdUpdated(uint256 indexed _newThreshold);
899     event InternalSwapStatusUpdated(bool indexed _status);
900     event Whitelist(address indexed _target, bool indexed _status);
901 
902     bool public tradingEnabled = false;
903 
904     constructor() ERC20("Elyssa AR", "$ELY") {
905         uniswapRouter = DexRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
906         pairAddress = DexFactory(uniswapRouter.factory()).createPair(address(this), uniswapRouter.WETH());
907 
908         whitelisted[msg.sender] = true;
909         whitelisted[address(uniswapRouter)] = true;
910         whitelisted[address(this)] = true;
911 
912         _mint(msg.sender, _totalSupply);
913     }
914 
915     function setmarketingWallet(address _newmarketing) external onlyOwner {
916         require(_newmarketing != address(0), "can not set marketing to dead wallet");
917         marketingWallet = _newmarketing;
918         emit marketingWalletChanged(_newmarketing);
919     }
920 
921     function setSwapTokensAtAmount(uint256 _newAmount) external onlyOwner {
922         require(
923             _newAmount > 0 && _newAmount <= (_totalSupply * 1) / 100,
924             "Minimum swap amount must be greater than 0 and less than 0.5% of total supply!"
925         );
926         swapTokensAtAmount = _newAmount;
927         emit SwapThresholdUpdated(swapTokensAtAmount);
928     }
929 
930     function toggleSwapping() external onlyOwner {
931         swapAndLiquifyEnabled = (swapAndLiquifyEnabled) ? false : true;
932     }
933 
934     function setWhitelistStatus(address _wallet, bool _status) external onlyOwner {
935         whitelisted[_wallet] = _status;
936         emit Whitelist(_wallet, _status);
937     }
938 
939     function checkWhitelist(address _wallet) external view returns (bool) {
940         return whitelisted[_wallet];
941     }
942 
943     function blacklistAddress(address _target, bool _status) external onlyOwner {
944         if (_status) {
945             require(_target != pairAddress, "Can't blacklist liquidity pool");
946             require(_target != address(this), "Can't blacklisted the token");
947         }
948         isBlacklisted[_target] = _status;
949     }
950 
951     function blacklistAddresses(address[] memory _targets, bool[] memory _status) external onlyOwner {
952         for (uint256 i = 0; i < _targets.length; i++) {
953             if (_status[i]) {
954                 require(_targets[i] != pairAddress, "Can't blacklist liquidity pool");
955                 require(_targets[i] != address(this), "Can't blacklisted the token");
956             }
957             isBlacklisted[_targets[i]] = _status[i];
958         }
959     }
960 
961     function startTrading() external onlyOwner {
962         require(!tradingEnabled, "Trading already enabled");
963         tradingEnabled = true;
964         startBlock = block.number;
965     }
966 
967     function updateBuyTax(uint256 marketingTax) external onlyOwner {
968         require(marketingTax <= 10, "can't set buy tax over 10%");
969         buyTaxes.marketingTax = marketingTax;
970     }
971 
972     function updateSellTax(uint256 marketingTax) external onlyOwner {
973         require(marketingTax <= 40, "can't set buy tax over 40%");
974         sellTaxes.marketingTax = marketingTax;
975     }
976 
977     // this function is reponsible for managing tax, if _from or _to is whitelisted, we simply return _amount and skip all the limitations
978     function _takeTax(address _from, address _to, uint256 _amount) internal returns (uint256) {
979         if (whitelisted[_from] || whitelisted[_to]) {
980             return _amount;
981         }
982 
983         require(!isBlacklisted[_from] && !isBlacklisted[_to], "You are blocked from buy/sell/transfers");
984 
985         require(tradingEnabled, "Trading not enabled yet!");
986 
987         uint256 totalTax = 0;
988         if (_to == pairAddress) {
989             totalTax = sellTaxes.marketingTax;
990         } else if (_from == pairAddress) {
991             totalTax = buyTaxes.marketingTax;
992         }
993 
994         if (_to != pairAddress) {
995             require(_amount + balanceOf(_to) <= maxWallet, "can't buy more than max wallet");
996         }
997 
998         //if is a sniper, blacklist it, only works for 5 blocks after launch
999         _antiBot(_from, _to);
1000 
1001         uint256 tax = 0;
1002         if (totalTax > 0) {
1003             tax = (_amount * totalTax) / 100;
1004             super._transfer(_from, address(this), tax);
1005         }
1006         return (_amount - tax);
1007     }
1008 
1009     function _transfer(address _from, address _to, uint256 _amount) internal virtual override {
1010         require(_from != address(0), "transfer from address zero");
1011         require(_to != address(0), "transfer to address zero");
1012         uint256 toTransfer = _takeTax(_from, _to, _amount);
1013 
1014         bool canSwap = balanceOf(address(this)) >= swapTokensAtAmount;
1015         if (
1016             swapAndLiquifyEnabled && pairAddress == _to && canSwap && !whitelisted[_from] && !whitelisted[_to]
1017                 && !isSwapping
1018         ) {
1019             isSwapping = true;
1020             internalSwap(swapTokensAtAmount);
1021             isSwapping = false;
1022         }
1023         super._transfer(_from, _to, toTransfer);
1024     }
1025 
1026     function internalSwap(uint256 swapAmount) internal {
1027         uint256 taxAmount = swapAmount;
1028         if (taxAmount == 0 || swapAmount == 0) {
1029             return;
1030         }
1031         swapToETH(balanceOf(address(this)));
1032         (bool success,) = marketingWallet.call{value: address(this).balance}("");
1033     }
1034 
1035     //swap balalce of the contract to ETH
1036     function swapToETH(uint256 _amount) internal {
1037         address[] memory path = new address[](2);
1038         path[0] = address(this);
1039         path[1] = uniswapRouter.WETH();
1040         _approve(address(this), address(uniswapRouter), _amount);
1041         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1042             _amount, 0, path, address(this), block.timestamp
1043         );
1044     }
1045 
1046     //change dead block in range 0-5, can only be done before launch
1047     function adjustDeadBlock(uint256 db) external onlyOwner {
1048         require(!tradingEnabled, "This function is disabled after launch");
1049         require(db <= 5, "cant set deadblock count to more than 5");
1050         deadBlocks = db;
1051     }
1052 
1053     //removing all limits here, must be called by owner, removes max wallet and sets buy/sell tax to 5/5
1054     function removeLimits() external onlyOwner {
1055         maxWallet = _totalSupply;
1056         buyTaxes.marketingTax = 5;
1057         sellTaxes.marketingTax = 5;
1058     }
1059 
1060     //blacklist wallet if is in dead block, we don't want to blacklist liquidity pair, that would ruin everything
1061     function _antiBot(address from, address to) internal {
1062         if (block.number <= startBlock + deadBlocks) {
1063             if (from == pairAddress) {
1064                 isBlacklisted[to] = true;
1065             }
1066             if (to == pairAddress) {
1067                 isBlacklisted[from] = true;
1068             }
1069         }
1070     }
1071 
1072     //ETH got stuck? withdraw here
1073     function withdrawStuckETH() external onlyOwner {
1074         (bool success,) = address(msg.sender).call{value: address(this).balance}("");
1075         require(success, "transferring ETH failed");
1076     }
1077 
1078     //Tokens got stuck in the contract? withdraw them using this function
1079     function withdrawStuckTokens(address ERC20_token) external onlyOwner {
1080         bool success = IERC20(ERC20_token).transfer(msg.sender, IERC20(ERC20_token).balanceOf(address(this)));
1081         require(success, "trasfering tokens failed!");
1082     }
1083 
1084     receive() external payable {}
1085 }