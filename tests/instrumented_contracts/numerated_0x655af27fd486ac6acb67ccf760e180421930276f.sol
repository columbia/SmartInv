1 pragma solidity 0.7.1;
2 
3 interface IERC20 {
4     function balanceOf(address account) external view returns (uint256);
5     function allowance(address owner, address spender) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
8     function totalSupply() external view returns (uint256);
9 
10     function burn(uint256 value) external returns (bool);
11 
12     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
13     function token0() external view returns (address);
14     function token1() external view returns (address);
15 }
16 
17 contract PoolRewardToken {
18     mapping (address => uint256) public _balanceOf;
19 
20     string public constant name = "MalwareChain DAO";
21     string public constant symbol = "MDAO";
22     uint8 public constant decimals = 18;
23     uint256 public totalSupply = 0;
24     mapping(address => mapping(address => uint256)) private _allowances;
25 
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     function balanceOf(address account) public view returns (uint256 value) {
30         return _balanceOf[account];
31     }
32 
33     function transfer(address to, uint256 value) public returns (bool success) {
34         require(_balanceOf[msg.sender] >= value);
35 
36         _balanceOf[msg.sender] -= value;  // deduct from sender's balance
37         _balanceOf[to] += value;          // add to recipient's balance
38         emit Transfer(msg.sender, to, value);
39         return true;
40     }
41 
42     function transferMultiple(address[] memory to, uint256 value) public returns (bool success) {
43         require(_balanceOf[msg.sender] >= value);
44 
45         _balanceOf[msg.sender] -= value;
46         value /= to.length;
47         for (uint256 i = 0; i < to.length; i++) {
48             _balanceOf[to[i]] += value;
49             emit Transfer(msg.sender, to[i], value);
50         }
51         return true;
52     }
53 
54     function allowance(address owner, address spender) public view returns (uint256) {
55         return _allowances[owner][spender];
56     }
57 
58     function approve(address spender, uint256 value) public returns (bool success) {
59         _allowances[msg.sender][spender] = value;
60         emit Approval(msg.sender, spender, value);
61         return true;
62     }
63 
64     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
65         require(value <= _balanceOf[from]);
66         require(value <= _allowances[from][msg.sender]);
67 
68         _balanceOf[from] -= value;
69         _balanceOf[to] += value;
70         _allowances[from][msg.sender] -= value;
71         emit Transfer(from, to, value);
72         return true;
73     }
74 
75     function mint(address to, uint256 value) internal {
76         totalSupply += value;
77         _balanceOf[to] += value;
78         emit Transfer(address(0), to, value);
79     }
80 
81     function burn(uint256 value) public returns (bool success) {
82         require(value <= _balanceOf[msg.sender]);
83         totalSupply -= value;
84         _balanceOf[msg.sender] -= value;
85         return true;
86     }
87 }
88 
89 abstract contract Ownable {
90     address public owner_;
91 
92     constructor() {
93         owner_ = msg.sender;
94     }
95 
96     modifier onlyOwner() {
97         if (msg.sender == owner_)
98             _;
99     }
100 
101     function transferOwnership(address newOwner) onlyOwner public {
102         if (newOwner != address(0)) owner_ = newOwner;
103     }
104 }
105 
106 contract MiningPool is PoolRewardToken, Ownable {
107     uint8 public constant BLOCK_STEP = 10;
108     uint256 public constant BLOCK_FEE_PERCENT = 100000;
109 
110     struct Investor {
111         uint256 depositMALW;
112         uint256 depositLPETH;
113         uint256 depositLPUSDT;
114         uint256 lastZeroPtr;
115         bool initialized;
116     }
117 
118     struct BlockInfo {
119         uint256 totalDepositsMALW;
120         uint256 totalDepositsLPETH;
121         uint256 totalDepositsLPUSDT;
122         uint256 lpETHPrice;
123         uint256 lpUSDTPrice;
124         uint256 blockLength;
125         uint256 blockReward;
126         uint256 lpPart;
127     }
128 
129     uint256 public BLOCK_REWARD = 10**18 * 400;
130     uint256 public LP_PART = 10**4 * 80;
131     uint256 public deployBlock;
132     uint256 public lastRecordedBlock;
133     uint256 public totalDepositsMALW;
134     uint256 public totalDepositsLPETH;
135     uint256 public totalDepositsLPUSDT;
136     BlockInfo[1000000] public history;
137     uint256 public arrayPointer;
138     mapping (address => Investor) public investors;
139     bool public miningFinished = false;
140     uint256 public masternodeRewardsBalance;
141     uint256 public feesBalance;
142     mapping (uint256 => uint256) public masternodeRewardsClaimedNonces;
143 
144     IERC20 public _tokenMALW;
145     IERC20 public _tokenLPETH;
146     IERC20 public _tokenLPUSDT;
147 
148     event Deposit(address indexed investor, uint256 valueMALW, uint256 valueLPETH, uint256 valueLPUSDT);
149     event Harvest(address indexed investor, uint256 value);
150     event Withdraw(address indexed investor, uint256 valueMALW, uint256 valueLPETH, uint256 valueLPUSDT);
151     event MasternodeReward(address indexed owner, uint256 value, uint256 nonce);
152     event FeesSpent(address indexed to, uint256 value);
153     event RewardChanged(uint256 newValue);
154     event LPPartChanged(uint256 newValue);
155 
156     constructor() {
157         deployBlock = block.number;
158         emit RewardChanged(BLOCK_REWARD);
159     }
160 
161     function setMALWToken(address token) public {
162         require(address(_tokenMALW) == address(0), "Address was already set");
163         _tokenMALW = IERC20(token);
164     }
165 
166     function setLPETHToken(address token) public {
167         require(address(_tokenLPETH) == address(0), "Address was already set");
168         _tokenLPETH = IERC20(token);
169     }
170 
171     function setLPUSDTToken(address token) public {
172         require(address(_tokenLPUSDT) == address(0), "Address was already set");
173         _tokenLPUSDT = IERC20(token);
174     }
175 
176     function setBlockReward(uint256 value) public onlyOwner {
177         recordHistory();
178         BLOCK_REWARD = value;
179         emit RewardChanged(value);
180     }
181 
182     function setLPPart(uint256 value) public onlyOwner {  // 1% = 10000
183         require(value < 90 * 10**4, "Maximum value is 900000 (90%)");
184         recordHistory();
185         LP_PART = value;
186         emit LPPartChanged(value);
187     }
188 
189     function currentBlock() public view returns (uint256) {
190         return (block.number - deployBlock) / BLOCK_STEP;
191     }
192 
193     function recordHistoryNeeded() public view returns (bool) {
194         return !miningFinished && lastRecordedBlock < currentBlock();
195     }
196 
197     function getBlockTotalDepositsMALW(uint256 blk) public view returns (uint256) {
198         if (blk >= arrayPointer)
199             return totalDepositsMALW;
200         return history[blk].totalDepositsMALW;
201     }
202 
203     function getBlockTotalDepositsLPETH(uint256 blk) public view returns (uint256) {
204         if (blk >= arrayPointer)
205             return totalDepositsLPETH;
206         return history[blk].totalDepositsLPETH;
207     }
208 
209     function getBlockTotalDepositsLPUSDT(uint256 blk) public view returns (uint256) {
210         if (blk >= arrayPointer)
211             return totalDepositsLPUSDT;
212         return history[blk].totalDepositsLPUSDT;
213     }
214 
215     function getBlockLPETHPrice(uint256 blk) public view returns (uint256) {
216         if (blk >= arrayPointer)
217             return getCurrentLPETHPrice();
218         return history[blk].lpETHPrice;
219     }
220 
221     function getBlockLPUSDTPrice(uint256 blk) public view returns (uint256) {
222         if (blk >= arrayPointer)
223             return getCurrentLPUSDTPrice();
224         return history[blk].lpUSDTPrice;
225     }
226 
227     function getCurrentLPETHPrice() public view returns (uint256) {
228         if (address(_tokenLPETH) == address(0))
229             return 0;
230         return _tokenLPETH.totalSupply() > 0 ? getReserve(_tokenLPETH) / _tokenLPETH.totalSupply() : 0;  // both MALWDAO and UNI-V2 have 18 decimals
231     }
232 
233     function getCurrentLPUSDTPrice() public view returns (uint256) {
234         if (address(_tokenLPUSDT) == address(0))
235             return 0;
236         return _tokenLPUSDT.totalSupply() > 0 ? getReserve(_tokenLPUSDT) / _tokenLPUSDT.totalSupply() : 0;  // both MALWDAO and UNI-V2 have 18 decimals
237     }
238 
239     function getRewardDistribution(uint256 blk) public view returns (uint256 malw, uint256 lp) {
240         if (blk > 787500) {  // 157500000 MALWDAO limit
241             return (0, 0);
242         }
243         lp = (getBlockTotalDepositsLPETH(blk) + getBlockTotalDepositsLPUSDT(blk)) <= 0 ? 0 : getLPPart(blk);
244         malw = getBlockTotalDepositsMALW(blk) <= 0 ? 0 : 1000000 - lp - BLOCK_FEE_PERCENT;
245     }
246 
247     function recordHistory() public returns (bool) {
248         if (recordHistoryNeeded()) {
249             _recordHistory();
250             return true;
251         }
252         return false;
253     }
254 
255     function _recordHistory() internal {
256         // miningFinished check is in recordHistoryNeeded();
257 
258         uint256 currentBlk = currentBlock();
259 
260         if (currentBlk > 787500) {
261             currentBlk = 787500;
262             miningFinished = true;
263         }
264 
265         uint256 lpETHPrice = getCurrentLPETHPrice();
266         uint256 lpUSDTPrice = getCurrentLPUSDTPrice();
267 
268         history[arrayPointer].totalDepositsMALW = totalDepositsMALW;
269         history[arrayPointer].totalDepositsLPETH = totalDepositsLPETH;
270         history[arrayPointer].totalDepositsLPUSDT = totalDepositsLPUSDT;
271         history[arrayPointer].lpETHPrice = lpETHPrice;
272         history[arrayPointer].lpUSDTPrice = lpUSDTPrice;
273         history[arrayPointer].blockLength = currentBlk - lastRecordedBlock;
274         history[arrayPointer].blockReward = BLOCK_REWARD;
275         history[arrayPointer].lpPart = LP_PART;
276 
277         masternodeRewardsBalance += BLOCK_REWARD / 20 * (currentBlk - lastRecordedBlock);  // 5%
278         feesBalance += BLOCK_REWARD / 20 * (currentBlk - lastRecordedBlock);  // 5%
279 
280         arrayPointer++;
281         lastRecordedBlock = currentBlk;
282     }
283 
284     function getReserve(IERC20 token) internal view returns (uint256) {
285         (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast) = token.getReserves();
286         return token.token0() == address(this) ? uint256(reserve0) : uint256(reserve1);
287     }
288 
289     function getBlockLength(uint256 blk) internal view returns (uint256) {
290         if (blk >= arrayPointer) {
291             return currentBlock() - lastRecordedBlock;
292         }
293         return history[blk].blockLength;
294     }
295 
296     function getBlockReward(uint256 blk) internal view returns (uint256) {
297         if (blk >= arrayPointer) {
298             return BLOCK_REWARD;
299         }
300         return history[blk].blockReward;
301     }
302 
303     function getLPPart(uint256 blk) internal view returns (uint256) {
304         if (blk >= arrayPointer) {
305             return LP_PART;
306         }
307         return history[blk].lpPart;
308     }
309 
310     function getRewardSum(address sender) public view returns (uint256) {
311         if (!investors[sender].initialized || !canHarvest(sender))
312             return 0;
313 
314         uint256 reward = 0;
315 
316         for (uint256 i = investors[sender].lastZeroPtr; i <= arrayPointer; i++) {
317             (uint256 malwPercent, uint256 lpPercent) = getRewardDistribution(i);
318             uint256 lpETHPrice = getBlockLPETHPrice(i);
319             uint256 lpUSDTPrice = getBlockLPUSDTPrice(i);
320             uint256 totalNormalizedLP = lpETHPrice * getBlockTotalDepositsLPETH(i) + lpUSDTPrice * getBlockTotalDepositsLPUSDT(i);
321             uint256 userNormalizedLP = lpETHPrice * investors[sender].depositLPETH + lpUSDTPrice * investors[sender].depositLPUSDT;
322 
323             if (investors[sender].depositMALW > 0)
324                 reward += getBlockReward(i) * getBlockLength(i) * investors[sender].depositMALW / getBlockTotalDepositsMALW(i) * malwPercent / 1000000;
325             if (userNormalizedLP > 0)
326                 reward += getBlockReward(i) * getBlockLength(i) * userNormalizedLP / totalNormalizedLP * lpPercent / 1000000;
327         }
328 
329         return reward;
330     }
331 
332     function deposit(uint256 valueMALW, uint256 valueLPETH, uint256 valueLPUSDT) public {
333         require(valueMALW + valueLPETH + valueLPUSDT > 0 &&
334                 valueMALW >= 0 &&
335                 valueLPETH >= 0 &&
336                 valueLPUSDT >= 0, "Invalid arguments");
337 
338         if (canHarvest(msg.sender))
339             harvestReward();  // history is recorded while harvesting
340         else
341             recordHistory();
342 
343         if (valueMALW > 0) {
344             require(_tokenMALW.allowance(msg.sender, address(this)) >= valueMALW, "Insufficient MALW allowance");
345             investors[msg.sender].depositMALW += valueMALW;
346             totalDepositsMALW += valueMALW;
347             _tokenMALW.transferFrom(msg.sender, address(this), valueMALW);
348         }
349 
350         if (valueLPETH > 0) {
351             require(_tokenLPETH.allowance(msg.sender, address(this)) >= valueLPETH, "Insufficient LPETH allowance");
352             investors[msg.sender].depositLPETH += valueLPETH;
353             totalDepositsLPETH += valueLPETH;
354             _tokenLPETH.transferFrom(msg.sender, address(this), valueLPETH);
355         }
356 
357         if (valueLPUSDT > 0) {
358             require(_tokenLPUSDT.allowance(msg.sender, address(this)) >= valueLPUSDT, "Insufficient LPUSDT allowance");
359             investors[msg.sender].depositLPUSDT += valueLPUSDT;
360             totalDepositsLPUSDT += valueLPUSDT;
361             _tokenLPUSDT.transferFrom(msg.sender, address(this), valueLPUSDT);
362         }
363 
364         investors[msg.sender].initialized = true;
365         investors[msg.sender].lastZeroPtr = arrayPointer;
366         emit Deposit(msg.sender, valueMALW, valueLPETH, valueLPUSDT);
367     }
368 
369     function canHarvest(address sender) public view returns (bool) {
370         return investors[sender].depositMALW + investors[sender].depositLPETH + investors[sender].depositLPUSDT > 0;
371     }
372 
373     function harvestReward() public returns (uint256) {
374         require(canHarvest(msg.sender));
375 
376         recordHistory();
377 
378         uint256 reward = getRewardSum(msg.sender);
379         if (reward > 0)
380             mint(msg.sender, reward);
381         investors[msg.sender].lastZeroPtr = arrayPointer;
382         emit Harvest(msg.sender, reward);
383 
384         return reward;
385     }
386 
387     function harvestRewardAndWithdraw() public returns (uint256, uint256, uint256, uint256) {
388         uint256 reward = harvestReward();
389         uint256 depositMALW = investors[msg.sender].depositMALW;
390         uint256 depositLPETH = investors[msg.sender].depositLPETH;
391         uint256 depositLPUSDT = investors[msg.sender].depositLPUSDT;
392 
393         if (depositMALW > 0) {
394             totalDepositsMALW -= depositMALW;
395             investors[msg.sender].depositMALW = 0;
396             _tokenMALW.transfer(msg.sender, depositMALW);
397         }
398 
399         if (depositLPETH > 0) {
400             totalDepositsLPETH -= depositLPETH;
401             investors[msg.sender].depositLPETH = 0;
402             _tokenLPETH.transfer(msg.sender, depositLPETH);
403         }
404 
405         if (depositLPUSDT > 0) {
406             totalDepositsLPUSDT -= depositLPUSDT;
407             investors[msg.sender].depositLPUSDT = 0;
408             _tokenLPUSDT.transfer(msg.sender, depositLPUSDT);
409         }
410 
411         emit Withdraw(msg.sender, depositMALW, depositLPETH, depositLPUSDT);
412 
413         return (reward, depositMALW, depositLPETH, depositLPUSDT);
414     }
415 
416     function splitSignature(bytes memory sig) internal pure returns (uint8, bytes32, bytes32) {
417         require(sig.length == 65);
418 
419         bytes32 r;
420         bytes32 s;
421         uint8 v;
422 
423         assembly {
424             // first 32 bytes, after the length prefix
425             r := mload(add(sig, 32))
426             // second 32 bytes
427             s := mload(add(sig, 64))
428             // final byte (first byte of the next 32 bytes)
429             v := byte(0, mload(add(sig, 96)))
430         }
431 
432         return (v, r, s);
433     }
434 
435     function recoverSigner(bytes32 message, bytes memory sig) internal pure returns (address) {
436         uint8 v;
437         bytes32 r;
438         bytes32 s;
439 
440         (v, r, s) = splitSignature(sig);
441 
442         return ecrecover(message, v, r, s);
443     }
444 
445     function prefixed(bytes32 hash) internal pure returns (bytes32) {
446         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
447     }
448 
449     function claimMasternodeReward(uint256 amount, uint256 nonce, bytes memory sig) public {
450         require(masternodeRewardsClaimedNonces[nonce] == 0, "This signature is already used");
451 
452         recordHistory();
453 
454         require(amount <= masternodeRewardsBalance, "Insufficient reward funds");
455 
456         bytes32 message = prefixed(keccak256(abi.encodePacked(msg.sender, amount, nonce, address(this))));
457         require(recoverSigner(message, sig) == owner_);
458 
459         masternodeRewardsClaimedNonces[nonce] = amount;
460         _balanceOf[msg.sender] += amount;
461         masternodeRewardsBalance -= amount;
462         emit MasternodeReward(msg.sender, amount, nonce);
463     }
464 
465     function sendFeeFunds(address to, uint256 amount) public onlyOwner {
466         require(feesBalance >= amount, "Insufficient funds");
467 
468         _balanceOf[to] += amount;
469         feesBalance -= amount;
470         emit FeesSpent(to, amount);
471     }
472 }