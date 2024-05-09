1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.6.0;
6 
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
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // This method relies in extcodesize, which returns 0 for contracts in
272         // construction, since the code is only stored at the end of the
273         // constructor execution.
274 
275         uint256 size;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { size := extcodesize(account) }
278         return size > 0;
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /**
471  * @dev These functions deal with verification of Merkle trees (hash trees),
472  */
473 library MerkleProof {
474     /**
475      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
476      * defined by `root`. For this, a `proof` must be provided, containing
477      * sibling hashes on the branch from the leaf to the root of the tree. Each
478      * pair of leaves and each pair of pre-images are assumed to be sorted.
479      */
480     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
481         bytes32 computedHash = leaf;
482 
483         for (uint256 i = 0; i < proof.length; i++) {
484             bytes32 proofElement = proof[i];
485 
486             if (computedHash <= proofElement) {
487                 // Hash(current computed hash + current element of the proof)
488                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
489             } else {
490                 // Hash(current element of the proof + current computed hash)
491                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
492             }
493         }
494 
495         // Check if the computed hash (root) is equal to the provided root
496         return computedHash == root;
497     }
498 }
499 
500 // File: contracts/interfaces/IMerkleBox.sol
501 
502 
503 
504 pragma solidity 0.6.12;
505 
506 interface IMerkleBox {
507     event NewMerkle(
508         address indexed sender,
509         address indexed erc20,
510         uint256 amount,
511         bytes32 indexed merkleRoot,
512         uint256 claimGroupId,
513         uint256 withdrawUnlockTime,
514         string memo
515     );
516     event MerkleClaim(address indexed account, address indexed erc20, uint256 amount);
517     event MerkleFundUpdate(address indexed funder, bytes32 indexed merkleRoot, uint256 claimGroupId, uint256 amount, bool withdraw);
518 
519     function addFunds(uint256 claimGroupId, uint256 amount) external;
520 
521     function addFundsWithPermit(
522         uint256 claimGroupId,
523         address funder,
524         uint256 amount,
525         uint256 deadline,
526         uint8 v,
527         bytes32 r,
528         bytes32 s
529     ) external;
530 
531     function withdrawFunds(uint256 claimGroupId, uint256 amount) external;
532 
533     function newClaimsGroup(
534         address erc20,
535         uint256 amount,
536         bytes32 merkleRoot,
537         uint256 withdrawUnlockTime,
538         string calldata memo
539     ) external returns (uint256);
540 
541     function isClaimable(
542         uint256 claimGroupId,
543         address account,
544         uint256 amount,
545         bytes32[] memory proof
546     ) external view returns (bool);
547 
548     function claim(
549         uint256 claimGroupId,
550         address account,
551         uint256 amount,
552         bytes32[] memory proof
553     ) external;
554 }
555 
556 // File: contracts/interfaces/IERC20WithPermit.sol
557 
558 
559 
560 pragma solidity 0.6.12;
561 
562 
563 interface IERC20WithPermit is IERC20 {
564     function permit(
565         address,
566         address,
567         uint256,
568         uint256,
569         uint8,
570         bytes32,
571         bytes32
572     ) external;
573 }
574 
575 // File: contracts/MerkleBox.sol
576 
577 
578 
579 pragma solidity 0.6.12;
580 
581 
582 
583 
584 
585 
586 contract MerkleBox is IMerkleBox {
587     using MerkleProof for MerkleProof;
588     using SafeERC20 for IERC20;
589     using SafeERC20 for IERC20WithPermit;
590     using SafeMath for uint256;
591 
592     struct Holding {
593         address owner; // account that contributed funds
594         address erc20; // claim-able ERC20 asset
595         uint256 balance; // amount of token held currently
596         bytes32 merkleRoot; // root of claims merkle tree
597         uint256 withdrawUnlockTime; // withdraw forbidden before this time
598         string memo; // an string to store arbitary notes about the holding
599     }
600 
601     mapping(uint256 => Holding) public holdings;
602     mapping(address => uint256[]) public claimGroupIds;
603     mapping(uint256 => mapping(bytes32 => bool)) public leafClaimed;
604     uint256 public constant LOCKING_PERIOD = 30 days;
605     uint256 public claimGroupCount;
606 
607     function addFunds(uint256 claimGroupId, uint256 amount) external override {
608         // prelim. parameter checks
609         require(amount != 0, "Invalid amount");
610 
611         // reference our struct storage
612         Holding storage holding = holdings[claimGroupId];
613         require(holding.owner != address(0), "Holding does not exist");
614 
615         // calculate amount to deposit.  handle deposit-all.
616         IERC20 token = IERC20(holding.erc20);
617         uint256 balance = token.balanceOf(msg.sender);
618         if (amount == uint256(-1)) {
619             amount = balance;
620         }
621         require(amount <= balance, "Insufficient balance");
622         require(amount != 0, "Amount cannot be zero");
623 
624         // transfer token to this contract
625         token.safeTransferFrom(msg.sender, address(this), amount);
626 
627         // update holdings record
628         holding.balance = holding.balance.add(amount);
629 
630         emit MerkleFundUpdate(msg.sender, holding.merkleRoot, claimGroupId, amount, false);
631     }
632 
633     function addFundsWithPermit(
634         uint256 claimGroupId,
635         address funder,
636         uint256 amount,
637         uint256 deadline,
638         uint8 v,
639         bytes32 r,
640         bytes32 s
641     ) external override {
642         // prelim. parameter checks
643         require(amount != 0, "Invalid amount");
644 
645         // reference our struct storage
646         Holding storage holding = holdings[claimGroupId];
647         require(holding.owner != address(0), "Holding does not exist");
648 
649         // calculate amount to deposit.  handle deposit-all.
650         IERC20WithPermit token = IERC20WithPermit(holding.erc20);
651         uint256 balance = token.balanceOf(funder);
652         if (amount == uint256(-1)) {
653             amount = balance;
654         }
655         require(amount <= balance, "Insufficient balance");
656         require(amount != 0, "Amount cannot be zero");
657 
658         // transfer token to this contract
659         token.permit(funder, address(this), amount, deadline, v, r, s);
660         token.safeTransferFrom(funder, address(this), amount);
661 
662         // update holdings record
663         holding.balance = holding.balance.add(amount);
664 
665         emit MerkleFundUpdate(funder, holding.merkleRoot, claimGroupId, amount, false);
666     }
667 
668     function withdrawFunds(uint256 claimGroupId, uint256 amount) external override {
669         // reference our struct storage
670         Holding storage holding = holdings[claimGroupId];
671         require(holding.owner != address(0), "Holding does not exist");
672         require(block.timestamp >= holding.withdrawUnlockTime, "Holdings may not be withdrawn");
673         require(holding.owner == msg.sender, "Only owner may withdraw");
674 
675         // calculate amount to withdraw.  handle withdraw-all.
676         IERC20 token = IERC20(holding.erc20);
677         if (amount == uint256(-1)) {
678             amount = holding.balance;
679         }
680         require(amount <= holding.balance, "Insufficient balance");
681 
682         // update holdings record
683         holding.balance = holding.balance.sub(amount);
684 
685         // transfer token to this contract
686         token.safeTransfer(msg.sender, amount);
687 
688         emit MerkleFundUpdate(msg.sender, holding.merkleRoot, claimGroupId, amount, true);
689     }
690 
691     function newClaimsGroup(
692         address erc20,
693         uint256 amount,
694         bytes32 merkleRoot,
695         uint256 withdrawUnlockTime,
696         string calldata memo
697     ) external override returns (uint256) {
698         // prelim. parameter checks
699         require(erc20 != address(0), "Invalid ERC20 address");
700         require(merkleRoot != 0, "Merkle cannot be zero");
701         require(withdrawUnlockTime >= block.timestamp + LOCKING_PERIOD, "Holding lock must exceed minimum lock period");
702 
703         claimGroupCount++;
704         // reference our struct storage
705         Holding storage holding = holdings[claimGroupCount];
706 
707         // calculate amount to deposit.  handle deposit-all.
708         IERC20 token = IERC20(erc20);
709         uint256 balance = token.balanceOf(msg.sender);
710         if (amount == uint256(-1)) {
711             amount = balance;
712         }
713         require(amount <= balance, "Insufficient balance");
714         require(amount != 0, "Amount cannot be zero");
715 
716         // transfer token to this contract
717         token.safeTransferFrom(msg.sender, address(this), amount);
718 
719         // record holding in stable storage
720         holding.owner = msg.sender;
721         holding.erc20 = erc20;
722         holding.balance = amount;
723         holding.merkleRoot = merkleRoot;
724         holding.withdrawUnlockTime = withdrawUnlockTime;
725         holding.memo = memo;
726         claimGroupIds[msg.sender].push(claimGroupCount);
727         emit NewMerkle(msg.sender, erc20, amount, merkleRoot, claimGroupCount, withdrawUnlockTime, memo);
728         return claimGroupCount;
729     }
730 
731     function isClaimable(
732         uint256 claimGroupId,
733         address account,
734         uint256 amount,
735         bytes32[] memory proof
736     ) external view override returns (bool) {
737         // holding exists?
738         Holding memory holding = holdings[claimGroupId];
739         if (holding.owner == address(0)) {
740             return false;
741         }
742         //  holding owner?
743         if (holding.owner == account) {
744             return false;
745         }
746         // sufficient balance exists?   (funder may have under-funded)
747         if (holding.balance < amount) {
748             return false;
749         }
750 
751         bytes32 leaf = _leafHash(account, amount);
752         // already claimed?
753         if (leafClaimed[claimGroupId][leaf]) {
754             return false;
755         }
756         // merkle proof is invalid or claim not found
757         if (!MerkleProof.verify(proof, holding.merkleRoot, leaf)) {
758             return false;
759         }
760         return true;
761     }
762 
763     function claim(
764         uint256 claimGroupId,
765         address account,
766         uint256 amount,
767         bytes32[] memory proof
768     ) external override {
769         // holding exists?
770         Holding storage holding = holdings[claimGroupId];
771         require(holding.owner != address(0), "Holding not found");
772 
773         //  holding owner?
774         require(holding.owner != account, "Holding owner cannot claim");
775 
776         // sufficient balance exists?   (funder may have under-funded)
777         require(holding.balance >= amount, "Claim under-funded by funder.");
778 
779         bytes32 leaf = _leafHash(account, amount);
780 
781         // already spent?
782         require(leafClaimed[claimGroupId][leaf] == false, "Already claimed");
783 
784         // merkle proof valid?
785         require(MerkleProof.verify(proof, holding.merkleRoot, leaf) == true, "Claim not found");
786 
787         // update state
788         leafClaimed[claimGroupId][leaf] = true;
789         holding.balance = holding.balance.sub(amount);
790         IERC20(holding.erc20).safeTransfer(account, amount);
791 
792         emit MerkleClaim(account, holding.erc20, amount);
793     }
794 
795     function getClaimGroupIds(address owner) public view returns (uint256[] memory ids) {
796         ids = claimGroupIds[owner];
797     }
798 
799     //////////////////////////////////////////////////////////
800 
801     // generate hash of (claim holder, amount)
802     // claim holder must be the caller
803     function _leafHash(address account, uint256 amount) internal pure returns (bytes32) {
804         return keccak256(abi.encodePacked(account, amount));
805     }
806 }