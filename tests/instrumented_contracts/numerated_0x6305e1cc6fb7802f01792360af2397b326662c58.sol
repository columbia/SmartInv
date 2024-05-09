1 pragma solidity ^0.5.0;
2 
3 interface IERC20 
4 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address who) external view returns (uint256);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function transfer(address to, uint256 value) external returns (bool);
9     function approve(address spender, uint256 value) external returns (bool);
10     function transferFrom(address from, address to, uint256 value) external returns (bool);
11     
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 contract ApproveAndCallFallBack {
17 
18     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
19 }
20 
21 library SafeMath 
22 {
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
24     {
25         if (a == 0) 
26         {
27             return 0;
28         }
29         uint256 c = a * b;
30         assert(c / a == b);
31         return c;
32     }
33     
34     function div(uint256 a, uint256 b) internal pure returns (uint256) 
35     {
36         uint256 c = a / b;
37         return c;
38     }
39     
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
41     {
42         assert(b <= a);
43         return a - b;
44     }
45     
46     function add(uint256 a, uint256 b) internal pure returns (uint256) 
47     {
48         uint256 c = a + b;
49         assert(c >= a);
50         return c;
51     }
52     
53     function ceil(uint256 a, uint256 m) internal pure returns (uint256) 
54     {
55         uint256 c = add(a,m);
56         uint256 d = sub(c,1);
57         return mul(div(d,m),m);
58     }
59 }
60 
61 contract ERC20Detailed is IERC20 
62 {
63     string private _name;
64     string private _symbol;
65     uint8 private _decimals;
66     
67     constructor(string memory name, string memory symbol, uint8 decimals) public {
68         _name = name;
69         _symbol = symbol;
70         _decimals = decimals;
71     }
72     
73     function name() public view returns(string memory) {
74         return _name;
75     }
76     
77     function symbol() public view returns(string memory) {
78         return _symbol;
79     }
80     
81     function decimals() public view returns(uint8) {
82         return _decimals;
83     }
84 }
85 
86 
87 contract BOMB3D is ERC20Detailed 
88 {
89     
90     using SafeMath for uint256;
91     mapping (address => uint256) private _balances;
92     mapping (address => mapping (address => uint256)) private _allowed;
93     
94     string constant tokenName = "BOMB3D 💣";
95     string constant tokenSymbol = "BOMB3D";
96     uint8  constant tokenDecimals = 18;
97     uint256 _totalSupply = 0;
98     
99     // ------------------------------------------------------------------------
100 
101     address payable admin = address(0);
102     
103     address unWrappedTokenAddress = address(0x1C95b093d6C236d3EF7c796fE33f9CC6b8606714);
104     
105     mapping (address => uint256) private _stakedBalances;
106     uint256 public totalAmountStaked = 0;
107     
108     mapping (address => uint256) private _stakingMultipliers;
109     mapping (address => uint256) private _stakedBalances_wMultiplier;
110     uint256 public totalAmountStaked_wMultipliers = 0;
111     
112     mapping (address => uint256) private _stakedBalances_bonuses;
113     uint256 public totalAmountStaked_bonuses = 0;
114     uint256 constant stakingBonuses_max = 50000;
115     
116     uint256 public staking_totalUnpaidRewards  = 0;
117     uint256 _staking_totalRewardsPerUnit = 0;
118     mapping (address => uint256) private _staking_totalRewardsPerUnit_positions;
119     mapping (address => uint256) private _staking_savedRewards;
120     
121     uint256 _staking_totalRewardsPerUnit_eth = 0;
122     mapping (address => uint256) private _staking_totalRewardsPerUnit_positions_eth;
123     mapping (address => uint256) private _staking_savedRewards_eth;
124     
125     // ------------------------------------------------------------------------
126     
127     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
128     {
129         admin = msg.sender;
130     }
131     
132     // ------------------------------------------------------------------------
133     //ERC20 IMPLEMENTATION with approveAndCall
134     // ------------------------------------------------------------------------
135     
136     function totalSupply() public view returns (uint256) 
137     {
138         return _totalSupply.add(appendDecimals(totalAmountStaked)).add(staking_totalUnpaidRewards);
139     }
140     
141     function balanceOf(address owner) public view returns (uint256) 
142     {
143         return _balances[owner];
144     }
145     
146     function allowance(address owner, address spender) public view returns (uint256) 
147     {
148         return _allowed[owner][spender];
149     }
150     
151     function transfer(address to, uint256 value) public returns (bool) 
152     {
153         require(value <= _balances[msg.sender]);
154         require(to != address(0));
155         
156         _balances[msg.sender] = _balances[msg.sender].sub(value);
157         _balances[to] = _balances[to].add(value);
158         
159         emit Transfer(msg.sender, to, value);
160         return true;
161     }
162     
163     function multiTransfer(address[] memory receivers, uint256[] memory values) public
164     {
165         for (uint256 i = 0; i < receivers.length; i++) 
166         {
167             transfer(receivers[i], values[i]);
168         }
169     }
170     
171     function approve(address spender, uint256 value) public returns (bool) 
172     {
173         require(spender != address(0));
174         _allowed[msg.sender][spender] = value;
175         emit Approval(msg.sender, spender, value);
176         return true;
177     }
178     
179     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) 
180     {
181         _allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
184         return true;
185     }
186     
187     function transferFrom(address from, address to, uint256 value) public returns (bool) 
188     {
189         require(value <= _balances[from]);
190         require(value <= _allowed[from][msg.sender]);
191         require(to != address(0));
192         
193         _balances[from] = _balances[from].sub(value);
194         _balances[to] = _balances[to].add(value);
195         
196         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197         
198         emit Transfer(from, to, value);
199         
200         return true;
201     }
202     
203     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
204     {
205         require(spender != address(0));
206         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
207         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
208         return true;
209     }
210     
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
212     {
213         require(spender != address(0));
214         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
215         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
216         return true;
217     }
218     
219     function _mint(address account, uint256 value) internal 
220     {
221         require(value != 0);
222         _balances[account] = _balances[account].add(value);
223         _totalSupply = _totalSupply.add(value);
224         emit Transfer(address(0), account, value);
225     }
226     
227     function burn(uint256 value) external 
228     {
229         _burn(msg.sender, value);
230     }
231     
232     function _burn(address account, uint256 value) internal 
233     {
234         require(value != 0);
235         require(value <= _balances[account]);
236         _totalSupply = _totalSupply.sub(value);
237         _balances[account] = _balances[account].sub(value);
238         emit Transfer(account, address(0), value);
239     }
240     
241     function burnFrom(address account, uint256 value) external 
242     {
243         require(value <= _allowed[account][msg.sender]);
244         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
245         _burn(account, value);
246     }
247     
248     
249     // ------------------------------------------------------------------------
250     //WRAPPING
251     // ------------------------------------------------------------------------
252     
253     
254     //Turn BOMBs into BOMB3Ds
255     function wrap(uint256 value_unwrapped) public returns (bool) 
256     {
257         require(IERC20(unWrappedTokenAddress).allowance(msg.sender, address(this)) >= value_unwrapped);
258         
259         uint256 balance_beforeTransfer = IERC20(unWrappedTokenAddress).balanceOf(address(this));
260         require(IERC20(unWrappedTokenAddress).transferFrom(msg.sender, address(this), value_unwrapped));
261         uint256 balance_afterTransfer = IERC20(unWrappedTokenAddress).balanceOf(address(this));
262         
263         require(balance_afterTransfer > balance_beforeTransfer);
264         
265         //determine what really was received on this end
266         uint256 receivedValue = balance_afterTransfer.sub(balance_beforeTransfer);
267         
268         //create decimals
269         uint256 receivedValueWithDecimals = appendDecimals(receivedValue);
270         
271         uint256 effectiveAmountStaked = totalAmountStaked_effective();
272         if(effectiveAmountStaked > 0)
273         {
274             //calculate staking rewards
275             uint256 stakingReward = findOnePercent(receivedValueWithDecimals).mul(getStakingRewardPercentage());
276             require(stakingReward < receivedValueWithDecimals);
277         
278             //split up to rewards per unit in stake
279             uint256 RewardsPerUnit = stakingReward.div(effectiveAmountStaked);
280             
281             //apply rewards
282             _staking_totalRewardsPerUnit = _staking_totalRewardsPerUnit.add(RewardsPerUnit);
283             
284             //prevent leaving any dust in the contract
285             uint256 actualRewardsCreated = RewardsPerUnit.mul(effectiveAmountStaked);
286             staking_totalUnpaidRewards = staking_totalUnpaidRewards.add(actualRewardsCreated);
287             uint256 dust = stakingReward.sub(actualRewardsCreated);
288             if(dust > 0)
289                 _mint(admin, dust);
290             
291             //give out BOMB3Ds
292             _mint(msg.sender, receivedValueWithDecimals.sub(stakingReward));
293         }
294         else 
295             _mint(msg.sender, receivedValueWithDecimals);
296         
297         return true;
298     }
299     
300     //Turn BOMB3Ds into BOMBs
301     function unwrap(uint256 value_unwrapped) public returns (bool)
302     {
303         return unwrapTo(value_unwrapped, msg.sender);
304     }
305     
306     //Turn BOMB3Ds into BOMBs, also set target address so you can save 1% from being destroyed when you want to transfer to an exchange/other third party
307     function unwrapTo(uint256 value_unwrapped, address target) public returns (bool)
308     {
309         uint256 valueWithDecimals = appendDecimals(value_unwrapped);
310         require(balanceOf(msg.sender) >= valueWithDecimals);
311         require(IERC20(unWrappedTokenAddress).transfer(target, value_unwrapped));
312         _burn(msg.sender, valueWithDecimals);
313         return true;
314     }
315     
316     
317     
318     // ------------------------------------------------------------------------
319     //STAKING
320     // ------------------------------------------------------------------------
321     
322     function stakedBalanceOf(address owner) public view returns (uint256) 
323     {
324         return _stakedBalances[owner];
325     }
326     
327     function stakedBalanceOf_wMultiplier(address owner) public view returns (uint256) 
328     {
329         return _stakedBalances_wMultiplier[owner];
330     }
331     
332     function stakedBalanceOf_bonuses(address owner) public view returns (uint256) 
333     {
334         return _stakedBalances_bonuses[owner];
335     }
336     
337     function stakedBalanceOf_effective(address owner) public view returns (uint256) 
338     {
339         return _stakedBalances_wMultiplier[owner].add(_stakedBalances_bonuses[owner]);
340     }
341     
342     function totalAmountStaked_effective() public view returns (uint256) 
343     {
344         return totalAmountStaked_wMultipliers.add(totalAmountStaked_bonuses);
345     }
346     //Moves BOMB3Ds into staking mode. Only full BOMB3Ds can be staked. 
347     //Stakers earn rewards whenever BOMBs are converted to BOMB3Ds.
348     function stake(uint256 value_unwrapped) public
349     {
350         require(value_unwrapped > 0);
351         uint256 valueWithDecimals = appendDecimals(value_unwrapped);
352         require(_balances[msg.sender] >= valueWithDecimals);
353         _burn(msg.sender, valueWithDecimals);
354         
355         updateRewardsFor(msg.sender);
356         
357         _stakedBalances[msg.sender] = _stakedBalances[msg.sender].add(value_unwrapped);
358         totalAmountStaked = totalAmountStaked.add(value_unwrapped);
359         
360         uint256 value_unwrapped_multiplied = value_unwrapped * getCurrentStakingMultiplier(msg.sender);
361         _stakedBalances_wMultiplier[msg.sender] = _stakedBalances_wMultiplier[msg.sender].add(value_unwrapped_multiplied);
362         totalAmountStaked_wMultipliers = totalAmountStaked_wMultipliers.add(value_unwrapped_multiplied);
363     }
364     
365     //Removes BOMB3Ds from staking mode.
366     function unstake(uint256 value_unwrapped) public
367     {
368         require(value_unwrapped > 0);
369         require(value_unwrapped <= _stakedBalances[msg.sender]);
370         updateRewardsFor(msg.sender);
371         _stakedBalances[msg.sender] = _stakedBalances[msg.sender].sub(value_unwrapped);
372         totalAmountStaked = totalAmountStaked.sub(value_unwrapped);
373         
374         uint256 value_unwrapped_multiplied = value_unwrapped * getCurrentStakingMultiplier(msg.sender);
375         _stakedBalances_wMultiplier[msg.sender] = _stakedBalances_wMultiplier[msg.sender].sub(value_unwrapped_multiplied);
376         totalAmountStaked_wMultipliers = totalAmountStaked_wMultipliers.sub(value_unwrapped_multiplied);
377         
378         uint256 valueWithDecimals = appendDecimals(value_unwrapped);
379         _mint(msg.sender, valueWithDecimals);
380     }
381     
382     //Rewards percentage is based on circulating supply.
383     function getStakingRewardPercentage() public view returns (uint256)
384     {
385         uint256 totalSupply_cur = totalSupply();
386         if(totalSupply_cur < appendDecimals(1000)) //early stakers bonus
387             return 3;
388         if(totalSupply_cur < appendDecimals(10000)) //early stakers bonus cooldown
389             return 2;
390         if(totalSupply_cur <  appendDecimals(50000)) //let normies get in
391             return 1;
392         if(totalSupply_cur <  appendDecimals(100000)) //getting juicy again
393             return 3;
394         return 5; //late to the party madness
395     }
396     
397     //Admin can reward users with additional virtual stake from a capped pool.
398     function setStakingBonus(address staker, uint256 value) public
399     {
400         require(msg.sender == admin);
401         updateRewardsFor(staker);
402         totalAmountStaked_bonuses = totalAmountStaked_bonuses.sub(_stakedBalances_bonuses[staker]);
403         _stakedBalances_bonuses[staker] = value;
404         totalAmountStaked_bonuses = totalAmountStaked_bonuses.add(value);
405         require(totalAmountStaked_bonuses <= stakingBonuses_max);
406     }
407     
408     //catch up with the current total Rewards. 
409     //this needs to be done whenever a stake is changed, either by staking more/less or applying a multiplier
410     function updateRewardsFor(address staker) private
411     {
412         _staking_savedRewards[staker] = viewUnpaidRewards(staker);
413         _staking_totalRewardsPerUnit_positions[staker] = _staking_totalRewardsPerUnit;
414         
415         _staking_savedRewards_eth[staker] = viewUnpaidRewards_eth(staker);
416         _staking_totalRewardsPerUnit_positions_eth[staker] = _staking_totalRewardsPerUnit_eth;
417     }
418     
419     //get all rewards that have not been claimed yet
420     function viewUnpaidRewards(address staker) public view returns (uint256)
421     {
422         uint256 newRewardsPerUnit = _staking_totalRewardsPerUnit.sub(_staking_totalRewardsPerUnit_positions[staker]);
423         uint256 newRewards = newRewardsPerUnit.mul(stakedBalanceOf_effective(staker));
424         return _staking_savedRewards[staker].add(newRewards);
425     }
426     //get all eth rewards that have not been claimed yet
427     function viewUnpaidRewards_eth(address staker) public view returns (uint256)
428     {
429         uint256 newRewardsPerUnit = _staking_totalRewardsPerUnit_eth.sub(_staking_totalRewardsPerUnit_positions_eth[staker]);
430         uint256 newRewards = newRewardsPerUnit.mul(stakedBalanceOf_effective(staker));
431         return _staking_savedRewards_eth[staker].add(newRewards);
432     }
433     
434     //pay out all unclaimed rewards
435     function payoutRewards() public
436     {
437         updateRewardsFor(msg.sender);
438         
439         uint256 rewards = _staking_savedRewards[msg.sender];
440         _staking_savedRewards[msg.sender] = 0;
441         staking_totalUnpaidRewards = staking_totalUnpaidRewards.sub(rewards);
442         if(rewards > 0)
443             _mint(msg.sender, rewards);
444         
445         uint256 rewards_eth = _staking_savedRewards_eth[msg.sender];
446         _staking_savedRewards_eth[msg.sender] = 0;
447         if(rewards_eth > 0)
448             msg.sender.transfer(rewards_eth);
449     }
450     
451     //leverage stake by purchasing a multiplier. returns will be used to further develop the BOMB3D ecosystem
452     function buyStakingMultiplier () public payable returns (bool)
453     {
454         uint256 cost = getNextStakingMultiplierCost(msg.sender);
455         require(cost > 0 && msg.value == cost);
456         
457         //calculate staking rewards
458         uint256 stakingReward = cost.div(2);
459         uint256 effectiveAmountStaked = totalAmountStaked_effective();
460         //split up to rewards per unit in stake
461         uint256 rewardsPerUnit = stakingReward.div(effectiveAmountStaked);
462         //apply rewards
463         _staking_totalRewardsPerUnit_eth = _staking_totalRewardsPerUnit_eth.add(rewardsPerUnit);
464         
465         //again, prevent leaving any dust in the contract
466         uint256 actualRewardsCreated = rewardsPerUnit.mul(effectiveAmountStaked);
467         uint256 pocketmoney = cost.sub(actualRewardsCreated);
468         admin.transfer(pocketmoney);
469         
470         updateRewardsFor(msg.sender);
471         
472         totalAmountStaked_wMultipliers = totalAmountStaked_wMultipliers.sub(_stakedBalances_wMultiplier[msg.sender]);
473         
474         uint256 nextStakingMultiplier = getNextStakingMultiplier(msg.sender);
475         _stakingMultipliers[msg.sender] = nextStakingMultiplier;
476         
477         _stakedBalances_wMultiplier[msg.sender] = _stakedBalances[msg.sender].mul(nextStakingMultiplier) ;
478         totalAmountStaked_wMultipliers = totalAmountStaked_wMultipliers.add(_stakedBalances_wMultiplier[msg.sender]);
479 
480         return true;
481     }
482     
483     function getCurrentStakingMultiplier(address stakerAddress) public view returns (uint256)
484     {
485         uint256 currentMultiplier = _stakingMultipliers[stakerAddress];
486         if(currentMultiplier == 0)
487             return 1;
488         return currentMultiplier;
489     }
490     
491     //defines staking multiplier tiers and returns next tier accordingly
492     function getNextStakingMultiplier(address stakerAddress) public view returns (uint256)
493     {
494         uint256 currentMultiplier = getCurrentStakingMultiplier(stakerAddress);
495         if(currentMultiplier == 1)
496             return 2;
497         if(currentMultiplier == 2)
498             return 3;
499         if(currentMultiplier == 3)
500             return 5;
501         return 10;
502     }
503     
504     //computes next tier price as: price = multiplier value * 0.1eth
505     function getNextStakingMultiplierCost(address stakerAddress) public view returns (uint256)
506     {
507         if(getCurrentStakingMultiplier(stakerAddress) == getNextStakingMultiplier(stakerAddress))
508             return 0;
509         return getNextStakingMultiplier(stakerAddress).mul(10 ** 17);
510     }
511     
512     
513     // ------------------------------------------------------------------------
514     //HELPERS
515     // ------------------------------------------------------------------------
516     
517     function findOnePercent(uint256 value) public pure returns (uint256)  
518     {
519         uint256 roundValue = value.ceil(100);
520         uint256 onePercent = roundValue.mul(100).div(10000);
521         return onePercent;
522     }
523     
524     function appendDecimals(uint256 value_unwrapped) public pure returns (uint256)
525     {
526         return value_unwrapped.mul(10**uint256(tokenDecimals));
527     }
528     
529 }