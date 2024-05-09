1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
5 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
6 // ,,,,,,@@@@@@@@@@@@@@(,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,@@@@@@@@@@@@(,,,,,,,,,,,,,,,,,,,
7 // ,,,,@@((((((((((((@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@((((((((//#@@,,,,,,,,,,,,,,,,,
8 // ,,,,@@////////////@@%((((((((((((@@,,...........................,,@@((((((((((@@,,@@((((@@//////////(((/(@@,,,,,,,,,,,,,
9 // ,,,,@@////////////@@%((((((((((((@@,,...........................,,@@((((((((((@@,,@@((((@@/////////////(///@@,,,,,,,,,,,
10 // ,,,,@@////////////@@%((((((((((((@@,,...........................,,@@((((((((((@@,,@@((((@@///////////////((//@@,,,,,,,,,
11 // ,,,,@@////////////@@%((((((((((((@@,,...........................,,@@((((((((((@@,,@@((((@@/////////////////((//@@,,,,,,,
12 // ,,,,@@////////////@@%((((((((((((@@,,..........................,,,@@((((((((((@@,,@@((((@@////////////////////(/(%%%*,,,
13 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@((((((((((@@,,@@((((@@/////////////////////////@@,,,
14 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@((((((((((@@,,@@((((@@/////////////////////////@@,,,
15 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@((((((((((@@,,@@((((@@/////////////////////////@@,,,
16 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@((((((((((@@,,@@((((@@/////////////////////////@@,,,
17 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/@@@@@@@@@@@@@@,,@@((((@@/////////////////////////@@,,,
18 // ,,,,@@////////////@@%((((((((((((@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@((((@@/////////////////////////@@,,,
19 // ,,,,@@////////////@@%((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((((((@@/////////////////////////@@,,,
20 // ,,,,@@////////////@@&(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@/////////////////////////@@,,,
21 // ,,,,@@////////////%&&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&/////////////////////////@@,,,
22 // ,,,,@@//////////////((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((///////////////////////////@@,,,
23 // ,,,,@@/////////////////////////////////////////////////////////////////////////////////////////////////////////////@@,,,
24 // ,,,,@@/////////////////////////////////////////////////////////////////////////////////////////////////////////////@@,,,
25 // ,,,,@@/////////////////////////////////////////////////////////////////////////////////////////////////////////////@@,,,
26 // ,,,,@@////////////(@%(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((&@(////////////@@,,,
27 // ,,,,@@////////////@@%(#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%(&@@////////////@@,,,
28 // ,,,,@@////////////@@%(%@#.......................................................................@@%(&@@////////////@@,,,
29 // ,,,,@@////////////@@%(%@#.......*#####..........................................................&@%(&@@////////////@@,,,
30 // ,,,,@@////////////@@%(%@#.......*##.................................###.........................&@%(&@@////////////@@,,,
31 // ,,,,@@////////////@@%(%@#.......*##.................................###.........................&@%(&@@////////////@@,,,
32 // ,,,,@@////////////@@%(%@#.......*##..................... ...........###. .......................&@%(&@@////////////@@,,,
33 // ,,,,@@////////////@@%(%@#.......*##..........###..(##.....########..###..###..###..(####/.......@@%(&@@////////////@@,,,
34 // ,,,,@@////////////@@%(%@#....,,,/##,,,,,,,,,,###,,###,,,,,##(,,,,,,,#####,,,,,###,,(##,,,,,,....@@%(&@@////////////@@,,,
35 // ,,,,@@////////////@@&(%@#.......*##.....(((..###((###.....**/((.....###**(((..###((###..........@@%(&@@////////////@@,,,
36 // ,,,,@@////////////@@&(%@#.......*##/////###..********//,....,**///. ***..###..*****(##.....@@%@@@@%(&@@@**@&///////@@,,,
37 // ,,,,@@////////////@@&(%@#........**********..........**,.......***.....//***.......(##...@@%#/#%@@@@@@////@&///////@@,,,
38 // ,,,,@@////////////@@&(%@#...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,((,,,,,,,,,,(##,,,@@%%%//*///%%%%%%@&///////@@,,,
39 // ,,,,@@////////////@@&(%@#........................................................../(( @@*/*/%%%**///*%%%%#%@(/////@@,,,
40 // ,,,,@@((((((((((((@@&(%@#........................................................((,...@@*/%%%&@%%///*@@#%%%@#(((//@@,,,
41 // ,,,,@@((((((((((((@@&(%@#......................................................#@......@@//%%%&@%%//*/@@*//(@#(((//@@,,,
42 // ,,,,@@((((((((((((@@&(#@#...,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,%@//@@,,@@/*(////*///*///@@(((((((//@@,,,
43 // ,,,,@@((((((((((((@@&(#@#......................................................#@//@@@@////(((((((((((@@(((((((((//@@,,,
44 // ,,,,@@((((((((((((@@&(#@#......................................................#@((@@///*(((((((((((@@@((((((((((//@@,,,
45 // ,,,,@@((((((((((((@@&(#@#..........................................................@@((((((((#((@@((@@@((((((((((//@@,,,
46 // ,,,,@@((((@@@@((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@((((@@@@((//@@,,,
47 // ,,,,@@((@@/,,,@@#(@@&###############################################################################%@@(#@@,,,,@@//@@,,,
48 // ,,,,@@(((@/,,,@@((@@&###############################################################################%@@((@@,,,,@@//@@,,,
49 // ,,,,@@((((((((((((@@&###############################################################################%@@((((((((((//@@,,,
50 // ,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,
51 // ,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
52 //
53 //*********************************************************************//
54 //*********************************************************************//
55   
56 //-------------DEPENDENCIES--------------------------//
57 
58 // File: @openzeppelin/contracts/utils/Address.sol
59 
60 
61 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
62 
63 pragma solidity ^0.8.1;
64 
65 /**
66  * @dev Collection of functions related to the address type
67  */
68 library Address {
69     /**
70      * @dev Returns true if account is a contract.
71      *
72      * [IMPORTANT]
73      * ====
74      * It is unsafe to assume that an address for which this function returns
75      * false is an externally-owned account (EOA) and not a contract.
76      *
77      * Among others, isContract will return false for the following
78      * types of addresses:
79      *
80      *  - an externally-owned account
81      *  - a contract in construction
82      *  - an address where a contract will be created
83      *  - an address where a contract lived, but was destroyed
84      * ====
85      *
86      * [IMPORTANT]
87      * ====
88      * You shouldn't rely on isContract to protect against flash loan attacks!
89      *
90      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
91      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
92      * constructor.
93      * ====
94      */
95     function isContract(address account) internal view returns (bool) {
96         // This method relies on extcodesize/address.code.length, which returns 0
97         // for contracts in construction, since the code is only stored at the end
98         // of the constructor execution.
99 
100         return account.code.length > 0;
101     }
102 
103     /**
104      * @dev Replacement for Solidity's transfer: sends amount wei to
105      * recipient, forwarding all available gas and reverting on errors.
106      *
107      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
108      * of certain opcodes, possibly making contracts go over the 2300 gas limit
109      * imposed by transfer, making them unable to receive funds via
110      * transfer. {sendValue} removes this limitation.
111      *
112      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
113      *
114      * IMPORTANT: because control is transferred to recipient, care must be
115      * taken to not create reentrancy vulnerabilities. Consider using
116      * {ReentrancyGuard} or the
117      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
118      */
119     function sendValue(address payable recipient, uint256 amount) internal {
120         require(address(this).balance >= amount, "Address: insufficient balance");
121 
122         (bool success, ) = recipient.call{value: amount}("");
123         require(success, "Address: unable to send value, recipient may have reverted");
124     }
125 
126     /**
127      * @dev Performs a Solidity function call using a low level call. A
128      * plain call is an unsafe replacement for a function call: use this
129      * function instead.
130      *
131      * If target reverts with a revert reason, it is bubbled up by this
132      * function (like regular Solidity function calls).
133      *
134      * Returns the raw returned data. To convert to the expected return value,
135      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
136      *
137      * Requirements:
138      *
139      * - target must be a contract.
140      * - calling target with data must not revert.
141      *
142      * _Available since v3.1._
143      */
144     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
145         return functionCall(target, data, "Address: low-level call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
150      * errorMessage as a fallback revert reason when target reverts.
151      *
152      * _Available since v3.1._
153      */
154     function functionCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal returns (bytes memory) {
159         return functionCallWithValue(target, data, 0, errorMessage);
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
164      * but also transferring value wei to target.
165      *
166      * Requirements:
167      *
168      * - the calling contract must have an ETH balance of at least value.
169      * - the called Solidity function must be payable.
170      *
171      * _Available since v3.1._
172      */
173     function functionCallWithValue(
174         address target,
175         bytes memory data,
176         uint256 value
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
183      * with errorMessage as a fallback revert reason when target reverts.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         require(address(this).balance >= value, "Address: insufficient balance for call");
194         require(isContract(target), "Address: call to non-contract");
195 
196         (bool success, bytes memory returndata) = target.call{value: value}(data);
197         return verifyCallResult(success, returndata, errorMessage);
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
202      * but performing a static call.
203      *
204      * _Available since v3.3._
205      */
206     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
207         return functionStaticCall(target, data, "Address: low-level static call failed");
208     }
209 
210     /**
211      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
212      * but performing a static call.
213      *
214      * _Available since v3.3._
215      */
216     function functionStaticCall(
217         address target,
218         bytes memory data,
219         string memory errorMessage
220     ) internal view returns (bytes memory) {
221         require(isContract(target), "Address: static call to non-contract");
222 
223         (bool success, bytes memory returndata) = target.staticcall(data);
224         return verifyCallResult(success, returndata, errorMessage);
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
229      * but performing a delegate call.
230      *
231      * _Available since v3.4._
232      */
233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
235     }
236 
237     /**
238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
239      * but performing a delegate call.
240      *
241      * _Available since v3.4._
242      */
243     function functionDelegateCall(
244         address target,
245         bytes memory data,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(isContract(target), "Address: delegate call to non-contract");
249 
250         (bool success, bytes memory returndata) = target.delegatecall(data);
251         return verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     /**
255      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
256      * revert reason using the provided one.
257      *
258      * _Available since v4.3._
259      */
260     function verifyCallResult(
261         bool success,
262         bytes memory returndata,
263         string memory errorMessage
264     ) internal pure returns (bytes memory) {
265         if (success) {
266             return returndata;
267         } else {
268             // Look for revert reason and bubble it up if present
269             if (returndata.length > 0) {
270                 // The easiest way to bubble the revert reason is using memory via assembly
271 
272                 assembly {
273                     let returndata_size := mload(returndata)
274                     revert(add(32, returndata), returndata_size)
275                 }
276             } else {
277                 revert(errorMessage);
278             }
279         }
280     }
281 }
282 
283 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
284 
285 
286 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
287 
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @title ERC721 token receiver interface
292  * @dev Interface for any contract that wants to support safeTransfers
293  * from ERC721 asset contracts.
294  */
295 interface IERC721Receiver {
296     /**
297      * @dev Whenever an {IERC721} tokenId token is transferred to this contract via {IERC721-safeTransferFrom}
298      * by operator from from, this function is called.
299      *
300      * It must return its Solidity selector to confirm the token transfer.
301      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
302      *
303      * The selector can be obtained in Solidity with IERC721.onERC721Received.selector.
304      */
305     function onERC721Received(
306         address operator,
307         address from,
308         uint256 tokenId,
309         bytes calldata data
310     ) external returns (bytes4);
311 }
312 
313 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Interface of the ERC165 standard, as defined in the
322  * https://eips.ethereum.org/EIPS/eip-165[EIP].
323  *
324  * Implementers can declare support of contract interfaces, which can then be
325  * queried by others ({ERC165Checker}).
326  *
327  * For an implementation, see {ERC165}.
328  */
329 interface IERC165 {
330     /**
331      * @dev Returns true if this contract implements the interface defined by
332      * interfaceId. See the corresponding
333      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
334      * to learn more about how these ids are created.
335      *
336      * This function call must use less than 30 000 gas.
337      */
338     function supportsInterface(bytes4 interfaceId) external view returns (bool);
339 }
340 
341 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
342 
343 
344 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
345 
346 pragma solidity ^0.8.0;
347 
348 
349 /**
350  * @dev Implementation of the {IERC165} interface.
351  *
352  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
353  * for the additional interface id that will be supported. For example:
354  *
355  * solidity
356  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
358  * }
359  * 
360  *
361  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
362  */
363 abstract contract ERC165 is IERC165 {
364     /**
365      * @dev See {IERC165-supportsInterface}.
366      */
367     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
368         return interfaceId == type(IERC165).interfaceId;
369     }
370 }
371 
372 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
373 
374 
375 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
376 
377 pragma solidity ^0.8.0;
378 
379 
380 /**
381  * @dev Required interface of an ERC721 compliant contract.
382  */
383 interface IERC721 is IERC165 {
384     /**
385      * @dev Emitted when tokenId token is transferred from from to to.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
388 
389     /**
390      * @dev Emitted when owner enables approved to manage the tokenId token.
391      */
392     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
393 
394     /**
395      * @dev Emitted when owner enables or disables (approved) operator to manage all of its assets.
396      */
397     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
398 
399     /**
400      * @dev Returns the number of tokens in owner's account.
401      */
402     function balanceOf(address owner) external view returns (uint256 balance);
403 
404     /**
405      * @dev Returns the owner of the tokenId token.
406      *
407      * Requirements:
408      *
409      * - tokenId must exist.
410      */
411     function ownerOf(uint256 tokenId) external view returns (address owner);
412 
413     /**
414      * @dev Safely transfers tokenId token from from to to, checking first that contract recipients
415      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
416      *
417      * Requirements:
418      *
419      * - from cannot be the zero address.
420      * - to cannot be the zero address.
421      * - tokenId token must exist and be owned by from.
422      * - If the caller is not from, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
423      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
424      *
425      * Emits a {Transfer} event.
426      */
427     function safeTransferFrom(
428         address from,
429         address to,
430         uint256 tokenId
431     ) external;
432 
433     /**
434      * @dev Transfers tokenId token from from to to.
435      *
436      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
437      *
438      * Requirements:
439      *
440      * - from cannot be the zero address.
441      * - to cannot be the zero address.
442      * - tokenId token must be owned by from.
443      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transferFrom(
448         address from,
449         address to,
450         uint256 tokenId
451     ) external;
452 
453     /**
454      * @dev Gives permission to to to transfer tokenId token to another account.
455      * The approval is cleared when the token is transferred.
456      *
457      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
458      *
459      * Requirements:
460      *
461      * - The caller must own the token or be an approved operator.
462      * - tokenId must exist.
463      *
464      * Emits an {Approval} event.
465      */
466     function approve(address to, uint256 tokenId) external;
467 
468     /**
469      * @dev Returns the account approved for tokenId token.
470      *
471      * Requirements:
472      *
473      * - tokenId must exist.
474      */
475     function getApproved(uint256 tokenId) external view returns (address operator);
476 
477     /**
478      * @dev Approve or remove operator as an operator for the caller.
479      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
480      *
481      * Requirements:
482      *
483      * - The operator cannot be the caller.
484      *
485      * Emits an {ApprovalForAll} event.
486      */
487     function setApprovalForAll(address operator, bool _approved) external;
488 
489     /**
490      * @dev Returns if the operator is allowed to manage all of the assets of owner.
491      *
492      * See {setApprovalForAll}
493      */
494     function isApprovedForAll(address owner, address operator) external view returns (bool);
495 
496     /**
497      * @dev Safely transfers tokenId token from from to to.
498      *
499      * Requirements:
500      *
501      * - from cannot be the zero address.
502      * - to cannot be the zero address.
503      * - tokenId token must exist and be owned by from.
504      * - If the caller is not from, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      * - If to refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
506      *
507      * Emits a {Transfer} event.
508      */
509     function safeTransferFrom(
510         address from,
511         address to,
512         uint256 tokenId,
513         bytes calldata data
514     ) external;
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
518 
519 
520 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Enumerable is IERC721 {
530     /**
531      * @dev Returns the total amount of tokens stored by the contract.
532      */
533     function totalSupply() external view returns (uint256);
534 
535     /**
536      * @dev Returns a token ID owned by owner at a given index of its token list.
537      * Use along with {balanceOf} to enumerate all of owner's tokens.
538      */
539     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
540 
541     /**
542      * @dev Returns a token ID at a given index of all the tokens stored by the contract.
543      * Use along with {totalSupply} to enumerate all tokens.
544      */
545     function tokenByIndex(uint256 index) external view returns (uint256);
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
558  * @dev See https://eips.ethereum.org/EIPS/eip-721
559  */
560 interface IERC721Metadata is IERC721 {
561     /**
562      * @dev Returns the token collection name.
563      */
564     function name() external view returns (string memory);
565 
566     /**
567      * @dev Returns the token collection symbol.
568      */
569     function symbol() external view returns (string memory);
570 
571     /**
572      * @dev Returns the Uniform Resource Identifier (URI) for tokenId token.
573      */
574     function tokenURI(uint256 tokenId) external view returns (string memory);
575 }
576 
577 // File: @openzeppelin/contracts/utils/Strings.sol
578 
579 
580 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 /**
585  * @dev String operations.
586  */
587 library Strings {
588     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
589 
590     /**
591      * @dev Converts a uint256 to its ASCII string decimal representation.
592      */
593     function toString(uint256 value) internal pure returns (string memory) {
594         // Inspired by OraclizeAPI's implementation - MIT licence
595         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
596 
597         if (value == 0) {
598             return "0";
599         }
600         uint256 temp = value;
601         uint256 digits;
602         while (temp != 0) {
603             digits++;
604             temp /= 10;
605         }
606         bytes memory buffer = new bytes(digits);
607         while (value != 0) {
608             digits -= 1;
609             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
610             value /= 10;
611         }
612         return string(buffer);
613     }
614 
615     /**
616      * @dev Converts a uint256 to its ASCII string hexadecimal representation.
617      */
618     function toHexString(uint256 value) internal pure returns (string memory) {
619         if (value == 0) {
620             return "0x00";
621         }
622         uint256 temp = value;
623         uint256 length = 0;
624         while (temp != 0) {
625             length++;
626             temp >>= 8;
627         }
628         return toHexString(value, length);
629     }
630 
631     /**
632      * @dev Converts a uint256 to its ASCII string hexadecimal representation with fixed length.
633      */
634     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
635         bytes memory buffer = new bytes(2 * length + 2);
636         buffer[0] = "0";
637         buffer[1] = "x";
638         for (uint256 i = 2 * length + 1; i > 1; --i) {
639             buffer[i] = _HEX_SYMBOLS[value & 0xf];
640             value >>= 4;
641         }
642         require(value == 0, "Strings: hex length insufficient");
643         return string(buffer);
644     }
645 }
646 
647 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
648 
649 
650 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
651 
652 pragma solidity ^0.8.0;
653 
654 /**
655  * @dev Contract module that helps prevent reentrant calls to a function.
656  *
657  * Inheriting from ReentrancyGuard will make the {nonReentrant} modifier
658  * available, which can be applied to functions to make sure there are no nested
659  * (reentrant) calls to them.
660  *
661  * Note that because there is a single nonReentrant guard, functions marked as
662  * nonReentrant may not call one another. This can be worked around by making
663  * those functions private, and then adding external nonReentrant entry
664  * points to them.
665  *
666  * TIP: If you would like to learn more about reentrancy and alternative ways
667  * to protect against it, check out our blog post
668  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
669  */
670 abstract contract ReentrancyGuard {
671     // Booleans are more expensive than uint256 or any type that takes up a full
672     // word because each write operation emits an extra SLOAD to first read the
673     // slot's contents, replace the bits taken up by the boolean, and then write
674     // back. This is the compiler's defense against contract upgrades and
675     // pointer aliasing, and it cannot be disabled.
676 
677     // The values being non-zero value makes deployment a bit more expensive,
678     // but in exchange the refund on every call to nonReentrant will be lower in
679     // amount. Since refunds are capped to a percentage of the total
680     // transaction's gas, it is best to keep them low in cases like this one, to
681     // increase the likelihood of the full refund coming into effect.
682     uint256 private constant _NOT_ENTERED = 1;
683     uint256 private constant _ENTERED = 2;
684 
685     uint256 private _status;
686 
687     constructor() {
688         _status = _NOT_ENTERED;
689     }
690 
691     /**
692      * @dev Prevents a contract from calling itself, directly or indirectly.
693      * Calling a nonReentrant function from another nonReentrant
694      * function is not supported. It is possible to prevent this from happening
695      * by making the nonReentrant function external, and making it call a
696      * private function that does the actual work.
697      */
698     modifier nonReentrant() {
699         // On the first call to nonReentrant, _notEntered will be true
700         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
701 
702         // Any calls to nonReentrant after this point will fail
703         _status = _ENTERED;
704 
705         _;
706 
707         // By storing the original value once again, a refund is triggered (see
708         // https://eips.ethereum.org/EIPS/eip-2200)
709         _status = _NOT_ENTERED;
710     }
711 }
712 
713 // File: @openzeppelin/contracts/utils/Context.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 /**
721  * @dev Provides information about the current execution context, including the
722  * sender of the transaction and its data. While these are generally available
723  * via msg.sender and msg.data, they should not be accessed in such a direct
724  * manner, since when dealing with meta-transactions the account sending and
725  * paying for execution may not be the actual sender (as far as an application
726  * is concerned).
727  *
728  * This contract is only required for intermediate, library-like contracts.
729  */
730 abstract contract Context {
731     function _msgSender() internal view virtual returns (address) {
732         return msg.sender;
733     }
734 
735     function _msgData() internal view virtual returns (bytes calldata) {
736         return msg.data;
737     }
738 }
739 
740 // File: @openzeppelin/contracts/access/Ownable.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Contract module which provides a basic access control mechanism, where
750  * there is an account (an owner) that can be granted exclusive access to
751  * specific functions.
752  *
753  * By default, the owner account will be the one that deploys the contract. This
754  * can later be changed with {transferOwnership}.
755  *
756  * This module is used through inheritance. It will make available the modifier
757  * onlyOwner, which can be applied to your functions to restrict their use to
758  * the owner.
759  */
760 abstract contract Ownable is Context {
761     address private _owner;
762 
763     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
764 
765     /**
766      * @dev Initializes the contract setting the deployer as the initial owner.
767      */
768     constructor() {
769         _transferOwnership(_msgSender());
770     }
771 
772     /**
773      * @dev Returns the address of the current owner.
774      */
775     function owner() public view virtual returns (address) {
776         return _owner;
777     }
778 
779     /**
780      * @dev Throws if called by any account other than the owner.
781      */
782     modifier onlyOwner() {
783         require(owner() == _msgSender(), "Ownable: caller is not the owner");
784         _;
785     }
786 
787     /**
788      * @dev Leaves the contract without owner. It will not be possible to call
789      * onlyOwner functions anymore. Can only be called by the current owner.
790      *
791      * NOTE: Renouncing ownership will leave the contract without an owner,
792      * thereby removing any functionality that is only available to the owner.
793      */
794     function renounceOwnership() public virtual onlyOwner {
795         _transferOwnership(address(0));
796     }
797 
798     /**
799      * @dev Transfers ownership of the contract to a new account (newOwner).
800      * Can only be called by the current owner.
801      */
802     function transferOwnership(address newOwner) public virtual onlyOwner {
803         require(newOwner != address(0), "Ownable: new owner is the zero address");
804         _transferOwnership(newOwner);
805     }
806 
807     /**
808      * @dev Transfers ownership of the contract to a new account (newOwner).
809      * Internal function without access restriction.
810      */
811     function _transferOwnership(address newOwner) internal virtual {
812         address oldOwner = _owner;
813         _owner = newOwner;
814         emit OwnershipTransferred(oldOwner, newOwner);
815     }
816 }
817 //-------------END DEPENDENCIES------------------------//
818 
819 
820   
821 // Rampp Contracts v2.1 (Teams.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 /**
826 * Teams is a contract implementation to extend upon Ownable that allows multiple controllers
827 * of a single contract to modify specific mint settings but not have overall ownership of the contract.
828 * This will easily allow cross-collaboration via Mintplex.xyz.
829 **/
830 abstract contract Teams is Ownable{
831   mapping (address => bool) internal team;
832 
833   /**
834   * @dev Adds an address to the team. Allows them to execute protected functions
835   * @param _address the ETH address to add, cannot be 0x and cannot be in team already
836   **/
837   function addToTeam(address _address) public onlyOwner {
838     require(_address != address(0), "Invalid address");
839     require(!inTeam(_address), "This address is already in your team.");
840   
841     team[_address] = true;
842   }
843 
844   /**
845   * @dev Removes an address to the team.
846   * @param _address the ETH address to remove, cannot be 0x and must be in team
847   **/
848   function removeFromTeam(address _address) public onlyOwner {
849     require(_address != address(0), "Invalid address");
850     require(inTeam(_address), "This address is not in your team currently.");
851   
852     team[_address] = false;
853   }
854 
855   /**
856   * @dev Check if an address is valid and active in the team
857   * @param _address ETH address to check for truthiness
858   **/
859   function inTeam(address _address)
860     public
861     view
862     returns (bool)
863   {
864     require(_address != address(0), "Invalid address to check.");
865     return team[_address] == true;
866   }
867 
868   /**
869   * @dev Throws if called by any account other than the owner or team member.
870   */
871   modifier onlyTeamOrOwner() {
872     bool _isOwner = owner() == _msgSender();
873     bool _isTeam = inTeam(_msgSender());
874     require(_isOwner || _isTeam, "Team: caller is not the owner or in Team.");
875     _;
876   }
877 }
878 
879 
880   
881   pragma solidity ^0.8.0;
882 
883   /**
884   * @dev These functions deal with verification of Merkle Trees proofs.
885   *
886   * The proofs can be generated using the JavaScript library
887   * https://github.com/miguelmota/merkletreejs[merkletreejs].
888   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
889   *
890   *
891   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
892   * hashing, or use a hash function other than keccak256 for hashing leaves.
893   * This is because the concatenation of a sorted pair of internal nodes in
894   * the merkle tree could be reinterpreted as a leaf value.
895   */
896   library MerkleProof {
897       /**
898       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
899       * defined by 'root'. For this, a 'proof' must be provided, containing
900       * sibling hashes on the branch from the leaf to the root of the tree. Each
901       * pair of leaves and each pair of pre-images are assumed to be sorted.
902       */
903       function verify(
904           bytes32[] memory proof,
905           bytes32 root,
906           bytes32 leaf
907       ) internal pure returns (bool) {
908           return processProof(proof, leaf) == root;
909       }
910 
911       /**
912       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
913       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
914       * hash matches the root of the tree. When processing the proof, the pairs
915       * of leafs & pre-images are assumed to be sorted.
916       *
917       * _Available since v4.4._
918       */
919       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
920           bytes32 computedHash = leaf;
921           for (uint256 i = 0; i < proof.length; i++) {
922               bytes32 proofElement = proof[i];
923               if (computedHash <= proofElement) {
924                   // Hash(current computed hash + current element of the proof)
925                   computedHash = _efficientHash(computedHash, proofElement);
926               } else {
927                   // Hash(current element of the proof + current computed hash)
928                   computedHash = _efficientHash(proofElement, computedHash);
929               }
930           }
931           return computedHash;
932       }
933 
934       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
935           assembly {
936               mstore(0x00, a)
937               mstore(0x20, b)
938               value := keccak256(0x00, 0x40)
939           }
940       }
941   }
942 
943 
944   // File: Allowlist.sol
945 
946   pragma solidity ^0.8.0;
947 
948   abstract contract Allowlist is Teams {
949     bytes32 public merkleRoot;
950     bool public onlyAllowlistMode = false;
951 
952     /**
953      * @dev Update merkle root to reflect changes in Allowlist
954      * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
955      */
956     function updateMerkleRoot(bytes32 _newMerkleRoot) public onlyTeamOrOwner {
957       require(_newMerkleRoot != merkleRoot, "Merkle root will be unchanged!");
958       merkleRoot = _newMerkleRoot;
959     }
960 
961     /**
962      * @dev Check the proof of an address if valid for merkle root
963      * @param _to address to check for proof
964      * @param _merkleProof Proof of the address to validate against root and leaf
965      */
966     function isAllowlisted(address _to, bytes32[] calldata _merkleProof) public view returns(bool) {
967       require(merkleRoot != 0, "Merkle root is not set!");
968       bytes32 leaf = keccak256(abi.encodePacked(_to));
969 
970       return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
971     }
972 
973     
974     function enableAllowlistOnlyMode() public onlyTeamOrOwner {
975       onlyAllowlistMode = true;
976     }
977 
978     function disableAllowlistOnlyMode() public onlyTeamOrOwner {
979         onlyAllowlistMode = false;
980     }
981   }
982   
983   
984 /**
985  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
986  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
987  *
988  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
989  * 
990  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
991  *
992  * Does not support burning tokens to address(0).
993  */
994 contract ERC721A is
995   Context,
996   ERC165,
997   IERC721,
998   IERC721Metadata,
999   IERC721Enumerable,
1000   Teams
1001 {
1002   using Address for address;
1003   using Strings for uint256;
1004 
1005   struct TokenOwnership {
1006     address addr;
1007     uint64 startTimestamp;
1008   }
1009 
1010   struct AddressData {
1011     uint128 balance;
1012     uint128 numberMinted;
1013   }
1014 
1015   uint256 private currentIndex;
1016 
1017   uint256 public immutable collectionSize;
1018   uint256 public maxBatchSize;
1019 
1020   // Token name
1021   string private _name;
1022 
1023   // Token symbol
1024   string private _symbol;
1025 
1026   // Mapping from token ID to ownership details
1027   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1028   mapping(uint256 => TokenOwnership) private _ownerships;
1029 
1030   // Mapping owner address to address data
1031   mapping(address => AddressData) private _addressData;
1032 
1033   // Mapping from token ID to approved address
1034   mapping(uint256 => address) private _tokenApprovals;
1035 
1036   // Mapping from owner to operator approvals
1037   mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039   /* @dev Mapping of restricted operator approvals set by contract Owner
1040   * This serves as an optional addition to ERC-721 so
1041   * that the contract owner can elect to prevent specific addresses/contracts
1042   * from being marked as the approver for a token. The reason for this
1043   * is that some projects may want to retain control of where their tokens can/can not be listed
1044   * either due to ethics, loyalty, or wanting trades to only occur on their personal marketplace.
1045   * By default, there are no restrictions. The contract owner must deliberatly block an address 
1046   */
1047   mapping(address => bool) public restrictedApprovalAddresses;
1048 
1049   /**
1050    * @dev
1051    * maxBatchSize refers to how much a minter can mint at a time.
1052    * collectionSize_ refers to how many tokens are in the collection.
1053    */
1054   constructor(
1055     string memory name_,
1056     string memory symbol_,
1057     uint256 maxBatchSize_,
1058     uint256 collectionSize_
1059   ) {
1060     require(
1061       collectionSize_ > 0,
1062       "ERC721A: collection must have a nonzero supply"
1063     );
1064     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1065     _name = name_;
1066     _symbol = symbol_;
1067     maxBatchSize = maxBatchSize_;
1068     collectionSize = collectionSize_;
1069     currentIndex = _startTokenId();
1070   }
1071 
1072   /**
1073   * To change the starting tokenId, please override this function.
1074   */
1075   function _startTokenId() internal view virtual returns (uint256) {
1076     return 1;
1077   }
1078 
1079   /**
1080    * @dev See {IERC721Enumerable-totalSupply}.
1081    */
1082   function totalSupply() public view override returns (uint256) {
1083     return _totalMinted();
1084   }
1085 
1086   function currentTokenId() public view returns (uint256) {
1087     return _totalMinted();
1088   }
1089 
1090   function getNextTokenId() public view returns (uint256) {
1091       return _totalMinted() + 1;
1092   }
1093 
1094   /**
1095   * Returns the total amount of tokens minted in the contract.
1096   */
1097   function _totalMinted() internal view returns (uint256) {
1098     unchecked {
1099       return currentIndex - _startTokenId();
1100     }
1101   }
1102 
1103   /**
1104    * @dev See {IERC721Enumerable-tokenByIndex}.
1105    */
1106   function tokenByIndex(uint256 index) public view override returns (uint256) {
1107     require(index < totalSupply(), "ERC721A: global index out of bounds");
1108     return index;
1109   }
1110 
1111   /**
1112    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1113    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1114    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1115    */
1116   function tokenOfOwnerByIndex(address owner, uint256 index)
1117     public
1118     view
1119     override
1120     returns (uint256)
1121   {
1122     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1123     uint256 numMintedSoFar = totalSupply();
1124     uint256 tokenIdsIdx = 0;
1125     address currOwnershipAddr = address(0);
1126     for (uint256 i = 0; i < numMintedSoFar; i++) {
1127       TokenOwnership memory ownership = _ownerships[i];
1128       if (ownership.addr != address(0)) {
1129         currOwnershipAddr = ownership.addr;
1130       }
1131       if (currOwnershipAddr == owner) {
1132         if (tokenIdsIdx == index) {
1133           return i;
1134         }
1135         tokenIdsIdx++;
1136       }
1137     }
1138     revert("ERC721A: unable to get token of owner by index");
1139   }
1140 
1141   /**
1142    * @dev See {IERC165-supportsInterface}.
1143    */
1144   function supportsInterface(bytes4 interfaceId)
1145     public
1146     view
1147     virtual
1148     override(ERC165, IERC165)
1149     returns (bool)
1150   {
1151     return
1152       interfaceId == type(IERC721).interfaceId ||
1153       interfaceId == type(IERC721Metadata).interfaceId ||
1154       interfaceId == type(IERC721Enumerable).interfaceId ||
1155       super.supportsInterface(interfaceId);
1156   }
1157 
1158   /**
1159    * @dev See {IERC721-balanceOf}.
1160    */
1161   function balanceOf(address owner) public view override returns (uint256) {
1162     require(owner != address(0), "ERC721A: balance query for the zero address");
1163     return uint256(_addressData[owner].balance);
1164   }
1165 
1166   function _numberMinted(address owner) internal view returns (uint256) {
1167     require(
1168       owner != address(0),
1169       "ERC721A: number minted query for the zero address"
1170     );
1171     return uint256(_addressData[owner].numberMinted);
1172   }
1173 
1174   function ownershipOf(uint256 tokenId)
1175     internal
1176     view
1177     returns (TokenOwnership memory)
1178   {
1179     uint256 curr = tokenId;
1180 
1181     unchecked {
1182         if (_startTokenId() <= curr && curr < currentIndex) {
1183             TokenOwnership memory ownership = _ownerships[curr];
1184             if (ownership.addr != address(0)) {
1185                 return ownership;
1186             }
1187 
1188             // Invariant:
1189             // There will always be an ownership that has an address and is not burned
1190             // before an ownership that does not have an address and is not burned.
1191             // Hence, curr will not underflow.
1192             while (true) {
1193                 curr--;
1194                 ownership = _ownerships[curr];
1195                 if (ownership.addr != address(0)) {
1196                     return ownership;
1197                 }
1198             }
1199         }
1200     }
1201 
1202     revert("ERC721A: unable to determine the owner of token");
1203   }
1204 
1205   /**
1206    * @dev See {IERC721-ownerOf}.
1207    */
1208   function ownerOf(uint256 tokenId) public view override returns (address) {
1209     return ownershipOf(tokenId).addr;
1210   }
1211 
1212   /**
1213    * @dev See {IERC721Metadata-name}.
1214    */
1215   function name() public view virtual override returns (string memory) {
1216     return _name;
1217   }
1218 
1219   /**
1220    * @dev See {IERC721Metadata-symbol}.
1221    */
1222   function symbol() public view virtual override returns (string memory) {
1223     return _symbol;
1224   }
1225 
1226   /**
1227    * @dev See {IERC721Metadata-tokenURI}.
1228    */
1229   function tokenURI(uint256 tokenId)
1230     public
1231     view
1232     virtual
1233     override
1234     returns (string memory)
1235   {
1236     string memory baseURI = _baseURI();
1237     return
1238       bytes(baseURI).length > 0
1239         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1240         : "";
1241   }
1242 
1243   /**
1244    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1245    * token will be the concatenation of the baseURI and the tokenId. Empty
1246    * by default, can be overriden in child contracts.
1247    */
1248   function _baseURI() internal view virtual returns (string memory) {
1249     return "";
1250   }
1251 
1252   /**
1253    * @dev Sets the value for an address to be in the restricted approval address pool.
1254    * Setting an address to true will disable token owners from being able to mark the address
1255    * for approval for trading. This would be used in theory to prevent token owners from listing
1256    * on specific marketplaces or protcols. Only modifible by the contract owner/team.
1257    * @param _address the marketplace/user to modify restriction status of
1258    * @param _isRestricted restriction status of the _address to be set. true => Restricted, false => Open
1259    */
1260   function setApprovalRestriction(address _address, bool _isRestricted) public onlyTeamOrOwner {
1261     restrictedApprovalAddresses[_address] = _isRestricted;
1262   }
1263 
1264   /**
1265    * @dev See {IERC721-approve}.
1266    */
1267   function approve(address to, uint256 tokenId) public override {
1268     address owner = ERC721A.ownerOf(tokenId);
1269     require(to != owner, "ERC721A: approval to current owner");
1270     require(restrictedApprovalAddresses[to] == false, "ERC721RestrictedApproval: Address to approve has been restricted by contract owner and is not allowed to be marked for approval");
1271 
1272     require(
1273       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1274       "ERC721A: approve caller is not owner nor approved for all"
1275     );
1276 
1277     _approve(to, tokenId, owner);
1278   }
1279 
1280   /**
1281    * @dev See {IERC721-getApproved}.
1282    */
1283   function getApproved(uint256 tokenId) public view override returns (address) {
1284     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1285 
1286     return _tokenApprovals[tokenId];
1287   }
1288 
1289   /**
1290    * @dev See {IERC721-setApprovalForAll}.
1291    */
1292   function setApprovalForAll(address operator, bool approved) public override {
1293     require(operator != _msgSender(), "ERC721A: approve to caller");
1294     require(restrictedApprovalAddresses[operator] == false, "ERC721RestrictedApproval: Operator address has been restricted by contract owner and is not allowed to be marked for approval");
1295 
1296     _operatorApprovals[_msgSender()][operator] = approved;
1297     emit ApprovalForAll(_msgSender(), operator, approved);
1298   }
1299 
1300   /**
1301    * @dev See {IERC721-isApprovedForAll}.
1302    */
1303   function isApprovedForAll(address owner, address operator)
1304     public
1305     view
1306     virtual
1307     override
1308     returns (bool)
1309   {
1310     return _operatorApprovals[owner][operator];
1311   }
1312 
1313   /**
1314    * @dev See {IERC721-transferFrom}.
1315    */
1316   function transferFrom(
1317     address from,
1318     address to,
1319     uint256 tokenId
1320   ) public override {
1321     _transfer(from, to, tokenId);
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-safeTransferFrom}.
1326    */
1327   function safeTransferFrom(
1328     address from,
1329     address to,
1330     uint256 tokenId
1331   ) public override {
1332     safeTransferFrom(from, to, tokenId, "");
1333   }
1334 
1335   /**
1336    * @dev See {IERC721-safeTransferFrom}.
1337    */
1338   function safeTransferFrom(
1339     address from,
1340     address to,
1341     uint256 tokenId,
1342     bytes memory _data
1343   ) public override {
1344     _transfer(from, to, tokenId);
1345     require(
1346       _checkOnERC721Received(from, to, tokenId, _data),
1347       "ERC721A: transfer to non ERC721Receiver implementer"
1348     );
1349   }
1350 
1351   /**
1352    * @dev Returns whether tokenId exists.
1353    *
1354    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1355    *
1356    * Tokens start existing when they are minted (_mint),
1357    */
1358   function _exists(uint256 tokenId) internal view returns (bool) {
1359     return _startTokenId() <= tokenId && tokenId < currentIndex;
1360   }
1361 
1362   function _safeMint(address to, uint256 quantity, bool isAdminMint) internal {
1363     _safeMint(to, quantity, isAdminMint, "");
1364   }
1365 
1366   /**
1367    * @dev Mints quantity tokens and transfers them to to.
1368    *
1369    * Requirements:
1370    *
1371    * - there must be quantity tokens remaining unminted in the total collection.
1372    * - to cannot be the zero address.
1373    * - quantity cannot be larger than the max batch size.
1374    *
1375    * Emits a {Transfer} event.
1376    */
1377   function _safeMint(
1378     address to,
1379     uint256 quantity,
1380     bool isAdminMint,
1381     bytes memory _data
1382   ) internal {
1383     uint256 startTokenId = currentIndex;
1384     require(to != address(0), "ERC721A: mint to the zero address");
1385     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1386     require(!_exists(startTokenId), "ERC721A: token already minted");
1387 
1388     // For admin mints we do not want to enforce the maxBatchSize limit
1389     if (isAdminMint == false) {
1390         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1391     }
1392 
1393     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1394 
1395     AddressData memory addressData = _addressData[to];
1396     _addressData[to] = AddressData(
1397       addressData.balance + uint128(quantity),
1398       addressData.numberMinted + (isAdminMint ? 0 : uint128(quantity))
1399     );
1400     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1401 
1402     uint256 updatedIndex = startTokenId;
1403 
1404     for (uint256 i = 0; i < quantity; i++) {
1405       emit Transfer(address(0), to, updatedIndex);
1406       require(
1407         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1408         "ERC721A: transfer to non ERC721Receiver implementer"
1409       );
1410       updatedIndex++;
1411     }
1412 
1413     currentIndex = updatedIndex;
1414     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1415   }
1416 
1417   /**
1418    * @dev Transfers tokenId from from to to.
1419    *
1420    * Requirements:
1421    *
1422    * - to cannot be the zero address.
1423    * - tokenId token must be owned by from.
1424    *
1425    * Emits a {Transfer} event.
1426    */
1427   function _transfer(
1428     address from,
1429     address to,
1430     uint256 tokenId
1431   ) private {
1432     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1433 
1434     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1435       getApproved(tokenId) == _msgSender() ||
1436       isApprovedForAll(prevOwnership.addr, _msgSender()));
1437 
1438     require(
1439       isApprovedOrOwner,
1440       "ERC721A: transfer caller is not owner nor approved"
1441     );
1442 
1443     require(
1444       prevOwnership.addr == from,
1445       "ERC721A: transfer from incorrect owner"
1446     );
1447     require(to != address(0), "ERC721A: transfer to the zero address");
1448 
1449     _beforeTokenTransfers(from, to, tokenId, 1);
1450 
1451     // Clear approvals from the previous owner
1452     _approve(address(0), tokenId, prevOwnership.addr);
1453 
1454     _addressData[from].balance -= 1;
1455     _addressData[to].balance += 1;
1456     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1457 
1458     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1459     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1460     uint256 nextTokenId = tokenId + 1;
1461     if (_ownerships[nextTokenId].addr == address(0)) {
1462       if (_exists(nextTokenId)) {
1463         _ownerships[nextTokenId] = TokenOwnership(
1464           prevOwnership.addr,
1465           prevOwnership.startTimestamp
1466         );
1467       }
1468     }
1469 
1470     emit Transfer(from, to, tokenId);
1471     _afterTokenTransfers(from, to, tokenId, 1);
1472   }
1473 
1474   /**
1475    * @dev Approve to to operate on tokenId
1476    *
1477    * Emits a {Approval} event.
1478    */
1479   function _approve(
1480     address to,
1481     uint256 tokenId,
1482     address owner
1483   ) private {
1484     _tokenApprovals[tokenId] = to;
1485     emit Approval(owner, to, tokenId);
1486   }
1487 
1488   uint256 public nextOwnerToExplicitlySet = 0;
1489 
1490   /**
1491    * @dev Explicitly set owners to eliminate loops in future calls of ownerOf().
1492    */
1493   function _setOwnersExplicit(uint256 quantity) internal {
1494     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1495     require(quantity > 0, "quantity must be nonzero");
1496     if (currentIndex == _startTokenId()) revert('No Tokens Minted Yet');
1497 
1498     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1499     if (endIndex > collectionSize - 1) {
1500       endIndex = collectionSize - 1;
1501     }
1502     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1503     require(_exists(endIndex), "not enough minted yet for this cleanup");
1504     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1505       if (_ownerships[i].addr == address(0)) {
1506         TokenOwnership memory ownership = ownershipOf(i);
1507         _ownerships[i] = TokenOwnership(
1508           ownership.addr,
1509           ownership.startTimestamp
1510         );
1511       }
1512     }
1513     nextOwnerToExplicitlySet = endIndex + 1;
1514   }
1515 
1516   /**
1517    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1518    * The call is not executed if the target address is not a contract.
1519    *
1520    * @param from address representing the previous owner of the given token ID
1521    * @param to target address that will receive the tokens
1522    * @param tokenId uint256 ID of the token to be transferred
1523    * @param _data bytes optional data to send along with the call
1524    * @return bool whether the call correctly returned the expected magic value
1525    */
1526   function _checkOnERC721Received(
1527     address from,
1528     address to,
1529     uint256 tokenId,
1530     bytes memory _data
1531   ) private returns (bool) {
1532     if (to.isContract()) {
1533       try
1534         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1535       returns (bytes4 retval) {
1536         return retval == IERC721Receiver(to).onERC721Received.selector;
1537       } catch (bytes memory reason) {
1538         if (reason.length == 0) {
1539           revert("ERC721A: transfer to non ERC721Receiver implementer");
1540         } else {
1541           assembly {
1542             revert(add(32, reason), mload(reason))
1543           }
1544         }
1545       }
1546     } else {
1547       return true;
1548     }
1549   }
1550 
1551   /**
1552    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1553    *
1554    * startTokenId - the first token id to be transferred
1555    * quantity - the amount to be transferred
1556    *
1557    * Calling conditions:
1558    *
1559    * - When from and to are both non-zero, from's tokenId will be
1560    * transferred to to.
1561    * - When from is zero, tokenId will be minted for to.
1562    */
1563   function _beforeTokenTransfers(
1564     address from,
1565     address to,
1566     uint256 startTokenId,
1567     uint256 quantity
1568   ) internal virtual {}
1569 
1570   /**
1571    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1572    * minting.
1573    *
1574    * startTokenId - the first token id to be transferred
1575    * quantity - the amount to be transferred
1576    *
1577    * Calling conditions:
1578    *
1579    * - when from and to are both non-zero.
1580    * - from and to are never both zero.
1581    */
1582   function _afterTokenTransfers(
1583     address from,
1584     address to,
1585     uint256 startTokenId,
1586     uint256 quantity
1587   ) internal virtual {}
1588 }
1589 
1590 
1591 
1592   
1593 abstract contract Ramppable {
1594   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1595 
1596   modifier isRampp() {
1597       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1598       _;
1599   }
1600 }
1601 
1602 
1603   
1604   
1605 interface IERC20 {
1606   function allowance(address owner, address spender) external view returns (uint256);
1607   function transfer(address _to, uint256 _amount) external returns (bool);
1608   function balanceOf(address account) external view returns (uint256);
1609   function transferFrom(address from, address to, uint256 amount) external returns (bool);
1610 }
1611 
1612 // File: WithdrawableV2
1613 // This abstract allows the contract to be able to mint and ingest ERC-20 payments for mints.
1614 // ERC-20 Payouts are limited to a single payout address. This feature 
1615 // will charge a small flat fee in native currency that is not subject to regular rev sharing.
1616 // This contract also covers the normal functionality of accepting native base currency rev-sharing
1617 abstract contract WithdrawableV2 is Teams, Ramppable {
1618   struct acceptedERC20 {
1619     bool isActive;
1620     uint256 chargeAmount;
1621   }
1622 
1623   
1624   mapping(address => acceptedERC20) private allowedTokenContracts;
1625   address[] public payableAddresses = [RAMPPADDRESS,0x5cCa867939aA9CBbd8757339659bfDbf3948091B,0x533A3FDD4F66F1CB854Dd1231751D3a762488b83];
1626   address[] public surchargePayableAddresses = [RAMPPADDRESS];
1627   address public erc20Payable = 0x533A3FDD4F66F1CB854Dd1231751D3a762488b83;
1628   uint256[] public payableFees = [1,4,95];
1629   uint256[] public surchargePayableFees = [100];
1630   uint256 public payableAddressCount = 3;
1631   uint256 public surchargePayableAddressCount = 1;
1632   uint256 public ramppSurchargeBalance = 0 ether;
1633   uint256 public ramppSurchargeFee = 0.001 ether;
1634   bool public onlyERC20MintingMode = false;
1635   
1636 
1637   /**
1638   * @dev Calculates the true payable balance of the contract as the
1639   * value on contract may be from ERC-20 mint surcharges and not 
1640   * public mint charges - which are not eligable for rev share & user withdrawl
1641   */
1642   function calcAvailableBalance() public view returns(uint256) {
1643     return address(this).balance - ramppSurchargeBalance;
1644   }
1645 
1646   function withdrawAll() public onlyTeamOrOwner {
1647       require(calcAvailableBalance() > 0);
1648       _withdrawAll();
1649   }
1650   
1651   function withdrawAllRampp() public isRampp {
1652       require(calcAvailableBalance() > 0);
1653       _withdrawAll();
1654   }
1655 
1656   function _withdrawAll() private {
1657       uint256 balance = calcAvailableBalance();
1658       
1659       for(uint i=0; i < payableAddressCount; i++ ) {
1660           _widthdraw(
1661               payableAddresses[i],
1662               (balance * payableFees[i]) / 100
1663           );
1664       }
1665   }
1666   
1667   function _widthdraw(address _address, uint256 _amount) private {
1668       (bool success, ) = _address.call{value: _amount}("");
1669       require(success, "Transfer failed.");
1670   }
1671 
1672   /**
1673   * @dev This function is similiar to the regular withdraw but operates only on the
1674   * balance that is available to surcharge payout addresses. This would be Rampp + partners
1675   **/
1676   function _withdrawAllSurcharges() private {
1677     uint256 balance = ramppSurchargeBalance;
1678     if(balance == 0) { return; }
1679     
1680     for(uint i=0; i < surchargePayableAddressCount; i++ ) {
1681         _widthdraw(
1682             surchargePayableAddresses[i],
1683             (balance * surchargePayableFees[i]) / 100
1684         );
1685     }
1686     ramppSurchargeBalance = 0 ether;
1687   }
1688 
1689   /**
1690   * @dev Allow contract owner to withdraw ERC-20 balance from contract
1691   * in the event ERC-20 tokens are paid to the contract for mints. This will
1692   * send the tokens to the payout as well as payout the surcharge fee to Rampp
1693   * @param _tokenContract contract of ERC-20 token to withdraw
1694   * @param _amountToWithdraw balance to withdraw according to balanceOf of ERC-20 token in wei
1695   */
1696   function withdrawERC20(address _tokenContract, uint256 _amountToWithdraw) public onlyTeamOrOwner {
1697     require(_amountToWithdraw > 0);
1698     IERC20 tokenContract = IERC20(_tokenContract);
1699     require(tokenContract.balanceOf(address(this)) >= _amountToWithdraw, "WithdrawV2: Contract does not own enough tokens");
1700     tokenContract.transfer(erc20Payable, _amountToWithdraw); // Payout ERC-20 tokens to recipient
1701     _withdrawAllSurcharges();
1702   }
1703 
1704   /**
1705   * @dev Allow Rampp to be able to withdraw only its ERC-20 payment surcharges from the contract.
1706   */
1707   function withdrawRamppSurcharges() public isRampp {
1708     require(ramppSurchargeBalance > 0, "WithdrawableV2: No Rampp surcharges in balance.");
1709     _withdrawAllSurcharges();
1710   }
1711 
1712    /**
1713   * @dev Helper function to increment Rampp surcharge balance when ERC-20 payment is made.
1714   */
1715   function addSurcharge() internal {
1716     ramppSurchargeBalance += ramppSurchargeFee;
1717   }
1718   
1719   /**
1720   * @dev Helper function to enforce Rampp surcharge fee when ERC-20 mint is made.
1721   */
1722   function hasSurcharge() internal returns(bool) {
1723     return msg.value == ramppSurchargeFee;
1724   }
1725 
1726   /**
1727   * @dev Set surcharge fee for using ERC-20 payments on contract
1728   * @param _newSurcharge is the new surcharge value of native currency in wei to facilitate ERC-20 payments
1729   */
1730   function setRamppSurcharge(uint256 _newSurcharge) public isRampp {
1731     ramppSurchargeFee = _newSurcharge;
1732   }
1733 
1734   /**
1735   * @dev check if an ERC-20 contract is a valid payable contract for executing a mint.
1736   * @param _erc20TokenContract address of ERC-20 contract in question
1737   */
1738   function isApprovedForERC20Payments(address _erc20TokenContract) public view returns(bool) {
1739     return allowedTokenContracts[_erc20TokenContract].isActive == true;
1740   }
1741 
1742   /**
1743   * @dev get the value of tokens to transfer for user of an ERC-20
1744   * @param _erc20TokenContract address of ERC-20 contract in question
1745   */
1746   function chargeAmountForERC20(address _erc20TokenContract) public view returns(uint256) {
1747     require(isApprovedForERC20Payments(_erc20TokenContract), "This ERC-20 contract is not approved to make payments on this contract!");
1748     return allowedTokenContracts[_erc20TokenContract].chargeAmount;
1749   }
1750 
1751   /**
1752   * @dev Explicity sets and ERC-20 contract as an allowed payment method for minting
1753   * @param _erc20TokenContract address of ERC-20 contract in question
1754   * @param _isActive default status of if contract should be allowed to accept payments
1755   * @param _chargeAmountInTokens fee (in tokens) to charge for mints for this specific ERC-20 token
1756   */
1757   function addOrUpdateERC20ContractAsPayment(address _erc20TokenContract, bool _isActive, uint256 _chargeAmountInTokens) public onlyTeamOrOwner {
1758     allowedTokenContracts[_erc20TokenContract].isActive = _isActive;
1759     allowedTokenContracts[_erc20TokenContract].chargeAmount = _chargeAmountInTokens;
1760   }
1761 
1762   /**
1763   * @dev Add an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1764   * it will assume the default value of zero. This should not be used to create new payment tokens.
1765   * @param _erc20TokenContract address of ERC-20 contract in question
1766   */
1767   function enableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1768     allowedTokenContracts[_erc20TokenContract].isActive = true;
1769   }
1770 
1771   /**
1772   * @dev Disable an ERC-20 contract as being a valid payment method. If passed a contract which has not been added
1773   * it will assume the default value of zero. This should not be used to create new payment tokens.
1774   * @param _erc20TokenContract address of ERC-20 contract in question
1775   */
1776   function disableERC20ContractAsPayment(address _erc20TokenContract) public onlyTeamOrOwner {
1777     allowedTokenContracts[_erc20TokenContract].isActive = false;
1778   }
1779 
1780   /**
1781   * @dev Enable only ERC-20 payments for minting on this contract
1782   */
1783   function enableERC20OnlyMinting() public onlyTeamOrOwner {
1784     onlyERC20MintingMode = true;
1785   }
1786 
1787   /**
1788   * @dev Disable only ERC-20 payments for minting on this contract
1789   */
1790   function disableERC20OnlyMinting() public onlyTeamOrOwner {
1791     onlyERC20MintingMode = false;
1792   }
1793 
1794   /**
1795   * @dev Set the payout of the ERC-20 token payout to a specific address
1796   * @param _newErc20Payable new payout addresses of ERC-20 tokens
1797   */
1798   function setERC20PayableAddress(address _newErc20Payable) public onlyTeamOrOwner {
1799     require(_newErc20Payable != address(0), "WithdrawableV2: new ERC-20 payout cannot be the zero address");
1800     require(_newErc20Payable != erc20Payable, "WithdrawableV2: new ERC-20 payout is same as current payout");
1801     erc20Payable = _newErc20Payable;
1802   }
1803 
1804   /**
1805   * @dev Reset the Rampp surcharge total to zero regardless of value on contract currently.
1806   */
1807   function resetRamppSurchargeBalance() public isRampp {
1808     ramppSurchargeBalance = 0 ether;
1809   }
1810 
1811   /**
1812   * @dev Allows Rampp wallet to update its own reference as well as update
1813   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1814   * and since Rampp is always the first address this function is limited to the rampp payout only.
1815   * @param _newAddress updated Rampp Address
1816   */
1817   function setRamppAddress(address _newAddress) public isRampp {
1818     require(_newAddress != RAMPPADDRESS, "WithdrawableV2: New Rampp address must be different");
1819     RAMPPADDRESS = _newAddress;
1820     payableAddresses[0] = _newAddress;
1821   }
1822 }
1823 
1824 
1825   
1826   
1827   
1828   
1829 abstract contract RamppERC721A is 
1830     Ownable,
1831     Teams,
1832     ERC721A,
1833     WithdrawableV2,
1834     ReentrancyGuard 
1835      
1836     , Allowlist 
1837     
1838 {
1839   constructor(
1840     string memory tokenName,
1841     string memory tokenSymbol
1842   ) ERC721A(tokenName, tokenSymbol, 2, 999) { }
1843     uint8 public CONTRACT_VERSION = 2;
1844     string public _baseTokenURI = "ipfs://bafybeie7qmhcmhq5notjvr7rpighdcuu4kfd47bkxz6zayrr6qgoqdkxva/";
1845 
1846     bool public mintingOpen = false;
1847     bool public isRevealed = false;
1848     
1849     uint256 public MAX_WALLET_MINTS = 2;
1850 
1851   
1852     /////////////// Admin Mint Functions
1853     /**
1854      * @dev Mints a token to an address with a tokenURI.
1855      * This is owner only and allows a fee-free drop
1856      * @param _to address of the future owner of the token
1857      * @param _qty amount of tokens to drop the owner
1858      */
1859      function mintToAdminV2(address _to, uint256 _qty) public onlyTeamOrOwner{
1860          require(_qty > 0, "Must mint at least 1 token.");
1861          require(currentTokenId() + _qty <= collectionSize, "Cannot mint over supply cap of 999");
1862          _safeMint(_to, _qty, true);
1863      }
1864 
1865   
1866     /////////////// GENERIC MINT FUNCTIONS
1867     /**
1868     * @dev Mints a single token to an address.
1869     * fee may or may not be required*
1870     * @param _to address of the future owner of the token
1871     */
1872     function mintTo(address _to) public payable {
1873         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1874         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1875         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1876         
1877         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1878         
1879 
1880         _safeMint(_to, 1, false);
1881     }
1882 
1883     /**
1884     * @dev Mints tokens to an address in batch.
1885     * fee may or may not be required*
1886     * @param _to address of the future owner of the token
1887     * @param _amount number of tokens to mint
1888     */
1889     function mintToMultiple(address _to, uint256 _amount) public payable {
1890         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1891         require(_amount >= 1, "Must mint at least 1 token");
1892         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1893         require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1894         
1895         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1896         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1897         
1898 
1899         _safeMint(_to, _amount, false);
1900     }
1901 
1902     /**
1903      * @dev Mints tokens to an address in batch using an ERC-20 token for payment
1904      * fee may or may not be required*
1905      * @param _to address of the future owner of the token
1906      * @param _amount number of tokens to mint
1907      * @param _erc20TokenContract erc-20 token contract to mint with
1908      */
1909     function mintToMultipleERC20(address _to, uint256 _amount, address _erc20TokenContract) public payable {
1910       require(_amount >= 1, "Must mint at least 1 token");
1911       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1912       require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1913       require(mintingOpen == true && onlyAllowlistMode == false, "Public minting is not open right now!");
1914       
1915       require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1916 
1917       // ERC-20 Specific pre-flight checks
1918       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
1919       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
1920       IERC20 payableToken = IERC20(_erc20TokenContract);
1921 
1922       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
1923       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
1924       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
1925       
1926       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
1927       require(transferComplete, "ERC-20 token was unable to be transferred");
1928       
1929       _safeMint(_to, _amount, false);
1930       addSurcharge();
1931     }
1932 
1933     function openMinting() public onlyTeamOrOwner {
1934         mintingOpen = true;
1935     }
1936 
1937     function stopMinting() public onlyTeamOrOwner {
1938         mintingOpen = false;
1939     }
1940 
1941   
1942     ///////////// ALLOWLIST MINTING FUNCTIONS
1943 
1944     /**
1945     * @dev Mints tokens to an address using an allowlist.
1946     * fee may or may not be required*
1947     * @param _to address of the future owner of the token
1948     * @param _merkleProof merkle proof array
1949     */
1950     function mintToAL(address _to, bytes32[] calldata _merkleProof) public payable {
1951         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1952         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1953         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1954         require(getNextTokenId() <= collectionSize, "Cannot mint over supply cap of 999");
1955         require(canMintAmount(_to, 1), "Wallet address is over the maximum allowed mints");
1956         
1957         
1958 
1959         _safeMint(_to, 1, false);
1960     }
1961 
1962     /**
1963     * @dev Mints tokens to an address using an allowlist.
1964     * fee may or may not be required*
1965     * @param _to address of the future owner of the token
1966     * @param _amount number of tokens to mint
1967     * @param _merkleProof merkle proof array
1968     */
1969     function mintToMultipleAL(address _to, uint256 _amount, bytes32[] calldata _merkleProof) public payable {
1970         require(onlyERC20MintingMode == false, "Only minting with ERC-20 tokens is enabled.");
1971         require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1972         require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1973         require(_amount >= 1, "Must mint at least 1 token");
1974         require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1975 
1976         require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1977         require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1978         
1979         
1980 
1981         _safeMint(_to, _amount, false);
1982     }
1983 
1984     /**
1985     * @dev Mints tokens to an address using an allowlist.
1986     * fee may or may not be required*
1987     * @param _to address of the future owner of the token
1988     * @param _amount number of tokens to mint
1989     * @param _merkleProof merkle proof array
1990     * @param _erc20TokenContract erc-20 token contract to mint with
1991     */
1992     function mintToMultipleERC20AL(address _to, uint256 _amount, bytes32[] calldata _merkleProof, address _erc20TokenContract) public payable {
1993       require(onlyAllowlistMode == true && mintingOpen == true, "Allowlist minting is closed");
1994       require(isAllowlisted(_to, _merkleProof), "Address is not in Allowlist!");
1995       require(_amount >= 1, "Must mint at least 1 token");
1996       require(_amount <= maxBatchSize, "Cannot mint more than max mint per transaction");
1997       require(canMintAmount(_to, _amount), "Wallet address is over the maximum allowed mints");
1998       require(currentTokenId() + _amount <= collectionSize, "Cannot mint over supply cap of 999");
1999       
2000     
2001       // ERC-20 Specific pre-flight checks
2002       require(isApprovedForERC20Payments(_erc20TokenContract), "ERC-20 Token is not approved for minting!");
2003       uint256 tokensQtyToTransfer = chargeAmountForERC20(_erc20TokenContract) * _amount;
2004       IERC20 payableToken = IERC20(_erc20TokenContract);
2005     
2006       require(payableToken.balanceOf(_to) >= tokensQtyToTransfer, "Buyer does not own enough of token to complete purchase");
2007       require(payableToken.allowance(_to, address(this)) >= tokensQtyToTransfer, "Buyer did not approve enough of ERC-20 token to complete purchase");
2008       require(hasSurcharge(), "Fee for ERC-20 payment not provided!");
2009       
2010       bool transferComplete = payableToken.transferFrom(_to, address(this), tokensQtyToTransfer);
2011       require(transferComplete, "ERC-20 token was unable to be transferred");
2012       
2013       _safeMint(_to, _amount, false);
2014       addSurcharge();
2015     }
2016 
2017     /**
2018      * @dev Enable allowlist minting fully by enabling both flags
2019      * This is a convenience function for the Rampp user
2020      */
2021     function openAllowlistMint() public onlyTeamOrOwner {
2022         enableAllowlistOnlyMode();
2023         mintingOpen = true;
2024     }
2025 
2026     /**
2027      * @dev Close allowlist minting fully by disabling both flags
2028      * This is a convenience function for the Rampp user
2029      */
2030     function closeAllowlistMint() public onlyTeamOrOwner {
2031         disableAllowlistOnlyMode();
2032         mintingOpen = false;
2033     }
2034 
2035 
2036   
2037     /**
2038     * @dev Check if wallet over MAX_WALLET_MINTS
2039     * @param _address address in question to check if minted count exceeds max
2040     */
2041     function canMintAmount(address _address, uint256 _amount) public view returns(bool) {
2042         require(_amount >= 1, "Amount must be greater than or equal to 1");
2043         return (_numberMinted(_address) + _amount) <= MAX_WALLET_MINTS;
2044     }
2045 
2046     /**
2047     * @dev Update the maximum amount of tokens that can be minted by a unique wallet
2048     * @param _newWalletMax the new max of tokens a wallet can mint. Must be >= 1
2049     */
2050     function setWalletMax(uint256 _newWalletMax) public onlyTeamOrOwner {
2051         require(_newWalletMax >= 1, "Max mints per wallet must be at least 1");
2052         MAX_WALLET_MINTS = _newWalletMax;
2053     }
2054     
2055 
2056   
2057     /**
2058      * @dev Allows owner to set Max mints per tx
2059      * @param _newMaxMint maximum amount of tokens allowed to mint per tx. Must be >= 1
2060      */
2061      function setMaxMint(uint256 _newMaxMint) public onlyTeamOrOwner {
2062          require(_newMaxMint >= 1, "Max mint must be at least 1");
2063          maxBatchSize = _newMaxMint;
2064      }
2065     
2066 
2067   
2068     function unveil(string memory _updatedTokenURI) public onlyTeamOrOwner {
2069         require(isRevealed == false, "Tokens are already unveiled");
2070         _baseTokenURI = _updatedTokenURI;
2071         isRevealed = true;
2072     }
2073     
2074 
2075   function _baseURI() internal view virtual override returns(string memory) {
2076     return _baseTokenURI;
2077   }
2078 
2079   function baseTokenURI() public view returns(string memory) {
2080     return _baseTokenURI;
2081   }
2082 
2083   function setBaseURI(string calldata baseURI) external onlyTeamOrOwner {
2084     _baseTokenURI = baseURI;
2085   }
2086 
2087   function getOwnershipData(uint256 tokenId) external view returns(TokenOwnership memory) {
2088     return ownershipOf(tokenId);
2089   }
2090 }
2091 
2092 
2093   
2094 // File: contracts/LuckyContract.sol
2095 //SPDX-License-Identifier: MIT
2096 
2097 pragma solidity ^0.8.0;
2098 
2099 contract LuckyContract is RamppERC721A {
2100     constructor() RamppERC721A("Lucky", "LCK"){}
2101 }
2102   
2103 //*********************************************************************//
2104 //*********************************************************************//  
2105 //                       Mintplex v2.1.0
2106 //
2107 //         This smart contract was generated by mintplex.xyz.
2108 //            Mintplex allows creators like you to launch 
2109 //             large scale NFT communities without code!
2110 //
2111 //    Mintplex is not responsible for the content of this contract and
2112 //        hopes it is being used in a responsible and kind way.  
2113 //       Mintplex is not associated or affiliated with this project.                                                    
2114 //             Twitter: @MintplexNFT ---- mintplex.xyz
2115 //*********************************************************************//                                                     
2116 //*********************************************************************// 
