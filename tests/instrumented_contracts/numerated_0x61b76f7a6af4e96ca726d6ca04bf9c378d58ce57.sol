1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 pragma solidity ^0.5.17;
6 
7 /**
8  * Math operations with safety checks
9  */
10 library SafeMath {
11     /**
12      * @dev Returns the addition of two unsigned integers, reverting on
13      * overflow.
14      *
15      * Counterpart to Solidity's `+` operator.
16      *
17      * Requirements:
18      * - Addition cannot overflow.
19      */
20     function add(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a + b;
22         require(c >= a, "SafeMath: addition overflow");
23 
24         return c;
25     }
26 
27     /**
28      * @dev Returns the subtraction of two unsigned integers, reverting on
29      * overflow (when the result is negative).
30      *
31      * Counterpart to Solidity's `-` operator.
32      *
33      * Requirements:
34      * - Subtraction cannot overflow.
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      * - Subtraction cannot overflow.
48      *
49      * _Available since v2.4.0._
50      */
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54 
55         return c;
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, reverting on
60      * overflow.
61      *
62      * Counterpart to Solidity's `*` operator.
63      *
64      * Requirements:
65      * - Multiplication cannot overflow.
66      */
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
69         // benefit is lost if 'b' is also tested.
70         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
71         if (a == 0) {
72             return 0;
73         }
74 
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77 
78         return c;
79     }
80 
81     /**
82      * @dev Returns the integer division of two unsigned integers. Reverts on
83      * division by zero. The result is rounded towards zero.
84      *
85      * Counterpart to Solidity's `/` operator. Note: this function uses a
86      * `revert` opcode (which leaves remaining gas untouched) while Solidity
87      * uses an invalid opcode to revert (consuming all remaining gas).
88      *
89      * Requirements:
90      * - The divisor cannot be zero.
91      */
92     function div(uint256 a, uint256 b) internal pure returns (uint256) {
93         return div(a, b, "SafeMath: division by zero");
94     }
95 
96     /**
97      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
98      * division by zero. The result is rounded towards zero.
99      *
100      * Counterpart to Solidity's `/` operator. Note: this function uses a
101      * `revert` opcode (which leaves remaining gas untouched) while Solidity
102      * uses an invalid opcode to revert (consuming all remaining gas).
103      *
104      * Requirements:
105      * - The divisor cannot be zero.
106      *
107      * _Available since v2.4.0._
108      */
109     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
110         // Solidity only automatically asserts when dividing by 0
111         require(b > 0, errorMessage);
112         uint256 c = a / b;
113         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
120      * Reverts when dividing by zero.
121      *
122      * Counterpart to Solidity's `%` operator. This function uses a `revert`
123      * opcode (which leaves remaining gas untouched) while Solidity uses an
124      * invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
130         return mod(a, b, "SafeMath: modulo by zero");
131     }
132 
133     /**
134      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
135      * Reverts with custom message when dividing by zero.
136      *
137      * Counterpart to Solidity's `%` operator. This function uses a `revert`
138      * opcode (which leaves remaining gas untouched) while Solidity uses an
139      * invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      *
144      * _Available since v2.4.0._
145      */
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 interface IERC20 {
153     /**
154      * @dev Returns the amount of tokens in existence.
155      */
156     function totalSupply() external view returns (uint256);
157 
158     /**
159      * @dev Returns the amount of tokens owned by `account`.
160      */
161     function balanceOf(address account) external view returns (uint256);
162 
163     /**
164      * @dev Moves `amount` tokens from the caller's account to `recipient`.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transfer(address recipient, uint256 amount)
171         external
172         returns (bool);
173 
174     function mint(address account, uint256 amount) external;
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender)
184         external
185         view
186         returns (uint256);
187 
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an {Approval} event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Moves `amount` tokens from `sender` to `recipient` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(
232         address indexed owner,
233         address indexed spender,
234         uint256 value
235     );
236 }
237 
238 // File: @openzeppelin/contracts/utils/Address.sol
239 
240 pragma solidity ^0.5.5;
241 
242 /**
243  * @dev Collection of functions related to the address type
244  */
245 library Address {
246     /**
247      * @dev Returns true if `account` is a contract.
248      *
249      * This test is non-exhaustive, and there may be false-negatives: during the
250      * execution of a contract's constructor, its address will be reported as
251      * not containing a contract.
252      *
253      * IMPORTANT: It is unsafe to assume that an address for which this
254      * function returns false is an externally-owned account (EOA) and not a
255      * contract.
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies in extcodesize, which returns 0 for contracts in
259         // construction, since the code is only stored at the end of the
260         // constructor execution.
261 
262         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
263         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
264         // for accounts without code, i.e. `keccak256('')`
265         bytes32 codehash;
266 
267             bytes32 accountHash
268          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
269         // solhint-disable-next-line no-inline-assembly
270         assembly {
271             codehash := extcodehash(account)
272         }
273         return (codehash != 0x0 && codehash != accountHash);
274     }
275 
276     /**
277      * @dev Converts an `address` into `address payable`. Note that this is
278      * simply a type cast: the actual underlying value is not changed.
279      *
280      * _Available since v2.4.0._
281      */
282     function toPayable(address account)
283         internal
284         pure
285         returns (address payable)
286     {
287         return address(uint160(account));
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      *
306      * _Available since v2.4.0._
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(
310             address(this).balance >= amount,
311             "Address: insufficient balance"
312         );
313 
314         // solhint-disable-next-line avoid-call-value
315         (bool success, ) = recipient.call.value(amount)("");
316         require(
317             success,
318             "Address: unable to send value, recipient may have reverted"
319         );
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
324 
325 pragma solidity ^0.5.0;
326 
327 /**
328  * @title SafeERC20
329  * @dev Wrappers around ERC20 operations that throw on failure (when the token
330  * contract returns false). Tokens that return no value (and instead revert or
331  * throw on failure) are also supported, non-reverting calls are assumed to be
332  * successful.
333  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
334  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
335  */
336 library SafeERC20 {
337     using SafeMath for uint256;
338     using Address for address;
339 
340     function safeTransfer(
341         IERC20 token,
342         address to,
343         uint256 value
344     ) internal {
345         callOptionalReturn(
346             token,
347             abi.encodeWithSelector(token.transfer.selector, to, value)
348         );
349     }
350 
351     function safeTransferFrom(
352         IERC20 token,
353         address from,
354         address to,
355         uint256 value
356     ) internal {
357         callOptionalReturn(
358             token,
359             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
360         );
361     }
362 
363     function safeApprove(
364         IERC20 token,
365         address spender,
366         uint256 value
367     ) internal {
368         // safeApprove should only be called when setting an initial allowance,
369         // or when resetting it to zero. To increase and decrease it, use
370         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
371         // solhint-disable-next-line max-line-length
372         require(
373             (value == 0) || (token.allowance(address(this), spender) == 0),
374             "SafeERC20: approve from non-zero to non-zero allowance"
375         );
376         callOptionalReturn(
377             token,
378             abi.encodeWithSelector(token.approve.selector, spender, value)
379         );
380     }
381 
382     function safeIncreaseAllowance(
383         IERC20 token,
384         address spender,
385         uint256 value
386     ) internal {
387         uint256 newAllowance = token.allowance(address(this), spender).add(
388             value
389         );
390         callOptionalReturn(
391             token,
392             abi.encodeWithSelector(
393                 token.approve.selector,
394                 spender,
395                 newAllowance
396             )
397         );
398     }
399 
400     function safeDecreaseAllowance(
401         IERC20 token,
402         address spender,
403         uint256 value
404     ) internal {
405         uint256 newAllowance = token.allowance(address(this), spender).sub(
406             value,
407             "SafeERC20: decreased allowance below zero"
408         );
409         callOptionalReturn(
410             token,
411             abi.encodeWithSelector(
412                 token.approve.selector,
413                 spender,
414                 newAllowance
415             )
416         );
417     }
418 
419     /**
420      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
421      * on the return value: the return value is optional (but if data is returned, it must not be false).
422      * @param token The token targeted by the call.
423      * @param data The call data (encoded using abi.encode or one of its variants).
424      */
425     function callOptionalReturn(IERC20 token, bytes memory data) private {
426         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
427         // we're implementing it ourselves.
428 
429         // A Solidity high level call has three parts:
430         //  1. The target address is checked to verify it contains contract code
431         //  2. The call itself is made, and success asserted
432         //  3. The return value is decoded, which in turn checks the size of the returned data.
433         // solhint-disable-next-line max-line-length
434         require(address(token).isContract(), "SafeERC20: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = address(token).call(data);
438         require(success, "SafeERC20: low-level call failed");
439 
440         if (returndata.length > 0) {
441             // Return data is optional
442             // solhint-disable-next-line max-line-length
443             require(
444                 abi.decode(returndata, (bool)),
445                 "SafeERC20: ERC20 operation did not succeed"
446             );
447         }
448     }
449 }
450 
451 contract Context {
452     // Empty internal constructor, to prevent people from mistakenly deploying
453     // an instance of this contract, which should be used via inheritance.
454     constructor () internal { }
455     // solhint-disable-previous-line no-empty-blocks
456 
457     function _msgSender() internal view returns (address payable) {
458         return msg.sender;
459     }
460 
461     function _msgData() internal view returns (bytes memory) {
462         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
463         return msg.data;
464     }
465 }
466 
467 contract Ownable is Context {
468     address private _owner;
469 
470     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
471 
472     /**
473      * @dev Initializes the contract setting the deployer as the initial owner.
474      */
475     constructor () internal {
476         _owner = _msgSender();
477         emit OwnershipTransferred(address(0), _owner);
478     }
479 
480     /**
481      * @dev Returns the address of the current owner.
482      */
483     function owner() public view returns (address) {
484         return _owner;
485     }
486 
487     /**
488      * @dev Throws if called by any account other than the owner.
489      */
490     modifier onlyOwner() {
491         require(isOwner(), "Ownable: caller is not the owner");
492         _;
493     }
494 
495     /**
496      * @dev Returns true if the caller is the current owner.
497      */
498     function isOwner() public view returns (bool) {
499         return _msgSender() == _owner;
500     }
501 
502     /**
503      * @dev Leaves the contract without owner. It will not be possible to call
504      * `onlyOwner` functions anymore. Can only be called by the current owner.
505      *
506      * NOTE: Renouncing ownership will leave the contract without an owner,
507      * thereby removing any functionality that is only available to the owner.
508      */
509     function renounceOwnership() public onlyOwner {
510         emit OwnershipTransferred(_owner, address(0));
511         _owner = address(0);
512     }
513 
514     /**
515      * @dev Transfers ownership of the contract to a new account (`newOwner`).
516      * Can only be called by the current owner.
517      */
518     function transferOwnership(address newOwner) public onlyOwner {
519         _transferOwnership(newOwner);
520     }
521 
522     /**
523      * @dev Transfers ownership of the contract to a new account (`newOwner`).
524      */
525     function _transferOwnership(address newOwner) internal {
526         require(newOwner != address(0), "Ownable: new owner is the zero address");
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 
533 
534 contract VampTokenSale is Ownable {
535     using SafeMath for uint256;
536     using SafeERC20 for IERC20;
537     IERC20 public usdt = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
538     address public collector = 0x45a6b8BdfC1FAa745720165e0B172A3D6D4EC897;
539     string public name = "VAMP Presale";
540 
541     IERC20 public VAMP = IERC20(0xb2C822a1b923E06Dbd193d2cFc7ad15388EA09DD);
542     address public beneficiary;
543 
544     uint256 public hardCap;
545     uint256 public softCap;
546     uint256 public tokensPerUSDT;
547     uint256 public purchaseLimitStageOne = 500 * 1e6;
548     uint256 public purchaseLimitStageTwo = 2000 * 1e6;
549     uint256 public purchaseLimitStageThree = 10000 * 1e6;
550 
551     uint256 public tokensSold = 0;
552     uint256 public usdtRaised = 0;
553     uint256 public investorCount = 0;
554     uint256 public weiRefunded = 0;
555     uint256 public minAmount = 1 * 1e6;
556     uint256 public maxAmount = 10000 * 1e6;
557 
558     uint256 public startTime;
559     uint256 public endTime;
560     uint256 public stageOne = 2 hours;
561     uint256 public stageTwo = 4 hours;
562     uint256 public timeHardCapReached;
563 
564     bool public softCapReached = false;
565     bool public crowdsaleFinished = false;
566    // address[] public whitelistAddress;
567     mapping(address => uint256) sold;
568     mapping(address => uint256) whitelistAmount;
569     mapping(address => bool) whitelistedAddress;
570     mapping(address => uint256) tokensAlreadyBought;
571 
572     event GoalReached(uint256 amountRaised);
573     event HardCapReached(uint256 hardcap);
574     event NewContribution(
575         address indexed holder,
576         uint256 tokenAmount,
577         uint256 etherAmount
578     );
579     event Refunded(address indexed holder, uint256 amount);
580 
581     modifier onlyAfter(uint256 time) {
582         require(now >= time);
583         _;
584     }
585 
586     modifier onlyBefore(uint256 time) {
587         require(now <= time);
588         _;
589     }
590 
591       modifier claimEnabled() {
592         require(block.timestamp.add(1 hours) >= timeHardCapReached);
593         _;
594     }
595 
596     constructor ( // in token-wei. i.e. number of presale tokens * 10^18
597         uint256 _startTime // start time (unix time, in seconds since 1970-01-01)
598        // address[] memory whitelistAddresses // presale duration in hours
599     ) public {
600         hardCap = 550000 * 1e6;
601         tokensPerUSDT = 10000000000000;
602         startTime = _startTime;
603         endTime = _startTime + 48 hours;
604         timeHardCapReached = endTime;
605        // whitelistAddress = whitelistAddresses;
606     }
607 
608     function() payable external {
609         revert("not purchased by eth");
610         // doPurchase(msg.sender);
611     }
612     function canClaim() public view returns (bool){
613          if(block.timestamp.add(1 hours) >= timeHardCapReached){
614              return true;
615          } else {
616              return false;
617          }
618     }
619 
620   /*  function refund() external onlyAfter(endTime) {
621         require(!softCapReached);
622         uint256 balance = sold[msg.sender];
623         require(balance > 0);
624         uint256 refund = balance / tokensPerUSDT;
625         msg.sender.transfer(refund);
626         delete sold[msg.sender];
627         weiRefunded = weiRefunded.add(refund);
628         token.refundPresale(msg.sender, balance);
629         Refunded(msg.sender, refund);
630     }*/
631     
632     function addWhiteListedAddresses(address[] memory _addresses) public onlyOwner {
633         require(_addresses.length > 0);
634         for (uint i = 0; i < _addresses.length; i++) {
635          whitelistedAddress[_addresses[i]] = true;
636     }
637     }
638     
639     function isWhitelisted(address _address) public view returns (bool) {
640         if(whitelistedAddress[_address]) {
641             return true;
642         } else {
643             return false;
644         }
645     }
646     function simulatebuy(uint256 amount) public view returns (uint256) {
647           uint256 tokens = amount * tokensPerUSDT;
648           return tokens;
649     }
650     
651     function tokensBought(address _address) public view returns (uint256) {
652         return tokensAlreadyBought[_address];
653     }
654     
655     function tokensAlreadySold() public view returns (uint256) {
656         return tokensSold;
657     }
658     
659     function raisedUSDT() public view returns (uint256) {
660         return usdtRaised;
661     }
662     function usdtDeposited(address _address) public view returns (uint256) {
663         return whitelistAmount[_address].add(sold[_address]);
664     }
665     
666     function getStage() public view returns (uint256) {
667          if (block.timestamp <= startTime.add(stageOne)) {
668              return 1;
669          } else if(block.timestamp >= startTime.add(stageOne) &&
670             block.timestamp <= startTime.add(stageTwo)) {
671                 return 2;
672             } else {
673                 return 3;
674             }
675     }
676     
677 
678     function withdrawTokens() public onlyOwner onlyAfter(timeHardCapReached) {
679         VAMP.safeTransfer(collector, VAMP.balanceOf(address(this)));
680     }
681 
682     function claimTokens() public claimEnabled() {
683         
684         if(tokensAlreadyBought[msg.sender] > 0){
685         VAMP.safeTransfer(msg.sender,tokensAlreadyBought[msg.sender]);
686         tokensAlreadyBought[msg.sender]= 0;
687         } else {
688             revert("No tokens to claim");
689         }
690        
691     }
692 
693     function purchase(uint256 amount) public {
694         require(amount > minAmount,"Must be more than minumum amount 1USDT");
695         require(amount <= maxAmount,"Must be smaller than max amount 10k usdt");
696       doPurchase(amount);
697     }
698      function doPurchase(uint256 amount)
699         private
700         onlyAfter(startTime)
701         onlyBefore(endTime)
702     {
703         assert(crowdsaleFinished == false);
704 
705         require(usdtRaised.add(amount) <= hardCap,"cant deposit without triggering hardcap");
706         if (block.timestamp <= startTime.add(stageOne) && isWhitelisted(msg.sender)) {
707             //first 2 hours
708             uint256 tokens = amount * tokensPerUSDT;
709             require(
710                 amount <= purchaseLimitStageOne,
711                 "Over purchase limit in stage one"
712             );
713             require(
714                 whitelistAmount[msg.sender].add(amount) <= purchaseLimitStageOne,
715                 "can't purchase more than allowed amount stage one"
716             );
717             usdt.safeTransferFrom(msg.sender, collector, amount);
718             whitelistAmount[msg.sender] = whitelistAmount[msg.sender].add(
719                 amount
720             );
721             usdtRaised = usdtRaised.add(amount);
722             tokensSold = tokensSold.add(tokens);
723             tokensAlreadyBought[msg.sender] = tokensAlreadyBought[msg.sender].add(tokens);
724         } else if (
725             block.timestamp >= startTime.add(stageOne) &&
726             block.timestamp <= startTime.add(stageTwo)
727         ) {
728             //first 2 - 4 hours
729 
730             uint256 tokens = amount * tokensPerUSDT;
731             require(
732                 amount <= purchaseLimitStageTwo,
733                 "Over purchase limit in stage two"
734             );
735             require(
736                 sold[msg.sender].add(amount) <=
737                     purchaseLimitStageTwo,
738                 "can't purchase more than allowed amount stage two"
739             );
740             sold[msg.sender] = sold[msg.sender].add(amount);
741             usdt.safeTransferFrom(msg.sender, collector, amount);
742             usdtRaised = usdtRaised.add(amount);
743             tokensSold = tokensSold.add(tokens);
744             tokensAlreadyBought[msg.sender] = tokensAlreadyBought[msg.sender].add(tokens);
745         } else if (block.timestamp > startTime.add(stageTwo)) {
746             //4 - 48 hours
747              uint256 tokens = amount * tokensPerUSDT;
748              require(
749                 amount <= purchaseLimitStageThree,
750                 "Over purchase limit in stage three"
751             );
752                require(
753                 sold[msg.sender].add(amount) <=
754                     purchaseLimitStageThree,
755                 "can't purchase more than allowed amount stage three"
756             );
757             sold[msg.sender] = sold[msg.sender].add(amount);
758             usdt.safeTransferFrom(msg.sender, collector, amount);
759             usdtRaised = usdtRaised.add(amount);
760             tokensSold = tokensSold.add(tokens);
761             tokensAlreadyBought[msg.sender] = tokensAlreadyBought[msg.sender].add(tokens);
762         }
763          if (usdtRaised == hardCap) {
764           timeHardCapReached = block.timestamp;
765           crowdsaleFinished = true;
766           emit HardCapReached(timeHardCapReached);
767         }
768 
769     }
770 }