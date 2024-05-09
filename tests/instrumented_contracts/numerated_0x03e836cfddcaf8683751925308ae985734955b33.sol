1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-17
3 */
4 
5 //                                        .:\::::/:.
6 //             +------------------+      .:\:\::/:/:.
7 //             |    NON FRENLY    |     :.:\:\::/:/:.:
8 //             |      TROLLS      |    :=.`  -  -  '.=:
9 //             |                  |    `=(\  0  0  /)='
10 //             |    A free mint   |       (  (__)  )
11 //             |    project <3    |     .--`-vvvv-'--
12 //             +------------------+     |            |
13 //                      | |            /  /(      )\  \
14 //                      | |           /  / (  /\  ) \  \
15 //                      | |          (  | /  /  \  \ |  )
16 //                      | |           ^^ (  (    )  ) ^^
17 //                      | |             __\  \  /  /__
18 //                      | |           `(______||______)'
19 //             ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
20 //
21 // SPDX-License-Identifier: MIT
22 
23 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
24 
25 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `to`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address to, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `from` to `to` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(
87         address from,
88         address to,
89         uint256 amount
90     ) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
108 
109 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Contract module that helps prevent reentrant calls to a function.
115  *
116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
117  * available, which can be applied to functions to make sure there are no nested
118  * (reentrant) calls to them.
119  *
120  * Note that because there is a single `nonReentrant` guard, functions marked as
121  * `nonReentrant` may not call one another. This can be worked around by making
122  * those functions `private`, and then adding `external` `nonReentrant` entry
123  * points to them.
124  *
125  * TIP: If you would like to learn more about reentrancy and alternative ways
126  * to protect against it, check out our blog post
127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
128  */
129 abstract contract ReentrancyGuard {
130     // Booleans are more expensive than uint256 or any type that takes up a full
131     // word because each write operation emits an extra SLOAD to first read the
132     // slot's contents, replace the bits taken up by the boolean, and then write
133     // back. This is the compiler's defense against contract upgrades and
134     // pointer aliasing, and it cannot be disabled.
135 
136     // The values being non-zero value makes deployment a bit more expensive,
137     // but in exchange the refund on every call to nonReentrant will be lower in
138     // amount. Since refunds are capped to a percentage of the total
139     // transaction's gas, it is best to keep them low in cases like this one, to
140     // increase the likelihood of the full refund coming into effect.
141     uint256 private constant _NOT_ENTERED = 1;
142     uint256 private constant _ENTERED = 2;
143 
144     uint256 private _status;
145 
146     constructor() {
147         _status = _NOT_ENTERED;
148     }
149 
150     /**
151      * @dev Prevents a contract from calling itself, directly or indirectly.
152      * Calling a `nonReentrant` function from another `nonReentrant`
153      * function is not supported. It is possible to prevent this from happening
154      * by making the `nonReentrant` function external, and making it call a
155      * `private` function that does the actual work.
156      */
157     modifier nonReentrant() {
158         // On the first call to nonReentrant, _notEntered will be true
159         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161         // Any calls to nonReentrant after this point will fail
162         _status = _ENTERED;
163 
164         _;
165 
166         // By storing the original value once again, a refund is triggered (see
167         // https://eips.ethereum.org/EIPS/eip-2200)
168         _status = _NOT_ENTERED;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Strings.sol
173 
174 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev String operations.
180  */
181 library Strings {
182     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
186      */
187     function toString(uint256 value) internal pure returns (string memory) {
188         // Inspired by OraclizeAPI's implementation - MIT licence
189         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
190 
191         if (value == 0) {
192             return "0";
193         }
194         uint256 temp = value;
195         uint256 digits;
196         while (temp != 0) {
197             digits++;
198             temp /= 10;
199         }
200         bytes memory buffer = new bytes(digits);
201         while (value != 0) {
202             digits -= 1;
203             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
204             value /= 10;
205         }
206         return string(buffer);
207     }
208 
209     /**
210      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
211      */
212     function toHexString(uint256 value) internal pure returns (string memory) {
213         if (value == 0) {
214             return "0x00";
215         }
216         uint256 temp = value;
217         uint256 length = 0;
218         while (temp != 0) {
219             length++;
220             temp >>= 8;
221         }
222         return toHexString(value, length);
223     }
224 
225     /**
226      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
227      */
228     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
229         bytes memory buffer = new bytes(2 * length + 2);
230         buffer[0] = "0";
231         buffer[1] = "x";
232         for (uint256 i = 2 * length + 1; i > 1; --i) {
233             buffer[i] = _HEX_SYMBOLS[value & 0xf];
234             value >>= 4;
235         }
236         require(value == 0, "Strings: hex length insufficient");
237         return string(buffer);
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Context.sol
242 
243 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
244 
245 pragma solidity ^0.8.0;
246 
247 /**
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 abstract contract Context {
258     function _msgSender() internal view virtual returns (address) {
259         return msg.sender;
260     }
261 
262     function _msgData() internal view virtual returns (bytes calldata) {
263         return msg.data;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/access/Ownable.sol
268 
269 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
270 
271 pragma solidity ^0.8.0;
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
345 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
346 
347 pragma solidity ^0.8.1;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      *
370      * [IMPORTANT]
371      * ====
372      * You shouldn't rely on `isContract` to protect against flash loan attacks!
373      *
374      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
375      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
376      * constructor.
377      * ====
378      */
379     function isContract(address account) internal view returns (bool) {
380         // This method relies on extcodesize/address.code.length, which returns 0
381         // for contracts in construction, since the code is only stored at the end
382         // of the constructor execution.
383 
384         return account.code.length > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         (bool success, ) = recipient.call{value: amount}("");
407         require(success, "Address: unable to send value, recipient may have reverted");
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain `call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value
461     ) internal returns (bytes memory) {
462         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
467      * with `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.call{value: value}(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
491         return functionStaticCall(target, data, "Address: low-level static call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.staticcall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
540      * revert reason using the provided one.
541      *
542      * _Available since v4.3._
543      */
544     function verifyCallResult(
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal pure returns (bytes memory) {
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555 
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
568 
569 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
570 
571 pragma solidity ^0.8.0;
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
665 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
666 
667 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @title ERC721 token receiver interface
673  * @dev Interface for any contract that wants to support safeTransfers
674  * from ERC721 asset contracts.
675  */
676 interface IERC721Receiver {
677     /**
678      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
679      * by `operator` from `from`, this function is called.
680      *
681      * It must return its Solidity selector to confirm the token transfer.
682      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
683      *
684      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
685      */
686     function onERC721Received(
687         address operator,
688         address from,
689         uint256 tokenId,
690         bytes calldata data
691     ) external returns (bytes4);
692 }
693 
694 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Interface of the ERC165 standard, as defined in the
702  * https://eips.ethereum.org/EIPS/eip-165[EIP].
703  *
704  * Implementers can declare support of contract interfaces, which can then be
705  * queried by others ({ERC165Checker}).
706  *
707  * For an implementation, see {ERC165}.
708  */
709 interface IERC165 {
710     /**
711      * @dev Returns true if this contract implements the interface defined by
712      * `interfaceId`. See the corresponding
713      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
714      * to learn more about how these ids are created.
715      *
716      * This function call must use less than 30 000 gas.
717      */
718     function supportsInterface(bytes4 interfaceId) external view returns (bool);
719 }
720 
721 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
722 
723 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
724 
725 pragma solidity ^0.8.0;
726 
727 /**
728  * @dev Implementation of the {IERC165} interface.
729  *
730  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
731  * for the additional interface id that will be supported. For example:
732  *
733  * ```solidity
734  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
735  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
736  * }
737  * ```
738  *
739  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
740  */
741 abstract contract ERC165 is IERC165 {
742     /**
743      * @dev See {IERC165-supportsInterface}.
744      */
745     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
746         return interfaceId == type(IERC165).interfaceId;
747     }
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 /**
757  * @dev Required interface of an ERC721 compliant contract.
758  */
759 interface IERC721 is IERC165 {
760     /**
761      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
762      */
763     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
764 
765     /**
766      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
767      */
768     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
769 
770     /**
771      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
772      */
773     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
774 
775     /**
776      * @dev Returns the number of tokens in ``owner``'s account.
777      */
778     function balanceOf(address owner) external view returns (uint256 balance);
779 
780     /**
781      * @dev Returns the owner of the `tokenId` token.
782      *
783      * Requirements:
784      *
785      * - `tokenId` must exist.
786      */
787     function ownerOf(uint256 tokenId) external view returns (address owner);
788 
789     /**
790      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
791      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must exist and be owned by `from`.
798      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
799      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
800      *
801      * Emits a {Transfer} event.
802      */
803     function safeTransferFrom(
804         address from,
805         address to,
806         uint256 tokenId
807     ) external;
808 
809     /**
810      * @dev Transfers `tokenId` token from `from` to `to`.
811      *
812      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
813      *
814      * Requirements:
815      *
816      * - `from` cannot be the zero address.
817      * - `to` cannot be the zero address.
818      * - `tokenId` token must be owned by `from`.
819      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
820      *
821      * Emits a {Transfer} event.
822      */
823     function transferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) external;
828 
829     /**
830      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
831      * The approval is cleared when the token is transferred.
832      *
833      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
834      *
835      * Requirements:
836      *
837      * - The caller must own the token or be an approved operator.
838      * - `tokenId` must exist.
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address to, uint256 tokenId) external;
843 
844     /**
845      * @dev Returns the account approved for `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function getApproved(uint256 tokenId) external view returns (address operator);
852 
853     /**
854      * @dev Approve or remove `operator` as an operator for the caller.
855      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
856      *
857      * Requirements:
858      *
859      * - The `operator` cannot be the caller.
860      *
861      * Emits an {ApprovalForAll} event.
862      */
863     function setApprovalForAll(address operator, bool _approved) external;
864 
865     /**
866      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
867      *
868      * See {setApprovalForAll}
869      */
870     function isApprovedForAll(address owner, address operator) external view returns (bool);
871 
872     /**
873      * @dev Safely transfers `tokenId` token from `from` to `to`.
874      *
875      * Requirements:
876      *
877      * - `from` cannot be the zero address.
878      * - `to` cannot be the zero address.
879      * - `tokenId` token must exist and be owned by `from`.
880      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function safeTransferFrom(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes calldata data
890     ) external;
891 }
892 
893 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
894 
895 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
896 
897 pragma solidity ^0.8.0;
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Enumerable is IERC721 {
904     /**
905      * @dev Returns the total amount of tokens stored by the contract.
906      */
907     function totalSupply() external view returns (uint256);
908 
909     /**
910      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
911      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
912      */
913     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
914 
915     /**
916      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
917      * Use along with {totalSupply} to enumerate all tokens.
918      */
919     function tokenByIndex(uint256 index) external view returns (uint256);
920 }
921 
922 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
923 
924 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
925 
926 pragma solidity ^0.8.0;
927 
928 /**
929  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
930  * @dev See https://eips.ethereum.org/EIPS/eip-721
931  */
932 interface IERC721Metadata is IERC721 {
933     /**
934      * @dev Returns the token collection name.
935      */
936     function name() external view returns (string memory);
937 
938     /**
939      * @dev Returns the token collection symbol.
940      */
941     function symbol() external view returns (string memory);
942 
943     /**
944      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
945      */
946     function tokenURI(uint256 tokenId) external view returns (string memory);
947 }
948 
949 // File: contracts/NonFrenlyTrolls.sol
950 
951 // Creator: Trolls Labs
952 
953 pragma solidity ^0.8.0;
954 
955 /**
956  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
957  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
958  *
959  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
960  *
961  * Does not support burning tokens to address(0).
962  *
963  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
964  */
965 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
966     using Address for address;
967     using Strings for uint256;
968 
969     struct TokenOwnership {
970         address addr;
971         uint64 startTimestamp;
972     }
973 
974     struct AddressData {
975         uint128 balance;
976         uint128 numberMinted;
977     }
978 
979     uint256 internal currentIndex;
980 
981     // Token name
982     string private _name;
983 
984     // Token symbol
985     string private _symbol;
986 
987     // Mapping from token ID to ownership details
988     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
989     mapping(uint256 => TokenOwnership) internal _ownerships;
990 
991     // Mapping owner address to address data
992     mapping(address => AddressData) private _addressData;
993 
994     // Mapping from token ID to approved address
995     mapping(uint256 => address) private _tokenApprovals;
996 
997     // Mapping from owner to operator approvals
998     mapping(address => mapping(address => bool)) private _operatorApprovals;
999 
1000     constructor(string memory name_, string memory symbol_) {
1001         _name = name_;
1002         _symbol = symbol_;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Enumerable-totalSupply}.
1007      */
1008     function totalSupply() public view override returns (uint256) {
1009         return currentIndex;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Enumerable-tokenByIndex}.
1014      */
1015     function tokenByIndex(uint256 index) public view override returns (uint256) {
1016         require(index < totalSupply(), "ERC721A: global index out of bounds");
1017         return index;
1018     }
1019 
1020     /**
1021      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1022      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1023      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1024      */
1025     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1026         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1027         uint256 numMintedSoFar = totalSupply();
1028         uint256 tokenIdsIdx;
1029         address currOwnershipAddr;
1030 
1031         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1032         unchecked {
1033             for (uint256 i; i < numMintedSoFar; i++) {
1034                 TokenOwnership memory ownership = _ownerships[i];
1035                 if (ownership.addr != address(0)) {
1036                     currOwnershipAddr = ownership.addr;
1037                 }
1038                 if (currOwnershipAddr == owner) {
1039                     if (tokenIdsIdx == index) {
1040                         return i;
1041                     }
1042                     tokenIdsIdx++;
1043                 }
1044             }
1045         }
1046 
1047         revert("ERC721A: unable to get token of owner by index");
1048     }
1049 
1050     /**
1051      * @dev See {IERC165-supportsInterface}.
1052      */
1053     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1054         return
1055             interfaceId == type(IERC721).interfaceId ||
1056             interfaceId == type(IERC721Metadata).interfaceId ||
1057             interfaceId == type(IERC721Enumerable).interfaceId ||
1058             super.supportsInterface(interfaceId);
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-balanceOf}.
1063      */
1064     function balanceOf(address owner) public view override returns (uint256) {
1065         require(owner != address(0), "ERC721A: balance query for the zero address");
1066         return uint256(_addressData[owner].balance);
1067     }
1068 
1069     function _numberMinted(address owner) internal view returns (uint256) {
1070         require(owner != address(0), "ERC721A: number minted query for the zero address");
1071         return uint256(_addressData[owner].numberMinted);
1072     }
1073 
1074     /**
1075      * Gas spent here starts off proportional to the maximum mint batch size.
1076      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1077      */
1078     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1079         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1080 
1081         unchecked {
1082             for (uint256 curr = tokenId; curr >= 0; curr--) {
1083                 TokenOwnership memory ownership = _ownerships[curr];
1084                 if (ownership.addr != address(0)) {
1085                     return ownership;
1086                 }
1087             }
1088         }
1089 
1090         revert("ERC721A: unable to determine the owner of token");
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-ownerOf}.
1095      */
1096     function ownerOf(uint256 tokenId) public view override returns (address) {
1097         return ownershipOf(tokenId).addr;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Metadata-name}.
1102      */
1103     function name() public view virtual override returns (string memory) {
1104         return _name;
1105     }
1106 
1107     /**
1108      * @dev See {IERC721Metadata-symbol}.
1109      */
1110     function symbol() public view virtual override returns (string memory) {
1111         return _symbol;
1112     }
1113 
1114     /**
1115      * @dev See {IERC721Metadata-tokenURI}.
1116      */
1117     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1118         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1119 
1120         string memory baseURI = _baseURI();
1121         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1122     }
1123 
1124     /**
1125      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1126      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1127      * by default, can be overriden in child contracts.
1128      */
1129     function _baseURI() internal view virtual returns (string memory) {
1130         return "";
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-approve}.
1135      */
1136     function approve(address to, uint256 tokenId) public override {
1137         address owner = ERC721A.ownerOf(tokenId);
1138         require(to != owner, "ERC721A: approval to current owner");
1139 
1140         require(
1141             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1142             "ERC721A: approve caller is not owner nor approved for all"
1143         );
1144 
1145         _approve(to, tokenId, owner);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-getApproved}.
1150      */
1151     function getApproved(uint256 tokenId) public view override returns (address) {
1152         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1153 
1154         return _tokenApprovals[tokenId];
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-setApprovalForAll}.
1159      */
1160     function setApprovalForAll(address operator, bool approved) public override {
1161         require(operator != _msgSender(), "ERC721A: approve to caller");
1162 
1163         _operatorApprovals[_msgSender()][operator] = approved;
1164         emit ApprovalForAll(_msgSender(), operator, approved);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-isApprovedForAll}.
1169      */
1170     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1171         return _operatorApprovals[owner][operator];
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-transferFrom}.
1176      */
1177     function transferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId
1181     ) public virtual override {
1182         _transfer(from, to, tokenId);
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-safeTransferFrom}.
1187      */
1188     function safeTransferFrom(
1189         address from,
1190         address to,
1191         uint256 tokenId
1192     ) public virtual override {
1193         safeTransferFrom(from, to, tokenId, "");
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-safeTransferFrom}.
1198      */
1199     function safeTransferFrom(
1200         address from,
1201         address to,
1202         uint256 tokenId,
1203         bytes memory _data
1204     ) public override {
1205         _transfer(from, to, tokenId);
1206         require(
1207             _checkOnERC721Received(from, to, tokenId, _data),
1208             "ERC721A: transfer to non ERC721Receiver implementer"
1209         );
1210     }
1211 
1212     /**
1213      * @dev Returns whether `tokenId` exists.
1214      *
1215      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1216      *
1217      * Tokens start existing when they are minted (`_mint`),
1218      */
1219     function _exists(uint256 tokenId) internal view returns (bool) {
1220         return tokenId < currentIndex;
1221     }
1222 
1223     function _safeMint(address to, uint256 quantity) internal {
1224         _safeMint(to, quantity, "");
1225     }
1226 
1227     /**
1228      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1229      *
1230      * Requirements:
1231      *
1232      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1233      * - `quantity` must be greater than 0.
1234      *
1235      * Emits a {Transfer} event.
1236      */
1237     function _safeMint(
1238         address to,
1239         uint256 quantity,
1240         bytes memory _data
1241     ) internal {
1242         _mint(to, quantity, _data, true);
1243     }
1244 
1245     /**
1246      * @dev Mints `quantity` tokens and transfers them to `to`.
1247      *
1248      * Requirements:
1249      *
1250      * - `to` cannot be the zero address.
1251      * - `quantity` must be greater than 0.
1252      *
1253      * Emits a {Transfer} event.
1254      */
1255     function _mint(
1256         address to,
1257         uint256 quantity,
1258         bytes memory _data,
1259         bool safe
1260     ) internal {
1261         uint256 startTokenId = currentIndex;
1262         require(to != address(0), "ERC721A: mint to the zero address");
1263         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1264 
1265         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1266 
1267         // Overflows are incredibly unrealistic.
1268         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1269         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1270         unchecked {
1271             _addressData[to].balance += uint128(quantity);
1272             _addressData[to].numberMinted += uint128(quantity);
1273 
1274             _ownerships[startTokenId].addr = to;
1275             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1276 
1277             uint256 updatedIndex = startTokenId;
1278 
1279             for (uint256 i; i < quantity; i++) {
1280                 emit Transfer(address(0), to, updatedIndex);
1281                 if (safe) {
1282                     require(
1283                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1284                         "ERC721A: transfer to non ERC721Receiver implementer"
1285                     );
1286                 }
1287 
1288                 updatedIndex++;
1289             }
1290 
1291             currentIndex = updatedIndex;
1292         }
1293 
1294         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1295     }
1296 
1297     /**
1298      * @dev Transfers `tokenId` from `from` to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `tokenId` token must be owned by `from`.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _transfer(
1308         address from,
1309         address to,
1310         uint256 tokenId
1311     ) private {
1312         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1313 
1314         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1315             getApproved(tokenId) == _msgSender() ||
1316             isApprovedForAll(prevOwnership.addr, _msgSender()));
1317 
1318         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1319 
1320         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1321         require(to != address(0), "ERC721A: transfer to the zero address");
1322 
1323         _beforeTokenTransfers(from, to, tokenId, 1);
1324 
1325         // Clear approvals from the previous owner
1326         _approve(address(0), tokenId, prevOwnership.addr);
1327 
1328         // Underflow of the sender's balance is impossible because we check for
1329         // ownership above and the recipient's balance can't realistically overflow.
1330         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1331         unchecked {
1332             _addressData[from].balance -= 1;
1333             _addressData[to].balance += 1;
1334 
1335             _ownerships[tokenId].addr = to;
1336             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1337 
1338             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1339             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1340             uint256 nextTokenId = tokenId + 1;
1341             if (_ownerships[nextTokenId].addr == address(0)) {
1342                 if (_exists(nextTokenId)) {
1343                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1344                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1345                 }
1346             }
1347         }
1348 
1349         emit Transfer(from, to, tokenId);
1350         _afterTokenTransfers(from, to, tokenId, 1);
1351     }
1352 
1353     /**
1354      * @dev Approve `to` to operate on `tokenId`
1355      *
1356      * Emits a {Approval} event.
1357      */
1358     function _approve(
1359         address to,
1360         uint256 tokenId,
1361         address owner
1362     ) private {
1363         _tokenApprovals[tokenId] = to;
1364         emit Approval(owner, to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1369      * The call is not executed if the target address is not a contract.
1370      *
1371      * @param from address representing the previous owner of the given token ID
1372      * @param to target address that will receive the tokens
1373      * @param tokenId uint256 ID of the token to be transferred
1374      * @param _data bytes optional data to send along with the call
1375      * @return bool whether the call correctly returned the expected magic value
1376      */
1377     function _checkOnERC721Received(
1378         address from,
1379         address to,
1380         uint256 tokenId,
1381         bytes memory _data
1382     ) private returns (bool) {
1383         if (to.isContract()) {
1384             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1385                 return retval == IERC721Receiver(to).onERC721Received.selector;
1386             } catch (bytes memory reason) {
1387                 if (reason.length == 0) {
1388                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1389                 } else {
1390                     assembly {
1391                         revert(add(32, reason), mload(reason))
1392                     }
1393                 }
1394             }
1395         } else {
1396             return true;
1397         }
1398     }
1399 
1400     /**
1401      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1402      *
1403      * startTokenId - the first token id to be transferred
1404      * quantity - the amount to be transferred
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` will be minted for `to`.
1411      */
1412     function _beforeTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 
1419     /**
1420      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1421      * minting.
1422      *
1423      * startTokenId - the first token id to be transferred
1424      * quantity - the amount to be transferred
1425      *
1426      * Calling conditions:
1427      *
1428      * - when `from` and `to` are both non-zero.
1429      * - `from` and `to` are never both zero.
1430      */
1431     function _afterTokenTransfers(
1432         address from,
1433         address to,
1434         uint256 startTokenId,
1435         uint256 quantity
1436     ) internal virtual {}
1437 }
1438 
1439 contract NonFrenlyTrolls is ERC721A, Ownable, ReentrancyGuard {
1440 
1441     string public        hiddenURI;
1442     string public        baseURI;
1443     uint public          price             = 0.000 ether;
1444     uint public          maxPerTx          = 5;
1445     uint public          maxPerWallet      = 5;
1446     uint public          totalFree         = 10000;
1447     uint public          maxSupply         = 10000;
1448     uint public          nextOwnerToExplicitlySet;
1449     bool public          mintEnabled;
1450     bool public          revealed;
1451 
1452     constructor() ERC721A("Non Frenly Trolls", "TROLL"){}
1453 
1454     function trolling(uint256 numberOfTokens) external payable {
1455         uint cost = price;
1456         if(totalSupply() + numberOfTokens < totalFree + 1) {
1457             cost = 0;
1458         }
1459         require(msg.sender == tx.origin, "who you tryna troll?");
1460         require(msg.value == numberOfTokens * cost, "don't be cheap!");
1461         require(totalSupply() + numberOfTokens < maxSupply + 1, "we're sold out!");
1462         require(mintEnabled, "come back tomorrow");
1463         require(numberMinted(msg.sender) + numberOfTokens <= maxPerWallet, "too many per wallet");
1464         require(numberOfTokens < maxPerTx + 1, "too many per tx");
1465 
1466         _safeMint(msg.sender, numberOfTokens);
1467     }
1468 
1469     function superTrolling(address to, uint256 numberOfTokens) external onlyOwner {
1470         require(totalSupply() + numberOfTokens < maxSupply + 1, "we're sold out!");
1471 
1472         _safeMint(to, numberOfTokens);
1473     }
1474 
1475     function toggleMinting() external onlyOwner {
1476         mintEnabled = !mintEnabled;
1477     }
1478 
1479     function toggleRevealed() external onlyOwner {
1480         revealed = !revealed;
1481     }
1482 
1483     function numberMinted(address owner) public view returns (uint256) {
1484         return _numberMinted(owner);
1485     }
1486 
1487     function setHiddenURI(string calldata hiddenURI_) external onlyOwner {
1488         hiddenURI = hiddenURI_;
1489     }
1490 
1491     function setBaseURI(string calldata baseURI_) external onlyOwner {
1492         baseURI = baseURI_;
1493     }
1494 
1495     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1496         require(_exists(tokenId), "troll does not exist");
1497 
1498         if (revealed) {
1499             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
1500         }
1501         return hiddenURI;
1502     }
1503 
1504     function setPrice(uint256 price_) external onlyOwner {
1505         price = price_;
1506     }
1507 
1508     function setTotalFree(uint256 totalFree_) external onlyOwner {
1509         totalFree = totalFree_;
1510     }
1511 
1512     function setMaxPerTx(uint256 maxPerTx_) external onlyOwner {
1513         maxPerTx = maxPerTx_;
1514     }
1515 
1516     function setMaxPerWallet(uint256 maxPerWallet_) external onlyOwner {
1517         maxPerWallet = maxPerWallet_;
1518     }
1519 
1520     function setmaxSupply(uint256 maxSupply_) external onlyOwner {
1521         maxSupply = maxSupply_;
1522     }
1523 
1524     function _baseURI() internal view virtual override returns (string memory) {
1525         return baseURI;
1526     }
1527 
1528     function withdraw() external onlyOwner nonReentrant {
1529         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1530         require(success, "Transfer failed.");
1531     }
1532 
1533     function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1534         _setOwnersExplicit(quantity);
1535     }
1536 
1537     function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1538         return ownershipOf(tokenId);
1539     }
1540 
1541     /**
1542      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1543      */
1544     function _setOwnersExplicit(uint256 quantity) internal {
1545         require(quantity != 0, "quantity must be nonzero");
1546         require(currentIndex != 0, "no tokens minted yet");
1547         uint256 _nextOwnerToExplicitlySet = nextOwnerToExplicitlySet;
1548         require(_nextOwnerToExplicitlySet < currentIndex, "all ownerships have been set");
1549 
1550         // Index underflow is impossible.
1551         // Counter or index overflow is incredibly unrealistic.
1552         unchecked {
1553             uint256 endIndex = _nextOwnerToExplicitlySet + quantity - 1;
1554 
1555             // Set the end index to be the last token index
1556             if (endIndex + 1 > currentIndex) {
1557                 endIndex = currentIndex - 1;
1558             }
1559 
1560             for (uint256 i = _nextOwnerToExplicitlySet; i <= endIndex; i++) {
1561                 if (_ownerships[i].addr == address(0)) {
1562                     TokenOwnership memory ownership = ownershipOf(i);
1563                     _ownerships[i].addr = ownership.addr;
1564                     _ownerships[i].startTimestamp = ownership.startTimestamp;
1565                 }
1566             }
1567 
1568             nextOwnerToExplicitlySet = endIndex + 1;
1569         }
1570     }
1571 }