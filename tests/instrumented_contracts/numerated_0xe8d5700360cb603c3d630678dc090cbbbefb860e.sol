1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity 0.8.17;
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 /**
7  * @dev These functions deal with verification of Merkle Tree proofs.
8  *
9  * The proofs can be generated using the JavaScript library
10  * https://github.com/miguelmota/merkletreejs[merkletreejs].
11  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
12  *
13  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
14  *
15  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
16  * hashing, or use a hash function other than keccak256 for hashing leaves.
17  * This is because the concatenation of a sorted pair of internal nodes in
18  * the merkle tree could be reinterpreted as a leaf value.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Calldata version of {verify}
37      *
38      * _Available since v4.7._
39      */
40     function verifyCalldata(
41         bytes32[] calldata proof,
42         bytes32 root,
43         bytes32 leaf
44     ) internal pure returns (bool) {
45         return processProofCalldata(proof, leaf) == root;
46     }
47 
48     /**
49      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
50      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
51      * hash matches the root of the tree. When processing the proof, the pairs
52      * of leafs & pre-images are assumed to be sorted.
53      *
54      * _Available since v4.4._
55      */
56     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
57         bytes32 computedHash = leaf;
58         for (uint256 i = 0; i < proof.length; i++) {
59             computedHash = _hashPair(computedHash, proof[i]);
60         }
61         return computedHash;
62     }
63 
64     /**
65      * @dev Calldata version of {processProof}
66      *
67      * _Available since v4.7._
68      */
69     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
70         bytes32 computedHash = leaf;
71         for (uint256 i = 0; i < proof.length; i++) {
72             computedHash = _hashPair(computedHash, proof[i]);
73         }
74         return computedHash;
75     }
76 
77     /**
78      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
79      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
80      *
81      * _Available since v4.7._
82      */
83     function multiProofVerify(
84         bytes32[] calldata proof,
85         bool[] calldata proofFlags,
86         bytes32 root,
87         bytes32[] calldata leaves
88     ) internal pure returns (bool) {
89         return processMultiProof(proof, proofFlags, leaves) == root;
90     }
91 
92     /**
93      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
94      * consuming from one or the other at each step according to the instructions given by
95      * `proofFlags`.
96      *
97      * _Available since v4.7._
98      */
99     function processMultiProof(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32[] calldata leaves
103     ) internal pure returns (bytes32 merkleRoot) {
104         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
105         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
106         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
107         // the merkle tree.
108         uint256 leavesLen = leaves.length;
109         uint256 totalHashes = proofFlags.length;
110 
111         // Check proof validity.
112         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
113 
114         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
115         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
116         bytes32[] memory hashes = new bytes32[](totalHashes);
117         uint256 leafPos = 0;
118         uint256 hashPos = 0;
119         uint256 proofPos = 0;
120         // At each step, we compute the next hash using two values:
121         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
122         //   get the next hash.
123         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
124         //   `proof` array.
125         for (uint256 i = 0; i < totalHashes; i++) {
126             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
127             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
128             hashes[i] = _hashPair(a, b);
129         }
130 
131         if (totalHashes > 0) {
132             return hashes[totalHashes - 1];
133         } else if (leavesLen > 0) {
134             return leaves[0];
135         } else {
136             return proof[0];
137         }
138     }
139 
140     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
141         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
142     }
143 
144     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
145         /// @solidity memory-safe-assembly
146         assembly {
147             mstore(0x00, a)
148             mstore(0x20, b)
149             value := keccak256(0x00, 0x40)
150         }
151     }
152 }
153 
154 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
155 
156 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
157 
158 /**
159  * @dev Interface of the ERC20 standard as defined in the EIP.
160  */
161 interface IERC20 {
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `to`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address to, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through {transferFrom}. This is
198      * zero by default.
199      *
200      * This value changes when {approve} or {transferFrom} are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * IMPORTANT: Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `from` to `to` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(
230         address from,
231         address to,
232         uint256 amount
233     ) external returns (bool);
234 }
235 
236 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
237 
238 /**
239  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
240  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
241  *
242  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
243  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
244  * need to send a transaction, and thus is not required to hold Ether at all.
245  */
246 interface IERC20Permit {
247     /**
248      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
249      * given ``owner``'s signed approval.
250      *
251      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
252      * ordering also apply here.
253      *
254      * Emits an {Approval} event.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      * - `deadline` must be a timestamp in the future.
260      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
261      * over the EIP712-formatted function arguments.
262      * - the signature must use ``owner``'s current nonce (see {nonces}).
263      *
264      * For more information on the signature format, see the
265      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
266      * section].
267      */
268     function permit(
269         address owner,
270         address spender,
271         uint256 value,
272         uint256 deadline,
273         uint8 v,
274         bytes32 r,
275         bytes32 s
276     ) external;
277 
278     /**
279      * @dev Returns the current nonce for `owner`. This value must be
280      * included whenever a signature is generated for {permit}.
281      *
282      * Every successful call to {permit} increases ``owner``'s nonce by one. This
283      * prevents a signature from being used multiple times.
284      */
285     function nonces(address owner) external view returns (uint256);
286 
287     /**
288      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
289      */
290     // solhint-disable-next-line func-name-mixedcase
291     function DOMAIN_SEPARATOR() external view returns (bytes32);
292 }
293 
294 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      *
317      * [IMPORTANT]
318      * ====
319      * You shouldn't rely on `isContract` to protect against flash loan attacks!
320      *
321      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
322      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
323      * constructor.
324      * ====
325      */
326     function isContract(address account) internal view returns (bool) {
327         // This method relies on extcodesize/address.code.length, which returns 0
328         // for contracts in construction, since the code is only stored at the end
329         // of the constructor execution.
330 
331         return account.code.length > 0;
332     }
333 
334     /**
335      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
336      * `recipient`, forwarding all available gas and reverting on errors.
337      *
338      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
339      * of certain opcodes, possibly making contracts go over the 2300 gas limit
340      * imposed by `transfer`, making them unable to receive funds via
341      * `transfer`. {sendValue} removes this limitation.
342      *
343      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
344      *
345      * IMPORTANT: because control is transferred to `recipient`, care must be
346      * taken to not create reentrancy vulnerabilities. Consider using
347      * {ReentrancyGuard} or the
348      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
349      */
350     function sendValue(address payable recipient, uint256 amount) internal {
351         require(address(this).balance >= amount, "Address: insufficient balance");
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(success, "Address: unable to send value, recipient may have reverted");
355     }
356 
357     /**
358      * @dev Performs a Solidity function call using a low level `call`. A
359      * plain `call` is an unsafe replacement for a function call: use this
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
376         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(address(this).balance >= value, "Address: insufficient balance for call");
425         require(isContract(target), "Address: call to non-contract");
426 
427         (bool success, bytes memory returndata) = target.call{value: value}(data);
428         return verifyCallResult(success, returndata, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
438         return functionStaticCall(target, data, "Address: low-level static call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal view returns (bytes memory) {
452         require(isContract(target), "Address: static call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.staticcall(data);
455         return verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
465         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.delegatecall(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
487      * revert reason using the provided one.
488      *
489      * _Available since v4.3._
490      */
491     function verifyCallResult(
492         bool success,
493         bytes memory returndata,
494         string memory errorMessage
495     ) internal pure returns (bytes memory) {
496         if (success) {
497             return returndata;
498         } else {
499             // Look for revert reason and bubble it up if present
500             if (returndata.length > 0) {
501                 // The easiest way to bubble the revert reason is using memory via assembly
502                 /// @solidity memory-safe-assembly
503                 assembly {
504                     let returndata_size := mload(returndata)
505                     revert(add(32, returndata), returndata_size)
506                 }
507             } else {
508                 revert(errorMessage);
509             }
510         }
511     }
512 }
513 
514 /**
515  * @title SafeERC20
516  * @dev Wrappers around ERC20 operations that throw on failure (when the token
517  * contract returns false). Tokens that return no value (and instead revert or
518  * throw on failure) are also supported, non-reverting calls are assumed to be
519  * successful.
520  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
521  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
522  */
523 library SafeERC20 {
524     using Address for address;
525 
526     function safeTransfer(
527         IERC20 token,
528         address to,
529         uint256 value
530     ) internal {
531         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
532     }
533 
534     function safeTransferFrom(
535         IERC20 token,
536         address from,
537         address to,
538         uint256 value
539     ) internal {
540         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
541     }
542 
543     /**
544      * @dev Deprecated. This function has issues similar to the ones found in
545      * {IERC20-approve}, and its usage is discouraged.
546      *
547      * Whenever possible, use {safeIncreaseAllowance} and
548      * {safeDecreaseAllowance} instead.
549      */
550     function safeApprove(
551         IERC20 token,
552         address spender,
553         uint256 value
554     ) internal {
555         // safeApprove should only be called when setting an initial allowance,
556         // or when resetting it to zero. To increase and decrease it, use
557         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
558         require(
559             (value == 0) || (token.allowance(address(this), spender) == 0),
560             "SafeERC20: approve from non-zero to non-zero allowance"
561         );
562         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
563     }
564 
565     function safeIncreaseAllowance(
566         IERC20 token,
567         address spender,
568         uint256 value
569     ) internal {
570         uint256 newAllowance = token.allowance(address(this), spender) + value;
571         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
572     }
573 
574     function safeDecreaseAllowance(
575         IERC20 token,
576         address spender,
577         uint256 value
578     ) internal {
579         unchecked {
580             uint256 oldAllowance = token.allowance(address(this), spender);
581             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
582             uint256 newAllowance = oldAllowance - value;
583             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
584         }
585     }
586 
587     function safePermit(
588         IERC20Permit token,
589         address owner,
590         address spender,
591         uint256 value,
592         uint256 deadline,
593         uint8 v,
594         bytes32 r,
595         bytes32 s
596     ) internal {
597         uint256 nonceBefore = token.nonces(owner);
598         token.permit(owner, spender, value, deadline, v, r, s);
599         uint256 nonceAfter = token.nonces(owner);
600         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
601     }
602 
603     /**
604      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
605      * on the return value: the return value is optional (but if data is returned, it must not be false).
606      * @param token The token targeted by the call.
607      * @param data The call data (encoded using abi.encode or one of its variants).
608      */
609     function _callOptionalReturn(IERC20 token, bytes memory data) private {
610         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
611         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
612         // the target address contains contract code and also asserts for success in the low-level call.
613 
614         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
615         if (returndata.length > 0) {
616             // Return data is optional
617             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
618         }
619     }
620 }
621 
622 // OpenZeppelin Contracts (last updated v4.5.0) (utils/math/Math.sol)
623 
624 /**
625  * @dev Standard math utilities missing in the Solidity language.
626  */
627 library Math {
628     enum Rounding {
629         Down, // Toward negative infinity
630         Up, // Toward infinity
631         Zero // Toward zero
632     }
633 
634     /**
635      * @dev Returns the largest of two numbers.
636      */
637     function max(uint256 a, uint256 b) internal pure returns (uint256) {
638         return a >= b ? a : b;
639     }
640 
641     /**
642      * @dev Returns the smallest of two numbers.
643      */
644     function min(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a < b ? a : b;
646     }
647 
648     /**
649      * @dev Returns the average of two numbers. The result is rounded towards
650      * zero.
651      */
652     function average(uint256 a, uint256 b) internal pure returns (uint256) {
653         // (a + b) / 2 can overflow.
654         return (a & b) + (a ^ b) / 2;
655     }
656 
657     /**
658      * @dev Returns the ceiling of the division of two numbers.
659      *
660      * This differs from standard division with `/` in that it rounds up instead
661      * of rounding down.
662      */
663     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
664         // (a + b - 1) / b can overflow on addition, so we distribute.
665         return a == 0 ? 0 : (a - 1) / b + 1;
666     }
667 
668     /**
669      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
670      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
671      * with further edits by Uniswap Labs also under MIT license.
672      */
673     function mulDiv(
674         uint256 x,
675         uint256 y,
676         uint256 denominator
677     ) internal pure returns (uint256 result) {
678         unchecked {
679             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
680             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
681             // variables such that product = prod1 * 2^256 + prod0.
682             uint256 prod0; // Least significant 256 bits of the product
683             uint256 prod1; // Most significant 256 bits of the product
684             assembly {
685                 let mm := mulmod(x, y, not(0))
686                 prod0 := mul(x, y)
687                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
688             }
689 
690             // Handle non-overflow cases, 256 by 256 division.
691             if (prod1 == 0) {
692                 return prod0 / denominator;
693             }
694 
695             // Make sure the result is less than 2^256. Also prevents denominator == 0.
696             require(denominator > prod1);
697 
698             ///////////////////////////////////////////////
699             // 512 by 256 division.
700             ///////////////////////////////////////////////
701 
702             // Make division exact by subtracting the remainder from [prod1 prod0].
703             uint256 remainder;
704             assembly {
705                 // Compute remainder using mulmod.
706                 remainder := mulmod(x, y, denominator)
707 
708                 // Subtract 256 bit number from 512 bit number.
709                 prod1 := sub(prod1, gt(remainder, prod0))
710                 prod0 := sub(prod0, remainder)
711             }
712 
713             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
714             // See https://cs.stackexchange.com/q/138556/92363.
715 
716             // Does not overflow because the denominator cannot be zero at this stage in the function.
717             uint256 twos = denominator & (~denominator + 1);
718             assembly {
719                 // Divide denominator by twos.
720                 denominator := div(denominator, twos)
721 
722                 // Divide [prod1 prod0] by twos.
723                 prod0 := div(prod0, twos)
724 
725                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
726                 twos := add(div(sub(0, twos), twos), 1)
727             }
728 
729             // Shift in bits from prod1 into prod0.
730             prod0 |= prod1 * twos;
731 
732             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
733             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
734             // four bits. That is, denominator * inv = 1 mod 2^4.
735             uint256 inverse = (3 * denominator) ^ 2;
736 
737             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
738             // in modular arithmetic, doubling the correct bits in each step.
739             inverse *= 2 - denominator * inverse; // inverse mod 2^8
740             inverse *= 2 - denominator * inverse; // inverse mod 2^16
741             inverse *= 2 - denominator * inverse; // inverse mod 2^32
742             inverse *= 2 - denominator * inverse; // inverse mod 2^64
743             inverse *= 2 - denominator * inverse; // inverse mod 2^128
744             inverse *= 2 - denominator * inverse; // inverse mod 2^256
745 
746             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
747             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
748             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
749             // is no longer required.
750             result = prod0 * inverse;
751             return result;
752         }
753     }
754 
755     /**
756      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
757      */
758     function mulDiv(
759         uint256 x,
760         uint256 y,
761         uint256 denominator,
762         Rounding rounding
763     ) internal pure returns (uint256) {
764         uint256 result = mulDiv(x, y, denominator);
765         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
766             result += 1;
767         }
768         return result;
769     }
770 
771     /**
772      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
773      *
774      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
775      */
776     function sqrt(uint256 a) internal pure returns (uint256) {
777         if (a == 0) {
778             return 0;
779         }
780 
781         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
782         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
783         // `msb(a) <= a < 2*msb(a)`.
784         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
785         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
786         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
787         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
788         uint256 result = 1;
789         uint256 x = a;
790         if (x >> 128 > 0) {
791             x >>= 128;
792             result <<= 64;
793         }
794         if (x >> 64 > 0) {
795             x >>= 64;
796             result <<= 32;
797         }
798         if (x >> 32 > 0) {
799             x >>= 32;
800             result <<= 16;
801         }
802         if (x >> 16 > 0) {
803             x >>= 16;
804             result <<= 8;
805         }
806         if (x >> 8 > 0) {
807             x >>= 8;
808             result <<= 4;
809         }
810         if (x >> 4 > 0) {
811             x >>= 4;
812             result <<= 2;
813         }
814         if (x >> 2 > 0) {
815             result <<= 1;
816         }
817 
818         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
819         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
820         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
821         // into the expected uint128 result.
822         unchecked {
823             result = (result + a / result) >> 1;
824             result = (result + a / result) >> 1;
825             result = (result + a / result) >> 1;
826             result = (result + a / result) >> 1;
827             result = (result + a / result) >> 1;
828             result = (result + a / result) >> 1;
829             result = (result + a / result) >> 1;
830             return min(result, a / result);
831         }
832     }
833 
834     /**
835      * @notice Calculates sqrt(a), following the selected rounding direction.
836      */
837     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
838         uint256 result = sqrt(a);
839         if (rounding == Rounding.Up && result * result < a) {
840             result += 1;
841         }
842         return result;
843     }
844 }
845 
846 // OpenZeppelin Contracts v4.4.1 (utils/structs/BitMaps.sol)
847 
848 /**
849  * @dev Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential.
850  * Largelly inspired by Uniswap's https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol[merkle-distributor].
851  */
852 library BitMaps {
853     struct BitMap {
854         mapping(uint256 => uint256) _data;
855     }
856 
857     /**
858      * @dev Returns whether the bit at `index` is set.
859      */
860     function get(BitMap storage bitmap, uint256 index) internal view returns (bool) {
861         uint256 bucket = index >> 8;
862         uint256 mask = 1 << (index & 0xff);
863         return bitmap._data[bucket] & mask != 0;
864     }
865 
866     /**
867      * @dev Sets the bit at `index` to the boolean `value`.
868      */
869     function setTo(
870         BitMap storage bitmap,
871         uint256 index,
872         bool value
873     ) internal {
874         if (value) {
875             set(bitmap, index);
876         } else {
877             unset(bitmap, index);
878         }
879     }
880 
881     /**
882      * @dev Sets the bit at `index`.
883      */
884     function set(BitMap storage bitmap, uint256 index) internal {
885         uint256 bucket = index >> 8;
886         uint256 mask = 1 << (index & 0xff);
887         bitmap._data[bucket] |= mask;
888     }
889 
890     /**
891      * @dev Unsets the bit at `index`.
892      */
893     function unset(BitMap storage bitmap, uint256 index) internal {
894         uint256 bucket = index >> 8;
895         uint256 mask = 1 << (index & 0xff);
896         bitmap._data[bucket] &= ~mask;
897     }
898 }
899 
900 contract Vesting {
901     using BitMaps for BitMaps.BitMap;
902     using SafeERC20 for IERC20;
903 
904     address public immutable token;
905     bytes32 public immutable merkleRoot;
906     uint256 public constant MAX_PERCENTAGE = 1e4;
907 
908     address public owner;
909 
910     mapping(uint256 => uint256) public claimed;
911     BitMaps.BitMap private _revokedBitmap;
912 
913     error InvalidProof();
914     error NothingToClaim();
915     error InvalidDates();
916     error EmptyMerkleRoot();
917     error OnlyOwner();
918     error AlreadyRevoked();
919     error ZeroAddress();
920     error CantRevokeEndedVesting();
921     error UnrevocableVesting();
922     error ClaimAmountGtClaimable();
923     error Revoked();
924 
925     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
926     event Claim(address indexed account, uint256 amount);
927     event VestingRevoked(address indexed account, uint256 amountUnvested);
928 
929     constructor(
930         address _token,
931         bytes32 _merkleRoot,
932         address _owner
933     ) {
934         if (_merkleRoot == "") revert EmptyMerkleRoot();
935 
936         token = _token;
937         merkleRoot = _merkleRoot;
938 
939         owner = _owner;
940     }
941 
942     modifier onlyOwner() {
943         if (msg.sender != owner) revert OnlyOwner();
944         _;
945     }
946 
947     function claim(
948         uint256 index,
949         address account,
950         uint256 amount,
951         bool revocable,
952         uint256 start,
953         uint256 end,
954         uint256 cadence,
955         uint256 percentageOnStart,
956         bytes32[] calldata merkleProof,
957         uint256 claimAmount
958     ) public {
959         bytes32 node = keccak256(
960             abi.encodePacked(index, account, amount, revocable, start, end, cadence, percentageOnStart)
961         );
962         if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();
963 
964         if (getRevoked(index)) revert Revoked();
965 
966         uint256 claimable = getClaimable(index, amount, start, end, cadence, percentageOnStart);
967 
968         if (claimable == 0) revert NothingToClaim();
969         if (claimAmount > claimable) revert ClaimAmountGtClaimable();
970 
971         claimed[index] += claimAmount;
972 
973         IERC20(token).safeTransfer(account, claimAmount);
974 
975         emit Claim(account, claimAmount);
976     }
977 
978     function stopVesting(
979         uint256 index,
980         address account,
981         uint256 amount,
982         bool revocable,
983         uint256 start,
984         uint256 end,
985         uint256 cadence,
986         uint256 percentageOnStart,
987         bytes32[] calldata merkleProof
988     ) external onlyOwner {
989         bytes32 node = keccak256(
990             abi.encodePacked(index, account, amount, revocable, start, end, cadence, percentageOnStart)
991         );
992         if (!MerkleProof.verify(merkleProof, merkleRoot, node)) revert InvalidProof();
993 
994         if (!revocable) revert UnrevocableVesting();
995 
996         if (getRevoked(index)) revert AlreadyRevoked();
997 
998         if (block.timestamp >= end) revert CantRevokeEndedVesting();
999 
1000         uint256 claimable = getClaimable(index, amount, start, end, cadence, percentageOnStart);
1001 
1002         setRevoked(index);
1003 
1004         if (claimable != 0) {
1005             IERC20(token).safeTransfer(account, claimable);
1006             emit Claim(account, claimable);
1007         }
1008 
1009         uint256 rest = amount - claimable;
1010 
1011         IERC20(token).safeTransfer(owner, rest);
1012 
1013         emit VestingRevoked(account, rest);
1014     }
1015 
1016     function getClaimable(
1017         uint256 index,
1018         uint256 amount,
1019         uint256 start,
1020         uint256 end,
1021         uint256 cadence,
1022         uint256 percentageOnStart
1023     ) public view returns (uint256) {
1024         if (block.timestamp < start) return 0;
1025         if (block.timestamp > end) return amount - claimed[index];
1026 
1027         uint256 elapsed = ((block.timestamp - start) / cadence) * cadence;
1028 
1029         if (percentageOnStart != 0) {
1030             uint256 claimableOnStart = (percentageOnStart * amount) / MAX_PERCENTAGE;
1031             uint256 claimableRest = (elapsed * (amount - claimableOnStart)) / (end - start);
1032 
1033             return claimableRest + claimableOnStart - claimed[index];
1034         }
1035 
1036         return (elapsed * amount) / (end - start) - claimed[index];
1037     }
1038 
1039     function transferOwnership(address newOwner) public virtual onlyOwner {
1040         if (newOwner == address(0)) revert ZeroAddress();
1041         owner = newOwner;
1042     }
1043 
1044     function getRevoked(uint256 index) public view returns (bool) {
1045         return _revokedBitmap.get(index);
1046     }
1047 
1048     function setRevoked(uint256 index) internal {
1049         _revokedBitmap.set(index);
1050     }
1051 }