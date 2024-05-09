1 // SPDX-License-Identifier: GPL-3.0
2  
3 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
4 pragma solidity ^0.8.0;
5  
6 /**
7 * @title ERC721 token receiver interface
8 * @dev Interface for any contract that wants to support safeTransfers
9 * from ERC721 asset contracts.
10 */
11 interface IERC721Receiver {
12    /**
13     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
14     * by `operator` from `from`, this function is called.
15     *
16     * It must return its Solidity selector to confirm the token transfer.
17     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
18     *
19     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
20     */
21    function onERC721Received(
22        address operator,
23        address from,
24        uint256 tokenId,
25        bytes calldata data
26    ) external returns (bytes4);
27 }
28  
29 // File: @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol
30  
31  
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)
33  
34 pragma solidity ^0.8.0;
35  
36  
37 /**
38 * @dev Implementation of the {IERC721Receiver} interface.
39 *
40 * Accepts all token transfers.
41 * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
42 */
43 contract ERC721Holder is IERC721Receiver {
44    /**
45     * @dev See {IERC721Receiver-onERC721Received}.
46     *
47     * Always returns `IERC721Receiver.onERC721Received.selector`.
48     */
49    function onERC721Received(
50        address,
51        address,
52        uint256,
53        bytes memory
54    ) public virtual override returns (bytes4) {
55        return this.onERC721Received.selector;
56    }
57 }
58  
59 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
60  
61  
62 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
63  
64 pragma solidity ^0.8.0;
65  
66 /**
67 * @dev Interface of the ERC165 standard, as defined in the
68 * https://eips.ethereum.org/EIPS/eip-165[EIP].
69 *
70 * Implementers can declare support of contract interfaces, which can then be
71 * queried by others ({ERC165Checker}).
72 *
73 * For an implementation, see {ERC165}.
74 */
75 interface IERC165 {
76    /**
77     * @dev Returns true if this contract implements the interface defined by
78     * `interfaceId`. See the corresponding
79     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
80     * to learn more about how these ids are created.
81     *
82     * This function call must use less than 30 000 gas.
83     */
84    function supportsInterface(bytes4 interfaceId) external view returns (bool);
85 }
86  
87 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
88  
89  
90 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
91  
92 pragma solidity ^0.8.0;
93  
94  
95 /**
96 * @dev Required interface of an ERC721 compliant contract.
97 */
98 interface IERC721 is IERC165 {
99    /**
100     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
101     */
102    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
103  
104    /**
105     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
106     */
107    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
108  
109    /**
110     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
111     */
112    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
113  
114    /**
115     * @dev Returns the number of tokens in ``owner``'s account.
116     */
117    function balanceOf(address owner) external view returns (uint256 balance);
118  
119    /**
120     * @dev Returns the owner of the `tokenId` token.
121     *
122     * Requirements:
123     *
124     * - `tokenId` must exist.
125     */
126    function ownerOf(uint256 tokenId) external view returns (address owner);
127  
128    /**
129     * @dev Safely transfers `tokenId` token from `from` to `to`.
130     *
131     * Requirements:
132     *
133     * - `from` cannot be the zero address.
134     * - `to` cannot be the zero address.
135     * - `tokenId` token must exist and be owned by `from`.
136     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
137     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138     *
139     * Emits a {Transfer} event.
140     */
141    function safeTransferFrom(
142        address from,
143        address to,
144        uint256 tokenId,
145        bytes calldata data
146    ) external;
147  
148    /**
149     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
150     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
151     *
152     * Requirements:
153     *
154     * - `from` cannot be the zero address.
155     * - `to` cannot be the zero address.
156     * - `tokenId` token must exist and be owned by `from`.
157     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
158     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159     *
160     * Emits a {Transfer} event.
161     */
162    function safeTransferFrom(
163        address from,
164        address to,
165        uint256 tokenId
166    ) external;
167  
168    /**
169     * @dev Transfers `tokenId` token from `from` to `to`.
170     *
171     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
172     *
173     * Requirements:
174     *
175     * - `from` cannot be the zero address.
176     * - `to` cannot be the zero address.
177     * - `tokenId` token must be owned by `from`.
178     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179     *
180     * Emits a {Transfer} event.
181     */
182    function transferFrom(
183        address from,
184        address to,
185        uint256 tokenId
186    ) external;
187  
188    /**
189     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
190     * The approval is cleared when the token is transferred.
191     *
192     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
193     *
194     * Requirements:
195     *
196     * - The caller must own the token or be an approved operator.
197     * - `tokenId` must exist.
198     *
199     * Emits an {Approval} event.
200     */
201    function approve(address to, uint256 tokenId) external;
202  
203    /**
204     * @dev Approve or remove `operator` as an operator for the caller.
205     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
206     *
207     * Requirements:
208     *
209     * - The `operator` cannot be the caller.
210     *
211     * Emits an {ApprovalForAll} event.
212     */
213    function setApprovalForAll(address operator, bool _approved) external;
214  
215    /**
216     * @dev Returns the account approved for `tokenId` token.
217     *
218     * Requirements:
219     *
220     * - `tokenId` must exist.
221     */
222    function getApproved(uint256 tokenId) external view returns (address operator);
223  
224    /**
225     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
226     *
227     * See {setApprovalForAll}
228     */
229    function isApprovedForAll(address owner, address operator) external view returns (bool);
230 }
231  
232 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
233  
234  
235 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
236  
237 pragma solidity ^0.8.0;
238  
239 /**
240 * @dev Interface of the ERC20 standard as defined in the EIP.
241 */
242 interface IERC20 {
243    /**
244     * @dev Emitted when `value` tokens are moved from one account (`from`) to
245     * another (`to`).
246     *
247     * Note that `value` may be zero.
248     */
249    event Transfer(address indexed from, address indexed to, uint256 value);
250  
251    /**
252     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253     * a call to {approve}. `value` is the new allowance.
254     */
255    event Approval(address indexed owner, address indexed spender, uint256 value);
256  
257    /**
258     * @dev Returns the amount of tokens in existence.
259     */
260    function totalSupply() external view returns (uint256);
261  
262    /**
263     * @dev Returns the amount of tokens owned by `account`.
264     */
265    function balanceOf(address account) external view returns (uint256);
266  
267    /**
268     * @dev Moves `amount` tokens from the caller's account to `to`.
269     *
270     * Returns a boolean value indicating whether the operation succeeded.
271     *
272     * Emits a {Transfer} event.
273     */
274    function transfer(address to, uint256 amount) external returns (bool);
275  
276    /**
277     * @dev Returns the remaining number of tokens that `spender` will be
278     * allowed to spend on behalf of `owner` through {transferFrom}. This is
279     * zero by default.
280     *
281     * This value changes when {approve} or {transferFrom} are called.
282     */
283    function allowance(address owner, address spender) external view returns (uint256);
284  
285    /**
286     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
287     *
288     * Returns a boolean value indicating whether the operation succeeded.
289     *
290     * IMPORTANT: Beware that changing an allowance with this method brings the risk
291     * that someone may use both the old and the new allowance by unfortunate
292     * transaction ordering. One possible solution to mitigate this race
293     * condition is to first reduce the spender's allowance to 0 and set the
294     * desired value afterwards:
295     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
296     *
297     * Emits an {Approval} event.
298     */
299    function approve(address spender, uint256 amount) external returns (bool);
300  
301    /**
302     * @dev Moves `amount` tokens from `from` to `to` using the
303     * allowance mechanism. `amount` is then deducted from the caller's
304     * allowance.
305     *
306     * Returns a boolean value indicating whether the operation succeeded.
307     *
308     * Emits a {Transfer} event.
309     */
310    function transferFrom(
311        address from,
312        address to,
313        uint256 amount
314    ) external returns (bool);
315 }
316  
317 // File: @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol
318  
319  
320 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
321  
322 pragma solidity ^0.8.1;
323  
324 /**
325 * @dev Collection of functions related to the address type
326 */
327 library AddressUpgradeable {
328    /**
329     * @dev Returns true if `account` is a contract.
330     *
331     * [IMPORTANT]
332     * ====
333     * It is unsafe to assume that an address for which this function returns
334     * false is an externally-owned account (EOA) and not a contract.
335     *
336     * Among others, `isContract` will return false for the following
337     * types of addresses:
338     *
339     *  - an externally-owned account
340     *  - a contract in construction
341     *  - an address where a contract will be created
342     *  - an address where a contract lived, but was destroyed
343     * ====
344     *
345     * [IMPORTANT]
346     * ====
347     * You shouldn't rely on `isContract` to protect against flash loan attacks!
348     *
349     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
350     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
351     * constructor.
352     * ====
353     */
354    function isContract(address account) internal view returns (bool) {
355        // This method relies on extcodesize/address.code.length, which returns 0
356        // for contracts in construction, since the code is only stored at the end
357        // of the constructor execution.
358  
359        return account.code.length > 0;
360    }
361  
362    /**
363     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
364     * `recipient`, forwarding all available gas and reverting on errors.
365     *
366     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
367     * of certain opcodes, possibly making contracts go over the 2300 gas limit
368     * imposed by `transfer`, making them unable to receive funds via
369     * `transfer`. {sendValue} removes this limitation.
370     *
371     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
372     *
373     * IMPORTANT: because control is transferred to `recipient`, care must be
374     * taken to not create reentrancy vulnerabilities. Consider using
375     * {ReentrancyGuard} or the
376     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
377     */
378    function sendValue(address payable recipient, uint256 amount) internal {
379        require(address(this).balance >= amount, "Address: insufficient balance");
380  
381        (bool success, ) = recipient.call{value: amount}("");
382        require(success, "Address: unable to send value, recipient may have reverted");
383    }
384  
385    /**
386     * @dev Performs a Solidity function call using a low level `call`. A
387     * plain `call` is an unsafe replacement for a function call: use this
388     * function instead.
389     *
390     * If `target` reverts with a revert reason, it is bubbled up by this
391     * function (like regular Solidity function calls).
392     *
393     * Returns the raw returned data. To convert to the expected return value,
394     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
395     *
396     * Requirements:
397     *
398     * - `target` must be a contract.
399     * - calling `target` with `data` must not revert.
400     *
401     * _Available since v3.1._
402     */
403    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
404        return functionCall(target, data, "Address: low-level call failed");
405    }
406  
407    /**
408     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
409     * `errorMessage` as a fallback revert reason when `target` reverts.
410     *
411     * _Available since v3.1._
412     */
413    function functionCall(
414        address target,
415        bytes memory data,
416        string memory errorMessage
417    ) internal returns (bytes memory) {
418        return functionCallWithValue(target, data, 0, errorMessage);
419    }
420  
421    /**
422     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423     * but also transferring `value` wei to `target`.
424     *
425     * Requirements:
426     *
427     * - the calling contract must have an ETH balance of at least `value`.
428     * - the called Solidity function must be `payable`.
429     *
430     * _Available since v3.1._
431     */
432    function functionCallWithValue(
433        address target,
434        bytes memory data,
435        uint256 value
436    ) internal returns (bytes memory) {
437        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
438    }
439  
440    /**
441     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
442     * with `errorMessage` as a fallback revert reason when `target` reverts.
443     *
444     * _Available since v3.1._
445     */
446    function functionCallWithValue(
447        address target,
448        bytes memory data,
449        uint256 value,
450        string memory errorMessage
451    ) internal returns (bytes memory) {
452        require(address(this).balance >= value, "Address: insufficient balance for call");
453        require(isContract(target), "Address: call to non-contract");
454  
455        (bool success, bytes memory returndata) = target.call{value: value}(data);
456        return verifyCallResult(success, returndata, errorMessage);
457    }
458  
459    /**
460     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461     * but performing a static call.
462     *
463     * _Available since v3.3._
464     */
465    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
466        return functionStaticCall(target, data, "Address: low-level static call failed");
467    }
468  
469    /**
470     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471     * but performing a static call.
472     *
473     * _Available since v3.3._
474     */
475    function functionStaticCall(
476        address target,
477        bytes memory data,
478        string memory errorMessage
479    ) internal view returns (bytes memory) {
480        require(isContract(target), "Address: static call to non-contract");
481  
482        (bool success, bytes memory returndata) = target.staticcall(data);
483        return verifyCallResult(success, returndata, errorMessage);
484    }
485  
486    /**
487     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
488     * revert reason using the provided one.
489     *
490     * _Available since v4.3._
491     */
492    function verifyCallResult(
493        bool success,
494        bytes memory returndata,
495        string memory errorMessage
496    ) internal pure returns (bytes memory) {
497        if (success) {
498            return returndata;
499        } else {
500            // Look for revert reason and bubble it up if present
501            if (returndata.length > 0) {
502                // The easiest way to bubble the revert reason is using memory via assembly
503                /// @solidity memory-safe-assembly
504                assembly {
505                    let returndata_size := mload(returndata)
506                    revert(add(32, returndata), returndata_size)
507                }
508            } else {
509                revert(errorMessage);
510            }
511        }
512    }
513 }
514  
515 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
516  
517  
518 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
519  
520 pragma solidity ^0.8.2;
521  
522  
523 /**
524 * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
525 * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
526 * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
527 * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
528 *
529 * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
530 * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
531 * case an upgrade adds a module that needs to be initialized.
532 *
533 * For example:
534 *
535 * [.hljs-theme-light.nopadding]
536 * ```
537 * contract MyToken is ERC20Upgradeable {
538 *     function initialize() initializer public {
539 *         __ERC20_init("MyToken", "MTK");
540 *     }
541 * }
542 * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
543 *     function initializeV2() reinitializer(2) public {
544 *         __ERC20Permit_init("MyToken");
545 *     }
546 * }
547 * ```
548 *
549 * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
550 * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
551 *
552 * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
553 * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
554 *
555 * [CAUTION]
556 * ====
557 * Avoid leaving a contract uninitialized.
558 *
559 * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
560 * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
561 * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
562 *
563 * [.hljs-theme-light.nopadding]
564 * ```
565 * /// @custom:oz-upgrades-unsafe-allow constructor
566 * constructor() {
567 *     _disableInitializers();
568 * }
569 * ```
570 * ====
571 */
572 abstract contract Initializable {
573    /**
574     * @dev Indicates that the contract has been initialized.
575     * @custom:oz-retyped-from bool
576     */
577    uint8 private _initialized;
578  
579    /**
580     * @dev Indicates that the contract is in the process of being initialized.
581     */
582    bool private _initializing;
583  
584    /**
585     * @dev Triggered when the contract has been initialized or reinitialized.
586     */
587    event Initialized(uint8 version);
588  
589    /**
590     * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
591     * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
592     */
593    modifier initializer() {
594        bool isTopLevelCall = !_initializing;
595        require(
596            (isTopLevelCall && _initialized < 1) || (!AddressUpgradeable.isContract(address(this)) && _initialized == 1),
597            "Initializable: contract is already initialized"
598        );
599        _initialized = 1;
600        if (isTopLevelCall) {
601            _initializing = true;
602        }
603        _;
604        if (isTopLevelCall) {
605            _initializing = false;
606            emit Initialized(1);
607        }
608    }
609  
610    /**
611     * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
612     * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
613     * used to initialize parent contracts.
614     *
615     * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
616     * initialization step. This is essential to configure modules that are added through upgrades and that require
617     * initialization.
618     *
619     * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
620     * a contract, executing them in the right order is up to the developer or operator.
621     */
622    modifier reinitializer(uint8 version) {
623        require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
624        _initialized = version;
625        _initializing = true;
626        _;
627        _initializing = false;
628        emit Initialized(version);
629    }
630  
631    /**
632     * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
633     * {initializer} and {reinitializer} modifiers, directly or indirectly.
634     */
635    modifier onlyInitializing() {
636        require(_initializing, "Initializable: contract is not initializing");
637        _;
638    }
639  
640    /**
641     * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
642     * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
643     * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
644     * through proxies.
645     */
646    function _disableInitializers() internal virtual {
647        require(!_initializing, "Initializable: contract is initializing");
648        if (_initialized < type(uint8).max) {
649            _initialized = type(uint8).max;
650            emit Initialized(type(uint8).max);
651        }
652    }
653 }
654  
655 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
656  
657  
658 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
659  
660 pragma solidity ^0.8.0;
661  
662  
663 /**
664 * @dev Provides information about the current execution context, including the
665 * sender of the transaction and its data. While these are generally available
666 * via msg.sender and msg.data, they should not be accessed in such a direct
667 * manner, since when dealing with meta-transactions the account sending and
668 * paying for execution may not be the actual sender (as far as an application
669 * is concerned).
670 *
671 * This contract is only required for intermediate, library-like contracts.
672 */
673 abstract contract ContextUpgradeable is Initializable {
674    function __Context_init() internal onlyInitializing {
675    }
676  
677    function __Context_init_unchained() internal onlyInitializing {
678    }
679    function _msgSender() internal view virtual returns (address) {
680        return msg.sender;
681    }
682  
683    function _msgData() internal view virtual returns (bytes calldata) {
684        return msg.data;
685    }
686  
687    /**
688     * @dev This empty reserved space is put in place to allow future versions to add new
689     * variables without shifting down storage in the inheritance chain.
690     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
691     */
692    uint256[50] private __gap;
693 }
694  
695 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
696  
697  
698 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
699  
700 pragma solidity ^0.8.0;
701  
702  
703  
704 /**
705 * @dev Contract module which provides a basic access control mechanism, where
706 * there is an account (an owner) that can be granted exclusive access to
707 * specific functions.
708 *
709 * By default, the owner account will be the one that deploys the contract. This
710 * can later be changed with {transferOwnership}.
711 *
712 * This module is used through inheritance. It will make available the modifier
713 * `onlyOwner`, which can be applied to your functions to restrict their use to
714 * the owner.
715 */
716 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
717    address private _owner;
718  
719    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720  
721    /**
722     * @dev Initializes the contract setting the deployer as the initial owner.
723     */
724    function __Ownable_init() internal onlyInitializing {
725        __Ownable_init_unchained();
726    }
727  
728    function __Ownable_init_unchained() internal onlyInitializing {
729        _transferOwnership(_msgSender());
730    }
731  
732    /**
733     * @dev Throws if called by any account other than the owner.
734     */
735    modifier onlyOwner() {
736        _checkOwner();
737        _;
738    }
739  
740    /**
741     * @dev Returns the address of the current owner.
742     */
743    function owner() public view virtual returns (address) {
744        return _owner;
745    }
746  
747    /**
748     * @dev Throws if the sender is not the owner.
749     */
750    function _checkOwner() internal view virtual {
751        require(owner() == _msgSender(), "Ownable: caller is not the owner");
752    }
753  
754    /**
755     * @dev Leaves the contract without owner. It will not be possible to call
756     * `onlyOwner` functions anymore. Can only be called by the current owner.
757     *
758     * NOTE: Renouncing ownership will leave the contract without an owner,
759     * thereby removing any functionality that is only available to the owner.
760     */
761    function renounceOwnership() public virtual onlyOwner {
762        _transferOwnership(address(0));
763    }
764  
765    /**
766     * @dev Transfers ownership of the contract to a new account (`newOwner`).
767     * Can only be called by the current owner.
768     */
769    function transferOwnership(address newOwner) public virtual onlyOwner {
770        require(newOwner != address(0), "Ownable: new owner is the zero address");
771        _transferOwnership(newOwner);
772    }
773  
774    /**
775     * @dev Transfers ownership of the contract to a new account (`newOwner`).
776     * Internal function without access restriction.
777     */
778    function _transferOwnership(address newOwner) internal virtual {
779        address oldOwner = _owner;
780        _owner = newOwner;
781        emit OwnershipTransferred(oldOwner, newOwner);
782    }
783  
784    /**
785     * @dev This empty reserved space is put in place to allow future versions to add new
786     * variables without shifting down storage in the inheritance chain.
787     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
788     */
789    uint256[49] private __gap;
790 }
791  
792 // File: @openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol
793  
794  
795 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
796  
797 pragma solidity ^0.8.0;
798  
799  
800 /**
801 * @dev Contract module that helps prevent reentrant calls to a function.
802 *
803 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
804 * available, which can be applied to functions to make sure there are no nested
805 * (reentrant) calls to them.
806 *
807 * Note that because there is a single `nonReentrant` guard, functions marked as
808 * `nonReentrant` may not call one another. This can be worked around by making
809 * those functions `private`, and then adding `external` `nonReentrant` entry
810 * points to them.
811 *
812 * TIP: If you would like to learn more about reentrancy and alternative ways
813 * to protect against it, check out our blog post
814 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
815 */
816 abstract contract ReentrancyGuardUpgradeable is Initializable {
817    // Booleans are more expensive than uint256 or any type that takes up a full
818    // word because each write operation emits an extra SLOAD to first read the
819    // slot's contents, replace the bits taken up by the boolean, and then write
820    // back. This is the compiler's defense against contract upgrades and
821    // pointer aliasing, and it cannot be disabled.
822  
823    // The values being non-zero value makes deployment a bit more expensive,
824    // but in exchange the refund on every call to nonReentrant will be lower in
825    // amount. Since refunds are capped to a percentage of the total
826    // transaction's gas, it is best to keep them low in cases like this one, to
827    // increase the likelihood of the full refund coming into effect.
828    uint256 private constant _NOT_ENTERED = 1;
829    uint256 private constant _ENTERED = 2;
830  
831    uint256 private _status;
832  
833    function __ReentrancyGuard_init() internal onlyInitializing {
834        __ReentrancyGuard_init_unchained();
835    }
836  
837    function __ReentrancyGuard_init_unchained() internal onlyInitializing {
838        _status = _NOT_ENTERED;
839    }
840  
841    /**
842     * @dev Prevents a contract from calling itself, directly or indirectly.
843     * Calling a `nonReentrant` function from another `nonReentrant`
844     * function is not supported. It is possible to prevent this from happening
845     * by making the `nonReentrant` function external, and making it call a
846     * `private` function that does the actual work.
847     */
848    modifier nonReentrant() {
849        // On the first call to nonReentrant, _notEntered will be true
850        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
851  
852        // Any calls to nonReentrant after this point will fail
853        _status = _ENTERED;
854  
855        _;
856  
857        // By storing the original value once again, a refund is triggered (see
858        // https://eips.ethereum.org/EIPS/eip-2200)
859        _status = _NOT_ENTERED;
860    }
861  
862    /**
863     * @dev This empty reserved space is put in place to allow future versions to add new
864     * variables without shifting down storage in the inheritance chain.
865     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
866     */
867    uint256[49] private __gap;
868 }
869  
870  
871 /// @title Interface for Player Zero Token
872 pragma solidity ^0.8.6;
873  
874 abstract contract PLAYERZEROTOKEN is IERC721  {
875  function mintToken() external virtual;
876  function totalSupply() external view virtual returns (uint256);
877 }
878  
879 /// @title Interface for Player Zero Auction
880 pragma solidity ^0.8.6;
881  
882 interface PlayerZeroAuction {
883  
884    event AuctionCreated(uint256 indexed currentToken, uint256 startTime, uint256 endTime);
885  
886    event AuctionBid(uint256 indexed currentToken, address sender, uint256 value, bool extended);
887  
888    event AuctionExtended(uint256 indexed currentToken, uint256 endTime);
889  
890    event AuctionSettled(uint256 indexed currentToken, address winner, uint256 amount);
891  
892    event AuctionTimeBufferUpdated(uint256 timeBuffer);
893  
894    event AuctionReservePriceUpdated(uint256 reservePrice);
895  
896    event AuctionMinBidIncrementPercentageUpdated(uint256 minBidIncrementPercentage);
897  
898    function settleAuction() external;
899  
900    function settleCurrentAndCreateNewAuction() external;
901  
902    function createBid(uint256 token) external payable;
903  
904    function setTimeBuffer(uint256 timeBuffer) external;
905  
906    function setReservePrice(uint256 reservePrice) external;
907  
908    function setMinBidIncrementPercentage(uint8 minBidIncrementPercentage) external;
909 }
910  
911 /// @title IWETH
912 pragma solidity ^0.8.6;
913  
914 interface IWETH {
915    function deposit() external payable;
916  
917    function withdraw(uint256 wad) external;
918  
919    function transfer(address to, uint256 value) external returns (bool);
920 }
921  
922 // LICENSE
923 // PlayerZeroAuction.sol is a modified version of Zora's AuctionHouse.sol:
924 // https://github.com/ourzora/auction-house/blob/54a12ec1a6cf562e49f0a4917990474b11350a2d/contracts/AuctionHouse.sol
925 //
926 // PlayerZeroAuction.sol source code Copyright Zora licensed under the GPL-3.0 license.
927 // With modifications by PlayerZero.
928  
929 /// @title The PlayerZero Auction House
930 contract PlayerZeroAuctionHouse is PlayerZeroAuction, ReentrancyGuardUpgradeable, OwnableUpgradeable, ERC721Holder {
931    // The PlayerZero ERC721 token contract
932    PLAYERZEROTOKEN public playerzero;
933  
934    // The status of the auction
935    bool public auctionStatus;
936  
937    // The address of the WETH contract
938    address public weth;
939  
940    // The address of the admin wallet
941    address public adminWallet;
942  
943    // The minimum amount of time left in an auction after a new bid is created
944    uint256 public timeBuffer;
945  
946    // The minimum price accepted in an auction
947    uint256 public reservePrice;
948  
949    // The minimum percentage difference between the last bid amount and the current bid
950    uint8 public minBidIncrementPercentage;
951  
952    // The duration of a single auction
953    uint256 public duration;
954  
955    // ID for the Player Zero (ERC721 token ID)
956    uint256 public currentToken;
957  
958    // The current highest bid amount
959    uint256 public amount;
960  
961    // The time that the auction started
962    uint256 public startTime;
963  
964    // The time that the auction is scheduled to end
965    uint256 public endTime;
966  
967    // The address of the current highest bid
968    address payable  public bidder;
969  
970    // Whether or not the auction has been settled
971    bool public settled;
972  
973    // The address of the winning bid based on any token
974    mapping(uint256 => address) public getWinningBidders;
975  
976    // The amount of the winning bid based on any token
977    mapping(uint256 => uint256) public getWinningAmount;
978  
979    /**
980     * @notice Initialize the auction house and base contracts,
981     * @dev This function can only be called once.
982     */
983    function initialize(
984        PLAYERZEROTOKEN _playerzero,
985        address _weth,
986        address _adminWallet,
987        uint256 _timeBuffer,
988        uint256 _reservePrice,
989        uint8 _minBidIncrementPercentage,
990        uint256 _duration
991    ) external initializer {
992        __ReentrancyGuard_init();
993        __Ownable_init();
994        auctionStatus = false;
995        playerzero = _playerzero;
996        weth = _weth;
997        adminWallet = _adminWallet;
998        timeBuffer = _timeBuffer;
999        reservePrice = _reservePrice;
1000        minBidIncrementPercentage = _minBidIncrementPercentage;
1001        duration = _duration;
1002    }
1003  
1004    ///////////////////////////
1005    // BIDDING FUNCTIONALITY //
1006    ///////////////////////////
1007  
1008    /**
1009     * @notice Create a bid for a Token, with a given amount.
1010     * @dev This contract only accepts payment in ETH.
1011     */
1012    function createBid(uint256 token) external payable override nonReentrant {
1013  
1014        require(currentToken == token, "Token not up for auction");
1015        require(block.timestamp < endTime, "Auction expired");
1016        require(msg.value >= reservePrice, "Must send at least reservePrice");
1017        require(
1018            msg.value >= amount + ((amount * minBidIncrementPercentage) / 100),
1019            "Must send more than last bid by minBidIncrementPercentage amount"
1020        );
1021  
1022        address payable lastBidder = bidder;
1023  
1024        // Refund the last bidder, if applicable
1025        if (lastBidder != address(0)) {
1026            _safeTransferETHWithFallback(lastBidder, amount);
1027        }
1028  
1029        amount = msg.value;
1030        bidder = payable(msg.sender);
1031  
1032        // Extend the auction if the bid was received within `timeBuffer` of the auction end time
1033        bool extended = endTime - block.timestamp < timeBuffer;
1034        if (extended) {
1035            endTime = block.timestamp + timeBuffer;
1036        }
1037  
1038        emit AuctionBid(currentToken, msg.sender, msg.value, extended);
1039  
1040        if (extended) {
1041            emit AuctionExtended(currentToken, endTime);
1042        }
1043    }
1044  
1045    ////////////////////////////
1046    // EXTERNAL FUNCTIONALITY //
1047    ////////////////////////////
1048  
1049  
1050    /**
1051     * @notice Settle the current auction.
1052     * @dev This function can only be called when the contract is off and by  owner.
1053     */
1054    function settleAuction() external override nonReentrant onlyOwner {
1055        require(!auctionStatus, "Auction is on");
1056        _settleAuction();
1057    }
1058  
1059    /**
1060     * @notice create an current auction.
1061     * @dev This function can only be called when the contract is off and by owner
1062     */
1063    function createAuction() external nonReentrant onlyOwner {
1064        require(!auctionStatus, "Auction is on");
1065        _createAuction();
1066        auctionStatus = true;
1067    }
1068  
1069    /**
1070     * @notice Settle the current auction, mint a new Token, and put it up for auction.
1071     * @dev This function can only be called when the contract is on.
1072     */
1073    function settleCurrentAndCreateNewAuction() external override nonReentrant {
1074        require(auctionStatus, "Auction is not on");
1075        _settleAuction();
1076        _createAuction();
1077    }
1078  
1079    /**
1080     * @notice Calls total supply on token contract
1081     */
1082    function getNextTokenID() external view returns (uint256) {
1083        return playerzero.totalSupply();
1084    }
1085  
1086    /**
1087     * @notice Calls total supply on token contract and subtracts 1 for current auction
1088     */
1089    function getCurrentTokenID() external view returns (uint256) {
1090        return playerzero.totalSupply() - 1;
1091    }
1092  
1093    /**
1094     * @notice Calls Remaing time of the current auction
1095     */
1096    function getRemainingTime() external view returns (uint256) {
1097        return endTime - block.timestamp;
1098    }
1099  
1100    /**
1101     * @notice Calls block timestamp
1102     */
1103    function getBockTimestamp() external view returns (uint256) {
1104        return block.timestamp;
1105    }
1106  
1107    ////////////////////////////
1108    // INTERNAL FUNCTIONALITY //
1109    ////////////////////////////
1110  
1111    /**
1112     * @notice Create an auction.
1113     * @dev Store the auction details in the `auction` state variable and emit an AuctionCreated event.
1114     */
1115    function _createAuction() internal {
1116        currentToken = playerzero.totalSupply();
1117        playerzero.mintToken();
1118        startTime = block.timestamp;
1119        endTime = startTime + duration;
1120        amount =  0;
1121        bidder =  payable(0);
1122        settled = false;
1123        emit AuctionCreated(currentToken, startTime, endTime);
1124    }
1125  
1126    /**
1127     * @notice Settle an auction, finalizing the bid and paying out to the owner.
1128     */
1129    function _settleAuction() internal {
1130        require(startTime != 0, "Auction hasn't begun");
1131        require(!settled, "Auction has already been settled");
1132        require(block.timestamp >= endTime, "Auction hasn't completed");
1133  
1134        settled = true;
1135       
1136  
1137        if (bidder == address(0)) {
1138            playerzero.transferFrom(address(this), adminWallet, currentToken);
1139        } else {
1140            playerzero.transferFrom(address(this), bidder, currentToken);
1141            getWinningBidders[currentToken] = bidder;
1142        }
1143  
1144        if (amount > 0) {
1145            _safeTransferETHWithFallback(adminWallet, amount);
1146            getWinningAmount[currentToken] = amount;
1147        }
1148  
1149        emit AuctionSettled(currentToken, bidder, amount);
1150    }
1151  
1152    /**
1153     * @notice Transfer ETH. If the ETH transfer fails, wrap the ETH and try send it as WETH.
1154     */
1155    function _safeTransferETHWithFallback(address to, uint256 value) internal {
1156        if (!_safeTransferETH(to, value)) {
1157            IWETH(weth).deposit{ value: value }();
1158            IERC20(weth).transfer(to, value);
1159        }
1160    }
1161  
1162    /**
1163     * @notice Transfer ETH and return the success status.
1164     * @dev This function only forwards 30,000 gas to the callee.
1165     */
1166    function _safeTransferETH(address to, uint256 value) internal returns (bool) {
1167        (bool success, ) = to.call{ value: value, gas: 30_000 }(new bytes(0));
1168        return success;
1169    }
1170  
1171    /////////////////////////
1172    // ADMIN FUNCTIONALITY //
1173    /////////////////////////
1174  
1175    /**
1176     * @notice turns off the Player Zero auction house.
1177     * @dev This function can only be called by the owner when the
1178     * contract is on. While no new auctions can be started when the contract is on,
1179     * anyone can settle an ongoing auction.
1180     */
1181    function stopAuction() external onlyOwner {
1182        require(auctionStatus, "Auction is not on");
1183        auctionStatus = false;
1184    }
1185  
1186    /**
1187     * @notice turns on the Player Zero auction house.
1188     * @dev This function can only be called by the owner when the
1189     * contract is not on. If required, this function will start a new auction.
1190     */
1191    function startAuction() external onlyOwner {
1192        require(!auctionStatus, "Auction is on");
1193        _createAuction();
1194        auctionStatus = true;
1195    }
1196  
1197    /**
1198     * @notice Set the auction time buffer.
1199     * @dev Only callable by the owner.
1200     */
1201    function setTimeBuffer(uint256 _timeBuffer) external override onlyOwner {
1202        timeBuffer = _timeBuffer;
1203  
1204        emit AuctionTimeBufferUpdated(_timeBuffer);
1205    }
1206  
1207    /**
1208     * @notice Set the auction reserve price.
1209     * @dev Only callable by the owner.
1210     */
1211    function setReservePrice(uint256 _reservePrice) external override onlyOwner {
1212        reservePrice = _reservePrice;
1213  
1214        emit AuctionReservePriceUpdated(_reservePrice);
1215    }
1216  
1217    /**
1218     * @notice Set the admin wallet.
1219     * @dev Only callable by the owner.
1220     */
1221    function setAdminWallet(address _wallet) external onlyOwner {
1222        adminWallet = _wallet;
1223    }
1224  
1225    /**
1226     * @notice Set the auction minimum bid increment percentage.
1227     * @dev Only callable by the owner.
1228     */
1229    function setMinBidIncrementPercentage(uint8 _minBidIncrementPercentage) external override onlyOwner {
1230        minBidIncrementPercentage = _minBidIncrementPercentage;
1231  
1232        emit AuctionMinBidIncrementPercentageUpdated(_minBidIncrementPercentage);
1233    }
1234  
1235 }