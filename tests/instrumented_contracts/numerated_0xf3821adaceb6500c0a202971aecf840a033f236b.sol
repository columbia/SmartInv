1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
6 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
7 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
8 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
9 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
10 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
11 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
12 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
13 @@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
14 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 @@@@@@@&@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@&@@&@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@
16 @@@@@@@@@@@@@@&@@&@@&@&&&@&@&@@&&@@@&@&&&%@@@@@&@@@@&&&@@@@&&@&&@@&@@@&%&&&@@@@@@@@@@@@@
17 @@@@@@@@@@@&@&%@@&@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@@@@&@@@@@@@@@@@@@
18 @@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@
19 @@@@@@@@@@@@@&@@@&@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@
20 @@@@@@@@@@@@@&&@&&@@@@@&&@@@@&%@@&@&@@&@&&@@&&&@@&@%@&@%@@&@@%@&&@@@&@@@@@@@@@@@@@@@@@@@
21 @@@@@@@@@@@&@@%@@&@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@&@@&@@&@@@@@@@@@@@@@
22 @@@@@@@@@@&@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@&@&&@@&@@@@@@@@@@@@@@@@
23 @@@@@@@@@@@&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@@@@@@@@
24 @@@@@@&@@@@&@@&@@@@@@@@&@@@@@@&@@@@@@@@@@&&&&@@&@@@@@@@@@@@@@@@@%@@@@@@@@@&@@@@@@&@@@@@@
25 @@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@
26 @@@@@@@@@@@@@@@@@&@@@@@@&@@@@@@@@@@@@@&&&&&&&@&@&@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@&@@@@@@
27 @@@@@@@@@@@@@@&@@@@@@@@@%@@@@@@@@@@@&&&&&@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@
28 @@@@@@@@@@@&@@&@@@@@@@@@%@@@@&@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@
29 @@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@@@@@@@&@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@&@@@%@@@@@@
30 @@@@@@@&@@@&@@%@@&@@@@@@&@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&@@&@@@&@&@@@@@@@
31 @@@@@@@@@@@@@@&@@&@@@@@@&@@@@@@@@@@@@@&&&&@&@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@&@@@@@@@@@
32 @@@@@@&@@@@@&@@@@@&@@@@&@@@@@@@@@@@@@@@@&&&&&@&@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@&@@@@@@@
33 @@@@@@@&@@@@@@&@&@@&@@@&&@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@@@@@@@@@@@@@@&@@@&@@@@@@@@@@@@@
34 @@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@&@@@@@@@@@@@@@@@&@@&@@@@&@@@@@@@@
35 @@@@@@@@@@@@@@@@@&@@@@@&%@@@@&@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@&@@@@@@
36 @@@@@@@@@@@@@@@@@@@@&@@&@&@@@&@@@%&@@%@@@&&@@@@@@&@@&&@@@&%&&&@&&@@@@@@@@@&@@@&@&@@@@@@@
37 @@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@&@@@@@@@@@@@&@@@@@@
38 @@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@&@@@@@&@@@@@@@
39 @@@@@@@@@@@&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
40 @@@@@@@&@@@&@@@&&&&@&&@@&&&&@@@@%@&&&&%&&@%@@@&@&@@@&%@@%&&&&@&&&&&@@&&@@%&@@@@@@@@@@@@@
41 @@@@@@@@@@@@@@&@@@@@@&@@@@@&@@@@@@@@@@@@&@@@@@&@@@&@@@@@@@@@@@@@@@@@&@@&@&@@@@@@&@@@@@@@
42 @@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
43 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
44 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
45 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
46 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
47 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
48 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
49 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
50 0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM  0XDISTORTION.COM 
51 
52 Gas optimization credited to Azuki: https://www.erc721a.org/
53 */
54 
55 
56 
57 
58 interface IERC165 {
59     /**
60      * @dev Returns true if this contract implements the interface defined by
61      * `interfaceId`. See the corresponding
62      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
63      * to learn more about how these ids are created.
64      *
65      * This function call must use less than 30 000 gas.
66      */
67     function supportsInterface(bytes4 interfaceId) external view returns (bool);
68 }
69 
70 pragma solidity ^0.8.0;
71 
72 
73 /**
74  * @dev Implementation of the {IERC165} interface.
75  *
76  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
77  * for the additional interface id that will be supported. For example:
78  *
79  * ```solidity
80  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
81  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
82  * }
83  * ```
84  *
85  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
86  */
87 abstract contract ERC165 is IERC165 {
88     /**
89      * @dev See {IERC165-supportsInterface}.
90      */
91     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
92         return interfaceId == type(IERC165).interfaceId;
93     }
94 }
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Collection of functions related to the address type
100  */
101 library Address {
102     /**
103      * @dev Returns true if `account` is a contract.
104      *
105      * [IMPORTANT]
106      * ====
107      * It is unsafe to assume that an address for which this function returns
108      * false is an externally-owned account (EOA) and not a contract.
109      *
110      * Among others, `isContract` will return false for the following
111      * types of addresses:
112      *
113      *  - an externally-owned account
114      *  - a contract in construction
115      *  - an address where a contract will be created
116      *  - an address where a contract lived, but was destroyed
117      * ====
118      */
119     function isContract(address account) internal view returns (bool) {
120         // This method relies on extcodesize, which returns 0 for contracts in
121         // construction, since the code is only stored at the end of the
122         // constructor execution.
123 
124         uint256 size;
125         assembly {
126             size := extcodesize(account)
127         }
128         return size > 0;
129     }
130 
131     /**
132      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
133      * `recipient`, forwarding all available gas and reverting on errors.
134      *
135      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
136      * of certain opcodes, possibly making contracts go over the 2300 gas limit
137      * imposed by `transfer`, making them unable to receive funds via
138      * `transfer`. {sendValue} removes this limitation.
139      *
140      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
141      *
142      * IMPORTANT: because control is transferred to `recipient`, care must be
143      * taken to not create reentrancy vulnerabilities. Consider using
144      * {ReentrancyGuard} or the
145      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
146      */
147     function sendValue(address payable recipient, uint256 amount) internal {
148         require(address(this).balance >= amount, "Address: insufficient balance");
149 
150         (bool success, ) = recipient.call{value: amount}("");
151         require(success, "Address: unable to send value, recipient may have reverted");
152     }
153 
154     /**
155      * @dev Performs a Solidity function call using a low level `call`. A
156      * plain `call` is an unsafe replacement for a function call: use this
157      * function instead.
158      *
159      * If `target` reverts with a revert reason, it is bubbled up by this
160      * function (like regular Solidity function calls).
161      *
162      * Returns the raw returned data. To convert to the expected return value,
163      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
164      *
165      * Requirements:
166      *
167      * - `target` must be a contract.
168      * - calling `target` with `data` must not revert.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
173         return functionCall(target, data, "Address: low-level call failed");
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
178      * `errorMessage` as a fallback revert reason when `target` reverts.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(
183         address target,
184         bytes memory data,
185         string memory errorMessage
186     ) internal returns (bytes memory) {
187         return functionCallWithValue(target, data, 0, errorMessage);
188     }
189 
190     /**
191      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
192      * but also transferring `value` wei to `target`.
193      *
194      * Requirements:
195      *
196      * - the calling contract must have an ETH balance of at least `value`.
197      * - the called Solidity function must be `payable`.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value
205     ) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(
216         address target,
217         bytes memory data,
218         uint256 value,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(address(this).balance >= value, "Address: insufficient balance for call");
222         require(isContract(target), "Address: call to non-contract");
223 
224         (bool success, bytes memory returndata) = target.call{value: value}(data);
225         return _verifyCallResult(success, returndata, errorMessage);
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
230      * but performing a static call.
231      *
232      * _Available since v3.3._
233      */
234     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
235         return functionStaticCall(target, data, "Address: low-level static call failed");
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
240      * but performing a static call.
241      *
242      * _Available since v3.3._
243      */
244     function functionStaticCall(
245         address target,
246         bytes memory data,
247         string memory errorMessage
248     ) internal view returns (bytes memory) {
249         require(isContract(target), "Address: static call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.staticcall(data);
252         return _verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a delegate call.
258      *
259      * _Available since v3.4._
260      */
261     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
262         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a delegate call.
268      *
269      * _Available since v3.4._
270      */
271     function functionDelegateCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal returns (bytes memory) {
276         require(isContract(target), "Address: delegate call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return _verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     function _verifyCallResult(
283         bool success,
284         bytes memory returndata,
285         string memory errorMessage
286     ) private pure returns (bytes memory) {
287         if (success) {
288             return returndata;
289         } else {
290             // Look for revert reason and bubble it up if present
291             if (returndata.length > 0) {
292                 // The easiest way to bubble the revert reason is using memory via assembly
293 
294                 assembly {
295                     let returndata_size := mload(returndata)
296                     revert(add(32, returndata), returndata_size)
297                 }
298             } else {
299                 revert(errorMessage);
300             }
301         }
302     }
303 }
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 
310 /**
311  * @dev Required interface of an ERC721 compliant contract.
312  */
313 interface IERC721 is IERC165 {
314     /**
315      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
318 
319     /**
320      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
321      */
322     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
323 
324     /**
325      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
326      */
327     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
328 
329     /**
330      * @dev Returns the number of tokens in ``owner``'s account.
331      */
332     function balanceOf(address owner) external view returns (uint256 balance);
333 
334     /**
335      * @dev Returns the owner of the `tokenId` token.
336      *
337      * Requirements:
338      *
339      * - `tokenId` must exist.
340      */
341     function ownerOf(uint256 tokenId) external view returns (address owner);
342 
343     /**
344      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
345      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
346      *
347      * Requirements:
348      *
349      * - `from` cannot be the zero address.
350      * - `to` cannot be the zero address.
351      * - `tokenId` token must exist and be owned by `from`.
352      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
353      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
354      *
355      * Emits a {Transfer} event.
356      */
357     function safeTransferFrom(
358         address from,
359         address to,
360         uint256 tokenId
361     ) external;
362 
363     /**
364      * @dev Transfers `tokenId` token from `from` to `to`.
365      *
366      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
367      *
368      * Requirements:
369      *
370      * - `from` cannot be the zero address.
371      * - `to` cannot be the zero address.
372      * - `tokenId` token must be owned by `from`.
373      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transferFrom(
378         address from,
379         address to,
380         uint256 tokenId
381     ) external;
382 
383     /**
384      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
385      * The approval is cleared when the token is transferred.
386      *
387      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
388      *
389      * Requirements:
390      *
391      * - The caller must own the token or be an approved operator.
392      * - `tokenId` must exist.
393      *
394      * Emits an {Approval} event.
395      */
396     function approve(address to, uint256 tokenId) external;
397 
398     /**
399      * @dev Returns the account approved for `tokenId` token.
400      *
401      * Requirements:
402      *
403      * - `tokenId` must exist.
404      */
405     function getApproved(uint256 tokenId) external view returns (address operator);
406 
407     /**
408      * @dev Approve or remove `operator` as an operator for the caller.
409      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
410      *
411      * Requirements:
412      *
413      * - The `operator` cannot be the caller.
414      *
415      * Emits an {ApprovalForAll} event.
416      */
417     function setApprovalForAll(address operator, bool _approved) external;
418 
419     /**
420      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
421      *
422      * See {setApprovalForAll}
423      */
424     function isApprovedForAll(address owner, address operator) external view returns (bool);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `tokenId` token must exist and be owned by `from`.
434      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
435      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
436      *
437      * Emits a {Transfer} event.
438      */
439     function safeTransferFrom(
440         address from,
441         address to,
442         uint256 tokenId,
443         bytes calldata data
444     ) external;
445 }
446 
447 
448 
449 pragma solidity ^0.8.0;
450 
451 /**
452  * @title ERC721 token receiver interface
453  * @dev Interface for any contract that wants to support safeTransfers
454  * from ERC721 asset contracts.
455  */
456 interface IERC721Receiver {
457     /**
458      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
459      * by `operator` from `from`, this function is called.
460      *
461      * It must return its Solidity selector to confirm the token transfer.
462      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
463      *
464      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
465      */
466     function onERC721Received(
467         address operator,
468         address from,
469         uint256 tokenId,
470         bytes calldata data
471     ) external returns (bytes4);
472 }
473 
474 
475 
476 pragma solidity ^0.8.0;
477 
478 /*
479  * @dev Provides information about the current execution context, including the
480  * sender of the transaction and its data. While these are generally available
481  * via msg.sender and msg.data, they should not be accessed in such a direct
482  * manner, since when dealing with meta-transactions the account sending and
483  * paying for execution may not be the actual sender (as far as an application
484  * is concerned).
485  *
486  * This contract is only required for intermediate, library-like contracts.
487  */
488 abstract contract Context {
489     function _msgSender() internal view virtual returns (address) {
490         return msg.sender;
491     }
492 
493     function _msgData() internal view virtual returns (bytes calldata) {
494         return msg.data;
495     }
496 }
497 
498 
499 pragma solidity ^0.8.0;
500 
501 /**
502  * @dev String operations.
503  */
504 library Strings {
505     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
506 
507     /**
508      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
509      */
510     function toString(uint256 value) internal pure returns (string memory) {
511         // Inspired by OraclizeAPI's implementation - MIT licence
512         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
513 
514         if (value == 0) {
515             return "0";
516         }
517         uint256 temp = value;
518         uint256 digits;
519         while (temp != 0) {
520             digits++;
521             temp /= 10;
522         }
523         bytes memory buffer = new bytes(digits);
524         while (value != 0) {
525             digits -= 1;
526             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
527             value /= 10;
528         }
529         return string(buffer);
530     }
531 
532     /**
533      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
534      */
535     function toHexString(uint256 value) internal pure returns (string memory) {
536         if (value == 0) {
537             return "0x00";
538         }
539         uint256 temp = value;
540         uint256 length = 0;
541         while (temp != 0) {
542             length++;
543             temp >>= 8;
544         }
545         return toHexString(value, length);
546     }
547 
548     /**
549      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
550      */
551     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
552         bytes memory buffer = new bytes(2 * length + 2);
553         buffer[0] = "0";
554         buffer[1] = "x";
555         for (uint256 i = 2 * length + 1; i > 1; --i) {
556             buffer[i] = _HEX_SYMBOLS[value & 0xf];
557             value >>= 4;
558         }
559         require(value == 0, "Strings: hex length insufficient");
560         return string(buffer);
561     }
562 }
563 
564 
565 
566 pragma solidity ^0.8.0;
567 
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Enumerable is IERC721 {
574     /**
575      * @dev Returns the total amount of tokens stored by the contract.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
581      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
582      */
583     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
584 
585     /**
586      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
587      * Use along with {totalSupply} to enumerate all tokens.
588      */
589     function tokenByIndex(uint256 index) external view returns (uint256);
590 }
591 
592 
593 
594 pragma solidity ^0.8.0;
595 
596 
597 
598 /**
599  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
600  * @dev See https://eips.ethereum.org/EIPS/eip-721
601  */
602 interface IERC721Metadata is IERC721 {
603     /**
604      * @dev Returns the token collection name.
605      */
606     function name() external view returns (string memory);
607 
608     /**
609      * @dev Returns the token collection symbol.
610      */
611     function symbol() external view returns (string memory);
612 
613     /**
614      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
615      */
616     function tokenURI(uint256 tokenId) external view returns (string memory);
617 }
618 
619 
620 
621 pragma solidity ^0.8.0;
622 
623 /**
624  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
625  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
626  *
627  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
628  *
629  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
630  *
631  * Does not support burning tokens to address(0).
632  */
633 contract ERC721A is
634   Context,
635   ERC165,
636   IERC721,
637   IERC721Metadata,
638   IERC721Enumerable
639 {
640   using Address for address;
641   using Strings for uint256;
642 
643   struct TokenOwnership {
644     address addr;
645     uint64 startTimestamp;
646   }
647 
648   struct AddressData {
649     uint128 balance;
650     uint128 numberMinted;
651   }
652 
653   uint256 private currentIndex = 1;
654 
655   uint256 internal immutable collectionSize;
656   uint256 internal immutable maxBatchSize;
657 
658   // Token name
659   string private _name;
660 
661   // Token symbol
662   string private _symbol;
663 
664   // Mapping from token ID to ownership details
665   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
666   mapping(uint256 => TokenOwnership) private _ownerships;
667 
668   // Mapping owner address to address data
669   mapping(address => AddressData) private _addressData;
670 
671   // Mapping from token ID to approved address
672   mapping(uint256 => address) private _tokenApprovals;
673 
674   // Mapping from owner to operator approvals
675   mapping(address => mapping(address => bool)) private _operatorApprovals;
676 
677   /**
678    * @dev
679    * `maxBatchSize` refers to how much a minter can mint at a time.
680    * `collectionSize_` refers to how many tokens are in the collection.
681    */
682   constructor(
683     string memory name_,
684     string memory symbol_,
685     uint256 maxBatchSize_,
686     uint256 collectionSize_
687   ) {
688     require(
689       collectionSize_ > 0,
690       "ERC721A: collection must have a nonzero supply"
691     );
692     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
693     _name = name_;
694     _symbol = symbol_;
695     maxBatchSize = maxBatchSize_;
696     collectionSize = collectionSize_;
697   }
698 
699   /**
700    * @dev See {IERC721Enumerable-totalSupply}.
701    */
702   function totalSupplyA() private view returns (uint256) {
703     return currentIndex;
704   }
705 
706   function totalSupply() public view override returns (uint256) {
707     return currentIndex - 1;
708   }
709 
710   /**
711    * @dev See {IERC721Enumerable-tokenByIndex}.
712    */
713   function tokenByIndex(uint256 index) public view override returns (uint256) {
714     require(index < totalSupplyA(), "ERC721A: global index out of bounds");
715     return index;
716   }
717 
718   /**
719    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
720    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
721    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
722    */
723   function tokenOfOwnerByIndex(address owner, uint256 index)
724     public
725     view
726     override
727     returns (uint256)
728   {
729     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
730     uint256 numMintedSoFar = totalSupplyA();
731     uint256 tokenIdsIdx = 0;
732     address currOwnershipAddr = address(0);
733     for (uint256 i = 0; i < numMintedSoFar; i++) {
734       TokenOwnership memory ownership = _ownerships[i];
735       if (ownership.addr != address(0)) {
736         currOwnershipAddr = ownership.addr;
737       }
738       if (currOwnershipAddr == owner) {
739         if (tokenIdsIdx == index) {
740           return i;
741         }
742         tokenIdsIdx++;
743       }
744     }
745     revert("ERC721A: unable to get token of owner by index");
746   }
747 
748   /**
749    * @dev See {IERC165-supportsInterface}.
750    */
751   function supportsInterface(bytes4 interfaceId)
752     public
753     view
754     virtual
755     override(ERC165, IERC165)
756     returns (bool)
757   {
758     return
759       interfaceId == type(IERC721).interfaceId ||
760       interfaceId == type(IERC721Metadata).interfaceId ||
761       interfaceId == type(IERC721Enumerable).interfaceId ||
762       super.supportsInterface(interfaceId);
763   }
764 
765   /**
766    * @dev See {IERC721-balanceOf}.
767    */
768   function balanceOf(address owner) public view override returns (uint256) {
769     require(owner != address(0), "ERC721A: balance query for the zero address");
770     return uint256(_addressData[owner].balance);
771   }
772 
773   function _numberMinted(address owner) internal view returns (uint256) {
774     require(
775       owner != address(0),
776       "ERC721A: number minted query for the zero address"
777     );
778     return uint256(_addressData[owner].numberMinted);
779   }
780 
781   function ownershipOf(uint256 tokenId)
782     internal
783     view
784     returns (TokenOwnership memory)
785   {
786     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
787 
788     uint256 lowestTokenToCheck;
789     if (tokenId >= maxBatchSize) {
790       lowestTokenToCheck = tokenId - maxBatchSize + 1;
791     }
792 
793     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
794       TokenOwnership memory ownership = _ownerships[curr];
795       if (ownership.addr != address(0)) {
796         return ownership;
797       }
798     }
799 
800     revert("ERC721A: unable to determine the owner of token");
801   }
802 
803   /**
804    * @dev See {IERC721-ownerOf}.
805    */
806   function ownerOf(uint256 tokenId) public view override returns (address) {
807     return ownershipOf(tokenId).addr;
808   }
809 
810   /**
811    * @dev See {IERC721Metadata-name}.
812    */
813   function name() public view virtual override returns (string memory) {
814     return _name;
815   }
816 
817   /**
818    * @dev See {IERC721Metadata-symbol}.
819    */
820   function symbol() public view virtual override returns (string memory) {
821     return _symbol;
822   }
823 
824   /**
825    * @dev See {IERC721Metadata-tokenURI}.
826    */
827   function tokenURI(uint256 tokenId)
828     public
829     view
830     virtual
831     override
832     returns (string memory)
833   {
834     require(
835       _exists(tokenId),
836       "ERC721Metadata: URI query for nonexistent token"
837     );
838 
839     string memory baseURI = _baseURI();
840     return
841       bytes(baseURI).length > 0
842         ? string(abi.encodePacked(baseURI, tokenId.toString()))
843         : "";
844   }
845 
846   /**
847    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849    * by default, can be overriden in child contracts.
850    */
851   function _baseURI() internal view virtual returns (string memory) {
852     return "";
853   }
854 
855   /**
856    * @dev See {IERC721-approve}.
857    */
858   function approve(address to, uint256 tokenId) public override {
859     address owner = ERC721A.ownerOf(tokenId);
860     require(to != owner, "ERC721A: approval to current owner");
861 
862     require(
863       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
864       "ERC721A: approve caller is not owner nor approved for all"
865     );
866 
867     _approve(to, tokenId, owner);
868   }
869 
870   /**
871    * @dev See {IERC721-getApproved}.
872    */
873   function getApproved(uint256 tokenId) public view override returns (address) {
874     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
875 
876     return _tokenApprovals[tokenId];
877   }
878 
879   /**
880    * @dev See {IERC721-setApprovalForAll}.
881    */
882   function setApprovalForAll(address operator, bool approved) public override {
883     require(operator != _msgSender(), "ERC721A: approve to caller");
884 
885     _operatorApprovals[_msgSender()][operator] = approved;
886     emit ApprovalForAll(_msgSender(), operator, approved);
887   }
888 
889   /**
890    * @dev See {IERC721-isApprovedForAll}.
891    */
892   function isApprovedForAll(address owner, address operator)
893     public
894     view
895     virtual
896     override
897     returns (bool)
898   {
899     return _operatorApprovals[owner][operator];
900   }
901 
902   /**
903    * @dev See {IERC721-transferFrom}.
904    */
905   function transferFrom(
906     address from,
907     address to,
908     uint256 tokenId
909   ) public virtual override {
910     _transfer(from, to, tokenId);
911   }
912 
913   /**
914    * @dev See {IERC721-safeTransferFrom}.
915    */
916   function safeTransferFrom(
917     address from,
918     address to,
919     uint256 tokenId
920   ) public override {
921     safeTransferFrom(from, to, tokenId, "");
922   }
923 
924   /**
925    * @dev See {IERC721-safeTransferFrom}.
926    */
927   function safeTransferFrom(
928     address from,
929     address to,
930     uint256 tokenId,
931     bytes memory _data
932   ) public virtual override {
933     _transfer(from, to, tokenId);
934     require(
935       _checkOnERC721Received(from, to, tokenId, _data),
936       "ERC721A: transfer to non ERC721Receiver implementer"
937     );
938   }
939 
940   /**
941    * @dev Returns whether `tokenId` exists.
942    *
943    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
944    *
945    * Tokens start existing when they are minted (`_mint`),
946    */
947   function _exists(uint256 tokenId) internal view returns (bool) {
948     return tokenId < currentIndex;
949   }
950 
951   function _safeMint(address to, uint256 quantity) internal {
952     _safeMint(to, quantity, "");
953   }
954 
955   function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
956          require(_exists(tokenId), "ERC721: operator query for nonexistent token");
957          address owner = ERC721A.ownerOf(tokenId);
958          return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
959    }
960   /**
961    * @dev Mints `quantity` tokens and transfers them to `to`.
962    *
963    * Requirements:
964    *
965    * - there must be `quantity` tokens remaining unminted in the total collection.
966    * - `to` cannot be the zero address.
967    * - `quantity` cannot be larger than the max batch size.
968    *
969    * Emits a {Transfer} event.
970    */
971 
972 
973 
974   function _safeMint(
975     address to,
976     uint256 quantity,
977     bytes memory _data
978   ) internal {
979     uint256 startTokenId = currentIndex;
980     require(to != address(0), "ERC721A: mint to the zero address");
981     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
982     require(!_exists(startTokenId), "ERC721A: token already minted");
983     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
984 
985     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
986 
987     AddressData memory addressData = _addressData[to];
988     _addressData[to] = AddressData(
989       addressData.balance + uint128(quantity),
990       addressData.numberMinted + uint128(quantity)
991     );
992     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
993 
994     uint256 updatedIndex = startTokenId;
995 
996     for (uint256 i = 0; i < quantity; i++) {
997       emit Transfer(address(0), to, updatedIndex);
998       require(
999         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1000         "ERC721A: transfer to non ERC721Receiver implementer"
1001       );
1002       updatedIndex++;
1003     }
1004 
1005     currentIndex = updatedIndex;
1006     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1007   }
1008 
1009   /**
1010    * @dev Transfers `tokenId` from `from` to `to`.
1011    *
1012    * Requirements:
1013    *
1014    * - `to` cannot be the zero address.
1015    * - `tokenId` token must be owned by `from`.
1016    *
1017    * Emits a {Transfer} event.
1018    */
1019   function _transfer(
1020     address from,
1021     address to,
1022     uint256 tokenId
1023   ) internal virtual {
1024     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1025 
1026     require(
1027       prevOwnership.addr == from,
1028       "ERC721A: transfer from incorrect owner"
1029     );
1030     require(to != address(0), "ERC721A: transfer to the zero address");
1031 
1032     _beforeTokenTransfers(from, to, tokenId, 1);
1033 
1034     // Clear approvals from the previous owner
1035     _approve(address(0), tokenId, prevOwnership.addr);
1036 
1037     _addressData[from].balance -= 1;
1038     _addressData[to].balance += 1;
1039     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1040 
1041     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1042     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1043     uint256 nextTokenId = tokenId + 1;
1044     if (_ownerships[nextTokenId].addr == address(0)) {
1045       if (_exists(nextTokenId)) {
1046         _ownerships[nextTokenId] = TokenOwnership(
1047           prevOwnership.addr,
1048           prevOwnership.startTimestamp
1049         );
1050       }
1051     }
1052 
1053     emit Transfer(from, to, tokenId);
1054     _afterTokenTransfers(from, to, tokenId, 1);
1055   }
1056 
1057   /**
1058    * @dev Approve `to` to operate on `tokenId`
1059    *
1060    * Emits a {Approval} event.
1061    */
1062   function _approve(
1063     address to,
1064     uint256 tokenId,
1065     address owner
1066   ) private {
1067     _tokenApprovals[tokenId] = to;
1068     emit Approval(owner, to, tokenId);
1069   }
1070 
1071   uint256 public nextOwnerToExplicitlySet = 0;
1072 
1073   /**
1074    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1075    */
1076   function _setOwnersExplicit(uint256 quantity) internal {
1077     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1078     require(quantity > 0, "quantity must be nonzero");
1079     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1080     if (endIndex > collectionSize - 1) {
1081       endIndex = collectionSize - 1;
1082     }
1083     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1084     require(_exists(endIndex), "not enough minted yet for this cleanup");
1085     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1086       if (_ownerships[i].addr == address(0)) {
1087         TokenOwnership memory ownership = ownershipOf(i);
1088         _ownerships[i] = TokenOwnership(
1089           ownership.addr,
1090           ownership.startTimestamp
1091         );
1092       }
1093     }
1094     nextOwnerToExplicitlySet = endIndex + 1;
1095   }
1096 
1097   /**
1098    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1099    * The call is not executed if the target address is not a contract.
1100    *
1101    * @param from address representing the previous owner of the given token ID
1102    * @param to target address that will receive the tokens
1103    * @param tokenId uint256 ID of the token to be transferred
1104    * @param _data bytes optional data to send along with the call
1105    * @return bool whether the call correctly returned the expected magic value
1106    */
1107   function _checkOnERC721Received(
1108     address from,
1109     address to,
1110     uint256 tokenId,
1111     bytes memory _data
1112   ) private returns (bool) {
1113     if (to.isContract()) {
1114       try
1115         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1116       returns (bytes4 retval) {
1117         return retval == IERC721Receiver(to).onERC721Received.selector;
1118       } catch (bytes memory reason) {
1119         if (reason.length == 0) {
1120           revert("ERC721A: transfer to non ERC721Receiver implementer");
1121         } else {
1122           assembly {
1123             revert(add(32, reason), mload(reason))
1124           }
1125         }
1126       }
1127     } else {
1128       return true;
1129     }
1130   }
1131 
1132   /**
1133    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1134    *
1135    * startTokenId - the first token id to be transferred
1136    * quantity - the amount to be transferred
1137    *
1138    * Calling conditions:
1139    *
1140    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1141    * transferred to `to`.
1142    * - When `from` is zero, `tokenId` will be minted for `to`.
1143    */
1144   function _beforeTokenTransfers(
1145     address from,
1146     address to,
1147     uint256 startTokenId,
1148     uint256 quantity
1149   ) internal virtual {}
1150 
1151   /**
1152    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1153    * minting.
1154    *
1155    * startTokenId - the first token id to be transferred
1156    * quantity - the amount to be transferred
1157    *
1158    * Calling conditions:
1159    *
1160    * - when `from` and `to` are both non-zero.
1161    * - `from` and `to` are never both zero.
1162    */
1163   function _afterTokenTransfers(
1164     address from,
1165     address to,
1166     uint256 startTokenId,
1167     uint256 quantity
1168   ) internal virtual {}
1169 }
1170 
1171 
1172 
1173 pragma solidity ^0.8.0;
1174 
1175 /**
1176  * @dev Contract module that helps prevent reentrant calls to a function.
1177  *
1178  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1179  * available, which can be applied to functions to make sure there are no nested
1180  * (reentrant) calls to them.
1181  *
1182  * Note that because there is a single `nonReentrant` guard, functions marked as
1183  * `nonReentrant` may not call one another. This can be worked around by making
1184  * those functions `private`, and then adding `external` `nonReentrant` entry
1185  * points to them.
1186  *
1187  * TIP: If you would like to learn more about reentrancy and alternative ways
1188  * to protect against it, check out our blog post
1189  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1190  */
1191 abstract contract ReentrancyGuard {
1192     // Booleans are more expensive than uint256 or any type that takes up a full
1193     // word because each write operation emits an extra SLOAD to first read the
1194     // slot's contents, replace the bits taken up by the boolean, and then write
1195     // back. This is the compiler's defense against contract upgrades and
1196     // pointer aliasing, and it cannot be disabled.
1197 
1198     // The values being non-zero value makes deployment a bit more expensive,
1199     // but in exchange the refund on every call to nonReentrant will be lower in
1200     // amount. Since refunds are capped to a percentage of the total
1201     // transaction's gas, it is best to keep them low in cases like this one, to
1202     // increase the likelihood of the full refund coming into effect.
1203     uint256 private constant _NOT_ENTERED = 1;
1204     uint256 private constant _ENTERED = 2;
1205 
1206     uint256 private _status;
1207 
1208     constructor() {
1209         _status = _NOT_ENTERED;
1210     }
1211 
1212     /**
1213      * @dev Prevents a contract from calling itself, directly or indirectly.
1214      * Calling a `nonReentrant` function from another `nonReentrant`
1215      * function is not supported. It is possible to prevent this from happening
1216      * by making the `nonReentrant` function external, and make it call a
1217      * `private` function that does the actual work.
1218      */
1219     modifier nonReentrant() {
1220         // On the first call to nonReentrant, _notEntered will be true
1221         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1222 
1223         // Any calls to nonReentrant after this point will fail
1224         _status = _ENTERED;
1225 
1226         _;
1227 
1228         // By storing the original value once again, a refund is triggered (see
1229         // https://eips.ethereum.org/EIPS/eip-2200)
1230         _status = _NOT_ENTERED;
1231     }
1232 }
1233 
1234 
1235 
1236 pragma solidity ^0.8.0;
1237 
1238 
1239 /**
1240  * @dev Contract module which provides a basic access control mechanism, where
1241  * there is an account (an owner) that can be granted exclusive access to
1242  * specific functions.
1243  *
1244  * By default, the owner account will be the one that deploys the contract. This
1245  * can later be changed with {transferOwnership}.
1246  *
1247  * This module is used through inheritance. It will make available the modifier
1248  * `onlyOwner`, which can be applied to your functions to restrict their use to
1249  * the owner.
1250  */
1251 abstract contract Ownable is Context {
1252     address private _owner;
1253 
1254     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1255 
1256     /**
1257      * @dev Initializes the contract setting the deployer as the initial owner.
1258      */
1259     constructor() {
1260         _setOwner(_msgSender());
1261     }
1262 
1263     /**
1264      * @dev Returns the address of the current owner.
1265      */
1266     function owner() public view virtual returns (address) {
1267         return _owner;
1268     }
1269 
1270     /**
1271      * @dev Throws if called by any account other than the owner.
1272      */
1273     modifier onlyOwner() {
1274         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1275         _;
1276     }
1277 
1278     /**
1279      * @dev Leaves the contract without owner. It will not be possible to call
1280      * `onlyOwner` functions anymore. Can only be called by the current owner.
1281      *
1282      * NOTE: Renouncing ownership will leave the contract without an owner,
1283      * thereby removing any functionality that is only available to the owner.
1284      */
1285     function renounceOwnership() public virtual onlyOwner {
1286         _setOwner(address(0));
1287     }
1288 
1289     /**
1290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1291      * Can only be called by the current owner.
1292      */
1293     function transferOwnership(address newOwner) public virtual onlyOwner {
1294         require(newOwner != address(0), "Ownable: new owner is the zero address");
1295         _setOwner(newOwner);
1296     }
1297 
1298     function _setOwner(address newOwner) private {
1299         address oldOwner = _owner;
1300         _owner = newOwner;
1301         emit OwnershipTransferred(oldOwner, newOwner);
1302     }
1303 }
1304 
1305 
1306 pragma solidity ^0.8.0;
1307 
1308 
1309 contract Distortion is ERC721A, Ownable, ReentrancyGuard {
1310 
1311 
1312 
1313   bool public isClaimActive = false;
1314   uint public maxSupply = 1000;
1315   uint public maxFree = 200;
1316   uint256 public price = 0.05 ether;    
1317   address payable private immutable payoutAddress;
1318 
1319 
1320   // keep track of wallets that have claimed
1321   mapping(address => uint) private claimed;
1322   mapping(address => uint) private claimedFree;
1323 
1324   // randomness of block in the future (#xxxxxxxx)
1325   string private hashOfBlock;
1326   bool private hashSet = false;
1327 
1328   constructor(
1329     address payable _payoutAddress
1330   ) ERC721A("Distortion", "DST", 1, maxSupply) {
1331 
1332     require(_payoutAddress != address(0));
1333     payoutAddress = _payoutAddress;
1334 
1335   }
1336 
1337 
1338   /*
1339 
1340   ███╗░░░███╗██╗███╗░░██╗████████╗
1341   ████╗░████║██║████╗░██║╚══██╔══╝
1342   ██╔████╔██║██║██╔██╗██║░░░██║░░░
1343   ██║╚██╔╝██║██║██║╚████║░░░██║░░░
1344   ██║░╚═╝░██║██║██║░╚███║░░░██║░░░
1345   ╚═╝░░░░░╚═╝╚═╝╚═╝░░╚══╝░░░╚═╝░░░
1346   Information on 0xDistortion.com
1347   */
1348 
1349   function mint() public payable callerIsWallet {
1350     require(isClaimActive, "Claim is not active...");
1351     require(totalSupply() + 1 <= maxSupply, "We have no more supply in stock.");
1352 
1353     if (totalSupply() + 1 > maxFree) {
1354       require(price == msg.value, "Wrong ether amount. Free supply depleted.");
1355       require(claimed[msg.sender] + 1 <= 2, "Max 2 per wallet."); 
1356       claimed[msg.sender] += 1;
1357 
1358     } else {
1359       require(msg.value == 0, "Don't send ether for the free mint.");
1360       require(claimedFree[msg.sender] < 1, "You can only get 1 free mint.");
1361       claimedFree[msg.sender] += 1;
1362     }
1363     
1364     _safeMint(msg.sender, 1);
1365   }
1366 
1367 
1368 
1369   /*
1370   ██████╗░███████╗██╗░░░██╗
1371   ██╔══██╗██╔════╝██║░░░██║
1372   ██║░░██║█████╗░░╚██╗░██╔╝
1373   ██║░░██║██╔══╝░░░╚████╔╝░
1374   ██████╔╝███████╗░░╚██╔╝░░
1375   ╚═════╝░╚══════╝░░░╚═╝░░░
1376   Developer functions:
1377   - Dev mint
1378   - Dev airdrop
1379   - Start the sale/claim
1380   - Update the price of the sale
1381   - Update the hash/provenance for the reveal (can only be called once)
1382   */
1383 
1384   function devMint() public onlyOwner {
1385     require(totalSupply() + 1 <= maxSupply, "Creator cannot mint if supply has been reached.");
1386     _safeMint(msg.sender, 1);
1387   }
1388 
1389   function devAirdrop(address _recipient) public onlyOwner {
1390     require(totalSupply() + 1 <= maxSupply, "Creator cannot airdrop if supply has been reached.");
1391     _safeMint(_recipient, 1);
1392   }
1393 
1394 
1395   function setClaimState(bool _trueOrFalse) public onlyOwner {
1396     isClaimActive = _trueOrFalse;
1397   }
1398 
1399   // adding the hash of the block of the last mint to ensure randomness.
1400   function updateHash(string memory _hash) public onlyOwner {
1401     require(!hashSet, "Randomness hash can only be set once by the deployer.");
1402     hashOfBlock = _hash;
1403     hashSet = true;
1404   }
1405 
1406   function updatePrice(uint256 _price) public onlyOwner {
1407     price = _price;
1408   }
1409 
1410 
1411 
1412   /*
1413 
1414   ░██████╗░███████╗███╗░░██╗███████╗██████╗░░█████╗░████████╗██╗██╗░░░██╗███████╗
1415   ██╔════╝░██╔════╝████╗░██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║██║░░░██║██╔════╝
1416   ██║░░██╗░█████╗░░██╔██╗██║█████╗░░██████╔╝███████║░░░██║░░░██║╚██╗░██╔╝█████╗░░
1417   ██║░░╚██╗██╔══╝░░██║╚████║██╔══╝░░██╔══██╗██╔══██║░░░██║░░░██║░╚████╔╝░██╔══╝░░
1418   ╚██████╔╝███████╗██║░╚███║███████╗██║░░██║██║░░██║░░░██║░░░██║░░╚██╔╝░░███████╗
1419   ░╚═════╝░╚══════╝╚═╝░░╚══╝╚══════╝╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░░╚═╝░░░╚══════╝
1420   Everything to do with the on-chain generation of the Distortion pieces.
1421   */
1422 
1423 
1424 
1425   string[] private colorNames = [
1426     'White' ,
1427     'Red',
1428     'Green',
1429     'Blue',
1430     'Gold',
1431     'Rose',
1432     'Purple'
1433   ]; 
1434 
1435 
1436   string[] private left = [
1437     'rgb(140,140,140)' ,
1438     'rgb(255, 26, 26)',
1439     'rgb(92, 214, 92)',
1440     'rgb(26, 140, 255)',
1441     'rgb(255, 215, 0)',
1442     'rgb(255, 128, 128)',
1443     'rgb(192, 50, 227)'
1444   ]; 
1445 
1446   string[] private right = [
1447     'rgb(52,52,52)' ,
1448     'rgb(230, 0, 0)',
1449     'rgb(51, 204, 51)',
1450     'rgb(0, 115, 230)',
1451     'rgb(204, 173, 0)',
1452     'rgb(255, 102, 102)',
1453     'rgb(167, 40, 199)'
1454   ]; 
1455 
1456   string[] private middleLeft = [
1457     'rgb(57,57,57)' ,
1458     'rgb(179, 0, 0)',
1459     'rgb(41, 163, 41)',
1460     'rgb(0, 89, 179)',
1461     'rgb(153, 130, 0)',
1462     'rgb(255, 77, 77)',
1463     'rgb(127, 32, 150)'
1464   ]; 
1465 
1466   string[] private middleRight = [
1467     'rgb(20,20,20)',
1468     'rgb(128, 0, 0)',
1469     'rgb(31, 122, 31)',
1470     'rgb(0, 64, 128)',
1471     'rgb(179, 152, 0)',
1472     'rgb(255, 51, 51)',
1473     'rgb(98, 19, 117)'
1474   ]; 
1475   
1476 
1477 
1478 
1479   string[] private frequencies = [
1480     '',
1481     '0',
1482     '00'
1483   ]; 
1484 
1485         
1486   function generateString(string memory name, uint256 tokenId, string[] memory array) internal view returns (string memory) {
1487 
1488     uint rand = uint(keccak256(abi.encodePacked(name, toString(tokenId)))) % array.length;
1489     string memory output = string(abi.encodePacked(array[rand % array.length]));
1490     return output;
1491 
1492   }
1493 
1494 
1495   function generateColorNumber(string memory name, uint256 tokenId) internal view returns (uint) {
1496 
1497     uint output;
1498     uint rand = uint(keccak256(abi.encodePacked(name, toString(tokenId)))) % 100;
1499 
1500     if (keccak256(bytes(hashOfBlock)) == keccak256(bytes(''))) {
1501         output = 0; //unrevealed
1502     } else {
1503       if (rand <= 15) {
1504         output = 1; //Red with 15% rarity.
1505       } else if (rand > 15 && rand <= 30) {
1506         output = 2; //Green with 15% rarity.
1507       } else if (rand > 30 && rand <= 45) {
1508         output = 3; //Blue with 15% rarity.
1509       } else if (rand > 45 && rand <= 75) {
1510         output = 0; //Black with 30% rarity.
1511       } else if (rand > 75 && rand <= 80) {
1512         output = 4; //Gold with 5% rarity.
1513       } else if (rand > 80 && rand <= 90) {
1514         output = 5; //Rose with 10% rarity.
1515       } else if (rand > 90) {
1516         output = 6; //Purple with 10% rarity.
1517       }
1518 
1519     }
1520     return output;
1521   }
1522 
1523 
1524   function generateNum(string memory name, uint256 tokenId, string memory genVar, uint low, uint high) internal view returns (string memory) {
1525 
1526     uint difference = high - low;
1527     uint randomnumber = uint(keccak256(abi.encodePacked(genVar, tokenId, name))) % difference + 1;
1528     randomnumber = randomnumber + low;
1529     return toString(randomnumber);
1530 
1531   }
1532 
1533   function generateNumUint(string memory name, uint256 tokenId, string memory genVar, uint low, uint high) internal view returns (uint) {
1534 
1535     uint difference = high - low;
1536     uint randomnumber = uint(keccak256(abi.encodePacked(genVar, tokenId, name))) % difference + 1;
1537     randomnumber = randomnumber + low;
1538     return randomnumber;
1539 
1540   }
1541 
1542 
1543   function genDefs(uint256 tokenId) internal view returns (string memory) {
1544 
1545     string memory output;
1546     string memory xFrequency = generateString("xF", tokenId, frequencies);
1547     string memory yFrequency = generateString("yF", tokenId, frequencies);
1548     string memory scale = generateNum("scale", tokenId, hashOfBlock, 10, 40);
1549 
1550     if (keccak256(bytes(hashOfBlock)) == keccak256(bytes(''))) {
1551       xFrequency = '';
1552       yFrequency = '';
1553       scale = '30';
1554     }
1555 
1556     output = string(abi.encodePacked(
1557       '<defs><filter id="squares" x="-30%" y="-30%" width="160%" height="160%"> <feTurbulence type="turbulence" baseFrequency="',
1558       '0.',
1559       xFrequency,
1560       '5 0.',
1561       yFrequency,
1562       '5',
1563       '" numOctaves="10" seed="" result="turbulence"> <animate attributeName="seed" dur="0.3s" repeatCount="indefinite" calcMode="discrete" values="1;2;3;4;5;6;7;8;9;1"/> </feTurbulence> <feDisplacementMap in="SourceGraphic" in2="turbulence" scale="',
1564       scale,
1565       '" xChannelSelector="R" yChannelSelector="G" /> </filter> </defs>'
1566       ));
1567     return output;
1568 
1569   }
1570       
1571 
1572   function genMiddle(uint256 tokenId) internal view returns (string memory) {
1573 
1574     string memory translate = toString(divide(generateNumUint("scale", tokenId, hashOfBlock, 10, 40), 5, 0));
1575     string[5] memory p;
1576 
1577     if (keccak256(bytes(hashOfBlock)) == keccak256(bytes(''))) {
1578       translate = '6';
1579     }
1580 
1581     p[0] = '<style alt="surround"> #1 { stroke-dasharray: 50,50,150 }</style> <!-- translate below is equal to scale above divided by 5 --> <!-- x starts at 5, increments by 2 | width is equal to 100 - (2*x) --> <g style="filter: url(#squares);" opacity="100%" id="1"> <g transform="translate(-';
1582     p[1] = translate;
1583     p[2] = ', -';
1584     p[3] = translate;
1585     p[4] = ')" >';
1586 
1587     string memory output = string(abi.encodePacked(p[0], p[1], p[2], p[3], p[4]));
1588     return output;
1589 
1590   }
1591 
1592 
1593 
1594   function genSquares(uint256 tokenId) internal view returns (string memory) {
1595 
1596     string memory output1;
1597     string memory output2;
1598     uint ringCount = generateNumUint("ringCount", tokenId, hashOfBlock, 5, 15);
1599     string[2] memory xywh;
1600     uint ringScaling = divide(25, ringCount, 0);
1601 
1602     if (keccak256(bytes(hashOfBlock)) == keccak256(bytes(''))) {
1603       ringCount = 5;
1604       ringScaling = 5;
1605     }
1606 
1607     for (uint i = 0; i < ringCount; i++) {    
1608       xywh[0] = toString(ringScaling*i + 5);
1609       xywh[1] = toString(100 - (ringScaling*i + 5)*2);
1610       output1 = string(abi.encodePacked(
1611           '<g style="animation: glitch 1.',
1612           toString(i),
1613           's infinite;"> <rect x="',
1614           xywh[0],
1615           '%" y="',
1616           xywh[0],
1617           '%" width="',
1618           xywh[1],
1619           '%" height="',
1620           xywh[1],
1621           '%" fill="none" stroke="',
1622           left[generateColorNumber("color", tokenId)],
1623           '" id="1" /> </g>'
1624           ));
1625       output2 = string(abi.encodePacked(output1, output2));
1626     }
1627     return output2;
1628           
1629   }
1630 
1631 
1632   function genEnd(uint256 tokenId) internal view returns (string memory) {
1633 
1634     uint colorNum = generateColorNumber("color", tokenId);
1635     string[13] memory p;
1636     p[0] = '</g> </g> <!-- END SQUARES --> <g style="animation: glitch 0.5s infinite;filter: url(#squares);"> <g transform="scale(0.50) translate(370, 287)" style="opacity:40%"> <path fill="';
1637     p[1] = right[colorNum];
1638     p[2] = '" d="M125.166 285.168l2.795 2.79 127.962-75.638L127.961 0l-2.795 9.5z"/><path fill="';
1639     p[3] = left[colorNum];
1640     p[4] = '" d="M127.962 287.959V0L0 212.32z"/><path fill="';
1641     p[5] = right[colorNum];
1642     p[6] = '" d="M126.386 412.306l1.575 4.6L256 236.587l-128.038 75.6-1.575 1.92z"/><path fill="';
1643     p[7] = left[colorNum];
1644     p[8] = '" d="M0 236.585l127.962 180.32v-104.72z"/><path fill="';
1645     p[9] = middleRight[colorNum];
1646     p[10] = '" d="M127.961 154.159v133.799l127.96-75.637z"/><path fill="';
1647     p[11] = middleLeft[colorNum];
1648     p[12] = '" d="M127.96 154.159L0 212.32l127.96 75.637z"/> </g> </g> </svg>';
1649     string memory output = string(abi.encodePacked(p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], p[8]));
1650     output = string(abi.encodePacked(output, p[9], p[10], p[11], p[12]));
1651     return output;
1652 
1653   }
1654 
1655 
1656   function generateDistortion(uint256 tokenId) public view returns (string memory) {
1657 
1658     string memory output;
1659     output = string(abi.encodePacked(
1660         '<svg width="750px" height="750px" viewBox="0 0 500 500" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="background-color: #101010;"> <!-- START BACKGROUND --> <style> @keyframes glitch { 0% {transform: translate(0px); opacity: 0.15;} 7% {transform: translate(2px); opacity: 0.65;} 45% {transform: translate(0px); opacity: 0.35;} 50% {transform: translate(-2px); opacity: 0.85;} 100% {transform: translate(0px); opacity: 0.25;} } </style> <defs> <filter id="background" x="-20%" y="-20%" width="140%" height="140%" filterUnits="objectBoundingBox" primitiveUnits="userSpaceOnUse" color-interpolation-filters="linearRGB"> <feTurbulence type="fractalNoise" baseFrequency="10" numOctaves="4" seed="1" stitchTiles="stitch" x="0%" y="0%" width="100%" height="100%" result="turbulence"> <animate attributeName="seed" dur="1s" repeatCount="indefinite" calcMode="discrete" values="1;2;3;4;5;6;7;8;9;10" /> </feTurbulence> <feSpecularLighting surfaceScale="10" specularExponent="10" lighting-color="#fff" width="100%" height="100%"> <animate attributeName="surfaceScale" dur="1s" repeatCount="indefinite" calcMode="discrete" values="10;11;12;13;14;15;14;13;12;11" /> <feDistantLight elevation="100"/> </feSpecularLighting> </filter> </defs> <g opacity="10%"> <rect width="700" height="700" fill="hsl(23, 0%, 100%)" filter="url(#background)"></rect> </g> <!-- END BACKGROUND --> <!-- START SQUARES -->',
1661         genDefs(tokenId),
1662         genMiddle(tokenId),
1663         genSquares(tokenId),
1664         genEnd(tokenId)
1665         ));
1666     return output;
1667 
1668   }
1669     
1670     
1671   function getFrequency(uint256 tokenId) internal view returns (uint) {
1672 
1673     uint[2] memory xy;
1674     string memory y = generateString("yF", tokenId, frequencies);
1675     string memory x = generateString("xF", tokenId, frequencies);
1676 
1677     if (keccak256(bytes(x)) == keccak256(bytes('0'))){
1678       xy[0] = 2;
1679     } else if (keccak256(bytes(x)) == keccak256(bytes('00'))){
1680       xy[0] = 1;
1681     } else {
1682       xy[0] = 3;
1683     }
1684 
1685     if (keccak256(bytes(y)) == keccak256(bytes('0'))){
1686       xy[1] = 2;
1687     } else if (keccak256(bytes(y)) == keccak256(bytes('00'))){
1688       xy[1] = 1;
1689     } else {
1690       xy[1] = 3;
1691     }
1692     return xy[0] * xy[1];
1693 
1694   }
1695 
1696 
1697 
1698   /**
1699   * @dev See {IERC721Metadata-tokenURI}.
1700   */
1701   function tokenURI(uint256 tokenId) override public view returns (string memory) {
1702     
1703     string memory ringCount = generateNum("ringCount", tokenId, hashOfBlock, 5, 15);
1704     string memory scale = generateNum("scale", tokenId, hashOfBlock, 10, 40);
1705     uint freq = getFrequency(tokenId);
1706     string memory unr;
1707 
1708     // if unrevealed
1709     if (keccak256(bytes(hashOfBlock)) == keccak256(bytes(''))) { scale = '0'; ringCount = '0'; unr = ' (Unrevealed)'; freq = 0;}
1710 
1711     string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Distortion #', toString(tokenId), unr,
1712     '","attributes": [ { "trait_type": "Color", "value": "',
1713     colorNames[generateColorNumber("color", tokenId)],
1714     '" }, { "trait_type": "Distortion Scale", "value": ',
1715     scale,
1716     ' }, { "trait_type": "Rings", "value": ', 
1717     ringCount,
1718     ' }, { "trait_type": "Frequency Multiple", "value": ', 
1719     toString(freq),
1720     ' }]',
1721     ', "description": "Distortion is a fully hand-typed 100% on-chain art collection limited to 1,000 pieces.", "image": "data:image/svg+xml;base64,',
1722     Base64.encode(bytes(string(abi.encodePacked(generateDistortion(tokenId))))),
1723     '"}'))));
1724     string memory output = string(abi.encodePacked('data:application/json;base64,', json));
1725 
1726     return output;
1727 
1728   }
1729 	
1730 	
1731   /**
1732     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1733     */
1734   function toString(uint256 value) internal pure returns (string memory) {
1735     // Inspired by OraclizeAPI's implementation - MIT licence
1736     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1737 
1738     if (value == 0) {
1739         return "0";
1740     }
1741     uint256 temp = value;
1742     uint256 digits;
1743     while (temp != 0) {
1744         digits++;
1745         temp /= 10;
1746     }
1747     bytes memory buffer = new bytes(digits);
1748     while (value != 0) {
1749         digits -= 1;
1750         buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1751         value /= 10;
1752     }
1753     return string(buffer);
1754   }
1755 
1756 
1757   function divide(uint a, uint b, uint precision) internal view returns ( uint) {
1758     return a*(10**precision)/b;
1759   }
1760 
1761 
1762   /**
1763   * @dev safety measure
1764   */
1765   modifier callerIsWallet() {
1766     require(tx.origin == msg.sender, "The caller is another contract");
1767     _;
1768   }
1769 
1770 
1771   function withdraw() public onlyOwner {
1772     uint256 balance = address(this).balance;
1773     Address.sendValue(payoutAddress, balance);
1774   }
1775 
1776 
1777   /**
1778   * @notice For the attributes to be revealed, the hash of the block of the final mint must be set so provenance can be verified.
1779   *
1780   */
1781   function getHash() public view returns (string memory) {
1782     return hashOfBlock;
1783   }
1784 
1785 
1786 }
1787 
1788 
1789 /// [MIT License]
1790 /// @title Base64
1791 /// @notice Provides a function for encoding some bytes in base64
1792 /// @author Brecht Devos <brecht@loopring.org>
1793 library Base64 {
1794     bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
1795 
1796     /// @notice Encodes some bytes to the base64 representation
1797     function encode(bytes memory data) internal pure returns (string memory) {
1798         uint256 len = data.length;
1799         if (len == 0) return "";
1800 
1801         // multiply by 4/3 rounded up
1802         uint256 encodedLen = 4 * ((len + 2) / 3);
1803 
1804         // Add some extra buffer at the end
1805         bytes memory result = new bytes(encodedLen + 32);
1806 
1807         bytes memory table = TABLE;
1808 
1809         assembly {
1810             let tablePtr := add(table, 1)
1811             let resultPtr := add(result, 32)
1812 
1813             for {
1814                 let i := 0
1815             } lt(i, len) {
1816 
1817             } {
1818                 i := add(i, 3)
1819                 let input := and(mload(add(data, i)), 0xffffff)
1820 
1821                 let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
1822                 out := shl(8, out)
1823                 out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
1824                 out := shl(8, out)
1825                 out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
1826                 out := shl(8, out)
1827                 out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
1828                 out := shl(224, out)
1829 
1830                 mstore(resultPtr, out)
1831 
1832                 resultPtr := add(resultPtr, 4)
1833             }
1834 
1835             switch mod(len, 3)
1836             case 1 {
1837                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
1838             }
1839             case 2 {
1840                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
1841             }
1842 
1843             mstore(result, encodedLen)
1844         }
1845 
1846         return string(result);
1847     }
1848 }