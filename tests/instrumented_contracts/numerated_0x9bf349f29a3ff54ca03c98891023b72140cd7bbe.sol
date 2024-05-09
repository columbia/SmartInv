1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
5 
6 pragma solidity ^0.8.1;
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      *
29      * [IMPORTANT]
30      * ====
31      * You shouldn't rely on `isContract` to protect against flash loan attacks!
32      *
33      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
34      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
35      * constructor.
36      * ====
37      */
38     function isContract(address account) internal view returns (bool) {
39         // This method relies on extcodesize/address.code.length, which returns 0
40         // for contracts in construction, since the code is only stored at the end
41         // of the constructor execution.
42 
43         return account.code.length > 0;
44     }
45 
46     /**
47      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
48      * `recipient`, forwarding all available gas and reverting on errors.
49      *
50      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
51      * of certain opcodes, possibly making contracts go over the 2300 gas limit
52      * imposed by `transfer`, making them unable to receive funds via
53      * `transfer`. {sendValue} removes this limitation.
54      *
55      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
56      *
57      * IMPORTANT: because control is transferred to `recipient`, care must be
58      * taken to not create reentrancy vulnerabilities. Consider using
59      * {ReentrancyGuard} or the
60      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
61      */
62     function sendValue(address payable recipient, uint256 amount) internal {
63         require(address(this).balance >= amount, "Address: insufficient balance");
64 
65         (bool success, ) = recipient.call{value: amount}("");
66         require(success, "Address: unable to send value, recipient may have reverted");
67     }
68 
69     /**
70      * @dev Performs a Solidity function call using a low level `call`. A
71      * plain `call` is an unsafe replacement for a function call: use this
72      * function instead.
73      *
74      * If `target` reverts with a revert reason, it is bubbled up by this
75      * function (like regular Solidity function calls).
76      *
77      * Returns the raw returned data. To convert to the expected return value,
78      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
79      *
80      * Requirements:
81      *
82      * - `target` must be a contract.
83      * - calling `target` with `data` must not revert.
84      *
85      * _Available since v3.1._
86      */
87     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
88         return functionCall(target, data, "Address: low-level call failed");
89     }
90 
91     /**
92      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
93      * `errorMessage` as a fallback revert reason when `target` reverts.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(
98         address target,
99         bytes memory data,
100         string memory errorMessage
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, 0, errorMessage);
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
107      * but also transferring `value` wei to `target`.
108      *
109      * Requirements:
110      *
111      * - the calling contract must have an ETH balance of at least `value`.
112      * - the called Solidity function must be `payable`.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(
117         address target,
118         bytes memory data,
119         uint256 value
120     ) internal returns (bytes memory) {
121         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
126      * with `errorMessage` as a fallback revert reason when `target` reverts.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(
131         address target,
132         bytes memory data,
133         uint256 value,
134         string memory errorMessage
135     ) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         (bool success, bytes memory returndata) = target.call{value: value}(data);
140         return verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(
160         address target,
161         bytes memory data,
162         string memory errorMessage
163     ) internal view returns (bytes memory) {
164         require(isContract(target), "Address: static call to non-contract");
165 
166         (bool success, bytes memory returndata) = target.staticcall(data);
167         return verifyCallResult(success, returndata, errorMessage);
168     }
169 
170     /**
171      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
172      * but performing a delegate call.
173      *
174      * _Available since v3.4._
175      */
176     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
177         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
178     }
179 
180     /**
181      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
182      * but performing a delegate call.
183      *
184      * _Available since v3.4._
185      */
186     function functionDelegateCall(
187         address target,
188         bytes memory data,
189         string memory errorMessage
190     ) internal returns (bytes memory) {
191         require(isContract(target), "Address: delegate call to non-contract");
192 
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     /**
198      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
199      * revert reason using the provided one.
200      *
201      * _Available since v4.3._
202      */
203     function verifyCallResult(
204         bool success,
205         bytes memory returndata,
206         string memory errorMessage
207     ) internal pure returns (bytes memory) {
208         if (success) {
209             return returndata;
210         } else {
211             // Look for revert reason and bubble it up if present
212             if (returndata.length > 0) {
213                 // The easiest way to bubble the revert reason is using memory via assembly
214                 /// @solidity memory-safe-assembly
215                 assembly {
216                     let returndata_size := mload(returndata)
217                     revert(add(32, returndata), returndata_size)
218                 }
219             } else {
220                 revert(errorMessage);
221             }
222         }
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 /**
234  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
235  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
236  *
237  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
238  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
239  * need to send a transaction, and thus is not required to hold Ether at all.
240  */
241 interface IERC20Permit {
242     /**
243      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
244      * given ``owner``'s signed approval.
245      *
246      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
247      * ordering also apply here.
248      *
249      * Emits an {Approval} event.
250      *
251      * Requirements:
252      *
253      * - `spender` cannot be the zero address.
254      * - `deadline` must be a timestamp in the future.
255      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
256      * over the EIP712-formatted function arguments.
257      * - the signature must use ``owner``'s current nonce (see {nonces}).
258      *
259      * For more information on the signature format, see the
260      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
261      * section].
262      */
263     function permit(
264         address owner,
265         address spender,
266         uint256 value,
267         uint256 deadline,
268         uint8 v,
269         bytes32 r,
270         bytes32 s
271     ) external;
272 
273     /**
274      * @dev Returns the current nonce for `owner`. This value must be
275      * included whenever a signature is generated for {permit}.
276      *
277      * Every successful call to {permit} increases ``owner``'s nonce by one. This
278      * prevents a signature from being used multiple times.
279      */
280     function nonces(address owner) external view returns (uint256);
281 
282     /**
283      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
284      */
285     // solhint-disable-next-line func-name-mixedcase
286     function DOMAIN_SEPARATOR() external view returns (bytes32);
287 }
288 
289 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
290 
291 
292 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Contract module that helps prevent reentrant calls to a function.
298  *
299  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
300  * available, which can be applied to functions to make sure there are no nested
301  * (reentrant) calls to them.
302  *
303  * Note that because there is a single `nonReentrant` guard, functions marked as
304  * `nonReentrant` may not call one another. This can be worked around by making
305  * those functions `private`, and then adding `external` `nonReentrant` entry
306  * points to them.
307  *
308  * TIP: If you would like to learn more about reentrancy and alternative ways
309  * to protect against it, check out our blog post
310  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
311  */
312 abstract contract ReentrancyGuard {
313     // Booleans are more expensive than uint256 or any type that takes up a full
314     // word because each write operation emits an extra SLOAD to first read the
315     // slot's contents, replace the bits taken up by the boolean, and then write
316     // back. This is the compiler's defense against contract upgrades and
317     // pointer aliasing, and it cannot be disabled.
318 
319     // The values being non-zero value makes deployment a bit more expensive,
320     // but in exchange the refund on every call to nonReentrant will be lower in
321     // amount. Since refunds are capped to a percentage of the total
322     // transaction's gas, it is best to keep them low in cases like this one, to
323     // increase the likelihood of the full refund coming into effect.
324     uint256 private constant _NOT_ENTERED = 1;
325     uint256 private constant _ENTERED = 2;
326 
327     uint256 private _status;
328 
329     constructor() {
330         _status = _NOT_ENTERED;
331     }
332 
333     /**
334      * @dev Prevents a contract from calling itself, directly or indirectly.
335      * Calling a `nonReentrant` function from another `nonReentrant`
336      * function is not supported. It is possible to prevent this from happening
337      * by making the `nonReentrant` function external, and making it call a
338      * `private` function that does the actual work.
339      */
340     modifier nonReentrant() {
341         _nonReentrantBefore();
342         _;
343         _nonReentrantAfter();
344     }
345 
346     function _nonReentrantBefore() private {
347         // On the first call to nonReentrant, _status will be _NOT_ENTERED
348         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
349 
350         // Any calls to nonReentrant after this point will fail
351         _status = _ENTERED;
352     }
353 
354     function _nonReentrantAfter() private {
355         // By storing the original value once again, a refund is triggered (see
356         // https://eips.ethereum.org/EIPS/eip-2200)
357         _status = _NOT_ENTERED;
358     }
359 }
360 
361 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
362 
363 
364 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
365 
366 pragma solidity ^0.8.0;
367 
368 /**
369  * @dev Interface of the ERC165 standard, as defined in the
370  * https://eips.ethereum.org/EIPS/eip-165[EIP].
371  *
372  * Implementers can declare support of contract interfaces, which can then be
373  * queried by others ({ERC165Checker}).
374  *
375  * For an implementation, see {ERC165}.
376  */
377 interface IERC165 {
378     /**
379      * @dev Returns true if this contract implements the interface defined by
380      * `interfaceId`. See the corresponding
381      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
382      * to learn more about how these ids are created.
383      *
384      * This function call must use less than 30 000 gas.
385      */
386     function supportsInterface(bytes4 interfaceId) external view returns (bool);
387 }
388 
389 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Required interface of an ERC721 compliant contract.
399  */
400 interface IERC721 is IERC165 {
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `tokenId` token must exist and be owned by `from`.
438      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
439      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
440      *
441      * Emits a {Transfer} event.
442      */
443     function safeTransferFrom(
444         address from,
445         address to,
446         uint256 tokenId,
447         bytes calldata data
448     ) external;
449 
450     /**
451      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
452      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
453      *
454      * Requirements:
455      *
456      * - `from` cannot be the zero address.
457      * - `to` cannot be the zero address.
458      * - `tokenId` token must exist and be owned by `from`.
459      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
460      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
461      *
462      * Emits a {Transfer} event.
463      */
464     function safeTransferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Transfers `tokenId` token from `from` to `to`.
472      *
473      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `tokenId` token must be owned by `from`.
480      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
481      *
482      * Emits a {Transfer} event.
483      */
484     function transferFrom(
485         address from,
486         address to,
487         uint256 tokenId
488     ) external;
489 
490     /**
491      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
492      * The approval is cleared when the token is transferred.
493      *
494      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
495      *
496      * Requirements:
497      *
498      * - The caller must own the token or be an approved operator.
499      * - `tokenId` must exist.
500      *
501      * Emits an {Approval} event.
502      */
503     function approve(address to, uint256 tokenId) external;
504 
505     /**
506      * @dev Approve or remove `operator` as an operator for the caller.
507      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
508      *
509      * Requirements:
510      *
511      * - The `operator` cannot be the caller.
512      *
513      * Emits an {ApprovalForAll} event.
514      */
515     function setApprovalForAll(address operator, bool _approved) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
528      *
529      * See {setApprovalForAll}
530      */
531     function isApprovedForAll(address owner, address operator) external view returns (bool);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
535 
536 
537 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 /**
542  * @dev Interface of the ERC20 standard as defined in the EIP.
543  */
544 interface IERC20 {
545     /**
546      * @dev Emitted when `value` tokens are moved from one account (`from`) to
547      * another (`to`).
548      *
549      * Note that `value` may be zero.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 value);
552 
553     /**
554      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
555      * a call to {approve}. `value` is the new allowance.
556      */
557     event Approval(address indexed owner, address indexed spender, uint256 value);
558 
559     /**
560      * @dev Returns the amount of tokens in existence.
561      */
562     function totalSupply() external view returns (uint256);
563 
564     /**
565      * @dev Returns the amount of tokens owned by `account`.
566      */
567     function balanceOf(address account) external view returns (uint256);
568 
569     /**
570      * @dev Moves `amount` tokens from the caller's account to `to`.
571      *
572      * Returns a boolean value indicating whether the operation succeeded.
573      *
574      * Emits a {Transfer} event.
575      */
576     function transfer(address to, uint256 amount) external returns (bool);
577 
578     /**
579      * @dev Returns the remaining number of tokens that `spender` will be
580      * allowed to spend on behalf of `owner` through {transferFrom}. This is
581      * zero by default.
582      *
583      * This value changes when {approve} or {transferFrom} are called.
584      */
585     function allowance(address owner, address spender) external view returns (uint256);
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
589      *
590      * Returns a boolean value indicating whether the operation succeeded.
591      *
592      * IMPORTANT: Beware that changing an allowance with this method brings the risk
593      * that someone may use both the old and the new allowance by unfortunate
594      * transaction ordering. One possible solution to mitigate this race
595      * condition is to first reduce the spender's allowance to 0 and set the
596      * desired value afterwards:
597      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
598      *
599      * Emits an {Approval} event.
600      */
601     function approve(address spender, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Moves `amount` tokens from `from` to `to` using the
605      * allowance mechanism. `amount` is then deducted from the caller's
606      * allowance.
607      *
608      * Returns a boolean value indicating whether the operation succeeded.
609      *
610      * Emits a {Transfer} event.
611      */
612     function transferFrom(
613         address from,
614         address to,
615         uint256 amount
616     ) external returns (bool);
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
620 
621 
622 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 
628 
629 /**
630  * @title SafeERC20
631  * @dev Wrappers around ERC20 operations that throw on failure (when the token
632  * contract returns false). Tokens that return no value (and instead revert or
633  * throw on failure) are also supported, non-reverting calls are assumed to be
634  * successful.
635  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
636  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
637  */
638 library SafeERC20 {
639     using Address for address;
640 
641     function safeTransfer(
642         IERC20 token,
643         address to,
644         uint256 value
645     ) internal {
646         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
647     }
648 
649     function safeTransferFrom(
650         IERC20 token,
651         address from,
652         address to,
653         uint256 value
654     ) internal {
655         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
656     }
657 
658     /**
659      * @dev Deprecated. This function has issues similar to the ones found in
660      * {IERC20-approve}, and its usage is discouraged.
661      *
662      * Whenever possible, use {safeIncreaseAllowance} and
663      * {safeDecreaseAllowance} instead.
664      */
665     function safeApprove(
666         IERC20 token,
667         address spender,
668         uint256 value
669     ) internal {
670         // safeApprove should only be called when setting an initial allowance,
671         // or when resetting it to zero. To increase and decrease it, use
672         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
673         require(
674             (value == 0) || (token.allowance(address(this), spender) == 0),
675             "SafeERC20: approve from non-zero to non-zero allowance"
676         );
677         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
678     }
679 
680     function safeIncreaseAllowance(
681         IERC20 token,
682         address spender,
683         uint256 value
684     ) internal {
685         uint256 newAllowance = token.allowance(address(this), spender) + value;
686         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
687     }
688 
689     function safeDecreaseAllowance(
690         IERC20 token,
691         address spender,
692         uint256 value
693     ) internal {
694         unchecked {
695             uint256 oldAllowance = token.allowance(address(this), spender);
696             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
697             uint256 newAllowance = oldAllowance - value;
698             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
699         }
700     }
701 
702     function safePermit(
703         IERC20Permit token,
704         address owner,
705         address spender,
706         uint256 value,
707         uint256 deadline,
708         uint8 v,
709         bytes32 r,
710         bytes32 s
711     ) internal {
712         uint256 nonceBefore = token.nonces(owner);
713         token.permit(owner, spender, value, deadline, v, r, s);
714         uint256 nonceAfter = token.nonces(owner);
715         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
716     }
717 
718     /**
719      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
720      * on the return value: the return value is optional (but if data is returned, it must not be false).
721      * @param token The token targeted by the call.
722      * @param data The call data (encoded using abi.encode or one of its variants).
723      */
724     function _callOptionalReturn(IERC20 token, bytes memory data) private {
725         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
726         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
727         // the target address contains contract code and also asserts for success in the low-level call.
728 
729         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
730         if (returndata.length > 0) {
731             // Return data is optional
732             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
733         }
734     }
735 }
736 
737 // File: @openzeppelin/contracts/utils/Context.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 /**
745  * @dev Provides information about the current execution context, including the
746  * sender of the transaction and its data. While these are generally available
747  * via msg.sender and msg.data, they should not be accessed in such a direct
748  * manner, since when dealing with meta-transactions the account sending and
749  * paying for execution may not be the actual sender (as far as an application
750  * is concerned).
751  *
752  * This contract is only required for intermediate, library-like contracts.
753  */
754 abstract contract Context {
755     function _msgSender() internal view virtual returns (address) {
756         return msg.sender;
757     }
758 
759     function _msgData() internal view virtual returns (bytes calldata) {
760         return msg.data;
761     }
762 }
763 
764 // File: @openzeppelin/contracts/access/Ownable.sol
765 
766 
767 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @dev Contract module which provides a basic access control mechanism, where
774  * there is an account (an owner) that can be granted exclusive access to
775  * specific functions.
776  *
777  * By default, the owner account will be the one that deploys the contract. This
778  * can later be changed with {transferOwnership}.
779  *
780  * This module is used through inheritance. It will make available the modifier
781  * `onlyOwner`, which can be applied to your functions to restrict their use to
782  * the owner.
783  */
784 abstract contract Ownable is Context {
785     address private _owner;
786 
787     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
788 
789     /**
790      * @dev Initializes the contract setting the deployer as the initial owner.
791      */
792     constructor() {
793         _transferOwnership(_msgSender());
794     }
795 
796     /**
797      * @dev Throws if called by any account other than the owner.
798      */
799     modifier onlyOwner() {
800         _checkOwner();
801         _;
802     }
803 
804     /**
805      * @dev Returns the address of the current owner.
806      */
807     function owner() public view virtual returns (address) {
808         return _owner;
809     }
810 
811     /**
812      * @dev Throws if the sender is not the owner.
813      */
814     function _checkOwner() internal view virtual {
815         require(owner() == _msgSender(), "Ownable: caller is not the owner");
816     }
817 
818     /**
819      * @dev Leaves the contract without owner. It will not be possible to call
820      * `onlyOwner` functions anymore. Can only be called by the current owner.
821      *
822      * NOTE: Renouncing ownership will leave the contract without an owner,
823      * thereby removing any functionality that is only available to the owner.
824      */
825     function renounceOwnership() public virtual onlyOwner {
826         _transferOwnership(address(0));
827     }
828 
829     /**
830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
831      * Can only be called by the current owner.
832      */
833     function transferOwnership(address newOwner) public virtual onlyOwner {
834         require(newOwner != address(0), "Ownable: new owner is the zero address");
835         _transferOwnership(newOwner);
836     }
837 
838     /**
839      * @dev Transfers ownership of the contract to a new account (`newOwner`).
840      * Internal function without access restriction.
841      */
842     function _transferOwnership(address newOwner) internal virtual {
843         address oldOwner = _owner;
844         _owner = newOwner;
845         emit OwnershipTransferred(oldOwner, newOwner);
846     }
847 }
848 
849 // File: contracts/WCAMundialStaking.sol
850 
851 //SPDX-License-Identifier: MIT
852 pragma solidity ^0.8.17;
853 
854 
855 
856 
857 
858 
859 contract WCAMundialStaking is ReentrancyGuard, Ownable {
860 	using SafeERC20 for IERC20;
861 
862 	// Interfaces for ERC721 and ERC20
863 	IERC721 public immutable nftCollection;
864 	IERC20 public immutable rewardsToken;
865 
866 	// Constructor function to set the rewards token and the NFT collection addresses
867 	constructor(IERC721 _nftCollection, IERC20 _rewardsToken) {
868 		nftCollection = _nftCollection;
869 		rewardsToken = _rewardsToken;
870 	}
871 
872 	address public manager;
873 	uint256 public startClaimTimestamp = 1685570400; // Jun 01 2023
874 	uint256 public startUnstakeTimestamp = 1671577200; // Dec 21 2022
875 	uint256 public endRewardsTimestamp = 1676761200; // Feb 19 2023
876 	// Almost 20 Token rewards per day => 0.00023149 * 10**18
877 	uint256 public rewardsPerSeconds = 231490000000000;
878 	uint256 public rewardExponent = 10**10;
879 	// Rewards have vesting of 0.13% per day => 0.00000154% per second => 1.54 * 10^-8 => 154 * 10^-10
880 	uint256 public rewardsLockSeconds = 154;
881 	bool public _stakingLive = false;
882 
883 	mapping(uint256 => uint256) public tokenIdTimeStaked;
884 	mapping(uint256 => address) public tokenIdToStaker;
885 	mapping(address => uint256[]) public stakerToTokenIds;
886 	mapping(address => uint256) public stakerRewards;
887 	mapping(address => uint256) public stakerRewardsClaimed;
888 
889 	// Modifiers
890 	modifier onlyOwnerOrManager() {
891 		require(owner() == msg.sender || manager == msg.sender, "Unauthorized");
892 		_;
893 	}
894 
895 	modifier canClaim() {
896 		require(block.timestamp >= startClaimTimestamp, "You can't already claim your rewards");
897 		_;
898 	}
899 
900 	modifier canUnstake() {
901 		require(block.timestamp >= startUnstakeTimestamp, "You can't already unstake your NFTs");
902 		_;
903 	}
904 
905 	modifier stakingIsLive() {
906 		require(_stakingLive, "Staking isn't live");
907 		_;
908 	}
909 
910 	function setManager(address _manager) external onlyOwner {
911 		manager = _manager;
912 	}
913 
914 	function setRewardsPerSecond(uint256 _rewardsPerSeconds) external onlyOwnerOrManager {
915 		rewardsPerSeconds = _rewardsPerSeconds;
916 	}
917 
918 	function setRewardExponent(uint256 _rewardExponent) external onlyOwnerOrManager {
919 		rewardExponent = _rewardExponent;
920 	}
921 
922 	function setStartClaimTimestamp(uint256 _timestamp) external onlyOwnerOrManager {
923 		require(_timestamp >= endRewardsTimestamp, "Start claim timestamp must be after end rewards timestamp");
924 		startClaimTimestamp = _timestamp;
925 	}
926 
927 	function setEndRewardsTimestamp(uint256 _timestamp) external onlyOwnerOrManager {
928 		endRewardsTimestamp = _timestamp;
929 	}
930 
931 	function setStartUnstakeTimestamp(uint256 _timestamp) external onlyOwnerOrManager {
932 		startUnstakeTimestamp = _timestamp;
933 	}
934 
935 	function toggleStakingLive() external onlyOwnerOrManager {
936 		_stakingLive = !_stakingLive;
937 	}
938 
939 	function bonus(address _address, uint256 _bonus) external onlyOwnerOrManager {
940 		stakerRewards[_address] += _bonus;
941 	}
942 
943 	function reduce(address _address, uint256 _reduce) external onlyOwnerOrManager {
944 		stakerRewards[_address] -= _reduce;
945 	}
946 
947 	function getTotalRewards(address staker) public view returns (uint256) {
948 		return getAvailableRewards(staker) + stakerRewardsClaimed[staker];
949 	}
950 
951 	function getStakedCount(address staker) external view returns (uint256) {
952 		return stakerToTokenIds[staker].length;
953 	}
954 
955 	function getStakedTokens(address staker) external view returns (uint256[] memory) {
956 		return stakerToTokenIds[staker];
957 	}
958 
959 	function stakeByIds(uint256[] calldata tokenIds) external stakingIsLive {
960 		for (uint256 i = 0; i < tokenIds.length; i++) {
961 			uint256 tokenId = tokenIds[i];
962 			require(nftCollection.ownerOf(tokenId) == msg.sender && tokenIdToStaker[tokenId] == address(0), "You don't own this token!");
963 			nftCollection.transferFrom(msg.sender, address(this), tokenId);
964 			stakerToTokenIds[msg.sender].push(tokenId);
965 			tokenIdTimeStaked[tokenId] = block.timestamp;
966 			tokenIdToStaker[tokenId] = msg.sender;
967 		}
968 	}
969 
970 	function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
971 		uint256 length = array.length;
972 		for (uint256 i = 0; i < length; i++) {
973 			if (array[i] == tokenId) {
974 				length--;
975 				if (i < length) {
976 					array[i] = array[length];
977 				}
978 				array.pop();
979 				break;
980 			}
981 		}
982 	}
983 
984 	function unstakeByIds(uint256[] calldata tokenIds) public canUnstake nonReentrant {
985 		for (uint256 i = 0; i < tokenIds.length; i++) {
986 			uint256 tokenId = tokenIds[i];
987 			require(tokenIdToStaker[tokenId] == msg.sender, "You don't own this token!");
988 			stakerRewards[msg.sender] += getRewardsByTokenId(tokenId);
989 			removeTokenIdFromArray(stakerToTokenIds[msg.sender], tokenId);
990 			tokenIdToStaker[tokenId] = address(0);
991 			nftCollection.transferFrom(address(this), msg.sender, tokenId);
992 		}
993 	}
994 
995 	function getRewardsByTokenId(uint256 _tokenId) public view returns (uint256) {
996 		uint256 timestamp = block.timestamp;
997 		if (tokenIdToStaker[_tokenId] == address(0) || tokenIdTimeStaked[_tokenId] > endRewardsTimestamp) {
998 			return 0;
999 		}
1000 		if (timestamp > endRewardsTimestamp) {
1001 			timestamp = endRewardsTimestamp;
1002 		}
1003 		return ((timestamp - tokenIdTimeStaked[_tokenId]) * rewardsPerSeconds);
1004 	}
1005 
1006 	function getAvailableRewards(address _staker) public view returns (uint256) {
1007 		uint256 tokenRewards = 0;
1008 		for (uint256 i = stakerToTokenIds[_staker].length; i > 0; i--) {
1009 			uint256 tokenId = stakerToTokenIds[msg.sender][i - 1];
1010 			tokenRewards += getRewardsByTokenId(tokenId);
1011 		}
1012 		if (tokenRewards == 0 && stakerRewards[_staker] == 0) {
1013 			return 0;
1014 		}
1015 		uint256 availableRewards = stakerRewards[_staker] + tokenRewards - stakerRewardsClaimed[_staker];
1016 		return availableRewards;
1017 	}
1018 
1019 	function getClaimableRewards(address _staker) public view returns (uint256) {
1020 		// Calculate the percentage of rewards to unlock based on the time passed since the start of the claim
1021 		if (block.timestamp < startClaimTimestamp) {
1022 			return 0;
1023 		}
1024 		uint256 totalRewards = getTotalRewards(_staker);
1025 		uint256 secondsFromClaimStart = block.timestamp - startClaimTimestamp;
1026 		uint256 rewardsToUnlock = ((totalRewards / rewardExponent) * secondsFromClaimStart * rewardsLockSeconds) - stakerRewardsClaimed[_staker];
1027 		// If the rewards to unlock are more than the total rewards, return the total rewards
1028 		if (rewardsToUnlock > totalRewards) {
1029 			return totalRewards;
1030 		}
1031 		require(rewardsToUnlock <= totalRewards, "You can't claim more than you have");
1032 		// Else return the rewards to unlock
1033 		return rewardsToUnlock;
1034 	}
1035 
1036 	function claimRewards() external canClaim nonReentrant {
1037 		uint256 rewardsToUnlock = getClaimableRewards(msg.sender);
1038 		// Require that the sender has claimed in the past
1039 		require(rewardsToUnlock > 0, "You have no rewards to claim");
1040 		stakerRewardsClaimed[msg.sender] += rewardsToUnlock;
1041 		// Send token from owner to staker
1042 		rewardsToken.transferFrom(owner(), msg.sender, rewardsToUnlock);
1043 	}
1044 }