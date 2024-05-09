1 pragma solidity ^0.8.17;
2 
3 
4 
5 
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         return msg.data;
14     }
15 }
16 
17 library Address {
18   
19     function isContract(address account) internal view returns (bool) {
20         // This method relies on extcodesize/address.code.length, which returns 0
21         // for contracts in construction, since the code is only stored at the end
22         // of the constructor execution.
23 
24         return account.code.length > 0;
25     }
26 
27     /**
28      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
29      * `recipient`, forwarding all available gas and reverting on errors.
30      *
31      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
32      * of certain opcodes, possibly making contracts go over the 2300 gas limit
33      * imposed by `transfer`, making them unable to receive funds via
34      * `transfer`. {sendValue} removes this limitation.
35      *
36      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
37      *
38      * IMPORTANT: because control is transferred to `recipient`, care must be
39      * taken to not create reentrancy vulnerabilities. Consider using
40      * {ReentrancyGuard} or the
41      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
42      */
43     function sendValue(address payable recipient, uint256 amount) internal {
44         require(address(this).balance >= amount, "Address: insufficient balance");
45 
46         (bool success, ) = recipient.call{value: amount}("");
47         require(success, "Address: unable to send value, recipient may have reverted");
48     }
49 
50     /**
51      * @dev Performs a Solidity function call using a low level `call`. A
52      * plain `call` is an unsafe replacement for a function call: use this
53      * function instead.
54      *
55      * If `target` reverts with a revert reason, it is bubbled up by this
56      * function (like regular Solidity function calls).
57      *
58      * Returns the raw returned data. To convert to the expected return value,
59      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
60      *
61      * Requirements:
62      *
63      * - `target` must be a contract.
64      * - calling `target` with `data` must not revert.
65      *
66      * _Available since v3.1._
67      */
68     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
69         return functionCall(target, data, "Address: low-level call failed");
70     }
71 
72     /**
73      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
74      * `errorMessage` as a fallback revert reason when `target` reverts.
75      *
76      * _Available since v3.1._
77      */
78     function functionCall(
79         address target,
80         bytes memory data,
81         string memory errorMessage
82     ) internal returns (bytes memory) {
83         return functionCallWithValue(target, data, 0, errorMessage);
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
88      * but also transferring `value` wei to `target`.
89      *
90      * Requirements:
91      *
92      * - the calling contract must have an ETH balance of at least `value`.
93      * - the called Solidity function must be `payable`.
94      *
95      * _Available since v3.1._
96      */
97     function functionCallWithValue(
98         address target,
99         bytes memory data,
100         uint256 value
101     ) internal returns (bytes memory) {
102         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
103     }
104 
105     /**
106      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
107      * with `errorMessage` as a fallback revert reason when `target` reverts.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value,
115         string memory errorMessage
116     ) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         (bool success, bytes memory returndata) = target.call{value: value}(data);
121         return verifyCallResult(success, returndata, errorMessage);
122     }
123 
124     /**
125      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
126      * but performing a static call.
127      *
128      * _Available since v3.3._
129      */
130     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
131         return functionStaticCall(target, data, "Address: low-level static call failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
136      * but performing a static call.
137      *
138      * _Available since v3.3._
139      */
140     function functionStaticCall(
141         address target,
142         bytes memory data,
143         string memory errorMessage
144     ) internal view returns (bytes memory) {
145         require(isContract(target), "Address: static call to non-contract");
146 
147         (bool success, bytes memory returndata) = target.staticcall(data);
148         return verifyCallResult(success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a delegate call.
154      *
155      * _Available since v3.4._
156      */
157     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a delegate call.
164      *
165      * _Available since v3.4._
166      */
167     function functionDelegateCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         require(isContract(target), "Address: delegate call to non-contract");
173 
174         (bool success, bytes memory returndata) = target.delegatecall(data);
175         return verifyCallResult(success, returndata, errorMessage);
176     }
177 
178     /**
179      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
180      * revert reason using the provided one.
181      *
182      * _Available since v4.3._
183      */
184     function verifyCallResult(
185         bool success,
186         bytes memory returndata,
187         string memory errorMessage
188     ) internal pure returns (bytes memory) {
189         if (success) {
190             return returndata;
191         } else {
192             // Look for revert reason and bubble it up if present
193             if (returndata.length > 0) {
194                 // The easiest way to bubble the revert reason is using memory via assembly
195 
196                 assembly {
197                     let returndata_size := mload(returndata)
198                     revert(add(32, returndata), returndata_size)
199                 }
200             } else {
201                 revert(errorMessage);
202             }
203         }
204     }
205 }
206 
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _transferOwnership(_msgSender());
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Leaves the contract without owner. It will not be possible to call
250      * `onlyOwner` functions anymore. Can only be called by the current owner.
251      *
252      * NOTE: Renouncing ownership will leave the contract without an owner,
253      * thereby removing any functionality that is only available to the owner.
254      */
255     function renounceOwnership() public virtual onlyOwner {
256         _transferOwnership(address(0));
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Can only be called by the current owner.
262      */
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _transferOwnership(newOwner);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Internal function without access restriction.
271      */
272     function _transferOwnership(address newOwner) internal virtual {
273         address oldOwner = _owner;
274         _owner = newOwner;
275         emit OwnershipTransferred(oldOwner, newOwner);
276     }
277 }
278 
279 // SPDX-License-Identifier: MIT
280 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
281 
282 
283 /**
284  * @title Counters
285  * @author Matt Condon (@shrugs)
286  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
287  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
288  *
289  * Include with `using Counters for Counters.Counter;`
290  */
291 library Counters {
292     struct Counter {
293         // This variable should never be directly accessed by users of the library: interactions must be restricted to
294         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
295         // this feature: see https://github.com/ethereum/solidity/issues/4637
296         uint256 _value; // default: 0
297     }
298 
299     function current(Counter storage counter) internal view returns (uint256) {
300         return counter._value;
301     }
302 
303     function increment(Counter storage counter) internal {
304         unchecked {
305             counter._value += 1;
306         }
307     }
308 
309     function decrement(Counter storage counter) internal {
310         uint256 value = counter._value;
311         require(value > 0, "Counter: decrement overflow");
312         unchecked {
313             counter._value = value - 1;
314         }
315     }
316 
317     function reset(Counter storage counter) internal {
318         counter._value = 0;
319     }
320 }
321 
322 
323 library SafeMath {
324     /**
325      * @dev Returns the addition of two unsigned integers, with an overflow flag.
326      *
327      * _Available since v3.4._
328      */
329     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         unchecked {
331             uint256 c = a + b;
332             if (c < a) return (false, 0);
333             return (true, c);
334         }
335     }
336 
337     /**
338      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
339      *
340      * _Available since v3.4._
341      */
342     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
343         unchecked {
344             if (b > a) return (false, 0);
345             return (true, a - b);
346         }
347     }
348 
349     /**
350      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
351      *
352      * _Available since v3.4._
353      */
354     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
355         unchecked {
356             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
357             // benefit is lost if 'b' is also tested.
358             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
359             if (a == 0) return (true, 0);
360             uint256 c = a * b;
361             if (c / a != b) return (false, 0);
362             return (true, c);
363         }
364     }
365 
366     /**
367      * @dev Returns the division of two unsigned integers, with a division by zero flag.
368      *
369      * _Available since v3.4._
370      */
371     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
372         unchecked {
373             if (b == 0) return (false, 0);
374             return (true, a / b);
375         }
376     }
377 
378     /**
379      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
380      *
381      * _Available since v3.4._
382      */
383     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
384         unchecked {
385             if (b == 0) return (false, 0);
386             return (true, a % b);
387         }
388     }
389 
390     /**
391      * @dev Returns the addition of two unsigned integers, reverting on
392      * overflow.
393      *
394      * Counterpart to Solidity's `+` operator.
395      *
396      * Requirements:
397      *
398      * - Addition cannot overflow.
399      */
400     function add(uint256 a, uint256 b) internal pure returns (uint256) {
401         return a + b;
402     }
403 
404     /**
405      * @dev Returns the subtraction of two unsigned integers, reverting on
406      * overflow (when the result is negative).
407      *
408      * Counterpart to Solidity's `-` operator.
409      *
410      * Requirements:
411      *
412      * - Subtraction cannot overflow.
413      */
414     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
415         return a - b;
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, reverting on
420      * overflow.
421      *
422      * Counterpart to Solidity's `*` operator.
423      *
424      * Requirements:
425      *
426      * - Multiplication cannot overflow.
427      */
428     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
429         return a * b;
430     }
431 
432     /**
433      * @dev Returns the integer division of two unsigned integers, reverting on
434      * division by zero. The result is rounded towards zero.
435      *
436      * Counterpart to Solidity's `/` operator.
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function div(uint256 a, uint256 b) internal pure returns (uint256) {
443         return a / b;
444     }
445 
446     /**
447      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
448      * reverting when dividing by zero.
449      *
450      * Counterpart to Solidity's `%` operator. This function uses a `revert`
451      * opcode (which leaves remaining gas untouched) while Solidity uses an
452      * invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
459         return a % b;
460     }
461 
462     /**
463      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
464      * overflow (when the result is negative).
465      *
466      * CAUTION: This function is deprecated because it requires allocating memory for the error
467      * message unnecessarily. For custom revert reasons use {trySub}.
468      *
469      * Counterpart to Solidity's `-` operator.
470      *
471      * Requirements:
472      *
473      * - Subtraction cannot overflow.
474      */
475     function sub(
476         uint256 a,
477         uint256 b,
478         string memory errorMessage
479     ) internal pure returns (uint256) {
480         unchecked {
481             require(b <= a, errorMessage);
482             return a - b;
483         }
484     }
485 
486     /**
487      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
488      * division by zero. The result is rounded towards zero.
489      *
490      * Counterpart to Solidity's `/` operator. Note: this function uses a
491      * `revert` opcode (which leaves remaining gas untouched) while Solidity
492      * uses an invalid opcode to revert (consuming all remaining gas).
493      *
494      * Requirements:
495      *
496      * - The divisor cannot be zero.
497      */
498     function div(
499         uint256 a,
500         uint256 b,
501         string memory errorMessage
502     ) internal pure returns (uint256) {
503         unchecked {
504             require(b > 0, errorMessage);
505             return a / b;
506         }
507     }
508 
509     /**
510      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
511      * reverting with custom message when dividing by zero.
512      *
513      * CAUTION: This function is deprecated because it requires allocating memory for the error
514      * message unnecessarily. For custom revert reasons use {tryMod}.
515      *
516      * Counterpart to Solidity's `%` operator. This function uses a `revert`
517      * opcode (which leaves remaining gas untouched) while Solidity uses an
518      * invalid opcode to revert (consuming all remaining gas).
519      *
520      * Requirements:
521      *
522      * - The divisor cannot be zero.
523      */
524     function mod(
525         uint256 a,
526         uint256 b,
527         string memory errorMessage
528     ) internal pure returns (uint256) {
529         unchecked {
530             require(b > 0, errorMessage);
531             return a % b;
532         }
533     }
534 }
535 
536 
537 library Strings {
538     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
539 
540     /**
541      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
542      */
543     function toString(uint256 value) internal pure returns (string memory) {
544         // Inspired by OraclizeAPI's implementation - MIT licence
545         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
546 
547         if (value == 0) {
548             return "0";
549         }
550         uint256 temp = value;
551         uint256 digits;
552         while (temp != 0) {
553             digits++;
554             temp /= 10;
555         }
556         bytes memory buffer = new bytes(digits);
557         while (value != 0) {
558             digits -= 1;
559             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
560             value /= 10;
561         }
562         return string(buffer);
563     }
564 
565     /**
566      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
567      */
568     function toHexString(uint256 value) internal pure returns (string memory) {
569         if (value == 0) {
570             return "0x00";
571         }
572         uint256 temp = value;
573         uint256 length = 0;
574         while (temp != 0) {
575             length++;
576             temp >>= 8;
577         }
578         return toHexString(value, length);
579     }
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
583      */
584     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
585         bytes memory buffer = new bytes(2 * length + 2);
586         buffer[0] = "0";
587         buffer[1] = "x";
588         for (uint256 i = 2 * length + 1; i > 1; --i) {
589             buffer[i] = _HEX_SYMBOLS[value & 0xf];
590             value >>= 4;
591         }
592         require(value == 0, "Strings: hex length insufficient");
593         return string(buffer);
594     }
595 }
596 
597 library SafeERC20 {
598     using Address for address;
599 
600     function safeTransfer(
601         IERC20 token,
602         address to,
603         uint256 value
604     ) internal {
605         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
606     }
607 
608     function safeTransferFrom(
609         IERC20 token,
610         address from,
611         address to,
612         uint256 value
613     ) internal {
614         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
615     }
616 
617     /**
618      * @dev Deprecated. This function has issues similar to the ones found in
619      * {IERC20-approve}, and its usage is discouraged.
620      *
621      * Whenever possible, use {safeIncreaseAllowance} and
622      * {safeDecreaseAllowance} instead.
623      */
624     function safeApprove(
625         IERC20 token,
626         address spender,
627         uint256 value
628     ) internal {
629         // safeApprove should only be called when setting an initial allowance,
630         // or when resetting it to zero. To increase and decrease it, use
631         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
632         require(
633             (value == 0) || (token.allowance(address(this), spender) == 0),
634             "SafeERC20: approve from non-zero to non-zero allowance"
635         );
636         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
637     }
638 
639     function safeIncreaseAllowance(
640         IERC20 token,
641         address spender,
642         uint256 value
643     ) internal {
644         uint256 newAllowance = token.allowance(address(this), spender) + value;
645         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
646     }
647 
648     function safeDecreaseAllowance(
649         IERC20 token,
650         address spender,
651         uint256 value
652     ) internal {
653         unchecked {
654             uint256 oldAllowance = token.allowance(address(this), spender);
655             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
656             uint256 newAllowance = oldAllowance - value;
657             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
658         }
659     }
660 
661     /**
662      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
663      * on the return value: the return value is optional (but if data is returned, it must not be false).
664      * @param token The token targeted by the call.
665      * @param data The call data (encoded using abi.encode or one of its variants).
666      */
667     function _callOptionalReturn(IERC20 token, bytes memory data) private {
668         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
669         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
670         // the target address contains contract code and also asserts for success in the low-level call.
671 
672         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
673         if (returndata.length > 0) {
674             // Return data is optional
675             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
676         }
677     }
678 }
679 
680 
681 interface IERC20 {
682     /**
683      * @dev Emitted when `value` tokens are moved from one account (`from`) to
684      * another (`to`).
685      *
686      * Note that `value` may be zero.
687      */
688     event Transfer(address indexed from, address indexed to, uint256 value);
689 
690     /**
691      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
692      * a call to {approve}. `value` is the new allowance.
693      */
694     event Approval(address indexed owner, address indexed spender, uint256 value);
695 
696     /**
697      * @dev Returns the amount of tokens in existence.
698      */
699     function totalSupply() external view returns (uint256);
700 
701     /**
702      * @dev Returns the amount of tokens owned by `account`.
703      */
704     function balanceOf(address account) external view returns (uint256);
705 
706     /**
707      * @dev Moves `amount` tokens from the caller's account to `to`.
708      *
709      * Returns a boolean value indicating whether the operation succeeded.
710      *
711      * Emits a {Transfer} event.
712      */
713     function transfer(address to, uint256 amount) external returns (bool);
714 
715     /**
716      * @dev Returns the remaining number of tokens that `spender` will be
717      * allowed to spend on behalf of `owner` through {transferFrom}. This is
718      * zero by default.
719      *
720      * This value changes when {approve} or {transferFrom} are called.
721      */
722     function allowance(address owner, address spender) external view returns (uint256);
723 
724     /**
725      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
726      *
727      * Returns a boolean value indicating whether the operation succeeded.
728      *
729      * IMPORTANT: Beware that changing an allowance with this method brings the risk
730      * that someone may use both the old and the new allowance by unfortunate
731      * transaction ordering. One possible solution to mitigate this race
732      * condition is to first reduce the spender's allowance to 0 and set the
733      * desired value afterwards:
734      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
735      *
736      * Emits an {Approval} event.
737      */
738     function approve(address spender, uint256 amount) external returns (bool);
739 
740     /**
741      * @dev Moves `amount` tokens from `from` to `to` using the
742      * allowance mechanism. `amount` is then deducted from the caller's
743      * allowance.
744      *
745      * Returns a boolean value indicating whether the operation succeeded.
746      *
747      * Emits a {Transfer} event.
748      */
749     function transferFrom(
750         address from,
751         address to,
752         uint256 amount
753     ) external returns (bool);
754 }
755 
756 
757 
758 
759 pragma solidity ^0.8.0;
760 abstract contract ReentrancyGuard {
761     uint256 private constant _NOT_ENTERED = 1;
762     uint256 private constant _ENTERED = 2;
763     uint256 private _status;
764 
765     constructor() {
766         _status = _NOT_ENTERED;
767     }
768     modifier nonReentrant() {
769         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
770 
771         _status = _ENTERED;
772 
773         _;
774         _status = _NOT_ENTERED;
775     }
776 }
777 
778 
779 interface IDEXRouter {
780     function factory() external pure returns (address);
781     function WETH() external pure returns (address);
782     function swapExactETHForTokensSupportingFeeOnTransferTokens(
783         uint amountOutMin,
784         address[] calldata path,
785         address to,
786         uint deadline
787     ) external payable;
788 
789     function swapExactTokensForETHSupportingFeeOnTransferTokens(
790         uint amountIn,
791         uint amountOutMin,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external;
796 
797     function getAmountsOut(uint amountIn, address[] memory path) external view returns (uint[] memory amounts);
798 }
799 
800 contract BATTLE is Ownable {
801 
802     struct Game {
803         uint256 revolverSize;
804         uint256 minBet;
805 
806         // This is a SHA-256 hash of the random number generated by the bot.
807         bytes32 hashedBulletChamberIndex;
808 
809         address[] players;
810         uint256[] bets;
811 
812         bool inProgress;
813         uint16 loser;
814     }
815 
816     address public immutable Dead = 0x000000000000000000000000000000000000dEaD;
817 
818     address public revenueWallet;
819 
820     IERC20 public  bettingToken;
821     
822     uint256 public  minimumBet;
823 
824     uint256 public  revenueBps;
825 
826     uint256 public  burnBps;
827 
828     mapping(int64 => Game) public games;
829 
830     int64[] public activeTgGroups;
831 
832     event Bet(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
833 
834     event Win(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
835 
836     event Loss(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
837 
838     event Revenue(int64 tgChatId, uint256 amount);
839 
840     event Burn(int64 tgChatId, uint256 amount);
841 
842     constructor() {
843         revenueWallet = 0xF21c708B656Bd87b3E31e53Ac3ed1ff5eb74b836;
844         revenueBps = 800;
845         burnBps = 200;
846         minimumBet = 1000;
847     }
848 
849     function isGameInProgress(int64 _tgChatId) public view returns (bool) {
850         return games[_tgChatId].inProgress;
851     }
852 
853     function removeTgId(int64 _tgChatId) internal {
854         for (uint256 i = 0; i < activeTgGroups.length; i++) {
855             if (activeTgGroups[i] == _tgChatId) {
856                 activeTgGroups[i] = activeTgGroups[activeTgGroups.length - 1];
857                 activeTgGroups.pop();
858             }
859         }
860     }
861 
862     function setMin(uint256 _minimumBet, uint256 _revenueBps, uint256 _burnBps) external onlyOwner {
863         minimumBet =  _minimumBet;
864         revenueBps =_revenueBps;
865         burnBps = _burnBps;
866     }
867 
868     function setBetToken(address _contract) external onlyOwner {
869         bettingToken = IERC20(_contract);
870     }
871 
872     function updateRevenueWalelt(address _wallet) external onlyOwner {
873         revenueWallet = _wallet;
874     }
875 
876     function start(
877         int64 _tgChatId,
878         uint256 _revolverSize,
879         uint256 _minBet,
880         bytes32 _hashedBulletChamberIndex,
881         address[] memory _players,
882         uint256[] memory _bets) public onlyOwner  returns (uint256[] memory) {
883 
884         require(_revolverSize >= 2, "Revolver size too small");
885         require(_players.length <= _revolverSize, "Too many players for this size revolver");
886         require(_minBet >= minimumBet, "Minimum bet too small");
887         require(_players.length == _bets.length, "Players/bets length mismatch");
888         require(_players.length > 1, "Not enough players");
889         require(!isGameInProgress(_tgChatId), "There is already a game in progress");
890 
891         uint256 betTotal = 0;
892         for (uint16 i = 0; i < _bets.length; i++) {
893             require(_bets[i] >= _minBet, "Bet is smaller than the minimum");
894             betTotal += _bets[i];
895         }
896         for (uint16 i = 0; i < _bets.length; i++) {
897             betTotal -= _bets[i];
898             if (_bets[i] > betTotal) {
899                 _bets[i] = betTotal;
900             }
901             betTotal += _bets[i];
902 
903             require(bettingToken.allowance(_players[i], address(this)) >= _bets[i], "Not enough allowance");
904             bool isSent = bettingToken.transferFrom(_players[i], address(this), _bets[i]);
905             require(isSent, "Funds transfer failed");
906 
907             emit Bet(_tgChatId, _players[i], i, _bets[i]);
908         }
909 
910         Game memory g;
911         g.revolverSize = _revolverSize;
912         g.minBet = _minBet;
913         g.hashedBulletChamberIndex = _hashedBulletChamberIndex;
914         g.players = _players;
915         g.bets = _bets;
916         g.inProgress = true;
917 
918         games[_tgChatId] = g;
919         activeTgGroups.push(_tgChatId);
920 
921         return _bets;
922     }
923 
924     function end(
925         int64 _tgChatId,
926         uint16 _loser,
927         string[] calldata) public onlyOwner {
928         require(_loser != type(uint16).max, "Loser index shouldn't be the sentinel value");
929         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
930 
931         Game storage g = games[_tgChatId];
932 
933         require(_loser < g.players.length, "Loser index out of range");
934         require(g.players.length > 1, "Not enough players");
935 
936         g.loser = _loser;
937         g.inProgress = false;
938         removeTgId(_tgChatId);
939 
940         address[] memory winners = new address[](g.players.length - 1);
941         uint16[] memory winnersPlayerIndex = new uint16[](g.players.length - 1);
942 
943         uint256 winningBetTotal = 0;
944 
945         {
946             uint16 numWinners = 0;
947             for (uint16 i = 0; i < g.players.length; i++) {
948                 if (i != _loser) {
949                     winners[numWinners] = g.players[i];
950                     winnersPlayerIndex[numWinners] = i;
951                     winningBetTotal += g.bets[i];
952                     numWinners++;
953                 }
954             }
955         }
956 
957         uint256 totalPaidWinnings = 0;
958         require(burnBps + revenueBps < 10_1000, "Total fees must be < 100%");
959 
960         uint256 burnShare = g.bets[_loser] * burnBps / 10_000;
961 
962         uint256 approxRevenueShare = g.bets[_loser] * revenueBps / 10_000;
963 
964         bool isSent;
965         {
966             uint256 totalWinnings = g.bets[_loser] - burnShare - approxRevenueShare;
967 
968             for (uint16 i = 0; i < winners.length; i++) {
969                 uint256 winnings = totalWinnings * g.bets[winnersPlayerIndex[i]] / winningBetTotal;
970 
971                 isSent = bettingToken.transfer(winners[i], g.bets[winnersPlayerIndex[i]] + winnings);
972                 require(isSent, "Funds transfer failed");
973 
974                 emit Win(_tgChatId, winners[i], winnersPlayerIndex[i], winnings);
975 
976                 totalPaidWinnings += winnings;
977             }
978         }
979 
980         bettingToken.transfer(Dead, burnShare);
981         uint256 realRevenueShare = g.bets[_loser] - totalPaidWinnings - burnShare;
982         isSent = bettingToken.transfer(revenueWallet, realRevenueShare);
983         require(isSent, "Revenue transfer failed");
984         emit Revenue(_tgChatId, realRevenueShare);
985         require((totalPaidWinnings + burnShare + realRevenueShare) == g.bets[_loser], "Calculated winnings do not add up");
986     }
987 
988      function endV2(
989         int64 _tgChatId,
990         uint16[] calldata _losers,
991         uint16 _winner,
992         string[] calldata _results
993     ) public onlyOwner {
994         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
995 
996         Game storage g = games[_tgChatId];
997 
998         require(_losers.length + 1 == g.players.length, "Invalid number of losers and winner");
999         require(_winner < g.players.length, "Winner index out of range");
1000 
1001         g.inProgress = false;
1002         removeTgId(_tgChatId);
1003 
1004         address[] memory loosers = new address[](_losers.length);
1005 
1006         uint256 winningBetTotal = g.bets[_winner];
1007 
1008       
1009         for (uint256 i = 0; i < _losers.length; i++) {
1010             loosers[i] = g.players[_losers[i]];
1011             winningBetTotal += g.bets[_losers[i]];
1012         }
1013 
1014         uint256 burnShare = winningBetTotal * burnBps / 10_000;
1015         uint256 approxRevenueShare = winningBetTotal * revenueBps / 10_000;
1016         uint256 totalWinnings = winningBetTotal - burnShare - approxRevenueShare;
1017 
1018         bool isSent;
1019         {
1020             isSent = bettingToken.transfer(g.players[_winner], totalWinnings);
1021             require(isSent, "Funds transfer failed");
1022         }
1023         
1024         bettingToken.transfer(Dead, burnShare);
1025         isSent = bettingToken.transfer(revenueWallet, approxRevenueShare);
1026 
1027         require(isSent, "Revenue transfer failed");
1028         emit Revenue(_tgChatId, approxRevenueShare);
1029         require(burnShare + approxRevenueShare + totalWinnings <= winningBetTotal, "Calculated winnings do not add up");
1030     }
1031     
1032 
1033     function abortGame(int64 _tgChatId) public onlyOwner {
1034         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
1035         Game storage g = games[_tgChatId];
1036 
1037         for (uint16 i = 0; i < g.players.length; i++) {
1038             bool isSent = bettingToken.transfer(g.players[i], g.bets[i]);
1039             require(isSent, "Funds transfer failed");
1040         }
1041 
1042         g.inProgress = false;
1043         removeTgId(_tgChatId);
1044     }
1045 
1046   
1047     function abortAllGames() public onlyOwner {
1048         int64[] memory _activeTgGroups = activeTgGroups;
1049         for (uint256 i = 0; i < _activeTgGroups.length; i++) {
1050             abortGame(_activeTgGroups[i]);
1051         }
1052     }
1053 
1054      function emergencyWithdrawEther() external onlyOwner {
1055         (bool success, ) = revenueWallet.call{value: address(this).balance}("");
1056         require(success, "Withdraw failed");
1057     }
1058 }