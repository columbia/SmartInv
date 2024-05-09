1 // SPDX-License-Identifier: AGPL-3.0-only AND GPL-3.0-only
2 
3 pragma solidity ^0.8.0;
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
6 
7 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Emitted when `value` tokens are moved from one account (`from`) to
15      * another (`to`).
16      *
17      * Note that `value` may be zero.
18      */
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     /**
22      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
23      * a call to {approve}. `value` is the new allowance.
24      */
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `to`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address to, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `from` to `to` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(
81         address from,
82         address to,
83         uint256 amount
84     ) external returns (bool);
85 }
86 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
88 
89 /**
90  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
91  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
92  *
93  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
94  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
95  * need to send a transaction, and thus is not required to hold Ether at all.
96  */
97 interface IERC20Permit {
98     /**
99      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
100      * given ``owner``'s signed approval.
101      *
102      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
103      * ordering also apply here.
104      *
105      * Emits an {Approval} event.
106      *
107      * Requirements:
108      *
109      * - `spender` cannot be the zero address.
110      * - `deadline` must be a timestamp in the future.
111      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
112      * over the EIP712-formatted function arguments.
113      * - the signature must use ``owner``'s current nonce (see {nonces}).
114      *
115      * For more information on the signature format, see the
116      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
117      * section].
118      */
119     function permit(
120         address owner,
121         address spender,
122         uint256 value,
123         uint256 deadline,
124         uint8 v,
125         bytes32 r,
126         bytes32 s
127     ) external;
128 
129     /**
130      * @dev Returns the current nonce for `owner`. This value must be
131      * included whenever a signature is generated for {permit}.
132      *
133      * Every successful call to {permit} increases ``owner``'s nonce by one. This
134      * prevents a signature from being used multiple times.
135      */
136     function nonces(address owner) external view returns (uint256);
137 
138     /**
139      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
140      */
141     // solhint-disable-next-line func-name-mixedcase
142     function DOMAIN_SEPARATOR() external view returns (bytes32);
143 }
144 
145 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
146 
147 /**
148  * @dev Collection of functions related to the address type
149  */
150 library Address {
151     /**
152      * @dev Returns true if `account` is a contract.
153      *
154      * [IMPORTANT]
155      * ====
156      * It is unsafe to assume that an address for which this function returns
157      * false is an externally-owned account (EOA) and not a contract.
158      *
159      * Among others, `isContract` will return false for the following
160      * types of addresses:
161      *
162      *  - an externally-owned account
163      *  - a contract in construction
164      *  - an address where a contract will be created
165      *  - an address where a contract lived, but was destroyed
166      * ====
167      *
168      * [IMPORTANT]
169      * ====
170      * You shouldn't rely on `isContract` to protect against flash loan attacks!
171      *
172      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
173      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
174      * constructor.
175      * ====
176      */
177     function isContract(address account) internal view returns (bool) {
178         // This method relies on extcodesize/address.code.length, which returns 0
179         // for contracts in construction, since the code is only stored at the end
180         // of the constructor execution.
181 
182         return account.code.length > 0;
183     }
184 
185     /**
186      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
187      * `recipient`, forwarding all available gas and reverting on errors.
188      *
189      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
190      * of certain opcodes, possibly making contracts go over the 2300 gas limit
191      * imposed by `transfer`, making them unable to receive funds via
192      * `transfer`. {sendValue} removes this limitation.
193      *
194      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
195      *
196      * IMPORTANT: because control is transferred to `recipient`, care must be
197      * taken to not create reentrancy vulnerabilities. Consider using
198      * {ReentrancyGuard} or the
199      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
200      */
201     function sendValue(address payable recipient, uint256 amount) internal {
202         require(address(this).balance >= amount, "Address: insufficient balance");
203 
204         (bool success, ) = recipient.call{value: amount}("");
205         require(success, "Address: unable to send value, recipient may have reverted");
206     }
207 
208     /**
209      * @dev Performs a Solidity function call using a low level `call`. A
210      * plain `call` is an unsafe replacement for a function call: use this
211      * function instead.
212      *
213      * If `target` reverts with a revert reason, it is bubbled up by this
214      * function (like regular Solidity function calls).
215      *
216      * Returns the raw returned data. To convert to the expected return value,
217      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
218      *
219      * Requirements:
220      *
221      * - `target` must be a contract.
222      * - calling `target` with `data` must not revert.
223      *
224      * _Available since v3.1._
225      */
226     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
227         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
232      * `errorMessage` as a fallback revert reason when `target` reverts.
233      *
234      * _Available since v3.1._
235      */
236     function functionCall(
237         address target,
238         bytes memory data,
239         string memory errorMessage
240     ) internal returns (bytes memory) {
241         return functionCallWithValue(target, data, 0, errorMessage);
242     }
243 
244     /**
245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
246      * but also transferring `value` wei to `target`.
247      *
248      * Requirements:
249      *
250      * - the calling contract must have an ETH balance of at least `value`.
251      * - the called Solidity function must be `payable`.
252      *
253      * _Available since v3.1._
254      */
255     function functionCallWithValue(
256         address target,
257         bytes memory data,
258         uint256 value
259     ) internal returns (bytes memory) {
260         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
261     }
262 
263     /**
264      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
265      * with `errorMessage` as a fallback revert reason when `target` reverts.
266      *
267      * _Available since v3.1._
268      */
269     function functionCallWithValue(
270         address target,
271         bytes memory data,
272         uint256 value,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         require(address(this).balance >= value, "Address: insufficient balance for call");
276         (bool success, bytes memory returndata) = target.call{value: value}(data);
277         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but performing a static call.
283      *
284      * _Available since v3.3._
285      */
286     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
287         return functionStaticCall(target, data, "Address: low-level static call failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
292      * but performing a static call.
293      *
294      * _Available since v3.3._
295      */
296     function functionStaticCall(
297         address target,
298         bytes memory data,
299         string memory errorMessage
300     ) internal view returns (bytes memory) {
301         (bool success, bytes memory returndata) = target.staticcall(data);
302         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
312         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(
322         address target,
323         bytes memory data,
324         string memory errorMessage
325     ) internal returns (bytes memory) {
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
332      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
333      *
334      * _Available since v4.8._
335      */
336     function verifyCallResultFromTarget(
337         address target,
338         bool success,
339         bytes memory returndata,
340         string memory errorMessage
341     ) internal view returns (bytes memory) {
342         if (success) {
343             if (returndata.length == 0) {
344                 // only check isContract if the call was successful and the return data is empty
345                 // otherwise we already know that it was a contract
346                 require(isContract(target), "Address: call to non-contract");
347             }
348             return returndata;
349         } else {
350             _revert(returndata, errorMessage);
351         }
352     }
353 
354     /**
355      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
356      * revert reason or using the provided one.
357      *
358      * _Available since v4.3._
359      */
360     function verifyCallResult(
361         bool success,
362         bytes memory returndata,
363         string memory errorMessage
364     ) internal pure returns (bytes memory) {
365         if (success) {
366             return returndata;
367         } else {
368             _revert(returndata, errorMessage);
369         }
370     }
371 
372     function _revert(bytes memory returndata, string memory errorMessage) private pure {
373         // Look for revert reason and bubble it up if present
374         if (returndata.length > 0) {
375             // The easiest way to bubble the revert reason is using memory via assembly
376             /// @solidity memory-safe-assembly
377             assembly {
378                 let returndata_size := mload(returndata)
379                 revert(add(32, returndata), returndata_size)
380             }
381         } else {
382             revert(errorMessage);
383         }
384     }
385 }
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure (when the token
390  * contract returns false). Tokens that return no value (and instead revert or
391  * throw on failure) are also supported, non-reverting calls are assumed to be
392  * successful.
393  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using Address for address;
398 
399     function safeTransfer(
400         IERC20 token,
401         address to,
402         uint256 value
403     ) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(
408         IERC20 token,
409         address from,
410         address to,
411         uint256 value
412     ) internal {
413         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
414     }
415 
416     /**
417      * @dev Deprecated. This function has issues similar to the ones found in
418      * {IERC20-approve}, and its usage is discouraged.
419      *
420      * Whenever possible, use {safeIncreaseAllowance} and
421      * {safeDecreaseAllowance} instead.
422      */
423     function safeApprove(
424         IERC20 token,
425         address spender,
426         uint256 value
427     ) internal {
428         // safeApprove should only be called when setting an initial allowance,
429         // or when resetting it to zero. To increase and decrease it, use
430         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
431         require(
432             (value == 0) || (token.allowance(address(this), spender) == 0),
433             "SafeERC20: approve from non-zero to non-zero allowance"
434         );
435         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
436     }
437 
438     function safeIncreaseAllowance(
439         IERC20 token,
440         address spender,
441         uint256 value
442     ) internal {
443         uint256 newAllowance = token.allowance(address(this), spender) + value;
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
445     }
446 
447     function safeDecreaseAllowance(
448         IERC20 token,
449         address spender,
450         uint256 value
451     ) internal {
452         unchecked {
453             uint256 oldAllowance = token.allowance(address(this), spender);
454             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
455             uint256 newAllowance = oldAllowance - value;
456             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457         }
458     }
459 
460     function safePermit(
461         IERC20Permit token,
462         address owner,
463         address spender,
464         uint256 value,
465         uint256 deadline,
466         uint8 v,
467         bytes32 r,
468         bytes32 s
469     ) internal {
470         uint256 nonceBefore = token.nonces(owner);
471         token.permit(owner, spender, value, deadline, v, r, s);
472         uint256 nonceAfter = token.nonces(owner);
473         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
474     }
475 
476     /**
477      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
478      * on the return value: the return value is optional (but if data is returned, it must not be false).
479      * @param token The token targeted by the call.
480      * @param data The call data (encoded using abi.encode or one of its variants).
481      */
482     function _callOptionalReturn(IERC20 token, bytes memory data) private {
483         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
484         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
485         // the target address contains contract code and also asserts for success in the low-level call.
486 
487         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
488         if (returndata.length > 0) {
489             // Return data is optional
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
496 
497 /**
498  * @dev These functions deal with verification of Merkle Tree proofs.
499  *
500  * The tree and the proofs can be generated using our
501  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
502  * You will find a quickstart guide in the readme.
503  *
504  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
505  * hashing, or use a hash function other than keccak256 for hashing leaves.
506  * This is because the concatenation of a sorted pair of internal nodes in
507  * the merkle tree could be reinterpreted as a leaf value.
508  * OpenZeppelin's JavaScript library generates merkle trees that are safe
509  * against this attack out of the box.
510  */
511 library MerkleProof {
512     /**
513      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
514      * defined by `root`. For this, a `proof` must be provided, containing
515      * sibling hashes on the branch from the leaf to the root of the tree. Each
516      * pair of leaves and each pair of pre-images are assumed to be sorted.
517      */
518     function verify(
519         bytes32[] memory proof,
520         bytes32 root,
521         bytes32 leaf
522     ) internal pure returns (bool) {
523         return processProof(proof, leaf) == root;
524     }
525 
526     /**
527      * @dev Calldata version of {verify}
528      *
529      * _Available since v4.7._
530      */
531     function verifyCalldata(
532         bytes32[] calldata proof,
533         bytes32 root,
534         bytes32 leaf
535     ) internal pure returns (bool) {
536         return processProofCalldata(proof, leaf) == root;
537     }
538 
539     /**
540      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
541      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
542      * hash matches the root of the tree. When processing the proof, the pairs
543      * of leafs & pre-images are assumed to be sorted.
544      *
545      * _Available since v4.4._
546      */
547     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
548         bytes32 computedHash = leaf;
549         for (uint256 i = 0; i < proof.length; i++) {
550             computedHash = _hashPair(computedHash, proof[i]);
551         }
552         return computedHash;
553     }
554 
555     /**
556      * @dev Calldata version of {processProof}
557      *
558      * _Available since v4.7._
559      */
560     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
561         bytes32 computedHash = leaf;
562         for (uint256 i = 0; i < proof.length; i++) {
563             computedHash = _hashPair(computedHash, proof[i]);
564         }
565         return computedHash;
566     }
567 
568     /**
569      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
570      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
571      *
572      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
573      *
574      * _Available since v4.7._
575      */
576     function multiProofVerify(
577         bytes32[] memory proof,
578         bool[] memory proofFlags,
579         bytes32 root,
580         bytes32[] memory leaves
581     ) internal pure returns (bool) {
582         return processMultiProof(proof, proofFlags, leaves) == root;
583     }
584 
585     /**
586      * @dev Calldata version of {multiProofVerify}
587      *
588      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
589      *
590      * _Available since v4.7._
591      */
592     function multiProofVerifyCalldata(
593         bytes32[] calldata proof,
594         bool[] calldata proofFlags,
595         bytes32 root,
596         bytes32[] memory leaves
597     ) internal pure returns (bool) {
598         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
599     }
600 
601     /**
602      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
603      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
604      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
605      * respectively.
606      *
607      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
608      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
609      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
610      *
611      * _Available since v4.7._
612      */
613     function processMultiProof(
614         bytes32[] memory proof,
615         bool[] memory proofFlags,
616         bytes32[] memory leaves
617     ) internal pure returns (bytes32 merkleRoot) {
618         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
619         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
620         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
621         // the merkle tree.
622         uint256 leavesLen = leaves.length;
623         uint256 totalHashes = proofFlags.length;
624 
625         // Check proof validity.
626         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
627 
628         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
629         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
630         bytes32[] memory hashes = new bytes32[](totalHashes);
631         uint256 leafPos = 0;
632         uint256 hashPos = 0;
633         uint256 proofPos = 0;
634         // At each step, we compute the next hash using two values:
635         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
636         //   get the next hash.
637         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
638         //   `proof` array.
639         for (uint256 i = 0; i < totalHashes; i++) {
640             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
641             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
642             hashes[i] = _hashPair(a, b);
643         }
644 
645         if (totalHashes > 0) {
646             return hashes[totalHashes - 1];
647         } else if (leavesLen > 0) {
648             return leaves[0];
649         } else {
650             return proof[0];
651         }
652     }
653 
654     /**
655      * @dev Calldata version of {processMultiProof}.
656      *
657      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
658      *
659      * _Available since v4.7._
660      */
661     function processMultiProofCalldata(
662         bytes32[] calldata proof,
663         bool[] calldata proofFlags,
664         bytes32[] memory leaves
665     ) internal pure returns (bytes32 merkleRoot) {
666         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
667         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
668         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
669         // the merkle tree.
670         uint256 leavesLen = leaves.length;
671         uint256 totalHashes = proofFlags.length;
672 
673         // Check proof validity.
674         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
675 
676         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
677         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
678         bytes32[] memory hashes = new bytes32[](totalHashes);
679         uint256 leafPos = 0;
680         uint256 hashPos = 0;
681         uint256 proofPos = 0;
682         // At each step, we compute the next hash using two values:
683         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
684         //   get the next hash.
685         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
686         //   `proof` array.
687         for (uint256 i = 0; i < totalHashes; i++) {
688             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
689             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
690             hashes[i] = _hashPair(a, b);
691         }
692 
693         if (totalHashes > 0) {
694             return hashes[totalHashes - 1];
695         } else if (leavesLen > 0) {
696             return leaves[0];
697         } else {
698             return proof[0];
699         }
700     }
701 
702     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
703         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
704     }
705 
706     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
707         /// @solidity memory-safe-assembly
708         assembly {
709             mstore(0x00, a)
710             mstore(0x20, b)
711             value := keccak256(0x00, 0x40)
712         }
713     }
714 }
715 
716 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
719 
720 /**
721  * @dev Provides information about the current execution context, including the
722  * sender of the transaction and its data. While these are generally available
723  * via msg.sender and msg.data, they should not be accessed in such a direct
724  * manner, since when dealing with meta-transactions the account sending and
725  * paying for execution may not be the actual sender (as far as an application
726  * is concerned).
727  *
728  * This contract is only required for intermediate, library-like contracts.
729  */
730 abstract contract Context {
731     function _msgSender() internal view virtual returns (address) {
732         return msg.sender;
733     }
734 
735     function _msgData() internal view virtual returns (bytes calldata) {
736         return msg.data;
737     }
738 }
739 
740 /**
741  * @dev Contract module which provides a basic access control mechanism, where
742  * there is an account (an owner) that can be granted exclusive access to
743  * specific functions.
744  *
745  * By default, the owner account will be the one that deploys the contract. This
746  * can later be changed with {transferOwnership}.
747  *
748  * This module is used through inheritance. It will make available the modifier
749  * `onlyOwner`, which can be applied to your functions to restrict their use to
750  * the owner.
751  */
752 abstract contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
756 
757     /**
758      * @dev Initializes the contract setting the deployer as the initial owner.
759      */
760     constructor() {
761         _transferOwnership(_msgSender());
762     }
763 
764     /**
765      * @dev Throws if called by any account other than the owner.
766      */
767     modifier onlyOwner() {
768         _checkOwner();
769         _;
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view virtual returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if the sender is not the owner.
781      */
782     function _checkOwner() internal view virtual {
783         require(owner() == _msgSender(), "Ownable: caller is not the owner");
784     }
785 
786     /**
787      * @dev Leaves the contract without owner. It will not be possible to call
788      * `onlyOwner` functions anymore. Can only be called by the current owner.
789      *
790      * NOTE: Renouncing ownership will leave the contract without an owner,
791      * thereby removing any functionality that is only available to the owner.
792      */
793     function renounceOwnership() public virtual onlyOwner {
794         _transferOwnership(address(0));
795     }
796 
797     /**
798      * @dev Transfers ownership of the contract to a new account (`newOwner`).
799      * Can only be called by the current owner.
800      */
801     function transferOwnership(address newOwner) public virtual onlyOwner {
802         require(newOwner != address(0), "Ownable: new owner is the zero address");
803         _transferOwnership(newOwner);
804     }
805 
806     /**
807      * @dev Transfers ownership of the contract to a new account (`newOwner`).
808      * Internal function without access restriction.
809      */
810     function _transferOwnership(address newOwner) internal virtual {
811         address oldOwner = _owner;
812         _owner = newOwner;
813         emit OwnershipTransferred(oldOwner, newOwner);
814     }
815 }
816 
817 // -> Forked from https://github.com/UMAprotocol/protocol/blob/master/packages/core/contracts/merkle-distributor/implementation/MerkleDistributor.sol
818 
819 /**
820  * @notice Concise list of functions in MerkleDistributor implementation that would be called by
821  * a consuming external contract (such as the Across Protocol's AcceleratingDistributor).
822  */
823 interface IMerkleDistributor {
824     // A Window maps a Merkle root to a reward token address.
825     struct Window {
826         // Merkle root describing the distribution.
827         bytes32 merkleRoot;
828         // Remaining amount of deposited rewards that have not yet been claimed.
829         uint256 remainingAmount;
830         // Currency in which reward is processed.
831         IERC20 rewardToken;
832         // IPFS hash of the merkle tree. Can be used to independently fetch recipient proofs and tree. Note that the canonical
833         // data type for storing an IPFS hash is a multihash which is the concatenation of  <varint hash function code>
834         // <varint digest size in bytes><hash function output>. We opted to store this in a string type to make it easier
835         // for users to query the ipfs data without needing to reconstruct the multihash. to view the IPFS data simply
836         // go to https://cloudflare-ipfs.com/ipfs/<IPFS-HASH>.
837         string ipfsHash;
838     }
839 
840     // Represents an account's claim for `amount` within the Merkle root located at the `windowIndex`.
841     struct Claim {
842         uint256 windowIndex;
843         uint256 amount;
844         uint256 accountIndex; // Used only for bitmap. Assumed to be unique for each claim.
845         address account;
846         bytes32[] merkleProof;
847     }
848 
849     function claim(Claim memory _claim) external;
850 
851     function claimMulti(Claim[] memory claims) external;
852 
853     function getRewardTokenForWindow(uint256 windowIndex) external view returns (address);
854 }
855 
856 // -> Forked from https://github.com/UMAprotocol/protocol/blob/master/packages/core/contracts/merkle-distributor/implementation/MerkleDistributor.sol
857 
858 /**
859  * Inspired by:
860  * - https://github.com/pie-dao/vested-token-migration-app
861  * - https://github.com/Uniswap/merkle-distributor
862  * - https://github.com/balancer-labs/erc20-redeemable
863  *
864  * @title  MerkleDistributor contract.
865  * @notice Allows an owner to distribute any reward ERC20 to claimants according to Merkle roots. The owner can specify
866  *         multiple Merkle roots distributions with customized reward currencies.
867  * @dev    The Merkle trees are not validated in any way, so the system assumes the contract owner behaves honestly.
868  */
869 contract MerkleDistributor is IMerkleDistributor, Ownable {
870     using SafeERC20 for IERC20;
871 
872     // Windows are mapped to arbitrary indices.
873     mapping(uint256 => Window) public merkleWindows;
874 
875     // Index of next created Merkle root.
876     uint256 public nextCreatedIndex;
877 
878     // Track which accounts have claimed for each window index.
879     // Note: uses a packed array of bools for gas optimization on tracking certain claims. Copied from Uniswap's contract.
880     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
881 
882     /**
883      *
884      *                EVENTS
885      *
886      */
887     event Claimed(
888         address indexed caller,
889         uint256 windowIndex,
890         address indexed account,
891         uint256 accountIndex,
892         uint256 amount,
893         address indexed rewardToken
894     );
895     event CreatedWindow(
896         uint256 indexed windowIndex, uint256 rewardsDeposited, address indexed rewardToken, address owner
897     );
898     event WithdrawRewards(address indexed owner, uint256 amount, address indexed currency);
899     event DeleteWindow(uint256 indexed windowIndex, address owner);
900 
901     /**
902      *
903      *      ADMIN FUNCTIONS
904      *
905      */
906 
907     /**
908      * @notice Set merkle root for the next available window index and seed allocations.
909      * @notice Callable only by owner of this contract. Caller must have approved this contract to transfer
910      *      `rewardsToDeposit` amount of `rewardToken` or this call will fail. Importantly, we assume that the
911      *      owner of this contract correctly chooses an amount `rewardsToDeposit` that is sufficient to cover all
912      *      claims within the `merkleRoot`.
913      * @param rewardsToDeposit amount of rewards to deposit to seed this allocation.
914      * @param rewardToken ERC20 reward token.
915      * @param merkleRoot merkle root describing allocation.
916      * @param ipfsHash hash of IPFS object, conveniently stored for clients
917      */
918     function setWindow(uint256 rewardsToDeposit, address rewardToken, bytes32 merkleRoot, string calldata ipfsHash)
919         external
920         onlyOwner
921     {
922         uint256 indexToSet = nextCreatedIndex;
923         nextCreatedIndex = indexToSet + 1;
924 
925         _setWindow(indexToSet, rewardsToDeposit, rewardToken, merkleRoot, ipfsHash);
926     }
927 
928     /**
929      * @notice Delete merkle root at window index.
930      * @dev Callable only by owner. Likely to be followed by a withdrawRewards call to clear contract state.
931      * @param windowIndex merkle root index to delete.
932      */
933     function deleteWindow(uint256 windowIndex) external onlyOwner {
934         delete merkleWindows[windowIndex];
935         emit DeleteWindow(windowIndex, msg.sender);
936     }
937 
938     /**
939      * @notice Emergency method that transfers rewards out of the contract if the contract was configured improperly.
940      * @dev Callable only by owner.
941      * @param rewardCurrency rewards to withdraw from contract.
942      * @param amount amount of rewards to withdraw.
943      */
944     function withdrawRewards(IERC20 rewardCurrency, uint256 amount) external onlyOwner {
945         rewardCurrency.safeTransfer(msg.sender, amount);
946         emit WithdrawRewards(msg.sender, amount, address(rewardCurrency));
947     }
948 
949     /**
950      *
951      *    NON-ADMIN FUNCTIONS
952      *
953      */
954 
955     /**
956      * @notice Batch claims to reduce gas versus individual submitting all claims. Method will fail
957      *         if any individual claims within the batch would fail.
958      * @dev    Optimistically tries to batch together consecutive claims for the same account and same
959      *         reward token to reduce gas. Therefore, the most gas-cost-optimal way to use this method
960      *         is to pass in an array of claims sorted by account and reward currency. It also reverts
961      *         when any of individual `_claim`'s `amount` exceeds `remainingAmount` for its window.
962      * @param claims array of claims to claim.
963      */
964     function claimMulti(Claim[] memory claims) public virtual override {
965         uint256 batchedAmount;
966         uint256 claimCount = claims.length;
967         for (uint256 i = 0; i < claimCount; i++) {
968             Claim memory _claim = claims[i];
969             _verifyAndMarkClaimed(_claim);
970             batchedAmount += _claim.amount;
971 
972             // If the next claim is NOT the same account or the same token (or this claim is the last one),
973             // then disburse the `batchedAmount` to the current claim's account for the current claim's reward token.
974             uint256 nextI = i + 1;
975             IERC20 currentRewardToken = merkleWindows[_claim.windowIndex].rewardToken;
976             if (
977                 nextI == claimCount
978                 // This claim is last claim.
979                 || claims[nextI].account != _claim.account
980                 // Next claim account is different than current one.
981                 || merkleWindows[claims[nextI].windowIndex].rewardToken != currentRewardToken
982             ) {
983                 // Next claim reward token is different than current one.
984 
985                 currentRewardToken.safeTransfer(_claim.account, batchedAmount);
986                 batchedAmount = 0;
987             }
988         }
989     }
990 
991     /**
992      * @notice Claim amount of reward tokens for account, as described by Claim input object.
993      * @dev    If the `_claim`'s `amount`, `accountIndex`, and `account` do not exactly match the
994      *         values stored in the merkle root for the `_claim`'s `windowIndex` this method
995      *         will revert. It also reverts when `_claim`'s `amount` exceeds `remainingAmount` for the window.
996      * @param _claim claim object describing amount, accountIndex, account, window index, and merkle proof.
997      */
998     function claim(Claim memory _claim) public virtual override {
999         _verifyAndMarkClaimed(_claim);
1000         merkleWindows[_claim.windowIndex].rewardToken.safeTransfer(_claim.account, _claim.amount);
1001     }
1002 
1003     /**
1004      * @notice Returns True if the claim for `accountIndex` has already been completed for the Merkle root at
1005      *         `windowIndex`.
1006      * @dev    This method will only work as intended if all `accountIndex`'s are unique for a given `windowIndex`.
1007      *         The onus is on the Owner of this contract to submit only valid Merkle roots.
1008      * @param windowIndex merkle root to check.
1009      * @param accountIndex account index to check within window index.
1010      * @return True if claim has been executed already, False otherwise.
1011      */
1012     function isClaimed(uint256 windowIndex, uint256 accountIndex) public view returns (bool) {
1013         uint256 claimedWordIndex = accountIndex / 256;
1014         uint256 claimedBitIndex = accountIndex % 256;
1015         uint256 claimedWord = claimedBitMap[windowIndex][claimedWordIndex];
1016         uint256 mask = (1 << claimedBitIndex);
1017         return claimedWord & mask == mask;
1018     }
1019 
1020     /**
1021      * @notice Returns rewardToken set by admin for windowIndex.
1022      * @param windowIndex merkle root to check.
1023      * @return address Reward token address
1024      */
1025     function getRewardTokenForWindow(uint256 windowIndex) public view override returns (address) {
1026         return address(merkleWindows[windowIndex].rewardToken);
1027     }
1028 
1029     /**
1030      * @notice Returns True if leaf described by {account, amount, accountIndex} is stored in Merkle root at given
1031      *         window index.
1032      * @param _claim claim object describing amount, accountIndex, account, window index, and merkle proof.
1033      * @return valid True if leaf exists.
1034      */
1035     function verifyClaim(Claim memory _claim) public view returns (bool valid) {
1036         bytes32 leaf = keccak256(abi.encodePacked(_claim.account, _claim.amount, _claim.accountIndex));
1037         return MerkleProof.verify(_claim.merkleProof, merkleWindows[_claim.windowIndex].merkleRoot, leaf);
1038     }
1039 
1040     /**
1041      *
1042      *     PRIVATE FUNCTIONS
1043      *
1044      */
1045 
1046     // Mark claim as completed for `accountIndex` for Merkle root at `windowIndex`.
1047     function _setClaimed(uint256 windowIndex, uint256 accountIndex) private {
1048         uint256 claimedWordIndex = accountIndex / 256;
1049         uint256 claimedBitIndex = accountIndex % 256;
1050         claimedBitMap[windowIndex][claimedWordIndex] =
1051             claimedBitMap[windowIndex][claimedWordIndex] | (1 << claimedBitIndex);
1052     }
1053 
1054     // Store new Merkle root at `windowindex`. Pull `rewardsDeposited` from caller to seed distribution for this root.
1055     function _setWindow(
1056         uint256 windowIndex,
1057         uint256 rewardsDeposited,
1058         address rewardToken,
1059         bytes32 merkleRoot,
1060         string memory ipfsHash
1061     ) private {
1062         Window storage window = merkleWindows[windowIndex];
1063         window.merkleRoot = merkleRoot;
1064         window.remainingAmount = rewardsDeposited;
1065         window.rewardToken = IERC20(rewardToken);
1066         window.ipfsHash = ipfsHash;
1067 
1068         emit CreatedWindow(windowIndex, rewardsDeposited, rewardToken, msg.sender);
1069 
1070         window.rewardToken.safeTransferFrom(msg.sender, address(this), rewardsDeposited);
1071     }
1072 
1073     // Verify claim is valid and mark it as completed in this contract.
1074     function _verifyAndMarkClaimed(Claim memory _claim) internal {
1075         // Check claimed proof against merkle window at given index.
1076         require(verifyClaim(_claim), "Incorrect merkle proof");
1077         // Check the account has not yet claimed for this window.
1078         require(!isClaimed(_claim.windowIndex, _claim.accountIndex), "Account has already claimed for this window");
1079 
1080         // Proof is correct and claim has not occurred yet, mark claimed complete.
1081         _setClaimed(_claim.windowIndex, _claim.accountIndex);
1082         merkleWindows[_claim.windowIndex].remainingAmount -= _claim.amount;
1083         emit Claimed(
1084             msg.sender,
1085             _claim.windowIndex,
1086             _claim.account,
1087             _claim.accountIndex,
1088             _claim.amount,
1089             address(merkleWindows[_claim.windowIndex].rewardToken)
1090             );
1091     }
1092 }