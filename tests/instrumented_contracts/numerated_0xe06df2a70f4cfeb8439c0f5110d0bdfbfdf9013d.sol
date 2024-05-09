1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 /*
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 abstract contract Context {
105     function _msgSender() internal view virtual returns (address) {
106         return msg.sender;
107     }
108 
109     function _msgData() internal view virtual returns (bytes calldata) {
110         return msg.data;
111     }
112 }
113 
114 
115 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
116 
117 
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Contract module which provides a basic access control mechanism, where
123  * there is an account (an owner) that can be granted exclusive access to
124  * specific functions.
125  *
126  * By default, the owner account will be the one that deploys the contract. This
127  * can later be changed with {transferOwnership}.
128  *
129  * This module is used through inheritance. It will make available the modifier
130  * `onlyOwner`, which can be applied to your functions to restrict their use to
131  * the owner.
132  */
133 abstract contract Ownable is Context {
134     address private _owner;
135 
136     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
137 
138     /**
139      * @dev Initializes the contract setting the deployer as the initial owner.
140      */
141     constructor() {
142         _setOwner(_msgSender());
143     }
144 
145     /**
146      * @dev Returns the address of the current owner.
147      */
148     function owner() public view virtual returns (address) {
149         return _owner;
150     }
151 
152     /**
153      * @dev Throws if called by any account other than the owner.
154      */
155     modifier onlyOwner() {
156         require(owner() == _msgSender(), "Ownable: caller is not the owner");
157         _;
158     }
159 
160     /**
161      * @dev Leaves the contract without owner. It will not be possible to call
162      * `onlyOwner` functions anymore. Can only be called by the current owner.
163      *
164      * NOTE: Renouncing ownership will leave the contract without an owner,
165      * thereby removing any functionality that is only available to the owner.
166      */
167     function renounceOwnership() public virtual onlyOwner {
168         _setOwner(address(0));
169     }
170 
171     /**
172      * @dev Transfers ownership of the contract to a new account (`newOwner`).
173      * Can only be called by the current owner.
174      */
175     function transferOwnership(address newOwner) public virtual onlyOwner {
176         require(newOwner != address(0), "Ownable: new owner is the zero address");
177         _setOwner(newOwner);
178     }
179 
180     function _setOwner(address newOwner) private {
181         address oldOwner = _owner;
182         _owner = newOwner;
183         emit OwnershipTransferred(oldOwner, newOwner);
184     }
185 }
186 
187 
188 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.2.0
189 
190 
191 
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Contract module that helps prevent reentrant calls to a function.
196  *
197  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
198  * available, which can be applied to functions to make sure there are no nested
199  * (reentrant) calls to them.
200  *
201  * Note that because there is a single `nonReentrant` guard, functions marked as
202  * `nonReentrant` may not call one another. This can be worked around by making
203  * those functions `private`, and then adding `external` `nonReentrant` entry
204  * points to them.
205  *
206  * TIP: If you would like to learn more about reentrancy and alternative ways
207  * to protect against it, check out our blog post
208  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
209  */
210 abstract contract ReentrancyGuard {
211     // Booleans are more expensive than uint256 or any type that takes up a full
212     // word because each write operation emits an extra SLOAD to first read the
213     // slot's contents, replace the bits taken up by the boolean, and then write
214     // back. This is the compiler's defense against contract upgrades and
215     // pointer aliasing, and it cannot be disabled.
216 
217     // The values being non-zero value makes deployment a bit more expensive,
218     // but in exchange the refund on every call to nonReentrant will be lower in
219     // amount. Since refunds are capped to a percentage of the total
220     // transaction's gas, it is best to keep them low in cases like this one, to
221     // increase the likelihood of the full refund coming into effect.
222     uint256 private constant _NOT_ENTERED = 1;
223     uint256 private constant _ENTERED = 2;
224 
225     uint256 private _status;
226 
227     constructor() {
228         _status = _NOT_ENTERED;
229     }
230 
231     /**
232      * @dev Prevents a contract from calling itself, directly or indirectly.
233      * Calling a `nonReentrant` function from another `nonReentrant`
234      * function is not supported. It is possible to prevent this from happening
235      * by making the `nonReentrant` function external, and make it call a
236      * `private` function that does the actual work.
237      */
238     modifier nonReentrant() {
239         // On the first call to nonReentrant, _notEntered will be true
240         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
241 
242         // Any calls to nonReentrant after this point will fail
243         _status = _ENTERED;
244 
245         _;
246 
247         // By storing the original value once again, a refund is triggered (see
248         // https://eips.ethereum.org/EIPS/eip-2200)
249         _status = _NOT_ENTERED;
250     }
251 }
252 
253 
254 // File @openzeppelin/contracts/utils/math/Math.sol@v4.2.0
255 
256 
257 
258 pragma solidity ^0.8.0;
259 
260 /**
261  * @dev Standard math utilities missing in the Solidity language.
262  */
263 library Math {
264     /**
265      * @dev Returns the largest of two numbers.
266      */
267     function max(uint256 a, uint256 b) internal pure returns (uint256) {
268         return a >= b ? a : b;
269     }
270 
271     /**
272      * @dev Returns the smallest of two numbers.
273      */
274     function min(uint256 a, uint256 b) internal pure returns (uint256) {
275         return a < b ? a : b;
276     }
277 
278     /**
279      * @dev Returns the average of two numbers. The result is rounded towards
280      * zero.
281      */
282     function average(uint256 a, uint256 b) internal pure returns (uint256) {
283         // (a + b) / 2 can overflow, so we distribute.
284         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
285     }
286 
287     /**
288      * @dev Returns the ceiling of the division of two numbers.
289      *
290      * This differs from standard division with `/` in that it rounds up instead
291      * of rounding down.
292      */
293     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
294         // (a + b - 1) / b can overflow on addition, so we distribute.
295         return a / b + (a % b == 0 ? 0 : 1);
296     }
297 }
298 
299 
300 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
301 
302 
303 
304 pragma solidity ^0.8.0;
305 
306 // CAUTION
307 // This version of SafeMath should only be used with Solidity 0.8 or later,
308 // because it relies on the compiler's built in overflow checks.
309 
310 /**
311  * @dev Wrappers over Solidity's arithmetic operations.
312  *
313  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
314  * now has built in overflow checking.
315  */
316 library SafeMath {
317     /**
318      * @dev Returns the addition of two unsigned integers, with an overflow flag.
319      *
320      * _Available since v3.4._
321      */
322     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
323         unchecked {
324             uint256 c = a + b;
325             if (c < a) return (false, 0);
326             return (true, c);
327         }
328     }
329 
330     /**
331      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
332      *
333      * _Available since v3.4._
334      */
335     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         unchecked {
337             if (b > a) return (false, 0);
338             return (true, a - b);
339         }
340     }
341 
342     /**
343      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
344      *
345      * _Available since v3.4._
346      */
347     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
348         unchecked {
349             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
350             // benefit is lost if 'b' is also tested.
351             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
352             if (a == 0) return (true, 0);
353             uint256 c = a * b;
354             if (c / a != b) return (false, 0);
355             return (true, c);
356         }
357     }
358 
359     /**
360      * @dev Returns the division of two unsigned integers, with a division by zero flag.
361      *
362      * _Available since v3.4._
363      */
364     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
365         unchecked {
366             if (b == 0) return (false, 0);
367             return (true, a / b);
368         }
369     }
370 
371     /**
372      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
373      *
374      * _Available since v3.4._
375      */
376     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
377         unchecked {
378             if (b == 0) return (false, 0);
379             return (true, a % b);
380         }
381     }
382 
383     /**
384      * @dev Returns the addition of two unsigned integers, reverting on
385      * overflow.
386      *
387      * Counterpart to Solidity's `+` operator.
388      *
389      * Requirements:
390      *
391      * - Addition cannot overflow.
392      */
393     function add(uint256 a, uint256 b) internal pure returns (uint256) {
394         return a + b;
395     }
396 
397     /**
398      * @dev Returns the subtraction of two unsigned integers, reverting on
399      * overflow (when the result is negative).
400      *
401      * Counterpart to Solidity's `-` operator.
402      *
403      * Requirements:
404      *
405      * - Subtraction cannot overflow.
406      */
407     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
408         return a - b;
409     }
410 
411     /**
412      * @dev Returns the multiplication of two unsigned integers, reverting on
413      * overflow.
414      *
415      * Counterpart to Solidity's `*` operator.
416      *
417      * Requirements:
418      *
419      * - Multiplication cannot overflow.
420      */
421     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
422         return a * b;
423     }
424 
425     /**
426      * @dev Returns the integer division of two unsigned integers, reverting on
427      * division by zero. The result is rounded towards zero.
428      *
429      * Counterpart to Solidity's `/` operator.
430      *
431      * Requirements:
432      *
433      * - The divisor cannot be zero.
434      */
435     function div(uint256 a, uint256 b) internal pure returns (uint256) {
436         return a / b;
437     }
438 
439     /**
440      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
441      * reverting when dividing by zero.
442      *
443      * Counterpart to Solidity's `%` operator. This function uses a `revert`
444      * opcode (which leaves remaining gas untouched) while Solidity uses an
445      * invalid opcode to revert (consuming all remaining gas).
446      *
447      * Requirements:
448      *
449      * - The divisor cannot be zero.
450      */
451     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
452         return a % b;
453     }
454 
455     /**
456      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
457      * overflow (when the result is negative).
458      *
459      * CAUTION: This function is deprecated because it requires allocating memory for the error
460      * message unnecessarily. For custom revert reasons use {trySub}.
461      *
462      * Counterpart to Solidity's `-` operator.
463      *
464      * Requirements:
465      *
466      * - Subtraction cannot overflow.
467      */
468     function sub(
469         uint256 a,
470         uint256 b,
471         string memory errorMessage
472     ) internal pure returns (uint256) {
473         unchecked {
474             require(b <= a, errorMessage);
475             return a - b;
476         }
477     }
478 
479     /**
480      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
481      * division by zero. The result is rounded towards zero.
482      *
483      * Counterpart to Solidity's `/` operator. Note: this function uses a
484      * `revert` opcode (which leaves remaining gas untouched) while Solidity
485      * uses an invalid opcode to revert (consuming all remaining gas).
486      *
487      * Requirements:
488      *
489      * - The divisor cannot be zero.
490      */
491     function div(
492         uint256 a,
493         uint256 b,
494         string memory errorMessage
495     ) internal pure returns (uint256) {
496         unchecked {
497             require(b > 0, errorMessage);
498             return a / b;
499         }
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
504      * reverting with custom message when dividing by zero.
505      *
506      * CAUTION: This function is deprecated because it requires allocating memory for the error
507      * message unnecessarily. For custom revert reasons use {tryMod}.
508      *
509      * Counterpart to Solidity's `%` operator. This function uses a `revert`
510      * opcode (which leaves remaining gas untouched) while Solidity uses an
511      * invalid opcode to revert (consuming all remaining gas).
512      *
513      * Requirements:
514      *
515      * - The divisor cannot be zero.
516      */
517     function mod(
518         uint256 a,
519         uint256 b,
520         string memory errorMessage
521     ) internal pure returns (uint256) {
522         unchecked {
523             require(b > 0, errorMessage);
524             return a % b;
525         }
526     }
527 }
528 
529 
530 // File contracts/ethereum/Vesting.sol
531 
532 
533 pragma solidity 0.8.4;
534 
535 
536 
537 
538 
539 contract Vesting is Ownable, ReentrancyGuard {
540     using SafeMath for uint256;
541 
542     event TokensClaimed(address indexed beneficient, uint256 amount);
543 
544 
545     IERC20 private _token;
546 
547     uint256 private _vestingLaunchBlock;
548 
549     uint256 private _numberOfParts;
550 
551     mapping(address => uint256) private _beneficientsTokens;
552 
553     mapping(address => uint256) private _beneficientsClaimedTokens;
554 
555     mapping(address => uint256) private _beneficientsLastClaimedBlock;
556 
557 
558     constructor(address token_, uint256 blockNumber) Ownable() {
559         _token = IERC20(token_);
560         _vestingLaunchBlock = blockNumber;
561     }
562 
563     function beneficientsTokens(address beneficient) external view returns(uint256) {
564         return _beneficientsTokens[beneficient];
565     }
566 
567     function availableToClaim(address beneficient) public view returns(uint256) {
568         uint256 blocksPassed = block.number - _beneficientsLastClaimedBlock[beneficient];
569         return Math.min(_beneficientsTokens[beneficient].div(_numberOfParts).mul(blocksPassed), _beneficientsTokens[beneficient].sub(_beneficientsClaimedTokens[beneficient]));
570     }
571 
572     function totalClaimed(address beneficient) public view returns(uint256) {
573         return _beneficientsClaimedTokens[beneficient];
574     }
575 
576     function totalLeft(address beneficient) public view returns(uint256) {
577         return _beneficientsTokens[beneficient] - totalClaimed(beneficient);
578     }
579 
580     function claim() external nonReentrant {
581         uint256 tokensToClaim = availableToClaim(msg.sender);
582         require(tokensToClaim > 0, "Vesting: All tokens claimed");
583         _beneficientsLastClaimedBlock[msg.sender] = block.number;
584         _beneficientsClaimedTokens[msg.sender] = _beneficientsClaimedTokens[msg.sender].add(tokensToClaim);
585         require(_token.transfer(msg.sender, tokensToClaim), "Vesting: Something went wrong with token transfer");
586         emit TokensClaimed(msg.sender, tokensToClaim);
587     }
588 
589     function addBeneficients(address[] memory beneficients, uint256[] memory amounts) external onlyOwner {
590         uint256 length = beneficients.length;
591         require(length == amounts.length, "Vesting: Must pass the same number of beneficients and amounts");
592         for (uint256 i = 0; i < length; i++) {
593             _beneficientsTokens[beneficients[i]] = amounts[i];
594             _beneficientsLastClaimedBlock[beneficients[i]] = _vestingLaunchBlock;
595         }
596     }
597 
598     function setNumberOfParts(uint256 numberOfParts) external onlyOwner {
599         _numberOfParts = numberOfParts;
600     }
601 
602     function withdrawERC20(address token, address recipent) external onlyOwner {
603         require(IERC20(token).transfer(recipent, IERC20(token).balanceOf(address(this))), "MoonieIDOPayments: Something went wrong with ERC20 withdrawal");
604     }
605 }