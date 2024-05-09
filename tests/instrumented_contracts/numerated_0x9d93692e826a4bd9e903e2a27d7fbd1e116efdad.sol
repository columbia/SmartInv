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
297 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
306  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
307  *
308  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
309  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
310  * need to send a transaction, and thus is not required to hold Ether at all.
311  */
312 interface IERC20Permit {
313     /**
314      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
315      * given ``owner``'s signed approval.
316      *
317      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
318      * ordering also apply here.
319      *
320      * Emits an {Approval} event.
321      *
322      * Requirements:
323      *
324      * - `spender` cannot be the zero address.
325      * - `deadline` must be a timestamp in the future.
326      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
327      * over the EIP712-formatted function arguments.
328      * - the signature must use ``owner``'s current nonce (see {nonces}).
329      *
330      * For more information on the signature format, see the
331      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
332      * section].
333      */
334     function permit(
335         address owner,
336         address spender,
337         uint256 value,
338         uint256 deadline,
339         uint8 v,
340         bytes32 r,
341         bytes32 s
342     ) external;
343 
344     /**
345      * @dev Returns the current nonce for `owner`. This value must be
346      * included whenever a signature is generated for {permit}.
347      *
348      * Every successful call to {permit} increases ``owner``'s nonce by one. This
349      * prevents a signature from being used multiple times.
350      */
351     function nonces(address owner) external view returns (uint256);
352 
353     /**
354      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
355      */
356     // solhint-disable-next-line func-name-mixedcase
357     function DOMAIN_SEPARATOR() external view returns (bytes32);
358 }
359 
360 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
361 
362 
363 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
364 
365 pragma solidity ^0.8.0;
366 
367 /**
368  * @dev Interface of the ERC20 standard as defined in the EIP.
369  */
370 interface IERC20 {
371     /**
372      * @dev Emitted when `value` tokens are moved from one account (`from`) to
373      * another (`to`).
374      *
375      * Note that `value` may be zero.
376      */
377     event Transfer(address indexed from, address indexed to, uint256 value);
378 
379     /**
380      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
381      * a call to {approve}. `value` is the new allowance.
382      */
383     event Approval(address indexed owner, address indexed spender, uint256 value);
384 
385     /**
386      * @dev Returns the amount of tokens in existence.
387      */
388     function totalSupply() external view returns (uint256);
389 
390     /**
391      * @dev Returns the amount of tokens owned by `account`.
392      */
393     function balanceOf(address account) external view returns (uint256);
394 
395     /**
396      * @dev Moves `amount` tokens from the caller's account to `to`.
397      *
398      * Returns a boolean value indicating whether the operation succeeded.
399      *
400      * Emits a {Transfer} event.
401      */
402     function transfer(address to, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Returns the remaining number of tokens that `spender` will be
406      * allowed to spend on behalf of `owner` through {transferFrom}. This is
407      * zero by default.
408      *
409      * This value changes when {approve} or {transferFrom} are called.
410      */
411     function allowance(address owner, address spender) external view returns (uint256);
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
415      *
416      * Returns a boolean value indicating whether the operation succeeded.
417      *
418      * IMPORTANT: Beware that changing an allowance with this method brings the risk
419      * that someone may use both the old and the new allowance by unfortunate
420      * transaction ordering. One possible solution to mitigate this race
421      * condition is to first reduce the spender's allowance to 0 and set the
422      * desired value afterwards:
423      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
424      *
425      * Emits an {Approval} event.
426      */
427     function approve(address spender, uint256 amount) external returns (bool);
428 
429     /**
430      * @dev Moves `amount` tokens from `from` to `to` using the
431      * allowance mechanism. `amount` is then deducted from the caller's
432      * allowance.
433      *
434      * Returns a boolean value indicating whether the operation succeeded.
435      *
436      * Emits a {Transfer} event.
437      */
438     function transferFrom(
439         address from,
440         address to,
441         uint256 amount
442     ) external returns (bool);
443 }
444 
445 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
446 
447 
448 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
449 
450 pragma solidity ^0.8.0;
451 
452 
453 /**
454  * @dev Interface for the optional metadata functions from the ERC20 standard.
455  *
456  * _Available since v4.1._
457  */
458 interface IERC20Metadata is IERC20 {
459     /**
460      * @dev Returns the name of the token.
461      */
462     function name() external view returns (string memory);
463 
464     /**
465      * @dev Returns the symbol of the token.
466      */
467     function symbol() external view returns (string memory);
468 
469     /**
470      * @dev Returns the decimals places of the token.
471      */
472     function decimals() external view returns (uint8);
473 }
474 
475 // File: @openzeppelin/contracts/utils/Strings.sol
476 
477 
478 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev String operations.
484  */
485 library Strings {
486     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
487     uint8 private constant _ADDRESS_LENGTH = 20;
488 
489     /**
490      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
491      */
492     function toString(uint256 value) internal pure returns (string memory) {
493         // Inspired by OraclizeAPI's implementation - MIT licence
494         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
495 
496         if (value == 0) {
497             return "0";
498         }
499         uint256 temp = value;
500         uint256 digits;
501         while (temp != 0) {
502             digits++;
503             temp /= 10;
504         }
505         bytes memory buffer = new bytes(digits);
506         while (value != 0) {
507             digits -= 1;
508             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
509             value /= 10;
510         }
511         return string(buffer);
512     }
513 
514     /**
515      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
516      */
517     function toHexString(uint256 value) internal pure returns (string memory) {
518         if (value == 0) {
519             return "0x00";
520         }
521         uint256 temp = value;
522         uint256 length = 0;
523         while (temp != 0) {
524             length++;
525             temp >>= 8;
526         }
527         return toHexString(value, length);
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
532      */
533     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
534         bytes memory buffer = new bytes(2 * length + 2);
535         buffer[0] = "0";
536         buffer[1] = "x";
537         for (uint256 i = 2 * length + 1; i > 1; --i) {
538             buffer[i] = _HEX_SYMBOLS[value & 0xf];
539             value >>= 4;
540         }
541         require(value == 0, "Strings: hex length insufficient");
542         return string(buffer);
543     }
544 
545     /**
546      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
547      */
548     function toHexString(address addr) internal pure returns (string memory) {
549         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
550     }
551 }
552 
553 // File: @openzeppelin/contracts/utils/Context.sol
554 
555 
556 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Provides information about the current execution context, including the
562  * sender of the transaction and its data. While these are generally available
563  * via msg.sender and msg.data, they should not be accessed in such a direct
564  * manner, since when dealing with meta-transactions the account sending and
565  * paying for execution may not be the actual sender (as far as an application
566  * is concerned).
567  *
568  * This contract is only required for intermediate, library-like contracts.
569  */
570 abstract contract Context {
571     function _msgSender() internal view virtual returns (address) {
572         return msg.sender;
573     }
574 
575     function _msgData() internal view virtual returns (bytes calldata) {
576         return msg.data;
577     }
578 }
579 
580 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 
590 /**
591  * @dev Implementation of the {IERC20} interface.
592  *
593  * This implementation is agnostic to the way tokens are created. This means
594  * that a supply mechanism has to be added in a derived contract using {_mint}.
595  * For a generic mechanism see {ERC20PresetMinterPauser}.
596  *
597  * TIP: For a detailed writeup see our guide
598  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
599  * to implement supply mechanisms].
600  *
601  * We have followed general OpenZeppelin Contracts guidelines: functions revert
602  * instead returning `false` on failure. This behavior is nonetheless
603  * conventional and does not conflict with the expectations of ERC20
604  * applications.
605  *
606  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
607  * This allows applications to reconstruct the allowance for all accounts just
608  * by listening to said events. Other implementations of the EIP may not emit
609  * these events, as it isn't required by the specification.
610  *
611  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
612  * functions have been added to mitigate the well-known issues around setting
613  * allowances. See {IERC20-approve}.
614  */
615 contract ERC20 is Context, IERC20, IERC20Metadata {
616     mapping(address => uint256) private _balances;
617 
618     mapping(address => mapping(address => uint256)) private _allowances;
619 
620     uint256 private _totalSupply;
621 
622     string private _name;
623     string private _symbol;
624 
625     /**
626      * @dev Sets the values for {name} and {symbol}.
627      *
628      * The default value of {decimals} is 18. To select a different value for
629      * {decimals} you should overload it.
630      *
631      * All two of these values are immutable: they can only be set once during
632      * construction.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev Returns the name of the token.
641      */
642     function name() public view virtual override returns (string memory) {
643         return _name;
644     }
645 
646     /**
647      * @dev Returns the symbol of the token, usually a shorter version of the
648      * name.
649      */
650     function symbol() public view virtual override returns (string memory) {
651         return _symbol;
652     }
653 
654     /**
655      * @dev Returns the number of decimals used to get its user representation.
656      * For example, if `decimals` equals `2`, a balance of `505` tokens should
657      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
658      *
659      * Tokens usually opt for a value of 18, imitating the relationship between
660      * Ether and Wei. This is the value {ERC20} uses, unless this function is
661      * overridden;
662      *
663      * NOTE: This information is only used for _display_ purposes: it in
664      * no way affects any of the arithmetic of the contract, including
665      * {IERC20-balanceOf} and {IERC20-transfer}.
666      */
667     function decimals() public view virtual override returns (uint8) {
668         return 18;
669     }
670 
671     /**
672      * @dev See {IERC20-totalSupply}.
673      */
674     function totalSupply() public view virtual override returns (uint256) {
675         return _totalSupply;
676     }
677 
678     /**
679      * @dev See {IERC20-balanceOf}.
680      */
681     function balanceOf(address account) public view virtual override returns (uint256) {
682         return _balances[account];
683     }
684 
685     /**
686      * @dev See {IERC20-transfer}.
687      *
688      * Requirements:
689      *
690      * - `to` cannot be the zero address.
691      * - the caller must have a balance of at least `amount`.
692      */
693     function transfer(address to, uint256 amount) public virtual override returns (bool) {
694         address owner = _msgSender();
695         _transfer(owner, to, amount);
696         return true;
697     }
698 
699     /**
700      * @dev See {IERC20-allowance}.
701      */
702     function allowance(address owner, address spender) public view virtual override returns (uint256) {
703         return _allowances[owner][spender];
704     }
705 
706     /**
707      * @dev See {IERC20-approve}.
708      *
709      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
710      * `transferFrom`. This is semantically equivalent to an infinite approval.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      */
716     function approve(address spender, uint256 amount) public virtual override returns (bool) {
717         address owner = _msgSender();
718         _approve(owner, spender, amount);
719         return true;
720     }
721 
722     /**
723      * @dev See {IERC20-transferFrom}.
724      *
725      * Emits an {Approval} event indicating the updated allowance. This is not
726      * required by the EIP. See the note at the beginning of {ERC20}.
727      *
728      * NOTE: Does not update the allowance if the current allowance
729      * is the maximum `uint256`.
730      *
731      * Requirements:
732      *
733      * - `from` and `to` cannot be the zero address.
734      * - `from` must have a balance of at least `amount`.
735      * - the caller must have allowance for ``from``'s tokens of at least
736      * `amount`.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 amount
742     ) public virtual override returns (bool) {
743         address spender = _msgSender();
744         _spendAllowance(from, spender, amount);
745         _transfer(from, to, amount);
746         return true;
747     }
748 
749     /**
750      * @dev Atomically increases the allowance granted to `spender` by the caller.
751      *
752      * This is an alternative to {approve} that can be used as a mitigation for
753      * problems described in {IERC20-approve}.
754      *
755      * Emits an {Approval} event indicating the updated allowance.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      */
761     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
762         address owner = _msgSender();
763         _approve(owner, spender, allowance(owner, spender) + addedValue);
764         return true;
765     }
766 
767     /**
768      * @dev Atomically decreases the allowance granted to `spender` by the caller.
769      *
770      * This is an alternative to {approve} that can be used as a mitigation for
771      * problems described in {IERC20-approve}.
772      *
773      * Emits an {Approval} event indicating the updated allowance.
774      *
775      * Requirements:
776      *
777      * - `spender` cannot be the zero address.
778      * - `spender` must have allowance for the caller of at least
779      * `subtractedValue`.
780      */
781     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
782         address owner = _msgSender();
783         uint256 currentAllowance = allowance(owner, spender);
784         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
785         unchecked {
786             _approve(owner, spender, currentAllowance - subtractedValue);
787         }
788 
789         return true;
790     }
791 
792     /**
793      * @dev Moves `amount` of tokens from `from` to `to`.
794      *
795      * This internal function is equivalent to {transfer}, and can be used to
796      * e.g. implement automatic token fees, slashing mechanisms, etc.
797      *
798      * Emits a {Transfer} event.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `from` must have a balance of at least `amount`.
805      */
806     function _transfer(
807         address from,
808         address to,
809         uint256 amount
810     ) internal virtual {
811         require(from != address(0), "ERC20: transfer from the zero address");
812         require(to != address(0), "ERC20: transfer to the zero address");
813 
814         _beforeTokenTransfer(from, to, amount);
815 
816         uint256 fromBalance = _balances[from];
817         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
818         unchecked {
819             _balances[from] = fromBalance - amount;
820         }
821         _balances[to] += amount;
822 
823         emit Transfer(from, to, amount);
824 
825         _afterTokenTransfer(from, to, amount);
826     }
827 
828     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
829      * the total supply.
830      *
831      * Emits a {Transfer} event with `from` set to the zero address.
832      *
833      * Requirements:
834      *
835      * - `account` cannot be the zero address.
836      */
837     function _mint(address account, uint256 amount) internal virtual {
838         require(account != address(0), "ERC20: mint to the zero address");
839 
840         _beforeTokenTransfer(address(0), account, amount);
841 
842         _totalSupply += amount;
843         _balances[account] += amount;
844         emit Transfer(address(0), account, amount);
845 
846         _afterTokenTransfer(address(0), account, amount);
847     }
848 
849     /**
850      * @dev Destroys `amount` tokens from `account`, reducing the
851      * total supply.
852      *
853      * Emits a {Transfer} event with `to` set to the zero address.
854      *
855      * Requirements:
856      *
857      * - `account` cannot be the zero address.
858      * - `account` must have at least `amount` tokens.
859      */
860     function _burn(address account, uint256 amount) internal virtual {
861         require(account != address(0), "ERC20: burn from the zero address");
862 
863         _beforeTokenTransfer(account, address(0), amount);
864 
865         uint256 accountBalance = _balances[account];
866         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
867         unchecked {
868             _balances[account] = accountBalance - amount;
869         }
870         _totalSupply -= amount;
871 
872         emit Transfer(account, address(0), amount);
873 
874         _afterTokenTransfer(account, address(0), amount);
875     }
876 
877     /**
878      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
879      *
880      * This internal function is equivalent to `approve`, and can be used to
881      * e.g. set automatic allowances for certain subsystems, etc.
882      *
883      * Emits an {Approval} event.
884      *
885      * Requirements:
886      *
887      * - `owner` cannot be the zero address.
888      * - `spender` cannot be the zero address.
889      */
890     function _approve(
891         address owner,
892         address spender,
893         uint256 amount
894     ) internal virtual {
895         require(owner != address(0), "ERC20: approve from the zero address");
896         require(spender != address(0), "ERC20: approve to the zero address");
897 
898         _allowances[owner][spender] = amount;
899         emit Approval(owner, spender, amount);
900     }
901 
902     /**
903      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
904      *
905      * Does not update the allowance amount in case of infinite allowance.
906      * Revert if not enough allowance is available.
907      *
908      * Might emit an {Approval} event.
909      */
910     function _spendAllowance(
911         address owner,
912         address spender,
913         uint256 amount
914     ) internal virtual {
915         uint256 currentAllowance = allowance(owner, spender);
916         if (currentAllowance != type(uint256).max) {
917             require(currentAllowance >= amount, "ERC20: insufficient allowance");
918             unchecked {
919                 _approve(owner, spender, currentAllowance - amount);
920             }
921         }
922     }
923 
924     /**
925      * @dev Hook that is called before any transfer of tokens. This includes
926      * minting and burning.
927      *
928      * Calling conditions:
929      *
930      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
931      * will be transferred to `to`.
932      * - when `from` is zero, `amount` tokens will be minted for `to`.
933      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
934      * - `from` and `to` are never both zero.
935      *
936      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
937      */
938     function _beforeTokenTransfer(
939         address from,
940         address to,
941         uint256 amount
942     ) internal virtual {}
943 
944     /**
945      * @dev Hook that is called after any transfer of tokens. This includes
946      * minting and burning.
947      *
948      * Calling conditions:
949      *
950      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
951      * has been transferred to `to`.
952      * - when `from` is zero, `amount` tokens have been minted for `to`.
953      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
954      * - `from` and `to` are never both zero.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _afterTokenTransfer(
959         address from,
960         address to,
961         uint256 amount
962     ) internal virtual {}
963 }
964 
965 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
966 
967 
968 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
969 
970 pragma solidity ^0.8.0;
971 
972 
973 
974 /**
975  * @dev Extension of {ERC20} that allows token holders to destroy both their own
976  * tokens and those that they have an allowance for, in a way that can be
977  * recognized off-chain (via event analysis).
978  */
979 abstract contract ERC20Burnable is Context, ERC20 {
980     /**
981      * @dev Destroys `amount` tokens from the caller.
982      *
983      * See {ERC20-_burn}.
984      */
985     function burn(uint256 amount) public virtual {
986         _burn(_msgSender(), amount);
987     }
988 
989     /**
990      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
991      * allowance.
992      *
993      * See {ERC20-_burn} and {ERC20-allowance}.
994      *
995      * Requirements:
996      *
997      * - the caller must have allowance for ``accounts``'s tokens of at least
998      * `amount`.
999      */
1000     function burnFrom(address account, uint256 amount) public virtual {
1001         _spendAllowance(account, _msgSender(), amount);
1002         _burn(account, amount);
1003     }
1004 }
1005 
1006 // File: @openzeppelin/contracts/utils/Address.sol
1007 
1008 
1009 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1010 
1011 pragma solidity ^0.8.1;
1012 
1013 /**
1014  * @dev Collection of functions related to the address type
1015  */
1016 library Address {
1017     /**
1018      * @dev Returns true if `account` is a contract.
1019      *
1020      * [IMPORTANT]
1021      * ====
1022      * It is unsafe to assume that an address for which this function returns
1023      * false is an externally-owned account (EOA) and not a contract.
1024      *
1025      * Among others, `isContract` will return false for the following
1026      * types of addresses:
1027      *
1028      *  - an externally-owned account
1029      *  - a contract in construction
1030      *  - an address where a contract will be created
1031      *  - an address where a contract lived, but was destroyed
1032      * ====
1033      *
1034      * [IMPORTANT]
1035      * ====
1036      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1037      *
1038      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1039      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1040      * constructor.
1041      * ====
1042      */
1043     function isContract(address account) internal view returns (bool) {
1044         // This method relies on extcodesize/address.code.length, which returns 0
1045         // for contracts in construction, since the code is only stored at the end
1046         // of the constructor execution.
1047 
1048         return account.code.length > 0;
1049     }
1050 
1051     /**
1052      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1053      * `recipient`, forwarding all available gas and reverting on errors.
1054      *
1055      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1056      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1057      * imposed by `transfer`, making them unable to receive funds via
1058      * `transfer`. {sendValue} removes this limitation.
1059      *
1060      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1061      *
1062      * IMPORTANT: because control is transferred to `recipient`, care must be
1063      * taken to not create reentrancy vulnerabilities. Consider using
1064      * {ReentrancyGuard} or the
1065      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1066      */
1067     function sendValue(address payable recipient, uint256 amount) internal {
1068         require(address(this).balance >= amount, "Address: insufficient balance");
1069 
1070         (bool success, ) = recipient.call{value: amount}("");
1071         require(success, "Address: unable to send value, recipient may have reverted");
1072     }
1073 
1074     /**
1075      * @dev Performs a Solidity function call using a low level `call`. A
1076      * plain `call` is an unsafe replacement for a function call: use this
1077      * function instead.
1078      *
1079      * If `target` reverts with a revert reason, it is bubbled up by this
1080      * function (like regular Solidity function calls).
1081      *
1082      * Returns the raw returned data. To convert to the expected return value,
1083      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1084      *
1085      * Requirements:
1086      *
1087      * - `target` must be a contract.
1088      * - calling `target` with `data` must not revert.
1089      *
1090      * _Available since v3.1._
1091      */
1092     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1093         return functionCall(target, data, "Address: low-level call failed");
1094     }
1095 
1096     /**
1097      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1098      * `errorMessage` as a fallback revert reason when `target` reverts.
1099      *
1100      * _Available since v3.1._
1101      */
1102     function functionCall(
1103         address target,
1104         bytes memory data,
1105         string memory errorMessage
1106     ) internal returns (bytes memory) {
1107         return functionCallWithValue(target, data, 0, errorMessage);
1108     }
1109 
1110     /**
1111      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1112      * but also transferring `value` wei to `target`.
1113      *
1114      * Requirements:
1115      *
1116      * - the calling contract must have an ETH balance of at least `value`.
1117      * - the called Solidity function must be `payable`.
1118      *
1119      * _Available since v3.1._
1120      */
1121     function functionCallWithValue(
1122         address target,
1123         bytes memory data,
1124         uint256 value
1125     ) internal returns (bytes memory) {
1126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1127     }
1128 
1129     /**
1130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1131      * with `errorMessage` as a fallback revert reason when `target` reverts.
1132      *
1133      * _Available since v3.1._
1134      */
1135     function functionCallWithValue(
1136         address target,
1137         bytes memory data,
1138         uint256 value,
1139         string memory errorMessage
1140     ) internal returns (bytes memory) {
1141         require(address(this).balance >= value, "Address: insufficient balance for call");
1142         require(isContract(target), "Address: call to non-contract");
1143 
1144         (bool success, bytes memory returndata) = target.call{value: value}(data);
1145         return verifyCallResult(success, returndata, errorMessage);
1146     }
1147 
1148     /**
1149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1150      * but performing a static call.
1151      *
1152      * _Available since v3.3._
1153      */
1154     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1155         return functionStaticCall(target, data, "Address: low-level static call failed");
1156     }
1157 
1158     /**
1159      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1160      * but performing a static call.
1161      *
1162      * _Available since v3.3._
1163      */
1164     function functionStaticCall(
1165         address target,
1166         bytes memory data,
1167         string memory errorMessage
1168     ) internal view returns (bytes memory) {
1169         require(isContract(target), "Address: static call to non-contract");
1170 
1171         (bool success, bytes memory returndata) = target.staticcall(data);
1172         return verifyCallResult(success, returndata, errorMessage);
1173     }
1174 
1175     /**
1176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1177      * but performing a delegate call.
1178      *
1179      * _Available since v3.4._
1180      */
1181     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1182         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1183     }
1184 
1185     /**
1186      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1187      * but performing a delegate call.
1188      *
1189      * _Available since v3.4._
1190      */
1191     function functionDelegateCall(
1192         address target,
1193         bytes memory data,
1194         string memory errorMessage
1195     ) internal returns (bytes memory) {
1196         require(isContract(target), "Address: delegate call to non-contract");
1197 
1198         (bool success, bytes memory returndata) = target.delegatecall(data);
1199         return verifyCallResult(success, returndata, errorMessage);
1200     }
1201 
1202     /**
1203      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1204      * revert reason using the provided one.
1205      *
1206      * _Available since v4.3._
1207      */
1208     function verifyCallResult(
1209         bool success,
1210         bytes memory returndata,
1211         string memory errorMessage
1212     ) internal pure returns (bytes memory) {
1213         if (success) {
1214             return returndata;
1215         } else {
1216             // Look for revert reason and bubble it up if present
1217             if (returndata.length > 0) {
1218                 // The easiest way to bubble the revert reason is using memory via assembly
1219                 /// @solidity memory-safe-assembly
1220                 assembly {
1221                     let returndata_size := mload(returndata)
1222                     revert(add(32, returndata), returndata_size)
1223                 }
1224             } else {
1225                 revert(errorMessage);
1226             }
1227         }
1228     }
1229 }
1230 
1231 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1232 
1233 
1234 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 
1239 
1240 
1241 /**
1242  * @title SafeERC20
1243  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1244  * contract returns false). Tokens that return no value (and instead revert or
1245  * throw on failure) are also supported, non-reverting calls are assumed to be
1246  * successful.
1247  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1248  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1249  */
1250 library SafeERC20 {
1251     using Address for address;
1252 
1253     function safeTransfer(
1254         IERC20 token,
1255         address to,
1256         uint256 value
1257     ) internal {
1258         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1259     }
1260 
1261     function safeTransferFrom(
1262         IERC20 token,
1263         address from,
1264         address to,
1265         uint256 value
1266     ) internal {
1267         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1268     }
1269 
1270     /**
1271      * @dev Deprecated. This function has issues similar to the ones found in
1272      * {IERC20-approve}, and its usage is discouraged.
1273      *
1274      * Whenever possible, use {safeIncreaseAllowance} and
1275      * {safeDecreaseAllowance} instead.
1276      */
1277     function safeApprove(
1278         IERC20 token,
1279         address spender,
1280         uint256 value
1281     ) internal {
1282         // safeApprove should only be called when setting an initial allowance,
1283         // or when resetting it to zero. To increase and decrease it, use
1284         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1285         require(
1286             (value == 0) || (token.allowance(address(this), spender) == 0),
1287             "SafeERC20: approve from non-zero to non-zero allowance"
1288         );
1289         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1290     }
1291 
1292     function safeIncreaseAllowance(
1293         IERC20 token,
1294         address spender,
1295         uint256 value
1296     ) internal {
1297         uint256 newAllowance = token.allowance(address(this), spender) + value;
1298         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1299     }
1300 
1301     function safeDecreaseAllowance(
1302         IERC20 token,
1303         address spender,
1304         uint256 value
1305     ) internal {
1306         unchecked {
1307             uint256 oldAllowance = token.allowance(address(this), spender);
1308             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1309             uint256 newAllowance = oldAllowance - value;
1310             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1311         }
1312     }
1313 
1314     function safePermit(
1315         IERC20Permit token,
1316         address owner,
1317         address spender,
1318         uint256 value,
1319         uint256 deadline,
1320         uint8 v,
1321         bytes32 r,
1322         bytes32 s
1323     ) internal {
1324         uint256 nonceBefore = token.nonces(owner);
1325         token.permit(owner, spender, value, deadline, v, r, s);
1326         uint256 nonceAfter = token.nonces(owner);
1327         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1328     }
1329 
1330     /**
1331      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1332      * on the return value: the return value is optional (but if data is returned, it must not be false).
1333      * @param token The token targeted by the call.
1334      * @param data The call data (encoded using abi.encode or one of its variants).
1335      */
1336     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1337         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1338         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1339         // the target address contains contract code and also asserts for success in the low-level call.
1340 
1341         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1342         if (returndata.length > 0) {
1343             // Return data is optional
1344             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1345         }
1346     }
1347 }
1348 
1349 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1350 
1351 
1352 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1353 
1354 pragma solidity ^0.8.0;
1355 
1356 /**
1357  * @title ERC721 token receiver interface
1358  * @dev Interface for any contract that wants to support safeTransfers
1359  * from ERC721 asset contracts.
1360  */
1361 interface IERC721Receiver {
1362     /**
1363      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1364      * by `operator` from `from`, this function is called.
1365      *
1366      * It must return its Solidity selector to confirm the token transfer.
1367      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1368      *
1369      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1370      */
1371     function onERC721Received(
1372         address operator,
1373         address from,
1374         uint256 tokenId,
1375         bytes calldata data
1376     ) external returns (bytes4);
1377 }
1378 
1379 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1380 
1381 
1382 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 /**
1387  * @dev Interface of the ERC165 standard, as defined in the
1388  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1389  *
1390  * Implementers can declare support of contract interfaces, which can then be
1391  * queried by others ({ERC165Checker}).
1392  *
1393  * For an implementation, see {ERC165}.
1394  */
1395 interface IERC165 {
1396     /**
1397      * @dev Returns true if this contract implements the interface defined by
1398      * `interfaceId`. See the corresponding
1399      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1400      * to learn more about how these ids are created.
1401      *
1402      * This function call must use less than 30 000 gas.
1403      */
1404     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1405 }
1406 
1407 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1408 
1409 
1410 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1411 
1412 pragma solidity ^0.8.0;
1413 
1414 
1415 /**
1416  * @dev Implementation of the {IERC165} interface.
1417  *
1418  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1419  * for the additional interface id that will be supported. For example:
1420  *
1421  * ```solidity
1422  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1423  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1424  * }
1425  * ```
1426  *
1427  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1428  */
1429 abstract contract ERC165 is IERC165 {
1430     /**
1431      * @dev See {IERC165-supportsInterface}.
1432      */
1433     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1434         return interfaceId == type(IERC165).interfaceId;
1435     }
1436 }
1437 
1438 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1439 
1440 
1441 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1442 
1443 pragma solidity ^0.8.0;
1444 
1445 
1446 /**
1447  * @dev Required interface of an ERC721 compliant contract.
1448  */
1449 interface IERC721 is IERC165 {
1450     /**
1451      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1452      */
1453     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1454 
1455     /**
1456      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1457      */
1458     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1459 
1460     /**
1461      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1462      */
1463     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1464 
1465     /**
1466      * @dev Returns the number of tokens in ``owner``'s account.
1467      */
1468     function balanceOf(address owner) external view returns (uint256 balance);
1469 
1470     /**
1471      * @dev Returns the owner of the `tokenId` token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      */
1477     function ownerOf(uint256 tokenId) external view returns (address owner);
1478 
1479     /**
1480      * @dev Safely transfers `tokenId` token from `from` to `to`.
1481      *
1482      * Requirements:
1483      *
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      * - `tokenId` token must exist and be owned by `from`.
1487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function safeTransferFrom(
1493         address from,
1494         address to,
1495         uint256 tokenId,
1496         bytes calldata data
1497     ) external;
1498 
1499     /**
1500      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1501      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1502      *
1503      * Requirements:
1504      *
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must exist and be owned by `from`.
1508      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function safeTransferFrom(
1514         address from,
1515         address to,
1516         uint256 tokenId
1517     ) external;
1518 
1519     /**
1520      * @dev Transfers `tokenId` token from `from` to `to`.
1521      *
1522      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1523      *
1524      * Requirements:
1525      *
1526      * - `from` cannot be the zero address.
1527      * - `to` cannot be the zero address.
1528      * - `tokenId` token must be owned by `from`.
1529      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1530      *
1531      * Emits a {Transfer} event.
1532      */
1533     function transferFrom(
1534         address from,
1535         address to,
1536         uint256 tokenId
1537     ) external;
1538 
1539     /**
1540      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1541      * The approval is cleared when the token is transferred.
1542      *
1543      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1544      *
1545      * Requirements:
1546      *
1547      * - The caller must own the token or be an approved operator.
1548      * - `tokenId` must exist.
1549      *
1550      * Emits an {Approval} event.
1551      */
1552     function approve(address to, uint256 tokenId) external;
1553 
1554     /**
1555      * @dev Approve or remove `operator` as an operator for the caller.
1556      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1557      *
1558      * Requirements:
1559      *
1560      * - The `operator` cannot be the caller.
1561      *
1562      * Emits an {ApprovalForAll} event.
1563      */
1564     function setApprovalForAll(address operator, bool _approved) external;
1565 
1566     /**
1567      * @dev Returns the account approved for `tokenId` token.
1568      *
1569      * Requirements:
1570      *
1571      * - `tokenId` must exist.
1572      */
1573     function getApproved(uint256 tokenId) external view returns (address operator);
1574 
1575     /**
1576      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1577      *
1578      * See {setApprovalForAll}
1579      */
1580     function isApprovedForAll(address owner, address operator) external view returns (bool);
1581 }
1582 
1583 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1584 
1585 
1586 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 
1591 /**
1592  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1593  * @dev See https://eips.ethereum.org/EIPS/eip-721
1594  */
1595 interface IERC721Metadata is IERC721 {
1596     /**
1597      * @dev Returns the token collection name.
1598      */
1599     function name() external view returns (string memory);
1600 
1601     /**
1602      * @dev Returns the token collection symbol.
1603      */
1604     function symbol() external view returns (string memory);
1605 
1606     /**
1607      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1608      */
1609     function tokenURI(uint256 tokenId) external view returns (string memory);
1610 }
1611 
1612 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1613 
1614 
1615 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1616 
1617 pragma solidity ^0.8.0;
1618 
1619 
1620 
1621 
1622 
1623 
1624 
1625 
1626 /**
1627  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1628  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1629  * {ERC721Enumerable}.
1630  */
1631 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1632     using Address for address;
1633     using Strings for uint256;
1634 
1635     // Token name
1636     string private _name;
1637 
1638     // Token symbol
1639     string private _symbol;
1640 
1641     // Mapping from token ID to owner address
1642     mapping(uint256 => address) private _owners;
1643 
1644     // Mapping owner address to token count
1645     mapping(address => uint256) private _balances;
1646 
1647     // Mapping from token ID to approved address
1648     mapping(uint256 => address) private _tokenApprovals;
1649 
1650     // Mapping from owner to operator approvals
1651     mapping(address => mapping(address => bool)) private _operatorApprovals;
1652 
1653     /**
1654      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1655      */
1656     constructor(string memory name_, string memory symbol_) {
1657         _name = name_;
1658         _symbol = symbol_;
1659     }
1660 
1661     /**
1662      * @dev See {IERC165-supportsInterface}.
1663      */
1664     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1665         return
1666             interfaceId == type(IERC721).interfaceId ||
1667             interfaceId == type(IERC721Metadata).interfaceId ||
1668             super.supportsInterface(interfaceId);
1669     }
1670 
1671     /**
1672      * @dev See {IERC721-balanceOf}.
1673      */
1674     function balanceOf(address owner) public view virtual override returns (uint256) {
1675         require(owner != address(0), "ERC721: address zero is not a valid owner");
1676         return _balances[owner];
1677     }
1678 
1679     /**
1680      * @dev See {IERC721-ownerOf}.
1681      */
1682     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1683         address owner = _owners[tokenId];
1684         require(owner != address(0), "ERC721: invalid token ID");
1685         return owner;
1686     }
1687 
1688     /**
1689      * @dev See {IERC721Metadata-name}.
1690      */
1691     function name() public view virtual override returns (string memory) {
1692         return _name;
1693     }
1694 
1695     /**
1696      * @dev See {IERC721Metadata-symbol}.
1697      */
1698     function symbol() public view virtual override returns (string memory) {
1699         return _symbol;
1700     }
1701 
1702     /**
1703      * @dev See {IERC721Metadata-tokenURI}.
1704      */
1705     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1706         _requireMinted(tokenId);
1707 
1708         string memory baseURI = _baseURI();
1709         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1710     }
1711 
1712     /**
1713      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1714      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1715      * by default, can be overridden in child contracts.
1716      */
1717     function _baseURI() internal view virtual returns (string memory) {
1718         return "";
1719     }
1720 
1721     /**
1722      * @dev See {IERC721-approve}.
1723      */
1724     function approve(address to, uint256 tokenId) public virtual override {
1725         address owner = ERC721.ownerOf(tokenId);
1726         require(to != owner, "ERC721: approval to current owner");
1727 
1728         require(
1729             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1730             "ERC721: approve caller is not token owner nor approved for all"
1731         );
1732 
1733         _approve(to, tokenId);
1734     }
1735 
1736     /**
1737      * @dev See {IERC721-getApproved}.
1738      */
1739     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1740         _requireMinted(tokenId);
1741 
1742         return _tokenApprovals[tokenId];
1743     }
1744 
1745     /**
1746      * @dev See {IERC721-setApprovalForAll}.
1747      */
1748     function setApprovalForAll(address operator, bool approved) public virtual override {
1749         _setApprovalForAll(_msgSender(), operator, approved);
1750     }
1751 
1752     /**
1753      * @dev See {IERC721-isApprovedForAll}.
1754      */
1755     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1756         return _operatorApprovals[owner][operator];
1757     }
1758 
1759     /**
1760      * @dev See {IERC721-transferFrom}.
1761      */
1762     function transferFrom(
1763         address from,
1764         address to,
1765         uint256 tokenId
1766     ) public virtual override {
1767         //solhint-disable-next-line max-line-length
1768         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1769 
1770         _transfer(from, to, tokenId);
1771     }
1772 
1773     /**
1774      * @dev See {IERC721-safeTransferFrom}.
1775      */
1776     function safeTransferFrom(
1777         address from,
1778         address to,
1779         uint256 tokenId
1780     ) public virtual override {
1781         safeTransferFrom(from, to, tokenId, "");
1782     }
1783 
1784     /**
1785      * @dev See {IERC721-safeTransferFrom}.
1786      */
1787     function safeTransferFrom(
1788         address from,
1789         address to,
1790         uint256 tokenId,
1791         bytes memory data
1792     ) public virtual override {
1793         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1794         _safeTransfer(from, to, tokenId, data);
1795     }
1796 
1797     /**
1798      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1799      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1800      *
1801      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1802      *
1803      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1804      * implement alternative mechanisms to perform token transfer, such as signature-based.
1805      *
1806      * Requirements:
1807      *
1808      * - `from` cannot be the zero address.
1809      * - `to` cannot be the zero address.
1810      * - `tokenId` token must exist and be owned by `from`.
1811      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1812      *
1813      * Emits a {Transfer} event.
1814      */
1815     function _safeTransfer(
1816         address from,
1817         address to,
1818         uint256 tokenId,
1819         bytes memory data
1820     ) internal virtual {
1821         _transfer(from, to, tokenId);
1822         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1823     }
1824 
1825     /**
1826      * @dev Returns whether `tokenId` exists.
1827      *
1828      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1829      *
1830      * Tokens start existing when they are minted (`_mint`),
1831      * and stop existing when they are burned (`_burn`).
1832      */
1833     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1834         return _owners[tokenId] != address(0);
1835     }
1836 
1837     /**
1838      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1839      *
1840      * Requirements:
1841      *
1842      * - `tokenId` must exist.
1843      */
1844     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1845         address owner = ERC721.ownerOf(tokenId);
1846         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1847     }
1848 
1849     /**
1850      * @dev Safely mints `tokenId` and transfers it to `to`.
1851      *
1852      * Requirements:
1853      *
1854      * - `tokenId` must not exist.
1855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1856      *
1857      * Emits a {Transfer} event.
1858      */
1859     function _safeMint(address to, uint256 tokenId) internal virtual {
1860         _safeMint(to, tokenId, "");
1861     }
1862 
1863     /**
1864      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1865      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1866      */
1867     function _safeMint(
1868         address to,
1869         uint256 tokenId,
1870         bytes memory data
1871     ) internal virtual {
1872         _mint(to, tokenId);
1873         require(
1874             _checkOnERC721Received(address(0), to, tokenId, data),
1875             "ERC721: transfer to non ERC721Receiver implementer"
1876         );
1877     }
1878 
1879     /**
1880      * @dev Mints `tokenId` and transfers it to `to`.
1881      *
1882      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1883      *
1884      * Requirements:
1885      *
1886      * - `tokenId` must not exist.
1887      * - `to` cannot be the zero address.
1888      *
1889      * Emits a {Transfer} event.
1890      */
1891     function _mint(address to, uint256 tokenId) internal virtual {
1892         require(to != address(0), "ERC721: mint to the zero address");
1893         require(!_exists(tokenId), "ERC721: token already minted");
1894 
1895         _beforeTokenTransfer(address(0), to, tokenId);
1896 
1897         _balances[to] += 1;
1898         _owners[tokenId] = to;
1899 
1900         emit Transfer(address(0), to, tokenId);
1901 
1902         _afterTokenTransfer(address(0), to, tokenId);
1903     }
1904 
1905     /**
1906      * @dev Destroys `tokenId`.
1907      * The approval is cleared when the token is burned.
1908      *
1909      * Requirements:
1910      *
1911      * - `tokenId` must exist.
1912      *
1913      * Emits a {Transfer} event.
1914      */
1915     function _burn(uint256 tokenId) internal virtual {
1916         address owner = ERC721.ownerOf(tokenId);
1917 
1918         _beforeTokenTransfer(owner, address(0), tokenId);
1919 
1920         // Clear approvals
1921         _approve(address(0), tokenId);
1922 
1923         _balances[owner] -= 1;
1924         delete _owners[tokenId];
1925 
1926         emit Transfer(owner, address(0), tokenId);
1927 
1928         _afterTokenTransfer(owner, address(0), tokenId);
1929     }
1930 
1931     /**
1932      * @dev Transfers `tokenId` from `from` to `to`.
1933      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1934      *
1935      * Requirements:
1936      *
1937      * - `to` cannot be the zero address.
1938      * - `tokenId` token must be owned by `from`.
1939      *
1940      * Emits a {Transfer} event.
1941      */
1942     function _transfer(
1943         address from,
1944         address to,
1945         uint256 tokenId
1946     ) internal virtual {
1947         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1948         require(to != address(0), "ERC721: transfer to the zero address");
1949 
1950         _beforeTokenTransfer(from, to, tokenId);
1951 
1952         // Clear approvals from the previous owner
1953         _approve(address(0), tokenId);
1954 
1955         _balances[from] -= 1;
1956         _balances[to] += 1;
1957         _owners[tokenId] = to;
1958 
1959         emit Transfer(from, to, tokenId);
1960 
1961         _afterTokenTransfer(from, to, tokenId);
1962     }
1963 
1964     /**
1965      * @dev Approve `to` to operate on `tokenId`
1966      *
1967      * Emits an {Approval} event.
1968      */
1969     function _approve(address to, uint256 tokenId) internal virtual {
1970         _tokenApprovals[tokenId] = to;
1971         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1972     }
1973 
1974     /**
1975      * @dev Approve `operator` to operate on all of `owner` tokens
1976      *
1977      * Emits an {ApprovalForAll} event.
1978      */
1979     function _setApprovalForAll(
1980         address owner,
1981         address operator,
1982         bool approved
1983     ) internal virtual {
1984         require(owner != operator, "ERC721: approve to caller");
1985         _operatorApprovals[owner][operator] = approved;
1986         emit ApprovalForAll(owner, operator, approved);
1987     }
1988 
1989     /**
1990      * @dev Reverts if the `tokenId` has not been minted yet.
1991      */
1992     function _requireMinted(uint256 tokenId) internal view virtual {
1993         require(_exists(tokenId), "ERC721: invalid token ID");
1994     }
1995 
1996     /**
1997      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1998      * The call is not executed if the target address is not a contract.
1999      *
2000      * @param from address representing the previous owner of the given token ID
2001      * @param to target address that will receive the tokens
2002      * @param tokenId uint256 ID of the token to be transferred
2003      * @param data bytes optional data to send along with the call
2004      * @return bool whether the call correctly returned the expected magic value
2005      */
2006     function _checkOnERC721Received(
2007         address from,
2008         address to,
2009         uint256 tokenId,
2010         bytes memory data
2011     ) private returns (bool) {
2012         if (to.isContract()) {
2013             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2014                 return retval == IERC721Receiver.onERC721Received.selector;
2015             } catch (bytes memory reason) {
2016                 if (reason.length == 0) {
2017                     revert("ERC721: transfer to non ERC721Receiver implementer");
2018                 } else {
2019                     /// @solidity memory-safe-assembly
2020                     assembly {
2021                         revert(add(32, reason), mload(reason))
2022                     }
2023                 }
2024             }
2025         } else {
2026             return true;
2027         }
2028     }
2029 
2030     /**
2031      * @dev Hook that is called before any token transfer. This includes minting
2032      * and burning.
2033      *
2034      * Calling conditions:
2035      *
2036      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2037      * transferred to `to`.
2038      * - When `from` is zero, `tokenId` will be minted for `to`.
2039      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2040      * - `from` and `to` are never both zero.
2041      *
2042      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2043      */
2044     function _beforeTokenTransfer(
2045         address from,
2046         address to,
2047         uint256 tokenId
2048     ) internal virtual {}
2049 
2050     /**
2051      * @dev Hook that is called after any transfer of tokens. This includes
2052      * minting and burning.
2053      *
2054      * Calling conditions:
2055      *
2056      * - when `from` and `to` are both non-zero.
2057      * - `from` and `to` are never both zero.
2058      *
2059      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2060      */
2061     function _afterTokenTransfer(
2062         address from,
2063         address to,
2064         uint256 tokenId
2065     ) internal virtual {}
2066 }
2067 
2068 // File: contracts/PolyMaximus.sol
2069 
2070 
2071 pragma solidity ^0.8.4;
2072 
2073 
2074 
2075 
2076 
2077 
2078 
2079 
2080 
2081 /// Contract Interfaces and Abstract contracts
2082     // this interface comes directly from the Icosa contract. Many of these are not used in Poly Maximus
2083     interface HedronContract {
2084         struct LiquidationStore{
2085             uint256 liquidationStart;
2086             address hsiAddress;
2087             uint96  bidAmount;
2088             address liquidator;
2089             uint88  endOffset;
2090             bool    isActive;
2091         }
2092         struct HEXStakeMinimal {
2093         uint40 stakeId;
2094         uint72 stakeShares;
2095         uint16 lockedDay;
2096         uint16 stakedDays;
2097         }
2098         event Approval(
2099             address indexed owner,
2100             address indexed spender,
2101             uint256 value
2102         );
2103         event Claim(uint256 data, address indexed claimant, uint40 indexed stakeId);
2104         event LoanEnd(
2105             uint256 data,
2106             address indexed borrower,
2107             uint40 indexed stakeId
2108         );
2109         event LoanLiquidateBid(
2110             uint256 data,
2111             address indexed bidder,
2112             uint40 indexed stakeId,
2113             uint40 indexed liquidationId
2114         );
2115         event LoanLiquidateExit(
2116             uint256 data,
2117             address indexed liquidator,
2118             uint40 indexed stakeId,
2119             uint40 indexed liquidationId
2120         );
2121         event LoanLiquidateStart(
2122             uint256 data,
2123             address indexed borrower,
2124             uint40 indexed stakeId,
2125             uint40 indexed liquidationId
2126         );
2127         event LoanPayment(
2128             uint256 data,
2129             address indexed borrower,
2130             uint40 indexed stakeId
2131         );
2132         event LoanStart(
2133             uint256 data,
2134             address indexed borrower,
2135             uint40 indexed stakeId
2136         );
2137         event Mint(uint256 data, address indexed minter, uint40 indexed stakeId);
2138         event Transfer(address indexed from, address indexed to, uint256 value);
2139 
2140         function allowance(address owner, address spender)
2141             external
2142             view
2143             returns (uint256);
2144 
2145         function approve(address spender, uint256 amount) external returns (bool);
2146 
2147         function balanceOf(address account) external view returns (uint256);
2148 
2149         function calcLoanPayment(
2150             address borrower,
2151             uint256 hsiIndex,
2152             address hsiAddress
2153         ) external view returns (uint256, uint256);
2154 
2155         function calcLoanPayoff(
2156             address borrower,
2157             uint256 hsiIndex,
2158             address hsiAddress
2159         ) external view returns (uint256, uint256);
2160 
2161         function claimInstanced(
2162             uint256 hsiIndex,
2163             address hsiAddress,
2164             address hsiStarterAddress
2165         ) external;
2166 
2167         function claimNative(uint256 stakeIndex, uint40 stakeId)
2168             external
2169             returns (uint256);
2170 
2171         function currentDay() external view returns (uint256);
2172 
2173         function dailyDataList(uint256)
2174             external
2175             view
2176             returns (
2177                 uint72 dayMintedTotal,
2178                 uint72 dayLoanedTotal,
2179                 uint72 dayBurntTotal,
2180                 uint32 dayInterestRate,
2181                 uint8 dayMintMultiplier
2182             );
2183 
2184         function decimals() external view returns (uint8);
2185 
2186         function decreaseAllowance(address spender, uint256 subtractedValue)
2187             external
2188             returns (bool);
2189 
2190         function hsim() external view returns (address);
2191 
2192         function increaseAllowance(address spender, uint256 addedValue)
2193             external
2194             returns (bool);
2195 
2196         function liquidationList(uint256)
2197             external
2198             view
2199             returns (LiquidationStore memory);
2200             /*
2201             returns (
2202                 uint256 liquidationStart,
2203                 address hsiAddress,
2204                 uint96 bidAmount,
2205                 address liquidator,
2206                 uint88 endOffset,
2207                 bool isActive
2208             );*/
2209 
2210         function loanInstanced(uint256 hsiIndex, address hsiAddress)
2211             external
2212             returns (uint256);
2213 
2214         function loanLiquidate(
2215             address owner,
2216             uint256 hsiIndex,
2217             address hsiAddress
2218         ) external returns (uint256);
2219 
2220         function loanLiquidateBid(uint256 liquidationId, uint256 liquidationBid)
2221             external
2222             returns (uint256);
2223 
2224         function loanLiquidateExit(uint256 hsiIndex, uint256 liquidationId)
2225             external
2226             returns (address);
2227 
2228         function loanPayment(uint256 hsiIndex, address hsiAddress)
2229             external
2230             returns (uint256);
2231 
2232         function loanPayoff(uint256 hsiIndex, address hsiAddress)
2233             external
2234             returns (uint256);
2235 
2236         function loanedSupply() external view returns (uint256);
2237 
2238         function mintInstanced(uint256 hsiIndex, address hsiAddress)
2239             external
2240             returns (uint256);
2241 
2242         function mintNative(uint256 stakeIndex, uint40 stakeId)
2243             external
2244             returns (uint256);
2245 
2246         function name() external view returns (string memory);
2247 
2248         function proofOfBenevolence(uint256 amount) external;
2249 
2250         function shareList(uint256)
2251             external
2252             view
2253             returns (
2254                 HEXStakeMinimal memory stake,
2255                 uint16 mintedDays,
2256                 uint8 launchBonus,
2257                 uint16 loanStart,
2258                 uint16 loanedDays,
2259                 uint32 interestRate,
2260                 uint8 paymentsMade,
2261                 bool isLoaned
2262             );
2263 
2264         function symbol() external view returns (string memory);
2265 
2266         function totalSupply() external view returns (uint256);
2267 
2268         function transfer(address recipient, uint256 amount)
2269             external
2270             returns (bool);
2271 
2272         function transferFrom(
2273             address sender,
2274             address recipient,
2275             uint256 amount
2276         ) external returns (bool);
2277     }
2278     // this comes from the icosa contract. Used for staking HDRN
2279     interface IcosaInterface {
2280         event Approval(
2281             address indexed owner,
2282             address indexed spender,
2283             uint256 value
2284         );
2285         event HDRNStakeAddCapital(uint256 data, address indexed staker);
2286         event HDRNStakeEnd(uint256 data, address indexed staker);
2287         event HDRNStakeStart(uint256 data, address indexed staker);
2288         event HDRNStakingStats(
2289             uint256 data,
2290             uint256 payout,
2291             uint256 indexed stakeDay
2292         );
2293         event HSIBuyBack(
2294             uint256 price,
2295             address indexed seller,
2296             uint40 indexed stakeId
2297         );
2298         event ICSAStakeAddCapital(uint256 data, address indexed staker);
2299         event ICSAStakeEnd(uint256 data0, uint256 data1, address indexed staker);
2300         event ICSAStakeStart(uint256 data, address indexed staker);
2301         event ICSAStakingStats(
2302             uint256 data,
2303             uint256 payoutIcsa,
2304             uint256 payoutHdrn,
2305             uint256 indexed stakeDay
2306         );
2307         event NFTStakeEnd(
2308             uint256 data,
2309             address indexed staker,
2310             uint96 indexed nftId
2311         );
2312         event NFTStakeStart(
2313             uint256 data,
2314             address indexed staker,
2315             uint96 indexed nftId,
2316             address indexed tokenAddress
2317         );
2318         event NFTStakingStats(
2319             uint256 data,
2320             uint256 payout,
2321             uint256 indexed stakeDay
2322         );
2323         event Transfer(address indexed from, address indexed to, uint256 value);
2324 
2325         function allowance(address owner, address spender)
2326             external
2327             view
2328             returns (uint256);
2329 
2330         function approve(address spender, uint256 amount) external returns (bool);
2331 
2332         function balanceOf(address account) external view returns (uint256);
2333 
2334         function currentDay() external view returns (uint256);
2335 
2336         function decimals() external view returns (uint8);
2337 
2338         function decreaseAllowance(address spender, uint256 subtractedValue)
2339             external
2340             returns (bool);
2341 
2342         function hdrnPoolIcsaCollected() external view returns (uint256);
2343 
2344         function hdrnPoolPayout(uint256) external view returns (uint256);
2345 
2346         function hdrnPoolPoints(uint256) external view returns (uint256);
2347 
2348         function hdrnPoolPointsRemoved() external view returns (uint256);
2349 
2350         function hdrnSeedLiquidity(uint256) external view returns (uint256);
2351 
2352         function hdrnStakeAddCapital(uint256 amount) external returns (uint256);
2353 
2354         function hdrnStakeEnd()
2355             external
2356             returns (
2357                 uint256,
2358                 uint256,
2359                 uint256
2360             );
2361 
2362         function hdrnStakeStart(uint256 amount) external returns (uint256);
2363 
2364         function hdrnStakes(address)
2365             external
2366             view
2367             returns (
2368                 uint64 stakeStart,
2369                 uint64 capitalAdded,
2370                 uint120 stakePoints,
2371                 bool isActive,
2372                 uint80 payoutPreCapitalAddIcsa,
2373                 uint80 payoutPreCapitalAddHdrn,
2374                 uint80 stakeAmount,
2375                 uint16 minStakeLength
2376             );
2377 
2378         function hexStakeSell(uint256 tokenId) external returns (uint256);
2379 
2380         function icsaPoolHdrnCollected() external view returns (uint256);
2381 
2382         function icsaPoolIcsaCollected() external view returns (uint256);
2383 
2384         function icsaPoolPayoutHdrn(uint256) external view returns (uint256);
2385 
2386         function icsaPoolPayoutIcsa(uint256) external view returns (uint256);
2387 
2388         function icsaPoolPoints(uint256) external view returns (uint256);
2389 
2390         function icsaPoolPointsRemoved() external view returns (uint256);
2391 
2392         function icsaSeedLiquidity(uint256) external view returns (uint256);
2393 
2394         function icsaStakeAddCapital(uint256 amount) external returns (uint256);
2395 
2396         function icsaStakeEnd()
2397             external
2398             returns (
2399                 uint256,
2400                 uint256,
2401                 uint256,
2402                 uint256,
2403                 uint256
2404             );
2405 
2406         function icsaStakeStart(uint256 amount) external returns (uint256);
2407 
2408         function icsaStakedSupply() external view returns (uint256);
2409 
2410         function icsaStakes(address)
2411             external
2412             view
2413             returns (
2414                 uint64 stakeStart,
2415                 uint64 capitalAdded,
2416                 uint120 stakePoints,
2417                 bool isActive,
2418                 uint80 payoutPreCapitalAddIcsa,
2419                 uint80 payoutPreCapitalAddHdrn,
2420                 uint80 stakeAmount,
2421                 uint16 minStakeLength
2422             );
2423 
2424         function increaseAllowance(address spender, uint256 addedValue)
2425             external
2426             returns (bool);
2427 
2428         function injectSeedLiquidity(uint256 amount, uint256 seedDays) external;
2429 
2430         function launchDay() external view returns (uint256);
2431 
2432         function name() external view returns (string memory);
2433 
2434         function nftPoolIcsaCollected() external view returns (uint256);
2435 
2436         function nftPoolPayout(uint256) external view returns (uint256);
2437 
2438         function nftPoolPoints(uint256) external view returns (uint256);
2439 
2440         function nftPoolPointsRemoved() external view returns (uint256);
2441 
2442         function nftStakeEnd(uint256 nftId) external returns (uint256);
2443 
2444         function nftStakeStart(uint256 amount, address tokenAddress)
2445             external
2446             payable
2447             returns (uint256);
2448 
2449         function nftStakes(uint256)
2450             external
2451             view
2452             returns (
2453                 uint64 stakeStart,
2454                 uint64 capitalAdded,
2455                 uint120 stakePoints,
2456                 bool isActive,
2457                 uint80 payoutPreCapitalAddIcsa,
2458                 uint80 payoutPreCapitalAddHdrn,
2459                 uint80 stakeAmount,
2460                 uint16 minStakeLength
2461             );
2462 
2463         function symbol() external view returns (string memory);
2464 
2465         function totalSupply() external view returns (uint256);
2466 
2467         function transfer(address to, uint256 amount) external returns (bool);
2468 
2469         function transferFrom(
2470             address from,
2471             address to,
2472             uint256 amount
2473         ) external returns (bool);
2474 
2475         function waatsa() external view returns (address);
2476     }
2477     // used in ThankYouTeam escrow contract
2478     contract TEAMContract {
2479         function getCurrentPeriod() public view returns (uint256) {}
2480     }
2481     contract HEXContract {
2482         function currentDay() external view returns (uint256){}
2483         function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external {}
2484         function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) external {}
2485     }
2486     contract HedronContracts {
2487         struct HEXStakeMinimal {
2488         uint40 stakeId;
2489         uint72 stakeShares;
2490         uint16 lockedDay;
2491         uint16 stakedDays;
2492         }
2493 
2494         struct ShareStore {
2495             HEXStakeMinimal stake;
2496             uint16          mintedDays;
2497             uint8           launchBonus;
2498             uint16          loanStart;
2499             uint16          loanedDays;
2500             uint32          interestRate;
2501             uint8           paymentsMade;
2502             bool            isLoaned;
2503         }
2504         struct LiquidationStore{
2505             uint256 liquidationStart;
2506             address hsiAddress;
2507             uint96  bidAmount;
2508             address liquidator;
2509             uint88  endOffset;
2510             bool    isActive;
2511         }
2512 
2513     function currentDay() external view returns (uint256) {}
2514     function liquidationList(uint256 index) public view returns (LiquidationStore memory) {}
2515     function shareList(uint256 hshi_id) public view returns (ShareStore memory) {}
2516     function mintInstanced(uint256 hsiIndex,address hsiAddress) external returns (uint256){}
2517     function mintNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256){}
2518     function loanLiquidate(address owner,uint256 hsiIndex,address hsiAddress) external returns (uint256) {}
2519     function loanLiquidateBid (uint256 liquidationId,uint256 liquidationBid) external returns (uint256) {}
2520     function loanLiquidateExit(uint256 hsiIndex, uint256 liquidationId) external returns (address) {}
2521     }
2522     contract HSIContract{
2523         struct HEXStakeMinimal {
2524         uint40 stakeId;
2525         uint72 stakeShares;
2526         uint16 lockedDay;
2527         uint16 stakedDays;
2528         }
2529 
2530         struct ShareStore {
2531             HEXStakeMinimal stake;
2532             uint16          mintedDays;
2533             uint8           launchBonus;
2534             uint16          loanStart;
2535             uint16          loanedDays;
2536             uint32          interestRate;
2537             uint8           paymentsMade;
2538             bool            isLoaned;
2539         }
2540         struct HEXStake {
2541         uint40 stakeId;
2542         uint72 stakedHearts;
2543         uint72 stakeShares;
2544         uint16 lockedDay;
2545         uint16 stakedDays;
2546         uint16 unlockedDay;
2547         bool   isAutoStake;
2548         }
2549     
2550         function share() public view returns (ShareStore memory) {}
2551         function goodAccounting() external {}
2552         function stakeDataFetch(
2553         ) 
2554             external
2555             view
2556             returns(HEXStake memory)
2557         {}
2558     }
2559     contract HSIManagerContract {
2560         mapping(address => address[]) public  hsiLists;
2561         function hexStakeDetokenize (uint256 tokenId) external returns (address) {}
2562         function hexStakeStart ( uint256 amount, uint256 length) external returns (address) {}
2563         function hexStakeEnd (uint256 hsiIndex,address hsiAddress) external returns (uint256) {}
2564         function ownerOf(uint256 tokenId) public view virtual returns (address) {}
2565         function hsiToken(uint256 hsiIndex) public view returns (address) {}
2566         function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual  returns (uint256) {}
2567         function safeTransferFrom(
2568             address from,
2569             address to,
2570             uint256 tokenId
2571         ) public virtual  {}
2572         function transferFrom(
2573             address from,
2574             address to,
2575             uint256 tokenId
2576         ) external {}
2577     }
2578 
2579 
2580 
2581 
2582 
2583 contract PolyMaximus is ERC20, ERC20Burnable, ReentrancyGuard {
2584 
2585     /*
2586     Poly Maximus is a HDRN pool for bidding in the HSIs available in the Hedron Liquidation Auctions.
2587 
2588     * Minting and Redemption Rules:
2589         - Mint 1 POLY per 1 HDRN deposited to the contract before or on the LAST_POSSIBLE_MINTING_DAY.
2590         - When minting, users vote for their recommended Bidding Budget as a percent of the entire Poly Maximus HDRN Treasury. Votes on LAST_POSSIBLE_MINTING_DAY default to 100%.
2591         - When there are less than 2 days left in minting, someone needs to run finalizeMinting() which activates bidding phase, stakes HDRN, and allocates the bidding budget. Then after minting someone needs to run flushLateMint
2592         - All HDRN deposited on the Late Minting Day is added to the bidding budget.
2593         - The redemption phase begins once all stakes are ended. Users run redeemPoly() which burns POLY and transfers them the corresponding HEX, HDRN, and ICSA per the REDEMPTION_RATE values.
2594     
2595     * HSI Auction Executor
2596         - The Executor is an address, or set of addresses which are able to run the bid() function completely at their discretion.
2597         - Poly Maximus Participants agree to not have any expectations of the performance of The Executor. 
2598         - If the executor does not make any bids over any 30 day period, the bidding is considered done and the remaining HDRN gets staked via Icosa.
2599     
2600     * HSI Management:
2601         - As HSIs enter the contract after succesful auctions, someone needs to run processHSI() which records information about the stake and schedules the ending of the stakes.
2602         - After each HSI ends, someone needs to run endHSIStake() to mint the HDRN and end the HEX stake. If it is the last scheduled HSI, it activates the redemption period.
2603         - if one of the HSIs ends with at least a year left until the LAST_ACTIVE_HSI ends, the HEX is restaked until right before the LAST_ACTIVE_HSI ends and the HDRN is added to the Icosa Hedron stake.
2604 
2605     * Thank You Maximus Team:
2606         - As an expression of gratitude for the outsized benefits of participating in Poly Maximus, 1% of the incoming HDRN and 1% of the outgoing HEX is gifted to TEAM
2607             - Before or on MINTING_PHASE_END
2608             -of the 1% of the incoming HDRN:
2609                 - 33% is distributed to TEAM stakers during year 1
2610                 - 33% is distributed to TEAM stakers during year 2
2611                 - 34% is sent to the Mystery Box Hot Address
2612             - The 1% of the outgoing HEX after all the stakes end is distributed to TEAM stakers during whichever year the last HSI ends.
2613     */
2614 
2615 
2616 
2617 
2618 
2619     /// Data Structures
2620 
2621         struct HEXStakeMinimal {
2622         uint40 stakeId;
2623         uint72 stakeShares;
2624         uint16 lockedDay;
2625         uint16 stakedDays;
2626         }
2627 
2628         struct ShareStore {
2629             HEXStakeMinimal stake;
2630             uint16          mintedDays;
2631             uint8           launchBonus;
2632             uint16          loanStart;
2633             uint16          loanedDays;
2634             uint32          interestRate;
2635             uint8           paymentsMade;
2636             bool            isLoaned;
2637         }
2638         struct LiquidationStore{
2639             uint256 liquidationStart;
2640             address hsiAddress;
2641             uint96  bidAmount;
2642             address liquidator;
2643             uint88  endOffset;
2644             bool    isActive;
2645         }
2646 
2647         struct LiquidationData {
2648             uint16          mintedDays;
2649             uint8           launchBonus;
2650             uint16          loanStart;
2651             uint16          loanedDays;
2652             uint32          interestRate;
2653             uint8           paymentsMade;
2654             bool            isLoaned;
2655             uint256 liquidationStart;
2656             address hsiAddress;
2657             uint96  bidAmount;
2658             address liquidator;
2659             uint88  endOffset;
2660             bool    isActive;
2661         }
2662         struct HEXStake {
2663                 uint40 stakeId;
2664                 uint72 stakedHearts;
2665                 uint72 stakeShares;
2666                 uint16 lockedDay;
2667                 uint16 stakedDays;
2668                 uint16 unlockedDay;
2669                 bool   isAutoStake;
2670             }
2671     
2672     /// Events
2673         event Mint (address indexed user,uint256 amount);
2674         event Redeem (address indexed user, uint256 amount, uint256 hex_redeemed, uint256 hedron_redeemed, uint256 icosa_redeemed);
2675         event Bid(uint256 liquidationId, uint256 liquidationBid);
2676         event ProcessHSI(address indexed hsi_address, uint256 hsi_id);
2677    
2678 
2679     /// Contract interfaces
2680         address constant HEX_ADDRESS = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
2681         HEXContract hex_contract = HEXContract(HEX_ADDRESS);
2682         address constant HEDRON_ADDRESS=0x3819f64f282bf135d62168C1e513280dAF905e06;
2683         HedronContract hedron_contract = HedronContract(HEDRON_ADDRESS); 
2684         address constant HSI_MANAGER_ADDRESS =0x8BD3d1472A656e312E94fB1BbdD599B8C51D18e3;
2685         HSIManagerContract HSI_manager_contract = HSIManagerContract(HSI_MANAGER_ADDRESS); 
2686         address public ICOSA_CONTRACT_ADDRESS = 0xfc4913214444aF5c715cc9F7b52655e788A569ed; 
2687         IcosaInterface icosa_contract = IcosaInterface(ICOSA_CONTRACT_ADDRESS);
2688         address constant TEAM_ADDRESS = 0xB7c9E99Da8A857cE576A830A9c19312114d9dE02;
2689     /// Minting Variables
2690 
2691         uint256 public MINTING_PHASE_START;
2692         uint256 public MINTING_PHASE_END;
2693         uint256 public LAST_POSSIBLE_MINTING_DAY;
2694         uint256 public late_thank_you_team; // late thank you team amount
2695         address mystery_box_hot =0x00C055Ee792B5bC9AeB06ced73bB71ce7E5773Ce;
2696         bool HAS_LATE_FLUSHED;
2697     /// Redemption Variables
2698         bool public IS_REDEMPTION_ACTIVE;
2699         uint256 public HEX_REDEMPTION_RATE; // Number of HEX units redeemable per POLY
2700         uint256 public HEDRON_REDEMPTION_RATE; // Number of HEDRON units redeemable per POLY
2701         uint256 public ICOSA_REDEMPTION_RATE; // Number of ICSA units redeemable per POLY
2702         uint256 div_scalar = 10**8;
2703     
2704     /// HSI Variables
2705         mapping (address => bool) public END_STAKERS; // Addresses of the users who end HSI stakes on Poly Community's behalf, may be used in future gas pooling contracts
2706         uint256 public LAST_STAKE_START_DAY;
2707         uint256 public LATEST_STAKE_END_DAY;
2708         mapping (address => HEXStake) public HEXStakes;
2709         address public LAST_ACTIVE_HSI;
2710         
2711         
2712     
2713     /// Bid Execution Variables
2714         mapping (address => bool) public IS_EXECUTOR; // mapping of addresses authorized to run executor functions
2715         bool public IS_BIDDING_ACTIVE;
2716         // BIDDING_BUDGET_TRACKER and STAKING_BUDGET_TRACKER are used to calculate the bidding_budget_percent, updated as each user mints and votes.
2717         uint256 public BIDDING_BUDGET_TRACKER; 
2718         uint256 public STAKING_BUDGET_TRACKER;
2719         uint256 TOTAL_BIDDING_BUDGET; // amount of HDRN able to be bid
2720         uint256 public HDRN_STAKING_BUDGET; // amount of HDRN allocated for staking
2721         uint256 public bidding_budget_percent; // percent of total HDRN able to be bid
2722         address public THANK_YOU_TEAM; // contract address for the ThankYouTeam Escrow contract
2723         uint256 public LAST_BID_PLACED_DAY; // Updated as each bid is placed, used to declare bidding deadline
2724         address public EXECUTOR_MAIN = 0x07D48f521e11B3824808397A1E57177821de2b61;
2725         address public EXECUTOR_AUX = 0xc9534Ca2B339bbfC3435e24B93bD1239A898cB28;
2726         address public POLY_WATER_ADDRESS;
2727         
2728 
2729         
2730 
2731     constructor() ERC20("Poly Maximus", "POLY") ReentrancyGuard() {
2732         uint256 start_day=hex_contract.currentDay();
2733         MINTING_PHASE_START = start_day;
2734         MINTING_PHASE_END = 1075;
2735         LAST_POSSIBLE_MINTING_DAY = MINTING_PHASE_END + 2;
2736         LAST_BID_PLACED_DAY=MINTING_PHASE_END; // set to first eligible day to prevent stake_leftover_hdrn() from being run before first bid is placed
2737         LAST_STAKE_START_DAY= MINTING_PHASE_END+10; // HSIs must have started before this deadline in order to be processed.
2738         IS_EXECUTOR[EXECUTOR_MAIN]=true;
2739         IS_EXECUTOR[EXECUTOR_AUX]=true; 
2740 
2741         PolyWater poly_water_contract = new PolyWater(address(this), EXECUTOR_MAIN); // deploys the gas fee donation pool contract
2742         POLY_WATER_ADDRESS = address(poly_water_contract);  
2743        
2744     }
2745     
2746     /// Utilities
2747         /**
2748         * @dev Sets decimals to 9 - to be equal to that of HDRN.
2749         */
2750         function decimals() public view virtual override returns (uint8) {return 9;}
2751         function mint(uint256 amount) private {_mint(msg.sender, amount);}
2752         /**
2753         * @dev Gets the current HEX Day.
2754         * @return hex_day current day per the HEX Contract.
2755         */
2756         function getCurrentDay() public view returns (uint256 hex_day) {return hex_contract.currentDay();} 
2757         
2758     /// Minting Phase Functions
2759         /**
2760         * @dev Checks that mint phase is ongoing and that the user inputted bid budget percent is within the allowed range. Then it updates the global bidding_budget_percent value, transfers the amount of HDRN to the Poly contract, then mints the user the same number of POLY.
2761         * @param amount amount of HDRN minted into POLY.
2762         * @param bid_budget_percent percent of total HDRN the user thinks should be bid on HSIs.
2763         */
2764         function mintPoly(uint256 amount, uint256 bid_budget_percent) nonReentrant external {
2765             uint256 today = getCurrentDay();
2766             require(today <= LAST_POSSIBLE_MINTING_DAY, "Minting Phase must still be ongoing to mint POLY.");
2767             require(bid_budget_percent <= 100, "Bid Budget must not be greater than 100 percent.");
2768             require(bid_budget_percent >= 50, "Bid Budget Percent must not be less than 50 percent.");
2769             IERC20(HEDRON_ADDRESS).transferFrom(msg.sender, address(this), amount); // sends HDRN to the Poly Contract
2770             if (today==LAST_POSSIBLE_MINTING_DAY || today == LAST_POSSIBLE_MINTING_DAY-1){
2771                 require(IS_BIDDING_ACTIVE==true, "Run finalizeMinting() to resume minting today.");  // prevent double-thanking team (even though team should get way more)
2772                 late_thank_you_team = late_thank_you_team + (amount / 200); 
2773                 bid_budget_percent = 100;
2774             }
2775             BIDDING_BUDGET_TRACKER = BIDDING_BUDGET_TRACKER + ((bid_budget_percent * amount)/100); // increments weighted running total bidding budget tracker
2776             STAKING_BUDGET_TRACKER = STAKING_BUDGET_TRACKER + (((100-bid_budget_percent) * amount)/100); // increments weighted running total staking budget tracker
2777             bidding_budget_percent = 100 * BIDDING_BUDGET_TRACKER / (BIDDING_BUDGET_TRACKER + STAKING_BUDGET_TRACKER); // calculates percent of total to be bid
2778             mint(amount); // Mints 1 POLY per 1 HDRN
2779             emit Mint(msg.sender, amount);
2780         }
2781 
2782         /*
2783         * @dev This function is run at the end of the minting phase to kick off the bidding phase. It checks if the minting phase is still ongoing, deploys the ThankYouTeam escrow contract, allocates the amount used to Thank TEAM, calculates the Bidding and Staking budgets, and stakes the HDRN staking budget.
2784         */
2785         function finalizeMinting() external nonReentrant {
2786             require(getCurrentDay() > MINTING_PHASE_END, "Minting Phase must be over.");
2787             require(IS_BIDDING_ACTIVE ==false);
2788             ThankYouTeam tyt = new ThankYouTeam();
2789             THANK_YOU_TEAM = address(tyt);
2790             uint256 total_hdrn = IERC20(HEDRON_ADDRESS).balanceOf(address(this));
2791             uint256 thank_you_team = 100 * total_hdrn / 10000; // Poly thanks TEAM for saving them 99% on gas fees and letting them have HDRN staking bonuses with 1% of the total HDRN pledged.
2792             IERC20(HEDRON_ADDRESS).transfer(THANK_YOU_TEAM, thank_you_team);
2793             TOTAL_BIDDING_BUDGET = (total_hdrn - thank_you_team) * bidding_budget_percent/100;
2794             HDRN_STAKING_BUDGET = (total_hdrn - thank_you_team) - TOTAL_BIDDING_BUDGET;
2795             IERC20(HEDRON_ADDRESS).approve(ICOSA_CONTRACT_ADDRESS, HDRN_STAKING_BUDGET);
2796             icosa_contract.hdrnStakeStart(HDRN_STAKING_BUDGET);
2797             IS_BIDDING_ACTIVE = true;
2798         }
2799         
2800         /* 
2801         @dev Anyone can run the function which sends the late poly minters' thanks to TEAM and Mystery Box. Half of it gets distributed to Year 1 TEAM stakers. Half of it gets distributed to the Mystery Box Hot address collected from the Mystery Bx Contract.
2802         
2803         */
2804         function flushLateMint() nonReentrant external {
2805             require(getCurrentDay()>LAST_POSSIBLE_MINTING_DAY, "Late Mint Phase must be over");
2806             require(HAS_LATE_FLUSHED==false);
2807             IERC20(HEDRON_ADDRESS).transfer(TEAM_ADDRESS, late_thank_you_team);
2808             IERC20(HEDRON_ADDRESS).transfer(mystery_box_hot, late_thank_you_team);
2809             HAS_LATE_FLUSHED = true;
2810         }
2811         
2812 
2813     /// Redemption Functions
2814         /**
2815         * @dev Checks that redemption phase is ongoing and that the amount requested is less than the user's POLY balance. Then it calculates the amount of HEX, HDRN, and ICOSA that is redeemable for the amount input by the user, burns that amount and transfers them their alloted HEX, HDRN, and ICOSA.
2816         * @param amount amount of POLY being redeemed.
2817         */
2818         function redeemPoly(uint256 amount) nonReentrant external {
2819             require(IS_REDEMPTION_ACTIVE==true, "Redemption can only happen at end.");
2820             uint256 current_balance = balanceOf(msg.sender);
2821             require(amount<=current_balance, "insufficient balance");
2822             uint256 redeemable_hex = amount * HEX_REDEMPTION_RATE / div_scalar;
2823             uint256 redeemable_hedron = amount * HEDRON_REDEMPTION_RATE / div_scalar;
2824             uint256 redeemable_icosa = amount * ICOSA_REDEMPTION_RATE / div_scalar;
2825             burn(amount);
2826             if (redeemable_hex > 0 ) {
2827                 IERC20(HEX_ADDRESS).transfer(msg.sender, redeemable_hex);
2828             }
2829             if (redeemable_hedron > 0 ) {
2830                 IERC20(HEDRON_ADDRESS).transfer(msg.sender, redeemable_hedron);
2831             }
2832             if (redeemable_icosa > 0 ) {
2833                 IERC20(ICOSA_CONTRACT_ADDRESS).transfer(msg.sender, redeemable_icosa);
2834             }
2835             emit Redeem(msg.sender, amount, redeemable_hex, redeemable_hedron, redeemable_icosa);
2836         }
2837         
2838 
2839         function calculate_redemption_rate(uint256 balance, uint256 supply) public view returns (uint256 redemption_rate) {
2840             uint256 scaled_redemption_rate = balance * div_scalar / supply;
2841             return scaled_redemption_rate;
2842         }
2843  
2844         function set_redemption_rate() private {
2845             HEX_REDEMPTION_RATE = calculate_redemption_rate(IERC20(HEX_ADDRESS).balanceOf(address(this)), totalSupply());
2846             HEDRON_REDEMPTION_RATE = calculate_redemption_rate(IERC20(HEDRON_ADDRESS).balanceOf(address(this)), totalSupply());
2847             ICOSA_REDEMPTION_RATE =  calculate_redemption_rate(IERC20(ICOSA_CONTRACT_ADDRESS).balanceOf(address(this)), totalSupply());
2848         }
2849     /// Liquidation Auction Management
2850         /*
2851         * @dev Bids on existing liquidations. It checks to make sure the bid is within the maximum bid allowance, ensures that bidding is still active, and that the caller of this function is in the whitelisted executor list. Then it places the bid via the Hedron contract.
2852         * @param liquidationId - unique identifier for the liquidation
2853         * @param liquidationBid - bid amount determined by executor.
2854         */
2855         function bid(uint256 liquidationId, uint256 liquidationBid) external nonReentrant {
2856             require(IS_BIDDING_ACTIVE);
2857             require(getCurrentDay() <= LAST_BID_PLACED_DAY + 30, "If 30 Days go by without a bid placed, bidding phase ends.");
2858             require(IS_EXECUTOR[msg.sender]);
2859             hedron_contract.loanLiquidateBid(liquidationId, liquidationBid);
2860             LAST_BID_PLACED_DAY = getCurrentDay();
2861             emit Bid(liquidationId, liquidationBid);
2862         }
2863         
2864         /*
2865         * @dev Allows the executor to start the liquidation process.
2866         * @param owner HSI contract owner address.
2867         * @param hsiIndex Index of the HSI contract address in the owner's HSI list.
2868         * @param hsiAddress Address of the HSI contract.
2869         */
2870         function startBid(address owner, uint256 hsiIndex, address hsiAddress) external nonReentrant {
2871             require(getCurrentDay() <= LAST_BID_PLACED_DAY + 30, "If 30 Days go by without a bid placed, bidding phase ends.");
2872             require(IS_EXECUTOR[msg.sender]);
2873             hedron_contract.loanLiquidate(owner, hsiIndex, hsiAddress);
2874             LAST_BID_PLACED_DAY = getCurrentDay();
2875         }
2876         /**
2877             * @dev Allows any address to exit a completed liquidation, granting control of the
2878                     HSI to the highest bidder. Included here for UI simplicity, but may be called directly to hedron contract.
2879             * @param hsiIndex Index of the HSI contract address in the zero address's HSI list.
2880             *                 (see hsiLists -> HEXStakeInstanceManager.sol)
2881             * @param liquidationId ID number of the liquidation to exit.
2882           
2883      */
2884         function collectWinnings(uint256 hsiIndex, uint256 liquidationId) external {
2885             hedron_contract.loanLiquidateExit(hsiIndex, liquidationId);
2886         }
2887 
2888         
2889         /*
2890         * @dev Gets the information about the liquidation, and the HSI.
2891         * @param liquidation_index Hedron liquidation auction identifier
2892         * return liquidation_data Liquidation information including: mintedDays, launchBonus, loanStart , loanedDays, interestRate, paymentsMade, isLoaned, liquidationStart, hsiAddress, bidAmount, liquidator, endOffset, isActive
2893         */
2894         function getLiquidation(uint256 liquidation_index) public view returns (LiquidationData memory liquidation_data) {
2895             
2896             uint256 liquidationStart=hedron_contract.liquidationList(liquidation_index).liquidationStart; 
2897             address hsiAddress=hedron_contract.liquidationList(liquidation_index).hsiAddress;
2898             uint96  bidAmount=hedron_contract.liquidationList(liquidation_index).bidAmount;
2899             address liquidator=hedron_contract.liquidationList(liquidation_index).liquidator;
2900             uint88  endOffset=hedron_contract.liquidationList(liquidation_index).endOffset;
2901             bool    isActive=hedron_contract.liquidationList(liquidation_index).isActive;
2902             uint16         mintedDays=  HSIContract(hsiAddress).share().mintedDays;
2903             uint8          launchBonus = HSIContract(hsiAddress).share().launchBonus;
2904             uint16         loanStart =  HSIContract(hsiAddress).share().loanStart;
2905             uint16         loanedDays =HSIContract(hsiAddress).share().loanedDays;
2906             uint32         interestRate= HSIContract(hsiAddress).share().interestRate;
2907             uint8          paymentsMade = HSIContract(hsiAddress).share().paymentsMade;
2908             bool           isLoaned = HSIContract(hsiAddress).share().isLoaned;
2909             LiquidationData memory liquidation = LiquidationData(
2910             mintedDays, launchBonus, loanStart , loanedDays, interestRate, paymentsMade, isLoaned,
2911             liquidationStart, hsiAddress, bidAmount, liquidator, endOffset, isActive
2912             );
2913             return liquidation;
2914         }
2915         
2916 
2917         
2918     /// HSI Management
2919         /*
2920         * @dev Run this function when a new HSI is won by the contract. It saves a new entry in the HEXStake mapping and determines if the HSI is the one that ends on the latest day.
2921         * @param hsi_id Unique ID for the HSI.
2922         */
2923         function processHSI(uint256 hsi_id) external nonReentrant {
2924             address hsi_address = HSI_manager_contract.hsiToken(hsi_id);
2925             address hsi_owner = HSI_manager_contract.ownerOf(hsi_id);
2926             require(hsi_owner==address(this), "Can only process HSIs owned by Poly Contract.");
2927             HSIContract hsi = HSIContract(hsi_address);
2928             require(hsi.stakeDataFetch().lockedDay<LAST_STAKE_START_DAY);
2929             HEXStake storage stake = HEXStakes[hsi_address];
2930             stake.stakeId = hsi.stakeDataFetch().stakeId;
2931             stake.stakedHearts =hsi.stakeDataFetch().stakedHearts;
2932             stake.stakeShares = hsi.stakeDataFetch().stakeShares;
2933             stake.lockedDay = hsi.stakeDataFetch().lockedDay;
2934             stake.stakedDays = hsi.stakeDataFetch().stakedDays;
2935             stake.unlockedDay = hsi.stakeDataFetch().stakedDays;
2936             stake.isAutoStake = hsi.stakeDataFetch().isAutoStake;
2937             uint256 end_day= stake.lockedDay + stake.stakedDays;
2938             if (end_day>LATEST_STAKE_END_DAY) {
2939                 LATEST_STAKE_END_DAY = end_day;
2940                 LAST_ACTIVE_HSI = hsi_address;
2941             }
2942             HSI_manager_contract.hexStakeDetokenize(hsi_id);
2943             emit ProcessHSI(hsi_address, hsi_id);
2944         }
2945         /*
2946         * @dev Ends the HSI stake, if it is eligible to end. If it is the last active HSI in the list, it activates the redemption period and sends a HEX tip to TEAM. if it is not the last one and there is more than a year until the last active HSI, it restakes the HEX and HDRN. Then it calculates the redemption rates.
2947         * @param hsiIndex HSI identifier
2948         * @param hsiAddress HSI unique contract address
2949         */
2950         function endHSIStake(uint256 hsiIndex, address hsiAddress) external nonReentrant {
2951             HEXStake storage stake = HEXStakes[hsiAddress];
2952             require(stake.lockedDay + stake.stakedDays < getCurrentDay(), "This stake has not ended yet");
2953             HSI_manager_contract.hexStakeEnd(hsiIndex, hsiAddress);
2954             if (hsiAddress == LAST_ACTIVE_HSI) {
2955                 icosa_contract.hdrnStakeEnd();
2956                 IS_REDEMPTION_ACTIVE = true;
2957                 uint256 thank_you_team = 100 * IERC20(HEX_ADDRESS).balanceOf(address(this)) / 10000;
2958                 IERC20(HEX_ADDRESS).transfer(TEAM_ADDRESS, thank_you_team);
2959             }
2960             set_redemption_rate();
2961             END_STAKERS[msg.sender]=true;
2962         }
2963         /*
2964         * @dev mints the HDRN from HSIs held by Poly Contract
2965         
2966         */
2967         function hedronMintInstanced(uint256 hsiIndex, address hsiAddress) external nonReentrant {
2968             hedron_contract.mintInstanced(hsiIndex, hsiAddress);
2969             set_redemption_rate();
2970 
2971         }
2972 
2973              /*
2974         * @dev Mints the HDRN from the stake, ends the stake, and calculates the redemption rate.
2975         * @param stakeIndex - index among list of users stakes
2976         * @param stakeIdParam - unique ID for hex stake
2977         */ 
2978         function endNativeStake(uint256 stakeIndex, uint40 stakeIdParam) external nonReentrant {
2979             require(getCurrentDay() >= LATEST_STAKE_END_DAY - 2);
2980             hex_contract.stakeEnd(stakeIndex, stakeIdParam);
2981             set_redemption_rate();
2982         }
2983         /*
2984         * @dev Mints the HDRN from the stake, ends the stake, and calculates the redemption rate.
2985         * @param stakeIndex - index among list of users stakes
2986         * @param stakeIdParam - unique ID for hex stake
2987         */ 
2988         function hedronMintNative(uint256 stakeIndex, uint40 stakeIdParam) external nonReentrant {
2989             hedron_contract.mintNative(stakeIndex, stakeIdParam);
2990             set_redemption_rate();
2991         }
2992         /*
2993         @dev Checks if the bidding phase is over is adequate time left and restakes leftover HEX and HDRN.
2994         */
2995         function stakeLeftover() external nonReentrant {
2996             require(getCurrentDay() > LAST_BID_PLACED_DAY + 30, "Must be 30 days after LAST_BID_PLACED");
2997             require(IS_REDEMPTION_ACTIVE == false, "Can not run during redemption phase.");
2998             uint256 days_til_redemption = LATEST_STAKE_END_DAY - getCurrentDay();
2999             require(days_til_redemption > 366, "Can not run in the last year leading up to end of last stake.");
3000             if (IERC20(HEX_ADDRESS).balanceOf(address(this))> 100000*10**8 ) {
3001                     hex_contract.stakeStart(IERC20(HEX_ADDRESS).balanceOf(address(this)), days_til_redemption - 3);
3002                     set_redemption_rate();
3003                 }
3004             if (IERC20(HEDRON_ADDRESS).balanceOf(address(this)) > 0) {
3005                 IERC20(HEDRON_ADDRESS).approve(ICOSA_CONTRACT_ADDRESS, IERC20(HEDRON_ADDRESS).balanceOf(address(this)));
3006                 icosa_contract.hdrnStakeAddCapital(IERC20(HEDRON_ADDRESS).balanceOf(address(this)));
3007                 set_redemption_rate();
3008             }
3009         }
3010 
3011    
3012         
3013         
3014 
3015         
3016     
3017         
3018         
3019 
3020 }
3021 
3022 contract ThankYouTeam {
3023     // THIS CONTRACT IS AN EXPRESSION OF GRATITUDE TO MAXIMUS TEAM FOR SAVING THE HSI BIDDERS FROM HOLDING THE BAG ON HSIs IMPACTED BY GAS FEES
3024     address TEAM_ADDRESS =0xB7c9E99Da8A857cE576A830A9c19312114d9dE02;
3025     address constant HEDRON_ADDRESS=0x3819f64f282bf135d62168C1e513280dAF905e06;
3026     address mystery_box_hot =0x00C055Ee792B5bC9AeB06ced73bB71ce7E5773Ce;
3027     mapping (uint => uint256) public schedule;
3028     uint256 percent_year_one = 33;
3029     uint256 percent_year_two = 33;
3030     bool IS_SCHEDULED;
3031     constructor() {
3032     }
3033     /*
3034     * @dev This schedules the distributions allocated to TEAM stakers during years one and two, and sends the Mystery Box hot address a reward.
3035     */
3036     function schedule_distribution() public {
3037         require(IS_SCHEDULED==false);
3038         schedule[1]=IERC20(HEDRON_ADDRESS).balanceOf(address(this)) * percent_year_one / 100;
3039         schedule[3]=IERC20(HEDRON_ADDRESS).balanceOf(address(this)) * percent_year_two / 100;
3040         uint256 mb_amt = IERC20(HEDRON_ADDRESS).balanceOf(address(this)) - (schedule[1]+schedule[3]);
3041         IERC20(HEDRON_ADDRESS).transfer(mystery_box_hot, mb_amt);
3042         IS_SCHEDULED=true;
3043     }
3044     /*
3045     * @dev This sends the funds to the TEAM contract during the qualified years, then prevents it from being sent again that year.
3046     */
3047     function distribute() public {
3048         require(IS_SCHEDULED, "The distributions have not been scheduled yet, run schedule_distribution() first.");
3049         uint256 current_period = TEAMContract(TEAM_ADDRESS).getCurrentPeriod();
3050         uint256 amt = schedule[current_period];
3051         require(amt>0, "There are no available funds to be distributed this year. Either it is not a qualified year, or it has already been run this year.");
3052         IERC20(HEDRON_ADDRESS).transfer(TEAM_ADDRESS, amt);
3053         schedule[current_period]=0;
3054     }
3055      
3056 }
3057 
3058 contract PolyWater is ERC20, ReentrancyGuard {
3059     
3060     address public executor; 
3061     address constant HEX_ADDRESS = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
3062     HEXContract hex_contract = HEXContract(HEX_ADDRESS);
3063 
3064     address public POLY_ADDRESS;
3065     uint ds = 10**8; // division scalar
3066     uint256 public launch_day;
3067     constructor(address poly_address, address executor_address) ERC20("Poly Water", "WATER") ReentrancyGuard() {
3068         executor = executor_address;
3069         POLY_ADDRESS=poly_address; 
3070         launch_day = hex_contract.currentDay();
3071     }
3072     function mint(uint256 amount) private {
3073         _mint(msg.sender, amount);
3074     }
3075     event Mint(address indexed minter, uint mint_rate, uint amount);
3076     event Flush(address indexed flusher, uint amount);
3077     receive() external payable nonReentrant {
3078         uint mint_rate = current_mint_rate(); //get current mint rate
3079         require(mint_rate>0, "Minting Phase is over."); // ensure the mint phase is ongoing.
3080         mint(mint_rate*msg.value); // mint WATER to sender
3081         emit Mint(msg.sender,mint_rate, msg.value);
3082     }
3083     /*
3084     @dev calculates the mint rate. Starting at 369, and decreasing by 1/3 every 36 days.
3085     */
3086     function current_mint_rate() public view returns (uint) {
3087         uint256 months = ((hex_contract.currentDay() - launch_day) * ds)/(36 * ds); 
3088         return 369 * ds / ( 3**months * ds );
3089     }
3090     function flush() public  {
3091         require(msg.sender==executor, "Only Executor can run this function.");
3092         uint256 amount = address(this).balance;
3093         (bool sent, bytes memory data) = payable(executor).call{value: amount}(""); // send ETH to the Executor 
3094         require(sent, "Failed to send Ether");
3095         emit Flush(msg.sender, amount);
3096     }
3097     function flush_erc20(address token_contract_address) public  {
3098         require(msg.sender==executor, "Only Executor can run this function.");
3099         IERC20 tc = IERC20(token_contract_address);
3100         tc.transfer(executor, tc.balanceOf(address(this)));
3101 
3102     }
3103     
3104    
3105 }