1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations.
81  *
82  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
83  * now has built in overflow checking.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, with an overflow flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             uint256 c = a + b;
94             if (c < a) return (false, 0);
95             return (true, c);
96         }
97     }
98 
99     /**
100      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
101      *
102      * _Available since v3.4._
103      */
104     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
105         unchecked {
106             if (b > a) return (false, 0);
107             return (true, a - b);
108         }
109     }
110 
111     /**
112      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
113      *
114      * _Available since v3.4._
115      */
116     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
117         unchecked {
118             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
119             // benefit is lost if 'b' is also tested.
120             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
121             if (a == 0) return (true, 0);
122             uint256 c = a * b;
123             if (c / a != b) return (false, 0);
124             return (true, c);
125         }
126     }
127 
128     /**
129      * @dev Returns the division of two unsigned integers, with a division by zero flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             if (b == 0) return (false, 0);
136             return (true, a / b);
137         }
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
142      *
143      * _Available since v3.4._
144      */
145     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
146         unchecked {
147             if (b == 0) return (false, 0);
148             return (true, a % b);
149         }
150     }
151 
152     /**
153      * @dev Returns the addition of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `+` operator.
157      *
158      * Requirements:
159      *
160      * - Addition cannot overflow.
161      */
162     function add(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a + b;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a - b;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a * b;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers, reverting on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator.
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return a / b;
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * reverting when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a % b;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * CAUTION: This function is deprecated because it requires allocating memory for the error
229      * message unnecessarily. For custom revert reasons use {trySub}.
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         unchecked {
239             require(b <= a, errorMessage);
240             return a - b;
241         }
242     }
243 
244     /**
245      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
246      * division by zero. The result is rounded towards zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Counterpart to Solidity's `/` operator. Note: this function uses a
253      * `revert` opcode (which leaves remaining gas untouched) while Solidity
254      * uses an invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         unchecked {
262             require(b > 0, errorMessage);
263             return a / b;
264         }
265     }
266 
267     /**
268      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
269      * reverting with custom message when dividing by zero.
270      *
271      * CAUTION: This function is deprecated because it requires allocating memory for the error
272      * message unnecessarily. For custom revert reasons use {tryMod}.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a % b;
286         }
287     }
288 }
289 
290 
291 
292 /**
293  * @dev These functions deal with verification of Merkle Trees proofs.
294  *
295  * The proofs can be generated using the JavaScript library
296  * https://github.com/miguelmota/merkletreejs[merkletreejs].
297  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
298  *
299  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
300  */
301 library MerkleProof {
302     /**
303      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
304      * defined by `root`. For this, a `proof` must be provided, containing
305      * sibling hashes on the branch from the leaf to the root of the tree. Each
306      * pair of leaves and each pair of pre-images are assumed to be sorted.
307      */
308     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
309         bytes32 computedHash = leaf;
310 
311         for (uint256 i = 0; i < proof.length; i++) {
312             bytes32 proofElement = proof[i];
313 
314             if (computedHash <= proofElement) {
315                 // Hash(current computed hash + current element of the proof)
316                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
317             } else {
318                 // Hash(current element of the proof + current computed hash)
319                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
320             }
321         }
322 
323         // Check if the computed hash (root) is equal to the provided root
324         return computedHash == root;
325     }
326 }
327 
328 
329 // Allows anyone to claim a token if they exist in a merkle root.
330 interface IMerkleDistributor {
331     // Returns the address of the token distributed by this contract.
332     function token() external view returns (address);
333 
334     // Returns the merkle root of the merkle tree containing account balances available to claim.
335     function merkleRoot() external view returns (bytes32);
336 
337     // Returns true if the index has been marked claimed.
338     function isClaimed(uint256 index) external view returns (bool);
339 
340     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
341     function claim(
342         uint256 index,
343         address account,
344         uint256 amount,
345         bytes32[] calldata merkleProof
346     ) external;
347 
348     // This event is triggered whenever a call to #claim succeeds.
349     event Claimed(uint256 index, address account, uint256 amount);
350 }
351 
352 
353 
354 /**
355  * @dev Collection of functions related to the address type
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      * ====
374      */
375     function isContract(address account) internal view returns (bool) {
376         // This method relies on extcodesize, which returns 0 for contracts in
377         // construction, since the code is only stored at the end of the
378         // constructor execution.
379 
380         uint256 size;
381         // solhint-disable-next-line no-inline-assembly
382         assembly { size := extcodesize(account) }
383         return size > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
406         (bool success, ) = recipient.call{ value: amount }("");
407         require(success, "Address: unable to send value, recipient may have reverted");
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain`call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
429       return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, 0, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but also transferring `value` wei to `target`.
445      *
446      * Requirements:
447      *
448      * - the calling contract must have an ETH balance of at least `value`.
449      * - the called Solidity function must be `payable`.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
459      * with `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
464         require(address(this).balance >= value, "Address: insufficient balance for call");
465         require(isContract(target), "Address: call to non-contract");
466 
467         // solhint-disable-next-line avoid-low-level-calls
468         (bool success, bytes memory returndata) = target.call{ value: value }(data);
469         return _verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
489         require(isContract(target), "Address: static call to non-contract");
490 
491         // solhint-disable-next-line avoid-low-level-calls
492         (bool success, bytes memory returndata) = target.staticcall(data);
493         return _verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
503         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
508      * but performing a delegate call.
509      *
510      * _Available since v3.4._
511      */
512     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         // solhint-disable-next-line avoid-low-level-calls
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return _verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
521         if (success) {
522             return returndata;
523         } else {
524             // Look for revert reason and bubble it up if present
525             if (returndata.length > 0) {
526                 // The easiest way to bubble the revert reason is using memory via assembly
527 
528                 // solhint-disable-next-line no-inline-assembly
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 
541 /**
542  * @title SafeERC20
543  * @dev Wrappers around ERC20 operations that throw on failure (when the token
544  * contract returns false). Tokens that return no value (and instead revert or
545  * throw on failure) are also supported, non-reverting calls are assumed to be
546  * successful.
547  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
548  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
549  */
550 library SafeERC20 {
551     using Address for address;
552 
553     function safeTransfer(IERC20 token, address to, uint256 value) internal {
554         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
555     }
556 
557     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
558         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
559     }
560 
561     /**
562      * @dev Deprecated. This function has issues similar to the ones found in
563      * {IERC20-approve}, and its usage is discouraged.
564      *
565      * Whenever possible, use {safeIncreaseAllowance} and
566      * {safeDecreaseAllowance} instead.
567      */
568     function safeApprove(IERC20 token, address spender, uint256 value) internal {
569         // safeApprove should only be called when setting an initial allowance,
570         // or when resetting it to zero. To increase and decrease it, use
571         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
572         // solhint-disable-next-line max-line-length
573         require((value == 0) || (token.allowance(address(this), spender) == 0),
574             "SafeERC20: approve from non-zero to non-zero allowance"
575         );
576         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
577     }
578 
579     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
580         uint256 newAllowance = token.allowance(address(this), spender) + value;
581         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
582     }
583 
584     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
585         unchecked {
586             uint256 oldAllowance = token.allowance(address(this), spender);
587             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
588             uint256 newAllowance = oldAllowance - value;
589             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
590         }
591     }
592 
593     /**
594      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
595      * on the return value: the return value is optional (but if data is returned, it must not be false).
596      * @param token The token targeted by the call.
597      * @param data The call data (encoded using abi.encode or one of its variants).
598      */
599     function _callOptionalReturn(IERC20 token, bytes memory data) private {
600         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
601         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
602         // the target address contains contract code and also asserts for success in the low-level call.
603 
604         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
605         if (returndata.length > 0) { // Return data is optional
606             // solhint-disable-next-line max-line-length
607             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
608         }
609     }
610 }
611 
612 
613 // https://docs.synthetix.io/contracts/source/contracts/owned
614 contract Owned {
615     address public owner;
616     address public nominatedOwner;
617 
618     constructor(address _owner) {
619         require(_owner != address(0), "Owner address cannot be 0");
620         owner = _owner;
621         emit OwnerChanged(address(0), _owner);
622     }
623 
624     function nominateNewOwner(address _owner) external onlyOwner {
625         nominatedOwner = _owner;
626         emit OwnerNominated(_owner);
627     }
628 
629     function acceptOwnership() external {
630         require(
631             msg.sender == nominatedOwner,
632             "You must be nominated before you can accept ownership"
633         );
634         emit OwnerChanged(owner, nominatedOwner);
635         owner = nominatedOwner;
636         nominatedOwner = address(0);
637     }
638 
639     modifier onlyOwner {
640         _onlyOwner();
641         _;
642     }
643 
644     function _onlyOwner() private view {
645         require(
646             msg.sender == owner,
647             "Only the contract owner may perform this action"
648         );
649     }
650 
651     event OwnerNominated(address newOwner);
652     event OwnerChanged(address oldOwner, address newOwner);
653 }
654 
655 
656 contract MerkleDistributor is IMerkleDistributor, Owned {
657     using SafeMath for uint256;
658     using SafeERC20 for IERC20;
659 
660     address public immutable override token;
661     bytes32 public immutable override merkleRoot;
662 
663     // This is a packed array of booleans.
664     mapping(uint256 => uint256) private claimedBitMap;
665 
666     uint256 public immutable ownerUnlockTime;
667 
668     constructor(
669         address _owner,
670         address _token,
671         bytes32 _merkleRoot,
672         uint256 _daysUntilUnlock
673     ) Owned(_owner) {
674         require(_owner != address(0), "Owner must be non-zero address");
675         require(_token != address(0), "Airdrop token must be non-zero address");
676         require(_merkleRoot != bytes32(0), "Merkle root must be non-zero");
677         require(
678             _daysUntilUnlock > 0,
679             "Days until owner unlock must be in the future"
680         );
681         token = _token;
682         merkleRoot = _merkleRoot;
683         ownerUnlockTime = block.timestamp.add(_daysUntilUnlock * 1 days);
684     }
685 
686     function isClaimed(uint256 index) public view override returns (bool) {
687         uint256 claimedWordIndex = index / 256;
688         uint256 claimedBitIndex = index % 256;
689         uint256 claimedWord = claimedBitMap[claimedWordIndex];
690         uint256 mask = (1 << claimedBitIndex);
691         return claimedWord & mask == mask;
692     }
693 
694     function _setClaimed(uint256 index) private {
695         uint256 claimedWordIndex = index / 256;
696         uint256 claimedBitIndex = index % 256;
697         claimedBitMap[claimedWordIndex] =
698             claimedBitMap[claimedWordIndex] |
699             (1 << claimedBitIndex);
700     }
701 
702     function claim(
703         uint256 index,
704         address account,
705         uint256 amount,
706         bytes32[] calldata merkleProof
707     ) external override {
708         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
709 
710         // Verify the merkle proof.
711         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
712         require(
713             MerkleProof.verify(merkleProof, merkleRoot, node),
714             "MerkleDistributor: Invalid proof."
715         );
716 
717         // Mark it claimed and send the token.
718         _setClaimed(index);
719         IERC20(token).safeTransfer(account, amount);
720 
721         emit Claimed(index, account, amount);
722     }
723 
724     // Used for recovery purposes
725     function recoverERC20(address tokenAddress, uint256 tokenAmount)
726         external
727         onlyOwner
728     {
729         require(
730             tokenAddress == address(token)
731                 ? block.timestamp >= ownerUnlockTime
732                 : true,
733             "MerkleDistributor: Cannot withdraw the token before unlock time"
734         );
735         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
736         emit Recovered(tokenAddress, tokenAmount);
737     }
738 
739     /* ========== EVENTS ========== */
740     event Recovered(address token, uint256 amount);
741 }