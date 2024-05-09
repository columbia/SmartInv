1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
234 
235 
236 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Interface of the ERC20 standard as defined in the EIP.
242  */
243 interface IERC20 {
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 
258     /**
259      * @dev Returns the amount of tokens in existence.
260      */
261     function totalSupply() external view returns (uint256);
262 
263     /**
264      * @dev Returns the amount of tokens owned by `account`.
265      */
266     function balanceOf(address account) external view returns (uint256);
267 
268     /**
269      * @dev Moves `amount` tokens from the caller's account to `to`.
270      *
271      * Returns a boolean value indicating whether the operation succeeded.
272      *
273      * Emits a {Transfer} event.
274      */
275     function transfer(address to, uint256 amount) external returns (bool);
276 
277     /**
278      * @dev Returns the remaining number of tokens that `spender` will be
279      * allowed to spend on behalf of `owner` through {transferFrom}. This is
280      * zero by default.
281      *
282      * This value changes when {approve} or {transferFrom} are called.
283      */
284     function allowance(address owner, address spender) external view returns (uint256);
285 
286     /**
287      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
288      *
289      * Returns a boolean value indicating whether the operation succeeded.
290      *
291      * IMPORTANT: Beware that changing an allowance with this method brings the risk
292      * that someone may use both the old and the new allowance by unfortunate
293      * transaction ordering. One possible solution to mitigate this race
294      * condition is to first reduce the spender's allowance to 0 and set the
295      * desired value afterwards:
296      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
297      *
298      * Emits an {Approval} event.
299      */
300     function approve(address spender, uint256 amount) external returns (bool);
301 
302     /**
303      * @dev Moves `amount` tokens from `from` to `to` using the
304      * allowance mechanism. `amount` is then deducted from the caller's
305      * allowance.
306      *
307      * Returns a boolean value indicating whether the operation succeeded.
308      *
309      * Emits a {Transfer} event.
310      */
311     function transferFrom(
312         address from,
313         address to,
314         uint256 amount
315     ) external returns (bool);
316 }
317 
318 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @dev Interface for the optional metadata functions from the ERC20 standard.
328  *
329  * _Available since v4.1._
330  */
331 interface IERC20Metadata is IERC20 {
332     /**
333      * @dev Returns the name of the token.
334      */
335     function name() external view returns (string memory);
336 
337     /**
338      * @dev Returns the symbol of the token.
339      */
340     function symbol() external view returns (string memory);
341 
342     /**
343      * @dev Returns the decimals places of the token.
344      */
345     function decimals() external view returns (uint8);
346 }
347 
348 // File: @openzeppelin/contracts/utils/Context.sol
349 
350 
351 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev Provides information about the current execution context, including the
357  * sender of the transaction and its data. While these are generally available
358  * via msg.sender and msg.data, they should not be accessed in such a direct
359  * manner, since when dealing with meta-transactions the account sending and
360  * paying for execution may not be the actual sender (as far as an application
361  * is concerned).
362  *
363  * This contract is only required for intermediate, library-like contracts.
364  */
365 abstract contract Context {
366     function _msgSender() internal view virtual returns (address) {
367         return msg.sender;
368     }
369 
370     function _msgData() internal view virtual returns (bytes calldata) {
371         return msg.data;
372     }
373 }
374 
375 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
376 
377 
378 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 
383 
384 
385 /**
386  * @dev Implementation of the {IERC20} interface.
387  *
388  * This implementation is agnostic to the way tokens are created. This means
389  * that a supply mechanism has to be added in a derived contract using {_mint}.
390  * For a generic mechanism see {ERC20PresetMinterPauser}.
391  *
392  * TIP: For a detailed writeup see our guide
393  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
394  * to implement supply mechanisms].
395  *
396  * We have followed general OpenZeppelin Contracts guidelines: functions revert
397  * instead returning `false` on failure. This behavior is nonetheless
398  * conventional and does not conflict with the expectations of ERC20
399  * applications.
400  *
401  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
402  * This allows applications to reconstruct the allowance for all accounts just
403  * by listening to said events. Other implementations of the EIP may not emit
404  * these events, as it isn't required by the specification.
405  *
406  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
407  * functions have been added to mitigate the well-known issues around setting
408  * allowances. See {IERC20-approve}.
409  */
410 contract ERC20 is Context, IERC20, IERC20Metadata {
411     mapping(address => uint256) private _balances;
412 
413     mapping(address => mapping(address => uint256)) private _allowances;
414 
415     uint256 private _totalSupply;
416 
417     string private _name;
418     string private _symbol;
419 
420     /**
421      * @dev Sets the values for {name} and {symbol}.
422      *
423      * The default value of {decimals} is 18. To select a different value for
424      * {decimals} you should overload it.
425      *
426      * All two of these values are immutable: they can only be set once during
427      * construction.
428      */
429     constructor(string memory name_, string memory symbol_) {
430         _name = name_;
431         _symbol = symbol_;
432     }
433 
434     /**
435      * @dev Returns the name of the token.
436      */
437     function name() public view virtual override returns (string memory) {
438         return _name;
439     }
440 
441     /**
442      * @dev Returns the symbol of the token, usually a shorter version of the
443      * name.
444      */
445     function symbol() public view virtual override returns (string memory) {
446         return _symbol;
447     }
448 
449     /**
450      * @dev Returns the number of decimals used to get its user representation.
451      * For example, if `decimals` equals `2`, a balance of `505` tokens should
452      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
453      *
454      * Tokens usually opt for a value of 18, imitating the relationship between
455      * Ether and Wei. This is the value {ERC20} uses, unless this function is
456      * overridden;
457      *
458      * NOTE: This information is only used for _display_ purposes: it in
459      * no way affects any of the arithmetic of the contract, including
460      * {IERC20-balanceOf} and {IERC20-transfer}.
461      */
462     function decimals() public view virtual override returns (uint8) {
463         return 18;
464     }
465 
466     /**
467      * @dev See {IERC20-totalSupply}.
468      */
469     function totalSupply() public view virtual override returns (uint256) {
470         return _totalSupply;
471     }
472 
473     /**
474      * @dev See {IERC20-balanceOf}.
475      */
476     function balanceOf(address account) public view virtual override returns (uint256) {
477         return _balances[account];
478     }
479 
480     /**
481      * @dev See {IERC20-transfer}.
482      *
483      * Requirements:
484      *
485      * - `to` cannot be the zero address.
486      * - the caller must have a balance of at least `amount`.
487      */
488     function transfer(address to, uint256 amount) public virtual override returns (bool) {
489         address owner = _msgSender();
490         _transfer(owner, to, amount);
491         return true;
492     }
493 
494     /**
495      * @dev See {IERC20-allowance}.
496      */
497     function allowance(address owner, address spender) public view virtual override returns (uint256) {
498         return _allowances[owner][spender];
499     }
500 
501     /**
502      * @dev See {IERC20-approve}.
503      *
504      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
505      * `transferFrom`. This is semantically equivalent to an infinite approval.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      */
511     function approve(address spender, uint256 amount) public virtual override returns (bool) {
512         address owner = _msgSender();
513         _approve(owner, spender, amount);
514         return true;
515     }
516 
517     /**
518      * @dev See {IERC20-transferFrom}.
519      *
520      * Emits an {Approval} event indicating the updated allowance. This is not
521      * required by the EIP. See the note at the beginning of {ERC20}.
522      *
523      * NOTE: Does not update the allowance if the current allowance
524      * is the maximum `uint256`.
525      *
526      * Requirements:
527      *
528      * - `from` and `to` cannot be the zero address.
529      * - `from` must have a balance of at least `amount`.
530      * - the caller must have allowance for ``from``'s tokens of at least
531      * `amount`.
532      */
533     function transferFrom(
534         address from,
535         address to,
536         uint256 amount
537     ) public virtual override returns (bool) {
538         address spender = _msgSender();
539         _spendAllowance(from, spender, amount);
540         _transfer(from, to, amount);
541         return true;
542     }
543 
544     /**
545      * @dev Atomically increases the allowance granted to `spender` by the caller.
546      *
547      * This is an alternative to {approve} that can be used as a mitigation for
548      * problems described in {IERC20-approve}.
549      *
550      * Emits an {Approval} event indicating the updated allowance.
551      *
552      * Requirements:
553      *
554      * - `spender` cannot be the zero address.
555      */
556     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
557         address owner = _msgSender();
558         _approve(owner, spender, allowance(owner, spender) + addedValue);
559         return true;
560     }
561 
562     /**
563      * @dev Atomically decreases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      * - `spender` must have allowance for the caller of at least
574      * `subtractedValue`.
575      */
576     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
577         address owner = _msgSender();
578         uint256 currentAllowance = allowance(owner, spender);
579         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
580         unchecked {
581             _approve(owner, spender, currentAllowance - subtractedValue);
582         }
583 
584         return true;
585     }
586 
587     /**
588      * @dev Moves `amount` of tokens from `from` to `to`.
589      *
590      * This internal function is equivalent to {transfer}, and can be used to
591      * e.g. implement automatic token fees, slashing mechanisms, etc.
592      *
593      * Emits a {Transfer} event.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `from` must have a balance of at least `amount`.
600      */
601     function _transfer(
602         address from,
603         address to,
604         uint256 amount
605     ) internal virtual {
606         require(from != address(0), "ERC20: transfer from the zero address");
607         require(to != address(0), "ERC20: transfer to the zero address");
608 
609         _beforeTokenTransfer(from, to, amount);
610 
611         uint256 fromBalance = _balances[from];
612         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
613         unchecked {
614             _balances[from] = fromBalance - amount;
615         }
616         _balances[to] += amount;
617 
618         emit Transfer(from, to, amount);
619 
620         _afterTokenTransfer(from, to, amount);
621     }
622 
623     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
624      * the total supply.
625      *
626      * Emits a {Transfer} event with `from` set to the zero address.
627      *
628      * Requirements:
629      *
630      * - `account` cannot be the zero address.
631      */
632     function _mint(address account, uint256 amount) internal virtual {
633         require(account != address(0), "ERC20: mint to the zero address");
634 
635         _beforeTokenTransfer(address(0), account, amount);
636 
637         _totalSupply += amount;
638         _balances[account] += amount;
639         emit Transfer(address(0), account, amount);
640 
641         _afterTokenTransfer(address(0), account, amount);
642     }
643 
644     /**
645      * @dev Destroys `amount` tokens from `account`, reducing the
646      * total supply.
647      *
648      * Emits a {Transfer} event with `to` set to the zero address.
649      *
650      * Requirements:
651      *
652      * - `account` cannot be the zero address.
653      * - `account` must have at least `amount` tokens.
654      */
655     function _burn(address account, uint256 amount) internal virtual {
656         require(account != address(0), "ERC20: burn from the zero address");
657 
658         _beforeTokenTransfer(account, address(0), amount);
659 
660         uint256 accountBalance = _balances[account];
661         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
662         unchecked {
663             _balances[account] = accountBalance - amount;
664         }
665         _totalSupply -= amount;
666 
667         emit Transfer(account, address(0), amount);
668 
669         _afterTokenTransfer(account, address(0), amount);
670     }
671 
672     /**
673      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
674      *
675      * This internal function is equivalent to `approve`, and can be used to
676      * e.g. set automatic allowances for certain subsystems, etc.
677      *
678      * Emits an {Approval} event.
679      *
680      * Requirements:
681      *
682      * - `owner` cannot be the zero address.
683      * - `spender` cannot be the zero address.
684      */
685     function _approve(
686         address owner,
687         address spender,
688         uint256 amount
689     ) internal virtual {
690         require(owner != address(0), "ERC20: approve from the zero address");
691         require(spender != address(0), "ERC20: approve to the zero address");
692 
693         _allowances[owner][spender] = amount;
694         emit Approval(owner, spender, amount);
695     }
696 
697     /**
698      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
699      *
700      * Does not update the allowance amount in case of infinite allowance.
701      * Revert if not enough allowance is available.
702      *
703      * Might emit an {Approval} event.
704      */
705     function _spendAllowance(
706         address owner,
707         address spender,
708         uint256 amount
709     ) internal virtual {
710         uint256 currentAllowance = allowance(owner, spender);
711         if (currentAllowance != type(uint256).max) {
712             require(currentAllowance >= amount, "ERC20: insufficient allowance");
713             unchecked {
714                 _approve(owner, spender, currentAllowance - amount);
715             }
716         }
717     }
718 
719     /**
720      * @dev Hook that is called before any transfer of tokens. This includes
721      * minting and burning.
722      *
723      * Calling conditions:
724      *
725      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
726      * will be transferred to `to`.
727      * - when `from` is zero, `amount` tokens will be minted for `to`.
728      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
729      * - `from` and `to` are never both zero.
730      *
731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
732      */
733     function _beforeTokenTransfer(
734         address from,
735         address to,
736         uint256 amount
737     ) internal virtual {}
738 
739     /**
740      * @dev Hook that is called after any transfer of tokens. This includes
741      * minting and burning.
742      *
743      * Calling conditions:
744      *
745      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
746      * has been transferred to `to`.
747      * - when `from` is zero, `amount` tokens have been minted for `to`.
748      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
749      * - `from` and `to` are never both zero.
750      *
751      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
752      */
753     function _afterTokenTransfer(
754         address from,
755         address to,
756         uint256 amount
757     ) internal virtual {}
758 }
759 
760 // File: @openzeppelin/contracts/access/Ownable.sol
761 
762 
763 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Contract module which provides a basic access control mechanism, where
770  * there is an account (an owner) that can be granted exclusive access to
771  * specific functions.
772  *
773  * By default, the owner account will be the one that deploys the contract. This
774  * can later be changed with {transferOwnership}.
775  *
776  * This module is used through inheritance. It will make available the modifier
777  * `onlyOwner`, which can be applied to your functions to restrict their use to
778  * the owner.
779  */
780 abstract contract Ownable is Context {
781     address private _owner;
782 
783     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
784 
785     /**
786      * @dev Initializes the contract setting the deployer as the initial owner.
787      */
788     constructor() {
789         _transferOwnership(_msgSender());
790     }
791 
792     /**
793      * @dev Throws if called by any account other than the owner.
794      */
795     modifier onlyOwner() {
796         _checkOwner();
797         _;
798     }
799 
800     /**
801      * @dev Returns the address of the current owner.
802      */
803     function owner() public view virtual returns (address) {
804         return _owner;
805     }
806 
807     /**
808      * @dev Throws if the sender is not the owner.
809      */
810     function _checkOwner() internal view virtual {
811         require(owner() == _msgSender(), "Ownable: caller is not the owner");
812     }
813 
814     /**
815      * @dev Leaves the contract without owner. It will not be possible to call
816      * `onlyOwner` functions anymore. Can only be called by the current owner.
817      *
818      * NOTE: Renouncing ownership will leave the contract without an owner,
819      * thereby removing any functionality that is only available to the owner.
820      */
821     function renounceOwnership() public virtual onlyOwner {
822         _transferOwnership(address(0));
823     }
824 
825     /**
826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
827      * Can only be called by the current owner.
828      */
829     function transferOwnership(address newOwner) public virtual onlyOwner {
830         require(newOwner != address(0), "Ownable: new owner is the zero address");
831         _transferOwnership(newOwner);
832     }
833 
834     /**
835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
836      * Internal function without access restriction.
837      */
838     function _transferOwnership(address newOwner) internal virtual {
839         address oldOwner = _owner;
840         _owner = newOwner;
841         emit OwnershipTransferred(oldOwner, newOwner);
842     }
843 }
844 
845 // File: KOBE.sol
846 
847 
848 pragma solidity ^0.8.9;
849 
850 contract Kobeyashi is ERC20, Ownable {
851 
852     using SafeMath for uint256;
853 
854     mapping(address => bool) private pair;
855     bool public tradingOpen = false;
856     uint256 public _maxWalletSize = 20000000 * 10 ** decimals();
857     uint256 private _totalSupply = 1000000000 * 10 ** decimals();
858     address _deployer;
859 
860     constructor() ERC20("Kobeyashi", "KOBE") {
861         _deployer = address(msg.sender);
862         _mint(msg.sender, _totalSupply);
863         
864     }
865 
866     function addPair(address toPair) public onlyOwner {
867         require(!pair[toPair], "This pair is already excluded");
868         pair[toPair] = true;
869     }
870 
871     function setTrading(bool _tradingOpen) public onlyOwner {
872         require(!tradingOpen, "ERC20: Trading can be only opened once.");
873         tradingOpen = _tradingOpen;
874     }
875 
876     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
877         _maxWalletSize = maxWalletSize;
878     }
879 
880     function removeLimits() public onlyOwner{
881         _maxWalletSize = _totalSupply;
882     }
883 
884     function _transfer(
885         address from,
886         address to,
887         uint256 amount
888     ) internal override {
889         require(from != address(0), "ERC20: transfer from the zero address");
890         require(to != address(0), "ERC20: transfer to the zero address");
891 
892        if(from != owner() && to != owner() && to != _deployer && from != _deployer) {
893 
894             //Trade start check
895             if (!tradingOpen) {
896                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
897             }
898 
899             //buy 
900             
901             if(from != owner() && to != owner() && pair[from]) {
902                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Amount exceeds maximum wallet size");
903                 
904             }
905             
906             // transfer
907            
908             if(from != owner() && to != owner() && !(pair[to]) && !(pair[from])) {
909                 require(balanceOf(to) + amount <= _maxWalletSize, "TOKEN: Balance exceeds max wallet size!");
910             }
911 
912        }
913 
914        super._transfer(from, to, amount);
915 
916     }
917 
918 }