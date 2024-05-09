1 // SPDX-License-Identifier: MIT
2 
3 // File contracts/experiments/Wilderness.sol
4 
5 pragma solidity ^0.8.9;
6 
7 // 4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
8 // 4444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
9 // 44444444444444444444444444444444444444444444m000@0000000mm444444444444444444444444444444444444444444
10 // 4444444444444444444444444444444444444444440@@@@@@@@@@@@@@@@0mm44444444444444444444444444444444444444
11 // 44444444444444444444444444444444444400@@0@@@@@@@@@@@@@@@@@@@@@@@m44444444444444444444444444444444444
12 // 444444444444444444444444444444444440@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0444444444444444444444444444444444
13 // 4444444444444444444444444444444m@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@044444444444444444444444444444444
14 // 44444444444444444444444444444440@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@04444444444444444444444444444444
15 // 444444444444444444444444444440@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@m444444444444444444444444444444
16 // 44444444444444444444444444440@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0m4444444444444444444444444444
17 // 444444444444444444444444444@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@4444444444444444444444444444
18 // 444444444444444444444444444@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@0000mmm40@@@@@4444444444444444444444444444
19 // 4444444444444444444444444440@@@@@@@@@@@@@@@J40@@@@@00J1............0@@@@4444444444444444444444444444
20 // 444444444444444444444444444m@@@@@@@@@@@@@@@@4......................1@@@04444444444444444444444444444
21 // 4444444444444444444444444440@@@@@@@@@@@@@@@@@1......................0@@04444444444444444444444444444
22 // 4444444444444444444444444440@@@@@@@@@@@@@@@@@1.......................@@@4444444444444444444444444444
23 // 4444444444444444444444444440@@@@@@@@@@@@@@@@@........................0@04444444444444444444444444444
24 // 444444444444444444444444444m@@@@@@@@@@@@@@@@0.....1Jmm4J111......4mmm0@44444444444444444444444444444
25 // 4444444444444444444444444444m@@@@@@@@@@@@@1.....14mmm0000m1J..1.1JJ1.m@44444444444444444444444444444
26 // 44444444444444444444444444444m@@@@@@@@@@@1.......1J4mmmJ......10.....0044444444444444444444444444444
27 // 4444444444444444444444444444440@@@@@@@@@@......................01....@m44444444444444444444444444444
28 // 4444444444444444444444444444444@@@@@@@@41.......................0....@m44444444444444444444444444444
29 // 4444444444444444444444444444444m@@@@@@@.........................01..1@m44444444444444444444444444444
30 // 444444444444444444444444444444440@@@@@@0........................1m..00444444444444444444444444444444
31 // 4444444444444444444444444444444444m00@@@1................1J.....10.1@m444444444444444444444444444444
32 // 4444444444444444444444444444444444440m.m0.................1JJJJJ4m.004444444444444444444444444444444
33 // 444444444444444444444444444444444444m0..@1........................J@44444444444444444444444444444444
34 // 44444444444444444444444444444444444440..4@...........4mmmmmmJ11101@044444444444444444444444444444444
35 // 4444444444444444444444444444444444444@...@J...........1J4m4JJJ11J4@444444444444444444444444444444444
36 // 4444444444444444444444444444444444444@...1001....................@0444444444444444444444444444444444
37 // 44444444444444444444444444444444444400......1001................m@4444444444444444444444444444444444
38 // 44444444444444444444444444444444444m@1.........100J.............@04444444444444444444444444444444444
39 // 444444444444444444444444444444444m0@0.............100J.........0044444444444444444444444444444444444
40 // 4444444444444444444444444444m00@@@@@@01..............1mmm@@@@@@@00mm44444444444444444444444444444444
41 // 444444444444444444444444m00@@@@00@@00000J...............1@@@@@@@000@@0000m44444444444444444444444444
42 // 44444444444444444444m00@@@@@@@@0mmmmmm0@@@m11JJJJJJ1111J00@@@@@0@@000m4m0000000m4JJJ44444JJ444444444
43 // 444..14441..J444...J44J.....1J441.....J4J1....144444441....141.....144441..1444J.....J41....14...444
44 // 444...14J...J441...144J.......41......14.......1444441......J1......1444....J44......41.....14...444
45 // 444....J1...J44.....J4J..14...4...J4J141..14J...4444J...441J41..14...441....144...11J41..11J44...444
46 // 444.........J41..J..14J...1...4...444441..J441..44441..144..J1.......44..11..441.....1J......4...444
47 // 444......1..14.......4J......14...J4J141..14J...4444J...44..11......J41......14JJ11...4J11...J...444
48 // 444..11..J..11.......1J..1...J41......14.......1444441......11..1...J4........4......11......J...444
49 // 444..141JJ..J...444...J..1J...441....1J4J1....144444441....1J1..1J...1..1441..1.....141.....141..444
50 // 44444444444444444444444444444444444J4444444J444444444444JJ44444444444444444444444JJ444444J4444444444
51 // 44444444444444444444444444444444444...WILDERNESS TO BLOCKCHAIN...44444444444444444444444444444444444
52 // 4444444444444444444444444444444444444444444...EDITIONS...4444444444444444444444444444444444444444444
53 
54 
55 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
56 
57 
58 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
59 
60 pragma solidity ^0.8.0;
61 
62 /**
63  * @dev Interface of the ERC165 standard, as defined in the
64  * https://eips.ethereum.org/EIPS/eip-165[EIP].
65  *
66  * Implementers can declare support of contract interfaces, which can then be
67  * queried by others ({ERC165Checker}).
68  *
69  * For an implementation, see {ERC165}.
70  */
71 interface IERC165 {
72     /**
73      * @dev Returns true if this contract implements the interface defined by
74      * `interfaceId`. See the corresponding
75      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
76      * to learn more about how these ids are created.
77      *
78      * This function call must use less than 30 000 gas.
79      */
80     function supportsInterface(bytes4 interfaceId) external view returns (bool);
81 }
82 
83 
84 // File @openzeppelin/contracts/token/ERC1155/IERC1155.sol@v4.7.0
85 
86 
87 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Required interface of an ERC1155 compliant contract, as defined in the
93  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
94  *
95  * _Available since v3.1._
96  */
97 interface IERC1155 is IERC165 {
98     /**
99      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
100      */
101     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
102 
103     /**
104      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
105      * transfers.
106      */
107     event TransferBatch(
108         address indexed operator,
109         address indexed from,
110         address indexed to,
111         uint256[] ids,
112         uint256[] values
113     );
114 
115     /**
116      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
117      * `approved`.
118      */
119     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
120 
121     /**
122      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
123      *
124      * If an {URI} event was emitted for `id`, the standard
125      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
126      * returned by {IERC1155MetadataURI-uri}.
127      */
128     event URI(string value, uint256 indexed id);
129 
130     /**
131      * @dev Returns the amount of tokens of token type `id` owned by `account`.
132      *
133      * Requirements:
134      *
135      * - `account` cannot be the zero address.
136      */
137     function balanceOf(address account, uint256 id) external view returns (uint256);
138 
139     /**
140      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
141      *
142      * Requirements:
143      *
144      * - `accounts` and `ids` must have the same length.
145      */
146     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
147         external
148         view
149         returns (uint256[] memory);
150 
151     /**
152      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
153      *
154      * Emits an {ApprovalForAll} event.
155      *
156      * Requirements:
157      *
158      * - `operator` cannot be the caller.
159      */
160     function setApprovalForAll(address operator, bool approved) external;
161 
162     /**
163      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
164      *
165      * See {setApprovalForAll}.
166      */
167     function isApprovedForAll(address account, address operator) external view returns (bool);
168 
169     /**
170      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
171      *
172      * Emits a {TransferSingle} event.
173      *
174      * Requirements:
175      *
176      * - `to` cannot be the zero address.
177      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
178      * - `from` must have a balance of tokens of type `id` of at least `amount`.
179      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
180      * acceptance magic value.
181      */
182     function safeTransferFrom(
183         address from,
184         address to,
185         uint256 id,
186         uint256 amount,
187         bytes calldata data
188     ) external;
189 
190     /**
191      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
192      *
193      * Emits a {TransferBatch} event.
194      *
195      * Requirements:
196      *
197      * - `ids` and `amounts` must have the same length.
198      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
199      * acceptance magic value.
200      */
201     function safeBatchTransferFrom(
202         address from,
203         address to,
204         uint256[] calldata ids,
205         uint256[] calldata amounts,
206         bytes calldata data
207     ) external;
208 }
209 
210 
211 // File @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol@v4.7.0
212 
213 
214 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 /**
219  * @dev _Available since v3.1._
220  */
221 interface IERC1155Receiver is IERC165 {
222     /**
223      * @dev Handles the receipt of a single ERC1155 token type. This function is
224      * called at the end of a `safeTransferFrom` after the balance has been updated.
225      *
226      * NOTE: To accept the transfer, this must return
227      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
228      * (i.e. 0xf23a6e61, or its own function selector).
229      *
230      * @param operator The address which initiated the transfer (i.e. msg.sender)
231      * @param from The address which previously owned the token
232      * @param id The ID of the token being transferred
233      * @param value The amount of tokens being transferred
234      * @param data Additional data with no specified format
235      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
236      */
237     function onERC1155Received(
238         address operator,
239         address from,
240         uint256 id,
241         uint256 value,
242         bytes calldata data
243     ) external returns (bytes4);
244 
245     /**
246      * @dev Handles the receipt of a multiple ERC1155 token types. This function
247      * is called at the end of a `safeBatchTransferFrom` after the balances have
248      * been updated.
249      *
250      * NOTE: To accept the transfer(s), this must return
251      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
252      * (i.e. 0xbc197c81, or its own function selector).
253      *
254      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
255      * @param from The address which previously owned the token
256      * @param ids An array containing ids of each token being transferred (order and length must match values array)
257      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
258      * @param data Additional data with no specified format
259      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
260      */
261     function onERC1155BatchReceived(
262         address operator,
263         address from,
264         uint256[] calldata ids,
265         uint256[] calldata values,
266         bytes calldata data
267     ) external returns (bytes4);
268 }
269 
270 
271 // File @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol@v4.7.0
272 
273 
274 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
275 
276 pragma solidity ^0.8.0;
277 
278 /**
279  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
280  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
281  *
282  * _Available since v3.1._
283  */
284 interface IERC1155MetadataURI is IERC1155 {
285     /**
286      * @dev Returns the URI for token type `id`.
287      *
288      * If the `\{id\}` substring is present in the URI, it must be replaced by
289      * clients with the actual token type ID.
290      */
291     function uri(uint256 id) external view returns (string memory);
292 }
293 
294 
295 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
296 
297 
298 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
299 
300 pragma solidity ^0.8.1;
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      *
323      * [IMPORTANT]
324      * ====
325      * You shouldn't rely on `isContract` to protect against flash loan attacks!
326      *
327      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
328      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
329      * constructor.
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize/address.code.length, which returns 0
334         // for contracts in construction, since the code is only stored at the end
335         // of the constructor execution.
336 
337         return account.code.length > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508                 /// @solidity memory-safe-assembly
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 
521 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 /**
529  * @dev Provides information about the current execution context, including the
530  * sender of the transaction and its data. While these are generally available
531  * via msg.sender and msg.data, they should not be accessed in such a direct
532  * manner, since when dealing with meta-transactions the account sending and
533  * paying for execution may not be the actual sender (as far as an application
534  * is concerned).
535  *
536  * This contract is only required for intermediate, library-like contracts.
537  */
538 abstract contract Context {
539     function _msgSender() internal view virtual returns (address) {
540         return msg.sender;
541     }
542 
543     function _msgData() internal view virtual returns (bytes calldata) {
544         return msg.data;
545     }
546 }
547 
548 
549 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Implementation of the {IERC165} interface.
558  *
559  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
560  * for the additional interface id that will be supported. For example:
561  *
562  * ```solidity
563  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
565  * }
566  * ```
567  *
568  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
569  */
570 abstract contract ERC165 is IERC165 {
571     /**
572      * @dev See {IERC165-supportsInterface}.
573      */
574     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
575         return interfaceId == type(IERC165).interfaceId;
576     }
577 }
578 
579 
580 // File @openzeppelin/contracts/token/ERC1155/ERC1155.sol@v4.7.0
581 
582 
583 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 
590 
591 
592 /**
593  * @dev Implementation of the basic standard multi-token.
594  * See https://eips.ethereum.org/EIPS/eip-1155
595  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
596  *
597  * _Available since v3.1._
598  */
599 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
600     using Address for address;
601 
602     // Mapping from token ID to account balances
603     mapping(uint256 => mapping(address => uint256)) private _balances;
604 
605     // Mapping from account to operator approvals
606     mapping(address => mapping(address => bool)) private _operatorApprovals;
607 
608     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
609     string private _uri;
610 
611     /**
612      * @dev See {_setURI}.
613      */
614     constructor(string memory uri_) {
615         _setURI(uri_);
616     }
617 
618     /**
619      * @dev See {IERC165-supportsInterface}.
620      */
621     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
622         return
623             interfaceId == type(IERC1155).interfaceId ||
624             interfaceId == type(IERC1155MetadataURI).interfaceId ||
625             super.supportsInterface(interfaceId);
626     }
627 
628     /**
629      * @dev See {IERC1155MetadataURI-uri}.
630      *
631      * This implementation returns the same URI for *all* token types. It relies
632      * on the token type ID substitution mechanism
633      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
634      *
635      * Clients calling this function must replace the `\{id\}` substring with the
636      * actual token type ID.
637      */
638     function uri(uint256) public view virtual override returns (string memory) {
639         return _uri;
640     }
641 
642     /**
643      * @dev See {IERC1155-balanceOf}.
644      *
645      * Requirements:
646      *
647      * - `account` cannot be the zero address.
648      */
649     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
650         require(account != address(0), "ERC1155: address zero is not a valid owner");
651         return _balances[id][account];
652     }
653 
654     /**
655      * @dev See {IERC1155-balanceOfBatch}.
656      *
657      * Requirements:
658      *
659      * - `accounts` and `ids` must have the same length.
660      */
661     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
662         public
663         view
664         virtual
665         override
666         returns (uint256[] memory)
667     {
668         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
669 
670         uint256[] memory batchBalances = new uint256[](accounts.length);
671 
672         for (uint256 i = 0; i < accounts.length; ++i) {
673             batchBalances[i] = balanceOf(accounts[i], ids[i]);
674         }
675 
676         return batchBalances;
677     }
678 
679     /**
680      * @dev See {IERC1155-setApprovalForAll}.
681      */
682     function setApprovalForAll(address operator, bool approved) public virtual override {
683         _setApprovalForAll(_msgSender(), operator, approved);
684     }
685 
686     /**
687      * @dev See {IERC1155-isApprovedForAll}.
688      */
689     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
690         return _operatorApprovals[account][operator];
691     }
692 
693     /**
694      * @dev See {IERC1155-safeTransferFrom}.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 id,
700         uint256 amount,
701         bytes memory data
702     ) public virtual override {
703         require(
704             from == _msgSender() || isApprovedForAll(from, _msgSender()),
705             "ERC1155: caller is not token owner nor approved"
706         );
707         _safeTransferFrom(from, to, id, amount, data);
708     }
709 
710     /**
711      * @dev See {IERC1155-safeBatchTransferFrom}.
712      */
713     function safeBatchTransferFrom(
714         address from,
715         address to,
716         uint256[] memory ids,
717         uint256[] memory amounts,
718         bytes memory data
719     ) public virtual override {
720         require(
721             from == _msgSender() || isApprovedForAll(from, _msgSender()),
722             "ERC1155: caller is not token owner nor approved"
723         );
724         _safeBatchTransferFrom(from, to, ids, amounts, data);
725     }
726 
727     /**
728      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
729      *
730      * Emits a {TransferSingle} event.
731      *
732      * Requirements:
733      *
734      * - `to` cannot be the zero address.
735      * - `from` must have a balance of tokens of type `id` of at least `amount`.
736      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
737      * acceptance magic value.
738      */
739     function _safeTransferFrom(
740         address from,
741         address to,
742         uint256 id,
743         uint256 amount,
744         bytes memory data
745     ) internal virtual {
746         require(to != address(0), "ERC1155: transfer to the zero address");
747 
748         address operator = _msgSender();
749         uint256[] memory ids = _asSingletonArray(id);
750         uint256[] memory amounts = _asSingletonArray(amount);
751 
752         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
753 
754         uint256 fromBalance = _balances[id][from];
755         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
756         unchecked {
757             _balances[id][from] = fromBalance - amount;
758         }
759         _balances[id][to] += amount;
760 
761         emit TransferSingle(operator, from, to, id, amount);
762 
763         _afterTokenTransfer(operator, from, to, ids, amounts, data);
764 
765         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
766     }
767 
768     /**
769      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
770      *
771      * Emits a {TransferBatch} event.
772      *
773      * Requirements:
774      *
775      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
776      * acceptance magic value.
777      */
778     function _safeBatchTransferFrom(
779         address from,
780         address to,
781         uint256[] memory ids,
782         uint256[] memory amounts,
783         bytes memory data
784     ) internal virtual {
785         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
786         require(to != address(0), "ERC1155: transfer to the zero address");
787 
788         address operator = _msgSender();
789 
790         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
791 
792         for (uint256 i = 0; i < ids.length; ++i) {
793             uint256 id = ids[i];
794             uint256 amount = amounts[i];
795 
796             uint256 fromBalance = _balances[id][from];
797             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
798             unchecked {
799                 _balances[id][from] = fromBalance - amount;
800             }
801             _balances[id][to] += amount;
802         }
803 
804         emit TransferBatch(operator, from, to, ids, amounts);
805 
806         _afterTokenTransfer(operator, from, to, ids, amounts, data);
807 
808         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
809     }
810 
811     /**
812      * @dev Sets a new URI for all token types, by relying on the token type ID
813      * substitution mechanism
814      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
815      *
816      * By this mechanism, any occurrence of the `\{id\}` substring in either the
817      * URI or any of the amounts in the JSON file at said URI will be replaced by
818      * clients with the token type ID.
819      *
820      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
821      * interpreted by clients as
822      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
823      * for token type ID 0x4cce0.
824      *
825      * See {uri}.
826      *
827      * Because these URIs cannot be meaningfully represented by the {URI} event,
828      * this function emits no events.
829      */
830     function _setURI(string memory newuri) internal virtual {
831         _uri = newuri;
832     }
833 
834     /**
835      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
836      *
837      * Emits a {TransferSingle} event.
838      *
839      * Requirements:
840      *
841      * - `to` cannot be the zero address.
842      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
843      * acceptance magic value.
844      */
845     function _mint(
846         address to,
847         uint256 id,
848         uint256 amount,
849         bytes memory data
850     ) internal virtual {
851         require(to != address(0), "ERC1155: mint to the zero address");
852 
853         address operator = _msgSender();
854         uint256[] memory ids = _asSingletonArray(id);
855         uint256[] memory amounts = _asSingletonArray(amount);
856 
857         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
858 
859         _balances[id][to] += amount;
860         emit TransferSingle(operator, address(0), to, id, amount);
861 
862         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
863 
864         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
865     }
866 
867     /**
868      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
869      *
870      * Emits a {TransferBatch} event.
871      *
872      * Requirements:
873      *
874      * - `ids` and `amounts` must have the same length.
875      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
876      * acceptance magic value.
877      */
878     function _mintBatch(
879         address to,
880         uint256[] memory ids,
881         uint256[] memory amounts,
882         bytes memory data
883     ) internal virtual {
884         require(to != address(0), "ERC1155: mint to the zero address");
885         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
886 
887         address operator = _msgSender();
888 
889         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
890 
891         for (uint256 i = 0; i < ids.length; i++) {
892             _balances[ids[i]][to] += amounts[i];
893         }
894 
895         emit TransferBatch(operator, address(0), to, ids, amounts);
896 
897         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
898 
899         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
900     }
901 
902     /**
903      * @dev Destroys `amount` tokens of token type `id` from `from`
904      *
905      * Emits a {TransferSingle} event.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `from` must have at least `amount` tokens of token type `id`.
911      */
912     function _burn(
913         address from,
914         uint256 id,
915         uint256 amount
916     ) internal virtual {
917         require(from != address(0), "ERC1155: burn from the zero address");
918 
919         address operator = _msgSender();
920         uint256[] memory ids = _asSingletonArray(id);
921         uint256[] memory amounts = _asSingletonArray(amount);
922 
923         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
924 
925         uint256 fromBalance = _balances[id][from];
926         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
927         unchecked {
928             _balances[id][from] = fromBalance - amount;
929         }
930 
931         emit TransferSingle(operator, from, address(0), id, amount);
932 
933         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
934     }
935 
936     /**
937      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
938      *
939      * Emits a {TransferBatch} event.
940      *
941      * Requirements:
942      *
943      * - `ids` and `amounts` must have the same length.
944      */
945     function _burnBatch(
946         address from,
947         uint256[] memory ids,
948         uint256[] memory amounts
949     ) internal virtual {
950         require(from != address(0), "ERC1155: burn from the zero address");
951         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
952 
953         address operator = _msgSender();
954 
955         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
956 
957         for (uint256 i = 0; i < ids.length; i++) {
958             uint256 id = ids[i];
959             uint256 amount = amounts[i];
960 
961             uint256 fromBalance = _balances[id][from];
962             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
963             unchecked {
964                 _balances[id][from] = fromBalance - amount;
965             }
966         }
967 
968         emit TransferBatch(operator, from, address(0), ids, amounts);
969 
970         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
971     }
972 
973     /**
974      * @dev Approve `operator` to operate on all of `owner` tokens
975      *
976      * Emits an {ApprovalForAll} event.
977      */
978     function _setApprovalForAll(
979         address owner,
980         address operator,
981         bool approved
982     ) internal virtual {
983         require(owner != operator, "ERC1155: setting approval status for self");
984         _operatorApprovals[owner][operator] = approved;
985         emit ApprovalForAll(owner, operator, approved);
986     }
987 
988     /**
989      * @dev Hook that is called before any token transfer. This includes minting
990      * and burning, as well as batched variants.
991      *
992      * The same hook is called on both single and batched variants. For single
993      * transfers, the length of the `ids` and `amounts` arrays will be 1.
994      *
995      * Calling conditions (for each `id` and `amount` pair):
996      *
997      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
998      * of token type `id` will be  transferred to `to`.
999      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1000      * for `to`.
1001      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1002      * will be burned.
1003      * - `from` and `to` are never both zero.
1004      * - `ids` and `amounts` have the same, non-zero length.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _beforeTokenTransfer(
1009         address operator,
1010         address from,
1011         address to,
1012         uint256[] memory ids,
1013         uint256[] memory amounts,
1014         bytes memory data
1015     ) internal virtual {}
1016 
1017     /**
1018      * @dev Hook that is called after any token transfer. This includes minting
1019      * and burning, as well as batched variants.
1020      *
1021      * The same hook is called on both single and batched variants. For single
1022      * transfers, the length of the `id` and `amount` arrays will be 1.
1023      *
1024      * Calling conditions (for each `id` and `amount` pair):
1025      *
1026      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1027      * of token type `id` will be  transferred to `to`.
1028      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1029      * for `to`.
1030      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1031      * will be burned.
1032      * - `from` and `to` are never both zero.
1033      * - `ids` and `amounts` have the same, non-zero length.
1034      *
1035      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1036      */
1037     function _afterTokenTransfer(
1038         address operator,
1039         address from,
1040         address to,
1041         uint256[] memory ids,
1042         uint256[] memory amounts,
1043         bytes memory data
1044     ) internal virtual {}
1045 
1046     function _doSafeTransferAcceptanceCheck(
1047         address operator,
1048         address from,
1049         address to,
1050         uint256 id,
1051         uint256 amount,
1052         bytes memory data
1053     ) private {
1054         if (to.isContract()) {
1055             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1056                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1057                     revert("ERC1155: ERC1155Receiver rejected tokens");
1058                 }
1059             } catch Error(string memory reason) {
1060                 revert(reason);
1061             } catch {
1062                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1063             }
1064         }
1065     }
1066 
1067     function _doSafeBatchTransferAcceptanceCheck(
1068         address operator,
1069         address from,
1070         address to,
1071         uint256[] memory ids,
1072         uint256[] memory amounts,
1073         bytes memory data
1074     ) private {
1075         if (to.isContract()) {
1076             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1077                 bytes4 response
1078             ) {
1079                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1080                     revert("ERC1155: ERC1155Receiver rejected tokens");
1081                 }
1082             } catch Error(string memory reason) {
1083                 revert(reason);
1084             } catch {
1085                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1086             }
1087         }
1088     }
1089 
1090     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1091         uint256[] memory array = new uint256[](1);
1092         array[0] = element;
1093 
1094         return array;
1095     }
1096 }
1097 
1098 
1099 // File @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol@v4.7.0
1100 
1101 
1102 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 /**
1107  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1108  *
1109  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1110  * clearly identified. Note: While a totalSupply of 1 might mean the
1111  * corresponding is an NFT, there is no guarantees that no other token with the
1112  * same id are not going to be minted.
1113  */
1114 abstract contract ERC1155Supply is ERC1155 {
1115     mapping(uint256 => uint256) private _totalSupply;
1116 
1117     /**
1118      * @dev Total amount of tokens in with a given id.
1119      */
1120     function totalSupply(uint256 id) public view virtual returns (uint256) {
1121         return _totalSupply[id];
1122     }
1123 
1124     /**
1125      * @dev Indicates whether any token exist with a given id, or not.
1126      */
1127     function exists(uint256 id) public view virtual returns (bool) {
1128         return ERC1155Supply.totalSupply(id) > 0;
1129     }
1130 
1131     /**
1132      * @dev See {ERC1155-_beforeTokenTransfer}.
1133      */
1134     function _beforeTokenTransfer(
1135         address operator,
1136         address from,
1137         address to,
1138         uint256[] memory ids,
1139         uint256[] memory amounts,
1140         bytes memory data
1141     ) internal virtual override {
1142         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1143 
1144         if (from == address(0)) {
1145             for (uint256 i = 0; i < ids.length; ++i) {
1146                 _totalSupply[ids[i]] += amounts[i];
1147             }
1148         }
1149 
1150         if (to == address(0)) {
1151             for (uint256 i = 0; i < ids.length; ++i) {
1152                 uint256 id = ids[i];
1153                 uint256 amount = amounts[i];
1154                 uint256 supply = _totalSupply[id];
1155                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1156                 unchecked {
1157                     _totalSupply[id] = supply - amount;
1158                 }
1159             }
1160         }
1161     }
1162 }
1163 
1164 
1165 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
1166 
1167 
1168 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 /**
1173  * @dev Contract module which provides a basic access control mechanism, where
1174  * there is an account (an owner) that can be granted exclusive access to
1175  * specific functions.
1176  *
1177  * By default, the owner account will be the one that deploys the contract. This
1178  * can later be changed with {transferOwnership}.
1179  *
1180  * This module is used through inheritance. It will make available the modifier
1181  * `onlyOwner`, which can be applied to your functions to restrict their use to
1182  * the owner.
1183  */
1184 abstract contract Ownable is Context {
1185     address private _owner;
1186 
1187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1188 
1189     /**
1190      * @dev Initializes the contract setting the deployer as the initial owner.
1191      */
1192     constructor() {
1193         _transferOwnership(_msgSender());
1194     }
1195 
1196     /**
1197      * @dev Throws if called by any account other than the owner.
1198      */
1199     modifier onlyOwner() {
1200         _checkOwner();
1201         _;
1202     }
1203 
1204     /**
1205      * @dev Returns the address of the current owner.
1206      */
1207     function owner() public view virtual returns (address) {
1208         return _owner;
1209     }
1210 
1211     /**
1212      * @dev Throws if the sender is not the owner.
1213      */
1214     function _checkOwner() internal view virtual {
1215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1216     }
1217 
1218     /**
1219      * @dev Leaves the contract without owner. It will not be possible to call
1220      * `onlyOwner` functions anymore. Can only be called by the current owner.
1221      *
1222      * NOTE: Renouncing ownership will leave the contract without an owner,
1223      * thereby removing any functionality that is only available to the owner.
1224      */
1225     function renounceOwnership() public virtual onlyOwner {
1226         _transferOwnership(address(0));
1227     }
1228 
1229     /**
1230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1231      * Can only be called by the current owner.
1232      */
1233     function transferOwnership(address newOwner) public virtual onlyOwner {
1234         require(newOwner != address(0), "Ownable: new owner is the zero address");
1235         _transferOwnership(newOwner);
1236     }
1237 
1238     /**
1239      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1240      * Internal function without access restriction.
1241      */
1242     function _transferOwnership(address newOwner) internal virtual {
1243         address oldOwner = _owner;
1244         _owner = newOwner;
1245         emit OwnershipTransferred(oldOwner, newOwner);
1246     }
1247 }
1248 
1249 
1250 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.0
1251 
1252 
1253 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 /**
1258  * @dev Contract module that helps prevent reentrant calls to a function.
1259  *
1260  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1261  * available, which can be applied to functions to make sure there are no nested
1262  * (reentrant) calls to them.
1263  *
1264  * Note that because there is a single `nonReentrant` guard, functions marked as
1265  * `nonReentrant` may not call one another. This can be worked around by making
1266  * those functions `private`, and then adding `external` `nonReentrant` entry
1267  * points to them.
1268  *
1269  * TIP: If you would like to learn more about reentrancy and alternative ways
1270  * to protect against it, check out our blog post
1271  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1272  */
1273 abstract contract ReentrancyGuard {
1274     // Booleans are more expensive than uint256 or any type that takes up a full
1275     // word because each write operation emits an extra SLOAD to first read the
1276     // slot's contents, replace the bits taken up by the boolean, and then write
1277     // back. This is the compiler's defense against contract upgrades and
1278     // pointer aliasing, and it cannot be disabled.
1279 
1280     // The values being non-zero value makes deployment a bit more expensive,
1281     // but in exchange the refund on every call to nonReentrant will be lower in
1282     // amount. Since refunds are capped to a percentage of the total
1283     // transaction's gas, it is best to keep them low in cases like this one, to
1284     // increase the likelihood of the full refund coming into effect.
1285     uint256 private constant _NOT_ENTERED = 1;
1286     uint256 private constant _ENTERED = 2;
1287 
1288     uint256 private _status;
1289 
1290     constructor() {
1291         _status = _NOT_ENTERED;
1292     }
1293 
1294     /**
1295      * @dev Prevents a contract from calling itself, directly or indirectly.
1296      * Calling a `nonReentrant` function from another `nonReentrant`
1297      * function is not supported. It is possible to prevent this from happening
1298      * by making the `nonReentrant` function external, and making it call a
1299      * `private` function that does the actual work.
1300      */
1301     modifier nonReentrant() {
1302         // On the first call to nonReentrant, _notEntered will be true
1303         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1304 
1305         // Any calls to nonReentrant after this point will fail
1306         _status = _ENTERED;
1307 
1308         _;
1309 
1310         // By storing the original value once again, a refund is triggered (see
1311         // https://eips.ethereum.org/EIPS/eip-2200)
1312         _status = _NOT_ENTERED;
1313     }
1314 }
1315 
1316 
1317 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
1318 
1319 
1320 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
1321 
1322 pragma solidity ^0.8.0;
1323 
1324 /**
1325  * @dev String operations.
1326  */
1327 library Strings {
1328     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1329     uint8 private constant _ADDRESS_LENGTH = 20;
1330 
1331     /**
1332      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1333      */
1334     function toString(uint256 value) internal pure returns (string memory) {
1335         // Inspired by OraclizeAPI's implementation - MIT licence
1336         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1337 
1338         if (value == 0) {
1339             return "0";
1340         }
1341         uint256 temp = value;
1342         uint256 digits;
1343         while (temp != 0) {
1344             digits++;
1345             temp /= 10;
1346         }
1347         bytes memory buffer = new bytes(digits);
1348         while (value != 0) {
1349             digits -= 1;
1350             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1351             value /= 10;
1352         }
1353         return string(buffer);
1354     }
1355 
1356     /**
1357      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1358      */
1359     function toHexString(uint256 value) internal pure returns (string memory) {
1360         if (value == 0) {
1361             return "0x00";
1362         }
1363         uint256 temp = value;
1364         uint256 length = 0;
1365         while (temp != 0) {
1366             length++;
1367             temp >>= 8;
1368         }
1369         return toHexString(value, length);
1370     }
1371 
1372     /**
1373      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1374      */
1375     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1376         bytes memory buffer = new bytes(2 * length + 2);
1377         buffer[0] = "0";
1378         buffer[1] = "x";
1379         for (uint256 i = 2 * length + 1; i > 1; --i) {
1380             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1381             value >>= 4;
1382         }
1383         require(value == 0, "Strings: hex length insufficient");
1384         return string(buffer);
1385     }
1386 
1387     /**
1388      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1389      */
1390     function toHexString(address addr) internal pure returns (string memory) {
1391         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1392     }
1393 }
1394 
1395 
1396 // File @openzeppelin/contracts/utils/Counters.sol@v4.7.0
1397 
1398 
1399 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
1400 
1401 pragma solidity ^0.8.0;
1402 
1403 /**
1404  * @title Counters
1405  * @author Matt Condon (@shrugs)
1406  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1407  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1408  *
1409  * Include with `using Counters for Counters.Counter;`
1410  */
1411 library Counters {
1412     struct Counter {
1413         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1414         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1415         // this feature: see https://github.com/ethereum/solidity/issues/4637
1416         uint256 _value; // default: 0
1417     }
1418 
1419     function current(Counter storage counter) internal view returns (uint256) {
1420         return counter._value;
1421     }
1422 
1423     function increment(Counter storage counter) internal {
1424         unchecked {
1425             counter._value += 1;
1426         }
1427     }
1428 
1429     function decrement(Counter storage counter) internal {
1430         uint256 value = counter._value;
1431         require(value > 0, "Counter: decrement overflow");
1432         unchecked {
1433             counter._value = value - 1;
1434         }
1435     }
1436 
1437     function reset(Counter storage counter) internal {
1438         counter._value = 0;
1439     }
1440 }
1441 
1442 
1443 // File @openzeppelin/contracts/utils/introspection/ERC165Checker.sol@v4.7.0
1444 
1445 
1446 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165Checker.sol)
1447 
1448 pragma solidity ^0.8.0;
1449 
1450 /**
1451  * @dev Library used to query support of an interface declared via {IERC165}.
1452  *
1453  * Note that these functions return the actual result of the query: they do not
1454  * `revert` if an interface is not supported. It is up to the caller to decide
1455  * what to do in these cases.
1456  */
1457 library ERC165Checker {
1458     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1459     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1460 
1461     /**
1462      * @dev Returns true if `account` supports the {IERC165} interface,
1463      */
1464     function supportsERC165(address account) internal view returns (bool) {
1465         // Any contract that implements ERC165 must explicitly indicate support of
1466         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1467         return
1468             _supportsERC165Interface(account, type(IERC165).interfaceId) &&
1469             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1470     }
1471 
1472     /**
1473      * @dev Returns true if `account` supports the interface defined by
1474      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1475      *
1476      * See {IERC165-supportsInterface}.
1477      */
1478     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1479         // query support of both ERC165 as per the spec and support of _interfaceId
1480         return supportsERC165(account) && _supportsERC165Interface(account, interfaceId);
1481     }
1482 
1483     /**
1484      * @dev Returns a boolean array where each value corresponds to the
1485      * interfaces passed in and whether they're supported or not. This allows
1486      * you to batch check interfaces for a contract where your expectation
1487      * is that some interfaces may not be supported.
1488      *
1489      * See {IERC165-supportsInterface}.
1490      *
1491      * _Available since v3.4._
1492      */
1493     function getSupportedInterfaces(address account, bytes4[] memory interfaceIds)
1494         internal
1495         view
1496         returns (bool[] memory)
1497     {
1498         // an array of booleans corresponding to interfaceIds and whether they're supported or not
1499         bool[] memory interfaceIdsSupported = new bool[](interfaceIds.length);
1500 
1501         // query support of ERC165 itself
1502         if (supportsERC165(account)) {
1503             // query support of each interface in interfaceIds
1504             for (uint256 i = 0; i < interfaceIds.length; i++) {
1505                 interfaceIdsSupported[i] = _supportsERC165Interface(account, interfaceIds[i]);
1506             }
1507         }
1508 
1509         return interfaceIdsSupported;
1510     }
1511 
1512     /**
1513      * @dev Returns true if `account` supports all the interfaces defined in
1514      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1515      *
1516      * Batch-querying can lead to gas savings by skipping repeated checks for
1517      * {IERC165} support.
1518      *
1519      * See {IERC165-supportsInterface}.
1520      */
1521     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1522         // query support of ERC165 itself
1523         if (!supportsERC165(account)) {
1524             return false;
1525         }
1526 
1527         // query support of each interface in _interfaceIds
1528         for (uint256 i = 0; i < interfaceIds.length; i++) {
1529             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1530                 return false;
1531             }
1532         }
1533 
1534         // all interfaces supported
1535         return true;
1536     }
1537 
1538     /**
1539      * @notice Query if a contract implements an interface, does not check ERC165 support
1540      * @param account The address of the contract to query for support of an interface
1541      * @param interfaceId The interface identifier, as specified in ERC-165
1542      * @return true if the contract at account indicates support of the interface with
1543      * identifier interfaceId, false otherwise
1544      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1545      * the behavior of this method is undefined. This precondition can be checked
1546      * with {supportsERC165}.
1547      * Interface identification is specified in ERC-165.
1548      */
1549     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1550         bytes memory encodedParams = abi.encodeWithSelector(IERC165.supportsInterface.selector, interfaceId);
1551         (bool success, bytes memory result) = account.staticcall{gas: 30000}(encodedParams);
1552         if (result.length < 32) return false;
1553         return success && abi.decode(result, (bool));
1554     }
1555 }
1556 
1557 
1558 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.0
1559 
1560 
1561 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1562 
1563 pragma solidity ^0.8.0;
1564 
1565 /**
1566  * @dev Interface for the NFT Royalty Standard.
1567  *
1568  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1569  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1570  *
1571  * _Available since v4.5._
1572  */
1573 interface IERC2981 is IERC165 {
1574     /**
1575      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1576      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1577      */
1578     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1579         external
1580         view
1581         returns (address receiver, uint256 royaltyAmount);
1582 }
1583 
1584 
1585 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
1586 
1587 
1588 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1589 
1590 pragma solidity ^0.8.0;
1591 
1592 /**
1593  * @dev Interface of the ERC20 standard as defined in the EIP.
1594  */
1595 interface IERC20 {
1596     /**
1597      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1598      * another (`to`).
1599      *
1600      * Note that `value` may be zero.
1601      */
1602     event Transfer(address indexed from, address indexed to, uint256 value);
1603 
1604     /**
1605      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1606      * a call to {approve}. `value` is the new allowance.
1607      */
1608     event Approval(address indexed owner, address indexed spender, uint256 value);
1609 
1610     /**
1611      * @dev Returns the amount of tokens in existence.
1612      */
1613     function totalSupply() external view returns (uint256);
1614 
1615     /**
1616      * @dev Returns the amount of tokens owned by `account`.
1617      */
1618     function balanceOf(address account) external view returns (uint256);
1619 
1620     /**
1621      * @dev Moves `amount` tokens from the caller's account to `to`.
1622      *
1623      * Returns a boolean value indicating whether the operation succeeded.
1624      *
1625      * Emits a {Transfer} event.
1626      */
1627     function transfer(address to, uint256 amount) external returns (bool);
1628 
1629     /**
1630      * @dev Returns the remaining number of tokens that `spender` will be
1631      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1632      * zero by default.
1633      *
1634      * This value changes when {approve} or {transferFrom} are called.
1635      */
1636     function allowance(address owner, address spender) external view returns (uint256);
1637 
1638     /**
1639      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1640      *
1641      * Returns a boolean value indicating whether the operation succeeded.
1642      *
1643      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1644      * that someone may use both the old and the new allowance by unfortunate
1645      * transaction ordering. One possible solution to mitigate this race
1646      * condition is to first reduce the spender's allowance to 0 and set the
1647      * desired value afterwards:
1648      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1649      *
1650      * Emits an {Approval} event.
1651      */
1652     function approve(address spender, uint256 amount) external returns (bool);
1653 
1654     /**
1655      * @dev Moves `amount` tokens from `from` to `to` using the
1656      * allowance mechanism. `amount` is then deducted from the caller's
1657      * allowance.
1658      *
1659      * Returns a boolean value indicating whether the operation succeeded.
1660      *
1661      * Emits a {Transfer} event.
1662      */
1663     function transferFrom(
1664         address from,
1665         address to,
1666         uint256 amount
1667     ) external returns (bool);
1668 }
1669 
1670 
1671 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.0
1672 
1673 
1674 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1675 
1676 pragma solidity ^0.8.0;
1677 
1678 /**
1679  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1680  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1681  *
1682  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1683  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1684  * need to send a transaction, and thus is not required to hold Ether at all.
1685  */
1686 interface IERC20Permit {
1687     /**
1688      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1689      * given ``owner``'s signed approval.
1690      *
1691      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1692      * ordering also apply here.
1693      *
1694      * Emits an {Approval} event.
1695      *
1696      * Requirements:
1697      *
1698      * - `spender` cannot be the zero address.
1699      * - `deadline` must be a timestamp in the future.
1700      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1701      * over the EIP712-formatted function arguments.
1702      * - the signature must use ``owner``'s current nonce (see {nonces}).
1703      *
1704      * For more information on the signature format, see the
1705      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1706      * section].
1707      */
1708     function permit(
1709         address owner,
1710         address spender,
1711         uint256 value,
1712         uint256 deadline,
1713         uint8 v,
1714         bytes32 r,
1715         bytes32 s
1716     ) external;
1717 
1718     /**
1719      * @dev Returns the current nonce for `owner`. This value must be
1720      * included whenever a signature is generated for {permit}.
1721      *
1722      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1723      * prevents a signature from being used multiple times.
1724      */
1725     function nonces(address owner) external view returns (uint256);
1726 
1727     /**
1728      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1729      */
1730     // solhint-disable-next-line func-name-mixedcase
1731     function DOMAIN_SEPARATOR() external view returns (bytes32);
1732 }
1733 
1734 
1735 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.0
1736 
1737 
1738 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1739 
1740 pragma solidity ^0.8.0;
1741 
1742 
1743 
1744 /**
1745  * @title SafeERC20
1746  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1747  * contract returns false). Tokens that return no value (and instead revert or
1748  * throw on failure) are also supported, non-reverting calls are assumed to be
1749  * successful.
1750  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1751  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1752  */
1753 library SafeERC20 {
1754     using Address for address;
1755 
1756     function safeTransfer(
1757         IERC20 token,
1758         address to,
1759         uint256 value
1760     ) internal {
1761         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1762     }
1763 
1764     function safeTransferFrom(
1765         IERC20 token,
1766         address from,
1767         address to,
1768         uint256 value
1769     ) internal {
1770         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1771     }
1772 
1773     /**
1774      * @dev Deprecated. This function has issues similar to the ones found in
1775      * {IERC20-approve}, and its usage is discouraged.
1776      *
1777      * Whenever possible, use {safeIncreaseAllowance} and
1778      * {safeDecreaseAllowance} instead.
1779      */
1780     function safeApprove(
1781         IERC20 token,
1782         address spender,
1783         uint256 value
1784     ) internal {
1785         // safeApprove should only be called when setting an initial allowance,
1786         // or when resetting it to zero. To increase and decrease it, use
1787         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1788         require(
1789             (value == 0) || (token.allowance(address(this), spender) == 0),
1790             "SafeERC20: approve from non-zero to non-zero allowance"
1791         );
1792         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1793     }
1794 
1795     function safeIncreaseAllowance(
1796         IERC20 token,
1797         address spender,
1798         uint256 value
1799     ) internal {
1800         uint256 newAllowance = token.allowance(address(this), spender) + value;
1801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1802     }
1803 
1804     function safeDecreaseAllowance(
1805         IERC20 token,
1806         address spender,
1807         uint256 value
1808     ) internal {
1809         unchecked {
1810             uint256 oldAllowance = token.allowance(address(this), spender);
1811             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1812             uint256 newAllowance = oldAllowance - value;
1813             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1814         }
1815     }
1816 
1817     function safePermit(
1818         IERC20Permit token,
1819         address owner,
1820         address spender,
1821         uint256 value,
1822         uint256 deadline,
1823         uint8 v,
1824         bytes32 r,
1825         bytes32 s
1826     ) internal {
1827         uint256 nonceBefore = token.nonces(owner);
1828         token.permit(owner, spender, value, deadline, v, r, s);
1829         uint256 nonceAfter = token.nonces(owner);
1830         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1831     }
1832 
1833     /**
1834      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1835      * on the return value: the return value is optional (but if data is returned, it must not be false).
1836      * @param token The token targeted by the call.
1837      * @param data The call data (encoded using abi.encode or one of its variants).
1838      */
1839     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1840         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1841         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1842         // the target address contains contract code and also asserts for success in the low-level call.
1843 
1844         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1845         if (returndata.length > 0) {
1846             // Return data is optional
1847             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1848         }
1849     }
1850 }
1851 
1852 
1853 // File @divergencetech/ethier/contracts/random/PRNG.sol@v0.33.0
1854 
1855 
1856 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
1857 pragma solidity >=0.8.9 <0.9.0;
1858 
1859 library PRNG {
1860     /**
1861     @notice A source of random numbers.
1862     @dev Pointer to a 2-word buffer of {carry || number, remaining unread
1863     bits}. however, note that this is abstracted away by the API and SHOULD NOT
1864     be used. This layout MUST NOT be considered part of the public API and
1865     therefore not relied upon even within stable versions.
1866      */
1867     type Source is uint256;
1868 
1869     /// @notice The biggest safe prime for modulus 2**128
1870     uint256 private constant MWC_FACTOR = 2**128 - 10408;
1871 
1872     /// @notice Layout within the buffer. 0x00 is the current (carry || number)
1873     uint256 private constant REMAIN = 0x20;
1874 
1875     /// @notice Mask for the 128 least significant bits
1876     uint256 private constant MASK_128_BITS = 0xffffffffffffffffffffffffffffffff;
1877 
1878     /**
1879     @notice Returns a new deterministic Source, differentiated only by the seed.
1880     @dev Use of PRNG.Source does NOT provide any unpredictability as generated
1881     numbers are entirely deterministic. Either a verifiable source of randomness
1882     such as Chainlink VRF, or a commit-and-reveal protocol MUST be used if
1883     unpredictability is required. The latter is only appropriate if the contract
1884     owner can be trusted within the specified threat model.
1885     @dev The 256bit seed is used to initialize carry || number
1886      */
1887     function newSource(bytes32 seed) internal pure returns (Source src) {
1888         assembly {
1889             src := mload(0x40)
1890             mstore(0x40, add(src, 0x40))
1891             mstore(src, seed)
1892             mstore(add(src, REMAIN), 128)
1893         }
1894         // DO NOT call _refill() on the new Source as newSource() is also used
1895         // by loadSource(), which implements its own state modifications. The
1896         // first call to read() on a fresh Source will induce a call to
1897         // _refill().
1898     }
1899 
1900     /**
1901     @dev Computes the next PRN in entropy using a lag-1 multiply-with-carry
1902     algorithm and resets the remaining bits to 128.
1903     `nextNumber = (factor * number + carry) mod 2**128`
1904     `nextCarry  = (factor * number + carry) //  2**128`
1905      */
1906     function _refill(Source src) private pure {
1907         assembly {
1908             let carryAndNumber := mload(src)
1909             let rand := and(carryAndNumber, MASK_128_BITS)
1910             let carry := shr(128, carryAndNumber)
1911             mstore(src, add(mul(MWC_FACTOR, rand), carry))
1912             mstore(add(src, REMAIN), 128)
1913         }
1914     }
1915 
1916     /**
1917     @notice Returns the specified number of bits <= 128 from the Source.
1918     @dev It is safe to cast the returned value to a uint<bits>.
1919      */
1920     function read(Source src, uint256 bits)
1921         internal
1922         pure
1923         returns (uint256 sample)
1924     {
1925         require(bits <= 128, "PRNG: max 128 bits");
1926 
1927         uint256 remain;
1928         assembly {
1929             remain := mload(add(src, REMAIN))
1930         }
1931         if (remain > bits) {
1932             return readWithSufficient(src, bits);
1933         }
1934 
1935         uint256 extra = bits - remain;
1936         sample = readWithSufficient(src, remain);
1937         assembly {
1938             sample := shl(extra, sample)
1939         }
1940 
1941         _refill(src);
1942         sample = sample | readWithSufficient(src, extra);
1943     }
1944 
1945     /**
1946     @notice Returns the specified number of bits, assuming that there is
1947     sufficient entropy remaining. See read() for usage.
1948      */
1949     function readWithSufficient(Source src, uint256 bits)
1950         private
1951         pure
1952         returns (uint256 sample)
1953     {
1954         assembly {
1955             let ent := mload(src)
1956             let rem := add(src, REMAIN)
1957             let remain := mload(rem)
1958             sample := shr(sub(256, bits), shl(sub(256, remain), ent))
1959             mstore(rem, sub(remain, bits))
1960         }
1961     }
1962 
1963     /// @notice Returns a random boolean.
1964     function readBool(Source src) internal pure returns (bool) {
1965         return read(src, 1) == 1;
1966     }
1967 
1968     /**
1969     @notice Returns the number of bits needed to encode n.
1970     @dev Useful for calling readLessThan() multiple times with the same upper
1971     bound.
1972      */
1973     function bitLength(uint256 n) internal pure returns (uint16 bits) {
1974         assembly {
1975             for {
1976                 let _n := n
1977             } gt(_n, 0) {
1978                 _n := shr(1, _n)
1979             } {
1980                 bits := add(bits, 1)
1981             }
1982         }
1983     }
1984 
1985     /**
1986     @notice Returns a uniformly random value in [0,n) with rejection sampling.
1987     @dev If the size of n is known, prefer readLessThan(Source, uint, uint16) as
1988     it skips the bit counting performed by this version; see bitLength().
1989      */
1990     function readLessThan(Source src, uint256 n)
1991         internal
1992         pure
1993         returns (uint256)
1994     {
1995         return readLessThan(src, n, bitLength(n));
1996     }
1997 
1998     /**
1999     @notice Returns a uniformly random value in [0,n) with rejection sampling
2000     from the range [0,2^bits).
2001     @dev For greatest efficiency, the value of bits should be the smallest
2002     number of bits required to capture n; if this is not known, use
2003     readLessThan(Source, uint) or bitLength(). Although rejections are reduced
2004     by using twice the number of bits, this increases the rate at which the
2005     entropy pool must be refreshed with a call to `_refill`.
2006 
2007     TODO: benchmark higher number of bits for rejection vs hashing gas cost.
2008      */
2009     function readLessThan(
2010         Source src,
2011         uint256 n,
2012         uint16 bits
2013     ) internal pure returns (uint256 result) {
2014         // Discard results >= n and try again because using % will bias towards
2015         // lower values; e.g. if n = 13 and we read 4 bits then {13, 14, 15}%13
2016         // will select {0, 1, 2} twice as often as the other values.
2017         // solhint-disable-next-line no-empty-blocks
2018         for (result = n; result >= n; result = read(src, bits)) {}
2019     }
2020 
2021     /**
2022     @notice Returns the internal state of the Source.
2023     @dev MUST NOT be considered part of the API and is subject to change without
2024     deprecation nor warning. Only exposed for testing.
2025      */
2026     function state(Source src)
2027         internal
2028         pure
2029         returns (uint256 entropy, uint256 remain)
2030     {
2031         assembly {
2032             entropy := mload(src)
2033             remain := mload(add(src, REMAIN))
2034         }
2035     }
2036 
2037     /**
2038     @notice Stores the state of the Source in a 2-word buffer. See loadSource().
2039     @dev The layout of the stored state MUST NOT be considered part of the
2040     public API, and is subject to change without warning. It is therefore only
2041     safe to rely on stored Sources _within_ contracts, but not _between_ them.
2042      */
2043     function store(Source src, uint256[2] storage stored) internal {
2044         uint256 carryAndNumber;
2045         uint256 remain;
2046         assembly {
2047             carryAndNumber := mload(src)
2048             remain := mload(add(src, REMAIN))
2049         }
2050         stored[0] = carryAndNumber;
2051         stored[1] = remain;
2052     }
2053 
2054     /**
2055     @notice Recreates a Source from the state stored with store().
2056      */
2057     function loadSource(uint256[2] storage stored)
2058         internal
2059         view
2060         returns (Source)
2061     {
2062         Source src = newSource(bytes32(stored[0]));
2063         uint256 carryAndNumber = stored[0];
2064         uint256 remain = stored[1];
2065 
2066         assembly {
2067             mstore(src, carryAndNumber)
2068             mstore(add(src, REMAIN), remain)
2069         }
2070         return src;
2071     }
2072 }
2073 
2074 
2075 // File hardhat/console.sol@v2.9.3
2076 
2077 
2078 pragma solidity >= 0.4.22 <0.9.0;
2079 
2080 library console {
2081 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
2082 
2083 	function _sendLogPayload(bytes memory payload) private view {
2084 		uint256 payloadLength = payload.length;
2085 		address consoleAddress = CONSOLE_ADDRESS;
2086 		assembly {
2087 			let payloadStart := add(payload, 32)
2088 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
2089 		}
2090 	}
2091 
2092 	function log() internal view {
2093 		_sendLogPayload(abi.encodeWithSignature("log()"));
2094 	}
2095 
2096 	function logInt(int p0) internal view {
2097 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
2098 	}
2099 
2100 	function logUint(uint p0) internal view {
2101 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
2102 	}
2103 
2104 	function logString(string memory p0) internal view {
2105 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2106 	}
2107 
2108 	function logBool(bool p0) internal view {
2109 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2110 	}
2111 
2112 	function logAddress(address p0) internal view {
2113 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2114 	}
2115 
2116 	function logBytes(bytes memory p0) internal view {
2117 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
2118 	}
2119 
2120 	function logBytes1(bytes1 p0) internal view {
2121 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
2122 	}
2123 
2124 	function logBytes2(bytes2 p0) internal view {
2125 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
2126 	}
2127 
2128 	function logBytes3(bytes3 p0) internal view {
2129 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
2130 	}
2131 
2132 	function logBytes4(bytes4 p0) internal view {
2133 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
2134 	}
2135 
2136 	function logBytes5(bytes5 p0) internal view {
2137 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
2138 	}
2139 
2140 	function logBytes6(bytes6 p0) internal view {
2141 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
2142 	}
2143 
2144 	function logBytes7(bytes7 p0) internal view {
2145 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
2146 	}
2147 
2148 	function logBytes8(bytes8 p0) internal view {
2149 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
2150 	}
2151 
2152 	function logBytes9(bytes9 p0) internal view {
2153 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
2154 	}
2155 
2156 	function logBytes10(bytes10 p0) internal view {
2157 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
2158 	}
2159 
2160 	function logBytes11(bytes11 p0) internal view {
2161 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
2162 	}
2163 
2164 	function logBytes12(bytes12 p0) internal view {
2165 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
2166 	}
2167 
2168 	function logBytes13(bytes13 p0) internal view {
2169 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
2170 	}
2171 
2172 	function logBytes14(bytes14 p0) internal view {
2173 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
2174 	}
2175 
2176 	function logBytes15(bytes15 p0) internal view {
2177 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
2178 	}
2179 
2180 	function logBytes16(bytes16 p0) internal view {
2181 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
2182 	}
2183 
2184 	function logBytes17(bytes17 p0) internal view {
2185 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
2186 	}
2187 
2188 	function logBytes18(bytes18 p0) internal view {
2189 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
2190 	}
2191 
2192 	function logBytes19(bytes19 p0) internal view {
2193 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
2194 	}
2195 
2196 	function logBytes20(bytes20 p0) internal view {
2197 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
2198 	}
2199 
2200 	function logBytes21(bytes21 p0) internal view {
2201 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
2202 	}
2203 
2204 	function logBytes22(bytes22 p0) internal view {
2205 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
2206 	}
2207 
2208 	function logBytes23(bytes23 p0) internal view {
2209 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
2210 	}
2211 
2212 	function logBytes24(bytes24 p0) internal view {
2213 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
2214 	}
2215 
2216 	function logBytes25(bytes25 p0) internal view {
2217 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
2218 	}
2219 
2220 	function logBytes26(bytes26 p0) internal view {
2221 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
2222 	}
2223 
2224 	function logBytes27(bytes27 p0) internal view {
2225 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
2226 	}
2227 
2228 	function logBytes28(bytes28 p0) internal view {
2229 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
2230 	}
2231 
2232 	function logBytes29(bytes29 p0) internal view {
2233 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
2234 	}
2235 
2236 	function logBytes30(bytes30 p0) internal view {
2237 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
2238 	}
2239 
2240 	function logBytes31(bytes31 p0) internal view {
2241 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
2242 	}
2243 
2244 	function logBytes32(bytes32 p0) internal view {
2245 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
2246 	}
2247 
2248 	function log(uint p0) internal view {
2249 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
2250 	}
2251 
2252 	function log(string memory p0) internal view {
2253 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
2254 	}
2255 
2256 	function log(bool p0) internal view {
2257 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
2258 	}
2259 
2260 	function log(address p0) internal view {
2261 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
2262 	}
2263 
2264 	function log(uint p0, uint p1) internal view {
2265 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
2266 	}
2267 
2268 	function log(uint p0, string memory p1) internal view {
2269 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
2270 	}
2271 
2272 	function log(uint p0, bool p1) internal view {
2273 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
2274 	}
2275 
2276 	function log(uint p0, address p1) internal view {
2277 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
2278 	}
2279 
2280 	function log(string memory p0, uint p1) internal view {
2281 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
2282 	}
2283 
2284 	function log(string memory p0, string memory p1) internal view {
2285 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
2286 	}
2287 
2288 	function log(string memory p0, bool p1) internal view {
2289 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
2290 	}
2291 
2292 	function log(string memory p0, address p1) internal view {
2293 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
2294 	}
2295 
2296 	function log(bool p0, uint p1) internal view {
2297 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
2298 	}
2299 
2300 	function log(bool p0, string memory p1) internal view {
2301 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
2302 	}
2303 
2304 	function log(bool p0, bool p1) internal view {
2305 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
2306 	}
2307 
2308 	function log(bool p0, address p1) internal view {
2309 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
2310 	}
2311 
2312 	function log(address p0, uint p1) internal view {
2313 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
2314 	}
2315 
2316 	function log(address p0, string memory p1) internal view {
2317 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
2318 	}
2319 
2320 	function log(address p0, bool p1) internal view {
2321 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
2322 	}
2323 
2324 	function log(address p0, address p1) internal view {
2325 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
2326 	}
2327 
2328 	function log(uint p0, uint p1, uint p2) internal view {
2329 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
2330 	}
2331 
2332 	function log(uint p0, uint p1, string memory p2) internal view {
2333 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
2334 	}
2335 
2336 	function log(uint p0, uint p1, bool p2) internal view {
2337 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
2338 	}
2339 
2340 	function log(uint p0, uint p1, address p2) internal view {
2341 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
2342 	}
2343 
2344 	function log(uint p0, string memory p1, uint p2) internal view {
2345 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
2346 	}
2347 
2348 	function log(uint p0, string memory p1, string memory p2) internal view {
2349 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
2350 	}
2351 
2352 	function log(uint p0, string memory p1, bool p2) internal view {
2353 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
2354 	}
2355 
2356 	function log(uint p0, string memory p1, address p2) internal view {
2357 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
2358 	}
2359 
2360 	function log(uint p0, bool p1, uint p2) internal view {
2361 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
2362 	}
2363 
2364 	function log(uint p0, bool p1, string memory p2) internal view {
2365 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
2366 	}
2367 
2368 	function log(uint p0, bool p1, bool p2) internal view {
2369 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
2370 	}
2371 
2372 	function log(uint p0, bool p1, address p2) internal view {
2373 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
2374 	}
2375 
2376 	function log(uint p0, address p1, uint p2) internal view {
2377 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
2378 	}
2379 
2380 	function log(uint p0, address p1, string memory p2) internal view {
2381 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
2382 	}
2383 
2384 	function log(uint p0, address p1, bool p2) internal view {
2385 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
2386 	}
2387 
2388 	function log(uint p0, address p1, address p2) internal view {
2389 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
2390 	}
2391 
2392 	function log(string memory p0, uint p1, uint p2) internal view {
2393 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
2394 	}
2395 
2396 	function log(string memory p0, uint p1, string memory p2) internal view {
2397 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
2398 	}
2399 
2400 	function log(string memory p0, uint p1, bool p2) internal view {
2401 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
2402 	}
2403 
2404 	function log(string memory p0, uint p1, address p2) internal view {
2405 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
2406 	}
2407 
2408 	function log(string memory p0, string memory p1, uint p2) internal view {
2409 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
2410 	}
2411 
2412 	function log(string memory p0, string memory p1, string memory p2) internal view {
2413 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
2414 	}
2415 
2416 	function log(string memory p0, string memory p1, bool p2) internal view {
2417 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
2418 	}
2419 
2420 	function log(string memory p0, string memory p1, address p2) internal view {
2421 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
2422 	}
2423 
2424 	function log(string memory p0, bool p1, uint p2) internal view {
2425 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
2426 	}
2427 
2428 	function log(string memory p0, bool p1, string memory p2) internal view {
2429 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
2430 	}
2431 
2432 	function log(string memory p0, bool p1, bool p2) internal view {
2433 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
2434 	}
2435 
2436 	function log(string memory p0, bool p1, address p2) internal view {
2437 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
2438 	}
2439 
2440 	function log(string memory p0, address p1, uint p2) internal view {
2441 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
2442 	}
2443 
2444 	function log(string memory p0, address p1, string memory p2) internal view {
2445 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
2446 	}
2447 
2448 	function log(string memory p0, address p1, bool p2) internal view {
2449 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
2450 	}
2451 
2452 	function log(string memory p0, address p1, address p2) internal view {
2453 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
2454 	}
2455 
2456 	function log(bool p0, uint p1, uint p2) internal view {
2457 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
2458 	}
2459 
2460 	function log(bool p0, uint p1, string memory p2) internal view {
2461 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
2462 	}
2463 
2464 	function log(bool p0, uint p1, bool p2) internal view {
2465 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
2466 	}
2467 
2468 	function log(bool p0, uint p1, address p2) internal view {
2469 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
2470 	}
2471 
2472 	function log(bool p0, string memory p1, uint p2) internal view {
2473 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
2474 	}
2475 
2476 	function log(bool p0, string memory p1, string memory p2) internal view {
2477 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
2478 	}
2479 
2480 	function log(bool p0, string memory p1, bool p2) internal view {
2481 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
2482 	}
2483 
2484 	function log(bool p0, string memory p1, address p2) internal view {
2485 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
2486 	}
2487 
2488 	function log(bool p0, bool p1, uint p2) internal view {
2489 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
2490 	}
2491 
2492 	function log(bool p0, bool p1, string memory p2) internal view {
2493 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
2494 	}
2495 
2496 	function log(bool p0, bool p1, bool p2) internal view {
2497 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
2498 	}
2499 
2500 	function log(bool p0, bool p1, address p2) internal view {
2501 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
2502 	}
2503 
2504 	function log(bool p0, address p1, uint p2) internal view {
2505 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
2506 	}
2507 
2508 	function log(bool p0, address p1, string memory p2) internal view {
2509 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
2510 	}
2511 
2512 	function log(bool p0, address p1, bool p2) internal view {
2513 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
2514 	}
2515 
2516 	function log(bool p0, address p1, address p2) internal view {
2517 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
2518 	}
2519 
2520 	function log(address p0, uint p1, uint p2) internal view {
2521 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
2522 	}
2523 
2524 	function log(address p0, uint p1, string memory p2) internal view {
2525 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
2526 	}
2527 
2528 	function log(address p0, uint p1, bool p2) internal view {
2529 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
2530 	}
2531 
2532 	function log(address p0, uint p1, address p2) internal view {
2533 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
2534 	}
2535 
2536 	function log(address p0, string memory p1, uint p2) internal view {
2537 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
2538 	}
2539 
2540 	function log(address p0, string memory p1, string memory p2) internal view {
2541 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
2542 	}
2543 
2544 	function log(address p0, string memory p1, bool p2) internal view {
2545 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
2546 	}
2547 
2548 	function log(address p0, string memory p1, address p2) internal view {
2549 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
2550 	}
2551 
2552 	function log(address p0, bool p1, uint p2) internal view {
2553 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
2554 	}
2555 
2556 	function log(address p0, bool p1, string memory p2) internal view {
2557 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
2558 	}
2559 
2560 	function log(address p0, bool p1, bool p2) internal view {
2561 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
2562 	}
2563 
2564 	function log(address p0, bool p1, address p2) internal view {
2565 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
2566 	}
2567 
2568 	function log(address p0, address p1, uint p2) internal view {
2569 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
2570 	}
2571 
2572 	function log(address p0, address p1, string memory p2) internal view {
2573 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
2574 	}
2575 
2576 	function log(address p0, address p1, bool p2) internal view {
2577 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
2578 	}
2579 
2580 	function log(address p0, address p1, address p2) internal view {
2581 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
2582 	}
2583 
2584 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
2585 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
2586 	}
2587 
2588 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
2589 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
2590 	}
2591 
2592 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
2593 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
2594 	}
2595 
2596 	function log(uint p0, uint p1, uint p2, address p3) internal view {
2597 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
2598 	}
2599 
2600 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
2601 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
2602 	}
2603 
2604 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
2605 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
2606 	}
2607 
2608 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
2609 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
2610 	}
2611 
2612 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
2613 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
2614 	}
2615 
2616 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
2617 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
2618 	}
2619 
2620 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
2621 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
2622 	}
2623 
2624 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
2625 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
2626 	}
2627 
2628 	function log(uint p0, uint p1, bool p2, address p3) internal view {
2629 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
2630 	}
2631 
2632 	function log(uint p0, uint p1, address p2, uint p3) internal view {
2633 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
2634 	}
2635 
2636 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
2637 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
2638 	}
2639 
2640 	function log(uint p0, uint p1, address p2, bool p3) internal view {
2641 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
2642 	}
2643 
2644 	function log(uint p0, uint p1, address p2, address p3) internal view {
2645 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
2646 	}
2647 
2648 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
2649 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
2650 	}
2651 
2652 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
2653 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
2654 	}
2655 
2656 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
2657 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
2658 	}
2659 
2660 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
2661 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
2662 	}
2663 
2664 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
2665 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
2666 	}
2667 
2668 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
2669 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
2670 	}
2671 
2672 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
2673 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
2674 	}
2675 
2676 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
2677 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
2678 	}
2679 
2680 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
2681 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
2682 	}
2683 
2684 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
2685 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
2686 	}
2687 
2688 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
2689 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
2690 	}
2691 
2692 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
2693 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
2694 	}
2695 
2696 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
2697 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
2698 	}
2699 
2700 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
2701 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
2702 	}
2703 
2704 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
2705 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
2706 	}
2707 
2708 	function log(uint p0, string memory p1, address p2, address p3) internal view {
2709 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
2710 	}
2711 
2712 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
2713 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
2714 	}
2715 
2716 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
2717 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
2718 	}
2719 
2720 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
2721 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
2722 	}
2723 
2724 	function log(uint p0, bool p1, uint p2, address p3) internal view {
2725 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
2726 	}
2727 
2728 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
2729 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
2730 	}
2731 
2732 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
2733 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
2734 	}
2735 
2736 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
2737 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
2738 	}
2739 
2740 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
2741 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
2742 	}
2743 
2744 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
2745 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
2746 	}
2747 
2748 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
2749 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
2750 	}
2751 
2752 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
2753 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
2754 	}
2755 
2756 	function log(uint p0, bool p1, bool p2, address p3) internal view {
2757 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
2758 	}
2759 
2760 	function log(uint p0, bool p1, address p2, uint p3) internal view {
2761 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
2762 	}
2763 
2764 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
2765 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
2766 	}
2767 
2768 	function log(uint p0, bool p1, address p2, bool p3) internal view {
2769 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
2770 	}
2771 
2772 	function log(uint p0, bool p1, address p2, address p3) internal view {
2773 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
2774 	}
2775 
2776 	function log(uint p0, address p1, uint p2, uint p3) internal view {
2777 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
2778 	}
2779 
2780 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
2781 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
2782 	}
2783 
2784 	function log(uint p0, address p1, uint p2, bool p3) internal view {
2785 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
2786 	}
2787 
2788 	function log(uint p0, address p1, uint p2, address p3) internal view {
2789 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
2790 	}
2791 
2792 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
2793 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
2794 	}
2795 
2796 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
2797 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
2798 	}
2799 
2800 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
2801 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
2802 	}
2803 
2804 	function log(uint p0, address p1, string memory p2, address p3) internal view {
2805 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
2806 	}
2807 
2808 	function log(uint p0, address p1, bool p2, uint p3) internal view {
2809 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
2810 	}
2811 
2812 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
2813 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
2814 	}
2815 
2816 	function log(uint p0, address p1, bool p2, bool p3) internal view {
2817 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
2818 	}
2819 
2820 	function log(uint p0, address p1, bool p2, address p3) internal view {
2821 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
2822 	}
2823 
2824 	function log(uint p0, address p1, address p2, uint p3) internal view {
2825 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
2826 	}
2827 
2828 	function log(uint p0, address p1, address p2, string memory p3) internal view {
2829 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
2830 	}
2831 
2832 	function log(uint p0, address p1, address p2, bool p3) internal view {
2833 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
2834 	}
2835 
2836 	function log(uint p0, address p1, address p2, address p3) internal view {
2837 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
2838 	}
2839 
2840 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
2841 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
2842 	}
2843 
2844 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
2845 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
2846 	}
2847 
2848 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
2849 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
2850 	}
2851 
2852 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
2853 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
2854 	}
2855 
2856 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
2857 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
2858 	}
2859 
2860 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
2861 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
2862 	}
2863 
2864 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
2865 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
2866 	}
2867 
2868 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
2869 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
2870 	}
2871 
2872 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
2873 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
2874 	}
2875 
2876 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
2877 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
2878 	}
2879 
2880 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
2881 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
2882 	}
2883 
2884 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
2885 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
2886 	}
2887 
2888 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
2889 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
2890 	}
2891 
2892 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
2893 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
2894 	}
2895 
2896 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
2897 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
2898 	}
2899 
2900 	function log(string memory p0, uint p1, address p2, address p3) internal view {
2901 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
2902 	}
2903 
2904 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
2905 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
2906 	}
2907 
2908 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
2909 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
2910 	}
2911 
2912 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
2913 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
2914 	}
2915 
2916 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
2917 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
2918 	}
2919 
2920 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
2921 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
2922 	}
2923 
2924 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
2925 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
2926 	}
2927 
2928 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
2929 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
2930 	}
2931 
2932 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
2933 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
2934 	}
2935 
2936 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
2937 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
2938 	}
2939 
2940 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
2941 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
2942 	}
2943 
2944 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
2945 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
2946 	}
2947 
2948 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
2949 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
2950 	}
2951 
2952 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
2953 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
2954 	}
2955 
2956 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
2957 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
2958 	}
2959 
2960 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
2961 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
2962 	}
2963 
2964 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
2965 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
2966 	}
2967 
2968 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
2969 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
2970 	}
2971 
2972 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
2973 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
2974 	}
2975 
2976 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
2977 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
2978 	}
2979 
2980 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
2981 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
2982 	}
2983 
2984 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
2985 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
2986 	}
2987 
2988 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
2989 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
2990 	}
2991 
2992 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
2993 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
2994 	}
2995 
2996 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
2997 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
2998 	}
2999 
3000 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
3001 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
3002 	}
3003 
3004 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
3005 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
3006 	}
3007 
3008 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
3009 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
3010 	}
3011 
3012 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
3013 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
3014 	}
3015 
3016 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
3017 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
3018 	}
3019 
3020 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
3021 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
3022 	}
3023 
3024 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
3025 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
3026 	}
3027 
3028 	function log(string memory p0, bool p1, address p2, address p3) internal view {
3029 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
3030 	}
3031 
3032 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
3033 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
3034 	}
3035 
3036 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
3037 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
3038 	}
3039 
3040 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
3041 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
3042 	}
3043 
3044 	function log(string memory p0, address p1, uint p2, address p3) internal view {
3045 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
3046 	}
3047 
3048 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
3049 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
3050 	}
3051 
3052 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
3053 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
3054 	}
3055 
3056 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
3057 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
3058 	}
3059 
3060 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
3061 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
3062 	}
3063 
3064 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
3065 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
3066 	}
3067 
3068 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
3069 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
3070 	}
3071 
3072 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
3073 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
3074 	}
3075 
3076 	function log(string memory p0, address p1, bool p2, address p3) internal view {
3077 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
3078 	}
3079 
3080 	function log(string memory p0, address p1, address p2, uint p3) internal view {
3081 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
3082 	}
3083 
3084 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
3085 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
3086 	}
3087 
3088 	function log(string memory p0, address p1, address p2, bool p3) internal view {
3089 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
3090 	}
3091 
3092 	function log(string memory p0, address p1, address p2, address p3) internal view {
3093 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
3094 	}
3095 
3096 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
3097 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
3098 	}
3099 
3100 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
3101 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
3102 	}
3103 
3104 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
3105 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
3106 	}
3107 
3108 	function log(bool p0, uint p1, uint p2, address p3) internal view {
3109 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
3110 	}
3111 
3112 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
3113 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
3114 	}
3115 
3116 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
3117 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
3118 	}
3119 
3120 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
3121 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
3122 	}
3123 
3124 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
3125 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
3126 	}
3127 
3128 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
3129 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
3130 	}
3131 
3132 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
3133 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
3134 	}
3135 
3136 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
3137 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
3138 	}
3139 
3140 	function log(bool p0, uint p1, bool p2, address p3) internal view {
3141 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
3142 	}
3143 
3144 	function log(bool p0, uint p1, address p2, uint p3) internal view {
3145 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
3146 	}
3147 
3148 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
3149 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
3150 	}
3151 
3152 	function log(bool p0, uint p1, address p2, bool p3) internal view {
3153 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
3154 	}
3155 
3156 	function log(bool p0, uint p1, address p2, address p3) internal view {
3157 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
3158 	}
3159 
3160 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
3161 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
3162 	}
3163 
3164 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
3165 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
3166 	}
3167 
3168 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
3169 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
3170 	}
3171 
3172 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
3173 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
3174 	}
3175 
3176 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
3177 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
3178 	}
3179 
3180 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
3181 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
3182 	}
3183 
3184 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
3185 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
3186 	}
3187 
3188 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
3189 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
3190 	}
3191 
3192 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
3193 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
3194 	}
3195 
3196 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
3197 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
3198 	}
3199 
3200 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
3201 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
3202 	}
3203 
3204 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
3205 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
3206 	}
3207 
3208 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
3209 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
3210 	}
3211 
3212 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
3213 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
3214 	}
3215 
3216 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
3217 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
3218 	}
3219 
3220 	function log(bool p0, string memory p1, address p2, address p3) internal view {
3221 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
3222 	}
3223 
3224 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
3225 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
3226 	}
3227 
3228 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
3229 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
3230 	}
3231 
3232 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
3233 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
3234 	}
3235 
3236 	function log(bool p0, bool p1, uint p2, address p3) internal view {
3237 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
3238 	}
3239 
3240 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
3241 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
3242 	}
3243 
3244 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
3245 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
3246 	}
3247 
3248 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
3249 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
3250 	}
3251 
3252 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
3253 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
3254 	}
3255 
3256 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
3257 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
3258 	}
3259 
3260 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
3261 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
3262 	}
3263 
3264 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
3265 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
3266 	}
3267 
3268 	function log(bool p0, bool p1, bool p2, address p3) internal view {
3269 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
3270 	}
3271 
3272 	function log(bool p0, bool p1, address p2, uint p3) internal view {
3273 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
3274 	}
3275 
3276 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
3277 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
3278 	}
3279 
3280 	function log(bool p0, bool p1, address p2, bool p3) internal view {
3281 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
3282 	}
3283 
3284 	function log(bool p0, bool p1, address p2, address p3) internal view {
3285 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
3286 	}
3287 
3288 	function log(bool p0, address p1, uint p2, uint p3) internal view {
3289 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
3290 	}
3291 
3292 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
3293 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
3294 	}
3295 
3296 	function log(bool p0, address p1, uint p2, bool p3) internal view {
3297 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
3298 	}
3299 
3300 	function log(bool p0, address p1, uint p2, address p3) internal view {
3301 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
3302 	}
3303 
3304 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
3305 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
3306 	}
3307 
3308 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
3309 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
3310 	}
3311 
3312 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
3313 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
3314 	}
3315 
3316 	function log(bool p0, address p1, string memory p2, address p3) internal view {
3317 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
3318 	}
3319 
3320 	function log(bool p0, address p1, bool p2, uint p3) internal view {
3321 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
3322 	}
3323 
3324 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
3325 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
3326 	}
3327 
3328 	function log(bool p0, address p1, bool p2, bool p3) internal view {
3329 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
3330 	}
3331 
3332 	function log(bool p0, address p1, bool p2, address p3) internal view {
3333 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
3334 	}
3335 
3336 	function log(bool p0, address p1, address p2, uint p3) internal view {
3337 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
3338 	}
3339 
3340 	function log(bool p0, address p1, address p2, string memory p3) internal view {
3341 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
3342 	}
3343 
3344 	function log(bool p0, address p1, address p2, bool p3) internal view {
3345 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
3346 	}
3347 
3348 	function log(bool p0, address p1, address p2, address p3) internal view {
3349 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
3350 	}
3351 
3352 	function log(address p0, uint p1, uint p2, uint p3) internal view {
3353 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
3354 	}
3355 
3356 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
3357 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
3358 	}
3359 
3360 	function log(address p0, uint p1, uint p2, bool p3) internal view {
3361 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
3362 	}
3363 
3364 	function log(address p0, uint p1, uint p2, address p3) internal view {
3365 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
3366 	}
3367 
3368 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
3369 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
3370 	}
3371 
3372 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
3373 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
3374 	}
3375 
3376 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
3377 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
3378 	}
3379 
3380 	function log(address p0, uint p1, string memory p2, address p3) internal view {
3381 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
3382 	}
3383 
3384 	function log(address p0, uint p1, bool p2, uint p3) internal view {
3385 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
3386 	}
3387 
3388 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
3389 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
3390 	}
3391 
3392 	function log(address p0, uint p1, bool p2, bool p3) internal view {
3393 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
3394 	}
3395 
3396 	function log(address p0, uint p1, bool p2, address p3) internal view {
3397 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
3398 	}
3399 
3400 	function log(address p0, uint p1, address p2, uint p3) internal view {
3401 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
3402 	}
3403 
3404 	function log(address p0, uint p1, address p2, string memory p3) internal view {
3405 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
3406 	}
3407 
3408 	function log(address p0, uint p1, address p2, bool p3) internal view {
3409 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
3410 	}
3411 
3412 	function log(address p0, uint p1, address p2, address p3) internal view {
3413 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
3414 	}
3415 
3416 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
3417 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
3418 	}
3419 
3420 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
3421 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
3422 	}
3423 
3424 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
3425 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
3426 	}
3427 
3428 	function log(address p0, string memory p1, uint p2, address p3) internal view {
3429 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
3430 	}
3431 
3432 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
3433 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
3434 	}
3435 
3436 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
3437 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
3438 	}
3439 
3440 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
3441 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
3442 	}
3443 
3444 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
3445 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
3446 	}
3447 
3448 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
3449 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
3450 	}
3451 
3452 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
3453 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
3454 	}
3455 
3456 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
3457 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
3458 	}
3459 
3460 	function log(address p0, string memory p1, bool p2, address p3) internal view {
3461 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
3462 	}
3463 
3464 	function log(address p0, string memory p1, address p2, uint p3) internal view {
3465 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
3466 	}
3467 
3468 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
3469 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
3470 	}
3471 
3472 	function log(address p0, string memory p1, address p2, bool p3) internal view {
3473 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
3474 	}
3475 
3476 	function log(address p0, string memory p1, address p2, address p3) internal view {
3477 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
3478 	}
3479 
3480 	function log(address p0, bool p1, uint p2, uint p3) internal view {
3481 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
3482 	}
3483 
3484 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
3485 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
3486 	}
3487 
3488 	function log(address p0, bool p1, uint p2, bool p3) internal view {
3489 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
3490 	}
3491 
3492 	function log(address p0, bool p1, uint p2, address p3) internal view {
3493 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
3494 	}
3495 
3496 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
3497 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
3498 	}
3499 
3500 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
3501 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
3502 	}
3503 
3504 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
3505 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
3506 	}
3507 
3508 	function log(address p0, bool p1, string memory p2, address p3) internal view {
3509 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
3510 	}
3511 
3512 	function log(address p0, bool p1, bool p2, uint p3) internal view {
3513 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
3514 	}
3515 
3516 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
3517 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
3518 	}
3519 
3520 	function log(address p0, bool p1, bool p2, bool p3) internal view {
3521 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
3522 	}
3523 
3524 	function log(address p0, bool p1, bool p2, address p3) internal view {
3525 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
3526 	}
3527 
3528 	function log(address p0, bool p1, address p2, uint p3) internal view {
3529 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
3530 	}
3531 
3532 	function log(address p0, bool p1, address p2, string memory p3) internal view {
3533 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
3534 	}
3535 
3536 	function log(address p0, bool p1, address p2, bool p3) internal view {
3537 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
3538 	}
3539 
3540 	function log(address p0, bool p1, address p2, address p3) internal view {
3541 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
3542 	}
3543 
3544 	function log(address p0, address p1, uint p2, uint p3) internal view {
3545 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
3546 	}
3547 
3548 	function log(address p0, address p1, uint p2, string memory p3) internal view {
3549 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
3550 	}
3551 
3552 	function log(address p0, address p1, uint p2, bool p3) internal view {
3553 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
3554 	}
3555 
3556 	function log(address p0, address p1, uint p2, address p3) internal view {
3557 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
3558 	}
3559 
3560 	function log(address p0, address p1, string memory p2, uint p3) internal view {
3561 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
3562 	}
3563 
3564 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
3565 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
3566 	}
3567 
3568 	function log(address p0, address p1, string memory p2, bool p3) internal view {
3569 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
3570 	}
3571 
3572 	function log(address p0, address p1, string memory p2, address p3) internal view {
3573 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
3574 	}
3575 
3576 	function log(address p0, address p1, bool p2, uint p3) internal view {
3577 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
3578 	}
3579 
3580 	function log(address p0, address p1, bool p2, string memory p3) internal view {
3581 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
3582 	}
3583 
3584 	function log(address p0, address p1, bool p2, bool p3) internal view {
3585 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
3586 	}
3587 
3588 	function log(address p0, address p1, bool p2, address p3) internal view {
3589 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
3590 	}
3591 
3592 	function log(address p0, address p1, address p2, uint p3) internal view {
3593 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
3594 	}
3595 
3596 	function log(address p0, address p1, address p2, string memory p3) internal view {
3597 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
3598 	}
3599 
3600 	function log(address p0, address p1, address p2, bool p3) internal view {
3601 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
3602 	}
3603 
3604 	function log(address p0, address p1, address p2, address p3) internal view {
3605 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
3606 	}
3607 
3608 }
3609 
3610 
3611 // File contracts/interfaces/INFTExtension.sol
3612 
3613 
3614 pragma solidity ^0.8.9;
3615 
3616 interface INFTExtension is IERC165 {}
3617 
3618 interface INFTURIExtension is INFTExtension {
3619     function tokenURI(uint256 tokenId) external view returns (string memory);
3620 }
3621 
3622 
3623 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
3624 
3625 
3626 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
3627 
3628 pragma solidity ^0.8.0;
3629 
3630 /**
3631  * @dev Required interface of an ERC721 compliant contract.
3632  */
3633 interface IERC721 is IERC165 {
3634     /**
3635      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
3636      */
3637     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
3638 
3639     /**
3640      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
3641      */
3642     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
3643 
3644     /**
3645      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
3646      */
3647     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
3648 
3649     /**
3650      * @dev Returns the number of tokens in ``owner``'s account.
3651      */
3652     function balanceOf(address owner) external view returns (uint256 balance);
3653 
3654     /**
3655      * @dev Returns the owner of the `tokenId` token.
3656      *
3657      * Requirements:
3658      *
3659      * - `tokenId` must exist.
3660      */
3661     function ownerOf(uint256 tokenId) external view returns (address owner);
3662 
3663     /**
3664      * @dev Safely transfers `tokenId` token from `from` to `to`.
3665      *
3666      * Requirements:
3667      *
3668      * - `from` cannot be the zero address.
3669      * - `to` cannot be the zero address.
3670      * - `tokenId` token must exist and be owned by `from`.
3671      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3672      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3673      *
3674      * Emits a {Transfer} event.
3675      */
3676     function safeTransferFrom(
3677         address from,
3678         address to,
3679         uint256 tokenId,
3680         bytes calldata data
3681     ) external;
3682 
3683     /**
3684      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
3685      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
3686      *
3687      * Requirements:
3688      *
3689      * - `from` cannot be the zero address.
3690      * - `to` cannot be the zero address.
3691      * - `tokenId` token must exist and be owned by `from`.
3692      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
3693      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
3694      *
3695      * Emits a {Transfer} event.
3696      */
3697     function safeTransferFrom(
3698         address from,
3699         address to,
3700         uint256 tokenId
3701     ) external;
3702 
3703     /**
3704      * @dev Transfers `tokenId` token from `from` to `to`.
3705      *
3706      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
3707      *
3708      * Requirements:
3709      *
3710      * - `from` cannot be the zero address.
3711      * - `to` cannot be the zero address.
3712      * - `tokenId` token must be owned by `from`.
3713      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
3714      *
3715      * Emits a {Transfer} event.
3716      */
3717     function transferFrom(
3718         address from,
3719         address to,
3720         uint256 tokenId
3721     ) external;
3722 
3723     /**
3724      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
3725      * The approval is cleared when the token is transferred.
3726      *
3727      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
3728      *
3729      * Requirements:
3730      *
3731      * - The caller must own the token or be an approved operator.
3732      * - `tokenId` must exist.
3733      *
3734      * Emits an {Approval} event.
3735      */
3736     function approve(address to, uint256 tokenId) external;
3737 
3738     /**
3739      * @dev Approve or remove `operator` as an operator for the caller.
3740      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
3741      *
3742      * Requirements:
3743      *
3744      * - The `operator` cannot be the caller.
3745      *
3746      * Emits an {ApprovalForAll} event.
3747      */
3748     function setApprovalForAll(address operator, bool _approved) external;
3749 
3750     /**
3751      * @dev Returns the account approved for `tokenId` token.
3752      *
3753      * Requirements:
3754      *
3755      * - `tokenId` must exist.
3756      */
3757     function getApproved(uint256 tokenId) external view returns (address operator);
3758 
3759     /**
3760      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
3761      *
3762      * See {setApprovalForAll}
3763      */
3764     function isApprovedForAll(address owner, address operator) external view returns (bool);
3765 }
3766 
3767 
3768 // File contracts/interfaces/IMetaverseNFT.sol
3769 
3770 
3771 pragma solidity ^0.8.9;
3772 
3773 interface IAvatarNFT {
3774     function DEVELOPER() external pure returns (string memory _url);
3775 
3776     function DEVELOPER_ADDRESS() external pure returns (address payable _dev);
3777 
3778     // ------ View functions ------
3779     function saleStarted() external view returns (bool);
3780 
3781     function isExtensionAdded(address extension) external view returns (bool);
3782 
3783     /**
3784         Extra information stored for each tokenId. Optional, provided on mint
3785      */
3786     function data(uint256 tokenId) external view returns (bytes32);
3787 
3788     // ------ Mint functions ------
3789     /**
3790         Mint from NFTExtension contract. Optionally provide data parameter.
3791      */
3792     function mintExternal(
3793         uint256 tokenId,
3794         address to,
3795         bytes32 data
3796     ) external payable;
3797 
3798     // ------ Admin functions ------
3799     function addExtension(address extension) external;
3800 
3801     function revokeExtension(address extension) external;
3802 
3803     function withdraw() external;
3804 }
3805 
3806 interface IMetaverseNFT is IAvatarNFT {
3807     // ------ View functions ------
3808     /**
3809         Recommended royalty for tokenId sale.
3810      */
3811     function royaltyInfo(uint256 tokenId, uint256 salePrice)
3812         external
3813         view
3814         returns (address receiver, uint256 royaltyAmount);
3815 
3816     // ------ Admin functions ------
3817     function setRoyaltyReceiver(address receiver) external;
3818 
3819     function setRoyaltyFee(uint256 fee) external;
3820 }
3821 
3822 
3823 // File contracts/utils/OpenseaProxy.sol
3824 
3825 
3826 pragma solidity ^0.8.9;
3827 
3828 // These contract definitions are used to create a reference to the OpenSea
3829 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
3830 interface OwnableDelegateProxy {
3831 
3832 }
3833 
3834 interface ProxyRegistry {
3835     function proxies(address) external view returns (OwnableDelegateProxy);
3836 }
3837 
3838 
3839 // File contracts/utils/NextShuffler.sol
3840 
3841 
3842 // Copyright (c) 2021 the ethier authors (github.com/divergencetech/ethier)
3843 pragma solidity >=0.8.9 <0.9.0;
3844 
3845 /**
3846 @notice Returns the next value in a shuffled list [0,n), amortising the shuffle
3847 across all calls to _next(). Can be used for randomly allocating a set of tokens
3848 but the caveats in `dev` docs MUST be noted.
3849 @dev Although the final shuffle is uniformly random, it is entirely
3850 deterministic if the seed to the PRNG.Source is known. This MUST NOT be used for
3851 applications that require secure (i.e. can't be manipulated) allocation unless
3852 parties who stand to gain from malicious use have no control over nor knowledge
3853 of the seed at the time that their transaction results in a call to _next().
3854  */
3855 contract NextShuffler {
3856     using PRNG for PRNG.Source;
3857 
3858     /// @notice Total number of elements to shuffle.
3859     /// @notice THIS LINE IS DIFFERENT, ORIGINALLY THIS VALUE IS IMMUTABLE
3860     uint256 public numToShuffle;
3861 
3862     /// @param numToShuffle_ Total number of elements to shuffle.
3863     constructor(uint256 numToShuffle_) {
3864         numToShuffle = numToShuffle_;
3865     }
3866 
3867     /**
3868     @dev Number of items already shuffled; i.e. number of historical calls to
3869     _next(). This is the equivalent of `i` in the Wikipedia description of the
3870     Fisher–Yates algorithm.
3871      */
3872     uint256 private shuffled;
3873 
3874     /**
3875     @dev A sparse representation of the shuffled list [0,n). List items that
3876     have been shuffled are stored with their original index as the key and their
3877     new index + 1 as their value. Note that mappings with numerical values
3878     return 0 for non-existent keys so we MUST increment the new index to
3879     differentiate between a default value and a new index of 0. See _get() and
3880     _set().
3881      */
3882     mapping(uint256 => uint256) private _permutation;
3883 
3884     /**
3885     @notice Returns the current value stored in list index `i`, accounting for
3886     all historical shuffling.
3887      */
3888     function _get(uint256 i) private view returns (uint256) {
3889         uint256 val = _permutation[i];
3890         return val == 0 ? i : val - 1;
3891     }
3892 
3893     /**
3894     @notice Sets the list index `i` to `val`, equivalent `arr[i] = val` in a
3895     standard Fisher–Yates shuffle.
3896      */
3897     function _set(uint256 i, uint256 val) private {
3898         _permutation[i] = i == val ? 0 : val + 1;
3899     }
3900 
3901     /// @notice Emited on each call to _next() to allow for thorough testing.
3902     event ShuffledWith(uint256 current, uint256 with);
3903 
3904     /**
3905     @notice Returns the next value in the shuffle list in O(1) time and memory.
3906     @dev NB: See the `dev` documentation of this contract re security (or lack
3907     thereof) of deterministic shuffling.
3908      */
3909     function _next(PRNG.Source src) internal returns (uint256) {
3910         require(shuffled < numToShuffle, "NextShuffler: finished");
3911 
3912         uint256 j = src.readLessThan(numToShuffle - shuffled) + shuffled;
3913         emit ShuffledWith(shuffled, j);
3914 
3915         uint256 chosen = _get(j);
3916         _set(j, _get(shuffled));
3917         shuffled++;
3918         return chosen;
3919     }
3920 }
3921 
3922 
3923 // File contracts/utils/NextShufflerLazyInit.sol
3924 
3925 
3926 pragma solidity ^0.8.9;
3927 
3928 
3929 contract NextShufflerLazyInit is NextShuffler {
3930     using PRNG for PRNG.Source;
3931 
3932     uint256[2] private _nextShufflerSourceStore;
3933     bool private _isRandomnessSourceSet;
3934 
3935     constructor () NextShuffler(0) {}
3936 
3937     function isNumToShuffleSet() public view returns (bool) {
3938         return numToShuffle != 0;
3939     }
3940 
3941     function isRandomnessSourceSet() internal view returns (bool) {
3942         return _isRandomnessSourceSet;
3943     }
3944 
3945     function _setNumToShuffle(uint256 _num) internal {
3946         require(numToShuffle == 0, "NextShufflerLazyInit: numToShuffle can only be set once");
3947         numToShuffle = _num;
3948     }
3949 
3950     function _setRandomnessSource(bytes32 seed) internal {
3951         require(
3952             !isNumToShuffleSet(),
3953             "Can't change source after seed has been set"
3954         );
3955 
3956         PRNG.Source src = PRNG.newSource(seed);
3957 
3958         src.store(_nextShufflerSourceStore);
3959 
3960         _isRandomnessSourceSet = true;
3961     }
3962 
3963     function _load() internal view returns (PRNG.Source) {
3964         return PRNG.loadSource(_nextShufflerSourceStore);
3965     }
3966 
3967     function _store(PRNG.Source _src) internal {
3968         _src.store(_nextShufflerSourceStore);
3969     }
3970 }
3971 
3972 
3973 // File contracts/MetaverseBaseNFT_ERC1155.sol
3974 
3975 
3976 pragma solidity ^0.8.9;
3977 
3978 /**
3979  * @title LICENSE REQUIREMENT
3980  * @dev This contract is licensed under the MIT license.
3981  * @dev You're not allowed to remove DEVELOPER() and DEVELOPER_ADDRESS() from contract
3982  */
3983 
3984 
3985 
3986 
3987 
3988 
3989 
3990 
3991 
3992 
3993 
3994 
3995 //      Want to launch your own collection?
3996 //        Check out https://buildship.xyz
3997 
3998 //                                    ,:loxO0KXXc
3999 //                               ,cdOKKKOxol:lKWl
4000 //                            ;oOXKko:,      ;KNc
4001 //                        'ox0X0d:           cNK,
4002 //                 ','  ;xXX0x:              dWk
4003 //            ,cdO0KKKKKXKo,                ,0Nl
4004 //         ;oOXKko:,;kWMNl                  dWO'
4005 //      ,o0XKd:'    oNMMK:                 cXX:
4006 //   'ckNNk:       ;KMN0c                 cXXl
4007 //  'OWMMWKOdl;'    cl;                  oXXc
4008 //   ;cclldxOKXKkl,                    ;kNO;
4009 //            ;cdk0kl'             ;clxXXo
4010 //                ':oxo'         c0WMMMMK;
4011 //                    :l:       lNMWXxOWWo
4012 //                      ';      :xdc' :XWd
4013 //             ,                      cXK;
4014 //           ':,                      xXl
4015 //           ;:      '               o0c
4016 //           ;c;,,,,'               lx;
4017 //            '''                  cc
4018 //                                ,'
4019 contract MetaverseBaseNFT_ERC1155 is
4020     ERC1155Supply,
4021     ReentrancyGuard,
4022     Ownable,
4023     NextShufflerLazyInit,
4024     IMetaverseNFT // implements IERC2981
4025 {
4026     using Address for address;
4027     using SafeERC20 for IERC20;
4028     using Counters for Counters.Counter;
4029     using Strings for uint256;
4030 
4031     Counters.Counter private _nextTokenIndex; // token index counter
4032 
4033     uint256 public constant SALE_STARTS_AT_INFINITY = 2**256 - 1;
4034     uint256 public constant DEVELOPER_FEE = 500; // of 10,000 = 5%
4035 
4036     uint256 public startTimestamp = SALE_STARTS_AT_INFINITY;
4037 
4038     uint256 public reserved;
4039     uint256 public maxSupply;
4040     uint256 public maxPerMint;
4041     uint256 public maxPerWallet;
4042     uint256 public price;
4043 
4044     uint256 public royaltyFee;
4045 
4046     address public royaltyReceiver;
4047     address public payoutReceiver = address(0x0);
4048     address public uriExtension = address(0x0);
4049 
4050     bool public isFrozen;
4051     bool public isPayoutChangeLocked;
4052     bool private isOpenSeaProxyActive = true;
4053     bool private startAtOne = false;
4054 
4055     mapping(uint256 => uint256) internal _maxSeriesSupply;
4056 
4057     /**
4058      * @dev Additional data for each token that needs to be stored and accessed on-chain
4059      */
4060     mapping(uint256 => bytes32) public data;
4061 
4062     /**
4063      * @dev Storing how many tokens each address has minted in public sale
4064      */
4065     mapping(address => uint256) public mintedBy;
4066 
4067     /**
4068      * @dev List of connected extensions
4069      */
4070     INFTExtension[] public extensions;
4071 
4072     string public PROVENANCE_HASH = "";
4073     string private CONTRACT_URI = "";
4074     string private BASE_URI;
4075     string private URI_POSTFIX = "";
4076 
4077     string public name;
4078     string public symbol;
4079 
4080     event ExtensionAdded(address indexed extensionAddress);
4081     event ExtensionRevoked(address indexed extensionAddress);
4082     event ExtensionURIAdded(address indexed extensionAddress);
4083 
4084     constructor(
4085         uint256 _price,
4086         uint256 _maxSupply, // only limit ids here, not the full number of NFTs
4087         uint256 _nReserved,
4088         uint256 _maxPerMint,
4089         uint256 _royaltyFee,
4090         string memory _uri,
4091         string memory _name,
4092         string memory _symbol,
4093         bool _startAtOne
4094     ) ERC1155(_uri) {
4095         startTimestamp = SALE_STARTS_AT_INFINITY;
4096 
4097         price = _price;
4098         reserved = _nReserved;
4099         maxPerMint = _maxPerMint;
4100         maxSupply = _maxSupply;
4101 
4102         royaltyFee = _royaltyFee;
4103         royaltyReceiver = address(this);
4104 
4105         startAtOne = _startAtOne;
4106 
4107         name = _name;
4108         symbol = _symbol;
4109 
4110         // Need help with uploading metadata? Try https://buildship.xyz
4111         BASE_URI = _uri;
4112     }
4113 
4114     function contractURI() public view returns (string memory _uri) {
4115         _uri = bytes(CONTRACT_URI).length > 0 ? CONTRACT_URI : BASE_URI;
4116     }
4117 
4118     function tokenURI(uint256 _tokenId) public view returns (string memory) {
4119         return uri(_tokenId);
4120     }
4121 
4122     function uri(uint256 tokenId) public view override returns (string memory) {
4123         if (uriExtension != address(0)) {
4124             string memory _uri = INFTURIExtension(uriExtension).tokenURI(
4125                 tokenId
4126             );
4127 
4128             if (bytes(_uri).length > 0) {
4129                 return _uri;
4130             }
4131         }
4132 
4133         if (bytes(URI_POSTFIX).length > 0) {
4134             return
4135                 string(
4136                     abi.encodePacked(BASE_URI, tokenId.toString(), URI_POSTFIX)
4137                 );
4138         } else {
4139             return string(abi.encodePacked(BASE_URI, tokenId.toString()));
4140         }
4141     }
4142 
4143     function startTokenId() public view returns (uint256) {
4144         return startAtOne ? 1 : 0;
4145     }
4146 
4147     function maxSeriesSupply(uint256 id) public view returns (uint256) {
4148         return _maxSeriesSupply[id];
4149     }
4150 
4151     function totalSeriesSupply(uint256 id) public view returns (uint256) {
4152         return totalSupply(id);
4153     }
4154 
4155     function maxSupplyAll() public view returns (uint256) {
4156         // sum of all token ids
4157         uint256 total = 0;
4158 
4159         for (uint256 id = startTokenId(); id < nextTokenId(); id++) {
4160             total += maxSeriesSupply(id);
4161         }
4162 
4163         return total;
4164     }
4165 
4166     function totalSupplyAll() public view returns (uint256) {
4167         // sum of all token ids
4168         uint256 total = 0;
4169 
4170         for (uint256 id = startTokenId(); id < nextTokenId(); id++) {
4171             total += totalSeriesSupply(id);
4172         }
4173 
4174         return total;
4175     }
4176 
4177     // ----- Admin functions -----
4178 
4179     function setBaseURI(string calldata _uri) public onlyOwner {
4180         BASE_URI = _uri;
4181     }
4182 
4183     // Contract-level metadata for Opensea
4184     function setContractURI(string calldata _uri) public onlyOwner {
4185         CONTRACT_URI = _uri;
4186     }
4187 
4188     function setPostfixURI(string calldata postfix) public onlyOwner {
4189         URI_POSTFIX = postfix;
4190     }
4191 
4192     function setPrice(uint256 _price) public onlyOwner {
4193         price = _price;
4194     }
4195 
4196     function setRandomnessSource(bytes32 seed) public onlyOwner {
4197         require(
4198             startTokenId() + maxSupply == nextTokenId(),
4199             "First import all series"
4200         );
4201 
4202         _setRandomnessSource(seed);
4203         _setNumToShuffle(maxSupplyAll());
4204     }
4205 
4206     // Freeze forever, irreversible
4207     function freeze() public onlyOwner {
4208         isFrozen = true;
4209     }
4210 
4211     // Lock changing withdraw address
4212     function lockPayoutChange() public onlyOwner {
4213         isPayoutChangeLocked = true;
4214     }
4215 
4216     function isExtensionAdded(address _extension) public view returns (bool) {
4217         for (uint256 index = 0; index < extensions.length; index++) {
4218             if (address(extensions[index]) == _extension) {
4219                 return true;
4220             }
4221         }
4222 
4223         return false;
4224     }
4225 
4226     function extensionsLength() public view returns (uint256) {
4227         return extensions.length;
4228     }
4229 
4230     // Extensions are allowed to mint
4231     function addExtension(address _extension) public onlyOwner {
4232         require(_extension != address(this), "Cannot add self as extension");
4233 
4234         require(!isExtensionAdded(_extension), "Extension already added");
4235 
4236         extensions.push(INFTExtension(_extension));
4237 
4238         emit ExtensionAdded(_extension);
4239     }
4240 
4241     function revokeExtension(address _extension) public onlyOwner {
4242         uint256 index = 0;
4243 
4244         for (; index < extensions.length; index++) {
4245             if (extensions[index] == INFTExtension(_extension)) {
4246                 break;
4247             }
4248         }
4249 
4250         extensions[index] = extensions[extensions.length - 1];
4251         extensions.pop();
4252 
4253         emit ExtensionRevoked(_extension);
4254     }
4255 
4256     function setExtensionTokenURI(address extension) public onlyOwner {
4257         require(extension != address(this), "Cannot add self as extension");
4258 
4259         require(
4260             extension == address(0x0) ||
4261                 ERC165Checker.supportsInterface(
4262                     extension,
4263                     type(INFTURIExtension).interfaceId
4264                 ),
4265             "Not conforms to extension"
4266         );
4267 
4268         uriExtension = extension;
4269 
4270         emit ExtensionURIAdded(extension);
4271     }
4272 
4273     // function to disable gasless listings for security in case
4274     // opensea ever shuts down or is compromised
4275     // from CryptoCoven https://etherscan.io/address/0x5180db8f5c931aae63c74266b211f580155ecac8#code
4276     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
4277         public
4278         onlyOwner
4279     {
4280         isOpenSeaProxyActive = _isOpenSeaProxyActive;
4281     }
4282 
4283     // ---- Minting ----
4284 
4285     function _mintConsecutive(
4286         uint256 nTokens,
4287         address to,
4288         bytes32 _data
4289     ) internal {
4290         require(
4291             totalSupplyAll() + nTokens + reserved <= maxSupplyAll(),
4292             "Not enough Tokens left."
4293         );
4294 
4295         // if data is 0xffffff...ff, then it is a request for a N sequential tokens
4296         // else it's a request for a specific token id
4297 
4298         if (uint256(_data) == type(uint256).max) {
4299             revert("Not implemented");
4300         } else {
4301             uint256 id = uint256(_data);
4302             _mint(to, id, nTokens, "");
4303         }
4304 
4305         if (_data.length > 0) {
4306             for (uint256 i; i < nTokens; i++) {
4307                 uint256 tokenId = nextTokenId() + i;
4308                 data[tokenId] = _data;
4309             }
4310         }
4311 
4312     }
4313 
4314     // ---- ERC1155Randomized -----
4315 
4316     function nextTokenId() public view returns (uint256) {
4317         return startTokenId() + _nextTokenIndex.current();
4318     }
4319 
4320     function getNextTokenId() internal returns (uint256 id) {
4321         id = _nextTokenIndex.current();
4322 
4323         _nextTokenIndex.increment();
4324     }
4325 
4326     function tokenOffset2TokenId(uint256 seed) public view returns (uint256) {
4327         return _tokenOffset2TokenId(seed);
4328     }
4329 
4330     function createTokenSeries(uint256[] memory supply) public onlyOwner {
4331         require(
4332             nextTokenId() + supply.length - 1 - startTokenId() <= maxSupply,
4333             "Too many tokens"
4334         );
4335 
4336         for (uint256 i = 0; i < supply.length; i++) {
4337             uint256 tokenId = startTokenId() + getNextTokenId();
4338             uint256 _supply = supply[i];
4339 
4340             // require(_supply > 0, "Supply must be greater than 0");
4341             require(_maxSeriesSupply[tokenId] == 0, "Token already imported");
4342             require(_supply != 0, "Can't import empty series");
4343 
4344             _maxSeriesSupply[tokenId] = _supply;
4345         }
4346     }
4347 
4348     function _mintTokens(
4349         address to,
4350         uint256 tokenId,
4351         uint256 amount
4352     ) internal {
4353         require(amount > 0, "Amount must be greater than 0");
4354         require(
4355             totalSeriesSupply(tokenId) + amount <= maxSeriesSupply(tokenId),
4356             "Amount exceeds max supply"
4357         );
4358         require(
4359             tokenId >= startTokenId() && tokenId < nextTokenId(),
4360             "TokenId out of range"
4361         );
4362 
4363         // Mint the tokens
4364         _mint(to, tokenId, amount, "");
4365     }
4366 
4367     function _tokenOffset2TokenId(uint256 seed)
4368         internal
4369         view
4370         returns (uint256)
4371     {
4372         uint256 index = 0;
4373         uint256 lastIndex;
4374 
4375         for (
4376             uint256 tokenId = startTokenId();
4377             tokenId < nextTokenId();
4378             tokenId++
4379         ) {
4380             lastIndex = index + maxSeriesSupply(tokenId) - 1;
4381 
4382             if (seed <= lastIndex && seed >= index) {
4383                 return tokenId;
4384             }
4385 
4386             index = lastIndex + 1;
4387         }
4388 
4389         console.log("Last Index", index);
4390         console.log("Seed", seed);
4391         console.log("Max supply", maxSupplyAll());
4392         console.log("Last token Id", nextTokenId());
4393 
4394         revert("Not found");
4395         // id = 0;
4396     }
4397 
4398     function _mintRandomTokens(uint256 amount, address to) internal {
4399         require(
4400             totalSupplyAll() + amount + reserved <= maxSupplyAll(),
4401             "Not enough Tokens left."
4402         );
4403 
4404         require(isRandomnessSourceSet(), "Randomness source not set");
4405 
4406         uint256 tokenOffset;
4407         uint256 tokenId;
4408 
4409         console.log("amount", amount);
4410 
4411         PRNG.Source rndSource = _load();
4412 
4413         for (uint256 i = 0; i < amount; i++) {
4414             tokenOffset = _next(rndSource);
4415 
4416             // token id is fetched from the random offset
4417             tokenId = _tokenOffset2TokenId(tokenOffset);
4418 
4419             _mintTokens(to, tokenId, 1);
4420         }
4421 
4422         _store(rndSource);
4423     }
4424 
4425     // ---- Mint control ----
4426 
4427     modifier whenSaleStarted() {
4428         require(saleStarted(), "Sale not started");
4429         _;
4430     }
4431 
4432     modifier whenNotFrozen() {
4433         require(!isFrozen, "Minting is frozen");
4434         _;
4435     }
4436 
4437     modifier whenNotPayoutChangeLocked() {
4438         require(!isPayoutChangeLocked, "Payout change is locked");
4439         _;
4440     }
4441 
4442     modifier onlyExtension() {
4443         require(
4444             isExtensionAdded(msg.sender),
4445             "Extension should be added to contract before minting"
4446         );
4447         _;
4448     }
4449 
4450     // ---- Mint public ----
4451 
4452     // Contract can sell tokens
4453     function mint(uint256 nTokens)
4454         external
4455         payable
4456         nonReentrant
4457         whenSaleStarted
4458     {
4459         // setting it to 0 means no limit
4460         if (maxPerWallet > 0) {
4461             require(
4462                 mintedBy[msg.sender] + nTokens <= maxPerWallet,
4463                 "You cannot mint more than maxPerWallet tokens for one address!"
4464             );
4465         }
4466         mintedBy[msg.sender] += nTokens;
4467 
4468         require(
4469             nTokens <= maxPerMint,
4470             "You cannot mint more than MAX_TOKENS_PER_MINT tokens at once!"
4471         );
4472 
4473         require(nTokens * price <= msg.value, "Inconsistent amount sent!");
4474 
4475         _mintRandomTokens(nTokens, msg.sender);
4476     }
4477 
4478     // Owner can claim free tokens
4479     function claim(uint256 nTokens, address to)
4480         external
4481         nonReentrant
4482         onlyOwner
4483     {
4484         require(nTokens <= reserved, "That would exceed the max reserved.");
4485 
4486         reserved = reserved - nTokens;
4487 
4488         _mintRandomTokens(nTokens, to);
4489     }
4490 
4491     // ---- Mint via extension
4492 
4493     function mintExternal(
4494         uint256 nTokens,
4495         address to,
4496         bytes32 _data
4497     ) external payable onlyExtension nonReentrant {
4498         // if data is 0x0, then it is a request for a N random tokens
4499         // else it's a request for a specific token id
4500         // but data is (offset + 0xff) for the token id
4501         // where token id = offset + startTokenId()
4502 
4503         if (_data == 0x0) {
4504             _mintRandomTokens(nTokens, to);
4505         } else {
4506             uint256 offset = uint256(_data) - 0xff;
4507             uint256 id = offset + startTokenId();
4508             _mintTokens(to, id, nTokens);
4509         }
4510     }
4511 
4512     // ---- Mint configuration
4513 
4514     function updateMaxPerMint(uint256 _maxPerMint)
4515         external
4516         onlyOwner
4517         nonReentrant
4518     {
4519         maxPerMint = _maxPerMint;
4520     }
4521 
4522     function updateMaxPerWallet(uint256 _maxPerWallet)
4523         external
4524         onlyOwner
4525         nonReentrant
4526     {
4527         maxPerWallet = _maxPerWallet;
4528     }
4529 
4530     // ---- Sale control ----
4531 
4532     function updateStartTimestamp(uint256 _startTimestamp)
4533         public
4534         onlyOwner
4535         whenNotFrozen
4536     {
4537         startTimestamp = _startTimestamp;
4538     }
4539 
4540     function startSale() public onlyOwner whenNotFrozen {
4541         require(
4542             startTokenId() + maxSupply == nextTokenId(),
4543             "First create all token series"
4544         );
4545 
4546         require(isRandomnessSourceSet(), "You should set source before startSale");
4547 
4548         startTimestamp = block.timestamp;
4549     }
4550 
4551     function stopSale() public onlyOwner {
4552         startTimestamp = SALE_STARTS_AT_INFINITY;
4553     }
4554 
4555     function saleStarted() public view returns (bool) {
4556         return block.timestamp >= startTimestamp;
4557     }
4558 
4559     // ---- Offchain Info ----
4560 
4561     // This should be set before sales open.
4562     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
4563         PROVENANCE_HASH = provenanceHash;
4564     }
4565 
4566     function setRoyaltyFee(uint256 _royaltyFee) public onlyOwner {
4567         royaltyFee = _royaltyFee;
4568     }
4569 
4570     function setRoyaltyReceiver(address _receiver) public onlyOwner {
4571         royaltyReceiver = _receiver;
4572     }
4573 
4574     function setPayoutReceiver(address _receiver)
4575         public
4576         onlyOwner
4577         whenNotPayoutChangeLocked
4578     {
4579         payoutReceiver = payable(_receiver);
4580     }
4581 
4582     function royaltyInfo(uint256, uint256 salePrice)
4583         external
4584         view
4585         returns (address receiver, uint256 royaltyAmount)
4586     {
4587         // We use the same contract to split royalties: 5% of royalty goes to the developer
4588         receiver = royaltyReceiver;
4589         royaltyAmount = (salePrice * royaltyFee) / 10000;
4590     }
4591 
4592     function getPayoutReceiver()
4593         public
4594         view
4595         returns (address payable receiver)
4596     {
4597         receiver = payoutReceiver != address(0x0)
4598             ? payable(payoutReceiver)
4599             : payable(owner());
4600     }
4601 
4602     // ---- Allow royalty deposits from Opensea -----
4603 
4604     receive() external payable {}
4605 
4606     // ---- Withdraw -----
4607 
4608     modifier onlyBuildship() {
4609         require(
4610             payable(msg.sender) == DEVELOPER_ADDRESS(),
4611             "Caller is not Buildship"
4612         );
4613         _;
4614     }
4615 
4616     function _withdraw() private {
4617         uint256 balance = address(this).balance;
4618         uint256 amount = (balance * (10000 - DEVELOPER_FEE)) / 10000;
4619 
4620         address payable receiver = getPayoutReceiver();
4621         address payable dev = DEVELOPER_ADDRESS();
4622 
4623         Address.sendValue(receiver, amount);
4624         Address.sendValue(dev, balance - amount);
4625     }
4626 
4627     function withdraw() public virtual onlyOwner {
4628         _withdraw();
4629     }
4630 
4631     function forceWithdrawBuildship() public virtual onlyBuildship {
4632         _withdraw();
4633     }
4634 
4635     function withdrawToken(IERC20 token) public virtual onlyOwner {
4636         uint256 balance = token.balanceOf(address(this));
4637 
4638         uint256 amount = (balance * (10000 - DEVELOPER_FEE)) / 10000;
4639 
4640         address payable receiver = getPayoutReceiver();
4641         address payable dev = DEVELOPER_ADDRESS();
4642 
4643         token.safeTransfer(receiver, amount);
4644         token.safeTransfer(dev, balance - amount);
4645     }
4646 
4647     function DEVELOPER() public pure returns (string memory _url) {
4648         _url = "https://buildship.xyz";
4649     }
4650 
4651     function DEVELOPER_ADDRESS() public pure returns (address payable _dev) {
4652         _dev = payable(0x704C043CeB93bD6cBE570C6A2708c3E1C0310587);
4653     }
4654 
4655     // -------- ERC1155 overrides --------
4656 
4657     function supportsInterface(bytes4 interfaceId)
4658         public
4659         view
4660         override
4661         returns (bool)
4662     {
4663         return
4664             interfaceId == type(IERC2981).interfaceId ||
4665             interfaceId == type(IMetaverseNFT).interfaceId ||
4666             super.supportsInterface(interfaceId);
4667     }
4668 
4669     /**
4670      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
4671      * Taken from CryptoCoven: https://etherscan.io/address/0x5180db8f5c931aae63c74266b211f580155ecac8#code
4672      */
4673     function isApprovedForAll(address owner, address operator)
4674         public
4675         view
4676         override
4677         returns (bool)
4678     {
4679         // Get a reference to OpenSea's proxy registry contract by instantiating
4680         // the contract using the already existing address.
4681         ProxyRegistry proxyRegistry = ProxyRegistry(
4682             0xa5409ec958C83C3f309868babACA7c86DCB077c1
4683         );
4684 
4685         if (
4686             isOpenSeaProxyActive &&
4687             address(proxyRegistry.proxies(owner)) == operator
4688         ) {
4689             return true;
4690         }
4691 
4692         return super.isApprovedForAll(owner, operator);
4693     }
4694 }
4695 
4696 contract Wilderness is MetaverseBaseNFT_ERC1155 {
4697     constructor () MetaverseBaseNFT_ERC1155(
4698         0 ether, // public mint price
4699         88, // max supply
4700         1, // reserved for admin for testing
4701         1, // max per mint
4702         1000, // royalties
4703         // hidden metadata
4704         "ipfs://bafybeialzno2az7tiei2enotshnkymsbnm7n4rg22h4oruopkzxsy6zq3q/",
4705         "Wilderness to Blockchain", // token name
4706         "WtoB", // token symbol
4707         true // start token id from 1
4708     ) {
4709         createTokenSeries(
4710             _createDynamicArray88(
4711                 [ 420,10,33,69,10,111,69,69,420,33,420,420,69,69,33,33,33,69,69,111,111,33,33,33,69,33,33,10,69,33,111,69,10,69,420,33,69,33,111,33,33,420,10,10,420,420,111,33,33,69,33,69,33,69,33,10,69,420,33,111,33,33,10,69,111,69,33,33,69,69,33,420,33,33,69,420,69,33,69,33,33,33,33,33,33,69,69,420 ]
4712             )
4713         );
4714     }
4715 
4716     function _createDynamicArray88(uint16[88] memory fix) internal pure returns (uint256[] memory dyn) {
4717         dyn = new uint256[](88);
4718 
4719         for (uint i = 0; i < 88; i++) {
4720             dyn[i] = fix[i];
4721         }
4722 
4723         return dyn;
4724     }
4725 
4726 }