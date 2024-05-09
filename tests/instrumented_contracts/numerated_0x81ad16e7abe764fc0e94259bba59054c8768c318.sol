1 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22     unchecked {
23         uint256 c = a + b;
24         if (c < a) return (false, 0);
25         return (true, c);
26     }
27     }
28 
29     /**
30      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35     unchecked {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39     }
40 
41     /**
42      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47     unchecked {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56     }
57 
58     /**
59      * @dev Returns the division of two unsigned integers, with a division by zero flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64     unchecked {
65         if (b == 0) return (false, 0);
66         return (true, a / b);
67     }
68     }
69 
70     /**
71      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
72      *
73      * _Available since v3.4._
74      */
75     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
76     unchecked {
77         if (b == 0) return (false, 0);
78         return (true, a % b);
79     }
80     }
81 
82     /**
83      * @dev Returns the addition of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `+` operator.
87      *
88      * Requirements:
89      *
90      * - Addition cannot overflow.
91      */
92     function add(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a + b;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      *
104      * - Subtraction cannot overflow.
105      */
106     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107         return a - b;
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `*` operator.
115      *
116      * Requirements:
117      *
118      * - Multiplication cannot overflow.
119      */
120     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a * b;
122     }
123 
124     /**
125      * @dev Returns the integer division of two unsigned integers, reverting on
126      * division by zero. The result is rounded towards zero.
127      *
128      * Counterpart to Solidity's `/` operator.
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a / b;
136     }
137 
138     /**
139      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
140      * reverting when dividing by zero.
141      *
142      * Counterpart to Solidity's `%` operator. This function uses a `revert`
143      * opcode (which leaves remaining gas untouched) while Solidity uses an
144      * invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      *
148      * - The divisor cannot be zero.
149      */
150     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
151         return a % b;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156      * overflow (when the result is negative).
157      *
158      * CAUTION: This function is deprecated because it requires allocating memory for the error
159      * message unnecessarily. For custom revert reasons use {trySub}.
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(
168         uint256 a,
169         uint256 b,
170         string memory errorMessage
171     ) internal pure returns (uint256) {
172     unchecked {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176     }
177 
178     /**
179      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
180      * division by zero. The result is rounded towards zero.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195     unchecked {
196         require(b > 0, errorMessage);
197         return a / b;
198     }
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * reverting with custom message when dividing by zero.
204      *
205      * CAUTION: This function is deprecated because it requires allocating memory for the error
206      * message unnecessarily. For custom revert reasons use {tryMod}.
207      *
208      * Counterpart to Solidity's `%` operator. This function uses a `revert`
209      * opcode (which leaves remaining gas untouched) while Solidity uses an
210      * invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function mod(
217         uint256 a,
218         uint256 b,
219         string memory errorMessage
220     ) internal pure returns (uint256) {
221     unchecked {
222         require(b > 0, errorMessage);
223         return a % b;
224     }
225     }
226 }
227 
228 
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @title Counters
236  * @author Matt Condon (@shrugs)
237  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
238  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
239  *
240  * Include with `using Counters for Counters.Counter;`
241  */
242 library Counters {
243     struct Counter {
244         // This variable should never be directly accessed by users of the library: interactions must be restricted to
245         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
246         // this feature: see https://github.com/ethereum/solidity/issues/4637
247         uint256 _value; // default: 0
248     }
249 
250     function current(Counter storage counter) internal view returns (uint256) {
251         return counter._value;
252     }
253 
254     function increment(Counter storage counter) internal {
255     unchecked {
256         counter._value += 1;
257     }
258     }
259 
260     function decrement(Counter storage counter) internal {
261         uint256 value = counter._value;
262         require(value > 0, "Counter: decrement overflow");
263     unchecked {
264         counter._value = value - 1;
265     }
266     }
267 
268     function reset(Counter storage counter) internal {
269         counter._value = 0;
270     }
271 }
272 
273 
274 
275 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Contract module that helps prevent reentrant calls to a function.
281  *
282  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
283  * available, which can be applied to functions to make sure there are no nested
284  * (reentrant) calls to them.
285  *
286  * Note that because there is a single `nonReentrant` guard, functions marked as
287  * `nonReentrant` may not call one another. This can be worked around by making
288  * those functions `private`, and then adding `external` `nonReentrant` entry
289  * points to them.
290  *
291  * TIP: If you would like to learn more about reentrancy and alternative ways
292  * to protect against it, check out our blog post
293  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
294  */
295 abstract contract ReentrancyGuard {
296     // Booleans are more expensive than uint256 or any type that takes up a full
297     // word because each write operation emits an extra SLOAD to first read the
298     // slot's contents, replace the bits taken up by the boolean, and then write
299     // back. This is the compiler's defense against contract upgrades and
300     // pointer aliasing, and it cannot be disabled.
301 
302     // The values being non-zero value makes deployment a bit more expensive,
303     // but in exchange the refund on every call to nonReentrant will be lower in
304     // amount. Since refunds are capped to a percentage of the total
305     // transaction's gas, it is best to keep them low in cases like this one, to
306     // increase the likelihood of the full refund coming into effect.
307     uint256 private constant _NOT_ENTERED = 1;
308     uint256 private constant _ENTERED = 2;
309 
310     uint256 private _status;
311 
312     constructor() {
313         _status = _NOT_ENTERED;
314     }
315 
316     /**
317      * @dev Prevents a contract from calling itself, directly or indirectly.
318      * Calling a `nonReentrant` function from another `nonReentrant`
319      * function is not supported. It is possible to prevent this from happening
320      * by making the `nonReentrant` function external, and making it call a
321      * `private` function that does the actual work.
322      */
323     modifier nonReentrant() {
324         // On the first call to nonReentrant, _notEntered will be true
325         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
326 
327         // Any calls to nonReentrant after this point will fail
328         _status = _ENTERED;
329 
330         _;
331 
332         // By storing the original value once again, a refund is triggered (see
333         // https://eips.ethereum.org/EIPS/eip-2200)
334         _status = _NOT_ENTERED;
335     }
336 }
337 
338 
339 
340 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
341 
342 pragma solidity ^0.8.0;
343 
344 /**
345  * @dev Interface of the ERC20 standard as defined in the EIP.
346  */
347 interface IERC20 {
348     /**
349      * @dev Returns the amount of tokens in existence.
350      */
351     function totalSupply() external view returns (uint256);
352 
353     /**
354      * @dev Returns the amount of tokens owned by `account`.
355      */
356     function balanceOf(address account) external view returns (uint256);
357 
358     /**
359      * @dev Moves `amount` tokens from the caller's account to `recipient`.
360      *
361      * Returns a boolean value indicating whether the operation succeeded.
362      *
363      * Emits a {Transfer} event.
364      */
365     function transfer(address recipient, uint256 amount) external returns (bool);
366 
367     /**
368      * @dev Returns the remaining number of tokens that `spender` will be
369      * allowed to spend on behalf of `owner` through {transferFrom}. This is
370      * zero by default.
371      *
372      * This value changes when {approve} or {transferFrom} are called.
373      */
374     function allowance(address owner, address spender) external view returns (uint256);
375 
376     /**
377      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
378      *
379      * Returns a boolean value indicating whether the operation succeeded.
380      *
381      * IMPORTANT: Beware that changing an allowance with this method brings the risk
382      * that someone may use both the old and the new allowance by unfortunate
383      * transaction ordering. One possible solution to mitigate this race
384      * condition is to first reduce the spender's allowance to 0 and set the
385      * desired value afterwards:
386      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
387      *
388      * Emits an {Approval} event.
389      */
390     function approve(address spender, uint256 amount) external returns (bool);
391 
392     /**
393      * @dev Moves `amount` tokens from `sender` to `recipient` using the
394      * allowance mechanism. `amount` is then deducted from the caller's
395      * allowance.
396      *
397      * Returns a boolean value indicating whether the operation succeeded.
398      *
399      * Emits a {Transfer} event.
400      */
401     function transferFrom(
402         address sender,
403         address recipient,
404         uint256 amount
405     ) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to {approve}. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev String operations.
435  */
436 library Strings {
437     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
438 
439     /**
440      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
441      */
442     function toString(uint256 value) internal pure returns (string memory) {
443         // Inspired by OraclizeAPI's implementation - MIT licence
444         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
445 
446         if (value == 0) {
447             return "0";
448         }
449         uint256 temp = value;
450         uint256 digits;
451         while (temp != 0) {
452             digits++;
453             temp /= 10;
454         }
455         bytes memory buffer = new bytes(digits);
456         while (value != 0) {
457             digits -= 1;
458             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
459             value /= 10;
460         }
461         return string(buffer);
462     }
463 
464     /**
465      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
466      */
467     function toHexString(uint256 value) internal pure returns (string memory) {
468         if (value == 0) {
469             return "0x00";
470         }
471         uint256 temp = value;
472         uint256 length = 0;
473         while (temp != 0) {
474             length++;
475             temp >>= 8;
476         }
477         return toHexString(value, length);
478     }
479 
480     /**
481      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
482      */
483     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
484         bytes memory buffer = new bytes(2 * length + 2);
485         buffer[0] = "0";
486         buffer[1] = "x";
487         for (uint256 i = 2 * length + 1; i > 1; --i) {
488             buffer[i] = _HEX_SYMBOLS[value & 0xf];
489             value >>= 4;
490         }
491         require(value == 0, "Strings: hex length insufficient");
492         return string(buffer);
493     }
494 }
495 
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Provides information about the current execution context, including the
504  * sender of the transaction and its data. While these are generally available
505  * via msg.sender and msg.data, they should not be accessed in such a direct
506  * manner, since when dealing with meta-transactions the account sending and
507  * paying for execution may not be the actual sender (as far as an application
508  * is concerned).
509  *
510  * This contract is only required for intermediate, library-like contracts.
511  */
512 abstract contract Context {
513     function _msgSender() internal view virtual returns (address) {
514         return msg.sender;
515     }
516 
517     function _msgData() internal view virtual returns (bytes calldata) {
518         return msg.data;
519     }
520 }
521 
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
525 
526 pragma solidity ^0.8.0;
527 
528 
529 /**
530  * @dev Contract module which provides a basic access control mechanism, where
531  * there is an account (an owner) that can be granted exclusive access to
532  * specific functions.
533  *
534  * By default, the owner account will be the one that deploys the contract. This
535  * can later be changed with {transferOwnership}.
536  *
537  * This module is used through inheritance. It will make available the modifier
538  * `onlyOwner`, which can be applied to your functions to restrict their use to
539  * the owner.
540  */
541 abstract contract Ownable is Context {
542     address private _owner;
543 
544     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
545 
546     /**
547      * @dev Initializes the contract setting the deployer as the initial owner.
548      */
549     constructor() {
550         _transferOwnership(_msgSender());
551     }
552 
553     /**
554      * @dev Returns the address of the current owner.
555      */
556     function owner() public view virtual returns (address) {
557         return _owner;
558     }
559 
560     /**
561      * @dev Throws if called by any account other than the owner.
562      */
563     modifier onlyOwner() {
564         require(owner() == _msgSender(), "Ownable: caller is not the owner");
565         _;
566     }
567 
568     /**
569      * @dev Leaves the contract without owner. It will not be possible to call
570      * `onlyOwner` functions anymore. Can only be called by the current owner.
571      *
572      * NOTE: Renouncing ownership will leave the contract without an owner,
573      * thereby removing any functionality that is only available to the owner.
574      */
575     function renounceOwnership() public virtual onlyOwner {
576         _transferOwnership(address(0));
577     }
578 
579     /**
580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
581      * Can only be called by the current owner.
582      */
583     function transferOwnership(address newOwner) public virtual onlyOwner {
584         require(newOwner != address(0), "Ownable: new owner is the zero address");
585         _transferOwnership(newOwner);
586     }
587 
588     /**
589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
590      * Internal function without access restriction.
591      */
592     function _transferOwnership(address newOwner) internal virtual {
593         address oldOwner = _owner;
594         _owner = newOwner;
595         emit OwnershipTransferred(oldOwner, newOwner);
596     }
597 }
598 
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @dev Collection of functions related to the address type
607  */
608 library Address {
609     /**
610      * @dev Returns true if `account` is a contract.
611      *
612      * [IMPORTANT]
613      * ====
614      * It is unsafe to assume that an address for which this function returns
615      * false is an externally-owned account (EOA) and not a contract.
616      *
617      * Among others, `isContract` will return false for the following
618      * types of addresses:
619      *
620      *  - an externally-owned account
621      *  - a contract in construction
622      *  - an address where a contract will be created
623      *  - an address where a contract lived, but was destroyed
624      * ====
625      */
626     function isContract(address account) internal view returns (bool) {
627         // This method relies on extcodesize, which returns 0 for contracts in
628         // construction, since the code is only stored at the end of the
629         // constructor execution.
630 
631         uint256 size;
632         assembly {
633             size := extcodesize(account)
634         }
635         return size > 0;
636     }
637 
638     /**
639      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
640      * `recipient`, forwarding all available gas and reverting on errors.
641      *
642      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
643      * of certain opcodes, possibly making contracts go over the 2300 gas limit
644      * imposed by `transfer`, making them unable to receive funds via
645      * `transfer`. {sendValue} removes this limitation.
646      *
647      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
648      *
649      * IMPORTANT: because control is transferred to `recipient`, care must be
650      * taken to not create reentrancy vulnerabilities. Consider using
651      * {ReentrancyGuard} or the
652      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
653      */
654     function sendValue(address payable recipient, uint256 amount) internal {
655         require(address(this).balance >= amount, "Address: insufficient balance");
656 
657         (bool success,) = recipient.call{value : amount}("");
658         require(success, "Address: unable to send value, recipient may have reverted");
659     }
660 
661     /**
662      * @dev Performs a Solidity function call using a low level `call`. A
663      * plain `call` is an unsafe replacement for a function call: use this
664      * function instead.
665      *
666      * If `target` reverts with a revert reason, it is bubbled up by this
667      * function (like regular Solidity function calls).
668      *
669      * Returns the raw returned data. To convert to the expected return value,
670      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
671      *
672      * Requirements:
673      *
674      * - `target` must be a contract.
675      * - calling `target` with `data` must not revert.
676      *
677      * _Available since v3.1._
678      */
679     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
680         return functionCall(target, data, "Address: low-level call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
685      * `errorMessage` as a fallback revert reason when `target` reverts.
686      *
687      * _Available since v3.1._
688      */
689     function functionCall(
690         address target,
691         bytes memory data,
692         string memory errorMessage
693     ) internal returns (bytes memory) {
694         return functionCallWithValue(target, data, 0, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but also transferring `value` wei to `target`.
700      *
701      * Requirements:
702      *
703      * - the calling contract must have an ETH balance of at least `value`.
704      * - the called Solidity function must be `payable`.
705      *
706      * _Available since v3.1._
707      */
708     function functionCallWithValue(
709         address target,
710         bytes memory data,
711         uint256 value
712     ) internal returns (bytes memory) {
713         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
718      * with `errorMessage` as a fallback revert reason when `target` reverts.
719      *
720      * _Available since v3.1._
721      */
722     function functionCallWithValue(
723         address target,
724         bytes memory data,
725         uint256 value,
726         string memory errorMessage
727     ) internal returns (bytes memory) {
728         require(address(this).balance >= value, "Address: insufficient balance for call");
729         require(isContract(target), "Address: call to non-contract");
730 
731         (bool success, bytes memory returndata) = target.call{value : value}(data);
732         return verifyCallResult(success, returndata, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but performing a static call.
738      *
739      * _Available since v3.3._
740      */
741     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
742         return functionStaticCall(target, data, "Address: low-level static call failed");
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
747      * but performing a static call.
748      *
749      * _Available since v3.3._
750      */
751     function functionStaticCall(
752         address target,
753         bytes memory data,
754         string memory errorMessage
755     ) internal view returns (bytes memory) {
756         require(isContract(target), "Address: static call to non-contract");
757 
758         (bool success, bytes memory returndata) = target.staticcall(data);
759         return verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
764      * but performing a delegate call.
765      *
766      * _Available since v3.4._
767      */
768     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
769         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
774      * but performing a delegate call.
775      *
776      * _Available since v3.4._
777      */
778     function functionDelegateCall(
779         address target,
780         bytes memory data,
781         string memory errorMessage
782     ) internal returns (bytes memory) {
783         require(isContract(target), "Address: delegate call to non-contract");
784 
785         (bool success, bytes memory returndata) = target.delegatecall(data);
786         return verifyCallResult(success, returndata, errorMessage);
787     }
788 
789     /**
790      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
791      * revert reason using the provided one.
792      *
793      * _Available since v4.3._
794      */
795     function verifyCallResult(
796         bool success,
797         bytes memory returndata,
798         string memory errorMessage
799     ) internal pure returns (bytes memory) {
800         if (success) {
801             return returndata;
802         } else {
803             // Look for revert reason and bubble it up if present
804             if (returndata.length > 0) {
805                 // The easiest way to bubble the revert reason is using memory via assembly
806 
807                 assembly {
808                     let returndata_size := mload(returndata)
809                     revert(add(32, returndata), returndata_size)
810                 }
811             } else {
812                 revert(errorMessage);
813             }
814         }
815     }
816 }
817 
818 
819 
820 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
821 
822 pragma solidity ^0.8.0;
823 
824 /**
825  * @title ERC721 token receiver interface
826  * @dev Interface for any contract that wants to support safeTransfers
827  * from ERC721 asset contracts.
828  */
829 interface IERC721Receiver {
830     /**
831      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
832      * by `operator` from `from`, this function is called.
833      *
834      * It must return its Solidity selector to confirm the token transfer.
835      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
836      *
837      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
838      */
839     function onERC721Received(
840         address operator,
841         address from,
842         uint256 tokenId,
843         bytes calldata data
844     ) external returns (bytes4);
845 }
846 
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 /**
854  * @dev Interface of the ERC165 standard, as defined in the
855  * https://eips.ethereum.org/EIPS/eip-165[EIP].
856  *
857  * Implementers can declare support of contract interfaces, which can then be
858  * queried by others ({ERC165Checker}).
859  *
860  * For an implementation, see {ERC165}.
861  */
862 interface IERC165 {
863     /**
864      * @dev Returns true if this contract implements the interface defined by
865      * `interfaceId`. See the corresponding
866      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
867      * to learn more about how these ids are created.
868      *
869      * This function call must use less than 30 000 gas.
870      */
871     function supportsInterface(bytes4 interfaceId) external view returns (bool);
872 }
873 
874 
875 
876 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
877 
878 pragma solidity ^0.8.0;
879 
880 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev Interface for the NFT Royalty Standard
886  */
887 interface IERC2981 is IERC165 {
888     /**
889      * @dev Called with the sale price to determine how much royalty is owed and to whom.
890      * @param tokenId - the NFT asset queried for royalty information
891      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
892      * @return receiver - address of who should be sent the royalty payment
893      * @return royaltyAmount - the royalty payment amount for `salePrice`
894      */
895     function royaltyInfo(uint256 tokenId, uint256 salePrice)
896     external
897     view
898     returns (address receiver, uint256 royaltyAmount);
899 }
900 
901 
902 
903 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
904 
905 pragma solidity ^0.8.0;
906 
907 /**
908  * @dev Implementation of the {IERC165} interface.
909  *
910  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
911  * for the additional interface id that will be supported. For example:
912  *
913  * ```solidity
914  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
915  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
916  * }
917  * ```
918  *
919  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
920  */
921 abstract contract ERC165 is IERC165 {
922     /**
923      * @dev See {IERC165-supportsInterface}.
924      */
925     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
926         return interfaceId == type(IERC165).interfaceId;
927     }
928 }
929 
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
933 
934 pragma solidity ^0.8.0;
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
1073 
1074 
1075 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1076 
1077 pragma solidity ^0.8.0;
1078 
1079 /**
1080  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1081  * @dev See https://eips.ethereum.org/EIPS/eip-721
1082  */
1083 interface IERC721Metadata is IERC721 {
1084     /**
1085      * @dev Returns the token collection name.
1086      */
1087     function name() external view returns (string memory);
1088 
1089     /**
1090      * @dev Returns the token collection symbol.
1091      */
1092     function symbol() external view returns (string memory);
1093 
1094     /**
1095      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1096      */
1097     function tokenURI(uint256 tokenId) external view returns (string memory);
1098 }
1099 
1100 
1101 
1102 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1103 
1104 pragma solidity ^0.8.0;
1105 
1106 /**
1107  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1108  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1109  * {ERC721Enumerable}.
1110  */
1111 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1112     using Address for address;
1113     using Strings for uint256;
1114 
1115     // Token name
1116     string private _name;
1117 
1118     // Token symbol
1119     string private _symbol;
1120 
1121     // Mapping from token ID to owner address
1122     mapping(uint256 => address) private _owners;
1123 
1124     // Mapping owner address to token count
1125     mapping(address => uint256) private _balances;
1126 
1127     // Mapping from token ID to approved address
1128     mapping(uint256 => address) private _tokenApprovals;
1129 
1130     // Mapping from owner to operator approvals
1131     mapping(address => mapping(address => bool)) private _operatorApprovals;
1132 
1133     /**
1134      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1135      */
1136     constructor(string memory name_, string memory symbol_) {
1137         _name = name_;
1138         _symbol = symbol_;
1139     }
1140 
1141     /**
1142      * @dev See {IERC165-supportsInterface}.
1143      */
1144     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1145         return
1146         interfaceId == type(IERC721).interfaceId ||
1147         interfaceId == type(IERC721Metadata).interfaceId ||
1148         super.supportsInterface(interfaceId);
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-balanceOf}.
1153      */
1154     function balanceOf(address owner) public view virtual override returns (uint256) {
1155         require(owner != address(0), "ERC721: balance query for the zero address");
1156         return _balances[owner];
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-ownerOf}.
1161      */
1162     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1163         address owner = _owners[tokenId];
1164         require(owner != address(0), "ERC721: owner query for nonexistent token");
1165         return owner;
1166     }
1167 
1168     /**
1169      * @dev See {IERC721Metadata-name}.
1170      */
1171     function name() public view virtual override returns (string memory) {
1172         return _name;
1173     }
1174 
1175     /**
1176      * @dev See {IERC721Metadata-symbol}.
1177      */
1178     function symbol() public view virtual override returns (string memory) {
1179         return _symbol;
1180     }
1181 
1182     /**
1183      * @dev See {IERC721Metadata-tokenURI}.
1184      */
1185     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1186         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1187 
1188         string memory baseURI = _baseURI();
1189         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1190     }
1191 
1192     /**
1193      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1194      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1195      * by default, can be overriden in child contracts.
1196      */
1197     function _baseURI() internal view virtual returns (string memory) {
1198         return "";
1199     }
1200 
1201     /**
1202      * @dev See {IERC721-approve}.
1203      */
1204     function approve(address to, uint256 tokenId) public virtual override {
1205         address owner = ERC721.ownerOf(tokenId);
1206         require(to != owner, "ERC721: approval to current owner");
1207 
1208         require(
1209             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1210             "ERC721: approve caller is not owner nor approved for all"
1211         );
1212 
1213         _approve(to, tokenId);
1214     }
1215 
1216     /**
1217      * @dev See {IERC721-getApproved}.
1218      */
1219     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1220         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1221 
1222         return _tokenApprovals[tokenId];
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-setApprovalForAll}.
1227      */
1228     function setApprovalForAll(address operator, bool approved) public virtual override {
1229         _setApprovalForAll(_msgSender(), operator, approved);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-isApprovedForAll}.
1234      */
1235     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1236         return _operatorApprovals[owner][operator];
1237     }
1238 
1239     /**
1240      * @dev See {IERC721-transferFrom}.
1241      */
1242     function transferFrom(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) public virtual override {
1247         //solhint-disable-next-line max-line-length
1248         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1249 
1250         _transfer(from, to, tokenId);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-safeTransferFrom}.
1255      */
1256     function safeTransferFrom(
1257         address from,
1258         address to,
1259         uint256 tokenId
1260     ) public virtual override {
1261         safeTransferFrom(from, to, tokenId, "");
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-safeTransferFrom}.
1266      */
1267     function safeTransferFrom(
1268         address from,
1269         address to,
1270         uint256 tokenId,
1271         bytes memory _data
1272     ) public virtual override {
1273         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1274         _safeTransfer(from, to, tokenId, _data);
1275     }
1276 
1277     /**
1278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1280      *
1281      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1282      *
1283      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1284      * implement alternative mechanisms to perform token transfer, such as signature-based.
1285      *
1286      * Requirements:
1287      *
1288      * - `from` cannot be the zero address.
1289      * - `to` cannot be the zero address.
1290      * - `tokenId` token must exist and be owned by `from`.
1291      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _safeTransfer(
1296         address from,
1297         address to,
1298         uint256 tokenId,
1299         bytes memory _data
1300     ) internal virtual {
1301         _transfer(from, to, tokenId);
1302         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1303     }
1304 
1305     /**
1306      * @dev Returns whether `tokenId` exists.
1307      *
1308      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1309      *
1310      * Tokens start existing when they are minted (`_mint`),
1311      * and stop existing when they are burned (`_burn`).
1312      */
1313     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1314         return _owners[tokenId] != address(0);
1315     }
1316 
1317     /**
1318      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1319      *
1320      * Requirements:
1321      *
1322      * - `tokenId` must exist.
1323      */
1324     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1325         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1326         address owner = ERC721.ownerOf(tokenId);
1327         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1328     }
1329 
1330     /**
1331      * @dev Safely mints `tokenId` and transfers it to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - `tokenId` must not exist.
1336      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _safeMint(address to, uint256 tokenId) internal virtual {
1341         _safeMint(to, tokenId, "");
1342     }
1343 
1344     /**
1345      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1346      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1347      */
1348     function _safeMint(
1349         address to,
1350         uint256 tokenId,
1351         bytes memory _data
1352     ) internal virtual {
1353         _mint(to, tokenId);
1354         require(
1355             _checkOnERC721Received(address(0), to, tokenId, _data),
1356             "ERC721: transfer to non ERC721Receiver implementer"
1357         );
1358     }
1359 
1360     /**
1361      * @dev Mints `tokenId` and transfers it to `to`.
1362      *
1363      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1364      *
1365      * Requirements:
1366      *
1367      * - `tokenId` must not exist.
1368      * - `to` cannot be the zero address.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function _mint(address to, uint256 tokenId) internal virtual {
1373         require(to != address(0), "ERC721: mint to the zero address");
1374         require(!_exists(tokenId), "ERC721: token already minted");
1375 
1376         _beforeTokenTransfer(address(0), to, tokenId);
1377 
1378         _balances[to] += 1;
1379         _owners[tokenId] = to;
1380 
1381         emit Transfer(address(0), to, tokenId);
1382     }
1383 
1384     /**
1385      * @dev Destroys `tokenId`.
1386      * The approval is cleared when the token is burned.
1387      *
1388      * Requirements:
1389      *
1390      * - `tokenId` must exist.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _burn(uint256 tokenId) internal virtual {
1395         address owner = ERC721.ownerOf(tokenId);
1396 
1397         _beforeTokenTransfer(owner, address(0), tokenId);
1398 
1399         // Clear approvals
1400         _approve(address(0), tokenId);
1401 
1402         _balances[owner] -= 1;
1403         delete _owners[tokenId];
1404 
1405         emit Transfer(owner, address(0), tokenId);
1406     }
1407 
1408     /**
1409      * @dev Transfers `tokenId` from `from` to `to`.
1410      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1411      *
1412      * Requirements:
1413      *
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must be owned by `from`.
1416      *
1417      * Emits a {Transfer} event.
1418      */
1419     function _transfer(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) internal virtual {
1424         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1425         require(to != address(0), "ERC721: transfer to the zero address");
1426 
1427         _beforeTokenTransfer(from, to, tokenId);
1428 
1429         // Clear approvals from the previous owner
1430         _approve(address(0), tokenId);
1431 
1432         _balances[from] -= 1;
1433         _balances[to] += 1;
1434         _owners[tokenId] = to;
1435 
1436         emit Transfer(from, to, tokenId);
1437     }
1438 
1439     /**
1440      * @dev Approve `to` to operate on `tokenId`
1441      *
1442      * Emits a {Approval} event.
1443      */
1444     function _approve(address to, uint256 tokenId) internal virtual {
1445         _tokenApprovals[tokenId] = to;
1446         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1447     }
1448 
1449     /**
1450      * @dev Approve `operator` to operate on all of `owner` tokens
1451      *
1452      * Emits a {ApprovalForAll} event.
1453      */
1454     function _setApprovalForAll(
1455         address owner,
1456         address operator,
1457         bool approved
1458     ) internal virtual {
1459         require(owner != operator, "ERC721: approve to caller");
1460         _operatorApprovals[owner][operator] = approved;
1461         emit ApprovalForAll(owner, operator, approved);
1462     }
1463 
1464     /**
1465      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1466      * The call is not executed if the target address is not a contract.
1467      *
1468      * @param from address representing the previous owner of the given token ID
1469      * @param to target address that will receive the tokens
1470      * @param tokenId uint256 ID of the token to be transferred
1471      * @param _data bytes optional data to send along with the call
1472      * @return bool whether the call correctly returned the expected magic value
1473      */
1474     function _checkOnERC721Received(
1475         address from,
1476         address to,
1477         uint256 tokenId,
1478         bytes memory _data
1479     ) private returns (bool) {
1480         if (to.isContract()) {
1481             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1482                 return retval == IERC721Receiver.onERC721Received.selector;
1483             } catch (bytes memory reason) {
1484                 if (reason.length == 0) {
1485                     revert("ERC721: transfer to non ERC721Receiver implementer");
1486                 } else {
1487                     assembly {
1488                         revert(add(32, reason), mload(reason))
1489                     }
1490                 }
1491             }
1492         } else {
1493             return true;
1494         }
1495     }
1496 
1497     /**
1498      * @dev Hook that is called before any token transfer. This includes minting
1499      * and burning.
1500      *
1501      * Calling conditions:
1502      *
1503      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1504      * transferred to `to`.
1505      * - When `from` is zero, `tokenId` will be minted for `to`.
1506      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1507      * - `from` and `to` are never both zero.
1508      *
1509      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1510      */
1511     function _beforeTokenTransfer(
1512         address from,
1513         address to,
1514         uint256 tokenId
1515     ) internal virtual {}
1516 }
1517 
1518 
1519 //SPDX-License-Identifier: MIT
1520 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1521 
1522 pragma solidity ^0.8.0;
1523 
1524 contract AlienDood is ERC721, IERC2981, Ownable, ReentrancyGuard {
1525     using Counters for Counters.Counter;
1526     using Strings for uint256;
1527 
1528     Counters.Counter private tokenCounter;
1529 
1530     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1531     bool private isOpenSeaProxyActive = true;
1532 
1533     string baseURI;
1534     string public UnrevealedURI;
1535 
1536     uint256 public constant MAX_SUPPLY = 3333;
1537     uint256 public constant MAX_MINTS_PER_TX = 5;
1538     uint256 public constant PUBLIC_MINT_PRICE = 0.025 ether;
1539     uint256 public constant MAX_FREE_MINTS = 888;
1540 
1541     bool public isPublicSaleActive = false;
1542     bool public isRevealed = false;
1543 
1544     // ============ ACCESS CHECKS ============
1545 
1546     modifier publicSaleActive() {
1547         require(isPublicSaleActive, "Public sale has not started");
1548         _;
1549     }
1550 
1551     modifier maxMintsPerTX(uint256 numberOfTokens) {
1552         require(
1553             numberOfTokens <= MAX_MINTS_PER_TX,
1554             "Reached max mints per transaction"
1555         );
1556         _;
1557     }
1558 
1559     modifier canMintNFTs(uint256 numberOfTokens) {
1560         require(
1561             tokenCounter.current() + numberOfTokens <=
1562             MAX_SUPPLY,
1563             "Sold out"
1564         );
1565         _;
1566     }
1567 
1568     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1569         if (tokenCounter.current() > MAX_FREE_MINTS) {
1570             require(
1571                 (price * numberOfTokens) == msg.value,
1572                 "Incorrect ETH value sent"
1573             );
1574         }
1575         _;
1576     }
1577 
1578     constructor(
1579         string memory _name,
1580         string memory _symbol,
1581         string memory _initBaseURI,
1582         string memory _initUnrevealedUri
1583     ) ERC721(_name, _symbol) {
1584         setBaseURI(_initBaseURI);
1585         setUnrevealedURI(_initUnrevealedUri);
1586     }
1587 
1588     // ============ MINTING FUNCTION ============
1589 
1590     function mint(uint256 numberOfTokens)
1591     external
1592     payable
1593     nonReentrant
1594     isCorrectPayment(PUBLIC_MINT_PRICE, numberOfTokens)
1595     publicSaleActive
1596     canMintNFTs(numberOfTokens)
1597     maxMintsPerTX(numberOfTokens) {
1598         for (uint256 i = 0; i < numberOfTokens; i++) {
1599             _safeMint(msg.sender, nextTokenId());
1600         }
1601     }
1602 
1603     // ============ INTERNAL FUNCTION  ============
1604 
1605     function getBaseURI() internal view virtual returns (string memory) {
1606         return baseURI;
1607     }
1608 
1609     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1610 
1611 
1612     function getLastTokenId() external view returns (uint256) {
1613         return tokenCounter.current();
1614     }
1615 
1616     function totalSupply() external view returns (uint256) {
1617         return tokenCounter.current();
1618     }
1619 
1620     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1621 
1622     // function to disable gasless listings for security in case
1623     // opensea ever shuts down or is compromised
1624     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive) external onlyOwner {
1625         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1626     }
1627 
1628     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1629         baseURI = _newBaseURI;
1630     }
1631 
1632     function setUnrevealedURI(string memory _UnrevealedURI) public onlyOwner {
1633         UnrevealedURI = _UnrevealedURI;
1634     }
1635 
1636     function reveal(bool _reveal) public onlyOwner {
1637         isRevealed = _reveal;
1638     }
1639 
1640     function setIsPublicSaleActive(bool _isPublicSaleActive) external onlyOwner {
1641         isPublicSaleActive = _isPublicSaleActive;
1642     }
1643 
1644     function withdraw() public onlyOwner {
1645         uint256 balance = address(this).balance;
1646         payable(msg.sender).transfer(balance);
1647     }
1648 
1649     function withdrawTokens(IERC20 token) public onlyOwner {
1650         uint256 balance = token.balanceOf(address(this));
1651         token.transfer(msg.sender, balance);
1652     }
1653 
1654     // ============ SUPPORTING FUNCTIONS ============
1655 
1656     function nextTokenId() private returns (uint256) {
1657         tokenCounter.increment();
1658         return tokenCounter.current();
1659     }
1660 
1661     // ============ FUNCTION OVERRIDES ============
1662 
1663     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool){
1664         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1665     }
1666 
1667     /**
1668      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1669      */
1670     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1671         // Get a reference to OpenSea's proxy registry contract by instantiating
1672         // the contract using the already existing address.
1673         ProxyRegistry proxyRegistry = ProxyRegistry(openSeaProxyRegistryAddress);
1674 
1675         if (isOpenSeaProxyActive && address(proxyRegistry.proxies(owner)) == operator) {
1676             return true;
1677         }
1678 
1679         return super.isApprovedForAll(owner, operator);
1680     }
1681 
1682     /**
1683      * @dev See {IERC721Metadata-tokenURI}.
1684      */
1685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1686         require(_exists(tokenId), "Token does not exist");
1687 
1688         if (isRevealed == false) {
1689             return UnrevealedURI;
1690         }
1691 
1692         return string(abi.encodePacked(baseURI, "/", tokenId.toString(), ".json"));
1693     }
1694 
1695     /**
1696    * @dev See {IERC165-royaltyInfo}.
1697      */
1698     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1699     external
1700     view
1701     override
1702     returns (address receiver, uint256 royaltyAmount) {
1703         require(_exists(tokenId), "Token does not exist");
1704         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1705     }
1706 
1707 }
1708 
1709 // These contract definitions are used to create a reference to the OpenSea
1710 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1711 contract OwnableDelegateProxy {
1712 
1713 }
1714 
1715 contract ProxyRegistry {
1716     mapping(address => OwnableDelegateProxy) public proxies;
1717 }