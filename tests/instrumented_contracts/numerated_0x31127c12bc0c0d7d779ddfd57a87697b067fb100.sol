1 // File: contracts/interface/ICoFiXV2DAO.sol
2 
3 // SPDX-License-Identifier: GPL-3.0-or-later
4 
5 pragma solidity 0.6.12;
6 
7 interface ICoFiXV2DAO {
8 
9     function setGovernance(address gov) external;
10     function start() external; 
11 
12     // function addETHReward() external payable; 
13 
14     event FlagSet(address gov, uint256 flag);
15     event CoFiBurn(address gov, uint256 amount);
16 }
17 // File: contracts/interface/ICoFiXV2Controller.sol
18 
19 pragma solidity 0.6.12;
20 
21 interface ICoFiXV2Controller {
22 
23     event NewK(address token, uint256 K, uint256 sigma, uint256 T, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum);
24     event NewGovernance(address _new);
25     event NewOracle(address _priceOracle);
26     event NewKTable(address _kTable);
27     event NewTimespan(uint256 _timeSpan);
28     event NewKRefreshInterval(uint256 _interval);
29     event NewKLimit(int128 maxK0);
30     event NewGamma(int128 _gamma);
31     event NewTheta(address token, uint32 theta);
32     event NewK(address token, uint32 k);
33     event NewCGamma(address token, uint32 gamma);
34 
35     function addCaller(address caller) external;
36 
37     function setCGamma(address token, uint32 gamma) external;
38 
39     function queryOracle(address token, uint8 op, bytes memory data) external payable returns (uint256 k, uint256 ethAmount, uint256 erc20Amount, uint256 blockNum, uint256 theta);
40 
41     function getKInfo(address token) external view returns (uint32 k, uint32 updatedAt, uint32 theta);
42 
43     function getLatestPriceAndAvgVola(address token) external payable returns (uint256, uint256, uint256, uint256);
44 }
45 
46 // File: contracts/interface/ICoFiXV2Factory.sol
47 
48 pragma solidity 0.6.12;
49 
50 interface ICoFiXV2Factory {
51     // All pairs: {ETH <-> ERC20 Token}
52     event PairCreated(address indexed token, address pair, uint256);
53     event NewGovernance(address _new);
54     event NewController(address _new);
55     event NewFeeReceiver(address _new);
56     event NewFeeVaultForLP(address token, address feeVault);
57     event NewVaultForLP(address _new);
58     event NewVaultForTrader(address _new);
59     event NewVaultForCNode(address _new);
60     event NewDAO(address _new);
61 
62     /// @dev Create a new token pair for trading
63     /// @param  token the address of token to trade
64     /// @param  initToken0Amount the initial asset ratio (initToken0Amount:initToken1Amount)
65     /// @param  initToken1Amount the initial asset ratio (initToken0Amount:initToken1Amount)
66     /// @return pair the address of new token pair
67     function createPair(
68         address token,
69 	    uint256 initToken0Amount,
70         uint256 initToken1Amount
71         )
72         external
73         returns (address pair);
74 
75     function getPair(address token) external view returns (address pair);
76     function allPairs(uint256) external view returns (address pair);
77     function allPairsLength() external view returns (uint256);
78 
79     function getTradeMiningStatus(address token) external view returns (bool status);
80     function setTradeMiningStatus(address token, bool status) external;
81     function getFeeVaultForLP(address token) external view returns (address feeVault); // for LPs
82     function setFeeVaultForLP(address token, address feeVault) external;
83 
84     function setGovernance(address _new) external;
85     function setController(address _new) external;
86     function setFeeReceiver(address _new) external;
87     function setVaultForLP(address _new) external;
88     function setVaultForTrader(address _new) external;
89     function setVaultForCNode(address _new) external;
90     function setDAO(address _new) external;
91     function getController() external view returns (address controller);
92     function getFeeReceiver() external view returns (address feeReceiver); // For CoFi Holders
93     function getVaultForLP() external view returns (address vaultForLP);
94     function getVaultForTrader() external view returns (address vaultForTrader);
95     function getVaultForCNode() external view returns (address vaultForCNode);
96     function getDAO() external view returns (address dao);
97 }
98 
99 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
100 
101 pragma solidity >=0.6.0 <0.8.0;
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 // File: contracts/interface/ICoFiToken.sol
178 
179 pragma solidity 0.6.12;
180 
181 interface ICoFiToken is IERC20 {
182 
183     /// @dev An event thats emitted when a new governance account is set
184     /// @param  _new The new governance address
185     event NewGovernance(address _new);
186 
187     /// @dev An event thats emitted when a new minter account is added
188     /// @param  _minter The new minter address added
189     event MinterAdded(address _minter);
190 
191     /// @dev An event thats emitted when a minter account is removed
192     /// @param  _minter The minter address removed
193     event MinterRemoved(address _minter);
194 
195     /// @dev Set governance address of CoFi token. Only governance has the right to execute.
196     /// @param  _new The new governance address
197     function setGovernance(address _new) external;
198 
199     /// @dev Add a new minter account to CoFi token, who can mint tokens. Only governance has the right to execute.
200     /// @param  _minter The new minter address
201     function addMinter(address _minter) external;
202 
203     /// @dev Remove a minter account from CoFi token, who can mint tokens. Only governance has the right to execute.
204     /// @param  _minter The minter address removed
205     function removeMinter(address _minter) external;
206 
207     /// @dev mint is used to distribute CoFi token to users, minters are CoFi mining pools
208     /// @param  _to The receiver address
209     /// @param  _amount The amount of tokens minted
210     function mint(address _to, uint256 _amount) external;
211 }
212 
213 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
214 
215 pragma solidity >=0.6.0 <0.8.0;
216 
217 /**
218  * @dev Contract module that helps prevent reentrant calls to a function.
219  *
220  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
221  * available, which can be applied to functions to make sure there are no nested
222  * (reentrant) calls to them.
223  *
224  * Note that because there is a single `nonReentrant` guard, functions marked as
225  * `nonReentrant` may not call one another. This can be worked around by making
226  * those functions `private`, and then adding `external` `nonReentrant` entry
227  * points to them.
228  *
229  * TIP: If you would like to learn more about reentrancy and alternative ways
230  * to protect against it, check out our blog post
231  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
232  */
233 abstract contract ReentrancyGuard {
234     // Booleans are more expensive than uint256 or any type that takes up a full
235     // word because each write operation emits an extra SLOAD to first read the
236     // slot's contents, replace the bits taken up by the boolean, and then write
237     // back. This is the compiler's defense against contract upgrades and
238     // pointer aliasing, and it cannot be disabled.
239 
240     // The values being non-zero value makes deployment a bit more expensive,
241     // but in exchange the refund on every call to nonReentrant will be lower in
242     // amount. Since refunds are capped to a percentage of the total
243     // transaction's gas, it is best to keep them low in cases like this one, to
244     // increase the likelihood of the full refund coming into effect.
245     uint256 private constant _NOT_ENTERED = 1;
246     uint256 private constant _ENTERED = 2;
247 
248     uint256 private _status;
249 
250     constructor () internal {
251         _status = _NOT_ENTERED;
252     }
253 
254     /**
255      * @dev Prevents a contract from calling itself, directly or indirectly.
256      * Calling a `nonReentrant` function from another `nonReentrant`
257      * function is not supported. It is possible to prevent this from happening
258      * by making the `nonReentrant` function external, and make it call a
259      * `private` function that does the actual work.
260      */
261     modifier nonReentrant() {
262         // On the first call to nonReentrant, _notEntered will be true
263         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
264 
265         // Any calls to nonReentrant after this point will fail
266         _status = _ENTERED;
267 
268         _;
269 
270         // By storing the original value once again, a refund is triggered (see
271         // https://eips.ethereum.org/EIPS/eip-2200)
272         _status = _NOT_ENTERED;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/math/Math.sol
277 
278 pragma solidity >=0.6.0 <0.8.0;
279 
280 /**
281  * @dev Standard math utilities missing in the Solidity language.
282  */
283 library Math {
284     /**
285      * @dev Returns the largest of two numbers.
286      */
287     function max(uint256 a, uint256 b) internal pure returns (uint256) {
288         return a >= b ? a : b;
289     }
290 
291     /**
292      * @dev Returns the smallest of two numbers.
293      */
294     function min(uint256 a, uint256 b) internal pure returns (uint256) {
295         return a < b ? a : b;
296     }
297 
298     /**
299      * @dev Returns the average of two numbers. The result is rounded towards
300      * zero.
301      */
302     function average(uint256 a, uint256 b) internal pure returns (uint256) {
303         // (a + b) / 2 can overflow, so we distribute
304         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
305     }
306 }
307 
308 // File: contracts/lib/TransferHelper.sol
309 
310 pragma solidity 0.6.12;
311 
312 // helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
313 library TransferHelper {
314     function safeApprove(address token, address to, uint value) internal {
315         // bytes4(keccak256(bytes('approve(address,uint256)')));
316         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
317         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: APPROVE_FAILED');
318     }
319 
320     function safeTransfer(address token, address to, uint value) internal {
321         // bytes4(keccak256(bytes('transfer(address,uint256)')));
322         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
323         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FAILED');
324     }
325 
326     function safeTransferFrom(address token, address from, address to, uint value) internal {
327         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
328         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
329         require(success && (data.length == 0 || abi.decode(data, (bool))), 'TransferHelper: TRANSFER_FROM_FAILED');
330     }
331 
332     function safeTransferETH(address to, uint value) internal {
333         (bool success,) = to.call{value:value}(new bytes(0));
334         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
335     }
336 }
337 
338 // File: @openzeppelin/contracts/math/SafeMath.sol
339 
340 pragma solidity >=0.6.0 <0.8.0;
341 
342 /**
343  * @dev Wrappers over Solidity's arithmetic operations with added overflow
344  * checks.
345  *
346  * Arithmetic operations in Solidity wrap on overflow. This can easily result
347  * in bugs, because programmers usually assume that an overflow raises an
348  * error, which is the standard behavior in high level programming languages.
349  * `SafeMath` restores this intuition by reverting the transaction when an
350  * operation overflows.
351  *
352  * Using this library instead of the unchecked operations eliminates an entire
353  * class of bugs, so it's recommended to use it always.
354  */
355 library SafeMath {
356     /**
357      * @dev Returns the addition of two unsigned integers, with an overflow flag.
358      *
359      * _Available since v3.4._
360      */
361     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
362         uint256 c = a + b;
363         if (c < a) return (false, 0);
364         return (true, c);
365     }
366 
367     /**
368      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
369      *
370      * _Available since v3.4._
371      */
372     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
373         if (b > a) return (false, 0);
374         return (true, a - b);
375     }
376 
377     /**
378      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
384         // benefit is lost if 'b' is also tested.
385         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
386         if (a == 0) return (true, 0);
387         uint256 c = a * b;
388         if (c / a != b) return (false, 0);
389         return (true, c);
390     }
391 
392     /**
393      * @dev Returns the division of two unsigned integers, with a division by zero flag.
394      *
395      * _Available since v3.4._
396      */
397     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
398         if (b == 0) return (false, 0);
399         return (true, a / b);
400     }
401 
402     /**
403      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
404      *
405      * _Available since v3.4._
406      */
407     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
408         if (b == 0) return (false, 0);
409         return (true, a % b);
410     }
411 
412     /**
413      * @dev Returns the addition of two unsigned integers, reverting on
414      * overflow.
415      *
416      * Counterpart to Solidity's `+` operator.
417      *
418      * Requirements:
419      *
420      * - Addition cannot overflow.
421      */
422     function add(uint256 a, uint256 b) internal pure returns (uint256) {
423         uint256 c = a + b;
424         require(c >= a, "SafeMath: addition overflow");
425         return c;
426     }
427 
428     /**
429      * @dev Returns the subtraction of two unsigned integers, reverting on
430      * overflow (when the result is negative).
431      *
432      * Counterpart to Solidity's `-` operator.
433      *
434      * Requirements:
435      *
436      * - Subtraction cannot overflow.
437      */
438     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
439         require(b <= a, "SafeMath: subtraction overflow");
440         return a - b;
441     }
442 
443     /**
444      * @dev Returns the multiplication of two unsigned integers, reverting on
445      * overflow.
446      *
447      * Counterpart to Solidity's `*` operator.
448      *
449      * Requirements:
450      *
451      * - Multiplication cannot overflow.
452      */
453     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
454         if (a == 0) return 0;
455         uint256 c = a * b;
456         require(c / a == b, "SafeMath: multiplication overflow");
457         return c;
458     }
459 
460     /**
461      * @dev Returns the integer division of two unsigned integers, reverting on
462      * division by zero. The result is rounded towards zero.
463      *
464      * Counterpart to Solidity's `/` operator. Note: this function uses a
465      * `revert` opcode (which leaves remaining gas untouched) while Solidity
466      * uses an invalid opcode to revert (consuming all remaining gas).
467      *
468      * Requirements:
469      *
470      * - The divisor cannot be zero.
471      */
472     function div(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b > 0, "SafeMath: division by zero");
474         return a / b;
475     }
476 
477     /**
478      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
479      * reverting when dividing by zero.
480      *
481      * Counterpart to Solidity's `%` operator. This function uses a `revert`
482      * opcode (which leaves remaining gas untouched) while Solidity uses an
483      * invalid opcode to revert (consuming all remaining gas).
484      *
485      * Requirements:
486      *
487      * - The divisor cannot be zero.
488      */
489     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
490         require(b > 0, "SafeMath: modulo by zero");
491         return a % b;
492     }
493 
494     /**
495      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
496      * overflow (when the result is negative).
497      *
498      * CAUTION: This function is deprecated because it requires allocating memory for the error
499      * message unnecessarily. For custom revert reasons use {trySub}.
500      *
501      * Counterpart to Solidity's `-` operator.
502      *
503      * Requirements:
504      *
505      * - Subtraction cannot overflow.
506      */
507     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
508         require(b <= a, errorMessage);
509         return a - b;
510     }
511 
512     /**
513      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
514      * division by zero. The result is rounded towards zero.
515      *
516      * CAUTION: This function is deprecated because it requires allocating memory for the error
517      * message unnecessarily. For custom revert reasons use {tryDiv}.
518      *
519      * Counterpart to Solidity's `/` operator. Note: this function uses a
520      * `revert` opcode (which leaves remaining gas untouched) while Solidity
521      * uses an invalid opcode to revert (consuming all remaining gas).
522      *
523      * Requirements:
524      *
525      * - The divisor cannot be zero.
526      */
527     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
528         require(b > 0, errorMessage);
529         return a / b;
530     }
531 
532     /**
533      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
534      * reverting with custom message when dividing by zero.
535      *
536      * CAUTION: This function is deprecated because it requires allocating memory for the error
537      * message unnecessarily. For custom revert reasons use {tryMod}.
538      *
539      * Counterpart to Solidity's `%` operator. This function uses a `revert`
540      * opcode (which leaves remaining gas untouched) while Solidity uses an
541      * invalid opcode to revert (consuming all remaining gas).
542      *
543      * Requirements:
544      *
545      * - The divisor cannot be zero.
546      */
547     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
548         require(b > 0, errorMessage);
549         return a % b;
550     }
551 }
552 
553 // File: contracts/CoFiXV2DAO.sol
554 
555 pragma solidity 0.6.12;
556 
557 contract CoFiXV2DAO is ICoFiXV2DAO, ReentrancyGuard {
558 
559     using SafeMath for uint256;
560 
561     /* ========== STATE ============== */
562 
563     uint8 public flag; 
564 
565     uint32  public startedBlock;
566     // uint32  public lastCollectingBlock;
567     uint32 public lastBlock;
568     uint128 public redeemedAmount;
569     uint128 public quotaAmount;
570 
571     uint8 constant DAO_FLAG_UNINITIALIZED    = 0;
572     uint8 constant DAO_FLAG_INITIALIZED      = 1;
573     uint8 constant DAO_FLAG_ACTIVE           = 2;
574     uint8 constant DAO_FLAG_NO_STAKING       = 3;
575     uint8 constant DAO_FLAG_PAUSED           = 4;
576     uint8 constant DAO_FLAG_SHUTDOWN         = 127;
577 
578     /* ========== PARAMETERS ============== */
579 
580     uint256 constant DAO_REPURCHASE_PRICE_DEVIATION = 10;  // price deviation < 5% 
581     uint256 constant _oracleFee = 0.01 ether;
582 
583 
584     /* ========== ADDRESSES ============== */
585 
586     address public cofiToken;
587 
588     address public factory;
589 
590     address public governance;
591 
592     /* ========== CONSTRUCTOR ========== */
593 
594     receive() external payable {
595     }
596 
597     constructor(address _cofiToken, address _factory) public {
598         cofiToken = _cofiToken;
599         factory = _factory;
600         governance = msg.sender;
601         flag = DAO_FLAG_INITIALIZED;
602     }
603 
604     /* ========== MODIFIERS ========== */
605 
606     modifier onlyGovernance() 
607     {
608         require(msg.sender == governance, "CDAO: not governance");
609         _;
610     }
611 
612     modifier whenActive() 
613     {
614         require(flag == DAO_FLAG_ACTIVE, "CDAO: not active");
615         _;
616     }
617 
618     /* ========== GOVERNANCE ========== */
619 
620     function setGovernance(address _new) external override onlyGovernance {
621         governance = _new;
622     }
623 
624     function start() override external onlyGovernance
625     {  
626         require(flag == DAO_FLAG_INITIALIZED, "CDAO: not initialized");
627 
628         startedBlock = uint32(block.number);
629         flag = DAO_FLAG_ACTIVE;
630         emit FlagSet(address(msg.sender), uint256(DAO_FLAG_ACTIVE));
631     }
632 
633     function pause() external onlyGovernance
634     {
635         flag = DAO_FLAG_PAUSED;
636         emit FlagSet(address(msg.sender), uint256(DAO_FLAG_PAUSED));
637     }
638 
639     function resume() external onlyGovernance
640     {
641         flag = DAO_FLAG_ACTIVE;
642         emit FlagSet(address(msg.sender), uint256(DAO_FLAG_ACTIVE));
643     }
644 
645     function totalETHRewards()
646         external view returns (uint256) 
647     {
648        return address(this).balance;
649     }
650 
651     function migrateTo(address _newDAO) external onlyGovernance
652     {
653         require(flag == DAO_FLAG_PAUSED, "CDAO: not paused");
654         
655         if(address(this).balance > 0) {
656             TransferHelper.safeTransferETH(_newDAO, address(this).balance);
657         }
658         // ICoFiXV2DAO(_newDAO).addETHReward{value: address(this).balance}();
659 
660         uint256 _cofiTokenAmount = ICoFiToken(cofiToken).balanceOf(address(this));
661         if (_cofiTokenAmount > 0) {
662             ICoFiToken(cofiToken).transfer(_newDAO, _cofiTokenAmount);
663         }
664     }
665 
666     function burnCofi(uint256 amount) external onlyGovernance {
667         require(amount > 0, "CDAO: illegal amount");
668 
669         uint256 _cofiTokenAmount = ICoFiToken(cofiToken).balanceOf(address(this));
670 
671         require(_cofiTokenAmount >= amount, "CDAO: insufficient cofi");
672 
673         ICoFiToken(cofiToken).transfer(address(0x1), amount);
674         emit CoFiBurn(address(msg.sender), amount);
675     }
676 
677     /* ========== MAIN ========== */
678 
679     // function addETHReward() 
680     //     override
681     //     external
682     //     payable
683     // { }
684 
685     function redeem(uint256 amount) 
686         external payable nonReentrant whenActive
687     {
688         require(address(this).balance > 0, "CDAO: insufficient balance");
689         require (msg.value == _oracleFee, "CDAO: !oracleFee");
690 
691         // check the repurchasing quota
692         uint256 quota = quotaOf();
693 
694         uint256 price;
695         {
696             // check if the price is steady
697             (uint256 ethAmount, uint256 tokenAmount, uint256 avg, ) = ICoFiXV2Controller(ICoFiXV2Factory(factory).getController())
698                     .getLatestPriceAndAvgVola{value: msg.value}(cofiToken);
699             price = tokenAmount.mul(1e18).div(ethAmount);
700 
701             uint256 diff = price > avg ? (price - avg) : (avg - price);
702             bool isDeviated = (diff.mul(100) < avg.mul(DAO_REPURCHASE_PRICE_DEVIATION))? false : true;
703             require(isDeviated == false, "CDAO: price deviation"); // validate
704         }
705 
706         // check if there is sufficient quota for repurchase
707         require (amount <= quota, "CDAO: insufficient quota");
708         require (amount.mul(1e18) <= address(this).balance.mul(price), "CDAO: insufficient balance2");
709 
710         redeemedAmount = uint128(amount.add(redeemedAmount));
711         quotaAmount = uint128(quota.sub(amount));
712         lastBlock = uint32(block.number);
713 
714         uint256 amountEthOut = amount.mul(1e18).div(price);
715 
716         // transactions
717         ICoFiToken(cofiToken).transferFrom(address(msg.sender), address(this), amount);
718         TransferHelper.safeTransferETH(msg.sender, amountEthOut);
719     }
720 
721     function _quota() internal view returns (uint256 quota) 
722     {
723         uint256 n = 100;
724         uint256 intv = (lastBlock == 0) ? 
725             (block.number).sub(startedBlock) : (block.number).sub(uint256(lastBlock));
726         uint256 _acc = (n * intv > 30_000) ? 30_000 : (n * intv);
727 
728         // check if total amounts overflow
729         uint256 total = _acc.mul(1e18).add(quotaAmount);
730         if (total > uint256(30_000).mul(1e18)){
731             quota = uint256(30_000).mul(1e18);
732         } else{
733             quota = total;
734         }
735     }
736 
737     /* ========== VIEWS ========== */
738 
739     function quotaOf() public view returns (uint256 quota) 
740     {
741         return _quota();
742     }
743 
744 }