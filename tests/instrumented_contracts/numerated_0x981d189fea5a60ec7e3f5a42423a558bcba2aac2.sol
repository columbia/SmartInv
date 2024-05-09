1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //           _____                    _____                    _____                    _____                    _____                _____                    _____          
5 //          /\    \                  /\    \                  /\    \                  /\    \                  /\    \              /\    \                  /\    \         
6 //         /::\____\                /::\    \                /::\    \                /::\    \                /::\    \            /::\    \                /::\    \        
7 //        /::::|   |                \:::\    \              /::::\    \              /::::\    \               \:::\    \           \:::\    \              /::::\    \       
8 //       /:::::|   |                 \:::\    \            /::::::\    \            /::::::\    \               \:::\    \           \:::\    \            /::::::\    \      
9 //      /::::::|   |                  \:::\    \          /:::/\:::\    \          /:::/\:::\    \               \:::\    \           \:::\    \          /:::/\:::\    \     
10 //     /:::/|::|   |                   \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \               \:::\    \           \:::\    \        /:::/__\:::\    \    
11 //    /:::/ |::|   |                   /::::\    \       \:::\   \:::\    \      /::::\   \:::\    \              /::::\    \          /::::\    \       \:::\   \:::\    \   
12 //   /:::/  |::|___|______    ____    /::::::\    \    ___\:::\   \:::\    \    /::::::\   \:::\    \    ____    /::::::\    \        /::::::\    \    ___\:::\   \:::\    \  
13 //  /:::/   |::::::::\    \  /\   \  /:::/\:::\    \  /\   \:::\   \:::\    \  /:::/\:::\   \:::\    \  /\   \  /:::/\:::\    \      /:::/\:::\    \  /\   \:::\   \:::\    \ 
14 // /:::/    |:::::::::\____\/::\   \/:::/  \:::\____\/::\   \:::\   \:::\____\/:::/  \:::\   \:::\____\/::\   \/:::/  \:::\____\    /:::/  \:::\____\/::\   \:::\   \:::\____\
15 // \::/    / ~~~~~/:::/    /\:::\  /:::/    \::/    /\:::\   \:::\   \::/    /\::/    \:::\   \::/    /\:::\  /:::/    \::/    /   /:::/    \::/    /\:::\   \:::\   \::/    /
16 //  \/____/      /:::/    /  \:::\/:::/    / \/____/  \:::\   \:::\   \/____/  \/____/ \:::\   \/____/  \:::\/:::/    / \/____/   /:::/    / \/____/  \:::\   \:::\   \/____/ 
17 //              /:::/    /    \::::::/    /            \:::\   \:::\    \               \:::\    \       \::::::/    /           /:::/    /            \:::\   \:::\    \     
18 //             /:::/    /      \::::/____/              \:::\   \:::\____\               \:::\____\       \::::/____/           /:::/    /              \:::\   \:::\____\    
19 //            /:::/    /        \:::\    \               \:::\  /:::/    /                \::/    /        \:::\    \           \::/    /                \:::\  /:::/    /    
20 //           /:::/    /          \:::\    \               \:::\/:::/    /                  \/____/          \:::\    \           \/____/                  \:::\/:::/    /     
21 //          /:::/    /            \:::\    \               \::::::/    /                                     \:::\    \                                    \::::::/    /      
22 //         /:::/    /              \:::\____\               \::::/    /                                       \:::\____\                                    \::::/    /       
23 //         \::/    /                \::/    /                \::/    /                                         \::/    /                                     \::/    /        
24 //          \/____/                  \/____/                  \/____/                                           \/____/                                       \/____/         
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
755     function _onlyOwner() private view {
756        require(owner() == _msgSender(), "Ownable: caller is not the owner");
757     }
758 
759     modifier onlyOwner() {
760         _onlyOwner();
761         _;
762     }
763 
764     /**
765      * @dev Leaves the contract without owner. It will not be possible to call
766      * onlyOwner functions anymore. Can only be called by the current owner.
767      *
768      * NOTE: Renouncing ownership will leave the contract without an owner,
769      * thereby removing any functionality that is only available to the owner.
770      */
771     function renounceOwnership() public virtual onlyOwner {
772         _transferOwnership(address(0));
773     }
774 
775     /**
776      * @dev Transfers ownership of the contract to a new account (newOwner).
777      * Can only be called by the current owner.
778      */
779     function transferOwnership(address newOwner) public virtual onlyOwner {
780         require(newOwner != address(0), "Ownable: new owner is the zero address");
781         _transferOwnership(newOwner);
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (newOwner).
786      * Internal function without access restriction.
787      */
788     function _transferOwnership(address newOwner) internal virtual {
789         address oldOwner = _owner;
790         _owner = newOwner;
791         emit OwnershipTransferred(oldOwner, newOwner);
792     }
793 }
794 
795 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
796 pragma solidity ^0.8.9;
797 
798 interface IOperatorFilterRegistry {
799     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
800     function register(address registrant) external;
801     function registerAndSubscribe(address registrant, address subscription) external;
802     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
803     function updateOperator(address registrant, address operator, bool filtered) external;
804     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
805     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
806     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
807     function subscribe(address registrant, address registrantToSubscribe) external;
808     function unsubscribe(address registrant, bool copyExistingEntries) external;
809     function subscriptionOf(address addr) external returns (address registrant);
810     function subscribers(address registrant) external returns (address[] memory);
811     function subscriberAt(address registrant, uint256 index) external returns (address);
812     function copyEntriesOf(address registrant, address registrantToCopy) external;
813     function isOperatorFiltered(address registrant, address operator) external returns (bool);
814     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
815     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
816     function filteredOperators(address addr) external returns (address[] memory);
817     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
818     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
819     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
820     function isRegistered(address addr) external returns (bool);
821     function codeHashOf(address addr) external returns (bytes32);
822 }
823 
824 // File contracts/OperatorFilter/OperatorFilterer.sol
825 pragma solidity ^0.8.9;
826 
827 abstract contract OperatorFilterer {
828     error OperatorNotAllowed(address operator);
829 
830     IOperatorFilterRegistry constant operatorFilterRegistry =
831         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
832 
833     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
834         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
835         // will not revert, but the contract will need to be registered with the registry once it is deployed in
836         // order for the modifier to filter addresses.
837         if (address(operatorFilterRegistry).code.length > 0) {
838             if (subscribe) {
839                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
840             } else {
841                 if (subscriptionOrRegistrantToCopy != address(0)) {
842                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
843                 } else {
844                     operatorFilterRegistry.register(address(this));
845                 }
846             }
847         }
848     }
849 
850     function _onlyAllowedOperator(address from) private view {
851       if (
852           !(
853               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
854               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
855           )
856       ) {
857           revert OperatorNotAllowed(msg.sender);
858       }
859     }
860 
861     modifier onlyAllowedOperator(address from) virtual {
862         // Check registry code length to facilitate testing in environments without a deployed registry.
863         if (address(operatorFilterRegistry).code.length > 0) {
864             // Allow spending tokens from addresses with balance
865             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
866             // from an EOA.
867             if (from == msg.sender) {
868                 _;
869                 return;
870             }
871             _onlyAllowedOperator(from);
872         }
873         _;
874     }
875 
876     modifier onlyAllowedOperatorApproval(address operator) virtual {
877         _checkFilterOperator(operator);
878         _;
879     }
880 
881     function _checkFilterOperator(address operator) internal view virtual {
882         // Check registry code length to facilitate testing in environments without a deployed registry.
883         if (address(operatorFilterRegistry).code.length > 0) {
884             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
885                 revert OperatorNotAllowed(operator);
886             }
887         }
888     }
889 }
890 
891 //-------------END DEPENDENCIES------------------------//
892 
893 
894   
895 error TransactionCapExceeded();
896 error PublicMintingClosed();
897 error ExcessiveOwnedMints();
898 error MintZeroQuantity();
899 error InvalidPayment();
900 error CapExceeded();
901 error IsAlreadyUnveiled();
902 error ValueCannotBeZero();
903 error CannotBeNullAddress();
904 error NoStateChange();
905 
906 error PublicMintClosed();
907 error AllowlistMintClosed();
908 
909 error AddressNotAllowlisted();
910 error AllowlistDropTimeHasNotPassed();
911 error PublicDropTimeHasNotPassed();
912 error DropTimeNotInFuture();
913 
914 error OnlyERC20MintingEnabled();
915 error ERC20TokenNotApproved();
916 error ERC20InsufficientBalance();
917 error ERC20InsufficientAllowance();
918 error ERC20TransferFailed();
919 
920 error ClaimModeDisabled();
921 error IneligibleRedemptionContract();
922 error TokenAlreadyRedeemed();
923 error InvalidOwnerForRedemption();
924 error InvalidApprovalForRedemption();
925 
926 error ERC721RestrictedApprovalAddressRestricted();
927   
928   
929 // Rampp Contracts v2.1 (Teams.sol)
930 
931 error InvalidTeamAddress();
932 error DuplicateTeamAddress();
933 pragma solidity ^0.8.0;
934 
935 /**
936 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
937 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
938 * This will easily allow cross-collaboration via Mintplex.xyz.
939 **/
940 abstract contract Teams is Ownable{
941   mapping (address => bool) internal team;
942 
943   /**
944   * @dev Adds an address to the team. Allows them to execute protected functions
945   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
946   **/
947   function addToTeam(address _address) public onlyOwner {
948     if(_address == address(0)) revert InvalidTeamAddress();
949     if(inTeam(_address)) revert DuplicateTeamAddress();
950   
951     team[_address] = true;
952   }
953 
954   /**
955   * @dev Removes an address to the team.
956   * @param _address the ETH address to remove, cannot be 0x and must be in team
957   **/
958   function removeFromTeam(address _address) public onlyOwner {
959     if(_address == address(0)) revert InvalidTeamAddress();
960     if(!inTeam(_address)) revert InvalidTeamAddress();
961   
962     team[_address] = false;
963   }
964 
965   /**
966   * @dev Check if an address is valid and active in the team
967   * @param _address ETH address to check for truthiness
968   **/
969   function inTeam(address _address)
970     public
971     view
972     returns (bool)
973   {
974     if(_address == address(0)) revert InvalidTeamAddress();
975     return team[_address] == true;
976   }
977 
978   /**
979   * @dev Throws if called by any account other than the owner or team member.
980   */
981   function _onlyTeamOrOwner() private view {
982     bool _isOwner = owner() == _msgSender();
983     bool _isTeam = inTeam(_msgSender());
984     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
985   }
986 
987   modifier onlyTeamOrOwner() {
988     _onlyTeamOrOwner();
989     _;
990   }
991 }
992 
993 
994   
995   pragma solidity ^0.8.0;
996 
997   /**
998   * @dev These functions deal with verification of Merkle Trees proofs.
999   *
1000   * The proofs can be generated using the JavaScript library
1001   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1002   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1003   *
1004   *
1005   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1006   * hashing, or use a hash function other than keccak256 for hashing leaves.
1007   * This is because the concatenation of a sorted pair of internal nodes in
1008   * the merkle tree could be reinterpreted as a leaf value.
1009   */
1010   library MerkleProof {
1011       /**
1012       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1013       * defined by 'root'. For this, a 'proof' must be provided, containing
1014       * sibling hashes on the branch from the leaf to the root of the tree. Each
1015       * pair of leaves and each pair of pre-images are assumed to be sorted.
1016       */
1017       function verify(
1018           bytes32[] memory proof,
1019           bytes32 root,
1020           bytes32 leaf
1021       ) internal pure returns (bool) {
1022           return processProof(proof, leaf) == root;
1023       }
1024 
1025       /**
1026       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1027       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1028       * hash matches the root of the tree. When processing the proof, the pairs
1029       * of leafs & pre-images are assumed to be sorted.
1030       *
1031       * _Available since v4.4._
1032       */
1033       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1034           bytes32 computedHash = leaf;
1035           for (uint256 i = 0; i < proof.length; i++) {
1036               bytes32 proofElement = proof[i];
1037               if (computedHash <= proofElement) {
1038                   // Hash(current computed hash + current element of the proof)
1039                   computedHash = _efficientHash(computedHash, proofElement);
1040               } else {
1041                   // Hash(current element of the proof + current computed hash)
1042                   computedHash = _efficientHash(proofElement, computedHash);
1043               }
1044           }
1045           return computedHash;
1046       }
1047 
1048       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1049           assembly {
1050               mstore(0x00, a)
1051               mstore(0x20, b)
1052               value := keccak256(0x00, 0x40)
1053           }
1054       }
1055   }
1056 
1057 
1058   // File: Allowlist.sol
1059 
1060   pragma solidity ^0.8.0;
1061 
1062   abstract contract Allowlist is Teams {
1063     bytes32 public merkleRoot;
1064     bool public onlyAllowlistMode = false;
1065 
1066     /**
1067      * @dev Update merkle root to reflect changes in Allowlist
1068      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1069      */
1070     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
1071       if(_newMerkleRoot == merkleRoot) revert NoStateChange();
1072       merkleRoot = _newMerkleRoot;
1073     }
1074 
1075     /**
1076      * @dev Check the proof of an address if valid for merkle root
1077      * @param _to address to check for proof
1078      * @param _merkleProof Proof of the address to validate against root and leaf
1079      */
1080     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
1081       if(merkleRoot == 0) revert ValueCannotBeZero();
1082       bytes32 leaf = keccak256(abi.encodePacked(_to));
1083 
1084       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1085     }
1086 
1087     
1088     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
1089       onlyAllowlistMode = true;
1090     }
1091 
1092     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
1093         onlyAllowlistMode = false;
1094     }
1095   }
1096   
1097   
1098 /**
1099  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1100  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1101  *
1102  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1103  * 
1104  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1105  *
1106  * Does not support burning tokens to address(0).
1107  */
1108 contract ERC721A is
1109   Context,
1110   ERC165,
1111   IERC721,
1112   IERC721Metadata,
1113   IERC721Enumerable,
1114   Teams
1115   , OperatorFilterer
1116 {
1117   using Address for address;
1118   using Strings for uint256;
1119 
1120   struct TokenOwnership {
1121     address addr;
1122     uint64 startTimestamp;
1123   }
1124 
1125   struct AddressData {
1126     uint128 balance;
1127     uint128 numberMinted;
1128   }
1129 
1130   uint256 private currentIndex;
1131 
1132   uint256 public immutable collectionSize;
1133   uint256 public maxBatchSize;
1134 
1135   // Token name
1136   string private _name;
1137 
1138   // Token symbol
1139   string private _symbol;
1140 
1141   // Mapping from token ID to ownership details
1142   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1143   mapping(uint256 => TokenOwnership) private _ownerships;
1144 
1145   // Mapping owner address to address data
1146   mapping(address => AddressData) private _addressData;
1147 
1148   // Mapping from token ID to approved address
1149   mapping(uint256 => address) private _tokenApprovals;
1150 
1151   // Mapping from owner to operator approvals
1152   mapping(address => mapping(address => bool)) private _operatorApprovals;
1153 
1154   /* @dev Mapping of restricted operator approvals set by contract Owner
1155   * This serves as an optional addition to ERC-721 so
1156   * that the contract owner can elect to prevent specific addresses/contracts
1157   * from being marked as the approver for a token. The reason for this
1158   * is that some projects may want to retain control of where their tokens can/can not be listed
1159   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1160   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1161   */
1162   mapping(address => bool) public restrictedApprovalAddresses;
1163 
1164   /**
1165    * @dev
1166    * maxBatchSize refers to how much a minter can mint at a time.
1167    * collectionSize_ refers to how many tokens are in the collection.
1168    */
1169   constructor(
1170     string memory name_,
1171     string memory symbol_,
1172     uint256 maxBatchSize_,
1173     uint256 collectionSize_
1174   ) OperatorFilterer(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6, true) {
1175     require(
1176       collectionSize_ > 0,
1177       "ERC721A: collection must have a nonzero supply"
1178     );
1179     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1180     _name = name_;
1181     _symbol = symbol_;
1182     maxBatchSize = maxBatchSize_;
1183     collectionSize = collectionSize_;
1184     currentIndex = _startTokenId();
1185   }
1186 
1187   /**
1188   * To change the starting tokenId, please override this function.
1189   */
1190   function _startTokenId() internal view virtual returns (uint256) {
1191     return 1;
1192   }
1193 
1194   /**
1195    * @dev See {IERC721Enumerable-totalSupply}.
1196    */
1197   function totalSupply() public view override returns (uint256) {
1198     return _totalMinted();
1199   }
1200 
1201   function currentTokenId() public view returns (uint256) {
1202     return _totalMinted();
1203   }
1204 
1205   function getNextTokenId() public view returns (uint256) {
1206       return _totalMinted() + 1;
1207   }
1208 
1209   /**
1210   * Returns the total amount of tokens minted in the contract.
1211   */
1212   function _totalMinted() internal view returns (uint256) {
1213     unchecked {
1214       return currentIndex - _startTokenId();
1215     }
1216   }
1217 
1218   /**
1219    * @dev See {IERC721Enumerable-tokenByIndex}.
1220    */
1221   function tokenByIndex(uint256 index) public view override returns (uint256) {
1222     require(index < totalSupply(), "ERC721A: global index out of bounds");
1223     return index;
1224   }
1225 
1226   /**
1227    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1228    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1229    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1230    */
1231   function tokenOfOwnerByIndex(address owner, uint256 index)
1232     public
1233     view
1234     override
1235     returns (uint256)
1236   {
1237     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1238     uint256 numMintedSoFar = totalSupply();
1239     uint256 tokenIdsIdx = 0;
1240     address currOwnershipAddr = address(0);
1241     for (uint256 i = 0; i < numMintedSoFar; i++) {
1242       TokenOwnership memory ownership = _ownerships[i];
1243       if (ownership.addr != address(0)) {
1244         currOwnershipAddr = ownership.addr;
1245       }
1246       if (currOwnershipAddr == owner) {
1247         if (tokenIdsIdx == index) {
1248           return i;
1249         }
1250         tokenIdsIdx++;
1251       }
1252     }
1253     revert("ERC721A: unable to get token of owner by index");
1254   }
1255 
1256   /**
1257    * @dev See {IERC165-supportsInterface}.
1258    */
1259   function supportsInterface(bytes4 interfaceId)
1260     public
1261     view
1262     virtual
1263     override(ERC165, IERC165)
1264     returns (bool)
1265   {
1266     return
1267       interfaceId == type(IERC721).interfaceId ||
1268       interfaceId == type(IERC721Metadata).interfaceId ||
1269       interfaceId == type(IERC721Enumerable).interfaceId ||
1270       super.supportsInterface(interfaceId);
1271   }
1272 
1273   /**
1274    * @dev See {IERC721-balanceOf}.
1275    */
1276   function balanceOf(address owner) public view override returns (uint256) {
1277     require(owner != address(0), "ERC721A: balance query for the zero address");
1278     return uint256(_addressData[owner].balance);
1279   }
1280 
1281   function _numberMinted(address owner) internal view returns (uint256) {
1282     require(
1283       owner != address(0),
1284       "ERC721A: number minted query for the zero address"
1285     );
1286     return uint256(_addressData[owner].numberMinted);
1287   }
1288 
1289   function ownershipOf(uint256 tokenId)
1290     internal
1291     view
1292     returns (TokenOwnership memory)
1293   {
1294     uint256 curr = tokenId;
1295 
1296     unchecked {
1297         if (_startTokenId() <= curr && curr < currentIndex) {
1298             TokenOwnership memory ownership = _ownerships[curr];
1299             if (ownership.addr != address(0)) {
1300                 return ownership;
1301             }
1302 
1303             // Invariant:
1304             // There will always be an ownership that has an address and is not burned
1305             // before an ownership that does not have an address and is not burned.
1306             // Hence, curr will not underflow.
1307             while (true) {
1308                 curr--;
1309                 ownership = _ownerships[curr];
1310                 if (ownership.addr != address(0)) {
1311                     return ownership;
1312                 }
1313             }
1314         }
1315     }
1316 
1317     revert("ERC721A: unable to determine the owner of token");
1318   }
1319 
1320   /**
1321    * @dev See {IERC721-ownerOf}.
1322    */
1323   function ownerOf(uint256 tokenId) public view override returns (address) {
1324     return ownershipOf(tokenId).addr;
1325   }
1326 
1327   /**
1328    * @dev See {IERC721Metadata-name}.
1329    */
1330   function name() public view virtual override returns (string memory) {
1331     return _name;
1332   }
1333 
1334   /**
1335    * @dev See {IERC721Metadata-symbol}.
1336    */
1337   function symbol() public view virtual override returns (string memory) {
1338     return _symbol;
1339   }
1340 
1341   /**
1342    * @dev See {IERC721Metadata-tokenURI}.
1343    */
1344   function tokenURI(uint256 tokenId)
1345     public
1346     view
1347     virtual
1348     override
1349     returns (string memory)
1350   {
1351     string memory baseURI = _baseURI();
1352     string memory extension = _baseURIExtension();
1353     return
1354       bytes(baseURI).length > 0
1355         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1356         : "";
1357   }
1358 
1359   /**
1360    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1361    * token will be the concatenation of the baseURI and the tokenId. Empty
1362    * by default, can be overriden in child contracts.
1363    */
1364   function _baseURI() internal view virtual returns (string memory) {
1365     return "";
1366   }
1367 
1368   /**
1369    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1370    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1371    * by default, can be overriden in child contracts.
1372    */
1373   function _baseURIExtension() internal view virtual returns (string memory) {
1374     return "";
1375   }
1376 
1377   /**
1378    * @dev Sets the value for an address to be in the restricted approval address pool.
1379    * Setting an address to true will disable token owners from being able to mark the address
1380    * for approval for trading. This would be used in theory to prevent token owners from listing
1381    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1382    * @param _address the marketplace/user to modify restriction status of
1383    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1384    */
1385   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1386     restrictedApprovalAddresses[_address] = _isRestricted;
1387   }
1388 
1389   /**
1390    * @dev See {IERC721-approve}.
1391    */
1392   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1393     address owner = ERC721A.ownerOf(tokenId);
1394     require(to != owner, "ERC721A: approval to current owner");
1395     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1396 
1397     require(
1398       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1399       "ERC721A: approve caller is not owner nor approved for all"
1400     );
1401 
1402     _approve(to, tokenId, owner);
1403   }
1404 
1405   /**
1406    * @dev See {IERC721-getApproved}.
1407    */
1408   function getApproved(uint256 tokenId) public view override returns (address) {
1409     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1410 
1411     return _tokenApprovals[tokenId];
1412   }
1413 
1414   /**
1415    * @dev See {IERC721-setApprovalForAll}.
1416    */
1417   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1418     require(operator != _msgSender(), "ERC721A: approve to caller");
1419     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1420 
1421     _operatorApprovals[_msgSender()][operator] = approved;
1422     emit ApprovalForAll(_msgSender(), operator, approved);
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-isApprovedForAll}.
1427    */
1428   function isApprovedForAll(address owner, address operator)
1429     public
1430     view
1431     virtual
1432     override
1433     returns (bool)
1434   {
1435     return _operatorApprovals[owner][operator];
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-transferFrom}.
1440    */
1441   function transferFrom(
1442     address from,
1443     address to,
1444     uint256 tokenId
1445   ) public override onlyAllowedOperator(from) {
1446     _transfer(from, to, tokenId);
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-safeTransferFrom}.
1451    */
1452   function safeTransferFrom(
1453     address from,
1454     address to,
1455     uint256 tokenId
1456   ) public override onlyAllowedOperator(from) {
1457     safeTransferFrom(from, to, tokenId, "");
1458   }
1459 
1460   /**
1461    * @dev See {IERC721-safeTransferFrom}.
1462    */
1463   function safeTransferFrom(
1464     address from,
1465     address to,
1466     uint256 tokenId,
1467     bytes memory _data
1468   ) public override onlyAllowedOperator(from) {
1469     _transfer(from, to, tokenId);
1470     require(
1471       _checkOnERC721Received(from, to, tokenId, _data),
1472       "ERC721A: transfer to non ERC721Receiver implementer"
1473     );
1474   }
1475 
1476   /**
1477    * @dev Returns whether tokenId exists.
1478    *
1479    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1480    *
1481    * Tokens start existing when they are minted (_mint),
1482    */
1483   function _exists(uint256 tokenId) internal view returns (bool) {
1484     return _startTokenId() <= tokenId && tokenId < currentIndex;
1485   }
1486 
1487   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1488     _safeMint(to, quantity, isAdminMint, "");
1489   }
1490 
1491   /**
1492    * @dev Mints quantity tokens and transfers them to to.
1493    *
1494    * Requirements:
1495    *
1496    * - there must be quantity tokens remaining unminted in the total collection.
1497    * - to cannot be the zero address.
1498    * - quantity cannot be larger than the max batch size.
1499    *
1500    * Emits a {Transfer} event.
1501    */
1502   function _safeMint(
1503     address to,
1504     uint256 quantity,
1505     bool isAdminMint,
1506     bytes memory _data
1507   ) internal {
1508     uint256 startTokenId = currentIndex;
1509     require(to != address(0), "ERC721A: mint to the zero address");
1510     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1511     require(!_exists(startTokenId), "ERC721A: token already minted");
1512 
1513     // For admin mints we do not want to enforce the maxBatchSize limit
1514     if (isAdminMint == false) {
1515         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1516     }
1517 
1518     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1519 
1520     AddressData memory addressData = _addressData[to];
1521     _addressData[to] = AddressData(
1522       addressData.balance + uint128(quantity),
1523       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1524     );
1525     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1526 
1527     uint256 updatedIndex = startTokenId;
1528 
1529     for (uint256 i = 0; i < quantity; i++) {
1530       emit Transfer(address(0), to, updatedIndex);
1531       require(
1532         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1533         "ERC721A: transfer to non ERC721Receiver implementer"
1534       );
1535       updatedIndex++;
1536     }
1537 
1538     currentIndex = updatedIndex;
1539     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1540   }
1541 
1542   /**
1543    * @dev Transfers tokenId from from to to.
1544    *
1545    * Requirements:
1546    *
1547    * - to cannot be the zero address.
1548    * - tokenId token must be owned by from.
1549    *
1550    * Emits a {Transfer} event.
1551    */
1552   function _transfer(
1553     address from,
1554     address to,
1555     uint256 tokenId
1556   ) private {
1557     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1558 
1559     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1560       getApproved(tokenId) == _msgSender() ||
1561       isApprovedForAll(prevOwnership.addr, _msgSender()));
1562 
1563     require(
1564       isApprovedOrOwner,
1565       "ERC721A: transfer caller is not owner nor approved"
1566     );
1567 
1568     require(
1569       prevOwnership.addr == from,
1570       "ERC721A: transfer from incorrect owner"
1571     );
1572     require(to != address(0), "ERC721A: transfer to the zero address");
1573 
1574     _beforeTokenTransfers(from, to, tokenId, 1);
1575 
1576     // Clear approvals from the previous owner
1577     _approve(address(0), tokenId, prevOwnership.addr);
1578 
1579     _addressData[from].balance -= 1;
1580     _addressData[to].balance += 1;
1581     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1582 
1583     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1584     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1585     uint256 nextTokenId = tokenId + 1;
1586     if (_ownerships[nextTokenId].addr == address(0)) {
1587       if (_exists(nextTokenId)) {
1588         _ownerships[nextTokenId] = TokenOwnership(
1589           prevOwnership.addr,
1590           prevOwnership.startTimestamp
1591         );
1592       }
1593     }
1594 
1595     emit Transfer(from, to, tokenId);
1596     _afterTokenTransfers(from, to, tokenId, 1);
1597   }
1598 
1599   /**
1600    * @dev Approve to to operate on tokenId
1601    *
1602    * Emits a {Approval} event.
1603    */
1604   function _approve(
1605     address to,
1606     uint256 tokenId,
1607     address owner
1608   ) private {
1609     _tokenApprovals[tokenId] = to;
1610     emit Approval(owner, to, tokenId);
1611   }
1612 
1613   uint256 public nextOwnerToExplicitlySet = 0;
1614 
1615   /**
1616    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1617    */
1618   function _setOwnersExplicit(uint256 quantity) internal {
1619     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1620     require(quantity > 0, "quantity must be nonzero");
1621     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1622 
1623     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1624     if (endIndex > collectionSize - 1) {
1625       endIndex = collectionSize - 1;
1626     }
1627     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1628     require(_exists(endIndex), "not enough minted yet for this cleanup");
1629     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1630       if (_ownerships[i].addr == address(0)) {
1631         TokenOwnership memory ownership = ownershipOf(i);
1632         _ownerships[i] = TokenOwnership(
1633           ownership.addr,
1634           ownership.startTimestamp
1635         );
1636       }
1637     }
1638     nextOwnerToExplicitlySet = endIndex + 1;
1639   }
1640 
1641   /**
1642    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1643    * The call is not executed if the target address is not a contract.
1644    *
1645    * @param from address representing the previous owner of the given token ID
1646    * @param to target address that will receive the tokens
1647    * @param tokenId uint256 ID of the token to be transferred
1648    * @param _data bytes optional data to send along with the call
1649    * @return bool whether the call correctly returned the expected magic value
1650    */
1651   function _checkOnERC721Received(
1652     address from,
1653     address to,
1654     uint256 tokenId,
1655     bytes memory _data
1656   ) private returns (bool) {
1657     if (to.isContract()) {
1658       try
1659         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1660       returns (bytes4 retval) {
1661         return retval == IERC721Receiver(to).onERC721Received.selector;
1662       } catch (bytes memory reason) {
1663         if (reason.length == 0) {
1664           revert("ERC721A: transfer to non ERC721Receiver implementer");
1665         } else {
1666           assembly {
1667             revert(add(32, reason), mload(reason))
1668           }
1669         }
1670       }
1671     } else {
1672       return true;
1673     }
1674   }
1675 
1676   /**
1677    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1678    *
1679    * startTokenId - the first token id to be transferred
1680    * quantity - the amount to be transferred
1681    *
1682    * Calling conditions:
1683    *
1684    * - When from and to are both non-zero, from's tokenId will be
1685    * transferred to to.
1686    * - When from is zero, tokenId will be minted for to.
1687    */
1688   function _beforeTokenTransfers(
1689     address from,
1690     address to,
1691     uint256 startTokenId,
1692     uint256 quantity
1693   ) internal virtual {}
1694 
1695   /**
1696    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1697    * minting.
1698    *
1699    * startTokenId - the first token id to be transferred
1700    * quantity - the amount to be transferred
1701    *
1702    * Calling conditions:
1703    *
1704    * - when from and to are both non-zero.
1705    * - from and to are never both zero.
1706    */
1707   function _afterTokenTransfers(
1708     address from,
1709     address to,
1710     uint256 startTokenId,
1711     uint256 quantity
1712   ) internal virtual {}
1713 }
1714 
1715 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1716 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1717 // @notice -- See Medium article --
1718 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1719 abstract contract ERC721ARedemption is ERC721A {
1720   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1721   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1722 
1723   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1724   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1725   
1726   uint256 public redemptionSurcharge = 0 ether;
1727   bool public redemptionModeEnabled;
1728   bool public verifiedClaimModeEnabled;
1729   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1730   mapping(address => bool) public redemptionContracts;
1731   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1732 
1733   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1734   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1735     redemptionContracts[_contractAddress] = _status;
1736   }
1737 
1738   // @dev Allow owner/team to determine if contract is accepting redemption mints
1739   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1740     redemptionModeEnabled = _newStatus;
1741   }
1742 
1743   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1744   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1745     verifiedClaimModeEnabled = _newStatus;
1746   }
1747 
1748   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1749   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1750     redemptionSurcharge = _newSurchargeInWei;
1751   }
1752 
1753   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1754   // @notice Must be a wallet address or implement IERC721Receiver.
1755   // Cannot be null address as this will break any ERC-721A implementation without a proper
1756   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1757   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1758     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1759     redemptionAddress = _newRedemptionAddress;
1760   }
1761 
1762   /**
1763   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1764   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1765   * the contract owner or Team => redemptionAddress. 
1766   * @param tokenId the token to be redeemed.
1767   * Emits a {Redeemed} event.
1768   **/
1769   function redeem(address redemptionContract, uint256 tokenId) public payable {
1770     if(getNextTokenId() > collectionSize) revert CapExceeded();
1771     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1772     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1773     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1774     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1775     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1776     
1777     IERC721 _targetContract = IERC721(redemptionContract);
1778     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1779     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1780     
1781     // Warning: Since there is no standarized return value for transfers of ERC-721
1782     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1783     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1784     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1785     // but the NFT may not have been sent to the redemptionAddress.
1786     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1787     tokenRedemptions[redemptionContract][tokenId] = true;
1788 
1789     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1790     _safeMint(_msgSender(), 1, false);
1791   }
1792 
1793   /**
1794   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1795   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1796   * @param tokenId the token to be redeemed.
1797   * Emits a {VerifiedClaim} event.
1798   **/
1799   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1800     if(getNextTokenId() > collectionSize) revert CapExceeded();
1801     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1802     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1803     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1804     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1805     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1806     
1807     tokenRedemptions[redemptionContract][tokenId] = true;
1808     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1809     _safeMint(_msgSender(), 1, false);
1810   }
1811 }
1812 
1813 
1814   
1815   
1816 interface IERC20 {
1817   function allowance(address owner, address spender) external view returns (uint256);
1818   function transfer(address _to, uint256 _amount) external returns (bool);
1819   function balanceOf(address account) external view returns (uint256);
1820   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1821 }
1822 
1823 // File: WithdrawableV2
1824 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1825 // ERC-20 Payouts are limited to a single payout address. This feature 
1826 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1827 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1828 abstract contract WithdrawableV2 is Teams {
1829   struct acceptedERC20 {
1830     bool isActive;
1831     uint256 chargeAmount;
1832   }
1833 
1834   
1835   mapping(address => acceptedERC20) private allowedTokenContracts;
1836   address[] public payableAddresses = [0x22767f186d5492E4c5364c05326b0c0155c5cAdB,0xa74A8D0Fc1a195CCef848DaE71EE888cA3860813];
1837   address public erc20Payable = 0x22767f186d5492E4c5364c05326b0c0155c5cAdB;
1838   uint256[] public payableFees = [50,50];
1839   uint256 public payableAddressCount = 2;
1840   bool public onlyERC20MintingMode;
1841   
1842 
1843   function withdrawAll() public onlyTeamOrOwner {
1844       if(address(this).balance == 0) revert ValueCannotBeZero();
1845       _withdrawAll(address(this).balance);
1846   }
1847 
1848   function _withdrawAll(uint256 balance) private {
1849       for(uint i=0; i < payableAddressCount; i++ ) {
1850           _widthdraw(
1851               payableAddresses[i],
1852               (balance * payableFees[i]) / 100
1853           );
1854       }
1855   }
1856   
1857   function _widthdraw(address _address, uint256 _amount) private {
1858       (bool success, ) = _address.call{value: _amount}("");
1859       require(success, "Transfer failed.");
1860   }
1861 
1862   /**
1863   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1864   * in the event ERC-20 tokens are paid to the contract for mints.
1865   * @param _tokenContract contract of ERC-20 token to withdraw
1866   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1867   */
1868   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1869     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1870     IERC20 tokenContract = IERC20(_tokenContract);
1871     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1872     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1873   }
1874 
1875   /**
1876   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1877   * @param _erc20TokenContract address of ERC-20 contract in question
1878   */
1879   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1880     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1881   }
1882 
1883   /**
1884   * @dev get the value of tokens to transfer for user of an ERC-20
1885   * @param _erc20TokenContract address of ERC-20 contract in question
1886   */
1887   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1888     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1889     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1890   }
1891 
1892   /**
1893   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1894   * @param _erc20TokenContract address of ERC-20 contract in question
1895   * @param _isActive default status of if contract should be allowed to accept payments
1896   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1897   */
1898   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1899     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1900     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1901   }
1902 
1903   /**
1904   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1905   * it will assume the default value of zero. This should not be used to create new payment tokens.
1906   * @param _erc20TokenContract address of ERC-20 contract in question
1907   */
1908   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1909     allowedTokenContracts[_erc20TokenContract].isActive = true;
1910   }
1911 
1912   /**
1913   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1914   * it will assume the default value of zero. This should not be used to create new payment tokens.
1915   * @param _erc20TokenContract address of ERC-20 contract in question
1916   */
1917   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1918     allowedTokenContracts[_erc20TokenContract].isActive = false;
1919   }
1920 
1921   /**
1922   * @dev Enable only ERC-20 payments for minting on this contract
1923   */
1924   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1925     onlyERC20MintingMode = true;
1926   }
1927 
1928   /**
1929   * @dev Disable only ERC-20 payments for minting on this contract
1930   */
1931   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1932     onlyERC20MintingMode = false;
1933   }
1934 
1935   /**
1936   * @dev Set the payout of the ERC-20 token payout to a specific address
1937   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1938   */
1939   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1940     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1941     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1942     erc20Payable = _newErc20Payable;
1943   }
1944 }
1945 
1946 
1947   
1948   
1949   
1950 // File: EarlyMintIncentive.sol
1951 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1952 // zero fee that can be calculated on the fly.
1953 abstract contract EarlyMintIncentive is Teams, ERC721A {
1954   uint256 public PRICE = 0.0055 ether;
1955   uint256 public EARLY_MINT_PRICE = 0 ether;
1956   uint256 public earlyMintOwnershipCap = 1;
1957   bool public usingEarlyMintIncentive = true;
1958 
1959   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1960     usingEarlyMintIncentive = true;
1961   }
1962 
1963   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1964     usingEarlyMintIncentive = false;
1965   }
1966 
1967   /**
1968   * @dev Set the max token ID in which the cost incentive will be applied.
1969   * @param _newCap max number of tokens wallet may mint for incentive price
1970   */
1971   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1972     if(_newCap == 0) revert ValueCannotBeZero();
1973     earlyMintOwnershipCap = _newCap;
1974   }
1975 
1976   /**
1977   * @dev Set the incentive mint price
1978   * @param _feeInWei new price per token when in incentive range
1979   */
1980   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1981     EARLY_MINT_PRICE = _feeInWei;
1982   }
1983 
1984   /**
1985   * @dev Set the primary mint price - the base price when not under incentive
1986   * @param _feeInWei new price per token
1987   */
1988   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1989     PRICE = _feeInWei;
1990   }
1991 
1992   /**
1993   * @dev Get the correct price for the mint for qty and person minting
1994   * @param _count amount of tokens to calc for mint
1995   * @param _to the address which will be minting these tokens, passed explicitly
1996   */
1997   function getPrice(uint256 _count, address _to) public view returns (uint256) {
1998     if(_count == 0) revert ValueCannotBeZero();
1999 
2000     // short circuit function if we dont need to even calc incentive pricing
2001     // short circuit if the current wallet mint qty is also already over cap
2002     if(
2003       usingEarlyMintIncentive == false ||
2004       _numberMinted(_to) > earlyMintOwnershipCap
2005     ) {
2006       return PRICE * _count;
2007     }
2008 
2009     uint256 endingTokenQty = _numberMinted(_to) + _count;
2010     // If qty to mint results in a final qty less than or equal to the cap then
2011     // the entire qty is within incentive mint.
2012     if(endingTokenQty  <= earlyMintOwnershipCap) {
2013       return EARLY_MINT_PRICE * _count;
2014     }
2015 
2016     // If the current token qty is less than the incentive cap
2017     // and the ending token qty is greater than the incentive cap
2018     // we will be straddling the cap so there will be some amount
2019     // that are incentive and some that are regular fee.
2020     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(_to);
2021     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
2022 
2023     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
2024   }
2025 }
2026 
2027   
2028 abstract contract RamppERC721A is 
2029     Ownable,
2030     Teams,
2031     ERC721ARedemption,
2032     WithdrawableV2,
2033     ReentrancyGuard 
2034     , EarlyMintIncentive 
2035     , Allowlist 
2036     
2037 {
2038   constructor(
2039     string memory tokenName,
2040     string memory tokenSymbol
2041   ) ERC721A(tokenName, tokenSymbol, 3, 5000) { }
2042     uint8 constant public CONTRACT_VERSION = 2;
2043     string public _baseTokenURI = "ipfs://bafybeif5hvtotmr4e5lvvsq2qmvbi64c6ysvoz2y2uoi3galvn2g5hrhbm/";
2044     string public _baseTokenExtension = ".json";
2045 
2046     bool public mintingOpen = false;
2047     
2048     
2049     uint256 public MAX_WALLET_MINTS = 3;
2050 
2051   
2052     /////////////// Admin Mint Functions
2053     /**
2054      * @dev Mints a token to an address with a tokenURI.
2055      * This is owner only and allows a fee-free drop
2056      * @param _to address of the future owner of the token
2057      * @param _qty amount of tokens to drop the owner
2058      */
2059      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
2060          if(_qty == 0) revert MintZeroQuantity();
2061          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
2062          _safeMint(_to, _qty, true);
2063      }
2064 
2065   
2066     /////////////// PUBLIC MINT FUNCTIONS
2067     /**
2068     * @dev Mints tokens to an address in batch.
2069     * fee may or may not be required*
2070     * @param _to address of the future owner of the token
2071     * @param _amount number of tokens to mint
2072     */
2073     function mintToMultiple(address _to, uint256 _amount) public payable {
2074         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2075         if(_amount == 0) revert MintZeroQuantity();
2076         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2077         if(!mintingOpen) revert PublicMintClosed();
2078         if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2079         
2080         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2081         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2082         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2083 
2084         _safeMint(_to, _amount, false);
2085     }
2086 
2087     /**
2088      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2089      * fee may or may not be required*
2090      * @param _to address of the future owner of the token
2091      * @param _amount number of tokens to mint
2092      * @param _erc20TokenContract erc-20 token contract to mint with
2093      */
2094     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2095       if(_amount == 0) revert MintZeroQuantity();
2096       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2097       if(!mintingOpen) revert PublicMintClosed();
2098       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2099       if(mintingOpen && onlyAllowlistMode) revert PublicMintClosed();
2100       
2101       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2102 
2103       // ERC-20 Specific pre-flight checks
2104       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2105       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2106       IERC20 payableToken = IERC20(_erc20TokenContract);
2107 
2108       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2109       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2110 
2111       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2112       if(!transferComplete) revert ERC20TransferFailed();
2113       
2114       _safeMint(_to, _amount, false);
2115     }
2116 
2117     function openMinting() public onlyTeamOrOwner {
2118         mintingOpen = true;
2119     }
2120 
2121     function stopMinting() public onlyTeamOrOwner {
2122         mintingOpen = false;
2123     }
2124 
2125   
2126     ///////////// ALLOWLIST MINTING FUNCTIONS
2127     /**
2128     * @dev Mints tokens to an address using an allowlist.
2129     * fee may or may not be required*
2130     * @param _to address of the future owner of the token
2131     * @param _amount number of tokens to mint
2132     * @param _merkleProof merkle proof array
2133     */
2134     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2135         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
2136         if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2137         if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2138         if(_amount == 0) revert MintZeroQuantity();
2139         if(_amount > maxBatchSize) revert TransactionCapExceeded();
2140         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2141         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2142         if(msg.value != getPrice(_amount, _to)) revert InvalidPayment();
2143         
2144 
2145         _safeMint(_to, _amount, false);
2146     }
2147 
2148     /**
2149     * @dev Mints tokens to an address using an allowlist.
2150     * fee may or may not be required*
2151     * @param _to address of the future owner of the token
2152     * @param _amount number of tokens to mint
2153     * @param _merkleProof merkle proof array
2154     * @param _erc20TokenContract erc-20 token contract to mint with
2155     */
2156     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2157       if(!onlyAllowlistMode || !mintingOpen) revert AllowlistMintClosed();
2158       if(!isAllowlisted(_to, _merkleProof)) revert AddressNotAllowlisted();
2159       if(_amount == 0) revert MintZeroQuantity();
2160       if(_amount > maxBatchSize) revert TransactionCapExceeded();
2161       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
2162       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
2163       
2164     
2165       // ERC-20 Specific pre-flight checks
2166       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
2167       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2168       IERC20 payableToken = IERC20(_erc20TokenContract);
2169 
2170       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
2171       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
2172 
2173       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2174       if(!transferComplete) revert ERC20TransferFailed();
2175       
2176       _safeMint(_to, _amount, false);
2177     }
2178 
2179     /**
2180      * @dev Enable allowlist minting fully by enabling both flags
2181      * This is a convenience function for the Rampp user
2182      */
2183     function openAllowlistMint() public onlyTeamOrOwner {
2184         enableAllowlistOnlyMode();
2185         mintingOpen = true;
2186     }
2187 
2188     /**
2189      * @dev Close allowlist minting fully by disabling both flags
2190      * This is a convenience function for the Rampp user
2191      */
2192     function closeAllowlistMint() public onlyTeamOrOwner {
2193         disableAllowlistOnlyMode();
2194         mintingOpen = false;
2195     }
2196 
2197 
2198   
2199     /**
2200     * @dev Check if wallet over MAX_WALLET_MINTS
2201     * @param _address address in question to check if minted count exceeds max
2202     */
2203     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2204         if(_amount == 0) revert ValueCannotBeZero();
2205         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2206     }
2207 
2208     /**
2209     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2210     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2211     */
2212     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2213         if(_newWalletMax == 0) revert ValueCannotBeZero();
2214         MAX_WALLET_MINTS = _newWalletMax;
2215     }
2216     
2217 
2218   
2219     /**
2220      * @dev Allows owner to set Max mints per tx
2221      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2222      */
2223      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2224          if(_newMaxMint == 0) revert ValueCannotBeZero();
2225          maxBatchSize = _newMaxMint;
2226      }
2227     
2228 
2229   
2230   
2231   
2232   function contractURI() public pure returns (string memory) {
2233     return "https://metadata.mintplex.xyz/GO8kzRD1GfK1dYoNevcr/contract-metadata";
2234   }
2235   
2236 
2237   function _baseURI() internal view virtual override returns(string memory) {
2238     return _baseTokenURI;
2239   }
2240 
2241   function _baseURIExtension() internal view virtual override returns(string memory) {
2242     return _baseTokenExtension;
2243   }
2244 
2245   function baseTokenURI() public view returns(string memory) {
2246     return _baseTokenURI;
2247   }
2248 
2249   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2250     _baseTokenURI = baseURI;
2251   }
2252 
2253   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2254     _baseTokenExtension = baseExtension;
2255   }
2256 }
2257 
2258 
2259   
2260 // File: contracts/MisfitsContract.sol
2261 //SPDX-License-Identifier: MIT
2262 
2263 pragma solidity ^0.8.0;
2264 
2265 contract MisfitsContract is RamppERC721A {
2266     constructor() RamppERC721A("Misfits", "MISFITS"){}
2267 }
2268   