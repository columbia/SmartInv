1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/interfaces/IERC1271.sol@v4.1.0
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC1271 standard signature validation method for
10  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
11  *
12  * _Available since v4.1._
13  */
14 interface IERC1271 {
15   /**
16    * @dev Should return whether the signature provided is valid for the provided data
17    * @param hash      Hash of the data to be signed
18    * @param signature Signature byte array associated with _data
19    */
20   function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
21 }
22 
23 
24 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.1.0
25 
26 
27 pragma solidity ^0.8.0;
28 
29 // CAUTION
30 // This version of SafeMath should only be used with Solidity 0.8 or later,
31 // because it relies on the compiler's built in overflow checks.
32 
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations.
35  *
36  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
37  * now has built in overflow checking.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             uint256 c = a + b;
48             if (c < a) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b > a) return (false, 0);
61             return (true, a - b);
62         }
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73             // benefit is lost if 'b' is also tested.
74             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75             if (a == 0) return (true, 0);
76             uint256 c = a * b;
77             if (c / a != b) return (false, 0);
78             return (true, c);
79         }
80     }
81 
82     /**
83      * @dev Returns the division of two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a / b);
91         }
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             if (b == 0) return (false, 0);
102             return (true, a % b);
103         }
104     }
105 
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a + b;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a - b;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a * b;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers, reverting on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator.
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a / b;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * reverting when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a % b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {trySub}.
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         unchecked {
193             require(b <= a, errorMessage);
194             return a - b;
195         }
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         unchecked {
216             require(b > 0, errorMessage);
217             return a / b;
218         }
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * reverting with custom message when dividing by zero.
224      *
225      * CAUTION: This function is deprecated because it requires allocating memory for the error
226      * message unnecessarily. For custom revert reasons use {tryMod}.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         unchecked {
238             require(b > 0, errorMessage);
239             return a % b;
240         }
241     }
242 }
243 
244 
245 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.1.0
246 
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
252  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
253  *
254  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
255  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
256  * need to send a transaction, and thus is not required to hold Ether at all.
257  */
258 interface IERC20Permit {
259     /**
260      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
261      * given ``owner``'s signed approval.
262      *
263      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
264      * ordering also apply here.
265      *
266      * Emits an {Approval} event.
267      *
268      * Requirements:
269      *
270      * - `spender` cannot be the zero address.
271      * - `deadline` must be a timestamp in the future.
272      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
273      * over the EIP712-formatted function arguments.
274      * - the signature must use ``owner``'s current nonce (see {nonces}).
275      *
276      * For more information on the signature format, see the
277      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
278      * section].
279      */
280     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
281 
282     /**
283      * @dev Returns the current nonce for `owner`. This value must be
284      * included whenever a signature is generated for {permit}.
285      *
286      * Every successful call to {permit} increases ``owner``'s nonce by one. This
287      * prevents a signature from being used multiple times.
288      */
289     function nonces(address owner) external view returns (uint256);
290 
291     /**
292      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
293      */
294     // solhint-disable-next-line func-name-mixedcase
295     function DOMAIN_SEPARATOR() external view returns (bytes32);
296 }
297 
298 
299 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.1.0
300 
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Interface of the ERC20 standard as defined in the EIP.
306  */
307 interface IERC20 {
308     /**
309      * @dev Returns the amount of tokens in existence.
310      */
311     function totalSupply() external view returns (uint256);
312 
313     /**
314      * @dev Returns the amount of tokens owned by `account`.
315      */
316     function balanceOf(address account) external view returns (uint256);
317 
318     /**
319      * @dev Moves `amount` tokens from the caller's account to `recipient`.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transfer(address recipient, uint256 amount) external returns (bool);
326 
327     /**
328      * @dev Returns the remaining number of tokens that `spender` will be
329      * allowed to spend on behalf of `owner` through {transferFrom}. This is
330      * zero by default.
331      *
332      * This value changes when {approve} or {transferFrom} are called.
333      */
334     function allowance(address owner, address spender) external view returns (uint256);
335 
336     /**
337      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * IMPORTANT: Beware that changing an allowance with this method brings the risk
342      * that someone may use both the old and the new allowance by unfortunate
343      * transaction ordering. One possible solution to mitigate this race
344      * condition is to first reduce the spender's allowance to 0 and set the
345      * desired value afterwards:
346      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
347      *
348      * Emits an {Approval} event.
349      */
350     function approve(address spender, uint256 amount) external returns (bool);
351 
352     /**
353      * @dev Moves `amount` tokens from `sender` to `recipient` using the
354      * allowance mechanism. `amount` is then deducted from the caller's
355      * allowance.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Emitted when `value` tokens are moved from one account (`from`) to
365      * another (`to`).
366      *
367      * Note that `value` may be zero.
368      */
369     event Transfer(address indexed from, address indexed to, uint256 value);
370 
371     /**
372      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
373      * a call to {approve}. `value` is the new allowance.
374      */
375     event Approval(address indexed owner, address indexed spender, uint256 value);
376 }
377 
378 
379 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.1.0
380 
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Interface for the optional metadata functions from the ERC20 standard.
386  *
387  * _Available since v4.1._
388  */
389 interface IERC20Metadata is IERC20 {
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() external view returns (string memory);
394 
395     /**
396      * @dev Returns the symbol of the token.
397      */
398     function symbol() external view returns (string memory);
399 
400     /**
401      * @dev Returns the decimals places of the token.
402      */
403     function decimals() external view returns (uint8);
404 }
405 
406 
407 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
408 
409 
410 pragma solidity ^0.8.0;
411 
412 /*
413  * @dev Provides information about the current execution context, including the
414  * sender of the transaction and its data. While these are generally available
415  * via msg.sender and msg.data, they should not be accessed in such a direct
416  * manner, since when dealing with meta-transactions the account sending and
417  * paying for execution may not be the actual sender (as far as an application
418  * is concerned).
419  *
420  * This contract is only required for intermediate, library-like contracts.
421  */
422 abstract contract Context {
423     function _msgSender() internal view virtual returns (address) {
424         return msg.sender;
425     }
426 
427     function _msgData() internal view virtual returns (bytes calldata) {
428         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
429         return msg.data;
430     }
431 }
432 
433 
434 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.1.0
435 
436 
437 pragma solidity ^0.8.0;
438 
439 
440 /**
441  * @dev Implementation of the {IERC20} interface.
442  *
443  * This implementation is agnostic to the way tokens are created. This means
444  * that a supply mechanism has to be added in a derived contract using {_mint}.
445  * For a generic mechanism see {ERC20PresetMinterPauser}.
446  *
447  * TIP: For a detailed writeup see our guide
448  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
449  * to implement supply mechanisms].
450  *
451  * We have followed general OpenZeppelin guidelines: functions revert instead
452  * of returning `false` on failure. This behavior is nonetheless conventional
453  * and does not conflict with the expectations of ERC20 applications.
454  *
455  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
456  * This allows applications to reconstruct the allowance for all accounts just
457  * by listening to said events. Other implementations of the EIP may not emit
458  * these events, as it isn't required by the specification.
459  *
460  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
461  * functions have been added to mitigate the well-known issues around setting
462  * allowances. See {IERC20-approve}.
463  */
464 contract ERC20 is Context, IERC20, IERC20Metadata {
465     mapping (address => uint256) private _balances;
466 
467     mapping (address => mapping (address => uint256)) private _allowances;
468 
469     uint256 private _totalSupply;
470 
471     string private _name;
472     string private _symbol;
473 
474     /**
475      * @dev Sets the values for {name} and {symbol}.
476      *
477      * The defaut value of {decimals} is 18. To select a different value for
478      * {decimals} you should overload it.
479      *
480      * All two of these values are immutable: they can only be set once during
481      * construction.
482      */
483     constructor (string memory name_, string memory symbol_) {
484         _name = name_;
485         _symbol = symbol_;
486     }
487 
488     /**
489      * @dev Returns the name of the token.
490      */
491     function name() public view virtual override returns (string memory) {
492         return _name;
493     }
494 
495     /**
496      * @dev Returns the symbol of the token, usually a shorter version of the
497      * name.
498      */
499     function symbol() public view virtual override returns (string memory) {
500         return _symbol;
501     }
502 
503     /**
504      * @dev Returns the number of decimals used to get its user representation.
505      * For example, if `decimals` equals `2`, a balance of `505` tokens should
506      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
507      *
508      * Tokens usually opt for a value of 18, imitating the relationship between
509      * Ether and Wei. This is the value {ERC20} uses, unless this function is
510      * overridden;
511      *
512      * NOTE: This information is only used for _display_ purposes: it in
513      * no way affects any of the arithmetic of the contract, including
514      * {IERC20-balanceOf} and {IERC20-transfer}.
515      */
516     function decimals() public view virtual override returns (uint8) {
517         return 18;
518     }
519 
520     /**
521      * @dev See {IERC20-totalSupply}.
522      */
523     function totalSupply() public view virtual override returns (uint256) {
524         return _totalSupply;
525     }
526 
527     /**
528      * @dev See {IERC20-balanceOf}.
529      */
530     function balanceOf(address account) public view virtual override returns (uint256) {
531         return _balances[account];
532     }
533 
534     /**
535      * @dev See {IERC20-transfer}.
536      *
537      * Requirements:
538      *
539      * - `recipient` cannot be the zero address.
540      * - the caller must have a balance of at least `amount`.
541      */
542     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
543         _transfer(_msgSender(), recipient, amount);
544         return true;
545     }
546 
547     /**
548      * @dev See {IERC20-allowance}.
549      */
550     function allowance(address owner, address spender) public view virtual override returns (uint256) {
551         return _allowances[owner][spender];
552     }
553 
554     /**
555      * @dev See {IERC20-approve}.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function approve(address spender, uint256 amount) public virtual override returns (bool) {
562         _approve(_msgSender(), spender, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-transferFrom}.
568      *
569      * Emits an {Approval} event indicating the updated allowance. This is not
570      * required by the EIP. See the note at the beginning of {ERC20}.
571      *
572      * Requirements:
573      *
574      * - `sender` and `recipient` cannot be the zero address.
575      * - `sender` must have a balance of at least `amount`.
576      * - the caller must have allowance for ``sender``'s tokens of at least
577      * `amount`.
578      */
579     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
580         _transfer(sender, recipient, amount);
581 
582         uint256 currentAllowance = _allowances[sender][_msgSender()];
583         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
584         _approve(sender, _msgSender(), currentAllowance - amount);
585 
586         return true;
587     }
588 
589     /**
590      * @dev Atomically increases the allowance granted to `spender` by the caller.
591      *
592      * This is an alternative to {approve} that can be used as a mitigation for
593      * problems described in {IERC20-approve}.
594      *
595      * Emits an {Approval} event indicating the updated allowance.
596      *
597      * Requirements:
598      *
599      * - `spender` cannot be the zero address.
600      */
601     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
602         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
603         return true;
604     }
605 
606     /**
607      * @dev Atomically decreases the allowance granted to `spender` by the caller.
608      *
609      * This is an alternative to {approve} that can be used as a mitigation for
610      * problems described in {IERC20-approve}.
611      *
612      * Emits an {Approval} event indicating the updated allowance.
613      *
614      * Requirements:
615      *
616      * - `spender` cannot be the zero address.
617      * - `spender` must have allowance for the caller of at least
618      * `subtractedValue`.
619      */
620     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
621         uint256 currentAllowance = _allowances[_msgSender()][spender];
622         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
623         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
624 
625         return true;
626     }
627 
628     /**
629      * @dev Moves tokens `amount` from `sender` to `recipient`.
630      *
631      * This is internal function is equivalent to {transfer}, and can be used to
632      * e.g. implement automatic token fees, slashing mechanisms, etc.
633      *
634      * Emits a {Transfer} event.
635      *
636      * Requirements:
637      *
638      * - `sender` cannot be the zero address.
639      * - `recipient` cannot be the zero address.
640      * - `sender` must have a balance of at least `amount`.
641      */
642     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
643         require(sender != address(0), "ERC20: transfer from the zero address");
644         require(recipient != address(0), "ERC20: transfer to the zero address");
645 
646         _beforeTokenTransfer(sender, recipient, amount);
647 
648         uint256 senderBalance = _balances[sender];
649         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
650         _balances[sender] = senderBalance - amount;
651         _balances[recipient] += amount;
652 
653         emit Transfer(sender, recipient, amount);
654     }
655 
656     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
657      * the total supply.
658      *
659      * Emits a {Transfer} event with `from` set to the zero address.
660      *
661      * Requirements:
662      *
663      * - `to` cannot be the zero address.
664      */
665     function _mint(address account, uint256 amount) internal virtual {
666         require(account != address(0), "ERC20: mint to the zero address");
667 
668         _beforeTokenTransfer(address(0), account, amount);
669 
670         _totalSupply += amount;
671         _balances[account] += amount;
672         emit Transfer(address(0), account, amount);
673     }
674 
675     /**
676      * @dev Destroys `amount` tokens from `account`, reducing the
677      * total supply.
678      *
679      * Emits a {Transfer} event with `to` set to the zero address.
680      *
681      * Requirements:
682      *
683      * - `account` cannot be the zero address.
684      * - `account` must have at least `amount` tokens.
685      */
686     function _burn(address account, uint256 amount) internal virtual {
687         require(account != address(0), "ERC20: burn from the zero address");
688 
689         _beforeTokenTransfer(account, address(0), amount);
690 
691         uint256 accountBalance = _balances[account];
692         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
693         _balances[account] = accountBalance - amount;
694         _totalSupply -= amount;
695 
696         emit Transfer(account, address(0), amount);
697     }
698 
699     /**
700      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
701      *
702      * This internal function is equivalent to `approve`, and can be used to
703      * e.g. set automatic allowances for certain subsystems, etc.
704      *
705      * Emits an {Approval} event.
706      *
707      * Requirements:
708      *
709      * - `owner` cannot be the zero address.
710      * - `spender` cannot be the zero address.
711      */
712     function _approve(address owner, address spender, uint256 amount) internal virtual {
713         require(owner != address(0), "ERC20: approve from the zero address");
714         require(spender != address(0), "ERC20: approve to the zero address");
715 
716         _allowances[owner][spender] = amount;
717         emit Approval(owner, spender, amount);
718     }
719 
720     /**
721      * @dev Hook that is called before any transfer of tokens. This includes
722      * minting and burning.
723      *
724      * Calling conditions:
725      *
726      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
727      * will be to transferred to `to`.
728      * - when `from` is zero, `amount` tokens will be minted for `to`.
729      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
730      * - `from` and `to` are never both zero.
731      *
732      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
733      */
734     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
735 }
736 
737 
738 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.1.0
739 
740 
741 pragma solidity ^0.8.0;
742 
743 /**
744  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
745  *
746  * These functions can be used to verify that a message was signed by the holder
747  * of the private keys of a given address.
748  */
749 library ECDSA {
750     /**
751      * @dev Returns the address that signed a hashed message (`hash`) with
752      * `signature`. This address can then be used for verification purposes.
753      *
754      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
755      * this function rejects them by requiring the `s` value to be in the lower
756      * half order, and the `v` value to be either 27 or 28.
757      *
758      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
759      * verification to be secure: it is possible to craft signatures that
760      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
761      * this is by receiving a hash of the original message (which may otherwise
762      * be too long), and then calling {toEthSignedMessageHash} on it.
763      */
764     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
765         // Divide the signature in r, s and v variables
766         bytes32 r;
767         bytes32 s;
768         uint8 v;
769 
770         // Check the signature length
771         // - case 65: r,s,v signature (standard)
772         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
773         if (signature.length == 65) {
774             // ecrecover takes the signature parameters, and the only way to get them
775             // currently is to use assembly.
776             // solhint-disable-next-line no-inline-assembly
777             assembly {
778                 r := mload(add(signature, 0x20))
779                 s := mload(add(signature, 0x40))
780                 v := byte(0, mload(add(signature, 0x60)))
781             }
782         } else if (signature.length == 64) {
783             // ecrecover takes the signature parameters, and the only way to get them
784             // currently is to use assembly.
785             // solhint-disable-next-line no-inline-assembly
786             assembly {
787                 let vs := mload(add(signature, 0x40))
788                 r := mload(add(signature, 0x20))
789                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
790                 v := add(shr(255, vs), 27)
791             }
792         } else {
793             revert("ECDSA: invalid signature length");
794         }
795 
796         return recover(hash, v, r, s);
797     }
798 
799     /**
800      * @dev Overload of {ECDSA-recover} that receives the `v`,
801      * `r` and `s` signature fields separately.
802      */
803     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
804         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
805         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
806         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
807         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
808         //
809         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
810         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
811         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
812         // these malleable signatures as well.
813         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
814         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
815 
816         // If the signature is valid (and not malleable), return the signer address
817         address signer = ecrecover(hash, v, r, s);
818         require(signer != address(0), "ECDSA: invalid signature");
819 
820         return signer;
821     }
822 
823     /**
824      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
825      * produces hash corresponding to the one signed with the
826      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
827      * JSON-RPC method as part of EIP-191.
828      *
829      * See {recover}.
830      */
831     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
832         // 32 is the length in bytes of hash,
833         // enforced by the type signature above
834         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
835     }
836 
837     /**
838      * @dev Returns an Ethereum Signed Typed Data, created from a
839      * `domainSeparator` and a `structHash`. This produces hash corresponding
840      * to the one signed with the
841      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
842      * JSON-RPC method as part of EIP-712.
843      *
844      * See {recover}.
845      */
846     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
847         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
848     }
849 }
850 
851 
852 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.1.0
853 
854 
855 pragma solidity ^0.8.0;
856 
857 /**
858  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
859  *
860  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
861  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
862  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
863  *
864  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
865  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
866  * ({_hashTypedDataV4}).
867  *
868  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
869  * the chain id to protect against replay attacks on an eventual fork of the chain.
870  *
871  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
872  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
873  *
874  * _Available since v3.4._
875  */
876 abstract contract EIP712 {
877     /* solhint-disable var-name-mixedcase */
878     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
879     // invalidate the cached domain separator if the chain id changes.
880     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
881     uint256 private immutable _CACHED_CHAIN_ID;
882 
883     bytes32 private immutable _HASHED_NAME;
884     bytes32 private immutable _HASHED_VERSION;
885     bytes32 private immutable _TYPE_HASH;
886     /* solhint-enable var-name-mixedcase */
887 
888     /**
889      * @dev Initializes the domain separator and parameter caches.
890      *
891      * The meaning of `name` and `version` is specified in
892      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
893      *
894      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
895      * - `version`: the current major version of the signing domain.
896      *
897      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
898      * contract upgrade].
899      */
900     constructor(string memory name, string memory version) {
901         bytes32 hashedName = keccak256(bytes(name));
902         bytes32 hashedVersion = keccak256(bytes(version));
903         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
904         _HASHED_NAME = hashedName;
905         _HASHED_VERSION = hashedVersion;
906         _CACHED_CHAIN_ID = block.chainid;
907         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
908         _TYPE_HASH = typeHash;
909     }
910 
911     /**
912      * @dev Returns the domain separator for the current chain.
913      */
914     function _domainSeparatorV4() internal view returns (bytes32) {
915         if (block.chainid == _CACHED_CHAIN_ID) {
916             return _CACHED_DOMAIN_SEPARATOR;
917         } else {
918             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
919         }
920     }
921 
922     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
923         return keccak256(
924             abi.encode(
925                 typeHash,
926                 name,
927                 version,
928                 block.chainid,
929                 address(this)
930             )
931         );
932     }
933 
934     /**
935      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
936      * function returns the hash of the fully encoded EIP712 message for this domain.
937      *
938      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
939      *
940      * ```solidity
941      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
942      *     keccak256("Mail(address to,string contents)"),
943      *     mailTo,
944      *     keccak256(bytes(mailContents))
945      * )));
946      * address signer = ECDSA.recover(digest, signature);
947      * ```
948      */
949     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
950         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
951     }
952 }
953 
954 
955 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
956 
957 
958 pragma solidity ^0.8.0;
959 
960 /**
961  * @title Counters
962  * @author Matt Condon (@shrugs)
963  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
964  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
965  *
966  * Include with `using Counters for Counters.Counter;`
967  */
968 library Counters {
969     struct Counter {
970         // This variable should never be directly accessed by users of the library: interactions must be restricted to
971         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
972         // this feature: see https://github.com/ethereum/solidity/issues/4637
973         uint256 _value; // default: 0
974     }
975 
976     function current(Counter storage counter) internal view returns (uint256) {
977         return counter._value;
978     }
979 
980     function increment(Counter storage counter) internal {
981         unchecked {
982             counter._value += 1;
983         }
984     }
985 
986     function decrement(Counter storage counter) internal {
987         uint256 value = counter._value;
988         require(value > 0, "Counter: decrement overflow");
989         unchecked {
990             counter._value = value - 1;
991         }
992     }
993 }
994 
995 
996 // File @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol@v4.1.0
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1004  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1005  *
1006  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1007  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1008  * need to send a transaction, and thus is not required to hold Ether at all.
1009  *
1010  * _Available since v3.4._
1011  */
1012 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1013     using Counters for Counters.Counter;
1014 
1015     mapping (address => Counters.Counter) private _nonces;
1016 
1017     // solhint-disable-next-line var-name-mixedcase
1018     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1019 
1020     /**
1021      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1022      *
1023      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1024      */
1025     constructor(string memory name) EIP712(name, "1") {
1026     }
1027 
1028     /**
1029      * @dev See {IERC20Permit-permit}.
1030      */
1031     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
1032         // solhint-disable-next-line not-rely-on-time
1033         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1034 
1035         bytes32 structHash = keccak256(
1036             abi.encode(
1037                 _PERMIT_TYPEHASH,
1038                 owner,
1039                 spender,
1040                 value,
1041                 _useNonce(owner),
1042                 deadline
1043             )
1044         );
1045 
1046         bytes32 hash = _hashTypedDataV4(structHash);
1047 
1048         address signer = ECDSA.recover(hash, v, r, s);
1049         require(signer == owner, "ERC20Permit: invalid signature");
1050 
1051         _approve(owner, spender, value);
1052     }
1053 
1054     /**
1055      * @dev See {IERC20Permit-nonces}.
1056      */
1057     function nonces(address owner) public view virtual override returns (uint256) {
1058         return _nonces[owner].current();
1059     }
1060 
1061     /**
1062      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1063      */
1064     // solhint-disable-next-line func-name-mixedcase
1065     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1066         return _domainSeparatorV4();
1067     }
1068 
1069     /**
1070      * @dev "Consume a nonce": return the current value and increment.
1071      *
1072      * _Available since v4.1._
1073      */
1074     function _useNonce(address owner) internal virtual returns (uint256 current) {
1075         Counters.Counter storage nonce = _nonces[owner];
1076         current = nonce.current();
1077         nonce.increment();
1078     }
1079 }
1080 
1081 
1082 // File contracts/libraries/UncheckedAddress.sol
1083 
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 
1088 library UncheckedAddress {
1089     function uncheckedFunctionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1090         return uncheckedFunctionCallWithValue(target, data, 0, errorMessage);
1091     }
1092 
1093     function uncheckedFunctionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1094         require(address(this).balance >= value, "UA: insufficient balance");
1095         // Check turned off:
1096         // require(isContract(target), "Address: call to non-contract");
1097 
1098         // solhint-disable-next-line avoid-low-level-calls
1099         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1100         return _verifyCallResult(success, returndata, errorMessage);
1101     }
1102 
1103     function uncheckedFunctionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1104         // Check turned off:
1105         // require(isContract(target), "Address: static call to non-contract");
1106 
1107         // solhint-disable-next-line avoid-low-level-calls
1108         (bool success, bytes memory returndata) = target.staticcall(data);
1109         return _verifyCallResult(success, returndata, errorMessage);
1110     }
1111 
1112     //noinspection NoReturn
1113     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1114         if (success) {
1115             return returndata;
1116         } else {
1117             // Look for revert reason and bubble it up if present
1118             if (returndata.length > 0) {
1119                 // The easiest way to bubble the revert reason is using memory via assembly
1120 
1121                 // solhint-disable-next-line no-inline-assembly
1122                 assembly {
1123                     revert(add(32, returndata), mload(returndata))
1124                 }
1125             } else {
1126                 revert(errorMessage);
1127             }
1128         }
1129     }
1130 }
1131 
1132 
1133 // File contracts/helpers/AmountCalculator.sol
1134 
1135 
1136 pragma solidity ^0.8.0;
1137 
1138 /// @title A helper contract for calculations related to order amounts
1139 contract AmountCalculator {
1140     using UncheckedAddress for address;
1141 
1142     /// @notice Calculates maker amount
1143     /// @return Floored maker amount
1144     function getMakerAmount(uint256 orderMakerAmount, uint256 orderTakerAmount, uint256 swapTakerAmount) external pure returns(uint256) {
1145         return swapTakerAmount * orderMakerAmount / orderTakerAmount;
1146     }
1147 
1148     /// @notice Calculates taker amount
1149     /// @return Ceiled taker amount
1150     function getTakerAmount(uint256 orderMakerAmount, uint256 orderTakerAmount, uint256 swapMakerAmount) external pure returns(uint256) {
1151         return (swapMakerAmount * orderTakerAmount + orderMakerAmount - 1) / orderMakerAmount;
1152     }
1153 
1154     /// @notice Performs an arbitrary call to target with data
1155     /// @return Result bytes transmuted to uint256
1156     function arbitraryStaticCall(address target, bytes memory data) external view returns(uint256) {
1157         (bytes memory result) = target.uncheckedFunctionStaticCall(data, "AC: arbitraryStaticCall");
1158         return abi.decode(result, (uint256));
1159     }
1160 }
1161 
1162 
1163 // File contracts/interfaces/AggregatorV3Interface.sol
1164 
1165 
1166 pragma solidity ^0.8.0;
1167 
1168 interface AggregatorV3Interface {
1169     function latestAnswer() external view returns (int256);
1170     function latestTimestamp() external view returns (uint256);
1171 }
1172 
1173 
1174 // File contracts/helpers/ChainlinkCalculator.sol
1175 
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 /// @title A helper contract for interactions with https://docs.chain.link
1180 contract ChainlinkCalculator {
1181     uint256 private constant _SPREAD_DENOMINATOR = 1e9;
1182     uint256 private constant _ORACLE_EXPIRATION_TIME = 30 minutes;
1183     uint256 private constant _INVERSE_MASK = 1 << 255;
1184 
1185     /// @notice Calculates price of token relative to ETH scaled by 1e18
1186     /// @param inverseAndSpread concatenated inverse flag and spread.
1187     /// Lowest 254 bits specify spread amount. Spread is scaled by 1e9, i.e. 101% = 1.01e9, 99% = 0.99e9.
1188     /// Highest bit is set when oracle price should be inverted,
1189     /// e.g. for DAI-ETH oracle, inverse=false means that we request DAI price in ETH
1190     /// and inverse=true means that we request ETH price in DAI
1191     /// @return Token price times amount
1192     function singlePrice(AggregatorV3Interface oracle, uint256 inverseAndSpread, uint256 amount) external view returns(uint256) {
1193         // solhint-disable-next-line not-rely-on-time
1194         require(oracle.latestTimestamp() + _ORACLE_EXPIRATION_TIME > block.timestamp, "CC: stale data");
1195         bool inverse = inverseAndSpread & _INVERSE_MASK > 0;
1196         uint256 spread = inverseAndSpread & (~_INVERSE_MASK);
1197         if (inverse) {
1198             return amount * spread * 1e18 / uint256(oracle.latestAnswer()) / _SPREAD_DENOMINATOR;
1199         } else {
1200             return amount * spread * uint256(oracle.latestAnswer()) / 1e18 / _SPREAD_DENOMINATOR;
1201         }
1202     }
1203 
1204     /// @notice Calculates price of token A relative to token B. Note that order is important
1205     /// @return Token A relative price times amount
1206     function doublePrice(AggregatorV3Interface oracle1, AggregatorV3Interface oracle2, uint256 spread, uint256 amount) external view returns(uint256) {
1207         // solhint-disable-next-line not-rely-on-time
1208         require(oracle1.latestTimestamp() + _ORACLE_EXPIRATION_TIME > block.timestamp, "CC: stale data O1");
1209         // solhint-disable-next-line not-rely-on-time
1210         require(oracle2.latestTimestamp() + _ORACLE_EXPIRATION_TIME > block.timestamp, "CC: stale data O2");
1211 
1212         return amount * spread * uint256(oracle1.latestAnswer()) / uint256(oracle2.latestAnswer()) / _SPREAD_DENOMINATOR;
1213     }
1214 }
1215 
1216 
1217 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
1218 
1219 
1220 pragma solidity ^0.8.0;
1221 
1222 /**
1223  * @dev Interface of the ERC165 standard, as defined in the
1224  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1225  *
1226  * Implementers can declare support of contract interfaces, which can then be
1227  * queried by others ({ERC165Checker}).
1228  *
1229  * For an implementation, see {ERC165}.
1230  */
1231 interface IERC165 {
1232     /**
1233      * @dev Returns true if this contract implements the interface defined by
1234      * `interfaceId`. See the corresponding
1235      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1236      * to learn more about how these ids are created.
1237      *
1238      * This function call must use less than 30 000 gas.
1239      */
1240     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1241 }
1242 
1243 
1244 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.1.0
1245 
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1251  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1252  *
1253  * _Available since v3.1._
1254  */
1255 interface IERC1155 is IERC165 {
1256     /**
1257      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1258      */
1259     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1260 
1261     /**
1262      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1263      * transfers.
1264      */
1265     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1266 
1267     /**
1268      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1269      * `approved`.
1270      */
1271     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1272 
1273     /**
1274      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1275      *
1276      * If an {URI} event was emitted for `id`, the standard
1277      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1278      * returned by {IERC1155MetadataURI-uri}.
1279      */
1280     event URI(string value, uint256 indexed id);
1281 
1282     /**
1283      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1284      *
1285      * Requirements:
1286      *
1287      * - `account` cannot be the zero address.
1288      */
1289     function balanceOf(address account, uint256 id) external view returns (uint256);
1290 
1291     /**
1292      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1293      *
1294      * Requirements:
1295      *
1296      * - `accounts` and `ids` must have the same length.
1297      */
1298     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1299 
1300     /**
1301      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1302      *
1303      * Emits an {ApprovalForAll} event.
1304      *
1305      * Requirements:
1306      *
1307      * - `operator` cannot be the caller.
1308      */
1309     function setApprovalForAll(address operator, bool approved) external;
1310 
1311     /**
1312      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1313      *
1314      * See {setApprovalForAll}.
1315      */
1316     function isApprovedForAll(address account, address operator) external view returns (bool);
1317 
1318     /**
1319      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1320      *
1321      * Emits a {TransferSingle} event.
1322      *
1323      * Requirements:
1324      *
1325      * - `to` cannot be the zero address.
1326      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1327      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1328      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1329      * acceptance magic value.
1330      */
1331     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1332 
1333     /**
1334      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1335      *
1336      * Emits a {TransferBatch} event.
1337      *
1338      * Requirements:
1339      *
1340      * - `ids` and `amounts` must have the same length.
1341      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1342      * acceptance magic value.
1343      */
1344     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1345 }
1346 
1347 
1348 // File contracts/helpers/ImmutableOwner.sol
1349 
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 /// @title A helper contract with helper modifiers to allow access to original contract creator only
1354 contract ImmutableOwner {
1355     address public immutable immutableOwner;
1356 
1357     modifier onlyImmutableOwner {
1358         require(msg.sender == immutableOwner, "IO: Access denied");
1359         _;
1360     }
1361 
1362     constructor(address _immutableOwner) {
1363         immutableOwner = _immutableOwner;
1364     }
1365 }
1366 
1367 
1368 // File contracts/helpers/ERC1155Proxy.sol
1369 
1370 
1371 pragma solidity ^0.8.0;
1372 
1373 
1374 /* solhint-disable func-name-mixedcase */
1375 
1376 abstract contract ERC1155Proxy is ImmutableOwner {
1377     constructor() {
1378         require(ERC1155Proxy.func_733NCGU.selector == bytes4(uint32(IERC20.transferFrom.selector) + 4), "ERC1155Proxy: bad selector");
1379     }
1380 
1381     // keccak256("func_733NCGU(address,address,uint256,address,uint256,bytes)") == 0x23b872e1
1382     function func_733NCGU(address from, address to, uint256 amount, IERC1155 token, uint256 tokenId, bytes calldata data) external onlyImmutableOwner {
1383         token.safeTransferFrom(from, to, tokenId, amount, data);
1384     }
1385 }
1386 
1387 /* solhint-enable func-name-mixedcase */
1388 
1389 
1390 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
1391 
1392 
1393 pragma solidity ^0.8.0;
1394 
1395 /**
1396  * @dev Collection of functions related to the address type
1397  */
1398 library Address {
1399     /**
1400      * @dev Returns true if `account` is a contract.
1401      *
1402      * [IMPORTANT]
1403      * ====
1404      * It is unsafe to assume that an address for which this function returns
1405      * false is an externally-owned account (EOA) and not a contract.
1406      *
1407      * Among others, `isContract` will return false for the following
1408      * types of addresses:
1409      *
1410      *  - an externally-owned account
1411      *  - a contract in construction
1412      *  - an address where a contract will be created
1413      *  - an address where a contract lived, but was destroyed
1414      * ====
1415      */
1416     function isContract(address account) internal view returns (bool) {
1417         // This method relies on extcodesize, which returns 0 for contracts in
1418         // construction, since the code is only stored at the end of the
1419         // constructor execution.
1420 
1421         uint256 size;
1422         // solhint-disable-next-line no-inline-assembly
1423         assembly { size := extcodesize(account) }
1424         return size > 0;
1425     }
1426 
1427     /**
1428      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1429      * `recipient`, forwarding all available gas and reverting on errors.
1430      *
1431      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1432      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1433      * imposed by `transfer`, making them unable to receive funds via
1434      * `transfer`. {sendValue} removes this limitation.
1435      *
1436      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1437      *
1438      * IMPORTANT: because control is transferred to `recipient`, care must be
1439      * taken to not create reentrancy vulnerabilities. Consider using
1440      * {ReentrancyGuard} or the
1441      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1442      */
1443     function sendValue(address payable recipient, uint256 amount) internal {
1444         require(address(this).balance >= amount, "Address: insufficient balance");
1445 
1446         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1447         (bool success, ) = recipient.call{ value: amount }("");
1448         require(success, "Address: unable to send value, recipient may have reverted");
1449     }
1450 
1451     /**
1452      * @dev Performs a Solidity function call using a low level `call`. A
1453      * plain`call` is an unsafe replacement for a function call: use this
1454      * function instead.
1455      *
1456      * If `target` reverts with a revert reason, it is bubbled up by this
1457      * function (like regular Solidity function calls).
1458      *
1459      * Returns the raw returned data. To convert to the expected return value,
1460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1461      *
1462      * Requirements:
1463      *
1464      * - `target` must be a contract.
1465      * - calling `target` with `data` must not revert.
1466      *
1467      * _Available since v3.1._
1468      */
1469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1470       return functionCall(target, data, "Address: low-level call failed");
1471     }
1472 
1473     /**
1474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1475      * `errorMessage` as a fallback revert reason when `target` reverts.
1476      *
1477      * _Available since v3.1._
1478      */
1479     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1480         return functionCallWithValue(target, data, 0, errorMessage);
1481     }
1482 
1483     /**
1484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1485      * but also transferring `value` wei to `target`.
1486      *
1487      * Requirements:
1488      *
1489      * - the calling contract must have an ETH balance of at least `value`.
1490      * - the called Solidity function must be `payable`.
1491      *
1492      * _Available since v3.1._
1493      */
1494     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1495         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1496     }
1497 
1498     /**
1499      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1500      * with `errorMessage` as a fallback revert reason when `target` reverts.
1501      *
1502      * _Available since v3.1._
1503      */
1504     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1505         require(address(this).balance >= value, "Address: insufficient balance for call");
1506         require(isContract(target), "Address: call to non-contract");
1507 
1508         // solhint-disable-next-line avoid-low-level-calls
1509         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1510         return _verifyCallResult(success, returndata, errorMessage);
1511     }
1512 
1513     /**
1514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1515      * but performing a static call.
1516      *
1517      * _Available since v3.3._
1518      */
1519     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1520         return functionStaticCall(target, data, "Address: low-level static call failed");
1521     }
1522 
1523     /**
1524      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1525      * but performing a static call.
1526      *
1527      * _Available since v3.3._
1528      */
1529     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1530         require(isContract(target), "Address: static call to non-contract");
1531 
1532         // solhint-disable-next-line avoid-low-level-calls
1533         (bool success, bytes memory returndata) = target.staticcall(data);
1534         return _verifyCallResult(success, returndata, errorMessage);
1535     }
1536 
1537     /**
1538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1539      * but performing a delegate call.
1540      *
1541      * _Available since v3.4._
1542      */
1543     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1544         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1545     }
1546 
1547     /**
1548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1549      * but performing a delegate call.
1550      *
1551      * _Available since v3.4._
1552      */
1553     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1554         require(isContract(target), "Address: delegate call to non-contract");
1555 
1556         // solhint-disable-next-line avoid-low-level-calls
1557         (bool success, bytes memory returndata) = target.delegatecall(data);
1558         return _verifyCallResult(success, returndata, errorMessage);
1559     }
1560 
1561     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1562         if (success) {
1563             return returndata;
1564         } else {
1565             // Look for revert reason and bubble it up if present
1566             if (returndata.length > 0) {
1567                 // The easiest way to bubble the revert reason is using memory via assembly
1568 
1569                 // solhint-disable-next-line no-inline-assembly
1570                 assembly {
1571                     let returndata_size := mload(returndata)
1572                     revert(add(32, returndata), returndata_size)
1573                 }
1574             } else {
1575                 revert(errorMessage);
1576             }
1577         }
1578     }
1579 }
1580 
1581 
1582 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.1.0
1583 
1584 
1585 pragma solidity ^0.8.0;
1586 
1587 
1588 /**
1589  * @title SafeERC20
1590  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1591  * contract returns false). Tokens that return no value (and instead revert or
1592  * throw on failure) are also supported, non-reverting calls are assumed to be
1593  * successful.
1594  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1595  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1596  */
1597 library SafeERC20 {
1598     using Address for address;
1599 
1600     function safeTransfer(IERC20 token, address to, uint256 value) internal {
1601         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1602     }
1603 
1604     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
1605         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1606     }
1607 
1608     /**
1609      * @dev Deprecated. This function has issues similar to the ones found in
1610      * {IERC20-approve}, and its usage is discouraged.
1611      *
1612      * Whenever possible, use {safeIncreaseAllowance} and
1613      * {safeDecreaseAllowance} instead.
1614      */
1615     function safeApprove(IERC20 token, address spender, uint256 value) internal {
1616         // safeApprove should only be called when setting an initial allowance,
1617         // or when resetting it to zero. To increase and decrease it, use
1618         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1619         // solhint-disable-next-line max-line-length
1620         require((value == 0) || (token.allowance(address(this), spender) == 0),
1621             "SafeERC20: approve from non-zero to non-zero allowance"
1622         );
1623         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1624     }
1625 
1626     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1627         uint256 newAllowance = token.allowance(address(this), spender) + value;
1628         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1629     }
1630 
1631     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
1632         unchecked {
1633             uint256 oldAllowance = token.allowance(address(this), spender);
1634             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1635             uint256 newAllowance = oldAllowance - value;
1636             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1637         }
1638     }
1639 
1640     /**
1641      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1642      * on the return value: the return value is optional (but if data is returned, it must not be false).
1643      * @param token The token targeted by the call.
1644      * @param data The call data (encoded using abi.encode or one of its variants).
1645      */
1646     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1647         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1648         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1649         // the target address contains contract code and also asserts for success in the low-level call.
1650 
1651         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1652         if (returndata.length > 0) { // Return data is optional
1653             // solhint-disable-next-line max-line-length
1654             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1655         }
1656     }
1657 }
1658 
1659 
1660 // File contracts/helpers/ERC20Proxy.sol
1661 
1662 
1663 pragma solidity ^0.8.0;
1664 
1665 /* solhint-disable func-name-mixedcase */
1666 
1667 abstract contract ERC20Proxy is ImmutableOwner {
1668     using SafeERC20 for IERC20;
1669 
1670     constructor() {
1671         require(ERC20Proxy.func_50BkM4K.selector == bytes4(uint32(IERC20.transferFrom.selector) + 1), "ERC20Proxy: bad selector");
1672     }
1673 
1674     // keccak256("func_50BkM4K(address,address,uint256,address)") = 0x23b872de
1675     function func_50BkM4K(address from, address to, uint256 amount, IERC20 token) external onlyImmutableOwner {
1676         token.safeTransferFrom(from, to, amount);
1677     }
1678 }
1679 
1680 /* solhint-enable func-name-mixedcase */
1681 
1682 
1683 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
1684 
1685 
1686 pragma solidity ^0.8.0;
1687 
1688 /**
1689  * @dev Required interface of an ERC721 compliant contract.
1690  */
1691 interface IERC721 is IERC165 {
1692     /**
1693      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1694      */
1695     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1696 
1697     /**
1698      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1699      */
1700     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1701 
1702     /**
1703      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1704      */
1705     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1706 
1707     /**
1708      * @dev Returns the number of tokens in ``owner``'s account.
1709      */
1710     function balanceOf(address owner) external view returns (uint256 balance);
1711 
1712     /**
1713      * @dev Returns the owner of the `tokenId` token.
1714      *
1715      * Requirements:
1716      *
1717      * - `tokenId` must exist.
1718      */
1719     function ownerOf(uint256 tokenId) external view returns (address owner);
1720 
1721     /**
1722      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1723      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1724      *
1725      * Requirements:
1726      *
1727      * - `from` cannot be the zero address.
1728      * - `to` cannot be the zero address.
1729      * - `tokenId` token must exist and be owned by `from`.
1730      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1732      *
1733      * Emits a {Transfer} event.
1734      */
1735     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1736 
1737     /**
1738      * @dev Transfers `tokenId` token from `from` to `to`.
1739      *
1740      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1741      *
1742      * Requirements:
1743      *
1744      * - `from` cannot be the zero address.
1745      * - `to` cannot be the zero address.
1746      * - `tokenId` token must be owned by `from`.
1747      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function transferFrom(address from, address to, uint256 tokenId) external;
1752 
1753     /**
1754      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1755      * The approval is cleared when the token is transferred.
1756      *
1757      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1758      *
1759      * Requirements:
1760      *
1761      * - The caller must own the token or be an approved operator.
1762      * - `tokenId` must exist.
1763      *
1764      * Emits an {Approval} event.
1765      */
1766     function approve(address to, uint256 tokenId) external;
1767 
1768     /**
1769      * @dev Returns the account approved for `tokenId` token.
1770      *
1771      * Requirements:
1772      *
1773      * - `tokenId` must exist.
1774      */
1775     function getApproved(uint256 tokenId) external view returns (address operator);
1776 
1777     /**
1778      * @dev Approve or remove `operator` as an operator for the caller.
1779      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1780      *
1781      * Requirements:
1782      *
1783      * - The `operator` cannot be the caller.
1784      *
1785      * Emits an {ApprovalForAll} event.
1786      */
1787     function setApprovalForAll(address operator, bool _approved) external;
1788 
1789     /**
1790      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1791      *
1792      * See {setApprovalForAll}
1793      */
1794     function isApprovedForAll(address owner, address operator) external view returns (bool);
1795 
1796     /**
1797       * @dev Safely transfers `tokenId` token from `from` to `to`.
1798       *
1799       * Requirements:
1800       *
1801       * - `from` cannot be the zero address.
1802       * - `to` cannot be the zero address.
1803       * - `tokenId` token must exist and be owned by `from`.
1804       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1805       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1806       *
1807       * Emits a {Transfer} event.
1808       */
1809     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1810 }
1811 
1812 
1813 // File contracts/helpers/ERC721Proxy.sol
1814 
1815 
1816 pragma solidity ^0.8.0;
1817 
1818 
1819 /* solhint-disable func-name-mixedcase */
1820 
1821 abstract contract ERC721Proxy is ImmutableOwner {
1822     constructor() {
1823         require(ERC721Proxy.func_40aVqeY.selector == bytes4(uint32(IERC20.transferFrom.selector) + 2), "ERC20Proxy: bad selector");
1824         require(ERC721Proxy.func_20xtkDI.selector == bytes4(uint32(IERC20.transferFrom.selector) + 3), "ERC20Proxy: bad selector");
1825     }
1826 
1827     // keccak256("func_40aVqeY(address,address,uint256,address)") == 0x23b872df
1828     function func_40aVqeY(address from, address to, uint256 tokenId, IERC721 token) external onlyImmutableOwner {
1829         token.transferFrom(from, to, tokenId);
1830     }
1831 
1832     // keccak256("func_20xtkDI(address,address,uint256,address)" == 0x23b872e0
1833     function func_20xtkDI(address from, address to, uint256 tokenId, IERC721 token) external onlyImmutableOwner {
1834         token.safeTransferFrom(from, to, tokenId);
1835     }
1836 }
1837 
1838 /* solhint-enable func-name-mixedcase */
1839 
1840 
1841 // File contracts/helpers/NonceManager.sol
1842 
1843 
1844 pragma solidity ^0.8.0;
1845 
1846 /// @title A helper contract for managing nonce of tx sender
1847 contract NonceManager {
1848     event NonceIncreased(address indexed maker, uint256 newNonce);
1849 
1850     mapping(address => uint256) public nonce;
1851 
1852     /// @notice Advances nonce by one
1853     function increaseNonce() external {
1854         advanceNonce(1);
1855     }
1856 
1857     function advanceNonce(uint8 amount) public {
1858         emit NonceIncreased(msg.sender, nonce[msg.sender] += amount);
1859     }
1860 
1861     function nonceEquals(address makerAddress, uint256 makerNonce) external view returns(bool) {
1862         return nonce[makerAddress] == makerNonce;
1863     }
1864 }
1865 
1866 
1867 // File contracts/helpers/PredicateHelper.sol
1868 
1869 
1870 pragma solidity ^0.8.0;
1871 
1872 /// @title A helper contract for executing boolean functions on arbitrary target call results
1873 contract PredicateHelper {
1874     using UncheckedAddress for address;
1875 
1876     /// @notice Calls every target with corresponding data
1877     /// @return True if call to any target returned True. Otherwise, false
1878     function or(address[] calldata targets, bytes[] calldata data) external view returns(bool) {
1879         require(targets.length == data.length, "PH: input array size mismatch");
1880         for (uint i = 0; i < targets.length; i++) {
1881             bytes memory result = targets[i].uncheckedFunctionStaticCall(data[i], "PH: 'or' subcall failed");
1882             require(result.length == 32, "PH: invalid call result");
1883             if (abi.decode(result, (bool))) {
1884                 return true;
1885             }
1886         }
1887         return false;
1888     }
1889 
1890     /// @notice Calls every target with corresponding data
1891     /// @return True if calls to all targets returned True. Otherwise, false
1892     function and(address[] calldata targets, bytes[] calldata data) external view returns(bool) {
1893         require(targets.length == data.length, "PH: input array size mismatch");
1894         for (uint i = 0; i < targets.length; i++) {
1895             bytes memory result = targets[i].uncheckedFunctionStaticCall(data[i], "PH: 'and' subcall failed");
1896             require(result.length == 32, "PH: invalid call result");
1897             if (!abi.decode(result, (bool))) {
1898                 return false;
1899             }
1900         }
1901         return true;
1902     }
1903 
1904     /// @notice Calls target with specified data and tests if it's equal to the value
1905     /// @param value Value to test
1906     /// @return True if call to target returns the same value as `value`. Otherwise, false
1907     function eq(uint256 value, address target, bytes memory data) external view returns(bool) {
1908         bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: eq");
1909         require(result.length == 32, "PH: invalid call result");
1910         return abi.decode(result, (uint256)) == value;
1911     }
1912 
1913     /// @notice Calls target with specified data and tests if it's lower than value
1914     /// @param value Value to test
1915     /// @return True if call to target returns value which is lower than `value`. Otherwise, false
1916     function lt(uint256 value, address target, bytes memory data) external view returns(bool) {
1917         bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: lt");
1918         require(result.length == 32, "PH: invalid call result");
1919         return abi.decode(result, (uint256)) < value;
1920     }
1921 
1922     /// @notice Calls target with specified data and tests if it's bigger than value
1923     /// @param value Value to test
1924     /// @return True if call to target returns value which is bigger than `value`. Otherwise, false
1925     function gt(uint256 value, address target, bytes memory data) external view returns(bool) {
1926         bytes memory result = target.uncheckedFunctionStaticCall(data, "PH: gt");
1927         require(result.length == 32, "PH: invalid call result");
1928         return abi.decode(result, (uint256)) > value;
1929     }
1930 
1931     /// @notice Checks passed time against block timestamp
1932     /// @return True if current block timestamp is lower than `time`. Otherwise, false
1933     function timestampBelow(uint256 time) external view returns(bool) {
1934         return block.timestamp < time;  // solhint-disable-line not-rely-on-time
1935     }
1936 }
1937 
1938 
1939 // File contracts/interfaces/InteractiveMaker.sol
1940 
1941 
1942 pragma solidity ^0.8.0;
1943 
1944 
1945 interface InteractiveMaker {
1946     function notifyFillOrder(
1947         address makerAsset,
1948         address takerAsset,
1949         uint256 makingAmount,
1950         uint256 takingAmount,
1951         bytes memory interactiveData
1952     ) external;
1953 }
1954 
1955 
1956 // File contracts/libraries/ArgumentsDecoder.sol
1957 
1958 
1959 pragma solidity ^0.8.0;
1960 
1961 
1962 library ArgumentsDecoder {
1963     function decodeSelector(bytes memory data) internal pure returns(bytes4 selector) {
1964         assembly { // solhint-disable-line no-inline-assembly
1965             selector := mload(add(data, 0x20))
1966         }
1967     }
1968 
1969     function decodeAddress(bytes memory data, uint256 argumentIndex) internal pure returns(address account) {
1970         assembly { // solhint-disable-line no-inline-assembly
1971             account := mload(add(add(data, 0x24), mul(argumentIndex, 0x20)))
1972         }
1973     }
1974 
1975     function decodeUint256(bytes memory data, uint256 argumentIndex) internal pure returns(uint256 value) {
1976         assembly { // solhint-disable-line no-inline-assembly
1977             value := mload(add(add(data, 0x24), mul(argumentIndex, 0x20)))
1978         }
1979     }
1980 
1981     function patchAddress(bytes memory data, uint256 argumentIndex, address account) internal pure {
1982         assembly { // solhint-disable-line no-inline-assembly
1983             mstore(add(add(data, 0x24), mul(argumentIndex, 0x20)), account)
1984         }
1985     }
1986 
1987     function patchUint256(bytes memory data, uint256 argumentIndex, uint256 value) internal pure {
1988         assembly { // solhint-disable-line no-inline-assembly
1989             mstore(add(add(data, 0x24), mul(argumentIndex, 0x20)), value)
1990         }
1991     }
1992 }
1993 
1994 
1995 // File contracts/libraries/SilentECDSA.sol
1996 
1997 
1998 pragma solidity ^0.8.0;
1999 
2000 /**
2001  * @dev Copy of OpenZeppelin ECDSA library that does not revert
2002  * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/df7996b671d309ee949113c64beee9899133dc05/contracts/utils/cryptography/ECDSA.sol
2003  *
2004  * Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2005  *
2006  * These functions can be used to verify that a message was signed by the holder
2007  * of the private keys of a given address.
2008  */
2009 library SilentECDSA {
2010     /**
2011      * @dev Returns the address that signed a hashed message (`hash`) with
2012      * `signature`. This address can then be used for verification purposes.
2013      *
2014      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2015      * this function rejects them by requiring the `s` value to be in the lower
2016      * half order, and the `v` value to be either 27 or 28.
2017      *
2018      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2019      * verification to be secure: it is possible to craft signatures that
2020      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2021      * this is by receiving a hash of the original message (which may otherwise
2022      * be too long), and then calling {toEthSignedMessageHash} on it.
2023      */
2024     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2025         // Divide the signature in r, s and v variables
2026         bytes32 r;
2027         bytes32 s;
2028         uint8 v;
2029 
2030         // Check the signature length
2031         // - case 65: r,s,v signature (standard)
2032         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
2033         if (signature.length == 65) {
2034             // ecrecover takes the signature parameters, and the only way to get them
2035             // currently is to use assembly.
2036             // solhint-disable-next-line no-inline-assembly
2037             assembly {
2038                 r := mload(add(signature, 0x20))
2039                 s := mload(add(signature, 0x40))
2040                 v := byte(0, mload(add(signature, 0x60)))
2041             }
2042         } else if (signature.length == 64) {
2043             // ecrecover takes the signature parameters, and the only way to get them
2044             // currently is to use assembly.
2045             // solhint-disable-next-line no-inline-assembly
2046             assembly {
2047                 let vs := mload(add(signature, 0x40))
2048                 r := mload(add(signature, 0x20))
2049                 s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
2050                 v := add(shr(255, vs), 27)
2051             }
2052         } else {
2053             // revert("ECDSA: invalid signature length");
2054             return address(0);
2055         }
2056 
2057         return recover(hash, v, r, s);
2058     }
2059 
2060     /**
2061      * @dev Overload of {ECDSA-recover} that receives the `v`,
2062      * `r` and `s` signature fields separately.
2063      */
2064     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
2065         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2066         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2067         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
2068         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2069         //
2070         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2071         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2072         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2073         // these malleable signatures as well.
2074         // require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid 's' value");
2075         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2076             return address(0);
2077         }
2078         // require(v == 27 || v == 28, "ECDSA: invalid 'v' value");
2079         if (v != 27 && v != 28) {
2080             return address(0);
2081         }
2082 
2083         // If the signature is valid (and not malleable), return the signer address
2084         address signer = ecrecover(hash, v, r, s);
2085         // require(signer != address(0), "ECDSA: invalid signature");
2086 
2087         return signer;
2088     }
2089 
2090     /**
2091      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2092      * produces hash corresponding to the one signed with the
2093      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2094      * JSON-RPC method as part of EIP-191.
2095      *
2096      * See {recover}.
2097      */
2098     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2099         // 32 is the length in bytes of hash,
2100         // enforced by the type signature above
2101         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2102     }
2103 
2104     /**
2105      * @dev Returns an Ethereum Signed Typed Data, created from a
2106      * `domainSeparator` and a `structHash`. This produces hash corresponding
2107      * to the one signed with the
2108      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2109      * JSON-RPC method as part of EIP-712.
2110      *
2111      * See {recover}.
2112      */
2113     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2114         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2115     }
2116 }
2117 
2118 
2119 // File contracts/LimitOrderProtocol.sol
2120 
2121 
2122 pragma solidity ^0.8.0;
2123 
2124 
2125 /// @title 1inch Limit Order Protocol v1
2126 contract LimitOrderProtocol is
2127     ImmutableOwner(address(this)),
2128     EIP712("1inch Limit Order Protocol", "1"),
2129     AmountCalculator,
2130     ChainlinkCalculator,
2131     ERC1155Proxy,
2132     ERC20Proxy,
2133     ERC721Proxy,
2134     NonceManager,
2135     PredicateHelper
2136 {
2137     using SafeMath for uint256;
2138     using SafeERC20 for IERC20;
2139     using UncheckedAddress for address;
2140     using ArgumentsDecoder for bytes;
2141 
2142     // Expiration Mask:
2143     //   predicate := PredicateHelper.timestampBelow(deadline)
2144     //
2145     // Maker Nonce:
2146     //   predicate := this.nonceEquals(makerAddress, makerNonce)
2147 
2148     event OrderFilled(
2149         address indexed maker,
2150         bytes32 orderHash,
2151         uint256 remaining
2152     );
2153 
2154     event OrderFilledRFQ(
2155         bytes32 orderHash,
2156         uint256 makingAmount
2157     );
2158 
2159     struct OrderRFQ {
2160         uint256 info;
2161         address makerAsset;
2162         address takerAsset;
2163         bytes makerAssetData; // (transferFrom.selector, signer, ______, makerAmount, ...)
2164         bytes takerAssetData; // (transferFrom.selector, sender, signer, takerAmount, ...)
2165     }
2166 
2167     struct Order {
2168         uint256 salt;
2169         address makerAsset;
2170         address takerAsset;
2171         bytes makerAssetData; // (transferFrom.selector, signer, ______, makerAmount, ...)
2172         bytes takerAssetData; // (transferFrom.selector, sender, signer, takerAmount, ...)
2173         bytes getMakerAmount; // this.staticcall(abi.encodePacked(bytes, swapTakerAmount)) => (swapMakerAmount)
2174         bytes getTakerAmount; // this.staticcall(abi.encodePacked(bytes, swapMakerAmount)) => (swapTakerAmount)
2175         bytes predicate;      // this.staticcall(bytes) => (bool)
2176         bytes permit;         // On first fill: permit.1.call(abi.encodePacked(permit.selector, permit.2))
2177         bytes interaction;
2178     }
2179 
2180     bytes32 constant public LIMIT_ORDER_TYPEHASH = keccak256(
2181         "Order(uint256 salt,address makerAsset,address takerAsset,bytes makerAssetData,bytes takerAssetData,bytes getMakerAmount,bytes getTakerAmount,bytes predicate,bytes permit,bytes interaction)"
2182     );
2183 
2184     bytes32 constant public LIMIT_ORDER_RFQ_TYPEHASH = keccak256(
2185         "OrderRFQ(uint256 info,address makerAsset,address takerAsset,bytes makerAssetData,bytes takerAssetData)"
2186     );
2187 
2188     // solhint-disable-next-line var-name-mixedcase
2189     bytes4 immutable private _MAX_SELECTOR = bytes4(uint32(IERC20.transferFrom.selector) + 10);
2190 
2191     uint256 constant private _FROM_INDEX = 0;
2192     uint256 constant private _TO_INDEX = 1;
2193     uint256 constant private _AMOUNT_INDEX = 2;
2194 
2195     mapping(bytes32 => uint256) private _remaining;
2196     mapping(address => mapping(uint256 => uint256)) private _invalidator;
2197 
2198     // solhint-disable-next-line func-name-mixedcase
2199     function DOMAIN_SEPARATOR() external view returns(bytes32) {
2200         return _domainSeparatorV4();
2201     }
2202 
2203     /// @notice Returns unfilled amount for order. Throws if order does not exist
2204     function remaining(bytes32 orderHash) external view returns(uint256) {
2205         return _remaining[orderHash].sub(1, "LOP: Unknown order");
2206     }
2207 
2208     /// @notice Returns unfilled amount for order
2209     /// @return Unfilled amount of order plus one if order exists. Otherwise 0
2210     function remainingRaw(bytes32 orderHash) external view returns(uint256) {
2211         return _remaining[orderHash];
2212     }
2213 
2214     /// @notice Same as `remainingRaw` but for multiple orders
2215     function remainingsRaw(bytes32[] memory orderHashes) external view returns(uint256[] memory results) {
2216         results = new uint256[](orderHashes.length);
2217         for (uint i = 0; i < orderHashes.length; i++) {
2218             results[i] = _remaining[orderHashes[i]];
2219         }
2220     }
2221 
2222     /// @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
2223     /// @return Each bit represents whenever corresponding quote was filled
2224     function invalidatorForOrderRFQ(address maker, uint256 slot) external view returns(uint256) {
2225         return _invalidator[maker][slot];
2226     }
2227 
2228     /// @notice Checks order predicate
2229     function checkPredicate(Order memory order) public view returns(bool) {
2230         bytes memory result = address(this).uncheckedFunctionStaticCall(order.predicate, "LOP: predicate call failed");
2231         require(result.length == 32, "LOP: invalid predicate return");
2232         return abi.decode(result, (bool));
2233     }
2234 
2235     /**
2236      * @notice Calls every target with corresponding data. Then reverts with CALL_RESULTS_0101011 where zeroes and ones
2237      * denote failure or success of the corresponding call
2238      */
2239     /**
2240      * @param targets Array of functions. Each function is expected to take a corresponding `data` argument
2241      * as parameter and return bool
2242      */
2243     function simulateCalls(address[] calldata targets, bytes[] calldata data) external {
2244         require(targets.length == data.length, "LOP: array size mismatch");
2245         bytes memory reason = new bytes(targets.length);
2246         for (uint i = 0; i < targets.length; i++) {
2247             // solhint-disable-next-line avoid-low-level-calls
2248             (bool success, bytes memory result) = targets[i].call(data[i]);
2249             if (success && result.length > 0) {
2250                 success = abi.decode(result, (bool));
2251             }
2252             reason[i] = success ? bytes1("1") : bytes1("0");
2253         }
2254 
2255         // Always revert and provide per call results
2256         revert(string(abi.encodePacked("CALL_RESULTS_", reason)));
2257     }
2258 
2259     /// @notice Cancels order by setting remaining amount to zero
2260     function cancelOrder(Order memory order) external {
2261         require(order.makerAssetData.decodeAddress(_FROM_INDEX) == msg.sender, "LOP: Access denied");
2262 
2263         bytes32 orderHash = _hash(order);
2264         _remaining[orderHash] = 1;
2265         emit OrderFilled(msg.sender, orderHash, 0);
2266     }
2267 
2268     /// @notice Cancels order's quote
2269     function cancelOrderRFQ(uint256 orderInfo) external {
2270         _invalidator[msg.sender][uint64(orderInfo) >> 8] |= (1 << (orderInfo & 0xff));
2271     }
2272 
2273     /// @notice Fills order's quote, fully or partially (whichever is possible)
2274     /// @param order Order quote to fill
2275     /// @param signature Signature to confirm quote ownership
2276     /// @param makingAmount Making amount
2277     /// @param takingAmount Taking amount
2278     function fillOrderRFQ(OrderRFQ memory order, bytes memory signature, uint256 makingAmount, uint256 takingAmount) external {
2279         // Check time expiration
2280         uint256 expiration = uint128(order.info) >> 64;
2281         require(expiration == 0 || block.timestamp <= expiration, "LOP: order expired");  // solhint-disable-line not-rely-on-time
2282 
2283         // Validate double spend
2284         address maker = order.makerAssetData.decodeAddress(_FROM_INDEX);
2285         uint256 invalidatorSlot = uint64(order.info) >> 8;
2286         uint256 invalidatorBit = 1 << uint8(order.info);
2287         uint256 invalidator = _invalidator[maker][invalidatorSlot];
2288         require(invalidator & invalidatorBit == 0, "LOP: already filled");
2289         _invalidator[maker][invalidatorSlot] = invalidator | invalidatorBit;
2290 
2291         // Compute partial fill if needed
2292         uint256 orderMakerAmount = order.makerAssetData.decodeUint256(_AMOUNT_INDEX);
2293         uint256 orderTakerAmount = order.takerAssetData.decodeUint256(_AMOUNT_INDEX);
2294         if (takingAmount == 0 && makingAmount == 0) {
2295             // Two zeros means whole order
2296             makingAmount = orderMakerAmount;
2297             takingAmount = orderTakerAmount;
2298         }
2299         else if (takingAmount == 0) {
2300             takingAmount = (makingAmount * orderTakerAmount + orderMakerAmount - 1) / orderMakerAmount;
2301         }
2302         else if (makingAmount == 0) {
2303             makingAmount = takingAmount * orderMakerAmount / orderTakerAmount;
2304         }
2305         else {
2306             revert("LOP: one of amounts should be 0");
2307         }
2308 
2309         require(makingAmount > 0 && takingAmount > 0, "LOP: can't swap 0 amount");
2310         require(makingAmount <= orderMakerAmount, "LOP: making amount exceeded");
2311         require(takingAmount <= orderTakerAmount, "LOP: taking amount exceeded");
2312 
2313         // Validate order
2314         bytes32 orderHash = _hash(order);
2315         _validate(order.makerAssetData, order.takerAssetData, signature, orderHash);
2316 
2317         // Maker => Taker, Taker => Maker
2318         _callMakerAssetTransferFrom(order.makerAsset, order.makerAssetData, msg.sender, makingAmount);
2319         _callTakerAssetTransferFrom(order.takerAsset, order.takerAssetData, msg.sender, takingAmount);
2320 
2321         emit OrderFilledRFQ(orderHash, makingAmount);
2322     }
2323 
2324     /// @notice Fills an order. If one doesn't exist (first fill) it will be created using order.makerAssetData
2325     function fillOrder(Order memory order, bytes calldata signature, uint256 makingAmount, uint256 takingAmount, uint256 thresholdAmount) external returns(uint256, uint256) {
2326         bytes32 orderHash = _hash(order);
2327 
2328         uint256 remainingMakerAmount;
2329         { // Stack too deep
2330             bool orderExists;
2331             (orderExists, remainingMakerAmount) = _remaining[orderHash].trySub(1);
2332             if (!orderExists) {
2333                 // First fill: validate order and permit maker asset
2334                 _validate(order.makerAssetData, order.takerAssetData, signature, orderHash);
2335                 remainingMakerAmount = order.makerAssetData.decodeUint256(_AMOUNT_INDEX);
2336                 if (order.permit.length > 0) {
2337                     (address token, bytes memory permit) = abi.decode(order.permit, (address, bytes));
2338                     token.uncheckedFunctionCall(abi.encodePacked(IERC20Permit.permit.selector, permit), "LOP: permit failed");
2339                     require(_remaining[orderHash] == 0, "LOP: reentrancy detected");
2340                 }
2341             }
2342         }
2343 
2344         // Check if order is valid
2345         if (order.predicate.length > 0) {
2346             require(checkPredicate(order), "LOP: predicate returned false");
2347         }
2348 
2349         // Compute maker and taker assets amount
2350         if ((takingAmount == 0) == (makingAmount == 0)) {
2351             revert("LOP: only one amount should be 0");
2352         }
2353         else if (takingAmount == 0) {
2354             takingAmount = _callGetTakerAmount(order, makingAmount);
2355             require(takingAmount <= thresholdAmount, "LOP: taking amount too high");
2356         }
2357         else {
2358             makingAmount = _callGetMakerAmount(order, takingAmount);
2359             require(makingAmount >= thresholdAmount, "LOP: making amount too low");
2360         }
2361 
2362         require(makingAmount > 0 && takingAmount > 0, "LOP: can't swap 0 amount");
2363 
2364         // Update remaining amount in storage
2365         remainingMakerAmount = remainingMakerAmount.sub(makingAmount, "LOP: taking > remaining");
2366         _remaining[orderHash] = remainingMakerAmount + 1;
2367         emit OrderFilled(msg.sender, orderHash, remainingMakerAmount);
2368 
2369         // Taker => Maker
2370         _callTakerAssetTransferFrom(order.takerAsset, order.takerAssetData, msg.sender, takingAmount);
2371 
2372         // Maker can handle funds interactively
2373         if (order.interaction.length > 0) {
2374             InteractiveMaker(order.makerAssetData.decodeAddress(_FROM_INDEX))
2375                 .notifyFillOrder(order.makerAsset, order.takerAsset, makingAmount, takingAmount, order.interaction);
2376         }
2377 
2378         // Maker => Taker
2379         _callMakerAssetTransferFrom(order.makerAsset, order.makerAssetData, msg.sender, makingAmount);
2380 
2381         return (makingAmount, takingAmount);
2382     }
2383 
2384     function _hash(Order memory order) internal view returns(bytes32) {
2385         return _hashTypedDataV4(
2386             keccak256(
2387                 abi.encode(
2388                     LIMIT_ORDER_TYPEHASH,
2389                     order.salt,
2390                     order.makerAsset,
2391                     order.takerAsset,
2392                     keccak256(order.makerAssetData),
2393                     keccak256(order.takerAssetData),
2394                     keccak256(order.getMakerAmount),
2395                     keccak256(order.getTakerAmount),
2396                     keccak256(order.predicate),
2397                     keccak256(order.permit),
2398                     keccak256(order.interaction)
2399                 )
2400             )
2401         );
2402     }
2403 
2404     function _hash(OrderRFQ memory order) internal view returns(bytes32) {
2405         return _hashTypedDataV4(
2406             keccak256(
2407                 abi.encode(
2408                     LIMIT_ORDER_RFQ_TYPEHASH,
2409                     order.info,
2410                     order.makerAsset,
2411                     order.takerAsset,
2412                     keccak256(order.makerAssetData),
2413                     keccak256(order.takerAssetData)
2414                 )
2415             )
2416         );
2417     }
2418 
2419     function _validate(bytes memory makerAssetData, bytes memory takerAssetData, bytes memory signature, bytes32 orderHash) internal view {
2420         require(makerAssetData.length >= 100, "LOP: bad makerAssetData.length");
2421         require(takerAssetData.length >= 100, "LOP: bad takerAssetData.length");
2422         bytes4 makerSelector = makerAssetData.decodeSelector();
2423         bytes4 takerSelector = takerAssetData.decodeSelector();
2424         require(makerSelector >= IERC20.transferFrom.selector && makerSelector <= _MAX_SELECTOR, "LOP: bad makerAssetData.selector");
2425         require(takerSelector >= IERC20.transferFrom.selector && takerSelector <= _MAX_SELECTOR, "LOP: bad takerAssetData.selector");
2426 
2427         address maker = address(makerAssetData.decodeAddress(_FROM_INDEX));
2428         if ((signature.length != 65 && signature.length != 64) || SilentECDSA.recover(orderHash, signature) != maker) {
2429             bytes memory result = maker.uncheckedFunctionStaticCall(abi.encodeWithSelector(IERC1271.isValidSignature.selector, orderHash, signature), "LOP: isValidSignature failed");
2430             require(result.length == 32 && abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector, "LOP: bad signature");
2431         }
2432     }
2433 
2434     function _callMakerAssetTransferFrom(address makerAsset, bytes memory makerAssetData, address taker, uint256 makingAmount) internal {
2435         // Patch receiver or validate private order
2436         address orderTakerAddress = makerAssetData.decodeAddress(_TO_INDEX);
2437         if (orderTakerAddress == address(0)) {
2438             makerAssetData.patchAddress(_TO_INDEX, taker);
2439         } else {
2440             require(orderTakerAddress == taker, "LOP: private order");
2441         }
2442 
2443         // Patch maker amount
2444         makerAssetData.patchUint256(_AMOUNT_INDEX, makingAmount);
2445 
2446         // Transfer asset from maker to taker
2447         bytes memory result = makerAsset.uncheckedFunctionCall(makerAssetData, "LOP: makerAsset.call failed");
2448         if (result.length > 0) {
2449             require(abi.decode(result, (bool)), "LOP: makerAsset.call bad result");
2450         }
2451     }
2452 
2453     function _callTakerAssetTransferFrom(address takerAsset, bytes memory takerAssetData, address taker, uint256 takingAmount) internal {
2454         // Patch spender
2455         takerAssetData.patchAddress(_FROM_INDEX, taker);
2456 
2457         // Patch taker amount
2458         takerAssetData.patchUint256(_AMOUNT_INDEX, takingAmount);
2459 
2460         // Transfer asset from taker to maker
2461         bytes memory result = takerAsset.uncheckedFunctionCall(takerAssetData, "LOP: takerAsset.call failed");
2462         if (result.length > 0) {
2463             require(abi.decode(result, (bool)), "LOP: takerAsset.call bad result");
2464         }
2465     }
2466 
2467     function _callGetMakerAmount(Order memory order, uint256 takerAmount) internal view returns(uint256 makerAmount) {
2468         if (order.getMakerAmount.length == 0 && takerAmount == order.takerAssetData.decodeUint256(_AMOUNT_INDEX)) {
2469             // On empty order.getMakerAmount calldata only whole fills are allowed
2470             return order.makerAssetData.decodeUint256(_AMOUNT_INDEX);
2471         }
2472         bytes memory result = address(this).uncheckedFunctionStaticCall(abi.encodePacked(order.getMakerAmount, takerAmount), "LOP: getMakerAmount call failed");
2473         require(result.length == 32, "LOP: invalid getMakerAmount ret");
2474         return abi.decode(result, (uint256));
2475     }
2476 
2477     function _callGetTakerAmount(Order memory order, uint256 makerAmount) internal view returns(uint256 takerAmount) {
2478         if (order.getTakerAmount.length == 0 && makerAmount == order.makerAssetData.decodeUint256(_AMOUNT_INDEX)) {
2479             // On empty order.getTakerAmount calldata only whole fills are allowed
2480             return order.takerAssetData.decodeUint256(_AMOUNT_INDEX);
2481         }
2482         bytes memory result = address(this).uncheckedFunctionStaticCall(abi.encodePacked(order.getTakerAmount, makerAmount), "LOP: getTakerAmount call failed");
2483         require(result.length == 32, "LOP: invalid getTakerAmount ret");
2484         return abi.decode(result, (uint256));
2485     }
2486 }