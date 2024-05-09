1 // Parsiq Token
2 pragma solidity 0.5.11;
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
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, "SafeMath: division by zero");
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95      * Reverts when dividing by zero.
96      *
97      * Counterpart to Solidity's `%` operator. This function uses a `revert`
98      * opcode (which leaves remaining gas untouched) while Solidity uses an
99      * invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "SafeMath: modulo by zero");
106         return a % b;
107     }
108 }
109 
110 
111 /**
112  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
113  *
114  * These functions can be used to verify that a message was signed by the holder
115  * of the private keys of a given address.
116  */
117 library ECDSA {
118     /**
119      * @dev Returns the address that signed a hashed message (`hash`) with
120      * `signature`. This address can then be used for verification purposes.
121      *
122      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
123      * this function rejects them by requiring the `s` value to be in the lower
124      * half order, and the `v` value to be either 27 or 28.
125      *
126      * (.note) This call _does not revert_ if the signature is invalid, or
127      * if the signer is otherwise unable to be retrieved. In those scenarios,
128      * the zero address is returned.
129      *
130      * (.warning) `hash` _must_ be the result of a hash operation for the
131      * verification to be secure: it is possible to craft signatures that
132      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
133      * this is by receiving a hash of the original message (which may otherwise)
134      * be too long), and then calling `toEthSignedMessageHash` on it.
135      */
136     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
137         // Check the signature length
138         if (signature.length != 65) {
139             return (address(0));
140         }
141 
142         // Divide the signature in r, s and v variables
143         bytes32 r;
144         bytes32 s;
145         uint8 v;
146 
147         // ecrecover takes the signature parameters, and the only way to get them
148         // currently is to use assembly.
149         // solhint-disable-next-line no-inline-assembly
150         assembly {
151             r := mload(add(signature, 0x20))
152             s := mload(add(signature, 0x40))
153             v := byte(0, mload(add(signature, 0x60)))
154         }
155 
156         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
157         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
158         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
159         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
160         //
161         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
162         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
163         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
164         // these malleable signatures as well.
165         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
166             return address(0);
167         }
168 
169         if (v != 27 && v != 28) {
170             return address(0);
171         }
172 
173         // If the signature is valid (and not malleable), return the signer address
174         return ecrecover(hash, v, r, s);
175     }
176 
177     /**
178      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
179      * replicates the behavior of the
180      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
181      * JSON-RPC method.
182      *
183      * See `recover`.
184      */
185     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
186         // 32 is the length in bytes of hash,
187         // enforced by the type signature above
188         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
189     }
190 }
191 
192 /**
193  * @dev Collection of functions related to the address type,
194  */
195 library Address {
196     /**
197      * @dev Returns true if `account` is a contract.
198      *
199      * This test is non-exhaustive, and there may be false-negatives: during the
200      * execution of a contract's constructor, its address will be reported as
201      * not containing a contract.
202      *
203      * > It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      */
206     function isContract(address account) internal view returns (bool) {
207         // This method relies in extcodesize, which returns 0 for contracts in
208         // construction, since the code is only stored at the end of the
209         // constructor execution.
210 
211         uint256 size;
212         // solhint-disable-next-line no-inline-assembly
213         assembly { size := extcodesize(account) }
214         return size > 0;
215     }
216 }
217 
218 /**
219  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
220  * the optional functions; to access them see `ERC20Detailed`.
221  */
222 interface IERC20 {
223     /**
224      * @dev Returns the amount of tokens in existence.
225      */
226     function totalSupply() external view returns (uint256);
227 
228     /**
229      * @dev Returns the amount of tokens owned by `account`.
230      */
231     function balanceOf(address account) external view returns (uint256);
232 
233     /**
234      * @dev Moves `amount` tokens from the caller's account to `recipient`.
235      *
236      * Returns a boolean value indicating whether the operation succeeded.
237      *
238      * Emits a `Transfer` event.
239      */
240     function transfer(address recipient, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Returns the remaining number of tokens that `spender` will be
244      * allowed to spend on behalf of `owner` through `transferFrom`. This is
245      * zero by default.
246      *
247      * This value changes when `approve` or `transferFrom` are called.
248      */
249     function allowance(address owner, address spender) external view returns (uint256);
250 
251     /**
252      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
253      *
254      * Returns a boolean value indicating whether the operation succeeded.
255      *
256      * > Beware that changing an allowance with this method brings the risk
257      * that someone may use both the old and the new allowance by unfortunate
258      * transaction ordering. One possible solution to mitigate this race
259      * condition is to first reduce the spender's allowance to 0 and set the
260      * desired value afterwards:
261      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
262      *
263      * Emits an `Approval` event.
264      */
265     function approve(address spender, uint256 amount) external returns (bool);
266 
267     /**
268      * @dev Moves `amount` tokens from `sender` to `recipient` using the
269      * allowance mechanism. `amount` is then deducted from the caller's
270      * allowance.
271      *
272      * Returns a boolean value indicating whether the operation succeeded.
273      *
274      * Emits a `Transfer` event.
275      */
276     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
277 
278     /**
279      * @dev Emitted when `value` tokens are moved from one account (`from`) to
280      * another (`to`).
281      *
282      * Note that `value` may be zero.
283      */
284     event Transfer(address indexed from, address indexed to, uint256 value);
285 
286     /**
287      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
288      * a call to `approve`. `value` is the new allowance.
289      */
290     event Approval(address indexed owner, address indexed spender, uint256 value);
291 }
292 
293 /**
294  * @dev Implementation of the `IERC20` interface.
295  *
296  * This implementation is agnostic to the way tokens are created. This means
297  * that a supply mechanism has to be added in a derived contract using `_mint`.
298  * For a generic mechanism see `ERC20Mintable`.
299  *
300  * *For a detailed writeup see our guide [How to implement supply
301  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
302  *
303  * We have followed general OpenZeppelin guidelines: functions revert instead
304  * of returning `false` on failure. This behavior is nonetheless conventional
305  * and does not conflict with the expectations of ERC20 applications.
306  *
307  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
308  * This allows applications to reconstruct the allowance for all accounts just
309  * by listening to said events. Other implementations of the EIP may not emit
310  * these events, as it isn't required by the specification.
311  *
312  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
313  * functions have been added to mitigate the well-known issues around setting
314  * allowances. See `IERC20.approve`.
315  */
316 contract ERC20 is IERC20 {
317     using SafeMath for uint256;
318 
319     mapping (address => uint256) private _balances;
320 
321     mapping (address => mapping (address => uint256)) private _allowances;
322 
323     uint256 private _totalSupply;
324 
325     /**
326      * @dev See `IERC20.totalSupply`.
327      */
328     function totalSupply() public view returns (uint256) {
329         return _totalSupply;
330     }
331 
332     /**
333      * @dev See `IERC20.balanceOf`.
334      */
335     function balanceOf(address account) public view returns (uint256) {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See `IERC20.transfer`.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount) public returns (bool) {
348         _transfer(msg.sender, recipient, amount);
349         return true;
350     }
351 
352     /**
353      * @dev See `IERC20.allowance`.
354      */
355     function allowance(address owner, address spender) public view returns (uint256) {
356         return _allowances[owner][spender];
357     }
358 
359     /**
360      * @dev See `IERC20.approve`.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 value) public returns (bool) {
367         _approve(msg.sender, spender, value);
368         return true;
369     }
370 
371     /**
372      * @dev See `IERC20.transferFrom`.
373      *
374      * Emits an `Approval` event indicating the updated allowance. This is not
375      * required by the EIP. See the note at the beginning of `ERC20`;
376      *
377      * Requirements:
378      * - `sender` and `recipient` cannot be the zero address.
379      * - `sender` must have a balance of at least `value`.
380      * - the caller must have allowance for `sender`'s tokens of at least
381      * `amount`.
382      */
383     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
384         _transfer(sender, recipient, amount);
385         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
386         return true;
387     }
388 
389     /**
390      * @dev Atomically increases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to `approve` that can be used as a mitigation for
393      * problems described in `IERC20.approve`.
394      *
395      * Emits an `Approval` event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
402         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to `approve` that can be used as a mitigation for
410      * problems described in `IERC20.approve`.
411      *
412      * Emits an `Approval` event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
421         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
422         return true;
423     }
424 
425     /**
426      * @dev Moves tokens `amount` from `sender` to `recipient`.
427      *
428      * This is internal function is equivalent to `transfer`, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a `Transfer` event.
432      *
433      * Requirements:
434      *
435      * - `sender` cannot be the zero address.
436      * - `recipient` cannot be the zero address.
437      * - `sender` must have a balance of at least `amount`.
438      */
439     function _transfer(address sender, address recipient, uint256 amount) internal {
440         require(sender != address(0), "ERC20: transfer from the zero address");
441         require(recipient != address(0), "ERC20: transfer to the zero address");
442 
443         _balances[sender] = _balances[sender].sub(amount);
444         _balances[recipient] = _balances[recipient].add(amount);
445         emit Transfer(sender, recipient, amount);
446     }
447 
448     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
449      * the total supply.
450      *
451      * Emits a `Transfer` event with `from` set to the zero address.
452      *
453      * Requirements
454      *
455      * - `to` cannot be the zero address.
456      */
457     function _mint(address account, uint256 amount) internal {
458         require(account != address(0), "ERC20: mint to the zero address");
459 
460         _totalSupply = _totalSupply.add(amount);
461         _balances[account] = _balances[account].add(amount);
462         emit Transfer(address(0), account, amount);
463     }
464 
465      /**
466      * @dev Destoys `amount` tokens from `account`, reducing the
467      * total supply.
468      *
469      * Emits a `Transfer` event with `to` set to the zero address.
470      *
471      * Requirements
472      *
473      * - `account` cannot be the zero address.
474      * - `account` must have at least `amount` tokens.
475      */
476     function _burn(address account, uint256 value) internal {
477         require(account != address(0), "ERC20: burn from the zero address");
478 
479         _totalSupply = _totalSupply.sub(value);
480         _balances[account] = _balances[account].sub(value);
481         emit Transfer(account, address(0), value);
482     }
483 
484     /**
485      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
486      *
487      * This is internal function is equivalent to `approve`, and can be used to
488      * e.g. set automatic allowances for certain subsystems, etc.
489      *
490      * Emits an `Approval` event.
491      *
492      * Requirements:
493      *
494      * - `owner` cannot be the zero address.
495      * - `spender` cannot be the zero address.
496      */
497     function _approve(address owner, address spender, uint256 value) internal {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = value;
502         emit Approval(owner, spender, value);
503     }
504 
505     /**
506      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
507      * from the caller's allowance.
508      *
509      * See `_burn` and `_approve`.
510      */
511     function _burnFrom(address account, uint256 amount) internal {
512         _burn(account, amount);
513         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
514     }
515 }
516 
517 /**
518  * @title SafeERC20
519  * @dev Wrappers around ERC20 operations that throw on failure (when the token
520  * contract returns false). Tokens that return no value (and instead revert or
521  * throw on failure) are also supported, non-reverting calls are assumed to be
522  * successful.
523  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
524  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
525  */
526 library SafeERC20 {
527     using SafeMath for uint256;
528     using Address for address;
529 
530     function safeTransfer(IERC20 token, address to, uint256 value) internal {
531         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
532     }
533 
534     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
535         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
536     }
537 
538     function safeApprove(IERC20 token, address spender, uint256 value) internal {
539         // safeApprove should only be called when setting an initial allowance,
540         // or when resetting it to zero. To increase and decrease it, use
541         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
542         // solhint-disable-next-line max-line-length
543         require((value == 0) || (token.allowance(address(this), spender) == 0),
544             "SafeERC20: approve from non-zero to non-zero allowance"
545         );
546         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
547     }
548 
549     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
550         uint256 newAllowance = token.allowance(address(this), spender).add(value);
551         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
552     }
553 
554     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
555         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
556         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
557     }
558 
559     /**
560      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
561      * on the return value: the return value is optional (but if data is returned, it must not be false).
562      * @param token The token targeted by the call.
563      * @param data The call data (encoded using abi.encode or one of its variants).
564      */
565     function callOptionalReturn(IERC20 token, bytes memory data) private {
566         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
567         // we're implementing it ourselves.
568 
569         // A Solidity high level call has three parts:
570         //  1. The target address is checked to verify it contains contract code
571         //  2. The call itself is made, and success asserted
572         //  3. The return value is decoded, which in turn checks the size of the returned data.
573         // solhint-disable-next-line max-line-length
574         require(address(token).isContract(), "SafeERC20: call to non-contract");
575 
576         // solhint-disable-next-line avoid-low-level-calls
577         (bool success, bytes memory returndata) = address(token).call(data);
578         require(success, "SafeERC20: low-level call failed");
579 
580         if (returndata.length > 0) { // Return data is optional
581             // solhint-disable-next-line max-line-length
582             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
583         }
584     }
585 }
586 
587 /**
588  * @dev Contract module which provides a basic access control mechanism, where
589  * there is an account (an owner) that can be granted exclusive access to
590  * specific functions.
591  *
592  * This module is used through inheritance. It will make available the modifier
593  * `onlyOwner`, which can be aplied to your functions to restrict their use to
594  * the owner.
595  */
596 contract Ownable {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600 
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () internal {
605         _owner = msg.sender;
606         emit OwnershipTransferred(address(0), _owner);
607     }
608 
609     /**
610      * @dev Returns the address of the current owner.
611      */
612     function owner() public view returns (address) {
613         return _owner;
614     }
615 
616     /**
617      * @dev Throws if called by any account other than the owner.
618      */
619     modifier onlyOwner() {
620         require(isOwner(), "Ownable: caller is not the owner");
621         _;
622     }
623 
624     /**
625      * @dev Returns true if the caller is the current owner.
626      */
627     function isOwner() public view returns (bool) {
628         return msg.sender == _owner;
629     }
630 
631     /**
632      * @dev Leaves the contract without owner. It will not be possible to call
633      * `onlyOwner` functions anymore. Can only be called by the current owner.
634      *
635      * > Note: Renouncing ownership will leave the contract without an owner,
636      * thereby removing any functionality that is only available to the owner.
637      */
638     function renounceOwnership() public onlyOwner {
639         emit OwnershipTransferred(_owner, address(0));
640         _owner = address(0);
641     }
642 
643     /**
644      * @dev Transfers ownership of the contract to a new account (`newOwner`).
645      * Can only be called by the current owner.
646      */
647     function transferOwnership(address newOwner) public onlyOwner {
648         _transferOwnership(newOwner);
649     }
650 
651     /**
652      * @dev Transfers ownership of the contract to a new account (`newOwner`).
653      */
654     function _transferOwnership(address newOwner) internal {
655         require(newOwner != address(0), "Ownable: new owner is the zero address");
656         emit OwnershipTransferred(_owner, newOwner);
657         _owner = newOwner;
658     }
659 }
660 
661 
662 interface ITokenReceiver {
663     function tokensReceived(
664         address from,
665         address to,
666         uint256 amount
667     ) external;
668 }
669 
670 
671 interface ITokenMigrator {
672     function migrate(address from, address to, uint256 amount) external returns (bool);
673 }
674 
675 contract TokenRecoverable is Ownable {
676     using SafeERC20 for IERC20;
677 
678     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyOwner {
679         uint256 balance = token.balanceOf(address(this));
680         require(balance >= amount, "Given amount is larger than current balance");
681         token.safeTransfer(to, amount);
682     }
683 }
684 
685 contract Burner is TokenRecoverable, ITokenReceiver {
686     address payable public token;
687 
688     address public migrator;
689 
690     constructor(address payable _token) public TokenRecoverable() {
691         token = _token;
692     }
693 
694     function setMigrator(address _migrator) public onlyOwner {
695         migrator = _migrator;
696     }
697 
698     function tokensReceived(address from, address to, uint256 amount) external {
699         require(token != address(0), "Burner is not initialized");
700         require(msg.sender == token, "Only Parsiq Token can notify");
701         require(ParsiqToken(token).burningEnabled(), "Burning is disabled");
702         if (migrator != address(0)) {
703             ITokenMigrator(migrator).migrate(from, to, amount);
704         }
705         ParsiqToken(token).burn(amount);
706     }
707 }
708 
709 
710 contract ParsiqToken is TokenRecoverable, ERC20 {
711     using SafeMath for uint256;
712     using ECDSA for bytes32;
713     using Address for address;
714 
715     uint256 internal constant MAX_UINT256 = ~uint256(0);
716     uint256 internal constant TOTAL_TOKENS = 500000000e18; // 500 000 000 tokens
717     string public constant name = "Parsiq Token";
718     string public constant symbol = "PRQ";
719     uint8 public constant decimals = uint8(18);
720 
721     mapping(address => bool) public notify;
722     mapping(address => Timelock[]) public timelocks;
723     mapping(address => Timelock[]) public relativeTimelocks;
724     mapping(bytes32 => bool) public hashedTxs;
725     mapping(address => bool) public whitelisted;
726     uint256 public transfersUnlockTime = MAX_UINT256; // MAX_UINT256 - transfers locked
727     address public burnerAddress;
728     bool public burningEnabled;
729     bool public etherlessTransferEnabled = true;
730 
731     struct Timelock {
732         uint256 time;
733         uint256 amount;
734     }
735 
736     event TransferPreSigned(
737         address indexed from,
738         address indexed to,
739         address indexed delegate,
740         uint256 amount,
741         uint256 fee);
742     event TransferLocked(address indexed from, address indexed to, uint256 amount, uint256 until);
743     event TransferLockedRelative(address indexed from, address indexed to, uint256 amount, uint256 duration);
744     event Released(address indexed to, uint256 amount);
745     event WhitelistedAdded(address indexed account);
746     event WhitelistedRemoved(address indexed account);
747 
748     modifier onlyWhenEtherlessTransferEnabled {
749         require(etherlessTransferEnabled == true, "Etherless transfer functionality disabled");
750         _;
751     }
752     
753     modifier onlyBurner() {
754         require(msg.sender == burnerAddress, "Only burnAddress can burn tokens");
755         _;
756     }
757 
758     modifier onlyWhenTransfersUnlocked(address from, address to) {
759         require(
760             transfersUnlockTime <= now ||
761             whitelisted[from] == true ||
762             whitelisted[to] == true, "Transfers locked");
763         _;
764     }
765 
766     modifier onlyWhitelisted() {
767         require(whitelisted[msg.sender] == true, "Not whitelisted");
768         _;
769     }
770 
771     modifier notTokenAddress(address _address) {
772         require(_address != address(this), "Cannot transfer to token contract");
773         _;
774     }
775 
776     modifier notBurnerUntilBurnIsEnabled(address _address) {
777         require(burningEnabled == true || _address != burnerAddress, "Cannot transfer to burner address, until burning is not enabled");
778         _;
779     }
780 
781     constructor() public TokenRecoverable() {
782         _mint(msg.sender, TOTAL_TOKENS);
783         _addWhitelisted(msg.sender);
784         burnerAddress = address(new Burner(address(this)));
785         notify[burnerAddress] = true; // Manually register Burner, because it cannot call register() while token constructor is not complete
786         Burner(burnerAddress).transferOwnership(msg.sender);
787     }
788 
789     function () external payable {
790         _release(msg.sender);
791         if (msg.value > 0) {
792             msg.sender.transfer(msg.value);
793         }
794     }
795 
796     function register() public {
797         notify[msg.sender] = true;
798     }
799 
800     function unregister() public {
801         notify[msg.sender] = false;
802     }
803 
804     function enableEtherlessTransfer() public onlyOwner {
805         etherlessTransferEnabled = true;
806     }
807 
808     function disableEtherlessTransfer() public onlyOwner {
809         etherlessTransferEnabled = false;
810     }
811 
812     function addWhitelisted(address _address) public onlyOwner {
813         _addWhitelisted(_address);
814     }
815 
816     function removeWhitelisted(address _address) public onlyOwner {
817         _removeWhitelisted(_address);
818     }
819 
820     function renounceWhitelisted() public {
821         _removeWhitelisted(msg.sender);
822     }
823 
824     function transferOwnership(address newOwner) public onlyOwner {
825         _removeWhitelisted(owner());
826         super.transferOwnership(newOwner);
827         _addWhitelisted(newOwner);
828     }
829 
830     function renounceOwnership() public onlyOwner {
831         renounceWhitelisted();
832         super.renounceOwnership();
833     }
834 
835     function unlockTransfers(uint256 when) public onlyOwner {
836         require(transfersUnlockTime == MAX_UINT256, "Transfers already unlocked");
837         require(when >= now, "Transfer unlock must not be in past");
838         transfersUnlockTime = when;
839     }
840 
841     function transfer(address to, uint256 value) public
842         onlyWhenTransfersUnlocked(msg.sender, to)
843         notTokenAddress(to)
844         notBurnerUntilBurnIsEnabled(to)
845         returns (bool)
846     {
847         bool success = super.transfer(to, value);
848         if (success) {
849             _postTransfer(msg.sender, to, value);
850         }
851         return success;
852     }
853 
854     function transferFrom(address from, address to, uint256 value) public
855         onlyWhenTransfersUnlocked(from, to)
856         notTokenAddress(to)
857         notBurnerUntilBurnIsEnabled(to)
858         returns (bool)
859     {
860         bool success = super.transferFrom(from, to, value);
861         if (success) {
862             _postTransfer(from, to, value);
863         }
864         return success;
865     }
866 
867     // We do not limit batch size, it's up to caller to determine maximum batch size/gas limit
868     function transferBatch(address[] memory to, uint256[] memory value) public returns (bool) {
869         require(to.length == value.length, "Array sizes must be equal");
870         uint256 n = to.length;
871         for (uint256 i = 0; i < n; i++) {
872             transfer(to[i], value[i]);
873         }
874         return true;
875     }
876 
877     function transferLocked(address to, uint256 value, uint256 until) public
878         onlyWhitelisted
879         notTokenAddress(to)
880         returns (bool)
881     {
882         require(to != address(0), "ERC20: transfer to the zero address");
883         require(value > 0, "Value must be positive");
884         require(until > now, "Until must be future value");
885         require(timelocks[to].length.add(relativeTimelocks[to].length) <= 100, "Too many locks on address");
886 
887         _transfer(msg.sender, address(this), value);
888 
889         timelocks[to].push(Timelock({ time: until, amount: value }));
890 
891         emit TransferLocked(msg.sender, to, value, until);
892         return true;
893     }
894 
895     /**
896     This function is analogue to transferLocked(), but uses relative time locks to synchornize
897     with transfer unlocking time
898      */
899     function transferLockedRelative(address to, uint256 value, uint256 duration) public
900         onlyWhitelisted
901         notTokenAddress(to)
902         returns (bool)
903     {
904         require(transfersUnlockTime > now, "Relative locks are disabled. Use transferLocked() instead");
905         require(to != address(0), "ERC20: transfer to the zero address");
906         require(value > 0, "Value must be positive");
907         require(timelocks[to].length.add(relativeTimelocks[to].length) <= 100, "Too many locks on address");
908 
909         _transfer(msg.sender, address(this), value);
910 
911         relativeTimelocks[to].push(Timelock({ time: duration, amount: value }));
912 
913         emit TransferLockedRelative(msg.sender, to, value, duration);
914         return true;
915     }
916 
917     function release() public {
918         _release(msg.sender);
919     }
920 
921     function lockedBalanceOf(address who) public view returns (uint256) {
922         return _lockedBalanceOf(timelocks[who])
923             .add(_lockedBalanceOf(relativeTimelocks[who]));
924     }
925     
926     function unlockableBalanceOf(address who) public view returns (uint256) {
927         uint256 tokens = _unlockableBalanceOf(timelocks[who], 0);
928         if (transfersUnlockTime > now) return tokens;
929 
930         return tokens.add(_unlockableBalanceOf(relativeTimelocks[who], transfersUnlockTime));
931     }
932 
933     function totalBalanceOf(address who) public view returns (uint256) {
934         return balanceOf(who).add(lockedBalanceOf(who));
935     }
936 
937     /**
938      * @dev Burns a specific amount of tokens.
939      * @param value The amount of token to be burned.
940      */
941     function burn(uint256 value) public onlyBurner {
942         _burn(msg.sender, value);
943     }
944 
945     function enableBurning() public onlyOwner {
946         burningEnabled = true;
947     }
948 
949     /** Etherless Transfer (ERC865 based) */
950     /**
951      * @notice Submit a presigned transfer
952      * @param _signature bytes The signature, issued by the owner.
953      * @param _to address The address which you want to transfer to.
954      * @param _value uint256 The amount of tokens to be transferred.
955      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
956      * @param _nonce uint256 Presigned transaction number. Should be unique, per user.
957      */
958     function transferPreSigned(
959         bytes memory _signature,
960         address _to,
961         uint256 _value,
962         uint256 _fee,
963         uint256 _nonce
964     )
965         public
966         onlyWhenEtherlessTransferEnabled
967         notTokenAddress(_to)
968         notBurnerUntilBurnIsEnabled(_to)
969         returns (bool)
970     {
971         require(_to != address(0), "Transfer to the zero address");
972 
973         bytes32 hashedParams = hashForSign(msg.sig, address(this), _to, _value, _fee, _nonce);
974         address from = hashedParams.toEthSignedMessageHash().recover(_signature);
975         require(from != address(0), "Invalid signature");
976 
977         require(
978             transfersUnlockTime <= now ||
979             whitelisted[from] == true ||
980             whitelisted[_to] == true, "Transfers are locked");
981 
982         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
983         require(hashedTxs[hashedTx] == false, "Nonce already used");
984         hashedTxs[hashedTx] = true;
985 
986         if (msg.sender == _to) {
987             _transfer(from, _to, _value.add(_fee));
988             _postTransfer(from, _to, _value.add(_fee));
989         } else {
990             _transfer(from, _to, _value);
991             _postTransfer(from, _to, _value);
992             _transfer(from, msg.sender, _fee);
993             _postTransfer(from, msg.sender, _fee);
994         }
995 
996         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
997         return true;
998     }
999 
1000     /**
1001      * @notice Hash (keccak256) of the payload used by transferPreSigned
1002      * @param _token address The address of the token.
1003      * @param _to address The address which you want to transfer to.
1004      * @param _value uint256 The amount of tokens to be transferred.
1005      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
1006      * @param _nonce uint256 Presigned transaction number.
1007      */
1008     function hashForSign(
1009         bytes4 _selector,
1010         address _token,
1011         address _to,
1012         uint256 _value,
1013         uint256 _fee,
1014         uint256 _nonce
1015     )
1016         public
1017         pure
1018         returns (bytes32)
1019     {
1020         return keccak256(abi.encodePacked(_selector, _token, _to, _value, _fee, _nonce));
1021     }
1022 
1023     function releasePreSigned(bytes memory _signature, uint256 _fee, uint256 _nonce)
1024         public
1025         onlyWhenEtherlessTransferEnabled
1026         returns (bool)
1027     {
1028         bytes32 hashedParams = hashForReleaseSign(msg.sig, address(this), _fee, _nonce);
1029         address from = hashedParams.toEthSignedMessageHash().recover(_signature);
1030         require(from != address(0), "Invalid signature");
1031 
1032         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
1033         require(hashedTxs[hashedTx] == false, "Nonce already used");
1034         hashedTxs[hashedTx] = true;
1035 
1036         uint256 released = _release(from);
1037         require(released > _fee, "Too small release");
1038         if (from != msg.sender) { // "from" already have all the tokens, no need to charge
1039             _transfer(from, msg.sender, _fee);
1040             _postTransfer(from, msg.sender, _fee);
1041         }
1042         return true;
1043     }
1044 
1045     /**
1046      * @notice Hash (keccak256) of the payload used by transferPreSigned
1047      * @param _token address The address of the token.
1048      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
1049      * @param _nonce uint256 Presigned transaction number.
1050      */
1051     function hashForReleaseSign(
1052         bytes4 _selector,
1053         address _token,
1054         uint256 _fee,
1055         uint256 _nonce
1056     )
1057         public
1058         pure
1059         returns (bytes32)
1060     {
1061         return keccak256(abi.encodePacked(_selector, _token, _fee, _nonce));
1062     }
1063 
1064     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyOwner {
1065         require(address(token) != address(this), "Cannot recover Parsiq tokens");
1066         super.recoverTokens(token, to,  amount);
1067     }
1068 
1069     function _release(address beneficiary) internal
1070         notBurnerUntilBurnIsEnabled(beneficiary)
1071         returns (uint256) {
1072         uint256 tokens = _releaseLocks(timelocks[beneficiary], 0);
1073         if (transfersUnlockTime <= now) {
1074             tokens = tokens.add(_releaseLocks(relativeTimelocks[beneficiary], transfersUnlockTime));
1075         }
1076 
1077         if (tokens == 0) return 0;
1078         _transfer(address(this), beneficiary, tokens);
1079         _postTransfer(address(this), beneficiary, tokens);
1080         emit Released(beneficiary, tokens);
1081         return tokens;
1082     }
1083 
1084     function _releaseLocks(Timelock[] storage locks, uint256 relativeTime) internal returns (uint256) {
1085         uint256 tokens = 0;
1086         uint256 lockCount = locks.length;
1087         uint256 i = lockCount;
1088         while (i > 0) {
1089             i--;
1090             Timelock storage timelock = locks[i]; 
1091             if (relativeTime.add(timelock.time) > now) continue;
1092             
1093             tokens = tokens.add(timelock.amount);
1094             lockCount--;
1095             if (i != lockCount) {
1096                 locks[i] = locks[lockCount];
1097             }
1098         }
1099         locks.length = lockCount;
1100         return tokens;
1101     }
1102 
1103     function _lockedBalanceOf(Timelock[] storage locks) internal view returns (uint256) {
1104         uint256 tokens = 0;
1105         uint256 n = locks.length;
1106         for (uint256 i = 0; i < n; i++) {
1107             tokens = tokens.add(locks[i].amount);
1108         }
1109         return tokens;
1110     }
1111 
1112     function _unlockableBalanceOf(Timelock[] storage locks, uint256 relativeTime) internal view returns (uint256) {
1113         uint256 tokens = 0;
1114         uint256 n = locks.length;
1115         for (uint256 i = 0; i < n; i++) {
1116             Timelock storage timelock = locks[i];
1117             if (relativeTime.add(timelock.time) <= now) {
1118                 tokens = tokens.add(timelock.amount);
1119             }
1120         }
1121         return tokens;
1122     }
1123 
1124     function _postTransfer(address from, address to, uint256 value) internal {
1125         if (!to.isContract()) return;
1126         if (notify[to] == false) return;
1127 
1128         ITokenReceiver(to).tokensReceived(from, to, value);
1129     }
1130 
1131     function _addWhitelisted(address _address) internal {
1132         whitelisted[_address] = true;
1133         emit WhitelistedAdded(_address);
1134     }
1135 
1136     function _removeWhitelisted(address _address) internal {
1137         whitelisted[_address] = false;
1138         emit WhitelistedRemoved(_address);
1139     }
1140 }