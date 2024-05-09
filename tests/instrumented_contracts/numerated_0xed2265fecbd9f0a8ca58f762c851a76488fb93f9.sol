1 // File: contracts/interfaces/IMintableERC721.sol
2 
3 
4 pragma solidity ^0.8.10;
5 
6 interface IMintableERC721 {
7 	/**
8 	 * @notice Checks if specified token exists
9 	 *
10 	 * @dev Returns whether the specified token ID has an ownership
11 	 *      information associated with it
12 	 *
13 	 * @param _tokenId ID of the token to query existence for
14 	 * @return whether the token exists (true - exists, false - doesn't exist)
15 	 */
16 	function exists(uint256 _tokenId) external view returns(bool);
17 
18 	/**
19 	 * @dev Creates new token with token ID specified
20 	 *      and assigns an ownership `_to` for this token
21 	 *
22 	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
23 	 *      Prefer the use of `saveMint` instead of `mint`.
24 	 *
25 	 * @dev Should have a restricted access handled by the implementation
26 	 *
27 	 * @param _to an address to mint token to
28 	 * @param _tokenId ID of the token to mint
29 	 */
30 	function mint(address _to, uint256 _tokenId) external;
31 
32 	/**
33 	 * @dev Creates new tokens starting with token ID specified
34 	 *      and assigns an ownership `_to` for these tokens
35 	 *
36 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
37 	 *
38 	 * @dev n must be greater or equal 2: `n > 1`
39 	 *
40 	 * @dev Unsafe: doesn't execute `onERC721Received` on the receiver.
41 	 *      Prefer the use of `saveMintBatch` instead of `mintBatch`.
42 	 *
43 	 * @dev Should have a restricted access handled by the implementation
44 	 *
45 	 * @param _to an address to mint tokens to
46 	 * @param _tokenId ID of the first token to mint
47 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
48 	 */
49 	function mintBatch(address _to, uint256 _tokenId, uint256 n) external;
50 
51 	/**
52 	 * @dev Creates new token with token ID specified
53 	 *      and assigns an ownership `_to` for this token
54 	 *
55 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
56 	 *      `onERC721Received` on `_to` and throws if the return value is not
57 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
58 	 *
59 	 * @dev Should have a restricted access handled by the implementation
60 	 *
61 	 * @param _to an address to mint token to
62 	 * @param _tokenId ID of the token to mint
63 	 */
64 	function safeMint(address _to, uint256 _tokenId) external;
65 
66 	/**
67 	 * @dev Creates new token with token ID specified
68 	 *      and assigns an ownership `_to` for this token
69 	 *
70 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
71 	 *      `onERC721Received` on `_to` and throws if the return value is not
72 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
73 	 *
74 	 * @dev Should have a restricted access handled by the implementation
75 	 *
76 	 * @param _to an address to mint token to
77 	 * @param _tokenId ID of the token to mint
78 	 * @param _data additional data with no specified format, sent in call to `_to`
79 	 */
80 	function safeMint(address _to, uint256 _tokenId, bytes memory _data) external;
81 
82 	/**
83 	 * @dev Creates new tokens starting with token ID specified
84 	 *      and assigns an ownership `_to` for these tokens
85 	 *
86 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
87 	 *
88 	 * @dev n must be greater or equal 2: `n > 1`
89 	 *
90 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
91 	 *      `onERC721Received` on `_to` and throws if the return value is not
92 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
93 	 *
94 	 * @dev Should have a restricted access handled by the implementation
95 	 *
96 	 * @param _to an address to mint token to
97 	 * @param _tokenId ID of the token to mint
98 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
99 	 */
100 	function safeMintBatch(address _to, uint256 _tokenId, uint256 n) external;
101 
102 	/**
103 	 * @dev Creates new tokens starting with token ID specified
104 	 *      and assigns an ownership `_to` for these tokens
105 	 *
106 	 * @dev Token IDs to be minted: [_tokenId, _tokenId + n)
107 	 *
108 	 * @dev n must be greater or equal 2: `n > 1`
109 	 *
110 	 * @dev Checks if `_to` is a smart contract (code size > 0). If so, it calls
111 	 *      `onERC721Received` on `_to` and throws if the return value is not
112 	 *      `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
113 	 *
114 	 * @dev Should have a restricted access handled by the implementation
115 	 *
116 	 * @param _to an address to mint token to
117 	 * @param _tokenId ID of the token to mint
118 	 * @param n how many tokens to mint, sequentially increasing the _tokenId
119 	 * @param _data additional data with no specified format, sent in call to `_to`
120 	 */
121 	function safeMintBatch(address _to, uint256 _tokenId, uint256 n, bytes memory _data) external;
122 }
123 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Contract module that helps prevent reentrant calls to a function.
132  *
133  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
134  * available, which can be applied to functions to make sure there are no nested
135  * (reentrant) calls to them.
136  *
137  * Note that because there is a single `nonReentrant` guard, functions marked as
138  * `nonReentrant` may not call one another. This can be worked around by making
139  * those functions `private`, and then adding `external` `nonReentrant` entry
140  * points to them.
141  *
142  * TIP: If you would like to learn more about reentrancy and alternative ways
143  * to protect against it, check out our blog post
144  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
145  */
146 abstract contract ReentrancyGuard {
147     // Booleans are more expensive than uint256 or any type that takes up a full
148     // word because each write operation emits an extra SLOAD to first read the
149     // slot's contents, replace the bits taken up by the boolean, and then write
150     // back. This is the compiler's defense against contract upgrades and
151     // pointer aliasing, and it cannot be disabled.
152 
153     // The values being non-zero value makes deployment a bit more expensive,
154     // but in exchange the refund on every call to nonReentrant will be lower in
155     // amount. Since refunds are capped to a percentage of the total
156     // transaction's gas, it is best to keep them low in cases like this one, to
157     // increase the likelihood of the full refund coming into effect.
158     uint256 private constant _NOT_ENTERED = 1;
159     uint256 private constant _ENTERED = 2;
160 
161     uint256 private _status;
162 
163     constructor() {
164         _status = _NOT_ENTERED;
165     }
166 
167     /**
168      * @dev Prevents a contract from calling itself, directly or indirectly.
169      * Calling a `nonReentrant` function from another `nonReentrant`
170      * function is not supported. It is possible to prevent this from happening
171      * by making the `nonReentrant` function external, and making it call a
172      * `private` function that does the actual work.
173      */
174     modifier nonReentrant() {
175         // On the first call to nonReentrant, _notEntered will be true
176         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
177 
178         // Any calls to nonReentrant after this point will fail
179         _status = _ENTERED;
180 
181         _;
182 
183         // By storing the original value once again, a refund is triggered (see
184         // https://eips.ethereum.org/EIPS/eip-2200)
185         _status = _NOT_ENTERED;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/utils/Address.sol
190 
191 
192 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Collection of functions related to the address type
198  */
199 library Address {
200     /**
201      * @dev Returns true if `account` is a contract.
202      *
203      * [IMPORTANT]
204      * ====
205      * It is unsafe to assume that an address for which this function returns
206      * false is an externally-owned account (EOA) and not a contract.
207      *
208      * Among others, `isContract` will return false for the following
209      * types of addresses:
210      *
211      *  - an externally-owned account
212      *  - a contract in construction
213      *  - an address where a contract will be created
214      *  - an address where a contract lived, but was destroyed
215      * ====
216      */
217     function isContract(address account) internal view returns (bool) {
218         // This method relies on extcodesize, which returns 0 for contracts in
219         // construction, since the code is only stored at the end of the
220         // constructor execution.
221 
222         uint256 size;
223         assembly {
224             size := extcodesize(account)
225         }
226         return size > 0;
227     }
228 
229     /**
230      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
231      * `recipient`, forwarding all available gas and reverting on errors.
232      *
233      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
234      * of certain opcodes, possibly making contracts go over the 2300 gas limit
235      * imposed by `transfer`, making them unable to receive funds via
236      * `transfer`. {sendValue} removes this limitation.
237      *
238      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
239      *
240      * IMPORTANT: because control is transferred to `recipient`, care must be
241      * taken to not create reentrancy vulnerabilities. Consider using
242      * {ReentrancyGuard} or the
243      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
244      */
245     function sendValue(address payable recipient, uint256 amount) internal {
246         require(address(this).balance >= amount, "Address: insufficient balance");
247 
248         (bool success, ) = recipient.call{value: amount}("");
249         require(success, "Address: unable to send value, recipient may have reverted");
250     }
251 
252     /**
253      * @dev Performs a Solidity function call using a low level `call`. A
254      * plain `call` is an unsafe replacement for a function call: use this
255      * function instead.
256      *
257      * If `target` reverts with a revert reason, it is bubbled up by this
258      * function (like regular Solidity function calls).
259      *
260      * Returns the raw returned data. To convert to the expected return value,
261      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
262      *
263      * Requirements:
264      *
265      * - `target` must be a contract.
266      * - calling `target` with `data` must not revert.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
271         return functionCall(target, data, "Address: low-level call failed");
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
276      * `errorMessage` as a fallback revert reason when `target` reverts.
277      *
278      * _Available since v3.1._
279      */
280     function functionCall(
281         address target,
282         bytes memory data,
283         string memory errorMessage
284     ) internal returns (bytes memory) {
285         return functionCallWithValue(target, data, 0, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but also transferring `value` wei to `target`.
291      *
292      * Requirements:
293      *
294      * - the calling contract must have an ETH balance of at least `value`.
295      * - the called Solidity function must be `payable`.
296      *
297      * _Available since v3.1._
298      */
299     function functionCallWithValue(
300         address target,
301         bytes memory data,
302         uint256 value
303     ) internal returns (bytes memory) {
304         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
305     }
306 
307     /**
308      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
309      * with `errorMessage` as a fallback revert reason when `target` reverts.
310      *
311      * _Available since v3.1._
312      */
313     function functionCallWithValue(
314         address target,
315         bytes memory data,
316         uint256 value,
317         string memory errorMessage
318     ) internal returns (bytes memory) {
319         require(address(this).balance >= value, "Address: insufficient balance for call");
320         require(isContract(target), "Address: call to non-contract");
321 
322         (bool success, bytes memory returndata) = target.call{value: value}(data);
323         return verifyCallResult(success, returndata, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
333         return functionStaticCall(target, data, "Address: low-level static call failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
338      * but performing a static call.
339      *
340      * _Available since v3.3._
341      */
342     function functionStaticCall(
343         address target,
344         bytes memory data,
345         string memory errorMessage
346     ) internal view returns (bytes memory) {
347         require(isContract(target), "Address: static call to non-contract");
348 
349         (bool success, bytes memory returndata) = target.staticcall(data);
350         return verifyCallResult(success, returndata, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
365      * but performing a delegate call.
366      *
367      * _Available since v3.4._
368      */
369     function functionDelegateCall(
370         address target,
371         bytes memory data,
372         string memory errorMessage
373     ) internal returns (bytes memory) {
374         require(isContract(target), "Address: delegate call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.delegatecall(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
382      * revert reason using the provided one.
383      *
384      * _Available since v4.3._
385      */
386     function verifyCallResult(
387         bool success,
388         bytes memory returndata,
389         string memory errorMessage
390     ) internal pure returns (bytes memory) {
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
410 
411 
412 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
413 
414 pragma solidity ^0.8.0;
415 
416 /**
417  * @dev Interface of the ERC20 standard as defined in the EIP.
418  */
419 interface IERC20 {
420     /**
421      * @dev Returns the amount of tokens in existence.
422      */
423     function totalSupply() external view returns (uint256);
424 
425     /**
426      * @dev Returns the amount of tokens owned by `account`.
427      */
428     function balanceOf(address account) external view returns (uint256);
429 
430     /**
431      * @dev Moves `amount` tokens from the caller's account to `recipient`.
432      *
433      * Returns a boolean value indicating whether the operation succeeded.
434      *
435      * Emits a {Transfer} event.
436      */
437     function transfer(address recipient, uint256 amount) external returns (bool);
438 
439     /**
440      * @dev Returns the remaining number of tokens that `spender` will be
441      * allowed to spend on behalf of `owner` through {transferFrom}. This is
442      * zero by default.
443      *
444      * This value changes when {approve} or {transferFrom} are called.
445      */
446     function allowance(address owner, address spender) external view returns (uint256);
447 
448     /**
449      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
450      *
451      * Returns a boolean value indicating whether the operation succeeded.
452      *
453      * IMPORTANT: Beware that changing an allowance with this method brings the risk
454      * that someone may use both the old and the new allowance by unfortunate
455      * transaction ordering. One possible solution to mitigate this race
456      * condition is to first reduce the spender's allowance to 0 and set the
457      * desired value afterwards:
458      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
459      *
460      * Emits an {Approval} event.
461      */
462     function approve(address spender, uint256 amount) external returns (bool);
463 
464     /**
465      * @dev Moves `amount` tokens from `sender` to `recipient` using the
466      * allowance mechanism. `amount` is then deducted from the caller's
467      * allowance.
468      *
469      * Returns a boolean value indicating whether the operation succeeded.
470      *
471      * Emits a {Transfer} event.
472      */
473     function transferFrom(
474         address sender,
475         address recipient,
476         uint256 amount
477     ) external returns (bool);
478 
479     /**
480      * @dev Emitted when `value` tokens are moved from one account (`from`) to
481      * another (`to`).
482      *
483      * Note that `value` may be zero.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 value);
486 
487     /**
488      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
489      * a call to {approve}. `value` is the new allowance.
490      */
491     event Approval(address indexed owner, address indexed spender, uint256 value);
492 }
493 
494 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
495 
496 
497 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
498 
499 pragma solidity ^0.8.0;
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure (when the token
506  * contract returns false). Tokens that return no value (and instead revert or
507  * throw on failure) are also supported, non-reverting calls are assumed to be
508  * successful.
509  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
510  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
511  */
512 library SafeERC20 {
513     using Address for address;
514 
515     function safeTransfer(
516         IERC20 token,
517         address to,
518         uint256 value
519     ) internal {
520         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
521     }
522 
523     function safeTransferFrom(
524         IERC20 token,
525         address from,
526         address to,
527         uint256 value
528     ) internal {
529         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
530     }
531 
532     /**
533      * @dev Deprecated. This function has issues similar to the ones found in
534      * {IERC20-approve}, and its usage is discouraged.
535      *
536      * Whenever possible, use {safeIncreaseAllowance} and
537      * {safeDecreaseAllowance} instead.
538      */
539     function safeApprove(
540         IERC20 token,
541         address spender,
542         uint256 value
543     ) internal {
544         // safeApprove should only be called when setting an initial allowance,
545         // or when resetting it to zero. To increase and decrease it, use
546         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
547         require(
548             (value == 0) || (token.allowance(address(this), spender) == 0),
549             "SafeERC20: approve from non-zero to non-zero allowance"
550         );
551         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
552     }
553 
554     function safeIncreaseAllowance(
555         IERC20 token,
556         address spender,
557         uint256 value
558     ) internal {
559         uint256 newAllowance = token.allowance(address(this), spender) + value;
560         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
561     }
562 
563     function safeDecreaseAllowance(
564         IERC20 token,
565         address spender,
566         uint256 value
567     ) internal {
568         unchecked {
569             uint256 oldAllowance = token.allowance(address(this), spender);
570             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
571             uint256 newAllowance = oldAllowance - value;
572             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
573         }
574     }
575 
576     /**
577      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
578      * on the return value: the return value is optional (but if data is returned, it must not be false).
579      * @param token The token targeted by the call.
580      * @param data The call data (encoded using abi.encode or one of its variants).
581      */
582     function _callOptionalReturn(IERC20 token, bytes memory data) private {
583         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
584         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
585         // the target address contains contract code and also asserts for success in the low-level call.
586 
587         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
588         if (returndata.length > 0) {
589             // Return data is optional
590             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
591         }
592     }
593 }
594 
595 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
596 
597 
598 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 /**
603  * @dev Interface of the ERC165 standard, as defined in the
604  * https://eips.ethereum.org/EIPS/eip-165[EIP].
605  *
606  * Implementers can declare support of contract interfaces, which can then be
607  * queried by others ({ERC165Checker}).
608  *
609  * For an implementation, see {ERC165}.
610  */
611 interface IERC165 {
612     /**
613      * @dev Returns true if this contract implements the interface defined by
614      * `interfaceId`. See the corresponding
615      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
616      * to learn more about how these ids are created.
617      *
618      * This function call must use less than 30 000 gas.
619      */
620     function supportsInterface(bytes4 interfaceId) external view returns (bool);
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 
631 /**
632  * @dev Required interface of an ERC721 compliant contract.
633  */
634 interface IERC721 is IERC165 {
635     /**
636      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
637      */
638     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
642      */
643     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
644 
645     /**
646      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
647      */
648     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
649 
650     /**
651      * @dev Returns the number of tokens in ``owner``'s account.
652      */
653     function balanceOf(address owner) external view returns (uint256 balance);
654 
655     /**
656      * @dev Returns the owner of the `tokenId` token.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must exist.
661      */
662     function ownerOf(uint256 tokenId) external view returns (address owner);
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
666      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId
682     ) external;
683 
684     /**
685      * @dev Transfers `tokenId` token from `from` to `to`.
686      *
687      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must be owned by `from`.
694      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
695      *
696      * Emits a {Transfer} event.
697      */
698     function transferFrom(
699         address from,
700         address to,
701         uint256 tokenId
702     ) external;
703 
704     /**
705      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
706      * The approval is cleared when the token is transferred.
707      *
708      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
709      *
710      * Requirements:
711      *
712      * - The caller must own the token or be an approved operator.
713      * - `tokenId` must exist.
714      *
715      * Emits an {Approval} event.
716      */
717     function approve(address to, uint256 tokenId) external;
718 
719     /**
720      * @dev Returns the account approved for `tokenId` token.
721      *
722      * Requirements:
723      *
724      * - `tokenId` must exist.
725      */
726     function getApproved(uint256 tokenId) external view returns (address operator);
727 
728     /**
729      * @dev Approve or remove `operator` as an operator for the caller.
730      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
731      *
732      * Requirements:
733      *
734      * - The `operator` cannot be the caller.
735      *
736      * Emits an {ApprovalForAll} event.
737      */
738     function setApprovalForAll(address operator, bool _approved) external;
739 
740     /**
741      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
742      *
743      * See {setApprovalForAll}
744      */
745     function isApprovedForAll(address owner, address operator) external view returns (bool);
746 
747     /**
748      * @dev Safely transfers `tokenId` token from `from` to `to`.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
756      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
757      *
758      * Emits a {Transfer} event.
759      */
760     function safeTransferFrom(
761         address from,
762         address to,
763         uint256 tokenId,
764         bytes calldata data
765     ) external;
766 }
767 
768 // File: @openzeppelin/contracts/interfaces/IERC721.sol
769 
770 
771 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC721.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 // File: @openzeppelin/contracts/interfaces/IERC165.sol
777 
778 
779 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
780 
781 pragma solidity ^0.8.0;
782 
783 
784 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
785 
786 
787 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 /**
792  * @dev These functions deal with verification of Merkle Trees proofs.
793  *
794  * The proofs can be generated using the JavaScript library
795  * https://github.com/miguelmota/merkletreejs[merkletreejs].
796  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
797  *
798  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
799  */
800 library MerkleProof {
801     /**
802      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
803      * defined by `root`. For this, a `proof` must be provided, containing
804      * sibling hashes on the branch from the leaf to the root of the tree. Each
805      * pair of leaves and each pair of pre-images are assumed to be sorted.
806      */
807     function verify(
808         bytes32[] memory proof,
809         bytes32 root,
810         bytes32 leaf
811     ) internal pure returns (bool) {
812         return processProof(proof, leaf) == root;
813     }
814 
815     /**
816      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
817      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
818      * hash matches the root of the tree. When processing the proof, the pairs
819      * of leafs & pre-images are assumed to be sorted.
820      *
821      * _Available since v4.4._
822      */
823     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
824         bytes32 computedHash = leaf;
825         for (uint256 i = 0; i < proof.length; i++) {
826             bytes32 proofElement = proof[i];
827             if (computedHash <= proofElement) {
828                 // Hash(current computed hash + current element of the proof)
829                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
830             } else {
831                 // Hash(current element of the proof + current computed hash)
832                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
833             }
834         }
835         return computedHash;
836     }
837 }
838 
839 // File: @openzeppelin/contracts/utils/Context.sol
840 
841 
842 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @dev Provides information about the current execution context, including the
848  * sender of the transaction and its data. While these are generally available
849  * via msg.sender and msg.data, they should not be accessed in such a direct
850  * manner, since when dealing with meta-transactions the account sending and
851  * paying for execution may not be the actual sender (as far as an application
852  * is concerned).
853  *
854  * This contract is only required for intermediate, library-like contracts.
855  */
856 abstract contract Context {
857     function _msgSender() internal view virtual returns (address) {
858         return msg.sender;
859     }
860 
861     function _msgData() internal view virtual returns (bytes calldata) {
862         return msg.data;
863     }
864 }
865 
866 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
867 
868 
869 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
870 
871 pragma solidity ^0.8.0;
872 
873 
874 
875 
876 /**
877  * @title PaymentSplitter
878  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
879  * that the Ether will be split in this way, since it is handled transparently by the contract.
880  *
881  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
882  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
883  * an amount proportional to the percentage of total shares they were assigned.
884  *
885  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
886  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
887  * function.
888  *
889  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
890  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
891  * to run tests before sending real value to this contract.
892  */
893 contract PaymentSplitter is Context {
894     event PayeeAdded(address account, uint256 shares);
895     event PaymentReleased(address to, uint256 amount);
896     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
897     event PaymentReceived(address from, uint256 amount);
898 
899     uint256 private _totalShares;
900     uint256 private _totalReleased;
901 
902     mapping(address => uint256) private _shares;
903     mapping(address => uint256) private _released;
904     address[] private _payees;
905 
906     mapping(IERC20 => uint256) private _erc20TotalReleased;
907     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
908 
909     /**
910      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
911      * the matching position in the `shares` array.
912      *
913      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
914      * duplicates in `payees`.
915      */
916     constructor(address[] memory payees, uint256[] memory shares_) payable {
917         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
918         require(payees.length > 0, "PaymentSplitter: no payees");
919 
920         for (uint256 i = 0; i < payees.length; i++) {
921             _addPayee(payees[i], shares_[i]);
922         }
923     }
924 
925     /**
926      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
927      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
928      * reliability of the events, and not the actual splitting of Ether.
929      *
930      * To learn more about this see the Solidity documentation for
931      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
932      * functions].
933      */
934     receive() external payable virtual {
935         emit PaymentReceived(_msgSender(), msg.value);
936     }
937 
938     /**
939      * @dev Getter for the total shares held by payees.
940      */
941     function totalShares() public view returns (uint256) {
942         return _totalShares;
943     }
944 
945     /**
946      * @dev Getter for the total amount of Ether already released.
947      */
948     function totalReleased() public view returns (uint256) {
949         return _totalReleased;
950     }
951 
952     /**
953      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
954      * contract.
955      */
956     function totalReleased(IERC20 token) public view returns (uint256) {
957         return _erc20TotalReleased[token];
958     }
959 
960     /**
961      * @dev Getter for the amount of shares held by an account.
962      */
963     function shares(address account) public view returns (uint256) {
964         return _shares[account];
965     }
966 
967     /**
968      * @dev Getter for the amount of Ether already released to a payee.
969      */
970     function released(address account) public view returns (uint256) {
971         return _released[account];
972     }
973 
974     /**
975      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
976      * IERC20 contract.
977      */
978     function released(IERC20 token, address account) public view returns (uint256) {
979         return _erc20Released[token][account];
980     }
981 
982     /**
983      * @dev Getter for the address of the payee number `index`.
984      */
985     function payee(uint256 index) public view returns (address) {
986         return _payees[index];
987     }
988 
989     /**
990      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
991      * total shares and their previous withdrawals.
992      */
993     function release(address payable account) public virtual {
994         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
995 
996         uint256 totalReceived = address(this).balance + totalReleased();
997         uint256 payment = _pendingPayment(account, totalReceived, released(account));
998 
999         require(payment != 0, "PaymentSplitter: account is not due payment");
1000 
1001         _released[account] += payment;
1002         _totalReleased += payment;
1003 
1004         Address.sendValue(account, payment);
1005         emit PaymentReleased(account, payment);
1006     }
1007 
1008     /**
1009      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1010      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1011      * contract.
1012      */
1013     function release(IERC20 token, address account) public virtual {
1014         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1015 
1016         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1017         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1018 
1019         require(payment != 0, "PaymentSplitter: account is not due payment");
1020 
1021         _erc20Released[token][account] += payment;
1022         _erc20TotalReleased[token] += payment;
1023 
1024         SafeERC20.safeTransfer(token, account, payment);
1025         emit ERC20PaymentReleased(token, account, payment);
1026     }
1027 
1028     /**
1029      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1030      * already released amounts.
1031      */
1032     function _pendingPayment(
1033         address account,
1034         uint256 totalReceived,
1035         uint256 alreadyReleased
1036     ) private view returns (uint256) {
1037         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1038     }
1039 
1040     /**
1041      * @dev Add a new payee to the contract.
1042      * @param account The address of the payee to add.
1043      * @param shares_ The number of shares owned by the payee.
1044      */
1045     function _addPayee(address account, uint256 shares_) private {
1046         require(account != address(0), "PaymentSplitter: account is the zero address");
1047         require(shares_ > 0, "PaymentSplitter: shares are 0");
1048         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1049 
1050         _payees.push(account);
1051         _shares[account] = shares_;
1052         _totalShares = _totalShares + shares_;
1053         emit PayeeAdded(account, shares_);
1054     }
1055 }
1056 
1057 // File: @openzeppelin/contracts/access/Ownable.sol
1058 
1059 
1060 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1061 
1062 pragma solidity ^0.8.0;
1063 
1064 
1065 /**
1066  * @dev Contract module which provides a basic access control mechanism, where
1067  * there is an account (an owner) that can be granted exclusive access to
1068  * specific functions.
1069  *
1070  * By default, the owner account will be the one that deploys the contract. This
1071  * can later be changed with {transferOwnership}.
1072  *
1073  * This module is used through inheritance. It will make available the modifier
1074  * `onlyOwner`, which can be applied to your functions to restrict their use to
1075  * the owner.
1076  */
1077 abstract contract Ownable is Context {
1078     address private _owner;
1079 
1080     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1081 
1082     /**
1083      * @dev Initializes the contract setting the deployer as the initial owner.
1084      */
1085     constructor() {
1086         _transferOwnership(_msgSender());
1087     }
1088 
1089     /**
1090      * @dev Returns the address of the current owner.
1091      */
1092     function owner() public view virtual returns (address) {
1093         return _owner;
1094     }
1095 
1096     /**
1097      * @dev Throws if called by any account other than the owner.
1098      */
1099     modifier onlyOwner() {
1100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1101         _;
1102     }
1103 
1104     /**
1105      * @dev Leaves the contract without owner. It will not be possible to call
1106      * `onlyOwner` functions anymore. Can only be called by the current owner.
1107      *
1108      * NOTE: Renouncing ownership will leave the contract without an owner,
1109      * thereby removing any functionality that is only available to the owner.
1110      */
1111     function renounceOwnership() public virtual onlyOwner {
1112         _transferOwnership(address(0));
1113     }
1114 
1115     /**
1116      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1117      * Can only be called by the current owner.
1118      */
1119     function transferOwnership(address newOwner) public virtual onlyOwner {
1120         require(newOwner != address(0), "Ownable: new owner is the zero address");
1121         _transferOwnership(newOwner);
1122     }
1123 
1124     /**
1125      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1126      * Internal function without access restriction.
1127      */
1128     function _transferOwnership(address newOwner) internal virtual {
1129         address oldOwner = _owner;
1130         _owner = newOwner;
1131         emit OwnershipTransferred(oldOwner, newOwner);
1132     }
1133 }
1134 
1135 // File: contracts/MintableSale.sol
1136 
1137 
1138 pragma solidity ^0.8.10;
1139 
1140 
1141 
1142 
1143 
1144 
1145 
1146 
1147 /**
1148  * @title Mintable Sale
1149  *
1150  * @notice Mintable Sale sales fixed amount of NFTs (tokens) for a fixed price in a fixed period of time;
1151  *      it can be used in a 10k sale campaign and the smart contract is generic and
1152  *      can sell any type of mintable NFT (see MintableERC721 interface)
1153  *
1154  * @dev Fixed parameters should not be changed mid sale because the minted per walet gets reset each time
1155  *
1156  * @dev When buying a token from this smart contract, next token is minted to the recipient
1157  *
1158  * @dev Supports functionality to limit amount of tokens that can be minted to each address
1159  *
1160  * @dev Deployment and setup:
1161  *      1. Deploy smart contract, specify smart contract address during the deployment:
1162  *         - Mintable ER721 deployed instance address
1163  *      2. Execute `initialize` function and set up the sale parameters;
1164  *         sale is not active until it's initialized
1165  *
1166  */
1167 contract MintableSale is Ownable, PaymentSplitter, ReentrancyGuard {
1168   // Use Zeppelin MerkleProof Library to verify Merkle proofs
1169   using MerkleProof for bytes32[];
1170 
1171   // ----- SLOT.1 (192/256)
1172   /**
1173    * @dev Next token ID to mint;
1174    *      initially this is the first "free" ID which can be minted;
1175    *      at any point in time this should point to a free, mintable ID
1176    *      for the token
1177    *
1178    * @dev `nextId` cannot be zero, we do not ever mint NFTs with zero IDs
1179    */
1180   uint32 public nextId = 1;
1181 
1182   /**
1183    * @dev Last token ID to mint;
1184    *      once `nextId` exceeds `finalId` the sale pauses
1185    */
1186   uint32 public finalId;
1187 
1188   /**
1189    * @notice Once set, limits the amount of tokens one can buy in a single transaction;
1190    *       When unset (zero) the amount of tokens is limited only by block size and
1191    *       amount of tokens left for sale
1192    */
1193   uint32 public batchLimit;
1194 
1195   /**
1196    * @notice Once set, limits the amount of tokens one address can buy for the duration of the sale;
1197    *       When unset (zero) the amount of tokens is limited only by the amount of tokens left for sale
1198    */
1199   uint32 public mintLimit;
1200 
1201   /**
1202    * @notice Counter of the tokens sold (minted) by this sale smart contract
1203    */
1204   uint32 public soldCounter;
1205 
1206   /**
1207    * @notice Merkle tree root to validate (address, cost, startDate, endDate)
1208    *         tuples
1209    */
1210   bytes32 public root;
1211 
1212   // ----- NON-SLOTTED
1213   /**
1214    * @dev Mintable ERC721 contract address to mint
1215    */
1216   address public immutable tokenContract;
1217 
1218   // ----- NON-SLOTTED
1219   /**
1220    * @dev Number of mints performed by address
1221    */
1222   mapping(uint32 => mapping(address => uint32)) public mints;
1223 
1224   // ----- NON-SLOTTED
1225   /**
1226    * @dev Is this a public sale or a private one (Merkle root verify or not)
1227    */
1228   bool public isPublicSale = false;
1229 
1230   // ----- NON-SLOTTED
1231   /**
1232    * @dev Sale number for contract - starts from 0 and increments to 1 for each new sale.
1233    * Used for resetting mints per wallet each sale.
1234    */
1235   uint32 public saleNumber = 0;
1236   /**
1237    * @dev Fired in initialize()
1238    *
1239    * @param _by an address which executed the initialization
1240    * @param _nextId next ID of the token to mint
1241    * @param _finalId final ID of the token to mint
1242    * @param _batchLimit how many tokens is allowed to buy in a single transaction
1243    * @param _root merkle tree root
1244    */
1245   event Initialized(
1246     address indexed _by,
1247     uint32 _nextId,
1248     uint32 _finalId,
1249     uint32 _batchLimit,
1250     uint32 _limit,
1251     bytes32 _root,
1252     bool _isPublicSale
1253   );
1254 
1255   /**
1256    * @dev Fired in buy(), buyTo(), buySingle(), and buySingleTo()
1257    *
1258    * @param _by an address which executed and payed the transaction, probably a buyer
1259    * @param _to an address which received token(s) minted
1260    * @param _amount number of tokens minted
1261    * @param _value ETH amount charged
1262    */
1263   event Bought(
1264     address indexed _by,
1265     address indexed _to,
1266     uint256 _amount,
1267     uint256 _value
1268   );
1269 
1270   /**
1271    * @dev Creates/deploys MintableSale and binds it to Mintable ERC721
1272    *      smart contract on construction
1273    *
1274    * @param _tokenContract deployed Mintable ERC721 smart contract; sale will mint ERC721
1275    *      tokens of that type to the recipient
1276    */
1277   constructor(
1278     address _tokenContract,
1279     address[] memory addressList,
1280     uint256[] memory shareList
1281   ) PaymentSplitter(addressList, shareList) {
1282     // verify the input is set
1283     require(_tokenContract != address(0), "token contract is not set");
1284 
1285     // verify input is valid smart contract of the expected interfaces
1286     require(
1287       IERC165(_tokenContract).supportsInterface(
1288         type(IMintableERC721).interfaceId
1289       ),
1290       "unexpected token contract type"
1291     );
1292 
1293     // assign the addresses
1294     tokenContract = _tokenContract;
1295   }
1296 
1297   /**
1298    * @notice Number of tokens left on sale
1299    *
1300    * @dev Doesn't take into account if sale is active or not
1301    *
1302    * @return number of tokens left on sale
1303    */
1304   function itemsOnSale() public view returns (uint32) {
1305     // calculate items left on sale, taking into account that
1306     // finalId is on sale (inclusive bound)
1307     return finalId >= nextId ? finalId + 1 - nextId : 0;
1308   }
1309 
1310   /**
1311    * @notice Number of tokens available on sale
1312    *
1313    * @dev Takes into account if sale is active or not, doesn't throw,
1314    *      returns zero if sale is inactive
1315    *
1316    * @return number of tokens available on sale
1317    */
1318   function itemsAvailable() public view returns (uint32) {
1319     // delegate to itemsOnSale() if sale is active, return zero otherwise
1320     return isActive() ? itemsOnSale() : 0;
1321   }
1322 
1323   /**
1324    * @notice Active sale is an operational sale capable of minting and selling tokens
1325    *
1326    * @dev The sale is active when all the requirements below are met:
1327    *      1. `finalId` is not reached (`nextId <= finalId`)
1328    *
1329    * @dev Function is marked as virtual to be overridden in the helper test smart contract (mock)
1330    *      in order to test how it affects the sale process
1331    *
1332    * @return true if sale is active (operational) and can sell tokens, false otherwise
1333    */
1334   function isActive() public view virtual returns (bool) {
1335     // evaluate sale state based on the internal state variables and return
1336     return nextId <= finalId;
1337   }
1338 
1339   /**
1340    * @dev Restricted access function to set up sale parameters, all at once,
1341    *      or any subset of them
1342    *
1343    * @dev To skip parameter initialization, set it to `-1`,
1344    *      that is a maximum value for unsigned integer of the corresponding type;
1345    *      `_aliSource` and `_aliValue` must both be either set or skipped
1346    *
1347    * @dev Example: following initialization will update only _itemPrice and _batchLimit,
1348    *      leaving the rest of the fields unchanged
1349    *      initialize(
1350    *          0xFFFFFFFF,
1351    *          0xFFFFFFFF,
1352    *          10,
1353    *          0xFFFFFFFF
1354    *      )
1355    *
1356    * @dev Requires next ID to be greater than zero (strict): `_nextId > 0`
1357    *
1358    * @dev Requires transaction sender to have `ROLE_SALE_MANAGER` role
1359    *
1360    * @param _nextId next ID of the token to mint, will be increased
1361    *      in smart contract storage after every successful buy
1362    * @param _finalId final ID of the token to mint; sale is capable of producing
1363    *      `_finalId - _nextId + 1` tokens
1364    *      when current time is within _saleStart (inclusive) and _saleEnd (exclusive)
1365    * @param _batchLimit how many tokens is allowed to buy in a single transaction,
1366    *      set to zero to disable the limit
1367    * @param _mintLimit how many tokens is allowed to buy for the duration of the sale,
1368    *      set to zero to disable the limit
1369    * @param _root merkle tree root used to verify whether an address can mint
1370    */
1371   function initialize(
1372     uint32 _nextId, // <<<--- keep type in sync with the body type(uint32).max !!!
1373     uint32 _finalId, // <<<--- keep type in sync with the body type(uint32).max !!!
1374     uint32 _batchLimit, // <<<--- keep type in sync with the body type(uint32).max !!!
1375     uint32 _mintLimit, // <<<--- keep type in sync with the body type(uint32).max !!!
1376     bytes32 _root, // <<<--- keep type in sync with the 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF !!!
1377     bool _isPublicSale
1378   ) public onlyOwner {
1379     // verify the inputs
1380     require(_nextId > 0, "zero nextId");
1381 
1382     // no need to verify extra parameters - "incorrect" values will deactivate the sale
1383 
1384     // initialize contract state based on the values supplied
1385     // take into account our convention that value `-1` means "do not set"
1386     // 0xFFFFFFFFFFFFFFFF, 64 bits
1387     // 0xFFFFFFFF, 32 bits
1388     if (_nextId != type(uint32).max) {
1389       nextId = _nextId;
1390     }
1391     // 0xFFFFFFFF, 32 bits
1392     if (_finalId != type(uint32).max) {
1393       finalId = _finalId;
1394     }
1395     // 0xFFFFFFFF, 32 bits
1396     if (_batchLimit != type(uint32).max) {
1397       batchLimit = _batchLimit;
1398     }
1399     // 0xFFFFFFFF, 32 bits
1400     if (_mintLimit != type(uint32).max) {
1401       mintLimit = _mintLimit;
1402     }
1403     // 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF, 256 bits
1404     if (
1405       _root !=
1406       0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
1407     ) {
1408       root = _root;
1409     }
1410 
1411     isPublicSale = _isPublicSale;
1412 
1413     saleNumber++;
1414 
1415     // emit an event - read values from the storage since not all of them might be set
1416     emit Initialized(
1417       msg.sender,
1418       nextId,
1419       finalId,
1420       batchLimit,
1421       mintLimit,
1422       root,
1423       isPublicSale
1424     );
1425   }
1426 
1427   /**
1428    * @notice Buys several (at least two) tokens in a batch.
1429    *      Accepts ETH as payment and mints a token
1430    *
1431    * @param _amount amount of tokens to create, two or more
1432    */
1433   function buy(
1434     uint256 _price,
1435     uint256 _start,
1436     uint256 _end,
1437     bytes32[] memory _proof,
1438     uint32 _amount
1439   ) public payable {
1440     // delegate to `buyTo` with the transaction sender set to be a recipient
1441     buyTo(msg.sender, _price, _start, _end, _proof, _amount);
1442   }
1443 
1444    /**
1445    * @notice Buys several (at least two) tokens in a batch.
1446    *      Accepts ETH as payment and mints a token
1447    *
1448    * @param _amount amount of tokens to create, two or more
1449    */
1450   function devBuy(
1451     uint256 _price,
1452     uint256 _start,
1453     uint256 _end,
1454     bytes32[] memory _proof,
1455     uint32 _amount
1456   ) public payable {
1457     // delegate to `buyTo` with the transaction sender set to be a recipient
1458     buyTo(msg.sender, _price, _start, _end, _proof, _amount);
1459   }
1460 
1461   /**
1462    * @notice Buys several (at least two) tokens in a batch to an address specified.
1463    *      Accepts ETH as payment and mints tokens
1464    *
1465    * @param _to address to mint tokens to
1466    * @param _amount amount of tokens to create, two or more
1467    */
1468   function buyTo(
1469     address _to,
1470     uint256 _price,
1471     uint256 _start,
1472     uint256 _end,
1473     bytes32[] memory _proof,
1474     uint32 _amount
1475   ) public payable nonReentrant {
1476     if (isPublicSale) {
1477       // disallow contracts from buying
1478       require(msg.sender == tx.origin, "Contract buys not allowed");
1479     }
1480 
1481     // construct Merkle tree leaf from the inputs supplied
1482     bytes32 leaf = buildLeaf(_price, _start, _end);
1483 
1484     // verify proof
1485     require(_proof.verify(root, leaf), "invalid proof");
1486 
1487     // verify the inputs
1488     require(_to != address(0), "recipient not set");
1489     require(
1490       _amount > 1 && (batchLimit == 0 || _amount <= batchLimit),
1491       "incorrect amount"
1492     );
1493     require(block.timestamp >= _start, "sale not yet started");
1494     require(block.timestamp <= _end, "sale ended");
1495 
1496     // verify mint limit
1497     if (mintLimit != 0) {
1498       require(
1499         mints[saleNumber][msg.sender] + _amount <= mintLimit,
1500         "mint limit reached"
1501       );
1502     }
1503 
1504     // verify there is enough items available to buy the amount
1505     // verifies sale is in active state under the hood
1506     require(
1507       itemsAvailable() >= _amount,
1508       "inactive sale or not enough items available"
1509     );
1510 
1511     // calculate the total price required and validate the transaction value
1512     uint256 totalPrice = _price * _amount;
1513     require(msg.value >= totalPrice, "not enough funds");
1514 
1515     // increment sender mints
1516     mints[saleNumber][msg.sender] += _amount;
1517 
1518     // mint token to to the recipient
1519     IMintableERC721(tokenContract).mintBatch(_to, nextId, _amount);
1520 
1521     // increment `nextId`
1522     nextId += _amount;
1523     // increment `soldCounter`
1524     soldCounter += _amount;
1525 
1526     // if ETH amount supplied exceeds the price
1527     if (msg.value > totalPrice) {
1528       // send excess amount back to sender
1529       payable(msg.sender).transfer(msg.value - totalPrice);
1530     }
1531 
1532     // emit en event
1533     emit Bought(msg.sender, _to, _amount, totalPrice);
1534   }
1535 
1536    /**
1537    * @notice Buys single token.
1538    *      Accepts ETH as payment and mints a token
1539    */
1540   function devBuySingle(
1541     uint256 _price,
1542     uint256 _start,
1543     uint256 _end,
1544     bytes32[] memory _proof
1545   ) public payable {
1546     // delegate to `buySingleTo` with the transaction sender set to be a recipient
1547     buySingleTo(msg.sender, _price, _start, _end, _proof);
1548   }
1549 
1550   /**
1551    * @notice Buys single token.
1552    *      Accepts ETH as payment and mints a token
1553    */
1554   function buySingle(
1555     uint256 _price,
1556     uint256 _start,
1557     uint256 _end,
1558     bytes32[] memory _proof
1559   ) public payable {
1560     // delegate to `buySingleTo` with the transaction sender set to be a recipient
1561     buySingleTo(msg.sender, _price, _start, _end, _proof);
1562   }
1563 
1564   /**
1565    * @notice Buys single token to an address specified.
1566    *      Accepts ETH as payment and mints a token
1567    *
1568    * @param _to address to mint token to
1569    */
1570   function buySingleTo(
1571     address _to,
1572     uint256 _price,
1573     uint256 _start,
1574     uint256 _end,
1575     bytes32[] memory _proof
1576   ) public payable nonReentrant {
1577     if (isPublicSale) {
1578       // disallow contracts from buying
1579       require(msg.sender == tx.origin, "Contract buys not allowed");
1580     }
1581     // construct Merkle tree leaf from the inputs supplied
1582     bytes32 leaf = buildLeaf(_price, _start, _end);
1583 
1584     // verify proof
1585     require(_proof.verify(root, leaf), "invalid proof");
1586 
1587     // verify the inputs and transaction value
1588     require(_to != address(0), "recipient not set");
1589     require(msg.value >= _price, "not enough funds");
1590     require(block.timestamp >= _start, "sale not yet started");
1591     require(block.timestamp <= _end, "sale ended");
1592 
1593     // verify mint limit
1594     if (mintLimit != 0) {
1595       require(
1596         mints[saleNumber][msg.sender] + 1 <= mintLimit,
1597         "mint limit reached"
1598       );
1599     }
1600 
1601     // verify sale is in active state
1602     require(isActive(), "inactive sale");
1603 
1604     // mint token to the recipient
1605     IMintableERC721(tokenContract).mint(_to, nextId);
1606 
1607     // increment `nextId`
1608     nextId++;
1609     // increment `soldCounter`
1610     soldCounter++;
1611     // increment sender mints
1612     mints[saleNumber][msg.sender]++;
1613 
1614     // if ETH amount supplied exceeds the price
1615     if (msg.value > _price) {
1616       // send excess amount back to sender
1617       payable(msg.sender).transfer(msg.value - _price);
1618     }
1619 
1620     // emit en event
1621     emit Bought(msg.sender, _to, 1, _price);
1622   }
1623 
1624   function buildLeaf(
1625     uint256 _price,
1626     uint256 _start,
1627     uint256 _end
1628   ) internal view returns (bytes32) {
1629     // construct Merkle tree leaf from the inputs supplied
1630     bytes32 leaf;
1631     if (!isPublicSale) {
1632       leaf = keccak256(abi.encodePacked(msg.sender, _price, _start, _end));
1633     } else {
1634       leaf = keccak256(abi.encodePacked(_price, _start, _end));
1635     }
1636     return leaf;
1637   }
1638 }