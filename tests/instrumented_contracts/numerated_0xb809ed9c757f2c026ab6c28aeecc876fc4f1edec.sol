1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-15
3 */
4 
5 /*
6 oooooooooooooooooooooooooooooooooooooooooooooooooooo******************
7 oooooooooooooooooooooooooooooooooooooooooooooooooooooooo**************
8 oooooooooooooooooooooooooooooooooooooooooooooooooooooooo**************
9 oooooooooooooooooooooooooooooooooooooooooooooooooooooooo**************
10 oooooooooooooooooooooooooooooooooooooooooooooooooooooooo**************
11 OoOOoooooooooooooooooooooooooooooooooooooooooooooooooooooo************
12 OOOOOOoooooooooooooooooooooooo*******************ooooooooo************
13 OOOOOOOOooooooooooooooooooo********°******************ooooo***********
14 OOOOOOOOOOoooooooooooooooo*°********°*******************oooo**********
15 OOOOOOOOOOOoooooooooooooo*°**o*°°°°°°°°°**°************°°*ooo*********
16 OOOOOOOOOOOOOOooooooooooo*****o***°°°....°°°°°°°*°°*°****°**o*o*******
17 OOOOOOOOOOOOOOOOoooooooo*°**oooooooooo*****°°°°°°°°°°°°°°****o********
18 OOOOOOOOOOOOOOOOOoooooo***ooooooooooooooooooooooo**°°°...°°*°*********
19 OOOOOOOOOOOOOOOOOooooo****ooooooooooooooooooooooooooo***°..°°*********
20 OOOOOOOOOOOOOOOOOOOOo****oooooooooooooooooooooooooooooooo*°°.°********
21 OOOOOOOOOOOOOOOOOOOoo***oooooooooooooooooooooooooooooooooo**°.°*******
22 OOOOOOOOOOOOOOOOOOOoo***o*ooooooooooooooooooooooooooooooo***°°°°******
23 OOOOOOOOOOOOOOOOOOOooo***oooooooooooooooooooooooooooooo*****°°°°°*o***
24 OOOOOOOOOOOOOOOOOOOo***oooooooooooooooooooooooooooooooo*****°..°.*o***
25 OOOOOOOOOOOOOOOOOoo***°oooooooooooooooooooooooooooooooo*****°..°°*o***
26 OOOOOOOOOOOOOOOOo*ooo*°ooooooooooooo***oooooooooooooooo******°°°°*****
27 OOOOOOOOOOOOOOOo*o°*o**ooooooooooooo****°*oooooooooooooo******°°°*o***
28 OOOOOOOOOOOOOOOO*ooo**oooooooOOoooooooooo**ooooooooo******°****°°*o***
29 OOOOOOOOOOOOOOOOo*ooooooooooOOOoooo**°**o*o*oooooo*******°°°°***°*****
30 OOOOOOOOOOOOOOOOo°ooooooooooOOOoooooo**oo*o*oooo*********°*°*****o****
31 OOOOOOOOOOOOOOOOO****ooooooooooooooooooooooooooo*o******°°*******o****
32 OOOOOOOOOOOOOOOOOo*o*oooooooooooooooooooooooo*oo*oooo***°°*******o****
33 OOOOOOOOOOOOOOOOOO**o*oooooooooooooooooooooo**oo*oooooo**********o****
34 OOOOOOoOOOOOOOOOooOoo*ooooooooooooooooooooo***o**oooooooooo***°*o*****
35 OOOOOOoooooOOOoooooo*ooooooooooooooooooooooo*oo**ooooooo**************
36 Oooooooooooooooooooo*oooooooooooooooooooo***ooo°*oooooo**°***°*o******
37 ooooooooooooooooooo*ooooooooooooooooooooooo***°°*ooooo**°***°°********
38 ooooooooooooooooooo**ooooooooooooooooooooooooo*oooooo*******°*o*******
39 oooooooooooooooooooo*oooooooooooooooooooooooooooooooo******°**********
40 oooooooooooooooooooo***ooooooooooooooooooooo*oooooooo**°*°°°**********
41 ooooooooooooooooooooo***oooooooooooo*oo*o*********oo**°**°°***********
42 oooooooooooooooooooo******ooooooooooooo***********oo*°****************
43 oooooooooooooooooo*°°°°°°***ooooooooooooo*********oo°***°°°***********
44 ooooooooooooooooo*°°°°°*°°***oooooooooooooooooo**oo°°*°.....°*********
45 ooooooooooooooooo*o*******°°°******oooooooooooooo**°°.........°*******
46 ooooooooooooooooo*oo*oo*****°°°°*°°************°°°°.........°°°.°*****
47 oooooooooo**ooooo*********o***°°°°°°°°°°°°°°°°°°°......°°°°°°°°°°*°***
48 oooooooooooooooo*°******o**o*****°°°°°°°°°°°°°°......°°°*°°°***°°°°°°°
49 oo********oooo*oo********o*oo*******°°°°..........°°°**********°°°°°°°
50 **********oo****o***********oo**oo***°°°.......°°°°************°°°°°°°
51 */
52 // File: @openzeppelin/contracts/utils/Strings.sol
53 
54 
55 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
56 
57 pragma solidity ^0.8.0;
58 
59 /**
60  * @dev String operations.
61  */
62 library Strings {
63     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
67      */
68     function toString(uint256 value) internal pure returns (string memory) {
69         // Inspired by OraclizeAPI's implementation - MIT licence
70         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
71 
72         if (value == 0) {
73             return "0";
74         }
75         uint256 temp = value;
76         uint256 digits;
77         while (temp != 0) {
78             digits++;
79             temp /= 10;
80         }
81         bytes memory buffer = new bytes(digits);
82         while (value != 0) {
83             digits -= 1;
84             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
85             value /= 10;
86         }
87         return string(buffer);
88     }
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
92      */
93     function toHexString(uint256 value) internal pure returns (string memory) {
94         if (value == 0) {
95             return "0x00";
96         }
97         uint256 temp = value;
98         uint256 length = 0;
99         while (temp != 0) {
100             length++;
101             temp >>= 8;
102         }
103         return toHexString(value, length);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
108      */
109     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
110         bytes memory buffer = new bytes(2 * length + 2);
111         buffer[0] = "0";
112         buffer[1] = "x";
113         for (uint256 i = 2 * length + 1; i > 1; --i) {
114             buffer[i] = _HEX_SYMBOLS[value & 0xf];
115             value >>= 4;
116         }
117         require(value == 0, "Strings: hex length insufficient");
118         return string(buffer);
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Address.sol
123 
124 
125 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
126 
127 pragma solidity ^0.8.1;
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      *
150      * [IMPORTANT]
151      * ====
152      * You shouldn't rely on `isContract` to protect against flash loan attacks!
153      *
154      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
155      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
156      * constructor.
157      * ====
158      */
159     function isContract(address account) internal view returns (bool) {
160         // This method relies on extcodesize/address.code.length, which returns 0
161         // for contracts in construction, since the code is only stored at the end
162         // of the constructor execution.
163 
164         return account.code.length > 0;
165     }
166 
167     /**
168      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
169      * `recipient`, forwarding all available gas and reverting on errors.
170      *
171      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
172      * of certain opcodes, possibly making contracts go over the 2300 gas limit
173      * imposed by `transfer`, making them unable to receive funds via
174      * `transfer`. {sendValue} removes this limitation.
175      *
176      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
177      *
178      * IMPORTANT: because control is transferred to `recipient`, care must be
179      * taken to not create reentrancy vulnerabilities. Consider using
180      * {ReentrancyGuard} or the
181      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
182      */
183     function sendValue(address payable recipient, uint256 amount) internal {
184         require(address(this).balance >= amount, "Address: insufficient balance");
185 
186         (bool success, ) = recipient.call{value: amount}("");
187         require(success, "Address: unable to send value, recipient may have reverted");
188     }
189 
190     /**
191      * @dev Performs a Solidity function call using a low level `call`. A
192      * plain `call` is an unsafe replacement for a function call: use this
193      * function instead.
194      *
195      * If `target` reverts with a revert reason, it is bubbled up by this
196      * function (like regular Solidity function calls).
197      *
198      * Returns the raw returned data. To convert to the expected return value,
199      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
200      *
201      * Requirements:
202      *
203      * - `target` must be a contract.
204      * - calling `target` with `data` must not revert.
205      *
206      * _Available since v3.1._
207      */
208     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
209         return functionCall(target, data, "Address: low-level call failed");
210     }
211 
212     /**
213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
214      * `errorMessage` as a fallback revert reason when `target` reverts.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(
219         address target,
220         bytes memory data,
221         string memory errorMessage
222     ) internal returns (bytes memory) {
223         return functionCallWithValue(target, data, 0, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but also transferring `value` wei to `target`.
229      *
230      * Requirements:
231      *
232      * - the calling contract must have an ETH balance of at least `value`.
233      * - the called Solidity function must be `payable`.
234      *
235      * _Available since v3.1._
236      */
237     function functionCallWithValue(
238         address target,
239         bytes memory data,
240         uint256 value
241     ) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
247      * with `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(
252         address target,
253         bytes memory data,
254         uint256 value,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(address(this).balance >= value, "Address: insufficient balance for call");
258         require(isContract(target), "Address: call to non-contract");
259 
260         (bool success, bytes memory returndata) = target.call{value: value}(data);
261         return verifyCallResult(success, returndata, errorMessage);
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
266      * but performing a static call.
267      *
268      * _Available since v3.3._
269      */
270     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
271         return functionStaticCall(target, data, "Address: low-level static call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal view returns (bytes memory) {
285         require(isContract(target), "Address: static call to non-contract");
286 
287         (bool success, bytes memory returndata) = target.staticcall(data);
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a delegate call.
294      *
295      * _Available since v3.4._
296      */
297     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
298         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(
308         address target,
309         bytes memory data,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(isContract(target), "Address: delegate call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.delegatecall(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
320      * revert reason using the provided one.
321      *
322      * _Available since v4.3._
323      */
324     function verifyCallResult(
325         bool success,
326         bytes memory returndata,
327         string memory errorMessage
328     ) internal pure returns (bytes memory) {
329         if (success) {
330             return returndata;
331         } else {
332             // Look for revert reason and bubble it up if present
333             if (returndata.length > 0) {
334                 // The easiest way to bubble the revert reason is using memory via assembly
335 
336                 assembly {
337                     let returndata_size := mload(returndata)
338                     revert(add(32, returndata), returndata_size)
339                 }
340             } else {
341                 revert(errorMessage);
342             }
343         }
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @title ERC721 token receiver interface
356  * @dev Interface for any contract that wants to support safeTransfers
357  * from ERC721 asset contracts.
358  */
359 interface IERC721Receiver {
360     /**
361      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
362      * by `operator` from `from`, this function is called.
363      *
364      * It must return its Solidity selector to confirm the token transfer.
365      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
366      *
367      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
368      */
369     function onERC721Received(
370         address operator,
371         address from,
372         uint256 tokenId,
373         bytes calldata data
374     ) external returns (bytes4);
375 }
376 
377 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
378 
379 
380 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
381 
382 pragma solidity ^0.8.0;
383 
384 /**
385  * @dev Interface of the ERC165 standard, as defined in the
386  * https://eips.ethereum.org/EIPS/eip-165[EIP].
387  *
388  * Implementers can declare support of contract interfaces, which can then be
389  * queried by others ({ERC165Checker}).
390  *
391  * For an implementation, see {ERC165}.
392  */
393 interface IERC165 {
394     /**
395      * @dev Returns true if this contract implements the interface defined by
396      * `interfaceId`. See the corresponding
397      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
398      * to learn more about how these ids are created.
399      *
400      * This function call must use less than 30 000 gas.
401      */
402     function supportsInterface(bytes4 interfaceId) external view returns (bool);
403 }
404 
405 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
406 
407 
408 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 
413 /**
414  * @dev Implementation of the {IERC165} interface.
415  *
416  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
417  * for the additional interface id that will be supported. For example:
418  *
419  * ```solidity
420  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
421  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
422  * }
423  * ```
424  *
425  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
426  */
427 abstract contract ERC165 is IERC165 {
428     /**
429      * @dev See {IERC165-supportsInterface}.
430      */
431     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
432         return interfaceId == type(IERC165).interfaceId;
433     }
434 }
435 
436 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
437 
438 
439 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
440 
441 pragma solidity ^0.8.0;
442 
443 
444 /**
445  * @dev Required interface of an ERC721 compliant contract.
446  */
447 interface IERC721 is IERC165 {
448     /**
449      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
455      */
456     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
457 
458     /**
459      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
460      */
461     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
462 
463     /**
464      * @dev Returns the number of tokens in ``owner``'s account.
465      */
466     function balanceOf(address owner) external view returns (uint256 balance);
467 
468     /**
469      * @dev Returns the owner of the `tokenId` token.
470      *
471      * Requirements:
472      *
473      * - `tokenId` must exist.
474      */
475     function ownerOf(uint256 tokenId) external view returns (address owner);
476 
477     /**
478      * @dev Safely transfers `tokenId` token from `from` to `to`.
479      *
480      * Requirements:
481      *
482      * - `from` cannot be the zero address.
483      * - `to` cannot be the zero address.
484      * - `tokenId` token must exist and be owned by `from`.
485      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
486      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
487      *
488      * Emits a {Transfer} event.
489      */
490     function safeTransferFrom(
491         address from,
492         address to,
493         uint256 tokenId,
494         bytes calldata data
495     ) external;
496 
497     /**
498      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
499      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
500      *
501      * Requirements:
502      *
503      * - `from` cannot be the zero address.
504      * - `to` cannot be the zero address.
505      * - `tokenId` token must exist and be owned by `from`.
506      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
508      *
509      * Emits a {Transfer} event.
510      */
511     function safeTransferFrom(
512         address from,
513         address to,
514         uint256 tokenId
515     ) external;
516 
517     /**
518      * @dev Transfers `tokenId` token from `from` to `to`.
519      *
520      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      *
529      * Emits a {Transfer} event.
530      */
531     function transferFrom(
532         address from,
533         address to,
534         uint256 tokenId
535     ) external;
536 
537     /**
538      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
539      * The approval is cleared when the token is transferred.
540      *
541      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
542      *
543      * Requirements:
544      *
545      * - The caller must own the token or be an approved operator.
546      * - `tokenId` must exist.
547      *
548      * Emits an {Approval} event.
549      */
550     function approve(address to, uint256 tokenId) external;
551 
552     /**
553      * @dev Approve or remove `operator` as an operator for the caller.
554      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
555      *
556      * Requirements:
557      *
558      * - The `operator` cannot be the caller.
559      *
560      * Emits an {ApprovalForAll} event.
561      */
562     function setApprovalForAll(address operator, bool _approved) external;
563 
564     /**
565      * @dev Returns the account approved for `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function getApproved(uint256 tokenId) external view returns (address operator);
572 
573     /**
574      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
575      *
576      * See {setApprovalForAll}
577      */
578     function isApprovedForAll(address owner, address operator) external view returns (bool);
579 }
580 
581 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
582 
583 
584 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 /**
590  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
591  * @dev See https://eips.ethereum.org/EIPS/eip-721
592  */
593 interface IERC721Metadata is IERC721 {
594     /**
595      * @dev Returns the token collection name.
596      */
597     function name() external view returns (string memory);
598 
599     /**
600      * @dev Returns the token collection symbol.
601      */
602     function symbol() external view returns (string memory);
603 
604     /**
605      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
606      */
607     function tokenURI(uint256 tokenId) external view returns (string memory);
608 }
609 
610 // File: erc721a/contracts/IERC721A.sol
611 
612 
613 // ERC721A Contracts v3.3.0
614 // Creator: Chiru Labs
615 
616 pragma solidity ^0.8.4;
617 
618 
619 
620 /**
621  * @dev Interface of an ERC721A compliant contract.
622  */
623 interface IERC721A is IERC721, IERC721Metadata {
624     /**
625      * The caller must own the token or be an approved operator.
626      */
627     error ApprovalCallerNotOwnerNorApproved();
628 
629     /**
630      * The token does not exist.
631      */
632     error ApprovalQueryForNonexistentToken();
633 
634     /**
635      * The caller cannot approve to their own address.
636      */
637     error ApproveToCaller();
638 
639     /**
640      * The caller cannot approve to the current owner.
641      */
642     error ApprovalToCurrentOwner();
643 
644     /**
645      * Cannot query the balance for the zero address.
646      */
647     error BalanceQueryForZeroAddress();
648 
649     /**
650      * Cannot mint to the zero address.
651      */
652     error MintToZeroAddress();
653 
654     /**
655      * The quantity of tokens minted must be more than zero.
656      */
657     error MintZeroQuantity();
658 
659     /**
660      * The token does not exist.
661      */
662     error OwnerQueryForNonexistentToken();
663 
664     /**
665      * The caller must own the token or be an approved operator.
666      */
667     error TransferCallerNotOwnerNorApproved();
668 
669     /**
670      * The token must be owned by `from`.
671      */
672     error TransferFromIncorrectOwner();
673 
674     /**
675      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
676      */
677     error TransferToNonERC721ReceiverImplementer();
678 
679     /**
680      * Cannot transfer to the zero address.
681      */
682     error TransferToZeroAddress();
683 
684     /**
685      * The token does not exist.
686      */
687     error URIQueryForNonexistentToken();
688 
689     // Compiler will pack this into a single 256bit word.
690     struct TokenOwnership {
691         // The address of the owner.
692         address addr;
693         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
694         uint64 startTimestamp;
695         // Whether the token has been burned.
696         bool burned;
697     }
698 
699     // Compiler will pack this into a single 256bit word.
700     struct AddressData {
701         // Realistically, 2**64-1 is more than enough.
702         uint64 balance;
703         // Keeps track of mint count with minimal overhead for tokenomics.
704         uint64 numberMinted;
705         // Keeps track of burn count with minimal overhead for tokenomics.
706         uint64 numberBurned;
707         // For miscellaneous variable(s) pertaining to the address
708         // (e.g. number of whitelist mint slots used).
709         // If there are multiple variables, please pack them into a uint64.
710         uint64 aux;
711     }
712 
713     /**
714      * @dev Returns the total amount of tokens stored by the contract.
715      * 
716      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
717      */
718     function totalSupply() external view returns (uint256);
719 }
720 
721 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
722 
723 
724 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Contract module that helps prevent reentrant calls to a function.
730  *
731  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
732  * available, which can be applied to functions to make sure there are no nested
733  * (reentrant) calls to them.
734  *
735  * Note that because there is a single `nonReentrant` guard, functions marked as
736  * `nonReentrant` may not call one another. This can be worked around by making
737  * those functions `private`, and then adding `external` `nonReentrant` entry
738  * points to them.
739  *
740  * TIP: If you would like to learn more about reentrancy and alternative ways
741  * to protect against it, check out our blog post
742  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
743  */
744 abstract contract ReentrancyGuard {
745     // Booleans are more expensive than uint256 or any type that takes up a full
746     // word because each write operation emits an extra SLOAD to first read the
747     // slot's contents, replace the bits taken up by the boolean, and then write
748     // back. This is the compiler's defense against contract upgrades and
749     // pointer aliasing, and it cannot be disabled.
750 
751     // The values being non-zero value makes deployment a bit more expensive,
752     // but in exchange the refund on every call to nonReentrant will be lower in
753     // amount. Since refunds are capped to a percentage of the total
754     // transaction's gas, it is best to keep them low in cases like this one, to
755     // increase the likelihood of the full refund coming into effect.
756     uint256 private constant _NOT_ENTERED = 1;
757     uint256 private constant _ENTERED = 2;
758 
759     uint256 private _status;
760 
761     constructor() {
762         _status = _NOT_ENTERED;
763     }
764 
765     /**
766      * @dev Prevents a contract from calling itself, directly or indirectly.
767      * Calling a `nonReentrant` function from another `nonReentrant`
768      * function is not supported. It is possible to prevent this from happening
769      * by making the `nonReentrant` function external, and making it call a
770      * `private` function that does the actual work.
771      */
772     modifier nonReentrant() {
773         // On the first call to nonReentrant, _notEntered will be true
774         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
775 
776         // Any calls to nonReentrant after this point will fail
777         _status = _ENTERED;
778 
779         _;
780 
781         // By storing the original value once again, a refund is triggered (see
782         // https://eips.ethereum.org/EIPS/eip-2200)
783         _status = _NOT_ENTERED;
784     }
785 }
786 
787 // File: @openzeppelin/contracts/utils/Context.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 /**
795  * @dev Provides information about the current execution context, including the
796  * sender of the transaction and its data. While these are generally available
797  * via msg.sender and msg.data, they should not be accessed in such a direct
798  * manner, since when dealing with meta-transactions the account sending and
799  * paying for execution may not be the actual sender (as far as an application
800  * is concerned).
801  *
802  * This contract is only required for intermediate, library-like contracts.
803  */
804 abstract contract Context {
805     function _msgSender() internal view virtual returns (address) {
806         return msg.sender;
807     }
808 
809     function _msgData() internal view virtual returns (bytes calldata) {
810         return msg.data;
811     }
812 }
813 
814 // File: erc721a/contracts/ERC721A.sol
815 
816 
817 // ERC721A Contracts v3.3.0
818 // Creator: Chiru Labs
819 
820 pragma solidity ^0.8.4;
821 
822 
823 
824 
825 
826 
827 
828 /**
829  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
830  * the Metadata extension. Built to optimize for lower gas during batch mints.
831  *
832  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
833  *
834  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
835  *
836  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
837  */
838 contract ERC721A is Context, ERC165, IERC721A {
839     using Address for address;
840     using Strings for uint256;
841 
842     // The tokenId of the next token to be minted.
843     uint256 internal _currentIndex;
844 
845     // The number of tokens burned.
846     uint256 internal _burnCounter;
847 
848     // Token name
849     string private _name;
850 
851     // Token symbol
852     string private _symbol;
853 
854     // Mapping from token ID to ownership details
855     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
856     mapping(uint256 => TokenOwnership) internal _ownerships;
857 
858     // Mapping owner address to address data
859     mapping(address => AddressData) private _addressData;
860 
861     // Mapping from token ID to approved address
862     mapping(uint256 => address) private _tokenApprovals;
863 
864     // Mapping from owner to operator approvals
865     mapping(address => mapping(address => bool)) private _operatorApprovals;
866 
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870         _currentIndex = _startTokenId();
871     }
872 
873     /**
874      * To change the starting tokenId, please override this function.
875      */
876     function _startTokenId() internal view virtual returns (uint256) {
877         return 0;
878     }
879 
880     /**
881      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
882      */
883     function totalSupply() public view override returns (uint256) {
884         // Counter underflow is impossible as _burnCounter cannot be incremented
885         // more than _currentIndex - _startTokenId() times
886         unchecked {
887             return _currentIndex - _burnCounter - _startTokenId();
888         }
889     }
890 
891     /**
892      * Returns the total amount of tokens minted in the contract.
893      */
894     function _totalMinted() internal view returns (uint256) {
895         // Counter underflow is impossible as _currentIndex does not decrement,
896         // and it is initialized to _startTokenId()
897         unchecked {
898             return _currentIndex - _startTokenId();
899         }
900     }
901 
902     /**
903      * @dev See {IERC165-supportsInterface}.
904      */
905     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
906         return
907             interfaceId == type(IERC721).interfaceId ||
908             interfaceId == type(IERC721Metadata).interfaceId ||
909             super.supportsInterface(interfaceId);
910     }
911 
912     /**
913      * @dev See {IERC721-balanceOf}.
914      */
915     function balanceOf(address owner) public view override returns (uint256) {
916         if (owner == address(0)) revert BalanceQueryForZeroAddress();
917         return uint256(_addressData[owner].balance);
918     }
919 
920     /**
921      * Returns the number of tokens minted by `owner`.
922      */
923     function _numberMinted(address owner) internal view returns (uint256) {
924         return uint256(_addressData[owner].numberMinted);
925     }
926 
927     /**
928      * Returns the number of tokens burned by or on behalf of `owner`.
929      */
930     function _numberBurned(address owner) internal view returns (uint256) {
931         return uint256(_addressData[owner].numberBurned);
932     }
933 
934     /**
935      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
936      */
937     function _getAux(address owner) internal view returns (uint64) {
938         return _addressData[owner].aux;
939     }
940 
941     /**
942      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
943      * If there are multiple variables, please pack them into a uint64.
944      */
945     function _setAux(address owner, uint64 aux) internal {
946         _addressData[owner].aux = aux;
947     }
948 
949     /**
950      * Gas spent here starts off proportional to the maximum mint batch size.
951      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
952      */
953     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
954         uint256 curr = tokenId;
955 
956         unchecked {
957             if (_startTokenId() <= curr) if (curr < _currentIndex) {
958                 TokenOwnership memory ownership = _ownerships[curr];
959                 if (!ownership.burned) {
960                     if (ownership.addr != address(0)) {
961                         return ownership;
962                     }
963                     // Invariant:
964                     // There will always be an ownership that has an address and is not burned
965                     // before an ownership that does not have an address and is not burned.
966                     // Hence, curr will not underflow.
967                     while (true) {
968                         curr--;
969                         ownership = _ownerships[curr];
970                         if (ownership.addr != address(0)) {
971                             return ownership;
972                         }
973                     }
974                 }
975             }
976         }
977         revert OwnerQueryForNonexistentToken();
978     }
979 
980     /**
981      * @dev See {IERC721-ownerOf}.
982      */
983     function ownerOf(uint256 tokenId) public view override returns (address) {
984         return _ownershipOf(tokenId).addr;
985     }
986 
987     /**
988      * @dev See {IERC721Metadata-name}.
989      */
990     function name() public view virtual override returns (string memory) {
991         return _name;
992     }
993 
994     /**
995      * @dev See {IERC721Metadata-symbol}.
996      */
997     function symbol() public view virtual override returns (string memory) {
998         return _symbol;
999     }
1000 
1001     /**
1002      * @dev See {IERC721Metadata-tokenURI}.
1003      */
1004     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1005         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1006 
1007         string memory baseURI = _baseURI();
1008         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1009     }
1010 
1011     /**
1012      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1013      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1014      * by default, can be overriden in child contracts.
1015      */
1016     function _baseURI() internal view virtual returns (string memory) {
1017         return '';
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-approve}.
1022      */
1023     function approve(address to, uint256 tokenId) public override {
1024         address owner = ERC721A.ownerOf(tokenId);
1025         if (to == owner) revert ApprovalToCurrentOwner();
1026 
1027         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1028             revert ApprovalCallerNotOwnerNorApproved();
1029         }
1030 
1031         _approve(to, tokenId, owner);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-getApproved}.
1036      */
1037     function getApproved(uint256 tokenId) public view override returns (address) {
1038         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1039 
1040         return _tokenApprovals[tokenId];
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-setApprovalForAll}.
1045      */
1046     function setApprovalForAll(address operator, bool approved) public virtual override {
1047         if (operator == _msgSender()) revert ApproveToCaller();
1048 
1049         _operatorApprovals[_msgSender()][operator] = approved;
1050         emit ApprovalForAll(_msgSender(), operator, approved);
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-isApprovedForAll}.
1055      */
1056     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1057         return _operatorApprovals[owner][operator];
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-transferFrom}.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         _transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) public virtual override {
1079         safeTransferFrom(from, to, tokenId, '');
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-safeTransferFrom}.
1084      */
1085     function safeTransferFrom(
1086         address from,
1087         address to,
1088         uint256 tokenId,
1089         bytes memory _data
1090     ) public virtual override {
1091         _transfer(from, to, tokenId);
1092         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1093             revert TransferToNonERC721ReceiverImplementer();
1094         }
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted (`_mint`),
1103      */
1104     function _exists(uint256 tokenId) internal view returns (bool) {
1105         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1106     }
1107 
1108     /**
1109      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1110      */
1111     function _safeMint(address to, uint256 quantity) internal {
1112         _safeMint(to, quantity, '');
1113     }
1114 
1115     /**
1116      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - If `to` refers to a smart contract, it must implement
1121      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1122      * - `quantity` must be greater than 0.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _safeMint(
1127         address to,
1128         uint256 quantity,
1129         bytes memory _data
1130     ) internal {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1139         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1140         unchecked {
1141             _addressData[to].balance += uint64(quantity);
1142             _addressData[to].numberMinted += uint64(quantity);
1143 
1144             _ownerships[startTokenId].addr = to;
1145             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1146 
1147             uint256 updatedIndex = startTokenId;
1148             uint256 end = updatedIndex + quantity;
1149 
1150             if (to.isContract()) {
1151                 do {
1152                     emit Transfer(address(0), to, updatedIndex);
1153                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1154                         revert TransferToNonERC721ReceiverImplementer();
1155                     }
1156                 } while (updatedIndex < end);
1157                 // Reentrancy protection
1158                 if (_currentIndex != startTokenId) revert();
1159             } else {
1160                 do {
1161                     emit Transfer(address(0), to, updatedIndex++);
1162                 } while (updatedIndex < end);
1163             }
1164             _currentIndex = updatedIndex;
1165         }
1166         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1167     }
1168 
1169     /**
1170      * @dev Mints `quantity` tokens and transfers them to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `to` cannot be the zero address.
1175      * - `quantity` must be greater than 0.
1176      *
1177      * Emits a {Transfer} event.
1178      */
1179     function _mint(address to, uint256 quantity) internal {
1180         uint256 startTokenId = _currentIndex;
1181         if (to == address(0)) revert MintToZeroAddress();
1182         if (quantity == 0) revert MintZeroQuantity();
1183 
1184         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1185 
1186         // Overflows are incredibly unrealistic.
1187         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1188         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1189         unchecked {
1190             _addressData[to].balance += uint64(quantity);
1191             _addressData[to].numberMinted += uint64(quantity);
1192 
1193             _ownerships[startTokenId].addr = to;
1194             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1195 
1196             uint256 updatedIndex = startTokenId;
1197             uint256 end = updatedIndex + quantity;
1198 
1199             do {
1200                 emit Transfer(address(0), to, updatedIndex++);
1201             } while (updatedIndex < end);
1202 
1203             _currentIndex = updatedIndex;
1204         }
1205         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1206     }
1207 
1208     /**
1209      * @dev Transfers `tokenId` from `from` to `to`.
1210      *
1211      * Requirements:
1212      *
1213      * - `to` cannot be the zero address.
1214      * - `tokenId` token must be owned by `from`.
1215      *
1216      * Emits a {Transfer} event.
1217      */
1218     function _transfer(
1219         address from,
1220         address to,
1221         uint256 tokenId
1222     ) private {
1223         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1224 
1225         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1226 
1227         bool isApprovedOrOwner = (_msgSender() == from ||
1228             isApprovedForAll(from, _msgSender()) ||
1229             getApproved(tokenId) == _msgSender());
1230 
1231         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1232         if (to == address(0)) revert TransferToZeroAddress();
1233 
1234         _beforeTokenTransfers(from, to, tokenId, 1);
1235 
1236         // Clear approvals from the previous owner
1237         _approve(address(0), tokenId, from);
1238 
1239         // Underflow of the sender's balance is impossible because we check for
1240         // ownership above and the recipient's balance can't realistically overflow.
1241         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1242         unchecked {
1243             _addressData[from].balance -= 1;
1244             _addressData[to].balance += 1;
1245 
1246             TokenOwnership storage currSlot = _ownerships[tokenId];
1247             currSlot.addr = to;
1248             currSlot.startTimestamp = uint64(block.timestamp);
1249 
1250             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1251             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1252             uint256 nextTokenId = tokenId + 1;
1253             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1254             if (nextSlot.addr == address(0)) {
1255                 // This will suffice for checking _exists(nextTokenId),
1256                 // as a burned slot cannot contain the zero address.
1257                 if (nextTokenId != _currentIndex) {
1258                     nextSlot.addr = from;
1259                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1260                 }
1261             }
1262         }
1263 
1264         emit Transfer(from, to, tokenId);
1265         _afterTokenTransfers(from, to, tokenId, 1);
1266     }
1267 
1268     /**
1269      * @dev Equivalent to `_burn(tokenId, false)`.
1270      */
1271     function _burn(uint256 tokenId) internal virtual {
1272         _burn(tokenId, false);
1273     }
1274 
1275     /**
1276      * @dev Destroys `tokenId`.
1277      * The approval is cleared when the token is burned.
1278      *
1279      * Requirements:
1280      *
1281      * - `tokenId` must exist.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1286         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1287 
1288         address from = prevOwnership.addr;
1289 
1290         if (approvalCheck) {
1291             bool isApprovedOrOwner = (_msgSender() == from ||
1292                 isApprovedForAll(from, _msgSender()) ||
1293                 getApproved(tokenId) == _msgSender());
1294 
1295             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1296         }
1297 
1298         _beforeTokenTransfers(from, address(0), tokenId, 1);
1299 
1300         // Clear approvals from the previous owner
1301         _approve(address(0), tokenId, from);
1302 
1303         // Underflow of the sender's balance is impossible because we check for
1304         // ownership above and the recipient's balance can't realistically overflow.
1305         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1306         unchecked {
1307             AddressData storage addressData = _addressData[from];
1308             addressData.balance -= 1;
1309             addressData.numberBurned += 1;
1310 
1311             // Keep track of who burned the token, and the timestamp of burning.
1312             TokenOwnership storage currSlot = _ownerships[tokenId];
1313             currSlot.addr = from;
1314             currSlot.startTimestamp = uint64(block.timestamp);
1315             currSlot.burned = true;
1316 
1317             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1318             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1319             uint256 nextTokenId = tokenId + 1;
1320             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1321             if (nextSlot.addr == address(0)) {
1322                 // This will suffice for checking _exists(nextTokenId),
1323                 // as a burned slot cannot contain the zero address.
1324                 if (nextTokenId != _currentIndex) {
1325                     nextSlot.addr = from;
1326                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1327                 }
1328             }
1329         }
1330 
1331         emit Transfer(from, address(0), tokenId);
1332         _afterTokenTransfers(from, address(0), tokenId, 1);
1333 
1334         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1335         unchecked {
1336             _burnCounter++;
1337         }
1338     }
1339 
1340     /**
1341      * @dev Approve `to` to operate on `tokenId`
1342      *
1343      * Emits a {Approval} event.
1344      */
1345     function _approve(
1346         address to,
1347         uint256 tokenId,
1348         address owner
1349     ) private {
1350         _tokenApprovals[tokenId] = to;
1351         emit Approval(owner, to, tokenId);
1352     }
1353 
1354     /**
1355      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1356      *
1357      * @param from address representing the previous owner of the given token ID
1358      * @param to target address that will receive the tokens
1359      * @param tokenId uint256 ID of the token to be transferred
1360      * @param _data bytes optional data to send along with the call
1361      * @return bool whether the call correctly returned the expected magic value
1362      */
1363     function _checkContractOnERC721Received(
1364         address from,
1365         address to,
1366         uint256 tokenId,
1367         bytes memory _data
1368     ) private returns (bool) {
1369         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1370             return retval == IERC721Receiver(to).onERC721Received.selector;
1371         } catch (bytes memory reason) {
1372             if (reason.length == 0) {
1373                 revert TransferToNonERC721ReceiverImplementer();
1374             } else {
1375                 assembly {
1376                     revert(add(32, reason), mload(reason))
1377                 }
1378             }
1379         }
1380     }
1381 
1382     /**
1383      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1384      * And also called before burning one token.
1385      *
1386      * startTokenId - the first token id to be transferred
1387      * quantity - the amount to be transferred
1388      *
1389      * Calling conditions:
1390      *
1391      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1392      * transferred to `to`.
1393      * - When `from` is zero, `tokenId` will be minted for `to`.
1394      * - When `to` is zero, `tokenId` will be burned by `from`.
1395      * - `from` and `to` are never both zero.
1396      */
1397     function _beforeTokenTransfers(
1398         address from,
1399         address to,
1400         uint256 startTokenId,
1401         uint256 quantity
1402     ) internal virtual {}
1403 
1404     /**
1405      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1406      * minting.
1407      * And also called after one token has been burned.
1408      *
1409      * startTokenId - the first token id to be transferred
1410      * quantity - the amount to be transferred
1411      *
1412      * Calling conditions:
1413      *
1414      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1415      * transferred to `to`.
1416      * - When `from` is zero, `tokenId` has been minted for `to`.
1417      * - When `to` is zero, `tokenId` has been burned by `from`.
1418      * - `from` and `to` are never both zero.
1419      */
1420     function _afterTokenTransfers(
1421         address from,
1422         address to,
1423         uint256 startTokenId,
1424         uint256 quantity
1425     ) internal virtual {}
1426 }
1427 
1428 // File: @openzeppelin/contracts/access/Ownable.sol
1429 
1430 
1431 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1432 
1433 pragma solidity ^0.8.0;
1434 
1435 
1436 /**
1437  * @dev Contract module which provides a basic access control mechanism, where
1438  * there is an account (an owner) that can be granted exclusive access to
1439  * specific functions.
1440  *
1441  * By default, the owner account will be the one that deploys the contract. This
1442  * can later be changed with {transferOwnership}.
1443  *
1444  * This module is used through inheritance. It will make available the modifier
1445  * `onlyOwner`, which can be applied to your functions to restrict their use to
1446  * the owner.
1447  */
1448 abstract contract Ownable is Context {
1449     address private _owner;
1450 
1451     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1452 
1453     /**
1454      * @dev Initializes the contract setting the deployer as the initial owner.
1455      */
1456     constructor() {
1457         _transferOwnership(_msgSender());
1458     }
1459 
1460     /**
1461      * @dev Returns the address of the current owner.
1462      */
1463     function owner() public view virtual returns (address) {
1464         return _owner;
1465     }
1466 
1467     /**
1468      * @dev Throws if called by any account other than the owner.
1469      */
1470     modifier onlyOwner() {
1471         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1472         _;
1473     }
1474 
1475     /**
1476      * @dev Leaves the contract without owner. It will not be possible to call
1477      * `onlyOwner` functions anymore. Can only be called by the current owner.
1478      *
1479      * NOTE: Renouncing ownership will leave the contract without an owner,
1480      * thereby removing any functionality that is only available to the owner.
1481      */
1482     function renounceOwnership() public virtual onlyOwner {
1483         _transferOwnership(address(0));
1484     }
1485 
1486     /**
1487      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1488      * Can only be called by the current owner.
1489      */
1490     function transferOwnership(address newOwner) public virtual onlyOwner {
1491         require(newOwner != address(0), "Ownable: new owner is the zero address");
1492         _transferOwnership(newOwner);
1493     }
1494 
1495     /**
1496      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1497      * Internal function without access restriction.
1498      */
1499     function _transferOwnership(address newOwner) internal virtual {
1500         address oldOwner = _owner;
1501         _owner = newOwner;
1502         emit OwnershipTransferred(oldOwner, newOwner);
1503     }
1504 }
1505 
1506 // File: wdy.sol
1507 
1508 pragma solidity ^0.8.0;
1509 
1510 
1511 
1512 
1513 
1514 contract WeDrewYou is Ownable, ERC721A, ReentrancyGuard {
1515     uint256 public collectionSize=4200;
1516     uint256 public maxPerAddressDuringMint=5;
1517   constructor() ERC721A("WeDrewYou", "WDY") {}
1518 
1519   function mint(uint256 quantity)
1520     external
1521   {
1522     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1523     require(
1524       numberMinted(msg.sender) + quantity <= maxPerAddressDuringMint,
1525       "can not mint this many"
1526     );
1527     _safeMint(msg.sender, quantity);
1528   }
1529 
1530   // // metadata URI
1531   string private _baseTokenURI;
1532 
1533   function _baseURI() internal view virtual override returns (string memory) {
1534     return _baseTokenURI;
1535   }
1536 
1537   function setBaseURI(string calldata baseURI) external onlyOwner {
1538     _baseTokenURI = baseURI;
1539   }
1540 
1541   function withdrawMoney() external onlyOwner nonReentrant {
1542     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1543     require(success, "Transfer failed.");
1544   }
1545 
1546   function numberMinted(address owner) public view returns (uint256) {
1547     return _numberMinted(owner);
1548   }
1549 }