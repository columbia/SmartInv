1 pragma solidity 0.5.8;
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
16 contract ApproveAndCallFallBack 
17 {
18     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public returns (bool);
19 }
20 
21 contract TransferAndCallFallBack 
22 {
23     function receiveToken(address from, uint256 tokens, address token, bytes memory data) public returns (bool);
24 }
25 
26 library SafeMath 
27 {
28     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
29     {
30         if (a == 0) 
31         {
32             return 0;
33         }
34         uint256 c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38     
39     function div(uint256 a, uint256 b) internal pure returns (uint256) 
40     {
41         uint256 c = a / b;
42         return c;
43     }
44     
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
46     {
47         assert(b <= a);
48         return a - b;
49     }
50     
51     function add(uint256 a, uint256 b) internal pure returns (uint256) 
52     {
53         uint256 c = a + b;
54         assert(c >= a);
55         return c;
56     }
57     
58     function ceil(uint256 a, uint256 m) internal pure returns (uint256) 
59     {
60         uint256 c = add(a,m);
61         uint256 d = sub(c,1);
62         return mul(div(d,m),m);
63     }
64 }
65 
66 contract ERC20Detailed is IERC20 
67 {
68     string private _name;
69     string private _symbol;
70     uint8 private _decimals;
71     
72     constructor(string memory name, string memory symbol, uint8 decimals) public {
73         _name = name;
74         _symbol = symbol;
75         _decimals = decimals;
76     }
77     
78     function name() public view returns(string memory) {
79         return _name;
80     }
81     
82     function symbol() public view returns(string memory) {
83         return _symbol;
84     }
85     
86     function decimals() public view returns(uint8) {
87         return _decimals;
88     }
89 }
90 
91 contract AfterShockV2 is ERC20Detailed 
92 {
93     using SafeMath for uint256;
94     
95     mapping (address => uint256) private _balances;
96     mapping (address => mapping (address => uint256)) private _allowed;
97     
98     string constant tokenName = "AfterShock V2";//"AfterShock V2";
99     string constant tokenSymbol = "SHOCK";//"SHOCK"; 
100     uint8  constant tokenDecimals = 18;
101     uint256 _totalSupply = 0;
102     
103     // ------------------------------------------------------------------------
104   
105     address public contractOwner;
106 
107     uint256 public fullUnitsStaked_total = 0;
108     mapping (address => bool) public isStaking;
109 
110     uint256 _totalRewardsPerUnit = 0;
111     mapping (address => uint256) private _totalRewardsPerUnit_positions;
112     mapping (address => uint256) private _savedRewards;
113     
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115     
116     // v2 ------------------------------------------------------------------------
117     
118     bool public migrationActive = true;
119     
120     //these addresses won't be affected by burn,ie liquidity pools
121     mapping(address => bool) public whitelistFrom;
122     mapping(address => bool) public whitelistTo;
123     event WhitelistFrom(address _addr, bool _whitelisted);
124     event WhitelistTo(address _addr, bool _whitelisted);
125 
126     // ------------------------------------------------------------------------
127     
128     constructor() public ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
129     {
130         contractOwner = msg.sender;
131     }
132     
133     // ------------------------------------------------------------------------
134 
135     modifier onlyOwner() {
136         require(msg.sender == contractOwner, "only owner");
137         _;
138     }
139     
140     function transferOwnership(address newOwner) public 
141     {
142         require(msg.sender == contractOwner);
143         require(newOwner != address(0));
144         emit OwnershipTransferred(contractOwner, newOwner);
145         contractOwner = newOwner;
146     }
147     
148     function totalSupply() public view returns (uint256) 
149     {
150         return _totalSupply;
151     }
152     
153     function balanceOf(address owner) public view returns (uint256) 
154     {
155         return _balances[owner];
156     }
157     
158     function fullUnitsStaked(address owner) external view returns (uint256) 
159     {
160         return isStaking[owner] ? toFullUnits(_balances[owner]) : 0;
161     }
162     
163     function toFullUnits(uint256 valueWithDecimals) public pure returns (uint256) 
164     {
165         return valueWithDecimals.div(10**uint256(tokenDecimals));
166     }
167     
168     function allowance(address owner, address spender) public view returns (uint256) 
169     {
170         return _allowed[owner][spender];
171     }
172     
173     function transfer(address to, uint256 value) public returns (bool) 
174     {
175         _executeTransfer(msg.sender, to, value);
176         return true;
177     }
178     
179     function transferAndCall(address to, uint value, bytes memory data) public returns (bool) 
180     {
181         require(transfer(to, value));
182         require(TransferAndCallFallBack(to).receiveToken(msg.sender, value, address(this), data));
183         return true;
184     }
185     
186     function multiTransfer(address[] memory receivers, uint256[] memory values) public
187     {
188         require(receivers.length == values.length);
189         for(uint256 i = 0; i < receivers.length; i++)
190             _executeTransfer(msg.sender, receivers[i], values[i]);
191     }
192     
193     function transferFrom(address from, address to, uint256 value) public returns (bool) 
194     {
195         require(value <= _allowed[from][msg.sender]);
196         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
197         _executeTransfer(from, to, value);
198         return true;
199     }
200     
201     function transferFromAndCall(address from, address to, uint value, bytes memory data) public returns (bool) 
202     {
203         require(transferFrom(from, to, value));
204         require(TransferAndCallFallBack(to).receiveToken(from, value, address(this), data));
205         return true;
206     }
207     
208     function approve(address spender, uint256 value) public returns (bool) 
209     {
210         require(spender != address(0));
211         _allowed[msg.sender][spender] = value;
212         emit Approval(msg.sender, spender, value);
213         return true;
214     }
215     
216     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) 
217     {
218         require(approve(spender, tokens));
219         require(ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data));
220         return true;
221     }
222     
223     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
224     {
225         require(spender != address(0));
226         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));
227         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
228         return true;
229     }
230     
231     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
232     {
233         require(spender != address(0));
234         _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].sub(subtractedValue));
235         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
236         return true;
237     }
238     
239     function _mint(address account, uint256 value) internal 
240     {
241         require(value != 0);
242         
243         uint256 initalBalance = _balances[account];
244         uint256 newBalance = initalBalance.add(value);
245         
246         _balances[account] = newBalance;
247         _totalSupply = _totalSupply.add(value);
248         
249         //update full units staked
250         if(isStaking[account])
251         {
252             uint256 fus_total = fullUnitsStaked_total;
253             fus_total = fus_total.sub(toFullUnits(initalBalance));
254             fus_total = fus_total.add(toFullUnits(newBalance));
255             fullUnitsStaked_total = fus_total;
256         }
257         emit Transfer(address(0), account, value);
258     }
259     
260     function burn(uint256 value) external 
261     {
262         _burn(msg.sender, value);
263     }
264     
265     function burnFrom(address account, uint256 value) external 
266     {
267         require(value <= _allowed[account][msg.sender]);
268         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
269         _burn(account, value);
270     }
271     
272     function _burn(address account, uint256 value) internal 
273     {
274         require(value != 0);
275         require(value <= _balances[account]);
276         
277         uint256 initalBalance = _balances[account];
278         uint256 newBalance = initalBalance.sub(value);
279         
280         _balances[account] = newBalance;
281         _totalSupply = _totalSupply.sub(value);
282         
283         //update full units staked
284         if(isStaking[account])
285         {
286             uint256 fus_total = fullUnitsStaked_total;
287             fus_total = fus_total.sub(toFullUnits(initalBalance));
288             fus_total = fus_total.add(toFullUnits(newBalance));
289             fullUnitsStaked_total = fus_total;
290         }
291         
292         emit Transfer(account, address(0), value);
293     }
294     
295     /*
296     *   transfer with additional burn and stake rewards
297     *   the receiver gets 94% of the sent value
298     *   6% are split to be burnt and distributed to holders
299     */
300     function _executeTransfer(address from, address to, uint256 value) private
301     {
302         require(value <= _balances[from]);
303         require(to != address(0) && to != address(this));
304         
305         //Update sender and receivers rewards - changing balances will change rewards shares
306         updateRewardsFor(from);
307         updateRewardsFor(to);
308         
309         uint256 sixPercent = 0;
310         if(!whitelistFrom[from] && !whitelistTo[to])
311         {
312             sixPercent = value.mul(6).div(100);
313             //set a minimum burn rate to prevent no-burn-txs due to precision loss
314             if(sixPercent == 0 && value > 0)
315                 sixPercent = 1;
316         }
317             
318         uint256 initalBalance_from = _balances[from];
319         uint256 newBalance_from = initalBalance_from.sub(value);
320         
321         value = value.sub(sixPercent);
322         
323         uint256 initalBalance_to = from != to ? _balances[to] : newBalance_from;
324         uint256 newBalance_to = initalBalance_to.add(value);
325         
326         //transfer
327         _balances[from] = newBalance_from;
328         _balances[to] = newBalance_to;
329         emit Transfer(from, to, value);
330          
331         //update full units staked
332         uint256 fus_total = fullUnitsStaked_total;
333         if(isStaking[from])
334         {
335             fus_total = fus_total.sub(toFullUnits(initalBalance_from));
336             fus_total = fus_total.add(toFullUnits(newBalance_from));
337         }
338         if(isStaking[to])
339         {
340             fus_total = fus_total.sub(toFullUnits(initalBalance_to));
341             fus_total = fus_total.add(toFullUnits(newBalance_to));
342         }
343         fullUnitsStaked_total = fus_total;
344         
345         uint256 amountToBurn = sixPercent;
346         
347         if(fus_total > 0)
348         {
349             uint256 stakingRewards = sixPercent.div(2);
350             //split up to rewards per unit in stake
351             uint256 rewardsPerUnit = stakingRewards.div(fus_total);
352             //apply rewards
353             _totalRewardsPerUnit = _totalRewardsPerUnit.add(rewardsPerUnit);
354             _balances[address(this)] = _balances[address(this)].add(stakingRewards);
355             if(stakingRewards > 0)
356                 emit Transfer(msg.sender, address(this), stakingRewards);
357             amountToBurn = amountToBurn.sub(stakingRewards);
358         }
359         
360         //update total supply
361         _totalSupply = _totalSupply.sub(amountToBurn);
362         if(amountToBurn > 0)
363             emit Transfer(msg.sender, address(0), amountToBurn);
364     }
365     
366     //catch up with the current total rewards. This needs to be done before an addresses balance is changed
367     function updateRewardsFor(address staker) private
368     {
369         _savedRewards[staker] = viewUnpaidRewards(staker);
370         _totalRewardsPerUnit_positions[staker] = _totalRewardsPerUnit;
371     }
372     
373     //get all rewards that have not been claimed yet
374     function viewUnpaidRewards(address staker) public view returns (uint256)
375     {
376         if(!isStaking[staker])
377             return _savedRewards[staker];
378         uint256 newRewardsPerUnit = _totalRewardsPerUnit.sub(_totalRewardsPerUnit_positions[staker]);
379         
380         uint256 newRewards = newRewardsPerUnit.mul(toFullUnits(_balances[staker]));
381         return _savedRewards[staker].add(newRewards);
382     }
383     
384     //pay out unclaimed rewards
385     function payoutRewards() public
386     {
387         updateRewardsFor(msg.sender);
388         uint256 rewards = _savedRewards[msg.sender];
389         require(rewards > 0 && rewards <= _balances[address(this)]);
390         
391         _savedRewards[msg.sender] = 0;
392         
393         uint256 initalBalance_staker = _balances[msg.sender];
394         uint256 newBalance_staker = initalBalance_staker.add(rewards);
395         
396         //update full units staked
397         if(isStaking[msg.sender])
398         {
399             uint256 fus_total = fullUnitsStaked_total;
400             fus_total = fus_total.sub(toFullUnits(initalBalance_staker));
401             fus_total = fus_total.add(toFullUnits(newBalance_staker));
402             fullUnitsStaked_total = fus_total;
403         }
404         
405         //transfer
406         _balances[address(this)] = _balances[address(this)].sub(rewards);
407         _balances[msg.sender] = newBalance_staker;
408         emit Transfer(address(this), msg.sender, rewards);
409     }
410     
411     function enableStaking() public { _enableStaking(msg.sender);  }
412     function disableStaking() public { _disableStaking(msg.sender); }
413     
414     function enableStakingFor(address staker) public onlyOwner { _enableStaking(staker); }
415     function disableStakingFor(address staker) public onlyOwner { _disableStaking(staker); }
416     
417     //enable staking for target address
418     function _enableStaking(address staker) private
419     {
420         require(!isStaking[staker]);
421         updateRewardsFor(staker);
422         isStaking[staker] = true;
423         fullUnitsStaked_total = fullUnitsStaked_total.add(toFullUnits(_balances[staker]));
424     }
425     
426     //disable staking for target address
427     function _disableStaking(address staker) private
428     {
429         require(isStaking[staker]);
430         updateRewardsFor(staker);
431         isStaking[staker] = false;
432         fullUnitsStaked_total = fullUnitsStaked_total.sub(toFullUnits(_balances[staker]));
433     }
434     
435     //withdraw tokens that were sent to this contract by accident
436     function withdrawERC20Tokens(address tokenAddress, uint256 amount) public onlyOwner
437     {
438         require(tokenAddress != address(this));
439         IERC20(tokenAddress).transfer(msg.sender, amount);
440     }
441     
442     //no fees if receiver is whitelisted
443     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
444         emit WhitelistTo(_addr, _whitelisted);
445         whitelistTo[_addr] = _whitelisted;
446     }
447 
448     //no fees if sender is whitelisted
449     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
450         emit WhitelistFrom(_addr, _whitelisted);
451         whitelistFrom[_addr] = _whitelisted;
452     }
453     
454     //migrate a list of balances
455     function multiMigrateBalance(address[] memory receivers, uint256[] memory values) public
456     {
457         require(receivers.length == values.length);
458         for(uint256 i = 0; i < receivers.length; i++)
459             migrateBalance(receivers[i], values[i]);
460     }
461     
462     //mint balance to a give address, only works as long as migrationmode is active
463     function migrateBalance(address account, uint256 amount) public onlyOwner
464     {
465         require(migrationActive);
466         _mint(account, amount);
467     }
468     
469     //this will stop migration mode permanently
470     function endMigration() public onlyOwner
471     {
472         migrationActive = false;
473     }
474     
475 }