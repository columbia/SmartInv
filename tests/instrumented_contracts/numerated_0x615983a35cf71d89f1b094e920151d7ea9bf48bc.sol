1 pragma solidity ^0.6.12;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10 
11     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12         return sub(a, b, "SafeMath: subtraction overflow");
13     }
14 
15     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
16         require(b <= a, errorMessage);
17         uint256 c = a - b;
18 
19         return c;
20     }
21 
22     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23         if (a == 0) {
24             return 0;
25         }
26 
27         uint256 c = a * b;
28         require(c / a == b, "SafeMath: multiplication overflow");
29 
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         return div(a, b, "SafeMath: division by zero");
35     }
36 
37     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b > 0, errorMessage);
39         uint256 c = a / b;
40 
41         return c;
42     }
43 
44     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45         return mod(a, b, "SafeMath: modulo by zero");
46     }
47 
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract Ownable {
55     address public _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     constructor () public {
60         _owner = msg.sender;
61         emit OwnershipTransferred(address(0), msg.sender);
62     }
63 
64     function owner() public view returns (address) {
65         return _owner;
66     }
67 
68     modifier onlyOwner() {
69         require(_owner == msg.sender, "Ownable: caller is not the owner");
70         _;
71     }
72 
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         emit OwnershipTransferred(_owner, newOwner);
81         _owner = newOwner;
82     }
83 }
84 
85 interface IERC20 {
86     function totalSupply() external view returns (uint256);
87     function balanceOf(address tokenOwner) external view returns (uint256 balance);
88     function allowance(address tokenOwner, address spender) external view returns (uint256 remaining);
89     function transfer(address to, uint256 tokens) external returns (bool success);
90     function approve(address spender, uint256 tokens) external returns (bool success);
91     function transferFrom(address from, address to, uint256 tokens) external returns (bool success);
92 }
93 
94 
95 interface IYFKA {
96     function mint(address to, uint256 amount) external;
97     function transferOwnership(address newOwner) external;
98     function balanceOf(address tokenOwner) external view returns (uint256 balance);
99 }
100 
101 contract YFKAController is Ownable {
102     using SafeMath for uint256;
103 
104     uint8 constant ETH_POOL = 3;
105 
106     IERC20[4] public pools;
107     
108     mapping(uint8 => mapping(address => uint256)) public lastBlockWithdrawn;
109     mapping(uint8 => mapping(address => uint256)) public personalEmissions;
110 
111 
112     IYFKA public yfka = IYFKA(0x4086692D53262b2Be0b13909D804F0491FF6Ec3e);
113     
114     uint256 public multiplier = 2;
115 
116     mapping(uint8 => mapping(address => uint256)) public stakes;
117 
118     // Current Emission Rate / 
119     uint256 public emissionRate = 2 * (10 ** 18); // YFKA reward per YFKA staked per year
120     
121     uint256 public minimum_stake = 2 * (10 ** 17); //0.2 YFKA required to stake
122     uint256 public blocks_per_year = 2372500;
123     
124     uint256 public decayPercent =  999998;
125     uint256 public decayDivisor = 1000000;
126     
127     uint256 public lastBlockUpdated = block.number;
128     
129     mapping(address => bool) whitelist;
130     
131     // MGMT
132     bool isOpen = false;
133     
134     function setOpen() public onlyOwner {
135         isOpen = true;
136     }
137     
138     function addWhitelist() public {
139         whitelist[msg.sender] = true;
140     }
141     
142     modifier onlyIfOpen {
143         if (isOpen == false) {
144           require((msg.sender == _owner) || (whitelist[msg.sender] == true));  
145         }
146         _;
147     }
148     //
149     
150     /*
151     SET TOKEN
152     Given an index and an address, this stores the ERC20 contract object of the token you want to support in your pool
153     Parameters:
154         idx: Index of the pool to set.
155         _addr: Address of the token you want to pool.
156     Returns:
157         None
158     
159     */
160     function setPool(uint8 idx, address _addr) public onlyOwner {
161         pools[idx] = IERC20(_addr);
162     }
163 
164     function setYFKA(address _addr) public onlyOwner {
165         yfka = IYFKA(_addr);
166     }
167 
168     function transferOwnershipOfYFKA(address _addr) public onlyOwner {
169         yfka.transferOwnership(_addr);
170     }
171 
172     /*
173     GET POINTS FOR STAKE
174     Calculates the 'points' an owner has for a particular pool. Used to calculate how much of a reward to mint.
175     Parameters:
176         idx: Index of the pool to set.
177         stake: The amount of stake.
178     Returns:
179         points: Number of points
180     */
181     uint precision = 1000000;
182     function yfkaPerLP(uint8 idx, uint256 amount) public view returns (uint256) {
183         uint percentOfLPStaked = amount.mul(precision).div(pools[idx].totalSupply());
184         uint256 _yfkaStake = yfka.balanceOf(address(pools[idx])).mul(percentOfLPStaked).div(precision);
185 
186         return _yfkaStake;
187     }
188     
189     function totalYFKAStaked(uint8 idx) public view returns(uint points) {
190         uint256 amount = pools[idx].balanceOf(address(this));
191         return yfkaPerLP(idx, amount);
192     }
193     
194     function personalYFKAStaked(uint8 idx) public view returns(uint points) {
195         uint256 amount = stakes[idx][msg.sender];
196         return yfkaPerLP(idx, amount);
197     }
198     
199 
200     // Returns the pool with the highest stake amount
201     function getActivePool() public view returns (uint8 idx) {
202         if ((totalYFKAStaked(0) < totalYFKAStaked(1)) && (totalYFKAStaked(0) < totalYFKAStaked(2))) {
203             return 0;
204         }
205         else if ((totalYFKAStaked(1) < totalYFKAStaked(0)) && (totalYFKAStaked(1) < totalYFKAStaked(2))) {
206             return 1;
207         }
208         return 2;
209     }
210 
211     // LOGIC CALLED WHEN STAKING / UNSTAKING / WITHDRAWING FROM A POOL
212 
213     // Emission rate variables
214     function _getNextRateReduction() public view returns(uint256) {
215         uint256 absoluteRate = emissionRate.mul(decayPercent).div(decayDivisor);
216         return emissionRate.sub(absoluteRate);
217     }
218 
219     function _getBlocksSinceLastReduction() public view returns(uint256) {
220         uint256 last = block.number.sub(lastBlockUpdated);
221         if (last > 5000) {
222             return 5000;
223         }
224         return last;
225     }
226     
227     function _getTotalNextRateReduction() public view returns(uint256) {
228         return _getNextRateReduction().mul(_getBlocksSinceLastReduction());
229     }
230     
231     // stake/ withdraw until 156 blocks have passed
232     function updateEmissionRate() internal {
233         if (_getTotalNextRateReduction() < emissionRate) {
234             emissionRate = emissionRate.sub(_getTotalNextRateReduction());
235             lastBlockUpdated = block.number;
236         }
237     }
238     
239     function getPersonalEmissionRate(uint8 idx, address _addr) public view returns (uint256) {
240         return personalEmissions[idx][_addr];
241     }
242 
243     function setPersonalEmissionRate(uint8 idx, address _addr) internal {
244         personalEmissions[idx][_addr] = emissionRate;
245     }
246     
247     event BonusPoolChange(uint256 indexed previousPool, uint256 indexed newPool);
248 
249     function stake(uint8 idx, uint256 amount) public {
250         require(yfkaPerLP(idx, amount) > minimum_stake);
251 
252         mint(idx, false);
253 
254         if (getPersonalEmissionRate(idx, msg.sender) == 0) {
255             setPersonalEmissionRate(idx, msg.sender);
256         }
257         
258         uint256 previousPool = getActivePool();
259 
260         pools[idx].transferFrom(msg.sender, address(this), amount);
261         stakes[idx][msg.sender] = stakes[idx][msg.sender].add(amount);
262         // If the emission rate has not been set, set it to the current rate
263         
264         uint256 newPool = getActivePool();
265         
266         if (previousPool != newPool) {
267             emit BonusPoolChange(previousPool, newPool);
268         }
269     }
270     
271     function unstake(uint8 idx, uint256 amount) public {
272         // Mint and update global and personal rate
273         mint(idx, true);
274 
275         // Subtract stake first before sending any tokens back. Will throw if invalid amount provided.
276         stakes[idx][msg.sender] = stakes[idx][msg.sender].sub(amount);
277         pools[idx].transfer(msg.sender, amount);
278     }
279     
280     // redeem idxs w/o unstaking
281     function redeem(uint8 idx) public {
282         // Mint and update global and personal rate
283         mint(idx, true);
284     }
285 
286     /*
287     LAST BLOCK WITHDRAWN
288     Mapping of pool index and wallet public key to block number
289     This is used to determine the time between the last withdraw event and the current withdraw event.
290     The duration of time in blocks is then multiplied by the 
291     */
292 
293     function getLastBlockWithdrawn(uint8 idx) public view returns (uint256 reward) {
294         uint256 lbw = lastBlockWithdrawn[idx][msg.sender];
295         if (lbw == 0) {
296             lbw = block.number;
297         }
298 
299         return lbw;
300     }
301 
302     function getCurrentRewardPerYear(uint8 idx) public view returns (uint256) {
303         uint256 emission = personalEmissions[idx][msg.sender];
304         uint256 staked = personalYFKAStaked(idx);
305 
306         if ((emission == 0) || (staked == 0)) {
307             return 0;
308         }
309 
310         uint256 perYear = staked.mul(emission).div(10 ** 18);
311 
312         return perYear;
313     }
314     
315     function getCurrentReward(uint8 idx) public view returns (uint256) {
316         uint256 perYear = getCurrentRewardPerYear(idx);
317 
318         uint256 lbw = getLastBlockWithdrawn(idx);
319         uint256 blockDifference = block.number.sub(lbw);
320 
321         uint reward = perYear.div(blocks_per_year).mul(blockDifference);
322         
323         if (idx == getActivePool()) {
324             reward = reward.mul(multiplier);
325         }
326         else if (idx == ETH_POOL) {
327             reward = reward.div(multiplier);
328         }
329         
330         return reward;
331     }
332     
333     event EmissionRateCut(uint256 indexed previousRate, uint256 indexed newRate);
334     
335     function mint(uint8 idx, bool update) internal onlyIfOpen {
336         uint256 mintAmount = getCurrentReward(idx);
337         
338         // Apply mint
339         yfka.mint(msg.sender, mintAmount);
340         
341         if(emissionRate != 0){
342             uint256 previousRate = emissionRate;
343             updateEmissionRate();
344             uint256 newRate = emissionRate;
345             
346             emit EmissionRateCut(previousRate, newRate);
347         }
348         
349         lastBlockWithdrawn[idx][msg.sender] = block.number;
350 
351         if(update == true) {
352            setPersonalEmissionRate(idx, msg.sender);
353         }
354     }
355 
356 }