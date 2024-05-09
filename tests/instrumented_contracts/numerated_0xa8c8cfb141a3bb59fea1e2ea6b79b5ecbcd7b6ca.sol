1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-04
3 */
4 
5 pragma solidity 0.5.10;
6 /* Source code for NOIA Token */
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SafeMath: subtraction overflow");
48         uint256 c = a - b;
49 
50         return c;
51     }
52 
53     /**
54      * @dev Returns the multiplication of two unsigned integers, reverting on
55      * overflow.
56      *
57      * Counterpart to Solidity's `*` operator.
58      *
59      * Requirements:
60      * - Multiplication cannot overflow.
61      */
62     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
63         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
64         // benefit is lost if 'b' is also tested.
65         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the integer division of two unsigned integers. Reverts on
78      * division by zero. The result is rounded towards zero.
79      *
80      * Counterpart to Solidity's `/` operator. Note: this function uses a
81      * `revert` opcode (which leaves remaining gas untouched) while Solidity
82      * uses an invalid opcode to revert (consuming all remaining gas).
83      *
84      * Requirements:
85      * - The divisor cannot be zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0, "SafeMath: division by zero");
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
98      * Reverts when dividing by zero.
99      *
100      * Counterpart to Solidity's `%` operator. This function uses a `revert`
101      * opcode (which leaves remaining gas untouched) while Solidity uses an
102      * invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      */
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         require(b != 0, "SafeMath: modulo by zero");
109         return a % b;
110     }
111 }
112 
113 /**
114  * @dev Collection of functions related to the address type,
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * This test is non-exhaustive, and there may be false-negatives: during the
121      * execution of a contract's constructor, its address will be reported as
122      * not containing a contract.
123      *
124      * > It is unsafe to assume that an address for which this function returns
125      * false is an externally-owned account (EOA) and not a contract.
126      */
127     function isContract(address account) internal view returns (bool) {
128         // This method relies in extcodesize, which returns 0 for contracts in
129         // construction, since the code is only stored at the end of the
130         // constructor execution.
131 
132         uint256 size;
133         // solhint-disable-next-line no-inline-assembly
134         assembly { size := extcodesize(account) }
135         return size > 0;
136     }
137 }
138 
139 
140 /**
141  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
142  *
143  * These functions can be used to verify that a message was signed by the holder
144  * of the private keys of a given address.
145  */
146 library ECDSA {
147     /**
148      * @dev Returns the address that signed a hashed message (`hash`) with
149      * `signature`. This address can then be used for verification purposes.
150      *
151      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
152      * this function rejects them by requiring the `s` value to be in the lower
153      * half order, and the `v` value to be either 27 or 28.
154      *
155      * (.note) This call _does not revert_ if the signature is invalid, or
156      * if the signer is otherwise unable to be retrieved. In those scenarios,
157      * the zero address is returned.
158      *
159      * (.warning) `hash` _must_ be the result of a hash operation for the
160      * verification to be secure: it is possible to craft signatures that
161      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
162      * this is by receiving a hash of the original message (which may otherwise)
163      * be too long), and then calling `toEthSignedMessageHash` on it.
164      */
165     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
166         // Check the signature length
167         if (signature.length != 65) {
168             return (address(0));
169         }
170 
171         // Divide the signature in r, s and v variables
172         bytes32 r;
173         bytes32 s;
174         uint8 v;
175 
176         // ecrecover takes the signature parameters, and the only way to get them
177         // currently is to use assembly.
178         // solhint-disable-next-line no-inline-assembly
179         assembly {
180             r := mload(add(signature, 0x20))
181             s := mload(add(signature, 0x40))
182             v := byte(0, mload(add(signature, 0x60)))
183         }
184 
185         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
186         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
187         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
188         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
189         //
190         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
191         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
192         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
193         // these malleable signatures as well.
194         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
195             return address(0);
196         }
197 
198         if (v != 27 && v != 28) {
199             return address(0);
200         }
201 
202         // If the signature is valid (and not malleable), return the signer address
203         return ecrecover(hash, v, r, s);
204     }
205 
206     /**
207      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
208      * replicates the behavior of the
209      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
210      * JSON-RPC method.
211      *
212      * See `recover`.
213      */
214     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
215         // 32 is the length in bytes of hash,
216         // enforced by the type signature above
217         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
218     }
219 }
220 
221 
222 /**
223  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
224  * the optional functions; to access them see `ERC20Detailed`.
225  */
226 interface IERC20 {
227     /**
228      * @dev Returns the amount of tokens in existence.
229      */
230     function totalSupply() external view returns (uint256);
231 
232     /**
233      * @dev Returns the amount of tokens owned by `account`.
234      */
235     function balanceOf(address account) external view returns (uint256);
236 
237     /**
238      * @dev Moves `amount` tokens from the caller's account to `recipient`.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * Emits a `Transfer` event.
243      */
244     function transfer(address recipient, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Returns the remaining number of tokens that `spender` will be
248      * allowed to spend on behalf of `owner` through `transferFrom`. This is
249      * zero by default.
250      *
251      * This value changes when `approve` or `transferFrom` are called.
252      */
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     /**
256      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
257      *
258      * Returns a boolean value indicating whether the operation succeeded.
259      *
260      * > Beware that changing an allowance with this method brings the risk
261      * that someone may use both the old and the new allowance by unfortunate
262      * transaction ordering. One possible solution to mitigate this race
263      * condition is to first reduce the spender's allowance to 0 and set the
264      * desired value afterwards:
265      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266      *
267      * Emits an `Approval` event.
268      */
269     function approve(address spender, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Moves `amount` tokens from `sender` to `recipient` using the
273      * allowance mechanism. `amount` is then deducted from the caller's
274      * allowance.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a `Transfer` event.
279      */
280     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Emitted when `value` tokens are moved from one account (`from`) to
284      * another (`to`).
285      *
286      * Note that `value` may be zero.
287      */
288     event Transfer(address indexed from, address indexed to, uint256 value);
289 
290     /**
291      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
292      * a call to `approve`. `value` is the new allowance.
293      */
294     event Approval(address indexed owner, address indexed spender, uint256 value);
295 }
296 
297 
298 /**
299  * @title SafeERC20
300  * @dev Wrappers around ERC20 operations that throw on failure (when the token
301  * contract returns false). Tokens that return no value (and instead revert or
302  * throw on failure) are also supported, non-reverting calls are assumed to be
303  * successful.
304  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
305  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
306  */
307 library SafeERC20 {
308     using SafeMath for uint256;
309     using Address for address;
310 
311     function safeTransfer(IERC20 token, address to, uint256 value) internal {
312         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
313     }
314 
315     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
316         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
317     }
318 
319     function safeApprove(IERC20 token, address spender, uint256 value) internal {
320         // safeApprove should only be called when setting an initial allowance,
321         // or when resetting it to zero. To increase and decrease it, use
322         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
323         // solhint-disable-next-line max-line-length
324         require((value == 0) || (token.allowance(address(this), spender) == 0),
325             "SafeERC20: approve from non-zero to non-zero allowance"
326         );
327         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
328     }
329 
330     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
331         uint256 newAllowance = token.allowance(address(this), spender).add(value);
332         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
333     }
334 
335     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
336         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
337         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
338     }
339 
340     /**
341      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
342      * on the return value: the return value is optional (but if data is returned, it must not be false).
343      * @param token The token targeted by the call.
344      * @param data The call data (encoded using abi.encode or one of its variants).
345      */
346     function callOptionalReturn(IERC20 token, bytes memory data) private {
347         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
348         // we're implementing it ourselves.
349 
350         // A Solidity high level call has three parts:
351         //  1. The target address is checked to verify it contains contract code
352         //  2. The call itself is made, and success asserted
353         //  3. The return value is decoded, which in turn checks the size of the returned data.
354         // solhint-disable-next-line max-line-length
355         require(address(token).isContract(), "SafeERC20: call to non-contract");
356 
357         // solhint-disable-next-line avoid-low-level-calls
358         (bool success, bytes memory returndata) = address(token).call(data);
359         require(success, "SafeERC20: low-level call failed");
360 
361         if (returndata.length > 0) { // Return data is optional
362             // solhint-disable-next-line max-line-length
363             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
364         }
365     }
366 }
367 
368 
369 /**
370  * @dev Implementation of the `IERC20` interface.
371  *
372  * This implementation is agnostic to the way tokens are created. This means
373  * that a supply mechanism has to be added in a derived contract using `_mint`.
374  * For a generic mechanism see `ERC20Mintable`.
375  *
376  * *For a detailed writeup see our guide [How to implement supply
377  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
378  *
379  * We have followed general OpenZeppelin guidelines: functions revert instead
380  * of returning `false` on failure. This behavior is nonetheless conventional
381  * and does not conflict with the expectations of ERC20 applications.
382  *
383  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
384  * This allows applications to reconstruct the allowance for all accounts just
385  * by listening to said events. Other implementations of the EIP may not emit
386  * these events, as it isn't required by the specification.
387  *
388  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
389  * functions have been added to mitigate the well-known issues around setting
390  * allowances. See `IERC20.approve`.
391  */
392 contract ERC20 is IERC20 {
393     using SafeMath for uint256;
394 
395     mapping (address => uint256) private _balances;
396 
397     mapping (address => mapping (address => uint256)) private _allowances;
398 
399     uint256 private _totalSupply;
400 
401     /**
402      * @dev See `IERC20.totalSupply`.
403      */
404     function totalSupply() public view returns (uint256) {
405         return _totalSupply;
406     }
407 
408     /**
409      * @dev See `IERC20.balanceOf`.
410      */
411     function balanceOf(address account) public view returns (uint256) {
412         return _balances[account];
413     }
414 
415     /**
416      * @dev See `IERC20.transfer`.
417      *
418      * Requirements:
419      *
420      * - `recipient` cannot be the zero address.
421      * - the caller must have a balance of at least `amount`.
422      */
423     function transfer(address recipient, uint256 amount) public returns (bool) {
424         _transfer(msg.sender, recipient, amount);
425         return true;
426     }
427 
428     /**
429      * @dev See `IERC20.allowance`.
430      */
431     function allowance(address owner, address spender) public view returns (uint256) {
432         return _allowances[owner][spender];
433     }
434 
435     /**
436      * @dev See `IERC20.approve`.
437      *
438      * Requirements:
439      *
440      * - `spender` cannot be the zero address.
441      */
442     function approve(address spender, uint256 value) public returns (bool) {
443         _approve(msg.sender, spender, value);
444         return true;
445     }
446 
447     /**
448      * @dev See `IERC20.transferFrom`.
449      *
450      * Emits an `Approval` event indicating the updated allowance. This is not
451      * required by the EIP. See the note at the beginning of `ERC20`;
452      *
453      * Requirements:
454      * - `sender` and `recipient` cannot be the zero address.
455      * - `sender` must have a balance of at least `value`.
456      * - the caller must have allowance for `sender`'s tokens of at least
457      * `amount`.
458      */
459     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
460         _transfer(sender, recipient, amount);
461         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
462         return true;
463     }
464 
465     /**
466      * @dev Atomically increases the allowance granted to `spender` by the caller.
467      *
468      * This is an alternative to `approve` that can be used as a mitigation for
469      * problems described in `IERC20.approve`.
470      *
471      * Emits an `Approval` event indicating the updated allowance.
472      *
473      * Requirements:
474      *
475      * - `spender` cannot be the zero address.
476      */
477     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
478         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
479         return true;
480     }
481 
482     /**
483      * @dev Atomically decreases the allowance granted to `spender` by the caller.
484      *
485      * This is an alternative to `approve` that can be used as a mitigation for
486      * problems described in `IERC20.approve`.
487      *
488      * Emits an `Approval` event indicating the updated allowance.
489      *
490      * Requirements:
491      *
492      * - `spender` cannot be the zero address.
493      * - `spender` must have allowance for the caller of at least
494      * `subtractedValue`.
495      */
496     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
497         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
498         return true;
499     }
500 
501     /**
502      * @dev Moves tokens `amount` from `sender` to `recipient`.
503      *
504      * This is internal function is equivalent to `transfer`, and can be used to
505      * e.g. implement automatic token fees, slashing mechanisms, etc.
506      *
507      * Emits a `Transfer` event.
508      *
509      * Requirements:
510      *
511      * - `sender` cannot be the zero address.
512      * - `recipient` cannot be the zero address.
513      * - `sender` must have a balance of at least `amount`.
514      */
515     function _transfer(address sender, address recipient, uint256 amount) internal {
516         require(sender != address(0), "ERC20: transfer from the zero address");
517         require(recipient != address(0), "ERC20: transfer to the zero address");
518 
519         _balances[sender] = _balances[sender].sub(amount);
520         _balances[recipient] = _balances[recipient].add(amount);
521         emit Transfer(sender, recipient, amount);
522     }
523 
524     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
525      * the total supply.
526      *
527      * Emits a `Transfer` event with `from` set to the zero address.
528      *
529      * Requirements
530      *
531      * - `to` cannot be the zero address.
532      */
533     function _mint(address account, uint256 amount) internal {
534         require(account != address(0), "ERC20: mint to the zero address");
535 
536         _totalSupply = _totalSupply.add(amount);
537         _balances[account] = _balances[account].add(amount);
538         emit Transfer(address(0), account, amount);
539     }
540 
541      /**
542      * @dev Destoys `amount` tokens from `account`, reducing the
543      * total supply.
544      *
545      * Emits a `Transfer` event with `to` set to the zero address.
546      *
547      * Requirements
548      *
549      * - `account` cannot be the zero address.
550      * - `account` must have at least `amount` tokens.
551      */
552     function _burn(address account, uint256 value) internal {
553         require(account != address(0), "ERC20: burn from the zero address");
554 
555         _totalSupply = _totalSupply.sub(value);
556         _balances[account] = _balances[account].sub(value);
557         emit Transfer(account, address(0), value);
558     }
559 
560     /**
561      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
562      *
563      * This is internal function is equivalent to `approve`, and can be used to
564      * e.g. set automatic allowances for certain subsystems, etc.
565      *
566      * Emits an `Approval` event.
567      *
568      * Requirements:
569      *
570      * - `owner` cannot be the zero address.
571      * - `spender` cannot be the zero address.
572      */
573     function _approve(address owner, address spender, uint256 value) internal {
574         require(owner != address(0), "ERC20: approve from the zero address");
575         require(spender != address(0), "ERC20: approve to the zero address");
576 
577         _allowances[owner][spender] = value;
578         emit Approval(owner, spender, value);
579     }
580 
581     /**
582      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
583      * from the caller's allowance.
584      *
585      * See `_burn` and `_approve`.
586      */
587     function _burnFrom(address account, uint256 amount) internal {
588         _burn(account, amount);
589         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
590     }
591 }
592 
593 
594 /**
595  * @dev Contract module which provides a basic access control mechanism, where
596  * there is an account (an owner) that can be granted exclusive access to
597  * specific functions.
598  *
599  * This module is used through inheritance. It will make available the modifier
600  * `onlyOwner`, which can be aplied to your functions to restrict their use to
601  * the owner.
602  */
603 contract Ownable {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607 
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor () internal {
612         _owner = msg.sender;
613         emit OwnershipTransferred(address(0), _owner);
614     }
615 
616     /**
617      * @dev Returns the address of the current owner.
618      */
619     function owner() public view returns (address) {
620         return _owner;
621     }
622 
623     /**
624      * @dev Throws if called by any account other than the owner.
625      */
626     modifier onlyOwner() {
627         require(isOwner(), "Ownable: caller is not the owner");
628         _;
629     }
630 
631     /**
632      * @dev Returns true if the caller is the current owner.
633      */
634     function isOwner() public view returns (bool) {
635         return msg.sender == _owner;
636     }
637 
638     /**
639      * @dev Leaves the contract without owner. It will not be possible to call
640      * `onlyOwner` functions anymore. Can only be called by the current owner.
641      *
642      * > Note: Renouncing ownership will leave the contract without an owner,
643      * thereby removing any functionality that is only available to the owner.
644      */
645     function renounceOwnership() public onlyOwner {
646         emit OwnershipTransferred(_owner, address(0));
647         _owner = address(0);
648     }
649 
650     /**
651      * @dev Transfers ownership of the contract to a new account (`newOwner`).
652      * Can only be called by the current owner.
653      */
654     function transferOwnership(address newOwner) public onlyOwner {
655         _transferOwnership(newOwner);
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      */
661     function _transferOwnership(address newOwner) internal {
662         require(newOwner != address(0), "Ownable: new owner is the zero address");
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667 
668 
669 interface ITokenReceiver {
670     function tokensReceived(
671         address from,
672         address to,
673         uint256 amount
674     ) external;
675 }
676 
677 contract TokenRecoverable is Ownable {
678     using SafeERC20 for IERC20;
679 
680     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyOwner {
681         uint256 balance = token.balanceOf(address(this));
682         require(balance >= amount, "Given amount is larger than current balance");
683         token.safeTransfer(to, amount);
684     }
685 }
686 
687 contract NOIAToken is TokenRecoverable, ERC20 {
688     using SafeMath for uint256;
689     using Address for address;
690     using ECDSA for bytes32;
691 
692     string public constant name = "NOIA Token";
693     string public constant symbol = "NOIA";
694     uint8 public constant decimals = uint8(18); 
695     uint256 public tokensToMint = 1000000000e18; // 1 000 000 000 tokens
696     address public burnAddress;
697     mapping(address => bool) public notify;
698     mapping(bytes32 => bool) private hashedTxs;
699     bool public etherlessTransferEnabled = true;
700 
701     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
702 
703     modifier onlyEtherlessTransferEnabled {
704         require(etherlessTransferEnabled == true, "Etherless transfer functionality disabled");
705         _;
706     }
707 
708     function register() public {
709         notify[msg.sender] = true;
710     }
711 
712     function unregister() public {
713         notify[msg.sender] = false;
714     }
715 
716     function enableEtherlessTransfer() public onlyOwner {
717         etherlessTransferEnabled = true;
718     }
719 
720     function disableEtherlessTransfer() public onlyOwner {
721         etherlessTransferEnabled = false;
722     }
723 
724     /**
725      * @dev Transfer token to a specified address
726      * @param to The address to transfer to.
727      * @param value The amount to be transferred.
728      */
729     function transfer(address to, uint256 value) public returns (bool) {
730         bool success = super.transfer(to, value);
731         if (success) {
732             _postTransfer(msg.sender, to, value);
733         }
734         return success;
735     }
736 
737     /**
738      * @dev Transfer tokens from one address to another.
739      * Note that while this function emits an Approval event, this is not required as per the specification,
740      * and other compliant implementations may not emit the event.
741      * @param from address The address which you want to send tokens from
742      * @param to address The address which you want to transfer to
743      * @param value uint256 the amount of tokens to be transferred
744      */
745     function transferFrom(address from, address to, uint256 value) public returns (bool) {
746         bool success = super.transferFrom(from, to, value);
747         if (success) {
748             _postTransfer(from, to, value);
749         }
750         return success;
751     }
752 
753     function _postTransfer(address from, address to, uint256 value) internal {
754         if (to.isContract()) {
755             if (notify[to] == false) return;
756 
757             ITokenReceiver(to).tokensReceived(from, to, value);
758         } else {
759             if (to == burnAddress) {
760                 _burn(burnAddress, value);
761             }
762         }
763     }
764 
765     function _burn(address account, uint256 value) internal {
766         require(tokensToMint == 0, "All tokens must be minted before burning");
767         super._burn(account, value);
768     }
769 
770     /**
771      * @dev Function to mint tokens
772      * @param to The address that will receive the minted tokens.
773      * @param value The amount of tokens to mint.
774      * @return A boolean that indicates if the operation was successful.
775      */
776     function mint(address to, uint256 value) public onlyOwner returns (bool) {
777         require(tokensToMint.sub(value) >= 0, "Not enough tokens left");
778         tokensToMint = tokensToMint.sub(value);
779         _mint(to, value);
780         _postTransfer(address(0), to, value);
781         return true;
782     }
783 
784     /**
785      * @dev Burns a specific amount of tokens.
786      * @param value The amount of token to be burned.
787      */
788     function burn(uint256 value) public {
789         require(msg.sender == burnAddress, "Only burnAddress can burn tokens");
790         _burn(msg.sender, value);
791     }
792 
793     function setBurnAddress(address _burnAddress) external onlyOwner {
794         require(balanceOf(_burnAddress) == 0, "Burn address must have zero balance!");
795 
796         burnAddress = _burnAddress;
797     }
798 
799     /** Etherless Transfer */
800     /**
801      * @notice Submit a presigned transfer
802      * @param _signature bytes The signature, issued by the owner.
803      * @param _to address The address which you want to transfer to.
804      * @param _value uint256 The amount of tokens to be transferred.
805      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
806      * @param _nonce uint256 Presigned transaction number. Should be unique, per user.
807      */
808     function transferPreSigned(
809         bytes memory _signature,
810         address _to,
811         uint256 _value,
812         uint256 _fee,
813         uint256 _nonce
814     )
815         public
816         onlyEtherlessTransferEnabled
817         returns (bool)
818     {
819         require(_to != address(0), "Transfer to the zero address");
820 
821         bytes32 hashedParams = hashForSign(msg.sig, address(this), _to, _value, _fee, _nonce);
822         address from = hashedParams.toEthSignedMessageHash().recover(_signature);
823         require(from != address(0), "Invalid signature");
824 
825         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
826         require(hashedTxs[hashedTx] == false, "Nonce already used");
827         hashedTxs[hashedTx] = true;
828 
829         if (msg.sender == _to) {
830             _transfer(from, _to, _value.add(_fee));
831             _postTransfer(from, _to, _value.add(_fee));
832         } else {
833             _transfer(from, _to, _value);
834             _postTransfer(from, _to, _value);
835             _transfer(from, msg.sender, _fee);
836             _postTransfer(from, msg.sender, _fee);
837         }
838 
839         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
840         return true;
841     }
842 
843     /**
844      * @notice Hash (keccak256) of the payload used by transferPreSigned
845      * @param _token address The address of the token.
846      * @param _to address The address which you want to transfer to.
847      * @param _value uint256 The amount of tokens to be transferred.
848      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
849      * @param _nonce uint256 Presigned transaction number.
850      */
851     function hashForSign(
852         bytes4 _selector,
853         address _token,
854         address _to,
855         uint256 _value,
856         uint256 _fee,
857         uint256 _nonce
858     )
859         public
860         pure
861         returns (bytes32)
862     {
863         return keccak256(abi.encodePacked(_selector, _token, _to, _value, _fee, _nonce));
864     }
865 }