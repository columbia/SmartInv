1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 //  ▄████▄   ██▀███ ▓██   ██▓ ██▓███  ▄▄▄█████▓ ▒█████  ▓█████▄  ██▓ ▄████▄   ██ ▄█▀ ▄▄▄▄    █    ██  ██▀███   ▄▄▄▄   ▒███████▒
5 // ▒██▀ ▀█  ▓██ ▒ ██▒▒██  ██▒▓██░  ██▒▓  ██▒ ▓▒▒██▒  ██▒▒██▀ ██▌▓██▒▒██▀ ▀█   ██▄█▒ ▓█████▄  ██  ▓██▒▓██ ▒ ██▒▓█████▄ ▒ ▒ ▒ ▄▀░
6 // ▒▓█    ▄ ▓██ ░▄█ ▒ ▒██ ██░▓██░ ██▓▒▒ ▓██░ ▒░▒██░  ██▒░██   █▌▒██▒▒▓█    ▄ ▓███▄░ ▒██▒ ▄██▓██  ▒██░▓██ ░▄█ ▒▒██▒ ▄██░ ▒ ▄▀▒░ 
7 // ▒▓▓▄ ▄██▒▒██▀▀█▄   ░ ▐██▓░▒██▄█▓▒ ▒░ ▓██▓ ░ ▒██   ██░░▓█▄   ▌░██░▒▓▓▄ ▄██▒▓██ █▄ ▒██░█▀  ▓▓█  ░██░▒██▀▀█▄  ▒██░█▀    ▄▀▒   ░
8 // ▒ ▓███▀ ░░██▓ ▒██▒ ░ ██▒▓░▒██▒ ░  ░  ▒██▒ ░ ░ ████▓▒░░▒████▓ ░██░▒ ▓███▀ ░▒██▒ █▄░▓█  ▀█▓▒▒█████▓ ░██▓ ▒██▒░▓█  ▀█▓▒███████▒
9 // ░ ░▒ ▒  ░░ ▒▓ ░▒▓░  ██▒▒▒ ▒▓▒░ ░  ░  ▒ ░░   ░ ▒░▒░▒░  ▒▒▓  ▒ ░▓  ░ ░▒ ▒  ░▒ ▒▒ ▓▒░▒▓███▀▒░▒▓▒ ▒ ▒ ░ ▒▓ ░▒▓░░▒▓███▀▒░▒▒ ▓░▒░▒
10 //   ░  ▒     ░▒ ░ ▒░▓██ ░▒░ ░▒ ░         ░      ░ ▒ ▒░  ░ ▒  ▒  ▒ ░  ░  ▒   ░ ░▒ ▒░▒░▒   ░ ░░▒░ ░ ░   ░▒ ░ ▒░▒░▒   ░ ░░▒ ▒ ░ ▒
11 // ░          ░░   ░ ▒ ▒ ░░  ░░         ░      ░ ░ ░ ▒   ░ ░  ░  ▒ ░░        ░ ░░ ░  ░    ░  ░░░ ░ ░   ░░   ░  ░    ░ ░ ░ ░ ░ ░
12 // ░ ░         ░     ░ ░                           ░ ░     ░     ░  ░ ░      ░  ░    ░         ░        ░      ░        ░ ░    
13 // ░                 ░ ░                                 ░          ░                     ░                         ░ ░  
14 //
15 //*********************************************************************//
16 //*********************************************************************//
17   
18 //-------------DEPENDENCIES--------------------------//
19 
20 // File: @openzeppelin/contracts/utils/Address.sol
21 
22 
23 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
24 
25 pragma solidity ^0.8.1;
26 
27 /**
28  * @dev Collection of functions related to the address type
29  */
30 library Address {
31     /**
32      * @dev Returns true if account is a contract.
33      *
34      * [IMPORTANT]
35      * ====
36      * It is unsafe to assume that an address for which this function returns
37      * false is an externally-owned account (EOA) and not a contract.
38      *
39      * Among others, isContract will return false for the following
40      * types of addresses:
41      *
42      *  - an externally-owned account
43      *  - a contract in construction
44      *  - an address where a contract will be created
45      *  - an address where a contract lived, but was destroyed
46      * ====
47      *
48      * [IMPORTANT]
49      * ====
50      * You shouldn't rely on isContract to protect against flash loan attacks!
51      *
52      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
53      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
54      * constructor.
55      * ====
56      */
57     function isContract(address account) internal view returns (bool) {
58         // This method relies on extcodesize/address.code.length, which returns 0
59         // for contracts in construction, since the code is only stored at the end
60         // of the constructor execution.
61 
62         return account.code.length > 0;
63     }
64 
65     /**
66      * @dev Replacement for Solidity's transfer: sends amount wei to
67      * recipient, forwarding all available gas and reverting on errors.
68      *
69      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
70      * of certain opcodes, possibly making contracts go over the 2300 gas limit
71      * imposed by transfer, making them unable to receive funds via
72      * transfer. {sendValue} removes this limitation.
73      *
74      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
75      *
76      * IMPORTANT: because control is transferred to recipient, care must be
77      * taken to not create reentrancy vulnerabilities. Consider using
78      * {ReentrancyGuard} or the
79      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
80      */
81     function sendValue(address payable recipient, uint256 amount) internal {
82         require(address(this).balance >= amount, "Address: insufficient balance");
83 
84         (bool success, ) = recipient.call{value: amount}("");
85         require(success, "Address: unable to send value, recipient may have reverted");
86     }
87 
88     /**
89      * @dev Performs a Solidity function call using a low level call. A
90      * plain call is an unsafe replacement for a function call: use this
91      * function instead.
92      *
93      * If target reverts with a revert reason, it is bubbled up by this
94      * function (like regular Solidity function calls).
95      *
96      * Returns the raw returned data. To convert to the expected return value,
97      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
98      *
99      * Requirements:
100      *
101      * - target must be a contract.
102      * - calling target with data must not revert.
103      *
104      * _Available since v3.1._
105      */
106     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
107         return functionCall(target, data, "Address: low-level call failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
112      * errorMessage as a fallback revert reason when target reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCall(
117         address target,
118         bytes memory data,
119         string memory errorMessage
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, 0, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
126      * but also transferring value wei to target.
127      *
128      * Requirements:
129      *
130      * - the calling contract must have an ETH balance of at least value.
131      * - the called Solidity function must be payable.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(
136         address target,
137         bytes memory data,
138         uint256 value
139     ) internal returns (bytes memory) {
140         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
145      * with errorMessage as a fallback revert reason when target reverts.
146      *
147      * _Available since v3.1._
148      */
149     function functionCallWithValue(
150         address target,
151         bytes memory data,
152         uint256 value,
153         string memory errorMessage
154     ) internal returns (bytes memory) {
155         require(address(this).balance >= value, "Address: insufficient balance for call");
156         require(isContract(target), "Address: call to non-contract");
157 
158         (bool success, bytes memory returndata) = target.call{value: value}(data);
159         return verifyCallResult(success, returndata, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
164      * but performing a static call.
165      *
166      * _Available since v3.3._
167      */
168     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
169         return functionStaticCall(target, data, "Address: low-level static call failed");
170     }
171 
172     /**
173      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
174      * but performing a static call.
175      *
176      * _Available since v3.3._
177      */
178     function functionStaticCall(
179         address target,
180         bytes memory data,
181         string memory errorMessage
182     ) internal view returns (bytes memory) {
183         require(isContract(target), "Address: static call to non-contract");
184 
185         (bool success, bytes memory returndata) = target.staticcall(data);
186         return verifyCallResult(success, returndata, errorMessage);
187     }
188 
189     /**
190      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
191      * but performing a delegate call.
192      *
193      * _Available since v3.4._
194      */
195     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
196         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
197     }
198 
199     /**
200      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
201      * but performing a delegate call.
202      *
203      * _Available since v3.4._
204      */
205     function functionDelegateCall(
206         address target,
207         bytes memory data,
208         string memory errorMessage
209     ) internal returns (bytes memory) {
210         require(isContract(target), "Address: delegate call to non-contract");
211 
212         (bool success, bytes memory returndata) = target.delegatecall(data);
213         return verifyCallResult(success, returndata, errorMessage);
214     }
215 
216     /**
217      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
218      * revert reason using the provided one.
219      *
220      * _Available since v4.3._
221      */
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 assembly {
235                     let returndata_size := mload(returndata)
236                     revert(add(32, returndata), returndata_size)
237                 }
238             } else {
239                 revert(errorMessage);
240             }
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title ERC721 token receiver interface
254  * @dev Interface for any contract that wants to support safeTransfers
255  * from ERC721 asset contracts.
256  */
257 interface IERC721Receiver {
258     /**
259      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
260      * by operator from from, this function is called.
261      *
262      * It must return its Solidity selector to confirm the token transfer.
263      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
264      *
265      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
266      */
267     function onERC721Received(
268         address operator,
269         address from,
270         uint256 tokenId,
271         bytes calldata data
272     ) external returns (bytes4);
273 }
274 
275 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
276 
277 
278 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
279 
280 pragma solidity ^0.8.0;
281 
282 /**
283  * @dev Interface of the ERC165 standard, as defined in the
284  * https://eips.ethereum.org/EIPS/eip-165[EIP].
285  *
286  * Implementers can declare support of contract interfaces, which can then be
287  * queried by others ({ERC165Checker}).
288  *
289  * For an implementation, see {ERC165}.
290  */
291 interface IERC165 {
292     /**
293      * @dev Returns true if this contract implements the interface defined by
294      * interfaceId. See the corresponding
295      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
296      * to learn more about how these ids are created.
297      *
298      * This function call must use less than 30 000 gas.
299      */
300     function supportsInterface(bytes4 interfaceId) external view returns (bool);
301 }
302 
303 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 
311 /**
312  * @dev Implementation of the {IERC165} interface.
313  *
314  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
315  * for the additional interface id that will be supported. For example:
316  *
317  * solidity
318  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
319  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
320  * }
321  * 
322  *
323  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
324  */
325 abstract contract ERC165 is IERC165 {
326     /**
327      * @dev See {IERC165-supportsInterface}.
328      */
329     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
330         return interfaceId == type(IERC165).interfaceId;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
335 
336 
337 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Required interface of an ERC721 compliant contract.
344  */
345 interface IERC721 is IERC165 {
346     /**
347      * @dev Emitted when tokenId token is transferred from from to to.
348      */
349     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
350 
351     /**
352      * @dev Emitted when owner enables approved to manage the tokenId token.
353      */
354     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
355 
356     /**
357      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
358      */
359     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
360 
361     /**
362      * @dev Returns the number of tokens in owner's account.
363      */
364     function balanceOf(address owner) external view returns (uint256 balance);
365 
366     /**
367      * @dev Returns the owner of the tokenId token.
368      *
369      * Requirements:
370      *
371      * - tokenId must exist.
372      */
373     function ownerOf(uint256 tokenId) external view returns (address owner);
374 
375     /**
376      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
378      *
379      * Requirements:
380      *
381      * - from cannot be the zero address.
382      * - to cannot be the zero address.
383      * - tokenId token must exist and be owned by from.
384      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
385      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
386      *
387      * Emits a {Transfer} event.
388      */
389     function safeTransferFrom(
390         address from,
391         address to,
392         uint256 tokenId
393     ) external;
394 
395     /**
396      * @dev Transfers tokenId token from from to to.
397      *
398      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
399      *
400      * Requirements:
401      *
402      * - from cannot be the zero address.
403      * - to cannot be the zero address.
404      * - tokenId token must be owned by from.
405      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
406      *
407      * Emits a {Transfer} event.
408      */
409     function transferFrom(
410         address from,
411         address to,
412         uint256 tokenId
413     ) external;
414 
415     /**
416      * @dev Gives permission to to to transfer tokenId token to another account.
417      * The approval is cleared when the token is transferred.
418      *
419      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
420      *
421      * Requirements:
422      *
423      * - The caller must own the token or be an approved operator.
424      * - tokenId must exist.
425      *
426      * Emits an {Approval} event.
427      */
428     function approve(address to, uint256 tokenId) external;
429 
430     /**
431      * @dev Returns the account approved for tokenId token.
432      *
433      * Requirements:
434      *
435      * - tokenId must exist.
436      */
437     function getApproved(uint256 tokenId) external view returns (address operator);
438 
439     /**
440      * @dev Approve or remove operator as an operator for the caller.
441      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
442      *
443      * Requirements:
444      *
445      * - The operator cannot be the caller.
446      *
447      * Emits an {ApprovalForAll} event.
448      */
449     function setApprovalForAll(address operator, bool _approved) external;
450 
451     /**
452      * @dev Returns if the operator is allowed to manage all of the assets of owner.
453      *
454      * See {setApprovalForAll}
455      */
456     function isApprovedForAll(address owner, address operator) external view returns (bool);
457 
458     /**
459      * @dev Safely transfers tokenId token from from to to.
460      *
461      * Requirements:
462      *
463      * - from cannot be the zero address.
464      * - to cannot be the zero address.
465      * - tokenId token must exist and be owned by from.
466      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
468      *
469      * Emits a {Transfer} event.
470      */
471     function safeTransferFrom(
472         address from,
473         address to,
474         uint256 tokenId,
475         bytes calldata data
476     ) external;
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 
487 /**
488  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
489  * @dev See https://eips.ethereum.org/EIPS/eip-721
490  */
491 interface IERC721Enumerable is IERC721 {
492     /**
493      * @dev Returns the total amount of tokens stored by the contract.
494      */
495     function totalSupply() external view returns (uint256);
496 
497     /**
498      * @dev Returns a token ID owned by owner at a given index of its token list.
499      * Use along with {balanceOf} to enumerate all of owner's tokens.
500      */
501     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
502 
503     /**
504      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
505      * Use along with {totalSupply} to enumerate all tokens.
506      */
507     function tokenByIndex(uint256 index) external view returns (uint256);
508 }
509 
510 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
520  * @dev See https://eips.ethereum.org/EIPS/eip-721
521  */
522 interface IERC721Metadata is IERC721 {
523     /**
524      * @dev Returns the token collection name.
525      */
526     function name() external view returns (string memory);
527 
528     /**
529      * @dev Returns the token collection symbol.
530      */
531     function symbol() external view returns (string memory);
532 
533     /**
534      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
535      */
536     function tokenURI(uint256 tokenId) external view returns (string memory);
537 }
538 
539 // File: @openzeppelin/contracts/utils/Strings.sol
540 
541 
542 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
543 
544 pragma solidity ^0.8.0;
545 
546 /**
547  * @dev String operations.
548  */
549 library Strings {
550     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
551 
552     /**
553      * @dev Converts a uint256 to its ASCII string decimal representation.
554      */
555     function toString(uint256 value) internal pure returns (string memory) {
556         // Inspired by OraclizeAPI's implementation - MIT licence
557         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
558 
559         if (value == 0) {
560             return "0";
561         }
562         uint256 temp = value;
563         uint256 digits;
564         while (temp != 0) {
565             digits++;
566             temp /= 10;
567         }
568         bytes memory buffer = new bytes(digits);
569         while (value != 0) {
570             digits -= 1;
571             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
572             value /= 10;
573         }
574         return string(buffer);
575     }
576 
577     /**
578      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
579      */
580     function toHexString(uint256 value) internal pure returns (string memory) {
581         if (value == 0) {
582             return "0x00";
583         }
584         uint256 temp = value;
585         uint256 length = 0;
586         while (temp != 0) {
587             length++;
588             temp >>= 8;
589         }
590         return toHexString(value, length);
591     }
592 
593     /**
594      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
595      */
596     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
597         bytes memory buffer = new bytes(2 * length + 2);
598         buffer[0] = "0";
599         buffer[1] = "x";
600         for (uint256 i = 2 * length + 1; i > 1; --i) {
601             buffer[i] = _HEX_SYMBOLS[value & 0xf];
602             value >>= 4;
603         }
604         require(value == 0, "Strings: hex length insufficient");
605         return string(buffer);
606     }
607 }
608 
609 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
610 
611 
612 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @dev Contract module that helps prevent reentrant calls to a function.
618  *
619  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
620  * available, which can be applied to functions to make sure there are no nested
621  * (reentrant) calls to them.
622  *
623  * Note that because there is a single nonReentrant guard, functions marked as
624  * nonReentrant may not call one another. This can be worked around by making
625  * those functions private, and then adding external nonReentrant entry
626  * points to them.
627  *
628  * TIP: If you would like to learn more about reentrancy and alternative ways
629  * to protect against it, check out our blog post
630  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
631  */
632 abstract contract ReentrancyGuard {
633     // Booleans are more expensive than uint256 or any type that takes up a full
634     // word because each write operation emits an extra SLOAD to first read the
635     // slot's contents, replace the bits taken up by the boolean, and then write
636     // back. This is the compiler's defense against contract upgrades and
637     // pointer aliasing, and it cannot be disabled.
638 
639     // The values being non-zero value makes deployment a bit more expensive,
640     // but in exchange the refund on every call to nonReentrant will be lower in
641     // amount. Since refunds are capped to a percentage of the total
642     // transaction's gas, it is best to keep them low in cases like this one, to
643     // increase the likelihood of the full refund coming into effect.
644     uint256 private constant _NOT_ENTERED = 1;
645     uint256 private constant _ENTERED = 2;
646 
647     uint256 private _status;
648 
649     constructor() {
650         _status = _NOT_ENTERED;
651     }
652 
653     /**
654      * @dev Prevents a contract from calling itself, directly or indirectly.
655      * Calling a nonReentrant function from another nonReentrant
656      * function is not supported. It is possible to prevent this from happening
657      * by making the nonReentrant function external, and making it call a
658      * private function that does the actual work.
659      */
660     modifier nonReentrant() {
661         // On the first call to nonReentrant, _notEntered will be true
662         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
663 
664         // Any calls to nonReentrant after this point will fail
665         _status = _ENTERED;
666 
667         _;
668 
669         // By storing the original value once again, a refund is triggered (see
670         // https://eips.ethereum.org/EIPS/eip-2200)
671         _status = _NOT_ENTERED;
672     }
673 }
674 
675 // File: @openzeppelin/contracts/utils/Context.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Provides information about the current execution context, including the
684  * sender of the transaction and its data. While these are generally available
685  * via msg.sender and msg.data, they should not be accessed in such a direct
686  * manner, since when dealing with meta-transactions the account sending and
687  * paying for execution may not be the actual sender (as far as an application
688  * is concerned).
689  *
690  * This contract is only required for intermediate, library-like contracts.
691  */
692 abstract contract Context {
693     function _msgSender() internal view virtual returns (address) {
694         return msg.sender;
695     }
696 
697     function _msgData() internal view virtual returns (bytes calldata) {
698         return msg.data;
699     }
700 }
701 
702 // File: @openzeppelin/contracts/access/Ownable.sol
703 
704 
705 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
706 
707 pragma solidity ^0.8.0;
708 
709 
710 /**
711  * @dev Contract module which provides a basic access control mechanism, where
712  * there is an account (an owner) that can be granted exclusive access to
713  * specific functions.
714  *
715  * By default, the owner account will be the one that deploys the contract. This
716  * can later be changed with {transferOwnership}.
717  *
718  * This module is used through inheritance. It will make available the modifier
719  * onlyOwner, which can be applied to your functions to restrict their use to
720  * the owner.
721  */
722 abstract contract Ownable is Context {
723     address private _owner;
724 
725     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
726 
727     /**
728      * @dev Initializes the contract setting the deployer as the initial owner.
729      */
730     constructor() {
731         _transferOwnership(_msgSender());
732     }
733 
734     /**
735      * @dev Returns the address of the current owner.
736      */
737     function owner() public view virtual returns (address) {
738         return _owner;
739     }
740 
741     /**
742      * @dev Throws if called by any account other than the owner.
743      */
744     function _onlyOwner() private view {
745        require(owner() == _msgSender(), "Ownable: caller is not the owner");
746     }
747 
748     modifier onlyOwner() {
749         _onlyOwner();
750         _;
751     }
752 
753     /**
754      * @dev Leaves the contract without owner. It will not be possible to call
755      * onlyOwner functions anymore. Can only be called by the current owner.
756      *
757      * NOTE: Renouncing ownership will leave the contract without an owner,
758      * thereby removing any functionality that is only available to the owner.
759      */
760     function renounceOwnership() public virtual onlyOwner {
761         _transferOwnership(address(0));
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (newOwner).
766      * Can only be called by the current owner.
767      */
768     function transferOwnership(address newOwner) public virtual onlyOwner {
769         require(newOwner != address(0), "Ownable: new owner is the zero address");
770         _transferOwnership(newOwner);
771     }
772 
773     /**
774      * @dev Transfers ownership of the contract to a new account (newOwner).
775      * Internal function without access restriction.
776      */
777     function _transferOwnership(address newOwner) internal virtual {
778         address oldOwner = _owner;
779         _owner = newOwner;
780         emit OwnershipTransferred(oldOwner, newOwner);
781     }
782 }
783 
784 // File contracts/OperatorFilter/IOperatorFilterRegistry.sol
785 pragma solidity ^0.8.9;
786 
787 interface IOperatorFilterRegistry {
788     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
789     function register(address registrant) external;
790     function registerAndSubscribe(address registrant, address subscription) external;
791     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
792     function updateOperator(address registrant, address operator, bool filtered) external;
793     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
794     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
795     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
796     function subscribe(address registrant, address registrantToSubscribe) external;
797     function unsubscribe(address registrant, bool copyExistingEntries) external;
798     function subscriptionOf(address addr) external returns (address registrant);
799     function subscribers(address registrant) external returns (address[] memory);
800     function subscriberAt(address registrant, uint256 index) external returns (address);
801     function copyEntriesOf(address registrant, address registrantToCopy) external;
802     function isOperatorFiltered(address registrant, address operator) external returns (bool);
803     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
804     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
805     function filteredOperators(address addr) external returns (address[] memory);
806     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
807     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
808     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
809     function isRegistered(address addr) external returns (bool);
810     function codeHashOf(address addr) external returns (bytes32);
811 }
812 
813 // File contracts/OperatorFilter/OperatorFilterer.sol
814 pragma solidity ^0.8.9;
815 
816 abstract contract OperatorFilterer {
817     error OperatorNotAllowed(address operator);
818 
819     IOperatorFilterRegistry constant operatorFilterRegistry =
820         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
821 
822     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
823         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
824         // will not revert, but the contract will need to be registered with the registry once it is deployed in
825         // order for the modifier to filter addresses.
826         if (address(operatorFilterRegistry).code.length > 0) {
827             if (subscribe) {
828                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
829             } else {
830                 if (subscriptionOrRegistrantToCopy != address(0)) {
831                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
832                 } else {
833                     operatorFilterRegistry.register(address(this));
834                 }
835             }
836         }
837     }
838 
839     function _onlyAllowedOperator(address from) private view {
840       if (
841           !(
842               operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
843               && operatorFilterRegistry.isOperatorAllowed(address(this), from)
844           )
845       ) {
846           revert OperatorNotAllowed(msg.sender);
847       }
848     }
849 
850     modifier onlyAllowedOperator(address from) virtual {
851         // Check registry code length to facilitate testing in environments without a deployed registry.
852         if (address(operatorFilterRegistry).code.length > 0) {
853             // Allow spending tokens from addresses with balance
854             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
855             // from an EOA.
856             if (from == msg.sender) {
857                 _;
858                 return;
859             }
860             _onlyAllowedOperator(from);
861         }
862         _;
863     }
864 
865     modifier onlyAllowedOperatorApproval(address operator) virtual {
866         _checkFilterOperator(operator);
867         _;
868     }
869 
870     function _checkFilterOperator(address operator) internal view virtual {
871         // Check registry code length to facilitate testing in environments without a deployed registry.
872         if (address(operatorFilterRegistry).code.length > 0) {
873             if (!operatorFilterRegistry.isOperatorAllowed(address(this), operator)) {
874                 revert OperatorNotAllowed(operator);
875             }
876         }
877     }
878 }
879 
880 //-------------END DEPENDENCIES------------------------//
881 
882 
883   
884 error TransactionCapExceeded();
885 error PublicMintingClosed();
886 error ExcessiveOwnedMints();
887 error MintZeroQuantity();
888 error InvalidPayment();
889 error CapExceeded();
890 error IsAlreadyUnveiled();
891 error ValueCannotBeZero();
892 error CannotBeNullAddress();
893 error NoStateChange();
894 
895 error PublicMintClosed();
896 error AllowlistMintClosed();
897 
898 error AddressNotAllowlisted();
899 error AllowlistDropTimeHasNotPassed();
900 error PublicDropTimeHasNotPassed();
901 error DropTimeNotInFuture();
902 
903 error OnlyERC20MintingEnabled();
904 error ERC20TokenNotApproved();
905 error ERC20InsufficientBalance();
906 error ERC20InsufficientAllowance();
907 error ERC20TransferFailed();
908 
909 error ClaimModeDisabled();
910 error IneligibleRedemptionContract();
911 error TokenAlreadyRedeemed();
912 error InvalidOwnerForRedemption();
913 error InvalidApprovalForRedemption();
914 
915 error ERC721RestrictedApprovalAddressRestricted();
916   
917   
918 // Rampp Contracts v2.1 (Teams.sol)
919 
920 error InvalidTeamAddress();
921 error DuplicateTeamAddress();
922 pragma solidity ^0.8.0;
923 
924 /**
925 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
926 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
927 * This will easily allow cross-collaboration via Mintplex.xyz.
928 **/
929 abstract contract Teams is Ownable{
930   mapping (address => bool) internal team;
931 
932   /**
933   * @dev Adds an address to the team. Allows them to execute protected functions
934   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
935   **/
936   function addToTeam(address _address) public onlyOwner {
937     if(_address == address(0)) revert InvalidTeamAddress();
938     if(inTeam(_address)) revert DuplicateTeamAddress();
939   
940     team[_address] = true;
941   }
942 
943   /**
944   * @dev Removes an address to the team.
945   * @param _address the ETH address to remove, cannot be 0x and must be in team
946   **/
947   function removeFromTeam(address _address) public onlyOwner {
948     if(_address == address(0)) revert InvalidTeamAddress();
949     if(!inTeam(_address)) revert InvalidTeamAddress();
950   
951     team[_address] = false;
952   }
953 
954   /**
955   * @dev Check if an address is valid and active in the team
956   * @param _address ETH address to check for truthiness
957   **/
958   function inTeam(address _address)
959     public
960     view
961     returns (bool)
962   {
963     if(_address == address(0)) revert InvalidTeamAddress();
964     return team[_address] == true;
965   }
966 
967   /**
968   * @dev Throws if called by any account other than the owner or team member.
969   */
970   function _onlyTeamOrOwner() private view {
971     bool _isOwner = owner() == _msgSender();
972     bool _isTeam = inTeam(_msgSender());
973     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
974   }
975 
976   modifier onlyTeamOrOwner() {
977     _onlyTeamOrOwner();
978     _;
979   }
980 }
981 
982 
983   
984   
985 /**
986  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
987  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
988  *
989  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
990  * 
991  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
992  *
993  * Does not support burning tokens to address(0).
994  */
995 contract ERC721A is
996   Context,
997   ERC165,
998   IERC721,
999   IERC721Metadata,
1000   IERC721Enumerable,
1001   Teams
1002   , OperatorFilterer
1003 {
1004   using Address for address;
1005   using Strings for uint256;
1006 
1007   struct TokenOwnership {
1008     address addr;
1009     uint64 startTimestamp;
1010   }
1011 
1012   struct AddressData {
1013     uint128 balance;
1014     uint128 numberMinted;
1015   }
1016 
1017   uint256 private currentIndex;
1018 
1019   uint256 public immutable collectionSize;
1020   uint256 public maxBatchSize;
1021 
1022   // Token name
1023   string private _name;
1024 
1025   // Token symbol
1026   string private _symbol;
1027 
1028   // Mapping from token ID to ownership details
1029   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1030   mapping(uint256 => TokenOwnership) private _ownerships;
1031 
1032   // Mapping owner address to address data
1033   mapping(address => AddressData) private _addressData;
1034 
1035   // Mapping from token ID to approved address
1036   mapping(uint256 => address) private _tokenApprovals;
1037 
1038   // Mapping from owner to operator approvals
1039   mapping(address => mapping(address => bool)) private _operatorApprovals;
1040 
1041   /* @dev Mapping of restricted operator approvals set by contract Owner
1042   * This serves as an optional addition to ERC-721 so
1043   * that the contract owner can elect to prevent specific addresses/contracts
1044   * from being marked as the approver for a token. The reason for this
1045   * is that some projects may want to retain control of where their tokens can/can not be listed
1046   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1047   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1048   */
1049   mapping(address => bool) public restrictedApprovalAddresses;
1050 
1051   /**
1052    * @dev
1053    * maxBatchSize refers to how much a minter can mint at a time.
1054    * collectionSize_ refers to how many tokens are in the collection.
1055    */
1056   constructor(
1057     string memory name_,
1058     string memory symbol_,
1059     uint256 maxBatchSize_,
1060     uint256 collectionSize_
1061   ) OperatorFilterer(address(0), false) {
1062     require(
1063       collectionSize_ > 0,
1064       "ERC721A: collection must have a nonzero supply"
1065     );
1066     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1067     _name = name_;
1068     _symbol = symbol_;
1069     maxBatchSize = maxBatchSize_;
1070     collectionSize = collectionSize_;
1071     currentIndex = _startTokenId();
1072   }
1073 
1074   /**
1075   * To change the starting tokenId, please override this function.
1076   */
1077   function _startTokenId() internal view virtual returns (uint256) {
1078     return 1;
1079   }
1080 
1081   /**
1082    * @dev See {IERC721Enumerable-totalSupply}.
1083    */
1084   function totalSupply() public view override returns (uint256) {
1085     return _totalMinted();
1086   }
1087 
1088   function currentTokenId() public view returns (uint256) {
1089     return _totalMinted();
1090   }
1091 
1092   function getNextTokenId() public view returns (uint256) {
1093       return _totalMinted() + 1;
1094   }
1095 
1096   /**
1097   * Returns the total amount of tokens minted in the contract.
1098   */
1099   function _totalMinted() internal view returns (uint256) {
1100     unchecked {
1101       return currentIndex - _startTokenId();
1102     }
1103   }
1104 
1105   /**
1106    * @dev See {IERC721Enumerable-tokenByIndex}.
1107    */
1108   function tokenByIndex(uint256 index) public view override returns (uint256) {
1109     require(index < totalSupply(), "ERC721A: global index out of bounds");
1110     return index;
1111   }
1112 
1113   /**
1114    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1115    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1116    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1117    */
1118   function tokenOfOwnerByIndex(address owner, uint256 index)
1119     public
1120     view
1121     override
1122     returns (uint256)
1123   {
1124     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1125     uint256 numMintedSoFar = totalSupply();
1126     uint256 tokenIdsIdx = 0;
1127     address currOwnershipAddr = address(0);
1128     for (uint256 i = 0; i < numMintedSoFar; i++) {
1129       TokenOwnership memory ownership = _ownerships[i];
1130       if (ownership.addr != address(0)) {
1131         currOwnershipAddr = ownership.addr;
1132       }
1133       if (currOwnershipAddr == owner) {
1134         if (tokenIdsIdx == index) {
1135           return i;
1136         }
1137         tokenIdsIdx++;
1138       }
1139     }
1140     revert("ERC721A: unable to get token of owner by index");
1141   }
1142 
1143   /**
1144    * @dev See {IERC165-supportsInterface}.
1145    */
1146   function supportsInterface(bytes4 interfaceId)
1147     public
1148     view
1149     virtual
1150     override(ERC165, IERC165)
1151     returns (bool)
1152   {
1153     return
1154       interfaceId == type(IERC721).interfaceId ||
1155       interfaceId == type(IERC721Metadata).interfaceId ||
1156       interfaceId == type(IERC721Enumerable).interfaceId ||
1157       super.supportsInterface(interfaceId);
1158   }
1159 
1160   /**
1161    * @dev See {IERC721-balanceOf}.
1162    */
1163   function balanceOf(address owner) public view override returns (uint256) {
1164     require(owner != address(0), "ERC721A: balance query for the zero address");
1165     return uint256(_addressData[owner].balance);
1166   }
1167 
1168   function _numberMinted(address owner) internal view returns (uint256) {
1169     require(
1170       owner != address(0),
1171       "ERC721A: number minted query for the zero address"
1172     );
1173     return uint256(_addressData[owner].numberMinted);
1174   }
1175 
1176   function ownershipOf(uint256 tokenId)
1177     internal
1178     view
1179     returns (TokenOwnership memory)
1180   {
1181     uint256 curr = tokenId;
1182 
1183     unchecked {
1184         if (_startTokenId() <= curr && curr < currentIndex) {
1185             TokenOwnership memory ownership = _ownerships[curr];
1186             if (ownership.addr != address(0)) {
1187                 return ownership;
1188             }
1189 
1190             // Invariant:
1191             // There will always be an ownership that has an address and is not burned
1192             // before an ownership that does not have an address and is not burned.
1193             // Hence, curr will not underflow.
1194             while (true) {
1195                 curr--;
1196                 ownership = _ownerships[curr];
1197                 if (ownership.addr != address(0)) {
1198                     return ownership;
1199                 }
1200             }
1201         }
1202     }
1203 
1204     revert("ERC721A: unable to determine the owner of token");
1205   }
1206 
1207   /**
1208    * @dev See {IERC721-ownerOf}.
1209    */
1210   function ownerOf(uint256 tokenId) public view override returns (address) {
1211     return ownershipOf(tokenId).addr;
1212   }
1213 
1214   /**
1215    * @dev See {IERC721Metadata-name}.
1216    */
1217   function name() public view virtual override returns (string memory) {
1218     return _name;
1219   }
1220 
1221   /**
1222    * @dev See {IERC721Metadata-symbol}.
1223    */
1224   function symbol() public view virtual override returns (string memory) {
1225     return _symbol;
1226   }
1227 
1228   /**
1229    * @dev See {IERC721Metadata-tokenURI}.
1230    */
1231   function tokenURI(uint256 tokenId)
1232     public
1233     view
1234     virtual
1235     override
1236     returns (string memory)
1237   {
1238     string memory baseURI = _baseURI();
1239     string memory extension = _baseURIExtension();
1240     return
1241       bytes(baseURI).length > 0
1242         ? string(abi.encodePacked(baseURI, tokenId.toString(), extension))
1243         : "";
1244   }
1245 
1246   /**
1247    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1248    * token will be the concatenation of the baseURI and the tokenId. Empty
1249    * by default, can be overriden in child contracts.
1250    */
1251   function _baseURI() internal view virtual returns (string memory) {
1252     return "";
1253   }
1254 
1255   /**
1256    * @dev Base URI extension used for computing {tokenURI}. If set, the resulting URI for each
1257    * token will be the concatenation of the baseURI, tokenId, and this value. Empty
1258    * by default, can be overriden in child contracts.
1259    */
1260   function _baseURIExtension() internal view virtual returns (string memory) {
1261     return "";
1262   }
1263 
1264   /**
1265    * @dev Sets the value for an address to be in the restricted approval address pool.
1266    * Setting an address to true will disable token owners from being able to mark the address
1267    * for approval for trading. This would be used in theory to prevent token owners from listing
1268    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1269    * @param _address the marketplace/user to modify restriction status of
1270    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1271    */
1272   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1273     restrictedApprovalAddresses[_address] = _isRestricted;
1274   }
1275 
1276   /**
1277    * @dev See {IERC721-approve}.
1278    */
1279   function approve(address to, uint256 tokenId) public override onlyAllowedOperatorApproval(to) {
1280     address owner = ERC721A.ownerOf(tokenId);
1281     require(to != owner, "ERC721A: approval to current owner");
1282     if(restrictedApprovalAddresses[to]) revert ERC721RestrictedApprovalAddressRestricted();
1283 
1284     require(
1285       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1286       "ERC721A: approve caller is not owner nor approved for all"
1287     );
1288 
1289     _approve(to, tokenId, owner);
1290   }
1291 
1292   /**
1293    * @dev See {IERC721-getApproved}.
1294    */
1295   function getApproved(uint256 tokenId) public view override returns (address) {
1296     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1297 
1298     return _tokenApprovals[tokenId];
1299   }
1300 
1301   /**
1302    * @dev See {IERC721-setApprovalForAll}.
1303    */
1304   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1305     require(operator != _msgSender(), "ERC721A: approve to caller");
1306     if(restrictedApprovalAddresses[operator]) revert ERC721RestrictedApprovalAddressRestricted();
1307 
1308     _operatorApprovals[_msgSender()][operator] = approved;
1309     emit ApprovalForAll(_msgSender(), operator, approved);
1310   }
1311 
1312   /**
1313    * @dev See {IERC721-isApprovedForAll}.
1314    */
1315   function isApprovedForAll(address owner, address operator)
1316     public
1317     view
1318     virtual
1319     override
1320     returns (bool)
1321   {
1322     return _operatorApprovals[owner][operator];
1323   }
1324 
1325   /**
1326    * @dev See {IERC721-transferFrom}.
1327    */
1328   function transferFrom(
1329     address from,
1330     address to,
1331     uint256 tokenId
1332   ) public override onlyAllowedOperator(from) {
1333     _transfer(from, to, tokenId);
1334   }
1335 
1336   /**
1337    * @dev See {IERC721-safeTransferFrom}.
1338    */
1339   function safeTransferFrom(
1340     address from,
1341     address to,
1342     uint256 tokenId
1343   ) public override onlyAllowedOperator(from) {
1344     safeTransferFrom(from, to, tokenId, "");
1345   }
1346 
1347   /**
1348    * @dev See {IERC721-safeTransferFrom}.
1349    */
1350   function safeTransferFrom(
1351     address from,
1352     address to,
1353     uint256 tokenId,
1354     bytes memory _data
1355   ) public override onlyAllowedOperator(from) {
1356     _transfer(from, to, tokenId);
1357     require(
1358       _checkOnERC721Received(from, to, tokenId, _data),
1359       "ERC721A: transfer to non ERC721Receiver implementer"
1360     );
1361   }
1362 
1363   /**
1364    * @dev Returns whether tokenId exists.
1365    *
1366    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1367    *
1368    * Tokens start existing when they are minted (_mint),
1369    */
1370   function _exists(uint256 tokenId) internal view returns (bool) {
1371     return _startTokenId() <= tokenId && tokenId < currentIndex;
1372   }
1373 
1374   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1375     _safeMint(to, quantity, isAdminMint, "");
1376   }
1377 
1378   /**
1379    * @dev Mints quantity tokens and transfers them to to.
1380    *
1381    * Requirements:
1382    *
1383    * - there must be quantity tokens remaining unminted in the total collection.
1384    * - to cannot be the zero address.
1385    * - quantity cannot be larger than the max batch size.
1386    *
1387    * Emits a {Transfer} event.
1388    */
1389   function _safeMint(
1390     address to,
1391     uint256 quantity,
1392     bool isAdminMint,
1393     bytes memory _data
1394   ) internal {
1395     uint256 startTokenId = currentIndex;
1396     require(to != address(0), "ERC721A: mint to the zero address");
1397     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1398     require(!_exists(startTokenId), "ERC721A: token already minted");
1399 
1400     // For admin mints we do not want to enforce the maxBatchSize limit
1401     if (isAdminMint == false) {
1402         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1403     }
1404 
1405     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1406 
1407     AddressData memory addressData = _addressData[to];
1408     _addressData[to] = AddressData(
1409       addressData.balance + uint128(quantity),
1410       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1411     );
1412     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1413 
1414     uint256 updatedIndex = startTokenId;
1415 
1416     for (uint256 i = 0; i < quantity; i++) {
1417       emit Transfer(address(0), to, updatedIndex);
1418       require(
1419         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1420         "ERC721A: transfer to non ERC721Receiver implementer"
1421       );
1422       updatedIndex++;
1423     }
1424 
1425     currentIndex = updatedIndex;
1426     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1427   }
1428 
1429   /**
1430    * @dev Transfers tokenId from from to to.
1431    *
1432    * Requirements:
1433    *
1434    * - to cannot be the zero address.
1435    * - tokenId token must be owned by from.
1436    *
1437    * Emits a {Transfer} event.
1438    */
1439   function _transfer(
1440     address from,
1441     address to,
1442     uint256 tokenId
1443   ) private {
1444     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1445 
1446     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1447       getApproved(tokenId) == _msgSender() ||
1448       isApprovedForAll(prevOwnership.addr, _msgSender()));
1449 
1450     require(
1451       isApprovedOrOwner,
1452       "ERC721A: transfer caller is not owner nor approved"
1453     );
1454 
1455     require(
1456       prevOwnership.addr == from,
1457       "ERC721A: transfer from incorrect owner"
1458     );
1459     require(to != address(0), "ERC721A: transfer to the zero address");
1460 
1461     _beforeTokenTransfers(from, to, tokenId, 1);
1462 
1463     // Clear approvals from the previous owner
1464     _approve(address(0), tokenId, prevOwnership.addr);
1465 
1466     _addressData[from].balance -= 1;
1467     _addressData[to].balance += 1;
1468     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1469 
1470     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1471     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1472     uint256 nextTokenId = tokenId + 1;
1473     if (_ownerships[nextTokenId].addr == address(0)) {
1474       if (_exists(nextTokenId)) {
1475         _ownerships[nextTokenId] = TokenOwnership(
1476           prevOwnership.addr,
1477           prevOwnership.startTimestamp
1478         );
1479       }
1480     }
1481 
1482     emit Transfer(from, to, tokenId);
1483     _afterTokenTransfers(from, to, tokenId, 1);
1484   }
1485 
1486   /**
1487    * @dev Approve to to operate on tokenId
1488    *
1489    * Emits a {Approval} event.
1490    */
1491   function _approve(
1492     address to,
1493     uint256 tokenId,
1494     address owner
1495   ) private {
1496     _tokenApprovals[tokenId] = to;
1497     emit Approval(owner, to, tokenId);
1498   }
1499 
1500   uint256 public nextOwnerToExplicitlySet = 0;
1501 
1502   /**
1503    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1504    */
1505   function _setOwnersExplicit(uint256 quantity) internal {
1506     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1507     require(quantity > 0, "quantity must be nonzero");
1508     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1509 
1510     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1511     if (endIndex > collectionSize - 1) {
1512       endIndex = collectionSize - 1;
1513     }
1514     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1515     require(_exists(endIndex), "not enough minted yet for this cleanup");
1516     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1517       if (_ownerships[i].addr == address(0)) {
1518         TokenOwnership memory ownership = ownershipOf(i);
1519         _ownerships[i] = TokenOwnership(
1520           ownership.addr,
1521           ownership.startTimestamp
1522         );
1523       }
1524     }
1525     nextOwnerToExplicitlySet = endIndex + 1;
1526   }
1527 
1528   /**
1529    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1530    * The call is not executed if the target address is not a contract.
1531    *
1532    * @param from address representing the previous owner of the given token ID
1533    * @param to target address that will receive the tokens
1534    * @param tokenId uint256 ID of the token to be transferred
1535    * @param _data bytes optional data to send along with the call
1536    * @return bool whether the call correctly returned the expected magic value
1537    */
1538   function _checkOnERC721Received(
1539     address from,
1540     address to,
1541     uint256 tokenId,
1542     bytes memory _data
1543   ) private returns (bool) {
1544     if (to.isContract()) {
1545       try
1546         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1547       returns (bytes4 retval) {
1548         return retval == IERC721Receiver(to).onERC721Received.selector;
1549       } catch (bytes memory reason) {
1550         if (reason.length == 0) {
1551           revert("ERC721A: transfer to non ERC721Receiver implementer");
1552         } else {
1553           assembly {
1554             revert(add(32, reason), mload(reason))
1555           }
1556         }
1557       }
1558     } else {
1559       return true;
1560     }
1561   }
1562 
1563   /**
1564    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1565    *
1566    * startTokenId - the first token id to be transferred
1567    * quantity - the amount to be transferred
1568    *
1569    * Calling conditions:
1570    *
1571    * - When from and to are both non-zero, from's tokenId will be
1572    * transferred to to.
1573    * - When from is zero, tokenId will be minted for to.
1574    */
1575   function _beforeTokenTransfers(
1576     address from,
1577     address to,
1578     uint256 startTokenId,
1579     uint256 quantity
1580   ) internal virtual {}
1581 
1582   /**
1583    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1584    * minting.
1585    *
1586    * startTokenId - the first token id to be transferred
1587    * quantity - the amount to be transferred
1588    *
1589    * Calling conditions:
1590    *
1591    * - when from and to are both non-zero.
1592    * - from and to are never both zero.
1593    */
1594   function _afterTokenTransfers(
1595     address from,
1596     address to,
1597     uint256 startTokenId,
1598     uint256 quantity
1599   ) internal virtual {}
1600 }
1601 
1602 // @title An implementation of ERC-721A with additonal context for 1:1 redemption with another ERC-721
1603 // @author Mintplex.xyz (Mintplex Labs Inc) (Twitter: @MintplexNFT)
1604 // @notice -- See Medium article --
1605 // @custom:experimental This is an experimental contract interface. Mintplex assumes no responsibility for functionality or security.
1606 abstract contract ERC721ARedemption is ERC721A {
1607   // @dev Emitted when someone exchanges an NFT for this contracts NFT via token redemption swap
1608   event Redeemed(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1609 
1610   // @dev Emitted when someone proves ownership of an NFT for this contracts NFT via token redemption swap
1611   event VerifiedClaim(address indexed from, uint256 indexed tokenId, address indexed contractAddress);
1612   
1613   uint256 public redemptionSurcharge = 0 ether;
1614   bool public redemptionModeEnabled;
1615   bool public verifiedClaimModeEnabled;
1616   address public redemptionAddress = 0x000000000000000000000000000000000000dEaD; // address burned tokens are sent, default is dEaD.
1617   mapping(address => bool) public redemptionContracts;
1618   mapping(address => mapping(uint256 => bool)) public tokenRedemptions;
1619 
1620   // @dev Allow owner/team to set the contract as eligable for redemption for this contract
1621   function setRedeemableContract(address _contractAddress, bool _status) public onlyTeamOrOwner {
1622     redemptionContracts[_contractAddress] = _status;
1623   }
1624 
1625   // @dev Allow owner/team to determine if contract is accepting redemption mints
1626   function setRedemptionMode(bool _newStatus) public onlyTeamOrOwner {
1627     redemptionModeEnabled = _newStatus;
1628   }
1629 
1630   // @dev Allow owner/team to determine if contract is accepting verified claim mints
1631   function setVerifiedClaimMode(bool _newStatus) public onlyTeamOrOwner {
1632     verifiedClaimModeEnabled = _newStatus;
1633   }
1634 
1635   // @dev Set the fee that it would cost a minter to be able to burn/validtion mint a token on this contract. 
1636   function setRedemptionSurcharge(uint256 _newSurchargeInWei) public onlyTeamOrOwner {
1637     redemptionSurcharge = _newSurchargeInWei;
1638   }
1639 
1640   // @dev Set the redemption address where redeemed NFTs will be transferred when "burned". 
1641   // @notice Must be a wallet address or implement IERC721Receiver.
1642   // Cannot be null address as this will break any ERC-721A implementation without a proper
1643   // burn mechanic as ownershipOf cannot handle 0x00 holdings mid batch.
1644   function setRedemptionAddress(address _newRedemptionAddress) public onlyTeamOrOwner {
1645     if(_newRedemptionAddress == address(0)) revert CannotBeNullAddress();
1646     redemptionAddress = _newRedemptionAddress;
1647   }
1648 
1649   /**
1650   * @dev allows redemption or "burning" of a single tokenID. Must be owned by the owner
1651   * @notice this does not impact the total supply of the burned token and the transfer destination address may be set by
1652   * the contract owner or Team => redemptionAddress. 
1653   * @param tokenId the token to be redeemed.
1654   * Emits a {Redeemed} event.
1655   **/
1656   function redeem(address redemptionContract, uint256 tokenId) public payable {
1657     if(getNextTokenId() > collectionSize) revert CapExceeded();
1658     if(!redemptionModeEnabled) revert ClaimModeDisabled();
1659     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1660     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1661     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1662     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1663     
1664     IERC721 _targetContract = IERC721(redemptionContract);
1665     if(_targetContract.ownerOf(tokenId) != _msgSender()) revert InvalidOwnerForRedemption();
1666     if(_targetContract.getApproved(tokenId) != address(this)) revert InvalidApprovalForRedemption();
1667     
1668     // Warning: Since there is no standarized return value for transfers of ERC-721
1669     // It is possible this function silently fails and a mint still occurs. The owner of the contract is
1670     // responsible for ensuring that the redemption contract does not lock or have staked controls preventing
1671     // movement of the token. As an added measure we keep a mapping of tokens redeemed to prevent multiple single-token redemptions, 
1672     // but the NFT may not have been sent to the redemptionAddress.
1673     _targetContract.safeTransferFrom(_msgSender(), redemptionAddress, tokenId);
1674     tokenRedemptions[redemptionContract][tokenId] = true;
1675 
1676     emit Redeemed(_msgSender(), tokenId, redemptionContract);
1677     _safeMint(_msgSender(), 1, false);
1678   }
1679 
1680   /**
1681   * @dev allows for verified claim mint against a single tokenID. Must be owned by the owner
1682   * @notice this mint action allows the original NFT to remain in the holders wallet, but its claim is logged.
1683   * @param tokenId the token to be redeemed.
1684   * Emits a {VerifiedClaim} event.
1685   **/
1686   function verifedClaim(address redemptionContract, uint256 tokenId) public payable {
1687     if(getNextTokenId() > collectionSize) revert CapExceeded();
1688     if(!verifiedClaimModeEnabled) revert ClaimModeDisabled();
1689     if(redemptionContract == address(0)) revert CannotBeNullAddress();
1690     if(!redemptionContracts[redemptionContract]) revert IneligibleRedemptionContract();
1691     if(msg.value != redemptionSurcharge) revert InvalidPayment();
1692     if(tokenRedemptions[redemptionContract][tokenId]) revert TokenAlreadyRedeemed();
1693     
1694     tokenRedemptions[redemptionContract][tokenId] = true;
1695     emit VerifiedClaim(_msgSender(), tokenId, redemptionContract);
1696     _safeMint(_msgSender(), 1, false);
1697   }
1698 }
1699 
1700 
1701   
1702 /** TimedDrop.sol
1703 * This feature will allow the owner to be able to set timed drops for both the public and allowlist mint (if applicable).
1704 * It is bound by the block timestamp. The owner is able to determine if the feature should be used as all 
1705 * with the "enforcePublicDropTime" and "enforceAllowlistDropTime" variables. If the feature is disabled the implmented
1706 * *DropTimePassed() functions will always return true. Otherwise calculation is done to check if time has passed.
1707 */
1708 abstract contract TimedDrop is Teams {
1709   bool public enforcePublicDropTime = true;
1710   uint256 public publicDropTime = 1672034400;
1711   
1712   /**
1713   * @dev Allow the contract owner to set the public time to mint.
1714   * @param _newDropTime timestamp since Epoch in seconds you want public drop to happen
1715   */
1716   function setPublicDropTime(uint256 _newDropTime) public onlyTeamOrOwner {
1717     if(_newDropTime < block.timestamp) revert DropTimeNotInFuture();
1718     publicDropTime = _newDropTime;
1719   }
1720 
1721   function usePublicDropTime() public onlyTeamOrOwner {
1722     enforcePublicDropTime = true;
1723   }
1724 
1725   function disablePublicDropTime() public onlyTeamOrOwner {
1726     enforcePublicDropTime = false;
1727   }
1728 
1729   /**
1730   * @dev determine if the public droptime has passed.
1731   * if the feature is disabled then assume the time has passed.
1732   */
1733   function publicDropTimePassed() public view returns(bool) {
1734     if(enforcePublicDropTime == false) {
1735       return true;
1736     }
1737     return block.timestamp >= publicDropTime;
1738   }
1739   
1740 }
1741 
1742   
1743 interface IERC20 {
1744   function allowance(address owner, address spender) external view returns (uint256);
1745   function transfer(address _to, uint256 _amount) external returns (bool);
1746   function balanceOf(address account) external view returns (uint256);
1747   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1748 }
1749 
1750 // File: WithdrawableV2
1751 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1752 // ERC-20 Payouts are limited to a single payout address. This feature 
1753 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1754 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1755 abstract contract WithdrawableV2 is Teams {
1756   struct acceptedERC20 {
1757     bool isActive;
1758     uint256 chargeAmount;
1759   }
1760 
1761   
1762   mapping(address => acceptedERC20) private allowedTokenContracts;
1763   address[] public payableAddresses = [0x2159019d05Fd453167b34e70e04378EAf4940dA9];
1764   address public erc20Payable = 0x2159019d05Fd453167b34e70e04378EAf4940dA9;
1765   uint256[] public payableFees = [100];
1766   uint256 public payableAddressCount = 1;
1767   bool public onlyERC20MintingMode;
1768   
1769 
1770   function withdrawAll() public onlyTeamOrOwner {
1771       if(address(this).balance == 0) revert ValueCannotBeZero();
1772       _withdrawAll(address(this).balance);
1773   }
1774 
1775   function _withdrawAll(uint256 balance) private {
1776       for(uint i=0; i < payableAddressCount; i++ ) {
1777           _widthdraw(
1778               payableAddresses[i],
1779               (balance * payableFees[i]) / 100
1780           );
1781       }
1782   }
1783   
1784   function _widthdraw(address _address, uint256 _amount) private {
1785       (bool success, ) = _address.call{value: _amount}("");
1786       require(success, "Transfer failed.");
1787   }
1788 
1789   /**
1790   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1791   * in the event ERC-20 tokens are paid to the contract for mints.
1792   * @param _tokenContract contract of ERC-20 token to withdraw
1793   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1794   */
1795   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1796     if(_amountToWithdraw == 0) revert ValueCannotBeZero();
1797     IERC20 tokenContract = IERC20(_tokenContract);
1798     if(tokenContract.balanceOf(address(this)) < _amountToWithdraw) revert ERC20InsufficientBalance();
1799     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1800   }
1801 
1802   /**
1803   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1804   * @param _erc20TokenContract address of ERC-20 contract in question
1805   */
1806   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1807     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1808   }
1809 
1810   /**
1811   * @dev get the value of tokens to transfer for user of an ERC-20
1812   * @param _erc20TokenContract address of ERC-20 contract in question
1813   */
1814   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1815     if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1816     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1817   }
1818 
1819   /**
1820   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1821   * @param _erc20TokenContract address of ERC-20 contract in question
1822   * @param _isActive default status of if contract should be allowed to accept payments
1823   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1824   */
1825   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1826     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1827     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1828   }
1829 
1830   /**
1831   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1832   * it will assume the default value of zero. This should not be used to create new payment tokens.
1833   * @param _erc20TokenContract address of ERC-20 contract in question
1834   */
1835   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1836     allowedTokenContracts[_erc20TokenContract].isActive = true;
1837   }
1838 
1839   /**
1840   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1841   * it will assume the default value of zero. This should not be used to create new payment tokens.
1842   * @param _erc20TokenContract address of ERC-20 contract in question
1843   */
1844   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1845     allowedTokenContracts[_erc20TokenContract].isActive = false;
1846   }
1847 
1848   /**
1849   * @dev Enable only ERC-20 payments for minting on this contract
1850   */
1851   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1852     onlyERC20MintingMode = true;
1853   }
1854 
1855   /**
1856   * @dev Disable only ERC-20 payments for minting on this contract
1857   */
1858   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1859     onlyERC20MintingMode = false;
1860   }
1861 
1862   /**
1863   * @dev Set the payout of the ERC-20 token payout to a specific address
1864   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1865   */
1866   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1867     if(_newErc20Payable == address(0)) revert CannotBeNullAddress();
1868     if(_newErc20Payable == erc20Payable) revert NoStateChange();
1869     erc20Payable = _newErc20Payable;
1870   }
1871 }
1872 
1873 
1874   
1875 // File: isFeeable.sol
1876 abstract contract Feeable is Teams {
1877   uint256 public PRICE = 0 ether;
1878 
1879   function setPrice(uint256 _feeInWei) public onlyTeamOrOwner {
1880     PRICE = _feeInWei;
1881   }
1882 
1883   function getPrice(uint256 _count) public view returns (uint256) {
1884     return PRICE * _count;
1885   }
1886 }
1887 
1888   
1889   
1890   
1891 abstract contract RamppERC721A is 
1892     Ownable,
1893     Teams,
1894     ERC721ARedemption,
1895     WithdrawableV2,
1896     ReentrancyGuard 
1897     , Feeable 
1898      
1899     , TimedDrop
1900 {
1901   constructor(
1902     string memory tokenName,
1903     string memory tokenSymbol
1904   ) ERC721A(tokenName, tokenSymbol, 2, 1000) { }
1905     uint8 constant public CONTRACT_VERSION = 2;
1906     string public _baseTokenURI = "ipfs://bafybeicpxjokkygwxzfocof56a3dce5tsvv72gmuqxwrm4rjta6rso6ooy/";
1907     string public _baseTokenExtension = ".json";
1908 
1909     bool public mintingOpen = true;
1910     
1911     
1912     uint256 public MAX_WALLET_MINTS = 2;
1913 
1914   
1915     /////////////// Admin Mint Functions
1916     /**
1917      * @dev Mints a token to an address with a tokenURI.
1918      * This is owner only and allows a fee-free drop
1919      * @param _to address of the future owner of the token
1920      * @param _qty amount of tokens to drop the owner
1921      */
1922      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1923          if(_qty == 0) revert MintZeroQuantity();
1924          if(currentTokenId() + _qty > collectionSize) revert CapExceeded();
1925          _safeMint(_to, _qty, true);
1926      }
1927 
1928   
1929     /////////////// PUBLIC MINT FUNCTIONS
1930     /**
1931     * @dev Mints tokens to an address in batch.
1932     * fee may or may not be required*
1933     * @param _to address of the future owner of the token
1934     * @param _amount number of tokens to mint
1935     */
1936     function mintToMultiple(address _to, uint256 _amount) public payable {
1937         if(onlyERC20MintingMode) revert OnlyERC20MintingEnabled();
1938         if(_amount == 0) revert MintZeroQuantity();
1939         if(_amount > maxBatchSize) revert TransactionCapExceeded();
1940         if(!mintingOpen) revert PublicMintClosed();
1941         
1942         if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
1943         if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1944         if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1945         if(msg.value != getPrice(_amount)) revert InvalidPayment();
1946 
1947         _safeMint(_to, _amount, false);
1948     }
1949 
1950     /**
1951      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1952      * fee may or may not be required*
1953      * @param _to address of the future owner of the token
1954      * @param _amount number of tokens to mint
1955      * @param _erc20TokenContract erc-20 token contract to mint with
1956      */
1957     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1958       if(_amount == 0) revert MintZeroQuantity();
1959       if(_amount > maxBatchSize) revert TransactionCapExceeded();
1960       if(!mintingOpen) revert PublicMintClosed();
1961       if(currentTokenId() + _amount > collectionSize) revert CapExceeded();
1962       
1963       if(!publicDropTimePassed()) revert PublicDropTimeHasNotPassed();
1964       if(!canMintAmount(_to, _amount)) revert ExcessiveOwnedMints();
1965 
1966       // ERC-20 Specific pre-flight checks
1967       if(!isApprovedForERC20Payments(_erc20TokenContract)) revert ERC20TokenNotApproved();
1968       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1969       IERC20 payableToken = IERC20(_erc20TokenContract);
1970 
1971       if(payableToken.balanceOf(_to) < tokensQtyToTransfer) revert ERC20InsufficientBalance();
1972       if(payableToken.allowance(_to, address(this)) < tokensQtyToTransfer) revert ERC20InsufficientAllowance();
1973 
1974       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1975       if(!transferComplete) revert ERC20TransferFailed();
1976       
1977       _safeMint(_to, _amount, false);
1978     }
1979 
1980     function openMinting() public onlyTeamOrOwner {
1981         mintingOpen = true;
1982     }
1983 
1984     function stopMinting() public onlyTeamOrOwner {
1985         mintingOpen = false;
1986     }
1987 
1988   
1989 
1990   
1991     /**
1992     * @dev Check if wallet over MAX_WALLET_MINTS
1993     * @param _address address in question to check if minted count exceeds max
1994     */
1995     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
1996         if(_amount == 0) revert ValueCannotBeZero();
1997         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
1998     }
1999 
2000     /**
2001     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2002     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2003     */
2004     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2005         if(_newWalletMax == 0) revert ValueCannotBeZero();
2006         MAX_WALLET_MINTS = _newWalletMax;
2007     }
2008     
2009 
2010   
2011     /**
2012      * @dev Allows owner to set Max mints per tx
2013      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2014      */
2015      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2016          if(_newMaxMint == 0) revert ValueCannotBeZero();
2017          maxBatchSize = _newMaxMint;
2018      }
2019     
2020 
2021   
2022   
2023   
2024   function contractURI() public pure returns (string memory) {
2025     return "https://metadata.mintplex.xyz/t14LjAN1yXVoHAHGy7co/contract-metadata";
2026   }
2027   
2028 
2029   function _baseURI() internal view virtual override returns(string memory) {
2030     return _baseTokenURI;
2031   }
2032 
2033   function _baseURIExtension() internal view virtual override returns(string memory) {
2034     return _baseTokenExtension;
2035   }
2036 
2037   function baseTokenURI() public view returns(string memory) {
2038     return _baseTokenURI;
2039   }
2040 
2041   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2042     _baseTokenURI = baseURI;
2043   }
2044 
2045   function setBaseTokenExtension(string calldata baseExtension) external onlyTeamOrOwner {
2046     _baseTokenExtension = baseExtension;
2047   }
2048 }
2049 
2050 
2051   
2052 // File: contracts/CryptoDickBurbzContract.sol
2053 //SPDX-License-Identifier: MIT
2054 
2055 pragma solidity ^0.8.0;
2056 
2057 contract CryptoDickBurbzContract is RamppERC721A {
2058     constructor() RamppERC721A("CryptoDickBurbz", "DickBurbz"){}
2059 }
2060   
2061 //*********************************************************************//
2062 //*********************************************************************//  
2063 //                       Mintplex v3.0.0
2064 //
2065 //         This smart contract was generated by mintplex.xyz.
2066 //            Mintplex allows creators like you to launch 
2067 //             large scale NFT communities without code!
2068 //
2069 //    Mintplex is not responsible for the content of this contract and
2070 //        hopes it is being used in a responsible and kind way.  
2071 //       Mintplex is not associated or affiliated with this project.                                                    
2072 //             Twitter: @MintplexNFT ---- mintplex.xyz
2073 //*********************************************************************//                                                     
2074 //*********************************************************************// 
