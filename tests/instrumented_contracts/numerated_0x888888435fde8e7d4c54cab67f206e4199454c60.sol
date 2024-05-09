1 // Sources flattened with hardhat v2.0.7 https://hardhat.org
2 
3 // SPDX-License-Identifier: MIT
4 
5 
6 pragma solidity >=0.6.0 <0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.3.0
31 
32 
33 
34 pragma solidity >=0.6.0 <0.8.0;
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
110 
111 // File @openzeppelin/contracts/math/SafeMath.sol@v3.3.0
112 
113 
114 
115 pragma solidity >=0.6.0 <0.8.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
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
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 
274 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.3.0
275 
276 
277 
278 pragma solidity >=0.6.0 <0.8.0;
279 
280 
281 
282 /**
283  * @dev Implementation of the {IERC20} interface.
284  *
285  * This implementation is agnostic to the way tokens are created. This means
286  * that a supply mechanism has to be added in a derived contract using {_mint}.
287  * For a generic mechanism see {ERC20PresetMinterPauser}.
288  *
289  * TIP: For a detailed writeup see our guide
290  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
291  * to implement supply mechanisms].
292  *
293  * We have followed general OpenZeppelin guidelines: functions revert instead
294  * of returning `false` on failure. This behavior is nonetheless conventional
295  * and does not conflict with the expectations of ERC20 applications.
296  *
297  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
298  * This allows applications to reconstruct the allowance for all accounts just
299  * by listening to said events. Other implementations of the EIP may not emit
300  * these events, as it isn't required by the specification.
301  *
302  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
303  * functions have been added to mitigate the well-known issues around setting
304  * allowances. See {IERC20-approve}.
305  */
306 contract ERC20 is Context, IERC20 {
307     using SafeMath for uint256;
308 
309     mapping (address => uint256) private _balances;
310 
311     mapping (address => mapping (address => uint256)) private _allowances;
312 
313     uint256 private _totalSupply;
314 
315     string private _name;
316     string private _symbol;
317     uint8 private _decimals;
318 
319     /**
320      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
321      * a default value of 18.
322      *
323      * To select a different value for {decimals}, use {_setupDecimals}.
324      *
325      * All three of these values are immutable: they can only be set once during
326      * construction.
327      */
328     constructor (string memory name_, string memory symbol_) public {
329         _name = name_;
330         _symbol = symbol_;
331         _decimals = 18;
332     }
333 
334     /**
335      * @dev Returns the name of the token.
336      */
337     function name() public view returns (string memory) {
338         return _name;
339     }
340 
341     /**
342      * @dev Returns the symbol of the token, usually a shorter version of the
343      * name.
344      */
345     function symbol() public view returns (string memory) {
346         return _symbol;
347     }
348 
349     /**
350      * @dev Returns the number of decimals used to get its user representation.
351      * For example, if `decimals` equals `2`, a balance of `505` tokens should
352      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
353      *
354      * Tokens usually opt for a value of 18, imitating the relationship between
355      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
356      * called.
357      *
358      * NOTE: This information is only used for _display_ purposes: it in
359      * no way affects any of the arithmetic of the contract, including
360      * {IERC20-balanceOf} and {IERC20-transfer}.
361      */
362     function decimals() public view returns (uint8) {
363         return _decimals;
364     }
365 
366     /**
367      * @dev See {IERC20-totalSupply}.
368      */
369     function totalSupply() public view override returns (uint256) {
370         return _totalSupply;
371     }
372 
373     /**
374      * @dev See {IERC20-balanceOf}.
375      */
376     function balanceOf(address account) public view override returns (uint256) {
377         return _balances[account];
378     }
379 
380     /**
381      * @dev See {IERC20-transfer}.
382      *
383      * Requirements:
384      *
385      * - `recipient` cannot be the zero address.
386      * - the caller must have a balance of at least `amount`.
387      */
388     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
389         _transfer(_msgSender(), recipient, amount);
390         return true;
391     }
392 
393     /**
394      * @dev See {IERC20-allowance}.
395      */
396     function allowance(address owner, address spender) public view virtual override returns (uint256) {
397         return _allowances[owner][spender];
398     }
399 
400     /**
401      * @dev See {IERC20-approve}.
402      *
403      * Requirements:
404      *
405      * - `spender` cannot be the zero address.
406      */
407     function approve(address spender, uint256 amount) public virtual override returns (bool) {
408         _approve(_msgSender(), spender, amount);
409         return true;
410     }
411 
412     /**
413      * @dev See {IERC20-transferFrom}.
414      *
415      * Emits an {Approval} event indicating the updated allowance. This is not
416      * required by the EIP. See the note at the beginning of {ERC20}.
417      *
418      * Requirements:
419      *
420      * - `sender` and `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      * - the caller must have allowance for ``sender``'s tokens of at least
423      * `amount`.
424      */
425     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
426         _transfer(sender, recipient, amount);
427         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
428         return true;
429     }
430 
431     /**
432      * @dev Atomically increases the allowance granted to `spender` by the caller.
433      *
434      * This is an alternative to {approve} that can be used as a mitigation for
435      * problems described in {IERC20-approve}.
436      *
437      * Emits an {Approval} event indicating the updated allowance.
438      *
439      * Requirements:
440      *
441      * - `spender` cannot be the zero address.
442      */
443     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
444         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
445         return true;
446     }
447 
448     /**
449      * @dev Atomically decreases the allowance granted to `spender` by the caller.
450      *
451      * This is an alternative to {approve} that can be used as a mitigation for
452      * problems described in {IERC20-approve}.
453      *
454      * Emits an {Approval} event indicating the updated allowance.
455      *
456      * Requirements:
457      *
458      * - `spender` cannot be the zero address.
459      * - `spender` must have allowance for the caller of at least
460      * `subtractedValue`.
461      */
462     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
464         return true;
465     }
466 
467     /**
468      * @dev Moves tokens `amount` from `sender` to `recipient`.
469      *
470      * This is internal function is equivalent to {transfer}, and can be used to
471      * e.g. implement automatic token fees, slashing mechanisms, etc.
472      *
473      * Emits a {Transfer} event.
474      *
475      * Requirements:
476      *
477      * - `sender` cannot be the zero address.
478      * - `recipient` cannot be the zero address.
479      * - `sender` must have a balance of at least `amount`.
480      */
481     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
482         require(sender != address(0), "ERC20: transfer from the zero address");
483         require(recipient != address(0), "ERC20: transfer to the zero address");
484 
485         _beforeTokenTransfer(sender, recipient, amount);
486 
487         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
488         _balances[recipient] = _balances[recipient].add(amount);
489         emit Transfer(sender, recipient, amount);
490     }
491 
492     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
493      * the total supply.
494      *
495      * Emits a {Transfer} event with `from` set to the zero address.
496      *
497      * Requirements:
498      *
499      * - `to` cannot be the zero address.
500      */
501     function _mint(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: mint to the zero address");
503 
504         _beforeTokenTransfer(address(0), account, amount);
505 
506         _totalSupply = _totalSupply.add(amount);
507         _balances[account] = _balances[account].add(amount);
508         emit Transfer(address(0), account, amount);
509     }
510 
511     /**
512      * @dev Destroys `amount` tokens from `account`, reducing the
513      * total supply.
514      *
515      * Emits a {Transfer} event with `to` set to the zero address.
516      *
517      * Requirements:
518      *
519      * - `account` cannot be the zero address.
520      * - `account` must have at least `amount` tokens.
521      */
522     function _burn(address account, uint256 amount) internal virtual {
523         require(account != address(0), "ERC20: burn from the zero address");
524 
525         _beforeTokenTransfer(account, address(0), amount);
526 
527         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
528         _totalSupply = _totalSupply.sub(amount);
529         emit Transfer(account, address(0), amount);
530     }
531 
532     /**
533      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
534      *
535      * This internal function is equivalent to `approve`, and can be used to
536      * e.g. set automatic allowances for certain subsystems, etc.
537      *
538      * Emits an {Approval} event.
539      *
540      * Requirements:
541      *
542      * - `owner` cannot be the zero address.
543      * - `spender` cannot be the zero address.
544      */
545     function _approve(address owner, address spender, uint256 amount) internal virtual {
546         require(owner != address(0), "ERC20: approve from the zero address");
547         require(spender != address(0), "ERC20: approve to the zero address");
548 
549         _allowances[owner][spender] = amount;
550         emit Approval(owner, spender, amount);
551     }
552 
553     /**
554      * @dev Sets {decimals} to a value other than the default one of 18.
555      *
556      * WARNING: This function should only be called from the constructor. Most
557      * applications that interact with token contracts will not expect
558      * {decimals} to ever change, and may work incorrectly if it does.
559      */
560     function _setupDecimals(uint8 decimals_) internal {
561         _decimals = decimals_;
562     }
563 
564     /**
565      * @dev Hook that is called before any transfer of tokens. This includes
566      * minting and burning.
567      *
568      * Calling conditions:
569      *
570      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
571      * will be to transferred to `to`.
572      * - when `from` is zero, `amount` tokens will be minted for `to`.
573      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
574      * - `from` and `to` are never both zero.
575      *
576      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
577      */
578     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
579 }
580 
581 
582 // File @openzeppelin/contracts/utils/Counters.sol@v3.3.0
583 
584 
585 
586 pragma solidity >=0.6.0 <0.8.0;
587 
588 /**
589  * @title Counters
590  * @author Matt Condon (@shrugs)
591  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
592  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
593  *
594  * Include with `using Counters for Counters.Counter;`
595  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
596  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
597  * directly accessed.
598  */
599 library Counters {
600     using SafeMath for uint256;
601 
602     struct Counter {
603         // This variable should never be directly accessed by users of the library: interactions must be restricted to
604         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
605         // this feature: see https://github.com/ethereum/solidity/issues/4637
606         uint256 _value; // default: 0
607     }
608 
609     function current(Counter storage counter) internal view returns (uint256) {
610         return counter._value;
611     }
612 
613     function increment(Counter storage counter) internal {
614         // The {SafeMath} overflow check can be skipped here, see the comment at the top
615         counter._value += 1;
616     }
617 
618     function decrement(Counter storage counter) internal {
619         counter._value = counter._value.sub(1);
620     }
621 }
622 
623 
624 // File contracts/ECDSA.sol
625 
626 
627 
628 pragma solidity >=0.6.0 <0.8.0;
629 
630 /**
631  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
632  *
633  * These functions can be used to verify that a message was signed by the holder
634  * of the private keys of a given address.
635  */
636 library ECDSA {
637     /**
638      * @dev Returns the address that signed a hashed message (`hash`) with
639      * `signature`. This address can then be used for verification purposes.
640      *
641      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
642      * this function rejects them by requiring the `s` value to be in the lower
643      * half order, and the `v` value to be either 27 or 28.
644      *
645      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
646      * verification to be secure: it is possible to craft signatures that
647      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
648      * this is by receiving a hash of the original message (which may otherwise
649      * be too long), and then calling {toEthSignedMessageHash} on it.
650      */
651     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
652         // Check the signature length
653         if (signature.length != 65) {
654             revert("ECDSA: invalid signature length");
655         }
656 
657         // Divide the signature in r, s and v variables
658         bytes32 r;
659         bytes32 s;
660         uint8 v;
661 
662         // ecrecover takes the signature parameters, and the only way to get them
663         // currently is to use assembly.
664         // solhint-disable-next-line no-inline-assembly
665         assembly {
666             r := mload(add(signature, 0x20))
667             s := mload(add(signature, 0x40))
668             v := byte(0, mload(add(signature, 0x60)))
669         }
670 
671         return recover(hash, v, r, s);
672     }
673 
674     /**
675      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
676      * `r` and `s` signature fields separately.
677      */
678     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
679         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
680         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
681         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
682         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
683         //
684         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
685         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
686         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
687         // these malleable signatures as well.
688         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
689         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
690 
691         // If the signature is valid (and not malleable), return the signer address
692         address signer = ecrecover(hash, v, r, s);
693         require(signer != address(0), "ECDSA: invalid signature");
694 
695         return signer;
696     }
697 
698     /**
699      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
700      * replicates the behavior of the
701      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
702      * JSON-RPC method.
703      *
704      * See {recover}.
705      */
706     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
707         // 32 is the length in bytes of hash,
708         // enforced by the type signature above
709         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
710     }
711 }
712 
713 
714 // File contracts/IERC20Permit.sol
715 
716 
717 
718 pragma solidity >=0.6.0 <0.8.0;
719 
720 /**
721  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
722  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
723  *
724  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
725  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
726  * need to send a transaction, and thus is not required to hold Ether at all.
727  */
728 interface IERC20Permit {
729     /**
730      * @dev Sets `value` as the allowance of `spender` over `owner`'s tokens,
731      * given `owner`'s signed approval.
732      *
733      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
734      * ordering also apply here.
735      *
736      * Emits an {Approval} event.
737      *
738      * Requirements:
739      *
740      * - `spender` cannot be the zero address.
741      * - `deadline` must be a timestamp in the future.
742      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
743      * over the EIP712-formatted function arguments.
744      * - the signature must use ``owner``'s current nonce (see {nonces}).
745      *
746      * For more information on the signature format, see the
747      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
748      * section].
749      */
750     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
751 
752     /**
753      * @dev Returns the current nonce for `owner`. This value must be
754      * included whenever a signature is generated for {permit}.
755      *
756      * Every successful call to {permit} increases ``owner``'s nonce by one. This
757      * prevents a signature from being used multiple times.
758      */
759     function nonces(address owner) external view returns (uint256);
760 
761     /**
762      * @dev Returns the domain separator used in the encoding of the signature for `permit`, as defined by {EIP712}.
763      */
764     // solhint-disable-next-line func-name-mixedcase
765     function DOMAIN_SEPARATOR() external view returns (bytes32);
766 }
767 
768 
769 // File contracts/EIP712.sol
770 
771 
772 
773 pragma solidity >=0.6.0 <0.8.0;
774 
775 /**
776  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
777  *
778  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
779  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
780  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
781  *
782  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
783  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
784  * ({_hashTypedDataV4}).
785  *
786  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
787  * the chain id to protect against replay attacks on an eventual fork of the chain.
788  *
789  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
790  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
791  */
792 abstract contract EIP712 {
793     /* solhint-disable var-name-mixedcase */
794     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
795     // invalidate the cached domain separator if the chain id changes.
796     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
797     uint256 private immutable _CACHED_CHAIN_ID;
798 
799     bytes32 private immutable _HASHED_NAME;
800     bytes32 private immutable _HASHED_VERSION;
801     bytes32 private immutable _TYPE_HASH;
802     /* solhint-enable var-name-mixedcase */
803 
804     /**
805      * @dev Initializes the domain separator and parameter caches.
806      *
807      * The meaning of `name` and `version` is specified in
808      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
809      *
810      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
811      * - `version`: the current major version of the signing domain.
812      *
813      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
814      * contract upgrade].
815      */
816     constructor(string memory name, string memory version) internal {
817         bytes32 hashedName = keccak256(bytes(name));
818         bytes32 hashedVersion = keccak256(bytes(version));
819         bytes32 typeHash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"); 
820         _HASHED_NAME = hashedName;
821         _HASHED_VERSION = hashedVersion;
822         _CACHED_CHAIN_ID = _getChainId();
823         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
824         _TYPE_HASH = typeHash;
825     }
826 
827     /**
828      * @dev Returns the domain separator for the current chain.
829      */
830     function _domainSeparatorV4() internal view returns (bytes32) {
831         if (_getChainId() == _CACHED_CHAIN_ID) {
832             return _CACHED_DOMAIN_SEPARATOR;
833         } else {
834             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
835         }
836     }
837 
838     function _buildDomainSeparator(bytes32 typeHash, bytes32 name, bytes32 version) private view returns (bytes32) {
839         return keccak256(
840             abi.encode(
841                 typeHash,
842                 name,
843                 version,
844                 _getChainId(),
845                 address(this)
846             )
847         );
848     }
849 
850     /**
851      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
852      * function returns the hash of the fully encoded EIP712 message for this domain.
853      *
854      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
855      *
856      * ```solidity
857      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
858      *     keccak256("Mail(address to,string contents)"),
859      *     mailTo,
860      *     keccak256(bytes(mailContents))
861      * )));
862      * address signer = ECDSA.recover(digest, signature);
863      * ```
864      */
865     function _hashTypedDataV4(bytes32 structHash) internal view returns (bytes32) {
866         return keccak256(abi.encodePacked("\x19\x01", _domainSeparatorV4(), structHash));
867     }
868 
869     function _getChainId() private view returns (uint256 chainId) {
870         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
871         // solhint-disable-next-line no-inline-assembly
872         assembly {
873             chainId := chainid()
874         }
875     }
876 }
877 
878 
879 // File contracts/ERC20Permit.sol
880 
881 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/da00d28cb7dd41e66fde367031653e0ef0fe47f2/contracts/drafts/ERC20Permit.sol
882 
883 
884 pragma solidity >=0.6.5 <0.8.0;
885 
886 
887 
888 
889 
890 /**
891  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
892  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
893  *
894  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
895  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
896  * need to send a transaction, and thus is not required to hold Ether at all.
897  */
898 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
899     using Counters for Counters.Counter;
900 
901     mapping (address => Counters.Counter) private _nonces;
902 
903     // solhint-disable-next-line var-name-mixedcase
904     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
905 
906     /**
907      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
908      *
909      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
910      */
911     constructor(string memory name) internal EIP712(name, "1") {
912     }
913 
914     /**
915      * @dev See {IERC20Permit-permit}.
916      */
917     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
918         // solhint-disable-next-line not-rely-on-time
919         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
920 
921         bytes32 structHash = keccak256(
922             abi.encode(
923                 _PERMIT_TYPEHASH,
924                 owner,
925                 spender,
926                 value,
927                 _nonces[owner].current(),
928                 deadline
929             )
930         );
931 
932         bytes32 hash = _hashTypedDataV4(structHash);
933 
934         address signer = ECDSA.recover(hash, v, r, s);
935         require(signer == owner, "ERC20Permit: invalid signature");
936 
937         _nonces[owner].increment();
938         _approve(owner, spender, value);
939     }
940 
941     /**
942      * @dev See {IERC20Permit-nonces}.
943      */
944     function nonces(address owner) public view override returns (uint256) {
945         return _nonces[owner].current();
946     }
947 
948     /**
949      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
950      */
951     // solhint-disable-next-line func-name-mixedcase
952     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
953         return _domainSeparatorV4();
954     }
955 }
956 
957 
958 // File contracts/Ownable.sol
959 
960 
961 
962 pragma solidity >=0.6.0 <0.8.0;
963 
964 
965 /**
966  * @dev Contract module which provides a basic access control mechanism, where
967  * there is an account (an owner) that can be granted exclusive access to
968  * specific functions.
969  *
970  * By default, the owner account will be the one that deploys the contract. This
971  * can later be changed with {transferOwnership}.
972  *
973  * This module is used through inheritance. It will make available the modifier
974  * `onlyOwner`, which can be applied to your functions to restrict their use to
975  * the owner.
976  */
977 abstract contract Ownable {
978     address private _owner;
979 
980     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
981 
982     /**
983      * @dev Initializes the contract setting the deployer as the initial owner.
984      */
985     constructor (address owner) internal {
986         _owner = owner;
987         emit OwnershipTransferred(address(0), owner);
988     }
989 
990     /**
991      * @dev Returns the address of the current owner.
992      */
993     function owner() public view returns (address) {
994         return _owner;
995     }
996 
997     /**
998      * @dev Throws if called by any account other than the owner.
999      */
1000     modifier onlyOwner() {
1001         require(_owner == msg.sender, "Ownable: caller is not the owner");
1002         _;
1003     }
1004 
1005     /**
1006      * @dev Leaves the contract without owner. It will not be possible to call
1007      * `onlyOwner` functions anymore. Can only be called by the current owner.
1008      *
1009      * NOTE: Renouncing ownership will leave the contract without an owner,
1010      * thereby removing any functionality that is only available to the owner.
1011      */
1012     function renounceOwnership() public virtual onlyOwner {
1013         emit OwnershipTransferred(_owner, address(0));
1014         _owner = address(0);
1015     }
1016 
1017     /**
1018      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1019      * Can only be called by the current owner.
1020      */
1021     function transferOwnership(address newOwner) public virtual onlyOwner {
1022         require(newOwner != address(0), "Ownable: new owner is the zero address");
1023         emit OwnershipTransferred(_owner, newOwner);
1024         _owner = newOwner;
1025     }
1026 }
1027 
1028 
1029 // File contracts/DFXToken.sol
1030 
1031 pragma solidity 0.7.3;
1032 
1033 
1034 
1035 contract DFXToken is ERC20, ERC20Permit, Ownable {
1036     constructor(address owner) public ERC20("DFX Token", "DFX") ERC20Permit("DFX Token") Ownable(owner) {}
1037 
1038     function mint(address account, uint256 amount) external onlyOwner {
1039         _mint(account, amount);
1040     }
1041 }