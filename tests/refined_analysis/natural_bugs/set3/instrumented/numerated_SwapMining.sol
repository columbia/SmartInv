1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.0 <0.8.0;
4 
5 import "@openzeppelin/contracts/access/Ownable.sol";
6 import "@openzeppelin/contracts/utils/EnumerableSet.sol";
7 import "../libraries/SafeMath.sol";
8 import "../libraries/BabyLibrary.sol";
9 import "../interfaces/IERC20.sol";
10 import "../interfaces/IBabyFactory.sol";
11 import "../interfaces/IBabyPair.sol";
12 import "../token/BabyToken.sol";
13 import 'hardhat/console.sol';
14 
15 interface IOracle {
16     function update(address tokenA, address tokenB) external;
17 
18     function consult(address tokenIn, uint amountIn, address tokenOut) external view returns (uint amountOut);
19 }
20 
21 contract SwapMining is Ownable {
22     using SafeMath for uint256;
23     using EnumerableSet for EnumerableSet.AddressSet;
24     EnumerableSet.AddressSet private _whitelist;
25 
26     // MDX tokens created per block
27     uint256 public babyPerBlock;
28     // The block number when MDX mining starts.
29     uint256 public startBlock;
30     // How many blocks are halved
31     uint256 public halvingPeriod = 5256000;
32     // Total allocation points
33     uint256 public totalAllocPoint = 0;
34     IOracle public oracle;
35     // router address
36     address public router;
37     // factory address
38     IBabyFactory public factory;
39     // babytoken address
40     BabyToken public babyToken;
41     // Calculate price based on BUSD
42     address public targetToken;
43     // pair corresponding pid
44     mapping(address => uint256) public pairOfPid;
45 
46     constructor(
47         BabyToken _babyToken,
48         IBabyFactory _factory,
49         IOracle _oracle,
50         address _router,
51         address _targetToken,
52         uint256 _babyPerBlock,
53         uint256 _startBlock
54     ) {
55         require(address(_babyToken) != address(0), "illegal address");
56         babyToken = _babyToken;
57         require(address(_factory) != address(0), "illegal address");
58         factory = _factory;
59         require(address(_oracle) != address(0), "illegal address");
60         oracle = _oracle;
61         require(_router != address(0), "illegal address");
62         router = _router;
63         targetToken = _targetToken;
64         babyPerBlock = _babyPerBlock;
65         startBlock = _startBlock;
66     }
67 
68     struct UserInfo {
69         uint256 quantity;       // How many LP tokens the user has provided
70         uint256 blockNumber;    // Last transaction block
71     }
72 
73     struct PoolInfo {
74         address pair;           // Trading pairs that can be mined
75         uint256 quantity;       // Current amount of LPs
76         uint256 totalQuantity;  // All quantity
77         uint256 allocPoint;     // How many allocation points assigned to this pool
78         uint256 allocMdxAmount; // How many MDXs
79         uint256 lastRewardBlock;// Last transaction block
80     }
81 
82     PoolInfo[] public poolInfo;
83     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
84 
85 
86     function poolLength() public view returns (uint256) {
87         return poolInfo.length;
88     }
89 
90 
91     function addPair(uint256 _allocPoint, address _pair, bool _withUpdate) public onlyOwner {
92         require(_pair != address(0), "_pair is the zero address");
93         if (_withUpdate) {
94             massMintPools();
95         }
96         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
97         totalAllocPoint = totalAllocPoint.add(_allocPoint);
98         poolInfo.push(PoolInfo({
99         pair : _pair,
100         quantity : 0,
101         totalQuantity : 0,
102         allocPoint : _allocPoint,
103         allocMdxAmount : 0,
104         lastRewardBlock : lastRewardBlock
105         }));
106         pairOfPid[_pair] = poolLength() - 1;
107     }
108 
109     // Update the allocPoint of the pool
110     function setPair(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
111         if (_withUpdate) {
112             massMintPools();
113         }
114         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
115         poolInfo[_pid].allocPoint = _allocPoint;
116     }
117 
118     // Set the number of baby produced by each block
119     function setBabyPerBlock(uint256 _newPerBlock) public onlyOwner {
120         massMintPools();
121         babyPerBlock = _newPerBlock;
122     }
123 
124     // Only tokens in the whitelist can be mined MDX
125     function addWhitelist(address _addToken) public onlyOwner returns (bool) {
126         require(_addToken != address(0), "SwapMining: token is the zero address");
127         return EnumerableSet.add(_whitelist, _addToken);
128     }
129 
130     function delWhitelist(address _delToken) public onlyOwner returns (bool) {
131         require(_delToken != address(0), "SwapMining: token is the zero address");
132         return EnumerableSet.remove(_whitelist, _delToken);
133     }
134 
135     function getWhitelistLength() public view returns (uint256) {
136         return EnumerableSet.length(_whitelist);
137     }
138 
139     function isWhitelist(address _token) public view returns (bool) {
140         return EnumerableSet.contains(_whitelist, _token);
141     }
142 
143     function getWhitelist(uint256 _index) public view returns (address){
144         require(_index <= getWhitelistLength() - 1, "SwapMining: index out of bounds");
145         return EnumerableSet.at(_whitelist, _index);
146     }
147 
148     function setHalvingPeriod(uint256 _block) public onlyOwner {
149         halvingPeriod = _block;
150     }
151 
152     function setRouter(address newRouter) public onlyOwner {
153         require(newRouter != address(0), "SwapMining: new router is the zero address");
154         router = newRouter;
155     }
156 
157     function setOracle(IOracle _oracle) public onlyOwner {
158         require(address(_oracle) != address(0), "SwapMining: new oracle is the zero address");
159         oracle = _oracle;
160     }
161 
162     // At what phase
163     function phase(uint256 blockNumber) public view returns (uint256) {
164         if (halvingPeriod == 0) {
165             return 0;
166         }
167         if (blockNumber > startBlock) {
168             return (blockNumber.sub(startBlock).sub(1)).div(halvingPeriod);
169         }
170         return 0;
171     }
172 
173     function phase() public view returns (uint256) {
174         return phase(block.number);
175     }
176 
177     function reward(uint256 blockNumber) public view returns (uint256) {
178         uint256 _phase = phase(blockNumber);
179         return babyPerBlock.div(2 ** _phase);
180     }
181 
182     function reward() public view returns (uint256) {
183         return reward(block.number);
184     }
185 
186     // Rewards for the current block
187     function getBabyReward(uint256 _lastRewardBlock) public view returns (uint256) {
188         require(_lastRewardBlock <= block.number, "SwapMining: must little than the current block number");
189         uint256 blockReward = 0;
190         uint256 n = phase(_lastRewardBlock);
191         uint256 m = phase(block.number);
192         // If it crosses the cycle
193         while (n < m) {
194             n++;
195             // Get the last block of the previous cycle
196             uint256 r = n.mul(halvingPeriod).add(startBlock);
197             // Get rewards from previous periods
198             blockReward = blockReward.add((r.sub(_lastRewardBlock)).mul(reward(r)));
199             _lastRewardBlock = r;
200         }
201         blockReward = blockReward.add((block.number.sub(_lastRewardBlock)).mul(reward(block.number)));
202         return blockReward;
203     }
204 
205     // Update all pools Called when updating allocPoint and setting new blocks
206     function massMintPools() public {
207         uint256 length = poolInfo.length;
208         for (uint256 pid = 0; pid < length; ++pid) {
209             mint(pid);
210         }
211     }
212 
213     function mint(uint256 _pid) public returns (bool) {
214         PoolInfo storage pool = poolInfo[_pid];
215         if (block.number <= pool.lastRewardBlock) {
216             return false;
217         }
218         uint256 blockReward = getBabyReward(pool.lastRewardBlock);
219         if (blockReward <= 0) {
220             return false;
221         }
222         // Calculate the rewards obtained by the pool based on the allocPoint
223         uint256 mdxReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
224         // Increase the number of tokens in the current pool
225         pool.allocMdxAmount = pool.allocMdxAmount.add(mdxReward);
226         pool.lastRewardBlock = block.number;
227         return true;
228     }
229 
230     modifier onlyRouter() {
231         require(msg.sender == router, "SwapMining: caller is not the router");
232         _;
233     }
234 
235     // swapMining only router
236     function swap(address account, address input, address output, uint256 amount) public onlyRouter returns (bool) {
237         require(account != address(0), "SwapMining: taker swap account is the zero address");
238         require(input != address(0), "SwapMining: taker swap input is the zero address");
239         require(output != address(0), "SwapMining: taker swap output is the zero address");
240 
241         if (poolLength() <= 0) {
242             return false;
243         }
244 
245         if (!isWhitelist(input) || !isWhitelist(output)) {
246             return false;
247         }
248 
249         address pair = BabyLibrary.pairFor(address(factory), input, output);
250         PoolInfo storage pool = poolInfo[pairOfPid[pair]];
251         // If it does not exist or the allocPoint is 0 then return
252         if (pool.pair != pair || pool.allocPoint <= 0) {
253             return false;
254         }
255 
256         uint256 quantity = getQuantity(output, amount, targetToken);
257         if (quantity <= 0) {
258             return false;
259         }
260 
261         mint(pairOfPid[pair]);
262 
263         pool.quantity = pool.quantity.add(quantity);
264         pool.totalQuantity = pool.totalQuantity.add(quantity);
265         UserInfo storage user = userInfo[pairOfPid[pair]][account];
266         user.quantity = user.quantity.add(quantity);
267         user.blockNumber = block.number;
268         return true;
269     }
270 
271     function getQuantity(address outputToken, uint256 outputAmount, address anchorToken) public view returns (uint256) {
272         uint256 quantity = 0;
273         if (outputToken == anchorToken) {
274             quantity = outputAmount;
275         } else if (IBabyFactory(factory).getPair(outputToken, anchorToken) != address(0)) {
276             quantity = IOracle(oracle).consult(outputToken, outputAmount, anchorToken);
277         } else {
278             uint256 length = getWhitelistLength();
279             for (uint256 index = 0; index < length; index++) {
280                 address intermediate = getWhitelist(index);
281                 if (factory.getPair(outputToken, intermediate) != address(0) && factory.getPair(intermediate, anchorToken) != address(0)) {
282                     uint256 interQuantity = IOracle(oracle).consult(outputToken, outputAmount, intermediate);
283                     quantity = IOracle(oracle).consult(intermediate, interQuantity, anchorToken);
284                     break;
285                 }
286             }
287         }
288         return quantity;
289     }
290 
291     // The user withdraws all the transaction rewards of the pool
292     function takerWithdraw() public {
293         uint256 userSub;
294         uint256 length = poolInfo.length;
295         for (uint256 pid = 0; pid < length; ++pid) {
296             PoolInfo storage pool = poolInfo[pid];
297             UserInfo storage user = userInfo[pid][msg.sender];
298             if (user.quantity > 0) {
299                 mint(pid);
300                 // The reward held by the user in this pool
301                 uint256 userReward = pool.allocMdxAmount.mul(user.quantity).div(pool.quantity);
302                 pool.quantity = pool.quantity.sub(user.quantity);
303                 pool.allocMdxAmount = pool.allocMdxAmount.sub(userReward);
304                 user.quantity = 0;
305                 user.blockNumber = block.number;
306                 userSub = userSub.add(userReward);
307             }
308         }
309         if (userSub <= 0) {
310             return;
311         }
312         console.log(userSub);
313         babyToken.transfer(msg.sender, userSub);
314     }
315 
316     // Get rewards from users in the current pool
317     function getUserReward(uint256 _pid, address _user) public view returns (uint256, uint256){
318         require(_pid <= poolInfo.length - 1, "SwapMining: Not find this pool");
319         uint256 userSub;
320         PoolInfo memory pool = poolInfo[_pid];
321         UserInfo memory user = userInfo[_pid][_user];
322         if (user.quantity > 0) {
323             uint256 blockReward = getBabyReward(pool.lastRewardBlock);
324             uint256 mdxReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
325             userSub = userSub.add((pool.allocMdxAmount.add(mdxReward)).mul(user.quantity).div(pool.quantity));
326         }
327         //Mdx available to users, User transaction amount
328         return (userSub, user.quantity);
329     }
330 
331     // Get details of the pool
332     function getPoolInfo(uint256 _pid) public view returns (address, address, uint256, uint256, uint256, uint256){
333         require(_pid <= poolInfo.length - 1, "SwapMining: Not find this pool");
334         PoolInfo memory pool = poolInfo[_pid];
335         address token0 = IBabyPair(pool.pair).token0();
336         address token1 = IBabyPair(pool.pair).token1();
337         uint256 mdxAmount = pool.allocMdxAmount;
338         uint256 blockReward = getBabyReward(pool.lastRewardBlock);
339         uint256 mdxReward = blockReward.mul(pool.allocPoint).div(totalAllocPoint);
340         mdxAmount = mdxAmount.add(mdxReward);
341         //token0,token1,Pool remaining reward,Total /Current transaction volume of the pool
342         return (token0, token1, mdxAmount, pool.totalQuantity, pool.quantity, pool.allocPoint);
343     }
344 
345     function ownerWithdraw(address _to, uint256 _amount) public onlyOwner {
346         safeCakeTransfer(_to, _amount);
347     }
348 
349     function safeCakeTransfer(address _to, uint256 _amount) internal {
350         uint256 balance = babyToken.balanceOf(address(this));
351         if (_amount > balance) {
352             _amount = balance;
353         }
354         babyToken.transfer(_to, _amount);
355     }
356 }
