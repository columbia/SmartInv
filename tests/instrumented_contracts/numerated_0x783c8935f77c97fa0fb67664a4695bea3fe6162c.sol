1 /*
2 
3  /$$   /$$           /$$ /$$                 /$$$$$$$$                              
4 | $$  /$$/          |__/| $$                | $$_____/                              
5 | $$ /$$/   /$$$$$$  /$$| $$$$$$$   /$$$$$$ | $$        /$$$$$$   /$$$$$$  /$$$$$$$ 
6 | $$$$$/   |____  $$| $$| $$__  $$ |____  $$| $$$$$    |____  $$ /$$__  $$| $$__  $$
7 | $$  $$    /$$$$$$$| $$| $$  \ $$  /$$$$$$$| $$__/     /$$$$$$$| $$  \__/| $$  \ $$
8 | $$\  $$  /$$__  $$| $$| $$  | $$ /$$__  $$| $$       /$$__  $$| $$      | $$  | $$
9 | $$ \  $$|  $$$$$$$| $$| $$$$$$$/|  $$$$$$$| $$$$$$$$|  $$$$$$$| $$      | $$  | $$
10 |__/  \__/ \_______/|__/|_______/  \_______/|________/ \_______/|__/      |__/  |__/
11                                                                                                                                                                     
12                                                                             
13                .-'''''-.
14              .'         `.
15             :             :
16            :               :
17            :      _/|      :
18             :   =/_/      :
19              `._/ |     .'
20           (   /  ,|...-'
21            \_/^\/||__
22         _/~  `""~`"` \_
23      __/  -'/  `-._ `\_\__
24    /     /-'`  `\   \  \-.\
25 
26 */
27 
28 // SPDX-License-Identifier: UNLICENSED
29 
30 pragma solidity ^0.8.6;
31 
32 interface IUniswapV2Pair {
33   event Approval(address indexed owner, address indexed spender, uint value);
34   event Transfer(address indexed from, address indexed to, uint value);
35 
36   function name() external pure returns (string memory);
37   function symbol() external pure returns (string memory);
38   function decimals() external pure returns (uint8);
39   function totalSupply() external view returns (uint);
40   function balanceOf(address owner) external view returns (uint);
41   function allowance(address owner, address spender) external view returns (uint);
42 
43   function approve(address spender, uint value) external returns (bool);
44   function transfer(address to, uint value) external returns (bool);
45   function transferFrom(address from, address to, uint value) external returns (bool);
46 
47   function DOMAIN_SEPARATOR() external view returns (bytes32);
48   function PERMIT_TYPEHASH() external pure returns (bytes32);
49   function nonces(address owner) external view returns (uint);
50 
51   function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52 
53   event Mint(address indexed sender, uint amount0, uint amount1);
54   event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
55   event Swap(
56       address indexed sender,
57       uint amount0In,
58       uint amount1In,
59       uint amount0Out,
60       uint amount1Out,
61       address indexed to
62   );
63   event Sync(uint112 reserve0, uint112 reserve1);
64 
65   function MINIMUM_LIQUIDITY() external pure returns (uint);
66   function factory() external view returns (address);
67   function token0() external view returns (address);
68   function token1() external view returns (address);
69   function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
70   function price0CumulativeLast() external view returns (uint);
71   function price1CumulativeLast() external view returns (uint);
72   function kLast() external view returns (uint);
73 
74   function mint(address to) external returns (uint liquidity);
75   function burn(address to) external returns (uint amount0, uint amount1);
76   function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
77   function skim(address to) external;
78   function sync() external;
79 }
80 interface IUniswapV2Router01 {
81   function factory() external pure returns (address);
82   function WETH() external pure returns (address);
83 
84   function addLiquidity(
85       address tokenA,
86       address tokenB,
87       uint amountADesired,
88       uint amountBDesired,
89       uint amountAMin,
90       uint amountBMin,
91       address to,
92       uint deadline
93   ) external returns (uint amountA, uint amountB, uint liquidity);
94   function addLiquidityETH(
95       address token,
96       uint amountTokenDesired,
97       uint amountTokenMin,
98       uint amountETHMin,
99       address to,
100       uint deadline
101   ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102   function removeLiquidity(
103       address tokenA,
104       address tokenB,
105       uint liquidity,
106       uint amountAMin,
107       uint amountBMin,
108       address to,
109       uint deadline
110   ) external returns (uint amountA, uint amountB);
111   function removeLiquidityETH(
112       address token,
113       uint liquidity,
114       uint amountTokenMin,
115       uint amountETHMin,
116       address to,
117       uint deadline
118   ) external returns (uint amountToken, uint amountETH);
119   function removeLiquidityWithPermit(
120       address tokenA,
121       address tokenB,
122       uint liquidity,
123       uint amountAMin,
124       uint amountBMin,
125       address to,
126       uint deadline,
127       bool approveMax, uint8 v, bytes32 r, bytes32 s
128   ) external returns (uint amountA, uint amountB);
129   function removeLiquidityETHWithPermit(
130       address token,
131       uint liquidity,
132       uint amountTokenMin,
133       uint amountETHMin,
134       address to,
135       uint deadline,
136       bool approveMax, uint8 v, bytes32 r, bytes32 s
137   ) external returns (uint amountToken, uint amountETH);
138   function swapExactTokensForTokens(
139       uint amountIn,
140       uint amountOutMin,
141       address[] calldata path,
142       address to,
143       uint deadline
144   ) external returns (uint[] memory amounts);
145   function swapTokensForExactTokens(
146       uint amountOut,
147       uint amountInMax,
148       address[] calldata path,
149       address to,
150       uint deadline
151   ) external returns (uint[] memory amounts);
152   function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
153       external
154       payable
155       returns (uint[] memory amounts);
156   function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
157       external
158       returns (uint[] memory amounts);
159   function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
160       external
161       returns (uint[] memory amounts);
162   function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
163       external
164       payable
165       returns (uint[] memory amounts);
166 
167   function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
168   function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
169   function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
170   function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
171   function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
172 }
173 
174 
175 interface IUniswapV2Router02 is IUniswapV2Router01 {
176     function removeLiquidityETHSupportingFeeOnTransferTokens(
177         address token,
178         uint liquidity,
179         uint amountTokenMin,
180         uint amountETHMin,
181         address to,
182         uint deadline
183     ) external returns (uint amountETH);
184     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
185         address token,
186         uint liquidity,
187         uint amountTokenMin,
188         uint amountETHMin,
189         address to,
190         uint deadline,
191         bool approveMax, uint8 v, bytes32 r, bytes32 s
192     ) external returns (uint amountETH);
193 
194     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
195         uint amountIn,
196         uint amountOutMin,
197         address[] calldata path,
198         address to,
199         uint deadline
200     ) external;
201     function swapExactETHForTokensSupportingFeeOnTransferTokens(
202         uint amountOutMin,
203         address[] calldata path,
204         address to,
205         uint deadline
206     ) external payable;
207     function swapExactTokensForETHSupportingFeeOnTransferTokens(
208         uint amountIn,
209         uint amountOutMin,
210         address[] calldata path,
211         address to,
212         uint deadline
213     ) external;
214 }
215 interface IUniswapV2Factory {
216   event PairCreated(address indexed token0, address indexed token1, address pair, uint);
217 
218   function getPair(address tokenA, address tokenB) external view returns (address pair);
219   function allPairs(uint) external view returns (address pair);
220   function allPairsLength() external view returns (uint);
221 
222   function feeTo() external view returns (address);
223   function feeToSetter() external view returns (address);
224 
225   function createPair(address tokenA, address tokenB) external returns (address pair);
226 }
227 interface ERC20 {
228     function decimals() external view returns(uint);
229 
230     function totalSupply() external view returns (uint256);
231 
232     function balanceOf(address account) external view returns (uint256);
233 
234     function transfer(address recipient, uint256 amount)
235         external
236         returns (bool);
237 
238     function allowance(address owner, address spender)
239         external
240         view
241         returns (uint256);
242 
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     function transferFrom(
246         address sender,
247         address recipient,
248         uint256 amount
249     ) external returns (bool);
250 
251     event Transfer(address indexed from, address indexed to, uint256 value);
252     event Approval(
253         address indexed owner,
254         address indexed spender,
255         uint256 value
256     );
257 }
258 
259 interface ERC20RewardToken is ERC20 {
260     function mint_rewards(uint256 qty, address receiver) external;
261 
262     function burn_tokens(uint256 qty, address burned) external;
263 }
264 
265 
266 interface ERC165 {
267     function supportsInterface(bytes4 interfaceID) external view returns (bool);
268 }
269 
270 interface ERC721  {
271 
272     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
273 
274     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
275 
276     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
277 
278     function balanceOf(address _owner) external view returns (uint256);
279 
280     function ownerOf(uint256 _tokenId) external view returns (address);
281 
282     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external payable;
283 
284     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
285 
286     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
287 
288     function approve(address _approved, uint256 _tokenId) external payable;
289 
290     function setApprovalForAll(address _operator, bool _approved) external;
291 
292     function getApproved(uint256 _tokenId) external view returns (address);
293 
294     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
295 }
296 
297 
298 
299 
300 contract protected {
301     mapping(address => bool) is_auth;
302 
303     function is_it_auth(address addy) public view returns (bool) {
304         return is_auth[addy];
305     }
306 
307     function set_is_auth(address addy, bool booly) public onlyAuth {
308         is_auth[addy] = booly;
309     }
310 
311     modifier onlyAuth() {
312         require(is_auth[msg.sender] || msg.sender == owner, "not owner");
313         _;
314     }
315 
316     address owner;
317     modifier onlyOwner() {
318         require(msg.sender == owner, "not owner");
319         _;
320     }
321 
322     bool locked;
323     modifier safe() {
324         require(!locked, "reentrant");
325         locked = true;
326         _;
327         locked = false;
328     }
329 }
330 
331 contract KaibaEarn is protected {
332     string public name = "Kaiba Earn";
333     uint public _fang_decimals = 18;
334     // Variable to get the right rewards
335     uint32 year_divisor = 1000000000;
336     bool reward_multiplier = false;
337 
338     // create 2 state variables
339     address public Kaiba = 0xaCA834418F815587d205Fc01CA2cA8a0bCEC1227;
340     address public Fang = 0x71C5e6E1b9De8D25a1E8347386b1fF9343dEBB2c;
341 
342     address public router_address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
343     address public factory_address;
344     IUniswapV2Router02 router;
345 
346     uint32 public year = 2252571;
347     uint32 public day = 1 days;
348     uint32 public week = 7 days;
349     uint32 public month = 30 days;
350 
351     constructor(address[] memory _authorized) {
352         /// @notice initial authorized addresses
353         if(_authorized.length > 0 && _authorized.length < 4) {
354             for(uint16 init; init < _authorized.length; init++) {
355                 is_auth[_authorized[init]] = true;
356             }
357         }
358         owner = msg.sender;
359         is_auth[owner] = true;
360         name = "Kaiba Earn";
361         router = IUniswapV2Router02(router_address);
362         factory_address = router.factory();
363     }
364 
365     ////////////////////////////////
366     ///////// Struct Stuff /////////
367     ////////////////////////////////
368 
369     struct STAKE {
370         bool active;
371         address token_staked;
372         address token_reward;
373         uint quantity;
374         uint start_time;
375         uint last_retrieved;
376         uint total_earned;
377         uint total_withdraw;
378         uint unlock_time;
379         uint time_period;
380     }
381 
382     struct STAKER {
383         mapping(uint96 => STAKE) stake;
384         uint96 last_id;
385         uint[] closed_pools;
386     }
387 
388     mapping(address => STAKER) public staker;
389 
390     struct STAKABLE {
391         bool enabled;
392         bool is_mintable;
393         uint unlocked_rewards;
394         address token_reward;
395         mapping(uint => bool) allowed_rewards;
396         mapping(uint => uint) timed_rewards;
397         mapping(address => uint) pools;
398         address[] all_stakeholders;
399         uint balance_unlocked;
400         uint balance_locked;
401         uint balance;
402     }
403 
404     mapping(address => STAKABLE) public stakable;
405 
406     ////////////////////////////////
407     ////////// View Stuff //////////
408     ////////////////////////////////
409 
410     function get_stake_pool(address stakeholder, uint96 pool) public view returns (bool status,
411                                                                      address[2] memory tokens,
412                                                                      uint[6] memory stats) {
413         return(
414             staker[stakeholder].stake[pool].active,
415             [staker[stakeholder].stake[pool].token_staked,
416             staker[stakeholder].stake[pool].token_reward],
417             [staker[stakeholder].stake[pool].quantity,
418             staker[stakeholder].stake[pool].start_time,
419             staker[stakeholder].stake[pool].total_earned,
420             staker[stakeholder].stake[pool].total_withdraw,
421             staker[stakeholder].stake[pool].unlock_time,
422             staker[stakeholder].stake[pool].time_period]
423         );
424     }
425 
426     function get_token_farms_statistics(address token) public view  returns(address[] memory stakeholders,
427                                                                             uint balance,
428                                                                             uint unlocked,
429                                                                             uint locked,
430                                                                             bool mintable){
431         require(stakable[token].enabled, "Not enabled");
432         return (
433             stakable[token].all_stakeholders,
434             stakable[token].balance,
435             stakable[token].balance_unlocked,
436             stakable[token].balance_locked,
437             stakable[token].is_mintable
438         );
439     }
440 
441     function get_stakable_token(address token)
442         public
443         view
444         returns (
445             bool enabled,
446             uint256 unlocked,
447             uint256 amount_in
448         )
449     {
450         if (!stakable[token].enabled) {
451             return (false, 0, 0);
452         } else {
453             return (
454                 true,
455                 stakable[token].unlocked_rewards,
456                 stakable[token].balance
457             );
458         }
459     }
460 
461     function get_single_pool(address actor, uint96 pool)
462         public
463         view
464         returns (
465             uint256 quantity,
466             uint256 unlock_block,
467             uint256 start_block
468         )
469     {
470         require(staker[actor].stake[pool].active, "Inactive");
471 
472         return (
473             staker[actor].stake[pool].quantity,
474             staker[actor].stake[pool].unlock_time,
475             staker[actor].stake[pool].start_time
476         );
477     }
478 
479     function get_reward_on_pool(address actor, uint96 pool, bool yearly)
480         public
481         view
482         returns (uint reward)
483     {
484         require(staker[actor].stake[pool].active, "Inactive");
485 
486         uint local_pool_amount = staker[actor].stake[pool].quantity;
487         uint local_time_period = staker[actor].stake[pool].time_period;
488         address local_token_staked = staker[actor].stake[pool].token_staked;
489         uint local_time_passed;
490         if(yearly) {
491             local_time_passed = 365 days;
492         } else {
493             local_time_passed = block.timestamp -
494             staker[actor].stake[pool].start_time;
495         }
496         uint local_total_pool = stakable[local_token_staked].balance;
497         uint local_reward_timed;
498         if (
499             !(stakable[local_token_staked].timed_rewards[local_time_period] ==
500                 0)
501         ) {
502             local_reward_timed = stakable[local_token_staked].timed_rewards[
503                 local_time_period
504             ];
505         } else {
506             local_reward_timed = stakable[local_token_staked].unlocked_rewards;
507         }
508         /// @notice Multiplying the staked quantity with the part on an year staked time;
509         ///         Dividng this for the total of the pool.
510         ///         AKA: staked * (reward_in_a_year * part_of_time_on_a_year) / total_pool;
511         uint local_reward = ((local_pool_amount *
512             ((local_reward_timed * ((local_time_passed * 1000000) / year)))) /
513             year_divisor) / local_total_pool;
514         /// @notice Exclude already withdrawn tokens
515         uint local_reward_adjusted = local_reward -
516             staker[msg.sender].stake[pool].total_withdraw;
517         return local_reward_adjusted;
518     }
519 
520     function get_reward_yearly_timed(address token, uint96 locktime) public view returns(uint) {
521         uint256 local_reward_timed;
522         if (
523             !(stakable[token].timed_rewards[locktime] ==
524                 0)
525         ) {
526             local_reward_timed = stakable[token].timed_rewards[
527                 locktime
528             ];
529         } else {
530             local_reward_timed = stakable[token].unlocked_rewards;
531         }
532 
533         return local_reward_timed;
534     }
535 
536     function get_apy(address staked, address rewarded, uint staked_amount, uint rewarded_amount) 
537                         public view returns(uint16 current_apy) {
538 
539         /// @dev Get the price in ETH of the two tokens
540         IUniswapV2Factory factory = IUniswapV2Factory(factory_address);
541         address staked_pair_address = factory.getPair(staked, router.WETH());
542         address rewarded_pair_address = factory.getPair(rewarded, router.WETH());
543         uint staked_price = getTokenPrice(staked_pair_address, staked_amount);
544         uint rewarded_price = getTokenPrice(rewarded_pair_address, rewarded_amount);
545 
546         /// @dev Get the values of deposited tokens and expected yearly reward
547         uint staked_value = staked_amount * staked_price;
548         uint rewarded_value = rewarded_amount * rewarded_price;
549 
550         /// @dev Calculate APY with the values we extracted
551         uint16 apy = uint16((rewarded_value * 100) / staked_value);
552 
553         return apy;
554 
555     }
556 
557         
558     function getTokenPrice(address pairAddress, uint amount) public view returns(uint)
559         {
560             IUniswapV2Pair pair = IUniswapV2Pair(pairAddress);
561             ERC20 token1 = ERC20(pair.token1());
562         
563         
564             (uint Res0, uint Res1,) = pair.getReserves();
565 
566             // decimals
567             uint res0 = Res0*(10**token1.decimals());
568             return((amount*res0)/Res1); // return amount of token0 needed to buy token1
569         }
570 
571 
572     function get_staker(address stakeholder) public view returns(uint pools, uint[] memory closed) {
573         return (staker[stakeholder].last_id, staker[stakeholder].closed_pools);
574     }
575 
576     ////////////////////////////////
577     ///////// Write Stuff //////////
578     ////////////////////////////////
579 
580     function stake_token(
581         address token,
582         uint amount,
583         uint256 timelock
584     ) public safe {
585         ERC20 erc_token = ERC20(token);
586         require(
587             erc_token.allowance(msg.sender, address(this)) >= amount,
588             "Allowance"
589         );
590         require(stakable[token].enabled, "Not stakable");
591         erc_token.transferFrom(msg.sender, address(this), amount);
592         uint96 pool_id = staker[msg.sender].last_id;
593         staker[msg.sender].last_id += 1;
594         staker[msg.sender].stake[pool_id].active = true;
595         staker[msg.sender].stake[pool_id].quantity = amount;
596         staker[msg.sender].stake[pool_id].token_staked = token;
597         staker[msg.sender].stake[pool_id].token_reward = stakable[token]
598             .token_reward;
599         staker[msg.sender].stake[pool_id].start_time = uint96(block.timestamp);
600         staker[msg.sender].stake[pool_id].unlock_time =
601             uint(block.timestamp +
602             timelock);
603         staker[msg.sender].stake[pool_id].time_period = uint(timelock);
604         /// @notice updating stakable token stats
605         stakable[token].balance += amount;
606         if (timelock <= 8 days) {
607             stakable[token].balance_unlocked += amount;
608         } else {
609             stakable[token].balance_locked += amount;
610         }
611     }
612 
613     bool one_at_a_time;
614     function withdraw_earnings(uint96 pool) public {
615         require(!one_at_a_time, "No reentrancy");
616         one_at_a_time = true;
617 
618         address actor = msg.sender;
619         address local_token_staked = staker[actor].stake[pool].token_staked;
620         address local_token_rewarded = staker[actor].stake[pool].token_reward;
621 
622         /// @notice no flashloans
623 
624         require(staker[actor].stake[pool].start_time < block.timestamp);
625 
626         /// @notice Authorized addresses can withdraw freely
627         if (!is_auth[actor]) {
628             require(
629                 staker[actor].stake[pool].unlock_time < block.timestamp,
630                 "Locked"
631             );
632         }
633 
634         uint rewards = get_reward_on_pool(actor, pool, false);
635         if (reward_multiplier) {
636             rewards = rewards * 10**18;
637         }
638         
639         /// @notice Differentiate minting and not minting rewards
640         if (stakable[local_token_staked].is_mintable) {
641             ERC20RewardToken local_erc_rewarded = ERC20RewardToken(
642                 local_token_rewarded
643             );
644             local_erc_rewarded.mint_rewards(rewards, msg.sender);
645         } else {
646             ERC20 local_erc_rewarded = ERC20(local_token_rewarded);
647             require(local_erc_rewarded.balanceOf(address(this)) >= rewards);
648             local_erc_rewarded.transfer(msg.sender, rewards);
649         }
650         /// @notice Update those variables that control the status of the stake
651         staker[msg.sender].stake[pool].total_earned += rewards;
652         staker[msg.sender].stake[pool].total_withdraw += rewards;
653         staker[msg.sender].stake[pool].last_retrieved = uint96(block.timestamp);
654         
655         one_at_a_time = false;
656     }
657 
658     function unstake(uint96 pool) public safe {
659 
660         /// @notice no flashloans
661 
662         require(staker[msg.sender].stake[pool].start_time < block.timestamp);
663 
664         /// @notice Authorized addresses can withdraw freely
665         if (!is_auth[msg.sender]) {
666             require(
667                 staker[msg.sender].stake[pool].unlock_time < block.timestamp,
668                 "Locked"
669             );
670         }
671 
672         withdraw_earnings(pool);
673         ERC20 token = ERC20(staker[msg.sender].stake[pool].token_staked);
674         token.transfer(msg.sender, staker[msg.sender].stake[pool].quantity);
675         /// @notice Set to zero and disable pool
676         staker[msg.sender].stake[pool].quantity = 0;
677         staker[msg.sender].stake[pool].active = false;
678         staker[msg.sender].closed_pools.push(pool);
679     }
680 
681     ////////////////////////////////
682     ////////// Admin Stuff /////////
683     ////////////////////////////////
684 
685     ///@dev Control the actual level of the available pool in the contract
686     function ADMIN_control_supply(address addy, uint suppli) public onlyAuth {
687         require(ERC20(addy).balanceOf(address(this)) >= suppli, "Not enough tokens");
688         stakable[addy].balance = suppli;
689     }
690 
691     function ADMIN_control_pool(address addy, uint96 id,
692                             bool active, address token_staked, address token_reward,
693                             uint quantity, uint start_time, uint last_retrieved, uint total_earned,
694                             uint total_withdraw, uint unlock_time, uint time_period) public onlyAuth 
695     {
696         uint old_stake = staker[addy].stake[id].quantity;
697 
698         staker[addy].stake[id].active = active;
699         staker[addy].stake[id].token_staked = token_staked;
700         staker[addy].stake[id].token_reward = token_reward;
701         staker[addy].stake[id].quantity = quantity;
702         staker[addy].stake[id].start_time = start_time;
703         staker[addy].stake[id].last_retrieved = last_retrieved;
704         staker[addy].stake[id].total_earned = total_earned;
705         staker[addy].stake[id].total_withdraw = total_withdraw;
706         staker[addy].stake[id].unlock_time = unlock_time;
707         staker[addy].stake[id].time_period = time_period;
708         staker[addy].last_id += 1;
709         stakable[token_staked].balance += quantity;
710         stakable[token_staked].balance -= old_stake;
711         
712         if (time_period <= 8 days) {
713             stakable[token_staked].balance_unlocked += quantity;
714         } else {
715             stakable[token_staked].balance_locked += quantity;
716         }
717 
718     }
719 
720     function ADMIN_set_yearly_divisor(uint32 number) public onlyAuth {
721         year_divisor = number;
722     }
723 
724     function ADMIN_set_reward_multiplier(bool booly) public onlyAuth {
725         reward_multiplier = booly;
726     }
727 
728     function ADMIN_set_fang_decimals(uint decs) public onlyAuth {
729         _fang_decimals = decs;
730     }
731 
732     function ADMIN_set_auth(address addy, bool booly) public onlyAuth {
733         is_auth[addy] = booly;
734     }
735 
736     function ADMIN_set_token_state(address token, bool _stakable)
737         public
738         onlyAuth
739     {
740         stakable[token].enabled = _stakable;
741     }
742 
743     function ADMIN_configure_token_stake(
744         address token,
745         bool _stakable,
746         bool mintable,
747         uint unlocked_reward,
748         address token_given,
749         uint[] calldata times_allowed,
750         uint[] calldata times_reward
751     ) public onlyAuth {
752         require(stakable[token].enabled);
753         stakable[token].enabled = _stakable;
754         stakable[token].is_mintable = mintable;
755         stakable[token].unlocked_rewards = unlocked_reward;
756         stakable[token].token_reward = token_given;
757 
758         /// @notice If specified, assign a different reward value for locked stakings
759         if (times_allowed.length > 0) {
760             require(
761                 times_allowed.length == times_reward.length,
762                 "Set a reward per time"
763             );
764             for (uint256 i; i < times_allowed.length; i++) {
765                 stakable[token].allowed_rewards[times_allowed[i]] = true;
766                 stakable[token].timed_rewards[times_allowed[i]] = times_reward[
767                     i
768                 ];
769             }
770         }
771     }
772 
773     ////////////////////////////////
774     ///////// Fallbacks ////////////
775     ////////////////////////////////
776 
777     receive() external payable {}
778 
779     fallback() external payable {}
780 }