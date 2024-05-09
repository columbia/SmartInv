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
659 // File: contracts/veNEWO.sol
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
747 
748 
749 interface IERC4626 is IERC20 {
750     // The address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
751     function asset() external view returns(address assetTokenAddress);
752 
753     // Total amount of the underlying asset that is “managed” by Vault.
754     function totalAssets() external view returns(uint256 totalManagedAssets);
755 
756     // The amount of shares that the Vault would exchange for the amount of assets provided, in an ideal scenario where all the conditions are met.
757     function convertToShares(uint256 assets) external view returns(uint256 shares); 
758 
759     // The amount of assets that the Vault would exchange for the amount of shares provided, in an ideal scenario where all the conditions are met.
760     function convertToAssets(uint256 shares) external view returns(uint256 assets);
761  
762     // Maximum amount of the underlying asset that can be deposited into the Vault for the receiver, through a deposit call.
763     function maxDeposit(address receiver) external view returns(uint256 maxAssets);
764 
765     // Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given current on-chain conditions.
766     function previewDeposit(uint256 assets) external view returns(uint256 shares);
767 
768     // Mints shares Vault shares to receiver by depositing exactly amount of underlying tokens.
769     function deposit(uint256 assets, address receiver) external returns(uint256 shares);
770 
771     // Maximum amount of shares that can be minted from the Vault for the receiver, through a mint call.
772     function maxMint(address receiver) external view returns(uint256 maxShares); 
773 
774     // Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given current on-chain conditions.
775     function previewMint(uint256 shares) external view returns(uint256 assets);
776 
777     // Mints exactly shares Vault shares to receiver by depositing amount of underlying tokens.
778     function mint(uint256 shares, address receiver) external returns(uint256 assets);
779 
780     // Maximum amount of the underlying asset that can be withdrawn from the owner balance in the Vault, through a withdraw call.
781     function maxWithdraw(address owner) external view returns(uint256 maxAssets);
782 
783     // Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block, given current on-chain conditions.
784     function previewWithdraw(uint256 assets) external view returns(uint256 shares);
785 
786     // Burns shares from owner and sends exactly assets of underlying tokens to receiver.
787     function withdraw(uint256 assets, address receiver, address owner) external returns(uint256 shares);
788 
789     // Maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
790     function maxRedeem(address owner) external view returns(uint256 maxShares);
791 
792     // Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block, given current on-chain conditions.
793     function previewRedeem(uint256 shares) external view returns(uint256 assets);
794 
795     // Burns exactly shares from owner and sends assets of underlying tokens to receiver.
796     function redeem(uint256 shares, address receiver, address owner) external returns(uint256 assets);
797 
798     event Deposit(address indexed caller, address indexed owner, uint256 assets, uint256 shares);
799     event Withdraw(address indexed caller, address indexed receiver, address indexed owner, uint256 assets, uint256 shares);
800 }
801 
802 // Custom errors
803 error Unauthorized();
804 error InsufficientBalance(uint256 available, uint256 required);
805 error NotWhitelisted();
806 error FundsInGracePeriod();
807 error FundsNotUnlocked();
808 error InvalidSetting();
809 error LockTimeOutOfBounds(uint256 lockTime, uint256 lockMin, uint256 lockMax);
810 error LockTimeLessThanCurrent(uint256 currentUnlockDate, uint256 newUnlockDate);
811 
812 /** 
813  * @title Implements voting escrow tokens with time based locking system
814  * @author gcontarini jocorrei
815  * @dev This implementation tries to follow the ERC4626 standard
816  * Implement a new constructor to deploy this contract 
817  */
818 abstract contract VeVault is ReentrancyGuard, Pausable, IERC4626 {
819     using SafeERC20 for IERC20;
820 
821     // Holds all params to implement the penalty/kick-off system
822     struct Penalty {
823         uint256 gracePeriod;
824         uint256 maxPerc;
825         uint256 minPerc;
826         uint256 stepPerc;
827     }
828     
829     // Hold all params to implement the locking system
830     struct LockTimer {
831         uint256 min;
832         uint256 max;
833         uint256 epoch;
834         bool    enforce;
835     }
836 
837     /* ========== STATE VARIABLES ========== */
838 
839     // Asset token
840     address public _assetTokenAddress;
841     uint256 public _totalManagedAssets;
842     mapping(address => uint256) public _assetBalances;
843 
844     // Share (veToken)
845     uint256 private _totalSupply;
846     mapping(address => uint256) public _shareBalances;
847     mapping(address => uint256) private _unlockDate;
848 
849     // ERC20 metadata
850     string public _name;
851     string public _symbol;
852 
853     LockTimer internal _lockTimer;
854     Penalty internal _penalty;
855     
856     // Only allow recoverERC20 from this list
857     mapping(address => bool) public whitelistRecoverERC20;
858 
859     // Constants
860     uint256 private constant SEC_IN_DAY = 86400;
861     uint256 private constant PRECISION = 1e2;
862     // This value should be 1e17 but we are using 1e2 as precision
863     uint256 private constant CONVERT_PRECISION  = 1e17 / PRECISION;
864     // Polynomial coefficients used in veMult function
865     uint256 private constant K_3 = 154143856;
866     uint256 private constant K_2 = 74861590400;
867     uint256 private constant K_1 = 116304927000000;
868     uint256 private constant K = 90026564600000000;
869 
870     /* ========== CONSTRUCTOR ========== */
871 
872     constructor(string memory name_, string memory symbol_) {
873         _name = name_;
874         _symbol = symbol_;
875     }
876     
877     /* ========== VIEWS ========== */
878     
879     /**
880      * @notice The address of the underlying token 
881      * used for the Vault for accounting, depositing,
882      * and withdrawing.
883      */
884     function asset() external view override returns (address assetTokenAddress) {
885         return _assetTokenAddress;
886     }
887 
888     /**
889      * @notice Total amount of the underlying asset that is “managed” by Vault.
890      */
891     function totalAssets() external view override returns (uint256 totalManagedAssets) {
892         return _totalManagedAssets;
893     }
894 
895     /**
896      * @notice Total of veTokens
897      */
898     function totalSupply() external view override returns (uint256) {
899         return _totalSupply;
900     }
901 
902     /**
903      * @notice Total of veTokens currently hold by an address
904      */
905     function balanceOf(address account) external view override returns (uint256) {
906         return _shareBalances[account];
907     }
908 
909     /** 
910      * @dev Compliant to the ERC4626 interface.
911      * @notice The amount of shares that the Vault would exchange 
912      * for the amount of assets provided, in an ideal scenario where
913      * all the conditions are met.
914      */
915     function convertToShares(uint256 assets, uint256 lockTime) public pure returns (uint256 shares) {
916         return assets * veMult(lockTime) / PRECISION;
917     }
918 
919     /**
920      * @notice If no lock time is given, return the amount of veToken for the min amount of time locked.
921      */
922     function convertToShares(uint256 assets) override external view returns (uint256 shares) {
923         return convertToShares(assets, _lockTimer.min);
924     }
925     
926     /**
927      * @notice The amount of assets that the Vault would exchange
928      * for the amount of shares provided, in an ideal scenario where
929      * all the conditions are met.
930      * @dev Compliant to the ERC4626 interface.
931      */
932     function convertToAssets(uint256 shares, uint256 lockTime) public pure returns (uint256 assets) {
933         return shares * PRECISION / veMult(lockTime);
934     }
935 
936     /**
937      * @notice If no lock time is given, return the amount of
938      * veToken for the min amount of time locked.
939      */
940     function convertToAssets(uint256 shares) override external view returns (uint256 assets) {
941         return convertToAssets(shares, _lockTimer.min);
942     }
943     
944     /** 
945      * @notice Maximum amount of the underlying asset that can
946      * be deposited into the Vault for the receiver, through a deposit call.
947      * @dev Compliant to the ERC4626 interface.
948      */
949     function maxDeposit(address) override external pure returns (uint256 maxAssets) {
950         return 2 ** 256 - 1;
951     }
952 
953     /** 
954      * @notice Allows an on-chain or off-chain user to simulate the
955      * effects of their deposit at the current block, given current on-chain conditions.
956      * @dev Compliant to the ERC4626 interface.
957      */
958     function previewDeposit(uint256 assets, uint256 lockTime) public pure returns (uint256 shares) {
959         return convertToShares(assets, lockTime);
960     }
961 
962     function previewDeposit(uint256 assets) override external view returns (uint256 shares) {
963         return previewDeposit(assets, _lockTimer.min);
964     }
965     
966     /**
967      * @notice Maximum amount of shares that can be minted from the
968      * Vault for the receiver, through a mint call.
969      * @dev Compliant to the ERC4626 interface.
970      */
971     function maxMint(address) override external pure returns (uint256 maxShares) {
972         return 2 ** 256 - 1;
973     }
974 
975     /**
976      * @notice Allows an on-chain or off-chain user to simulate the
977      * effects of their mint at the current block, given current on-chain conditions.
978      * @dev Compliant to the ERC4626 interface.
979      */
980     function previewMint(uint256 shares, uint256 lockTime) public pure returns (uint256 assets) {
981         return convertToAssets(shares, lockTime);
982     }
983 
984     /**
985      * @notice If no lock time is given, return the amount of veToken for the min amount of time locked.
986      */
987     function previewMint(uint256 shares) override external view returns (uint256 assets) {
988         return previewMint(shares, _lockTimer.min);
989     }
990     
991     /**
992      * @notice Maximum amount of the underlying asset that can be withdrawn from the
993      * owner balance in the Vault, through a withdraw call.
994      * @dev Compliant to the ERC4626 interface.
995      */
996     function maxWithdraw(address owner) override external view returns (uint256 maxAssets) {
997         if (paused) {
998             return 0;
999         }
1000         return _assetBalances[owner];
1001     }
1002 
1003     /**
1004      * @notice Allows an on-chain or off-chain user to simulate the effects of their
1005      * withdrawal at the current block, given current on-chain conditions.
1006      * @dev Compliant to the ERC4626 interface.
1007      */
1008     function previewWithdraw(uint256 assets, uint256 lockTime) public pure returns (uint256 shares) {
1009         return convertToShares(assets, lockTime);
1010     }
1011 
1012     /**
1013      * @notice If no lock time is given, return the amount of veToken for the min amount of time locked.
1014      */
1015     function previewWithdraw(uint256 assets) override external view returns (uint256 shares) {
1016         return previewWithdraw(assets, _lockTimer.min);
1017     }
1018     
1019     /**
1020      * @notice Maximum amount of Vault shares that can be redeemed from the owner balance in the Vault, through a redeem call.
1021      * @dev Compliant to the ERC4626 interface.
1022      */
1023     function maxRedeem(address owner) override external view returns (uint256 maxShares) {
1024         if (paused) {
1025             return 0;
1026         }
1027         return _shareBalances[owner];
1028     }
1029 
1030     /**
1031      * @notice Allows an on-chain or off-chain user to simulate the effects of their
1032      * redeemption at the current block, given current on-chain conditions.
1033      * @dev Compliant to the ERC4626 interface.
1034      */
1035     function previewRedeem(uint256 shares, uint256 lockTime) public pure returns (uint256 assets) {
1036         return convertToAssets(shares, lockTime);
1037     }
1038 
1039     /**
1040      * @notice If no lock time is given, return the amount of veToken for the min amount of time locked.
1041      */
1042     function previewRedeem(uint256 shares) override external view returns (uint256 assets) {
1043         return previewRedeem(shares, _lockTimer.min);
1044     }
1045     
1046     /**
1047      * @notice Ve tokens are not transferable.
1048      * @dev Always returns zero.
1049      * ERC20 interface.
1050      */
1051     function allowance(address, address) override external pure returns (uint256) {
1052         return 0;
1053     }
1054 
1055     /**
1056      * @notice Total assets deposited by address
1057      * @dev Compliant to the ERC4626 interface.
1058      */
1059     function assetBalanceOf(address account) external view returns (uint256) {
1060         return _assetBalances[account];
1061     }
1062 
1063     /**
1064      * @notice Unlock date for an account
1065      */
1066     function unlockDate(address account) external view returns (uint256) {
1067         return _unlockDate[account];
1068     }
1069 
1070     /**
1071      * @notice How long is the grace period in seconds
1072      */
1073     function gracePeriod() external view returns (uint256) {
1074         return _penalty.gracePeriod;
1075     }
1076 
1077     /**
1078      * @notice Percentage paid per epoch after grace period plus the minimum percentage
1079      * This is paid to caller which withdraw veTokens in name of account in the underlying asset.
1080      */
1081     function penaltyPercentage() external view returns (uint256) {
1082         return _penalty.stepPerc;
1083     }
1084 
1085     /**
1086      * @notice Minimum lock time in seconds
1087      */
1088      function minLockTime() external view returns (uint256) {
1089          return _lockTimer.min;
1090      }
1091     
1092     /**
1093      * @notice Maximum lock time in seconds
1094      */
1095      function maxLockTime() external view returns (uint256) {
1096          return _lockTimer.max;
1097      }
1098 
1099      /**
1100      * @notice Returns the name of the token.
1101      */
1102     function name() public view returns (string memory) {
1103         return _name;
1104     }
1105 
1106     /**
1107      * @notice Returns the symbol of the token, usually a shorter version of the name.
1108      */
1109     function symbol() public view returns (string memory) {
1110         return _symbol;
1111     }
1112 
1113     function decimals() public pure returns (uint8) {
1114         return 18;
1115     }
1116     
1117     /* ========== ERC20 NOT ALLOWED FUNCTIONS ========== */
1118 
1119     /**
1120      * @notice ERC20 transfer are not allowed
1121      */
1122     function transfer(address, uint256) external pure override returns (bool) {
1123         revert Unauthorized();
1124     }
1125 
1126     /**
1127      * @notice ERC20 approve are not allowed
1128      */
1129     function approve(address, uint256) external pure override returns (bool) {
1130         revert Unauthorized();
1131     }
1132 
1133     /**
1134      * @notice ERC20 transferFrom are not allowed
1135      */
1136     function transferFrom(address, address, uint256) external pure override returns (bool) {
1137         revert Unauthorized();
1138     }
1139 
1140     /* ========== PURE FUNCTIONS ========== */
1141 
1142     /**
1143      * @notice Calculate the multipler applied to the amount of tokens staked.
1144      * @dev This functions implements the following polynomial: 
1145      * f(x) = x^3 * 1.54143856e-09 - x^2 * 7.48615904e-07 + x * 1.16304927e-03 + 9.00265646e-01
1146      * Which can be simplified to: f(x) = x^3 * K_3 - x^2 * K_2 + x * K_1 + K
1147      * Granularity is lost with lockTime between days
1148      * @param lockTime: time in seconds
1149      * @return multiplier with 2 digits of precision
1150      */
1151     function veMult(uint256 lockTime) internal pure returns (uint256) {
1152         return (
1153             (((lockTime / SEC_IN_DAY) ** 3) * K_3)
1154             + ((lockTime / SEC_IN_DAY) * K_1) + K
1155             - (((lockTime / SEC_IN_DAY) ** 2) * K_2)
1156             ) / CONVERT_PRECISION;
1157     }
1158 
1159     /**
1160      * @notice Returns the multiplier applied for an address
1161      * with 2 digits precision
1162      * @param owner: address of owner 
1163      * @return multiplier applied to an account, zero in case of no assets
1164      */
1165     function veMult(address owner) external view returns (uint256) {
1166         if (_assetBalances[owner] == 0) return 0;
1167         return _shareBalances[owner] * PRECISION / _assetBalances[owner];
1168     }
1169     
1170     /* ========== MUTATIVE FUNCTIONS ========== */
1171 
1172     /**
1173      * @notice Mints shares Vault shares to receiver by depositing exactly 
1174      * amount of underlying tokens.
1175      * Only allow deposits for caller equals receiver.
1176      * Relocks are only allowed if new unlock date is futherest
1177      * in the future. If user tries to reduce its lock period
1178      * the transaction will revert.
1179      * The multiplier applied is always the one from the last
1180      * deposit. And it's applied to the total amount deposited
1181      * so far. It's not possible to have 2 unclock dates for 
1182      * the same address.
1183      * @dev Compliant to the ERC4626 interface.
1184      * @param assets: amount of underlying tokens
1185      * @param receiver: address which the veTokens will be granted to
1186      * @param lockTime: how long the tokens will be locked
1187      * @return shares minted for receiver
1188      */
1189     function deposit(uint256 assets, address receiver, uint256 lockTime)
1190             external 
1191             nonReentrant
1192             notPaused 
1193             returns (uint256 shares) {
1194         return _deposit(assets, receiver, lockTime);
1195     }
1196     
1197     /**
1198      * @notice If no lock time is given, use the min lock time value.
1199      * @param assets: amount of underlying tokens
1200      * @param receiver: address which the veTokens will be granted to
1201      * @return shares minted for receiver
1202      */
1203     function deposit(uint256 assets, address receiver)
1204             override
1205             external
1206             nonReentrant
1207             notPaused 
1208             returns (uint256 shares) {
1209         return _deposit(assets, receiver, _lockTimer.min);
1210     }
1211     
1212     /**
1213      * @notice Mint shares for receiver by depositing
1214      * the necessary amount of underlying tokens.
1215      * Only allow deposits for caller equals receiver.
1216      * Relocks are only allowed if new unlock date is futherest
1217      * in the future. If user tries to reduce its lock period
1218      * the transaction will revert.
1219      * The multiplier applied is always the one from the last
1220      * deposit. And it's applied to the total amount deposited
1221      * so far. It's not possible to have 2 unclock dates for 
1222      * the same address.
1223      * @dev Not compliant to the ERC4626 interface
1224      * since it doesn't mint the exactly amount
1225      * of shares asked. The shares amount stays
1226      * within a 0.001% margin.
1227      * @param shares: amount of veTokens the receiver will get
1228      * @param receiver: address which the veTokens will be granted to
1229      * @param lockTime: how long the tokens will be locked
1230      * @return assets deposit in the vault
1231      */
1232     function mint(uint256 shares, address receiver, uint256 lockTime)
1233             external 
1234             nonReentrant
1235             notPaused
1236             returns (uint256 assets) {
1237         uint256 updatedShares = convertToShares(_assetBalances[receiver], lockTime);
1238         if (updatedShares > _shareBalances[receiver]) {
1239             uint256 diff = updatedShares - _shareBalances[receiver];
1240             if (shares <= diff)
1241                 revert Unauthorized();
1242             assets = convertToAssets(shares - diff, lockTime);
1243         } else {
1244             uint256 diff = _shareBalances[receiver] - updatedShares;
1245             assets = convertToAssets(shares + diff, lockTime);
1246         }
1247         _deposit(assets, receiver, lockTime);
1248         return assets;
1249     }
1250 
1251     /**
1252      * @notice If no lock time is given, use the min lock time value.
1253      * @param shares: amount of veTokens the receiver will get
1254      * @param receiver: address which the veTokens will be granted to
1255      * @return assets deposit in the vault
1256      */
1257     function mint(uint256 shares, address receiver)
1258             override
1259             external
1260             nonReentrant
1261             notPaused
1262             returns (uint256 assets) {
1263         uint256 updatedShares = convertToShares(_assetBalances[receiver], _lockTimer.min);
1264         if (updatedShares > _shareBalances[receiver]) {
1265             uint256 diff = updatedShares - _shareBalances[receiver];
1266             assets = convertToAssets(shares - diff, _lockTimer.min);
1267         } else {
1268             uint256 diff = _shareBalances[receiver] - updatedShares;
1269             assets = convertToAssets(shares + diff, _lockTimer.min);
1270         }
1271         _deposit(assets, receiver, _lockTimer.min);
1272         return assets;
1273     }
1274     
1275     /**
1276      * @notice Burns shares from owner and sends exactly
1277      * assets of underlying tokens to receiver.
1278      * Allows owner to send their assets to another
1279      * address.
1280      * A caller can only withdraw assets from owner
1281      * to owner, receiving a reward for doing so.
1282      * This reward is paid from owner's asset balance.
1283      * Can only withdraw after unlockDate and withdraw
1284      * from another address after unlockDate plus grace
1285      * period.
1286      * @dev Compliant to the ERC4626 interface
1287      * @param assets: amount of underlying tokens
1288      * @param receiver: address which tokens will be transfered to
1289      * @param owner: address which controls the veTokens 
1290      * @return shares burned from owner
1291      */
1292     function withdraw(uint256 assets, address receiver, address owner)
1293             override
1294             external 
1295             nonReentrant 
1296             notPaused
1297             returns (uint256 shares) {
1298         return _withdraw(assets, receiver, owner);
1299     }
1300 
1301     /**
1302      * @notice Burns shares from owner and sends the correct
1303      * amount of underlying tokens to receiver.
1304      * Allows owner to send their assets to another
1305      * address.
1306      * A caller can only withdraw assets from owner
1307      * to owner, receiving a reward for doing so.
1308      * This reward is paid from owner asset balance.
1309      * Can only withdraw after unlockDate and withdraw
1310      * from another address after unlockDate plus grace
1311      * period.
1312      * @dev Not compliant to the ERC4626 interface
1313      * since it doesn't burn the exactly amount
1314      * of shares asked. The shares amount stays
1315      * within a 0.001% margin.
1316      * @param shares: amount of veTokens to burn 
1317      * @param receiver: address which tokens will be transfered to
1318      * @param owner: address which controls the veTokens 
1319      * @return assets transfered to receiver
1320      */
1321     function redeem(uint256 shares, address receiver, address owner)
1322             override
1323             external 
1324             nonReentrant 
1325             notPaused
1326             returns (uint256 assets) {
1327         uint256 diff = _shareBalances[owner] - _assetBalances[owner];
1328         if (shares < diff)
1329             revert Unauthorized();
1330         assets = shares - diff;
1331         _withdraw(assets, receiver, owner);
1332         return assets;
1333     }
1334 
1335     /**
1336      * @notice Withdraw all funds for the caller
1337      * @dev Best option to get all funds from an account
1338      * @return shares burned from caller 
1339      */
1340     function exit()
1341             external 
1342             nonReentrant 
1343             notPaused
1344             returns (uint256 shares) {
1345         return _withdraw(_assetBalances[msg.sender], msg.sender, msg.sender);
1346     }
1347 
1348     /**
1349     * @notice Owner can change the unlock rule to allow
1350     * withdraws before unlock date.
1351     * Ignores the rule if set to false.
1352     */
1353     function changeUnlockRule(bool flag) external onlyOwner {
1354         _lockTimer.enforce = flag;
1355     }
1356 
1357     /**
1358      * @notice Owner can change state variabes which controls the penalty system
1359      */
1360     function changeGracePeriod(uint256 newGracePeriod) external onlyOwner {
1361         _penalty.gracePeriod = newGracePeriod;
1362     }
1363     
1364     /**
1365      * @notice Owner can change state variabes which controls the penalty system
1366      */
1367     function changeEpoch(uint256 newEpoch) external onlyOwner {
1368         if (newEpoch == 0)
1369             revert InvalidSetting();
1370         _lockTimer.epoch = newEpoch;
1371     }
1372     
1373     /**
1374      * @notice Owner can change state variabes which controls the penalty system
1375      */
1376     function changeMinPenalty(uint256 newMinPenalty) external onlyOwner {
1377         if (newMinPenalty >= _penalty.maxPerc)
1378             revert InvalidSetting();
1379         _penalty.minPerc = newMinPenalty;
1380     }
1381     
1382     /**
1383      * @notice Owner can change state variabes which controls the penalty system
1384      */
1385     function changeMaxPenalty(uint256 newMaxPenalty) external onlyOwner {
1386         if (newMaxPenalty <= _penalty.minPerc)
1387             revert InvalidSetting();
1388         _penalty.maxPerc = newMaxPenalty;
1389     }
1390     
1391     /**
1392      * @notice Owner can whitelist an ERC20 to recover it afterwards.
1393      * Emits and event to notify all users about it 
1394      * @dev It's possible to owner whitelist the underlying token
1395      * and do some kind of rugpull. To prevent that, it'recommended
1396      * that owner is a multisig address. Also, it emits an event
1397      * of changes in the ERC20 whitelist as a safety check.
1398      * @param flag: true to allow recover for the token
1399      */
1400     function changeWhitelistRecoverERC20(address tokenAddress, bool flag) external onlyOwner {
1401         whitelistRecoverERC20[tokenAddress] = flag;
1402         emit ChangeWhitelistERC20(tokenAddress, flag);
1403     }
1404 
1405     /**
1406      * @notice Added to support to recover ERC20 token within a whitelist 
1407      */
1408     function recoverERC20(address tokenAddress, uint256 tokenAmount) external onlyOwner {
1409         if (whitelistRecoverERC20[tokenAddress] == false) revert NotWhitelisted();
1410         
1411         uint balance = IERC20(tokenAddress).balanceOf(address(this));
1412         if (balance < tokenAmount) revert InsufficientBalance({
1413                 available: balance,
1414                 required: tokenAmount
1415         });
1416         
1417         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1418         emit Recovered(tokenAddress, tokenAmount);
1419     }
1420 
1421     /**
1422      * @notice Added to support to recover ERC721 
1423      */
1424     function recoverERC721(address tokenAddress, uint256 tokenId) external onlyOwner {
1425         IERC721(tokenAddress).safeTransferFrom(address(this), owner, tokenId);
1426         emit RecoveredNFT(tokenAddress, tokenId);
1427     }
1428 
1429     /* ========== INTERNAL FUNCTIONS ========== */
1430     
1431     /**
1432      * @dev Handles deposit in which
1433      * new veTokens are minted.
1434      * Transfer asset tokens to
1435      * vault and lock it for a period.
1436      * @param assets: amount of underlying tokens
1437      * @param receiver: address which the veTokens will be granted to
1438      * @param lockTime: how long the tokens will be locked
1439      * @return shares minted for receiver 
1440      */
1441     function _deposit(
1442         uint256 assets,
1443         address receiver,
1444         uint256 lockTime
1445         ) internal 
1446         updateShares(receiver, lockTime)
1447         returns (uint256 shares) {
1448         if (msg.sender != receiver)
1449             revert Unauthorized();
1450         if (lockTime < _lockTimer.min || lockTime > _lockTimer.max)
1451             revert LockTimeOutOfBounds(lockTime, _lockTimer.min, _lockTimer.max);
1452 
1453         // Cannot lock more funds less than the current
1454         uint256 unlockTime = block.timestamp + lockTime;
1455         if (unlockTime < _unlockDate[receiver])
1456             revert LockTimeLessThanCurrent(_unlockDate[receiver], unlockTime);
1457         _unlockDate[receiver] = unlockTime;
1458 
1459         // The end balance of shares can be
1460         // lower than the amount returned by
1461         // this function
1462         shares = convertToShares(assets, lockTime);
1463         if (assets == 0) {
1464             emit Relock(msg.sender, receiver, assets, _unlockDate[receiver]);
1465         } else {
1466             // Update assets
1467             _totalManagedAssets += assets;
1468             _assetBalances[receiver] += assets;
1469             IERC20(_assetTokenAddress).safeTransferFrom(receiver, address(this), assets);
1470             emit Deposit(msg.sender, receiver, assets, shares);
1471         }
1472         return shares;
1473     }
1474     
1475     /**
1476      * @dev Handles withdraw in which veTokens are burned.
1477      * Transfer asset tokens from vault to receiver.
1478      * Only allows withdraw after correct unlock date.
1479      * The end balance of shares can be lower than 
1480      * the amount returned by this function
1481      * @param assets: amount of underlying tokens
1482      * @param receiver: address which the veTokens will be granted to
1483      * @param owner: address which holds the veTokens 
1484      * @return shares burned from owner
1485      */
1486     function _withdraw(
1487         uint256 assets,
1488         address receiver,
1489         address owner
1490         ) internal
1491         updateShares(receiver, _lockTimer.min)
1492         returns (uint256 shares) {
1493         if (owner == address(0)) revert Unauthorized();
1494         if (_assetBalances[owner] < assets)
1495             revert InsufficientBalance({
1496                 available: _assetBalances[owner],
1497                 required: assets
1498             });
1499 
1500         // To kickout someone
1501         if (msg.sender != owner) {
1502             // Must send the funds to owner
1503             if (receiver != owner)
1504                 revert Unauthorized();
1505             // Only kickout after gracePeriod
1506             if (_lockTimer.enforce && (block.timestamp < _unlockDate[owner] + _penalty.gracePeriod))
1507                 revert FundsNotUnlocked();
1508             // Pay reward to caller
1509             assets -= _payPenalty(owner, assets);
1510         }
1511         // Self withdraw
1512         else if (_lockTimer.enforce && block.timestamp < _unlockDate[owner])
1513             revert FundsNotUnlocked();
1514 
1515         // Withdraw assets
1516         _totalManagedAssets -= assets;
1517         _assetBalances[owner] -= assets;
1518         IERC20(_assetTokenAddress).safeTransfer(receiver, assets);
1519         shares = assets;
1520         emit Withdraw(msg.sender, receiver, owner, assets, shares);
1521         return shares;
1522     }
1523 
1524     /**
1525      * @dev Pay penalty to withdraw caller.
1526      * The reward is paid from owner account
1527      * with their underlying asset.
1528      * Only after the grace period it's paid.
1529      * It starts at the minimum penalty and
1530      * after each epoch it's increased. It's
1531      * capped at the max penalty.
1532      * @param owner: address which controls the veTokens
1533      * @param assets: amount of assets from owner being withdraw
1534      * @return amountPenalty amount of assets paid to caller
1535      */
1536     function _payPenalty(address owner, uint256 assets) internal returns (uint256 amountPenalty) {
1537         uint256 penaltyAmount = _penalty.minPerc 
1538                         + (((block.timestamp - (_unlockDate[owner] + _penalty.gracePeriod))
1539                             / _lockTimer.epoch)
1540                         * _penalty.stepPerc);
1541 
1542         if (penaltyAmount > _penalty.maxPerc) {
1543             penaltyAmount = _penalty.maxPerc;
1544         }
1545         amountPenalty = (assets * penaltyAmount) / 100;
1546 
1547         // Safety check 
1548         if (_assetBalances[owner] < amountPenalty)
1549             revert InsufficientBalance({
1550                 available: _assetBalances[owner],
1551                 required: amountPenalty
1552             });
1553 
1554         _totalManagedAssets -= amountPenalty;
1555         _assetBalances[owner] -= amountPenalty;
1556 
1557         IERC20(_assetTokenAddress).safeTransfer(msg.sender, amountPenalty);
1558         emit PayPenalty(msg.sender, owner, amountPenalty);
1559         return amountPenalty;
1560     }
1561     
1562     /**
1563      * @dev Update the correct amount of shares
1564      * In case of a deposit, always consider
1565      * the last lockTime for the multiplier.
1566      * But the unlockDate will always be the
1567      * one futherest in the future.
1568      * In a case of a withdraw, the min multiplier
1569      * is applied for the leftover assets in vault. 
1570      */
1571     modifier updateShares(address receiver, uint256 lockTime) {
1572         _;
1573         uint256 shares = convertToShares(_assetBalances[receiver], lockTime);
1574         uint256 oldShares = _shareBalances[receiver];
1575         if (oldShares < shares) {
1576             uint256 diff = shares - oldShares;
1577             _totalSupply += diff;
1578             emit Mint(receiver, diff);
1579         } else if (oldShares > shares) {
1580             uint256 diff = oldShares - shares;
1581             _totalSupply -= diff;
1582             emit Burn(receiver, diff);
1583         }
1584         _shareBalances[receiver] = shares;
1585     }
1586     
1587     /* ========== EVENTS ========== */
1588 
1589     event Relock(address indexed caller, address indexed receiver, uint256 assets, uint256 newUnlockDate);
1590     event PayPenalty(address indexed caller, address indexed owner, uint256 assets);
1591     event Burn(address indexed user, uint256 shares);
1592     event Mint(address indexed user, uint256 shares);
1593     event Recovered(address token, uint256 amount);
1594     event RecoveredNFT(address tokenAddress, uint256 tokenId);
1595     event ChangeWhitelistERC20(address indexed tokenAddress, bool whitelistState);
1596 }
1597 
1598 contract VeNewO is VeVault("veNewO", "veNWO") {
1599     constructor(
1600         address owner_,
1601         address stakingToken_,
1602         uint256 gracePeriod_,
1603         uint256 minLockTime_,
1604         uint256 maxLockTime_,
1605         uint256 penaltyPerc_,
1606         uint256 maxPenalty_,
1607         uint256 minPenalty_,
1608         uint256 epoch_
1609     ) Owned(owner_) {
1610         // assetToken = IERC20(stakingToken_);
1611         _assetTokenAddress = stakingToken_;
1612 
1613         _lockTimer.min = minLockTime_;
1614         _lockTimer.max = maxLockTime_;
1615         _lockTimer.epoch = epoch_;
1616         _lockTimer.enforce = true;
1617         
1618         _penalty.gracePeriod = gracePeriod_;
1619         _penalty.maxPerc = maxPenalty_;
1620         _penalty.minPerc = minPenalty_;
1621         _penalty.stepPerc = penaltyPerc_;
1622 
1623         paused = false;
1624     }
1625 }