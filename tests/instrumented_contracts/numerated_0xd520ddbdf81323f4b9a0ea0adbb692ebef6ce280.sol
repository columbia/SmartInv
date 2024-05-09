1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 
33 pragma solidity >=0.6.0 <0.8.0;
34 
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 
113 pragma solidity >=0.6.0 <0.8.0;
114 
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, with an overflow flag.
132      *
133      * _Available since v3.4._
134      */
135     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
136         uint256 c = a + b;
137         if (c < a) return (false, 0);
138         return (true, c);
139     }
140 
141     /**
142      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         if (b > a) return (false, 0);
148         return (true, a - b);
149     }
150 
151     /**
152      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
153      *
154      * _Available since v3.4._
155      */
156     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) return (true, 0);
161         uint256 c = a * b;
162         if (c / a != b) return (false, 0);
163         return (true, c);
164     }
165 
166     /**
167      * @dev Returns the division of two unsigned integers, with a division by zero flag.
168      *
169      * _Available since v3.4._
170      */
171     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
172         if (b == 0) return (false, 0);
173         return (true, a / b);
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         if (b == 0) return (false, 0);
183         return (true, a % b);
184     }
185 
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         uint256 c = a + b;
198         require(c >= a, "SafeMath: addition overflow");
199         return c;
200     }
201 
202     /**
203      * @dev Returns the subtraction of two unsigned integers, reverting on
204      * overflow (when the result is negative).
205      *
206      * Counterpart to Solidity's `-` operator.
207      *
208      * Requirements:
209      *
210      * - Subtraction cannot overflow.
211      */
212     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
213         require(b <= a, "SafeMath: subtraction overflow");
214         return a - b;
215     }
216 
217     /**
218      * @dev Returns the multiplication of two unsigned integers, reverting on
219      * overflow.
220      *
221      * Counterpart to Solidity's `*` operator.
222      *
223      * Requirements:
224      *
225      * - Multiplication cannot overflow.
226      */
227     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
228         if (a == 0) return 0;
229         uint256 c = a * b;
230         require(c / a == b, "SafeMath: multiplication overflow");
231         return c;
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers, reverting on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b > 0, "SafeMath: division by zero");
248         return a / b;
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * reverting when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
264         require(b > 0, "SafeMath: modulo by zero");
265         return a % b;
266     }
267 
268     /**
269      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
270      * overflow (when the result is negative).
271      *
272      * CAUTION: This function is deprecated because it requires allocating memory for the error
273      * message unnecessarily. For custom revert reasons use {trySub}.
274      *
275      * Counterpart to Solidity's `-` operator.
276      *
277      * Requirements:
278      *
279      * - Subtraction cannot overflow.
280      */
281     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
282         require(b <= a, errorMessage);
283         return a - b;
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * CAUTION: This function is deprecated because it requires allocating memory for the error
291      * message unnecessarily. For custom revert reasons use {tryDiv}.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
302         require(b > 0, errorMessage);
303         return a / b;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * reverting with custom message when dividing by zero.
309      *
310      * CAUTION: This function is deprecated because it requires allocating memory for the error
311      * message unnecessarily. For custom revert reasons use {tryMod}.
312      *
313      * Counterpart to Solidity's `%` operator. This function uses a `revert`
314      * opcode (which leaves remaining gas untouched) while Solidity uses an
315      * invalid opcode to revert (consuming all remaining gas).
316      *
317      * Requirements:
318      *
319      * - The divisor cannot be zero.
320      */
321     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
322         require(b > 0, errorMessage);
323         return a % b;
324     }
325 }
326 
327 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
328 
329 
330 pragma solidity >=0.6.0 <0.8.0;
331 
332 
333 /**
334  * @dev Implementation of the {IERC20} interface.
335  *
336  * This implementation is agnostic to the way tokens are created. This means
337  * that a supply mechanism has to be added in a derived contract using {_mint}.
338  * For a generic mechanism see {ERC20PresetMinterPauser}.
339  *
340  * TIP: For a detailed writeup see our guide
341  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
342  * to implement supply mechanisms].
343  *
344  * We have followed general OpenZeppelin guidelines: functions revert instead
345  * of returning `false` on failure. This behavior is nonetheless conventional
346  * and does not conflict with the expectations of ERC20 applications.
347  *
348  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
349  * This allows applications to reconstruct the allowance for all accounts just
350  * by listening to said events. Other implementations of the EIP may not emit
351  * these events, as it isn't required by the specification.
352  *
353  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
354  * functions have been added to mitigate the well-known issues around setting
355  * allowances. See {IERC20-approve}.
356  */
357 contract ERC20 is Context, IERC20 {
358     using SafeMath for uint256;
359 
360     mapping (address => uint256) private _balances;
361 
362     mapping (address => mapping (address => uint256)) private _allowances;
363 
364     uint256 private _totalSupply;
365 
366     string private _name;
367     string private _symbol;
368     uint8 private _decimals;
369 
370     /**
371      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
372      * a default value of 18.
373      *
374      * To select a different value for {decimals}, use {_setupDecimals}.
375      *
376      * All three of these values are immutable: they can only be set once during
377      * construction.
378      */
379     constructor (string memory name_, string memory symbol_) public {
380         _name = name_;
381         _symbol = symbol_;
382         _decimals = 18;
383     }
384 
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() public view virtual returns (string memory) {
389         return _name;
390     }
391 
392     /**
393      * @dev Returns the symbol of the token, usually a shorter version of the
394      * name.
395      */
396     function symbol() public view virtual returns (string memory) {
397         return _symbol;
398     }
399 
400     /**
401      * @dev Returns the number of decimals used to get its user representation.
402      * For example, if `decimals` equals `2`, a balance of `505` tokens should
403      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
404      *
405      * Tokens usually opt for a value of 18, imitating the relationship between
406      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
407      * called.
408      *
409      * NOTE: This information is only used for _display_ purposes: it in
410      * no way affects any of the arithmetic of the contract, including
411      * {IERC20-balanceOf} and {IERC20-transfer}.
412      */
413     function decimals() public view virtual returns (uint8) {
414         return _decimals;
415     }
416 
417     /**
418      * @dev See {IERC20-totalSupply}.
419      */
420     function totalSupply() public view virtual override returns (uint256) {
421         return _totalSupply;
422     }
423 
424     /**
425      * @dev See {IERC20-balanceOf}.
426      */
427     function balanceOf(address account) public view virtual override returns (uint256) {
428         return _balances[account];
429     }
430 
431     /**
432      * @dev See {IERC20-transfer}.
433      *
434      * Requirements:
435      *
436      * - `recipient` cannot be the zero address.
437      * - the caller must have a balance of at least `amount`.
438      */
439     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
440         _transfer(_msgSender(), recipient, amount);
441         return true;
442     }
443 
444     /**
445      * @dev See {IERC20-allowance}.
446      */
447     function allowance(address owner, address spender) public view virtual override returns (uint256) {
448         return _allowances[owner][spender];
449     }
450 
451     /**
452      * @dev See {IERC20-approve}.
453      *
454      * Requirements:
455      *
456      * - `spender` cannot be the zero address.
457      */
458     function approve(address spender, uint256 amount) public virtual override returns (bool) {
459         _approve(_msgSender(), spender, amount);
460         return true;
461     }
462 
463     /**
464      * @dev See {IERC20-transferFrom}.
465      *
466      * Emits an {Approval} event indicating the updated allowance. This is not
467      * required by the EIP. See the note at the beginning of {ERC20}.
468      *
469      * Requirements:
470      *
471      * - `sender` and `recipient` cannot be the zero address.
472      * - `sender` must have a balance of at least `amount`.
473      * - the caller must have allowance for ``sender``'s tokens of at least
474      * `amount`.
475      */
476     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
477         _transfer(sender, recipient, amount);
478         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically increases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to {approve} that can be used as a mitigation for
486      * problems described in {IERC20-approve}.
487      *
488      * Emits an {Approval} event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      */
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496         return true;
497     }
498 
499     /**
500      * @dev Atomically decreases the allowance granted to `spender` by the caller.
501      *
502      * This is an alternative to {approve} that can be used as a mitigation for
503      * problems described in {IERC20-approve}.
504      *
505      * Emits an {Approval} event indicating the updated allowance.
506      *
507      * Requirements:
508      *
509      * - `spender` cannot be the zero address.
510      * - `spender` must have allowance for the caller of at least
511      * `subtractedValue`.
512      */
513     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
514         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
515         return true;
516     }
517 
518     /**
519      * @dev Moves tokens `amount` from `sender` to `recipient`.
520      *
521      * This is internal function is equivalent to {transfer}, and can be used to
522      * e.g. implement automatic token fees, slashing mechanisms, etc.
523      *
524      * Emits a {Transfer} event.
525      *
526      * Requirements:
527      *
528      * - `sender` cannot be the zero address.
529      * - `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      */
532     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
533         require(sender != address(0), "ERC20: transfer from the zero address");
534         require(recipient != address(0), "ERC20: transfer to the zero address");
535 
536         _beforeTokenTransfer(sender, recipient, amount);
537 
538         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
539         _balances[recipient] = _balances[recipient].add(amount);
540         emit Transfer(sender, recipient, amount);
541     }
542 
543     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
544      * the total supply.
545      *
546      * Emits a {Transfer} event with `from` set to the zero address.
547      *
548      * Requirements:
549      *
550      * - `to` cannot be the zero address.
551      */
552     function _mint(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: mint to the zero address");
554 
555         _beforeTokenTransfer(address(0), account, amount);
556 
557         _totalSupply = _totalSupply.add(amount);
558         _balances[account] = _balances[account].add(amount);
559         emit Transfer(address(0), account, amount);
560     }
561 
562     /**
563      * @dev Destroys `amount` tokens from `account`, reducing the
564      * total supply.
565      *
566      * Emits a {Transfer} event with `to` set to the zero address.
567      *
568      * Requirements:
569      *
570      * - `account` cannot be the zero address.
571      * - `account` must have at least `amount` tokens.
572      */
573     function _burn(address account, uint256 amount) internal virtual {
574         require(account != address(0), "ERC20: burn from the zero address");
575 
576         _beforeTokenTransfer(account, address(0), amount);
577 
578         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
579         _totalSupply = _totalSupply.sub(amount);
580         emit Transfer(account, address(0), amount);
581     }
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
585      *
586      * This internal function is equivalent to `approve`, and can be used to
587      * e.g. set automatic allowances for certain subsystems, etc.
588      *
589      * Emits an {Approval} event.
590      *
591      * Requirements:
592      *
593      * - `owner` cannot be the zero address.
594      * - `spender` cannot be the zero address.
595      */
596     function _approve(address owner, address spender, uint256 amount) internal virtual {
597         require(owner != address(0), "ERC20: approve from the zero address");
598         require(spender != address(0), "ERC20: approve to the zero address");
599 
600         _allowances[owner][spender] = amount;
601         emit Approval(owner, spender, amount);
602     }
603 
604     /**
605      * @dev Sets {decimals} to a value other than the default one of 18.
606      *
607      * WARNING: This function should only be called from the constructor. Most
608      * applications that interact with token contracts will not expect
609      * {decimals} to ever change, and may work incorrectly if it does.
610      */
611     function _setupDecimals(uint8 decimals_) internal virtual {
612         _decimals = decimals_;
613     }
614 
615     /**
616      * @dev Hook that is called before any transfer of tokens. This includes
617      * minting and burning.
618      *
619      * Calling conditions:
620      *
621      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
622      * will be to transferred to `to`.
623      * - when `from` is zero, `amount` tokens will be minted for `to`.
624      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
625      * - `from` and `to` are never both zero.
626      *
627      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
628      */
629     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
630 }
631 
632 // File: @openzeppelin/contracts/drafts/IERC20Permit.sol
633 
634 
635 pragma solidity >=0.6.0 <0.8.0;
636 
637 
638 /**
639  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
640  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
641  *
642  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
643  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
644  * need to send a transaction, and thus is not required to hold Ether at all.
645  */
646 interface IERC20Permit {
647     /**
648      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
649      * given `owner`'s signed approval.
650      *
651      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
652      * ordering also apply here.
653      *
654      * Emits an {Approval} event.
655      *
656      * Requirements:
657      *
658      * - `spender` cannot be the zero address.
659      * - `deadline` must be a timestamp in the future.
660      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
661      * over the EIP712-formatted function arguments.
662      * - the signature must use ``owner``'s current nonce (see {nonces}).
663      *
664      * For more information on the signature format, see the
665      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
666      * section].
667      */
668     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
669 
670     /**
671      * @dev Returns the current nonce for `owner`. This value must be
672      * included whenever a signature is generated for {permit}.
673      *
674      * Every successful call to {permit} increases ``owner``'s nonce by one. This
675      * prevents a signature from being used multiple times.
676      */
677     function nonces(address owner) external view returns (uint256);
678 
679     /**
680      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
681      */
682     // solhint-disable-next-line func-name-mixedcase
683     function DOMAIN_SEPARATOR() external view returns (bytes32);
684 }
685 
686 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
687 
688 
689 pragma solidity >=0.6.0 <0.8.0;
690 
691 
692 /**
693  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
694  *
695  * These functions can be used to verify that a message was signed by the holder
696  * of the private keys of a given address.
697  */
698 library ECDSA {
699     /**
700      * @dev Returns the address that signed a hashed message (`hash`) with
701      * `signature`. This address can then be used for verification purposes.
702      *
703      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
704      * this function rejects them by requiring the `s` value to be in the lower
705      * half order, and the `v` value to be either 27 or 28.
706      *
707      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
708      * verification to be secure: it is possible to craft signatures that
709      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
710      * this is by receiving a hash of the original message (which may otherwise
711      * be too long), and then calling {toEthSignedMessageHash} on it.
712      */
713     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
714         // Check the signature length
715         if (signature.length != 65) {
716             revert("ECDSA: invalid signature length");
717         }
718 
719         // Divide the signature in r, s and v variables
720         bytes32 r;
721         bytes32 s;
722         uint8 v;
723 
724         // ecrecover takes the signature parameters, and the only way to get them
725         // currently is to use assembly.
726         // solhint-disable-next-line no-inline-assembly
727         assembly {
728             r := mload(add(signature, 0x20))
729             s := mload(add(signature, 0x40))
730             v := byte(0, mload(add(signature, 0x60)))
731         }
732 
733         return recover(hash, v, r, s);
734     }
735 
736     /**
737      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
738      * `r` and `s` signature fields separately.
739      */
740     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
741         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
742         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
743         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
744         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
745         //
746         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
747         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
748         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
749         // these malleable signatures as well.
750         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
751         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
752 
753         // If the signature is valid (and not malleable), return the signer address
754         address signer = ecrecover(hash, v, r, s);
755         require(signer != address(0), "ECDSA: invalid signature");
756 
757         return signer;
758     }
759 
760     /**
761      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
762      * replicates the behavior of the
763      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
764      * JSON-RPC method.
765      *
766      * See {recover}.
767      */
768     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
769         // 32 is the length in bytes of hash,
770         // enforced by the type signature above
771         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
772     }
773 }
774 
775 // File: @openzeppelin/contracts/utils/Counters.sol
776 
777 
778 pragma solidity >=0.6.0 <0.8.0;
779 
780 
781 /**
782  * @title Counters
783  * @author Matt Condon (@shrugs)
784  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
785  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
786  *
787  * Include with `using Counters for Counters.Counter;`
788  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
789  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
790  * directly accessed.
791  */
792 library Counters {
793     using SafeMath for uint256;
794 
795     struct Counter {
796         // This variable should never be directly accessed by users of the library: interactions must be restricted to
797         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
798         // this feature: see https://github.com/ethereum/solidity/issues/4637
799         uint256 _value; // default: 0
800     }
801 
802     function current(Counter storage counter) internal view returns (uint256) {
803         return counter._value;
804     }
805 
806     function increment(Counter storage counter) internal {
807         // The {SafeMath} overflow check can be skipped here, see the comment at the top
808         counter._value += 1;
809     }
810 
811     function decrement(Counter storage counter) internal {
812         counter._value = counter._value.sub(1);
813     }
814 }
815 
816 // File: @openzeppelin/contracts/drafts/EIP712.sol
817 
818 
819 pragma solidity >=0.6.0 <0.8.0;
820 
821 
822 /**
823  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
824  *
825  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
826  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
827  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
828  *
829  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
830  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
831  * ({_hashTypedDataV4}).
832  *
833  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
834  * the chain id to protect against replay attacks on an eventual fork of the chain.
835  *
836  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
837  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
838  *
839  * _Available since v3.4._
840  */
841 abstract contract EIP712 {
842     /* solhint-disable var-name-mixedcase */
843     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
844     // invalidate the cached domain separator if the chain id changes.
845     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
846     uint256 private immutable _CACHED_CHAIN_ID;
847 
848     bytes32 private immutable _HASHED_NAME;
849     bytes32 private immutable _HASHED_VERSION;
850     bytes32 private immutable _TYPE_HASH;
851     /* solhint-enable var-name-mixedcase */
852 
853     /**
854      * @dev Initializes the domain separator and parameter caches.
855      *
856      * The meaning of `name` and `version` is specified in
857      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
858      *
859      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
860      * - `version`: the current major version of the signing domain.
861      *
862      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
863      * contract upgrade].
864      */
865     constructor(string memory name, string memory version) internal {
866         bytes32 hashedName = keccak256(bytes(name));
867         bytes32 hashedVersion = keccak256(bytes(version));
868         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
869         _HASHED_NAME = hashedName;
870         _HASHED_VERSION = hashedVersion;
871         _CACHED_CHAIN_ID = _getChainId();
872         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
873         _TYPE_HASH = typeHash;
874     }
875 
876     /**
877      * @dev Returns the domain separator for the current chain.
878      */
879     function _domainSeparatorV4() internal view virtual returns (bytes32) {
880         if (_getChainId() == _CACHED_CHAIN_ID) {
881             return _CACHED_DOMAIN_SEPARATOR;
882         } else {
883             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
884         }
885     }
886 
887     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
888         return keccak256(
889             abi.encode(
890                 typeHash,
891                 name,
892                 version,
893                 _getChainId(),
894                 address(this)
895             )
896         );
897     }
898 
899     /**
900      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
901      * function returns the hash of the fully encoded EIP712 message for this domain.
902      *
903      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
904      *
905      * ```solidity
906      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
907      *     keccak256("Mail(address to,string contents)"),
908      *     mailTo,
909      *     keccak256(bytes(mailContents))
910      * )));
911      * address signer = ECDSA.recover(digest, signature);
912      * ```
913      */
914     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
915         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
916     }
917 
918     function _getChainId() private view returns (uint256 chainId) {
919         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
920         // solhint-disable-next-line no-inline-assembly
921         assembly {
922             chainId := chainid()
923         }
924     }
925 }
926 
927 // File: @openzeppelin/contracts/drafts/ERC20Permit.sol
928 
929 
930 pragma solidity >=0.6.5 <0.8.0;
931 
932 
933 /**
934  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
935  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
936  *
937  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
938  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
939  * need to send a transaction, and thus is not required to hold Ether at all.
940  *
941  * _Available since v3.4._
942  */
943 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
944     using Counters for Counters.Counter;
945 
946     mapping (address => Counters.Counter) private _nonces;
947 
948     // solhint-disable-next-line var-name-mixedcase
949     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
950 
951     /**
952      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
953      *
954      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
955      */
956     constructor(string memory name) internal EIP712(name, "1") {
957     }
958 
959     /**
960      * @dev See {IERC20Permit-permit}.
961      */
962     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
963         // solhint-disable-next-line not-rely-on-time
964         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
965 
966         bytes32 structHash = keccak256(
967             abi.encode(
968                 _PERMIT_TYPEHASH,
969                 owner,
970                 spender,
971                 value,
972                 _nonces[owner].current(),
973                 deadline
974             )
975         );
976 
977         bytes32 hash = _hashTypedDataV4(structHash);
978 
979         address signer = ECDSA.recover(hash, v, r, s);
980         require(signer == owner, "ERC20Permit: invalid signature");
981 
982         _nonces[owner].increment();
983         _approve(owner, spender, value);
984     }
985 
986     /**
987      * @dev See {IERC20Permit-nonces}.
988      */
989     function nonces(address owner) public view override returns (uint256) {
990         return _nonces[owner].current();
991     }
992 
993     /**
994      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
995      */
996     // solhint-disable-next-line func-name-mixedcase
997     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
998         return _domainSeparatorV4();
999     }
1000 }
1001 
1002 // File: contracts/HLD.sol
1003 
1004 
1005 pragma solidity 0.6.12;
1006 
1007 
1008 contract HLD is ERC20Permit {
1009     constructor() public ERC20("Holdefi Token", "HLD") ERC20Permit("Holdefi Token") {
1010         _mint(_msgSender(), 100000000 ether);
1011     }
1012 
1013     // Taking ideas from Compound:
1014     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
1015 
1016     /// @notice A record of states for signing / validating signatures
1017     mapping (address => Counters.Counter) public delegateNonces;
1018 
1019     /// @dev A record of each accounts delegate
1020     mapping (address => address) public delegates;
1021 
1022     /// @notice A checkpoint for marking number of votes from a given block
1023     struct Checkpoint {
1024         uint32 fromBlock;
1025         uint256 votes;
1026     }
1027 
1028     /// @notice A record of votes checkpoints for each account, by index
1029     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
1030 
1031     /// @notice The number of checkpoints for each account
1032     mapping (address => uint32) public numCheckpoints;
1033 
1034     // solhint-disable-next-line var-name-mixedcase
1035     bytes32 private immutable DELEGATION_TYPEHASH = keccak256("Delegation(address delegator,address delegatee,uint256 nonce,uint256 expiry)");
1036 
1037     /// @notice An event thats emitted when an account changes its delegate
1038     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1039 
1040     /// @notice An event thats emitted when a delegate account's vote balance changes
1041     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1042 
1043     /**
1044      * ERC20 modified transferFrom that also update the avgPrice paid for the recipient and
1045      * updates user gov idx
1046      *
1047      * @param sender : sender account
1048      * @param recipient : recipient account
1049      * @param amount : value to transfer
1050      * @return : flag whether transfer was successful or not
1051      */
1052     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1053       _transfer(sender, recipient, amount);
1054       _approve(sender, msg.sender, allowance(sender, msg.sender).sub(amount, "ERC20: transfer amount exceeds allowance"));
1055       _moveDelegates(delegates[sender], delegates[recipient], amount);
1056       return true;
1057     }
1058 
1059     /**
1060      * ERC20 modified transfer that also update the delegates
1061      *
1062      * @param recipient : recipient account
1063      * @param amount : value to transfer
1064      * @return : flag whether transfer was successful or not
1065      */
1066     function transfer(address recipient, uint256 amount) public override returns (bool) {
1067       _transfer(msg.sender, recipient, amount);
1068       _moveDelegates(delegates[msg.sender], delegates[recipient], amount);
1069       return true;
1070     }
1071 
1072    /**
1073     * @notice Delegate votes from `msg.sender` to `delegatee`
1074     * @param delegatee The address to delegate votes to
1075     */
1076     function delegate(address delegatee) external {
1077         _delegate(msg.sender, delegatee);
1078     }
1079 
1080     /**
1081      * @notice Delegates votes from signatory to `delegatee`
1082      * @param delegator The address which delegates votes  
1083      * @param delegatee The address to delegate votes to
1084      * @param expiry The time at which to expire the signature
1085      * @param v The recovery byte of the signature
1086      * @param r Half of the ECDSA signature pair
1087      * @param s Half of the ECDSA signature pair
1088      */
1089     function delegateBySig(address delegator, address delegatee, uint expiry, uint8 v, bytes32 r, bytes32 s) external {
1090         require(block.timestamp <= expiry, "HLD::delegateBySig: signature expired");
1091 
1092         bytes32 structHash = keccak256(
1093             abi.encode(
1094                 DELEGATION_TYPEHASH,
1095                 delegator,
1096                 delegatee,
1097                 delegateNonces[delegator].current(),
1098                 expiry
1099             )
1100         );
1101 
1102         bytes32 hash = _hashTypedDataV4(structHash);
1103         
1104         address signer = ECDSA.recover(hash, v, r, s);
1105         require(signer == delegator, "HLD::delegateBySig: invalid signature");
1106         
1107         delegateNonces[delegator].increment();
1108         _delegate(delegator, delegatee);
1109     }
1110 
1111     /**
1112      * @notice Gets the current votes balance for `account`
1113      * @param account The address to get votes balance
1114      * @return The number of current votes for `account`
1115      */
1116     function getCurrentVotes(address account) external view returns (uint256) {
1117         uint32 nCheckpoints = numCheckpoints[account];
1118         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1119     }
1120 
1121     /**
1122      * @notice Determine the prior number of votes for an account as of a block number
1123      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1124      * @param account The address of the account to check
1125      * @param blockNumber The block number to get the vote balance at
1126      * @return The number of votes the account had as of the given block
1127      */
1128     function getPriorVotes(address account, uint blockNumber) external view returns (uint256) {
1129         require(blockNumber < block.number, "HLD::getPriorVotes: not yet determined");
1130 
1131         uint32 nCheckpoints = numCheckpoints[account];
1132         if (nCheckpoints == 0) {
1133             return 0;
1134         }
1135 
1136         // First check most recent balance
1137         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1138             return checkpoints[account][nCheckpoints - 1].votes;
1139         }
1140 
1141         // Next check implicit zero balance
1142         if (checkpoints[account][0].fromBlock > blockNumber) {
1143             return 0;
1144         }
1145 
1146         uint32 lower = 0;
1147         uint32 upper = nCheckpoints - 1;
1148         while (upper > lower) {
1149             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1150             Checkpoint memory cp = checkpoints[account][center];
1151             if (cp.fromBlock == blockNumber) {
1152                 return cp.votes;
1153             } else if (cp.fromBlock < blockNumber) {
1154                 lower = center;
1155             } else {
1156                 upper = center - 1;
1157             }
1158         }
1159         return checkpoints[account][lower].votes;
1160     }
1161 
1162     function _delegate(address delegator, address delegatee) internal {
1163         address currentDelegate = delegates[delegator];
1164         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying HLDs (not scaled);
1165         delegates[delegator] = delegatee;
1166 
1167         emit DelegateChanged(delegator, currentDelegate, delegatee);
1168 
1169         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1170     }
1171 
1172     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1173         if (srcRep != dstRep && amount > 0) {
1174             if (srcRep != address(0)) {
1175                 // decrease old representative
1176                 uint32 srcRepNum = numCheckpoints[srcRep];
1177                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1178                 uint256 srcRepNew = srcRepOld.sub(amount);
1179                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1180             }
1181 
1182             if (dstRep != address(0)) {
1183                 // increase new representative
1184                 uint32 dstRepNum = numCheckpoints[dstRep];
1185                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1186                 uint256 dstRepNew = dstRepOld.add(amount);
1187                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1188             }
1189         }
1190     }
1191 
1192     function _writeCheckpoint(address delegatee, uint32 nCheckpoints, uint256 oldVotes, uint256 newVotes) internal {
1193         uint32 blockNumber = safe32(block.number, "HLD::_writeCheckpoint: block number exceeds 32 bits");
1194 
1195         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1196             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1197         } else {
1198             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1199             numCheckpoints[delegatee] = nCheckpoints + 1;
1200         }
1201 
1202         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1203     }
1204 
1205     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1206         require(n < 2**32, errorMessage);
1207         return uint32(n);
1208     }
1209 }