1 /*                
2 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
3 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
4 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
5 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
6 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
7 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
8 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
9 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
10 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
11 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
12 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
13 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
14 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
15 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxddoolllllllllooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
16 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdolcccclloooddddddddoollc:ccldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
17 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxdoc:cloxk0XNWWMMMMMMMMMMMMWNX0kdoc::ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
18 xxxxxxxxxxxxxxxxxxxxxxxxxxxxxdl::ldOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMNKxoc:ldxxxxxxxxxxxxxxxxxxxxxxxxxxx
19 xxxxxxxxxxxxxxxxxxxxxxxxxxxoc:lxKWMMMMMMMMMMWMMMMMMMMMMMMMMMMWXXWMMMWXkl:coxxxxxxxxxxxxxxxxxxxxxxxxx
20 xxxxxxxxxxxxxxxxxxxxxxxxxo::o0WMMMMMMMMMMMWOlkWMMMMMMMMMMMMMM0:;0MMMMMMW0o::oxxxxxxxxxxxxxxxxxxxxxxx
21 xxxxxxxxxxxxxxxxxxxxxxxdc;oKWMMMMMMMMMMMMMW0d0WMMMMMMMMMMMMMMXdxXMMMMMMMMW0l;ldxxxxxxxxxxxxxxxxxxxxx
22 xxxxxxxxxxxxxxxxxxxxxxo;c0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk::oxxxxxxxxxxxxxxxxxxxx
23 xxxxxxxxxxxxxxxxxxxxxl;oXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKl;lxxxxxxxxxxxxxxxxxxx
24 xxxxxxxxxxxxxxxxxxxxl;oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNd;lxxxxxxxxxxxxxxxxxx
25 xxxxxxxxxxxxxxxxxxxo;lNMMMMMMMMMMMMMMMMMMMMMMN00KKXXNWWMMMMMMMMMMMMMMMMMMMMMMMMNd,lxxxxxxxxxxxxxxxxx
26 xxxxxxxxxxxxxxxxxxd;:KMMMMMMMMMMMMMMMMMMMMMMMNOxxddddddddddxxkOO0KKXXNNNWWWWWWWNx,cxxxxxxxxxxxxxxxxx
27 xxxxxxxxxxxxxxxxxxl,xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNXK0Okkxxxddddl::llllllllc:cdxxxxxxxxxxxxxxxxx
28 xxxxxxxxxxxxxxxxxd;:KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk;cdddddddddxxxxxxxxxxxxxxxxxxxx
29 xxxxxxxxxxxxxxxxxo,lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx;lxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
30 xxxxxxxxxxxxxxxxxl,xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
31 xxxxxxxxxxxxxxxxxc,kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
32 xxxxxxxxxxxxxxxxxc;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
33 xxxxxxxxxxxxxxxxxc;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
34 xxxxxxxxxxxxxxxxxc;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
35 xxxxxxxxxxxxxxxxxc;kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
36 xxxxxxxxxxxxxxxxxl,xMMMMMMMMMMWkkWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
37 xxxxxxxxxxxxxxxxxl,dWMMMMMMMMMXloWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,oxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
38 xxxxxxxxxxxxxxxxxo,oWMMMMMMMMMKcdWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,lxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
39 xxxxxxxxxxxxxxxxxo,oNMMMMMMMMMK:dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMx,lxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
40 xxxxxxxxxxxxxxxxxd;lNMMMMMMMMM0:xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk,lxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
41 xxxxxxxxxxxxxxxxxd;cXMMMMMMMMM0:xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMk;cxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
42 xxxxxxxxxxxxxxxxxx::KMMMMMMMMM0:xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO;cxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
43 xxxxxxxxxxxxxxxxxx:;0MMMMMMMMMK:dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0;:xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
44 xxxxxxxxxxxxxxxxxxc;OMMMMMMMMMKcoWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK::xxxxxxxxxxxxxxxxxxxxxxxxxxxxx
45 xxxxxxxxxxxxxxxxxxc;kMMMMMMMMMNxkWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMK:;dxxxxxxxxxxxxxxxxxxxxxxxxxxxx
46 xxxxxxxxxxxxxxxxxxc,kMMMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXc;dxxxxxxxxxxxxxxxxxxxxxxxxxxxx
47 xxxxxxxxxxxxxxxxxxl,kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNl;dxxxxxxxxxxxxxxxxxxxxxxxxxxxx
48 xxxxxxxxxxxxxxxxxxl,xMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWo,oxxxxxxxxxxxxxxxxxxxxxxxxxxxx
49 xxxxxxxxxxxxxxxxxxl,xMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,oxxxxxxxxxxxxxxxxxxxxxxxxxxxx
50 xxxxxxxxxxxxxxxxxxl,xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWd,lxxxxxxxxxxxxxxxxxxxxxxxxxxxx
51 xxxxxxxxxxxxxxxxxxl,xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx,lxxxxxxxxxxxxxxxxxxxxxxxxxxxx  
52 */
53 
54 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
55 
56 
57 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
58 
59 pragma solidity ^0.8.0;
60 
61 // CAUTION
62 // This version of SafeMath should only be used with Solidity 0.8 or later,
63 // because it relies on the compiler's built in overflow checks.
64 
65 /**
66  * @dev Wrappers over Solidity's arithmetic operations.
67  *
68  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
69  * now has built in overflow checking.
70  */
71 library SafeMath {
72     /**
73      * @dev Returns the addition of two unsigned integers, with an overflow flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             uint256 c = a + b;
80             if (c < a) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     /**
86      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b > a) return (false, 0);
93             return (true, a - b);
94         }
95     }
96 
97     /**
98      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105             // benefit is lost if 'b' is also tested.
106             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107             if (a == 0) return (true, 0);
108             uint256 c = a * b;
109             if (c / a != b) return (false, 0);
110             return (true, c);
111         }
112     }
113 
114     /**
115      * @dev Returns the division of two unsigned integers, with a division by zero flag.
116      *
117      * _Available since v3.4._
118      */
119     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
120         unchecked {
121             if (b == 0) return (false, 0);
122             return (true, a / b);
123         }
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         unchecked {
133             if (b == 0) return (false, 0);
134             return (true, a % b);
135         }
136     }
137 
138     /**
139      * @dev Returns the addition of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `+` operator.
143      *
144      * Requirements:
145      *
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a + b;
150     }
151 
152     /**
153      * @dev Returns the subtraction of two unsigned integers, reverting on
154      * overflow (when the result is negative).
155      *
156      * Counterpart to Solidity's `-` operator.
157      *
158      * Requirements:
159      *
160      * - Subtraction cannot overflow.
161      */
162     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a - b;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         return a * b;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator.
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b) internal pure returns (uint256) {
191         return a / b;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * reverting when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a % b;
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
212      * overflow (when the result is negative).
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {trySub}.
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         unchecked {
229             require(b <= a, errorMessage);
230             return a - b;
231         }
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(
247         uint256 a,
248         uint256 b,
249         string memory errorMessage
250     ) internal pure returns (uint256) {
251         unchecked {
252             require(b > 0, errorMessage);
253             return a / b;
254         }
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * reverting with custom message when dividing by zero.
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {tryMod}.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(
273         uint256 a,
274         uint256 b,
275         string memory errorMessage
276     ) internal pure returns (uint256) {
277         unchecked {
278             require(b > 0, errorMessage);
279             return a % b;
280         }
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/Counters.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @title Counters
293  * @author Matt Condon (@shrugs)
294  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
295  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
296  *
297  * Include with `using Counters for Counters.Counter;`
298  */
299 library Counters {
300     struct Counter {
301         // This variable should never be directly accessed by users of the library: interactions must be restricted to
302         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
303         // this feature: see https://github.com/ethereum/solidity/issues/4637
304         uint256 _value; // default: 0
305     }
306 
307     function current(Counter storage counter) internal view returns (uint256) {
308         return counter._value;
309     }
310 
311     function increment(Counter storage counter) internal {
312         unchecked {
313             counter._value += 1;
314         }
315     }
316 
317     function decrement(Counter storage counter) internal {
318         uint256 value = counter._value;
319         require(value > 0, "Counter: decrement overflow");
320         unchecked {
321             counter._value = value - 1;
322         }
323     }
324 
325     function reset(Counter storage counter) internal {
326         counter._value = 0;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Contract module that helps prevent reentrant calls to a function.
339  *
340  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
341  * available, which can be applied to functions to make sure there are no nested
342  * (reentrant) calls to them.
343  *
344  * Note that because there is a single `nonReentrant` guard, functions marked as
345  * `nonReentrant` may not call one another. This can be worked around by making
346  * those functions `private`, and then adding `external` `nonReentrant` entry
347  * points to them.
348  *
349  * TIP: If you would like to learn more about reentrancy and alternative ways
350  * to protect against it, check out our blog post
351  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
352  */
353 abstract contract ReentrancyGuard {
354     // Booleans are more expensive than uint256 or any type that takes up a full
355     // word because each write operation emits an extra SLOAD to first read the
356     // slot's contents, replace the bits taken up by the boolean, and then write
357     // back. This is the compiler's defense against contract upgrades and
358     // pointer aliasing, and it cannot be disabled.
359 
360     // The values being non-zero value makes deployment a bit more expensive,
361     // but in exchange the refund on every call to nonReentrant will be lower in
362     // amount. Since refunds are capped to a percentage of the total
363     // transaction's gas, it is best to keep them low in cases like this one, to
364     // increase the likelihood of the full refund coming into effect.
365     uint256 private constant _NOT_ENTERED = 1;
366     uint256 private constant _ENTERED = 2;
367 
368     uint256 private _status;
369 
370     constructor() {
371         _status = _NOT_ENTERED;
372     }
373 
374     /**
375      * @dev Prevents a contract from calling itself, directly or indirectly.
376      * Calling a `nonReentrant` function from another `nonReentrant`
377      * function is not supported. It is possible to prevent this from happening
378      * by making the `nonReentrant` function external, and making it call a
379      * `private` function that does the actual work.
380      */
381     modifier nonReentrant() {
382         // On the first call to nonReentrant, _notEntered will be true
383         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
384 
385         // Any calls to nonReentrant after this point will fail
386         _status = _ENTERED;
387 
388         _;
389 
390         // By storing the original value once again, a refund is triggered (see
391         // https://eips.ethereum.org/EIPS/eip-2200)
392         _status = _NOT_ENTERED;
393     }
394 }
395 
396 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
397 
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Interface of the ERC20 standard as defined in the EIP.
405  */
406 interface IERC20 {
407     /**
408      * @dev Returns the amount of tokens in existence.
409      */
410     function totalSupply() external view returns (uint256);
411 
412     /**
413      * @dev Returns the amount of tokens owned by `account`.
414      */
415     function balanceOf(address account) external view returns (uint256);
416 
417     /**
418      * @dev Moves `amount` tokens from the caller's account to `recipient`.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transfer(address recipient, uint256 amount) external returns (bool);
425 
426     /**
427      * @dev Returns the remaining number of tokens that `spender` will be
428      * allowed to spend on behalf of `owner` through {transferFrom}. This is
429      * zero by default.
430      *
431      * This value changes when {approve} or {transferFrom} are called.
432      */
433     function allowance(address owner, address spender) external view returns (uint256);
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * IMPORTANT: Beware that changing an allowance with this method brings the risk
441      * that someone may use both the old and the new allowance by unfortunate
442      * transaction ordering. One possible solution to mitigate this race
443      * condition is to first reduce the spender's allowance to 0 and set the
444      * desired value afterwards:
445      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
446      *
447      * Emits an {Approval} event.
448      */
449     function approve(address spender, uint256 amount) external returns (bool);
450 
451     /**
452      * @dev Moves `amount` tokens from `sender` to `recipient` using the
453      * allowance mechanism. `amount` is then deducted from the caller's
454      * allowance.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address sender,
462         address recipient,
463         uint256 amount
464     ) external returns (bool);
465 
466     /**
467      * @dev Emitted when `value` tokens are moved from one account (`from`) to
468      * another (`to`).
469      *
470      * Note that `value` may be zero.
471      */
472     event Transfer(address indexed from, address indexed to, uint256 value);
473 
474     /**
475      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
476      * a call to {approve}. `value` is the new allowance.
477      */
478     event Approval(address indexed owner, address indexed spender, uint256 value);
479 }
480 
481 // File: @openzeppelin/contracts/interfaces/IERC20.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 // File: @openzeppelin/contracts/utils/Strings.sol
490 
491 
492 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
493 
494 pragma solidity ^0.8.0;
495 
496 /**
497  * @dev String operations.
498  */
499 library Strings {
500     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
501 
502     /**
503      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
504      */
505     function toString(uint256 value) internal pure returns (string memory) {
506         // Inspired by OraclizeAPI's implementation - MIT licence
507         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
508 
509         if (value == 0) {
510             return "0";
511         }
512         uint256 temp = value;
513         uint256 digits;
514         while (temp != 0) {
515             digits++;
516             temp /= 10;
517         }
518         bytes memory buffer = new bytes(digits);
519         while (value != 0) {
520             digits -= 1;
521             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
522             value /= 10;
523         }
524         return string(buffer);
525     }
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
529      */
530     function toHexString(uint256 value) internal pure returns (string memory) {
531         if (value == 0) {
532             return "0x00";
533         }
534         uint256 temp = value;
535         uint256 length = 0;
536         while (temp != 0) {
537             length++;
538             temp >>= 8;
539         }
540         return toHexString(value, length);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
545      */
546     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
547         bytes memory buffer = new bytes(2 * length + 2);
548         buffer[0] = "0";
549         buffer[1] = "x";
550         for (uint256 i = 2 * length + 1; i > 1; --i) {
551             buffer[i] = _HEX_SYMBOLS[value & 0xf];
552             value >>= 4;
553         }
554         require(value == 0, "Strings: hex length insufficient");
555         return string(buffer);
556     }
557 }
558 
559 // File: @openzeppelin/contracts/utils/Context.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Provides information about the current execution context, including the
568  * sender of the transaction and its data. While these are generally available
569  * via msg.sender and msg.data, they should not be accessed in such a direct
570  * manner, since when dealing with meta-transactions the account sending and
571  * paying for execution may not be the actual sender (as far as an application
572  * is concerned).
573  *
574  * This contract is only required for intermediate, library-like contracts.
575  */
576 abstract contract Context {
577     function _msgSender() internal view virtual returns (address) {
578         return msg.sender;
579     }
580 
581     function _msgData() internal view virtual returns (bytes calldata) {
582         return msg.data;
583     }
584 }
585 
586 // File: @openzeppelin/contracts/access/Ownable.sol
587 
588 
589 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
590 
591 pragma solidity ^0.8.0;
592 
593 
594 /**
595  * @dev Contract module which provides a basic access control mechanism, where
596  * there is an account (an owner) that can be granted exclusive access to
597  * specific functions.
598  *
599  * By default, the owner account will be the one that deploys the contract. This
600  * can later be changed with {transferOwnership}.
601  *
602  * This module is used through inheritance. It will make available the modifier
603  * `onlyOwner`, which can be applied to your functions to restrict their use to
604  * the owner.
605  */
606 abstract contract Ownable is Context {
607     address private _owner;
608 
609     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
610 
611     /**
612      * @dev Initializes the contract setting the deployer as the initial owner.
613      */
614     constructor() {
615         _transferOwnership(_msgSender());
616     }
617 
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view virtual returns (address) {
622         return _owner;
623     }
624 
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(owner() == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632 
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         _transferOwnership(address(0));
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      * Can only be called by the current owner.
647      */
648     function transferOwnership(address newOwner) public virtual onlyOwner {
649         require(newOwner != address(0), "Ownable: new owner is the zero address");
650         _transferOwnership(newOwner);
651     }
652 
653     /**
654      * @dev Transfers ownership of the contract to a new account (`newOwner`).
655      * Internal function without access restriction.
656      */
657     function _transferOwnership(address newOwner) internal virtual {
658         address oldOwner = _owner;
659         _owner = newOwner;
660         emit OwnershipTransferred(oldOwner, newOwner);
661     }
662 }
663 
664 // File: @openzeppelin/contracts/utils/Address.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev Collection of functions related to the address type
673  */
674 library Address {
675     /**
676      * @dev Returns true if `account` is a contract.
677      *
678      * [IMPORTANT]
679      * ====
680      * It is unsafe to assume that an address for which this function returns
681      * false is an externally-owned account (EOA) and not a contract.
682      *
683      * Among others, `isContract` will return false for the following
684      * types of addresses:
685      *
686      *  - an externally-owned account
687      *  - a contract in construction
688      *  - an address where a contract will be created
689      *  - an address where a contract lived, but was destroyed
690      * ====
691      */
692     function isContract(address account) internal view returns (bool) {
693         // This method relies on extcodesize, which returns 0 for contracts in
694         // construction, since the code is only stored at the end of the
695         // constructor execution.
696 
697         uint256 size;
698         assembly {
699             size := extcodesize(account)
700         }
701         return size > 0;
702     }
703 
704     /**
705      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
706      * `recipient`, forwarding all available gas and reverting on errors.
707      *
708      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
709      * of certain opcodes, possibly making contracts go over the 2300 gas limit
710      * imposed by `transfer`, making them unable to receive funds via
711      * `transfer`. {sendValue} removes this limitation.
712      *
713      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
714      *
715      * IMPORTANT: because control is transferred to `recipient`, care must be
716      * taken to not create reentrancy vulnerabilities. Consider using
717      * {ReentrancyGuard} or the
718      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
719      */
720     function sendValue(address payable recipient, uint256 amount) internal {
721         require(address(this).balance >= amount, "Address: insufficient balance");
722 
723         (bool success, ) = recipient.call{value: amount}("");
724         require(success, "Address: unable to send value, recipient may have reverted");
725     }
726 
727     /**
728      * @dev Performs a Solidity function call using a low level `call`. A
729      * plain `call` is an unsafe replacement for a function call: use this
730      * function instead.
731      *
732      * If `target` reverts with a revert reason, it is bubbled up by this
733      * function (like regular Solidity function calls).
734      *
735      * Returns the raw returned data. To convert to the expected return value,
736      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
737      *
738      * Requirements:
739      *
740      * - `target` must be a contract.
741      * - calling `target` with `data` must not revert.
742      *
743      * _Available since v3.1._
744      */
745     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
746         return functionCall(target, data, "Address: low-level call failed");
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
751      * `errorMessage` as a fallback revert reason when `target` reverts.
752      *
753      * _Available since v3.1._
754      */
755     function functionCall(
756         address target,
757         bytes memory data,
758         string memory errorMessage
759     ) internal returns (bytes memory) {
760         return functionCallWithValue(target, data, 0, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but also transferring `value` wei to `target`.
766      *
767      * Requirements:
768      *
769      * - the calling contract must have an ETH balance of at least `value`.
770      * - the called Solidity function must be `payable`.
771      *
772      * _Available since v3.1._
773      */
774     function functionCallWithValue(
775         address target,
776         bytes memory data,
777         uint256 value
778     ) internal returns (bytes memory) {
779         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
784      * with `errorMessage` as a fallback revert reason when `target` reverts.
785      *
786      * _Available since v3.1._
787      */
788     function functionCallWithValue(
789         address target,
790         bytes memory data,
791         uint256 value,
792         string memory errorMessage
793     ) internal returns (bytes memory) {
794         require(address(this).balance >= value, "Address: insufficient balance for call");
795         require(isContract(target), "Address: call to non-contract");
796 
797         (bool success, bytes memory returndata) = target.call{value: value}(data);
798         return verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     /**
802      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
803      * but performing a static call.
804      *
805      * _Available since v3.3._
806      */
807     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
808         return functionStaticCall(target, data, "Address: low-level static call failed");
809     }
810 
811     /**
812      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
813      * but performing a static call.
814      *
815      * _Available since v3.3._
816      */
817     function functionStaticCall(
818         address target,
819         bytes memory data,
820         string memory errorMessage
821     ) internal view returns (bytes memory) {
822         require(isContract(target), "Address: static call to non-contract");
823 
824         (bool success, bytes memory returndata) = target.staticcall(data);
825         return verifyCallResult(success, returndata, errorMessage);
826     }
827 
828     /**
829      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
830      * but performing a delegate call.
831      *
832      * _Available since v3.4._
833      */
834     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
835         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
836     }
837 
838     /**
839      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
840      * but performing a delegate call.
841      *
842      * _Available since v3.4._
843      */
844     function functionDelegateCall(
845         address target,
846         bytes memory data,
847         string memory errorMessage
848     ) internal returns (bytes memory) {
849         require(isContract(target), "Address: delegate call to non-contract");
850 
851         (bool success, bytes memory returndata) = target.delegatecall(data);
852         return verifyCallResult(success, returndata, errorMessage);
853     }
854 
855     /**
856      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
857      * revert reason using the provided one.
858      *
859      * _Available since v4.3._
860      */
861     function verifyCallResult(
862         bool success,
863         bytes memory returndata,
864         string memory errorMessage
865     ) internal pure returns (bytes memory) {
866         if (success) {
867             return returndata;
868         } else {
869             // Look for revert reason and bubble it up if present
870             if (returndata.length > 0) {
871                 // The easiest way to bubble the revert reason is using memory via assembly
872 
873                 assembly {
874                     let returndata_size := mload(returndata)
875                     revert(add(32, returndata), returndata_size)
876                 }
877             } else {
878                 revert(errorMessage);
879             }
880         }
881     }
882 }
883 
884 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 /**
892  * @title ERC721 token receiver interface
893  * @dev Interface for any contract that wants to support safeTransfers
894  * from ERC721 asset contracts.
895  */
896 interface IERC721Receiver {
897     /**
898      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
899      * by `operator` from `from`, this function is called.
900      *
901      * It must return its Solidity selector to confirm the token transfer.
902      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
903      *
904      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
905      */
906     function onERC721Received(
907         address operator,
908         address from,
909         uint256 tokenId,
910         bytes calldata data
911     ) external returns (bytes4);
912 }
913 
914 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Interface of the ERC165 standard, as defined in the
923  * https://eips.ethereum.org/EIPS/eip-165[EIP].
924  *
925  * Implementers can declare support of contract interfaces, which can then be
926  * queried by others ({ERC165Checker}).
927  *
928  * For an implementation, see {ERC165}.
929  */
930 interface IERC165 {
931     /**
932      * @dev Returns true if this contract implements the interface defined by
933      * `interfaceId`. See the corresponding
934      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
935      * to learn more about how these ids are created.
936      *
937      * This function call must use less than 30 000 gas.
938      */
939     function supportsInterface(bytes4 interfaceId) external view returns (bool);
940 }
941 
942 // File: @openzeppelin/contracts/interfaces/IERC165.sol
943 
944 
945 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 
950 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
951 
952 
953 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
954 
955 pragma solidity ^0.8.0;
956 
957 
958 /**
959  * @dev Interface for the NFT Royalty Standard
960  */
961 interface IERC2981 is IERC165 {
962     /**
963      * @dev Called with the sale price to determine how much royalty is owed and to whom.
964      * @param tokenId - the NFT asset queried for royalty information
965      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
966      * @return receiver - address of who should be sent the royalty payment
967      * @return royaltyAmount - the royalty payment amount for `salePrice`
968      */
969     function royaltyInfo(uint256 tokenId, uint256 salePrice)
970         external
971         view
972         returns (address receiver, uint256 royaltyAmount);
973 }
974 
975 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
976 
977 
978 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
979 
980 pragma solidity ^0.8.0;
981 
982 
983 /**
984  * @dev Implementation of the {IERC165} interface.
985  *
986  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
987  * for the additional interface id that will be supported. For example:
988  *
989  * ```solidity
990  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
991  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
992  * }
993  * ```
994  *
995  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
996  */
997 abstract contract ERC165 is IERC165 {
998     /**
999      * @dev See {IERC165-supportsInterface}.
1000      */
1001     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1002         return interfaceId == type(IERC165).interfaceId;
1003     }
1004 }
1005 
1006 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1007 
1008 
1009 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1010 
1011 pragma solidity ^0.8.0;
1012 
1013 
1014 /**
1015  * @dev Required interface of an ERC721 compliant contract.
1016  */
1017 interface IERC721 is IERC165 {
1018     /**
1019      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1020      */
1021     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1022 
1023     /**
1024      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1025      */
1026     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1027 
1028     /**
1029      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1030      */
1031     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1032 
1033     /**
1034      * @dev Returns the number of tokens in ``owner``'s account.
1035      */
1036     function balanceOf(address owner) external view returns (uint256 balance);
1037 
1038     /**
1039      * @dev Returns the owner of the `tokenId` token.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must exist.
1044      */
1045     function ownerOf(uint256 tokenId) external view returns (address owner);
1046 
1047     /**
1048      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1049      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1050      *
1051      * Requirements:
1052      *
1053      * - `from` cannot be the zero address.
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must exist and be owned by `from`.
1056      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1057      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1058      *
1059      * Emits a {Transfer} event.
1060      */
1061     function safeTransferFrom(
1062         address from,
1063         address to,
1064         uint256 tokenId
1065     ) external;
1066 
1067     /**
1068      * @dev Transfers `tokenId` token from `from` to `to`.
1069      *
1070      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1071      *
1072      * Requirements:
1073      *
1074      * - `from` cannot be the zero address.
1075      * - `to` cannot be the zero address.
1076      * - `tokenId` token must be owned by `from`.
1077      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) external;
1086 
1087     /**
1088      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1089      * The approval is cleared when the token is transferred.
1090      *
1091      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1092      *
1093      * Requirements:
1094      *
1095      * - The caller must own the token or be an approved operator.
1096      * - `tokenId` must exist.
1097      *
1098      * Emits an {Approval} event.
1099      */
1100     function approve(address to, uint256 tokenId) external;
1101 
1102     /**
1103      * @dev Returns the account approved for `tokenId` token.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function getApproved(uint256 tokenId) external view returns (address operator);
1110 
1111     /**
1112      * @dev Approve or remove `operator` as an operator for the caller.
1113      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1114      *
1115      * Requirements:
1116      *
1117      * - The `operator` cannot be the caller.
1118      *
1119      * Emits an {ApprovalForAll} event.
1120      */
1121     function setApprovalForAll(address operator, bool _approved) external;
1122 
1123     /**
1124      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1125      *
1126      * See {setApprovalForAll}
1127      */
1128     function isApprovedForAll(address owner, address operator) external view returns (bool);
1129 
1130     /**
1131      * @dev Safely transfers `tokenId` token from `from` to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must exist and be owned by `from`.
1138      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function safeTransferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId,
1147         bytes calldata data
1148     ) external;
1149 }
1150 
1151 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1152 
1153 
1154 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 
1159 /**
1160  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1161  * @dev See https://eips.ethereum.org/EIPS/eip-721
1162  */
1163 interface IERC721Enumerable is IERC721 {
1164     /**
1165      * @dev Returns the total amount of tokens stored by the contract.
1166      */
1167     function totalSupply() external view returns (uint256);
1168 
1169     /**
1170      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1171      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1172      */
1173     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1174 
1175     /**
1176      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1177      * Use along with {totalSupply} to enumerate all tokens.
1178      */
1179     function tokenByIndex(uint256 index) external view returns (uint256);
1180 }
1181 
1182 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1183 
1184 
1185 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 /**
1191  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1192  * @dev See https://eips.ethereum.org/EIPS/eip-721
1193  */
1194 interface IERC721Metadata is IERC721 {
1195     /**
1196      * @dev Returns the token collection name.
1197      */
1198     function name() external view returns (string memory);
1199 
1200     /**
1201      * @dev Returns the token collection symbol.
1202      */
1203     function symbol() external view returns (string memory);
1204 
1205     /**
1206      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1207      */
1208     function tokenURI(uint256 tokenId) external view returns (string memory);
1209 }
1210 
1211 // File: contracts/ERC721A.sol
1212 
1213 
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 
1219 
1220 
1221 
1222 
1223 
1224 
1225 /**
1226  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1227  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1228  *
1229  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1230  *
1231  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1232  *
1233  * Does not support burning tokens to address(0).
1234  */
1235 contract ERC721A is
1236   Context,
1237   ERC165,
1238   IERC721,
1239   IERC721Metadata,
1240   IERC721Enumerable
1241 {
1242   using Address for address;
1243   using Strings for uint256;
1244 
1245   struct TokenOwnership {
1246     address addr;
1247     uint64 startTimestamp;
1248   }
1249 
1250   struct AddressData {
1251     uint128 balance;
1252     uint128 numberMinted;
1253   }
1254 
1255   uint256 private currentIndex = 0;
1256 
1257   uint256 internal immutable collectionSize;
1258   uint256 internal immutable maxBatchSize;
1259 
1260   // Token name
1261   string private _name;
1262 
1263   // Token symbol
1264   string private _symbol;
1265 
1266   // Mapping from token ID to ownership details
1267   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1268   mapping(uint256 => TokenOwnership) private _ownerships;
1269 
1270   // Mapping owner address to address data
1271   mapping(address => AddressData) private _addressData;
1272 
1273   // Mapping from token ID to approved address
1274   mapping(uint256 => address) private _tokenApprovals;
1275 
1276   // Mapping from owner to operator approvals
1277   mapping(address => mapping(address => bool)) private _operatorApprovals;
1278 
1279   /**
1280    * @dev
1281    * `maxBatchSize` refers to how much a minter can mint at a time.
1282    * `collectionSize_` refers to how many tokens are in the collection.
1283    */
1284   constructor(
1285     string memory name_,
1286     string memory symbol_,
1287     uint256 maxBatchSize_,
1288     uint256 collectionSize_
1289   ) {
1290     require(
1291       collectionSize_ > 0,
1292       "ERC721A: collection must have a nonzero supply"
1293     );
1294     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1295     _name = name_;
1296     _symbol = symbol_;
1297     maxBatchSize = maxBatchSize_;
1298     collectionSize = collectionSize_;
1299   }
1300 
1301   /**
1302    * @dev See {IERC721Enumerable-totalSupply}.
1303    */
1304   function totalSupply() public view override returns (uint256) {
1305     return currentIndex;
1306   }
1307 
1308   /**
1309    * @dev See {IERC721Enumerable-tokenByIndex}.
1310    */
1311   function tokenByIndex(uint256 index) public view override returns (uint256) {
1312     require(index < totalSupply(), "ERC721A: global index out of bounds");
1313     return index;
1314   }
1315 
1316   /**
1317    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1318    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1319    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1320    */
1321   function tokenOfOwnerByIndex(address owner, uint256 index)
1322     public
1323     view
1324     override
1325     returns (uint256)
1326   {
1327     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1328     uint256 numMintedSoFar = totalSupply();
1329     uint256 tokenIdsIdx = 0;
1330     address currOwnershipAddr = address(0);
1331     for (uint256 i = 0; i < numMintedSoFar; i++) {
1332       TokenOwnership memory ownership = _ownerships[i];
1333       if (ownership.addr != address(0)) {
1334         currOwnershipAddr = ownership.addr;
1335       }
1336       if (currOwnershipAddr == owner) {
1337         if (tokenIdsIdx == index) {
1338           return i;
1339         }
1340         tokenIdsIdx++;
1341       }
1342     }
1343     revert("ERC721A: unable to get token of owner by index");
1344   }
1345 
1346   /**
1347    * @dev See {IERC165-supportsInterface}.
1348    */
1349   function supportsInterface(bytes4 interfaceId)
1350     public
1351     view
1352     virtual
1353     override(ERC165, IERC165)
1354     returns (bool)
1355   {
1356     return
1357       interfaceId == type(IERC721).interfaceId ||
1358       interfaceId == type(IERC721Metadata).interfaceId ||
1359       interfaceId == type(IERC721Enumerable).interfaceId ||
1360       super.supportsInterface(interfaceId);
1361   }
1362 
1363   /**
1364    * @dev See {IERC721-balanceOf}.
1365    */
1366   function balanceOf(address owner) public view override returns (uint256) {
1367     require(owner != address(0), "ERC721A: balance query for the zero address");
1368     return uint256(_addressData[owner].balance);
1369   }
1370 
1371   function _numberMinted(address owner) internal view returns (uint256) {
1372     require(
1373       owner != address(0),
1374       "ERC721A: number minted query for the zero address"
1375     );
1376     return uint256(_addressData[owner].numberMinted);
1377   }
1378 
1379   function ownershipOf(uint256 tokenId)
1380     internal
1381     view
1382     returns (TokenOwnership memory)
1383   {
1384     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1385 
1386     uint256 lowestTokenToCheck;
1387     if (tokenId >= maxBatchSize) {
1388       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1389     }
1390 
1391     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1392       TokenOwnership memory ownership = _ownerships[curr];
1393       if (ownership.addr != address(0)) {
1394         return ownership;
1395       }
1396     }
1397 
1398     revert("ERC721A: unable to determine the owner of token");
1399   }
1400 
1401   /**
1402    * @dev See {IERC721-ownerOf}.
1403    */
1404   function ownerOf(uint256 tokenId) public view override returns (address) {
1405     return ownershipOf(tokenId).addr;
1406   }
1407 
1408   /**
1409    * @dev See {IERC721Metadata-name}.
1410    */
1411   function name() public view virtual override returns (string memory) {
1412     return _name;
1413   }
1414 
1415   /**
1416    * @dev See {IERC721Metadata-symbol}.
1417    */
1418   function symbol() public view virtual override returns (string memory) {
1419     return _symbol;
1420   }
1421 
1422   /**
1423    * @dev See {IERC721Metadata-tokenURI}.
1424    */
1425   function tokenURI(uint256 tokenId)
1426     public
1427     view
1428     virtual
1429     override
1430     returns (string memory)
1431   {
1432     require(
1433       _exists(tokenId),
1434       "ERC721Metadata: URI query for nonexistent token"
1435     );
1436 
1437     string memory baseURI = _baseURI();
1438     return
1439       bytes(baseURI).length > 0
1440         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1441         : "";
1442   }
1443 
1444   /**
1445    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1446    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1447    * by default, can be overriden in child contracts.
1448    */
1449   function _baseURI() internal view virtual returns (string memory) {
1450     return "";
1451   }
1452 
1453   /**
1454    * @dev See {IERC721-approve}.
1455    */
1456   function approve(address to, uint256 tokenId) public override {
1457     address owner = ERC721A.ownerOf(tokenId);
1458     require(to != owner, "ERC721A: approval to current owner");
1459 
1460     require(
1461       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1462       "ERC721A: approve caller is not owner nor approved for all"
1463     );
1464 
1465     _approve(to, tokenId, owner);
1466   }
1467 
1468   /**
1469    * @dev See {IERC721-getApproved}.
1470    */
1471   function getApproved(uint256 tokenId) public view override returns (address) {
1472     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1473 
1474     return _tokenApprovals[tokenId];
1475   }
1476 
1477   /**
1478    * @dev See {IERC721-setApprovalForAll}.
1479    */
1480   function setApprovalForAll(address operator, bool approved) public override {
1481     require(operator != _msgSender(), "ERC721A: approve to caller");
1482 
1483     _operatorApprovals[_msgSender()][operator] = approved;
1484     emit ApprovalForAll(_msgSender(), operator, approved);
1485   }
1486 
1487   /**
1488    * @dev See {IERC721-isApprovedForAll}.
1489    */
1490   function isApprovedForAll(address owner, address operator)
1491     public
1492     view
1493     virtual
1494     override
1495     returns (bool)
1496   {
1497     return _operatorApprovals[owner][operator];
1498   }
1499 
1500   /**
1501    * @dev See {IERC721-transferFrom}.
1502    */
1503   function transferFrom(
1504     address from,
1505     address to,
1506     uint256 tokenId
1507   ) public override {
1508     _transfer(from, to, tokenId);
1509   }
1510 
1511   /**
1512    * @dev See {IERC721-safeTransferFrom}.
1513    */
1514   function safeTransferFrom(
1515     address from,
1516     address to,
1517     uint256 tokenId
1518   ) public override {
1519     safeTransferFrom(from, to, tokenId, "");
1520   }
1521 
1522   /**
1523    * @dev See {IERC721-safeTransferFrom}.
1524    */
1525   function safeTransferFrom(
1526     address from,
1527     address to,
1528     uint256 tokenId,
1529     bytes memory _data
1530   ) public override {
1531     _transfer(from, to, tokenId);
1532     require(
1533       _checkOnERC721Received(from, to, tokenId, _data),
1534       "ERC721A: transfer to non ERC721Receiver implementer"
1535     );
1536   }
1537 
1538   /**
1539    * @dev Returns whether `tokenId` exists.
1540    *
1541    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1542    *
1543    * Tokens start existing when they are minted (`_mint`),
1544    */
1545   function _exists(uint256 tokenId) internal view returns (bool) {
1546     return tokenId < currentIndex;
1547   }
1548 
1549   function _safeMint(address to, uint256 quantity) internal {
1550     _safeMint(to, quantity, "");
1551   }
1552 
1553   /**
1554    * @dev Mints `quantity` tokens and transfers them to `to`.
1555    *
1556    * Requirements:
1557    *
1558    * - there must be `quantity` tokens remaining unminted in the total collection.
1559    * - `to` cannot be the zero address.
1560    * - `quantity` cannot be larger than the max batch size.
1561    *
1562    * Emits a {Transfer} event.
1563    */
1564   function _safeMint(
1565     address to,
1566     uint256 quantity,
1567     bytes memory _data
1568   ) internal {
1569     uint256 startTokenId = currentIndex;
1570     require(to != address(0), "ERC721A: mint to the zero address");
1571     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1572     require(!_exists(startTokenId), "ERC721A: token already minted");
1573     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1574 
1575     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1576 
1577     AddressData memory addressData = _addressData[to];
1578     _addressData[to] = AddressData(
1579       addressData.balance + uint128(quantity),
1580       addressData.numberMinted + uint128(quantity)
1581     );
1582     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1583 
1584     uint256 updatedIndex = startTokenId;
1585 
1586     for (uint256 i = 0; i < quantity; i++) {
1587       emit Transfer(address(0), to, updatedIndex);
1588       require(
1589         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1590         "ERC721A: transfer to non ERC721Receiver implementer"
1591       );
1592       updatedIndex++;
1593     }
1594 
1595     currentIndex = updatedIndex;
1596     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1597   }
1598 
1599   /**
1600    * @dev Transfers `tokenId` from `from` to `to`.
1601    *
1602    * Requirements:
1603    *
1604    * - `to` cannot be the zero address.
1605    * - `tokenId` token must be owned by `from`.
1606    *
1607    * Emits a {Transfer} event.
1608    */
1609   function _transfer(
1610     address from,
1611     address to,
1612     uint256 tokenId
1613   ) private {
1614     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1615 
1616     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1617       getApproved(tokenId) == _msgSender() ||
1618       isApprovedForAll(prevOwnership.addr, _msgSender()));
1619 
1620     require(
1621       isApprovedOrOwner,
1622       "ERC721A: transfer caller is not owner nor approved"
1623     );
1624 
1625     require(
1626       prevOwnership.addr == from,
1627       "ERC721A: transfer from incorrect owner"
1628     );
1629     require(to != address(0), "ERC721A: transfer to the zero address");
1630 
1631     _beforeTokenTransfers(from, to, tokenId, 1);
1632 
1633     // Clear approvals from the previous owner
1634     _approve(address(0), tokenId, prevOwnership.addr);
1635 
1636     _addressData[from].balance -= 1;
1637     _addressData[to].balance += 1;
1638     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1639 
1640     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1641     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1642     uint256 nextTokenId = tokenId + 1;
1643     if (_ownerships[nextTokenId].addr == address(0)) {
1644       if (_exists(nextTokenId)) {
1645         _ownerships[nextTokenId] = TokenOwnership(
1646           prevOwnership.addr,
1647           prevOwnership.startTimestamp
1648         );
1649       }
1650     }
1651 
1652     emit Transfer(from, to, tokenId);
1653     _afterTokenTransfers(from, to, tokenId, 1);
1654   }
1655 
1656   /**
1657    * @dev Approve `to` to operate on `tokenId`
1658    *
1659    * Emits a {Approval} event.
1660    */
1661   function _approve(
1662     address to,
1663     uint256 tokenId,
1664     address owner
1665   ) private {
1666     _tokenApprovals[tokenId] = to;
1667     emit Approval(owner, to, tokenId);
1668   }
1669 
1670   uint256 public nextOwnerToExplicitlySet = 0;
1671 
1672   /**
1673    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1674    */
1675   function _setOwnersExplicit(uint256 quantity) internal {
1676     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1677     require(quantity > 0, "quantity must be nonzero");
1678     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1679     if (endIndex > collectionSize - 1) {
1680       endIndex = collectionSize - 1;
1681     }
1682     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1683     require(_exists(endIndex), "not enough minted yet for this cleanup");
1684     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1685       if (_ownerships[i].addr == address(0)) {
1686         TokenOwnership memory ownership = ownershipOf(i);
1687         _ownerships[i] = TokenOwnership(
1688           ownership.addr,
1689           ownership.startTimestamp
1690         );
1691       }
1692     }
1693     nextOwnerToExplicitlySet = endIndex + 1;
1694   }
1695 
1696   /**
1697    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1698    * The call is not executed if the target address is not a contract.
1699    *
1700    * @param from address representing the previous owner of the given token ID
1701    * @param to target address that will receive the tokens
1702    * @param tokenId uint256 ID of the token to be transferred
1703    * @param _data bytes optional data to send along with the call
1704    * @return bool whether the call correctly returned the expected magic value
1705    */
1706   function _checkOnERC721Received(
1707     address from,
1708     address to,
1709     uint256 tokenId,
1710     bytes memory _data
1711   ) private returns (bool) {
1712     if (to.isContract()) {
1713       try
1714         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1715       returns (bytes4 retval) {
1716         return retval == IERC721Receiver(to).onERC721Received.selector;
1717       } catch (bytes memory reason) {
1718         if (reason.length == 0) {
1719           revert("ERC721A: transfer to non ERC721Receiver implementer");
1720         } else {
1721           assembly {
1722             revert(add(32, reason), mload(reason))
1723           }
1724         }
1725       }
1726     } else {
1727       return true;
1728     }
1729   }
1730 
1731   /**
1732    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1733    *
1734    * startTokenId - the first token id to be transferred
1735    * quantity - the amount to be transferred
1736    *
1737    * Calling conditions:
1738    *
1739    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1740    * transferred to `to`.
1741    * - When `from` is zero, `tokenId` will be minted for `to`.
1742    */
1743   function _beforeTokenTransfers(
1744     address from,
1745     address to,
1746     uint256 startTokenId,
1747     uint256 quantity
1748   ) internal virtual {}
1749 
1750   /**
1751    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1752    * minting.
1753    *
1754    * startTokenId - the first token id to be transferred
1755    * quantity - the amount to be transferred
1756    *
1757    * Calling conditions:
1758    *
1759    * - when `from` and `to` are both non-zero.
1760    * - `from` and `to` are never both zero.
1761    */
1762   function _afterTokenTransfers(
1763     address from,
1764     address to,
1765     uint256 startTokenId,
1766     uint256 quantity
1767   ) internal virtual {}
1768 }
1769 
1770 //SPDX-License-Identifier: MIT
1771 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1772 
1773 pragma solidity ^0.8.0;
1774 
1775 
1776 
1777 
1778 
1779 
1780 
1781 
1782 
1783 contract poobs is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1784     using Counters for Counters.Counter;
1785     using Strings for uint256;
1786 
1787     Counters.Counter private tokenCounter;
1788 
1789     string private release_all_poobs = "ipfs://QmZU6h1b9Srf1CALZjJ7eDQN9MVjEAjPoEKMdYDUwuLjKH";
1790     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1791     bool private isOpenSeaProxyActive = true;
1792 
1793 uint256 public constant price = 0.01 ether;
1794 uint256 public  total_amount_of_poobs = 5555;
1795 uint256 public reserved_amount_for_whitelist = 555;
1796 uint256 public constant mint_amount_for_public = 3;
1797 uint256 public constant mint_amount_for_whitelist= 1;
1798 bool public isPublicSaleActive = true;
1799 bool public paused = true;
1800 
1801 
1802 
1803     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1804 
1805     modifier publicSaleActive() {
1806         require(isPublicSaleActive, "Public sale is not open");
1807         _;
1808     }
1809 
1810 
1811 
1812     modifier maxMintsPerTX(uint256 numberOfTokens) {
1813         require(
1814             numberOfTokens <= mint_amount_for_public,
1815             "Max mints per transaction exceeded"
1816         );
1817         _;
1818     }
1819 
1820     modifier canMintNFTs(uint256 numberOfTokens) {
1821         require(
1822             totalSupply() + numberOfTokens <=
1823                  total_amount_of_poobs,
1824             "Not enough mints remaining to mint"
1825         );
1826         _;
1827     }
1828 
1829     modifier freeMintsAvailable() {
1830         require(
1831             totalSupply() <=
1832                 reserved_amount_for_whitelist,
1833             "Not enough free mints remain"
1834         );
1835         _;
1836     }
1837 
1838 
1839 
1840 
1841     constructor(
1842     ) ERC721A("poobs", "poobsnft", 100,  total_amount_of_poobs) {
1843     }
1844 
1845     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1846 
1847     function mintpoobs(uint256 _amount) external payable {
1848         address _caller = _msgSender();
1849         require(!paused, "Paused");
1850         require( total_amount_of_poobs >= totalSupply() + _amount, "Exceeds max supply");
1851         require(_amount > 0, "No 0 mints");
1852         require(tx.origin == _caller, "No contracts");
1853         require(mint_amount_for_public >= _amount , "Excess max per paid tx");
1854         
1855       if(reserved_amount_for_whitelist >= totalSupply()){
1856             require(mint_amount_for_whitelist  >= _amount , "Excess max per free tx");
1857         }else{
1858             require(mint_amount_for_public>= _amount , "Excess max per paid tx");
1859             require(_amount * price == msg.value, "Invalid funds provided");
1860         }
1861 
1862 
1863         _safeMint(_caller, _amount);
1864     }
1865 
1866 
1867     //A simple free mint function to avoid confusion
1868     //The normal mint function with a cost of 0 would work too
1869 
1870     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1871 
1872     function getBaseURI() external view returns (string memory) {
1873         return release_all_poobs;
1874     }
1875 
1876     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1877 
1878     function reveal_all_poobs(string memory _baseURI) external onlyOwner {
1879         release_all_poobs = _baseURI;
1880     }
1881 
1882     // function to disable gasless listings for security in case
1883     // opensea ever shuts down or is compromised
1884     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1885         external
1886         onlyOwner
1887     {
1888         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1889     }
1890 
1891     function setIsPublicSaleActive(bool _isPublicSaleActive)
1892         external
1893         onlyOwner
1894     {
1895         isPublicSaleActive = _isPublicSaleActive;
1896     }
1897 
1898  function IsPaused(bool _paused)
1899         external
1900         onlyOwner
1901     {
1902         paused = _paused;
1903     }
1904 
1905     function reserved_for_whitelist(uint256 reserved)
1906         external
1907         onlyOwner
1908     {
1909        reserved_amount_for_whitelist = reserved;
1910     }
1911 
1912 
1913     function withdrawfunds() public onlyOwner {
1914         uint256 balance = address(this).balance;
1915         payable(msg.sender).transfer(balance);
1916     }
1917 
1918     function withdrawTokens(IERC20 token) public onlyOwner {
1919         uint256 balance = token.balanceOf(address(this));
1920         token.transfer(msg.sender, balance);
1921     }
1922 
1923 
1924 
1925     // ============ SUPPORTING FUNCTIONS ============
1926 
1927     function nextTokenId() private returns (uint256) {
1928         tokenCounter.increment();
1929         return tokenCounter.current();
1930     }
1931 
1932     // ============ FUNCTION OVERRIDES ============
1933 
1934     function supportsInterface(bytes4 interfaceId)
1935         public
1936         view
1937         virtual
1938         override(ERC721A, IERC165)
1939         returns (bool)
1940     {
1941         return
1942             interfaceId == type(IERC2981).interfaceId ||
1943             super.supportsInterface(interfaceId);
1944     }
1945 
1946     /**
1947      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1948      */
1949     function isApprovedForAll(address owner, address operator)
1950         public
1951         view
1952         override
1953         returns (bool)
1954     {
1955         // Get a reference to OpenSea's proxy registry contract by instantiating
1956         // the contract using the already existing address.
1957         ProxyRegistry proxyRegistry = ProxyRegistry(
1958             openSeaProxyRegistryAddress
1959         );
1960         if (
1961             isOpenSeaProxyActive &&
1962             address(proxyRegistry.proxies(owner)) == operator
1963         ) {
1964             return true;
1965         }
1966 
1967         return super.isApprovedForAll(owner, operator);
1968     }
1969 
1970     /**
1971      * @dev See {IERC721Metadata-tokenURI}.
1972      */
1973     function tokenURI(uint256 tokenId)
1974         public
1975         view
1976         virtual
1977         override
1978         returns (string memory)
1979     {
1980         require(_exists(tokenId), "Nonexistent token");
1981 
1982         return
1983             string(abi.encodePacked(release_all_poobs, "/", (tokenId+1).toString(), ".json"));
1984     }
1985 
1986     /**
1987      * @dev See {IERC165-royaltyInfo}.
1988      */
1989     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1990         external
1991         view
1992         override
1993         returns (address receiver, uint256 royaltyAmount)
1994     {
1995         require(_exists(tokenId), "Nonexistent token");
1996 
1997         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1998     }
1999 }
2000 
2001 // These contract definitions are used to create a reference to the OpenSea
2002 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
2003 contract OwnableDelegateProxy {
2004 
2005 }
2006 
2007 contract ProxyRegistry {
2008     mapping(address => OwnableDelegateProxy) public proxies;
2009 }