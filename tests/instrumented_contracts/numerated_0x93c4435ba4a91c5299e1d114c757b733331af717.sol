1 // SPDX-License-Identifier: MIT
2 
3 // 作成者: 大場 つぐみ
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 // CAUTION
10 // This version of SafeMath should only be used with Solidity 0.8 or later,
11 // because it relies on the compiler's built in overflow checks.
12 
13 /**
14  * @dev Wrappers over Solidity's arithmetic operations.
15  *
16  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
17  * now has built in overflow checking.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, with an overflow flag.
22      *
23      * _Available since v3.4._
24      */
25     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
26         unchecked {
27             uint256 c = a + b;
28             if (c < a) return (false, 0);
29             return (true, c);
30         }
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             if (b > a) return (false, 0);
41             return (true, a - b);
42         }
43     }
44 
45     /**
46      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
47      *
48      * _Available since v3.4._
49      */
50     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
51         unchecked {
52             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
53             // benefit is lost if 'b' is also tested.
54             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
55             if (a == 0) return (true, 0);
56             uint256 c = a * b;
57             if (c / a != b) return (false, 0);
58             return (true, c);
59         }
60     }
61 
62     /**
63      * @dev Returns the division of two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68         unchecked {
69             if (b == 0) return (false, 0);
70             return (true, a / b);
71         }
72     }
73 
74     /**
75      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
76      *
77      * _Available since v3.4._
78      */
79     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
80         unchecked {
81             if (b == 0) return (false, 0);
82             return (true, a % b);
83         }
84     }
85 
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a + b;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a - b;
112     }
113 
114     /**
115      * @dev Returns the multiplication of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `*` operator.
119      *
120      * Requirements:
121      *
122      * - Multiplication cannot overflow.
123      */
124     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a * b;
126     }
127 
128     /**
129      * @dev Returns the integer division of two unsigned integers, reverting on
130      * division by zero. The result is rounded towards zero.
131      *
132      * Counterpart to Solidity's `/` operator.
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return a % b;
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * CAUTION: This function is deprecated because it requires allocating memory for the error
163      * message unnecessarily. For custom revert reasons use {trySub}.
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(
172         uint256 a,
173         uint256 b,
174         string memory errorMessage
175     ) internal pure returns (uint256) {
176         unchecked {
177             require(b <= a, errorMessage);
178             return a - b;
179         }
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b > 0, errorMessage);
201             return a / b;
202         }
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * reverting with custom message when dividing by zero.
208      *
209      * CAUTION: This function is deprecated because it requires allocating memory for the error
210      * message unnecessarily. For custom revert reasons use {tryMod}.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(
221         uint256 a,
222         uint256 b,
223         string memory errorMessage
224     ) internal pure returns (uint256) {
225         unchecked {
226             require(b > 0, errorMessage);
227             return a % b;
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
233 
234 
235 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Interface of the ERC20 standard as defined in the EIP.
241  */
242 interface IERC20 {
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 
257     /**
258      * @dev Returns the amount of tokens in existence.
259      */
260     function totalSupply() external view returns (uint256);
261 
262     /**
263      * @dev Returns the amount of tokens owned by `account`.
264      */
265     function balanceOf(address account) external view returns (uint256);
266 
267     /**
268      * @dev Moves `amount` tokens from the caller's account to `to`.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transfer(address to, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Returns the remaining number of tokens that `spender` will be
278      * allowed to spend on behalf of `owner` through {transferFrom}. This is
279      * zero by default.
280      *
281      * This value changes when {approve} or {transferFrom} are called.
282      */
283     function allowance(address owner, address spender) external view returns (uint256);
284 
285     /**
286      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
287      *
288      * Returns a boolean value indicating whether the operation succeeded.
289      *
290      * IMPORTANT: Beware that changing an allowance with this method brings the risk
291      * that someone may use both the old and the new allowance by unfortunate
292      * transaction ordering. One possible solution to mitigate this race
293      * condition is to first reduce the spender's allowance to 0 and set the
294      * desired value afterwards:
295      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296      *
297      * Emits an {Approval} event.
298      */
299     function approve(address spender, uint256 amount) external returns (bool);
300 
301     /**
302      * @dev Moves `amount` tokens from `from` to `to` using the
303      * allowance mechanism. `amount` is then deducted from the caller's
304      * allowance.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transferFrom(
311         address from,
312         address to,
313         uint256 amount
314     ) external returns (bool);
315 }
316 
317 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
318 
319 
320 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 
325 /**
326  * @dev Interface for the optional metadata functions from the ERC20 standard.
327  *
328  * _Available since v4.1._
329  */
330 interface IERC20Metadata is IERC20 {
331     /**
332      * @dev Returns the name of the token.
333      */
334     function name() external view returns (string memory);
335 
336     /**
337      * @dev Returns the symbol of the token.
338      */
339     function symbol() external view returns (string memory);
340 
341     /**
342      * @dev Returns the decimals places of the token.
343      */
344     function decimals() external view returns (uint8);
345 }
346 
347 // File: @openzeppelin/contracts/utils/Context.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Provides information about the current execution context, including the
356  * sender of the transaction and its data. While these are generally available
357  * via msg.sender and msg.data, they should not be accessed in such a direct
358  * manner, since when dealing with meta-transactions the account sending and
359  * paying for execution may not be the actual sender (as far as an application
360  * is concerned).
361  *
362  * This contract is only required for intermediate, library-like contracts.
363  */
364 abstract contract Context {
365     function _msgSender() internal view virtual returns (address) {
366         return msg.sender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes calldata) {
370         return msg.data;
371     }
372 }
373 
374 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
375 
376 
377 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 
383 
384 /**
385  * @dev Implementation of the {IERC20} interface.
386  *
387  * This implementation is agnostic to the way tokens are created. This means
388  * that a supply mechanism has to be added in a derived contract using {_mint}.
389  * For a generic mechanism see {ERC20PresetMinterPauser}.
390  *
391  * TIP: For a detailed writeup see our guide
392  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
393  * to implement supply mechanisms].
394  *
395  * We have followed general OpenZeppelin Contracts guidelines: functions revert
396  * instead returning `false` on failure. This behavior is nonetheless
397  * conventional and does not conflict with the expectations of ERC20
398  * applications.
399  *
400  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
401  * This allows applications to reconstruct the allowance for all accounts just
402  * by listening to said events. Other implementations of the EIP may not emit
403  * these events, as it isn't required by the specification.
404  *
405  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
406  * functions have been added to mitigate the well-known issues around setting
407  * allowances. See {IERC20-approve}.
408  */
409 contract ERC20 is Context, IERC20, IERC20Metadata {
410     mapping(address => uint256) private _balances;
411 
412     mapping(address => mapping(address => uint256)) private _allowances;
413 
414     uint256 private _totalSupply;
415 
416     string private _name;
417     string private _symbol;
418 
419     /**
420      * @dev Sets the values for {name} and {symbol}.
421      *
422      * The default value of {decimals} is 18. To select a different value for
423      * {decimals} you should overload it.
424      *
425      * All two of these values are immutable: they can only be set once during
426      * construction.
427      */
428     constructor(string memory name_, string memory symbol_) {
429         _name = name_;
430         _symbol = symbol_;
431     }
432 
433     /**
434      * @dev Returns the name of the token.
435      */
436     function name() public view virtual override returns (string memory) {
437         return _name;
438     }
439 
440     /**
441      * @dev Returns the symbol of the token, usually a shorter version of the
442      * name.
443      */
444     function symbol() public view virtual override returns (string memory) {
445         return _symbol;
446     }
447 
448     /**
449      * @dev Returns the number of decimals used to get its user representation.
450      * For example, if `decimals` equals `2`, a balance of `505` tokens should
451      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
452      *
453      * Tokens usually opt for a value of 18, imitating the relationship between
454      * Ether and Wei. This is the value {ERC20} uses, unless this function is
455      * overridden;
456      *
457      * NOTE: This information is only used for _display_ purposes: it in
458      * no way affects any of the arithmetic of the contract, including
459      * {IERC20-balanceOf} and {IERC20-transfer}.
460      */
461     function decimals() public view virtual override returns (uint8) {
462         return 18;
463     }
464 
465     /**
466      * @dev See {IERC20-totalSupply}.
467      */
468     function totalSupply() public view virtual override returns (uint256) {
469         return _totalSupply;
470     }
471 
472     /**
473      * @dev See {IERC20-balanceOf}.
474      */
475     function balanceOf(address account) public view virtual override returns (uint256) {
476         return _balances[account];
477     }
478 
479     /**
480      * @dev See {IERC20-transfer}.
481      *
482      * Requirements:
483      *
484      * - `to` cannot be the zero address.
485      * - the caller must have a balance of at least `amount`.
486      */
487     function transfer(address to, uint256 amount) public virtual override returns (bool) {
488         address owner = _msgSender();
489         _transfer(owner, to, amount);
490         return true;
491     }
492 
493     /**
494      * @dev See {IERC20-allowance}.
495      */
496     function allowance(address owner, address spender) public view virtual override returns (uint256) {
497         return _allowances[owner][spender];
498     }
499 
500     /**
501      * @dev See {IERC20-approve}.
502      *
503      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
504      * `transferFrom`. This is semantically equivalent to an infinite approval.
505      *
506      * Requirements:
507      *
508      * - `spender` cannot be the zero address.
509      */
510     function approve(address spender, uint256 amount) public virtual override returns (bool) {
511         address owner = _msgSender();
512         _approve(owner, spender, amount);
513         return true;
514     }
515 
516     /**
517      * @dev See {IERC20-transferFrom}.
518      *
519      * Emits an {Approval} event indicating the updated allowance. This is not
520      * required by the EIP. See the note at the beginning of {ERC20}.
521      *
522      * NOTE: Does not update the allowance if the current allowance
523      * is the maximum `uint256`.
524      *
525      * Requirements:
526      *
527      * - `from` and `to` cannot be the zero address.
528      * - `from` must have a balance of at least `amount`.
529      * - the caller must have allowance for ``from``'s tokens of at least
530      * `amount`.
531      */
532     function transferFrom(
533         address from,
534         address to,
535         uint256 amount
536     ) public virtual override returns (bool) {
537         address spender = _msgSender();
538         _spendAllowance(from, spender, amount);
539         _transfer(from, to, amount);
540         return true;
541     }
542 
543     /**
544      * @dev Atomically increases the allowance granted to `spender` by the caller.
545      *
546      * This is an alternative to {approve} that can be used as a mitigation for
547      * problems described in {IERC20-approve}.
548      *
549      * Emits an {Approval} event indicating the updated allowance.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
556         address owner = _msgSender();
557         _approve(owner, spender, allowance(owner, spender) + addedValue);
558         return true;
559     }
560 
561     /**
562      * @dev Atomically decreases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      * - `spender` must have allowance for the caller of at least
573      * `subtractedValue`.
574      */
575     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
576         address owner = _msgSender();
577         uint256 currentAllowance = allowance(owner, spender);
578         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
579         unchecked {
580             _approve(owner, spender, currentAllowance - subtractedValue);
581         }
582 
583         return true;
584     }
585 
586     /**
587      * @dev Moves `amount` of tokens from `from` to `to`.
588      *
589      * This internal function is equivalent to {transfer}, and can be used to
590      * e.g. implement automatic token fees, slashing mechanisms, etc.
591      *
592      * Emits a {Transfer} event.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `from` must have a balance of at least `amount`.
599      */
600     function _transfer(
601         address from,
602         address to,
603         uint256 amount
604     ) internal virtual {
605         require(from != address(0), "ERC20: transfer from the zero address");
606         require(to != address(0), "ERC20: transfer to the zero address");
607 
608         _beforeTokenTransfer(from, to, amount);
609 
610         uint256 fromBalance = _balances[from];
611         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
612         unchecked {
613             _balances[from] = fromBalance - amount;
614         }
615         _balances[to] += amount;
616 
617         emit Transfer(from, to, amount);
618 
619         _afterTokenTransfer(from, to, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements:
628      *
629      * - `account` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _beforeTokenTransfer(address(0), account, amount);
635 
636         _totalSupply += amount;
637         _balances[account] += amount;
638         emit Transfer(address(0), account, amount);
639 
640         _afterTokenTransfer(address(0), account, amount);
641     }
642 
643     /**
644      * @dev Destroys `amount` tokens from `account`, reducing the
645      * total supply.
646      *
647      * Emits a {Transfer} event with `to` set to the zero address.
648      *
649      * Requirements:
650      *
651      * - `account` cannot be the zero address.
652      * - `account` must have at least `amount` tokens.
653      */
654     function _burn(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: burn from the zero address");
656 
657         _beforeTokenTransfer(account, address(0), amount);
658 
659         uint256 accountBalance = _balances[account];
660         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
661         unchecked {
662             _balances[account] = accountBalance - amount;
663         }
664         _totalSupply -= amount;
665 
666         emit Transfer(account, address(0), amount);
667 
668         _afterTokenTransfer(account, address(0), amount);
669     }
670 
671     /**
672      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
673      *
674      * This internal function is equivalent to `approve`, and can be used to
675      * e.g. set automatic allowances for certain subsystems, etc.
676      *
677      * Emits an {Approval} event.
678      *
679      * Requirements:
680      *
681      * - `owner` cannot be the zero address.
682      * - `spender` cannot be the zero address.
683      */
684     function _approve(
685         address owner,
686         address spender,
687         uint256 amount
688     ) internal virtual {
689         require(owner != address(0), "ERC20: approve from the zero address");
690         require(spender != address(0), "ERC20: approve to the zero address");
691 
692         _allowances[owner][spender] = amount;
693         emit Approval(owner, spender, amount);
694     }
695 
696     /**
697      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
698      *
699      * Does not update the allowance amount in case of infinite allowance.
700      * Revert if not enough allowance is available.
701      *
702      * Might emit an {Approval} event.
703      */
704     function _spendAllowance(
705         address owner,
706         address spender,
707         uint256 amount
708     ) internal virtual {
709         uint256 currentAllowance = allowance(owner, spender);
710         if (currentAllowance != type(uint256).max) {
711             require(currentAllowance >= amount, "ERC20: insufficient allowance");
712             unchecked {
713                 _approve(owner, spender, currentAllowance - amount);
714             }
715         }
716     }
717 
718     /**
719      * @dev Hook that is called before any transfer of tokens. This includes
720      * minting and burning.
721      *
722      * Calling conditions:
723      *
724      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
725      * will be transferred to `to`.
726      * - when `from` is zero, `amount` tokens will be minted for `to`.
727      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
728      * - `from` and `to` are never both zero.
729      *
730      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
731      */
732     function _beforeTokenTransfer(
733         address from,
734         address to,
735         uint256 amount
736     ) internal virtual {}
737 
738     /**
739      * @dev Hook that is called after any transfer of tokens. This includes
740      * minting and burning.
741      *
742      * Calling conditions:
743      *
744      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
745      * has been transferred to `to`.
746      * - when `from` is zero, `amount` tokens have been minted for `to`.
747      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
748      * - `from` and `to` are never both zero.
749      *
750      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
751      */
752     function _afterTokenTransfer(
753         address from,
754         address to,
755         uint256 amount
756     ) internal virtual {}
757 }
758 
759 // File: @openzeppelin/contracts/access/Ownable.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @dev Contract module which provides a basic access control mechanism, where
769  * there is an account (an owner) that can be granted exclusive access to
770  * specific functions.
771  *
772  * By default, the owner account will be the one that deploys the contract. This
773  * can later be changed with {transferOwnership}.
774  *
775  * This module is used through inheritance. It will make available the modifier
776  * `onlyOwner`, which can be applied to your functions to restrict their use to
777  * the owner.
778  */
779 abstract contract Ownable is Context {
780     address private _owner;
781 
782     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
783 
784     /**
785      * @dev Initializes the contract setting the deployer as the initial owner.
786      */
787     constructor() {
788         _transferOwnership(_msgSender());
789     }
790 
791     /**
792      * @dev Throws if called by any account other than the owner.
793      */
794     modifier onlyOwner() {
795         _checkOwner();
796         _;
797     }
798 
799     /**
800      * @dev Returns the address of the current owner.
801      */
802     function owner() public view virtual returns (address) {
803         return _owner;
804     }
805 
806     /**
807      * @dev Throws if the sender is not the owner.
808      */
809     function _checkOwner() internal view virtual {
810         require(owner() == _msgSender(), "Ownable: caller is not the owner");
811     }
812 
813     /**
814      * @dev Leaves the contract without owner. It will not be possible to call
815      * `onlyOwner` functions anymore. Can only be called by the current owner.
816      *
817      * NOTE: Renouncing ownership will leave the contract without an owner,
818      * thereby removing any functionality that is only available to the owner.
819      */
820     function renounceOwnership() public virtual onlyOwner {
821         _transferOwnership(address(0));
822     }
823 
824     /**
825      * @dev Transfers ownership of the contract to a new account (`newOwner`).
826      * Can only be called by the current owner.
827      */
828     function transferOwnership(address newOwner) public virtual onlyOwner {
829         require(newOwner != address(0), "Ownable: new owner is the zero address");
830         _transferOwnership(newOwner);
831     }
832 
833     /**
834      * @dev Transfers ownership of the contract to a new account (`newOwner`).
835      * Internal function without access restriction.
836      */
837     function _transferOwnership(address newOwner) internal virtual {
838         address oldOwner = _owner;
839         _owner = newOwner;
840         emit OwnershipTransferred(oldOwner, newOwner);
841     }
842 }
843 
844 // File: random.sol
845 
846 
847 pragma solidity ^0.8.4;
848 
849 contract RandomExperiment is ERC20, Ownable {
850 
851     using SafeMath for uint256;
852 
853     mapping(address => bool) private pair;
854     bool public tradingOpen;
855     uint256 public _maxWalletSize =   210000 * 10 ** decimals();
856     uint256 private _totalSupply  = 10000000 * 10 ** decimals();
857 
858     constructor() ERC20("Collectivized Worth", "RNG") {
859 
860         _mint(msg.sender, _totalSupply);
861         
862     }
863 
864     function addPair(address toPair) public onlyOwner {
865         require(!pair[toPair], "This pair is already excluded");
866         pair[toPair] = true;
867     }
868 
869     function setTrading(bool _tradingOpen) public onlyOwner {
870         tradingOpen = _tradingOpen;
871     }
872 
873     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
874         _maxWalletSize = maxWalletSize;
875     }
876 
877     function removeLimits() public onlyOwner{
878         _maxWalletSize = _totalSupply;
879     }
880 
881     function _transfer(
882         address from,
883         address to,
884         uint256 amount
885     ) internal override {
886         require(from != address(0), "ERC20: transfer from the zero address");
887         require(to != address(0), "ERC20: transfer to the zero address");
888         require(amount > 0, "Transfer amount must be greater than zero");
889 
890        if(from != owner() && to != owner()) {
891 
892             //Trade start check
893             if (!tradingOpen) {
894                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
895             }
896 
897             //buy 
898             
899             if(from != owner() && to != owner() && pair[from]) {
900                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
901                 
902             }
903             
904             // transfer
905            
906             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
907                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
908             }
909 
910        }
911 
912        super._transfer(from, to, amount);
913 
914     }
915 
916 }