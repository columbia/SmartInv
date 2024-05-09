1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @kyber.network/utils-sc/contracts/IERC20Ext.sol
82 
83 pragma solidity 0.6.6;
84 
85 
86 
87 /**
88  * @dev Interface extending ERC20 standard to include decimals() as
89  *      it is optional in the OpenZeppelin IERC20 interface.
90  */
91 interface IERC20Ext is IERC20 {
92     /**
93      * @dev This function is required as Kyber requires to interact
94      *      with token.decimals() with many of its operations.
95      */
96     function decimals() external view returns (uint8 digits);
97 }
98 
99 // File: contracts/sol6/IKyberReserve.sol
100 
101 pragma solidity 0.6.6;
102 
103 
104 
105 interface IKyberReserve {
106     function trade(
107         IERC20Ext srcToken,
108         uint256 srcAmount,
109         IERC20Ext destToken,
110         address payable destAddress,
111         uint256 conversionRate,
112         bool validate
113     ) external payable returns (bool);
114 
115     function getConversionRate(
116         IERC20Ext src,
117         IERC20Ext dest,
118         uint256 srcQty,
119         uint256 blockNumber
120     ) external view returns (uint256);
121 }
122 
123 // File: contracts/sol6/IWeth.sol
124 
125 pragma solidity 0.6.6;
126 
127 
128 
129 interface IWeth is IERC20Ext {
130     function deposit() external payable;
131     function withdraw(uint256 wad) external;
132 }
133 
134 // File: contracts/sol6/IKyberSanity.sol
135 
136 pragma solidity 0.6.6;
137 
138 
139 interface IKyberSanity {
140     function getSanityRate(IERC20Ext src, IERC20Ext dest) external view returns (uint256);
141 }
142 
143 // File: contracts/sol6/IConversionRates.sol
144 
145 pragma solidity 0.6.6;
146 
147 
148 
149 interface IConversionRates {
150 
151     function recordImbalance(
152         IERC20Ext token,
153         int buyAmount,
154         uint256 rateUpdateBlock,
155         uint256 currentBlock
156     ) external;
157 
158     function getRate(
159         IERC20Ext token,
160         uint256 currentBlockNumber,
161         bool buy,
162         uint256 qty
163     ) external view returns(uint256);
164 }
165 
166 // File: @kyber.network/utils-sc/contracts/Utils.sol
167 
168 pragma solidity 0.6.6;
169 
170 
171 
172 /**
173  * @title Kyber utility file
174  * mostly shared constants and rate calculation helpers
175  * inherited by most of kyber contracts.
176  * previous utils implementations are for previous solidity versions.
177  */
178 contract Utils {
179     /// Declared constants below to be used in tandem with
180     /// getDecimalsConstant(), for gas optimization purposes
181     /// which return decimals from a constant list of popular
182     /// tokens.
183     IERC20Ext internal constant ETH_TOKEN_ADDRESS = IERC20Ext(
184         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
185     );
186     IERC20Ext internal constant USDT_TOKEN_ADDRESS = IERC20Ext(
187         0xdAC17F958D2ee523a2206206994597C13D831ec7
188     );
189     IERC20Ext internal constant DAI_TOKEN_ADDRESS = IERC20Ext(
190         0x6B175474E89094C44Da98b954EedeAC495271d0F
191     );
192     IERC20Ext internal constant USDC_TOKEN_ADDRESS = IERC20Ext(
193         0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
194     );
195     IERC20Ext internal constant WBTC_TOKEN_ADDRESS = IERC20Ext(
196         0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599
197     );
198     IERC20Ext internal constant KNC_TOKEN_ADDRESS = IERC20Ext(
199         0xdd974D5C2e2928deA5F71b9825b8b646686BD200
200     );
201     uint256 public constant BPS = 10000; // Basic Price Steps. 1 step = 0.01%
202     uint256 internal constant PRECISION = (10**18);
203     uint256 internal constant MAX_QTY = (10**28); // 10B tokens
204     uint256 internal constant MAX_RATE = (PRECISION * 10**7); // up to 10M tokens per eth
205     uint256 internal constant MAX_DECIMALS = 18;
206     uint256 internal constant ETH_DECIMALS = 18;
207     uint256 internal constant MAX_ALLOWANCE = uint256(-1); // token.approve inifinite
208 
209     mapping(IERC20Ext => uint256) internal decimals;
210 
211     /// @dev Sets the decimals of a token to storage if not already set, and returns
212     ///      the decimals value of the token. Prefer using this function over
213     ///      getDecimals(), to avoid forgetting to set decimals in local storage.
214     /// @param token The token type
215     /// @return tokenDecimals The decimals of the token
216     function getSetDecimals(IERC20Ext token) internal returns (uint256 tokenDecimals) {
217         tokenDecimals = getDecimalsConstant(token);
218         if (tokenDecimals > 0) return tokenDecimals;
219 
220         tokenDecimals = decimals[token];
221         if (tokenDecimals == 0) {
222             tokenDecimals = token.decimals();
223             decimals[token] = tokenDecimals;
224         }
225     }
226 
227     /// @dev Get the balance of a user
228     /// @param token The token type
229     /// @param user The user's address
230     /// @return The balance
231     function getBalance(IERC20Ext token, address user) internal view returns (uint256) {
232         if (token == ETH_TOKEN_ADDRESS) {
233             return user.balance;
234         } else {
235             return token.balanceOf(user);
236         }
237     }
238 
239     /// @dev Get the decimals of a token, read from the constant list, storage,
240     ///      or from token.decimals(). Prefer using getSetDecimals when possible.
241     /// @param token The token type
242     /// @return tokenDecimals The decimals of the token
243     function getDecimals(IERC20Ext token) internal view returns (uint256 tokenDecimals) {
244         // return token decimals if has constant value
245         tokenDecimals = getDecimalsConstant(token);
246         if (tokenDecimals > 0) return tokenDecimals;
247 
248         // handle case where token decimals is not a declared decimal constant
249         tokenDecimals = decimals[token];
250         // moreover, very possible that old tokens have decimals 0
251         // these tokens will just have higher gas fees.
252         return (tokenDecimals > 0) ? tokenDecimals : token.decimals();
253     }
254 
255     function calcDestAmount(
256         IERC20Ext src,
257         IERC20Ext dest,
258         uint256 srcAmount,
259         uint256 rate
260     ) internal view returns (uint256) {
261         return calcDstQty(srcAmount, getDecimals(src), getDecimals(dest), rate);
262     }
263 
264     function calcSrcAmount(
265         IERC20Ext src,
266         IERC20Ext dest,
267         uint256 destAmount,
268         uint256 rate
269     ) internal view returns (uint256) {
270         return calcSrcQty(destAmount, getDecimals(src), getDecimals(dest), rate);
271     }
272 
273     function calcDstQty(
274         uint256 srcQty,
275         uint256 srcDecimals,
276         uint256 dstDecimals,
277         uint256 rate
278     ) internal pure returns (uint256) {
279         require(srcQty <= MAX_QTY, "srcQty > MAX_QTY");
280         require(rate <= MAX_RATE, "rate > MAX_RATE");
281 
282         if (dstDecimals >= srcDecimals) {
283             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
284             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
285         } else {
286             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
287             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
288         }
289     }
290 
291     function calcSrcQty(
292         uint256 dstQty,
293         uint256 srcDecimals,
294         uint256 dstDecimals,
295         uint256 rate
296     ) internal pure returns (uint256) {
297         require(dstQty <= MAX_QTY, "dstQty > MAX_QTY");
298         require(rate <= MAX_RATE, "rate > MAX_RATE");
299 
300         //source quantity is rounded up. to avoid dest quantity being too low.
301         uint256 numerator;
302         uint256 denominator;
303         if (srcDecimals >= dstDecimals) {
304             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
305             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
306             denominator = rate;
307         } else {
308             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
309             numerator = (PRECISION * dstQty);
310             denominator = (rate * (10**(dstDecimals - srcDecimals)));
311         }
312         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
313     }
314 
315     function calcRateFromQty(
316         uint256 srcAmount,
317         uint256 destAmount,
318         uint256 srcDecimals,
319         uint256 dstDecimals
320     ) internal pure returns (uint256) {
321         require(srcAmount <= MAX_QTY, "srcAmount > MAX_QTY");
322         require(destAmount <= MAX_QTY, "destAmount > MAX_QTY");
323 
324         if (dstDecimals >= srcDecimals) {
325             require((dstDecimals - srcDecimals) <= MAX_DECIMALS, "dst - src > MAX_DECIMALS");
326             return ((destAmount * PRECISION) / ((10**(dstDecimals - srcDecimals)) * srcAmount));
327         } else {
328             require((srcDecimals - dstDecimals) <= MAX_DECIMALS, "src - dst > MAX_DECIMALS");
329             return ((destAmount * PRECISION * (10**(srcDecimals - dstDecimals))) / srcAmount);
330         }
331     }
332 
333     /// @dev save storage access by declaring token decimal constants
334     /// @param token The token type
335     /// @return token decimals
336     function getDecimalsConstant(IERC20Ext token) internal pure returns (uint256) {
337         if (token == ETH_TOKEN_ADDRESS) {
338             return ETH_DECIMALS;
339         } else if (token == USDT_TOKEN_ADDRESS) {
340             return 6;
341         } else if (token == DAI_TOKEN_ADDRESS) {
342             return 18;
343         } else if (token == USDC_TOKEN_ADDRESS) {
344             return 6;
345         } else if (token == WBTC_TOKEN_ADDRESS) {
346             return 8;
347         } else if (token == KNC_TOKEN_ADDRESS) {
348             return 18;
349         } else {
350             return 0;
351         }
352     }
353 
354     function minOf(uint256 x, uint256 y) internal pure returns (uint256) {
355         return x > y ? y : x;
356     }
357 }
358 
359 // File: @openzeppelin/contracts/math/SafeMath.sol
360 
361 // SPDX-License-Identifier: MIT
362 
363 pragma solidity ^0.6.0;
364 
365 /**
366  * @dev Wrappers over Solidity's arithmetic operations with added overflow
367  * checks.
368  *
369  * Arithmetic operations in Solidity wrap on overflow. This can easily result
370  * in bugs, because programmers usually assume that an overflow raises an
371  * error, which is the standard behavior in high level programming languages.
372  * `SafeMath` restores this intuition by reverting the transaction when an
373  * operation overflows.
374  *
375  * Using this library instead of the unchecked operations eliminates an entire
376  * class of bugs, so it's recommended to use it always.
377  */
378 library SafeMath {
379     /**
380      * @dev Returns the addition of two unsigned integers, reverting on
381      * overflow.
382      *
383      * Counterpart to Solidity's `+` operator.
384      *
385      * Requirements:
386      *
387      * - Addition cannot overflow.
388      */
389     function add(uint256 a, uint256 b) internal pure returns (uint256) {
390         uint256 c = a + b;
391         require(c >= a, "SafeMath: addition overflow");
392 
393         return c;
394     }
395 
396     /**
397      * @dev Returns the subtraction of two unsigned integers, reverting on
398      * overflow (when the result is negative).
399      *
400      * Counterpart to Solidity's `-` operator.
401      *
402      * Requirements:
403      *
404      * - Subtraction cannot overflow.
405      */
406     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
407         return sub(a, b, "SafeMath: subtraction overflow");
408     }
409 
410     /**
411      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
412      * overflow (when the result is negative).
413      *
414      * Counterpart to Solidity's `-` operator.
415      *
416      * Requirements:
417      *
418      * - Subtraction cannot overflow.
419      */
420     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
421         require(b <= a, errorMessage);
422         uint256 c = a - b;
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the multiplication of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `*` operator.
432      *
433      * Requirements:
434      *
435      * - Multiplication cannot overflow.
436      */
437     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
438         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
439         // benefit is lost if 'b' is also tested.
440         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
441         if (a == 0) {
442             return 0;
443         }
444 
445         uint256 c = a * b;
446         require(c / a == b, "SafeMath: multiplication overflow");
447 
448         return c;
449     }
450 
451     /**
452      * @dev Returns the integer division of two unsigned integers. Reverts on
453      * division by zero. The result is rounded towards zero.
454      *
455      * Counterpart to Solidity's `/` operator. Note: this function uses a
456      * `revert` opcode (which leaves remaining gas untouched) while Solidity
457      * uses an invalid opcode to revert (consuming all remaining gas).
458      *
459      * Requirements:
460      *
461      * - The divisor cannot be zero.
462      */
463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
464         return div(a, b, "SafeMath: division by zero");
465     }
466 
467     /**
468      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
469      * division by zero. The result is rounded towards zero.
470      *
471      * Counterpart to Solidity's `/` operator. Note: this function uses a
472      * `revert` opcode (which leaves remaining gas untouched) while Solidity
473      * uses an invalid opcode to revert (consuming all remaining gas).
474      *
475      * Requirements:
476      *
477      * - The divisor cannot be zero.
478      */
479     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         require(b > 0, errorMessage);
481         uint256 c = a / b;
482         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
483 
484         return c;
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
489      * Reverts when dividing by zero.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      *
497      * - The divisor cannot be zero.
498      */
499     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
500         return mod(a, b, "SafeMath: modulo by zero");
501     }
502 
503     /**
504      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
505      * Reverts with custom message when dividing by zero.
506      *
507      * Counterpart to Solidity's `%` operator. This function uses a `revert`
508      * opcode (which leaves remaining gas untouched) while Solidity uses an
509      * invalid opcode to revert (consuming all remaining gas).
510      *
511      * Requirements:
512      *
513      * - The divisor cannot be zero.
514      */
515     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b != 0, errorMessage);
517         return a % b;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/utils/Address.sol
522 
523 // SPDX-License-Identifier: MIT
524 
525 pragma solidity ^0.6.2;
526 
527 /**
528  * @dev Collection of functions related to the address type
529  */
530 library Address {
531     /**
532      * @dev Returns true if `account` is a contract.
533      *
534      * [IMPORTANT]
535      * ====
536      * It is unsafe to assume that an address for which this function returns
537      * false is an externally-owned account (EOA) and not a contract.
538      *
539      * Among others, `isContract` will return false for the following
540      * types of addresses:
541      *
542      *  - an externally-owned account
543      *  - a contract in construction
544      *  - an address where a contract will be created
545      *  - an address where a contract lived, but was destroyed
546      * ====
547      */
548     function isContract(address account) internal view returns (bool) {
549         // This method relies in extcodesize, which returns 0 for contracts in
550         // construction, since the code is only stored at the end of the
551         // constructor execution.
552 
553         uint256 size;
554         // solhint-disable-next-line no-inline-assembly
555         assembly { size := extcodesize(account) }
556         return size > 0;
557     }
558 
559     /**
560      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
561      * `recipient`, forwarding all available gas and reverting on errors.
562      *
563      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
564      * of certain opcodes, possibly making contracts go over the 2300 gas limit
565      * imposed by `transfer`, making them unable to receive funds via
566      * `transfer`. {sendValue} removes this limitation.
567      *
568      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
569      *
570      * IMPORTANT: because control is transferred to `recipient`, care must be
571      * taken to not create reentrancy vulnerabilities. Consider using
572      * {ReentrancyGuard} or the
573      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
574      */
575     function sendValue(address payable recipient, uint256 amount) internal {
576         require(address(this).balance >= amount, "Address: insufficient balance");
577 
578         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
579         (bool success, ) = recipient.call{ value: amount }("");
580         require(success, "Address: unable to send value, recipient may have reverted");
581     }
582 
583     /**
584      * @dev Performs a Solidity function call using a low level `call`. A
585      * plain`call` is an unsafe replacement for a function call: use this
586      * function instead.
587      *
588      * If `target` reverts with a revert reason, it is bubbled up by this
589      * function (like regular Solidity function calls).
590      *
591      * Returns the raw returned data. To convert to the expected return value,
592      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
593      *
594      * Requirements:
595      *
596      * - `target` must be a contract.
597      * - calling `target` with `data` must not revert.
598      *
599      * _Available since v3.1._
600      */
601     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
602       return functionCall(target, data, "Address: low-level call failed");
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
607      * `errorMessage` as a fallback revert reason when `target` reverts.
608      *
609      * _Available since v3.1._
610      */
611     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
612         return _functionCallWithValue(target, data, 0, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but also transferring `value` wei to `target`.
618      *
619      * Requirements:
620      *
621      * - the calling contract must have an ETH balance of at least `value`.
622      * - the called Solidity function must be `payable`.
623      *
624      * _Available since v3.1._
625      */
626     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
627         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
632      * with `errorMessage` as a fallback revert reason when `target` reverts.
633      *
634      * _Available since v3.1._
635      */
636     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
637         require(address(this).balance >= value, "Address: insufficient balance for call");
638         return _functionCallWithValue(target, data, value, errorMessage);
639     }
640 
641     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
642         require(isContract(target), "Address: call to non-contract");
643 
644         // solhint-disable-next-line avoid-low-level-calls
645         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
646         if (success) {
647             return returndata;
648         } else {
649             // Look for revert reason and bubble it up if present
650             if (returndata.length > 0) {
651                 // The easiest way to bubble the revert reason is using memory via assembly
652 
653                 // solhint-disable-next-line no-inline-assembly
654                 assembly {
655                     let returndata_size := mload(returndata)
656                     revert(add(32, returndata), returndata_size)
657                 }
658             } else {
659                 revert(errorMessage);
660             }
661         }
662     }
663 }
664 
665 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
666 
667 // SPDX-License-Identifier: MIT
668 
669 pragma solidity ^0.6.0;
670 
671 
672 
673 
674 /**
675  * @title SafeERC20
676  * @dev Wrappers around ERC20 operations that throw on failure (when the token
677  * contract returns false). Tokens that return no value (and instead revert or
678  * throw on failure) are also supported, non-reverting calls are assumed to be
679  * successful.
680  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
681  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
682  */
683 library SafeERC20 {
684     using SafeMath for uint256;
685     using Address for address;
686 
687     function safeTransfer(IERC20 token, address to, uint256 value) internal {
688         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
689     }
690 
691     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
692         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
693     }
694 
695     /**
696      * @dev Deprecated. This function has issues similar to the ones found in
697      * {IERC20-approve}, and its usage is discouraged.
698      *
699      * Whenever possible, use {safeIncreaseAllowance} and
700      * {safeDecreaseAllowance} instead.
701      */
702     function safeApprove(IERC20 token, address spender, uint256 value) internal {
703         // safeApprove should only be called when setting an initial allowance,
704         // or when resetting it to zero. To increase and decrease it, use
705         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
706         // solhint-disable-next-line max-line-length
707         require((value == 0) || (token.allowance(address(this), spender) == 0),
708             "SafeERC20: approve from non-zero to non-zero allowance"
709         );
710         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
711     }
712 
713     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
714         uint256 newAllowance = token.allowance(address(this), spender).add(value);
715         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
716     }
717 
718     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
719         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
720         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
721     }
722 
723     /**
724      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
725      * on the return value: the return value is optional (but if data is returned, it must not be false).
726      * @param token The token targeted by the call.
727      * @param data The call data (encoded using abi.encode or one of its variants).
728      */
729     function _callOptionalReturn(IERC20 token, bytes memory data) private {
730         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
731         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
732         // the target address contains contract code and also asserts for success in the low-level call.
733 
734         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
735         if (returndata.length > 0) { // Return data is optional
736             // solhint-disable-next-line max-line-length
737             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
738         }
739     }
740 }
741 
742 // File: @kyber.network/utils-sc/contracts/PermissionGroups.sol
743 
744 pragma solidity 0.6.6;
745 
746 contract PermissionGroups {
747     uint256 internal constant MAX_GROUP_SIZE = 50;
748 
749     address public admin;
750     address public pendingAdmin;
751     mapping(address => bool) internal operators;
752     mapping(address => bool) internal alerters;
753     address[] internal operatorsGroup;
754     address[] internal alertersGroup;
755 
756     event AdminClaimed(address newAdmin, address previousAdmin);
757 
758     event TransferAdminPending(address pendingAdmin);
759 
760     event OperatorAdded(address newOperator, bool isAdd);
761 
762     event AlerterAdded(address newAlerter, bool isAdd);
763 
764     constructor(address _admin) public {
765         require(_admin != address(0), "admin 0");
766         admin = _admin;
767     }
768 
769     modifier onlyAdmin() {
770         require(msg.sender == admin, "only admin");
771         _;
772     }
773 
774     modifier onlyOperator() {
775         require(operators[msg.sender], "only operator");
776         _;
777     }
778 
779     modifier onlyAlerter() {
780         require(alerters[msg.sender], "only alerter");
781         _;
782     }
783 
784     function getOperators() external view returns (address[] memory) {
785         return operatorsGroup;
786     }
787 
788     function getAlerters() external view returns (address[] memory) {
789         return alertersGroup;
790     }
791 
792     /**
793      * @dev Allows the current admin to set the pendingAdmin address.
794      * @param newAdmin The address to transfer ownership to.
795      */
796     function transferAdmin(address newAdmin) public onlyAdmin {
797         require(newAdmin != address(0), "new admin 0");
798         emit TransferAdminPending(newAdmin);
799         pendingAdmin = newAdmin;
800     }
801 
802     /**
803      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
804      * @param newAdmin The address to transfer ownership to.
805      */
806     function transferAdminQuickly(address newAdmin) public onlyAdmin {
807         require(newAdmin != address(0), "admin 0");
808         emit TransferAdminPending(newAdmin);
809         emit AdminClaimed(newAdmin, admin);
810         admin = newAdmin;
811     }
812 
813     /**
814      * @dev Allows the pendingAdmin address to finalize the change admin process.
815      */
816     function claimAdmin() public {
817         require(pendingAdmin == msg.sender, "not pending");
818         emit AdminClaimed(pendingAdmin, admin);
819         admin = pendingAdmin;
820         pendingAdmin = address(0);
821     }
822 
823     function addAlerter(address newAlerter) public onlyAdmin {
824         require(!alerters[newAlerter], "alerter exists"); // prevent duplicates.
825         require(alertersGroup.length < MAX_GROUP_SIZE, "max alerters");
826 
827         emit AlerterAdded(newAlerter, true);
828         alerters[newAlerter] = true;
829         alertersGroup.push(newAlerter);
830     }
831 
832     function removeAlerter(address alerter) public onlyAdmin {
833         require(alerters[alerter], "not alerter");
834         alerters[alerter] = false;
835 
836         for (uint256 i = 0; i < alertersGroup.length; ++i) {
837             if (alertersGroup[i] == alerter) {
838                 alertersGroup[i] = alertersGroup[alertersGroup.length - 1];
839                 alertersGroup.pop();
840                 emit AlerterAdded(alerter, false);
841                 break;
842             }
843         }
844     }
845 
846     function addOperator(address newOperator) public onlyAdmin {
847         require(!operators[newOperator], "operator exists"); // prevent duplicates.
848         require(operatorsGroup.length < MAX_GROUP_SIZE, "max operators");
849 
850         emit OperatorAdded(newOperator, true);
851         operators[newOperator] = true;
852         operatorsGroup.push(newOperator);
853     }
854 
855     function removeOperator(address operator) public onlyAdmin {
856         require(operators[operator], "not operator");
857         operators[operator] = false;
858 
859         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
860             if (operatorsGroup[i] == operator) {
861                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
862                 operatorsGroup.pop();
863                 emit OperatorAdded(operator, false);
864                 break;
865             }
866         }
867     }
868 }
869 
870 // File: @kyber.network/utils-sc/contracts/Withdrawable.sol
871 
872 pragma solidity 0.6.6;
873 
874 
875 
876 
877 contract Withdrawable is PermissionGroups {
878     using SafeERC20 for IERC20Ext;
879 
880     event TokenWithdraw(IERC20Ext token, uint256 amount, address sendTo);
881     event EtherWithdraw(uint256 amount, address sendTo);
882 
883     constructor(address _admin) public PermissionGroups(_admin) {}
884 
885     /**
886      * @dev Withdraw all IERC20Ext compatible tokens
887      * @param token IERC20Ext The address of the token contract
888      */
889     function withdrawToken(
890         IERC20Ext token,
891         uint256 amount,
892         address sendTo
893     ) external onlyAdmin {
894         token.safeTransfer(sendTo, amount);
895         emit TokenWithdraw(token, amount, sendTo);
896     }
897 
898     /**
899      * @dev Withdraw Ethers
900      */
901     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
902         (bool success, ) = sendTo.call{value: amount}("");
903         require(success, "withdraw failed");
904         emit EtherWithdraw(amount, sendTo);
905     }
906 }
907 
908 // File: contracts/sol6/KyberFprReserveV2.sol
909 
910 // SPDX-License-Identifier: MIT
911 pragma solidity 0.6.6;
912 
913 
914 
915 
916 
917 
918 
919 
920 /// @title KyberFprReserve version 2
921 /// Allow Reserve to work work with either weth or eth.
922 /// for working with weth should specify external address to hold weth.
923 /// Allow Reserve to set maxGasPriceWei to trade with
924 contract KyberFprReserveV2 is IKyberReserve, Utils, Withdrawable {
925     using SafeERC20 for IERC20Ext;
926     using SafeMath for uint256;
927 
928     mapping(bytes32 => bool) public approvedWithdrawAddresses; // sha3(token,address)=>bool
929     mapping(address => address) public tokenWallet;
930 
931     struct ConfigData {
932         bool tradeEnabled;
933         bool doRateValidation; // whether to do rate validation in trade func
934         uint128 maxGasPriceWei;
935     }
936 
937     address public kyberNetwork;
938     ConfigData internal configData;
939 
940     IConversionRates public conversionRatesContract;
941     IKyberSanity public sanityRatesContract;
942     IWeth public weth;
943 
944     event DepositToken(IERC20Ext indexed token, uint256 amount);
945     event TradeExecute(
946         address indexed origin,
947         IERC20Ext indexed src,
948         uint256 srcAmount,
949         IERC20Ext indexed destToken,
950         uint256 destAmount,
951         address payable destAddress
952     );
953     event TradeEnabled(bool enable);
954     event MaxGasPriceUpdated(uint128 newMaxGasPrice);
955     event DoRateValidationUpdated(bool doRateValidation);
956     event WithdrawAddressApproved(IERC20Ext indexed token, address indexed addr, bool approve);
957     event NewTokenWallet(IERC20Ext indexed token, address indexed wallet);
958     event WithdrawFunds(IERC20Ext indexed token, uint256 amount, address indexed destination);
959     event SetKyberNetworkAddress(address indexed network);
960     event SetConversionRateAddress(IConversionRates indexed rate);
961     event SetWethAddress(IWeth indexed weth);
962     event SetSanityRateAddress(IKyberSanity indexed sanity);
963 
964     constructor(
965         address _kyberNetwork,
966         IConversionRates _ratesContract,
967         IWeth _weth,
968         uint128 _maxGasPriceWei,
969         bool _doRateValidation,
970         address _admin
971     ) public Withdrawable(_admin) {
972         require(_kyberNetwork != address(0), "kyberNetwork 0");
973         require(_ratesContract != IConversionRates(0), "ratesContract 0");
974         require(_weth != IWeth(0), "weth 0");
975         kyberNetwork = _kyberNetwork;
976         conversionRatesContract = _ratesContract;
977         weth = _weth;
978         configData = ConfigData({
979             tradeEnabled: true,
980             maxGasPriceWei: _maxGasPriceWei,
981             doRateValidation: _doRateValidation
982         });
983     }
984 
985     receive() external payable {
986         emit DepositToken(ETH_TOKEN_ADDRESS, msg.value);
987     }
988 
989     function trade(
990         IERC20Ext srcToken,
991         uint256 srcAmount,
992         IERC20Ext destToken,
993         address payable destAddress,
994         uint256 conversionRate,
995         bool /* validate */
996     ) external override payable returns (bool) {
997         require(msg.sender == kyberNetwork, "wrong sender");
998         ConfigData memory data = configData;
999         require(data.tradeEnabled, "trade not enable");
1000         require(tx.gasprice <= uint256(data.maxGasPriceWei), "gas price too high");
1001 
1002         doTrade(
1003             srcToken,
1004             srcAmount,
1005             destToken,
1006             destAddress,
1007             conversionRate,
1008             data.doRateValidation
1009         );
1010 
1011         return true;
1012     }
1013 
1014     function enableTrade() external onlyAdmin {
1015         configData.tradeEnabled = true;
1016         emit TradeEnabled(true);
1017     }
1018 
1019     function disableTrade() external onlyAlerter {
1020         configData.tradeEnabled = false;
1021         emit TradeEnabled(false);
1022     }
1023 
1024     function setMaxGasPrice(uint128 newMaxGasPrice) external onlyOperator {
1025         configData.maxGasPriceWei = newMaxGasPrice;
1026         emit MaxGasPriceUpdated(newMaxGasPrice);
1027     }
1028 
1029     function setDoRateValidation(bool _doRateValidation) external onlyAdmin {
1030         configData.doRateValidation = _doRateValidation;
1031         emit DoRateValidationUpdated(_doRateValidation);
1032     }
1033 
1034     function approveWithdrawAddress(
1035         IERC20Ext token,
1036         address addr,
1037         bool approve
1038     ) external onlyAdmin {
1039         approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), addr))] = approve;
1040         getSetDecimals(token);
1041         emit WithdrawAddressApproved(token, addr, approve);
1042     }
1043 
1044     /// @dev allow set tokenWallet[token] back to 0x0 address
1045     /// @dev in case of using weth from external wallet, must call set token wallet for weth
1046     ///      tokenWallet for weth must be different from this reserve address
1047     function setTokenWallet(IERC20Ext token, address wallet) external onlyAdmin {
1048         tokenWallet[address(token)] = wallet;
1049         getSetDecimals(token);
1050         emit NewTokenWallet(token, wallet);
1051     }
1052 
1053     /// @dev withdraw amount of token to an approved destination
1054     ///      if reserve is using weth instead of eth, should call withdraw weth
1055     /// @param token token to withdraw
1056     /// @param amount amount to withdraw
1057     /// @param destination address to transfer fund to
1058     function withdraw(
1059         IERC20Ext token,
1060         uint256 amount,
1061         address destination
1062     ) external onlyOperator {
1063         require(
1064             approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), destination))],
1065             "destination is not approved"
1066         );
1067 
1068         if (token == ETH_TOKEN_ADDRESS) {
1069             (bool success, ) = destination.call{value: amount}("");
1070             require(success, "withdraw eth failed");
1071         } else {
1072             address wallet = getTokenWallet(token);
1073             if (wallet == address(this)) {
1074                 token.safeTransfer(destination, amount);
1075             } else {
1076                 token.safeTransferFrom(wallet, destination, amount);
1077             }
1078         }
1079 
1080         emit WithdrawFunds(token, amount, destination);
1081     }
1082 
1083     function setKyberNetwork(address _newNetwork) external onlyAdmin {
1084         require(_newNetwork != address(0), "kyberNetwork 0");
1085         kyberNetwork = _newNetwork;
1086         emit SetKyberNetworkAddress(_newNetwork);
1087     }
1088 
1089     function setConversionRate(IConversionRates _newConversionRate) external onlyAdmin {
1090         require(_newConversionRate != IConversionRates(0), "conversionRates 0");
1091         conversionRatesContract = _newConversionRate;
1092         emit SetConversionRateAddress(_newConversionRate);
1093     }
1094 
1095     /// @dev weth is unlikely to be changed, but added this function to keep the flexibilty
1096     function setWeth(IWeth _newWeth) external onlyAdmin {
1097         require(_newWeth != IWeth(0), "weth 0");
1098         weth = _newWeth;
1099         emit SetWethAddress(_newWeth);
1100     }
1101 
1102     /// @dev sanity rate can be set to 0x0 address to disable sanity rate check
1103     function setSanityRate(IKyberSanity _newSanity) external onlyAdmin {
1104         sanityRatesContract = _newSanity;
1105         emit SetSanityRateAddress(_newSanity);
1106     }
1107 
1108     function getConversionRate(
1109         IERC20Ext src,
1110         IERC20Ext dest,
1111         uint256 srcQty,
1112         uint256 blockNumber
1113     ) external override view returns (uint256) {
1114         ConfigData memory data = configData;
1115         if (!data.tradeEnabled) return 0;
1116         if (tx.gasprice > uint256(data.maxGasPriceWei)) return 0;
1117         if (srcQty == 0) return 0;
1118 
1119         IERC20Ext token;
1120         bool isBuy;
1121 
1122         if (ETH_TOKEN_ADDRESS == src) {
1123             isBuy = true;
1124             token = dest;
1125         } else if (ETH_TOKEN_ADDRESS == dest) {
1126             isBuy = false;
1127             token = src;
1128         } else {
1129             return 0; // pair is not listed
1130         }
1131 
1132         uint256 rate;
1133         try conversionRatesContract.getRate(token, blockNumber, isBuy, srcQty) returns(uint256 r) {
1134             rate = r;
1135         } catch {
1136             return 0;
1137         }
1138         uint256 destQty = calcDestAmount(src, dest, srcQty, rate);
1139 
1140         if (getBalance(dest) < destQty) return 0;
1141 
1142         if (sanityRatesContract != IKyberSanity(0)) {
1143             uint256 sanityRate = sanityRatesContract.getSanityRate(src, dest);
1144             if (rate > sanityRate) return 0;
1145         }
1146 
1147         return rate;
1148     }
1149 
1150     function isAddressApprovedForWithdrawal(IERC20Ext token, address addr)
1151         external
1152         view
1153         returns (bool)
1154     {
1155         return approvedWithdrawAddresses[keccak256(abi.encodePacked(address(token), addr))];
1156     }
1157 
1158     function tradeEnabled() external view returns (bool) {
1159         return configData.tradeEnabled;
1160     }
1161 
1162     function maxGasPriceWei() external view returns (uint128) {
1163         return configData.maxGasPriceWei;
1164     }
1165 
1166     function doRateValidation() external view returns (bool) {
1167         return configData.doRateValidation;
1168     }
1169 
1170     /// @dev return available balance of a token that reserve can use
1171     ///      if using weth, call getBalance(eth) will return weth balance
1172     ///      if using wallet for token, will return min of balance and allowance
1173     /// @param token token to get available balance that reserve can use
1174     function getBalance(IERC20Ext token) public view returns (uint256) {
1175         address wallet = getTokenWallet(token);
1176         IERC20Ext usingToken;
1177 
1178         if (token == ETH_TOKEN_ADDRESS) {
1179             if (wallet == address(this)) {
1180                 // reserve should be using eth instead of weth
1181                 return address(this).balance;
1182             }
1183             // reserve is using weth instead of eth
1184             usingToken = weth;
1185         } else {
1186             if (wallet == address(this)) {
1187                 // not set token wallet or reserve is the token wallet, no need to check allowance
1188                 return token.balanceOf(address(this));
1189             }
1190             usingToken = token;
1191         }
1192 
1193         uint256 balanceOfWallet = usingToken.balanceOf(wallet);
1194         uint256 allowanceOfWallet = usingToken.allowance(wallet, address(this));
1195 
1196         return minOf(balanceOfWallet, allowanceOfWallet);
1197     }
1198 
1199     /// @dev return wallet that holds the token
1200     ///      if token is ETH, check tokenWallet of WETH instead
1201     ///      if wallet is 0x0, consider as this reserve address
1202     function getTokenWallet(IERC20Ext token) public view returns (address wallet) {
1203         wallet = (token == ETH_TOKEN_ADDRESS)
1204             ? tokenWallet[address(weth)]
1205             : tokenWallet[address(token)];
1206         if (wallet == address(0)) {
1207             wallet = address(this);
1208         }
1209     }
1210 
1211     /// @dev do a trade, re-validate the conversion rate, remove trust assumption with network
1212     /// @param srcToken Src token
1213     /// @param srcAmount Amount of src token
1214     /// @param destToken Destination token
1215     /// @param destAddress Destination address to send tokens to
1216     /// @param validateRate re-validate rate or not
1217     function doTrade(
1218         IERC20Ext srcToken,
1219         uint256 srcAmount,
1220         IERC20Ext destToken,
1221         address payable destAddress,
1222         uint256 conversionRate,
1223         bool validateRate
1224     ) internal {
1225         require(conversionRate > 0, "rate is 0");
1226 
1227         bool isBuy = srcToken == ETH_TOKEN_ADDRESS;
1228         if (isBuy) {
1229             require(msg.value == srcAmount, "wrong msg value");
1230         } else {
1231             require(msg.value == 0, "bad msg value");
1232         }
1233 
1234         if (validateRate) {
1235             uint256 rate = conversionRatesContract.getRate(
1236                 isBuy ? destToken : srcToken,
1237                 block.number,
1238                 isBuy,
1239                 srcAmount
1240             );
1241             // re-validate conversion rate
1242             require(rate >= conversionRate, "reserve rate lower then network requested rate");
1243             if (sanityRatesContract != IKyberSanity(0)) {
1244                 // sanity rate check
1245                 uint256 sanityRate = sanityRatesContract.getSanityRate(srcToken, destToken);
1246                 require(rate <= sanityRate, "rate should not be greater than sanity rate" );
1247             }
1248         }
1249 
1250         uint256 destAmount = calcDestAmount(srcToken, destToken, srcAmount, conversionRate);
1251         require(destAmount > 0, "dest amount is 0");
1252 
1253         address srcTokenWallet = getTokenWallet(srcToken);
1254         address destTokenWallet = getTokenWallet(destToken);
1255 
1256         if (isBuy) {
1257             // add to imbalance
1258             conversionRatesContract.recordImbalance(
1259                 destToken,
1260                 int256(destAmount),
1261                 0,
1262                 block.number
1263             );
1264             // if reserve is using weth, convert eth to weth and transfer weth to its' tokenWallet
1265             if (srcTokenWallet != address(this)) {
1266                 weth.deposit{value: msg.value}();
1267                 IERC20Ext(weth).safeTransfer(srcTokenWallet, msg.value);
1268             }
1269             // transfer dest token from tokenWallet to destAddress
1270             if (destTokenWallet == address(this)) {
1271                 destToken.safeTransfer(destAddress, destAmount);
1272             } else {
1273                 destToken.safeTransferFrom(destTokenWallet, destAddress, destAmount);
1274             }
1275         } else {
1276             // add to imbalance
1277             conversionRatesContract.recordImbalance(
1278                 srcToken,
1279                 -1 * int256(srcAmount),
1280                 0,
1281                 block.number
1282             );
1283             // collect src token from sender
1284             srcToken.safeTransferFrom(msg.sender, srcTokenWallet, srcAmount);
1285             // if reserve is using weth, reserve needs to collect weth from tokenWallet,
1286             // then convert it to eth
1287             if (destTokenWallet != address(this)) {
1288                 IERC20Ext(weth).safeTransferFrom(destTokenWallet, address(this), destAmount);
1289                 weth.withdraw(destAmount);
1290             }
1291             // transfer eth to destAddress
1292             (bool success, ) = destAddress.call{value: destAmount}("");
1293             require(success, "transfer eth from reserve to destAddress failed");
1294         }
1295 
1296         emit TradeExecute(msg.sender, srcToken, srcAmount, destToken, destAmount, destAddress);
1297     }
1298 }