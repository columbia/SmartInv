1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 library ECDSA {
6     /**
7      * @dev Returns the address that signed a hashed message (`hash`) with
8      * `signature`. This address can then be used for verification purposes.
9      *
10      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
11      * this function rejects them by requiring the `s` value to be in the lower
12      * half order, and the `v` value to be either 27 or 28.
13      *
14      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
15      * verification to be secure: it is possible to craft signatures that
16      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
17      * this is by receiving a hash of the original message (which may otherwise
18      * be too long), and then calling {toEthSignedMessageHash} on it.
19      */
20     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
21         // Check the signature length
22         if (signature.length != 65) {
23             revert("ECDSA: invalid signature length");
24         }
25 
26         // Divide the signature in r, s and v variables
27         bytes32 r;
28         bytes32 s;
29         uint8 v;
30 
31         // ecrecover takes the signature parameters, and the only way to get them
32         // currently is to use assembly.
33         // solhint-disable-next-line no-inline-assembly
34         assembly {
35             r := mload(add(signature, 0x20))
36             s := mload(add(signature, 0x40))
37             v := byte(0, mload(add(signature, 0x60)))
38         }
39 
40         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
41         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
42         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
43         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
44         //
45         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
46         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
47         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
48         // these malleable signatures as well.
49         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
50         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
51 
52         // If the signature is valid (and not malleable), return the signer address
53         address signer = ecrecover(hash, v, r, s);
54         require(signer != address(0), "ECDSA: invalid signature");
55 
56         return signer;
57     }
58 
59     /**
60      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
61      * replicates the behavior of the
62      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
63      * JSON-RPC method.
64      *
65      * See {recover}.
66      */
67     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
68         // 32 is the length in bytes of hash,
69         // enforced by the type signature above
70         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
71     }
72 }
73 
74 library SafeMath {
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return sub(a, b, "SafeMath: subtraction overflow");
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         require(b <= a, errorMessage);
118         uint256 c = a - b;
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      *
157      * - The divisor cannot be zero.
158      */
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162 
163     /**
164      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
165      * division by zero. The result is rounded towards zero.
166      *
167      * Counterpart to Solidity's `/` operator. Note: this function uses a
168      * `revert` opcode (which leaves remaining gas untouched) while Solidity
169      * uses an invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      *
173      * - The divisor cannot be zero.
174      */
175     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b > 0, errorMessage);
177         uint256 c = a / b;
178         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
196         return mod(a, b, "SafeMath: modulo by zero");
197     }
198 
199     /**
200      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
201      * Reverts with custom message when dividing by zero.
202      *
203      * Counterpart to Solidity's `%` operator. This function uses a `revert`
204      * opcode (which leaves remaining gas untouched) while Solidity uses an
205      * invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b != 0, errorMessage);
213         return a % b;
214     }
215 }
216 
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address payable) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes memory) {
223         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
224         return msg.data;
225     }
226 }
227 
228 contract Ownable is Context {
229     address private _owner;
230 
231     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
232 
233     /**
234      * @dev Initializes the contract setting the deployer as the initial owner.
235      */
236     constructor () internal {
237         address msgSender = _msgSender();
238         _owner = msgSender;
239         emit OwnershipTransferred(address(0), msgSender);
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(_owner == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         emit OwnershipTransferred(_owner, address(0));
266         _owner = address(0);
267     }
268 
269     /**
270      * @dev Transfers ownership of the contract to a new account (`newOwner`).
271      * Can only be called by the current owner.
272      */
273     function transferOwnership(address newOwner) public virtual onlyOwner {
274         require(newOwner != address(0), "Ownable: new owner is the zero address");
275         emit OwnershipTransferred(_owner, newOwner);
276         _owner = newOwner;
277     }
278 }
279 
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 interface IERC20 {
416     /**
417      * @dev Returns the amount of tokens in existence.
418      */
419     function totalSupply() external view returns (uint256);
420 
421     /**
422      * @dev Returns the amount of tokens owned by `account`.
423      */
424     function balanceOf(address account) external view returns (uint256);
425 
426     /**
427      * @dev Moves `amount` tokens from the caller's account to `recipient`.
428      *
429      * Returns a boolean value indicating whether the operation succeeded.
430      *
431      * Emits a {Transfer} event.
432      */
433     function transfer(address recipient, uint256 amount) external returns (bool);
434 
435     /**
436      * @dev Returns the remaining number of tokens that `spender` will be
437      * allowed to spend on behalf of `owner` through {transferFrom}. This is
438      * zero by default.
439      *
440      * This value changes when {approve} or {transferFrom} are called.
441      */
442     function allowance(address owner, address spender) external view returns (uint256);
443 
444     /**
445      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
446      *
447      * Returns a boolean value indicating whether the operation succeeded.
448      *
449      * IMPORTANT: Beware that changing an allowance with this method brings the risk
450      * that someone may use both the old and the new allowance by unfortunate
451      * transaction ordering. One possible solution to mitigate this race
452      * condition is to first reduce the spender's allowance to 0 and set the
453      * desired value afterwards:
454      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
455      *
456      * Emits an {Approval} event.
457      */
458     function approve(address spender, uint256 amount) external returns (bool);
459 
460     /**
461      * @dev Moves `amount` tokens from `sender` to `recipient` using the
462      * allowance mechanism. `amount` is then deducted from the caller's
463      * allowance.
464      *
465      * Returns a boolean value indicating whether the operation succeeded.
466      *
467      * Emits a {Transfer} event.
468      */
469     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
470 
471     /**
472      * @dev Emitted when `value` tokens are moved from one account (`from`) to
473      * another (`to`).
474      *
475      * Note that `value` may be zero.
476      */
477     event Transfer(address indexed from, address indexed to, uint256 value);
478 
479     /**
480      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
481      * a call to {approve}. `value` is the new allowance.
482      */
483     event Approval(address indexed owner, address indexed spender, uint256 value);
484 }
485 
486 library SafeERC20 {
487     using SafeMath for uint256;
488     using Address for address;
489 
490     function safeTransfer(IERC20 token, address to, uint256 value) internal {
491         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
492     }
493 
494     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
495         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
496     }
497 
498     /**
499      * @dev Deprecated. This function has issues similar to the ones found in
500      * {IERC20-approve}, and its usage is discouraged.
501      *
502      * Whenever possible, use {safeIncreaseAllowance} and
503      * {safeDecreaseAllowance} instead.
504      */
505     function safeApprove(IERC20 token, address spender, uint256 value) internal {
506         // safeApprove should only be called when setting an initial allowance,
507         // or when resetting it to zero. To increase and decrease it, use
508         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
509         // solhint-disable-next-line max-line-length
510         require((value == 0) || (token.allowance(address(this), spender) == 0),
511             "SafeERC20: approve from non-zero to non-zero allowance"
512         );
513         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
514     }
515 
516     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
517         uint256 newAllowance = token.allowance(address(this), spender).add(value);
518         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
519     }
520 
521     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
522         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
523         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
524     }
525 
526     /**
527      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
528      * on the return value: the return value is optional (but if data is returned, it must not be false).
529      * @param token The token targeted by the call.
530      * @param data The call data (encoded using abi.encode or one of its variants).
531      */
532     function _callOptionalReturn(IERC20 token, bytes memory data) private {
533         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
534         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
535         // the target address contains contract code and also asserts for success in the low-level call.
536 
537         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
538         if (returndata.length > 0) { // Return data is optional
539             // solhint-disable-next-line max-line-length
540             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
541         }
542     }
543 }
544 
545 interface IMilk2Token {
546 
547     function transfer(address _to, uint256 _amount) external returns (bool);
548 
549     function balanceOf(address _to) external returns (uint256);
550 
551 }
552 
553 contract MultiplierMath {
554 
555     function max(uint256 a, uint256 b) internal pure returns (uint256) {
556         return a > b ? a : b;
557     }
558 
559 
560     function min(uint256 a, uint256 b) internal pure returns (uint256) {
561         return a < b ? a : b;
562     }
563 
564 
565     function getInterval(uint256 a, uint256 b) internal pure returns(uint256) {
566         return a > b ? a - b : 0;
567     }
568 
569 }
570 
571 interface LastShadowContract {
572 
573     function getRewards(address _user) external view returns(uint256);
574 
575     function getTotalRewards(address _user) external view returns(uint256);
576 
577     function getLastBlock(address _user) external view returns(uint256);
578 
579     function getUsersCount() external view returns(uint256);
580 
581     function getUser(uint256 _userId) external view returns(address);
582 }
583 
584 contract ShadowStakingV4 is Ownable,  MultiplierMath {
585     using SafeMath for uint256;
586     using SafeERC20 for IERC20;
587     using ECDSA for bytes32;
588 
589     struct UserInfo {
590         uint256 rewardDebt;
591         uint256 lastBlock;
592     }
593 
594 
595     struct PoolInfo {
596         IERC20 lpToken;
597         uint256 allocPointAmount;
598         uint256 blockCreation;
599     }
600 
601     IMilk2Token public milk;
602 
603     LastShadowContract public lastShadowContract;
604 
605     mapping (address => UserInfo) private userInfo;
606     mapping (address => bool) public trustedSigner;
607 
608     address[] internal users;
609 
610     uint256 internal previousUsersCount;
611 
612     mapping (address => uint256) public newUsersId;
613 
614     PoolInfo[] private poolInfo;
615 
616     uint256 private totalPoints;
617 
618     uint256[5] internal epochs;
619 
620     uint256[5] internal multipliers;
621 
622     event Harvest(address sender, uint256 amount, uint256 blockNumber);
623     event AddNewPool(address token, uint256 pid);
624     event PoolUpdate(uint256 poolPid, uint256 previusPoints, uint256 newPoints);
625     event AddNewKey(bytes keyHash, uint256 id);
626     event EmergencyRefund(address sender, uint256 amount);
627 
628     constructor(IMilk2Token _milk, uint256[5] memory _epochs, uint256[5] memory _multipliers, LastShadowContract _lastShadowContract) public {
629         milk = _milk;
630         epochs = _epochs;
631         multipliers = _multipliers;
632         lastShadowContract = _lastShadowContract;
633         previousUsersCount = lastShadowContract.getUsersCount();
634     }
635 
636 
637     function addNewPool(IERC20 _lpToken, uint256 _newPoints) public onlyOwner {
638         totalPoints = totalPoints.add(_newPoints);
639         poolInfo.push(PoolInfo({lpToken: _lpToken, allocPointAmount: _newPoints, blockCreation:block.number}));
640         emit AddNewPool(address(_lpToken), _newPoints);
641     }
642 
643 
644     function setPoll(uint256 _poolPid, uint256 _newPoints) public onlyOwner {
645         totalPoints = totalPoints.sub(poolInfo[_poolPid].allocPointAmount).add(_newPoints);
646         poolInfo[_poolPid].allocPointAmount = _newPoints;
647     }
648 
649 
650     function setTrustedSigner(address _signer, bool _isValid) public onlyOwner {
651         trustedSigner[_signer] = _isValid;
652     }
653 
654 
655     function getPool(uint256 _poolPid) public view returns(address _lpToken, uint256 _block, uint256 _weight) {
656         _lpToken = address(poolInfo[_poolPid].lpToken);
657         _block = poolInfo[_poolPid].blockCreation;
658         _weight = poolInfo[_poolPid].allocPointAmount;
659     }
660 
661 
662     function getPoolsCount() public view returns(uint256) {
663         return poolInfo.length;
664     }
665 
666 
667     function getRewards(address _user) public view returns(uint256) {
668         if (newUsersId[_user] == 0) {
669             return  lastShadowContract.getRewards(_user);
670         } else {
671             return  userInfo[_user].rewardDebt;
672         }
673     }
674 
675 
676     function getLastBlock(address _user) public view returns(uint256) {
677         if (newUsersId[_user] == 0) {
678             return lastShadowContract.getLastBlock(_user);
679         } else {
680             return userInfo[_user].lastBlock;
681         }
682     }
683 
684 
685     function getTotalPoints() public view returns(uint256) {
686         return totalPoints;
687     }
688 
689 
690     function registration() public {
691         require(getLastBlock(msg.sender) == 0, "User already exist");
692 
693         _registration(msg.sender, 0, block.number);
694     }
695 
696 
697     function getData(uint256 _amount, uint256 _lastBlockNumber, uint256 _currentBlockNumber, address _sender) public pure returns(bytes32) {
698         return sha256(abi.encode(_amount, _lastBlockNumber, _currentBlockNumber, _sender));
699     }
700 
701     ///////////////////////////////////////////////////////////////////////////////////////
702     ///// Refactored items
703     /////////////////////////////////////////////////////////////////////////////////////
704     /**
705     *@dev Prepare abi encoded message
706     */
707     function getMsgForSign(uint256 _amount, uint256 _lastBlockNumber, uint256 _currentBlockNumber, address _sender) public pure returns(bytes32) {
708         return keccak256(abi.encode(_amount, _lastBlockNumber, _currentBlockNumber, _sender));
709     }
710 
711     /**
712     * @dev prepare hash for sign with Ethereum comunity convention
713     *see links below
714     *https://ethereum.stackexchange.com/questions/24547/sign-without-x19ethereum-signed-message-prefix?rq=1
715     *https://github.com/ethereum/EIPs/pull/712
716     *https://programtheblockchain.com/posts/2018/02/17/signing-and-verifying-messages-in-ethereum/
717     */
718     function preSignMsg(bytes32 _msg) public pure returns(bytes32) {
719         return _msg.toEthSignedMessageHash();
720     }
721 
722 
723     /**
724     * @dev Check signature and transfer tokens
725     * @param  _amount - subj
726     * @param  _lastBlockNumber - subj
727     * @param  _currentBlockNumber - subj
728     * @param  _msgForSign - hash for sign with Ethereum style prefix!!!
729     * @param  _signature  - signature
730     */
731     function harvest(uint256 _amount, uint256 _lastBlockNumber, uint256 _currentBlockNumber, bytes32 _msgForSign, bytes memory _signature) public {
732         require(_currentBlockNumber <= block.number, "currentBlockNumber cannot be larger than the last block");
733 
734         if (newUsersId[msg.sender] == 0) {
735             _registration(msg.sender, getRewards(msg.sender), getLastBlock(msg.sender));
736         }
737 
738         //Double spend check
739         require(getLastBlock(msg.sender) == _lastBlockNumber, "lastBlockNumber must be equal to the value in the storage");
740 
741         //1. Lets check signer
742         address signedBy = _msgForSign.recover(_signature);
743         require(trustedSigner[signedBy] == true, "Signature check failed!");
744 
745         //2. Check signed msg integrety
746         bytes32 actualMsg = getMsgForSign(
747             _amount,
748             _lastBlockNumber,
749             _currentBlockNumber,
750             msg.sender
751         );
752         require(actualMsg.toEthSignedMessageHash() == _msgForSign,"Integrety check failed!");
753 
754         //Actions
755 
756         userInfo[msg.sender].rewardDebt = userInfo[msg.sender].rewardDebt.add(_amount);
757         userInfo[msg.sender].lastBlock = _currentBlockNumber;
758         if (_amount > 0) {
759             milk.transfer(msg.sender, _amount);
760         }
761         emit Harvest(msg.sender, _amount, _currentBlockNumber);
762     }
763 
764 
765 
766     function getUsersCount() public view returns(uint256) {
767         return users.length.add(previousUsersCount);
768     }
769 
770 
771     function getUser(uint256 _userId) public view returns(address) {
772         if (_userId < previousUsersCount) {
773             return lastShadowContract.getUser(_userId);
774         }
775         else {
776             return users[_userId.sub(previousUsersCount)];
777         }
778     }
779 
780 
781     function getTotalRewards(address _user) public view returns(uint256) {
782         if (newUsersId[_user] == 0) {
783             return lastShadowContract.getTotalRewards(_user);
784         }
785         else {
786             return userInfo[_user].rewardDebt;
787         }
788     }
789 
790 
791     function _registration(address _user, uint256 _rewardDebt, uint256 _lastBlock) internal {
792         UserInfo storage _userInfo = userInfo[_user];
793         _userInfo.rewardDebt = _rewardDebt;
794         _userInfo.lastBlock = _lastBlock;
795         users.push(_user);
796         newUsersId[_user] = users.length;
797     }
798 
799 
800     function getValueMultiplier(uint256 _id) public view returns(uint256) {
801         return multipliers[_id];
802     }
803 
804 
805     function getValueEpoch(uint256 _id) public view returns(uint256) {
806         return epochs[_id];
807     }
808 
809 
810     function getMultiplier(uint256 f, uint256 t) public view returns(uint256) {
811         return getInterval(min(t, epochs[1]), max(f, epochs[0])) * multipliers[0] +
812         getInterval(min(t, epochs[2]), max(f, epochs[1])) * multipliers[1] +
813         getInterval(min(t, epochs[3]), max(f, epochs[2])) * multipliers[2] +
814         getInterval(min(t, epochs[4]), max(f, epochs[3])) * multipliers[3] +
815         getInterval(max(t, epochs[4]), max(f, epochs[4])) * multipliers[4];
816     }
817 
818 
819     function getCurrentMultiplier() public view returns(uint256) {
820         if (block.number < epochs[0]) {
821             return 0;
822         }
823         if (block.number < epochs[1]) {
824             return multipliers[0];
825         }
826         if (block.number < epochs[2]) {
827             return multipliers[1];
828         }
829         if (block.number < epochs[3]) {
830             return multipliers[2];
831         }
832         if (block.number < epochs[4]) {
833             return multipliers[3];
834         }
835         if (block.number > epochs[4]) {
836             return multipliers[4];
837         }
838     }
839 
840 
841     function setEpoch(uint256 _id, uint256 _amount) public onlyOwner {
842         epochs[_id] = _amount;
843     }
844 
845 
846     function setMultiplier(uint256 _id, uint256 _amount) public onlyOwner {
847         multipliers[_id] = _amount;
848     }
849 
850 
851     function emergencyRefund() public onlyOwner {
852         emit EmergencyRefund(msg.sender, milk.balanceOf(address(this)));
853         milk.transfer(owner(), milk.balanceOf(address(this)));
854     }
855 
856 }