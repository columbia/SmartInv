1 /*
2  * An Autonomous DeFi Governance System
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
96 contract GearProtocolv2 is ERC20Detailed 
97 {
98     using SafeMath for uint256;
99     
100     mapping (address => uint256) private balances;
101     mapping (address => mapping (address => uint256)) private allowed;
102     
103     string constant tokenName = "GearProtocol v2";
104     string constant tokenSymbol = "GEAR"; 
105     uint8  constant tokenDecimals = 18;
106     uint256 _totalSupply = 0;
107   
108     address public contractOwner;
109 
110     uint256 public fullUnitsFarmed_total = 0;
111     mapping (address => bool) public isFarming;
112 
113     uint256 _totalRewardsPerUnit = 0;
114     mapping (address => uint256) private _totalRewardsPerUnit_positions;
115     mapping (address => uint256) private _savedRewards;
116     
117     //these addresses won't be affected by network fee,ie liquidity pools
118     mapping(address => bool) public whitelistFrom;
119     mapping(address => bool) public whitelistTo;
120     event WhitelistFrom(address _addr, bool _whitelisted);
121     event WhitelistTo(address _addr, bool _whitelisted);
122     
123     constructor() public payable ERC20Detailed(tokenName, tokenSymbol, tokenDecimals) 
124     {
125         contractOwner = msg.sender;
126         _supply(msg.sender, 1000000*(10**uint256(tokenDecimals)));
127     }
128     
129     modifier onlyOwner() {
130         require(msg.sender == contractOwner, "only owner");
131         _;
132     }
133     
134     function totalSupply() public view returns (uint256) 
135     {
136         return _totalSupply;
137     }
138     
139     function balanceOf(address owner) public view returns (uint256) 
140     {
141         return balances[owner];
142     }
143     
144     function fullUnitsFarmed(address owner) external view returns (uint256) 
145     {
146         return isFarming[owner] ? toFullUnits(balances[owner]) : 0;
147     }
148     
149     function toFullUnits(uint256 valueWithDecimals) public pure returns (uint256) 
150     {
151         return valueWithDecimals.div(10**uint256(tokenDecimals));
152     }
153     
154     function allowance(address owner, address spender) public view returns (uint256) 
155     {
156         return allowed[owner][spender];
157     }
158     
159     function transfer(address to, uint256 value) public returns (bool) 
160     {
161         _executeTransfer(msg.sender, to, value);
162         return true;
163     }
164     
165     function multiTransfer(address[] memory receivers, uint256[] memory values) public
166     {
167         require(receivers.length == values.length);
168         for(uint256 i = 0; i < receivers.length; i++)
169             _executeTransfer(msg.sender, receivers[i], values[i]);
170     }
171     
172     function transferFrom(address from, address to, uint256 value) public returns (bool) 
173     {
174         require(value <= allowed[from][msg.sender]);
175         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
176         _executeTransfer(from, to, value);
177         return true;
178     }
179     
180     function approve(address spender, uint256 value) public returns (bool) 
181     {
182         require(spender != address(0));
183         allowed[msg.sender][spender] = value;
184         emit Approval(msg.sender, spender, value);
185         return true;
186     }
187     
188     
189     function approveAndCall(address spender, uint256 tokens, bytes data) external returns (bool) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
193         return true;
194     }
195     
196     
197     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) 
198     {
199         require(spender != address(0));
200         allowed[msg.sender][spender] = (allowed[msg.sender][spender].add(addedValue));
201         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
202         return true;
203     }
204     
205     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) 
206     {
207         require(spender != address(0));
208         allowed[msg.sender][spender] = (allowed[msg.sender][spender].sub(subtractedValue));
209         emit Approval(msg.sender, spender, allowed[msg.sender][spender]);
210         return true;
211     }
212     
213     function _supply(address account, uint256 value) internal onlyOwner
214     {
215         require(value != 0);
216         
217         uint256 initalBalance = balances[account];
218         uint256 newBalance = initalBalance.add(value);
219         
220         balances[account] = newBalance;
221         _totalSupply = _totalSupply.add(value);
222         
223         emit Transfer(address(0), account, value);
224     }
225     
226     function burn(uint256 value) external 
227     {
228         _burn(msg.sender, value);
229     }
230     
231 
232     function _burn(address account, uint256 value) internal 
233     {
234         require(value != 0);
235         require(value <= balances[account]);
236         
237         uint256 initalBalance = balances[account];
238         uint256 newBalance = initalBalance.sub(value);
239         
240         balances[account] = newBalance;
241         _totalSupply = _totalSupply.sub(value);
242         
243         //update full units farmed
244         if(isFarming[account])
245         {
246             uint256 fus_total = fullUnitsFarmed_total;
247             fus_total = fus_total.sub(toFullUnits(initalBalance));
248             fus_total = fus_total.add(toFullUnits(newBalance));
249             fullUnitsFarmed_total = fus_total;
250         }
251         
252         emit Transfer(account, address(0), value);
253     }
254     
255     /*
256     *   transfer incurring a feee of 3%
257     *   the receiver gets 97% of the sent value
258     *   3% is distributed to GEAR farming pool
259     */
260     function _executeTransfer(address from, address to, uint256 value) private
261     {
262         require(value <= balances[from]);
263         require(to != address(0) && to != from);
264         require(to != address(this));
265         
266         
267         //Update sender and receivers rewards - changing balances will change rewards shares
268         updateRewardsFor(from);
269         updateRewardsFor(to);
270         
271         uint256 threePercent = 0;
272         
273         if(!whitelistFrom[from] && !whitelistTo[to])
274         {
275             threePercent = value.mul(3).div(100);
276             
277             
278             //set a minimum  rate to prevent no-fee-txs due to precision loss
279             if(threePercent == 0 && value > 0)
280                 threePercent = 1;
281         }
282             
283         uint256 initalBalance_from = balances[from];
284         balances[from] = initalBalance_from.sub(value);
285         
286         value = value.sub(threePercent);
287         
288         uint256 initalBalance_to = balances[to];
289         balances[to] = initalBalance_to.add(value);
290         
291         emit Transfer(from, to, value);
292          
293         //update full units farmed
294         uint256 fus_total = fullUnitsFarmed_total;
295         if(isFarming[from])
296         {
297             fus_total = fus_total.sub(toFullUnits(initalBalance_from));
298             fus_total = fus_total.add(toFullUnits(balances[from]));
299         }
300         if(isFarming[to])
301         {
302             fus_total = fus_total.sub(toFullUnits(initalBalance_to));
303             fus_total = fus_total.add(toFullUnits(balances[to]));
304         }
305         fullUnitsFarmed_total = fus_total;
306         
307         
308         if(fus_total > 0)
309         {
310             uint256 farmingRewards = threePercent;
311             //split up to rewards per unit in farm
312             uint256 rewardsPerUnit = farmingRewards.div(fus_total);
313             //apply reward
314             _totalRewardsPerUnit = _totalRewardsPerUnit.add(rewardsPerUnit);
315             balances[address(this)] = balances[address(this)].add(farmingRewards);
316             if(farmingRewards > 0)
317                 emit Transfer(msg.sender, address(this), farmingRewards);
318         }
319         
320     }
321     
322     //catch up with the current total harvest rewards. This needs to be done before an addresses balance is changed
323     function updateRewardsFor(address farmer) private
324     {
325         _savedRewards[farmer] = viewHarvest(farmer);
326         _totalRewardsPerUnit_positions[farmer] = _totalRewardsPerUnit;
327     }
328     
329     //get all harvest rewards that have not been claimed yet
330     function viewHarvest(address farmer) public view returns (uint256)
331     {
332         if(!isFarming[farmer])
333             return _savedRewards[farmer];
334         uint256 newRewardsPerUnit = _totalRewardsPerUnit.sub(_totalRewardsPerUnit_positions[farmer]);
335         
336         uint256 newRewards = newRewardsPerUnit.mul(toFullUnits(balances[farmer]));
337         return _savedRewards[farmer].add(newRewards);
338     }
339     
340     //pay out unclaimed harvest rewards
341     function harvest() public
342     {
343         updateRewardsFor(msg.sender);
344         uint256 rewards = _savedRewards[msg.sender];
345         require(rewards > 0 && rewards <= balances[address(this)]);
346         
347         _savedRewards[msg.sender] = 0;
348         
349          uint256 onePercent = 0;
350          uint256 reward = 0;
351         
352         onePercent = rewards.mul(1).div(100);
353         
354        //set a minimum  rate to prevent no harvest-fee-txs due to precision loss
355             if(onePercent == 0 && rewards > 0) {
356                 onePercent = 1;
357         }
358         
359         reward = rewards.sub(onePercent);
360         
361         uint256 initalBalance_farmer = balances[msg.sender];
362         uint256 newBalance_farmer = initalBalance_farmer.add(reward);
363         
364         //update full units farmed
365         if(isFarming[msg.sender])
366         {
367             uint256 fus_total = fullUnitsFarmed_total;
368             fus_total = fus_total.sub(toFullUnits(initalBalance_farmer));
369             fus_total = fus_total.add(toFullUnits(newBalance_farmer));
370             fullUnitsFarmed_total = fus_total;
371         }
372         
373         //transfer
374         balances[address(this)] = balances[address(this)].sub(rewards);
375         balances[msg.sender] = newBalance_farmer;
376         balances[contractOwner] = balances[contractOwner].add(onePercent);
377         emit Transfer(address(this), msg.sender, rewards);
378         emit Transfer(address(this), contractOwner, onePercent);
379     }
380     
381     function enableFarming() public { _enableFarming(msg.sender);  }
382     
383     function disableFarming() public { _disableFarming(msg.sender); }
384     
385     function enableFarmingFor(address farmer) public onlyOwner { _enableFarming(farmer); }
386     
387     function disableFarmingFor(address farmer) public onlyOwner { _disableFarming(farmer); }
388     
389     //enable farming for target address
390     function _enableFarming(address farmer) private
391     {
392         require(!isFarming[farmer]);
393         updateRewardsFor(farmer);
394         isFarming[farmer] = true;
395         fullUnitsFarmed_total = fullUnitsFarmed_total.add(toFullUnits(balances[farmer]));
396     }
397     
398     //disable farming for target address
399     function _disableFarming(address farmer) private
400     {
401         require(isFarming[farmer]);
402         updateRewardsFor(farmer);
403         isFarming[farmer] = false;
404         fullUnitsFarmed_total = fullUnitsFarmed_total.sub(toFullUnits(balances[farmer]));
405     }
406     
407     //withdraw tokens that were sent to this contract by accident
408     function withdrawERC20Tokens(address tokenAddress, uint256 amount) public onlyOwner
409     {
410         require(tokenAddress != address(this));
411         IERC20(tokenAddress).transfer(msg.sender, amount);
412     }
413     
414     //no fees if receiver is whitelisted
415     function setWhitelistedTo(address _addr, bool _whitelisted) external onlyOwner {
416         emit WhitelistTo(_addr, _whitelisted);
417         whitelistTo[_addr] = _whitelisted;
418     }
419 
420     //no fees if sender is whitelisted
421     function setWhitelistedFrom(address _addr, bool _whitelisted) external onlyOwner {
422         emit WhitelistFrom(_addr, _whitelisted);
423         whitelistFrom[_addr] = _whitelisted;
424     }
425     
426 }