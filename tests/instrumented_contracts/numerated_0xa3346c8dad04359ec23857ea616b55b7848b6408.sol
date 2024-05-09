1 pragma solidity ^0.5.0;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 contract Context {
15     // Empty internal constructor, to prevent people from mistakenly deploying
16     // an instance of this contract, which should be used via inheritance.
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * This module is used through inheritance. It will make available the modifier
35  * `onlyOwner`, which can be applied to your functions to restrict their use to
36  * the owner.
37  */
38 contract Ownable is Context {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     /**
44      * @dev Initializes the contract setting the deployer as the initial owner.
45      */
46     constructor () internal {
47         _owner = _msgSender();
48         emit OwnershipTransferred(address(0), _owner);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(isOwner(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Returns true if the caller is the current owner.
68      */
69     function isOwner() public view returns (bool) {
70         return _msgSender() == _owner;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public onlyOwner {
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      */
96     function _transferOwnership(address newOwner) internal {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         emit OwnershipTransferred(_owner, newOwner);
99         _owner = newOwner;
100     }
101 }
102 /**
103  * @title Roles
104  * @dev Library for managing addresses assigned to a Role.
105  */
106 library Roles {
107     struct Role {
108         mapping (address => bool) bearer;
109     }
110 
111     /**
112      * @dev Give an account access to this role.
113      */
114     function add(Role storage role, address account) internal {
115         require(!has(role, account), "Roles: account already has role");
116         role.bearer[account] = true;
117     }
118 
119     /**
120      * @dev Remove an account's access to this role.
121      */
122     function remove(Role storage role, address account) internal {
123         require(has(role, account), "Roles: account does not have role");
124         role.bearer[account] = false;
125     }
126 
127     /**
128      * @dev Check if an account has this role.
129      * @return bool
130      */
131     function has(Role storage role, address account) internal view returns (bool) {
132         require(account != address(0), "Roles: account is the zero address");
133         return role.bearer[account];
134     }
135 }
136 
137 contract SignerRole is Context {
138     using Roles for Roles.Role;
139 
140     event SignerAdded(address indexed account);
141     event SignerRemoved(address indexed account);
142 
143     Roles.Role private _signers;
144 
145     constructor () internal {
146         _addSigner(_msgSender());
147     }
148 
149     modifier onlySigner() {
150         require(isSigner(_msgSender()), "SignerRole: caller does not have the Signer role");
151         _;
152     }
153 
154     function isSigner(address account) public view returns (bool) {
155         return _signers.has(account);
156     }
157 
158     function addSigner(address account) public onlySigner {
159         _addSigner(account);
160     }
161 
162     function renounceSigner() public {
163         _removeSigner(_msgSender());
164     }
165 
166     function _addSigner(address account) internal {
167         _signers.add(account);
168         emit SignerAdded(account);
169     }
170 
171     function _removeSigner(address account) internal {
172         _signers.remove(account);
173         emit SignerRemoved(account);
174     }
175 }
176 
177 contract PauserRole is Context {
178     using Roles for Roles.Role;
179 
180     event PauserAdded(address indexed account);
181     event PauserRemoved(address indexed account);
182 
183     Roles.Role private _pausers;
184 
185     constructor () internal {
186         _addPauser(_msgSender());
187     }
188 
189     modifier onlyPauser() {
190         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
191         _;
192     }
193 
194     function isPauser(address account) public view returns (bool) {
195         return _pausers.has(account);
196     }
197 
198     function addPauser(address account) public onlyPauser {
199         _addPauser(account);
200     }
201 
202     function renouncePauser() public {
203         _removePauser(_msgSender());
204     }
205 
206     function _addPauser(address account) internal {
207         _pausers.add(account);
208         emit PauserAdded(account);
209     }
210 
211     function _removePauser(address account) internal {
212         _pausers.remove(account);
213         emit PauserRemoved(account);
214     }
215 }
216 
217 /**
218  * @dev Contract module which allows children to implement an emergency stop
219  * mechanism that can be triggered by an authorized account.
220  *
221  * This module is used through inheritance. It will make available the
222  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
223  * the functions of your contract. Note that they will not be pausable by
224  * simply including this module, only once the modifiers are put in place.
225  */
226 contract Pausable is Context, PauserRole {
227     /**
228      * @dev Emitted when the pause is triggered by a pauser (`account`).
229      */
230     event Paused(address account);
231 
232     /**
233      * @dev Emitted when the pause is lifted by a pauser (`account`).
234      */
235     event Unpaused(address account);
236 
237     bool private _paused;
238 
239     /**
240      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
241      * to the deployer.
242      */
243     constructor () internal {
244         _paused = false;
245     }
246 
247     /**
248      * @dev Returns true if the contract is paused, and false otherwise.
249      */
250     function paused() public view returns (bool) {
251         return _paused;
252     }
253 
254     /**
255      * @dev Modifier to make a function callable only when the contract is not paused.
256      */
257     modifier whenNotPaused() {
258         require(!_paused, "Pausable: paused");
259         _;
260     }
261 
262     /**
263      * @dev Modifier to make a function callable only when the contract is paused.
264      */
265     modifier whenPaused() {
266         require(_paused, "Pausable: not paused");
267         _;
268     }
269 
270     /**
271      * @dev Called by a pauser to pause, triggers stopped state.
272      */
273     function pause() public onlyPauser whenNotPaused {
274         _paused = true;
275         emit Paused(_msgSender());
276     }
277 
278     /**
279      * @dev Called by a pauser to unpause, returns to normal state.
280      */
281     function unpause() public onlyPauser whenPaused {
282         _paused = false;
283         emit Unpaused(_msgSender());
284     }
285 }
286 
287 /**
288  * @dev Collection of functions related to the address type
289  */
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * This test is non-exhaustive, and there may be false-negatives: during the
295      * execution of a contract's constructor, its address will be reported as
296      * not containing a contract.
297      *
298      * IMPORTANT: It is unsafe to assume that an address for which this
299      * function returns false is an externally-owned account (EOA) and not a
300      * contract.
301      */
302     function isContract(address account) internal view returns (bool) {
303         // This method relies in extcodesize, which returns 0 for contracts in
304         // construction, since the code is only stored at the end of the
305         // constructor execution.
306 
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != 0x0 && codehash != accountHash);
315     }
316 
317     /**
318      * @dev Converts an `address` into `address payable`. Note that this is
319      * simply a type cast: the actual underlying value is not changed.
320      *
321      * _Available since v2.4.0._
322      */
323     function toPayable(address account) internal pure returns (address payable) {
324         return address(uint160(account));
325     }
326 
327     /**
328      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
329      * `recipient`, forwarding all available gas and reverting on errors.
330      *
331      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
332      * of certain opcodes, possibly making contracts go over the 2300 gas limit
333      * imposed by `transfer`, making them unable to receive funds via
334      * `transfer`. {sendValue} removes this limitation.
335      *
336      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
337      *
338      * IMPORTANT: because control is transferred to `recipient`, care must be
339      * taken to not create reentrancy vulnerabilities. Consider using
340      * {ReentrancyGuard} or the
341      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
342      *
343      * _Available since v2.4.0._
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         // solhint-disable-next-line avoid-call-value
349         (bool success, ) = recipient.call.value(amount)("");
350         require(success, "Address: unable to send value, recipient may have reverted");
351     }
352 }
353 /**
354  * @dev Wrappers over Solidity's arithmetic operations with added overflow
355  * checks.
356  *
357  * Arithmetic operations in Solidity wrap on overflow. This can easily result
358  * in bugs, because programmers usually assume that an overflow raises an
359  * error, which is the standard behavior in high level programming languages.
360  * `SafeMath` restores this intuition by reverting the transaction when an
361  * operation overflows.
362  *
363  * Using this library instead of the unchecked operations eliminates an entire
364  * class of bugs, so it's recommended to use it always.
365  */
366 library SafeMath {
367     /**
368      * @dev Returns the addition of two unsigned integers, reverting on
369      * overflow.
370      *
371      * Counterpart to Solidity's `+` operator.
372      *
373      * Requirements:
374      * - Addition cannot overflow.
375      */
376     function add(uint256 a, uint256 b) internal pure returns (uint256) {
377         uint256 c = a + b;
378         require(c >= a, "SafeMath: addition overflow");
379 
380         return c;
381     }
382 
383     /**
384      * @dev Returns the subtraction of two unsigned integers, reverting on
385      * overflow (when the result is negative).
386      *
387      * Counterpart to Solidity's `-` operator.
388      *
389      * Requirements:
390      * - Subtraction cannot overflow.
391      */
392     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
393         return sub(a, b, "SafeMath: subtraction overflow");
394     }
395 
396     /**
397      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
398      * overflow (when the result is negative).
399      *
400      * Counterpart to Solidity's `-` operator.
401      *
402      * Requirements:
403      * - Subtraction cannot overflow.
404      *
405      * _Available since v2.4.0._
406      */
407     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
408         require(b <= a, errorMessage);
409         uint256 c = a - b;
410 
411         return c;
412     }
413 
414     /**
415      * @dev Returns the multiplication of two unsigned integers, reverting on
416      * overflow.
417      *
418      * Counterpart to Solidity's `*` operator.
419      *
420      * Requirements:
421      * - Multiplication cannot overflow.
422      */
423     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
424         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425         // benefit is lost if 'b' is also tested.
426         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
427         if (a == 0) {
428             return 0;
429         }
430 
431         uint256 c = a * b;
432         require(c / a == b, "SafeMath: multiplication overflow");
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the integer division of two unsigned integers. Reverts on
439      * division by zero. The result is rounded towards zero.
440      *
441      * Counterpart to Solidity's `/` operator. Note: this function uses a
442      * `revert` opcode (which leaves remaining gas untouched) while Solidity
443      * uses an invalid opcode to revert (consuming all remaining gas).
444      *
445      * Requirements:
446      * - The divisor cannot be zero.
447      */
448     function div(uint256 a, uint256 b) internal pure returns (uint256) {
449         return div(a, b, "SafeMath: division by zero");
450     }
451 
452     /**
453      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
454      * division by zero. The result is rounded towards zero.
455      *
456      * Counterpart to Solidity's `/` operator. Note: this function uses a
457      * `revert` opcode (which leaves remaining gas untouched) while Solidity
458      * uses an invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      * - The divisor cannot be zero.
462      *
463      * _Available since v2.4.0._
464      */
465     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         // Solidity only automatically asserts when dividing by 0
467         require(b > 0, errorMessage);
468         uint256 c = a / b;
469         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
476      * Reverts when dividing by zero.
477      *
478      * Counterpart to Solidity's `%` operator. This function uses a `revert`
479      * opcode (which leaves remaining gas untouched) while Solidity uses an
480      * invalid opcode to revert (consuming all remaining gas).
481      *
482      * Requirements:
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
486         return mod(a, b, "SafeMath: modulo by zero");
487     }
488 
489     /**
490      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
491      * Reverts with custom message when dividing by zero.
492      *
493      * Counterpart to Solidity's `%` operator. This function uses a `revert`
494      * opcode (which leaves remaining gas untouched) while Solidity uses an
495      * invalid opcode to revert (consuming all remaining gas).
496      *
497      * Requirements:
498      * - The divisor cannot be zero.
499      *
500      * _Available since v2.4.0._
501      */
502     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b != 0, errorMessage);
504         return a % b;
505     }
506 }
507 /**
508  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
509  * the optional functions; to access them see {ERC20Detailed}.
510  */
511 interface IERC20 {
512     /**
513      * @dev Returns the amount of tokens in existence.
514      */
515     function totalSupply() external view returns (uint256);
516 
517     /**
518      * @dev Returns the amount of tokens owned by `account`.
519      */
520     function balanceOf(address account) external view returns (uint256);
521 
522     /**
523      * @dev Moves `amount` tokens from the caller's account to `recipient`.
524      *
525      * Returns a boolean value indicating whether the operation succeeded.
526      *
527      * Emits a {Transfer} event.
528      */
529     function transfer(address recipient, uint256 amount) external returns (bool);
530 
531     /**
532      * @dev Returns the remaining number of tokens that `spender` will be
533      * allowed to spend on behalf of `owner` through {transferFrom}. This is
534      * zero by default.
535      *
536      * This value changes when {approve} or {transferFrom} are called.
537      */
538     function allowance(address owner, address spender) external view returns (uint256);
539 
540     /**
541      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
542      *
543      * Returns a boolean value indicating whether the operation succeeded.
544      *
545      * IMPORTANT: Beware that changing an allowance with this method brings the risk
546      * that someone may use both the old and the new allowance by unfortunate
547      * transaction ordering. One possible solution to mitigate this race
548      * condition is to first reduce the spender's allowance to 0 and set the
549      * desired value afterwards:
550      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
551      *
552      * Emits an {Approval} event.
553      */
554     function approve(address spender, uint256 amount) external returns (bool);
555 
556     /**
557      * @dev Moves `amount` tokens from `sender` to `recipient` using the
558      * allowance mechanism. `amount` is then deducted from the caller's
559      * allowance.
560      *
561      * Returns a boolean value indicating whether the operation succeeded.
562      *
563      * Emits a {Transfer} event.
564      */
565     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
566 
567     /**
568      * @dev Emitted when `value` tokens are moved from one account (`from`) to
569      * another (`to`).
570      *
571      * Note that `value` may be zero.
572      */
573     event Transfer(address indexed from, address indexed to, uint256 value);
574 
575     /**
576      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
577      * a call to {approve}. `value` is the new allowance.
578      */
579     event Approval(address indexed owner, address indexed spender, uint256 value);
580 }
581 
582 library SafeERC20 {
583     using SafeMath for uint256;
584     using Address for address;
585 
586     function safeTransfer(IERC20 token, address to, uint256 value) internal {
587         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
588     }
589 
590     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
591         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
592     }
593 
594     function safeApprove(IERC20 token, address spender, uint256 value) internal {
595         // safeApprove should only be called when setting an initial allowance,
596         // or when resetting it to zero. To increase and decrease it, use
597         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
598         // solhint-disable-next-line max-line-length
599         require((value == 0) || (token.allowance(address(this), spender) == 0),
600             "SafeERC20: approve from non-zero to non-zero allowance"
601         );
602         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
603     }
604 
605     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
606         uint256 newAllowance = token.allowance(address(this), spender).add(value);
607         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
608     }
609 
610     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
611         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
612         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
613     }
614 
615     /**
616      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
617      * on the return value: the return value is optional (but if data is returned, it must not be false).
618      * @param token The token targeted by the call.
619      * @param data The call data (encoded using abi.encode or one of its variants).
620      */
621     function callOptionalReturn(IERC20 token, bytes memory data) private {
622         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
623         // we're implementing it ourselves.
624 
625         // A Solidity high level call has three parts:
626         //  1. The target address is checked to verify it contains contract code
627         //  2. The call itself is made, and success asserted
628         //  3. The return value is decoded, which in turn checks the size of the returned data.
629         // solhint-disable-next-line max-line-length
630         require(address(token).isContract(), "SafeERC20: call to non-contract");
631 
632         // solhint-disable-next-line avoid-low-level-calls
633         (bool success, bytes memory returndata) = address(token).call(data);
634         require(success, "SafeERC20: low-level call failed");
635 
636         if (returndata.length > 0) { // Return data is optional
637             // solhint-disable-next-line max-line-length
638             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
639         }
640     }
641 }
642 /**
643  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
644  *
645  * These functions can be used to verify that a message was signed by the holder
646  * of the private keys of a given address.
647  */
648 library ECDSA {
649     /**
650      * @dev Returns the address that signed a hashed message (`hash`) with
651      * `signature`. This address can then be used for verification purposes.
652      *
653      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
654      * this function rejects them by requiring the `s` value to be in the lower
655      * half order, and the `v` value to be either 27 or 28.
656      *
657      * NOTE: This call _does not revert_ if the signature is invalid, or
658      * if the signer is otherwise unable to be retrieved. In those scenarios,
659      * the zero address is returned.
660      *
661      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
662      * verification to be secure: it is possible to craft signatures that
663      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
664      * this is by receiving a hash of the original message (which may otherwise
665      * be too long), and then calling {toEthSignedMessageHash} on it.
666      */
667     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
668         // Check the signature length
669         if (signature.length != 65) {
670             return (address(0));
671         }
672 
673         // Divide the signature in r, s and v variables
674         bytes32 r;
675         bytes32 s;
676         uint8 v;
677 
678         // ecrecover takes the signature parameters, and the only way to get them
679         // currently is to use assembly.
680         // solhint-disable-next-line no-inline-assembly
681         assembly {
682             r := mload(add(signature, 0x20))
683             s := mload(add(signature, 0x40))
684             v := byte(0, mload(add(signature, 0x60)))
685         }
686 
687         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
688         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
689         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
690         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
691         //
692         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
693         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
694         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
695         // these malleable signatures as well.
696         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
697             return address(0);
698         }
699 
700         if (v != 27 && v != 28) {
701             return address(0);
702         }
703 
704         // If the signature is valid (and not malleable), return the signer address
705         return ecrecover(hash, v, r, s);
706     }
707 
708     /**
709      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
710      * replicates the behavior of the
711      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
712      * JSON-RPC method.
713      *
714      * See {recover}.
715      */
716     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
717         // 32 is the length in bytes of hash,
718         // enforced by the type signature above
719         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
720     }
721 }
722 
723 contract TetherSender is Ownable, SignerRole , Pausable  {
724 
725     address private tokenAddr;
726     using SafeERC20 for IERC20;
727     using ECDSA for bytes32;
728 
729     constructor (address _tokenAddr) public {
730      tokenAddr = _tokenAddr;
731     }
732 
733     function transfer(address source, address[] memory  dests, uint256[] memory values) public onlySigner whenNotPaused {
734 
735         uint256 i = 0;
736         while (i < dests.length) {
737            IERC20(tokenAddr).safeTransferFrom(source, dests[i], values[i]);
738            i += 1;
739         }
740     }
741 
742     function transferEx(address source,  address[] memory  dests, uint256[] memory values, bytes memory data, bytes32 hash, bytes memory signature) public onlySigner whenNotPaused {
743 
744         require(keccak256(data) == hash, "Hash missmatch");
745         require(verify(source, hash, signature), "Source not verified");
746 
747         uint256 i = 0;
748         while (i < dests.length) {
749            IERC20(tokenAddr).safeTransferFrom(source, dests[i], values[i]);
750            i += 1;
751         }
752     }
753 
754     function verify(address account, bytes32 hash, bytes memory signature) public pure returns (bool) {
755          return ECDSA.recover(hash, signature) == account;
756     }
757 }