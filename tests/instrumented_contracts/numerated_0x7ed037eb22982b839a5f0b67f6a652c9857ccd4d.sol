1 // Multi-Stake Capital: $MSC
2 // -You buy on Ethereum, we bond and stake on multiple chains and return the profits to $MSC holders.
3 
4 // Tokenomics:
5 // 10% of each buy goes to existing holders.
6 // 10% of each sell goes into multi-chain bonding and staking to add to the treasury and buy back MSC tokens.
7 
8 // Website: https://multistakecapital.link
9 
10 // Twitter: https://twitter.com/MulStakeCapital
11 
12 //
13 //   /$$$  /$$$$$$  /$$$$$$$$/$$$$$$  /$$   /$$ /$$$$$$$$                  /$$$$$$  /$$$$$$$$/$$$$$$  /$$   /$$ /$$$$$$$$/$$$  
14 //  /$$_/ /$$__  $$|__  $$__/$$__  $$| $$  /$$/| $$_____/                 /$$__  $$|__  $$__/$$__  $$| $$  /$$/| $$_____/_  $$ 
15 // /$$/  | $$  \__/   | $$ | $$  \ $$| $$ /$$/ | $$                      | $$  \__/   | $$ | $$  \ $$| $$ /$$/ | $$       \  $$
16 //| $$   |  $$$$$$    | $$ | $$$$$$$$| $$$$$/  | $$$$$                   |  $$$$$$    | $$ | $$$$$$$$| $$$$$/  | $$$$$     | $$
17 //| $$    \____  $$   | $$ | $$__  $$| $$  $$  | $$__/                    \____  $$   | $$ | $$__  $$| $$  $$  | $$__/     | $$
18 //|  $$   /$$  \ $$   | $$ | $$  | $$| $$\  $$ | $$                       /$$  \ $$   | $$ | $$  | $$| $$\  $$ | $$        /$$/
19 // \  $$$|  $$$$$$/   | $$ | $$  | $$| $$ \  $$| $$$$$$$$       /$$      |  $$$$$$/   | $$ | $$  | $$| $$ \  $$| $$$$$$$$/$$$/ 
20 //  \___/ \______/    |__/ |__/  |__/|__/  \__/|________/      | $/       \______/    |__/ |__/  |__/|__/  \__/|________/___/  
21 //  
22 
23 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 // CAUTION
30 // This version of SafeMath should only be used with Solidity 0.8 or later,
31 // because it relies on the compiler's built in overflow checks.
32 
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations.
35  *
36  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
37  * now has built in overflow checking.
38  */
39 library SafeMath {
40     /**
41      * @dev Returns the addition of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         unchecked {
47             uint256 c = a + b;
48             if (c < a) return (false, 0);
49             return (true, c);
50         }
51     }
52 
53     /**
54      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
55      *
56      * _Available since v3.4._
57      */
58     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
59         unchecked {
60             if (b > a) return (false, 0);
61             return (true, a - b);
62         }
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         unchecked {
72             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
73             // benefit is lost if 'b' is also tested.
74             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
75             if (a == 0) return (true, 0);
76             uint256 c = a * b;
77             if (c / a != b) return (false, 0);
78             return (true, c);
79         }
80     }
81 
82     /**
83      * @dev Returns the division of two unsigned integers, with a division by zero flag.
84      *
85      * _Available since v3.4._
86      */
87     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
88         unchecked {
89             if (b == 0) return (false, 0);
90             return (true, a / b);
91         }
92     }
93 
94     /**
95      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
96      *
97      * _Available since v3.4._
98      */
99     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
100         unchecked {
101             if (b == 0) return (false, 0);
102             return (true, a % b);
103         }
104     }
105 
106     /**
107      * @dev Returns the addition of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `+` operator.
111      *
112      * Requirements:
113      *
114      * - Addition cannot overflow.
115      */
116     function add(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a + b;
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a - b;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         return a * b;
146     }
147 
148     /**
149      * @dev Returns the integer division of two unsigned integers, reverting on
150      * division by zero. The result is rounded towards zero.
151      *
152      * Counterpart to Solidity's `/` operator.
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return a / b;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * reverting when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return a % b;
176     }
177 
178     /**
179      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
180      * overflow (when the result is negative).
181      *
182      * CAUTION: This function is deprecated because it requires allocating memory for the error
183      * message unnecessarily. For custom revert reasons use {trySub}.
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         unchecked {
197             require(b <= a, errorMessage);
198             return a - b;
199         }
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(
215         uint256 a,
216         uint256 b,
217         string memory errorMessage
218     ) internal pure returns (uint256) {
219         unchecked {
220             require(b > 0, errorMessage);
221             return a / b;
222         }
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting with custom message when dividing by zero.
228      *
229      * CAUTION: This function is deprecated because it requires allocating memory for the error
230      * message unnecessarily. For custom revert reasons use {tryMod}.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         unchecked {
246             require(b > 0, errorMessage);
247             return a % b;
248         }
249     }
250 }
251 
252 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
253 
254 
255 // OpenZeppelin Contracts v4.3.2 (token/ERC20/IERC20.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Interface of the ERC20 standard as defined in the EIP.
261  */
262 interface IERC20 {
263     /**
264      * @dev Returns the amount of tokens in existence.
265      */
266     function totalSupply() external view returns (uint256);
267 
268     /**
269      * @dev Returns the amount of tokens owned by `account`.
270      */
271     function balanceOf(address account) external view returns (uint256);
272 
273     /**
274      * @dev Moves `amount` tokens from the caller's account to `recipient`.
275      *
276      * Returns a boolean value indicating whether the operation succeeded.
277      *
278      * Emits a {Transfer} event.
279      */
280     function transfer(address recipient, uint256 amount) external returns (bool);
281 
282     /**
283      * @dev Returns the remaining number of tokens that `spender` will be
284      * allowed to spend on behalf of `owner` through {transferFrom}. This is
285      * zero by default.
286      *
287      * This value changes when {approve} or {transferFrom} are called.
288      */
289     function allowance(address owner, address spender) external view returns (uint256);
290 
291     /**
292      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
293      *
294      * Returns a boolean value indicating whether the operation succeeded.
295      *
296      * IMPORTANT: Beware that changing an allowance with this method brings the risk
297      * that someone may use both the old and the new allowance by unfortunate
298      * transaction ordering. One possible solution to mitigate this race
299      * condition is to first reduce the spender's allowance to 0 and set the
300      * desired value afterwards:
301      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
302      *
303      * Emits an {Approval} event.
304      */
305     function approve(address spender, uint256 amount) external returns (bool);
306 
307     /**
308      * @dev Moves `amount` tokens from `sender` to `recipient` using the
309      * allowance mechanism. `amount` is then deducted from the caller's
310      * allowance.
311      *
312      * Returns a boolean value indicating whether the operation succeeded.
313      *
314      * Emits a {Transfer} event.
315      */
316     function transferFrom(
317         address sender,
318         address recipient,
319         uint256 amount
320     ) external returns (bool);
321 
322     /**
323      * @dev Emitted when `value` tokens are moved from one account (`from`) to
324      * another (`to`).
325      *
326      * Note that `value` may be zero.
327      */
328     event Transfer(address indexed from, address indexed to, uint256 value);
329 
330     /**
331      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
332      * a call to {approve}. `value` is the new allowance.
333      */
334     event Approval(address indexed owner, address indexed spender, uint256 value);
335 }
336 // File: @openzeppelin/contracts/utils/Context.sol
337 
338 
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Provides information about the current execution context, including the
344  * sender of the transaction and its data. While these are generally available
345  * via msg.sender and msg.data, they should not be accessed in such a direct
346  * manner, since when dealing with meta-transactions the account sending and
347  * paying for execution may not be the actual sender (as far as an application
348  * is concerned).
349  *
350  * This contract is only required for intermediate, library-like contracts.
351  */
352 abstract contract Context {
353     function _msgSender() internal view virtual returns (address) {
354         return msg.sender;
355     }
356 
357     function _msgData() internal view virtual returns (bytes calldata) {
358         return msg.data;
359     }
360 }
361 
362 // File: @openzeppelin/contracts/access/Ownable.sol
363 
364 
365 
366 pragma solidity ^0.8.0;
367 
368 
369 /**
370  * @dev Contract module which provides a basic access control mechanism, where
371  * there is an account (an owner) that can be granted exclusive access to
372  * specific functions.
373  *
374  * By default, the owner account will be the one that deploys the contract. This
375  * can later be changed with {transferOwnership}.
376  *
377  * This module is used through inheritance. It will make available the modifier
378  * `onlyOwner`, which can be applied to your functions to restrict their use to
379  * the owner.
380  */
381 abstract contract Ownable is Context {
382     address private _owner;
383 
384     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
385 
386     /**
387      * @dev Initializes the contract setting the deployer as the initial owner.
388      */
389     constructor() {
390         _setOwner(_msgSender());
391     }
392 
393     /**
394      * @dev Returns the address of the current owner.
395      */
396     function owner() public view virtual returns (address) {
397         return _owner;
398     }
399 
400     /**
401      * @dev Throws if called by any account other than the owner.
402      */
403     modifier onlyOwner() {
404         require(owner() == _msgSender(), "Ownable: caller is not the owner");
405         _;
406     }
407 
408     /**
409      * @dev Leaves the contract without owner. It will not be possible to call
410      * `onlyOwner` functions anymore. Can only be called by the current owner.
411      *
412      * NOTE: Renouncing ownership will leave the contract without an owner,
413      * thereby removing any functionality that is only available to the owner.
414      */
415     function renounceOwnership() public virtual onlyOwner {
416         _setOwner(address(0));
417     }
418 
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Can only be called by the current owner.
422      */
423     function transferOwnership(address newOwner) public virtual onlyOwner {
424         require(newOwner != address(0), "Ownable: new owner is the zero address");
425         _setOwner(newOwner);
426     }
427 
428     function _setOwner(address newOwner) private {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Address.sol
436 
437 
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Collection of functions related to the address type
443  */
444 library Address {
445     /**
446      * @dev Returns true if `account` is a contract.
447      *
448      * [IMPORTANT]
449      * ====
450      * It is unsafe to assume that an address for which this function returns
451      * false is an externally-owned account (EOA) and not a contract.
452      *
453      * Among others, `isContract` will return false for the following
454      * types of addresses:
455      *
456      *  - an externally-owned account
457      *  - a contract in construction
458      *  - an address where a contract will be created
459      *  - an address where a contract lived, but was destroyed
460      * ====
461      */
462     function isContract(address account) internal view returns (bool) {
463         // This method relies on extcodesize, which returns 0 for contracts in
464         // construction, since the code is only stored at the end of the
465         // constructor execution.
466 
467         uint256 size;
468         assembly {
469             size := extcodesize(account)
470         }
471         return size > 0;
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      */
490     function sendValue(address payable recipient, uint256 amount) internal {
491         require(address(this).balance >= amount, "Address: insufficient balance");
492 
493         (bool success, ) = recipient.call{value: amount}("");
494         require(success, "Address: unable to send value, recipient may have reverted");
495     }
496 
497     /**
498      * @dev Performs a Solidity function call using a low level `call`. A
499      * plain `call` is an unsafe replacement for a function call: use this
500      * function instead.
501      *
502      * If `target` reverts with a revert reason, it is bubbled up by this
503      * function (like regular Solidity function calls).
504      *
505      * Returns the raw returned data. To convert to the expected return value,
506      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
507      *
508      * Requirements:
509      *
510      * - `target` must be a contract.
511      * - calling `target` with `data` must not revert.
512      *
513      * _Available since v3.1._
514      */
515     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
516         return functionCall(target, data, "Address: low-level call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
521      * `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, 0, errorMessage);
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
535      * but also transferring `value` wei to `target`.
536      *
537      * Requirements:
538      *
539      * - the calling contract must have an ETH balance of at least `value`.
540      * - the called Solidity function must be `payable`.
541      *
542      * _Available since v3.1._
543      */
544     function functionCallWithValue(
545         address target,
546         bytes memory data,
547         uint256 value
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
554      * with `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCallWithValue(
559         address target,
560         bytes memory data,
561         uint256 value,
562         string memory errorMessage
563     ) internal returns (bytes memory) {
564         require(address(this).balance >= value, "Address: insufficient balance for call");
565         require(isContract(target), "Address: call to non-contract");
566 
567         (bool success, bytes memory returndata) = target.call{value: value}(data);
568         return verifyCallResult(success, returndata, errorMessage);
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
578         return functionStaticCall(target, data, "Address: low-level static call failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(
588         address target,
589         bytes memory data,
590         string memory errorMessage
591     ) internal view returns (bytes memory) {
592         require(isContract(target), "Address: static call to non-contract");
593 
594         (bool success, bytes memory returndata) = target.staticcall(data);
595         return verifyCallResult(success, returndata, errorMessage);
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
600      * but performing a delegate call.
601      *
602      * _Available since v3.4._
603      */
604     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
605         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
606     }
607 
608     /**
609      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
610      * but performing a delegate call.
611      *
612      * _Available since v3.4._
613      */
614     function functionDelegateCall(
615         address target,
616         bytes memory data,
617         string memory errorMessage
618     ) internal returns (bytes memory) {
619         require(isContract(target), "Address: delegate call to non-contract");
620 
621         (bool success, bytes memory returndata) = target.delegatecall(data);
622         return verifyCallResult(success, returndata, errorMessage);
623     }
624 
625     /**
626      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
627      * revert reason using the provided one.
628      *
629      * _Available since v4.3._
630      */
631     function verifyCallResult(
632         bool success,
633         bytes memory returndata,
634         string memory errorMessage
635     ) internal pure returns (bytes memory) {
636         if (success) {
637             return returndata;
638         } else {
639             // Look for revert reason and bubble it up if present
640             if (returndata.length > 0) {
641                 // The easiest way to bubble the revert reason is using memory via assembly
642 
643                 assembly {
644                     let returndata_size := mload(returndata)
645                     revert(add(32, returndata), returndata_size)
646                 }
647             } else {
648                 revert(errorMessage);
649             }
650         }
651     }
652 }
653 
654 // File: contracts/MultiStakeCapital.sol
655 
656 // Multi-Stake Capital: $MSC
657 // -You buy on Ethereum, we bond and stake on multiple chains and return the profits to $MSC holders.
658 
659 // Tokenomics:
660 // 10% of each buy goes to existing holders.
661 // 10% of each sell goes into multi-chain bonding and staking to add to the treasury and buy back MSC tokens.
662 
663 // Website: https://multistakecapital.link
664 
665 // Twitter: https://twitter.com/MulStakeCapital
666 
667 //
668 //   /$$$  /$$$$$$  /$$$$$$$$/$$$$$$  /$$   /$$ /$$$$$$$$                  /$$$$$$  /$$$$$$$$/$$$$$$  /$$   /$$ /$$$$$$$$/$$$  
669 //  /$$_/ /$$__  $$|__  $$__/$$__  $$| $$  /$$/| $$_____/                 /$$__  $$|__  $$__/$$__  $$| $$  /$$/| $$_____/_  $$ 
670 // /$$/  | $$  \__/   | $$ | $$  \ $$| $$ /$$/ | $$                      | $$  \__/   | $$ | $$  \ $$| $$ /$$/ | $$       \  $$
671 //| $$   |  $$$$$$    | $$ | $$$$$$$$| $$$$$/  | $$$$$                   |  $$$$$$    | $$ | $$$$$$$$| $$$$$/  | $$$$$     | $$
672 //| $$    \____  $$   | $$ | $$__  $$| $$  $$  | $$__/                    \____  $$   | $$ | $$__  $$| $$  $$  | $$__/     | $$
673 //|  $$   /$$  \ $$   | $$ | $$  | $$| $$\  $$ | $$                       /$$  \ $$   | $$ | $$  | $$| $$\  $$ | $$        /$$/
674 // \  $$$|  $$$$$$/   | $$ | $$  | $$| $$ \  $$| $$$$$$$$       /$$      |  $$$$$$/   | $$ | $$  | $$| $$ \  $$| $$$$$$$$/$$$/ 
675 //  \___/ \______/    |__/ |__/  |__/|__/  \__/|________/      | $/       \______/    |__/ |__/  |__/|__/  \__/|________/___/  
676 //                                                             |_/                                                                                                                                                                                                                                                                                                     
677 
678     interface IUniswapV2Factory {
679         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
680 
681         function feeTo() external view returns (address);
682         function feeToSetter() external view returns (address);
683 
684         function getPair(address tokenA, address tokenB) external view returns (address pair);
685         function allPairs(uint) external view returns (address pair);
686         function allPairsLength() external view returns (uint);
687 
688         function createPair(address tokenA, address tokenB) external returns (address pair);
689 
690         function setFeeTo(address) external;
691         function setFeeToSetter(address) external;
692     }
693 
694     interface IUniswapV2Pair {
695         event Approval(address indexed owner, address indexed spender, uint value);
696         event Transfer(address indexed from, address indexed to, uint value);
697 
698         function name() external pure returns (string memory);
699         function symbol() external pure returns (string memory);
700         function decimals() external pure returns (uint8);
701         function totalSupply() external view returns (uint);
702         function balanceOf(address owner) external view returns (uint);
703         function allowance(address owner, address spender) external view returns (uint);
704 
705         function approve(address spender, uint value) external returns (bool);
706         function transfer(address to, uint value) external returns (bool);
707         function transferFrom(address from, address to, uint value) external returns (bool);
708 
709         function DOMAIN_SEPARATOR() external view returns (bytes32);
710         function PERMIT_TYPEHASH() external pure returns (bytes32);
711         function nonces(address owner) external view returns (uint);
712 
713         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
714 
715         event Mint(address indexed sender, uint amount0, uint amount1);
716         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
717         event Swap(
718             address indexed sender,
719             uint amount0In,
720             uint amount1In,
721             uint amount0Out,
722             uint amount1Out,
723             address indexed to
724         );
725         event Sync(uint112 reserve0, uint112 reserve1);
726 
727         function MINIMUM_LIQUIDITY() external pure returns (uint);
728         function factory() external view returns (address);
729         function token0() external view returns (address);
730         function token1() external view returns (address);
731         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
732         function price0CumulativeLast() external view returns (uint);
733         function price1CumulativeLast() external view returns (uint);
734         function kLast() external view returns (uint);
735 
736         function mint(address to) external returns (uint liquidity);
737         function burn(address to) external returns (uint amount0, uint amount1);
738         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
739         function skim(address to) external;
740         function sync() external;
741 
742         function initialize(address, address) external;
743     }
744 
745 interface IUniswapV2Router01 {
746         function factory() external pure returns (address);
747         function WETH() external pure returns (address);
748 
749         function addLiquidity(
750             address tokenA,
751             address tokenB,
752             uint amountADesired,
753             uint amountBDesired,
754             uint amountAMin,
755             uint amountBMin,
756             address to,
757             uint deadline
758         ) external returns (uint amountA, uint amountB, uint liquidity);
759         function addLiquidityETH(
760             address token,
761             uint amountTokenDesired,
762             uint amountTokenMin,
763             uint amountETHMin,
764             address to,
765             uint deadline
766         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
767         function removeLiquidity(
768             address tokenA,
769             address tokenB,
770             uint liquidity,
771             uint amountAMin,
772             uint amountBMin,
773             address to,
774             uint deadline
775         ) external returns (uint amountA, uint amountB);
776         function removeLiquidityETH(
777             address token,
778             uint liquidity,
779             uint amountTokenMin,
780             uint amountETHMin,
781             address to,
782             uint deadline
783         ) external returns (uint amountToken, uint amountETH);
784         function removeLiquidityWithPermit(
785             address tokenA,
786             address tokenB,
787             uint liquidity,
788             uint amountAMin,
789             uint amountBMin,
790             address to,
791             uint deadline,
792             bool approveMax, uint8 v, bytes32 r, bytes32 s
793         ) external returns (uint amountA, uint amountB);
794         function removeLiquidityETHWithPermit(
795             address token,
796             uint liquidity,
797             uint amountTokenMin,
798             uint amountETHMin,
799             address to,
800             uint deadline,
801             bool approveMax, uint8 v, bytes32 r, bytes32 s
802         ) external returns (uint amountToken, uint amountETH);
803         function swapExactTokensForTokens(
804             uint amountIn,
805             uint amountOutMin,
806             address[] calldata path,
807             address to,
808             uint deadline
809         ) external returns (uint[] memory amounts);
810         function swapTokensForExactTokens(
811             uint amountOut,
812             uint amountInMax,
813             address[] calldata path,
814             address to,
815             uint deadline
816         ) external returns (uint[] memory amounts);
817         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
818             external
819             payable
820             returns (uint[] memory amounts);
821         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
822             external
823             returns (uint[] memory amounts);
824         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
825             external
826             returns (uint[] memory amounts);
827         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
828             external
829             payable
830             returns (uint[] memory amounts);
831 
832         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
833         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
834         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
835         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
836         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
837     }
838 
839 
840    interface IUniswapV2Router02 is IUniswapV2Router01 {
841         function removeLiquidityETHSupportingFeeOnTransferTokens(
842             address token,
843             uint liquidity,
844             uint amountTokenMin,
845             uint amountETHMin,
846             address to,
847             uint deadline
848         ) external returns (uint amountETH);
849         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
850             address token,
851             uint liquidity,
852             uint amountTokenMin,
853             uint amountETHMin,
854             address to,
855             uint deadline,
856             bool approveMax, uint8 v, bytes32 r, bytes32 s
857         ) external returns (uint amountETH);
858 
859         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
860             uint amountIn,
861             uint amountOutMin,
862             address[] calldata path,
863             address to,
864             uint deadline
865         ) external;
866         function swapExactETHForTokensSupportingFeeOnTransferTokens(
867             uint amountOutMin,
868             address[] calldata path,
869             address to,
870             uint deadline
871         ) external payable;
872         function swapExactTokensForETHSupportingFeeOnTransferTokens(
873             uint amountIn,
874             uint amountOutMin,
875             address[] calldata path,
876             address to,
877             uint deadline
878         ) external;
879     }
880 
881 pragma solidity ^0.8.0;
882 //SPDX-License-Identifier: MIT
883 
884 
885 
886 
887 
888 
889     contract MultiStakeCapital is Context, IERC20, Ownable {
890         using SafeMath for uint256;
891         using Address for address;
892 
893         mapping (address => uint256) private _rOwned;
894         mapping (address => uint256) private _tOwned;
895         mapping (address => mapping (address => uint256)) private _allowances;
896 
897         mapping (address => bool) private _isExcludedFromFee;
898 
899         mapping (address => bool) private _isExcluded;
900         address[] private _excluded;
901 
902         uint256 private constant MAX = ~uint256(0);
903         uint256 private _tTotal = 1000000000000 * 10**9;
904         uint256 private _rTotal = (MAX - (MAX % _tTotal));
905         uint256 private _tFeeTotal;
906 
907         string private _name = 'MultiStakeCapital';
908         string private _symbol = 'MSC';
909         uint8 private _decimals = 9;
910 
911         uint256 private _taxFee = 10;
912         uint256 private _teamFee = 10;
913         uint256 private _previousTaxFee = _taxFee;
914         uint256 private _previousTeamFee = _teamFee;
915 
916         address payable public _MSCWalletAddress;
917         address payable public _marketingWalletAddress;
918 
919         IUniswapV2Router02 public immutable uniswapV2Router;
920         address public immutable uniswapV2Pair;
921 
922         bool inSwap = false;
923         bool public swapEnabled = true;
924 
925         uint256 private _maxTxAmount = 100000000000000e9;
926         // We will set a minimum amount of tokens to be swaped => 5M
927         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
928 
929         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
930         event SwapEnabledUpdated(bool enabled);
931 
932         modifier lockTheSwap {
933             inSwap = true;
934             _;
935             inSwap = false;
936         }
937 
938         constructor (address payable MSCWalletAddress, address payable marketingWalletAddress) {
939             _MSCWalletAddress = MSCWalletAddress;
940             _marketingWalletAddress = marketingWalletAddress;
941             _rOwned[_msgSender()] = _rTotal;
942 
943             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
944             // Create a uniswap pair for this new token
945             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
946                 .createPair(address(this), _uniswapV2Router.WETH());
947 
948             // set the rest of the contract variables
949             uniswapV2Router = _uniswapV2Router;
950 
951             // Exclude owner and this contract from fee
952             _isExcludedFromFee[owner()] = true;
953             _isExcludedFromFee[address(this)] = true;
954 
955             emit Transfer(address(0), _msgSender(), _tTotal);
956         }
957 
958         function name() public view returns (string memory) {
959             return _name;
960         }
961 
962         function symbol() public view returns (string memory) {
963             return _symbol;
964         }
965 
966         function decimals() public view returns (uint8) {
967             return _decimals;
968         }
969 
970         function totalSupply() public view override returns (uint256) {
971             return _tTotal;
972         }
973 
974         function balanceOf(address account) public view override returns (uint256) {
975             if (_isExcluded[account]) return _tOwned[account];
976             return tokenFromReflection(_rOwned[account]);
977         }
978 
979         function transfer(address recipient, uint256 amount) public override returns (bool) {
980             _transfer(_msgSender(), recipient, amount);
981             return true;
982         }
983 
984         function allowance(address owner, address spender) public view override returns (uint256) {
985             return _allowances[owner][spender];
986         }
987 
988         function approve(address spender, uint256 amount) public override returns (bool) {
989             _approve(_msgSender(), spender, amount);
990             return true;
991         }
992 
993         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
994             _transfer(sender, recipient, amount);
995             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
996             return true;
997         }
998 
999         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1000             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1001             return true;
1002         }
1003 
1004         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1005             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1006             return true;
1007         }
1008 
1009         function isExcluded(address account) public view returns (bool) {
1010             return _isExcluded[account];
1011         }
1012 
1013         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
1014             _isExcludedFromFee[account] = excluded;
1015         }
1016 
1017         function totalFees() public view returns (uint256) {
1018             return _tFeeTotal;
1019         }
1020 
1021         function deliver(uint256 tAmount) public {
1022             address sender = _msgSender();
1023             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1024             (uint256 rAmount,,,,,) = _getValues(tAmount);
1025             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1026             _rTotal = _rTotal.sub(rAmount);
1027             _tFeeTotal = _tFeeTotal.add(tAmount);
1028         }
1029 
1030         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1031             require(tAmount <= _tTotal, "Amount must be less than supply");
1032             if (!deductTransferFee) {
1033                 (uint256 rAmount,,,,,) = _getValues(tAmount);
1034                 return rAmount;
1035             } else {
1036                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1037                 return rTransferAmount;
1038             }
1039         }
1040 
1041         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1042             require(rAmount <= _rTotal, "Amount must be less than total reflections");
1043             uint256 currentRate =  _getRate();
1044             return rAmount.div(currentRate);
1045         }
1046 
1047         function excludeAccount(address account) external onlyOwner() {
1048             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1049             require(!_isExcluded[account], "Account is already excluded");
1050             if(_rOwned[account] > 0) {
1051                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
1052             }
1053             _isExcluded[account] = true;
1054             _excluded.push(account);
1055         }
1056 
1057         function includeAccount(address account) external onlyOwner() {
1058             require(_isExcluded[account], "Account is already excluded");
1059             for (uint256 i = 0; i < _excluded.length; i++) {
1060                 if (_excluded[i] == account) {
1061                     _excluded[i] = _excluded[_excluded.length - 1];
1062                     _tOwned[account] = 0;
1063                     _isExcluded[account] = false;
1064                     _excluded.pop();
1065                     break;
1066                 }
1067             }
1068         }
1069 
1070         function removeAllFee() private {
1071             if(_taxFee == 0 && _teamFee == 0) return;
1072 
1073             _previousTaxFee = _taxFee;
1074             _previousTeamFee = _teamFee;
1075 
1076             _taxFee = 0;
1077             _teamFee = 0;
1078         }
1079 
1080         function restoreAllFee() private {
1081             _taxFee = _previousTaxFee;
1082             _teamFee = _previousTeamFee;
1083         }
1084 
1085         function isExcludedFromFee(address account) public view returns(bool) {
1086             return _isExcludedFromFee[account];
1087         }
1088 
1089         function _approve(address owner, address spender, uint256 amount) private {
1090             require(owner != address(0), "ERC20: approve from the zero address");
1091             require(spender != address(0), "ERC20: approve to the zero address");
1092 
1093             _allowances[owner][spender] = amount;
1094             emit Approval(owner, spender, amount);
1095         }
1096 
1097         function _transfer(address sender, address recipient, uint256 amount) private {
1098             require(sender != address(0), "ERC20: transfer from the zero address");
1099             require(recipient != address(0), "ERC20: transfer to the zero address");
1100             require(amount > 0, "Transfer amount must be greater than zero");
1101 
1102             if(sender != owner() && recipient != owner())
1103                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1104 
1105             // is the token balance of this contract address over the min number of
1106             // tokens that we need to initiate a swap?
1107             // also, don't get caught in a circular team event.
1108             // also, don't swap if sender is uniswap pair.
1109             uint256 contractTokenBalance = balanceOf(address(this));
1110 
1111             if(contractTokenBalance >= _maxTxAmount)
1112             {
1113                 contractTokenBalance = _maxTxAmount;
1114             }
1115 
1116             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
1117             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1118                 // We need to swap the current tokens to ETH and send to the team wallet
1119                 swapTokensForEth(contractTokenBalance);
1120 
1121                 uint256 contractETHBalance = address(this).balance;
1122                 if(contractETHBalance > 0) {
1123                     sendETHToTeam(address(this).balance);
1124                 }
1125             }
1126 
1127             //indicates if fee should be deducted from transfer
1128             bool takeFee = true;
1129 
1130             //if any account belongs to _isExcludedFromFee account then remove the fee
1131             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1132                 takeFee = false;
1133             }
1134 
1135             //transfer amount, it will take tax and team fee
1136             _tokenTransfer(sender,recipient,amount,takeFee);
1137         }
1138 
1139         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1140             // generate the uniswap pair path of token -> weth
1141             address[] memory path = new address[](2);
1142             path[0] = address(this);
1143             path[1] = uniswapV2Router.WETH();
1144 
1145             _approve(address(this), address(uniswapV2Router), tokenAmount);
1146 
1147             // make the swap
1148             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1149                 tokenAmount,
1150                 0, // accept any amount of ETH
1151                 path,
1152                 address(this),
1153                 block.timestamp
1154             );
1155         }
1156 
1157         function sendETHToTeam(uint256 amount) private {
1158             _MSCWalletAddress.transfer(amount.div(2));
1159             _marketingWalletAddress.transfer(amount.div(2));
1160         }
1161 
1162         // We are exposing these functions to be able to manual swap and send
1163         // in case the token is highly valued and 5M becomes too much
1164         function manualSwap() external onlyOwner() {
1165             uint256 contractBalance = balanceOf(address(this));
1166             swapTokensForEth(contractBalance);
1167         }
1168 
1169         function manualSend() external onlyOwner() {
1170             uint256 contractETHBalance = address(this).balance;
1171             sendETHToTeam(contractETHBalance);
1172         }
1173 
1174         function setSwapEnabled(bool enabled) external onlyOwner(){
1175             swapEnabled = enabled;
1176         }
1177 
1178         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1179             if(!takeFee)
1180                 removeAllFee();
1181 
1182             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1183                 _transferFromExcluded(sender, recipient, amount);
1184             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1185                 _transferToExcluded(sender, recipient, amount);
1186             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1187                 _transferStandard(sender, recipient, amount);
1188             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1189                 _transferBothExcluded(sender, recipient, amount);
1190             } else {
1191                 _transferStandard(sender, recipient, amount);
1192             }
1193 
1194             if(!takeFee)
1195                 restoreAllFee();
1196         }
1197 
1198         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1199             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1200             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1201             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1202             _takeTeam(tTeam);
1203             _reflectFee(rFee, tFee);
1204             emit Transfer(sender, recipient, tTransferAmount);
1205         }
1206 
1207         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1208             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1209             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1210             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1211             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1212             _takeTeam(tTeam);
1213             _reflectFee(rFee, tFee);
1214             emit Transfer(sender, recipient, tTransferAmount);
1215         }
1216 
1217         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1218             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1219             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1220             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1221             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1222             _takeTeam(tTeam);
1223             _reflectFee(rFee, tFee);
1224             emit Transfer(sender, recipient, tTransferAmount);
1225         }
1226 
1227         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1228             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1229             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1230             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1231             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1232             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1233             _takeTeam(tTeam);
1234             _reflectFee(rFee, tFee);
1235             emit Transfer(sender, recipient, tTransferAmount);
1236         }
1237 
1238         function _takeTeam(uint256 tTeam) private {
1239             uint256 currentRate =  _getRate();
1240             uint256 rTeam = tTeam.mul(currentRate);
1241             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1242             if(_isExcluded[address(this)])
1243                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1244         }
1245 
1246         function _reflectFee(uint256 rFee, uint256 tFee) private {
1247             _rTotal = _rTotal.sub(rFee);
1248             _tFeeTotal = _tFeeTotal.add(tFee);
1249         }
1250 
1251          //to recieve ETH from uniswapV2Router when swaping
1252         receive() external payable {}
1253 
1254         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1255             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1256             uint256 currentRate =  _getRate();
1257             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1258             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1259         }
1260 
1261         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1262             uint256 tFee = tAmount.mul(taxFee).div(100);
1263             uint256 tTeam = tAmount.mul(teamFee).div(100);
1264             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1265             return (tTransferAmount, tFee, tTeam);
1266         }
1267 
1268         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1269             uint256 rAmount = tAmount.mul(currentRate);
1270             uint256 rFee = tFee.mul(currentRate);
1271             uint256 rTransferAmount = rAmount.sub(rFee);
1272             return (rAmount, rTransferAmount, rFee);
1273         }
1274 
1275         function _getRate() private view returns(uint256) {
1276             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1277             return rSupply.div(tSupply);
1278         }
1279 
1280         function _getCurrentSupply() private view returns(uint256, uint256) {
1281             uint256 rSupply = _rTotal;
1282             uint256 tSupply = _tTotal;
1283             for (uint256 i = 0; i < _excluded.length; i++) {
1284                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1285                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1286                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1287             }
1288             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1289             return (rSupply, tSupply);
1290         }
1291 
1292         function _getTaxFee() private view returns(uint256) {
1293             return _taxFee;
1294         }
1295 
1296         function _getMaxTxAmount() private view returns(uint256) {
1297             return _maxTxAmount;
1298         }
1299 
1300         function _getETHBalance() public view returns(uint256 balance) {
1301             return address(this).balance;
1302         }
1303 
1304         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1305             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1306             _taxFee = taxFee;
1307         }
1308 
1309         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1310             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1311             _teamFee = teamFee;
1312         }
1313 
1314         function _setMSCWallet(address payable MSCWalletAddress) external onlyOwner() {
1315             _MSCWalletAddress = MSCWalletAddress;
1316         }
1317 
1318         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1319             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1320             _maxTxAmount = maxTxAmount;
1321         }
1322     }