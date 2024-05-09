1 // File: contracts/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.2;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: contracts/Context.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity 0.6.2;
168 
169 /*
170  * @dev Provides information about the current execution context, including the
171  * sender of the transaction and its data. While these are generally available
172  * via msg.sender and msg.data, they should not be accessed in such a direct
173  * manner, since when dealing with GSN meta-transactions the account sending and
174  * paying for execution may not be the actual sender (as far as an application
175  * is concerned).
176  *
177  * This contract is only required for intermediate, library-like contracts.
178  */
179 abstract contract Context {
180     function _msgSender() internal view virtual returns (address payable) {
181         return msg.sender;
182     }
183 
184     function _msgData() internal view virtual returns (bytes memory) {
185         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
186         return msg.data;
187     }
188 }
189 
190 // File: contracts/Ownable.sol
191 
192 // SPDX-License-Identifier: MIT
193 
194 pragma solidity 0.6.2;
195 
196 /**
197  * @dev Contract module which provides a basic access control mechanism, where
198  * there is an account (an owner) that can be granted exclusive access to
199  * specific functions.
200  *
201  * By default, the owner account will be the one that deploys the contract. This
202  * can later be changed with {transferOwnership}.
203  *
204  * This module is used through inheritance. It will make available the modifier
205  * `onlyOwner`, which can be applied to your functions to restrict their use to
206  * the owner.
207  */
208 contract Ownable is Context {
209     address private _owner;
210 
211     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
212 
213     /**
214      * @dev Initializes the contract setting the deployer as the initial owner.
215      */
216     constructor () internal {
217         address msgSender = _msgSender();
218         _owner = msgSender;
219         emit OwnershipTransferred(address(0), msgSender);
220     }
221 
222     /**
223      * @dev Returns the address of the current owner.
224      */
225     function owner() public view returns (address) {
226         return _owner;
227     }
228 
229     /**
230      * @dev Throws if called by any account other than the owner.
231      */
232     modifier onlyOwner() {
233         require(_owner == _msgSender(), "Ownable: caller is not the owner");
234         _;
235     }
236 
237     /**
238      * @dev Leaves the contract without owner. It will not be possible to call
239      * `onlyOwner` functions anymore. Can only be called by the current owner.
240      *
241      * NOTE: Renouncing ownership will leave the contract without an owner,
242      * thereby removing any functionality that is only available to the owner.
243      */
244     function renounceOwnership() public virtual onlyOwner {
245         emit OwnershipTransferred(_owner, address(0));
246         _owner = address(0);
247     }
248 
249     /**
250      * @dev Transfers ownership of the contract to a new account (`newOwner`).
251      * Can only be called by the current owner.
252      */
253     function transferOwnership(address newOwner) public virtual onlyOwner {
254         require(newOwner != address(0), "Ownable: new owner is the zero address");
255         emit OwnershipTransferred(_owner, newOwner);
256         _owner = newOwner;
257     }
258 }
259 
260 // File: contracts/Address.sol
261 
262 // SPDX-License-Identifier: MIT
263 
264 pragma solidity 0.6.2;
265 
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // This method relies in extcodesize, which returns 0 for contracts in
289         // construction, since the code is only stored at the end of the
290         // constructor execution.
291 
292         uint256 size;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { size := extcodesize(account) }
295         return size > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
403 
404 // File: contracts/IERC20.sol
405 
406 // SPDX-License-Identifier: MIT
407 
408 pragma solidity 0.6.2;
409 
410 
411 /**
412  * @dev Interface of the ERC20 standard as defined in the EIP.
413  */
414 interface IERC20 {
415     /**
416      * @dev Returns the amount of tokens in existence.
417      */
418     function totalSupply() external view returns (uint256);
419 
420     /**
421      * @dev Returns the amount of tokens owned by `account`.
422      */
423     function balanceOf(address account) external view returns (uint256);
424 
425     /**
426      * @dev Moves `amount` tokens from the caller's account to `recipient`.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transfer(address recipient, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Returns the remaining number of tokens that `spender` will be
436      * allowed to spend on behalf of `owner` through {transferFrom}. This is
437      * zero by default.
438      *
439      * This value changes when {approve} or {transferFrom} are called.
440      */
441     function allowance(address owner, address spender) external view returns (uint256);
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
445      *
446      * Returns a boolean value indicating whether the operation succeeded.
447      *
448      * IMPORTANT: Beware that changing an allowance with this method brings the risk
449      * that someone may use both the old and the new allowance by unfortunate
450      * transaction ordering. One possible solution to mitigate this race
451      * condition is to first reduce the spender's allowance to 0 and set the
452      * desired value afterwards:
453      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
454      *
455      * Emits an {Approval} event.
456      */
457     function approve(address spender, uint256 amount) external returns (bool);
458 
459     /**
460      * @dev Moves `amount` tokens from `sender` to `recipient` using the
461      * allowance mechanism. `amount` is then deducted from the caller's
462      * allowance.
463      *
464      * Returns a boolean value indicating whether the operation succeeded.
465      *
466      * Emits a {Transfer} event.
467      */
468     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
469 
470     /**
471      * @dev Emitted when `value` tokens are moved from one account (`from`) to
472      * another (`to`).
473      *
474      * Note that `value` may be zero.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 value);
477 
478     /**
479      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
480      * a call to {approve}. `value` is the new allowance.
481      */
482     event Approval(address indexed owner, address indexed spender, uint256 value);
483 }
484 
485 // File: contracts/IBrainLootbox.sol
486 
487 pragma solidity 0.6.2;
488 
489 interface IBrainLootbox {
490   function getPrice(uint256 _id) external view returns (uint256);
491   function redeem(uint256 id, address to) external;
492 }
493 
494 // File: contracts/ReentrancyGuard.sol
495 
496 // SPDX-License-Identifier: MIT
497 
498 pragma solidity 0.6.2;
499 
500 /**
501  * @dev Contract module that helps prevent reentrant calls to a function.
502  *
503  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
504  * available, which can be applied to functions to make sure there are no nested
505  * (reentrant) calls to them.
506  *
507  * Note that because there is a single `nonReentrant` guard, functions marked as
508  * `nonReentrant` may not call one another. This can be worked around by making
509  * those functions `private`, and then adding `external` `nonReentrant` entry
510  * points to them.
511  *
512  * TIP: If you would like to learn more about reentrancy and alternative ways
513  * to protect against it, check out our blog post
514  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
515  */
516 contract ReentrancyGuard {
517     // Booleans are more expensive than uint256 or any type that takes up a full
518     // word because each write operation emits an extra SLOAD to first read the
519     // slot's contents, replace the bits taken up by the boolean, and then write
520     // back. This is the compiler's defense against contract upgrades and
521     // pointer aliasing, and it cannot be disabled.
522 
523     // The values being non-zero value makes deployment a bit more expensive,
524     // but in exchange the refund on every call to nonReentrant will be lower in
525     // amount. Since refunds are capped to a percentage of the total
526     // transaction's gas, it is best to keep them low in cases like this one, to
527     // increase the likelihood of the full refund coming into effect.
528     uint256 private constant _NOT_ENTERED = 1;
529     uint256 private constant _ENTERED = 2;
530 
531     uint256 private _status;
532 
533     constructor () internal {
534         _status = _NOT_ENTERED;
535     }
536 
537     /**
538      * @dev Prevents a contract from calling itself, directly or indirectly.
539      * Calling a `nonReentrant` function from another `nonReentrant`
540      * function is not supported. It is possible to prevent this from happening
541      * by making the `nonReentrant` function external, and make it call a
542      * `private` function that does the actual work.
543      */
544     modifier nonReentrant() {
545         // On the first call to nonReentrant, _notEntered will be true
546         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
547 
548         // Any calls to nonReentrant after this point will fail
549         _status = _ENTERED;
550 
551         _;
552 
553         // By storing the original value once again, a refund is triggered (see
554         // https://eips.ethereum.org/EIPS/eip-2200)
555         _status = _NOT_ENTERED;
556     }
557 }
558 
559 // File: contracts/BrainFarm.sol
560 
561 pragma solidity 0.6.2;
562 
563 
564 
565 
566 
567 
568 contract BrainFarm is Ownable, ReentrancyGuard {
569   using SafeMath for uint256;
570 
571   constructor(address _brain) public {
572     BrainAddress = _brain;
573   }
574 
575   address public BrainAddress;
576   address public LootboxAddress;
577 
578   function setLootboxAddress(address _address) public onlyOwner {
579     LootboxAddress = _address;
580   }
581 
582   mapping(address => uint256) private brainBalance;
583   mapping(address => uint256) public lastUpdateTime;
584   mapping(address => uint256) public points;
585 
586   event Staked(address indexed user, uint256 amount);
587   event Withdrawn(address indexed user, uint256 amount);
588 
589   modifier updateReward(address account) {
590     if (account != address(0)) {
591       points[account] = earned(account);
592       lastUpdateTime[account] = block.timestamp;
593     }
594     _;
595   }
596 
597   function balanceOf(address account) public view returns (uint256) {
598     return brainBalance[account];
599   }
600 
601   /*
602   The block.timestamp environment variable is used to determine a control flow decision. 
603   Note that the values of variables like coinbase, gaslimit, block number and timestamp are predictable and can be manipulated by a malicious miner. 
604   Also keep in mind that attackers know hashes of earlier blocks. 
605   Don't use any of those environment variables as sources of randomness and be aware that use of these variables introduces a certain level of trust into miners.
606   https://swcregistry.io/docs/SWC-116
607   
608   AUDITOR NOTE: It appers that intent of this function is to add incremental rewards over time.
609     Thus this vulnerability is not relly applicable to this function.
610   */
611   function earned(address account) public view returns (uint256) {
612     uint256 blockTime = block.timestamp;
613     return points[account].add(blockTime.sub(lastUpdateTime[account]).mul(1e18).div(86400).mul(balanceOf(account).div(1e18)));
614   }
615 
616   /*
617   An external message call to an address specified by the caller is executed.
618   Note that the callee account might contain arbitrary code and could re-enter any function within this contract. 
619   Reentering the contract in an intermediate state may lead to unexpected behaviour. 
620   Make sure that no state modifications are executed after this call and/or reentrancy guards are in place.
621   https://swcregistry.io/docs/SWC-107
622   
623   AUDITOR NOTE: Fix implmented, and vulnerable code commented out.
624   */
625   function stake(uint256 amount) public updateReward(_msgSender()) nonReentrant {
626     require(amount.add(balanceOf(_msgSender())) <= 5000000000000000000, "Cannot stake more than 5 BRAIN");
627     //IERC20(BrainAddress).transferFrom(_msgSender(), address(this), amount);
628     brainBalance[_msgSender()] = brainBalance[_msgSender()].add(amount);
629     IERC20(BrainAddress).transferFrom(_msgSender(), address(this), amount);
630     emit Staked(_msgSender(), amount);
631   }
632 
633   function withdraw(uint256 amount) public updateReward(_msgSender()) nonReentrant {
634     require(amount > 0, "Cannot withdraw 0");
635     require(amount <= balanceOf(_msgSender()), "Cannot withdraw more than balance");
636     IERC20(BrainAddress).transfer(_msgSender(), amount);
637     brainBalance[_msgSender()] = brainBalance[_msgSender()].sub(amount);
638     emit Withdrawn(_msgSender(), amount);
639   }
640 
641   function exit() external {
642     withdraw(balanceOf(_msgSender()));
643   }
644     
645   function redeem(uint256 _lootbox) public updateReward(_msgSender()) nonReentrant {
646     uint256 price = IBrainLootbox(LootboxAddress).getPrice(_lootbox);
647     require(price > 0, "Loot not found");
648     require(points[_msgSender()] >= price, "Not enough points to redeem");
649     IBrainLootbox(LootboxAddress).redeem(_lootbox, _msgSender());
650     points[_msgSender()] = points[_msgSender()].sub(price);
651   }
652 }