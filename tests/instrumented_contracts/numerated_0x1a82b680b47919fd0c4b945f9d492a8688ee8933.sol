1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
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
17 interface IERC165 {
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
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
172 }
173 
174 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Contract module that helps prevent reentrant calls to a function.
183  *
184  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
185  * available, which can be applied to functions to make sure there are no nested
186  * (reentrant) calls to them.
187  *
188  * Note that because there is a single `nonReentrant` guard, functions marked as
189  * `nonReentrant` may not call one another. This can be worked around by making
190  * those functions `private`, and then adding `external` `nonReentrant` entry
191  * points to them.
192  *
193  * TIP: If you would like to learn more about reentrancy and alternative ways
194  * to protect against it, check out our blog post
195  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
196  */
197 abstract contract ReentrancyGuard {
198     // Booleans are more expensive than uint256 or any type that takes up a full
199     // word because each write operation emits an extra SLOAD to first read the
200     // slot's contents, replace the bits taken up by the boolean, and then write
201     // back. This is the compiler's defense against contract upgrades and
202     // pointer aliasing, and it cannot be disabled.
203 
204     // The values being non-zero value makes deployment a bit more expensive,
205     // but in exchange the refund on every call to nonReentrant will be lower in
206     // amount. Since refunds are capped to a percentage of the total
207     // transaction's gas, it is best to keep them low in cases like this one, to
208     // increase the likelihood of the full refund coming into effect.
209     uint256 private constant _NOT_ENTERED = 1;
210     uint256 private constant _ENTERED = 2;
211 
212     uint256 private _status;
213 
214     constructor() {
215         _status = _NOT_ENTERED;
216     }
217 
218     /**
219      * @dev Prevents a contract from calling itself, directly or indirectly.
220      * Calling a `nonReentrant` function from another `nonReentrant`
221      * function is not supported. It is possible to prevent this from happening
222      * by making the `nonReentrant` function external, and making it call a
223      * `private` function that does the actual work.
224      */
225     modifier nonReentrant() {
226         // On the first call to nonReentrant, _notEntered will be true
227         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
228 
229         // Any calls to nonReentrant after this point will fail
230         _status = _ENTERED;
231 
232         _;
233 
234         // By storing the original value once again, a refund is triggered (see
235         // https://eips.ethereum.org/EIPS/eip-2200)
236         _status = _NOT_ENTERED;
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
466 
467 
468 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @dev Interface of the ERC20 standard as defined in the EIP.
474  */
475 interface IERC20 {
476     /**
477      * @dev Emitted when `value` tokens are moved from one account (`from`) to
478      * another (`to`).
479      *
480      * Note that `value` may be zero.
481      */
482     event Transfer(address indexed from, address indexed to, uint256 value);
483 
484     /**
485      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
486      * a call to {approve}. `value` is the new allowance.
487      */
488     event Approval(address indexed owner, address indexed spender, uint256 value);
489 
490     /**
491      * @dev Returns the amount of tokens in existence.
492      */
493     function totalSupply() external view returns (uint256);
494 
495     /**
496      * @dev Returns the amount of tokens owned by `account`.
497      */
498     function balanceOf(address account) external view returns (uint256);
499 
500     /**
501      * @dev Moves `amount` tokens from the caller's account to `to`.
502      *
503      * Returns a boolean value indicating whether the operation succeeded.
504      *
505      * Emits a {Transfer} event.
506      */
507     function transfer(address to, uint256 amount) external returns (bool);
508 
509     /**
510      * @dev Returns the remaining number of tokens that `spender` will be
511      * allowed to spend on behalf of `owner` through {transferFrom}. This is
512      * zero by default.
513      *
514      * This value changes when {approve} or {transferFrom} are called.
515      */
516     function allowance(address owner, address spender) external view returns (uint256);
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
520      *
521      * Returns a boolean value indicating whether the operation succeeded.
522      *
523      * IMPORTANT: Beware that changing an allowance with this method brings the risk
524      * that someone may use both the old and the new allowance by unfortunate
525      * transaction ordering. One possible solution to mitigate this race
526      * condition is to first reduce the spender's allowance to 0 and set the
527      * desired value afterwards:
528      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
529      *
530      * Emits an {Approval} event.
531      */
532     function approve(address spender, uint256 amount) external returns (bool);
533 
534     /**
535      * @dev Moves `amount` tokens from `from` to `to` using the
536      * allowance mechanism. `amount` is then deducted from the caller's
537      * allowance.
538      *
539      * Returns a boolean value indicating whether the operation succeeded.
540      *
541      * Emits a {Transfer} event.
542      */
543     function transferFrom(
544         address from,
545         address to,
546         uint256 amount
547     ) external returns (bool);
548 }
549 
550 // File: @openzeppelin/contracts/interfaces/IERC20.sol
551 
552 
553 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
554 
555 pragma solidity ^0.8.0;
556 
557 
558 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 
567 /**
568  * @title SafeERC20
569  * @dev Wrappers around ERC20 operations that throw on failure (when the token
570  * contract returns false). Tokens that return no value (and instead revert or
571  * throw on failure) are also supported, non-reverting calls are assumed to be
572  * successful.
573  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
574  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
575  */
576 library SafeERC20 {
577     using Address for address;
578 
579     function safeTransfer(
580         IERC20 token,
581         address to,
582         uint256 value
583     ) internal {
584         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
585     }
586 
587     function safeTransferFrom(
588         IERC20 token,
589         address from,
590         address to,
591         uint256 value
592     ) internal {
593         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
594     }
595 
596     /**
597      * @dev Deprecated. This function has issues similar to the ones found in
598      * {IERC20-approve}, and its usage is discouraged.
599      *
600      * Whenever possible, use {safeIncreaseAllowance} and
601      * {safeDecreaseAllowance} instead.
602      */
603     function safeApprove(
604         IERC20 token,
605         address spender,
606         uint256 value
607     ) internal {
608         // safeApprove should only be called when setting an initial allowance,
609         // or when resetting it to zero. To increase and decrease it, use
610         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
611         require(
612             (value == 0) || (token.allowance(address(this), spender) == 0),
613             "SafeERC20: approve from non-zero to non-zero allowance"
614         );
615         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
616     }
617 
618     function safeIncreaseAllowance(
619         IERC20 token,
620         address spender,
621         uint256 value
622     ) internal {
623         uint256 newAllowance = token.allowance(address(this), spender) + value;
624         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
625     }
626 
627     function safeDecreaseAllowance(
628         IERC20 token,
629         address spender,
630         uint256 value
631     ) internal {
632         unchecked {
633             uint256 oldAllowance = token.allowance(address(this), spender);
634             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
635             uint256 newAllowance = oldAllowance - value;
636             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
637         }
638     }
639 
640     /**
641      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
642      * on the return value: the return value is optional (but if data is returned, it must not be false).
643      * @param token The token targeted by the call.
644      * @param data The call data (encoded using abi.encode or one of its variants).
645      */
646     function _callOptionalReturn(IERC20 token, bytes memory data) private {
647         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
648         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
649         // the target address contains contract code and also asserts for success in the low-level call.
650 
651         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
652         if (returndata.length > 0) {
653             // Return data is optional
654             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
655         }
656     }
657 }
658 
659 // File: contracts/veRewards.sol
660 
661 
662 pragma solidity ^0.8.13;
663 
664 
665 
666 
667 
668 interface IERC4626 is IERC20 {
669     // The address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
670     function asset() external view returns(address assetTokenAddress);
671 
672     // Total amount of the underlying asset that is “managed” by Vault.
673     function totalAssets() external view returns(uint256 totalManagedAssets);
674 
675     // The amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario where all the conditions are met.
676     function convertToShares(uint256 assets) external view returns(uint256 shares); 
677 
678     // The amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario where all the conditions are met.
679     function convertToAssets(uint256 shares) external view returns(uint256 assets);
680  
681     // Maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call.
682     function maxDeposit(address receiver) external view returns(uint256 maxAssets);
683 
684     // Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
685     function previewDeposit(uint256 assets) external view returns(uint256 shares);
686 
687     // Mints shares Vault shares to receiver by depositing exactly amount of underlying tokens.
688     function deposit(uint256 assets, address receiver) external returns(uint256 shares);
689 
690     // Maximum amount of shares that can be minted from the Vault for the receiver, through a mint call.
691     function maxMint(address receiver) external view returns(uint256 maxShares); 
692 
693     // Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
694     function previewMint(uint256 shares) external view returns(uint256 assets);
695 
696     // Mints exactly shares Vault shares to receiver by depositing amount of underlying tokens.
697     function mint(uint256 shares, address receiver) external returns(uint256 assets);
698 
699     // Maximum amount of the underlying asset that can be withdrawn from the owner balance in the Vault, through a withdraw call.
700     function maxWithdraw(address owner) external view returns(uint256 maxAssets);
701 
702     // Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
703     function previewWithdraw(uint256 assets) external view returns(uint256 shares);
704 
705     // Burns shares from owner and sends exactly assets of underlying tokens to receiver.
706     function withdraw(uint256 assets, address receiver, address owner) external returns(uint256 shares);
707 
708     // Maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
709     function maxRedeem(address owner) external view returns(uint256 maxShares);
710 
711     // Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
712     function previewRedeem(uint256 shares) external view returns(uint256 assets);
713 
714     // Burns exactly shares from owner and sends assets of underlying tokens to receiver.
715     function redeem(uint256 shares, address receiver, address owner) external returns(uint256 assets);
716 
717     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
718     event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
719 }
720 
721 interface IVeVault is IERC4626 {
722     function asset() external view  returns (address assetTokenAddress);
723     function totalAssets() external view  returns (uint256 totalManagedAssets);
724     function totalSupply() external view  returns (uint256);
725     function balanceOf(address account) external view  returns (uint256);
726     function convertToShares(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
727     function convertToShares(uint256 assets)  external view returns (uint256 shares);
728     function convertToAssets(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
729     function convertToAssets(uint256 shares)  external view returns (uint256 assets);
730     function maxDeposit(address)  external pure returns (uint256 maxAssets);
731     function previewDeposit(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
732     function previewDeposit(uint256 assets)  external view returns (uint256 shares);
733     function maxMint(address)  external pure returns (uint256 maxShares);
734     function previewMint(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
735     function previewMint(uint256 shares)  external view returns (uint256 assets);
736     function maxWithdraw(address owner)  external view returns (uint256 maxAssets);
737     function previewWithdraw(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
738     function previewWithdraw(uint256 assets)  external view returns (uint256 shares);
739     function maxRedeem(address owner)  external view returns (uint256 maxShares);
740     function previewRedeem(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
741     function previewRedeem(uint256 shares)  external view returns (uint256 assets);
742     function allowance(address, address)  external view returns (uint256);
743     function assetBalanceOf(address account) external view returns (uint256);
744     function unlockDate(address account) external view returns (uint256);
745     function gracePeriod() external view returns (uint256);
746     function penaltyPercentage() external view returns (uint256);
747     function minLockTime() external view returns (uint256);
748     function maxLockTime() external view returns (uint256);
749     function transfer(address, uint256) external  returns (bool);
750     function approve(address, uint256) external  returns (bool);
751     function transferFrom(address, address, uint256) external  returns (bool);
752     function veMult(address owner) external view returns (uint256);
753     function deposit(uint256 assets, address receiver, uint256 lockTime) external returns (uint256 shares);
754     function deposit(uint256 assets, address receiver)  external returns (uint256 shares);
755     function mint(uint256 shares, address receiver, uint256 lockTime) external returns (uint256 assets);
756     function mint(uint256 shares, address receiver)  external returns (uint256 assets);
757     function withdraw(uint256 assets, address receiver, address owner)  external returns (uint256 shares);
758     function redeem(uint256 shares, address receiver, address owner)  external returns (uint256 assets);
759     function exit() external returns (uint256 shares);
760     function changeUnlockRule(bool flag) external;
761     function changeGracePeriod(uint256 newGracePeriod) external;
762     function changeEpoch(uint256 newEpoch) external;
763     function changeMinPenalty(uint256 newMinPenalty) external;
764     function changeMaxPenalty(uint256 newMaxPenalty) external;
765     function changeWhitelistRecoverERC20(address tokenAddress, bool flag) external;
766     function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
767     function recoverERC721(address tokenAddress, uint256 tokenId) external;
768 
769     event PayPenalty(address indexed caller, address indexed owner, uint256 assets);
770     event Burn(address indexed user, uint256 shares);
771     event Mint(address indexed user, uint256 shares);
772     event Recovered(address token, uint256 amount);
773     event RecoveredNFT(address tokenAddress, uint256 tokenId);
774     event ChangeWhitelistERC20(address indexed tokenAddress, bool whitelistState);
775 }
776 
777 // https://docs.synthetix.io/contracts/source/contracts/Owned
778 abstract contract Owned {
779     address public owner;
780     address public nominatedOwner;
781 
782     constructor(address _owner) {
783         require(_owner != address(0), "Owner address cannot be 0");
784         owner = _owner;
785         emit OwnerChanged(address(0), _owner);
786     }
787 
788     function nominateNewOwner(address _owner) external onlyOwner {
789         nominatedOwner = _owner;
790         emit OwnerNominated(_owner);
791     }
792 
793     function acceptOwnership() external {
794         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
795         emit OwnerChanged(owner, nominatedOwner);
796         owner = nominatedOwner;
797         nominatedOwner = address(0);
798     }
799 
800     modifier onlyOwner {
801         _onlyOwner();
802         _;
803     }
804 
805     function _onlyOwner() private view {
806         require(msg.sender == owner, "Only the contract owner may perform this action");
807     }
808 
809     event OwnerNominated(address newOwner);
810     event OwnerChanged(address oldOwner, address newOwner);
811 }
812 
813 // https://docs.synthetix.io/contracts/source/contracts/Pausable
814 abstract contract Pausable is Owned {
815     uint public lastPauseTime;
816     bool public paused;
817 
818     constructor() {
819         // This contract is abstract, and thus cannot be instantiated directly
820         require(owner != address(0), "Owner must be set");
821         // Paused will be false, and lastPauseTime will be 0 upon initialisation
822     }
823 
824     /**
825      * @notice Change the paused state of the contract
826      * @dev Only the contract owner may call this.
827      */
828     function setPaused(bool _paused) external onlyOwner {
829         // Ensure we're actually changing the state before we do anything
830         if (_paused == paused) {
831             return;
832         }
833 
834         // Set our paused state.
835         paused = _paused;
836 
837         // If applicable, set the last pause time.
838         if (paused) {
839             lastPauseTime = block.timestamp;
840         }
841 
842         // Let everyone know that our pause state has changed.
843         emit PauseChanged(paused);
844     }
845 
846     event PauseChanged(bool isPaused);
847 
848     modifier notPaused {
849         require(!paused, "This action cannot be performed while the contract is paused");
850         _;
851     }
852 }
853 
854 // https://docs.synthetix.io/contracts/source/contracts/RewardsDistributionRecipient
855 abstract contract RewardsDistributionRecipient is Owned {
856     address public rewardsDistribution;
857 
858     function notifyRewardAmount(uint256 reward) virtual external;
859 
860     modifier onlyRewardsDistribution() {
861         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
862         _;
863     }
864 
865     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
866         rewardsDistribution = _rewardsDistribution;
867     }
868 }
869 
870 error RewardTooHigh();
871 error RewardPeriodNotComplete(uint256 finish);
872 error NotWhitelisted();
873 error InsufficientBalance(uint256 available, uint256 required);
874 
875 /** 
876  * @title Implements a reward system which grant rewards based on veToken balance 
877  * @author gcontarini jocorrei
878  * @notice This implementation was inspired by the StakingReward contract from Synthetixio
879  * @dev Implement a new constructor to deploy this contract 
880  */
881 contract Rewards is RewardsDistributionRecipient, ReentrancyGuard, Pausable {
882     using SafeERC20 for IERC20;
883 
884     struct Account {
885         uint256 rewardPerTokenPaid;
886         uint256 rewards;
887         uint256 dueDate;
888     }
889 
890     /* ========== STATE VARIABLES ========== */
891 
892     address public rewardsToken;
893     address public vault;                    // address of the ve vault
894     uint256 public periodFinish = 0;         // end of the rewardDuration period
895     uint256 public rewardRate = 0;           // rewards per second distributed by the contract ==> rewardavailable / rewardDuration
896     uint256 public rewardsDuration = 7 days; // the rewards inside the contract are gone be distributed during this period
897     uint256 public lastUpdateTime;           // when the reward period started
898     uint256 public rewardPerTokenStored;     // amounts of reward per staked token
899 
900     mapping(address => Account) public accounts;
901     
902     // Only allow recoverERC20 from this list
903     mapping(address => bool) public whitelistRecoverERC20;
904 
905     /* ========== CONSTRUCTOR ========== */
906 
907     constructor(
908         address _owner,
909         address _vault,
910         address _rewardsDistribution,
911         address _rewardsToken
912     ) Owned(_owner) {
913         rewardsToken = _rewardsToken;
914         rewardsDistribution = _rewardsDistribution;
915         vault = _vault;
916         lastUpdateTime = block.timestamp;
917     }
918 
919     /* ========== VIEWS ========== */
920 
921     /**
922      * @notice Get the vault address
923      */
924     function getVaultAddress() public view returns (address) {
925         return vault;
926     }
927 
928     /**
929      * @notice Pick the correct date for applying the reward
930      * Apply until the end of periodFinish or until
931      * unlockDate for funds in the veVault
932      * @return date which the reward is applicable for and address
933      */
934     function lastTimeRewardApplicable(address owner) public view returns (uint256) {
935         if (owner != address(0) && accounts[owner].dueDate < periodFinish) {
936             return block.timestamp < accounts[owner].dueDate ? block.timestamp : accounts[owner].dueDate;
937         }
938         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
939     }
940 
941     /**
942      * @notice Calculate how much reward must be given for an user
943      * per token in veVault. 
944      * @dev If dueDate is less than the period finish,
945      * a "negative" reward is applied to ensure that
946      * rewards are applied only until this date.
947      * @return amount of reward per token an addres is elegible to receive so far
948      */
949     function rewardPerToken(address owner) public view returns (uint256) {
950         uint256 _totalSupply = IVeVault(vault).totalSupply();
951 
952         if (_totalSupply == 0) {
953             return rewardPerTokenStored;
954         }
955         uint256 userLastTime = lastTimeRewardApplicable(owner);
956         
957         // Apply a negative reward per token when
958         // due date is already over.
959         if (userLastTime < lastUpdateTime) {
960             return rewardPerTokenStored
961                 - ((lastUpdateTime - userLastTime)
962                     * rewardRate
963                     * 1e18
964                     / _totalSupply
965                 );
966         }
967         return rewardPerTokenStored
968                 + ((userLastTime - lastUpdateTime)
969                     * rewardRate
970                     * 1e18
971                     / _totalSupply
972                 );
973     }
974     
975     /**
976      * @notice Calculates how much rewards a staker earned 
977      * until this moment.
978      * @dev Only apply reward until period finish or unlock date.
979      * @return amount of reward available to claim 
980      */
981     function earned(address owner) public view returns (uint256) {
982         uint256 currentReward = rewardPerToken(owner);
983         uint256 paidReward = accounts[owner].rewardPerTokenPaid;
984 
985         uint256 moreReward = 0;
986         if (currentReward > paidReward) {
987             moreReward = IVeVault(vault).balanceOf(owner)
988                             * (currentReward - paidReward)
989                             / 1e18;
990         }
991         return accounts[owner].rewards + moreReward;
992     }
993 
994     /**
995      * @notice Total rewards that will be paid during the distribution
996      */
997     function getRewardForDuration() external view returns (uint256) {
998         return rewardRate * rewardsDuration;
999     }
1000 
1001     /* ========== MUTATIVE FUNCTIONS ========== */
1002 
1003     /**
1004      * @notice Notify the reward contract about a deposit in the
1005      * veVault contract. This is important to assure the
1006      * contract will account user's rewards.
1007      * @return account full information
1008      */
1009     function notifyDeposit() public updateReward(msg.sender) returns(Account memory) {
1010         emit NotifyDeposit(msg.sender, accounts[owner].rewardPerTokenPaid, accounts[owner].dueDate);
1011         return accounts[owner];
1012     }
1013 
1014     /**
1015      * @notice Claim rewards for user.
1016      * @dev In case of no rewards claimable
1017      * just update the user status and do nothing.
1018      */
1019     function getReward() public updateReward(msg.sender) {
1020         uint256 reward = accounts[msg.sender].rewards;
1021         if (reward <= 0) return;
1022         
1023         accounts[msg.sender].rewards = 0;
1024         IERC20(rewardsToken).safeTransfer(msg.sender, reward);
1025         emit RewardPaid(msg.sender, reward);
1026     }
1027 
1028     /* ========== RESTRICTED FUNCTIONS ========== */
1029 
1030     /**
1031      * @notice Set the contract to start distribuiting rewards
1032      * for ve holders.
1033      * @param reward: amount of tokens to be distributed
1034      */
1035     function notifyRewardAmount(uint256 reward)
1036             external
1037             override 
1038             onlyRewardsDistribution 
1039             updateReward(address(0)) {
1040         if (block.timestamp >= periodFinish) {
1041             rewardRate = reward / rewardsDuration;
1042         } else {
1043             uint256 remaining = periodFinish - block.timestamp;
1044             uint256 leftover = remaining * rewardRate;
1045             rewardRate = (reward + leftover) / rewardsDuration;
1046         }
1047 
1048         // Ensure the provided reward amount is not more than the balance in the contract.
1049         // This keeps the reward rate in the right range, preventing overflows due to
1050         // very high values of rewardRate in the earned and rewardsPerToken functions;
1051         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1052         uint balance = IERC20(rewardsToken).balanceOf(address(this));
1053         if (rewardRate > balance / rewardsDuration) revert RewardTooHigh();
1054 
1055         lastUpdateTime = block.timestamp;
1056         periodFinish = block.timestamp + rewardsDuration;
1057         emit RewardAdded(reward);
1058     }
1059     
1060     /**
1061      * @notice Allow owner to change reward duration
1062      * Only allow the change if period finish has already ended
1063      */
1064     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1065         if (block.timestamp <= periodFinish) revert RewardPeriodNotComplete(periodFinish);
1066 
1067         rewardsDuration = _rewardsDuration;
1068         emit RewardsDurationUpdated(rewardsDuration);
1069     }
1070 
1071     /**
1072      * @notice Added to support to recover ERC20 token within a whitelist 
1073      */
1074     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1075         if (whitelistRecoverERC20[tokenAddress] == false) revert NotWhitelisted();
1076         
1077         uint balance = IERC20(tokenAddress).balanceOf(address(this));
1078         if (balance < tokenAmount) revert InsufficientBalance({
1079                 available: balance,
1080                 required: tokenAmount
1081         });
1082         
1083         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1084         emit Recovered(tokenAddress, tokenAmount);
1085     }
1086 
1087     /**
1088      * @dev It's possible to owner whitelist the underlying token
1089      * and do some kind of rugpull. To prevent that, it'recommended
1090      * that owner is a multisig address. Also, it emits an event
1091      * of changes in the ERC20 whitelist as a safety check.
1092      * @notice Owner can whitelist an ERC20 to recover it afterwards.
1093      * Emits and event to notify all users about it 
1094      * @param flag: true to allow recover for the token
1095      */
1096     function changeWhitelistRecoverERC20(address tokenAddress, bool flag) external onlyOwner {
1097         whitelistRecoverERC20[tokenAddress] = flag;
1098         emit ChangeWhitelistERC20(tokenAddress, flag);
1099     }
1100 
1101     /**
1102      * @notice Added to support to recover ERC721 
1103      */
1104     function recoverERC721(address tokenAddress, uint256 tokenId) external onlyOwner {
1105         IERC721(tokenAddress).safeTransferFrom(address(this), owner, tokenId);
1106         emit RecoveredNFT(tokenAddress, tokenId);
1107     }
1108 
1109     /* ========== MODIFIERS ========== */
1110 
1111     /**
1112      * @dev Update user rewards accordlingly to
1113      * the current timestamp.
1114      */
1115     modifier updateReward(address owner) {
1116         rewardPerTokenStored = rewardPerToken(address(0));
1117         lastUpdateTime = lastTimeRewardApplicable(address(0));
1118 
1119         if (owner != address(0)) {
1120             if (accounts[owner].rewardPerTokenPaid == 0)
1121                 accounts[owner].rewardPerTokenPaid = rewardPerTokenStored;
1122             accounts[owner].dueDate = IVeVault(vault).unlockDate(owner);
1123             accounts[owner].rewards = earned(owner);
1124             accounts[owner].rewardPerTokenPaid = rewardPerToken(address(0));
1125         }
1126         _;
1127     }
1128 
1129     /* ========== EVENTS ========== */
1130 
1131     event RewardAdded(uint256 reward);
1132     event RewardPaid(address indexed user, uint256 reward);
1133     event RewardsDurationUpdated(uint256 newDuration);
1134     event NotifyDeposit(address indexed user, uint256 rewardPerTokenPaid, uint256 dueDate);
1135     event Recovered(address token, uint256 amount);
1136     event RecoveredNFT(address tokenAddress, uint256 tokenId);
1137     event ChangeWhitelistERC20(address indexed tokenAddress, bool whitelistState);
1138 }