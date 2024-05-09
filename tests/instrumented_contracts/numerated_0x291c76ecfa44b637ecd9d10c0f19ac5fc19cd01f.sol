1 //LLLLLLLLLLL                                      LLLLLLLLLLL                                                                                           
2 //L:::::::::L                                      L:::::::::L                                                                                           
3 //L:::::::::L                                      L:::::::::L                                                                                           
4 //LL:::::::LL                                      LL:::::::LL                                                                                           
5 //  L:::::L                   eeeeeeeeeeee           L:::::L                   eeeeeeeeeeee    nnnn  nnnnnnnn    nnnn  nnnnnnnn yyyyyyy           yyyyyyy
6 //  L:::::L                 ee::::::::::::ee         L:::::L                 ee::::::::::::ee  n:::nn::::::::nn  n:::nn::::::::nny:::::y         y:::::y 
7 //  L:::::L                e::::::eeeee:::::ee       L:::::L                e::::::eeeee:::::een::::::::::::::nn n::::::::::::::nny:::::y       y:::::y  
8 //  L:::::L               e::::::e     e:::::e       L:::::L               e::::::e     e:::::enn:::::::::::::::nnn:::::::::::::::ny:::::y     y:::::y   
9 //  L:::::L               e:::::::eeeee::::::e       L:::::L               e:::::::eeeee::::::e  n:::::nnnn:::::n  n:::::nnnn:::::n y:::::y   y:::::y    
10 //  L:::::L               e:::::::::::::::::e        L:::::L               e:::::::::::::::::e   n::::n    n::::n  n::::n    n::::n  y:::::y y:::::y     
11 //  L:::::L               e::::::eeeeeeeeeee         L:::::L               e::::::eeeeeeeeeee    n::::n    n::::n  n::::n    n::::n   y:::::y:::::y      
12 //  L:::::L         LLLLLLe:::::::e                  L:::::L         LLLLLLe:::::::e             n::::n    n::::n  n::::n    n::::n    y:::::::::y       
13 //LL:::::::LLLLLLLLL:::::Le::::::::e               LL:::::::LLLLLLLLL:::::Le::::::::e            n::::n    n::::n  n::::n    n::::n     y:::::::y        
14 //L::::::::::::::::::::::L e::::::::eeeeeeee       L::::::::::::::::::::::L e::::::::eeeeeeee    n::::n    n::::n  n::::n    n::::n      y:::::y         
15 //L::::::::::::::::::::::L  ee:::::::::::::e       L::::::::::::::::::::::L  ee:::::::::::::e    n::::n    n::::n  n::::n    n::::n     y:::::y          
16 //LLLLLLLLLLLLLLLLLLLLLLLL    eeeeeeeeeeeeee       LLLLLLLLLLLLLLLLLLLLLLLL    eeeeeeeeeeeeee    nnnnnn    nnnnnn  nnnnnn    nnnnnn    y:::::y           
17 //                                                                                                                                    y:::::y            
18 //                                                                                                                                   y:::::y             
19 //                                                                                                                                  y:::::y              
20 //                                                                                                                                 y:::::y               
21 //                                                                                                                                yyyyyyy      
22 //BY: PISS ANGELS
23 //
24 // (╯°□°)╯︵ ┻━┻ *us symbolically flipping the nft space upside down*
25 
26 
27 // SPDX-License-Identifier: MIT
28 
29 // File: @openzeppelin/contracts/utils/Counters.sol
30 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @title Counters
36  * @author Matt Condon (@shrugs)
37  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
38  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
39  *
40  * Include with `using Counters for Counters.Counter;`
41  */
42 library Counters {
43     struct Counter {
44         // This variable should never be directly accessed by users of the library: interactions must be restricted to
45         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
46         // this feature: see https://github.com/ethereum/solidity/issues/4637
47         uint256 _value; // default: 0
48     }
49 
50     function current(Counter storage counter) internal view returns (uint256) {
51         return counter._value;
52     }
53 
54     function increment(Counter storage counter) internal {
55         unchecked {
56             counter._value += 1;
57         }
58     }
59 
60     function decrement(Counter storage counter) internal {
61         uint256 value = counter._value;
62         require(value > 0, "Counter: decrement overflow");
63         unchecked {
64             counter._value = value - 1;
65         }
66     }
67 
68     function reset(Counter storage counter) internal {
69         counter._value = 0;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev Contract module which provides a basic access control mechanism, where
173  * there is an account (an owner) that can be granted exclusive access to
174  * specific functions.
175  *
176  * By default, the owner account will be the one that deploys the contract. This
177  * can later be changed with {transferOwnership}.
178  *
179  * This module is used through inheritance. It will make available the modifier
180  * `onlyOwner`, which can be applied to your functions to restrict their use to
181  * the owner.
182  */
183 abstract contract Ownable is Context {
184     address private _owner;
185 
186     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
187 
188     /**
189      * @dev Initializes the contract setting the deployer as the initial owner.
190      */
191     constructor() {
192         _transferOwnership(_msgSender());
193     }
194 
195     /**
196      * @dev Returns the address of the current owner.
197      */
198     function owner() public view virtual returns (address) {
199         return _owner;
200     }
201 
202     /**
203      * @dev Throws if called by any account other than the owner.
204      */
205     modifier onlyOwner() {
206         require(owner() == _msgSender(), "Ownable: caller is not the owner");
207         _;
208     }
209 
210     /**
211      * @dev Leaves the contract without owner. It will not be possible to call
212      * `onlyOwner` functions anymore. Can only be called by the current owner.
213      *
214      * NOTE: Renouncing ownership will leave the contract without an owner,
215      * thereby removing any functionality that is only available to the owner.
216      */
217     function renounceOwnership() public virtual onlyOwner {
218         _transferOwnership(address(0));
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Can only be called by the current owner.
224      */
225     function transferOwnership(address newOwner) public virtual onlyOwner {
226         require(newOwner != address(0), "Ownable: new owner is the zero address");
227         _transferOwnership(newOwner);
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Internal function without access restriction.
233      */
234     function _transferOwnership(address newOwner) internal virtual {
235         address oldOwner = _owner;
236         _owner = newOwner;
237         emit OwnershipTransferred(oldOwner, newOwner);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         assembly {
274             size := extcodesize(account)
275         }
276         return size > 0;
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         (bool success, ) = recipient.call{value: amount}("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain `call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321         return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(
331         address target,
332         bytes memory data,
333         string memory errorMessage
334     ) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value
353     ) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value,
367         string memory errorMessage
368     ) internal returns (bytes memory) {
369         require(address(this).balance >= value, "Address: insufficient balance for call");
370         require(isContract(target), "Address: call to non-contract");
371 
372         (bool success, bytes memory returndata) = target.call{value: value}(data);
373         return verifyCallResult(success, returndata, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but performing a static call.
379      *
380      * _Available since v3.3._
381      */
382     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
383         return functionStaticCall(target, data, "Address: low-level static call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
388      * but performing a static call.
389      *
390      * _Available since v3.3._
391      */
392     function functionStaticCall(
393         address target,
394         bytes memory data,
395         string memory errorMessage
396     ) internal view returns (bytes memory) {
397         require(isContract(target), "Address: static call to non-contract");
398 
399         (bool success, bytes memory returndata) = target.staticcall(data);
400         return verifyCallResult(success, returndata, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but performing a delegate call.
406      *
407      * _Available since v3.4._
408      */
409     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
410         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
415      * but performing a delegate call.
416      *
417      * _Available since v3.4._
418      */
419     function functionDelegateCall(
420         address target,
421         bytes memory data,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(isContract(target), "Address: delegate call to non-contract");
425 
426         (bool success, bytes memory returndata) = target.delegatecall(data);
427         return verifyCallResult(success, returndata, errorMessage);
428     }
429 
430     /**
431      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
432      * revert reason using the provided one.
433      *
434      * _Available since v4.3._
435      */
436     function verifyCallResult(
437         bool success,
438         bytes memory returndata,
439         string memory errorMessage
440     ) internal pure returns (bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 assembly {
449                     let returndata_size := mload(returndata)
450                     revert(add(32, returndata), returndata_size)
451                 }
452             } else {
453                 revert(errorMessage);
454             }
455         }
456     }
457 }
458 
459 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
460 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @title ERC721 token receiver interface
466  * @dev Interface for any contract that wants to support safeTransfers
467  * from ERC721 asset contracts.
468  */
469 interface IERC721Receiver {
470     /**
471      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
472      * by `operator` from `from`, this function is called.
473      *
474      * It must return its Solidity selector to confirm the token transfer.
475      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
476      *
477      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
478      */
479     function onERC721Received(
480         address operator,
481         address from,
482         uint256 tokenId,
483         bytes calldata data
484     ) external returns (bytes4);
485 }
486 
487 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
488 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
489 
490 pragma solidity ^0.8.0;
491 
492 /**
493  * @dev Interface of the ERC165 standard, as defined in the
494  * https://eips.ethereum.org/EIPS/eip-165[EIP].
495  *
496  * Implementers can declare support of contract interfaces, which can then be
497  * queried by others ({ERC165Checker}).
498  *
499  * For an implementation, see {ERC165}.
500  */
501 interface IERC165 {
502     /**
503      * @dev Returns true if this contract implements the interface defined by
504      * `interfaceId`. See the corresponding
505      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
506      * to learn more about how these ids are created.
507      *
508      * This function call must use less than 30 000 gas.
509      */
510     function supportsInterface(bytes4 interfaceId) external view returns (bool);
511 }
512 
513 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
514 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Implementation of the {IERC165} interface.
521  *
522  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
523  * for the additional interface id that will be supported. For example:
524  *
525  * ```solidity
526  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
528  * }
529  * ```
530  *
531  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
532  */
533 abstract contract ERC165 is IERC165 {
534     /**
535      * @dev See {IERC165-supportsInterface}.
536      */
537     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
538         return interfaceId == type(IERC165).interfaceId;
539     }
540 }
541 
542 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Required interface of an ERC721 compliant contract.
550  */
551 interface IERC721 is IERC165 {
552     /**
553      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
554      */
555     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
559      */
560     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
564      */
565     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
566 
567     /**
568      * @dev Returns the number of tokens in ``owner``'s account.
569      */
570     function balanceOf(address owner) external view returns (uint256 balance);
571 
572     /**
573      * @dev Returns the owner of the `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function ownerOf(uint256 tokenId) external view returns (address owner);
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
648      *
649      * Requirements:
650      *
651      * - The `operator` cannot be the caller.
652      *
653      * Emits an {ApprovalForAll} event.
654      */
655     function setApprovalForAll(address operator, bool _approved) external;
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId,
681         bytes calldata data
682     ) external;
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
686 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 interface IERC721Metadata is IERC721 {
695     /**
696      * @dev Returns the token collection name.
697      */
698     function name() external view returns (string memory);
699 
700     /**
701      * @dev Returns the token collection symbol.
702      */
703     function symbol() external view returns (string memory);
704 
705     /**
706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
707      */
708     function tokenURI(uint256 tokenId) external view returns (string memory);
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
712 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
718  * the Metadata extension, but not including the Enumerable extension, which is available separately as
719  * {ERC721Enumerable}.
720  */
721 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
722     using Address for address;
723     using Strings for uint256;
724 
725     // Token name
726     string private _name;
727 
728     // Token symbol
729     string private _symbol;
730 
731     // Mapping from token ID to owner address
732     mapping(uint256 => address) private _owners;
733 
734     // Mapping owner address to token count
735     mapping(address => uint256) private _balances;
736 
737     // Mapping from token ID to approved address
738     mapping(uint256 => address) private _tokenApprovals;
739 
740     // Mapping from owner to operator approvals
741     mapping(address => mapping(address => bool)) private _operatorApprovals;
742 
743     /**
744      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
745      */
746     constructor(string memory name_, string memory symbol_) {
747         _name = name_;
748         _symbol = symbol_;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
755         return
756             interfaceId == type(IERC721).interfaceId ||
757             interfaceId == type(IERC721Metadata).interfaceId ||
758             super.supportsInterface(interfaceId);
759     }
760 
761     /**
762      * @dev See {IERC721-balanceOf}.
763      */
764     function balanceOf(address owner) public view virtual override returns (uint256) {
765         require(owner != address(0), "ERC721: balance query for the zero address");
766         return _balances[owner];
767     }
768 
769     /**
770      * @dev See {IERC721-ownerOf}.
771      */
772     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
773         address owner = _owners[tokenId];
774         require(owner != address(0), "ERC721: owner query for nonexistent token");
775         return owner;
776     }
777 
778     /**
779      * @dev See {IERC721Metadata-name}.
780      */
781     function name() public view virtual override returns (string memory) {
782         return _name;
783     }
784 
785     /**
786      * @dev See {IERC721Metadata-symbol}.
787      */
788     function symbol() public view virtual override returns (string memory) {
789         return _symbol;
790     }
791 
792     /**
793      * @dev See {IERC721Metadata-tokenURI}.
794      */
795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
796         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
797 
798         string memory baseURI = _baseURI();
799         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
800     }
801 
802     /**
803      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
804      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
805      * by default, can be overriden in child contracts.
806      */
807     function _baseURI() internal view virtual returns (string memory) {
808         return "";
809     }
810 
811     /**
812      * @dev See {IERC721-approve}.
813      */
814     function approve(address to, uint256 tokenId) public virtual override {
815         address owner = ERC721.ownerOf(tokenId);
816         require(to != owner, "ERC721: approval to current owner");
817 
818         require(
819             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
820             "ERC721: approve caller is not owner nor approved for all"
821         );
822 
823         _approve(to, tokenId);
824     }
825 
826     /**
827      * @dev See {IERC721-getApproved}.
828      */
829     function getApproved(uint256 tokenId) public view virtual override returns (address) {
830         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
831 
832         return _tokenApprovals[tokenId];
833     }
834 
835     /**
836      * @dev See {IERC721-setApprovalForAll}.
837      */
838     function setApprovalForAll(address operator, bool approved) public virtual override {
839         _setApprovalForAll(_msgSender(), operator, approved);
840     }
841 
842     /**
843      * @dev See {IERC721-isApprovedForAll}.
844      */
845     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
846         return _operatorApprovals[owner][operator];
847     }
848 
849     /**
850      * @dev See {IERC721-transferFrom}.
851      */
852     function transferFrom(
853         address from,
854         address to,
855         uint256 tokenId
856     ) public virtual override {
857         //solhint-disable-next-line max-line-length
858         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
859 
860         _transfer(from, to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-safeTransferFrom}.
865      */
866     function safeTransferFrom(
867         address from,
868         address to,
869         uint256 tokenId
870     ) public virtual override {
871         safeTransferFrom(from, to, tokenId, "");
872     }
873 
874     /**
875      * @dev See {IERC721-safeTransferFrom}.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes memory _data
882     ) public virtual override {
883         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
884         _safeTransfer(from, to, tokenId, _data);
885     }
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
890      *
891      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
892      *
893      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
894      * implement alternative mechanisms to perform token transfer, such as signature-based.
895      *
896      * Requirements:
897      *
898      * - `from` cannot be the zero address.
899      * - `to` cannot be the zero address.
900      * - `tokenId` token must exist and be owned by `from`.
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function _safeTransfer(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes memory _data
910     ) internal virtual {
911         _transfer(from, to, tokenId);
912         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
913     }
914 
915     /**
916      * @dev Returns whether `tokenId` exists.
917      *
918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
919      *
920      * Tokens start existing when they are minted (`_mint`),
921      * and stop existing when they are burned (`_burn`).
922      */
923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
924         return _owners[tokenId] != address(0);
925     }
926 
927     /**
928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
929      *
930      * Requirements:
931      *
932      * - `tokenId` must exist.
933      */
934     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
935         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
936         address owner = ERC721.ownerOf(tokenId);
937         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
938     }
939 
940     /**
941      * @dev Safely mints `tokenId` and transfers it to `to`.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must not exist.
946      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947      *
948      * Emits a {Transfer} event.
949      */
950     function _safeMint(address to, uint256 tokenId) internal virtual {
951         _safeMint(to, tokenId, "");
952     }
953 
954     /**
955      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
956      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
957      */
958     function _safeMint(
959         address to,
960         uint256 tokenId,
961         bytes memory _data
962     ) internal virtual {
963         _mint(to, tokenId);
964         require(
965             _checkOnERC721Received(address(0), to, tokenId, _data),
966             "ERC721: transfer to non ERC721Receiver implementer"
967         );
968     }
969 
970     /**
971      * @dev Mints `tokenId` and transfers it to `to`.
972      *
973      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
974      *
975      * Requirements:
976      *
977      * - `tokenId` must not exist.
978      * - `to` cannot be the zero address.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _mint(address to, uint256 tokenId) internal virtual {
983         require(to != address(0), "ERC721: mint to the zero address");
984         require(!_exists(tokenId), "ERC721: token already minted");
985 
986         _beforeTokenTransfer(address(0), to, tokenId);
987 
988         _balances[to] += 1;
989         _owners[tokenId] = to;
990 
991         emit Transfer(address(0), to, tokenId);
992     }
993 
994     /**
995      * @dev Destroys `tokenId`.
996      * The approval is cleared when the token is burned.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _burn(uint256 tokenId) internal virtual {
1005         address owner = ERC721.ownerOf(tokenId);
1006 
1007         _beforeTokenTransfer(owner, address(0), tokenId);
1008 
1009         // Clear approvals
1010         _approve(address(0), tokenId);
1011 
1012         _balances[owner] -= 1;
1013         delete _owners[tokenId];
1014 
1015         emit Transfer(owner, address(0), tokenId);
1016     }
1017 
1018     /**
1019      * @dev Transfers `tokenId` from `from` to `to`.
1020      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1021      *
1022      * Requirements:
1023      *
1024      * - `to` cannot be the zero address.
1025      * - `tokenId` token must be owned by `from`.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function _transfer(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) internal virtual {
1034         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1035         require(to != address(0), "ERC721: transfer to the zero address");
1036 
1037         _beforeTokenTransfer(from, to, tokenId);
1038 
1039         // Clear approvals from the previous owner
1040         _approve(address(0), tokenId);
1041 
1042         _balances[from] -= 1;
1043         _balances[to] += 1;
1044         _owners[tokenId] = to;
1045 
1046         emit Transfer(from, to, tokenId);
1047     }
1048 
1049     /**
1050      * @dev Approve `to` to operate on `tokenId`
1051      *
1052      * Emits a {Approval} event.
1053      */
1054     function _approve(address to, uint256 tokenId) internal virtual {
1055         _tokenApprovals[tokenId] = to;
1056         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1057     }
1058 
1059     /**
1060      * @dev Approve `operator` to operate on all of `owner` tokens
1061      *
1062      * Emits a {ApprovalForAll} event.
1063      */
1064     function _setApprovalForAll(
1065         address owner,
1066         address operator,
1067         bool approved
1068     ) internal virtual {
1069         require(owner != operator, "ERC721: approve to caller");
1070         _operatorApprovals[owner][operator] = approved;
1071         emit ApprovalForAll(owner, operator, approved);
1072     }
1073 
1074     /**
1075      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1076      * The call is not executed if the target address is not a contract.
1077      *
1078      * @param from address representing the previous owner of the given token ID
1079      * @param to target address that will receive the tokens
1080      * @param tokenId uint256 ID of the token to be transferred
1081      * @param _data bytes optional data to send along with the call
1082      * @return bool whether the call correctly returned the expected magic value
1083      */
1084     function _checkOnERC721Received(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) private returns (bool) {
1090         if (to.isContract()) {
1091             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1092                 return retval == IERC721Receiver.onERC721Received.selector;
1093             } catch (bytes memory reason) {
1094                 if (reason.length == 0) {
1095                     revert("ERC721: transfer to non ERC721Receiver implementer");
1096                 } else {
1097                     assembly {
1098                         revert(add(32, reason), mload(reason))
1099                     }
1100                 }
1101             }
1102         } else {
1103             return true;
1104         }
1105     }
1106 
1107     /**
1108      * @dev Hook that is called before any token transfer. This includes minting
1109      * and burning.
1110      *
1111      * Calling conditions:
1112      *
1113      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1114      * transferred to `to`.
1115      * - When `from` is zero, `tokenId` will be minted for `to`.
1116      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1117      * - `from` and `to` are never both zero.
1118      *
1119      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1120      */
1121     function _beforeTokenTransfer(
1122         address from,
1123         address to,
1124         uint256 tokenId
1125     ) internal virtual {}
1126 }
1127 
1128 // File: contracts/LE LENNY NFT SMART CONTRACT
1129 
1130 pragma solidity >=0.7.0 <0.9.0;
1131 
1132 contract LeLennyNFT is ERC721, Ownable {
1133   using Strings for uint256;
1134   using Counters for Counters.Counter;
1135 
1136   Counters.Counter private supply;
1137 
1138   string public uriPrefix = "";
1139   string public uriSuffix = ".json";
1140   string public hiddenMetadataUri;
1141   
1142   uint256 public cost = 0.00069 ether;
1143   uint256 public maxSupply = 3333;
1144   uint256 public maxMintAmountPerTx = 9;
1145 
1146   bool public paused = true;
1147   bool public revealed = false;
1148 
1149   constructor() ERC721("Le Lenny NFT", "LENNFT") {
1150     setHiddenMetadataUri("ipfs://QmbDB5VKcEydgT6MhcQkAoPcFV967sZBWMFEqwEMgWMmGD/lelennyloader.json");
1151   }
1152 
1153   modifier mintCompliance(uint256 _mintAmount) {
1154     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1155     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1156     _;
1157   }
1158 
1159   function totalSupply() public view returns (uint256) {
1160     return supply.current();
1161   }
1162 
1163   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1164     require(!paused, "The contract is paused!");
1165     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1166 
1167     _mintLoop(msg.sender, _mintAmount);
1168   }
1169   
1170   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1171     _mintLoop(_receiver, _mintAmount);
1172   }
1173 
1174   function walletOfOwner(address _owner)
1175     public
1176     view
1177     returns (uint256[] memory)
1178   {
1179     uint256 ownerTokenCount = balanceOf(_owner);
1180     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1181     uint256 currentTokenId = 1;
1182     uint256 ownedTokenIndex = 0;
1183 
1184     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1185       address currentTokenOwner = ownerOf(currentTokenId);
1186 
1187       if (currentTokenOwner == _owner) {
1188         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1189 
1190         ownedTokenIndex++;
1191       }
1192 
1193       currentTokenId++;
1194     }
1195 
1196     return ownedTokenIds;
1197   }
1198 
1199   function tokenURI(uint256 _tokenId)
1200     public
1201     view
1202     virtual
1203     override
1204     returns (string memory)
1205   {
1206     require(
1207       _exists(_tokenId),
1208       "ERC721Metadata: URI query for nonexistent token"
1209     );
1210 
1211     if (revealed == false) {
1212       return hiddenMetadataUri;
1213     }
1214 
1215     string memory currentBaseURI = _baseURI();
1216     return bytes(currentBaseURI).length > 0
1217         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1218         : "";
1219   }
1220 
1221   function setRevealed(bool _state) public onlyOwner {
1222     revealed = _state;
1223   }
1224 
1225   function setCost(uint256 _cost) public onlyOwner {
1226     cost = _cost;
1227   }
1228 
1229   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1230     maxMintAmountPerTx = _maxMintAmountPerTx;
1231   }
1232 
1233   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1234     hiddenMetadataUri = _hiddenMetadataUri;
1235   }
1236 
1237   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1238     uriPrefix = _uriPrefix;
1239   }
1240 
1241   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1242     uriSuffix = _uriSuffix;
1243   }
1244 
1245   function setPaused(bool _state) public onlyOwner {
1246     paused = _state;
1247   }
1248 
1249   function withdraw() public onlyOwner {
1250 
1251     // This will transfer the contract balance to the owner.
1252     // Do not remove this otherwise you will not be able to withdraw the funds.
1253     // =============================================================================
1254     (bool os, ) = payable(0x382A6216c35fEf447cdE1f6e4AF07652dfF3d243).call{value: address(this).balance}("");
1255     require(os);
1256     // =============================================================================
1257   }
1258 
1259   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1260     for (uint256 i = 0; i < _mintAmount; i++) {
1261       supply.increment();
1262       _safeMint(_receiver, supply.current());
1263     }
1264   }
1265 
1266   function _baseURI() internal view virtual override returns (string memory) {
1267     return uriPrefix;
1268   }
1269 }
1270 
1271 //WE LOVE YOU AND CANT WAIT TO START PROVIDING YALL WITH SOME VALUE!