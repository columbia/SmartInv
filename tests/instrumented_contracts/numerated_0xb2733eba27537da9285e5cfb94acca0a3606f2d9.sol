1 // Sources flattened with hardhat v2.6.0 https://hardhat.org
2 
3 
4 pragma solidity ^0.6.12;
5 
6 
7 /*
8 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
9 @@@@@@@@@@@@@@@@@@@@@@@@@@#%@@@@@@             @@@@@@%/@@@@@@@@@@@@@@@@@@@@@@@@@
10 @@@@@@@@@@@@@@@@@@@@@.&@@@@@@@@@@@             @@@@@@@@@@@&.@@@@@@@@@@@@@@@@@@@@
11 @@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@@%@@@@@@@@@@@%@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@@
12 @@@@@@@@@@@@@@      &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@@
13 @@@@@@@@@@@           &@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@           @@@@@@@@@@
14 @@@@@@@@@          @@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@@@@@@@@@          @@@@@@@@
15 @@@@@@@ &       @@@@@@@@@@@@@@                     @@@@@@@@@@@@@@       & @@@@@@
16 @@@@@@@@@@@   @@@@@@@@@@@&                             &@@@@@@@@@@@   &@@@@@@@@@
17 @@@@&@@@@@@@@@@@@@@@@@&                                   @@@@@@@@@@@@@@@@@@@@@@
18 @@@ @@@@@@@@@&@@@@@@&          &&      ,&       &&          &@@@@@@&@@@@@@@@@ @@
19 @@ @@@@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@ @
20 @@@@@@@@@@@@@@@@@@               &&    &&&    &(               @@@@@@@@@@@@@@@@@
21 @#@@@@@@@@@@@@@@&         &&                         &&         &@@@@@@@@@@@@@@%
22 @       @@@@@@@@               &&# &&&&& &&&&& &&&               @@@@@@@@      @
23 @      (@@@@@@@@                     *     .                     @@@@@@@@%     @
24 @      &@@@@@@@&       &   &&   (&&&&   2   &&&&,   &&   &       %@@@@@@@@     @
25 @      (@@@@@@@@                     %.   .%                     @@@@@@@@%     @
26 @       @@@@@@@@               &&% &&&&& &&&&& %&&               @@@@@@@@      @
27 @#@@@@@@@@@@@@@@&         &&                         &&         &@@@@@@@@@@@@@@%
28 @@@@@@@@@@@@@@@@@@               &&    &&&    &&               @@@@@@@@@@@@@@@@@
29 @@ @@@@@@@@@@@@@@@@                                           @@@@@@@@@@@@@@@@ @
30 @@@ @@@@@@@@@&@@@@@@&          &&      #&       &&          %@@@@@@&@@@@@@@@@ @@
31 @@@@@@@@@@@@@@@@@@@@@@&                                   @@@@@@@@@@@@@@@@@@@@@@
32 @@@@@@@@@@@   @@@@@@@@@@@&                             %@@@@@@@@@@@   @@@@@@@@@@
33 @@@@@@@ &       @@@@@@@@@@@@@@                     @@@@@@@@@@@@@@       & @@@@@@
34 @@@@@@@@@         .&@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@@@@@@@@&          @@@@@@@@
35 @@@@@@@@@@@*          @@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@           @@@@@@@@@@
36 @@@@@@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@@
37 @@@@@@@@@@@@@@@@@.@@@@@@@@@@@@@@@&             @@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@@@
38 @@@@@@@@@@@@@@@@@@@@@.&@@@@@@@@@@@             @@@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@
39 @@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@
40 */
41 
42 
43 /*
44 💰 BE THE HOUSE 💰
45 
46 CINO Token - Cardino is an ERC20 Token that Rewards Holders with profits from our online casino!
47      
48    
49 💝 Stake your Cardino and get your share of the gross operating profits! 
50 
51 🤖 Telegram        https://t.me/CardinoCasino
52 
53 💥 Huge Marketing Lined Up!
54 
55 📈 Decentralized Finance meets the casino industry!
56 
57 
58 🔥  Tokenomics - 10% Tax | 4% To marketing | 6% To the Team
59 💰  80% of Casino profits back to the stakers!
60 💫  Virtually no fees after September 12th Cardano Block Chain Smart Contract release!
61 ⭐️  Token will be bridged to Cardano and casino will be built there!
62 🔒   43% of Token Supply locked on Unicrypt!
63 🗣   Community Driven Project and Economy 
64 
65 
66 
67 💰 Lottery Smart Contract coming soon for stakers to begin to profit from! 💰 
68  */
69 
70 
71 
72 pragma solidity >=0.6.0 <0.8.0;
73 
74 /*
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with GSN meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address payable) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes memory) {
90         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
91         return msg.data;
92     }
93 }
94 
95 
96 // File @openzeppelin/contracts/GSN/Context.sol@v3.4.1-solc-0.7-2
97 
98 
99 
100 pragma solidity >=0.6.0 <0.8.0;
101 
102 
103 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1-solc-0.7-2
104 
105 
106 
107 pragma solidity >=0.6.0 <0.8.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `recipient`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address recipient, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Moves `amount` tokens from `sender` to `recipient` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
167 
168     /**
169      * @dev Emitted when `value` tokens are moved from one account (`from`) to
170      * another (`to`).
171      *
172      * Note that `value` may be zero.
173      */
174     event Transfer(address indexed from, address indexed to, uint256 value);
175 
176     /**
177      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
178      * a call to {approve}. `value` is the new allowance.
179      */
180     event Approval(address indexed owner, address indexed spender, uint256 value);
181 }
182 
183 
184 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1-solc-0.7-2
185 
186 
187 
188 pragma solidity >=0.6.0 <0.8.0;
189 
190 /**
191  * @dev Wrappers over Solidity's arithmetic operations with added overflow
192  * checks.
193  *
194  * Arithmetic operations in Solidity wrap on overflow. This can easily result
195  * in bugs, because programmers usually assume that an overflow raises an
196  * error, which is the standard behavior in high level programming languages.
197  * `SafeMath` restores this intuition by reverting the transaction when an
198  * operation overflows.
199  *
200  * Using this library instead of the unchecked operations eliminates an entire
201  * class of bugs, so it's recommended to use it always.
202  */
203 library SafeMath {
204     /**
205      * @dev Returns the addition of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         uint256 c = a + b;
211         if (c < a) return (false, 0);
212         return (true, c);
213     }
214 
215     /**
216      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         if (b > a) return (false, 0);
222         return (true, a - b);
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
227      *
228      * _Available since v3.4._
229      */
230     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
231         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
232         // benefit is lost if 'b' is also tested.
233         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
234         if (a == 0) return (true, 0);
235         uint256 c = a * b;
236         if (c / a != b) return (false, 0);
237         return (true, c);
238     }
239 
240     /**
241      * @dev Returns the division of two unsigned integers, with a division by zero flag.
242      *
243      * _Available since v3.4._
244      */
245     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
246         if (b == 0) return (false, 0);
247         return (true, a / b);
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
252      *
253      * _Available since v3.4._
254      */
255     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
256         if (b == 0) return (false, 0);
257         return (true, a % b);
258     }
259 
260     /**
261      * @dev Returns the addition of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `+` operator.
265      *
266      * Requirements:
267      *
268      * - Addition cannot overflow.
269      */
270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
271         uint256 c = a + b;
272         require(c >= a, "SafeMath: addition overflow");
273         return c;
274     }
275 
276     /**
277      * @dev Returns the subtraction of two unsigned integers, reverting on
278      * overflow (when the result is negative).
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
287         require(b <= a, "SafeMath: subtraction overflow");
288         return a - b;
289     }
290 
291     /**
292      * @dev Returns the multiplication of two unsigned integers, reverting on
293      * overflow.
294      *
295      * Counterpart to Solidity's `*` operator.
296      *
297      * Requirements:
298      *
299      * - Multiplication cannot overflow.
300      */
301     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
302         if (a == 0) return 0;
303         uint256 c = a * b;
304         require(c / a == b, "SafeMath: multiplication overflow");
305         return c;
306     }
307 
308     /**
309      * @dev Returns the integer division of two unsigned integers, reverting on
310      * division by zero. The result is rounded towards zero.
311      *
312      * Counterpart to Solidity's `/` operator. Note: this function uses a
313      * `revert` opcode (which leaves remaining gas untouched) while Solidity
314      * uses an invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         require(b > 0, "SafeMath: division by zero");
322         return a / b;
323     }
324 
325     /**
326      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
327      * reverting when dividing by zero.
328      *
329      * Counterpart to Solidity's `%` operator. This function uses a `revert`
330      * opcode (which leaves remaining gas untouched) while Solidity uses an
331      * invalid opcode to revert (consuming all remaining gas).
332      *
333      * Requirements:
334      *
335      * - The divisor cannot be zero.
336      */
337     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
338         require(b > 0, "SafeMath: modulo by zero");
339         return a % b;
340     }
341 
342     /**
343      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
344      * overflow (when the result is negative).
345      *
346      * CAUTION: This function is deprecated because it requires allocating memory for the error
347      * message unnecessarily. For custom revert reasons use {trySub}.
348      *
349      * Counterpart to Solidity's `-` operator.
350      *
351      * Requirements:
352      *
353      * - Subtraction cannot overflow.
354      */
355     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b <= a, errorMessage);
357         return a - b;
358     }
359 
360     /**
361      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
362      * division by zero. The result is rounded towards zero.
363      *
364      * CAUTION: This function is deprecated because it requires allocating memory for the error
365      * message unnecessarily. For custom revert reasons use {tryDiv}.
366      *
367      * Counterpart to Solidity's `/` operator. Note: this function uses a
368      * `revert` opcode (which leaves remaining gas untouched) while Solidity
369      * uses an invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         require(b > 0, errorMessage);
377         return a / b;
378     }
379 
380     /**
381      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
382      * reverting with custom message when dividing by zero.
383      *
384      * CAUTION: This function is deprecated because it requires allocating memory for the error
385      * message unnecessarily. For custom revert reasons use {tryMod}.
386      *
387      * Counterpart to Solidity's `%` operator. This function uses a `revert`
388      * opcode (which leaves remaining gas untouched) while Solidity uses an
389      * invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b > 0, errorMessage);
397         return a % b;
398     }
399 }
400 
401 
402 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1-solc-0.7-2
403 
404 
405 
406 pragma solidity >=0.6.0 <0.8.0;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize, which returns 0 for contracts in
431         // construction, since the code is only stored at the end of the
432         // constructor execution.
433 
434         uint256 size;
435         // solhint-disable-next-line no-inline-assembly
436         assembly { size := extcodesize(account) }
437         return size > 0;
438     }
439 
440     /**
441      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
442      * `recipient`, forwarding all available gas and reverting on errors.
443      *
444      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
445      * of certain opcodes, possibly making contracts go over the 2300 gas limit
446      * imposed by `transfer`, making them unable to receive funds via
447      * `transfer`. {sendValue} removes this limitation.
448      *
449      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
450      *
451      * IMPORTANT: because control is transferred to `recipient`, care must be
452      * taken to not create reentrancy vulnerabilities. Consider using
453      * {ReentrancyGuard} or the
454      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
455      */
456     function sendValue(address payable recipient, uint256 amount) internal {
457         require(address(this).balance >= amount, "Address: insufficient balance");
458 
459         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
460         (bool success, ) = recipient.call{ value: amount }("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain`call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483       return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         // solhint-disable-next-line avoid-low-level-calls
522         (bool success, bytes memory returndata) = target.call{ value: value }(data);
523         return _verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but performing a static call.
529      *
530      * _Available since v3.3._
531      */
532     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
533         return functionStaticCall(target, data, "Address: low-level static call failed");
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
538      * but performing a static call.
539      *
540      * _Available since v3.3._
541      */
542     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
543         require(isContract(target), "Address: static call to non-contract");
544 
545         // solhint-disable-next-line avoid-low-level-calls
546         (bool success, bytes memory returndata) = target.staticcall(data);
547         return _verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
557         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
558     }
559 
560     /**
561      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
562      * but performing a delegate call.
563      *
564      * _Available since v3.4._
565      */
566     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
567         require(isContract(target), "Address: delegate call to non-contract");
568 
569         // solhint-disable-next-line avoid-low-level-calls
570         (bool success, bytes memory returndata) = target.delegatecall(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
575         if (success) {
576             return returndata;
577         } else {
578             // Look for revert reason and bubble it up if present
579             if (returndata.length > 0) {
580                 // The easiest way to bubble the revert reason is using memory via assembly
581 
582                 // solhint-disable-next-line no-inline-assembly
583                 assembly {
584                     let returndata_size := mload(returndata)
585                     revert(add(32, returndata), returndata_size)
586                 }
587             } else {
588                 revert(errorMessage);
589             }
590         }
591     }
592 }
593 
594 
595 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1-solc-0.7-2
596 
597 
598 
599 pragma solidity >=0.6.0 < 0.8.0;
600 
601 /**
602  * @dev Contract module which provides a basic access control mechanism, where
603  * there is an account (an owner) that can be granted exclusive access to
604  * specific functions.
605  *
606  * By default, the owner account will be the one that deploys the contract. This
607  * can later be changed with {transferOwnership}.
608  *
609  * This module is used through inheritance. It will make available the modifier
610  * `onlyOwner`, which can be applied to your functions to restrict their use to
611  * the owner.
612  */
613 abstract contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor () internal {
622         address msgSender = _msgSender();
623         _owner = msgSender;
624         emit OwnershipTransferred(address(0), msgSender);
625     }
626 
627     /**
628      * @dev Returns the address of the current owner.
629      */
630     function owner() public view virtual returns (address) {
631         return _owner;
632     }
633 
634     /**
635      * @dev Throws if called by any account other than the owner.
636      */
637     modifier onlyOwner() {
638         require(owner() == _msgSender(), "Ownable: caller is not the owner");
639         _;
640     }
641 
642     /**
643      * @dev Leaves the contract without owner. It will not be possible to call
644      * `onlyOwner` functions anymore. Can only be called by the current owner.
645      *
646      * NOTE: Renouncing ownership will leave the contract without an owner,
647      * thereby removing any functionality that is only available to the owner.
648      */
649     function renounceOwnership() public virtual onlyOwner {
650         emit OwnershipTransferred(_owner, address(0));
651         _owner = address(0);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664 
665 
666 // File contracts/external/IUniswapV2Router01.sol
667 
668 pragma solidity >=0.6.2;
669 
670 interface IUniswapV2Router01 {
671     function factory() external pure returns (address);
672     function WETH() external pure returns (address);
673 
674     function addLiquidity(
675         address tokenA,
676         address tokenB,
677         uint amountADesired,
678         uint amountBDesired,
679         uint amountAMin,
680         uint amountBMin,
681         address to,
682         uint deadline
683     ) external returns (uint amountA, uint amountB, uint liquidity);
684     function addLiquidityETH(
685         address token,
686         uint amountTokenDesired,
687         uint amountTokenMin,
688         uint amountETHMin,
689         address to,
690         uint deadline
691     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
692     function removeLiquidity(
693         address tokenA,
694         address tokenB,
695         uint liquidity,
696         uint amountAMin,
697         uint amountBMin,
698         address to,
699         uint deadline
700     ) external returns (uint amountA, uint amountB);
701     function removeLiquidityETH(
702         address token,
703         uint liquidity,
704         uint amountTokenMin,
705         uint amountETHMin,
706         address to,
707         uint deadline
708     ) external returns (uint amountToken, uint amountETH);
709     function removeLiquidityWithPermit(
710         address tokenA,
711         address tokenB,
712         uint liquidity,
713         uint amountAMin,
714         uint amountBMin,
715         address to,
716         uint deadline,
717         bool approveMax, uint8 v, bytes32 r, bytes32 s
718     ) external returns (uint amountA, uint amountB);
719     function removeLiquidityETHWithPermit(
720         address token,
721         uint liquidity,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline,
726         bool approveMax, uint8 v, bytes32 r, bytes32 s
727     ) external returns (uint amountToken, uint amountETH);
728     function swapExactTokensForTokens(
729         uint amountIn,
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external returns (uint[] memory amounts);
735     function swapTokensForExactTokens(
736         uint amountOut,
737         uint amountInMax,
738         address[] calldata path,
739         address to,
740         uint deadline
741     ) external returns (uint[] memory amounts);
742     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
743         external
744         payable
745         returns (uint[] memory amounts);
746     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
747         external
748         returns (uint[] memory amounts);
749     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
750         external
751         returns (uint[] memory amounts);
752     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
753         external
754         payable
755         returns (uint[] memory amounts);
756 
757     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
758     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
759     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
760     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
761     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
762 }
763 
764 
765 // File contracts/external/IUniswapV2Router02.sol
766 
767 pragma solidity >=0.6.2;
768 interface IUniswapV2Router02 is IUniswapV2Router01 {
769     function removeLiquidityETHSupportingFeeOnTransferTokens(
770         address token,
771         uint liquidity,
772         uint amountTokenMin,
773         uint amountETHMin,
774         address to,
775         uint deadline
776     ) external returns (uint amountETH);
777     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
778         address token,
779         uint liquidity,
780         uint amountTokenMin,
781         uint amountETHMin,
782         address to,
783         uint deadline,
784         bool approveMax, uint8 v, bytes32 r, bytes32 s
785     ) external returns (uint amountETH);
786 
787     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
788         uint amountIn,
789         uint amountOutMin,
790         address[] calldata path,
791         address to,
792         uint deadline
793     ) external;
794     function swapExactETHForTokensSupportingFeeOnTransferTokens(
795         uint amountOutMin,
796         address[] calldata path,
797         address to,
798         uint deadline
799     ) external payable;
800     function swapExactTokensForETHSupportingFeeOnTransferTokens(
801         uint amountIn,
802         uint amountOutMin,
803         address[] calldata path,
804         address to,
805         uint deadline
806     ) external;
807 }
808 
809 
810 // File contracts/external/IUniswapV2Factory.sol
811 
812 pragma solidity >=0.5.0;
813 
814 interface IUniswapV2Factory {
815     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
816 
817     function feeTo() external view returns (address);
818     function feeToSetter() external view returns (address);
819 
820     function getPair(address tokenA, address tokenB) external view returns (address pair);
821     function allPairs(uint) external view returns (address pair);
822     function allPairsLength() external view returns (uint);
823 
824     function createPair(address tokenA, address tokenB) external returns (address pair);
825 
826     function setFeeTo(address) external;
827     function setFeeToSetter(address) external;
828 }
829 
830 
831 // File contracts/external/IUniswapV2Pair.sol
832 
833 pragma solidity >=0.5.0;
834 
835 interface IUniswapV2Pair {
836     event Approval(address indexed owner, address indexed spender, uint value);
837     event Transfer(address indexed from, address indexed to, uint value);
838 
839     function name() external pure returns (string memory);
840     function symbol() external pure returns (string memory);
841     function decimals() external pure returns (uint8);
842     function totalSupply() external view returns (uint);
843     function balanceOf(address owner) external view returns (uint);
844     function allowance(address owner, address spender) external view returns (uint);
845 
846     function approve(address spender, uint value) external returns (bool);
847     function transfer(address to, uint value) external returns (bool);
848     function transferFrom(address from, address to, uint value) external returns (bool);
849 
850     function DOMAIN_SEPARATOR() external view returns (bytes32);
851     function PERMIT_TYPEHASH() external pure returns (bytes32);
852     function nonces(address owner) external view returns (uint);
853 
854     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
855 
856     event Mint(address indexed sender, uint amount0, uint amount1);
857     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
858     event Swap(
859         address indexed sender,
860         uint amount0In,
861         uint amount1In,
862         uint amount0Out,
863         uint amount1Out,
864         address indexed to
865     );
866     event Sync(uint112 reserve0, uint112 reserve1);
867 
868     function MINIMUM_LIQUIDITY() external pure returns (uint);
869     function factory() external view returns (address);
870     function token0() external view returns (address);
871     function token1() external view returns (address);
872     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
873     function price0CumulativeLast() external view returns (uint);
874     function price1CumulativeLast() external view returns (uint);
875     function kLast() external view returns (uint);
876 
877     function mint(address to) external returns (uint liquidity);
878     function burn(address to) external returns (uint amount0, uint amount1);
879     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
880     function skim(address to) external;
881     function sync() external;
882 
883     function initialize(address, address) external;
884 }
885 
886 
887 
888 // File contracts/CardinoV2.sol
889 
890 
891 pragma solidity ^0.6.12;
892 
893 
894 
895 abstract contract V1 {
896     function balanceOf(address account) public view virtual returns(uint256);
897 }
898 
899 
900 // Contract implementation
901     contract CardinoV2 is Context, IERC20, Ownable {
902         using SafeMath for uint256;
903         using Address for address;
904 
905 
906 
907 
908         mapping (address => uint256) private _tOwned;
909         mapping (address => mapping (address => uint256)) private _allowances;
910 
911         mapping (address => bool) private _isExcludedFromFee;
912 
913         mapping (address => bool) private _isExcluded;
914         address[] private _excluded;
915         mapping (address => bool) private _isBlackListedBot;
916         address[] private _blackListedBots;
917 
918         event ExcludeFromFee(address indexed account, bool isExcluded);
919 
920         event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
921 
922         uint256 private _tTotal;  //Determined by prior balances
923         uint256 private _tFeeTotal;
924 
925         string private _name = 'Cardino | t.me/CardinoCasino';
926         string private _symbol = 'CINO';
927         uint8 private _decimals = 18;
928         uint256 private launchTime;
929 
930 
931         address payable paymentContractAddress = payable(0xF2FBB896DA2e53Ce7C1391cA003FD8A3277c55aB);
932 
933         // Tax fees will start at 0 so we don't have a big impact when deploying to Uniswap
934      
935 
936 
937 
938         uint256 public _taxFee = 10;
939         uint256 private _previousTaxFee = _taxFee;
940 
941         address payable public _taxWalletAddress;
942 
943         IUniswapV2Router02 public immutable uniswapV2Router;
944         address public immutable uniswapV2Pair;
945 
946         bool inSwap = false;
947         bool public swapEnabled = true;
948 
949         uint256 public _maxTxAmount = 100000000000 * 10**18; //no max tx limit rn
950 
951         uint256 private _numOfTokensToExchange = 10000 * 10**18; 
952         bool public  enforceMaxTx = true;
953         uint256 dropped = 0;
954 
955         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
956         event SwapEnabledUpdated(bool enabled);
957 
958         modifier lockTheSwap {
959             inSwap = true;
960             _;
961             inSwap = false;
962         }
963 
964        
965 
966         constructor ( ) public {
967 
968             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
969             // Create a uniswap pair for this new token
970             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
971                 .createPair(address(this), _uniswapV2Router.WETH());
972 
973             // set the rest of the contract variables
974             uniswapV2Router = _uniswapV2Router;
975 
976             // Exclude owner and this contract from fee
977             _isExcludedFromFee[owner()] = true;
978             _isExcludedFromFee[address(this)] = true;
979             _isExcludedFromFee[address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)] = true;
980             launchTime = block.timestamp;
981             _taxWalletAddress = paymentContractAddress;
982 
983             // a i r  d r o p 
984 
985             //Post-Airdrop accounting
986 
987             // casino was excluded from hodlers address list to reduce amount of tokens down to 51B essentially burning ~7b
988             uint256 casinoShare = 43000000000 * 10 ** 18;
989             
990 
991             // _tTotal = _tTotal.add(cinoInLP);
992             _tTotal = _tTotal.add(casinoShare);
993 
994 
995 
996             uint256 cinoInLP = 13159356274 * (10 ** 18);
997             uint256 distroTokens = 42188271736 * (10 ** 18);
998 
999 
1000             uint256 tokensForWallet = cinoInLP.add(distroTokens);
1001 
1002             _tTotal = _tTotal.add(tokensForWallet);
1003 
1004             _tOwned[_msgSender()] = _tTotal; 
1005 
1006             
1007             // Transferring the equivalent of V1 CINO in the current Liquidity Pool into the dev wallet to provide initial liquidity for V2 as to maintain the market status
1008 
1009             emit Transfer(address(0), _msgSender(), _tTotal);
1010         }
1011 
1012         
1013 
1014         function name() public view returns (string memory) {
1015             return _name;
1016         }
1017 
1018         function symbol() public view returns (string memory) {
1019             return _symbol;
1020         }
1021 
1022         function decimals() public view returns (uint8) {
1023             return _decimals;
1024         }
1025 
1026         function totalSupply() public view override returns (uint256) {
1027             return _tTotal;
1028         }
1029 
1030         function balanceOf(address account) public view override returns (uint256) {
1031             return _tOwned[account];
1032         }
1033 
1034         function transfer(address recipient, uint256 amount) public override returns (bool) {
1035             _transfer(_msgSender(), recipient, amount);
1036             return true;
1037         }
1038 
1039         function allowance(address owner, address spender) public view override returns (uint256) {
1040             return _allowances[owner][spender];
1041         }
1042 
1043         function approve(address spender, uint256 amount) public override returns (bool) {
1044             _approve(_msgSender(), spender, amount);
1045             return true;
1046         }
1047 
1048         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1049             _transfer(sender, recipient, amount);
1050             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1051             return true;
1052         }
1053 
1054         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1055             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1056             return true;
1057         }
1058 
1059         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1060             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1061             return true;
1062         }
1063 
1064         function isExcluded(address account) public view returns (bool) {
1065             return _isExcluded[account];
1066         }
1067 
1068         function isBlackListed(address account) public view returns (bool) {
1069             return _isBlackListedBot[account];
1070         }
1071 
1072         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
1073             _isExcludedFromFee[account] = excluded;
1074         }
1075 
1076         function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1077 
1078             for(uint256 i = 0; i < accounts.length; i++) {
1079 
1080                 _isExcludedFromFee[accounts[i]] = excluded;
1081 
1082             }
1083 
1084             emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1085 
1086         }
1087 
1088         function setMaxTxEnforced(bool isMaxTxEnforced) public onlyOwner returns (bool maxTxEnforced){
1089             enforceMaxTx = isMaxTxEnforced;
1090             return enforceMaxTx;
1091         }
1092 
1093         function totalFees() public view returns (uint256) {
1094             return _tFeeTotal;
1095         }
1096 
1097 
1098         function excludeAccount(address account) external onlyOwner() {
1099             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1100             require(!_isExcluded[account], "Account is already excluded");
1101             _isExcluded[account] = true;
1102             _excluded.push(account);
1103         }
1104 
1105 
1106         function includeAccount(address account) external onlyOwner() {
1107             require(_isExcluded[account], "Account is already excluded");
1108             for (uint256 i = 0; i < _excluded.length; i++) {
1109                 if (_excluded[i] == account) {
1110                     _excluded[i] = _excluded[_excluded.length - 1];
1111                     _tOwned[account] = 0;
1112                     _isExcluded[account] = false;
1113                     _excluded.pop();
1114                     break;
1115                 }
1116             }
1117         }
1118 
1119         function addBotToBlackList(address account) external onlyOwner() {
1120             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
1121             require(!_isBlackListedBot[account], "Account is already blacklisted");
1122             _isBlackListedBot[account] = true;
1123             _blackListedBots.push(account);
1124         }
1125 
1126         function removeBotFromBlackList(address account) external onlyOwner() {
1127             require(_isBlackListedBot[account], "Account is not blacklisted");
1128             for (uint256 i = 0; i < _blackListedBots.length; i++) {
1129                 if (_blackListedBots[i] == account) {
1130                     _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
1131                     _isBlackListedBot[account] = false;
1132                     _blackListedBots.pop();
1133                     break;
1134                 }
1135             }
1136         }
1137 
1138         function removeAllFee() private {
1139             if(_taxFee == 0) return;
1140 
1141             _previousTaxFee = _taxFee;
1142 
1143             _taxFee = 0;
1144         }
1145 
1146         function restoreAllFee() private {
1147             _taxFee = _previousTaxFee;
1148         }
1149 
1150         function isExcludedFromFee(address account) public view returns(bool) {
1151             return _isExcludedFromFee[account];
1152         }
1153 
1154         function setMaxTxLimit(uint256 maxTxLimit) external onlyOwner() {
1155             _maxTxAmount = maxTxLimit * 10 ** 18;
1156             
1157         }
1158 
1159         function setNumofTokensForExchange(uint256 numOfTokensToExchange) external onlyOwner() {
1160         _numOfTokensToExchange = numOfTokensToExchange;
1161         }
1162 
1163         function _approve(address owner, address spender, uint256 amount) private {
1164             require(owner != address(0), "ERC20: approve from the zero address");
1165             require(spender != address(0), "ERC20: approve to the zero address");
1166 
1167             _allowances[owner][spender] = amount;
1168             emit Approval(owner, spender, amount);
1169         }
1170 
1171         function _transfer(address sender, address recipient, uint256 amount) private {
1172         if (
1173             block.timestamp == launchTime &&
1174             sender != owner() &&
1175             sender != address(this)
1176               ) {
1177                 _isBlackListedBot[recipient] = true;
1178                 _blackListedBots.push(recipient);
1179             }
1180             require(sender != address(0), "ERC20: transfer from the zero address");
1181             require(recipient != address(0), "ERC20: transfer to the zero address");
1182             require(amount > 0, "Transfer amount must be greater than zero");
1183             require(!_isBlackListedBot[sender], "You have no power here!");
1184             require(!_isBlackListedBot[recipient], "You have no power here!");
1185 
1186             
1187 
1188             if(sender != owner() && recipient != owner() && enforceMaxTx)
1189                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1190 
1191 
1192             uint256 contractTokenBalance = balanceOf(address(this));
1193 
1194             if(contractTokenBalance >= _maxTxAmount)
1195             {
1196                 contractTokenBalance = _maxTxAmount;
1197             }
1198 
1199             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchange;
1200             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) { 
1201                 // We need to swap the current tokens to ETH and send to the marketing wallet
1202                 swapTokensForEth(contractTokenBalance);
1203 
1204                 uint256 contractETHBalance = address(this).balance;
1205                 if(contractETHBalance > 0) {
1206                     sendETHToTaxes(address(this).balance);
1207                 }
1208             }
1209 
1210             //indicates if fee should be deducted from transfer
1211             bool takeFee = true;
1212 
1213             //if any account belongs to _isExcludedFromFee account then remove the fee
1214             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1215                 takeFee = false;
1216             }
1217 
1218             //transfer amount, it will take tax fee
1219             _tokenTransfer(sender,recipient,amount,takeFee);
1220         }
1221 
1222         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1223             //generate the uniswap pair path of CINO -> wETH
1224             address[] memory path = new address[](2);
1225             path[0] = address(this);
1226             path[1] = uniswapV2Router.WETH();
1227 
1228             _approve(address(this), address(uniswapV2Router), tokenAmount);
1229 
1230             // make the swap
1231             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1232                 tokenAmount,
1233                 0, // accept any amount of ETH
1234                 path,
1235                 _taxWalletAddress,
1236                 block.timestamp
1237             );
1238         }
1239 
1240         function sendETHToTaxes(uint256 amount) private {
1241             _taxWalletAddress.transfer(amount);
1242         }
1243 
1244         // We are exposing these functions to be able to manual swap and send
1245         // in case the token is highly valued and 5M becomes too much
1246         function manualSwap() external onlyOwner() {
1247             uint256 contractBalance = balanceOf(address(this));
1248             swapTokensForEth(contractBalance);
1249         }
1250 
1251         function manualSend() external onlyOwner() {
1252             uint256 contractETHBalance = address(this).balance;
1253             sendETHToTaxes(contractETHBalance);
1254         }
1255 
1256         function setSwapEnabled(bool enabled) external onlyOwner(){
1257             swapEnabled = enabled;
1258         }
1259 
1260         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1261             if(!takeFee)
1262                 removeAllFee();
1263 
1264             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1265                 _transferFromExcluded(sender, recipient, amount);
1266             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1267                 _transferToExcluded(sender, recipient, amount);
1268             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1269                 _transferStandard(sender, recipient, amount);
1270             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1271                 _transferBothExcluded(sender, recipient, amount);
1272             } else {
1273                 _transferStandard(sender, recipient, amount);
1274             }
1275 
1276             if(!takeFee)
1277                 restoreAllFee();
1278         }
1279 
1280         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1281             (uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1282             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1283             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1284             _takeTaxes(tFee);
1285             emit Transfer(sender, recipient, tTransferAmount);
1286         }
1287 
1288         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1289             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1290             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1291             emit Transfer(sender, recipient, tAmount);
1292         }
1293 
1294         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1295             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1296             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1297             emit Transfer(sender, recipient, tAmount);
1298         }
1299 
1300         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1301             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1302             _tOwned[recipient] = _tOwned[recipient].add(tAmount);
1303             emit Transfer(sender, recipient, tAmount);
1304         }
1305 
1306         function _takeTaxes(uint256 tTotal) private {
1307             _tOwned[address(this)] = _tOwned[address(this)].add(tTotal);
1308             
1309             }
1310 
1311         function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1312             return _amount.mul(_taxFee).div(
1313             10**2
1314             );
1315         }
1316 
1317         function _reflectFee( uint256 tFee) private {
1318             _tFeeTotal = _tFeeTotal.add(tFee);
1319         }
1320 
1321          //to recieve ETH from uniswapV2Router when swapping
1322         receive() external payable {}
1323 
1324         function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
1325             (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
1326             return (tTransferAmount, tFee);
1327         }
1328 
1329         function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
1330             uint256 tFee = calculateTaxFee(tAmount);
1331             uint256 tTransferAmount = tAmount.sub(tFee);
1332             return (tTransferAmount, tFee);
1333         }
1334 
1335         function _getTaxFee() private view returns(uint256) {
1336             return _taxFee;
1337         }
1338 
1339         function _getMaxTxAmount() private view returns(uint256) {
1340             return _maxTxAmount;
1341         }
1342 
1343         function _getETHBalance() public view returns(uint256 balance) {
1344             return address(this).balance;
1345         }
1346 
1347         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1348             require(taxFee >= 0 && taxFee <= 500, 'taxFee should be in 1 - 50');
1349             _taxFee = taxFee.div(10);
1350         }
1351 
1352 
1353     }