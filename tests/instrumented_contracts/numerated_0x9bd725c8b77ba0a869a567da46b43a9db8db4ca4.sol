1 /*
2  * Satoshi P2P e-cash paper
3  *
4  * Satoshi Nakamoto
5  * satoshin@gmx.com
6  * www.bitcoin.org
7  *
8  * Abstract:
9  *
10  * A purely decentralized implementation of an Ethereum contract, inspired by 
11  * Bitcoin's peer-to-peer electronic cash system, enables the direct transfer 
12  * of tokens from one party to another without a third-party intermediary. 
13  * Cryptographic methods provide part of the solution, but primary advantages 
14  * are lost if a trusted authority is still needed to manage token supply and 
15  * prevent over-spending.
16  *
17  * We propose a solution to the token supply management using a 
18  * contract-level automated feature. The contract manages the token supply by 
19  * calculating the rewards from a block and applying the "BlockReward" event, 
20  * forming a record that cannot be altered without redoing the reward event. 
21  * The reward event not only serves as evidence of the sequence of operations, 
22  * but also as evidence of the largest pool of token holders. As long as a 
23  * majority of token holders are not cooperating to disrupt the contract, 
24  * they'll validate the longest chain of events and outpace potential adversaries.
25  *
26  * The contract itself requires minimal structure. Transactions are executed 
27  * on a first-come-first-serve basis, and addresses can interact with the 
28  * contract at will, accepting the outcome of the longest chain of events as 
29  * proof of what happened in their absence. In addition, the contract 
30  * periodically contributes tokens to the Satoshi Contribution, effectively 
31  * removing them from the circulating supply. This contributes to the scarcity 
32  * and potentially the value of the token over time, reflecting the spirit of 
33  * Satoshi Nakamoto's vision in the context of an Ethereum contract.
34  * 
35  * https://twitter.com/0xSatoshiETH
36 */
37 
38 pragma solidity 0.8.19;
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address who) external view returns (uint256);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function transfer(address to, uint256 value) external returns (bool);
45     function approve(address spender, uint256 value) external returns (bool);
46     function transferFrom(address from, address to, uint256 value) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 interface InterfaceLP {
52     function sync() external;
53     function mint(address to) external returns (uint liquidity);
54 }
55 
56 abstract contract ERC20Detailed is IERC20 {
57     string private _name;
58     string private _symbol;
59     uint8 private _decimals;
60 
61     constructor(
62         string memory _tokenName,
63         string memory _tokenSymbol,
64         uint8 _tokenDecimals
65     ) {
66         _name = _tokenName;
67         _symbol = _tokenSymbol;
68         _decimals = _tokenDecimals;
69     }
70 
71     function name() public view returns (string memory) {
72         return _name;
73     }
74 
75     function symbol() public view returns (string memory) {
76         return _symbol;
77     }
78 
79     function decimals() public view returns (uint8) {
80         return _decimals;
81     }
82 }
83 
84 interface IDEXRouter {
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87 }
88 
89 interface IDEXFactory {
90     function createPair(address tokenA, address tokenB)
91     external
92     returns (address pair);
93 }
94 
95 contract Ownable {
96     address private _owner;
97 
98     event OwnershipRenounced(address indexed previousOwner);
99 
100     event OwnershipTransferred(
101         address indexed previousOwner,
102         address indexed newOwner
103     );
104 
105     constructor() {
106         _owner = msg.sender;
107     }
108 
109     function owner() public view returns (address) {
110         return _owner;
111     }
112 
113     modifier onlyOwner() {
114         require(msg.sender == _owner, "Not owner");
115         _;
116     }
117 
118     function renounceOwnership() public onlyOwner {
119         emit OwnershipRenounced(_owner);
120         _owner = address(0);
121     }
122 
123     function transferOwnership(address newOwner) public onlyOwner {
124         _transferOwnership(newOwner);
125     }
126 
127     function _transferOwnership(address newOwner) internal {
128         require(newOwner != address(0));
129         emit OwnershipTransferred(_owner, newOwner);
130         _owner = newOwner;
131     }
132 }
133 
134 interface IWETH {
135     function deposit() external payable;
136 }
137 
138 contract Satoshi is ERC20Detailed, Ownable {
139 
140     uint256 public halvingRateNumerator = 810101010;
141     uint256 public halvingRateDenominator = 100000000000;
142 
143     uint256 public blockRewardInterval = 2 hours;
144     uint256 public nextBlockReward;
145     bool public autoBlockReward = true;
146 
147     uint256 public maxTxnAmount;
148     uint256 public maxWallet;
149 
150     uint256 public percentForSatoshi = 50;
151     bool public satoshiEnabled = true;
152     uint256 public satoshiFrequency = 2 hours;
153     uint256 public nextSatoshi;
154 
155     uint256 private constant DECIMALS = 18;
156     uint256 private constant INITIAL_COINS_SUPPLY = 21_000_000 * 10**DECIMALS;
157     uint256 private constant TOTAL_UNITS = type(uint256).max - (type(uint256).max % INITIAL_COINS_SUPPLY);
158     uint256 private constant MIN_SUPPLY = 21 * 10**DECIMALS;
159 
160     event BlockReward(uint256 indexed time, uint256 totalSupply);
161     event RemovedLimits();
162     event SatoshiContribution(uint256 indexed amount);
163 
164     IWETH public immutable weth;
165 
166     IDEXRouter public immutable router;
167     address public immutable pair;
168     
169     bool public limitsInEffect = true;
170     bool public lpAdded = false;
171     
172     uint256 private _totalSupply;
173     uint256 private _unitsPerCoin;
174 
175     mapping(address => uint256) private _unitBalances;
176     mapping(address => mapping(address => uint256)) private _allowedCoins;
177 
178     modifier validRecipient(address to) {
179         require(to != address(0x0));
180         _;
181     }
182 
183     constructor() ERC20Detailed(block.chainid==1 ? "SATOSHI" : "SAT", block.chainid==1 ? "SATS" : "SAT", 18) {
184         address dexAddress;
185         if(block.chainid == 1){
186             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
187         } else if(block.chainid == 5){
188             dexAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
189         } else if (block.chainid == 97){
190             dexAddress = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
191         } else {
192             revert("Chain not configured");
193         }
194 
195         router = IDEXRouter(dexAddress);
196 
197         _totalSupply = INITIAL_COINS_SUPPLY;
198         _unitBalances[address(this)] = TOTAL_UNITS;
199         _unitsPerCoin = TOTAL_UNITS/(_totalSupply);
200 
201         maxTxnAmount = _totalSupply * 1 / 100;
202         maxWallet = _totalSupply * 1 / 100;
203 
204         weth = IWETH(router.WETH());
205         pair = IDEXFactory(router.factory()).createPair(address(this), router.WETH());
206 
207         emit Transfer(address(0x0), address(this), balanceOf(address(this)));
208     }
209 
210     function _msgSender() internal view returns (address payable) {
211         return payable(msg.sender);
212     }
213 
214     function totalSupply() external view override returns (uint256) {
215         return _totalSupply;
216     }
217 
218     function allowance(address owner_, address spender) external view override returns (uint256){
219         return _allowedCoins[owner_][spender];
220     }
221 
222     function balanceOf(address who) public view override returns (uint256) {
223         return _unitBalances[who]/(_unitsPerCoin);
224     }
225 
226     function transfer(address recipient, uint256 amount) public override validRecipient(recipient) returns (bool) {
227         _transferFrom(_msgSender(), recipient, amount);
228         return true;
229     }
230 
231     function approve(address spender, uint256 coins) public override returns (bool) {
232         _allowedCoins[_msgSender()][spender] = coins;
233         emit Approval(_msgSender(), spender, coins);
234         return true;
235     }
236 
237     function transferFrom(address sender, address recipient, uint256 amount) public override validRecipient(recipient) returns (bool) {
238         require(amount <= _allowedCoins[sender][_msgSender()], "Transfer amount exceeds allowance");
239         _allowedCoins[sender][_msgSender()] = _allowedCoins[sender][_msgSender()]-amount;
240         _transferFrom(sender, recipient, amount);
241         return true;
242     }
243 
244     function _transferFrom(address sender, address recipient, uint256 amount) internal {
245         if(limitsInEffect){
246             if (sender == pair || recipient == pair){
247                 require(amount <= maxTxnAmount, "Max Transaction Amount Exceeded");
248             }
249             if (recipient != pair){
250                 require(balanceOf(recipient) + amount <= maxWallet, "Max Wallet Amount Exceeded");
251             }
252         }
253 
254         if(recipient == pair){
255             if(autoBlockReward && shouldReward()){
256                 blockReward();
257             }
258             if (shouldReward()) {
259                 autoSatoshi();
260             }
261         }
262 
263         uint256 unitAmount = amount*(_unitsPerCoin);
264 
265         _unitBalances[sender] = _unitBalances[sender]-(unitAmount);
266         _unitBalances[recipient] = _unitBalances[recipient]+(unitAmount);
267 
268         emit Transfer(sender, recipient, unitAmount/(_unitsPerCoin));
269     }
270 
271         function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool){
272         uint256 oldValue = _allowedCoins[_msgSender()][spender];
273         if (subtractedValue >= oldValue) {
274             _allowedCoins[_msgSender()][spender] = 0;
275         } else {
276             _allowedCoins[_msgSender()][spender] = oldValue - subtractedValue;
277         }
278         emit Approval(_msgSender(), spender, _allowedCoins[_msgSender()][spender]);
279         return true;
280     }
281 
282     function increaseAllowance(address spender, uint256 addedValue) external returns (bool){
283         _allowedCoins[_msgSender()][spender] = _allowedCoins[_msgSender()][spender] + addedValue;
284         emit Approval(_msgSender(), spender, _allowedCoins[_msgSender()][spender]);
285         return true;
286     }
287 
288     function getSupplyDeltaOnNextBlockReward() external view returns (uint256){
289         return (_totalSupply*halvingRateNumerator)/halvingRateDenominator;
290     }
291 
292     function shouldReward() public view returns (bool) {
293         return nextBlockReward <= block.timestamp;
294     }
295 
296     function lpSync() internal {
297         InterfaceLP _pair = InterfaceLP(pair);
298         _pair.sync();
299     }
300 
301     function blockReward() private returns (uint256) {
302         uint256 time = block.timestamp;
303 
304         uint256 supplyDelta = (_totalSupply*halvingRateNumerator)/halvingRateDenominator;
305 
306         nextBlockReward += blockRewardInterval;
307 
308         if (supplyDelta == 0) {
309             emit BlockReward(time, _totalSupply);
310             return _totalSupply;
311         }
312 
313         _totalSupply = _totalSupply - supplyDelta;
314 
315         if (_totalSupply < MIN_SUPPLY) {
316             _totalSupply = MIN_SUPPLY;
317             autoBlockReward = false;
318         }
319 
320         _unitsPerCoin = TOTAL_UNITS / _totalSupply;
321 
322         lpSync();
323 
324         emit BlockReward(time, _totalSupply);
325         return _totalSupply;
326     }
327 
328     function manualBlockReward() external onlyOwner {
329         require(shouldReward(), "Not yet time for block reward");
330         blockReward();
331     }
332 
333     function autoSatoshi() internal {
334         nextSatoshi = block.timestamp + satoshiFrequency;
335 
336         uint256 liquidityPairBalance = balanceOf(pair);
337 
338         uint256 amountToContribute = liquidityPairBalance * percentForSatoshi / 10000;
339 
340         if (amountToContribute > 0) {
341             uint256 unitAmountToContribute = amountToContribute * _unitsPerCoin;
342             _unitBalances[pair] -= unitAmountToContribute;
343             _unitBalances[address(0xdead)] += unitAmountToContribute;
344             emit Transfer(pair, address(0xdead), amountToContribute);
345         }
346 
347         InterfaceLP _pair = InterfaceLP(pair);
348         _pair.sync();
349         emit SatoshiContribution(amountToContribute);
350     }
351 
352     function manualSatoshi() external onlyOwner {
353         require(shouldReward(), "Must wait for cooldown to finish");
354 
355         nextSatoshi = block.timestamp + satoshiFrequency;
356 
357         uint256 liquidityPairBalance = balanceOf(pair);
358 
359         uint256 amountToContribute = liquidityPairBalance * percentForSatoshi / 10000;
360 
361         if (amountToContribute > 0) {
362             uint256 unitAmountToContribute = amountToContribute * _unitsPerCoin;
363             _unitBalances[pair] -= unitAmountToContribute;
364             _unitBalances[address(0xdead)] += unitAmountToContribute;
365             emit Transfer(pair, address(0xdead), amountToContribute);
366         }
367 
368         InterfaceLP _pair = InterfaceLP(pair);
369         _pair.sync();
370         emit SatoshiContribution(amountToContribute);
371     }
372 
373     function genesisBlock(address[] calldata _to) external payable onlyOwner {
374         require(!lpAdded, "LP already added");
375         require(address(this).balance > 0 && balanceOf(address(this)) > 0);
376 
377         uint256 totalDistribution = (_to.length * (INITIAL_COINS_SUPPLY * 3 / 1000));
378         uint256 toDistribute = INITIAL_COINS_SUPPLY * 3 / 1000 * _unitsPerCoin;
379 
380         require(balanceOf(address(this)) >= totalDistribution, "Insufficient balance to distribute");
381 
382         for (uint256 i = 0; i < _to.length; i++) {
383             _unitBalances[_to[i]] += (toDistribute);
384         }
385 
386         weth.deposit{value: address(this).balance}();
387 
388         uint lpBalance = (_unitBalances[address(this)] - (totalDistribution * _unitsPerCoin));
389         _unitBalances[pair] += lpBalance;
390         _unitBalances[address(this)] = 0;
391         emit Transfer(address(this), pair, _unitBalances[pair] / _unitsPerCoin);
392 
393         IERC20(address(weth)).transfer(address(pair), IERC20(address(weth)).balanceOf(address(this)));
394 
395         InterfaceLP(pair).mint(owner());
396         lpAdded = true;
397 
398         nextBlockReward = block.timestamp + blockRewardInterval;
399         nextSatoshi = block.timestamp + satoshiFrequency;
400 
401         //The NY Times 4/07/2023 Israel Launches Biggest Air Attack on West Bank in Nearly Two Decades
402     }
403 
404 }