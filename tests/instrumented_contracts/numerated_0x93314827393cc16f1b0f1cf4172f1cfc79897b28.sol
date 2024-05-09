1 // File: contracts/IERC20Cutted.sol
2 
3 pragma solidity ^0.6.2;
4 
5 
6 interface IERC20Cutted {
7 
8     // Some old tokens are implemented without a retrun parameter (this was prior to the ERC20 standart change)
9     function transfer(address to, uint256 value) external;
10 
11     function balanceOf(address who) external view returns (uint256);
12 
13 }
14 
15 // File: @openzeppelin/contracts/GSN/Context.sol
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity >=0.6.0 <0.8.0;
20 
21 /*
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with GSN meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address payable) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes memory) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 // File: @openzeppelin/contracts/access/Ownable.sol
43 
44 
45 pragma solidity >=0.6.0 <0.8.0;
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 abstract contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor () internal {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: contracts/RetrieveTokensFeature.sol
112 
113 pragma solidity ^0.6.2;
114 
115 
116 
117 
118 
119 contract RetrieveTokensFeature is Context, Ownable {
120 
121     function retrieveTokens(address to, address anotherToken) virtual public onlyOwner() {
122         IERC20Cutted alienToken = IERC20Cutted(anotherToken);
123         alienToken.transfer(to, alienToken.balanceOf(address(this)));
124     }
125 
126     function retriveETH(address payable to) virtual public onlyOwner() {
127         to.transfer(address(this).balance);
128     }
129 
130 }
131 
132 // File: @openzeppelin/contracts/math/SafeMath.sol
133 
134 
135 pragma solidity >=0.6.0 <0.8.0;
136 
137 /**
138  * @dev Wrappers over Solidity's arithmetic operations with added overflow
139  * checks.
140  *
141  * Arithmetic operations in Solidity wrap on overflow. This can easily result
142  * in bugs, because programmers usually assume that an overflow raises an
143  * error, which is the standard behavior in high level programming languages.
144  * `SafeMath` restores this intuition by reverting the transaction when an
145  * operation overflows.
146  *
147  * Using this library instead of the unchecked operations eliminates an entire
148  * class of bugs, so it's recommended to use it always.
149  */
150 library SafeMath {
151     /**
152      * @dev Returns the addition of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `+` operator.
156      *
157      * Requirements:
158      *
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;
163         require(c >= a, "SafeMath: addition overflow");
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179         return sub(a, b, "SafeMath: subtraction overflow");
180     }
181 
182     /**
183      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
184      * overflow (when the result is negative).
185      *
186      * Counterpart to Solidity's `-` operator.
187      *
188      * Requirements:
189      *
190      * - Subtraction cannot overflow.
191      */
192     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b <= a, errorMessage);
194         uint256 c = a - b;
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the multiplication of two unsigned integers, reverting on
201      * overflow.
202      *
203      * Counterpart to Solidity's `*` operator.
204      *
205      * Requirements:
206      *
207      * - Multiplication cannot overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213         if (a == 0) {
214             return 0;
215         }
216 
217         uint256 c = a * b;
218         require(c / a == b, "SafeMath: multiplication overflow");
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers. Reverts on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator. Note: this function uses a
228      * `revert` opcode (which leaves remaining gas untouched) while Solidity
229      * uses an invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function div(uint256 a, uint256 b) internal pure returns (uint256) {
236         return div(a, b, "SafeMath: division by zero");
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b > 0, errorMessage);
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
272         return mod(a, b, "SafeMath: modulo by zero");
273     }
274 
275     /**
276      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
277      * Reverts with custom message when dividing by zero.
278      *
279      * Counterpart to Solidity's `%` operator. This function uses a `revert`
280      * opcode (which leaves remaining gas untouched) while Solidity uses an
281      * invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b != 0, errorMessage);
289         return a % b;
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/Address.sol
294 
295 
296 pragma solidity >=0.6.2 <0.8.0;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      */
319     function isContract(address account) internal view returns (bool) {
320         // This method relies on extcodesize, which returns 0 for contracts in
321         // construction, since the code is only stored at the end of the
322         // constructor execution.
323 
324         uint256 size;
325         // solhint-disable-next-line no-inline-assembly
326         assembly { size := extcodesize(account) }
327         return size > 0;
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(address(this).balance >= amount, "Address: insufficient balance");
348 
349         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
350         (bool success, ) = recipient.call{ value: amount }("");
351         require(success, "Address: unable to send value, recipient may have reverted");
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain`call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
373       return functionCall(target, data, "Address: low-level call failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
378      * `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
383         return functionCallWithValue(target, data, 0, errorMessage);
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
388      * but also transferring `value` wei to `target`.
389      *
390      * Requirements:
391      *
392      * - the calling contract must have an ETH balance of at least `value`.
393      * - the called Solidity function must be `payable`.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
403      * with `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
408         require(address(this).balance >= value, "Address: insufficient balance for call");
409         require(isContract(target), "Address: call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{ value: value }(data);
413         return _verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but performing a static call.
419      *
420      * _Available since v3.3._
421      */
422     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
423         return functionStaticCall(target, data, "Address: low-level static call failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
433         require(isContract(target), "Address: static call to non-contract");
434 
435         // solhint-disable-next-line avoid-low-level-calls
436         (bool success, bytes memory returndata) = target.staticcall(data);
437         return _verifyCallResult(success, returndata, errorMessage);
438     }
439 
440     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
441         if (success) {
442             return returndata;
443         } else {
444             // Look for revert reason and bubble it up if present
445             if (returndata.length > 0) {
446                 // The easiest way to bubble the revert reason is using memory via assembly
447 
448                 // solhint-disable-next-line no-inline-assembly
449                 assembly {
450                     let returndata_size := mload(returndata)
451                     revert(add(32, returndata), returndata_size)
452                 }
453             } else {
454                 revert(errorMessage);
455             }
456         }
457     }
458 }
459 
460 // File: contracts/StagedCrowdsale.sol
461 
462 pragma solidity ^0.6.2;
463 
464 
465 
466 
467 
468 
469 contract StagedCrowdsale is Context, Ownable {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     struct Milestone {
474         uint256 start;
475         uint256 end;
476         uint256 bonus;
477         uint256 minInvestedLimit;
478         uint256 maxInvestedLimit;
479         uint256 invested;
480         uint256 tokensSold;
481         uint256 hardcapInTokens;
482     }
483 
484     Milestone[] public milestones;
485 
486     function milestonesCount() public view returns (uint) {
487         return milestones.length;
488     }
489 
490     function addMilestone(uint256 start, uint256 end, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
491         milestones.push(Milestone(start, end, bonus, minInvestedLimit, maxInvestedLimit, invested, tokensSold, hardcapInTokens));
492     }
493 
494     function removeMilestone(uint8 number) public onlyOwner {
495         require(number < milestones.length);
496         //Milestone storage milestone = milestones[number];
497 
498         delete milestones[number];
499 
500         // check it
501         for (uint i = number; i < milestones.length - 1; i++) {
502             milestones[i] = milestones[i + 1];
503         }
504 
505     }
506 
507     function changeMilestone(uint8 number, uint256 start, uint256 end, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
508         require(number < milestones.length);
509         Milestone storage milestone = milestones[number];
510 
511         milestone.start = start;
512         milestone.end = end;
513         milestone.bonus = bonus;
514         milestone.minInvestedLimit = minInvestedLimit;
515         milestone.maxInvestedLimit = maxInvestedLimit;
516         milestone.invested = invested;
517         milestone.tokensSold = tokensSold;
518         milestone.hardcapInTokens = hardcapInTokens;
519     }
520 
521     function insertMilestone(uint8 index, uint256 start, uint256 end, uint256 bonus, uint256 minInvestedLimit, uint256 maxInvestedLimit, uint256 invested, uint256 tokensSold, uint256 hardcapInTokens) public onlyOwner {
522         require(index < milestones.length);
523         for (uint i = milestones.length; i > index; i--) {
524             milestones[i] = milestones[i - 1];
525         }
526         milestones[index] = Milestone(start, end, bonus, minInvestedLimit, maxInvestedLimit, invested, tokensSold, hardcapInTokens);
527     }
528 
529     function clearMilestones() public onlyOwner {
530         require(milestones.length > 0);
531         for (uint i = 0; i < milestones.length; i++) {
532             delete milestones[i];
533         }
534     }
535 
536     function currentMilestone() public view returns (uint256) {
537         for (uint256 i = 0; i < milestones.length; i++) {
538             if (now >= milestones[i].start && now < milestones[i].end && milestones[i].tokensSold <= milestones[i].hardcapInTokens) {
539                 return i;
540             }
541         }
542         revert();
543     }
544 
545 }
546 
547 // File: contracts/CommonSale.sol
548 
549 pragma solidity ^0.6.2;
550 
551 
552 
553 
554 
555 contract CommonSale is StagedCrowdsale, RetrieveTokensFeature {
556 
557     IERC20Cutted public token;
558     uint256 public price; // amount of tokens per 1 ETH
559     uint256 public invested;
560     uint256 public percentRate = 100;
561     address payable public wallet;
562     bool public isPause = false;
563     mapping(address => bool) public whitelist;
564 
565     mapping(uint256 => mapping(address => uint256)) public balances;
566 
567     mapping(uint256 => bool) public whitelistedMilestones;
568 
569     function setMilestoneWithWhitelist(uint256 index) public onlyOwner {
570         whitelistedMilestones[index] = true;
571     }
572 
573     function unsetMilestoneWithWhitelist(uint256 index) public onlyOwner {
574         whitelistedMilestones[index] = false;
575     }
576 
577     function addToWhiteList(address target) public onlyOwner {
578         require(!whitelist[target], "Already in whitelist");
579         whitelist[target] = true;
580     }
581 
582     function addToWhiteListMultiple(address[] memory targets) public onlyOwner {
583         for (uint i = 0; i < targets.length; i++) {
584             if (!whitelist[targets[i]]) whitelist[targets[i]] = true;
585         }
586     }
587 
588     function pause() public onlyOwner {
589         isPause = true;
590     }
591 
592     function unpause() public onlyOwner {
593         isPause = false;
594     }
595 
596     function setToken(address newTokenAddress) public onlyOwner() {
597         token = IERC20Cutted(newTokenAddress);
598     }
599 
600     function setPercentRate(uint256 newPercentRate) public onlyOwner() {
601         percentRate = newPercentRate;
602     }
603 
604     function setWallet(address payable newWallet) public onlyOwner() {
605         wallet = newWallet;
606     }
607 
608     function setPrice(uint256 newPrice) public onlyOwner() {
609         price = newPrice;
610     }
611 
612     function updateInvested(uint256 value) internal {
613         invested = invested.add(value);
614     }
615 
616     function internalFallback() internal returns (uint) {
617         require(!isPause, "Contract paused");
618 
619         uint256 milestoneIndex = currentMilestone();
620         Milestone storage milestone = milestones[milestoneIndex];
621         uint256 limitedInvestValue = msg.value;
622 
623         // limit the minimum amount for one transaction (ETH) 
624         require(limitedInvestValue >= milestone.minInvestedLimit, "The amount is too small");
625 
626         // check if the milestone requires user to be whitelisted
627         if (whitelistedMilestones[milestoneIndex]) {
628             require(whitelist[_msgSender()], "The address must be whitelisted!");
629         }
630 
631         // limit the maximum amount that one user can spend during the current milestone (ETH)
632         uint256 maxAllowableValue = milestone.maxInvestedLimit - balances[milestoneIndex][_msgSender()];
633         if (limitedInvestValue > maxAllowableValue) {
634             limitedInvestValue = maxAllowableValue;
635         }
636         require(limitedInvestValue > 0, "Investment limit exceeded!");
637 
638         // apply a bonus if any (10SET)
639         uint256 tokensWithoutBonus = limitedInvestValue.mul(price).div(1 ether);
640         uint256 tokensWithBonus = tokensWithoutBonus;
641         if (milestone.bonus > 0) {
642             tokensWithBonus = tokensWithoutBonus.add(tokensWithoutBonus.mul(milestone.bonus).div(percentRate));
643         }
644 
645         // limit the number of tokens that user can buy according to the hardcap of the current milestone (10SET)
646         if (milestone.tokensSold.add(tokensWithBonus) > milestone.hardcapInTokens) {
647             tokensWithBonus = milestone.hardcapInTokens.sub(milestone.tokensSold);
648             if (milestone.bonus > 0) {
649                 tokensWithoutBonus = tokensWithBonus.mul(percentRate).div(percentRate + milestone.bonus);
650             }
651         }
652         
653         // calculate the resulting amount of ETH that user will spend and calculate the change if any
654         uint256 tokenBasedLimitedInvestValue = tokensWithoutBonus.mul(1 ether).div(price);
655         uint256 change = msg.value - tokenBasedLimitedInvestValue;
656 
657         // update stats
658         invested = invested.add(tokenBasedLimitedInvestValue);
659         milestone.tokensSold = milestone.tokensSold.add(tokensWithBonus);
660         balances[milestoneIndex][_msgSender()] = balances[milestoneIndex][_msgSender()].add(tokenBasedLimitedInvestValue);
661         
662         wallet.transfer(tokenBasedLimitedInvestValue);
663         
664         // we multiply the amount to send by 100 / 98 to compensate the buyer 2% fee charged on each transaction
665         token.transfer(_msgSender(), tokensWithBonus.mul(100).div(98));
666         
667         if (change > 0) {
668             _msgSender().transfer(change);
669         }
670 
671         return tokensWithBonus;
672     }
673 
674     receive() external payable {
675         internalFallback();
676     }
677 
678 }
679 
680 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
681 
682 
683 pragma solidity >=0.6.0 <0.8.0;
684 
685 /**
686  * @dev Interface of the ERC20 standard as defined in the EIP.
687  */
688 interface IERC20 {
689     /**
690      * @dev Returns the amount of tokens in existence.
691      */
692     function totalSupply() external view returns (uint256);
693 
694     /**
695      * @dev Returns the amount of tokens owned by `account`.
696      */
697     function balanceOf(address account) external view returns (uint256);
698 
699     /**
700      * @dev Moves `amount` tokens from the caller's account to `recipient`.
701      *
702      * Returns a boolean value indicating whether the operation succeeded.
703      *
704      * Emits a {Transfer} event.
705      */
706     function transfer(address recipient, uint256 amount) external returns (bool);
707 
708     /**
709      * @dev Returns the remaining number of tokens that `spender` will be
710      * allowed to spend on behalf of `owner` through {transferFrom}. This is
711      * zero by default.
712      *
713      * This value changes when {approve} or {transferFrom} are called.
714      */
715     function allowance(address owner, address spender) external view returns (uint256);
716 
717     /**
718      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
719      *
720      * Returns a boolean value indicating whether the operation succeeded.
721      *
722      * IMPORTANT: Beware that changing an allowance with this method brings the risk
723      * that someone may use both the old and the new allowance by unfortunate
724      * transaction ordering. One possible solution to mitigate this race
725      * condition is to first reduce the spender's allowance to 0 and set the
726      * desired value afterwards:
727      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
728      *
729      * Emits an {Approval} event.
730      */
731     function approve(address spender, uint256 amount) external returns (bool);
732 
733     /**
734      * @dev Moves `amount` tokens from `sender` to `recipient` using the
735      * allowance mechanism. `amount` is then deducted from the caller's
736      * allowance.
737      *
738      * Returns a boolean value indicating whether the operation succeeded.
739      *
740      * Emits a {Transfer} event.
741      */
742     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
743 
744     /**
745      * @dev Emitted when `value` tokens are moved from one account (`from`) to
746      * another (`to`).
747      *
748      * Note that `value` may be zero.
749      */
750     event Transfer(address indexed from, address indexed to, uint256 value);
751 
752     /**
753      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
754      * a call to {approve}. `value` is the new allowance.
755      */
756     event Approval(address indexed owner, address indexed spender, uint256 value);
757 }
758 
759 // File: contracts/TenSetToken.sol
760 
761 pragma solidity ^0.6.2;
762 
763 
764 
765 
766 
767 
768 contract TenSetToken is IERC20, RetrieveTokensFeature {
769     using SafeMath for uint256;
770     using Address for address;
771 
772     mapping(address => uint256) private _rOwned;
773     mapping(address => uint256) private _tOwned;
774     mapping(address => mapping(address => uint256)) private _allowances;
775 
776     mapping(address => bool) private _isExcluded;
777     address[] private _excluded;
778 
779     uint256 private constant MAX = ~uint256(0);
780     uint256 private constant INITIAL_SUPPLY = 210000000 * 10 ** 18;
781     uint256 private constant BURN_STOP_SUPPLY = 2100000 * 10 ** 18;
782     uint256 private _tTotal = INITIAL_SUPPLY;
783     uint256 private _rTotal = (MAX - (MAX % _tTotal));
784     uint256 private _tFeeTotal;
785 
786     string private _name = "10Set Token";
787     string private _symbol = "10SET";
788     uint8 private _decimals = 18;
789 
790     constructor (address[] memory addresses, uint256[] memory amounts) public {
791         uint256 rDistributed = 0;
792         // loop through the addresses array and send tokens to each address except the last one
793         // the corresponding amount to sent is taken from the amounts array
794         for(uint8 i = 0; i < addresses.length - 1; i++) {
795             (uint256 rAmount, , , , , , ) = _getValues(amounts[i]);
796             _rOwned[addresses[i]] = rAmount;
797             rDistributed = rDistributed + rAmount;
798             emit Transfer(address(0), addresses[i], amounts[i]);
799         }
800         // all remaining tokens will be sent to the last address in the addresses array
801         uint256 rRemainder = _rTotal - rDistributed;
802         address liQuidityWalletAddress = addresses[addresses.length - 1];
803         _rOwned[liQuidityWalletAddress] = rRemainder;
804         emit Transfer(address(0), liQuidityWalletAddress, tokenFromReflection(rRemainder));
805     }
806 
807     function excludeAccount(address account) external onlyOwner() {
808         require(!_isExcluded[account], "Account is already excluded");
809         if (_rOwned[account] > 0) {
810             _tOwned[account] = tokenFromReflection(_rOwned[account]);
811         }
812         _isExcluded[account] = true;
813         _excluded.push(account);
814     }
815 
816     function includeAccount(address account) external onlyOwner() {
817         require(_isExcluded[account], "Account is already included");
818         for (uint256 i = 0; i < _excluded.length; i++) {
819             if (_excluded[i] == account) {
820                 _excluded[i] = _excluded[_excluded.length - 1];
821                 _tOwned[account] = 0;
822                 _isExcluded[account] = false;
823                 _excluded.pop();
824                 break;
825             }
826         }
827     }
828 
829     function name() public view returns (string memory) {
830         return _name;
831     }
832 
833     function symbol() public view returns (string memory) {
834         return _symbol;
835     }
836 
837     function decimals() public view returns (uint8) {
838         return _decimals;
839     }
840 
841     function totalSupply() public view override returns (uint256) {
842         return _tTotal;
843     }
844 
845     function balanceOf(address account) public view override returns (uint256) {
846         if (_isExcluded[account]) return _tOwned[account];
847         return tokenFromReflection(_rOwned[account]);
848     }
849 
850     function transfer(address recipient, uint256 amount) public override returns (bool) {
851         _transfer(_msgSender(), recipient, amount);
852         return true;
853     }
854 
855     function allowance(address owner, address spender) public view override returns (uint256) {
856         return _allowances[owner][spender];
857     }
858 
859     function approve(address spender, uint256 amount) public override returns (bool) {
860         _approve(_msgSender(), spender, amount);
861         return true;
862     }
863 
864     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
865         _transfer(sender, recipient, amount);
866         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
867         return true;
868     }
869 
870     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
871         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
872         return true;
873     }
874 
875     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
876         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
877         return true;
878     }
879 
880     function burn(uint256 amount) public {
881         require(_msgSender() != address(0), "ERC20: burn from the zero address");
882         (uint256 rAmount, , , , , , ) = _getValues(amount);
883         _burn(_msgSender(), amount, rAmount);
884     }
885 
886     function burnFrom(address account, uint256 amount) public {
887         require(account != address(0), "ERC20: burn from the zero address");
888         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
889         _approve(account, _msgSender(), decreasedAllowance);
890         (uint256 rAmount, , , , , , ) = _getValues(amount);
891         _burn(account, amount, rAmount);
892     }
893 
894     function isExcluded(address account) public view returns (bool) {
895         return _isExcluded[account];
896     }
897 
898     function totalFees() public view returns (uint256) {
899         return _tFeeTotal;
900     }
901 
902     function reflect(uint256 tAmount) public {
903         address sender = _msgSender();
904         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
905         (uint256 rAmount, , , , , , ) = _getValues(tAmount);
906         _rOwned[sender] = _rOwned[sender].sub(rAmount);
907         _rTotal = _rTotal.sub(rAmount);
908         _tFeeTotal = _tFeeTotal.add(tAmount);
909     }
910 
911     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
912         require(tAmount <= _tTotal, "Amount must be less than supply");
913         if (!deductTransferFee) {
914             (uint256 rAmount, , , , , , ) = _getValues(tAmount);
915             return rAmount;
916         } else {
917             ( , uint256 rTransferAmount, , , , , ) = _getValues(tAmount);
918             return rTransferAmount;
919         }
920     }
921 
922     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
923         require(rAmount <= _rTotal, "Amount must be less than total reflections");
924         uint256 currentRate = _getRate();
925         return rAmount.div(currentRate);
926     }
927 
928     function _approve(address owner, address spender, uint256 amount) private {
929         require(owner != address(0), "ERC20: approve from the zero address");
930         require(spender != address(0), "ERC20: approve to the zero address");
931 
932         _allowances[owner][spender] = amount;
933         emit Approval(owner, spender, amount);
934     }
935 
936     function _transfer(address sender, address recipient, uint256 amount) private {
937         require(sender != address(0), "ERC20: transfer from the zero address");
938         require(recipient != address(0), "ERC20: transfer to the zero address");
939         require(amount > 0, "Transfer amount must be greater than zero");
940         if (_isExcluded[sender] && !_isExcluded[recipient]) {
941             _transferFromExcluded(sender, recipient, amount);
942         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
943             _transferToExcluded(sender, recipient, amount);
944         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
945             _transferStandard(sender, recipient, amount);
946         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
947             _transferBothExcluded(sender, recipient, amount);
948         } else {
949             _transferStandard(sender, recipient, amount);
950         }
951     }
952 
953     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
954         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
955         _rOwned[sender] = _rOwned[sender].sub(rAmount);
956         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
957         _reflectFee(rFee, tFee);
958         if (tBurn > 0) {
959             _reflectBurn(rBurn, tBurn, sender);
960         }
961         emit Transfer(sender, recipient, tTransferAmount);
962     }
963 
964     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
965         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
966         _rOwned[sender] = _rOwned[sender].sub(rAmount);
967         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
968         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
969         _reflectFee(rFee, tFee);
970         if (tBurn > 0) {
971             _reflectBurn(rBurn, tBurn, sender);
972         }
973         emit Transfer(sender, recipient, tTransferAmount);
974     }
975 
976     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
977         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
978         _tOwned[sender] = _tOwned[sender].sub(tAmount);
979         _rOwned[sender] = _rOwned[sender].sub(rAmount);
980         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
981         _reflectFee(rFee, tFee);
982         if (tBurn > 0) {
983             _reflectBurn(rBurn, tBurn, sender);
984         }
985         emit Transfer(sender, recipient, tTransferAmount);
986     }
987 
988     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
989         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
990         _tOwned[sender] = _tOwned[sender].sub(tAmount);
991         _rOwned[sender] = _rOwned[sender].sub(rAmount);
992         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
993         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
994         _reflectFee(rFee, tFee);
995         if (tBurn > 0) {
996             _reflectBurn(rBurn, tBurn, sender);
997         }
998         emit Transfer(sender, recipient, tTransferAmount);
999     }
1000 
1001     function _reflectFee(uint256 rFee, uint256 tFee) private {
1002         _rTotal = _rTotal.sub(rFee);
1003         _tFeeTotal = _tFeeTotal.add(tFee);
1004     }
1005 
1006     function _reflectBurn(uint256 rBurn, uint256 tBurn, address account) private {
1007         _rTotal = _rTotal.sub(rBurn);
1008         _tTotal = _tTotal.sub(tBurn);
1009         emit Transfer(account, address(0), tBurn);
1010     }
1011 
1012     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1013         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount);
1014         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 rBurn) = _getRValues(tAmount, tFee, tBurn);
1015         return (rAmount, rTransferAmount, rFee, rBurn, tTransferAmount, tFee, tBurn);
1016     }
1017 
1018     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1019         uint256 tFee = tAmount.div(100);
1020         uint256 tTransferAmount = tAmount.sub(tFee);
1021         uint256 tBurn = 0;
1022         if (_tTotal > BURN_STOP_SUPPLY) {
1023             tBurn = tAmount.div(100);
1024             if (_tTotal < BURN_STOP_SUPPLY.add(tBurn)) {
1025                 tBurn = _tTotal.sub(BURN_STOP_SUPPLY);
1026             }
1027             tTransferAmount = tTransferAmount.sub(tBurn);
1028         }
1029         return (tTransferAmount, tFee, tBurn);
1030     }
1031 
1032     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn) private view returns (uint256, uint256, uint256, uint256) {
1033         uint256 currentRate = _getRate();
1034         uint256 rAmount = tAmount.mul(currentRate);
1035         uint256 rFee = tFee.mul(currentRate);
1036         uint256 rBurn = 0;
1037         uint256 rTransferAmount = rAmount.sub(rFee);
1038         if (tBurn > 0) {
1039             rBurn = tBurn.mul(currentRate);
1040             rTransferAmount = rAmount.sub(rBurn);
1041         }
1042         return (rAmount, rTransferAmount, rFee, rBurn);
1043     }
1044 
1045     function _getRate() private view returns (uint256) {
1046         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1047         return rSupply.div(tSupply);
1048     }
1049 
1050     function _getCurrentSupply() private view returns (uint256, uint256) {
1051         uint256 rSupply = _rTotal;
1052         uint256 tSupply = _tTotal;
1053         for (uint256 i = 0; i < _excluded.length; i++) {
1054             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1055             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1056             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1057         }
1058         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1059         return (rSupply, tSupply);
1060     }
1061 
1062     function _burn(address account, uint256 tAmount, uint256 rAmount) private {
1063         if (_isExcluded[account]) {
1064             _tOwned[account] = _tOwned[account].sub(tAmount, "ERC20: burn amount exceeds balance");
1065             _rOwned[account] = _rOwned[account].sub(rAmount, "ERC20: burn amount exceeds balance"); 
1066         } else {
1067             _rOwned[account] = _rOwned[account].sub(rAmount, "ERC20: burn amount exceeds balance");
1068         }
1069         _reflectBurn(rAmount, tAmount, account);
1070     }
1071 }
1072 
1073 // File: contracts/FreezeTokenWallet.sol
1074 
1075 pragma solidity ^0.6.2;
1076 
1077 
1078 
1079 
1080 contract FreezeTokenWallet is RetrieveTokensFeature {
1081 
1082   using SafeMath for uint256;
1083 
1084   IERC20Cutted public token;
1085 
1086   bool public started;
1087 
1088   uint256 public startLockPeriod = 0 days;
1089 
1090   uint256 public period = 30 * 30 * 1 days;
1091 
1092   uint256 public duration = 90 days;
1093 
1094   uint256 public startUnlock;
1095 
1096   uint256 public retrievedTokens;
1097 
1098   uint256 public startBalance;
1099 
1100   modifier notStarted() {
1101     require(!started);
1102     _;
1103   }
1104 
1105   function setPeriod(uint newPeriod) public onlyOwner notStarted {
1106     period = newPeriod * 1 days;
1107   }
1108 
1109   function setDuration(uint newDuration) public onlyOwner notStarted {
1110     duration = newDuration * 1 days;
1111   }
1112 
1113   function setStartLockPeriod(uint newStartLockPeriod) public onlyOwner notStarted {
1114     startLockPeriod = newStartLockPeriod * 1 days;
1115   }
1116 
1117   function setToken(address newToken) public onlyOwner notStarted {
1118     token = IERC20Cutted(newToken);
1119   }
1120 
1121   function start(uint startDate) public onlyOwner notStarted {
1122     startUnlock = startDate + startLockPeriod;
1123     retrievedTokens = 0;
1124     startBalance = token.balanceOf(address(this));
1125     started = true;
1126   }
1127 
1128   function retrieveWalletTokens(address to) public onlyOwner {
1129     require(started && now >= startUnlock);
1130     if (now >= startUnlock + period) {
1131       token.transfer(to, token.balanceOf(address(this)));
1132     } else {
1133       uint parts = period.div(duration);
1134       uint tokensByPart = startBalance.div(parts);
1135       uint timeSinceStart = now.sub(startUnlock);
1136       uint pastParts = timeSinceStart.div(duration);
1137       uint tokensToRetrieveSinceStart = pastParts.mul(tokensByPart);
1138       uint tokensToRetrieve = tokensToRetrieveSinceStart.sub(retrievedTokens);
1139       if(tokensToRetrieve > 0) {
1140         retrievedTokens = retrievedTokens.add(tokensToRetrieve);
1141         token.transfer(to, tokensToRetrieve);
1142       }
1143     }
1144   }
1145 
1146   function retrieveTokens(address to, address anotherToken) override public onlyOwner() {
1147     require(address(token) != anotherToken, "");
1148     super.retrieveTokens(to, anotherToken);
1149   }
1150 
1151 }
1152 
1153 // File: contracts/Configurator.sol
1154 
1155 pragma solidity ^0.6.2;
1156 
1157 
1158 
1159 
1160 
1161 
1162 
1163 contract Configurator is RetrieveTokensFeature {
1164     using SafeMath for uint256;
1165     using Address for address;
1166 
1167     uint256 private constant MAX = ~uint256(0);
1168 
1169     uint256 private constant COMPANY_RESERVE_AMOUNT    = 21000000 * 1 ether;
1170     uint256 private constant TEAM_AMOUNT               = 21000000 * 1 ether;
1171     uint256 private constant MARKETING_AMOUNT          = 10500000 * 1 ether;
1172     uint256 private constant LIQUIDITY_RESERVE         = 10500000 * 1 ether;
1173     uint256 private constant SALE_AMOUNT               = uint256(147000000 * 1 ether * 100) / 98;
1174 
1175     address private constant OWNER_ADDRESS             = address(0x68CE6F1A63CC76795a70Cf9b9ca3f23293547303);
1176     address private constant TEAM_WALLET_OWNER_ADDRESS = address(0x44C4A8d57B22597a2c0397A15CF1F32d8A4EA8F7);
1177     address private constant MARKETING_WALLET_ADDRESS  = address(0x127D069DC8B964a813889D349eD3dA3f6D35383D);
1178     address private constant COMPANY_RESERVE_ADDRESS   = address(0x7BD3b301f3537c75bf64B7468998d20045cfa48e);
1179     address private constant LIQUIDITY_WALLET_ADDRESS  = address(0x91E84302594deFaD552938B6D0D56e9f39908f9F);
1180     address payable constant ETH_WALLET_ADDRESS        = payable(0x68CE6F1A63CC76795a70Cf9b9ca3f23293547303);
1181     address private constant DEPLOYER_ADDRESS          = address(0x6E9DC3D20B906Fd2B52eC685fE127170eD2165aB);
1182 
1183     uint256 private constant PRICE                   = 10000 * 1 ether;  // 1 ETH = 10000 10SET
1184 
1185     uint256 private constant STAGE1_START_DATE       = 1612116000;       // Jan 31 2021 19:00:00 GMT+0100
1186     uint256 private constant STAGE1_END_DATE         = 1612720800;       // Feb 07 2021 19:00:00 GMT+0100
1187     uint256 private constant STAGE1_BONUS            = 10;
1188     uint256 private constant STAGE1_MIN_INVESTMENT   = 1 * 10 ** 17;     // 0.1 ETH
1189     uint256 private constant STAGE1_MAX_INVESTMENT   = 40 * 1 ether;     // 40 ETH
1190     uint256 private constant STAGE1_TOKEN_HARDCAP    = 11000000 * 1 ether;
1191 
1192     uint256 private constant STAGE2_START_DATE       = 1615140000;       // Mar 07 2021 19:00:00 GMT+0100
1193     uint256 private constant STAGE2_END_DATE         = 1615744800;       // Mar 14 2021 19:00:00 GMT+0100 
1194     uint256 private constant STAGE2_BONUS            = 5;
1195     uint256 private constant STAGE2_MIN_INVESTMENT   = 0.1 * 1 ether;    // 0.1 ETH
1196     uint256 private constant STAGE2_MAX_INVESTMENT   = 100 * 1 ether;    // 100 ETH
1197     uint256 private constant STAGE2_TOKEN_HARDCAP    = 52500000 * 1 ether;
1198 
1199     uint256 private constant STAGE3_START_DATE       = 1615744800;       // Mar 14 2021 19:00:00 GMT+0100 
1200     uint256 private constant STAGE3_END_DATE         = 253374588000;     // Feb 14 9999 07:00:00 GMT+0100 
1201     uint256 private constant STAGE3_BONUS            = 0;
1202     uint256 private constant STAGE3_MIN_INVESTMENT   = 0;                // 0 ETH
1203     uint256 private constant STAGE3_MAX_INVESTMENT   = MAX;
1204     uint256 private constant STAGE3_TOKEN_HARDCAP    = 80000000 * 1 ether;
1205 
1206     address[] private addresses;
1207     uint256[] private amounts;
1208 
1209     TenSetToken public token;
1210     FreezeTokenWallet public freezeWallet;
1211     CommonSale public commonSale;
1212 
1213     constructor () public {
1214         // create instances
1215         freezeWallet = new FreezeTokenWallet();
1216         commonSale = new CommonSale();
1217 
1218         addresses.push(COMPANY_RESERVE_ADDRESS);
1219         amounts.push(COMPANY_RESERVE_AMOUNT);
1220         addresses.push(address(freezeWallet));
1221         amounts.push(TEAM_AMOUNT);
1222         addresses.push(MARKETING_WALLET_ADDRESS);
1223         amounts.push(MARKETING_AMOUNT);
1224         addresses.push(address(commonSale));
1225         amounts.push(SALE_AMOUNT);
1226         addresses.push(LIQUIDITY_WALLET_ADDRESS);
1227         amounts.push(0); // will receive the remaining tokens (should be slightly less than LIQUIDITY_RESERVE)
1228 
1229         token = new TenSetToken(addresses, amounts);
1230 
1231         commonSale.setToken(address(token));
1232         freezeWallet.setToken(address(token));
1233 
1234         commonSale.setPrice(PRICE);
1235         commonSale.setWallet(ETH_WALLET_ADDRESS);
1236         commonSale.addMilestone(STAGE1_START_DATE, STAGE1_END_DATE, STAGE1_BONUS, STAGE1_MIN_INVESTMENT, STAGE1_MAX_INVESTMENT, 0, 0, STAGE1_TOKEN_HARDCAP);
1237         commonSale.setMilestoneWithWhitelist(0);
1238         commonSale.addMilestone(STAGE2_START_DATE, STAGE2_END_DATE, STAGE2_BONUS, STAGE2_MIN_INVESTMENT, STAGE2_MAX_INVESTMENT, 0, 0, STAGE2_TOKEN_HARDCAP);
1239         commonSale.setMilestoneWithWhitelist(1);
1240         commonSale.addMilestone(STAGE3_START_DATE, STAGE3_END_DATE, STAGE3_BONUS, STAGE3_MIN_INVESTMENT, STAGE3_MAX_INVESTMENT, 0, 0, STAGE3_TOKEN_HARDCAP);
1241 
1242         freezeWallet.start(STAGE1_START_DATE);
1243 
1244         token.transferOwnership(OWNER_ADDRESS);
1245         freezeWallet.transferOwnership(TEAM_WALLET_OWNER_ADDRESS);
1246         commonSale.transferOwnership(DEPLOYER_ADDRESS);
1247     }
1248 
1249 }