1 // Sources flattened with hardhat v2.11.2 https://hardhat.org
2 
3 // File contracts/lib/InitializableOwnable.sol
4 
5 
6 
7 /**
8  * @title Ownable
9  * @author DODO Breeder
10  *
11  * @notice Ownership related functions
12  */
13 contract InitializableOwnable {
14     address public _OWNER_;
15     address public _NEW_OWNER_;
16     bool internal _INITIALIZED_;
17 
18     // ============ Events ============
19 
20     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     // ============ Modifiers ============
25 
26     modifier notInitialized() {
27         require(!_INITIALIZED_, "DODO_INITIALIZED");
28         _;
29     }
30 
31     modifier onlyOwner() {
32         require(msg.sender == _OWNER_, "NOT_OWNER");
33         _;
34     }
35 
36     // ============ Functions ============
37 
38     function initOwner(address newOwner) public notInitialized {
39         _INITIALIZED_ = true;
40         _OWNER_ = newOwner;
41     }
42 
43     function transferOwnership(address newOwner) public onlyOwner {
44         emit OwnershipTransferPrepared(_OWNER_, newOwner);
45         _NEW_OWNER_ = newOwner;
46     }
47 
48     function claimOwnership() public {
49         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
50         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
51         _OWNER_ = _NEW_OWNER_;
52         _NEW_OWNER_ = address(0);
53     }
54 }
55 
56 
57 // File contracts/intf/IDODOApprove.sol
58 
59 
60 interface IDODOApprove {
61     function claimTokens(address token,address who,address dest,uint256 amount) external;
62     function getDODOProxy() external view returns (address);
63 }
64 
65 
66 // File contracts/DODOApproveProxy.sol
67 
68 
69 
70 
71 interface IDODOApproveProxy {
72     function isAllowedProxy(address _proxy) external view returns (bool);
73     function claimTokens(address token,address who,address dest,uint256 amount) external;
74 }
75 
76 /**
77  * @title DODOApproveProxy
78  * @author DODO Breeder
79  *
80  * @notice Allow different version dodoproxy to claim from DODOApprove
81  */
82 contract DODOApproveProxy is InitializableOwnable {
83     
84     // ============ Storage ============
85     uint256 private constant _TIMELOCK_DURATION_ = 3 days;
86     mapping (address => bool) public _IS_ALLOWED_PROXY_;
87     uint256 public _TIMELOCK_;
88     address public _PENDING_ADD_DODO_PROXY_;
89     address public immutable _DODO_APPROVE_;
90 
91     // ============ Modifiers ============
92     modifier notLocked() {
93         require(
94             _TIMELOCK_ <= block.timestamp,
95             "SetProxy is timelocked"
96         );
97         _;
98     }
99 
100     constructor(address dodoApporve) public {
101         _DODO_APPROVE_ = dodoApporve;
102     }
103 
104     function init(address owner, address[] memory proxies) external {
105         initOwner(owner);
106         for(uint i = 0; i < proxies.length; i++) 
107             _IS_ALLOWED_PROXY_[proxies[i]] = true;
108     }
109 
110     function unlockAddProxy(address newDodoProxy) public onlyOwner {
111         _TIMELOCK_ = block.timestamp + _TIMELOCK_DURATION_;
112         _PENDING_ADD_DODO_PROXY_ = newDodoProxy;
113     }
114 
115     function lockAddProxy() public onlyOwner {
116        _PENDING_ADD_DODO_PROXY_ = address(0);
117        _TIMELOCK_ = 0;
118     }
119 
120 
121     function addDODOProxy() external onlyOwner notLocked() {
122         _IS_ALLOWED_PROXY_[_PENDING_ADD_DODO_PROXY_] = true;
123         lockAddProxy();
124     }
125 
126     function removeDODOProxy (address oldDodoProxy) public onlyOwner {
127         _IS_ALLOWED_PROXY_[oldDodoProxy] = false;
128     }
129     
130     function claimTokens(
131         address token,
132         address who,
133         address dest,
134         uint256 amount
135     ) external {
136         require(_IS_ALLOWED_PROXY_[msg.sender], "DODOApproveProxy:Access restricted");
137         IDODOApprove(_DODO_APPROVE_).claimTokens(
138             token,
139             who,
140             dest,
141             amount
142         );
143     }
144 
145     function isAllowedProxy(address _proxy) external view returns (bool) {
146         return _IS_ALLOWED_PROXY_[_proxy];
147     }
148 }
149 
150 
151 // File contracts/intf/IWETH.sol
152 
153 
154 
155 
156 interface IWETH {
157     function totalSupply() external view returns (uint256);
158 
159     function balanceOf(address account) external view returns (uint256);
160 
161     function transfer(address recipient, uint256 amount) external returns (bool);
162 
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     function transferFrom(
168         address src,
169         address dst,
170         uint256 wad
171     ) external returns (bool);
172 
173     function deposit() external payable;
174 
175     function withdraw(uint256 wad) external;
176 }
177 
178 
179 // File @openzeppelin/contracts/utils/math/Math.sol@v4.7.3
180 
181 
182 
183 /**
184  * @dev Standard math utilities missing in the Solidity language.
185  */
186 library Math {
187     enum Rounding {
188         Down, // Toward negative infinity
189         Up, // Toward infinity
190         Zero // Toward zero
191     }
192 
193     /**
194      * @dev Returns the largest of two numbers.
195      */
196     function max(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a >= b ? a : b;
198     }
199 
200     /**
201      * @dev Returns the smallest of two numbers.
202      */
203     function min(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a < b ? a : b;
205     }
206 
207     /**
208      * @dev Returns the average of two numbers. The result is rounded towards
209      * zero.
210      */
211     function average(uint256 a, uint256 b) internal pure returns (uint256) {
212         // (a + b) / 2 can overflow.
213         return (a & b) + (a ^ b) / 2;
214     }
215 
216     /**
217      * @dev Returns the ceiling of the division of two numbers.
218      *
219      * This differs from standard division with `/` in that it rounds up instead
220      * of rounding down.
221      */
222     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
223         // (a + b - 1) / b can overflow on addition, so we distribute.
224         return a == 0 ? 0 : (a - 1) / b + 1;
225     }
226 
227     /**
228      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
229      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
230      * with further edits by Uniswap Labs also under MIT license.
231      */
232     function mulDiv(
233         uint256 x,
234         uint256 y,
235         uint256 denominator
236     ) internal pure returns (uint256 result) {
237         unchecked {
238             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
239             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
240             // variables such that product = prod1 * 2^256 + prod0.
241             uint256 prod0; // Least significant 256 bits of the product
242             uint256 prod1; // Most significant 256 bits of the product
243             assembly {
244                 let mm := mulmod(x, y, not(0))
245                 prod0 := mul(x, y)
246                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
247             }
248 
249             // Handle non-overflow cases, 256 by 256 division.
250             if (prod1 == 0) {
251                 return prod0 / denominator;
252             }
253 
254             // Make sure the result is less than 2^256. Also prevents denominator == 0.
255             require(denominator > prod1);
256 
257             ///////////////////////////////////////////////
258             // 512 by 256 division.
259             ///////////////////////////////////////////////
260 
261             // Make division exact by subtracting the remainder from [prod1 prod0].
262             uint256 remainder;
263             assembly {
264                 // Compute remainder using mulmod.
265                 remainder := mulmod(x, y, denominator)
266 
267                 // Subtract 256 bit number from 512 bit number.
268                 prod1 := sub(prod1, gt(remainder, prod0))
269                 prod0 := sub(prod0, remainder)
270             }
271 
272             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
273             // See https://cs.stackexchange.com/q/138556/92363.
274 
275             // Does not overflow because the denominator cannot be zero at this stage in the function.
276             uint256 twos = denominator & (~denominator + 1);
277             assembly {
278                 // Divide denominator by twos.
279                 denominator := div(denominator, twos)
280 
281                 // Divide [prod1 prod0] by twos.
282                 prod0 := div(prod0, twos)
283 
284                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
285                 twos := add(div(sub(0, twos), twos), 1)
286             }
287 
288             // Shift in bits from prod1 into prod0.
289             prod0 |= prod1 * twos;
290 
291             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
292             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
293             // four bits. That is, denominator * inv = 1 mod 2^4.
294             uint256 inverse = (3 * denominator) ^ 2;
295 
296             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
297             // in modular arithmetic, doubling the correct bits in each step.
298             inverse *= 2 - denominator * inverse; // inverse mod 2^8
299             inverse *= 2 - denominator * inverse; // inverse mod 2^16
300             inverse *= 2 - denominator * inverse; // inverse mod 2^32
301             inverse *= 2 - denominator * inverse; // inverse mod 2^64
302             inverse *= 2 - denominator * inverse; // inverse mod 2^128
303             inverse *= 2 - denominator * inverse; // inverse mod 2^256
304 
305             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
306             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
307             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
308             // is no longer required.
309             result = prod0 * inverse;
310             return result;
311         }
312     }
313 
314     /**
315      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
316      */
317     function mulDiv(
318         uint256 x,
319         uint256 y,
320         uint256 denominator,
321         Rounding rounding
322     ) internal pure returns (uint256) {
323         uint256 result = mulDiv(x, y, denominator);
324         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
325             result += 1;
326         }
327         return result;
328     }
329 
330     /**
331      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
332      *
333      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
334      */
335     function sqrt(uint256 a) internal pure returns (uint256) {
336         if (a == 0) {
337             return 0;
338         }
339 
340         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
341         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
342         // `msb(a) <= a < 2*msb(a)`.
343         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
344         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
345         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
346         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
347         uint256 result = 1;
348         uint256 x = a;
349         if (x >> 128 > 0) {
350             x >>= 128;
351             result <<= 64;
352         }
353         if (x >> 64 > 0) {
354             x >>= 64;
355             result <<= 32;
356         }
357         if (x >> 32 > 0) {
358             x >>= 32;
359             result <<= 16;
360         }
361         if (x >> 16 > 0) {
362             x >>= 16;
363             result <<= 8;
364         }
365         if (x >> 8 > 0) {
366             x >>= 8;
367             result <<= 4;
368         }
369         if (x >> 4 > 0) {
370             x >>= 4;
371             result <<= 2;
372         }
373         if (x >> 2 > 0) {
374             result <<= 1;
375         }
376 
377         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
378         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
379         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
380         // into the expected uint128 result.
381         unchecked {
382             result = (result + a / result) >> 1;
383             result = (result + a / result) >> 1;
384             result = (result + a / result) >> 1;
385             result = (result + a / result) >> 1;
386             result = (result + a / result) >> 1;
387             result = (result + a / result) >> 1;
388             result = (result + a / result) >> 1;
389             return min(result, a / result);
390         }
391     }
392 
393     /**
394      * @notice Calculates sqrt(a), following the selected rounding direction.
395      */
396     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
397         uint256 result = sqrt(a);
398         if (rounding == Rounding.Up && result * result < a) {
399             result += 1;
400         }
401         return result;
402     }
403 }
404 
405 
406 // File contracts/lib/DecimalMath.sol
407 
408 
409 /**
410  * @title DecimalMath
411  * @author DODO Breeder
412  *
413  * @notice Functions for fixed point number with 18 decimals
414  */
415 
416 library DecimalMath {
417 
418     uint256 internal constant ONE = 10**18;
419     uint256 internal constant ONE2 = 10**36;
420 
421     function mul(uint256 target, uint256 d) internal pure returns (uint256) {
422         return target * d / (10**18);
423     }
424 
425     function mulFloor(uint256 target, uint256 d) internal pure returns (uint256) {
426         return target * d / (10**18);
427     }
428 
429     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
430         return _divCeil(target * d, 10**18);
431     }
432 
433     function div(uint256 target, uint256 d) internal pure returns (uint256) {
434         return target * (10**18) / d;
435     }
436 
437     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
438         return target * (10**18) / d;
439     }
440 
441     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
442         return _divCeil(target * (10**18), d);
443     }
444 
445     function reciprocalFloor(uint256 target) internal pure returns (uint256) {
446         return uint256(10**36) / target;
447     }
448 
449     function reciprocalCeil(uint256 target) internal pure returns (uint256) {
450         return _divCeil(uint256(10**36), target);
451     }
452 
453     function sqrt(uint256 target) internal pure returns (uint256) {
454         return Math.sqrt(target * ONE);
455     }
456 
457     function powFloor(uint256 target, uint256 e) internal pure returns (uint256) {
458         if (e == 0) {
459             return 10 ** 18;
460         } else if (e == 1) {
461             return target;
462         } else {
463             uint p = powFloor(target, e / 2);
464             p = p * p / (10**18);
465             if (e % 2 == 1) {
466                 p = p * target / (10**18);
467             }
468             return p;
469         }
470     }
471 
472     function _divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 quotient = a / b;
474         uint256 remainder = a - quotient * b;
475         if (remainder > 0) {
476             return quotient + 1;
477         } else {
478             return quotient;
479         }
480     }
481 }
482 
483 
484 // File contracts/SmartRoute/intf/IDODOAdapter.sol
485 
486 
487 
488 interface IDODOAdapter {
489     
490     function sellBase(address to, address pool, bytes memory data) external;
491 
492     function sellQuote(address to, address pool, bytes memory data) external;
493 }
494 
495 
496 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
497 
498 
499 
500 /**
501  * @dev Interface of the ERC20 standard as defined in the EIP.
502  */
503 interface IERC20 {
504     /**
505      * @dev Emitted when `value` tokens are moved from one account (`from`) to
506      * another (`to`).
507      *
508      * Note that `value` may be zero.
509      */
510     event Transfer(address indexed from, address indexed to, uint256 value);
511 
512     /**
513      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
514      * a call to {approve}. `value` is the new allowance.
515      */
516     event Approval(address indexed owner, address indexed spender, uint256 value);
517 
518     /**
519      * @dev Returns the amount of tokens in existence.
520      */
521     function totalSupply() external view returns (uint256);
522 
523     /**
524      * @dev Returns the amount of tokens owned by `account`.
525      */
526     function balanceOf(address account) external view returns (uint256);
527 
528     /**
529      * @dev Moves `amount` tokens from the caller's account to `to`.
530      *
531      * Returns a boolean value indicating whether the operation succeeded.
532      *
533      * Emits a {Transfer} event.
534      */
535     function transfer(address to, uint256 amount) external returns (bool);
536 
537     /**
538      * @dev Returns the remaining number of tokens that `spender` will be
539      * allowed to spend on behalf of `owner` through {transferFrom}. This is
540      * zero by default.
541      *
542      * This value changes when {approve} or {transferFrom} are called.
543      */
544     function allowance(address owner, address spender) external view returns (uint256);
545 
546     /**
547      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
548      *
549      * Returns a boolean value indicating whether the operation succeeded.
550      *
551      * IMPORTANT: Beware that changing an allowance with this method brings the risk
552      * that someone may use both the old and the new allowance by unfortunate
553      * transaction ordering. One possible solution to mitigate this race
554      * condition is to first reduce the spender's allowance to 0 and set the
555      * desired value afterwards:
556      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
557      *
558      * Emits an {Approval} event.
559      */
560     function approve(address spender, uint256 amount) external returns (bool);
561 
562     /**
563      * @dev Moves `amount` tokens from `from` to `to` using the
564      * allowance mechanism. `amount` is then deducted from the caller's
565      * allowance.
566      *
567      * Returns a boolean value indicating whether the operation succeeded.
568      *
569      * Emits a {Transfer} event.
570      */
571     function transferFrom(
572         address from,
573         address to,
574         uint256 amount
575     ) external returns (bool);
576 }
577 
578 
579 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
580 
581 
582 
583 /**
584  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
585  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
586  *
587  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
588  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
589  * need to send a transaction, and thus is not required to hold Ether at all.
590  */
591 interface IERC20Permit {
592     /**
593      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
594      * given ``owner``'s signed approval.
595      *
596      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
597      * ordering also apply here.
598      *
599      * Emits an {Approval} event.
600      *
601      * Requirements:
602      *
603      * - `spender` cannot be the zero address.
604      * - `deadline` must be a timestamp in the future.
605      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
606      * over the EIP712-formatted function arguments.
607      * - the signature must use ``owner``'s current nonce (see {nonces}).
608      *
609      * For more information on the signature format, see the
610      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
611      * section].
612      */
613     function permit(
614         address owner,
615         address spender,
616         uint256 value,
617         uint256 deadline,
618         uint8 v,
619         bytes32 r,
620         bytes32 s
621     ) external;
622 
623     /**
624      * @dev Returns the current nonce for `owner`. This value must be
625      * included whenever a signature is generated for {permit}.
626      *
627      * Every successful call to {permit} increases ``owner``'s nonce by one. This
628      * prevents a signature from being used multiple times.
629      */
630     function nonces(address owner) external view returns (uint256);
631 
632     /**
633      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
634      */
635     // solhint-disable-next-line func-name-mixedcase
636     function DOMAIN_SEPARATOR() external view returns (bytes32);
637 }
638 
639 
640 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
641 
642 
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      *
665      * [IMPORTANT]
666      * ====
667      * You shouldn't rely on `isContract` to protect against flash loan attacks!
668      *
669      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
670      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
671      * constructor.
672      * ====
673      */
674     function isContract(address account) internal view returns (bool) {
675         // This method relies on extcodesize/address.code.length, which returns 0
676         // for contracts in construction, since the code is only stored at the end
677         // of the constructor execution.
678 
679         return account.code.length > 0;
680     }
681 
682     /**
683      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
684      * `recipient`, forwarding all available gas and reverting on errors.
685      *
686      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
687      * of certain opcodes, possibly making contracts go over the 2300 gas limit
688      * imposed by `transfer`, making them unable to receive funds via
689      * `transfer`. {sendValue} removes this limitation.
690      *
691      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
692      *
693      * IMPORTANT: because control is transferred to `recipient`, care must be
694      * taken to not create reentrancy vulnerabilities. Consider using
695      * {ReentrancyGuard} or the
696      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
697      */
698     function sendValue(address payable recipient, uint256 amount) internal {
699         require(address(this).balance >= amount, "Address: insufficient balance");
700 
701         (bool success, ) = recipient.call{value: amount}("");
702         require(success, "Address: unable to send value, recipient may have reverted");
703     }
704 
705     /**
706      * @dev Performs a Solidity function call using a low level `call`. A
707      * plain `call` is an unsafe replacement for a function call: use this
708      * function instead.
709      *
710      * If `target` reverts with a revert reason, it is bubbled up by this
711      * function (like regular Solidity function calls).
712      *
713      * Returns the raw returned data. To convert to the expected return value,
714      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
715      *
716      * Requirements:
717      *
718      * - `target` must be a contract.
719      * - calling `target` with `data` must not revert.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
724         return functionCall(target, data, "Address: low-level call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
729      * `errorMessage` as a fallback revert reason when `target` reverts.
730      *
731      * _Available since v3.1._
732      */
733     function functionCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal returns (bytes memory) {
738         return functionCallWithValue(target, data, 0, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but also transferring `value` wei to `target`.
744      *
745      * Requirements:
746      *
747      * - the calling contract must have an ETH balance of at least `value`.
748      * - the called Solidity function must be `payable`.
749      *
750      * _Available since v3.1._
751      */
752     function functionCallWithValue(
753         address target,
754         bytes memory data,
755         uint256 value
756     ) internal returns (bytes memory) {
757         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
758     }
759 
760     /**
761      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
762      * with `errorMessage` as a fallback revert reason when `target` reverts.
763      *
764      * _Available since v3.1._
765      */
766     function functionCallWithValue(
767         address target,
768         bytes memory data,
769         uint256 value,
770         string memory errorMessage
771     ) internal returns (bytes memory) {
772         require(address(this).balance >= value, "Address: insufficient balance for call");
773         require(isContract(target), "Address: call to non-contract");
774 
775         (bool success, bytes memory returndata) = target.call{value: value}(data);
776         return verifyCallResult(success, returndata, errorMessage);
777     }
778 
779     /**
780      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
781      * but performing a static call.
782      *
783      * _Available since v3.3._
784      */
785     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
786         return functionStaticCall(target, data, "Address: low-level static call failed");
787     }
788 
789     /**
790      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
791      * but performing a static call.
792      *
793      * _Available since v3.3._
794      */
795     function functionStaticCall(
796         address target,
797         bytes memory data,
798         string memory errorMessage
799     ) internal view returns (bytes memory) {
800         require(isContract(target), "Address: static call to non-contract");
801 
802         (bool success, bytes memory returndata) = target.staticcall(data);
803         return verifyCallResult(success, returndata, errorMessage);
804     }
805 
806     /**
807      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
808      * but performing a delegate call.
809      *
810      * _Available since v3.4._
811      */
812     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
813         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
818      * but performing a delegate call.
819      *
820      * _Available since v3.4._
821      */
822     function functionDelegateCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         require(isContract(target), "Address: delegate call to non-contract");
828 
829         (bool success, bytes memory returndata) = target.delegatecall(data);
830         return verifyCallResult(success, returndata, errorMessage);
831     }
832 
833     /**
834      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
835      * revert reason using the provided one.
836      *
837      * _Available since v4.3._
838      */
839     function verifyCallResult(
840         bool success,
841         bytes memory returndata,
842         string memory errorMessage
843     ) internal pure returns (bytes memory) {
844         if (success) {
845             return returndata;
846         } else {
847             // Look for revert reason and bubble it up if present
848             if (returndata.length > 0) {
849                 // The easiest way to bubble the revert reason is using memory via assembly
850                 /// @solidity memory-safe-assembly
851                 assembly {
852                     let returndata_size := mload(returndata)
853                     revert(add(32, returndata), returndata_size)
854                 }
855             } else {
856                 revert(errorMessage);
857             }
858         }
859     }
860 }
861 
862 
863 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
864 
865 
866 
867 
868 
869 /**
870  * @title SafeERC20
871  * @dev Wrappers around ERC20 operations that throw on failure (when the token
872  * contract returns false). Tokens that return no value (and instead revert or
873  * throw on failure) are also supported, non-reverting calls are assumed to be
874  * successful.
875  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
876  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
877  */
878 library SafeERC20 {
879     using Address for address;
880 
881     function safeTransfer(
882         IERC20 token,
883         address to,
884         uint256 value
885     ) internal {
886         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
887     }
888 
889     function safeTransferFrom(
890         IERC20 token,
891         address from,
892         address to,
893         uint256 value
894     ) internal {
895         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
896     }
897 
898     /**
899      * @dev Deprecated. This function has issues similar to the ones found in
900      * {IERC20-approve}, and its usage is discouraged.
901      *
902      * Whenever possible, use {safeIncreaseAllowance} and
903      * {safeDecreaseAllowance} instead.
904      */
905     function safeApprove(
906         IERC20 token,
907         address spender,
908         uint256 value
909     ) internal {
910         // safeApprove should only be called when setting an initial allowance,
911         // or when resetting it to zero. To increase and decrease it, use
912         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
913         require(
914             (value == 0) || (token.allowance(address(this), spender) == 0),
915             "SafeERC20: approve from non-zero to non-zero allowance"
916         );
917         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
918     }
919 
920     function safeIncreaseAllowance(
921         IERC20 token,
922         address spender,
923         uint256 value
924     ) internal {
925         uint256 newAllowance = token.allowance(address(this), spender) + value;
926         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
927     }
928 
929     function safeDecreaseAllowance(
930         IERC20 token,
931         address spender,
932         uint256 value
933     ) internal {
934         unchecked {
935             uint256 oldAllowance = token.allowance(address(this), spender);
936             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
937             uint256 newAllowance = oldAllowance - value;
938             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
939         }
940     }
941 
942     function safePermit(
943         IERC20Permit token,
944         address owner,
945         address spender,
946         uint256 value,
947         uint256 deadline,
948         uint8 v,
949         bytes32 r,
950         bytes32 s
951     ) internal {
952         uint256 nonceBefore = token.nonces(owner);
953         token.permit(owner, spender, value, deadline, v, r, s);
954         uint256 nonceAfter = token.nonces(owner);
955         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
956     }
957 
958     /**
959      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
960      * on the return value: the return value is optional (but if data is returned, it must not be false).
961      * @param token The token targeted by the call.
962      * @param data The call data (encoded using abi.encode or one of its variants).
963      */
964     function _callOptionalReturn(IERC20 token, bytes memory data) private {
965         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
966         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
967         // the target address contains contract code and also asserts for success in the low-level call.
968 
969         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
970         if (returndata.length > 0) {
971             // Return data is optional
972             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
973         }
974     }
975 }
976 
977 
978 // File contracts/SmartRoute/lib/UniversalERC20.sol
979 
980 
981 
982 
983 library UniversalERC20 {
984     using SafeERC20 for IERC20;
985 
986     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
987 
988     // 1. skip 0 amount
989     // 2. handle ETH transfer
990     function universalTransfer(
991         IERC20 token,
992         address payable to,
993         uint256 amount
994     ) internal {
995         if (amount > 0) {
996             if (isETH(token)) {
997                 to.transfer(amount);
998             } else {
999                 token.safeTransfer(to, amount);
1000             }
1001         }
1002     }
1003 
1004     function universalApproveMax(
1005         IERC20 token,
1006         address to,
1007         uint256 amount
1008     ) internal {
1009         uint256 allowance = token.allowance(address(this), to);
1010         if (allowance < amount) {
1011             if (allowance > 0) {
1012                 token.safeApprove(to, 0);
1013             }
1014             token.safeApprove(to, type(uint256).max);
1015         }
1016     }
1017 
1018     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
1019         if (isETH(token)) {
1020             return who.balance;
1021         } else {
1022             return token.balanceOf(who);
1023         }
1024     }
1025 
1026     function tokenBalanceOf(IERC20 token, address who) internal view returns (uint256) {
1027         return token.balanceOf(who);
1028     }
1029 
1030     function isETH(IERC20 token) internal pure returns (bool) {
1031         return token == ETH_ADDRESS;
1032     }
1033 }
1034 
1035 
1036 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
1037 
1038 
1039 
1040 /**
1041  * @dev Provides information about the current execution context, including the
1042  * sender of the transaction and its data. While these are generally available
1043  * via msg.sender and msg.data, they should not be accessed in such a direct
1044  * manner, since when dealing with meta-transactions the account sending and
1045  * paying for execution may not be the actual sender (as far as an application
1046  * is concerned).
1047  *
1048  * This contract is only required for intermediate, library-like contracts.
1049  */
1050 abstract contract Context {
1051     function _msgSender() internal view virtual returns (address) {
1052         return msg.sender;
1053     }
1054 
1055     function _msgData() internal view virtual returns (bytes calldata) {
1056         return msg.data;
1057     }
1058 }
1059 
1060 
1061 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
1062 
1063 
1064 
1065 /**
1066  * @dev Contract module which provides a basic access control mechanism, where
1067  * there is an account (an owner) that can be granted exclusive access to
1068  * specific functions.
1069  *
1070  * By default, the owner account will be the one that deploys the contract. This
1071  * can later be changed with {transferOwnership}.
1072  *
1073  * This module is used through inheritance. It will make available the modifier
1074  * `onlyOwner`, which can be applied to your functions to restrict their use to
1075  * the owner.
1076  */
1077 abstract contract Ownable is Context {
1078     address private _owner;
1079 
1080     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1081 
1082     /**
1083      * @dev Initializes the contract setting the deployer as the initial owner.
1084      */
1085     constructor() {
1086         _transferOwnership(_msgSender());
1087     }
1088 
1089     /**
1090      * @dev Throws if called by any account other than the owner.
1091      */
1092     modifier onlyOwner() {
1093         _checkOwner();
1094         _;
1095     }
1096 
1097     /**
1098      * @dev Returns the address of the current owner.
1099      */
1100     function owner() public view virtual returns (address) {
1101         return _owner;
1102     }
1103 
1104     /**
1105      * @dev Throws if the sender is not the owner.
1106      */
1107     function _checkOwner() internal view virtual {
1108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1109     }
1110 
1111     /**
1112      * @dev Leaves the contract without owner. It will not be possible to call
1113      * `onlyOwner` functions anymore. Can only be called by the current owner.
1114      *
1115      * NOTE: Renouncing ownership will leave the contract without an owner,
1116      * thereby removing any functionality that is only available to the owner.
1117      */
1118     function renounceOwnership() public virtual onlyOwner {
1119         _transferOwnership(address(0));
1120     }
1121 
1122     /**
1123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1124      * Can only be called by the current owner.
1125      */
1126     function transferOwnership(address newOwner) public virtual onlyOwner {
1127         require(newOwner != address(0), "Ownable: new owner is the zero address");
1128         _transferOwnership(newOwner);
1129     }
1130 
1131     /**
1132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1133      * Internal function without access restriction.
1134      */
1135     function _transferOwnership(address newOwner) internal virtual {
1136         address oldOwner = _owner;
1137         _owner = newOwner;
1138         emit OwnershipTransferred(oldOwner, newOwner);
1139     }
1140 }
1141 
1142 
1143 // File contracts/SmartRoute/DODORouteProxy.sol
1144 
1145 /*
1146 
1147     Copyright 2022 DODO ZOO.
1148     SPDX-License-Identifier: Apache-2.0
1149 
1150 */
1151 
1152 pragma solidity 0.8.16;
1153 pragma experimental ABIEncoderV2;
1154 
1155 
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 /// @title DODORouteProxy
1164 /// @author DODO Breeder
1165 /// @notice new routeProxy contract with fee rebate to manage all route. It provides three methods to swap, 
1166 /// including mixSwap, multiSwap and externalSwap. Mixswap is for linear swap, which describes one token path 
1167 /// with one pool each time. Multiswap is a simplified version about 1inch, which describes one token path 
1168 /// with several pools each time. ExternalSwap is for other routers like 0x, 1inch and paraswap. Dodo and 
1169 /// front-end users could take certain route fee rebate from each swap. Wherein dodo will get a fixed percentage, 
1170 /// and front-end users could assign any proportion through function parameters.
1171 /// @dev dependence: DODOApprove.sol / DODOApproveProxy.sol / IDODOAdapter.sol
1172 /// In dodo's contract system, there is only one approve entrance DODOApprove.sol. DODOApprove manages DODOApproveProxy,
1173 /// Any contract which needs claim user's tokens must be registered in DODOApproveProxy. They used in DODORouteProxy are 
1174 /// to manage user's token, all user's token must be claimed through DODOApproveProxy and DODOApprove
1175 /// IDODOAdapter determine the interface of adapter, in which swap happened. There are different adapters for different
1176 /// pools. Adapter addresses are parameters contructed off chain so they are loose coupling with routeProxy.
1177 /// adapters have two interface functions. func sellBase(address to, address pool, bytes memory moreInfo) and func sellQuote(address to, address pool, bytes memory moreInfo)
1178 
1179 contract DODOFeeRouteProxy is Ownable {
1180 
1181     using UniversalERC20 for IERC20;
1182 
1183     // ============ Storage ============
1184 
1185     address constant _ETH_ADDRESS_ = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1186     address public immutable _WETH_;
1187     // dodo appprove proxy address, the only entrance to get user's token
1188     address public immutable _DODO_APPROVE_PROXY_;
1189     // used in multiSwap for split, sum of pool weight must equal totalWeight
1190     // in PoolInfo, pool weight has 8 bit, so totalWeight < 2**8
1191     uint256 public totalWeight = 100;
1192     // check safe safe for external call, add trusted external swap contract, 0x,1inch, paraswap
1193     // only owner could manage
1194     mapping(address => bool) public isWhiteListedContract; 
1195     // check safe for external approve, add trusted external swap approve contract, 0x, 1inch, paraswap
1196     // only owner could manage
1197     // Specially for 0x swap from eth, add zero address
1198     mapping(address => bool) public isApproveWhiteListedContract; 
1199 
1200     // dodo route fee rate, unit is 10**18, default fee rate is 1.5 * 1e15 / 1e18 = 0.0015 = 0.015%
1201     uint256 public routeFeeRate = 1500000000000000; 
1202     // dodo route fee receiver
1203     address public routeFeeReceiver;
1204 
1205     struct PoolInfo {
1206         // pool swap direciton, 0 is for sellBase, 1 is for sellQuote
1207         uint256 direction;
1208         // distinct transferFrom pool(like dodoV1) and transfer pool
1209         // 1 is for transferFrom pool, pool call transferFrom function to get tokens from adapter
1210         // 2 is for transfer pool, pool determine swapAmount through balanceOf(Token) - reserve
1211         uint256 poolEdition;
1212         // pool weight, actualWeight = weight/totalWeight, totalAmount * actualWeight = amount through this pool swap
1213         uint256 weight;
1214         // pool address
1215         address pool;
1216         // pool adapter, making actual swap call in corresponding adapter
1217         address adapter;
1218         // pool adapter's Info, record addtional infos(could be zero-bytes) needed by each pool adapter
1219         bytes moreInfo;
1220     }
1221 
1222     // ============ Events ============
1223 
1224     event OrderHistory(
1225         address fromToken,
1226         address toToken,
1227         address sender,
1228         uint256 fromAmount,
1229         uint256 returnAmount
1230     );
1231 
1232     // ============ Modifiers ============
1233 
1234     modifier judgeExpired(uint256 deadLine) {
1235         require(deadLine >= block.timestamp, "DODORouteProxy: EXPIRED");
1236         _;
1237     }
1238 
1239     fallback() external payable {}
1240 
1241     receive() external payable {}
1242 
1243     // ============ Constructor ============
1244 
1245     constructor(address payable weth, address dodoApproveProxy, address feeReceiver) public {
1246         require(feeReceiver != address(0), "DODORouteProxy: feeReceiver invalid");
1247         require(dodoApproveProxy != address(0), "DODORouteProxy: dodoApproveProxy invalid");
1248         require(weth != address(0), "DODORouteProxy: weth address invalid");
1249 
1250         _WETH_ = weth;
1251         _DODO_APPROVE_PROXY_ = dodoApproveProxy;
1252         routeFeeReceiver = feeReceiver;
1253     }
1254 
1255     // ============ Owner only ============
1256 
1257     function addWhiteList(address contractAddr) public onlyOwner {
1258         isWhiteListedContract[contractAddr] = true;
1259     }
1260 
1261     function removeWhiteList(address contractAddr) public onlyOwner {
1262         isWhiteListedContract[contractAddr] = false;
1263     }
1264 
1265     function addApproveWhiteList(address contractAddr) public onlyOwner {
1266         isApproveWhiteListedContract[contractAddr] = true;
1267     }
1268 
1269     function removeApproveWhiteList(address contractAddr) public onlyOwner {
1270         isApproveWhiteListedContract[contractAddr] = false;
1271     }
1272 
1273     function changeRouteFeeRate(uint256 newFeeRate) public onlyOwner {
1274         require(newFeeRate < 10**18, "DODORouteProxy: newFeeRate overflowed");
1275         routeFeeRate = newFeeRate;
1276     }
1277   
1278     function changeRouteFeeReceiver(address newFeeReceiver) public onlyOwner {
1279         require(newFeeReceiver != address(0), "DODORouteProxy: feeReceiver invalid");
1280         routeFeeReceiver = newFeeReceiver;
1281     }
1282 
1283     function changeTotalWeight(uint256 newTotalWeight) public onlyOwner {
1284         require(newTotalWeight < 2 ** 8, "DODORouteProxy: totalWeight overflowed");
1285         totalWeight = newTotalWeight;
1286     }
1287 
1288     /// @notice used for emergency, generally there wouldn't be tokens left
1289     function superWithdraw(address token) public onlyOwner {
1290         if(token != _ETH_ADDRESS_) {
1291             uint256 restAmount = IERC20(token).universalBalanceOf(address(this));
1292             IERC20(token).universalTransfer(payable(routeFeeReceiver), restAmount);
1293         } else {
1294             uint256 restAmount = address(this).balance;
1295             payable(routeFeeReceiver).transfer(restAmount);
1296         }
1297     }
1298 
1299     // ============ Swap ============
1300 
1301 
1302     /// @notice Call external black box contracts to finish a swap
1303     /// @param approveTarget external swap approve address
1304     /// @param swapTarget external swap address
1305     /// @param feeData route fee info
1306     /// @param callDataConcat external swap data, toAddress need to be routeProxy
1307     /// specially when toToken is ETH, use WETH as external calldata's toToken
1308     function externalSwap(
1309         address fromToken,
1310         address toToken,
1311         address approveTarget,
1312         address swapTarget,
1313         uint256 fromTokenAmount,
1314         uint256 minReturnAmount,
1315         bytes memory feeData,
1316         bytes memory callDataConcat,
1317         uint256 deadLine
1318     ) external payable judgeExpired(deadLine) returns (uint256 receiveAmount) {      
1319         require(isWhiteListedContract[swapTarget], "DODORouteProxy: Not Whitelist Contract");  
1320         require(isApproveWhiteListedContract[approveTarget], "DODORouteProxy: Not Whitelist Appprove Contract");  
1321 
1322         // transfer in fromToken
1323         if (fromToken != _ETH_ADDRESS_) {
1324             // approve if needed
1325             if (approveTarget != address(0)) {
1326                 IERC20(fromToken).universalApproveMax(approveTarget, fromTokenAmount);
1327             }
1328 
1329             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(
1330                 fromToken,
1331                 msg.sender,
1332                 address(this),
1333                 fromTokenAmount
1334             );
1335         } else {
1336             // value check
1337             require(msg.value == fromTokenAmount, "DODORouteProxy: invalid ETH amount");
1338         }
1339 
1340         // swap
1341         uint256 toTokenOriginBalance;
1342         if(toToken != _ETH_ADDRESS_) {
1343             toTokenOriginBalance = IERC20(toToken).universalBalanceOf(address(this));
1344         } else {
1345             toTokenOriginBalance = IERC20(_WETH_).universalBalanceOf(address(this));
1346         }
1347 
1348         {  
1349             require(swapTarget != _DODO_APPROVE_PROXY_, "DODORouteProxy: Risk Target");
1350             (bool success, bytes memory result) = swapTarget.call{
1351                 value: fromToken == _ETH_ADDRESS_ ? fromTokenAmount : 0
1352             }(callDataConcat);
1353             // revert with lowlevel info
1354             if (success == false) {
1355                 assembly {
1356                     revert(add(result,32),mload(result))
1357                 }
1358             }
1359         }
1360 
1361         // calculate toToken amount
1362         if(toToken != _ETH_ADDRESS_) {
1363             receiveAmount = IERC20(toToken).universalBalanceOf(address(this)) - (
1364                 toTokenOriginBalance
1365             );
1366         } else {
1367             receiveAmount = IERC20(_WETH_).universalBalanceOf(address(this)) - (
1368                 toTokenOriginBalance
1369             );
1370         }
1371         
1372         // distribute toToken
1373         receiveAmount = _routeWithdraw(toToken, receiveAmount, feeData, minReturnAmount);
1374 
1375         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, receiveAmount);
1376     }
1377 
1378     /// @notice linear version, describes one token path with one pool each time
1379     /// @param mixAdapters adapter address array, record each pool's interrelated adapter in order
1380     /// @param mixPairs pool address array, record pool address of the whole route in order
1381     /// @param assetTo asset Address（pool or proxy）, describe pool adapter's receiver address. Specially assetTo[0] is deposit receiver before all
1382     /// @param directions pool directions aggregation, one bit represent one pool direction, 0 means sellBase, 1 means sellQuote
1383     /// @param moreInfos pool adapter's Info set, record addtional infos(could be zero-bytes) needed by each pool adapter, keeping order with adapters
1384     /// @param feeData route fee info, bytes decode into broker and brokerFee, determine rebate proportion, brokerFee in [0, 1e18]
1385     function mixSwap(
1386         address fromToken,
1387         address toToken,
1388         uint256 fromTokenAmount,
1389         uint256 minReturnAmount,
1390         address[] memory mixAdapters,
1391         address[] memory mixPairs,
1392         address[] memory assetTo,
1393         uint256 directions,
1394         bytes[] memory moreInfos,
1395         bytes memory feeData,
1396         uint256 deadLine
1397     ) external payable judgeExpired(deadLine) returns (uint256 receiveAmount) {
1398         require(mixPairs.length > 0, "DODORouteProxy: PAIRS_EMPTY");
1399         require(mixPairs.length == mixAdapters.length, "DODORouteProxy: PAIR_ADAPTER_NOT_MATCH");
1400         require(mixPairs.length == assetTo.length - 1, "DODORouteProxy: PAIR_ASSETTO_NOT_MATCH");
1401         require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");
1402 
1403         address _toToken = toToken;
1404         {
1405         uint256 _fromTokenAmount = fromTokenAmount;
1406         address _fromToken = fromToken;
1407 
1408         uint256 toTokenOriginBalance;
1409         if(_toToken != _ETH_ADDRESS_) {
1410             toTokenOriginBalance = IERC20(_toToken).universalBalanceOf(address(this));
1411         } else {
1412             toTokenOriginBalance = IERC20(_WETH_).universalBalanceOf(address(this));
1413         }
1414 
1415         // transfer in fromToken
1416         _deposit(
1417             msg.sender,
1418             assetTo[0],
1419             _fromToken,
1420             _fromTokenAmount,
1421             _fromToken == _ETH_ADDRESS_
1422         );
1423 
1424         // swap
1425         for (uint256 i = 0; i < mixPairs.length; i++) {
1426             if (directions & 1 == 0) {
1427                 IDODOAdapter(mixAdapters[i]).sellBase(
1428                     assetTo[i + 1],
1429                     mixPairs[i],
1430                     moreInfos[i]
1431                 );
1432             } else {
1433                 IDODOAdapter(mixAdapters[i]).sellQuote(
1434                     assetTo[i + 1],
1435                     mixPairs[i],
1436                     moreInfos[i]
1437                 );
1438             }
1439             directions = directions >> 1;
1440         }
1441 
1442         // calculate toToken amount
1443         if(_toToken != _ETH_ADDRESS_) {
1444             receiveAmount = IERC20(_toToken).universalBalanceOf(address(this)) - (
1445                 toTokenOriginBalance
1446             );
1447         } else {
1448             receiveAmount = IERC20(_WETH_).universalBalanceOf(address(this)) - (
1449                 toTokenOriginBalance
1450             );
1451         }
1452         }
1453 
1454         // distribute toToken
1455         receiveAmount = _routeWithdraw(_toToken, receiveAmount, feeData, minReturnAmount);
1456 
1457         emit OrderHistory(fromToken, toToken, msg.sender, fromTokenAmount, receiveAmount);
1458     }
1459 
1460     /// @notice split version, describes one token path with several pools each time. Called one token pair with several pools "one split"
1461     /// @param splitNumber record pool number in one split, determine sequence(poolInfo) array subscript in transverse. Begin with 0
1462     /// for example, [0,1, 3], mean the first split has one(1 - 0) pool, the second split has 2 (3 - 1) pool
1463     /// @param midToken middle token set, record token path in order. 
1464     /// Specially midToken[1] is WETH addresss when fromToken is ETH. Besides midToken[1] is also fromToken 
1465     /// Specially midToken[length - 2] is WETH address and midToken[length -1 ] is ETH address when toToken is ETH. Besides midToken[length -1]
1466     /// is the last toToken and midToken[length - 2] is common second last middle token.
1467     /// @param assetFrom asset Address（pool or proxy）describe pool adapter's receiver address. Specially assetFrom[0] is deposit receiver before all
1468     /// @param sequence PoolInfo sequence, describe each pool's attributions, ordered by spiltNumber
1469     /// @param feeData route fee info, bytes decode into broker and brokerFee, determine rebate proportion, brokerFee in [0, 1e18]
1470     function dodoMutliSwap(
1471         uint256 fromTokenAmount,
1472         uint256 minReturnAmount,
1473         uint256[] memory splitNumber,  
1474         address[] memory midToken,
1475         address[] memory assetFrom,
1476         bytes[] memory sequence, 
1477         bytes memory feeData,
1478         uint256 deadLine
1479     ) external payable judgeExpired(deadLine) returns (uint256 receiveAmount) {
1480         address toToken = midToken[midToken.length - 1];
1481         {
1482         require(
1483             assetFrom.length == splitNumber.length,
1484             "DODORouteProxy: PAIR_ASSETTO_NOT_MATCH"
1485         );
1486         require(minReturnAmount > 0, "DODORouteProxy: RETURN_AMOUNT_ZERO");
1487         uint256 _fromTokenAmount = fromTokenAmount;
1488         address fromToken = midToken[0];
1489 
1490         uint256 toTokenOriginBalance;
1491         if(toToken != _ETH_ADDRESS_) {
1492             toTokenOriginBalance = IERC20(toToken).universalBalanceOf(address(this));
1493         } else {
1494             toTokenOriginBalance = IERC20(_WETH_).universalBalanceOf(address(this));
1495         }
1496 
1497         // transfer in fromToken
1498         _deposit(
1499             msg.sender,
1500             assetFrom[0],
1501             fromToken,
1502             _fromTokenAmount,
1503             fromToken == _ETH_ADDRESS_
1504         );
1505 
1506         // swap
1507         _multiSwap(midToken, splitNumber, sequence, assetFrom);
1508 
1509         // calculate toToken amount
1510         if(toToken != _ETH_ADDRESS_) {
1511             receiveAmount = IERC20(toToken).universalBalanceOf(address(this)) - (
1512                 toTokenOriginBalance
1513             );
1514         } else {
1515             receiveAmount = IERC20(_WETH_).universalBalanceOf(address(this)) - (
1516                 toTokenOriginBalance
1517             );
1518         }
1519         }
1520         // distribute toToken
1521         receiveAmount = _routeWithdraw(toToken, receiveAmount, feeData, minReturnAmount);
1522 
1523         emit OrderHistory(
1524             midToken[0], //fromToken
1525             midToken[midToken.length - 1], //toToken
1526             msg.sender,
1527             fromTokenAmount,
1528             receiveAmount
1529         );
1530     }
1531 
1532     //====================== internal =======================
1533     /// @notice multiSwap process
1534     function _multiSwap(
1535         address[] memory midToken,
1536         uint256[] memory splitNumber,
1537         bytes[] memory swapSequence,
1538         address[] memory assetFrom
1539     ) internal {
1540         for (uint256 i = 1; i < splitNumber.length; i++) {
1541             // begin one split(one token pair with one or more pools)
1542             // define midtoken address, ETH -> WETH address
1543             uint256 curTotalAmount = IERC20(midToken[i]).tokenBalanceOf(assetFrom[i - 1]);
1544             uint256 curTotalWeight = totalWeight;
1545 
1546             // split amount into all pools if needed, transverse all pool in this split
1547             for (uint256 j = splitNumber[i - 1]; j < splitNumber[i]; j++) {
1548                 PoolInfo memory curPoolInfo;
1549                 {
1550                     (address pool, address adapter, uint256 mixPara, bytes memory moreInfo) = abi
1551                         .decode(swapSequence[j], (address, address, uint256, bytes));
1552 
1553                     curPoolInfo.direction = mixPara >> 17;
1554                     curPoolInfo.weight = (0xffff & mixPara) >> 9;
1555                     curPoolInfo.poolEdition = (0xff & mixPara);
1556                     curPoolInfo.pool = pool;
1557                     curPoolInfo.adapter = adapter;
1558                     curPoolInfo.moreInfo = moreInfo;
1559                 }
1560 
1561                 // assetFrom[i - 1] is routeProxy when there are more than one pools in this split
1562                 if (assetFrom[i - 1] == address(this)) {
1563                     uint256 curAmount = curTotalAmount * curPoolInfo.weight / curTotalWeight;
1564                     // last spilt check
1565                     if(j == splitNumber[i] - 1) {
1566                         curAmount = IERC20(midToken[i]).tokenBalanceOf(address(this));
1567                     }
1568 
1569                     if (curPoolInfo.poolEdition == 1) {
1570                         //For using transferFrom pool (like dodoV1, Curve), pool call transferFrom function to get tokens from adapter
1571                         SafeERC20.safeTransfer(IERC20(midToken[i]), curPoolInfo.adapter, curAmount);
1572                     } else {
1573                         //For using transfer pool (like dodoV2), pool determine swapAmount through balanceOf(Token) - reserve
1574                         SafeERC20.safeTransfer(IERC20(midToken[i]), curPoolInfo.pool, curAmount);
1575                     }
1576                 }
1577 
1578                 if (curPoolInfo.direction == 0) {
1579                     IDODOAdapter(curPoolInfo.adapter).sellBase(
1580                         assetFrom[i],
1581                         curPoolInfo.pool,
1582                         curPoolInfo.moreInfo
1583                     );
1584                 } else {
1585                     IDODOAdapter(curPoolInfo.adapter).sellQuote(
1586                         assetFrom[i],
1587                         curPoolInfo.pool,
1588                         curPoolInfo.moreInfo
1589                     );
1590                 }
1591             }
1592         }
1593     }
1594 
1595     /// @notice before the first pool swap, contract call _deposit to get ERC20 token through DODOApprove/transfer ETH to WETH
1596     function _deposit(
1597         address from,
1598         address to,
1599         address token,
1600         uint256 amount,
1601         bool isETH
1602     ) internal {
1603         if (isETH) {
1604             if (amount > 0) {
1605                 require(msg.value == amount, "ETH_VALUE_WRONG");
1606                 IWETH(_WETH_).deposit{value: amount}();
1607                 if (to != address(this)) SafeERC20.safeTransfer(IERC20(_WETH_), to, amount);
1608             }
1609         } else {
1610             IDODOApproveProxy(_DODO_APPROVE_PROXY_).claimTokens(token, from, to, amount);
1611         }
1612     }
1613 
1614     /// @notice after all swaps, transfer tokens to original receiver(user) and distribute fees to DODO and broker
1615     /// Specially when toToken is ETH, distribute WETH
1616     function _routeWithdraw(
1617         address toToken,
1618         uint256 receiveAmount,
1619         bytes memory feeData,
1620         uint256 minReturnAmount
1621     ) internal returns(uint256 userReceiveAmount) {
1622         address originToToken = toToken;
1623         if(toToken == _ETH_ADDRESS_) {
1624             toToken = _WETH_;
1625         }
1626         (address broker, uint256 brokerFeeRate) = abi.decode(feeData, (address, uint256));
1627         require(brokerFeeRate < 10**18, "DODORouteProxy: brokerFeeRate overflowed");
1628 
1629         uint256 routeFee = DecimalMath.mulFloor(receiveAmount, routeFeeRate);
1630         IERC20(toToken).universalTransfer(payable(routeFeeReceiver), routeFee);
1631 
1632         uint256 brokerFee = DecimalMath.mulFloor(receiveAmount, brokerFeeRate);
1633         IERC20(toToken).universalTransfer(payable(broker), brokerFee);
1634         
1635         receiveAmount = receiveAmount - routeFee - brokerFee;
1636         require(receiveAmount >= minReturnAmount, "DODORouteProxy: Return amount is not enough");
1637         
1638         if (originToToken == _ETH_ADDRESS_) {
1639             IWETH(_WETH_).withdraw(receiveAmount);
1640             payable(msg.sender).transfer(receiveAmount);
1641         } else {
1642             IERC20(toToken).universalTransfer(payable(msg.sender), receiveAmount);
1643         }
1644 
1645         userReceiveAmount = receiveAmount;
1646     }
1647 }