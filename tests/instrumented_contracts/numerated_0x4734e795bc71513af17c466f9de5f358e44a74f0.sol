1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Address.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
72 
73 pragma solidity ^0.8.1;
74 
75 /**
76  * @dev Collection of functions related to the address type
77  */
78 library Address {
79     /**
80      * @dev Returns true if `account` is a contract.
81      *
82      * [IMPORTANT]
83      * ====
84      * It is unsafe to assume that an address for which this function returns
85      * false is an externally-owned account (EOA) and not a contract.
86      *
87      * Among others, `isContract` will return false for the following
88      * types of addresses:
89      *
90      *  - an externally-owned account
91      *  - a contract in construction
92      *  - an address where a contract will be created
93      *  - an address where a contract lived, but was destroyed
94      * ====
95      *
96      * [IMPORTANT]
97      * ====
98      * You shouldn't rely on `isContract` to protect against flash loan attacks!
99      *
100      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
101      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
102      * constructor.
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize/address.code.length, which returns 0
107         // for contracts in construction, since the code is only stored at the end
108         // of the constructor execution.
109 
110         return account.code.length > 0;
111     }
112 
113     /**
114      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
115      * `recipient`, forwarding all available gas and reverting on errors.
116      *
117      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
118      * of certain opcodes, possibly making contracts go over the 2300 gas limit
119      * imposed by `transfer`, making them unable to receive funds via
120      * `transfer`. {sendValue} removes this limitation.
121      *
122      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
123      *
124      * IMPORTANT: because control is transferred to `recipient`, care must be
125      * taken to not create reentrancy vulnerabilities. Consider using
126      * {ReentrancyGuard} or the
127      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
128      */
129     function sendValue(address payable recipient, uint256 amount) internal {
130         require(address(this).balance >= amount, "Address: insufficient balance");
131 
132         (bool success, ) = recipient.call{value: amount}("");
133         require(success, "Address: unable to send value, recipient may have reverted");
134     }
135 
136     /**
137      * @dev Performs a Solidity function call using a low level `call`. A
138      * plain `call` is an unsafe replacement for a function call: use this
139      * function instead.
140      *
141      * If `target` reverts with a revert reason, it is bubbled up by this
142      * function (like regular Solidity function calls).
143      *
144      * Returns the raw returned data. To convert to the expected return value,
145      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
146      *
147      * Requirements:
148      *
149      * - `target` must be a contract.
150      * - calling `target` with `data` must not revert.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
155         return functionCall(target, data, "Address: low-level call failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
160      * `errorMessage` as a fallback revert reason when `target` reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCall(
165         address target,
166         bytes memory data,
167         string memory errorMessage
168     ) internal returns (bytes memory) {
169         return functionCallWithValue(target, data, 0, errorMessage);
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
174      * but also transferring `value` wei to `target`.
175      *
176      * Requirements:
177      *
178      * - the calling contract must have an ETH balance of at least `value`.
179      * - the called Solidity function must be `payable`.
180      *
181      * _Available since v3.1._
182      */
183     function functionCallWithValue(
184         address target,
185         bytes memory data,
186         uint256 value
187     ) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(
198         address target,
199         bytes memory data,
200         uint256 value,
201         string memory errorMessage
202     ) internal returns (bytes memory) {
203         require(address(this).balance >= value, "Address: insufficient balance for call");
204         require(isContract(target), "Address: call to non-contract");
205 
206         (bool success, bytes memory returndata) = target.call{value: value}(data);
207         return verifyCallResult(success, returndata, errorMessage);
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
217         return functionStaticCall(target, data, "Address: low-level static call failed");
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
222      * but performing a static call.
223      *
224      * _Available since v3.3._
225      */
226     function functionStaticCall(
227         address target,
228         bytes memory data,
229         string memory errorMessage
230     ) internal view returns (bytes memory) {
231         require(isContract(target), "Address: static call to non-contract");
232 
233         (bool success, bytes memory returndata) = target.staticcall(data);
234         return verifyCallResult(success, returndata, errorMessage);
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
244         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
245     }
246 
247     /**
248      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
249      * but performing a delegate call.
250      *
251      * _Available since v3.4._
252      */
253     function functionDelegateCall(
254         address target,
255         bytes memory data,
256         string memory errorMessage
257     ) internal returns (bytes memory) {
258         require(isContract(target), "Address: delegate call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.delegatecall(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
266      * revert reason using the provided one.
267      *
268      * _Available since v4.3._
269      */
270     function verifyCallResult(
271         bool success,
272         bytes memory returndata,
273         string memory errorMessage
274     ) internal pure returns (bytes memory) {
275         if (success) {
276             return returndata;
277         } else {
278             // Look for revert reason and bubble it up if present
279             if (returndata.length > 0) {
280                 // The easiest way to bubble the revert reason is using memory via assembly
281                 /// @solidity memory-safe-assembly
282                 assembly {
283                     let returndata_size := mload(returndata)
284                     revert(add(32, returndata), returndata_size)
285                 }
286             } else {
287                 revert(errorMessage);
288             }
289         }
290     }
291 }
292 
293 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
294 
295 
296 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 /**
301  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
302  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
303  *
304  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
305  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
306  * need to send a transaction, and thus is not required to hold Ether at all.
307  */
308 interface IERC20Permit {
309     /**
310      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
311      * given ``owner``'s signed approval.
312      *
313      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
314      * ordering also apply here.
315      *
316      * Emits an {Approval} event.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `deadline` must be a timestamp in the future.
322      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
323      * over the EIP712-formatted function arguments.
324      * - the signature must use ``owner``'s current nonce (see {nonces}).
325      *
326      * For more information on the signature format, see the
327      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
328      * section].
329      */
330     function permit(
331         address owner,
332         address spender,
333         uint256 value,
334         uint256 deadline,
335         uint8 v,
336         bytes32 r,
337         bytes32 s
338     ) external;
339 
340     /**
341      * @dev Returns the current nonce for `owner`. This value must be
342      * included whenever a signature is generated for {permit}.
343      *
344      * Every successful call to {permit} increases ``owner``'s nonce by one. This
345      * prevents a signature from being used multiple times.
346      */
347     function nonces(address owner) external view returns (uint256);
348 
349     /**
350      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
351      */
352     // solhint-disable-next-line func-name-mixedcase
353     function DOMAIN_SEPARATOR() external view returns (bytes32);
354 }
355 
356 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
357 
358 
359 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Interface of the ERC20 standard as defined in the EIP.
365  */
366 interface IERC20 {
367     /**
368      * @dev Emitted when `value` tokens are moved from one account (`from`) to
369      * another (`to`).
370      *
371      * Note that `value` may be zero.
372      */
373     event Transfer(address indexed from, address indexed to, uint256 value);
374 
375     /**
376      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
377      * a call to {approve}. `value` is the new allowance.
378      */
379     event Approval(address indexed owner, address indexed spender, uint256 value);
380 
381     /**
382      * @dev Returns the amount of tokens in existence.
383      */
384     function totalSupply() external view returns (uint256);
385 
386     /**
387      * @dev Returns the amount of tokens owned by `account`.
388      */
389     function balanceOf(address account) external view returns (uint256);
390 
391     /**
392      * @dev Moves `amount` tokens from the caller's account to `to`.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * Emits a {Transfer} event.
397      */
398     function transfer(address to, uint256 amount) external returns (bool);
399 
400     /**
401      * @dev Returns the remaining number of tokens that `spender` will be
402      * allowed to spend on behalf of `owner` through {transferFrom}. This is
403      * zero by default.
404      *
405      * This value changes when {approve} or {transferFrom} are called.
406      */
407     function allowance(address owner, address spender) external view returns (uint256);
408 
409     /**
410      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * IMPORTANT: Beware that changing an allowance with this method brings the risk
415      * that someone may use both the old and the new allowance by unfortunate
416      * transaction ordering. One possible solution to mitigate this race
417      * condition is to first reduce the spender's allowance to 0 and set the
418      * desired value afterwards:
419      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
420      *
421      * Emits an {Approval} event.
422      */
423     function approve(address spender, uint256 amount) external returns (bool);
424 
425     /**
426      * @dev Moves `amount` tokens from `from` to `to` using the
427      * allowance mechanism. `amount` is then deducted from the caller's
428      * allowance.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * Emits a {Transfer} event.
433      */
434     function transferFrom(
435         address from,
436         address to,
437         uint256 amount
438     ) external returns (bool);
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
442 
443 
444 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 
449 
450 
451 /**
452  * @title SafeERC20
453  * @dev Wrappers around ERC20 operations that throw on failure (when the token
454  * contract returns false). Tokens that return no value (and instead revert or
455  * throw on failure) are also supported, non-reverting calls are assumed to be
456  * successful.
457  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
458  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
459  */
460 library SafeERC20 {
461     using Address for address;
462 
463     function safeTransfer(
464         IERC20 token,
465         address to,
466         uint256 value
467     ) internal {
468         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
469     }
470 
471     function safeTransferFrom(
472         IERC20 token,
473         address from,
474         address to,
475         uint256 value
476     ) internal {
477         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
478     }
479 
480     /**
481      * @dev Deprecated. This function has issues similar to the ones found in
482      * {IERC20-approve}, and its usage is discouraged.
483      *
484      * Whenever possible, use {safeIncreaseAllowance} and
485      * {safeDecreaseAllowance} instead.
486      */
487     function safeApprove(
488         IERC20 token,
489         address spender,
490         uint256 value
491     ) internal {
492         // safeApprove should only be called when setting an initial allowance,
493         // or when resetting it to zero. To increase and decrease it, use
494         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
495         require(
496             (value == 0) || (token.allowance(address(this), spender) == 0),
497             "SafeERC20: approve from non-zero to non-zero allowance"
498         );
499         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
500     }
501 
502     function safeIncreaseAllowance(
503         IERC20 token,
504         address spender,
505         uint256 value
506     ) internal {
507         uint256 newAllowance = token.allowance(address(this), spender) + value;
508         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
509     }
510 
511     function safeDecreaseAllowance(
512         IERC20 token,
513         address spender,
514         uint256 value
515     ) internal {
516         unchecked {
517             uint256 oldAllowance = token.allowance(address(this), spender);
518             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
519             uint256 newAllowance = oldAllowance - value;
520             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
521         }
522     }
523 
524     function safePermit(
525         IERC20Permit token,
526         address owner,
527         address spender,
528         uint256 value,
529         uint256 deadline,
530         uint8 v,
531         bytes32 r,
532         bytes32 s
533     ) internal {
534         uint256 nonceBefore = token.nonces(owner);
535         token.permit(owner, spender, value, deadline, v, r, s);
536         uint256 nonceAfter = token.nonces(owner);
537         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
549         // the target address contains contract code and also asserts for success in the low-level call.
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) {
553             // Return data is optional
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev These functions deal with verification of Merkle Tree proofs.
568  *
569  * The proofs can be generated using the JavaScript library
570  * https://github.com/miguelmota/merkletreejs[merkletreejs].
571  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
572  *
573  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
574  *
575  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
576  * hashing, or use a hash function other than keccak256 for hashing leaves.
577  * This is because the concatenation of a sorted pair of internal nodes in
578  * the merkle tree could be reinterpreted as a leaf value.
579  */
580 library MerkleProof {
581     /**
582      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
583      * defined by `root`. For this, a `proof` must be provided, containing
584      * sibling hashes on the branch from the leaf to the root of the tree. Each
585      * pair of leaves and each pair of pre-images are assumed to be sorted.
586      */
587     function verify(
588         bytes32[] memory proof,
589         bytes32 root,
590         bytes32 leaf
591     ) internal pure returns (bool) {
592         return processProof(proof, leaf) == root;
593     }
594 
595     /**
596      * @dev Calldata version of {verify}
597      *
598      * _Available since v4.7._
599      */
600     function verifyCalldata(
601         bytes32[] calldata proof,
602         bytes32 root,
603         bytes32 leaf
604     ) internal pure returns (bool) {
605         return processProofCalldata(proof, leaf) == root;
606     }
607 
608     /**
609      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
610      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
611      * hash matches the root of the tree. When processing the proof, the pairs
612      * of leafs & pre-images are assumed to be sorted.
613      *
614      * _Available since v4.4._
615      */
616     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
617         bytes32 computedHash = leaf;
618         for (uint256 i = 0; i < proof.length; i++) {
619             computedHash = _hashPair(computedHash, proof[i]);
620         }
621         return computedHash;
622     }
623 
624     /**
625      * @dev Calldata version of {processProof}
626      *
627      * _Available since v4.7._
628      */
629     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
630         bytes32 computedHash = leaf;
631         for (uint256 i = 0; i < proof.length; i++) {
632             computedHash = _hashPair(computedHash, proof[i]);
633         }
634         return computedHash;
635     }
636 
637     /**
638      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
639      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
640      *
641      * _Available since v4.7._
642      */
643     function multiProofVerify(
644         bytes32[] memory proof,
645         bool[] memory proofFlags,
646         bytes32 root,
647         bytes32[] memory leaves
648     ) internal pure returns (bool) {
649         return processMultiProof(proof, proofFlags, leaves) == root;
650     }
651 
652     /**
653      * @dev Calldata version of {multiProofVerify}
654      *
655      * _Available since v4.7._
656      */
657     function multiProofVerifyCalldata(
658         bytes32[] calldata proof,
659         bool[] calldata proofFlags,
660         bytes32 root,
661         bytes32[] memory leaves
662     ) internal pure returns (bool) {
663         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
664     }
665 
666     /**
667      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
668      * consuming from one or the other at each step according to the instructions given by
669      * `proofFlags`.
670      *
671      * _Available since v4.7._
672      */
673     function processMultiProof(
674         bytes32[] memory proof,
675         bool[] memory proofFlags,
676         bytes32[] memory leaves
677     ) internal pure returns (bytes32 merkleRoot) {
678         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
679         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
680         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
681         // the merkle tree.
682         uint256 leavesLen = leaves.length;
683         uint256 totalHashes = proofFlags.length;
684 
685         // Check proof validity.
686         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
687 
688         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
689         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
690         bytes32[] memory hashes = new bytes32[](totalHashes);
691         uint256 leafPos = 0;
692         uint256 hashPos = 0;
693         uint256 proofPos = 0;
694         // At each step, we compute the next hash using two values:
695         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
696         //   get the next hash.
697         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
698         //   `proof` array.
699         for (uint256 i = 0; i < totalHashes; i++) {
700             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
701             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
702             hashes[i] = _hashPair(a, b);
703         }
704 
705         if (totalHashes > 0) {
706             return hashes[totalHashes - 1];
707         } else if (leavesLen > 0) {
708             return leaves[0];
709         } else {
710             return proof[0];
711         }
712     }
713 
714     /**
715      * @dev Calldata version of {processMultiProof}
716      *
717      * _Available since v4.7._
718      */
719     function processMultiProofCalldata(
720         bytes32[] calldata proof,
721         bool[] calldata proofFlags,
722         bytes32[] memory leaves
723     ) internal pure returns (bytes32 merkleRoot) {
724         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
725         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
726         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
727         // the merkle tree.
728         uint256 leavesLen = leaves.length;
729         uint256 totalHashes = proofFlags.length;
730 
731         // Check proof validity.
732         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
733 
734         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
735         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
736         bytes32[] memory hashes = new bytes32[](totalHashes);
737         uint256 leafPos = 0;
738         uint256 hashPos = 0;
739         uint256 proofPos = 0;
740         // At each step, we compute the next hash using two values:
741         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
742         //   get the next hash.
743         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
744         //   `proof` array.
745         for (uint256 i = 0; i < totalHashes; i++) {
746             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
747             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
748             hashes[i] = _hashPair(a, b);
749         }
750 
751         if (totalHashes > 0) {
752             return hashes[totalHashes - 1];
753         } else if (leavesLen > 0) {
754             return leaves[0];
755         } else {
756             return proof[0];
757         }
758     }
759 
760     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
761         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
762     }
763 
764     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
765         /// @solidity memory-safe-assembly
766         assembly {
767             mstore(0x00, a)
768             mstore(0x20, b)
769             value := keccak256(0x00, 0x40)
770         }
771     }
772 }
773 
774 // File: @openzeppelin/contracts/utils/Strings.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 /**
782  * @dev String operations.
783  */
784 library Strings {
785     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
786     uint8 private constant _ADDRESS_LENGTH = 20;
787 
788     /**
789      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
790      */
791     function toString(uint256 value) internal pure returns (string memory) {
792         // Inspired by OraclizeAPI's implementation - MIT licence
793         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
794 
795         if (value == 0) {
796             return "0";
797         }
798         uint256 temp = value;
799         uint256 digits;
800         while (temp != 0) {
801             digits++;
802             temp /= 10;
803         }
804         bytes memory buffer = new bytes(digits);
805         while (value != 0) {
806             digits -= 1;
807             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
808             value /= 10;
809         }
810         return string(buffer);
811     }
812 
813     /**
814      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
815      */
816     function toHexString(uint256 value) internal pure returns (string memory) {
817         if (value == 0) {
818             return "0x00";
819         }
820         uint256 temp = value;
821         uint256 length = 0;
822         while (temp != 0) {
823             length++;
824             temp >>= 8;
825         }
826         return toHexString(value, length);
827     }
828 
829     /**
830      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
831      */
832     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
833         bytes memory buffer = new bytes(2 * length + 2);
834         buffer[0] = "0";
835         buffer[1] = "x";
836         for (uint256 i = 2 * length + 1; i > 1; --i) {
837             buffer[i] = _HEX_SYMBOLS[value & 0xf];
838             value >>= 4;
839         }
840         require(value == 0, "Strings: hex length insufficient");
841         return string(buffer);
842     }
843 
844     /**
845      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
846      */
847     function toHexString(address addr) internal pure returns (string memory) {
848         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
849     }
850 }
851 
852 // File: @openzeppelin/contracts/utils/Context.sol
853 
854 
855 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
856 
857 pragma solidity ^0.8.0;
858 
859 /**
860  * @dev Provides information about the current execution context, including the
861  * sender of the transaction and its data. While these are generally available
862  * via msg.sender and msg.data, they should not be accessed in such a direct
863  * manner, since when dealing with meta-transactions the account sending and
864  * paying for execution may not be the actual sender (as far as an application
865  * is concerned).
866  *
867  * This contract is only required for intermediate, library-like contracts.
868  */
869 abstract contract Context {
870     function _msgSender() internal view virtual returns (address) {
871         return msg.sender;
872     }
873 
874     function _msgData() internal view virtual returns (bytes calldata) {
875         return msg.data;
876     }
877 }
878 
879 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 
888 
889 /**
890  * @title PaymentSplitter
891  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
892  * that the Ether will be split in this way, since it is handled transparently by the contract.
893  *
894  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
895  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
896  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
897  * time of contract deployment and can't be updated thereafter.
898  *
899  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
900  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
901  * function.
902  *
903  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
904  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
905  * to run tests before sending real value to this contract.
906  */
907 contract PaymentSplitter is Context {
908     event PayeeAdded(address account, uint256 shares);
909     event PaymentReleased(address to, uint256 amount);
910     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
911     event PaymentReceived(address from, uint256 amount);
912 
913     uint256 private _totalShares;
914     uint256 private _totalReleased;
915 
916     mapping(address => uint256) private _shares;
917     mapping(address => uint256) private _released;
918     address[] private _payees;
919 
920     mapping(IERC20 => uint256) private _erc20TotalReleased;
921     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
922 
923     /**
924      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
925      * the matching position in the `shares` array.
926      *
927      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
928      * duplicates in `payees`.
929      */
930     constructor(address[] memory payees, uint256[] memory shares_) payable {
931         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
932         require(payees.length > 0, "PaymentSplitter: no payees");
933 
934         for (uint256 i = 0; i < payees.length; i++) {
935             _addPayee(payees[i], shares_[i]);
936         }
937     }
938 
939     /**
940      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
941      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
942      * reliability of the events, and not the actual splitting of Ether.
943      *
944      * To learn more about this see the Solidity documentation for
945      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
946      * functions].
947      */
948     receive() external payable virtual {
949         emit PaymentReceived(_msgSender(), msg.value);
950     }
951 
952     /**
953      * @dev Getter for the total shares held by payees.
954      */
955     function totalShares() public view returns (uint256) {
956         return _totalShares;
957     }
958 
959     /**
960      * @dev Getter for the total amount of Ether already released.
961      */
962     function totalReleased() public view returns (uint256) {
963         return _totalReleased;
964     }
965 
966     /**
967      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
968      * contract.
969      */
970     function totalReleased(IERC20 token) public view returns (uint256) {
971         return _erc20TotalReleased[token];
972     }
973 
974     /**
975      * @dev Getter for the amount of shares held by an account.
976      */
977     function shares(address account) public view returns (uint256) {
978         return _shares[account];
979     }
980 
981     /**
982      * @dev Getter for the amount of Ether already released to a payee.
983      */
984     function released(address account) public view returns (uint256) {
985         return _released[account];
986     }
987 
988     /**
989      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
990      * IERC20 contract.
991      */
992     function released(IERC20 token, address account) public view returns (uint256) {
993         return _erc20Released[token][account];
994     }
995 
996     /**
997      * @dev Getter for the address of the payee number `index`.
998      */
999     function payee(uint256 index) public view returns (address) {
1000         return _payees[index];
1001     }
1002 
1003     /**
1004      * @dev Getter for the amount of payee's releasable Ether.
1005      */
1006     function releasable(address account) public view returns (uint256) {
1007         uint256 totalReceived = address(this).balance + totalReleased();
1008         return _pendingPayment(account, totalReceived, released(account));
1009     }
1010 
1011     /**
1012      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1013      * IERC20 contract.
1014      */
1015     function releasable(IERC20 token, address account) public view returns (uint256) {
1016         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1017         return _pendingPayment(account, totalReceived, released(token, account));
1018     }
1019 
1020     /**
1021      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1022      * total shares and their previous withdrawals.
1023      */
1024     function release(address payable account) public virtual {
1025         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1026 
1027         uint256 payment = releasable(account);
1028 
1029         require(payment != 0, "PaymentSplitter: account is not due payment");
1030 
1031         _released[account] += payment;
1032         _totalReleased += payment;
1033 
1034         Address.sendValue(account, payment);
1035         emit PaymentReleased(account, payment);
1036     }
1037 
1038     /**
1039      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1040      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1041      * contract.
1042      */
1043     function release(IERC20 token, address account) public virtual {
1044         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1045 
1046         uint256 payment = releasable(token, account);
1047 
1048         require(payment != 0, "PaymentSplitter: account is not due payment");
1049 
1050         _erc20Released[token][account] += payment;
1051         _erc20TotalReleased[token] += payment;
1052 
1053         SafeERC20.safeTransfer(token, account, payment);
1054         emit ERC20PaymentReleased(token, account, payment);
1055     }
1056 
1057     /**
1058      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1059      * already released amounts.
1060      */
1061     function _pendingPayment(
1062         address account,
1063         uint256 totalReceived,
1064         uint256 alreadyReleased
1065     ) private view returns (uint256) {
1066         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1067     }
1068 
1069     /**
1070      * @dev Add a new payee to the contract.
1071      * @param account The address of the payee to add.
1072      * @param shares_ The number of shares owned by the payee.
1073      */
1074     function _addPayee(address account, uint256 shares_) private {
1075         require(account != address(0), "PaymentSplitter: account is the zero address");
1076         require(shares_ > 0, "PaymentSplitter: shares are 0");
1077         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1078 
1079         _payees.push(account);
1080         _shares[account] = shares_;
1081         _totalShares = _totalShares + shares_;
1082         emit PayeeAdded(account, shares_);
1083     }
1084 }
1085 
1086 // File: @openzeppelin/contracts/access/Ownable.sol
1087 
1088 
1089 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1090 
1091 pragma solidity ^0.8.0;
1092 
1093 
1094 /**
1095  * @dev Contract module which provides a basic access control mechanism, where
1096  * there is an account (an owner) that can be granted exclusive access to
1097  * specific functions.
1098  *
1099  * By default, the owner account will be the one that deploys the contract. This
1100  * can later be changed with {transferOwnership}.
1101  *
1102  * This module is used through inheritance. It will make available the modifier
1103  * `onlyOwner`, which can be applied to your functions to restrict their use to
1104  * the owner.
1105  */
1106 abstract contract Ownable is Context {
1107     address private _owner;
1108 
1109     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1110 
1111     /**
1112      * @dev Initializes the contract setting the deployer as the initial owner.
1113      */
1114     constructor() {
1115         _transferOwnership(_msgSender());
1116     }
1117 
1118     /**
1119      * @dev Throws if called by any account other than the owner.
1120      */
1121     modifier onlyOwner() {
1122         _checkOwner();
1123         _;
1124     }
1125 
1126     /**
1127      * @dev Returns the address of the current owner.
1128      */
1129     function owner() public view virtual returns (address) {
1130         return _owner;
1131     }
1132 
1133     /**
1134      * @dev Throws if the sender is not the owner.
1135      */
1136     function _checkOwner() internal view virtual {
1137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1138     }
1139 
1140     /**
1141      * @dev Leaves the contract without owner. It will not be possible to call
1142      * `onlyOwner` functions anymore. Can only be called by the current owner.
1143      *
1144      * NOTE: Renouncing ownership will leave the contract without an owner,
1145      * thereby removing any functionality that is only available to the owner.
1146      */
1147     function renounceOwnership() public virtual onlyOwner {
1148         _transferOwnership(address(0));
1149     }
1150 
1151     /**
1152      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1153      * Can only be called by the current owner.
1154      */
1155     function transferOwnership(address newOwner) public virtual onlyOwner {
1156         require(newOwner != address(0), "Ownable: new owner is the zero address");
1157         _transferOwnership(newOwner);
1158     }
1159 
1160     /**
1161      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1162      * Internal function without access restriction.
1163      */
1164     function _transferOwnership(address newOwner) internal virtual {
1165         address oldOwner = _owner;
1166         _owner = newOwner;
1167         emit OwnershipTransferred(oldOwner, newOwner);
1168     }
1169 }
1170 
1171 // File: erc721a/contracts/IERC721A.sol
1172 
1173 
1174 // ERC721A Contracts v4.2.2
1175 // Creator: Chiru Labs
1176 
1177 pragma solidity ^0.8.4;
1178 
1179 /**
1180  * @dev Interface of ERC721A.
1181  */
1182 interface IERC721A {
1183     /**
1184      * The caller must own the token or be an approved operator.
1185      */
1186     error ApprovalCallerNotOwnerNorApproved();
1187 
1188     /**
1189      * The token does not exist.
1190      */
1191     error ApprovalQueryForNonexistentToken();
1192 
1193     /**
1194      * The caller cannot approve to their own address.
1195      */
1196     error ApproveToCaller();
1197 
1198     /**
1199      * Cannot query the balance for the zero address.
1200      */
1201     error BalanceQueryForZeroAddress();
1202 
1203     /**
1204      * Cannot mint to the zero address.
1205      */
1206     error MintToZeroAddress();
1207 
1208     /**
1209      * The quantity of tokens minted must be more than zero.
1210      */
1211     error MintZeroQuantity();
1212 
1213     /**
1214      * The token does not exist.
1215      */
1216     error OwnerQueryForNonexistentToken();
1217 
1218     /**
1219      * The caller must own the token or be an approved operator.
1220      */
1221     error TransferCallerNotOwnerNorApproved();
1222 
1223     /**
1224      * The token must be owned by `from`.
1225      */
1226     error TransferFromIncorrectOwner();
1227 
1228     /**
1229      * Cannot safely transfer to a contract that does not implement the
1230      * ERC721Receiver interface.
1231      */
1232     error TransferToNonERC721ReceiverImplementer();
1233 
1234     /**
1235      * Cannot transfer to the zero address.
1236      */
1237     error TransferToZeroAddress();
1238 
1239     /**
1240      * The token does not exist.
1241      */
1242     error URIQueryForNonexistentToken();
1243 
1244     /**
1245      * The `quantity` minted with ERC2309 exceeds the safety limit.
1246      */
1247     error MintERC2309QuantityExceedsLimit();
1248 
1249     /**
1250      * The `extraData` cannot be set on an unintialized ownership slot.
1251      */
1252     error OwnershipNotInitializedForExtraData();
1253 
1254     // =============================================================
1255     //                            STRUCTS
1256     // =============================================================
1257 
1258     struct TokenOwnership {
1259         // The address of the owner.
1260         address addr;
1261         // Stores the start time of ownership with minimal overhead for tokenomics.
1262         uint64 startTimestamp;
1263         // Whether the token has been burned.
1264         bool burned;
1265         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1266         uint24 extraData;
1267     }
1268 
1269     // =============================================================
1270     //                         TOKEN COUNTERS
1271     // =============================================================
1272 
1273     /**
1274      * @dev Returns the total number of tokens in existence.
1275      * Burned tokens will reduce the count.
1276      * To get the total number of tokens minted, please see {_totalMinted}.
1277      */
1278     function totalSupply() external view returns (uint256);
1279 
1280     // =============================================================
1281     //                            IERC165
1282     // =============================================================
1283 
1284     /**
1285      * @dev Returns true if this contract implements the interface defined by
1286      * `interfaceId`. See the corresponding
1287      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1288      * to learn more about how these ids are created.
1289      *
1290      * This function call must use less than 30000 gas.
1291      */
1292     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1293 
1294     // =============================================================
1295     //                            IERC721
1296     // =============================================================
1297 
1298     /**
1299      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1300      */
1301     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1302 
1303     /**
1304      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1305      */
1306     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1307 
1308     /**
1309      * @dev Emitted when `owner` enables or disables
1310      * (`approved`) `operator` to manage all of its assets.
1311      */
1312     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1313 
1314     /**
1315      * @dev Returns the number of tokens in `owner`'s account.
1316      */
1317     function balanceOf(address owner) external view returns (uint256 balance);
1318 
1319     /**
1320      * @dev Returns the owner of the `tokenId` token.
1321      *
1322      * Requirements:
1323      *
1324      * - `tokenId` must exist.
1325      */
1326     function ownerOf(uint256 tokenId) external view returns (address owner);
1327 
1328     /**
1329      * @dev Safely transfers `tokenId` token from `from` to `to`,
1330      * checking first that contract recipients are aware of the ERC721 protocol
1331      * to prevent tokens from being forever locked.
1332      *
1333      * Requirements:
1334      *
1335      * - `from` cannot be the zero address.
1336      * - `to` cannot be the zero address.
1337      * - `tokenId` token must exist and be owned by `from`.
1338      * - If the caller is not `from`, it must be have been allowed to move
1339      * this token by either {approve} or {setApprovalForAll}.
1340      * - If `to` refers to a smart contract, it must implement
1341      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1342      *
1343      * Emits a {Transfer} event.
1344      */
1345     function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId,
1349         bytes calldata data
1350     ) external;
1351 
1352     /**
1353      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1354      */
1355     function safeTransferFrom(
1356         address from,
1357         address to,
1358         uint256 tokenId
1359     ) external;
1360 
1361     /**
1362      * @dev Transfers `tokenId` from `from` to `to`.
1363      *
1364      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1365      * whenever possible.
1366      *
1367      * Requirements:
1368      *
1369      * - `from` cannot be the zero address.
1370      * - `to` cannot be the zero address.
1371      * - `tokenId` token must be owned by `from`.
1372      * - If the caller is not `from`, it must be approved to move this token
1373      * by either {approve} or {setApprovalForAll}.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function transferFrom(
1378         address from,
1379         address to,
1380         uint256 tokenId
1381     ) external;
1382 
1383     /**
1384      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1385      * The approval is cleared when the token is transferred.
1386      *
1387      * Only a single account can be approved at a time, so approving the
1388      * zero address clears previous approvals.
1389      *
1390      * Requirements:
1391      *
1392      * - The caller must own the token or be an approved operator.
1393      * - `tokenId` must exist.
1394      *
1395      * Emits an {Approval} event.
1396      */
1397     function approve(address to, uint256 tokenId) external;
1398 
1399     /**
1400      * @dev Approve or remove `operator` as an operator for the caller.
1401      * Operators can call {transferFrom} or {safeTransferFrom}
1402      * for any token owned by the caller.
1403      *
1404      * Requirements:
1405      *
1406      * - The `operator` cannot be the caller.
1407      *
1408      * Emits an {ApprovalForAll} event.
1409      */
1410     function setApprovalForAll(address operator, bool _approved) external;
1411 
1412     /**
1413      * @dev Returns the account approved for `tokenId` token.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function getApproved(uint256 tokenId) external view returns (address operator);
1420 
1421     /**
1422      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1423      *
1424      * See {setApprovalForAll}.
1425      */
1426     function isApprovedForAll(address owner, address operator) external view returns (bool);
1427 
1428     // =============================================================
1429     //                        IERC721Metadata
1430     // =============================================================
1431 
1432     /**
1433      * @dev Returns the token collection name.
1434      */
1435     function name() external view returns (string memory);
1436 
1437     /**
1438      * @dev Returns the token collection symbol.
1439      */
1440     function symbol() external view returns (string memory);
1441 
1442     /**
1443      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1444      */
1445     function tokenURI(uint256 tokenId) external view returns (string memory);
1446 
1447     // =============================================================
1448     //                           IERC2309
1449     // =============================================================
1450 
1451     /**
1452      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1453      * (inclusive) is transferred from `from` to `to`, as defined in the
1454      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1455      *
1456      * See {_mintERC2309} for more details.
1457      */
1458     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1459 }
1460 
1461 // File: erc721a/contracts/ERC721A.sol
1462 
1463 
1464 // ERC721A Contracts v4.2.2
1465 // Creator: Chiru Labs
1466 
1467 pragma solidity ^0.8.4;
1468 
1469 
1470 /**
1471  * @dev Interface of ERC721 token receiver.
1472  */
1473 interface ERC721A__IERC721Receiver {
1474     function onERC721Received(
1475         address operator,
1476         address from,
1477         uint256 tokenId,
1478         bytes calldata data
1479     ) external returns (bytes4);
1480 }
1481 
1482 /**
1483  * @title ERC721A
1484  *
1485  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1486  * Non-Fungible Token Standard, including the Metadata extension.
1487  * Optimized for lower gas during batch mints.
1488  *
1489  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1490  * starting from `_startTokenId()`.
1491  *
1492  * Assumptions:
1493  *
1494  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1495  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1496  */
1497 contract ERC721A is IERC721A {
1498     // Reference type for token approval.
1499     struct TokenApprovalRef {
1500         address value;
1501     }
1502 
1503     // =============================================================
1504     //                           CONSTANTS
1505     // =============================================================
1506 
1507     // Mask of an entry in packed address data.
1508     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1509 
1510     // The bit position of `numberMinted` in packed address data.
1511     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1512 
1513     // The bit position of `numberBurned` in packed address data.
1514     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1515 
1516     // The bit position of `aux` in packed address data.
1517     uint256 private constant _BITPOS_AUX = 192;
1518 
1519     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1520     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1521 
1522     // The bit position of `startTimestamp` in packed ownership.
1523     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1524 
1525     // The bit mask of the `burned` bit in packed ownership.
1526     uint256 private constant _BITMASK_BURNED = 1 << 224;
1527 
1528     // The bit position of the `nextInitialized` bit in packed ownership.
1529     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1530 
1531     // The bit mask of the `nextInitialized` bit in packed ownership.
1532     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1533 
1534     // The bit position of `extraData` in packed ownership.
1535     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1536 
1537     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1538     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1539 
1540     // The mask of the lower 160 bits for addresses.
1541     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1542 
1543     // The maximum `quantity` that can be minted with {_mintERC2309}.
1544     // This limit is to prevent overflows on the address data entries.
1545     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1546     // is required to cause an overflow, which is unrealistic.
1547     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1548 
1549     // The `Transfer` event signature is given by:
1550     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1551     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1552         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1553 
1554     // =============================================================
1555     //                            STORAGE
1556     // =============================================================
1557 
1558     // The next token ID to be minted.
1559     uint256 private _currentIndex;
1560 
1561     // The number of tokens burned.
1562     uint256 private _burnCounter;
1563 
1564     // Token name
1565     string private _name;
1566 
1567     // Token symbol
1568     string private _symbol;
1569 
1570     // Mapping from token ID to ownership details
1571     // An empty struct value does not necessarily mean the token is unowned.
1572     // See {_packedOwnershipOf} implementation for details.
1573     //
1574     // Bits Layout:
1575     // - [0..159]   `addr`
1576     // - [160..223] `startTimestamp`
1577     // - [224]      `burned`
1578     // - [225]      `nextInitialized`
1579     // - [232..255] `extraData`
1580     mapping(uint256 => uint256) private _packedOwnerships;
1581 
1582     // Mapping owner address to address data.
1583     //
1584     // Bits Layout:
1585     // - [0..63]    `balance`
1586     // - [64..127]  `numberMinted`
1587     // - [128..191] `numberBurned`
1588     // - [192..255] `aux`
1589     mapping(address => uint256) private _packedAddressData;
1590 
1591     // Mapping from token ID to approved address.
1592     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1593 
1594     // Mapping from owner to operator approvals
1595     mapping(address => mapping(address => bool)) private _operatorApprovals;
1596 
1597     // =============================================================
1598     //                          CONSTRUCTOR
1599     // =============================================================
1600 
1601     constructor(string memory name_, string memory symbol_) {
1602         _name = name_;
1603         _symbol = symbol_;
1604         _currentIndex = _startTokenId();
1605     }
1606 
1607     // =============================================================
1608     //                   TOKEN COUNTING OPERATIONS
1609     // =============================================================
1610 
1611     /**
1612      * @dev Returns the starting token ID.
1613      * To change the starting token ID, please override this function.
1614      */
1615     function _startTokenId() internal view virtual returns (uint256) {
1616         return 0;
1617     }
1618 
1619     /**
1620      * @dev Returns the next token ID to be minted.
1621      */
1622     function _nextTokenId() internal view virtual returns (uint256) {
1623         return _currentIndex;
1624     }
1625 
1626     /**
1627      * @dev Returns the total number of tokens in existence.
1628      * Burned tokens will reduce the count.
1629      * To get the total number of tokens minted, please see {_totalMinted}.
1630      */
1631     function totalSupply() public view virtual override returns (uint256) {
1632         // Counter underflow is impossible as _burnCounter cannot be incremented
1633         // more than `_currentIndex - _startTokenId()` times.
1634         unchecked {
1635             return _currentIndex - _burnCounter - _startTokenId();
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns the total amount of tokens minted in the contract.
1641      */
1642     function _totalMinted() internal view virtual returns (uint256) {
1643         // Counter underflow is impossible as `_currentIndex` does not decrement,
1644         // and it is initialized to `_startTokenId()`.
1645         unchecked {
1646             return _currentIndex - _startTokenId();
1647         }
1648     }
1649 
1650     /**
1651      * @dev Returns the total number of tokens burned.
1652      */
1653     function _totalBurned() internal view virtual returns (uint256) {
1654         return _burnCounter;
1655     }
1656 
1657     // =============================================================
1658     //                    ADDRESS DATA OPERATIONS
1659     // =============================================================
1660 
1661     /**
1662      * @dev Returns the number of tokens in `owner`'s account.
1663      */
1664     function balanceOf(address owner) public view virtual override returns (uint256) {
1665         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1666         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1667     }
1668 
1669     /**
1670      * Returns the number of tokens minted by `owner`.
1671      */
1672     function _numberMinted(address owner) internal view returns (uint256) {
1673         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1674     }
1675 
1676     /**
1677      * Returns the number of tokens burned by or on behalf of `owner`.
1678      */
1679     function _numberBurned(address owner) internal view returns (uint256) {
1680         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1681     }
1682 
1683     /**
1684      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1685      */
1686     function _getAux(address owner) internal view returns (uint64) {
1687         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1688     }
1689 
1690     /**
1691      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1692      * If there are multiple variables, please pack them into a uint64.
1693      */
1694     function _setAux(address owner, uint64 aux) internal virtual {
1695         uint256 packed = _packedAddressData[owner];
1696         uint256 auxCasted;
1697         // Cast `aux` with assembly to avoid redundant masking.
1698         assembly {
1699             auxCasted := aux
1700         }
1701         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1702         _packedAddressData[owner] = packed;
1703     }
1704 
1705     // =============================================================
1706     //                            IERC165
1707     // =============================================================
1708 
1709     /**
1710      * @dev Returns true if this contract implements the interface defined by
1711      * `interfaceId`. See the corresponding
1712      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1713      * to learn more about how these ids are created.
1714      *
1715      * This function call must use less than 30000 gas.
1716      */
1717     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1718         // The interface IDs are constants representing the first 4 bytes
1719         // of the XOR of all function selectors in the interface.
1720         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1721         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1722         return
1723             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1724             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1725             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1726     }
1727 
1728     // =============================================================
1729     //                        IERC721Metadata
1730     // =============================================================
1731 
1732     /**
1733      * @dev Returns the token collection name.
1734      */
1735     function name() public view virtual override returns (string memory) {
1736         return _name;
1737     }
1738 
1739     /**
1740      * @dev Returns the token collection symbol.
1741      */
1742     function symbol() public view virtual override returns (string memory) {
1743         return _symbol;
1744     }
1745 
1746     /**
1747      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1748      */
1749     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1750         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1751 
1752         string memory baseURI = _baseURI();
1753         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1754     }
1755 
1756     /**
1757      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1758      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1759      * by default, it can be overridden in child contracts.
1760      */
1761     function _baseURI() internal view virtual returns (string memory) {
1762         return '';
1763     }
1764 
1765     // =============================================================
1766     //                     OWNERSHIPS OPERATIONS
1767     // =============================================================
1768 
1769     /**
1770      * @dev Returns the owner of the `tokenId` token.
1771      *
1772      * Requirements:
1773      *
1774      * - `tokenId` must exist.
1775      */
1776     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1777         return address(uint160(_packedOwnershipOf(tokenId)));
1778     }
1779 
1780     /**
1781      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1782      * It gradually moves to O(1) as tokens get transferred around over time.
1783      */
1784     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1785         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1786     }
1787 
1788     /**
1789      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1790      */
1791     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1792         return _unpackedOwnership(_packedOwnerships[index]);
1793     }
1794 
1795     /**
1796      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1797      */
1798     function _initializeOwnershipAt(uint256 index) internal virtual {
1799         if (_packedOwnerships[index] == 0) {
1800             _packedOwnerships[index] = _packedOwnershipOf(index);
1801         }
1802     }
1803 
1804     /**
1805      * Returns the packed ownership data of `tokenId`.
1806      */
1807     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1808         uint256 curr = tokenId;
1809 
1810         unchecked {
1811             if (_startTokenId() <= curr)
1812                 if (curr < _currentIndex) {
1813                     uint256 packed = _packedOwnerships[curr];
1814                     // If not burned.
1815                     if (packed & _BITMASK_BURNED == 0) {
1816                         // Invariant:
1817                         // There will always be an initialized ownership slot
1818                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1819                         // before an unintialized ownership slot
1820                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1821                         // Hence, `curr` will not underflow.
1822                         //
1823                         // We can directly compare the packed value.
1824                         // If the address is zero, packed will be zero.
1825                         while (packed == 0) {
1826                             packed = _packedOwnerships[--curr];
1827                         }
1828                         return packed;
1829                     }
1830                 }
1831         }
1832         revert OwnerQueryForNonexistentToken();
1833     }
1834 
1835     /**
1836      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1837      */
1838     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1839         ownership.addr = address(uint160(packed));
1840         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1841         ownership.burned = packed & _BITMASK_BURNED != 0;
1842         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1843     }
1844 
1845     /**
1846      * @dev Packs ownership data into a single uint256.
1847      */
1848     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1849         assembly {
1850             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1851             owner := and(owner, _BITMASK_ADDRESS)
1852             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1853             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1854         }
1855     }
1856 
1857     /**
1858      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1859      */
1860     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1861         // For branchless setting of the `nextInitialized` flag.
1862         assembly {
1863             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1864             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1865         }
1866     }
1867 
1868     // =============================================================
1869     //                      APPROVAL OPERATIONS
1870     // =============================================================
1871 
1872     /**
1873      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1874      * The approval is cleared when the token is transferred.
1875      *
1876      * Only a single account can be approved at a time, so approving the
1877      * zero address clears previous approvals.
1878      *
1879      * Requirements:
1880      *
1881      * - The caller must own the token or be an approved operator.
1882      * - `tokenId` must exist.
1883      *
1884      * Emits an {Approval} event.
1885      */
1886     function approve(address to, uint256 tokenId) public virtual override {
1887         address owner = ownerOf(tokenId);
1888 
1889         if (_msgSenderERC721A() != owner)
1890             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1891                 revert ApprovalCallerNotOwnerNorApproved();
1892             }
1893 
1894         _tokenApprovals[tokenId].value = to;
1895         emit Approval(owner, to, tokenId);
1896     }
1897 
1898     /**
1899      * @dev Returns the account approved for `tokenId` token.
1900      *
1901      * Requirements:
1902      *
1903      * - `tokenId` must exist.
1904      */
1905     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1906         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1907 
1908         return _tokenApprovals[tokenId].value;
1909     }
1910 
1911     /**
1912      * @dev Approve or remove `operator` as an operator for the caller.
1913      * Operators can call {transferFrom} or {safeTransferFrom}
1914      * for any token owned by the caller.
1915      *
1916      * Requirements:
1917      *
1918      * - The `operator` cannot be the caller.
1919      *
1920      * Emits an {ApprovalForAll} event.
1921      */
1922     function setApprovalForAll(address operator, bool approved) public virtual override {
1923         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1924 
1925         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1926         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1927     }
1928 
1929     /**
1930      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1931      *
1932      * See {setApprovalForAll}.
1933      */
1934     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1935         return _operatorApprovals[owner][operator];
1936     }
1937 
1938     /**
1939      * @dev Returns whether `tokenId` exists.
1940      *
1941      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1942      *
1943      * Tokens start existing when they are minted. See {_mint}.
1944      */
1945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1946         return
1947             _startTokenId() <= tokenId &&
1948             tokenId < _currentIndex && // If within bounds,
1949             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1950     }
1951 
1952     /**
1953      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1954      */
1955     function _isSenderApprovedOrOwner(
1956         address approvedAddress,
1957         address owner,
1958         address msgSender
1959     ) private pure returns (bool result) {
1960         assembly {
1961             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1962             owner := and(owner, _BITMASK_ADDRESS)
1963             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1964             msgSender := and(msgSender, _BITMASK_ADDRESS)
1965             // `msgSender == owner || msgSender == approvedAddress`.
1966             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1967         }
1968     }
1969 
1970     /**
1971      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1972      */
1973     function _getApprovedSlotAndAddress(uint256 tokenId)
1974         private
1975         view
1976         returns (uint256 approvedAddressSlot, address approvedAddress)
1977     {
1978         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1979         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1980         assembly {
1981             approvedAddressSlot := tokenApproval.slot
1982             approvedAddress := sload(approvedAddressSlot)
1983         }
1984     }
1985 
1986     // =============================================================
1987     //                      TRANSFER OPERATIONS
1988     // =============================================================
1989 
1990     /**
1991      * @dev Transfers `tokenId` from `from` to `to`.
1992      *
1993      * Requirements:
1994      *
1995      * - `from` cannot be the zero address.
1996      * - `to` cannot be the zero address.
1997      * - `tokenId` token must be owned by `from`.
1998      * - If the caller is not `from`, it must be approved to move this token
1999      * by either {approve} or {setApprovalForAll}.
2000      *
2001      * Emits a {Transfer} event.
2002      */
2003     function transferFrom(
2004         address from,
2005         address to,
2006         uint256 tokenId
2007     ) public virtual override {
2008         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2009 
2010         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2011 
2012         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2013 
2014         // The nested ifs save around 20+ gas over a compound boolean condition.
2015         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2016             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2017 
2018         if (to == address(0)) revert TransferToZeroAddress();
2019 
2020         _beforeTokenTransfers(from, to, tokenId, 1);
2021 
2022         // Clear approvals from the previous owner.
2023         assembly {
2024             if approvedAddress {
2025                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2026                 sstore(approvedAddressSlot, 0)
2027             }
2028         }
2029 
2030         // Underflow of the sender's balance is impossible because we check for
2031         // ownership above and the recipient's balance can't realistically overflow.
2032         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2033         unchecked {
2034             // We can directly increment and decrement the balances.
2035             --_packedAddressData[from]; // Updates: `balance -= 1`.
2036             ++_packedAddressData[to]; // Updates: `balance += 1`.
2037 
2038             // Updates:
2039             // - `address` to the next owner.
2040             // - `startTimestamp` to the timestamp of transfering.
2041             // - `burned` to `false`.
2042             // - `nextInitialized` to `true`.
2043             _packedOwnerships[tokenId] = _packOwnershipData(
2044                 to,
2045                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2046             );
2047 
2048             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2049             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2050                 uint256 nextTokenId = tokenId + 1;
2051                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2052                 if (_packedOwnerships[nextTokenId] == 0) {
2053                     // If the next slot is within bounds.
2054                     if (nextTokenId != _currentIndex) {
2055                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2056                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2057                     }
2058                 }
2059             }
2060         }
2061 
2062         emit Transfer(from, to, tokenId);
2063         _afterTokenTransfers(from, to, tokenId, 1);
2064     }
2065 
2066     /**
2067      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2068      */
2069     function safeTransferFrom(
2070         address from,
2071         address to,
2072         uint256 tokenId
2073     ) public virtual override {
2074         safeTransferFrom(from, to, tokenId, '');
2075     }
2076 
2077     /**
2078      * @dev Safely transfers `tokenId` token from `from` to `to`.
2079      *
2080      * Requirements:
2081      *
2082      * - `from` cannot be the zero address.
2083      * - `to` cannot be the zero address.
2084      * - `tokenId` token must exist and be owned by `from`.
2085      * - If the caller is not `from`, it must be approved to move this token
2086      * by either {approve} or {setApprovalForAll}.
2087      * - If `to` refers to a smart contract, it must implement
2088      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2089      *
2090      * Emits a {Transfer} event.
2091      */
2092     function safeTransferFrom(
2093         address from,
2094         address to,
2095         uint256 tokenId,
2096         bytes memory _data
2097     ) public virtual override {
2098         transferFrom(from, to, tokenId);
2099         if (to.code.length != 0)
2100             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2101                 revert TransferToNonERC721ReceiverImplementer();
2102             }
2103     }
2104 
2105     /**
2106      * @dev Hook that is called before a set of serially-ordered token IDs
2107      * are about to be transferred. This includes minting.
2108      * And also called before burning one token.
2109      *
2110      * `startTokenId` - the first token ID to be transferred.
2111      * `quantity` - the amount to be transferred.
2112      *
2113      * Calling conditions:
2114      *
2115      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2116      * transferred to `to`.
2117      * - When `from` is zero, `tokenId` will be minted for `to`.
2118      * - When `to` is zero, `tokenId` will be burned by `from`.
2119      * - `from` and `to` are never both zero.
2120      */
2121     function _beforeTokenTransfers(
2122         address from,
2123         address to,
2124         uint256 startTokenId,
2125         uint256 quantity
2126     ) internal virtual {}
2127 
2128     /**
2129      * @dev Hook that is called after a set of serially-ordered token IDs
2130      * have been transferred. This includes minting.
2131      * And also called after one token has been burned.
2132      *
2133      * `startTokenId` - the first token ID to be transferred.
2134      * `quantity` - the amount to be transferred.
2135      *
2136      * Calling conditions:
2137      *
2138      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2139      * transferred to `to`.
2140      * - When `from` is zero, `tokenId` has been minted for `to`.
2141      * - When `to` is zero, `tokenId` has been burned by `from`.
2142      * - `from` and `to` are never both zero.
2143      */
2144     function _afterTokenTransfers(
2145         address from,
2146         address to,
2147         uint256 startTokenId,
2148         uint256 quantity
2149     ) internal virtual {}
2150 
2151     /**
2152      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2153      *
2154      * `from` - Previous owner of the given token ID.
2155      * `to` - Target address that will receive the token.
2156      * `tokenId` - Token ID to be transferred.
2157      * `_data` - Optional data to send along with the call.
2158      *
2159      * Returns whether the call correctly returned the expected magic value.
2160      */
2161     function _checkContractOnERC721Received(
2162         address from,
2163         address to,
2164         uint256 tokenId,
2165         bytes memory _data
2166     ) private returns (bool) {
2167         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2168             bytes4 retval
2169         ) {
2170             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2171         } catch (bytes memory reason) {
2172             if (reason.length == 0) {
2173                 revert TransferToNonERC721ReceiverImplementer();
2174             } else {
2175                 assembly {
2176                     revert(add(32, reason), mload(reason))
2177                 }
2178             }
2179         }
2180     }
2181 
2182     // =============================================================
2183     //                        MINT OPERATIONS
2184     // =============================================================
2185 
2186     /**
2187      * @dev Mints `quantity` tokens and transfers them to `to`.
2188      *
2189      * Requirements:
2190      *
2191      * - `to` cannot be the zero address.
2192      * - `quantity` must be greater than 0.
2193      *
2194      * Emits a {Transfer} event for each mint.
2195      */
2196     function _mint(address to, uint256 quantity) internal virtual {
2197         uint256 startTokenId = _currentIndex;
2198         if (quantity == 0) revert MintZeroQuantity();
2199 
2200         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2201 
2202         // Overflows are incredibly unrealistic.
2203         // `balance` and `numberMinted` have a maximum limit of 2**64.
2204         // `tokenId` has a maximum limit of 2**256.
2205         unchecked {
2206             // Updates:
2207             // - `balance += quantity`.
2208             // - `numberMinted += quantity`.
2209             //
2210             // We can directly add to the `balance` and `numberMinted`.
2211             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2212 
2213             // Updates:
2214             // - `address` to the owner.
2215             // - `startTimestamp` to the timestamp of minting.
2216             // - `burned` to `false`.
2217             // - `nextInitialized` to `quantity == 1`.
2218             _packedOwnerships[startTokenId] = _packOwnershipData(
2219                 to,
2220                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2221             );
2222 
2223             uint256 toMasked;
2224             uint256 end = startTokenId + quantity;
2225 
2226             // Use assembly to loop and emit the `Transfer` event for gas savings.
2227             assembly {
2228                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2229                 toMasked := and(to, _BITMASK_ADDRESS)
2230                 // Emit the `Transfer` event.
2231                 log4(
2232                     0, // Start of data (0, since no data).
2233                     0, // End of data (0, since no data).
2234                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2235                     0, // `address(0)`.
2236                     toMasked, // `to`.
2237                     startTokenId // `tokenId`.
2238                 )
2239 
2240                 for {
2241                     let tokenId := add(startTokenId, 1)
2242                 } iszero(eq(tokenId, end)) {
2243                     tokenId := add(tokenId, 1)
2244                 } {
2245                     // Emit the `Transfer` event. Similar to above.
2246                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2247                 }
2248             }
2249             if (toMasked == 0) revert MintToZeroAddress();
2250 
2251             _currentIndex = end;
2252         }
2253         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2254     }
2255 
2256     /**
2257      * @dev Mints `quantity` tokens and transfers them to `to`.
2258      *
2259      * This function is intended for efficient minting only during contract creation.
2260      *
2261      * It emits only one {ConsecutiveTransfer} as defined in
2262      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2263      * instead of a sequence of {Transfer} event(s).
2264      *
2265      * Calling this function outside of contract creation WILL make your contract
2266      * non-compliant with the ERC721 standard.
2267      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2268      * {ConsecutiveTransfer} event is only permissible during contract creation.
2269      *
2270      * Requirements:
2271      *
2272      * - `to` cannot be the zero address.
2273      * - `quantity` must be greater than 0.
2274      *
2275      * Emits a {ConsecutiveTransfer} event.
2276      */
2277     function _mintERC2309(address to, uint256 quantity) internal virtual {
2278         uint256 startTokenId = _currentIndex;
2279         if (to == address(0)) revert MintToZeroAddress();
2280         if (quantity == 0) revert MintZeroQuantity();
2281         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2282 
2283         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2284 
2285         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2286         unchecked {
2287             // Updates:
2288             // - `balance += quantity`.
2289             // - `numberMinted += quantity`.
2290             //
2291             // We can directly add to the `balance` and `numberMinted`.
2292             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2293 
2294             // Updates:
2295             // - `address` to the owner.
2296             // - `startTimestamp` to the timestamp of minting.
2297             // - `burned` to `false`.
2298             // - `nextInitialized` to `quantity == 1`.
2299             _packedOwnerships[startTokenId] = _packOwnershipData(
2300                 to,
2301                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2302             );
2303 
2304             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2305 
2306             _currentIndex = startTokenId + quantity;
2307         }
2308         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2309     }
2310 
2311     /**
2312      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2313      *
2314      * Requirements:
2315      *
2316      * - If `to` refers to a smart contract, it must implement
2317      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2318      * - `quantity` must be greater than 0.
2319      *
2320      * See {_mint}.
2321      *
2322      * Emits a {Transfer} event for each mint.
2323      */
2324     function _safeMint(
2325         address to,
2326         uint256 quantity,
2327         bytes memory _data
2328     ) internal virtual {
2329         _mint(to, quantity);
2330 
2331         unchecked {
2332             if (to.code.length != 0) {
2333                 uint256 end = _currentIndex;
2334                 uint256 index = end - quantity;
2335                 do {
2336                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2337                         revert TransferToNonERC721ReceiverImplementer();
2338                     }
2339                 } while (index < end);
2340                 // Reentrancy protection.
2341                 if (_currentIndex != end) revert();
2342             }
2343         }
2344     }
2345 
2346     /**
2347      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2348      */
2349     function _safeMint(address to, uint256 quantity) internal virtual {
2350         _safeMint(to, quantity, '');
2351     }
2352 
2353     // =============================================================
2354     //                        BURN OPERATIONS
2355     // =============================================================
2356 
2357     /**
2358      * @dev Equivalent to `_burn(tokenId, false)`.
2359      */
2360     function _burn(uint256 tokenId) internal virtual {
2361         _burn(tokenId, false);
2362     }
2363 
2364     /**
2365      * @dev Destroys `tokenId`.
2366      * The approval is cleared when the token is burned.
2367      *
2368      * Requirements:
2369      *
2370      * - `tokenId` must exist.
2371      *
2372      * Emits a {Transfer} event.
2373      */
2374     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2375         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2376 
2377         address from = address(uint160(prevOwnershipPacked));
2378 
2379         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2380 
2381         if (approvalCheck) {
2382             // The nested ifs save around 20+ gas over a compound boolean condition.
2383             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2384                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2385         }
2386 
2387         _beforeTokenTransfers(from, address(0), tokenId, 1);
2388 
2389         // Clear approvals from the previous owner.
2390         assembly {
2391             if approvedAddress {
2392                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2393                 sstore(approvedAddressSlot, 0)
2394             }
2395         }
2396 
2397         // Underflow of the sender's balance is impossible because we check for
2398         // ownership above and the recipient's balance can't realistically overflow.
2399         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2400         unchecked {
2401             // Updates:
2402             // - `balance -= 1`.
2403             // - `numberBurned += 1`.
2404             //
2405             // We can directly decrement the balance, and increment the number burned.
2406             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2407             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2408 
2409             // Updates:
2410             // - `address` to the last owner.
2411             // - `startTimestamp` to the timestamp of burning.
2412             // - `burned` to `true`.
2413             // - `nextInitialized` to `true`.
2414             _packedOwnerships[tokenId] = _packOwnershipData(
2415                 from,
2416                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2417             );
2418 
2419             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2420             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2421                 uint256 nextTokenId = tokenId + 1;
2422                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2423                 if (_packedOwnerships[nextTokenId] == 0) {
2424                     // If the next slot is within bounds.
2425                     if (nextTokenId != _currentIndex) {
2426                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2427                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2428                     }
2429                 }
2430             }
2431         }
2432 
2433         emit Transfer(from, address(0), tokenId);
2434         _afterTokenTransfers(from, address(0), tokenId, 1);
2435 
2436         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2437         unchecked {
2438             _burnCounter++;
2439         }
2440     }
2441 
2442     // =============================================================
2443     //                     EXTRA DATA OPERATIONS
2444     // =============================================================
2445 
2446     /**
2447      * @dev Directly sets the extra data for the ownership data `index`.
2448      */
2449     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2450         uint256 packed = _packedOwnerships[index];
2451         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2452         uint256 extraDataCasted;
2453         // Cast `extraData` with assembly to avoid redundant masking.
2454         assembly {
2455             extraDataCasted := extraData
2456         }
2457         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2458         _packedOwnerships[index] = packed;
2459     }
2460 
2461     /**
2462      * @dev Called during each token transfer to set the 24bit `extraData` field.
2463      * Intended to be overridden by the cosumer contract.
2464      *
2465      * `previousExtraData` - the value of `extraData` before transfer.
2466      *
2467      * Calling conditions:
2468      *
2469      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2470      * transferred to `to`.
2471      * - When `from` is zero, `tokenId` will be minted for `to`.
2472      * - When `to` is zero, `tokenId` will be burned by `from`.
2473      * - `from` and `to` are never both zero.
2474      */
2475     function _extraData(
2476         address from,
2477         address to,
2478         uint24 previousExtraData
2479     ) internal view virtual returns (uint24) {}
2480 
2481     /**
2482      * @dev Returns the next extra data for the packed ownership data.
2483      * The returned result is shifted into position.
2484      */
2485     function _nextExtraData(
2486         address from,
2487         address to,
2488         uint256 prevOwnershipPacked
2489     ) private view returns (uint256) {
2490         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2491         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2492     }
2493 
2494     // =============================================================
2495     //                       OTHER OPERATIONS
2496     // =============================================================
2497 
2498     /**
2499      * @dev Returns the message sender (defaults to `msg.sender`).
2500      *
2501      * If you are writing GSN compatible contracts, you need to override this function.
2502      */
2503     function _msgSenderERC721A() internal view virtual returns (address) {
2504         return msg.sender;
2505     }
2506 
2507     /**
2508      * @dev Converts a uint256 to its ASCII string decimal representation.
2509      */
2510     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2511         assembly {
2512             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2513             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
2514             // We will need 1 32-byte word to store the length,
2515             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
2516             str := add(mload(0x40), 0x80)
2517             // Update the free memory pointer to allocate.
2518             mstore(0x40, str)
2519 
2520             // Cache the end of the memory to calculate the length later.
2521             let end := str
2522 
2523             // We write the string from rightmost digit to leftmost digit.
2524             // The following is essentially a do-while loop that also handles the zero case.
2525             // prettier-ignore
2526             for { let temp := value } 1 {} {
2527                 str := sub(str, 1)
2528                 // Write the character to the pointer.
2529                 // The ASCII index of the '0' character is 48.
2530                 mstore8(str, add(48, mod(temp, 10)))
2531                 // Keep dividing `temp` until zero.
2532                 temp := div(temp, 10)
2533                 // prettier-ignore
2534                 if iszero(temp) { break }
2535             }
2536 
2537             let length := sub(end, str)
2538             // Move the pointer 32 bytes leftwards to make room for the length.
2539             str := sub(str, 0x20)
2540             // Store the length.
2541             mstore(str, length)
2542         }
2543     }
2544 }
2545 
2546 // File: contracts/AlactrazSwimTeam_ERC721A.sol
2547 
2548 
2549 
2550 pragma solidity ^0.8.4;
2551 
2552 
2553 
2554 
2555 
2556 
2557 
2558 contract AlcatrazSwimTeam is ERC721A, Ownable, PaymentSplitter, ReentrancyGuard  {
2559 
2560     //metadata
2561     string public hiddenMetadataUri = 'https://arweave.net/8PPPPYgNuciffkTc_V9V5FWXbVnVwQw4pgtFWwmtpRc';
2562     string public uriPrefix = 'https://arweave.net/__ARWEAVE_HASH_/';
2563     string public uriSuffix = '.json';
2564 
2565     // mainMint
2566     uint256 public mainMintStart = 1665687600; // Thu Oct 13 2022 20:00:00 GMT+0100 (British Summer Time)
2567     uint256 public maxMintAmountPerTx = 5;
2568     uint256 public mintRate = 0.02 ether;
2569 
2570     uint256 public currentTokenId = 0;
2571 
2572     uint public totalMints;
2573     bool public paused = false;
2574     bool public revealing = true;
2575     uint public revealTo = 0;
2576     uint16[10001] public ids; // creates ids 0-9999 must be 10001 on final contract
2577     uint16 private index;
2578     mapping(uint256 => uint256) public setIDs;
2579     
2580     // frenList
2581 
2582 
2583     uint256 public frenListMintStart = 1665514800;  // Wed Oct 11 2022 20:00:00 GMT+0100 (British Summer Time)
2584     uint256 public frenListMintEnd = 1666119600;    // Tue Oct 18 2022 20:00:00 GMT+0100 (British Summer Time)
2585     uint public frenListMintLimits = 5;
2586     uint256 public frenListMintRate = 0.015 ether;
2587     bytes32 public frenListMerkleRoot;
2588     mapping(address=>uint) public frenListMinted;
2589     bool public initialised = false;
2590 
2591     // giftList
2592     bytes32 public giftListMerkleRoot;
2593     uint public giftListDefaultMax = 1;
2594     mapping(address=>uint) public giftListMintLimits;
2595     mapping(address=>uint) public giftListMinted;
2596 
2597     //team
2598     uint256 public totalTeamMints;
2599     mapping(address=>uint256) public allocations;
2600 
2601     // burn to earn
2602     bool public burnToEarnActive = false;
2603     uint public burnToEarnRequirement = 1;
2604     uint public burnToEarnNominateRequirement = 1;
2605     
2606 
2607     mapping(uint256=>uint256) public sacrafices; 
2608 
2609     constructor(address[] memory _payees, uint256[] memory _shares,  uint256 totalMintable, uint256 teamMemberAllocation) 
2610         ERC721A("AlcatrazSwimTeam", "AST") 
2611         PaymentSplitter(_payees, _shares) payable 
2612         {
2613             delete ids[0];
2614             
2615             totalTeamMints = _payees.length * teamMemberAllocation;
2616             totalMints = totalMintable-totalTeamMints;
2617             for (uint256 i = 0; i<_shares.length; i++){
2618                 allocations[_payees[i]] = teamMemberAllocation;
2619             }
2620 
2621         }
2622 
2623     // Token & Token URI
2624 
2625     function _startTokenId() internal view virtual override returns (uint256) {
2626         return 1;
2627     }
2628 
2629     function pickRandomUniqueId(uint256 random) private returns (uint256 id) {
2630         uint256 len = ids.length - index++;
2631         require(len > 0, "no ids left");
2632         uint256 randomIndex = random % len;
2633         
2634         id = ids[randomIndex] != 0 ? ids[randomIndex] : randomIndex;
2635         ids[randomIndex] = uint16(ids[len - 1] == 0 ? len - 1 : ids[len - 1]);
2636         ids[len - 1] = 0;
2637         return id;
2638     }
2639 
2640     
2641     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2642         uriPrefix = _uriPrefix;
2643     }
2644 
2645     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2646         uriSuffix = _uriSuffix;
2647     }
2648 
2649       function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2650         hiddenMetadataUri = _hiddenMetadataUri;
2651     }
2652 
2653     
2654     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2655         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2656 
2657         // if revealing is on, 
2658         if (revealing == true && (_tokenId > revealTo)) {
2659          return hiddenMetadataUri;
2660         }
2661         string memory currentBaseURI = uriPrefix;
2662         return bytes(currentBaseURI).length > 0
2663         ? string(abi.encodePacked(currentBaseURI, Strings.toString(setIDs[_tokenId]), uriSuffix))
2664         : '';
2665     }
2666 
2667     // Minting
2668 
2669     function setPeriod(string memory periodType, uint256 _timestamp) public onlyOwner {
2670         if(keccak256(bytes(periodType)) == keccak256(bytes("mainMintStart"))){
2671             require(block.timestamp < mainMintStart, "You can't update mainMintstart once the period has started.");
2672             mainMintStart = _timestamp;
2673         } else if (keccak256(bytes(periodType)) == keccak256(bytes("frenListMintStart"))){
2674             require(block.timestamp < frenListMintStart, "You can't update frenListMintstart once the frenlListMint period started.");
2675             frenListMintStart = _timestamp;
2676         }else if (keccak256(bytes(periodType)) == keccak256(bytes("frenListMintEnd"))){
2677             require(block.timestamp < frenListMintEnd, "You can't update frenListMintEnd once it has passed.");
2678             frenListMintEnd = _timestamp;
2679         }
2680     }
2681 
2682     function setPaused(bool _state) public onlyOwner {
2683         paused = _state;
2684     }
2685 
2686     function setMintRate(uint256 _cost) public onlyOwner {
2687         mintRate = _cost;
2688     }
2689 
2690     function setMaxMintAmountPerTx(uint256 quantity) public onlyOwner {
2691         maxMintAmountPerTx = quantity;
2692     }  
2693 
2694     function setRandomIdsForToken(uint256 quantity) private{
2695         for (uint256 i = 1; i!=quantity+1; i++){
2696             currentTokenId++;
2697             setIDs[currentTokenId] =  pickRandomUniqueId(block.timestamp* block.number-1);
2698         }
2699     }
2700 
2701     function mint(uint256 quantity) external nonReentrant payable {
2702         require(!paused, "Minting is paused!");
2703         require(block.timestamp >= mainMintStart, "The period to mint this card has not started.");
2704         require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2705         require(msg.value >= (mintRate * quantity), "Not enough ether sent");
2706         require(quantity <= maxMintAmountPerTx, "Max Mint Amount Per TX reached");
2707         
2708         // assign random ids
2709         setRandomIdsForToken(quantity);
2710         _mint(msg.sender, quantity);
2711     }
2712 
2713     function teamMint(uint256 quantity) external nonReentrant payable {
2714         require(!paused, "Minting is paused!");
2715         require(block.timestamp >= frenListMintStart, "The period to mint this card has not started.");
2716         // anyone without allocation bounced out here.
2717         require((_nextTokenId()-1) + quantity <= allocations[msg.sender], "Not enough tokens left in your allocation.");
2718         // assign random ids
2719         setRandomIdsForToken(quantity);
2720         allocations[msg.sender] = allocations[msg.sender] - quantity;
2721         totalTeamMints = totalTeamMints - quantity;
2722         _mint(msg.sender, quantity);
2723     }
2724 
2725     function mintForAddress( uint256 quantity, address _reciever) public nonReentrant onlyOwner {
2726         require(block.timestamp >= frenListMintStart, "You can only mintForAddress once the frenList Mint starts.");
2727         require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2728 
2729         // assign random ids
2730         setRandomIdsForToken(quantity);
2731         _safeMint(_reciever, quantity); 
2732     }
2733 
2734     function setRevealState(bool _state) public onlyOwner {
2735         revealing = _state;
2736     }
2737 
2738 
2739     // frenListminting utilising merkeproofs
2740 
2741     function setFrenListMintRate(uint256 _cost) public onlyOwner {
2742         frenListMintRate = _cost;
2743     }
2744 
2745     function setFrenListMintLimits(uint256 _limit) public onlyOwner {
2746         frenListMintLimits = _limit;
2747     }
2748     
2749     function setFrenListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2750         frenListMerkleRoot = merkleRoot;
2751     }
2752     
2753     function setGiftListMerkleRoot(bytes32 merkleRoot) external onlyOwner {
2754         giftListMerkleRoot = merkleRoot;
2755     }
2756 
2757     function frenListMint(bytes32[] calldata merkleProof, uint256 quantity) public nonReentrant
2758         payable
2759         isValidMerkleProof(merkleProof, frenListMerkleRoot) {
2760         require(!paused, "Minting is paused!");
2761         require(block.timestamp >= frenListMintStart, "You can only mint once the frenList Mint starts.");
2762         require(block.timestamp < frenListMintEnd, "You can only mint before the frenList Mint ends.");
2763 
2764         require((frenListMinted[msg.sender]+ quantity) <= frenListMintLimits, "Going over maximum frenList Mints" );
2765         require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2766         require(msg.value >= (frenListMintRate * quantity), "Not enough ether sent");
2767         require(quantity <= maxMintAmountPerTx, "Max Mint Amount Per TX reached");
2768         
2769         // assign random ids
2770         frenListMinted[msg.sender] = frenListMinted[msg.sender]+quantity;
2771         setRandomIdsForToken(quantity);
2772         _mint(msg.sender, quantity);
2773 
2774     }
2775 
2776     function giftListMint(bytes32[] calldata merkleProof, uint256 quantity) public nonReentrant
2777         payable
2778         isValidMerkleProof(merkleProof, giftListMerkleRoot) {
2779         require(!paused, "Minting is paused!");
2780         require(block.timestamp >= frenListMintStart, "You can only mint once the frenList Mint starts.");  
2781         require((_nextTokenId()-1) + quantity <= totalMints, "Not enough tokens left to fulfill mint ammount requested");
2782 
2783          // assign default or override if not set.
2784         if(giftListMinted[msg.sender] == 0){
2785             giftListMintLimits[msg.sender] = giftListMintLimits[msg.sender]==0 ? giftListDefaultMax : giftListMintLimits[msg.sender];
2786         }
2787         // can only mint what youve been granted
2788         require(giftListMinted[msg.sender]+quantity <= giftListMintLimits[msg.sender] ,"Can not exceed max gift mints for this address");
2789         
2790         giftListMinted[msg.sender] = giftListMinted[msg.sender]+quantity;
2791         // assign random ids        
2792         setRandomIdsForToken(quantity);
2793         _mint(msg.sender, quantity);
2794 
2795     }
2796 
2797     function updateGiftLimit(address[] memory addressses, uint[] memory limits) public nonReentrant onlyOwner {
2798         require(addressses.length == limits.length,"adresses and limits must be of equal length");
2799         for (uint256 i = 0; i<addressses.length; i++){
2800             giftListMintLimits[addressses[i]] = limits[i];
2801         }
2802     }
2803 
2804     function release(address payable account) public nonReentrant virtual override {
2805 
2806         require(msg.sender == account,"You can only release funds to your own address");
2807 
2808         super.release(account);
2809     }
2810 
2811     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
2812         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
2813         require(
2814             MerkleProof.verify(
2815                 merkleProof,
2816                 root,
2817                 leaf
2818             ),
2819             "Address is not in the frens list"
2820         );
2821         _;
2822     }
2823 
2824     // Burn To Earn.
2825 
2826     function setBurnToEarnActive(bool _state) public onlyOwner {
2827         burnToEarnActive = _state;
2828     }
2829 
2830     function setBurnToEarnRequirement(uint requirement) public onlyOwner {
2831         require(requirement>0,"Must require at least 1");
2832         burnToEarnRequirement = requirement;
2833     }
2834     
2835     function setBurnToEarnNominateRequirement(uint requirement) public onlyOwner {
2836         burnToEarnNominateRequirement = requirement;
2837     }
2838 
2839 
2840     // function getSetIDs() public view returns (uint[] memory){
2841 
2842     //     uint256 minted =  _nextTokenId()-1;
2843 
2844     //     uint256[] memory ret = new uint256[](minted);
2845     
2846     //     for (uint i = 0; i < minted; i++) {
2847     //         ret[i] = setIDs[i+1];
2848     //     }
2849         
2850     //     return ret;
2851     // }
2852     function getSetIDSlice(uint start, uint end) public view returns (uint[] memory){
2853         require(start!=0,"start of slice must not be 0");
2854         require(end>start,"end  of slice must not be higher than end of slice");
2855         uint256 minted =  _nextTokenId()-1;
2856         require(end<=minted,"end  of slice must be lower than last tokenId");
2857 
2858         uint256[] memory ret = new uint256[]((end-start)+1);
2859     
2860         for (uint i = 0; i < ((end-start)+1); i++) {
2861             ret[i] = setIDs[(i+start)];
2862         }
2863         
2864         return ret;
2865     }
2866 
2867     function getSacraficesSlice(uint start, uint end) public view returns (uint[] memory){
2868         require(start!=0,"start of slice must not be 0");
2869         require(end>start,"start  of slice must not be higher than end of slice");
2870         uint256 minted =  _nextTokenId()-1;
2871         require(end<=minted,"end  of slice must be lower than last tokenId");
2872 
2873         uint256[] memory ret = new uint256[]((end-start)+1);
2874     
2875         for (uint i = 0; i < ((end-start)+1); i++) {
2876             ret[i] = sacrafices[(i+start)];
2877         }
2878         
2879         return ret;
2880     }
2881 
2882     event BurnToEarn(address indexed _from, uint256[] indexed tokenIds,uint256[] indexed nominatedIds,uint256[]  tokenIdsRead,uint256[]  nominatedIdsRead, string reason );
2883 
2884     function burnToEarn(uint256[] memory tokenIds, uint256[] memory nominatedIds, string memory reason) public nonReentrant virtual {
2885         require(burnToEarnActive, "ERC721: 'Burn To Earn' is not yet active");
2886         require((nominatedIds.length >0) && tokenIds.length >0, "ERC721: Must nominate and burn");
2887         require(tokenIds.length >= burnToEarnRequirement ,"ERC721: Must match or exceed burn to earn burn requirement");
2888         require(nominatedIds.length >= burnToEarnNominateRequirement, "ERC721: Must match or exceed burn to earn nomination requirement");
2889         
2890         for (uint256 i = 0; i < tokenIds.length ; i++) { 
2891             require(ownerOf(tokenIds[i]) == msg.sender, "ERC721: caller is not the burn token owner");
2892         }
2893         for (uint256 i = 0; i < nominatedIds.length ; i++) { 
2894             require(ownerOf(nominatedIds[i]) == msg.sender, "ERC721A: caller is not the nominated token owner");
2895         }
2896 
2897         
2898         if((tokenIds.length ==1) && (nominatedIds.length ==1)){
2899             // 'one for one' add one to nominated sacrafices + whatever sacrafices have been received to the burnt token.
2900             sacrafices[nominatedIds[0]] = sacrafices[nominatedIds[0]]+1+sacrafices[tokenIds[0]];
2901             sacrafices[tokenIds[0]] = 0;
2902         } else if((tokenIds.length >1) && (nominatedIds.length ==1)){
2903             // 'many for one' add tokenIds count to  nominateds sacrafices + whatever sacrafices have been received to the burnt tokens.
2904             uint256 totalAdditionalSacrafices;
2905             for (uint256 i = 0; i < tokenIds.length ; i++) { 
2906                 totalAdditionalSacrafices+sacrafices[tokenIds[i]];
2907                 sacrafices[tokenIds[i]] = 0;
2908             }
2909             sacrafices[nominatedIds[0]] = sacrafices[nominatedIds[0]]+tokenIds.length+totalAdditionalSacrafices;
2910         } else if( ((tokenIds.length >1) && (nominatedIds.length >1))){
2911 
2912             if ( (tokenIds.length == nominatedIds.length)){
2913                 // 'many for many and even' add 1 per tokenId to each nominated and add on previous sacrafices 1 for 1
2914                 
2915                 for (uint256 i = 0; i < nominatedIds.length ; i++) { 
2916                     sacrafices[nominatedIds[i]] = sacrafices[nominatedIds[i]]+1 + sacrafices[tokenIds[i]];
2917                     sacrafices[tokenIds[i]] = 0;
2918                 }
2919                 
2920             } else if(tokenIds.length % nominatedIds.length == 0){
2921                 uint multiplier = tokenIds.length/nominatedIds.length;
2922                 for (uint256 i = 0; i < nominatedIds.length ; i++) {
2923                     uint256 sacraficesToCarry;
2924                     for (uint256 indexA = 0; indexA < multiplier ; indexA++) {
2925                         sacraficesToCarry = sacraficesToCarry+ sacrafices[tokenIds[indexA+(i*multiplier)]];
2926                         sacrafices[tokenIds[indexA+(i*multiplier)]] = 0;
2927                     }
2928                     sacrafices[nominatedIds[i]] = sacrafices[nominatedIds[i]]+multiplier+sacraficesToCarry;
2929                 }
2930                
2931             }   else {
2932                 revert("Burns must be even, 'one to one' 'many burns to one', even or evenly divsible bya a mutliplier, like 3 nominations to one burn, 6 noms to two burns, but not uneven like 5 noms to 3 burns");
2933             }
2934         }
2935         else {
2936             revert("Burns must be even, 'one to one' 'many burns to one', even or evenly divsible bya a mutliplier, like 3 nominations to one burn, 6 noms to two burns, but not uneven like 5 noms to 3 burns");
2937         }
2938         for (uint256 i = 0; i < tokenIds.length ; i++) { 
2939             super._burn(tokenIds[i],true);
2940         }
2941         emit BurnToEarn(msg.sender, tokenIds, nominatedIds, tokenIds, nominatedIds, reason);
2942     }
2943 
2944 }