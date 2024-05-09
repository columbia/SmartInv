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
659 // File: contracts/veLPvault.sol
660 
661 
662 pragma solidity ^0.8.13;
663 
664 
665 
666 
667 
668 
669 // https://docs.synthetix.io/contracts/source/contracts/Owned
670 abstract contract Owned {
671     address public owner;
672     address public nominatedOwner;
673 
674     constructor(address _owner) {
675         require(_owner != address(0), "Owner address cannot be 0");
676         owner = _owner;
677         emit OwnerChanged(address(0), _owner);
678     }
679 
680     function nominateNewOwner(address _owner) external onlyOwner {
681         nominatedOwner = _owner;
682         emit OwnerNominated(_owner);
683     }
684 
685     function acceptOwnership() external {
686         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
687         emit OwnerChanged(owner, nominatedOwner);
688         owner = nominatedOwner;
689         nominatedOwner = address(0);
690     }
691 
692     modifier onlyOwner {
693         _onlyOwner();
694         _;
695     }
696 
697     function _onlyOwner() private view {
698         require(msg.sender == owner, "Only the contract owner may perform this action");
699     }
700 
701     event OwnerNominated(address newOwner);
702     event OwnerChanged(address oldOwner, address newOwner);
703 }
704 
705 // https://docs.synthetix.io/contracts/source/contracts/Pausable
706 abstract contract Pausable is Owned {
707     uint public lastPauseTime;
708     bool public paused;
709 
710     constructor() {
711         // This contract is abstract, and thus cannot be instantiated directly
712         require(owner != address(0), "Owner must be set");
713         // Paused will be false, and lastPauseTime will be 0 upon initialisation
714     }
715 
716     /**
717      * @notice Change the paused state of the contract
718      * @dev Only the contract owner may call this.
719      */
720     function setPaused(bool _paused) external onlyOwner {
721         // Ensure we're actually changing the state before we do anything
722         if (_paused == paused) {
723             return;
724         }
725 
726         // Set our paused state.
727         paused = _paused;
728 
729         // If applicable, set the last pause time.
730         if (paused) {
731             lastPauseTime = block.timestamp;
732         }
733 
734         // Let everyone know that our pause state has changed.
735         emit PauseChanged(paused);
736     }
737 
738     event PauseChanged(bool isPaused);
739 
740     modifier notPaused {
741         require(!paused, "This action cannot be performed while the contract is paused");
742         _;
743     }
744 }
745 
746 
747 // https://docs.synthetix.io/contracts/source/contracts/RewardsDistributionRecipient
748 abstract contract RewardsDistributionRecipient is Owned {
749     address public rewardsDistribution;
750 
751     function notifyRewardAmount(uint256 reward) virtual external;
752 
753     modifier onlyRewardsDistribution() {
754         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
755         _;
756     }
757 
758     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
759         rewardsDistribution = _rewardsDistribution;
760     }
761 }
762 
763 interface IUniswapV2Pair {
764     event Approval(address indexed owner, address indexed spender, uint value);
765     event Transfer(address indexed from, address indexed to, uint value);
766 
767     function name() external pure returns (string memory);
768     function symbol() external pure returns (string memory);
769     function decimals() external pure returns (uint8);
770     function totalSupply() external view returns (uint);
771     function balanceOf(address owner) external view returns (uint);
772     function allowance(address owner, address spender) external view returns (uint);
773 
774     function approve(address spender, uint value) external returns (bool);
775     function transfer(address to, uint value) external returns (bool);
776     function transferFrom(address from, address to, uint value) external returns (bool);
777 
778     function DOMAIN_SEPARATOR() external view returns (bytes32);
779     function PERMIT_TYPEHASH() external pure returns (bytes32);
780     function nonces(address owner) external view returns (uint);
781 
782     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
783 
784     event Mint(address indexed sender, uint amount0, uint amount1);
785     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
786     event Swap(
787         address indexed sender,
788         uint amount0In,
789         uint amount1In,
790         uint amount0Out,
791         uint amount1Out,
792         address indexed to
793     );
794     event Sync(uint112 reserve0, uint112 reserve1);
795 
796     function MINIMUM_LIQUIDITY() external pure returns (uint);
797     function factory() external view returns (address);
798     function token0() external view returns (address);
799     function token1() external view returns (address);
800     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
801     function price0CumulativeLast() external view returns (uint);
802     function price1CumulativeLast() external view returns (uint);
803     function kLast() external view returns (uint);
804 
805     function mint(address to) external returns (uint liquidity);
806     function burn(address to) external returns (uint amount0, uint amount1);
807     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
808     function skim(address to) external;
809     function sync() external;
810 
811     function initialize(address, address) external;
812 }
813 
814 
815 interface IERC4626 is IERC20 {
816     // The address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
817     function asset() external view returns(address assetTokenAddress);
818 
819     // Total amount of the underlying asset that is “managed” by Vault.
820     function totalAssets() external view returns(uint256 totalManagedAssets);
821 
822     // The amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario where all the conditions are met.
823     function convertToShares(uint256 assets) external view returns(uint256 shares); 
824 
825     // The amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario where all the conditions are met.
826     function convertToAssets(uint256 shares) external view returns(uint256 assets);
827  
828     // Maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call.
829     function maxDeposit(address receiver) external view returns(uint256 maxAssets);
830 
831     // Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
832     function previewDeposit(uint256 assets) external view returns(uint256 shares);
833 
834     // Mints shares Vault shares to receiver by depositing exactly amount of underlying tokens.
835     function deposit(uint256 assets, address receiver) external returns(uint256 shares);
836 
837     // Maximum amount of shares that can be minted from the Vault for the receiver, through a mint call.
838     function maxMint(address receiver) external view returns(uint256 maxShares); 
839 
840     // Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
841     function previewMint(uint256 shares) external view returns(uint256 assets);
842 
843     // Mints exactly shares Vault shares to receiver by depositing amount of underlying tokens.
844     function mint(uint256 shares, address receiver) external returns(uint256 assets);
845 
846     // Maximum amount of the underlying asset that can be withdrawn from the owner balance in the Vault, through a withdraw call.
847     function maxWithdraw(address owner) external view returns(uint256 maxAssets);
848 
849     // Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
850     function previewWithdraw(uint256 assets) external view returns(uint256 shares);
851 
852     // Burns shares from owner and sends exactly assets of underlying tokens to receiver.
853     function withdraw(uint256 assets, address receiver, address owner) external returns(uint256 shares);
854 
855     // Maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
856     function maxRedeem(address owner) external view returns(uint256 maxShares);
857 
858     // Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
859     function previewRedeem(uint256 shares) external view returns(uint256 assets);
860 
861     // Burns exactly shares from owner and sends assets of underlying tokens to receiver.
862     function redeem(uint256 shares, address receiver, address owner) external returns(uint256 assets);
863 
864     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
865     event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
866 }
867 interface IVeVault is IERC4626 {
868     function asset() external view  returns (address assetTokenAddress);
869     function totalAssets() external view  returns (uint256 totalManagedAssets);
870     function totalSupply() external view  returns (uint256);
871     function balanceOf(address account) external view  returns (uint256);
872     function convertToShares(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
873     function convertToShares(uint256 assets)  external view returns (uint256 shares);
874     function convertToAssets(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
875     function convertToAssets(uint256 shares)  external view returns (uint256 assets);
876     function maxDeposit(address)  external pure returns (uint256 maxAssets);
877     function previewDeposit(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
878     function previewDeposit(uint256 assets)  external view returns (uint256 shares);
879     function maxMint(address)  external pure returns (uint256 maxShares);
880     function previewMint(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
881     function previewMint(uint256 shares)  external view returns (uint256 assets);
882     function maxWithdraw(address owner)  external view returns (uint256 maxAssets);
883     function previewWithdraw(uint256 assets, uint256 lockTime) external view returns (uint256 shares);
884     function previewWithdraw(uint256 assets)  external view returns (uint256 shares);
885     function maxRedeem(address owner)  external view returns (uint256 maxShares);
886     function previewRedeem(uint256 shares, uint256 lockTime) external view returns (uint256 assets);
887     function previewRedeem(uint256 shares)  external view returns (uint256 assets);
888     function allowance(address, address)  external view returns (uint256);
889     function assetBalanceOf(address account) external view returns (uint256);
890     function unlockDate(address account) external view returns (uint256);
891     function gracePeriod() external view returns (uint256);
892     function penaltyPercentage() external view returns (uint256);
893     function minLockTime() external view returns (uint256);
894     function maxLockTime() external view returns (uint256);
895     function transfer(address, uint256) external  returns (bool);
896     function approve(address, uint256) external  returns (bool);
897     function transferFrom(address, address, uint256) external  returns (bool);
898     function veMult(address owner) external view returns (uint256);
899     function deposit(uint256 assets, address receiver, uint256 lockTime) external returns (uint256 shares);
900     function deposit(uint256 assets, address receiver)  external returns (uint256 shares);
901     function mint(uint256 shares, address receiver, uint256 lockTime) external returns (uint256 assets);
902     function mint(uint256 shares, address receiver)  external returns (uint256 assets);
903     function withdraw(uint256 assets, address receiver, address owner)  external returns (uint256 shares);
904     function redeem(uint256 shares, address receiver, address owner)  external returns (uint256 assets);
905     function exit() external returns (uint256 shares);
906     function changeUnlockRule(bool flag) external;
907     function changeGracePeriod(uint256 newGracePeriod) external;
908     function changeEpoch(uint256 newEpoch) external;
909     function changeMinPenalty(uint256 newMinPenalty) external;
910     function changeMaxPenalty(uint256 newMaxPenalty) external;
911     function changeWhitelistRecoverERC20(address tokenAddress, bool flag) external;
912     function recoverERC20(address tokenAddress, uint256 tokenAmount) external;
913     function recoverERC721(address tokenAddress, uint256 tokenId) external;
914 
915     event PayPenalty(address indexed caller, address indexed owner, uint256 assets);
916     event Burn(address indexed user, uint256 shares);
917     event Mint(address indexed user, uint256 shares);
918     event Recovered(address token, uint256 amount);
919     event RecoveredNFT(address tokenAddress, uint256 tokenId);
920     event ChangeWhitelistERC20(address indexed tokenAddress, bool whitelistState);
921 }
922 
923 
924 // Custom errors
925 error Unauthorized();
926 error UnauthorizedClaim();
927 error NotImplemented();
928 error RewardTooHigh(uint256 allowed, uint256 reward);
929 error NotWhitelisted();
930 error InsufficientBalance();
931 
932 /** 
933  * @title Implements a reward system which grants rewards based on LP
934  * staked in this contract and grants boosts based on depositor veToken balance
935  * @author gcontarini jocorrei
936  * @dev This implementation tries to follow the ERC4626 standard
937  * Implement a new constructor to deploy this contract 
938  */
939 abstract contract LpRewards is ReentrancyGuard, Pausable, RewardsDistributionRecipient, IERC4626 {
940     using SafeERC20 for IERC20;
941 
942     struct Account {
943         uint256 rewards;
944         uint256 assets;
945         uint256 shares;
946         uint256 sharesBoost;
947         uint256 rewardPerTokenPaid;
948     }
949 
950     struct Total {
951         uint256 managedAssets;
952         uint256 supply;
953     }
954     
955     /* ========= STATE VARIABLES ========= */
956 
957     // veVault
958     address public veVault;
959     // Reward token
960     address public rewardsToken;
961     // Asset token (LP token)
962     address public assetToken;
963 
964     // Contract totals
965     Total public total;
966     // User info
967     mapping(address => Account) internal accounts;
968 
969     // Reward per token
970     uint256 public rewardPerTokenStored;
971     uint256 public rewardRate = 0;
972 
973     // Epochs
974     uint256 public periodFinish = 0;
975     uint256 public rewardsDuration = 7 days;
976     uint256 public lastUpdateTime;
977 
978     // Math precision
979     uint256 internal constant PRECISION = 1e18; 
980     
981     // ERC20 metadata (The share token)
982     string public _name;
983     string public _symbol;
984 
985     // Only allow recoverERC20 from this list
986     mapping(address => bool) public whitelistRecoverERC20;
987 
988     /* ============ CONSTRUCTOR ============== */
989 
990     constructor(string memory name_, string memory symbol_) {
991         _name = name_;
992         _symbol = symbol_;
993     }
994 
995     /* ============ VIEWS (IERC4626) =================== */
996     
997     /**
998      * @notice Address of asset token
999      */
1000     function asset() override external view returns (address assetTokenAddress) {
1001         return assetToken;
1002     }
1003     
1004     /**
1005      * @notice Total of LP tokens hold by the contract
1006      */
1007     function totalAssets() override external view returns (uint256 totalManagedAssets) {
1008         return total.managedAssets;
1009     }
1010 
1011     /**
1012      * @notice Total of shares minted by the contract
1013      * This value is important to calculate the percentage
1014      * of reward for each staker
1015      */
1016     function totalSupply() override external view returns (uint256) {
1017         return total.supply;
1018     }
1019 
1020     /**
1021      * @notice Amount of shares an address has
1022      */
1023     function balanceOf(address owner) override external view returns (uint256) {
1024         return accounts[owner].shares;
1025     }
1026 
1027     /**
1028      * @notice Amount of LP staked by an address
1029      */
1030     function assetBalanceOf(address owner) external view returns (uint256) {
1031         return accounts[owner].assets;
1032     }
1033 
1034     /** 
1035      * @notice Maximum amount of the underlying asset that can
1036      * be deposited into the Vault for the receiver, through a deposit call.
1037      * @dev Compliant to the ERC4626 interface.
1038      */
1039     function maxDeposit(address) override external pure returns (uint256 maxAssets) {
1040         return 2 ** 256 - 1;
1041     }
1042 
1043     /**
1044      * @notice Maximum amount of shares that can be minted from the
1045      * Vault for the receiver, through a mint call.
1046      * @dev Compliant to the ERC4626 interface.
1047      */
1048     function maxMint(address) override external pure returns (uint256 maxShares) {
1049         return 2 ** 256 - 1;
1050     }
1051 
1052     /**
1053      * @notice Maximum amount of the underlying asset that can be withdrawn from the
1054      * owner balance in the Vault, through a withdraw call.
1055      * @dev Compliant to the ERC4626 interface.
1056      */
1057     function maxWithdraw(address owner) override external view returns (uint256 maxAssets) {
1058         if (paused) {
1059             return 0;
1060         }
1061         return accounts[owner].assets;
1062     }
1063 
1064     /**
1065      * @notice Maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
1066      * @dev Compliant to the ERC4626 interface.
1067      */
1068     function maxRedeem(address owner) override external view returns (uint256 maxShares) {
1069         if (paused) {
1070             return 0;
1071         }
1072         // Since assets and (shares - sharesBoost) have an 1:1 ratio
1073         return accounts[owner].assets;
1074     }
1075 
1076     /** 
1077      * @notice The amount of shares that the Vault would exchange 
1078      * for the amount of assets provided, in an ideal scenario where
1079      * all the conditions are met.
1080      * @dev Compliant to the ERC4626 interface.
1081      */
1082     function convertToShares(uint256 assets) override external view returns (uint256 shares) {
1083         return assets * getMultiplier(msg.sender) / PRECISION;
1084     }
1085 
1086     /**
1087      * @notice The amount of assets that the Vault would exchange
1088      * for the amount of shares provided, in an ideal scenario where
1089      * all the conditions are met.
1090      * @dev Compliant to the ERC4626 interface.
1091      */
1092     function convertToAssets(uint256 shares) override external view returns (uint256 assets) {
1093         return shares * PRECISION / getMultiplier(msg.sender);
1094     }
1095 
1096     /** 
1097      * @notice Allows an on-chain or off-chain user to simulate the
1098      * effects of their deposit at the current block, given current on-chain conditions.
1099      * @dev Compliant to the ERC4626 interface.
1100      */
1101     function previewDeposit(uint256 assets) override external view returns (uint256 shares) {
1102         return assets * getMultiplier(msg.sender) / PRECISION;
1103     }
1104 
1105     /**
1106      * @notice Allows an on-chain or off-chain user to simulate the
1107      * effects of their mint at the current block, given current on-chain conditions.
1108      * @dev Compliant to the ERC4626 interface.
1109      */
1110     function previewMint(uint256 shares) override external view returns (uint256 assets) {
1111          return shares * PRECISION / getMultiplier(msg.sender);
1112     }
1113 
1114     /**
1115      * @notice Allows an on-chain or off-chain user to simulate the effects of their
1116      * withdrawal at the current block, given current on-chain conditions.
1117      * @dev Compliant to the ERC4626 interface.
1118      */
1119     function previewWithdraw(uint256 assets) override external view returns (uint256 shares) {
1120         return assets * getMultiplier(msg.sender) / PRECISION;
1121     }
1122 
1123     /**
1124      * @notice Allows an on-chain or off-chain user to simulate the effects of their
1125      * redeemption at the current block, given current on-chain conditions.
1126      * @dev Compliant to the ERC4626 interface.
1127      */
1128     function previewRedeem(uint256 shares) override external view returns (uint256 assets) {
1129         return shares * PRECISION / getMultiplier(msg.sender);
1130     }
1131 
1132     /**
1133      * @notice xNEWO tokens are not transferable.
1134      * @dev Always returns zero.
1135      */
1136     function allowance(address, address) override external pure returns (uint256) {
1137         return 0;
1138     }
1139 
1140     /**
1141      * @dev Returns the name, symbol and decimals of the token.
1142      */
1143     function name() public view virtual returns (string memory) {
1144         return _name;
1145     }
1146 
1147     function symbol() public view virtual returns (string memory) {
1148         return _symbol;
1149     }
1150 
1151     function decimals() public view virtual returns (uint8) {
1152         return 18;
1153     }
1154 
1155      /* ========== ERC20 NOT ALLOWED FUNCTIONS ========== */
1156 
1157     /**
1158      * @notice ERC20 transfer are not allowed
1159      */
1160     function transfer(address, uint256) external pure override returns (bool) {
1161         revert Unauthorized();
1162     }
1163 
1164     /**
1165      * @notice ERC20 approve are not allowed
1166      */
1167     function approve(address, uint256) external pure override returns (bool) {
1168         revert Unauthorized();
1169     }
1170 
1171     /**
1172      * @notice ERC20 transferFrom are not allowed
1173      */
1174     function transferFrom(address, address, uint256) external pure override returns (bool) {
1175         revert Unauthorized();
1176     }
1177 
1178     /* ============== REWARD FUNCTIONS ====================== */
1179 
1180     /**
1181      * @notice Notify the reward contract about a deposit in the
1182      * veVault contract. This is important to assure the
1183      * contract will account user's rewards.
1184      * @return account with full information
1185      */
1186     function notifyDeposit() public updateReward(msg.sender) updateBoost(msg.sender) returns(Account memory) {
1187         emit NotifyDeposit(msg.sender, accounts[owner].assets, accounts[owner].shares);
1188         return accounts[owner];
1189     }
1190 
1191     /**
1192      * @notice Pick the correct date for applying the reward
1193      * Apply until the end of periodFinish or now
1194      * @return date which rewards are applicable
1195      */
1196     function lastTimeRewardApplicable() public view returns (uint256) {
1197         return block.timestamp < periodFinish ? block.timestamp : periodFinish;
1198     }
1199 
1200     /**
1201      * @notice Calculate how much reward must be given for an user
1202      * per token staked. 
1203      * @return amount of reward per token updated
1204      */
1205     function rewardPerToken() public view returns (uint256) {
1206         if (total.supply == 0) {
1207             return rewardPerTokenStored;
1208         }
1209         return
1210             rewardPerTokenStored
1211             + ((lastTimeRewardApplicable() - lastUpdateTime)
1212                 * rewardRate
1213                 * PRECISION 
1214                 / total.supply
1215             );
1216     }
1217     
1218     /**
1219      * @notice Calculates how much rewards a staker earned 
1220      * until this moment.
1221      * @return amount of rewards earned so far
1222      */
1223     function earned(address owner) public view returns (uint256) {
1224         return accounts[owner].rewards
1225                 + (accounts[owner].shares
1226                     * (rewardPerToken() - accounts[owner].rewardPerTokenPaid)
1227                     / PRECISION);
1228     }
1229 
1230     /**
1231      * @notice Total rewards that will be paid during the distribution
1232      */
1233     function getRewardForDuration() external view returns (uint256) {
1234         return rewardRate * rewardsDuration;
1235     }
1236 
1237     /**
1238      * @notice Claim rewards for user.
1239      * @dev In case of no rewards claimable
1240      * just update the user status and do nothing.
1241      */
1242     function getReward() public updateReward(msg.sender) returns (uint256 reward) {
1243         reward = accounts[msg.sender].rewards;
1244         if(reward <= 0)
1245             revert UnauthorizedClaim();
1246         accounts[msg.sender].rewards = 0;
1247         IERC20(rewardsToken).safeTransfer(msg.sender, reward);
1248         emit RewardPaid(msg.sender, reward);
1249         return reward;
1250     }
1251 
1252     /**
1253      * @notice Set the contract to start distribuiting rewards
1254      * for stakers.
1255      * @param reward: amount of tokens to be distributed
1256      */
1257     function notifyRewardAmount(uint256 reward)
1258             override
1259             external
1260             onlyRewardsDistribution
1261             updateReward(address(0)) {
1262         if (block.timestamp >= periodFinish)
1263             rewardRate = reward / rewardsDuration;
1264         else {
1265             uint256 remaining = periodFinish - block.timestamp;
1266             uint256 leftover = remaining * rewardRate;
1267             rewardRate = (reward + leftover) / rewardsDuration;
1268         }
1269 
1270         // Ensure the provided reward amount is not more than the balance in the contract.
1271         // This keeps the reward rate in the right range, preventing overflows due to
1272         // very high values of rewardRate in the earned and rewardsPerToken functions;
1273         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1274         uint balance = IERC20(rewardsToken).balanceOf(address(this));
1275         if(rewardRate > balance / rewardsDuration)
1276             revert RewardTooHigh({
1277                 allowed: balance,
1278                 reward: reward
1279             });
1280         lastUpdateTime = block.timestamp;
1281         periodFinish = block.timestamp + rewardsDuration;
1282         emit RewardAdded(reward);
1283     }
1284 
1285     /**
1286      * @notice Allow owner to change reward duration
1287      * Only allow the change if period finish has already ended
1288      */
1289     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1290         if (block.timestamp <= periodFinish)
1291             revert Unauthorized();
1292         rewardsDuration = _rewardsDuration;
1293         emit RewardsDurationUpdated(rewardsDuration);
1294     }
1295 
1296     /* =================  GET EXTERNAL INFO  =================== */
1297 
1298     /**
1299      * @notice Get how much token (not veToken) owner has in the provided LP
1300      */
1301     function getNewoShare(address owner) public view returns (uint256) {
1302         uint112 reserve0; uint112 reserve1; uint32 timestamp;
1303 
1304         (reserve0, reserve1, timestamp) = IUniswapV2Pair(assetToken).getReserves();
1305         return accounts[owner].assets * reserve0
1306                 / IUniswapV2Pair(assetToken).totalSupply();
1307     }
1308 
1309     /**
1310      * @notice Get the multiplier applied for the address in the veVault contract 
1311      */
1312     function getMultiplier(address owner) public view returns (uint256) {
1313         IVeVault veToken = IVeVault(veVault);
1314         uint256 assetBalance = veToken.assetBalanceOf(owner);
1315         
1316         // to make sure that there is no division by zero
1317         if (assetBalance == 0)
1318             return 1;
1319         return veToken.balanceOf(owner) * PRECISION / assetBalance;   
1320     }
1321 
1322     /**
1323      * @notice Get how much newo an address has locked in veVault
1324      */
1325     function getNewoLocked(address owner) public view returns (uint256) {
1326         return IVeVault(veVault).assetBalanceOf(owner);
1327     }
1328 
1329     /* ========== MUTATIVE FUNCTIONS ========== */
1330     
1331     /**
1332      * @notice Mints shares to receiver by depositing exactly amount of underlying tokens.
1333      * @dev Compliant to the ERC4626 interface.
1334      * @param assets: amount of underlying tokens
1335      * @param receiver: address which the veTokens will be granted to
1336      * @return shares minted for receiver
1337      */
1338     function deposit(uint256 assets, address receiver)
1339             override
1340             external
1341             nonReentrant
1342             notPaused
1343             updateReward(receiver)
1344             updateBoost(receiver)
1345             returns (uint256 shares) {
1346         shares = assets;
1347         _deposit(assets, shares, receiver);
1348         return shares;
1349     }
1350 
1351     /**
1352      * @dev Not compliant to the ERC4626 interface.
1353      * Due to rounding issues, would be very hard and
1354      * gas expensive to make it properly works.
1355      * To avoid a bad user experience this function
1356      * will always revert.
1357      */
1358     function mint(uint256, address)
1359             override
1360             external
1361             pure
1362             returns (uint256) {
1363         revert NotImplemented();
1364     }
1365 
1366     /**
1367      * @notice Burns shares from owner and sends exactly
1368      * assets of underlying tokens to receiver.
1369      * Allows owner to send their assets to another
1370      * address.
1371      * @dev Compliant to the ERC4626 interface
1372      * @param assets: amount of underlying tokens
1373      * @param receiver: address which tokens will be transfered to
1374      * @param owner: address which controls the veTokens 
1375      * @return shares burned from owner
1376      */
1377     function withdraw(uint256 assets, address receiver, address owner)
1378             override
1379             external
1380             nonReentrant
1381             updateReward(owner)
1382             updateBoost(owner)
1383             returns(uint256 shares) {
1384         shares = assets;
1385         _withdraw(assets, shares, receiver, owner);
1386         return shares; 
1387     }
1388 
1389     /**
1390      * @dev Not compliant to the ERC4626 interface.
1391      * Due to rounding issues, would be very hard and
1392      * gas expensive to make it properly works.
1393      * To avoid a bad user experience this function
1394      * will always revert.
1395      */
1396     function redeem(uint256, address, address)
1397             override
1398             external 
1399             pure
1400             returns (uint256) {
1401         revert NotImplemented();
1402     }
1403 
1404     /**
1405      * @notice Perform a full withdraw
1406      * for caller and get all remaining rewards
1407      * @return reward claimed by the caller
1408      */
1409     function exit() external
1410             nonReentrant 
1411             updateReward(msg.sender)
1412             updateBoost(msg.sender)
1413             returns (uint256 reward) {
1414         _withdraw(accounts[msg.sender].assets, accounts[msg.sender].shares - accounts[msg.sender].sharesBoost, msg.sender, msg.sender);
1415         reward = getReward();
1416         return reward;
1417     }
1418 
1419     /* ========== RESTRICTED FUNCTIONS ========== */
1420     
1421     /**
1422      * @dev Handles internal withdraw logic
1423      * Burns the correct shares amount and
1424      * transfer assets to receiver.
1425      * Only allows receiver equal owner
1426      * @param assets: amount of tokens to withdraw
1427      * @param shares: amount of shares to burn
1428      * @param receiver: address which the tokens will transfered to
1429      * @param owner: address which controls the shares
1430      */
1431     function _withdraw(uint256 assets, uint256 shares, address receiver, address owner) internal {
1432         if(assets <= 0 || owner != msg.sender 
1433             || accounts[owner].assets < assets
1434             || (accounts[owner].shares - accounts[owner].sharesBoost) < shares)
1435             revert Unauthorized();
1436     
1437         // Remove LP Tokens (assets)
1438         total.managedAssets -= assets;
1439         accounts[owner].assets -= assets;
1440         
1441         // Remove shares
1442         total.supply -= shares;
1443         accounts[owner].shares -= shares;
1444 
1445         IERC20(assetToken).safeTransfer(receiver, assets);
1446 
1447         // ERC4626 compliance has to emit withdraw event
1448         emit Withdraw(msg.sender, receiver, owner, assets, shares);
1449     }
1450     
1451     /**
1452      * @dev Handles internal deposit logic
1453      * Mints the correct shares amount and
1454      * transfer assets from caller to vault.
1455      * @param assets: amount of tokens to deposit 
1456      * @param shares: amount of shares to mint
1457      * @param receiver: address which the shares will be minted to, must be the same as caller
1458      */
1459     function _deposit(uint256 assets, uint256 shares, address receiver) internal {
1460         if(assets <= 0 || receiver != msg.sender)
1461             revert Unauthorized();
1462         // Lp tokens
1463         total.managedAssets += assets;
1464         accounts[receiver].assets += assets;
1465 
1466         // Vault shares
1467         total.supply += shares;
1468         accounts[receiver].shares += shares;
1469 
1470         IERC20(assetToken).safeTransferFrom(msg.sender, address(this), assets);
1471         emit Deposit(msg.sender, address(this), assets, shares);
1472     }
1473 
1474     /**
1475      * @notice Owner can whitelist an ERC20 to recover it afterwards.
1476      * Emits and event to notify all users about it 
1477      * @dev It's possible to owner whitelist the underlying token
1478      * and do some kind of rugpull. To prevent that, it'recommended
1479      * that owner is a multisig address. Also, it emits an event
1480      * of changes in the ERC20 whitelist as a safety check.
1481      * @param flag: true to allow recover for the token
1482      */
1483     function changeWhitelistRecoverERC20(address tokenAddress, bool flag) external onlyOwner {
1484         whitelistRecoverERC20[tokenAddress] = flag;
1485         emit ChangeWhitelistERC20(tokenAddress, flag);
1486     }
1487 
1488     /**
1489      * @notice Added to support to recover ERC20 token within a whitelist 
1490      */
1491     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1492         if (whitelistRecoverERC20[tokenAddress] == false) revert NotWhitelisted();
1493         
1494         uint balance = IERC20(tokenAddress).balanceOf(address(this));
1495         if (balance < tokenAmount) revert InsufficientBalance(); 
1496 
1497         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1498         emit Recovered(tokenAddress, tokenAmount);
1499     }
1500 
1501     /**
1502      * @notice Added to support to recover ERC721 
1503      */
1504     function recoverERC721(address tokenAddress, uint256 tokenId) external onlyOwner {
1505         IERC721(tokenAddress).safeTransferFrom(address(this), owner, tokenId);
1506         emit RecoveredNFT(tokenAddress, tokenId);
1507     }
1508     
1509     /* ========== MODIFIERS ========== */
1510 
1511     /**
1512      * @dev Always apply this to update the current state
1513      * of earned rewards for caller
1514      */
1515     modifier updateReward(address owner) {
1516         rewardPerTokenStored = rewardPerToken();
1517         lastUpdateTime = lastTimeRewardApplicable();
1518         if (owner != address(0)) {
1519             accounts[owner].rewards = earned(owner);
1520             accounts[owner].rewardPerTokenPaid = rewardPerTokenStored;
1521         }
1522         _;
1523     }
1524 
1525     /**
1526      * @dev Whenever the amount of assets is changed
1527      * this will check and update the boosts correctly
1528      * This action can burn or mint new shares if necessary
1529      */
1530     modifier updateBoost(address owner) {
1531         _;
1532         uint256 oldShares = accounts[owner].shares;
1533         uint256 newShares = oldShares;
1534         if (getNewoShare(owner) <= getNewoLocked(owner)){
1535             newShares = accounts[owner].assets * getMultiplier(owner) / PRECISION;
1536         }
1537         if (newShares > oldShares) {
1538             // Mint boost shares
1539             uint256 diff = newShares - oldShares;
1540             total.supply += diff;
1541             accounts[owner].sharesBoost = diff;
1542             accounts[owner].shares = newShares;
1543             emit BoostUpdated(owner, accounts[owner].shares, accounts[owner].sharesBoost);
1544         } else if (newShares < oldShares) {
1545             // Burn boost shares
1546             uint256 diff = oldShares - newShares;
1547             total.supply -= diff;
1548             accounts[owner].sharesBoost = diff;
1549             accounts[owner].shares = newShares;
1550             emit BoostUpdated(owner, accounts[owner].shares, accounts[owner].sharesBoost);
1551         }
1552     }
1553 
1554     /* ========== EVENTS ========== */
1555 
1556     event RewardAdded(uint256 reward);
1557     event RewardPaid(address indexed user, uint256 reward);
1558     event RewardsDurationUpdated(uint256 newDuration);
1559     event Recovered(address token, uint256 amount);
1560     event RecoveredNFT(address tokenAddress, uint256 tokenId);
1561     event ChangeWhitelistERC20(address indexed tokenAddress, bool whitelistState);
1562     event NotifyDeposit(address indexed user, uint256 assetBalance, uint256 sharesBalance);
1563     event BoostUpdated(address indexed owner, uint256 totalShares, uint256 boostShares);
1564 }
1565 
1566 
1567 contract XNewO is LpRewards("staked NEWO LP", "stNEWOlp") {
1568     constructor(
1569         address _owner,
1570         address _lp,
1571         address _rewardsToken,
1572         address _veTokenVault,
1573         address _rewardsDistribution
1574     ) Owned (_owner) {
1575         assetToken = _lp;
1576         rewardsToken = _rewardsToken;
1577         veVault = _veTokenVault;
1578         rewardsDistribution = _rewardsDistribution;
1579     }
1580 }