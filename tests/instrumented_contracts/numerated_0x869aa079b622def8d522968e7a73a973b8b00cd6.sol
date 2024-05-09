1 pragma solidity 0.6.12;
2 
3 library SafeMath {
4   /**
5    * @dev Returns the addition of two unsigned integers, reverting on
6    * overflow.
7    *
8    * Counterpart to Solidity's `+` operator.
9    *
10    * Requirements:
11    * - Addition cannot overflow.
12    */
13   function add(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a + b;
15     require(c >= a, "SafeMath: addition overflow");
16 
17     return c;
18   }
19 
20   /**
21    * @dev Returns the subtraction of two unsigned integers, reverting on
22    * overflow (when the result is negative).
23    *
24    * Counterpart to Solidity's `-` operator.
25    *
26    * Requirements:
27    * - Subtraction cannot overflow.
28    */
29   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30     return sub(a, b, "SafeMath: subtraction overflow");
31   }
32 
33   /**
34    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
35    * overflow (when the result is negative).
36    *
37    * Counterpart to Solidity's `-` operator.
38    *
39    * Requirements:
40    * - Subtraction cannot overflow.
41    */
42   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43     require(b <= a, errorMessage);
44     uint256 c = a - b;
45 
46     return c;
47   }
48 
49   /**
50    * @dev Returns the multiplication of two unsigned integers, reverting on
51    * overflow.
52    *
53    * Counterpart to Solidity's `*` operator.
54    *
55    * Requirements:
56    * - Multiplication cannot overflow.
57    */
58   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
60     // benefit is lost if 'b' is also tested.
61     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
62     if (a == 0) {
63       return 0;
64     }
65 
66     uint256 c = a * b;
67     require(c / a == b, "SafeMath: multiplication overflow");
68 
69     return c;
70   }
71 
72   /**
73    * @dev Returns the integer division of two unsigned integers. Reverts on
74    * division by zero. The result is rounded towards zero.
75    *
76    * Counterpart to Solidity's `/` operator. Note: this function uses a
77    * `revert` opcode (which leaves remaining gas untouched) while Solidity
78    * uses an invalid opcode to revert (consuming all remaining gas).
79    *
80    * Requirements:
81    * - The divisor cannot be zero.
82    */
83   function div(uint256 a, uint256 b) internal pure returns (uint256) {
84     return div(a, b, "SafeMath: division by zero");
85   }
86 
87   /**
88    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
89    * division by zero. The result is rounded towards zero.
90    *
91    * Counterpart to Solidity's `/` operator. Note: this function uses a
92    * `revert` opcode (which leaves remaining gas untouched) while Solidity
93    * uses an invalid opcode to revert (consuming all remaining gas).
94    *
95    * Requirements:
96    * - The divisor cannot be zero.
97    */
98   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99     require(b > 0, errorMessage);
100     uint256 c = a / b;
101     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
102 
103     return c;
104   }
105 
106   /**
107    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
108    * Reverts when dividing by zero.
109    *
110    * Counterpart to Solidity's `%` operator. This function uses a `revert`
111    * opcode (which leaves remaining gas untouched) while Solidity uses an
112    * invalid opcode to revert (consuming all remaining gas).
113    *
114    * Requirements:
115    * - The divisor cannot be zero.
116    */
117   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
118     return mod(a, b, "SafeMath: modulo by zero");
119   }
120 
121   /**
122    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
123    * Reverts with custom message when dividing by zero.
124    *
125    * Counterpart to Solidity's `%` operator. This function uses a `revert`
126    * opcode (which leaves remaining gas untouched) while Solidity uses an
127    * invalid opcode to revert (consuming all remaining gas).
128    *
129    * Requirements:
130    * - The divisor cannot be zero.
131    */
132   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133     require(b != 0, errorMessage);
134     return a % b;
135   }
136 }
137 
138 interface IERC20 {
139   /**
140    * @dev Returns the amount of tokens in existence.
141    */
142   function totalSupply() external view returns (uint256);
143 
144   /**
145    * @dev Returns the amount of tokens owned by `account`.
146    */
147   function balanceOf(address account) external view returns (uint256);
148 
149   /**
150    * @dev Moves `amount` tokens from the caller's account to `recipient`.
151    *
152    * Returns a boolean value indicating whether the operation succeeded.
153    *
154    * Emits a {Transfer} event.
155    */
156   function transfer(address recipient, uint256 amount) external returns (bool);
157 
158   /**
159    * @dev Returns the remaining number of tokens that `spender` will be
160    * allowed to spend on behalf of `owner` through {transferFrom}. This is
161    * zero by default.
162    *
163    * This value changes when {approve} or {transferFrom} are called.
164    */
165   function allowance(address owner, address spender) external view returns (uint256);
166 
167   /**
168    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
169    *
170    * Returns a boolean value indicating whether the operation succeeded.
171    *
172    * IMPORTANT: Beware that changing an allowance with this method brings the risk
173    * that someone may use both the old and the new allowance by unfortunate
174    * transaction ordering. One possible solution to mitigate this race
175    * condition is to first reduce the spender's allowance to 0 and set the
176    * desired value afterwards:
177    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
178    *
179    * Emits an {Approval} event.
180    */
181   function approve(address spender, uint256 amount) external returns (bool);
182 
183   /**
184    * @dev Moves `amount` tokens from `sender` to `recipient` using the
185    * allowance mechanism. `amount` is then deducted from the caller's
186    * allowance.
187    *
188    * Returns a boolean value indicating whether the operation succeeded.
189    *
190    * Emits a {Transfer} event.
191    */
192   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
193 
194   /**
195    * @dev Emitted when `value` tokens are moved from one account (`from`) to
196    * another (`to`).
197    *
198    * Note that `value` may be zero.
199    */
200   event Transfer(address indexed from, address indexed to, uint256 value);
201 
202   /**
203    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
204    * a call to {approve}. `value` is the new allowance.
205    */
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 
208 }
209 
210 
211 interface StakingContract {
212     function getStaker(address _staker) external view virtual returns (uint256, uint256, bool);
213 }
214 
215 interface Calculator {
216     function calculateTokensOwed(address account) external view virtual returns (uint256);
217 }
218 interface Administrator {
219     function resetStakeTimeDebug(address account, uint lastTimestamp, uint startTimestamp, bool migrated) external virtual;
220     function swapExactETHForTokensAddLiquidity(address[] calldata path, uint liquidityETH, uint swapETH)
221       external
222       payable
223       returns (uint liquidity);
224 }
225 
226 interface UniswapV2Router{
227     function addLiquidityETH(
228       address token,
229       uint amountTokenDesired,
230       uint amountTokenMin,
231       uint amountETHMin,
232       address to,
233       uint deadline
234     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
235     
236     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
237       external
238       payable
239       returns (uint[] memory amounts);
240       
241      function WETH() external pure returns (address);
242 
243 }
244 
245 // PAMP Time is a derivative token of time staked in the Pamp Network staking ecosystem
246 // It can be redeemed for 1 day staked per token, and also has non-inflationary staking/farming mechanics
247 contract PAMPTime is IERC20 {
248     using SafeMath for uint256;
249 
250     mapping (address => uint256) private _balances;
251 
252     mapping (address => mapping (address => uint256)) private _allowances;
253 
254     uint256 private _totalSupply;
255     uint256 public maxSupply;
256     uint public stakedTotalSupply;
257 
258     string private _name;
259     string private _symbol;
260     uint8 private _decimals;
261     
262     uint public numLeftSale;
263     
264     uint public rate;
265     
266     bool public saleEnabled;
267     
268     uint public maxSecondsPerAddress;
269     
270     uint public minStakeDurationDays;
271     
272     address payable public owner;
273     
274     bool public freeze;
275     
276     bool public enableBurns;
277     
278     bool public claimsEnabled;
279     
280     bool public redemptionsEnabled;
281     
282     uint public burnPercent;       // 1 decimal place; 20 = 2.0
283     
284     uint public cycleDaysStaked;
285     
286     bool public stakingEnabled;
287     
288     uint public rewardsPool;
289     
290     IERC20 public pampToken;
291     
292     IERC20 public uniswapPair;
293     
294     StakingContract public stakingContract;
295     
296     Administrator public admin;
297     
298     UniswapV2Router public router;
299     
300     Calculator public calculator;
301     
302     bool public useCalc;
303     
304     mapping (address => bool) public uniswapPairs;
305     
306     mapping (address => string) public whitelist;
307     
308     mapping (address => Claim) public claims;
309     
310     mapping (address => uint) public secondsRedeemed;
311     
312     mapping (address => Staker) public stakers;
313     
314     address[] path;
315     
316     struct Staker {
317         uint poolTokenBalance;
318         uint startTimestamp;
319     }
320     
321     struct Claim {
322         bool claimed50;
323         bool claimed100;
324         bool claimed200;
325     }
326     
327     modifier onlyOwner() {
328         assert(msg.sender == owner);
329         _;
330     }
331 
332     /**
333      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
334      * a default value of 18.
335      *
336      * To select a different value for {decimals}, use {_setupDecimals}.
337      *
338      * All three of these values are immutable: they can only be set once during
339      * construction.
340      */
341     constructor () public {
342         owner = msg.sender;
343         _name = "Pamp Time";
344         _symbol = "PTIME";
345         _decimals = 18;
346         maxSupply = 10000E18;
347         burnPercent = 20;
348         rate = 75000000000000000;
349         numLeftSale = 4000E18;
350         minStakeDurationDays = 2;
351         freeze = true;
352         enableBurns = true;
353         claimsEnabled = false;
354         redemptionsEnabled = false;
355         stakingEnabled = false;
356         maxSecondsPerAddress = 4320000; // 50 days
357         _mint(msg.sender, 1000E18);
358         whitelist[owner] = "Owner";
359 
360         router = UniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
361         pampToken = IERC20(0xF0FAC7104aAC544e4a7CE1A55ADF2B5a25c65bD1);
362         stakingContract = StakingContract(0x738d3CEC4E685A2546Ab6C3B055fd6B8C1198093);
363         admin = Administrator(0x0Ee85192B3ba619ADa35462e7fa9f511a44C3736);
364         path.push(router.WETH());
365         path.push(address(this));
366         whitelist[address(router)] = "UniswapV2Router";
367         whitelist[address(this)] = "Token contract";
368         whitelist[address(admin)] = "Administrator";
369         cycleDaysStaked = 30;
370     }
371     
372     function claimPTIME() external { // Claim TIME tokens based on days staked on PAMP
373         (uint tokens, uint daysStaked) = calculateClaimableTokens(msg.sender);  // Calculate how many you can claim
374         require(tokens > 0, "You have no tokens to claim");
375         require(_totalSupply.add(tokens) <= maxSupply, "Max supply reached");       // There is a maximum supply
376         require(claimsEnabled);
377         if(daysStaked > 50 && daysStaked < 100) {
378             claims[msg.sender].claimed50 = true;            // We only allow 3 claims for the life of an account so we store the claims in claims[] array
379         } else if(daysStaked >= 100 && daysStaked < 200) {
380             claims[msg.sender].claimed100 = true;
381         } else if(daysStaked >= 200) {
382             claims[msg.sender].claimed200 = true;
383         }
384         
385         _mint(msg.sender, tokens); 
386     }
387     
388     function calculateClaimableTokens(address pampStaker) public view returns (uint256, uint256) {
389         (uint startTimestamp, uint lastTimestamp, bool hasMigrated) = stakingContract.getStaker(pampStaker); // Get staker information from staking contract
390         if(!hasMigrated || startTimestamp == 0) {
391             return (0,0);
392         }
393         uint daysStaked = block.timestamp.sub(startTimestamp) / 86400;  // Calculate time staked in days
394         uint balance = pampToken.balanceOf(pampStaker);
395         Claim memory claim = claims[pampStaker];
396         
397         if(daysStaked > 50 && daysStaked < 100 && balance >= 1000E18 && !claim.claimed50) {     //Self-explanatory; we're just checking days staked and balance and returning the amount to be claimed
398             if(balance < 5000E18) {
399                 return (1E18, daysStaked);
400             } else if (balance >= 5000E18 && balance < 10000E18) {
401                 return (3E18, daysStaked);
402             } else if (balance >= 10000E18) {
403                 return (5E18, daysStaked);
404             }
405         } else if(daysStaked >= 100 && daysStaked < 200 && balance >= 1000E18 && !claim.claimed100) {
406             if(balance < 5000E18) {
407                 return (2E18, daysStaked);
408             } else if (balance >= 5000E18 && balance < 10000E18) {
409                 return (6E18, daysStaked);
410             } else if (balance >= 10000E18) {
411                 return (10E18, daysStaked);
412             }
413         } else if(daysStaked >= 200 && balance >= 1000E18 && !claim.claimed200) {
414             if(balance < 5000E18) {
415                 return (2E18, daysStaked);
416             } else if (balance >= 5000E18 && balance < 10000E18) {
417                 return (6E18, daysStaked);
418             } else if (balance >= 10000E18) {
419                 return (10E18, daysStaked);
420             }
421         }
422         return (0, 0);      // else, no tokens can be claimed
423     }
424     
425     function redeemPTIME(uint tokens) external {    // Redeem (burn) TIME tokens for extra days staked in PAMP staking
426         require(tokens > 0);
427         require(redemptionsEnabled);
428         _burn(msg.sender, tokens);
429         (uint startTimestamp, uint lastTimestamp, bool hasMigrated) = stakingContract.getStaker(msg.sender);        // get staker info
430         require(startTimestamp != 0 && hasMigrated);
431         uint secondsAdded = mulDiv(86400, tokens, 1E18);                                        // We calculate the seconds to be subtracted from the staker's timestamp
432         secondsRedeemed[msg.sender] = secondsRedeemed[msg.sender].add(secondsAdded);            // There is a max number of seconds that can be redeemd for the lifetime of an address (50 days)
433         require(secondsRedeemed[msg.sender] <= maxSecondsPerAddress, "You have used more than the max of 50 days");
434         admin.resetStakeTimeDebug(msg.sender, lastTimestamp, startTimestamp.sub(secondsAdded), hasMigrated);        // Proxy contract calls this function on the staking contract
435     }
436     
437     
438     
439     function stakeLiquidityTokens(uint256 numPoolTokensToStake) external {
440         require(numPoolTokensToStake > 0);
441         require(stakingEnabled, "Staking is currently disabled.");
442         
443         uniswapPair.transferFrom(msg.sender, address(this), numPoolTokensToStake);      // Transfer liquidity tokens from the sender to this contract
444         
445         Staker storage thisStaker = stakers[msg.sender];                                // Get the sender's information
446         
447         if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {
448             thisStaker.startTimestamp = block.timestamp;
449         } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
450             uint percent = mulDiv(1000000, numPoolTokensToStake, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the number of pool tokens to stake as a fraction of the token balance
451             if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
452                thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
453             } else {
454                 thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
455             }
456         }
457         
458         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(numPoolTokensToStake);
459         
460     }
461     
462     function withdrawLiquidityTokens(uint256 numPoolTokensToWithdraw) external {
463         
464         require(numPoolTokensToWithdraw > 0);
465         
466         Staker storage thisStaker = stakers[msg.sender];
467         
468         require(thisStaker.poolTokenBalance >= numPoolTokensToWithdraw, "Pool token balance too low");
469         
470         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
471         
472         require(daysStaked >= minStakeDurationDays);
473         
474         uint tokensOwed = calculateTokensOwed(msg.sender);      // We give all of the rewards owed to the sender on a withdrawal, regardless of the amount withdrawn
475         
476         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.sub(numPoolTokensToWithdraw);
477         
478         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
479         
480         _balances[msg.sender] = _balances[msg.sender].add(tokensOwed);      // Could also do this with _transfer, but the balance of address(this) is zero
481         rewardsPool = rewardsPool.sub(tokensOwed);                          // We keep track of the rewards pool and remove tokens sent (instead of using _balances[address(this)])
482         emit Transfer(address(this), msg.sender, tokensOwed);               // However removing tokens from the pool decreases everyone else's rewards, which might create a misaligned incentive (TBD)
483         
484         uniswapPair.transfer(msg.sender, numPoolTokensToWithdraw);          // Give staker back their UNI-V2
485     }
486     
487     function withdrawRewards() external {   // Same as above, but we don't remove their poolTokenBalance (UNI-V2)
488         
489         Staker storage thisStaker = stakers[msg.sender];
490         
491         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
492         
493         require(daysStaked >= minStakeDurationDays);
494         
495         uint tokensOwed = calculateTokensOwed(msg.sender);
496         
497         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
498         _balances[msg.sender] = _balances[msg.sender].add(tokensOwed);
499         rewardsPool = rewardsPool.sub(tokensOwed);
500         emit Transfer(address(this), msg.sender, tokensOwed);
501     }
502     
503     // If you call this function you forfeit your rewards
504     function emergencyWithdrawLiquidityTokens() external {
505         Staker storage thisStaker = stakers[msg.sender];
506         uint poolTokenBalance = thisStaker.poolTokenBalance;
507         thisStaker.poolTokenBalance = 0;
508         thisStaker.startTimestamp = block.timestamp;
509         uniswapPair.transfer(msg.sender, poolTokenBalance);
510     }
511     
512     
513    
514     function addToRewardsPool(address sender, uint tokens) internal {   // This is like a burn but goes to the staker rewards pool instead
515         _balances[sender] = _balances[sender].sub(tokens);
516         rewardsPool = rewardsPool.add(tokens);
517         emit Transfer(sender, address(this), tokens);
518     }
519     
520     function AddToRewardsPool(uint tokens) external { // This will likely not be used unless we (or somebody) want to donate to staking
521         addToRewardsPool(msg.sender, tokens);
522     }
523     
524         
525     function buyPTIME(address beneficiary) public payable {     // Used for presale
526         require(saleEnabled, "Sale is disabled");
527         require(msg.value <= 50E18 && msg.value >= rate);       // Max contribution is 50 ETH (but obviousy somebody can call this function multiple times or from multiple addresses; sybil resistance is not really important)
528         uint tokens = mulDiv(1E18, msg.value, rate);            // Basically just divide the contribution by the rate and you get your tokens
529         numLeftSale = numLeftSale.sub(tokens);
530         _mint(beneficiary, tokens);
531     }
532     
533     function endSale() external onlyOwner {         // When the sale is over we add half the ETH and sold tokens to Uniswap
534         require(saleEnabled);
535         saleEnabled = false;
536         //freeze = false;
537         uint liquidityPTIME = (4000E18 - numLeftSale) / 2;      // However many were sold, divide it by 2, mint them and and add them to Uniswap
538         uint devShare = address(this).balance / 2;
539         uint liquidityETH = address(this).balance.sub(devShare);        // Half the ETH goes to Uniswap
540         owner.transfer(devShare);                                       // Half goes to us for development and marketing
541         _approve(address(this), address(router), 100000000000E18);      // Approve the router to spend our tokens
542         _mint(address(this), liquidityPTIME);
543         (uint amountToken, uint amountETH, uint liquidity) = router.addLiquidityETH{value: liquidityETH}(address(this), liquidityPTIME, 0, 0, address(this), block.timestamp.add(86400));
544         stakers[address(this)].poolTokenBalance = liquidity;            // Our liquidity is staking
545         stakers[address(this)].startTimestamp = block.timestamp;
546     }
547     
548     function AddEthLiquidity() external payable { // This function allows you to add liquidity and begin staking without needing any tokens (just ETH)
549         require(stakingEnabled, "Staking is disabled"); 
550         require(msg.value > 0);
551         uint swapETH = msg.value / 2; // ETH used for swap (buying tokens)
552         uint liquidityETH = msg.value.sub(swapETH); // ETH used for liquidity addition (along with bought tokens)
553         _approve(address(admin), address(router), 100000000000E18);
554         uint liquidity = admin.swapExactETHForTokensAddLiquidity{value: msg.value}(path, liquidityETH, swapETH);        // We use another contract for the swap and add because Uniswap won't let us use the token contract address in the 'to' field of the swap function
555         
556         Staker storage thisStaker = stakers[msg.sender];
557          if(thisStaker.startTimestamp == 0 || thisStaker.poolTokenBalance == 0) {       // Staker begins staking immediately
558             thisStaker.startTimestamp = block.timestamp;
559         } else {                                                                        // If the sender is currently staking, adding to his balance results in a holding time penalty
560             uint percent = mulDiv(1000000, liquidity, thisStaker.poolTokenBalance);      // This is not really 'percent' it is just a number that represents the totalAmount as a fraction of the recipientBalance
561             if(percent.add(thisStaker.startTimestamp) > block.timestamp) {         // We represent the 'percent' or 'penalty' as seconds and add to the recipient's unix time
562                thisStaker.startTimestamp = block.timestamp; // Receiving too many tokens resets your holding time
563             } else {
564                 thisStaker.startTimestamp = thisStaker.startTimestamp.add(percent);               
565             }
566         }
567         
568         thisStaker.poolTokenBalance = thisStaker.poolTokenBalance.add(liquidity);   
569     }
570     
571     function claimContractRewards(address beneficiary) external onlyOwner {         // Claim rewards on behalf of the contract and have them sent to a beneficiary (team wallet)
572         Staker storage thisStaker = stakers[address(this)];
573         
574         uint daysStaked = block.timestamp.sub(thisStaker.startTimestamp) / 86400;  // Calculate time staked in days
575         
576         uint tokensOwed = calculateTokensOwed(address(this));
577         
578         thisStaker.startTimestamp = block.timestamp; // Reset staking timer on withdrawal
579         _balances[beneficiary] = _balances[beneficiary].add(tokensOwed);
580         rewardsPool = rewardsPool.sub(tokensOwed);
581         emit Transfer(address(this), beneficiary, tokensOwed);
582     }
583 
584     /**
585      * @dev Returns the name of the token.
586      */
587     function name() public view returns (string memory) {
588         return _name;
589     }
590 
591     /**
592      * @dev Returns the symbol of the token, usually a shorter version of the
593      * name.
594      */
595     function symbol() public view returns (string memory) {
596         return _symbol;
597     }
598 
599     /**
600      * @dev Returns the number of decimals used to get its user representation.
601      * For example, if `decimals` equals `2`, a balance of `505` tokens should
602      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
603      *
604      * Tokens usually opt for a value of 18, imitating the relationship between
605      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
606      * called.
607      *
608      * NOTE: This information is only used for _display_ purposes: it in
609      * no way affects any of the arithmetic of the contract, including
610      * {IERC20-balanceOf} and {IERC20-transfer}.
611      */
612     function decimals() public view returns (uint8) {
613         return _decimals;
614     }
615 
616     /**
617      * @dev See {IERC20-totalSupply}.
618      */
619     function totalSupply() public view override returns (uint256) {
620         return _totalSupply;
621     }
622 
623     /**
624      * @dev See {IERC20-balanceOf}.
625      */
626     function balanceOf(address account) public view override returns (uint256) {
627         return _balances[account];
628     }
629     
630     function getStaker(address _staker) external view returns (uint, uint, uint, uint) {
631         return (stakers[_staker].startTimestamp, 0, stakers[_staker].poolTokenBalance, 0); // We use 0 to comply with the interface of the other liquidity staking contracts
632     }
633     
634     function calculateTokensOwed(address account) public view returns (uint256) {
635         if(useCalc) {
636             return calculator.calculateTokensOwed(account);
637         }
638         Staker memory staker = stakers[msg.sender];
639         uint daysStaked = block.timestamp.sub(staker.startTimestamp) / 86400;
640         if(staker.startTimestamp == 0 || daysStaked == 0) {
641             return 0;
642         }
643         uint factor = mulDiv(daysStaked*1E18, rewardsPool, cycleDaysStaked*1E18);        // If 100% of the staking pool is staked for the full cycle and claims, we get 100% of the rewards pool returned.
644         return mulDiv(factor, staker.poolTokenBalance, uniswapPair.totalSupply());  // The formula takes into account your percent share of the Uniswap pool and your days staked. You will get the same amount per day, in theory (but in practice the size of the pool is constantly changing)
645     }
646 
647 
648     /**
649      * @dev See {IERC20-transfer}.
650      *
651      * Requirements:
652      *
653      * - `recipient` cannot be the zero address.
654      * - the caller must have a balance of at least `amount`.
655      */
656     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
657         _transfer(msg.sender, recipient, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-allowance}.
663      */
664     function allowance(address owner, address spender) public view virtual override returns (uint256) {
665         return _allowances[owner][spender];
666     }
667 
668     /**
669      * @dev See {IERC20-approve}.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      */
675     function approve(address spender, uint256 amount) public virtual override returns (bool) {
676         _approve(msg.sender, spender, amount);
677         return true;
678     }
679 
680     /**
681      * @dev See {IERC20-transferFrom}.
682      *
683      * Emits an {Approval} event indicating the updated allowance. This is not
684      * required by the EIP. See the note at the beginning of {ERC20}.
685      *
686      * Requirements:
687      *
688      * - `sender` and `recipient` cannot be the zero address.
689      * - `sender` must have a balance of at least `amount`.
690      * - the caller must have allowance for ``sender``'s tokens of at least
691      * `amount`.
692      */
693     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
694         _transfer(sender, recipient, amount);
695         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
696         return true;
697     }
698 
699     /**
700      * @dev Atomically increases the allowance granted to `spender` by the caller.
701      *
702      * This is an alternative to {approve} that can be used as a mitigation for
703      * problems described in {IERC20-approve}.
704      *
705      * Emits an {Approval} event indicating the updated allowance.
706      *
707      * Requirements:
708      *
709      * - `spender` cannot be the zero address.
710      */
711     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
712         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
713         return true;
714     }
715 
716     /**
717      * @dev Atomically decreases the allowance granted to `spender` by the caller.
718      *
719      * This is an alternative to {approve} that can be used as a mitigation for
720      * problems described in {IERC20-approve}.
721      *
722      * Emits an {Approval} event indicating the updated allowance.
723      *
724      * Requirements:
725      *
726      * - `spender` cannot be the zero address.
727      * - `spender` must have allowance for the caller of at least
728      * `subtractedValue`.
729      */
730     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
731         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
732         return true;
733     }
734 
735     /**
736      * @dev Moves tokens `amount` from `sender` to `recipient`.
737      *
738      * This is internal function is equivalent to {transfer}, and can be used to
739      * e.g. implement automatic token fees, slashing mechanisms, etc.
740      *
741      * Emits a {Transfer} event.
742      *
743      * Requirements:
744      *
745      * - `sender` cannot be the zero address.
746      * - `recipient` cannot be the zero address.
747      * - `sender` must have a balance of at least `amount`.
748      */
749     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
750         require(sender != address(0), "ERC20: transfer from the zero address");
751         require(recipient != address(0), "ERC20: transfer to the zero address");
752         require(sender == owner || sender == address(this) || !freeze, "Contract is frozen");
753         
754         uint totalAmount = amount;
755         
756         
757         if (enableBurns && bytes(whitelist[sender]).length == 0 && bytes(whitelist[recipient]).length == 0) {
758             // Sender and recipient are not in the whitelist
759             uint burnedAmount = mulDiv(amount, burnPercent/2, 1000); // Amount to be burned. Divide by 2 because half is burned and the other half goes to staking rewards pool
760             
761             if (burnedAmount > 0) {
762                 if (burnedAmount > amount) {
763                     totalAmount = 0;
764                 } else {
765                     totalAmount = amount.sub(burnedAmount);
766                 }
767                 _burn(sender, burnedAmount);  // Remove the burned amount from the sender's balance
768                 addToRewardsPool(sender, burnedAmount);
769             }
770         } else if (enableBurns && uniswapPairs[recipient] == true && sender != address(admin)) {    // Uniswap was used. This is a special case. Uniswap is burn on receive but whitelist on send, so sellers pay fee and buyers do not.
771                 uint burnedAmount = mulDiv(amount, burnPercent/2, 1000);     // Seller fee
772                 if (burnedAmount > 0) {
773                     if (burnedAmount > amount) {
774                         totalAmount = 0;
775                     } else {
776                         totalAmount = amount.sub(burnedAmount);
777                     }
778                     _burn(sender, burnedAmount);
779                     addToRewardsPool(sender, burnedAmount);
780                 }
781         }
782         
783 
784         _balances[sender] = _balances[sender].sub(totalAmount, "ERC20: transfer amount exceeds balance");
785         _balances[recipient] = _balances[recipient].add(totalAmount);
786         emit Transfer(sender, recipient, amount);
787     }
788 
789     /**
790      * @dev Destroys `amount` tokens from `account`, reducing the
791      * total supply.
792      *
793      * Emits a {Transfer} event with `to` set to the zero address.
794      *
795      * Requirements:
796      *
797      * - `account` cannot be the zero address.
798      * - `account` must have at least `amount` tokens.
799      */
800     function _burn(address account, uint256 amount) internal virtual {
801         require(account != address(0), "ERC20: burn from the zero address");
802 
803         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
804         _totalSupply = _totalSupply.sub(amount);
805         emit Transfer(account, address(0), amount);
806     }
807     
808     function _mint(address account, uint256 amount) internal virtual {
809         require(account != address(0), "ERC20: mint to the zero address");
810 
811         _totalSupply = _totalSupply.add(amount);
812         _balances[account] = _balances[account].add(amount);
813         emit Transfer(address(0), account, amount);
814     }
815 
816     /**
817      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
818      *
819      * This internal function is equivalent to `approve`, and can be used to
820      * e.g. set automatic allowances for certain subsystems, etc.
821      *
822      * Emits an {Approval} event.
823      *
824      * Requirements:
825      *
826      * - `owner` cannot be the zero address.
827      * - `spender` cannot be the zero address.
828      */
829     function _approve(address owner, address spender, uint256 amount) internal virtual {
830         require(owner != address(0), "ERC20: approve from the zero address");
831         require(spender != address(0), "ERC20: approve to the zero address");
832 
833         _allowances[owner][spender] = amount;
834         emit Approval(owner, spender, amount);
835     }
836     
837     function updateWhitelist(address addr, string calldata reason, bool remove) external onlyOwner {
838         if (remove) {
839             delete whitelist[addr];
840         } else {
841             whitelist[addr] = reason;
842         }
843     }
844     
845     function updateStakingContract(address _newContract) external onlyOwner {
846         stakingContract = StakingContract(_newContract);
847     }
848     
849     function updateAdministrator(address _admin) external onlyOwner {
850         admin = Administrator(_admin);
851         whitelist[_admin] = "Administrator";
852     }
853     
854     function updateToken(address _newToken) external onlyOwner {
855         pampToken = IERC20(_newToken);
856     }
857     
858     function transferOwnership(address payable _newOwner) external onlyOwner {
859         owner = _newOwner;
860     }
861     
862     function updateFreeze(bool _freeze) external onlyOwner {
863         freeze = _freeze;
864     }
865     
866     function updateRate(uint _rate) external onlyOwner {
867         rate = _rate;
868     }
869     
870     function updateSaleEnabled(bool _saleEnabled) external onlyOwner {
871         saleEnabled = _saleEnabled;
872     }
873     
874     function updateMaxSecondsPerAddress(uint max) external onlyOwner {
875         maxSecondsPerAddress = max;
876     }
877     
878     function updateStakingEnabled(bool _stakingEnabled) external onlyOwner {
879         stakingEnabled = _stakingEnabled;
880     }
881     
882     function updateEnableBurns(bool _burnsEnabled) external onlyOwner {
883         enableBurns = _burnsEnabled;
884     }
885     
886     function updateUniswapPair(address _pair) external onlyOwner {
887         uniswapPair = IERC20(_pair);
888         uniswapPairs[_pair] = true;
889         whitelist[_pair] = "UniswapPair";
890     }
891     
892     function updateUniswapPairs(address addr, bool remove) external onlyOwner {
893         if (remove) {
894             delete uniswapPairs[addr];
895         } else {
896             uniswapPairs[addr] = true;
897         }
898     }
899     
900     function updateClaimsEnabled(bool _enabled) external onlyOwner {
901         claimsEnabled = _enabled;
902     }
903     
904     function updateRedemptionsEnabled(bool _enabled) external onlyOwner {
905         redemptionsEnabled = _enabled;
906     }
907     
908     function updateCurrentCycleDays(uint _days) external onlyOwner {
909         cycleDaysStaked = _days;
910     }
911     
912     function updateRouter(address _router) external onlyOwner {
913         router = UniswapV2Router(_router);
914     }
915     
916     function updateCalculator(address calc) external onlyOwner {
917         if(calc == address(0)) {
918             useCalc = false;
919         } else {
920             calculator = Calculator(calc);
921             useCalc = true;
922         }
923     }
924     
925     
926      // This function was not written by us. It was taken from here: https://medium.com/coinmonks/math-in-solidity-part-3-percents-and-proportions-4db014e080b1
927     // Takes in three numbers and calculates x * (y/z)
928     // This is very useful for this contract as percentages are used constantly
929 
930     function mulDiv (uint x, uint y, uint z) public pure returns (uint) {
931           (uint l, uint h) = fullMul (x, y);
932           assert (h < z);
933           uint mm = mulmod (x, y, z);
934           if (mm > l) h -= 1;
935           l -= mm;
936           uint pow2 = z & -z;
937           z /= pow2;
938           l /= pow2;
939           l += h * ((-pow2) / pow2 + 1);
940           uint r = 1;
941           r *= 2 - z * r;
942           r *= 2 - z * r;
943           r *= 2 - z * r;
944           r *= 2 - z * r;
945           r *= 2 - z * r;
946           r *= 2 - z * r;
947           r *= 2 - z * r;
948           r *= 2 - z * r;
949           return l * r;
950     }
951     
952     function fullMul (uint x, uint y) private pure returns (uint l, uint h) {
953           uint mm = mulmod (x, y, uint (-1));
954           l = x * y;
955           h = mm - l;
956           if (mm < l) h -= 1;
957     }
958     
959     receive() external payable {
960         buyPTIME(msg.sender);
961     }
962     
963     fallback() external payable {
964         buyPTIME(msg.sender);
965     }
966     
967     function emergencyWithdrawETH() external onlyOwner {
968         owner.transfer(address(this).balance);
969     }
970     
971     
972 }