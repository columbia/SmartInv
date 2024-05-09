1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.3;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         uint256 c = a + b;
25         if (c < a) return (false, 0);
26         return (true, c);
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         if (b > a) return (false, 0);
36         return (true, a - b);
37     }
38 
39     /**
40      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
41      *
42      * _Available since v3.4._
43      */
44     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
45         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46         // benefit is lost if 'b' is also tested.
47         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
48         if (a == 0) return (true, 0);
49         uint256 c = a * b;
50         if (c / a != b) return (false, 0);
51         return (true, c);
52     }
53 
54     /**
55      * @dev Returns the division of two unsigned integers, with a division by zero flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         if (b == 0) return (false, 0);
61         return (true, a / b);
62     }
63 
64     /**
65      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
66      *
67      * _Available since v3.4._
68      */
69     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
70         if (b == 0) return (false, 0);
71         return (true, a % b);
72     }
73 
74     /**
75      * @dev Returns the addition of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `+` operator.
79      *
80      * Requirements:
81      *
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87         return c;
88     }
89 
90     /**
91      * @dev Returns the subtraction of two unsigned integers, reverting on
92      * overflow (when the result is negative).
93      *
94      * Counterpart to Solidity's `-` operator.
95      *
96      * Requirements:
97      *
98      * - Subtraction cannot overflow.
99      */
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b <= a, "SafeMath: subtraction overflow");
102         return a - b;
103     }
104 
105     /**
106      * @dev Returns the multiplication of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `*` operator.
110      *
111      * Requirements:
112      *
113      * - Multiplication cannot overflow.
114      */
115     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116         if (a == 0) return 0;
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers, reverting on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b > 0, "SafeMath: division by zero");
136         return a / b;
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * reverting when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b > 0, "SafeMath: modulo by zero");
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         return a - b;
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * CAUTION: This function is deprecated because it requires allocating memory for the error
179      * message unnecessarily. For custom revert reasons use {tryDiv}.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         return a / b;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * reverting with custom message when dividing by zero.
197      *
198      * CAUTION: This function is deprecated because it requires allocating memory for the error
199      * message unnecessarily. For custom revert reasons use {tryMod}.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
210         require(b > 0, errorMessage);
211         return a % b;
212     }
213 }
214 
215 /**
216  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
217  *
218  * These functions can be used to verify that a message was signed by the holder
219  * of the private keys of a given address.
220  */
221 library ECDSA {
222     /**
223      * @dev Returns the address that signed a hashed message (`hash`) with
224      * `signature`. This address can then be used for verification purposes.
225      *
226      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
227      * this function rejects them by requiring the `s` value to be in the lower
228      * half order, and the `v` value to be either 27 or 28.
229      *
230      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
231      * verification to be secure: it is possible to craft signatures that
232      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
233      * this is by receiving a hash of the original message (which may otherwise
234      * be too long), and then calling {toEthSignedMessageHash} on it.
235      */
236     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
237         // Check the signature length
238         if (signature.length != 65) {
239             revert("ECDSA: invalid signature length");
240         }
241 
242         // Divide the signature in r, s and v variables
243         bytes32 r;
244         bytes32 s;
245         uint8 v;
246 
247         // ecrecover takes the signature parameters, and the only way to get them
248         // currently is to use assembly.
249         // solhint-disable-next-line no-inline-assembly
250         assembly {
251             r := mload(add(signature, 0x20))
252             s := mload(add(signature, 0x40))
253             v := byte(0, mload(add(signature, 0x60)))
254         }
255 
256         return recover(hash, v, r, s);
257     }
258 
259     /**
260      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
261      * `r` and `s` signature fields separately.
262      */
263     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
264         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
265         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
266         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
267         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
268         //
269         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
270         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
271         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
272         // these malleable signatures as well.
273         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
274         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
275 
276         // If the signature is valid (and not malleable), return the signer address
277         address signer = ecrecover(hash, v, r, s);
278         require(signer != address(0), "ECDSA: invalid signature");
279 
280         return signer;
281     }
282 
283     /**
284      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
285      * replicates the behavior of the
286      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
287      * JSON-RPC method.
288      *
289      * See {recover}.
290      */
291     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
292         // 32 is the length in bytes of hash,
293         // enforced by the type signature above
294         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
295     }
296 }
297 
298 /*
299  * @dev Provides information about the current execution context, including the
300  * sender of the transaction and its data. While these are generally available
301  * via msg.sender and msg.data, they should not be accessed in such a direct
302  * manner, since when dealing with GSN meta-transactions the account sending and
303  * paying for execution may not be the actual sender (as far as an application
304  * is concerned).
305  *
306  * This contract is only required for intermediate, library-like contracts.
307  */
308 abstract contract Context {
309     function _msgSender() internal view virtual returns (address payable) {
310         return msg.sender;
311     }
312 
313     function _msgData() internal view virtual returns (bytes memory) {
314         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
315         return msg.data;
316     }
317 }
318 
319 /**
320  * @dev Interface of the ERC20 standard as defined in the EIP.
321  */
322 interface IERC20 {
323     /**
324      * @dev Returns the amount of tokens in existence.
325      */
326     function totalSupply() external view returns (uint256);
327 
328     /**
329      * @dev Returns the amount of tokens owned by `account`.
330      */
331     function balanceOf(address account) external view returns (uint256);
332 
333     /**
334      * @dev Moves `amount` tokens from the caller's account to `recipient`.
335      *
336      * Returns a boolean value indicating whether the operation succeeded.
337      *
338      * Emits a {Transfer} event.
339      */
340     function transfer(address recipient, uint256 amount) external returns (bool);
341 
342     /**
343      * @dev Returns the remaining number of tokens that `spender` will be
344      * allowed to spend on behalf of `owner` through {transferFrom}. This is
345      * zero by default.
346      *
347      * This value changes when {approve} or {transferFrom} are called.
348      */
349     function allowance(address owner, address spender) external view returns (uint256);
350 
351     /**
352      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * IMPORTANT: Beware that changing an allowance with this method brings the risk
357      * that someone may use both the old and the new allowance by unfortunate
358      * transaction ordering. One possible solution to mitigate this race
359      * condition is to first reduce the spender's allowance to 0 and set the
360      * desired value afterwards:
361      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
362      *
363      * Emits an {Approval} event.
364      */
365     function approve(address spender, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Moves `amount` tokens from `sender` to `recipient` using the
369      * allowance mechanism. `amount` is then deducted from the caller's
370      * allowance.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Emitted when `value` tokens are moved from one account (`from`) to
380      * another (`to`).
381      *
382      * Note that `value` may be zero.
383      */
384     event Transfer(address indexed from, address indexed to, uint256 value);
385 
386     /**
387      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
388      * a call to {approve}. `value` is the new allowance.
389      */
390     event Approval(address indexed owner, address indexed spender, uint256 value);
391 }
392 
393 /**
394  * @dev Implementation of the {IERC20} interface.
395  *
396  * This implementation is agnostic to the way tokens are created. This means
397  * that a supply mechanism has to be added in a derived contract using {_mint}.
398  * For a generic mechanism see {ERC20PresetMinterPauser}.
399  *
400  * TIP: For a detailed writeup see our guide
401  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
402  * to implement supply mechanisms].
403  *
404  * We have followed general OpenZeppelin guidelines: functions revert instead
405  * of returning `false` on failure. This behavior is nonetheless conventional
406  * and does not conflict with the expectations of ERC20 applications.
407  *
408  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See {IERC20-approve}.
416  */
417 contract ERC20 is Context, IERC20 {
418     using SafeMath for uint256;
419 
420     mapping (address => uint256) private _balances;
421 
422     mapping (address => mapping (address => uint256)) private _allowances;
423 
424     uint256 private _totalSupply;
425 
426     string private _name;
427     string private _symbol;
428     uint8 private _decimals;
429 
430     /**
431      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
432      * a default value of 18.
433      *
434      * To select a different value for {decimals}, use {_setupDecimals}.
435      *
436      * All three of these values are immutable: they can only be set once during
437      * construction.
438      */
439     constructor (string memory name_, string memory symbol_) public {
440         _name = name_;
441         _symbol = symbol_;
442         _decimals = 18;
443     }
444 
445     /**
446      * @dev Returns the name of the token.
447      */
448     function name() public view virtual returns (string memory) {
449         return _name;
450     }
451 
452     /**
453      * @dev Returns the symbol of the token, usually a shorter version of the
454      * name.
455      */
456     function symbol() public view virtual returns (string memory) {
457         return _symbol;
458     }
459 
460     /**
461      * @dev Returns the number of decimals used to get its user representation.
462      * For example, if `decimals` equals `2`, a balance of `505` tokens should
463      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
464      *
465      * Tokens usually opt for a value of 18, imitating the relationship between
466      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
467      * called.
468      *
469      * NOTE: This information is only used for _display_ purposes: it in
470      * no way affects any of the arithmetic of the contract, including
471      * {IERC20-balanceOf} and {IERC20-transfer}.
472      */
473     function decimals() public view virtual returns (uint8) {
474         return _decimals;
475     }
476 
477     /**
478      * @dev See {IERC20-totalSupply}.
479      */
480     function totalSupply() public view virtual override returns (uint256) {
481         return _totalSupply;
482     }
483 
484     /**
485      * @dev See {IERC20-balanceOf}.
486      */
487     function balanceOf(address account) public view virtual override returns (uint256) {
488         return _balances[account];
489     }
490 
491     /**
492      * @dev See {IERC20-transfer}.
493      *
494      * Requirements:
495      *
496      * - `recipient` cannot be the zero address.
497      * - the caller must have a balance of at least `amount`.
498      */
499     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
500         _transfer(_msgSender(), recipient, amount);
501         return true;
502     }
503 
504     /**
505      * @dev See {IERC20-allowance}.
506      */
507     function allowance(address owner, address spender) public view virtual override returns (uint256) {
508         return _allowances[owner][spender];
509     }
510 
511     /**
512      * @dev See {IERC20-approve}.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      */
518     function approve(address spender, uint256 amount) public virtual override returns (bool) {
519         _approve(_msgSender(), spender, amount);
520         return true;
521     }
522 
523     /**
524      * @dev See {IERC20-transferFrom}.
525      *
526      * Emits an {Approval} event indicating the updated allowance. This is not
527      * required by the EIP. See the note at the beginning of {ERC20}.
528      *
529      * Requirements:
530      *
531      * - `sender` and `recipient` cannot be the zero address.
532      * - `sender` must have a balance of at least `amount`.
533      * - the caller must have allowance for ``sender``'s tokens of at least
534      * `amount`.
535      */
536     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(sender, recipient, amount);
538         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
539         return true;
540     }
541 
542     /**
543      * @dev Atomically increases the allowance granted to `spender` by the caller.
544      *
545      * This is an alternative to {approve} that can be used as a mitigation for
546      * problems described in {IERC20-approve}.
547      *
548      * Emits an {Approval} event indicating the updated allowance.
549      *
550      * Requirements:
551      *
552      * - `spender` cannot be the zero address.
553      */
554     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
556         return true;
557     }
558 
559     /**
560      * @dev Atomically decreases the allowance granted to `spender` by the caller.
561      *
562      * This is an alternative to {approve} that can be used as a mitigation for
563      * problems described in {IERC20-approve}.
564      *
565      * Emits an {Approval} event indicating the updated allowance.
566      *
567      * Requirements:
568      *
569      * - `spender` cannot be the zero address.
570      * - `spender` must have allowance for the caller of at least
571      * `subtractedValue`.
572      */
573     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
575         return true;
576     }
577 
578     /**
579      * @dev Moves tokens `amount` from `sender` to `recipient`.
580      *
581      * This is internal function is equivalent to {transfer}, and can be used to
582      * e.g. implement automatic token fees, slashing mechanisms, etc.
583      *
584      * Emits a {Transfer} event.
585      *
586      * Requirements:
587      *
588      * - `sender` cannot be the zero address.
589      * - `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      */
592     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
593         require(sender != address(0), "ERC20: transfer from the zero address");
594         require(recipient != address(0), "ERC20: transfer to the zero address");
595 
596         _beforeTokenTransfer(sender, recipient, amount);
597 
598         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
599         _balances[recipient] = _balances[recipient].add(amount);
600         emit Transfer(sender, recipient, amount);
601     }
602 
603     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
604      * the total supply.
605      *
606      * Emits a {Transfer} event with `from` set to the zero address.
607      *
608      * Requirements:
609      *
610      * - `to` cannot be the zero address.
611      */
612     function _mint(address account, uint256 amount) internal virtual {
613         require(account != address(0), "ERC20: mint to the zero address");
614 
615         _beforeTokenTransfer(address(0), account, amount);
616 
617         _totalSupply = _totalSupply.add(amount);
618         _balances[account] = _balances[account].add(amount);
619         emit Transfer(address(0), account, amount);
620     }
621 
622     /**
623      * @dev Destroys `amount` tokens from `account`, reducing the
624      * total supply.
625      *
626      * Emits a {Transfer} event with `to` set to the zero address.
627      *
628      * Requirements:
629      *
630      * - `account` cannot be the zero address.
631      * - `account` must have at least `amount` tokens.
632      */
633     function _burn(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: burn from the zero address");
635 
636         _beforeTokenTransfer(account, address(0), amount);
637 
638         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
639         _totalSupply = _totalSupply.sub(amount);
640         emit Transfer(account, address(0), amount);
641     }
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
645      *
646      * This internal function is equivalent to `approve`, and can be used to
647      * e.g. set automatic allowances for certain subsystems, etc.
648      *
649      * Emits an {Approval} event.
650      *
651      * Requirements:
652      *
653      * - `owner` cannot be the zero address.
654      * - `spender` cannot be the zero address.
655      */
656     function _approve(address owner, address spender, uint256 amount) internal virtual {
657         require(owner != address(0), "ERC20: approve from the zero address");
658         require(spender != address(0), "ERC20: approve to the zero address");
659 
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663 
664     /**
665      * @dev Sets {decimals} to a value other than the default one of 18.
666      *
667      * WARNING: This function should only be called from the constructor. Most
668      * applications that interact with token contracts will not expect
669      * {decimals} to ever change, and may work incorrectly if it does.
670      */
671     function _setupDecimals(uint8 decimals_) internal virtual {
672         _decimals = decimals_;
673     }
674 
675     /**
676      * @dev Hook that is called before any transfer of tokens. This includes
677      * minting and burning.
678      *
679      * Calling conditions:
680      *
681      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
682      * will be to transferred to `to`.
683      * - when `from` is zero, `amount` tokens will be minted for `to`.
684      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
685      * - `from` and `to` are never both zero.
686      *
687      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
688      */
689     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
690 }
691 
692 /**
693  * @dev Contract module which provides a basic access control mechanism, where
694  * there is an account (an owner) that can be granted exclusive access to
695  * specific functions.
696  *
697  * By default, the owner account will be the one that deploys the contract. This
698  * can later be changed with {transferOwnership}.
699  *
700  * This module is used through inheritance. It will make available the modifier
701  * `onlyOwner`, which can be applied to your functions to restrict their use to
702  * the owner.
703  */
704 abstract contract Ownable is Context {
705     address private _owner;
706 
707     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
708 
709     /**
710      * @dev Initializes the contract setting the deployer as the initial owner.
711      */
712     constructor () internal {
713         address msgSender = _msgSender();
714         _owner = msgSender;
715         emit OwnershipTransferred(address(0), msgSender);
716     }
717 
718     /**
719      * @dev Returns the address of the current owner.
720      */
721     function owner() public view virtual returns (address) {
722         return _owner;
723     }
724 
725     /**
726      * @dev Throws if called by any account other than the owner.
727      */
728     modifier onlyOwner() {
729         require(owner() == _msgSender(), "Ownable: caller is not the owner");
730         _;
731     }
732 
733     /**
734      * @dev Leaves the contract without owner. It will not be possible to call
735      * `onlyOwner` functions anymore. Can only be called by the current owner.
736      *
737      * NOTE: Renouncing ownership will leave the contract without an owner,
738      * thereby removing any functionality that is only available to the owner.
739      */
740     function renounceOwnership() public virtual onlyOwner {
741         emit OwnershipTransferred(_owner, address(0));
742         _owner = address(0);
743     }
744 
745     /**
746      * @dev Transfers ownership of the contract to a new account (`newOwner`).
747      * Can only be called by the current owner.
748      */
749     function transferOwnership(address newOwner) public virtual onlyOwner {
750         require(newOwner != address(0), "Ownable: new owner is the zero address");
751         emit OwnershipTransferred(_owner, newOwner);
752         _owner = newOwner;
753     }
754 }
755 
756 library TransferHelper {
757     function safeApprove(address token, address to, uint256 value) internal {
758         // bytes4(keccak256(bytes('approve(address,uint256)')));
759         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
760         require(success && (data.length == 0 || abi.decode(data, (bool))), 'safeApprove failed');
761     }
762 
763     function safeTransfer(address token, address to, uint256 value) internal {
764         // bytes4(keccak256(bytes('transfer(address,uint256)')));
765         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
766         require(success && (data.length == 0 || abi.decode(data, (bool))), 'safeTransfer failed');
767     }
768 
769     function safeTransferFrom(address token, address from, address to, uint256 value) internal {
770         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
771         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
772         require(success && (data.length == 0 || abi.decode(data, (bool))), 'transferFrom failed');
773     }
774 
775     function safeTransferETH(address to, uint256 value) internal {
776         (bool success,) = to.call{value: value}(new bytes(0));
777         require(success, 'safeTransferETH failed');
778     }
779 }
780 
781 contract ETHBridge is Ownable {
782     using SafeMath for uint;
783     address public signer;
784     mapping(string => bool) public executed;
785 
786     event Transit(address indexed ercToken, address indexed to, uint256 indexed amount);
787     event Withdraw(address indexed ercToken, address indexed to, uint256 indexed amount, string withdrawId);
788 
789     constructor(address _signer) public {
790         signer = _signer;
791     }
792 
793     function transit(address _ercToken, uint256 _amount) external {
794         require(_amount > 0, "amount must be greater than 0");
795         TransferHelper.safeTransferFrom(_ercToken, msg.sender, address(this), _amount);
796         emit Transit(_ercToken, msg.sender, _amount);
797     }
798 
799     function withdraw(bytes calldata _signature, string memory _withdrawId, address _ercToken, uint _amount) external {
800         require(!executed[_withdrawId], "already withdraw");
801         require(_amount > 0, "amount must be greater than 0");
802 
803         uint chainId;
804         assembly {
805             chainId := chainid()
806         }
807         bytes32 message = keccak256(abi.encodePacked(chainId, address(this), _ercToken, _amount, msg.sender, _withdrawId));
808         bytes32 signature = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", message));
809 
810         require(ECDSA.recover(signature, _signature) == signer, "invalid signature");
811 
812         TransferHelper.safeTransfer(_ercToken, msg.sender, _amount);
813         executed[_withdrawId] = true;
814         emit Withdraw(_ercToken, msg.sender, _amount, _withdrawId);
815     }
816 
817     function changeSigner(address _signer) onlyOwner external {
818         signer = _signer;
819     }
820 }