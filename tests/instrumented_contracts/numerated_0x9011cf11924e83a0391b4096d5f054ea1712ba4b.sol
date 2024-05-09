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
152 // File: @openzeppelin/contracts/utils/Counters.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @title Counters
161  * @author Matt Condon (@shrugs)
162  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
163  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
164  *
165  * Include with `using Counters for Counters.Counter;`
166  */
167 library Counters {
168     struct Counter {
169         // This variable should never be directly accessed by users of the library: interactions must be restricted to
170         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
171         // this feature: see https://github.com/ethereum/solidity/issues/4637
172         uint256 _value; // default: 0
173     }
174 
175     function current(Counter storage counter) internal view returns (uint256) {
176         return counter._value;
177     }
178 
179     function increment(Counter storage counter) internal {
180         unchecked {
181             counter._value += 1;
182         }
183     }
184 
185     function decrement(Counter storage counter) internal {
186         uint256 value = counter._value;
187         require(value > 0, "Counter: decrement overflow");
188         unchecked {
189             counter._value = value - 1;
190         }
191     }
192 
193     function reset(Counter storage counter) internal {
194         counter._value = 0;
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Strings.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev String operations.
207  */
208 library Strings {
209     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
210 
211     /**
212      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
213      */
214     function toString(uint256 value) internal pure returns (string memory) {
215         // Inspired by OraclizeAPI's implementation - MIT licence
216         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
217 
218         if (value == 0) {
219             return "0";
220         }
221         uint256 temp = value;
222         uint256 digits;
223         while (temp != 0) {
224             digits++;
225             temp /= 10;
226         }
227         bytes memory buffer = new bytes(digits);
228         while (value != 0) {
229             digits -= 1;
230             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
231             value /= 10;
232         }
233         return string(buffer);
234     }
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
238      */
239     function toHexString(uint256 value) internal pure returns (string memory) {
240         if (value == 0) {
241             return "0x00";
242         }
243         uint256 temp = value;
244         uint256 length = 0;
245         while (temp != 0) {
246             length++;
247             temp >>= 8;
248         }
249         return toHexString(value, length);
250     }
251 
252     /**
253      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
254      */
255     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
256         bytes memory buffer = new bytes(2 * length + 2);
257         buffer[0] = "0";
258         buffer[1] = "x";
259         for (uint256 i = 2 * length + 1; i > 1; --i) {
260             buffer[i] = _HEX_SYMBOLS[value & 0xf];
261             value >>= 4;
262         }
263         require(value == 0, "Strings: hex length insufficient");
264         return string(buffer);
265     }
266 }
267 
268 // File: @openzeppelin/contracts/utils/Context.sol
269 
270 
271 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Provides information about the current execution context, including the
277  * sender of the transaction and its data. While these are generally available
278  * via msg.sender and msg.data, they should not be accessed in such a direct
279  * manner, since when dealing with meta-transactions the account sending and
280  * paying for execution may not be the actual sender (as far as an application
281  * is concerned).
282  *
283  * This contract is only required for intermediate, library-like contracts.
284  */
285 abstract contract Context {
286     function _msgSender() internal view virtual returns (address) {
287         return msg.sender;
288     }
289 
290     function _msgData() internal view virtual returns (bytes calldata) {
291         return msg.data;
292     }
293 }
294 
295 // File: @openzeppelin/contracts/access/Ownable.sol
296 
297 
298 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 
303 /**
304  * @dev Contract module which provides a basic access control mechanism, where
305  * there is an account (an owner) that can be granted exclusive access to
306  * specific functions.
307  *
308  * By default, the owner account will be the one that deploys the contract. This
309  * can later be changed with {transferOwnership}.
310  *
311  * This module is used through inheritance. It will make available the modifier
312  * `onlyOwner`, which can be applied to your functions to restrict their use to
313  * the owner.
314  */
315 abstract contract Ownable is Context {
316     address private _owner;
317 
318     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
319 
320     /**
321      * @dev Initializes the contract setting the deployer as the initial owner.
322      */
323     constructor() {
324         _transferOwnership(_msgSender());
325     }
326 
327     /**
328      * @dev Returns the address of the current owner.
329      */
330     function owner() public view virtual returns (address) {
331         return _owner;
332     }
333 
334     /**
335      * @dev Throws if called by any account other than the owner.
336      */
337     modifier onlyOwner() {
338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
339         _;
340     }
341 
342     /**
343      * @dev Leaves the contract without owner. It will not be possible to call
344      * `onlyOwner` functions anymore. Can only be called by the current owner.
345      *
346      * NOTE: Renouncing ownership will leave the contract without an owner,
347      * thereby removing any functionality that is only available to the owner.
348      */
349     function renounceOwnership() public virtual onlyOwner {
350         _transferOwnership(address(0));
351     }
352 
353     /**
354      * @dev Transfers ownership of the contract to a new account (`newOwner`).
355      * Can only be called by the current owner.
356      */
357     function transferOwnership(address newOwner) public virtual onlyOwner {
358         require(newOwner != address(0), "Ownable: new owner is the zero address");
359         _transferOwnership(newOwner);
360     }
361 
362     /**
363      * @dev Transfers ownership of the contract to a new account (`newOwner`).
364      * Internal function without access restriction.
365      */
366     function _transferOwnership(address newOwner) internal virtual {
367         address oldOwner = _owner;
368         _owner = newOwner;
369         emit OwnershipTransferred(oldOwner, newOwner);
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Address.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Collection of functions related to the address type
382  */
383 library Address {
384     /**
385      * @dev Returns true if `account` is a contract.
386      *
387      * [IMPORTANT]
388      * ====
389      * It is unsafe to assume that an address for which this function returns
390      * false is an externally-owned account (EOA) and not a contract.
391      *
392      * Among others, `isContract` will return false for the following
393      * types of addresses:
394      *
395      *  - an externally-owned account
396      *  - a contract in construction
397      *  - an address where a contract will be created
398      *  - an address where a contract lived, but was destroyed
399      * ====
400      */
401     function isContract(address account) internal view returns (bool) {
402         // This method relies on extcodesize, which returns 0 for contracts in
403         // construction, since the code is only stored at the end of the
404         // constructor execution.
405 
406         uint256 size;
407         assembly {
408             size := extcodesize(account)
409         }
410         return size > 0;
411     }
412 
413     /**
414      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
415      * `recipient`, forwarding all available gas and reverting on errors.
416      *
417      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
418      * of certain opcodes, possibly making contracts go over the 2300 gas limit
419      * imposed by `transfer`, making them unable to receive funds via
420      * `transfer`. {sendValue} removes this limitation.
421      *
422      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
423      *
424      * IMPORTANT: because control is transferred to `recipient`, care must be
425      * taken to not create reentrancy vulnerabilities. Consider using
426      * {ReentrancyGuard} or the
427      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
428      */
429     function sendValue(address payable recipient, uint256 amount) internal {
430         require(address(this).balance >= amount, "Address: insufficient balance");
431 
432         (bool success, ) = recipient.call{value: amount}("");
433         require(success, "Address: unable to send value, recipient may have reverted");
434     }
435 
436     /**
437      * @dev Performs a Solidity function call using a low level `call`. A
438      * plain `call` is an unsafe replacement for a function call: use this
439      * function instead.
440      *
441      * If `target` reverts with a revert reason, it is bubbled up by this
442      * function (like regular Solidity function calls).
443      *
444      * Returns the raw returned data. To convert to the expected return value,
445      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
446      *
447      * Requirements:
448      *
449      * - `target` must be a contract.
450      * - calling `target` with `data` must not revert.
451      *
452      * _Available since v3.1._
453      */
454     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionCall(target, data, "Address: low-level call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
460      * `errorMessage` as a fallback revert reason when `target` reverts.
461      *
462      * _Available since v3.1._
463      */
464     function functionCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         return functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(
484         address target,
485         bytes memory data,
486         uint256 value
487     ) internal returns (bytes memory) {
488         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
493      * with `errorMessage` as a fallback revert reason when `target` reverts.
494      *
495      * _Available since v3.1._
496      */
497     function functionCallWithValue(
498         address target,
499         bytes memory data,
500         uint256 value,
501         string memory errorMessage
502     ) internal returns (bytes memory) {
503         require(address(this).balance >= value, "Address: insufficient balance for call");
504         require(isContract(target), "Address: call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.call{value: value}(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a static call.
513      *
514      * _Available since v3.3._
515      */
516     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
517         return functionStaticCall(target, data, "Address: low-level static call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a static call.
523      *
524      * _Available since v3.3._
525      */
526     function functionStaticCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal view returns (bytes memory) {
531         require(isContract(target), "Address: static call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.staticcall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but performing a delegate call.
540      *
541      * _Available since v3.4._
542      */
543     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
544         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(isContract(target), "Address: delegate call to non-contract");
559 
560         (bool success, bytes memory returndata) = target.delegatecall(data);
561         return verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     /**
565      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
566      * revert reason using the provided one.
567      *
568      * _Available since v4.3._
569      */
570     function verifyCallResult(
571         bool success,
572         bytes memory returndata,
573         string memory errorMessage
574     ) internal pure returns (bytes memory) {
575         if (success) {
576             return returndata;
577         } else {
578             // Look for revert reason and bubble it up if present
579             if (returndata.length > 0) {
580                 // The easiest way to bubble the revert reason is using memory via assembly
581 
582                 assembly {
583                     let returndata_size := mload(returndata)
584                     revert(add(32, returndata), returndata_size)
585                 }
586             } else {
587                 revert(errorMessage);
588             }
589         }
590     }
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
594 
595 
596 // OpenZeppelin Contracts v4.4.0 (token/ERC20/utils/SafeERC20.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 
602 /**
603  * @title SafeERC20
604  * @dev Wrappers around ERC20 operations that throw on failure (when the token
605  * contract returns false). Tokens that return no value (and instead revert or
606  * throw on failure) are also supported, non-reverting calls are assumed to be
607  * successful.
608  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
609  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
610  */
611 library SafeERC20 {
612     using Address for address;
613 
614     function safeTransfer(
615         IERC20 token,
616         address to,
617         uint256 value
618     ) internal {
619         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
620     }
621 
622     function safeTransferFrom(
623         IERC20 token,
624         address from,
625         address to,
626         uint256 value
627     ) internal {
628         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
629     }
630 
631     /**
632      * @dev Deprecated. This function has issues similar to the ones found in
633      * {IERC20-approve}, and its usage is discouraged.
634      *
635      * Whenever possible, use {safeIncreaseAllowance} and
636      * {safeDecreaseAllowance} instead.
637      */
638     function safeApprove(
639         IERC20 token,
640         address spender,
641         uint256 value
642     ) internal {
643         // safeApprove should only be called when setting an initial allowance,
644         // or when resetting it to zero. To increase and decrease it, use
645         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
646         require(
647             (value == 0) || (token.allowance(address(this), spender) == 0),
648             "SafeERC20: approve from non-zero to non-zero allowance"
649         );
650         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
651     }
652 
653     function safeIncreaseAllowance(
654         IERC20 token,
655         address spender,
656         uint256 value
657     ) internal {
658         uint256 newAllowance = token.allowance(address(this), spender) + value;
659         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
660     }
661 
662     function safeDecreaseAllowance(
663         IERC20 token,
664         address spender,
665         uint256 value
666     ) internal {
667         unchecked {
668             uint256 oldAllowance = token.allowance(address(this), spender);
669             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
670             uint256 newAllowance = oldAllowance - value;
671             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
672         }
673     }
674 
675     /**
676      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
677      * on the return value: the return value is optional (but if data is returned, it must not be false).
678      * @param token The token targeted by the call.
679      * @param data The call data (encoded using abi.encode or one of its variants).
680      */
681     function _callOptionalReturn(IERC20 token, bytes memory data) private {
682         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
683         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
684         // the target address contains contract code and also asserts for success in the low-level call.
685 
686         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
687         if (returndata.length > 0) {
688             // Return data is optional
689             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
690         }
691     }
692 }
693 
694 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.0 (finance/PaymentSplitter.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 
702 
703 
704 /**
705  * @title PaymentSplitter
706  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
707  * that the Ether will be split in this way, since it is handled transparently by the contract.
708  *
709  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
710  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
711  * an amount proportional to the percentage of total shares they were assigned.
712  *
713  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
714  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
715  * function.
716  *
717  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
718  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
719  * to run tests before sending real value to this contract.
720  */
721 contract PaymentSplitter is Context {
722     event PayeeAdded(address account, uint256 shares);
723     event PaymentReleased(address to, uint256 amount);
724     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
725     event PaymentReceived(address from, uint256 amount);
726 
727     uint256 private _totalShares;
728     uint256 private _totalReleased;
729 
730     mapping(address => uint256) private _shares;
731     mapping(address => uint256) private _released;
732     address[] private _payees;
733 
734     mapping(IERC20 => uint256) private _erc20TotalReleased;
735     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
736 
737     /**
738      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
739      * the matching position in the `shares` array.
740      *
741      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
742      * duplicates in `payees`.
743      */
744     constructor(address[] memory payees, uint256[] memory shares_) payable {
745         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
746         require(payees.length > 0, "PaymentSplitter: no payees");
747 
748         for (uint256 i = 0; i < payees.length; i++) {
749             _addPayee(payees[i], shares_[i]);
750         }
751     }
752 
753     /**
754      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
755      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
756      * reliability of the events, and not the actual splitting of Ether.
757      *
758      * To learn more about this see the Solidity documentation for
759      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
760      * functions].
761      */
762     receive() external payable virtual {
763         emit PaymentReceived(_msgSender(), msg.value);
764     }
765 
766     /**
767      * @dev Getter for the total shares held by payees.
768      */
769     function totalShares() public view returns (uint256) {
770         return _totalShares;
771     }
772 
773     /**
774      * @dev Getter for the total amount of Ether already released.
775      */
776     function totalReleased() public view returns (uint256) {
777         return _totalReleased;
778     }
779 
780     /**
781      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
782      * contract.
783      */
784     function totalReleased(IERC20 token) public view returns (uint256) {
785         return _erc20TotalReleased[token];
786     }
787 
788     /**
789      * @dev Getter for the amount of shares held by an account.
790      */
791     function shares(address account) public view returns (uint256) {
792         return _shares[account];
793     }
794 
795     /**
796      * @dev Getter for the amount of Ether already released to a payee.
797      */
798     function released(address account) public view returns (uint256) {
799         return _released[account];
800     }
801 
802     /**
803      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
804      * IERC20 contract.
805      */
806     function released(IERC20 token, address account) public view returns (uint256) {
807         return _erc20Released[token][account];
808     }
809 
810     /**
811      * @dev Getter for the address of the payee number `index`.
812      */
813     function payee(uint256 index) public view returns (address) {
814         return _payees[index];
815     }
816 
817     /**
818      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
819      * total shares and their previous withdrawals.
820      */
821     function release(address payable account) public virtual {
822         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
823 
824         uint256 totalReceived = address(this).balance + totalReleased();
825         uint256 payment = _pendingPayment(account, totalReceived, released(account));
826 
827         require(payment != 0, "PaymentSplitter: account is not due payment");
828 
829         _released[account] += payment;
830         _totalReleased += payment;
831 
832         Address.sendValue(account, payment);
833         emit PaymentReleased(account, payment);
834     }
835 
836     /**
837      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
838      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
839      * contract.
840      */
841     function release(IERC20 token, address account) public virtual {
842         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
843 
844         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
845         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
846 
847         require(payment != 0, "PaymentSplitter: account is not due payment");
848 
849         _erc20Released[token][account] += payment;
850         _erc20TotalReleased[token] += payment;
851 
852         SafeERC20.safeTransfer(token, account, payment);
853         emit ERC20PaymentReleased(token, account, payment);
854     }
855 
856     /**
857      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
858      * already released amounts.
859      */
860     function _pendingPayment(
861         address account,
862         uint256 totalReceived,
863         uint256 alreadyReleased
864     ) private view returns (uint256) {
865         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
866     }
867 
868     /**
869      * @dev Add a new payee to the contract.
870      * @param account The address of the payee to add.
871      * @param shares_ The number of shares owned by the payee.
872      */
873     function _addPayee(address account, uint256 shares_) private {
874         require(account != address(0), "PaymentSplitter: account is the zero address");
875         require(shares_ > 0, "PaymentSplitter: shares are 0");
876         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
877 
878         _payees.push(account);
879         _shares[account] = shares_;
880         _totalShares = _totalShares + shares_;
881         emit PayeeAdded(account, shares_);
882     }
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
886 
887 
888 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
889 
890 pragma solidity ^0.8.0;
891 
892 /**
893  * @title ERC721 token receiver interface
894  * @dev Interface for any contract that wants to support safeTransfers
895  * from ERC721 asset contracts.
896  */
897 interface IERC721Receiver {
898     /**
899      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
900      * by `operator` from `from`, this function is called.
901      *
902      * It must return its Solidity selector to confirm the token transfer.
903      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
904      *
905      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
906      */
907     function onERC721Received(
908         address operator,
909         address from,
910         uint256 tokenId,
911         bytes calldata data
912     ) external returns (bytes4);
913 }
914 
915 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
916 
917 
918 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
919 
920 pragma solidity ^0.8.0;
921 
922 /**
923  * @dev Interface of the ERC165 standard, as defined in the
924  * https://eips.ethereum.org/EIPS/eip-165[EIP].
925  *
926  * Implementers can declare support of contract interfaces, which can then be
927  * queried by others ({ERC165Checker}).
928  *
929  * For an implementation, see {ERC165}.
930  */
931 interface IERC165 {
932     /**
933      * @dev Returns true if this contract implements the interface defined by
934      * `interfaceId`. See the corresponding
935      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
936      * to learn more about how these ids are created.
937      *
938      * This function call must use less than 30 000 gas.
939      */
940     function supportsInterface(bytes4 interfaceId) external view returns (bool);
941 }
942 
943 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
944 
945 
946 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
947 
948 pragma solidity ^0.8.0;
949 
950 
951 /**
952  * @dev Implementation of the {IERC165} interface.
953  *
954  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
955  * for the additional interface id that will be supported. For example:
956  *
957  * ```solidity
958  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
960  * }
961  * ```
962  *
963  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
964  */
965 abstract contract ERC165 is IERC165 {
966     /**
967      * @dev See {IERC165-supportsInterface}.
968      */
969     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
970         return interfaceId == type(IERC165).interfaceId;
971     }
972 }
973 
974 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
975 
976 
977 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
978 
979 pragma solidity ^0.8.0;
980 
981 
982 /**
983  * @dev Required interface of an ERC721 compliant contract.
984  */
985 interface IERC721 is IERC165 {
986     /**
987      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
988      */
989     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
990 
991     /**
992      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
993      */
994     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
995 
996     /**
997      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
998      */
999     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1000 
1001     /**
1002      * @dev Returns the number of tokens in ``owner``'s account.
1003      */
1004     function balanceOf(address owner) external view returns (uint256 balance);
1005 
1006     /**
1007      * @dev Returns the owner of the `tokenId` token.
1008      *
1009      * Requirements:
1010      *
1011      * - `tokenId` must exist.
1012      */
1013     function ownerOf(uint256 tokenId) external view returns (address owner);
1014 
1015     /**
1016      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1017      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1018      *
1019      * Requirements:
1020      *
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must exist and be owned by `from`.
1024      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1025      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) external;
1034 
1035     /**
1036      * @dev Transfers `tokenId` token from `from` to `to`.
1037      *
1038      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1039      *
1040      * Requirements:
1041      *
1042      * - `from` cannot be the zero address.
1043      * - `to` cannot be the zero address.
1044      * - `tokenId` token must be owned by `from`.
1045      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function transferFrom(
1050         address from,
1051         address to,
1052         uint256 tokenId
1053     ) external;
1054 
1055     /**
1056      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1057      * The approval is cleared when the token is transferred.
1058      *
1059      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1060      *
1061      * Requirements:
1062      *
1063      * - The caller must own the token or be an approved operator.
1064      * - `tokenId` must exist.
1065      *
1066      * Emits an {Approval} event.
1067      */
1068     function approve(address to, uint256 tokenId) external;
1069 
1070     /**
1071      * @dev Returns the account approved for `tokenId` token.
1072      *
1073      * Requirements:
1074      *
1075      * - `tokenId` must exist.
1076      */
1077     function getApproved(uint256 tokenId) external view returns (address operator);
1078 
1079     /**
1080      * @dev Approve or remove `operator` as an operator for the caller.
1081      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1082      *
1083      * Requirements:
1084      *
1085      * - The `operator` cannot be the caller.
1086      *
1087      * Emits an {ApprovalForAll} event.
1088      */
1089     function setApprovalForAll(address operator, bool _approved) external;
1090 
1091     /**
1092      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1093      *
1094      * See {setApprovalForAll}
1095      */
1096     function isApprovedForAll(address owner, address operator) external view returns (bool);
1097 
1098     /**
1099      * @dev Safely transfers `tokenId` token from `from` to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `from` cannot be the zero address.
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must exist and be owned by `from`.
1106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1107      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function safeTransferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId,
1115         bytes calldata data
1116     ) external;
1117 }
1118 
1119 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1120 
1121 
1122 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1123 
1124 pragma solidity ^0.8.0;
1125 
1126 
1127 /**
1128  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1129  * @dev See https://eips.ethereum.org/EIPS/eip-721
1130  */
1131 interface IERC721Enumerable is IERC721 {
1132     /**
1133      * @dev Returns the total amount of tokens stored by the contract.
1134      */
1135     function totalSupply() external view returns (uint256);
1136 
1137     /**
1138      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1139      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1140      */
1141     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1142 
1143     /**
1144      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1145      * Use along with {totalSupply} to enumerate all tokens.
1146      */
1147     function tokenByIndex(uint256 index) external view returns (uint256);
1148 }
1149 
1150 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1151 
1152 
1153 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 
1158 /**
1159  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1160  * @dev See https://eips.ethereum.org/EIPS/eip-721
1161  */
1162 interface IERC721Metadata is IERC721 {
1163     /**
1164      * @dev Returns the token collection name.
1165      */
1166     function name() external view returns (string memory);
1167 
1168     /**
1169      * @dev Returns the token collection symbol.
1170      */
1171     function symbol() external view returns (string memory);
1172 
1173     /**
1174      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1175      */
1176     function tokenURI(uint256 tokenId) external view returns (string memory);
1177 }
1178 
1179 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1180 
1181 
1182 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
1183 
1184 pragma solidity ^0.8.0;
1185 
1186 
1187 
1188 
1189 
1190 
1191 
1192 
1193 /**
1194  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1195  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1196  * {ERC721Enumerable}.
1197  */
1198 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1199     using Address for address;
1200     using Strings for uint256;
1201 
1202     // Token name
1203     string private _name;
1204 
1205     // Token symbol
1206     string private _symbol;
1207 
1208     // Mapping from token ID to owner address
1209     mapping(uint256 => address) private _owners;
1210 
1211     // Mapping owner address to token count
1212     mapping(address => uint256) private _balances;
1213 
1214     // Mapping from token ID to approved address
1215     mapping(uint256 => address) private _tokenApprovals;
1216 
1217     // Mapping from owner to operator approvals
1218     mapping(address => mapping(address => bool)) private _operatorApprovals;
1219 
1220     /**
1221      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1222      */
1223     constructor(string memory name_, string memory symbol_) {
1224         _name = name_;
1225         _symbol = symbol_;
1226     }
1227 
1228     /**
1229      * @dev See {IERC165-supportsInterface}.
1230      */
1231     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1232         return
1233             interfaceId == type(IERC721).interfaceId ||
1234             interfaceId == type(IERC721Metadata).interfaceId ||
1235             super.supportsInterface(interfaceId);
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-balanceOf}.
1240      */
1241     function balanceOf(address owner) public view virtual override returns (uint256) {
1242         require(owner != address(0), "ERC721: balance query for the zero address");
1243         return _balances[owner];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-ownerOf}.
1248      */
1249     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1250         address owner = _owners[tokenId];
1251         require(owner != address(0), "ERC721: owner query for nonexistent token");
1252         return owner;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-name}.
1257      */
1258     function name() public view virtual override returns (string memory) {
1259         return _name;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-symbol}.
1264      */
1265     function symbol() public view virtual override returns (string memory) {
1266         return _symbol;
1267     }
1268 
1269     /**
1270      * @dev See {IERC721Metadata-tokenURI}.
1271      */
1272     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1273         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1274 
1275         string memory baseURI = _baseURI();
1276         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1277     }
1278 
1279     /**
1280      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1281      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1282      * by default, can be overriden in child contracts.
1283      */
1284     function _baseURI() internal view virtual returns (string memory) {
1285         return "";
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-approve}.
1290      */
1291     function approve(address to, uint256 tokenId) public virtual override {
1292         address owner = ERC721.ownerOf(tokenId);
1293         require(to != owner, "ERC721: approval to current owner");
1294 
1295         require(
1296             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1297             "ERC721: approve caller is not owner nor approved for all"
1298         );
1299 
1300         _approve(to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev See {IERC721-getApproved}.
1305      */
1306     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1307         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1308 
1309         return _tokenApprovals[tokenId];
1310     }
1311 
1312     /**
1313      * @dev See {IERC721-setApprovalForAll}.
1314      */
1315     function setApprovalForAll(address operator, bool approved) public virtual override {
1316         _setApprovalForAll(_msgSender(), operator, approved);
1317     }
1318 
1319     /**
1320      * @dev See {IERC721-isApprovedForAll}.
1321      */
1322     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1323         return _operatorApprovals[owner][operator];
1324     }
1325 
1326     /**
1327      * @dev See {IERC721-transferFrom}.
1328      */
1329     function transferFrom(
1330         address from,
1331         address to,
1332         uint256 tokenId
1333     ) public virtual override {
1334         //solhint-disable-next-line max-line-length
1335         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1336 
1337         _transfer(from, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev See {IERC721-safeTransferFrom}.
1342      */
1343     function safeTransferFrom(
1344         address from,
1345         address to,
1346         uint256 tokenId
1347     ) public virtual override {
1348         safeTransferFrom(from, to, tokenId, "");
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-safeTransferFrom}.
1353      */
1354     function safeTransferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) public virtual override {
1360         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1361         _safeTransfer(from, to, tokenId, _data);
1362     }
1363 
1364     /**
1365      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1366      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1367      *
1368      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1369      *
1370      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1371      * implement alternative mechanisms to perform token transfer, such as signature-based.
1372      *
1373      * Requirements:
1374      *
1375      * - `from` cannot be the zero address.
1376      * - `to` cannot be the zero address.
1377      * - `tokenId` token must exist and be owned by `from`.
1378      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _safeTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId,
1386         bytes memory _data
1387     ) internal virtual {
1388         _transfer(from, to, tokenId);
1389         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1390     }
1391 
1392     /**
1393      * @dev Returns whether `tokenId` exists.
1394      *
1395      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1396      *
1397      * Tokens start existing when they are minted (`_mint`),
1398      * and stop existing when they are burned (`_burn`).
1399      */
1400     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1401         return _owners[tokenId] != address(0);
1402     }
1403 
1404     /**
1405      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      */
1411     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1412         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1413         address owner = ERC721.ownerOf(tokenId);
1414         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1415     }
1416 
1417     /**
1418      * @dev Safely mints `tokenId` and transfers it to `to`.
1419      *
1420      * Requirements:
1421      *
1422      * - `tokenId` must not exist.
1423      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1424      *
1425      * Emits a {Transfer} event.
1426      */
1427     function _safeMint(address to, uint256 tokenId) internal virtual {
1428         _safeMint(to, tokenId, "");
1429     }
1430 
1431     /**
1432      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1433      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1434      */
1435     function _safeMint(
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) internal virtual {
1440         _mint(to, tokenId);
1441         require(
1442             _checkOnERC721Received(address(0), to, tokenId, _data),
1443             "ERC721: transfer to non ERC721Receiver implementer"
1444         );
1445     }
1446 
1447     /**
1448      * @dev Mints `tokenId` and transfers it to `to`.
1449      *
1450      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1451      *
1452      * Requirements:
1453      *
1454      * - `tokenId` must not exist.
1455      * - `to` cannot be the zero address.
1456      *
1457      * Emits a {Transfer} event.
1458      */
1459     function _mint(address to, uint256 tokenId) internal virtual {
1460         require(to != address(0), "ERC721: mint to the zero address");
1461         require(!_exists(tokenId), "ERC721: token already minted");
1462 
1463         _beforeTokenTransfer(address(0), to, tokenId);
1464 
1465         _balances[to] += 1;
1466         _owners[tokenId] = to;
1467 
1468         emit Transfer(address(0), to, tokenId);
1469     }
1470 
1471     /**
1472      * @dev Destroys `tokenId`.
1473      * The approval is cleared when the token is burned.
1474      *
1475      * Requirements:
1476      *
1477      * - `tokenId` must exist.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function _burn(uint256 tokenId) internal virtual {
1482         address owner = ERC721.ownerOf(tokenId);
1483 
1484         _beforeTokenTransfer(owner, address(0), tokenId);
1485 
1486         // Clear approvals
1487         _approve(address(0), tokenId);
1488 
1489         _balances[owner] -= 1;
1490         delete _owners[tokenId];
1491 
1492         emit Transfer(owner, address(0), tokenId);
1493     }
1494 
1495     /**
1496      * @dev Transfers `tokenId` from `from` to `to`.
1497      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1498      *
1499      * Requirements:
1500      *
1501      * - `to` cannot be the zero address.
1502      * - `tokenId` token must be owned by `from`.
1503      *
1504      * Emits a {Transfer} event.
1505      */
1506     function _transfer(
1507         address from,
1508         address to,
1509         uint256 tokenId
1510     ) internal virtual {
1511         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1512         require(to != address(0), "ERC721: transfer to the zero address");
1513 
1514         _beforeTokenTransfer(from, to, tokenId);
1515 
1516         // Clear approvals from the previous owner
1517         _approve(address(0), tokenId);
1518 
1519         _balances[from] -= 1;
1520         _balances[to] += 1;
1521         _owners[tokenId] = to;
1522 
1523         emit Transfer(from, to, tokenId);
1524     }
1525 
1526     /**
1527      * @dev Approve `to` to operate on `tokenId`
1528      *
1529      * Emits a {Approval} event.
1530      */
1531     function _approve(address to, uint256 tokenId) internal virtual {
1532         _tokenApprovals[tokenId] = to;
1533         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev Approve `operator` to operate on all of `owner` tokens
1538      *
1539      * Emits a {ApprovalForAll} event.
1540      */
1541     function _setApprovalForAll(
1542         address owner,
1543         address operator,
1544         bool approved
1545     ) internal virtual {
1546         require(owner != operator, "ERC721: approve to caller");
1547         _operatorApprovals[owner][operator] = approved;
1548         emit ApprovalForAll(owner, operator, approved);
1549     }
1550 
1551     /**
1552      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1553      * The call is not executed if the target address is not a contract.
1554      *
1555      * @param from address representing the previous owner of the given token ID
1556      * @param to target address that will receive the tokens
1557      * @param tokenId uint256 ID of the token to be transferred
1558      * @param _data bytes optional data to send along with the call
1559      * @return bool whether the call correctly returned the expected magic value
1560      */
1561     function _checkOnERC721Received(
1562         address from,
1563         address to,
1564         uint256 tokenId,
1565         bytes memory _data
1566     ) private returns (bool) {
1567         if (to.isContract()) {
1568             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1569                 return retval == IERC721Receiver.onERC721Received.selector;
1570             } catch (bytes memory reason) {
1571                 if (reason.length == 0) {
1572                     revert("ERC721: transfer to non ERC721Receiver implementer");
1573                 } else {
1574                     assembly {
1575                         revert(add(32, reason), mload(reason))
1576                     }
1577                 }
1578             }
1579         } else {
1580             return true;
1581         }
1582     }
1583 
1584     /**
1585      * @dev Hook that is called before any token transfer. This includes minting
1586      * and burning.
1587      *
1588      * Calling conditions:
1589      *
1590      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1591      * transferred to `to`.
1592      * - When `from` is zero, `tokenId` will be minted for `to`.
1593      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1594      * - `from` and `to` are never both zero.
1595      *
1596      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1597      */
1598     function _beforeTokenTransfer(
1599         address from,
1600         address to,
1601         uint256 tokenId
1602     ) internal virtual {}
1603 }
1604 
1605 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1606 
1607 
1608 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1609 
1610 pragma solidity ^0.8.0;
1611 
1612 
1613 
1614 /**
1615  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1616  * enumerability of all the token ids in the contract as well as all token ids owned by each
1617  * account.
1618  */
1619 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1620     // Mapping from owner to list of owned token IDs
1621     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1622 
1623     // Mapping from token ID to index of the owner tokens list
1624     mapping(uint256 => uint256) private _ownedTokensIndex;
1625 
1626     // Array with all token ids, used for enumeration
1627     uint256[] private _allTokens;
1628 
1629     // Mapping from token id to position in the allTokens array
1630     mapping(uint256 => uint256) private _allTokensIndex;
1631 
1632     /**
1633      * @dev See {IERC165-supportsInterface}.
1634      */
1635     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1636         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1637     }
1638 
1639     /**
1640      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1641      */
1642     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1643         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1644         return _ownedTokens[owner][index];
1645     }
1646 
1647     /**
1648      * @dev See {IERC721Enumerable-totalSupply}.
1649      */
1650     function totalSupply() public view virtual override returns (uint256) {
1651         return _allTokens.length;
1652     }
1653 
1654     /**
1655      * @dev See {IERC721Enumerable-tokenByIndex}.
1656      */
1657     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1658         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1659         return _allTokens[index];
1660     }
1661 
1662     /**
1663      * @dev Hook that is called before any token transfer. This includes minting
1664      * and burning.
1665      *
1666      * Calling conditions:
1667      *
1668      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1669      * transferred to `to`.
1670      * - When `from` is zero, `tokenId` will be minted for `to`.
1671      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1672      * - `from` cannot be the zero address.
1673      * - `to` cannot be the zero address.
1674      *
1675      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1676      */
1677     function _beforeTokenTransfer(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) internal virtual override {
1682         super._beforeTokenTransfer(from, to, tokenId);
1683 
1684         if (from == address(0)) {
1685             _addTokenToAllTokensEnumeration(tokenId);
1686         } else if (from != to) {
1687             _removeTokenFromOwnerEnumeration(from, tokenId);
1688         }
1689         if (to == address(0)) {
1690             _removeTokenFromAllTokensEnumeration(tokenId);
1691         } else if (to != from) {
1692             _addTokenToOwnerEnumeration(to, tokenId);
1693         }
1694     }
1695 
1696     /**
1697      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1698      * @param to address representing the new owner of the given token ID
1699      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1700      */
1701     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1702         uint256 length = ERC721.balanceOf(to);
1703         _ownedTokens[to][length] = tokenId;
1704         _ownedTokensIndex[tokenId] = length;
1705     }
1706 
1707     /**
1708      * @dev Private function to add a token to this extension's token tracking data structures.
1709      * @param tokenId uint256 ID of the token to be added to the tokens list
1710      */
1711     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1712         _allTokensIndex[tokenId] = _allTokens.length;
1713         _allTokens.push(tokenId);
1714     }
1715 
1716     /**
1717      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1718      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1719      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1720      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1721      * @param from address representing the previous owner of the given token ID
1722      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1723      */
1724     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1725         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1726         // then delete the last slot (swap and pop).
1727 
1728         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1729         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1730 
1731         // When the token to delete is the last token, the swap operation is unnecessary
1732         if (tokenIndex != lastTokenIndex) {
1733             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1734 
1735             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1736             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1737         }
1738 
1739         // This also deletes the contents at the last position of the array
1740         delete _ownedTokensIndex[tokenId];
1741         delete _ownedTokens[from][lastTokenIndex];
1742     }
1743 
1744     /**
1745      * @dev Private function to remove a token from this extension's token tracking data structures.
1746      * This has O(1) time complexity, but alters the order of the _allTokens array.
1747      * @param tokenId uint256 ID of the token to be removed from the tokens list
1748      */
1749     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1750         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1751         // then delete the last slot (swap and pop).
1752 
1753         uint256 lastTokenIndex = _allTokens.length - 1;
1754         uint256 tokenIndex = _allTokensIndex[tokenId];
1755 
1756         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1757         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1758         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1759         uint256 lastTokenId = _allTokens[lastTokenIndex];
1760 
1761         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1762         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1763 
1764         // This also deletes the contents at the last position of the array
1765         delete _allTokensIndex[tokenId];
1766         _allTokens.pop();
1767     }
1768 }
1769 
1770 // File: contracts/NFT.sol
1771 
1772 
1773 
1774 pragma solidity ^0.8.4;
1775 
1776 
1777 
1778 
1779 
1780 
1781 contract AncientCatsClub is
1782     ERC721Enumerable,
1783     Ownable,
1784     ReentrancyGuard,
1785     PaymentSplitter
1786 {
1787     using Strings for uint256;
1788     using Counters for Counters.Counter;
1789 
1790     struct PresaleConfig {
1791         uint256 startTime;
1792         uint256 duration;
1793         uint256 maxCount;
1794     }
1795     struct SaleConfig {
1796         uint256 startTime;
1797         uint256 maxCount;
1798     }
1799 
1800     uint256 public maxSupply = 8222;
1801     uint256 public maxSaleSupply = 7999;
1802     uint256 public maxPresaleSupply = 1000;
1803     uint256 public maxGiftSupply = 223;
1804     uint256 public giftCount;
1805     uint256 public presaleCount;
1806     uint256 public totalNFT;
1807     string public baseURI;
1808     string public notRevealedUri;
1809     string public baseExtension = ".json";
1810     bool public isBurnEnabled;
1811     bool public paused = false;
1812     bool public revealed = false;
1813     PresaleConfig public presaleConfig;
1814     SaleConfig public saleConfig;
1815     Counters.Counter private _tokenIds;
1816 
1817     uint256[] private _teamShares = [2501, 1566, 1566, 1566, 150, 150, 2501];
1818     address[] private _team = [
1819         0xC983f037a25D98e85E3094160cf98aE43e22681e,
1820         0x3EA8477588f821408dc791CCD189C6A3a69fbD52,
1821         0xBf9Be42E5a381d95bD38b0a091F194C43DA43e93,
1822         0xe6653e9592967C515030b277606b25D1d5F449b0,
1823         0x039F0812360ebe580aa61a2593C52527Ba638D90,
1824         0x528257067be5638A871daE9314A052caB2953D8b,
1825         0xb918B3d2bfaF0affa9fecFe7e8FC70468a144252
1826     ];
1827 
1828     mapping(address => bool) private _presaleList;
1829     mapping(address => uint256) public _presaleClaimed;
1830     mapping(address => uint256) public _giftClaimed;
1831     mapping(address => uint256) public _saleClaimed;
1832     mapping(address => uint256) public _totalClaimed;
1833 
1834     enum WorkflowStatus {
1835         CheckOnPresale,
1836         Presale,
1837         Sale,
1838         SoldOut
1839     }
1840     WorkflowStatus public workflow;
1841 
1842     event ChangePresaleConfig(
1843         uint256 _startTime,
1844         uint256 _duration,
1845         uint256 _maxCount
1846     );
1847     event ChangeSaleConfig(uint256 _startTime, uint256 _maxCount);
1848     event ChangeIsBurnEnabled(bool _isBurnEnabled);
1849     event ChangeBaseURI(string _baseURI);
1850     event GiftMint(address indexed _recipient, uint256 _amount);
1851     event PresaleMint(address indexed _minter, uint256 _amount, uint256 _price);
1852     event SaleMint(address indexed _minter, uint256 _amount, uint256 _price);
1853     event WorkflowStatusChange(
1854         WorkflowStatus previousStatus,
1855         WorkflowStatus newStatus
1856     );
1857 
1858     constructor()
1859         ERC721("Ancient Cats Club", "CAT")
1860         PaymentSplitter(_team, _teamShares)
1861         ReentrancyGuard()
1862     {}
1863 
1864     function changePauseState() public onlyOwner {
1865         paused = !paused;
1866     }
1867 
1868     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
1869         baseURI = _tokenBaseURI;
1870         emit ChangeBaseURI(_tokenBaseURI);
1871     }
1872 
1873     function _baseURI() internal view override returns (string memory) {
1874         return baseURI;
1875     }
1876 
1877     function reveal() public onlyOwner {
1878         revealed = true;
1879     }
1880 
1881     function addToPresaleList(address[] calldata _addresses)
1882         external
1883         onlyOwner
1884     {
1885         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1886             require(
1887                 _addresses[ind] != address(0),
1888                 "Ancient Cats Club: Can't add a zero address"
1889             );
1890             if (_presaleList[_addresses[ind]] == false) {
1891                 _presaleList[_addresses[ind]] = true;
1892             }
1893         }
1894     }
1895 
1896     function isOnPresaleList(address _address) external view returns (bool) {
1897         return _presaleList[_address];
1898     }
1899 
1900     function removeFromPresaleList(address[] calldata _addresses)
1901         external
1902         onlyOwner
1903     {
1904         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1905             require(
1906                 _addresses[ind] != address(0),
1907                 "Ancient Cats Club: Can't remove a zero address"
1908             );
1909             if (_presaleList[_addresses[ind]] == true) {
1910                 _presaleList[_addresses[ind]] = false;
1911             }
1912         }
1913     }
1914 
1915     function setUpPresale(uint256 _duration) external onlyOwner {
1916         require(
1917             workflow == WorkflowStatus.CheckOnPresale,
1918             "Ancient Cats Club: Unauthorized Transaction"
1919         );
1920         uint256 _startTime = block.timestamp;
1921         uint256 _maxCount = 3;
1922         presaleConfig = PresaleConfig(_startTime, _duration, _maxCount);
1923         emit ChangePresaleConfig(_startTime, _duration, _maxCount);
1924         workflow = WorkflowStatus.Presale;
1925         emit WorkflowStatusChange(
1926             WorkflowStatus.CheckOnPresale,
1927             WorkflowStatus.Presale
1928         );
1929     }
1930 
1931     function setUpSale() external onlyOwner {
1932         require(
1933             workflow == WorkflowStatus.Presale,
1934             "Ancient Cats Club: Unauthorized Transaction"
1935         );
1936         PresaleConfig memory _presaleConfig = presaleConfig;
1937         uint256 _presaleEndTime = _presaleConfig.startTime +
1938             _presaleConfig.duration;
1939         require(
1940             block.timestamp > _presaleEndTime,
1941             "Ancient Cats Club: Sale not started"
1942         );
1943         uint256 _startTime = block.timestamp;
1944         uint256 _maxCount = 10;
1945         saleConfig = SaleConfig(_startTime, _maxCount);
1946         emit ChangeSaleConfig(_startTime, _maxCount);
1947         workflow = WorkflowStatus.Sale;
1948         emit WorkflowStatusChange(WorkflowStatus.Presale, WorkflowStatus.Sale);
1949     }
1950 
1951     function setIsBurnEnabled(bool _isBurnEnabled) external onlyOwner {
1952         isBurnEnabled = _isBurnEnabled;
1953         emit ChangeIsBurnEnabled(_isBurnEnabled);
1954     }
1955 
1956     function giftMint(address[] calldata _addresses) external onlyOwner {
1957         require(
1958             totalNFT + _addresses.length <= maxSupply,
1959             "Ancient Cats Club: max total supply exceeded"
1960         );
1961 
1962         require(
1963             giftCount + _addresses.length <= maxGiftSupply,
1964             "Ancient Cats Club: max gift supply exceeded"
1965         );
1966 
1967         uint256 _newItemId;
1968         for (uint256 ind = 0; ind < _addresses.length; ind++) {
1969             require(
1970                 _addresses[ind] != address(0),
1971                 "Ancient Cats Club: recepient is the null address"
1972             );
1973             _tokenIds.increment();
1974             _newItemId = _tokenIds.current();
1975             _safeMint(_addresses[ind], _newItemId);
1976             _giftClaimed[_addresses[ind]] = _giftClaimed[_addresses[ind]] + 1;
1977             _totalClaimed[_addresses[ind]] = _totalClaimed[_addresses[ind]] + 1;
1978             totalNFT = totalNFT + 1;
1979             giftCount = giftCount + 1;
1980         }
1981     }
1982 
1983     function presaleMint(uint256 _amount) external payable nonReentrant {
1984         PresaleConfig memory _presaleConfig = presaleConfig;
1985         uint256 presaleAmountLimit;
1986         if (block.timestamp <= _presaleConfig.startTime + 6 hours) {
1987             presaleAmountLimit = 1;
1988         } else {
1989             presaleAmountLimit = 3;
1990         }
1991         require(
1992             _amount <= presaleAmountLimit,
1993             "Ancient Cats Club: You can't mint so much tokens"
1994         );
1995         require(
1996             _presaleClaimed[msg.sender] + _amount <= presaleAmountLimit,
1997             "Ancient Cats Club: You can't mint so much tokens"
1998         );
1999         require(
2000             _presaleList[msg.sender] == true,
2001             " Caller is not on the presale list"
2002         );
2003         require(
2004             _presaleConfig.startTime > 0,
2005             "Ancient Cats Club: Presale must be active to mint Ancient Cats"
2006         );
2007         require(
2008             block.timestamp >= _presaleConfig.startTime,
2009             "Ancient Cats Club: Presale not started"
2010         );
2011         require(
2012             block.timestamp <=
2013                 _presaleConfig.startTime + _presaleConfig.duration,
2014             "Ancient Cats Club: Presale is ended"
2015         );
2016         require(
2017             totalNFT + _amount <= maxPresaleSupply,
2018             "Ancient Cats Club: max presale supply exceeded"
2019         );
2020         require(
2021             totalNFT + _amount <= maxSupply,
2022             "Ancient Cats Club: max supply exceeded"
2023         );
2024         uint256 _price = 100000000000000000; // 0.1 ETH
2025         require(
2026             _price <= msg.value,
2027             "Ancient Cats Club: Ether value sent is not correct"
2028         );
2029         require(!paused, "Ancient Cats Club: contract is paused");
2030         uint256 _newItemId;
2031         for (uint256 ind = 0; ind < _amount; ind++) {
2032             _tokenIds.increment();
2033             _newItemId = _tokenIds.current();
2034             _safeMint(msg.sender, _newItemId);
2035             _presaleClaimed[msg.sender] = _presaleClaimed[msg.sender] + 1;
2036             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + 1;
2037             totalNFT = totalNFT + 1;
2038             presaleCount = presaleCount + 1;
2039         }
2040         emit PresaleMint(msg.sender, _amount, _price);
2041     }
2042 
2043     function saleMint(uint256 _amount) external payable nonReentrant {
2044         uint256 _price;
2045         SaleConfig memory _saleConfig = saleConfig;
2046         if (block.timestamp <= _saleConfig.startTime + 6 hours) {
2047             _price = 200000000000000000; //0.2 ETH
2048         } else {
2049             _price = 150000000000000000; //0.15 ETH
2050         }
2051         require(_amount > 0, "Ancient Cats Club: zero amount");
2052         require(
2053             _saleConfig.startTime > 0,
2054             "Ancient Cats Club: sale is not active"
2055         );
2056         require(
2057             block.timestamp >= _saleConfig.startTime,
2058             "Ancient Cats Club: sale not started"
2059         );
2060         require(
2061             _amount <= _saleConfig.maxCount,
2062             "Ancient Cats Club:  Can only mint 10 tokens at a time"
2063         );
2064         require(
2065             totalNFT + _amount <= maxSupply,
2066             "Ancient Cats Club: max supply exceeded"
2067         );
2068         require(
2069             totalNFT + _amount <= maxSaleSupply,
2070             "Ancient Cats Club: max supply exceeded"
2071         );
2072         require(
2073             _price * _amount <= msg.value,
2074             "Ancient Cats Club: Ether value sent is not correct"
2075         );
2076         require(!paused, "Ancient Cats Club: contract is paused");
2077         uint256 _newItemId;
2078         for (uint256 ind = 0; ind < _amount; ind++) {
2079             _tokenIds.increment();
2080             _newItemId = _tokenIds.current();
2081             _safeMint(msg.sender, _newItemId);
2082             _saleClaimed[msg.sender] = _saleClaimed[msg.sender] + 1;
2083             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + 1;
2084             totalNFT = totalNFT + 1;
2085         }
2086         emit SaleMint(msg.sender, _amount, _price);
2087         if (totalNFT + _amount == maxSupply) {
2088             workflow = WorkflowStatus.SoldOut;
2089             emit WorkflowStatusChange(
2090                 WorkflowStatus.Sale,
2091                 WorkflowStatus.SoldOut
2092             );
2093         }
2094     }
2095 
2096     function getWorkflowStatus() public view returns (uint256) {
2097         uint256 _status;
2098         if (workflow == WorkflowStatus.CheckOnPresale) {
2099             _status = 1;
2100         }
2101         if (workflow == WorkflowStatus.Presale) {
2102             _status = 2;
2103         }
2104         if (workflow == WorkflowStatus.Sale) {
2105             _status = 3;
2106         }
2107         if (workflow == WorkflowStatus.SoldOut) {
2108             _status = 4;
2109         }
2110         return _status;
2111     }
2112 
2113     function tokenURI(uint256 tokenId)
2114         public
2115         view
2116         virtual
2117         override
2118         returns (string memory)
2119     {
2120         require(
2121             _exists(tokenId),
2122             "ERC721Metadata: URI query for nonexistent token"
2123         );
2124         if (revealed == false) {
2125             return notRevealedUri;
2126         }
2127 
2128         string memory currentBaseURI = _baseURI();
2129         return
2130             bytes(currentBaseURI).length > 0
2131                 ? string(
2132                     abi.encodePacked(
2133                         currentBaseURI,
2134                         tokenId.toString(),
2135                         baseExtension
2136                     )
2137                 )
2138                 : "";
2139     }
2140 
2141     function setBaseExtension(string memory _newBaseExtension)
2142         public
2143         onlyOwner
2144     {
2145         baseExtension = _newBaseExtension;
2146     }
2147 
2148     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2149         notRevealedUri = _notRevealedURI;
2150     }
2151 
2152     function changeTotalSupply(uint256 _newSupply) public onlyOwner {
2153         maxSupply = _newSupply;
2154     }
2155 
2156     function changeSaleSupply(uint256 _newSaleSupply) public onlyOwner {
2157         maxSaleSupply = _newSaleSupply;
2158     }
2159 
2160     function burn(uint256 tokenId) external {
2161         require(isBurnEnabled, "Ancient Cats Club: burning disabled");
2162         require(
2163             _isApprovedOrOwner(msg.sender, tokenId),
2164             "Ancient Cats Club: burn caller is not owner nor approved"
2165         );
2166         _burn(tokenId);
2167         totalNFT = totalNFT - 1;
2168     }
2169 }