1 // File: @openzeppelin/contracts-upgradeable/utils/introspection/IERC165Upgradeable.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity 0.8.17;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165Upgradeable {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol
30 
31 
32 /**
33  * @dev Required interface of an ERC721 compliant contract.
34  */
35 interface IERC721Upgradeable is IERC165Upgradeable {
36     /**
37      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
38      */
39     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
40 
41     /**
42      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
43      */
44     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
48      */
49     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
50 
51     /**
52      * @dev Returns the number of tokens in ``owner``'s account.
53      */
54     function balanceOf(address owner) external view returns (uint256 balance);
55 
56     /**
57      * @dev Returns the owner of the `tokenId` token.
58      *
59      * Requirements:
60      *
61      * - `tokenId` must exist.
62      */
63     function ownerOf(uint256 tokenId) external view returns (address owner);
64 
65     /**
66      * @dev Safely transfers `tokenId` token from `from` to `to`.
67      *
68      * Requirements:
69      *
70      * - `from` cannot be the zero address.
71      * - `to` cannot be the zero address.
72      * - `tokenId` token must exist and be owned by `from`.
73      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
74      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
75      *
76      * Emits a {Transfer} event.
77      */
78     function safeTransferFrom(
79         address from,
80         address to,
81         uint256 tokenId,
82         bytes calldata data
83     ) external;
84 
85     /**
86      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
87      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
88      *
89      * Requirements:
90      *
91      * - `from` cannot be the zero address.
92      * - `to` cannot be the zero address.
93      * - `tokenId` token must exist and be owned by `from`.
94      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
95      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
96      *
97      * Emits a {Transfer} event.
98      */
99     function safeTransferFrom(
100         address from,
101         address to,
102         uint256 tokenId
103     ) external;
104 
105     /**
106      * @dev Transfers `tokenId` token from `from` to `to`.
107      *
108      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
109      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
110      * understand this adds an external call which potentially creates a reentrancy vulnerability.
111      *
112      * Requirements:
113      *
114      * - `from` cannot be the zero address.
115      * - `to` cannot be the zero address.
116      * - `tokenId` token must be owned by `from`.
117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transferFrom(
122         address from,
123         address to,
124         uint256 tokenId
125     ) external;
126 
127     /**
128      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
129      * The approval is cleared when the token is transferred.
130      *
131      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
132      *
133      * Requirements:
134      *
135      * - The caller must own the token or be an approved operator.
136      * - `tokenId` must exist.
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address to, uint256 tokenId) external;
141 
142     /**
143      * @dev Approve or remove `operator` as an operator for the caller.
144      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
145      *
146      * Requirements:
147      *
148      * - The `operator` cannot be the caller.
149      *
150      * Emits an {ApprovalForAll} event.
151      */
152     function setApprovalForAll(address operator, bool _approved) external;
153 
154     /**
155      * @dev Returns the account approved for `tokenId` token.
156      *
157      * Requirements:
158      *
159      * - `tokenId` must exist.
160      */
161     function getApproved(uint256 tokenId) external view returns (address operator);
162 
163     /**
164      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
165      *
166      * See {setApprovalForAll}
167      */
168     function isApprovedForAll(address owner, address operator) external view returns (bool);
169 }
170 
171 // File: @openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol
172 
173 
174 /**
175  * @title ERC721 token receiver interface
176  * @dev Interface for any contract that wants to support safeTransfers
177  * from ERC721 asset contracts.
178  */
179 interface IERC721ReceiverUpgradeable {
180     /**
181      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
182      * by `operator` from `from`, this function is called.
183      *
184      * It must return its Solidity selector to confirm the token transfer.
185      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
186      *
187      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
188      */
189     function onERC721Received(
190         address operator,
191         address from,
192         uint256 tokenId,
193         bytes calldata data
194     ) external returns (bytes4);
195 }
196 
197 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721MetadataUpgradeable.sol
198 
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721MetadataUpgradeable is IERC721Upgradeable {
205     /**
206      * @dev Returns the token collection name.
207      */
208     function name() external view returns (string memory);
209 
210     /**
211      * @dev Returns the token collection symbol.
212      */
213     function symbol() external view returns (string memory);
214 
215     /**
216      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
217      */
218     function tokenURI(uint256 tokenId) external view returns (string memory);
219 }
220 
221 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
222 
223 
224 /**
225  * @dev Collection of functions related to the address type
226  */
227 library AddressUpgradeable {
228     /**
229      * @dev Returns true if `account` is a contract.
230      *
231      * [IMPORTANT]
232      * ====
233      * It is unsafe to assume that an address for which this function returns
234      * false is an externally-owned account (EOA) and not a contract.
235      *
236      * Among others, `isContract` will return false for the following
237      * types of addresses:
238      *
239      *  - an externally-owned account
240      *  - a contract in construction
241      *  - an address where a contract will be created
242      *  - an address where a contract lived, but was destroyed
243      * ====
244      *
245      * [IMPORTANT]
246      * ====
247      * You shouldn't rely on `isContract` to protect against flash loan attacks!
248      *
249      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
250      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
251      * constructor.
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // This method relies on extcodesize/address.code.length, which returns 0
256         // for contracts in construction, since the code is only stored at the end
257         // of the constructor execution.
258 
259         return account.code.length > 0;
260     }
261 
262     /**
263      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
264      * `recipient`, forwarding all available gas and reverting on errors.
265      *
266      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
267      * of certain opcodes, possibly making contracts go over the 2300 gas limit
268      * imposed by `transfer`, making them unable to receive funds via
269      * `transfer`. {sendValue} removes this limitation.
270      *
271      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
272      *
273      * IMPORTANT: because control is transferred to `recipient`, care must be
274      * taken to not create reentrancy vulnerabilities. Consider using
275      * {ReentrancyGuard} or the
276      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
277      */
278     function sendValue(address payable recipient, uint256 amount) internal {
279         require(address(this).balance >= amount, "Address: insufficient balance");
280 
281         (bool success, ) = recipient.call{value: amount}("");
282         require(success, "Address: unable to send value, recipient may have reverted");
283     }
284 
285     /**
286      * @dev Performs a Solidity function call using a low level `call`. A
287      * plain `call` is an unsafe replacement for a function call: use this
288      * function instead.
289      *
290      * If `target` reverts with a revert reason, it is bubbled up by this
291      * function (like regular Solidity function calls).
292      *
293      * Returns the raw returned data. To convert to the expected return value,
294      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
295      *
296      * Requirements:
297      *
298      * - `target` must be a contract.
299      * - calling `target` with `data` must not revert.
300      *
301      * _Available since v3.1._
302      */
303     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
309      * `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data,
316         string memory errorMessage
317     ) internal returns (bytes memory) {
318         return functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(
333         address target,
334         bytes memory data,
335         uint256 value
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value,
350         string memory errorMessage
351     ) internal returns (bytes memory) {
352         require(address(this).balance >= value, "Address: insufficient balance for call");
353         (bool success, bytes memory returndata) = target.call{value: value}(data);
354         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but performing a static call.
360      *
361      * _Available since v3.3._
362      */
363     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
364         return functionStaticCall(target, data, "Address: low-level static call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
369      * but performing a static call.
370      *
371      * _Available since v3.3._
372      */
373     function functionStaticCall(
374         address target,
375         bytes memory data,
376         string memory errorMessage
377     ) internal view returns (bytes memory) {
378         (bool success, bytes memory returndata) = target.staticcall(data);
379         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
384      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
385      *
386      * _Available since v4.8._
387      */
388     function verifyCallResultFromTarget(
389         address target,
390         bool success,
391         bytes memory returndata,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         if (success) {
395             if (returndata.length == 0) {
396                 // only check isContract if the call was successful and the return data is empty
397                 // otherwise we already know that it was a contract
398                 require(isContract(target), "Address: call to non-contract");
399             }
400             return returndata;
401         } else {
402             _revert(returndata, errorMessage);
403         }
404     }
405 
406     /**
407      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
408      * revert reason or using the provided one.
409      *
410      * _Available since v4.3._
411      */
412     function verifyCallResult(
413         bool success,
414         bytes memory returndata,
415         string memory errorMessage
416     ) internal pure returns (bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             _revert(returndata, errorMessage);
421         }
422     }
423 
424     function _revert(bytes memory returndata, string memory errorMessage) private pure {
425         // Look for revert reason and bubble it up if present
426         if (returndata.length > 0) {
427             // The easiest way to bubble the revert reason is using memory via assembly
428             /// @solidity memory-safe-assembly
429             assembly {
430                 let returndata_size := mload(returndata)
431                 revert(add(32, returndata), returndata_size)
432             }
433         } else {
434             revert(errorMessage);
435         }
436     }
437 }
438 
439 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
440 
441 
442 /**
443  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
444  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
445  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
446  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
447  *
448  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
449  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
450  * case an upgrade adds a module that needs to be initialized.
451  *
452  * For example:
453  *
454  * [.hljs-theme-light.nopadding]
455  * ```
456  * contract MyToken is ERC20Upgradeable {
457  *     function initialize() initializer public {
458  *         __ERC20_init("MyToken", "MTK");
459  *     }
460  * }
461  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
462  *     function initializeV2() reinitializer(2) public {
463  *         __ERC20Permit_init("MyToken");
464  *     }
465  * }
466  * ```
467  *
468  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
469  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
470  *
471  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
472  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
473  *
474  * [CAUTION]
475  * ====
476  * Avoid leaving a contract uninitialized.
477  *
478  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
479  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
480  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
481  *
482  * [.hljs-theme-light.nopadding]
483  * ```
484  * /// @custom:oz-upgrades-unsafe-allow constructor
485  * constructor() {
486  *     _disableInitializers();
487  * }
488  * ```
489  * ====
490  */
491 abstract contract Initializable {
492     /**
493      * @dev Indicates that the contract has been initialized.
494      * @custom:oz-retyped-from bool
495      */
496     uint8 private _initialized;
497 
498     /**
499      * @dev Indicates that the contract is in the process of being initialized.
500      */
501     bool private _initializing;
502 
503     /**
504      * @dev Triggered when the contract has been initialized or reinitialized.
505      */
506     event Initialized(uint8 version);
507 
508     /**
509      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
510      * `onlyInitializing` functions can be used to initialize parent contracts.
511      *
512      * Similar to `reinitializer(1)`, except that functions marked with `initializer` can be nested in the context of a
513      * constructor.
514      *
515      * Emits an {Initialized} event.
516      */
517     modifier initializer() {
518         bool isTopLevelCall = !_initializing;
519         require(
520             (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
521             "Initializable: contract is already initialized"
522         );
523         _initialized = 1;
524         if (isTopLevelCall) {
525             _initializing = true;
526         }
527         _;
528         if (isTopLevelCall) {
529             _initializing = false;
530             emit Initialized(1);
531         }
532     }
533 
534     /**
535      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
536      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
537      * used to initialize parent contracts.
538      *
539      * A reinitializer may be used after the original initialization step. This is essential to configure modules that
540      * are added through upgrades and that require initialization.
541      *
542      * When `version` is 1, this modifier is similar to `initializer`, except that functions marked with `reinitializer`
543      * cannot be nested. If one is invoked in the context of another, execution will revert.
544      *
545      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
546      * a contract, executing them in the right order is up to the developer or operator.
547      *
548      * WARNING: setting the version to 255 will prevent any future reinitialization.
549      *
550      * Emits an {Initialized} event.
551      */
552     modifier reinitializer(uint8 version) {
553         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
554         _initialized = version;
555         _initializing = true;
556         _;
557         _initializing = false;
558         emit Initialized(version);
559     }
560 
561     /**
562      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
563      * {initializer} and {reinitializer} modifiers, directly or indirectly.
564      */
565     modifier onlyInitializing() {
566         require(_initializing, "Initializable: contract is not initializing");
567         _;
568     }
569 
570     /**
571      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
572      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
573      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
574      * through proxies.
575      *
576      * Emits an {Initialized} event the first time it is successfully executed.
577      */
578     function _disableInitializers() internal virtual {
579         require(!_initializing, "Initializable: contract is initializing");
580         if (_initialized < type(uint8).max) {
581             _initialized = type(uint8).max;
582             emit Initialized(type(uint8).max);
583         }
584     }
585 
586     /**
587      * @dev Returns the highest version that has been initialized. See {reinitializer}.
588      */
589     function _getInitializedVersion() internal view returns (uint8) {
590         return _initialized;
591     }
592 
593     /**
594      * @dev Returns `true` if the contract is currently initializing. See {onlyInitializing}.
595      */
596     function _isInitializing() internal view returns (bool) {
597         return _initializing;
598     }
599 }
600 
601 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
602 
603 
604 /**
605  * @dev Provides information about the current execution context, including the
606  * sender of the transaction and its data. While these are generally available
607  * via msg.sender and msg.data, they should not be accessed in such a direct
608  * manner, since when dealing with meta-transactions the account sending and
609  * paying for execution may not be the actual sender (as far as an application
610  * is concerned).
611  *
612  * This contract is only required for intermediate, library-like contracts.
613  */
614 abstract contract ContextUpgradeable is Initializable {
615     function __Context_init() internal onlyInitializing {
616     }
617 
618     function __Context_init_unchained() internal onlyInitializing {
619     }
620     function _msgSender() internal view virtual returns (address) {
621         return msg.sender;
622     }
623 
624     function _msgData() internal view virtual returns (bytes calldata) {
625         return msg.data;
626     }
627 
628     /**
629      * @dev This empty reserved space is put in place to allow future versions to add new
630      * variables without shifting down storage in the inheritance chain.
631      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
632      */
633     uint256[50] private __gap;
634 }
635 
636 // File: @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol
637 
638 
639 /**
640  * @dev Standard math utilities missing in the Solidity language.
641  */
642 library MathUpgradeable {
643     enum Rounding {
644         Down, // Toward negative infinity
645         Up, // Toward infinity
646         Zero // Toward zero
647     }
648 
649     /**
650      * @dev Returns the largest of two numbers.
651      */
652     function max(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a > b ? a : b;
654     }
655 
656     /**
657      * @dev Returns the smallest of two numbers.
658      */
659     function min(uint256 a, uint256 b) internal pure returns (uint256) {
660         return a < b ? a : b;
661     }
662 
663     /**
664      * @dev Returns the average of two numbers. The result is rounded towards
665      * zero.
666      */
667     function average(uint256 a, uint256 b) internal pure returns (uint256) {
668         // (a + b) / 2 can overflow.
669         return (a & b) + (a ^ b) / 2;
670     }
671 
672     /**
673      * @dev Returns the ceiling of the division of two numbers.
674      *
675      * This differs from standard division with `/` in that it rounds up instead
676      * of rounding down.
677      */
678     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
679         // (a + b - 1) / b can overflow on addition, so we distribute.
680         return a == 0 ? 0 : (a - 1) / b + 1;
681     }
682 
683     /**
684      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
685      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
686      * with further edits by Uniswap Labs also under MIT license.
687      */
688     function mulDiv(
689         uint256 x,
690         uint256 y,
691         uint256 denominator
692     ) internal pure returns (uint256 result) {
693         unchecked {
694             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
695             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
696             // variables such that product = prod1 * 2^256 + prod0.
697             uint256 prod0; // Least significant 256 bits of the product
698             uint256 prod1; // Most significant 256 bits of the product
699             assembly {
700                 let mm := mulmod(x, y, not(0))
701                 prod0 := mul(x, y)
702                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
703             }
704 
705             // Handle non-overflow cases, 256 by 256 division.
706             if (prod1 == 0) {
707                 return prod0 / denominator;
708             }
709 
710             // Make sure the result is less than 2^256. Also prevents denominator == 0.
711             require(denominator > prod1);
712 
713             ///////////////////////////////////////////////
714             // 512 by 256 division.
715             ///////////////////////////////////////////////
716 
717             // Make division exact by subtracting the remainder from [prod1 prod0].
718             uint256 remainder;
719             assembly {
720                 // Compute remainder using mulmod.
721                 remainder := mulmod(x, y, denominator)
722 
723                 // Subtract 256 bit number from 512 bit number.
724                 prod1 := sub(prod1, gt(remainder, prod0))
725                 prod0 := sub(prod0, remainder)
726             }
727 
728             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
729             // See https://cs.stackexchange.com/q/138556/92363.
730 
731             // Does not overflow because the denominator cannot be zero at this stage in the function.
732             uint256 twos = denominator & (~denominator + 1);
733             assembly {
734                 // Divide denominator by twos.
735                 denominator := div(denominator, twos)
736 
737                 // Divide [prod1 prod0] by twos.
738                 prod0 := div(prod0, twos)
739 
740                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
741                 twos := add(div(sub(0, twos), twos), 1)
742             }
743 
744             // Shift in bits from prod1 into prod0.
745             prod0 |= prod1 * twos;
746 
747             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
748             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
749             // four bits. That is, denominator * inv = 1 mod 2^4.
750             uint256 inverse = (3 * denominator) ^ 2;
751 
752             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
753             // in modular arithmetic, doubling the correct bits in each step.
754             inverse *= 2 - denominator * inverse; // inverse mod 2^8
755             inverse *= 2 - denominator * inverse; // inverse mod 2^16
756             inverse *= 2 - denominator * inverse; // inverse mod 2^32
757             inverse *= 2 - denominator * inverse; // inverse mod 2^64
758             inverse *= 2 - denominator * inverse; // inverse mod 2^128
759             inverse *= 2 - denominator * inverse; // inverse mod 2^256
760 
761             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
762             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
763             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
764             // is no longer required.
765             result = prod0 * inverse;
766             return result;
767         }
768     }
769 
770     /**
771      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
772      */
773     function mulDiv(
774         uint256 x,
775         uint256 y,
776         uint256 denominator,
777         Rounding rounding
778     ) internal pure returns (uint256) {
779         uint256 result = mulDiv(x, y, denominator);
780         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
781             result += 1;
782         }
783         return result;
784     }
785 
786     /**
787      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
788      *
789      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
790      */
791     function sqrt(uint256 a) internal pure returns (uint256) {
792         if (a == 0) {
793             return 0;
794         }
795 
796         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
797         //
798         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
799         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
800         //
801         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
802         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
803         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
804         //
805         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
806         uint256 result = 1 << (log2(a) >> 1);
807 
808         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
809         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
810         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
811         // into the expected uint128 result.
812         unchecked {
813             result = (result + a / result) >> 1;
814             result = (result + a / result) >> 1;
815             result = (result + a / result) >> 1;
816             result = (result + a / result) >> 1;
817             result = (result + a / result) >> 1;
818             result = (result + a / result) >> 1;
819             result = (result + a / result) >> 1;
820             return min(result, a / result);
821         }
822     }
823 
824     /**
825      * @notice Calculates sqrt(a), following the selected rounding direction.
826      */
827     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
828         unchecked {
829             uint256 result = sqrt(a);
830             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
831         }
832     }
833 
834     /**
835      * @dev Return the log in base 2, rounded down, of a positive value.
836      * Returns 0 if given 0.
837      */
838     function log2(uint256 value) internal pure returns (uint256) {
839         uint256 result = 0;
840         unchecked {
841             if (value >> 128 > 0) {
842                 value >>= 128;
843                 result += 128;
844             }
845             if (value >> 64 > 0) {
846                 value >>= 64;
847                 result += 64;
848             }
849             if (value >> 32 > 0) {
850                 value >>= 32;
851                 result += 32;
852             }
853             if (value >> 16 > 0) {
854                 value >>= 16;
855                 result += 16;
856             }
857             if (value >> 8 > 0) {
858                 value >>= 8;
859                 result += 8;
860             }
861             if (value >> 4 > 0) {
862                 value >>= 4;
863                 result += 4;
864             }
865             if (value >> 2 > 0) {
866                 value >>= 2;
867                 result += 2;
868             }
869             if (value >> 1 > 0) {
870                 result += 1;
871             }
872         }
873         return result;
874     }
875 
876     /**
877      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
878      * Returns 0 if given 0.
879      */
880     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
881         unchecked {
882             uint256 result = log2(value);
883             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
884         }
885     }
886 
887     /**
888      * @dev Return the log in base 10, rounded down, of a positive value.
889      * Returns 0 if given 0.
890      */
891     function log10(uint256 value) internal pure returns (uint256) {
892         uint256 result = 0;
893         unchecked {
894             if (value >= 10**64) {
895                 value /= 10**64;
896                 result += 64;
897             }
898             if (value >= 10**32) {
899                 value /= 10**32;
900                 result += 32;
901             }
902             if (value >= 10**16) {
903                 value /= 10**16;
904                 result += 16;
905             }
906             if (value >= 10**8) {
907                 value /= 10**8;
908                 result += 8;
909             }
910             if (value >= 10**4) {
911                 value /= 10**4;
912                 result += 4;
913             }
914             if (value >= 10**2) {
915                 value /= 10**2;
916                 result += 2;
917             }
918             if (value >= 10**1) {
919                 result += 1;
920             }
921         }
922         return result;
923     }
924 
925     /**
926      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
927      * Returns 0 if given 0.
928      */
929     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
930         unchecked {
931             uint256 result = log10(value);
932             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
933         }
934     }
935 
936     /**
937      * @dev Return the log in base 256, rounded down, of a positive value.
938      * Returns 0 if given 0.
939      *
940      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
941      */
942     function log256(uint256 value) internal pure returns (uint256) {
943         uint256 result = 0;
944         unchecked {
945             if (value >> 128 > 0) {
946                 value >>= 128;
947                 result += 16;
948             }
949             if (value >> 64 > 0) {
950                 value >>= 64;
951                 result += 8;
952             }
953             if (value >> 32 > 0) {
954                 value >>= 32;
955                 result += 4;
956             }
957             if (value >> 16 > 0) {
958                 value >>= 16;
959                 result += 2;
960             }
961             if (value >> 8 > 0) {
962                 result += 1;
963             }
964         }
965         return result;
966     }
967 
968     /**
969      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
970      * Returns 0 if given 0.
971      */
972     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
973         unchecked {
974             uint256 result = log256(value);
975             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
976         }
977     }
978 }
979 
980 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
981 
982 
983 /**
984  * @dev String operations.
985  */
986 library StringsUpgradeable {
987     bytes16 private constant _SYMBOLS = "0123456789abcdef";
988     uint8 private constant _ADDRESS_LENGTH = 20;
989 
990     /**
991      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
992      */
993     function toString(uint256 value) internal pure returns (string memory) {
994         unchecked {
995             uint256 length = MathUpgradeable.log10(value) + 1;
996             string memory buffer = new string(length);
997             uint256 ptr;
998             /// @solidity memory-safe-assembly
999             assembly {
1000                 ptr := add(buffer, add(32, length))
1001             }
1002             while (true) {
1003                 ptr--;
1004                 /// @solidity memory-safe-assembly
1005                 assembly {
1006                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1007                 }
1008                 value /= 10;
1009                 if (value == 0) break;
1010             }
1011             return buffer;
1012         }
1013     }
1014 
1015     /**
1016      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1017      */
1018     function toHexString(uint256 value) internal pure returns (string memory) {
1019         unchecked {
1020             return toHexString(value, MathUpgradeable.log256(value) + 1);
1021         }
1022     }
1023 
1024     /**
1025      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1026      */
1027     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1028         bytes memory buffer = new bytes(2 * length + 2);
1029         buffer[0] = "0";
1030         buffer[1] = "x";
1031         for (uint256 i = 2 * length + 1; i > 1; --i) {
1032             buffer[i] = _SYMBOLS[value & 0xf];
1033             value >>= 4;
1034         }
1035         require(value == 0, "Strings: hex length insufficient");
1036         return string(buffer);
1037     }
1038 
1039     /**
1040      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1041      */
1042     function toHexString(address addr) internal pure returns (string memory) {
1043         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1044     }
1045 }
1046 
1047 // File: @openzeppelin/contracts-upgradeable/utils/introspection/ERC165Upgradeable.sol
1048 
1049 
1050 
1051 /**
1052  * @dev Implementation of the {IERC165} interface.
1053  *
1054  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1055  * for the additional interface id that will be supported. For example:
1056  *
1057  * ```solidity
1058  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1059  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1060  * }
1061  * ```
1062  *
1063  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1064  */
1065 abstract contract ERC165Upgradeable is Initializable, IERC165Upgradeable {
1066     function __ERC165_init() internal onlyInitializing {
1067     }
1068 
1069     function __ERC165_init_unchained() internal onlyInitializing {
1070     }
1071     /**
1072      * @dev See {IERC165-supportsInterface}.
1073      */
1074     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1075         return interfaceId == type(IERC165Upgradeable).interfaceId;
1076     }
1077 
1078     /**
1079      * @dev This empty reserved space is put in place to allow future versions to add new
1080      * variables without shifting down storage in the inheritance chain.
1081      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1082      */
1083     uint256[50] private __gap;
1084 }
1085 
1086 // File: @openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol
1087 
1088 
1089 
1090 
1091 
1092 
1093 
1094 
1095 
1096 /**
1097  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1098  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1099  * {ERC721Enumerable}.
1100  */
1101 contract ERC721Upgradeable is Initializable, ContextUpgradeable, ERC165Upgradeable, IERC721Upgradeable, IERC721MetadataUpgradeable {
1102     using AddressUpgradeable for address;
1103     using StringsUpgradeable for uint256;
1104 
1105     // Token name
1106     string private _name;
1107 
1108     // Token symbol
1109     string private _symbol;
1110 
1111     // Mapping from token ID to owner address
1112     mapping(uint256 => address) private _owners;
1113 
1114     // Mapping owner address to token count
1115     mapping(address => uint256) private _balances;
1116 
1117     // Mapping from token ID to approved address
1118     mapping(uint256 => address) private _tokenApprovals;
1119 
1120     // Mapping from owner to operator approvals
1121     mapping(address => mapping(address => bool)) private _operatorApprovals;
1122 
1123     /**
1124      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1125      */
1126     function __ERC721_init(string memory name_, string memory symbol_) internal onlyInitializing {
1127         __ERC721_init_unchained(name_, symbol_);
1128     }
1129 
1130     function __ERC721_init_unchained(string memory name_, string memory symbol_) internal onlyInitializing {
1131         _name = name_;
1132         _symbol = symbol_;
1133     }
1134 
1135     /**
1136      * @dev See {IERC165-supportsInterface}.
1137      */
1138     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165Upgradeable, IERC165Upgradeable) returns (bool) {
1139         return
1140             interfaceId == type(IERC721Upgradeable).interfaceId ||
1141             interfaceId == type(IERC721MetadataUpgradeable).interfaceId ||
1142             super.supportsInterface(interfaceId);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-balanceOf}.
1147      */
1148     function balanceOf(address owner) public view virtual override returns (uint256) {
1149         require(owner != address(0), "ERC721: address zero is not a valid owner");
1150         return _balances[owner];
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-ownerOf}.
1155      */
1156     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1157         address owner = _ownerOf(tokenId);
1158         require(owner != address(0), "ERC721: invalid token ID");
1159         return owner;
1160     }
1161 
1162     /**
1163      * @dev See {IERC721Metadata-name}.
1164      */
1165     function name() public view virtual override returns (string memory) {
1166         return _name;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-symbol}.
1171      */
1172     function symbol() public view virtual override returns (string memory) {
1173         return _symbol;
1174     }
1175 
1176     /**
1177      * @dev See {IERC721Metadata-tokenURI}.
1178      */
1179     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1180         _requireMinted(tokenId);
1181 
1182         string memory baseURI = _baseURI();
1183         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1184     }
1185 
1186     /**
1187      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1188      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1189      * by default, can be overridden in child contracts.
1190      */
1191     function _baseURI() internal view virtual returns (string memory) {
1192         return "";
1193     }
1194 
1195     /**
1196      * @dev See {IERC721-approve}.
1197      */
1198     function approve(address to, uint256 tokenId) public virtual override {
1199         address owner = ERC721Upgradeable.ownerOf(tokenId);
1200         require(to != owner, "ERC721: approval to current owner");
1201 
1202         require(
1203             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1204             "ERC721: approve caller is not token owner or approved for all"
1205         );
1206 
1207         _approve(to, tokenId);
1208     }
1209 
1210     /**
1211      * @dev See {IERC721-getApproved}.
1212      */
1213     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1214         _requireMinted(tokenId);
1215 
1216         return _tokenApprovals[tokenId];
1217     }
1218 
1219     /**
1220      * @dev See {IERC721-setApprovalForAll}.
1221      */
1222     function setApprovalForAll(address operator, bool approved) public virtual override {
1223         _setApprovalForAll(_msgSender(), operator, approved);
1224     }
1225 
1226     /**
1227      * @dev See {IERC721-isApprovedForAll}.
1228      */
1229     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1230         return _operatorApprovals[owner][operator];
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-transferFrom}.
1235      */
1236     function transferFrom(
1237         address from,
1238         address to,
1239         uint256 tokenId
1240     ) public virtual override {
1241         //solhint-disable-next-line max-line-length
1242         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1243 
1244         _transfer(from, to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev See {IERC721-safeTransferFrom}.
1249      */
1250     function safeTransferFrom(
1251         address from,
1252         address to,
1253         uint256 tokenId
1254     ) public virtual override {
1255         safeTransferFrom(from, to, tokenId, "");
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-safeTransferFrom}.
1260      */
1261     function safeTransferFrom(
1262         address from,
1263         address to,
1264         uint256 tokenId,
1265         bytes memory data
1266     ) public virtual override {
1267         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1268         _safeTransfer(from, to, tokenId, data);
1269     }
1270 
1271     /**
1272      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1273      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1274      *
1275      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1276      *
1277      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1278      * implement alternative mechanisms to perform token transfer, such as signature-based.
1279      *
1280      * Requirements:
1281      *
1282      * - `from` cannot be the zero address.
1283      * - `to` cannot be the zero address.
1284      * - `tokenId` token must exist and be owned by `from`.
1285      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1286      *
1287      * Emits a {Transfer} event.
1288      */
1289     function _safeTransfer(
1290         address from,
1291         address to,
1292         uint256 tokenId,
1293         bytes memory data
1294     ) internal virtual {
1295         _transfer(from, to, tokenId);
1296         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1297     }
1298 
1299     /**
1300      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1301      */
1302     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1303         return _owners[tokenId];
1304     }
1305 
1306     /**
1307      * @dev Returns whether `tokenId` exists.
1308      *
1309      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1310      *
1311      * Tokens start existing when they are minted (`_mint`),
1312      * and stop existing when they are burned (`_burn`).
1313      */
1314     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1315         return _ownerOf(tokenId) != address(0);
1316     }
1317 
1318     /**
1319      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1320      *
1321      * Requirements:
1322      *
1323      * - `tokenId` must exist.
1324      */
1325     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1326         address owner = ERC721Upgradeable.ownerOf(tokenId);
1327         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1328     }
1329 
1330     /**
1331      * @dev Safely mints `tokenId` and transfers it to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - `tokenId` must not exist.
1336      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _safeMint(address to, uint256 tokenId) internal virtual {
1341         _safeMint(to, tokenId, "");
1342     }
1343 
1344     /**
1345      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1346      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1347      */
1348     function _safeMint(
1349         address to,
1350         uint256 tokenId,
1351         bytes memory data
1352     ) internal virtual {
1353         _mint(to, tokenId);
1354         require(
1355             _checkOnERC721Received(address(0), to, tokenId, data),
1356             "ERC721: transfer to non ERC721Receiver implementer"
1357         );
1358     }
1359 
1360     /**
1361      * @dev Mints `tokenId` and transfers it to `to`.
1362      *
1363      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1364      *
1365      * Requirements:
1366      *
1367      * - `tokenId` must not exist.
1368      * - `to` cannot be the zero address.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _mint(address to, uint256 tokenId) internal virtual {
1373         require(to != address(0), "ERC721: mint to the zero address");
1374         require(!_exists(tokenId), "ERC721: token already minted");
1375 
1376         _beforeTokenTransfer(address(0), to, tokenId, 1);
1377 
1378         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1379         require(!_exists(tokenId), "ERC721: token already minted");
1380 
1381         unchecked {
1382             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1383             // Given that tokens are minted one by one, it is impossible in practice that
1384             // this ever happens. Might change if we allow batch minting.
1385             // The ERC fails to describe this case.
1386             _balances[to] += 1;
1387         }
1388 
1389         _owners[tokenId] = to;
1390 
1391         emit Transfer(address(0), to, tokenId);
1392 
1393         _afterTokenTransfer(address(0), to, tokenId, 1);
1394     }
1395 
1396     /**
1397      * @dev Destroys `tokenId`.
1398      * The approval is cleared when the token is burned.
1399      * This is an internal function that does not check if the sender is authorized to operate on the token.
1400      *
1401      * Requirements:
1402      *
1403      * - `tokenId` must exist.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _burn(uint256 tokenId) internal virtual {
1408         address owner = ERC721Upgradeable.ownerOf(tokenId);
1409 
1410         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1411 
1412         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1413         owner = ERC721Upgradeable.ownerOf(tokenId);
1414 
1415         // Clear approvals
1416         delete _tokenApprovals[tokenId];
1417 
1418         unchecked {
1419             // Cannot overflow, as that would require more tokens to be burned/transferred
1420             // out than the owner initially received through minting and transferring in.
1421             _balances[owner] -= 1;
1422         }
1423         delete _owners[tokenId];
1424 
1425         emit Transfer(owner, address(0), tokenId);
1426 
1427         _afterTokenTransfer(owner, address(0), tokenId, 1);
1428     }
1429 
1430     /**
1431      * @dev Transfers `tokenId` from `from` to `to`.
1432      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1433      *
1434      * Requirements:
1435      *
1436      * - `to` cannot be the zero address.
1437      * - `tokenId` token must be owned by `from`.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function _transfer(
1442         address from,
1443         address to,
1444         uint256 tokenId
1445     ) internal virtual {
1446         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1447         require(to != address(0), "ERC721: transfer to the zero address");
1448 
1449         _beforeTokenTransfer(from, to, tokenId, 1);
1450 
1451         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1452         require(ERC721Upgradeable.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1453 
1454         // Clear approvals from the previous owner
1455         delete _tokenApprovals[tokenId];
1456 
1457         unchecked {
1458             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1459             // `from`'s balance is the number of token held, which is at least one before the current
1460             // transfer.
1461             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1462             // all 2**256 token ids to be minted, which in practice is impossible.
1463             _balances[from] -= 1;
1464             _balances[to] += 1;
1465         }
1466         _owners[tokenId] = to;
1467 
1468         emit Transfer(from, to, tokenId);
1469 
1470         _afterTokenTransfer(from, to, tokenId, 1);
1471     }
1472 
1473     /**
1474      * @dev Approve `to` to operate on `tokenId`
1475      *
1476      * Emits an {Approval} event.
1477      */
1478     function _approve(address to, uint256 tokenId) internal virtual {
1479         _tokenApprovals[tokenId] = to;
1480         emit Approval(ERC721Upgradeable.ownerOf(tokenId), to, tokenId);
1481     }
1482 
1483     /**
1484      * @dev Approve `operator` to operate on all of `owner` tokens
1485      *
1486      * Emits an {ApprovalForAll} event.
1487      */
1488     function _setApprovalForAll(
1489         address owner,
1490         address operator,
1491         bool approved
1492     ) internal virtual {
1493         require(owner != operator, "ERC721: approve to caller");
1494         _operatorApprovals[owner][operator] = approved;
1495         emit ApprovalForAll(owner, operator, approved);
1496     }
1497 
1498     /**
1499      * @dev Reverts if the `tokenId` has not been minted yet.
1500      */
1501     function _requireMinted(uint256 tokenId) internal view virtual {
1502         require(_exists(tokenId), "ERC721: invalid token ID");
1503     }
1504 
1505     /**
1506      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1507      * The call is not executed if the target address is not a contract.
1508      *
1509      * @param from address representing the previous owner of the given token ID
1510      * @param to target address that will receive the tokens
1511      * @param tokenId uint256 ID of the token to be transferred
1512      * @param data bytes optional data to send along with the call
1513      * @return bool whether the call correctly returned the expected magic value
1514      */
1515     function _checkOnERC721Received(
1516         address from,
1517         address to,
1518         uint256 tokenId,
1519         bytes memory data
1520     ) private returns (bool) {
1521         if (to.isContract()) {
1522             try IERC721ReceiverUpgradeable(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1523                 return retval == IERC721ReceiverUpgradeable.onERC721Received.selector;
1524             } catch (bytes memory reason) {
1525                 if (reason.length == 0) {
1526                     revert("ERC721: transfer to non ERC721Receiver implementer");
1527                 } else {
1528                     /// @solidity memory-safe-assembly
1529                     assembly {
1530                         revert(add(32, reason), mload(reason))
1531                     }
1532                 }
1533             }
1534         } else {
1535             return true;
1536         }
1537     }
1538 
1539     /**
1540      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1541      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1542      *
1543      * Calling conditions:
1544      *
1545      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1546      * - When `from` is zero, the tokens will be minted for `to`.
1547      * - When `to` is zero, ``from``'s tokens will be burned.
1548      * - `from` and `to` are never both zero.
1549      * - `batchSize` is non-zero.
1550      *
1551      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1552      */
1553     function _beforeTokenTransfer(
1554         address from,
1555         address to,
1556         uint256, /* firstTokenId */
1557         uint256 batchSize
1558     ) internal virtual {
1559         if (batchSize > 1) {
1560             if (from != address(0)) {
1561                 _balances[from] -= batchSize;
1562             }
1563             if (to != address(0)) {
1564                 _balances[to] += batchSize;
1565             }
1566         }
1567     }
1568 
1569     /**
1570      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1571      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1572      *
1573      * Calling conditions:
1574      *
1575      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1576      * - When `from` is zero, the tokens were minted for `to`.
1577      * - When `to` is zero, ``from``'s tokens were burned.
1578      * - `from` and `to` are never both zero.
1579      * - `batchSize` is non-zero.
1580      *
1581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1582      */
1583     function _afterTokenTransfer(
1584         address from,
1585         address to,
1586         uint256 firstTokenId,
1587         uint256 batchSize
1588     ) internal virtual {}
1589 
1590     /**
1591      * @dev This empty reserved space is put in place to allow future versions to add new
1592      * variables without shifting down storage in the inheritance chain.
1593      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1594      */
1595     uint256[44] private __gap;
1596 }
1597 
1598 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721URIStorageUpgradeable.sol
1599 
1600 
1601 
1602 /**
1603  * @dev ERC721 token with storage based token URI management.
1604  */
1605 abstract contract ERC721URIStorageUpgradeable is Initializable, ERC721Upgradeable {
1606     function __ERC721URIStorage_init() internal onlyInitializing {
1607     }
1608 
1609     function __ERC721URIStorage_init_unchained() internal onlyInitializing {
1610     }
1611     using StringsUpgradeable for uint256;
1612 
1613     // Optional mapping for token URIs
1614     mapping(uint256 => string) private _tokenURIs;
1615 
1616     /**
1617      * @dev See {IERC721Metadata-tokenURI}.
1618      */
1619     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1620         _requireMinted(tokenId);
1621 
1622         string memory _tokenURI = _tokenURIs[tokenId];
1623         string memory base = _baseURI();
1624 
1625         // If there is no base URI, return the token URI.
1626         if (bytes(base).length == 0) {
1627             return _tokenURI;
1628         }
1629         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1630         if (bytes(_tokenURI).length > 0) {
1631             return string(abi.encodePacked(base, _tokenURI));
1632         }
1633 
1634         return super.tokenURI(tokenId);
1635     }
1636 
1637     /**
1638      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1639      *
1640      * Requirements:
1641      *
1642      * - `tokenId` must exist.
1643      */
1644     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1645         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1646         _tokenURIs[tokenId] = _tokenURI;
1647     }
1648 
1649     /**
1650      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1651      * token-specific URI was set for the token, and if so, it deletes the token URI from
1652      * the storage mapping.
1653      */
1654     function _burn(uint256 tokenId) internal virtual override {
1655         super._burn(tokenId);
1656 
1657         if (bytes(_tokenURIs[tokenId]).length != 0) {
1658             delete _tokenURIs[tokenId];
1659         }
1660     }
1661 
1662     /**
1663      * @dev This empty reserved space is put in place to allow future versions to add new
1664      * variables without shifting down storage in the inheritance chain.
1665      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1666      */
1667     uint256[49] private __gap;
1668 }
1669 
1670 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/IERC721EnumerableUpgradeable.sol
1671 
1672 
1673 /**
1674  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1675  * @dev See https://eips.ethereum.org/EIPS/eip-721
1676  */
1677 interface IERC721EnumerableUpgradeable is IERC721Upgradeable {
1678     /**
1679      * @dev Returns the total amount of tokens stored by the contract.
1680      */
1681     function totalSupply() external view returns (uint256);
1682 
1683     /**
1684      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1685      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1686      */
1687     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1688 
1689     /**
1690      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1691      * Use along with {totalSupply} to enumerate all tokens.
1692      */
1693     function tokenByIndex(uint256 index) external view returns (uint256);
1694 }
1695 
1696 // File: @openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol
1697 
1698 
1699 
1700 
1701 /**
1702  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1703  * enumerability of all the token ids in the contract as well as all token ids owned by each
1704  * account.
1705  */
1706 abstract contract ERC721EnumerableUpgradeable is Initializable, ERC721Upgradeable, IERC721EnumerableUpgradeable {
1707     function __ERC721Enumerable_init() internal onlyInitializing {
1708     }
1709 
1710     function __ERC721Enumerable_init_unchained() internal onlyInitializing {
1711     }
1712     // Mapping from owner to list of owned token IDs
1713     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1714 
1715     // Mapping from token ID to index of the owner tokens list
1716     mapping(uint256 => uint256) private _ownedTokensIndex;
1717 
1718     // Array with all token ids, used for enumeration
1719     uint256[] private _allTokens;
1720 
1721     // Mapping from token id to position in the allTokens array
1722     mapping(uint256 => uint256) private _allTokensIndex;
1723 
1724     /**
1725      * @dev See {IERC165-supportsInterface}.
1726      */
1727     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165Upgradeable, ERC721Upgradeable) returns (bool) {
1728         return interfaceId == type(IERC721EnumerableUpgradeable).interfaceId || super.supportsInterface(interfaceId);
1729     }
1730 
1731     /**
1732      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1733      */
1734     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1735         require(index < ERC721Upgradeable.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1736         return _ownedTokens[owner][index];
1737     }
1738 
1739     /**
1740      * @dev See {IERC721Enumerable-totalSupply}.
1741      */
1742     function totalSupply() public view virtual override returns (uint256) {
1743         return _allTokens.length;
1744     }
1745 
1746     /**
1747      * @dev See {IERC721Enumerable-tokenByIndex}.
1748      */
1749     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1750         require(index < ERC721EnumerableUpgradeable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1751         return _allTokens[index];
1752     }
1753 
1754     /**
1755      * @dev See {ERC721-_beforeTokenTransfer}.
1756      */
1757     function _beforeTokenTransfer(
1758         address from,
1759         address to,
1760         uint256 firstTokenId,
1761         uint256 batchSize
1762     ) internal virtual override {
1763         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1764 
1765         if (batchSize > 1) {
1766             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1767             revert("ERC721Enumerable: consecutive transfers not supported");
1768         }
1769 
1770         uint256 tokenId = firstTokenId;
1771 
1772         if (from == address(0)) {
1773             _addTokenToAllTokensEnumeration(tokenId);
1774         } else if (from != to) {
1775             _removeTokenFromOwnerEnumeration(from, tokenId);
1776         }
1777         if (to == address(0)) {
1778             _removeTokenFromAllTokensEnumeration(tokenId);
1779         } else if (to != from) {
1780             _addTokenToOwnerEnumeration(to, tokenId);
1781         }
1782     }
1783 
1784     /**
1785      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1786      * @param to address representing the new owner of the given token ID
1787      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1788      */
1789     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1790         uint256 length = ERC721Upgradeable.balanceOf(to);
1791         _ownedTokens[to][length] = tokenId;
1792         _ownedTokensIndex[tokenId] = length;
1793     }
1794 
1795     /**
1796      * @dev Private function to add a token to this extension's token tracking data structures.
1797      * @param tokenId uint256 ID of the token to be added to the tokens list
1798      */
1799     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1800         _allTokensIndex[tokenId] = _allTokens.length;
1801         _allTokens.push(tokenId);
1802     }
1803 
1804     /**
1805      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1806      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1807      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1808      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1809      * @param from address representing the previous owner of the given token ID
1810      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1811      */
1812     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1813         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1814         // then delete the last slot (swap and pop).
1815 
1816         uint256 lastTokenIndex = ERC721Upgradeable.balanceOf(from) - 1;
1817         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1818 
1819         // When the token to delete is the last token, the swap operation is unnecessary
1820         if (tokenIndex != lastTokenIndex) {
1821             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1822 
1823             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1824             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1825         }
1826 
1827         // This also deletes the contents at the last position of the array
1828         delete _ownedTokensIndex[tokenId];
1829         delete _ownedTokens[from][lastTokenIndex];
1830     }
1831 
1832     /**
1833      * @dev Private function to remove a token from this extension's token tracking data structures.
1834      * This has O(1) time complexity, but alters the order of the _allTokens array.
1835      * @param tokenId uint256 ID of the token to be removed from the tokens list
1836      */
1837     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1838         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1839         // then delete the last slot (swap and pop).
1840 
1841         uint256 lastTokenIndex = _allTokens.length - 1;
1842         uint256 tokenIndex = _allTokensIndex[tokenId];
1843 
1844         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1845         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1846         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1847         uint256 lastTokenId = _allTokens[lastTokenIndex];
1848 
1849         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1850         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1851 
1852         // This also deletes the contents at the last position of the array
1853         delete _allTokensIndex[tokenId];
1854         _allTokens.pop();
1855     }
1856 
1857     /**
1858      * @dev This empty reserved space is put in place to allow future versions to add new
1859      * variables without shifting down storage in the inheritance chain.
1860      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1861      */
1862     uint256[46] private __gap;
1863 }
1864 
1865 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
1866 
1867 
1868 
1869 /**
1870  * @dev Contract module which provides a basic access control mechanism, where
1871  * there is an account (an owner) that can be granted exclusive access to
1872  * specific functions.
1873  *
1874  * By default, the owner account will be the one that deploys the contract. This
1875  * can later be changed with {transferOwnership}.
1876  *
1877  * This module is used through inheritance. It will make available the modifier
1878  * `onlyOwner`, which can be applied to your functions to restrict their use to
1879  * the owner.
1880  */
1881 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
1882     address private _owner;
1883 
1884     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1885 
1886     /**
1887      * @dev Initializes the contract setting the deployer as the initial owner.
1888      */
1889     function __Ownable_init() internal onlyInitializing {
1890         __Ownable_init_unchained();
1891     }
1892 
1893     function __Ownable_init_unchained() internal onlyInitializing {
1894         _transferOwnership(_msgSender());
1895     }
1896 
1897     /**
1898      * @dev Throws if called by any account other than the owner.
1899      */
1900     modifier onlyOwner() {
1901         _checkOwner();
1902         _;
1903     }
1904 
1905     /**
1906      * @dev Returns the address of the current owner.
1907      */
1908     function owner() public view virtual returns (address) {
1909         return _owner;
1910     }
1911 
1912     /**
1913      * @dev Throws if the sender is not the owner.
1914      */
1915     function _checkOwner() internal view virtual {
1916         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1917     }
1918 
1919     /**
1920      * @dev Leaves the contract without owner. It will not be possible to call
1921      * `onlyOwner` functions anymore. Can only be called by the current owner.
1922      *
1923      * NOTE: Renouncing ownership will leave the contract without an owner,
1924      * thereby removing any functionality that is only available to the owner.
1925      */
1926     function renounceOwnership() public virtual onlyOwner {
1927         _transferOwnership(address(0));
1928     }
1929 
1930     /**
1931      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1932      * Can only be called by the current owner.
1933      */
1934     function transferOwnership(address newOwner) public virtual onlyOwner {
1935         require(newOwner != address(0), "Ownable: new owner is the zero address");
1936         _transferOwnership(newOwner);
1937     }
1938 
1939     /**
1940      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1941      * Internal function without access restriction.
1942      */
1943     function _transferOwnership(address newOwner) internal virtual {
1944         address oldOwner = _owner;
1945         _owner = newOwner;
1946         emit OwnershipTransferred(oldOwner, newOwner);
1947     }
1948 
1949     /**
1950      * @dev This empty reserved space is put in place to allow future versions to add new
1951      * variables without shifting down storage in the inheritance chain.
1952      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
1953      */
1954     uint256[49] private __gap;
1955 }
1956 
1957 // File: @openzeppelin/contracts/utils/Counters.sol
1958 
1959 
1960 /**
1961  * @title Counters
1962  * @author Matt Condon (@shrugs)
1963  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1964  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1965  *
1966  * Include with `using Counters for Counters.Counter;`
1967  */
1968 library Counters {
1969     struct Counter {
1970         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1971         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1972         // this feature: see https://github.com/ethereum/solidity/issues/4637
1973         uint256 _value; // default: 0
1974     }
1975 
1976     function current(Counter storage counter) internal view returns (uint256) {
1977         return counter._value;
1978     }
1979 
1980     function increment(Counter storage counter) internal {
1981         unchecked {
1982             counter._value += 1;
1983         }
1984     }
1985 
1986     function decrement(Counter storage counter) internal {
1987         uint256 value = counter._value;
1988         require(value > 0, "Counter: decrement overflow");
1989         unchecked {
1990             counter._value = value - 1;
1991         }
1992     }
1993 
1994     function reset(Counter storage counter) internal {
1995         counter._value = 0;
1996     }
1997 }
1998 
1999 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2000 
2001 
2002 /**
2003  * @dev Interface of the ERC20 standard as defined in the EIP.
2004  */
2005 interface IERC20 {
2006     /**
2007      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2008      * another (`to`).
2009      *
2010      * Note that `value` may be zero.
2011      */
2012     event Transfer(address indexed from, address indexed to, uint256 value);
2013 
2014     /**
2015      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2016      * a call to {approve}. `value` is the new allowance.
2017      */
2018     event Approval(address indexed owner, address indexed spender, uint256 value);
2019 
2020     /**
2021      * @dev Returns the amount of tokens in existence.
2022      */
2023     function totalSupply() external view returns (uint256);
2024 
2025     /**
2026      * @dev Returns the amount of tokens owned by `account`.
2027      */
2028     function balanceOf(address account) external view returns (uint256);
2029 
2030     /**
2031      * @dev Moves `amount` tokens from the caller's account to `to`.
2032      *
2033      * Returns a boolean value indicating whether the operation succeeded.
2034      *
2035      * Emits a {Transfer} event.
2036      */
2037     function transfer(address to, uint256 amount) external returns (bool);
2038 
2039     /**
2040      * @dev Returns the remaining number of tokens that `spender` will be
2041      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2042      * zero by default.
2043      *
2044      * This value changes when {approve} or {transferFrom} are called.
2045      */
2046     function allowance(address owner, address spender) external view returns (uint256);
2047 
2048     /**
2049      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2050      *
2051      * Returns a boolean value indicating whether the operation succeeded.
2052      *
2053      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2054      * that someone may use both the old and the new allowance by unfortunate
2055      * transaction ordering. One possible solution to mitigate this race
2056      * condition is to first reduce the spender's allowance to 0 and set the
2057      * desired value afterwards:
2058      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2059      *
2060      * Emits an {Approval} event.
2061      */
2062     function approve(address spender, uint256 amount) external returns (bool);
2063 
2064     /**
2065      * @dev Moves `amount` tokens from `from` to `to` using the
2066      * allowance mechanism. `amount` is then deducted from the caller's
2067      * allowance.
2068      *
2069      * Returns a boolean value indicating whether the operation succeeded.
2070      *
2071      * Emits a {Transfer} event.
2072      */
2073     function transferFrom(
2074         address from,
2075         address to,
2076         uint256 amount
2077     ) external returns (bool);
2078 }
2079 
2080 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
2081 
2082 
2083 interface IOperatorFilterRegistry {
2084     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
2085     function register(address registrant) external;
2086     function registerAndSubscribe(address registrant, address subscription) external;
2087     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
2088     function unregister(address addr) external;
2089     function updateOperator(address registrant, address operator, bool filtered) external;
2090     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
2091     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
2092     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
2093     function subscribe(address registrant, address registrantToSubscribe) external;
2094     function unsubscribe(address registrant, bool copyExistingEntries) external;
2095     function subscriptionOf(address addr) external returns (address registrant);
2096     function subscribers(address registrant) external returns (address[] memory);
2097     function subscriberAt(address registrant, uint256 index) external returns (address);
2098     function copyEntriesOf(address registrant, address registrantToCopy) external;
2099     function isOperatorFiltered(address registrant, address operator) external returns (bool);
2100     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
2101     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
2102     function filteredOperators(address addr) external returns (address[] memory);
2103     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
2104     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
2105     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
2106     function isRegistered(address addr) external returns (bool);
2107     function codeHashOf(address addr) external returns (bytes32);
2108 }
2109 
2110 // File: operator-filter-registry/src/OperatorFilterer.sol
2111 
2112 
2113 /**
2114  * @title  OperatorFilterer
2115  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
2116  *         registrant's entries in the OperatorFilterRegistry.
2117  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
2118  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
2119  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
2120  */
2121 abstract contract OperatorFilterer {
2122     error OperatorNotAllowed(address operator);
2123 
2124     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
2125         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
2126 
2127     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
2128         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
2129         // will not revert, but the contract will need to be registered with the registry once it is deployed in
2130         // order for the modifier to filter addresses.
2131         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2132             if (subscribe) {
2133                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
2134             } else {
2135                 if (subscriptionOrRegistrantToCopy != address(0)) {
2136                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
2137                 } else {
2138                     OPERATOR_FILTER_REGISTRY.register(address(this));
2139                 }
2140             }
2141         }
2142     }
2143 
2144     modifier onlyAllowedOperator(address from) virtual {
2145         // Allow spending tokens from addresses with balance
2146         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
2147         // from an EOA.
2148         if (from != msg.sender) {
2149             _checkFilterOperator(msg.sender);
2150         }
2151         _;
2152     }
2153 
2154     modifier onlyAllowedOperatorApproval(address operator) virtual {
2155         _checkFilterOperator(operator);
2156         _;
2157     }
2158 
2159     function _checkFilterOperator(address operator) internal view virtual {
2160         // Check registry code length to facilitate testing in environments without a deployed registry.
2161         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
2162             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
2163                 revert OperatorNotAllowed(operator);
2164             }
2165         }
2166     }
2167 }
2168 
2169 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
2170 
2171 
2172 /**
2173  * @title  DefaultOperatorFilterer
2174  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2175  */
2176 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2177     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
2178 
2179     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
2180 }
2181 
2182 // File: contracts/LW1-Comic.sol
2183 
2184 
2185 
2186 
2187 
2188 
2189 
2190 
2191 interface IERC721 {
2192     function balanceOf(address _owner) external view returns (uint256);
2193     function ownerOf(uint256 _tokenId) external returns (address);
2194 }
2195 
2196 contract LW1Comic is 
2197     DefaultOperatorFilterer,
2198     Initializable,
2199     OwnableUpgradeable,
2200     ERC721Upgradeable,
2201     ERC721URIStorageUpgradeable,
2202     ERC721EnumerableUpgradeable
2203 {
2204     using Counters for Counters.Counter;
2205     Counters.Counter private _tokenIdCounter;   
2206     struct TokenTiers {
2207         string name;
2208         uint256 tier;
2209         string uriPackaged;
2210         uint256 possibilityCount;
2211         uint256 forgePercent;
2212     }
2213     mapping(address => uint256) private allowList;
2214     mapping(address => uint256) private discountList;
2215     mapping(address => uint256) private mintCount;
2216     uint256 private mintPrice;
2217     uint256 private portalPrice;
2218     uint256 private discountPrice;
2219     uint256 private maxSupply;
2220     uint256 private maxPerAddress;
2221     uint256 private _baseCount;
2222     uint256 private randomSeed;
2223     string public contractURI;
2224     bool private openSale = false;
2225     address private royaltyAddress;
2226     address private sourceContract;
2227     mapping (uint256 => uint256) private tokenRandomKey;
2228     mapping (uint256 => string) private unpackagedUris;
2229     mapping (uint256 => bool) private canUnpack;
2230     mapping (uint256 => bool) private unpackaged;
2231     address[] private tokenOwners;
2232     TokenTiers[] private tokenTiers;
2233     mapping (uint256 => TokenTiers) private tokenTiersMinted;
2234     string private errNotOwner = "You are not the owner of this token";
2235     string private errZeroAddress = "Zero address";
2236 
2237     event Minted(uint256 tokenId, address owner);
2238     event Forged(uint256 tokenId, address owner);
2239 
2240     constructor(
2241         string memory _name,
2242         string memory _symbol,
2243         uint256 _maxSupply,
2244         TokenTiers[] memory _tokenTiers
2245     ) {
2246         initialize(_name, _symbol);
2247         maxSupply = _maxSupply;
2248         royaltyAddress = msg.sender;
2249         randomSeed = 0;
2250         uint256 sum = 0;
2251         for (uint256 i = 0; i < _tokenTiers.length; i++) {
2252             sum += _tokenTiers[i].possibilityCount;
2253         }
2254         require(maxSupply == sum, "Max supply should be equal to the sum of possibility count");
2255         for (uint256 i = 0; i < _tokenTiers.length; i++) {
2256             tokenTiers.push(_tokenTiers[i]);
2257         }
2258     }
2259     
2260     function initialize(
2261         string memory _name,
2262         string memory _symbol
2263     ) public initializer {
2264         __Ownable_init();
2265         __ERC721_init(_name, _symbol);
2266         __ERC721URIStorage_init();
2267         __ERC721Enumerable_init();
2268     }
2269 
2270     function random(uint256 _l) public view returns (uint256) {
2271         return uint256(keccak256(abi.encodePacked(randomSeed, block.difficulty, block.timestamp, _tokenIdCounter.current() ))) % _l;
2272     }
2273 
2274     function setBaseCountAndContract(uint256 _count, address _contract, uint256 _freePrice) external onlyOwner {
2275         require(_contract != address(0), errZeroAddress);
2276         _baseCount = _count;
2277         _tokenIdCounter = Counters.Counter(_count);
2278         sourceContract = _contract;
2279         portalPrice = _freePrice;
2280         randomSeed++;
2281     }
2282 
2283     function setRoyaltyAddress(address _royaltyAddress) external onlyOwner {
2284         require(_royaltyAddress != address(0), errZeroAddress);
2285         royaltyAddress = _royaltyAddress;
2286         randomSeed++;
2287     }
2288 
2289     function getRoyaltyAddress() external view returns (address) {
2290         return royaltyAddress;
2291     }
2292 
2293     function setPrice(uint256 _mintPrice) external onlyOwner {
2294         mintPrice = _mintPrice;
2295         randomSeed++;
2296     }
2297 
2298     function setDiscountPrice(uint256 _discountPrice) external onlyOwner {
2299         discountPrice = _discountPrice;
2300         randomSeed++;
2301     }
2302 
2303     function setMaxPerAddress(uint256 _maxPerAddress) external onlyOwner {
2304         maxPerAddress = _maxPerAddress;
2305         randomSeed++;
2306     }
2307 
2308     function getPrices() external view returns (uint256, uint256, uint256) {
2309         return (mintPrice, discountPrice, portalPrice);
2310     }
2311 
2312     function setAllowList(address[] memory _addresses, uint256 _amount) external onlyOwner {
2313         for (uint256 i = 0; i < _addresses.length; i++) {
2314             if(_addresses[i] != address(0)) {
2315                 allowList[_addresses[i]] = _amount;
2316             }
2317             randomSeed++;
2318         }
2319     }
2320 
2321     function setDiscountList(address[] memory _addresses, uint256 _amount) external onlyOwner {
2322         for (uint256 i = 0; i < _addresses.length; i++) {
2323             if(_addresses[i] != address(0)) {
2324                 discountList[_addresses[i]] = _amount;
2325                 if(allowList[_addresses[i]]>0)  {
2326                     allowList[_addresses[i]] += _amount;
2327                 }   else {
2328                     allowList[_addresses[i]] = _amount;
2329                 }
2330             }
2331             randomSeed++;
2332         }
2333     }
2334 
2335     function getPrice(uint256 _tokenId) public view returns (uint256) {
2336         uint256 price = mintPrice;
2337         if(_tokenId > 0 && _baseCount > 0 && _tokenId <= _baseCount)    {
2338             price = portalPrice;
2339         }
2340         return price;
2341     }
2342 
2343     function getQty(address _address, uint256 _tokenId) public view returns (uint256) {
2344         require(_address != address(0), errZeroAddress);
2345         uint256 availableToMint = openSale? maxPerAddress: 0;
2346         if(_tokenId > 0 && _baseCount > 0 && _tokenId <= _baseCount)    {
2347             availableToMint = tokenRandomKey[_tokenId]>0? 0: 1;
2348         } else if((openSale || allowList[_address]>0) && _tokenIdCounter.current() < maxSupply) {
2349             if(allowList[_address]>0) {
2350                 availableToMint += allowList[_address];
2351             }
2352             if(mintCount[_address]>0) {
2353                 if(availableToMint >= mintCount[_address])  {
2354                     availableToMint -= mintCount[_address];
2355                 }   else    {
2356                     availableToMint = 0;
2357                 }
2358             }
2359         }
2360         return availableToMint;
2361     }
2362 
2363     function getQtyPriceAllowed(address _address, uint256 _tokenId) public view returns (uint256, uint256) {
2364         require(_address != address(0), errZeroAddress);
2365         return (getQty(_address, _tokenId), getPrice(_tokenId));
2366     }
2367 
2368     function getDiscountQty(address _address) public view returns (uint256) {
2369         require(_address != address(0), errZeroAddress);
2370         return discountList[_address];
2371     }
2372 
2373     function setSaleState(bool _openSale) external onlyOwner {
2374         openSale = _openSale;
2375         randomSeed++;
2376     }
2377 
2378     function setUnpackageState(uint256 _tokenId, string memory _unpackagedUri, bool _canUnpack) external onlyOwner {
2379         unpackagedUris[_tokenId] = _unpackagedUri;
2380         canUnpack[_tokenId] = _canUnpack;
2381         randomSeed++;
2382     }
2383 
2384     function _mintIt(address _to, uint256 _tokenId, uint256 _random) internal {
2385         require(_random > 0 || _tokenId > 0 || getQty(_to, _tokenId) > 0, "You cannot mint");
2386         bool isForge = true;
2387         uint256 sum = 0;
2388         if(_random == 0)    {
2389             for (uint256 i = 0; i < tokenTiers.length; i++) {
2390                 sum += tokenTiers[i].possibilityCount;
2391             }
2392             isForge = false;
2393             _random = random(sum);
2394         }
2395         require(isForge || sum > 0, "You can't mint");
2396         uint256 _tier = 0;
2397         if(!isForge) {
2398             for (uint256 i = 0; i < tokenTiers.length; i++) {
2399                 if (_random < tokenTiers[i].possibilityCount) {
2400                     _tier = i;
2401                     tokenTiers[i].possibilityCount -= 1;
2402                     break;
2403                 } else {
2404                     _random -= tokenTiers[i].possibilityCount;
2405                 }
2406             }
2407         }   else {
2408             _tier = _random;
2409         }
2410         if(_tokenId == 0) {
2411             _tokenIdCounter.increment();
2412             _tokenId = _tokenIdCounter.current();
2413             if(!isForge) {
2414                 if(mintCount[_to]>0)    {
2415                     mintCount[_to]++;
2416                 } else {
2417                     mintCount[_to] = 1;
2418                 }
2419             }
2420         }
2421         _safeMint(_to, _tokenId);
2422         _setTokenURI(_tokenId, tokenTiers[_tier].uriPackaged);
2423         tokenTiersMinted[_tokenId] = 
2424         (TokenTiers(
2425             tokenTiers[_tier].name, 
2426             _tier, 
2427             tokenTiers[_tier].uriPackaged,
2428             tokenTiers[_tier].possibilityCount + 1,
2429             tokenTiers[_tier].forgePercent
2430         ));
2431         tokenRandomKey[_tokenId] = (random(2**256 - 1));
2432         emit Minted(_tokenId, _to);
2433         randomSeed++;
2434     }
2435 
2436     function mintNFT(address _to, uint256 _tokenId) internal {
2437         require(_to != address(0), errZeroAddress);
2438         require(openSale || allowList[msg.sender] > 0 || _tokenId>0, "You are not on the allow list");
2439         require(_tokenIdCounter.current() <= maxSupply, "Exceeds max supply");
2440         _mintIt(_to, _tokenId, 0);
2441         randomSeed++;
2442     }
2443 
2444     function mint(uint256 _qty) external payable {
2445         address _to = msg.sender;
2446         require(_to != address(0), errZeroAddress);
2447         require(_qty > 0, "You cannot mint 0 NFTs");
2448         require(_qty <= 25, "You cannot mint more than 25 NTFs at once");
2449         //require(msg.value >= mintPrice*_qty, "You need to pay more");
2450         uint256 discountQty = ( discountList[_to]>0 )? (_qty > discountList[_to]? discountList[_to]: _qty): 0;
2451         uint256 fullQty = _qty - discountQty;
2452         require(msg.value > 0 && msg.value >= (( discountPrice > 0 ? (discountPrice * discountQty): 0) + ( mintPrice * fullQty ) ), "You need to pay more");
2453         require(getQty(_to, 0)>=_qty, "You cannot buy this amount of NFTs");
2454         for( uint256 i = 0; i < _qty; i++)  {
2455             mintNFT(_to, 0);
2456             if(discountList[_to] > 0){
2457                 discountList[_to] -= 1;
2458             }
2459         }
2460         payable(royaltyAddress).transfer(msg.value);
2461         if(allowList[_to]>0){
2462             allowList[_to] -= _qty;
2463         }
2464         randomSeed++;
2465     }
2466 
2467     function portalMint(uint256[] memory _tokenIds) external payable {
2468         require(portalPrice > 0, "Free mint is not allowed");
2469         require(msg.value >= portalPrice*_tokenIds.length, "You need to pay more");
2470         require(_tokenIds.length > 0, "You cannot mint more than 0 NTFs");
2471         require(_tokenIds.length <= 25, "You cannot mint more than 25 NTFs at once");
2472         for( uint256 i = 0; i < _tokenIds.length; i++){
2473             require(IERC721(sourceContract).ownerOf(_tokenIds[i]) == msg.sender, errNotOwner);
2474             require(tokenRandomKey[_tokenIds[i]] == 0, "Already minted");
2475             mintNFT(msg.sender, _tokenIds[i]);
2476         }
2477         payable(royaltyAddress).transfer(msg.value);
2478         randomSeed++;
2479     }
2480 
2481     function unpackage(uint256 _tokenId) external {
2482         require(ownerOf(_tokenId) == msg.sender, errNotOwner);
2483         require(canUnpack[_tokenId] == true, "Unpackage is not yet allowed");
2484         require(unpackaged[_tokenId] != true, "Already unpackaged");
2485         _setTokenURI(_tokenId, unpackagedUris[_tokenId]);
2486         unpackaged[_tokenId] = true;
2487         randomSeed++;
2488     }
2489     
2490     function burn(uint256 _tokenId) public {
2491         require(ownerOf(_tokenId) == msg.sender || owner() == msg.sender, errNotOwner);
2492         _burn(_tokenId);
2493         randomSeed++;
2494     }
2495 
2496     function forge(address _to, uint256[] memory _tokenIds) external {
2497         require(_to != address(0), errZeroAddress);
2498         require(_tokenIds.length==3, "You need 3 NFTs to Forge");
2499         maxSupply++;
2500         uint256 _tier = tokenTiersMinted[_tokenIds[0]].tier;
2501         require(_tier < tokenTiers.length-1, "You can't forge this tier");
2502         for (uint256 i = 0; i < _tokenIds.length; i++) {
2503             require(tokenTiersMinted[_tokenIds[i]].tier == _tier, "Tokens are not from the same tier");
2504             require(unpackaged[_tokenIds[i]] == true, "You need to unpackage the NFTs");
2505         }
2506         for (uint256 i = 0; i < _tokenIds.length; i++) {
2507             burn(_tokenIds[i]);
2508         }
2509         
2510         uint256 minimumAmount = 0;
2511         for(uint256 i = _tier; i < tokenTiers.length; i++)  {
2512             minimumAmount += tokenTiers[i].forgePercent;
2513         }
2514         uint256 _random = random(minimumAmount);
2515 
2516         TokenTiers[] memory holdTemp = tokenTiers;
2517 
2518         uint256 newTier = _tier + 1;
2519         for (uint256 i = tokenTiers.length-1; i > _tier; i--) {
2520             if(_random <= holdTemp[i].forgePercent) {
2521                 newTier = i;
2522                 break;
2523             } else {
2524                 _random -= holdTemp[i].forgePercent;
2525             }
2526         }
2527 
2528         _mintIt(_to, 0, newTier);
2529         emit Forged(_tokenIdCounter.current(), _to);
2530         randomSeed++;
2531     }
2532 
2533     function getTokenRandomKey(uint256 _tokenId) external view returns (uint256, string memory, bool, bool) {
2534         if((ownerOf(_tokenId) == msg.sender || owner() == msg.sender))  {
2535             return (tokenRandomKey[_tokenId], unpackagedUris[_tokenId], canUnpack[_tokenId], unpackaged[_tokenId]);
2536         }
2537         return (0, "", false, false);
2538     }
2539 
2540     function getTokenTier(uint256 _tokenId) external view returns (string memory) {
2541         return owner() == msg.sender? tokenTiersMinted[_tokenId].name: "";
2542     }
2543 
2544     function _beforeTokenTransfer(
2545         address from,
2546         address to,
2547         uint256 tokenId,
2548         uint256 batchSize
2549     )
2550         internal
2551         virtual
2552         override(ERC721Upgradeable, ERC721EnumerableUpgradeable){
2553         super._beforeTokenTransfer(from, to, tokenId, batchSize);
2554     }
2555 
2556     function _burn(uint256 tokenId)
2557         internal
2558         override(ERC721Upgradeable, ERC721URIStorageUpgradeable)
2559     {
2560         super._burn(tokenId);
2561     }
2562 
2563     function supportsInterface(bytes4 interfaceId)
2564         public
2565         view
2566         override(ERC721Upgradeable, ERC721EnumerableUpgradeable)
2567         returns (bool)
2568     {
2569         return super.supportsInterface(interfaceId);
2570     }
2571 
2572     function totalSupply() public view override returns (uint256) {
2573         return maxSupply;
2574     }
2575 
2576     function setTokenURI(uint256 _tokenId, string memory _uri) external onlyOwner {
2577         _setTokenURI(_tokenId, _uri);
2578         randomSeed++;
2579     }
2580 
2581     function tokenURI(uint256 _tokenId) public view override(ERC721URIStorageUpgradeable, ERC721Upgradeable)
2582     returns (string memory) {
2583         return super.tokenURI(_tokenId);
2584     }
2585 
2586     function setContractURI(string memory _uri) external onlyOwner {
2587         contractURI = _uri;
2588         randomSeed++;
2589     }
2590 
2591     function isAddressInLists(address _address) external view returns ( TokenTiers[] memory, uint256, uint256, uint256 ) {
2592         TokenTiers[] memory temp;
2593         return (owner() == msg.sender? tokenTiers: temp, owner() == msg.sender? allowList[_address]: 0, owner() == msg.sender? mintCount[_address]: 0, owner() == msg.sender? discountList[_address]: 0);
2594     }
2595     
2596      function setApprovalForAll(address operator, bool approved) public override(IERC721Upgradeable, ERC721Upgradeable) onlyAllowedOperatorApproval(operator) {
2597         super.setApprovalForAll(operator, approved);
2598     }
2599 
2600     function approve(address operator, uint256 tokenId) public override(IERC721Upgradeable, ERC721Upgradeable) onlyAllowedOperatorApproval(operator) {
2601         super.approve(operator, tokenId);
2602     }
2603 
2604     function transferFrom(address from, address to, uint256 tokenId) public override(IERC721Upgradeable, ERC721Upgradeable) onlyAllowedOperator(from) {
2605         super.transferFrom(from, to, tokenId);
2606     }
2607 
2608     function safeTransferFrom(address from, address to, uint256 tokenId) public override(IERC721Upgradeable, ERC721Upgradeable) onlyAllowedOperator(from) {
2609         super.safeTransferFrom(from, to, tokenId);
2610     }
2611 
2612     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2613         public
2614         override(IERC721Upgradeable, ERC721Upgradeable)
2615         onlyAllowedOperator(from)
2616     {
2617         super.safeTransferFrom(from, to, tokenId, data);
2618     }
2619 
2620 }
