1 pragma solidity 0.6.12;
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
98 }
99 
100 contract YFKAController is Ownable {
101     using SafeMath for uint256;
102 
103     IERC20[3] pools;
104     
105     mapping(uint8 => mapping(address => uint256)) public lastBlockWithdrawn;
106     mapping(uint8 => mapping(address => uint256)) public personalEmissions;
107 
108 
109     IYFKA public yfka = IYFKA(0x4086692D53262b2Be0b13909D804F0491FF6Ec3e);
110     
111     uint256 public multiplier = 2; 
112     
113     mapping(uint8 => mapping(address => uint256)) public stakes;
114     mapping(uint8 => uint256) public totalStakes;
115     
116     // Current Emission Rate / 
117     uint256 public emissionRate = 10**18;
118     uint256 public decayPercent =  999998;
119     uint256 public decayDivisor = 1000000;
120     
121     uint256 public lastBlockUpdated = block.number;
122     
123     /*
124     SET TOKEN
125     Given an index and an address, this stores the ERC20 contract object of the token you want to support in your pool
126     Parameters:
127         idx: Index of the pool to set.
128         _addr: Address of the token you want to pool.
129     Returns:
130         None
131     
132     */
133     function setPool(uint8 idx, address _addr) public onlyOwner {
134         pools[idx] = IERC20(_addr);
135     }
136 
137     function transferOwnershipOfYFKA(address _addr) public onlyOwner {
138         yfka.transferOwnership(_addr);
139     }
140 
141     /*
142     GET POINTS FOR STAKE
143     Calculates the 'points' an owner has for a particular pool. Used to calculate how much of a reward to mint.
144     Parameters:
145         idx: Index of the pool to set.
146         stake: The amount of stake.
147     Returns:
148         points: Number of points
149     */
150     function getPointsForStake(uint8 idx, uint256 stake) public view returns(uint points) {
151         return stake.mul(10 ** 9).div(pools[idx].totalSupply());
152     }
153 
154 
155     // Returns the pool with the highest stake amount
156     function getActivePool() public view returns (uint8 idx) {
157         uint256[3] memory maxStakes;
158         maxStakes[0] = getPointsForStake(0, pools[0].balanceOf(address(this)));
159         maxStakes[1] = getPointsForStake(1, pools[1].balanceOf(address(this)));
160         maxStakes[2] = getPointsForStake(2, pools[2].balanceOf(address(this)));
161         
162         if ((maxStakes[0] >= maxStakes[1]) && (maxStakes[0] >= maxStakes[2])) {
163             return 0;
164         }
165         else if ((maxStakes[1] >= maxStakes[0]) && (maxStakes[1] >= maxStakes[2])) {
166             return 1;
167         }
168         return 2;
169     }
170 
171     // LOGIC CALLED WHEN STAKING / UNSTAKING / WITHDRAWING FROM A POOL
172 
173     // Emission rate variables
174     function _getNextRateReduction() internal view returns(uint256) {
175         uint256 absoluteRate = emissionRate.mul(decayPercent).div(decayDivisor);
176         return emissionRate.sub(absoluteRate);
177     }
178 
179     function _getBlocksSinceLastReduction() internal view returns(uint256) {
180         uint256 last = block.number.sub(lastBlockUpdated);
181         if (last > 5000) {
182             return 5000;
183         }
184         return last;    
185         
186     }
187     
188     function _getTotalNextRateReduction() internal view returns(uint256) {
189         return _getNextRateReduction().mul(_getBlocksSinceLastReduction());
190     }
191     
192     // stake/ withdraw until 156 blocks have passed
193     function updateEmissionRate() internal {
194         
195         if (_getTotalNextRateReduction() < emissionRate) {
196             emissionRate = emissionRate.sub(_getTotalNextRateReduction());
197             lastBlockUpdated = block.number;
198         }
199         
200     }
201     
202     function getPersonalEmissionRate(uint8 idx, address _addr) public view returns (uint256) {
203         return personalEmissions[idx][_addr];
204     }
205 
206     function setPersonalEmissionRate(uint8 idx, address _addr) internal {
207         personalEmissions[idx][_addr] = emissionRate;
208     }
209 
210     function increaseStake(uint8 idx, uint256 amount) internal {
211         pools[idx].transferFrom(msg.sender, address(this), amount);
212         stakes[idx][msg.sender] = stakes[idx][msg.sender].add(amount);
213         totalStakes[idx] = totalStakes[idx].add(amount);
214     }
215 
216     function decreaseStake(uint8 idx, uint256 amount) internal {
217         totalStakes[idx] = totalStakes[idx].sub(amount);
218         stakes[idx][msg.sender] = stakes[idx][msg.sender].sub(amount);
219         pools[idx].transfer(msg.sender, amount);
220     }
221 
222     function stake(uint8 idx, uint256 amount) public {
223         // If the emission rate has not been set, set it to the current rate
224         // 10**3 == MINIMUM_LIQUIDITY of the uniswap token 
225         require(emissionRate > 0, "Staking period must be active.");
226         amount = amount.sub(10**3);
227         
228         if (getPersonalEmissionRate(idx, msg.sender) == 0) {
229             setPersonalEmissionRate(idx, msg.sender);
230         }
231 
232         // Mint before adding stake
233         mint(idx, false);
234         
235         // Add to stake
236         increaseStake(idx, amount);
237     }
238     
239     function unstake(uint8 idx, uint256 amount) public {
240         // Mint and update global and personal rate
241         amount = amount.sub(10**3);
242         
243         mint(idx, true);
244 
245         // Subtract stake first before sending any tokens back. Will throw if invalid amount provided.
246         decreaseStake(idx, amount);
247     }
248     
249     // redeem idxs w/o unstaking
250     function redeem(uint8 idx) public {
251         // Mint and update global and personal rate
252         mint(idx, true);
253     }
254 
255     /*
256     LAST BLOCK WITHDRAWN
257     Mapping of pool index and wallet public key to block number
258     This is used to determine the time between the last withdraw event and the current withdraw event.
259     The duration of time in blocks is then multiplied by the 
260     */
261 
262     function getLastBlockWithdrawn(uint8 idx) public view returns (uint256) {
263         uint256 lbw = lastBlockWithdrawn[idx][msg.sender];
264         if (lbw == 0) {
265             lbw = block.number;
266         }
267 
268         return lbw;
269     }
270     
271     function setLastBlockWithdrawn(uint8 idx) internal {
272         lastBlockWithdrawn[idx][msg.sender] = block.number;
273     }
274     
275     function getCurrentReward(uint8 idx) public view returns (uint256 reward) {
276         uint256 blockDifference = block.number.sub(getLastBlockWithdrawn(idx));
277         uint256 amount = getPersonalEmissionRate(idx, msg.sender).mul(blockDifference).mul(getPointsForStake(idx,stakes[idx][msg.sender])).div(10**9);
278         
279         if (idx == getActivePool()) {
280             amount = amount.mul(multiplier);
281         }
282         
283         return amount;
284 
285     }
286     
287     function mint(uint8 idx, bool update) internal {
288         uint256 mintAmount = getCurrentReward(idx); 
289         
290         // Apply mint
291         yfka.mint(msg.sender, mintAmount);
292         
293         if(emissionRate != 0){
294             updateEmissionRate();
295         }
296         
297         setLastBlockWithdrawn(idx);
298         if(update) {    
299            setPersonalEmissionRate(idx, msg.sender);
300         }
301         
302     }
303 
304 }