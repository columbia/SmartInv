1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 pragma solidity >=0.6.0 <0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a {Transfer} event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through {transferFrom}. This is
32      * zero by default.
33      *
34      * This value changes when {approve} or {transferFrom} are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * IMPORTANT: Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an {Approval} event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to {approve}. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: @openzeppelin/contracts/math/SafeMath.sol
81 
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /**
86  * @dev Wrappers over Solidity's arithmetic operations with added overflow
87  * checks.
88  *
89  * Arithmetic operations in Solidity wrap on overflow. This can easily result
90  * in bugs, because programmers usually assume that an overflow raises an
91  * error, which is the standard behavior in high level programming languages.
92  * `SafeMath` restores this intuition by reverting the transaction when an
93  * operation overflows.
94  *
95  * Using this library instead of the unchecked operations eliminates an entire
96  * class of bugs, so it's recommended to use it always.
97  */
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 
244 pragma solidity >=0.6.2 <0.8.0;
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // This method relies on extcodesize, which returns 0 for contracts in
269         // construction, since the code is only stored at the end of the
270         // constructor execution.
271 
272         uint256 size;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { size := extcodesize(account) }
275         return size > 0;
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         require(isContract(target), "Address: call to non-contract");
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{ value: value }(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
381         require(isContract(target), "Address: static call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.staticcall(data);
385         return _verifyCallResult(success, returndata, errorMessage);
386     }
387 
388     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
409 
410 
411 pragma solidity >=0.6.0 <0.8.0;
412 
413 
414 
415 
416 /**
417  * @title SafeERC20
418  * @dev Wrappers around ERC20 operations that throw on failure (when the token
419  * contract returns false). Tokens that return no value (and instead revert or
420  * throw on failure) are also supported, non-reverting calls are assumed to be
421  * successful.
422  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
423  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
424  */
425 library SafeERC20 {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     function safeTransfer(IERC20 token, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
431     }
432 
433     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
434         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
435     }
436 
437     /**
438      * @dev Deprecated. This function has issues similar to the ones found in
439      * {IERC20-approve}, and its usage is discouraged.
440      *
441      * Whenever possible, use {safeIncreaseAllowance} and
442      * {safeDecreaseAllowance} instead.
443      */
444     function safeApprove(IERC20 token, address spender, uint256 value) internal {
445         // safeApprove should only be called when setting an initial allowance,
446         // or when resetting it to zero. To increase and decrease it, use
447         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
448         // solhint-disable-next-line max-line-length
449         require((value == 0) || (token.allowance(address(this), spender) == 0),
450             "SafeERC20: approve from non-zero to non-zero allowance"
451         );
452         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
453     }
454 
455     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
456         uint256 newAllowance = token.allowance(address(this), spender).add(value);
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
458     }
459 
460     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
461         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
462         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
463     }
464 
465     /**
466      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
467      * on the return value: the return value is optional (but if data is returned, it must not be false).
468      * @param token The token targeted by the call.
469      * @param data The call data (encoded using abi.encode or one of its variants).
470      */
471     function _callOptionalReturn(IERC20 token, bytes memory data) private {
472         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
473         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
474         // the target address contains contract code and also asserts for success in the low-level call.
475 
476         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
477         if (returndata.length > 0) { // Return data is optional
478             // solhint-disable-next-line max-line-length
479             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
480         }
481     }
482 }
483 
484 // File: @openzeppelin/contracts/GSN/Context.sol
485 
486 
487 pragma solidity >=0.6.0 <0.8.0;
488 
489 /*
490  * @dev Provides information about the current execution context, including the
491  * sender of the transaction and its data. While these are generally available
492  * via msg.sender and msg.data, they should not be accessed in such a direct
493  * manner, since when dealing with GSN meta-transactions the account sending and
494  * paying for execution may not be the actual sender (as far as an application
495  * is concerned).
496  *
497  * This contract is only required for intermediate, library-like contracts.
498  */
499 abstract contract Context {
500     function _msgSender() internal view virtual returns (address payable) {
501         return msg.sender;
502     }
503 
504     function _msgData() internal view virtual returns (bytes memory) {
505         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
506         return msg.data;
507     }
508 }
509 
510 // File: @openzeppelin/contracts/access/Ownable.sol
511 
512 
513 pragma solidity >=0.6.0 <0.8.0;
514 
515 /**
516  * @dev Contract module which provides a basic access control mechanism, where
517  * there is an account (an owner) that can be granted exclusive access to
518  * specific functions.
519  *
520  * By default, the owner account will be the one that deploys the contract. This
521  * can later be changed with {transferOwnership}.
522  *
523  * This module is used through inheritance. It will make available the modifier
524  * `onlyOwner`, which can be applied to your functions to restrict their use to
525  * the owner.
526  */
527 abstract contract Ownable is Context {
528     address private _owner;
529 
530     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
531 
532     /**
533      * @dev Initializes the contract setting the deployer as the initial owner.
534      */
535     constructor () {
536         address msgSender = _msgSender();
537         _owner = msgSender;
538         emit OwnershipTransferred(address(0), msgSender);
539     }
540 
541     /**
542      * @dev Returns the address of the current owner.
543      */
544     function owner() public view returns (address) {
545         return _owner;
546     }
547 
548     /**
549      * @dev Throws if called by any account other than the owner.
550      */
551     modifier onlyOwner() {
552         require(_owner == _msgSender(), "Ownable: caller is not the owner");
553         _;
554     }
555 
556     /**
557      * @dev Leaves the contract without owner. It will not be possible to call
558      * `onlyOwner` functions anymore. Can only be called by the current owner.
559      *
560      * NOTE: Renouncing ownership will leave the contract without an owner,
561      * thereby removing any functionality that is only available to the owner.
562      */
563     function renounceOwnership() public virtual onlyOwner {
564         emit OwnershipTransferred(_owner, address(0));
565         _owner = address(0);
566     }
567 
568     /**
569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
570      * Can only be called by the current owner.
571      */
572     function transferOwnership(address newOwner) public virtual onlyOwner {
573         require(newOwner != address(0), "Ownable: new owner is the zero address");
574         emit OwnershipTransferred(_owner, newOwner);
575         _owner = newOwner;
576     }
577 }
578 
579 // File: contracts/ERC20Recovery.sol
580 
581 pragma solidity >=0.4.25 <0.9.0;
582 
583 
584 
585 abstract contract ERC20Recovery is Ownable{
586     using SafeERC20 for IERC20;
587     function recoverERC20(IERC20 token) external onlyOwner {
588         token.safeTransfer(owner(), token.balanceOf(address(this)));
589     }
590 }
591 
592 // File: contracts/GradualTokenSwap.sol
593 
594 pragma solidity 0.7.6;
595 // SPDX-License-Identifier: GPL-3.0-or-later
596 
597 
598 
599 /**
600  * @title GTS
601  * @dev A token swap contract that gradually releases tokens on its balance
602  */
603 contract GradualTokenSwap is ERC20Recovery {
604     // solhint-disable not-rely-on-time
605     using SafeMath for uint256;
606     using SafeERC20 for IERC20;
607 
608     event Withdrawn(address account, uint256 amount);
609 
610     // Durations and timestamps in UNIX time, also in block.timestamp.
611     uint256 public immutable start;
612     uint256 public immutable duration;
613     IERC20 public immutable rHEGIC;
614     IERC20 public immutable HEGIC;
615 
616     mapping(address => uint) public released;
617     mapping(address => uint) public provided;
618 
619     /**
620      * @dev Creates a contract that can be used for swapping rHEGIC into HEGIC
621      * @param _start UNIX time at which the unlock period starts
622      * @param _duration Duration in seconds for unlocking tokens
623      */
624     constructor (uint256 _start, uint256 _duration, IERC20 _rHEGIC, IERC20 _HEGIC) {
625         if(_start == 0) _start = block.timestamp;
626         require(_duration > 0, "GTS: duration is 0");
627 
628         duration = _duration;
629         start = _start;
630         rHEGIC =_rHEGIC;
631         HEGIC = _HEGIC;
632     }
633 
634     /**
635      * @dev Provide rHEGIC tokens to the contract for later exchange
636      */
637     function provide(uint amount) external {
638       rHEGIC.safeTransferFrom(msg.sender, address(this), amount);
639       provided[msg.sender] = provided[msg.sender].add(amount);
640     }
641 
642     /**
643      * @dev Withdraw unlocked user's HEGIC tokens
644      */
645     function withdraw() external {
646         uint amount = available(msg.sender);
647         require(amount > 0, "GTS: You are have not unlocked tokens yet");
648         released[msg.sender] = released[msg.sender].add(amount);
649         HEGIC.safeTransfer(msg.sender, amount);
650         emit Withdrawn(msg.sender, amount);
651     }
652 
653     /**
654      * @dev Calculates the amount of tokens that has already been unlocked but hasn't been swapped yet
655      */
656     function available(address account) public view returns (uint256) {
657         return unlocked(account).sub(released[account]);
658     }
659 
660     /**
661      * @dev Calculates the total amount of tokens that has already been unlocked
662      */
663     function unlocked(address account) public view returns (uint256) {
664         if(block.timestamp < start)
665             return 0;
666         if (block.timestamp >= start.add(duration)) {
667             return provided[account];
668         } else {
669             return provided[account].mul(block.timestamp.sub(start)).div(duration);
670         }
671     }
672 }