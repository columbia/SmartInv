1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `recipient`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Returns the remaining number of tokens that `spender` will be
99      * allowed to spend on behalf of `owner` through {transferFrom}. This is
100      * zero by default.
101      *
102      * This value changes when {approve} or {transferFrom} are called.
103      */
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     /**
107      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * IMPORTANT: Beware that changing an allowance with this method brings the risk
112      * that someone may use both the old and the new allowance by unfortunate
113      * transaction ordering. One possible solution to mitigate this race
114      * condition is to first reduce the spender's allowance to 0 and set the
115      * desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `sender` to `recipient` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address sender,
133         address recipient,
134         uint256 amount
135     ) external returns (bool);
136 
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to {approve}. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 // File: @openzeppelin/contracts/utils/Strings.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev String operations.
161  */
162 library Strings {
163     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
167      */
168     function toString(uint256 value) internal pure returns (string memory) {
169         // Inspired by OraclizeAPI's implementation - MIT licence
170         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
171 
172         if (value == 0) {
173             return "0";
174         }
175         uint256 temp = value;
176         uint256 digits;
177         while (temp != 0) {
178             digits++;
179             temp /= 10;
180         }
181         bytes memory buffer = new bytes(digits);
182         while (value != 0) {
183             digits -= 1;
184             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
185             value /= 10;
186         }
187         return string(buffer);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
192      */
193     function toHexString(uint256 value) internal pure returns (string memory) {
194         if (value == 0) {
195             return "0x00";
196         }
197         uint256 temp = value;
198         uint256 length = 0;
199         while (temp != 0) {
200             length++;
201             temp >>= 8;
202         }
203         return toHexString(value, length);
204     }
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
208      */
209     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
210         bytes memory buffer = new bytes(2 * length + 2);
211         buffer[0] = "0";
212         buffer[1] = "x";
213         for (uint256 i = 2 * length + 1; i > 1; --i) {
214             buffer[i] = _HEX_SYMBOLS[value & 0xf];
215             value >>= 4;
216         }
217         require(value == 0, "Strings: hex length insufficient");
218         return string(buffer);
219     }
220 }
221 
222 // File: @openzeppelin/contracts/utils/Context.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Provides information about the current execution context, including the
231  * sender of the transaction and its data. While these are generally available
232  * via msg.sender and msg.data, they should not be accessed in such a direct
233  * manner, since when dealing with meta-transactions the account sending and
234  * paying for execution may not be the actual sender (as far as an application
235  * is concerned).
236  *
237  * This contract is only required for intermediate, library-like contracts.
238  */
239 abstract contract Context {
240     function _msgSender() internal view virtual returns (address) {
241         return msg.sender;
242     }
243 
244     function _msgData() internal view virtual returns (bytes calldata) {
245         return msg.data;
246     }
247 }
248 
249 // File: @openzeppelin/contracts/access/Ownable.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 
257 /**
258  * @dev Contract module which provides a basic access control mechanism, where
259  * there is an account (an owner) that can be granted exclusive access to
260  * specific functions.
261  *
262  * By default, the owner account will be the one that deploys the contract. This
263  * can later be changed with {transferOwnership}.
264  *
265  * This module is used through inheritance. It will make available the modifier
266  * `onlyOwner`, which can be applied to your functions to restrict their use to
267  * the owner.
268  */
269 abstract contract Ownable is Context {
270     address private _owner;
271 
272     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
273 
274     /**
275      * @dev Initializes the contract setting the deployer as the initial owner.
276      */
277     constructor() {
278         _transferOwnership(_msgSender());
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view virtual returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(owner() == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         _transferOwnership(address(0));
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Can only be called by the current owner.
310      */
311     function transferOwnership(address newOwner) public virtual onlyOwner {
312         require(newOwner != address(0), "Ownable: new owner is the zero address");
313         _transferOwnership(newOwner);
314     }
315 
316     /**
317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
318      * Internal function without access restriction.
319      */
320     function _transferOwnership(address newOwner) internal virtual {
321         address oldOwner = _owner;
322         _owner = newOwner;
323         emit OwnershipTransferred(oldOwner, newOwner);
324     }
325 }
326 
327 // File: @openzeppelin/contracts/utils/Address.sol
328 
329 
330 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
331 
332 pragma solidity ^0.8.0;
333 
334 /**
335  * @dev Collection of functions related to the address type
336  */
337 library Address {
338     /**
339      * @dev Returns true if `account` is a contract.
340      *
341      * [IMPORTANT]
342      * ====
343      * It is unsafe to assume that an address for which this function returns
344      * false is an externally-owned account (EOA) and not a contract.
345      *
346      * Among others, `isContract` will return false for the following
347      * types of addresses:
348      *
349      *  - an externally-owned account
350      *  - a contract in construction
351      *  - an address where a contract will be created
352      *  - an address where a contract lived, but was destroyed
353      * ====
354      */
355     function isContract(address account) internal view returns (bool) {
356         // This method relies on extcodesize, which returns 0 for contracts in
357         // construction, since the code is only stored at the end of the
358         // constructor execution.
359 
360         uint256 size;
361         assembly {
362             size := extcodesize(account)
363         }
364         return size > 0;
365     }
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386         (bool success, ) = recipient.call{value: amount}("");
387         require(success, "Address: unable to send value, recipient may have reverted");
388     }
389 
390     /**
391      * @dev Performs a Solidity function call using a low level `call`. A
392      * plain `call` is an unsafe replacement for a function call: use this
393      * function instead.
394      *
395      * If `target` reverts with a revert reason, it is bubbled up by this
396      * function (like regular Solidity function calls).
397      *
398      * Returns the raw returned data. To convert to the expected return value,
399      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
400      *
401      * Requirements:
402      *
403      * - `target` must be a contract.
404      * - calling `target` with `data` must not revert.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
409         return functionCall(target, data, "Address: low-level call failed");
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
414      * `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(
419         address target,
420         bytes memory data,
421         string memory errorMessage
422     ) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 value
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
447      * with `errorMessage` as a fallback revert reason when `target` reverts.
448      *
449      * _Available since v3.1._
450      */
451     function functionCallWithValue(
452         address target,
453         bytes memory data,
454         uint256 value,
455         string memory errorMessage
456     ) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         require(isContract(target), "Address: call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.call{value: value}(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a static call.
467      *
468      * _Available since v3.3._
469      */
470     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
471         return functionStaticCall(target, data, "Address: low-level static call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a static call.
477      *
478      * _Available since v3.3._
479      */
480     function functionStaticCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal view returns (bytes memory) {
485         require(isContract(target), "Address: static call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.staticcall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
498         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(
508         address target,
509         bytes memory data,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         require(isContract(target), "Address: delegate call to non-contract");
513 
514         (bool success, bytes memory returndata) = target.delegatecall(data);
515         return verifyCallResult(success, returndata, errorMessage);
516     }
517 
518     /**
519      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
520      * revert reason using the provided one.
521      *
522      * _Available since v4.3._
523      */
524     function verifyCallResult(
525         bool success,
526         bytes memory returndata,
527         string memory errorMessage
528     ) internal pure returns (bytes memory) {
529         if (success) {
530             return returndata;
531         } else {
532             // Look for revert reason and bubble it up if present
533             if (returndata.length > 0) {
534                 // The easiest way to bubble the revert reason is using memory via assembly
535 
536                 assembly {
537                     let returndata_size := mload(returndata)
538                     revert(add(32, returndata), returndata_size)
539                 }
540             } else {
541                 revert(errorMessage);
542             }
543         }
544     }
545 }
546 
547 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.0 (token/ERC20/utils/SafeERC20.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 
556 /**
557  * @title SafeERC20
558  * @dev Wrappers around ERC20 operations that throw on failure (when the token
559  * contract returns false). Tokens that return no value (and instead revert or
560  * throw on failure) are also supported, non-reverting calls are assumed to be
561  * successful.
562  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
563  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
564  */
565 library SafeERC20 {
566     using Address for address;
567 
568     function safeTransfer(
569         IERC20 token,
570         address to,
571         uint256 value
572     ) internal {
573         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
574     }
575 
576     function safeTransferFrom(
577         IERC20 token,
578         address from,
579         address to,
580         uint256 value
581     ) internal {
582         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
583     }
584 
585     /**
586      * @dev Deprecated. This function has issues similar to the ones found in
587      * {IERC20-approve}, and its usage is discouraged.
588      *
589      * Whenever possible, use {safeIncreaseAllowance} and
590      * {safeDecreaseAllowance} instead.
591      */
592     function safeApprove(
593         IERC20 token,
594         address spender,
595         uint256 value
596     ) internal {
597         // safeApprove should only be called when setting an initial allowance,
598         // or when resetting it to zero. To increase and decrease it, use
599         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
600         require(
601             (value == 0) || (token.allowance(address(this), spender) == 0),
602             "SafeERC20: approve from non-zero to non-zero allowance"
603         );
604         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
605     }
606 
607     function safeIncreaseAllowance(
608         IERC20 token,
609         address spender,
610         uint256 value
611     ) internal {
612         uint256 newAllowance = token.allowance(address(this), spender) + value;
613         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
614     }
615 
616     function safeDecreaseAllowance(
617         IERC20 token,
618         address spender,
619         uint256 value
620     ) internal {
621         unchecked {
622             uint256 oldAllowance = token.allowance(address(this), spender);
623             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
624             uint256 newAllowance = oldAllowance - value;
625             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
626         }
627     }
628 
629     /**
630      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
631      * on the return value: the return value is optional (but if data is returned, it must not be false).
632      * @param token The token targeted by the call.
633      * @param data The call data (encoded using abi.encode or one of its variants).
634      */
635     function _callOptionalReturn(IERC20 token, bytes memory data) private {
636         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
637         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
638         // the target address contains contract code and also asserts for success in the low-level call.
639 
640         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
641         if (returndata.length > 0) {
642             // Return data is optional
643             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
644         }
645     }
646 }
647 
648 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.0 (finance/PaymentSplitter.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 
657 
658 /**
659  * @title PaymentSplitter
660  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
661  * that the Ether will be split in this way, since it is handled transparently by the contract.
662  *
663  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
664  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
665  * an amount proportional to the percentage of total shares they were assigned.
666  *
667  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
668  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
669  * function.
670  *
671  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
672  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
673  * to run tests before sending real value to this contract.
674  */
675 contract PaymentSplitter is Context {
676     event PayeeAdded(address account, uint256 shares);
677     event PaymentReleased(address to, uint256 amount);
678     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
679     event PaymentReceived(address from, uint256 amount);
680 
681     uint256 private _totalShares;
682     uint256 private _totalReleased;
683 
684     mapping(address => uint256) private _shares;
685     mapping(address => uint256) private _released;
686     address[] private _payees;
687 
688     mapping(IERC20 => uint256) private _erc20TotalReleased;
689     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
690 
691     /**
692      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
693      * the matching position in the `shares` array.
694      *
695      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
696      * duplicates in `payees`.
697      */
698     constructor(address[] memory payees, uint256[] memory shares_) payable {
699         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
700         require(payees.length > 0, "PaymentSplitter: no payees");
701 
702         for (uint256 i = 0; i < payees.length; i++) {
703             _addPayee(payees[i], shares_[i]);
704         }
705     }
706 
707     /**
708      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
709      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
710      * reliability of the events, and not the actual splitting of Ether.
711      *
712      * To learn more about this see the Solidity documentation for
713      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
714      * functions].
715      */
716     receive() external payable virtual {
717         emit PaymentReceived(_msgSender(), msg.value);
718     }
719 
720     /**
721      * @dev Getter for the total shares held by payees.
722      */
723     function totalShares() public view returns (uint256) {
724         return _totalShares;
725     }
726 
727     /**
728      * @dev Getter for the total amount of Ether already released.
729      */
730     function totalReleased() public view returns (uint256) {
731         return _totalReleased;
732     }
733 
734     /**
735      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
736      * contract.
737      */
738     function totalReleased(IERC20 token) public view returns (uint256) {
739         return _erc20TotalReleased[token];
740     }
741 
742     /**
743      * @dev Getter for the amount of shares held by an account.
744      */
745     function shares(address account) public view returns (uint256) {
746         return _shares[account];
747     }
748 
749     /**
750      * @dev Getter for the amount of Ether already released to a payee.
751      */
752     function released(address account) public view returns (uint256) {
753         return _released[account];
754     }
755 
756     /**
757      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
758      * IERC20 contract.
759      */
760     function released(IERC20 token, address account) public view returns (uint256) {
761         return _erc20Released[token][account];
762     }
763 
764     /**
765      * @dev Getter for the address of the payee number `index`.
766      */
767     function payee(uint256 index) public view returns (address) {
768         return _payees[index];
769     }
770 
771     /**
772      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
773      * total shares and their previous withdrawals.
774      */
775     function release(address payable account) public virtual {
776         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
777 
778         uint256 totalReceived = address(this).balance + totalReleased();
779         uint256 payment = _pendingPayment(account, totalReceived, released(account));
780 
781         require(payment != 0, "PaymentSplitter: account is not due payment");
782 
783         _released[account] += payment;
784         _totalReleased += payment;
785 
786         Address.sendValue(account, payment);
787         emit PaymentReleased(account, payment);
788     }
789 
790     /**
791      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
792      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
793      * contract.
794      */
795     function release(IERC20 token, address account) public virtual {
796         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
797 
798         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
799         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
800 
801         require(payment != 0, "PaymentSplitter: account is not due payment");
802 
803         _erc20Released[token][account] += payment;
804         _erc20TotalReleased[token] += payment;
805 
806         SafeERC20.safeTransfer(token, account, payment);
807         emit ERC20PaymentReleased(token, account, payment);
808     }
809 
810     /**
811      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
812      * already released amounts.
813      */
814     function _pendingPayment(
815         address account,
816         uint256 totalReceived,
817         uint256 alreadyReleased
818     ) private view returns (uint256) {
819         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
820     }
821 
822     /**
823      * @dev Add a new payee to the contract.
824      * @param account The address of the payee to add.
825      * @param shares_ The number of shares owned by the payee.
826      */
827     function _addPayee(address account, uint256 shares_) private {
828         require(account != address(0), "PaymentSplitter: account is the zero address");
829         require(shares_ > 0, "PaymentSplitter: shares are 0");
830         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
831 
832         _payees.push(account);
833         _shares[account] = shares_;
834         _totalShares = _totalShares + shares_;
835         emit PayeeAdded(account, shares_);
836     }
837 }
838 
839 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
840 
841 
842 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 /**
847  * @title ERC721 token receiver interface
848  * @dev Interface for any contract that wants to support safeTransfers
849  * from ERC721 asset contracts.
850  */
851 interface IERC721Receiver {
852     /**
853      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
854      * by `operator` from `from`, this function is called.
855      *
856      * It must return its Solidity selector to confirm the token transfer.
857      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
858      *
859      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
860      */
861     function onERC721Received(
862         address operator,
863         address from,
864         uint256 tokenId,
865         bytes calldata data
866     ) external returns (bytes4);
867 }
868 
869 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @dev Interface of the ERC165 standard, as defined in the
878  * https://eips.ethereum.org/EIPS/eip-165[EIP].
879  *
880  * Implementers can declare support of contract interfaces, which can then be
881  * queried by others ({ERC165Checker}).
882  *
883  * For an implementation, see {ERC165}.
884  */
885 interface IERC165 {
886     /**
887      * @dev Returns true if this contract implements the interface defined by
888      * `interfaceId`. See the corresponding
889      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
890      * to learn more about how these ids are created.
891      *
892      * This function call must use less than 30 000 gas.
893      */
894     function supportsInterface(bytes4 interfaceId) external view returns (bool);
895 }
896 
897 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
898 
899 
900 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
901 
902 pragma solidity ^0.8.0;
903 
904 
905 /**
906  * @dev Implementation of the {IERC165} interface.
907  *
908  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
909  * for the additional interface id that will be supported. For example:
910  *
911  * ```solidity
912  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
913  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
914  * }
915  * ```
916  *
917  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
918  */
919 abstract contract ERC165 is IERC165 {
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
924         return interfaceId == type(IERC165).interfaceId;
925     }
926 }
927 
928 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
929 
930 
931 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
932 
933 pragma solidity ^0.8.0;
934 
935 
936 /**
937  * @dev Required interface of an ERC721 compliant contract.
938  */
939 interface IERC721 is IERC165 {
940     /**
941      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
942      */
943     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
944 
945     /**
946      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
947      */
948     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
949 
950     /**
951      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
952      */
953     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
954 
955     /**
956      * @dev Returns the number of tokens in ``owner``'s account.
957      */
958     function balanceOf(address owner) external view returns (uint256 balance);
959 
960     /**
961      * @dev Returns the owner of the `tokenId` token.
962      *
963      * Requirements:
964      *
965      * - `tokenId` must exist.
966      */
967     function ownerOf(uint256 tokenId) external view returns (address owner);
968 
969     /**
970      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
971      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId
987     ) external;
988 
989     /**
990      * @dev Transfers `tokenId` token from `from` to `to`.
991      *
992      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
993      *
994      * Requirements:
995      *
996      * - `from` cannot be the zero address.
997      * - `to` cannot be the zero address.
998      * - `tokenId` token must be owned by `from`.
999      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function transferFrom(
1004         address from,
1005         address to,
1006         uint256 tokenId
1007     ) external;
1008 
1009     /**
1010      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1011      * The approval is cleared when the token is transferred.
1012      *
1013      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1014      *
1015      * Requirements:
1016      *
1017      * - The caller must own the token or be an approved operator.
1018      * - `tokenId` must exist.
1019      *
1020      * Emits an {Approval} event.
1021      */
1022     function approve(address to, uint256 tokenId) external;
1023 
1024     /**
1025      * @dev Returns the account approved for `tokenId` token.
1026      *
1027      * Requirements:
1028      *
1029      * - `tokenId` must exist.
1030      */
1031     function getApproved(uint256 tokenId) external view returns (address operator);
1032 
1033     /**
1034      * @dev Approve or remove `operator` as an operator for the caller.
1035      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1036      *
1037      * Requirements:
1038      *
1039      * - The `operator` cannot be the caller.
1040      *
1041      * Emits an {ApprovalForAll} event.
1042      */
1043     function setApprovalForAll(address operator, bool _approved) external;
1044 
1045     /**
1046      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1047      *
1048      * See {setApprovalForAll}
1049      */
1050     function isApprovedForAll(address owner, address operator) external view returns (bool);
1051 
1052     /**
1053      * @dev Safely transfers `tokenId` token from `from` to `to`.
1054      *
1055      * Requirements:
1056      *
1057      * - `from` cannot be the zero address.
1058      * - `to` cannot be the zero address.
1059      * - `tokenId` token must exist and be owned by `from`.
1060      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1062      *
1063      * Emits a {Transfer} event.
1064      */
1065     function safeTransferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId,
1069         bytes calldata data
1070     ) external;
1071 }
1072 
1073 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1074 
1075 
1076 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1077 
1078 pragma solidity ^0.8.0;
1079 
1080 
1081 /**
1082  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1083  * @dev See https://eips.ethereum.org/EIPS/eip-721
1084  */
1085 interface IERC721Enumerable is IERC721 {
1086     /**
1087      * @dev Returns the total amount of tokens stored by the contract.
1088      */
1089     function totalSupply() external view returns (uint256);
1090 
1091     /**
1092      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1093      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1094      */
1095     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1096 
1097     /**
1098      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1099      * Use along with {totalSupply} to enumerate all tokens.
1100      */
1101     function tokenByIndex(uint256 index) external view returns (uint256);
1102 }
1103 
1104 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1105 
1106 
1107 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1114  * @dev See https://eips.ethereum.org/EIPS/eip-721
1115  */
1116 interface IERC721Metadata is IERC721 {
1117     /**
1118      * @dev Returns the token collection name.
1119      */
1120     function name() external view returns (string memory);
1121 
1122     /**
1123      * @dev Returns the token collection symbol.
1124      */
1125     function symbol() external view returns (string memory);
1126 
1127     /**
1128      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1129      */
1130     function tokenURI(uint256 tokenId) external view returns (string memory);
1131 }
1132 
1133 // File: pagzi/ERC721P.sol
1134 
1135 
1136 pragma solidity ^0.8.10;
1137 
1138 
1139 
1140 
1141 
1142 
1143 
1144 abstract contract ERC721P is Context, ERC165, IERC721, IERC721Metadata {
1145     using Address for address;
1146     string private _name;
1147     string private _symbol;
1148     address[] internal _owners;
1149     mapping(uint256 => address) private _tokenApprovals;
1150     mapping(address => mapping(address => bool)) private _operatorApprovals;     
1151     constructor(string memory name_, string memory symbol_) {
1152         _name = name_;
1153         _symbol = symbol_;
1154     }     
1155     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1156         return
1157             interfaceId == type(IERC721).interfaceId ||
1158             interfaceId == type(IERC721Metadata).interfaceId ||
1159             super.supportsInterface(interfaceId);
1160     }
1161     function balanceOf(address owner) public view virtual override returns (uint256) {
1162         require(owner != address(0), "ERC721: balance query for the zero address");
1163         uint count = 0;
1164         uint length = _owners.length;
1165         for( uint i = 0; i < length; ++i ){
1166           if( owner == _owners[i] ){
1167             ++count;
1168           }
1169         }
1170         delete length;
1171         return count;
1172     }
1173     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1174         address owner = _owners[tokenId];
1175         require(owner != address(0), "ERC721: owner query for nonexistent token");
1176         return owner;
1177     }
1178     function name() public view virtual override returns (string memory) {
1179         return _name;
1180     }
1181     function symbol() public view virtual override returns (string memory) {
1182         return _symbol;
1183     }
1184     function approve(address to, uint256 tokenId) public virtual override {
1185         address owner = ERC721P.ownerOf(tokenId);
1186         require(to != owner, "ERC721: approval to current owner");
1187 
1188         require(
1189             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1190             "ERC721: approve caller is not owner nor approved for all"
1191         );
1192 
1193         _approve(to, tokenId);
1194     }
1195     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1196         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1197 
1198         return _tokenApprovals[tokenId];
1199     }
1200     function setApprovalForAll(address operator, bool approved) public virtual override {
1201         require(operator != _msgSender(), "ERC721: approve to caller");
1202 
1203         _operatorApprovals[_msgSender()][operator] = approved;
1204         emit ApprovalForAll(_msgSender(), operator, approved);
1205     }
1206     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1207         return _operatorApprovals[owner][operator];
1208     }
1209     function transferFrom(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) public virtual override {
1214         //solhint-disable-next-line max-line-length
1215         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1216 
1217         _transfer(from, to, tokenId);
1218     }
1219     function safeTransferFrom(
1220         address from,
1221         address to,
1222         uint256 tokenId
1223     ) public virtual override {
1224         safeTransferFrom(from, to, tokenId, "");
1225     }
1226     function safeTransferFrom(
1227         address from,
1228         address to,
1229         uint256 tokenId,
1230         bytes memory _data
1231     ) public virtual override {
1232         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1233         _safeTransfer(from, to, tokenId, _data);
1234     }     
1235     function _safeTransfer(
1236         address from,
1237         address to,
1238         uint256 tokenId,
1239         bytes memory _data
1240     ) internal virtual {
1241         _transfer(from, to, tokenId);
1242         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1243     }
1244 	function _exists(uint256 tokenId) internal view virtual returns (bool) {
1245         return tokenId < _owners.length && _owners[tokenId] != address(0);
1246     }
1247 	function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1248         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1249         address owner = ERC721P.ownerOf(tokenId);
1250         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1251     }
1252 	function _safeMint(address to, uint256 tokenId) internal virtual {
1253         _safeMint(to, tokenId, "");
1254     }
1255 	function _safeMint(
1256         address to,
1257         uint256 tokenId,
1258         bytes memory _data
1259     ) internal virtual {
1260         _mint(to, tokenId);
1261         require(
1262             _checkOnERC721Received(address(0), to, tokenId, _data),
1263             "ERC721: transfer to non ERC721Receiver implementer"
1264         );
1265     }
1266 	function _mint(address to, uint256 tokenId) internal virtual {
1267         require(to != address(0), "ERC721: mint to the zero address");
1268         require(!_exists(tokenId), "ERC721: token already minted");
1269 
1270         _beforeTokenTransfer(address(0), to, tokenId);
1271         _owners.push(to);
1272 
1273         emit Transfer(address(0), to, tokenId);
1274     }
1275 	function _burn(uint256 tokenId) internal virtual {
1276         address owner = ERC721P.ownerOf(tokenId);
1277 
1278         _beforeTokenTransfer(owner, address(0), tokenId);
1279 
1280         // Clear approvals
1281         _approve(address(0), tokenId);
1282         _owners[tokenId] = address(0);
1283 
1284         emit Transfer(owner, address(0), tokenId);
1285     }
1286 	function _transfer(
1287         address from,
1288         address to,
1289         uint256 tokenId
1290     ) internal virtual {
1291         require(ERC721P.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1292         require(to != address(0), "ERC721: transfer to the zero address");
1293 
1294         _beforeTokenTransfer(from, to, tokenId);
1295 
1296         // Clear approvals from the previous owner
1297         _approve(address(0), tokenId);
1298         _owners[tokenId] = to;
1299 
1300         emit Transfer(from, to, tokenId);
1301     }
1302 	function _approve(address to, uint256 tokenId) internal virtual {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(ERC721P.ownerOf(tokenId), to, tokenId);
1305     }
1306 	function _checkOnERC721Received(
1307         address from,
1308         address to,
1309         uint256 tokenId,
1310         bytes memory _data
1311     ) private returns (bool) {
1312         if (to.isContract()) {
1313             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1314                 return retval == IERC721Receiver.onERC721Received.selector;
1315             } catch (bytes memory reason) {
1316                 if (reason.length == 0) {
1317                     revert("ERC721: transfer to non ERC721Receiver implementer");
1318                 } else {
1319                     assembly {
1320                         revert(add(32, reason), mload(reason))
1321                     }
1322                 }
1323             }
1324         } else {
1325             return true;
1326         }
1327     }
1328 	function _beforeTokenTransfer(
1329         address from,
1330         address to,
1331         uint256 tokenId
1332     ) internal virtual {}
1333 }
1334 // File: pagzi/ERC721Enum.sol
1335 
1336 
1337 pragma solidity ^0.8.10;
1338 
1339 
1340 abstract contract ERC721Enum is ERC721P, IERC721Enumerable {
1341     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721P) returns (bool) {
1342         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1343     }
1344     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256 tokenId) {
1345         require(index < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
1346         uint count;
1347         for( uint i; i < _owners.length; ++i ){
1348             if( owner == _owners[i] ){
1349                 if( count == index )
1350                     return i;
1351                 else
1352                     ++count;
1353             }
1354         }
1355         require(false, "ERC721Enum: owner ioob");
1356     }
1357     function tokensOfOwner(address owner) public view returns (uint256[] memory) {
1358         require(0 < ERC721P.balanceOf(owner), "ERC721Enum: owner ioob");
1359         uint256 tokenCount = balanceOf(owner);
1360         uint256[] memory tokenIds = new uint256[](tokenCount);
1361         for (uint256 i = 0; i < tokenCount; i++) {
1362             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1363         }
1364         return tokenIds;
1365     }
1366     function totalSupply() public view virtual override returns (uint256) {
1367         return _owners.length;
1368     }
1369     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1370         require(index < ERC721Enum.totalSupply(), "ERC721Enum: global ioob");
1371         return index;
1372     }
1373 }
1374 // File: Figures.sol
1375 
1376 
1377 // Author: Unknown Figures;
1378 pragma solidity ^0.8.10;
1379 
1380 
1381 
1382 
1383 
1384 
1385 contract UnknownFigures is ERC721Enum, Ownable, PaymentSplitter, ReentrancyGuard {
1386 	using Strings for uint256;
1387 	string public baseURI;
1388 	//sale settings
1389 	uint256 public cost = 0.06 ether;
1390 	uint256 public maxSupply = 5555;
1391 	uint256 public maxMint = 20;
1392 	bool public status = false;
1393 	//presale settings
1394 	uint256 public presaleDate = 1637132400;
1395 	mapping(address => uint256) public presaleWhitelist;
1396 	//share settings
1397 	address[] private addressList = [
1398 	0x8fd413668962F8CbcE60619E95585D118d0EDDF2,
1399 	0x873Da4ff1FDAb40464B5abeD1C906ab1BB47B62c,
1400 	0xf74062e36Fa02C73261F453d35C51EDbC8f9FAB2,
1401 	0x731C300fbecfCAE1A03DEa818FA0bA479dbC9b2c
1402 	];
1403 	uint[] private shareList = [25,25,25,25];
1404 	constructor(
1405 	string memory _name,
1406 	string memory _symbol,
1407 	string memory _initBaseURI
1408 	) ERC721P(_name, _symbol)
1409 	PaymentSplitter( addressList, shareList ){
1410 	setBaseURI(_initBaseURI);
1411 	}
1412 	// internal
1413 	function _baseURI() internal view virtual returns (string memory) {
1414 	return baseURI;
1415 	}
1416 	// public minting
1417 	function mint(uint256 _mintAmount) public payable nonReentrant{
1418 	uint256 s = totalSupply();
1419 	require(status, "Off" );
1420 	require(_mintAmount > 0, "Duh" );
1421 	require(_mintAmount <= maxMint, "Too many" );
1422 	require(s + _mintAmount <= maxSupply, "Sorry" );
1423 	require(msg.value >= cost * _mintAmount);
1424 	for (uint256 i = 0; i < _mintAmount; ++i) {
1425 	_safeMint(msg.sender, s + i, "");
1426 	}
1427 	delete s;
1428 	}
1429 	function mintPresale(uint256 _mintAmount) public payable {
1430 	require(presaleDate <= block.timestamp, "Not yet");
1431 	uint256 s = totalSupply();
1432 	uint256 reserve = presaleWhitelist[msg.sender];
1433 	require(!status, "Off");
1434 	require(reserve > 0, "Low reserve");
1435 	require(_mintAmount <= reserve, "Try less");
1436 	require(s + _mintAmount <= maxSupply, "More than max");
1437 	require(cost * _mintAmount == msg.value, "Wrong amount");
1438 	presaleWhitelist[msg.sender] = reserve - _mintAmount;
1439 	delete reserve;
1440 	for(uint256 i; i < _mintAmount; i++){
1441 	_safeMint(msg.sender, s + i, "");
1442 	}
1443 	delete s;
1444 	}
1445 	// admin minting
1446 	function gift(uint[] calldata quantity, address[] calldata recipient) external onlyOwner{
1447 	require(quantity.length == recipient.length, "Provide quantities and recipients" );
1448 	uint totalQuantity = 0;
1449 	uint256 s = totalSupply();
1450 	for(uint i = 0; i < quantity.length; ++i){
1451 	totalQuantity += quantity[i];
1452 	}
1453 	require( s + totalQuantity <= maxSupply, "Too many" );
1454 	delete totalQuantity;
1455 	for(uint i = 0; i < recipient.length; ++i){
1456 	for(uint j = 0; j < quantity[i]; ++j){
1457 	_safeMint( recipient[i], s++, "" );
1458 	}
1459 	}
1460 	delete s;	
1461 	}
1462 	// admin functionality
1463 	function presaleSet(address[] calldata _addresses, uint256[] calldata _amounts) public onlyOwner {
1464 	for(uint256 i; i < _addresses.length; i++){
1465 	presaleWhitelist[_addresses[i]] = _amounts[i];
1466 	}
1467 	}
1468 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1469 	require(_exists(tokenId), "ERC721Metadata: Nonexistent token");
1470 	string memory currentBaseURI = _baseURI();
1471 	return bytes(currentBaseURI).length > 0	? string(abi.encodePacked(currentBaseURI, tokenId.toString())) : "";
1472 	}
1473 	function setCost(uint256 _newCost) public onlyOwner {
1474 	cost = _newCost;
1475 	}
1476 	function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1477 	maxMint = _newMaxMintAmount;
1478 	}
1479 	function setmaxSupply(uint256 _newMaxSupply) public onlyOwner {
1480 	maxSupply = _newMaxSupply;
1481 	}
1482 	function setBaseURI(string memory _newBaseURI) public onlyOwner {
1483 	baseURI = _newBaseURI;
1484 	}
1485 	function setSaleStatus(bool _status) public onlyOwner {
1486 	status = _status;
1487 	}
1488 	function withdraw() public payable onlyOwner {
1489 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1490 	require(success);
1491 	}
1492 }