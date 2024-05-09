1 // File: localhost/contracts/Config.sol
2 
3 pragma solidity ^0.5.0;
4 
5 contract Config {
6     // function signature of "postProcess()"
7     bytes4 constant POSTPROCESS_SIG = 0xc2722916;
8 
9     // Handler post-process type. Others should not happen now.
10     enum HandlerType {Token, Custom, Others}
11 }
12 
13 // File: localhost/contracts/lib/LibCache.sol
14 
15 pragma solidity ^0.5.0;
16 
17 library LibCache {
18     function setAddress(bytes32[] storage _cache, address _input) internal {
19         _cache.push(bytes32(uint256(uint160(_input))));
20     }
21 
22     function set(bytes32[] storage _cache, bytes32 _input) internal {
23         _cache.push(_input);
24     }
25 
26     function setHandlerType(bytes32[] storage _cache, uint256 _input) internal {
27         require(_input < uint96(-1), "Invalid Handler Type");
28         _cache.push(bytes12(uint96(_input)));
29     }
30 
31     function setSender(bytes32[] storage _cache, address _input) internal {
32         require(_cache.length == 0, "cache not empty");
33         setAddress(_cache, _input);
34     }
35 
36     function getAddress(bytes32[] storage _cache)
37         internal
38         returns (address ret)
39     {
40         ret = address(uint160(uint256(peek(_cache))));
41         _cache.pop();
42     }
43 
44     function getSig(bytes32[] storage _cache) internal returns (bytes4 ret) {
45         ret = bytes4(peek(_cache));
46         _cache.pop();
47     }
48 
49     function get(bytes32[] storage _cache) internal returns (bytes32 ret) {
50         ret = peek(_cache);
51         _cache.pop();
52     }
53 
54     function peek(bytes32[] storage _cache)
55         internal
56         view
57         returns (bytes32 ret)
58     {
59         require(_cache.length > 0, "cache empty");
60         ret = _cache[_cache.length - 1];
61     }
62 
63     function getSender(bytes32[] storage _cache)
64         internal
65         returns (address ret)
66     {
67         require(_cache.length > 0, "cache empty");
68         ret = address(uint160(uint256(_cache[0])));
69     }
70 }
71 
72 // File: localhost/contracts/Cache.sol
73 
74 pragma solidity ^0.5.0;
75 
76 
77 /// @notice A cache structure composed by a bytes32 array
78 contract Cache {
79     using LibCache for bytes32[];
80 
81     bytes32[] cache;
82 
83     modifier isCacheEmpty() {
84         require(cache.length == 0, "Cache not empty");
85         _;
86     }
87 }
88 
89 // File: localhost/contracts/interface/IRegistry.sol
90 
91 pragma solidity ^0.5.0;
92 
93 
94 interface IRegistry {
95     function isValid(address handler) external view returns (bool result);
96 
97     function getInfo(address handler) external view returns (bytes32 info);
98 }
99 
100 // File: @openzeppelin/contracts/utils/Address.sol
101 
102 pragma solidity ^0.5.5;
103 
104 /**
105  * @dev Collection of functions related to the address type
106  */
107 library Address {
108     /**
109      * @dev Returns true if `account` is a contract.
110      *
111      * [IMPORTANT]
112      * ====
113      * It is unsafe to assume that an address for which this function returns
114      * false is an externally-owned account (EOA) and not a contract.
115      *
116      * Among others, `isContract` will return false for the following 
117      * types of addresses:
118      *
119      *  - an externally-owned account
120      *  - a contract in construction
121      *  - an address where a contract will be created
122      *  - an address where a contract lived, but was destroyed
123      * ====
124      */
125     function isContract(address account) internal view returns (bool) {
126         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
127         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
128         // for accounts without code, i.e. `keccak256('')`
129         bytes32 codehash;
130         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
131         // solhint-disable-next-line no-inline-assembly
132         assembly { codehash := extcodehash(account) }
133         return (codehash != accountHash && codehash != 0x0);
134     }
135 
136     /**
137      * @dev Converts an `address` into `address payable`. Note that this is
138      * simply a type cast: the actual underlying value is not changed.
139      *
140      * _Available since v2.4.0._
141      */
142     function toPayable(address account) internal pure returns (address payable) {
143         return address(uint160(account));
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      *
162      * _Available since v2.4.0._
163      */
164     function sendValue(address payable recipient, uint256 amount) internal {
165         require(address(this).balance >= amount, "Address: insufficient balance");
166 
167         // solhint-disable-next-line avoid-call-value
168         (bool success, ) = recipient.call.value(amount)("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 }
172 
173 // File: @openzeppelin/contracts/math/SafeMath.sol
174 
175 pragma solidity ^0.5.0;
176 
177 /**
178  * @dev Wrappers over Solidity's arithmetic operations with added overflow
179  * checks.
180  *
181  * Arithmetic operations in Solidity wrap on overflow. This can easily result
182  * in bugs, because programmers usually assume that an overflow raises an
183  * error, which is the standard behavior in high level programming languages.
184  * `SafeMath` restores this intuition by reverting the transaction when an
185  * operation overflows.
186  *
187  * Using this library instead of the unchecked operations eliminates an entire
188  * class of bugs, so it's recommended to use it always.
189  */
190 library SafeMath {
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      * - Addition cannot overflow.
199      */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a, "SafeMath: addition overflow");
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      * - Subtraction cannot overflow.
215      */
216     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217         return sub(a, b, "SafeMath: subtraction overflow");
218     }
219 
220     /**
221      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
222      * overflow (when the result is negative).
223      *
224      * Counterpart to Solidity's `-` operator.
225      *
226      * Requirements:
227      * - Subtraction cannot overflow.
228      *
229      * _Available since v2.4.0._
230      */
231     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b <= a, errorMessage);
233         uint256 c = a - b;
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `*` operator.
243      *
244      * Requirements:
245      * - Multiplication cannot overflow.
246      */
247     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
248         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
249         // benefit is lost if 'b' is also tested.
250         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
251         if (a == 0) {
252             return 0;
253         }
254 
255         uint256 c = a * b;
256         require(c / a == b, "SafeMath: multiplication overflow");
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the integer division of two unsigned integers. Reverts on
263      * division by zero. The result is rounded towards zero.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      * - The divisor cannot be zero.
271      */
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         return div(a, b, "SafeMath: division by zero");
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      * - The divisor cannot be zero.
286      *
287      * _Available since v2.4.0._
288      */
289     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
290         // Solidity only automatically asserts when dividing by 0
291         require(b > 0, errorMessage);
292         uint256 c = a / b;
293         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
294 
295         return c;
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * Reverts when dividing by zero.
301      *
302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
303      * opcode (which leaves remaining gas untouched) while Solidity uses an
304      * invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      * - The divisor cannot be zero.
308      */
309     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
310         return mod(a, b, "SafeMath: modulo by zero");
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts with custom message when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      * - The divisor cannot be zero.
323      *
324      * _Available since v2.4.0._
325      */
326     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b != 0, errorMessage);
328         return a % b;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
333 
334 pragma solidity ^0.5.0;
335 
336 /**
337  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
338  * the optional functions; to access them see {ERC20Detailed}.
339  */
340 interface IERC20 {
341     /**
342      * @dev Returns the amount of tokens in existence.
343      */
344     function totalSupply() external view returns (uint256);
345 
346     /**
347      * @dev Returns the amount of tokens owned by `account`.
348      */
349     function balanceOf(address account) external view returns (uint256);
350 
351     /**
352      * @dev Moves `amount` tokens from the caller's account to `recipient`.
353      *
354      * Returns a boolean value indicating whether the operation succeeded.
355      *
356      * Emits a {Transfer} event.
357      */
358     function transfer(address recipient, uint256 amount) external returns (bool);
359 
360     /**
361      * @dev Returns the remaining number of tokens that `spender` will be
362      * allowed to spend on behalf of `owner` through {transferFrom}. This is
363      * zero by default.
364      *
365      * This value changes when {approve} or {transferFrom} are called.
366      */
367     function allowance(address owner, address spender) external view returns (uint256);
368 
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * IMPORTANT: Beware that changing an allowance with this method brings the risk
375      * that someone may use both the old and the new allowance by unfortunate
376      * transaction ordering. One possible solution to mitigate this race
377      * condition is to first reduce the spender's allowance to 0 and set the
378      * desired value afterwards:
379      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
380      *
381      * Emits an {Approval} event.
382      */
383     function approve(address spender, uint256 amount) external returns (bool);
384 
385     /**
386      * @dev Moves `amount` tokens from `sender` to `recipient` using the
387      * allowance mechanism. `amount` is then deducted from the caller's
388      * allowance.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * Emits a {Transfer} event.
393      */
394     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Emitted when `value` tokens are moved from one account (`from`) to
398      * another (`to`).
399      *
400      * Note that `value` may be zero.
401      */
402     event Transfer(address indexed from, address indexed to, uint256 value);
403 
404     /**
405      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
406      * a call to {approve}. `value` is the new allowance.
407      */
408     event Approval(address indexed owner, address indexed spender, uint256 value);
409 }
410 
411 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
412 
413 pragma solidity ^0.5.0;
414 
415 
416 
417 
418 /**
419  * @title SafeERC20
420  * @dev Wrappers around ERC20 operations that throw on failure (when the token
421  * contract returns false). Tokens that return no value (and instead revert or
422  * throw on failure) are also supported, non-reverting calls are assumed to be
423  * successful.
424  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
425  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
426  */
427 library SafeERC20 {
428     using SafeMath for uint256;
429     using Address for address;
430 
431     function safeTransfer(IERC20 token, address to, uint256 value) internal {
432         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
433     }
434 
435     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
436         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
437     }
438 
439     function safeApprove(IERC20 token, address spender, uint256 value) internal {
440         // safeApprove should only be called when setting an initial allowance,
441         // or when resetting it to zero. To increase and decrease it, use
442         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
443         // solhint-disable-next-line max-line-length
444         require((value == 0) || (token.allowance(address(this), spender) == 0),
445             "SafeERC20: approve from non-zero to non-zero allowance"
446         );
447         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
448     }
449 
450     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
451         uint256 newAllowance = token.allowance(address(this), spender).add(value);
452         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
453     }
454 
455     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
456         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
457         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
458     }
459 
460     /**
461      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
462      * on the return value: the return value is optional (but if data is returned, it must not be false).
463      * @param token The token targeted by the call.
464      * @param data The call data (encoded using abi.encode or one of its variants).
465      */
466     function callOptionalReturn(IERC20 token, bytes memory data) private {
467         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
468         // we're implementing it ourselves.
469 
470         // A Solidity high level call has three parts:
471         //  1. The target address is checked to verify it contains contract code
472         //  2. The call itself is made, and success asserted
473         //  3. The return value is decoded, which in turn checks the size of the returned data.
474         // solhint-disable-next-line max-line-length
475         require(address(token).isContract(), "SafeERC20: call to non-contract");
476 
477         // solhint-disable-next-line avoid-low-level-calls
478         (bool success, bytes memory returndata) = address(token).call(data);
479         require(success, "SafeERC20: low-level call failed");
480 
481         if (returndata.length > 0) { // Return data is optional
482             // solhint-disable-next-line max-line-length
483             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
484         }
485     }
486 }
487 
488 // File: localhost/contracts/Proxy.sol
489 
490 pragma solidity ^0.5.0;
491 pragma experimental ABIEncoderV2;
492 
493 
494 
495 
496 
497 
498 /**
499  * @title The entrance of Furucombo
500  * @author Ben Huang
501  */
502 contract Proxy is Cache, Config {
503     using Address for address;
504     using SafeERC20 for IERC20;
505 
506     // keccak256 hash of "furucombo.handler.registry"
507     // prettier-ignore
508     bytes32 private constant HANDLER_REGISTRY = 0x6874162fd62902201ea0f4bf541086067b3b88bd802fac9e150fd2d1db584e19;
509 
510     constructor(address registry) public {
511         bytes32 slot = HANDLER_REGISTRY;
512         assembly {
513             sstore(slot, registry)
514         }
515     }
516 
517     /**
518      * @notice Direct transfer from EOA should be reverted.
519      * @dev Callback function will be handled here.
520      */
521     function() external payable {
522         require(Address.isContract(msg.sender), "Not allowed from EOA");
523 
524         // If triggered by a function call, caller should be registered in registry.
525         // The function call will then be forwarded to the location registered in
526         // registry.
527         if (msg.data.length != 0) {
528             require(_isValid(msg.sender), "Invalid caller");
529 
530             address target =
531                 address(bytes20(IRegistry(_getRegistry()).getInfo(msg.sender)));
532             _exec(target, msg.data);
533         }
534     }
535 
536     /**
537      * @notice Combo execution function. Including three phases: pre-process,
538      * exection and post-process.
539      * @param tos The handlers of combo.
540      * @param datas The combo datas.
541      */
542     function batchExec(address[] memory tos, bytes[] memory datas)
543         public
544         payable
545     {
546         _preProcess();
547         _execs(tos, datas);
548         _postProcess();
549     }
550 
551     /**
552      * @notice The execution interface for callback function to be executed.
553      * @dev This function can only be called through the handler, which makes
554      * the caller become proxy itself.
555      */
556     function execs(address[] memory tos, bytes[] memory datas) public payable {
557         require(msg.sender == address(this), "Does not allow external calls");
558         require(cache.length > 0, "Cache should be initialized");
559         _execs(tos, datas);
560     }
561 
562     /**
563      * @notice The execution phase.
564      * @param tos The handlers of combo.
565      * @param datas The combo datas.
566      */
567     function _execs(address[] memory tos, bytes[] memory datas) internal {
568         require(
569             tos.length == datas.length,
570             "Tos and datas length inconsistent"
571         );
572         for (uint256 i = 0; i < tos.length; i++) {
573             _exec(tos[i], datas[i]);
574             // Setup the process to be triggered in the post-process phase
575             _setPostProcess(tos[i]);
576         }
577     }
578 
579     /**
580      * @notice The execution of a single cube.
581      * @param _to The handler of cube.
582      * @param _data The cube execution data.
583      */
584     function _exec(address _to, bytes memory _data)
585         internal
586         returns (bytes memory result)
587     {
588         require(_isValid(_to), "Invalid handler");
589         assembly {
590             let succeeded := delegatecall(
591                 sub(gas, 5000),
592                 _to,
593                 add(_data, 0x20),
594                 mload(_data),
595                 0,
596                 0
597             )
598             let size := returndatasize
599 
600             result := mload(0x40)
601             mstore(
602                 0x40,
603                 add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
604             )
605             mstore(result, size)
606             returndatacopy(add(result, 0x20), 0, size)
607 
608             switch iszero(succeeded)
609                 case 1 {
610                     revert(add(result, 0x20), size)
611                 }
612         }
613     }
614 
615     /**
616      * @notice Setup the post-process.
617      * @param _to The handler of post-process.
618      */
619     function _setPostProcess(address _to) internal {
620         // If the cache length equals 1, just skip
621         // If the top is a custom post-process, replace it with the handler
622         // address.
623         require(cache.length > 0, "cache empty");
624         if (cache.length == 1) return;
625         else if (cache.peek() == bytes32(bytes12(uint96(HandlerType.Custom)))) {
626             cache.pop();
627             // Check if the handler is already set.
628             if (bytes4(cache.peek()) != 0x00000000) cache.setAddress(_to);
629             cache.setHandlerType(uint256(HandlerType.Custom));
630         }
631     }
632 
633     /// @notice The pre-process phase.
634     function _preProcess() internal isCacheEmpty {
635         // Set the sender on the top of cache.
636         cache.setSender(msg.sender);
637     }
638 
639     /// @notice The post-process phase.
640     function _postProcess() internal {
641         // If the top of cache is HandlerType.Custom (which makes it being zero
642         // address when `cache.getAddress()`), get the handler address and execute
643         // the handler with it and the post-process function selector.
644         // If not, use it as token address and send the token back to user.
645         while (cache.length > 1) {
646             address addr = cache.getAddress();
647             if (addr == address(0)) {
648                 addr = cache.getAddress();
649                 _exec(addr, abi.encodeWithSelector(POSTPROCESS_SIG));
650             } else {
651                 uint256 amount = IERC20(addr).balanceOf(address(this));
652                 if (amount > 0) IERC20(addr).safeTransfer(msg.sender, amount);
653             }
654         }
655 
656         // Balance should also be returned to user
657         uint256 amount = address(this).balance;
658         if (amount > 0) msg.sender.transfer(amount);
659 
660         // Pop the msg.sender
661         cache.pop();
662     }
663 
664     /// @notice Get the registry contract address.
665     function _getRegistry() internal view returns (address registry) {
666         bytes32 slot = HANDLER_REGISTRY;
667         assembly {
668             registry := sload(slot)
669         }
670     }
671 
672     /// @notice Check if the handler is valid in registry.
673     function _isValid(address handler) internal view returns (bool result) {
674         return IRegistry(_getRegistry()).isValid(handler);
675     }
676 }