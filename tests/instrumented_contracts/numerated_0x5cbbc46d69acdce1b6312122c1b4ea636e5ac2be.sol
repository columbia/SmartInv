1 //██████╗░░█████╗░██╗░░██╗███████╗██████╗░  ██████╗░░█████╗░███╗░░██╗░█████╗░███╗░░██╗░█████╗░░██████╗
2 //██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗  ██╔══██╗██╔══██╗████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
3 //██████╦╝███████║█████═╝░█████╗░░██║░░██║  ██████╦╝███████║██╔██╗██║███████║██╔██╗██║███████║╚█████╗░
4 //██╔══██╗██╔══██║██╔═██╗░██╔══╝░░██║░░██║  ██╔══██╗██╔══██║██║╚████║██╔══██║██║╚████║██╔══██║░╚═══██╗
5 //██████╦╝██║░░██║██║░╚██╗███████╗██████╔╝  ██████╦╝██║░░██║██║░╚███║██║░░██║██║░╚███║██║░░██║██████╔╝
6 //╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═════╝░
7 //
8 // 
9 // National Banana Day & 420 have landed on the same day, and the pairing is exquisite.
10 // Yes, this is a real day, and we happen to be particularly fond of the whacky yellow foodstuff (and the green stuff).
11 // We decided to create this free mint NFT collection to bring some fun and laughs to the NFT community on this special day <3
12 // -KevNFriends Team 
13 // https://discord.gg/kevnfriends
14 
15 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
16 
17 
18 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 // CAUTION
23 // This version of SafeMath should only be used with Solidity 0.8 or later,
24 // because it relies on the compiler's built in overflow checks.
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations.
28  *
29  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
30  * now has built in overflow checking.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             uint256 c = a + b;
41             if (c < a) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b > a) return (false, 0);
54             return (true, a - b);
55         }
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66             // benefit is lost if 'b' is also tested.
67             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68             if (a == 0) return (true, 0);
69             uint256 c = a * b;
70             if (c / a != b) return (false, 0);
71             return (true, c);
72         }
73     }
74 
75     /**
76      * @dev Returns the division of two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a / b);
84         }
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a % b);
96         }
97     }
98 
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a + b;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a - b;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      *
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a * b;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers, reverting on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator.
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a / b;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * reverting when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a % b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * CAUTION: This function is deprecated because it requires allocating memory for the error
176      * message unnecessarily. For custom revert reasons use {trySub}.
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a / b;
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting with custom message when dividing by zero.
221      *
222      * CAUTION: This function is deprecated because it requires allocating memory for the error
223      * message unnecessarily. For custom revert reasons use {tryMod}.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a % b;
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Counters.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @title Counters
254  * @author Matt Condon (@shrugs)
255  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
256  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
257  *
258  * Include with `using Counters for Counters.Counter;`
259  */
260 library Counters {
261     struct Counter {
262         // This variable should never be directly accessed by users of the library: interactions must be restricted to
263         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
264         // this feature: see https://github.com/ethereum/solidity/issues/4637
265         uint256 _value; // default: 0
266     }
267 
268     function current(Counter storage counter) internal view returns (uint256) {
269         return counter._value;
270     }
271 
272     function increment(Counter storage counter) internal {
273         unchecked {
274             counter._value += 1;
275         }
276     }
277 
278     function decrement(Counter storage counter) internal {
279         uint256 value = counter._value;
280         require(value > 0, "Counter: decrement overflow");
281         unchecked {
282             counter._value = value - 1;
283         }
284     }
285 
286     function reset(Counter storage counter) internal {
287         counter._value = 0;
288     }
289 }
290 
291 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
295 
296 pragma solidity ^0.8.0;
297 
298 /**
299  * @dev Contract module that helps prevent reentrant calls to a function.
300  *
301  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
302  * available, which can be applied to functions to make sure there are no nested
303  * (reentrant) calls to them.
304  *
305  * Note that because there is a single `nonReentrant` guard, functions marked as
306  * `nonReentrant` may not call one another. This can be worked around by making
307  * those functions `private`, and then adding `external` `nonReentrant` entry
308  * points to them.
309  *
310  * TIP: If you would like to learn more about reentrancy and alternative ways
311  * to protect against it, check out our blog post
312  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
313  */
314 abstract contract ReentrancyGuard {
315     // Booleans are more expensive than uint256 or any type that takes up a full
316     // word because each write operation emits an extra SLOAD to first read the
317     // slot's contents, replace the bits taken up by the boolean, and then write
318     // back. This is the compiler's defense against contract upgrades and
319     // pointer aliasing, and it cannot be disabled.
320 
321     // The values being non-zero value makes deployment a bit more expensive,
322     // but in exchange the refund on every call to nonReentrant will be lower in
323     // amount. Since refunds are capped to a percentage of the total
324     // transaction's gas, it is best to keep them low in cases like this one, to
325     // increase the likelihood of the full refund coming into effect.
326     uint256 private constant _NOT_ENTERED = 1;
327     uint256 private constant _ENTERED = 2;
328 
329     uint256 private _status;
330 
331     constructor() {
332         _status = _NOT_ENTERED;
333     }
334 
335     /**
336      * @dev Prevents a contract from calling itself, directly or indirectly.
337      * Calling a `nonReentrant` function from another `nonReentrant`
338      * function is not supported. It is possible to prevent this from happening
339      * by making the `nonReentrant` function external, and making it call a
340      * `private` function that does the actual work.
341      */
342     modifier nonReentrant() {
343         // On the first call to nonReentrant, _notEntered will be true
344         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
345 
346         // Any calls to nonReentrant after this point will fail
347         _status = _ENTERED;
348 
349         _;
350 
351         // By storing the original value once again, a refund is triggered (see
352         // https://eips.ethereum.org/EIPS/eip-2200)
353         _status = _NOT_ENTERED;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @dev Interface of the ERC20 standard as defined in the EIP.
366  */
367 interface IERC20 {
368     /**
369      * @dev Returns the amount of tokens in existence.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     /**
374      * @dev Returns the amount of tokens owned by `account`.
375      */
376     function balanceOf(address account) external view returns (uint256);
377 
378     /**
379      * @dev Moves `amount` tokens from the caller's account to `recipient`.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transfer(address recipient, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender) external view returns (uint256);
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * IMPORTANT: Beware that changing an allowance with this method brings the risk
402      * that someone may use both the old and the new allowance by unfortunate
403      * transaction ordering. One possible solution to mitigate this race
404      * condition is to first reduce the spender's allowance to 0 and set the
405      * desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address spender, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Moves `amount` tokens from `sender` to `recipient` using the
414      * allowance mechanism. `amount` is then deducted from the caller's
415      * allowance.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(
422         address sender,
423         address recipient,
424         uint256 amount
425     ) external returns (bool);
426 
427     /**
428      * @dev Emitted when `value` tokens are moved from one account (`from`) to
429      * another (`to`).
430      *
431      * Note that `value` may be zero.
432      */
433     event Transfer(address indexed from, address indexed to, uint256 value);
434 
435     /**
436      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
437      * a call to {approve}. `value` is the new allowance.
438      */
439     event Approval(address indexed owner, address indexed spender, uint256 value);
440 }
441 
442 // File: @openzeppelin/contracts/interfaces/IERC20.sol
443 
444 
445 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
446 
447 pragma solidity ^0.8.0;
448 
449 
450 // File: @openzeppelin/contracts/utils/Strings.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev String operations.
459  */
460 library Strings {
461     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
462 
463     /**
464      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
465      */
466     function toString(uint256 value) internal pure returns (string memory) {
467         // Inspired by OraclizeAPI's implementation - MIT licence
468         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
469 
470         if (value == 0) {
471             return "0";
472         }
473         uint256 temp = value;
474         uint256 digits;
475         while (temp != 0) {
476             digits++;
477             temp /= 10;
478         }
479         bytes memory buffer = new bytes(digits);
480         while (value != 0) {
481             digits -= 1;
482             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
483             value /= 10;
484         }
485         return string(buffer);
486     }
487 
488     /**
489      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
490      */
491     function toHexString(uint256 value) internal pure returns (string memory) {
492         if (value == 0) {
493             return "0x00";
494         }
495         uint256 temp = value;
496         uint256 length = 0;
497         while (temp != 0) {
498             length++;
499             temp >>= 8;
500         }
501         return toHexString(value, length);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
506      */
507     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
508         bytes memory buffer = new bytes(2 * length + 2);
509         buffer[0] = "0";
510         buffer[1] = "x";
511         for (uint256 i = 2 * length + 1; i > 1; --i) {
512             buffer[i] = _HEX_SYMBOLS[value & 0xf];
513             value >>= 4;
514         }
515         require(value == 0, "Strings: hex length insufficient");
516         return string(buffer);
517     }
518 }
519 
520 // File: @openzeppelin/contracts/utils/Context.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Provides information about the current execution context, including the
529  * sender of the transaction and its data. While these are generally available
530  * via msg.sender and msg.data, they should not be accessed in such a direct
531  * manner, since when dealing with meta-transactions the account sending and
532  * paying for execution may not be the actual sender (as far as an application
533  * is concerned).
534  *
535  * This contract is only required for intermediate, library-like contracts.
536  */
537 abstract contract Context {
538     function _msgSender() internal view virtual returns (address) {
539         return msg.sender;
540     }
541 
542     function _msgData() internal view virtual returns (bytes calldata) {
543         return msg.data;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/access/Ownable.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 abstract contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor() {
576         _transferOwnership(_msgSender());
577     }
578 
579     /**
580      * @dev Returns the address of the current owner.
581      */
582     function owner() public view virtual returns (address) {
583         return _owner;
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         require(owner() == _msgSender(), "Ownable: caller is not the owner");
591         _;
592     }
593 
594     /**
595      * @dev Leaves the contract without owner. It will not be possible to call
596      * `onlyOwner` functions anymore. Can only be called by the current owner.
597      *
598      * NOTE: Renouncing ownership will leave the contract without an owner,
599      * thereby removing any functionality that is only available to the owner.
600      */
601     function renounceOwnership() public virtual onlyOwner {
602         _transferOwnership(address(0));
603     }
604 
605     /**
606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
607      * Can only be called by the current owner.
608      */
609     function transferOwnership(address newOwner) public virtual onlyOwner {
610         require(newOwner != address(0), "Ownable: new owner is the zero address");
611         _transferOwnership(newOwner);
612     }
613 
614     /**
615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
616      * Internal function without access restriction.
617      */
618     function _transferOwnership(address newOwner) internal virtual {
619         address oldOwner = _owner;
620         _owner = newOwner;
621         emit OwnershipTransferred(oldOwner, newOwner);
622     }
623 }
624 
625 // File: @openzeppelin/contracts/utils/Address.sol
626 
627 
628 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 /**
633  * @dev Collection of functions related to the address type
634  */
635 library Address {
636     /**
637      * @dev Returns true if `account` is a contract.
638      *
639      * [IMPORTANT]
640      * ====
641      * It is unsafe to assume that an address for which this function returns
642      * false is an externally-owned account (EOA) and not a contract.
643      *
644      * Among others, `isContract` will return false for the following
645      * types of addresses:
646      *
647      *  - an externally-owned account
648      *  - a contract in construction
649      *  - an address where a contract will be created
650      *  - an address where a contract lived, but was destroyed
651      * ====
652      */
653     function isContract(address account) internal view returns (bool) {
654         // This method relies on extcodesize, which returns 0 for contracts in
655         // construction, since the code is only stored at the end of the
656         // constructor execution.
657 
658         uint256 size;
659         assembly {
660             size := extcodesize(account)
661         }
662         return size > 0;
663     }
664 
665     /**
666      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
667      * `recipient`, forwarding all available gas and reverting on errors.
668      *
669      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
670      * of certain opcodes, possibly making contracts go over the 2300 gas limit
671      * imposed by `transfer`, making them unable to receive funds via
672      * `transfer`. {sendValue} removes this limitation.
673      *
674      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
675      *
676      * IMPORTANT: because control is transferred to `recipient`, care must be
677      * taken to not create reentrancy vulnerabilities. Consider using
678      * {ReentrancyGuard} or the
679      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
680      */
681     function sendValue(address payable recipient, uint256 amount) internal {
682         require(address(this).balance >= amount, "Address: insufficient balance");
683 
684         (bool success, ) = recipient.call{value: amount}("");
685         require(success, "Address: unable to send value, recipient may have reverted");
686     }
687 
688     /**
689      * @dev Performs a Solidity function call using a low level `call`. A
690      * plain `call` is an unsafe replacement for a function call: use this
691      * function instead.
692      *
693      * If `target` reverts with a revert reason, it is bubbled up by this
694      * function (like regular Solidity function calls).
695      *
696      * Returns the raw returned data. To convert to the expected return value,
697      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
698      *
699      * Requirements:
700      *
701      * - `target` must be a contract.
702      * - calling `target` with `data` must not revert.
703      *
704      * _Available since v3.1._
705      */
706     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
707         return functionCall(target, data, "Address: low-level call failed");
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
712      * `errorMessage` as a fallback revert reason when `target` reverts.
713      *
714      * _Available since v3.1._
715      */
716     function functionCall(
717         address target,
718         bytes memory data,
719         string memory errorMessage
720     ) internal returns (bytes memory) {
721         return functionCallWithValue(target, data, 0, errorMessage);
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
726      * but also transferring `value` wei to `target`.
727      *
728      * Requirements:
729      *
730      * - the calling contract must have an ETH balance of at least `value`.
731      * - the called Solidity function must be `payable`.
732      *
733      * _Available since v3.1._
734      */
735     function functionCallWithValue(
736         address target,
737         bytes memory data,
738         uint256 value
739     ) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
745      * with `errorMessage` as a fallback revert reason when `target` reverts.
746      *
747      * _Available since v3.1._
748      */
749     function functionCallWithValue(
750         address target,
751         bytes memory data,
752         uint256 value,
753         string memory errorMessage
754     ) internal returns (bytes memory) {
755         require(address(this).balance >= value, "Address: insufficient balance for call");
756         require(isContract(target), "Address: call to non-contract");
757 
758         (bool success, bytes memory returndata) = target.call{value: value}(data);
759         return verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
769         return functionStaticCall(target, data, "Address: low-level static call failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(
779         address target,
780         bytes memory data,
781         string memory errorMessage
782     ) internal view returns (bytes memory) {
783         require(isContract(target), "Address: static call to non-contract");
784 
785         (bool success, bytes memory returndata) = target.staticcall(data);
786         return verifyCallResult(success, returndata, errorMessage);
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
791      * but performing a delegate call.
792      *
793      * _Available since v3.4._
794      */
795     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
796         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
801      * but performing a delegate call.
802      *
803      * _Available since v3.4._
804      */
805     function functionDelegateCall(
806         address target,
807         bytes memory data,
808         string memory errorMessage
809     ) internal returns (bytes memory) {
810         require(isContract(target), "Address: delegate call to non-contract");
811 
812         (bool success, bytes memory returndata) = target.delegatecall(data);
813         return verifyCallResult(success, returndata, errorMessage);
814     }
815 
816     /**
817      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
818      * revert reason using the provided one.
819      *
820      * _Available since v4.3._
821      */
822     function verifyCallResult(
823         bool success,
824         bytes memory returndata,
825         string memory errorMessage
826     ) internal pure returns (bytes memory) {
827         if (success) {
828             return returndata;
829         } else {
830             // Look for revert reason and bubble it up if present
831             if (returndata.length > 0) {
832                 // The easiest way to bubble the revert reason is using memory via assembly
833 
834                 assembly {
835                     let returndata_size := mload(returndata)
836                     revert(add(32, returndata), returndata_size)
837                 }
838             } else {
839                 revert(errorMessage);
840             }
841         }
842     }
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
846 
847 
848 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 /**
853  * @title ERC721 token receiver interface
854  * @dev Interface for any contract that wants to support safeTransfers
855  * from ERC721 asset contracts.
856  */
857 interface IERC721Receiver {
858     /**
859      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
860      * by `operator` from `from`, this function is called.
861      *
862      * It must return its Solidity selector to confirm the token transfer.
863      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
864      *
865      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
866      */
867     function onERC721Received(
868         address operator,
869         address from,
870         uint256 tokenId,
871         bytes calldata data
872     ) external returns (bytes4);
873 }
874 
875 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
876 
877 
878 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 /**
883  * @dev Interface of the ERC165 standard, as defined in the
884  * https://eips.ethereum.org/EIPS/eip-165[EIP].
885  *
886  * Implementers can declare support of contract interfaces, which can then be
887  * queried by others ({ERC165Checker}).
888  *
889  * For an implementation, see {ERC165}.
890  */
891 interface IERC165 {
892     /**
893      * @dev Returns true if this contract implements the interface defined by
894      * `interfaceId`. See the corresponding
895      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
896      * to learn more about how these ids are created.
897      *
898      * This function call must use less than 30 000 gas.
899      */
900     function supportsInterface(bytes4 interfaceId) external view returns (bool);
901 }
902 
903 // File: @openzeppelin/contracts/interfaces/IERC165.sol
904 
905 
906 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
907 
908 pragma solidity ^0.8.0;
909 
910 
911 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
912 
913 
914 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
915 
916 pragma solidity ^0.8.0;
917 
918 
919 /**
920  * @dev Interface for the NFT Royalty Standard
921  */
922 interface IERC2981 is IERC165 {
923     /**
924      * @dev Called with the sale price to determine how much royalty is owed and to whom.
925      * @param tokenId - the NFT asset queried for royalty information
926      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
927      * @return receiver - address of who should be sent the royalty payment
928      * @return royaltyAmount - the royalty payment amount for `salePrice`
929      */
930     function royaltyInfo(uint256 tokenId, uint256 salePrice)
931         external
932         view
933         returns (address receiver, uint256 royaltyAmount);
934 }
935 
936 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
937 
938 
939 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
940 
941 pragma solidity ^0.8.0;
942 
943 
944 /**
945  * @dev Implementation of the {IERC165} interface.
946  *
947  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
948  * for the additional interface id that will be supported. For example:
949  *
950  * ```solidity
951  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
952  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
953  * }
954  * ```
955  *
956  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
957  */
958 abstract contract ERC165 is IERC165 {
959     /**
960      * @dev See {IERC165-supportsInterface}.
961      */
962     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963         return interfaceId == type(IERC165).interfaceId;
964     }
965 }
966 
967 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
968 
969 
970 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
971 
972 pragma solidity ^0.8.0;
973 
974 
975 /**
976  * @dev Required interface of an ERC721 compliant contract.
977  */
978 interface IERC721 is IERC165 {
979     /**
980      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
981      */
982     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
983 
984     /**
985      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
986      */
987     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
988 
989     /**
990      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
991      */
992     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
993 
994     /**
995      * @dev Returns the number of tokens in ``owner``'s account.
996      */
997     function balanceOf(address owner) external view returns (uint256 balance);
998 
999     /**
1000      * @dev Returns the owner of the `tokenId` token.
1001      *
1002      * Requirements:
1003      *
1004      * - `tokenId` must exist.
1005      */
1006     function ownerOf(uint256 tokenId) external view returns (address owner);
1007 
1008     /**
1009      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1010      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1011      *
1012      * Requirements:
1013      *
1014      * - `from` cannot be the zero address.
1015      * - `to` cannot be the zero address.
1016      * - `tokenId` token must exist and be owned by `from`.
1017      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1018      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId
1026     ) external;
1027 
1028     /**
1029      * @dev Transfers `tokenId` token from `from` to `to`.
1030      *
1031      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must be owned by `from`.
1038      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1039      *
1040      * Emits a {Transfer} event.
1041      */
1042     function transferFrom(
1043         address from,
1044         address to,
1045         uint256 tokenId
1046     ) external;
1047 
1048     /**
1049      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1050      * The approval is cleared when the token is transferred.
1051      *
1052      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1053      *
1054      * Requirements:
1055      *
1056      * - The caller must own the token or be an approved operator.
1057      * - `tokenId` must exist.
1058      *
1059      * Emits an {Approval} event.
1060      */
1061     function approve(address to, uint256 tokenId) external;
1062 
1063     /**
1064      * @dev Returns the account approved for `tokenId` token.
1065      *
1066      * Requirements:
1067      *
1068      * - `tokenId` must exist.
1069      */
1070     function getApproved(uint256 tokenId) external view returns (address operator);
1071 
1072     /**
1073      * @dev Approve or remove `operator` as an operator for the caller.
1074      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1075      *
1076      * Requirements:
1077      *
1078      * - The `operator` cannot be the caller.
1079      *
1080      * Emits an {ApprovalForAll} event.
1081      */
1082     function setApprovalForAll(address operator, bool _approved) external;
1083 
1084     /**
1085      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1086      *
1087      * See {setApprovalForAll}
1088      */
1089     function isApprovedForAll(address owner, address operator) external view returns (bool);
1090 
1091     /**
1092      * @dev Safely transfers `tokenId` token from `from` to `to`.
1093      *
1094      * Requirements:
1095      *
1096      * - `from` cannot be the zero address.
1097      * - `to` cannot be the zero address.
1098      * - `tokenId` token must exist and be owned by `from`.
1099      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function safeTransferFrom(
1105         address from,
1106         address to,
1107         uint256 tokenId,
1108         bytes calldata data
1109     ) external;
1110 }
1111 
1112 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1113 
1114 
1115 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1116 
1117 pragma solidity ^0.8.0;
1118 
1119 
1120 /**
1121  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1122  * @dev See https://eips.ethereum.org/EIPS/eip-721
1123  */
1124 interface IERC721Enumerable is IERC721 {
1125     /**
1126      * @dev Returns the total amount of tokens stored by the contract.
1127      */
1128     function totalSupply() external view returns (uint256);
1129 
1130     /**
1131      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1132      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1133      */
1134     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1135 
1136     /**
1137      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1138      * Use along with {totalSupply} to enumerate all tokens.
1139      */
1140     function tokenByIndex(uint256 index) external view returns (uint256);
1141 }
1142 
1143 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1144 
1145 
1146 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 /**
1152  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1153  * @dev See https://eips.ethereum.org/EIPS/eip-721
1154  */
1155 interface IERC721Metadata is IERC721 {
1156     /**
1157      * @dev Returns the token collection name.
1158      */
1159     function name() external view returns (string memory);
1160 
1161     /**
1162      * @dev Returns the token collection symbol.
1163      */
1164     function symbol() external view returns (string memory);
1165 
1166     /**
1167      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1168      */
1169     function tokenURI(uint256 tokenId) external view returns (string memory);
1170 }
1171 
1172 // File: contracts/ERC721A.sol
1173 
1174 
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 
1185 
1186 /**
1187  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1188  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1189  *
1190  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1191  *
1192  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1193  *
1194  * Does not support burning tokens to address(0).
1195  */
1196 contract ERC721A is
1197   Context,
1198   ERC165,
1199   IERC721,
1200   IERC721Metadata,
1201   IERC721Enumerable
1202 {
1203   using Address for address;
1204   using Strings for uint256;
1205 
1206   struct TokenOwnership {
1207     address addr;
1208     uint64 startTimestamp;
1209   }
1210 
1211   struct AddressData {
1212     uint128 balance;
1213     uint128 numberMinted;
1214   }
1215 
1216   uint256 private currentIndex = 0;
1217 
1218   uint256 internal immutable collectionSize;
1219   uint256 internal immutable maxBatchSize;
1220 
1221   // Token name
1222   string private _name;
1223 
1224   // Token symbol
1225   string private _symbol;
1226 
1227   // Mapping from token ID to ownership details
1228   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1229   mapping(uint256 => TokenOwnership) private _ownerships;
1230 
1231   // Mapping owner address to address data
1232   mapping(address => AddressData) private _addressData;
1233 
1234   // Mapping from token ID to approved address
1235   mapping(uint256 => address) private _tokenApprovals;
1236 
1237   // Mapping from owner to operator approvals
1238   mapping(address => mapping(address => bool)) private _operatorApprovals;
1239 
1240   /**
1241    * @dev
1242    * `maxBatchSize` refers to how much a minter can mint at a time.
1243    * `collectionSize_` refers to how many tokens are in the collection.
1244    */
1245   constructor(
1246     string memory name_,
1247     string memory symbol_,
1248     uint256 maxBatchSize_,
1249     uint256 collectionSize_
1250   ) {
1251     require(
1252       collectionSize_ > 0,
1253       "ERC721A: collection must have a nonzero supply"
1254     );
1255     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1256     _name = name_;
1257     _symbol = symbol_;
1258     maxBatchSize = maxBatchSize_;
1259     collectionSize = collectionSize_;
1260   }
1261 
1262   /**
1263    * @dev See {IERC721Enumerable-totalSupply}.
1264    */
1265   function totalSupply() public view override returns (uint256) {
1266     return currentIndex;
1267   }
1268 
1269   /**
1270    * @dev See {IERC721Enumerable-tokenByIndex}.
1271    */
1272   function tokenByIndex(uint256 index) public view override returns (uint256) {
1273     require(index < totalSupply(), "ERC721A: global index out of bounds");
1274     return index;
1275   }
1276 
1277   /**
1278    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1279    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1280    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1281    */
1282   function tokenOfOwnerByIndex(address owner, uint256 index)
1283     public
1284     view
1285     override
1286     returns (uint256)
1287   {
1288     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1289     uint256 numMintedSoFar = totalSupply();
1290     uint256 tokenIdsIdx = 0;
1291     address currOwnershipAddr = address(0);
1292     for (uint256 i = 0; i < numMintedSoFar; i++) {
1293       TokenOwnership memory ownership = _ownerships[i];
1294       if (ownership.addr != address(0)) {
1295         currOwnershipAddr = ownership.addr;
1296       }
1297       if (currOwnershipAddr == owner) {
1298         if (tokenIdsIdx == index) {
1299           return i;
1300         }
1301         tokenIdsIdx++;
1302       }
1303     }
1304     revert("ERC721A: unable to get token of owner by index");
1305   }
1306 
1307   /**
1308    * @dev See {IERC165-supportsInterface}.
1309    */
1310   function supportsInterface(bytes4 interfaceId)
1311     public
1312     view
1313     virtual
1314     override(ERC165, IERC165)
1315     returns (bool)
1316   {
1317     return
1318       interfaceId == type(IERC721).interfaceId ||
1319       interfaceId == type(IERC721Metadata).interfaceId ||
1320       interfaceId == type(IERC721Enumerable).interfaceId ||
1321       super.supportsInterface(interfaceId);
1322   }
1323 
1324   /**
1325    * @dev See {IERC721-balanceOf}.
1326    */
1327   function balanceOf(address owner) public view override returns (uint256) {
1328     require(owner != address(0), "ERC721A: balance query for the zero address");
1329     return uint256(_addressData[owner].balance);
1330   }
1331 
1332   function _numberMinted(address owner) internal view returns (uint256) {
1333     require(
1334       owner != address(0),
1335       "ERC721A: number minted query for the zero address"
1336     );
1337     return uint256(_addressData[owner].numberMinted);
1338   }
1339 
1340   function ownershipOf(uint256 tokenId)
1341     internal
1342     view
1343     returns (TokenOwnership memory)
1344   {
1345     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1346 
1347     uint256 lowestTokenToCheck;
1348     if (tokenId >= maxBatchSize) {
1349       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1350     }
1351 
1352     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1353       TokenOwnership memory ownership = _ownerships[curr];
1354       if (ownership.addr != address(0)) {
1355         return ownership;
1356       }
1357     }
1358 
1359     revert("ERC721A: unable to determine the owner of token");
1360   }
1361 
1362   /**
1363    * @dev See {IERC721-ownerOf}.
1364    */
1365   function ownerOf(uint256 tokenId) public view override returns (address) {
1366     return ownershipOf(tokenId).addr;
1367   }
1368 
1369   /**
1370    * @dev See {IERC721Metadata-name}.
1371    */
1372   function name() public view virtual override returns (string memory) {
1373     return _name;
1374   }
1375 
1376   /**
1377    * @dev See {IERC721Metadata-symbol}.
1378    */
1379   function symbol() public view virtual override returns (string memory) {
1380     return _symbol;
1381   }
1382 
1383   /**
1384    * @dev See {IERC721Metadata-tokenURI}.
1385    */
1386   function tokenURI(uint256 tokenId)
1387     public
1388     view
1389     virtual
1390     override
1391     returns (string memory)
1392   {
1393     require(
1394       _exists(tokenId),
1395       "ERC721Metadata: URI query for nonexistent token"
1396     );
1397 
1398     string memory baseURI = _baseURI();
1399     return
1400       bytes(baseURI).length > 0
1401         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1402         : "";
1403   }
1404 
1405   /**
1406    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1407    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1408    * by default, can be overriden in child contracts.
1409    */
1410   function _baseURI() internal view virtual returns (string memory) {
1411     return "";
1412   }
1413 
1414   /**
1415    * @dev See {IERC721-approve}.
1416    */
1417   function approve(address to, uint256 tokenId) public override {
1418     address owner = ERC721A.ownerOf(tokenId);
1419     require(to != owner, "ERC721A: approval to current owner");
1420 
1421     require(
1422       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1423       "ERC721A: approve caller is not owner nor approved for all"
1424     );
1425 
1426     _approve(to, tokenId, owner);
1427   }
1428 
1429   /**
1430    * @dev See {IERC721-getApproved}.
1431    */
1432   function getApproved(uint256 tokenId) public view override returns (address) {
1433     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1434 
1435     return _tokenApprovals[tokenId];
1436   }
1437 
1438   /**
1439    * @dev See {IERC721-setApprovalForAll}.
1440    */
1441   function setApprovalForAll(address operator, bool approved) public override {
1442     require(operator != _msgSender(), "ERC721A: approve to caller");
1443 
1444     _operatorApprovals[_msgSender()][operator] = approved;
1445     emit ApprovalForAll(_msgSender(), operator, approved);
1446   }
1447 
1448   /**
1449    * @dev See {IERC721-isApprovedForAll}.
1450    */
1451   function isApprovedForAll(address owner, address operator)
1452     public
1453     view
1454     virtual
1455     override
1456     returns (bool)
1457   {
1458     return _operatorApprovals[owner][operator];
1459   }
1460 
1461   /**
1462    * @dev See {IERC721-transferFrom}.
1463    */
1464   function transferFrom(
1465     address from,
1466     address to,
1467     uint256 tokenId
1468   ) public override {
1469     _transfer(from, to, tokenId);
1470   }
1471 
1472   /**
1473    * @dev See {IERC721-safeTransferFrom}.
1474    */
1475   function safeTransferFrom(
1476     address from,
1477     address to,
1478     uint256 tokenId
1479   ) public override {
1480     safeTransferFrom(from, to, tokenId, "");
1481   }
1482 
1483   /**
1484    * @dev See {IERC721-safeTransferFrom}.
1485    */
1486   function safeTransferFrom(
1487     address from,
1488     address to,
1489     uint256 tokenId,
1490     bytes memory _data
1491   ) public override {
1492     _transfer(from, to, tokenId);
1493     require(
1494       _checkOnERC721Received(from, to, tokenId, _data),
1495       "ERC721A: transfer to non ERC721Receiver implementer"
1496     );
1497   }
1498 
1499   /**
1500    * @dev Returns whether `tokenId` exists.
1501    *
1502    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1503    *
1504    * Tokens start existing when they are minted (`_mint`),
1505    */
1506   function _exists(uint256 tokenId) internal view returns (bool) {
1507     return tokenId < currentIndex;
1508   }
1509 
1510   function _safeMint(address to, uint256 quantity) internal {
1511     _safeMint(to, quantity, "");
1512   }
1513 
1514   /**
1515    * @dev Mints `quantity` tokens and transfers them to `to`.
1516    *
1517    * Requirements:
1518    *
1519    * - there must be `quantity` tokens remaining unminted in the total collection.
1520    * - `to` cannot be the zero address.
1521    * - `quantity` cannot be larger than the max batch size.
1522    *
1523    * Emits a {Transfer} event.
1524    */
1525   function _safeMint(
1526     address to,
1527     uint256 quantity,
1528     bytes memory _data
1529   ) internal {
1530     uint256 startTokenId = currentIndex;
1531     require(to != address(0), "ERC721A: mint to the zero address");
1532     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1533     require(!_exists(startTokenId), "ERC721A: token already minted");
1534     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1535 
1536     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1537 
1538     AddressData memory addressData = _addressData[to];
1539     _addressData[to] = AddressData(
1540       addressData.balance + uint128(quantity),
1541       addressData.numberMinted + uint128(quantity)
1542     );
1543     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1544 
1545     uint256 updatedIndex = startTokenId;
1546 
1547     for (uint256 i = 0; i < quantity; i++) {
1548       emit Transfer(address(0), to, updatedIndex);
1549       require(
1550         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1551         "ERC721A: transfer to non ERC721Receiver implementer"
1552       );
1553       updatedIndex++;
1554     }
1555 
1556     currentIndex = updatedIndex;
1557     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1558   }
1559 
1560   /**
1561    * @dev Transfers `tokenId` from `from` to `to`.
1562    *
1563    * Requirements:
1564    *
1565    * - `to` cannot be the zero address.
1566    * - `tokenId` token must be owned by `from`.
1567    *
1568    * Emits a {Transfer} event.
1569    */
1570   function _transfer(
1571     address from,
1572     address to,
1573     uint256 tokenId
1574   ) private {
1575     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1576 
1577     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1578       getApproved(tokenId) == _msgSender() ||
1579       isApprovedForAll(prevOwnership.addr, _msgSender()));
1580 
1581     require(
1582       isApprovedOrOwner,
1583       "ERC721A: transfer caller is not owner nor approved"
1584     );
1585 
1586     require(
1587       prevOwnership.addr == from,
1588       "ERC721A: transfer from incorrect owner"
1589     );
1590     require(to != address(0), "ERC721A: transfer to the zero address");
1591 
1592     _beforeTokenTransfers(from, to, tokenId, 1);
1593 
1594     // Clear approvals from the previous owner
1595     _approve(address(0), tokenId, prevOwnership.addr);
1596 
1597     _addressData[from].balance -= 1;
1598     _addressData[to].balance += 1;
1599     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1600 
1601     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1602     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1603     uint256 nextTokenId = tokenId + 1;
1604     if (_ownerships[nextTokenId].addr == address(0)) {
1605       if (_exists(nextTokenId)) {
1606         _ownerships[nextTokenId] = TokenOwnership(
1607           prevOwnership.addr,
1608           prevOwnership.startTimestamp
1609         );
1610       }
1611     }
1612 
1613     emit Transfer(from, to, tokenId);
1614     _afterTokenTransfers(from, to, tokenId, 1);
1615   }
1616 
1617   /**
1618    * @dev Approve `to` to operate on `tokenId`
1619    *
1620    * Emits a {Approval} event.
1621    */
1622   function _approve(
1623     address to,
1624     uint256 tokenId,
1625     address owner
1626   ) private {
1627     _tokenApprovals[tokenId] = to;
1628     emit Approval(owner, to, tokenId);
1629   }
1630 
1631   uint256 public nextOwnerToExplicitlySet = 0;
1632 
1633   /**
1634    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1635    */
1636   function _setOwnersExplicit(uint256 quantity) internal {
1637     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1638     require(quantity > 0, "quantity must be nonzero");
1639     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1640     if (endIndex > collectionSize - 1) {
1641       endIndex = collectionSize - 1;
1642     }
1643     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1644     require(_exists(endIndex), "not enough minted yet for this cleanup");
1645     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1646       if (_ownerships[i].addr == address(0)) {
1647         TokenOwnership memory ownership = ownershipOf(i);
1648         _ownerships[i] = TokenOwnership(
1649           ownership.addr,
1650           ownership.startTimestamp
1651         );
1652       }
1653     }
1654     nextOwnerToExplicitlySet = endIndex + 1;
1655   }
1656 
1657   /**
1658    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1659    * The call is not executed if the target address is not a contract.
1660    *
1661    * @param from address representing the previous owner of the given token ID
1662    * @param to target address that will receive the tokens
1663    * @param tokenId uint256 ID of the token to be transferred
1664    * @param _data bytes optional data to send along with the call
1665    * @return bool whether the call correctly returned the expected magic value
1666    */
1667   function _checkOnERC721Received(
1668     address from,
1669     address to,
1670     uint256 tokenId,
1671     bytes memory _data
1672   ) private returns (bool) {
1673     if (to.isContract()) {
1674       try
1675         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1676       returns (bytes4 retval) {
1677         return retval == IERC721Receiver(to).onERC721Received.selector;
1678       } catch (bytes memory reason) {
1679         if (reason.length == 0) {
1680           revert("ERC721A: transfer to non ERC721Receiver implementer");
1681         } else {
1682           assembly {
1683             revert(add(32, reason), mload(reason))
1684           }
1685         }
1686       }
1687     } else {
1688       return true;
1689     }
1690   }
1691 
1692   /**
1693    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1694    *
1695    * startTokenId - the first token id to be transferred
1696    * quantity - the amount to be transferred
1697    *
1698    * Calling conditions:
1699    *
1700    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1701    * transferred to `to`.
1702    * - When `from` is zero, `tokenId` will be minted for `to`.
1703    */
1704   function _beforeTokenTransfers(
1705     address from,
1706     address to,
1707     uint256 startTokenId,
1708     uint256 quantity
1709   ) internal virtual {}
1710 
1711   /**
1712    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1713    * minting.
1714    *
1715    * startTokenId - the first token id to be transferred
1716    * quantity - the amount to be transferred
1717    *
1718    * Calling conditions:
1719    *
1720    * - when `from` and `to` are both non-zero.
1721    * - `from` and `to` are never both zero.
1722    */
1723   function _afterTokenTransfers(
1724     address from,
1725     address to,
1726     uint256 startTokenId,
1727     uint256 quantity
1728   ) internal virtual {}
1729 }
1730 
1731 //SPDX-License-Identifier: MIT
1732 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1733 
1734 pragma solidity ^0.8.0;
1735 
1736 
1737 
1738 
1739 
1740 
1741 
1742 
1743 
1744 contract BakedBananas is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1745     using Counters for Counters.Counter;
1746     using Strings for uint256;
1747 
1748     Counters.Counter private tokenCounter;
1749 
1750     string private baseURI = "";
1751     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1752     bool private isOpenSeaProxyActive = true;
1753 
1754     uint256 public constant MAX_MINTS_PER_TX = 1;
1755     uint256 public maxSupply = 420;
1756     uint256 public constant WALLETLIMIT = 0;
1757 
1758     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1759     uint256 public NUM_FREE_MINTS = 420;
1760     bool public isPublicSaleActive = false;
1761 
1762 
1763 
1764 
1765     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1766 
1767     modifier publicSaleActive() {
1768         require(isPublicSaleActive, "Public sale is not open");
1769         _;
1770     }
1771 
1772 
1773 
1774     modifier maxMintsPerTX(uint256 numberOfTokens) {
1775         require(
1776             numberOfTokens <= MAX_MINTS_PER_TX,
1777             "Max mints per transaction exceeded"
1778         );
1779         _;
1780     }
1781 
1782     modifier canMintNFTs(uint256 numberOfTokens) {
1783         require(
1784             totalSupply() + numberOfTokens <=
1785                 maxSupply,
1786             "Not enough mints remaining to mint"
1787         );
1788         _;
1789     }
1790 
1791     modifier freeMintsAvailable() {
1792         require(
1793             totalSupply() <=
1794                 NUM_FREE_MINTS,
1795             "Not enough free mints remain"
1796         );
1797         _;
1798     }
1799 
1800 
1801 
1802     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1803         if(totalSupply()>NUM_FREE_MINTS){
1804         require(
1805             (price * numberOfTokens) == msg.value,
1806             "Incorrect ETH value sent"
1807         );
1808         }
1809         _;
1810     }
1811 
1812 
1813     modifier isWalletLimit() {
1814         require(
1815             _numberMinted(msg.sender) <= 
1816               WALLETLIMIT,
1817          "There is a per-wallet limit!"
1818         );
1819         _;
1820     }
1821 
1822     constructor(
1823     ) ERC721A("Baked Bananas", "NANAS", 420, maxSupply) {
1824     }
1825 
1826     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1827 
1828     function mint(uint256 numberOfTokens)
1829         external
1830         payable
1831         nonReentrant
1832         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1833         publicSaleActive
1834         canMintNFTs(numberOfTokens)
1835         maxMintsPerTX(numberOfTokens)
1836     {
1837 
1838         _safeMint(msg.sender, numberOfTokens);
1839     }
1840 
1841 
1842 
1843     //A simple free mint function to avoid confusion
1844     //The normal mint function with a cost of 0 would work too
1845     function freeMint(uint256 numberOfTokens)
1846         external
1847         nonReentrant
1848         canMintNFTs(numberOfTokens)
1849         maxMintsPerTX(numberOfTokens)
1850         freeMintsAvailable()
1851         isWalletLimit
1852     {
1853         _safeMint(msg.sender, numberOfTokens);
1854     }
1855 
1856 
1857 
1858 
1859     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1860 
1861     function getBaseURI() external view returns (string memory) {
1862         return baseURI;
1863     }
1864 
1865     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1866 
1867     function setBaseURI(string memory _baseURI) external onlyOwner {
1868         baseURI = _baseURI;
1869     }
1870 
1871     // function to disable gasless listings for security in case
1872     // opensea ever shuts down or is compromised
1873     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1874         external
1875         onlyOwner
1876     {
1877         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1878     }
1879 
1880     function setIsPublicSaleActive(bool _isPublicSaleActive)
1881         external
1882         onlyOwner
1883     {
1884         isPublicSaleActive = _isPublicSaleActive;
1885     }
1886 
1887     function setNumFreeMints(uint256 _numfreemints)
1888         external
1889         onlyOwner
1890     {
1891         NUM_FREE_MINTS = _numfreemints;
1892     }
1893 
1894 
1895     function withdraw() public onlyOwner {
1896         uint256 balance = address(this).balance;
1897         payable(msg.sender).transfer(balance);
1898     }
1899 
1900     function withdrawTokens(IERC20 token) public onlyOwner {
1901         uint256 balance = token.balanceOf(address(this));
1902         token.transfer(msg.sender, balance);
1903     }
1904 
1905 
1906 
1907     // ============ SUPPORTING FUNCTIONS ============
1908 
1909     function nextTokenId() private returns (uint256) {
1910         tokenCounter.increment();
1911         return tokenCounter.current();
1912     }
1913 
1914     // ============ FUNCTION OVERRIDES ============
1915 
1916     function supportsInterface(bytes4 interfaceId)
1917         public
1918         view
1919         virtual
1920         override(ERC721A, IERC165)
1921         returns (bool)
1922     {
1923         return
1924             interfaceId == type(IERC2981).interfaceId ||
1925             super.supportsInterface(interfaceId);
1926     }
1927 
1928     /**
1929      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1930      */
1931     function isApprovedForAll(address owner, address operator)
1932         public
1933         view
1934         override
1935         returns (bool)
1936     {
1937         // Get a reference to OpenSea's proxy registry contract by instantiating
1938         // the contract using the already existing address.
1939         ProxyRegistry proxyRegistry = ProxyRegistry(
1940             openSeaProxyRegistryAddress
1941         );
1942         if (
1943             isOpenSeaProxyActive &&
1944             address(proxyRegistry.proxies(owner)) == operator
1945         ) {
1946             return true;
1947         }
1948 
1949         return super.isApprovedForAll(owner, operator);
1950     }
1951 
1952     /**
1953      * @dev See {IERC721Metadata-tokenURI}.
1954      */
1955     function tokenURI(uint256 tokenId)
1956         public
1957         view
1958         virtual
1959         override
1960         returns (string memory)
1961     {
1962         require(_exists(tokenId), "Nonexistent token");
1963 
1964         return
1965             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1966     }
1967 
1968     /**
1969      * @dev See {IERC165-royaltyInfo}.
1970      */
1971     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1972         external
1973         view
1974         override
1975         returns (address receiver, uint256 royaltyAmount)
1976     {
1977         require(_exists(tokenId), "Nonexistent token");
1978 
1979         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1980     }
1981 }
1982 
1983 // These contract definitions are used to create a reference to the OpenSea
1984 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1985 contract OwnableDelegateProxy {
1986 
1987 }
1988 
1989 contract ProxyRegistry {
1990     mapping(address => OwnableDelegateProxy) public proxies;
1991 }