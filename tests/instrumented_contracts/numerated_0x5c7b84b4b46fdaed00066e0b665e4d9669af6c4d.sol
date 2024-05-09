1 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `to`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address to, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `from` to `to` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address from,
64         address to,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
87 
88 pragma solidity ^0.8.0;
89 
90 /**
91  * @dev Contract module that helps prevent reentrant calls to a function.
92  *
93  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
94  * available, which can be applied to functions to make sure there are no nested
95  * (reentrant) calls to them.
96  *
97  * Note that because there is a single `nonReentrant` guard, functions marked as
98  * `nonReentrant` may not call one another. This can be worked around by making
99  * those functions `private`, and then adding `external` `nonReentrant` entry
100  * points to them.
101  *
102  * TIP: If you would like to learn more about reentrancy and alternative ways
103  * to protect against it, check out our blog post
104  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
105  */
106 abstract contract ReentrancyGuard {
107     // Booleans are more expensive than uint256 or any type that takes up a full
108     // word because each write operation emits an extra SLOAD to first read the
109     // slot's contents, replace the bits taken up by the boolean, and then write
110     // back. This is the compiler's defense against contract upgrades and
111     // pointer aliasing, and it cannot be disabled.
112 
113     // The values being non-zero value makes deployment a bit more expensive,
114     // but in exchange the refund on every call to nonReentrant will be lower in
115     // amount. Since refunds are capped to a percentage of the total
116     // transaction's gas, it is best to keep them low in cases like this one, to
117     // increase the likelihood of the full refund coming into effect.
118     uint256 private constant _NOT_ENTERED = 1;
119     uint256 private constant _ENTERED = 2;
120 
121     uint256 private _status;
122 
123     constructor() {
124         _status = _NOT_ENTERED;
125     }
126 
127     /**
128      * @dev Prevents a contract from calling itself, directly or indirectly.
129      * Calling a `nonReentrant` function from another `nonReentrant`
130      * function is not supported. It is possible to prevent this from happening
131      * by making the `nonReentrant` function external, and making it call a
132      * `private` function that does the actual work.
133      */
134     modifier nonReentrant() {
135         // On the first call to nonReentrant, _notEntered will be true
136         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
137 
138         // Any calls to nonReentrant after this point will fail
139         _status = _ENTERED;
140 
141         _;
142 
143         // By storing the original value once again, a refund is triggered (see
144         // https://eips.ethereum.org/EIPS/eip-2200)
145         _status = _NOT_ENTERED;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/utils/Strings.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev String operations.
158  */
159 library Strings {
160     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
161 
162     /**
163      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
164      */
165     function toString(uint256 value) internal pure returns (string memory) {
166         // Inspired by OraclizeAPI's implementation - MIT licence
167         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
168 
169         if (value == 0) {
170             return "0";
171         }
172         uint256 temp = value;
173         uint256 digits;
174         while (temp != 0) {
175             digits++;
176             temp /= 10;
177         }
178         bytes memory buffer = new bytes(digits);
179         while (value != 0) {
180             digits -= 1;
181             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
182             value /= 10;
183         }
184         return string(buffer);
185     }
186 
187     /**
188      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
189      */
190     function toHexString(uint256 value) internal pure returns (string memory) {
191         if (value == 0) {
192             return "0x00";
193         }
194         uint256 temp = value;
195         uint256 length = 0;
196         while (temp != 0) {
197             length++;
198             temp >>= 8;
199         }
200         return toHexString(value, length);
201     }
202 
203     /**
204      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
205      */
206     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
207         bytes memory buffer = new bytes(2 * length + 2);
208         buffer[0] = "0";
209         buffer[1] = "x";
210         for (uint256 i = 2 * length + 1; i > 1; --i) {
211             buffer[i] = _HEX_SYMBOLS[value & 0xf];
212             value >>= 4;
213         }
214         require(value == 0, "Strings: hex length insufficient");
215         return string(buffer);
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Context.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 /**
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 // File: @openzeppelin/contracts/access/Ownable.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _transferOwnership(_msgSender());
276     }
277 
278     /**
279      * @dev Returns the address of the current owner.
280      */
281     function owner() public view virtual returns (address) {
282         return _owner;
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(owner() == _msgSender(), "Ownable: caller is not the owner");
290         _;
291     }
292 
293     /**
294      * @dev Leaves the contract without owner. It will not be possible to call
295      * `onlyOwner` functions anymore. Can only be called by the current owner.
296      *
297      * NOTE: Renouncing ownership will leave the contract without an owner,
298      * thereby removing any functionality that is only available to the owner.
299      */
300     function renounceOwnership() public virtual onlyOwner {
301         _transferOwnership(address(0));
302     }
303 
304     /**
305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
306      * Can only be called by the current owner.
307      */
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         require(newOwner != address(0), "Ownable: new owner is the zero address");
310         _transferOwnership(newOwner);
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Internal function without access restriction.
316      */
317     function _transferOwnership(address newOwner) internal virtual {
318         address oldOwner = _owner;
319         _owner = newOwner;
320         emit OwnershipTransferred(oldOwner, newOwner);
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/Address.sol
325 
326 
327 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
328 
329 pragma solidity ^0.8.1;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      *
352      * [IMPORTANT]
353      * ====
354      * You shouldn't rely on `isContract` to protect against flash loan attacks!
355      *
356      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
357      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
358      * constructor.
359      * ====
360      */
361     function isContract(address account) internal view returns (bool) {
362         // This method relies on extcodesize/address.code.length, which returns 0
363         // for contracts in construction, since the code is only stored at the end
364         // of the constructor execution.
365 
366         return account.code.length > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         (bool success, ) = recipient.call{value: amount}("");
389         require(success, "Address: unable to send value, recipient may have reverted");
390     }
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(
454         address target,
455         bytes memory data,
456         uint256 value,
457         string memory errorMessage
458     ) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         require(isContract(target), "Address: call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.call{value: value}(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
473         return functionStaticCall(target, data, "Address: low-level static call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a static call.
479      *
480      * _Available since v3.3._
481      */
482     function functionStaticCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal view returns (bytes memory) {
487         require(isContract(target), "Address: static call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.staticcall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a delegate call.
496      *
497      * _Available since v3.4._
498      */
499     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
500         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal returns (bytes memory) {
514         require(isContract(target), "Address: delegate call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.delegatecall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
522      * revert reason using the provided one.
523      *
524      * _Available since v4.3._
525      */
526     function verifyCallResult(
527         bool success,
528         bytes memory returndata,
529         string memory errorMessage
530     ) internal pure returns (bytes memory) {
531         if (success) {
532             return returndata;
533         } else {
534             // Look for revert reason and bubble it up if present
535             if (returndata.length > 0) {
536                 // The easiest way to bubble the revert reason is using memory via assembly
537 
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 
558 /**
559  * @title SafeERC20
560  * @dev Wrappers around ERC20 operations that throw on failure (when the token
561  * contract returns false). Tokens that return no value (and instead revert or
562  * throw on failure) are also supported, non-reverting calls are assumed to be
563  * successful.
564  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
565  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
566  */
567 library SafeERC20 {
568     using Address for address;
569 
570     function safeTransfer(
571         IERC20 token,
572         address to,
573         uint256 value
574     ) internal {
575         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
576     }
577 
578     function safeTransferFrom(
579         IERC20 token,
580         address from,
581         address to,
582         uint256 value
583     ) internal {
584         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
585     }
586 
587     /**
588      * @dev Deprecated. This function has issues similar to the ones found in
589      * {IERC20-approve}, and its usage is discouraged.
590      *
591      * Whenever possible, use {safeIncreaseAllowance} and
592      * {safeDecreaseAllowance} instead.
593      */
594     function safeApprove(
595         IERC20 token,
596         address spender,
597         uint256 value
598     ) internal {
599         // safeApprove should only be called when setting an initial allowance,
600         // or when resetting it to zero. To increase and decrease it, use
601         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
602         require(
603             (value == 0) || (token.allowance(address(this), spender) == 0),
604             "SafeERC20: approve from non-zero to non-zero allowance"
605         );
606         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
607     }
608 
609     function safeIncreaseAllowance(
610         IERC20 token,
611         address spender,
612         uint256 value
613     ) internal {
614         uint256 newAllowance = token.allowance(address(this), spender) + value;
615         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
616     }
617 
618     function safeDecreaseAllowance(
619         IERC20 token,
620         address spender,
621         uint256 value
622     ) internal {
623         unchecked {
624             uint256 oldAllowance = token.allowance(address(this), spender);
625             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
626             uint256 newAllowance = oldAllowance - value;
627             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
628         }
629     }
630 
631     /**
632      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
633      * on the return value: the return value is optional (but if data is returned, it must not be false).
634      * @param token The token targeted by the call.
635      * @param data The call data (encoded using abi.encode or one of its variants).
636      */
637     function _callOptionalReturn(IERC20 token, bytes memory data) private {
638         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
639         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
640         // the target address contains contract code and also asserts for success in the low-level call.
641 
642         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
643         if (returndata.length > 0) {
644             // Return data is optional
645             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
646         }
647     }
648 }
649 
650 
651 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
652 
653 
654 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
655 
656 pragma solidity ^0.8.0;
657 
658 /**
659  * @title ERC721 token receiver interface
660  * @dev Interface for any contract that wants to support safeTransfers
661  * from ERC721 asset contracts.
662  */
663 interface IERC721Receiver {
664     /**
665      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
666      * by `operator` from `from`, this function is called.
667      *
668      * It must return its Solidity selector to confirm the token transfer.
669      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
670      *
671      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
672      */
673     function onERC721Received(
674         address operator,
675         address from,
676         uint256 tokenId,
677         bytes calldata data
678     ) external returns (bytes4);
679 }
680 
681 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @dev Interface of the ERC165 standard, as defined in the
690  * https://eips.ethereum.org/EIPS/eip-165[EIP].
691  *
692  * Implementers can declare support of contract interfaces, which can then be
693  * queried by others ({ERC165Checker}).
694  *
695  * For an implementation, see {ERC165}.
696  */
697 interface IERC165 {
698     /**
699      * @dev Returns true if this contract implements the interface defined by
700      * `interfaceId`. See the corresponding
701      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
702      * to learn more about how these ids are created.
703      *
704      * This function call must use less than 30 000 gas.
705      */
706     function supportsInterface(bytes4 interfaceId) external view returns (bool);
707 }
708 
709 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 
717 /**
718  * @dev Implementation of the {IERC165} interface.
719  *
720  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
721  * for the additional interface id that will be supported. For example:
722  *
723  * ```solidity
724  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
726  * }
727  * ```
728  *
729  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
730  */
731 abstract contract ERC165 is IERC165 {
732     /**
733      * @dev See {IERC165-supportsInterface}.
734      */
735     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
736         return interfaceId == type(IERC165).interfaceId;
737     }
738 }
739 
740 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
741 
742 
743 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Required interface of an ERC721 compliant contract.
750  */
751 interface IERC721 is IERC165 {
752     /**
753      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
754      */
755     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
759      */
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
764      */
765     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
766 
767     /**
768      * @dev Returns the number of tokens in ``owner``'s account.
769      */
770     function balanceOf(address owner) external view returns (uint256 balance);
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) external view returns (address owner);
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) external view returns (address operator);
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes calldata data
882     ) external;
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
886 
887 
888 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 
893 /**
894  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
895  * @dev See https://eips.ethereum.org/EIPS/eip-721
896  */
897 interface IERC721Enumerable is IERC721 {
898     /**
899      * @dev Returns the total amount of tokens stored by the contract.
900      */
901     function totalSupply() external view returns (uint256);
902 
903     /**
904      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
905      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
906      */
907     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
911      * Use along with {totalSupply} to enumerate all tokens.
912      */
913     function tokenByIndex(uint256 index) external view returns (uint256);
914 }
915 
916 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
917 
918 
919 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
920 
921 pragma solidity ^0.8.0;
922 
923 
924 /**
925  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
926  * @dev See https://eips.ethereum.org/EIPS/eip-721
927  */
928 interface IERC721Metadata is IERC721 {
929     /**
930      * @dev Returns the token collection name.
931      */
932     function name() external view returns (string memory);
933 
934     /**
935      * @dev Returns the token collection symbol.
936      */
937     function symbol() external view returns (string memory);
938 
939     /**
940      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
941      */
942     function tokenURI(uint256 tokenId) external view returns (string memory);
943 }
944 
945 // File: contracts/TwistedToonz.sol
946 
947 
948 // Creator: Chiru Labs
949 
950 pragma solidity ^0.8.0;
951 
952 /**
953  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
954  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
955  *
956  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
957  *
958  * Does not support burning tokens to address(0).
959  *
960  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
961  */
962 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
963     using Address for address;
964     using Strings for uint256;
965 
966     struct TokenOwnership {
967         address addr;
968         uint64 startTimestamp;
969     }
970 
971     struct AddressData {
972         uint128 balance;
973         uint128 numberMinted;
974     }
975 
976     uint256 internal currentIndex;
977 
978     // Token name
979     string private _name;
980 
981     // Token symbol
982     string private _symbol;
983 
984     // Mapping from token ID to ownership details
985     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
986     mapping(uint256 => TokenOwnership) internal _ownerships;
987 
988     // Mapping owner address to address data
989     mapping(address => AddressData) private _addressData;
990 
991     // Mapping from token ID to approved address
992     mapping(uint256 => address) private _tokenApprovals;
993 
994     // Mapping from owner to operator approvals
995     mapping(address => mapping(address => bool)) private _operatorApprovals;
996 
997     constructor(string memory name_, string memory symbol_) {
998         _name = name_;
999         _symbol = symbol_;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Enumerable-totalSupply}.
1004      */
1005     function totalSupply() public view override returns (uint256) {
1006         return currentIndex;
1007     }
1008 
1009     /**
1010      * @dev See {IERC721Enumerable-tokenByIndex}.
1011      */
1012     function tokenByIndex(uint256 index) public view override returns (uint256) {
1013         require(index < totalSupply(), "ERC721A: global index out of bounds");
1014         return index;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1019      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1020      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1023         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1024         uint256 numMintedSoFar = totalSupply();
1025         uint256 tokenIdsIdx;
1026         address currOwnershipAddr;
1027 
1028         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1029         unchecked {
1030             for (uint256 i; i < numMintedSoFar; i++) {
1031                 TokenOwnership memory ownership = _ownerships[i];
1032                 if (ownership.addr != address(0)) {
1033                     currOwnershipAddr = ownership.addr;
1034                 }
1035                 if (currOwnershipAddr == owner) {
1036                     if (tokenIdsIdx == index) {
1037                         return i;
1038                     }
1039                     tokenIdsIdx++;
1040                 }
1041             }
1042         }
1043 
1044         revert("ERC721A: unable to get token of owner by index");
1045     }
1046 
1047     /**
1048      * @dev See {IERC165-supportsInterface}.
1049      */
1050     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1051         return
1052             interfaceId == type(IERC721).interfaceId ||
1053             interfaceId == type(IERC721Metadata).interfaceId ||
1054             interfaceId == type(IERC721Enumerable).interfaceId ||
1055             super.supportsInterface(interfaceId);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-balanceOf}.
1060      */
1061     function balanceOf(address owner) public view override returns (uint256) {
1062         require(owner != address(0), "ERC721A: balance query for the zero address");
1063         return uint256(_addressData[owner].balance);
1064     }
1065 
1066     function _numberMinted(address owner) internal view returns (uint256) {
1067         require(owner != address(0), "ERC721A: number minted query for the zero address");
1068         return uint256(_addressData[owner].numberMinted);
1069     }
1070 
1071     /**
1072      * Gas spent here starts off proportional to the maximum mint batch size.
1073      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1074      */
1075     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1076         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1077 
1078         unchecked {
1079             for (uint256 curr = tokenId; curr >= 0; curr--) {
1080                 TokenOwnership memory ownership = _ownerships[curr];
1081                 if (ownership.addr != address(0)) {
1082                     return ownership;
1083                 }
1084             }
1085         }
1086 
1087         revert("ERC721A: unable to determine the owner of token");
1088     }
1089 
1090     /**
1091      * @dev See {IERC721-ownerOf}.
1092      */
1093     function ownerOf(uint256 tokenId) public view override returns (address) {
1094         return ownershipOf(tokenId).addr;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Metadata-name}.
1099      */
1100     function name() public view virtual override returns (string memory) {
1101         return _name;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Metadata-symbol}.
1106      */
1107     function symbol() public view virtual override returns (string memory) {
1108         return _symbol;
1109     }
1110 
1111     /**
1112      * @dev See {IERC721Metadata-tokenURI}.
1113      */
1114     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1115         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1116 
1117         string memory baseURI = _baseURI();
1118         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1119     }
1120 
1121     /**
1122      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1123      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1124      * by default, can be overriden in child contracts.
1125      */
1126     function _baseURI() internal view virtual returns (string memory) {
1127         return "";
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-approve}.
1132      */
1133     function approve(address to, uint256 tokenId) public override {
1134         address owner = ERC721A.ownerOf(tokenId);
1135         require(to != owner, "ERC721A: approval to current owner");
1136 
1137         require(
1138             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1139             "ERC721A: approve caller is not owner nor approved for all"
1140         );
1141 
1142         _approve(to, tokenId, owner);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-getApproved}.
1147      */
1148     function getApproved(uint256 tokenId) public view override returns (address) {
1149         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1150 
1151         return _tokenApprovals[tokenId];
1152     }
1153 
1154     /**
1155      * @dev See {IERC721-setApprovalForAll}.
1156      */
1157     function setApprovalForAll(address operator, bool approved) public override {
1158         require(operator != _msgSender(), "ERC721A: approve to caller");
1159 
1160         _operatorApprovals[_msgSender()][operator] = approved;
1161         emit ApprovalForAll(_msgSender(), operator, approved);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-isApprovedForAll}.
1166      */
1167     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1168         return _operatorApprovals[owner][operator];
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-transferFrom}.
1173      */
1174     function transferFrom(
1175         address from,
1176         address to,
1177         uint256 tokenId
1178     ) public virtual override {
1179         _transfer(from, to, tokenId);
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-safeTransferFrom}.
1184      */
1185     function safeTransferFrom(
1186         address from,
1187         address to,
1188         uint256 tokenId
1189     ) public virtual override {
1190         safeTransferFrom(from, to, tokenId, "");
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-safeTransferFrom}.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes memory _data
1201     ) public override {
1202         _transfer(from, to, tokenId);
1203         require(
1204             _checkOnERC721Received(from, to, tokenId, _data),
1205             "ERC721A: transfer to non ERC721Receiver implementer"
1206         );
1207     }
1208 
1209     /**
1210      * @dev Returns whether `tokenId` exists.
1211      *
1212      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1213      *
1214      * Tokens start existing when they are minted (`_mint`),
1215      */
1216     function _exists(uint256 tokenId) internal view returns (bool) {
1217         return tokenId < currentIndex;
1218     }
1219 
1220     function _safeMint(address to, uint256 quantity) internal {
1221         _safeMint(to, quantity, "");
1222     }
1223 
1224     /**
1225      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1226      *
1227      * Requirements:
1228      *
1229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1230      * - `quantity` must be greater than 0.
1231      *
1232      * Emits a {Transfer} event.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 quantity,
1237         bytes memory _data
1238     ) internal {
1239         _mint(to, quantity, _data, true);
1240     }
1241 
1242     /**
1243      * @dev Mints `quantity` tokens and transfers them to `to`.
1244      *
1245      * Requirements:
1246      *
1247      * - `to` cannot be the zero address.
1248      * - `quantity` must be greater than 0.
1249      *
1250      * Emits a {Transfer} event.
1251      */
1252     function _mint(
1253         address to,
1254         uint256 quantity,
1255         bytes memory _data,
1256         bool safe
1257     ) internal {
1258         uint256 startTokenId = currentIndex;
1259         require(to != address(0), "ERC721A: mint to the zero address");
1260         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1261 
1262         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1263 
1264         // Overflows are incredibly unrealistic.
1265         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1266         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1267         unchecked {
1268             _addressData[to].balance += uint128(quantity);
1269             _addressData[to].numberMinted += uint128(quantity);
1270 
1271             _ownerships[startTokenId].addr = to;
1272             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1273 
1274             uint256 updatedIndex = startTokenId;
1275 
1276             for (uint256 i; i < quantity; i++) {
1277                 emit Transfer(address(0), to, updatedIndex);
1278                 if (safe) {
1279                     require(
1280                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1281                         "ERC721A: transfer to non ERC721Receiver implementer"
1282                     );
1283                 }
1284 
1285                 updatedIndex++;
1286             }
1287 
1288             currentIndex = updatedIndex;
1289         }
1290 
1291         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1292     }
1293 
1294     /**
1295      * @dev Transfers `tokenId` from `from` to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `to` cannot be the zero address.
1300      * - `tokenId` token must be owned by `from`.
1301      *
1302      * Emits a {Transfer} event.
1303      */
1304     function _transfer(
1305         address from,
1306         address to,
1307         uint256 tokenId
1308     ) private {
1309         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1310 
1311         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1312             getApproved(tokenId) == _msgSender() ||
1313             isApprovedForAll(prevOwnership.addr, _msgSender()));
1314 
1315         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1316 
1317         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1318         require(to != address(0), "ERC721A: transfer to the zero address");
1319 
1320         _beforeTokenTransfers(from, to, tokenId, 1);
1321 
1322         // Clear approvals from the previous owner
1323         _approve(address(0), tokenId, prevOwnership.addr);
1324 
1325         // Underflow of the sender's balance is impossible because we check for
1326         // ownership above and the recipient's balance can't realistically overflow.
1327         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1328         unchecked {
1329             _addressData[from].balance -= 1;
1330             _addressData[to].balance += 1;
1331 
1332             _ownerships[tokenId].addr = to;
1333             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1334 
1335             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1336             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1337             uint256 nextTokenId = tokenId + 1;
1338             if (_ownerships[nextTokenId].addr == address(0)) {
1339                 if (_exists(nextTokenId)) {
1340                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1341                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1342                 }
1343             }
1344         }
1345 
1346         emit Transfer(from, to, tokenId);
1347         _afterTokenTransfers(from, to, tokenId, 1);
1348     }
1349 
1350     /**
1351      * @dev Approve `to` to operate on `tokenId`
1352      *
1353      * Emits a {Approval} event.
1354      */
1355     function _approve(
1356         address to,
1357         uint256 tokenId,
1358         address owner
1359     ) private {
1360         _tokenApprovals[tokenId] = to;
1361         emit Approval(owner, to, tokenId);
1362     }
1363 
1364     /**
1365      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1366      * The call is not executed if the target address is not a contract.
1367      *
1368      * @param from address representing the previous owner of the given token ID
1369      * @param to target address that will receive the tokens
1370      * @param tokenId uint256 ID of the token to be transferred
1371      * @param _data bytes optional data to send along with the call
1372      * @return bool whether the call correctly returned the expected magic value
1373      */
1374     function _checkOnERC721Received(
1375         address from,
1376         address to,
1377         uint256 tokenId,
1378         bytes memory _data
1379     ) private returns (bool) {
1380         if (to.isContract()) {
1381             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1382                 return retval == IERC721Receiver(to).onERC721Received.selector;
1383             } catch (bytes memory reason) {
1384                 if (reason.length == 0) {
1385                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1386                 } else {
1387                     assembly {
1388                         revert(add(32, reason), mload(reason))
1389                     }
1390                 }
1391             }
1392         } else {
1393             return true;
1394         }
1395     }
1396 
1397     /**
1398      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1399      *
1400      * startTokenId - the first token id to be transferred
1401      * quantity - the amount to be transferred
1402      *
1403      * Calling conditions:
1404      *
1405      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1406      * transferred to `to`.
1407      * - When `from` is zero, `tokenId` will be minted for `to`.
1408      */
1409     function _beforeTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 
1416     /**
1417      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1418      * minting.
1419      *
1420      * startTokenId - the first token id to be transferred
1421      * quantity - the amount to be transferred
1422      *
1423      * Calling conditions:
1424      *
1425      * - when `from` and `to` are both non-zero.
1426      * - `from` and `to` are never both zero.
1427      */
1428     function _afterTokenTransfers(
1429         address from,
1430         address to,
1431         uint256 startTokenId,
1432         uint256 quantity
1433     ) internal virtual {}
1434 }
1435 
1436 contract Goldiggerz is ERC721A, Ownable, ReentrancyGuard {
1437 
1438   string public        baseURI           = "ipfs://QmWkWQR5ucDh6PaSFS4BhjkuC6ESMGdCR2Hn2HLvdufz25/";
1439   uint public          price             = 0 ether;
1440   uint public          maxPerTx          = 3;
1441   uint public          maxPerWallet      = 3;
1442   uint public          totalFree         = 10000;
1443   uint public          maxSupply         = 10000;
1444   uint public          nextOwnerToExplicitlySet;
1445   bool public          mintEnabled;
1446 
1447   constructor() ERC721A("Goldiggerz", "GDZ"){}
1448 
1449   function mint(uint256 amt) external payable
1450   {
1451     uint cost = price;
1452     if(totalSupply() + amt < totalFree + 1) {
1453       cost = 0;
1454     }
1455     require(msg.sender == tx.origin,"Be yourself, honey.");
1456     require(msg.value == amt * cost,"Please send the exact amount.");
1457     require(totalSupply() + amt < maxSupply + 1,"No more");
1458     require(mintEnabled, "Minting is not live yet, hold on.");
1459     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1460     require( amt < maxPerTx + 1, "Max per TX reached.");
1461 
1462     _safeMint(msg.sender, amt);
1463   }
1464 
1465   function ownerBatchMint(uint256 amt) external onlyOwner
1466   {
1467     require(totalSupply() + amt < maxSupply + 1,"too many!");
1468 
1469     _safeMint(msg.sender, amt);
1470   }
1471 
1472   function toggleMinting() external onlyOwner {
1473       mintEnabled = !mintEnabled;
1474   }
1475 
1476   function setMaxTokensPerWallet(uint8 _maxTokensPerWallet) external onlyOwner {
1477         maxPerWallet = _maxTokensPerWallet;
1478     }
1479 
1480     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1481     maxPerTx = _maxMintAmountPerTx;
1482   }
1483 
1484   function costCheck() public view returns (uint256 _cost) {
1485       if(totalSupply() < totalFree)
1486         return 0;
1487       else 
1488          return price;
1489   }
1490 
1491   function numberMinted(address owner) public view returns (uint256) {
1492     return _numberMinted(owner);
1493   }
1494 
1495   function setBaseURI(string calldata baseURI_) external onlyOwner {
1496     baseURI = baseURI_;
1497   }
1498 
1499   function setPrice(uint256 price_) external onlyOwner {
1500       price = price_;
1501   }
1502 
1503   function setTotalFree(uint256 totalFree_) external onlyOwner {
1504       totalFree = totalFree_;
1505   }
1506 
1507   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1508       maxPerTx = maxPerTx_;
1509   }
1510 
1511   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1512       maxPerWallet = maxPerWallet_;
1513   }
1514 
1515   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1516       maxSupply = maxSupply_;
1517   }
1518 
1519   function _baseURI() internal view virtual override returns (string memory) {
1520     return baseURI;
1521   }
1522 
1523   function withdraw() external onlyOwner nonReentrant {
1524     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1525     require(success, "Transfer failed.");
1526   }
1527 
1528   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1529     _setOwnersExplicit(quantity);
1530   }
1531 
1532   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1533   {
1534     return ownershipOf(tokenId);
1535   }
1536 
1537 
1538   /**
1539     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1540     */
1541   function _setOwnersExplicit(uint256 quantity) internal {
1542       require(quantity != 0, "quantity must be nonzero");
1543       require(currentIndex != 0, "no tokens minted yet");
1544       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1545       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1546 
1547       // Index underflow is impossible.
1548       // Counter or index overflow is incredibly unrealistic.
1549       unchecked {
1550           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1551 
1552           // Set the end index to be the last token index
1553           if (endIndex + 1 > currentIndex) {
1554               endIndex = currentIndex - 1;
1555           }
1556 
1557           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1558               if (_ownerships[i].addr == address(0)) {
1559                   TokenOwnership memory ownership = ownershipOf(i);
1560                   _ownerships[i].addr = ownership.addr;
1561                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1562               }
1563           }
1564 
1565           nextOwnerToExplicitlySet = endIndex + 1;
1566       }
1567   }
1568 }