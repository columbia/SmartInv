1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
235  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
236  *
237  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
238  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
239  * need to send a transaction, and thus is not required to hold Ether at all.
240  */
241 interface IERC20Permit {
242     /**
243      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
244      * given ``owner``'s signed approval.
245      *
246      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
247      * ordering also apply here.
248      *
249      * Emits an {Approval} event.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      * - `deadline` must be a timestamp in the future.
255      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
256      * over the EIP712-formatted function arguments.
257      * - the signature must use ``owner``'s current nonce (see {nonces}).
258      *
259      * For more information on the signature format, see the
260      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
261      * section].
262      */
263     function permit(
264         address owner,
265         address spender,
266         uint256 value,
267         uint256 deadline,
268         uint8 v,
269         bytes32 r,
270         bytes32 s
271     ) external;
272 
273     /**
274      * @dev Returns the current nonce for `owner`. This value must be
275      * included whenever a signature is generated for {permit}.
276      *
277      * Every successful call to {permit} increases ``owner``'s nonce by one. This
278      * prevents a signature from being used multiple times.
279      */
280     function nonces(address owner) external view returns (uint256);
281 
282     /**
283      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
284      */
285     // solhint-disable-next-line func-name-mixedcase
286     function DOMAIN_SEPARATOR() external view returns (bytes32);
287 }
288 
289 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
290 
291 
292 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Interface of the ERC20 standard as defined in the EIP.
298  */
299 interface IERC20 {
300     /**
301      * @dev Emitted when `value` tokens are moved from one account (`from`) to
302      * another (`to`).
303      *
304      * Note that `value` may be zero.
305      */
306     event Transfer(address indexed from, address indexed to, uint256 value);
307 
308     /**
309      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
310      * a call to {approve}. `value` is the new allowance.
311      */
312     event Approval(address indexed owner, address indexed spender, uint256 value);
313 
314     /**
315      * @dev Returns the amount of tokens in existence.
316      */
317     function totalSupply() external view returns (uint256);
318 
319     /**
320      * @dev Returns the amount of tokens owned by `account`.
321      */
322     function balanceOf(address account) external view returns (uint256);
323 
324     /**
325      * @dev Moves `amount` tokens from the caller's account to `to`.
326      *
327      * Returns a boolean value indicating whether the operation succeeded.
328      *
329      * Emits a {Transfer} event.
330      */
331     function transfer(address to, uint256 amount) external returns (bool);
332 
333     /**
334      * @dev Returns the remaining number of tokens that `spender` will be
335      * allowed to spend on behalf of `owner` through {transferFrom}. This is
336      * zero by default.
337      *
338      * This value changes when {approve} or {transferFrom} are called.
339      */
340     function allowance(address owner, address spender) external view returns (uint256);
341 
342     /**
343      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
344      *
345      * Returns a boolean value indicating whether the operation succeeded.
346      *
347      * IMPORTANT: Beware that changing an allowance with this method brings the risk
348      * that someone may use both the old and the new allowance by unfortunate
349      * transaction ordering. One possible solution to mitigate this race
350      * condition is to first reduce the spender's allowance to 0 and set the
351      * desired value afterwards:
352      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
353      *
354      * Emits an {Approval} event.
355      */
356     function approve(address spender, uint256 amount) external returns (bool);
357 
358     /**
359      * @dev Moves `amount` tokens from `from` to `to` using the
360      * allowance mechanism. `amount` is then deducted from the caller's
361      * allowance.
362      *
363      * Returns a boolean value indicating whether the operation succeeded.
364      *
365      * Emits a {Transfer} event.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 amount
371     ) external returns (bool);
372 }
373 
374 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
375 
376 
377 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 
382 
383 
384 /**
385  * @title SafeERC20
386  * @dev Wrappers around ERC20 operations that throw on failure (when the token
387  * contract returns false). Tokens that return no value (and instead revert or
388  * throw on failure) are also supported, non-reverting calls are assumed to be
389  * successful.
390  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
391  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
392  */
393 library SafeERC20 {
394     using Address for address;
395 
396     function safeTransfer(
397         IERC20 token,
398         address to,
399         uint256 value
400     ) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
402     }
403 
404     function safeTransferFrom(
405         IERC20 token,
406         address from,
407         address to,
408         uint256 value
409     ) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
411     }
412 
413     /**
414      * @dev Deprecated. This function has issues similar to the ones found in
415      * {IERC20-approve}, and its usage is discouraged.
416      *
417      * Whenever possible, use {safeIncreaseAllowance} and
418      * {safeDecreaseAllowance} instead.
419      */
420     function safeApprove(
421         IERC20 token,
422         address spender,
423         uint256 value
424     ) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         require(
429             (value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(
436         IERC20 token,
437         address spender,
438         uint256 value
439     ) internal {
440         uint256 newAllowance = token.allowance(address(this), spender) + value;
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(
445         IERC20 token,
446         address spender,
447         uint256 value
448     ) internal {
449         unchecked {
450             uint256 oldAllowance = token.allowance(address(this), spender);
451             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
452             uint256 newAllowance = oldAllowance - value;
453             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454         }
455     }
456 
457     function safePermit(
458         IERC20Permit token,
459         address owner,
460         address spender,
461         uint256 value,
462         uint256 deadline,
463         uint8 v,
464         bytes32 r,
465         bytes32 s
466     ) internal {
467         uint256 nonceBefore = token.nonces(owner);
468         token.permit(owner, spender, value, deadline, v, r, s);
469         uint256 nonceAfter = token.nonces(owner);
470         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
471     }
472 
473     /**
474      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
475      * on the return value: the return value is optional (but if data is returned, it must not be false).
476      * @param token The token targeted by the call.
477      * @param data The call data (encoded using abi.encode or one of its variants).
478      */
479     function _callOptionalReturn(IERC20 token, bytes memory data) private {
480         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
481         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
482         // the target address contains contract code and also asserts for success in the low-level call.
483 
484         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
485         if (returndata.length > 0) {
486             // Return data is optional
487             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
488         }
489     }
490 }
491 
492 // File: @openzeppelin/contracts/utils/Strings.sol
493 
494 
495 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
496 
497 pragma solidity ^0.8.0;
498 
499 /**
500  * @dev String operations.
501  */
502 library Strings {
503     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
504     uint8 private constant _ADDRESS_LENGTH = 20;
505 
506     /**
507      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
508      */
509     function toString(uint256 value) internal pure returns (string memory) {
510         // Inspired by OraclizeAPI's implementation - MIT licence
511         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
512 
513         if (value == 0) {
514             return "0";
515         }
516         uint256 temp = value;
517         uint256 digits;
518         while (temp != 0) {
519             digits++;
520             temp /= 10;
521         }
522         bytes memory buffer = new bytes(digits);
523         while (value != 0) {
524             digits -= 1;
525             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
526             value /= 10;
527         }
528         return string(buffer);
529     }
530 
531     /**
532      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
533      */
534     function toHexString(uint256 value) internal pure returns (string memory) {
535         if (value == 0) {
536             return "0x00";
537         }
538         uint256 temp = value;
539         uint256 length = 0;
540         while (temp != 0) {
541             length++;
542             temp >>= 8;
543         }
544         return toHexString(value, length);
545     }
546 
547     /**
548      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
549      */
550     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
551         bytes memory buffer = new bytes(2 * length + 2);
552         buffer[0] = "0";
553         buffer[1] = "x";
554         for (uint256 i = 2 * length + 1; i > 1; --i) {
555             buffer[i] = _HEX_SYMBOLS[value & 0xf];
556             value >>= 4;
557         }
558         require(value == 0, "Strings: hex length insufficient");
559         return string(buffer);
560     }
561 
562     /**
563      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
564      */
565     function toHexString(address addr) internal pure returns (string memory) {
566         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
567     }
568 }
569 
570 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
571 
572 
573 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev These functions deal with verification of Merkle Tree proofs.
579  *
580  * The proofs can be generated using the JavaScript library
581  * https://github.com/miguelmota/merkletreejs[merkletreejs].
582  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
583  *
584  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
585  *
586  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
587  * hashing, or use a hash function other than keccak256 for hashing leaves.
588  * This is because the concatenation of a sorted pair of internal nodes in
589  * the merkle tree could be reinterpreted as a leaf value.
590  */
591 library MerkleProof {
592     /**
593      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
594      * defined by `root`. For this, a `proof` must be provided, containing
595      * sibling hashes on the branch from the leaf to the root of the tree. Each
596      * pair of leaves and each pair of pre-images are assumed to be sorted.
597      */
598     function verify(
599         bytes32[] memory proof,
600         bytes32 root,
601         bytes32 leaf
602     ) internal pure returns (bool) {
603         return processProof(proof, leaf) == root;
604     }
605 
606     /**
607      * @dev Calldata version of {verify}
608      *
609      * _Available since v4.7._
610      */
611     function verifyCalldata(
612         bytes32[] calldata proof,
613         bytes32 root,
614         bytes32 leaf
615     ) internal pure returns (bool) {
616         return processProofCalldata(proof, leaf) == root;
617     }
618 
619     /**
620      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
621      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
622      * hash matches the root of the tree. When processing the proof, the pairs
623      * of leafs & pre-images are assumed to be sorted.
624      *
625      * _Available since v4.4._
626      */
627     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
628         bytes32 computedHash = leaf;
629         for (uint256 i = 0; i < proof.length; i++) {
630             computedHash = _hashPair(computedHash, proof[i]);
631         }
632         return computedHash;
633     }
634 
635     /**
636      * @dev Calldata version of {processProof}
637      *
638      * _Available since v4.7._
639      */
640     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
641         bytes32 computedHash = leaf;
642         for (uint256 i = 0; i < proof.length; i++) {
643             computedHash = _hashPair(computedHash, proof[i]);
644         }
645         return computedHash;
646     }
647 
648     /**
649      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
650      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
651      *
652      * _Available since v4.7._
653      */
654     function multiProofVerify(
655         bytes32[] memory proof,
656         bool[] memory proofFlags,
657         bytes32 root,
658         bytes32[] memory leaves
659     ) internal pure returns (bool) {
660         return processMultiProof(proof, proofFlags, leaves) == root;
661     }
662 
663     /**
664      * @dev Calldata version of {multiProofVerify}
665      *
666      * _Available since v4.7._
667      */
668     function multiProofVerifyCalldata(
669         bytes32[] calldata proof,
670         bool[] calldata proofFlags,
671         bytes32 root,
672         bytes32[] memory leaves
673     ) internal pure returns (bool) {
674         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
675     }
676 
677     /**
678      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
679      * consuming from one or the other at each step according to the instructions given by
680      * `proofFlags`.
681      *
682      * _Available since v4.7._
683      */
684     function processMultiProof(
685         bytes32[] memory proof,
686         bool[] memory proofFlags,
687         bytes32[] memory leaves
688     ) internal pure returns (bytes32 merkleRoot) {
689         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
690         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
691         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
692         // the merkle tree.
693         uint256 leavesLen = leaves.length;
694         uint256 totalHashes = proofFlags.length;
695 
696         // Check proof validity.
697         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
698 
699         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
700         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
701         bytes32[] memory hashes = new bytes32[](totalHashes);
702         uint256 leafPos = 0;
703         uint256 hashPos = 0;
704         uint256 proofPos = 0;
705         // At each step, we compute the next hash using two values:
706         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
707         //   get the next hash.
708         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
709         //   `proof` array.
710         for (uint256 i = 0; i < totalHashes; i++) {
711             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
712             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
713             hashes[i] = _hashPair(a, b);
714         }
715 
716         if (totalHashes > 0) {
717             return hashes[totalHashes - 1];
718         } else if (leavesLen > 0) {
719             return leaves[0];
720         } else {
721             return proof[0];
722         }
723     }
724 
725     /**
726      * @dev Calldata version of {processMultiProof}
727      *
728      * _Available since v4.7._
729      */
730     function processMultiProofCalldata(
731         bytes32[] calldata proof,
732         bool[] calldata proofFlags,
733         bytes32[] memory leaves
734     ) internal pure returns (bytes32 merkleRoot) {
735         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
736         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
737         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
738         // the merkle tree.
739         uint256 leavesLen = leaves.length;
740         uint256 totalHashes = proofFlags.length;
741 
742         // Check proof validity.
743         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
744 
745         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
746         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
747         bytes32[] memory hashes = new bytes32[](totalHashes);
748         uint256 leafPos = 0;
749         uint256 hashPos = 0;
750         uint256 proofPos = 0;
751         // At each step, we compute the next hash using two values:
752         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
753         //   get the next hash.
754         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
755         //   `proof` array.
756         for (uint256 i = 0; i < totalHashes; i++) {
757             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
758             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
759             hashes[i] = _hashPair(a, b);
760         }
761 
762         if (totalHashes > 0) {
763             return hashes[totalHashes - 1];
764         } else if (leavesLen > 0) {
765             return leaves[0];
766         } else {
767             return proof[0];
768         }
769     }
770 
771     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
772         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
773     }
774 
775     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
776         /// @solidity memory-safe-assembly
777         assembly {
778             mstore(0x00, a)
779             mstore(0x20, b)
780             value := keccak256(0x00, 0x40)
781         }
782     }
783 }
784 
785 // File: @openzeppelin/contracts/utils/Context.sol
786 
787 
788 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 /**
793  * @dev Provides information about the current execution context, including the
794  * sender of the transaction and its data. While these are generally available
795  * via msg.sender and msg.data, they should not be accessed in such a direct
796  * manner, since when dealing with meta-transactions the account sending and
797  * paying for execution may not be the actual sender (as far as an application
798  * is concerned).
799  *
800  * This contract is only required for intermediate, library-like contracts.
801  */
802 abstract contract Context {
803     function _msgSender() internal view virtual returns (address) {
804         return msg.sender;
805     }
806 
807     function _msgData() internal view virtual returns (bytes calldata) {
808         return msg.data;
809     }
810 }
811 
812 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
813 
814 
815 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 
820 
821 
822 /**
823  * @title PaymentSplitter
824  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
825  * that the Ether will be split in this way, since it is handled transparently by the contract.
826  *
827  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
828  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
829  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
830  * time of contract deployment and can't be updated thereafter.
831  *
832  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
833  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
834  * function.
835  *
836  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
837  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
838  * to run tests before sending real value to this contract.
839  */
840 contract PaymentSplitter is Context {
841     event PayeeAdded(address account, uint256 shares);
842     event PaymentReleased(address to, uint256 amount);
843     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
844     event PaymentReceived(address from, uint256 amount);
845 
846     uint256 private _totalShares;
847     uint256 private _totalReleased;
848 
849     mapping(address => uint256) private _shares;
850     mapping(address => uint256) private _released;
851     address[] private _payees;
852 
853     mapping(IERC20 => uint256) private _erc20TotalReleased;
854     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
855 
856     /**
857      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
858      * the matching position in the `shares` array.
859      *
860      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
861      * duplicates in `payees`.
862      */
863     constructor(address[] memory payees, uint256[] memory shares_) payable {
864         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
865         require(payees.length > 0, "PaymentSplitter: no payees");
866 
867         for (uint256 i = 0; i < payees.length; i++) {
868             _addPayee(payees[i], shares_[i]);
869         }
870     }
871 
872     /**
873      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
874      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
875      * reliability of the events, and not the actual splitting of Ether.
876      *
877      * To learn more about this see the Solidity documentation for
878      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
879      * functions].
880      */
881     receive() external payable virtual {
882         emit PaymentReceived(_msgSender(), msg.value);
883     }
884 
885     /**
886      * @dev Getter for the total shares held by payees.
887      */
888     function totalShares() public view returns (uint256) {
889         return _totalShares;
890     }
891 
892     /**
893      * @dev Getter for the total amount of Ether already released.
894      */
895     function totalReleased() public view returns (uint256) {
896         return _totalReleased;
897     }
898 
899     /**
900      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
901      * contract.
902      */
903     function totalReleased(IERC20 token) public view returns (uint256) {
904         return _erc20TotalReleased[token];
905     }
906 
907     /**
908      * @dev Getter for the amount of shares held by an account.
909      */
910     function shares(address account) public view returns (uint256) {
911         return _shares[account];
912     }
913 
914     /**
915      * @dev Getter for the amount of Ether already released to a payee.
916      */
917     function released(address account) public view returns (uint256) {
918         return _released[account];
919     }
920 
921     /**
922      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
923      * IERC20 contract.
924      */
925     function released(IERC20 token, address account) public view returns (uint256) {
926         return _erc20Released[token][account];
927     }
928 
929     /**
930      * @dev Getter for the address of the payee number `index`.
931      */
932     function payee(uint256 index) public view returns (address) {
933         return _payees[index];
934     }
935 
936     /**
937      * @dev Getter for the amount of payee's releasable Ether.
938      */
939     function releasable(address account) public view returns (uint256) {
940         uint256 totalReceived = address(this).balance + totalReleased();
941         return _pendingPayment(account, totalReceived, released(account));
942     }
943 
944     /**
945      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
946      * IERC20 contract.
947      */
948     function releasable(IERC20 token, address account) public view returns (uint256) {
949         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
950         return _pendingPayment(account, totalReceived, released(token, account));
951     }
952 
953     /**
954      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
955      * total shares and their previous withdrawals.
956      */
957     function release(address payable account) public virtual {
958         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
959 
960         uint256 payment = releasable(account);
961 
962         require(payment != 0, "PaymentSplitter: account is not due payment");
963 
964         _released[account] += payment;
965         _totalReleased += payment;
966 
967         Address.sendValue(account, payment);
968         emit PaymentReleased(account, payment);
969     }
970 
971     /**
972      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
973      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
974      * contract.
975      */
976     function release(IERC20 token, address account) public virtual {
977         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
978 
979         uint256 payment = releasable(token, account);
980 
981         require(payment != 0, "PaymentSplitter: account is not due payment");
982 
983         _erc20Released[token][account] += payment;
984         _erc20TotalReleased[token] += payment;
985 
986         SafeERC20.safeTransfer(token, account, payment);
987         emit ERC20PaymentReleased(token, account, payment);
988     }
989 
990     /**
991      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
992      * already released amounts.
993      */
994     function _pendingPayment(
995         address account,
996         uint256 totalReceived,
997         uint256 alreadyReleased
998     ) private view returns (uint256) {
999         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1000     }
1001 
1002     /**
1003      * @dev Add a new payee to the contract.
1004      * @param account The address of the payee to add.
1005      * @param shares_ The number of shares owned by the payee.
1006      */
1007     function _addPayee(address account, uint256 shares_) private {
1008         require(account != address(0), "PaymentSplitter: account is the zero address");
1009         require(shares_ > 0, "PaymentSplitter: shares are 0");
1010         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1011 
1012         _payees.push(account);
1013         _shares[account] = shares_;
1014         _totalShares = _totalShares + shares_;
1015         emit PayeeAdded(account, shares_);
1016     }
1017 }
1018 
1019 // File: @openzeppelin/contracts/access/Ownable.sol
1020 
1021 
1022 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 /**
1028  * @dev Contract module which provides a basic access control mechanism, where
1029  * there is an account (an owner) that can be granted exclusive access to
1030  * specific functions.
1031  *
1032  * By default, the owner account will be the one that deploys the contract. This
1033  * can later be changed with {transferOwnership}.
1034  *
1035  * This module is used through inheritance. It will make available the modifier
1036  * `onlyOwner`, which can be applied to your functions to restrict their use to
1037  * the owner.
1038  */
1039 abstract contract Ownable is Context {
1040     address private _owner;
1041 
1042     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1043 
1044     /**
1045      * @dev Initializes the contract setting the deployer as the initial owner.
1046      */
1047     constructor() {
1048         _transferOwnership(_msgSender());
1049     }
1050 
1051     /**
1052      * @dev Throws if called by any account other than the owner.
1053      */
1054     modifier onlyOwner() {
1055         _checkOwner();
1056         _;
1057     }
1058 
1059     /**
1060      * @dev Returns the address of the current owner.
1061      */
1062     function owner() public view virtual returns (address) {
1063         return _owner;
1064     }
1065 
1066     /**
1067      * @dev Throws if the sender is not the owner.
1068      */
1069     function _checkOwner() internal view virtual {
1070         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1071     }
1072 
1073     /**
1074      * @dev Leaves the contract without owner. It will not be possible to call
1075      * `onlyOwner` functions anymore. Can only be called by the current owner.
1076      *
1077      * NOTE: Renouncing ownership will leave the contract without an owner,
1078      * thereby removing any functionality that is only available to the owner.
1079      */
1080     function renounceOwnership() public virtual onlyOwner {
1081         _transferOwnership(address(0));
1082     }
1083 
1084     /**
1085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1086      * Can only be called by the current owner.
1087      */
1088     function transferOwnership(address newOwner) public virtual onlyOwner {
1089         require(newOwner != address(0), "Ownable: new owner is the zero address");
1090         _transferOwnership(newOwner);
1091     }
1092 
1093     /**
1094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1095      * Internal function without access restriction.
1096      */
1097     function _transferOwnership(address newOwner) internal virtual {
1098         address oldOwner = _owner;
1099         _owner = newOwner;
1100         emit OwnershipTransferred(oldOwner, newOwner);
1101     }
1102 }
1103 
1104 // File: erc721a/contracts/IERC721A.sol
1105 
1106 
1107 // ERC721A Contracts v4.2.0
1108 // Creator: Chiru Labs
1109 
1110 pragma solidity ^0.8.4;
1111 
1112 /**
1113  * @dev Interface of ERC721A.
1114  */
1115 interface IERC721A {
1116     /**
1117      * The caller must own the token or be an approved operator.
1118      */
1119     error ApprovalCallerNotOwnerNorApproved();
1120 
1121     /**
1122      * The token does not exist.
1123      */
1124     error ApprovalQueryForNonexistentToken();
1125 
1126     /**
1127      * The caller cannot approve to their own address.
1128      */
1129     error ApproveToCaller();
1130 
1131     /**
1132      * Cannot query the balance for the zero address.
1133      */
1134     error BalanceQueryForZeroAddress();
1135 
1136     /**
1137      * Cannot mint to the zero address.
1138      */
1139     error MintToZeroAddress();
1140 
1141     /**
1142      * The quantity of tokens minted must be more than zero.
1143      */
1144     error MintZeroQuantity();
1145 
1146     /**
1147      * The token does not exist.
1148      */
1149     error OwnerQueryForNonexistentToken();
1150 
1151     /**
1152      * The caller must own the token or be an approved operator.
1153      */
1154     error TransferCallerNotOwnerNorApproved();
1155 
1156     /**
1157      * The token must be owned by `from`.
1158      */
1159     error TransferFromIncorrectOwner();
1160 
1161     /**
1162      * Cannot safely transfer to a contract that does not implement the
1163      * ERC721Receiver interface.
1164      */
1165     error TransferToNonERC721ReceiverImplementer();
1166 
1167     /**
1168      * Cannot transfer to the zero address.
1169      */
1170     error TransferToZeroAddress();
1171 
1172     /**
1173      * The token does not exist.
1174      */
1175     error URIQueryForNonexistentToken();
1176 
1177     /**
1178      * The `quantity` minted with ERC2309 exceeds the safety limit.
1179      */
1180     error MintERC2309QuantityExceedsLimit();
1181 
1182     /**
1183      * The `extraData` cannot be set on an unintialized ownership slot.
1184      */
1185     error OwnershipNotInitializedForExtraData();
1186 
1187     // =============================================================
1188     //                            STRUCTS
1189     // =============================================================
1190 
1191     struct TokenOwnership {
1192         // The address of the owner.
1193         address addr;
1194         // Stores the start time of ownership with minimal overhead for tokenomics.
1195         uint64 startTimestamp;
1196         // Whether the token has been burned.
1197         bool burned;
1198         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1199         uint24 extraData;
1200     }
1201 
1202     // =============================================================
1203     //                         TOKEN COUNTERS
1204     // =============================================================
1205 
1206     /**
1207      * @dev Returns the total number of tokens in existence.
1208      * Burned tokens will reduce the count.
1209      * To get the total number of tokens minted, please see {_totalMinted}.
1210      */
1211     function totalSupply() external view returns (uint256);
1212 
1213     // =============================================================
1214     //                            IERC165
1215     // =============================================================
1216 
1217     /**
1218      * @dev Returns true if this contract implements the interface defined by
1219      * `interfaceId`. See the corresponding
1220      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1221      * to learn more about how these ids are created.
1222      *
1223      * This function call must use less than 30000 gas.
1224      */
1225     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1226 
1227     // =============================================================
1228     //                            IERC721
1229     // =============================================================
1230 
1231     /**
1232      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1233      */
1234     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1235 
1236     /**
1237      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1238      */
1239     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1240 
1241     /**
1242      * @dev Emitted when `owner` enables or disables
1243      * (`approved`) `operator` to manage all of its assets.
1244      */
1245     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1246 
1247     /**
1248      * @dev Returns the number of tokens in `owner`'s account.
1249      */
1250     function balanceOf(address owner) external view returns (uint256 balance);
1251 
1252     /**
1253      * @dev Returns the owner of the `tokenId` token.
1254      *
1255      * Requirements:
1256      *
1257      * - `tokenId` must exist.
1258      */
1259     function ownerOf(uint256 tokenId) external view returns (address owner);
1260 
1261     /**
1262      * @dev Safely transfers `tokenId` token from `from` to `to`,
1263      * checking first that contract recipients are aware of the ERC721 protocol
1264      * to prevent tokens from being forever locked.
1265      *
1266      * Requirements:
1267      *
1268      * - `from` cannot be the zero address.
1269      * - `to` cannot be the zero address.
1270      * - `tokenId` token must exist and be owned by `from`.
1271      * - If the caller is not `from`, it must be have been allowed to move
1272      * this token by either {approve} or {setApprovalForAll}.
1273      * - If `to` refers to a smart contract, it must implement
1274      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1275      *
1276      * Emits a {Transfer} event.
1277      */
1278     function safeTransferFrom(
1279         address from,
1280         address to,
1281         uint256 tokenId,
1282         bytes calldata data
1283     ) external;
1284 
1285     /**
1286      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1287      */
1288     function safeTransferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) external;
1293 
1294     /**
1295      * @dev Transfers `tokenId` from `from` to `to`.
1296      *
1297      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1298      * whenever possible.
1299      *
1300      * Requirements:
1301      *
1302      * - `from` cannot be the zero address.
1303      * - `to` cannot be the zero address.
1304      * - `tokenId` token must be owned by `from`.
1305      * - If the caller is not `from`, it must be approved to move this token
1306      * by either {approve} or {setApprovalForAll}.
1307      *
1308      * Emits a {Transfer} event.
1309      */
1310     function transferFrom(
1311         address from,
1312         address to,
1313         uint256 tokenId
1314     ) external;
1315 
1316     /**
1317      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1318      * The approval is cleared when the token is transferred.
1319      *
1320      * Only a single account can be approved at a time, so approving the
1321      * zero address clears previous approvals.
1322      *
1323      * Requirements:
1324      *
1325      * - The caller must own the token or be an approved operator.
1326      * - `tokenId` must exist.
1327      *
1328      * Emits an {Approval} event.
1329      */
1330     function approve(address to, uint256 tokenId) external;
1331 
1332     /**
1333      * @dev Approve or remove `operator` as an operator for the caller.
1334      * Operators can call {transferFrom} or {safeTransferFrom}
1335      * for any token owned by the caller.
1336      *
1337      * Requirements:
1338      *
1339      * - The `operator` cannot be the caller.
1340      *
1341      * Emits an {ApprovalForAll} event.
1342      */
1343     function setApprovalForAll(address operator, bool _approved) external;
1344 
1345     /**
1346      * @dev Returns the account approved for `tokenId` token.
1347      *
1348      * Requirements:
1349      *
1350      * - `tokenId` must exist.
1351      */
1352     function getApproved(uint256 tokenId) external view returns (address operator);
1353 
1354     /**
1355      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1356      *
1357      * See {setApprovalForAll}.
1358      */
1359     function isApprovedForAll(address owner, address operator) external view returns (bool);
1360 
1361     // =============================================================
1362     //                        IERC721Metadata
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns the token collection name.
1367      */
1368     function name() external view returns (string memory);
1369 
1370     /**
1371      * @dev Returns the token collection symbol.
1372      */
1373     function symbol() external view returns (string memory);
1374 
1375     /**
1376      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1377      */
1378     function tokenURI(uint256 tokenId) external view returns (string memory);
1379 
1380     // =============================================================
1381     //                           IERC2309
1382     // =============================================================
1383 
1384     /**
1385      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1386      * (inclusive) is transferred from `from` to `to`, as defined in the
1387      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1388      *
1389      * See {_mintERC2309} for more details.
1390      */
1391     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1392 }
1393 
1394 // File: erc721a/contracts/ERC721A.sol
1395 
1396 
1397 // ERC721A Contracts v4.2.0
1398 // Creator: Chiru Labs
1399 
1400 pragma solidity ^0.8.4;
1401 
1402 
1403 /**
1404  * @dev Interface of ERC721 token receiver.
1405  */
1406 interface ERC721A__IERC721Receiver {
1407     function onERC721Received(
1408         address operator,
1409         address from,
1410         uint256 tokenId,
1411         bytes calldata data
1412     ) external returns (bytes4);
1413 }
1414 
1415 /**
1416  * @title ERC721A
1417  *
1418  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1419  * Non-Fungible Token Standard, including the Metadata extension.
1420  * Optimized for lower gas during batch mints.
1421  *
1422  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1423  * starting from `_startTokenId()`.
1424  *
1425  * Assumptions:
1426  *
1427  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1428  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1429  */
1430 contract ERC721A is IERC721A {
1431     // Reference type for token approval.
1432     struct TokenApprovalRef {
1433         address value;
1434     }
1435 
1436     // =============================================================
1437     //                           CONSTANTS
1438     // =============================================================
1439 
1440     // Mask of an entry in packed address data.
1441     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1442 
1443     // The bit position of `numberMinted` in packed address data.
1444     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1445 
1446     // The bit position of `numberBurned` in packed address data.
1447     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1448 
1449     // The bit position of `aux` in packed address data.
1450     uint256 private constant _BITPOS_AUX = 192;
1451 
1452     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1453     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1454 
1455     // The bit position of `startTimestamp` in packed ownership.
1456     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1457 
1458     // The bit mask of the `burned` bit in packed ownership.
1459     uint256 private constant _BITMASK_BURNED = 1 << 224;
1460 
1461     // The bit position of the `nextInitialized` bit in packed ownership.
1462     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1463 
1464     // The bit mask of the `nextInitialized` bit in packed ownership.
1465     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1466 
1467     // The bit position of `extraData` in packed ownership.
1468     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1469 
1470     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1471     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1472 
1473     // The mask of the lower 160 bits for addresses.
1474     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1475 
1476     // The maximum `quantity` that can be minted with {_mintERC2309}.
1477     // This limit is to prevent overflows on the address data entries.
1478     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1479     // is required to cause an overflow, which is unrealistic.
1480     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1481 
1482     // The `Transfer` event signature is given by:
1483     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1484     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1485         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1486 
1487     // =============================================================
1488     //                            STORAGE
1489     // =============================================================
1490 
1491     // The next token ID to be minted.
1492     uint256 private _currentIndex;
1493 
1494     // The number of tokens burned.
1495     uint256 private _burnCounter;
1496 
1497     // Token name
1498     string private _name;
1499 
1500     // Token symbol
1501     string private _symbol;
1502 
1503     // Mapping from token ID to ownership details
1504     // An empty struct value does not necessarily mean the token is unowned.
1505     // See {_packedOwnershipOf} implementation for details.
1506     //
1507     // Bits Layout:
1508     // - [0..159]   `addr`
1509     // - [160..223] `startTimestamp`
1510     // - [224]      `burned`
1511     // - [225]      `nextInitialized`
1512     // - [232..255] `extraData`
1513     mapping(uint256 => uint256) private _packedOwnerships;
1514 
1515     // Mapping owner address to address data.
1516     //
1517     // Bits Layout:
1518     // - [0..63]    `balance`
1519     // - [64..127]  `numberMinted`
1520     // - [128..191] `numberBurned`
1521     // - [192..255] `aux`
1522     mapping(address => uint256) private _packedAddressData;
1523 
1524     // Mapping from token ID to approved address.
1525     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1526 
1527     // Mapping from owner to operator approvals
1528     mapping(address => mapping(address => bool)) private _operatorApprovals;
1529 
1530     // =============================================================
1531     //                          CONSTRUCTOR
1532     // =============================================================
1533 
1534     constructor(string memory name_, string memory symbol_) {
1535         _name = name_;
1536         _symbol = symbol_;
1537         _currentIndex = _startTokenId();
1538     }
1539 
1540     // =============================================================
1541     //                   TOKEN COUNTING OPERATIONS
1542     // =============================================================
1543 
1544     /**
1545      * @dev Returns the starting token ID.
1546      * To change the starting token ID, please override this function.
1547      */
1548     function _startTokenId() internal view virtual returns (uint256) {
1549         return 0;
1550     }
1551 
1552     /**
1553      * @dev Returns the next token ID to be minted.
1554      */
1555     function _nextTokenId() internal view virtual returns (uint256) {
1556         return _currentIndex;
1557     }
1558 
1559     /**
1560      * @dev Returns the total number of tokens in existence.
1561      * Burned tokens will reduce the count.
1562      * To get the total number of tokens minted, please see {_totalMinted}.
1563      */
1564     function totalSupply() public view virtual override returns (uint256) {
1565         // Counter underflow is impossible as _burnCounter cannot be incremented
1566         // more than `_currentIndex - _startTokenId()` times.
1567         unchecked {
1568             return _currentIndex - _burnCounter - _startTokenId();
1569         }
1570     }
1571 
1572     /**
1573      * @dev Returns the total amount of tokens minted in the contract.
1574      */
1575     function _totalMinted() internal view virtual returns (uint256) {
1576         // Counter underflow is impossible as `_currentIndex` does not decrement,
1577         // and it is initialized to `_startTokenId()`.
1578         unchecked {
1579             return _currentIndex - _startTokenId();
1580         }
1581     }
1582 
1583     /**
1584      * @dev Returns the total number of tokens burned.
1585      */
1586     function _totalBurned() internal view virtual returns (uint256) {
1587         return _burnCounter;
1588     }
1589 
1590     // =============================================================
1591     //                    ADDRESS DATA OPERATIONS
1592     // =============================================================
1593 
1594     /**
1595      * @dev Returns the number of tokens in `owner`'s account.
1596      */
1597     function balanceOf(address owner) public view virtual override returns (uint256) {
1598         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1599         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1600     }
1601 
1602     /**
1603      * Returns the number of tokens minted by `owner`.
1604      */
1605     function _numberMinted(address owner) internal view returns (uint256) {
1606         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1607     }
1608 
1609     /**
1610      * Returns the number of tokens burned by or on behalf of `owner`.
1611      */
1612     function _numberBurned(address owner) internal view returns (uint256) {
1613         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1614     }
1615 
1616     /**
1617      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1618      */
1619     function _getAux(address owner) internal view returns (uint64) {
1620         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1621     }
1622 
1623     /**
1624      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1625      * If there are multiple variables, please pack them into a uint64.
1626      */
1627     function _setAux(address owner, uint64 aux) internal virtual {
1628         uint256 packed = _packedAddressData[owner];
1629         uint256 auxCasted;
1630         // Cast `aux` with assembly to avoid redundant masking.
1631         assembly {
1632             auxCasted := aux
1633         }
1634         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1635         _packedAddressData[owner] = packed;
1636     }
1637 
1638     // =============================================================
1639     //                            IERC165
1640     // =============================================================
1641 
1642     /**
1643      * @dev Returns true if this contract implements the interface defined by
1644      * `interfaceId`. See the corresponding
1645      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1646      * to learn more about how these ids are created.
1647      *
1648      * This function call must use less than 30000 gas.
1649      */
1650     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1651         // The interface IDs are constants representing the first 4 bytes
1652         // of the XOR of all function selectors in the interface.
1653         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1654         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1655         return
1656             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1657             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1658             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1659     }
1660 
1661     // =============================================================
1662     //                        IERC721Metadata
1663     // =============================================================
1664 
1665     /**
1666      * @dev Returns the token collection name.
1667      */
1668     function name() public view virtual override returns (string memory) {
1669         return _name;
1670     }
1671 
1672     /**
1673      * @dev Returns the token collection symbol.
1674      */
1675     function symbol() public view virtual override returns (string memory) {
1676         return _symbol;
1677     }
1678 
1679     /**
1680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1681      */
1682     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1683         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1684 
1685         string memory baseURI = _baseURI();
1686         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1687     }
1688 
1689     /**
1690      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1691      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1692      * by default, it can be overridden in child contracts.
1693      */
1694     function _baseURI() internal view virtual returns (string memory) {
1695         return '';
1696     }
1697 
1698     // =============================================================
1699     //                     OWNERSHIPS OPERATIONS
1700     // =============================================================
1701 
1702     /**
1703      * @dev Returns the owner of the `tokenId` token.
1704      *
1705      * Requirements:
1706      *
1707      * - `tokenId` must exist.
1708      */
1709     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1710         return address(uint160(_packedOwnershipOf(tokenId)));
1711     }
1712 
1713     /**
1714      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1715      * It gradually moves to O(1) as tokens get transferred around over time.
1716      */
1717     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1718         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1719     }
1720 
1721     /**
1722      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1723      */
1724     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1725         return _unpackedOwnership(_packedOwnerships[index]);
1726     }
1727 
1728     /**
1729      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1730      */
1731     function _initializeOwnershipAt(uint256 index) internal virtual {
1732         if (_packedOwnerships[index] == 0) {
1733             _packedOwnerships[index] = _packedOwnershipOf(index);
1734         }
1735     }
1736 
1737     /**
1738      * Returns the packed ownership data of `tokenId`.
1739      */
1740     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1741         uint256 curr = tokenId;
1742 
1743         unchecked {
1744             if (_startTokenId() <= curr)
1745                 if (curr < _currentIndex) {
1746                     uint256 packed = _packedOwnerships[curr];
1747                     // If not burned.
1748                     if (packed & _BITMASK_BURNED == 0) {
1749                         // Invariant:
1750                         // There will always be an initialized ownership slot
1751                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1752                         // before an unintialized ownership slot
1753                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1754                         // Hence, `curr` will not underflow.
1755                         //
1756                         // We can directly compare the packed value.
1757                         // If the address is zero, packed will be zero.
1758                         while (packed == 0) {
1759                             packed = _packedOwnerships[--curr];
1760                         }
1761                         return packed;
1762                     }
1763                 }
1764         }
1765         revert OwnerQueryForNonexistentToken();
1766     }
1767 
1768     /**
1769      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1770      */
1771     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1772         ownership.addr = address(uint160(packed));
1773         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1774         ownership.burned = packed & _BITMASK_BURNED != 0;
1775         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1776     }
1777 
1778     /**
1779      * @dev Packs ownership data into a single uint256.
1780      */
1781     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1782         assembly {
1783             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1784             owner := and(owner, _BITMASK_ADDRESS)
1785             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1786             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1787         }
1788     }
1789 
1790     /**
1791      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1792      */
1793     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1794         // For branchless setting of the `nextInitialized` flag.
1795         assembly {
1796             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1797             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1798         }
1799     }
1800 
1801     // =============================================================
1802     //                      APPROVAL OPERATIONS
1803     // =============================================================
1804 
1805     /**
1806      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1807      * The approval is cleared when the token is transferred.
1808      *
1809      * Only a single account can be approved at a time, so approving the
1810      * zero address clears previous approvals.
1811      *
1812      * Requirements:
1813      *
1814      * - The caller must own the token or be an approved operator.
1815      * - `tokenId` must exist.
1816      *
1817      * Emits an {Approval} event.
1818      */
1819     function approve(address to, uint256 tokenId) public virtual override {
1820         address owner = ownerOf(tokenId);
1821 
1822         if (_msgSenderERC721A() != owner)
1823             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1824                 revert ApprovalCallerNotOwnerNorApproved();
1825             }
1826 
1827         _tokenApprovals[tokenId].value = to;
1828         emit Approval(owner, to, tokenId);
1829     }
1830 
1831     /**
1832      * @dev Returns the account approved for `tokenId` token.
1833      *
1834      * Requirements:
1835      *
1836      * - `tokenId` must exist.
1837      */
1838     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1839         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1840 
1841         return _tokenApprovals[tokenId].value;
1842     }
1843 
1844     /**
1845      * @dev Approve or remove `operator` as an operator for the caller.
1846      * Operators can call {transferFrom} or {safeTransferFrom}
1847      * for any token owned by the caller.
1848      *
1849      * Requirements:
1850      *
1851      * - The `operator` cannot be the caller.
1852      *
1853      * Emits an {ApprovalForAll} event.
1854      */
1855     function setApprovalForAll(address operator, bool approved) public virtual override {
1856         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1857 
1858         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1859         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1860     }
1861 
1862     /**
1863      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1864      *
1865      * See {setApprovalForAll}.
1866      */
1867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1868         return _operatorApprovals[owner][operator];
1869     }
1870 
1871     /**
1872      * @dev Returns whether `tokenId` exists.
1873      *
1874      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1875      *
1876      * Tokens start existing when they are minted. See {_mint}.
1877      */
1878     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1879         return
1880             _startTokenId() <= tokenId &&
1881             tokenId < _currentIndex && // If within bounds,
1882             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1883     }
1884 
1885     /**
1886      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1887      */
1888     function _isSenderApprovedOrOwner(
1889         address approvedAddress,
1890         address owner,
1891         address msgSender
1892     ) private pure returns (bool result) {
1893         assembly {
1894             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1895             owner := and(owner, _BITMASK_ADDRESS)
1896             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1897             msgSender := and(msgSender, _BITMASK_ADDRESS)
1898             // `msgSender == owner || msgSender == approvedAddress`.
1899             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1900         }
1901     }
1902 
1903     /**
1904      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1905      */
1906     function _getApprovedSlotAndAddress(uint256 tokenId)
1907         private
1908         view
1909         returns (uint256 approvedAddressSlot, address approvedAddress)
1910     {
1911         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1912         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1913         assembly {
1914             approvedAddressSlot := tokenApproval.slot
1915             approvedAddress := sload(approvedAddressSlot)
1916         }
1917     }
1918 
1919     // =============================================================
1920     //                      TRANSFER OPERATIONS
1921     // =============================================================
1922 
1923     /**
1924      * @dev Transfers `tokenId` from `from` to `to`.
1925      *
1926      * Requirements:
1927      *
1928      * - `from` cannot be the zero address.
1929      * - `to` cannot be the zero address.
1930      * - `tokenId` token must be owned by `from`.
1931      * - If the caller is not `from`, it must be approved to move this token
1932      * by either {approve} or {setApprovalForAll}.
1933      *
1934      * Emits a {Transfer} event.
1935      */
1936     function transferFrom(
1937         address from,
1938         address to,
1939         uint256 tokenId
1940     ) public virtual override {
1941         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1942 
1943         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1944 
1945         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1946 
1947         // The nested ifs save around 20+ gas over a compound boolean condition.
1948         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1949             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1950 
1951         if (to == address(0)) revert TransferToZeroAddress();
1952 
1953         _beforeTokenTransfers(from, to, tokenId, 1);
1954 
1955         // Clear approvals from the previous owner.
1956         assembly {
1957             if approvedAddress {
1958                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1959                 sstore(approvedAddressSlot, 0)
1960             }
1961         }
1962 
1963         // Underflow of the sender's balance is impossible because we check for
1964         // ownership above and the recipient's balance can't realistically overflow.
1965         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1966         unchecked {
1967             // We can directly increment and decrement the balances.
1968             --_packedAddressData[from]; // Updates: `balance -= 1`.
1969             ++_packedAddressData[to]; // Updates: `balance += 1`.
1970 
1971             // Updates:
1972             // - `address` to the next owner.
1973             // - `startTimestamp` to the timestamp of transfering.
1974             // - `burned` to `false`.
1975             // - `nextInitialized` to `true`.
1976             _packedOwnerships[tokenId] = _packOwnershipData(
1977                 to,
1978                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1979             );
1980 
1981             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1982             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1983                 uint256 nextTokenId = tokenId + 1;
1984                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1985                 if (_packedOwnerships[nextTokenId] == 0) {
1986                     // If the next slot is within bounds.
1987                     if (nextTokenId != _currentIndex) {
1988                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1989                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1990                     }
1991                 }
1992             }
1993         }
1994 
1995         emit Transfer(from, to, tokenId);
1996         _afterTokenTransfers(from, to, tokenId, 1);
1997     }
1998 
1999     /**
2000      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2001      */
2002     function safeTransferFrom(
2003         address from,
2004         address to,
2005         uint256 tokenId
2006     ) public virtual override {
2007         safeTransferFrom(from, to, tokenId, '');
2008     }
2009 
2010     /**
2011      * @dev Safely transfers `tokenId` token from `from` to `to`.
2012      *
2013      * Requirements:
2014      *
2015      * - `from` cannot be the zero address.
2016      * - `to` cannot be the zero address.
2017      * - `tokenId` token must exist and be owned by `from`.
2018      * - If the caller is not `from`, it must be approved to move this token
2019      * by either {approve} or {setApprovalForAll}.
2020      * - If `to` refers to a smart contract, it must implement
2021      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2022      *
2023      * Emits a {Transfer} event.
2024      */
2025     function safeTransferFrom(
2026         address from,
2027         address to,
2028         uint256 tokenId,
2029         bytes memory _data
2030     ) public virtual override {
2031         transferFrom(from, to, tokenId);
2032         if (to.code.length != 0)
2033             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2034                 revert TransferToNonERC721ReceiverImplementer();
2035             }
2036     }
2037 
2038     /**
2039      * @dev Hook that is called before a set of serially-ordered token IDs
2040      * are about to be transferred. This includes minting.
2041      * And also called before burning one token.
2042      *
2043      * `startTokenId` - the first token ID to be transferred.
2044      * `quantity` - the amount to be transferred.
2045      *
2046      * Calling conditions:
2047      *
2048      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2049      * transferred to `to`.
2050      * - When `from` is zero, `tokenId` will be minted for `to`.
2051      * - When `to` is zero, `tokenId` will be burned by `from`.
2052      * - `from` and `to` are never both zero.
2053      */
2054     function _beforeTokenTransfers(
2055         address from,
2056         address to,
2057         uint256 startTokenId,
2058         uint256 quantity
2059     ) internal virtual {}
2060 
2061     /**
2062      * @dev Hook that is called after a set of serially-ordered token IDs
2063      * have been transferred. This includes minting.
2064      * And also called after one token has been burned.
2065      *
2066      * `startTokenId` - the first token ID to be transferred.
2067      * `quantity` - the amount to be transferred.
2068      *
2069      * Calling conditions:
2070      *
2071      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2072      * transferred to `to`.
2073      * - When `from` is zero, `tokenId` has been minted for `to`.
2074      * - When `to` is zero, `tokenId` has been burned by `from`.
2075      * - `from` and `to` are never both zero.
2076      */
2077     function _afterTokenTransfers(
2078         address from,
2079         address to,
2080         uint256 startTokenId,
2081         uint256 quantity
2082     ) internal virtual {}
2083 
2084     /**
2085      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2086      *
2087      * `from` - Previous owner of the given token ID.
2088      * `to` - Target address that will receive the token.
2089      * `tokenId` - Token ID to be transferred.
2090      * `_data` - Optional data to send along with the call.
2091      *
2092      * Returns whether the call correctly returned the expected magic value.
2093      */
2094     function _checkContractOnERC721Received(
2095         address from,
2096         address to,
2097         uint256 tokenId,
2098         bytes memory _data
2099     ) private returns (bool) {
2100         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2101             bytes4 retval
2102         ) {
2103             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2104         } catch (bytes memory reason) {
2105             if (reason.length == 0) {
2106                 revert TransferToNonERC721ReceiverImplementer();
2107             } else {
2108                 assembly {
2109                     revert(add(32, reason), mload(reason))
2110                 }
2111             }
2112         }
2113     }
2114 
2115     // =============================================================
2116     //                        MINT OPERATIONS
2117     // =============================================================
2118 
2119     /**
2120      * @dev Mints `quantity` tokens and transfers them to `to`.
2121      *
2122      * Requirements:
2123      *
2124      * - `to` cannot be the zero address.
2125      * - `quantity` must be greater than 0.
2126      *
2127      * Emits a {Transfer} event for each mint.
2128      */
2129     function _mint(address to, uint256 quantity) internal virtual {
2130         uint256 startTokenId = _currentIndex;
2131         if (quantity == 0) revert MintZeroQuantity();
2132 
2133         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2134 
2135         // Overflows are incredibly unrealistic.
2136         // `balance` and `numberMinted` have a maximum limit of 2**64.
2137         // `tokenId` has a maximum limit of 2**256.
2138         unchecked {
2139             // Updates:
2140             // - `balance += quantity`.
2141             // - `numberMinted += quantity`.
2142             //
2143             // We can directly add to the `balance` and `numberMinted`.
2144             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2145 
2146             // Updates:
2147             // - `address` to the owner.
2148             // - `startTimestamp` to the timestamp of minting.
2149             // - `burned` to `false`.
2150             // - `nextInitialized` to `quantity == 1`.
2151             _packedOwnerships[startTokenId] = _packOwnershipData(
2152                 to,
2153                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2154             );
2155 
2156             uint256 toMasked;
2157             uint256 end = startTokenId + quantity;
2158 
2159             // Use assembly to loop and emit the `Transfer` event for gas savings.
2160             assembly {
2161                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2162                 toMasked := and(to, _BITMASK_ADDRESS)
2163                 // Emit the `Transfer` event.
2164                 log4(
2165                     0, // Start of data (0, since no data).
2166                     0, // End of data (0, since no data).
2167                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2168                     0, // `address(0)`.
2169                     toMasked, // `to`.
2170                     startTokenId // `tokenId`.
2171                 )
2172 
2173                 for {
2174                     let tokenId := add(startTokenId, 1)
2175                 } iszero(eq(tokenId, end)) {
2176                     tokenId := add(tokenId, 1)
2177                 } {
2178                     // Emit the `Transfer` event. Similar to above.
2179                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2180                 }
2181             }
2182             if (toMasked == 0) revert MintToZeroAddress();
2183 
2184             _currentIndex = end;
2185         }
2186         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2187     }
2188 
2189     /**
2190      * @dev Mints `quantity` tokens and transfers them to `to`.
2191      *
2192      * This function is intended for efficient minting only during contract creation.
2193      *
2194      * It emits only one {ConsecutiveTransfer} as defined in
2195      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2196      * instead of a sequence of {Transfer} event(s).
2197      *
2198      * Calling this function outside of contract creation WILL make your contract
2199      * non-compliant with the ERC721 standard.
2200      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2201      * {ConsecutiveTransfer} event is only permissible during contract creation.
2202      *
2203      * Requirements:
2204      *
2205      * - `to` cannot be the zero address.
2206      * - `quantity` must be greater than 0.
2207      *
2208      * Emits a {ConsecutiveTransfer} event.
2209      */
2210     function _mintERC2309(address to, uint256 quantity) internal virtual {
2211         uint256 startTokenId = _currentIndex;
2212         if (to == address(0)) revert MintToZeroAddress();
2213         if (quantity == 0) revert MintZeroQuantity();
2214         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2215 
2216         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2217 
2218         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2219         unchecked {
2220             // Updates:
2221             // - `balance += quantity`.
2222             // - `numberMinted += quantity`.
2223             //
2224             // We can directly add to the `balance` and `numberMinted`.
2225             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2226 
2227             // Updates:
2228             // - `address` to the owner.
2229             // - `startTimestamp` to the timestamp of minting.
2230             // - `burned` to `false`.
2231             // - `nextInitialized` to `quantity == 1`.
2232             _packedOwnerships[startTokenId] = _packOwnershipData(
2233                 to,
2234                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2235             );
2236 
2237             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2238 
2239             _currentIndex = startTokenId + quantity;
2240         }
2241         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2242     }
2243 
2244     /**
2245      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2246      *
2247      * Requirements:
2248      *
2249      * - If `to` refers to a smart contract, it must implement
2250      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2251      * - `quantity` must be greater than 0.
2252      *
2253      * See {_mint}.
2254      *
2255      * Emits a {Transfer} event for each mint.
2256      */
2257     function _safeMint(
2258         address to,
2259         uint256 quantity,
2260         bytes memory _data
2261     ) internal virtual {
2262         _mint(to, quantity);
2263 
2264         unchecked {
2265             if (to.code.length != 0) {
2266                 uint256 end = _currentIndex;
2267                 uint256 index = end - quantity;
2268                 do {
2269                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2270                         revert TransferToNonERC721ReceiverImplementer();
2271                     }
2272                 } while (index < end);
2273                 // Reentrancy protection.
2274                 if (_currentIndex != end) revert();
2275             }
2276         }
2277     }
2278 
2279     /**
2280      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2281      */
2282     function _safeMint(address to, uint256 quantity) internal virtual {
2283         _safeMint(to, quantity, '');
2284     }
2285 
2286     // =============================================================
2287     //                        BURN OPERATIONS
2288     // =============================================================
2289 
2290     /**
2291      * @dev Equivalent to `_burn(tokenId, false)`.
2292      */
2293     function _burn(uint256 tokenId) internal virtual {
2294         _burn(tokenId, false);
2295     }
2296 
2297     /**
2298      * @dev Destroys `tokenId`.
2299      * The approval is cleared when the token is burned.
2300      *
2301      * Requirements:
2302      *
2303      * - `tokenId` must exist.
2304      *
2305      * Emits a {Transfer} event.
2306      */
2307     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2308         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2309 
2310         address from = address(uint160(prevOwnershipPacked));
2311 
2312         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2313 
2314         if (approvalCheck) {
2315             // The nested ifs save around 20+ gas over a compound boolean condition.
2316             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2317                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2318         }
2319 
2320         _beforeTokenTransfers(from, address(0), tokenId, 1);
2321 
2322         // Clear approvals from the previous owner.
2323         assembly {
2324             if approvedAddress {
2325                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2326                 sstore(approvedAddressSlot, 0)
2327             }
2328         }
2329 
2330         // Underflow of the sender's balance is impossible because we check for
2331         // ownership above and the recipient's balance can't realistically overflow.
2332         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2333         unchecked {
2334             // Updates:
2335             // - `balance -= 1`.
2336             // - `numberBurned += 1`.
2337             //
2338             // We can directly decrement the balance, and increment the number burned.
2339             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2340             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2341 
2342             // Updates:
2343             // - `address` to the last owner.
2344             // - `startTimestamp` to the timestamp of burning.
2345             // - `burned` to `true`.
2346             // - `nextInitialized` to `true`.
2347             _packedOwnerships[tokenId] = _packOwnershipData(
2348                 from,
2349                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2350             );
2351 
2352             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2353             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2354                 uint256 nextTokenId = tokenId + 1;
2355                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2356                 if (_packedOwnerships[nextTokenId] == 0) {
2357                     // If the next slot is within bounds.
2358                     if (nextTokenId != _currentIndex) {
2359                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2360                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2361                     }
2362                 }
2363             }
2364         }
2365 
2366         emit Transfer(from, address(0), tokenId);
2367         _afterTokenTransfers(from, address(0), tokenId, 1);
2368 
2369         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2370         unchecked {
2371             _burnCounter++;
2372         }
2373     }
2374 
2375     // =============================================================
2376     //                     EXTRA DATA OPERATIONS
2377     // =============================================================
2378 
2379     /**
2380      * @dev Directly sets the extra data for the ownership data `index`.
2381      */
2382     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2383         uint256 packed = _packedOwnerships[index];
2384         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2385         uint256 extraDataCasted;
2386         // Cast `extraData` with assembly to avoid redundant masking.
2387         assembly {
2388             extraDataCasted := extraData
2389         }
2390         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2391         _packedOwnerships[index] = packed;
2392     }
2393 
2394     /**
2395      * @dev Called during each token transfer to set the 24bit `extraData` field.
2396      * Intended to be overridden by the cosumer contract.
2397      *
2398      * `previousExtraData` - the value of `extraData` before transfer.
2399      *
2400      * Calling conditions:
2401      *
2402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2403      * transferred to `to`.
2404      * - When `from` is zero, `tokenId` will be minted for `to`.
2405      * - When `to` is zero, `tokenId` will be burned by `from`.
2406      * - `from` and `to` are never both zero.
2407      */
2408     function _extraData(
2409         address from,
2410         address to,
2411         uint24 previousExtraData
2412     ) internal view virtual returns (uint24) {}
2413 
2414     /**
2415      * @dev Returns the next extra data for the packed ownership data.
2416      * The returned result is shifted into position.
2417      */
2418     function _nextExtraData(
2419         address from,
2420         address to,
2421         uint256 prevOwnershipPacked
2422     ) private view returns (uint256) {
2423         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2424         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2425     }
2426 
2427     // =============================================================
2428     //                       OTHER OPERATIONS
2429     // =============================================================
2430 
2431     /**
2432      * @dev Returns the message sender (defaults to `msg.sender`).
2433      *
2434      * If you are writing GSN compatible contracts, you need to override this function.
2435      */
2436     function _msgSenderERC721A() internal view virtual returns (address) {
2437         return msg.sender;
2438     }
2439 
2440     /**
2441      * @dev Converts a uint256 to its ASCII string decimal representation.
2442      */
2443     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2444         assembly {
2445             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2446             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2447             // We will need 1 32-byte word to store the length,
2448             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2449             ptr := add(mload(0x40), 128)
2450             // Update the free memory pointer to allocate.
2451             mstore(0x40, ptr)
2452 
2453             // Cache the end of the memory to calculate the length later.
2454             let end := ptr
2455 
2456             // We write the string from the rightmost digit to the leftmost digit.
2457             // The following is essentially a do-while loop that also handles the zero case.
2458             // Costs a bit more than early returning for the zero case,
2459             // but cheaper in terms of deployment and overall runtime costs.
2460             for {
2461                 // Initialize and perform the first pass without check.
2462                 let temp := value
2463                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2464                 ptr := sub(ptr, 1)
2465                 // Write the character to the pointer.
2466                 // The ASCII index of the '0' character is 48.
2467                 mstore8(ptr, add(48, mod(temp, 10)))
2468                 temp := div(temp, 10)
2469             } temp {
2470                 // Keep dividing `temp` until zero.
2471                 temp := div(temp, 10)
2472             } {
2473                 // Body of the for loop.
2474                 ptr := sub(ptr, 1)
2475                 mstore8(ptr, add(48, mod(temp, 10)))
2476             }
2477 
2478             let length := sub(end, ptr)
2479             // Move the pointer 32 bytes leftwards to make room for the length.
2480             ptr := sub(ptr, 32)
2481             // Store the length.
2482             mstore(ptr, length)
2483         }
2484     }
2485 }
2486 
2487 // File: client/contracts/CenturySocialClub.sol
2488 
2489 
2490 
2491 pragma solidity 0.8.11;
2492 
2493 
2494 
2495 
2496 
2497 
2498 contract CenturySocialClub is ERC721A, PaymentSplitter, Ownable {
2499     using Strings for uint256;
2500 
2501     // CSC - Metadata variables
2502     string baseURI;
2503     string public baseExtension = ".json";
2504     string public notRevealedUri;
2505     bool public revealed = false;
2506 
2507     // CSC - Mint variables
2508     uint256 public cost = 0.125 ether;
2509     uint256 public maxSupply;
2510     uint256 public supplyLimit;
2511     uint256 public maxPremintQuantity = 4;
2512     bytes32 public root;
2513 
2514     // CSC - Sale variables
2515     bool public isPremintOpened = false;
2516     bool public isPublicMintOpened = false;
2517     bool public paused = false;
2518 
2519     constructor(
2520         string memory _name,
2521         string memory _symbol,
2522         uint256 _maxSupply,
2523         uint256 _supplyLimit,
2524         string memory _initNotRevealedUri,
2525         bytes32 _merkleroot,
2526         address[] memory _payees,
2527         uint256[] memory _shares
2528     ) ERC721A(_name, _symbol) PaymentSplitter(_payees, _shares) {
2529         maxSupply = _maxSupply;
2530         supplyLimit = _supplyLimit;
2531         setNotRevealedURI(_initNotRevealedUri);
2532         root = _merkleroot;
2533     }
2534 
2535     // CSC - UTILS
2536 
2537     /**
2538      * @notice Update mint cost amount
2539      *
2540      * @param _newCost new cost amount
2541      */
2542     function setCost(uint256 _newCost) public onlyOwner {
2543         cost = _newCost;
2544     }
2545 
2546     /**
2547      * @notice Update max mint quantity allowed for premint
2548      *
2549      * @param _newMaxPremintQuantity new max premint quantity allowed
2550      */
2551     function setMaxPremintQuantity(uint256 _newMaxPremintQuantity) public onlyOwner {
2552         maxPremintQuantity = _newMaxPremintQuantity;
2553     }
2554 
2555     /**
2556      * @notice Update URI for unrevealed metadata
2557      *
2558      * @param _notRevealedURI new URI for unrevealed metadata
2559      */
2560     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2561         notRevealedUri = _notRevealedURI;
2562     }
2563 
2564     /**
2565      * @notice Update URI for metadata
2566      *
2567      * @param _newBaseURI new URI for metadata
2568      */
2569     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2570         baseURI = _newBaseURI;
2571     }
2572 
2573     /**
2574      * @notice Update premint state
2575      *
2576      * @param _opened new premint state
2577      */
2578     function setPremintOpened(bool _opened) public onlyOwner {
2579         isPremintOpened = _opened;
2580     }
2581 
2582     /**
2583      * @notice Update mint state
2584      *
2585      * @param _opened new mint state
2586      */
2587     function setMintOpened(bool _opened) public onlyOwner {
2588         isPublicMintOpened = _opened;
2589     }
2590 
2591     /**
2592      * @notice Update limit supply
2593      *
2594      * @param _supplyLimit update limit supply
2595      */
2596     function setLimitSupply(uint256 _supplyLimit) public onlyOwner {
2597         supplyLimit = _supplyLimit;
2598     }
2599 
2600     /**
2601      * @notice Update base extension for metadata
2602      *
2603      * @param _newBaseExtension new base extension
2604      */
2605     function setBaseExtension(string memory _newBaseExtension)
2606         public
2607         onlyOwner
2608     {
2609         baseExtension = _newBaseExtension;
2610     }
2611 
2612     /**
2613      * @notice Update merkle root
2614      *
2615      * @param _merkleroot new merkle root
2616      */
2617     function setMerkleRoot(bytes32 _merkleroot)
2618         public
2619         onlyOwner
2620     {
2621         root = _merkleroot;
2622     }
2623 
2624     /**
2625      * @notice Update sale state
2626      *
2627      * @param _state new sale state
2628      */
2629     function setPause(bool _state) public onlyOwner {
2630         paused = _state;
2631     }
2632 
2633     /**
2634      * @notice Returns balance of contract
2635      */
2636     function balance() public view returns(uint256) {
2637         return address(this).balance;
2638     }
2639 
2640     // CSC - Metadata
2641 
2642     /**
2643      * @notice Returns URI for metadata
2644      */
2645     function _baseURI() internal view virtual override returns (string memory) {
2646         return baseURI;
2647     }
2648 
2649     /**
2650      * @notice Returns URL for metadata
2651      *
2652      * @param tokenId token id
2653      */
2654     function tokenURI(uint256 tokenId)
2655         public
2656         view
2657         virtual
2658         override
2659         returns (string memory)
2660     {
2661         require(
2662             _exists(tokenId),
2663             "ERC721Metadata: URI query for nonexistent token"
2664         );
2665 
2666         if (revealed == false) {
2667             return bytes(notRevealedUri).length > 0
2668                 ? string(
2669                     abi.encodePacked(
2670                         notRevealedUri,
2671                         tokenId.toString(),
2672                         baseExtension
2673                     )
2674                 )
2675                 : "";
2676         }
2677 
2678         string memory currentBaseURI = _baseURI();
2679         return
2680             bytes(currentBaseURI).length > 0
2681                 ? string(
2682                     abi.encodePacked(
2683                         currentBaseURI,
2684                         tokenId.toString(),
2685                         baseExtension
2686                     )
2687                 )
2688                 : "";
2689     }
2690 
2691     /**
2692      * @notice Reveal NTFs
2693      */
2694     function reveal() public onlyOwner {
2695         revealed = true;
2696     }
2697 
2698     /**
2699      * @notice Update reveal state for metadata
2700      *
2701      * @param _state reveal state
2702      */
2703     function setReveal(bool _state) public onlyOwner {
2704         revealed = _state;
2705     }
2706 
2707     // CSC - Minting
2708 
2709     /**
2710      * @notice Mint NFTs for admin
2711      */
2712     function adminMint(uint256 _quantity) public onlyOwner {
2713         require(!paused);
2714         require(msg.sender == tx.origin);
2715         uint256 supply = totalSupply();
2716         require(supply + _quantity <= maxSupply);
2717         _mint(msg.sender, _quantity);
2718     }
2719 
2720     /**
2721      * @notice Mint NFTs during public sale
2722      *
2723      * @param _quantity quantity of tokens to mint
2724      */
2725     function PublicMint(uint256 _quantity) public payable {
2726         require(msg.sender == tx.origin);
2727         require(!paused);
2728         require(isPublicMintOpened, "Public mint is not opened");
2729         uint256 supply = totalSupply();
2730         require(supply + _quantity <= supplyLimit);
2731         require(supply + _quantity <= maxSupply);
2732 
2733         if (msg.sender != owner()) {
2734             require(msg.value >= cost * _quantity);
2735         }
2736 
2737         _mint(msg.sender, _quantity);
2738     }
2739 
2740 
2741     /**
2742      * @notice Mint NFTs if whitelisted
2743      *
2744      * @param _quantity quantity of tokens to mint
2745      * @param _proof merkle proof
2746      */
2747     function BrainPassMint(uint256 _quantity, bytes32[] calldata _proof) public payable {
2748         require(msg.sender == tx.origin);
2749         require(!paused, "Sale is not opened");
2750         require(isPremintOpened, "Premint mint is not opened");
2751         require(isWhiteListed(msg.sender, _proof), "Not in the whitelist");
2752         require(_numberMinted(msg.sender) + _quantity <= maxPremintQuantity, "You cannot mint more than 4 tokens during premint");
2753         uint256 supply = totalSupply();
2754         require(supply + _quantity <= supplyLimit, "Insufficient tokens left");
2755         require(supply + _quantity <= maxSupply, "Insufficient tokens left");
2756 
2757         if (msg.sender != owner()) {
2758             require(msg.value >= cost * _quantity);
2759         }
2760 
2761         _mint(msg.sender, _quantity);
2762     }
2763 
2764     // CSC - Whitelist verification
2765 
2766     /**
2767     * @notice Return true or false if the account is whitelisted or not
2768     *
2769     * @param account The account of the user
2770     * @param proof The Merkle Proof
2771     *
2772     * @return true or false if the account is whitelisted or not
2773     **/
2774     function isWhiteListed(address account, bytes32[] calldata proof) internal view returns(bool) {
2775         return _verify(_leaf(account), proof);
2776     }
2777 
2778     /**
2779     * @notice Return the account hashed
2780     *
2781     * @param account The account to hash
2782     *
2783     * @return The account hashed
2784     **/
2785     function _leaf(address account) internal pure returns(bytes32) {
2786         return keccak256(abi.encodePacked(account));
2787     }
2788 
2789     /**
2790     * @notice Returns true if a leaf can be proved to be a part of a Merkle tree defined by root
2791     *
2792     * @param leaf The leaf
2793     * @param proof The Merkle Proof
2794     *
2795     * @return True if a leaf can be provded to be a part of a Merkle tree defined by root
2796     **/
2797     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns(bool) {
2798         return MerkleProof.verify(proof, root, leaf);
2799     }
2800 }