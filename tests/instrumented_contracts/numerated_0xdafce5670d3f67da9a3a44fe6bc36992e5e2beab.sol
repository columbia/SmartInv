1 // SPDX-License-Identifier: No
2 
3 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
4 
5 pragma solidity >=0.5.0;
6 
7 interface IUniswapV2Pair {
8     event Approval(address indexed owner, address indexed spender, uint value);
9     event Transfer(address indexed from, address indexed to, uint value);
10 
11     function name() external pure returns (string memory);
12     function symbol() external pure returns (string memory);
13     function decimals() external pure returns (uint8);
14     function totalSupply() external view returns (uint);
15     function balanceOf(address owner) external view returns (uint);
16     function allowance(address owner, address spender) external view returns (uint);
17 
18     function approve(address spender, uint value) external returns (bool);
19     function transfer(address to, uint value) external returns (bool);
20     function transferFrom(address from, address to, uint value) external returns (bool);
21 
22     function DOMAIN_SEPARATOR() external view returns (bytes32);
23     function PERMIT_TYPEHASH() external pure returns (bytes32);
24     function nonces(address owner) external view returns (uint);
25 
26     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
27 
28     event Mint(address indexed sender, uint amount0, uint amount1);
29     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
30     event Swap(
31         address indexed sender,
32         uint amount0In,
33         uint amount1In,
34         uint amount0Out,
35         uint amount1Out,
36         address indexed to
37     );
38     event Sync(uint112 reserve0, uint112 reserve1);
39 
40     function MINIMUM_LIQUIDITY() external pure returns (uint);
41     function factory() external view returns (address);
42     function token0() external view returns (address);
43     function token1() external view returns (address);
44     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
45     function price0CumulativeLast() external view returns (uint);
46     function price1CumulativeLast() external view returns (uint);
47     function kLast() external view returns (uint);
48 
49     function mint(address to) external returns (uint liquidity);
50     function burn(address to) external returns (uint amount0, uint amount1);
51     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
52     function skim(address to) external;
53     function sync() external;
54 
55     function initialize(address, address) external;
56 }
57 
58 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
59 
60 pragma solidity >=0.5.0;
61 
62 interface IUniswapV2Factory {
63     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
64 
65     function feeTo() external view returns (address);
66     function feeToSetter() external view returns (address);
67 
68     function getPair(address tokenA, address tokenB) external view returns (address pair);
69     function allPairs(uint) external view returns (address pair);
70     function allPairsLength() external view returns (uint);
71 
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 
74     function setFeeTo(address) external;
75     function setFeeToSetter(address) external;
76 }
77 
78 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
79 
80 
81 pragma solidity ^0.6.0;
82 
83 /**
84  * @dev Interface of the ERC20 standard as defined in the EIP.
85  */
86 interface IERC20 {
87     /**
88      * @dev Returns the amount of tokens in existence.
89      */
90     function totalSupply() external view returns (uint256);
91 
92     /**
93      * @dev Returns the amount of tokens owned by `account`.
94      */
95     function balanceOf(address account) external view returns (uint256);
96 
97     /**
98      * @dev Moves `amount` tokens from the caller's account to `recipient`.
99      *
100      * Returns a boolean value indicating whether the operation succeeded.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transfer(address recipient, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Returns the remaining number of tokens that `spender` will be
108      * allowed to spend on behalf of `owner` through {transferFrom}. This is
109      * zero by default.
110      *
111      * This value changes when {approve} or {transferFrom} are called.
112      */
113     function allowance(address owner, address spender) external view returns (uint256);
114 
115     /**
116      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * IMPORTANT: Beware that changing an allowance with this method brings the risk
121      * that someone may use both the old and the new allowance by unfortunate
122      * transaction ordering. One possible solution to mitigate this race
123      * condition is to first reduce the spender's allowance to 0 and set the
124      * desired value afterwards:
125      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address spender, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Moves `amount` tokens from `sender` to `recipient` using the
133      * allowance mechanism. `amount` is then deducted from the caller's
134      * allowance.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Emitted when `value` tokens are moved from one account (`from`) to
144      * another (`to`).
145      *
146      * Note that `value` may be zero.
147      */
148     event Transfer(address indexed from, address indexed to, uint256 value);
149 
150     /**
151      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
152      * a call to {approve}. `value` is the new allowance.
153      */
154     event Approval(address indexed owner, address indexed spender, uint256 value);
155 }
156 
157 // File: @openzeppelin/contracts-ethereum-package/contracts/math/SafeMath.sol
158 
159 pragma solidity ^0.6.0;
160 
161 /**
162  * @dev Wrappers over Solidity's arithmetic operations with added overflow
163  * checks.
164  *
165  * Arithmetic operations in Solidity wrap on overflow. This can easily result
166  * in bugs, because programmers usually assume that an overflow raises an
167  * error, which is the standard behavior in high level programming languages.
168  * `SafeMath` restores this intuition by reverting the transaction when an
169  * operation overflows.
170  *
171  * Using this library instead of the unchecked operations eliminates an entire
172  * class of bugs, so it's recommended to use it always.
173  */
174 library SafeMath {
175     /**
176      * @dev Returns the addition of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `+` operator.
180      *
181      * Requirements:
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      * - Subtraction cannot overflow.
199      */
200     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
201         return sub(a, b, "SafeMath: subtraction overflow");
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      * - Subtraction cannot overflow.
212      */
213     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b <= a, errorMessage);
215         uint256 c = a - b;
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the multiplication of two unsigned integers, reverting on
222      * overflow.
223      *
224      * Counterpart to Solidity's `*` operator.
225      *
226      * Requirements:
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
231         // benefit is lost if 'b' is also tested.
232         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
233         if (a == 0) {
234             return 0;
235         }
236 
237         uint256 c = a * b;
238         require(c / a == b, "SafeMath: multiplication overflow");
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the integer division of two unsigned integers. Reverts on
245      * division by zero. The result is rounded towards zero.
246      *
247      * Counterpart to Solidity's `/` operator. Note: this function uses a
248      * `revert` opcode (which leaves remaining gas untouched) while Solidity
249      * uses an invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      * - The divisor cannot be zero.
253      */
254     function div(uint256 a, uint256 b) internal pure returns (uint256) {
255         return div(a, b, "SafeMath: division by zero");
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * Counterpart to Solidity's `/` operator. Note: this function uses a
263      * `revert` opcode (which leaves remaining gas untouched) while Solidity
264      * uses an invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      * - The divisor cannot be zero.
268      */
269     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         // Solidity only automatically asserts when dividing by 0
271         require(b > 0, errorMessage);
272         uint256 c = a / b;
273         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * Reverts when dividing by zero.
281      *
282      * Counterpart to Solidity's `%` operator. This function uses a `revert`
283      * opcode (which leaves remaining gas untouched) while Solidity uses an
284      * invalid opcode to revert (consuming all remaining gas).
285      *
286      * Requirements:
287      * - The divisor cannot be zero.
288      */
289     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
290         return mod(a, b, "SafeMath: modulo by zero");
291     }
292 
293     /**
294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
295      * Reverts with custom message when dividing by zero.
296      *
297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
298      * opcode (which leaves remaining gas untouched) while Solidity uses an
299      * invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      * - The divisor cannot be zero.
303      */
304     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
305         require(b != 0, errorMessage);
306         return a % b;
307     }
308 }
309 
310 // File: contracts/v612/DELTA/Periphery/DELTA_Limited_Staking_Window.sol
311 
312 pragma experimental ABIEncoderV2;
313 
314 
315 
316 
317 
318 interface IWETH {
319     function deposit() external payable;
320     function transfer(address to, uint value) external returns (bool);
321     function withdraw(uint) external;
322     function balanceOf(address) external returns (uint256);
323 }
324 
325 interface IRLP {
326   function rebase() external;
327   function wrap() external;
328   function setBaseLPToken(address) external;
329   function openRebasing() external;
330   function balanceOf(address) external returns (uint256);
331   function transfer(address, uint256) external returns (bool);
332 }
333 
334 interface IDELTA_DEEP_FARMING_VAULT {
335     function depositFor(address, uint256,uint256) external;
336 }
337 
338 interface IRESERVE_VAULT {
339     function setRatio(uint256) external;
340 }
341 
342 contract DELTA_Limited_Staking_Window {
343   using SafeMath for uint256;
344   
345   struct LiquidityContribution {
346     address byWho;
347     uint256 howMuchETHUnits;
348     uint256 contributionTimestamp;
349     uint256 creditsAdded;
350   }
351 
352 
353   //////////
354   // STORAGE
355   //////////
356 
357   ///////////
358   // Unchanging variables and constants 
359   /// @dev All this variables should be set only once. Anything else is a bug.
360 
361   // Constants
362   address constant internal UNISWAP_FACTORY = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
363   address public DELTA_FINANCIAL_MULTISIG;
364   /// @notice the person who sets the multisig wallet, happens only once
365   // This person has no power over the contract only power to set the multisig wallet
366   address immutable public INTERIM_ADMIN;
367   IWETH constant public wETH = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
368   address public reserveVaultAddress;
369   address public deltaDeepFarmingVaultAddress;
370   uint256 public LSW_RUN_TIME = 10 days;
371   uint256 public constant MAX_ETH_POOL_SEED = 1500 ether;
372 
373   // @notice periode after the LSW is ended to claim the LP and the bonuses
374   uint256 public constant CLAIMING_PERIOD = 30 days;
375   uint256 public constant MAX_TIME_BONUS_PERCENT = 30;
376 
377   IRLP public rebasingLP; // Wrapped LP
378   address public deltaTokenAddress;
379 
380   ///////////
381 
382   ///////////
383   // Referral handling variables
384   /// @dev Variables handling referral bonuses and IDs calculations
385 
386   /// @dev Sequential referral IDs (skipping 0)
387   uint256 public totalReferralIDs; 
388   /// @dev mappings and reverse mapping handling the referral id ( for links to be smaller)
389   mapping(uint256 => address) public referralCodeMappingIndexedByID; 
390   mapping(address => uint256) public referralCodeMappingIndexedByAddress;
391   /// @dev we store bonus WETH in this variable because we don't want to send it until LSW is over... Because of the possibility of refund
392   mapping(address => uint256) public referralBonusWETH;
393   /// @dev boolean flag if the user already claimed his WETH bonus
394   mapping(address => bool) public referralBonusWETHClaimed;
395   uint256 public totalWETHEarmarkedForReferrers;
396 
397   ///////////
398 
399 
400   ///////////
401   // Liquidity contribution variables
402   /// @dev variables for storing liquidity contributions and subsequent calculation for LP distribution
403 
404   /// @dev An array of all contributions with metadata
405   LiquidityContribution [] public liquidityContributionsArray;
406   /// @dev This is ETH contributed by the specific person, it doesn't include any bonuses this is used to handle refunds
407   mapping(address => uint256) public liquidityContributedInETHUnitsMapping;  
408   /// @notice Each person has a credit based on their referrals and other bonuses as well as ETH contributions. This is what is used for owed LP
409   mapping(address => uint256) public liquidityCreditsMapping;
410   /// @dev a boolean flag for an address to signify they have already claimed LP owed to them
411   mapping(address => bool) public claimedLP;
412   /// @notice Calculated at the time of liquidity addition. RLP per each credit
413   /// @dev stored multiplied by 1e12 for change
414   uint256 public rlpPerCredit;
415   /// @dev total Credit inside the smart contract used for ending calculation for rlpPerCredit
416   uint256 public totalCreditValue;
417   ///////////
418 
419 
420   ///////////
421   // Refund handling variables
422 
423   /// @notice Variables used for potential refund if the liquidity addition fails. This failover happens 2 days after LSW is supposed to be over, and its is not.
424   /// @dev mapping of boolean flags if the user already claimed his refund
425   mapping(address => bool) public refundClaimed;
426   /// @notice boolean flag that can be initiated if LSW didnt end 2 days after it was supposed to calling the refund function.
427   /// @dev This opens refunds, refunds do not adjust anything except the above mapping. Its important this variable is never triggered
428   bool public refundsOpen;
429   ///////////
430 
431   ///////////
432   // Handling LSW timing variables
433 
434   /// @dev variables for length of LSW, separate from constant ones above
435   bool public liquidityGenerationHasStarted;
436   bool public liquidityGenerationHasEnded;
437   /// @dev timestamps are not dynamic and generated upon calling the start function
438   uint256 public liquidityGenerationStartTimestamp;
439   uint256 public liquidityGenerationEndTimestamp;
440   ///////////
441 
442 
443 
444   // constructor is only called by the token contract
445   constructor() public {
446       INTERIM_ADMIN = msg.sender;
447   }
448 
449 
450   /// @dev fallback on eth sent to the contract ( note WETH doesn't send ETH to this contract so no carveout is needed )
451   receive() external payable {
452     revertBecauseUserDidNotProvideAgreement();
453   }
454 
455   function setMultisig(address multisig) public {
456       onlyInterimAdmin();
457     
458       require(DELTA_FINANCIAL_MULTISIG == address(0), "only set once");
459       DELTA_FINANCIAL_MULTISIG = multisig;
460   }
461 
462   function onlyInterimAdmin() public view {
463       require(INTERIM_ADMIN == msg.sender, "wrong");
464   }
465 
466   function setReserveVault(address reserveVault) public {
467       onlyMultisig();
468       reserveVaultAddress = reserveVault;
469   }
470 
471   /// Helper functions
472   function setRLPWrap(address rlpAddress) public {
473       onlyMultisig();
474       rebasingLP = IRLP(rlpAddress);
475   }
476 
477   function setDELTAToken(address deltaToken, bool delegateCall) public {
478       onlyMultisig();
479       if(delegateCall == false) {
480         deltaTokenAddress = deltaToken;
481       } else {
482           bytes memory callData = abi.encodePacked(bytes4(keccak256(bytes("getTokenInfo()"))), "");
483         (,bytes memory addressDelta)= deltaToken.delegatecall(callData);
484         deltaTokenAddress = abi.decode(addressDelta, (address));
485       }
486   }
487 
488   function setFarmingVaultAddress(address farmingVault) public {
489       onlyMultisig();
490       deltaDeepFarmingVaultAddress = farmingVault;
491       require(address(rebasingLP) != address(0), "Need rlp to be set");
492       require(farmingVault != address(0), "Provide an address for farmingVault");
493       IERC20(address(rebasingLP)).approve(farmingVault, uint(-1));
494   }
495   
496   function extendLSWEndTime(uint256 numberSeconds) public {
497       onlyMultisig();
498       liquidityGenerationEndTimestamp = liquidityGenerationEndTimestamp.add(numberSeconds);
499       LSW_RUN_TIME = LSW_RUN_TIME.add(numberSeconds);
500   }
501 
502 
503 
504   /// @notice This function starts the LSW and opens deposits and creates the RLP wrap
505   function startLiquidityGeneration() public {
506     onlyMultisig();
507 
508     // We check that this is called by the correct authorithy
509     /// @dev deltaToken has a time countdown in it that will make this function avaible to call 
510     require(liquidityGenerationHasStarted == false, "startLiquidityGeneration() called when LSW had already started");
511 
512     // We start the LSW
513     liquidityGenerationHasStarted = true;
514     // Informational timestamp only written here
515     // All calculations are based on the variable below end timestamp and run time which is used to bonus calculations
516     liquidityGenerationStartTimestamp = block.timestamp;
517     liquidityGenerationEndTimestamp = liquidityGenerationStartTimestamp + LSW_RUN_TIME;
518 
519   }
520  
521   /// @notice publically callable function that assigns a sequential shortened referral ID so a long one doesnt need to be provided in the URL
522   function makeRefCode() public returns (uint256) {
523     // If that address already has one, we dont make a new one
524     if(referralCodeMappingIndexedByAddress[msg.sender] != 0){
525        return referralCodeMappingIndexedByAddress[msg.sender];
526      }
527      else {
528        return _makeRefCode(msg.sender);
529      }
530   }
531 
532   /// @dev Assigns a unique index to referrers, starting at 1
533   function _makeRefCode(address referrer) internal returns (uint256) {
534       totalReferralIDs++; // lead to skip 0 code for the LSW 
535       // Populate reverse as well for lookup above
536       referralCodeMappingIndexedByID[totalReferralIDs] = referrer;
537       referralCodeMappingIndexedByAddress[msg.sender] = totalReferralIDs;
538       return totalReferralIDs;
539   }
540 
541   /// @dev Not using modifiers is a purposeful choice for code readability.
542   function revertBecauseUserDidNotProvideAgreement() internal pure {
543     revert("No agreement provided, please review the smart contract before interacting with it");
544   }
545 
546 
547   function adminEndLSWAndRefundEveryone() public {
548     onlyMultisig();
549     liquidityGenerationEndTimestamp = 0;
550     openRefunds();
551   }
552 
553   function onlyMultisig() public view {
554     require(msg.sender == DELTA_FINANCIAL_MULTISIG, "FBI OPEN UP");
555   }
556 
557 
558   /// @notice a publically callable function that ends the LSW, adds liquidity and splits RLP for each credit.
559   function endLiquidityDeployment() public {
560     // Check if it already ended
561     require(block.timestamp > liquidityGenerationEndTimestamp.add(5 minutes), "LSW Not over yet."); // Added few blocks here
562     // Check if it was already run
563     require(liquidityGenerationHasEnded == false, "LSW Already ended");
564     require(refundsOpen == false, "Refunds Opened, no ending");
565 
566     // Check if all variable addresses are set
567     // This includes the delta token
568     // Rebasing lp wrap
569     // Reserve vault which acts as options plunge insurance and floor price reserve 
570     // And operating capital for loans
571     // And the farming vault which is used to auto stake in it
572     require(deltaTokenAddress != address(0), "Delta Token is not set");
573     require(address(rebasingLP) != address(0), "Rlp is not set");
574     require(address(reserveVaultAddress) != address(0), "Reserve Vault is not set");
575     require(address(deltaDeepFarmingVaultAddress) != address(0), "Deep farming vault isn't set");
576 
577     // We wrap the delta token in the interface
578     IERC20 deltaToken = IERC20(deltaTokenAddress);
579     // Check the balance we have
580     // Note : if the process wan't complete correctly, the balance here would be wrong
581     // Because DELTA token returns a balanace 
582     uint256 balanceOfDELTA = deltaToken.balanceOf(address(this)); 
583     // We make sure we for sure have the total supply
584     require(balanceOfDELTA == deltaToken.totalSupply(), "Did not get the whole supply of deltaToken");
585     /// We mkake sure the supply is equal to the agreed on 45mln
586     require(balanceOfDELTA == 45_000_000e18, "Did not get the whole supply of deltaToken");
587 
588     // Optimistically get pair
589     address deltaWethUniswapPair = IUniswapV2Factory(UNISWAP_FACTORY).getPair(deltaTokenAddress, address(wETH));
590     if(deltaWethUniswapPair == address(0)) { // Pair doesn't exist yet 
591       // create pair returns address
592       deltaWethUniswapPair = IUniswapV2Factory(UNISWAP_FACTORY).createPair(
593         deltaTokenAddress,
594         address(wETH)
595       );
596     }
597 
598     // Split between DELTA financial and pool
599     // intented outcome 50% split between pool and further fund for tokens and WETH
600     uint256 balanceWETHPreSplit = wETH.balanceOf(address(this));
601     require(balanceWETHPreSplit > 0, "Not enough WETH");
602     wETH.transfer(DELTA_FINANCIAL_MULTISIG, balanceWETHPreSplit.div(2)); // send half
603     uint256 balanceWETHPostSplit = wETH.balanceOf(address(this)); // requery
604     // We remove the WETH we had earmarked for referals
605     uint256 balanceWETHPostReferal = balanceWETHPostSplit.sub(totalWETHEarmarkedForReferrers);
606 
607     /// @dev note this will revert if there is less than 1500 eth at this stage
608     /// We just want refunds if that's the case cause it's not worth bothering
609     uint256 balanceWETHForReserves = balanceWETHPostReferal.sub(MAX_ETH_POOL_SEED, "Not enough ETH");
610 
611     /// @dev we check that bonuses are less than 5% of total deposited because they should be at max 5
612     /// Anything else is a issue
613     /// Note added 1ETH for possible change
614     require(totalWETHEarmarkedForReferrers <= balanceWETHPreSplit.div(20).add(1e18), "Sanity check failure 3");
615     wETH.transfer(reserveVaultAddress, balanceWETHForReserves);
616     // We seed the pool with WETH
617     wETH.transfer(deltaWethUniswapPair, MAX_ETH_POOL_SEED);
618     require(wETH.balanceOf(address(this)) == totalWETHEarmarkedForReferrers, "Math Error");
619 
620     // Transfer DELTA
621     /// @dev this address is already mature as in it has 100% of DELTA in its balance 
622     uint256 deltaForPoolAndReserve = balanceOfDELTA.div(2);
623     /// Smaller number / bigger number = float  with 1000 for precision
624     uint256 percentOfBalanceToReserves = MAX_ETH_POOL_SEED.mul(1000).div(balanceWETHPostReferal);
625     // We take the precision out here
626     uint256 delfaForPool = deltaForPoolAndReserve.mul(percentOfBalanceToReserves).div(1000);
627 
628     // transfer to pool
629     deltaToken.transfer(deltaWethUniswapPair, delfaForPool);
630     // We check if we are not sending 10% by mistake not whitelisting this address for whole sends
631     // Note we don't check the rest because it should not deviate 
632     require(deltaToken.balanceOf(deltaWethUniswapPair) == delfaForPool, "LSW did not get permissions to send directly to balance");
633     // Transfer to team vesting
634     deltaToken.transfer(DELTA_FINANCIAL_MULTISIG, balanceOfDELTA.div(2));
635     // transfer to floor/liqudation insurance reserves
636     deltaToken.transfer(reserveVaultAddress, deltaToken.balanceOf(address(this))); // queried again in case of rounding problems
637     
638     /// This ratio is set as how much 1 whole eth buys
639     /// Since eth is 1e18 and delta is same we can do this here
640     /// Note that we don't expect 45mln eth so we dont really lose precision (delta supply is 45mln)
641     IRESERVE_VAULT(reserveVaultAddress).setRatio(
642         delfaForPool.div(MAX_ETH_POOL_SEED)
643     );
644 
645     // just wrapping in the interface
646     IUniswapV2Pair newPair = IUniswapV2Pair(deltaWethUniswapPair);
647     // Add liquidity
648     newPair.mint(address(this)); //transfer LP here
649     // WE approve the rlp to spend because thats what the wrap function uses (transferFor)
650     newPair.approve(address(rebasingLP), uint(-1));
651 
652     // We set the base token in a whitelist for rLP for LSW
653     rebasingLP.setBaseLPToken(address(newPair));
654 
655     /// @dev outside call, this function is supposed to wrap all LP of this address and issue rebasibngLP and send it to this address
656     /// This switch is 1:1 1LP for 1 rebasingLP
657     rebasingLP.wrap();
658 
659     // Rebase liquidity 
660     /// @notice First rebase rebases RLP 3x. This means this would hit the gas limit if it was made in this call. 
661     /// So it just triggers a boolean flag to rebase and then trading is opened.
662     /// @dev itended side effect of this is flipping a boolean flag inside the rebasingLP contract. It will open the rebasing function to be called about 30 times
663     /// Until its called that amount of times trading or transfering of DELTA token will not be opened. 
664     /// This is done so price of RLP will be 3x that it was minted at instantly. Also will generate about 30bln in volume
665     rebasingLP.openRebasing();
666     // Split LP per Credit
667     uint256 totalRLP = rebasingLP.balanceOf(address(this));
668     require(totalRLP > 0, "Sanity check failure 1");
669     // We store as 1e12 more for change
670     rlpPerCredit = totalRLP.mul(1e12).div(totalCreditValue);
671     require(rlpPerCredit > 0, "Sanity check failure 2");
672 
673     // Finalize to open claims (claimLP and ETH claiming for referal)
674     liquidityGenerationHasEnded = true;
675   }
676 
677   function claimOrStakeAndClaimLP(bool claimToWalletInstead) public {
678     // Make sure the LSW ended ( this is set in fn endLiquidityDeployment() only)
679     // And is only set when all checks have passed and we good
680     require(liquidityGenerationHasEnded, "Liquidity Generation isn't over");
681 
682     // Make sure the claiming period isn't over
683     // Note that we hav ea claiming period here so rLP doesnt get stuck or ETH doesnt get stuck in thsi contract
684     // This is because of the referal system having wrong addresses in it possibly
685     require(block.timestamp < liquidityGenerationEndTimestamp.add(CLAIMING_PERIOD), "Claiming period is over");
686   
687     // Make sure the person has something to claim
688     require(liquidityContributedInETHUnitsMapping[msg.sender] > 0, "You have nothing to claim.");
689     // Make sure the person hasnt already claimed
690     require(claimedLP[msg.sender] == false, "You have already claimed.");
691     // Set the already claimed flag
692     claimedLP[msg.sender] = true;
693 
694     // We calculate the amount of rebasing LP due
695     uint256 rlpDue = liquidityCreditsMapping[msg.sender].mul(rlpPerCredit).div(1e12);
696     // And send it out
697     // We check if the person wants to claim to the wallet, the default is to stake it for him in the vault
698     if(claimToWalletInstead) {
699         rebasingLP.transfer(msg.sender, rlpDue);
700     }
701     else {
702         IDELTA_DEEP_FARMING_VAULT(deltaDeepFarmingVaultAddress).depositFor(msg.sender,rlpDue,0);
703     }
704   }
705 
706 
707 
708   /// @dev we loop over all liquidity contributions of a person and return them here for front end display
709   /// Note this might suffer from gas limits on infura if there are enogh deposits and we are aware of that
710   /// Its just a nice helper function that is not nessesary
711   function allLiquidityContributionsOfAnAddress(address person) public view returns (LiquidityContribution  [] memory liquidityContributionsOfPerson) {
712 
713     uint256 j; // Index of the memory array
714 
715     /// @dev we grab liquidity contributions at current index and compare to the provided address, and if it matches we push it to the array
716     for(uint256 i = 0; i < liquidityContributionsArray.length; i++) {
717       LiquidityContribution memory currentContribution = liquidityContributionsArray[i];
718       if(currentContribution.byWho == person) {
719         liquidityContributionsOfPerson[j] = currentContribution;
720         j++;
721       }
722     }
723   }
724 
725 
726   /// @notice Sends the bonus WETH to the referer after LSW is over.
727   function getWETHBonusForReferrals() public {
728     require(liquidityGenerationHasEnded == true, "LSW Not ended");
729 
730     // Make sure the claiming period isn't over
731     // This is done in case ETH is stuck with malformed addresses
732     require(block.timestamp < liquidityGenerationEndTimestamp.add(CLAIMING_PERIOD), "Claiming period is over");
733     require(referralBonusWETHClaimed[msg.sender] == false, "Already claimed, check wETH balance not ETH");
734     require(referralBonusWETH[msg.sender] > 0, "nothing to claim");
735     /// @dev flag as claimed so no other calls is possible to this
736     /// Note that even if reentry was possible here we set it first before sending out weth
737     referralBonusWETHClaimed[msg.sender] = true;
738     /// @dev wETH transfer( token ) has no hook possibility
739     wETH.transfer(msg.sender, referralBonusWETH[msg.sender]); 
740   }
741 
742   /// @notice Transfer any remaining tokens in the contract
743   /// This is done after the claiming period is over in case there are malformed not claimed referal amounts 
744   function finalizeLSW(address _token) public {
745     onlyMultisig();
746 
747     require(liquidityGenerationHasEnded == true, "LSW Not ended");
748     require(block.timestamp >= liquidityGenerationEndTimestamp.add(CLAIMING_PERIOD), "Claiming period is not over");
749     
750     IERC20 token = IERC20(_token);
751 
752     /// @dev Transfer remaining tokens to the team. Those are tokens that has been
753     /// unclaimed or transferred to the contract.
754     token.transfer(DELTA_FINANCIAL_MULTISIG, token.balanceOf(address(this)));
755   }
756 
757   /// @notice this function allows anyone to refund the eth deposited in case the contract cannot finish
758   /// This is a nessesary function because of the contrract not having admin controls
759   /// And is only here as a safety pillow failure
760   function getRefund() public {
761     require(refundsOpen, "Refunds are not open");
762     require(refundClaimed[msg.sender]  == false, "Already got a refund, check your wETH balance.");
763     refundClaimed[msg.sender] = true;
764 
765     // We send wETH9 here so there is no callback
766     wETH.transfer(msg.sender, liquidityContributedInETHUnitsMapping[msg.sender]);
767   }
768 
769   // This function opens refunds,  if LSW didnt finish 2 days after it was supposed to. This means something went wrong.
770   function openRefunds() public {
771 
772     require(liquidityGenerationHasEnded == false, "Liquidity generation has ended"); // We correctly ended the LSW
773     require(liquidityGenerationHasStarted == true, "Liquidity generation has not started");
774     // Liquidity genertion should had ended 2 days ago!
775     require(block.timestamp > liquidityGenerationEndTimestamp.add(2 days), "Post LSW grace period isn't over");
776     /// This can be set over and over again with no issue here
777     refundsOpen = true;
778 
779   }
780 
781 
782   /// @dev Returns bonus in credit units, and adds and calculates credit for the referrer
783   /// @return credit units (something like wETH but in credit) this is for the referee ( person who was refered)
784   function handleReferredDepositWithAddress(address referrerAddress) internal returns (uint256) {
785 
786     if(referrerAddress == msg.sender)  { return 0; } //We dont let self referrals and bail here without any bonuses.
787 
788     require(msg.value > 0, "Sanity check failure");
789     uint256 wETHBonus = msg.value.div(20); // 5%
790     uint256 creditBonus = wETHBonus; // Samesies
791     totalWETHEarmarkedForReferrers = totalWETHEarmarkedForReferrers.add(wETHBonus);
792     require(wETHBonus > 0 && creditBonus > 0 , "Sanity check failure 2");
793 
794     // We give 5% wETH of the deposit to the person
795     referralBonusWETH[referrerAddress] = referralBonusWETH[referrerAddress].add(wETHBonus);
796 
797     //We add credit
798     liquidityCreditsMapping[referrerAddress] = liquidityCreditsMapping[referrerAddress].add(creditBonus);
799     // Update total credits
800     totalCreditValue = totalCreditValue.add(creditBonus);
801     
802     // We return 10% bonus for the person who was refered
803     return creditBonus.mul(2);
804   }
805 
806   /// @dev checks if a address for this referral ID exists, if it doesnt just returns 0 skipping the adding function
807   function handleReferredDepositWithReferralID(uint256 referralID) internal returns (uint256 personWhoGotReferedBonus) {
808     address referrerAddress = referralCodeMappingIndexedByID[referralID];
809     // We check if the referral number was registered, and if its not the same person.
810     if(referrerAddress != address(0) && referrerAddress != msg.sender) {
811       return handleReferredDepositWithAddress(referrerAddress);
812     } else {
813       return 0;
814     }
815   }
816 
817   function secondsLeftInLiquidityGenerationEvent() public view returns ( uint256 ) {
818 
819     if(block.timestamp >= liquidityGenerationEndTimestamp) { return 0; }
820     return liquidityGenerationEndTimestamp - block.timestamp;
821 
822   }
823 
824   function liquidityGenerationParticipationAgreement() public pure returns (string memory) {
825     return "I understand that I'm interacting with a smart contract. I understand that liquidity im providing is locked forever. I reviewed code of the smart contract and understand it fully. I agree to not hold developers or other people associated with the project to liable for any losses of misunderstandings";
826   }
827 
828   // referrerAddress or referralID must be provided, the unused parameter should be left as 0
829   function contributeLiquidity(bool readAndAgreedToLiquidityProviderAgreement, address referrerAddress, uint256 referralID) public payable {
830     require(refundsOpen == false, "Refunds Opened, no deposit");
831     // We check that LSW has already started
832     require(liquidityGenerationHasStarted, "Liquidity generation did not start");
833     // We check if liquidity generation didn't end
834     require(liquidityGenerationHasEnded == false, "Liquidity generation has ended");
835     // We check if liquidity genration still has time in it
836     require(secondsLeftInLiquidityGenerationEvent() > 0, "Liquidity generation has ended 2");
837     // We check if user agreed with the terms of the smart contract
838     if(readAndAgreedToLiquidityProviderAgreement == false) {
839       revertBecauseUserDidNotProvideAgreement();
840     }
841     require(msg.value > 0, "Ethereum needs to be provided");
842 
843     // We add credit bonus, which is 10% if user is referred
844     // RefID takes precedence here
845     uint256 creditBonus;
846     if(referralID != 0) {
847       creditBonus = handleReferredDepositWithReferralID(referralID); // TO REVIEW: handleReferredDepositWithReferralID returns the reward (referrer and referee)
848     } else if (referrerAddress != address(0)){
849       creditBonus = handleReferredDepositWithAddress(referrerAddress); // TO REVIEW: handleReferredDepositWithReferralID returns the reward (referrer and referee)
850     } // Else bonus is 0
851 
852     // We add the time bonus to the credit 
853     creditBonus = creditBonus.add(calculateCreditBonusBasedOnCurrentTime(msg.value));
854 
855     // Credit bonus should never be bigger than credit here. Max 30% + 10%. Aka 40% of msg.value
856     // Note this is a magic number here, since we dont really want to read the max bonus again from storage
857     require(msg.value.mul(41).div(100) > creditBonus, "Sanity check failure");
858 
859     // We update the global number of credit so we can distribute LP later
860     uint256 creditValue = msg.value.add(creditBonus);
861     totalCreditValue = totalCreditValue.add(creditValue);
862 
863     // Give the person credit and the bonus
864     liquidityCreditsMapping[msg.sender] = liquidityCreditsMapping[msg.sender].add(creditValue);
865     // Save the persons deposit for refunds in case
866     liquidityContributedInETHUnitsMapping[msg.sender] = liquidityContributedInETHUnitsMapping[msg.sender].add(msg.value);
867 
868     // We add it to array of all deposits
869     liquidityContributionsArray.push(LiquidityContribution({
870       byWho : msg.sender,
871       howMuchETHUnits : msg.value,
872       contributionTimestamp : block.timestamp,
873       creditsAdded : creditValue // Stores the deposit + the bonus
874     }));
875 
876     // We turn ETH into WETH9
877     wETH.deposit{value : msg.value}();
878   }
879 
880   /// @dev intended return is the bonus credit in terms of ETH units
881   // At the start of LSW is 30%, ramping down to 0% in the last 12 hours of LSW.
882   function calculateCreditBonusBasedOnCurrentTime(uint256 depositValue) internal view returns (uint256) {
883     uint256 secondsLeft = secondsLeftInLiquidityGenerationEvent();
884     uint256 totalSeconds = LSW_RUN_TIME;
885 
886     // We get percent left in the LSW
887     uint256 percentLeft = secondsLeft.mul(100).div(totalSeconds); // 24 hours before LSW end, we get 7 for percentLeft - highest value for this possible is 100 (by a bot)
888 
889     // We calculate bonus based on percent left. Eg 100% of the time remaining, means a 30% bonus. 50% of the time remaining, means a 15% bonus.
890     // MAX_TIME_BONUS_PERCENT is a constant set to 30 (double-check on review)
891     // Max example with 1 ETH contribute: 30 * 100 * 1eth / 10000 = 0.3eth
892     // Low end (towards the end of LSW) > 0 example MAX_TIME_BONUS_PERCENT == 7;
893       // 30 * 7 * 1eth / 10000 = 0.021 eth
894     // Min example MAX_TIME_BONUS_PERCENT == 0; returns 0
895     /// 100 % bonus
896     /// 30*100*1e18/10000 == 0.3 * 1e18
897     /// Dust numbers
898     /// 30*100*1/10000 == 0
899     uint256 bonus = MAX_TIME_BONUS_PERCENT.mul(percentLeft).mul(depositValue).div(10000);
900     require(depositValue.mul(31).div(100) > bonus , "Sanity check failure bonus");
901     return bonus;
902   }
903 
904 }