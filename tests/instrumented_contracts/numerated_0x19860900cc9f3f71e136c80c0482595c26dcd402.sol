1 // Sources flattened with hardhat v2.11.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
32 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 
114 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
115 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Contract module that helps prevent reentrant calls to a function.
121  *
122  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
123  * available, which can be applied to functions to make sure there are no nested
124  * (reentrant) calls to them.
125  *
126  * Note that because there is a single `nonReentrant` guard, functions marked as
127  * `nonReentrant` may not call one another. This can be worked around by making
128  * those functions `private`, and then adding `external` `nonReentrant` entry
129  * points to them.
130  *
131  * TIP: If you would like to learn more about reentrancy and alternative ways
132  * to protect against it, check out our blog post
133  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
134  */
135 abstract contract ReentrancyGuard {
136     // Booleans are more expensive than uint256 or any type that takes up a full
137     // word because each write operation emits an extra SLOAD to first read the
138     // slot's contents, replace the bits taken up by the boolean, and then write
139     // back. This is the compiler's defense against contract upgrades and
140     // pointer aliasing, and it cannot be disabled.
141 
142     // The values being non-zero value makes deployment a bit more expensive,
143     // but in exchange the refund on every call to nonReentrant will be lower in
144     // amount. Since refunds are capped to a percentage of the total
145     // transaction's gas, it is best to keep them low in cases like this one, to
146     // increase the likelihood of the full refund coming into effect.
147     uint256 private constant _NOT_ENTERED = 1;
148     uint256 private constant _ENTERED = 2;
149 
150     uint256 private _status;
151 
152     constructor() {
153         _status = _NOT_ENTERED;
154     }
155 
156     /**
157      * @dev Prevents a contract from calling itself, directly or indirectly.
158      * Calling a `nonReentrant` function from another `nonReentrant`
159      * function is not supported. It is possible to prevent this from happening
160      * by making the `nonReentrant` function external, and making it call a
161      * `private` function that does the actual work.
162      */
163     modifier nonReentrant() {
164         // On the first call to nonReentrant, _notEntered will be true
165         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
166 
167         // Any calls to nonReentrant after this point will fail
168         _status = _ENTERED;
169 
170         _;
171 
172         // By storing the original value once again, a refund is triggered (see
173         // https://eips.ethereum.org/EIPS/eip-2200)
174         _status = _NOT_ENTERED;
175     }
176 }
177 
178 
179 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
180 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
181 
182 pragma solidity ^0.8.1;
183 
184 /**
185  * @dev Collection of functions related to the address type
186  */
187 library Address {
188     /**
189      * @dev Returns true if `account` is a contract.
190      *
191      * [IMPORTANT]
192      * ====
193      * It is unsafe to assume that an address for which this function returns
194      * false is an externally-owned account (EOA) and not a contract.
195      *
196      * Among others, `isContract` will return false for the following
197      * types of addresses:
198      *
199      *  - an externally-owned account
200      *  - a contract in construction
201      *  - an address where a contract will be created
202      *  - an address where a contract lived, but was destroyed
203      * ====
204      *
205      * [IMPORTANT]
206      * ====
207      * You shouldn't rely on `isContract` to protect against flash loan attacks!
208      *
209      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
210      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
211      * constructor.
212      * ====
213      */
214     function isContract(address account) internal view returns (bool) {
215         // This method relies on extcodesize/address.code.length, which returns 0
216         // for contracts in construction, since the code is only stored at the end
217         // of the constructor execution.
218 
219         return account.code.length > 0;
220     }
221 
222     /**
223      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
224      * `recipient`, forwarding all available gas and reverting on errors.
225      *
226      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
227      * of certain opcodes, possibly making contracts go over the 2300 gas limit
228      * imposed by `transfer`, making them unable to receive funds via
229      * `transfer`. {sendValue} removes this limitation.
230      *
231      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
232      *
233      * IMPORTANT: because control is transferred to `recipient`, care must be
234      * taken to not create reentrancy vulnerabilities. Consider using
235      * {ReentrancyGuard} or the
236      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
237      */
238     function sendValue(address payable recipient, uint256 amount) internal {
239         require(address(this).balance >= amount, "Address: insufficient balance");
240 
241         (bool success, ) = recipient.call{value: amount}("");
242         require(success, "Address: unable to send value, recipient may have reverted");
243     }
244 
245     /**
246      * @dev Performs a Solidity function call using a low level `call`. A
247      * plain `call` is an unsafe replacement for a function call: use this
248      * function instead.
249      *
250      * If `target` reverts with a revert reason, it is bubbled up by this
251      * function (like regular Solidity function calls).
252      *
253      * Returns the raw returned data. To convert to the expected return value,
254      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
255      *
256      * Requirements:
257      *
258      * - `target` must be a contract.
259      * - calling `target` with `data` must not revert.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionCall(target, data, "Address: low-level call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
269      * `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         return functionCallWithValue(target, data, 0, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but also transferring `value` wei to `target`.
284      *
285      * Requirements:
286      *
287      * - the calling contract must have an ETH balance of at least `value`.
288      * - the called Solidity function must be `payable`.
289      *
290      * _Available since v3.1._
291      */
292     function functionCallWithValue(
293         address target,
294         bytes memory data,
295         uint256 value
296     ) internal returns (bytes memory) {
297         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
298     }
299 
300     /**
301      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
302      * with `errorMessage` as a fallback revert reason when `target` reverts.
303      *
304      * _Available since v3.1._
305      */
306     function functionCallWithValue(
307         address target,
308         bytes memory data,
309         uint256 value,
310         string memory errorMessage
311     ) internal returns (bytes memory) {
312         require(address(this).balance >= value, "Address: insufficient balance for call");
313         require(isContract(target), "Address: call to non-contract");
314 
315         (bool success, bytes memory returndata) = target.call{value: value}(data);
316         return verifyCallResult(success, returndata, errorMessage);
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
326         return functionStaticCall(target, data, "Address: low-level static call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(
336         address target,
337         bytes memory data,
338         string memory errorMessage
339     ) internal view returns (bytes memory) {
340         require(isContract(target), "Address: static call to non-contract");
341 
342         (bool success, bytes memory returndata) = target.staticcall(data);
343         return verifyCallResult(success, returndata, errorMessage);
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
353         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
358      * but performing a delegate call.
359      *
360      * _Available since v3.4._
361      */
362     function functionDelegateCall(
363         address target,
364         bytes memory data,
365         string memory errorMessage
366     ) internal returns (bytes memory) {
367         require(isContract(target), "Address: delegate call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.delegatecall(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
375      * revert reason using the provided one.
376      *
377      * _Available since v4.3._
378      */
379     function verifyCallResult(
380         bool success,
381         bytes memory returndata,
382         string memory errorMessage
383     ) internal pure returns (bytes memory) {
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390                 /// @solidity memory-safe-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 
403 // File contracts/EthericeStaking.sol
404 pragma solidity 0.8.16;
405 
406 
407 
408 interface TokenContractInterface {
409     function calcDay() external view returns (uint256);
410 
411     function lobbyEntry(uint256 _day) external view returns (uint256);
412 
413     function balanceOf(address _owner) external view returns (uint256 balance);
414 
415     function transfer(address _to, uint256 _value)
416         external
417         returns (bool success);
418     function allowance(address owner, address spender) external view returns (uint256);
419     function transferFrom(
420         address _from,
421         address _to,
422         uint256 _value
423     ) external returns (bool success);
424 
425     function dev_addr() external view returns (address);
426 }
427 
428 contract EthericeStaking is Ownable, ReentrancyGuard {
429     event NewStake(
430         address indexed addr,
431         uint256 timestamp,
432         uint256 indexed stakeId,
433         uint256 stakeAmount,
434         uint256 stakeDuration
435     );
436     event StakeCollected(
437         address indexed addr,
438         uint256 timestamp,
439         uint256 indexed stakeId,
440         uint256 stakeAmount,
441         uint256 divsReceived
442     );
443     event SellStakeRequest(
444         address indexed addr,
445         uint256 timestamp,
446         uint256 indexed stakeId,
447         uint256 price
448     );
449     event CancelStakeSellRequest(
450         address indexed addr,
451         uint256 timestamp,
452         uint256 indexed stakeId
453     );
454     event StakeSold(
455         address indexed from,
456         address indexed to,
457         uint256 timestamp,
458         uint256 sellAmount,
459         uint256 indexed stakeId
460     );
461     event NewLoanRequest(
462         address indexed addr,
463         uint256 timestamp,
464         uint256 loanAmount,
465         uint256 interestAmount,
466         uint256 duration,
467         uint256 indexed stakeId
468     );
469     event LoanRequestFilled(
470         address indexed filledBy,
471         uint256 timestamp,
472         address indexed receivedBy,
473         uint256 loanamount,
474         uint256 indexed stakeId
475     );
476     event LoanRepaid(
477         address indexed paidTo,
478         uint256 timestamp,
479         uint256 interestAmount,
480         uint256 loanamount,
481         uint256 indexed stakeId
482     );
483     event CancelLoanRequest(
484         address indexed addr,
485         uint256 timestamp,
486         uint256 indexed stakeId
487     );
488 
489     struct stake {
490         address owner;
491         uint256 tokensStaked;
492         uint256 startDay;
493         uint256 endDay;
494         uint256 forSalePrice;
495         uint256 loanRepayments; // loan repayments made on this stake (deduct from divs on withdrawal)
496         bool hasCollected;
497     }
498 
499     /* A map for each  stakeId => struct stake */
500     mapping(uint256 => stake) public mapStakes;
501     uint256 public lastStakeIndex;
502     /* Address => stakeId for a users stakes */
503     mapping(address => uint256[]) internal _userStakes;
504 
505     struct loan {
506         address requestedBy;
507         address filledBy;
508         uint256 loanAmount;
509         uint256 loanInterest;
510         uint256 loanDuration;
511         uint256 startDay;
512         uint256 endDay;
513     }
514     /* A map for each loan loanId => struct loan */
515     mapping(uint256 => loan) public mapLoans;
516     /* Address => stakeId for a users loans (address is the person filling the loan not receiving it) */
517     mapping(address => uint256[]) internal _userLends;
518 
519     /** Hold amount of eth owed to dev fees */
520     uint256 public devFees;
521 
522     /** Total ETH in the dividend pool for each day */
523     mapping(uint256 => uint256) public dayDividendPool;
524 
525     /** Total tokens that have been staked each day */
526     mapping(uint256 => uint256) public tokensInActiveStake;
527 
528     /** TokenContract object  */
529     TokenContractInterface public _tokenContract;
530 
531     /** Ensures that token contract can't be changed for securiy */
532     bool public tokenContractAddressSet = false;
533 
534     /** The amount of days each days divs would be spread over */
535     uint256 public maxDividendRewardDays = 30;
536 
537     /** The max amount of days user can stake */
538     uint256 public maxStakeDays = 60;
539 
540     uint256 constant public devSellStakeFee = 10;
541     uint256 constant public devLoanFeePercent = 2;
542 
543     address public deployer;
544 
545     constructor() {
546         deployer = msg.sender;
547     }
548 
549     receive() external payable {}
550 
551     /**
552         @dev Set the contract address, must be run before any eth is posted
553         to the contract
554         @param _address the token contract address
555     */
556     function setTokenContractAddress(address _address) external {
557         require(_address != address(0), "Address cannot be zero");
558         require(tokenContractAddressSet == false, "Token contract address already set");
559         require(msg.sender==deployer, "Only deployer can set this value");
560         require(owner() != deployer, "Ownership must be transferred before contract start");
561         tokenContractAddressSet = true;
562         _tokenContract = TokenContractInterface(_address);
563     }
564 
565     /**
566         @dev runs when and eth is sent to the divs contract and distros
567         it out across the total div days
568     */
569     function receiveDivs() external payable {
570         // calcDay will return 2 when we're processing the divs from day 1
571         uint256 _day =  _tokenContract.calcDay();
572         require(_day > 1, "receive divs not yet enabled");
573         // We process divs for previous day;
574         _day--;
575 
576         require(msg.sender == address(_tokenContract), "Unauthorized");
577         uint256 _daysToSplitRewardsOver = _day < maxDividendRewardDays
578             ? _day
579             : maxDividendRewardDays;
580 
581         if(_day == 1) {
582             _daysToSplitRewardsOver = 2 ;
583         }
584         
585         uint256 _totalDivsPerDay = msg.value / _daysToSplitRewardsOver ;
586         
587         for (uint256 i = 1; i <= _daysToSplitRewardsOver; ) {
588             dayDividendPool[_day + i] += _totalDivsPerDay;
589             unchecked {
590                 i++;
591             }
592         }
593     }
594 
595     /**
596         @dev update the max days dividends are spread over
597         @param _newMaxRewardDays the max days
598     */
599     function updateMaxDividendRewardDays(uint256 _newMaxRewardDays) external onlyOwner {
600         require((_newMaxRewardDays <= 60 && _newMaxRewardDays >= 10), "New value must be <= 60 & >= 10");
601         maxDividendRewardDays = _newMaxRewardDays;
602     }
603 
604     /**
605      * @dev set the max staking days
606      * @param _amount the number of days
607      */
608     function updateMaxStakeDays(uint256 _amount) external onlyOwner {
609         require((_amount <= 300 && _amount > 30), "New value must be <= 300 and > 30");
610         maxStakeDays = _amount;
611     }
612 
613     /**
614      * @dev User creates a new stake 
615      * @param _amount total tokens to stake
616      * @param _days must be less than max stake days. 
617      * the more days the higher the gas fee
618      */
619     function newStake(uint256 _amount, uint256 _days) external nonReentrant {
620         require(_days > 1, "Staking: Staking days < 1");
621         require(
622             _days <= maxStakeDays,
623             "Staking: Staking days > max_stake_days"
624         );
625 
626         uint256 _currentDay = _tokenContract.calcDay();
627         require(_currentDay > 0, "Staking not enabled");
628 
629         bool success = _tokenContract.transferFrom(msg.sender, address(this), _amount);
630         require(success, "Transfer failed");
631 
632 
633         uint256 _stakeId = _getNextStakeId();
634 
635         uint256 _endDay =_currentDay + 1 + _days;
636         uint256 _startDay = _currentDay + 1;
637         mapStakes[_stakeId] = stake({
638             owner: msg.sender,
639             tokensStaked: _amount,
640             startDay: _startDay,
641             endDay: _endDay,
642             forSalePrice: 0,
643             hasCollected: false,
644             loanRepayments: 0
645         });
646 
647         for (uint256 i = _startDay; i < _endDay ;) {
648             tokensInActiveStake[i] += _amount;
649 
650             unchecked{ i++; }
651         }
652 
653         _userStakes[msg.sender].push(_stakeId);
654 
655         emit NewStake(msg.sender, block.timestamp, _stakeId, _amount, _days);
656     }
657 
658     /** 
659      * @dev Get the next stake id index 
660      */
661     function _getNextStakeId() internal returns (uint256) {
662         lastStakeIndex++;
663         return lastStakeIndex;
664     }
665 
666     /**
667      * @dev called by user to collect an outstading stake
668      */
669     function collectStake(uint256 _stakeId) external nonReentrant {
670         stake storage _stake = mapStakes[_stakeId];
671         uint256 currentDay = _tokenContract.calcDay();
672         
673         require(_stake.owner == msg.sender, "Unauthorised");
674         require(_stake.hasCollected == false, "Already Collected");
675         require( currentDay > _stake.endDay , "Stake hasn't ended");
676 
677         // Check for outstanding loans
678         loan storage _loan = mapLoans[_stakeId];
679         if(_loan.filledBy != address(0)){
680             // Outstanding loan has not been paid off 
681             // so do that now
682             repayLoan(_stakeId);
683         } else if (_loan.requestedBy != address(0)) {
684             _clearLoan(_stakeId);   
685         }
686 
687         // Get new instance of loan after potential updates
688         _loan = mapLoans[_stakeId];
689 
690          // Get the loan from storage again 
691          // and check its cleard before we move on
692         require(_loan.filledBy == address(0), "Stake has unpaid loan");
693         require(_loan.requestedBy == address(0), "Stake has outstanding loan request");
694             
695         uint256 profit = calcStakeCollecting(_stakeId);
696         mapStakes[_stakeId].hasCollected = true;
697 
698         // Send user the stake back
699         bool success = _tokenContract.transfer(
700             msg.sender,
701             _stake.tokensStaked
702         );
703         require(success, "Transfer failed");
704 
705         // Send the user divs
706         Address.sendValue( payable(_stake.owner) , profit);
707 
708         emit StakeCollected(
709             _stake.owner,
710             block.timestamp,
711             _stakeId,
712             _stake.tokensStaked,
713             profit
714         );
715     }
716 
717     /** 
718      * Added an auth wrapper to the cancel loan request
719      * so it cant be canceled by just anyone externally
720      */
721     function cancelLoanRequest(uint256 _stakeId) external {
722         stake storage _stake = mapStakes[_stakeId];
723         require(msg.sender == _stake.owner, "Unauthorised");
724         _cancelLoanRequest(_stakeId);
725     }
726 
727     function _cancelLoanRequest(uint256 _stakeId) internal {
728         mapLoans[_stakeId] = loan({
729             requestedBy: address(0),
730             filledBy: address(0),
731             loanAmount: 0,
732             loanInterest: 0,
733             loanDuration: 0,
734             startDay: 0,
735             endDay: 0
736         });
737 
738         emit CancelLoanRequest(
739             msg.sender,
740             block.timestamp,
741             _stakeId
742         );
743     }
744 
745     function _clearLoan(uint256 _stakeId) internal {
746         loan storage _loan = mapLoans[_stakeId];
747          if(_loan.filledBy == address(0)) {
748                 // Just an unfilled loan request so we can cancel it off
749                 _cancelLoanRequest(_stakeId);
750             } else  {
751                 // Loan was filled so if its not been claimed yet we need to 
752                 // send the repayment back to the loaner
753                 repayLoan(_stakeId);
754             }
755     }
756 
757     /**
758      * @dev Calculating a stakes ETH divs payout value by looping through each day of it
759      * @param _stakeId Id of the target stake
760      */
761     function calcStakeCollecting(uint256 _stakeId)
762         public
763         view
764         returns (uint256)
765     {
766         uint256 currentDay = _tokenContract.calcDay();
767         uint256 userDivs;
768         stake memory _stake = mapStakes[_stakeId];
769 
770         for (
771             uint256 _day = _stake.startDay;
772             _day < _stake.endDay && _day < currentDay;
773         ) {
774             userDivs +=
775                 (dayDividendPool[_day] * _stake.tokensStaked) /
776                 tokensInActiveStake[_day];
777 
778                 unchecked {
779                     _day++;
780                 }
781         }
782 
783         delete currentDay;
784         delete _stake;
785 
786         // remove any loans returned amount from the total
787         return (userDivs - _stake.loanRepayments);
788     }
789 
790     function listStakeForSale(uint256 _stakeId, uint256 _price) external {
791         stake memory _stake = mapStakes[_stakeId];
792         require(_stake.owner == msg.sender, "Unauthorised");
793         require(_stake.hasCollected == false, "Already Collected");
794 
795         uint256 _currentDay = _tokenContract.calcDay();
796         require(_stake.endDay >= _currentDay, "Stake has ended");
797 
798          // can't list a stake for sale whilst we have an outstanding loan against it
799         loan storage _loan = mapLoans[_stakeId];
800         require(_loan.requestedBy == address(0), "Stake has an outstanding loan request");
801 
802         mapStakes[_stakeId].forSalePrice = _price;
803 
804         emit SellStakeRequest(msg.sender, block.timestamp, _stakeId, _price);
805 
806         delete _currentDay;
807         delete _stake;
808     }
809 
810     function cancelStakeSellRequest(uint256 _stakeId) external {
811         require(mapStakes[_stakeId].owner == msg.sender, "Unauthorised");
812         require(mapStakes[_stakeId].forSalePrice > 0, "Stake is not for sale");
813         mapStakes[_stakeId].forSalePrice = 0;
814 
815         emit CancelStakeSellRequest(
816             msg.sender,
817             block.timestamp,
818             _stakeId
819         );
820     }
821 
822     function buyStake(uint256 _stakeId) external payable nonReentrant {
823         stake memory _stake = mapStakes[_stakeId];
824         require(_stake.forSalePrice > 0, "Stake not for sale");
825         require(_stake.owner != msg.sender, "Can't buy own stakes");
826 
827         loan storage _loan = mapLoans[_stakeId];
828         require(_loan.filledBy == address(0), "Can't buy stake with unpaid loan");
829 
830         uint256 _currentDay = _tokenContract.calcDay();
831         require(
832             _stake.endDay > _currentDay,
833             "stake can't be brought after it has ended"
834         );
835         require(_stake.hasCollected == false, "Stake already collected");
836         require(msg.value >= _stake.forSalePrice, "msg.value is < stake price");
837 
838         uint256 _devShare = (_stake.forSalePrice * devSellStakeFee) / 100;
839         uint256 _sellAmount =  _stake.forSalePrice - _devShare;
840 
841         dayDividendPool[_currentDay] += _devShare / 2;
842         devFees += _devShare / 2;
843 
844         _userStakes[msg.sender].push(_stakeId);
845 
846         mapStakes[_stakeId].owner = msg.sender;
847         mapStakes[_stakeId].forSalePrice = 0;
848 
849         Address.sendValue(payable(_stake.owner), _sellAmount);
850 
851         emit StakeSold(
852             _stake.owner,
853             msg.sender,
854             block.timestamp,
855             _sellAmount,
856             _stakeId
857         );
858 
859         delete _stake;
860     }
861 
862     /**
863      * @dev send the devFees to the dev wallet
864      */
865     function flushDevTaxes() external nonReentrant{
866         address _devWallet = _tokenContract.dev_addr();
867         uint256 _devFees = devFees;
868         devFees = 0;
869         Address.sendValue(payable(_devWallet), _devFees);
870     }
871 
872     function requestLoanOnStake(
873         uint256 _stakeId,
874         uint256 _loanAmount,
875         uint256 _interestAmount,
876         uint256 _duration
877     ) external {
878 
879         stake storage _stake = mapStakes[_stakeId];
880         require(_stake.owner == msg.sender, "Unauthorised");
881         require(_stake.hasCollected == false, "Already Collected");
882 
883         uint256 _currentDay = _tokenContract.calcDay();
884         require(_stake.endDay > (_currentDay + _duration), "Loan must expire before stake end day");
885 
886         loan storage _loan = mapLoans[_stakeId];
887         require(_loan.filledBy == address(0), "Stake already has outstanding loan");
888 
889         uint256 userDivs = calcStakeCollecting(_stakeId);
890         require(userDivs > ( _stake.loanRepayments + _loanAmount + _interestAmount), "Loan amount is > divs earned so far");
891 
892 
893         mapLoans[_stakeId] = loan({
894             requestedBy: msg.sender,
895             filledBy: address(0),
896             loanAmount: _loanAmount,
897             loanInterest: _interestAmount,
898             loanDuration: _duration,
899             startDay: 0,
900             endDay: 0
901         });
902 
903         emit NewLoanRequest(
904             msg.sender,
905             block.timestamp,
906             _loanAmount,
907             _interestAmount,
908             _duration,
909             _stakeId
910         );
911     }
912 
913     function fillLoan(uint256 _stakeId) external payable nonReentrant {
914         stake storage _stake = mapStakes[_stakeId];
915         loan storage _loan = mapLoans[_stakeId];
916         
917         require(_loan.requestedBy != address(0), "No active loan on this stake");
918         require(_stake.hasCollected == false, "Stake Collected");
919 
920         uint256 _currentDay = _tokenContract.calcDay();
921         require(_stake.endDay > _currentDay, "Stake ended");
922 
923         require(_stake.endDay > (_currentDay + _loan.loanDuration), "Loan must expire before stake end day");
924         
925         require(_loan.filledBy == address(0), "Already filled");
926         require(_loan.loanAmount <= msg.value, "Not enough eth");
927 
928         require(msg.sender != _stake.owner, "No lend on own stakes");
929 
930         if (_stake.forSalePrice > 0) {
931             // Can't sell a stake with an outstanding loan so we remove from sale
932             mapStakes[_stakeId].forSalePrice = 0;
933         }
934 
935         mapLoans[_stakeId] = loan({
936             requestedBy: _loan.requestedBy,
937             filledBy: msg.sender,
938             loanAmount: _loan.loanAmount,
939             loanInterest: _loan.loanInterest,
940             loanDuration: _loan.loanDuration,
941             startDay: _currentDay + 1,
942             endDay: _currentDay + 1 + _loan.loanDuration
943         });
944 
945         // Deduct fees
946         uint256 _devShare = (_loan.loanAmount * devLoanFeePercent) / 100;
947         uint256 _loanAmount = _loan.loanAmount - _devShare; 
948 
949         dayDividendPool[_currentDay] += _devShare / 2;
950         devFees += _devShare / 2;
951 
952         // Send the loan to the requester
953         Address.sendValue(payable(_loan.requestedBy), _loanAmount);
954 
955         _userLends[msg.sender].push(_stakeId);
956 
957         emit LoanRequestFilled(
958             msg.sender,
959             block.timestamp,
960             _stake.owner,
961             _loanAmount,
962             _stakeId
963         );
964     }
965 
966     /**
967      * This function is public so any can call and it
968      * will repay the loan to the loaner. Stakes can only
969      * have 1 active loan at a time so if the staker wants
970      * to take out a new loan they will have to call the 
971      * repayLoan function first to pay the outstanding 
972      * loan.
973      * This avoids us having to use an array and loop
974      * through loans to see which ones need paying back
975      * @param _stakeId the stake to repay the loan from 
976      */
977     function repayLoan(uint256 _stakeId) public {
978         loan memory _loan = mapLoans[_stakeId];
979         require(_loan.requestedBy != address(0), "No loan on stake");
980         require(_loan.filledBy != address(0), "Loan not filled");
981 
982         uint256 _currentDay = _tokenContract.calcDay();
983         require(_loan.endDay <= _currentDay, "Loan duration not met");
984 
985         // Save the payment here so its deducted from the divs 
986         // on withdrawal
987         mapStakes[_stakeId].loanRepayments += (  _loan.loanAmount + _loan.loanInterest );
988 
989         _cancelLoanRequest(_stakeId);
990         
991         Address.sendValue(payable(_loan.filledBy), _loan.loanAmount + _loan.loanInterest);
992 
993         // address indexed paidTo,
994         // uint256 timestamp,
995         // address interestAmount,
996         // uint256 loanamount,
997         // uint256 stakeId
998         emit LoanRepaid(
999             _loan.filledBy,
1000             block.timestamp,
1001             _loan.loanInterest,
1002             _loan.loanAmount,
1003             _stakeId
1004         );
1005     }
1006 
1007     function totalDividendPool() external view returns (uint256) {
1008         uint256 _day = _tokenContract.calcDay();
1009         // Prevent start day going to -1 on day 0
1010         if(_day <= 0) {
1011             return 0;
1012         }
1013         uint256 _startDay = _day;
1014         uint256 _total;
1015         for (uint256 i = 0; i <= (_startDay +  maxDividendRewardDays) ; ) {
1016             _total += dayDividendPool[_startDay + i];
1017             unchecked {
1018                  i++;
1019             }
1020         }
1021     
1022         return _total;
1023     }
1024 
1025     function userStakes(address _address) external view returns(uint256[] memory){
1026         return _userStakes[_address];
1027     }
1028 
1029     function userLends(address _address) external view returns (uint256[] memory) {
1030         return _userLends[_address];
1031     }
1032 }