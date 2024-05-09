1 // File: contracts/WAGDIEGRAVE.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-06-08
5 */
6 
7 
8 /**
9  * @title MutantAssGoblinKidz contract
10  * @dev Extends ERC721A - thanks azuki
11  */
12 
13 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
14 
15 
16 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
17 
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(
78         address from,
79         address to,
80         uint256 amount
81     ) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module that helps prevent reentrant calls to a function.
107  *
108  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
109  * available, which can be applied to functions to make sure there are no nested
110  * (reentrant) calls to them.
111  *
112  * Note that because there is a single `nonReentrant` guard, functions marked as
113  * `nonReentrant` may not call one another. This can be worked around by making
114  * those functions `private`, and then adding `external` `nonReentrant` entry
115  * points to them.
116  *
117  * TIP: If you would like to learn more about reentrancy and alternative ways
118  * to protect against it, check out our blog post
119  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
120  */
121 abstract contract ReentrancyGuard {
122     // Booleans are more expensive than uint256 or any type that takes up a full
123     // word because each write operation emits an extra SLOAD to first read the
124     // slot's contents, replace the bits taken up by the boolean, and then write
125     // back. This is the compiler's defense against contract upgrades and
126     // pointer aliasing, and it cannot be disabled.
127 
128     // The values being non-zero value makes deployment a bit more expensive,
129     // but in exchange the refund on every call to nonReentrant will be lower in
130     // amount. Since refunds are capped to a percentage of the total
131     // transaction's gas, it is best to keep them low in cases like this one, to
132     // increase the likelihood of the full refund coming into effect.
133     uint256 private constant _NOT_ENTERED = 1;
134     uint256 private constant _ENTERED = 2;
135 
136     uint256 private _status;
137 
138     constructor() {
139         _status = _NOT_ENTERED;
140     }
141 
142     /**
143      * @dev Prevents a contract from calling itself, directly or indirectly.
144      * Calling a `nonReentrant` function from another `nonReentrant`
145      * function is not supported. It is possible to prevent this from happening
146      * by making the `nonReentrant` function external, and making it call a
147      * `private` function that does the actual work.
148      */
149     modifier nonReentrant() {
150         // On the first call to nonReentrant, _notEntered will be true
151         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
152 
153         // Any calls to nonReentrant after this point will fail
154         _status = _ENTERED;
155 
156         _;
157 
158         // By storing the original value once again, a refund is triggered (see
159         // https://eips.ethereum.org/EIPS/eip-2200)
160         _status = _NOT_ENTERED;
161     }
162 }
163 
164 // File: @openzeppelin/contracts/utils/Strings.sol
165 
166 
167 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
168 
169 pragma solidity ^0.8.0;
170 
171 /**
172  * @dev String operations.
173  */
174 library Strings {
175     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
179      */
180     function toString(uint256 value) internal pure returns (string memory) {
181         // Inspired by OraclizeAPI's implementation - MIT licence
182         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
183 
184         if (value == 0) {
185             return "0";
186         }
187         uint256 temp = value;
188         uint256 digits;
189         while (temp != 0) {
190             digits++;
191             temp /= 10;
192         }
193         bytes memory buffer = new bytes(digits);
194         while (value != 0) {
195             digits -= 1;
196             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
197             value /= 10;
198         }
199         return string(buffer);
200     }
201 
202     /**
203      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
204      */
205     function toHexString(uint256 value) internal pure returns (string memory) {
206         if (value == 0) {
207             return "0x00";
208         }
209         uint256 temp = value;
210         uint256 length = 0;
211         while (temp != 0) {
212             length++;
213             temp >>= 8;
214         }
215         return toHexString(value, length);
216     }
217 
218     /**
219      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
220      */
221     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
222         bytes memory buffer = new bytes(2 * length + 2);
223         buffer[0] = "0";
224         buffer[1] = "x";
225         for (uint256 i = 2 * length + 1; i > 1; --i) {
226             buffer[i] = _HEX_SYMBOLS[value & 0xf];
227             value >>= 4;
228         }
229         require(value == 0, "Strings: hex length insufficient");
230         return string(buffer);
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Context.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 // File: @openzeppelin/contracts/access/Ownable.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 abstract contract Ownable is Context {
282     address private _owner;
283 
284     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286     /**
287      * @dev Initializes the contract setting the deployer as the initial owner.
288      */
289     constructor() {
290         _transferOwnership(_msgSender());
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if called by any account other than the owner.
302      */
303     modifier onlyOwner() {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305         _;
306     }
307 
308     /**
309      * @dev Leaves the contract without owner. It will not be possible to call
310      * `onlyOwner` functions anymore. Can only be called by the current owner.
311      *
312      * NOTE: Renouncing ownership will leave the contract without an owner,
313      * thereby removing any functionality that is only available to the owner.
314      */
315     function renounceOwnership() public virtual onlyOwner {
316         _transferOwnership(address(0));
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Can only be called by the current owner.
322      */
323     function transferOwnership(address newOwner) public virtual onlyOwner {
324         require(newOwner != address(0), "Ownable: new owner is the zero address");
325         _transferOwnership(newOwner);
326     }
327 
328     /**
329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
330      * Internal function without access restriction.
331      */
332     function _transferOwnership(address newOwner) internal virtual {
333         address oldOwner = _owner;
334         _owner = newOwner;
335         emit OwnershipTransferred(oldOwner, newOwner);
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/Address.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
343 
344 pragma solidity ^0.8.1;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      *
367      * [IMPORTANT]
368      * ====
369      * You shouldn't rely on `isContract` to protect against flash loan attacks!
370      *
371      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
372      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
373      * constructor.
374      * ====
375      */
376     function isContract(address account) internal view returns (bool) {
377         // This method relies on extcodesize/address.code.length, which returns 0
378         // for contracts in construction, since the code is only stored at the end
379         // of the constructor execution.
380 
381         return account.code.length > 0;
382     }
383 
384     /**
385      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
386      * `recipient`, forwarding all available gas and reverting on errors.
387      *
388      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
389      * of certain opcodes, possibly making contracts go over the 2300 gas limit
390      * imposed by `transfer`, making them unable to receive funds via
391      * `transfer`. {sendValue} removes this limitation.
392      *
393      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
394      *
395      * IMPORTANT: because control is transferred to `recipient`, care must be
396      * taken to not create reentrancy vulnerabilities. Consider using
397      * {ReentrancyGuard} or the
398      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
399      */
400     function sendValue(address payable recipient, uint256 amount) internal {
401         require(address(this).balance >= amount, "Address: insufficient balance");
402 
403         (bool success, ) = recipient.call{value: amount}("");
404         require(success, "Address: unable to send value, recipient may have reverted");
405     }
406 
407     /**
408      * @dev Performs a Solidity function call using a low level `call`. A
409      * plain `call` is an unsafe replacement for a function call: use this
410      * function instead.
411      *
412      * If `target` reverts with a revert reason, it is bubbled up by this
413      * function (like regular Solidity function calls).
414      *
415      * Returns the raw returned data. To convert to the expected return value,
416      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
417      *
418      * Requirements:
419      *
420      * - `target` must be a contract.
421      * - calling `target` with `data` must not revert.
422      *
423      * _Available since v3.1._
424      */
425     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
426         return functionCall(target, data, "Address: low-level call failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
431      * `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCall(
436         address target,
437         bytes memory data,
438         string memory errorMessage
439     ) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, 0, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but also transferring `value` wei to `target`.
446      *
447      * Requirements:
448      *
449      * - the calling contract must have an ETH balance of at least `value`.
450      * - the called Solidity function must be `payable`.
451      *
452      * _Available since v3.1._
453      */
454     function functionCallWithValue(
455         address target,
456         bytes memory data,
457         uint256 value
458     ) internal returns (bytes memory) {
459         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
464      * with `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(address(this).balance >= value, "Address: insufficient balance for call");
475         require(isContract(target), "Address: call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.call{value: value}(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483      * but performing a static call.
484      *
485      * _Available since v3.3._
486      */
487     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
488         return functionStaticCall(target, data, "Address: low-level static call failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a static call.
494      *
495      * _Available since v3.3._
496      */
497     function functionStaticCall(
498         address target,
499         bytes memory data,
500         string memory errorMessage
501     ) internal view returns (bytes memory) {
502         require(isContract(target), "Address: static call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.staticcall(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a delegate call.
511      *
512      * _Available since v3.4._
513      */
514     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
515         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a delegate call.
521      *
522      * _Available since v3.4._
523      */
524     function functionDelegateCall(
525         address target,
526         bytes memory data,
527         string memory errorMessage
528     ) internal returns (bytes memory) {
529         require(isContract(target), "Address: delegate call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.delegatecall(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
537      * revert reason using the provided one.
538      *
539      * _Available since v4.3._
540      */
541     function verifyCallResult(
542         bool success,
543         bytes memory returndata,
544         string memory errorMessage
545     ) internal pure returns (bytes memory) {
546         if (success) {
547             return returndata;
548         } else {
549             // Look for revert reason and bubble it up if present
550             if (returndata.length > 0) {
551                 // The easiest way to bubble the revert reason is using memory via assembly
552 
553                 assembly {
554                     let returndata_size := mload(returndata)
555                     revert(add(32, returndata), returndata_size)
556                 }
557             } else {
558                 revert(errorMessage);
559             }
560         }
561     }
562 }
563 
564 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
568 
569 pragma solidity ^0.8.0;
570 
571 
572 
573 /**
574  * @title SafeERC20
575  * @dev Wrappers around ERC20 operations that throw on failure (when the token
576  * contract returns false). Tokens that return no value (and instead revert or
577  * throw on failure) are also supported, non-reverting calls are assumed to be
578  * successful.
579  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
580  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
581  */
582 library SafeERC20 {
583     using Address for address;
584 
585     function safeTransfer(
586         IERC20 token,
587         address to,
588         uint256 value
589     ) internal {
590         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
591     }
592 
593     function safeTransferFrom(
594         IERC20 token,
595         address from,
596         address to,
597         uint256 value
598     ) internal {
599         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
600     }
601 
602     /**
603      * @dev Deprecated. This function has issues similar to the ones found in
604      * {IERC20-approve}, and its usage is discouraged.
605      *
606      * Whenever possible, use {safeIncreaseAllowance} and
607      * {safeDecreaseAllowance} instead.
608      */
609     function safeApprove(
610         IERC20 token,
611         address spender,
612         uint256 value
613     ) internal {
614         // safeApprove should only be called when setting an initial allowance,
615         // or when resetting it to zero. To increase and decrease it, use
616         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
617         require(
618             (value == 0) || (token.allowance(address(this), spender) == 0),
619             "SafeERC20: approve from non-zero to non-zero allowance"
620         );
621         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
622     }
623 
624     function safeIncreaseAllowance(
625         IERC20 token,
626         address spender,
627         uint256 value
628     ) internal {
629         uint256 newAllowance = token.allowance(address(this), spender) + value;
630         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
631     }
632 
633     function safeDecreaseAllowance(
634         IERC20 token,
635         address spender,
636         uint256 value
637     ) internal {
638         unchecked {
639             uint256 oldAllowance = token.allowance(address(this), spender);
640             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
641             uint256 newAllowance = oldAllowance - value;
642             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
643         }
644     }
645 
646     /**
647      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
648      * on the return value: the return value is optional (but if data is returned, it must not be false).
649      * @param token The token targeted by the call.
650      * @param data The call data (encoded using abi.encode or one of its variants).
651      */
652     function _callOptionalReturn(IERC20 token, bytes memory data) private {
653         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
654         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
655         // the target address contains contract code and also asserts for success in the low-level call.
656 
657         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
658         if (returndata.length > 0) {
659             // Return data is optional
660             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
661         }
662     }
663 }
664 
665 
666 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @title ERC721 token receiver interface
675  * @dev Interface for any contract that wants to support safeTransfers
676  * from ERC721 asset contracts.
677  */
678 interface IERC721Receiver {
679     /**
680      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
681      * by `operator` from `from`, this function is called.
682      *
683      * It must return its Solidity selector to confirm the token transfer.
684      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
685      *
686      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
687      */
688     function onERC721Received(
689         address operator,
690         address from,
691         uint256 tokenId,
692         bytes calldata data
693     ) external returns (bytes4);
694 }
695 
696 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
697 
698 
699 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 /**
704  * @dev Interface of the ERC165 standard, as defined in the
705  * https://eips.ethereum.org/EIPS/eip-165[EIP].
706  *
707  * Implementers can declare support of contract interfaces, which can then be
708  * queried by others ({ERC165Checker}).
709  *
710  * For an implementation, see {ERC165}.
711  */
712 interface IERC165 {
713     /**
714      * @dev Returns true if this contract implements the interface defined by
715      * `interfaceId`. See the corresponding
716      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
717      * to learn more about how these ids are created.
718      *
719      * This function call must use less than 30 000 gas.
720      */
721     function supportsInterface(bytes4 interfaceId) external view returns (bool);
722 }
723 
724 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
725 
726 
727 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @dev Implementation of the {IERC165} interface.
734  *
735  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
736  * for the additional interface id that will be supported. For example:
737  *
738  * ```solidity
739  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
741  * }
742  * ```
743  *
744  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
745  */
746 abstract contract ERC165 is IERC165 {
747     /**
748      * @dev See {IERC165-supportsInterface}.
749      */
750     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
751         return interfaceId == type(IERC165).interfaceId;
752     }
753 }
754 
755 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 
763 /**
764  * @dev Required interface of an ERC721 compliant contract.
765  */
766 interface IERC721 is IERC165 {
767     /**
768      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
769      */
770     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
771 
772     /**
773      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
774      */
775     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
776 
777     /**
778      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
779      */
780     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
781 
782     /**
783      * @dev Returns the number of tokens in ``owner``'s account.
784      */
785     function balanceOf(address owner) external view returns (uint256 balance);
786 
787     /**
788      * @dev Returns the owner of the `tokenId` token.
789      *
790      * Requirements:
791      *
792      * - `tokenId` must exist.
793      */
794     function ownerOf(uint256 tokenId) external view returns (address owner);
795 
796     /**
797      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
798      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
799      *
800      * Requirements:
801      *
802      * - `from` cannot be the zero address.
803      * - `to` cannot be the zero address.
804      * - `tokenId` token must exist and be owned by `from`.
805      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
806      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
807      *
808      * Emits a {Transfer} event.
809      */
810     function safeTransferFrom(
811         address from,
812         address to,
813         uint256 tokenId
814     ) external;
815 
816     /**
817      * @dev Transfers `tokenId` token from `from` to `to`.
818      *
819      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
820      *
821      * Requirements:
822      *
823      * - `from` cannot be the zero address.
824      * - `to` cannot be the zero address.
825      * - `tokenId` token must be owned by `from`.
826      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
827      *
828      * Emits a {Transfer} event.
829      */
830     function transferFrom(
831         address from,
832         address to,
833         uint256 tokenId
834     ) external;
835 
836     /**
837      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
838      * The approval is cleared when the token is transferred.
839      *
840      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
841      *
842      * Requirements:
843      *
844      * - The caller must own the token or be an approved operator.
845      * - `tokenId` must exist.
846      *
847      * Emits an {Approval} event.
848      */
849     function approve(address to, uint256 tokenId) external;
850 
851     /**
852      * @dev Returns the account approved for `tokenId` token.
853      *
854      * Requirements:
855      *
856      * - `tokenId` must exist.
857      */
858     function getApproved(uint256 tokenId) external view returns (address operator);
859 
860     /**
861      * @dev Approve or remove `operator` as an operator for the caller.
862      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
874      *
875      * See {setApprovalForAll}
876      */
877     function isApprovedForAll(address owner, address operator) external view returns (bool);
878 
879     /**
880      * @dev Safely transfers `tokenId` token from `from` to `to`.
881      *
882      * Requirements:
883      *
884      * - `from` cannot be the zero address.
885      * - `to` cannot be the zero address.
886      * - `tokenId` token must exist and be owned by `from`.
887      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
888      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
889      *
890      * Emits a {Transfer} event.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId,
896         bytes calldata data
897     ) external;
898 }
899 
900 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
901 
902 
903 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 
908 /**
909  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
910  * @dev See https://eips.ethereum.org/EIPS/eip-721
911  */
912 interface IERC721Enumerable is IERC721 {
913     /**
914      * @dev Returns the total amount of tokens stored by the contract.
915      */
916     function totalSupply() external view returns (uint256);
917 
918     /**
919      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
920      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
921      */
922     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
923 
924     /**
925      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
926      * Use along with {totalSupply} to enumerate all tokens.
927      */
928     function tokenByIndex(uint256 index) external view returns (uint256);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Metadata is IERC721 {
944     /**
945      * @dev Returns the token collection name.
946      */
947     function name() external view returns (string memory);
948 
949     /**
950      * @dev Returns the token collection symbol.
951      */
952     function symbol() external view returns (string memory);
953 
954     /**
955      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
956      */
957     function tokenURI(uint256 tokenId) external view returns (string memory);
958 }
959 
960 // File: contracts/TwistedToonz.sol
961 
962 
963 // Creator: Chiru Labs
964 
965 pragma solidity ^0.8.0;
966 
967 
968 
969 
970 
971 
972 
973 
974 
975 /**
976  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
977  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
978  *
979  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
980  *
981  * Does not support burning tokens to address(0).
982  *
983  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
984  */
985 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
986     using Address for address;
987     using Strings for uint256;
988 
989     struct TokenOwnership {
990         address addr;
991         uint64 startTimestamp;
992     }
993 
994     struct AddressData {
995         uint128 balance;
996         uint128 numberMinted;
997     }
998 
999     uint256 internal currentIndex;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to ownership details
1008     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1009     mapping(uint256 => TokenOwnership) internal _ownerships;
1010 
1011     // Mapping owner address to address data
1012     mapping(address => AddressData) private _addressData;
1013 
1014     // Mapping from token ID to approved address
1015     mapping(uint256 => address) private _tokenApprovals;
1016 
1017     // Mapping from owner to operator approvals
1018     mapping(address => mapping(address => bool)) private _operatorApprovals;
1019 
1020     constructor(string memory name_, string memory symbol_) {
1021         _name = name_;
1022         _symbol = symbol_;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-totalSupply}.
1027      */
1028     function totalSupply() public view override returns (uint256) {
1029         return currentIndex;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Enumerable-tokenByIndex}.
1034      */
1035     function tokenByIndex(uint256 index) public view override returns (uint256) {
1036         require(index < totalSupply(), "ERC721A: global index out of bounds");
1037         return index;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1042      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1043      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1044      */
1045     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1046         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1047         uint256 numMintedSoFar = totalSupply();
1048         uint256 tokenIdsIdx;
1049         address currOwnershipAddr;
1050 
1051         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1052         unchecked {
1053             for (uint256 i; i < numMintedSoFar; i++) {
1054                 TokenOwnership memory ownership = _ownerships[i];
1055                 if (ownership.addr != address(0)) {
1056                     currOwnershipAddr = ownership.addr;
1057                 }
1058                 if (currOwnershipAddr == owner) {
1059                     if (tokenIdsIdx == index) {
1060                         return i;
1061                     }
1062                     tokenIdsIdx++;
1063                 }
1064             }
1065         }
1066 
1067         revert("ERC721A: unable to get token of owner by index");
1068     }
1069 
1070     /**
1071      * @dev See {IERC165-supportsInterface}.
1072      */
1073     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1074         return
1075             interfaceId == type(IERC721).interfaceId ||
1076             interfaceId == type(IERC721Metadata).interfaceId ||
1077             interfaceId == type(IERC721Enumerable).interfaceId ||
1078             super.supportsInterface(interfaceId);
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-balanceOf}.
1083      */
1084     function balanceOf(address owner) public view override returns (uint256) {
1085         require(owner != address(0), "ERC721A: balance query for the zero address");
1086         return uint256(_addressData[owner].balance);
1087     }
1088 
1089     function _numberMinted(address owner) internal view returns (uint256) {
1090         require(owner != address(0), "ERC721A: number minted query for the zero address");
1091         return uint256(_addressData[owner].numberMinted);
1092     }
1093 
1094     /**
1095      * Gas spent here starts off proportional to the maximum mint batch size.
1096      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1097      */
1098     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1099         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1100 
1101         unchecked {
1102             for (uint256 curr = tokenId; curr >= 0; curr--) {
1103                 TokenOwnership memory ownership = _ownerships[curr];
1104                 if (ownership.addr != address(0)) {
1105                     return ownership;
1106                 }
1107             }
1108         }
1109 
1110         revert("ERC721A: unable to determine the owner of token");
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-ownerOf}.
1115      */
1116     function ownerOf(uint256 tokenId) public view override returns (address) {
1117         return ownershipOf(tokenId).addr;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-name}.
1122      */
1123     function name() public view virtual override returns (string memory) {
1124         return _name;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-symbol}.
1129      */
1130     function symbol() public view virtual override returns (string memory) {
1131         return _symbol;
1132     }
1133 
1134     /**
1135      * @dev See {IERC721Metadata-tokenURI}.
1136      */
1137     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1138         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1139 
1140         string memory baseURI = _baseURI();
1141         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1142     }
1143 
1144     /**
1145      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1146      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1147      * by default, can be overriden in child contracts.
1148      */
1149     function _baseURI() internal view virtual returns (string memory) {
1150         return "";
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-approve}.
1155      */
1156     function approve(address to, uint256 tokenId) public override {
1157         address owner = ERC721A.ownerOf(tokenId);
1158         require(to != owner, "ERC721A: approval to current owner");
1159 
1160         require(
1161             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1162             "ERC721A: approve caller is not owner nor approved for all"
1163         );
1164 
1165         _approve(to, tokenId, owner);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-getApproved}.
1170      */
1171     function getApproved(uint256 tokenId) public view override returns (address) {
1172         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1173 
1174         return _tokenApprovals[tokenId];
1175     }
1176 
1177     /**
1178      * @dev See {IERC721-setApprovalForAll}.
1179      */
1180     function setApprovalForAll(address operator, bool approved) public override {
1181         require(operator != _msgSender(), "ERC721A: approve to caller");
1182 
1183         _operatorApprovals[_msgSender()][operator] = approved;
1184         emit ApprovalForAll(_msgSender(), operator, approved);
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-isApprovedForAll}.
1189      */
1190     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1191         return _operatorApprovals[owner][operator];
1192     }
1193 
1194     /**
1195      * @dev See {IERC721-transferFrom}.
1196      */
1197     function transferFrom(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) public virtual override {
1202         _transfer(from, to, tokenId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721-safeTransferFrom}.
1207      */
1208     function safeTransferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) public virtual override {
1213         safeTransferFrom(from, to, tokenId, "");
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-safeTransferFrom}.
1218      */
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId,
1223         bytes memory _data
1224     ) public override {
1225         _transfer(from, to, tokenId);
1226         require(
1227             _checkOnERC721Received(from, to, tokenId, _data),
1228             "ERC721A: transfer to non ERC721Receiver implementer"
1229         );
1230     }
1231 
1232     /**
1233      * @dev Returns whether `tokenId` exists.
1234      *
1235      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1236      *
1237      * Tokens start existing when they are minted (`_mint`),
1238      */
1239     function _exists(uint256 tokenId) internal view returns (bool) {
1240         return tokenId < currentIndex;
1241     }
1242 
1243     function _safeMint(address to, uint256 quantity) internal {
1244         _safeMint(to, quantity, "");
1245     }
1246 
1247     /**
1248      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1249      *
1250      * Requirements:
1251      *
1252      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1253      * - `quantity` must be greater than 0.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _safeMint(
1258         address to,
1259         uint256 quantity,
1260         bytes memory _data
1261     ) internal {
1262         _mint(to, quantity, _data, true);
1263     }
1264 
1265     /**
1266      * @dev Mints `quantity` tokens and transfers them to `to`.
1267      *
1268      * Requirements:
1269      *
1270      * - `to` cannot be the zero address.
1271      * - `quantity` must be greater than 0.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _mint(
1276         address to,
1277         uint256 quantity,
1278         bytes memory _data,
1279         bool safe
1280     ) internal {
1281         uint256 startTokenId = currentIndex;
1282         require(to != address(0), "ERC721A: mint to the zero address");
1283         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1284 
1285         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1286 
1287         // Overflows are incredibly unrealistic.
1288         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1289         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1290         unchecked {
1291             _addressData[to].balance += uint128(quantity);
1292             _addressData[to].numberMinted += uint128(quantity);
1293 
1294             _ownerships[startTokenId].addr = to;
1295             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1296 
1297             uint256 updatedIndex = startTokenId;
1298 
1299             for (uint256 i; i < quantity; i++) {
1300                 emit Transfer(address(0), to, updatedIndex);
1301                 if (safe) {
1302                     require(
1303                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1304                         "ERC721A: transfer to non ERC721Receiver implementer"
1305                     );
1306                 }
1307 
1308                 updatedIndex++;
1309             }
1310 
1311             currentIndex = updatedIndex;
1312         }
1313 
1314         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1315     }
1316 
1317     /**
1318      * @dev Transfers `tokenId` from `from` to `to`.
1319      *
1320      * Requirements:
1321      *
1322      * - `to` cannot be the zero address.
1323      * - `tokenId` token must be owned by `from`.
1324      *
1325      * Emits a {Transfer} event.
1326      */
1327     function _transfer(
1328         address from,
1329         address to,
1330         uint256 tokenId
1331     ) private {
1332         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1333 
1334         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1335             getApproved(tokenId) == _msgSender() ||
1336             isApprovedForAll(prevOwnership.addr, _msgSender()));
1337 
1338         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1339 
1340         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1341         require(to != address(0), "ERC721A: transfer to the zero address");
1342 
1343         _beforeTokenTransfers(from, to, tokenId, 1);
1344 
1345         // Clear approvals from the previous owner
1346         _approve(address(0), tokenId, prevOwnership.addr);
1347 
1348         // Underflow of the sender's balance is impossible because we check for
1349         // ownership above and the recipient's balance can't realistically overflow.
1350         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1351         unchecked {
1352             _addressData[from].balance -= 1;
1353             _addressData[to].balance += 1;
1354 
1355             _ownerships[tokenId].addr = to;
1356             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1357 
1358             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1359             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1360             uint256 nextTokenId = tokenId + 1;
1361             if (_ownerships[nextTokenId].addr == address(0)) {
1362                 if (_exists(nextTokenId)) {
1363                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1364                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1365                 }
1366             }
1367         }
1368 
1369         emit Transfer(from, to, tokenId);
1370         _afterTokenTransfers(from, to, tokenId, 1);
1371     }
1372 
1373     /**
1374      * @dev Approve `to` to operate on `tokenId`
1375      *
1376      * Emits a {Approval} event.
1377      */
1378     function _approve(
1379         address to,
1380         uint256 tokenId,
1381         address owner
1382     ) private {
1383         _tokenApprovals[tokenId] = to;
1384         emit Approval(owner, to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1389      * The call is not executed if the target address is not a contract.
1390      *
1391      * @param from address representing the previous owner of the given token ID
1392      * @param to target address that will receive the tokens
1393      * @param tokenId uint256 ID of the token to be transferred
1394      * @param _data bytes optional data to send along with the call
1395      * @return bool whether the call correctly returned the expected magic value
1396      */
1397     function _checkOnERC721Received(
1398         address from,
1399         address to,
1400         uint256 tokenId,
1401         bytes memory _data
1402     ) private returns (bool) {
1403         if (to.isContract()) {
1404             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1405                 return retval == IERC721Receiver(to).onERC721Received.selector;
1406             } catch (bytes memory reason) {
1407                 if (reason.length == 0) {
1408                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1409                 } else {
1410                     assembly {
1411                         revert(add(32, reason), mload(reason))
1412                     }
1413                 }
1414             }
1415         } else {
1416             return true;
1417         }
1418     }
1419 
1420     /**
1421      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1429      * transferred to `to`.
1430      * - When `from` is zero, `tokenId` will be minted for `to`.
1431      */
1432     function _beforeTokenTransfers(
1433         address from,
1434         address to,
1435         uint256 startTokenId,
1436         uint256 quantity
1437     ) internal virtual {}
1438 
1439     /**
1440      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1441      * minting.
1442      *
1443      * startTokenId - the first token id to be transferred
1444      * quantity - the amount to be transferred
1445      *
1446      * Calling conditions:
1447      *
1448      * - when `from` and `to` are both non-zero.
1449      * - `from` and `to` are never both zero.
1450      */
1451     function _afterTokenTransfers(
1452         address from,
1453         address to,
1454         uint256 startTokenId,
1455         uint256 quantity
1456     ) internal virtual {}
1457 }
1458 
1459 contract WAGDIEGRAVE is ERC721A, Ownable, ReentrancyGuard {
1460 
1461   string public        baseURI;
1462   uint public          price             = 0.0035 ether;
1463   uint public          maxPerTx          = 5;
1464   uint public          maxPerWallet      = 20;
1465   uint public          maxFreePerWallet  = 1;
1466   uint public          totalFree         = 555;
1467   uint public          maxSupply         = 6969;
1468   uint public          nextOwnerToExplicitlySet;
1469   bool public          mintEnabled;
1470 
1471   constructor() ERC721A("WAGDIEGRAVE", "WAGDIEG"){}
1472 
1473   function mint(uint256 amt) external payable
1474   {
1475     uint cost = price;
1476     if(totalSupply() + amt < totalFree + 1) {
1477       cost = 0;
1478       amt = 1;
1479       require(numberMinted(msg.sender) + amt <= maxFreePerWallet, "Too free mint many per wallet!");
1480     }
1481     require(msg.sender == tx.origin,"your are not the sender");
1482     require(msg.value == amt * cost,"Please send the exact amount.");
1483     require(totalSupply() + amt < maxSupply + 1, "Sorry anno degen");
1484     require(mintEnabled, "Not live yet.");
1485     require(numberMinted(msg.sender) + amt <= maxPerWallet, "Too many per wallet!");
1486     require(amt < maxPerTx + 1, "Max per TX reached.");
1487 
1488     _safeMint(msg.sender, amt);
1489   }
1490 
1491   function ownerBatchMint(uint256 amt) external onlyOwner
1492   {
1493     require(totalSupply() + amt < maxSupply + 1,"too many!");
1494 
1495     _safeMint(msg.sender, amt);
1496   }
1497 
1498   function toggleMinting() external onlyOwner {
1499       mintEnabled = !mintEnabled;
1500   }
1501 
1502   function numberMinted(address owner) public view returns (uint256) {
1503     return _numberMinted(owner);
1504   }
1505 
1506   function setBaseURI(string calldata baseURI_) external onlyOwner {
1507     baseURI = baseURI_;
1508   }
1509 
1510   function setPrice(uint256 price_) external onlyOwner {
1511       price = price_;
1512   }
1513 
1514   function setTotalFree(uint256 totalFree_) external onlyOwner {
1515       totalFree = totalFree_;
1516   }
1517 
1518   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1519       maxPerTx = maxPerTx_;
1520   }
1521 
1522   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1523       maxPerWallet = maxPerWallet_;
1524   }
1525 
1526   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1527       maxSupply = maxSupply_;
1528   }
1529 
1530   function _baseURI() internal view virtual override returns (string memory) {
1531     return baseURI;
1532   }
1533 
1534   function withdraw() external onlyOwner nonReentrant {
1535     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1536     require(success, "Transfer failed.");
1537   }
1538 
1539   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1540     _setOwnersExplicit(quantity);
1541   }
1542 
1543   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1544   {
1545     return ownershipOf(tokenId);
1546   }
1547 
1548 
1549   /**
1550     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1551     */
1552   function _setOwnersExplicit(uint256 quantity) internal {
1553       require(quantity != 0, "quantity must be nonzero");
1554       require(currentIndex != 0, "no tokens minted yet");
1555       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1556       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1557 
1558       // Index underflow is impossible.
1559       // Counter or index overflow is incredibly unrealistic.
1560       unchecked {
1561           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1562 
1563           // Set the end index to be the last token index
1564           if (endIndex + 1 > currentIndex) {
1565               endIndex = currentIndex - 1;
1566           }
1567 
1568           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1569               if (_ownerships[i].addr == address(0)) {
1570                   TokenOwnership memory ownership = ownershipOf(i);
1571                   _ownerships[i].addr = ownership.addr;
1572                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1573               }
1574           }
1575 
1576           nextOwnerToExplicitlySet = endIndex + 1;
1577       }
1578   }
1579 }