1 // SPDX-License-Identifier: MIT
2 /*
3 This is a Stacker.vc FarmTreasury version 1 contract. It deploys a rebase token where it rebases to be equivalent to it's underlying token. 1 stackUSDT = 1 USDT.
4 The underlying assets are used to farm on different smart contract and produce yield via the ever-expanding DeFi ecosystem.
5 
6 THANKS! To Lido DAO for the inspiration in more ways than one, but especially for a lot of the code here. 
7 If you haven't already, stake your ETH for ETH2.0 with Lido.fi!
8 
9 Also thanks for Aragon for hosting our Stacker Ventures DAO, and for more inspiration!
10 */
11 
12 pragma solidity ^0.6.11;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 /**
36  * @dev Collection of functions related to the address type
37  */
38 library Address {
39     /**
40      * @dev Returns true if `account` is a contract.
41      *
42      * [IMPORTANT]
43      * ====
44      * It is unsafe to assume that an address for which this function returns
45      * false is an externally-owned account (EOA) and not a contract.
46      *
47      * Among others, `isContract` will return false for the following
48      * types of addresses:
49      *
50      *  - an externally-owned account
51      *  - a contract in construction
52      *  - an address where a contract will be created
53      *  - an address where a contract lived, but was destroyed
54      * ====
55      */
56     function isContract(address account) internal view returns (bool) {
57         // This method relies on extcodesize, which returns 0 for contracts in
58         // construction, since the code is only stored at the end of the
59         // constructor execution.
60 
61         uint256 size;
62         // solhint-disable-next-line no-inline-assembly
63         assembly { size := extcodesize(account) }
64         return size > 0;
65     }
66 
67     /**
68      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
69      * `recipient`, forwarding all available gas and reverting on errors.
70      *
71      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
72      * of certain opcodes, possibly making contracts go over the 2300 gas limit
73      * imposed by `transfer`, making them unable to receive funds via
74      * `transfer`. {sendValue} removes this limitation.
75      *
76      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
77      *
78      * IMPORTANT: because control is transferred to `recipient`, care must be
79      * taken to not create reentrancy vulnerabilities. Consider using
80      * {ReentrancyGuard} or the
81      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
82      */
83     function sendValue(address payable recipient, uint256 amount) internal {
84         require(address(this).balance >= amount, "Address: insufficient balance");
85 
86         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
87         (bool success, ) = recipient.call{ value: amount }("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90 
91     /**
92      * @dev Performs a Solidity function call using a low level `call`. A
93      * plain`call` is an unsafe replacement for a function call: use this
94      * function instead.
95      *
96      * If `target` reverts with a revert reason, it is bubbled up by this
97      * function (like regular Solidity function calls).
98      *
99      * Returns the raw returned data. To convert to the expected return value,
100      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
101      *
102      * Requirements:
103      *
104      * - `target` must be a contract.
105      * - calling `target` with `data` must not revert.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
110       return functionCall(target, data, "Address: low-level call failed");
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
115      * `errorMessage` as a fallback revert reason when `target` reverts.
116      *
117      * _Available since v3.1._
118      */
119     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
120         return functionCallWithValue(target, data, 0, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but also transferring `value` wei to `target`.
126      *
127      * Requirements:
128      *
129      * - the calling contract must have an ETH balance of at least `value`.
130      * - the called Solidity function must be `payable`.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
135         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
140      * with `errorMessage` as a fallback revert reason when `target` reverts.
141      *
142      * _Available since v3.1._
143      */
144     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
145         require(address(this).balance >= value, "Address: insufficient balance for call");
146         require(isContract(target), "Address: call to non-contract");
147 
148         // solhint-disable-next-line avoid-low-level-calls
149         (bool success, bytes memory returndata) = target.call{ value: value }(data);
150         return _verifyCallResult(success, returndata, errorMessage);
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
160         return functionStaticCall(target, data, "Address: low-level static call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
165      * but performing a static call.
166      *
167      * _Available since v3.3._
168      */
169     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
170         require(isContract(target), "Address: static call to non-contract");
171 
172         // solhint-disable-next-line avoid-low-level-calls
173         (bool success, bytes memory returndata) = target.staticcall(data);
174         return _verifyCallResult(success, returndata, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
184         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
185     }
186 
187     /**
188      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
189      * but performing a delegate call.
190      *
191      * _Available since v3.4._
192      */
193     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
194         require(isContract(target), "Address: delegate call to non-contract");
195 
196         // solhint-disable-next-line avoid-low-level-calls
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return _verifyCallResult(success, returndata, errorMessage);
199     }
200 
201     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
202         if (success) {
203             return returndata;
204         } else {
205             // Look for revert reason and bubble it up if present
206             if (returndata.length > 0) {
207                 // The easiest way to bubble the revert reason is using memory via assembly
208 
209                 // solhint-disable-next-line no-inline-assembly
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 /**
222  * @dev Contract module that helps prevent reentrant calls to a function.
223  *
224  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
225  * available, which can be applied to functions to make sure there are no nested
226  * (reentrant) calls to them.
227  *
228  * Note that because there is a single `nonReentrant` guard, functions marked as
229  * `nonReentrant` may not call one another. This can be worked around by making
230  * those functions `private`, and then adding `external` `nonReentrant` entry
231  * points to them.
232  *
233  * TIP: If you would like to learn more about reentrancy and alternative ways
234  * to protect against it, check out our blog post
235  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
236  */
237 abstract contract ReentrancyGuard {
238     // Booleans are more expensive than uint256 or any type that takes up a full
239     // word because each write operation emits an extra SLOAD to first read the
240     // slot's contents, replace the bits taken up by the boolean, and then write
241     // back. This is the compiler's defense against contract upgrades and
242     // pointer aliasing, and it cannot be disabled.
243 
244     // The values being non-zero value makes deployment a bit more expensive,
245     // but in exchange the refund on every call to nonReentrant will be lower in
246     // amount. Since refunds are capped to a percentage of the total
247     // transaction's gas, it is best to keep them low in cases like this one, to
248     // increase the likelihood of the full refund coming into effect.
249     uint256 private constant _NOT_ENTERED = 1;
250     uint256 private constant _ENTERED = 2;
251 
252     uint256 private _status;
253 
254     constructor () internal {
255         _status = _NOT_ENTERED;
256     }
257 
258     /**
259      * @dev Prevents a contract from calling itself, directly or indirectly.
260      * Calling a `nonReentrant` function from another `nonReentrant`
261      * function is not supported. It is possible to prevent this from happening
262      * by making the `nonReentrant` function external, and make it call a
263      * `private` function that does the actual work.
264      */
265     modifier nonReentrant() {
266         // On the first call to nonReentrant, _notEntered will be true
267         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
268 
269         // Any calls to nonReentrant after this point will fail
270         _status = _ENTERED;
271 
272         _;
273 
274         // By storing the original value once again, a refund is triggered (see
275         // https://eips.ethereum.org/EIPS/eip-2200)
276         _status = _NOT_ENTERED;
277     }
278 }
279 
280 /**
281  * @dev Wrappers over Solidity's arithmetic operations with added overflow
282  * checks.
283  *
284  * Arithmetic operations in Solidity wrap on overflow. This can easily result
285  * in bugs, because programmers usually assume that an overflow raises an
286  * error, which is the standard behavior in high level programming languages.
287  * `SafeMath` restores this intuition by reverting the transaction when an
288  * operation overflows.
289  *
290  * Using this library instead of the unchecked operations eliminates an entire
291  * class of bugs, so it's recommended to use it always.
292  */
293 library SafeMath {
294     /**
295      * @dev Returns the addition of two unsigned integers, with an overflow flag.
296      *
297      * _Available since v3.4._
298      */
299     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
300         uint256 c = a + b;
301         if (c < a) return (false, 0);
302         return (true, c);
303     }
304 
305     /**
306      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
307      *
308      * _Available since v3.4._
309      */
310     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
311         if (b > a) return (false, 0);
312         return (true, a - b);
313     }
314 
315     /**
316      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
317      *
318      * _Available since v3.4._
319      */
320     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
321         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
322         // benefit is lost if 'b' is also tested.
323         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
324         if (a == 0) return (true, 0);
325         uint256 c = a * b;
326         if (c / a != b) return (false, 0);
327         return (true, c);
328     }
329 
330     /**
331      * @dev Returns the division of two unsigned integers, with a division by zero flag.
332      *
333      * _Available since v3.4._
334      */
335     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
336         if (b == 0) return (false, 0);
337         return (true, a / b);
338     }
339 
340     /**
341      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
342      *
343      * _Available since v3.4._
344      */
345     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
346         if (b == 0) return (false, 0);
347         return (true, a % b);
348     }
349 
350     /**
351      * @dev Returns the addition of two unsigned integers, reverting on
352      * overflow.
353      *
354      * Counterpart to Solidity's `+` operator.
355      *
356      * Requirements:
357      *
358      * - Addition cannot overflow.
359      */
360     function add(uint256 a, uint256 b) internal pure returns (uint256) {
361         uint256 c = a + b;
362         require(c >= a, "SafeMath: addition overflow");
363         return c;
364     }
365 
366     /**
367      * @dev Returns the subtraction of two unsigned integers, reverting on
368      * overflow (when the result is negative).
369      *
370      * Counterpart to Solidity's `-` operator.
371      *
372      * Requirements:
373      *
374      * - Subtraction cannot overflow.
375      */
376     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
377         require(b <= a, "SafeMath: subtraction overflow");
378         return a - b;
379     }
380 
381     /**
382      * @dev Returns the multiplication of two unsigned integers, reverting on
383      * overflow.
384      *
385      * Counterpart to Solidity's `*` operator.
386      *
387      * Requirements:
388      *
389      * - Multiplication cannot overflow.
390      */
391     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
392         if (a == 0) return 0;
393         uint256 c = a * b;
394         require(c / a == b, "SafeMath: multiplication overflow");
395         return c;
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers, reverting on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator. Note: this function uses a
403      * `revert` opcode (which leaves remaining gas untouched) while Solidity
404      * uses an invalid opcode to revert (consuming all remaining gas).
405      *
406      * Requirements:
407      *
408      * - The divisor cannot be zero.
409      */
410     function div(uint256 a, uint256 b) internal pure returns (uint256) {
411         require(b > 0, "SafeMath: division by zero");
412         return a / b;
413     }
414 
415     /**
416      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
417      * reverting when dividing by zero.
418      *
419      * Counterpart to Solidity's `%` operator. This function uses a `revert`
420      * opcode (which leaves remaining gas untouched) while Solidity uses an
421      * invalid opcode to revert (consuming all remaining gas).
422      *
423      * Requirements:
424      *
425      * - The divisor cannot be zero.
426      */
427     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
428         require(b > 0, "SafeMath: modulo by zero");
429         return a % b;
430     }
431 
432     /**
433      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
434      * overflow (when the result is negative).
435      *
436      * CAUTION: This function is deprecated because it requires allocating memory for the error
437      * message unnecessarily. For custom revert reasons use {trySub}.
438      *
439      * Counterpart to Solidity's `-` operator.
440      *
441      * Requirements:
442      *
443      * - Subtraction cannot overflow.
444      */
445     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
446         require(b <= a, errorMessage);
447         return a - b;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
452      * division by zero. The result is rounded towards zero.
453      *
454      * CAUTION: This function is deprecated because it requires allocating memory for the error
455      * message unnecessarily. For custom revert reasons use {tryDiv}.
456      *
457      * Counterpart to Solidity's `/` operator. Note: this function uses a
458      * `revert` opcode (which leaves remaining gas untouched) while Solidity
459      * uses an invalid opcode to revert (consuming all remaining gas).
460      *
461      * Requirements:
462      *
463      * - The divisor cannot be zero.
464      */
465     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
466         require(b > 0, errorMessage);
467         return a / b;
468     }
469 
470     /**
471      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
472      * reverting with custom message when dividing by zero.
473      *
474      * CAUTION: This function is deprecated because it requires allocating memory for the error
475      * message unnecessarily. For custom revert reasons use {tryMod}.
476      *
477      * Counterpart to Solidity's `%` operator. This function uses a `revert`
478      * opcode (which leaves remaining gas untouched) while Solidity uses an
479      * invalid opcode to revert (consuming all remaining gas).
480      *
481      * Requirements:
482      *
483      * - The divisor cannot be zero.
484      */
485     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
486         require(b > 0, errorMessage);
487         return a % b;
488     }
489 }
490 
491 /**
492  * @dev Interface of the ERC20 standard as defined in the EIP.
493  */
494 interface IERC20 {
495     /**
496      * @dev Returns the amount of tokens in existence.
497      */
498     function totalSupply() external view returns (uint256);
499 
500     /**
501      * @dev Returns the amount of tokens owned by `account`.
502      */
503     function balanceOf(address account) external view returns (uint256);
504 
505     /**
506      * @dev Moves `amount` tokens from the caller's account to `recipient`.
507      *
508      * Returns a boolean value indicating whether the operation succeeded.
509      *
510      * Emits a {Transfer} event.
511      */
512     function transfer(address recipient, uint256 amount) external returns (bool);
513 
514     /**
515      * @dev Returns the remaining number of tokens that `spender` will be
516      * allowed to spend on behalf of `owner` through {transferFrom}. This is
517      * zero by default.
518      *
519      * This value changes when {approve} or {transferFrom} are called.
520      */
521     function allowance(address owner, address spender) external view returns (uint256);
522 
523     /**
524      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
525      *
526      * Returns a boolean value indicating whether the operation succeeded.
527      *
528      * IMPORTANT: Beware that changing an allowance with this method brings the risk
529      * that someone may use both the old and the new allowance by unfortunate
530      * transaction ordering. One possible solution to mitigate this race
531      * condition is to first reduce the spender's allowance to 0 and set the
532      * desired value afterwards:
533      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
534      *
535      * Emits an {Approval} event.
536      */
537     function approve(address spender, uint256 amount) external returns (bool);
538 
539     /**
540      * @dev Moves `amount` tokens from `sender` to `recipient` using the
541      * allowance mechanism. `amount` is then deducted from the caller's
542      * allowance.
543      *
544      * Returns a boolean value indicating whether the operation succeeded.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
549 
550     /**
551      * @dev Emitted when `value` tokens are moved from one account (`from`) to
552      * another (`to`).
553      *
554      * Note that `value` may be zero.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 value);
557 
558     /**
559      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
560      * a call to {approve}. `value` is the new allowance.
561      */
562     event Approval(address indexed owner, address indexed spender, uint256 value);
563 }
564 
565 /**
566  * @title SafeERC20
567  * @dev Wrappers around ERC20 operations that throw on failure (when the token
568  * contract returns false). Tokens that return no value (and instead revert or
569  * throw on failure) are also supported, non-reverting calls are assumed to be
570  * successful.
571  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
572  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
573  */
574 library SafeERC20 {
575     using SafeMath for uint256;
576     using Address for address;
577 
578     function safeTransfer(IERC20 token, address to, uint256 value) internal {
579         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
580     }
581 
582     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
583         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
584     }
585 
586     /**
587      * @dev Deprecated. This function has issues similar to the ones found in
588      * {IERC20-approve}, and its usage is discouraged.
589      *
590      * Whenever possible, use {safeIncreaseAllowance} and
591      * {safeDecreaseAllowance} instead.
592      */
593     function safeApprove(IERC20 token, address spender, uint256 value) internal {
594         // safeApprove should only be called when setting an initial allowance,
595         // or when resetting it to zero. To increase and decrease it, use
596         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
597         // solhint-disable-next-line max-line-length
598         require((value == 0) || (token.allowance(address(this), spender) == 0),
599             "SafeERC20: approve from non-zero to non-zero allowance"
600         );
601         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
602     }
603 
604     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
605         uint256 newAllowance = token.allowance(address(this), spender).add(value);
606         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
607     }
608 
609     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
610         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
611         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
612     }
613 
614     /**
615      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
616      * on the return value: the return value is optional (but if data is returned, it must not be false).
617      * @param token The token targeted by the call.
618      * @param data The call data (encoded using abi.encode or one of its variants).
619      */
620     function _callOptionalReturn(IERC20 token, bytes memory data) private {
621         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
622         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
623         // the target address contains contract code and also asserts for success in the low-level call.
624 
625         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
626         if (returndata.length > 0) { // Return data is optional
627             // solhint-disable-next-line max-line-length
628             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
629         }
630     }
631 }
632 
633 abstract contract FarmTokenV1 is IERC20 {
634     using SafeMath for uint256;
635     using Address for address;
636 
637     // shares are how a users balance is generated. For rebase tokens, balances are always generated at runtime, while shares stay constant.
638     // shares is your proportion of the total pool of invested UnderlyingToken
639     // shares are like a Compound.finance cToken, while our token balances are like an Aave aToken.
640     mapping(address => uint256) private shares;
641     mapping(address => mapping (address => uint256)) private allowances;
642 
643     uint256 public totalShares;
644 
645     string public name;
646     string public symbol;
647     string public underlying;
648     address public underlyingContract;
649 
650     uint8 public decimals;
651 
652     event Transfer(address indexed from, address indexed to, uint256 value);
653     event Approval(address indexed owner, address indexed spender, uint256 value);
654 
655     constructor(string memory _name, uint8 _decimals, address _underlyingContract) public {
656         name = string(abi.encodePacked(abi.encodePacked("Stacker Ventures ", _name), " v1"));
657         symbol = string(abi.encodePacked("stack", _name));
658         underlying = _name;
659 
660         decimals = _decimals;
661 
662         underlyingContract = _underlyingContract;
663     }
664 
665     // 1 stackToken = 1 underlying token
666     function totalSupply() external override view returns (uint256){
667         return _getTotalUnderlying();
668     }
669 
670     function totalUnderlying() external view returns (uint256){
671         return _getTotalUnderlying();
672     }
673 
674     function balanceOf(address _account) public override view returns (uint256){
675         return getUnderlyingForShares(_sharesOf(_account));
676     }
677 
678     // transfer tokens, not shares
679     function transfer(address _recipient, uint256 _amount) external override returns (bool){
680         _verify(msg.sender, _amount);
681         _transfer(msg.sender, _recipient, _amount);
682         return true;
683     }
684 
685     function transferFrom(address _sender, address _recipient, uint256 _amount) external override returns (bool){
686         _verify(_sender, _amount);
687         uint256 _currentAllowance = allowances[_sender][msg.sender];
688         require(_currentAllowance >= _amount, "FARMTOKENV1: not enough allowance");
689 
690         _transfer(_sender, _recipient, _amount);
691         _approve(_sender, msg.sender, _currentAllowance.sub(_amount));
692         return true;
693     }
694 
695     // this checks if a transfer/transferFrom/withdraw is allowed. There are some conditions on withdraws/transfers from new deposits
696     // function stub, this needs to be implemented in a contract which inherits this for a valid deployment
697     // IMPLEMENT THIS
698     function _verify(address _account, uint256 _amountUnderlyingToSend) internal virtual;
699 
700     // allow tokens, not shares
701     function allowance(address _owner, address _spender) external override view returns (uint256){
702         return allowances[_owner][_spender];
703     }
704 
705     // approve tokens, not shares
706     function approve(address _spender, uint256 _amount) external override returns (bool){
707         _approve(msg.sender, _spender, _amount);
708         return true;
709     }
710 
711     // shares of _account
712     function sharesOf(address _account) external view returns (uint256) {
713         return _sharesOf(_account);
714     }
715 
716     // how many shares for _amount of underlying?
717     // if there are no shares, or no underlying yet, we are initing the contract or suffered a total loss
718     // either way, init this state at 1:1 shares:underlying
719     function getSharesForUnderlying(uint256 _amountUnderlying) public view returns (uint256){
720         uint256 _totalUnderlying = _getTotalUnderlying();
721         if (_totalUnderlying == 0){
722             return _amountUnderlying; // this will init at 1:1 _underlying:_shares
723         }
724         uint256 _totalShares = totalShares;
725         if (_totalShares == 0){
726             return _amountUnderlying; // this will init the first shares, expected contract underlying balance == 0, or there will be a bonus (doesn't belong to anyone so ok)
727         }
728 
729         return _amountUnderlying.mul(_totalShares).div(_totalUnderlying);
730     }
731 
732     // how many underlying for _amount of shares?
733     // if there are no shares, or no underlying yet, we are initing the contract or suffered a total loss
734     // either way, init this state at 1:1 shares:underlying
735     function getUnderlyingForShares(uint256 _amountShares) public view returns (uint256){
736         uint256 _totalShares = totalShares;
737         if (_totalShares == 0){
738             return _amountShares; // this will init at 1:1 _shares:_underlying
739         }
740         uint256 _totalUnderlying = _getTotalUnderlying();
741         if (_totalUnderlying == 0){
742             return _amountShares; // this will init at 1:1 
743         }
744 
745         return _amountShares.mul(_totalUnderlying).div(_totalShares);
746 
747     }
748 
749     function _sharesOf(address _account) internal view returns (uint256){
750         return shares[_account];
751     }
752 
753     // function stub, this needs to be implemented in a contract which inherits this for a valid deployment
754     // sum the contract balance + working balance withdrawn from the contract and actively farming
755     // IMPLEMENT THIS
756     function _getTotalUnderlying() internal virtual view returns (uint256);
757 
758     // in underlying
759     function _transfer(address _sender, address _recipient, uint256 _amount) internal {
760         uint256 _sharesToTransfer = getSharesForUnderlying(_amount);
761         _transferShares(_sender, _recipient, _sharesToTransfer);
762         emit Transfer(_sender, _recipient, _amount);
763     }
764 
765     // in underlying
766     function _approve(address _owner, address _spender, uint256 _amount) internal {
767         require(_owner != address(0), "FARMTOKENV1: from == 0x0");
768         require(_spender != address(0), "FARMTOKENV1: to == 0x00");
769 
770         allowances[_owner][_spender] = _amount;
771         emit Approval(_owner, _spender, _amount);
772     }
773 
774     function _transferShares(address _sender, address _recipient,  uint256 _amountShares) internal {
775         require(_sender != address(0), "FARMTOKENV1: from == 0x00");
776         require(_recipient != address(0), "FARMTOKENV1: to == 0x00");
777 
778         uint256 _currentSenderShares = shares[_sender];
779         require(_amountShares <= _currentSenderShares, "FARMTOKENV1: transfer amount exceeds balance");
780 
781         shares[_sender] = _currentSenderShares.sub(_amountShares);
782         shares[_recipient] = shares[_recipient].add(_amountShares);
783     }
784 
785     function _mintShares(address _recipient, uint256 _amountShares) internal {
786         require(_recipient != address(0), "FARMTOKENV1: to == 0x00");
787 
788         totalShares = totalShares.add(_amountShares);
789         shares[_recipient] = shares[_recipient].add(_amountShares);
790 
791         // NOTE: we're not emitting a Transfer event from the zero address here
792         // If we mint shares with no underlying, we basically just diluted everyone
793 
794         // It's not possible to send events from _everyone_ to reflect each balance dilution (ie: balance going down)
795 
796         // Not compliant to ERC20 standard...
797     }
798 
799     function _burnShares(address _account, uint256 _amountShares) internal {
800         require(_account != address(0), "FARMTOKENV1: burn from == 0x00");
801 
802         uint256 _accountShares = shares[_account];
803         require(_amountShares <= _accountShares, "FARMTOKENV1: burn amount exceeds balance");
804         totalShares = totalShares.sub(_amountShares);
805 
806         shares[_account] = _accountShares.sub(_amountShares);
807 
808         // NOTE: we're not emitting a Transfer event to the zero address here 
809         // If we burn shares without burning/withdrawing the underlying
810         // then it looks like a system wide credit to everyones balance
811 
812         // It's not possible to send events to _everyone_ to reflect each balance credit (ie: balance going up)
813 
814         // Not compliant to ERC20 standard...
815     }
816 }
817 
818 contract FarmTreasuryV1 is ReentrancyGuard, FarmTokenV1 {
819     using SafeERC20 for IERC20;
820     using SafeMath for uint256;
821     using Address for address;
822 
823     mapping(address => DepositInfo) public userDeposits;
824     mapping(address => bool) public noLockWhitelist;
825 
826     struct DepositInfo {
827         uint256 amountUnderlyingLocked;
828         uint256 timestampDeposit;
829         uint256 timestampUnlocked;
830     }
831 
832     uint256 internal constant LOOP_LIMIT = 200;
833 
834     address payable public governance;
835     address payable public farmBoss;
836 
837     bool public paused = false;
838     bool public pausedDeposits = false;
839 
840     // fee schedule, can be changed by governance, in bips
841     // performance fee is on any gains, base fee is on AUM/yearly
842     uint256 public constant max = 10000;
843     uint256 public performanceToTreasury = 1000;
844     uint256 public performanceToFarmer = 1000;
845     uint256 public baseToTreasury = 100;
846     uint256 public baseToFarmer = 100;
847 
848     // limits on rebalancing from the farmer, trying to negate errant rebalances
849     uint256 public rebalanceUpLimit = 100; // maximum of a 1% gain per rebalance
850     uint256 public rebalanceUpWaitTime = 23 hours;
851     uint256 public lastRebalanceUpTime;
852 
853     // waiting period on withdraws from time of deposit
854     // locked amount linearly decreases until the time is up, so at waitPeriod/2 after deposit, you can withdraw depositAmt/2 funds.
855     uint256 public waitPeriod = 1 weeks;
856 
857     // hot wallet holdings for instant withdraw, in bips
858     // if the hot wallet balance expires, the users will need to wait for the next rebalance period in order to withdraw
859     uint256 public hotWalletHoldings = 1000; // 10% initially
860 
861     uint256 public ACTIVELY_FARMED;
862 
863     event RebalanceHot(uint256 amountIn, uint256 amountToFarmer, uint256 timestamp);
864     event ProfitDeclared(bool profit, uint256 amount, uint256 timestamp, uint256 totalAmountInPool, uint256 totalSharesInPool, uint256 performanceFeeTotal, uint256 baseFeeTotal);
865     event Deposit(address depositor, uint256 amount, address referral);
866     event Withdraw(address withdrawer, uint256 amount);
867 
868     constructor(string memory _nameUnderlying, uint8 _decimalsUnderlying, address _underlying) public FarmTokenV1(_nameUnderlying, _decimalsUnderlying, _underlying) {
869         governance = msg.sender;
870         lastRebalanceUpTime = block.timestamp;
871     }
872 
873     function setGovernance(address payable _new) external {
874         require(msg.sender == governance, "FARMTREASURYV1: !governance");
875         governance = _new;
876     }
877 
878     // the "farmBoss" is a trusted smart contract that functions kind of like an EOA.
879     // HOWEVER specific contract addresses need to be whitelisted in order for this contract to be allowed to interact w/ them
880     // the governance has full control over the farmBoss, and other addresses can have partial control for strategy rotation/rebalancing
881     function setFarmBoss(address payable _new) external {
882         require(msg.sender == governance, "FARMTREASURYV1: !governance");
883         farmBoss = _new;
884     }
885 
886     function setNoLockWhitelist(address[] calldata _accounts, bool[] calldata _noLock) external {
887         require(msg.sender == governance, "FARMTREASURYV1: !governance");
888         require(_accounts.length == _noLock.length && _accounts.length <= LOOP_LIMIT, "FARMTREASURYV1: check array lengths");
889 
890         for (uint256 i = 0; i < _accounts.length; i++){
891             noLockWhitelist[_accounts[i]] = _noLock[i];
892         }
893     }
894 
895     function pause() external {
896         require(msg.sender == governance, "FARMTREASURYV1: !governance");
897         paused = true;
898     }
899 
900     function unpause() external {
901         require(msg.sender == governance, "FARMTREASURYV1: !governance");
902         paused = false;
903     }
904 
905     function pauseDeposits() external {
906         require(msg.sender == governance, "FARMTREASURYV1: !governance");
907         pausedDeposits = true;
908     }
909 
910     function unpauseDeposits() external {
911         require(msg.sender == governance, "FARMTREASURYV1: !governance");
912         pausedDeposits = false;
913     }
914 
915     function setFeeDistribution(uint256 _performanceToTreasury, uint256 _performanceToFarmer, uint256 _baseToTreasury, uint256 _baseToFarmer) external {
916         require(msg.sender == governance, "FARMTREASURYV1: !governance");
917         require(_performanceToTreasury.add(_performanceToFarmer) < max, "FARMTREASURYV1: too high performance");
918         require(_baseToTreasury.add(_baseToFarmer) <= 500, "FARMTREASURYV1: too high base");
919         
920         performanceToTreasury = _performanceToTreasury;
921         performanceToFarmer = _performanceToFarmer;
922         baseToTreasury = _baseToTreasury;
923         baseToFarmer = _baseToFarmer;
924     }
925 
926     function setWaitPeriod(uint256 _new) external {
927         require(msg.sender == governance, "FARMTREASURYV1: !governance");
928         require(_new <= 10 weeks, "FARMTREASURYV1: too long wait");
929 
930         waitPeriod = _new;
931     }
932 
933     function setHotWalletHoldings(uint256 _new) external {
934         require(msg.sender == governance, "FARMTREASURYV1: !governance");
935         require(_new <= max && _new >= 100, "FARMTREASURYV1: hot wallet values bad");
936 
937         hotWalletHoldings = _new;
938     }
939 
940     function setRebalanceUpLimit(uint256 _new) external {
941         require(msg.sender == governance, "FARMTREASURYV1: !governance");
942         require(_new < max, "FARMTREASURYV1: >= max");
943 
944         rebalanceUpLimit = _new;
945     }
946 
947     function setRebalanceUpWaitTime(uint256 _new) external {
948         require(msg.sender == governance, "FARMTREASURYV1: !governance");
949         require(_new <= 1 weeks, "FARMTREASURYV1: > 1 week");
950 
951         rebalanceUpWaitTime = _new;
952     }
953 
954     function deposit(uint256 _amountUnderlying, address _referral) external nonReentrant {
955         require(_amountUnderlying > 0, "FARMTREASURYV1: amount == 0");
956         require(!paused && !pausedDeposits, "FARMTREASURYV1: paused");
957 
958         _deposit(_amountUnderlying, _referral);
959 
960         IERC20 _underlying = IERC20(underlyingContract);
961         uint256 _before = _underlying.balanceOf(address(this));
962         _underlying.safeTransferFrom(msg.sender, address(this), _amountUnderlying);
963         uint256 _after = _underlying.balanceOf(address(this));
964         uint256 _total = _after.sub(_before);
965         require(_total >= _amountUnderlying, "FARMTREASURYV1: bad transfer");
966     }
967 
968     function _deposit(uint256 _amountUnderlying, address _referral) internal {
969         // determine how many shares this will be
970         uint256 _sharesToMint = getSharesForUnderlying(_amountUnderlying);
971 
972         _mintShares(msg.sender, _sharesToMint);
973         // store some important info for this deposit, that will be checked on withdraw/transfer of tokens
974         _storeDepositInfo(msg.sender, _amountUnderlying);
975 
976         // emit deposit w/ referral event... can't refer yourself
977         if (_referral != msg.sender){
978             emit Deposit(msg.sender, _amountUnderlying, _referral);
979         }
980         else {
981             emit Deposit(msg.sender, _amountUnderlying, address(0));
982         }
983 
984         emit Transfer(address(0), msg.sender, _amountUnderlying);
985     }
986 
987     function _storeDepositInfo(address _account, uint256 _amountUnderlying) internal {
988 
989         DepositInfo memory _existingInfo = userDeposits[_account];
990 
991         // first deposit, make a new entry in the mapping, lock all funds for "waitPeriod"
992         if (_existingInfo.timestampDeposit == 0){
993             DepositInfo memory _info = DepositInfo(
994                 {
995                     amountUnderlyingLocked: _amountUnderlying, 
996                     timestampDeposit: block.timestamp, 
997                     timestampUnlocked: block.timestamp.add(waitPeriod)
998                 }
999             );
1000             userDeposits[_account] = _info;
1001         }
1002         // not the first deposit, if there are still funds locked, then average out the waits (ie: 1 BTC locked 10 days = 2 BTC locked 5 days)
1003         else {
1004             uint256 _lockedAmt = _getLockedAmount(_account, _existingInfo.amountUnderlyingLocked, _existingInfo.timestampDeposit, _existingInfo.timestampUnlocked);
1005             // if there's no lock, disregard old info and make a new lock
1006 
1007             if (_lockedAmt == 0){
1008                 DepositInfo memory _info = DepositInfo(
1009                     {
1010                         amountUnderlyingLocked: _amountUnderlying, 
1011                         timestampDeposit: block.timestamp, 
1012                         timestampUnlocked: block.timestamp.add(waitPeriod)
1013                     }
1014                 );
1015                 userDeposits[_account] = _info;
1016             }
1017             // funds are still locked from a past deposit, average out the waittime remaining with the waittime for this new deposit
1018             /*
1019                 solve this equation:
1020 
1021                 newDepositAmt * waitPeriod + remainingAmt * existingWaitPeriod = (newDepositAmt + remainingAmt) * X waitPeriod
1022 
1023                 therefore:
1024 
1025                                 (newDepositAmt * waitPeriod + remainingAmt * existingWaitPeriod)
1026                 X waitPeriod =  ----------------------------------------------------------------
1027                                                 (newDepositAmt + remainingAmt)
1028 
1029                 Example: 7 BTC new deposit, with wait period of 2 weeks
1030                          1 BTC remaining, with remaining wait period of 1 week
1031                          ...
1032                          (7 BTC * 2 weeks + 1 BTC * 1 week) / 8 BTC = 1.875 weeks
1033             */
1034             else {
1035                 uint256 _lockedAmtTime = _lockedAmt.mul(_existingInfo.timestampUnlocked.sub(block.timestamp));
1036                 uint256 _newAmtTime = _amountUnderlying.mul(waitPeriod);
1037                 uint256 _total = _amountUnderlying.add(_lockedAmt);
1038 
1039                 uint256 _newLockedTime = (_lockedAmtTime.add(_newAmtTime)).div(_total);
1040 
1041                 DepositInfo memory _info = DepositInfo(
1042                     {
1043                         amountUnderlyingLocked: _total, 
1044                         timestampDeposit: block.timestamp, 
1045                         timestampUnlocked: block.timestamp.add(_newLockedTime)
1046                     }
1047                 );
1048                 userDeposits[_account] = _info;
1049             }
1050         }
1051     }
1052 
1053     function getLockedAmount(address _account) public view returns (uint256) {
1054         DepositInfo memory _existingInfo = userDeposits[_account];
1055         return _getLockedAmount(_account, _existingInfo.amountUnderlyingLocked, _existingInfo.timestampDeposit, _existingInfo.timestampUnlocked);
1056     }
1057 
1058     // the locked amount linearly decreases until the timestampUnlocked time, then it's zero
1059     // Example: if 5 BTC contributed (2 week lock), then after 1 week there will be 2.5 BTC locked, the rest is free to transfer/withdraw
1060     function _getLockedAmount(address _account, uint256 _amountLocked, uint256 _timestampDeposit, uint256 _timestampUnlocked) internal view returns (uint256) {
1061         if (_timestampUnlocked <= block.timestamp || noLockWhitelist[_account]){
1062             return 0;
1063         }
1064         else {
1065             uint256 _remainingTime = _timestampUnlocked.sub(block.timestamp);
1066             uint256 _totalTime = _timestampUnlocked.sub(_timestampDeposit);
1067 
1068             return _amountLocked.mul(_remainingTime).div(_totalTime);
1069         }
1070     }
1071 
1072     function withdraw(uint256 _amountUnderlying) external nonReentrant {
1073         require(_amountUnderlying > 0, "FARMTREASURYV1: amount == 0");
1074         require(!paused, "FARMTREASURYV1: paused");
1075 
1076         _withdraw(_amountUnderlying);
1077 
1078         IERC20(underlyingContract).safeTransfer(msg.sender, _amountUnderlying);
1079     }
1080 
1081     function _withdraw(uint256 _amountUnderlying) internal {
1082         _verify(msg.sender, _amountUnderlying);
1083         // try and catch the more obvious error of hot wallet being depleted, otherwise proceed
1084         if (IERC20(underlyingContract).balanceOf(address(this)) < _amountUnderlying){
1085             revert("FARMTREASURYV1: Hot wallet balance depleted. Please try smaller withdraw or wait for rebalancing.");
1086         }
1087 
1088         uint256 _sharesToBurn = getSharesForUnderlying(_amountUnderlying);
1089         _burnShares(msg.sender, _sharesToBurn); // they must have >= _sharesToBurn, checked here
1090 
1091         emit Transfer(msg.sender, address(0), _amountUnderlying);
1092         emit Withdraw(msg.sender, _amountUnderlying);
1093     }
1094 
1095     // wait time verification
1096     function _verify(address _account, uint256 _amountUnderlyingToSend) internal override {
1097         DepositInfo memory _existingInfo = userDeposits[_account];
1098 
1099         uint256 _lockedAmt = _getLockedAmount(_account, _existingInfo.amountUnderlyingLocked, _existingInfo.timestampDeposit, _existingInfo.timestampUnlocked);
1100         uint256 _balance = balanceOf(_account);
1101 
1102         // require that any funds locked are not leaving the account in question.
1103         require(_balance.sub(_amountUnderlyingToSend) >= _lockedAmt, "FARMTREASURYV1: requested funds are temporarily locked");
1104     }
1105 
1106     // this means that we made a GAIN, due to standard farming gains
1107     // operaratable by farmBoss, this is standard operating procedure, farmers can only report gains
1108     function rebalanceUp(uint256 _amount, address _farmerRewards) external nonReentrant returns (bool, uint256) {
1109         require(msg.sender == farmBoss, "FARMTREASURYV1: !farmBoss");
1110         require(!paused, "FARMTREASURYV1: paused");
1111 
1112         // fee logic & profit recording
1113         // check farmer limits on rebalance wait time for earning reportings. if there is no _amount reported, we don't take any fees and skip these checks
1114         // we should always allow pure hot wallet rebalances, however earnings needs some checks and restrictions
1115         if (_amount > 0){
1116             require(block.timestamp.sub(lastRebalanceUpTime) >= rebalanceUpWaitTime, "FARMTREASURYV1: <rebalanceUpWaitTime");
1117             require(ACTIVELY_FARMED.mul(rebalanceUpLimit).div(max) >= _amount, "FARMTREASURYV1 _amount > rebalanceUpLimit");
1118             // farmer incurred a gain of _amount, add this to the amount being farmed
1119             ACTIVELY_FARMED = ACTIVELY_FARMED.add(_amount);
1120             uint256 _totalPerformance = _performanceFee(_amount, _farmerRewards);
1121             uint256 _totalAnnual = _annualFee(_farmerRewards);
1122 
1123             // for farmer controls, and also for the annual fee time
1124             // only update this if there is a reported gain, otherwise this is just a hot wallet rebalance, and we should always allow these
1125             lastRebalanceUpTime = block.timestamp; 
1126 
1127             // for off-chain APY calculations, fees assessed
1128             emit ProfitDeclared(true, _amount, block.timestamp, _getTotalUnderlying(), totalShares, _totalPerformance, _totalAnnual);
1129         }
1130         else {
1131             // for off-chain APY calculations, no fees assessed
1132             emit ProfitDeclared(true, _amount, block.timestamp, _getTotalUnderlying(), totalShares, 0, 0);
1133         }
1134         // end fee logic & profit recording
1135 
1136         // funds are in the contract and gains are accounted for, now determine if we need to further rebalance the hot wallet up, or can take funds in order to farm
1137         // start hot wallet and farmBoss rebalance logic
1138         (bool _fundsNeeded, uint256 _amountChange) = _calcHotWallet();
1139         _rebalanceHot(_fundsNeeded, _amountChange); // if the hot wallet rebalance fails, revert() the entire function
1140         // end logic
1141 
1142         return (_fundsNeeded, _amountChange); // in case we need them, FE simulations and such
1143     }
1144 
1145     // this means that the system took a loss, and it needs to be reflected in the next rebalance
1146     // only operatable by governance, (large) losses should be extremely rare by good farming practices
1147     // this would look like a farmed smart contract getting exploited/hacked, and us not having the necessary insurance for it
1148     // possible that some more aggressive IL strategies could also need this function called
1149     function rebalanceDown(uint256 _amount, bool _rebalanceHotWallet) external nonReentrant returns (bool, uint256) {
1150         require(msg.sender == governance, "FARMTREASURYV1: !governance");
1151         // require(!paused, "FARMTREASURYV1: paused"); <-- governance can only call this anyways, leave this commented out
1152 
1153         ACTIVELY_FARMED = ACTIVELY_FARMED.sub(_amount);
1154 
1155         if (_rebalanceHotWallet){
1156             (bool _fundsNeeded, uint256 _amountChange) = _calcHotWallet();
1157             _rebalanceHot(_fundsNeeded, _amountChange); // if the hot wallet rebalance fails, revert() the entire function
1158 
1159             return (_fundsNeeded, _amountChange); // in case we need them, FE simulations and such
1160         }
1161 
1162         // for off-chain APY calculations, no fees assessed
1163         emit ProfitDeclared(false, _amount, block.timestamp, _getTotalUnderlying(), totalShares, 0, 0);
1164 
1165         return (false, 0);
1166     }
1167 
1168     function _performanceFee(uint256 _amount, address _farmerRewards) internal returns (uint256){
1169 
1170         uint256 _existingShares = totalShares;
1171         uint256 _balance = _getTotalUnderlying();
1172 
1173         uint256 _performanceToFarmerUnderlying = _amount.mul(performanceToFarmer).div(max);
1174         uint256 _performanceToTreasuryUnderlying = _amount.mul(performanceToTreasury).div(max);
1175         uint256 _performanceTotalUnderlying = _performanceToFarmerUnderlying.add(_performanceToTreasuryUnderlying);
1176 
1177         if (_performanceTotalUnderlying == 0){
1178             return 0;
1179         }
1180 
1181         uint256 _sharesToMint = _underlyingFeeToShares(_performanceTotalUnderlying, _balance, _existingShares);
1182 
1183         uint256 _sharesToFarmer = _sharesToMint.mul(_performanceToFarmerUnderlying).div(_performanceTotalUnderlying); // by the same ratio
1184         uint256 _sharesToTreasury = _sharesToMint.sub(_sharesToFarmer);
1185 
1186         _mintShares(_farmerRewards, _sharesToFarmer);
1187         _mintShares(governance, _sharesToTreasury);
1188 
1189         uint256 _underlyingFarmer = getUnderlyingForShares(_sharesToFarmer);
1190         uint256 _underlyingTreasury = getUnderlyingForShares(_sharesToTreasury);
1191 
1192         // do two mint events, in underlying, not shares
1193         emit Transfer(address(0), _farmerRewards, _underlyingFarmer);
1194         emit Transfer(address(0), governance, _underlyingTreasury);
1195 
1196         return _underlyingFarmer.add(_underlyingTreasury);
1197     }
1198 
1199     // we are taking baseToTreasury + baseToFarmer each year, every time this is called, look when we took fee last, and linearize the fee to now();
1200     function _annualFee(address _farmerRewards) internal returns (uint256) {
1201         uint256 _lastAnnualFeeTime = lastRebalanceUpTime;
1202         if (_lastAnnualFeeTime >= block.timestamp){
1203             return 0;
1204         }
1205 
1206         uint256 _elapsedTime = block.timestamp.sub(_lastAnnualFeeTime);
1207         uint256 _existingShares = totalShares;
1208         uint256 _balance = _getTotalUnderlying();
1209 
1210         uint256 _annualPossibleUnderlying = _balance.mul(_elapsedTime).div(365 days);
1211         uint256 _annualToFarmerUnderlying = _annualPossibleUnderlying.mul(baseToFarmer).div(max);
1212         uint256 _annualToTreasuryUnderlying = _annualPossibleUnderlying.mul(baseToFarmer).div(max);
1213         uint256 _annualTotalUnderlying = _annualToFarmerUnderlying.add(_annualToTreasuryUnderlying);
1214 
1215         if (_annualTotalUnderlying == 0){
1216             return 0;
1217         }
1218 
1219         uint256 _sharesToMint = _underlyingFeeToShares(_annualTotalUnderlying, _balance, _existingShares);
1220 
1221         uint256 _sharesToFarmer = _sharesToMint.mul(_annualToFarmerUnderlying).div(_annualTotalUnderlying); // by the same ratio
1222         uint256 _sharesToTreasury = _sharesToMint.sub(_sharesToFarmer);
1223 
1224         _mintShares(_farmerRewards, _sharesToFarmer);
1225         _mintShares(governance, _sharesToTreasury);
1226 
1227         uint256 _underlyingFarmer = getUnderlyingForShares(_sharesToFarmer);
1228         uint256 _underlyingTreasury = getUnderlyingForShares(_sharesToTreasury);
1229 
1230         // do two mint events, in underlying, not shares
1231         emit Transfer(address(0), _farmerRewards, _underlyingFarmer);
1232         emit Transfer(address(0), governance, _underlyingTreasury);
1233 
1234         return _underlyingFarmer.add(_underlyingTreasury);
1235     }
1236 
1237     function _underlyingFeeToShares(uint256 _totalFeeUnderlying, uint256 _balance, uint256 _existingShares) pure internal returns (uint256 _sharesToMint){
1238         // to mint the required amount of fee shares, solve:
1239         /* 
1240             ratio:
1241 
1242                     currentShares             newShares     
1243             -------------------------- : --------------------, where newShares = (currentShares + mintShares)
1244             (totalUnderlying - feeAmt)      totalUnderlying
1245 
1246             solved:
1247             ---> (currentShares / (totalUnderlying - feeAmt) * totalUnderlying) - currentShares = mintShares, where newBalanceLessFee = (totalUnderlying - feeAmt)
1248         */
1249         return _existingShares
1250                 .mul(_balance)
1251                 .div(_balance.sub(_totalFeeUnderlying))
1252                 .sub(_existingShares);
1253     }
1254 
1255     function _calcHotWallet() internal view returns (bool _fundsNeeded, uint256 _amountChange) {
1256         uint256 _balanceHere = IERC20(underlyingContract).balanceOf(address(this));
1257         uint256 _balanceFarmed = ACTIVELY_FARMED;
1258 
1259         uint256 _totalAmount = _balanceHere.add(_balanceFarmed);
1260         uint256 _hotAmount = _totalAmount.mul(hotWalletHoldings).div(max);
1261 
1262         // we have too much in hot wallet, send to farmBoss
1263         if (_balanceHere >= _hotAmount){
1264             return (false, _balanceHere.sub(_hotAmount));
1265         }
1266         // we have too little in hot wallet, pull from farmBoss
1267         if (_balanceHere < _hotAmount){
1268             return (true, _hotAmount.sub(_balanceHere));
1269         }
1270     }
1271 
1272     // usually paired with _calcHotWallet()
1273     function _rebalanceHot(bool _fundsNeeded, uint256 _amountChange) internal {
1274         if (_fundsNeeded){
1275             uint256 _before = IERC20(underlyingContract).balanceOf(address(this));
1276             IERC20(underlyingContract).safeTransferFrom(farmBoss, address(this), _amountChange);
1277             uint256 _after = IERC20(underlyingContract).balanceOf(address(this));
1278             uint256 _total = _after.sub(_before);
1279 
1280             require(_total >= _amountChange, "FARMTREASURYV1: bad rebalance, hot wallet needs funds!");
1281 
1282             // we took funds from the farmBoss to refill the hot wallet, reflect this in ACTIVELY_FARMED
1283             ACTIVELY_FARMED = ACTIVELY_FARMED.sub(_amountChange);
1284 
1285             emit RebalanceHot(_amountChange, 0, block.timestamp);
1286         }
1287         else {
1288             require(farmBoss != address(0), "FARMTREASURYV1: !FarmBoss"); // don't burn funds
1289 
1290             IERC20(underlyingContract).safeTransfer(farmBoss, _amountChange); // _calcHotWallet() guarantees we have funds here to send
1291 
1292             // we sent more funds for the farmer to farm, reflect this
1293             ACTIVELY_FARMED = ACTIVELY_FARMED.add(_amountChange);
1294 
1295             emit RebalanceHot(0, _amountChange, block.timestamp);
1296         }
1297     }
1298 
1299     function _getTotalUnderlying() internal override view returns (uint256) {
1300         uint256 _balanceHere = IERC20(underlyingContract).balanceOf(address(this));
1301         uint256 _balanceFarmed = ACTIVELY_FARMED;
1302 
1303         return _balanceHere.add(_balanceFarmed);
1304     }
1305 
1306     function rescue(address _token, uint256 _amount) external nonReentrant {
1307         require(msg.sender == governance, "FARMTREASURYV1: !governance");
1308 
1309         if (_token != address(0)){
1310             IERC20(_token).safeTransfer(governance, _amount);
1311         }
1312         else { // if _tokenContract is 0x0, then escape ETH
1313             governance.transfer(_amount);
1314         }
1315     }
1316 }