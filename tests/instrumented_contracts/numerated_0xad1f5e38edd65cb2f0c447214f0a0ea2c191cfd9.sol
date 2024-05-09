1 /*
2  * A highly limited supply utility token of Gear Protocol
3  * 
4  *  Official Website: 
5  *  https://www.GearProtocol.com
6  */
7 
8 
9 
10 pragma solidity ^0.4.25;
11 
12 interface IERC20 
13 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address who) external view returns (uint256);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function transfer(address to, uint256 value) external returns (bool);
18     function approve(address spender, uint256 value) external returns (bool);
19     function transferFrom(address from, address to, uint256 value) external returns (bool);
20     
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 interface ApproveAndCallFallBack 
26 {
27     function receiveApproval(address from, uint256 tokens, address token, bytes data) external;
28 }
29 
30 
31 library SafeMath 
32 {
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) 
34     {
35         if (a == 0) 
36         {
37             return 0;
38         }
39         uint256 c = a * b;
40         assert(c / a == b);
41         return c;
42     }
43     
44     function div(uint256 a, uint256 b) internal pure returns (uint256) 
45     {
46         uint256 c = a / b;
47         return c;
48     }
49     
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) 
51     {
52         assert(b <= a);
53         return a - b;
54     }
55     
56     function add(uint256 a, uint256 b) internal pure returns (uint256) 
57     {
58         uint256 c = a + b;
59         assert(c >= a);
60         return c;
61     }
62     
63     function ceil(uint256 a, uint256 m) internal pure returns (uint256) 
64     {
65         uint256 c = add(a,m);
66         uint256 d = sub(c,1);
67         return mul(div(d,m),m);
68     }
69 }
70 
71 contract ERC20Detailed is IERC20 
72 {
73     string private _name;
74     string private _symbol;
75     uint8 private _decimals;
76     
77     constructor(string memory name, string memory symbol, uint8 decimals) public {
78         _name = name;
79         _symbol = symbol;
80         _decimals = decimals;
81     }
82     
83     function name() public view returns(string memory) {
84         return _name;
85     }
86     
87     function symbol() public view returns(string memory) {
88         return _symbol;
89     }
90     
91     function decimals() public view returns(uint8) {
92         return _decimals;
93     }
94 }
95 
96 contract GearAutomatic is ERC20Detailed 
97 {
98     using SafeMath for uint256;
99     
100     mapping (address => uint256) private balances;
101     mapping (address => mapping (address => uint256)) private allowed;
102     
103     string constant tokenName = "GearAutomatic";
104     string constant tokenSymbol = "AUTO"; 
105     uint8  constant tokenDecimals = 18;
106     uint256 _totalSupply = 0;
107   
108     address public contractOwner;
109 
110     uint256 public fullUnitsFarmed_total = 0;
111     uint256 public totalFarmers = 0;
112     mapping (address => bool) public isFarming;
113 
114     uint256 _totalRewardsPerUnit = 0;
115     mapping (address => uint256) private _totalRewardsPerUnit_positions;
116     mapping (address => uint256) private _savedRewards;
117     
118     //these addresses won't be affected by network fee,ie liquidity pools
119     mapping(address => bool) public whitelistFrom;
120     mapping(address => bool) public whitelistTo;
121     event WhitelistFrom(address _addr, bool _whitelisted);
122     event WhitelistTo(address _addr, bool _whitelisted);
123     
124     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
125     {
126         contractOwner = msg.sender;
127         _supply(msg.sender, 10000*(10**uint256(tokenDecimals)));
128     }
129     
130     modifier onlyOwner() {
131         require(msg.sender == contractOwner, "only owner");
132         _;
133     }
134     
135     function totalSupply() public view returns (uint256) 
136     {
137         return _totalSupply;
138     }
139     
140     function balanceOf(address owner) public view returns (uint256) 
141     {
142         return balances[owner];
143     }
144     
145     function fullUnitsFarmed(address owner) external view returns (uint256) 
146     {
147         return isFarming[owner] ? toFullUnits(balances[owner]) : 0;
148     }
149     
150     function toFullUnits(uint256 valueWithDecimals) public pure returns (uint256) 
151     {
152         return valueWithDecimals.div(10**uint256(tokenDecimals));
153     }
154     
155     function allowance(address owner, address spender) public view returns (uint256) 
156     {
157         return allowed[owner][spender];
158     }
159     
160     function transfer(address to, uint256 value) public returns (bool) 
161     {
162         _executeTransfer(msg.sender, to, value);
163         return true;
164     }
165     
166     function multiTransfer(address[] memory receivers, uint256[] memory values) public
167     {
168         require(receivers.length == values.length);
169         for(uint256 i = 0; i < receivers.length; i++)
170             _executeTransfer(msg.sender, receivers[i], values[i]);
171     }
172     
173     function transferFrom(address from, address to, uint256 value) public returns (bool) 
174     {
175         require(value <= allowed[from][msg.sender]);
176         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
177         _executeTransfer(from, to, value);
178         return true;
179     }
180     
181     function approve(address spender, uint256 value) public returns (bool) 
182     {
183         require(spender != address(0));
184         allowed[msg.sender][spender] = value;
185         emit Approval(msg.sender, spender, value);
186         return true;
187     }
188     
189     
190     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
191         allowed[msg.sender][spender] = tokens;
192         emit Approval(msg.sender, spender, tokens);
193         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
194         return true;
195     }
196     
197     
198     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
199     {
200         require(spender != address(0));
201         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
202         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
203         return true;
204     }
205     
206     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
207     {
208         require(spender != address(0));
209         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
210         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
211         return true;
212     }
213     
214     function _supply(address account, uint256 value) internal onlyOwner
215     {
216         require(value != 0);
217         
218         uint256 initalBalance = balances[account];
219         uint256 newBalance = initalBalance.add(value);
220         
221         balances[account] = newBalance;
222         _totalSupply = _totalSupply.add(value);
223         
224         emit Transfer(address(0), account, value);
225     }
226     
227     function burn(uint256 value) external 
228     {
229         _burn(msg.sender, value);
230     }
231     
232 
233     function _burn(address account, uint256 value) internal 
234     {
235         require(value != 0);
236         require(value <= balances[account]);
237         
238         uint256 initalBalance = balances[account];
239         uint256 newBalance = initalBalance.sub(value);
240         
241         balances[account] = newBalance;
242         _totalSupply = _totalSupply.sub(value);
243         
244         //update full units farmed
245         if(isFarming[account])
246         {
247             uint256 fus_total = fullUnitsFarmed_total;
248             fus_total = fus_total.sub(toFullUnits(initalBalance));
249             fus_total = fus_total.add(toFullUnits(newBalance));
250             fullUnitsFarmed_total = fus_total;
251         }
252         
253         emit Transfer(account, address(0), value);
254     }
255     
256     /*
257     *   transfer incurring a fee of 5%
258     *   the receiver gets 95% of the sent value
259     *   5% is distributed to AUTO farming pool
260     */
261     function _executeTransfer(address from, address to, uint256 value) private
262     {
263         require(value <= balances[from]);
264         require(to != address(0) && to != from);
265         require(to != address(this));
266         
267         
268         //Update sender and receivers rewards - changing balances will change rewards shares
269         updateRewardsFor(from);
270         updateRewardsFor(to);
271         
272         uint256 fivePercent = 0;
273         
274         if(!whitelistFrom[from] && !whitelistTo[to])
275         {
276             fivePercent = value.mul(5).div(100);
277             
278             
279             //set a minimum  rate to prevent no-fee-txs due to precision loss
280             if(fivePercent == 0 && value > 0)
281                 fivePercent = 1;
282         }
283             
284         uint256 initalBalance_from = balances[from];
285         balances[from] = initalBalance_from.sub(value);
286         
287         value = value.sub(fivePercent);
288         
289         uint256 initalBalance_to = balances[to];
290         balances[to] = initalBalance_to.add(value);
291         
292         emit Transfer(from, to, value);
293          
294         //update full units farmed
295         uint256 fus_total = fullUnitsFarmed_total;
296         if(isFarming[from])
297         {
298             fus_total = fus_total.sub(toFullUnits(initalBalance_from));
299             fus_total = fus_total.add(toFullUnits(balances[from]));
300         }
301         if(isFarming[to])
302         {
303             fus_total = fus_total.sub(toFullUnits(initalBalance_to));
304             fus_total = fus_total.add(toFullUnits(balances[to]));
305         }
306         
307         if(isFarming[from] && balances[from] < 1)
308         {
309              updateRewardsFor(from);
310              isFarming[from] = false;
311              fullUnitsFarmed_total = fullUnitsFarmed_total.sub(toFullUnits(balances[from]));
312              totalFarmers = totalFarmers.sub(1); 
313         }
314         
315         
316         fullUnitsFarmed_total = fus_total;
317         
318         if(fus_total > 0)
319         {
320             uint256 farmingRewards = fivePercent;
321             //split up to rewards per unit in farm
322             uint256 rewardsPerUnit = farmingRewards.div(fus_total);
323             //apply reward
324             _totalRewardsPerUnit = _totalRewardsPerUnit.add(rewardsPerUnit);
325             balances[address(this)] = balances[address(this)].add(farmingRewards);
326             if(farmingRewards > 0)
327                 emit Transfer(msg.sender, address(this), farmingRewards);
328         }
329         
330     }
331     
332     //catch up with the current total harvest rewards. This needs to be done before an addresses balance is changed
333     function updateRewardsFor(address farmer) private
334     {
335         _savedRewards[farmer] = viewHarvest(farmer);
336         _totalRewardsPerUnit_positions[farmer] = _totalRewardsPerUnit;
337     }
338     
339     //get all harvest rewards that have not been claimed yet
340     function viewHarvest(address farmer) public view returns (uint256)
341     {
342         if(!isFarming[farmer])
343             return _savedRewards[farmer];
344         uint256 newRewardsPerUnit = _totalRewardsPerUnit.sub(_totalRewardsPerUnit_positions[farmer]);
345         
346         uint256 newRewards = newRewardsPerUnit.mul(toFullUnits(balances[farmer]));
347         return _savedRewards[farmer].add(newRewards);
348     }
349     
350     //pay out unclaimed harvest rewards
351     function harvest() public
352     {
353         updateRewardsFor(msg.sender);
354         uint256 rewards = _savedRewards[msg.sender];
355         require(rewards > 0 && rewards <= balances[address(this)]);
356         
357         _savedRewards[msg.sender] = 0;
358         
359          uint256 fivePercent = 0;
360          uint256 reward = 0;
361         
362         fivePercent = rewards.mul(5).div(100);
363         
364        //set a minimum  rate to prevent no harvest-fee-txs due to precision loss
365             if(fivePercent == 0 && rewards > 0) {
366                 fivePercent = 1;
367         }
368         
369         reward = rewards.sub(fivePercent);
370         
371         uint256 initalBalance_farmer = balances[msg.sender];
372         uint256 newBalance_farmer = initalBalance_farmer.add(reward);
373         
374         //update full units farmed
375         if(isFarming[msg.sender])
376         {
377             uint256 fus_total = fullUnitsFarmed_total;
378             fus_total = fus_total.sub(toFullUnits(initalBalance_farmer));
379             fus_total = fus_total.add(toFullUnits(newBalance_farmer));
380             fullUnitsFarmed_total = fus_total;
381         }
382         
383         //transfer
384         balances[address(this)] = balances[address(this)].sub(rewards);
385         balances[msg.sender] = newBalance_farmer;
386         balances[contractOwner] = balances[contractOwner].add(fivePercent);
387         emit Transfer(address(this), msg.sender, rewards);
388         emit Transfer(address(this), contractOwner, fivePercent);
389     }
390     
391     function enableFarming() public { _enableFarming(msg.sender);  }
392     
393     function disableFarming() public { _disableFarming(msg.sender); }
394     
395     function enableFarmingFor(address farmer) public onlyOwner { _enableFarming(farmer); }
396     
397     function disableFarmingFor(address farmer) public onlyOwner { _disableFarming(farmer); }
398     
399     //enable farming for target address
400     function _enableFarming(address farmer) private
401     {
402         require(!isFarming[farmer]);
403         updateRewardsFor(farmer);
404         isFarming[farmer] = true;
405         fullUnitsFarmed_total = fullUnitsFarmed_total.add(toFullUnits(balances[farmer]));
406         totalFarmers = totalFarmers.add(1);
407     }
408     
409     //disable farming for target address
410     function _disableFarming(address farmer) private
411     {
412         require(isFarming[farmer]);
413         updateRewardsFor(farmer);
414         isFarming[farmer] = false;
415         fullUnitsFarmed_total = fullUnitsFarmed_total.sub(toFullUnits(balances[farmer]));
416         totalFarmers = totalFarmers.sub(1);
417     }
418     
419     //withdraw tokens that were sent to this contract by accident
420     function withdrawERC20Tokens(address tokenAddress, uint256 amount) public onlyOwner
421     {
422         require(tokenAddress != address(this));
423         IERC20(tokenAddress).transfer(msg.sender, amount);
424     }
425     
426     //no fees if receiver is whitelisted
427     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
428         emit WhitelistTo(_addr, _whitelisted);
429         whitelistTo[_addr] = _whitelisted;
430     }
431 
432     //no fees if sender is whitelisted
433     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
434         emit WhitelistFrom(_addr, _whitelisted);
435         whitelistFrom[_addr] = _whitelisted;
436     }
437     
438 }