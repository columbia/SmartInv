1 /*
2 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⠶⣿⣭⡧⡤⣤⣻⣛⣹⣿⣿⣿⣶⣄
3 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⣼⣊⣤⣶⣷⣶⣧⣤⣽⣿⣿⣿⣿⣿⣿⣷
4 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇
5 ⢀⢀⢀⢀⢀⢀⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧
6 ⢀⢀⢀⢀⢀⢀⠸⠿⣿⣿⠿⣿⣿⣿⣿⣿⣿⣿⡿⣿⣻⣿⣿⣿⣿⣿⡆
7 ⢀⢀⢀⢀⢀⢀⢀⢸⣿⣿⡀⠘⣿⡿⢿⣿⣿⡟⣾⣿⣯⣽⣼⣿⣿⣿⣿⡀
8 ⢀⢀⢀⢀⢀⢀⡠⠚⢛⣛⣃⢄⡁⢀⢀⢀⠈⠁⠛⠛⠛⠛⠚⠻⣿⣿⣿⣷
9 ⢀⢀⣴⣶⣶⣶⣷⡄⠊⠉⢻⣟⠃⢀⢀⢀⢀⡠⠔⠒⢀⢀⢀⢀⢹⣿⣿⣿⣄⣀⣀⣀⣀⣀⣀
10 ⢠⣾⣿⣿⣿⣿⣿⣿⣿⣶⣄⣙⠻⠿⠶⠒⠁⢀⢀⣀⣤⣰⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄
11 ⢿⠟⠛⠋⣿⣿⣿⣿⣿⣿⣿⣟⡿⠷⣶⣶⣶⢶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄
12 ⢀⢀⢀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⠙⠻⠿⣿⣿⡿
13 ⢀⢀⢀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢀⢀⢀⢀⠈⠁
14 ⢀⢀⢀⢀⢸⣿⣿⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
15 ⢀⢀⢀⢀⢸⣿⣿⣿⣿⣄⠈⠛⠿⣿⣿⣿⣿⣿⣿⣿⡿⠟⣹⣿⣿⣿⣿⣿⣿⣿⣿⠇
16 ⢀⢀⢀⢀⢀⢻⣿⣿⣿⣿⣧⣀⢀⢀⠉⠛⠛⠋⠉⢀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⠏
17 ⢀⢀⢀⢀⢀⢀⢻⣿⣿⣿⣿⣿⣷⣤⣄⣀⣀⣤⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋
18 ⢀⢀⢀⢀⢀⢀⢀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠛
19 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢹⣿⡿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁
20 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⢸⣿⡇⢀⠈⠙⠛⠛⠛⠛⠛⠛⠻⣿⣿⣿⠇
21 ⢀⢀⢀⢀⢀⢀⢀⢀⢀⣸⣿⡇⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢨⣿⣿
22 ⢀⢀⢀⢀⢀⢀⢀⢀⣾⣿⡿⠃⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢸⣿⡏
23 ⢀⢀⢀⢀⢀⢀⢀⢀⠻⠿⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢀⢠⣿⣿⡇                                      
24 */
25 
26 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
27 
28 
29 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
30 
31 pragma solidity ^0.8.0;
32 
33 // CAUTION
34 // This version of SafeMath should only be used with Solidity 0.8 or later,
35 // because it relies on the compiler's built in overflow checks.
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations.
39  *
40  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
41  * now has built in overflow checking.
42  */
43 library SafeMath {
44     /**
45      * @dev Returns the addition of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             uint256 c = a + b;
52             if (c < a) return (false, 0);
53             return (true, c);
54         }
55     }
56 
57     /**
58      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
59      *
60      * _Available since v3.4._
61      */
62     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         unchecked {
64             if (b > a) return (false, 0);
65             return (true, a - b);
66         }
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
71      *
72      * _Available since v3.4._
73      */
74     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
75         unchecked {
76             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77             // benefit is lost if 'b' is also tested.
78             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79             if (a == 0) return (true, 0);
80             uint256 c = a * b;
81             if (c / a != b) return (false, 0);
82             return (true, c);
83         }
84     }
85 
86     /**
87      * @dev Returns the division of two unsigned integers, with a division by zero flag.
88      *
89      * _Available since v3.4._
90      */
91     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
92         unchecked {
93             if (b == 0) return (false, 0);
94             return (true, a / b);
95         }
96     }
97 
98     /**
99      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
100      *
101      * _Available since v3.4._
102      */
103     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             if (b == 0) return (false, 0);
106             return (true, a % b);
107         }
108     }
109 
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         return a + b;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return a - b;
136     }
137 
138     /**
139      * @dev Returns the multiplication of two unsigned integers, reverting on
140      * overflow.
141      *
142      * Counterpart to Solidity's `*` operator.
143      *
144      * Requirements:
145      *
146      * - Multiplication cannot overflow.
147      */
148     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
149         return a * b;
150     }
151 
152     /**
153      * @dev Returns the integer division of two unsigned integers, reverting on
154      * division by zero. The result is rounded towards zero.
155      *
156      * Counterpart to Solidity's `/` operator.
157      *
158      * Requirements:
159      *
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return a / b;
164     }
165 
166     /**
167      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
168      * reverting when dividing by zero.
169      *
170      * Counterpart to Solidity's `%` operator. This function uses a `revert`
171      * opcode (which leaves remaining gas untouched) while Solidity uses an
172      * invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         return a % b;
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
184      * overflow (when the result is negative).
185      *
186      * CAUTION: This function is deprecated because it requires allocating memory for the error
187      * message unnecessarily. For custom revert reasons use {trySub}.
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b <= a, errorMessage);
202             return a - b;
203         }
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a / b;
226         }
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * reverting with custom message when dividing by zero.
232      *
233      * CAUTION: This function is deprecated because it requires allocating memory for the error
234      * message unnecessarily. For custom revert reasons use {tryMod}.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(
245         uint256 a,
246         uint256 b,
247         string memory errorMessage
248     ) internal pure returns (uint256) {
249         unchecked {
250             require(b > 0, errorMessage);
251             return a % b;
252         }
253     }
254 }
255 
256 // File: @openzeppelin/contracts/utils/Counters.sol
257 
258 
259 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 /**
264  * @title Counters
265  * @author Matt Condon (@shrugs)
266  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
267  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
268  *
269  * Include with `using Counters for Counters.Counter;`
270  */
271 library Counters {
272     struct Counter {
273         // This variable should never be directly accessed by users of the library: interactions must be restricted to
274         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
275         // this feature: see https://github.com/ethereum/solidity/issues/4637
276         uint256 _value; // default: 0
277     }
278 
279     function current(Counter storage counter) internal view returns (uint256) {
280         return counter._value;
281     }
282 
283     function increment(Counter storage counter) internal {
284         unchecked {
285             counter._value += 1;
286         }
287     }
288 
289     function decrement(Counter storage counter) internal {
290         uint256 value = counter._value;
291         require(value > 0, "Counter: decrement overflow");
292         unchecked {
293             counter._value = value - 1;
294         }
295     }
296 
297     function reset(Counter storage counter) internal {
298         counter._value = 0;
299     }
300 }
301 
302 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
303 
304 
305 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Contract module that helps prevent reentrant calls to a function.
311  *
312  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
313  * available, which can be applied to functions to make sure there are no nested
314  * (reentrant) calls to them.
315  *
316  * Note that because there is a single `nonReentrant` guard, functions marked as
317  * `nonReentrant` may not call one another. This can be worked around by making
318  * those functions `private`, and then adding `external` `nonReentrant` entry
319  * points to them.
320  *
321  * TIP: If you would like to learn more about reentrancy and alternative ways
322  * to protect against it, check out our blog post
323  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
324  */
325 abstract contract ReentrancyGuard {
326     // Booleans are more expensive than uint256 or any type that takes up a full
327     // word because each write operation emits an extra SLOAD to first read the
328     // slot's contents, replace the bits taken up by the boolean, and then write
329     // back. This is the compiler's defense against contract upgrades and
330     // pointer aliasing, and it cannot be disabled.
331 
332     // The values being non-zero value makes deployment a bit more expensive,
333     // but in exchange the refund on every call to nonReentrant will be lower in
334     // amount. Since refunds are capped to a percentage of the total
335     // transaction's gas, it is best to keep them low in cases like this one, to
336     // increase the likelihood of the full refund coming into effect.
337     uint256 private constant _NOT_ENTERED = 1;
338     uint256 private constant _ENTERED = 2;
339 
340     uint256 private _status;
341 
342     constructor() {
343         _status = _NOT_ENTERED;
344     }
345 
346     /**
347      * @dev Prevents a contract from calling itself, directly or indirectly.
348      * Calling a `nonReentrant` function from another `nonReentrant`
349      * function is not supported. It is possible to prevent this from happening
350      * by making the `nonReentrant` function external, and making it call a
351      * `private` function that does the actual work.
352      */
353     modifier nonReentrant() {
354         // On the first call to nonReentrant, _notEntered will be true
355         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
356 
357         // Any calls to nonReentrant after this point will fail
358         _status = _ENTERED;
359 
360         _;
361 
362         // By storing the original value once again, a refund is triggered (see
363         // https://eips.ethereum.org/EIPS/eip-2200)
364         _status = _NOT_ENTERED;
365     }
366 }
367 
368 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Interface of the ERC20 standard as defined in the EIP.
377  */
378 interface IERC20 {
379     /**
380      * @dev Returns the amount of tokens in existence.
381      */
382     function totalSupply() external view returns (uint256);
383 
384     /**
385      * @dev Returns the amount of tokens owned by `account`.
386      */
387     function balanceOf(address account) external view returns (uint256);
388 
389     /**
390      * @dev Moves `amount` tokens from the caller's account to `recipient`.
391      *
392      * Returns a boolean value indicating whether the operation succeeded.
393      *
394      * Emits a {Transfer} event.
395      */
396     function transfer(address recipient, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Returns the remaining number of tokens that `spender` will be
400      * allowed to spend on behalf of `owner` through {transferFrom}. This is
401      * zero by default.
402      *
403      * This value changes when {approve} or {transferFrom} are called.
404      */
405     function allowance(address owner, address spender) external view returns (uint256);
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
409      *
410      * Returns a boolean value indicating whether the operation succeeded.
411      *
412      * IMPORTANT: Beware that changing an allowance with this method brings the risk
413      * that someone may use both the old and the new allowance by unfortunate
414      * transaction ordering. One possible solution to mitigate this race
415      * condition is to first reduce the spender's allowance to 0 and set the
416      * desired value afterwards:
417      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418      *
419      * Emits an {Approval} event.
420      */
421     function approve(address spender, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Moves `amount` tokens from `sender` to `recipient` using the
425      * allowance mechanism. `amount` is then deducted from the caller's
426      * allowance.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transferFrom(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) external returns (bool);
437 
438     /**
439      * @dev Emitted when `value` tokens are moved from one account (`from`) to
440      * another (`to`).
441      *
442      * Note that `value` may be zero.
443      */
444     event Transfer(address indexed from, address indexed to, uint256 value);
445 
446     /**
447      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
448      * a call to {approve}. `value` is the new allowance.
449      */
450     event Approval(address indexed owner, address indexed spender, uint256 value);
451 }
452 
453 // File: @openzeppelin/contracts/interfaces/IERC20.sol
454 
455 
456 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC20.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 // File: @openzeppelin/contracts/utils/Strings.sol
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev String operations.
470  */
471 library Strings {
472     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
473 
474     /**
475      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
476      */
477     function toString(uint256 value) internal pure returns (string memory) {
478         // Inspired by OraclizeAPI's implementation - MIT licence
479         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
480 
481         if (value == 0) {
482             return "0";
483         }
484         uint256 temp = value;
485         uint256 digits;
486         while (temp != 0) {
487             digits++;
488             temp /= 10;
489         }
490         bytes memory buffer = new bytes(digits);
491         while (value != 0) {
492             digits -= 1;
493             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
494             value /= 10;
495         }
496         return string(buffer);
497     }
498 
499     /**
500      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
501      */
502     function toHexString(uint256 value) internal pure returns (string memory) {
503         if (value == 0) {
504             return "0x00";
505         }
506         uint256 temp = value;
507         uint256 length = 0;
508         while (temp != 0) {
509             length++;
510             temp >>= 8;
511         }
512         return toHexString(value, length);
513     }
514 
515     /**
516      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
517      */
518     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
519         bytes memory buffer = new bytes(2 * length + 2);
520         buffer[0] = "0";
521         buffer[1] = "x";
522         for (uint256 i = 2 * length + 1; i > 1; --i) {
523             buffer[i] = _HEX_SYMBOLS[value & 0xf];
524             value >>= 4;
525         }
526         require(value == 0, "Strings: hex length insufficient");
527         return string(buffer);
528     }
529 }
530 
531 // File: @openzeppelin/contracts/utils/Context.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @dev Provides information about the current execution context, including the
540  * sender of the transaction and its data. While these are generally available
541  * via msg.sender and msg.data, they should not be accessed in such a direct
542  * manner, since when dealing with meta-transactions the account sending and
543  * paying for execution may not be the actual sender (as far as an application
544  * is concerned).
545  *
546  * This contract is only required for intermediate, library-like contracts.
547  */
548 abstract contract Context {
549     function _msgSender() internal view virtual returns (address) {
550         return msg.sender;
551     }
552 
553     function _msgData() internal view virtual returns (bytes calldata) {
554         return msg.data;
555     }
556 }
557 
558 // File: @openzeppelin/contracts/access/Ownable.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Contract module which provides a basic access control mechanism, where
568  * there is an account (an owner) that can be granted exclusive access to
569  * specific functions.
570  *
571  * By default, the owner account will be the one that deploys the contract. This
572  * can later be changed with {transferOwnership}.
573  *
574  * This module is used through inheritance. It will make available the modifier
575  * `onlyOwner`, which can be applied to your functions to restrict their use to
576  * the owner.
577  */
578 abstract contract Ownable is Context {
579     address private _owner;
580 
581     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582 
583     /**
584      * @dev Initializes the contract setting the deployer as the initial owner.
585      */
586     constructor() {
587         _transferOwnership(_msgSender());
588     }
589 
590     /**
591      * @dev Returns the address of the current owner.
592      */
593     function owner() public view virtual returns (address) {
594         return _owner;
595     }
596 
597     /**
598      * @dev Throws if called by any account other than the owner.
599      */
600     modifier onlyOwner() {
601         require(owner() == _msgSender(), "Ownable: caller is not the owner");
602         _;
603     }
604 
605     /**
606      * @dev Leaves the contract without owner. It will not be possible to call
607      * `onlyOwner` functions anymore. Can only be called by the current owner.
608      *
609      * NOTE: Renouncing ownership will leave the contract without an owner,
610      * thereby removing any functionality that is only available to the owner.
611      */
612     function renounceOwnership() public virtual onlyOwner {
613         _transferOwnership(address(0));
614     }
615 
616     /**
617      * @dev Transfers ownership of the contract to a new account (`newOwner`).
618      * Can only be called by the current owner.
619      */
620     function transferOwnership(address newOwner) public virtual onlyOwner {
621         require(newOwner != address(0), "Ownable: new owner is the zero address");
622         _transferOwnership(newOwner);
623     }
624 
625     /**
626      * @dev Transfers ownership of the contract to a new account (`newOwner`).
627      * Internal function without access restriction.
628      */
629     function _transferOwnership(address newOwner) internal virtual {
630         address oldOwner = _owner;
631         _owner = newOwner;
632         emit OwnershipTransferred(oldOwner, newOwner);
633     }
634 }
635 
636 // File: @openzeppelin/contracts/utils/Address.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Collection of functions related to the address type
645  */
646 library Address {
647     /**
648      * @dev Returns true if `account` is a contract.
649      *
650      * [IMPORTANT]
651      * ====
652      * It is unsafe to assume that an address for which this function returns
653      * false is an externally-owned account (EOA) and not a contract.
654      *
655      * Among others, `isContract` will return false for the following
656      * types of addresses:
657      *
658      *  - an externally-owned account
659      *  - a contract in construction
660      *  - an address where a contract will be created
661      *  - an address where a contract lived, but was destroyed
662      * ====
663      */
664     function isContract(address account) internal view returns (bool) {
665         // This method relies on extcodesize, which returns 0 for contracts in
666         // construction, since the code is only stored at the end of the
667         // constructor execution.
668 
669         uint256 size;
670         assembly {
671             size := extcodesize(account)
672         }
673         return size > 0;
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(address(this).balance >= amount, "Address: insufficient balance");
694 
695         (bool success, ) = recipient.call{value: amount}("");
696         require(success, "Address: unable to send value, recipient may have reverted");
697     }
698 
699     /**
700      * @dev Performs a Solidity function call using a low level `call`. A
701      * plain `call` is an unsafe replacement for a function call: use this
702      * function instead.
703      *
704      * If `target` reverts with a revert reason, it is bubbled up by this
705      * function (like regular Solidity function calls).
706      *
707      * Returns the raw returned data. To convert to the expected return value,
708      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
709      *
710      * Requirements:
711      *
712      * - `target` must be a contract.
713      * - calling `target` with `data` must not revert.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
718         return functionCall(target, data, "Address: low-level call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
723      * `errorMessage` as a fallback revert reason when `target` reverts.
724      *
725      * _Available since v3.1._
726      */
727     function functionCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal returns (bytes memory) {
732         return functionCallWithValue(target, data, 0, errorMessage);
733     }
734 
735     /**
736      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
737      * but also transferring `value` wei to `target`.
738      *
739      * Requirements:
740      *
741      * - the calling contract must have an ETH balance of at least `value`.
742      * - the called Solidity function must be `payable`.
743      *
744      * _Available since v3.1._
745      */
746     function functionCallWithValue(
747         address target,
748         bytes memory data,
749         uint256 value
750     ) internal returns (bytes memory) {
751         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
756      * with `errorMessage` as a fallback revert reason when `target` reverts.
757      *
758      * _Available since v3.1._
759      */
760     function functionCallWithValue(
761         address target,
762         bytes memory data,
763         uint256 value,
764         string memory errorMessage
765     ) internal returns (bytes memory) {
766         require(address(this).balance >= value, "Address: insufficient balance for call");
767         require(isContract(target), "Address: call to non-contract");
768 
769         (bool success, bytes memory returndata) = target.call{value: value}(data);
770         return verifyCallResult(success, returndata, errorMessage);
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
780         return functionStaticCall(target, data, "Address: low-level static call failed");
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
785      * but performing a static call.
786      *
787      * _Available since v3.3._
788      */
789     function functionStaticCall(
790         address target,
791         bytes memory data,
792         string memory errorMessage
793     ) internal view returns (bytes memory) {
794         require(isContract(target), "Address: static call to non-contract");
795 
796         (bool success, bytes memory returndata) = target.staticcall(data);
797         return verifyCallResult(success, returndata, errorMessage);
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
807         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
812      * but performing a delegate call.
813      *
814      * _Available since v3.4._
815      */
816     function functionDelegateCall(
817         address target,
818         bytes memory data,
819         string memory errorMessage
820     ) internal returns (bytes memory) {
821         require(isContract(target), "Address: delegate call to non-contract");
822 
823         (bool success, bytes memory returndata) = target.delegatecall(data);
824         return verifyCallResult(success, returndata, errorMessage);
825     }
826 
827     /**
828      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
829      * revert reason using the provided one.
830      *
831      * _Available since v4.3._
832      */
833     function verifyCallResult(
834         bool success,
835         bytes memory returndata,
836         string memory errorMessage
837     ) internal pure returns (bytes memory) {
838         if (success) {
839             return returndata;
840         } else {
841             // Look for revert reason and bubble it up if present
842             if (returndata.length > 0) {
843                 // The easiest way to bubble the revert reason is using memory via assembly
844 
845                 assembly {
846                     let returndata_size := mload(returndata)
847                     revert(add(32, returndata), returndata_size)
848                 }
849             } else {
850                 revert(errorMessage);
851             }
852         }
853     }
854 }
855 
856 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
857 
858 
859 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
860 
861 pragma solidity ^0.8.0;
862 
863 /**
864  * @title ERC721 token receiver interface
865  * @dev Interface for any contract that wants to support safeTransfers
866  * from ERC721 asset contracts.
867  */
868 interface IERC721Receiver {
869     /**
870      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
871      * by `operator` from `from`, this function is called.
872      *
873      * It must return its Solidity selector to confirm the token transfer.
874      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
875      *
876      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
877      */
878     function onERC721Received(
879         address operator,
880         address from,
881         uint256 tokenId,
882         bytes calldata data
883     ) external returns (bytes4);
884 }
885 
886 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
887 
888 
889 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
890 
891 pragma solidity ^0.8.0;
892 
893 /**
894  * @dev Interface of the ERC165 standard, as defined in the
895  * https://eips.ethereum.org/EIPS/eip-165[EIP].
896  *
897  * Implementers can declare support of contract interfaces, which can then be
898  * queried by others ({ERC165Checker}).
899  *
900  * For an implementation, see {ERC165}.
901  */
902 interface IERC165 {
903     /**
904      * @dev Returns true if this contract implements the interface defined by
905      * `interfaceId`. See the corresponding
906      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
907      * to learn more about how these ids are created.
908      *
909      * This function call must use less than 30 000 gas.
910      */
911     function supportsInterface(bytes4 interfaceId) external view returns (bool);
912 }
913 
914 // File: @openzeppelin/contracts/interfaces/IERC165.sol
915 
916 
917 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
918 
919 pragma solidity ^0.8.0;
920 
921 
922 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
923 
924 
925 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
926 
927 pragma solidity ^0.8.0;
928 
929 
930 /**
931  * @dev Interface for the NFT Royalty Standard
932  */
933 interface IERC2981 is IERC165 {
934     /**
935      * @dev Called with the sale price to determine how much royalty is owed and to whom.
936      * @param tokenId - the NFT asset queried for royalty information
937      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
938      * @return receiver - address of who should be sent the royalty payment
939      * @return royaltyAmount - the royalty payment amount for `salePrice`
940      */
941     function royaltyInfo(uint256 tokenId, uint256 salePrice)
942         external
943         view
944         returns (address receiver, uint256 royaltyAmount);
945 }
946 
947 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
948 
949 
950 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
951 
952 pragma solidity ^0.8.0;
953 
954 
955 /**
956  * @dev Implementation of the {IERC165} interface.
957  *
958  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
959  * for the additional interface id that will be supported. For example:
960  *
961  * ```solidity
962  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
964  * }
965  * ```
966  *
967  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
968  */
969 abstract contract ERC165 is IERC165 {
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
974         return interfaceId == type(IERC165).interfaceId;
975     }
976 }
977 
978 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
979 
980 
981 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
982 
983 pragma solidity ^0.8.0;
984 
985 
986 /**
987  * @dev Required interface of an ERC721 compliant contract.
988  */
989 interface IERC721 is IERC165 {
990     /**
991      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
992      */
993     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
994 
995     /**
996      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
997      */
998     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
999 
1000     /**
1001      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1002      */
1003     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1004 
1005     /**
1006      * @dev Returns the number of tokens in ``owner``'s account.
1007      */
1008     function balanceOf(address owner) external view returns (uint256 balance);
1009 
1010     /**
1011      * @dev Returns the owner of the `tokenId` token.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must exist.
1016      */
1017     function ownerOf(uint256 tokenId) external view returns (address owner);
1018 
1019     /**
1020      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1021      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must exist and be owned by `from`.
1028      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1029      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function safeTransferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) external;
1038 
1039     /**
1040      * @dev Transfers `tokenId` token from `from` to `to`.
1041      *
1042      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1050      *
1051      * Emits a {Transfer} event.
1052      */
1053     function transferFrom(
1054         address from,
1055         address to,
1056         uint256 tokenId
1057     ) external;
1058 
1059     /**
1060      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1061      * The approval is cleared when the token is transferred.
1062      *
1063      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1064      *
1065      * Requirements:
1066      *
1067      * - The caller must own the token or be an approved operator.
1068      * - `tokenId` must exist.
1069      *
1070      * Emits an {Approval} event.
1071      */
1072     function approve(address to, uint256 tokenId) external;
1073 
1074     /**
1075      * @dev Returns the account approved for `tokenId` token.
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must exist.
1080      */
1081     function getApproved(uint256 tokenId) external view returns (address operator);
1082 
1083     /**
1084      * @dev Approve or remove `operator` as an operator for the caller.
1085      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1086      *
1087      * Requirements:
1088      *
1089      * - The `operator` cannot be the caller.
1090      *
1091      * Emits an {ApprovalForAll} event.
1092      */
1093     function setApprovalForAll(address operator, bool _approved) external;
1094 
1095     /**
1096      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1097      *
1098      * See {setApprovalForAll}
1099      */
1100     function isApprovedForAll(address owner, address operator) external view returns (bool);
1101 
1102     /**
1103      * @dev Safely transfers `tokenId` token from `from` to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - `from` cannot be the zero address.
1108      * - `to` cannot be the zero address.
1109      * - `tokenId` token must exist and be owned by `from`.
1110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function safeTransferFrom(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes calldata data
1120     ) external;
1121 }
1122 
1123 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1124 
1125 
1126 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1127 
1128 pragma solidity ^0.8.0;
1129 
1130 
1131 /**
1132  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1133  * @dev See https://eips.ethereum.org/EIPS/eip-721
1134  */
1135 interface IERC721Enumerable is IERC721 {
1136     /**
1137      * @dev Returns the total amount of tokens stored by the contract.
1138      */
1139     function totalSupply() external view returns (uint256);
1140 
1141     /**
1142      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1143      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1144      */
1145     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1146 
1147     /**
1148      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1149      * Use along with {totalSupply} to enumerate all tokens.
1150      */
1151     function tokenByIndex(uint256 index) external view returns (uint256);
1152 }
1153 
1154 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1155 
1156 
1157 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1158 
1159 pragma solidity ^0.8.0;
1160 
1161 
1162 /**
1163  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1164  * @dev See https://eips.ethereum.org/EIPS/eip-721
1165  */
1166 interface IERC721Metadata is IERC721 {
1167     /**
1168      * @dev Returns the token collection name.
1169      */
1170     function name() external view returns (string memory);
1171 
1172     /**
1173      * @dev Returns the token collection symbol.
1174      */
1175     function symbol() external view returns (string memory);
1176 
1177     /**
1178      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1179      */
1180     function tokenURI(uint256 tokenId) external view returns (string memory);
1181 }
1182 
1183 // File: contracts/ERC721A.sol
1184 
1185 
1186 
1187 pragma solidity ^0.8.0;
1188 
1189 
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 /**
1198  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1199  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1200  *
1201  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1202  *
1203  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1204  *
1205  * Does not support burning tokens to address(0).
1206  */
1207 contract ERC721A is
1208   Context,
1209   ERC165,
1210   IERC721,
1211   IERC721Metadata,
1212   IERC721Enumerable
1213 {
1214   using Address for address;
1215   using Strings for uint256;
1216 
1217   struct TokenOwnership {
1218     address addr;
1219     uint64 startTimestamp;
1220   }
1221 
1222   struct AddressData {
1223     uint128 balance;
1224     uint128 numberMinted;
1225   }
1226 
1227   uint256 private currentIndex = 0;
1228 
1229   uint256 internal immutable collectionSize;
1230   uint256 internal immutable maxBatchSize;
1231 
1232   // Token name
1233   string private _name;
1234 
1235   // Token symbol
1236   string private _symbol;
1237 
1238   // Mapping from token ID to ownership details
1239   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1240   mapping(uint256 => TokenOwnership) private _ownerships;
1241 
1242   // Mapping owner address to address data
1243   mapping(address => AddressData) private _addressData;
1244 
1245   // Mapping from token ID to approved address
1246   mapping(uint256 => address) private _tokenApprovals;
1247 
1248   // Mapping from owner to operator approvals
1249   mapping(address => mapping(address => bool)) private _operatorApprovals;
1250 
1251   /**
1252    * @dev
1253    * `maxBatchSize` refers to how much a minter can mint at a time.
1254    * `collectionSize_` refers to how many tokens are in the collection.
1255    */
1256   constructor(
1257     string memory name_,
1258     string memory symbol_,
1259     uint256 maxBatchSize_,
1260     uint256 collectionSize_
1261   ) {
1262     require(
1263       collectionSize_ > 0,
1264       "ERC721A: collection must have a nonzero supply"
1265     );
1266     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1267     _name = name_;
1268     _symbol = symbol_;
1269     maxBatchSize = maxBatchSize_;
1270     collectionSize = collectionSize_;
1271   }
1272 
1273   /**
1274    * @dev See {IERC721Enumerable-totalSupply}.
1275    */
1276   function totalSupply() public view override returns (uint256) {
1277     return currentIndex;
1278   }
1279 
1280   /**
1281    * @dev See {IERC721Enumerable-tokenByIndex}.
1282    */
1283   function tokenByIndex(uint256 index) public view override returns (uint256) {
1284     require(index < totalSupply(), "ERC721A: global index out of bounds");
1285     return index;
1286   }
1287 
1288   /**
1289    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1290    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1291    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1292    */
1293   function tokenOfOwnerByIndex(address owner, uint256 index)
1294     public
1295     view
1296     override
1297     returns (uint256)
1298   {
1299     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1300     uint256 numMintedSoFar = totalSupply();
1301     uint256 tokenIdsIdx = 0;
1302     address currOwnershipAddr = address(0);
1303     for (uint256 i = 0; i < numMintedSoFar; i++) {
1304       TokenOwnership memory ownership = _ownerships[i];
1305       if (ownership.addr != address(0)) {
1306         currOwnershipAddr = ownership.addr;
1307       }
1308       if (currOwnershipAddr == owner) {
1309         if (tokenIdsIdx == index) {
1310           return i;
1311         }
1312         tokenIdsIdx++;
1313       }
1314     }
1315     revert("ERC721A: unable to get token of owner by index");
1316   }
1317 
1318   /**
1319    * @dev See {IERC165-supportsInterface}.
1320    */
1321   function supportsInterface(bytes4 interfaceId)
1322     public
1323     view
1324     virtual
1325     override(ERC165, IERC165)
1326     returns (bool)
1327   {
1328     return
1329       interfaceId == type(IERC721).interfaceId ||
1330       interfaceId == type(IERC721Metadata).interfaceId ||
1331       interfaceId == type(IERC721Enumerable).interfaceId ||
1332       super.supportsInterface(interfaceId);
1333   }
1334 
1335   /**
1336    * @dev See {IERC721-balanceOf}.
1337    */
1338   function balanceOf(address owner) public view override returns (uint256) {
1339     require(owner != address(0), "ERC721A: balance query for the zero address");
1340     return uint256(_addressData[owner].balance);
1341   }
1342 
1343   function _numberMinted(address owner) internal view returns (uint256) {
1344     require(
1345       owner != address(0),
1346       "ERC721A: number minted query for the zero address"
1347     );
1348     return uint256(_addressData[owner].numberMinted);
1349   }
1350 
1351   function ownershipOf(uint256 tokenId)
1352     internal
1353     view
1354     returns (TokenOwnership memory)
1355   {
1356     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1357 
1358     uint256 lowestTokenToCheck;
1359     if (tokenId >= maxBatchSize) {
1360       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1361     }
1362 
1363     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1364       TokenOwnership memory ownership = _ownerships[curr];
1365       if (ownership.addr != address(0)) {
1366         return ownership;
1367       }
1368     }
1369 
1370     revert("ERC721A: unable to determine the owner of token");
1371   }
1372 
1373   /**
1374    * @dev See {IERC721-ownerOf}.
1375    */
1376   function ownerOf(uint256 tokenId) public view override returns (address) {
1377     return ownershipOf(tokenId).addr;
1378   }
1379 
1380   /**
1381    * @dev See {IERC721Metadata-name}.
1382    */
1383   function name() public view virtual override returns (string memory) {
1384     return _name;
1385   }
1386 
1387   /**
1388    * @dev See {IERC721Metadata-symbol}.
1389    */
1390   function symbol() public view virtual override returns (string memory) {
1391     return _symbol;
1392   }
1393 
1394   /**
1395    * @dev See {IERC721Metadata-tokenURI}.
1396    */
1397   function tokenURI(uint256 tokenId)
1398     public
1399     view
1400     virtual
1401     override
1402     returns (string memory)
1403   {
1404     require(
1405       _exists(tokenId),
1406       "ERC721Metadata: URI query for nonexistent token"
1407     );
1408 
1409     string memory baseURI = _baseURI();
1410     return
1411       bytes(baseURI).length > 0
1412         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1413         : "";
1414   }
1415 
1416   /**
1417    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1418    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1419    * by default, can be overriden in child contracts.
1420    */
1421   function _baseURI() internal view virtual returns (string memory) {
1422     return "";
1423   }
1424 
1425   /**
1426    * @dev See {IERC721-approve}.
1427    */
1428   function approve(address to, uint256 tokenId) public override {
1429     address owner = ERC721A.ownerOf(tokenId);
1430     require(to != owner, "ERC721A: approval to current owner");
1431 
1432     require(
1433       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1434       "ERC721A: approve caller is not owner nor approved for all"
1435     );
1436 
1437     _approve(to, tokenId, owner);
1438   }
1439 
1440   /**
1441    * @dev See {IERC721-getApproved}.
1442    */
1443   function getApproved(uint256 tokenId) public view override returns (address) {
1444     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1445 
1446     return _tokenApprovals[tokenId];
1447   }
1448 
1449   /**
1450    * @dev See {IERC721-setApprovalForAll}.
1451    */
1452   function setApprovalForAll(address operator, bool approved) public override {
1453     require(operator != _msgSender(), "ERC721A: approve to caller");
1454 
1455     _operatorApprovals[_msgSender()][operator] = approved;
1456     emit ApprovalForAll(_msgSender(), operator, approved);
1457   }
1458 
1459   /**
1460    * @dev See {IERC721-isApprovedForAll}.
1461    */
1462   function isApprovedForAll(address owner, address operator)
1463     public
1464     view
1465     virtual
1466     override
1467     returns (bool)
1468   {
1469     return _operatorApprovals[owner][operator];
1470   }
1471 
1472   /**
1473    * @dev See {IERC721-transferFrom}.
1474    */
1475   function transferFrom(
1476     address from,
1477     address to,
1478     uint256 tokenId
1479   ) public override {
1480     _transfer(from, to, tokenId);
1481   }
1482 
1483   /**
1484    * @dev See {IERC721-safeTransferFrom}.
1485    */
1486   function safeTransferFrom(
1487     address from,
1488     address to,
1489     uint256 tokenId
1490   ) public override {
1491     safeTransferFrom(from, to, tokenId, "");
1492   }
1493 
1494   /**
1495    * @dev See {IERC721-safeTransferFrom}.
1496    */
1497   function safeTransferFrom(
1498     address from,
1499     address to,
1500     uint256 tokenId,
1501     bytes memory _data
1502   ) public override {
1503     _transfer(from, to, tokenId);
1504     require(
1505       _checkOnERC721Received(from, to, tokenId, _data),
1506       "ERC721A: transfer to non ERC721Receiver implementer"
1507     );
1508   }
1509 
1510   /**
1511    * @dev Returns whether `tokenId` exists.
1512    *
1513    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1514    *
1515    * Tokens start existing when they are minted (`_mint`),
1516    */
1517   function _exists(uint256 tokenId) internal view returns (bool) {
1518     return tokenId < currentIndex;
1519   }
1520 
1521   function _safeMint(address to, uint256 quantity) internal {
1522     _safeMint(to, quantity, "");
1523   }
1524 
1525   /**
1526    * @dev Mints `quantity` tokens and transfers them to `to`.
1527    *
1528    * Requirements:
1529    *
1530    * - there must be `quantity` tokens remaining unminted in the total collection.
1531    * - `to` cannot be the zero address.
1532    * - `quantity` cannot be larger than the max batch size.
1533    *
1534    * Emits a {Transfer} event.
1535    */
1536   function _safeMint(
1537     address to,
1538     uint256 quantity,
1539     bytes memory _data
1540   ) internal {
1541     uint256 startTokenId = currentIndex;
1542     require(to != address(0), "ERC721A: mint to the zero address");
1543     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1544     require(!_exists(startTokenId), "ERC721A: token already minted");
1545     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1546 
1547     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1548 
1549     AddressData memory addressData = _addressData[to];
1550     _addressData[to] = AddressData(
1551       addressData.balance + uint128(quantity),
1552       addressData.numberMinted + uint128(quantity)
1553     );
1554     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1555 
1556     uint256 updatedIndex = startTokenId;
1557 
1558     for (uint256 i = 0; i < quantity; i++) {
1559       emit Transfer(address(0), to, updatedIndex);
1560       require(
1561         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1562         "ERC721A: transfer to non ERC721Receiver implementer"
1563       );
1564       updatedIndex++;
1565     }
1566 
1567     currentIndex = updatedIndex;
1568     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1569   }
1570 
1571   /**
1572    * @dev Transfers `tokenId` from `from` to `to`.
1573    *
1574    * Requirements:
1575    *
1576    * - `to` cannot be the zero address.
1577    * - `tokenId` token must be owned by `from`.
1578    *
1579    * Emits a {Transfer} event.
1580    */
1581   function _transfer(
1582     address from,
1583     address to,
1584     uint256 tokenId
1585   ) private {
1586     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1587 
1588     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1589       getApproved(tokenId) == _msgSender() ||
1590       isApprovedForAll(prevOwnership.addr, _msgSender()));
1591 
1592     require(
1593       isApprovedOrOwner,
1594       "ERC721A: transfer caller is not owner nor approved"
1595     );
1596 
1597     require(
1598       prevOwnership.addr == from,
1599       "ERC721A: transfer from incorrect owner"
1600     );
1601     require(to != address(0), "ERC721A: transfer to the zero address");
1602 
1603     _beforeTokenTransfers(from, to, tokenId, 1);
1604 
1605     // Clear approvals from the previous owner
1606     _approve(address(0), tokenId, prevOwnership.addr);
1607 
1608     _addressData[from].balance -= 1;
1609     _addressData[to].balance += 1;
1610     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1611 
1612     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1613     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1614     uint256 nextTokenId = tokenId + 1;
1615     if (_ownerships[nextTokenId].addr == address(0)) {
1616       if (_exists(nextTokenId)) {
1617         _ownerships[nextTokenId] = TokenOwnership(
1618           prevOwnership.addr,
1619           prevOwnership.startTimestamp
1620         );
1621       }
1622     }
1623 
1624     emit Transfer(from, to, tokenId);
1625     _afterTokenTransfers(from, to, tokenId, 1);
1626   }
1627 
1628   /**
1629    * @dev Approve `to` to operate on `tokenId`
1630    *
1631    * Emits a {Approval} event.
1632    */
1633   function _approve(
1634     address to,
1635     uint256 tokenId,
1636     address owner
1637   ) private {
1638     _tokenApprovals[tokenId] = to;
1639     emit Approval(owner, to, tokenId);
1640   }
1641 
1642   uint256 public nextOwnerToExplicitlySet = 0;
1643 
1644   /**
1645    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1646    */
1647   function _setOwnersExplicit(uint256 quantity) internal {
1648     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1649     require(quantity > 0, "quantity must be nonzero");
1650     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1651     if (endIndex > collectionSize - 1) {
1652       endIndex = collectionSize - 1;
1653     }
1654     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1655     require(_exists(endIndex), "not enough minted yet for this cleanup");
1656     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1657       if (_ownerships[i].addr == address(0)) {
1658         TokenOwnership memory ownership = ownershipOf(i);
1659         _ownerships[i] = TokenOwnership(
1660           ownership.addr,
1661           ownership.startTimestamp
1662         );
1663       }
1664     }
1665     nextOwnerToExplicitlySet = endIndex + 1;
1666   }
1667 
1668   /**
1669    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1670    * The call is not executed if the target address is not a contract.
1671    *
1672    * @param from address representing the previous owner of the given token ID
1673    * @param to target address that will receive the tokens
1674    * @param tokenId uint256 ID of the token to be transferred
1675    * @param _data bytes optional data to send along with the call
1676    * @return bool whether the call correctly returned the expected magic value
1677    */
1678   function _checkOnERC721Received(
1679     address from,
1680     address to,
1681     uint256 tokenId,
1682     bytes memory _data
1683   ) private returns (bool) {
1684     if (to.isContract()) {
1685       try
1686         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1687       returns (bytes4 retval) {
1688         return retval == IERC721Receiver(to).onERC721Received.selector;
1689       } catch (bytes memory reason) {
1690         if (reason.length == 0) {
1691           revert("ERC721A: transfer to non ERC721Receiver implementer");
1692         } else {
1693           assembly {
1694             revert(add(32, reason), mload(reason))
1695           }
1696         }
1697       }
1698     } else {
1699       return true;
1700     }
1701   }
1702 
1703   /**
1704    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1705    *
1706    * startTokenId - the first token id to be transferred
1707    * quantity - the amount to be transferred
1708    *
1709    * Calling conditions:
1710    *
1711    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1712    * transferred to `to`.
1713    * - When `from` is zero, `tokenId` will be minted for `to`.
1714    */
1715   function _beforeTokenTransfers(
1716     address from,
1717     address to,
1718     uint256 startTokenId,
1719     uint256 quantity
1720   ) internal virtual {}
1721 
1722   /**
1723    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1724    * minting.
1725    *
1726    * startTokenId - the first token id to be transferred
1727    * quantity - the amount to be transferred
1728    *
1729    * Calling conditions:
1730    *
1731    * - when `from` and `to` are both non-zero.
1732    * - `from` and `to` are never both zero.
1733    */
1734   function _afterTokenTransfers(
1735     address from,
1736     address to,
1737     uint256 startTokenId,
1738     uint256 quantity
1739   ) internal virtual {}
1740 }
1741 
1742 //SPDX-License-Identifier: MIT
1743 //Contract based on [https://docs.openzeppelin.com/contracts/3.x/erc721](https://docs.openzeppelin.com/contracts/3.x/erc721)
1744 
1745 pragma solidity ^0.8.0;
1746 
1747 
1748 
1749 
1750 
1751 
1752 
1753 
1754 
1755 contract clickCLACKclick is ERC721A, IERC2981, Ownable, ReentrancyGuard {
1756     using Counters for Counters.Counter;
1757     using Strings for uint256;
1758 
1759     Counters.Counter private tokenCounter;
1760 
1761     string private baseURI = "ipfs://QmPG8pQDHUpwbb4DME4Mof6rLuvGDRVUA4TQiXSJWckcmx";
1762     address private openSeaProxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1763     bool private isOpenSeaProxyActive = true;
1764 
1765     uint256 public constant MAX_MINTS_PER_TX = 4;
1766     uint256 public maxSupply = 3456;
1767 
1768     uint256 public constant PUBLIC_SALE_PRICE = 0.01 ether;
1769     uint256 public NUM_FREE_MINTS = 456;
1770     bool public isPublicSaleActive = true;
1771 
1772 
1773 
1774 
1775     // ============ ACCESS CONTROL/SANITY MODIFIERS ============
1776 
1777     modifier publicSaleActive() {
1778         require(isPublicSaleActive, "Public sale is not open");
1779         _;
1780     }
1781 
1782 
1783 
1784     modifier maxMintsPerTX(uint256 numberOfTokens) {
1785         require(
1786             numberOfTokens <= MAX_MINTS_PER_TX,
1787             "Max mints per transaction exceeded"
1788         );
1789         _;
1790     }
1791 
1792     modifier canMintNFTs(uint256 numberOfTokens) {
1793         require(
1794             totalSupply() + numberOfTokens <=
1795                 maxSupply,
1796             "Not enough mints remaining to mint"
1797         );
1798         _;
1799     }
1800 
1801     modifier freeMintsAvailable() {
1802         require(
1803             totalSupply() <=
1804                 NUM_FREE_MINTS,
1805             "Not enough free mints remain"
1806         );
1807         _;
1808     }
1809 
1810 
1811 
1812     modifier isCorrectPayment(uint256 price, uint256 numberOfTokens) {
1813         if(totalSupply()>NUM_FREE_MINTS){
1814         require(
1815             (price * numberOfTokens) == msg.value,
1816             "Incorrect ETH value sent"
1817         );
1818         }
1819         _;
1820     }
1821 
1822 
1823     constructor(
1824     ) ERC721A("clickCLACKclick", "doyounodawae", 100, maxSupply) {
1825     }
1826 
1827     // ============ PUBLIC FUNCTIONS FOR MINTING ============
1828 
1829     function mint(uint256 numberOfTokens)
1830         external
1831         payable
1832         nonReentrant
1833         isCorrectPayment(PUBLIC_SALE_PRICE, numberOfTokens)
1834         publicSaleActive
1835         canMintNFTs(numberOfTokens)
1836         maxMintsPerTX(numberOfTokens)
1837     {
1838 
1839         _safeMint(msg.sender, numberOfTokens);
1840     }
1841 
1842 
1843 
1844     //A simple free mint function to avoid confusion
1845     //The normal mint function with a cost of 0 would work too
1846 
1847     // ============ PUBLIC READ-ONLY FUNCTIONS ============
1848 
1849     function getBaseURI() external view returns (string memory) {
1850         return baseURI;
1851     }
1852 
1853     // ============ OWNER-ONLY ADMIN FUNCTIONS ============
1854 
1855     function setBaseURI(string memory _baseURI) external onlyOwner {
1856         baseURI = _baseURI;
1857     }
1858 
1859     // function to disable gasless listings for security in case
1860     // opensea ever shuts down or is compromised
1861     function setIsOpenSeaProxyActive(bool _isOpenSeaProxyActive)
1862         external
1863         onlyOwner
1864     {
1865         isOpenSeaProxyActive = _isOpenSeaProxyActive;
1866     }
1867 
1868     function setIsPublicSaleActive(bool _isPublicSaleActive)
1869         external
1870         onlyOwner
1871     {
1872         isPublicSaleActive = _isPublicSaleActive;
1873     }
1874 
1875 
1876     function setNumFreeMints(uint256 _numfreemints)
1877         external
1878         onlyOwner
1879     {
1880         NUM_FREE_MINTS = _numfreemints;
1881     }
1882 
1883 
1884     function withdraw() public onlyOwner {
1885         uint256 balance = address(this).balance;
1886         payable(msg.sender).transfer(balance);
1887     }
1888 
1889     function withdrawTokens(IERC20 token) public onlyOwner {
1890         uint256 balance = token.balanceOf(address(this));
1891         token.transfer(msg.sender, balance);
1892     }
1893 
1894 
1895 
1896     // ============ SUPPORTING FUNCTIONS ============
1897 
1898     function nextTokenId() private returns (uint256) {
1899         tokenCounter.increment();
1900         return tokenCounter.current();
1901     }
1902 
1903     // ============ FUNCTION OVERRIDES ============
1904 
1905     function supportsInterface(bytes4 interfaceId)
1906         public
1907         view
1908         virtual
1909         override(ERC721A, IERC165)
1910         returns (bool)
1911     {
1912         return
1913             interfaceId == type(IERC2981).interfaceId ||
1914             super.supportsInterface(interfaceId);
1915     }
1916 
1917     /**
1918      * @dev Override isApprovedForAll to allowlist user's OpenSea proxy accounts to enable gas-less listings.
1919      */
1920     function isApprovedForAll(address owner, address operator)
1921         public
1922         view
1923         override
1924         returns (bool)
1925     {
1926         // Get a reference to OpenSea's proxy registry contract by instantiating
1927         // the contract using the already existing address.
1928         ProxyRegistry proxyRegistry = ProxyRegistry(
1929             openSeaProxyRegistryAddress
1930         );
1931         if (
1932             isOpenSeaProxyActive &&
1933             address(proxyRegistry.proxies(owner)) == operator
1934         ) {
1935             return true;
1936         }
1937 
1938         return super.isApprovedForAll(owner, operator);
1939     }
1940 
1941     /**
1942      * @dev See {IERC721Metadata-tokenURI}.
1943      */
1944     function tokenURI(uint256 tokenId)
1945         public
1946         view
1947         virtual
1948         override
1949         returns (string memory)
1950     {
1951         require(_exists(tokenId), "Nonexistent token");
1952 
1953         return
1954             string(abi.encodePacked(baseURI, "/", (tokenId+1).toString(), ".json"));
1955     }
1956 
1957     /**
1958      * @dev See {IERC165-royaltyInfo}.
1959      */
1960     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1961         external
1962         view
1963         override
1964         returns (address receiver, uint256 royaltyAmount)
1965     {
1966         require(_exists(tokenId), "Nonexistent token");
1967 
1968         return (address(this), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
1969     }
1970 }
1971 
1972 // These contract definitions are used to create a reference to the OpenSea
1973 // ProxyRegistry contract by using the registry's address (see isApprovedForAll).
1974 contract OwnableDelegateProxy {
1975 
1976 }
1977 
1978 contract ProxyRegistry {
1979     mapping(address => OwnableDelegateProxy) public proxies;
1980 }