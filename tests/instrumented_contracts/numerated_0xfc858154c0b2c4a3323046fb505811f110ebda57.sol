1 pragma solidity 0.5.10;
2 /* Source code for NOIA Token */
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         require(b <= a, "SafeMath: subtraction overflow");
44         uint256 c = a - b;
45 
46         return c;
47     }
48 
49     /**
50      * @dev Returns the multiplication of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `*` operator.
54      *
55      * Requirements:
56      * - Multiplication cannot overflow.
57      */
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60         // benefit is lost if 'b' is also tested.
61         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
62         if (a == 0) {
63             return 0;
64         }
65 
66         uint256 c = a * b;
67         require(c / a == b, "SafeMath: multiplication overflow");
68 
69         return c;
70     }
71 
72     /**
73      * @dev Returns the integer division of two unsigned integers. Reverts on
74      * division by zero. The result is rounded towards zero.
75      *
76      * Counterpart to Solidity's `/` operator. Note: this function uses a
77      * `revert` opcode (which leaves remaining gas untouched) while Solidity
78      * uses an invalid opcode to revert (consuming all remaining gas).
79      *
80      * Requirements:
81      * - The divisor cannot be zero.
82      */
83     function div(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Solidity only automatically asserts when dividing by 0
85         require(b > 0, "SafeMath: division by zero");
86         uint256 c = a / b;
87         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
94      * Reverts when dividing by zero.
95      *
96      * Counterpart to Solidity's `%` operator. This function uses a `revert`
97      * opcode (which leaves remaining gas untouched) while Solidity uses an
98      * invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      * - The divisor cannot be zero.
102      */
103     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b != 0, "SafeMath: modulo by zero");
105         return a % b;
106     }
107 }
108 
109 /**
110  * @dev Collection of functions related to the address type,
111  */
112 library Address {
113     /**
114      * @dev Returns true if `account` is a contract.
115      *
116      * This test is non-exhaustive, and there may be false-negatives: during the
117      * execution of a contract's constructor, its address will be reported as
118      * not containing a contract.
119      *
120      * > It is unsafe to assume that an address for which this function returns
121      * false is an externally-owned account (EOA) and not a contract.
122      */
123     function isContract(address account) internal view returns (bool) {
124         // This method relies in extcodesize, which returns 0 for contracts in
125         // construction, since the code is only stored at the end of the
126         // constructor execution.
127 
128         uint256 size;
129         // solhint-disable-next-line no-inline-assembly
130         assembly { size := extcodesize(account) }
131         return size > 0;
132     }
133 }
134 
135 
136 /**
137  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
138  *
139  * These functions can be used to verify that a message was signed by the holder
140  * of the private keys of a given address.
141  */
142 library ECDSA {
143     /**
144      * @dev Returns the address that signed a hashed message (`hash`) with
145      * `signature`. This address can then be used for verification purposes.
146      *
147      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
148      * this function rejects them by requiring the `s` value to be in the lower
149      * half order, and the `v` value to be either 27 or 28.
150      *
151      * (.note) This call _does not revert_ if the signature is invalid, or
152      * if the signer is otherwise unable to be retrieved. In those scenarios,
153      * the zero address is returned.
154      *
155      * (.warning) `hash` _must_ be the result of a hash operation for the
156      * verification to be secure: it is possible to craft signatures that
157      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
158      * this is by receiving a hash of the original message (which may otherwise)
159      * be too long), and then calling `toEthSignedMessageHash` on it.
160      */
161     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
162         // Check the signature length
163         if (signature.length != 65) {
164             return (address(0));
165         }
166 
167         // Divide the signature in r, s and v variables
168         bytes32 r;
169         bytes32 s;
170         uint8 v;
171 
172         // ecrecover takes the signature parameters, and the only way to get them
173         // currently is to use assembly.
174         // solhint-disable-next-line no-inline-assembly
175         assembly {
176             r := mload(add(signature, 0x20))
177             s := mload(add(signature, 0x40))
178             v := byte(0, mload(add(signature, 0x60)))
179         }
180 
181         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
182         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
183         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
184         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
185         //
186         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
187         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
188         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
189         // these malleable signatures as well.
190         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
191             return address(0);
192         }
193 
194         if (v != 27 && v != 28) {
195             return address(0);
196         }
197 
198         // If the signature is valid (and not malleable), return the signer address
199         return ecrecover(hash, v, r, s);
200     }
201 
202     /**
203      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
204      * replicates the behavior of the
205      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
206      * JSON-RPC method.
207      *
208      * See `recover`.
209      */
210     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
211         // 32 is the length in bytes of hash,
212         // enforced by the type signature above
213         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
214     }
215 }
216 
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
293 
294 /**
295  * @title SafeERC20
296  * @dev Wrappers around ERC20 operations that throw on failure (when the token
297  * contract returns false). Tokens that return no value (and instead revert or
298  * throw on failure) are also supported, non-reverting calls are assumed to be
299  * successful.
300  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
301  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
302  */
303 library SafeERC20 {
304     using SafeMath for uint256;
305     using Address for address;
306 
307     function safeTransfer(IERC20 token, address to, uint256 value) internal {
308         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
309     }
310 
311     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
312         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
313     }
314 
315     function safeApprove(IERC20 token, address spender, uint256 value) internal {
316         // safeApprove should only be called when setting an initial allowance,
317         // or when resetting it to zero. To increase and decrease it, use
318         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
319         // solhint-disable-next-line max-line-length
320         require((value == 0) || (token.allowance(address(this), spender) == 0),
321             "SafeERC20: approve from non-zero to non-zero allowance"
322         );
323         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
324     }
325 
326     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
327         uint256 newAllowance = token.allowance(address(this), spender).add(value);
328         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
329     }
330 
331     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
332         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
333         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
334     }
335 
336     /**
337      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
338      * on the return value: the return value is optional (but if data is returned, it must not be false).
339      * @param token The token targeted by the call.
340      * @param data The call data (encoded using abi.encode or one of its variants).
341      */
342     function callOptionalReturn(IERC20 token, bytes memory data) private {
343         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
344         // we're implementing it ourselves.
345 
346         // A Solidity high level call has three parts:
347         //  1. The target address is checked to verify it contains contract code
348         //  2. The call itself is made, and success asserted
349         //  3. The return value is decoded, which in turn checks the size of the returned data.
350         // solhint-disable-next-line max-line-length
351         require(address(token).isContract(), "SafeERC20: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = address(token).call(data);
355         require(success, "SafeERC20: low-level call failed");
356 
357         if (returndata.length > 0) { // Return data is optional
358             // solhint-disable-next-line max-line-length
359             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
360         }
361     }
362 }
363 
364 
365 /**
366  * @dev Implementation of the `IERC20` interface.
367  *
368  * This implementation is agnostic to the way tokens are created. This means
369  * that a supply mechanism has to be added in a derived contract using `_mint`.
370  * For a generic mechanism see `ERC20Mintable`.
371  *
372  * *For a detailed writeup see our guide [How to implement supply
373  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
374  *
375  * We have followed general OpenZeppelin guidelines: functions revert instead
376  * of returning `false` on failure. This behavior is nonetheless conventional
377  * and does not conflict with the expectations of ERC20 applications.
378  *
379  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
380  * This allows applications to reconstruct the allowance for all accounts just
381  * by listening to said events. Other implementations of the EIP may not emit
382  * these events, as it isn't required by the specification.
383  *
384  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
385  * functions have been added to mitigate the well-known issues around setting
386  * allowances. See `IERC20.approve`.
387  */
388 contract ERC20 is IERC20 {
389     using SafeMath for uint256;
390 
391     mapping (address => uint256) private _balances;
392 
393     mapping (address => mapping (address => uint256)) private _allowances;
394 
395     uint256 private _totalSupply;
396 
397     /**
398      * @dev See `IERC20.totalSupply`.
399      */
400     function totalSupply() public view returns (uint256) {
401         return _totalSupply;
402     }
403 
404     /**
405      * @dev See `IERC20.balanceOf`.
406      */
407     function balanceOf(address account) public view returns (uint256) {
408         return _balances[account];
409     }
410 
411     /**
412      * @dev See `IERC20.transfer`.
413      *
414      * Requirements:
415      *
416      * - `recipient` cannot be the zero address.
417      * - the caller must have a balance of at least `amount`.
418      */
419     function transfer(address recipient, uint256 amount) public returns (bool) {
420         _transfer(msg.sender, recipient, amount);
421         return true;
422     }
423 
424     /**
425      * @dev See `IERC20.allowance`.
426      */
427     function allowance(address owner, address spender) public view returns (uint256) {
428         return _allowances[owner][spender];
429     }
430 
431     /**
432      * @dev See `IERC20.approve`.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function approve(address spender, uint256 value) public returns (bool) {
439         _approve(msg.sender, spender, value);
440         return true;
441     }
442 
443     /**
444      * @dev See `IERC20.transferFrom`.
445      *
446      * Emits an `Approval` event indicating the updated allowance. This is not
447      * required by the EIP. See the note at the beginning of `ERC20`;
448      *
449      * Requirements:
450      * - `sender` and `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `value`.
452      * - the caller must have allowance for `sender`'s tokens of at least
453      * `amount`.
454      */
455     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
456         _transfer(sender, recipient, amount);
457         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
458         return true;
459     }
460 
461     /**
462      * @dev Atomically increases the allowance granted to `spender` by the caller.
463      *
464      * This is an alternative to `approve` that can be used as a mitigation for
465      * problems described in `IERC20.approve`.
466      *
467      * Emits an `Approval` event indicating the updated allowance.
468      *
469      * Requirements:
470      *
471      * - `spender` cannot be the zero address.
472      */
473     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
474         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
475         return true;
476     }
477 
478     /**
479      * @dev Atomically decreases the allowance granted to `spender` by the caller.
480      *
481      * This is an alternative to `approve` that can be used as a mitigation for
482      * problems described in `IERC20.approve`.
483      *
484      * Emits an `Approval` event indicating the updated allowance.
485      *
486      * Requirements:
487      *
488      * - `spender` cannot be the zero address.
489      * - `spender` must have allowance for the caller of at least
490      * `subtractedValue`.
491      */
492     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
493         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Moves tokens `amount` from `sender` to `recipient`.
499      *
500      * This is internal function is equivalent to `transfer`, and can be used to
501      * e.g. implement automatic token fees, slashing mechanisms, etc.
502      *
503      * Emits a `Transfer` event.
504      *
505      * Requirements:
506      *
507      * - `sender` cannot be the zero address.
508      * - `recipient` cannot be the zero address.
509      * - `sender` must have a balance of at least `amount`.
510      */
511     function _transfer(address sender, address recipient, uint256 amount) internal {
512         require(sender != address(0), "ERC20: transfer from the zero address");
513         require(recipient != address(0), "ERC20: transfer to the zero address");
514 
515         _balances[sender] = _balances[sender].sub(amount);
516         _balances[recipient] = _balances[recipient].add(amount);
517         emit Transfer(sender, recipient, amount);
518     }
519 
520     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
521      * the total supply.
522      *
523      * Emits a `Transfer` event with `from` set to the zero address.
524      *
525      * Requirements
526      *
527      * - `to` cannot be the zero address.
528      */
529     function _mint(address account, uint256 amount) internal {
530         require(account != address(0), "ERC20: mint to the zero address");
531 
532         _totalSupply = _totalSupply.add(amount);
533         _balances[account] = _balances[account].add(amount);
534         emit Transfer(address(0), account, amount);
535     }
536 
537      /**
538      * @dev Destoys `amount` tokens from `account`, reducing the
539      * total supply.
540      *
541      * Emits a `Transfer` event with `to` set to the zero address.
542      *
543      * Requirements
544      *
545      * - `account` cannot be the zero address.
546      * - `account` must have at least `amount` tokens.
547      */
548     function _burn(address account, uint256 value) internal {
549         require(account != address(0), "ERC20: burn from the zero address");
550 
551         _totalSupply = _totalSupply.sub(value);
552         _balances[account] = _balances[account].sub(value);
553         emit Transfer(account, address(0), value);
554     }
555 
556     /**
557      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
558      *
559      * This is internal function is equivalent to `approve`, and can be used to
560      * e.g. set automatic allowances for certain subsystems, etc.
561      *
562      * Emits an `Approval` event.
563      *
564      * Requirements:
565      *
566      * - `owner` cannot be the zero address.
567      * - `spender` cannot be the zero address.
568      */
569     function _approve(address owner, address spender, uint256 value) internal {
570         require(owner != address(0), "ERC20: approve from the zero address");
571         require(spender != address(0), "ERC20: approve to the zero address");
572 
573         _allowances[owner][spender] = value;
574         emit Approval(owner, spender, value);
575     }
576 
577     /**
578      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
579      * from the caller's allowance.
580      *
581      * See `_burn` and `_approve`.
582      */
583     function _burnFrom(address account, uint256 amount) internal {
584         _burn(account, amount);
585         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
586     }
587 }
588 
589 
590 /**
591  * @dev Contract module which provides a basic access control mechanism, where
592  * there is an account (an owner) that can be granted exclusive access to
593  * specific functions.
594  *
595  * This module is used through inheritance. It will make available the modifier
596  * `onlyOwner`, which can be aplied to your functions to restrict their use to
597  * the owner.
598  */
599 contract Ownable {
600     address private _owner;
601 
602     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
603 
604     /**
605      * @dev Initializes the contract setting the deployer as the initial owner.
606      */
607     constructor () internal {
608         _owner = msg.sender;
609         emit OwnershipTransferred(address(0), _owner);
610     }
611 
612     /**
613      * @dev Returns the address of the current owner.
614      */
615     function owner() public view returns (address) {
616         return _owner;
617     }
618 
619     /**
620      * @dev Throws if called by any account other than the owner.
621      */
622     modifier onlyOwner() {
623         require(isOwner(), "Ownable: caller is not the owner");
624         _;
625     }
626 
627     /**
628      * @dev Returns true if the caller is the current owner.
629      */
630     function isOwner() public view returns (bool) {
631         return msg.sender == _owner;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * > Note: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public onlyOwner {
651         _transferOwnership(newOwner);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      */
657     function _transferOwnership(address newOwner) internal {
658         require(newOwner != address(0), "Ownable: new owner is the zero address");
659         emit OwnershipTransferred(_owner, newOwner);
660         _owner = newOwner;
661     }
662 }
663 
664 
665 interface ITokenReceiver {
666     function tokensReceived(
667         address from,
668         address to,
669         uint256 amount
670     ) external;
671 }
672 
673 contract TokenRecoverable is Ownable {
674     using SafeERC20 for IERC20;
675 
676     function recoverTokens(IERC20 token, address to, uint256 amount) public onlyOwner {
677         uint256 balance = token.balanceOf(address(this));
678         require(balance >= amount, "Given amount is larger than current balance");
679         token.safeTransfer(to, amount);
680     }
681 }
682 
683 contract NOIAToken is TokenRecoverable, ERC20 {
684     using SafeMath for uint256;
685     using Address for address;
686     using ECDSA for bytes32;
687 
688     string public constant name = "NOIA Token";
689     string public constant symbol = "NOIA";
690     uint8 public constant decimals = uint8(18); 
691     uint256 public tokensToMint = 1000000000e18; // 1 000 000 000 tokens
692     address public burnAddress;
693     mapping(address => bool) public notify;
694     mapping(bytes32 => bool) private hashedTxs;
695     bool public etherlessTransferEnabled = true;
696 
697     event TransferPreSigned(address indexed from, address indexed to, address indexed delegate, uint256 amount, uint256 fee);
698 
699     modifier onlyEtherlessTransferEnabled {
700         require(etherlessTransferEnabled == true, "Etherless transfer functionality disabled");
701         _;
702     }
703 
704     function register() public {
705         notify[msg.sender] = true;
706     }
707 
708     function unregister() public {
709         notify[msg.sender] = false;
710     }
711 
712     function enableEtherlessTransfer() public onlyOwner {
713         etherlessTransferEnabled = true;
714     }
715 
716     function disableEtherlessTransfer() public onlyOwner {
717         etherlessTransferEnabled = false;
718     }
719 
720     /**
721      * @dev Transfer token to a specified address
722      * @param to The address to transfer to.
723      * @param value The amount to be transferred.
724      */
725     function transfer(address to, uint256 value) public returns (bool) {
726         bool success = super.transfer(to, value);
727         if (success) {
728             _postTransfer(msg.sender, to, value);
729         }
730         return success;
731     }
732 
733     /**
734      * @dev Transfer tokens from one address to another.
735      * Note that while this function emits an Approval event, this is not required as per the specification,
736      * and other compliant implementations may not emit the event.
737      * @param from address The address which you want to send tokens from
738      * @param to address The address which you want to transfer to
739      * @param value uint256 the amount of tokens to be transferred
740      */
741     function transferFrom(address from, address to, uint256 value) public returns (bool) {
742         bool success = super.transferFrom(from, to, value);
743         if (success) {
744             _postTransfer(from, to, value);
745         }
746         return success;
747     }
748 
749     function _postTransfer(address from, address to, uint256 value) internal {
750         if (to.isContract()) {
751             if (notify[to] == false) return;
752 
753             ITokenReceiver(to).tokensReceived(from, to, value);
754         } else {
755             if (to == burnAddress) {
756                 _burn(burnAddress, value);
757             }
758         }
759     }
760 
761     function _burn(address account, uint256 value) internal {
762         require(tokensToMint == 0, "All tokens must be minted before burning");
763         super._burn(account, value);
764     }
765 
766     /**
767      * @dev Function to mint tokens
768      * @param to The address that will receive the minted tokens.
769      * @param value The amount of tokens to mint.
770      * @return A boolean that indicates if the operation was successful.
771      */
772     function mint(address to, uint256 value) public onlyOwner returns (bool) {
773         require(tokensToMint.sub(value) >= 0, "Not enough tokens left");
774         tokensToMint = tokensToMint.sub(value);
775         _mint(to, value);
776         _postTransfer(address(0), to, value);
777         return true;
778     }
779 
780     /**
781      * @dev Burns a specific amount of tokens.
782      * @param value The amount of token to be burned.
783      */
784     function burn(uint256 value) public {
785         require(msg.sender == burnAddress, "Only burnAddress can burn tokens");
786         _burn(msg.sender, value);
787     }
788 
789     function setBurnAddress(address _burnAddress) external onlyOwner {
790         require(balanceOf(_burnAddress) == 0, "Burn address must have zero balance!");
791 
792         burnAddress = _burnAddress;
793     }
794 
795     /** Etherless Transfer */
796     /**
797      * @notice Submit a presigned transfer
798      * @param _signature bytes The signature, issued by the owner.
799      * @param _to address The address which you want to transfer to.
800      * @param _value uint256 The amount of tokens to be transferred.
801      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
802      * @param _nonce uint256 Presigned transaction number. Should be unique, per user.
803      */
804     function transferPreSigned(
805         bytes memory _signature,
806         address _to,
807         uint256 _value,
808         uint256 _fee,
809         uint256 _nonce
810     )
811         public
812         onlyEtherlessTransferEnabled
813         returns (bool)
814     {
815         require(_to != address(0), "Transfer to the zero address");
816 
817         bytes32 hashedParams = hashForSign(msg.sig, address(this), _to, _value, _fee, _nonce);
818         address from = hashedParams.toEthSignedMessageHash().recover(_signature);
819         require(from != address(0), "Invalid signature");
820 
821         bytes32 hashedTx = keccak256(abi.encodePacked(from, hashedParams));
822         require(hashedTxs[hashedTx] == false, "Nonce already used");
823         hashedTxs[hashedTx] = true;
824 
825         if (msg.sender == _to) {
826             _transfer(from, _to, _value.add(_fee));
827             _postTransfer(from, _to, _value.add(_fee));
828         } else {
829             _transfer(from, _to, _value);
830             _postTransfer(from, _to, _value);
831             _transfer(from, msg.sender, _fee);
832             _postTransfer(from, msg.sender, _fee);
833         }
834 
835         emit TransferPreSigned(from, _to, msg.sender, _value, _fee);
836         return true;
837     }
838 
839     /**
840      * @notice Hash (keccak256) of the payload used by transferPreSigned
841      * @param _token address The address of the token.
842      * @param _to address The address which you want to transfer to.
843      * @param _value uint256 The amount of tokens to be transferred.
844      * @param _fee uint256 The amount of tokens paid to msg.sender, by the owner.
845      * @param _nonce uint256 Presigned transaction number.
846      */
847     function hashForSign(
848         bytes4 _selector,
849         address _token,
850         address _to,
851         uint256 _value,
852         uint256 _fee,
853         uint256 _nonce
854     )
855         public
856         pure
857         returns (bytes32)
858     {
859         return keccak256(abi.encodePacked(_selector, _token, _to, _value, _fee, _nonce));
860     }
861 }