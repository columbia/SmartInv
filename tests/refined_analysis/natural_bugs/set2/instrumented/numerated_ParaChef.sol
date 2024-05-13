1 // SPDX-License-Identifier: MIT
2 pragma experimental ABIEncoderV2;
3 pragma solidity 0.6.12;
4 
5 import "./ParaToken.sol";
6 import "./interfaces/IERC20.sol";
7 import "./libraries/SafeERC20.sol";
8 import "./libraries/EnumerableSet.sol";
9 import "./libraries/SafeMath_para.sol";
10 import "./interfaces/IWETH.sol";
11 import './interfaces/IParaRouter02.sol';
12 import './interfaces/IParaPair.sol';
13 import './libraries/TransferHelper.sol';
14 import './interfaces/IFeeDistributor.sol';
15 import './ParaProxy.sol';
16 
17 interface IParaTicket {
18     function level() external pure returns (uint256);
19     function tokensOfOwner(address owner) external view returns (uint256[] memory);
20     function setApprovalForAll(address to, bool approved) external;
21     function safeTransferFrom(address from, address to, uint256 tokenId) external;
22     function setUsed(uint256 tokenId) external;
23     function _used(uint256 tokenId) external view returns(bool);
24 }
25 
26 interface IMigratorChef {
27     // Perform LP token migration from legacy UniswapV2 to paraSwap.
28     // Take the current LP token address and return the new LP token address.
29     // Migrator should have full access to the caller's LP token.
30     // Return the new LP token address.
31     //
32     // XXX Migrator must have allowance access to UniswapV2 LP tokens.
33     // paraSwap must mint EXACTLY the same amount of paraSwap LP tokens or
34     // else something bad will happen. Traditional UniswapV2 does not
35     // do that so be careful!
36     function migrate(IERC20 token) external returns (IERC20);
37 }
38 
39 // MasterChef is the master of ParaSwap. He can make T42 and he is a fair guy.
40 //
41 // Note that it's ownable and the owner wields tremendous power. The ownership
42 // will be transferred to a governance smart contract once T42 is sufficiently
43 // distributed and the community can show to govern itself.
44 //
45 // Have fun reading it. Hopefully it's bug-free. God bless.
46 contract MasterChef is ParaProxyAdminStorage {
47     using SafeMath for uint256;
48     using SafeERC20 for IERC20;
49     // Info of each user.
50     struct UserInfo {
51         uint256 amount; // How many LP tokens the user has provided.
52         uint256 rewardDebt; // Reward debt. See explanation below.
53         //
54         // We do some fancy math here. Basically, any point in time, the amount of T42s
55         // entitled to a user but is pending to be distributed is:
56         //
57         //   pending reward = (user.amount * pool.accT42PerShare) - user.rewardDebt
58         //
59         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
60         //   1. The pool's `accT42PerShare` (and `lastRewardBlock`) gets updated.
61         //   2. User receives the pending reward sent to his/her address.
62         //   3. User's `amount` gets updated.
63         //   4. User's `rewardDebt` gets updated.
64     }
65     // Info of each pool.
66     struct PoolInfo {
67         IERC20 lpToken; // Address of LP token contract.
68         uint256 allocPoint; // How many allocation points assigned to this pool. T42s to distribute per block.
69         uint256 lastRewardBlock; // Last block number that T42s distribution occurs.
70         uint256 accT42PerShare; // Accumulated T42s per share, times 1e12. See below.
71         IParaTicket ticket; // if VIP pool, NFT ticket contract, else 0
72         uint256 pooltype;
73     }
74     // every farm's percent of T42 issue
75     uint8[10] public farmPercent;
76     // The T42 TOKEN!
77     ParaToken public t42;
78     // Dev address.
79     address public devaddr;
80     // Treasury address
81     address public treasury;
82     // Fee Distritution contract address
83     address public feeDistributor;
84     // Mining income commission rate, default 5%
85     uint256 public claimFeeRate;
86     // Mining pool withdrawal fee rate, the default is 1.3%
87     uint256 public withdrawFeeRate;
88     // Block number when bonus T42 period ends.
89     uint256 public bonusEndBlock;
90     // Bonus muliplier for early t42 makers.
91     uint256 public constant BONUS_MULTIPLIER = 1;
92     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
93     IMigratorChef public migrator;
94     // Info of each pool.
95     PoolInfo[] public poolInfo;
96     // Info of each user that stakes LP tokens.
97     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
98     // Total allocation poitns. Must be the sum of all allocation points in all pools.
99     uint256 public totalAllocPoint;
100     // The block number when T42 mining starts.
101     uint256 public startBlock;
102     
103     // the address of WETH
104     address public WETH;
105     // the address of Router
106     IParaRouter02 public paraRouter;
107     // Change returned after adding liquidity
108     mapping(address => mapping(address => uint)) public userChange;
109     // record who staked which NFT ticket into this contract
110     mapping(address => mapping(address => uint[])) public ticket_stakes;
111     // record total claimed T42 for per user & per PoolType
112     mapping(address => mapping(uint256 => uint256)) public _totalClaimed;
113     mapping(address => address) public _whitelist;
114     // TOTAL Deposit pid => uint
115     mapping(uint => uint) public poolsTotalDeposit;
116 
117     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
118     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
119     event EmergencyWithdraw(
120         address indexed user,
121         uint256 indexed pid,
122         uint256 amount
123     );
124     event WithdrawChange(
125         address indexed user,
126         address indexed token,
127         uint256 change);
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(admin == msg.sender, "Ownable: caller is not the owner");
133         _;
134     }
135     constructor() public {
136         admin = msg.sender;
137     }
138     
139     function initialize(
140         ParaToken _t42,
141         address _treasury,
142         address _feeDistributor,
143         address _devaddr,
144         uint256 _bonusEndBlock,
145         address _WETH,
146         IParaRouter02 _paraRouter
147     ) external onlyOwner {
148         t42 = _t42;
149         treasury = _treasury;
150         feeDistributor = _feeDistributor;
151         devaddr = _devaddr;
152         bonusEndBlock = _bonusEndBlock;
153         startBlock = _t42.startBlock();
154         WETH = _WETH;
155         paraRouter = _paraRouter;
156         claimFeeRate = 500;
157         withdrawFeeRate = 130;
158     }
159 
160     function _become(ParaProxy proxy) public {
161         require(msg.sender == proxy.admin(), "only proxy admin can change brains");
162         require(proxy._acceptImplementation() == 0, "change not authorized");
163     }
164     
165     function setWhitelist(address _whtie, address accpeter) public onlyOwner {
166         _whitelist[_whtie] = accpeter;
167     }
168 
169     function setT42(ParaToken _t42) public onlyOwner {
170         require(address(_t42) != address(0), "Should not set _t42 to 0x0");
171         t42 = _t42;
172     }
173     
174     function setTreasury(address _treasury) public onlyOwner {
175         require(_treasury != address(0), "Should not set treasury to 0x0");
176         require(_treasury != treasury, "Need a different treasury address");
177         treasury = _treasury;
178     }
179     
180     function setRouter(address _router) public onlyOwner {
181         require(_router != address(0), "Should not set _router to 0x0");
182         require(_router != address(paraRouter), "Need a different treasury address");
183         paraRouter = IParaRouter02(_router);
184     }
185     
186     function setFeeDistributor(address _newAddress) public onlyOwner {
187         require(_newAddress != address(0), "Should not set fee distributor to 0x0");
188         require(_newAddress != feeDistributor, "Need a different fee distributor address");
189         feeDistributor = _newAddress;
190     }
191 
192     function setFarmPercents(uint8[] memory percents) public onlyOwner {
193         uint8 sum = 0;
194         uint8 i = 0;
195         for (i = 0; i < percents.length; i++) {
196             sum += percents[i];
197         }
198         require(sum == 100, "Total percent should be 100%");
199         for (i = 0; i < percents.length; i++) {
200             farmPercent[i] = percents[i];
201         }
202     }
203 
204     function t42PerBlock(uint8 index) public view returns (uint) {
205         return t42.issuePerBlock().mul(farmPercent[index]).div(100);
206     }
207 
208     function setClaimFeeRate(uint256 newRate) public onlyOwner {
209         require(newRate <= 2000, "Claim fee rate should not be greater than 20%");
210         require(newRate != claimFeeRate, "Need a different value");
211         claimFeeRate = newRate;
212     }
213 
214     function setWithdrawFeeRate(uint256 newRate) public onlyOwner {
215         require(newRate <= 500, "Withdraw fee rate should not be greater than 5%");
216         require(newRate != withdrawFeeRate, "Need a different value");
217         withdrawFeeRate = newRate;
218     }
219 
220     function poolLength() external view returns (uint256) {
221         return poolInfo.length;
222     }
223 
224 	function onERC721Received(
225         address,
226         address,
227         uint256,
228         bytes memory
229     ) public returns (bytes4) {
230         return this.onERC721Received.selector;
231     }
232 
233     // Add a new lp to the pool. Can only be called by the owner.
234     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
235     function add(
236         uint256 _allocPoint,
237         IERC20 _lpToken,
238         uint256 _pooltype,
239         IParaTicket _ticket,
240         bool _withUpdate
241     ) public onlyOwner {
242         if (_withUpdate) {
243             massUpdatePools();
244         }
245         uint256 lastRewardBlock =
246             block.number > startBlock ? block.number : startBlock;
247         totalAllocPoint = totalAllocPoint.add(_allocPoint);
248         poolInfo.push(
249             PoolInfo({
250                 lpToken: _lpToken,
251                 allocPoint: _allocPoint,
252                 lastRewardBlock: lastRewardBlock,
253                 accT42PerShare: 0,
254                 pooltype: _pooltype,
255                 ticket: _ticket
256             })
257         );
258     }
259 
260     // Update the given pool's T42 allocation point. Can only be called by the owner.
261     function set(
262         uint256 _pid,
263         uint256 _allocPoint,
264         bool _withUpdate
265     ) public onlyOwner {
266         if (_withUpdate) {
267             massUpdatePools();
268         }
269         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
270             _allocPoint
271         );
272         poolInfo[_pid].allocPoint = _allocPoint;
273     }
274 
275     // Set the migrator contract. Can only be called by the owner.
276     function setMigrator(IMigratorChef _migrator) public onlyOwner {
277         migrator = _migrator;
278     }
279 
280     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
281     function migrate(uint256 _pid) public {
282         require(address(migrator) != address(0), "migrate: no migrator");
283         PoolInfo storage pool = poolInfo[_pid];
284         IERC20 lpToken = pool.lpToken;
285         //TODO use poolsTotalDeposit insteadOf balanceOf(address(this)); ??
286         uint256 bal = poolsTotalDeposit[_pid];
287         lpToken.safeApprove(address(migrator), bal);
288         //uint newLpAmountOld = newLpToken.balanceOf(address(this));
289         IERC20 newLpToken = migrator.migrate(lpToken);
290         uint newLpAmountNew = newLpToken.balanceOf(address(this));
291         require(bal <= newLpAmountNew, "migrate: bad");
292         pool.lpToken = newLpToken;
293     }
294 
295     // Return reward multiplier over the given _from to _to block.
296     function getMultiplier(uint256 _from, uint256 _to)
297         public
298         view
299         returns (uint256)
300     {
301         if (_to <= bonusEndBlock) {
302             return _to.sub(_from).mul(BONUS_MULTIPLIER);
303         } else if (_from >= bonusEndBlock) {
304             return _to.sub(_from);
305         } else {
306             return
307                 bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
308                     _to.sub(bonusEndBlock)
309                 );
310         }
311     }
312 
313     // View function to see pending T42s on frontend.
314     function pendingT42(uint256 _pid, address _user)
315         external
316         view
317         returns (uint256 pending, uint256 fee)
318     {
319         PoolInfo storage pool = poolInfo[_pid];
320         UserInfo storage user = userInfo[_pid][_user];
321         uint256 accT42PerShare = pool.accT42PerShare;
322         //use poolsTotalDeposit[_pid] insteadOf balanceOf(address(this))
323         uint256 lpSupply = poolsTotalDeposit[_pid];
324         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
325             uint256 multiplier =
326                 getMultiplier(pool.lastRewardBlock, block.number);
327             uint256 t42Reward =
328                 multiplier.mul(t42PerBlock(1)).mul(pool.allocPoint).div(
329                     totalAllocPoint
330                 );
331             accT42PerShare = accT42PerShare.add(
332                 t42Reward.mul(1e12).div(lpSupply)
333             );
334         }
335         pending = user.amount.mul(accT42PerShare).div(1e12).sub(user.rewardDebt);
336         fee = pending.mul(claimFeeRate).div(10000);
337     }
338 
339     // Update reward vairables for all pools. Be careful of gas spending!
340     function massUpdatePools() public {
341         uint256 length = poolInfo.length;
342         for (uint256 pid = 0; pid < length; ++pid) {
343             updatePool(pid);
344         }
345     }
346 
347     // Update reward variables of the given pool to be up-to-date.
348     function updatePool(uint256 _pid) public {
349         PoolInfo storage pool = poolInfo[_pid];
350         if (block.number <= pool.lastRewardBlock) {
351             return;
352         }
353         //use poolsTotalDeposit[_pid] insteadOf balanceOf(address(this))
354         uint256 lpSupply = poolsTotalDeposit[_pid];
355         if (lpSupply == 0) {
356             pool.lastRewardBlock = block.number;
357             return;
358         }
359         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
360         uint256 t42Reward =
361             multiplier.mul(t42PerBlock(1)).mul(pool.allocPoint).div(
362                 totalAllocPoint
363             );
364         t42.mint(treasury, t42Reward.div(9));
365         t42.mint(address(this), t42Reward);
366         pool.accT42PerShare = pool.accT42PerShare.add(
367             t42Reward.mul(1e12).div(lpSupply)
368         );
369         pool.lastRewardBlock = block.number;
370     }
371 
372     //uint256 _minPoolTokens,
373     function depositSingle(uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
374         depositSingleInternal(msg.sender, msg.sender, _pid, _token, _amount, paths, _minTokens);
375     }
376 
377     //uint256 _minPoolTokens,
378     function depositSingleTo(address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) payable external{
379         //Msg.sender is on the white list
380         require(_whitelist[msg.sender] != address(0), "only white");
381         
382         IFeeDistributor(feeDistributor).setReferalByChef(_user, _whitelist[msg.sender]);
383         depositSingleInternal(msg.sender, _user, _pid, _token, _amount, paths, _minTokens);
384     }
385 
386     struct DepositVars{
387         uint oldBalance;
388         uint newBalance;
389         uint amountA;
390         uint amountB;
391         uint liquidity;
392     }
393     function depositSingleInternal(address payer, address _user, uint256 _pid, address _token, uint256 _amount, address[][2] memory paths, uint _minTokens) internal {
394         require(paths.length == 2,"deposit: PE");
395         //Stack too deep, try removing local variables
396         DepositVars memory vars;
397         (_token, _amount) = _doTransferIn(payer, _token, _amount);
398         require(_amount > 0, "deposit: zero");
399         //swap by path
400         (address[2] memory tokens, uint[2] memory amounts) = depositSwapForTokens(_token, _amount, paths);
401         //Go approve
402         approveIfNeeded(tokens[0], address(paraRouter), amounts[0]);
403         approveIfNeeded(tokens[1], address(paraRouter), amounts[1]);
404         PoolInfo memory pool = poolInfo[_pid];
405         //Non-VIP pool
406         require(address(pool.ticket) == address(0), "T:E");
407         //lp balance check
408         vars.oldBalance = pool.lpToken.balanceOf(address(this));
409         (vars.amountA, vars.amountB, vars.liquidity) = paraRouter.addLiquidity(tokens[0], tokens[1], amounts[0], amounts[1], 1, 1, address(this), block.timestamp + 600);
410         vars.newBalance = pool.lpToken.balanceOf(address(this));
411         //----------------- TODO 
412         require(vars.newBalance > vars.oldBalance, "B:E");
413         vars.liquidity = vars.newBalance.sub(vars.oldBalance);
414         require(vars.liquidity >= _minTokens, "H:S");
415         addChange(_user, tokens[0], amounts[0].sub(vars.amountA));
416         addChange(_user, tokens[1], amounts[1].sub(vars.amountB));
417         //_deposit
418         _deposit(_pid, vars.liquidity, _user);
419     }
420 
421     function depositSwapForTokens(address _token, uint256 _amount, address[][2] memory paths) internal returns(address[2] memory tokens, uint[2] memory amounts){
422         for (uint256 i = 0; i < 2; i++) {
423             if(paths[i].length == 0){
424                 tokens[i] = _token;
425                 amounts[i] = _amount.div(2);
426             }else{
427                 require(paths[i][0] == _token,"invalid path");
428                 //Go approve
429                 approveIfNeeded(_token, address(paraRouter), _amount);
430                 (tokens[i], amounts[i]) = swapTokensIn(_amount.div(2), paths[i]);
431             }
432         }
433     }
434 
435     function addChange(address user, address _token, uint change) internal returns(uint){
436         if(change > 0){
437             uint changeOld = userChange[user][_token];
438             //set storage
439             userChange[user][_token] = changeOld.add(change);
440         }
441     }
442 
443     function swapTokensIn(uint amountIn, address[] memory path) internal returns(address tokenOut, uint amountOut){
444         uint[] memory amounts = paraRouter.swapExactTokensForTokens(amountIn, 0, path, address(this), block.timestamp + 600);
445         tokenOut = path[path.length - 1];
446         amountOut = amounts[amounts.length - 1];
447     }
448 
449     function _claim(uint256 pooltype, uint pending) internal {
450         uint256 fee = pending.mul(claimFeeRate).div(10000);
451         safeT42Transfer(msg.sender, pending.sub(fee));
452         _totalClaimed[msg.sender][pooltype] += pending.sub(fee);
453         t42.approve(feeDistributor, fee);
454         IFeeDistributor(feeDistributor).incomeClaimFee(msg.sender, address(t42), fee);
455     }
456 
457     function totalClaimed(address _user, uint256 pooltype, uint index) public view returns (uint256) {
458         if (pooltype > 0)
459             return _totalClaimed[_user][pooltype];
460             uint sum = 0;
461             for(uint i = 0; i <= index; i++){
462                 sum += _totalClaimed[_user][i];
463             }
464         return sum;
465     }
466 
467     function deposit_all_tickets(IParaTicket ticket) public {
468         uint256[] memory idlist = ticket.tokensOfOwner(msg.sender);
469         if (idlist.length > 0) {
470             for (uint i = 0; i < idlist.length; i++) {
471                 uint tokenId = idlist[i];   
472                 ticket.safeTransferFrom(msg.sender, address(this), tokenId);
473                 if(!ticket._used(tokenId)){
474                     ticket.setUsed(tokenId);
475                 }
476                 ticket_stakes[msg.sender][address(ticket)].push(tokenId);
477             }
478         }
479     }
480 
481     function ticket_staked_count(address who, address ticket) public view returns (uint) {
482         return ticket_stakes[who][ticket].length;
483     }
484 
485     function ticket_staked_array(address who, address ticket) public view returns (uint[] memory) {
486         return ticket_stakes[who][ticket];
487     }
488 
489     function check_vip_limit(uint ticket_level, uint ticket_count, uint256 amount) public view returns (uint allowed, uint overflow){
490         uint256 limit;
491         if (ticket_level == 0) limit = 1000 * 1e18;
492         else if (ticket_level == 1) limit = 5000 * 1e18;
493         else if (ticket_level == 2) limit = 10000 * 1e18;
494         else if (ticket_level == 3) limit = 25000 * 1e18;
495         else if (ticket_level == 4) limit = 100000 * 1e18;
496         //TODO 
497         uint limitAll = ticket_count.mul(limit);
498         if(amount <= limitAll){
499             allowed = limitAll.sub(amount);
500         }else{
501             overflow = amount.sub(limitAll);
502         }
503     }
504     
505     function deposit(uint256 _pid, uint256 _amount) external {
506         depositInternal(_pid, _amount, msg.sender, msg.sender);
507     }
508 
509     function depositTo(uint256 _pid, uint256 _amount, address _user) external {
510         //Msg.sender is on the white list
511         require(_whitelist[msg.sender] != address(0), "only white");
512         
513         IFeeDistributor(feeDistributor).setReferalByChef(_user, _whitelist[msg.sender]);
514         depositInternal(_pid, _amount, _user, msg.sender);
515     }
516 
517     // Deposit LP tokens to MasterChef for T42 allocation.
518     function depositInternal(uint256 _pid, uint256 _amount, address _user, address payer) internal {
519         PoolInfo storage pool = poolInfo[_pid];
520         pool.lpToken.safeTransferFrom(
521             address(payer),
522             address(this),
523             _amount
524         );
525         if (address(pool.ticket) != address(0)) {
526             UserInfo storage user = userInfo[_pid][_user];
527             uint256 new_amount = user.amount.add(_amount);
528             uint256 user_ticket_count = pool.ticket.tokensOfOwner(_user).length;
529             uint256 staked_ticket_count = ticket_staked_count(_user, address(pool.ticket));
530             uint256 ticket_level = pool.ticket.level();
531             (, uint overflow) = check_vip_limit(ticket_level, user_ticket_count + staked_ticket_count, new_amount);
532             require(overflow == 0, "Exceeding the ticket limit");
533             deposit_all_tickets(pool.ticket);
534         }
535         _deposit(_pid, _amount, _user);
536     }
537 
538     // Deposit LP tokens to MasterChef for para allocation.
539     function _deposit(uint256 _pid, uint256 _amount, address _user) internal {
540         PoolInfo storage pool = poolInfo[_pid];
541         UserInfo storage user = userInfo[_pid][_user];
542         //add total of pool before updatePool
543         poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].add(_amount);
544         updatePool(_pid);
545         if (user.amount > 0) {
546             uint256 pending =
547                 user.amount.mul(pool.accT42PerShare).div(1e12).sub(
548                     user.rewardDebt
549                 );
550             //TODO
551             _claim(pool.pooltype, pending);
552         }
553         user.amount = user.amount.add(_amount);
554         user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
555         emit Deposit(_user, _pid, _amount);
556     }
557 
558     function withdraw_tickets(uint256 _pid, uint256 tokenId) public {
559         //use memory for reduce gas
560         PoolInfo memory pool = poolInfo[_pid];
561         UserInfo memory user = userInfo[_pid][msg.sender];
562         //use storage because of updating value
563         uint256[] storage idlist = ticket_stakes[msg.sender][address(pool.ticket)];
564         for (uint i; i< idlist.length; i++) {
565             if (idlist[i] == tokenId) {
566                 (, uint overflow) = check_vip_limit(pool.ticket.level(), idlist.length - 1, user.amount);
567                 require(overflow == 0, "Please withdraw usdt in advance");
568                 pool.ticket.safeTransferFrom(address(this), msg.sender, tokenId);
569                 idlist[i] = idlist[idlist.length - 1];
570                 idlist.pop();
571                 return;
572             }
573         }
574         require(false, "You never staked this ticket before");
575     }
576 
577     // Withdraw LP tokens from MasterChef.
578     function withdraw(uint256 _pid, uint256 _amount) public {
579         _withdrawInternal(_pid, _amount, msg.sender);
580         emit Withdraw(msg.sender, _pid, _amount);
581     }
582 
583     function _withdrawInternal(uint256 _pid, uint256 _amount, address _operator) internal{
584         (address lpToken,uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, _operator);
585         IERC20(lpToken).safeTransfer(_operator, actual_amount);
586     }
587 
588     function _withdrawWithoutTransfer(uint256 _pid, uint256 _amount, address _operator) internal returns (address lpToken, uint actual_amount){
589         PoolInfo storage pool = poolInfo[_pid];
590         UserInfo storage user = userInfo[_pid][_operator];
591         require(user.amount >= _amount, "withdraw: not good");
592         updatePool(_pid);
593         uint256 pending =
594             user.amount.mul(pool.accT42PerShare).div(1e12).sub(
595                 user.rewardDebt
596             );
597         _claim(pool.pooltype, pending);
598         user.amount = user.amount.sub(_amount);
599         user.rewardDebt = user.amount.mul(pool.accT42PerShare).div(1e12);
600         //sub total of pool
601         poolsTotalDeposit[_pid] = poolsTotalDeposit[_pid].sub(_amount);
602         lpToken = address(pool.lpToken);
603         uint fee = _amount.mul(withdrawFeeRate).div(10000);
604         IERC20(lpToken).approve(feeDistributor, fee);
605         IFeeDistributor(feeDistributor).incomeWithdrawFee(_operator, lpToken, fee, _amount);
606         actual_amount = _amount.sub(fee);
607     }
608 
609     function withdrawSingle(address tokenOut, uint256 _pid, uint256 _amount, address[][2] memory paths) external{
610         require(paths[0].length >= 2 && paths[1].length >= 2, "PE:2");
611         require(paths[0][paths[0].length - 1] == tokenOut,"invalid path_");
612         require(paths[1][paths[1].length - 1] == tokenOut,"invalid path_");
613         //doWithraw Lp
614         (address lpToken, uint actual_amount) = _withdrawWithoutTransfer(_pid, _amount, msg.sender);
615         //remove liquidity
616         address[2] memory tokens;
617         uint[2] memory amounts;
618         tokens[0] = IParaPair(lpToken).token0();
619         tokens[1] = IParaPair(lpToken).token1();
620         //Go approve
621         approveIfNeeded(lpToken, address(paraRouter), actual_amount);
622         (amounts[0], amounts[1]) = paraRouter.removeLiquidity(
623             tokens[0], tokens[1], actual_amount, 0, 0, address(this), block.timestamp.add(600));
624         //swap to tokenOut
625         for (uint i = 0; i < 2; i++){
626             address[] memory path = paths[i];
627             require(path[0] == tokens[0] || path[0] == tokens[1], "invalid path_0");
628             //Consider the same currency situation
629             if(path[0] == tokens[0]){
630                 swapTokensOut(amounts[0], tokenOut, path);
631             }else{
632                 swapTokensOut(amounts[1], tokenOut, path);    
633             }
634         }
635         emit Withdraw(msg.sender, _pid, _amount);
636     }
637 
638     function approveIfNeeded(address _token, address spender, uint _amount) private{
639         if (IERC20(_token).allowance(address(this), spender) < _amount) {
640              IERC20(_token).approve(spender, _amount);
641         }
642     }
643 
644     //swapOut
645     function swapTokensOut(uint amountIn, address tokenOut, address[] memory path) internal {
646         //Consider the same currency situation
647         if(path[0] == path[1]){
648             _doTransferOut(tokenOut, amountIn);
649             return;
650         }
651         approveIfNeeded(path[0], address(paraRouter), amountIn);
652         if(tokenOut == address(0)){
653             //swapForETH to msg.sender
654             paraRouter.swapExactTokensForETH(amountIn, 0, path, msg.sender, block.timestamp + 600);
655         }else{
656             paraRouter.swapExactTokensForTokens(amountIn, 0, path, msg.sender, block.timestamp + 600);
657         }
658     }
659 
660     //Weth -> ETH / transfer erc20
661     function _doTransferOut(address _token, uint amount) private{
662         if(_token == address(0)){
663             IWETH(WETH).withdraw(amount);
664             TransferHelper.safeTransferETH(msg.sender, amount);
665         }else{
666             IERC20(_token).safeTransfer(msg.sender, amount);
667         }
668     }
669 
670     function _doTransferIn(address payer, address _token, uint _amount) private returns(address, uint){
671         if(_token == address(0)){
672             _amount = msg.value;
673             //Convert to WETH
674             IWETH(WETH).deposit{value: _amount}();
675             _token = WETH;
676         }else{
677             IERC20(_token).safeTransferFrom(address(payer), address(this), _amount);
678         }
679         return (_token, _amount);
680     }
681 
682     // Withdraw without caring about rewards. EMERGENCY ONLY.
683     function emergencyWithdraw(uint256 _pid) public {
684         PoolInfo storage pool = poolInfo[_pid];
685         UserInfo storage user = userInfo[_pid][msg.sender];
686         //To get the value in user.amount = 0; calculate
687         uint saved_amount = user.amount;
688         user.amount = 0;
689         user.rewardDebt = 0;   
690         uint fee = saved_amount.mul(withdrawFeeRate).div(10000);
691         pool.lpToken.safeTransfer(address(msg.sender), saved_amount.sub(fee));
692         pool.lpToken.approve(feeDistributor, fee);
693         IFeeDistributor(feeDistributor).incomeWithdrawFee(msg.sender, address(pool.lpToken), fee, saved_amount);
694         emit EmergencyWithdraw(msg.sender, _pid, saved_amount);
695     }
696 
697     function withdrawChange(address[] memory tokens) external{
698         for(uint256 i = 0; i < tokens.length; i++){
699             uint change = userChange[msg.sender][tokens[i]];
700             //set storage
701             userChange[msg.sender][tokens[i]] = 0;
702             IERC20(tokens[i]).safeTransfer(address(msg.sender), change);
703             emit WithdrawChange(msg.sender, tokens[i], change);
704         }
705     }
706 
707     // Safe t42 transfer function, just in case if rounding error causes pool to not have enough T42s.
708     function safeT42Transfer(address _to, uint256 _amount) internal {
709         uint256 t42Bal = t42.balanceOf(address(this));
710         if (_amount > t42Bal) {
711             t42.transfer(_to, t42Bal);
712         } else {
713             t42.transfer(_to, _amount);
714         }
715     }
716 
717     // Update dev address by the previous dev.
718     function dev(address _devaddr) public {
719         require(msg.sender == devaddr, "dev: wut?");
720         devaddr = _devaddr;
721     }
722 }