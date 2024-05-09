1 // File: contracts\GFarmTokenInterface.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.7.5;
5 
6 interface GFarmTokenInterface{
7 	function balanceOf(address account) external view returns (uint256);
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9     function transfer(address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function burn(address from, uint256 amount) external;
13     function mint(address to, uint256 amount) external;
14 }
15 
16 // File: @openzeppelin\contracts\math\SafeMath.sol
17 
18 pragma solidity ^0.7.0;
19 
20 /**
21  * @dev Wrappers over Solidity's arithmetic operations with added overflow
22  * checks.
23  *
24  * Arithmetic operations in Solidity wrap on overflow. This can easily result
25  * in bugs, because programmers usually assume that an overflow raises an
26  * error, which is the standard behavior in high level programming languages.
27  * `SafeMath` restores this intuition by reverting the transaction when an
28  * operation overflows.
29  *
30  * Using this library instead of the unchecked operations eliminates an entire
31  * class of bugs, so it's recommended to use it always.
32  */
33 library SafeMath {
34     /**
35      * @dev Returns the addition of two unsigned integers, reverting on
36      * overflow.
37      *
38      * Counterpart to Solidity's `+` operator.
39      *
40      * Requirements:
41      *
42      * - Addition cannot overflow.
43      */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47 
48         return c;
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      *
73      * - Subtraction cannot overflow.
74      */
75     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b <= a, errorMessage);
77         uint256 c = a - b;
78 
79         return c;
80     }
81 
82     /**
83      * @dev Returns the multiplication of two unsigned integers, reverting on
84      * overflow.
85      *
86      * Counterpart to Solidity's `*` operator.
87      *
88      * Requirements:
89      *
90      * - Multiplication cannot overflow.
91      */
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
94         // benefit is lost if 'b' is also tested.
95         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
96         if (a == 0) {
97             return 0;
98         }
99 
100         uint256 c = a * b;
101         require(c / a == b, "SafeMath: multiplication overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b) internal pure returns (uint256) {
119         return div(a, b, "SafeMath: division by zero");
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      *
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
135         require(b > 0, errorMessage);
136         uint256 c = a / b;
137         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         return mod(a, b, "SafeMath: modulo by zero");
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts with custom message when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b != 0, errorMessage);
172         return a % b;
173     }
174 }
175 
176 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Pair.sol
177 
178 pragma solidity >=0.5.0;
179 
180 interface IUniswapV2Pair {
181     event Approval(address indexed owner, address indexed spender, uint value);
182     event Transfer(address indexed from, address indexed to, uint value);
183 
184     function name() external pure returns (string memory);
185     function symbol() external pure returns (string memory);
186     function decimals() external pure returns (uint8);
187     function totalSupply() external view returns (uint);
188     function balanceOf(address owner) external view returns (uint);
189     function allowance(address owner, address spender) external view returns (uint);
190 
191     function approve(address spender, uint value) external returns (bool);
192     function transfer(address to, uint value) external returns (bool);
193     function transferFrom(address from, address to, uint value) external returns (bool);
194 
195     function DOMAIN_SEPARATOR() external view returns (bytes32);
196     function PERMIT_TYPEHASH() external pure returns (bytes32);
197     function nonces(address owner) external view returns (uint);
198 
199     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
200 
201     event Mint(address indexed sender, uint amount0, uint amount1);
202     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
203     event Swap(
204         address indexed sender,
205         uint amount0In,
206         uint amount1In,
207         uint amount0Out,
208         uint amount1Out,
209         address indexed to
210     );
211     event Sync(uint112 reserve0, uint112 reserve1);
212 
213     function MINIMUM_LIQUIDITY() external pure returns (uint);
214     function factory() external view returns (address);
215     function token0() external view returns (address);
216     function token1() external view returns (address);
217     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
218     function price0CumulativeLast() external view returns (uint);
219     function price1CumulativeLast() external view returns (uint);
220     function kLast() external view returns (uint);
221 
222     function mint(address to) external returns (uint liquidity);
223     function burn(address to) external returns (uint amount0, uint amount1);
224     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
225     function skim(address to) external;
226     function sync() external;
227 
228     function initialize(address, address) external;
229 }
230 
231 // File: contracts\GFarm.sol
232 
233 pragma solidity 0.7.5;
234 
235 
236 
237 
238 contract GFarm {
239 
240     using SafeMath for uint;
241 
242     // VARIABLES & CONSTANTS
243 
244     // 1. Tokens
245     GFarmTokenInterface public token;
246     IUniswapV2Pair public lp;
247     address public nft;
248 
249     // 2. Pool 1
250     uint public POOL1_MULTIPLIER; // 1e18
251     uint public POOL1_MULTIPLIER_UPDATED;
252     uint public constant POOL1_MULTIPLIER_UPDATE_EVERY = 45000; // 1 week (blocks)
253     uint public POOL1_lastRewardBlock;
254     uint public POOL1_accTokensPerLP; // 1e18
255     uint public constant POOL1_REFERRAL_P = 6; // % 2 == 0
256     uint public constant POOL1_CREDITS_MIN_P = 1;
257 
258     // 3. Pool 2
259     uint public immutable POOL2_MULTIPLIER; // 1e18
260     uint public constant POOL2_DURATION = 32000; // 5 days
261     uint public immutable POOL2_END;
262     uint public POOL2_lastRewardBlock;
263     uint public POOL2_accTokensPerETH; // 1e18
264 
265     // 4. Pool 1 & Pool 2
266     uint public immutable POOLS_START;
267     uint public constant POOLS_START_DELAY = 1775;
268     uint public constant PRECISION = 1e5;
269 
270     // 5. Useful Uniswap addresses (for TVL & APY)
271     address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
272     IUniswapV2Pair constant ETH_USDC_PAIR = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
273 
274     // 6. Governance & dev fund
275     address public GOVERNANCE;
276     address public immutable DEV_FUND;
277     uint constant GOVERNANCE_P = 500000; // PRECISION
278     uint constant DEV_FUND_P = 500000; // PRECISION
279 
280     // 7. Info about each user
281     struct User {
282         uint POOL1_provided;
283         uint POOL1_rewardDebt;
284         address POOL1_referral;
285         uint POOL1_referralReward;
286 
287         uint POOL2_provided;
288         uint POOL2_rewardDebt;
289 
290         uint NFT_CREDITS_amount;
291         uint NFT_CREDITS_lastUpdated;
292         bool NFT_CREDITS_receiving;
293     }
294     mapping(address => User) public users;
295 
296     constructor(address _GOV, address _DEV){
297         // Distribution = 7500 * (3/4)^(n-1) (n = week)
298         POOL1_MULTIPLIER = uint(7500 * 1e18) / 45000;
299         POOL1_MULTIPLIER_UPDATED = block.number.add(POOLS_START_DELAY);
300 
301         POOL2_MULTIPLIER = POOL1_MULTIPLIER.div(10);
302         POOL2_END = block.number.add(POOLS_START_DELAY)
303                     .add(POOL2_DURATION);
304 
305         POOLS_START = block.number.add(POOLS_START_DELAY);
306 
307         GOVERNANCE = _GOV;
308         DEV_FUND = _DEV;
309     }
310 
311     // GOVERNANCE
312 
313     // 0. Modifier
314     modifier onlyGov(){
315         require(msg.sender == GOVERNANCE);
316         _;
317     }
318 
319     // 1. Update governance address
320     function set_GOVERNANCE(address _gov) external onlyGov{
321         GOVERNANCE = _gov;
322     }
323 
324     // 2. Set token address
325     function set_TOKEN(address _token) external onlyGov{
326         require(token == GFarmTokenInterface(0), "Token address already set");
327         token = GFarmTokenInterface(_token);
328     }
329 
330     // 3. Set lp address
331     function set_LP(address _lp) external onlyGov{
332         require(lp == IUniswapV2Pair(0), "LP address already set");
333         lp = IUniswapV2Pair(_lp);
334     }
335 
336     // 4. Set token address
337     function set_NFT(address _nft) external onlyGov{
338         require(nft == address(0), "NFT address already set");
339         nft = _nft;
340     }
341 
342     // POOL REWARDS BETWEEN 2 BLOCKS
343 
344     // 1. Pool 1 (1e18)
345     function POOL1_getReward(uint _from, uint _to) private view returns (uint){
346         uint blocks;
347 
348         if(_from >= POOLS_START && _to >= POOLS_START){
349             blocks = _to.sub(_from);
350         }
351 
352         return blocks.mul(POOL1_MULTIPLIER);
353     }
354 
355     // 2. Pool 2 (1e18)
356     function POOL2_getReward(uint _from, uint _to) private view returns (uint){
357         uint blocks;
358 
359         if(_from >= POOLS_START && _to >= POOLS_START){
360             // Before pool 2 has ended
361             if(_from <= POOL2_END && _to <= POOL2_END){
362                 blocks = _to.sub(_from);
363             // Between before and after pool 2 has ended
364             }else if(_from <= POOL2_END && _to > POOL2_END){
365                 blocks = POOL2_END.sub(_from);
366             // After pool 2 has ended
367             }else if(_from > POOL2_END && _to > POOL2_END){
368                 blocks = 0;
369             }
370         }
371 
372         return blocks.mul(POOL2_MULTIPLIER);
373     }
374 
375     // UPDATE POOL VARIABLES
376 
377     // 1. Pool 1
378     function POOL1_update() private {
379         uint lpSupply = lp.balanceOf(address(this));
380 
381         if (POOL1_lastRewardBlock == 0 || lpSupply == 0) {
382             POOL1_lastRewardBlock = block.number;
383             return;
384         }
385 
386         uint reward = POOL1_getReward(POOL1_lastRewardBlock, block.number);
387         
388         token.mint(address(this), reward);
389         token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION));
390         token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION));
391 
392         POOL1_accTokensPerLP = POOL1_accTokensPerLP.add(
393             reward.mul(1e18).div(lpSupply)
394         );
395         POOL1_lastRewardBlock = block.number;
396 
397         if(block.number >= POOL1_MULTIPLIER_UPDATED.add(POOL1_MULTIPLIER_UPDATE_EVERY)){
398             POOL1_MULTIPLIER = POOL1_MULTIPLIER.mul(3).div(4);
399             POOL1_MULTIPLIER_UPDATED = block.number;
400         }
401     }   
402 
403     // 2. Pool 2
404     function POOL2_update(uint ethJustStaked) private {
405         // ETH balance is updated before the rest of the code
406         uint ethSupply = address(this).balance.sub(ethJustStaked);
407 
408         if (POOL2_lastRewardBlock == 0 || ethSupply == 0) {
409             POOL2_lastRewardBlock = block.number;
410             return;
411         }
412 
413         uint reward = POOL2_getReward(POOL2_lastRewardBlock, block.number);
414         
415         token.mint(address(this), reward);
416         token.mint(GOVERNANCE, reward.mul(GOVERNANCE_P).div(100*PRECISION));
417         token.mint(DEV_FUND, reward.mul(DEV_FUND_P).div(100*PRECISION));
418 
419         POOL2_accTokensPerETH = POOL2_accTokensPerETH.add(reward.mul(1e18).div(ethSupply));
420         POOL2_lastRewardBlock = block.number;
421     }
422 
423     // PENDING REWARD
424 
425     // 1. Pool 1 external (1e18)
426     function POOL1_pendingReward() external view returns(uint){
427         return _POOL1_pendingReward(users[msg.sender]);
428     }
429 
430     // 2. Pool 1 private (1e18)
431     function _POOL1_pendingReward(User memory u) private view returns(uint){
432         uint _POOL1_accTokensPerLP = POOL1_accTokensPerLP;
433         uint lpSupply = lp.balanceOf(address(this));
434 
435         if (block.number > POOL1_lastRewardBlock && lpSupply != 0) {
436             uint pendingReward = POOL1_getReward(POOL1_lastRewardBlock, block.number);
437             _POOL1_accTokensPerLP = _POOL1_accTokensPerLP.add(
438                 pendingReward.mul(1e18).div(lpSupply)
439             );
440         }
441 
442         return u.POOL1_provided.mul(_POOL1_accTokensPerLP).div(1e18)
443                 .sub(u.POOL1_rewardDebt);
444     }
445 
446     // 3. Pool 2 external (1e18)
447     function POOL2_pendingReward() external view returns(uint){
448         return _POOL2_pendingReward(users[msg.sender], 0);
449     }
450     
451     // 4. Pool 2 private (1e18)
452     function _POOL2_pendingReward(User memory u, uint ethJustStaked) private view returns(uint){
453         uint _POOL2_accTokensPerETH = POOL2_accTokensPerETH;
454         // ETH balance is updated before the rest of the code
455         uint ethSupply = address(this).balance.sub(ethJustStaked);
456 
457         if (block.number > POOL2_lastRewardBlock && ethSupply != 0) {
458             uint pendingReward = POOL2_getReward(POOL2_lastRewardBlock, block.number);
459             _POOL2_accTokensPerETH = _POOL2_accTokensPerETH.add(
460                 pendingReward.mul(1e18).div(ethSupply)
461             );
462         }
463 
464         return u.POOL2_provided.mul(_POOL2_accTokensPerETH).div(1e18)
465             .sub(u.POOL2_rewardDebt);
466     }
467 
468     // HARVEST REWARDS
469 
470     // 1. Pool 1 external
471     function POOL1_harvest() external{
472         require(block.number >= POOLS_START, "Pool hasn't started yet.");
473         _POOL1_harvest(msg.sender);
474     }
475 
476     // 2. Pool 1 private
477     function _POOL1_harvest(address a) private{
478         User storage u = users[a];
479         uint pending = _POOL1_pendingReward(u);
480         POOL1_update();
481 
482         if(pending > 0){
483             if(u.POOL1_referral == address(0)){
484                 POOLS_safeTokenTransfer(a, pending);
485                 token.burn(a, pending.mul(POOL1_REFERRAL_P).div(100));
486             }else{
487                 uint referralReward = pending.mul(POOL1_REFERRAL_P.div(2)).div(100);
488                 uint userReward = pending.sub(referralReward);
489 
490                 POOLS_safeTokenTransfer(a, userReward);
491                 POOLS_safeTokenTransfer(u.POOL1_referral, referralReward);
492 
493                 User storage referralUser = users[u.POOL1_referral];
494                 referralUser.POOL1_referralReward = referralUser.POOL1_referralReward
495                                                     .add(referralReward);
496             }
497         }
498 
499         u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
500     }
501 
502     // 3. Pool 2 external
503     function POOL2_harvest() external{
504         require(block.number >= POOLS_START, "Pool hasn't started yet.");
505         _POOL2_harvest(msg.sender, 0);
506     }
507     
508     // 4. Pool 2 private
509     function _POOL2_harvest(address a, uint ethJustStaked) private{
510         User storage u = users[a];
511         uint pending = _POOL2_pendingReward(u, ethJustStaked);
512         POOL2_update(ethJustStaked);
513 
514         if(pending > 0){
515             POOLS_safeTokenTransfer(a, pending);
516         }
517 
518         u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
519     }
520 
521     // STAKE
522 
523     // 1. Pool 1
524     function POOL1_stake(uint amount, address referral) external{
525         require(tx.origin == msg.sender, "Contracts not allowed.");
526         require(block.number >= POOLS_START, "Pool hasn't started yet.");
527         require(amount > 0, "Staking 0 lp.");
528 
529         uint lpSupplyBefore = lp.balanceOf(address(this));
530 
531         _POOL1_harvest(msg.sender);
532         lp.transferFrom(msg.sender, address(this), amount);
533 
534         User storage u = users[msg.sender];
535         u.POOL1_provided = u.POOL1_provided.add(amount);
536         u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
537 
538         if(!u.NFT_CREDITS_receiving
539             && u.POOL1_provided >= lpSupplyBefore.mul(POOL1_CREDITS_MIN_P).div(100)){
540             u.NFT_CREDITS_receiving = true;
541             u.NFT_CREDITS_lastUpdated = block.number;
542         }
543 
544         if(u.POOL1_referral == address(0) && referral != address(0)
545             && referral != msg.sender){
546             u.POOL1_referral = referral;
547         }
548     }
549 
550     // 2. Pool 2
551     function POOL2_stake() payable external{
552         require(tx.origin == msg.sender, "Contracts not allowed.");
553         require(block.number >= POOLS_START, "Pool hasn't started yet.");
554         require(block.number <= POOL2_END, "Pool is finished, no more staking.");
555         require(msg.value > 0, "Staking 0 ETH.");
556 
557         _POOL2_harvest(msg.sender, msg.value);
558 
559         User storage u = users[msg.sender];
560         u.POOL2_provided = u.POOL2_provided.add(msg.value);
561         u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
562     }
563 
564     // UNSTAKE
565 
566     // 1. Pool 1
567     function POOL1_unstake(uint amount) external{
568         User storage u = users[msg.sender];
569         require(amount > 0, "Unstaking 0 lp.");
570         require(u.POOL1_provided >= amount, "Unstaking more than currently staked.");
571 
572         _POOL1_harvest(msg.sender);
573         lp.transfer(msg.sender, amount);
574 
575         u.POOL1_provided = u.POOL1_provided.sub(amount);
576         u.POOL1_rewardDebt = u.POOL1_provided.mul(POOL1_accTokensPerLP).div(1e18);
577 
578         uint lpSupply = lp.balanceOf(address(this));
579 
580         if(u.NFT_CREDITS_receiving
581             && u.POOL1_provided < lpSupply.mul(POOL1_CREDITS_MIN_P).div(100)
582             || u.NFT_CREDITS_receiving && lpSupply == 0){
583             u.NFT_CREDITS_amount = NFT_CREDITS_amount(msg.sender);
584             u.NFT_CREDITS_receiving = false;
585             u.NFT_CREDITS_lastUpdated = block.number;
586         }
587     }
588 
589     // 2. Pool 2
590     function POOL2_unstake(uint amount) external{
591         User storage u = users[msg.sender];
592         require(amount > 0, "Unstaking 0 ETH.");
593         require(u.POOL2_provided >= amount, "Unstaking more than currently staked.");
594 
595         _POOL2_harvest(msg.sender, 0);
596         msg.sender.transfer(amount);
597 
598         u.POOL2_provided = u.POOL2_provided.sub(amount);
599         u.POOL2_rewardDebt = u.POOL2_provided.mul(POOL2_accTokensPerETH).div(1e18);
600     }
601 
602     // NFTs
603 
604     // 1. NFT credits of msg.sender
605     function NFT_CREDITS_amount(address a) public view returns(uint){
606         User memory u = users[a];
607         if(u.NFT_CREDITS_receiving){
608             return u.NFT_CREDITS_amount.add(block.number.sub(u.NFT_CREDITS_lastUpdated));
609         }else{
610             return u.NFT_CREDITS_amount;
611         }
612     }
613 
614     // 2. Spend NFT credits when claiming an NFT
615     function spendCredits(address a, uint requiredCredits) external{
616         require(msg.sender == nft, "Can only called by GFarmNFT.");
617         User storage u = users[a];
618         u.NFT_CREDITS_amount = NFT_CREDITS_amount(a).sub(requiredCredits);
619         u.NFT_CREDITS_lastUpdated = block.number;
620     }
621 
622     // PREVENT ROUNDING ERRORS
623 
624     function POOLS_safeTokenTransfer(address _to, uint _amount) private {
625         uint bal = token.balanceOf(address(this));
626         if (_amount > bal) {
627             token.transfer(_to, bal);
628         } else {
629             token.transfer(_to, _amount);
630         }
631     }
632 
633     // USEFUL PRICING FUNCTIONS (FOR TVL & APY)
634 
635     // 1. ETH/USD price (PRECISION)
636     function getEthPrice() private view returns(uint){
637         (uint112 reserves0, uint112 reserves1, ) = ETH_USDC_PAIR.getReserves();
638         uint reserveUSDC;
639         uint reserveETH;
640 
641         if(WETH == ETH_USDC_PAIR.token0()){
642             reserveETH = reserves0;
643             reserveUSDC = reserves1;
644         }else{
645             reserveUSDC = reserves0;
646             reserveETH = reserves1;
647         }
648         // Divide number of USDC by number of ETH
649         // we multiply by 1e12 because USDC only has 6 decimals
650         return reserveUSDC.mul(1e12).mul(PRECISION).div(reserveETH);
651     }
652     // 2. GFARM/ETH price (PRECISION)
653     function getGFarmPriceEth() private view returns(uint){
654         (uint112 reserves0, uint112 reserves1, ) = lp.getReserves();
655 
656         uint reserveETH;
657         uint reserveGFARM;
658 
659         if(WETH == lp.token0()){
660             reserveETH = reserves0;
661             reserveGFARM = reserves1;
662         }else{
663             reserveGFARM = reserves0;
664             reserveETH = reserves1;
665         }
666 
667         return reserveETH.mul(PRECISION).div(reserveGFARM);
668     }
669 
670     // UI VIEW FUNCTIONS (READ-ONLY)
671     
672     function POOLS_blocksLeftUntilStart() external view returns(uint){
673         if(block.number > POOLS_START){ return 0; }
674         return POOLS_START.sub(block.number);
675     }
676 
677     function POOL1_getMultiplier() public view returns (uint) {
678         if(block.number < POOLS_START){
679             return 0;
680         }
681         return POOL1_MULTIPLIER;
682     }
683 
684     function POOL2_getMultiplier() public view returns (uint) {
685         if(block.number < POOLS_START || block.number > POOL2_END){
686             return 0;
687         }
688         return POOL2_MULTIPLIER;
689     }
690 
691     function POOL1_provided() external view returns(uint){
692         return users[msg.sender].POOL1_provided;
693     }
694 
695     function POOL2_provided() external view returns(uint){
696         return users[msg.sender].POOL2_provided;
697     }
698 
699     function POOL1_referralReward() external view returns(uint){
700         return users[msg.sender].POOL1_referralReward;
701     }
702 
703     function POOL2_blocksLeft() external view returns(uint){
704         if(block.number > POOL2_END){
705             return 0;
706         }
707         return POOL2_END.sub(block.number);
708     }
709 
710     function POOL1_referral() external view returns(address){
711         return users[msg.sender].POOL1_referral;
712     }
713 
714     function POOL1_minLpsNftCredits() external view returns(uint){
715         return lp.balanceOf(address(this)).mul(POOL1_CREDITS_MIN_P).div(100);
716     }
717 
718     // (PRECISION)
719     function POOL1_tvl() public view returns(uint){
720         if(lp.totalSupply() == 0){ return 0; }
721 
722         (uint112 reserves0, uint112 reserves1, ) = lp.getReserves();
723         uint reserveEth;
724 
725         if(WETH == lp.token0()){
726             reserveEth = reserves0;
727         }else{
728             reserveEth = reserves1;
729         }
730 
731         uint lpPriceEth = reserveEth.mul(1e5).mul(2).div(lp.totalSupply());
732         uint lpPriceUsd = lpPriceEth.mul(getEthPrice()).div(1e5);
733 
734         return lp.balanceOf(address(this)).mul(lpPriceUsd).div(1e18);
735     }
736 
737     // (PRECISION)
738     function POOL2_tvl() public view returns(uint){
739         return address(this).balance.mul(getEthPrice()).div(1e18);
740     }
741 
742     // (PRECISION)
743     function POOLS_tvl() external view returns(uint){
744         return POOL1_tvl().add(POOL2_tvl());
745     }
746 
747     // (PRECISION)
748     function POOL1_apy() external view returns(uint){
749         if(POOL1_tvl() == 0){ return 0; }
750         return POOL1_MULTIPLIER.mul(2336000)
751                 .mul(getGFarmPriceEth()).mul(getEthPrice())
752                 .mul(100).div(POOL1_tvl());
753     }
754 
755     // (PRECISION)
756     function POOL2_apy() external view returns(uint){
757         if(POOL2_tvl() == 0){ return 0; }
758         return POOL2_MULTIPLIER.mul(2336000)
759                 .mul(getGFarmPriceEth()).mul(getEthPrice())
760                 .mul(100).div(POOL2_tvl());
761     }
762 
763     function myNftCredits() external view returns(uint){
764         return NFT_CREDITS_amount(msg.sender);
765     }
766 
767 }