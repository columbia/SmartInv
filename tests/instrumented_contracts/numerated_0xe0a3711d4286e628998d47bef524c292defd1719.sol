1 // SPDX-License-Identifier: MIT
2 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
3 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
4 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
5 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
6 
7 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @title ERC721 token receiver interface
16  * @dev Interface for any contract that wants to support safeTransfers
17  * from ERC721 asset contracts.
18  */
19 interface IERC721Receiver {
20     /**
21      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
22      * by `operator` from `from`, this function is called.
23      *
24      * It must return its Solidity selector to confirm the token transfer.
25      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
26      *
27      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
28      */
29     function onERC721Received(
30         address operator,
31         address from,
32         uint256 tokenId,
33         bytes calldata data
34     ) external returns (bytes4);
35 }
36 
37 // File: ISBShipable.sol
38 
39 
40 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
41 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
42 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
43 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
44 
45 pragma solidity 0.8.14;
46 
47 interface ISBShipable {
48     function initialize(
49         bytes calldata initArg,
50         uint128 bip,
51         address feeReceiver
52     ) external;
53 }
54 
55 // File: ISBMintable.sol
56 
57 
58 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
59 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
60 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
61 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
62 
63 pragma solidity 0.8.14;
64 
65 interface ISBMintable {
66     function mintNext(address reciever, uint256 amount) external;
67 
68     function mintTarget(address reciever, uint256 target) external;
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Interface of the ERC20 standard as defined in the EIP.
80  */
81 interface IERC20 {
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 
96     /**
97      * @dev Returns the amount of tokens in existence.
98      */
99     function totalSupply() external view returns (uint256);
100 
101     /**
102      * @dev Returns the amount of tokens owned by `account`.
103      */
104     function balanceOf(address account) external view returns (uint256);
105 
106     /**
107      * @dev Moves `amount` tokens from the caller's account to `to`.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * Emits a {Transfer} event.
112      */
113     function transfer(address to, uint256 amount) external returns (bool);
114 
115     /**
116      * @dev Returns the remaining number of tokens that `spender` will be
117      * allowed to spend on behalf of `owner` through {transferFrom}. This is
118      * zero by default.
119      *
120      * This value changes when {approve} or {transferFrom} are called.
121      */
122     function allowance(address owner, address spender) external view returns (uint256);
123 
124     /**
125      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * IMPORTANT: Beware that changing an allowance with this method brings the risk
130      * that someone may use both the old and the new allowance by unfortunate
131      * transaction ordering. One possible solution to mitigate this race
132      * condition is to first reduce the spender's allowance to 0 and set the
133      * desired value afterwards:
134      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
135      *
136      * Emits an {Approval} event.
137      */
138     function approve(address spender, uint256 amount) external returns (bool);
139 
140     /**
141      * @dev Moves `amount` tokens from `from` to `to` using the
142      * allowance mechanism. `amount` is then deducted from the caller's
143      * allowance.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address from,
151         address to,
152         uint256 amount
153     ) external returns (bool);
154 }
155 
156 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
157 
158 
159 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 /**
164  * @dev These functions deal with verification of Merkle Trees proofs.
165  *
166  * The proofs can be generated using the JavaScript library
167  * https://github.com/miguelmota/merkletreejs[merkletreejs].
168  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
169  *
170  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
171  *
172  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
173  * hashing, or use a hash function other than keccak256 for hashing leaves.
174  * This is because the concatenation of a sorted pair of internal nodes in
175  * the merkle tree could be reinterpreted as a leaf value.
176  */
177 library MerkleProof {
178     /**
179      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
180      * defined by `root`. For this, a `proof` must be provided, containing
181      * sibling hashes on the branch from the leaf to the root of the tree. Each
182      * pair of leaves and each pair of pre-images are assumed to be sorted.
183      */
184     function verify(
185         bytes32[] memory proof,
186         bytes32 root,
187         bytes32 leaf
188     ) internal pure returns (bool) {
189         return processProof(proof, leaf) == root;
190     }
191 
192     /**
193      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
194      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
195      * hash matches the root of the tree. When processing the proof, the pairs
196      * of leafs & pre-images are assumed to be sorted.
197      *
198      * _Available since v4.4._
199      */
200     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
201         bytes32 computedHash = leaf;
202         for (uint256 i = 0; i < proof.length; i++) {
203             bytes32 proofElement = proof[i];
204             if (computedHash <= proofElement) {
205                 // Hash(current computed hash + current element of the proof)
206                 computedHash = _efficientHash(computedHash, proofElement);
207             } else {
208                 // Hash(current element of the proof + current computed hash)
209                 computedHash = _efficientHash(proofElement, computedHash);
210             }
211         }
212         return computedHash;
213     }
214 
215     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
216         assembly {
217             mstore(0x00, a)
218             mstore(0x20, b)
219             value := keccak256(0x00, 0x40)
220         }
221     }
222 }
223 
224 // File: @openzeppelin/contracts/interfaces/IERC1271.sol
225 
226 
227 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1271.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Interface of the ERC1271 standard signature validation method for
233  * contracts as defined in https://eips.ethereum.org/EIPS/eip-1271[ERC-1271].
234  *
235  * _Available since v4.1._
236  */
237 interface IERC1271 {
238     /**
239      * @dev Should return whether the signature provided is valid for the provided data
240      * @param hash      Hash of the data to be signed
241      * @param signature Signature byte array associated with _data
242      */
243     function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
250 
251 pragma solidity ^0.8.1;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      *
274      * [IMPORTANT]
275      * ====
276      * You shouldn't rely on `isContract` to protect against flash loan attacks!
277      *
278      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
279      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
280      * constructor.
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // This method relies on extcodesize/address.code.length, which returns 0
285         // for contracts in construction, since the code is only stored at the end
286         // of the constructor execution.
287 
288         return account.code.length > 0;
289     }
290 
291     /**
292      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
293      * `recipient`, forwarding all available gas and reverting on errors.
294      *
295      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
296      * of certain opcodes, possibly making contracts go over the 2300 gas limit
297      * imposed by `transfer`, making them unable to receive funds via
298      * `transfer`. {sendValue} removes this limitation.
299      *
300      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
301      *
302      * IMPORTANT: because control is transferred to `recipient`, care must be
303      * taken to not create reentrancy vulnerabilities. Consider using
304      * {ReentrancyGuard} or the
305      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
306      */
307     function sendValue(address payable recipient, uint256 amount) internal {
308         require(address(this).balance >= amount, "Address: insufficient balance");
309 
310         (bool success, ) = recipient.call{value: amount}("");
311         require(success, "Address: unable to send value, recipient may have reverted");
312     }
313 
314     /**
315      * @dev Performs a Solidity function call using a low level `call`. A
316      * plain `call` is an unsafe replacement for a function call: use this
317      * function instead.
318      *
319      * If `target` reverts with a revert reason, it is bubbled up by this
320      * function (like regular Solidity function calls).
321      *
322      * Returns the raw returned data. To convert to the expected return value,
323      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
324      *
325      * Requirements:
326      *
327      * - `target` must be a contract.
328      * - calling `target` with `data` must not revert.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
333         return functionCall(target, data, "Address: low-level call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
338      * `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(
362         address target,
363         bytes memory data,
364         uint256 value
365     ) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(
376         address target,
377         bytes memory data,
378         uint256 value,
379         string memory errorMessage
380     ) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         require(isContract(target), "Address: call to non-contract");
383 
384         (bool success, bytes memory returndata) = target.call{value: value}(data);
385         return verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but performing a static call.
391      *
392      * _Available since v3.3._
393      */
394     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
395         return functionStaticCall(target, data, "Address: low-level static call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
400      * but performing a static call.
401      *
402      * _Available since v3.3._
403      */
404     function functionStaticCall(
405         address target,
406         bytes memory data,
407         string memory errorMessage
408     ) internal view returns (bytes memory) {
409         require(isContract(target), "Address: static call to non-contract");
410 
411         (bool success, bytes memory returndata) = target.staticcall(data);
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a delegate call.
418      *
419      * _Available since v3.4._
420      */
421     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
422         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
427      * but performing a delegate call.
428      *
429      * _Available since v3.4._
430      */
431     function functionDelegateCall(
432         address target,
433         bytes memory data,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(isContract(target), "Address: delegate call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.delegatecall(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
444      * revert reason using the provided one.
445      *
446      * _Available since v4.3._
447      */
448     function verifyCallResult(
449         bool success,
450         bytes memory returndata,
451         string memory errorMessage
452     ) internal pure returns (bytes memory) {
453         if (success) {
454             return returndata;
455         } else {
456             // Look for revert reason and bubble it up if present
457             if (returndata.length > 0) {
458                 // The easiest way to bubble the revert reason is using memory via assembly
459 
460                 assembly {
461                     let returndata_size := mload(returndata)
462                     revert(add(32, returndata), returndata_size)
463                 }
464             } else {
465                 revert(errorMessage);
466             }
467         }
468     }
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
472 
473 
474 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
475 
476 pragma solidity ^0.8.0;
477 
478 
479 
480 /**
481  * @title SafeERC20
482  * @dev Wrappers around ERC20 operations that throw on failure (when the token
483  * contract returns false). Tokens that return no value (and instead revert or
484  * throw on failure) are also supported, non-reverting calls are assumed to be
485  * successful.
486  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
487  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
488  */
489 library SafeERC20 {
490     using Address for address;
491 
492     function safeTransfer(
493         IERC20 token,
494         address to,
495         uint256 value
496     ) internal {
497         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
498     }
499 
500     function safeTransferFrom(
501         IERC20 token,
502         address from,
503         address to,
504         uint256 value
505     ) internal {
506         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
507     }
508 
509     /**
510      * @dev Deprecated. This function has issues similar to the ones found in
511      * {IERC20-approve}, and its usage is discouraged.
512      *
513      * Whenever possible, use {safeIncreaseAllowance} and
514      * {safeDecreaseAllowance} instead.
515      */
516     function safeApprove(
517         IERC20 token,
518         address spender,
519         uint256 value
520     ) internal {
521         // safeApprove should only be called when setting an initial allowance,
522         // or when resetting it to zero. To increase and decrease it, use
523         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
524         require(
525             (value == 0) || (token.allowance(address(this), spender) == 0),
526             "SafeERC20: approve from non-zero to non-zero allowance"
527         );
528         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
529     }
530 
531     function safeIncreaseAllowance(
532         IERC20 token,
533         address spender,
534         uint256 value
535     ) internal {
536         uint256 newAllowance = token.allowance(address(this), spender) + value;
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     function safeDecreaseAllowance(
541         IERC20 token,
542         address spender,
543         uint256 value
544     ) internal {
545         unchecked {
546             uint256 oldAllowance = token.allowance(address(this), spender);
547             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
548             uint256 newAllowance = oldAllowance - value;
549             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
550         }
551     }
552 
553     /**
554      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
555      * on the return value: the return value is optional (but if data is returned, it must not be false).
556      * @param token The token targeted by the call.
557      * @param data The call data (encoded using abi.encode or one of its variants).
558      */
559     function _callOptionalReturn(IERC20 token, bytes memory data) private {
560         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
561         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
562         // the target address contains contract code and also asserts for success in the low-level call.
563 
564         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
565         if (returndata.length > 0) {
566             // Return data is optional
567             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
568         }
569     }
570 }
571 
572 // File: paymentUtil.sol
573 
574 
575 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
576 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
577 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
578 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
579 
580 pragma solidity 0.8.14;
581 
582 
583 
584 library paymentUtil {
585     using SafeERC20 for IERC20;
586 
587     function processPayment(address token, uint256 amount) public {
588         if (token == address(0)) {
589             require(msg.value >= amount, "invalid payment");
590         } else {
591             IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/utils/Strings.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev String operations.
605  */
606 library Strings {
607     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
608 
609     /**
610      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
611      */
612     function toString(uint256 value) internal pure returns (string memory) {
613         // Inspired by OraclizeAPI's implementation - MIT licence
614         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
615 
616         if (value == 0) {
617             return "0";
618         }
619         uint256 temp = value;
620         uint256 digits;
621         while (temp != 0) {
622             digits++;
623             temp /= 10;
624         }
625         bytes memory buffer = new bytes(digits);
626         while (value != 0) {
627             digits -= 1;
628             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
629             value /= 10;
630         }
631         return string(buffer);
632     }
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
636      */
637     function toHexString(uint256 value) internal pure returns (string memory) {
638         if (value == 0) {
639             return "0x00";
640         }
641         uint256 temp = value;
642         uint256 length = 0;
643         while (temp != 0) {
644             length++;
645             temp >>= 8;
646         }
647         return toHexString(value, length);
648     }
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
652      */
653     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
654         bytes memory buffer = new bytes(2 * length + 2);
655         buffer[0] = "0";
656         buffer[1] = "x";
657         for (uint256 i = 2 * length + 1; i > 1; --i) {
658             buffer[i] = _HEX_SYMBOLS[value & 0xf];
659             value >>= 4;
660         }
661         require(value == 0, "Strings: hex length insufficient");
662         return string(buffer);
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
667 
668 
669 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 
674 /**
675  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
676  *
677  * These functions can be used to verify that a message was signed by the holder
678  * of the private keys of a given address.
679  */
680 library ECDSA {
681     enum RecoverError {
682         NoError,
683         InvalidSignature,
684         InvalidSignatureLength,
685         InvalidSignatureS,
686         InvalidSignatureV
687     }
688 
689     function _throwError(RecoverError error) private pure {
690         if (error == RecoverError.NoError) {
691             return; // no error: do nothing
692         } else if (error == RecoverError.InvalidSignature) {
693             revert("ECDSA: invalid signature");
694         } else if (error == RecoverError.InvalidSignatureLength) {
695             revert("ECDSA: invalid signature length");
696         } else if (error == RecoverError.InvalidSignatureS) {
697             revert("ECDSA: invalid signature 's' value");
698         } else if (error == RecoverError.InvalidSignatureV) {
699             revert("ECDSA: invalid signature 'v' value");
700         }
701     }
702 
703     /**
704      * @dev Returns the address that signed a hashed message (`hash`) with
705      * `signature` or error string. This address can then be used for verification purposes.
706      *
707      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
708      * this function rejects them by requiring the `s` value to be in the lower
709      * half order, and the `v` value to be either 27 or 28.
710      *
711      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
712      * verification to be secure: it is possible to craft signatures that
713      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
714      * this is by receiving a hash of the original message (which may otherwise
715      * be too long), and then calling {toEthSignedMessageHash} on it.
716      *
717      * Documentation for signature generation:
718      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
719      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
720      *
721      * _Available since v4.3._
722      */
723     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
724         // Check the signature length
725         // - case 65: r,s,v signature (standard)
726         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
727         if (signature.length == 65) {
728             bytes32 r;
729             bytes32 s;
730             uint8 v;
731             // ecrecover takes the signature parameters, and the only way to get them
732             // currently is to use assembly.
733             assembly {
734                 r := mload(add(signature, 0x20))
735                 s := mload(add(signature, 0x40))
736                 v := byte(0, mload(add(signature, 0x60)))
737             }
738             return tryRecover(hash, v, r, s);
739         } else if (signature.length == 64) {
740             bytes32 r;
741             bytes32 vs;
742             // ecrecover takes the signature parameters, and the only way to get them
743             // currently is to use assembly.
744             assembly {
745                 r := mload(add(signature, 0x20))
746                 vs := mload(add(signature, 0x40))
747             }
748             return tryRecover(hash, r, vs);
749         } else {
750             return (address(0), RecoverError.InvalidSignatureLength);
751         }
752     }
753 
754     /**
755      * @dev Returns the address that signed a hashed message (`hash`) with
756      * `signature`. This address can then be used for verification purposes.
757      *
758      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
759      * this function rejects them by requiring the `s` value to be in the lower
760      * half order, and the `v` value to be either 27 or 28.
761      *
762      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
763      * verification to be secure: it is possible to craft signatures that
764      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
765      * this is by receiving a hash of the original message (which may otherwise
766      * be too long), and then calling {toEthSignedMessageHash} on it.
767      */
768     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
769         (address recovered, RecoverError error) = tryRecover(hash, signature);
770         _throwError(error);
771         return recovered;
772     }
773 
774     /**
775      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
776      *
777      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
778      *
779      * _Available since v4.3._
780      */
781     function tryRecover(
782         bytes32 hash,
783         bytes32 r,
784         bytes32 vs
785     ) internal pure returns (address, RecoverError) {
786         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
787         uint8 v = uint8((uint256(vs) >> 255) + 27);
788         return tryRecover(hash, v, r, s);
789     }
790 
791     /**
792      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
793      *
794      * _Available since v4.2._
795      */
796     function recover(
797         bytes32 hash,
798         bytes32 r,
799         bytes32 vs
800     ) internal pure returns (address) {
801         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
802         _throwError(error);
803         return recovered;
804     }
805 
806     /**
807      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
808      * `r` and `s` signature fields separately.
809      *
810      * _Available since v4.3._
811      */
812     function tryRecover(
813         bytes32 hash,
814         uint8 v,
815         bytes32 r,
816         bytes32 s
817     ) internal pure returns (address, RecoverError) {
818         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
819         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
820         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
821         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
822         //
823         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
824         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
825         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
826         // these malleable signatures as well.
827         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
828             return (address(0), RecoverError.InvalidSignatureS);
829         }
830         if (v != 27 && v != 28) {
831             return (address(0), RecoverError.InvalidSignatureV);
832         }
833 
834         // If the signature is valid (and not malleable), return the signer address
835         address signer = ecrecover(hash, v, r, s);
836         if (signer == address(0)) {
837             return (address(0), RecoverError.InvalidSignature);
838         }
839 
840         return (signer, RecoverError.NoError);
841     }
842 
843     /**
844      * @dev Overload of {ECDSA-recover} that receives the `v`,
845      * `r` and `s` signature fields separately.
846      */
847     function recover(
848         bytes32 hash,
849         uint8 v,
850         bytes32 r,
851         bytes32 s
852     ) internal pure returns (address) {
853         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
854         _throwError(error);
855         return recovered;
856     }
857 
858     /**
859      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
860      * produces hash corresponding to the one signed with the
861      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
862      * JSON-RPC method as part of EIP-191.
863      *
864      * See {recover}.
865      */
866     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
867         // 32 is the length in bytes of hash,
868         // enforced by the type signature above
869         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
870     }
871 
872     /**
873      * @dev Returns an Ethereum Signed Message, created from `s`. This
874      * produces hash corresponding to the one signed with the
875      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
876      * JSON-RPC method as part of EIP-191.
877      *
878      * See {recover}.
879      */
880     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
881         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
882     }
883 
884     /**
885      * @dev Returns an Ethereum Signed Typed Data, created from a
886      * `domainSeparator` and a `structHash`. This produces hash corresponding
887      * to the one signed with the
888      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
889      * JSON-RPC method as part of EIP-712.
890      *
891      * See {recover}.
892      */
893     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
894         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
895     }
896 }
897 
898 // File: @openzeppelin/contracts/utils/cryptography/SignatureChecker.sol
899 
900 
901 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/SignatureChecker.sol)
902 
903 pragma solidity ^0.8.0;
904 
905 
906 
907 
908 /**
909  * @dev Signature verification helper that can be used instead of `ECDSA.recover` to seamlessly support both ECDSA
910  * signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like
911  * Argent and Gnosis Safe.
912  *
913  * _Available since v4.1._
914  */
915 library SignatureChecker {
916     /**
917      * @dev Checks if a signature is valid for a given signer and data hash. If the signer is a smart contract, the
918      * signature is validated against that smart contract using ERC1271, otherwise it's validated using `ECDSA.recover`.
919      *
920      * NOTE: Unlike ECDSA signatures, contract signatures are revocable, and the outcome of this function can thus
921      * change through time. It could return true at block N and false at block N+1 (or the opposite).
922      */
923     function isValidSignatureNow(
924         address signer,
925         bytes32 hash,
926         bytes memory signature
927     ) internal view returns (bool) {
928         (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
929         if (error == ECDSA.RecoverError.NoError && recovered == signer) {
930             return true;
931         }
932 
933         (bool success, bytes memory result) = signer.staticcall(
934             abi.encodeWithSelector(IERC1271.isValidSignature.selector, hash, signature)
935         );
936         return (success && result.length == 32 && abi.decode(result, (bytes4)) == IERC1271.isValidSignature.selector);
937     }
938 }
939 
940 // File: @openzeppelin/contracts-upgradeable/utils/structs/EnumerableSetUpgradeable.sol
941 
942 
943 // OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/EnumerableSet.sol)
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @dev Library for managing
949  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
950  * types.
951  *
952  * Sets have the following properties:
953  *
954  * - Elements are added, removed, and checked for existence in constant time
955  * (O(1)).
956  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
957  *
958  * ```
959  * contract Example {
960  *     // Add the library methods
961  *     using EnumerableSet for EnumerableSet.AddressSet;
962  *
963  *     // Declare a set state variable
964  *     EnumerableSet.AddressSet private mySet;
965  * }
966  * ```
967  *
968  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
969  * and `uint256` (`UintSet`) are supported.
970  */
971 library EnumerableSetUpgradeable {
972     // To implement this library for multiple types with as little code
973     // repetition as possible, we write it in terms of a generic Set type with
974     // bytes32 values.
975     // The Set implementation uses private functions, and user-facing
976     // implementations (such as AddressSet) are just wrappers around the
977     // underlying Set.
978     // This means that we can only create new EnumerableSets for types that fit
979     // in bytes32.
980 
981     struct Set {
982         // Storage of set values
983         bytes32[] _values;
984         // Position of the value in the `values` array, plus 1 because index 0
985         // means a value is not in the set.
986         mapping(bytes32 => uint256) _indexes;
987     }
988 
989     /**
990      * @dev Add a value to a set. O(1).
991      *
992      * Returns true if the value was added to the set, that is if it was not
993      * already present.
994      */
995     function _add(Set storage set, bytes32 value) private returns (bool) {
996         if (!_contains(set, value)) {
997             set._values.push(value);
998             // The value is stored at length-1, but we add 1 to all indexes
999             // and use 0 as a sentinel value
1000             set._indexes[value] = set._values.length;
1001             return true;
1002         } else {
1003             return false;
1004         }
1005     }
1006 
1007     /**
1008      * @dev Removes a value from a set. O(1).
1009      *
1010      * Returns true if the value was removed from the set, that is if it was
1011      * present.
1012      */
1013     function _remove(Set storage set, bytes32 value) private returns (bool) {
1014         // We read and store the value's index to prevent multiple reads from the same storage slot
1015         uint256 valueIndex = set._indexes[value];
1016 
1017         if (valueIndex != 0) {
1018             // Equivalent to contains(set, value)
1019             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1020             // the array, and then remove the last element (sometimes called as 'swap and pop').
1021             // This modifies the order of the array, as noted in {at}.
1022 
1023             uint256 toDeleteIndex = valueIndex - 1;
1024             uint256 lastIndex = set._values.length - 1;
1025 
1026             if (lastIndex != toDeleteIndex) {
1027                 bytes32 lastValue = set._values[lastIndex];
1028 
1029                 // Move the last value to the index where the value to delete is
1030                 set._values[toDeleteIndex] = lastValue;
1031                 // Update the index for the moved value
1032                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1033             }
1034 
1035             // Delete the slot where the moved value was stored
1036             set._values.pop();
1037 
1038             // Delete the index for the deleted slot
1039             delete set._indexes[value];
1040 
1041             return true;
1042         } else {
1043             return false;
1044         }
1045     }
1046 
1047     /**
1048      * @dev Returns true if the value is in the set. O(1).
1049      */
1050     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1051         return set._indexes[value] != 0;
1052     }
1053 
1054     /**
1055      * @dev Returns the number of values on the set. O(1).
1056      */
1057     function _length(Set storage set) private view returns (uint256) {
1058         return set._values.length;
1059     }
1060 
1061     /**
1062      * @dev Returns the value stored at position `index` in the set. O(1).
1063      *
1064      * Note that there are no guarantees on the ordering of values inside the
1065      * array, and it may change when more values are added or removed.
1066      *
1067      * Requirements:
1068      *
1069      * - `index` must be strictly less than {length}.
1070      */
1071     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1072         return set._values[index];
1073     }
1074 
1075     /**
1076      * @dev Return the entire set in an array
1077      *
1078      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1079      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1080      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1081      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1082      */
1083     function _values(Set storage set) private view returns (bytes32[] memory) {
1084         return set._values;
1085     }
1086 
1087     // Bytes32Set
1088 
1089     struct Bytes32Set {
1090         Set _inner;
1091     }
1092 
1093     /**
1094      * @dev Add a value to a set. O(1).
1095      *
1096      * Returns true if the value was added to the set, that is if it was not
1097      * already present.
1098      */
1099     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1100         return _add(set._inner, value);
1101     }
1102 
1103     /**
1104      * @dev Removes a value from a set. O(1).
1105      *
1106      * Returns true if the value was removed from the set, that is if it was
1107      * present.
1108      */
1109     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1110         return _remove(set._inner, value);
1111     }
1112 
1113     /**
1114      * @dev Returns true if the value is in the set. O(1).
1115      */
1116     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1117         return _contains(set._inner, value);
1118     }
1119 
1120     /**
1121      * @dev Returns the number of values in the set. O(1).
1122      */
1123     function length(Bytes32Set storage set) internal view returns (uint256) {
1124         return _length(set._inner);
1125     }
1126 
1127     /**
1128      * @dev Returns the value stored at position `index` in the set. O(1).
1129      *
1130      * Note that there are no guarantees on the ordering of values inside the
1131      * array, and it may change when more values are added or removed.
1132      *
1133      * Requirements:
1134      *
1135      * - `index` must be strictly less than {length}.
1136      */
1137     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1138         return _at(set._inner, index);
1139     }
1140 
1141     /**
1142      * @dev Return the entire set in an array
1143      *
1144      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1145      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1146      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1147      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1148      */
1149     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1150         return _values(set._inner);
1151     }
1152 
1153     // AddressSet
1154 
1155     struct AddressSet {
1156         Set _inner;
1157     }
1158 
1159     /**
1160      * @dev Add a value to a set. O(1).
1161      *
1162      * Returns true if the value was added to the set, that is if it was not
1163      * already present.
1164      */
1165     function add(AddressSet storage set, address value) internal returns (bool) {
1166         return _add(set._inner, bytes32(uint256(uint160(value))));
1167     }
1168 
1169     /**
1170      * @dev Removes a value from a set. O(1).
1171      *
1172      * Returns true if the value was removed from the set, that is if it was
1173      * present.
1174      */
1175     function remove(AddressSet storage set, address value) internal returns (bool) {
1176         return _remove(set._inner, bytes32(uint256(uint160(value))));
1177     }
1178 
1179     /**
1180      * @dev Returns true if the value is in the set. O(1).
1181      */
1182     function contains(AddressSet storage set, address value) internal view returns (bool) {
1183         return _contains(set._inner, bytes32(uint256(uint160(value))));
1184     }
1185 
1186     /**
1187      * @dev Returns the number of values in the set. O(1).
1188      */
1189     function length(AddressSet storage set) internal view returns (uint256) {
1190         return _length(set._inner);
1191     }
1192 
1193     /**
1194      * @dev Returns the value stored at position `index` in the set. O(1).
1195      *
1196      * Note that there are no guarantees on the ordering of values inside the
1197      * array, and it may change when more values are added or removed.
1198      *
1199      * Requirements:
1200      *
1201      * - `index` must be strictly less than {length}.
1202      */
1203     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1204         return address(uint160(uint256(_at(set._inner, index))));
1205     }
1206 
1207     /**
1208      * @dev Return the entire set in an array
1209      *
1210      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1211      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1212      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1213      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1214      */
1215     function values(AddressSet storage set) internal view returns (address[] memory) {
1216         bytes32[] memory store = _values(set._inner);
1217         address[] memory result;
1218 
1219         assembly {
1220             result := store
1221         }
1222 
1223         return result;
1224     }
1225 
1226     // UintSet
1227 
1228     struct UintSet {
1229         Set _inner;
1230     }
1231 
1232     /**
1233      * @dev Add a value to a set. O(1).
1234      *
1235      * Returns true if the value was added to the set, that is if it was not
1236      * already present.
1237      */
1238     function add(UintSet storage set, uint256 value) internal returns (bool) {
1239         return _add(set._inner, bytes32(value));
1240     }
1241 
1242     /**
1243      * @dev Removes a value from a set. O(1).
1244      *
1245      * Returns true if the value was removed from the set, that is if it was
1246      * present.
1247      */
1248     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1249         return _remove(set._inner, bytes32(value));
1250     }
1251 
1252     /**
1253      * @dev Returns true if the value is in the set. O(1).
1254      */
1255     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1256         return _contains(set._inner, bytes32(value));
1257     }
1258 
1259     /**
1260      * @dev Returns the number of values on the set. O(1).
1261      */
1262     function length(UintSet storage set) internal view returns (uint256) {
1263         return _length(set._inner);
1264     }
1265 
1266     /**
1267      * @dev Returns the value stored at position `index` in the set. O(1).
1268      *
1269      * Note that there are no guarantees on the ordering of values inside the
1270      * array, and it may change when more values are added or removed.
1271      *
1272      * Requirements:
1273      *
1274      * - `index` must be strictly less than {length}.
1275      */
1276     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1277         return uint256(_at(set._inner, index));
1278     }
1279 
1280     /**
1281      * @dev Return the entire set in an array
1282      *
1283      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1284      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1285      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1286      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1287      */
1288     function values(UintSet storage set) internal view returns (uint256[] memory) {
1289         bytes32[] memory store = _values(set._inner);
1290         uint256[] memory result;
1291 
1292         assembly {
1293             result := store
1294         }
1295 
1296         return result;
1297     }
1298 }
1299 
1300 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
1301 
1302 
1303 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1304 
1305 pragma solidity ^0.8.0;
1306 
1307 /**
1308  * @dev Interface of the ERC165 standard, as defined in the
1309  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1310  *
1311  * Implementers can declare support of contract interfaces, which can then be
1312  * queried by others ({ERC165Checker}).
1313  *
1314  * For an implementation, see {ERC165}.
1315  */
1316 interface IERC165Upgradeable {
1317     /**
1318      * @dev Returns true if this contract implements the interface defined by
1319      * `interfaceId`. See the corresponding
1320      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1321      * to learn more about how these ids are created.
1322      *
1323      * This function call must use less than 30 000 gas.
1324      */
1325     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1326 }
1327 
1328 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol
1329 
1330 
1331 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 
1336 /**
1337  * @dev Required interface of an ERC721 compliant contract.
1338  */
1339 interface IERC721Upgradeable is IERC165Upgradeable {
1340     /**
1341      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1342      */
1343     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1344 
1345     /**
1346      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1347      */
1348     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1349 
1350     /**
1351      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1352      */
1353     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1354 
1355     /**
1356      * @dev Returns the number of tokens in ``owner``'s account.
1357      */
1358     function balanceOf(address owner) external view returns (uint256 balance);
1359 
1360     /**
1361      * @dev Returns the owner of the `tokenId` token.
1362      *
1363      * Requirements:
1364      *
1365      * - `tokenId` must exist.
1366      */
1367     function ownerOf(uint256 tokenId) external view returns (address owner);
1368 
1369     /**
1370      * @dev Safely transfers `tokenId` token from `from` to `to`.
1371      *
1372      * Requirements:
1373      *
1374      * - `from` cannot be the zero address.
1375      * - `to` cannot be the zero address.
1376      * - `tokenId` token must exist and be owned by `from`.
1377      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function safeTransferFrom(
1383         address from,
1384         address to,
1385         uint256 tokenId,
1386         bytes calldata data
1387     ) external;
1388 
1389     /**
1390      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1391      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1392      *
1393      * Requirements:
1394      *
1395      * - `from` cannot be the zero address.
1396      * - `to` cannot be the zero address.
1397      * - `tokenId` token must exist and be owned by `from`.
1398      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1399      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1400      *
1401      * Emits a {Transfer} event.
1402      */
1403     function safeTransferFrom(
1404         address from,
1405         address to,
1406         uint256 tokenId
1407     ) external;
1408 
1409     /**
1410      * @dev Transfers `tokenId` token from `from` to `to`.
1411      *
1412      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1413      *
1414      * Requirements:
1415      *
1416      * - `from` cannot be the zero address.
1417      * - `to` cannot be the zero address.
1418      * - `tokenId` token must be owned by `from`.
1419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function transferFrom(
1424         address from,
1425         address to,
1426         uint256 tokenId
1427     ) external;
1428 
1429     /**
1430      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1431      * The approval is cleared when the token is transferred.
1432      *
1433      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1434      *
1435      * Requirements:
1436      *
1437      * - The caller must own the token or be an approved operator.
1438      * - `tokenId` must exist.
1439      *
1440      * Emits an {Approval} event.
1441      */
1442     function approve(address to, uint256 tokenId) external;
1443 
1444     /**
1445      * @dev Approve or remove `operator` as an operator for the caller.
1446      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1447      *
1448      * Requirements:
1449      *
1450      * - The `operator` cannot be the caller.
1451      *
1452      * Emits an {ApprovalForAll} event.
1453      */
1454     function setApprovalForAll(address operator, bool _approved) external;
1455 
1456     /**
1457      * @dev Returns the account approved for `tokenId` token.
1458      *
1459      * Requirements:
1460      *
1461      * - `tokenId` must exist.
1462      */
1463     function getApproved(uint256 tokenId) external view returns (address operator);
1464 
1465     /**
1466      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1467      *
1468      * See {setApprovalForAll}
1469      */
1470     function isApprovedForAll(address owner, address operator) external view returns (bool);
1471 }
1472 
1473 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol
1474 
1475 
1476 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1477 
1478 pragma solidity ^0.8.0;
1479 
1480 
1481 /**
1482  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1483  * @dev See https://eips.ethereum.org/EIPS/eip-721
1484  */
1485 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
1486     /**
1487      * @dev Returns the token collection name.
1488      */
1489     function name() external view returns (string memory);
1490 
1491     /**
1492      * @dev Returns the token collection symbol.
1493      */
1494     function symbol() external view returns (string memory);
1495 
1496     /**
1497      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1498      */
1499     function tokenURI(uint256 tokenId) external view returns (string memory);
1500 }
1501 
1502 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
1503 
1504 
1505 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
1506 
1507 pragma solidity ^0.8.0;
1508 
1509 /**
1510  * @dev String operations.
1511  */
1512 library StringsUpgradeable {
1513     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1514 
1515     /**
1516      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1517      */
1518     function toString(uint256 value) internal pure returns (string memory) {
1519         // Inspired by OraclizeAPI's implementation - MIT licence
1520         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1521 
1522         if (value == 0) {
1523             return "0";
1524         }
1525         uint256 temp = value;
1526         uint256 digits;
1527         while (temp != 0) {
1528             digits++;
1529             temp /= 10;
1530         }
1531         bytes memory buffer = new bytes(digits);
1532         while (value != 0) {
1533             digits -= 1;
1534             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1535             value /= 10;
1536         }
1537         return string(buffer);
1538     }
1539 
1540     /**
1541      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1542      */
1543     function toHexString(uint256 value) internal pure returns (string memory) {
1544         if (value == 0) {
1545             return "0x00";
1546         }
1547         uint256 temp = value;
1548         uint256 length = 0;
1549         while (temp != 0) {
1550             length++;
1551             temp >>= 8;
1552         }
1553         return toHexString(value, length);
1554     }
1555 
1556     /**
1557      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1558      */
1559     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1560         bytes memory buffer = new bytes(2 * length + 2);
1561         buffer[0] = "0";
1562         buffer[1] = "x";
1563         for (uint256 i = 2 * length + 1; i > 1; --i) {
1564             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1565             value >>= 4;
1566         }
1567         require(value == 0, "Strings: hex length insufficient");
1568         return string(buffer);
1569     }
1570 }
1571 
1572 // File: @openzeppelin/contracts-upgradeable/access/IAccessControlUpgradeable.sol
1573 
1574 
1575 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1576 
1577 pragma solidity ^0.8.0;
1578 
1579 /**
1580  * @dev External interface of AccessControl declared to support ERC165 detection.
1581  */
1582 interface IAccessControlUpgradeable {
1583     /**
1584      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1585      *
1586      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1587      * {RoleAdminChanged} not being emitted signaling this.
1588      *
1589      * _Available since v3.1._
1590      */
1591     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1592 
1593     /**
1594      * @dev Emitted when `account` is granted `role`.
1595      *
1596      * `sender` is the account that originated the contract call, an admin role
1597      * bearer except when using {AccessControl-_setupRole}.
1598      */
1599     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1600 
1601     /**
1602      * @dev Emitted when `account` is revoked `role`.
1603      *
1604      * `sender` is the account that originated the contract call:
1605      *   - if using `revokeRole`, it is the admin role bearer
1606      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1607      */
1608     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1609 
1610     /**
1611      * @dev Returns `true` if `account` has been granted `role`.
1612      */
1613     function hasRole(bytes32 role, address account) external view returns (bool);
1614 
1615     /**
1616      * @dev Returns the admin role that controls `role`. See {grantRole} and
1617      * {revokeRole}.
1618      *
1619      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1620      */
1621     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1622 
1623     /**
1624      * @dev Grants `role` to `account`.
1625      *
1626      * If `account` had not been already granted `role`, emits a {RoleGranted}
1627      * event.
1628      *
1629      * Requirements:
1630      *
1631      * - the caller must have ``role``'s admin role.
1632      */
1633     function grantRole(bytes32 role, address account) external;
1634 
1635     /**
1636      * @dev Revokes `role` from `account`.
1637      *
1638      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1639      *
1640      * Requirements:
1641      *
1642      * - the caller must have ``role``'s admin role.
1643      */
1644     function revokeRole(bytes32 role, address account) external;
1645 
1646     /**
1647      * @dev Revokes `role` from the calling account.
1648      *
1649      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1650      * purpose is to provide a mechanism for accounts to lose their privileges
1651      * if they are compromised (such as when a trusted device is misplaced).
1652      *
1653      * If the calling account had been granted `role`, emits a {RoleRevoked}
1654      * event.
1655      *
1656      * Requirements:
1657      *
1658      * - the caller must be `account`.
1659      */
1660     function renounceRole(bytes32 role, address account) external;
1661 }
1662 
1663 // File: @openzeppelin/contracts-upgradeable/access/IAccessControlEnumerableUpgradeable.sol
1664 
1665 
1666 // OpenZeppelin Contracts v4.4.1 (access/IAccessControlEnumerable.sol)
1667 
1668 pragma solidity ^0.8.0;
1669 
1670 
1671 /**
1672  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1673  */
1674 interface IAccessControlEnumerableUpgradeable is IAccessControlUpgradeable {
1675     /**
1676      * @dev Returns one of the accounts that have `role`. `index` must be a
1677      * value between 0 and {getRoleMemberCount}, non-inclusive.
1678      *
1679      * Role bearers are not sorted in any particular way, and their ordering may
1680      * change at any point.
1681      *
1682      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1683      * you perform all queries on the same block. See the following
1684      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1685      * for more information.
1686      */
1687     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1688 
1689     /**
1690      * @dev Returns the number of accounts that have `role`. Can be used
1691      * together with {getRoleMember} to enumerate all bearers of a role.
1692      */
1693     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1694 }
1695 
1696 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
1697 
1698 
1699 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1700 
1701 pragma solidity ^0.8.1;
1702 
1703 /**
1704  * @dev Collection of functions related to the address type
1705  */
1706 library AddressUpgradeable {
1707     /**
1708      * @dev Returns true if `account` is a contract.
1709      *
1710      * [IMPORTANT]
1711      * ====
1712      * It is unsafe to assume that an address for which this function returns
1713      * false is an externally-owned account (EOA) and not a contract.
1714      *
1715      * Among others, `isContract` will return false for the following
1716      * types of addresses:
1717      *
1718      *  - an externally-owned account
1719      *  - a contract in construction
1720      *  - an address where a contract will be created
1721      *  - an address where a contract lived, but was destroyed
1722      * ====
1723      *
1724      * [IMPORTANT]
1725      * ====
1726      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1727      *
1728      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1729      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1730      * constructor.
1731      * ====
1732      */
1733     function isContract(address account) internal view returns (bool) {
1734         // This method relies on extcodesize/address.code.length, which returns 0
1735         // for contracts in construction, since the code is only stored at the end
1736         // of the constructor execution.
1737 
1738         return account.code.length > 0;
1739     }
1740 
1741     /**
1742      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1743      * `recipient`, forwarding all available gas and reverting on errors.
1744      *
1745      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1746      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1747      * imposed by `transfer`, making them unable to receive funds via
1748      * `transfer`. {sendValue} removes this limitation.
1749      *
1750      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1751      *
1752      * IMPORTANT: because control is transferred to `recipient`, care must be
1753      * taken to not create reentrancy vulnerabilities. Consider using
1754      * {ReentrancyGuard} or the
1755      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1756      */
1757     function sendValue(address payable recipient, uint256 amount) internal {
1758         require(address(this).balance >= amount, "Address: insufficient balance");
1759 
1760         (bool success, ) = recipient.call{value: amount}("");
1761         require(success, "Address: unable to send value, recipient may have reverted");
1762     }
1763 
1764     /**
1765      * @dev Performs a Solidity function call using a low level `call`. A
1766      * plain `call` is an unsafe replacement for a function call: use this
1767      * function instead.
1768      *
1769      * If `target` reverts with a revert reason, it is bubbled up by this
1770      * function (like regular Solidity function calls).
1771      *
1772      * Returns the raw returned data. To convert to the expected return value,
1773      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1774      *
1775      * Requirements:
1776      *
1777      * - `target` must be a contract.
1778      * - calling `target` with `data` must not revert.
1779      *
1780      * _Available since v3.1._
1781      */
1782     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1783         return functionCall(target, data, "Address: low-level call failed");
1784     }
1785 
1786     /**
1787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1788      * `errorMessage` as a fallback revert reason when `target` reverts.
1789      *
1790      * _Available since v3.1._
1791      */
1792     function functionCall(
1793         address target,
1794         bytes memory data,
1795         string memory errorMessage
1796     ) internal returns (bytes memory) {
1797         return functionCallWithValue(target, data, 0, errorMessage);
1798     }
1799 
1800     /**
1801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1802      * but also transferring `value` wei to `target`.
1803      *
1804      * Requirements:
1805      *
1806      * - the calling contract must have an ETH balance of at least `value`.
1807      * - the called Solidity function must be `payable`.
1808      *
1809      * _Available since v3.1._
1810      */
1811     function functionCallWithValue(
1812         address target,
1813         bytes memory data,
1814         uint256 value
1815     ) internal returns (bytes memory) {
1816         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1817     }
1818 
1819     /**
1820      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1821      * with `errorMessage` as a fallback revert reason when `target` reverts.
1822      *
1823      * _Available since v3.1._
1824      */
1825     function functionCallWithValue(
1826         address target,
1827         bytes memory data,
1828         uint256 value,
1829         string memory errorMessage
1830     ) internal returns (bytes memory) {
1831         require(address(this).balance >= value, "Address: insufficient balance for call");
1832         require(isContract(target), "Address: call to non-contract");
1833 
1834         (bool success, bytes memory returndata) = target.call{value: value}(data);
1835         return verifyCallResult(success, returndata, errorMessage);
1836     }
1837 
1838     /**
1839      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1840      * but performing a static call.
1841      *
1842      * _Available since v3.3._
1843      */
1844     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1845         return functionStaticCall(target, data, "Address: low-level static call failed");
1846     }
1847 
1848     /**
1849      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1850      * but performing a static call.
1851      *
1852      * _Available since v3.3._
1853      */
1854     function functionStaticCall(
1855         address target,
1856         bytes memory data,
1857         string memory errorMessage
1858     ) internal view returns (bytes memory) {
1859         require(isContract(target), "Address: static call to non-contract");
1860 
1861         (bool success, bytes memory returndata) = target.staticcall(data);
1862         return verifyCallResult(success, returndata, errorMessage);
1863     }
1864 
1865     /**
1866      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1867      * revert reason using the provided one.
1868      *
1869      * _Available since v4.3._
1870      */
1871     function verifyCallResult(
1872         bool success,
1873         bytes memory returndata,
1874         string memory errorMessage
1875     ) internal pure returns (bytes memory) {
1876         if (success) {
1877             return returndata;
1878         } else {
1879             // Look for revert reason and bubble it up if present
1880             if (returndata.length > 0) {
1881                 // The easiest way to bubble the revert reason is using memory via assembly
1882 
1883                 assembly {
1884                     let returndata_size := mload(returndata)
1885                     revert(add(32, returndata), returndata_size)
1886                 }
1887             } else {
1888                 revert(errorMessage);
1889             }
1890         }
1891     }
1892 }
1893 
1894 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
1895 
1896 
1897 // OpenZeppelin Contracts (last updated v4.6.0) (proxy/utils/Initializable.sol)
1898 
1899 pragma solidity ^0.8.2;
1900 
1901 
1902 /**
1903  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
1904  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
1905  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
1906  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
1907  *
1908  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
1909  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
1910  * case an upgrade adds a module that needs to be initialized.
1911  *
1912  * For example:
1913  *
1914  * [.hljs-theme-light.nopadding]
1915  * ```
1916  * contract MyToken is ERC20Upgradeable {
1917  *     function initialize() initializer public {
1918  *         __ERC20_init("MyToken", "MTK");
1919  *     }
1920  * }
1921  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
1922  *     function initializeV2() reinitializer(2) public {
1923  *         __ERC20Permit_init("MyToken");
1924  *     }
1925  * }
1926  * ```
1927  *
1928  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
1929  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
1930  *
1931  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
1932  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
1933  *
1934  * [CAUTION]
1935  * ====
1936  * Avoid leaving a contract uninitialized.
1937  *
1938  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
1939  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
1940  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
1941  *
1942  * [.hljs-theme-light.nopadding]
1943  * ```
1944  * /// @custom:oz-upgrades-unsafe-allow constructor
1945  * constructor() {
1946  *     _disableInitializers();
1947  * }
1948  * ```
1949  * ====
1950  */
1951 abstract contract Initializable {
1952     /**
1953      * @dev Indicates that the contract has been initialized.
1954      * @custom:oz-retyped-from bool
1955      */
1956     uint8 private _initialized;
1957 
1958     /**
1959      * @dev Indicates that the contract is in the process of being initialized.
1960      */
1961     bool private _initializing;
1962 
1963     /**
1964      * @dev Triggered when the contract has been initialized or reinitialized.
1965      */
1966     event Initialized(uint8 version);
1967 
1968     /**
1969      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
1970      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
1971      */
1972     modifier initializer() {
1973         bool isTopLevelCall = _setInitializedVersion(1);
1974         if (isTopLevelCall) {
1975             _initializing = true;
1976         }
1977         _;
1978         if (isTopLevelCall) {
1979             _initializing = false;
1980             emit Initialized(1);
1981         }
1982     }
1983 
1984     /**
1985      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
1986      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
1987      * used to initialize parent contracts.
1988      *
1989      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
1990      * initialization step. This is essential to configure modules that are added through upgrades and that require
1991      * initialization.
1992      *
1993      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
1994      * a contract, executing them in the right order is up to the developer or operator.
1995      */
1996     modifier reinitializer(uint8 version) {
1997         bool isTopLevelCall = _setInitializedVersion(version);
1998         if (isTopLevelCall) {
1999             _initializing = true;
2000         }
2001         _;
2002         if (isTopLevelCall) {
2003             _initializing = false;
2004             emit Initialized(version);
2005         }
2006     }
2007 
2008     /**
2009      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
2010      * {initializer} and {reinitializer} modifiers, directly or indirectly.
2011      */
2012     modifier onlyInitializing() {
2013         require(_initializing, "Initializable: contract is not initializing");
2014         _;
2015     }
2016 
2017     /**
2018      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
2019      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
2020      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
2021      * through proxies.
2022      */
2023     function _disableInitializers() internal virtual {
2024         _setInitializedVersion(type(uint8).max);
2025     }
2026 
2027     function _setInitializedVersion(uint8 version) private returns (bool) {
2028         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
2029         // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
2030         // of initializers, because in other contexts the contract may have been reentered.
2031         if (_initializing) {
2032             require(
2033                 version == 1 && !AddressUpgradeable.isContract(address(this)),
2034                 "Initializable: contract is already initialized"
2035             );
2036             return false;
2037         } else {
2038             require(_initialized < version, "Initializable: contract is already initialized");
2039             _initialized = version;
2040             return true;
2041         }
2042     }
2043 }
2044 
2045 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
2046 
2047 
2048 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
2049 
2050 pragma solidity ^0.8.0;
2051 
2052 
2053 
2054 /**
2055  * @dev Implementation of the {IERC165} interface.
2056  *
2057  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
2058  * for the additional interface id that will be supported. For example:
2059  *
2060  * ```solidity
2061  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2062  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
2063  * }
2064  * ```
2065  *
2066  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
2067  */
2068 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
2069     function __ERC165_init() internal onlyInitializing {
2070     }
2071 
2072     function __ERC165_init_unchained() internal onlyInitializing {
2073     }
2074     /**
2075      * @dev See {IERC165-supportsInterface}.
2076      */
2077     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2078         return interfaceId == type(IERC165Upgradeable).interfaceId;
2079     }
2080 
2081     /**
2082      * @dev This empty reserved space is put in place to allow future versions to add new
2083      * variables without shifting down storage in the inheritance chain.
2084      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2085      */
2086     uint256[50] private __gap;
2087 }
2088 
2089 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
2090 
2091 
2092 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2093 
2094 pragma solidity ^0.8.0;
2095 
2096 
2097 /**
2098  * @dev Provides information about the current execution context, including the
2099  * sender of the transaction and its data. While these are generally available
2100  * via msg.sender and msg.data, they should not be accessed in such a direct
2101  * manner, since when dealing with meta-transactions the account sending and
2102  * paying for execution may not be the actual sender (as far as an application
2103  * is concerned).
2104  *
2105  * This contract is only required for intermediate, library-like contracts.
2106  */
2107 abstract contract ContextUpgradeable is Initializable {
2108     function __Context_init() internal onlyInitializing {
2109     }
2110 
2111     function __Context_init_unchained() internal onlyInitializing {
2112     }
2113     function _msgSender() internal view virtual returns (address) {
2114         return msg.sender;
2115     }
2116 
2117     function _msgData() internal view virtual returns (bytes calldata) {
2118         return msg.data;
2119     }
2120 
2121     /**
2122      * @dev This empty reserved space is put in place to allow future versions to add new
2123      * variables without shifting down storage in the inheritance chain.
2124      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
2125      */
2126     uint256[50] private __gap;
2127 }
2128 
2129 // File: ERC721ASBUpgradable.sol
2130 
2131 
2132 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
2133 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
2134 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
2135 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
2136 
2137 // ERC721A Creator: Chiru Labs
2138 // GJ mate. interesting design :)
2139 
2140 pragma solidity 0.8.14;
2141 
2142 
2143 
2144 
2145 
2146 
2147 
2148 
2149 
2150 error ApprovalCallerNotOwnerNorApproved();
2151 error ApprovalQueryForNonexistentToken();
2152 error ApproveToCaller();
2153 error ApprovalToCurrentOwner();
2154 error BalanceQueryForZeroAddress();
2155 error MintToZeroAddress();
2156 error MintZeroQuantity();
2157 error OwnerQueryForNonexistentToken();
2158 error TransferCallerNotOwnerNorApproved();
2159 error TransferFromIncorrectOwner();
2160 error TransferToNonERC721ReceiverImplementer();
2161 error TransferToZeroAddress();
2162 error URIQueryForNonexistentToken();
2163 error AllOwnershipsHaveBeenSet();
2164 error QuantityMustBeNonZero();
2165 error NoTokensMintedYet();
2166 error InvalidQueryRange();
2167 
2168 /**
2169  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
2170  * the Metadata extension. Built to optimize for lower gas during batch mints.
2171  *
2172  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
2173  *
2174  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2175  *
2176  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
2177  *
2178  * Speedboat team modified version of ERC721A - upgradable
2179  */
2180 contract ERC721ASBUpgradable is
2181     Initializable,
2182     ContextUpgradeable,
2183     ERC165Upgradeable,
2184     IERC721Upgradeable,
2185     IERC721MetadataUpgradeable
2186 {
2187     using Address for address;
2188     using Strings for uint256;
2189 
2190     // Compiler will pack this into a single 256bit word.
2191     struct TokenOwnership {
2192         // The address of the owner.
2193         address addr;
2194         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
2195         uint64 startTimestamp;
2196         // Whether the token has been burned.
2197         bool burned;
2198     }
2199 
2200     // Compiler will pack this into a single 256bit word.
2201     struct AddressData {
2202         // Realistically, 2**64-1 is more than enough.
2203         uint64 balance;
2204         // Keeps track of mint count with minimal overhead for tokenomics.
2205         uint64 numberMinted;
2206         // Keeps track of burn count with minimal overhead for tokenomics.
2207         uint64 numberBurned;
2208         // For miscellaneous variable(s) pertaining to the address
2209         // (e.g. number of whitelist mint slots used).
2210         // If there are multiple variables, please pack them into a uint64.
2211         uint64 aux;
2212     }
2213 
2214     // The tokenId of the next token to be minted.
2215     uint256 internal _currentIndex;
2216 
2217     // The number of tokens burned.
2218     uint256 internal _burnCounter;
2219 
2220     // Token name
2221     string private _name;
2222 
2223     // Token symbol
2224     string private _symbol;
2225 
2226     // Mapping from token ID to ownership details
2227     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
2228     mapping(uint256 => TokenOwnership) internal _ownerships;
2229 
2230     // Mapping owner address to address data
2231     mapping(address => AddressData) private _addressData;
2232 
2233     // Mapping from token ID to approved address
2234     mapping(uint256 => address) private _tokenApprovals;
2235 
2236     // Mapping from owner to operator approvals
2237     mapping(address => mapping(address => bool)) private _operatorApprovals;
2238 
2239     uint256 public nextOwnerToExplicitlySet;
2240 
2241     /**
2242      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
2243      * SB: change to public. anyone are free to pay the gas lol :P
2244      */
2245     function setOwnersExplicit(uint256 quantity) public {
2246         if (quantity == 0) revert QuantityMustBeNonZero();
2247         if (_currentIndex == _startTokenId()) revert NoTokensMintedYet();
2248         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
2249         if (_nextOwnerToExplicitlySet == 0) {
2250             _nextOwnerToExplicitlySet = _startTokenId();
2251         }
2252         if (_nextOwnerToExplicitlySet >= _currentIndex)
2253             revert AllOwnershipsHaveBeenSet();
2254 
2255         // Index underflow is impossible.
2256         // Counter or index overflow is incredibly unrealistic.
2257         unchecked {
2258             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
2259 
2260             // Set the end index to be the last token index
2261             if (endIndex + 1 > _currentIndex) {
2262                 endIndex = _currentIndex - 1;
2263             }
2264 
2265             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
2266                 if (
2267                     _ownerships[i].addr == address(0) && !_ownerships[i].burned
2268                 ) {
2269                     TokenOwnership memory ownership = _ownershipOf(i);
2270                     _ownerships[i].addr = ownership.addr;
2271                     _ownerships[i].startTimestamp = ownership.startTimestamp;
2272                 }
2273             }
2274 
2275             nextOwnerToExplicitlySet = endIndex + 1;
2276         }
2277     }
2278 
2279     /**
2280      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2281      *
2282      * If the `tokenId` is out of bounds:
2283      *   - `addr` = `address(0)`
2284      *   - `startTimestamp` = `0`
2285      *   - `burned` = `false`
2286      *
2287      * If the `tokenId` is burned:
2288      *   - `addr` = `<Address of owner before token was burned>`
2289      *   - `startTimestamp` = `<Timestamp when token was burned>`
2290      *   - `burned = `true`
2291      *
2292      * Otherwise:
2293      *   - `addr` = `<Address of owner>`
2294      *   - `startTimestamp` = `<Timestamp of start of ownership>`
2295      *   - `burned = `false`
2296      */
2297     function explicitOwnershipOf(uint256 tokenId)
2298         public
2299         view
2300         returns (TokenOwnership memory)
2301     {
2302         TokenOwnership memory ownership;
2303         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
2304             return ownership;
2305         }
2306         ownership = _ownerships[tokenId];
2307         if (ownership.burned) {
2308             return ownership;
2309         }
2310         return _ownershipOf(tokenId);
2311     }
2312 
2313     /**
2314      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2315      * See {ERC721AQueryable-explicitOwnershipOf}
2316      */
2317     function explicitOwnershipsOf(uint256[] memory tokenIds)
2318         external
2319         view
2320         returns (TokenOwnership[] memory)
2321     {
2322         unchecked {
2323             uint256 tokenIdsLength = tokenIds.length;
2324             TokenOwnership[] memory ownerships = new TokenOwnership[](
2325                 tokenIdsLength
2326             );
2327             for (uint256 i; i != tokenIdsLength; ++i) {
2328                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2329             }
2330             return ownerships;
2331         }
2332     }
2333 
2334     /**
2335      * @dev Returns an array of token IDs owned by `owner`,
2336      * in the range [`start`, `stop`)
2337      * (i.e. `start <= tokenId < stop`).
2338      *
2339      * This function allows for tokens to be queried if the collection
2340      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2341      *
2342      * Requirements:
2343      *
2344      * - `start` < `stop`
2345      */
2346     function tokensOfOwnerIn(
2347         address owner,
2348         uint256 start,
2349         uint256 stop
2350     ) external view returns (uint256[] memory) {
2351         unchecked {
2352             if (start >= stop) revert InvalidQueryRange();
2353             uint256 tokenIdsIdx;
2354             uint256 stopLimit = _currentIndex;
2355             // Set `start = max(start, _startTokenId())`.
2356             if (start < _startTokenId()) {
2357                 start = _startTokenId();
2358             }
2359             // Set `stop = min(stop, _currentIndex)`.
2360             if (stop > stopLimit) {
2361                 stop = stopLimit;
2362             }
2363             uint256 tokenIdsMaxLength = balanceOf(owner);
2364             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2365             // to cater for cases where `balanceOf(owner)` is too big.
2366             if (start < stop) {
2367                 uint256 rangeLength = stop - start;
2368                 if (rangeLength < tokenIdsMaxLength) {
2369                     tokenIdsMaxLength = rangeLength;
2370                 }
2371             } else {
2372                 tokenIdsMaxLength = 0;
2373             }
2374             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2375             if (tokenIdsMaxLength == 0) {
2376                 return tokenIds;
2377             }
2378             // We need to call `explicitOwnershipOf(start)`,
2379             // because the slot at `start` may not be initialized.
2380             TokenOwnership memory ownership = explicitOwnershipOf(start);
2381             address currOwnershipAddr;
2382             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2383             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2384             if (!ownership.burned) {
2385                 currOwnershipAddr = ownership.addr;
2386             }
2387             for (
2388                 uint256 i = start;
2389                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
2390                 ++i
2391             ) {
2392                 ownership = _ownerships[i];
2393                 if (ownership.burned) {
2394                     continue;
2395                 }
2396                 if (ownership.addr != address(0)) {
2397                     currOwnershipAddr = ownership.addr;
2398                 }
2399                 if (currOwnershipAddr == owner) {
2400                     tokenIds[tokenIdsIdx++] = i;
2401                 }
2402             }
2403             // Downsize the array to fit.
2404             assembly {
2405                 mstore(tokenIds, tokenIdsIdx)
2406             }
2407             return tokenIds;
2408         }
2409     }
2410 
2411     /**
2412      * @dev Returns an array of token IDs owned by `owner`.
2413      *
2414      * This function scans the ownership mapping and is O(totalSupply) in complexity.
2415      * It is meant to be called off-chain.
2416      *
2417      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2418      * multiple smaller scans if the collection is large enough to cause
2419      * an out-of-gas error (10K pfp collections should be fine).
2420      */
2421     function tokensOfOwner(address owner)
2422         public
2423         view
2424         returns (uint256[] memory)
2425     {
2426         unchecked {
2427             uint256 tokenIdsIdx;
2428             address currOwnershipAddr;
2429             uint256 tokenIdsLength = balanceOf(owner);
2430             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2431             TokenOwnership memory ownership;
2432             for (
2433                 uint256 i = _startTokenId();
2434                 tokenIdsIdx != tokenIdsLength;
2435                 ++i
2436             ) {
2437                 ownership = _ownerships[i];
2438                 if (ownership.burned) {
2439                     continue;
2440                 }
2441                 if (ownership.addr != address(0)) {
2442                     currOwnershipAddr = ownership.addr;
2443                 }
2444                 if (currOwnershipAddr == owner) {
2445                     tokenIds[tokenIdsIdx++] = i;
2446                 }
2447             }
2448             return tokenIds;
2449         }
2450     }
2451 
2452     function __ERC721A_init(string memory name_, string memory symbol_) public {
2453         __Context_init_unchained();
2454         __ERC165_init_unchained();
2455         _name = name_;
2456         _symbol = symbol_;
2457         _currentIndex = _startTokenId();
2458     }
2459 
2460     /**
2461      * To change the starting tokenId, please override this function.
2462      */
2463     function _startTokenId() internal view virtual returns (uint256) {
2464         return 1; // SB: change to start from 1 - modified from original 0. since others SB's code reserve 0 for a random stuff
2465     }
2466 
2467     /**
2468      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
2469      */
2470     function totalSupply() public view returns (uint256) {
2471         // Counter underflow is impossible as _burnCounter cannot be incremented
2472         // more than _currentIndex - _startTokenId() times
2473         unchecked {
2474             return _currentIndex - _burnCounter - _startTokenId();
2475         }
2476     }
2477 
2478     /**
2479      * Returns the total amount of tokens minted in the contract.
2480      */
2481     function _totalMinted() internal view returns (uint256) {
2482         // Counter underflow is impossible as _currentIndex does not decrement,
2483         // and it is initialized to _startTokenId()
2484         unchecked {
2485             return _currentIndex - _startTokenId();
2486         }
2487     }
2488 
2489     /**
2490      * @dev See {IERC165-supportsInterface}.
2491      */
2492     function supportsInterface(bytes4 interfaceId)
2493         public
2494         view
2495         virtual
2496         override(ERC165Upgradeable, IERC165Upgradeable)
2497         returns (bool)
2498     {
2499         return
2500             interfaceId == type(IERC721Upgradeable).interfaceId ||
2501             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
2502             super.supportsInterface(interfaceId);
2503     }
2504 
2505     /**
2506      * @dev See {IERC721-balanceOf}.
2507      */
2508     function balanceOf(address owner) public view override returns (uint256) {
2509         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2510         return uint256(_addressData[owner].balance);
2511     }
2512 
2513     /**
2514      * Returns the number of tokens minted by `owner`.
2515      */
2516     function _numberMinted(address owner) internal view returns (uint256) {
2517         return uint256(_addressData[owner].numberMinted);
2518     }
2519 
2520     /**
2521      * Returns the number of tokens burned by or on behalf of `owner`.
2522      */
2523     function _numberBurned(address owner) internal view returns (uint256) {
2524         return uint256(_addressData[owner].numberBurned);
2525     }
2526 
2527     /**
2528      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2529      */
2530     function _getAux(address owner) internal view returns (uint64) {
2531         return _addressData[owner].aux;
2532     }
2533 
2534     /**
2535      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2536      * If there are multiple variables, please pack them into a uint64.
2537      */
2538     function _setAux(address owner, uint64 aux) internal {
2539         _addressData[owner].aux = aux;
2540     }
2541 
2542     /**
2543      * Gas spent here starts off proportional to the maximum mint batch size.
2544      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2545      */
2546     function _ownershipOf(uint256 tokenId)
2547         internal
2548         view
2549         returns (TokenOwnership memory)
2550     {
2551         uint256 curr = tokenId;
2552 
2553         unchecked {
2554             if (_startTokenId() <= curr && curr < _currentIndex) {
2555                 TokenOwnership memory ownership = _ownerships[curr];
2556                 if (!ownership.burned) {
2557                     if (ownership.addr != address(0)) {
2558                         return ownership;
2559                     }
2560                     // Invariant:
2561                     // There will always be an ownership that has an address and is not burned
2562                     // before an ownership that does not have an address and is not burned.
2563                     // Hence, curr will not underflow.
2564                     while (true) {
2565                         curr--;
2566                         ownership = _ownerships[curr];
2567                         if (ownership.addr != address(0)) {
2568                             return ownership;
2569                         }
2570                     }
2571                 }
2572             }
2573         }
2574         revert OwnerQueryForNonexistentToken();
2575     }
2576 
2577     /**
2578      * @dev See {IERC721-ownerOf}.
2579      */
2580     function ownerOf(uint256 tokenId) public view override returns (address) {
2581         return _ownershipOf(tokenId).addr;
2582     }
2583 
2584     /**
2585      * @dev See {IERC721Metadata-name}.
2586      */
2587     function name() public view virtual override returns (string memory) {
2588         return _name;
2589     }
2590 
2591     /**
2592      * @dev See {IERC721Metadata-symbol}.
2593      */
2594     function symbol() public view virtual override returns (string memory) {
2595         return _symbol;
2596     }
2597 
2598     /**
2599      * @dev See {IERC721Metadata-tokenURI}.
2600      */
2601     function tokenURI(uint256 tokenId)
2602         public
2603         view
2604         virtual
2605         override
2606         returns (string memory)
2607     {
2608         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2609 
2610         string memory baseURI = _baseURI();
2611         return
2612             bytes(baseURI).length != 0
2613                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
2614                 : "";
2615     }
2616 
2617     /**
2618      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2619      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2620      * by default, can be overriden in child contracts.
2621      */
2622     function _baseURI() internal view virtual returns (string memory) {
2623         return "";
2624     }
2625 
2626     /**
2627      * @dev See {IERC721-approve}.
2628      */
2629     function approve(address to, uint256 tokenId) public override {
2630         address owner = ownerOf(tokenId);
2631         if (to == owner) revert ApprovalToCurrentOwner();
2632 
2633         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2634             revert ApprovalCallerNotOwnerNorApproved();
2635         }
2636 
2637         _approve(to, tokenId, owner);
2638     }
2639 
2640     /**
2641      * @dev See {IERC721-getApproved}.
2642      */
2643     function getApproved(uint256 tokenId)
2644         public
2645         view
2646         override
2647         returns (address)
2648     {
2649         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2650 
2651         return _tokenApprovals[tokenId];
2652     }
2653 
2654     /**
2655      * @dev See {IERC721-setApprovalForAll}.
2656      */
2657     function setApprovalForAll(address operator, bool approved)
2658         public
2659         virtual
2660         override
2661     {
2662         if (operator == _msgSender()) revert ApproveToCaller();
2663 
2664         _operatorApprovals[_msgSender()][operator] = approved;
2665         emit ApprovalForAll(_msgSender(), operator, approved);
2666     }
2667 
2668     /**
2669      * @dev See {IERC721-isApprovedForAll}.
2670      */
2671     function isApprovedForAll(address owner, address operator)
2672         public
2673         view
2674         virtual
2675         override
2676         returns (bool)
2677     {
2678         return _operatorApprovals[owner][operator];
2679     }
2680 
2681     /**
2682      * @dev See {IERC721-transferFrom}.
2683      */
2684     function transferFrom(
2685         address from,
2686         address to,
2687         uint256 tokenId
2688     ) public virtual override {
2689         _transfer(from, to, tokenId);
2690     }
2691 
2692     /**
2693      * @dev See {IERC721-safeTransferFrom}.
2694      */
2695     function safeTransferFrom(
2696         address from,
2697         address to,
2698         uint256 tokenId
2699     ) public virtual override {
2700         safeTransferFrom(from, to, tokenId, "");
2701     }
2702 
2703     /**
2704      * @dev See {IERC721-safeTransferFrom}.
2705      */
2706     function safeTransferFrom(
2707         address from,
2708         address to,
2709         uint256 tokenId,
2710         bytes memory _data
2711     ) public virtual override {
2712         _transfer(from, to, tokenId);
2713         if (
2714             to.isContract() &&
2715             !_checkContractOnERC721Received(from, to, tokenId, _data)
2716         ) {
2717             revert TransferToNonERC721ReceiverImplementer();
2718         }
2719     }
2720 
2721     /**
2722      * @dev Returns whether `tokenId` exists.
2723      *
2724      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2725      *
2726      * Tokens start existing when they are minted (`_mint`),
2727      */
2728     function _exists(uint256 tokenId) internal view returns (bool) {
2729         return
2730             _startTokenId() <= tokenId &&
2731             tokenId < _currentIndex &&
2732             !_ownerships[tokenId].burned;
2733     }
2734 
2735     /**
2736      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2737      */
2738     function _safeMint(address to, uint256 quantity) internal {
2739         _safeMint(to, quantity, "");
2740     }
2741 
2742     /**
2743      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2744      *
2745      * Requirements:
2746      *
2747      * - If `to` refers to a smart contract, it must implement
2748      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2749      * - `quantity` must be greater than 0.
2750      *
2751      * Emits a {Transfer} event.
2752      */
2753     function _safeMint(
2754         address to,
2755         uint256 quantity,
2756         bytes memory _data
2757     ) internal {
2758         uint256 startTokenId = _currentIndex;
2759         if (to == address(0)) revert MintToZeroAddress();
2760         if (quantity == 0) revert MintZeroQuantity();
2761 
2762         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2763 
2764         // Overflows are incredibly unrealistic.
2765         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2766         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2767         unchecked {
2768             _addressData[to].balance += uint64(quantity);
2769             _addressData[to].numberMinted += uint64(quantity);
2770 
2771             _ownerships[startTokenId].addr = to;
2772             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2773 
2774             uint256 updatedIndex = startTokenId;
2775             uint256 end = updatedIndex + quantity;
2776 
2777             if (to.isContract()) {
2778                 do {
2779                     emit Transfer(address(0), to, updatedIndex);
2780                     if (
2781                         !_checkContractOnERC721Received(
2782                             address(0),
2783                             to,
2784                             updatedIndex++,
2785                             _data
2786                         )
2787                     ) {
2788                         revert TransferToNonERC721ReceiverImplementer();
2789                     }
2790                 } while (updatedIndex != end);
2791                 // Reentrancy protection
2792                 if (_currentIndex != startTokenId) revert();
2793             } else {
2794                 do {
2795                     emit Transfer(address(0), to, updatedIndex++);
2796                 } while (updatedIndex != end);
2797             }
2798             _currentIndex = updatedIndex;
2799         }
2800         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2801     }
2802 
2803     /**
2804      * @dev Mints `quantity` tokens and transfers them to `to`.
2805      *
2806      * Requirements:
2807      *
2808      * - `to` cannot be the zero address.
2809      * - `quantity` must be greater than 0.
2810      *
2811      * Emits a {Transfer} event.
2812      */
2813     function _mint(address to, uint256 quantity) internal {
2814         uint256 startTokenId = _currentIndex;
2815         if (to == address(0)) revert MintToZeroAddress();
2816         if (quantity == 0) revert MintZeroQuantity();
2817 
2818         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2819 
2820         // Overflows are incredibly unrealistic.
2821         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2822         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2823         unchecked {
2824             _addressData[to].balance += uint64(quantity);
2825             _addressData[to].numberMinted += uint64(quantity);
2826 
2827             _ownerships[startTokenId].addr = to;
2828             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2829 
2830             uint256 updatedIndex = startTokenId;
2831             uint256 end = updatedIndex + quantity;
2832 
2833             do {
2834                 emit Transfer(address(0), to, updatedIndex++);
2835             } while (updatedIndex != end);
2836 
2837             _currentIndex = updatedIndex;
2838         }
2839         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2840     }
2841 
2842     /**
2843      * @dev Transfers `tokenId` from `from` to `to`.
2844      *
2845      * Requirements:
2846      *
2847      * - `to` cannot be the zero address.
2848      * - `tokenId` token must be owned by `from`.
2849      *
2850      * Emits a {Transfer} event.
2851      */
2852     function _transfer(
2853         address from,
2854         address to,
2855         uint256 tokenId
2856     ) private {
2857         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2858 
2859         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2860 
2861         bool isApprovedOrOwner = (_msgSender() == from ||
2862             isApprovedForAll(from, _msgSender()) ||
2863             getApproved(tokenId) == _msgSender());
2864 
2865         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2866         if (to == address(0)) revert TransferToZeroAddress();
2867 
2868         _beforeTokenTransfers(from, to, tokenId, 1);
2869 
2870         // Clear approvals from the previous owner
2871         _approve(address(0), tokenId, from);
2872 
2873         // Underflow of the sender's balance is impossible because we check for
2874         // ownership above and the recipient's balance can't realistically overflow.
2875         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2876         unchecked {
2877             _addressData[from].balance -= 1;
2878             _addressData[to].balance += 1;
2879 
2880             TokenOwnership storage currSlot = _ownerships[tokenId];
2881             currSlot.addr = to;
2882             currSlot.startTimestamp = uint64(block.timestamp);
2883 
2884             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2885             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2886             uint256 nextTokenId = tokenId + 1;
2887             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2888             if (nextSlot.addr == address(0)) {
2889                 // This will suffice for checking _exists(nextTokenId),
2890                 // as a burned slot cannot contain the zero address.
2891                 if (nextTokenId != _currentIndex) {
2892                     nextSlot.addr = from;
2893                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2894                 }
2895             }
2896         }
2897 
2898         emit Transfer(from, to, tokenId);
2899         _afterTokenTransfers(from, to, tokenId, 1);
2900     }
2901 
2902     /**
2903      * @dev Equivalent to `_burn(tokenId, false)`.
2904      */
2905     function _burn(uint256 tokenId) internal virtual {
2906         _burn(tokenId, false);
2907     }
2908 
2909     /**
2910      * @dev Destroys `tokenId`.
2911      * The approval is cleared when the token is burned.
2912      *
2913      * Requirements:
2914      *
2915      * - `tokenId` must exist.
2916      *
2917      * Emits a {Transfer} event.
2918      */
2919     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2920         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2921 
2922         address from = prevOwnership.addr;
2923 
2924         if (approvalCheck) {
2925             bool isApprovedOrOwner = (_msgSender() == from ||
2926                 isApprovedForAll(from, _msgSender()) ||
2927                 getApproved(tokenId) == _msgSender());
2928 
2929             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2930         }
2931 
2932         _beforeTokenTransfers(from, address(0), tokenId, 1);
2933 
2934         // Clear approvals from the previous owner
2935         _approve(address(0), tokenId, from);
2936 
2937         // Underflow of the sender's balance is impossible because we check for
2938         // ownership above and the recipient's balance can't realistically overflow.
2939         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2940         unchecked {
2941             AddressData storage addressData = _addressData[from];
2942             addressData.balance -= 1;
2943             addressData.numberBurned += 1;
2944 
2945             // Keep track of who burned the token, and the timestamp of burning.
2946             TokenOwnership storage currSlot = _ownerships[tokenId];
2947             currSlot.addr = from;
2948             currSlot.startTimestamp = uint64(block.timestamp);
2949             currSlot.burned = true;
2950 
2951             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2952             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2953             uint256 nextTokenId = tokenId + 1;
2954             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2955             if (nextSlot.addr == address(0)) {
2956                 // This will suffice for checking _exists(nextTokenId),
2957                 // as a burned slot cannot contain the zero address.
2958                 if (nextTokenId != _currentIndex) {
2959                     nextSlot.addr = from;
2960                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2961                 }
2962             }
2963         }
2964 
2965         emit Transfer(from, address(0), tokenId);
2966         _afterTokenTransfers(from, address(0), tokenId, 1);
2967 
2968         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2969         unchecked {
2970             _burnCounter++;
2971         }
2972     }
2973 
2974     /**
2975      * @dev Approve `to` to operate on `tokenId`
2976      *
2977      * Emits a {Approval} event.
2978      */
2979     function _approve(
2980         address to,
2981         uint256 tokenId,
2982         address owner
2983     ) private {
2984         _tokenApprovals[tokenId] = to;
2985         emit Approval(owner, to, tokenId);
2986     }
2987 
2988     /**
2989      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2990      *
2991      * @param from address representing the previous owner of the given token ID
2992      * @param to target address that will receive the tokens
2993      * @param tokenId uint256 ID of the token to be transferred
2994      * @param _data bytes optional data to send along with the call
2995      * @return bool whether the call correctly returned the expected magic value
2996      */
2997     function _checkContractOnERC721Received(
2998         address from,
2999         address to,
3000         uint256 tokenId,
3001         bytes memory _data
3002     ) private returns (bool) {
3003         try
3004             IERC721Receiver(to).onERC721Received(
3005                 _msgSender(),
3006                 from,
3007                 tokenId,
3008                 _data
3009             )
3010         returns (bytes4 retval) {
3011             return retval == IERC721Receiver(to).onERC721Received.selector;
3012         } catch (bytes memory reason) {
3013             if (reason.length == 0) {
3014                 revert TransferToNonERC721ReceiverImplementer();
3015             } else {
3016                 assembly {
3017                     revert(add(32, reason), mload(reason))
3018                 }
3019             }
3020         }
3021     }
3022 
3023     /**
3024      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
3025      * And also called before burning one token.
3026      *
3027      * startTokenId - the first token id to be transferred
3028      * quantity - the amount to be transferred
3029      *
3030      * Calling conditions:
3031      *
3032      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3033      * transferred to `to`.
3034      * - When `from` is zero, `tokenId` will be minted for `to`.
3035      * - When `to` is zero, `tokenId` will be burned by `from`.
3036      * - `from` and `to` are never both zero.
3037      */
3038     function _beforeTokenTransfers(
3039         address from,
3040         address to,
3041         uint256 startTokenId,
3042         uint256 quantity
3043     ) internal virtual {}
3044 
3045     /**
3046      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
3047      * minting.
3048      * And also called after one token has been burned.
3049      *
3050      * startTokenId - the first token id to be transferred
3051      * quantity - the amount to be transferred
3052      *
3053      * Calling conditions:
3054      *
3055      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
3056      * transferred to `to`.
3057      * - When `from` is zero, `tokenId` has been minted for `to`.
3058      * - When `to` is zero, `tokenId` has been burned by `from`.
3059      * - `from` and `to` are never both zero.
3060      */
3061     function _afterTokenTransfers(
3062         address from,
3063         address to,
3064         uint256 startTokenId,
3065         uint256 quantity
3066     ) internal virtual {}
3067 }
3068 
3069 // File: @openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol
3070 
3071 
3072 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
3073 
3074 pragma solidity ^0.8.0;
3075 
3076 
3077 
3078 
3079 
3080 
3081 /**
3082  * @dev Contract module that allows children to implement role-based access
3083  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
3084  * members except through off-chain means by accessing the contract event logs. Some
3085  * applications may benefit from on-chain enumerability, for those cases see
3086  * {AccessControlEnumerable}.
3087  *
3088  * Roles are referred to by their `bytes32` identifier. These should be exposed
3089  * in the external API and be unique. The best way to achieve this is by
3090  * using `public constant` hash digests:
3091  *
3092  * ```
3093  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
3094  * ```
3095  *
3096  * Roles can be used to represent a set of permissions. To restrict access to a
3097  * function call, use {hasRole}:
3098  *
3099  * ```
3100  * function foo() public {
3101  *     require(hasRole(MY_ROLE, msg.sender));
3102  *     ...
3103  * }
3104  * ```
3105  *
3106  * Roles can be granted and revoked dynamically via the {grantRole} and
3107  * {revokeRole} functions. Each role has an associated admin role, and only
3108  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
3109  *
3110  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
3111  * that only accounts with this role will be able to grant or revoke other
3112  * roles. More complex role relationships can be created by using
3113  * {_setRoleAdmin}.
3114  *
3115  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
3116  * grant and revoke this role. Extra precautions should be taken to secure
3117  * accounts that have been granted it.
3118  */
3119 abstract contract AccessControlUpgradeable is Initializable, ContextUpgradeable, IAccessControlUpgradeable, ERC165Upgradeable {
3120     function __AccessControl_init() internal onlyInitializing {
3121     }
3122 
3123     function __AccessControl_init_unchained() internal onlyInitializing {
3124     }
3125     struct RoleData {
3126         mapping(address => bool) members;
3127         bytes32 adminRole;
3128     }
3129 
3130     mapping(bytes32 => RoleData) private _roles;
3131 
3132     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
3133 
3134     /**
3135      * @dev Modifier that checks that an account has a specific role. Reverts
3136      * with a standardized message including the required role.
3137      *
3138      * The format of the revert reason is given by the following regular expression:
3139      *
3140      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3141      *
3142      * _Available since v4.1._
3143      */
3144     modifier onlyRole(bytes32 role) {
3145         _checkRole(role);
3146         _;
3147     }
3148 
3149     /**
3150      * @dev See {IERC165-supportsInterface}.
3151      */
3152     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3153         return interfaceId == type(IAccessControlUpgradeable).interfaceId || super.supportsInterface(interfaceId);
3154     }
3155 
3156     /**
3157      * @dev Returns `true` if `account` has been granted `role`.
3158      */
3159     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
3160         return _roles[role].members[account];
3161     }
3162 
3163     /**
3164      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
3165      * Overriding this function changes the behavior of the {onlyRole} modifier.
3166      *
3167      * Format of the revert message is described in {_checkRole}.
3168      *
3169      * _Available since v4.6._
3170      */
3171     function _checkRole(bytes32 role) internal view virtual {
3172         _checkRole(role, _msgSender());
3173     }
3174 
3175     /**
3176      * @dev Revert with a standard message if `account` is missing `role`.
3177      *
3178      * The format of the revert reason is given by the following regular expression:
3179      *
3180      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
3181      */
3182     function _checkRole(bytes32 role, address account) internal view virtual {
3183         if (!hasRole(role, account)) {
3184             revert(
3185                 string(
3186                     abi.encodePacked(
3187                         "AccessControl: account ",
3188                         StringsUpgradeable.toHexString(uint160(account), 20),
3189                         " is missing role ",
3190                         StringsUpgradeable.toHexString(uint256(role), 32)
3191                     )
3192                 )
3193             );
3194         }
3195     }
3196 
3197     /**
3198      * @dev Returns the admin role that controls `role`. See {grantRole} and
3199      * {revokeRole}.
3200      *
3201      * To change a role's admin, use {_setRoleAdmin}.
3202      */
3203     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
3204         return _roles[role].adminRole;
3205     }
3206 
3207     /**
3208      * @dev Grants `role` to `account`.
3209      *
3210      * If `account` had not been already granted `role`, emits a {RoleGranted}
3211      * event.
3212      *
3213      * Requirements:
3214      *
3215      * - the caller must have ``role``'s admin role.
3216      */
3217     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3218         _grantRole(role, account);
3219     }
3220 
3221     /**
3222      * @dev Revokes `role` from `account`.
3223      *
3224      * If `account` had been granted `role`, emits a {RoleRevoked} event.
3225      *
3226      * Requirements:
3227      *
3228      * - the caller must have ``role``'s admin role.
3229      */
3230     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
3231         _revokeRole(role, account);
3232     }
3233 
3234     /**
3235      * @dev Revokes `role` from the calling account.
3236      *
3237      * Roles are often managed via {grantRole} and {revokeRole}: this function's
3238      * purpose is to provide a mechanism for accounts to lose their privileges
3239      * if they are compromised (such as when a trusted device is misplaced).
3240      *
3241      * If the calling account had been revoked `role`, emits a {RoleRevoked}
3242      * event.
3243      *
3244      * Requirements:
3245      *
3246      * - the caller must be `account`.
3247      */
3248     function renounceRole(bytes32 role, address account) public virtual override {
3249         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
3250 
3251         _revokeRole(role, account);
3252     }
3253 
3254     /**
3255      * @dev Grants `role` to `account`.
3256      *
3257      * If `account` had not been already granted `role`, emits a {RoleGranted}
3258      * event. Note that unlike {grantRole}, this function doesn't perform any
3259      * checks on the calling account.
3260      *
3261      * [WARNING]
3262      * ====
3263      * This function should only be called from the constructor when setting
3264      * up the initial roles for the system.
3265      *
3266      * Using this function in any other way is effectively circumventing the admin
3267      * system imposed by {AccessControl}.
3268      * ====
3269      *
3270      * NOTE: This function is deprecated in favor of {_grantRole}.
3271      */
3272     function _setupRole(bytes32 role, address account) internal virtual {
3273         _grantRole(role, account);
3274     }
3275 
3276     /**
3277      * @dev Sets `adminRole` as ``role``'s admin role.
3278      *
3279      * Emits a {RoleAdminChanged} event.
3280      */
3281     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
3282         bytes32 previousAdminRole = getRoleAdmin(role);
3283         _roles[role].adminRole = adminRole;
3284         emit RoleAdminChanged(role, previousAdminRole, adminRole);
3285     }
3286 
3287     /**
3288      * @dev Grants `role` to `account`.
3289      *
3290      * Internal function without access restriction.
3291      */
3292     function _grantRole(bytes32 role, address account) internal virtual {
3293         if (!hasRole(role, account)) {
3294             _roles[role].members[account] = true;
3295             emit RoleGranted(role, account, _msgSender());
3296         }
3297     }
3298 
3299     /**
3300      * @dev Revokes `role` from `account`.
3301      *
3302      * Internal function without access restriction.
3303      */
3304     function _revokeRole(bytes32 role, address account) internal virtual {
3305         if (hasRole(role, account)) {
3306             _roles[role].members[account] = false;
3307             emit RoleRevoked(role, account, _msgSender());
3308         }
3309     }
3310 
3311     /**
3312      * @dev This empty reserved space is put in place to allow future versions to add new
3313      * variables without shifting down storage in the inheritance chain.
3314      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3315      */
3316     uint256[49] private __gap;
3317 }
3318 
3319 // File: @openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol
3320 
3321 
3322 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControlEnumerable.sol)
3323 
3324 pragma solidity ^0.8.0;
3325 
3326 
3327 
3328 
3329 
3330 /**
3331  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
3332  */
3333 abstract contract AccessControlEnumerableUpgradeable is Initializable, IAccessControlEnumerableUpgradeable, AccessControlUpgradeable {
3334     function __AccessControlEnumerable_init() internal onlyInitializing {
3335     }
3336 
3337     function __AccessControlEnumerable_init_unchained() internal onlyInitializing {
3338     }
3339     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
3340 
3341     mapping(bytes32 => EnumerableSetUpgradeable.AddressSet) private _roleMembers;
3342 
3343     /**
3344      * @dev See {IERC165-supportsInterface}.
3345      */
3346     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
3347         return interfaceId == type(IAccessControlEnumerableUpgradeable).interfaceId || super.supportsInterface(interfaceId);
3348     }
3349 
3350     /**
3351      * @dev Returns one of the accounts that have `role`. `index` must be a
3352      * value between 0 and {getRoleMemberCount}, non-inclusive.
3353      *
3354      * Role bearers are not sorted in any particular way, and their ordering may
3355      * change at any point.
3356      *
3357      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
3358      * you perform all queries on the same block. See the following
3359      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
3360      * for more information.
3361      */
3362     function getRoleMember(bytes32 role, uint256 index) public view virtual override returns (address) {
3363         return _roleMembers[role].at(index);
3364     }
3365 
3366     /**
3367      * @dev Returns the number of accounts that have `role`. Can be used
3368      * together with {getRoleMember} to enumerate all bearers of a role.
3369      */
3370     function getRoleMemberCount(bytes32 role) public view virtual override returns (uint256) {
3371         return _roleMembers[role].length();
3372     }
3373 
3374     /**
3375      * @dev Overload {_grantRole} to track enumerable memberships
3376      */
3377     function _grantRole(bytes32 role, address account) internal virtual override {
3378         super._grantRole(role, account);
3379         _roleMembers[role].add(account);
3380     }
3381 
3382     /**
3383      * @dev Overload {_revokeRole} to track enumerable memberships
3384      */
3385     function _revokeRole(bytes32 role, address account) internal virtual override {
3386         super._revokeRole(role, account);
3387         _roleMembers[role].remove(account);
3388     }
3389 
3390     /**
3391      * @dev This empty reserved space is put in place to allow future versions to add new
3392      * variables without shifting down storage in the inheritance chain.
3393      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3394      */
3395     uint256[49] private __gap;
3396 }
3397 
3398 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
3399 
3400 
3401 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
3402 
3403 pragma solidity ^0.8.0;
3404 
3405 
3406 /**
3407  * @dev Contract module that helps prevent reentrant calls to a function.
3408  *
3409  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
3410  * available, which can be applied to functions to make sure there are no nested
3411  * (reentrant) calls to them.
3412  *
3413  * Note that because there is a single `nonReentrant` guard, functions marked as
3414  * `nonReentrant` may not call one another. This can be worked around by making
3415  * those functions `private`, and then adding `external` `nonReentrant` entry
3416  * points to them.
3417  *
3418  * TIP: If you would like to learn more about reentrancy and alternative ways
3419  * to protect against it, check out our blog post
3420  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
3421  */
3422 abstract contract ReentrancyGuardUpgradeable is Initializable {
3423     // Booleans are more expensive than uint256 or any type that takes up a full
3424     // word because each write operation emits an extra SLOAD to first read the
3425     // slot's contents, replace the bits taken up by the boolean, and then write
3426     // back. This is the compiler's defense against contract upgrades and
3427     // pointer aliasing, and it cannot be disabled.
3428 
3429     // The values being non-zero value makes deployment a bit more expensive,
3430     // but in exchange the refund on every call to nonReentrant will be lower in
3431     // amount. Since refunds are capped to a percentage of the total
3432     // transaction's gas, it is best to keep them low in cases like this one, to
3433     // increase the likelihood of the full refund coming into effect.
3434     uint256 private constant _NOT_ENTERED = 1;
3435     uint256 private constant _ENTERED = 2;
3436 
3437     uint256 private _status;
3438 
3439     function __ReentrancyGuard_init() internal onlyInitializing {
3440         __ReentrancyGuard_init_unchained();
3441     }
3442 
3443     function __ReentrancyGuard_init_unchained() internal onlyInitializing {
3444         _status = _NOT_ENTERED;
3445     }
3446 
3447     /**
3448      * @dev Prevents a contract from calling itself, directly or indirectly.
3449      * Calling a `nonReentrant` function from another `nonReentrant`
3450      * function is not supported. It is possible to prevent this from happening
3451      * by making the `nonReentrant` function external, and making it call a
3452      * `private` function that does the actual work.
3453      */
3454     modifier nonReentrant() {
3455         // On the first call to nonReentrant, _notEntered will be true
3456         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
3457 
3458         // Any calls to nonReentrant after this point will fail
3459         _status = _ENTERED;
3460 
3461         _;
3462 
3463         // By storing the original value once again, a refund is triggered (see
3464         // https://eips.ethereum.org/EIPS/eip-2200)
3465         _status = _NOT_ENTERED;
3466     }
3467 
3468     /**
3469      * @dev This empty reserved space is put in place to allow future versions to add new
3470      * variables without shifting down storage in the inheritance chain.
3471      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
3472      */
3473     uint256[49] private __gap;
3474 }
3475 
3476 // File: SBII721A.sol
3477 
3478 
3479 // author: yoyoismee.eth -- it's opensource but also feel free to send me coffee/beer.
3480 //  ╔═╗┌─┐┌─┐┌─┐┌┬┐┌┐ ┌─┐┌─┐┌┬┐┌─┐┌┬┐┬ ┬┌┬┐┬┌─┐
3481 //  ╚═╗├─┘├┤ ├┤  ││├┴┐│ │├─┤ │ └─┐ │ │ │ ││││ │
3482 //  ╚═╝┴  └─┘└─┘─┴┘└─┘└─┘┴ ┴ ┴o└─┘ ┴ └─┘─┴┘┴└─┘
3483 
3484 pragma solidity 0.8.14;
3485 
3486 
3487 
3488 
3489 
3490 
3491 
3492 
3493 
3494 
3495 
3496 
3497 
3498 
3499 // @dev speedboat v2 erc721A = modified SBII721A
3500 // @dev should treat this code as experimental.
3501 contract SBII721A is
3502     Initializable,
3503     ERC721ASBUpgradable,
3504     ReentrancyGuardUpgradeable,
3505     AccessControlEnumerableUpgradeable,
3506     ISBMintable,
3507     ISBShipable
3508 {
3509     using EnumerableSetUpgradeable for EnumerableSetUpgradeable.AddressSet;
3510     using StringsUpgradeable for uint256;
3511     using SafeERC20 for IERC20;
3512 
3513     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
3514     string public constant MODEL = "SBII-721A-0";
3515 
3516     struct Round {
3517         uint128 price;
3518         uint32 quota;
3519         uint16 amountPerUser;
3520         bool isActive;
3521         bool isPublic;
3522         bool isMerkleMode; // merkleMode will override price, amountPerUser, and TokenID if specify
3523         bool exist;
3524         address tokenAddress; // 0 for base asset
3525     }
3526 
3527     struct Conf {
3528         bool allowNFTUpdate;
3529         bool allowConfUpdate;
3530         bool allowContract;
3531         bool allowPrivilege;
3532         bool randomAccessMode;
3533         bool allowTarget;
3534         bool allowLazySell;
3535         uint64 maxSupply;
3536     }
3537 
3538     Conf public config;
3539     string[] public roundNames;
3540 
3541     mapping(bytes32 => EnumerableSetUpgradeable.AddressSet) private walletList;
3542     mapping(bytes32 => bytes32) private merkleRoot;
3543     mapping(bytes32 => Round) private roundData;
3544     mapping(uint256 => bool) public nonceUsed;
3545 
3546     mapping(bytes32 => mapping(address => uint256)) mintedInRound;
3547 
3548     string private _baseTokenURI;
3549     address private feeReceiver;
3550     uint256 private bip;
3551     address public beneficiary;
3552 
3553     function listRole()
3554         public
3555         pure
3556         returns (string[] memory names, bytes32[] memory code)
3557     {
3558         names = new string[](2);
3559         code = new bytes32[](2);
3560 
3561         names[0] = "MINTER";
3562         names[1] = "ADMIN";
3563 
3564         code[0] = MINTER_ROLE;
3565         code[1] = DEFAULT_ADMIN_ROLE;
3566     }
3567 
3568     function grantRoles(bytes32 role, address[] calldata accounts) public {
3569         for (uint256 i = 0; i < accounts.length; i++) {
3570             super.grantRole(role, accounts[i]);
3571         }
3572     }
3573 
3574     function revokeRoles(bytes32 role, address[] calldata accounts) public {
3575         for (uint256 i = 0; i < accounts.length; i++) {
3576             super.revokeRole(role, accounts[i]);
3577         }
3578     }
3579 
3580     function setBeneficiary(address _beneficiary)
3581         public
3582         onlyRole(DEFAULT_ADMIN_ROLE)
3583     {
3584         require(beneficiary == address(0), "as");
3585         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3586         beneficiary = _beneficiary;
3587     }
3588 
3589     // 0 = unlimited, can only set once.
3590     function setMaxSupply(uint64 _maxSupply)
3591         public
3592         onlyRole(DEFAULT_ADMIN_ROLE)
3593     {
3594         require(config.maxSupply == 0, "as");
3595         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3596         config.maxSupply = _maxSupply;
3597     }
3598 
3599     function listRoleWallet(bytes32 role)
3600         public
3601         view
3602         returns (address[] memory roleMembers)
3603     {
3604         uint256 count = getRoleMemberCount(role);
3605         roleMembers = new address[](count);
3606         for (uint256 i = 0; i < count; i++) {
3607             roleMembers[i] = getRoleMember(role, i);
3608         }
3609     }
3610 
3611     function listToken(address wallet)
3612         public
3613         view
3614         returns (uint256[] memory tokenList)
3615     {
3616         return tokensOfOwner(wallet);
3617     }
3618 
3619     function listRounds() public view returns (string[] memory) {
3620         return roundNames;
3621     }
3622 
3623     function roundInfo(string memory roundName)
3624         public
3625         view
3626         returns (Round memory)
3627     {
3628         return roundData[keccak256(abi.encodePacked(roundName))];
3629     }
3630 
3631     function massMint(address[] calldata wallets, uint256[] calldata amount)
3632         public
3633     {
3634         require(config.allowPrivilege, "disabled feature");
3635         require(hasRole(MINTER_ROLE, msg.sender), "pd");
3636         for (uint256 i = 0; i < wallets.length; i++) {
3637             mintNext(wallets[i], amount[i]);
3638         }
3639     }
3640 
3641     function mintNext(address reciever, uint256 amount) public override {
3642         require(config.allowPrivilege, "disabled feature");
3643         require(hasRole(MINTER_ROLE, msg.sender), "pd");
3644         _mintNext(reciever, amount);
3645     }
3646 
3647     function _mintNext(address reciever, uint256 amount) internal {
3648         if (config.maxSupply != 0) {
3649             require(totalSupply() + amount <= config.maxSupply);
3650         }
3651         _safeMint(reciever, amount); // 721A mint
3652     }
3653 
3654     function _random(address ad, uint256 num) internal returns (uint256) {
3655         revert("not supported by 721a la");
3656     }
3657 
3658     function updateURI(string memory newURI)
3659         public
3660         onlyRole(DEFAULT_ADMIN_ROLE)
3661     {
3662         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3663         require(config.allowNFTUpdate, "na");
3664         _baseTokenURI = newURI;
3665     }
3666 
3667     function mintTarget(address reciever, uint256 target) public override {
3668         revert("not supported by 721a la");
3669     }
3670 
3671     function requestMint(Round storage thisRound, uint256 amount) internal {
3672         require(thisRound.isActive, "not active");
3673         require(thisRound.quota >= amount, "out of stock");
3674         if (!config.allowContract) {
3675             require(tx.origin == msg.sender);
3676         }
3677         thisRound.quota -= uint32(amount);
3678     }
3679 
3680     /// magic overload
3681 
3682     function mint(string memory roundName, uint256 amount)
3683         public
3684         payable
3685         nonReentrant
3686     {
3687         bytes32 key = keccak256(abi.encodePacked(roundName));
3688         Round storage thisRound = roundData[key];
3689 
3690         requestMint(thisRound, amount);
3691 
3692         // require(thisRound.isActive, "not active");
3693         // require(thisRound.quota >= amount, "out of stock");
3694         // if (!config.allowContract) {
3695         //     require(tx.origin == msg.sender, "not allow contract");
3696         // }
3697         // thisRound.quota -= uint32(amount);
3698 
3699         require(!thisRound.isMerkleMode, "wrong data");
3700 
3701         if (!thisRound.isPublic) {
3702             require(walletList[key].contains(msg.sender));
3703             require(
3704                 mintedInRound[key][msg.sender] + amount <=
3705                     thisRound.amountPerUser,
3706                 "out of quota"
3707             );
3708             mintedInRound[key][msg.sender] += amount;
3709         } else {
3710             require(amount <= thisRound.amountPerUser, "nope"); // public round can mint multiple time
3711         }
3712 
3713         paymentUtil.processPayment(
3714             thisRound.tokenAddress,
3715             thisRound.price * amount
3716         );
3717 
3718         _mintNext(msg.sender, amount);
3719     }
3720 
3721     function mint(
3722         string memory roundName,
3723         address wallet,
3724         uint256 amount,
3725         uint256 tokenID,
3726         uint256 nonce,
3727         uint256 pricePerUnit,
3728         address denominatedAsset,
3729         bytes32[] memory proof
3730     ) public payable {
3731         bytes32 key = keccak256(abi.encodePacked(roundName));
3732         Round storage thisRound = roundData[key];
3733 
3734         requestMint(thisRound, amount);
3735 
3736         // require(thisRound.isActive, "not active");
3737         // require(thisRound.quota >= amount, "out of quota");
3738         // thisRound.quota -= uint32(amount);
3739 
3740         require(thisRound.isMerkleMode, "invalid");
3741 
3742         bytes32 data = hash(
3743             wallet,
3744             amount,
3745             tokenID,
3746             nonce,
3747             pricePerUnit,
3748             denominatedAsset,
3749             address(this),
3750             block.chainid
3751         );
3752         require(_merkleCheck(data, merkleRoot[key], proof), "fail merkle");
3753 
3754         _useNonce(nonce);
3755         if (wallet != address(0)) {
3756             require(wallet == msg.sender, "nope");
3757         }
3758 
3759         require(amount > 0, "pick one"); // such a lazy check lol
3760         require(tokenID == 0, "nope"); // such a lazy check lol
3761 
3762         paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
3763         _mintNext(wallet, amount);
3764     }
3765 
3766     function mint(
3767         address wallet,
3768         uint256 amount,
3769         uint256 tokenID,
3770         uint256 nonce,
3771         uint256 pricePerUnit,
3772         address denominatedAsset,
3773         bytes memory signature
3774     ) public payable {
3775         bytes32 data = hash(
3776             wallet,
3777             amount,
3778             tokenID,
3779             nonce,
3780             pricePerUnit,
3781             denominatedAsset,
3782             address(this),
3783             block.chainid
3784         );
3785         require(config.allowLazySell, "na");
3786         require(config.allowPrivilege, "na");
3787 
3788         require(_verifySig(data, signature));
3789 
3790         _useNonce(nonce);
3791         if (wallet != address(0)) {
3792             require(wallet == msg.sender, "nope");
3793         }
3794 
3795         require(amount > 0, "pick one"); // such a lazy check lol
3796         require(tokenID == 0, "nope"); // such a lazy check lol
3797 
3798         paymentUtil.processPayment(denominatedAsset, pricePerUnit * amount);
3799         _mintNext(wallet, amount);
3800     }
3801 
3802     /// magic overload end
3803 
3804     // this is 721 version. in 20 or 1155 will use the same format but different interpretation
3805     // wallet = 0 mean any
3806     // tokenID = 0 mean next
3807     // amount will overide tokenID
3808     // denominatedAsset = 0 mean chain token (e.g. eth)
3809     // chainID is to prevent replay attack
3810 
3811     function hash(
3812         address wallet,
3813         uint256 amount,
3814         uint256 tokenID,
3815         uint256 nonce,
3816         uint256 pricePerUnit,
3817         address denominatedAsset,
3818         address refPorject,
3819         uint256 chainID
3820     ) public pure returns (bytes32) {
3821         return
3822             keccak256(
3823                 abi.encodePacked(
3824                     wallet,
3825                     amount,
3826                     tokenID,
3827                     nonce,
3828                     pricePerUnit,
3829                     denominatedAsset,
3830                     refPorject,
3831                     chainID
3832                 )
3833             );
3834     }
3835 
3836     function _toSignedHash(bytes32 data) internal pure returns (bytes32) {
3837         return ECDSA.toEthSignedMessageHash(data);
3838     }
3839 
3840     function _verifySig(bytes32 data, bytes memory signature)
3841         public
3842         view
3843         returns (bool)
3844     {
3845         return
3846             hasRole(MINTER_ROLE, ECDSA.recover(_toSignedHash(data), signature));
3847     }
3848 
3849     function _merkleCheck(
3850         bytes32 data,
3851         bytes32 root,
3852         bytes32[] memory merkleProof
3853     ) internal pure returns (bool) {
3854         return MerkleProof.verify(merkleProof, root, data);
3855     }
3856 
3857     /// ROUND
3858 
3859     function newRound(
3860         string memory roundName,
3861         uint128 _price,
3862         uint32 _quota,
3863         uint16 _amountPerUser,
3864         bool _isActive,
3865         bool _isPublic,
3866         bool _isMerkle,
3867         address _tokenAddress
3868     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
3869         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3870         bytes32 key = keccak256(abi.encodePacked(roundName));
3871 
3872         require(!roundData[key].exist, "already exist");
3873         roundNames.push(roundName);
3874         roundData[key] = Round({
3875             price: _price,
3876             quota: _quota,
3877             amountPerUser: _amountPerUser,
3878             isActive: _isActive,
3879             isPublic: _isPublic,
3880             isMerkleMode: _isMerkle,
3881             tokenAddress: _tokenAddress,
3882             exist: true
3883         });
3884     }
3885 
3886     function triggerRound(string memory roundName, bool _isActive)
3887         public
3888         onlyRole(DEFAULT_ADMIN_ROLE)
3889     {
3890         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3891         bytes32 key = keccak256(abi.encodePacked(roundName));
3892         roundData[key].isActive = _isActive;
3893     }
3894 
3895     function setMerkleRoot(string memory roundName, bytes32 root)
3896         public
3897         onlyRole(DEFAULT_ADMIN_ROLE)
3898     {
3899         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3900         bytes32 key = keccak256(abi.encodePacked(roundName));
3901         merkleRoot[key] = root;
3902     }
3903 
3904     function updateRound(
3905         string memory roundName,
3906         uint128 _price,
3907         uint32 _quota,
3908         uint16 _amountPerUser,
3909         bool _isPublic
3910     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
3911         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3912         bytes32 key = keccak256(abi.encodePacked(roundName));
3913         roundData[key].price = _price;
3914         roundData[key].quota = _quota;
3915         roundData[key].amountPerUser = _amountPerUser;
3916         roundData[key].isPublic = _isPublic;
3917     }
3918 
3919     function addRoundWallet(string memory roundName, address[] memory wallets)
3920         public
3921         onlyRole(DEFAULT_ADMIN_ROLE)
3922     {
3923         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3924         bytes32 key = keccak256(abi.encodePacked(roundName));
3925         for (uint256 i = 0; i < wallets.length; i++) {
3926             walletList[key].add(wallets[i]);
3927         }
3928     }
3929 
3930     function removeRoundWallet(
3931         string memory roundName,
3932         address[] memory wallets
3933     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
3934         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3935         bytes32 key = keccak256(abi.encodePacked(roundName));
3936         for (uint256 i = 0; i < wallets.length; i++) {
3937             walletList[key].remove(wallets[i]);
3938         }
3939     }
3940 
3941     function getRoundWallet(string memory roundName)
3942         public
3943         view
3944         returns (address[] memory)
3945     {
3946         return walletList[keccak256(abi.encodePacked(roundName))].values();
3947     }
3948 
3949     function isQualify(address wallet, string memory roundName)
3950         public
3951         view
3952         returns (bool)
3953     {
3954         Round memory x = roundInfo(roundName);
3955         if (!x.isActive) {
3956             return false;
3957         }
3958         if (x.quota == 0) {
3959             return false;
3960         }
3961         bytes32 key = keccak256(abi.encodePacked(roundName));
3962         if (!x.isPublic && !walletList[key].contains(wallet)) {
3963             return false;
3964         }
3965         if (mintedInRound[key][wallet] >= x.amountPerUser) {
3966             return false;
3967         }
3968         return true;
3969     }
3970 
3971     function listQualifiedRound(address wallet)
3972         public
3973         view
3974         returns (string[] memory)
3975     {
3976         string[] memory valid = new string[](roundNames.length);
3977         for (uint256 i = 0; i < roundNames.length; i++) {
3978             if (isQualify(wallet, roundNames[i])) {
3979                 valid[i] = roundNames[i];
3980             }
3981         }
3982         return valid;
3983     }
3984 
3985     function setNonce(uint256[] calldata nonces, bool status)
3986         external
3987         onlyRole(DEFAULT_ADMIN_ROLE)
3988     {
3989         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
3990         require(config.allowPrivilege, "df");
3991 
3992         for (uint256 i = 0; i < nonces.length; i++) {
3993             nonceUsed[nonces[i]] = status;
3994         }
3995     }
3996 
3997     function _useNonce(uint256 nonce) internal {
3998         require(!nonceUsed[nonce], "used");
3999         nonceUsed[nonce] = true;
4000     }
4001 
4002     /// ROUND end ///
4003 
4004     function initialize(
4005         bytes calldata initArg,
4006         uint128 _bip,
4007         address _feeReceiver
4008     ) public initializer {
4009         feeReceiver = _feeReceiver;
4010         bip = _bip;
4011 
4012         (
4013             string memory name,
4014             string memory symbol,
4015             string memory baseTokenURI,
4016             address owner,
4017             bool _allowNFTUpdate,
4018             bool _allowConfUpdate,
4019             bool _allowContract,
4020             bool _allowPrivilege,
4021             bool _randomAccessMode,
4022             bool _allowTarget,
4023             bool _allowLazySell
4024         ) = abi.decode(
4025                 initArg,
4026                 (
4027                     string,
4028                     string,
4029                     string,
4030                     address,
4031                     bool,
4032                     bool,
4033                     bool,
4034                     bool,
4035                     bool,
4036                     bool,
4037                     bool
4038                 )
4039             );
4040 
4041         __721AInit(name, symbol);
4042         _setupRole(DEFAULT_ADMIN_ROLE, owner);
4043         _setupRole(MINTER_ROLE, owner);
4044 
4045         _baseTokenURI = baseTokenURI;
4046         config = Conf({
4047             allowNFTUpdate: _allowNFTUpdate,
4048             allowConfUpdate: _allowConfUpdate,
4049             allowContract: _allowContract,
4050             allowPrivilege: _allowPrivilege,
4051             randomAccessMode: _randomAccessMode,
4052             allowTarget: _allowTarget,
4053             allowLazySell: _allowLazySell,
4054             maxSupply: 0
4055         });
4056     }
4057 
4058     function updateConfig(
4059         bool _allowNFTUpdate,
4060         bool _allowConfUpdate,
4061         bool _allowContract,
4062         bool _allowPrivilege,
4063         bool _allowTarget,
4064         bool _allowLazySell
4065     ) public onlyRole(DEFAULT_ADMIN_ROLE) {
4066         require(config.allowConfUpdate);
4067         // require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
4068         config.allowNFTUpdate = _allowNFTUpdate;
4069         config.allowConfUpdate = _allowConfUpdate;
4070         config.allowContract = _allowContract;
4071         config.allowPrivilege = _allowPrivilege;
4072         config.allowTarget = _allowTarget;
4073         config.allowLazySell = _allowLazySell;
4074     }
4075 
4076     function withdraw(address tokenAddress) public {
4077         address reviver = beneficiary;
4078         if (beneficiary == address(0)) {
4079             require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender), "admin only");
4080             reviver = msg.sender;
4081         }
4082         if (tokenAddress == address(0)) {
4083             payable(feeReceiver).transfer(
4084                 (address(this).balance * bip) / 10000
4085             );
4086             payable(reviver).transfer(address(this).balance);
4087         } else {
4088             IERC20 token = IERC20(tokenAddress);
4089             token.safeTransfer(
4090                 feeReceiver,
4091                 (token.balanceOf(address(this)) * bip) / 10000
4092             );
4093             token.safeTransfer(reviver, token.balanceOf(address(this)));
4094         }
4095     }
4096 
4097     function contractURI() external view returns (string memory) {
4098         string memory baseURI = _baseURI();
4099         return string(abi.encodePacked(baseURI, "contract_uri"));
4100     }
4101 
4102     function tokenURI(uint256 tokenId)
4103         public
4104         view
4105         virtual
4106         override
4107         returns (string memory)
4108     {
4109         require(_exists(tokenId), "nonexistent token");
4110 
4111         string memory baseURI = _baseURI();
4112         return string(abi.encodePacked(baseURI, "uri/", tokenId.toString()));
4113     }
4114 
4115     // @dev boring section -------------------
4116 
4117     function __721AInit(string memory name, string memory symbol) internal {
4118         __ReentrancyGuard_init_unchained();
4119         __ERC721A_init(name, symbol);
4120         __AccessControlEnumerable_init_unchained();
4121     }
4122 
4123     function _baseURI() internal view virtual override returns (string memory) {
4124         return _baseTokenURI;
4125     }
4126 
4127     function supportsInterface(bytes4 interfaceId)
4128         public
4129         view
4130         virtual
4131         override(AccessControlEnumerableUpgradeable, ERC721ASBUpgradable)
4132         returns (bool)
4133     {
4134         return
4135             interfaceId == type(IERC721Upgradeable).interfaceId ||
4136             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
4137             super.supportsInterface(interfaceId);
4138     }
4139 }