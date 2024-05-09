1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.9;
4 
5 
6 
7 // Part: IBasicRewards
8 
9 interface IBasicRewards {
10     function stakeFor(address, uint256) external returns (bool);
11 
12     function balanceOf(address) external view returns (uint256);
13 
14     function earned(address) external view returns (uint256);
15 
16     function withdrawAll(bool) external returns (bool);
17 
18     function withdraw(uint256, bool) external returns (bool);
19 
20     function getReward() external returns (bool);
21 
22     function stake(uint256) external returns (bool);
23 }
24 
25 // Part: ICurveFactoryPool
26 
27 interface ICurveFactoryPool {
28     function get_dy(
29         int128 i,
30         int128 j,
31         uint256 dx
32     ) external view returns (uint256);
33 
34     function get_balances() external view returns (uint256[2] memory);
35 
36     function add_liquidity(
37         uint256[2] memory _amounts,
38         uint256 _min_mint_amount,
39         address _receiver
40     ) external returns (uint256);
41 
42     function exchange(
43         int128 i,
44         int128 j,
45         uint256 _dx,
46         uint256 _min_dy,
47         address _receiver
48     ) external returns (uint256);
49 }
50 
51 // Part: ICurveV2Pool
52 
53 interface ICurveV2Pool {
54     function get_dy(
55         uint256 i,
56         uint256 j,
57         uint256 dx
58     ) external view returns (uint256);
59 
60     function exchange_underlying(
61         uint256 i,
62         uint256 j,
63         uint256 dx,
64         uint256 min_dy
65     ) external payable returns (uint256);
66 }
67 
68 // Part: IUnionVault
69 
70 interface IUnionVault {
71     enum Option {
72         Claim,
73         ClaimAsETH,
74         ClaimAsCRV,
75         ClaimAsCVX,
76         ClaimAndStake
77     }
78 
79     function withdraw(address _to, uint256 _shares)
80         external
81         returns (uint256 withdrawn);
82 
83     function withdrawAll(address _to) external returns (uint256 withdrawn);
84 
85     function withdrawAs(
86         address _to,
87         uint256 _shares,
88         Option option
89     ) external;
90 
91     function withdrawAs(
92         address _to,
93         uint256 _shares,
94         Option option,
95         uint256 minAmountOut
96     ) external;
97 
98     function withdrawAllAs(address _to, Option option) external;
99 
100     function withdrawAllAs(
101         address _to,
102         Option option,
103         uint256 minAmountOut
104     ) external;
105 
106     function depositAll(address _to) external returns (uint256 _shares);
107 
108     function deposit(address _to, uint256 _amount)
109         external
110         returns (uint256 _shares);
111 
112     function harvest() external;
113 
114     function balanceOfUnderlying(address user)
115         external
116         view
117         returns (uint256 amount);
118 
119     function outstanding3CrvRewards() external view returns (uint256 total);
120 
121     function outstandingCvxRewards() external view returns (uint256 total);
122 
123     function outstandingCrvRewards() external view returns (uint256 total);
124 
125     function totalUnderlying() external view returns (uint256 total);
126 
127     function underlying() external view returns (address);
128 
129     function setPlatform(address _platform) external;
130 
131     function setPlatformFee(uint256 _fee) external;
132 
133     function setCallIncentive(uint256 _incentive) external;
134 
135     function setWithdrawalPenalty(uint256 _penalty) external;
136 
137     function setApprovals() external;
138 }
139 
140 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/Address
141 
142 /**
143  * @dev Collection of functions related to the address type
144  */
145 library Address {
146     /**
147      * @dev Returns true if `account` is a contract.
148      *
149      * [IMPORTANT]
150      * ====
151      * It is unsafe to assume that an address for which this function returns
152      * false is an externally-owned account (EOA) and not a contract.
153      *
154      * Among others, `isContract` will return false for the following
155      * types of addresses:
156      *
157      *  - an externally-owned account
158      *  - a contract in construction
159      *  - an address where a contract will be created
160      *  - an address where a contract lived, but was destroyed
161      * ====
162      */
163     function isContract(address account) internal view returns (bool) {
164         // This method relies on extcodesize, which returns 0 for contracts in
165         // construction, since the code is only stored at the end of the
166         // constructor execution.
167 
168         uint256 size;
169         // solhint-disable-next-line no-inline-assembly
170         assembly { size := extcodesize(account) }
171         return size > 0;
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(address(this).balance >= amount, "Address: insufficient balance");
192 
193         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
194         (bool success, ) = recipient.call{ value: amount }("");
195         require(success, "Address: unable to send value, recipient may have reverted");
196     }
197 
198     /**
199      * @dev Performs a Solidity function call using a low level `call`. A
200      * plain`call` is an unsafe replacement for a function call: use this
201      * function instead.
202      *
203      * If `target` reverts with a revert reason, it is bubbled up by this
204      * function (like regular Solidity function calls).
205      *
206      * Returns the raw returned data. To convert to the expected return value,
207      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
208      *
209      * Requirements:
210      *
211      * - `target` must be a contract.
212      * - calling `target` with `data` must not revert.
213      *
214      * _Available since v3.1._
215      */
216     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
217       return functionCall(target, data, "Address: low-level call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
222      * `errorMessage` as a fallback revert reason when `target` reverts.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, 0, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but also transferring `value` wei to `target`.
233      *
234      * Requirements:
235      *
236      * - the calling contract must have an ETH balance of at least `value`.
237      * - the called Solidity function must be `payable`.
238      *
239      * _Available since v3.1._
240      */
241     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
247      * with `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         // solhint-disable-next-line avoid-low-level-calls
256         (bool success, bytes memory returndata) = target.call{ value: value }(data);
257         return _verifyCallResult(success, returndata, errorMessage);
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
262      * but performing a static call.
263      *
264      * _Available since v3.3._
265      */
266     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
267         return functionStaticCall(target, data, "Address: low-level static call failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
272      * but performing a static call.
273      *
274      * _Available since v3.3._
275      */
276     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
277         require(isContract(target), "Address: static call to non-contract");
278 
279         // solhint-disable-next-line avoid-low-level-calls
280         (bool success, bytes memory returndata) = target.staticcall(data);
281         return _verifyCallResult(success, returndata, errorMessage);
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
286      * but performing a delegate call.
287      *
288      * _Available since v3.4._
289      */
290     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
291         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
301         require(isContract(target), "Address: delegate call to non-contract");
302 
303         // solhint-disable-next-line avoid-low-level-calls
304         (bool success, bytes memory returndata) = target.delegatecall(data);
305         return _verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
309         if (success) {
310             return returndata;
311         } else {
312             // Look for revert reason and bubble it up if present
313             if (returndata.length > 0) {
314                 // The easiest way to bubble the revert reason is using memory via assembly
315 
316                 // solhint-disable-next-line no-inline-assembly
317                 assembly {
318                     let returndata_size := mload(returndata)
319                     revert(add(32, returndata), returndata_size)
320                 }
321             } else {
322                 revert(errorMessage);
323             }
324         }
325     }
326 }
327 
328 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/IERC20
329 
330 /**
331  * @dev Interface of the ERC20 standard as defined in the EIP.
332  */
333 interface IERC20 {
334     /**
335      * @dev Returns the amount of tokens in existence.
336      */
337     function totalSupply() external view returns (uint256);
338 
339     /**
340      * @dev Returns the amount of tokens owned by `account`.
341      */
342     function balanceOf(address account) external view returns (uint256);
343 
344     /**
345      * @dev Moves `amount` tokens from the caller's account to `recipient`.
346      *
347      * Returns a boolean value indicating whether the operation succeeded.
348      *
349      * Emits a {Transfer} event.
350      */
351     function transfer(address recipient, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Returns the remaining number of tokens that `spender` will be
355      * allowed to spend on behalf of `owner` through {transferFrom}. This is
356      * zero by default.
357      *
358      * This value changes when {approve} or {transferFrom} are called.
359      */
360     function allowance(address owner, address spender) external view returns (uint256);
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * IMPORTANT: Beware that changing an allowance with this method brings the risk
368      * that someone may use both the old and the new allowance by unfortunate
369      * transaction ordering. One possible solution to mitigate this race
370      * condition is to first reduce the spender's allowance to 0 and set the
371      * desired value afterwards:
372      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373      *
374      * Emits an {Approval} event.
375      */
376     function approve(address spender, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Moves `amount` tokens from `sender` to `recipient` using the
380      * allowance mechanism. `amount` is then deducted from the caller's
381      * allowance.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * Emits a {Transfer} event.
386      */
387     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
388 
389     /**
390      * @dev Emitted when `value` tokens are moved from one account (`from`) to
391      * another (`to`).
392      *
393      * Note that `value` may be zero.
394      */
395     event Transfer(address indexed from, address indexed to, uint256 value);
396 
397     /**
398      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
399      * a call to {approve}. `value` is the new allowance.
400      */
401     event Approval(address indexed owner, address indexed spender, uint256 value);
402 }
403 
404 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/MerkleProof
405 
406 /**
407  * @dev These functions deal with verification of Merkle Trees proofs.
408  *
409  * The proofs can be generated using the JavaScript library
410  * https://github.com/miguelmota/merkletreejs[merkletreejs].
411  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
412  *
413  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
414  */
415 library MerkleProof {
416     /**
417      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
418      * defined by `root`. For this, a `proof` must be provided, containing
419      * sibling hashes on the branch from the leaf to the root of the tree. Each
420      * pair of leaves and each pair of pre-images are assumed to be sorted.
421      */
422     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
423         bytes32 computedHash = leaf;
424 
425         for (uint256 i = 0; i < proof.length; i++) {
426             bytes32 proofElement = proof[i];
427 
428             if (computedHash <= proofElement) {
429                 // Hash(current computed hash + current element of the proof)
430                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
431             } else {
432                 // Hash(current element of the proof + current computed hash)
433                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
434             }
435         }
436 
437         // Check if the computed hash (root) is equal to the provided root
438         return computedHash == root;
439     }
440 }
441 
442 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/ReentrancyGuard
443 
444 /**
445  * @dev Contract module that helps prevent reentrant calls to a function.
446  *
447  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
448  * available, which can be applied to functions to make sure there are no nested
449  * (reentrant) calls to them.
450  *
451  * Note that because there is a single `nonReentrant` guard, functions marked as
452  * `nonReentrant` may not call one another. This can be worked around by making
453  * those functions `private`, and then adding `external` `nonReentrant` entry
454  * points to them.
455  *
456  * TIP: If you would like to learn more about reentrancy and alternative ways
457  * to protect against it, check out our blog post
458  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
459  */
460 abstract contract ReentrancyGuard {
461     // Booleans are more expensive than uint256 or any type that takes up a full
462     // word because each write operation emits an extra SLOAD to first read the
463     // slot's contents, replace the bits taken up by the boolean, and then write
464     // back. This is the compiler's defense against contract upgrades and
465     // pointer aliasing, and it cannot be disabled.
466 
467     // The values being non-zero value makes deployment a bit more expensive,
468     // but in exchange the refund on every call to nonReentrant will be lower in
469     // amount. Since refunds are capped to a percentage of the total
470     // transaction's gas, it is best to keep them low in cases like this one, to
471     // increase the likelihood of the full refund coming into effect.
472     uint256 private constant _NOT_ENTERED = 1;
473     uint256 private constant _ENTERED = 2;
474 
475     uint256 private _status;
476 
477     constructor () {
478         _status = _NOT_ENTERED;
479     }
480 
481     /**
482      * @dev Prevents a contract from calling itself, directly or indirectly.
483      * Calling a `nonReentrant` function from another `nonReentrant`
484      * function is not supported. It is possible to prevent this from happening
485      * by making the `nonReentrant` function external, and make it call a
486      * `private` function that does the actual work.
487      */
488     modifier nonReentrant() {
489         // On the first call to nonReentrant, _notEntered will be true
490         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
491 
492         // Any calls to nonReentrant after this point will fail
493         _status = _ENTERED;
494 
495         _;
496 
497         // By storing the original value once again, a refund is triggered (see
498         // https://eips.ethereum.org/EIPS/eip-2200)
499         _status = _NOT_ENTERED;
500     }
501 }
502 
503 // Part: OpenZeppelin/openzeppelin-contracts@4.1.0/SafeERC20
504 
505 /**
506  * @title SafeERC20
507  * @dev Wrappers around ERC20 operations that throw on failure (when the token
508  * contract returns false). Tokens that return no value (and instead revert or
509  * throw on failure) are also supported, non-reverting calls are assumed to be
510  * successful.
511  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
512  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
513  */
514 library SafeERC20 {
515     using Address for address;
516 
517     function safeTransfer(IERC20 token, address to, uint256 value) internal {
518         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
519     }
520 
521     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
522         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
523     }
524 
525     /**
526      * @dev Deprecated. This function has issues similar to the ones found in
527      * {IERC20-approve}, and its usage is discouraged.
528      *
529      * Whenever possible, use {safeIncreaseAllowance} and
530      * {safeDecreaseAllowance} instead.
531      */
532     function safeApprove(IERC20 token, address spender, uint256 value) internal {
533         // safeApprove should only be called when setting an initial allowance,
534         // or when resetting it to zero. To increase and decrease it, use
535         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
536         // solhint-disable-next-line max-line-length
537         require((value == 0) || (token.allowance(address(this), spender) == 0),
538             "SafeERC20: approve from non-zero to non-zero allowance"
539         );
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
541     }
542 
543     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender) + value;
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
549         unchecked {
550             uint256 oldAllowance = token.allowance(address(this), spender);
551             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
552             uint256 newAllowance = oldAllowance - value;
553             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
554         }
555     }
556 
557     /**
558      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
559      * on the return value: the return value is optional (but if data is returned, it must not be false).
560      * @param token The token targeted by the call.
561      * @param data The call data (encoded using abi.encode or one of its variants).
562      */
563     function _callOptionalReturn(IERC20 token, bytes memory data) private {
564         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
565         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
566         // the target address contains contract code and also asserts for success in the low-level call.
567 
568         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
569         if (returndata.length > 0) { // Return data is optional
570             // solhint-disable-next-line max-line-length
571             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
572         }
573     }
574 }
575 
576 // Part: UnionBase
577 
578 // Common variables and functions
579 contract UnionBase {
580     address public constant CVXCRV_STAKING_CONTRACT =
581         0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e;
582     address public constant CURVE_CRV_ETH_POOL =
583         0x8301AE4fc9c624d1D396cbDAa1ed877821D7C511;
584     address public constant CURVE_CVX_ETH_POOL =
585         0xB576491F1E6e5E62f1d8F26062Ee822B40B0E0d4;
586     address public constant CURVE_CVXCRV_CRV_POOL =
587         0x9D0464996170c6B9e75eED71c68B99dDEDf279e8;
588 
589     address public constant CRV_TOKEN =
590         0xD533a949740bb3306d119CC777fa900bA034cd52;
591     address public constant CVXCRV_TOKEN =
592         0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7;
593     address public constant CVX_TOKEN =
594         0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
595 
596     uint256 public constant CRVETH_ETH_INDEX = 0;
597     uint256 public constant CRVETH_CRV_INDEX = 1;
598     int128 public constant CVXCRV_CRV_INDEX = 0;
599     int128 public constant CVXCRV_CVXCRV_INDEX = 1;
600     uint256 public constant CVXETH_ETH_INDEX = 0;
601     uint256 public constant CVXETH_CVX_INDEX = 1;
602 
603     IBasicRewards cvxCrvStaking = IBasicRewards(CVXCRV_STAKING_CONTRACT);
604     ICurveV2Pool cvxEthSwap = ICurveV2Pool(CURVE_CVX_ETH_POOL);
605     ICurveV2Pool crvEthSwap = ICurveV2Pool(CURVE_CRV_ETH_POOL);
606     ICurveFactoryPool crvCvxCrvSwap = ICurveFactoryPool(CURVE_CVXCRV_CRV_POOL);
607 
608     /// @notice Swap CRV for cvxCRV on Curve
609     /// @param amount - amount to swap
610     /// @param recipient - where swapped tokens will be sent to
611     /// @return amount of CRV obtained after the swap
612     function _swapCrvToCvxCrv(uint256 amount, address recipient)
613         internal
614         returns (uint256)
615     {
616         return _crvToCvxCrv(amount, recipient, 0);
617     }
618 
619     /// @notice Swap CRV for cvxCRV on Curve
620     /// @param amount - amount to swap
621     /// @param recipient - where swapped tokens will be sent to
622     /// @param minAmountOut - minimum expected amount of output tokens
623     /// @return amount of CRV obtained after the swap
624     function _swapCrvToCvxCrv(
625         uint256 amount,
626         address recipient,
627         uint256 minAmountOut
628     ) internal returns (uint256) {
629         return _crvToCvxCrv(amount, recipient, minAmountOut);
630     }
631 
632     /// @notice Swap CRV for cvxCRV on Curve
633     /// @param amount - amount to swap
634     /// @param recipient - where swapped tokens will be sent to
635     /// @param minAmountOut - minimum expected amount of output tokens
636     /// @return amount of CRV obtained after the swap
637     function _crvToCvxCrv(
638         uint256 amount,
639         address recipient,
640         uint256 minAmountOut
641     ) internal returns (uint256) {
642         return
643             crvCvxCrvSwap.exchange(
644                 CVXCRV_CRV_INDEX,
645                 CVXCRV_CVXCRV_INDEX,
646                 amount,
647                 minAmountOut,
648                 recipient
649             );
650     }
651 
652     /// @notice Swap cvxCRV for CRV on Curve
653     /// @param amount - amount to swap
654     /// @param recipient - where swapped tokens will be sent to
655     /// @return amount of CRV obtained after the swap
656     function _swapCvxCrvToCrv(uint256 amount, address recipient)
657         internal
658         returns (uint256)
659     {
660         return _cvxCrvToCrv(amount, recipient, 0);
661     }
662 
663     /// @notice Swap cvxCRV for CRV on Curve
664     /// @param amount - amount to swap
665     /// @param recipient - where swapped tokens will be sent to
666     /// @param minAmountOut - minimum expected amount of output tokens
667     /// @return amount of CRV obtained after the swap
668     function _swapCvxCrvToCrv(
669         uint256 amount,
670         address recipient,
671         uint256 minAmountOut
672     ) internal returns (uint256) {
673         return _cvxCrvToCrv(amount, recipient, minAmountOut);
674     }
675 
676     /// @notice Swap cvxCRV for CRV on Curve
677     /// @param amount - amount to swap
678     /// @param recipient - where swapped tokens will be sent to
679     /// @param minAmountOut - minimum expected amount of output tokens
680     /// @return amount of CRV obtained after the swap
681     function _cvxCrvToCrv(
682         uint256 amount,
683         address recipient,
684         uint256 minAmountOut
685     ) internal returns (uint256) {
686         return
687             crvCvxCrvSwap.exchange(
688                 CVXCRV_CVXCRV_INDEX,
689                 CVXCRV_CRV_INDEX,
690                 amount,
691                 minAmountOut,
692                 recipient
693             );
694     }
695 
696     /// @notice Swap CRV for native ETH on Curve
697     /// @param amount - amount to swap
698     /// @return amount of ETH obtained after the swap
699     function _swapCrvToEth(uint256 amount) internal returns (uint256) {
700         return _crvToEth(amount, 0);
701     }
702 
703     /// @notice Swap CRV for native ETH on Curve
704     /// @param amount - amount to swap
705     /// @param minAmountOut - minimum expected amount of output tokens
706     /// @return amount of ETH obtained after the swap
707     function _swapCrvToEth(uint256 amount, uint256 minAmountOut)
708         internal
709         returns (uint256)
710     {
711         return _crvToEth(amount, minAmountOut);
712     }
713 
714     /// @notice Swap CRV for native ETH on Curve
715     /// @param amount - amount to swap
716     /// @param minAmountOut - minimum expected amount of output tokens
717     /// @return amount of ETH obtained after the swap
718     function _crvToEth(uint256 amount, uint256 minAmountOut)
719         internal
720         returns (uint256)
721     {
722         return
723             crvEthSwap.exchange_underlying{value: 0}(
724                 CRVETH_CRV_INDEX,
725                 CRVETH_ETH_INDEX,
726                 amount,
727                 minAmountOut
728             );
729     }
730 
731     /// @notice Swap native ETH for CRV on Curve
732     /// @param amount - amount to swap
733     /// @return amount of CRV obtained after the swap
734     function _swapEthToCrv(uint256 amount) internal returns (uint256) {
735         return _ethToCrv(amount, 0);
736     }
737 
738     /// @notice Swap native ETH for CRV on Curve
739     /// @param amount - amount to swap
740     /// @param minAmountOut - minimum expected amount of output tokens
741     /// @return amount of CRV obtained after the swap
742     function _swapEthToCrv(uint256 amount, uint256 minAmountOut)
743         internal
744         returns (uint256)
745     {
746         return _ethToCrv(amount, minAmountOut);
747     }
748 
749     /// @notice Swap native ETH for CRV on Curve
750     /// @param amount - amount to swap
751     /// @param minAmountOut - minimum expected amount of output tokens
752     /// @return amount of CRV obtained after the swap
753     function _ethToCrv(uint256 amount, uint256 minAmountOut)
754         internal
755         returns (uint256)
756     {
757         return
758             crvEthSwap.exchange_underlying{value: amount}(
759                 CRVETH_ETH_INDEX,
760                 CRVETH_CRV_INDEX,
761                 amount,
762                 minAmountOut
763             );
764     }
765 
766     /// @notice Swap native ETH for CVX on Curve
767     /// @param amount - amount to swap
768     /// @return amount of CRV obtained after the swap
769     function _swapEthToCvx(uint256 amount) internal returns (uint256) {
770         return _ethToCvx(amount, 0);
771     }
772 
773     /// @notice Swap native ETH for CVX on Curve
774     /// @param amount - amount to swap
775     /// @param minAmountOut - minimum expected amount of output tokens
776     /// @return amount of CRV obtained after the swap
777     function _swapEthToCvx(uint256 amount, uint256 minAmountOut)
778         internal
779         returns (uint256)
780     {
781         return _ethToCvx(amount, minAmountOut);
782     }
783 
784     /// @notice Swap native ETH for CVX on Curve
785     /// @param amount - amount to swap
786     /// @param minAmountOut - minimum expected amount of output tokens
787     /// @return amount of CRV obtained after the swap
788     function _ethToCvx(uint256 amount, uint256 minAmountOut)
789         internal
790         returns (uint256)
791     {
792         return
793             cvxEthSwap.exchange_underlying{value: amount}(
794                 CVXETH_ETH_INDEX,
795                 CVXETH_CVX_INDEX,
796                 amount,
797                 minAmountOut
798             );
799     }
800 
801     modifier notToZeroAddress(address _to) {
802         require(_to != address(0), "Invalid address!");
803         _;
804     }
805 }
806 
807 // Part: ClaimZaps
808 
809 contract ClaimZaps is ReentrancyGuard, UnionBase {
810     using SafeERC20 for IERC20;
811 
812     // Possible options when claiming
813     enum Option {
814         Claim,
815         ClaimAsETH,
816         ClaimAsCRV,
817         ClaimAsCVX,
818         ClaimAndStake
819     }
820 
821     /// @notice Set approvals for the tokens used when swapping
822     function _setApprovals() internal {
823         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, 0);
824         IERC20(CRV_TOKEN).safeApprove(CURVE_CRV_ETH_POOL, type(uint256).max);
825 
826         IERC20(CVXCRV_TOKEN).safeApprove(CVXCRV_STAKING_CONTRACT, 0);
827         IERC20(CVXCRV_TOKEN).safeApprove(
828             CVXCRV_STAKING_CONTRACT,
829             type(uint256).max
830         );
831 
832         IERC20(CVXCRV_TOKEN).safeApprove(CURVE_CVXCRV_CRV_POOL, 0);
833         IERC20(CVXCRV_TOKEN).safeApprove(
834             CURVE_CVXCRV_CRV_POOL,
835             type(uint256).max
836         );
837     }
838 
839     function _claimAs(
840         address account,
841         uint256 amount,
842         Option option
843     ) internal {
844         _claim(account, amount, option, 0);
845     }
846 
847     function _claimAs(
848         address account,
849         uint256 amount,
850         Option option,
851         uint256 minAmountOut
852     ) internal {
853         _claim(account, amount, option, minAmountOut);
854     }
855 
856     /// @notice Zap function to claim token balance as another token
857     /// @param account - recipient of the swapped token
858     /// @param amount - amount to swap
859     /// @param option - what to swap to
860     /// @param minAmountOut - minimum desired amount of output token
861     function _claim(
862         address account,
863         uint256 amount,
864         Option option,
865         uint256 minAmountOut
866     ) internal nonReentrant {
867         if (option == Option.ClaimAsCRV) {
868             _swapCvxCrvToCrv(amount, account, minAmountOut);
869         } else if (option == Option.ClaimAsETH) {
870             uint256 _crvBalance = _swapCvxCrvToCrv(amount, address(this));
871             uint256 _ethAmount = _swapCrvToEth(_crvBalance, minAmountOut);
872             (bool success, ) = account.call{value: _ethAmount}("");
873             require(success, "ETH transfer failed");
874         } else if (option == Option.ClaimAsCVX) {
875             uint256 _crvBalance = _swapCvxCrvToCrv(amount, address(this));
876             uint256 _ethAmount = _swapCrvToEth(_crvBalance);
877             uint256 _cvxAmount = _swapEthToCvx(_ethAmount, minAmountOut);
878             IERC20(CVX_TOKEN).safeTransfer(account, _cvxAmount);
879         } else if (option == Option.ClaimAndStake) {
880             require(cvxCrvStaking.stakeFor(account, amount), "Staking failed");
881         } else {
882             IERC20(CVXCRV_TOKEN).safeTransfer(account, amount);
883         }
884     }
885 }
886 
887 // File: MerkleDistributorV2.sol
888 
889 // Allows anyone to claim a token if they exist in a merkle root.
890 contract MerkleDistributorV2 is ClaimZaps {
891     using SafeERC20 for IERC20;
892 
893     address public vault;
894     bytes32 public merkleRoot;
895     uint32 public week;
896     bool public frozen;
897 
898     address public admin;
899     address public depositor;
900 
901     // This is a packed array of booleans.
902     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
903 
904     // This event is triggered whenever a call to #claim succeeds.
905     event Claimed(
906         uint256 index,
907         uint256 indexed amount,
908         address indexed account,
909         uint256 week
910     );
911     // This event is triggered whenever the merkle root gets updated.
912     event MerkleRootUpdated(bytes32 indexed merkleRoot, uint32 indexed week);
913     // This event is triggered whenever the admin is updated.
914     event AdminUpdated(address indexed oldAdmin, address indexed newAdmin);
915     // This event is triggered whenever the depositor contract is updated.
916     event DepositorUpdated(
917         address indexed oldDepositor,
918         address indexed newDepositor
919     );
920     // This event is triggered whenever the vault contract is updated.
921     event VaultUpdated(address indexed oldVault, address indexed newVault);
922 
923     constructor(address _vault, address _depositor) {
924         require(_vault != address(0));
925         vault = _vault;
926         admin = msg.sender;
927         depositor = _depositor;
928         week = 0;
929         frozen = true;
930     }
931 
932     /// @notice Set approvals for the tokens used when swapping
933     function setApprovals() external onlyAdmin {
934         _setApprovals();
935         IERC20(CVXCRV_TOKEN).safeApprove(vault, 0);
936         IERC20(CVXCRV_TOKEN).safeApprove(vault, type(uint256).max);
937     }
938 
939     /// @notice Check if the index has been marked as claimed.
940     /// @param index - the index to check
941     /// @return true if index has been marked as claimed.
942     function isClaimed(uint256 index) public view returns (bool) {
943         uint256 claimedWordIndex = index / 256;
944         uint256 claimedBitIndex = index % 256;
945         uint256 claimedWord = claimedBitMap[week][claimedWordIndex];
946         uint256 mask = (1 << claimedBitIndex);
947         return claimedWord & mask == mask;
948     }
949 
950     function _setClaimed(uint256 index) private {
951         uint256 claimedWordIndex = index / 256;
952         uint256 claimedBitIndex = index % 256;
953         claimedBitMap[week][claimedWordIndex] =
954             claimedBitMap[week][claimedWordIndex] |
955             (1 << claimedBitIndex);
956     }
957 
958     /// @notice Transfers ownership of the contract
959     /// @param newAdmin - address of the new admin of the contract
960     function updateAdmin(address newAdmin)
961         external
962         onlyAdmin
963         notToZeroAddress(newAdmin)
964     {
965         address oldAdmin = admin;
966         admin = newAdmin;
967         emit AdminUpdated(oldAdmin, newAdmin);
968     }
969 
970     /// @notice Changes the contract allowed to freeze before depositing
971     /// @param newDepositor - address of the new depositor contract
972     function updateDepositor(address newDepositor)
973         external
974         onlyAdmin
975         notToZeroAddress(newDepositor)
976     {
977         address oldDepositor = depositor;
978         depositor = newDepositor;
979         emit DepositorUpdated(oldDepositor, newDepositor);
980     }
981 
982     /// @notice Changes the Vault where funds are staked
983     /// @param newVault - address of the new vault contract
984     function updateVault(address newVault)
985         external
986         onlyAdmin
987         notToZeroAddress(newVault)
988     {
989         address oldVault = vault;
990         vault = newVault;
991         emit VaultUpdated(oldVault, newVault);
992     }
993 
994     /// @notice Internal function to handle users' claims
995     /// @param index - claimer index
996     /// @param account - claimer account
997     /// @param amount - claim amount
998     /// @param merkleProof - merkle proof for the claim
999     function _claim(
1000         uint256 index,
1001         address account,
1002         uint256 amount,
1003         bytes32[] calldata merkleProof
1004     ) internal {
1005         require(!frozen, "Claiming is frozen.");
1006         require(!isClaimed(index), "Drop already claimed.");
1007 
1008         // Verify the merkle proof.
1009         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
1010         require(
1011             MerkleProof.verify(merkleProof, merkleRoot, node),
1012             "Invalid proof."
1013         );
1014 
1015         // Mark it claimed and send the token.
1016         _setClaimed(index);
1017     }
1018 
1019     /// @notice Claim the given amount of uCRV to the given address.
1020     /// @param index - claimer index
1021     /// @param account - claimer account
1022     /// @param amount - claim amount
1023     /// @param merkleProof - merkle proof for the claim
1024     function claim(
1025         uint256 index,
1026         address account,
1027         uint256 amount,
1028         bytes32[] calldata merkleProof
1029     ) external {
1030         // Claim
1031         _claim(index, account, amount, merkleProof);
1032 
1033         // Send shares to account
1034         IERC20(vault).safeTransfer(account, amount);
1035 
1036         emit Claimed(index, amount, account, week);
1037     }
1038 
1039     /// @notice Claim as an other token
1040     /// Reverts if the inputs are invalid.
1041     /// @param index - claimer index
1042     /// @param account - claimer account
1043     /// @param amount - claim amount
1044     /// @param merkleProof - merkle proof for the claim
1045     /// @param option - claiming option
1046     function claimAs(
1047         uint256 index,
1048         address account,
1049         uint256 amount,
1050         bytes32[] calldata merkleProof,
1051         Option option
1052     ) external {
1053         _claimZap(index, account, amount, merkleProof, option, 0);
1054     }
1055 
1056     /// @notice Claim as an other token
1057     /// Reverts if the inputs are invalid.
1058     /// @param index - claimer index
1059     /// @param account - claimer account
1060     /// @param amount - claim amount
1061     /// @param merkleProof - merkle proof for the claim
1062     /// @param option - claiming option
1063     /// @param minAmountOut - minimum desired amount of output token
1064     function claimAs(
1065         uint256 index,
1066         address account,
1067         uint256 amount,
1068         bytes32[] calldata merkleProof,
1069         Option option,
1070         uint256 minAmountOut
1071     ) external {
1072         _claimZap(index, account, amount, merkleProof, option, minAmountOut);
1073     }
1074 
1075     /// @notice Claim as an other token
1076     /// Reverts if the inputs are invalid.
1077     /// @param index - claimer index
1078     /// @param account - claimer account
1079     /// @param amount - claim amount
1080     /// @param merkleProof - merkle proof for the claim
1081     /// @param option - claiming option
1082     /// @param minAmountOut - minimum desired amount of output token
1083     function _claimZap(
1084         uint256 index,
1085         address account,
1086         uint256 amount,
1087         bytes32[] calldata merkleProof,
1088         Option option,
1089         uint256 minAmountOut
1090     ) internal {
1091         // Claim
1092         _claim(index, account, amount, merkleProof);
1093 
1094         // Unstake
1095         uint256 _withdrawn = IUnionVault(vault).withdraw(address(this), amount);
1096 
1097         // Claim it as the specified token
1098         _claimAs(account, _withdrawn, option, minAmountOut);
1099         emit Claimed(index, amount, account, week);
1100     }
1101 
1102     /// @notice Stakes the contract's entire cvxCRV balance in the Vault
1103     function stake() external onlyAdminOrDistributor {
1104         IUnionVault(vault).depositAll(address(this));
1105     }
1106 
1107     /// @notice Freezes the claim function to allow the merkleRoot to be changed
1108     /// @dev Can be called by the owner or the depositor zap contract
1109     function freeze() external onlyAdminOrDistributor {
1110         frozen = true;
1111     }
1112 
1113     /// @notice Unfreezes the claim function.
1114     function unfreeze() public onlyAdmin {
1115         frozen = false;
1116     }
1117 
1118     /// @notice Update the merkle root and increment the week.
1119     /// @param _merkleRoot - the new root to push
1120     /// @param _unfreeze - whether to unfreeze the contract after unlock
1121     function updateMerkleRoot(bytes32 _merkleRoot, bool _unfreeze)
1122         external
1123         onlyAdmin
1124     {
1125         require(frozen, "Contract not frozen.");
1126 
1127         // Increment the week (simulates the clearing of the claimedBitMap)
1128         week = week + 1;
1129         // Set the new merkle root
1130         merkleRoot = _merkleRoot;
1131 
1132         emit MerkleRootUpdated(merkleRoot, week);
1133 
1134         if (_unfreeze) {
1135             unfreeze();
1136         }
1137     }
1138 
1139     receive() external payable {}
1140 
1141     modifier onlyAdmin() {
1142         require(msg.sender == admin, "Admin only");
1143         _;
1144     }
1145 
1146     modifier onlyAdminOrDistributor() {
1147         require(
1148             (msg.sender == admin) || (msg.sender == depositor),
1149             "Admin or depositor only"
1150         );
1151         _;
1152     }
1153 }
