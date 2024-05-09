1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠛⢉⢉⠉⠉⠻⣿⣿⣿⣿⣿⣿
5 // ⣿⣿⣿⣿⣿⣿⣿⠟⠠⡰⣕⣗⣷⣧⣀⣅⠘⣿⣿⣿⣿⣿
6 // ⣿⣿⣿⣿⣿⣿⠃⣠⣳⣟⣿⣿⣷⣿⡿⣜⠄⣿⣿⣿⣿⣿
7 // ⣿⣿⣿⣿⡿⠁⠄⣳⢷⣿⣿⣿⣿⡿⣝⠖⠄⣿⣿⣿⣿⣿
8 // ⣿⣿⣿⣿⠃⠄⢢⡹⣿⢷⣯⢿⢷⡫⣗⠍⢰⣿⣿⣿⣿⣿
9 // ⣿⣿⣿⡏⢀⢄⠤⣁⠋⠿⣗⣟⡯⡏⢎⠁⢸⣿⣿⣿⣿⣿
10 // ⣿⣿⣿⠄⢔⢕⣯⣿⣿⡲⡤⡄⡤⠄⡀⢠⣿⣿⣿⣿⣿⣿
11 // ⣿⣿⠇⠠⡳⣯⣿⣿⣾⢵⣫⢎⢎⠆⢀⣿⣿⣿⣿⣿⣿⣿
12 // ⣿⣿⠄⢨⣫⣿⣿⡿⣿⣻⢎⡗⡕⡅⢸⣿⣿⣿⣿⣿⣿⣿
13 // ⣿⣿⠄⢜⢾⣾⣿⣿⣟⣗⢯⡪⡳⡀⢸⣿⣿⣿⣿⣿⣿⣿
14 // ⣿⣿⠄⢸⢽⣿⣷⣿⣻⡮⡧⡳⡱⡁⢸⣿⣿⣿⣿⣿⣿⣿
15 // ⣿⣿⡄⢨⣻⣽⣿⣟⣿⣞⣗⡽⡸⡐⢸⣿⣿⣿⣿⣿⣿⣿
16 // ⣿⣿⡇⢀⢗⣿⣿⣿⣿⡿⣞⡵⡣⣊⢸⣿⣿⣿⣿⣿⣿⣿
17 // ⣿⣿⣿⡀⡣⣗⣿⣿⣿⣿⣯⡯⡺⣼⠎⣿⣿⣿⣿⣿⣿⣿
18 // ⣿⣿⣿⣧⠐⡵⣻⣟⣯⣿⣷⣟⣝⢞⡿⢹⣿⣿⣿⣿⣿⣿
19 // ⣿⣿⣿⣿⡆⢘⡺⣽⢿⣻⣿⣗⡷⣹⢩⢃⢿⣿⣿⣿⣿⣿
20 // ⣿⣿⣿⣿⣷⠄⠪⣯⣟⣿⢯⣿⣻⣜⢎⢆⠜⣿⣿⣿⣿⣿
21 // ⣿⣿⣿⣿⣿⡆⠄⢣⣻⣽⣿⣿⣟⣾⡮⡺⡸⠸⣿⣿⣿⣿
22 // ⣿⣿⡿⠛⠉⠁⠄⢕⡳⣽⡾⣿⢽⣯⡿⣮⢚⣅⠹⣿⣿⣿
23 // ⡿⠋⠄⠄⠄⠄⢀⠒⠝⣞⢿⡿⣿⣽⢿⡽⣧⣳⡅⠌⠻⣿
24 // ⠁⠄⠄⠄⠄⠄⠐⡐⠱⡱⣻⡻⣝⣮⣟⣿⣻⣟⣻⡺⣊
25 //
26 //*********************************************************************//
27 //*********************************************************************//
28   
29 //-------------DEPENDENCIES--------------------------//
30 
31 // File: @openzeppelin/contracts/utils/Address.sol
32 
33 
34 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
35 
36 pragma solidity ^0.8.1;
37 
38 /**
39  * @dev Collection of functions related to the address type
40  */
41 library Address {
42     /**
43      * @dev Returns true if account is a contract.
44      *
45      * [IMPORTANT]
46      * ====
47      * It is unsafe to assume that an address for which this function returns
48      * false is an externally-owned account (EOA) and not a contract.
49      *
50      * Among others, isContract will return false for the following
51      * types of addresses:
52      *
53      *  - an externally-owned account
54      *  - a contract in construction
55      *  - an address where a contract will be created
56      *  - an address where a contract lived, but was destroyed
57      * ====
58      *
59      * [IMPORTANT]
60      * ====
61      * You shouldn't rely on isContract to protect against flash loan attacks!
62      *
63      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
64      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
65      * constructor.
66      * ====
67      */
68     function isContract(address account) internal view returns (bool) {
69         // This method relies on extcodesize/address.code.length, which returns 0
70         // for contracts in construction, since the code is only stored at the end
71         // of the constructor execution.
72 
73         return account.code.length > 0;
74     }
75 
76     /**
77      * @dev Replacement for Solidity's transfer: sends amount wei to
78      * recipient, forwarding all available gas and reverting on errors.
79      *
80      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
81      * of certain opcodes, possibly making contracts go over the 2300 gas limit
82      * imposed by transfer, making them unable to receive funds via
83      * transfer. {sendValue} removes this limitation.
84      *
85      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
86      *
87      * IMPORTANT: because control is transferred to recipient, care must be
88      * taken to not create reentrancy vulnerabilities. Consider using
89      * {ReentrancyGuard} or the
90      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
91      */
92     function sendValue(address payable recipient, uint256 amount) internal {
93         require(address(this).balance >= amount, "Address: insufficient balance");
94 
95         (bool success, ) = recipient.call{value: amount}("");
96         require(success, "Address: unable to send value, recipient may have reverted");
97     }
98 
99     /**
100      * @dev Performs a Solidity function call using a low level call. A
101      * plain call is an unsafe replacement for a function call: use this
102      * function instead.
103      *
104      * If target reverts with a revert reason, it is bubbled up by this
105      * function (like regular Solidity function calls).
106      *
107      * Returns the raw returned data. To convert to the expected return value,
108      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
109      *
110      * Requirements:
111      *
112      * - target must be a contract.
113      * - calling target with data must not revert.
114      *
115      * _Available since v3.1._
116      */
117     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
118         return functionCall(target, data, "Address: low-level call failed");
119     }
120 
121     /**
122      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
123      * errorMessage as a fallback revert reason when target reverts.
124      *
125      * _Available since v3.1._
126      */
127     function functionCall(
128         address target,
129         bytes memory data,
130         string memory errorMessage
131     ) internal returns (bytes memory) {
132         return functionCallWithValue(target, data, 0, errorMessage);
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
137      * but also transferring value wei to target.
138      *
139      * Requirements:
140      *
141      * - the calling contract must have an ETH balance of at least value.
142      * - the called Solidity function must be payable.
143      *
144      * _Available since v3.1._
145      */
146     function functionCallWithValue(
147         address target,
148         bytes memory data,
149         uint256 value
150     ) internal returns (bytes memory) {
151         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
156      * with errorMessage as a fallback revert reason when target reverts.
157      *
158      * _Available since v3.1._
159      */
160     function functionCallWithValue(
161         address target,
162         bytes memory data,
163         uint256 value,
164         string memory errorMessage
165     ) internal returns (bytes memory) {
166         require(address(this).balance >= value, "Address: insufficient balance for call");
167         require(isContract(target), "Address: call to non-contract");
168 
169         (bool success, bytes memory returndata) = target.call{value: value}(data);
170         return verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
175      * but performing a static call.
176      *
177      * _Available since v3.3._
178      */
179     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
180         return functionStaticCall(target, data, "Address: low-level static call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
185      * but performing a static call.
186      *
187      * _Available since v3.3._
188      */
189     function functionStaticCall(
190         address target,
191         bytes memory data,
192         string memory errorMessage
193     ) internal view returns (bytes memory) {
194         require(isContract(target), "Address: static call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.staticcall(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
202      * but performing a delegate call.
203      *
204      * _Available since v3.4._
205      */
206     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
207         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
212      * but performing a delegate call.
213      *
214      * _Available since v3.4._
215      */
216     function functionDelegateCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal returns (bytes memory) {
221         require(isContract(target), "Address: delegate call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.delegatecall(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
229      * revert reason using the provided one.
230      *
231      * _Available since v4.3._
232      */
233     function verifyCallResult(
234         bool success,
235         bytes memory returndata,
236         string memory errorMessage
237     ) internal pure returns (bytes memory) {
238         if (success) {
239             return returndata;
240         } else {
241             // Look for revert reason and bubble it up if present
242             if (returndata.length > 0) {
243                 // The easiest way to bubble the revert reason is using memory via assembly
244 
245                 assembly {
246                     let returndata_size := mload(returndata)
247                     revert(add(32, returndata), returndata_size)
248                 }
249             } else {
250                 revert(errorMessage);
251             }
252         }
253     }
254 }
255 
256 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @title ERC721 token receiver interface
265  * @dev Interface for any contract that wants to support safeTransfers
266  * from ERC721 asset contracts.
267  */
268 interface IERC721Receiver {
269     /**
270      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
271      * by operator from from, this function is called.
272      *
273      * It must return its Solidity selector to confirm the token transfer.
274      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
275      *
276      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
277      */
278     function onERC721Received(
279         address operator,
280         address from,
281         uint256 tokenId,
282         bytes calldata data
283     ) external returns (bytes4);
284 }
285 
286 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
287 
288 
289 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Interface of the ERC165 standard, as defined in the
295  * https://eips.ethereum.org/EIPS/eip-165[EIP].
296  *
297  * Implementers can declare support of contract interfaces, which can then be
298  * queried by others ({ERC165Checker}).
299  *
300  * For an implementation, see {ERC165}.
301  */
302 interface IERC165 {
303     /**
304      * @dev Returns true if this contract implements the interface defined by
305      * interfaceId. See the corresponding
306      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
307      * to learn more about how these ids are created.
308      *
309      * This function call must use less than 30 000 gas.
310      */
311     function supportsInterface(bytes4 interfaceId) external view returns (bool);
312 }
313 
314 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 
322 /**
323  * @dev Implementation of the {IERC165} interface.
324  *
325  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
326  * for the additional interface id that will be supported. For example:
327  *
328  * solidity
329  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
331  * }
332  * 
333  *
334  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
335  */
336 abstract contract ERC165 is IERC165 {
337     /**
338      * @dev See {IERC165-supportsInterface}.
339      */
340     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
341         return interfaceId == type(IERC165).interfaceId;
342     }
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Required interface of an ERC721 compliant contract.
355  */
356 interface IERC721 is IERC165 {
357     /**
358      * @dev Emitted when tokenId token is transferred from from to to.
359      */
360     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
361 
362     /**
363      * @dev Emitted when owner enables approved to manage the tokenId token.
364      */
365     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
366 
367     /**
368      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
369      */
370     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
371 
372     /**
373      * @dev Returns the number of tokens in owner's account.
374      */
375     function balanceOf(address owner) external view returns (uint256 balance);
376 
377     /**
378      * @dev Returns the owner of the tokenId token.
379      *
380      * Requirements:
381      *
382      * - tokenId must exist.
383      */
384     function ownerOf(uint256 tokenId) external view returns (address owner);
385 
386     /**
387      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
388      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
389      *
390      * Requirements:
391      *
392      * - from cannot be the zero address.
393      * - to cannot be the zero address.
394      * - tokenId token must exist and be owned by from.
395      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
396      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
397      *
398      * Emits a {Transfer} event.
399      */
400     function safeTransferFrom(
401         address from,
402         address to,
403         uint256 tokenId
404     ) external;
405 
406     /**
407      * @dev Transfers tokenId token from from to to.
408      *
409      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
410      *
411      * Requirements:
412      *
413      * - from cannot be the zero address.
414      * - to cannot be the zero address.
415      * - tokenId token must be owned by from.
416      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
417      *
418      * Emits a {Transfer} event.
419      */
420     function transferFrom(
421         address from,
422         address to,
423         uint256 tokenId
424     ) external;
425 
426     /**
427      * @dev Gives permission to to to transfer tokenId token to another account.
428      * The approval is cleared when the token is transferred.
429      *
430      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
431      *
432      * Requirements:
433      *
434      * - The caller must own the token or be an approved operator.
435      * - tokenId must exist.
436      *
437      * Emits an {Approval} event.
438      */
439     function approve(address to, uint256 tokenId) external;
440 
441     /**
442      * @dev Returns the account approved for tokenId token.
443      *
444      * Requirements:
445      *
446      * - tokenId must exist.
447      */
448     function getApproved(uint256 tokenId) external view returns (address operator);
449 
450     /**
451      * @dev Approve or remove operator as an operator for the caller.
452      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
453      *
454      * Requirements:
455      *
456      * - The operator cannot be the caller.
457      *
458      * Emits an {ApprovalForAll} event.
459      */
460     function setApprovalForAll(address operator, bool _approved) external;
461 
462     /**
463      * @dev Returns if the operator is allowed to manage all of the assets of owner.
464      *
465      * See {setApprovalForAll}
466      */
467     function isApprovedForAll(address owner, address operator) external view returns (bool);
468 
469     /**
470      * @dev Safely transfers tokenId token from from to to.
471      *
472      * Requirements:
473      *
474      * - from cannot be the zero address.
475      * - to cannot be the zero address.
476      * - tokenId token must exist and be owned by from.
477      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
478      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
479      *
480      * Emits a {Transfer} event.
481      */
482     function safeTransferFrom(
483         address from,
484         address to,
485         uint256 tokenId,
486         bytes calldata data
487     ) external;
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
491 
492 
493 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
500  * @dev See https://eips.ethereum.org/EIPS/eip-721
501  */
502 interface IERC721Enumerable is IERC721 {
503     /**
504      * @dev Returns the total amount of tokens stored by the contract.
505      */
506     function totalSupply() external view returns (uint256);
507 
508     /**
509      * @dev Returns a token ID owned by owner at a given index of its token list.
510      * Use along with {balanceOf} to enumerate all of owner's tokens.
511      */
512     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
513 
514     /**
515      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
516      * Use along with {totalSupply} to enumerate all tokens.
517      */
518     function tokenByIndex(uint256 index) external view returns (uint256);
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
531  * @dev See https://eips.ethereum.org/EIPS/eip-721
532  */
533 interface IERC721Metadata is IERC721 {
534     /**
535      * @dev Returns the token collection name.
536      */
537     function name() external view returns (string memory);
538 
539     /**
540      * @dev Returns the token collection symbol.
541      */
542     function symbol() external view returns (string memory);
543 
544     /**
545      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
546      */
547     function tokenURI(uint256 tokenId) external view returns (string memory);
548 }
549 
550 // File: @openzeppelin/contracts/utils/Strings.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 /**
558  * @dev String operations.
559  */
560 library Strings {
561     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
562 
563     /**
564      * @dev Converts a uint256 to its ASCII string decimal representation.
565      */
566     function toString(uint256 value) internal pure returns (string memory) {
567         // Inspired by OraclizeAPI's implementation - MIT licence
568         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
569 
570         if (value == 0) {
571             return "0";
572         }
573         uint256 temp = value;
574         uint256 digits;
575         while (temp != 0) {
576             digits++;
577             temp /= 10;
578         }
579         bytes memory buffer = new bytes(digits);
580         while (value != 0) {
581             digits -= 1;
582             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
583             value /= 10;
584         }
585         return string(buffer);
586     }
587 
588     /**
589      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
590      */
591     function toHexString(uint256 value) internal pure returns (string memory) {
592         if (value == 0) {
593             return "0x00";
594         }
595         uint256 temp = value;
596         uint256 length = 0;
597         while (temp != 0) {
598             length++;
599             temp >>= 8;
600         }
601         return toHexString(value, length);
602     }
603 
604     /**
605      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
606      */
607     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
608         bytes memory buffer = new bytes(2 * length + 2);
609         buffer[0] = "0";
610         buffer[1] = "x";
611         for (uint256 i = 2 * length + 1; i > 1; --i) {
612             buffer[i] = _HEX_SYMBOLS[value & 0xf];
613             value >>= 4;
614         }
615         require(value == 0, "Strings: hex length insufficient");
616         return string(buffer);
617     }
618 }
619 
620 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Contract module that helps prevent reentrant calls to a function.
629  *
630  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
631  * available, which can be applied to functions to make sure there are no nested
632  * (reentrant) calls to them.
633  *
634  * Note that because there is a single nonReentrant guard, functions marked as
635  * nonReentrant may not call one another. This can be worked around by making
636  * those functions private, and then adding external nonReentrant entry
637  * points to them.
638  *
639  * TIP: If you would like to learn more about reentrancy and alternative ways
640  * to protect against it, check out our blog post
641  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
642  */
643 abstract contract ReentrancyGuard {
644     // Booleans are more expensive than uint256 or any type that takes up a full
645     // word because each write operation emits an extra SLOAD to first read the
646     // slot's contents, replace the bits taken up by the boolean, and then write
647     // back. This is the compiler's defense against contract upgrades and
648     // pointer aliasing, and it cannot be disabled.
649 
650     // The values being non-zero value makes deployment a bit more expensive,
651     // but in exchange the refund on every call to nonReentrant will be lower in
652     // amount. Since refunds are capped to a percentage of the total
653     // transaction's gas, it is best to keep them low in cases like this one, to
654     // increase the likelihood of the full refund coming into effect.
655     uint256 private constant _NOT_ENTERED = 1;
656     uint256 private constant _ENTERED = 2;
657 
658     uint256 private _status;
659 
660     constructor() {
661         _status = _NOT_ENTERED;
662     }
663 
664     /**
665      * @dev Prevents a contract from calling itself, directly or indirectly.
666      * Calling a nonReentrant function from another nonReentrant
667      * function is not supported. It is possible to prevent this from happening
668      * by making the nonReentrant function external, and making it call a
669      * private function that does the actual work.
670      */
671     modifier nonReentrant() {
672         // On the first call to nonReentrant, _notEntered will be true
673         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
674 
675         // Any calls to nonReentrant after this point will fail
676         _status = _ENTERED;
677 
678         _;
679 
680         // By storing the original value once again, a refund is triggered (see
681         // https://eips.ethereum.org/EIPS/eip-2200)
682         _status = _NOT_ENTERED;
683     }
684 }
685 
686 // File: @openzeppelin/contracts/utils/Context.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 /**
694  * @dev Provides information about the current execution context, including the
695  * sender of the transaction and its data. While these are generally available
696  * via msg.sender and msg.data, they should not be accessed in such a direct
697  * manner, since when dealing with meta-transactions the account sending and
698  * paying for execution may not be the actual sender (as far as an application
699  * is concerned).
700  *
701  * This contract is only required for intermediate, library-like contracts.
702  */
703 abstract contract Context {
704     function _msgSender() internal view virtual returns (address) {
705         return msg.sender;
706     }
707 
708     function _msgData() internal view virtual returns (bytes calldata) {
709         return msg.data;
710     }
711 }
712 
713 // File: @openzeppelin/contracts/access/Ownable.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Contract module which provides a basic access control mechanism, where
723  * there is an account (an owner) that can be granted exclusive access to
724  * specific functions.
725  *
726  * By default, the owner account will be the one that deploys the contract. This
727  * can later be changed with {transferOwnership}.
728  *
729  * This module is used through inheritance. It will make available the modifier
730  * onlyOwner, which can be applied to your functions to restrict their use to
731  * the owner.
732  */
733 abstract contract Ownable is Context {
734     address private _owner;
735 
736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
737 
738     /**
739      * @dev Initializes the contract setting the deployer as the initial owner.
740      */
741     constructor() {
742         _transferOwnership(_msgSender());
743     }
744 
745     /**
746      * @dev Returns the address of the current owner.
747      */
748     function owner() public view virtual returns (address) {
749         return _owner;
750     }
751 
752     /**
753      * @dev Throws if called by any account other than the owner.
754      */
755     modifier onlyOwner() {
756         require(owner() == _msgSender(), "Ownable: caller is not the owner");
757         _;
758     }
759 
760     /**
761      * @dev Leaves the contract without owner. It will not be possible to call
762      * onlyOwner functions anymore. Can only be called by the current owner.
763      *
764      * NOTE: Renouncing ownership will leave the contract without an owner,
765      * thereby removing any functionality that is only available to the owner.
766      */
767     function renounceOwnership() public virtual onlyOwner {
768         _transferOwnership(address(0));
769     }
770 
771     /**
772      * @dev Transfers ownership of the contract to a new account (newOwner).
773      * Can only be called by the current owner.
774      */
775     function transferOwnership(address newOwner) public virtual onlyOwner {
776         require(newOwner != address(0), "Ownable: new owner is the zero address");
777         _transferOwnership(newOwner);
778     }
779 
780     /**
781      * @dev Transfers ownership of the contract to a new account (newOwner).
782      * Internal function without access restriction.
783      */
784     function _transferOwnership(address newOwner) internal virtual {
785         address oldOwner = _owner;
786         _owner = newOwner;
787         emit OwnershipTransferred(oldOwner, newOwner);
788     }
789 }
790 //-------------END DEPENDENCIES------------------------//
791 
792 
793   
794 // Rampp Contracts v2.1 (Teams.sol)
795 
796 pragma solidity ^0.8.0;
797 
798 /**
799 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
800 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
801 * This will easily allow cross-collaboration via Mintplex.xyz.
802 **/
803 abstract contract Teams is Ownable{
804   mapping (address => bool) internal team;
805 
806   /**
807   * @dev Adds an address to the team. Allows them to execute protected functions
808   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
809   **/
810   function addToTeam(address _address) public onlyOwner {
811     require(_address != address(0), "Invalid address");
812     require(!inTeam(_address), "This address is already in your team.");
813   
814     team[_address] = true;
815   }
816 
817   /**
818   * @dev Removes an address to the team.
819   * @param _address the ETH address to remove, cannot be 0x and must be in team
820   **/
821   function removeFromTeam(address _address) public onlyOwner {
822     require(_address != address(0), "Invalid address");
823     require(inTeam(_address), "This address is not in your team currently.");
824   
825     team[_address] = false;
826   }
827 
828   /**
829   * @dev Check if an address is valid and active in the team
830   * @param _address ETH address to check for truthiness
831   **/
832   function inTeam(address _address)
833     public
834     view
835     returns (bool)
836   {
837     require(_address != address(0), "Invalid address to check.");
838     return team[_address] == true;
839   }
840 
841   /**
842   * @dev Throws if called by any account other than the owner or team member.
843   */
844   modifier onlyTeamOrOwner() {
845     bool _isOwner = owner() == _msgSender();
846     bool _isTeam = inTeam(_msgSender());
847     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
848     _;
849   }
850 }
851 
852 
853   
854   
855 /**
856  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
857  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
858  *
859  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
860  * 
861  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
862  *
863  * Does not support burning tokens to address(0).
864  */
865 contract ERC721A is
866   Context,
867   ERC165,
868   IERC721,
869   IERC721Metadata,
870   IERC721Enumerable,
871   Teams
872 {
873   using Address for address;
874   using Strings for uint256;
875 
876   struct TokenOwnership {
877     address addr;
878     uint64 startTimestamp;
879   }
880 
881   struct AddressData {
882     uint128 balance;
883     uint128 numberMinted;
884   }
885 
886   uint256 private currentIndex;
887 
888   uint256 public immutable collectionSize;
889   uint256 public maxBatchSize;
890 
891   // Token name
892   string private _name;
893 
894   // Token symbol
895   string private _symbol;
896 
897   // Mapping from token ID to ownership details
898   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
899   mapping(uint256 => TokenOwnership) private _ownerships;
900 
901   // Mapping owner address to address data
902   mapping(address => AddressData) private _addressData;
903 
904   // Mapping from token ID to approved address
905   mapping(uint256 => address) private _tokenApprovals;
906 
907   // Mapping from owner to operator approvals
908   mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910   /* @dev Mapping of restricted operator approvals set by contract Owner
911   * This serves as an optional addition to ERC-721 so
912   * that the contract owner can elect to prevent specific addresses/contracts
913   * from being marked as the approver for a token. The reason for this
914   * is that some projects may want to retain control of where their tokens can/can not be listed
915   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
916   * By default, there are no restrictions. The contract owner must deliberatly block an address 
917   */
918   mapping(address => bool) public restrictedApprovalAddresses;
919 
920   /**
921    * @dev
922    * maxBatchSize refers to how much a minter can mint at a time.
923    * collectionSize_ refers to how many tokens are in the collection.
924    */
925   constructor(
926     string memory name_,
927     string memory symbol_,
928     uint256 maxBatchSize_,
929     uint256 collectionSize_
930   ) {
931     require(
932       collectionSize_ > 0,
933       "ERC721A: collection must have a nonzero supply"
934     );
935     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
936     _name = name_;
937     _symbol = symbol_;
938     maxBatchSize = maxBatchSize_;
939     collectionSize = collectionSize_;
940     currentIndex = _startTokenId();
941   }
942 
943   /**
944   * To change the starting tokenId, please override this function.
945   */
946   function _startTokenId() internal view virtual returns (uint256) {
947     return 1;
948   }
949 
950   /**
951    * @dev See {IERC721Enumerable-totalSupply}.
952    */
953   function totalSupply() public view override returns (uint256) {
954     return _totalMinted();
955   }
956 
957   function currentTokenId() public view returns (uint256) {
958     return _totalMinted();
959   }
960 
961   function getNextTokenId() public view returns (uint256) {
962       return _totalMinted() + 1;
963   }
964 
965   /**
966   * Returns the total amount of tokens minted in the contract.
967   */
968   function _totalMinted() internal view returns (uint256) {
969     unchecked {
970       return currentIndex - _startTokenId();
971     }
972   }
973 
974   /**
975    * @dev See {IERC721Enumerable-tokenByIndex}.
976    */
977   function tokenByIndex(uint256 index) public view override returns (uint256) {
978     require(index < totalSupply(), "ERC721A: global index out of bounds");
979     return index;
980   }
981 
982   /**
983    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
984    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
985    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
986    */
987   function tokenOfOwnerByIndex(address owner, uint256 index)
988     public
989     view
990     override
991     returns (uint256)
992   {
993     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
994     uint256 numMintedSoFar = totalSupply();
995     uint256 tokenIdsIdx = 0;
996     address currOwnershipAddr = address(0);
997     for (uint256 i = 0; i < numMintedSoFar; i++) {
998       TokenOwnership memory ownership = _ownerships[i];
999       if (ownership.addr != address(0)) {
1000         currOwnershipAddr = ownership.addr;
1001       }
1002       if (currOwnershipAddr == owner) {
1003         if (tokenIdsIdx == index) {
1004           return i;
1005         }
1006         tokenIdsIdx++;
1007       }
1008     }
1009     revert("ERC721A: unable to get token of owner by index");
1010   }
1011 
1012   /**
1013    * @dev See {IERC165-supportsInterface}.
1014    */
1015   function supportsInterface(bytes4 interfaceId)
1016     public
1017     view
1018     virtual
1019     override(ERC165, IERC165)
1020     returns (bool)
1021   {
1022     return
1023       interfaceId == type(IERC721).interfaceId ||
1024       interfaceId == type(IERC721Metadata).interfaceId ||
1025       interfaceId == type(IERC721Enumerable).interfaceId ||
1026       super.supportsInterface(interfaceId);
1027   }
1028 
1029   /**
1030    * @dev See {IERC721-balanceOf}.
1031    */
1032   function balanceOf(address owner) public view override returns (uint256) {
1033     require(owner != address(0), "ERC721A: balance query for the zero address");
1034     return uint256(_addressData[owner].balance);
1035   }
1036 
1037   function _numberMinted(address owner) internal view returns (uint256) {
1038     require(
1039       owner != address(0),
1040       "ERC721A: number minted query for the zero address"
1041     );
1042     return uint256(_addressData[owner].numberMinted);
1043   }
1044 
1045   function ownershipOf(uint256 tokenId)
1046     internal
1047     view
1048     returns (TokenOwnership memory)
1049   {
1050     uint256 curr = tokenId;
1051 
1052     unchecked {
1053         if (_startTokenId() <= curr && curr < currentIndex) {
1054             TokenOwnership memory ownership = _ownerships[curr];
1055             if (ownership.addr != address(0)) {
1056                 return ownership;
1057             }
1058 
1059             // Invariant:
1060             // There will always be an ownership that has an address and is not burned
1061             // before an ownership that does not have an address and is not burned.
1062             // Hence, curr will not underflow.
1063             while (true) {
1064                 curr--;
1065                 ownership = _ownerships[curr];
1066                 if (ownership.addr != address(0)) {
1067                     return ownership;
1068                 }
1069             }
1070         }
1071     }
1072 
1073     revert("ERC721A: unable to determine the owner of token");
1074   }
1075 
1076   /**
1077    * @dev See {IERC721-ownerOf}.
1078    */
1079   function ownerOf(uint256 tokenId) public view override returns (address) {
1080     return ownershipOf(tokenId).addr;
1081   }
1082 
1083   /**
1084    * @dev See {IERC721Metadata-name}.
1085    */
1086   function name() public view virtual override returns (string memory) {
1087     return _name;
1088   }
1089 
1090   /**
1091    * @dev See {IERC721Metadata-symbol}.
1092    */
1093   function symbol() public view virtual override returns (string memory) {
1094     return _symbol;
1095   }
1096 
1097   /**
1098    * @dev See {IERC721Metadata-tokenURI}.
1099    */
1100   function tokenURI(uint256 tokenId)
1101     public
1102     view
1103     virtual
1104     override
1105     returns (string memory)
1106   {
1107     string memory baseURI = _baseURI();
1108     return
1109       bytes(baseURI).length > 0
1110         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1111         : "";
1112   }
1113 
1114   /**
1115    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1116    * token will be the concatenation of the baseURI and the tokenId. Empty
1117    * by default, can be overriden in child contracts.
1118    */
1119   function _baseURI() internal view virtual returns (string memory) {
1120     return "";
1121   }
1122 
1123   /**
1124    * @dev Sets the value for an address to be in the restricted approval address pool.
1125    * Setting an address to true will disable token owners from being able to mark the address
1126    * for approval for trading. This would be used in theory to prevent token owners from listing
1127    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1128    * @param _address the marketplace/user to modify restriction status of
1129    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1130    */
1131   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1132     restrictedApprovalAddresses[_address] = _isRestricted;
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-approve}.
1137    */
1138   function approve(address to, uint256 tokenId) public override {
1139     address owner = ERC721A.ownerOf(tokenId);
1140     require(to != owner, "ERC721A: approval to current owner");
1141     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1142 
1143     require(
1144       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1145       "ERC721A: approve caller is not owner nor approved for all"
1146     );
1147 
1148     _approve(to, tokenId, owner);
1149   }
1150 
1151   /**
1152    * @dev See {IERC721-getApproved}.
1153    */
1154   function getApproved(uint256 tokenId) public view override returns (address) {
1155     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1156 
1157     return _tokenApprovals[tokenId];
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-setApprovalForAll}.
1162    */
1163   function setApprovalForAll(address operator, bool approved) public override {
1164     require(operator != _msgSender(), "ERC721A: approve to caller");
1165     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1166 
1167     _operatorApprovals[_msgSender()][operator] = approved;
1168     emit ApprovalForAll(_msgSender(), operator, approved);
1169   }
1170 
1171   /**
1172    * @dev See {IERC721-isApprovedForAll}.
1173    */
1174   function isApprovedForAll(address owner, address operator)
1175     public
1176     view
1177     virtual
1178     override
1179     returns (bool)
1180   {
1181     return _operatorApprovals[owner][operator];
1182   }
1183 
1184   /**
1185    * @dev See {IERC721-transferFrom}.
1186    */
1187   function transferFrom(
1188     address from,
1189     address to,
1190     uint256 tokenId
1191   ) public override {
1192     _transfer(from, to, tokenId);
1193   }
1194 
1195   /**
1196    * @dev See {IERC721-safeTransferFrom}.
1197    */
1198   function safeTransferFrom(
1199     address from,
1200     address to,
1201     uint256 tokenId
1202   ) public override {
1203     safeTransferFrom(from, to, tokenId, "");
1204   }
1205 
1206   /**
1207    * @dev See {IERC721-safeTransferFrom}.
1208    */
1209   function safeTransferFrom(
1210     address from,
1211     address to,
1212     uint256 tokenId,
1213     bytes memory _data
1214   ) public override {
1215     _transfer(from, to, tokenId);
1216     require(
1217       _checkOnERC721Received(from, to, tokenId, _data),
1218       "ERC721A: transfer to non ERC721Receiver implementer"
1219     );
1220   }
1221 
1222   /**
1223    * @dev Returns whether tokenId exists.
1224    *
1225    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1226    *
1227    * Tokens start existing when they are minted (_mint),
1228    */
1229   function _exists(uint256 tokenId) internal view returns (bool) {
1230     return _startTokenId() <= tokenId && tokenId < currentIndex;
1231   }
1232 
1233   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1234     _safeMint(to, quantity, isAdminMint, "");
1235   }
1236 
1237   /**
1238    * @dev Mints quantity tokens and transfers them to to.
1239    *
1240    * Requirements:
1241    *
1242    * - there must be quantity tokens remaining unminted in the total collection.
1243    * - to cannot be the zero address.
1244    * - quantity cannot be larger than the max batch size.
1245    *
1246    * Emits a {Transfer} event.
1247    */
1248   function _safeMint(
1249     address to,
1250     uint256 quantity,
1251     bool isAdminMint,
1252     bytes memory _data
1253   ) internal {
1254     uint256 startTokenId = currentIndex;
1255     require(to != address(0), "ERC721A: mint to the zero address");
1256     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1257     require(!_exists(startTokenId), "ERC721A: token already minted");
1258 
1259     // For admin mints we do not want to enforce the maxBatchSize limit
1260     if (isAdminMint == false) {
1261         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1262     }
1263 
1264     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1265 
1266     AddressData memory addressData = _addressData[to];
1267     _addressData[to] = AddressData(
1268       addressData.balance + uint128(quantity),
1269       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1270     );
1271     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1272 
1273     uint256 updatedIndex = startTokenId;
1274 
1275     for (uint256 i = 0; i < quantity; i++) {
1276       emit Transfer(address(0), to, updatedIndex);
1277       require(
1278         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1279         "ERC721A: transfer to non ERC721Receiver implementer"
1280       );
1281       updatedIndex++;
1282     }
1283 
1284     currentIndex = updatedIndex;
1285     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1286   }
1287 
1288   /**
1289    * @dev Transfers tokenId from from to to.
1290    *
1291    * Requirements:
1292    *
1293    * - to cannot be the zero address.
1294    * - tokenId token must be owned by from.
1295    *
1296    * Emits a {Transfer} event.
1297    */
1298   function _transfer(
1299     address from,
1300     address to,
1301     uint256 tokenId
1302   ) private {
1303     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1304 
1305     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1306       getApproved(tokenId) == _msgSender() ||
1307       isApprovedForAll(prevOwnership.addr, _msgSender()));
1308 
1309     require(
1310       isApprovedOrOwner,
1311       "ERC721A: transfer caller is not owner nor approved"
1312     );
1313 
1314     require(
1315       prevOwnership.addr == from,
1316       "ERC721A: transfer from incorrect owner"
1317     );
1318     require(to != address(0), "ERC721A: transfer to the zero address");
1319 
1320     _beforeTokenTransfers(from, to, tokenId, 1);
1321 
1322     // Clear approvals from the previous owner
1323     _approve(address(0), tokenId, prevOwnership.addr);
1324 
1325     _addressData[from].balance -= 1;
1326     _addressData[to].balance += 1;
1327     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1328 
1329     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1330     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1331     uint256 nextTokenId = tokenId + 1;
1332     if (_ownerships[nextTokenId].addr == address(0)) {
1333       if (_exists(nextTokenId)) {
1334         _ownerships[nextTokenId] = TokenOwnership(
1335           prevOwnership.addr,
1336           prevOwnership.startTimestamp
1337         );
1338       }
1339     }
1340 
1341     emit Transfer(from, to, tokenId);
1342     _afterTokenTransfers(from, to, tokenId, 1);
1343   }
1344 
1345   /**
1346    * @dev Approve to to operate on tokenId
1347    *
1348    * Emits a {Approval} event.
1349    */
1350   function _approve(
1351     address to,
1352     uint256 tokenId,
1353     address owner
1354   ) private {
1355     _tokenApprovals[tokenId] = to;
1356     emit Approval(owner, to, tokenId);
1357   }
1358 
1359   uint256 public nextOwnerToExplicitlySet = 0;
1360 
1361   /**
1362    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1363    */
1364   function _setOwnersExplicit(uint256 quantity) internal {
1365     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1366     require(quantity > 0, "quantity must be nonzero");
1367     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1368 
1369     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1370     if (endIndex > collectionSize - 1) {
1371       endIndex = collectionSize - 1;
1372     }
1373     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1374     require(_exists(endIndex), "not enough minted yet for this cleanup");
1375     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1376       if (_ownerships[i].addr == address(0)) {
1377         TokenOwnership memory ownership = ownershipOf(i);
1378         _ownerships[i] = TokenOwnership(
1379           ownership.addr,
1380           ownership.startTimestamp
1381         );
1382       }
1383     }
1384     nextOwnerToExplicitlySet = endIndex + 1;
1385   }
1386 
1387   /**
1388    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1389    * The call is not executed if the target address is not a contract.
1390    *
1391    * @param from address representing the previous owner of the given token ID
1392    * @param to target address that will receive the tokens
1393    * @param tokenId uint256 ID of the token to be transferred
1394    * @param _data bytes optional data to send along with the call
1395    * @return bool whether the call correctly returned the expected magic value
1396    */
1397   function _checkOnERC721Received(
1398     address from,
1399     address to,
1400     uint256 tokenId,
1401     bytes memory _data
1402   ) private returns (bool) {
1403     if (to.isContract()) {
1404       try
1405         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1406       returns (bytes4 retval) {
1407         return retval == IERC721Receiver(to).onERC721Received.selector;
1408       } catch (bytes memory reason) {
1409         if (reason.length == 0) {
1410           revert("ERC721A: transfer to non ERC721Receiver implementer");
1411         } else {
1412           assembly {
1413             revert(add(32, reason), mload(reason))
1414           }
1415         }
1416       }
1417     } else {
1418       return true;
1419     }
1420   }
1421 
1422   /**
1423    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1424    *
1425    * startTokenId - the first token id to be transferred
1426    * quantity - the amount to be transferred
1427    *
1428    * Calling conditions:
1429    *
1430    * - When from and to are both non-zero, from's tokenId will be
1431    * transferred to to.
1432    * - When from is zero, tokenId will be minted for to.
1433    */
1434   function _beforeTokenTransfers(
1435     address from,
1436     address to,
1437     uint256 startTokenId,
1438     uint256 quantity
1439   ) internal virtual {}
1440 
1441   /**
1442    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1443    * minting.
1444    *
1445    * startTokenId - the first token id to be transferred
1446    * quantity - the amount to be transferred
1447    *
1448    * Calling conditions:
1449    *
1450    * - when from and to are both non-zero.
1451    * - from and to are never both zero.
1452    */
1453   function _afterTokenTransfers(
1454     address from,
1455     address to,
1456     uint256 startTokenId,
1457     uint256 quantity
1458   ) internal virtual {}
1459 }
1460 
1461 
1462 
1463   
1464 abstract contract Ramppable {
1465   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1466 
1467   modifier isRampp() {
1468       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1469       _;
1470   }
1471 }
1472 
1473 
1474   
1475   
1476 interface IERC20 {
1477   function allowance(address owner, address spender) external view returns (uint256);
1478   function transfer(address _to, uint256 _amount) external returns (bool);
1479   function balanceOf(address account) external view returns (uint256);
1480   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1481 }
1482 
1483 // File: WithdrawableV2
1484 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1485 // ERC-20 Payouts are limited to a single payout address. This feature 
1486 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1487 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1488 abstract contract WithdrawableV2 is Teams, Ramppable {
1489   struct acceptedERC20 {
1490     bool isActive;
1491     uint256 chargeAmount;
1492   }
1493 
1494   
1495   mapping(address => acceptedERC20) private allowedTokenContracts;
1496   address[] public payableAddresses = [RAMPPADDRESS,0xEFB551E7B9fFdb53c2d8fbfD03A2b8A62A2C8872];
1497   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1498   address public erc20Payable = 0xEFB551E7B9fFdb53c2d8fbfD03A2b8A62A2C8872;
1499   uint256[] public payableFees = [5,95];
1500   uint256[] public surchargePayableFees = [100];
1501   uint256 public payableAddressCount = 2;
1502   uint256 public surchargePayableAddressCount = 1;
1503   uint256 public ramppSurchargeBalance = 0 ether;
1504   uint256 public ramppSurchargeFee = 0.001 ether;
1505   bool public onlyERC20MintingMode = false;
1506   
1507 
1508   /**
1509   * @dev Calculates the true payable balance of the contract as the
1510   * value on contract may be from ERC-20 mint surcharges and not 
1511   * public mint charges - which are not eligable for rev share & user withdrawl
1512   */
1513   function calcAvailableBalance() public view returns(uint256) {
1514     return address(this).balance - ramppSurchargeBalance;
1515   }
1516 
1517   function withdrawAll() public onlyTeamOrOwner {
1518       require(calcAvailableBalance() > 0);
1519       _withdrawAll();
1520   }
1521   
1522   function withdrawAllRampp() public isRampp {
1523       require(calcAvailableBalance() > 0);
1524       _withdrawAll();
1525   }
1526 
1527   function _withdrawAll() private {
1528       uint256 balance = calcAvailableBalance();
1529       
1530       for(uint i=0; i < payableAddressCount; i++ ) {
1531           _widthdraw(
1532               payableAddresses[i],
1533               (balance * payableFees[i]) / 100
1534           );
1535       }
1536   }
1537   
1538   function _widthdraw(address _address, uint256 _amount) private {
1539       (bool success, ) = _address.call{value: _amount}("");
1540       require(success, "Transfer failed.");
1541   }
1542 
1543   /**
1544   * @dev This function is similiar to the regular withdraw but operates only on the
1545   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1546   **/
1547   function _withdrawAllSurcharges() private {
1548     uint256 balance = ramppSurchargeBalance;
1549     if(balance == 0) { return; }
1550     
1551     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1552         _widthdraw(
1553             surchargePayableAddresses[i],
1554             (balance * surchargePayableFees[i]) / 100
1555         );
1556     }
1557     ramppSurchargeBalance = 0 ether;
1558   }
1559 
1560   /**
1561   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1562   * in the event ERC-20 tokens are paid to the contract for mints. This will
1563   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1564   * @param _tokenContract contract of ERC-20 token to withdraw
1565   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1566   */
1567   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1568     require(_amountToWithdraw > 0);
1569     IERC20 tokenContract = IERC20(_tokenContract);
1570     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1571     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1572     _withdrawAllSurcharges();
1573   }
1574 
1575   /**
1576   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1577   */
1578   function withdrawRamppSurcharges() public isRampp {
1579     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1580     _withdrawAllSurcharges();
1581   }
1582 
1583    /**
1584   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1585   */
1586   function addSurcharge() internal {
1587     ramppSurchargeBalance += ramppSurchargeFee;
1588   }
1589   
1590   /**
1591   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1592   */
1593   function hasSurcharge() internal returns(bool) {
1594     return msg.value == ramppSurchargeFee;
1595   }
1596 
1597   /**
1598   * @dev Set surcharge fee for using ERC-20 payments on contract
1599   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1600   */
1601   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1602     ramppSurchargeFee = _newSurcharge;
1603   }
1604 
1605   /**
1606   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1607   * @param _erc20TokenContract address of ERC-20 contract in question
1608   */
1609   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1610     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1611   }
1612 
1613   /**
1614   * @dev get the value of tokens to transfer for user of an ERC-20
1615   * @param _erc20TokenContract address of ERC-20 contract in question
1616   */
1617   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1618     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1619     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1620   }
1621 
1622   /**
1623   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1624   * @param _erc20TokenContract address of ERC-20 contract in question
1625   * @param _isActive default status of if contract should be allowed to accept payments
1626   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1627   */
1628   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1629     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1630     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1631   }
1632 
1633   /**
1634   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1635   * it will assume the default value of zero. This should not be used to create new payment tokens.
1636   * @param _erc20TokenContract address of ERC-20 contract in question
1637   */
1638   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1639     allowedTokenContracts[_erc20TokenContract].isActive = true;
1640   }
1641 
1642   /**
1643   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1644   * it will assume the default value of zero. This should not be used to create new payment tokens.
1645   * @param _erc20TokenContract address of ERC-20 contract in question
1646   */
1647   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1648     allowedTokenContracts[_erc20TokenContract].isActive = false;
1649   }
1650 
1651   /**
1652   * @dev Enable only ERC-20 payments for minting on this contract
1653   */
1654   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1655     onlyERC20MintingMode = true;
1656   }
1657 
1658   /**
1659   * @dev Disable only ERC-20 payments for minting on this contract
1660   */
1661   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1662     onlyERC20MintingMode = false;
1663   }
1664 
1665   /**
1666   * @dev Set the payout of the ERC-20 token payout to a specific address
1667   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1668   */
1669   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1670     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1671     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1672     erc20Payable = _newErc20Payable;
1673   }
1674 
1675   /**
1676   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1677   */
1678   function resetRamppSurchargeBalance() public isRampp {
1679     ramppSurchargeBalance = 0 ether;
1680   }
1681 
1682   /**
1683   * @dev Allows Rampp wallet to update its own reference as well as update
1684   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1685   * and since Rampp is always the first address this function is limited to the rampp payout only.
1686   * @param _newAddress updated Rampp Address
1687   */
1688   function setRamppAddress(address _newAddress) public isRampp {
1689     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1690     RAMPPADDRESS = _newAddress;
1691     payableAddresses[0] = _newAddress;
1692   }
1693 }
1694 
1695 
1696   
1697   
1698 // File: EarlyMintIncentive.sol
1699 // Allows the contract to have the first x tokens have a discount or
1700 // zero fee that can be calculated on the fly.
1701 abstract contract EarlyMintIncentive is Teams, ERC721A {
1702   uint256 public PRICE = 0.005 ether;
1703   uint256 public EARLY_MINT_PRICE = 0 ether;
1704   uint256 public earlyMintTokenIdCap = 1000;
1705   bool public usingEarlyMintIncentive = true;
1706 
1707   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1708     usingEarlyMintIncentive = true;
1709   }
1710 
1711   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1712     usingEarlyMintIncentive = false;
1713   }
1714 
1715   /**
1716   * @dev Set the max token ID in which the cost incentive will be applied.
1717   * @param _newTokenIdCap max tokenId in which incentive will be applied
1718   */
1719   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1720     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1721     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1722     earlyMintTokenIdCap = _newTokenIdCap;
1723   }
1724 
1725   /**
1726   * @dev Set the incentive mint price
1727   * @param _feeInWei new price per token when in incentive range
1728   */
1729   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1730     EARLY_MINT_PRICE = _feeInWei;
1731   }
1732 
1733   /**
1734   * @dev Set the primary mint price - the base price when not under incentive
1735   * @param _feeInWei new price per token
1736   */
1737   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1738     PRICE = _feeInWei;
1739   }
1740 
1741   function getPrice(uint256 _count) public view returns (uint256) {
1742     require(_count > 0, "Must be minting at least 1 token.");
1743 
1744     // short circuit function if we dont need to even calc incentive pricing
1745     // short circuit if the current tokenId is also already over cap
1746     if(
1747       usingEarlyMintIncentive == false ||
1748       currentTokenId() > earlyMintTokenIdCap
1749     ) {
1750       return PRICE * _count;
1751     }
1752 
1753     uint256 endingTokenId = currentTokenId() + _count;
1754     // If qty to mint results in a final token ID less than or equal to the cap then
1755     // the entire qty is within free mint.
1756     if(endingTokenId  <= earlyMintTokenIdCap) {
1757       return EARLY_MINT_PRICE * _count;
1758     }
1759 
1760     // If the current token id is less than the incentive cap
1761     // and the ending token ID is greater than the incentive cap
1762     // we will be straddling the cap so there will be some amount
1763     // that are incentive and some that are regular fee.
1764     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1765     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1766 
1767     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1768   }
1769 }
1770 
1771   
1772   
1773 abstract contract RamppERC721A is 
1774     Ownable,
1775     Teams,
1776     ERC721A,
1777     WithdrawableV2,
1778     ReentrancyGuard 
1779     , EarlyMintIncentive 
1780      
1781     
1782 {
1783   constructor(
1784     string memory tokenName,
1785     string memory tokenSymbol
1786   ) ERC721A(tokenName, tokenSymbol, 5, 5000) { }
1787     uint8 public CONTRACT_VERSION = 2;
1788     string public _baseTokenURI = "ipfs://QmdqxHCou5Uu1eeX8oea9TnYJQ1gdR2UuKTon75cQxtykD/";
1789 
1790     bool public mintingOpen = true;
1791     
1792     
1793     uint256 public MAX_WALLET_MINTS = 5;
1794 
1795   
1796     /////////////// Admin Mint Functions
1797     /**
1798      * @dev Mints a token to an address with a tokenURI.
1799      * This is owner only and allows a fee-free drop
1800      * @param _to address of the future owner of the token
1801      * @param _qty amount of tokens to drop the owner
1802      */
1803      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1804          require(_qty > 0, "Must mint at least 1 token.");
1805          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 5000");
1806          _safeMint(_to, _qty, true);
1807      }
1808 
1809   
1810     /////////////// GENERIC MINT FUNCTIONS
1811     /**
1812     * @dev Mints a single token to an address.
1813     * fee may or may not be required*
1814     * @param _to address of the future owner of the token
1815     */
1816     function mintTo(address _to) public payable {
1817         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1818         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1819         require(mintingOpen == true, "Minting is not open right now!");
1820         
1821         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1822         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1823         
1824         _safeMint(_to, 1, false);
1825     }
1826 
1827     /**
1828     * @dev Mints tokens to an address in batch.
1829     * fee may or may not be required*
1830     * @param _to address of the future owner of the token
1831     * @param _amount number of tokens to mint
1832     */
1833     function mintToMultiple(address _to, uint256 _amount) public payable {
1834         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1835         require(_amount >= 1, "Must mint at least 1 token");
1836         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1837         require(mintingOpen == true, "Minting is not open right now!");
1838         
1839         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1840         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 5000");
1841         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1842 
1843         _safeMint(_to, _amount, false);
1844     }
1845 
1846     /**
1847      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1848      * fee may or may not be required*
1849      * @param _to address of the future owner of the token
1850      * @param _amount number of tokens to mint
1851      * @param _erc20TokenContract erc-20 token contract to mint with
1852      */
1853     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1854       require(_amount >= 1, "Must mint at least 1 token");
1855       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1856       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 5000");
1857       require(mintingOpen == true, "Minting is not open right now!");
1858       
1859       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1860 
1861       // ERC-20 Specific pre-flight checks
1862       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1863       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1864       IERC20 payableToken = IERC20(_erc20TokenContract);
1865 
1866       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1867       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1868       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1869       
1870       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1871       require(transferComplete, "ERC-20 token was unable to be transferred");
1872       
1873       _safeMint(_to, _amount, false);
1874       addSurcharge();
1875     }
1876 
1877     function openMinting() public onlyTeamOrOwner {
1878         mintingOpen = true;
1879     }
1880 
1881     function stopMinting() public onlyTeamOrOwner {
1882         mintingOpen = false;
1883     }
1884 
1885   
1886 
1887   
1888     /**
1889     * @dev Check if wallet over MAX_WALLET_MINTS
1890     * @param _address address in question to check if minted count exceeds max
1891     */
1892     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1893         require(_amount >= 1, "Amount must be greater than or equal to 1");
1894         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1895     }
1896 
1897     /**
1898     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
1899     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
1900     */
1901     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
1902         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
1903         MAX_WALLET_MINTS = _newWalletMax;
1904     }
1905     
1906 
1907   
1908     /**
1909      * @dev Allows owner to set Max mints per tx
1910      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
1911      */
1912      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
1913          require(_newMaxMint >= 1, "Max mint must be at least 1");
1914          maxBatchSize = _newMaxMint;
1915      }
1916     
1917 
1918   
1919 
1920   function _baseURI() internal view virtual override returns(string memory) {
1921     return _baseTokenURI;
1922   }
1923 
1924   function baseTokenURI() public view returns(string memory) {
1925     return _baseTokenURI;
1926   }
1927 
1928   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
1929     _baseTokenURI = baseURI;
1930   }
1931 
1932   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
1933     return ownershipOf(tokenId);
1934   }
1935 }
1936 
1937 
1938   
1939 // File: contracts/VitalikPumpsContract.sol
1940 //SPDX-License-Identifier: MIT
1941 
1942 pragma solidity ^0.8.0;
1943 
1944 contract VitalikPumpsContract is RamppERC721A {
1945     constructor() RamppERC721A("Vitalik Pumps", "VTLKP"){}
1946 }
1947   
1948 //*********************************************************************//
1949 //*********************************************************************//  
1950 //                       Mintplex v2.1.0
1951 //
1952 //         This smart contract was generated by mintplex.xyz.
1953 //            Mintplex allows creators like you to launch 
1954 //             large scale NFT communities without code!
1955 //
1956 //    Mintplex is not responsible for the content of this contract and
1957 //        hopes it is being used in a responsible and kind way.  
1958 //       Mintplex is not associated or affiliated with this project.                                                    
1959 //             Twitter: @MintplexNFT ---- mintplex.xyz
1960 //*********************************************************************//                                                     
1961 //*********************************************************************// 
