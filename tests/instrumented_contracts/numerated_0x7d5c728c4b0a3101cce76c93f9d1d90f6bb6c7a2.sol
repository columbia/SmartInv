1 // Sources flattened with hardhat v2.10.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.0
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         _checkOwner();
63         _;
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if the sender is not the owner.
75      */
76     function _checkOwner() internal view virtual {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public virtual onlyOwner {
88         _transferOwnership(address(0));
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public virtual onlyOwner {
96         require(newOwner != address(0), "Ownable: new owner is the zero address");
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Internal function without access restriction.
103      */
104     function _transferOwnership(address newOwner) internal virtual {
105         address oldOwner = _owner;
106         _owner = newOwner;
107         emit OwnershipTransferred(oldOwner, newOwner);
108     }
109 }
110 
111 
112 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.0
113 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev Contract module that helps prevent reentrant calls to a function.
119  *
120  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
121  * available, which can be applied to functions to make sure there are no nested
122  * (reentrant) calls to them.
123  *
124  * Note that because there is a single `nonReentrant` guard, functions marked as
125  * `nonReentrant` may not call one another. This can be worked around by making
126  * those functions `private`, and then adding `external` `nonReentrant` entry
127  * points to them.
128  *
129  * TIP: If you would like to learn more about reentrancy and alternative ways
130  * to protect against it, check out our blog post
131  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
132  */
133 abstract contract ReentrancyGuard {
134     // Booleans are more expensive than uint256 or any type that takes up a full
135     // word because each write operation emits an extra SLOAD to first read the
136     // slot's contents, replace the bits taken up by the boolean, and then write
137     // back. This is the compiler's defense against contract upgrades and
138     // pointer aliasing, and it cannot be disabled.
139 
140     // The values being non-zero value makes deployment a bit more expensive,
141     // but in exchange the refund on every call to nonReentrant will be lower in
142     // amount. Since refunds are capped to a percentage of the total
143     // transaction's gas, it is best to keep them low in cases like this one, to
144     // increase the likelihood of the full refund coming into effect.
145     uint256 private constant _NOT_ENTERED = 1;
146     uint256 private constant _ENTERED = 2;
147 
148     uint256 private _status;
149 
150     constructor() {
151         _status = _NOT_ENTERED;
152     }
153 
154     /**
155      * @dev Prevents a contract from calling itself, directly or indirectly.
156      * Calling a `nonReentrant` function from another `nonReentrant`
157      * function is not supported. It is possible to prevent this from happening
158      * by making the `nonReentrant` function external, and making it call a
159      * `private` function that does the actual work.
160      */
161     modifier nonReentrant() {
162         // On the first call to nonReentrant, _notEntered will be true
163         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
164 
165         // Any calls to nonReentrant after this point will fail
166         _status = _ENTERED;
167 
168         _;
169 
170         // By storing the original value once again, a refund is triggered (see
171         // https://eips.ethereum.org/EIPS/eip-2200)
172         _status = _NOT_ENTERED;
173     }
174 }
175 
176 
177 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
178 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @title ERC721 token receiver interface
184  * @dev Interface for any contract that wants to support safeTransfers
185  * from ERC721 asset contracts.
186  */
187 interface IERC721Receiver {
188     /**
189      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
190      * by `operator` from `from`, this function is called.
191      *
192      * It must return its Solidity selector to confirm the token transfer.
193      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
194      *
195      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
196      */
197     function onERC721Received(
198         address operator,
199         address from,
200         uint256 tokenId,
201         bytes calldata data
202     ) external returns (bytes4);
203 }
204 
205 
206 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
207 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
208 
209 pragma solidity ^0.8.0;
210 
211 /**
212  * @dev Interface of the ERC165 standard, as defined in the
213  * https://eips.ethereum.org/EIPS/eip-165[EIP].
214  *
215  * Implementers can declare support of contract interfaces, which can then be
216  * queried by others ({ERC165Checker}).
217  *
218  * For an implementation, see {ERC165}.
219  */
220 interface IERC165 {
221     /**
222      * @dev Returns true if this contract implements the interface defined by
223      * `interfaceId`. See the corresponding
224      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
225      * to learn more about how these ids are created.
226      *
227      * This function call must use less than 30 000 gas.
228      */
229     function supportsInterface(bytes4 interfaceId) external view returns (bool);
230 }
231 
232 
233 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
234 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Required interface of an ERC721 compliant contract.
240  */
241 interface IERC721 is IERC165 {
242     /**
243      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
244      */
245     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
246 
247     /**
248      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
249      */
250     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
251 
252     /**
253      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
254      */
255     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
256 
257     /**
258      * @dev Returns the number of tokens in ``owner``'s account.
259      */
260     function balanceOf(address owner) external view returns (uint256 balance);
261 
262     /**
263      * @dev Returns the owner of the `tokenId` token.
264      *
265      * Requirements:
266      *
267      * - `tokenId` must exist.
268      */
269     function ownerOf(uint256 tokenId) external view returns (address owner);
270 
271     /**
272      * @dev Safely transfers `tokenId` token from `from` to `to`.
273      *
274      * Requirements:
275      *
276      * - `from` cannot be the zero address.
277      * - `to` cannot be the zero address.
278      * - `tokenId` token must exist and be owned by `from`.
279      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
280      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
281      *
282      * Emits a {Transfer} event.
283      */
284     function safeTransferFrom(
285         address from,
286         address to,
287         uint256 tokenId,
288         bytes calldata data
289     ) external;
290 
291     /**
292      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
293      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
294      *
295      * Requirements:
296      *
297      * - `from` cannot be the zero address.
298      * - `to` cannot be the zero address.
299      * - `tokenId` token must exist and be owned by `from`.
300      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
301      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
302      *
303      * Emits a {Transfer} event.
304      */
305     function safeTransferFrom(
306         address from,
307         address to,
308         uint256 tokenId
309     ) external;
310 
311     /**
312      * @dev Transfers `tokenId` token from `from` to `to`.
313      *
314      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
315      *
316      * Requirements:
317      *
318      * - `from` cannot be the zero address.
319      * - `to` cannot be the zero address.
320      * - `tokenId` token must be owned by `from`.
321      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transferFrom(
326         address from,
327         address to,
328         uint256 tokenId
329     ) external;
330 
331     /**
332      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
333      * The approval is cleared when the token is transferred.
334      *
335      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
336      *
337      * Requirements:
338      *
339      * - The caller must own the token or be an approved operator.
340      * - `tokenId` must exist.
341      *
342      * Emits an {Approval} event.
343      */
344     function approve(address to, uint256 tokenId) external;
345 
346     /**
347      * @dev Approve or remove `operator` as an operator for the caller.
348      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
349      *
350      * Requirements:
351      *
352      * - The `operator` cannot be the caller.
353      *
354      * Emits an {ApprovalForAll} event.
355      */
356     function setApprovalForAll(address operator, bool _approved) external;
357 
358     /**
359      * @dev Returns the account approved for `tokenId` token.
360      *
361      * Requirements:
362      *
363      * - `tokenId` must exist.
364      */
365     function getApproved(uint256 tokenId) external view returns (address operator);
366 
367     /**
368      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
369      *
370      * See {setApprovalForAll}
371      */
372     function isApprovedForAll(address owner, address operator) external view returns (bool);
373 }
374 
375 
376 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
377 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
378 
379 pragma solidity ^0.8.0;
380 
381 /**
382  * @dev Interface of the ERC20 standard as defined in the EIP.
383  */
384 interface IERC20 {
385     /**
386      * @dev Emitted when `value` tokens are moved from one account (`from`) to
387      * another (`to`).
388      *
389      * Note that `value` may be zero.
390      */
391     event Transfer(address indexed from, address indexed to, uint256 value);
392 
393     /**
394      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
395      * a call to {approve}. `value` is the new allowance.
396      */
397     event Approval(address indexed owner, address indexed spender, uint256 value);
398 
399     /**
400      * @dev Returns the amount of tokens in existence.
401      */
402     function totalSupply() external view returns (uint256);
403 
404     /**
405      * @dev Returns the amount of tokens owned by `account`.
406      */
407     function balanceOf(address account) external view returns (uint256);
408 
409     /**
410      * @dev Moves `amount` tokens from the caller's account to `to`.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transfer(address to, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Returns the remaining number of tokens that `spender` will be
420      * allowed to spend on behalf of `owner` through {transferFrom}. This is
421      * zero by default.
422      *
423      * This value changes when {approve} or {transferFrom} are called.
424      */
425     function allowance(address owner, address spender) external view returns (uint256);
426 
427     /**
428      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
429      *
430      * Returns a boolean value indicating whether the operation succeeded.
431      *
432      * IMPORTANT: Beware that changing an allowance with this method brings the risk
433      * that someone may use both the old and the new allowance by unfortunate
434      * transaction ordering. One possible solution to mitigate this race
435      * condition is to first reduce the spender's allowance to 0 and set the
436      * desired value afterwards:
437      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
438      *
439      * Emits an {Approval} event.
440      */
441     function approve(address spender, uint256 amount) external returns (bool);
442 
443     /**
444      * @dev Moves `amount` tokens from `from` to `to` using the
445      * allowance mechanism. `amount` is then deducted from the caller's
446      * allowance.
447      *
448      * Returns a boolean value indicating whether the operation succeeded.
449      *
450      * Emits a {Transfer} event.
451      */
452     function transferFrom(
453         address from,
454         address to,
455         uint256 amount
456     ) external returns (bool);
457 }
458 
459 
460 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.0
461 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
467  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
468  *
469  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
470  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
471  * need to send a transaction, and thus is not required to hold Ether at all.
472  */
473 interface IERC20Permit {
474     /**
475      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
476      * given ``owner``'s signed approval.
477      *
478      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
479      * ordering also apply here.
480      *
481      * Emits an {Approval} event.
482      *
483      * Requirements:
484      *
485      * - `spender` cannot be the zero address.
486      * - `deadline` must be a timestamp in the future.
487      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
488      * over the EIP712-formatted function arguments.
489      * - the signature must use ``owner``'s current nonce (see {nonces}).
490      *
491      * For more information on the signature format, see the
492      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
493      * section].
494      */
495     function permit(
496         address owner,
497         address spender,
498         uint256 value,
499         uint256 deadline,
500         uint8 v,
501         bytes32 r,
502         bytes32 s
503     ) external;
504 
505     /**
506      * @dev Returns the current nonce for `owner`. This value must be
507      * included whenever a signature is generated for {permit}.
508      *
509      * Every successful call to {permit} increases ``owner``'s nonce by one. This
510      * prevents a signature from being used multiple times.
511      */
512     function nonces(address owner) external view returns (uint256);
513 
514     /**
515      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
516      */
517     // solhint-disable-next-line func-name-mixedcase
518     function DOMAIN_SEPARATOR() external view returns (bytes32);
519 }
520 
521 
522 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
523 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
524 
525 pragma solidity ^0.8.1;
526 
527 /**
528  * @dev Collection of functions related to the address type
529  */
530 library Address {
531     /**
532      * @dev Returns true if `account` is a contract.
533      *
534      * [IMPORTANT]
535      * ====
536      * It is unsafe to assume that an address for which this function returns
537      * false is an externally-owned account (EOA) and not a contract.
538      *
539      * Among others, `isContract` will return false for the following
540      * types of addresses:
541      *
542      *  - an externally-owned account
543      *  - a contract in construction
544      *  - an address where a contract will be created
545      *  - an address where a contract lived, but was destroyed
546      * ====
547      *
548      * [IMPORTANT]
549      * ====
550      * You shouldn't rely on `isContract` to protect against flash loan attacks!
551      *
552      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
553      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
554      * constructor.
555      * ====
556      */
557     function isContract(address account) internal view returns (bool) {
558         // This method relies on extcodesize/address.code.length, which returns 0
559         // for contracts in construction, since the code is only stored at the end
560         // of the constructor execution.
561 
562         return account.code.length > 0;
563     }
564 
565     /**
566      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
567      * `recipient`, forwarding all available gas and reverting on errors.
568      *
569      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
570      * of certain opcodes, possibly making contracts go over the 2300 gas limit
571      * imposed by `transfer`, making them unable to receive funds via
572      * `transfer`. {sendValue} removes this limitation.
573      *
574      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
575      *
576      * IMPORTANT: because control is transferred to `recipient`, care must be
577      * taken to not create reentrancy vulnerabilities. Consider using
578      * {ReentrancyGuard} or the
579      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
580      */
581     function sendValue(address payable recipient, uint256 amount) internal {
582         require(address(this).balance >= amount, "Address: insufficient balance");
583 
584         (bool success, ) = recipient.call{value: amount}("");
585         require(success, "Address: unable to send value, recipient may have reverted");
586     }
587 
588     /**
589      * @dev Performs a Solidity function call using a low level `call`. A
590      * plain `call` is an unsafe replacement for a function call: use this
591      * function instead.
592      *
593      * If `target` reverts with a revert reason, it is bubbled up by this
594      * function (like regular Solidity function calls).
595      *
596      * Returns the raw returned data. To convert to the expected return value,
597      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
598      *
599      * Requirements:
600      *
601      * - `target` must be a contract.
602      * - calling `target` with `data` must not revert.
603      *
604      * _Available since v3.1._
605      */
606     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
607         return functionCall(target, data, "Address: low-level call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
612      * `errorMessage` as a fallback revert reason when `target` reverts.
613      *
614      * _Available since v3.1._
615      */
616     function functionCall(
617         address target,
618         bytes memory data,
619         string memory errorMessage
620     ) internal returns (bytes memory) {
621         return functionCallWithValue(target, data, 0, errorMessage);
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
626      * but also transferring `value` wei to `target`.
627      *
628      * Requirements:
629      *
630      * - the calling contract must have an ETH balance of at least `value`.
631      * - the called Solidity function must be `payable`.
632      *
633      * _Available since v3.1._
634      */
635     function functionCallWithValue(
636         address target,
637         bytes memory data,
638         uint256 value
639     ) internal returns (bytes memory) {
640         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
645      * with `errorMessage` as a fallback revert reason when `target` reverts.
646      *
647      * _Available since v3.1._
648      */
649     function functionCallWithValue(
650         address target,
651         bytes memory data,
652         uint256 value,
653         string memory errorMessage
654     ) internal returns (bytes memory) {
655         require(address(this).balance >= value, "Address: insufficient balance for call");
656         require(isContract(target), "Address: call to non-contract");
657 
658         (bool success, bytes memory returndata) = target.call{value: value}(data);
659         return verifyCallResult(success, returndata, errorMessage);
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
664      * but performing a static call.
665      *
666      * _Available since v3.3._
667      */
668     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
669         return functionStaticCall(target, data, "Address: low-level static call failed");
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
674      * but performing a static call.
675      *
676      * _Available since v3.3._
677      */
678     function functionStaticCall(
679         address target,
680         bytes memory data,
681         string memory errorMessage
682     ) internal view returns (bytes memory) {
683         require(isContract(target), "Address: static call to non-contract");
684 
685         (bool success, bytes memory returndata) = target.staticcall(data);
686         return verifyCallResult(success, returndata, errorMessage);
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
691      * but performing a delegate call.
692      *
693      * _Available since v3.4._
694      */
695     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
696         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
701      * but performing a delegate call.
702      *
703      * _Available since v3.4._
704      */
705     function functionDelegateCall(
706         address target,
707         bytes memory data,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         require(isContract(target), "Address: delegate call to non-contract");
711 
712         (bool success, bytes memory returndata) = target.delegatecall(data);
713         return verifyCallResult(success, returndata, errorMessage);
714     }
715 
716     /**
717      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
718      * revert reason using the provided one.
719      *
720      * _Available since v4.3._
721      */
722     function verifyCallResult(
723         bool success,
724         bytes memory returndata,
725         string memory errorMessage
726     ) internal pure returns (bytes memory) {
727         if (success) {
728             return returndata;
729         } else {
730             // Look for revert reason and bubble it up if present
731             if (returndata.length > 0) {
732                 // The easiest way to bubble the revert reason is using memory via assembly
733                 /// @solidity memory-safe-assembly
734                 assembly {
735                     let returndata_size := mload(returndata)
736                     revert(add(32, returndata), returndata_size)
737                 }
738             } else {
739                 revert(errorMessage);
740             }
741         }
742     }
743 }
744 
745 
746 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.0
747 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 
753 /**
754  * @title SafeERC20
755  * @dev Wrappers around ERC20 operations that throw on failure (when the token
756  * contract returns false). Tokens that return no value (and instead revert or
757  * throw on failure) are also supported, non-reverting calls are assumed to be
758  * successful.
759  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
760  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
761  */
762 library SafeERC20 {
763     using Address for address;
764 
765     function safeTransfer(
766         IERC20 token,
767         address to,
768         uint256 value
769     ) internal {
770         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
771     }
772 
773     function safeTransferFrom(
774         IERC20 token,
775         address from,
776         address to,
777         uint256 value
778     ) internal {
779         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
780     }
781 
782     /**
783      * @dev Deprecated. This function has issues similar to the ones found in
784      * {IERC20-approve}, and its usage is discouraged.
785      *
786      * Whenever possible, use {safeIncreaseAllowance} and
787      * {safeDecreaseAllowance} instead.
788      */
789     function safeApprove(
790         IERC20 token,
791         address spender,
792         uint256 value
793     ) internal {
794         // safeApprove should only be called when setting an initial allowance,
795         // or when resetting it to zero. To increase and decrease it, use
796         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
797         require(
798             (value == 0) || (token.allowance(address(this), spender) == 0),
799             "SafeERC20: approve from non-zero to non-zero allowance"
800         );
801         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
802     }
803 
804     function safeIncreaseAllowance(
805         IERC20 token,
806         address spender,
807         uint256 value
808     ) internal {
809         uint256 newAllowance = token.allowance(address(this), spender) + value;
810         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
811     }
812 
813     function safeDecreaseAllowance(
814         IERC20 token,
815         address spender,
816         uint256 value
817     ) internal {
818         unchecked {
819             uint256 oldAllowance = token.allowance(address(this), spender);
820             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
821             uint256 newAllowance = oldAllowance - value;
822             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
823         }
824     }
825 
826     function safePermit(
827         IERC20Permit token,
828         address owner,
829         address spender,
830         uint256 value,
831         uint256 deadline,
832         uint8 v,
833         bytes32 r,
834         bytes32 s
835     ) internal {
836         uint256 nonceBefore = token.nonces(owner);
837         token.permit(owner, spender, value, deadline, v, r, s);
838         uint256 nonceAfter = token.nonces(owner);
839         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
840     }
841 
842     /**
843      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
844      * on the return value: the return value is optional (but if data is returned, it must not be false).
845      * @param token The token targeted by the call.
846      * @param data The call data (encoded using abi.encode or one of its variants).
847      */
848     function _callOptionalReturn(IERC20 token, bytes memory data) private {
849         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
850         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
851         // the target address contains contract code and also asserts for success in the low-level call.
852 
853         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
854         if (returndata.length > 0) {
855             // Return data is optional
856             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
857         }
858     }
859 }
860 
861 
862 // File contracts/NekoProfitShares.sol
863 
864 // SPDX-License-Identifier: MIT
865 /// @author Mr D 
866 /// @title NEKO ProfitShares
867 pragma solidity >=0.8.11;
868 contract NekoProfitShares is Ownable, ReentrancyGuard, IERC721Receiver {
869     using SafeERC20 for IERC20;
870     
871     IERC20 public token;
872     IERC721 public nftContract;
873 
874     /* @dev team wallet should be a multi-sig wallet, used to transfer 
875     ETH out of the contract for a migration, or EOL of the contract */
876     address public teamWallet;
877 
878     // global flag to set staking and depositing active
879     bool public isActive;
880 
881     // flag to turn off only deposits
882     bool public depositsActive;
883 
884 
885     // total points to allocate rewards 
886     uint256 public totalSharePoints;
887 
888     uint256 private lockDuration = 14 days;
889 
890     struct UserLock {
891         uint256 tokenAmount; // total amount they currently have locked
892         uint256 claimedAmount; // total amount they have withdrawn
893         uint256 startTime; // start of the lock
894         uint256 endTime; // when the lock ends
895     }
896 
897     struct UserNftLock {
898         uint256 nftId; // nft id they have staked
899         uint256 amount; // amount they have locked
900         uint256 startTime; // start of the lock
901         uint256 endTime; // when the lock ends
902     }
903 
904     struct NftInfo {
905         uint256 lockDuration; // how long this nft needs is locked
906         uint256 shareMultiplier;  // multiply users shares by this number 1x = 10
907         uint256 lockedNfts; // how many nfts are currently locked for this ID
908         bool isDisabled; // so we can hide ones we don't want
909     }
910 
911     mapping(address => UserLock) public userLocks;
912     mapping(address => UserNftLock) public userNftLocks;
913     
914     NftInfo public nftInfo;
915     mapping(address => uint256) public currentMultiplier;
916 
917     mapping(address => uint256) public sharePoints;
918 
919     uint256 public constant MAX_MULTIPLIER = 30; // 3x
920 
921     
922     //Multiplier to add some accuracy to profitPerShare
923     uint256 private constant DistributionMultiplier = 2**64;
924     
925     //profit for each share a holder holds, a share equals a decimal.
926     uint256 public profitPerShare;
927 
928     //the total reward distributed through the vault, for tracking purposes
929     uint256 public totalShareRewards;
930     
931     //the total payout through the vault, for tracking purposes
932     uint256 public totalPayouts;
933    
934     //Mapping of the already paid out(or missed) shares of each staker
935     mapping(address => uint256) private alreadyPaidShares;
936     
937     //Mapping of shares that are reserved for payout
938     mapping(address => uint256) private toBePaid;
939 
940 
941     event Locked(address indexed account, uint256 unlock );
942     event WithdrawTokens(address indexed account, uint256 amount);
943     event NftLocked(address indexed account, uint256 nftId, uint256 unlock);
944 
945     event ClaimNative(address claimAddress, uint256 amount);
946     event NftUnLocked(address indexed account, uint256 nftId);
947 
948     constructor (
949         IERC20 _token,
950         IERC721 _nftContract,
951         address  _teamWallet
952     ) {     
953         token = _token;
954         nftContract = _nftContract;
955         teamWallet = _teamWallet;
956     }
957 
958     function setToken(IERC20 _token) public onlyOwner {
959         token = _token;
960     }
961 
962 
963     function setActive(bool _isActive) public onlyOwner {
964         isActive = _isActive;
965     }
966 
967     function setDepositsActive(bool _depositsActive) public onlyOwner {
968         depositsActive = _depositsActive;
969     }
970 
971     function setLockDuration(uint256 _lockDuration) public onlyOwner {
972         lockDuration = _lockDuration;
973     }
974 
975     function setNftContract( IERC721 _nftContract ) public onlyOwner {
976         nftContract = _nftContract;      
977     }
978 
979     function setNftInfo(
980         uint256 _lockDuration, 
981         uint256 _shareMultiplier) public onlyOwner {
982         
983         require(_shareMultiplier <= MAX_MULTIPLIER, 'Multiplier too high');
984 
985         nftInfo.lockDuration = _lockDuration;
986         nftInfo.shareMultiplier = _shareMultiplier; 
987 
988     }
989 
990     function setNftDisabled(bool _isDisabled) public onlyOwner {
991         nftInfo.isDisabled = _isDisabled;        
992     }
993 
994     function lock(uint256 _amount) public nonReentrant {
995         require(isActive && depositsActive,'Not active');
996         require(token.balanceOf(msg.sender) >= _amount, 'Not enough tokens');
997 
998         userLocks[msg.sender].tokenAmount = userLocks[msg.sender].tokenAmount + _amount;
999         userLocks[msg.sender].startTime = block.timestamp; 
1000         userLocks[msg.sender].endTime = block.timestamp + lockDuration; 
1001         
1002 
1003         // move the tokens
1004         token.safeTransferFrom(address(msg.sender), address(this), _amount);
1005 
1006         // multiply existing shares by the multiplier 
1007         uint256 shares = _amount; 
1008 
1009         if(currentMultiplier[msg.sender] > 0) {
1010           shares = (_amount * currentMultiplier[msg.sender])/10;
1011         }
1012 
1013          // give the shares
1014         _addShares(msg.sender,shares);
1015 
1016         emit Locked( msg.sender,userLocks[msg.sender].endTime );
1017 
1018     }
1019 
1020     function claimLock(uint256 _amount) public nonReentrant {
1021         require(isActive,'Not active');
1022         require(userLocks[msg.sender].endTime <= block.timestamp,'Tokens Locked');
1023         require(userLocks[msg.sender].tokenAmount > 0 && userLocks[msg.sender].tokenAmount >= _amount, 'Not enough tokens Locked');
1024 
1025         userLocks[msg.sender].claimedAmount = userLocks[msg.sender].claimedAmount + _amount;
1026         userLocks[msg.sender].tokenAmount = userLocks[msg.sender].tokenAmount - _amount;
1027 
1028         // multiply existing shares by the multiplier 
1029         uint256 shares = _amount; 
1030 
1031         if(currentMultiplier[msg.sender] > 0) {
1032           shares = (_amount * currentMultiplier[msg.sender])/10;
1033         }
1034 
1035         // remove the shares
1036         _removeShares(msg.sender, shares);
1037 
1038         // move the tokens
1039         token.safeTransfer(address(msg.sender), _amount);
1040         emit WithdrawTokens(msg.sender, _amount);
1041         
1042     }
1043 
1044     // locks an NFT for the amount of time and give shares
1045     function lockNft(uint256 _nftId) public nonReentrant {
1046         require(
1047             isActive &&
1048             depositsActive &&
1049             nftInfo.shareMultiplier > 0  && 
1050             !nftInfo.isDisabled && 
1051             nftContract.ownerOf(_nftId) == msg.sender &&
1052             userNftLocks[msg.sender].startTime == 0, "Can't Lock");
1053 
1054         userNftLocks[msg.sender].nftId = _nftId;
1055         userNftLocks[msg.sender].startTime = block.timestamp; 
1056         userNftLocks[msg.sender].endTime = block.timestamp + nftInfo.lockDuration; 
1057         userNftLocks[msg.sender].amount = userNftLocks[msg.sender].amount + 1; 
1058         
1059         // update the locked count
1060         nftInfo.lockedNfts = nftInfo.lockedNfts + 1;
1061 
1062         // assing the multiplier
1063         currentMultiplier[msg.sender] = nftInfo.shareMultiplier;
1064 
1065         uint256 currentShares = getShares(msg.sender); 
1066         // multiply existing shares by the multiplier and give them the difference
1067         uint256 shares = ((currentShares * nftInfo.shareMultiplier)/10) - currentShares;
1068 
1069         _addShares(msg.sender, shares);
1070 
1071         // send the NFT
1072         nftContract.safeTransferFrom( msg.sender, address(this), _nftId);
1073 
1074         emit NftLocked( msg.sender, _nftId, userNftLocks[msg.sender].endTime);
1075 
1076     }
1077 
1078     // unlocks and claims an NFT if allowed and removes the shares
1079     function unLockNft(uint256 _nftId) public nonReentrant {
1080         require(isActive && userNftLocks[msg.sender].amount > 0, 'Not Locked');
1081         require(block.timestamp >= userNftLocks[msg.sender].endTime, 'Still Locked');
1082  
1083         uint256 currentShares = getShares(msg.sender); 
1084         uint256 shares;
1085         if(currentMultiplier[msg.sender] > 0) {
1086             // divide existing shares by the multiplier and remove the difference
1087             shares = currentShares - ((currentShares*10)/currentMultiplier[msg.sender]);
1088         }
1089         
1090         // reset the multiplier
1091         currentMultiplier[msg.sender] = 0;
1092 
1093         // remove the shares
1094         _removeShares(msg.sender, shares);
1095 
1096         uint256 amount = userNftLocks[msg.sender].amount;
1097         delete userNftLocks[msg.sender];
1098 
1099         // update the locked count
1100         nftInfo.lockedNfts = nftInfo.lockedNfts - amount;
1101         
1102         // send the NFT
1103         nftContract.safeTransferFrom(  address(this), msg.sender, _nftId);
1104 
1105         emit NftUnLocked( msg.sender, _nftId);
1106     }
1107 
1108     //gets shares of an address
1109     function getShares(address _addr) public view returns(uint256){
1110         return (sharePoints[_addr]);
1111     }
1112 
1113     //gets locks of an address
1114     function getLocked(address _addr) public view returns(uint256){
1115         return userLocks[_addr].tokenAmount;
1116     }
1117 
1118     //Returns the not paid out dividends of an address in wei
1119     function getDividends(address _addr) public view returns (uint256){
1120         return _getDividendsOf(_addr) + toBePaid[_addr];
1121     }
1122 
1123     function claimNative() public nonReentrant {
1124         require(isActive,'Not active');
1125            
1126         uint256 amount = getDividends(msg.sender);
1127         require(amount!=0,"=0"); 
1128         //Substracts the amount from the dividends
1129         _updateClaimedDividends(msg.sender, amount);
1130         totalPayouts+=amount;
1131         (bool sent,) =msg.sender.call{value: (amount)}("");
1132         require(sent,"withdraw failed");
1133         emit ClaimNative(msg.sender,amount);
1134 
1135     }
1136 
1137     //adds Token to balances, adds new Native to the toBePaid mapping and resets staking
1138     function _addShares(address _addr, uint256 _amount) private {
1139         // the new amount of points
1140         uint256 newAmount = sharePoints[_addr] + _amount;
1141 
1142         // update the total points
1143         totalSharePoints+=_amount;
1144 
1145         //gets the payout before the change
1146         uint256 payment = _getDividendsOf(_addr);
1147 
1148         //resets dividends to 0 for newAmount
1149         alreadyPaidShares[_addr] = profitPerShare * newAmount;
1150         //adds dividends to the toBePaid mapping
1151         toBePaid[_addr]+=payment; 
1152         //sets newBalance
1153         sharePoints[_addr]=newAmount;
1154     }
1155 
1156     //removes shares, adds Native to the toBePaid mapping and resets staking
1157     function _removeShares(address _addr, uint256 _amount) private {
1158         //the amount of token after transfer
1159         uint256 newAmount=sharePoints[_addr] - _amount;
1160         totalSharePoints -= _amount;
1161 
1162         //gets the payout before the change
1163         uint256 payment =_getDividendsOf(_addr);
1164         //sets newBalance
1165         sharePoints[_addr]=newAmount;
1166         //resets dividendss to 0 for newAmount
1167         alreadyPaidShares[_addr] = profitPerShare * sharePoints[_addr];
1168         //adds dividendss to the toBePaid mapping
1169         toBePaid[_addr] += payment; 
1170     }
1171 
1172     //gets the dividends of an address that aren't in the toBePaid mapping 
1173     function _getDividendsOf(address _addr) private view returns (uint256) {
1174         uint256 fullPayout = profitPerShare * sharePoints[_addr];
1175         //if excluded from staking or some error return 0
1176         if(fullPayout<=alreadyPaidShares[_addr]) return 0;
1177         return (fullPayout - alreadyPaidShares[_addr])/DistributionMultiplier;
1178     }
1179 
1180     //adjust the profit share with the new amount
1181     function _updateProfitPerShare(uint256 _amount) private {
1182 
1183         totalShareRewards += _amount;
1184         if (totalSharePoints > 0) {
1185             //Increases profit per share based on current total shares
1186             profitPerShare += ((_amount * DistributionMultiplier)/totalSharePoints);
1187         }
1188     }
1189 
1190     //Substracts the amount from dividends, fails if amount exceeds dividends
1191     function _updateClaimedDividends(address _addr,uint256 _amount) private {
1192 
1193         uint256 newAmount = _getDividendsOf(_addr);
1194 
1195         //sets payout mapping to current amount
1196         alreadyPaidShares[_addr] = profitPerShare * sharePoints[_addr];
1197         //the amount to be paid 
1198         toBePaid[_addr]+=newAmount;
1199         toBePaid[_addr]-=_amount;
1200     }
1201 
1202     event OnProfitSharesReceive(address indexed sender, uint256 amount);
1203     receive() external payable {
1204 
1205         if(msg.value > 0 && totalSharePoints > 0){
1206             _updateProfitPerShare(msg.value);
1207         }
1208 
1209         emit OnProfitSharesReceive(msg.sender, msg.value);
1210     }
1211 
1212     event TeamWalletChange(address oldTeamWallet, address newTeamWallet);
1213     function setTeamWallet(address _teamWallet) public {
1214         require(msg.sender == teamWallet,'Not allowed');
1215 
1216         address prevWallet = teamWallet;
1217         teamWallet = _teamWallet;
1218 
1219         emit TeamWalletChange(prevWallet, _teamWallet);
1220     }
1221 
1222     // pull all the ETH out of the contract to the owner, needed for migrations/emergencies/EOL 
1223     // the team wallet should be set to a multi-sig wallet
1224     event AdminEthWithdraw(address account, uint256 amount);
1225     function withdrawETH() public {
1226         require(msg.sender == teamWallet,'Not allowed');
1227         uint256 amount = address(this).balance;
1228          (bool sent,) =address(owner()).call{value: (amount)}("");
1229 
1230         require(sent,"withdraw failed");
1231         emit AdminEthWithdraw(msg.sender, amount);
1232     }
1233 
1234     function onERC721Received(address operator, address, uint256, bytes calldata) external view returns(bytes4) {
1235         require(operator == address(this), "can not directly transfer");
1236         return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1237     }
1238 }