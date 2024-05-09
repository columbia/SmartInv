1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.12;
8 
9 /**
10  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
11  *
12  * These functions can be used to verify that a message was signed by the holder
13  * of the private keys of a given address.
14  */
15 library ECDSA {
16     /**
17      * @dev Returns the address that signed a hashed message (`hash`) with
18      * `signature`. This address can then be used for verification purposes.
19      *
20      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
21      * this function rejects them by requiring the `s` value to be in the lower
22      * half order, and the `v` value to be either 27 or 28.
23      *
24      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
25      * verification to be secure: it is possible to craft signatures that
26      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
27      * this is by receiving a hash of the original message (which may otherwise
28      * be too long), and then calling {toEthSignedMessageHash} on it.
29      */
30     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
31         // Check the signature length
32         if (signature.length != 65) {
33             revert("ECDSA: invalid signature length");
34         }
35 
36         // Divide the signature in r, s and v variables
37         bytes32 r;
38         bytes32 s;
39         uint8 v;
40 
41         // ecrecover takes the signature parameters, and the only way to get them
42         // currently is to use assembly.
43         // solhint-disable-next-line no-inline-assembly
44         assembly {
45             r := mload(add(signature, 0x20))
46             s := mload(add(signature, 0x40))
47             v := byte(0, mload(add(signature, 0x60)))
48         }
49 
50         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
51         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
52         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
53         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
54         //
55         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
56         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
57         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
58         // these malleable signatures as well.
59         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
60         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
61 
62         // If the signature is valid (and not malleable), return the signer address
63         address signer = ecrecover(hash, v, r, s);
64         require(signer != address(0), "ECDSA: invalid signature");
65 
66         return signer;
67     }
68 
69     /**
70      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
71      * replicates the behavior of the
72      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
73      * JSON-RPC method.
74      *
75      * See {recover}.
76      */
77     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
78         // 32 is the length in bytes of hash,
79         // enforced by the type signature above
80         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
81     }
82 }
83 
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
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
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address payable) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes memory) {
247         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
248         return msg.data;
249     }
250 }
251 
252 contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor () internal {
261         address msgSender = _msgSender();
262         _owner = msgSender;
263         emit OwnershipTransferred(address(0), msgSender);
264     }
265 
266     /**
267      * @dev Returns the address of the current owner.
268      */
269     function owner() public view returns (address) {
270         return _owner;
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         require(_owner == _msgSender(), "Ownable: caller is not the owner");
278         _;
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         emit OwnershipTransferred(_owner, address(0));
290         _owner = address(0);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Can only be called by the current owner.
296      */
297     function transferOwnership(address newOwner) public virtual onlyOwner {
298         require(newOwner != address(0), "Ownable: new owner is the zero address");
299         emit OwnershipTransferred(_owner, newOwner);
300         _owner = newOwner;
301     }
302 }
303 
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      */
322     function isContract(address account) internal view returns (bool) {
323         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
324         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
325         // for accounts without code, i.e. `keccak256('')`
326         bytes32 codehash;
327         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
328         // solhint-disable-next-line no-inline-assembly
329         assembly { codehash := extcodehash(account) }
330         return (codehash != accountHash && codehash != 0x0);
331     }
332 
333     /**
334      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
335      * `recipient`, forwarding all available gas and reverting on errors.
336      *
337      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
338      * of certain opcodes, possibly making contracts go over the 2300 gas limit
339      * imposed by `transfer`, making them unable to receive funds via
340      * `transfer`. {sendValue} removes this limitation.
341      *
342      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
343      *
344      * IMPORTANT: because control is transferred to `recipient`, care must be
345      * taken to not create reentrancy vulnerabilities. Consider using
346      * {ReentrancyGuard} or the
347      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
348      */
349     function sendValue(address payable recipient, uint256 amount) internal {
350         require(address(this).balance >= amount, "Address: insufficient balance");
351 
352         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353         (bool success, ) = recipient.call{ value: amount }("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain`call` is an unsafe replacement for a function call: use this
360      * function instead.
361      *
362      * If `target` reverts with a revert reason, it is bubbled up by this
363      * function (like regular Solidity function calls).
364      *
365      * Returns the raw returned data. To convert to the expected return value,
366      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
367      *
368      * Requirements:
369      *
370      * - `target` must be a contract.
371      * - calling `target` with `data` must not revert.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
386         return _functionCallWithValue(target, data, 0, errorMessage);
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
391      * but also transferring `value` wei to `target`.
392      *
393      * Requirements:
394      *
395      * - the calling contract must have an ETH balance of at least `value`.
396      * - the called Solidity function must be `payable`.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
411         require(address(this).balance >= value, "Address: insufficient balance for call");
412         return _functionCallWithValue(target, data, value, errorMessage);
413     }
414 
415     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
416         require(isContract(target), "Address: call to non-contract");
417 
418         // solhint-disable-next-line avoid-low-level-calls
419         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
420         if (success) {
421             return returndata;
422         } else {
423             // Look for revert reason and bubble it up if present
424             if (returndata.length > 0) {
425                 // The easiest way to bubble the revert reason is using memory via assembly
426 
427                 // solhint-disable-next-line no-inline-assembly
428                 assembly {
429                     let returndata_size := mload(returndata)
430                     revert(add(32, returndata), returndata_size)
431                 }
432             } else {
433                 revert(errorMessage);
434             }
435         }
436     }
437 }
438 
439 interface IERC20 {
440     /**
441      * @dev Returns the amount of tokens in existence.
442      */
443     function totalSupply() external view returns (uint256);
444 
445     /**
446      * @dev Returns the amount of tokens owned by `account`.
447      */
448     function balanceOf(address account) external view returns (uint256);
449 
450     /**
451      * @dev Moves `amount` tokens from the caller's account to `recipient`.
452      *
453      * Returns a boolean value indicating whether the operation succeeded.
454      *
455      * Emits a {Transfer} event.
456      */
457     function transfer(address recipient, uint256 amount) external returns (bool);
458 
459     /**
460      * @dev Returns the remaining number of tokens that `spender` will be
461      * allowed to spend on behalf of `owner` through {transferFrom}. This is
462      * zero by default.
463      *
464      * This value changes when {approve} or {transferFrom} are called.
465      */
466     function allowance(address owner, address spender) external view returns (uint256);
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
470      *
471      * Returns a boolean value indicating whether the operation succeeded.
472      *
473      * IMPORTANT: Beware that changing an allowance with this method brings the risk
474      * that someone may use both the old and the new allowance by unfortunate
475      * transaction ordering. One possible solution to mitigate this race
476      * condition is to first reduce the spender's allowance to 0 and set the
477      * desired value afterwards:
478      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
479      *
480      * Emits an {Approval} event.
481      */
482     function approve(address spender, uint256 amount) external returns (bool);
483 
484     /**
485      * @dev Moves `amount` tokens from `sender` to `recipient` using the
486      * allowance mechanism. `amount` is then deducted from the caller's
487      * allowance.
488      *
489      * Returns a boolean value indicating whether the operation succeeded.
490      *
491      * Emits a {Transfer} event.
492      */
493     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
494 
495     /**
496      * @dev Emitted when `value` tokens are moved from one account (`from`) to
497      * another (`to`).
498      *
499      * Note that `value` may be zero.
500      */
501     event Transfer(address indexed from, address indexed to, uint256 value);
502 
503     /**
504      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
505      * a call to {approve}. `value` is the new allowance.
506      */
507     event Approval(address indexed owner, address indexed spender, uint256 value);
508 }
509 
510 library SafeERC20 {
511     using SafeMath for uint256;
512     using Address for address;
513 
514     function safeTransfer(IERC20 token, address to, uint256 value) internal {
515         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
516     }
517 
518     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
519         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
520     }
521 
522     /**
523      * @dev Deprecated. This function has issues similar to the ones found in
524      * {IERC20-approve}, and its usage is discouraged.
525      *
526      * Whenever possible, use {safeIncreaseAllowance} and
527      * {safeDecreaseAllowance} instead.
528      */
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function _callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
559         // the target address contains contract code and also asserts for success in the low-level call.
560 
561         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
562         if (returndata.length > 0) { // Return data is optional
563             // solhint-disable-next-line max-line-length
564             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
565         }
566     }
567 }
568 
569 interface IMilk2Token {
570 
571     function mint(address _to, uint256 _amount) external returns (bool);
572 
573     function burn(address _to, uint256 _amount) external returns (bool);
574 
575 }
576 
577 contract MultiplierMath {
578 
579     function max(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a > b ? a : b;
581     }
582 
583 
584     function min(uint256 a, uint256 b) internal pure returns (uint256) {
585         return a < b ? a : b;
586     }
587 
588 
589     function getInterval(uint256 a, uint256 b) internal pure returns(uint256) {
590         return a > b ? a - b : 0;
591     }
592 
593 }
594 
595 contract ShadowStakingV3 is Ownable,  MultiplierMath {
596     using SafeMath for uint256;
597     using SafeERC20 for IERC20;
598     using ECDSA for bytes32;
599 
600     struct UserInfo {
601         uint256 rewardDebt;
602         uint256 lastBlock;
603     }
604 
605 
606     struct PoolInfo {
607         IERC20 lpToken;
608         uint256 allocPointAmount;
609         uint256 blockCreation;
610     }
611 
612     IMilk2Token public milk;
613 
614     mapping (address => UserInfo) private userInfo;
615     mapping (address => bool) public trustedSigner;
616 
617     address[] internal users;
618 
619 
620     PoolInfo[] private poolInfo;
621 
622 
623     uint256 private totalPoints;
624 
625     uint256[5] internal epochs;
626 
627     uint256[5] internal multipliers;
628 
629 
630     event Harvest(address sender, uint256 amount, uint256 blockNumber);
631     event AddNewPool(address token, uint256 pid);
632     event PoolUpdate(uint256 poolPid, uint256 previusPoints, uint256 newPoints);
633     event AddNewKey(bytes keyHash, uint256 id);
634 
635 
636     constructor(IMilk2Token _milk, uint256[5] memory _epochs, uint256[5] memory _multipliers) public {
637         milk = _milk;
638         epochs = _epochs;
639         multipliers = _multipliers;
640 
641         //For debug
642         trustedSigner[msg.sender]=true;
643     }
644 
645 
646     /**
647       * @dev Add a new lp to the pool.
648       *
649       * @param _lpToken - address of ERC-20 LP token
650        * @param _newPoints - share in the total amount of rewards
651       * DO NOT add the same LP token more than once. Rewards will be messed up if you do.
652       * Can only be called by the current owner.
653       */
654     function addNewPool(IERC20 _lpToken, uint256 _newPoints) public onlyOwner {
655         totalPoints = totalPoints.add(_newPoints);
656         poolInfo.push(PoolInfo({lpToken: _lpToken, allocPointAmount: _newPoints, blockCreation:block.number}));
657         emit AddNewPool(address(_lpToken), _newPoints);
658     }
659 
660 
661     /**
662      * @dev Update lp address to the pool.
663      *
664      * @param _poolPid - number of pool
665      * @param _newPoints - new amount of allocation points
666      * DO NOT add the same LP token more than once. Rewards will be messed up if you do.
667      * Can only be called by the current owner.
668      */
669     function setPoll(uint256 _poolPid, uint256 _newPoints) public onlyOwner {
670         totalPoints = totalPoints.sub(poolInfo[_poolPid].allocPointAmount).add(_newPoints);
671         poolInfo[_poolPid].allocPointAmount = _newPoints;
672     }
673 
674 
675     /**
676     *@dev set address that can sign
677     */
678     function setTrustedSigner(address _signer, bool _isValid) public onlyOwner {
679         trustedSigner[_signer] = _isValid;
680     }
681 
682 
683     function getPool(uint256 _poolPid) public view returns(address _lpToken, uint256 _block, uint256 _weight) {
684         _lpToken = address(poolInfo[_poolPid].lpToken);
685         _block = poolInfo[_poolPid].blockCreation;
686         _weight = poolInfo[_poolPid].allocPointAmount;
687     }
688 
689 
690     /**
691       * @dev - return Number of keys
692       */
693     function getPoolsCount() public view returns(uint256) {
694         return poolInfo.length;
695     }
696 
697 
698     /**
699       * @dev - return info about current user's reward
700       * @param _user - user's address
701       */
702     function getRewards(address _user) public view returns(uint256) {
703         return  userInfo[_user].rewardDebt;
704     }
705 
706 
707     /**
708       * @dev - return info about user's last block with update
709       *
710       * @param _user - user's address
711       */
712     function getLastBlock(address _user) public view returns(uint256) {
713         return userInfo[_user].lastBlock;
714     }
715 
716 
717     /**
718     * @dev - return total allocation points
719     */
720     function getTotalPoints() public view returns(uint256) {
721         return totalPoints;
722     }
723 
724 
725     function registration() public {
726         require(userInfo[msg.sender].lastBlock == 0, "User already exist");
727         UserInfo storage _userInfo = userInfo[msg.sender];
728         _userInfo.rewardDebt = 0;
729         _userInfo.lastBlock = block.number;
730         users.push(msg.sender);
731     }
732 
733 
734     function getData(uint256 _amount,
735         uint256 _lastBlockNumber,
736         uint256 _currentBlockNumber,
737         address _sender) public pure returns(bytes32) {
738         return sha256(abi.encode(_amount, _lastBlockNumber, _currentBlockNumber, _sender));
739     }
740 
741     ///////////////////////////////////////////////////////////////////////////////////////
742     ///// Refactored items
743     /////////////////////////////////////////////////////////////////////////////////////
744     /**
745     *@dev Prepare abi encoded message
746     */
747     function getMsgForSign(
748         uint256 _amount,
749         uint256 _lastBlockNumber,
750         uint256 _currentBlockNumber,
751         address _sender) public pure returns(bytes32)
752     {
753         return keccak256(abi.encode(_amount, _lastBlockNumber, _currentBlockNumber, _sender));
754     }
755 
756     /**
757     * @dev prepare hash for sign with Ethereum comunity convention
758     *see links below
759     *https://ethereum.stackexchange.com/questions/24547/sign-without-x19ethereum-signed-message-prefix?rq=1
760     *https://github.com/ethereum/EIPs/pull/712
761     *https://programtheblockchain.com/posts/2018/02/17/signing-and-verifying-messages-in-ethereum/
762     */
763     function preSignMsg(bytes32 _msg) public pure returns(bytes32) {
764         return _msg.toEthSignedMessageHash();
765     }
766 
767 
768     /**
769     * @dev Check signature and mint tokens
770     * @param  _amount - subj
771     * @param  _lastBlockNumber - subj
772     * @param  _currentBlockNumber - subj
773     * @param  _msgForSign - hash for sign with Ethereum style prefix!!!
774     * @param  _signature  - signature
775     */
776     function harvest(
777         uint256 _amount,
778         uint256 _lastBlockNumber,
779         uint256 _currentBlockNumber,
780         bytes32 _msgForSign,
781         bytes memory _signature)
782     public
783     {
784         require(_currentBlockNumber <= block.number, "currentBlockNumber cannot be larger than the last block");
785 
786         //Double spend check
787         require(userInfo[msg.sender].lastBlock == _lastBlockNumber, "lastBlockNumber must be equal to the value in the storage");
788 
789         //1. Lets check signer
790         address signedBy = _msgForSign.recover(_signature);
791         require(trustedSigner[signedBy] == true, "Signature check failed!");
792 
793         //2. Check signed msg integrety
794         bytes32 actualMsg = getMsgForSign(
795             _amount,
796             _lastBlockNumber,
797             _currentBlockNumber,
798             msg.sender
799         );
800         require(actualMsg.toEthSignedMessageHash() == _msgForSign,"Integrety check failed!");
801 
802         //Actions
803         userInfo[msg.sender].rewardDebt = userInfo[msg.sender].rewardDebt.add(_amount);
804         userInfo[msg.sender].lastBlock = _currentBlockNumber;
805         if (_amount > 0) {
806             milk.mint(msg.sender, _amount);
807         }
808         emit Harvest(msg.sender, _amount, _currentBlockNumber);
809     }
810 
811 
812     /**
813     * @dev Check signature and mint tokens
814     * @param  _amount - subj
815     * @param  _lastBlockNumber - subj
816     * @param  _currentBlockNumber - subj
817     * @param  _msgForSign - hash for sign with Ethereum style prefix!!!
818     * @param  _signature  - signature
819     */
820     function debug_harvest(
821         uint256 _amount,
822         uint256 _lastBlockNumber,
823         uint256 _currentBlockNumber,
824         bytes32 _msgForSign,
825         bytes memory _signature)
826     public view returns(address _signer, bytes32 _msg, bytes32 _prefixedMsg)
827     {
828         require(_currentBlockNumber <= block.number, "currentBlockNumber cannot be larger than the last block");
829 
830         //Double spend check
831         require(userInfo[msg.sender].lastBlock == _lastBlockNumber, "lastBlockNumber must be equal to the value in the storage");
832 
833         //1. Lets check signer
834         address signedBy = _msgForSign.recover(_signature);
835         //require(trustedSigner[signedBy] == true, "Signature check failed!");
836 
837         //2. Check signed msg integrety
838         bytes32 actualMsg = getMsgForSign(
839             _amount,
840             _lastBlockNumber,
841             _currentBlockNumber,
842             msg.sender
843         );
844         //require(actualMsg.toEthSignedMessageHash() == _msgForSign,"Integrety check failed!");
845 
846         // //Actions
847         // userInfo[msg.sender].rewardDebt = userInfo[msg.sender].rewardDebt.add(_amount);
848         // userInfo[msg.sender].lastBlock = _currentBlockNumber;
849         // if (_amount > 0) {
850         //     milk.mint(msg.sender, _amount);
851         // }
852         // emit Harvest(msg.sender, _amount, _currentBlockNumber);
853         return (signedBy, actualMsg, actualMsg.toEthSignedMessageHash());
854     }
855     ///////////////////////////////////////////////////////////////////////////////////////
856     ///////////////////////////////////////////////////////////////////////////////////////
857 
858 
859     /**
860      * @dev - return Number of users
861      */
862     function getUsersCount() public view returns(uint256) {
863         return users.length;
864     }
865 
866 
867     /**
868      * @dev - return address of user
869      * @param - _userId - unique number of user in array
870      */
871     function getUser(uint256 _userId) public view returns(address) {
872         return users[_userId];
873     }
874 
875 
876     /**
877      * @dev - return total rewards
878      */
879     function getTotalRewards(address _user) public view returns(uint256) {
880         return userInfo[_user].rewardDebt;
881     }
882 
883 
884     /**
885     * @param - _id - multiplier's id (0-4)
886     * @dev - return value of multiplier
887     */
888     function getValueMultiplier(uint256 _id) public view returns(uint256) {
889         return multipliers[_id];
890     }
891 
892 
893     /**
894     * @param - _id - epoch's id(0-4)
895     * @dev - return value of epoch
896     */
897     function getValueEpoch(uint256 _id) public view returns(uint256) {
898         return epochs[_id];
899     }
900 
901 
902     function getMultiplier(uint256 f, uint256 t) public view returns(uint256) {
903         return getInterval(min(t, epochs[1]), max(f, epochs[0])) * multipliers[0] +
904         getInterval(min(t, epochs[2]), max(f, epochs[1])) * multipliers[1] +
905         getInterval(min(t, epochs[3]), max(f, epochs[2])) * multipliers[2] +
906         getInterval(min(t, epochs[4]), max(f, epochs[3])) * multipliers[3] +
907         getInterval(max(t, epochs[4]), max(f, epochs[4])) * multipliers[4];
908     }
909 
910 
911     function getCurrentMultiplier() public view returns(uint256) {
912         if (block.number < epochs[0]) {
913             return 0;
914         }
915         if (block.number < epochs[1]) {
916             return multipliers[0];
917         }
918         if (block.number < epochs[2]) {
919             return multipliers[1];
920         }
921         if (block.number < epochs[3]) {
922             return multipliers[2];
923         }
924         if (block.number < epochs[4]) {
925             return multipliers[3];
926         }
927         if (block.number > epochs[4]) {
928             return multipliers[4];
929         }
930     }
931 
932 
933     function setEpoch(uint256 _id, uint256 _amount) public onlyOwner {
934         epochs[_id] = _amount;
935     }
936 
937 
938     function setMultiplier(uint256 _id, uint256 _amount) public onlyOwner {
939         multipliers[_id] = _amount;
940     }
941 
942 }