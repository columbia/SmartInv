1 // File: localhost/contracts/Config.sol
2 
3 pragma solidity ^0.5.0;
4 
5 
6 contract Config {
7     // function signature of "postProcess()"
8     bytes4 constant POSTPROCESS_SIG = 0xc2722916;
9 
10     // Handler post-process type. Others should not happen now.
11     enum HandlerType {Token, Custom, Others}
12 }
13 
14 // File: localhost/contracts/lib/LibCache.sol
15 
16 pragma solidity ^0.5.0;
17 
18 
19 library LibCache {
20     function setAddress(bytes32[] storage _cache, address _input) internal {
21         _cache.push(bytes32(uint256(uint160(_input))));
22     }
23 
24     function set(bytes32[] storage _cache, bytes32 _input) internal {
25         _cache.push(_input);
26     }
27 
28     function setHandlerType(bytes32[] storage _cache, uint256 _input) internal {
29         require(_input < uint96(-1), "Invalid Handler Type");
30         _cache.push(bytes12(uint96(_input)));
31     }
32 
33     function setSender(bytes32[] storage _cache, address _input) internal {
34         require(_cache.length == 0, "cache not empty");
35         setAddress(_cache, _input);
36     }
37 
38     function getAddress(bytes32[] storage _cache)
39         internal
40         returns (address ret)
41     {
42         ret = address(uint160(uint256(peek(_cache))));
43         _cache.pop();
44     }
45 
46     function getSig(bytes32[] storage _cache) internal returns (bytes4 ret) {
47         ret = bytes4(peek(_cache));
48         _cache.pop();
49     }
50 
51     function get(bytes32[] storage _cache) internal returns (bytes32 ret) {
52         ret = peek(_cache);
53         _cache.pop();
54     }
55 
56     function peek(bytes32[] storage _cache)
57         internal
58         view
59         returns (bytes32 ret)
60     {
61         require(_cache.length > 0, "cache empty");
62         ret = _cache[_cache.length - 1];
63     }
64 
65     function getSender(bytes32[] storage _cache)
66         internal
67         returns (address ret)
68     {
69         require(_cache.length > 0, "cache empty");
70         ret = address(uint160(uint256(_cache[0])));
71     }
72 }
73 
74 // File: localhost/contracts/Cache.sol
75 
76 pragma solidity ^0.5.0;
77 
78 
79 
80 /// @notice A cache structure composed by a bytes32 array
81 contract Cache {
82     using LibCache for bytes32[];
83 
84     bytes32[] cache;
85 
86     modifier isCacheEmpty() {
87         require(cache.length == 0, "Cache not empty");
88         _;
89     }
90 }
91 
92 // File: localhost/contracts/interface/IRegistry.sol
93 
94 pragma solidity ^0.5.0;
95 
96 
97 interface IRegistry {
98     function isValid(address handler) external view returns (bool result);
99 
100     function getInfo(address handler) external view returns (bytes32 info);
101 }
102 
103 // File: @openzeppelin/contracts/utils/Address.sol
104 
105 pragma solidity ^0.5.5;
106 
107 /**
108  * @dev Collection of functions related to the address type
109  */
110 library Address {
111     /**
112      * @dev Returns true if `account` is a contract.
113      *
114      * [IMPORTANT]
115      * ====
116      * It is unsafe to assume that an address for which this function returns
117      * false is an externally-owned account (EOA) and not a contract.
118      *
119      * Among others, `isContract` will return false for the following 
120      * types of addresses:
121      *
122      *  - an externally-owned account
123      *  - a contract in construction
124      *  - an address where a contract will be created
125      *  - an address where a contract lived, but was destroyed
126      * ====
127      */
128     function isContract(address account) internal view returns (bool) {
129         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
130         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
131         // for accounts without code, i.e. `keccak256('')`
132         bytes32 codehash;
133         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
134         // solhint-disable-next-line no-inline-assembly
135         assembly { codehash := extcodehash(account) }
136         return (codehash != accountHash && codehash != 0x0);
137     }
138 
139     /**
140      * @dev Converts an `address` into `address payable`. Note that this is
141      * simply a type cast: the actual underlying value is not changed.
142      *
143      * _Available since v2.4.0._
144      */
145     function toPayable(address account) internal pure returns (address payable) {
146         return address(uint160(account));
147     }
148 
149     /**
150      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
151      * `recipient`, forwarding all available gas and reverting on errors.
152      *
153      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
154      * of certain opcodes, possibly making contracts go over the 2300 gas limit
155      * imposed by `transfer`, making them unable to receive funds via
156      * `transfer`. {sendValue} removes this limitation.
157      *
158      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
159      *
160      * IMPORTANT: because control is transferred to `recipient`, care must be
161      * taken to not create reentrancy vulnerabilities. Consider using
162      * {ReentrancyGuard} or the
163      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
164      *
165      * _Available since v2.4.0._
166      */
167     function sendValue(address payable recipient, uint256 amount) internal {
168         require(address(this).balance >= amount, "Address: insufficient balance");
169 
170         // solhint-disable-next-line avoid-call-value
171         (bool success, ) = recipient.call.value(amount)("");
172         require(success, "Address: unable to send value, recipient may have reverted");
173     }
174 }
175 
176 // File: @openzeppelin/contracts/math/SafeMath.sol
177 
178 pragma solidity ^0.5.0;
179 
180 /**
181  * @dev Wrappers over Solidity's arithmetic operations with added overflow
182  * checks.
183  *
184  * Arithmetic operations in Solidity wrap on overflow. This can easily result
185  * in bugs, because programmers usually assume that an overflow raises an
186  * error, which is the standard behavior in high level programming languages.
187  * `SafeMath` restores this intuition by reverting the transaction when an
188  * operation overflows.
189  *
190  * Using this library instead of the unchecked operations eliminates an entire
191  * class of bugs, so it's recommended to use it always.
192  */
193 library SafeMath {
194     /**
195      * @dev Returns the addition of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `+` operator.
199      *
200      * Requirements:
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         require(c >= a, "SafeMath: addition overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      * - Subtraction cannot overflow.
218      */
219     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
220         return sub(a, b, "SafeMath: subtraction overflow");
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * Counterpart to Solidity's `-` operator.
228      *
229      * Requirements:
230      * - Subtraction cannot overflow.
231      *
232      * _Available since v2.4.0._
233      */
234     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b <= a, errorMessage);
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `*` operator.
246      *
247      * Requirements:
248      * - Multiplication cannot overflow.
249      */
250     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
251         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
252         // benefit is lost if 'b' is also tested.
253         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
254         if (a == 0) {
255             return 0;
256         }
257 
258         uint256 c = a * b;
259         require(c / a == b, "SafeMath: multiplication overflow");
260 
261         return c;
262     }
263 
264     /**
265      * @dev Returns the integer division of two unsigned integers. Reverts on
266      * division by zero. The result is rounded towards zero.
267      *
268      * Counterpart to Solidity's `/` operator. Note: this function uses a
269      * `revert` opcode (which leaves remaining gas untouched) while Solidity
270      * uses an invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      * - The divisor cannot be zero.
289      *
290      * _Available since v2.4.0._
291      */
292     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
293         // Solidity only automatically asserts when dividing by 0
294         require(b > 0, errorMessage);
295         uint256 c = a / b;
296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      * - The divisor cannot be zero.
311      */
312     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
313         return mod(a, b, "SafeMath: modulo by zero");
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * Reverts with custom message when dividing by zero.
319      *
320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
321      * opcode (which leaves remaining gas untouched) while Solidity uses an
322      * invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      * - The divisor cannot be zero.
326      *
327      * _Available since v2.4.0._
328      */
329     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         require(b != 0, errorMessage);
331         return a % b;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
336 
337 pragma solidity ^0.5.0;
338 
339 /**
340  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
341  * the optional functions; to access them see {ERC20Detailed}.
342  */
343 interface IERC20 {
344     /**
345      * @dev Returns the amount of tokens in existence.
346      */
347     function totalSupply() external view returns (uint256);
348 
349     /**
350      * @dev Returns the amount of tokens owned by `account`.
351      */
352     function balanceOf(address account) external view returns (uint256);
353 
354     /**
355      * @dev Moves `amount` tokens from the caller's account to `recipient`.
356      *
357      * Returns a boolean value indicating whether the operation succeeded.
358      *
359      * Emits a {Transfer} event.
360      */
361     function transfer(address recipient, uint256 amount) external returns (bool);
362 
363     /**
364      * @dev Returns the remaining number of tokens that `spender` will be
365      * allowed to spend on behalf of `owner` through {transferFrom}. This is
366      * zero by default.
367      *
368      * This value changes when {approve} or {transferFrom} are called.
369      */
370     function allowance(address owner, address spender) external view returns (uint256);
371 
372     /**
373      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
374      *
375      * Returns a boolean value indicating whether the operation succeeded.
376      *
377      * IMPORTANT: Beware that changing an allowance with this method brings the risk
378      * that someone may use both the old and the new allowance by unfortunate
379      * transaction ordering. One possible solution to mitigate this race
380      * condition is to first reduce the spender's allowance to 0 and set the
381      * desired value afterwards:
382      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
383      *
384      * Emits an {Approval} event.
385      */
386     function approve(address spender, uint256 amount) external returns (bool);
387 
388     /**
389      * @dev Moves `amount` tokens from `sender` to `recipient` using the
390      * allowance mechanism. `amount` is then deducted from the caller's
391      * allowance.
392      *
393      * Returns a boolean value indicating whether the operation succeeded.
394      *
395      * Emits a {Transfer} event.
396      */
397     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Emitted when `value` tokens are moved from one account (`from`) to
401      * another (`to`).
402      *
403      * Note that `value` may be zero.
404      */
405     event Transfer(address indexed from, address indexed to, uint256 value);
406 
407     /**
408      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
409      * a call to {approve}. `value` is the new allowance.
410      */
411     event Approval(address indexed owner, address indexed spender, uint256 value);
412 }
413 
414 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
415 
416 pragma solidity ^0.5.0;
417 
418 
419 
420 
421 /**
422  * @title SafeERC20
423  * @dev Wrappers around ERC20 operations that throw on failure (when the token
424  * contract returns false). Tokens that return no value (and instead revert or
425  * throw on failure) are also supported, non-reverting calls are assumed to be
426  * successful.
427  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
428  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
429  */
430 library SafeERC20 {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     function safeTransfer(IERC20 token, address to, uint256 value) internal {
435         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
436     }
437 
438     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
439         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
440     }
441 
442     function safeApprove(IERC20 token, address spender, uint256 value) internal {
443         // safeApprove should only be called when setting an initial allowance,
444         // or when resetting it to zero. To increase and decrease it, use
445         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
446         // solhint-disable-next-line max-line-length
447         require((value == 0) || (token.allowance(address(this), spender) == 0),
448             "SafeERC20: approve from non-zero to non-zero allowance"
449         );
450         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
451     }
452 
453     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).add(value);
455         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
460         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     /**
464      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
465      * on the return value: the return value is optional (but if data is returned, it must not be false).
466      * @param token The token targeted by the call.
467      * @param data The call data (encoded using abi.encode or one of its variants).
468      */
469     function callOptionalReturn(IERC20 token, bytes memory data) private {
470         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
471         // we're implementing it ourselves.
472 
473         // A Solidity high level call has three parts:
474         //  1. The target address is checked to verify it contains contract code
475         //  2. The call itself is made, and success asserted
476         //  3. The return value is decoded, which in turn checks the size of the returned data.
477         // solhint-disable-next-line max-line-length
478         require(address(token).isContract(), "SafeERC20: call to non-contract");
479 
480         // solhint-disable-next-line avoid-low-level-calls
481         (bool success, bytes memory returndata) = address(token).call(data);
482         require(success, "SafeERC20: low-level call failed");
483 
484         if (returndata.length > 0) { // Return data is optional
485             // solhint-disable-next-line max-line-length
486             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
487         }
488     }
489 }
490 
491 // File: localhost/contracts/Proxy.sol
492 
493 pragma solidity ^0.5.0;
494 pragma experimental ABIEncoderV2;
495 
496 
497 
498 
499 
500 
501 
502 /**
503  * @title The entrance of Furucombo
504  * @author Ben Huang
505  */
506 contract Proxy is Cache, Config {
507     using Address for address;
508     using SafeERC20 for IERC20;
509 
510     // keccak256 hash of "furucombo.handler.registry"
511     bytes32 private constant HANDLER_REGISTRY = 0x6874162fd62902201ea0f4bf541086067b3b88bd802fac9e150fd2d1db584e19;
512 
513     constructor(address registry) public {
514         bytes32 slot = HANDLER_REGISTRY;
515         assembly {
516             sstore(slot, registry)
517         }
518     }
519 
520     /**
521      * @notice Direct transfer from EOA should be reverted.
522      * @dev Callback function will be handled here.
523      */
524     function() external payable {
525         require(Address.isContract(msg.sender), "Not allowed from EOA");
526 
527         // If triggered by a function call, caller should be registered in registry.
528         // The function call will then be forwarded to the location registered in
529         // registry.
530         if (msg.data.length != 0) {
531             require(_isValid(msg.sender), "Invalid caller");
532 
533             address target = address(
534                 bytes20(IRegistry(_getRegistry()).getInfo(msg.sender))
535             );
536             _exec(target, msg.data);
537         }
538     }
539 
540     /**
541      * @notice Combo execution function. Including three phases: pre-process,
542      * exection and post-process.
543      * @param tos The handlers of combo.
544      * @param datas The combo datas.
545      */
546     function batchExec(address[] memory tos, bytes[] memory datas)
547         public
548         payable
549     {
550         _preProcess();
551         _execs(tos, datas);
552         _postProcess();
553     }
554 
555     /**
556      * @notice The execution interface for callback function to be executed.
557      * @dev This function can only be called through the handler, which makes
558      * the caller become proxy itself.
559      */
560     function execs(address[] memory tos, bytes[] memory datas) public payable {
561         require(msg.sender == address(this), "Does not allow external calls");
562         _execs(tos, datas);
563     }
564 
565     /**
566      * @notice The execution phase.
567      * @param tos The handlers of combo.
568      * @param datas The combo datas.
569      */
570     function _execs(address[] memory tos, bytes[] memory datas) internal {
571         require(
572             tos.length == datas.length,
573             "Tos and datas length inconsistent"
574         );
575         for (uint256 i = 0; i < tos.length; i++) {
576             _exec(tos[i], datas[i]);
577             // Setup the process to be triggered in the post-process phase
578             _setPostProcess(tos[i]);
579         }
580     }
581 
582     /**
583      * @notice The execution of a single cube.
584      * @param _to The handler of cube.
585      * @param _data The cube execution data.
586      */
587     function _exec(address _to, bytes memory _data)
588         internal
589         returns (bytes memory result)
590     {
591         require(_isValid(_to), "Invalid handler");
592         assembly {
593             let succeeded := delegatecall(
594                 sub(gas, 5000),
595                 _to,
596                 add(_data, 0x20),
597                 mload(_data),
598                 0,
599                 0
600             )
601             let size := returndatasize
602 
603             result := mload(0x40)
604             mstore(
605                 0x40,
606                 add(result, and(add(add(size, 0x20), 0x1f), not(0x1f)))
607             )
608             mstore(result, size)
609             returndatacopy(add(result, 0x20), 0, size)
610 
611             switch iszero(succeeded)
612                 case 1 {
613                     revert(add(result, 0x20), size)
614                 }
615         }
616     }
617 
618     /**
619      * @notice Setup the post-process.
620      * @param _to The handler of post-process.
621      */
622     function _setPostProcess(address _to) internal {
623         // If the cache is empty, just skip
624         // If the top is a custom post-process, replace it with the handler
625         // address.
626         require(cache.length > 0, "cache empty");
627         if (cache.length == 1) return;
628         else if (cache.peek() == bytes32(bytes12(uint96(HandlerType.Custom)))) {
629             cache.pop();
630             // Check if the handler is already set.
631             if (bytes4(cache.peek()) != 0x00000000) cache.setAddress(_to);
632             cache.setHandlerType(uint256(HandlerType.Custom));
633         }
634     }
635 
636     /// @notice The pre-process phase.
637     function _preProcess() internal isCacheEmpty {
638         // Set the sender on the top of cache.
639         cache.setSender(msg.sender);
640     }
641 
642     /// @notice The post-process phase.
643     function _postProcess() internal {
644         // If the top of cache is HandlerType.Custom (which makes it being zero
645         // address when `cache.getAddress()`), get the handler address and execute
646         // the handler with it and the post-process function selector.
647         // If not, use it as token address and send the token back to user.
648         while (cache.length > 1) {
649             address addr = cache.getAddress();
650             if (addr == address(0)) {
651                 addr = cache.getAddress();
652                 _exec(addr, abi.encodeWithSelector(POSTPROCESS_SIG));
653             } else {
654                 uint256 amount = IERC20(addr).balanceOf(address(this));
655                 if (amount > 0) IERC20(addr).safeTransfer(msg.sender, amount);
656             }
657         }
658 
659         // Balance should also be returned to user
660         uint256 amount = address(this).balance;
661         if (amount > 0) msg.sender.transfer(amount);
662 
663         // Pop the msg.sender
664         cache.pop();
665     }
666 
667     /// @notice Get the registry contract address.
668     function _getRegistry() internal view returns (address registry) {
669         bytes32 slot = HANDLER_REGISTRY;
670         assembly {
671             registry := sload(slot)
672         }
673     }
674 
675     /// @notice Check if the handler is valid in registry.
676     function _isValid(address handler) internal view returns (bool result) {
677         return IRegistry(_getRegistry()).isValid(handler);
678     }
679 }