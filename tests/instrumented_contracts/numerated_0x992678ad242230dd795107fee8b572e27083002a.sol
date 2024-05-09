1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 // CAUTION
75 // This version of SafeMath should only be used with Solidity 0.8 or later,
76 // because it relies on the compiler's built in overflow checks.
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations.
80  *
81  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
82  * now has built in overflow checking.
83  */
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             uint256 c = a + b;
93             if (c < a) return (false, 0);
94             return (true, c);
95         }
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             if (b > a) return (false, 0);
106             return (true, a - b);
107         }
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118             // benefit is lost if 'b' is also tested.
119             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120             if (a == 0) return (true, 0);
121             uint256 c = a * b;
122             if (c / a != b) return (false, 0);
123             return (true, c);
124         }
125     }
126 
127     /**
128      * @dev Returns the division of two unsigned integers, with a division by zero flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             if (b == 0) return (false, 0);
135             return (true, a / b);
136         }
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a % b);
148         }
149     }
150 
151     /**
152      * @dev Returns the addition of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `+` operator.
156      *
157      * Requirements:
158      *
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a + b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a * b;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator.
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a / b;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a % b;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * CAUTION: This function is deprecated because it requires allocating memory for the error
228      * message unnecessarily. For custom revert reasons use {trySub}.
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b <= a, errorMessage);
243             return a - b;
244         }
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a / b;
267         }
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting with custom message when dividing by zero.
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {tryMod}.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b > 0, errorMessage);
292             return a % b;
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Context.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         return msg.data;
321     }
322 }
323 
324 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP.
333  */
334 interface IERC20 {
335     /**
336      * @dev Emitted when `value` tokens are moved from one account (`from`) to
337      * another (`to`).
338      *
339      * Note that `value` may be zero.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 value);
342 
343     /**
344      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
345      * a call to {approve}. `value` is the new allowance.
346      */
347     event Approval(address indexed owner, address indexed spender, uint256 value);
348 
349     /**
350      * @dev Returns the amount of tokens in existence.
351      */
352     function totalSupply() external view returns (uint256);
353 
354     /**
355      * @dev Returns the amount of tokens owned by `account`.
356      */
357     function balanceOf(address account) external view returns (uint256);
358 
359     /**
360      * @dev Moves `amount` tokens from the caller's account to `to`.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * Emits a {Transfer} event.
365      */
366     function transfer(address to, uint256 amount) external returns (bool);
367 
368     /**
369      * @dev Returns the remaining number of tokens that `spender` will be
370      * allowed to spend on behalf of `owner` through {transferFrom}. This is
371      * zero by default.
372      *
373      * This value changes when {approve} or {transferFrom} are called.
374      */
375     function allowance(address owner, address spender) external view returns (uint256);
376 
377     /**
378      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * IMPORTANT: Beware that changing an allowance with this method brings the risk
383      * that someone may use both the old and the new allowance by unfortunate
384      * transaction ordering. One possible solution to mitigate this race
385      * condition is to first reduce the spender's allowance to 0 and set the
386      * desired value afterwards:
387      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
388      *
389      * Emits an {Approval} event.
390      */
391     function approve(address spender, uint256 amount) external returns (bool);
392 
393     /**
394      * @dev Moves `amount` tokens from `from` to `to` using the
395      * allowance mechanism. `amount` is then deducted from the caller's
396      * allowance.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transferFrom(
403         address from,
404         address to,
405         uint256 amount
406     ) external returns (bool);
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
410 
411 
412 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 
417 /**
418  * @dev Interface for the optional metadata functions from the ERC20 standard.
419  *
420  * _Available since v4.1._
421  */
422 interface IERC20Metadata is IERC20 {
423     /**
424      * @dev Returns the name of the token.
425      */
426     function name() external view returns (string memory);
427 
428     /**
429      * @dev Returns the symbol of the token.
430      */
431     function symbol() external view returns (string memory);
432 
433     /**
434      * @dev Returns the decimals places of the token.
435      */
436     function decimals() external view returns (uint8);
437 }
438 
439 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
440 
441 
442 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
443 
444 pragma solidity ^0.8.0;
445 
446 
447 
448 
449 /**
450  * @dev Implementation of the {IERC20} interface.
451  *
452  * This implementation is agnostic to the way tokens are created. This means
453  * that a supply mechanism has to be added in a derived contract using {_mint}.
454  * For a generic mechanism see {ERC20PresetMinterPauser}.
455  *
456  * TIP: For a detailed writeup see our guide
457  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
458  * to implement supply mechanisms].
459  *
460  * We have followed general OpenZeppelin Contracts guidelines: functions revert
461  * instead returning `false` on failure. This behavior is nonetheless
462  * conventional and does not conflict with the expectations of ERC20
463  * applications.
464  *
465  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
466  * This allows applications to reconstruct the allowance for all accounts just
467  * by listening to said events. Other implementations of the EIP may not emit
468  * these events, as it isn't required by the specification.
469  *
470  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
471  * functions have been added to mitigate the well-known issues around setting
472  * allowances. See {IERC20-approve}.
473  */
474 contract ERC20 is Context, IERC20, IERC20Metadata {
475     mapping(address => uint256) private _balances;
476 
477     mapping(address => mapping(address => uint256)) private _allowances;
478 
479     uint256 private _totalSupply;
480 
481     string private _name;
482     string private _symbol;
483 
484     /**
485      * @dev Sets the values for {name} and {symbol}.
486      *
487      * The default value of {decimals} is 18. To select a different value for
488      * {decimals} you should overload it.
489      *
490      * All two of these values are immutable: they can only be set once during
491      * construction.
492      */
493     constructor(string memory name_, string memory symbol_) {
494         _name = name_;
495         _symbol = symbol_;
496     }
497 
498     /**
499      * @dev Returns the name of the token.
500      */
501     function name() public view virtual override returns (string memory) {
502         return _name;
503     }
504 
505     /**
506      * @dev Returns the symbol of the token, usually a shorter version of the
507      * name.
508      */
509     function symbol() public view virtual override returns (string memory) {
510         return _symbol;
511     }
512 
513     /**
514      * @dev Returns the number of decimals used to get its user representation.
515      * For example, if `decimals` equals `2`, a balance of `505` tokens should
516      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
517      *
518      * Tokens usually opt for a value of 18, imitating the relationship between
519      * Ether and Wei. This is the value {ERC20} uses, unless this function is
520      * overridden;
521      *
522      * NOTE: This information is only used for _display_ purposes: it in
523      * no way affects any of the arithmetic of the contract, including
524      * {IERC20-balanceOf} and {IERC20-transfer}.
525      */
526     function decimals() public view virtual override returns (uint8) {
527         return 18;
528     }
529 
530     /**
531      * @dev See {IERC20-totalSupply}.
532      */
533     function totalSupply() public view virtual override returns (uint256) {
534         return _totalSupply;
535     }
536 
537     /**
538      * @dev See {IERC20-balanceOf}.
539      */
540     function balanceOf(address account) public view virtual override returns (uint256) {
541         return _balances[account];
542     }
543 
544     /**
545      * @dev See {IERC20-transfer}.
546      *
547      * Requirements:
548      *
549      * - `to` cannot be the zero address.
550      * - the caller must have a balance of at least `amount`.
551      */
552     function transfer(address to, uint256 amount) public virtual override returns (bool) {
553         address owner = _msgSender();
554         _transfer(owner, to, amount);
555         return true;
556     }
557 
558     /**
559      * @dev See {IERC20-allowance}.
560      */
561     function allowance(address owner, address spender) public view virtual override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     /**
566      * @dev See {IERC20-approve}.
567      *
568      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
569      * `transferFrom`. This is semantically equivalent to an infinite approval.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function approve(address spender, uint256 amount) public virtual override returns (bool) {
576         address owner = _msgSender();
577         _approve(owner, spender, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-transferFrom}.
583      *
584      * Emits an {Approval} event indicating the updated allowance. This is not
585      * required by the EIP. See the note at the beginning of {ERC20}.
586      *
587      * NOTE: Does not update the allowance if the current allowance
588      * is the maximum `uint256`.
589      *
590      * Requirements:
591      *
592      * - `from` and `to` cannot be the zero address.
593      * - `from` must have a balance of at least `amount`.
594      * - the caller must have allowance for ``from``'s tokens of at least
595      * `amount`.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 amount
601     ) public virtual override returns (bool) {
602         address spender = _msgSender();
603         _spendAllowance(from, spender, amount);
604         _transfer(from, to, amount);
605         return true;
606     }
607 
608     /**
609      * @dev Atomically increases the allowance granted to `spender` by the caller.
610      *
611      * This is an alternative to {approve} that can be used as a mitigation for
612      * problems described in {IERC20-approve}.
613      *
614      * Emits an {Approval} event indicating the updated allowance.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
621         address owner = _msgSender();
622         _approve(owner, spender, allowance(owner, spender) + addedValue);
623         return true;
624     }
625 
626     /**
627      * @dev Atomically decreases the allowance granted to `spender` by the caller.
628      *
629      * This is an alternative to {approve} that can be used as a mitigation for
630      * problems described in {IERC20-approve}.
631      *
632      * Emits an {Approval} event indicating the updated allowance.
633      *
634      * Requirements:
635      *
636      * - `spender` cannot be the zero address.
637      * - `spender` must have allowance for the caller of at least
638      * `subtractedValue`.
639      */
640     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
641         address owner = _msgSender();
642         uint256 currentAllowance = allowance(owner, spender);
643         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
644         unchecked {
645             _approve(owner, spender, currentAllowance - subtractedValue);
646         }
647 
648         return true;
649     }
650 
651     /**
652      * @dev Moves `amount` of tokens from `from` to `to`.
653      *
654      * This internal function is equivalent to {transfer}, and can be used to
655      * e.g. implement automatic token fees, slashing mechanisms, etc.
656      *
657      * Emits a {Transfer} event.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `from` must have a balance of at least `amount`.
664      */
665     function _transfer(
666         address from,
667         address to,
668         uint256 amount
669     ) internal virtual {
670         require(from != address(0), "ERC20: transfer from the zero address");
671         require(to != address(0), "ERC20: transfer to the zero address");
672 
673         _beforeTokenTransfer(from, to, amount);
674 
675         uint256 fromBalance = _balances[from];
676         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
677         unchecked {
678             _balances[from] = fromBalance - amount;
679         }
680         _balances[to] += amount;
681 
682         emit Transfer(from, to, amount);
683 
684         _afterTokenTransfer(from, to, amount);
685     }
686 
687     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
688      * the total supply.
689      *
690      * Emits a {Transfer} event with `from` set to the zero address.
691      *
692      * Requirements:
693      *
694      * - `account` cannot be the zero address.
695      */
696     function _mint(address account, uint256 amount) internal virtual {
697         require(account != address(0), "ERC20: mint to the zero address");
698 
699         _beforeTokenTransfer(address(0), account, amount);
700 
701         _totalSupply += amount;
702         _balances[account] += amount;
703         emit Transfer(address(0), account, amount);
704 
705         _afterTokenTransfer(address(0), account, amount);
706     }
707 
708     /**
709      * @dev Destroys `amount` tokens from `account`, reducing the
710      * total supply.
711      *
712      * Emits a {Transfer} event with `to` set to the zero address.
713      *
714      * Requirements:
715      *
716      * - `account` cannot be the zero address.
717      * - `account` must have at least `amount` tokens.
718      */
719     function _burn(address account, uint256 amount) internal virtual {
720         require(account != address(0), "ERC20: burn from the zero address");
721 
722         _beforeTokenTransfer(account, address(0), amount);
723 
724         uint256 accountBalance = _balances[account];
725         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
726         unchecked {
727             _balances[account] = accountBalance - amount;
728         }
729         _totalSupply -= amount;
730 
731         emit Transfer(account, address(0), amount);
732 
733         _afterTokenTransfer(account, address(0), amount);
734     }
735 
736     /**
737      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
738      *
739      * This internal function is equivalent to `approve`, and can be used to
740      * e.g. set automatic allowances for certain subsystems, etc.
741      *
742      * Emits an {Approval} event.
743      *
744      * Requirements:
745      *
746      * - `owner` cannot be the zero address.
747      * - `spender` cannot be the zero address.
748      */
749     function _approve(
750         address owner,
751         address spender,
752         uint256 amount
753     ) internal virtual {
754         require(owner != address(0), "ERC20: approve from the zero address");
755         require(spender != address(0), "ERC20: approve to the zero address");
756 
757         _allowances[owner][spender] = amount;
758         emit Approval(owner, spender, amount);
759     }
760 
761     /**
762      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
763      *
764      * Does not update the allowance amount in case of infinite allowance.
765      * Revert if not enough allowance is available.
766      *
767      * Might emit an {Approval} event.
768      */
769     function _spendAllowance(
770         address owner,
771         address spender,
772         uint256 amount
773     ) internal virtual {
774         uint256 currentAllowance = allowance(owner, spender);
775         if (currentAllowance != type(uint256).max) {
776             require(currentAllowance >= amount, "ERC20: insufficient allowance");
777             unchecked {
778                 _approve(owner, spender, currentAllowance - amount);
779             }
780         }
781     }
782 
783     /**
784      * @dev Hook that is called before any transfer of tokens. This includes
785      * minting and burning.
786      *
787      * Calling conditions:
788      *
789      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
790      * will be transferred to `to`.
791      * - when `from` is zero, `amount` tokens will be minted for `to`.
792      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
793      * - `from` and `to` are never both zero.
794      *
795      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
796      */
797     function _beforeTokenTransfer(
798         address from,
799         address to,
800         uint256 amount
801     ) internal virtual {}
802 
803     /**
804      * @dev Hook that is called after any transfer of tokens. This includes
805      * minting and burning.
806      *
807      * Calling conditions:
808      *
809      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
810      * has been transferred to `to`.
811      * - when `from` is zero, `amount` tokens have been minted for `to`.
812      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
813      * - `from` and `to` are never both zero.
814      *
815      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
816      */
817     function _afterTokenTransfer(
818         address from,
819         address to,
820         uint256 amount
821     ) internal virtual {}
822 }
823 
824 // File: contracts/diamondhands.sol
825 
826 //SPDX-License-Identifier: UNLICENSED
827 pragma solidity ^0.8.2;
828 
829 
830 
831 
832 
833 
834 
835 contract TEAMContract {
836     function getPoolAddresses(string memory ticker) public view returns (address) {}
837 }
838 contract PerpetualContract {
839     function getCurrentPeriod() external view returns (uint256){}
840     uint256 public STAKE_START_DAY; // the day when the current stake starts, is updated as each stake starts
841     uint256 public STAKE_END_DAY; // the day when the current stake ends, is updated as each stake starts
842     uint256 public STAKE_LENGTH;
843     function getHexDay() external view returns (uint256){}
844 
845 }
846 /*
847 Diamond Hands Club is a contract that allows holders of the Maximus Perpetual Pool tokens to 
848 timelock their tokens for the duration of the corresponding HEX stake pool and earn additional rewards. 
849 This contract is deployed for each of the Perpetual Pools and runs on that pool's stake schedule.
850 Joining the Diamond Hands Club is fully voluntary and there is a penalty applied to any amount that is unlocked early.
851 Penalty = amount* 0.0369 * 3696 / stake length
852 
853 How it works
854 1. Choose amount you want to lock.
855 2. Lock in before the Perpetual Pool stake starts by running joinClub(amount) which transfers your Perpetual Pool tokens to the Diamond Hand Contract.
856 3. If you unlock before the Perpetual Pool stake ends, the penalty applied to the amount early unlocked goes into the Reward Bucket Contract. 
857 4. After the stake ends, The contents of the Reward Bucket are sent to the Stake Reward Distribution contract and you can reclaim your pool tokens from the DH contract and claim your portion of the rewards from that period from the Stake Reward Distribution Contract containing:
858     1. Pool tokens from early unlock penalty
859     2. Any TEAM or MAXI that happens to be mysteriously airdropped to the Reward Bucket by motivated TEAM members trying to incentivize perpetual pool participation.
860 
861 
862 Period 0: Perpetual Pool Minting Phase - ends September 26
863 What Happens? Users can enter the first timelock period.
864 Functions available:
865 - joinClub(amount) commits them into the upcoming stake period
866 - earlyEndStake(amount) if they have already joined the upcoming stake period
867 
868 Period 1: Stake Phase
869 What Happens? Users are locked in, and if they unlock early they experience a penalty that is redistributed to the people that stay locked the whole period.
870 Functions available:
871 - joinClub(amount) commits them into the next stake period
872 - earlyEndStake(amount, stakeID) if they are currently locked into the current stake period or have already joined the upcoming stake period
873 - extendStake(stakeID) rolls their existing stake into the next stake period
874 
875 Period 2: Reload Phase
876 What Happens? After the corresponding perpetual pool stake ends users can reclaim their locked tokens and claim rewards from the prior period. They can also enter the next timelock period.
877 - joinClub(amount) commits them into the next stake period
878 - earlyEndStake(amount, stakeID) if they are currently locked into the current stake period or have already joined the upcoming stake period
879 - restakeExpiredStake(stakeID) rolls their existing stake into the next stake period
880 - endExpiredStake(stakeID) closes out their existing stake and returns their timelocked tokens.
881 
882 Period 3:Stake Phase
883 Period 4: Reload Phase
884 REPEAT FOREVER
885 
886 */
887 contract DiamondHandsClub is ReentrancyGuard {
888     /*
889     Post-deployment instructions: 
890     1. run deployStakeRewardDistributionContract()
891     2. run deployRewardBucketContract()
892     */
893     event Stake(
894         address indexed staker,
895         uint256 amount, 
896         uint256 current_period,
897         uint256 stakeID, 
898         bool is_initial);
899     event ExtendStake(
900         address indexed staker,
901         uint256 amount, 
902         uint256 staking_period, 
903         uint256 stakeID);
904     event EarlyEndStake(address indexed staker,
905         uint256 amount, 
906         uint256 staking_period, 
907         uint256 stakeID);
908     event EndExpiredStake(address indexed staker,
909         uint256 amount, 
910         uint256 staking_period, 
911         uint256 stakeID);
912     event RestakeExpiredStake(address indexed staker,
913         uint256 amount, 
914         uint256 staking_period, 
915         uint256 stakeID);
916     address public PERPETUAL_POOL_ADDRESS;
917     address public constant TEAM_CONTRACT_ADDRESS=0xB7c9E99Da8A857cE576A830A9c19312114d9dE02;
918     TEAMContract TeamContract = TEAMContract(TEAM_CONTRACT_ADDRESS);  
919     PerpetualContract PoolContract;
920     IERC20 PoolERC;
921     uint256 public GLOBAL_AMOUNT_STAKED;  // Running total number of Pool tokens staked by all users. Incremented when any user stakes Pool tokens and decremented when any user end-stakes Pool Tokens.
922     mapping (address=> uint256) public USER_AMOUNT_STAKED;// Running total number of Tokens staked per user. Incremented when user stakes Tokens and decremented when user end-stakes Tokens.
923     address public STAKE_REWARD_DISTRIBUTION_ADDRESS; // Contract that the reward bucket sends funds to as a staking period ends. Contract that user claims their rewards from.
924     address public REWARD_BUCKET_ADDRESS; // Reward Bucket is the address that stores the stake rewards. Penalties are sent from DH Contract to the Reward Bucket. 
925     string public TICKER_SYMBOL;
926     constructor(string memory ticker) ReentrancyGuard() {
927         TICKER_SYMBOL=ticker; // symbol of the Perpetual Pool contract this is deployed for.
928         PERPETUAL_POOL_ADDRESS = TeamContract.getPoolAddresses(ticker);
929         PoolContract = PerpetualContract(PERPETUAL_POOL_ADDRESS); // used for getCurrentPeriod, etc.
930         PoolERC = IERC20(PERPETUAL_POOL_ADDRESS); // used for transfer, balanceOf, etc
931     }
932     // Supporting Contract Deployment
933     // @notice Run this immediately after deployment of the DH Contract.
934     function deployStakeRewardDistributionContract() public nonReentrant {
935         require(STAKE_REWARD_DISTRIBUTION_ADDRESS==address(0), "already deployed");
936         DHStakeRewardDistribution srd = new DHStakeRewardDistribution(address(this));
937         STAKE_REWARD_DISTRIBUTION_ADDRESS = address(srd);
938     }
939     // @notice Run this immediately after deployment of the DH Contract.
940     function deployRewardBucketContract() public nonReentrant  {
941         require(REWARD_BUCKET_ADDRESS==address(0), "already deployed");
942         RewardBucket rb = new RewardBucket(address(this));
943         REWARD_BUCKET_ADDRESS = address(rb);
944     }
945     
946    
947     /// Staking
948     // A StakeRecord is created for each user when they stake into a new period.
949     // If a stake record for a user has already been created for a particular period, the existing one will be updated.
950     struct StakeRecord {
951         address staker; // staker
952         uint256 balance; // the remaining balance of the stake.
953         uint stakeID; // how a user identifies their stakes. Each period stake increments stakeID.
954         uint256 stake_expiry_period; // what period this stake is scheduled to serve through. May be extended to the next staking period during the stake_expiry_period.
955         mapping(uint => uint256) stakedTokensPerPeriod; // A record of the number of Tokens that successfully served each staking period during this stake. This number crystallizes as each staking period ends and is used to claim rewards.
956         bool initiated;
957     }
958     mapping (uint => uint256) public globalStakedTokensPerPeriod; // A record of the number of Tokens that are successfully staked for each stake period. Value crystallizes in each period as period ends.
959     mapping (address =>mapping(uint => StakeRecord)) public stakes; // Mapping of all users stake records.
960     /*
961     @notice joinClub(amount) User facing function for staking Tokens. 
962     @dev 1) Checks if user balance exceeds input stake amount. 2) Saves stake data via newStakeRecord(). 3) Transfers the staked Tokens to the Diamond Hand Club Contract. 4) Update global and user stake tally.
963     @param amount number of Tokens staked, include enough zeros to support 8 decimal units. to stake 1 Token, enter amount = 100000000
964     */
965     function joinClub(uint256 amount) external nonReentrant {
966         require(amount>0, "You must join with more than zero pool tokens");
967         require(PoolERC.allowance(msg.sender, address(this))>=amount);
968         newStakeRecord(amount); // updates the stake record
969         PoolERC.transferFrom(msg.sender, address(this), amount); // sends pool token to Diamond Hand Club contract
970         GLOBAL_AMOUNT_STAKED = GLOBAL_AMOUNT_STAKED + amount;
971         USER_AMOUNT_STAKED[msg.sender]=USER_AMOUNT_STAKED[msg.sender] + amount;
972     }
973         /*
974         @dev Function that determines which is the next staking period, and creates or updates the users stake record for that period.
975         */
976         function newStakeRecord(uint256 amount) private {
977             uint256 next_staking_period = getNextStakingPeriod(); // the contract period number for each staking period is used as a unique identifier for a stake. 
978             StakeRecord storage stake = stakes[msg.sender][next_staking_period]; // retrieves the existing stake record for this upcoming staking period, or render a new one if this is the first time.
979             bool is_initial;
980             if (stake.initiated==false){ // first time setup. values that should not change if this user stakes again in this period.
981                 stake.stakeID = next_staking_period;
982                 stake.initiated = true;
983                 stake.staker = msg.sender;
984                 stake.stake_expiry_period = next_staking_period;
985                 is_initial = true;
986             }
987             stake.balance = amount + stake.balance;
988             stake.stakedTokensPerPeriod[next_staking_period] = amount + stake.stakedTokensPerPeriod[next_staking_period];
989             globalStakedTokensPerPeriod[next_staking_period] = amount + globalStakedTokensPerPeriod[next_staking_period];
990             emit Stake(msg.sender, amount, getCurrentPeriod(), stake.stakeID, is_initial);
991         }
992   
993     /*
994     @notice Calculates the 20% penalty for early end staking an amount.
995     */
996     function calculatePenalty(uint256 amount) public view returns(uint256) {
997         uint256 penalty = amount/5; // 20% penalty = 1/5 of the amount
998         return penalty;
999     } 
1000 /*
1001     @notice earlyEndStakeToken(stakeID, amount) User facing function for ending a part or all of a stake either before or during its expiry period. A scaled% penalty is applied to the amount returned to the user and the penalized amount goes to the Reward Bucket.
1002     @dev checks that they have this stake, updates the stake record via earlyEndStakeRecord() function, updates the global tallies, calculates the early end stake penalty, and returns back the amount requested minus penalty.
1003     @param stakeID the ID of the stake the user wants to early end stake
1004     @param amount number of Tokens early end staked, include enough zeros to support 8 decimal units. to end stake 1 Tokens, enter amount = 100000000
1005     */
1006     function earlyEndStakeToken(uint256 stakeID, uint256 amount) external nonReentrant {
1007         earlyEndStakeRecord(stakeID, amount); // update the stake record
1008         uint256 penalty = calculatePenalty(amount); 
1009         GLOBAL_AMOUNT_STAKED = GLOBAL_AMOUNT_STAKED - amount;
1010         USER_AMOUNT_STAKED[msg.sender]=USER_AMOUNT_STAKED[msg.sender] - amount;
1011         PoolERC.transfer(msg.sender,amount-penalty);
1012         PoolERC.transfer(REWARD_BUCKET_ADDRESS,penalty);
1013     }
1014          /*
1015         @dev Determines if stake is pending, or in progress and updates the record to reflect the amount of Tokens that remains actively staked from that particular stake.
1016         @param stakeID the ID of the stake the user wants to early end stake
1017         @param amount number of Tokens early end staked, include enough zeros to support 8 decimal units. to end stake 1 Tokens, enter amount = 100000000
1018         */
1019         function earlyEndStakeRecord(uint256 stakeID, uint256 amount) private {
1020             uint256 current_period = getCurrentPeriod();
1021             uint256 next_staking_period = getNextStakingPeriod();
1022             StakeRecord storage stake = stakes[msg.sender][stakeID];
1023             require(stake.initiated==true, "You must enter an existing stake period");
1024             require(stake.stake_expiry_period>=current_period, "The stake period must be active."); // must be before the stake has expired
1025             require(stake.balance>=amount);
1026             stake.balance = stake.balance - amount;
1027             // Decrement staked Tokens from next staking period
1028             if (stake.stakedTokensPerPeriod[next_staking_period]>0){
1029                 globalStakedTokensPerPeriod[next_staking_period]=globalStakedTokensPerPeriod[next_staking_period]-amount;
1030                 stake.stakedTokensPerPeriod[next_staking_period]=stake.stakedTokensPerPeriod[next_staking_period]-amount;
1031             }
1032             // Decrement staked Tokens from current staking period.
1033             if (stake.stakedTokensPerPeriod[current_period]>0) {
1034                 globalStakedTokensPerPeriod[current_period]=globalStakedTokensPerPeriod[current_period]-amount;
1035                 stake.stakedTokensPerPeriod[current_period]=stake.stakedTokensPerPeriod[current_period]-amount;
1036             }
1037             emit EarlyEndStake(msg.sender, amount, stake.stake_expiry_period, stakeID);
1038         }
1039     /*
1040     @notice End a stake which has already served its full staking period. This function updates your stake record and returns your staked Tokens back into your address.
1041     @param stakeID the ID of the stake the user wants to end stake
1042     @param amount number of Tokens end staked, include enough zeros to support 8 decimal units. to end stake 1 Tokens, enter amount = 100000000
1043             
1044     */
1045     function endCompletedStake(uint256 stakeID, uint256 amount) external nonReentrant {
1046         endExpiredStake(stakeID, amount);
1047         GLOBAL_AMOUNT_STAKED = GLOBAL_AMOUNT_STAKED - amount;
1048         USER_AMOUNT_STAKED[msg.sender]=USER_AMOUNT_STAKED[msg.sender] - amount;
1049         PoolERC.transfer(msg.sender, amount);
1050     }
1051         function endExpiredStake(uint256 stakeID, uint256 amount) private {
1052             uint256 current_period=getCurrentPeriod();
1053             StakeRecord storage stake = stakes[msg.sender][stakeID];
1054             require(stake.stake_expiry_period<current_period);
1055             require(stake.balance>=amount);
1056             stake.balance = stake.balance-amount;
1057             emit EndExpiredStake(msg.sender, amount, stake.stake_expiry_period, stakeID);
1058         }
1059 
1060     /*
1061     @notice This function extends a currently active stake into the next staking period. It can only be run during the expiry period of a stake. This extends the entire stake into the next period.
1062     @param stakeID the ID of the stake the user wants to extend into the next staking period.
1063         */
1064         function extendStake(uint256 stakeID) external nonReentrant {
1065             uint256 current_period=getCurrentPeriod();
1066             uint256 next_staking_period = getNextStakingPeriod();
1067             StakeRecord storage stake = stakes[msg.sender][stakeID];
1068             require(isStakingPeriod());
1069             require(stake.stake_expiry_period==current_period);
1070             stake.stake_expiry_period=next_staking_period;
1071             stake.stakedTokensPerPeriod[next_staking_period] = stake.stakedTokensPerPeriod[next_staking_period] + stake.balance;
1072             globalStakedTokensPerPeriod[next_staking_period] = globalStakedTokensPerPeriod[next_staking_period] + stake.balance;
1073             emit ExtendStake(msg.sender, stake.balance, next_staking_period, stakeID);
1074         }
1075     /*
1076     @notice This function ends and restakes a stake which has been completed (if current period is greater than stake expiry period). It ends the stake but does not return your Tokens, instead it rolls those Tokens into a brand new stake record starting in the next staking period.
1077     @param stakeID the ID of the stake the user wants to extend into the next staking period.
1078     */
1079     function restakeExpiredStake(uint256 stakeID) public nonReentrant {
1080         uint256 current_period=getCurrentPeriod();
1081         StakeRecord storage stake = stakes[msg.sender][stakeID];
1082         require(stake.stake_expiry_period<current_period);
1083         require(stake.balance > 0);
1084         newStakeRecord(stake.balance);
1085         uint256 amount = stake.balance;
1086         stake.balance = 0;
1087         emit RestakeExpiredStake(msg.sender, amount, stake.stake_expiry_period, stakeID);
1088     }
1089     function getAddressPeriodEndTotal(address staker_address, uint256 period, uint stakeID) public view returns (uint256) {
1090         StakeRecord storage stake = stakes[staker_address][stakeID];
1091         return stake.stakedTokensPerPeriod[period]; 
1092     }
1093     function getglobalStakedTokensPerPeriod(uint256 period) public view returns(uint256){
1094         return globalStakedTokensPerPeriod[period];
1095     }
1096    
1097     /// Utilities
1098     /*
1099     @notice The current period of the Diamond Hands Contract is the current period of the corresponding Perpetual Pool Contract.
1100     */
1101     function getCurrentPeriod() public view returns (uint current_period){
1102         return PoolContract.getCurrentPeriod(); 
1103     }
1104     
1105     function isStakingPeriod() public view returns (bool) {
1106         uint remainder = getCurrentPeriod()%2;
1107         if(remainder==0){
1108             return false;
1109         }
1110         else {
1111             return true;
1112         }
1113     }
1114 
1115     function getNextStakingPeriod() private view returns(uint256) {
1116         uint256 current_period=getCurrentPeriod();
1117         uint256 next_staking_period;
1118         if (isStakingPeriod()==true) {
1119             next_staking_period = current_period+2;
1120         }
1121         else {
1122             next_staking_period=current_period+1;
1123         }
1124         return next_staking_period;
1125     }
1126 }
1127 contract RewardBucket is ReentrancyGuard {
1128     /*
1129     Deployment instructions: 
1130     1. run activate()
1131     */
1132     address public PERPETUAL_POOL_ADDRESS;
1133     address public constant TEAM_CONTRACT_ADDRESS=0xB7c9E99Da8A857cE576A830A9c19312114d9dE02;
1134     PerpetualContract PoolContract;
1135     IERC20 PoolERC;
1136     TEAMContract TeamContract = TEAMContract(TEAM_CONTRACT_ADDRESS);
1137     address public STAKE_REWARD_DISTRIBUTION_ADDRESS;
1138     DiamondHandsClub DHContract;
1139     constructor(address dhc_address) ReentrancyGuard() {
1140         DHContract = DiamondHandsClub(dhc_address);
1141     } 
1142     /*
1143     @notice This function must be run right after deployment
1144     */
1145     function activate() public nonReentrant {
1146         require(PERPETUAL_POOL_ADDRESS==address(0)); 
1147         PERPETUAL_POOL_ADDRESS=DHContract.PERPETUAL_POOL_ADDRESS();
1148         PoolContract = PerpetualContract(PERPETUAL_POOL_ADDRESS); // used for getCurrentPeriod, etc.
1149         PoolERC = IERC20(PERPETUAL_POOL_ADDRESS); // used for transfer, balanceOf, etc
1150         STAKE_REWARD_DISTRIBUTION_ADDRESS=DHContract.STAKE_REWARD_DISTRIBUTION_ADDRESS();
1151         require(STAKE_REWARD_DISTRIBUTION_ADDRESS!=address(0));
1152         declareSupportedTokens();
1153     }
1154     /// Rewards Allocation   
1155     // Income received by the TEAM Contract in tokens from the below declared supported tokens list are split up and claimable
1156     mapping (string => address) supportedTokens;
1157     /*
1158     @dev Declares which tokens that will be supported by the reward distribution contract.
1159     */
1160     address constant MAXI_ADDRESS = 0x0d86EB9f43C57f6FF3BC9E23D8F9d82503f0e84b;
1161     address constant HEX_ADDRESS  = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39; // "2b, 5 9 1e? that is the question..."
1162     address constant HEDRON_ADDRESS = 0x3819f64f282bf135d62168C1e513280dAF905e06; 
1163     
1164     function declareSupportedTokens() private {
1165         supportedTokens["HEX"] = HEX_ADDRESS;
1166         supportedTokens["MAXI"]=MAXI_ADDRESS;
1167         supportedTokens["HDRN"]=HEDRON_ADDRESS;
1168         supportedTokens["BASE"]=TeamContract.getPoolAddresses("BASE");
1169         supportedTokens["TRIO"]=TeamContract.getPoolAddresses("TRIO");
1170         supportedTokens["LUCKY"]=TeamContract.getPoolAddresses("LUCKY");
1171         supportedTokens["DECI"]=TeamContract.getPoolAddresses("DECI");
1172         supportedTokens["TEAM"]=TEAM_CONTRACT_ADDRESS;
1173         supportedTokens["ICSA"]=0xfc4913214444aF5c715cc9F7b52655e788A569ed;
1174         
1175     }
1176     mapping (string => mapping (uint => bool)) public didRecordPeriodEndBalance; // didRecordPeriodEndBalance[TICKER][period]
1177     mapping (string =>mapping (uint => uint256)) public periodEndBalance; //periodEndBalance[TICKER][period]
1178     mapping (string => mapping (uint => uint256)) public periodRedemptionRates; //periodRedemptionRates[TICKER][period] Number of coins claimable per team staked 
1179     /*
1180     @notice This function checks to make sure that a staking period just ended, and then measures and saves the Tokens Contracts balance of the designated token.
1181     @param ticker is the ticker that is to be 
1182     */ 
1183     function prepareClaim(string memory ticker) external nonReentrant {
1184         require(DHContract.isStakingPeriod()==false);
1185         uint256 latest_staking_period = DHContract.getCurrentPeriod()-1;
1186         require(didRecordPeriodEndBalance[ticker][latest_staking_period]==false);
1187         periodEndBalance[ticker][latest_staking_period] = IERC20(supportedTokens[ticker]).balanceOf(address(this)); //measures how many of the designated token are in the Tokens contract address
1188         IERC20(supportedTokens[ticker]).transfer(STAKE_REWARD_DISTRIBUTION_ADDRESS, periodEndBalance[ticker][latest_staking_period]);
1189         didRecordPeriodEndBalance[ticker][latest_staking_period]=true;
1190         uint256 scaled_rate = periodEndBalance[ticker][latest_staking_period] *(10**8)/DHContract.getglobalStakedTokensPerPeriod(latest_staking_period);
1191         periodRedemptionRates[ticker][latest_staking_period] = scaled_rate;
1192     }
1193     
1194     function getPeriodRedemptionRates(string memory ticker, uint256 period) public view returns (uint256) {
1195         return periodRedemptionRates[ticker][period];
1196     }
1197     
1198     function getSupportedTokens(string memory ticker) public view returns(address) {
1199             return supportedTokens[ticker];
1200         }
1201 
1202     function getClaimableAmount(address user, uint256 period, string memory ticker, uint stakeID) public view returns (uint256, address) {
1203         uint256 total_amount_succesfully_staked = DHContract.getAddressPeriodEndTotal(user, period, stakeID);
1204         uint256 redeemable_amount = getPeriodRedemptionRates(ticker,period) * total_amount_succesfully_staked / (10**8);
1205         return (redeemable_amount, getSupportedTokens(ticker));
1206     }
1207     
1208 }
1209 contract DHStakeRewardDistribution is ReentrancyGuard {
1210     /*
1211     Deployment insttructions: 
1212     1. run activate()
1213     2. run prepareSupportedTokens()
1214     */
1215     address public REWARD_BUCKET_ADDRESS;
1216     RewardBucket RewardBucketContract;
1217     address public DHC_ADDRESS;
1218     DiamondHandsClub DHContract; 
1219     mapping (string => address) public supportedTokens;
1220     mapping (address => mapping(uint => mapping(uint => mapping (string => bool)))) public didUserStakeClaimFromPeriod; // log which periods and which tokens a user's stake has claimed rewards from
1221     constructor(address dhc_address) ReentrancyGuard(){
1222       DHC_ADDRESS=dhc_address;
1223       DHContract = DiamondHandsClub(DHC_ADDRESS); 
1224     }
1225     /*
1226     Upon deployment we must collect the Reward bucket address from the DH Contract
1227     */
1228     function activate() public nonReentrant {
1229         require(REWARD_BUCKET_ADDRESS==address(0));
1230         REWARD_BUCKET_ADDRESS = DHContract.REWARD_BUCKET_ADDRESS();
1231         require(REWARD_BUCKET_ADDRESS!=address(0));
1232         RewardBucketContract = RewardBucket(REWARD_BUCKET_ADDRESS);
1233         
1234     }
1235     /*
1236     @notice Claim Rewards in the designated ticker for a period served by a stake record designated by stake ID. You can only run this function if you have not already claimed and if you have redeemable rewards for that coin from that period.
1237     @param period is the period you want to claim rewards from
1238     @param ticker is the ticker symbol for the token you want to claim
1239     @param stakeID is the stakeID of the stake record that contains Tokens that was succesfully staked during the period you input.
1240     */
1241     function claimRewards(uint256 period, string memory ticker, uint stakeID) nonReentrant external {
1242         (uint256 redeemable_amount, address token_address) = RewardBucketContract.getClaimableAmount(msg.sender,period, ticker, stakeID);
1243         require(didUserStakeClaimFromPeriod[msg.sender][stakeID][period][ticker]==false, "You must not have already claimed from this stake on this period.");
1244         require(redeemable_amount>0, "No rewards from this period.");
1245         IERC20(token_address).transfer(msg.sender, redeemable_amount);
1246         didUserStakeClaimFromPeriod[msg.sender][stakeID][period][ticker]=true;
1247     }
1248 
1249     /*
1250     @notice Run this function to retrieve and save all of the supported token addresses from the Tokens contract into the Stake Reward Distribution contract. This should be run once after the supported tokens are declared in the team contract.
1251     */
1252     function prepareSupportedTokens() nonReentrant public {
1253         collectSupportedTokenAddress("HEX");
1254         collectSupportedTokenAddress("MAXI");
1255         collectSupportedTokenAddress("HDRN");
1256         collectSupportedTokenAddress("BASE");
1257         collectSupportedTokenAddress("TRIO");
1258         collectSupportedTokenAddress("LUCKY");
1259         collectSupportedTokenAddress("DECI");
1260         collectSupportedTokenAddress("TEAM");
1261         collectSupportedTokenAddress("ICSA");
1262     }
1263     function collectSupportedTokenAddress(string memory ticker) private {
1264         require(supportedTokens[ticker]==address(0));
1265         supportedTokens[ticker]=RewardBucketContract.getSupportedTokens(ticker);
1266     }
1267 }