1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //                                                                                                                                                                           
5 //                                                                                                                                                                           
6 // EEEEEEEEEEEEEEEEEEEEEE                                        PPPPPPPPPPPPPPPPP   hhhhhhh                                               kkkkkkkk                          
7 // E::::::::::::::::::::E                                        P::::::::::::::::P  h:::::h                                               k::::::k                          
8 // E::::::::::::::::::::E                                        P::::::PPPPPP:::::P h:::::h                                               k::::::k                          
9 // EE::::::EEEEEEEEE::::E                                        PP:::::P     P:::::Ph:::::h                                               k::::::k                          
10 //   E:::::E       EEEEEEyyyyyyy           yyyyyyy eeeeeeeeeeee    P::::P     P:::::P h::::h hhhhh       uuuuuu    uuuuuunnnn  nnnnnnnn     k:::::k    kkkkkkk  ssssssssss   
11 //   E:::::E              y:::::y         y:::::yee::::::::::::ee  P::::P     P:::::P h::::hh:::::hhh    u::::u    u::::un:::nn::::::::nn   k:::::k   k:::::k ss::::::::::s  
12 //   E::::::EEEEEEEEEE     y:::::y       y:::::ye::::::eeeee:::::eeP::::PPPPPP:::::P  h::::::::::::::hh  u::::u    u::::un::::::::::::::nn  k:::::k  k:::::kss:::::::::::::s 
13 //   E:::::::::::::::E      y:::::y     y:::::ye::::::e     e:::::eP:::::::::::::PP   h:::::::hhh::::::h u::::u    u::::unn:::::::::::::::n k:::::k k:::::k s::::::ssss:::::s
14 //   E:::::::::::::::E       y:::::y   y:::::y e:::::::eeeee::::::eP::::PPPPPPPPP     h::::::h   h::::::hu::::u    u::::u  n:::::nnnn:::::n k::::::k:::::k   s:::::s  ssssss 
15 //   E::::::EEEEEEEEEE        y:::::y y:::::y  e:::::::::::::::::e P::::P             h:::::h     h:::::hu::::u    u::::u  n::::n    n::::n k:::::::::::k      s::::::s      
16 //   E:::::E                   y:::::y:::::y   e::::::eeeeeeeeeee  P::::P             h:::::h     h:::::hu::::u    u::::u  n::::n    n::::n k:::::::::::k         s::::::s   
17 //   E:::::E       EEEEEE       y:::::::::y    e:::::::e           P::::P             h:::::h     h:::::hu:::::uuuu:::::u  n::::n    n::::n k::::::k:::::k  ssssss   s:::::s 
18 // EE::::::EEEEEEEE:::::E        y:::::::y     e::::::::e        PP::::::PP           h:::::h     h:::::hu:::::::::::::::uun::::n    n::::nk::::::k k:::::k s:::::ssss::::::s
19 // E::::::::::::::::::::E         y:::::y       e::::::::eeeeeeeeP::::::::P           h:::::h     h:::::h u:::::::::::::::un::::n    n::::nk::::::k  k:::::ks::::::::::::::s 
20 // E::::::::::::::::::::E        y:::::y         ee:::::::::::::eP::::::::P           h:::::h     h:::::h  uu::::::::uu:::un::::n    n::::nk::::::k   k:::::ks:::::::::::ss  
21 // EEEEEEEEEEEEEEEEEEEEEE       y:::::y            eeeeeeeeeeeeeePPPPPPPPPP           hhhhhhh     hhhhhhh    uuuuuuuu  uuuunnnnnn    nnnnnnkkkkkkkk    kkkkkkksssssssssss    
22 //                             y:::::y                                                                                                                                       
23 //                            y:::::y                                                                                                                                        
24 //                           y:::::y                                                                                                                                         
25 //                          y:::::y                                                                                                                                          
26 //                         yyyyyyy                                                                                                                                           
27 //                                                                                                                                                                           
28 //                                                                                                                                                                           
29 //
30 //*********************************************************************//
31 //*********************************************************************//
32   
33 //-------------DEPENDENCIES--------------------------//
34 
35 // File: @openzeppelin/contracts/utils/Address.sol
36 
37 
38 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
39 
40 pragma solidity ^0.8.1;
41 
42 /**
43  * @dev Collection of functions related to the address type
44  */
45 library Address {
46     /**
47      * @dev Returns true if account is a contract.
48      *
49      * [IMPORTANT]
50      * ====
51      * It is unsafe to assume that an address for which this function returns
52      * false is an externally-owned account (EOA) and not a contract.
53      *
54      * Among others, isContract will return false for the following
55      * types of addresses:
56      *
57      *  - an externally-owned account
58      *  - a contract in construction
59      *  - an address where a contract will be created
60      *  - an address where a contract lived, but was destroyed
61      * ====
62      *
63      * [IMPORTANT]
64      * ====
65      * You shouldn't rely on isContract to protect against flash loan attacks!
66      *
67      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
68      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
69      * constructor.
70      * ====
71      */
72     function isContract(address account) internal view returns (bool) {
73         // This method relies on extcodesize/address.code.length, which returns 0
74         // for contracts in construction, since the code is only stored at the end
75         // of the constructor execution.
76 
77         return account.code.length > 0;
78     }
79 
80     /**
81      * @dev Replacement for Solidity's transfer: sends amount wei to
82      * recipient, forwarding all available gas and reverting on errors.
83      *
84      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
85      * of certain opcodes, possibly making contracts go over the 2300 gas limit
86      * imposed by transfer, making them unable to receive funds via
87      * transfer. {sendValue} removes this limitation.
88      *
89      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
90      *
91      * IMPORTANT: because control is transferred to recipient, care must be
92      * taken to not create reentrancy vulnerabilities. Consider using
93      * {ReentrancyGuard} or the
94      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
95      */
96     function sendValue(address payable recipient, uint256 amount) internal {
97         require(address(this).balance >= amount, "Address: insufficient balance");
98 
99         (bool success, ) = recipient.call{value: amount}("");
100         require(success, "Address: unable to send value, recipient may have reverted");
101     }
102 
103     /**
104      * @dev Performs a Solidity function call using a low level call. A
105      * plain call is an unsafe replacement for a function call: use this
106      * function instead.
107      *
108      * If target reverts with a revert reason, it is bubbled up by this
109      * function (like regular Solidity function calls).
110      *
111      * Returns the raw returned data. To convert to the expected return value,
112      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
113      *
114      * Requirements:
115      *
116      * - target must be a contract.
117      * - calling target with data must not revert.
118      *
119      * _Available since v3.1._
120      */
121     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
122         return functionCall(target, data, "Address: low-level call failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
127      * errorMessage as a fallback revert reason when target reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCall(
132         address target,
133         bytes memory data,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         return functionCallWithValue(target, data, 0, errorMessage);
137     }
138 
139     /**
140      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
141      * but also transferring value wei to target.
142      *
143      * Requirements:
144      *
145      * - the calling contract must have an ETH balance of at least value.
146      * - the called Solidity function must be payable.
147      *
148      * _Available since v3.1._
149      */
150     function functionCallWithValue(
151         address target,
152         bytes memory data,
153         uint256 value
154     ) internal returns (bytes memory) {
155         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
156     }
157 
158     /**
159      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
160      * with errorMessage as a fallback revert reason when target reverts.
161      *
162      * _Available since v3.1._
163      */
164     function functionCallWithValue(
165         address target,
166         bytes memory data,
167         uint256 value,
168         string memory errorMessage
169     ) internal returns (bytes memory) {
170         require(address(this).balance >= value, "Address: insufficient balance for call");
171         require(isContract(target), "Address: call to non-contract");
172 
173         (bool success, bytes memory returndata) = target.call{value: value}(data);
174         return verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
179      * but performing a static call.
180      *
181      * _Available since v3.3._
182      */
183     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
184         return functionStaticCall(target, data, "Address: low-level static call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
189      * but performing a static call.
190      *
191      * _Available since v3.3._
192      */
193     function functionStaticCall(
194         address target,
195         bytes memory data,
196         string memory errorMessage
197     ) internal view returns (bytes memory) {
198         require(isContract(target), "Address: static call to non-contract");
199 
200         (bool success, bytes memory returndata) = target.staticcall(data);
201         return verifyCallResult(success, returndata, errorMessage);
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
206      * but performing a delegate call.
207      *
208      * _Available since v3.4._
209      */
210     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
211         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
216      * but performing a delegate call.
217      *
218      * _Available since v3.4._
219      */
220     function functionDelegateCall(
221         address target,
222         bytes memory data,
223         string memory errorMessage
224     ) internal returns (bytes memory) {
225         require(isContract(target), "Address: delegate call to non-contract");
226 
227         (bool success, bytes memory returndata) = target.delegatecall(data);
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
233      * revert reason using the provided one.
234      *
235      * _Available since v4.3._
236      */
237     function verifyCallResult(
238         bool success,
239         bytes memory returndata,
240         string memory errorMessage
241     ) internal pure returns (bytes memory) {
242         if (success) {
243             return returndata;
244         } else {
245             // Look for revert reason and bubble it up if present
246             if (returndata.length > 0) {
247                 // The easiest way to bubble the revert reason is using memory via assembly
248 
249                 assembly {
250                     let returndata_size := mload(returndata)
251                     revert(add(32, returndata), returndata_size)
252                 }
253             } else {
254                 revert(errorMessage);
255             }
256         }
257     }
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @title ERC721 token receiver interface
269  * @dev Interface for any contract that wants to support safeTransfers
270  * from ERC721 asset contracts.
271  */
272 interface IERC721Receiver {
273     /**
274      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
275      * by operator from from, this function is called.
276      *
277      * It must return its Solidity selector to confirm the token transfer.
278      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
279      *
280      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
281      */
282     function onERC721Received(
283         address operator,
284         address from,
285         uint256 tokenId,
286         bytes calldata data
287     ) external returns (bytes4);
288 }
289 
290 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 /**
298  * @dev Interface of the ERC165 standard, as defined in the
299  * https://eips.ethereum.org/EIPS/eip-165[EIP].
300  *
301  * Implementers can declare support of contract interfaces, which can then be
302  * queried by others ({ERC165Checker}).
303  *
304  * For an implementation, see {ERC165}.
305  */
306 interface IERC165 {
307     /**
308      * @dev Returns true if this contract implements the interface defined by
309      * interfaceId. See the corresponding
310      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
311      * to learn more about how these ids are created.
312      *
313      * This function call must use less than 30 000 gas.
314      */
315     function supportsInterface(bytes4 interfaceId) external view returns (bool);
316 }
317 
318 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
322 
323 pragma solidity ^0.8.0;
324 
325 
326 /**
327  * @dev Implementation of the {IERC165} interface.
328  *
329  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
330  * for the additional interface id that will be supported. For example:
331  *
332  * solidity
333  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
335  * }
336  * 
337  *
338  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
339  */
340 abstract contract ERC165 is IERC165 {
341     /**
342      * @dev See {IERC165-supportsInterface}.
343      */
344     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
345         return interfaceId == type(IERC165).interfaceId;
346     }
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev Required interface of an ERC721 compliant contract.
359  */
360 interface IERC721 is IERC165 {
361     /**
362      * @dev Emitted when tokenId token is transferred from from to to.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when owner enables approved to manage the tokenId token.
368      */
369     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
370 
371     /**
372      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
373      */
374     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
375 
376     /**
377      * @dev Returns the number of tokens in owner's account.
378      */
379     function balanceOf(address owner) external view returns (uint256 balance);
380 
381     /**
382      * @dev Returns the owner of the tokenId token.
383      *
384      * Requirements:
385      *
386      * - tokenId must exist.
387      */
388     function ownerOf(uint256 tokenId) external view returns (address owner);
389 
390     /**
391      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
392      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
393      *
394      * Requirements:
395      *
396      * - from cannot be the zero address.
397      * - to cannot be the zero address.
398      * - tokenId token must exist and be owned by from.
399      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
400      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
401      *
402      * Emits a {Transfer} event.
403      */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Transfers tokenId token from from to to.
412      *
413      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
414      *
415      * Requirements:
416      *
417      * - from cannot be the zero address.
418      * - to cannot be the zero address.
419      * - tokenId token must be owned by from.
420      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430     /**
431      * @dev Gives permission to to to transfer tokenId token to another account.
432      * The approval is cleared when the token is transferred.
433      *
434      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
435      *
436      * Requirements:
437      *
438      * - The caller must own the token or be an approved operator.
439      * - tokenId must exist.
440      *
441      * Emits an {Approval} event.
442      */
443     function approve(address to, uint256 tokenId) external;
444 
445     /**
446      * @dev Returns the account approved for tokenId token.
447      *
448      * Requirements:
449      *
450      * - tokenId must exist.
451      */
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     /**
455      * @dev Approve or remove operator as an operator for the caller.
456      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
457      *
458      * Requirements:
459      *
460      * - The operator cannot be the caller.
461      *
462      * Emits an {ApprovalForAll} event.
463      */
464     function setApprovalForAll(address operator, bool _approved) external;
465 
466     /**
467      * @dev Returns if the operator is allowed to manage all of the assets of owner.
468      *
469      * See {setApprovalForAll}
470      */
471     function isApprovedForAll(address owner, address operator) external view returns (bool);
472 
473     /**
474      * @dev Safely transfers tokenId token from from to to.
475      *
476      * Requirements:
477      *
478      * - from cannot be the zero address.
479      * - to cannot be the zero address.
480      * - tokenId token must exist and be owned by from.
481      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId,
490         bytes calldata data
491     ) external;
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
495 
496 
497 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 /**
503  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
504  * @dev See https://eips.ethereum.org/EIPS/eip-721
505  */
506 interface IERC721Enumerable is IERC721 {
507     /**
508      * @dev Returns the total amount of tokens stored by the contract.
509      */
510     function totalSupply() external view returns (uint256);
511 
512     /**
513      * @dev Returns a token ID owned by owner at a given index of its token list.
514      * Use along with {balanceOf} to enumerate all of owner's tokens.
515      */
516     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
517 
518     /**
519      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
520      * Use along with {totalSupply} to enumerate all tokens.
521      */
522     function tokenByIndex(uint256 index) external view returns (uint256);
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
535  * @dev See https://eips.ethereum.org/EIPS/eip-721
536  */
537 interface IERC721Metadata is IERC721 {
538     /**
539      * @dev Returns the token collection name.
540      */
541     function name() external view returns (string memory);
542 
543     /**
544      * @dev Returns the token collection symbol.
545      */
546     function symbol() external view returns (string memory);
547 
548     /**
549      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
550      */
551     function tokenURI(uint256 tokenId) external view returns (string memory);
552 }
553 
554 // File: @openzeppelin/contracts/utils/Strings.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 /**
562  * @dev String operations.
563  */
564 library Strings {
565     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
566 
567     /**
568      * @dev Converts a uint256 to its ASCII string decimal representation.
569      */
570     function toString(uint256 value) internal pure returns (string memory) {
571         // Inspired by OraclizeAPI's implementation - MIT licence
572         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
573 
574         if (value == 0) {
575             return "0";
576         }
577         uint256 temp = value;
578         uint256 digits;
579         while (temp != 0) {
580             digits++;
581             temp /= 10;
582         }
583         bytes memory buffer = new bytes(digits);
584         while (value != 0) {
585             digits -= 1;
586             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
587             value /= 10;
588         }
589         return string(buffer);
590     }
591 
592     /**
593      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
594      */
595     function toHexString(uint256 value) internal pure returns (string memory) {
596         if (value == 0) {
597             return "0x00";
598         }
599         uint256 temp = value;
600         uint256 length = 0;
601         while (temp != 0) {
602             length++;
603             temp >>= 8;
604         }
605         return toHexString(value, length);
606     }
607 
608     /**
609      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
610      */
611     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
612         bytes memory buffer = new bytes(2 * length + 2);
613         buffer[0] = "0";
614         buffer[1] = "x";
615         for (uint256 i = 2 * length + 1; i > 1; --i) {
616             buffer[i] = _HEX_SYMBOLS[value & 0xf];
617             value >>= 4;
618         }
619         require(value == 0, "Strings: hex length insufficient");
620         return string(buffer);
621     }
622 }
623 
624 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
625 
626 
627 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 /**
632  * @dev Contract module that helps prevent reentrant calls to a function.
633  *
634  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
635  * available, which can be applied to functions to make sure there are no nested
636  * (reentrant) calls to them.
637  *
638  * Note that because there is a single nonReentrant guard, functions marked as
639  * nonReentrant may not call one another. This can be worked around by making
640  * those functions private, and then adding external nonReentrant entry
641  * points to them.
642  *
643  * TIP: If you would like to learn more about reentrancy and alternative ways
644  * to protect against it, check out our blog post
645  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
646  */
647 abstract contract ReentrancyGuard {
648     // Booleans are more expensive than uint256 or any type that takes up a full
649     // word because each write operation emits an extra SLOAD to first read the
650     // slot's contents, replace the bits taken up by the boolean, and then write
651     // back. This is the compiler's defense against contract upgrades and
652     // pointer aliasing, and it cannot be disabled.
653 
654     // The values being non-zero value makes deployment a bit more expensive,
655     // but in exchange the refund on every call to nonReentrant will be lower in
656     // amount. Since refunds are capped to a percentage of the total
657     // transaction's gas, it is best to keep them low in cases like this one, to
658     // increase the likelihood of the full refund coming into effect.
659     uint256 private constant _NOT_ENTERED = 1;
660     uint256 private constant _ENTERED = 2;
661 
662     uint256 private _status;
663 
664     constructor() {
665         _status = _NOT_ENTERED;
666     }
667 
668     /**
669      * @dev Prevents a contract from calling itself, directly or indirectly.
670      * Calling a nonReentrant function from another nonReentrant
671      * function is not supported. It is possible to prevent this from happening
672      * by making the nonReentrant function external, and making it call a
673      * private function that does the actual work.
674      */
675     modifier nonReentrant() {
676         // On the first call to nonReentrant, _notEntered will be true
677         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
678 
679         // Any calls to nonReentrant after this point will fail
680         _status = _ENTERED;
681 
682         _;
683 
684         // By storing the original value once again, a refund is triggered (see
685         // https://eips.ethereum.org/EIPS/eip-2200)
686         _status = _NOT_ENTERED;
687     }
688 }
689 
690 // File: @openzeppelin/contracts/utils/Context.sol
691 
692 
693 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 /**
698  * @dev Provides information about the current execution context, including the
699  * sender of the transaction and its data. While these are generally available
700  * via msg.sender and msg.data, they should not be accessed in such a direct
701  * manner, since when dealing with meta-transactions the account sending and
702  * paying for execution may not be the actual sender (as far as an application
703  * is concerned).
704  *
705  * This contract is only required for intermediate, library-like contracts.
706  */
707 abstract contract Context {
708     function _msgSender() internal view virtual returns (address) {
709         return msg.sender;
710     }
711 
712     function _msgData() internal view virtual returns (bytes calldata) {
713         return msg.data;
714     }
715 }
716 
717 // File: @openzeppelin/contracts/access/Ownable.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @dev Contract module which provides a basic access control mechanism, where
727  * there is an account (an owner) that can be granted exclusive access to
728  * specific functions.
729  *
730  * By default, the owner account will be the one that deploys the contract. This
731  * can later be changed with {transferOwnership}.
732  *
733  * This module is used through inheritance. It will make available the modifier
734  * onlyOwner, which can be applied to your functions to restrict their use to
735  * the owner.
736  */
737 abstract contract Ownable is Context {
738     address private _owner;
739 
740     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
741 
742     /**
743      * @dev Initializes the contract setting the deployer as the initial owner.
744      */
745     constructor() {
746         _transferOwnership(_msgSender());
747     }
748 
749     /**
750      * @dev Returns the address of the current owner.
751      */
752     function owner() public view virtual returns (address) {
753         return _owner;
754     }
755 
756     /**
757      * @dev Throws if called by any account other than the owner.
758      */
759     modifier onlyOwner() {
760         require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
794 //-------------END DEPENDENCIES------------------------//
795 
796 
797   
798 // Rampp Contracts v2.1 (Teams.sol)
799 
800 pragma solidity ^0.8.0;
801 
802 /**
803 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
804 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
805 * This will easily allow cross-collaboration via Mintplex.xyz.
806 **/
807 abstract contract Teams is Ownable{
808   mapping (address => bool) internal team;
809 
810   /**
811   * @dev Adds an address to the team. Allows them to execute protected functions
812   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
813   **/
814   function addToTeam(address _address) public onlyOwner {
815     require(_address != address(0), "Invalid address");
816     require(!inTeam(_address), "This address is already in your team.");
817   
818     team[_address] = true;
819   }
820 
821   /**
822   * @dev Removes an address to the team.
823   * @param _address the ETH address to remove, cannot be 0x and must be in team
824   **/
825   function removeFromTeam(address _address) public onlyOwner {
826     require(_address != address(0), "Invalid address");
827     require(inTeam(_address), "This address is not in your team currently.");
828   
829     team[_address] = false;
830   }
831 
832   /**
833   * @dev Check if an address is valid and active in the team
834   * @param _address ETH address to check for truthiness
835   **/
836   function inTeam(address _address)
837     public
838     view
839     returns (bool)
840   {
841     require(_address != address(0), "Invalid address to check.");
842     return team[_address] == true;
843   }
844 
845   /**
846   * @dev Throws if called by any account other than the owner or team member.
847   */
848   modifier onlyTeamOrOwner() {
849     bool _isOwner = owner() == _msgSender();
850     bool _isTeam = inTeam(_msgSender());
851     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
852     _;
853   }
854 }
855 
856 
857   
858   pragma solidity ^0.8.0;
859 
860   /**
861   * @dev These functions deal with verification of Merkle Trees proofs.
862   *
863   * The proofs can be generated using the JavaScript library
864   * https://github.com/miguelmota/merkletreejs[merkletreejs].
865   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
866   *
867   *
868   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
869   * hashing, or use a hash function other than keccak256 for hashing leaves.
870   * This is because the concatenation of a sorted pair of internal nodes in
871   * the merkle tree could be reinterpreted as a leaf value.
872   */
873   library MerkleProof {
874       /**
875       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
876       * defined by 'root'. For this, a 'proof' must be provided, containing
877       * sibling hashes on the branch from the leaf to the root of the tree. Each
878       * pair of leaves and each pair of pre-images are assumed to be sorted.
879       */
880       function verify(
881           bytes32[] memory proof,
882           bytes32 root,
883           bytes32 leaf
884       ) internal pure returns (bool) {
885           return processProof(proof, leaf) == root;
886       }
887 
888       /**
889       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
890       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
891       * hash matches the root of the tree. When processing the proof, the pairs
892       * of leafs & pre-images are assumed to be sorted.
893       *
894       * _Available since v4.4._
895       */
896       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
897           bytes32 computedHash = leaf;
898           for (uint256 i = 0; i < proof.length; i++) {
899               bytes32 proofElement = proof[i];
900               if (computedHash <= proofElement) {
901                   // Hash(current computed hash + current element of the proof)
902                   computedHash = _efficientHash(computedHash, proofElement);
903               } else {
904                   // Hash(current element of the proof + current computed hash)
905                   computedHash = _efficientHash(proofElement, computedHash);
906               }
907           }
908           return computedHash;
909       }
910 
911       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
912           assembly {
913               mstore(0x00, a)
914               mstore(0x20, b)
915               value := keccak256(0x00, 0x40)
916           }
917       }
918   }
919 
920 
921   // File: Allowlist.sol
922 
923   pragma solidity ^0.8.0;
924 
925   abstract contract Allowlist is Teams {
926     bytes32 public merkleRoot;
927     bool public onlyAllowlistMode = false;
928 
929     /**
930      * @dev Update merkle root to reflect changes in Allowlist
931      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
932      */
933     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
934       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
935       merkleRoot = _newMerkleRoot;
936     }
937 
938     /**
939      * @dev Check the proof of an address if valid for merkle root
940      * @param _to address to check for proof
941      * @param _merkleProof Proof of the address to validate against root and leaf
942      */
943     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
944       require(merkleRoot != 0, "Merkle root is not set!");
945       bytes32 leaf = keccak256(abi.encodePacked(_to));
946 
947       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
948     }
949 
950     
951     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
952       onlyAllowlistMode = true;
953     }
954 
955     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
956         onlyAllowlistMode = false;
957     }
958   }
959   
960   
961 /**
962  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
963  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
964  *
965  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
966  * 
967  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
968  *
969  * Does not support burning tokens to address(0).
970  */
971 contract ERC721A is
972   Context,
973   ERC165,
974   IERC721,
975   IERC721Metadata,
976   IERC721Enumerable,
977   Teams
978 {
979   using Address for address;
980   using Strings for uint256;
981 
982   struct TokenOwnership {
983     address addr;
984     uint64 startTimestamp;
985   }
986 
987   struct AddressData {
988     uint128 balance;
989     uint128 numberMinted;
990   }
991 
992   uint256 private currentIndex;
993 
994   uint256 public immutable collectionSize;
995   uint256 public maxBatchSize;
996 
997   // Token name
998   string private _name;
999 
1000   // Token symbol
1001   string private _symbol;
1002 
1003   // Mapping from token ID to ownership details
1004   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1005   mapping(uint256 => TokenOwnership) private _ownerships;
1006 
1007   // Mapping owner address to address data
1008   mapping(address => AddressData) private _addressData;
1009 
1010   // Mapping from token ID to approved address
1011   mapping(uint256 => address) private _tokenApprovals;
1012 
1013   // Mapping from owner to operator approvals
1014   mapping(address => mapping(address => bool)) private _operatorApprovals;
1015 
1016   /* @dev Mapping of restricted operator approvals set by contract Owner
1017   * This serves as an optional addition to ERC-721 so
1018   * that the contract owner can elect to prevent specific addresses/contracts
1019   * from being marked as the approver for a token. The reason for this
1020   * is that some projects may want to retain control of where their tokens can/can not be listed
1021   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1022   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1023   */
1024   mapping(address => bool) public restrictedApprovalAddresses;
1025 
1026   /**
1027    * @dev
1028    * maxBatchSize refers to how much a minter can mint at a time.
1029    * collectionSize_ refers to how many tokens are in the collection.
1030    */
1031   constructor(
1032     string memory name_,
1033     string memory symbol_,
1034     uint256 maxBatchSize_,
1035     uint256 collectionSize_
1036   ) {
1037     require(
1038       collectionSize_ > 0,
1039       "ERC721A: collection must have a nonzero supply"
1040     );
1041     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1042     _name = name_;
1043     _symbol = symbol_;
1044     maxBatchSize = maxBatchSize_;
1045     collectionSize = collectionSize_;
1046     currentIndex = _startTokenId();
1047   }
1048 
1049   /**
1050   * To change the starting tokenId, please override this function.
1051   */
1052   function _startTokenId() internal view virtual returns (uint256) {
1053     return 1;
1054   }
1055 
1056   /**
1057    * @dev See {IERC721Enumerable-totalSupply}.
1058    */
1059   function totalSupply() public view override returns (uint256) {
1060     return _totalMinted();
1061   }
1062 
1063   function currentTokenId() public view returns (uint256) {
1064     return _totalMinted();
1065   }
1066 
1067   function getNextTokenId() public view returns (uint256) {
1068       return _totalMinted() + 1;
1069   }
1070 
1071   /**
1072   * Returns the total amount of tokens minted in the contract.
1073   */
1074   function _totalMinted() internal view returns (uint256) {
1075     unchecked {
1076       return currentIndex - _startTokenId();
1077     }
1078   }
1079 
1080   /**
1081    * @dev See {IERC721Enumerable-tokenByIndex}.
1082    */
1083   function tokenByIndex(uint256 index) public view override returns (uint256) {
1084     require(index < totalSupply(), "ERC721A: global index out of bounds");
1085     return index;
1086   }
1087 
1088   /**
1089    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1090    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1091    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1092    */
1093   function tokenOfOwnerByIndex(address owner, uint256 index)
1094     public
1095     view
1096     override
1097     returns (uint256)
1098   {
1099     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1100     uint256 numMintedSoFar = totalSupply();
1101     uint256 tokenIdsIdx = 0;
1102     address currOwnershipAddr = address(0);
1103     for (uint256 i = 0; i < numMintedSoFar; i++) {
1104       TokenOwnership memory ownership = _ownerships[i];
1105       if (ownership.addr != address(0)) {
1106         currOwnershipAddr = ownership.addr;
1107       }
1108       if (currOwnershipAddr == owner) {
1109         if (tokenIdsIdx == index) {
1110           return i;
1111         }
1112         tokenIdsIdx++;
1113       }
1114     }
1115     revert("ERC721A: unable to get token of owner by index");
1116   }
1117 
1118   /**
1119    * @dev See {IERC165-supportsInterface}.
1120    */
1121   function supportsInterface(bytes4 interfaceId)
1122     public
1123     view
1124     virtual
1125     override(ERC165, IERC165)
1126     returns (bool)
1127   {
1128     return
1129       interfaceId == type(IERC721).interfaceId ||
1130       interfaceId == type(IERC721Metadata).interfaceId ||
1131       interfaceId == type(IERC721Enumerable).interfaceId ||
1132       super.supportsInterface(interfaceId);
1133   }
1134 
1135   /**
1136    * @dev See {IERC721-balanceOf}.
1137    */
1138   function balanceOf(address owner) public view override returns (uint256) {
1139     require(owner != address(0), "ERC721A: balance query for the zero address");
1140     return uint256(_addressData[owner].balance);
1141   }
1142 
1143   function _numberMinted(address owner) internal view returns (uint256) {
1144     require(
1145       owner != address(0),
1146       "ERC721A: number minted query for the zero address"
1147     );
1148     return uint256(_addressData[owner].numberMinted);
1149   }
1150 
1151   function ownershipOf(uint256 tokenId)
1152     internal
1153     view
1154     returns (TokenOwnership memory)
1155   {
1156     uint256 curr = tokenId;
1157 
1158     unchecked {
1159         if (_startTokenId() <= curr && curr < currentIndex) {
1160             TokenOwnership memory ownership = _ownerships[curr];
1161             if (ownership.addr != address(0)) {
1162                 return ownership;
1163             }
1164 
1165             // Invariant:
1166             // There will always be an ownership that has an address and is not burned
1167             // before an ownership that does not have an address and is not burned.
1168             // Hence, curr will not underflow.
1169             while (true) {
1170                 curr--;
1171                 ownership = _ownerships[curr];
1172                 if (ownership.addr != address(0)) {
1173                     return ownership;
1174                 }
1175             }
1176         }
1177     }
1178 
1179     revert("ERC721A: unable to determine the owner of token");
1180   }
1181 
1182   /**
1183    * @dev See {IERC721-ownerOf}.
1184    */
1185   function ownerOf(uint256 tokenId) public view override returns (address) {
1186     return ownershipOf(tokenId).addr;
1187   }
1188 
1189   /**
1190    * @dev See {IERC721Metadata-name}.
1191    */
1192   function name() public view virtual override returns (string memory) {
1193     return _name;
1194   }
1195 
1196   /**
1197    * @dev See {IERC721Metadata-symbol}.
1198    */
1199   function symbol() public view virtual override returns (string memory) {
1200     return _symbol;
1201   }
1202 
1203   /**
1204    * @dev See {IERC721Metadata-tokenURI}.
1205    */
1206   function tokenURI(uint256 tokenId)
1207     public
1208     view
1209     virtual
1210     override
1211     returns (string memory)
1212   {
1213     string memory baseURI = _baseURI();
1214     return
1215       bytes(baseURI).length > 0
1216         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1217         : "";
1218   }
1219 
1220   /**
1221    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1222    * token will be the concatenation of the baseURI and the tokenId. Empty
1223    * by default, can be overriden in child contracts.
1224    */
1225   function _baseURI() internal view virtual returns (string memory) {
1226     return "";
1227   }
1228 
1229   /**
1230    * @dev Sets the value for an address to be in the restricted approval address pool.
1231    * Setting an address to true will disable token owners from being able to mark the address
1232    * for approval for trading. This would be used in theory to prevent token owners from listing
1233    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1234    * @param _address the marketplace/user to modify restriction status of
1235    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1236    */
1237   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1238     restrictedApprovalAddresses[_address] = _isRestricted;
1239   }
1240 
1241   /**
1242    * @dev See {IERC721-approve}.
1243    */
1244   function approve(address to, uint256 tokenId) public override {
1245     address owner = ERC721A.ownerOf(tokenId);
1246     require(to != owner, "ERC721A: approval to current owner");
1247     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1248 
1249     require(
1250       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1251       "ERC721A: approve caller is not owner nor approved for all"
1252     );
1253 
1254     _approve(to, tokenId, owner);
1255   }
1256 
1257   /**
1258    * @dev See {IERC721-getApproved}.
1259    */
1260   function getApproved(uint256 tokenId) public view override returns (address) {
1261     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1262 
1263     return _tokenApprovals[tokenId];
1264   }
1265 
1266   /**
1267    * @dev See {IERC721-setApprovalForAll}.
1268    */
1269   function setApprovalForAll(address operator, bool approved) public override {
1270     require(operator != _msgSender(), "ERC721A: approve to caller");
1271     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1272 
1273     _operatorApprovals[_msgSender()][operator] = approved;
1274     emit ApprovalForAll(_msgSender(), operator, approved);
1275   }
1276 
1277   /**
1278    * @dev See {IERC721-isApprovedForAll}.
1279    */
1280   function isApprovedForAll(address owner, address operator)
1281     public
1282     view
1283     virtual
1284     override
1285     returns (bool)
1286   {
1287     return _operatorApprovals[owner][operator];
1288   }
1289 
1290   /**
1291    * @dev See {IERC721-transferFrom}.
1292    */
1293   function transferFrom(
1294     address from,
1295     address to,
1296     uint256 tokenId
1297   ) public override {
1298     _transfer(from, to, tokenId);
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-safeTransferFrom}.
1303    */
1304   function safeTransferFrom(
1305     address from,
1306     address to,
1307     uint256 tokenId
1308   ) public override {
1309     safeTransferFrom(from, to, tokenId, "");
1310   }
1311 
1312   /**
1313    * @dev See {IERC721-safeTransferFrom}.
1314    */
1315   function safeTransferFrom(
1316     address from,
1317     address to,
1318     uint256 tokenId,
1319     bytes memory _data
1320   ) public override {
1321     _transfer(from, to, tokenId);
1322     require(
1323       _checkOnERC721Received(from, to, tokenId, _data),
1324       "ERC721A: transfer to non ERC721Receiver implementer"
1325     );
1326   }
1327 
1328   /**
1329    * @dev Returns whether tokenId exists.
1330    *
1331    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1332    *
1333    * Tokens start existing when they are minted (_mint),
1334    */
1335   function _exists(uint256 tokenId) internal view returns (bool) {
1336     return _startTokenId() <= tokenId && tokenId < currentIndex;
1337   }
1338 
1339   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1340     _safeMint(to, quantity, isAdminMint, "");
1341   }
1342 
1343   /**
1344    * @dev Mints quantity tokens and transfers them to to.
1345    *
1346    * Requirements:
1347    *
1348    * - there must be quantity tokens remaining unminted in the total collection.
1349    * - to cannot be the zero address.
1350    * - quantity cannot be larger than the max batch size.
1351    *
1352    * Emits a {Transfer} event.
1353    */
1354   function _safeMint(
1355     address to,
1356     uint256 quantity,
1357     bool isAdminMint,
1358     bytes memory _data
1359   ) internal {
1360     uint256 startTokenId = currentIndex;
1361     require(to != address(0), "ERC721A: mint to the zero address");
1362     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1363     require(!_exists(startTokenId), "ERC721A: token already minted");
1364 
1365     // For admin mints we do not want to enforce the maxBatchSize limit
1366     if (isAdminMint == false) {
1367         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1368     }
1369 
1370     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1371 
1372     AddressData memory addressData = _addressData[to];
1373     _addressData[to] = AddressData(
1374       addressData.balance + uint128(quantity),
1375       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1376     );
1377     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1378 
1379     uint256 updatedIndex = startTokenId;
1380 
1381     for (uint256 i = 0; i < quantity; i++) {
1382       emit Transfer(address(0), to, updatedIndex);
1383       require(
1384         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1385         "ERC721A: transfer to non ERC721Receiver implementer"
1386       );
1387       updatedIndex++;
1388     }
1389 
1390     currentIndex = updatedIndex;
1391     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1392   }
1393 
1394   /**
1395    * @dev Transfers tokenId from from to to.
1396    *
1397    * Requirements:
1398    *
1399    * - to cannot be the zero address.
1400    * - tokenId token must be owned by from.
1401    *
1402    * Emits a {Transfer} event.
1403    */
1404   function _transfer(
1405     address from,
1406     address to,
1407     uint256 tokenId
1408   ) private {
1409     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1410 
1411     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1412       getApproved(tokenId) == _msgSender() ||
1413       isApprovedForAll(prevOwnership.addr, _msgSender()));
1414 
1415     require(
1416       isApprovedOrOwner,
1417       "ERC721A: transfer caller is not owner nor approved"
1418     );
1419 
1420     require(
1421       prevOwnership.addr == from,
1422       "ERC721A: transfer from incorrect owner"
1423     );
1424     require(to != address(0), "ERC721A: transfer to the zero address");
1425 
1426     _beforeTokenTransfers(from, to, tokenId, 1);
1427 
1428     // Clear approvals from the previous owner
1429     _approve(address(0), tokenId, prevOwnership.addr);
1430 
1431     _addressData[from].balance -= 1;
1432     _addressData[to].balance += 1;
1433     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1434 
1435     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1436     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1437     uint256 nextTokenId = tokenId + 1;
1438     if (_ownerships[nextTokenId].addr == address(0)) {
1439       if (_exists(nextTokenId)) {
1440         _ownerships[nextTokenId] = TokenOwnership(
1441           prevOwnership.addr,
1442           prevOwnership.startTimestamp
1443         );
1444       }
1445     }
1446 
1447     emit Transfer(from, to, tokenId);
1448     _afterTokenTransfers(from, to, tokenId, 1);
1449   }
1450 
1451   /**
1452    * @dev Approve to to operate on tokenId
1453    *
1454    * Emits a {Approval} event.
1455    */
1456   function _approve(
1457     address to,
1458     uint256 tokenId,
1459     address owner
1460   ) private {
1461     _tokenApprovals[tokenId] = to;
1462     emit Approval(owner, to, tokenId);
1463   }
1464 
1465   uint256 public nextOwnerToExplicitlySet = 0;
1466 
1467   /**
1468    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1469    */
1470   function _setOwnersExplicit(uint256 quantity) internal {
1471     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1472     require(quantity > 0, "quantity must be nonzero");
1473     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1474 
1475     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1476     if (endIndex > collectionSize - 1) {
1477       endIndex = collectionSize - 1;
1478     }
1479     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1480     require(_exists(endIndex), "not enough minted yet for this cleanup");
1481     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1482       if (_ownerships[i].addr == address(0)) {
1483         TokenOwnership memory ownership = ownershipOf(i);
1484         _ownerships[i] = TokenOwnership(
1485           ownership.addr,
1486           ownership.startTimestamp
1487         );
1488       }
1489     }
1490     nextOwnerToExplicitlySet = endIndex + 1;
1491   }
1492 
1493   /**
1494    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1495    * The call is not executed if the target address is not a contract.
1496    *
1497    * @param from address representing the previous owner of the given token ID
1498    * @param to target address that will receive the tokens
1499    * @param tokenId uint256 ID of the token to be transferred
1500    * @param _data bytes optional data to send along with the call
1501    * @return bool whether the call correctly returned the expected magic value
1502    */
1503   function _checkOnERC721Received(
1504     address from,
1505     address to,
1506     uint256 tokenId,
1507     bytes memory _data
1508   ) private returns (bool) {
1509     if (to.isContract()) {
1510       try
1511         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1512       returns (bytes4 retval) {
1513         return retval == IERC721Receiver(to).onERC721Received.selector;
1514       } catch (bytes memory reason) {
1515         if (reason.length == 0) {
1516           revert("ERC721A: transfer to non ERC721Receiver implementer");
1517         } else {
1518           assembly {
1519             revert(add(32, reason), mload(reason))
1520           }
1521         }
1522       }
1523     } else {
1524       return true;
1525     }
1526   }
1527 
1528   /**
1529    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1530    *
1531    * startTokenId - the first token id to be transferred
1532    * quantity - the amount to be transferred
1533    *
1534    * Calling conditions:
1535    *
1536    * - When from and to are both non-zero, from's tokenId will be
1537    * transferred to to.
1538    * - When from is zero, tokenId will be minted for to.
1539    */
1540   function _beforeTokenTransfers(
1541     address from,
1542     address to,
1543     uint256 startTokenId,
1544     uint256 quantity
1545   ) internal virtual {}
1546 
1547   /**
1548    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1549    * minting.
1550    *
1551    * startTokenId - the first token id to be transferred
1552    * quantity - the amount to be transferred
1553    *
1554    * Calling conditions:
1555    *
1556    * - when from and to are both non-zero.
1557    * - from and to are never both zero.
1558    */
1559   function _afterTokenTransfers(
1560     address from,
1561     address to,
1562     uint256 startTokenId,
1563     uint256 quantity
1564   ) internal virtual {}
1565 }
1566 
1567 
1568 
1569   
1570 abstract contract Ramppable {
1571   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1572 
1573   modifier isRampp() {
1574       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1575       _;
1576   }
1577 }
1578 
1579 
1580   
1581   
1582 interface IERC20 {
1583   function allowance(address owner, address spender) external view returns (uint256);
1584   function transfer(address _to, uint256 _amount) external returns (bool);
1585   function balanceOf(address account) external view returns (uint256);
1586   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1587 }
1588 
1589 // File: WithdrawableV2
1590 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1591 // ERC-20 Payouts are limited to a single payout address. This feature 
1592 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1593 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1594 abstract contract WithdrawableV2 is Teams, Ramppable {
1595   struct acceptedERC20 {
1596     bool isActive;
1597     uint256 chargeAmount;
1598   }
1599 
1600   
1601   mapping(address => acceptedERC20) private allowedTokenContracts;
1602   address[] public payableAddresses = [RAMPPADDRESS,0x5ed61dAd8db52645d6bEBc0Fd1eDe1269E85F053];
1603   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1604   address public erc20Payable = 0x5ed61dAd8db52645d6bEBc0Fd1eDe1269E85F053;
1605   uint256[] public payableFees = [0,100];
1606   uint256[] public surchargePayableFees = [100];
1607   uint256 public payableAddressCount = 2;
1608   uint256 public surchargePayableAddressCount = 1;
1609   uint256 public ramppSurchargeBalance = 0 ether;
1610   uint256 public ramppSurchargeFee = 0 ether;
1611   bool public onlyERC20MintingMode = false;
1612   
1613 
1614   /**
1615   * @dev Calculates the true payable balance of the contract as the
1616   * value on contract may be from ERC-20 mint surcharges and not 
1617   * public mint charges - which are not eligable for rev share & user withdrawl
1618   */
1619   function calcAvailableBalance() public view returns(uint256) {
1620     return address(this).balance - ramppSurchargeBalance;
1621   }
1622 
1623   function withdrawAll() public onlyTeamOrOwner {
1624       require(calcAvailableBalance() > 0);
1625       _withdrawAll();
1626   }
1627   
1628   function withdrawAllRampp() public isRampp {
1629       require(calcAvailableBalance() > 0);
1630       _withdrawAll();
1631   }
1632 
1633   function _withdrawAll() private {
1634       uint256 balance = calcAvailableBalance();
1635       
1636       for(uint i=0; i < payableAddressCount; i++ ) {
1637           _widthdraw(
1638               payableAddresses[i],
1639               (balance * payableFees[i]) / 100
1640           );
1641       }
1642   }
1643   
1644   function _widthdraw(address _address, uint256 _amount) private {
1645       (bool success, ) = _address.call{value: _amount}("");
1646       require(success, "Transfer failed.");
1647   }
1648 
1649   /**
1650   * @dev This function is similiar to the regular withdraw but operates only on the
1651   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1652   **/
1653   function _withdrawAllSurcharges() private {
1654     uint256 balance = ramppSurchargeBalance;
1655     if(balance == 0) { return; }
1656     
1657     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1658         _widthdraw(
1659             surchargePayableAddresses[i],
1660             (balance * surchargePayableFees[i]) / 100
1661         );
1662     }
1663     ramppSurchargeBalance = 0 ether;
1664   }
1665 
1666   /**
1667   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1668   * in the event ERC-20 tokens are paid to the contract for mints. This will
1669   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1670   * @param _tokenContract contract of ERC-20 token to withdraw
1671   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1672   */
1673   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1674     require(_amountToWithdraw > 0);
1675     IERC20 tokenContract = IERC20(_tokenContract);
1676     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1677     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1678     _withdrawAllSurcharges();
1679   }
1680 
1681   /**
1682   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1683   */
1684   function withdrawRamppSurcharges() public isRampp {
1685     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1686     _withdrawAllSurcharges();
1687   }
1688 
1689    /**
1690   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1691   */
1692   function addSurcharge() internal {
1693     ramppSurchargeBalance += ramppSurchargeFee;
1694   }
1695   
1696   /**
1697   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1698   */
1699   function hasSurcharge() internal returns(bool) {
1700     return msg.value == ramppSurchargeFee;
1701   }
1702 
1703   /**
1704   * @dev Set surcharge fee for using ERC-20 payments on contract
1705   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1706   */
1707   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1708     ramppSurchargeFee = _newSurcharge;
1709   }
1710 
1711   /**
1712   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1713   * @param _erc20TokenContract address of ERC-20 contract in question
1714   */
1715   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1716     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1717   }
1718 
1719   /**
1720   * @dev get the value of tokens to transfer for user of an ERC-20
1721   * @param _erc20TokenContract address of ERC-20 contract in question
1722   */
1723   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1724     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1725     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1726   }
1727 
1728   /**
1729   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1730   * @param _erc20TokenContract address of ERC-20 contract in question
1731   * @param _isActive default status of if contract should be allowed to accept payments
1732   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1733   */
1734   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1735     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1736     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1737   }
1738 
1739   /**
1740   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1741   * it will assume the default value of zero. This should not be used to create new payment tokens.
1742   * @param _erc20TokenContract address of ERC-20 contract in question
1743   */
1744   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1745     allowedTokenContracts[_erc20TokenContract].isActive = true;
1746   }
1747 
1748   /**
1749   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1750   * it will assume the default value of zero. This should not be used to create new payment tokens.
1751   * @param _erc20TokenContract address of ERC-20 contract in question
1752   */
1753   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1754     allowedTokenContracts[_erc20TokenContract].isActive = false;
1755   }
1756 
1757   /**
1758   * @dev Enable only ERC-20 payments for minting on this contract
1759   */
1760   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1761     onlyERC20MintingMode = true;
1762   }
1763 
1764   /**
1765   * @dev Disable only ERC-20 payments for minting on this contract
1766   */
1767   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1768     onlyERC20MintingMode = false;
1769   }
1770 
1771   /**
1772   * @dev Set the payout of the ERC-20 token payout to a specific address
1773   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1774   */
1775   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1776     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1777     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1778     erc20Payable = _newErc20Payable;
1779   }
1780 
1781   /**
1782   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1783   */
1784   function resetRamppSurchargeBalance() public isRampp {
1785     ramppSurchargeBalance = 0 ether;
1786   }
1787 
1788   /**
1789   * @dev Allows Rampp wallet to update its own reference as well as update
1790   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1791   * and since Rampp is always the first address this function is limited to the rampp payout only.
1792   * @param _newAddress updated Rampp Address
1793   */
1794   function setRamppAddress(address _newAddress) public isRampp {
1795     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1796     RAMPPADDRESS = _newAddress;
1797     payableAddresses[0] = _newAddress;
1798   }
1799 }
1800 
1801 
1802   
1803   
1804   
1805 // File: EarlyMintIncentive.sol
1806 // Allows the contract to have the first x tokens minted for a wallet at a discount or
1807 // zero fee that can be calculated on the fly.
1808 abstract contract EarlyMintIncentive is Teams, ERC721A {
1809   uint256 public PRICE = 0.005 ether;
1810   uint256 public EARLY_MINT_PRICE = 0.003 ether;
1811   uint256 public earlyMintOwnershipCap = 4;
1812   bool public usingEarlyMintIncentive = true;
1813 
1814   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1815     usingEarlyMintIncentive = true;
1816   }
1817 
1818   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1819     usingEarlyMintIncentive = false;
1820   }
1821 
1822   /**
1823   * @dev Set the max token ID in which the cost incentive will be applied.
1824   * @param _newCap max number of tokens wallet may mint for incentive price
1825   */
1826   function setEarlyMintOwnershipCap(uint256 _newCap) public onlyTeamOrOwner {
1827     require(_newCap >= 1, "Cannot set cap to less than 1");
1828     earlyMintOwnershipCap = _newCap;
1829   }
1830 
1831   /**
1832   * @dev Set the incentive mint price
1833   * @param _feeInWei new price per token when in incentive range
1834   */
1835   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1836     EARLY_MINT_PRICE = _feeInWei;
1837   }
1838 
1839   /**
1840   * @dev Set the primary mint price - the base price when not under incentive
1841   * @param _feeInWei new price per token
1842   */
1843   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1844     PRICE = _feeInWei;
1845   }
1846 
1847   function getPrice(uint256 _count) public view returns (uint256) {
1848     require(_count > 0, "Must be minting at least 1 token.");
1849 
1850     // short circuit function if we dont need to even calc incentive pricing
1851     // short circuit if the current wallet mint qty is also already over cap
1852     if(
1853       usingEarlyMintIncentive == false ||
1854       _numberMinted(msg.sender) > earlyMintOwnershipCap
1855     ) {
1856       return PRICE * _count;
1857     }
1858 
1859     uint256 endingTokenQty = _numberMinted(msg.sender) + _count;
1860     // If qty to mint results in a final qty less than or equal to the cap then
1861     // the entire qty is within incentive mint.
1862     if(endingTokenQty  <= earlyMintOwnershipCap) {
1863       return EARLY_MINT_PRICE * _count;
1864     }
1865 
1866     // If the current token qty is less than the incentive cap
1867     // and the ending token qty is greater than the incentive cap
1868     // we will be straddling the cap so there will be some amount
1869     // that are incentive and some that are regular fee.
1870     uint256 incentiveTokenCount = earlyMintOwnershipCap - _numberMinted(msg.sender);
1871     uint256 outsideIncentiveCount = endingTokenQty - earlyMintOwnershipCap;
1872 
1873     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1874   }
1875 }
1876 
1877   
1878 abstract contract RamppERC721A is 
1879     Ownable,
1880     Teams,
1881     ERC721A,
1882     WithdrawableV2,
1883     ReentrancyGuard 
1884     , EarlyMintIncentive 
1885     , Allowlist 
1886     
1887 {
1888   constructor(
1889     string memory tokenName,
1890     string memory tokenSymbol
1891   ) ERC721A(tokenName, tokenSymbol, 5, 10000) { }
1892     uint8 public CONTRACT_VERSION = 2;
1893     string public _baseTokenURI = "https://eyephunks.wtf/nfts/";
1894 
1895     bool public mintingOpen = false;
1896     
1897     
1898     uint256 public MAX_WALLET_MINTS = 10;
1899 
1900   
1901     /////////////// Admin Mint Functions
1902     /**
1903      * @dev Mints a token to an address with a tokenURI.
1904      * This is owner only and allows a fee-free drop
1905      * @param _to address of the future owner of the token
1906      * @param _qty amount of tokens to drop the owner
1907      */
1908      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1909          require(_qty > 0, "Must mint at least 1 token.");
1910          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1911          _safeMint(_to, _qty, true);
1912      }
1913 
1914   
1915     /////////////// GENERIC MINT FUNCTIONS
1916     /**
1917     * @dev Mints a single token to an address.
1918     * fee may or may not be required*
1919     * @param _to address of the future owner of the token
1920     */
1921     function mintTo(address _to) public payable {
1922         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1923         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1924         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1925         
1926         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1927         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1928         
1929         _safeMint(_to, 1, false);
1930     }
1931 
1932     /**
1933     * @dev Mints tokens to an address in batch.
1934     * fee may or may not be required*
1935     * @param _to address of the future owner of the token
1936     * @param _amount number of tokens to mint
1937     */
1938     function mintToMultiple(address _to, uint256 _amount) public payable {
1939         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1940         require(_amount >= 1, "Must mint at least 1 token");
1941         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1942         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1943         
1944         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1945         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
1946         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
1947 
1948         _safeMint(_to, _amount, false);
1949     }
1950 
1951     /**
1952      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1953      * fee may or may not be required*
1954      * @param _to address of the future owner of the token
1955      * @param _amount number of tokens to mint
1956      * @param _erc20TokenContract erc-20 token contract to mint with
1957      */
1958     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1959       require(_amount >= 1, "Must mint at least 1 token");
1960       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1961       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1962       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1963       
1964       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1965 
1966       // ERC-20 Specific pre-flight checks
1967       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1968       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1969       IERC20 payableToken = IERC20(_erc20TokenContract);
1970 
1971       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1972       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1973       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1974       
1975       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1976       require(transferComplete, "ERC-20 token was unable to be transferred");
1977       
1978       _safeMint(_to, _amount, false);
1979       addSurcharge();
1980     }
1981 
1982     function openMinting() public onlyTeamOrOwner {
1983         mintingOpen = true;
1984     }
1985 
1986     function stopMinting() public onlyTeamOrOwner {
1987         mintingOpen = false;
1988     }
1989 
1990   
1991     ///////////// ALLOWLIST MINTING FUNCTIONS
1992 
1993     /**
1994     * @dev Mints tokens to an address using an allowlist.
1995     * fee may or may not be required*
1996     * @param _to address of the future owner of the token
1997     * @param _merkleProof merkle proof array
1998     */
1999     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
2000         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2001         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2002         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2003         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
2004         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2005         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
2006         
2007 
2008         _safeMint(_to, 1, false);
2009     }
2010 
2011     /**
2012     * @dev Mints tokens to an address using an allowlist.
2013     * fee may or may not be required*
2014     * @param _to address of the future owner of the token
2015     * @param _amount number of tokens to mint
2016     * @param _merkleProof merkle proof array
2017     */
2018     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2019         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2020         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2021         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2022         require(_amount >= 1, "Must mint at least 1 token");
2023         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2024 
2025         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2026         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
2027         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2028         
2029 
2030         _safeMint(_to, _amount, false);
2031     }
2032 
2033     /**
2034     * @dev Mints tokens to an address using an allowlist.
2035     * fee may or may not be required*
2036     * @param _to address of the future owner of the token
2037     * @param _amount number of tokens to mint
2038     * @param _merkleProof merkle proof array
2039     * @param _erc20TokenContract erc-20 token contract to mint with
2040     */
2041     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2042       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2043       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2044       require(_amount >= 1, "Must mint at least 1 token");
2045       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2046       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2047       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
2048       
2049     
2050       // ERC-20 Specific pre-flight checks
2051       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2052       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2053       IERC20 payableToken = IERC20(_erc20TokenContract);
2054     
2055       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2056       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2057       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2058       
2059       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2060       require(transferComplete, "ERC-20 token was unable to be transferred");
2061       
2062       _safeMint(_to, _amount, false);
2063       addSurcharge();
2064     }
2065 
2066     /**
2067      * @dev Enable allowlist minting fully by enabling both flags
2068      * This is a convenience function for the Rampp user
2069      */
2070     function openAllowlistMint() public onlyTeamOrOwner {
2071         enableAllowlistOnlyMode();
2072         mintingOpen = true;
2073     }
2074 
2075     /**
2076      * @dev Close allowlist minting fully by disabling both flags
2077      * This is a convenience function for the Rampp user
2078      */
2079     function closeAllowlistMint() public onlyTeamOrOwner {
2080         disableAllowlistOnlyMode();
2081         mintingOpen = false;
2082     }
2083 
2084 
2085   
2086     /**
2087     * @dev Check if wallet over MAX_WALLET_MINTS
2088     * @param _address address in question to check if minted count exceeds max
2089     */
2090     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2091         require(_amount >= 1, "Amount must be greater than or equal to 1");
2092         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2093     }
2094 
2095     /**
2096     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2097     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2098     */
2099     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2100         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2101         MAX_WALLET_MINTS = _newWalletMax;
2102     }
2103     
2104 
2105   
2106     /**
2107      * @dev Allows owner to set Max mints per tx
2108      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2109      */
2110      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2111          require(_newMaxMint >= 1, "Max mint must be at least 1");
2112          maxBatchSize = _newMaxMint;
2113      }
2114     
2115 
2116   
2117 
2118   function _baseURI() internal view virtual override returns(string memory) {
2119     return _baseTokenURI;
2120   }
2121 
2122   function baseTokenURI() public view returns(string memory) {
2123     return _baseTokenURI;
2124   }
2125 
2126   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2127     _baseTokenURI = baseURI;
2128   }
2129 
2130   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2131     return ownershipOf(tokenId);
2132   }
2133 }
2134 
2135 
2136   
2137 // File: contracts/EyePhunksContract.sol
2138 //SPDX-License-Identifier: MIT
2139 
2140 pragma solidity ^0.8.0;
2141 
2142 contract EyePhunksContract is RamppERC721A {
2143     constructor() RamppERC721A("EyePhunks", "EYEPHUNKS"){}
2144 }
2145   