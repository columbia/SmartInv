1 /*
2 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
3 ─██████████████───██████████████─████████████───██████████████────██████████████─██████████████─██████████████─██████████████─
4 ─██░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░████─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
5 ─██░░██████░░██───██░░██████░░██─██░░████░░░░██─██░░██████░░██────██░░██████░░██─██░░██████░░██─██░░██████████─██░░██████████─
6 ─██░░██──██░░██───██░░██──██░░██─██░░██──██░░██─██░░██──██░░██────██░░██──██░░██─██░░██──██░░██─██░░██─────────██░░██─────────
7 ─██░░██████░░████─██░░██──██░░██─██░░██──██░░██─██░░██████░░██────██░░██████░░██─██░░██████░░██─██░░██████████─██░░██████████─
8 ─██░░░░░░░░░░░░██─██░░██──██░░██─██░░██──██░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
9 ─██░░████████░░██─██░░██──██░░██─██░░██──██░░██─██░░██████░░██────██░░██████████─██░░██████░░██─██████████░░██─██████████░░██─
10 ─██░░██────██░░██─██░░██──██░░██─██░░██──██░░██─██░░██──██░░██────██░░██─────────██░░██──██░░██─────────██░░██─────────██░░██─
11 ─██░░████████░░██─██░░██████░░██─██░░████░░░░██─██░░██──██░░██────██░░██─────────██░░██──██░░██─██████████░░██─██████████░░██─
12 ─██░░░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░████─██░░██──██░░██────██░░██─────────██░░██──██░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
13 ─████████████████─██████████████─████████████───██████──██████────██████─────────██████──██████─██████████████─██████████████─
14 ──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
15 */
16 pragma solidity ^0.8.0;
17 
18 // CAUTION
19 // This version of SafeMath should only be used with Solidity 0.8 or later,
20 // because it relies on the compiler's built in overflow checks.
21 
22 /**
23  * @dev Wrappers over Solidity's arithmetic operations.
24  *
25  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
26  * now has built in overflow checking.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, with an overflow flag.
31      *
32      * _Available since v3.4._
33      */
34     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
35         unchecked {
36             uint256 c = a + b;
37             if (c < a) return (false, 0);
38             return (true, c);
39         }
40     }
41 
42     /**
43      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         unchecked {
49             if (b > a) return (false, 0);
50             return (true, a - b);
51         }
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
62             // benefit is lost if 'b' is also tested.
63             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
64             if (a == 0) return (true, 0);
65             uint256 c = a * b;
66             if (c / a != b) return (false, 0);
67             return (true, c);
68         }
69     }
70 
71     /**
72      * @dev Returns the division of two unsigned integers, with a division by zero flag.
73      *
74      * _Available since v3.4._
75      */
76     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
77         unchecked {
78             if (b == 0) return (false, 0);
79             return (true, a / b);
80         }
81     }
82 
83     /**
84      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
85      *
86      * _Available since v3.4._
87      */
88     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
89         unchecked {
90             if (b == 0) return (false, 0);
91             return (true, a % b);
92         }
93     }
94 
95     /**
96      * @dev Returns the addition of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `+` operator.
100      *
101      * Requirements:
102      *
103      * - Addition cannot overflow.
104      */
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         return a + b;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a - b;
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, reverting on
125      * overflow.
126      *
127      * Counterpart to Solidity's `*` operator.
128      *
129      * Requirements:
130      *
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a * b;
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers, reverting on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator.
142      *
143      * Requirements:
144      *
145      * - The divisor cannot be zero.
146      */
147     function div(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a / b;
149     }
150 
151     /**
152      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
153      * reverting when dividing by zero.
154      *
155      * Counterpart to Solidity's `%` operator. This function uses a `revert`
156      * opcode (which leaves remaining gas untouched) while Solidity uses an
157      * invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      *
161      * - The divisor cannot be zero.
162      */
163     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
164         return a % b;
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * CAUTION: This function is deprecated because it requires allocating memory for the error
172      * message unnecessarily. For custom revert reasons use {trySub}.
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(
181         uint256 a,
182         uint256 b,
183         string memory errorMessage
184     ) internal pure returns (uint256) {
185         unchecked {
186             require(b <= a, errorMessage);
187             return a - b;
188         }
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(
204         uint256 a,
205         uint256 b,
206         string memory errorMessage
207     ) internal pure returns (uint256) {
208         unchecked {
209             require(b > 0, errorMessage);
210             return a / b;
211         }
212     }
213 
214     /**
215      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
216      * reverting with custom message when dividing by zero.
217      *
218      * CAUTION: This function is deprecated because it requires allocating memory for the error
219      * message unnecessarily. For custom revert reasons use {tryMod}.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function mod(
230         uint256 a,
231         uint256 b,
232         string memory errorMessage
233     ) internal pure returns (uint256) {
234         unchecked {
235             require(b > 0, errorMessage);
236             return a % b;
237         }
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Counters.sol
242 
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @title Counters
250  * @author Matt Condon (@shrugs)
251  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
252  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
253  *
254  * Include with `using Counters for Counters.Counter;`
255  */
256 library Counters {
257     struct Counter {
258         // This variable should never be directly accessed by users of the library: interactions must be restricted to
259         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
260         // this feature: see https://github.com/ethereum/solidity/issues/4637
261         uint256 _value; // default: 0
262     }
263 
264     function current(Counter storage counter) internal view returns (uint256) {
265         return counter._value;
266     }
267 
268     function increment(Counter storage counter) internal {
269         unchecked {
270             counter._value += 1;
271         }
272     }
273 
274     function decrement(Counter storage counter) internal {
275         uint256 value = counter._value;
276         require(value > 0, "Counter: decrement overflow");
277         unchecked {
278             counter._value = value - 1;
279         }
280     }
281 
282     function reset(Counter storage counter) internal {
283         counter._value = 0;
284     }
285 }
286 
287 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev Contract module that helps prevent reentrant calls to a function.
296  *
297  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
298  * available, which can be applied to functions to make sure there are no nested
299  * (reentrant) calls to them.
300  *
301  * Note that because there is a single `nonReentrant` guard, functions marked as
302  * `nonReentrant` may not call one another. This can be worked around by making
303  * those functions `private`, and then adding `external` `nonReentrant` entry
304  * points to them.
305  *
306  * TIP: If you would like to learn more about reentrancy and alternative ways
307  * to protect against it, check out our blog post
308  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
309  */
310 abstract contract ReentrancyGuard {
311     // Booleans are more expensive than uint256 or any type that takes up a full
312     // word because each write operation emits an extra SLOAD to first read the
313     // slot's contents, replace the bits taken up by the boolean, and then write
314     // back. This is the compiler's defense against contract upgrades and
315     // pointer aliasing, and it cannot be disabled.
316 
317     // The values being non-zero value makes deployment a bit more expensive,
318     // but in exchange the refund on every call to nonReentrant will be lower in
319     // amount. Since refunds are capped to a percentage of the total
320     // transaction's gas, it is best to keep them low in cases like this one, to
321     // increase the likelihood of the full refund coming into effect.
322     uint256 private constant _NOT_ENTERED = 1;
323     uint256 private constant _ENTERED = 2;
324 
325     uint256 private _status;
326 
327     constructor() {
328         _status = _NOT_ENTERED;
329     }
330 
331     /**
332      * @dev Prevents a contract from calling itself, directly or indirectly.
333      * Calling a `nonReentrant` function from another `nonReentrant`
334      * function is not supported. It is possible to prevent this from happening
335      * by making the `nonReentrant` function external, and making it call a
336      * `private` function that does the actual work.
337      */
338     modifier nonReentrant() {
339         // On the first call to nonReentrant, _notEntered will be true
340         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
341 
342         // Any calls to nonReentrant after this point will fail
343         _status = _ENTERED;
344 
345         _;
346 
347         // By storing the original value once again, a refund is triggered (see
348         // https://eips.ethereum.org/EIPS/eip-2200)
349         _status = _NOT_ENTERED;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
354 
355 
356 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC20 standard as defined in the EIP.
362  */
363 interface IERC20 {
364     /**
365      * @dev Returns the amount of tokens in existence.
366      */
367     function totalSupply() external view returns (uint256);
368 
369     /**
370      * @dev Returns the amount of tokens owned by `account`.
371      */
372     function balanceOf(address account) external view returns (uint256);
373 
374     /**
375      * @dev Moves `amount` tokens from the caller's account to `recipient`.
376      *
377      * Returns a boolean value indicating whether the operation succeeded.
378      *
379      * Emits a {Transfer} event.
380      */
381     function transfer(address recipient, uint256 amount) external returns (bool);
382 
383     /**
384      * @dev Returns the remaining number of tokens that `spender` will be
385      * allowed to spend on behalf of `owner` through {transferFrom}. This is
386      * zero by default.
387      *
388      * This value changes when {approve} or {transferFrom} are called.
389      */
390     function allowance(address owner, address spender) external view returns (uint256);
391 
392     /**
393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
394      *
395      * Returns a boolean value indicating whether the operation succeeded.
396      *
397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
398      * that someone may use both the old and the new allowance by unfortunate
399      * transaction ordering. One possible solution to mitigate this race
400      * condition is to first reduce the spender's allowance to 0 and set the
401      * desired value afterwards:
402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
403      *
404      * Emits an {Approval} event.
405      */
406     function approve(address spender, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Moves `amount` tokens from `sender` to `recipient` using the
410      * allowance mechanism. `amount` is then deducted from the caller's
411      * allowance.
412      *
413      * Returns a boolean value indicating whether the operation succeeded.
414      *
415      * Emits a {Transfer} event.
416      */
417     function transferFrom(
418         address sender,
419         address recipient,
420         uint256 amount
421     ) external returns (bool);
422 
423     /**
424      * @dev Emitted when `value` tokens are moved from one account (`from`) to
425      * another (`to`).
426      *
427      * Note that `value` may be zero.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 value);
430 
431     /**
432      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
433      * a call to {approve}. `value` is the new allowance.
434      */
435     event Approval(address indexed owner, address indexed spender, uint256 value);
436 }
437 
438 // File: @openzeppelin/contracts/interfaces/IERC20.sol
439 
440 
441 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
442 
443 pragma solidity ^0.8.0;
444 
445 
446 // File: @openzeppelin/contracts/utils/Strings.sol
447 
448 
449 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev String operations.
455  */
456 library Strings {
457     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
458 
459     /**
460      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
461      */
462     function toString(uint256 value) internal pure returns (string memory) {
463         // Inspired by OraclizeAPI's implementation - MIT licence
464         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
465 
466         if (value == 0) {
467             return "0";
468         }
469         uint256 temp = value;
470         uint256 digits;
471         while (temp != 0) {
472             digits++;
473             temp /= 10;
474         }
475         bytes memory buffer = new bytes(digits);
476         while (value != 0) {
477             digits -= 1;
478             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
479             value /= 10;
480         }
481         return string(buffer);
482     }
483 
484     /**
485      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
486      */
487     function toHexString(uint256 value) internal pure returns (string memory) {
488         if (value == 0) {
489             return "0x00";
490         }
491         uint256 temp = value;
492         uint256 length = 0;
493         while (temp != 0) {
494             length++;
495             temp >>= 8;
496         }
497         return toHexString(value, length);
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
502      */
503     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
504         bytes memory buffer = new bytes(2 * length + 2);
505         buffer[0] = "0";
506         buffer[1] = "x";
507         for (uint256 i = 2 * length + 1; i > 1; --i) {
508             buffer[i] = _HEX_SYMBOLS[value & 0xf];
509             value >>= 4;
510         }
511         require(value == 0, "Strings: hex length insufficient");
512         return string(buffer);
513     }
514 }
515 
516 // File: @openzeppelin/contracts/utils/Context.sol
517 
518 
519 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @dev Provides information about the current execution context, including the
525  * sender of the transaction and its data. While these are generally available
526  * via msg.sender and msg.data, they should not be accessed in such a direct
527  * manner, since when dealing with meta-transactions the account sending and
528  * paying for execution may not be the actual sender (as far as an application
529  * is concerned).
530  *
531  * This contract is only required for intermediate, library-like contracts.
532  */
533 abstract contract Context {
534     function _msgSender() internal view virtual returns (address) {
535         return msg.sender;
536     }
537 
538     function _msgData() internal view virtual returns (bytes calldata) {
539         return msg.data;
540     }
541 }
542 
543 // File: @openzeppelin/contracts/access/Ownable.sol
544 
545 
546 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 
551 /**
552  * @dev Contract module which provides a basic access control mechanism, where
553  * there is an account (an owner) that can be granted exclusive access to
554  * specific functions.
555  *
556  * By default, the owner account will be the one that deploys the contract. This
557  * can later be changed with {transferOwnership}.
558  *
559  * This module is used through inheritance. It will make available the modifier
560  * `onlyOwner`, which can be applied to your functions to restrict their use to
561  * the owner.
562  */
563 abstract contract Ownable is Context {
564     address private _owner;
565 
566     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
567 
568     /**
569      * @dev Initializes the contract setting the deployer as the initial owner.
570      */
571     constructor() {
572         _transferOwnership(_msgSender());
573     }
574 
575     /**
576      * @dev Returns the address of the current owner.
577      */
578     function owner() public view virtual returns (address) {
579         return _owner;
580     }
581 
582     /**
583      * @dev Throws if called by any account other than the owner.
584      */
585     modifier onlyOwner() {
586         require(owner() == _msgSender(), "Ownable: caller is not the owner");
587         _;
588     }
589 
590     /**
591      * @dev Leaves the contract without owner. It will not be possible to call
592      * `onlyOwner` functions anymore. Can only be called by the current owner.
593      *
594      * NOTE: Renouncing ownership will leave the contract without an owner,
595      * thereby removing any functionality that is only available to the owner.
596      */
597     function renounceOwnership() public virtual onlyOwner {
598         _transferOwnership(address(0));
599     }
600 
601     /**
602      * @dev Transfers ownership of the contract to a new account (`newOwner`).
603      * Can only be called by the current owner.
604      */
605     function transferOwnership(address newOwner) public virtual onlyOwner {
606         require(newOwner != address(0), "Ownable: new owner is the zero address");
607         _transferOwnership(newOwner);
608     }
609 
610     /**
611      * @dev Transfers ownership of the contract to a new account (`newOwner`).
612      * Internal function without access restriction.
613      */
614     function _transferOwnership(address newOwner) internal virtual {
615         address oldOwner = _owner;
616         _owner = newOwner;
617         emit OwnershipTransferred(oldOwner, newOwner);
618     }
619 }
620 
621 // File: @openzeppelin/contracts/utils/Address.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Collection of functions related to the address type
630  */
631 library Address {
632     /**
633      * @dev Returns true if `account` is a contract.
634      *
635      * [IMPORTANT]
636      * ====
637      * It is unsafe to assume that an address for which this function returns
638      * false is an externally-owned account (EOA) and not a contract.
639      *
640      * Among others, `isContract` will return false for the following
641      * types of addresses:
642      *
643      *  - an externally-owned account
644      *  - a contract in construction
645      *  - an address where a contract will be created
646      *  - an address where a contract lived, but was destroyed
647      * ====
648      */
649     function isContract(address account) internal view returns (bool) {
650         // This method relies on extcodesize, which returns 0 for contracts in
651         // construction, since the code is only stored at the end of the
652         // constructor execution.
653 
654         uint256 size;
655         assembly {
656             size := extcodesize(account)
657         }
658         return size > 0;
659     }
660 
661     /**
662      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
663      * `recipient`, forwarding all available gas and reverting on errors.
664      *
665      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
666      * of certain opcodes, possibly making contracts go over the 2300 gas limit
667      * imposed by `transfer`, making them unable to receive funds via
668      * `transfer`. {sendValue} removes this limitation.
669      *
670      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
671      *
672      * IMPORTANT: because control is transferred to `recipient`, care must be
673      * taken to not create reentrancy vulnerabilities. Consider using
674      * {ReentrancyGuard} or the
675      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
676      */
677     function sendValue(address payable recipient, uint256 amount) internal {
678         require(address(this).balance >= amount, "Address: insufficient balance");
679 
680         (bool success, ) = recipient.call{value: amount}("");
681         require(success, "Address: unable to send value, recipient may have reverted");
682     }
683 
684     /**
685      * @dev Performs a Solidity function call using a low level `call`. A
686      * plain `call` is an unsafe replacement for a function call: use this
687      * function instead.
688      *
689      * If `target` reverts with a revert reason, it is bubbled up by this
690      * function (like regular Solidity function calls).
691      *
692      * Returns the raw returned data. To convert to the expected return value,
693      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
694      *
695      * Requirements:
696      *
697      * - `target` must be a contract.
698      * - calling `target` with `data` must not revert.
699      *
700      * _Available since v3.1._
701      */
702     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
703         return functionCall(target, data, "Address: low-level call failed");
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
708      * `errorMessage` as a fallback revert reason when `target` reverts.
709      *
710      * _Available since v3.1._
711      */
712     function functionCall(
713         address target,
714         bytes memory data,
715         string memory errorMessage
716     ) internal returns (bytes memory) {
717         return functionCallWithValue(target, data, 0, errorMessage);
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
722      * but also transferring `value` wei to `target`.
723      *
724      * Requirements:
725      *
726      * - the calling contract must have an ETH balance of at least `value`.
727      * - the called Solidity function must be `payable`.
728      *
729      * _Available since v3.1._
730      */
731     function functionCallWithValue(
732         address target,
733         bytes memory data,
734         uint256 value
735     ) internal returns (bytes memory) {
736         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
741      * with `errorMessage` as a fallback revert reason when `target` reverts.
742      *
743      * _Available since v3.1._
744      */
745     function functionCallWithValue(
746         address target,
747         bytes memory data,
748         uint256 value,
749         string memory errorMessage
750     ) internal returns (bytes memory) {
751         require(address(this).balance >= value, "Address: insufficient balance for call");
752         require(isContract(target), "Address: call to non-contract");
753 
754         (bool success, bytes memory returndata) = target.call{value: value}(data);
755         return verifyCallResult(success, returndata, errorMessage);
756     }
757 
758     /**
759      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
760      * but performing a static call.
761      *
762      * _Available since v3.3._
763      */
764     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
765         return functionStaticCall(target, data, "Address: low-level static call failed");
766     }
767 
768     /**
769      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
770      * but performing a static call.
771      *
772      * _Available since v3.3._
773      */
774     function functionStaticCall(
775         address target,
776         bytes memory data,
777         string memory errorMessage
778     ) internal view returns (bytes memory) {
779         require(isContract(target), "Address: static call to non-contract");
780 
781         (bool success, bytes memory returndata) = target.staticcall(data);
782         return verifyCallResult(success, returndata, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but performing a delegate call.
788      *
789      * _Available since v3.4._
790      */
791     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
792         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
797      * but performing a delegate call.
798      *
799      * _Available since v3.4._
800      */
801     function functionDelegateCall(
802         address target,
803         bytes memory data,
804         string memory errorMessage
805     ) internal returns (bytes memory) {
806         require(isContract(target), "Address: delegate call to non-contract");
807 
808         (bool success, bytes memory returndata) = target.delegatecall(data);
809         return verifyCallResult(success, returndata, errorMessage);
810     }
811 
812     /**
813      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
814      * revert reason using the provided one.
815      *
816      * _Available since v4.3._
817      */
818     function verifyCallResult(
819         bool success,
820         bytes memory returndata,
821         string memory errorMessage
822     ) internal pure returns (bytes memory) {
823         if (success) {
824             return returndata;
825         } else {
826             // Look for revert reason and bubble it up if present
827             if (returndata.length > 0) {
828                 // The easiest way to bubble the revert reason is using memory via assembly
829 
830                 assembly {
831                     let returndata_size := mload(returndata)
832                     revert(add(32, returndata), returndata_size)
833                 }
834             } else {
835                 revert(errorMessage);
836             }
837         }
838     }
839 }
840 
841 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
842 
843 
844 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
845 
846 pragma solidity ^0.8.0;
847 
848 /**
849  * @title ERC721 token receiver interface
850  * @dev Interface for any contract that wants to support safeTransfers
851  * from ERC721 asset contracts.
852  */
853 interface IERC721Receiver {
854     /**
855      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
856      * by `operator` from `from`, this function is called.
857      *
858      * It must return its Solidity selector to confirm the token transfer.
859      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
860      *
861      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
862      */
863     function onERC721Received(
864         address operator,
865         address from,
866         uint256 tokenId,
867         bytes calldata data
868     ) external returns (bytes4);
869 }
870 
871 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
872 
873 
874 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
875 
876 pragma solidity ^0.8.0;
877 
878 /**
879  * @dev Interface of the ERC165 standard, as defined in the
880  * https://eips.ethereum.org/EIPS/eip-165[EIP].
881  *
882  * Implementers can declare support of contract interfaces, which can then be
883  * queried by others ({ERC165Checker}).
884  *
885  * For an implementation, see {ERC165}.
886  */
887 interface IERC165 {
888     /**
889      * @dev Returns true if this contract implements the interface defined by
890      * `interfaceId`. See the corresponding
891      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
892      * to learn more about how these ids are created.
893      *
894      * This function call must use less than 30 000 gas.
895      */
896     function supportsInterface(bytes4 interfaceId) external view returns (bool);
897 }
898 
899 // File: @openzeppelin/contracts/interfaces/IERC165.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 
907 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
908 
909 
910 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @dev Interface for the NFT Royalty Standard
917  */
918 interface IERC2981 is IERC165 {
919     /**
920      * @dev Called with the sale price to determine how much royalty is owed and to whom.
921      * @param tokenId - the NFT asset queried for royalty information
922      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
923      * @return receiver - address of who should be sent the royalty payment
924      * @return royaltyAmount - the royalty payment amount for `salePrice`
925      */
926     function royaltyInfo(uint256 tokenId, uint256 salePrice)
927         external
928         view
929         returns (address receiver, uint256 royaltyAmount);
930 }
931 
932 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
933 
934 
935 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
936 
937 pragma solidity ^0.8.0;
938 
939 
940 /**
941  * @dev Implementation of the {IERC165} interface.
942  *
943  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
944  * for the additional interface id that will be supported. For example:
945  *
946  * ```solidity
947  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
948  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
949  * }
950  * ```
951  *
952  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
953  */
954 abstract contract ERC165 is IERC165 {
955     /**
956      * @dev See {IERC165-supportsInterface}.
957      */
958     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
959         return interfaceId == type(IERC165).interfaceId;
960     }
961 }
962 
963 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
964 
965 
966 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 
971 /**
972  * @dev Required interface of an ERC721 compliant contract.
973  */
974 interface IERC721 is IERC165 {
975     /**
976      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
977      */
978     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
979 
980     /**
981      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
982      */
983     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
984 
985     /**
986      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
987      */
988     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
989 
990     /**
991      * @dev Returns the number of tokens in ``owner``'s account.
992      */
993     function balanceOf(address owner) external view returns (uint256 balance);
994 
995     /**
996      * @dev Returns the owner of the `tokenId` token.
997      *
998      * Requirements:
999      *
1000      * - `tokenId` must exist.
1001      */
1002     function ownerOf(uint256 tokenId) external view returns (address owner);
1003 
1004     /**
1005      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1006      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1007      *
1008      * Requirements:
1009      *
1010      * - `from` cannot be the zero address.
1011      * - `to` cannot be the zero address.
1012      * - `tokenId` token must exist and be owned by `from`.
1013      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1014      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1015      *
1016      * Emits a {Transfer} event.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) external;
1023 
1024     /**
1025      * @dev Transfers `tokenId` token from `from` to `to`.
1026      *
1027      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1028      *
1029      * Requirements:
1030      *
1031      * - `from` cannot be the zero address.
1032      * - `to` cannot be the zero address.
1033      * - `tokenId` token must be owned by `from`.
1034      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1035      *
1036      * Emits a {Transfer} event.
1037      */
1038     function transferFrom(
1039         address from,
1040         address to,
1041         uint256 tokenId
1042     ) external;
1043 
1044     /**
1045      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1046      * The approval is cleared when the token is transferred.
1047      *
1048      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1049      *
1050      * Requirements:
1051      *
1052      * - The caller must own the token or be an approved operator.
1053      * - `tokenId` must exist.
1054      *
1055      * Emits an {Approval} event.
1056      */
1057     function approve(address to, uint256 tokenId) external;
1058 
1059     /**
1060      * @dev Returns the account approved for `tokenId` token.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      */
1066     function getApproved(uint256 tokenId) external view returns (address operator);
1067 
1068     /**
1069      * @dev Approve or remove `operator` as an operator for the caller.
1070      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1071      *
1072      * Requirements:
1073      *
1074      * - The `operator` cannot be the caller.
1075      *
1076      * Emits an {ApprovalForAll} event.
1077      */
1078     function setApprovalForAll(address operator, bool _approved) external;
1079 
1080     /**
1081      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1082      *
1083      * See {setApprovalForAll}
1084      */
1085     function isApprovedForAll(address owner, address operator) external view returns (bool);
1086 
1087     /**
1088      * @dev Safely transfers `tokenId` token from `from` to `to`.
1089      *
1090      * Requirements:
1091      *
1092      * - `from` cannot be the zero address.
1093      * - `to` cannot be the zero address.
1094      * - `tokenId` token must exist and be owned by `from`.
1095      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1096      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1097      *
1098      * Emits a {Transfer} event.
1099      */
1100     function safeTransferFrom(
1101         address from,
1102         address to,
1103         uint256 tokenId,
1104         bytes calldata data
1105     ) external;
1106 }
1107 
1108 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1109 
1110 
1111 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 /**
1117  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1118  * @dev See https://eips.ethereum.org/EIPS/eip-721
1119  */
1120 interface IERC721Enumerable is IERC721 {
1121     /**
1122      * @dev Returns the total amount of tokens stored by the contract.
1123      */
1124     function totalSupply() external view returns (uint256);
1125 
1126     /**
1127      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1128      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1129      */
1130     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1131 
1132     /**
1133      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1134      * Use along with {totalSupply} to enumerate all tokens.
1135      */
1136     function tokenByIndex(uint256 index) external view returns (uint256);
1137 }
1138 
1139 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1140 
1141 
1142 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1143 
1144 pragma solidity ^0.8.0;
1145 
1146 
1147 /**
1148  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1149  * @dev See https://eips.ethereum.org/EIPS/eip-721
1150  */
1151 interface IERC721Metadata is IERC721 {
1152     /**
1153      * @dev Returns the token collection name.
1154      */
1155     function name() external view returns (string memory);
1156 
1157     /**
1158      * @dev Returns the token collection symbol.
1159      */
1160     function symbol() external view returns (string memory);
1161 
1162     /**
1163      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1164      */
1165     function tokenURI(uint256 tokenId) external view returns (string memory);
1166 }
1167 
1168 // File: contracts/ERC721A.sol
1169 
1170 
1171 
1172 pragma solidity ^0.8.0;
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 /**
1183  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1184  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1185  *
1186  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1187  *
1188  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1189  *
1190  * Does not support burning tokens to address(0).
1191  */
1192 contract ERC721A is
1193   Context,
1194   ERC165,
1195   IERC721,
1196   IERC721Metadata,
1197   IERC721Enumerable
1198 {
1199   using Address for address;
1200   using Strings for uint256;
1201 
1202   struct TokenOwnership {
1203     address addr;
1204     uint64 startTimestamp;
1205   }
1206 
1207   struct AddressData {
1208     uint128 balance;
1209     uint128 numberMinted;
1210   }
1211 
1212   uint256 private currentIndex = 0;
1213 
1214   uint256 internal immutable collectionSize;
1215   uint256 internal immutable maxBatchSize;
1216 
1217   // Token name
1218   string private _name;
1219 
1220   // Token symbol
1221   string private _symbol;
1222 
1223   // Mapping from token ID to ownership details
1224   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1225   mapping(uint256 => TokenOwnership) private _ownerships;
1226 
1227   // Mapping owner address to address data
1228   mapping(address => AddressData) private _addressData;
1229 
1230   // Mapping from token ID to approved address
1231   mapping(uint256 => address) private _tokenApprovals;
1232 
1233   // Mapping from owner to operator approvals
1234   mapping(address => mapping(address => bool)) private _operatorApprovals;
1235 
1236   /**
1237    * @dev
1238    * `maxBatchSize` refers to how much a minter can mint at a time.
1239    * `collectionSize_` refers to how many tokens are in the collection.
1240    */
1241   constructor(
1242     string memory name_,
1243     string memory symbol_,
1244     uint256 maxBatchSize_,
1245     uint256 collectionSize_
1246   ) {
1247     require(
1248       collectionSize_ > 0,
1249       "ERC721A: collection must have a nonzero supply"
1250     );
1251     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1252     _name = name_;
1253     _symbol = symbol_;
1254     maxBatchSize = maxBatchSize_;
1255     collectionSize = collectionSize_;
1256   }
1257 
1258   /**
1259    * @dev See {IERC721Enumerable-totalSupply}.
1260    */
1261   function totalSupply() public view override returns (uint256) {
1262     return currentIndex;
1263   }
1264 
1265   /**
1266    * @dev See {IERC721Enumerable-tokenByIndex}.
1267    */
1268   function tokenByIndex(uint256 index) public view override returns (uint256) {
1269     require(index < totalSupply(), "ERC721A: global index out of bounds");
1270     return index;
1271   }
1272 
1273   /**
1274    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1275    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1276    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1277    */
1278   function tokenOfOwnerByIndex(address owner, uint256 index)
1279     public
1280     view
1281     override
1282     returns (uint256)
1283   {
1284     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1285     uint256 numMintedSoFar = totalSupply();
1286     uint256 tokenIdsIdx = 0;
1287     address currOwnershipAddr = address(0);
1288     for (uint256 i = 0; i < numMintedSoFar; i++) {
1289       TokenOwnership memory ownership = _ownerships[i];
1290       if (ownership.addr != address(0)) {
1291         currOwnershipAddr = ownership.addr;
1292       }
1293       if (currOwnershipAddr == owner) {
1294         if (tokenIdsIdx == index) {
1295           return i;
1296         }
1297         tokenIdsIdx++;
1298       }
1299     }
1300     revert("ERC721A: unable to get token of owner by index");
1301   }
1302 
1303   /**
1304    * @dev See {IERC165-supportsInterface}.
1305    */
1306   function supportsInterface(bytes4 interfaceId)
1307     public
1308     view
1309     virtual
1310     override(ERC165, IERC165)
1311     returns (bool)
1312   {
1313     return
1314       interfaceId == type(IERC721).interfaceId ||
1315       interfaceId == type(IERC721Metadata).interfaceId ||
1316       interfaceId == type(IERC721Enumerable).interfaceId ||
1317       super.supportsInterface(interfaceId);
1318   }
1319 
1320   /**
1321    * @dev See {IERC721-balanceOf}.
1322    */
1323   function balanceOf(address owner) public view override returns (uint256) {
1324     require(owner != address(0), "ERC721A: balance query for the zero address");
1325     return uint256(_addressData[owner].balance);
1326   }
1327 
1328   function _numberMinted(address owner) internal view returns (uint256) {
1329     require(
1330       owner != address(0),
1331       "ERC721A: number minted query for the zero address"
1332     );
1333     return uint256(_addressData[owner].numberMinted);
1334   }
1335 
1336   function ownershipOf(uint256 tokenId)
1337     internal
1338     view
1339     returns (TokenOwnership memory)
1340   {
1341     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1342 
1343     uint256 lowestTokenToCheck;
1344     if (tokenId >= maxBatchSize) {
1345       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1346     }
1347 
1348     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1349       TokenOwnership memory ownership = _ownerships[curr];
1350       if (ownership.addr != address(0)) {
1351         return ownership;
1352       }
1353     }
1354 
1355     revert("ERC721A: unable to determine the owner of token");
1356   }
1357 
1358   /**
1359    * @dev See {IERC721-ownerOf}.
1360    */
1361   function ownerOf(uint256 tokenId) public view override returns (address) {
1362     return ownershipOf(tokenId).addr;
1363   }
1364 
1365   /**
1366    * @dev See {IERC721Metadata-name}.
1367    */
1368   function name() public view virtual override returns (string memory) {
1369     return _name;
1370   }
1371 
1372   /**
1373    * @dev See {IERC721Metadata-symbol}.
1374    */
1375   function symbol() public view virtual override returns (string memory) {
1376     return _symbol;
1377   }
1378 
1379   /**
1380    * @dev See {IERC721Metadata-tokenURI}.
1381    */
1382   function tokenURI(uint256 tokenId)
1383     public
1384     view
1385     virtual
1386     override
1387     returns (string memory)
1388   {
1389     require(
1390       _exists(tokenId),
1391       "ERC721Metadata: URI query for nonexistent token"
1392     );
1393 
1394     string memory baseURI = _baseURI();
1395     return
1396       bytes(baseURI).length > 0
1397         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1398         : "";
1399   }
1400 
1401   /**
1402    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1403    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1404    * by default, can be overriden in child contracts.
1405    */
1406   function _baseURI() internal view virtual returns (string memory) {
1407     return "";
1408   }
1409 
1410   /**
1411    * @dev See {IERC721-approve}.
1412    */
1413   function approve(address to, uint256 tokenId) public override {
1414     address owner = ERC721A.ownerOf(tokenId);
1415     require(to != owner, "ERC721A: approval to current owner");
1416 
1417     require(
1418       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1419       "ERC721A: approve caller is not owner nor approved for all"
1420     );
1421 
1422     _approve(to, tokenId, owner);
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-getApproved}.
1427    */
1428   function getApproved(uint256 tokenId) public view override returns (address) {
1429     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1430 
1431     return _tokenApprovals[tokenId];
1432   }
1433 
1434   /**
1435    * @dev See {IERC721-setApprovalForAll}.
1436    */
1437   function setApprovalForAll(address operator, bool approved) public override {
1438     require(operator != _msgSender(), "ERC721A: approve to caller");
1439 
1440     _operatorApprovals[_msgSender()][operator] = approved;
1441     emit ApprovalForAll(_msgSender(), operator, approved);
1442   }
1443 
1444   /**
1445    * @dev See {IERC721-isApprovedForAll}.
1446    */
1447   function isApprovedForAll(address owner, address operator)
1448     public
1449     view
1450     virtual
1451     override
1452     returns (bool)
1453   {
1454     return _operatorApprovals[owner][operator];
1455   }
1456 
1457   /**
1458    * @dev See {IERC721-transferFrom}.
1459    */
1460   function transferFrom(
1461     address from,
1462     address to,
1463     uint256 tokenId
1464   ) public override {
1465     _transfer(from, to, tokenId);
1466   }
1467 
1468   /**
1469    * @dev See {IERC721-safeTransferFrom}.
1470    */
1471   function safeTransferFrom(
1472     address from,
1473     address to,
1474     uint256 tokenId
1475   ) public override {
1476     safeTransferFrom(from, to, tokenId, "");
1477   }
1478 
1479   /**
1480    * @dev See {IERC721-safeTransferFrom}.
1481    */
1482   function safeTransferFrom(
1483     address from,
1484     address to,
1485     uint256 tokenId,
1486     bytes memory _data
1487   ) public override {
1488     _transfer(from, to, tokenId);
1489     require(
1490       _checkOnERC721Received(from, to, tokenId, _data),
1491       "ERC721A: transfer to non ERC721Receiver implementer"
1492     );
1493   }
1494 
1495   /**
1496    * @dev Returns whether `tokenId` exists.
1497    *
1498    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1499    *
1500    * Tokens start existing when they are minted (`_mint`),
1501    */
1502   function _exists(uint256 tokenId) internal view returns (bool) {
1503     return tokenId < currentIndex;
1504   }
1505 
1506   function _safeMint(address to, uint256 quantity) internal {
1507     _safeMint(to, quantity, "");
1508   }
1509 
1510   /**
1511    * @dev Mints `quantity` tokens and transfers them to `to`.
1512    *
1513    * Requirements:
1514    *
1515    * - there must be `quantity` tokens remaining unminted in the total collection.
1516    * - `to` cannot be the zero address.
1517    * - `quantity` cannot be larger than the max batch size.
1518    *
1519    * Emits a {Transfer} event.
1520    */
1521   function _safeMint(
1522     address to,
1523     uint256 quantity,
1524     bytes memory _data
1525   ) internal {
1526     uint256 startTokenId = currentIndex;
1527     require(to != address(0), "ERC721A: mint to the zero address");
1528     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1529     require(!_exists(startTokenId), "ERC721A: token already minted");
1530     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1531 
1532     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1533 
1534     AddressData memory addressData = _addressData[to];
1535     _addressData[to] = AddressData(
1536       addressData.balance + uint128(quantity),
1537       addressData.numberMinted + uint128(quantity)
1538     );
1539     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1540 
1541     uint256 updatedIndex = startTokenId;
1542 
1543     for (uint256 i = 0; i < quantity; i++) {
1544       emit Transfer(address(0), to, updatedIndex);
1545       require(
1546         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1547         "ERC721A: transfer to non ERC721Receiver implementer"
1548       );
1549       updatedIndex++;
1550     }
1551 
1552     currentIndex = updatedIndex;
1553     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1554   }
1555 
1556   /**
1557    * @dev Transfers `tokenId` from `from` to `to`.
1558    *
1559    * Requirements:
1560    *
1561    * - `to` cannot be the zero address.
1562    * - `tokenId` token must be owned by `from`.
1563    *
1564    * Emits a {Transfer} event.
1565    */
1566   function _transfer(
1567     address from,
1568     address to,
1569     uint256 tokenId
1570   ) private {
1571     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1572 
1573     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1574       getApproved(tokenId) == _msgSender() ||
1575       isApprovedForAll(prevOwnership.addr, _msgSender()));
1576 
1577     require(
1578       isApprovedOrOwner,
1579       "ERC721A: transfer caller is not owner nor approved"
1580     );
1581 
1582     require(
1583       prevOwnership.addr == from,
1584       "ERC721A: transfer from incorrect owner"
1585     );
1586     require(to != address(0), "ERC721A: transfer to the zero address");
1587 
1588     _beforeTokenTransfers(from, to, tokenId, 1);
1589 
1590     // Clear approvals from the previous owner
1591     _approve(address(0), tokenId, prevOwnership.addr);
1592 
1593     _addressData[from].balance -= 1;
1594     _addressData[to].balance += 1;
1595     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1596 
1597     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1598     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1599     uint256 nextTokenId = tokenId + 1;
1600     if (_ownerships[nextTokenId].addr == address(0)) {
1601       if (_exists(nextTokenId)) {
1602         _ownerships[nextTokenId] = TokenOwnership(
1603           prevOwnership.addr,
1604           prevOwnership.startTimestamp
1605         );
1606       }
1607     }
1608 
1609     emit Transfer(from, to, tokenId);
1610     _afterTokenTransfers(from, to, tokenId, 1);
1611   }
1612 
1613   /**
1614    * @dev Approve `to` to operate on `tokenId`
1615    *
1616    * Emits a {Approval} event.
1617    */
1618   function _approve(
1619     address to,
1620     uint256 tokenId,
1621     address owner
1622   ) private {
1623     _tokenApprovals[tokenId] = to;
1624     emit Approval(owner, to, tokenId);
1625   }
1626 
1627   uint256 public nextOwnerToExplicitlySet = 0;
1628 
1629   /**
1630    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1631    */
1632   function _setOwnersExplicit(uint256 quantity) internal {
1633     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1634     require(quantity > 0, "quantity must be nonzero");
1635     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1636     if (endIndex > collectionSize - 1) {
1637       endIndex = collectionSize - 1;
1638     }
1639     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1640     require(_exists(endIndex), "not enough minted yet for this cleanup");
1641     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1642       if (_ownerships[i].addr == address(0)) {
1643         TokenOwnership memory ownership = ownershipOf(i);
1644         _ownerships[i] = TokenOwnership(
1645           ownership.addr,
1646           ownership.startTimestamp
1647         );
1648       }
1649     }
1650     nextOwnerToExplicitlySet = endIndex + 1;
1651   }
1652 
1653   /**
1654    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1655    * The call is not executed if the target address is not a contract.
1656    *
1657    * @param from address representing the previous owner of the given token ID
1658    * @param to target address that will receive the tokens
1659    * @param tokenId uint256 ID of the token to be transferred
1660    * @param _data bytes optional data to send along with the call
1661    * @return bool whether the call correctly returned the expected magic value
1662    */
1663   function _checkOnERC721Received(
1664     address from,
1665     address to,
1666     uint256 tokenId,
1667     bytes memory _data
1668   ) private returns (bool) {
1669     if (to.isContract()) {
1670       try
1671         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1672       returns (bytes4 retval) {
1673         return retval == IERC721Receiver(to).onERC721Received.selector;
1674       } catch (bytes memory reason) {
1675         if (reason.length == 0) {
1676           revert("ERC721A: transfer to non ERC721Receiver implementer");
1677         } else {
1678           assembly {
1679             revert(add(32, reason), mload(reason))
1680           }
1681         }
1682       }
1683     } else {
1684       return true;
1685     }
1686   }
1687 
1688   /**
1689    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1690    *
1691    * startTokenId - the first token id to be transferred
1692    * quantity - the amount to be transferred
1693    *
1694    * Calling conditions:
1695    *
1696    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1697    * transferred to `to`.
1698    * - When `from` is zero, `tokenId` will be minted for `to`.
1699    */
1700   function _beforeTokenTransfers(
1701     address from,
1702     address to,
1703     uint256 startTokenId,
1704     uint256 quantity
1705   ) internal virtual {}
1706 
1707   /**
1708    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1709    * minting.
1710    *
1711    * startTokenId - the first token id to be transferred
1712    * quantity - the amount to be transferred
1713    *
1714    * Calling conditions:
1715    *
1716    * - when `from` and `to` are both non-zero.
1717    * - `from` and `to` are never both zero.
1718    */
1719   function _afterTokenTransfers(
1720     address from,
1721     address to,
1722     uint256 startTokenId,
1723     uint256 quantity
1724   ) internal virtual {}
1725 }
1726 
1727 //SPDX-License-Identifier: MIT
1728 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1729 
1730 pragma solidity ^0.8.0;
1731 
1732 contract BODAPASS is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1733     using Counters for Counters.Counter;
1734     using Strings for uint256;
1735 
1736     Counters.Counter private tokenCounter;
1737 
1738     string private baseURI = "ipfs://QmbEN8rzswKhffiKKM2mEmpiPbPzkPbKjsv4dGcH87ReTx";
1739     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1740     bool private isOpenSeaProxyActive = true;
1741 
1742     uint256 public constant MAX_MINTS_PER_TX = 5;
1743     uint256 public maxSupply = 1000;
1744 
1745     uint256 public constant PUBLIC_SALE_PRICE = 0.02 ether;
1746     uint256 public NUM_FREE_MINTS = 0;
1747     bool public isPublicSaleActive = true;
1748 
1749 
1750 
1751 
1752     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1753 
1754     modifier publicSaleActive() {
1755         require(isPublicSaleActive, "Public sale is not open");
1756         _;
1757     }
1758 
1759 
1760 
1761     modifier maxMintsPerTX(uint256 numberOfTokens) {
1762         require(
1763             numberOfTokens <= MAX_MINTS_PER_TX,
1764             "Max mints per transaction exceeded"
1765         );
1766         _;
1767     }
1768 
1769     modifier canMintNFTs(uint256 numberOfTokens) {
1770         require(
1771             totalSupply() + numberOfTokens <=
1772                 maxSupply,
1773             "Not enough mints remaining to mint"
1774         );
1775         _;
1776     }
1777 
1778     modifier freeMintsAvailable() {
1779         require(
1780             totalSupply() <=
1781                 NUM_FREE_MINTS,
1782             "Not enough free mints remain"
1783         );
1784         _;
1785     }
1786 
1787 
1788 
1789     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1790         if(totalSupply()>NUM_FREE_MINTS){
1791         require(
1792             (price * numberOfTokens) == msg.value,
1793             "Incorrect ETH value sent"
1794         );
1795         }
1796         _;
1797     }
1798 
1799 
1800     constructor(
1801     ) ERC721A("[B]ODA PASS", "[B]ODA", 100, maxSupply) {
1802     }
1803 
1804     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1805 
1806     function mint(uint256 numberOfTokens)
1807         external
1808         payable
1809         nonReentrant
1810         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1811         publicSaleActive
1812         canMintNFTs(numberOfTokens)
1813         maxMintsPerTX(numberOfTokens)
1814     {
1815 
1816         _safeMint(msg.sender, numberOfTokens);
1817     }
1818 
1819 
1820 
1821     //A simple free mint function to avoid confusion
1822     //The normal mint function with a cost of 0 would work too
1823 
1824     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1825 
1826     function getBaseURI() external view returns (string memory) {
1827         return baseURI;
1828     }
1829 
1830     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1831 
1832     function setBaseURI(string memory _baseURI) external onlyOwner {
1833         baseURI = _baseURI;
1834     }
1835 
1836     // function to disable gasless listings for security in case
1837     // opensea ever shuts down or is compromised
1838     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1839         external
1840         onlyOwner
1841     {
1842         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1843     }
1844 
1845     function setIsPublicSaleActive(bool _isPublicSaleActive)
1846         external
1847         onlyOwner
1848     {
1849         isPublicSaleActive = _isPublicSaleActive;
1850     }
1851 
1852 
1853     function mints(uint256 _numfreemints)
1854         external
1855         onlyOwner
1856     {
1857         NUM_FREE_MINTS = _numfreemints;
1858     }
1859 
1860 
1861     function withdraw() public onlyOwner {
1862         uint256 balance = address(this).balance;
1863         payable(msg.sender).transfer(balance);
1864     }
1865 
1866     function withdrawTokens(IERC20 token) public onlyOwner {
1867         uint256 balance = token.balanceOf(address(this));
1868         token.transfer(msg.sender, balance);
1869     }
1870 
1871 
1872 
1873     // ============ SUPPORTING FUNCTIONS ============
1874 
1875     function nextTokenId() private returns (uint256) {
1876         tokenCounter.increment();
1877         return tokenCounter.current();
1878     }
1879 
1880     // ============ FUNCTION OVERRIDES ============
1881 
1882     function supportsInterface(bytes4 interfaceId)
1883         public
1884         view
1885         virtual
1886         override(ERC721A, IERC165)
1887         returns (bool)
1888     {
1889         return
1890             interfaceId == type(IERC2981).interfaceId ||
1891             super.supportsInterface(interfaceId);
1892     }
1893 
1894     /**
1895      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1896      */
1897     function isApprovedForAll(address owner, address operator)
1898         public
1899         view
1900         override
1901         returns (bool)
1902     {
1903         // Get a reference to OpenSea's proxy registry contract by instantiating
1904         // the contract using the already existing address.
1905         ProxyRegistry proxyRegistry = ProxyRegistry(
1906             openSeaProxyRegistryAddress
1907         );
1908         if (
1909             isOpenSeaProxyActive &&
1910             address(proxyRegistry.proxies(owner)) == operator
1911         ) {
1912             return true;
1913         }
1914 
1915         return super.isApprovedForAll(owner, operator);
1916     }
1917 
1918     /**
1919      * @dev See {IERC721Metadata-tokenURI}.
1920      */
1921     function tokenURI(uint256 tokenId)
1922         public
1923         view
1924         virtual
1925         override
1926         returns (string memory)
1927     {
1928         require(_exists(tokenId), "Nonexistent token");
1929 
1930         return
1931             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1932     }
1933 
1934     /**
1935      * @dev See {IERC165-royaltyInfo}.
1936      */
1937     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1938         external
1939         view
1940         override
1941         returns (address receiver, uint256 royaltyAmount)
1942     {
1943         require(_exists(tokenId), "Nonexistent token");
1944 
1945         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1946     }
1947 }
1948 
1949 // These contract definitions are used to create a reference to the OpenSea
1950 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1951 contract OwnableDelegateProxy {
1952 
1953 }
1954 
1955 contract ProxyRegistry {
1956     mapping(address => OwnableDelegateProxy) public proxies;
1957 }