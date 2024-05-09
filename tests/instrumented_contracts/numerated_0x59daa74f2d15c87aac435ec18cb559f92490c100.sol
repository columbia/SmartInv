1 // File: contracts/lib/LibParam.sol
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
40         uint256 n = REFS_LIMIT;
41         while (conf & REFS_MASK == REFS_MASK && n > 0) {
42             n--;
43             conf = conf >> 8;
44         }
45         require(n > 0, "No dynamic param");
46         refs = new uint256[](n);
47         params = new uint256[](n);
48         for (uint256 i = 0; i < n; i++) {
49             refs[i] = uint256(conf & REFS_MASK);
50             conf = conf >> 8;
51         }
52         uint256 i = 0;
53         for (uint256 k = 0; k < PARAMS_SIZE_LIMIT; k++) {
54             if (conf & PARAMS_MASK != 0) {
55                 require(i < n, "Location count exceeds ref count");
56                 params[i] = k * 32 + 4;
57                 i++;
58             }
59             conf = conf >> 1;
60         }
61         require(i == n, "Location count less than ref count");
62     }
63 }
64 
65 // File: contracts/lib/LibStack.sol
66 
67 pragma solidity ^0.6.0;
68 
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
79     function setHandlerType(bytes32[] storage _stack, Config.HandlerType _input)
80         internal
81     {
82         _stack.push(bytes12(uint96(_input)));
83     }
84 
85     function getAddress(bytes32[] storage _stack)
86         internal
87         returns (address ret)
88     {
89         ret = address(uint160(uint256(peek(_stack))));
90         _stack.pop();
91     }
92 
93     function getSig(bytes32[] storage _stack) internal returns (bytes4 ret) {
94         ret = bytes4(peek(_stack));
95         _stack.pop();
96     }
97 
98     function get(bytes32[] storage _stack) internal returns (bytes32 ret) {
99         ret = peek(_stack);
100         _stack.pop();
101     }
102 
103     function peek(bytes32[] storage _stack)
104         internal
105         view
106         returns (bytes32 ret)
107     {
108         require(_stack.length > 0, "stack empty");
109         ret = _stack[_stack.length - 1];
110     }
111 }
112 
113 // File: contracts/lib/LibCache.sol
114 
115 pragma solidity ^0.6.0;
116 
117 library LibCache {
118     function set(
119         mapping(bytes32 => bytes32) storage _cache,
120         bytes32 _key,
121         bytes32 _value
122     ) internal {
123         _cache[_key] = _value;
124     }
125 
126     function setAddress(
127         mapping(bytes32 => bytes32) storage _cache,
128         bytes32 _key,
129         address _value
130     ) internal {
131         _cache[_key] = bytes32(uint256(uint160(_value)));
132     }
133 
134     function setUint256(
135         mapping(bytes32 => bytes32) storage _cache,
136         bytes32 _key,
137         uint256 _value
138     ) internal {
139         _cache[_key] = bytes32(_value);
140     }
141 
142     function getAddress(
143         mapping(bytes32 => bytes32) storage _cache,
144         bytes32 _key
145     ) internal view returns (address ret) {
146         ret = address(uint160(uint256(_cache[_key])));
147     }
148 
149     function getUint256(
150         mapping(bytes32 => bytes32) storage _cache,
151         bytes32 _key
152     ) internal view returns (uint256 ret) {
153         ret = uint256(_cache[_key]);
154     }
155 
156     function get(mapping(bytes32 => bytes32) storage _cache, bytes32 _key)
157         internal
158         view
159         returns (bytes32 ret)
160     {
161         ret = _cache[_key];
162     }
163 }
164 
165 // File: contracts/Storage.sol
166 
167 pragma solidity ^0.6.0;
168 
169 
170 
171 /// @notice A cache structure composed by a bytes32 array
172 contract Storage {
173     using LibCache for mapping(bytes32 => bytes32);
174     using LibStack for bytes32[];
175 
176     bytes32[] public stack;
177     mapping(bytes32 => bytes32) public cache;
178 
179     // keccak256 hash of "msg.sender"
180     // prettier-ignore
181     bytes32 public constant MSG_SENDER_KEY = 0xb2f2618cecbbb6e7468cc0f2aa43858ad8d153e0280b22285e28e853bb9d453a;
182 
183     // keccak256 hash of "cube.counter"
184     // prettier-ignore
185     bytes32 public constant CUBE_COUNTER_KEY = 0xf9543f11459ccccd21306c8881aaab675ff49d988c1162fd1dd9bbcdbe4446be;
186 
187     modifier isStackEmpty() {
188         require(stack.length == 0, "Stack not empty");
189         _;
190     }
191 
192     modifier isCubeCounterZero() {
193         require(_getCubeCounter() == 0, "Cube counter not zero");
194         _;
195     }
196 
197     modifier isInitialized() {
198         require(_getSender() != address(0), "Sender is not initialized");
199         _;
200     }
201 
202     modifier isNotInitialized() {
203         require(_getSender() == address(0), "Sender is initialized");
204         _;
205     }
206 
207     function _setSender() internal isNotInitialized {
208         cache.setAddress(MSG_SENDER_KEY, msg.sender);
209     }
210 
211     function _resetSender() internal {
212         cache.setAddress(MSG_SENDER_KEY, address(0));
213     }
214 
215     function _getSender() internal view returns (address) {
216         return cache.getAddress(MSG_SENDER_KEY);
217     }
218 
219     function _addCubeCounter() internal {
220         cache.setUint256(CUBE_COUNTER_KEY, _getCubeCounter() + 1);
221     }
222 
223     function _resetCubeCounter() internal {
224         cache.setUint256(CUBE_COUNTER_KEY, 0);
225     }
226 
227     function _getCubeCounter() internal view returns (uint256) {
228         return cache.getUint256(CUBE_COUNTER_KEY);
229     }
230 }
231 
232 // File: contracts/Config.sol
233 
234 pragma solidity ^0.6.0;
235 
236 contract Config {
237     // function signature of "postProcess()"
238     bytes4 public constant POSTPROCESS_SIG = 0xc2722916;
239 
240     // The base amount of percentage function
241     uint256 public constant PERCENTAGE_BASE = 1 ether;
242 
243     // Handler post-process type. Others should not happen now.
244     enum HandlerType {Token, Custom, Others}
245 }
246 
247 // File: contracts/interface/IRegistry.sol
248 
249 pragma solidity ^0.6.0;
250 
251 interface IRegistry {
252     function handlers(address) external view returns (bytes32);
253     function callers(address) external view returns (bytes32);
254     function bannedAgents(address) external view returns (uint256);
255     function fHalt() external view returns (bool);
256     function isValidHandler(address handler) external view returns (bool);
257     function isValidCaller(address handler) external view returns (bool);
258 }
259 
260 // File: contracts/interface/IProxy.sol
261 
262 pragma solidity ^0.6.0;
263 pragma experimental ABIEncoderV2;
264 
265 interface IProxy {
266     function batchExec(address[] calldata tos, bytes32[] calldata configs, bytes[] memory datas) external payable;
267     function execs(address[] calldata tos, bytes32[] calldata configs, bytes[] memory datas) external payable;
268 }
269 
270 // File: @openzeppelin/contracts/utils/Address.sol
271 
272 // SPDX-License-Identifier: MIT
273 
274 pragma solidity >=0.6.2 <0.8.0;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // This method relies on extcodesize, which returns 0 for contracts in
299         // construction, since the code is only stored at the end of the
300         // constructor execution.
301 
302         uint256 size;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { size := extcodesize(account) }
305         return size > 0;
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: value }(data);
391         return _verifyCallResult(success, returndata, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but performing a static call.
397      *
398      * _Available since v3.3._
399      */
400     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
401         return functionStaticCall(target, data, "Address: low-level static call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
406      * but performing a static call.
407      *
408      * _Available since v3.3._
409      */
410     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.staticcall(data);
415         return _verifyCallResult(success, returndata, errorMessage);
416     }
417 
418     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
419         if (success) {
420             return returndata;
421         } else {
422             // Look for revert reason and bubble it up if present
423             if (returndata.length > 0) {
424                 // The easiest way to bubble the revert reason is using memory via assembly
425 
426                 // solhint-disable-next-line no-inline-assembly
427                 assembly {
428                     let returndata_size := mload(returndata)
429                     revert(add(32, returndata), returndata_size)
430                 }
431             } else {
432                 revert(errorMessage);
433             }
434         }
435     }
436 }
437 
438 // File: @openzeppelin/contracts/math/SafeMath.sol
439 
440 
441 pragma solidity >=0.6.0 <0.8.0;
442 
443 /**
444  * @dev Wrappers over Solidity's arithmetic operations with added overflow
445  * checks.
446  *
447  * Arithmetic operations in Solidity wrap on overflow. This can easily result
448  * in bugs, because programmers usually assume that an overflow raises an
449  * error, which is the standard behavior in high level programming languages.
450  * `SafeMath` restores this intuition by reverting the transaction when an
451  * operation overflows.
452  *
453  * Using this library instead of the unchecked operations eliminates an entire
454  * class of bugs, so it's recommended to use it always.
455  */
456 library SafeMath {
457     /**
458      * @dev Returns the addition of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `+` operator.
462      *
463      * Requirements:
464      *
465      * - Addition cannot overflow.
466      */
467     function add(uint256 a, uint256 b) internal pure returns (uint256) {
468         uint256 c = a + b;
469         require(c >= a, "SafeMath: addition overflow");
470 
471         return c;
472     }
473 
474     /**
475      * @dev Returns the subtraction of two unsigned integers, reverting on
476      * overflow (when the result is negative).
477      *
478      * Counterpart to Solidity's `-` operator.
479      *
480      * Requirements:
481      *
482      * - Subtraction cannot overflow.
483      */
484     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
485         return sub(a, b, "SafeMath: subtraction overflow");
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
499         require(b <= a, errorMessage);
500         uint256 c = a - b;
501 
502         return c;
503     }
504 
505     /**
506      * @dev Returns the multiplication of two unsigned integers, reverting on
507      * overflow.
508      *
509      * Counterpart to Solidity's `*` operator.
510      *
511      * Requirements:
512      *
513      * - Multiplication cannot overflow.
514      */
515     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
516         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
517         // benefit is lost if 'b' is also tested.
518         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
519         if (a == 0) {
520             return 0;
521         }
522 
523         uint256 c = a * b;
524         require(c / a == b, "SafeMath: multiplication overflow");
525 
526         return c;
527     }
528 
529     /**
530      * @dev Returns the integer division of two unsigned integers. Reverts on
531      * division by zero. The result is rounded towards zero.
532      *
533      * Counterpart to Solidity's `/` operator. Note: this function uses a
534      * `revert` opcode (which leaves remaining gas untouched) while Solidity
535      * uses an invalid opcode to revert (consuming all remaining gas).
536      *
537      * Requirements:
538      *
539      * - The divisor cannot be zero.
540      */
541     function div(uint256 a, uint256 b) internal pure returns (uint256) {
542         return div(a, b, "SafeMath: division by zero");
543     }
544 
545     /**
546      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
547      * division by zero. The result is rounded towards zero.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         uint256 c = a / b;
560         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
561 
562         return c;
563     }
564 
565     /**
566      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
567      * Reverts when dividing by zero.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
578         return mod(a, b, "SafeMath: modulo by zero");
579     }
580 
581     /**
582      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
583      * Reverts with custom message when dividing by zero.
584      *
585      * Counterpart to Solidity's `%` operator. This function uses a `revert`
586      * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
594         require(b != 0, errorMessage);
595         return a % b;
596     }
597 }
598 
599 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
600 
601 
602 pragma solidity >=0.6.0 <0.8.0;
603 
604 /**
605  * @dev Interface of the ERC20 standard as defined in the EIP.
606  */
607 interface IERC20 {
608     /**
609      * @dev Returns the amount of tokens in existence.
610      */
611     function totalSupply() external view returns (uint256);
612 
613     /**
614      * @dev Returns the amount of tokens owned by `account`.
615      */
616     function balanceOf(address account) external view returns (uint256);
617 
618     /**
619      * @dev Moves `amount` tokens from the caller's account to `recipient`.
620      *
621      * Returns a boolean value indicating whether the operation succeeded.
622      *
623      * Emits a {Transfer} event.
624      */
625     function transfer(address recipient, uint256 amount) external returns (bool);
626 
627     /**
628      * @dev Returns the remaining number of tokens that `spender` will be
629      * allowed to spend on behalf of `owner` through {transferFrom}. This is
630      * zero by default.
631      *
632      * This value changes when {approve} or {transferFrom} are called.
633      */
634     function allowance(address owner, address spender) external view returns (uint256);
635 
636     /**
637      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
638      *
639      * Returns a boolean value indicating whether the operation succeeded.
640      *
641      * IMPORTANT: Beware that changing an allowance with this method brings the risk
642      * that someone may use both the old and the new allowance by unfortunate
643      * transaction ordering. One possible solution to mitigate this race
644      * condition is to first reduce the spender's allowance to 0 and set the
645      * desired value afterwards:
646      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address spender, uint256 amount) external returns (bool);
651 
652     /**
653      * @dev Moves `amount` tokens from `sender` to `recipient` using the
654      * allowance mechanism. `amount` is then deducted from the caller's
655      * allowance.
656      *
657      * Returns a boolean value indicating whether the operation succeeded.
658      *
659      * Emits a {Transfer} event.
660      */
661     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
662 
663     /**
664      * @dev Emitted when `value` tokens are moved from one account (`from`) to
665      * another (`to`).
666      *
667      * Note that `value` may be zero.
668      */
669     event Transfer(address indexed from, address indexed to, uint256 value);
670 
671     /**
672      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
673      * a call to {approve}. `value` is the new allowance.
674      */
675     event Approval(address indexed owner, address indexed spender, uint256 value);
676 }
677 
678 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
679 
680 
681 pragma solidity >=0.6.0 <0.8.0;
682 
683 
684 
685 
686 /**
687  * @title SafeERC20
688  * @dev Wrappers around ERC20 operations that throw on failure (when the token
689  * contract returns false). Tokens that return no value (and instead revert or
690  * throw on failure) are also supported, non-reverting calls are assumed to be
691  * successful.
692  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
693  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
694  */
695 library SafeERC20 {
696     using SafeMath for uint256;
697     using Address for address;
698 
699     function safeTransfer(IERC20 token, address to, uint256 value) internal {
700         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
701     }
702 
703     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
704         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
705     }
706 
707     /**
708      * @dev Deprecated. This function has issues similar to the ones found in
709      * {IERC20-approve}, and its usage is discouraged.
710      *
711      * Whenever possible, use {safeIncreaseAllowance} and
712      * {safeDecreaseAllowance} instead.
713      */
714     function safeApprove(IERC20 token, address spender, uint256 value) internal {
715         // safeApprove should only be called when setting an initial allowance,
716         // or when resetting it to zero. To increase and decrease it, use
717         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
718         // solhint-disable-next-line max-line-length
719         require((value == 0) || (token.allowance(address(this), spender) == 0),
720             "SafeERC20: approve from non-zero to non-zero allowance"
721         );
722         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
723     }
724 
725     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
726         uint256 newAllowance = token.allowance(address(this), spender).add(value);
727         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
728     }
729 
730     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
731         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
732         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
733     }
734 
735     /**
736      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
737      * on the return value: the return value is optional (but if data is returned, it must not be false).
738      * @param token The token targeted by the call.
739      * @param data The call data (encoded using abi.encode or one of its variants).
740      */
741     function _callOptionalReturn(IERC20 token, bytes memory data) private {
742         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
743         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
744         // the target address contains contract code and also asserts for success in the low-level call.
745 
746         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
747         if (returndata.length > 0) { // Return data is optional
748             // solhint-disable-next-line max-line-length
749             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
750         }
751     }
752 }
753 
754 // File: contracts/Proxy.sol
755 
756 pragma solidity ^0.6.0;
757 
758 
759 
760 
761 
762 
763 
764 /**
765  * @title The entrance of Furucombo
766  * @author Ben Huang
767  */
768 contract Proxy is IProxy, Storage, Config {
769     using Address for address;
770     using SafeERC20 for IERC20;
771     using LibParam for bytes32;
772 
773     modifier isNotBanned() {
774         require(registry.bannedAgents(address(this)) == 0, "Banned");
775         _;
776     }
777 
778     modifier isNotHalted() {
779         require(registry.fHalt() == false, "Halted");
780         _;
781     }
782 
783     IRegistry public immutable registry;
784 
785     constructor(address _registry) public {
786         registry = IRegistry(_registry);
787     }
788 
789     /**
790      * @notice Direct transfer from EOA should be reverted.
791      * @dev Callback function will be handled here.
792      */
793     fallback() external payable isNotHalted isNotBanned isInitialized {
794         // If triggered by a function call, caller should be registered in
795         // registry.
796         // The function call will then be forwarded to the location registered
797         // in registry.
798         require(_isValidCaller(msg.sender), "Invalid caller");
799 
800         address target = address(bytes20(registry.callers(msg.sender)));
801         bytes memory result = _exec(target, msg.data);
802 
803         // return result for aave v2 flashloan()
804         uint256 size = result.length;
805         assembly {
806             let loc := add(result, 0x20)
807             return(loc, size)
808         }
809     }
810 
811     /**
812      * @notice Direct transfer from EOA should be reverted.
813      */
814     receive() external payable {
815         require(Address.isContract(msg.sender), "Not allowed from EOA");
816     }
817 
818     /**
819      * @notice Combo execution function. Including three phases: pre-process,
820      * exection and post-process.
821      * @param tos The handlers of combo.
822      * @param configs The configurations of executing cubes.
823      * @param datas The combo datas.
824      */
825     function batchExec(
826         address[] calldata tos,
827         bytes32[] calldata configs,
828         bytes[] memory datas
829     ) external payable override isNotHalted isNotBanned {
830         _preProcess();
831         _execs(tos, configs, datas);
832         _postProcess();
833     }
834 
835     /**
836      * @notice The execution interface for callback function to be executed.
837      * @dev This function can only be called through the handler, which makes
838      * the caller become proxy itself.
839      */
840     function execs(
841         address[] calldata tos,
842         bytes32[] calldata configs,
843         bytes[] memory datas
844     ) external payable override isNotHalted isNotBanned isInitialized {
845         require(msg.sender == address(this), "Does not allow external calls");
846         _execs(tos, configs, datas);
847     }
848 
849     /**
850      * @notice The execution phase.
851      * @param tos The handlers of combo.
852      * @param configs The configurations of executing cubes.
853      * @param datas The combo datas.
854      */
855     function _execs(
856         address[] memory tos,
857         bytes32[] memory configs,
858         bytes[] memory datas
859     ) internal {
860         bytes32[256] memory localStack;
861         uint256 index = 0;
862 
863         require(
864             tos.length == datas.length,
865             "Tos and datas length inconsistent"
866         );
867         require(
868             tos.length == configs.length,
869             "Tos and configs length inconsistent"
870         );
871         for (uint256 i = 0; i < tos.length; i++) {
872             bytes32 config = configs[i];
873             // Check if the data contains dynamic parameter
874             if (!config.isStatic()) {
875                 // If so, trim the exectution data base on the configuration and stack content
876                 _trim(datas[i], config, localStack, index);
877             }
878             // Check if the output will be referenced afterwards
879             bytes memory result = _exec(tos[i], datas[i]);
880             if (config.isReferenced()) {
881                 // If so, parse the output and place it into local stack
882                 uint256 num = config.getReturnNum();
883                 uint256 newIndex = _parse(localStack, result, index);
884                 require(
885                     newIndex == index + num,
886                     "Return num and parsed return num not matched"
887                 );
888                 index = newIndex;
889             }
890 
891             // Setup the process to be triggered in the post-process phase
892             _setPostProcess(tos[i]);
893         }
894     }
895 
896     /**
897      * @notice Trimming the execution data.
898      * @param data The execution data.
899      * @param config The configuration.
900      * @param localStack The stack the be referenced.
901      * @param index Current element count of localStack.
902      */
903     function _trim(
904         bytes memory data,
905         bytes32 config,
906         bytes32[256] memory localStack,
907         uint256 index
908     ) internal pure {
909         // Fetch the parameter configuration from config
910         (uint256[] memory refs, uint256[] memory params) = config.getParams();
911         // Trim the data with the reference and parameters
912         for (uint256 i = 0; i < refs.length; i++) {
913             require(refs[i] < index, "Reference to out of localStack");
914             bytes32 ref = localStack[refs[i]];
915             uint256 offset = params[i];
916             uint256 base = PERCENTAGE_BASE;
917             assembly {
918                 let loc := add(add(data, 0x20), offset)
919                 let m := mload(loc)
920                 // Adjust the value by multiplier if a dynamic parameter is not zero
921                 if iszero(iszero(m)) {
922                     // Assert no overflow first
923                     let p := mul(m, ref)
924                     if iszero(eq(div(p, m), ref)) {
925                         revert(0, 0)
926                     } // require(p / m == ref)
927                     ref := div(p, base)
928                 }
929                 mstore(loc, ref)
930             }
931         }
932     }
933 
934     /**
935      * @notice Parse the return data to the local stack.
936      * @param localStack The local stack to place the return values.
937      * @param ret The return data.
938      * @param index The current tail.
939      */
940     function _parse(
941         bytes32[256] memory localStack,
942         bytes memory ret,
943         uint256 index
944     ) internal pure returns (uint256 newIndex) {
945         uint256 len = ret.length;
946         // The return value should be multiple of 32-bytes to be parsed.
947         require(len % 32 == 0, "illegal length for _parse");
948         // Estimate the tail after the process.
949         newIndex = index + len / 32;
950         require(newIndex <= 256, "stack overflow");
951         assembly {
952             let offset := shl(5, index)
953             // Store the data into localStack
954             for {
955                 let i := 0
956             } lt(i, len) {
957                 i := add(i, 0x20)
958             } {
959                 mstore(
960                     add(localStack, add(i, offset)),
961                     mload(add(add(ret, i), 0x20))
962                 )
963             }
964         }
965     }
966 
967     /**
968      * @notice The execution of a single cube.
969      * @param _to The handler of cube.
970      * @param _data The cube execution data.
971      */
972     function _exec(address _to, bytes memory _data)
973         internal
974         returns (bytes memory result)
975     {
976         require(_isValidHandler(_to), "Invalid handler");
977         _addCubeCounter();
978         assembly {
979             let succeeded := delegatecall(
980                 sub(gas(), 5000),
981                 _to,
982                 add(_data, 0x20),
983                 mload(_data),
984                 0,
985                 0
986             )
987             let size := returndatasize()
988 
989             result := mload(0x40)
990             mstore(
991                 0x40,
992                 add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
993             )
994             mstore(result, size)
995             returndatacopy(add(result, 0x20), 0, size)
996 
997             switch iszero(succeeded)
998                 case 1 {
999                     revert(add(result, 0x20), size)
1000                 }
1001         }
1002     }
1003 
1004     /**
1005      * @notice Setup the post-process.
1006      * @param _to The handler of post-process.
1007      */
1008     function _setPostProcess(address _to) internal {
1009         // If the stack length equals 0, just skip
1010         // If the top is a custom post-process, replace it with the handler
1011         // address.
1012         if (stack.length == 0) {
1013             return;
1014         } else if (
1015             stack.peek() == bytes32(bytes12(uint96(HandlerType.Custom)))
1016         ) {
1017             stack.pop();
1018             // Check if the handler is already set.
1019             if (bytes4(stack.peek()) != 0x00000000) stack.setAddress(_to);
1020             stack.setHandlerType(HandlerType.Custom);
1021         }
1022     }
1023 
1024     /// @notice The pre-process phase.
1025     function _preProcess() internal virtual isStackEmpty isCubeCounterZero {
1026         // Set the sender.
1027         _setSender();
1028     }
1029 
1030     /// @notice The post-process phase.
1031     function _postProcess() internal {
1032         // Handler type will be parsed at the beginning. Will send the token back to
1033         // user if the handler type is "Token". Will get the handler address and
1034         // execute the customized post-process if handler type is "Custom".
1035         while (stack.length > 0) {
1036             bytes32 top = stack.get();
1037             // Get handler type
1038             HandlerType handlerType = HandlerType(uint96(bytes12(top)));
1039             if (handlerType == HandlerType.Token) {
1040                 address addr = address(uint160(uint256(top)));
1041                 uint256 amount = IERC20(addr).balanceOf(address(this));
1042                 if (amount > 0) IERC20(addr).safeTransfer(msg.sender, amount);
1043             } else if (handlerType == HandlerType.Custom) {
1044                 address addr = stack.getAddress();
1045                 _exec(addr, abi.encodeWithSelector(POSTPROCESS_SIG));
1046             } else {
1047                 revert("Invalid handler type");
1048             }
1049         }
1050 
1051         // Balance should also be returned to user
1052         uint256 amount = address(this).balance;
1053         if (amount > 0) msg.sender.transfer(amount);
1054 
1055         // Reset the msg.sender and cube counter
1056         _resetSender();
1057         _resetCubeCounter();
1058     }
1059 
1060     /// @notice Check if the handler is valid in registry.
1061     function _isValidHandler(address handler) internal view returns (bool) {
1062         return registry.isValidHandler(handler);
1063     }
1064 
1065     /// @notice Check if the caller is valid in registry.
1066     function _isValidCaller(address caller) internal view returns (bool) {
1067         return registry.isValidCaller(caller);
1068     }
1069 }