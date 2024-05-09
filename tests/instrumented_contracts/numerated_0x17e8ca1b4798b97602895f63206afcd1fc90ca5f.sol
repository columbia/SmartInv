1 // File: localhost/contracts/lib/LibParam.sol
2 
3 pragma solidity ^0.6.0;
4 
5 library LibParam {
6     bytes32 private constant STATIC_MASK =
7         0x0100000000000000000000000000000000000000000000000000000000000000;
8     bytes32 private constant PARAMS_MASK =
9         0x0000000000000000000000000000000000000000000000000000000000000001;
10     bytes32 private constant REFS_MASK =
11         0x00000000000000000000000000000000000000000000000000000000000000FF;
12     bytes32 private constant RETURN_NUM_MASK =
13         0x00FF000000000000000000000000000000000000000000000000000000000000;
14 
15     uint256 private constant REFS_LIMIT = 22;
16     uint256 private constant PARAMS_SIZE_LIMIT = 64;
17     uint256 private constant RETURN_NUM_OFFSET = 240;
18 
19     function isStatic(bytes32 conf) internal pure returns (bool) {
20         if (conf & STATIC_MASK == 0) return true;
21         else return false;
22     }
23 
24     function isReferenced(bytes32 conf) internal pure returns (bool) {
25         if (getReturnNum(conf) == 0) return false;
26         else return true;
27     }
28 
29     function getReturnNum(bytes32 conf) internal pure returns (uint256 num) {
30         bytes32 temp = (conf & RETURN_NUM_MASK) >> RETURN_NUM_OFFSET;
31         num = uint256(temp);
32     }
33 
34     function getParams(bytes32 conf)
35         internal
36         pure
37         returns (uint256[] memory refs, uint256[] memory params)
38     {
39         require(!isStatic(conf), "Static params");
40         uint256 n = 0;
41         while (conf & REFS_MASK == REFS_MASK && n < REFS_LIMIT) {
42             n++;
43             conf = conf >> 8;
44         }
45         n = REFS_LIMIT - n;
46         require(n > 0, "No dynamic param");
47         refs = new uint256[](n);
48         params = new uint256[](n);
49         for (uint256 i = 0; i < n; i++) {
50             refs[i] = uint256(conf & REFS_MASK);
51             conf = conf >> 8;
52         }
53         uint256 i = 0;
54         for (uint256 k = 0; k < PARAMS_SIZE_LIMIT; k++) {
55             if (conf & PARAMS_MASK != 0) {
56                 require(i < n, "Location count exceeds ref count");
57                 params[i] = k * 32 + 4;
58                 i++;
59             }
60             conf = conf >> 1;
61         }
62         require(i == n, "Location count less than ref count");
63     }
64 }
65 
66 // File: localhost/contracts/lib/LibStack.sol
67 
68 pragma solidity ^0.6.0;
69 
70 library LibStack {
71     function setAddress(bytes32[] storage _stack, address _input) internal {
72         _stack.push(bytes32(uint256(uint160(_input))));
73     }
74 
75     function set(bytes32[] storage _stack, bytes32 _input) internal {
76         _stack.push(_input);
77     }
78 
79     function setHandlerType(bytes32[] storage _stack, uint256 _input) internal {
80         require(_input < uint96(-1), "Invalid Handler Type");
81         _stack.push(bytes12(uint96(_input)));
82     }
83 
84     function getAddress(bytes32[] storage _stack)
85         internal
86         returns (address ret)
87     {
88         ret = address(uint160(uint256(peek(_stack))));
89         _stack.pop();
90     }
91 
92     function getSig(bytes32[] storage _stack) internal returns (bytes4 ret) {
93         ret = bytes4(peek(_stack));
94         _stack.pop();
95     }
96 
97     function get(bytes32[] storage _stack) internal returns (bytes32 ret) {
98         ret = peek(_stack);
99         _stack.pop();
100     }
101 
102     function peek(bytes32[] storage _stack)
103         internal
104         view
105         returns (bytes32 ret)
106     {
107         require(_stack.length > 0, "stack empty");
108         ret = _stack[_stack.length - 1];
109     }
110 }
111 
112 // File: localhost/contracts/lib/LibCache.sol
113 
114 pragma solidity ^0.6.0;
115 
116 library LibCache {
117     function set(
118         mapping(bytes32 => bytes32) storage _cache,
119         bytes32 _key,
120         bytes32 _value
121     ) internal {
122         _cache[_key] = _value;
123     }
124 
125     function setAddress(
126         mapping(bytes32 => bytes32) storage _cache,
127         bytes32 _key,
128         address _value
129     ) internal {
130         _cache[_key] = bytes32(uint256(uint160(_value)));
131     }
132 
133     function setUint256(
134         mapping(bytes32 => bytes32) storage _cache,
135         bytes32 _key,
136         uint256 _value
137     ) internal {
138         _cache[_key] = bytes32(_value);
139     }
140 
141     function getAddress(
142         mapping(bytes32 => bytes32) storage _cache,
143         bytes32 _key
144     ) internal view returns (address ret) {
145         ret = address(uint160(uint256(_cache[_key])));
146     }
147 
148     function getUint256(
149         mapping(bytes32 => bytes32) storage _cache,
150         bytes32 _key
151     ) internal view returns (uint256 ret) {
152         ret = uint256(_cache[_key]);
153     }
154 
155     function get(mapping(bytes32 => bytes32) storage _cache, bytes32 _key)
156         internal
157         view
158         returns (bytes32 ret)
159     {
160         ret = _cache[_key];
161     }
162 }
163 
164 // File: localhost/contracts/Storage.sol
165 
166 pragma solidity ^0.6.0;
167 
168 
169 
170 /// @notice A cache structure composed by a bytes32 array
171 contract Storage {
172     using LibCache for mapping(bytes32 => bytes32);
173     using LibStack for bytes32[];
174 
175     bytes32[] public stack;
176     mapping(bytes32 => bytes32) public cache;
177 
178     // keccak256 hash of "msg.sender"
179     // prettier-ignore
180     bytes32 public constant MSG_SENDER_KEY = 0xb2f2618cecbbb6e7468cc0f2aa43858ad8d153e0280b22285e28e853bb9d453a;
181 
182     // keccak256 hash of "cube.counter"
183     // prettier-ignore
184     bytes32 public constant CUBE_COUNTER_KEY = 0xf9543f11459ccccd21306c8881aaab675ff49d988c1162fd1dd9bbcdbe4446be;
185 
186     modifier isStackEmpty() {
187         require(stack.length == 0, "Stack not empty");
188         _;
189     }
190 
191     modifier isCubeCounterZero() {
192         require(_getCubeCounter() == 0, "Cube counter not zero");
193         _;
194     }
195 
196     function _setSender() internal {
197         if (_getSender() == address(0))
198             cache.setAddress(MSG_SENDER_KEY, msg.sender);
199     }
200 
201     function _resetSender() internal {
202         cache.setAddress(MSG_SENDER_KEY, address(0));
203     }
204 
205     function _getSender() internal view returns (address) {
206         return cache.getAddress(MSG_SENDER_KEY);
207     }
208 
209     function _addCubeCounter() internal {
210         cache.setUint256(CUBE_COUNTER_KEY, _getCubeCounter() + 1);
211     }
212 
213     function _resetCubeCounter() internal {
214         cache.setUint256(CUBE_COUNTER_KEY, 0);
215     }
216 
217     function _getCubeCounter() internal view returns (uint256) {
218         return cache.getUint256(CUBE_COUNTER_KEY);
219     }
220 }
221 
222 // File: localhost/contracts/Config.sol
223 
224 pragma solidity ^0.6.0;
225 
226 contract Config {
227     // function signature of "postProcess()"
228     bytes4 public constant POSTPROCESS_SIG = 0xc2722916;
229 
230     // The base amount of percentage function
231     uint256 public constant PERCENTAGE_BASE = 1 ether;
232 
233     // Handler post-process type. Others should not happen now.
234     enum HandlerType {Token, Custom, Others}
235 }
236 
237 // File: localhost/contracts/interface/IRegistry.sol
238 
239 pragma solidity ^0.6.0;
240 
241 
242 interface IRegistry {
243     function infos(address) external view returns (bytes32);
244 
245     function isValid(address handler) external view returns (bool result);
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 // SPDX-License-Identifier: MIT
251 
252 pragma solidity >=0.6.2 <0.8.0;
253 
254 /**
255  * @dev Collection of functions related to the address type
256  */
257 library Address {
258     /**
259      * @dev Returns true if `account` is a contract.
260      *
261      * [IMPORTANT]
262      * ====
263      * It is unsafe to assume that an address for which this function returns
264      * false is an externally-owned account (EOA) and not a contract.
265      *
266      * Among others, `isContract` will return false for the following
267      * types of addresses:
268      *
269      *  - an externally-owned account
270      *  - a contract in construction
271      *  - an address where a contract will be created
272      *  - an address where a contract lived, but was destroyed
273      * ====
274      */
275     function isContract(address account) internal view returns (bool) {
276         // This method relies on extcodesize, which returns 0 for contracts in
277         // construction, since the code is only stored at the end of the
278         // constructor execution.
279 
280         uint256 size;
281         // solhint-disable-next-line no-inline-assembly
282         assembly { size := extcodesize(account) }
283         return size > 0;
284     }
285 
286     /**
287      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
288      * `recipient`, forwarding all available gas and reverting on errors.
289      *
290      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
291      * of certain opcodes, possibly making contracts go over the 2300 gas limit
292      * imposed by `transfer`, making them unable to receive funds via
293      * `transfer`. {sendValue} removes this limitation.
294      *
295      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
296      *
297      * IMPORTANT: because control is transferred to `recipient`, care must be
298      * taken to not create reentrancy vulnerabilities. Consider using
299      * {ReentrancyGuard} or the
300      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
301      */
302     function sendValue(address payable recipient, uint256 amount) internal {
303         require(address(this).balance >= amount, "Address: insufficient balance");
304 
305         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
306         (bool success, ) = recipient.call{ value: amount }("");
307         require(success, "Address: unable to send value, recipient may have reverted");
308     }
309 
310     /**
311      * @dev Performs a Solidity function call using a low level `call`. A
312      * plain`call` is an unsafe replacement for a function call: use this
313      * function instead.
314      *
315      * If `target` reverts with a revert reason, it is bubbled up by this
316      * function (like regular Solidity function calls).
317      *
318      * Returns the raw returned data. To convert to the expected return value,
319      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
320      *
321      * Requirements:
322      *
323      * - `target` must be a contract.
324      * - calling `target` with `data` must not revert.
325      *
326      * _Available since v3.1._
327      */
328     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
329       return functionCall(target, data, "Address: low-level call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
334      * `errorMessage` as a fallback revert reason when `target` reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
354         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
359      * with `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: value }(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but performing a static call.
375      *
376      * _Available since v3.3._
377      */
378     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
379         return functionStaticCall(target, data, "Address: low-level static call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return _verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
397         if (success) {
398             return returndata;
399         } else {
400             // Look for revert reason and bubble it up if present
401             if (returndata.length > 0) {
402                 // The easiest way to bubble the revert reason is using memory via assembly
403 
404                 // solhint-disable-next-line no-inline-assembly
405                 assembly {
406                     let returndata_size := mload(returndata)
407                     revert(add(32, returndata), returndata_size)
408                 }
409             } else {
410                 revert(errorMessage);
411             }
412         }
413     }
414 }
415 
416 // File: @openzeppelin/contracts/math/SafeMath.sol
417 
418 
419 pragma solidity >=0.6.0 <0.8.0;
420 
421 /**
422  * @dev Wrappers over Solidity's arithmetic operations with added overflow
423  * checks.
424  *
425  * Arithmetic operations in Solidity wrap on overflow. This can easily result
426  * in bugs, because programmers usually assume that an overflow raises an
427  * error, which is the standard behavior in high level programming languages.
428  * `SafeMath` restores this intuition by reverting the transaction when an
429  * operation overflows.
430  *
431  * Using this library instead of the unchecked operations eliminates an entire
432  * class of bugs, so it's recommended to use it always.
433  */
434 library SafeMath {
435     /**
436      * @dev Returns the addition of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `+` operator.
440      *
441      * Requirements:
442      *
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         uint256 c = a + b;
447         require(c >= a, "SafeMath: addition overflow");
448 
449         return c;
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, reverting on
454      * overflow (when the result is negative).
455      *
456      * Counterpart to Solidity's `-` operator.
457      *
458      * Requirements:
459      *
460      * - Subtraction cannot overflow.
461      */
462     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
463         return sub(a, b, "SafeMath: subtraction overflow");
464     }
465 
466     /**
467      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
468      * overflow (when the result is negative).
469      *
470      * Counterpart to Solidity's `-` operator.
471      *
472      * Requirements:
473      *
474      * - Subtraction cannot overflow.
475      */
476     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
477         require(b <= a, errorMessage);
478         uint256 c = a - b;
479 
480         return c;
481     }
482 
483     /**
484      * @dev Returns the multiplication of two unsigned integers, reverting on
485      * overflow.
486      *
487      * Counterpart to Solidity's `*` operator.
488      *
489      * Requirements:
490      *
491      * - Multiplication cannot overflow.
492      */
493     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
494         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
495         // benefit is lost if 'b' is also tested.
496         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
497         if (a == 0) {
498             return 0;
499         }
500 
501         uint256 c = a * b;
502         require(c / a == b, "SafeMath: multiplication overflow");
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the integer division of two unsigned integers. Reverts on
509      * division by zero. The result is rounded towards zero.
510      *
511      * Counterpart to Solidity's `/` operator. Note: this function uses a
512      * `revert` opcode (which leaves remaining gas untouched) while Solidity
513      * uses an invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function div(uint256 a, uint256 b) internal pure returns (uint256) {
520         return div(a, b, "SafeMath: division by zero");
521     }
522 
523     /**
524      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
525      * division by zero. The result is rounded towards zero.
526      *
527      * Counterpart to Solidity's `/` operator. Note: this function uses a
528      * `revert` opcode (which leaves remaining gas untouched) while Solidity
529      * uses an invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
536         require(b > 0, errorMessage);
537         uint256 c = a / b;
538         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
545      * Reverts when dividing by zero.
546      *
547      * Counterpart to Solidity's `%` operator. This function uses a `revert`
548      * opcode (which leaves remaining gas untouched) while Solidity uses an
549      * invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
556         return mod(a, b, "SafeMath: modulo by zero");
557     }
558 
559     /**
560      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
561      * Reverts with custom message when dividing by zero.
562      *
563      * Counterpart to Solidity's `%` operator. This function uses a `revert`
564      * opcode (which leaves remaining gas untouched) while Solidity uses an
565      * invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b != 0, errorMessage);
573         return a % b;
574     }
575 }
576 
577 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
578 
579 
580 pragma solidity >=0.6.0 <0.8.0;
581 
582 /**
583  * @dev Interface of the ERC20 standard as defined in the EIP.
584  */
585 interface IERC20 {
586     /**
587      * @dev Returns the amount of tokens in existence.
588      */
589     function totalSupply() external view returns (uint256);
590 
591     /**
592      * @dev Returns the amount of tokens owned by `account`.
593      */
594     function balanceOf(address account) external view returns (uint256);
595 
596     /**
597      * @dev Moves `amount` tokens from the caller's account to `recipient`.
598      *
599      * Returns a boolean value indicating whether the operation succeeded.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transfer(address recipient, uint256 amount) external returns (bool);
604 
605     /**
606      * @dev Returns the remaining number of tokens that `spender` will be
607      * allowed to spend on behalf of `owner` through {transferFrom}. This is
608      * zero by default.
609      *
610      * This value changes when {approve} or {transferFrom} are called.
611      */
612     function allowance(address owner, address spender) external view returns (uint256);
613 
614     /**
615      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
616      *
617      * Returns a boolean value indicating whether the operation succeeded.
618      *
619      * IMPORTANT: Beware that changing an allowance with this method brings the risk
620      * that someone may use both the old and the new allowance by unfortunate
621      * transaction ordering. One possible solution to mitigate this race
622      * condition is to first reduce the spender's allowance to 0 and set the
623      * desired value afterwards:
624      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
625      *
626      * Emits an {Approval} event.
627      */
628     function approve(address spender, uint256 amount) external returns (bool);
629 
630     /**
631      * @dev Moves `amount` tokens from `sender` to `recipient` using the
632      * allowance mechanism. `amount` is then deducted from the caller's
633      * allowance.
634      *
635      * Returns a boolean value indicating whether the operation succeeded.
636      *
637      * Emits a {Transfer} event.
638      */
639     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
640 
641     /**
642      * @dev Emitted when `value` tokens are moved from one account (`from`) to
643      * another (`to`).
644      *
645      * Note that `value` may be zero.
646      */
647     event Transfer(address indexed from, address indexed to, uint256 value);
648 
649     /**
650      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
651      * a call to {approve}. `value` is the new allowance.
652      */
653     event Approval(address indexed owner, address indexed spender, uint256 value);
654 }
655 
656 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
657 
658 
659 pragma solidity >=0.6.0 <0.8.0;
660 
661 
662 
663 
664 /**
665  * @title SafeERC20
666  * @dev Wrappers around ERC20 operations that throw on failure (when the token
667  * contract returns false). Tokens that return no value (and instead revert or
668  * throw on failure) are also supported, non-reverting calls are assumed to be
669  * successful.
670  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
671  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
672  */
673 library SafeERC20 {
674     using SafeMath for uint256;
675     using Address for address;
676 
677     function safeTransfer(IERC20 token, address to, uint256 value) internal {
678         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
679     }
680 
681     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
682         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
683     }
684 
685     /**
686      * @dev Deprecated. This function has issues similar to the ones found in
687      * {IERC20-approve}, and its usage is discouraged.
688      *
689      * Whenever possible, use {safeIncreaseAllowance} and
690      * {safeDecreaseAllowance} instead.
691      */
692     function safeApprove(IERC20 token, address spender, uint256 value) internal {
693         // safeApprove should only be called when setting an initial allowance,
694         // or when resetting it to zero. To increase and decrease it, use
695         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
696         // solhint-disable-next-line max-line-length
697         require((value == 0) || (token.allowance(address(this), spender) == 0),
698             "SafeERC20: approve from non-zero to non-zero allowance"
699         );
700         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
701     }
702 
703     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
704         uint256 newAllowance = token.allowance(address(this), spender).add(value);
705         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
706     }
707 
708     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
709         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
710         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
711     }
712 
713     /**
714      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
715      * on the return value: the return value is optional (but if data is returned, it must not be false).
716      * @param token The token targeted by the call.
717      * @param data The call data (encoded using abi.encode or one of its variants).
718      */
719     function _callOptionalReturn(IERC20 token, bytes memory data) private {
720         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
721         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
722         // the target address contains contract code and also asserts for success in the low-level call.
723 
724         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
725         if (returndata.length > 0) { // Return data is optional
726             // solhint-disable-next-line max-line-length
727             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
728         }
729     }
730 }
731 
732 // File: localhost/contracts/Proxy.sol
733 
734 pragma solidity ^0.6.0;
735 pragma experimental ABIEncoderV2;
736 
737 
738 
739 
740 
741 
742 
743 /**
744  * @title The entrance of Furucombo
745  * @author Ben Huang
746  */
747 contract Proxy is Storage, Config {
748     using Address for address;
749     using SafeERC20 for IERC20;
750     using LibParam for bytes32;
751 
752     // keccak256 hash of "furucombo.handler.registry"
753     // prettier-ignore
754     bytes32 private constant HANDLER_REGISTRY = 0x6874162fd62902201ea0f4bf541086067b3b88bd802fac9e150fd2d1db584e19;
755 
756     constructor(address registry) public {
757         bytes32 slot = HANDLER_REGISTRY;
758         assembly {
759             sstore(slot, registry)
760         }
761     }
762 
763     /**
764      * @notice Direct transfer from EOA should be reverted.
765      * @dev Callback function will be handled here.
766      */
767     fallback() external payable {
768         require(Address.isContract(msg.sender), "Not allowed from EOA");
769 
770         // If triggered by a function call, caller should be registered in registry.
771         // The function call will then be forwarded to the location registered in
772         // registry.
773         if (msg.data.length != 0) {
774             require(_isValid(msg.sender), "Invalid caller");
775 
776             address target =
777                 address(bytes20(IRegistry(_getRegistry()).infos(msg.sender)));
778             bytes memory result = _exec(target, msg.data);
779 
780             // return result for aave v2 flashloan()
781             uint256 size = result.length;
782             assembly {
783                 let loc := add(result, 0x20)
784                 return(loc, size)
785             }
786         }
787     }
788 
789     /**
790      * @notice Combo execution function. Including three phases: pre-process,
791      * exection and post-process.
792      * @param tos The handlers of combo.
793      * @param configs The configurations of executing cubes.
794      * @param datas The combo datas.
795      */
796     function batchExec(
797         address[] memory tos,
798         bytes32[] memory configs,
799         bytes[] memory datas
800     ) public payable {
801         _preProcess();
802         _execs(tos, configs, datas);
803         _postProcess();
804     }
805 
806     /**
807      * @notice The execution interface for callback function to be executed.
808      * @dev This function can only be called through the handler, which makes
809      * the caller become proxy itself.
810      */
811     function execs(
812         address[] memory tos,
813         bytes32[] memory configs,
814         bytes[] memory datas
815     ) public payable {
816         require(msg.sender == address(this), "Does not allow external calls");
817         require(_getSender() != address(0), "Sender should be initialized");
818         _execs(tos, configs, datas);
819     }
820 
821     /**
822      * @notice The execution phase.
823      * @param tos The handlers of combo.
824      * @param configs The configurations of executing cubes.
825      * @param datas The combo datas.
826      */
827     function _execs(
828         address[] memory tos,
829         bytes32[] memory configs,
830         bytes[] memory datas
831     ) internal {
832         bytes32[256] memory localStack;
833         uint256 index = 0;
834 
835         require(
836             tos.length == datas.length,
837             "Tos and datas length inconsistent"
838         );
839         require(
840             tos.length == configs.length,
841             "Tos and configs length inconsistent"
842         );
843         for (uint256 i = 0; i < tos.length; i++) {
844             // Check if the data contains dynamic parameter
845             if (!configs[i].isStatic()) {
846                 // If so, trim the exectution data base on the configuration and stack content
847                 _trim(datas[i], configs[i], localStack, index);
848             }
849             // Check if the output will be referenced afterwards
850             if (configs[i].isReferenced()) {
851                 // If so, parse the output and place it into local stack
852                 uint256 num = configs[i].getReturnNum();
853                 uint256 newIndex =
854                     _parse(localStack, _exec(tos[i], datas[i]), index);
855                 require(
856                     newIndex == index + num,
857                     "Return num and parsed return num not matched"
858                 );
859                 index = newIndex;
860             } else {
861                 _exec(tos[i], datas[i]);
862             }
863             // Setup the process to be triggered in the post-process phase
864             _setPostProcess(tos[i]);
865         }
866     }
867 
868     /**
869      * @notice Trimming the execution data.
870      * @param data The execution data.
871      * @param config The configuration.
872      * @param localStack The stack the be referenced.
873      * @param index Current element count of localStack.
874      */
875     function _trim(
876         bytes memory data,
877         bytes32 config,
878         bytes32[256] memory localStack,
879         uint256 index
880     ) internal pure {
881         // Fetch the parameter configuration from config
882         (uint256[] memory refs, uint256[] memory params) = config.getParams();
883         // Trim the data with the reference and parameters
884         for (uint256 i = 0; i < refs.length; i++) {
885             require(refs[i] < index, "Reference to out of localStack");
886             bytes32 ref = localStack[refs[i]];
887             uint256 offset = params[i];
888             uint256 base = PERCENTAGE_BASE;
889             assembly {
890                 let loc := add(add(data, 0x20), offset)
891                 let m := mload(loc)
892                 // Adjust the value by multiplier if a dynamic parameter is not zero
893                 if iszero(iszero(m)) {
894                     // Assert no overflow first
895                     let p := mul(m, ref)
896                     if iszero(eq(div(p, m), ref)) {
897                         revert(0, 0)
898                     } // require(p / m == ref)
899                     ref := div(p, base)
900                 }
901                 mstore(loc, ref)
902             }
903         }
904     }
905 
906     /**
907      * @notice Parse the return data to the local stack.
908      * @param localStack The local stack to place the return values.
909      * @param ret The return data.
910      * @param index The current tail.
911      */
912     function _parse(
913         bytes32[256] memory localStack,
914         bytes memory ret,
915         uint256 index
916     ) internal pure returns (uint256 newIndex) {
917         uint256 len = ret.length;
918         // Estimate the tail after the process.
919         newIndex = index + len / 32;
920         require(newIndex <= 256, "stack overflow");
921         assembly {
922             let offset := shl(5, index)
923             // Store the data into localStack
924             for {
925                 let i := 0
926             } lt(i, len) {
927                 i := add(i, 0x20)
928             } {
929                 mstore(
930                     add(localStack, add(i, offset)),
931                     mload(add(add(ret, i), 0x20))
932                 )
933             }
934         }
935     }
936 
937     /**
938      * @notice The execution of a single cube.
939      * @param _to The handler of cube.
940      * @param _data The cube execution data.
941      */
942     function _exec(address _to, bytes memory _data)
943         internal
944         returns (bytes memory result)
945     {
946         require(_isValid(_to), "Invalid handler");
947         _addCubeCounter();
948         assembly {
949             let succeeded := delegatecall(
950                 sub(gas(), 5000),
951                 _to,
952                 add(_data, 0x20),
953                 mload(_data),
954                 0,
955                 0
956             )
957             let size := returndatasize()
958 
959             result := mload(0x40)
960             mstore(
961                 0x40,
962                 add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
963             )
964             mstore(result, size)
965             returndatacopy(add(result, 0x20), 0, size)
966 
967             switch iszero(succeeded)
968                 case 1 {
969                     revert(add(result, 0x20), size)
970                 }
971         }
972     }
973 
974     /**
975      * @notice Setup the post-process.
976      * @param _to The handler of post-process.
977      */
978     function _setPostProcess(address _to) internal {
979         // If the stack length equals 0, just skip
980         // If the top is a custom post-process, replace it with the handler
981         // address.
982         if (stack.length == 0) {
983             return;
984         } else if (
985             stack.peek() == bytes32(bytes12(uint96(HandlerType.Custom)))
986         ) {
987             stack.pop();
988             // Check if the handler is already set.
989             if (bytes4(stack.peek()) != 0x00000000) stack.setAddress(_to);
990             stack.setHandlerType(uint256(HandlerType.Custom));
991         }
992     }
993 
994     /// @notice The pre-process phase.
995     function _preProcess() internal virtual isStackEmpty isCubeCounterZero {
996         // Set the sender.
997         _setSender();
998     }
999 
1000     /// @notice The post-process phase.
1001     function _postProcess() internal {
1002         // If the top of stack is HandlerType.Custom (which makes it being zero
1003         // address when `stack.getAddress()`), get the handler address and execute
1004         // the handler with it and the post-process function selector.
1005         // If not, use it as token address and send the token back to user.
1006         while (stack.length > 0) {
1007             address addr = stack.getAddress();
1008             if (addr == address(0)) {
1009                 addr = stack.getAddress();
1010                 _exec(addr, abi.encodeWithSelector(POSTPROCESS_SIG));
1011             } else {
1012                 uint256 amount = IERC20(addr).balanceOf(address(this));
1013                 if (amount > 0) IERC20(addr).safeTransfer(msg.sender, amount);
1014             }
1015         }
1016 
1017         // Balance should also be returned to user
1018         uint256 amount = address(this).balance;
1019         if (amount > 0) msg.sender.transfer(amount);
1020 
1021         // Reset the msg.sender and cube counter
1022         _resetSender();
1023         _resetCubeCounter();
1024     }
1025 
1026     /// @notice Get the registry contract address.
1027     function _getRegistry() internal view returns (address registry) {
1028         bytes32 slot = HANDLER_REGISTRY;
1029         assembly {
1030             registry := sload(slot)
1031         }
1032     }
1033 
1034     /// @notice Check if the handler is valid in registry.
1035     function _isValid(address handler) internal view returns (bool result) {
1036         return IRegistry(_getRegistry()).isValid(handler);
1037     }
1038 }