1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity =0.8.17;
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
87 
88 /**
89  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
90  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
91  *
92  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
93  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
94  * need to send a transaction, and thus is not required to hold Ether at all.
95  */
96 interface IERC20Permit {
97     /**
98      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
99      * given ``owner``'s signed approval.
100      *
101      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
102      * ordering also apply here.
103      *
104      * Emits an {Approval} event.
105      *
106      * Requirements:
107      *
108      * - `spender` cannot be the zero address.
109      * - `deadline` must be a timestamp in the future.
110      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
111      * over the EIP712-formatted function arguments.
112      * - the signature must use ``owner``'s current nonce (see {nonces}).
113      *
114      * For more information on the signature format, see the
115      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
116      * section].
117      */
118     function permit(
119         address owner,
120         address spender,
121         uint256 value,
122         uint256 deadline,
123         uint8 v,
124         bytes32 r,
125         bytes32 s
126     ) external;
127 
128     /**
129      * @dev Returns the current nonce for `owner`. This value must be
130      * included whenever a signature is generated for {permit}.
131      *
132      * Every successful call to {permit} increases ``owner``'s nonce by one. This
133      * prevents a signature from being used multiple times.
134      */
135     function nonces(address owner) external view returns (uint256);
136 
137     /**
138      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
139      */
140     // solhint-disable-next-line func-name-mixedcase
141     function DOMAIN_SEPARATOR() external view returns (bytes32);
142 }
143 
144 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
145 
146 /**
147  * @dev Collection of functions related to the address type
148  */
149 library Address {
150     /**
151      * @dev Returns true if `account` is a contract.
152      *
153      * [IMPORTANT]
154      * ====
155      * It is unsafe to assume that an address for which this function returns
156      * false is an externally-owned account (EOA) and not a contract.
157      *
158      * Among others, `isContract` will return false for the following
159      * types of addresses:
160      *
161      *  - an externally-owned account
162      *  - a contract in construction
163      *  - an address where a contract will be created
164      *  - an address where a contract lived, but was destroyed
165      * ====
166      *
167      * [IMPORTANT]
168      * ====
169      * You shouldn't rely on `isContract` to protect against flash loan attacks!
170      *
171      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
172      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
173      * constructor.
174      * ====
175      */
176     function isContract(address account) internal view returns (bool) {
177         // This method relies on extcodesize/address.code.length, which returns 0
178         // for contracts in construction, since the code is only stored at the end
179         // of the constructor execution.
180 
181         return account.code.length > 0;
182     }
183 
184     /**
185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
186      * `recipient`, forwarding all available gas and reverting on errors.
187      *
188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
190      * imposed by `transfer`, making them unable to receive funds via
191      * `transfer`. {sendValue} removes this limitation.
192      *
193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
194      *
195      * IMPORTANT: because control is transferred to `recipient`, care must be
196      * taken to not create reentrancy vulnerabilities. Consider using
197      * {ReentrancyGuard} or the
198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         (bool success, ) = recipient.call{value: amount}("");
204         require(success, "Address: unable to send value, recipient may have reverted");
205     }
206 
207     /**
208      * @dev Performs a Solidity function call using a low level `call`. A
209      * plain `call` is an unsafe replacement for a function call: use this
210      * function instead.
211      *
212      * If `target` reverts with a revert reason, it is bubbled up by this
213      * function (like regular Solidity function calls).
214      *
215      * Returns the raw returned data. To convert to the expected return value,
216      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
217      *
218      * Requirements:
219      *
220      * - `target` must be a contract.
221      * - calling `target` with `data` must not revert.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionCall(target, data, "Address: low-level call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
231      * `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but also transferring `value` wei to `target`.
246      *
247      * Requirements:
248      *
249      * - the calling contract must have an ETH balance of at least `value`.
250      * - the called Solidity function must be `payable`.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
264      * with `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         require(isContract(target), "Address: call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.call{value: value}(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
288         return functionStaticCall(target, data, "Address: low-level static call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal view returns (bytes memory) {
302         require(isContract(target), "Address: static call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(isContract(target), "Address: delegate call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.delegatecall(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
337      * revert reason using the provided one.
338      *
339      * _Available since v4.3._
340      */
341     function verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) internal pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352                 /// @solidity memory-safe-assembly
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 /**
365  * @title SafeERC20
366  * @dev Wrappers around ERC20 operations that throw on failure (when the token
367  * contract returns false). Tokens that return no value (and instead revert or
368  * throw on failure) are also supported, non-reverting calls are assumed to be
369  * successful.
370  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
371  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
372  */
373 library SafeERC20 {
374     using Address for address;
375 
376     function safeTransfer(
377         IERC20 token,
378         address to,
379         uint256 value
380     ) internal {
381         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
382     }
383 
384     function safeTransferFrom(
385         IERC20 token,
386         address from,
387         address to,
388         uint256 value
389     ) internal {
390         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
391     }
392 
393     /**
394      * @dev Deprecated. This function has issues similar to the ones found in
395      * {IERC20-approve}, and its usage is discouraged.
396      *
397      * Whenever possible, use {safeIncreaseAllowance} and
398      * {safeDecreaseAllowance} instead.
399      */
400     function safeApprove(
401         IERC20 token,
402         address spender,
403         uint256 value
404     ) internal {
405         // safeApprove should only be called when setting an initial allowance,
406         // or when resetting it to zero. To increase and decrease it, use
407         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
408         require(
409             (value == 0) || (token.allowance(address(this), spender) == 0),
410             "SafeERC20: approve from non-zero to non-zero allowance"
411         );
412         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
413     }
414 
415     function safeIncreaseAllowance(
416         IERC20 token,
417         address spender,
418         uint256 value
419     ) internal {
420         uint256 newAllowance = token.allowance(address(this), spender) + value;
421         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
422     }
423 
424     function safeDecreaseAllowance(
425         IERC20 token,
426         address spender,
427         uint256 value
428     ) internal {
429         unchecked {
430             uint256 oldAllowance = token.allowance(address(this), spender);
431             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
432             uint256 newAllowance = oldAllowance - value;
433             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434         }
435     }
436 
437     function safePermit(
438         IERC20Permit token,
439         address owner,
440         address spender,
441         uint256 value,
442         uint256 deadline,
443         uint8 v,
444         bytes32 r,
445         bytes32 s
446     ) internal {
447         uint256 nonceBefore = token.nonces(owner);
448         token.permit(owner, spender, value, deadline, v, r, s);
449         uint256 nonceAfter = token.nonces(owner);
450         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
451     }
452 
453     /**
454      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
455      * on the return value: the return value is optional (but if data is returned, it must not be false).
456      * @param token The token targeted by the call.
457      * @param data The call data (encoded using abi.encode or one of its variants).
458      */
459     function _callOptionalReturn(IERC20 token, bytes memory data) private {
460         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
461         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
462         // the target address contains contract code and also asserts for success in the low-level call.
463 
464         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
465         if (returndata.length > 0) {
466             // Return data is optional
467             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
468         }
469     }
470 }
471 
472 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
473 
474 /**
475  * @dev These functions deal with verification of Merkle Tree proofs.
476  *
477  * The proofs can be generated using the JavaScript library
478  * https://github.com/miguelmota/merkletreejs[merkletreejs].
479  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
480  *
481  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
482  *
483  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
484  * hashing, or use a hash function other than keccak256 for hashing leaves.
485  * This is because the concatenation of a sorted pair of internal nodes in
486  * the merkle tree could be reinterpreted as a leaf value.
487  */
488 library MerkleProof {
489     /**
490      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
491      * defined by `root`. For this, a `proof` must be provided, containing
492      * sibling hashes on the branch from the leaf to the root of the tree. Each
493      * pair of leaves and each pair of pre-images are assumed to be sorted.
494      */
495     function verify(
496         bytes32[] memory proof,
497         bytes32 root,
498         bytes32 leaf
499     ) internal pure returns (bool) {
500         return processProof(proof, leaf) == root;
501     }
502 
503     /**
504      * @dev Calldata version of {verify}
505      *
506      * _Available since v4.7._
507      */
508     function verifyCalldata(
509         bytes32[] calldata proof,
510         bytes32 root,
511         bytes32 leaf
512     ) internal pure returns (bool) {
513         return processProofCalldata(proof, leaf) == root;
514     }
515 
516     /**
517      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
518      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
519      * hash matches the root of the tree. When processing the proof, the pairs
520      * of leafs & pre-images are assumed to be sorted.
521      *
522      * _Available since v4.4._
523      */
524     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
525         bytes32 computedHash = leaf;
526         for (uint256 i = 0; i < proof.length; i++) {
527             computedHash = _hashPair(computedHash, proof[i]);
528         }
529         return computedHash;
530     }
531 
532     /**
533      * @dev Calldata version of {processProof}
534      *
535      * _Available since v4.7._
536      */
537     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
538         bytes32 computedHash = leaf;
539         for (uint256 i = 0; i < proof.length; i++) {
540             computedHash = _hashPair(computedHash, proof[i]);
541         }
542         return computedHash;
543     }
544 
545     /**
546      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
547      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
548      *
549      * _Available since v4.7._
550      */
551     function multiProofVerify(
552         bytes32[] memory proof,
553         bool[] memory proofFlags,
554         bytes32 root,
555         bytes32[] memory leaves
556     ) internal pure returns (bool) {
557         return processMultiProof(proof, proofFlags, leaves) == root;
558     }
559 
560     /**
561      * @dev Calldata version of {multiProofVerify}
562      *
563      * _Available since v4.7._
564      */
565     function multiProofVerifyCalldata(
566         bytes32[] calldata proof,
567         bool[] calldata proofFlags,
568         bytes32 root,
569         bytes32[] memory leaves
570     ) internal pure returns (bool) {
571         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
572     }
573 
574     /**
575      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
576      * consuming from one or the other at each step according to the instructions given by
577      * `proofFlags`.
578      *
579      * _Available since v4.7._
580      */
581     function processMultiProof(
582         bytes32[] memory proof,
583         bool[] memory proofFlags,
584         bytes32[] memory leaves
585     ) internal pure returns (bytes32 merkleRoot) {
586         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
587         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
588         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
589         // the merkle tree.
590         uint256 leavesLen = leaves.length;
591         uint256 totalHashes = proofFlags.length;
592 
593         // Check proof validity.
594         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
595 
596         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
597         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
598         bytes32[] memory hashes = new bytes32[](totalHashes);
599         uint256 leafPos = 0;
600         uint256 hashPos = 0;
601         uint256 proofPos = 0;
602         // At each step, we compute the next hash using two values:
603         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
604         //   get the next hash.
605         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
606         //   `proof` array.
607         for (uint256 i = 0; i < totalHashes; i++) {
608             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
609             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
610             hashes[i] = _hashPair(a, b);
611         }
612 
613         if (totalHashes > 0) {
614             return hashes[totalHashes - 1];
615         } else if (leavesLen > 0) {
616             return leaves[0];
617         } else {
618             return proof[0];
619         }
620     }
621 
622     /**
623      * @dev Calldata version of {processMultiProof}
624      *
625      * _Available since v4.7._
626      */
627     function processMultiProofCalldata(
628         bytes32[] calldata proof,
629         bool[] calldata proofFlags,
630         bytes32[] memory leaves
631     ) internal pure returns (bytes32 merkleRoot) {
632         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
633         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
634         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
635         // the merkle tree.
636         uint256 leavesLen = leaves.length;
637         uint256 totalHashes = proofFlags.length;
638 
639         // Check proof validity.
640         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
641 
642         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
643         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
644         bytes32[] memory hashes = new bytes32[](totalHashes);
645         uint256 leafPos = 0;
646         uint256 hashPos = 0;
647         uint256 proofPos = 0;
648         // At each step, we compute the next hash using two values:
649         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
650         //   get the next hash.
651         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
652         //   `proof` array.
653         for (uint256 i = 0; i < totalHashes; i++) {
654             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
655             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
656             hashes[i] = _hashPair(a, b);
657         }
658 
659         if (totalHashes > 0) {
660             return hashes[totalHashes - 1];
661         } else if (leavesLen > 0) {
662             return leaves[0];
663         } else {
664             return proof[0];
665         }
666     }
667 
668     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
669         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
670     }
671 
672     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
673         /// @solidity memory-safe-assembly
674         assembly {
675             mstore(0x00, a)
676             mstore(0x20, b)
677             value := keccak256(0x00, 0x40)
678         }
679     }
680 }
681 
682 // Allows anyone to claim a token if they exist in a merkle root.
683 interface IMerkleDistributor {
684     // Returns the address of the token distributed by this contract.
685     function token() external view returns (address);
686     // Returns the merkle root of the merkle tree containing account balances available to claim.
687     function merkleRoot() external view returns (bytes32);
688     // Returns true if the index has been marked claimed.
689     function isClaimed(uint256 index) external view returns (bool);
690     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
691     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
692 
693     // This event is triggered whenever a call to #claim succeeds.
694     event Claimed(uint256 index, address account, uint256 amount);
695 }
696 
697 error AlreadyClaimed();
698 error InvalidProof();
699 
700 contract MerkleDistributor is IMerkleDistributor {
701     using SafeERC20 for IERC20;
702 
703     address public immutable override token;
704     bytes32 public immutable override merkleRoot;
705 
706     // This is a packed array of booleans.
707     mapping(uint256 => uint256) private claimedBitMap;
708 
709     constructor(address token_, bytes32 merkleRoot_) {
710         token = token_;
711         merkleRoot = merkleRoot_;
712     }
713 
714     function isClaimed(uint256 index) public view override returns (bool) {
715         uint256 claimedWordIndex = index / 256;
716         uint256 claimedBitIndex = index % 256;
717         uint256 claimedWord = claimedBitMap[claimedWordIndex];
718         uint256 mask = (1 << claimedBitIndex);
719         return claimedWord & mask == mask;
720     }
721 
722     function _setClaimed(uint256 index) private {
723         uint256 claimedWordIndex = index / 256;
724         uint256 claimedBitIndex = index % 256;
725         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
726     }
727 
728     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof)
729         public
730         virtual
731         override
732     {
733         if (isClaimed(index)) revert AlreadyClaimed();
734 
735         // Verify the merkle proof.
736         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
737         if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();
738 
739         // Mark it claimed and send the token.
740         _setClaimed(index);
741         IERC20(token).safeTransfer(account, amount);
742 
743         emit Claimed(index, account, amount);
744     }
745 }
746 
747 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
748 
749 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
750 
751 /**
752  * @dev Provides information about the current execution context, including the
753  * sender of the transaction and its data. While these are generally available
754  * via msg.sender and msg.data, they should not be accessed in such a direct
755  * manner, since when dealing with meta-transactions the account sending and
756  * paying for execution may not be the actual sender (as far as an application
757  * is concerned).
758  *
759  * This contract is only required for intermediate, library-like contracts.
760  */
761 abstract contract Context {
762     function _msgSender() internal view virtual returns (address) {
763         return msg.sender;
764     }
765 
766     function _msgData() internal view virtual returns (bytes calldata) {
767         return msg.data;
768     }
769 }
770 
771 /**
772  * @dev Contract module which provides a basic access control mechanism, where
773  * there is an account (an owner) that can be granted exclusive access to
774  * specific functions.
775  *
776  * By default, the owner account will be the one that deploys the contract. This
777  * can later be changed with {transferOwnership}.
778  *
779  * This module is used through inheritance. It will make available the modifier
780  * `onlyOwner`, which can be applied to your functions to restrict their use to
781  * the owner.
782  */
783 abstract contract Ownable is Context {
784     address private _owner;
785 
786     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
787 
788     /**
789      * @dev Initializes the contract setting the deployer as the initial owner.
790      */
791     constructor() {
792         _transferOwnership(_msgSender());
793     }
794 
795     /**
796      * @dev Throws if called by any account other than the owner.
797      */
798     modifier onlyOwner() {
799         _checkOwner();
800         _;
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view virtual returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if the sender is not the owner.
812      */
813     function _checkOwner() internal view virtual {
814         require(owner() == _msgSender(), "Ownable: caller is not the owner");
815     }
816 
817     /**
818      * @dev Leaves the contract without owner. It will not be possible to call
819      * `onlyOwner` functions anymore. Can only be called by the current owner.
820      *
821      * NOTE: Renouncing ownership will leave the contract without an owner,
822      * thereby removing any functionality that is only available to the owner.
823      */
824     function renounceOwnership() public virtual onlyOwner {
825         _transferOwnership(address(0));
826     }
827 
828     /**
829      * @dev Transfers ownership of the contract to a new account (`newOwner`).
830      * Can only be called by the current owner.
831      */
832     function transferOwnership(address newOwner) public virtual onlyOwner {
833         require(newOwner != address(0), "Ownable: new owner is the zero address");
834         _transferOwnership(newOwner);
835     }
836 
837     /**
838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
839      * Internal function without access restriction.
840      */
841     function _transferOwnership(address newOwner) internal virtual {
842         address oldOwner = _owner;
843         _owner = newOwner;
844         emit OwnershipTransferred(oldOwner, newOwner);
845     }
846 }
847 
848 error EndTimeInPast();
849 error ClaimWindowFinished();
850 error NoWithdrawDuringClaim();
851 
852 contract MerkleDistributorWithDeadline is MerkleDistributor, Ownable {
853     using SafeERC20 for IERC20;
854 
855     uint256 public immutable endTime;
856 
857     constructor(address token_, bytes32 merkleRoot_, uint256 endTime_) MerkleDistributor(token_, merkleRoot_) {
858         if (endTime_ <= block.timestamp) revert EndTimeInPast();
859         endTime = endTime_;
860     }
861 
862     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) public override {
863         if (block.timestamp > endTime) revert ClaimWindowFinished();
864         super.claim(index, account, amount, merkleProof);
865     }
866 
867     function withdraw() external onlyOwner {
868         if (block.timestamp < endTime) revert NoWithdrawDuringClaim();
869         IERC20(token).safeTransfer(msg.sender, IERC20(token).balanceOf(address(this)));
870     }
871 }