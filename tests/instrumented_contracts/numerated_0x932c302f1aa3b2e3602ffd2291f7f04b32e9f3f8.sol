1 // File: contracts/PersianCat.sol
2 
3 
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-05-22
7 */
8 
9 // File: contracts/PersianCat.sol
10 
11 
12 
13 /**
14  * @title PersianCat contract
15 */
16 
17 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
18 
19 
20 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Contract module that helps prevent reentrant calls to a function.
111  *
112  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
113  * available, which can be applied to functions to make sure there are no nested
114  * (reentrant) calls to them.
115  *
116  * Note that because there is a single `nonReentrant` guard, functions marked as
117  * `nonReentrant` may not call one another. This can be worked around by making
118  * those functions `private`, and then adding `external` `nonReentrant` entry
119  * points to them.
120  *
121  * TIP: If you would like to learn more about reentrancy and alternative ways
122  * to protect against it, check out our blog post
123  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
124  */
125 abstract contract ReentrancyGuard {
126     // Booleans are more expensive than uint256 or any type that takes up a full
127     // word because each write operation emits an extra SLOAD to first read the
128     // slot's contents, replace the bits taken up by the boolean, and then write
129     // back. This is the compiler's defense against contract upgrades and
130     // pointer aliasing, and it cannot be disabled.
131 
132     // The values being non-zero value makes deployment a bit more expensive,
133     // but in exchange the refund on every call to nonReentrant will be lower in
134     // amount. Since refunds are capped to a percentage of the total
135     // transaction's gas, it is best to keep them low in cases like this one, to
136     // increase the likelihood of the full refund coming into effect.
137     uint256 private constant _NOT_ENTERED = 1;
138     uint256 private constant _ENTERED = 2;
139 
140     uint256 private _status;
141 
142     constructor() {
143         _status = _NOT_ENTERED;
144     }
145 
146     /**
147      * @dev Prevents a contract from calling itself, directly or indirectly.
148      * Calling a `nonReentrant` function from another `nonReentrant`
149      * function is not supported. It is possible to prevent this from happening
150      * by making the `nonReentrant` function external, and making it call a
151      * `private` function that does the actual work.
152      */
153     modifier nonReentrant() {
154         // On the first call to nonReentrant, _notEntered will be true
155         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
156 
157         // Any calls to nonReentrant after this point will fail
158         _status = _ENTERED;
159 
160         _;
161 
162         // By storing the original value once again, a refund is triggered (see
163         // https://eips.ethereum.org/EIPS/eip-2200)
164         _status = _NOT_ENTERED;
165     }
166 }
167 
168 // File: @openzeppelin/contracts/utils/Strings.sol
169 
170 
171 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
172 
173 pragma solidity ^0.8.0;
174 
175 /**
176  * @dev String operations.
177  */
178 library Strings {
179     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
180 
181     /**
182      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
183      */
184     function toString(uint256 value) internal pure returns (string memory) {
185         // Inspired by OraclizeAPI's implementation - MIT licence
186         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
187 
188         if (value == 0) {
189             return "0";
190         }
191         uint256 temp = value;
192         uint256 digits;
193         while (temp != 0) {
194             digits++;
195             temp /= 10;
196         }
197         bytes memory buffer = new bytes(digits);
198         while (value != 0) {
199             digits -= 1;
200             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
201             value /= 10;
202         }
203         return string(buffer);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
208      */
209     function toHexString(uint256 value) internal pure returns (string memory) {
210         if (value == 0) {
211             return "0x00";
212         }
213         uint256 temp = value;
214         uint256 length = 0;
215         while (temp != 0) {
216             length++;
217             temp >>= 8;
218         }
219         return toHexString(value, length);
220     }
221 
222     /**
223      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
224      */
225     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
226         bytes memory buffer = new bytes(2 * length + 2);
227         buffer[0] = "0";
228         buffer[1] = "x";
229         for (uint256 i = 2 * length + 1; i > 1; --i) {
230             buffer[i] = _HEX_SYMBOLS[value & 0xf];
231             value >>= 4;
232         }
233         require(value == 0, "Strings: hex length insufficient");
234         return string(buffer);
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/Context.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Provides information about the current execution context, including the
247  * sender of the transaction and its data. While these are generally available
248  * via msg.sender and msg.data, they should not be accessed in such a direct
249  * manner, since when dealing with meta-transactions the account sending and
250  * paying for execution may not be the actual sender (as far as an application
251  * is concerned).
252  *
253  * This contract is only required for intermediate, library-like contracts.
254  */
255 abstract contract Context {
256     function _msgSender() internal view virtual returns (address) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view virtual returns (bytes calldata) {
261         return msg.data;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/access/Ownable.sol
266 
267 
268 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
269 
270 pragma solidity ^0.8.0;
271 
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 abstract contract Ownable is Context {
286     address private _owner;
287 
288     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290     /**
291      * @dev Initializes the contract setting the deployer as the initial owner.
292      */
293     constructor() {
294         _transferOwnership(_msgSender());
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view virtual returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(owner() == _msgSender(), "Ownable: caller is not the owner");
309         _;
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public virtual onlyOwner {
320         _transferOwnership(address(0));
321     }
322 
323     /**
324      * @dev Transfers ownership of the contract to a new account (`newOwner`).
325      * Can only be called by the current owner.
326      */
327     function transferOwnership(address newOwner) public virtual onlyOwner {
328         require(newOwner != address(0), "Ownable: new owner is the zero address");
329         _transferOwnership(newOwner);
330     }
331 
332     /**
333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
334      * Internal function without access restriction.
335      */
336     function _transferOwnership(address newOwner) internal virtual {
337         address oldOwner = _owner;
338         _owner = newOwner;
339         emit OwnershipTransferred(oldOwner, newOwner);
340     }
341 }
342 
343 // File: @openzeppelin/contracts/utils/Address.sol
344 
345 
346 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Collection of functions related to the address type
352  */
353 library Address {
354     /**
355      * @dev Returns true if `account` is a contract.
356      *
357      * [IMPORTANT]
358      * ====
359      * It is unsafe to assume that an address for which this function returns
360      * false is an externally-owned account (EOA) and not a contract.
361      *
362      * Among others, `isContract` will return false for the following
363      * types of addresses:
364      *
365      *  - an externally-owned account
366      *  - a contract in construction
367      *  - an address where a contract will be created
368      *  - an address where a contract lived, but was destroyed
369      * ====
370      *
371      * [IMPORTANT]
372      * ====
373      * You shouldn't rely on `isContract` to protect against flash loan attacks!
374      *
375      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
376      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
377      * constructor.
378      * ====
379      */
380     function isContract(address account) internal view returns (bool) {
381         // This method relies on extcodesize/address.code.length, which returns 0
382         // for contracts in construction, since the code is only stored at the end
383         // of the constructor execution.
384 
385         return account.code.length > 0;
386     }
387 
388     /**
389      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
390      * `recipient`, forwarding all available gas and reverting on errors.
391      *
392      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
393      * of certain opcodes, possibly making contracts go over the 2300 gas limit
394      * imposed by `transfer`, making them unable to receive funds via
395      * `transfer`. {sendValue} removes this limitation.
396      *
397      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
398      *
399      * IMPORTANT: because control is transferred to `recipient`, care must be
400      * taken to not create reentrancy vulnerabilities. Consider using
401      * {ReentrancyGuard} or the
402      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
403      */
404     function sendValue(address payable recipient, uint256 amount) internal {
405         require(address(this).balance >= amount, "Address: insufficient balance");
406 
407         (bool success, ) = recipient.call{value: amount}("");
408         require(success, "Address: unable to send value, recipient may have reverted");
409     }
410 
411     /**
412      * @dev Performs a Solidity function call using a low level `call`. A
413      * plain `call` is an unsafe replacement for a function call: use this
414      * function instead.
415      *
416      * If `target` reverts with a revert reason, it is bubbled up by this
417      * function (like regular Solidity function calls).
418      *
419      * Returns the raw returned data. To convert to the expected return value,
420      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
421      *
422      * Requirements:
423      *
424      * - `target` must be a contract.
425      * - calling `target` with `data` must not revert.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionCall(target, data, "Address: low-level call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
435      * `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, 0, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but also transferring `value` wei to `target`.
450      *
451      * Requirements:
452      *
453      * - the calling contract must have an ETH balance of at least `value`.
454      * - the called Solidity function must be `payable`.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value
462     ) internal returns (bytes memory) {
463         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
468      * with `errorMessage` as a fallback revert reason when `target` reverts.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(
473         address target,
474         bytes memory data,
475         uint256 value,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         require(address(this).balance >= value, "Address: insufficient balance for call");
479         require(isContract(target), "Address: call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.call{value: value}(data);
482         return verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
492         return functionStaticCall(target, data, "Address: low-level static call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal view returns (bytes memory) {
506         require(isContract(target), "Address: static call to non-contract");
507 
508         (bool success, bytes memory returndata) = target.staticcall(data);
509         return verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         require(isContract(target), "Address: delegate call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.delegatecall(data);
536         return verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
541      * revert reason using the provided one.
542      *
543      * _Available since v4.3._
544      */
545     function verifyCallResult(
546         bool success,
547         bytes memory returndata,
548         string memory errorMessage
549     ) internal pure returns (bytes memory) {
550         if (success) {
551             return returndata;
552         } else {
553             // Look for revert reason and bubble it up if present
554             if (returndata.length > 0) {
555                 // The easiest way to bubble the revert reason is using memory via assembly
556 
557                 assembly {
558                     let returndata_size := mload(returndata)
559                     revert(add(32, returndata), returndata_size)
560                 }
561             } else {
562                 revert(errorMessage);
563             }
564         }
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
569 
570 
571 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 
577 /**
578  * @title SafeERC20
579  * @dev Wrappers around ERC20 operations that throw on failure (when the token
580  * contract returns false). Tokens that return no value (and instead revert or
581  * throw on failure) are also supported, non-reverting calls are assumed to be
582  * successful.
583  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
584  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
585  */
586 library SafeERC20 {
587     using Address for address;
588 
589     function safeTransfer(
590         IERC20 token,
591         address to,
592         uint256 value
593     ) internal {
594         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
595     }
596 
597     function safeTransferFrom(
598         IERC20 token,
599         address from,
600         address to,
601         uint256 value
602     ) internal {
603         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
604     }
605 
606     /**
607      * @dev Deprecated. This function has issues similar to the ones found in
608      * {IERC20-approve}, and its usage is discouraged.
609      *
610      * Whenever possible, use {safeIncreaseAllowance} and
611      * {safeDecreaseAllowance} instead.
612      */
613     function safeApprove(
614         IERC20 token,
615         address spender,
616         uint256 value
617     ) internal {
618         // safeApprove should only be called when setting an initial allowance,
619         // or when resetting it to zero. To increase and decrease it, use
620         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
621         require(
622             (value == 0) || (token.allowance(address(this), spender) == 0),
623             "SafeERC20: approve from non-zero to non-zero allowance"
624         );
625         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
626     }
627 
628     function safeIncreaseAllowance(
629         IERC20 token,
630         address spender,
631         uint256 value
632     ) internal {
633         uint256 newAllowance = token.allowance(address(this), spender) + value;
634         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
635     }
636 
637     function safeDecreaseAllowance(
638         IERC20 token,
639         address spender,
640         uint256 value
641     ) internal {
642         unchecked {
643             uint256 oldAllowance = token.allowance(address(this), spender);
644             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
645             uint256 newAllowance = oldAllowance - value;
646             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
647         }
648     }
649 
650     /**
651      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
652      * on the return value: the return value is optional (but if data is returned, it must not be false).
653      * @param token The token targeted by the call.
654      * @param data The call data (encoded using abi.encode or one of its variants).
655      */
656     function _callOptionalReturn(IERC20 token, bytes memory data) private {
657         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
658         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
659         // the target address contains contract code and also asserts for success in the low-level call.
660 
661         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
662         if (returndata.length > 0) {
663             // Return data is optional
664             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
665         }
666     }
667 }
668 
669 
670 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @title ERC721 token receiver interface
679  * @dev Interface for any contract that wants to support safeTransfers
680  * from ERC721 asset contracts.
681  */
682 interface IERC721Receiver {
683     /**
684      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
685      * by `operator` from `from`, this function is called.
686      *
687      * It must return its Solidity selector to confirm the token transfer.
688      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
689      *
690      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
691      */
692     function onERC721Received(
693         address operator,
694         address from,
695         uint256 tokenId,
696         bytes calldata data
697     ) external returns (bytes4);
698 }
699 
700 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
701 
702 
703 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @dev Interface of the ERC165 standard, as defined in the
709  * https://eips.ethereum.org/EIPS/eip-165[EIP].
710  *
711  * Implementers can declare support of contract interfaces, which can then be
712  * queried by others ({ERC165Checker}).
713  *
714  * For an implementation, see {ERC165}.
715  */
716 interface IERC165 {
717     /**
718      * @dev Returns true if this contract implements the interface defined by
719      * `interfaceId`. See the corresponding
720      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
721      * to learn more about how these ids are created.
722      *
723      * This function call must use less than 30 000 gas.
724      */
725     function supportsInterface(bytes4 interfaceId) external view returns (bool);
726 }
727 
728 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 /**
737  * @dev Implementation of the {IERC165} interface.
738  *
739  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
740  * for the additional interface id that will be supported. For example:
741  *
742  * ```solidity
743  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
744  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
745  * }
746  * ```
747  *
748  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
749  */
750 abstract contract ERC165 is IERC165 {
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
755         return interfaceId == type(IERC165).interfaceId;
756     }
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @dev Required interface of an ERC721 compliant contract.
769  */
770 interface IERC721 is IERC165 {
771     /**
772      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
773      */
774     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
775 
776     /**
777      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
778      */
779     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
780 
781     /**
782      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
783      */
784     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
785 
786     /**
787      * @dev Returns the number of tokens in ``owner``'s account.
788      */
789     function balanceOf(address owner) external view returns (uint256 balance);
790 
791     /**
792      * @dev Returns the owner of the `tokenId` token.
793      *
794      * Requirements:
795      *
796      * - `tokenId` must exist.
797      */
798     function ownerOf(uint256 tokenId) external view returns (address owner);
799 
800     /**
801      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
802      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
803      *
804      * Requirements:
805      *
806      * - `from` cannot be the zero address.
807      * - `to` cannot be the zero address.
808      * - `tokenId` token must exist and be owned by `from`.
809      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
810      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
811      *
812      * Emits a {Transfer} event.
813      */
814     function safeTransferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) external;
819 
820     /**
821      * @dev Transfers `tokenId` token from `from` to `to`.
822      *
823      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
824      *
825      * Requirements:
826      *
827      * - `from` cannot be the zero address.
828      * - `to` cannot be the zero address.
829      * - `tokenId` token must be owned by `from`.
830      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
831      *
832      * Emits a {Transfer} event.
833      */
834     function transferFrom(
835         address from,
836         address to,
837         uint256 tokenId
838     ) external;
839 
840     /**
841      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
842      * The approval is cleared when the token is transferred.
843      *
844      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
845      *
846      * Requirements:
847      *
848      * - The caller must own the token or be an approved operator.
849      * - `tokenId` must exist.
850      *
851      * Emits an {Approval} event.
852      */
853     function approve(address to, uint256 tokenId) external;
854 
855     /**
856      * @dev Returns the account approved for `tokenId` token.
857      *
858      * Requirements:
859      *
860      * - `tokenId` must exist.
861      */
862     function getApproved(uint256 tokenId) external view returns (address operator);
863 
864     /**
865      * @dev Approve or remove `operator` as an operator for the caller.
866      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
867      *
868      * Requirements:
869      *
870      * - The `operator` cannot be the caller.
871      *
872      * Emits an {ApprovalForAll} event.
873      */
874     function setApprovalForAll(address operator, bool _approved) external;
875 
876     /**
877      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
878      *
879      * See {setApprovalForAll}
880      */
881     function isApprovedForAll(address owner, address operator) external view returns (bool);
882 
883     /**
884      * @dev Safely transfers `tokenId` token from `from` to `to`.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must exist and be owned by `from`.
891      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId,
900         bytes calldata data
901     ) external;
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
905 
906 
907 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
914  * @dev See https://eips.ethereum.org/EIPS/eip-721
915  */
916 interface IERC721Enumerable is IERC721 {
917     /**
918      * @dev Returns the total amount of tokens stored by the contract.
919      */
920     function totalSupply() external view returns (uint256);
921 
922     /**
923      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
924      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
925      */
926     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
927 
928     /**
929      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
930      * Use along with {totalSupply} to enumerate all tokens.
931      */
932     function tokenByIndex(uint256 index) external view returns (uint256);
933 }
934 
935 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 /**
944  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
945  * @dev See https://eips.ethereum.org/EIPS/eip-721
946  */
947 interface IERC721Metadata is IERC721 {
948     /**
949      * @dev Returns the token collection name.
950      */
951     function name() external view returns (string memory);
952 
953     /**
954      * @dev Returns the token collection symbol.
955      */
956     function symbol() external view returns (string memory);
957 
958     /**
959      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
960      */
961     function tokenURI(uint256 tokenId) external view returns (string memory);
962 }
963 
964 
965 pragma solidity ^0.8.0;
966 
967 
968 /**
969  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
970  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
971  *
972  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
973  *
974  * Does not support burning tokens to address(0).
975  *
976  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
977  */
978 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
979     using Address for address;
980     using Strings for uint256;
981 
982     struct TokenOwnership {
983         address addr;
984         uint64 startTimestamp;
985     }
986 
987     struct AddressData {
988         uint128 balance;
989         uint128 numberMinted;
990     }
991 
992     uint256 internal currentIndex;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1002     mapping(uint256 => TokenOwnership) internal _ownerships;
1003 
1004     // Mapping owner address to address data
1005     mapping(address => AddressData) private _addressData;
1006 
1007     // Mapping from token ID to approved address
1008     mapping(uint256 => address) private _tokenApprovals;
1009 
1010     // Mapping from owner to operator approvals
1011     mapping(address => mapping(address => bool)) private _operatorApprovals;
1012 
1013     constructor(string memory name_, string memory symbol_) {
1014         _name = name_;
1015         _symbol = symbol_;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Enumerable-totalSupply}.
1020      */
1021     function totalSupply() public view override returns (uint256) {
1022         return currentIndex;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Enumerable-tokenByIndex}.
1027      */
1028     function tokenByIndex(uint256 index) public view override returns (uint256) {
1029         require(index < totalSupply(), "ERC721A: global index out of bounds");
1030         return index;
1031     }
1032 
1033     /**
1034      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1035      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1036      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1037      */
1038     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1039         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1040         uint256 numMintedSoFar = totalSupply();
1041         uint256 tokenIdsIdx;
1042         address currOwnershipAddr;
1043 
1044         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1045         unchecked {
1046             for (uint256 i; i < numMintedSoFar; i++) {
1047                 TokenOwnership memory ownership = _ownerships[i];
1048                 if (ownership.addr != address(0)) {
1049                     currOwnershipAddr = ownership.addr;
1050                 }
1051                 if (currOwnershipAddr == owner) {
1052                     if (tokenIdsIdx == index) {
1053                         return i;
1054                     }
1055                     tokenIdsIdx++;
1056                 }
1057             }
1058         }
1059 
1060         revert("ERC721A: unable to get token of owner by index");
1061     }
1062 
1063     /**
1064      * @dev See {IERC165-supportsInterface}.
1065      */
1066     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1067         return
1068             interfaceId == type(IERC721).interfaceId ||
1069             interfaceId == type(IERC721Metadata).interfaceId ||
1070             interfaceId == type(IERC721Enumerable).interfaceId ||
1071             super.supportsInterface(interfaceId);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-balanceOf}.
1076      */
1077     function balanceOf(address owner) public view override returns (uint256) {
1078         require(owner != address(0), "ERC721A: balance query for the zero address");
1079         return uint256(_addressData[owner].balance);
1080     }
1081 
1082     function _numberMinted(address owner) internal view returns (uint256) {
1083         require(owner != address(0), "ERC721A: number minted query for the zero address");
1084         return uint256(_addressData[owner].numberMinted);
1085     }
1086 
1087     /**
1088      * Gas spent here starts off proportional to the maximum mint batch size.
1089      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1090      */
1091     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1092         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1093 
1094         unchecked {
1095             for (uint256 curr = tokenId; curr >= 0; curr--) {
1096                 TokenOwnership memory ownership = _ownerships[curr];
1097                 if (ownership.addr != address(0)) {
1098                     return ownership;
1099                 }
1100             }
1101         }
1102 
1103         revert("ERC721A: unable to determine the owner of token");
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-ownerOf}.
1108      */
1109     function ownerOf(uint256 tokenId) public view override returns (address) {
1110         return ownershipOf(tokenId).addr;
1111     }
1112 
1113     /**
1114      * @dev See {IERC721Metadata-name}.
1115      */
1116     function name() public view virtual override returns (string memory) {
1117         return _name;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Metadata-symbol}.
1122      */
1123     function symbol() public view virtual override returns (string memory) {
1124         return _symbol;
1125     }
1126 
1127     /**
1128      * @dev See {IERC721Metadata-tokenURI}.
1129      */
1130     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1131         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1132 
1133         string memory baseURI = _baseURI();
1134         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1135     }
1136 
1137     /**
1138      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1139      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1140      * by default, can be overriden in child contracts.
1141      */
1142     function _baseURI() internal view virtual returns (string memory) {
1143         return "";
1144     }
1145 
1146     /**
1147      * @dev See {IERC721-approve}.
1148      */
1149     function approve(address to, uint256 tokenId) public override {
1150         address owner = ERC721A.ownerOf(tokenId);
1151         require(to != owner, "ERC721A: approval to current owner");
1152 
1153         require(
1154             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1155             "ERC721A: approve caller is not owner nor approved for all"
1156         );
1157 
1158         _approve(to, tokenId, owner);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-getApproved}.
1163      */
1164     function getApproved(uint256 tokenId) public view override returns (address) {
1165         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1166 
1167         return _tokenApprovals[tokenId];
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-setApprovalForAll}.
1172      */
1173     function setApprovalForAll(address operator, bool approved) public override {
1174         require(operator != _msgSender(), "ERC721A: approve to caller");
1175 
1176         _operatorApprovals[_msgSender()][operator] = approved;
1177         emit ApprovalForAll(_msgSender(), operator, approved);
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-isApprovedForAll}.
1182      */
1183     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1184         return _operatorApprovals[owner][operator];
1185     }
1186 
1187     /**
1188      * @dev See {IERC721-transferFrom}.
1189      */
1190     function transferFrom(
1191         address from,
1192         address to,
1193         uint256 tokenId
1194     ) public virtual override {
1195         _transfer(from, to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-safeTransferFrom}.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public virtual override {
1206         safeTransferFrom(from, to, tokenId, "");
1207     }
1208 
1209     /**
1210      * @dev See {IERC721-safeTransferFrom}.
1211      */
1212     function safeTransferFrom(
1213         address from,
1214         address to,
1215         uint256 tokenId,
1216         bytes memory _data
1217     ) public override {
1218         _transfer(from, to, tokenId);
1219         require(
1220             _checkOnERC721Received(from, to, tokenId, _data),
1221             "ERC721A: transfer to non ERC721Receiver implementer"
1222         );
1223     }
1224 
1225     /**
1226      * @dev Returns whether `tokenId` exists.
1227      *
1228      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1229      *
1230      * Tokens start existing when they are minted (`_mint`),
1231      */
1232     function _exists(uint256 tokenId) internal view returns (bool) {
1233         return tokenId < currentIndex;
1234     }
1235 
1236     function _safeMint(address to, uint256 quantity) internal {
1237         _safeMint(to, quantity, "");
1238     }
1239 
1240     /**
1241      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1242      *
1243      * Requirements:
1244      *
1245      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1246      * - `quantity` must be greater than 0.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _safeMint(
1251         address to,
1252         uint256 quantity,
1253         bytes memory _data
1254     ) internal {
1255         _mint(to, quantity, _data, true);
1256     }
1257 
1258     /**
1259      * @dev Mints `quantity` tokens and transfers them to `to`.
1260      *
1261      * Requirements:
1262      *
1263      * - `to` cannot be the zero address.
1264      * - `quantity` must be greater than 0.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _mint(
1269         address to,
1270         uint256 quantity,
1271         bytes memory _data,
1272         bool safe
1273     ) internal {
1274         uint256 startTokenId = currentIndex;
1275         require(to != address(0), "ERC721A: mint to the zero address");
1276         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1277 
1278         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1279 
1280         // Overflows are incredibly unrealistic.
1281         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1282         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1283         unchecked {
1284             _addressData[to].balance += uint128(quantity);
1285             _addressData[to].numberMinted += uint128(quantity);
1286 
1287             _ownerships[startTokenId].addr = to;
1288             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1289 
1290             uint256 updatedIndex = startTokenId;
1291 
1292             for (uint256 i; i < quantity; i++) {
1293                 emit Transfer(address(0), to, updatedIndex);
1294                 if (safe) {
1295                     require(
1296                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1297                         "ERC721A: transfer to non ERC721Receiver implementer"
1298                     );
1299                 }
1300 
1301                 updatedIndex++;
1302             }
1303 
1304             currentIndex = updatedIndex;
1305         }
1306 
1307         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1308     }
1309 
1310     /**
1311      * @dev Transfers `tokenId` from `from` to `to`.
1312      *
1313      * Requirements:
1314      *
1315      * - `to` cannot be the zero address.
1316      * - `tokenId` token must be owned by `from`.
1317      *
1318      * Emits a {Transfer} event.
1319      */
1320     function _transfer(
1321         address from,
1322         address to,
1323         uint256 tokenId
1324     ) private {
1325         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1326 
1327         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1328             getApproved(tokenId) == _msgSender() ||
1329             isApprovedForAll(prevOwnership.addr, _msgSender()));
1330 
1331         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1332 
1333         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1334         require(to != address(0), "ERC721A: transfer to the zero address");
1335 
1336         _beforeTokenTransfers(from, to, tokenId, 1);
1337 
1338         // Clear approvals from the previous owner
1339         _approve(address(0), tokenId, prevOwnership.addr);
1340 
1341         // Underflow of the sender's balance is impossible because we check for
1342         // ownership above and the recipient's balance can't realistically overflow.
1343         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1344         unchecked {
1345             _addressData[from].balance -= 1;
1346             _addressData[to].balance += 1;
1347 
1348             _ownerships[tokenId].addr = to;
1349             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1350 
1351             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1352             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1353             uint256 nextTokenId = tokenId + 1;
1354             if (_ownerships[nextTokenId].addr == address(0)) {
1355                 if (_exists(nextTokenId)) {
1356                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1357                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1358                 }
1359             }
1360         }
1361 
1362         emit Transfer(from, to, tokenId);
1363         _afterTokenTransfers(from, to, tokenId, 1);
1364     }
1365 
1366     /**
1367      * @dev Approve `to` to operate on `tokenId`
1368      *
1369      * Emits a {Approval} event.
1370      */
1371     function _approve(
1372         address to,
1373         uint256 tokenId,
1374         address owner
1375     ) private {
1376         _tokenApprovals[tokenId] = to;
1377         emit Approval(owner, to, tokenId);
1378     }
1379 
1380     /**
1381      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1382      * The call is not executed if the target address is not a contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param _data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) private returns (bool) {
1396         if (to.isContract()) {
1397             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1398                 return retval == IERC721Receiver(to).onERC721Received.selector;
1399             } catch (bytes memory reason) {
1400                 if (reason.length == 0) {
1401                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1402                 } else {
1403                     assembly {
1404                         revert(add(32, reason), mload(reason))
1405                     }
1406                 }
1407             }
1408         } else {
1409             return true;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1415      *
1416      * startTokenId - the first token id to be transferred
1417      * quantity - the amount to be transferred
1418      *
1419      * Calling conditions:
1420      *
1421      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1422      * transferred to `to`.
1423      * - When `from` is zero, `tokenId` will be minted for `to`.
1424      */
1425     function _beforeTokenTransfers(
1426         address from,
1427         address to,
1428         uint256 startTokenId,
1429         uint256 quantity
1430     ) internal virtual {}
1431 
1432     /**
1433      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1434      * minting.
1435      *
1436      * startTokenId - the first token id to be transferred
1437      * quantity - the amount to be transferred
1438      *
1439      * Calling conditions:
1440      *
1441      * - when `from` and `to` are both non-zero.
1442      * - `from` and `to` are never both zero.
1443      */
1444     function _afterTokenTransfers(
1445         address from,
1446         address to,
1447         uint256 startTokenId,
1448         uint256 quantity
1449     ) internal virtual {}
1450 }
1451 
1452 contract PersianCat is ERC721A, Ownable, ReentrancyGuard {
1453 
1454   string public        baseURI;
1455   uint public          price             = 0.0069 ether;
1456   uint public          maxPerTx          = 10;
1457   uint public          maxPerWallet      = 30;
1458   uint public          totalFree         = 2500;
1459   uint public          maxSupply         = 3969;
1460   uint public          nextOwnerToExplicitlySet;
1461   bool public          mintEnabled;
1462 
1463   constructor() ERC721A("PersianCat", "PC"){}
1464 
1465   function mint(uint256 amt) external payable
1466   {
1467     uint cost = price;
1468     if(totalSupply() + amt < totalFree + 1) {
1469       cost = 0;
1470     }
1471     require(msg.sender == tx.origin,"Be yourself, honey.");
1472     require(msg.value == amt * cost,"Please send the exact amount.");
1473     require(totalSupply() + amt < maxSupply + 1,"No more Apes available");
1474     require(mintEnabled, "Minting is not live yet.");
1475     require(numberMinted(msg.sender) + amt <= maxPerWallet,"Too many per wallet!");
1476     require( amt < maxPerTx + 1, "Max per TX reached.");
1477 
1478     _safeMint(msg.sender, amt);
1479   }
1480 
1481   function toggleMinting() external onlyOwner {
1482       mintEnabled = !mintEnabled;
1483   }
1484 
1485   function numberMinted(address owner) public view returns (uint256) {
1486     return _numberMinted(owner);
1487   }
1488 
1489   function setBaseURI(string calldata baseURI_) external onlyOwner {
1490     baseURI = baseURI_;
1491   }
1492 
1493   function setPrice(uint256 price_) external onlyOwner {
1494       price = price_;
1495   }
1496 
1497   function setTotalFree(uint256 totalFree_) external onlyOwner {
1498       totalFree = totalFree_;
1499   }
1500 
1501   function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1502       maxPerTx = maxPerTx_;
1503   }
1504 
1505   function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1506       maxPerWallet = maxPerWallet_;
1507   }
1508 
1509   function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1510       maxSupply = maxSupply_;
1511   }
1512 
1513   function _baseURI() internal view virtual override returns (string memory) {
1514     return baseURI;
1515   }
1516 
1517   function withdraw() external onlyOwner nonReentrant {
1518     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1519     require(success, "Transfer failed.");
1520   }
1521 
1522   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1523     _setOwnersExplicit(quantity);
1524   }
1525 
1526   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory)
1527   {
1528     return ownershipOf(tokenId);
1529   }
1530 
1531 
1532   /**
1533     * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1534     */
1535   function _setOwnersExplicit(uint256 quantity) internal {
1536       require(quantity != 0, "quantity must be nonzero");
1537       require(currentIndex != 0, "no tokens minted yet");
1538       uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1539       require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1540 
1541       // Index underflow is impossible.
1542       // Counter or index overflow is incredibly unrealistic.
1543       unchecked {
1544           uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1545 
1546           // Set the end index to be the last token index
1547           if (endIndex + 1 > currentIndex) {
1548               endIndex = currentIndex - 1;
1549           }
1550 
1551           for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1552               if (_ownerships[i].addr == address(0)) {
1553                   TokenOwnership memory ownership = ownershipOf(i);
1554                   _ownerships[i].addr = ownership.addr;
1555                   _ownerships[i].startTimestamp = ownership.startTimestamp;
1556               }
1557           }
1558 
1559           nextOwnerToExplicitlySet = endIndex + 1;
1560       }
1561   }
1562 }