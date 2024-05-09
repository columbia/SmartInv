1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
114         // Solidity only automatically asserts when dividing by 0
115         require(b > 0, errorMessage);
116         uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
124      * Reverts when dividing by zero.
125      *
126      * Counterpart to Solidity's `%` operator. This function uses a `revert`
127      * opcode (which leaves remaining gas untouched) while Solidity uses an
128      * invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         return mod(a, b, "SafeMath: modulo by zero");
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts with custom message when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/cryptography/ECDSA.sol
155 
156 pragma solidity ^0.6.0;
157 
158 /**
159  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
160  *
161  * These functions can be used to verify that a message was signed by the holder
162  * of the private keys of a given address.
163  */
164 library ECDSA {
165     /**
166      * @dev Returns the address that signed a hashed message (`hash`) with
167      * `signature`. This address can then be used for verification purposes.
168      *
169      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
170      * this function rejects them by requiring the `s` value to be in the lower
171      * half order, and the `v` value to be either 27 or 28.
172      *
173      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
174      * verification to be secure: it is possible to craft signatures that
175      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
176      * this is by receiving a hash of the original message (which may otherwise
177      * be too long), and then calling {toEthSignedMessageHash} on it.
178      */
179     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
180         // Check the signature length
181         if (signature.length != 65) {
182             revert("ECDSA: invalid signature length");
183         }
184 
185         // Divide the signature in r, s and v variables
186         bytes32 r;
187         bytes32 s;
188         uint8 v;
189 
190         // ecrecover takes the signature parameters, and the only way to get them
191         // currently is to use assembly.
192         // solhint-disable-next-line no-inline-assembly
193         assembly {
194             r := mload(add(signature, 0x20))
195             s := mload(add(signature, 0x40))
196             v := byte(0, mload(add(signature, 0x60)))
197         }
198 
199         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
200         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
201         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
202         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
203         //
204         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
205         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
206         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
207         // these malleable signatures as well.
208         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
209             revert("ECDSA: invalid signature 's' value");
210         }
211 
212         if (v != 27 && v != 28) {
213             revert("ECDSA: invalid signature 'v' value");
214         }
215 
216         // If the signature is valid (and not malleable), return the signer address
217         address signer = ecrecover(hash, v, r, s);
218         require(signer != address(0), "ECDSA: invalid signature");
219 
220         return signer;
221     }
222 
223     /**
224      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
225      * replicates the behavior of the
226      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
227      * JSON-RPC method.
228      *
229      * See {recover}.
230      */
231     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
232         // 32 is the length in bytes of hash,
233         // enforced by the type signature above
234         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 pragma solidity ^0.6.2;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * [IMPORTANT]
250      * ====
251      * It is unsafe to assume that an address for which this function returns
252      * false is an externally-owned account (EOA) and not a contract.
253      *
254      * Among others, `isContract` will return false for the following
255      * types of addresses:
256      *
257      *  - an externally-owned account
258      *  - a contract in construction
259      *  - an address where a contract will be created
260      *  - an address where a contract lived, but was destroyed
261      * ====
262      */
263     function isContract(address account) internal view returns (bool) {
264         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
265         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
266         // for accounts without code, i.e. `keccak256('')`
267         bytes32 codehash;
268         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly { codehash := extcodehash(account) }
271         return (codehash != accountHash && codehash != 0x0);
272     }
273 
274     /**
275      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
276      * `recipient`, forwarding all available gas and reverting on errors.
277      *
278      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
279      * of certain opcodes, possibly making contracts go over the 2300 gas limit
280      * imposed by `transfer`, making them unable to receive funds via
281      * `transfer`. {sendValue} removes this limitation.
282      *
283      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
284      *
285      * IMPORTANT: because control is transferred to `recipient`, care must be
286      * taken to not create reentrancy vulnerabilities. Consider using
287      * {ReentrancyGuard} or the
288      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
289      */
290     function sendValue(address payable recipient, uint256 amount) internal {
291         require(address(this).balance >= amount, "Address: insufficient balance");
292 
293         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
294         (bool success, ) = recipient.call{ value: amount }("");
295         require(success, "Address: unable to send value, recipient may have reverted");
296     }
297 }
298 
299 // File: @openzeppelin/contracts/GSN/Context.sol
300 
301 pragma solidity ^0.6.0;
302 
303 /*
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with GSN meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 contract Context {
314     // Empty internal constructor, to prevent people from mistakenly deploying
315     // an instance of this contract, which should be used via inheritance.
316     constructor () internal { }
317 
318     function _msgSender() internal view virtual returns (address payable) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes memory) {
323         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
324         return msg.data;
325     }
326 }
327 
328 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
329 
330 pragma solidity ^0.6.0;
331 
332 /**
333  * @dev Interface of the ERC20 standard as defined in the EIP.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
407 
408 pragma solidity ^0.6.0;
409 
410 
411 
412 
413 
414 /**
415  * @dev Implementation of the {IERC20} interface.
416  *
417  * This implementation is agnostic to the way tokens are created. This means
418  * that a supply mechanism has to be added in a derived contract using {_mint}.
419  * For a generic mechanism see {ERC20MinterPauser}.
420  *
421  * TIP: For a detailed writeup see our guide
422  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
423  * to implement supply mechanisms].
424  *
425  * We have followed general OpenZeppelin guidelines: functions revert instead
426  * of returning `false` on failure. This behavior is nonetheless conventional
427  * and does not conflict with the expectations of ERC20 applications.
428  *
429  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
430  * This allows applications to reconstruct the allowance for all accounts just
431  * by listening to said events. Other implementations of the EIP may not emit
432  * these events, as it isn't required by the specification.
433  *
434  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
435  * functions have been added to mitigate the well-known issues around setting
436  * allowances. See {IERC20-approve}.
437  */
438 contract ERC20 is Context, IERC20 {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _balances;
443 
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     uint256 private _totalSupply;
447 
448     string private _name;
449     string private _symbol;
450     uint8 private _decimals;
451 
452     /**
453      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
454      * a default value of 18.
455      *
456      * To select a different value for {decimals}, use {_setupDecimals}.
457      *
458      * All three of these values are immutable: they can only be set once during
459      * construction.
460      */
461     constructor (string memory name, string memory symbol) public {
462         _name = name;
463         _symbol = symbol;
464         _decimals = 18;
465     }
466 
467     /**
468      * @dev Returns the name of the token.
469      */
470     function name() public view returns (string memory) {
471         return _name;
472     }
473 
474     /**
475      * @dev Returns the symbol of the token, usually a shorter version of the
476      * name.
477      */
478     function symbol() public view returns (string memory) {
479         return _symbol;
480     }
481 
482     /**
483      * @dev Returns the number of decimals used to get its user representation.
484      * For example, if `decimals` equals `2`, a balance of `505` tokens should
485      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
486      *
487      * Tokens usually opt for a value of 18, imitating the relationship between
488      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
489      * called.
490      *
491      * NOTE: This information is only used for _display_ purposes: it in
492      * no way affects any of the arithmetic of the contract, including
493      * {IERC20-balanceOf} and {IERC20-transfer}.
494      */
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     /**
500      * @dev See {IERC20-totalSupply}.
501      */
502     function totalSupply() public view override returns (uint256) {
503         return _totalSupply;
504     }
505 
506     /**
507      * @dev See {IERC20-balanceOf}.
508      */
509     function balanceOf(address account) public view override returns (uint256) {
510         return _balances[account];
511     }
512 
513     /**
514      * @dev See {IERC20-transfer}.
515      *
516      * Requirements:
517      *
518      * - `recipient` cannot be the zero address.
519      * - the caller must have a balance of at least `amount`.
520      */
521     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     /**
527      * @dev See {IERC20-allowance}.
528      */
529     function allowance(address owner, address spender) public view virtual override returns (uint256) {
530         return _allowances[owner][spender];
531     }
532 
533     /**
534      * @dev See {IERC20-approve}.
535      *
536      * Requirements:
537      *
538      * - `spender` cannot be the zero address.
539      */
540     function approve(address spender, uint256 amount) public virtual override returns (bool) {
541         _approve(_msgSender(), spender, amount);
542         return true;
543     }
544 
545     /**
546      * @dev See {IERC20-transferFrom}.
547      *
548      * Emits an {Approval} event indicating the updated allowance. This is not
549      * required by the EIP. See the note at the beginning of {ERC20};
550      *
551      * Requirements:
552      * - `sender` and `recipient` cannot be the zero address.
553      * - `sender` must have a balance of at least `amount`.
554      * - the caller must have allowance for ``sender``'s tokens of at least
555      * `amount`.
556      */
557     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically increases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      */
575     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
576         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
577         return true;
578     }
579 
580     /**
581      * @dev Atomically decreases the allowance granted to `spender` by the caller.
582      *
583      * This is an alternative to {approve} that can be used as a mitigation for
584      * problems described in {IERC20-approve}.
585      *
586      * Emits an {Approval} event indicating the updated allowance.
587      *
588      * Requirements:
589      *
590      * - `spender` cannot be the zero address.
591      * - `spender` must have allowance for the caller of at least
592      * `subtractedValue`.
593      */
594     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
595         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
596         return true;
597     }
598 
599     /**
600      * @dev Moves tokens `amount` from `sender` to `recipient`.
601      *
602      * This is internal function is equivalent to {transfer}, and can be used to
603      * e.g. implement automatic token fees, slashing mechanisms, etc.
604      *
605      * Emits a {Transfer} event.
606      *
607      * Requirements:
608      *
609      * - `sender` cannot be the zero address.
610      * - `recipient` cannot be the zero address.
611      * - `sender` must have a balance of at least `amount`.
612      */
613     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
614         require(sender != address(0), "ERC20: transfer from the zero address");
615         require(recipient != address(0), "ERC20: transfer to the zero address");
616 
617         _beforeTokenTransfer(sender, recipient, amount);
618 
619         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
620         _balances[recipient] = _balances[recipient].add(amount);
621         emit Transfer(sender, recipient, amount);
622     }
623 
624     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
625      * the total supply.
626      *
627      * Emits a {Transfer} event with `from` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `to` cannot be the zero address.
632      */
633     function _mint(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: mint to the zero address");
635 
636         _beforeTokenTransfer(address(0), account, amount);
637 
638         _totalSupply = _totalSupply.add(amount);
639         _balances[account] = _balances[account].add(amount);
640         emit Transfer(address(0), account, amount);
641     }
642 
643     /**
644      * @dev Destroys `amount` tokens from `account`, reducing the
645      * total supply.
646      *
647      * Emits a {Transfer} event with `to` set to the zero address.
648      *
649      * Requirements
650      *
651      * - `account` cannot be the zero address.
652      * - `account` must have at least `amount` tokens.
653      */
654     function _burn(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: burn from the zero address");
656 
657         _beforeTokenTransfer(account, address(0), amount);
658 
659         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
660         _totalSupply = _totalSupply.sub(amount);
661         emit Transfer(account, address(0), amount);
662     }
663 
664     /**
665      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
666      *
667      * This is internal function is equivalent to `approve`, and can be used to
668      * e.g. set automatic allowances for certain subsystems, etc.
669      *
670      * Emits an {Approval} event.
671      *
672      * Requirements:
673      *
674      * - `owner` cannot be the zero address.
675      * - `spender` cannot be the zero address.
676      */
677     function _approve(address owner, address spender, uint256 amount) internal virtual {
678         require(owner != address(0), "ERC20: approve from the zero address");
679         require(spender != address(0), "ERC20: approve to the zero address");
680 
681         _allowances[owner][spender] = amount;
682         emit Approval(owner, spender, amount);
683     }
684 
685     /**
686      * @dev Sets {decimals} to a value other than the default one of 18.
687      *
688      * WARNING: This function should only be called from the constructor. Most
689      * applications that interact with token contracts will not expect
690      * {decimals} to ever change, and may work incorrectly if it does.
691      */
692     function _setupDecimals(uint8 decimals_) internal {
693         _decimals = decimals_;
694     }
695 
696     /**
697      * @dev Hook that is called before any transfer of tokens. This includes
698      * minting and burning.
699      *
700      * Calling conditions:
701      *
702      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
703      * will be to transferred to `to`.
704      * - when `from` is zero, `amount` tokens will be minted for `to`.
705      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
706      * - `from` and `to` are never both zero.
707      *
708      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
709      */
710     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
711 }
712 
713 // File: contracts/ERC865Plus677ish.sol
714 
715 pragma solidity >=0.6.0  <0.7.0;
716 /**
717  * @title ERC677 transferAndCall token interface
718  * @dev See https://github.com/ethereum/EIPs/issues/677 for specification and
719  *      discussion.
720  *
721  * We deviate from the specification and we don't define a tokenfallback. That means
722  * tranferAndCall can specify the function to call (bytes4(sha3("setN(uint256)")))
723  * and its arguments, and the respective function is called.
724  *
725  * If an invalid function is called, its default function (if implemented) is called.
726  *
727  * We also deviate from ERC865 and added a pre signed transaction for transferAndCall.
728  */
729 
730 /*
731  Notes on signature malleability: Ethereum took the same
732  precaution as in bitcoin was used to prevent that:
733 
734  https://github.com/ethereum/go-ethereum/blob/master/vendor/github.com/btcsuite/btcd/btcec/signature.go#L48
735  https://github.com/ethereum/go-ethereum/blob/master/crypto/signature_test.go
736  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-155.md
737  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-2.md
738 
739  However, ecrecover still allows ambigous signatures. Thus, recover that wraps ecrecover checks for ambigous
740  signatures and only allows unique signatures.
741 */
742 
743 abstract contract ERC865Plus677ish {
744     event TransferAndCall(address indexed _from, address indexed _to, uint256 _value, bytes4 _methodName, bytes _args);
745     function transferAndCall(address _to, uint256 _value, bytes4 _methodName, bytes memory _args) public virtual returns (bool);
746 
747     event TransferPreSigned(address indexed _from, address indexed _to, address indexed _delegate,
748         uint256 _amount, uint256 _fee);
749     event TransferAndCallPreSigned(address indexed _from, address indexed _to, address indexed _delegate,
750         uint256 _amount, uint256 _fee, bytes4 _methodName, bytes _args);
751 
752     function transferPreSigned(bytes memory _signature, address _from, address _to, uint256 _value,
753         uint256 _fee, uint256 _nonce) public virtual returns (bool);
754     function transferAndCallPreSigned(bytes memory _signature, address _from, address _to, uint256 _value,
755         uint256 _fee, uint256 _nonce, bytes4 _methodName, bytes memory _args) public virtual returns (bool);
756 }
757 
758 // File: contracts/BaseToken.sol
759 
760 pragma solidity >=0.6.0  <0.7.0;
761 
762 
763 
764 
765 
766 
767 abstract contract Basetoken is ERC20, ERC865Plus677ish {
768 
769     using SafeMath for uint256;
770     using ECDSA for bytes32;
771     using Address for address;
772 
773     /**
774     * Events
775     */
776 
777 
778     event MyLog( address indexed _from, uint256 _value);
779 
780 
781     // ownership
782     address public owner;
783     uint8 private _decimals;
784 
785     // nonces of transfers performed
786     mapping(bytes => bool) signatures;
787 
788 
789 
790     constructor(string memory name, string memory symbol ) ERC20(name, symbol) public {
791         owner = msg.sender;
792     }
793 
794     //**************** OVERRIDE ERC20 *******************************************************************************************
795     /**
796      * @dev Allows the current owner to transfer the ownership.
797      * @param _newOwner The address to transfer ownership to.
798      */
799     function transferOwnership(address _newOwner) public onlyOwner {
800         require(owner == msg.sender,'Only owner can transfer the ownership');
801         owner = _newOwner;
802     }
803 
804 
805     /**
806      * Minting functionality to multiples recipients
807      */
808     function mint(address[] memory _recipients, uint256[] memory _amounts) public onlyOwner  {
809         require(owner == msg.sender,'Only owner can add new tokens');
810         require(_recipients.length == _amounts.length,'Invalid size of recipients|amount');
811         require(_recipients.length <= 10,'Only allow mint 10 recipients');
812 
813         for (uint8 i = 0; i < _recipients.length; i++) {
814             address recipient = _recipients[i];
815             uint256 amount = _amounts[i];
816 
817             _mint(recipient, amount);
818         }
819     }
820 
821 
822 
823 
824 
825 
826     function doTransfer(address _from, address _to, uint256 _value, uint256 _fee, address _feeAddress) internal {
827         emit MyLog(_from,  _value);
828 
829         require(_to != address(0),'Invalid recipient address');
830 
831         uint256 total = _value.add(_fee);
832         require(total <= balanceOf(_from),'Insufficient funds');
833 
834 
835         emit MyLog(_from, _value);
836         myTransferFrom(_from,_to,_value);
837 
838         //Agregar el fee a la address fee
839         if(_fee > 0 && _feeAddress != address(0)) {
840             myTransferFrom(_from,_feeAddress,_fee);
841 
842         }
843 
844 
845     }
846 
847     /**
848       * @dev See {IERC20-transferFrom}.
849       *
850       * Emits an {Approval} event indicating the updated allowance. This is not
851       * required by the EIP. See the note at the beginning of {ERC20};
852       *
853       * Requirements:
854       * - `sender` and `recipient` cannot be the zero address.
855       * - `sender` must have a balance of at least `amount`.
856       * - the caller must have allowance for ``sender``'s tokens of at least
857       * `amount`.
858       */
859     function myTransferFrom(address from, address to, uint256 amount) public onlyOwner returns (bool) {
860         _transfer(from, to, amount);
861         //Check if allow use amount to spent
862         uint256 allowed= allowance(msg.sender, from);
863         uint256 diff=allowed.sub(amount);
864         _approve(from, msg.sender, diff);
865         return true;
866     }
867 
868 
869 
870     //**************** END OVERRIDE ERC20 *******************************************************************************************
871 
872 
873 
874 
875 
876 
877     //**************** FROM ERC865 *******************************************************************************************
878     function transferAndCall(address _to, uint256 _value, bytes4 _methodName, bytes memory _args) public override returns (bool) {
879         require(transferFromSender(_to, _value),'Invalid transfer from sender');
880 
881         emit TransferAndCall(msg.sender, _to, _value, _methodName, _args);
882 
883         // call receiver
884         require(Address.isContract(_to),'Address is not contract');
885 
886         (bool success, ) = _to.call(abi.encodePacked(abi.encodeWithSelector(_methodName, msg.sender, _value), _args));
887         require(success, 'Transfer unsuccesfully');
888         return success;
889     }
890 
891     //ERC 865 + delegate transfer and call
892     function transferPreSigned(bytes memory _signature, address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce) public override returns (bool) {
893 
894         require(!signatures[_signature],'Signature already used');
895 
896         bytes32 hashedTx = transferPreSignedHashing(address(this), _to, _value, _fee, _nonce);
897 
898         address from = ECDSA.recover(hashedTx, _signature);
899 
900         //if hashedTx does not fit to _signature Utils.recover resp. Solidity's ecrecover returns another (random) address,
901         //if this returned address does have enough tokens, they would be transferred, therefor we check if the retrieved
902         //signature is equal the specified one
903         require(from == _from,'Invalid sender1');
904         require(from != address(0),'Invalid sender address');
905 
906 
907 
908         doTransfer(from, _to, _value, _fee, msg.sender);
909         signatures[_signature] = true;
910 
911 
912         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
913         return true;
914     }
915 
916 
917     function transferAndCallPreSigned(bytes memory _signature, address _from, address _to, uint256 _value, uint256 _fee, uint256 _nonce,
918         bytes4 _methodName, bytes memory _args) public override returns (bool) {
919 
920         require(!signatures[_signature],'Signature already used');
921 
922         bytes32 hashedTx = transferAndCallPreSignedHashing(address(this), _to, _value, _fee, _nonce, _methodName, _args);
923         address from = ECDSA.recover(hashedTx, _signature);
924 
925         /**
926         *if hashedTx does not fit to _signature Utils.recover resp. Solidity's ecrecover returns another (random) address,
927         *if this returned address does have enough tokens, they would be transferred, therefor we check if the retrieved
928         *signature is equal the specified one
929         **/
930         require(from == _from,'Invalid sender');
931         require(from != address(0),'Invalid sender address');
932 
933         doTransfer(from, _to, _value, _fee, msg.sender);
934         signatures[_signature] = true;
935 
936 
937         emit TransferAndCallPreSigned(from, _to, msg.sender, _value, _fee, _methodName, _args);
938 
939         // call receiver
940         require(Address.isContract(_to),'Address is not contract');
941 
942         //call on behalf of from and not msg.sender
943         (bool success, ) = _to.call(abi.encodePacked(abi.encodeWithSelector(_methodName, from, _value), _args));
944         require(success);
945         return success;
946     }
947 
948     //**************** END FROM ERC865 *******************************************************************************************
949 
950 
951 
952 
953 
954 
955 
956     //*****************************UTILS FUNCTIONS****************************************************************
957     /**
958      * From: https://github.com/PROPSProject/props-token-distribution/blob/master/contracts/token/ERC865Token.sol
959      * adapted to: https://solidity.readthedocs.io/en/v0.5.3/050-breaking-changes.html?highlight=abi%20encode
960      * @notice Hash (keccak256) of the payload used by transferPreSigned
961      * @param _token address The address of the token.
962      * @param _to address The address which you want to transfer to.
963      * @param _value uint256 The amount of tokens to be transferred.
964      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
965      */
966     function transferAndCallPreSignedHashing(address _token, address _to, uint256 _value, uint256 _fee, uint256 _nonce,
967         bytes4 _methodName, bytes memory _args) internal pure returns (bytes32) {
968         /* "38980f82": transferAndCallPreSignedHashing(address,address,uint256,uint256,uint256,bytes4,bytes) */
969         return keccak256(abi.encode(bytes4(0x38980f82), _token, _to, _value, _fee, _nonce, _methodName, _args));
970     }
971 
972     function transferPreSignedHashing(address _token, address _to, uint256 _value, uint256 _fee, uint256 _nonce)
973     internal pure returns (bytes32) {
974         /* "15420b71": transferPreSignedHashing(address,address,uint256,uint256,uint256) */
975         return keccak256(abi.encode(bytes4(0x15420b71), _token, _to, _value, _fee, _nonce));
976     }
977 
978 
979     function transferFromSender(address _to, uint256 _value) private returns (bool) {
980         doTransfer(msg.sender, _to, _value, 0, address(0));
981         return true;
982     }
983 
984     modifier onlyOwner() {
985         require(msg.sender == owner, "Access denied");
986         _;
987     }
988 
989 
990     //*****************************END UTILS FUNCTIONS**********************************************************
991 
992 }
993 
994 // File: contracts/COPCB.sol
995 
996 contract COPCB is Basetoken{
997 
998     constructor() Basetoken("Pesos Colombianos", "COPCB") public{
999 
1000     }
1001 }