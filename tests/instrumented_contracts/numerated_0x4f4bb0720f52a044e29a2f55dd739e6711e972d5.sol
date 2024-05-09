1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
3 
4 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
5 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
6 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
7 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0d:'.;0MMMMMMMMMMMMMMMMMMMMMMMMWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
8 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0xxKMMK:. .:oONMMMWK0NMMMMMMMMMMMMMMMNx;,,;cokXMMMMMMMMMMMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMM
9 // MMMMMMMMMMWNWMMMWKkxONMMMMMMMMMMMMMMMWO:.. .xWMd  :XMMMMMMMK;.kMMMMMMMMMMMMMMM0'  .'.  'xNMMMMNkc:cxNMMMMKclXMMMMMMW0xx0NMMMMMMMMM
10 // MMMMMMMMWk;';kWNo. ..'xNMMM0lxNMMMMMMO. .oOXWMMx. :NMMMMMMMK, lWMMMMMWNXNWMMMMK; .xWKx,  oWMW0; .,. ;0MMMk..OMMMMMKc. ..cXMMMMMMMM
11 // MMMMMMMMO..'..ol..o0c. lNMWc ,KMWOxKWO. ,KMMMMM0' ,KMMMMMMMX; :NMMMMKl'.'cKMMMNc  oWMMK, '0MK; 'OWk. lWMMO..kWWWMN: .dKkONMMMMMMMM
12 // MMMMMMMWo ,0o    :NMNc .dWX; ;KMK, '0K, .kMMMMMX; .OMMMMMMMNc ,KMMM0' 'l' 'OMMMd. ;XMMWl .kWd  lK0o. oNKkc. ';'cKK; .OWMMMMMMMMMMM
13 // MMMMMMMX: cNK;  .kMMM0' ,KN: '0MNc  lNl  oWMWWWNc  ;olcccOWWl .OMMNc .OMO' ,KMM0' .kMMWl .kX:  .'..,dNK:..  'ldONWk' .cONMMMMMMMMM
14 // MMMMMMMK, lWMd  ,0MMMNc .xWo .xMMO. '0x. .c:;''dl   ...',xWMd .xMM0, :XMWd. lNMNc  oWWO. ;XK, 'xO0KNMMWKKk' oMMMMMMXd, .:KMMMMMMMM
15 // MMMMMMMK; lWM0' '0MMMMo  oMO. :XMN:  oK,  .,;:lOx. ;KXNNWMMMx. oMMO. cWMMX; .OMMd  ,ko. ,0MK, :XMMMMMMMMM0' lWMMMMMMMNo. ;KMMMMMMM
16 // MMMMMMMNc :XMWd'lXMMMMd  lWNl .dWMx. :Xl  lWMMMMO. ;XMMMMMMMk. lWMO' cWMMWo  dMMO.  ..;dXMMX: '0MMWXOKWMM0, lWMMWNWMWXd. .OMMMMMMM
17 // MMMMMMMMx..OMMWNWMMMMMd  lWMK; .dNk. ,Kk. ;XMMMMK, ,KMMMMMMMO. :NMK; ;KMMMx. cWMK, .oXWMMMMWx. ;xd:..oWMMK, lWMK:';:;.  .dNMMMMMMM
18 // MMMMMMMMX: cNMMMMMMMMWl  oMMMK;  ;;  :NK; .kMMMMX; '0MMMMMMM0, ,KMWOcdXMMMk. :NMN:  oMMMMMMMWk;....:xNMMMK; cNMXo,...':dKWMMMMMMMM
19 // MMMMMMMMM0,.oWMMMMMMMN: .xMMMMNx;.  ,OMWo  lWMMMN: '0MMMMMMMK, 'OMMMMMMMMMKc;kWMWo  cWMMMMMMMMWK00XWMMMMMX: :NMMMWXXXWMMMMMMMMMMMM
20 // MMMMMMMMMMKdkWMMMMMMMWk:oXMMMMMMWKO0NMMM0' ,KMMMN: '0MMMMMMMNl.,0MMMMMMMMMMWWMMMMd. ;XMMMMMMMMMMMMMMMMMMMW0d0WMMMMMMMMMMMMMMMMMMMM
21 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWk:oXMMMWd'lXMMMMMMMMNKXWMMMMMMMMMMMMMMMMk. ,KMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
22 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO. .OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
23 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0' .kMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
24 // MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWkcxNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
25 
26 
27 
28 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
29 
30 pragma solidity ^0.8.0;
31 
32 // CAUTION
33 // This version of SafeMath should only be used with Solidity 0.8 or later,
34 // because it relies on the compiler's built in overflow checks.
35 
36 /**
37  * @dev Wrappers over Solidity's arithmetic operations.
38  *
39  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
40  * now has built in overflow checking.
41  */
42 library SafeMath {
43     /**
44      * @dev Returns the addition of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             uint256 c = a + b;
51             if (c < a) return (false, 0);
52             return (true, c);
53         }
54     }
55 
56     /**
57      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
58      *
59      * _Available since v3.4._
60      */
61     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
62         unchecked {
63             if (b > a) return (false, 0);
64             return (true, a - b);
65         }
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
70      *
71      * _Available since v3.4._
72      */
73     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
74         unchecked {
75             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76             // benefit is lost if 'b' is also tested.
77             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78             if (a == 0) return (true, 0);
79             uint256 c = a * b;
80             if (c / a != b) return (false, 0);
81             return (true, c);
82         }
83     }
84 
85     /**
86      * @dev Returns the division of two unsigned integers, with a division by zero flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             if (b == 0) return (false, 0);
93             return (true, a / b);
94         }
95     }
96 
97     /**
98      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
99      *
100      * _Available since v3.4._
101      */
102     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
103         unchecked {
104             if (b == 0) return (false, 0);
105             return (true, a % b);
106         }
107     }
108 
109     /**
110      * @dev Returns the addition of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `+` operator.
114      *
115      * Requirements:
116      *
117      * - Addition cannot overflow.
118      */
119     function add(uint256 a, uint256 b) internal pure returns (uint256) {
120         return a + b;
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a - b;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         return a * b;
149     }
150 
151     /**
152      * @dev Returns the integer division of two unsigned integers, reverting on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator.
156      *
157      * Requirements:
158      *
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a / b;
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
167      * reverting when dividing by zero.
168      *
169      * Counterpart to Solidity's `%` operator. This function uses a `revert`
170      * opcode (which leaves remaining gas untouched) while Solidity uses an
171      * invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      *
175      * - The divisor cannot be zero.
176      */
177     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
178         return a % b;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
183      * overflow (when the result is negative).
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {trySub}.
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(
195         uint256 a,
196         uint256 b,
197         string memory errorMessage
198     ) internal pure returns (uint256) {
199         unchecked {
200             require(b <= a, errorMessage);
201             return a - b;
202         }
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(
218         uint256 a,
219         uint256 b,
220         string memory errorMessage
221     ) internal pure returns (uint256) {
222         unchecked {
223             require(b > 0, errorMessage);
224             return a / b;
225         }
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting with custom message when dividing by zero.
231      *
232      * CAUTION: This function is deprecated because it requires allocating memory for the error
233      * message unnecessarily. For custom revert reasons use {tryMod}.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(
244         uint256 a,
245         uint256 b,
246         string memory errorMessage
247     ) internal pure returns (uint256) {
248         unchecked {
249             require(b > 0, errorMessage);
250             return a % b;
251         }
252     }
253 }
254 
255 // File: @openzeppelin/contracts/utils/Strings.sol
256 
257 
258 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
259 
260 pragma solidity ^0.8.0;
261 
262 /**
263  * @dev String operations.
264  */
265 library Strings {
266     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
267 
268     /**
269      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
270      */
271     function toString(uint256 value) internal pure returns (string memory) {
272         // Inspired by OraclizeAPI's implementation - MIT licence
273         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
274 
275         if (value == 0) {
276             return "0";
277         }
278         uint256 temp = value;
279         uint256 digits;
280         while (temp != 0) {
281             digits++;
282             temp /= 10;
283         }
284         bytes memory buffer = new bytes(digits);
285         while (value != 0) {
286             digits -= 1;
287             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
288             value /= 10;
289         }
290         return string(buffer);
291     }
292 
293     /**
294      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
295      */
296     function toHexString(uint256 value) internal pure returns (string memory) {
297         if (value == 0) {
298             return "0x00";
299         }
300         uint256 temp = value;
301         uint256 length = 0;
302         while (temp != 0) {
303             length++;
304             temp >>= 8;
305         }
306         return toHexString(value, length);
307     }
308 
309     /**
310      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
311      */
312     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
313         bytes memory buffer = new bytes(2 * length + 2);
314         buffer[0] = "0";
315         buffer[1] = "x";
316         for (uint256 i = 2 * length + 1; i > 1; --i) {
317             buffer[i] = _HEX_SYMBOLS[value & 0xf];
318             value >>= 4;
319         }
320         require(value == 0, "Strings: hex length insufficient");
321         return string(buffer);
322     }
323 }
324 
325 // File: @openzeppelin/contracts/utils/Context.sol
326 
327 
328 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Provides information about the current execution context, including the
334  * sender of the transaction and its data. While these are generally available
335  * via msg.sender and msg.data, they should not be accessed in such a direct
336  * manner, since when dealing with meta-transactions the account sending and
337  * paying for execution may not be the actual sender (as far as an application
338  * is concerned).
339  *
340  * This contract is only required for intermediate, library-like contracts.
341  */
342 abstract contract Context {
343     function _msgSender() internal view virtual returns (address) {
344         return msg.sender;
345     }
346 
347     function _msgData() internal view virtual returns (bytes calldata) {
348         return msg.data;
349     }
350 }
351 
352 // File: @openzeppelin/contracts/access/Ownable.sol
353 
354 
355 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
356 
357 pragma solidity ^0.8.0;
358 
359 
360 /**
361  * @dev Contract module which provides a basic access control mechanism, where
362  * there is an account (an owner) that can be granted exclusive access to
363  * specific functions.
364  *
365  * By default, the owner account will be the one that deploys the contract. This
366  * can later be changed with {transferOwnership}.
367  *
368  * This module is used through inheritance. It will make available the modifier
369  * `onlyOwner`, which can be applied to your functions to restrict their use to
370  * the owner.
371  */
372 abstract contract Ownable is Context {
373     address private _owner;
374 
375     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
376 
377     /**
378      * @dev Initializes the contract setting the deployer as the initial owner.
379      */
380     constructor() {
381         _transferOwnership(_msgSender());
382     }
383 
384     /**
385      * @dev Returns the address of the current owner.
386      */
387     function owner() public view virtual returns (address) {
388         return _owner;
389     }
390 
391     /**
392      * @dev Throws if called by any account other than the owner.
393      */
394     modifier onlyOwner() {
395         require(owner() == _msgSender(), "Ownable: caller is not the owner");
396         _;
397     }
398 
399     /**
400      * @dev Leaves the contract without owner. It will not be possible to call
401      * `onlyOwner` functions anymore. Can only be called by the current owner.
402      *
403      * NOTE: Renouncing ownership will leave the contract without an owner,
404      * thereby removing any functionality that is only available to the owner.
405      */
406     function renounceOwnership() public virtual onlyOwner {
407         _transferOwnership(address(0));
408     }
409 
410     /**
411      * @dev Transfers ownership of the contract to a new account (`newOwner`).
412      * Can only be called by the current owner.
413      */
414     function transferOwnership(address newOwner) public virtual onlyOwner {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         _transferOwnership(newOwner);
417     }
418 
419     /**
420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
421      * Internal function without access restriction.
422      */
423     function _transferOwnership(address newOwner) internal virtual {
424         address oldOwner = _owner;
425         _owner = newOwner;
426         emit OwnershipTransferred(oldOwner, newOwner);
427     }
428 }
429 
430 // File: @openzeppelin/contracts/utils/Address.sol
431 
432 
433 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
434 
435 pragma solidity ^0.8.1;
436 
437 /**
438  * @dev Collection of functions related to the address type
439  */
440 library Address {
441     /**
442      * @dev Returns true if `account` is a contract.
443      *
444      * [IMPORTANT]
445      * ====
446      * It is unsafe to assume that an address for which this function returns
447      * false is an externally-owned account (EOA) and not a contract.
448      *
449      * Among others, `isContract` will return false for the following
450      * types of addresses:
451      *
452      *  - an externally-owned account
453      *  - a contract in construction
454      *  - an address where a contract will be created
455      *  - an address where a contract lived, but was destroyed
456      * ====
457      *
458      * [IMPORTANT]
459      * ====
460      * You shouldn't rely on `isContract` to protect against flash loan attacks!
461      *
462      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
463      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
464      * constructor.
465      * ====
466      */
467     function isContract(address account) internal view returns (bool) {
468         // This method relies on extcodesize/address.code.length, which returns 0
469         // for contracts in construction, since the code is only stored at the end
470         // of the constructor execution.
471 
472         return account.code.length > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
656 
657 
658 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @title ERC721 token receiver interface
664  * @dev Interface for any contract that wants to support safeTransfers
665  * from ERC721 asset contracts.
666  */
667 interface IERC721Receiver {
668     /**
669      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
670      * by `operator` from `from`, this function is called.
671      *
672      * It must return its Solidity selector to confirm the token transfer.
673      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
674      *
675      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
676      */
677     function onERC721Received(
678         address operator,
679         address from,
680         uint256 tokenId,
681         bytes calldata data
682     ) external returns (bytes4);
683 }
684 
685 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Interface of the ERC165 standard, as defined in the
694  * https://eips.ethereum.org/EIPS/eip-165[EIP].
695  *
696  * Implementers can declare support of contract interfaces, which can then be
697  * queried by others ({ERC165Checker}).
698  *
699  * For an implementation, see {ERC165}.
700  */
701 interface IERC165 {
702     /**
703      * @dev Returns true if this contract implements the interface defined by
704      * `interfaceId`. See the corresponding
705      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
706      * to learn more about how these ids are created.
707      *
708      * This function call must use less than 30 000 gas.
709      */
710     function supportsInterface(bytes4 interfaceId) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @dev Implementation of the {IERC165} interface.
723  *
724  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
725  * for the additional interface id that will be supported. For example:
726  *
727  * ```solidity
728  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
729  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
730  * }
731  * ```
732  *
733  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
734  */
735 abstract contract ERC165 is IERC165 {
736     /**
737      * @dev See {IERC165-supportsInterface}.
738      */
739     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
740         return interfaceId == type(IERC165).interfaceId;
741     }
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
745 
746 
747 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @dev Required interface of an ERC721 compliant contract.
754  */
755 interface IERC721 is IERC165 {
756     /**
757      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
758      */
759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
760 
761     /**
762      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
763      */
764     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
765 
766     /**
767      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
768      */
769     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
770 
771     /**
772      * @dev Returns the number of tokens in ``owner``'s account.
773      */
774     function balanceOf(address owner) external view returns (uint256 balance);
775 
776     /**
777      * @dev Returns the owner of the `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function ownerOf(uint256 tokenId) external view returns (address owner);
784 
785     /**
786      * @dev Safely transfers `tokenId` token from `from` to `to`.
787      *
788      * Requirements:
789      *
790      * - `from` cannot be the zero address.
791      * - `to` cannot be the zero address.
792      * - `tokenId` token must exist and be owned by `from`.
793      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
794      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
795      *
796      * Emits a {Transfer} event.
797      */
798     function safeTransferFrom(
799         address from,
800         address to,
801         uint256 tokenId,
802         bytes calldata data
803     ) external;
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
807      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Transfers `tokenId` token from `from` to `to`.
827      *
828      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      *
837      * Emits a {Transfer} event.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
847      * The approval is cleared when the token is transferred.
848      *
849      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
850      *
851      * Requirements:
852      *
853      * - The caller must own the token or be an approved operator.
854      * - `tokenId` must exist.
855      *
856      * Emits an {Approval} event.
857      */
858     function approve(address to, uint256 tokenId) external;
859 
860     /**
861      * @dev Approve or remove `operator` as an operator for the caller.
862      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
863      *
864      * Requirements:
865      *
866      * - The `operator` cannot be the caller.
867      *
868      * Emits an {ApprovalForAll} event.
869      */
870     function setApprovalForAll(address operator, bool _approved) external;
871 
872     /**
873      * @dev Returns the account approved for `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function getApproved(uint256 tokenId) external view returns (address operator);
880 
881     /**
882      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
883      *
884      * See {setApprovalForAll}
885      */
886     function isApprovedForAll(address owner, address operator) external view returns (bool);
887 }
888 
889 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
890 
891 
892 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
893 
894 pragma solidity ^0.8.0;
895 
896 
897 /**
898  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
899  * @dev See https://eips.ethereum.org/EIPS/eip-721
900  */
901 interface IERC721Enumerable is IERC721 {
902     /**
903      * @dev Returns the total amount of tokens stored by the contract.
904      */
905     function totalSupply() external view returns (uint256);
906 
907     /**
908      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
909      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
910      */
911     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
912 
913     /**
914      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
915      * Use along with {totalSupply} to enumerate all tokens.
916      */
917     function tokenByIndex(uint256 index) external view returns (uint256);
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
921 
922 
923 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
930  * @dev See https://eips.ethereum.org/EIPS/eip-721
931  */
932 interface IERC721Metadata is IERC721 {
933     /**
934      * @dev Returns the token collection name.
935      */
936     function name() external view returns (string memory);
937 
938     /**
939      * @dev Returns the token collection symbol.
940      */
941     function symbol() external view returns (string memory);
942 
943     /**
944      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
945      */
946     function tokenURI(uint256 tokenId) external view returns (string memory);
947 }
948 
949 // File: https://github.com/chiru-labs/ERC721A/blob/v2.2.0/contracts/ERC721A.sol
950 
951 
952 // Creator: Chiru Labs
953 
954 pragma solidity ^0.8.4;
955 
956 
957 
958 
959 
960 
961 
962 
963 
964 error ApprovalCallerNotOwnerNorApproved();
965 error ApprovalQueryForNonexistentToken();
966 error ApproveToCaller();
967 error ApprovalToCurrentOwner();
968 error BalanceQueryForZeroAddress();
969 error MintedQueryForZeroAddress();
970 error BurnedQueryForZeroAddress();
971 error MintToZeroAddress();
972 error MintZeroQuantity();
973 error OwnerIndexOutOfBounds();
974 error OwnerQueryForNonexistentToken();
975 error TokenIndexOutOfBounds();
976 error TransferCallerNotOwnerNorApproved();
977 error TransferFromIncorrectOwner();
978 error TransferToNonERC721ReceiverImplementer();
979 error TransferToZeroAddress();
980 error URIQueryForNonexistentToken();
981 
982 /**
983  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
984  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
985  *
986  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
987  *
988  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
989  *
990  * Assumes that the maximum token id cannot exceed 2**128 - 1 (max value of uint128).
991  */
992 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
993     using Address for address;
994     using Strings for uint256;
995 
996     // Compiler will pack this into a single 256bit word.
997     struct TokenOwnership {
998         // The address of the owner.
999         address addr;
1000         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1001         uint64 startTimestamp;
1002         // Whether the token has been burned.
1003         bool burned;
1004     }
1005 
1006     // Compiler will pack this into a single 256bit word.
1007     struct AddressData {
1008         // Realistically, 2**64-1 is more than enough.
1009         uint64 balance;
1010         // Keeps track of mint count with minimal overhead for tokenomics.
1011         uint64 numberMinted;
1012         // Keeps track of burn count with minimal overhead for tokenomics.
1013         uint64 numberBurned;
1014     }
1015 
1016     // Compiler will pack the following 
1017     // _currentIndex and _burnCounter into a single 256bit word.
1018     
1019     // The tokenId of the next token to be minted.
1020     uint128 internal _currentIndex;
1021 
1022     // The number of tokens burned.
1023     uint128 internal _burnCounter;
1024 
1025     // Token name
1026     string private _name;
1027 
1028     // Token symbol
1029     string private _symbol;
1030 
1031     // Mapping from token ID to ownership details
1032     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1033     mapping(uint256 => TokenOwnership) internal _ownerships;
1034 
1035     // Mapping owner address to address data
1036     mapping(address => AddressData) private _addressData;
1037 
1038     // Mapping from token ID to approved address
1039     mapping(uint256 => address) private _tokenApprovals;
1040 
1041     // Mapping from owner to operator approvals
1042     mapping(address => mapping(address => bool)) private _operatorApprovals;
1043 
1044     constructor(string memory name_, string memory symbol_) {
1045         _name = name_;
1046         _symbol = symbol_;
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-totalSupply}.
1051      */
1052     function totalSupply() public view override returns (uint256) {
1053         // Counter underflow is impossible as _burnCounter cannot be incremented
1054         // more than _currentIndex times
1055         unchecked {
1056             return _currentIndex - _burnCounter;    
1057         }
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Enumerable-tokenByIndex}.
1062      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1063      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1064      */
1065     function tokenByIndex(uint256 index) public view override returns (uint256) {
1066         uint256 numMintedSoFar = _currentIndex;
1067         uint256 tokenIdsIdx;
1068 
1069         // Counter overflow is impossible as the loop breaks when
1070         // uint256 i is equal to another uint256 numMintedSoFar.
1071         unchecked {
1072             for (uint256 i; i < numMintedSoFar; i++) {
1073                 TokenOwnership memory ownership = _ownerships[i];
1074                 if (!ownership.burned) {
1075                     if (tokenIdsIdx == index) {
1076                         return i;
1077                     }
1078                     tokenIdsIdx++;
1079                 }
1080             }
1081         }
1082         revert TokenIndexOutOfBounds();
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1087      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1088      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1089      */
1090     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1091         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
1092         uint256 numMintedSoFar = _currentIndex;
1093         uint256 tokenIdsIdx;
1094         address currOwnershipAddr;
1095 
1096         // Counter overflow is impossible as the loop breaks when
1097         // uint256 i is equal to another uint256 numMintedSoFar.
1098         unchecked {
1099             for (uint256 i; i < numMintedSoFar; i++) {
1100                 TokenOwnership memory ownership = _ownerships[i];
1101                 if (ownership.burned) {
1102                     continue;
1103                 }
1104                 if (ownership.addr != address(0)) {
1105                     currOwnershipAddr = ownership.addr;
1106                 }
1107                 if (currOwnershipAddr == owner) {
1108                     if (tokenIdsIdx == index) {
1109                         return i;
1110                     }
1111                     tokenIdsIdx++;
1112                 }
1113             }
1114         }
1115 
1116         // Execution should never reach this point.
1117         revert();
1118     }
1119 
1120     /**
1121      * @dev See {IERC165-supportsInterface}.
1122      */
1123     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1124         return
1125             interfaceId == type(IERC721).interfaceId ||
1126             interfaceId == type(IERC721Metadata).interfaceId ||
1127             interfaceId == type(IERC721Enumerable).interfaceId ||
1128             super.supportsInterface(interfaceId);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-balanceOf}.
1133      */
1134     function balanceOf(address owner) public view override returns (uint256) {
1135         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1136         return uint256(_addressData[owner].balance);
1137     }
1138 
1139     function _numberMinted(address owner) internal view returns (uint256) {
1140         if (owner == address(0)) revert MintedQueryForZeroAddress();
1141         return uint256(_addressData[owner].numberMinted);
1142     }
1143 
1144     function _numberBurned(address owner) internal view returns (uint256) {
1145         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1146         return uint256(_addressData[owner].numberBurned);
1147     }
1148 
1149     /**
1150      * Gas spent here starts off proportional to the maximum mint batch size.
1151      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1152      */
1153     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1154         uint256 curr = tokenId;
1155 
1156         unchecked {
1157             if (curr < _currentIndex) {
1158                 TokenOwnership memory ownership = _ownerships[curr];
1159                 if (!ownership.burned) {
1160                     if (ownership.addr != address(0)) {
1161                         return ownership;
1162                     }
1163                     // Invariant: 
1164                     // There will always be an ownership that has an address and is not burned 
1165                     // before an ownership that does not have an address and is not burned.
1166                     // Hence, curr will not underflow.
1167                     while (true) {
1168                         curr--;
1169                         ownership = _ownerships[curr];
1170                         if (ownership.addr != address(0)) {
1171                             return ownership;
1172                         }
1173                     }
1174                 }
1175             }
1176         }
1177         revert OwnerQueryForNonexistentToken();
1178     }
1179 
1180     /**
1181      * @dev See {IERC721-ownerOf}.
1182      */
1183     function ownerOf(uint256 tokenId) public view override returns (address) {
1184         return ownershipOf(tokenId).addr;
1185     }
1186 
1187     /**
1188      * @dev See {IERC721Metadata-name}.
1189      */
1190     function name() public view virtual override returns (string memory) {
1191         return _name;
1192     }
1193 
1194     /**
1195      * @dev See {IERC721Metadata-symbol}.
1196      */
1197     function symbol() public view virtual override returns (string memory) {
1198         return _symbol;
1199     }
1200 
1201     /**
1202      * @dev See {IERC721Metadata-tokenURI}.
1203      */
1204     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1205         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1206 
1207         string memory baseURI = _baseURI();
1208         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1209     }
1210 
1211     /**
1212      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1213      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1214      * by default, can be overriden in child contracts.
1215      */
1216     function _baseURI() internal view virtual returns (string memory) {
1217         return '';
1218     }
1219 
1220     /**
1221      * @dev See {IERC721-approve}.
1222      */
1223     function approve(address to, uint256 tokenId) public override {
1224         address owner = ERC721A.ownerOf(tokenId);
1225         if (to == owner) revert ApprovalToCurrentOwner();
1226 
1227         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1228             revert ApprovalCallerNotOwnerNorApproved();
1229         }
1230 
1231         _approve(to, tokenId, owner);
1232     }
1233 
1234     /**
1235      * @dev See {IERC721-getApproved}.
1236      */
1237     function getApproved(uint256 tokenId) public view override returns (address) {
1238         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1239 
1240         return _tokenApprovals[tokenId];
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-setApprovalForAll}.
1245      */
1246     function setApprovalForAll(address operator, bool approved) public override {
1247         if (operator == _msgSender()) revert ApproveToCaller();
1248 
1249         _operatorApprovals[_msgSender()][operator] = approved;
1250         emit ApprovalForAll(_msgSender(), operator, approved);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-isApprovedForAll}.
1255      */
1256     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1257         return _operatorApprovals[owner][operator];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-transferFrom}.
1262      */
1263     function transferFrom(
1264         address from,
1265         address to,
1266         uint256 tokenId
1267     ) public virtual override {
1268         _transfer(from, to, tokenId);
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-safeTransferFrom}.
1273      */
1274     function safeTransferFrom(
1275         address from,
1276         address to,
1277         uint256 tokenId
1278     ) public virtual override {
1279         safeTransferFrom(from, to, tokenId, '');
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-safeTransferFrom}.
1284      */
1285     function safeTransferFrom(
1286         address from,
1287         address to,
1288         uint256 tokenId,
1289         bytes memory _data
1290     ) public virtual override {
1291         _transfer(from, to, tokenId);
1292         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1293             revert TransferToNonERC721ReceiverImplementer();
1294         }
1295     }
1296 
1297     /**
1298      * @dev Returns whether `tokenId` exists.
1299      *
1300      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1301      *
1302      * Tokens start existing when they are minted (`_mint`),
1303      */
1304     function _exists(uint256 tokenId) internal view returns (bool) {
1305         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1306     }
1307 
1308     function _safeMint(address to, uint256 quantity) internal {
1309         _safeMint(to, quantity, '');
1310     }
1311 
1312     /**
1313      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1314      *
1315      * Requirements:
1316      *
1317      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1318      * - `quantity` must be greater than 0.
1319      *
1320      * Emits a {Transfer} event.
1321      */
1322     function _safeMint(
1323         address to,
1324         uint256 quantity,
1325         bytes memory _data
1326     ) internal {
1327         _mint(to, quantity, _data, true);
1328     }
1329 
1330     /**
1331      * @dev Mints `quantity` tokens and transfers them to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - `to` cannot be the zero address.
1336      * - `quantity` must be greater than 0.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _mint(
1341         address to,
1342         uint256 quantity,
1343         bytes memory _data,
1344         bool safe
1345     ) internal {
1346         uint256 startTokenId = _currentIndex;
1347         if (to == address(0)) revert MintToZeroAddress();
1348         if (quantity == 0) revert MintZeroQuantity();
1349 
1350         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1351 
1352         // Overflows are incredibly unrealistic.
1353         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1354         // updatedIndex overflows if _currentIndex + quantity > 3.4e38 (2**128) - 1
1355         unchecked {
1356             _addressData[to].balance += uint64(quantity);
1357             _addressData[to].numberMinted += uint64(quantity);
1358 
1359             _ownerships[startTokenId].addr = to;
1360             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1361 
1362             uint256 updatedIndex = startTokenId;
1363 
1364             for (uint256 i; i < quantity; i++) {
1365                 emit Transfer(address(0), to, updatedIndex);
1366                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1367                     revert TransferToNonERC721ReceiverImplementer();
1368                 }
1369                 updatedIndex++;
1370             }
1371 
1372             _currentIndex = uint128(updatedIndex);
1373         }
1374         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1375     }
1376 
1377     /**
1378      * @dev Transfers `tokenId` from `from` to `to`.
1379      *
1380      * Requirements:
1381      *
1382      * - `to` cannot be the zero address.
1383      * - `tokenId` token must be owned by `from`.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function _transfer(
1388         address from,
1389         address to,
1390         uint256 tokenId
1391     ) private {
1392         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1393 
1394         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1395             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1396             getApproved(tokenId) == _msgSender());
1397 
1398         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1399         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1400         if (to == address(0)) revert TransferToZeroAddress();
1401 
1402         _beforeTokenTransfers(from, to, tokenId, 1);
1403 
1404         // Clear approvals from the previous owner
1405         _approve(address(0), tokenId, prevOwnership.addr);
1406 
1407         // Underflow of the sender's balance is impossible because we check for
1408         // ownership above and the recipient's balance can't realistically overflow.
1409         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1410         unchecked {
1411             _addressData[from].balance -= 1;
1412             _addressData[to].balance += 1;
1413 
1414             _ownerships[tokenId].addr = to;
1415             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1416 
1417             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1418             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1419             uint256 nextTokenId = tokenId + 1;
1420             if (_ownerships[nextTokenId].addr == address(0)) {
1421                 // This will suffice for checking _exists(nextTokenId),
1422                 // as a burned slot cannot contain the zero address.
1423                 if (nextTokenId < _currentIndex) {
1424                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1425                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1426                 }
1427             }
1428         }
1429 
1430         emit Transfer(from, to, tokenId);
1431         _afterTokenTransfers(from, to, tokenId, 1);
1432     }
1433 
1434     /**
1435      * @dev Destroys `tokenId`.
1436      * The approval is cleared when the token is burned.
1437      *
1438      * Requirements:
1439      *
1440      * - `tokenId` must exist.
1441      *
1442      * Emits a {Transfer} event.
1443      */
1444     function _burn(uint256 tokenId) internal virtual {
1445         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1446 
1447         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1448 
1449         // Clear approvals from the previous owner
1450         _approve(address(0), tokenId, prevOwnership.addr);
1451 
1452         // Underflow of the sender's balance is impossible because we check for
1453         // ownership above and the recipient's balance can't realistically overflow.
1454         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**128.
1455         unchecked {
1456             _addressData[prevOwnership.addr].balance -= 1;
1457             _addressData[prevOwnership.addr].numberBurned += 1;
1458 
1459             // Keep track of who burned the token, and the timestamp of burning.
1460             _ownerships[tokenId].addr = prevOwnership.addr;
1461             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1462             _ownerships[tokenId].burned = true;
1463 
1464             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1465             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1466             uint256 nextTokenId = tokenId + 1;
1467             if (_ownerships[nextTokenId].addr == address(0)) {
1468                 // This will suffice for checking _exists(nextTokenId),
1469                 // as a burned slot cannot contain the zero address.
1470                 if (nextTokenId < _currentIndex) {
1471                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1472                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1473                 }
1474             }
1475         }
1476 
1477         emit Transfer(prevOwnership.addr, address(0), tokenId);
1478         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1479 
1480         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1481         unchecked { 
1482             _burnCounter++;
1483         }
1484     }
1485 
1486     /**
1487      * @dev Approve `to` to operate on `tokenId`
1488      *
1489      * Emits a {Approval} event.
1490      */
1491     function _approve(
1492         address to,
1493         uint256 tokenId,
1494         address owner
1495     ) private {
1496         _tokenApprovals[tokenId] = to;
1497         emit Approval(owner, to, tokenId);
1498     }
1499 
1500     /**
1501      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1502      * The call is not executed if the target address is not a contract.
1503      *
1504      * @param from address representing the previous owner of the given token ID
1505      * @param to target address that will receive the tokens
1506      * @param tokenId uint256 ID of the token to be transferred
1507      * @param _data bytes optional data to send along with the call
1508      * @return bool whether the call correctly returned the expected magic value
1509      */
1510     function _checkOnERC721Received(
1511         address from,
1512         address to,
1513         uint256 tokenId,
1514         bytes memory _data
1515     ) private returns (bool) {
1516         if (to.isContract()) {
1517             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1518                 return retval == IERC721Receiver(to).onERC721Received.selector;
1519             } catch (bytes memory reason) {
1520                 if (reason.length == 0) {
1521                     revert TransferToNonERC721ReceiverImplementer();
1522                 } else {
1523                     assembly {
1524                         revert(add(32, reason), mload(reason))
1525                     }
1526                 }
1527             }
1528         } else {
1529             return true;
1530         }
1531     }
1532 
1533     /**
1534      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1535      * And also called before burning one token.
1536      *
1537      * startTokenId - the first token id to be transferred
1538      * quantity - the amount to be transferred
1539      *
1540      * Calling conditions:
1541      *
1542      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1543      * transferred to `to`.
1544      * - When `from` is zero, `tokenId` will be minted for `to`.
1545      * - When `to` is zero, `tokenId` will be burned by `from`.
1546      * - `from` and `to` are never both zero.
1547      */
1548     function _beforeTokenTransfers(
1549         address from,
1550         address to,
1551         uint256 startTokenId,
1552         uint256 quantity
1553     ) internal virtual {}
1554 
1555     /**
1556      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1557      * minting.
1558      * And also called after one token has been burned.
1559      *
1560      * startTokenId - the first token id to be transferred
1561      * quantity - the amount to be transferred
1562      *
1563      * Calling conditions:
1564      *
1565      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1566      * transferred to `to`.
1567      * - When `from` is zero, `tokenId` has been minted for `to`.
1568      * - When `to` is zero, `tokenId` has been burned by `from`.
1569      * - `from` and `to` are never both zero.
1570      */
1571     function _afterTokenTransfers(
1572         address from,
1573         address to,
1574         uint256 startTokenId,
1575         uint256 quantity
1576     ) internal virtual {}
1577 }
1578 
1579 // File: contracts/MUFFINPETSXYZ.sol
1580 
1581 
1582 pragma solidity ^0.8.6;
1583 
1584 
1585 
1586 
1587 
1588 pragma solidity ^0.8.0;
1589 
1590 contract MUFFINPETSXYZ is ERC721A, Ownable {
1591     using SafeMath for uint256;
1592     using Address for address;
1593     using Strings for uint256;
1594 
1595     uint256 public constant NFT_PRICE = 33000000000000000; // 0.03 ETH
1596     uint public constant MAX_NFT_PURCHASE = 20;
1597     uint public constant RESERVED_SUPPLY = 500; 
1598     uint256 public PUBLIC_SUPPLY = 9500;
1599     uint256 public MAX_SUPPLY = RESERVED_SUPPLY + PUBLIC_SUPPLY;
1600     bool public contractIsActive = false;
1601 
1602     string private _baseURIExtended;
1603     string public provenanceHash = "1351a033d18f0aede57d309929b1c81faf2f80beecae9a18e25aab889b6df2e0";
1604     mapping(uint256 => string) _tokenURIs;
1605     mapping(address => bool) minted;
1606 
1607     uint256 public totalReservedSupply;
1608     uint256 public totalPublicSupply;
1609 
1610 
1611     modifier mintOnlyOnce() {
1612         require(!minted[_msgSender()], 'Can only mint once');
1613         minted[_msgSender()] = true;
1614         _;
1615     }
1616 
1617     constructor() ERC721A('MUFFINPETS', 'MUFFINPETS.XYZ') {}
1618 
1619     function setContractActive(bool val) public onlyOwner {
1620         contractIsActive = val;
1621     }
1622 
1623     function withdraw() public onlyOwner {
1624         uint256 balance = address(this).balance;
1625         payable(msg.sender).transfer(balance);
1626     }
1627 
1628     function mintReserved(uint numberOfTokens) public onlyOwner {
1629         require(numberOfTokens > 0, "Cannot mint 0 tokens. Please increase quantity");
1630         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1631         require(totalReservedSupply < RESERVED_SUPPLY, "RESERVED_SUPPLY drained");
1632         require(totalReservedSupply.add(numberOfTokens) <= RESERVED_SUPPLY, "Purchase would exceed max supply");
1633         totalReservedSupply += numberOfTokens;
1634         _safeMint(msg.sender, numberOfTokens);
1635     }
1636 
1637     function mint(uint numberOfTokens) public payable {
1638         require(contractIsActive, "Sale is not active");
1639         require(numberOfTokens > 0, "Cannot mint 0 tokens. Please increase quantity");
1640         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1641         require(totalPublicSupply < PUBLIC_SUPPLY, "Purchase would exceed PUBLIC_SUPPLY");
1642         require(totalPublicSupply.add(numberOfTokens) <= PUBLIC_SUPPLY, "Purchase would exceed max supply");
1643         require(numberOfTokens <= MAX_NFT_PURCHASE, "Can only mint up to 20 per purchase");
1644         require(NFT_PRICE.mul(numberOfTokens) == msg.value, "Incorrect amount sent");
1645         totalPublicSupply += numberOfTokens;
1646         _safeMint(msg.sender, numberOfTokens);
1647     }
1648 
1649     function mintFree() public mintOnlyOnce {
1650         require(contractIsActive, "Sale is not active");
1651         require(totalSupply() < MAX_SUPPLY, "All tokens have been minted");
1652         require(totalSupply().add(1) <= PUBLIC_SUPPLY, "Purchase would exceed max supply");
1653         require(totalPublicSupply < PUBLIC_SUPPLY, "Minting would exceed PUBLIC_SUPPLY");
1654         totalPublicSupply += 1;
1655         _safeMint(msg.sender, 1);
1656     }
1657 
1658     function _baseURI() internal view virtual override returns (string memory) {
1659         return _baseURIExtended;
1660     }
1661 
1662     // Sets base URI for all tokens, only able to be called by contract owner
1663     function setBaseURI(string memory baseURI_) external onlyOwner {
1664         _baseURIExtended = baseURI_;
1665     }
1666 
1667     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1668         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1669 
1670         string memory _tokenURI = _tokenURIs[tokenId];
1671         string memory base = _baseURI();
1672 
1673         // If there is no base URI, return the token URI.
1674         if (bytes(base).length == 0) {
1675             return _tokenURI;
1676         }
1677         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1678         if (bytes(_tokenURI).length > 0) {
1679             return string(abi.encodePacked(base, _tokenURI));
1680         }
1681         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1682         return string(abi.encodePacked(base, tokenId.toString()));
1683     }
1684 }