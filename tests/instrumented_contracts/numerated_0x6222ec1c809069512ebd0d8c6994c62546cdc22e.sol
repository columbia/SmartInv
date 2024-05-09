1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
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
163 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
164 
165 // SPDX-License-Identifier: MIT
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Contract module that helps prevent reentrant calls to a function.
171  *
172  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
173  * available, which can be applied to functions to make sure there are no nested
174  * (reentrant) calls to them.
175  *
176  * Note that because there is a single `nonReentrant` guard, functions marked as
177  * `nonReentrant` may not call one another. This can be worked around by making
178  * those functions `private`, and then adding `external` `nonReentrant` entry
179  * points to them.
180  *
181  * TIP: If you would like to learn more about reentrancy and alternative ways
182  * to protect against it, check out our blog post
183  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
184  */
185 contract ReentrancyGuard {
186     // Booleans are more expensive than uint256 or any type that takes up a full
187     // word because each write operation emits an extra SLOAD to first read the
188     // slot's contents, replace the bits taken up by the boolean, and then write
189     // back. This is the compiler's defense against contract upgrades and
190     // pointer aliasing, and it cannot be disabled.
191 
192     // The values being non-zero value makes deployment a bit more expensive,
193     // but in exchange the refund on every call to nonReentrant will be lower in
194     // amount. Since refunds are capped to a percentage of the total
195     // transaction's gas, it is best to keep them low in cases like this one, to
196     // increase the likelihood of the full refund coming into effect.
197     uint256 private constant _NOT_ENTERED = 1;
198     uint256 private constant _ENTERED = 2;
199 
200     uint256 private _status;
201 
202     constructor () internal {
203         _status = _NOT_ENTERED;
204     }
205 
206     /**
207      * @dev Prevents a contract from calling itself, directly or indirectly.
208      * Calling a `nonReentrant` function from another `nonReentrant`
209      * function is not supported. It is possible to prevent this from happening
210      * by making the `nonReentrant` function external, and make it call a
211      * `private` function that does the actual work.
212      */
213     modifier nonReentrant() {
214         // On the first call to nonReentrant, _notEntered will be true
215         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
216 
217         // Any calls to nonReentrant after this point will fail
218         _status = _ENTERED;
219 
220         _;
221 
222         // By storing the original value once again, a refund is triggered (see
223         // https://eips.ethereum.org/EIPS/eip-2200)
224         _status = _NOT_ENTERED;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/GSN/Context.sol
229 
230 // SPDX-License-Identifier: MIT
231 
232 pragma solidity ^0.6.0;
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 // File: @openzeppelin/contracts/access/Ownable.sol
256 
257 // SPDX-License-Identifier: MIT
258 
259 pragma solidity ^0.6.0;
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor () internal {
282         address msgSender = _msgSender();
283         _owner = msgSender;
284         emit OwnershipTransferred(address(0), msgSender);
285     }
286 
287     /**
288      * @dev Returns the address of the current owner.
289      */
290     function owner() public view returns (address) {
291         return _owner;
292     }
293 
294     /**
295      * @dev Throws if called by any account other than the owner.
296      */
297     modifier onlyOwner() {
298         require(_owner == _msgSender(), "Ownable: caller is not the owner");
299         _;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public virtual onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         emit OwnershipTransferred(_owner, newOwner);
321         _owner = newOwner;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
326 
327 // SPDX-License-Identifier: MIT
328 
329 pragma solidity ^0.6.0;
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP.
333  */
334 interface IERC20 {
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 // File: @openzeppelin/contracts/utils/Address.sol
406 
407 // SPDX-License-Identifier: MIT
408 
409 pragma solidity ^0.6.2;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * [IMPORTANT]
419      * ====
420      * It is unsafe to assume that an address for which this function returns
421      * false is an externally-owned account (EOA) and not a contract.
422      *
423      * Among others, `isContract` will return false for the following
424      * types of addresses:
425      *
426      *  - an externally-owned account
427      *  - a contract in construction
428      *  - an address where a contract will be created
429      *  - an address where a contract lived, but was destroyed
430      * ====
431      */
432     function isContract(address account) internal view returns (bool) {
433         // This method relies in extcodesize, which returns 0 for contracts in
434         // construction, since the code is only stored at the end of the
435         // constructor execution.
436 
437         uint256 size;
438         // solhint-disable-next-line no-inline-assembly
439         assembly { size := extcodesize(account) }
440         return size > 0;
441     }
442 
443     /**
444      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
445      * `recipient`, forwarding all available gas and reverting on errors.
446      *
447      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
448      * of certain opcodes, possibly making contracts go over the 2300 gas limit
449      * imposed by `transfer`, making them unable to receive funds via
450      * `transfer`. {sendValue} removes this limitation.
451      *
452      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
453      *
454      * IMPORTANT: because control is transferred to `recipient`, care must be
455      * taken to not create reentrancy vulnerabilities. Consider using
456      * {ReentrancyGuard} or the
457      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
458      */
459     function sendValue(address payable recipient, uint256 amount) internal {
460         require(address(this).balance >= amount, "Address: insufficient balance");
461 
462         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
463         (bool success, ) = recipient.call{ value: amount }("");
464         require(success, "Address: unable to send value, recipient may have reverted");
465     }
466 
467     /**
468      * @dev Performs a Solidity function call using a low level `call`. A
469      * plain`call` is an unsafe replacement for a function call: use this
470      * function instead.
471      *
472      * If `target` reverts with a revert reason, it is bubbled up by this
473      * function (like regular Solidity function calls).
474      *
475      * Returns the raw returned data. To convert to the expected return value,
476      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
477      *
478      * Requirements:
479      *
480      * - `target` must be a contract.
481      * - calling `target` with `data` must not revert.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
486       return functionCall(target, data, "Address: low-level call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
491      * `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
496         return _functionCallWithValue(target, data, 0, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but also transferring `value` wei to `target`.
502      *
503      * Requirements:
504      *
505      * - the calling contract must have an ETH balance of at least `value`.
506      * - the called Solidity function must be `payable`.
507      *
508      * _Available since v3.1._
509      */
510     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
516      * with `errorMessage` as a fallback revert reason when `target` reverts.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
521         require(address(this).balance >= value, "Address: insufficient balance for call");
522         return _functionCallWithValue(target, data, value, errorMessage);
523     }
524 
525     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
526         require(isContract(target), "Address: call to non-contract");
527 
528         // solhint-disable-next-line avoid-low-level-calls
529         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 // solhint-disable-next-line no-inline-assembly
538                 assembly {
539                     let returndata_size := mload(returndata)
540                     revert(add(32, returndata), returndata_size)
541                 }
542             } else {
543                 revert(errorMessage);
544             }
545         }
546     }
547 }
548 
549 // File: contracts/PinkslipSale.sol
550 
551 pragma solidity 0.6.5;
552 
553 
554 
555 
556 
557 
558 contract PinkslipSale is ReentrancyGuard, Ownable {
559 
560     using SafeMath for uint256;
561     using Address for address payable;
562 
563     mapping(address => uint256) participants;
564 
565     uint256 public buyPrice;
566     uint256 public minimalGoal;
567     uint256 public hardCap;
568 
569     IERC20 crowdsaleToken;
570 
571     uint256 constant tokenDecimals = 18;
572 
573     event SellToken(address recepient, uint tokensSold, uint value);
574 
575     address payable fundingAddress;
576     uint256 public totalCollected;
577     uint256 public totalSold;
578     uint256 public start;
579     bool stopped = false;
580 
581     constructor(
582         IERC20 _token,
583         address payable _fundingAddress
584     ) public {
585         minimalGoal = 1000000000000000000;
586         hardCap = 500000000000000000000;
587         buyPrice = 114583333333333; // 0,000114583333333333 ETH
588         crowdsaleToken = _token;
589         fundingAddress = _fundingAddress;
590         start = getTime();
591     }
592 
593     function getToken()
594     external
595     view
596     returns(address)
597     {
598         return address(crowdsaleToken);
599     }
600 
601     receive() external payable {
602         require(msg.value >= 100000000000000000, 'PinkslipSale: Min 0.1 ETH');
603         require(participants[msg.sender] <= 3000000000000000000, 'PinkslipSale: Min 3 ETH');
604         sell(msg.sender, msg.value);
605     }
606 
607     function sell(address payable _recepient, uint256 _value) internal
608         nonReentrant
609         whenCrowdsaleAlive()
610     {
611         uint256 newTotalCollected = totalCollected.add(_value);
612 
613         if (hardCap < newTotalCollected) {
614             // Refund anything above the hard cap
615             uint256 refund = newTotalCollected.sub(hardCap);
616             uint256 diff = _value.sub(refund);
617             _recepient.sendValue(refund);
618             _value = diff;
619             newTotalCollected = totalCollected.add(_value);
620         }
621 
622         // Token amount per price
623         uint256 tokensSold = (_value).mul(10 ** tokenDecimals).div(buyPrice);
624 
625         // Send user tokens
626         require(crowdsaleToken.transfer(_recepient, tokensSold), 'PinkslipSale: Error transfering');
627 
628         emit SellToken(_recepient, tokensSold, _value);
629 
630         // Save participants
631         participants[_recepient] = participants[_recepient].add(_value);
632 
633         fundingAddress.sendValue(_value);
634 
635         // Update total BNB
636         totalCollected = totalCollected.add(_value);
637 
638         // Update tokens sold
639         totalSold = totalSold.add(tokensSold);
640     }
641 
642   function totalTokensNeeded() external view returns (uint256) {
643     return hardCap.mul(10 ** tokenDecimals).div(buyPrice);
644   }
645 
646   function stop()
647     external
648     onlyOwner()
649   {
650         stopped = true;
651   }
652 
653   function unstop()
654     external
655     onlyOwner()
656   {
657         stopped = false;
658   }
659 
660   function returnUnsold()
661     external
662     nonReentrant
663     onlyOwner()
664   {
665     crowdsaleToken.transfer(fundingAddress, crowdsaleToken.balanceOf(address(this)));
666   }
667 
668   function getTime()
669     public
670     view
671     returns(uint256)
672   {
673     return block.timestamp;
674   }
675 
676   function isActive()
677     public
678     view
679     returns(bool)
680   {
681     return (
682       totalCollected < hardCap && !stopped
683     );
684   }
685 
686   function isSuccessful()
687     external
688     view
689     returns(bool)
690   {
691     return (
692       totalCollected >= minimalGoal
693     );
694   }
695 
696   modifier whenCrowdsaleAlive() {
697     require(isActive());
698     _;
699   }
700 
701 }