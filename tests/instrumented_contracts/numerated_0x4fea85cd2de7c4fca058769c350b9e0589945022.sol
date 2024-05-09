1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //
5 //                                      _   .-')                              ('-.                                        
6 //                                     ( '.( OO )_                          _(  OO)                                       
7 //                                      ,--.   ,--.)    ,-.-')    .-----.  (,------.                                      
8 //                                      |   `.'   |     |  |OO)  '  .--./   |  .---'                                      
9 //                                      |         |     |  |  \  |  |('-.   |  |                                          
10 //                                      |  |'.'|  |     |  |(_/ /_) |OO  ) (|  '--.                                       
11 //                                      |  |   |  |    ,|  |_.' ||  |`-'|   |  .--'                                       
12 //                                      |  |   |  |.-.(_|  |.-.(_'  '--'\.-.|  `---..-.                                   
13 //                                      `--'   `--'`-'  `--'`-'   `-----'`-'`------'`-'                                   
14 //             .-. .-')            .-') _     ('-.                  _  .-')                  ('-.     _ .-') _    .-')    
15 //             \  ( OO )          (  OO) )  _(  OO)                ( \( -O )                ( OO ).-.( (  OO) )  ( OO ).  
16 //  .-'),-----. ;-----.\   ,-.-') /     '._(,------.,--.            ,------.  .-'),-----.   / . --. / \     .'_ (_)---\_) 
17 // ( OO'  .-.  '| .-.  |   |  |OO)|'--...__)|  .---'|  |.-')        |   /`. '( OO'  .-.  '  | \-.  \  ,`'--..._)/    _ |  
18 // /   |  | |  || '-' /_)  |  |  \'--.  .--'|  |    |  | OO )       |  /  | |/   |  | |  |.-'-'  |  | |  |  \  '\  :` `.  
19 // \_) |  |\|  || .-. `.   |  |(_/   |  |  (|  '--. |  |`-' |       |  |_.' |\_) |  |\|  | \| |_.'  | |  |   ' | '..`''.) 
20 //   \ |  | |  || |  \  | ,|  |_.'   |  |   |  .--'(|  '---.'       |  .  '.'  \ |  | |  |  |  .-.  | |  |   / :.-._)   \ 
21 //    `'  '-'  '| '--'  /(_|  |      |  |   |  `---.|      |        |  |\  \    `'  '-'  '  |  | |  | |  '--'  /\       / 
22 //      `-----' `------'   `--'      `--'   `------'`------'        `--' '--'     `-----'   `--' `--' `-------'  `-----'  
23 //
24 //
25 // Dedicated to Nonna. My beloved daughter. With love, daddy =)
26 //
27 //
28 // Thanks rsivakov.eth, zhanna.eth, pictorom.eth, kekys.eth, xscript.eth, ann-von-pop.eth, timonsh.eth, yulsvkv.eth, steerpike.eth
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
1581 /** TimedDrop.sol
1582 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1583 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1584 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1585 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1586 */
1587 abstract contract TimedDrop is Teams {
1588   bool public enforcePublicDropTime = true;
1589   uint256 public publicDropTime = 1666299600;
1590   
1591   /**
1592   * @dev Allow the contract owner to set the public time to mint.
1593   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1594   */
1595   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1596     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disablePublicDropTime!");
1597     publicDropTime = _newDropTime;
1598   }
1599 
1600   function usePublicDropTime() public onlyTeamOrOwner {
1601     enforcePublicDropTime = true;
1602   }
1603 
1604   function disablePublicDropTime() public onlyTeamOrOwner {
1605     enforcePublicDropTime = false;
1606   }
1607 
1608   /**
1609   * @dev determine if the public droptime has passed.
1610   * if the feature is disabled then assume the time has passed.
1611   */
1612   function publicDropTimePassed() public view returns(bool) {
1613     if(enforcePublicDropTime == false) {
1614       return true;
1615     }
1616     return block.timestamp >= publicDropTime;
1617   }
1618   
1619   // Allowlist implementation of the Timed Drop feature
1620   bool public enforceAllowlistDropTime = true;
1621   uint256 public allowlistDropTime = 1665090000;
1622 
1623   /**
1624   * @dev Allow the contract owner to set the allowlist time to mint.
1625   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1626   */
1627   function setAllowlistDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1628     require(_newDropTime > block.timestamp, "Drop date must be in future! Otherwise call disableAllowlistDropTime!");
1629     allowlistDropTime = _newDropTime;
1630   }
1631 
1632   function useAllowlistDropTime() public onlyTeamOrOwner {
1633     enforceAllowlistDropTime = true;
1634   }
1635 
1636   function disableAllowlistDropTime() public onlyTeamOrOwner {
1637     enforceAllowlistDropTime = false;
1638   }
1639 
1640   function allowlistDropTimePassed() public view returns(bool) {
1641     if(enforceAllowlistDropTime == false) {
1642       return true;
1643     }
1644 
1645     return block.timestamp >= allowlistDropTime;
1646   }
1647 }
1648 
1649   
1650 interface IERC20 {
1651   function allowance(address owner, address spender) external view returns (uint256);
1652   function transfer(address _to, uint256 _amount) external returns (bool);
1653   function balanceOf(address account) external view returns (uint256);
1654   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1655 }
1656 
1657 // File: WithdrawableV2
1658 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1659 // ERC-20 Payouts are limited to a single payout address. This feature 
1660 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1661 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1662 abstract contract WithdrawableV2 is Teams, Ramppable {
1663   struct acceptedERC20 {
1664     bool isActive;
1665     uint256 chargeAmount;
1666   }
1667 
1668   
1669   mapping(address => acceptedERC20) private allowedTokenContracts;
1670   address[] public payableAddresses = [RAMPPADDRESS,0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0x6D1F9CF37Cfb93a2eC0125bA107a251F459cc575,0x8c96c028fC1D2FbEFb3916890e87a625a10fd9c1,0xb19109A88fAF69e988D700d3e0854b1C099eB844,0xb60920846701c2B8d8433CF26607f3C4c56587f8,0xeC4EC8D445A2902F790405901373fBa6a220cA5b,0x44C2f9f2478A2423E9864bE5F30f4078283b811D];
1671   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1672   address public erc20Payable = 0x6D1F9CF37Cfb93a2eC0125bA107a251F459cc575;
1673   uint256[] public payableFees = [1,4,5,75,5,3,2,5];
1674   uint256[] public surchargePayableFees = [100];
1675   uint256 public payableAddressCount = 8;
1676   uint256 public surchargePayableAddressCount = 1;
1677   uint256 public ramppSurchargeBalance = 0 ether;
1678   uint256 public ramppSurchargeFee = 0.001 ether;
1679   bool public onlyERC20MintingMode = false;
1680   
1681 
1682   /**
1683   * @dev Calculates the true payable balance of the contract as the
1684   * value on contract may be from ERC-20 mint surcharges and not 
1685   * public mint charges - which are not eligable for rev share & user withdrawl
1686   */
1687   function calcAvailableBalance() public view returns(uint256) {
1688     return address(this).balance - ramppSurchargeBalance;
1689   }
1690 
1691   function withdrawAll() public onlyTeamOrOwner {
1692       require(calcAvailableBalance() > 0);
1693       _withdrawAll();
1694   }
1695   
1696   function withdrawAllRampp() public isRampp {
1697       require(calcAvailableBalance() > 0);
1698       _withdrawAll();
1699   }
1700 
1701   function _withdrawAll() private {
1702       uint256 balance = calcAvailableBalance();
1703       
1704       for(uint i=0; i < payableAddressCount; i++ ) {
1705           _widthdraw(
1706               payableAddresses[i],
1707               (balance * payableFees[i]) / 100
1708           );
1709       }
1710   }
1711   
1712   function _widthdraw(address _address, uint256 _amount) private {
1713       (bool success, ) = _address.call{value: _amount}("");
1714       require(success, "Transfer failed.");
1715   }
1716 
1717   /**
1718   * @dev This function is similiar to the regular withdraw but operates only on the
1719   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1720   **/
1721   function _withdrawAllSurcharges() private {
1722     uint256 balance = ramppSurchargeBalance;
1723     if(balance == 0) { return; }
1724     
1725     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1726         _widthdraw(
1727             surchargePayableAddresses[i],
1728             (balance * surchargePayableFees[i]) / 100
1729         );
1730     }
1731     ramppSurchargeBalance = 0 ether;
1732   }
1733 
1734   /**
1735   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1736   * in the event ERC-20 tokens are paid to the contract for mints. This will
1737   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1738   * @param _tokenContract contract of ERC-20 token to withdraw
1739   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1740   */
1741   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1742     require(_amountToWithdraw > 0);
1743     IERC20 tokenContract = IERC20(_tokenContract);
1744     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1745     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1746     _withdrawAllSurcharges();
1747   }
1748 
1749   /**
1750   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1751   */
1752   function withdrawRamppSurcharges() public isRampp {
1753     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1754     _withdrawAllSurcharges();
1755   }
1756 
1757    /**
1758   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1759   */
1760   function addSurcharge() internal {
1761     ramppSurchargeBalance += ramppSurchargeFee;
1762   }
1763   
1764   /**
1765   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1766   */
1767   function hasSurcharge() internal returns(bool) {
1768     return msg.value == ramppSurchargeFee;
1769   }
1770 
1771   /**
1772   * @dev Set surcharge fee for using ERC-20 payments on contract
1773   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1774   */
1775   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1776     ramppSurchargeFee = _newSurcharge;
1777   }
1778 
1779   /**
1780   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1781   * @param _erc20TokenContract address of ERC-20 contract in question
1782   */
1783   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1784     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1785   }
1786 
1787   /**
1788   * @dev get the value of tokens to transfer for user of an ERC-20
1789   * @param _erc20TokenContract address of ERC-20 contract in question
1790   */
1791   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1792     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1793     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1794   }
1795 
1796   /**
1797   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1798   * @param _erc20TokenContract address of ERC-20 contract in question
1799   * @param _isActive default status of if contract should be allowed to accept payments
1800   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1801   */
1802   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1803     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1804     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1805   }
1806 
1807   /**
1808   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1809   * it will assume the default value of zero. This should not be used to create new payment tokens.
1810   * @param _erc20TokenContract address of ERC-20 contract in question
1811   */
1812   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1813     allowedTokenContracts[_erc20TokenContract].isActive = true;
1814   }
1815 
1816   /**
1817   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1818   * it will assume the default value of zero. This should not be used to create new payment tokens.
1819   * @param _erc20TokenContract address of ERC-20 contract in question
1820   */
1821   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1822     allowedTokenContracts[_erc20TokenContract].isActive = false;
1823   }
1824 
1825   /**
1826   * @dev Enable only ERC-20 payments for minting on this contract
1827   */
1828   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1829     onlyERC20MintingMode = true;
1830   }
1831 
1832   /**
1833   * @dev Disable only ERC-20 payments for minting on this contract
1834   */
1835   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1836     onlyERC20MintingMode = false;
1837   }
1838 
1839   /**
1840   * @dev Set the payout of the ERC-20 token payout to a specific address
1841   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1842   */
1843   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1844     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1845     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1846     erc20Payable = _newErc20Payable;
1847   }
1848 
1849   /**
1850   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1851   */
1852   function resetRamppSurchargeBalance() public isRampp {
1853     ramppSurchargeBalance = 0 ether;
1854   }
1855 
1856   /**
1857   * @dev Allows Rampp wallet to update its own reference as well as update
1858   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1859   * and since Rampp is always the first address this function is limited to the rampp payout only.
1860   * @param _newAddress updated Rampp Address
1861   */
1862   function setRamppAddress(address _newAddress) public isRampp {
1863     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1864     RAMPPADDRESS = _newAddress;
1865     payableAddresses[0] = _newAddress;
1866   }
1867 }
1868 
1869 
1870   
1871   
1872 // File: EarlyMintIncentive.sol
1873 // Allows the contract to have the first x tokens have a discount or
1874 // zero fee that can be calculated on the fly.
1875 abstract contract EarlyMintIncentive is Teams, ERC721A {
1876   uint256 public PRICE = 0.211 ether;
1877   uint256 public EARLY_MINT_PRICE = 0 ether;
1878   uint256 public earlyMintTokenIdCap = 5000;
1879   bool public usingEarlyMintIncentive = true;
1880 
1881   function enableEarlyMintIncentive() public onlyTeamOrOwner {
1882     usingEarlyMintIncentive = true;
1883   }
1884 
1885   function disableEarlyMintIncentive() public onlyTeamOrOwner {
1886     usingEarlyMintIncentive = false;
1887   }
1888 
1889   /**
1890   * @dev Set the max token ID in which the cost incentive will be applied.
1891   * @param _newTokenIdCap max tokenId in which incentive will be applied
1892   */
1893   function setEarlyMintTokenIdCap(uint256 _newTokenIdCap) public onlyTeamOrOwner {
1894     require(_newTokenIdCap <= collectionSize, "Cannot set incentive tokenId cap larger than totaly supply.");
1895     require(_newTokenIdCap >= 1, "Cannot set tokenId cap to less than the first token");
1896     earlyMintTokenIdCap = _newTokenIdCap;
1897   }
1898 
1899   /**
1900   * @dev Set the incentive mint price
1901   * @param _feeInWei new price per token when in incentive range
1902   */
1903   function setEarlyIncentivePrice(uint256 _feeInWei) public onlyTeamOrOwner {
1904     EARLY_MINT_PRICE = _feeInWei;
1905   }
1906 
1907   /**
1908   * @dev Set the primary mint price - the base price when not under incentive
1909   * @param _feeInWei new price per token
1910   */
1911   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1912     PRICE = _feeInWei;
1913   }
1914 
1915   function getPrice(uint256 _count) public view returns (uint256) {
1916     require(_count > 0, "Must be minting at least 1 token.");
1917 
1918     // short circuit function if we dont need to even calc incentive pricing
1919     // short circuit if the current tokenId is also already over cap
1920     if(
1921       usingEarlyMintIncentive == false ||
1922       currentTokenId() > earlyMintTokenIdCap
1923     ) {
1924       return PRICE * _count;
1925     }
1926 
1927     uint256 endingTokenId = currentTokenId() + _count;
1928     // If qty to mint results in a final token ID less than or equal to the cap then
1929     // the entire qty is within free mint.
1930     if(endingTokenId  <= earlyMintTokenIdCap) {
1931       return EARLY_MINT_PRICE * _count;
1932     }
1933 
1934     // If the current token id is less than the incentive cap
1935     // and the ending token ID is greater than the incentive cap
1936     // we will be straddling the cap so there will be some amount
1937     // that are incentive and some that are regular fee.
1938     uint256 incentiveTokenCount = earlyMintTokenIdCap - currentTokenId();
1939     uint256 outsideIncentiveCount = endingTokenId - earlyMintTokenIdCap;
1940 
1941     return (EARLY_MINT_PRICE * incentiveTokenCount) + (PRICE * outsideIncentiveCount);
1942   }
1943 }
1944 
1945   
1946   
1947 abstract contract RamppERC721A is 
1948     Ownable,
1949     Teams,
1950     ERC721A,
1951     WithdrawableV2,
1952     ReentrancyGuard 
1953     , EarlyMintIncentive 
1954     , Allowlist 
1955     , TimedDrop
1956 {
1957   constructor(
1958     string memory tokenName,
1959     string memory tokenSymbol
1960   ) ERC721A(tokenName, tokenSymbol, 1, 10000) { }
1961     uint8 public CONTRACT_VERSION = 2;
1962     string public _baseTokenURI = "ipfs://bafybeib4c4kflkxajcm6v23g3hv6iee24t2a6lhdz7iqpoepa4frrk2nqa/";
1963 
1964     bool public mintingOpen = false;
1965     bool public isRevealed = false;
1966     
1967     uint256 public MAX_WALLET_MINTS = 1;
1968 
1969   
1970     /////////////// Admin Mint Functions
1971     /**
1972      * @dev Mints a token to an address with a tokenURI.
1973      * This is owner only and allows a fee-free drop
1974      * @param _to address of the future owner of the token
1975      * @param _qty amount of tokens to drop the owner
1976      */
1977      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1978          require(_qty > 0, "Must mint at least 1 token.");
1979          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 10000");
1980          _safeMint(_to, _qty, true);
1981      }
1982 
1983   
1984     /////////////// GENERIC MINT FUNCTIONS
1985     /**
1986     * @dev Mints a single token to an address.
1987     * fee may or may not be required*
1988     * @param _to address of the future owner of the token
1989     */
1990     function mintTo(address _to) public payable {
1991         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1992         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
1993         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1994         require(publicDropTimePassed() == true, "Public drop time has not passed!");
1995         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1996         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
1997         
1998         _safeMint(_to, 1, false);
1999     }
2000 
2001     /**
2002     * @dev Mints tokens to an address in batch.
2003     * fee may or may not be required*
2004     * @param _to address of the future owner of the token
2005     * @param _amount number of tokens to mint
2006     */
2007     function mintToMultiple(address _to, uint256 _amount) public payable {
2008         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2009         require(_amount >= 1, "Must mint at least 1 token");
2010         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2011         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2012         require(publicDropTimePassed() == true, "Public drop time has not passed!");
2013         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2014         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
2015         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2016 
2017         _safeMint(_to, _amount, false);
2018     }
2019 
2020     /**
2021      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
2022      * fee may or may not be required*
2023      * @param _to address of the future owner of the token
2024      * @param _amount number of tokens to mint
2025      * @param _erc20TokenContract erc-20 token contract to mint with
2026      */
2027     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
2028       require(_amount >= 1, "Must mint at least 1 token");
2029       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2030       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
2031       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
2032       require(publicDropTimePassed() == true, "Public drop time has not passed!");
2033       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2034 
2035       // ERC-20 Specific pre-flight checks
2036       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2037       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2038       IERC20 payableToken = IERC20(_erc20TokenContract);
2039 
2040       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2041       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2042       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2043       
2044       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2045       require(transferComplete, "ERC-20 token was unable to be transferred");
2046       
2047       _safeMint(_to, _amount, false);
2048       addSurcharge();
2049     }
2050 
2051     function openMinting() public onlyTeamOrOwner {
2052         mintingOpen = true;
2053     }
2054 
2055     function stopMinting() public onlyTeamOrOwner {
2056         mintingOpen = false;
2057     }
2058 
2059   
2060     ///////////// ALLOWLIST MINTING FUNCTIONS
2061 
2062     /**
2063     * @dev Mints tokens to an address using an allowlist.
2064     * fee may or may not be required*
2065     * @param _to address of the future owner of the token
2066     * @param _merkleProof merkle proof array
2067     */
2068     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
2069         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2070         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2071         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2072         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 10000");
2073         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
2074         require(msg.value == getPrice(1), "Value needs to be exactly the mint fee!");
2075         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2076 
2077         _safeMint(_to, 1, false);
2078     }
2079 
2080     /**
2081     * @dev Mints tokens to an address using an allowlist.
2082     * fee may or may not be required*
2083     * @param _to address of the future owner of the token
2084     * @param _amount number of tokens to mint
2085     * @param _merkleProof merkle proof array
2086     */
2087     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
2088         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
2089         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2090         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2091         require(_amount >= 1, "Must mint at least 1 token");
2092         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2093 
2094         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2095         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
2096         require(msg.value == getPrice(_amount), "Value below required mint fee for amount");
2097         require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2098 
2099         _safeMint(_to, _amount, false);
2100     }
2101 
2102     /**
2103     * @dev Mints tokens to an address using an allowlist.
2104     * fee may or may not be required*
2105     * @param _to address of the future owner of the token
2106     * @param _amount number of tokens to mint
2107     * @param _merkleProof merkle proof array
2108     * @param _erc20TokenContract erc-20 token contract to mint with
2109     */
2110     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
2111       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
2112       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
2113       require(_amount >= 1, "Must mint at least 1 token");
2114       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
2115       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
2116       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 10000");
2117       require(allowlistDropTimePassed() == true, "Allowlist drop time has not passed!");
2118     
2119       // ERC-20 Specific pre-flight checks
2120       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2121       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2122       IERC20 payableToken = IERC20(_erc20TokenContract);
2123     
2124       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2125       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2126       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2127       
2128       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2129       require(transferComplete, "ERC-20 token was unable to be transferred");
2130       
2131       _safeMint(_to, _amount, false);
2132       addSurcharge();
2133     }
2134 
2135     /**
2136      * @dev Enable allowlist minting fully by enabling both flags
2137      * This is a convenience function for the Rampp user
2138      */
2139     function openAllowlistMint() public onlyTeamOrOwner {
2140         enableAllowlistOnlyMode();
2141         mintingOpen = true;
2142     }
2143 
2144     /**
2145      * @dev Close allowlist minting fully by disabling both flags
2146      * This is a convenience function for the Rampp user
2147      */
2148     function closeAllowlistMint() public onlyTeamOrOwner {
2149         disableAllowlistOnlyMode();
2150         mintingOpen = false;
2151     }
2152 
2153 
2154   
2155     /**
2156     * @dev Check if wallet over MAX_WALLET_MINTS
2157     * @param _address address in question to check if minted count exceeds max
2158     */
2159     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2160         require(_amount >= 1, "Amount must be greater than or equal to 1");
2161         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2162     }
2163 
2164     /**
2165     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2166     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2167     */
2168     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2169         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2170         MAX_WALLET_MINTS = _newWalletMax;
2171     }
2172     
2173 
2174   
2175     /**
2176      * @dev Allows owner to set Max mints per tx
2177      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2178      */
2179      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2180          require(_newMaxMint >= 1, "Max mint must be at least 1");
2181          maxBatchSize = _newMaxMint;
2182      }
2183     
2184 
2185   
2186     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2187         require(isRevealed == false, "Tokens are already unveiled");
2188         _baseTokenURI = _updatedTokenURI;
2189         isRevealed = true;
2190     }
2191     
2192 
2193   function _baseURI() internal view virtual override returns(string memory) {
2194     return _baseTokenURI;
2195   }
2196 
2197   function baseTokenURI() public view returns(string memory) {
2198     return _baseTokenURI;
2199   }
2200 
2201   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2202     _baseTokenURI = baseURI;
2203   }
2204 
2205   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2206     return ownershipOf(tokenId);
2207   }
2208 }
2209 
2210 
2211   
2212 // File: contracts/MiceContract.sol
2213 //SPDX-License-Identifier: MIT
2214 
2215 pragma solidity ^0.8.0;
2216 
2217 contract MiceContract is RamppERC721A {
2218     constructor() RamppERC721A("MICE", "MICE"){}
2219 }
2220   
2221 //*********************************************************************//
2222 //*********************************************************************//  
2223 //                       Mintplex v2.1.0
2224 //
2225 //         This smart contract was generated by mintplex.xyz.
2226 //            Mintplex allows creators like you to launch 
2227 //             large scale NFT communities without code!
2228 //
2229 //    Mintplex is not responsible for the content of this contract and
2230 //        hopes it is being used in a responsible and kind way.  
2231 //       Mintplex is not associated or affiliated with this project.                                                    
2232 //             Twitter: @MintplexNFT ---- mintplex.xyz
2233 //*********************************************************************//                                                     
2234 //*********************************************************************//