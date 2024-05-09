1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Emitted when `value` tokens are moved from one account (`from`) to
41      * another (`to`).
42      *
43      * Note that `value` may be zero.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     /**
48      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
49      * a call to {approve}. `value` is the new allowance.
50      */
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `to`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address to, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `from` to `to` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address from, address to, uint256 amount) external returns (bool);
107 }
108 
109 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 
117 /**
118  * @dev Interface for the optional metadata functions from the ERC20 standard.
119  *
120  * _Available since v4.1._
121  */
122 interface IERC20Metadata is IERC20 {
123     /**
124      * @dev Returns the name of the token.
125      */
126     function name() external view returns (string memory);
127 
128     /**
129      * @dev Returns the symbol of the token.
130      */
131     function symbol() external view returns (string memory);
132 
133     /**
134      * @dev Returns the decimals places of the token.
135      */
136     function decimals() external view returns (uint8);
137 }
138 
139 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
140 
141 
142 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 
147 
148 
149 /**
150  * @dev Implementation of the {IERC20} interface.
151  *
152  * This implementation is agnostic to the way tokens are created. This means
153  * that a supply mechanism has to be added in a derived contract using {_mint}.
154  * For a generic mechanism see {ERC20PresetMinterPauser}.
155  *
156  * TIP: For a detailed writeup see our guide
157  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
158  * to implement supply mechanisms].
159  *
160  * The default value of {decimals} is 18. To change this, you should override
161  * this function so it returns a different value.
162  *
163  * We have followed general OpenZeppelin Contracts guidelines: functions revert
164  * instead returning `false` on failure. This behavior is nonetheless
165  * conventional and does not conflict with the expectations of ERC20
166  * applications.
167  *
168  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
169  * This allows applications to reconstruct the allowance for all accounts just
170  * by listening to said events. Other implementations of the EIP may not emit
171  * these events, as it isn't required by the specification.
172  *
173  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
174  * functions have been added to mitigate the well-known issues around setting
175  * allowances. See {IERC20-approve}.
176  */
177 contract ERC20 is Context, IERC20, IERC20Metadata {
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * All two of these values are immutable: they can only be set once during
191      * construction.
192      */
193     constructor(string memory name_, string memory symbol_) {
194         _name = name_;
195         _symbol = symbol_;
196     }
197 
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() public view virtual override returns (string memory) {
202         return _name;
203     }
204 
205     /**
206      * @dev Returns the symbol of the token, usually a shorter version of the
207      * name.
208      */
209     function symbol() public view virtual override returns (string memory) {
210         return _symbol;
211     }
212 
213     /**
214      * @dev Returns the number of decimals used to get its user representation.
215      * For example, if `decimals` equals `2`, a balance of `505` tokens should
216      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
217      *
218      * Tokens usually opt for a value of 18, imitating the relationship between
219      * Ether and Wei. This is the default value returned by this function, unless
220      * it's overridden.
221      *
222      * NOTE: This information is only used for _display_ purposes: it in
223      * no way affects any of the arithmetic of the contract, including
224      * {IERC20-balanceOf} and {IERC20-transfer}.
225      */
226     function decimals() public view virtual override returns (uint8) {
227         return 18;
228     }
229 
230     /**
231      * @dev See {IERC20-totalSupply}.
232      */
233     function totalSupply() public view virtual override returns (uint256) {
234         return _totalSupply;
235     }
236 
237     /**
238      * @dev See {IERC20-balanceOf}.
239      */
240     function balanceOf(address account) public view virtual override returns (uint256) {
241         return _balances[account];
242     }
243 
244     /**
245      * @dev See {IERC20-transfer}.
246      *
247      * Requirements:
248      *
249      * - `to` cannot be the zero address.
250      * - the caller must have a balance of at least `amount`.
251      */
252     function transfer(address to, uint256 amount) public virtual override returns (bool) {
253         address owner = _msgSender();
254         _transfer(owner, to, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-allowance}.
260      */
261     function allowance(address owner, address spender) public view virtual override returns (uint256) {
262         return _allowances[owner][spender];
263     }
264 
265     /**
266      * @dev See {IERC20-approve}.
267      *
268      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
269      * `transferFrom`. This is semantically equivalent to an infinite approval.
270      *
271      * Requirements:
272      *
273      * - `spender` cannot be the zero address.
274      */
275     function approve(address spender, uint256 amount) public virtual override returns (bool) {
276         address owner = _msgSender();
277         _approve(owner, spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * NOTE: Does not update the allowance if the current allowance
288      * is the maximum `uint256`.
289      *
290      * Requirements:
291      *
292      * - `from` and `to` cannot be the zero address.
293      * - `from` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``from``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
298         address spender = _msgSender();
299         _spendAllowance(from, spender, amount);
300         _transfer(from, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically increases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      */
316     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         _approve(owner, spender, allowance(owner, spender) + addedValue);
319         return true;
320     }
321 
322     /**
323      * @dev Atomically decreases the allowance granted to `spender` by the caller.
324      *
325      * This is an alternative to {approve} that can be used as a mitigation for
326      * problems described in {IERC20-approve}.
327      *
328      * Emits an {Approval} event indicating the updated allowance.
329      *
330      * Requirements:
331      *
332      * - `spender` cannot be the zero address.
333      * - `spender` must have allowance for the caller of at least
334      * `subtractedValue`.
335      */
336     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
337         address owner = _msgSender();
338         uint256 currentAllowance = allowance(owner, spender);
339         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
340         unchecked {
341             _approve(owner, spender, currentAllowance - subtractedValue);
342         }
343 
344         return true;
345     }
346 
347     /**
348      * @dev Moves `amount` of tokens from `from` to `to`.
349      *
350      * This internal function is equivalent to {transfer}, and can be used to
351      * e.g. implement automatic token fees, slashing mechanisms, etc.
352      *
353      * Emits a {Transfer} event.
354      *
355      * Requirements:
356      *
357      * - `from` cannot be the zero address.
358      * - `to` cannot be the zero address.
359      * - `from` must have a balance of at least `amount`.
360      */
361     function _transfer(address from, address to, uint256 amount) internal virtual {
362         require(from != address(0), "ERC20: transfer from the zero address");
363         require(to != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(from, to, amount);
366 
367         uint256 fromBalance = _balances[from];
368         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
369         unchecked {
370             _balances[from] = fromBalance - amount;
371             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
372             // decrementing then incrementing.
373             _balances[to] += amount;
374         }
375 
376         emit Transfer(from, to, amount);
377 
378         _afterTokenTransfer(from, to, amount);
379     }
380 
381     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
382      * the total supply.
383      *
384      * Emits a {Transfer} event with `from` set to the zero address.
385      *
386      * Requirements:
387      *
388      * - `account` cannot be the zero address.
389      */
390     function _mint(address account, uint256 amount) internal virtual {
391         require(account != address(0), "ERC20: mint to the zero address");
392 
393         _beforeTokenTransfer(address(0), account, amount);
394 
395         _totalSupply += amount;
396         unchecked {
397             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
398             _balances[account] += amount;
399         }
400         emit Transfer(address(0), account, amount);
401 
402         _afterTokenTransfer(address(0), account, amount);
403     }
404 
405     /**
406      * @dev Destroys `amount` tokens from `account`, reducing the
407      * total supply.
408      *
409      * Emits a {Transfer} event with `to` set to the zero address.
410      *
411      * Requirements:
412      *
413      * - `account` cannot be the zero address.
414      * - `account` must have at least `amount` tokens.
415      */
416     function _burn(address account, uint256 amount) internal virtual {
417         require(account != address(0), "ERC20: burn from the zero address");
418 
419         _beforeTokenTransfer(account, address(0), amount);
420 
421         uint256 accountBalance = _balances[account];
422         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
423         unchecked {
424             _balances[account] = accountBalance - amount;
425             // Overflow not possible: amount <= accountBalance <= totalSupply.
426             _totalSupply -= amount;
427         }
428 
429         emit Transfer(account, address(0), amount);
430 
431         _afterTokenTransfer(account, address(0), amount);
432     }
433 
434     /**
435      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
436      *
437      * This internal function is equivalent to `approve`, and can be used to
438      * e.g. set automatic allowances for certain subsystems, etc.
439      *
440      * Emits an {Approval} event.
441      *
442      * Requirements:
443      *
444      * - `owner` cannot be the zero address.
445      * - `spender` cannot be the zero address.
446      */
447     function _approve(address owner, address spender, uint256 amount) internal virtual {
448         require(owner != address(0), "ERC20: approve from the zero address");
449         require(spender != address(0), "ERC20: approve to the zero address");
450 
451         _allowances[owner][spender] = amount;
452         emit Approval(owner, spender, amount);
453     }
454 
455     /**
456      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
457      *
458      * Does not update the allowance amount in case of infinite allowance.
459      * Revert if not enough allowance is available.
460      *
461      * Might emit an {Approval} event.
462      */
463     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
464         uint256 currentAllowance = allowance(owner, spender);
465         if (currentAllowance != type(uint256).max) {
466             require(currentAllowance >= amount, "ERC20: insufficient allowance");
467             unchecked {
468                 _approve(owner, spender, currentAllowance - amount);
469             }
470         }
471     }
472 
473     /**
474      * @dev Hook that is called before any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * will be transferred to `to`.
481      * - when `from` is zero, `amount` tokens will be minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
488 
489     /**
490      * @dev Hook that is called after any transfer of tokens. This includes
491      * minting and burning.
492      *
493      * Calling conditions:
494      *
495      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
496      * has been transferred to `to`.
497      * - when `from` is zero, `amount` tokens have been minted for `to`.
498      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
499      * - `from` and `to` are never both zero.
500      *
501      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
502      */
503     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
504 }
505 
506 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
507 
508 
509 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
510 
511 pragma solidity ^0.8.0;
512 
513 // CAUTION
514 // This version of SafeMath should only be used with Solidity 0.8 or later,
515 // because it relies on the compiler's built in overflow checks.
516 
517 /**
518  * @dev Wrappers over Solidity's arithmetic operations.
519  *
520  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
521  * now has built in overflow checking.
522  */
523 library SafeMath {
524     /**
525      * @dev Returns the addition of two unsigned integers, with an overflow flag.
526      *
527      * _Available since v3.4._
528      */
529     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
530         unchecked {
531             uint256 c = a + b;
532             if (c < a) return (false, 0);
533             return (true, c);
534         }
535     }
536 
537     /**
538      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
539      *
540      * _Available since v3.4._
541      */
542     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
543         unchecked {
544             if (b > a) return (false, 0);
545             return (true, a - b);
546         }
547     }
548 
549     /**
550      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
551      *
552      * _Available since v3.4._
553      */
554     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
555         unchecked {
556             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
557             // benefit is lost if 'b' is also tested.
558             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
559             if (a == 0) return (true, 0);
560             uint256 c = a * b;
561             if (c / a != b) return (false, 0);
562             return (true, c);
563         }
564     }
565 
566     /**
567      * @dev Returns the division of two unsigned integers, with a division by zero flag.
568      *
569      * _Available since v3.4._
570      */
571     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
572         unchecked {
573             if (b == 0) return (false, 0);
574             return (true, a / b);
575         }
576     }
577 
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
580      *
581      * _Available since v3.4._
582      */
583     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
584         unchecked {
585             if (b == 0) return (false, 0);
586             return (true, a % b);
587         }
588     }
589 
590     /**
591      * @dev Returns the addition of two unsigned integers, reverting on
592      * overflow.
593      *
594      * Counterpart to Solidity's `+` operator.
595      *
596      * Requirements:
597      *
598      * - Addition cannot overflow.
599      */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601         return a + b;
602     }
603 
604     /**
605      * @dev Returns the subtraction of two unsigned integers, reverting on
606      * overflow (when the result is negative).
607      *
608      * Counterpart to Solidity's `-` operator.
609      *
610      * Requirements:
611      *
612      * - Subtraction cannot overflow.
613      */
614     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
615         return a - b;
616     }
617 
618     /**
619      * @dev Returns the multiplication of two unsigned integers, reverting on
620      * overflow.
621      *
622      * Counterpart to Solidity's `*` operator.
623      *
624      * Requirements:
625      *
626      * - Multiplication cannot overflow.
627      */
628     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
629         return a * b;
630     }
631 
632     /**
633      * @dev Returns the integer division of two unsigned integers, reverting on
634      * division by zero. The result is rounded towards zero.
635      *
636      * Counterpart to Solidity's `/` operator.
637      *
638      * Requirements:
639      *
640      * - The divisor cannot be zero.
641      */
642     function div(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a / b;
644     }
645 
646     /**
647      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
648      * reverting when dividing by zero.
649      *
650      * Counterpart to Solidity's `%` operator. This function uses a `revert`
651      * opcode (which leaves remaining gas untouched) while Solidity uses an
652      * invalid opcode to revert (consuming all remaining gas).
653      *
654      * Requirements:
655      *
656      * - The divisor cannot be zero.
657      */
658     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a % b;
660     }
661 
662     /**
663      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
664      * overflow (when the result is negative).
665      *
666      * CAUTION: This function is deprecated because it requires allocating memory for the error
667      * message unnecessarily. For custom revert reasons use {trySub}.
668      *
669      * Counterpart to Solidity's `-` operator.
670      *
671      * Requirements:
672      *
673      * - Subtraction cannot overflow.
674      */
675     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
676         unchecked {
677             require(b <= a, errorMessage);
678             return a - b;
679         }
680     }
681 
682     /**
683      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
684      * division by zero. The result is rounded towards zero.
685      *
686      * Counterpart to Solidity's `/` operator. Note: this function uses a
687      * `revert` opcode (which leaves remaining gas untouched) while Solidity
688      * uses an invalid opcode to revert (consuming all remaining gas).
689      *
690      * Requirements:
691      *
692      * - The divisor cannot be zero.
693      */
694     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
695         unchecked {
696             require(b > 0, errorMessage);
697             return a / b;
698         }
699     }
700 
701     /**
702      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
703      * reverting with custom message when dividing by zero.
704      *
705      * CAUTION: This function is deprecated because it requires allocating memory for the error
706      * message unnecessarily. For custom revert reasons use {tryMod}.
707      *
708      * Counterpart to Solidity's `%` operator. This function uses a `revert`
709      * opcode (which leaves remaining gas untouched) while Solidity uses an
710      * invalid opcode to revert (consuming all remaining gas).
711      *
712      * Requirements:
713      *
714      * - The divisor cannot be zero.
715      */
716     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
717         unchecked {
718             require(b > 0, errorMessage);
719             return a % b;
720         }
721     }
722 }
723 
724 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
725 
726 pragma solidity >=0.5.0;
727 
728 interface IUniswapV2Pair {
729     event Approval(address indexed owner, address indexed spender, uint value);
730     event Transfer(address indexed from, address indexed to, uint value);
731 
732     function name() external pure returns (string memory);
733     function symbol() external pure returns (string memory);
734     function decimals() external pure returns (uint8);
735     function totalSupply() external view returns (uint);
736     function balanceOf(address owner) external view returns (uint);
737     function allowance(address owner, address spender) external view returns (uint);
738 
739     function approve(address spender, uint value) external returns (bool);
740     function transfer(address to, uint value) external returns (bool);
741     function transferFrom(address from, address to, uint value) external returns (bool);
742 
743     function DOMAIN_SEPARATOR() external view returns (bytes32);
744     function PERMIT_TYPEHASH() external pure returns (bytes32);
745     function nonces(address owner) external view returns (uint);
746 
747     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
748 
749     event Mint(address indexed sender, uint amount0, uint amount1);
750     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
751     event Swap(
752         address indexed sender,
753         uint amount0In,
754         uint amount1In,
755         uint amount0Out,
756         uint amount1Out,
757         address indexed to
758     );
759     event Sync(uint112 reserve0, uint112 reserve1);
760 
761     function MINIMUM_LIQUIDITY() external pure returns (uint);
762     function factory() external view returns (address);
763     function token0() external view returns (address);
764     function token1() external view returns (address);
765     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
766     function price0CumulativeLast() external view returns (uint);
767     function price1CumulativeLast() external view returns (uint);
768     function kLast() external view returns (uint);
769 
770     function mint(address to) external returns (uint liquidity);
771     function burn(address to) external returns (uint amount0, uint amount1);
772     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
773     function skim(address to) external;
774     function sync() external;
775 
776     function initialize(address, address) external;
777 }
778 
779 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
780 
781 pragma solidity >=0.5.0;
782 
783 interface IUniswapV2Factory {
784     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
785 
786     function feeTo() external view returns (address);
787     function feeToSetter() external view returns (address);
788 
789     function getPair(address tokenA, address tokenB) external view returns (address pair);
790     function allPairs(uint) external view returns (address pair);
791     function allPairsLength() external view returns (uint);
792 
793     function createPair(address tokenA, address tokenB) external returns (address pair);
794 
795     function setFeeTo(address) external;
796     function setFeeToSetter(address) external;
797 }
798 
799 // File: @uniswap/lib/contracts/libraries/TransferHelper.sol
800 
801 
802 
803 pragma solidity >=0.6.0;
804 
805 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
806 library TransferHelper {
807     function safeApprove(
808         address token,
809         address to,
810         uint256 value
811     ) internal {
812         // bytes4(keccak256(bytes('approve(address,uint256)')));
813         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
814         require(
815             success && (data.length == 0 || abi.decode(data, (bool))),
816             'TransferHelper::safeApprove: approve failed'
817         );
818     }
819 
820     function safeTransfer(
821         address token,
822         address to,
823         uint256 value
824     ) internal {
825         // bytes4(keccak256(bytes('transfer(address,uint256)')));
826         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
827         require(
828             success && (data.length == 0 || abi.decode(data, (bool))),
829             'TransferHelper::safeTransfer: transfer failed'
830         );
831     }
832 
833     function safeTransferFrom(
834         address token,
835         address from,
836         address to,
837         uint256 value
838     ) internal {
839         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
840         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
841         require(
842             success && (data.length == 0 || abi.decode(data, (bool))),
843             'TransferHelper::transferFrom: transferFrom failed'
844         );
845     }
846 
847     function safeTransferETH(address to, uint256 value) internal {
848         (bool success, ) = to.call{value: value}(new bytes(0));
849         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
850     }
851 }
852 
853 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
854 
855 pragma solidity >=0.6.2;
856 
857 interface IUniswapV2Router01 {
858     function factory() external pure returns (address);
859     function WETH() external pure returns (address);
860 
861     function addLiquidity(
862         address tokenA,
863         address tokenB,
864         uint amountADesired,
865         uint amountBDesired,
866         uint amountAMin,
867         uint amountBMin,
868         address to,
869         uint deadline
870     ) external returns (uint amountA, uint amountB, uint liquidity);
871     function addLiquidityETH(
872         address token,
873         uint amountTokenDesired,
874         uint amountTokenMin,
875         uint amountETHMin,
876         address to,
877         uint deadline
878     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
879     function removeLiquidity(
880         address tokenA,
881         address tokenB,
882         uint liquidity,
883         uint amountAMin,
884         uint amountBMin,
885         address to,
886         uint deadline
887     ) external returns (uint amountA, uint amountB);
888     function removeLiquidityETH(
889         address token,
890         uint liquidity,
891         uint amountTokenMin,
892         uint amountETHMin,
893         address to,
894         uint deadline
895     ) external returns (uint amountToken, uint amountETH);
896     function removeLiquidityWithPermit(
897         address tokenA,
898         address tokenB,
899         uint liquidity,
900         uint amountAMin,
901         uint amountBMin,
902         address to,
903         uint deadline,
904         bool approveMax, uint8 v, bytes32 r, bytes32 s
905     ) external returns (uint amountA, uint amountB);
906     function removeLiquidityETHWithPermit(
907         address token,
908         uint liquidity,
909         uint amountTokenMin,
910         uint amountETHMin,
911         address to,
912         uint deadline,
913         bool approveMax, uint8 v, bytes32 r, bytes32 s
914     ) external returns (uint amountToken, uint amountETH);
915     function swapExactTokensForTokens(
916         uint amountIn,
917         uint amountOutMin,
918         address[] calldata path,
919         address to,
920         uint deadline
921     ) external returns (uint[] memory amounts);
922     function swapTokensForExactTokens(
923         uint amountOut,
924         uint amountInMax,
925         address[] calldata path,
926         address to,
927         uint deadline
928     ) external returns (uint[] memory amounts);
929     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
930         external
931         payable
932         returns (uint[] memory amounts);
933     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
934         external
935         returns (uint[] memory amounts);
936     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
937         external
938         returns (uint[] memory amounts);
939     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
940         external
941         payable
942         returns (uint[] memory amounts);
943 
944     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
945     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
946     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
947     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
948     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
949 }
950 
951 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
952 
953 pragma solidity >=0.6.2;
954 
955 
956 
957 interface IUniswapV2Router02 is IUniswapV2Router01 {
958     function removeLiquidityETHSupportingFeeOnTransferTokens(
959         address token,
960         uint liquidity,
961         uint amountTokenMin,
962         uint amountETHMin,
963         address to,
964         uint deadline
965     ) external returns (uint amountETH);
966     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
967         address token,
968         uint liquidity,
969         uint amountTokenMin,
970         uint amountETHMin,
971         address to,
972         uint deadline,
973         bool approveMax, uint8 v, bytes32 r, bytes32 s
974     ) external returns (uint amountETH);
975 
976     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
977         uint amountIn,
978         uint amountOutMin,
979         address[] calldata path,
980         address to,
981         uint deadline
982     ) external;
983     function swapExactETHForTokensSupportingFeeOnTransferTokens(
984         uint amountOutMin,
985         address[] calldata path,
986         address to,
987         uint deadline
988     ) external payable;
989     function swapExactTokensForETHSupportingFeeOnTransferTokens(
990         uint amountIn,
991         uint amountOutMin,
992         address[] calldata path,
993         address to,
994         uint deadline
995     ) external;
996 }
997 
998 // File: REVV/Revv.sol
999 
1000 /**
1001  REVVUP
1002  Our mission is to provide a platform for everyone, even players with limited capital, to take part in Revenue Sharing offered by many protocols today.  
1003  hese generally have a minimum position size to qualify for revenue share which makes access difficult for some.
1004 Especially to get diversification across multiple protocols. 
1005 We want to facilitate revenue sharing and diversification for all in the most cost efficient manner possible.
1006 TG link: https://t.me/RevvdUpEntry
1007 Website: revvdup.io
1008 https://twitter.com/RevvdUp_io
1009 Tax: 5/5
1010 **/
1011 
1012 pragma solidity 0.8.20;
1013 
1014 
1015 
1016 
1017 
1018 
1019 
1020 
1021 
1022 abstract contract Ownable is Context {
1023     
1024     address private _owner;
1025 
1026     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1027 
1028     /**
1029      * @dev Initializes the contract setting the deployer as the initial owner.
1030      */
1031     constructor() {
1032         _transferOwnership(_msgSender());
1033     }
1034 
1035     /**
1036      * @dev Returns the address of the current owner.
1037      */
1038     function owner() public view virtual returns (address) {
1039         return _owner;
1040     }
1041 
1042     /**
1043      * @dev Throws if called by any account other than the owner.
1044      */
1045     modifier onlyOwner() {
1046         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1047         _;
1048     }
1049 
1050     /**
1051      * @dev Leaves the contract without owner. It will not be possible to call
1052      * `onlyOwner` functions anymore. Can only be called by the current owner.
1053      *
1054      * NOTE: Renouncing ownership will leave the contract without an owner,
1055      * thereby removing any functionality that is only available to the owner.
1056      */
1057     function renounceOwnership() public virtual onlyOwner {
1058         _transferOwnership(address(0));
1059     }
1060 
1061     /**
1062      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1063      * Can only be called by the current owner.
1064      */
1065     function transferOwnership(address newOwner) public virtual onlyOwner {
1066         require(newOwner != address(0), "Ownable: new owner is the zero address");
1067         _transferOwnership(newOwner);
1068     }
1069 
1070     /**
1071      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1072      * Internal function without access restriction.
1073      */
1074     function _transferOwnership(address newOwner) internal virtual {
1075         address oldOwner = _owner;
1076         _owner = newOwner;
1077         emit OwnershipTransferred(oldOwner, newOwner);
1078     }
1079 }
1080 
1081 
1082 contract REVVUP is ERC20, Ownable {
1083     using SafeMath for uint256;
1084 
1085     address public investmentWallet = address(0x2159E8d5566369DdB67bbfC6b288Ed5591D34235);
1086     address public marketingWallet = address(0x68287F8fe42597Df7cA5bF99d5A17348377c520B);
1087     address public teamWallet = address(0x3CDbb9714EF972f43375Ac8e783fd3203f3EC748);
1088     address public constant deadAddress = address(0x000000000000000000000000000000000000dEaD);
1089     IUniswapV2Router02 public  uniswapV2Router;
1090     address public  uniswapV2Pair;
1091 
1092     uint256 public investmentBuyFee = 3;
1093     uint256 public teamBuyFee = 2;
1094     uint256 public autoLPBuyFee = 0;
1095     uint256 public buyTotalFees = autoLPBuyFee + teamBuyFee  + investmentBuyFee;
1096     uint256 public investmentSellFee = 3;
1097     uint256 public teamSellFee = 2;
1098     uint256 public autoLPSellFee= 0;
1099     uint256 public sellTotalFees = autoLPBuyFee + teamSellFee+ investmentSellFee ;
1100     uint256 public _investmentShare;
1101     uint256 public _autoLpShare;
1102     uint256 public _teamShare;
1103     uint256 public txMaxperWallet;
1104     uint256 public maxTokenPerWallet;
1105     uint256 public swapTokensAtAmount;
1106 
1107     mapping(address => bool) blacklisted;
1108     mapping(address => bool) private _isExcludedFromFees;
1109     mapping(address => bool) public _isTxMaxExcluded;
1110     mapping(address => bool) public automatedMarketMakerPairs;
1111     bool public limitTx ;
1112     bool public letDegen;
1113     bool public swapEnabled ;
1114     bool private swappingUp;
1115 
1116     event ExcludeFromFees(address indexed account, bool isExcluded);
1117     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1118     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiquidity);
1119 
1120 
1121     constructor() ERC20("REVVD UP", "REVV") {
1122          uint256 totalSupply = 1_000_000 * 1e18;
1123          _mint(msg.sender, totalSupply);
1124          //preload();
1125     }
1126 
1127 
1128     function preload() public onlyOwner {  
1129         //UNISWAP TESTNET
1130        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1131         //MAINNET 
1132        // uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1133         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1134             .createPair(address(this), uniswapV2Router.WETH());
1135         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1136 
1137           txMaxperWallet = 10_000 * 1e18; 
1138           maxTokenPerWallet = 10_000 * 1e18; 
1139           swapTokensAtAmount = (this.totalSupply() * 5) / 10000; 
1140           swapEnabled = false;
1141         limitTx = true;
1142           letDegen = false;
1143        
1144         excludeFromFees(owner(), true);
1145         excludeFromFees(address(this), true);
1146         excludeFromFees(address(0xdead), true);
1147 
1148         _excludeFromMaxTx(owner(), true);
1149         _excludeFromMaxTx(address(this), true);
1150         _excludeFromMaxTx(address(0xdead), true);
1151          _excludeFromMaxTx(address(uniswapV2Router), true);
1152         _excludeFromMaxTx(address(uniswapV2Pair), true);
1153     }
1154    
1155    
1156    function revvUpNow() external onlyOwner{
1157             letDegen = true;
1158            swapEnabled = true;
1159    }
1160 
1161 
1162     function updateLimit() external onlyOwner returns (bool) {
1163         limitTx  = false;
1164         return true;
1165     }
1166 
1167     function UpdateMaxOutWallet(uint256 amt) external onlyOwner {
1168         require(
1169             amt >= ((totalSupply() * 10) / 1000) / 1e18,
1170             "Max number must be bigger than 1.0%"
1171         );
1172         maxTokenPerWallet = amt* (10**18);
1173     }
1174 
1175 
1176    function updateTxMax(uint256 amt) external onlyOwner {
1177         require(
1178             amt >= ((totalSupply() * 5) / 1000) / 1e18,
1179             "must be bigger than 0.5%"
1180         );
1181         txMaxperWallet = amt* (10**18);
1182     }
1183 
1184 
1185    function updateSwapLimit(uint256 amt)
1186         external
1187         onlyOwner
1188         returns (bool)
1189     {
1190         require(
1191             amt >= (totalSupply() * 1) / 100000,
1192             "limit must be higher than 0.001% total supply."
1193         );
1194         require(
1195             amt <= (totalSupply() * 5) / 1000,
1196             "limit cannot be higher than 0.5% total supply."
1197         );
1198         swapTokensAtAmount = amt;
1199         return true;
1200     }
1201 
1202 
1203     function setSwapEnabled(bool action) external onlyOwner {
1204         swapEnabled = action;
1205     }
1206 
1207 
1208     function _excludeFromMaxTx(address _address, bool action)
1209         public
1210         onlyOwner
1211     {
1212         _isTxMaxExcluded[_address] = action;
1213     }
1214 
1215  
1216     function updateBuyFees(
1217         uint256 _investFee,
1218         uint256 _lpFee,
1219         uint256 _teamFee
1220     ) external onlyOwner {
1221         investmentBuyFee= _investFee;
1222         autoLPBuyFee= _lpFee;
1223         teamBuyFee  = _teamFee;
1224         buyTotalFees = investmentBuyFee + autoLPBuyFee+ teamBuyFee;
1225         require(buyTotalFees <= 5, "Buy fee max should 5%");
1226     }
1227 
1228     function updateSellFees(
1229         uint256 _investFee,
1230         uint256 _lpFee,
1231         uint256 _teamFee
1232     ) external onlyOwner {
1233         investmentSellFee  = _investFee;
1234         autoLPBuyFee = _lpFee;
1235         teamSellFee = _teamFee;
1236         sellTotalFees = investmentSellFee + autoLPBuyFee + teamSellFee;
1237         require(sellTotalFees <= 5, "Sell Max must be 5%");
1238     }
1239 
1240     function excludeFromFees(address account, bool excluded) public onlyOwner {
1241         _isExcludedFromFees[account] = excluded;
1242         emit ExcludeFromFees(account, excluded);
1243     }
1244 
1245     function setAutomatedMarketMakerPair(address pair, bool value)
1246         public
1247         onlyOwner
1248     {
1249         require(
1250             pair != uniswapV2Pair,
1251             "pair cannot be removed from automatedMarketMakerPairs"
1252         );
1253 
1254         _setAutomatedMarketMakerPair(pair, value);
1255     }
1256 
1257     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1258         automatedMarketMakerPairs[pair] = value;
1259 
1260         emit SetAutomatedMarketMakerPair(pair, value);
1261     }
1262 
1263 
1264     function updateTeamAddress(address newAdd) external onlyOwner {
1265         teamWallet = newAdd;
1266     }
1267 
1268     function isExcludedFromFees(address account) public view returns (bool) {
1269         return _isExcludedFromFees[account];
1270     }
1271 
1272     function isBlacklisted(address account) public view returns (bool) {
1273         return blacklisted[account];
1274     }
1275 
1276     function _transfer(
1277         address from,
1278         address to,
1279         uint256 amount
1280     ) internal override {
1281         require(from != address(0), "ERC20: transfer from the zero address");
1282         require(to != address(0), "ERC20: transfer to the zero address");
1283         require(!blacklisted[from],"Sender blacklisted");
1284         require(!blacklisted[to],"Receiver blacklisted");
1285 
1286         if (amount == 0) {
1287             super._transfer(from, to, 0);
1288             return;
1289         }
1290 
1291         if (limitTx) {
1292             if (
1293                 from != owner() &&
1294                 to != owner() &&
1295                 to != address(0) &&
1296                 to != address(0xdead) &&
1297                 !swappingUp
1298             ) {
1299                 if (!letDegen) {
1300                     require(
1301                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1302                         "Trading is not active."
1303                     );
1304                 }
1305                 if (
1306                     automatedMarketMakerPairs[from] &&
1307                     !_isTxMaxExcluded[to]
1308                 ) {
1309                     require(
1310                         amount <= txMaxperWallet,
1311                         "Buy transfer amount exceeds the txMaxperWallet."
1312                     );
1313                     require(
1314                         amount + balanceOf(to) <= maxTokenPerWallet,
1315                         "Max wallet exceeded"
1316                     );
1317                 }
1318                 else if (
1319                     automatedMarketMakerPairs[to] &&
1320                     !_isTxMaxExcluded[from]
1321                 ) {
1322                     require(
1323                         amount <= txMaxperWallet,
1324                         "Sell transfer amount exceeds the txMaxperWallet."
1325                     );
1326                 } else if (!_isTxMaxExcluded[to]) {
1327                     require(
1328                         amount + balanceOf(to) <= maxTokenPerWallet,
1329                         "Max wallet exceeded"
1330                     );
1331                 }
1332             }
1333         }
1334 
1335         uint256 contractTokenBalance = balanceOf(address(this));
1336 
1337         bool doSwapUp = contractTokenBalance >= swapTokensAtAmount;
1338 
1339         if (
1340             doSwapUp &&
1341             swapEnabled &&
1342             !swappingUp &&
1343             !automatedMarketMakerPairs[from] &&
1344             !_isExcludedFromFees[from] &&
1345             !_isExcludedFromFees[to]
1346         ) {
1347             swappingUp = true;
1348             SwapUp();
1349             swappingUp = false;
1350         }
1351 
1352         bool takeFee = !swappingUp;
1353 
1354     
1355         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1356             takeFee = false;
1357         }
1358 
1359         uint256 fees = 0;
1360         
1361         if (takeFee) {
1362 
1363             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1364                 fees = amount.mul(sellTotalFees).div(100);
1365                 _autoLpShare += (fees * autoLPBuyFee) / sellTotalFees;
1366                 _teamShare += (fees * teamSellFee) / sellTotalFees;
1367                 _investmentShare += (fees * investmentSellFee ) / sellTotalFees;
1368             }
1369             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1370                 fees = amount.mul(buyTotalFees).div(100);
1371                 _autoLpShare += (fees * autoLPBuyFee) / buyTotalFees;
1372                 _teamShare += (fees * teamBuyFee ) / buyTotalFees;
1373                 _investmentShare+= (fees * investmentBuyFee) / buyTotalFees;
1374             }
1375 
1376             if (fees > 0) {
1377                 super._transfer(from, address(this), fees);
1378             }
1379 
1380             amount -= fees;
1381         }
1382 
1383         super._transfer(from, to, amount);
1384     }
1385     
1386 
1387     function swapTokensForEth(uint256 tokenAmount) private {
1388         address[] memory path = new address[](2);
1389         path[0] = address(this);
1390         path[1] = uniswapV2Router.WETH();
1391 
1392         _approve(address(this), address(uniswapV2Router), tokenAmount);
1393         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1394             tokenAmount,
1395             0, 
1396             path,
1397             address(this),
1398             block.timestamp
1399         );
1400     }
1401        function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1402        
1403         _approve(address(this), address(uniswapV2Router), tokenAmount);
1404         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1405             address(this),
1406             tokenAmount,
1407             0, 
1408             0, 
1409             owner(),
1410             block.timestamp
1411         );
1412     }
1413 
1414 
1415 
1416     function SwapUp() private {
1417         uint256 contractBalance = balanceOf(address(this));
1418         uint256 totalTokensToSwap = _investmentShare +
1419             _teamShare+
1420             _autoLpShare;
1421         bool success;
1422 
1423         if (contractBalance == 0 || totalTokensToSwap == 0) {
1424             return;
1425         }
1426 
1427         if (contractBalance > swapTokensAtAmount * 20) {
1428             contractBalance = swapTokensAtAmount * 20;
1429         }
1430 
1431         uint256 liquidityTokens = (contractBalance * _autoLpShare)/totalTokensToSwap /2;
1432         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1433 
1434         uint256 initialETHBalance = address(this).balance;
1435 
1436         swapTokensForEth(amountToSwapForETH);
1437 
1438         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1439         uint256 ethForInvestment = ethBalance.mul(_investmentShare).div(totalTokensToSwap - (_autoLpShare / 2));
1440         uint256 ethForTeam = ethBalance.mul(_teamShare).div(totalTokensToSwap - (_autoLpShare / 2));
1441         
1442         uint256 ethForLiquidity = ethBalance - ethForInvestment- ethForTeam;
1443 
1444         _investmentShare = 0;
1445         _teamShare = 0;
1446         _autoLpShare = 0;
1447 
1448         (success, ) = address(investmentWallet).call{value: ethForInvestment}("");
1449         (success, ) = address(teamWallet).call{value: ethForTeam.div(2)}("");
1450          (success, ) = address(marketingWallet).call{value: ethForTeam.div(2)}("");
1451 
1452         
1453         
1454         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1455             addLiquidity(liquidityTokens, ethForLiquidity);
1456             emit SwapAndLiquify(
1457                 amountToSwapForETH,
1458                 ethForLiquidity,
1459                 _autoLpShare
1460             );
1461         }
1462        
1463     }
1464 
1465     function updateUniswaoRouterv2(address _address) public onlyOwner {
1466         uniswapV2Router = IUniswapV2Router02(_address);
1467     }
1468 
1469       function updateMarketingAddress(address _address) public onlyOwner {
1470         marketingWallet = address(_address);
1471     }
1472 
1473          function updateInvestmentAddress(address _address) public onlyOwner {
1474         investmentWallet = address(_address);
1475     }
1476 
1477 
1478     function blacklistAddress(address _address) public onlyOwner {
1479         blacklisted[_address] = true;
1480     }
1481 
1482     
1483     function removeBlacklisting(address _address) public onlyOwner {
1484         blacklisted[_address] = false;
1485     }
1486 
1487     function withdrawContEth(address _address) external onlyOwner {
1488         (bool success, ) = _address.call{
1489             value: address(this).balance
1490         } ("");
1491         require(success);
1492     }
1493 
1494 
1495     receive() external payable {}
1496 }