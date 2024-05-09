1 /**
2 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⠴⠶⠶⠶⠶⠶⠶⠶⠶⢤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀
3 ⠀⠀⠀⠀⢀⣤⠶⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠶⣤⡀⠀⠀⠀⠀⠀
4 ⠀⠀⢀⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢷⡄⠀⠀⠀
5 ⠀⣰⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣦⠀⠀
6 ⢰⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⠀
7 ⣿⠀⠀⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡄⠀⢹⡄
8 ⡏⠀⢰⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⢸⡇
9 ⣿⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡟⠀⢸⡇
10 ⢹⡆⠀⢹⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⠃⠀⣾⠀
11 ⠈⢷⡀⢸⡇⠀⢀⣠⣤⣶⣶⣶⣤⡀⠀⠀⠀⠀⠀⢀⣠⣶⣶⣶⣶⣤⣄⠀⠀⣿⠀⣼⠃⠀
12 ⠀⠈⢷⣼⠃⠀⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⡇⠀⢸⡾⠃⠀⠀
13 ⠀⠀⠈⣿⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⠃⠀⢸⡇⠀⠀⠀
14 ⠀⠀⠀⣿⠀⠀⠘⢿⣿⣿⣿⣿⡿⠃⠀⢠⠀⣄⠀⠀⠙⢿⣿⣿⣿⡿⠏⠀⠀⢘⡇⠀⠀⠀
15 ⠀⠀⠀⢻⡄⠀⠀⠀⠈⠉⠉⠀⠀⠀⣴⣿⠀⣿⣷⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⢸⡇⠀⠀⠀
16 ⠀⠀⠀⠈⠻⣄⡀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠀⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠀⠘⣟⠳⣦⡀⠀⠀⠀⠸⣿⡿⠀⢻⣿⡟⠀⠀⠀⠀⣤⡾⢻⡏⠁⠀⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⠀⢻⡄⢻⠻⣆⠀⠀⠀⠈⠀⠀⠀⠈⠀⠀⠀⢀⡾⢻⠁⢸⠁⠀⠀⠀⠀⠀⠀
19 ⠀⠀⠀⠀⠀⠀⢸⡇⠀⡆⢹⠒⡦⢤⠤⡤⢤⢤⡤⣤⠤⡔⡿⢁⡇⠀⡿⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠀⠀⠀⠘⡇⠀⢣⢸⠦⣧⣼⣀⡇⢸⢀⣇⣸⣠⡷⢇⢸⠀⠀⡇⠀⠀⠀⠀⠀⠀⠀
21 ⠀⠀⠀⠀⠀⠀⠀⣷⠀⠈⠺⣄⣇⢸⠉⡏⢹⠉⡏⢹⢀⣧⠾⠋⠀⢠⡇⠀⠀⠀⠀⠀⠀⠀
22 ⠀⠀⠀⠀⠀⠀⠀⠻⣆⠀⠀⠀⠈⠉⠙⠓⠚⠚⠋⠉⠁⠀⠀⠀⢀⡾⠁⠀⠀⠀⠀⠀⠀⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡴⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠳⠶⠦⣤⣤⣤⡤⠶⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25  */
26 // SPDX-License-Identifier: MIT
27 //Developer Info: 
28 
29 
30 
31 // File: @openzeppelin/contracts/utils/Strings.sol
32 
33 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev String operations.
39  */
40 library Strings {
41     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
45      */
46     function toString(uint256 value) internal pure returns (string memory) {
47         // Inspired by OraclizeAPI's implementation - MIT licence
48         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
49 
50         if (value == 0) {
51             return "0";
52         }
53         uint256 temp = value;
54         uint256 digits;
55         while (temp != 0) {
56             digits++;
57             temp /= 10;
58         }
59         bytes memory buffer = new bytes(digits);
60         while (value != 0) {
61             digits -= 1;
62             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
63             value /= 10;
64         }
65         return string(buffer);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
70      */
71     function toHexString(uint256 value) internal pure returns (string memory) {
72         if (value == 0) {
73             return "0x00";
74         }
75         uint256 temp = value;
76         uint256 length = 0;
77         while (temp != 0) {
78             length++;
79             temp >>= 8;
80         }
81         return toHexString(value, length);
82     }
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
86      */
87     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
88         bytes memory buffer = new bytes(2 * length + 2);
89         buffer[0] = "0";
90         buffer[1] = "x";
91         for (uint256 i = 2 * length + 1; i > 1; --i) {
92             buffer[i] = _HEX_SYMBOLS[value & 0xf];
93             value >>= 4;
94         }
95         require(value == 0, "Strings: hex length insufficient");
96         return string(buffer);
97     }
98 }
99 
100 // File: @openzeppelin/contracts/utils/Context.sol
101 
102 
103 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Provides information about the current execution context, including the
109  * sender of the transaction and its data. While these are generally available
110  * via msg.sender and msg.data, they should not be accessed in such a direct
111  * manner, since when dealing with meta-transactions the account sending and
112  * paying for execution may not be the actual sender (as far as an application
113  * is concerned).
114  *
115  * This contract is only required for intermediate, library-like contracts.
116  */
117 abstract contract Context {
118     function _msgSender() internal view virtual returns (address) {
119         return msg.sender;
120     }
121 
122     function _msgData() internal view virtual returns (bytes calldata) {
123         return msg.data;
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/Address.sol
128 
129 
130 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
131 
132 pragma solidity ^0.8.1;
133 
134 /**
135  * @dev Collection of functions related to the address type
136  */
137 library Address {
138     /**
139      * @dev Returns true if `account` is a contract.
140      *
141      * [IMPORTANT]
142      * ====
143      * It is unsafe to assume that an address for which this function returns
144      * false is an externally-owned account (EOA) and not a contract.
145      *
146      * Among others, `isContract` will return false for the following
147      * types of addresses:
148      *
149      *  - an externally-owned account
150      *  - a contract in construction
151      *  - an address where a contract will be created
152      *  - an address where a contract lived, but was destroyed
153      * ====
154      *
155      * [IMPORTANT]
156      * ====
157      * You shouldn't rely on `isContract` to protect against flash loan attacks!
158      *
159      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
160      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
161      * constructor.
162      * ====
163      */
164     function isContract(address account) internal view returns (bool) {
165         // This method relies on extcodesize/address.code.length, which returns 0
166         // for contracts in construction, since the code is only stored at the end
167         // of the constructor execution.
168 
169         return account.code.length > 0;
170     }
171 
172     /**
173      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
174      * `recipient`, forwarding all available gas and reverting on errors.
175      *
176      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
177      * of certain opcodes, possibly making contracts go over the 2300 gas limit
178      * imposed by `transfer`, making them unable to receive funds via
179      * `transfer`. {sendValue} removes this limitation.
180      *
181      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
182      *
183      * IMPORTANT: because control is transferred to `recipient`, care must be
184      * taken to not create reentrancy vulnerabilities. Consider using
185      * {ReentrancyGuard} or the
186      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
187      */
188     function sendValue(address payable recipient, uint256 amount) internal {
189         require(address(this).balance >= amount, "Address: insufficient balance");
190 
191         (bool success, ) = recipient.call{value: amount}("");
192         require(success, "Address: unable to send value, recipient may have reverted");
193     }
194 
195     /**
196      * @dev Performs a Solidity function call using a low level `call`. A
197      * plain `call` is an unsafe replacement for a function call: use this
198      * function instead.
199      *
200      * If `target` reverts with a revert reason, it is bubbled up by this
201      * function (like regular Solidity function calls).
202      *
203      * Returns the raw returned data. To convert to the expected return value,
204      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
205      *
206      * Requirements:
207      *
208      * - `target` must be a contract.
209      * - calling `target` with `data` must not revert.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
214         return functionCall(target, data, "Address: low-level call failed");
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
219      * `errorMessage` as a fallback revert reason when `target` reverts.
220      *
221      * _Available since v3.1._
222      */
223     function functionCall(
224         address target,
225         bytes memory data,
226         string memory errorMessage
227     ) internal returns (bytes memory) {
228         return functionCallWithValue(target, data, 0, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but also transferring `value` wei to `target`.
234      *
235      * Requirements:
236      *
237      * - the calling contract must have an ETH balance of at least `value`.
238      * - the called Solidity function must be `payable`.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
252      * with `errorMessage` as a fallback revert reason when `target` reverts.
253      *
254      * _Available since v3.1._
255      */
256     function functionCallWithValue(
257         address target,
258         bytes memory data,
259         uint256 value,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(address(this).balance >= value, "Address: insufficient balance for call");
263         require(isContract(target), "Address: call to non-contract");
264 
265         (bool success, bytes memory returndata) = target.call{value: value}(data);
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
276         return functionStaticCall(target, data, "Address: low-level static call failed");
277     }
278 
279     /**
280      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
281      * but performing a static call.
282      *
283      * _Available since v3.3._
284      */
285     function functionStaticCall(
286         address target,
287         bytes memory data,
288         string memory errorMessage
289     ) internal view returns (bytes memory) {
290         require(isContract(target), "Address: static call to non-contract");
291 
292         (bool success, bytes memory returndata) = target.staticcall(data);
293         return verifyCallResult(success, returndata, errorMessage);
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
303         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
308      * but performing a delegate call.
309      *
310      * _Available since v3.4._
311      */
312     function functionDelegateCall(
313         address target,
314         bytes memory data,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(isContract(target), "Address: delegate call to non-contract");
318 
319         (bool success, bytes memory returndata) = target.delegatecall(data);
320         return verifyCallResult(success, returndata, errorMessage);
321     }
322 
323     /**
324      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
325      * revert reason using the provided one.
326      *
327      * _Available since v4.3._
328      */
329     function verifyCallResult(
330         bool success,
331         bytes memory returndata,
332         string memory errorMessage
333     ) internal pure returns (bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 assembly {
342                     let returndata_size := mload(returndata)
343                     revert(add(32, returndata), returndata_size)
344                 }
345             } else {
346                 revert(errorMessage);
347             }
348         }
349     }
350 }
351 
352 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 /**
360  * @title ERC721 token receiver interface
361  * @dev Interface for any contract that wants to support safeTransfers
362  * from ERC721 asset contracts.
363  */
364 interface IERC721Receiver {
365     /**
366      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
367      * by `operator` from `from`, this function is called.
368      *
369      * It must return its Solidity selector to confirm the token transfer.
370      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
371      *
372      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
373      */
374     function onERC721Received(
375         address operator,
376         address from,
377         uint256 tokenId,
378         bytes calldata data
379     ) external returns (bytes4);
380 }
381 
382 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
383 
384 
385 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 /**
390  * @dev Interface of the ERC165 standard, as defined in the
391  * https://eips.ethereum.org/EIPS/eip-165[EIP].
392  *
393  * Implementers can declare support of contract interfaces, which can then be
394  * queried by others ({ERC165Checker}).
395  *
396  * For an implementation, see {ERC165}.
397  */
398 interface IERC165 {
399     /**
400      * @dev Returns true if this contract implements the interface defined by
401      * `interfaceId`. See the corresponding
402      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
403      * to learn more about how these ids are created.
404      *
405      * This function call must use less than 30 000 gas.
406      */
407     function supportsInterface(bytes4 interfaceId) external view returns (bool);
408 }
409 
410 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
411 
412 
413 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
414 
415 pragma solidity ^0.8.0;
416 
417 
418 /**
419  * @dev Implementation of the {IERC165} interface.
420  *
421  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
422  * for the additional interface id that will be supported. For example:
423  *
424  * ```solidity
425  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
426  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
427  * }
428  * ```
429  *
430  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
431  */
432 abstract contract ERC165 is IERC165 {
433     /**
434      * @dev See {IERC165-supportsInterface}.
435      */
436     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437         return interfaceId == type(IERC165).interfaceId;
438     }
439 }
440 
441 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
442 
443 
444 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
445 
446 pragma solidity ^0.8.0;
447 
448 
449 /**
450  * @dev Required interface of an ERC721 compliant contract.
451  */
452 interface IERC721 is IERC165 {
453     /**
454      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
455      */
456     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
460      */
461     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
465      */
466     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
467 
468     /**
469      * @dev Returns the number of tokens in ``owner``'s account.
470      */
471     function balanceOf(address owner) external view returns (uint256 balance);
472 
473     /**
474      * @dev Returns the owner of the `tokenId` token.
475      *
476      * Requirements:
477      *
478      * - `tokenId` must exist.
479      */
480     function ownerOf(uint256 tokenId) external view returns (address owner);
481 
482     /**
483      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
484      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
485      *
486      * Requirements:
487      *
488      * - `from` cannot be the zero address.
489      * - `to` cannot be the zero address.
490      * - `tokenId` token must exist and be owned by `from`.
491      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
492      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
493      *
494      * Emits a {Transfer} event.
495      */
496     function safeTransferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Transfers `tokenId` token from `from` to `to`.
504      *
505      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
506      *
507      * Requirements:
508      *
509      * - `from` cannot be the zero address.
510      * - `to` cannot be the zero address.
511      * - `tokenId` token must be owned by `from`.
512      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
513      *
514      * Emits a {Transfer} event.
515      */
516     function transferFrom(
517         address from,
518         address to,
519         uint256 tokenId
520     ) external;
521 
522     /**
523      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
524      * The approval is cleared when the token is transferred.
525      *
526      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
527      *
528      * Requirements:
529      *
530      * - The caller must own the token or be an approved operator.
531      * - `tokenId` must exist.
532      *
533      * Emits an {Approval} event.
534      */
535     function approve(address to, uint256 tokenId) external;
536 
537     /**
538      * @dev Returns the account approved for `tokenId` token.
539      *
540      * Requirements:
541      *
542      * - `tokenId` must exist.
543      */
544     function getApproved(uint256 tokenId) external view returns (address operator);
545 
546     /**
547      * @dev Approve or remove `operator` as an operator for the caller.
548      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
549      *
550      * Requirements:
551      *
552      * - The `operator` cannot be the caller.
553      *
554      * Emits an {ApprovalForAll} event.
555      */
556     function setApprovalForAll(address operator, bool _approved) external;
557 
558     /**
559      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
560      *
561      * See {setApprovalForAll}
562      */
563     function isApprovedForAll(address owner, address operator) external view returns (bool);
564 
565     /**
566      * @dev Safely transfers `tokenId` token from `from` to `to`.
567      *
568      * Requirements:
569      *
570      * - `from` cannot be the zero address.
571      * - `to` cannot be the zero address.
572      * - `tokenId` token must exist and be owned by `from`.
573      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
574      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
575      *
576      * Emits a {Transfer} event.
577      */
578     function safeTransferFrom(
579         address from,
580         address to,
581         uint256 tokenId,
582         bytes calldata data
583     ) external;
584 }
585 
586 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
596  * @dev See https://eips.ethereum.org/EIPS/eip-721
597  */
598 interface IERC721Metadata is IERC721 {
599     /**
600      * @dev Returns the token collection name.
601      */
602     function name() external view returns (string memory);
603 
604     /**
605      * @dev Returns the token collection symbol.
606      */
607     function symbol() external view returns (string memory);
608 
609     /**
610      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
611      */
612     function tokenURI(uint256 tokenId) external view returns (string memory);
613 }
614 
615 // File: contracts/new.sol
616 
617 
618 
619 
620 pragma solidity ^0.8.4;
621 
622 
623 
624 
625 
626 
627 
628 
629 error ApprovalCallerNotOwnerNorApproved();
630 error ApprovalQueryForNonexistentToken();
631 error ApproveToCaller();
632 error ApprovalToCurrentOwner();
633 error BalanceQueryForZeroAddress();
634 error MintToZeroAddress();
635 error MintZeroQuantity();
636 error OwnerQueryForNonexistentToken();
637 error TransferCallerNotOwnerNorApproved();
638 error TransferFromIncorrectOwner();
639 error TransferToNonERC721ReceiverImplementer();
640 error TransferToZeroAddress();
641 error URIQueryForNonexistentToken();
642 
643 /**
644  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
645  * the Metadata extension. Built to optimize for lower gas during batch mints.
646  *
647  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
648  *
649  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
650  *
651  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
652  */
653 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
654     using Address for address;
655     using Strings for uint256;
656 
657     // Compiler will pack this into a single 256bit word.
658     struct TokenOwnership {
659         // The address of the owner.
660         address addr;
661         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
662         uint64 startTimestamp;
663         // Whether the token has been burned.
664         bool burned;
665     }
666 
667     // Compiler will pack this into a single 256bit word.
668     struct AddressData {
669         // Realistically, 2**64-1 is more than enough.
670         uint64 balance;
671         // Keeps track of mint count with minimal overhead for tokenomics.
672         uint64 numberMinted;
673         // Keeps track of burn count with minimal overhead for tokenomics.
674         uint64 numberBurned;
675         // For miscellaneous variable(s) pertaining to the address
676         // (e.g. number of whitelist mint slots used).
677         // If there are multiple variables, please pack them into a uint64.
678         uint64 aux;
679     }
680 
681     // The tokenId of the next token to be minted.
682     uint256 internal _currentIndex;
683 
684     // The number of tokens burned.
685     uint256 internal _burnCounter;
686 
687     // Token name
688     string private _name;
689 
690     // Token symbol
691     string private _symbol;
692 
693     // Mapping from token ID to ownership details
694     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
695     mapping(uint256 => TokenOwnership) internal _ownerships;
696 
697     // Mapping owner address to address data
698     mapping(address => AddressData) private _addressData;
699 
700     // Mapping from token ID to approved address
701     mapping(uint256 => address) private _tokenApprovals;
702 
703     // Mapping from owner to operator approvals
704     mapping(address => mapping(address => bool)) private _operatorApprovals;
705 
706     constructor(string memory name_, string memory symbol_) {
707         _name = name_;
708         _symbol = symbol_;
709         _currentIndex = _startTokenId();
710     }
711 
712     /**
713      * To change the starting tokenId, please override this function.
714      */
715     function _startTokenId() internal view virtual returns (uint256) {
716         return 0;
717     }
718 
719     /**
720      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
721      */
722     function totalSupply() public view returns (uint256) {
723         // Counter underflow is impossible as _burnCounter cannot be incremented
724         // more than _currentIndex - _startTokenId() times
725         unchecked {
726             return _currentIndex - _burnCounter - _startTokenId();
727         }
728     }
729 
730     /**
731      * Returns the total amount of tokens minted in the contract.
732      */
733     function _totalMinted() internal view returns (uint256) {
734         // Counter underflow is impossible as _currentIndex does not decrement,
735         // and it is initialized to _startTokenId()
736         unchecked {
737             return _currentIndex - _startTokenId();
738         }
739     }
740 
741     /**
742      * @dev See {IERC165-supportsInterface}.
743      */
744     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
745         return
746             interfaceId == type(IERC721).interfaceId ||
747             interfaceId == type(IERC721Metadata).interfaceId ||
748             super.supportsInterface(interfaceId);
749     }
750 
751     /**
752      * @dev See {IERC721-balanceOf}.
753      */
754     function balanceOf(address owner) public view override returns (uint256) {
755         if (owner == address(0)) revert BalanceQueryForZeroAddress();
756         return uint256(_addressData[owner].balance);
757     }
758 
759     /**
760      * Returns the number of tokens minted by `owner`.
761      */
762     function _numberMinted(address owner) internal view returns (uint256) {
763         return uint256(_addressData[owner].numberMinted);
764     }
765 
766     /**
767      * Returns the number of tokens burned by or on behalf of `owner`.
768      */
769     function _numberBurned(address owner) internal view returns (uint256) {
770         return uint256(_addressData[owner].numberBurned);
771     }
772 
773     /**
774      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
775      */
776     function _getAux(address owner) internal view returns (uint64) {
777         return _addressData[owner].aux;
778     }
779 
780     /**
781      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
782      * If there are multiple variables, please pack them into a uint64.
783      */
784     function _setAux(address owner, uint64 aux) internal {
785         _addressData[owner].aux = aux;
786     }
787 
788     /**
789      * Gas spent here starts off proportional to the maximum mint batch size.
790      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
791      */
792     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
793         uint256 curr = tokenId;
794 
795         unchecked {
796             if (_startTokenId() <= curr && curr < _currentIndex) {
797                 TokenOwnership memory ownership = _ownerships[curr];
798                 if (!ownership.burned) {
799                     if (ownership.addr != address(0)) {
800                         return ownership;
801                     }
802                     // Invariant:
803                     // There will always be an ownership that has an address and is not burned
804                     // before an ownership that does not have an address and is not burned.
805                     // Hence, curr will not underflow.
806                     while (true) {
807                         curr--;
808                         ownership = _ownerships[curr];
809                         if (ownership.addr != address(0)) {
810                             return ownership;
811                         }
812                     }
813                 }
814             }
815         }
816         revert OwnerQueryForNonexistentToken();
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view override returns (address) {
823         return _ownershipOf(tokenId).addr;
824     }
825 
826     /**
827      * @dev See {IERC721Metadata-name}.
828      */
829     function name() public view virtual override returns (string memory) {
830         return _name;
831     }
832 
833     /**
834      * @dev See {IERC721Metadata-symbol}.
835      */
836     function symbol() public view virtual override returns (string memory) {
837         return _symbol;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-tokenURI}.
842      */
843     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
844         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
845 
846         string memory baseURI = _baseURI();
847         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
848     }
849 
850     /**
851      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
852      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
853      * by default, can be overriden in child contracts.
854      */
855     function _baseURI() internal view virtual returns (string memory) {
856         return '';
857     }
858 
859     /**
860      * @dev See {IERC721-approve}.
861      */
862     function approve(address to, uint256 tokenId) public override {
863         address owner = ERC721A.ownerOf(tokenId);
864         if (to == owner) revert ApprovalToCurrentOwner();
865 
866         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
867             revert ApprovalCallerNotOwnerNorApproved();
868         }
869 
870         _approve(to, tokenId, owner);
871     }
872 
873     /**
874      * @dev See {IERC721-getApproved}.
875      */
876     function getApproved(uint256 tokenId) public view override returns (address) {
877         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
878 
879         return _tokenApprovals[tokenId];
880     }
881 
882     /**
883      * @dev See {IERC721-setApprovalForAll}.
884      */
885     function setApprovalForAll(address operator, bool approved) public virtual override {
886         if (operator == _msgSender()) revert ApproveToCaller();
887 
888         _operatorApprovals[_msgSender()][operator] = approved;
889         emit ApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
896         return _operatorApprovals[owner][operator];
897     }
898 
899     /**
900      * @dev See {IERC721-transferFrom}.
901      */
902     function transferFrom(
903         address from,
904         address to,
905         uint256 tokenId
906     ) public virtual override {
907         _transfer(from, to, tokenId);
908     }
909 
910     /**
911      * @dev See {IERC721-safeTransferFrom}.
912      */
913     function safeTransferFrom(
914         address from,
915         address to,
916         uint256 tokenId
917     ) public virtual override {
918         safeTransferFrom(from, to, tokenId, '');
919     }
920 
921     /**
922      * @dev See {IERC721-safeTransferFrom}.
923      */
924     function safeTransferFrom(
925         address from,
926         address to,
927         uint256 tokenId,
928         bytes memory _data
929     ) public virtual override {
930         _transfer(from, to, tokenId);
931         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
932             revert TransferToNonERC721ReceiverImplementer();
933         }
934     }
935 
936     /**
937      * @dev Returns whether `tokenId` exists.
938      *
939      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
940      *
941      * Tokens start existing when they are minted (`_mint`),
942      */
943     function _exists(uint256 tokenId) internal view returns (bool) {
944         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
945             !_ownerships[tokenId].burned;
946     }
947 
948     function _safeMint(address to, uint256 quantity) internal {
949         _safeMint(to, quantity, '');
950     }
951 
952     /**
953      * @dev Safely mints `quantity` tokens and transfers them to `to`.
954      *
955      * Requirements:
956      *
957      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
958      * - `quantity` must be greater than 0.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _safeMint(
963         address to,
964         uint256 quantity,
965         bytes memory _data
966     ) internal {
967         _mint(to, quantity, _data, true);
968     }
969 
970     /**
971      * @dev Mints `quantity` tokens and transfers them to `to`.
972      *
973      * Requirements:
974      *
975      * - `to` cannot be the zero address.
976      * - `quantity` must be greater than 0.
977      *
978      * Emits a {Transfer} event.
979      */
980     function _mint(
981         address to,
982         uint256 quantity,
983         bytes memory _data,
984         bool safe
985     ) internal {
986         uint256 startTokenId = _currentIndex;
987         if (to == address(0)) revert MintToZeroAddress();
988         if (quantity == 0) revert MintZeroQuantity();
989 
990         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
991 
992         // Overflows are incredibly unrealistic.
993         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
994         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
995         unchecked {
996             _addressData[to].balance += uint64(quantity);
997             _addressData[to].numberMinted += uint64(quantity);
998 
999             _ownerships[startTokenId].addr = to;
1000             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1001 
1002             uint256 updatedIndex = startTokenId;
1003             uint256 end = updatedIndex + quantity;
1004 
1005             if (safe && to.isContract()) {
1006                 do {
1007                     emit Transfer(address(0), to, updatedIndex);
1008                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1009                         revert TransferToNonERC721ReceiverImplementer();
1010                     }
1011                 } while (updatedIndex != end);
1012                 // Reentrancy protection
1013                 if (_currentIndex != startTokenId) revert();
1014             } else {
1015                 do {
1016                     emit Transfer(address(0), to, updatedIndex++);
1017                 } while (updatedIndex != end);
1018             }
1019             _currentIndex = updatedIndex;
1020         }
1021         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1022     }
1023 
1024     /**
1025      * @dev Transfers `tokenId` from `from` to `to`.
1026      *
1027      * Requirements:
1028      *
1029      * - `to` cannot be the zero address.
1030      * - `tokenId` token must be owned by `from`.
1031      *
1032      * Emits a {Transfer} event.
1033      */
1034     function _transfer(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) private {
1039         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1040 
1041         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1042 
1043         bool isApprovedOrOwner = (_msgSender() == from ||
1044             isApprovedForAll(from, _msgSender()) ||
1045             getApproved(tokenId) == _msgSender());
1046 
1047         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1048         if (to == address(0)) revert TransferToZeroAddress();
1049 
1050         _beforeTokenTransfers(from, to, tokenId, 1);
1051 
1052         // Clear approvals from the previous owner
1053         _approve(address(0), tokenId, from);
1054 
1055         // Underflow of the sender's balance is impossible because we check for
1056         // ownership above and the recipient's balance can't realistically overflow.
1057         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1058         unchecked {
1059             _addressData[from].balance -= 1;
1060             _addressData[to].balance += 1;
1061 
1062             TokenOwnership storage currSlot = _ownerships[tokenId];
1063             currSlot.addr = to;
1064             currSlot.startTimestamp = uint64(block.timestamp);
1065 
1066             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1067             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1068             uint256 nextTokenId = tokenId + 1;
1069             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1070             if (nextSlot.addr == address(0)) {
1071                 // This will suffice for checking _exists(nextTokenId),
1072                 // as a burned slot cannot contain the zero address.
1073                 if (nextTokenId != _currentIndex) {
1074                     nextSlot.addr = from;
1075                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1076                 }
1077             }
1078         }
1079 
1080         emit Transfer(from, to, tokenId);
1081         _afterTokenTransfers(from, to, tokenId, 1);
1082     }
1083 
1084     /**
1085      * @dev This is equivalent to _burn(tokenId, false)
1086      */
1087     function _burn(uint256 tokenId) internal virtual {
1088         _burn(tokenId, false);
1089     }
1090 
1091     /**
1092      * @dev Destroys `tokenId`.
1093      * The approval is cleared when the token is burned.
1094      *
1095      * Requirements:
1096      *
1097      * - `tokenId` must exist.
1098      *
1099      * Emits a {Transfer} event.
1100      */
1101     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1102         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1103 
1104         address from = prevOwnership.addr;
1105 
1106         if (approvalCheck) {
1107             bool isApprovedOrOwner = (_msgSender() == from ||
1108                 isApprovedForAll(from, _msgSender()) ||
1109                 getApproved(tokenId) == _msgSender());
1110 
1111             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1112         }
1113 
1114         _beforeTokenTransfers(from, address(0), tokenId, 1);
1115 
1116         // Clear approvals from the previous owner
1117         _approve(address(0), tokenId, from);
1118 
1119         // Underflow of the sender's balance is impossible because we check for
1120         // ownership above and the recipient's balance can't realistically overflow.
1121         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1122         unchecked {
1123             AddressData storage addressData = _addressData[from];
1124             addressData.balance -= 1;
1125             addressData.numberBurned += 1;
1126 
1127             // Keep track of who burned the token, and the timestamp of burning.
1128             TokenOwnership storage currSlot = _ownerships[tokenId];
1129             currSlot.addr = from;
1130             currSlot.startTimestamp = uint64(block.timestamp);
1131             currSlot.burned = true;
1132 
1133             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1134             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1135             uint256 nextTokenId = tokenId + 1;
1136             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1137             if (nextSlot.addr == address(0)) {
1138                 // This will suffice for checking _exists(nextTokenId),
1139                 // as a burned slot cannot contain the zero address.
1140                 if (nextTokenId != _currentIndex) {
1141                     nextSlot.addr = from;
1142                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1143                 }
1144             }
1145         }
1146 
1147         emit Transfer(from, address(0), tokenId);
1148         _afterTokenTransfers(from, address(0), tokenId, 1);
1149 
1150         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1151         unchecked {
1152             _burnCounter++;
1153         }
1154     }
1155 
1156     /**
1157      * @dev Approve `to` to operate on `tokenId`
1158      *
1159      * Emits a {Approval} event.
1160      */
1161     function _approve(
1162         address to,
1163         uint256 tokenId,
1164         address owner
1165     ) private {
1166         _tokenApprovals[tokenId] = to;
1167         emit Approval(owner, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1172      *
1173      * @param from address representing the previous owner of the given token ID
1174      * @param to target address that will receive the tokens
1175      * @param tokenId uint256 ID of the token to be transferred
1176      * @param _data bytes optional data to send along with the call
1177      * @return bool whether the call correctly returned the expected magic value
1178      */
1179     function _checkContractOnERC721Received(
1180         address from,
1181         address to,
1182         uint256 tokenId,
1183         bytes memory _data
1184     ) private returns (bool) {
1185         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1186             return retval == IERC721Receiver(to).onERC721Received.selector;
1187         } catch (bytes memory reason) {
1188             if (reason.length == 0) {
1189                 revert TransferToNonERC721ReceiverImplementer();
1190             } else {
1191                 assembly {
1192                     revert(add(32, reason), mload(reason))
1193                 }
1194             }
1195         }
1196     }
1197 
1198     /**
1199      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1200      * And also called before burning one token.
1201      *
1202      * startTokenId - the first token id to be transferred
1203      * quantity - the amount to be transferred
1204      *
1205      * Calling conditions:
1206      *
1207      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1208      * transferred to `to`.
1209      * - When `from` is zero, `tokenId` will be minted for `to`.
1210      * - When `to` is zero, `tokenId` will be burned by `from`.
1211      * - `from` and `to` are never both zero.
1212      */
1213     function _beforeTokenTransfers(
1214         address from,
1215         address to,
1216         uint256 startTokenId,
1217         uint256 quantity
1218     ) internal virtual {}
1219 
1220     /**
1221      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1222      * minting.
1223      * And also called after one token has been burned.
1224      *
1225      * startTokenId - the first token id to be transferred
1226      * quantity - the amount to be transferred
1227      *
1228      * Calling conditions:
1229      *
1230      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1231      * transferred to `to`.
1232      * - When `from` is zero, `tokenId` has been minted for `to`.
1233      * - When `to` is zero, `tokenId` has been burned by `from`.
1234      * - `from` and `to` are never both zero.
1235      */
1236     function _afterTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 }
1243 
1244 abstract contract Ownable is Context {
1245     address private _owner;
1246 
1247     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1248 
1249     /**
1250      * @dev Initializes the contract setting the deployer as the initial owner.
1251      */
1252     constructor() {
1253         _transferOwnership(_msgSender());
1254     }
1255 
1256     /**
1257      * @dev Returns the address of the current owner.
1258      */
1259     function owner() public view virtual returns (address) {
1260         return _owner;
1261     }
1262 
1263     /**
1264      * @dev Throws if called by any account other than the owner.
1265      */
1266     modifier onlyOwner() {
1267         require(owner() == _msgSender() , "Ownable: caller is not the owner");
1268         _;
1269     }
1270 
1271     /**
1272      * @dev Leaves the contract without owner. It will not be possible to call
1273      * `onlyOwner` functions anymore. Can only be called by the current owner.
1274      *
1275      * NOTE: Renouncing ownership will leave the contract without an owner,
1276      * thereby removing any functionality that is only available to the owner.
1277      */
1278     function renounceOwnership() public virtual onlyOwner {
1279         _transferOwnership(address(0));
1280     }
1281 
1282     /**
1283      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1284      * Can only be called by the current owner.
1285      */
1286     function transferOwnership(address newOwner) public virtual onlyOwner {
1287         require(newOwner != address(0), "Ownable: new owner is the zero address");
1288         _transferOwnership(newOwner);
1289     }
1290 
1291     /**
1292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1293      * Internal function without access restriction.
1294      */
1295     function _transferOwnership(address newOwner) internal virtual {
1296         address oldOwner = _owner;
1297         _owner = newOwner;
1298         emit OwnershipTransferred(oldOwner, newOwner);
1299     }
1300 }
1301 pragma solidity ^0.8.13;
1302 
1303 interface IOperatorFilterRegistry {
1304     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1305     function register(address registrant) external;
1306     function registerAndSubscribe(address registrant, address subscription) external;
1307     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1308     function updateOperator(address registrant, address operator, bool filtered) external;
1309     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1310     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1311     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1312     function subscribe(address registrant, address registrantToSubscribe) external;
1313     function unsubscribe(address registrant, bool copyExistingEntries) external;
1314     function subscriptionOf(address addr) external returns (address registrant);
1315     function subscribers(address registrant) external returns (address[] memory);
1316     function subscriberAt(address registrant, uint256 index) external returns (address);
1317     function copyEntriesOf(address registrant, address registrantToCopy) external;
1318     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1319     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1320     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1321     function filteredOperators(address addr) external returns (address[] memory);
1322     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1323     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1324     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1325     function isRegistered(address addr) external returns (bool);
1326     function codeHashOf(address addr) external returns (bytes32);
1327 }
1328 pragma solidity ^0.8.13;
1329 
1330 
1331 
1332 abstract contract OperatorFilterer {
1333     error OperatorNotAllowed(address operator);
1334 
1335     IOperatorFilterRegistry constant operatorFilterRegistry =
1336         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1337 
1338     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1339         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1340         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1341         // order for the modifier to filter addresses.
1342         if (address(operatorFilterRegistry).code.length > 0) {
1343             if (subscribe) {
1344                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1345             } else {
1346                 if (subscriptionOrRegistrantToCopy != address(0)) {
1347                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1348                 } else {
1349                     operatorFilterRegistry.register(address(this));
1350                 }
1351             }
1352         }
1353     }
1354 
1355     modifier onlyAllowedOperator(address from) virtual {
1356         // Check registry code length to facilitate testing in environments without a deployed registry.
1357         if (address(operatorFilterRegistry).code.length > 0) {
1358             // Allow spending tokens from addresses with balance
1359             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1360             // from an EOA.
1361             if (from == msg.sender) {
1362                 _;
1363                 return;
1364             }
1365             if (
1366                 !(
1367                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1368                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1369                 )
1370             ) {
1371                 revert OperatorNotAllowed(msg.sender);
1372             }
1373         }
1374         _;
1375     }
1376 }
1377 pragma solidity ^0.8.13;
1378 
1379 
1380 
1381 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1382     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1383 
1384     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1385 }
1386     pragma solidity ^0.8.7;
1387     
1388     contract deadpixwtf is ERC721A, DefaultOperatorFilterer , Ownable {
1389     using Strings for uint256;
1390 
1391 
1392   string private uriPrefix ;
1393   string private uriSuffix = ".json";
1394   string public hiddenURL;
1395 
1396   
1397   
1398 
1399   uint256 public cost = 0.003 ether;
1400  
1401   
1402 
1403   uint16 public maxSupply = 732;
1404   uint8 public maxMintAmountPerTx = 5;
1405     uint8 public maxFreeMintAmountPerWallet = 0;
1406                                                              
1407  
1408   bool public paused = true;
1409   bool public reveal =false;
1410 
1411    mapping (address => uint8) public NFTPerPublicAddress;
1412 
1413  
1414   
1415   
1416  
1417   
1418 
1419   constructor() ERC721A("dead pix", "wtf") {
1420   }
1421 
1422 
1423   
1424  
1425   function mint(uint8 _mintAmount) external payable  {
1426      uint16 totalSupply = uint16(totalSupply());
1427      uint8 nft = NFTPerPublicAddress[msg.sender];
1428     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1429     require(_mintAmount + nft <= maxMintAmountPerTx, "Exceeds max per transaction.");
1430 
1431     require(!paused, "The contract is paused!");
1432     
1433       if(nft >= maxFreeMintAmountPerWallet)
1434     {
1435     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1436     }
1437     else {
1438          uint8 costAmount = _mintAmount + nft;
1439         if(costAmount > maxFreeMintAmountPerWallet)
1440        {
1441         costAmount = costAmount - maxFreeMintAmountPerWallet;
1442         require(msg.value >= cost * costAmount, "Insufficient funds!");
1443        }
1444        
1445          
1446     }
1447     
1448 
1449 
1450     _safeMint(msg.sender , _mintAmount);
1451 
1452     NFTPerPublicAddress[msg.sender] = _mintAmount + nft;
1453      
1454      delete totalSupply;
1455      delete _mintAmount;
1456   }
1457   
1458   function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
1459      uint16 totalSupply = uint16(totalSupply());
1460     require(totalSupply + _mintAmount <= maxSupply, "Exceeds max supply.");
1461      _safeMint(_receiver , _mintAmount);
1462      delete _mintAmount;
1463      delete _receiver;
1464      delete totalSupply;
1465   }
1466 
1467   function  Airdrop(uint8 _amountPerAddress, address[] calldata addresses) external onlyOwner {
1468      uint16 totalSupply = uint16(totalSupply());
1469      uint totalAmount =   _amountPerAddress * addresses.length;
1470     require(totalSupply + totalAmount <= maxSupply, "Exceeds max supply.");
1471      for (uint256 i = 0; i < addresses.length; i++) {
1472             _safeMint(addresses[i], _amountPerAddress);
1473         }
1474 
1475      delete _amountPerAddress;
1476      delete totalSupply;
1477   }
1478 
1479  
1480 
1481   function setMaxSupply(uint16 _maxSupply) external onlyOwner {
1482       maxSupply = _maxSupply;
1483   }
1484 
1485 
1486 
1487    
1488   function tokenURI(uint256 _tokenId)
1489     public
1490     view
1491     virtual
1492     override
1493     returns (string memory)
1494   {
1495     require(
1496       _exists(_tokenId),
1497       "ERC721Metadata: URI query for nonexistent token"
1498     );
1499     
1500   
1501 if ( reveal == false)
1502 {
1503     return hiddenURL;
1504 }
1505     
1506 
1507     string memory currentBaseURI = _baseURI();
1508     return bytes(currentBaseURI).length > 0
1509         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString() ,uriSuffix))
1510         : "";
1511   }
1512  
1513  
1514 
1515 
1516  function setFreeMaxLimitPerAddress(uint8 _limit) external onlyOwner{
1517     maxFreeMintAmountPerWallet = _limit;
1518    delete _limit;
1519 
1520 }
1521 
1522     
1523   
1524 
1525   function setUriPrefix(string memory _uriPrefix) external onlyOwner {
1526     uriPrefix = _uriPrefix;
1527   }
1528    function setHiddenUri(string memory _uriPrefix) external onlyOwner {
1529     hiddenURL = _uriPrefix;
1530   }
1531 
1532 
1533   function setPaused() external onlyOwner {
1534     paused = !paused;
1535    
1536   }
1537 
1538   function setCost(uint _cost) external onlyOwner{
1539       cost = _cost;
1540 
1541   }
1542 
1543  function setRevealed() external onlyOwner{
1544      reveal = !reveal;
1545  }
1546 
1547   function setMaxMintAmountPerTx(uint8 _maxtx) external onlyOwner{
1548       maxMintAmountPerTx = _maxtx;
1549 
1550   }
1551 
1552  
1553 
1554   function withdraw() external onlyOwner {
1555   uint _balance = address(this).balance;
1556      payable(msg.sender).transfer(_balance ); 
1557        
1558   }
1559 
1560 
1561   function _baseURI() internal view  override returns (string memory) {
1562     return uriPrefix;
1563   }
1564 
1565     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1566         super.transferFrom(from, to, tokenId);
1567     }
1568 
1569     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1570         super.safeTransferFrom(from, to, tokenId);
1571     }
1572 
1573     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
1574         public
1575         override
1576         onlyAllowedOperator(from)
1577     {
1578         super.safeTransferFrom(from, to, tokenId, data);
1579     }
1580 }